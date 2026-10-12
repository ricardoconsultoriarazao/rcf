import "./globals.css";

export const metadata = {
  title: "RJLF Gestao",
  description: "Sistema interno RJLF Consultoria"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>
        <header className="topbar">
          <div className="wrap">
            <div className="brand">RJLF Consultoria</div>
            <div className="subtitle">Sistema interno de RCFs e Avaliacao 30/60/90</div>
            <nav className="nav">
              <a href="/">Dashboard</a>
              <a href="/funcoes">RCFs</a>
              <a href="/avaliacoes">Avaliacoes</a>
              <a href="/avaliacoes/nova">Nova avaliacao</a>
            </nav>
          </div>
        </header>
        {children}
      </body>
    </html>
  );
}
