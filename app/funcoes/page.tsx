import { prisma } from "@/lib/prisma";

export default async function FuncoesPage() {
  const roles = await prisma.functionRole.findMany({
    orderBy: [{ area: "asc" }, { title: "asc" }]
  });

  return (
    <main>
      <section className="hero">
        <span className="tag">RCF</span>
        <h1>Responsabilidades Chave por Funcao</h1>
        <p className="muted">Lista inicial carregada a partir dos documentos consolidados.</p>
      </section>
      <section className="list">
        {roles.map((role) => (
          <article className="card" key={role.id}>
            <h2>{role.title}</h2>
            <p className="muted">{role.area}</p>
            <p>{role.principal}</p>
            <a className="button secondary" href={`/funcoes/${role.id}`}>Abrir RCF</a>
          </article>
        ))}
      </section>
    </main>
  );
}
