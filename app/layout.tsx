import "./globals.css";
import { getCurrentUser } from "@/lib/auth";

export const metadata = {
  title: "RJLF Gestao",
  description: "Sistema interno RJLF Consultoria"
};

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const user = await getCurrentUser().catch(() => null);
  const isConsultant = user?.role === "CONSULTOR";
  const isCollaborator = user?.role === "COLABORADOR";

  return (
    <html lang="pt-BR">
      <body>
        <header className="topbar">
          <div className="wrap">
            <div className="brand">RJLF Consultoria</div>
            <div className="subtitle">Sistema interno de RCFs e Avaliacao 30/60/90</div>
            <nav className="nav">
              {!isCollaborator ? <a href="/">Dashboard</a> : null}
              {!isCollaborator ? <a href="/funcoes">RCFs</a> : null}
              {!isCollaborator ? <a href="/avaliacoes">Avaliacoes</a> : null}
              {!isCollaborator ? <a href="/avaliacoes/nova">Nova avaliacao</a> : null}
              {isConsultant ? <a href="/usuarios">Usuarios</a> : null}
              {isCollaborator ? <a href="/meu-rcf">Meu RCF</a> : null}
              {user ? <a href="/logout">Sair</a> : null}
            </nav>
          </div>
        </header>
        {children}
      </body>
    </html>
  );
}
