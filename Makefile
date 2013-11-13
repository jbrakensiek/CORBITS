SHELL = /bin/bash
CC = g++
CFLAGS = -c -Wall -O2 -I $(LIB_PATH) -I $(DATA_PATH)
LDFLAGS = -Wall -O2 -I $(LIB_PATH) -I $(DATA_PATH)

# library

LIB_PATH = lib
LIB = 	$(LIB_PATH)/math_misc.cpp \
	$(LIB_PATH)/point3D.cpp \
	$(LIB_PATH)/transit.cpp \
	$(LIB_PATH)/occultations.cpp
LIB_OBJ = $(LIB:.cpp=.o)

# base

BASE_PATH = base
BASE_SRC = $(BASE_PATH)/corbits.cpp
BASE_OBJ = $(BASE_SRC:.cpp=.o)

# data

DATA_PATH = data
DATA_SRC = $(DATA_PATH)/koi_input.cpp
DATA_OBJ = $(DATA_SRC:.cpp=.o)

# examples

EXAMPLES = kepler-11 period-dist mhs-dist solar-system

KEP11_PATH = examples/kepler-11
KEP11_SRC = $(KEP11_PATH)/Kepler-11.cpp
KEP11_OBJ = $(KEP11_SRC:.cpp=.o)

PER_PATH = examples/period-dist
PER_SRC = $(PER_PATH)/stat_dist.cpp \
	$(PER_PATH)/period_dist.cpp
PER_OBJ = $(PER_SRC:.cpp=.o)

MHS_PATH = examples/period-dist
MHS_SRC = $(MHS_PATH)/stat_dist.cpp \
	$(MHS_PATH)/mhs_dist.cpp
MHS_OBJ = $(MHS_SRC:.cpp=.o)

SOLSYS_PATH = examples/solar-system
SOLSYS_SRC = $(SOLSYS_PATH)/solsys.cpp
SOLSYS_OBJ = $(SOLSYS_SRC:.cpp=.o)

# unit tests

TEST_PATH = test
TEST_SRC = $(TEST_PATH)/approx_test.cpp
TEST_OBJ = $(TEST_SRC:.cpp=.o)

# targets

all: lib base examples

lib: $(LIB_OBJ)

corbits: base

base: lib $(BASE_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(BASE_OBJ) -o $(BASE_PATH)/corbits

examples: $(EXAMPLES)

# Kepler-11

kepler-11: lib $(KEP11_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(KEP11_OBJ) -o $(KEP11_PATH)/$@

run-kepler-11: kepler-11
	$(KEP11_PATH)/kepler-11

# Period ratio distribution

period-dist: lib $(DATA_OBJ) $(PER_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(DATA_OBJ) $(PER_OBJ) -o $(PER_PATH)/$@

run-period-dist: period-dist $(DATA_PATH)/koi-data-edit.txt
	$(PER_PATH)/period-dist

period-hist: $(DATA_PATH)/per_adj_hist_py.txt \
	$(DATA_PATH)/per_all_hist_py.txt \
	$(DATA_PATH)/per_snr_hist_py.txt
	python $(PER_PATH)/hist/make_hist.py 2> /dev/null

# MHS distribution

mhs-dist: lib $(DATA_OBJ) $(MHS_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(DATA_OBJ) $(MHS_OBJ) -o $(MHS_PATH)/$@

run-mhs-dist: mhs-dist $(DATA_PATH)/koi-data-edit.txt
	$(MHS_PATH)/mhs-dist

mhs-hist: $(DATA_PATH)/mhs_adj_hist_py.txt \
	$(DATA_PATH)/mhs_all_hist_py.txt \
	$(DATA_PATH)/mhs_snr_hist_py.txt
	python $(MHS_PATH)/hist/make_mhs_hist.py 2> /dev/null

# Solar System

solar-system: lib $(SOLSYS_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(SOLSYS_OBJ) -o $(SOLSYS_PATH)/$@

run-solar-system: solar-system
	$(SOLSYS_PATH)/solar-system 2> /dev/null

# Unit tests

unit-test: lib $(TEST_OBJ)
	$(CC) $(LDFLAGS) $(LIB_OBJ) $(DATA_OBJ) $(TEST_OBJ) -o $(TEST_PATH)/$@

# ref: http://mrbook.org/tutorials/make
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

# remove object files and executables
clean:
	rm -f $(LIB_PATH)/*.o \
	$(BASE)/*.o \
	$(BASE)/corbits \
	$(KEP11_PATH)/*.o \
	$(KEP11_PATH)/kepler-11 \
	$(PER_PATH)/*.o \
	$(PER_PATH)/period-dist \
	$(MHS_PATH)/*.o \
	$(MHS_PATH)/mhs-dist \
	$(SOLSYS_PATH)/*.o \
	$(SOLSYS_PATH)/solar-system \
	$(TEST_PATH)/*.o \
	$(TEST_PATH)/unit-test

# remove all output files
clean-all: clean
	rm -f $(DATA_PATH)/*.txt \
	$(PER_PATH)/*.txt \
	$(PER_PATH)/stat/*.txt \
	$(PER_PATH)/hist/*.txt \
	$(PER_PATH)/hist/*.pdf \
	$(PER_PATH)/*.log \
	$(SOLSYS_PATH)/*.csv

# files

$(DATA_PATH)/koi-data-edit.txt:
	$(DATA_PATH)/grab.sh

$(DATA_PATH)/per_adj_hist_py.txt: run-period-dist

$(DATA_PATH)/per_all_hist_py.txt: run-period-dist

$(DATA_PATH)/per_snr_hist_py.txt: run-period-dist

$(DATA_PATH)/mhs_adj_hist_py.txt: run-mhs-dist

$(DATA_PATH)/mhs_all_hist_py.txt: run-mhs-dist

$(DATA_PATH)/mhs_snr_hist_py.txt: run-mhs-dist
