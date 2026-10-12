const { PrismaClient } = require("@prisma/client");
const fs = require("fs");
const path = require("path");

const prisma = new PrismaClient();

async function main() {
  const company = await prisma.company.upsert({
    where: { id: "00000000-0000-4000-8000-000000000001" },
    update: {},
    create: {
      id: "00000000-0000-4000-8000-000000000001",
      name: "Empresa Modelo RJLF"
    }
  });

  const file = path.join(process.cwd(), "data", "rcfs_consolidados.json");
  const roles = JSON.parse(fs.readFileSync(file, "utf8"));

  for (const role of roles) {
    await prisma.functionRole.upsert({
      where: {
        companyId_slug: {
          companyId: company.id,
          slug: role.slug
        }
      },
      update: {
        title: role.title,
        area: role.area,
        mission: role.mission,
        principal: role.principal,
        autonomy: role.autonomy,
        responsibilities: role.responsibilities || [],
        daily: role.daily || [],
        indicators: role.indicators || [],
        behaviors: role.behaviors || [],
        unacceptable: role.unacceptable || [],
        interactions: role.interactions || [],
        goals30: role.goals30 || [],
        goals60: role.goals60 || [],
        goals90: role.goals90 || []
      },
      create: {
        companyId: company.id,
        slug: role.slug,
        title: role.title,
        area: role.area,
        mission: role.mission,
        principal: role.principal,
        autonomy: role.autonomy,
        responsibilities: role.responsibilities || [],
        daily: role.daily || [],
        indicators: role.indicators || [],
        behaviors: role.behaviors || [],
        unacceptable: role.unacceptable || [],
        interactions: role.interactions || [],
        goals30: role.goals30 || [],
        goals60: role.goals60 || [],
        goals90: role.goals90 || []
      }
    });
  }

  console.log(`Seed concluido: ${roles.length} RCFs carregados.`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
