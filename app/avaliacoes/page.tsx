import { prisma } from "@/lib/prisma";

export default async function AvaliacoesPage() {
  const evaluations = await prisma.evaluation.findMany({
    include: { role: true, collaborator: true },
    orderBy: { createdAt: "desc" },
    take: 50
  });

  return (
    <main>
      <section className="hero">
        <span className="tag">Acompanhamento</span>
        <h1>Avaliacoes registradas</h1>
        <p className="muted">Historico das conversas de evolucao 30/60/90 dias.</p>
      </section>
      <p><a className="button" href="/avaliacoes/nova">Nova avaliacao</a></p>
      {evaluations.map((evaluation) => (
        <article className="card" key={evaluation.id}>
          <h2>{evaluation.role.title} - {evaluation.cycle} dias</h2>
          <p><strong>Colaborador:</strong> {evaluation.collaborator?.name || "Nao informado"}</p>
          <p><strong>Avaliador:</strong> {evaluation.evaluatorName}</p>
          <p><strong>Status:</strong> {evaluation.status}</p>
          <p className="muted">{evaluation.createdAt.toLocaleString("pt-BR")}</p>
        </article>
      ))}
    </main>
  );
}
