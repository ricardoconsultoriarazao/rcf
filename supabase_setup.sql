-- RJLF Gestao - Supabase setup
-- Rode este arquivo no Supabase SQL Editor.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS "Company" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "name" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "Collaborator" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "companyId" TEXT NOT NULL REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "name" TEXT NOT NULL,
  "email" TEXT,
  "roleTitle" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "FunctionRole" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "companyId" TEXT NOT NULL REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "slug" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "area" TEXT,
  "mission" TEXT NOT NULL,
  "principal" TEXT NOT NULL,
  "autonomy" TEXT NOT NULL,
  "responsibilities" JSONB NOT NULL,
  "daily" JSONB NOT NULL,
  "indicators" JSONB NOT NULL,
  "behaviors" JSONB NOT NULL,
  "unacceptable" JSONB NOT NULL,
  "interactions" JSONB NOT NULL,
  "goals30" JSONB NOT NULL,
  "goals60" JSONB NOT NULL,
  "goals90" JSONB NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "FunctionRole_companyId_slug_key" UNIQUE ("companyId", "slug")
);

CREATE TABLE IF NOT EXISTS "Evaluation" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "companyId" TEXT NOT NULL REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "collaboratorId" TEXT REFERENCES "Collaborator"("id") ON DELETE SET NULL ON UPDATE CASCADE,
  "roleId" TEXT NOT NULL REFERENCES "FunctionRole"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "cycle" TEXT NOT NULL,
  "evaluatorName" TEXT NOT NULL,
  "status" TEXT NOT NULL,
  "evidence" TEXT,
  "strengths" TEXT,
  "attention" TEXT,
  "agreements" TEXT,
  "finalQuestion" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "EvaluationAnswer" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "evaluationId" TEXT NOT NULL REFERENCES "Evaluation"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "question" TEXT NOT NULL,
  "intent" TEXT NOT NULL,
  "expected" TEXT NOT NULL,
  "answer" TEXT NOT NULL,
  "score" INTEGER,
  "observation" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "AppUser" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  "companyId" TEXT NOT NULL REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  "name" TEXT NOT NULL,
  "email" TEXT NOT NULL UNIQUE,
  "passwordHash" TEXT NOT NULL,
  "role" TEXT NOT NULL,
  "functionRoleId" TEXT REFERENCES "FunctionRole"("id") ON DELETE SET NULL ON UPDATE CASCADE,
  "collaboratorId" TEXT REFERENCES "Collaborator"("id") ON DELETE SET NULL ON UPDATE CASCADE,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS "Collaborator_companyId_idx" ON "Collaborator"("companyId");
CREATE INDEX IF NOT EXISTS "FunctionRole_companyId_idx" ON "FunctionRole"("companyId");
CREATE INDEX IF NOT EXISTS "Evaluation_companyId_idx" ON "Evaluation"("companyId");
CREATE INDEX IF NOT EXISTS "Evaluation_roleId_idx" ON "Evaluation"("roleId");
CREATE INDEX IF NOT EXISTS "EvaluationAnswer_evaluationId_idx" ON "EvaluationAnswer"("evaluationId");
CREATE INDEX IF NOT EXISTS "AppUser_companyId_idx" ON "AppUser"("companyId");
CREATE INDEX IF NOT EXISTS "AppUser_role_idx" ON "AppUser"("role");

