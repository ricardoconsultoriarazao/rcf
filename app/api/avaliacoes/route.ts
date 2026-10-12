import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { cookies } from "next/headers";

const DEFAULT_COMPANY_ID = "00000000-0000-4000-8000-000000000001";

export async function POST(request: Request) {
  try {
    const token = cookies().get("rjlf_session")?.value;
    const expected = process.env.CONSULTANT_SESSION_TOKEN || "local-dev-token";
    if (token !== expected) {
      return NextResponse.json({ error: "Nao autorizado." }, { status: 401 });
    }

    const body = await request.json();
    if (!body.roleId || !body.cycle || !body.evaluatorName || !body.collaboratorName) {
      return NextResponse.json({ error: "Campos obrigatorios ausentes." }, { status: 400 });
    }

    const role = await prisma.functionRole.findUnique({ where: { id: body.roleId } });
    if (!role) return NextResponse.json({ error: "RCF nao encontrado." }, { status: 404 });

    const collaborator = await prisma.collaborator.create({
      data: {
        companyId: DEFAULT_COMPANY_ID,
        name: body.collaboratorName,
        email: body.collaboratorEmail || null,
        roleTitle: role.title
      }
    });

    const evaluation = await prisma.evaluation.create({
      data: {
        companyId: DEFAULT_COMPANY_ID,
        collaboratorId: collaborator.id,
        roleId: role.id,
        cycle: body.cycle,
        evaluatorName: body.evaluatorName,
        status: body.status || "Em desenvolvimento",
        evidence: body.evidence || null,
        strengths: body.strengths || null,
        attention: body.attention || null,
        agreements: body.agreements || null,
        finalQuestion: body.finalQuestion || null,
        answers: {
          create: (body.answers || []).map((answer: any) => ({
            question: answer.question,
            intent: answer.intent,
            expected: answer.expected,
            answer: answer.answer || "",
            score: answer.score,
            observation: answer.observation || null
          }))
        }
      }
    });

    return NextResponse.json({ id: evaluation.id });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: "Erro ao salvar avaliacao." }, { status: 500 });
  }
}
