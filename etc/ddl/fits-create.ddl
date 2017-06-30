CREATE SCHEMA fits;

-- ground_relationship is from the site to the ground in m.  e.g., a site above ground
-- has a negative ground relationship.
CREATE TABLE fits.site (
	sitePK SERIAL PRIMARY KEY,
	siteID TEXT NOT NULL,
	name TEXT NOT NULL,
	location GEOGRAPHY(POINT, 4326) NOT NULL,
	height NUMERIC NOT NULL,
	ground_relationship NUMERIC NOT NULL,
	UNIQUE(siteID)
);

CREATE TABLE fits.unit (
	unitPK SERIAL PRIMARY KEY,
	symbol TEXT NOT NULL UNIQUE,
	name TEXT NOT NULL
);

CREATE TABLE fits.type (
	typePK SERIAL PRIMARY KEY,
	typeID TEXT NOT NULL UNIQUE,
	name TEXT NOT NULL,
	description TEXT NOT NULL,	
	unitPK BIGINT REFERENCES fits.unit(unitPK) ON DELETE CASCADE NOT NULL
);

CREATE TABLE fits.method (
	methodPK SERIAL  PRIMARY KEY,
	methodID TEXT NOT NULL UNIQUE,
	name TEXT NOT NULL,
	description TEXT NOT NULL,
	reference TEXT NOT NULL
);

CREATE TABLE fits.type_method (
	typePK BIGINT REFERENCES fits.type(typePK) ON DELETE CASCADE NOT NULL,
	methodPK BIGINT REFERENCES fits.method(methodPK) NOT NULL,
	PRIMARY KEY (typePK, methodPK)
);

CREATE TABLE fits.system (
	systemPK SERIAL PRIMARY KEY,
	systemID TEXT NOT NULL,
	description TEXT NOT NULL
);

CREATE TABLE fits.sample (
	samplePK SERIAL PRIMARY KEY,
	systemPK BIGINT REFERENCES fits.system(systemPK) ON DELETE CASCADE NOT NULL,
	sampleID TEXT NOT NULL,
	UNIQUE(systemPK, sampleID)
);

CREATE TABLE fits.observation (
	sitePK BIGINT REFERENCES fits.site(sitePK) ON DELETE CASCADE NOT NULL,
	typePK BIGINT REFERENCES fits.type(typePK) ON DELETE CASCADE NOT NULL,
	methodPK BIGINT REFERENCES fits.method(methodPK) ON DELETE CASCADE NOT NULL,
	samplePK BIGINT REFERENCES fits.sample(samplePK) ON DELETE CASCADE NOT NULL,
	time TIMESTAMP(6) WITH TIME ZONE NOT NULL,
	value NUMERIC NOT NULL,
	error NUMERIC NOT NULL,
	PRIMARY KEY (sitePK, typePK, methodPK, samplePK, time)
);

CREATE INDEX ON fits.observation (sitePK);
CREATE INDEX ON fits.observation (typePK);
CREATE INDEX ON fits.observation (time);

CREATE TABLE fits.visual_observation (
	sitePK BIGINT REFERENCES fits.site(sitePK) ON DELETE CASCADE NOT NULL,
	time TIMESTAMP(6) WITH TIME ZONE NOT NULL,
	image_url TEXT NOT NULL,
	notes TEXT NOT NULL,
	PRIMARY KEY (sitePK, time)
);

CREATE INDEX ON fits.visual_observation (sitePK);
CREATE INDEX ON fits.visual_observation (time);
