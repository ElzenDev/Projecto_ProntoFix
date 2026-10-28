-- ============================================================
--  ProntoFix — Base de Dados MySQL
--  Grupo 04 · Dispositivos Móveis · IADE / Universidade Europeia
--  2025-2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS prontofix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE prontofix;

-- ─────────────────────────────────────────────
--  1. utilizador
--     Entidade base de todos os utilizadores.
--     tipo: 'cliente' | 'tecnico' | 'admin'
-- ─────────────────────────────────────────────
CREATE TABLE utilizador (
    id            INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(120)    NOT NULL,
    email         VARCHAR(180)    NOT NULL UNIQUE,
    password_hash VARCHAR(255)    NOT NULL,
    telefone      VARCHAR(20)         NULL,           -- o  (opcional)
    tipo          ENUM('cliente','tecnico','admin') NOT NULL,
    criado_em     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

-- ─────────────────────────────────────────────
--  2. cliente
--     Especialização de utilizador (1:1 opcional).
--     utilizador_id → utilizador.id
-- ─────────────────────────────────────────────
CREATE TABLE cliente (
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    utilizador_id  INT UNSIGNED NOT NULL UNIQUE,      -- *  FK → utilizador
    morada         VARCHAR(255)     NULL,              -- o
    latitude       DECIMAL(9,6)     NULL,              -- o
    longitude      DECIMAL(9,6)     NULL,              -- o

    PRIMARY KEY (id),
    CONSTRAINT fk_cliente_utilizador
        FOREIGN KEY (utilizador_id) REFERENCES utilizador(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
--  3. tecnico
--     Especialização de utilizador (1:1 opcional).
--     utilizador_id → utilizador.id
-- ─────────────────────────────────────────────
CREATE TABLE tecnico (
    id               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    utilizador_id    INT UNSIGNED NOT NULL UNIQUE,    -- *  FK → utilizador
    especialidade    VARCHAR(100) NOT NULL,            -- *
    avaliacao_media  DECIMAL(3,2)     NULL,            -- o  (0.00 a 5.00)
    disponivel       TINYINT(1)   NOT NULL DEFAULT 1,  -- *
    foto_url         VARCHAR(500)     NULL,            -- o

    PRIMARY KEY (id),
    CONSTRAINT fk_tecnico_utilizador
        FOREIGN KEY (utilizador_id) REFERENCES utilizador(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
--  4. categoria_servico
--     Tipos de serviço disponíveis (ex: Eletricidade, Canalização).
-- ─────────────────────────────────────────────
CREATE TABLE categoria_servico (
    id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome       VARCHAR(80)  NOT NULL UNIQUE,          -- *
    icone_url  VARCHAR(500)     NULL,                 -- o

    PRIMARY KEY (id)
);

-- ─────────────────────────────────────────────
--  5. pedido
--     Pedido de serviço feito por um cliente.
--     cliente_id   → cliente.id      (1:N obrigatório)
--     tecnico_id   → tecnico.id      (1:N opcional — pode não ter técnico ainda)
--     categoria_id → categoria_servico.id  (1:N obrigatório)
--     estado: 'pendente' | 'aceite' | 'em_progresso' | 'concluido' | 'cancelado'
-- ─────────────────────────────────────────────
CREATE TABLE pedido (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cliente_id   INT UNSIGNED NOT NULL,               -- *  FK → cliente
    tecnico_id   INT UNSIGNED     NULL,               -- o  FK → tecnico
    categoria_id INT UNSIGNED NOT NULL,               -- *  FK → categoria_servico
    descricao    TEXT         NOT NULL,               -- *
    estado       ENUM('pendente','aceite','em_progresso','concluido','cancelado')
                              NOT NULL DEFAULT 'pendente',
    preco_final  DECIMAL(8,2)     NULL,               -- o  (definido após conclusão)
    criado_em    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    concluido_em DATETIME         NULL,               -- o

    PRIMARY KEY (id),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_id)   REFERENCES cliente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_tecnico
        FOREIGN KEY (tecnico_id)   REFERENCES tecnico(id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_categoria
        FOREIGN KEY (categoria_id) REFERENCES categoria_servico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
--  6. avaliacao
--     Avaliação deixada pelo cliente após conclusão.
--     pedido_id  → pedido.id   (1:1 opcional — nem todo o pedido tem avaliação)
--     cliente_id → cliente.id
--     tecnico_id → tecnico.id
-- ─────────────────────────────────────────────
CREATE TABLE avaliacao (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    pedido_id   INT UNSIGNED NOT NULL UNIQUE,         -- *  FK → pedido  (1:1)
    cliente_id  INT UNSIGNED NOT NULL,                -- *  FK → cliente
    tecnico_id  INT UNSIGNED NOT NULL,                -- *  FK → tecnico
    estrelas    TINYINT      NOT NULL,                -- *  1–5
    comentario  TEXT             NULL,                -- o
    criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT fk_avaliacao_pedido
        FOREIGN KEY (pedido_id)  REFERENCES pedido(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_avaliacao_cliente
        FOREIGN KEY (cliente_id) REFERENCES cliente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_avaliacao_tecnico
        FOREIGN KEY (tecnico_id) REFERENCES tecnico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_estrelas CHECK (estrelas BETWEEN 1 AND 5)
);

-- ─────────────────────────────────────────────
--  7. notificacao
--     Notificações enviadas a qualquer utilizador.
--     utilizador_id → utilizador.id  (1:N)
-- ─────────────────────────────────────────────
CREATE TABLE notificacao (
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    utilizador_id  INT UNSIGNED NOT NULL,             -- *  FK → utilizador
    titulo         VARCHAR(150) NOT NULL,             -- *
    mensagem       TEXT         NOT NULL,             -- *
    lida           TINYINT(1)   NOT NULL DEFAULT 0,   -- *  0=não lida, 1=lida
    enviada_em     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    CONSTRAINT fk_notificacao_utilizador
        FOREIGN KEY (utilizador_id) REFERENCES utilizador(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
--  ÍNDICES adicionais (desempenho)
-- ─────────────────────────────────────────────
CREATE INDEX idx_pedido_estado      ON pedido(estado);
CREATE INDEX idx_pedido_criado_em   ON pedido(criado_em);
CREATE INDEX idx_notificacao_lida   ON notificacao(lida);
CREATE INDEX idx_tecnico_disponivel ON tecnico(disponivel);

