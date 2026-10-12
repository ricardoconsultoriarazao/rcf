import { prisma } from "@/lib/prisma";
import { getCurrentUser } from "@/lib/auth";
import { redirect } from "next/navigation";

export default async function DashboardPage() {
  const current = await getCurrentUser();
  if (!current) redirect("/login");
  if (current?.role === "COLABORADOR") redirect("/meu-rcf");

  const [companies, roles, evaluations, users] = await Promise.all([
    prisma.company.count(),
    prisma.functionRole.count(),
    prisma.evaluation.count(),
    prisma.appUser.count()
  ]);

  return (
    <main>
      <section className="hero">
        <span className="tag">Gestao empresarial</span>
        <h1>Dashboard RJLF</h1>
        <p className="muted">
          Ambiente local para organizar RCFs, conduzir avaliacoes 30/60/90 dias e registrar evidencias de evolucao.
        </p>
      </section>

      <section className="grid-3">
        <div className="card">
          <h2>{companies}</h2>
          <p>Empresas cadastradas</p>
        </div>
        <div className="card">
          <h2>{roles}</h2>
          <p>RCFs carregados</p>
        </div>
        <div className="card">
          <h2>{evaluations}</h2>
          <p>Avaliacoes registradas</p>
        </div>
        <div className="card">
          <h2>{users}</h2>
          <p>Usuarios cadastrados</p>
        </div>
      </section>

      <section className="panel">
        <h2>Proximas acoes</h2>
        <p><a className="button" href="/funcoes">Ver RCFs</a> <a className="button secondary" href="/avaliacoes/nova">Criar avaliacao</a> <a className="button secondary" href="/usuarios">Criar usuarios</a></p>
      </section>
    </main>
  );
}
