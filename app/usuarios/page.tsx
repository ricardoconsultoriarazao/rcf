import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { prisma } from "@/lib/prisma";
import { getCurrentUser, hashPassword } from "@/lib/auth";

async function createUser(formData: FormData) {
  "use server";

  const current = await getCurrentUser();
  if (current?.role !== "CONSULTOR") redirect("/");

  const name = String(formData.get("name") || "").trim();
  const email = String(formData.get("email") || "").trim().toLowerCase();
  const password = String(formData.get("password") || "");
  const role = String(formData.get("role") || "COLABORADOR");
  const functionRoleId = String(formData.get("functionRoleId") || "") || null;

  if (!name || !email || password.length < 6) redirect("/usuarios?erro=1");

  const company = await prisma.company.findFirst({ orderBy: { createdAt: "asc" } });
  if (!company) redirect("/usuarios?erro=empresa");

  const functionRole = functionRoleId
    ? await prisma.functionRole.findUnique({ where: { id: functionRoleId } })
    : null;

  const collaborator = role === "COLABORADOR"
    ? await prisma.collaborator.create({
        data: {
          companyId: company.id,
          name,
          email,
          roleTitle: functionRole?.title || null
        }
      })
    : null;

  await prisma.appUser.create({
    data: {
      companyId: company.id,
      name,
      email,
      passwordHash: hashPassword(password),
      role,
      functionRoleId,
      collaboratorId: collaborator?.id || null
    }
  });

  revalidatePath("/usuarios");
  redirect("/usuarios?sucesso=1");
}

async function toggleUser(formData: FormData) {
  "use server";

  const current = await getCurrentUser();
  if (current?.role !== "CONSULTOR") redirect("/");

  const id = String(formData.get("id") || "");
  const active = String(formData.get("active") || "") === "true";
  if (id) {
    await prisma.appUser.update({ where: { id }, data: { active: !active } });
    revalidatePath("/usuarios");
  }
}

export default async function UsuariosPage({ searchParams }: { searchParams: { erro?: string; sucesso?: string } }) {
  const current = await getCurrentUser();
  if (current?.role !== "CONSULTOR") redirect("/");

  const [users, roles] = await Promise.all([
    prisma.appUser.findMany({
      include: { functionRole: true },
      orderBy: [{ active: "desc" }, { createdAt: "desc" }]
    }),
    prisma.functionRole.findMany({ orderBy: [{ area: "asc" }, { title: "asc" }] })
  ]);

  return (
    <main>
      <section className="hero">
        <span className="tag">Acessos</span>
        <h1>Usuarios do sistema</h1>
        <p className="muted">Crie acessos para avaliadores e colaboradores. Colaboradores veem apenas o RCF vinculado ao proprio usuario.</p>
      </section>

      {searchParams.sucesso ? <p className="success">Usuario criado com sucesso.</p> : null}
      {searchParams.erro ? <p className="error">Confira nome, e-mail e senha com pelo menos 6 caracteres.</p> : null}

      <section className="panel">
        <h2>Novo usuario</h2>
        <form action={createUser} className="grid">
          <div>
            <label>Nome</label>
            <input name="name" required />
          </div>
          <div>
            <label>E-mail</label>
            <input name="email" type="email" required />
          </div>
          <div>
            <label>Senha inicial</label>
            <input name="password" type="password" minLength={6} required />
          </div>
          <div>
            <label>Perfil</label>
            <select name="role" defaultValue="COLABORADOR">
              <option value="COLABORADOR">Colaborador</option>
              <option value="AVALIADOR">Avaliador</option>
              <option value="CONSULTOR">Consultor</option>
            </select>
          </div>
          <div className="grid-span">
            <label>RCF vinculado ao colaborador</label>
            <select name="functionRoleId">
              <option value="">Sem RCF especifico</option>
              {roles.map((role) => (
                <option key={role.id} value={role.id}>{role.title} - {role.area}</option>
              ))}
            </select>
            <p className="muted">Use este campo principalmente para colaborador. O acesso dele sera limitado ao RCF escolhido.</p>
          </div>
          <div>
            <button type="submit">Criar usuario</button>
          </div>
        </form>
      </section>

      <section className="panel">
        <h2>Usuarios cadastrados</h2>
        <div className="table">
          <div className="table-row table-head">
            <span>Nome</span>
            <span>E-mail</span>
            <span>Perfil</span>
            <span>RCF</span>
            <span>Status</span>
            <span>Acao</span>
          </div>
          {users.map((user) => (
            <div className="table-row" key={user.id}>
              <span>{user.name}</span>
              <span>{user.email}</span>
              <span>{user.role}</span>
              <span>{user.functionRole?.title || "-"}</span>
              <span>{user.active ? "Ativo" : "Inativo"}</span>
              <form action={toggleUser}>
                <input type="hidden" name="id" value={user.id} />
                <input type="hidden" name="active" value={String(user.active)} />
                <button className="secondary" type="submit">{user.active ? "Inativar" : "Ativar"}</button>
              </form>
            </div>
          ))}
        </div>
      </section>
    </main>
  );
}
