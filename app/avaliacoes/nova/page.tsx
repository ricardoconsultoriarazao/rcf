import { prisma } from "@/lib/prisma";
import { getCurrentUser } from "@/lib/auth";
import { redirect } from "next/navigation";
import AvaliacaoForm from "./AvaliacaoForm";

export default async function NovaAvaliacaoPage({ searchParams }: { searchParams: { roleId?: string } }) {
  const current = await getCurrentUser();
  if (!current) redirect("/login");
  if (current?.role === "COLABORADOR") redirect("/meu-rcf");

  const roles = await prisma.functionRole.findMany({
    orderBy: [{ title: "asc" }]
  });
  const serializedRoles = roles.map((role) => ({
    id: role.id,
    title: role.title,
    area: role.area,
    mission: role.mission,
    principal: role.principal,
    autonomy: role.autonomy,
    responsibilities: role.responsibilities,
    daily: role.daily,
    indicators: role.indicators,
    behaviors: role.behaviors,
    unacceptable: role.unacceptable,
    interactions: role.interactions,
    goals30: role.goals30,
    goals60: role.goals60,
    goals90: role.goals90
  }));

  return (
    <main>
      <section className="hero">
        <span className="tag">30/60/90 dias</span>
        <h1>Nova avaliacao de evolucao</h1>
        <p className="muted">Selecione o RCF para o sistema orientar o gestor sobre o que deve aparecer nas respostas.</p>
      </section>
      <AvaliacaoForm roles={serializedRoles} selectedRoleId={searchParams.roleId} />
    </main>
  );
}
