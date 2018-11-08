CREATE TABLE accounts(
	-- always present fields
	id BIGINT NOT NULL AUTO_INCREMENT,
	address VARCHAR(32) NOT NULL UNIQUE,
	inspected_times INT NOT NULL DEFAULT 0,

	-- nullable fields
	first_inspected_at DATETIME NULL,
	last_inspected_at DATETIME NULL,
	hash VARCHAR(64) NULL UNIQUE,
	payouts_sum DECIMAL(20, 9) NULL,
	fee_percent_guessed DECIMAL(6, 3) NULL,
	found_at DATETIME(3) NULL,
	exported_at DATETIME(3) NULL,
	invalidated_at DATETIME(3) NULL,
	invalidated_exported_at DATETIME(3) NULL,

	-- keys
	PRIMARY KEY(id)
);
