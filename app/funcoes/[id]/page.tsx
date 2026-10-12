import { prisma } from "@/lib/prisma";
import { getCurrentUser } from "@/lib/auth";
import { notFound, redirect } from "next/navigation";

function List({ items }: { items: unknown }) {
  const list = Array.isArray(items) ? items : [];
  return <ul>{list.map((item, index) => <li key={index}>{String(item)}</li>)}</ul>;
}

export default async function FuncaoPage({ params }: { params: { id: string } }) {
  const current = await getCurrentUser();
  if (!current) redirect("/login");
  if (current?.role === "COLABORADOR" && current.functionRoleId !== params.id) redirect("/meu-rcf");

  const role = await prisma.functionRole.findUnique({ where: { id: params.id } });
  if (!role) notFound();

  return (
    <main>
      <section className="hero">
        <span className="tag">{role.area}</span>
        <h1>{role.title}</h1>
        <p>{role.mission}</p>
      </section>

      <section className="grid">
        <div className="card">
          <h2>Resultado principal esperado</h2>
          <p>{role.principal}</p>
        </div>
        <div className="card">
          <h2>Autonomia</h2>
          <p>{role.autonomy}</p>
        </div>
      </section>

      <section className="panel"><h2>Responsabilidades-chave</h2><List items={role.responsibilities} /></section>
      <section className="panel"><h2>Atividades do dia a dia</h2><List items={role.daily} /></section>
      <section className="panel"><h2>Indicadores</h2><List items={role.indicators} /></section>
      <section className="grid">
        <div className="panel"><h2>Comportamentos esperados</h2><List items={role.behaviors} /></div>
        <div className="panel"><h2>Comportamentos inaceitaveis</h2><List items={role.unacceptable} /></div>
      </section>
      <section className="panel"><h2>Interfaces internas e externas</h2><List items={role.interactions} /></section>
      <section className="grid-3">
        <div className="panel"><h2>30 dias</h2><List items={role.goals30} /></div>
        <div className="panel"><h2>60 dias</h2><List items={role.goals60} /></div>
        <div className="panel"><h2>90 dias</h2><List items={role.goals90} /></div>
      </section>
      <p><a className="button" href={`/avaliacoes/nova?roleId=${role.id}`}>Avaliar esta funcao</a></p>
    </main>
  );
}