INSERT INTO "Company" ("id", "name")
VALUES ('00000000-0000-4000-8000-000000000001', 'Empresa Modelo RJLF')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'gerente', 'Gerente', 'Gestão Geral', 'Gerir a operação completa da clínica, liderando pessoas, processos, metas comerciais, resultado financeiro, experiência do cliente, conformidade operacional e evolução contínua da unidade.', 'Clínica funcionando com previsibilidade, equipe orientada, metas acompanhadas, caixa controlado, indicadores visíveis e decisões tomadas antes que os problemas se tornem crises.', 'Alta autonomia para conduzir rotina operacional, reuniões, cobrança de metas, organização da equipe e planos de ação. Decisões com impacto financeiro relevante, contratações, desligamentos estratégicos, grandes negociações e exceções comerciais devem ser alinhadas ao proprietário/franqueado.', '["Representar e sustentar o jeito de ser da empresa, transformando cultura em rotina, postura e consequência.","Planejar metas mensais, semanais e diárias de faturamento, recebimento, produtividade, conversão, agenda, vendas internas e resultado financeiro.","Conduzir reuniões de abertura, fechamento, acompanhamento comercial, feedback individual e análise de indicadores.","Gerenciar recrutamento, seleção, admissão, demissão, férias, ponto, escala, treinamentos e desenvolvimento da equipe.","Supervisionar financeiro: caixa, banco, contas a pagar, contas a receber, boletos, notas fiscais, inadimplência, relatórios e fluxo de caixa.","Coordenar comercial, marketing, parcerias externas, campanhas, eventos, resgate de faltantes, eficiência de vendas e aproveitamento de leads.","Garantir manutenção predial, equipamentos, estoque, compras, alvarás, documentação, qualidade e controle de riscos.","Atuar em conflitos, cancelamentos, reclamações, desistências e negociações extraordinárias com clientes."]'::jsonb, '["Abrir o painel de indicadores e verificar agenda, faturamento, recebimentos, pendências financeiras, faltas, comparecimentos, conversões e produtividade.","Fazer alinhamento rápido com coordenadora comercial/prime/equipe técnica para prioridades do dia.","Acompanhar caixa, contas críticas, cobranças prioritárias e movimentação bancária.","Verificar gargalos de agenda, ociosidade, retrabalho, atrasos e falhas de atendimento.","Cobrar planos de ação de vendas, relacionamento, indicação, recompra e retenção.","Registrar decisões, combinados e responsáveis por ação."]'::jsonb, '["Faturamento bruto e líquido","Lucro/resultado operacional","Recebimento e inadimplência","Conversão de avaliação em venda","Comparecimento de agendados","Produtividade por profissional","Ocupação de salas","Ticket médio","Vendas internas","Avaliações/NPS/satisfação","Cancelamentos e distratos","Cumprimento de plano de ação"]'::jsonb, '["Liderança firme e respeitosa","Visão de dono","Decisão orientada por indicadores","Comunicação clara","Disciplina de rotina","Capacidade de cobrança sem agressividade","Postura de solução","Confidencialidade e maturidade emocional"]'::jsonb, '["Ignorar indicadores","Prometer sem registrar ou acompanhar","Ser omisso em conflitos","Transferir responsabilidade sem resolver","Permitir quebra de padrão sem consequência","Tratar equipe ou cliente com julgamento","Perder controle financeiro ou documental"]'::jsonb, '["Proprietário/franqueado","Coordenadora comercial","Prime/recepção","Auxiliar administrativo-financeiro","Nutricionista","Biomédica/esteticista/enfermeira","Marketing/redes sociais","Contabilidade","Fornecedores e prestadores"]'::jsonb, '["Conhecer toda a operação, sistemas, indicadores, equipe e gargalos críticos.","Implantar rotina diária de leitura de indicadores e reunião curta de prioridades.","Mapear riscos financeiros, comerciais e operacionais."]'::jsonb, '["Padronizar reuniões semanais, cobrança de metas, planos de ação e acompanhamento de equipe.","Organizar fluxo de caixa, inadimplência, agenda, produtividade e indicadores comerciais.","Treinar ou realocar responsabilidades críticas."]'::jsonb, '["Operar com previsibilidade de metas, agenda, financeiro e produtividade.","Apresentar plano de melhoria por área, com responsáveis e prazos.","Reduzir dependência do proprietário em decisões rotineiras."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'coordenadora-comercial', 'Coordenadora Comercial', 'Comercial', 'Coordenar a força comercial da clínica, garantindo agenda qualificada, conversão, vendas, parcerias, indicações, campanhas e execução do plano de metas.', 'Metas comerciais batidas com método, agenda cheia, equipe direcionada, parcerias ativas, clientes resgatados e plano de ação em andamento.', 'Autonomia média-alta para organizar rotinas comerciais, distribuir ações, cobrar metas, acompanhar funil e propor campanhas. Descontos fora da política, grandes parcerias e ações com investimento devem ser aprovados pela gerência/proprietário.', '["Desdobrar metas de venda em plano de ação individual por pessoa e por canal.","Acompanhar transformadoras/consultoras e intervir em vendas quando necessário.","Coordenar agendamentos de avaliações, consultorias e transformações.","Analisar faltas, não comparecidos, não convertidos, aniversariantes, indicações e oportunidades de recompra.","Organizar parcerias externas, eventos e ações locais para geração de demanda.","Coordenar postagens e ações comerciais alinhadas à estratégia da marca.","Apoiar gerente na criação de campanhas e na leitura de conversão, ticket médio e eficiência de vendas."]'::jsonb, '["Verificar agenda do dia e do dia seguinte.","Acompanhar leads, agendamentos, comparecimentos, conversões e vendas realizadas.","Fazer reunião curta com consultoras/prime digital para prioridades comerciais.","Cobrar retorno de faltantes, não convertidos e indicações.","Registrar obstáculos e ações corretivas."]'::jsonb, '["Leads recebidos","Agendamentos","Comparecimento","Conversão","Ticket médio","Faturamento por canal","Vendas internas","Parcerias ativas","Indicações","Faltantes resgatados","Não convertidos reativados"]'::jsonb, '["Energia comercial","Foco em meta","Escuta ativa","Capacidade de influência","Organização de funil","Boa comunicação","Coragem para cobrar","Postura colaborativa"]'::jsonb, '["Deixar lead sem retorno","Não acompanhar conversão","Fazer campanha sem medir resultado","Culpar equipe sem plano de ação","Prometer desconto sem regra","Não registrar combinados comerciais"]'::jsonb, '["Gerente","Consultoras","Prime digital","Prime recepção","Nutricionista","Equipe técnica","Marketing/redes sociais","Parceiros externos"]'::jsonb, '["Conhecer metas, funil, carteira, scripts e principais gargalos de conversão.","Implantar controle diário de leads, agenda e comparecimento.","Criar plano de resgate de faltantes e não convertidos."]'::jsonb, '["Aumentar previsibilidade de agenda e qualidade dos leads.","Padronizar reunião comercial e acompanhamento de metas individuais.","Ativar parcerias e rotina de indicações."]'::jsonb, '["Operar funil comercial com métricas claras e plano semanal.","Melhorar conversão, ticket médio e recompras.","Reduzir dependência do gerente na rotina comercial diária."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'consultora-bem-estar-saude', 'Consultora de Bem-Estar e Saúde', 'Comercial / Vendas Consultivas', 'Realizar consultorias de bem-estar e saúde com escuta ativa, acolhimento e venda ética, conectando dores, desejos e objetivos do cliente às soluções adequadas da clínica.', 'Clientes bem atendidos, confiança construída, propostas apresentadas com clareza, conversões realizadas e não convertidos acompanhados com método.', 'Autonomia para conduzir consultorias, apresentar soluções dentro da política comercial e fazer follow-up. Negociações fora da regra, descontos extraordinários e exceções contratuais devem ser aprovados pela coordenação/gerência.', '["Preparar-se antes da consultoria analisando histórico, origem do lead, objetivo declarado e interações anteriores.","Receber o cliente com postura acolhedora, profissional e sem julgamento.","Conduzir diagnóstico consultivo, entendendo objetivo, dores, urgência, histórico e objeções.","Apresentar solução adequada, explicando benefícios, plano, investimento e próximos passos.","Registrar informações relevantes no sistema.","Confirmar agendamentos, reduzir faltas e manter contato com não comparecidos.","Reativar não convertidos com abordagem respeitosa, ofertas e alternativas.","Apoiar vendas de serviços, produtos e tratamentos, mantendo ética e clareza."]'::jsonb, '["Checar agenda de consultorias e preparar cada atendimento.","Enviar lembretes e estímulos aos agendados.","Organizar sala, materiais, degustação e acolhimento.","Realizar consultorias dentro do tempo padrão.","Registrar motivos de perda, objeções e próximos contatos.","Retornar faltantes e não convertidos."]'::jsonb, '["Agendamentos de consultoria","Comparecimento","Conversão","Ticket médio","Valor vendido","Motivos de perda","Reagendamento de faltantes","Reativação de não convertidos","Satisfação do cliente"]'::jsonb, '["Escuta ativa","Empatia sem julgamento","Postura confiante","Comunicação clara","Boa apresentação pessoal","Persistência com elegância","Organização de follow-up","Foco em solução"]'::jsonb, '["Pressionar cliente de forma antiética","Julgar corpo, condição ou histórico do cliente","Deixar não convertido sem retorno","Não registrar informações da consultoria","Prometer resultado impossível","Desrespeitar política comercial"]'::jsonb, '["Coordenadora comercial","Prime digital","Prime recepção","Nutricionista","Equipe técnica","Gerente"]'::jsonb, '["Dominar portfólio, abordagem, scripts, objeções e sistema.","Realizar consultorias acompanhadas e registrar aprendizado.","Implantar rotina de confirmação e follow-up."]'::jsonb, '["Atingir padrão mínimo de conversão e qualidade de atendimento.","Mapear principais objeções e construir respostas consultivas.","Melhorar comparecimento e retomada de não convertidos."]'::jsonb, '["Atuar com autonomia em consultorias e vendas.","Entregar metas de conversão e ticket médio acordadas.","Ser referência em acolhimento, confiança e registro comercial."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'prime', 'Prime / Recepção', 'Atendimento / Experiência do Cliente', 'Garantir uma experiência de chegada, permanência e saída organizada, acolhedora e profissional, conectando cliente, agenda, equipe, caixa e informações da clínica.', 'Recepção funcionando sem ruído, clientes acolhidos, agenda organizada, caixa conferido, mensagens respondidas e pendências encaminhadas.', 'Autonomia para organizar recepção, confirmar agenda, responder dúvidas operacionais e executar rotina de caixa dentro da política. Negociações financeiras, descontos, cancelamentos e exceções devem ser encaminhados à gerência.', '["Recepcionar clientes com cordialidade, sorriso, identificação pelo nome e postura acolhedora.","Operar agenda, confirmações, faltas, remarcações, esperas, finalizações e encaixes.","Atender telefone e WhatsApp com prontidão, clareza e registro.","Operar caixa, receber valores, conferir débitos, anexar comprovantes e fazer fechamento.","Acompanhar sessões pendentes e estimular agendamentos.","Organizar fichas, documentos, recepção, degustações, café/água/chá e materiais.","Direcionar clientes para profissionais e salas, informando tempo de espera.","Apoiar vendas simples de produtos, serviços e reagendamentos."]'::jsonb, '["Conferir agenda e confirmações do dia.","Atualizar status no sistema.","Receber clientes e direcionar atendimentos.","Responder WhatsApp e telefone.","Conferir débitos e movimentação de caixa.","Emitir relatórios de sessões pendentes/faltas.","Manter recepção limpa, organizada e acolhedora."]'::jsonb, '["Tempo de resposta","Taxa de confirmação","Faltas e remarcações","Sessões pendentes","Erros de agenda","Conferência de caixa","Avaliações do atendimento","Vendas simples/reagendamentos"]'::jsonb, '["Cordialidade","Organização","Atenção aos detalhes","Discrição financeira","Comunicação objetiva","Agilidade sem perder cuidado","Senso de prioridade","Postura acolhedora"]'::jsonb, '["Deixar cliente esperando sem informação","Responder com frieza ou impaciência","Errar agenda por falta de conferência","Comentar débitos de forma constrangedora","Não registrar mudanças","Manter recepção desorganizada"]'::jsonb, '["Clientes","Gerente","Coordenadora comercial","Consultoras","Nutricionista","Equipe técnica","Auxiliar financeiro"]'::jsonb, '["Dominar agenda, sistema, fluxo de chegada e fechamento de caixa.","Reduzir atrasos e falhas de comunicação.","Padronizar confirmações e recepção."]'::jsonb, '["Organizar rotina de sessões pendentes, faltantes e remarcações.","Melhorar tempo de resposta e qualidade dos registros.","Atuar com segurança em caixa e atendimento."]'::jsonb, '["Ser referência de experiência do cliente na entrada e saída.","Manter agenda atualizada, caixa sem divergências e recepção impecável.","Apoiar retenção e recompra por meio de relacionamento."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'prime-digital', 'Prime Digital', 'SDR / Atendimento Digital', 'Realizar o primeiro contato com leads digitais e ativos, qualificar necessidades, criar conexão, gerar compromisso de comparecimento e agendar consultorias de bem-estar e saúde.', 'Leads respondidos rápido, qualificados corretamente, agendamentos realizados, comparecimento estimulado e funil digital registrado.', 'Autonomia para responder leads, qualificar, agendar e fazer follow-up dentro do script e da política. Exceções comerciais, promessas de desconto e conflitos devem ser direcionados à coordenação/gerência.', '["Atender leads oriundos de WhatsApp, redes sociais, campanhas, parcerias, urnas e indicações.","Fazer prospecção ativa quando combinado com a gestão.","Entender dor, objetivo e momento do cliente antes de oferecer agenda.","Aplicar scripts com naturalidade, empatia e foco em conversão.","Agendar consultorias e reforçar valor do comparecimento.","Enviar confirmações, lembretes, vídeos e mensagens de estímulo.","Registrar origem, status, objeções e próximos passos no sistema/controle.","Reaquecer leads frios e recuperar oportunidades sem retorno."]'::jsonb, '["Abrir canais digitais e responder pendências.","Priorizar leads novos e quentes.","Qualificar, agendar e confirmar.","Atualizar planilha/CRM/status.","Acionar coordenadora sobre objeções recorrentes.","Fazer follow-up de não respondidos e faltantes."]'::jsonb, '["Volume de leads","Tempo de primeira resposta","Taxa de contato","Agendamentos","Comparecimento","Conversão pós-consultoria","Custo por lead quando houver mídia","Leads sem retorno","Origem dos leads"]'::jsonb, '["Agilidade","Comunicação persuasiva e humana","Disciplina de follow-up","Escuta ativa","Organização de funil","Resiliência","Boa escrita","Energia positiva em áudio/mensagem"]'::jsonb, '["Deixar lead sem resposta","Copiar e colar mensagem fria sem contexto","Não registrar origem/status","Forçar promessa irreal","Responder fora do tom da marca","Perder histórico do cliente"]'::jsonb, '["Coordenadora comercial","Consultoras","Prime recepção","Marketing","Gerente"]'::jsonb, '["Dominar script, canais, origem dos leads e critérios de qualificação.","Implantar rotina de resposta rápida e registro.","Reduzir leads sem retorno."]'::jsonb, '["Melhorar taxa de agendamento e comparecimento.","Criar cadência de reativação de leads.","Mapear objeções e ajustar comunicação com a coordenação."]'::jsonb, '["Operar funil digital com previsibilidade.","Atingir metas de agendamento e comparecimento.","Gerar inteligência sobre canais e qualidade dos leads."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'nutricionista', 'Nutricionista', 'Técnica / Saúde / Retenção', 'Conduzir o Programa Nutricional com ética, segurança, acolhimento e método, garantindo adesão, evolução controlada, orientação individualizada e integração com estética e vendas internas.', 'Clientes acompanhados semanalmente, evolução registrada, adesão sustentada, riscos identificados e pelo menos a meta acordada de clientes dentro da evolução esperada.', 'Autonomia técnica dentro das atribuições do conselho profissional, protocolos e políticas da clínica. Situações clínicas complexas, contraindicações, risco, conflito ou exceção comercial devem ser escaladas ao gestor e/ou responsável técnico conforme o caso.', '["Realizar consulta inicial com anamnese, análise de laudo técnico, mapa do cliente e contraindicações.","Explicar o programa, metas, responsabilidades do cliente, uso do app e próximos passos.","Acompanhar evolução semanal, peso, medidas, registros, dificuldades e mecanismos de defesa.","Realizar retornos obrigatórios e extras quando necessário.","Corrigir uso incorreto do app e incentivar registros diários.","Orientar alimentação, atividade física, estratégias de adesão e alternativas práticas.","Registrar resumo técnico no prontuário e comunicar alertas à equipe.","Estimular avaliações, indicações, retenção e venda interna ética."]'::jsonb, '["Checar agenda, prontuários e clientes fora da meta.","Preparar consultas com base nos registros.","Realizar atendimentos com escuta ativa e orientação clara.","Registrar evolução e próximos combinados.","Comunicar equipe sobre riscos, faltas ou baixa adesão.","Acompanhar relatórios de evolução."]'::jsonb, '["Clientes dentro da meta","Adesão ao app","Retornos realizados no prazo","Faltas nutricionais","Evolução de peso/medidas","Avaliações positivas","Indicações","Vendas internas/retenção","Clientes em alerta clínico"]'::jsonb, '["Ética profissional","Acolhimento","Clareza didática","Firmeza técnica","Escuta ativa","Registro disciplinado","Trabalho em equipe","Atualização contínua"]'::jsonb, '["Atender sem registro","Ignorar contraindicações","Julgar comportamento alimentar","Não comunicar risco à equipe","Prometer resultado sem adesão","Quebrar sigilo profissional","Desvalorizar orientação de outro profissional"]'::jsonb, '["Cliente","Gerente","Consultora","Prime","Biomédica/esteticista/enfermeira","Responsável técnica","Médico/parceiros quando aplicável"]'::jsonb, '["Dominar protocolos, sistema, app, anamnese, laudo e rotina de retorno.","Identificar carteira de clientes em alerta.","Padronizar registro em prontuário."]'::jsonb, '["Aumentar adesão ao app e comparecimento aos retornos.","Melhorar percentual de clientes dentro da meta.","Integrar melhor nutrição, estética e comercial."]'::jsonb, '["Operar agenda nutricional com previsibilidade.","Ser referência técnica em adesão e retenção.","Gerar planos de ação para clientes fora da meta."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'biomedica-esteta', 'Biomédica Esteta', 'Técnica / Estética Avançada', 'Executar procedimentos estéticos com segurança, técnica, acolhimento e foco em resultado, conectando experiência do cliente, evolução corporal/facial e protocolos da clínica.', 'Procedimentos realizados com padrão técnico, salas preparadas, evolução registrada, clientes orientados e oportunidades de retenção/venda interna identificadas.', 'Autonomia para executar procedimentos dentro de sua habilitação, protocolo e agenda. Intercorrências, contraindicações, procedimentos fora do escopo, ajustes de protocolo e reclamações devem ser escalados à responsável técnica/gerência.', '["Checar agenda, salas, equipamentos, insumos e prontuários antes dos atendimentos.","Preparar ambiente limpo, organizado, seguro e acolhedor.","Executar procedimentos corporais e faciais conforme protocolos, habilitação e treinamentos.","Explicar procedimento, benefícios, cuidados e expectativas de forma simples.","Realizar evolução semanal, medidas, fotos, pressão quando aplicável e registros.","Identificar dificuldades de adesão e comunicar nutricionista/coordenação.","Orientar cliente com postura motivadora e sem julgamento.","Apoiar vendas internas, indicações e avaliações quando perceber necessidade real."]'::jsonb, '["Checar agenda e preparar salas.","Conferir equipamentos e insumos.","Executar procedimentos no tempo e padrão definidos.","Registrar evolução e ocorrências.","Organizar sala após cada atendimento.","Sinalizar faltas, riscos, baixa adesão ou necessidade de ajuste."]'::jsonb, '["Procedimentos realizados","Ocupação da agenda","Pontualidade","Evolução registrada","Avaliações do cliente","Vendas internas","Indicações","Retrabalho/intercorrências","Consumo de insumos"]'::jsonb, '["Cuidado técnico","Organização","Empatia","Postura profissional","Comunicação simples","Higiene rigorosa","Proatividade","Trabalho integrado"]'::jsonb, '["Executar procedimento sem preparo ou registro","Ignorar contraindicação","Deixar sala/equipamento desorganizado","Prometer resultado garantido","Comentar corpo do cliente de forma inadequada","Descumprir biossegurança"]'::jsonb, '["Cliente","Nutricionista","Prime","Consultora","Gerente","Responsável técnica","Equipe técnica"]'::jsonb, '["Dominar protocolos, salas, equipamentos, registros e agenda.","Executar atendimentos acompanhados quando necessário.","Padronizar preparo e fechamento de sala."]'::jsonb, '["Atender com autonomia técnica e qualidade percebida.","Melhorar registros de evolução e comunicação com nutrição.","Identificar oportunidades de retenção e indicação."]'::jsonb, '["Ser referência em segurança, experiência e resultado nos procedimentos.","Manter produtividade, satisfação e registro consistente.","Contribuir para vendas internas e fidelização."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'responsavel-tecnica', 'Responsável Técnica', 'Técnica / Compliance', 'Responder tecnicamente pelos serviços, protocolos, biossegurança, documentação, equipe técnica e conformidade sanitária, garantindo atendimento seguro e padronizado.', 'Operação técnica segura, documentada, auditável e alinhada às normas profissionais, sanitárias e aos protocolos internos.', 'Alta autonomia técnica dentro das normas profissionais e sanitárias. Decisões com impacto jurídico, sanitário ou financeiro devem ser comunicadas imediatamente à gerência/proprietário.', '["Garantir cumprimento de protocolos técnicos, biossegurança, registros, termos e prontuários.","Orientar equipe técnica sobre condutas, contraindicações, intercorrências e limites de atuação.","Supervisionar organização de salas, equipamentos, insumos, validade e rastreabilidade.","Apoiar treinamentos técnicos e reciclagens.","Analisar riscos, incidentes, reclamações técnicas e necessidade de encaminhamento.","Manter documentação regulatória e técnica atualizada conforme exigências aplicáveis.","Atuar como referência técnica para gerente e equipe."]'::jsonb, '["Verificar ocorrências técnicas e pendências de registros.","Acompanhar salas, insumos e padrões de biossegurança.","Orientar profissionais diante de dúvidas ou exceções.","Checar se protocolos críticos estão sendo cumpridos.","Registrar correções e treinamentos necessários."]'::jsonb, '["Conformidade de prontuários","Intercorrências","Pendências sanitárias","Treinamentos realizados","Não conformidades técnicas","Reclamações técnicas","Validade de insumos","Auditorias/checklists"]'::jsonb, '["Rigor técnico","Ética","Postura educativa","Atenção a risco","Comunicação clara","Firmeza em limites","Discrição","Responsabilidade legal"]'::jsonb, '["Permitir procedimento fora de habilitação","Ignorar intercorrência","Assinar sem evidência","Não registrar orientação técnica","Flexibilizar biossegurança","Omitir risco ao gestor"]'::jsonb, '["Gerente","Equipe técnica","Nutricionista","Prime","Consultoras","Órgãos reguladores quando aplicável","Fornecedores técnicos"]'::jsonb, '["Mapear protocolos, documentos, riscos e pendências técnicas.","Implantar checklist de conformidade e registros.","Orientar equipe sobre pontos críticos."]'::jsonb, '["Regularizar pendências e treinar equipe em padrões técnicos.","Criar rotina de auditoria de prontuários e salas.","Reduzir falhas de registro e biossegurança."]'::jsonb, '["Manter operação técnica auditável e segura.","Criar plano preventivo de riscos e treinamentos.","Ser referência técnica contínua da unidade."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'esteticista', 'Esteticista', 'Técnica / Estética', 'Executar procedimentos estéticos permitidos à função com cuidado, padrão, higiene, acolhimento e foco na experiência e evolução do cliente.', 'Atendimentos realizados no padrão, salas organizadas, evolução acompanhada, clientes bem orientados e agenda produtiva.', 'Autonomia para executar procedimentos dentro do escopo treinado e autorizado. Intercorrências, dúvidas técnicas, reclamações e contraindicações devem ser encaminhadas à responsável técnica/gerência.', '["Preparar sala, maca, equipamentos e insumos.","Executar procedimentos corporais e faciais dentro do escopo e treinamento.","Explicar o procedimento, benefícios, sensações esperadas e cuidados.","Acompanhar medidas/evolução quando aplicável.","Manter vínculo positivo com cliente, estimulando adesão ao programa.","Comunicar dificuldades, faltas, baixa adesão ou intercorrências à equipe.","Zelar por higiene, organização e conservação dos equipamentos.","Apoiar venda interna e indicação quando houver necessidade real do cliente."]'::jsonb, '["Checar agenda, sala e materiais.","Receber cliente pelo nome e confirmar procedimento.","Executar atendimento com pontualidade.","Registrar evolução e observações.","Organizar sala após atendimento.","Sinalizar necessidades de reposição ou manutenção."]'::jsonb, '["Procedimentos realizados","Ocupação da agenda","Pontualidade","Satisfação do cliente","Evolução registrada","Vendas internas","Indicações","Faltas/reagendamentos"]'::jsonb, '["Acolhimento","Higiene","Organização","Cuidado com detalhes","Comunicação simples","Postura motivadora","Disciplina de registro","Trabalho em equipe"]'::jsonb, '["Atender sem preparo de sala","Descumprir protocolo","Não registrar evolução","Ignorar contraindicação","Falar de forma negativa sobre cliente/equipe","Prometer resultado garantido"]'::jsonb, '["Cliente","Prime","Nutricionista","Biomédica","Responsável técnica","Gerente"]'::jsonb, '["Dominar protocolos, agenda, salas e registros.","Executar procedimentos com supervisão quando necessário.","Padronizar organização e atendimento."]'::jsonb, '["Atender com autonomia e qualidade percebida.","Melhorar evolução e comunicação com equipe.","Contribuir para adesão e retenção."]'::jsonb, '["Manter produtividade e satisfação consistentes.","Ser confiável em rotina, registro e cuidado.","Identificar oportunidades de melhoria de experiência."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'enfermeira-esteta', 'Enfermeira Esteta', 'Técnica / Procedimentos Injetáveis e Estética', 'Realizar procedimentos estéticos compatíveis com a formação e habilitação, com segurança, acolhimento, registro técnico e integração com o plano de cuidado do cliente.', 'Procedimentos executados com segurança, documentação correta, cliente orientado, intercorrências prevenidas e experiência profissional percebida.', 'Autonomia técnica nos procedimentos autorizados pela habilitação, conselho, protocolos e clínica. Situações de risco, intercorrência, procedimento fora do escopo e reclamações devem ser escaladas imediatamente.', '["Avaliar indicação, contraindicação, termo, histórico e prontuário antes do procedimento.","Preparar materiais, sala, assepsia, insumos e descarte conforme biossegurança.","Executar procedimentos permitidos conforme habilitação, protocolo e legislação aplicável.","Explicar benefícios, riscos, cuidados pré e pós-procedimento.","Registrar lote, produto, técnica, áreas, intercorrências e orientações.","Acompanhar retornos, evolução, satisfação e necessidade de ajuste.","Comunicar responsável técnica/gerência em situações de risco, reclamação ou exceção."]'::jsonb, '["Checar agenda, prontuários, termos e materiais.","Preparar sala com padrão de biossegurança.","Realizar atendimento técnico e orientação.","Registrar procedimento completo.","Acompanhar pós-atendimento e pendências."]'::jsonb, '["Procedimentos realizados","Conformidade de termos/prontuários","Retornos realizados","Intercorrências","Satisfação","Reclamações","Consumo/rastreabilidade de insumos","Venda ética de continuidade"]'::jsonb, '["Precisão técnica","Biossegurança","Comunicação calma","Postura profissional","Ética","Registro rigoroso","Acolhimento","Prudência"]'::jsonb, '["Proceder sem termo ou avaliação","Ignorar contraindicação","Omitir intercorrência","Não registrar lote/produto","Prometer resultado absoluto","Atuar fora da habilitação"]'::jsonb, '["Cliente","Responsável técnica","Gerente","Prime","Consultora","Equipe técnica"]'::jsonb, '["Dominar protocolos, termos, registros e fluxo de sala.","Mapear procedimentos autorizados e limites técnicos.","Padronizar pós-atendimento."]'::jsonb, '["Atender com autonomia e documentação impecável.","Reduzir riscos de retrabalho/intercorrência.","Integrar melhor venda consultiva e cuidado técnico."]'::jsonb, '["Ser referência de segurança e experiência em procedimentos avançados.","Manter satisfação, retorno e registro sem falhas.","Contribuir para protocolos e treinamentos internos."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'auxiliar-administrativo-financeiro', 'Auxiliar Administrativo-Financeiro', 'Administrativo / Financeiro / RH', 'Apoiar a gestão administrativa, financeira, de estoque, documentos, compras, cobranças e departamento pessoal, garantindo organização e dados confiáveis para decisão.', 'Rotina financeira e administrativa organizada, caixa conferido, contas controladas, documentos em dia, estoque monitorado e gestor informado.', 'Autonomia para executar rotinas financeiras e administrativas conforme política. Pagamentos, compras relevantes, acordos, distratos, exceções financeiras e decisões de RH devem ser aprovados pelo gerente/proprietário.', '["Auxiliar recrutamento, seleção, documentação, admissões, demissões, férias, atestados, ponto e escala.","Executar contato com contabilidade e envio de documentos.","Realizar abertura/fechamento/conferência de caixa, relatórios financeiros, boletos, notas, contas a pagar e receber.","Atualizar sistema financeiro diariamente e preparar agendamentos bancários.","Organizar recebimentos e cobranças, reportando situações críticas.","Controlar manutenção, prestadores, reparos e compras.","Monitorar estoque de insumos, limpeza, escritório, produtos, uniformes e materiais.","Auxiliar reuniões, relatórios e distratos/rescisões contratuais com clientes."]'::jsonb, '["Conferir caixa e movimentações.","Atualizar contas a pagar/receber e sistema financeiro.","Verificar cobranças e inadimplências.","Organizar documentos para contabilidade/gestão.","Monitorar estoque crítico.","Acompanhar pendências administrativas e prestadores."]'::jsonb, '["Caixa sem divergência","Contas pagas no prazo","Recebíveis acompanhados","Inadimplência","Notas/boletos emitidos","Estoque mínimo","Compras planejadas","Documentos enviados no prazo","Pendências de manutenção"]'::jsonb, '["Organização","Precisão","Confidencialidade","Senso de prazo","Visão sistêmica","Cordialidade","Atenção a detalhe","Proatividade silenciosa"]'::jsonb, '["Atrasar pagamento sem aviso","Lançar informação sem conferência","Expor dados financeiros","Perder comprovantes/documentos","Não reportar inadimplência crítica","Comprar sem aprovação quando exigido"]'::jsonb, '["Gerente","Prime","Contabilidade","Fornecedores","Prestadores","Equipe técnica","Clientes em cobrança/distrato"]'::jsonb, '["Dominar sistemas, caixa, documentos, contas e estoque.","Organizar pendências financeiras e administrativas.","Criar rotina diária de conferência."]'::jsonb, '["Reduzir atrasos, divergências e pendências de documentação.","Implantar controle de estoque e compras recorrentes.","Apoiar cobrança e recebíveis com previsibilidade."]'::jsonb, '["Operar administrativo-financeiro com baixa dependência do gerente.","Entregar relatórios confiáveis e agenda financeira organizada.","Ser ponto de controle de documentos, estoque e obrigações."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'auxiliar-servicos-gerais', 'Auxiliar de Serviços Gerais', 'Apoio Operacional / Limpeza', 'Garantir limpeza, organização, higiene e suporte operacional dos ambientes, contribuindo para segurança, conforto e boa experiência do cliente e da equipe.', 'Clínica limpa, organizada, abastecida, segura e pronta para atendimento durante todo o expediente.', 'Autonomia para executar rotina de limpeza e sinalizar necessidades. Compras, manutenção e mudanças de padrão devem ser aprovadas pelo administrativo/gerente.', '["Limpar recepção, salas, banheiros, copa, áreas comuns e apoio.","Repor materiais de higiene, limpeza, descartáveis e itens de uso comum.","Apoiar organização de salas entre atendimentos quando solicitado.","Sinalizar falta de materiais, manutenção, sujeira crítica ou risco.","Seguir checklist diário e padrões de higiene.","Manter discrição diante de clientes, documentos e conversas internas."]'::jsonb, '["Executar checklist de abertura/limpeza.","Revisar banheiros e recepção ao longo do dia.","Repor materiais.","Organizar copa e áreas comuns.","Descartar resíduos conforme orientação.","Comunicar necessidades ao administrativo/gerência."]'::jsonb, '["Checklist cumprido","Ambientes sem reclamação","Reposição feita no prazo","Ocorrências de limpeza","Materiais críticos sinalizados","Pontualidade"]'::jsonb, '["Discrição","Capricho","Agilidade","Responsabilidade","Atenção a detalhes","Cordialidade","Organização","Compromisso com higiene"]'::jsonb, '["Ignorar sujeira ou risco","Expor conversas internas","Deixar banheiro sem reposição","Misturar produtos de forma insegura","Não avisar falta de material","Circular sem postura profissional"]'::jsonb, '["Prime","Auxiliar administrativo-financeiro","Gerente","Equipe técnica","Clientes de forma cordial e discreta"]'::jsonb, '["Conhecer ambientes, checklist, produtos e horários críticos.","Garantir padrão mínimo diário de limpeza.","Criar hábito de sinalizar materiais e manutenção."]'::jsonb, '["Manter clínica organizada sem necessidade de cobrança constante.","Reduzir falhas de reposição e limpeza.","Apoiar melhor fluxo de salas e recepção."]'::jsonb, '["Ser referência de cuidado e higiene na operação.","Antecipar necessidades de limpeza e material.","Contribuir para experiência premium do cliente."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'fisioterapeuta-dermato-funcional', 'Fisioterapeuta Dermato Funcional', 'Técnica / Fisioterapia Dermato Funcional', 'Avaliar e executar condutas dermato funcionais com foco em segurança, evolução clínica, estética, funcionalidade, adesão e experiência do cliente.', 'Clientes avaliados e tratados com plano técnico coerente, evolução registrada, protocolos seguros e integração com nutrição/estética.', 'Autonomia técnica dentro da habilitação profissional e protocolos. Riscos, intercorrências e exceções devem ser comunicados à responsável técnica/gerência.', '["Realizar avaliação funcional e estética conforme escopo profissional.","Executar procedimentos e terapias permitidos à fisioterapia dermato funcional.","Orientar cuidados, frequência, expectativas e adesão.","Registrar evolução, medidas, fotos e resposta ao tratamento.","Identificar contraindicações, riscos e necessidade de encaminhamento.","Apoiar equipe na correlação entre estética, nutrição e funcionalidade."]'::jsonb, '["Checar agenda e prontuários.","Preparar sala, equipamentos e materiais.","Atender, orientar e registrar.","Acompanhar evolução e comunicar pontos de atenção.","Zelar pela organização e biossegurança."]'::jsonb, '["Procedimentos realizados","Evolução registrada","Adesão ao plano","Satisfação","Faltas/reagendamentos","Intercorrências","Vendas internas/continuidade"]'::jsonb, '["Precisão técnica","Acolhimento","Didática","Organização","Ética","Trabalho em equipe","Cuidado com segurança","Foco em evolução"]'::jsonb, '["Atuar fora do escopo","Não registrar evolução","Ignorar contraindicação","Prometer resultado absoluto","Descuidar de biossegurança","Não comunicar risco"]'::jsonb, '["Cliente","Nutricionista","Biomédica","Esteticista","Gerente","Responsável técnica"]'::jsonb, '["Conhecer protocolos, equipamentos e fluxo de registro.","Mapear principais perfis de cliente e restrições.","Padronizar avaliação e evolução."]'::jsonb, '["Atender com autonomia e consistência técnica.","Melhorar integração com nutrição e estética.","Reduzir faltas e aumentar adesão."]'::jsonb, '["Ser referência em conduta dermato funcional.","Manter satisfação e evolução consistente.","Contribuir para planos integrados e retenção."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'transformadora', 'Transformadora', 'Comercial / Avaliação Inicial', 'Conduzir a transformação/avaliação inicial, conectando o desejo do cliente aos dados, à necessidade de mudança e ao plano de solução da clínica.', 'Avaliações bem conduzidas, cliente consciente do problema e do caminho, dados registrados e oportunidade comercial entregue com qualidade à consultora/coordenadora.', 'Autonomia para conduzir avaliação dentro do protocolo. Negociação comercial, diagnóstico técnico fora do escopo e situações sensíveis devem ser encaminhados à consultora/nutricionista/gerência.', '["Receber o cliente para avaliação com acolhimento e escuta ativa.","Coletar dados, medidas, informações de objetivo, histórico, dores e expectativas.","Aplicar instrumentos de avaliação conforme padrão.","Explicar dados de forma simples, sem julgamento e com foco em solução.","Preparar cliente para a consultoria/venda com consciência de valor.","Registrar informações críticas e sinalizar perfil, objeções e oportunidades."]'::jsonb, '["Checar avaliações agendadas.","Preparar sala, equipamentos e materiais.","Realizar avaliação e registro.","Comunicar consultora sobre perfil e pontos relevantes.","Organizar sala e documentos."]'::jsonb, '["Avaliações realizadas","Comparecimento","Qualidade do registro","Conversão pós-avaliação","Tempo de atendimento","Satisfação inicial","Indicações geradas"]'::jsonb, '["Acolhimento","Didática","Energia positiva","Discrição","Organização","Escuta sem julgamento","Cuidado com dados pessoais","Foco em solução"]'::jsonb, '["Constranger cliente","Usar dados para julgamento","Não registrar informações","Atrasar avaliação","Prometer resultado","Criar medo em vez de consciência"]'::jsonb, '["Consultora","Coordenadora comercial","Nutricionista","Prime","Gerente"]'::jsonb, '["Dominar instrumentos, roteiro e registros da avaliação.","Aprender a comunicar dados com acolhimento.","Padronizar passagem de informações à consultora."]'::jsonb, '["Melhorar qualidade das avaliações e conexão com o cliente.","Reduzir falhas de registro.","Apoiar aumento de conversão."]'::jsonb, '["Ser referência em avaliação inicial.","Gerar consciência, confiança e base para venda consultiva.","Manter alto padrão de experiência inicial."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'redes-sociais-clinica', 'Responsável por Redes Sociais da Clínica', 'Marketing / Conteúdo Local', 'Planejar, produzir e organizar conteúdos locais que fortaleçam autoridade, relacionamento, prova social e geração de demanda para a clínica.', 'Redes sociais atualizadas com conteúdo alinhado à marca, rotina da clínica, campanhas, provas sociais e chamadas para agendamento.', 'Autonomia para propor pautas e executar conteúdos aprovados. Campanhas, ofertas, uso de imagem de cliente e temas sensíveis devem seguir aprovação da gestão e regras da marca.', '["Planejar calendário de conteúdo alinhado às campanhas e metas comerciais.","Produzir registros de bastidores, equipe, tratamentos, depoimentos e provas sociais permitidas.","Garantir linguagem, imagem e postura compatíveis com a marca.","Apoiar divulgação de ofertas, eventos, parcerias e ações locais.","Interagir com comentários e mensagens conforme alinhamento com Prime Digital.","Organizar banco de imagens, autorizações e materiais.","Medir alcance, engajamento, mensagens geradas e leads."]'::jsonb, '["Verificar calendário e demandas de conteúdo.","Captar imagens/vídeos da rotina com autorização.","Publicar ou programar conteúdos.","Sinalizar oportunidades de pauta.","Acompanhar comentários, mensagens e métricas básicas."]'::jsonb, '["Publicações realizadas","Alcance","Engajamento","Mensagens recebidas","Leads gerados","Cliques/agendamentos","Provas sociais coletadas","Regularidade de postagem"]'::jsonb, '["Criatividade com critério","Organização","Senso estético","Cuidado com imagem","Agilidade","Respeito à privacidade","Comunicação leve","Foco comercial"]'::jsonb, '["Publicar cliente sem autorização","Prometer resultado proibido","Usar imagem desalinhada à marca","Abandonar calendário","Responder de forma informal demais","Divulgar informação sensível"]'::jsonb, '["Coordenadora comercial","Prime digital","Gerente","Equipe técnica","Clientes autorizados"]'::jsonb, '["Organizar calendário, identidade visual e banco de conteúdos.","Mapear campanhas e principais serviços.","Implantar rotina de captação."]'::jsonb, '["Publicar com regularidade e medir métricas básicas.","Gerar mais mensagens/leads qualificados.","Aumentar provas sociais e bastidores relevantes."]'::jsonb, '["Criar presença local consistente e alinhada ao comercial.","Transformar conteúdo em agenda e autoridade.","Manter fluxo de conteúdo sem depender de improviso."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'estagiaria', 'Estagiária', 'Apoio Operacional / Aprendizagem', 'Apoiar rotinas operacionais, administrativas ou técnicas conforme formação e supervisão, aprendendo padrões da clínica e contribuindo para organização e atendimento.', 'Demandas de apoio executadas com atenção, aprendizado contínuo, registros corretos e respeito aos limites de atuação do estágio.', 'Baixa a média, conforme maturidade e escopo do estágio. Atividades críticas devem ser supervisionadas e validadas.', '["Apoiar atendimento, organização, registros e preparação de materiais conforme orientação.","Observar e aprender fluxos, protocolos, linguagem e padrões da clínica.","Executar tarefas compatíveis com estágio e supervisão.","Comunicar dúvidas, erros e dificuldades rapidamente.","Manter postura profissional, ética e cordial com clientes e equipe."]'::jsonb, '["Receber prioridades do supervisor.","Apoiar organização de materiais e ambientes.","Executar tarefas administrativas ou operacionais permitidas.","Registrar aprendizados e dúvidas.","Solicitar validação antes de atividades críticas."]'::jsonb, '["Tarefas concluídas","Pontualidade","Aprendizado demonstrado","Erros reduzidos","Feedback do supervisor","Organização de materiais"]'::jsonb, '["Curiosidade","Humildade para aprender","Atenção","Pontualidade","Cordialidade","Responsabilidade","Comunicação de dúvida","Respeito a limites"]'::jsonb, '["Atuar sem supervisão quando exigido","Omitir erro","Assumir promessa ao cliente","Desrespeitar sigilo","Executar procedimento fora do escopo","Falta de pontualidade recorrente"]'::jsonb, '["Supervisor direto","Prime","Equipe técnica","Gerente","Clientes em apoio"]'::jsonb, '["Conhecer áreas, rotina, regras de postura e limites de atuação.","Executar tarefas simples com segurança.","Criar rotina de feedback com supervisor."]'::jsonb, '["Assumir tarefas recorrentes de apoio com menor dependência.","Demonstrar evolução em organização e comunicação.","Reduzir erros operacionais."]'::jsonb, '["Contribuir para fluxo da clínica com autonomia proporcional.","Estar preparada para novas responsabilidades.","Manter padrão profissional consistente."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

INSERT INTO "FunctionRole" ("companyId", "slug", "title", "area", "mission", "principal", "autonomy", "responsibilities", "daily", "indicators", "behaviors", "unacceptable", "interactions", "goals30", "goals60", "goals90")
VALUES ('00000000-0000-4000-8000-000000000001', 'vigia', 'Vigia', 'Segurança Patrimonial / Apoio', 'Zelar pela segurança patrimonial, controle de acesso, observação preventiva e apoio ao funcionamento seguro da unidade.', 'Ambiente monitorado, acessos observados, riscos comunicados e rotina de segurança cumprida com discrição.', 'Autonomia para observar, orientar acessos simples e comunicar riscos. Situações de conflito, ameaça ou decisão crítica devem ser escaladas ao responsável e autoridades quando necessário.', '["Controlar entrada e saída conforme orientação da unidade.","Observar movimentações suspeitas e comunicar responsáveis.","Apoiar abertura/fechamento conforme procedimento.","Zelar por patrimônio, portas, luzes, equipamentos e ocorrências externas.","Manter postura discreta, cordial e preventiva.","Registrar ou comunicar ocorrências relevantes."]'::jsonb, '["Conferir pontos de acesso.","Observar movimentação de clientes, equipe e entorno.","Apoiar abertura/fechamento.","Comunicar ocorrências imediatamente.","Manter-se atento e disponível."]'::jsonb, '["Ocorrências registradas","Falhas de acesso","Pontualidade","Comunicações preventivas","Checklists de abertura/fechamento","Incidentes evitados"]'::jsonb, '["Atenção constante","Discrição","Cordialidade","Responsabilidade","Prontidão","Calma","Comunicação objetiva","Postura preventiva"]'::jsonb, '["Abandonar posto","Dormir em serviço","Tratar cliente de forma rude","Omitir ocorrência","Permitir acesso indevido","Comentar assuntos internos"]'::jsonb, '["Gerente","Prime","Auxiliar administrativo","Equipe","Clientes/visitantes"]'::jsonb, '["Conhecer rotina, acessos, horários e responsáveis.","Aprender procedimentos de abertura/fechamento.","Criar padrão de comunicação de ocorrências."]'::jsonb, '["Atuar preventivamente com menor supervisão.","Reduzir falhas de acesso e comunicação.","Manter presença discreta e segura."]'::jsonb, '["Ser referência de segurança e confiança operacional.","Antecipar riscos e apoiar fechamento/abertura com consistência.","Manter registros e comunicação preventiva."]'::jsonb)
ON CONFLICT ("companyId", "slug") DO UPDATE SET
  "title" = EXCLUDED."title",
  "area" = EXCLUDED."area",
  "mission" = EXCLUDED."mission",
  "principal" = EXCLUDED."principal",
  "autonomy" = EXCLUDED."autonomy",
  "responsibilities" = EXCLUDED."responsibilities",
  "daily" = EXCLUDED."daily",
  "indicators" = EXCLUDED."indicators",
  "behaviors" = EXCLUDED."behaviors",
  "unacceptable" = EXCLUDED."unacceptable",
  "interactions" = EXCLUDED."interactions",
  "goals30" = EXCLUDED."goals30",
  "goals60" = EXCLUDED."goals60",
  "goals90" = EXCLUDED."goals90";

