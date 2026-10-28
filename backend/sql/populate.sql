-- ─────────────────────────────────────────────
--  DADOS DE EXEMPLO (opcional)
-- ─────────────────────────────────────────────
INSERT INTO categoria_servico (nome, icone_url) VALUES
    ('Eletricidade',  NULL),
    ('Canalização',   NULL),
    ('Pintura',       NULL),
    ('Carpintaria',   NULL),
    ('Limpeza',       NULL);

-- ─────────────────────────────────────────────
    -- OS DADOS A SEREM INSERIDOS
-- ─────────────────────────────────────────────
INSERT INTO utilizador
(nome, email, password_hash, telefone, tipo)
VALUES
('João Silva', 'joao@email.com', 'hash123', '912345678', 'cliente'),
('Ana Costa', 'ana@email.com', 'hash456', '923456789', 'cliente'),
('Carlos Mendes', 'carlos@email.com', 'hash789', '934567890', 'tecnico'),
('Admin ProntoFix', 'admin@prontofix.com', 'hash000', '900000000', 'admin');


INSERT INTO cliente
(utilizador_id, morada, latitude, longitude)
VALUES
(1, 'Rua das Flores, Lisboa', 38.7223, -9.1393),
(2, 'Avenida Central, Porto', 41.1579, -8.6291);



INSERT INTO tecnico
(utilizador_id, especialidade, avaliacao_media, disponivel)
VALUES
(3, 'Eletricista', 4.80, 1);


INSERT INTO pedido
(cliente_id, tecnico_id, categoria_id, descricao, estado, preco_final)
VALUES
(1, 1, 1, 'Tomada da sala deixou de funcionar e precisa de reparação', 'concluido', 50.00),

(2, 1, 2, 'Fuga de água debaixo do lava-loiça', 'em_progresso', 80.00),

(1, NULL, 3, 'Pintura de uma parede do quarto', 'pendente', NULL);


INSERT INTO avaliacao
(pedido_id, cliente_id, tecnico_id, estrelas, comentario)
VALUES
(1, 1, 1, 5, 'Excelente serviço, técnico muito profissional e resolveu o problema rapidamente.');



INSERT INTO notificacao
(utilizador_id, titulo, mensagem, lida)
VALUES
(1, 'Pedido concluído', 'O teu serviço de eletricidade foi concluído com sucesso.', 0),

(3, 'Novo serviço', 'Foi atribuído um novo pedido de eletricidade.', 0),

(2, 'Pedido em progresso', 'O técnico já iniciou o serviço solicitado.', 1);


-- ─────────────────────────────────────────────
DADOS DOS PEDIDOS 
-- ─────────────────────────────────────────────


INSERT INTO pedido
(cliente_id, tecnico_id, categoria_id, descricao, estado, preco_final)
VALUES
(1, 1, 1, 'Tomada da sala deixou de funcionar e precisa de reparação', 'concluido', 50.00);

INSERT INTO pedido
(cliente_id, tecnico_id, categoria_id, descricao, estado, preco_final)
VALUES
(2, 1, 2, 'Fuga de água debaixo do lava-loiça', 'em_progresso', 80.00);


INSERT INTO pedido
(cliente_id, tecnico_id, categoria_id, descricao, estado, preco_final)
VALUES
(1, NULL, 3, 'Pintura de uma parede do quarto', 'pendente', NULL);