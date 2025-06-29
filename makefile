# Compilador e flags
CC = gcc
CFLAGS = -Wall -Wextra -g -std=c11

# Diretórios
SRC_DIR = .
CONFIG_DIR = config
READER_DIR = reader
MEMORY_CONTROLLER_DIR = memory
TESTS_DIR = tests
UNITY_DIR = $(TESTS_DIR)/libs/unity/src
OPTIONS_TESTS_DIR = $(TESTS_DIR)/unit/options
MEMORY_TESTS_DIR = $(TESTS_DIR)/unit/memory
READER_TESTS_DIR = $(TESTS_DIR)/unit/reader
READER_TEST_FILES = $(READER_TESTS_DIR)/reader_tests.c
READER_SRC_FILE = $(READER_DIR)/reader.c
READER_TEST_EXE = test_reader


# Fontes principais do programa
SRC_FILES = $(SRC_DIR)/main.c \
            $(CONFIG_DIR)/options.c \
            $(READER_DIR)/reader.c

# Arquivos de teste unitário
OPTIONS_TEST_FILES = $(OPTIONS_TESTS_DIR)/options_unit_tests.c
MEMORY_TEST_FILES = $(MEMORY_TESTS_DIR)/memory_controller_tests.c

# Arquivo Unity
UNITY_SRC = $(UNITY_DIR)/unity.c

# Executáveis
MAIN_EXE = main
OPTIONS_TEST_EXE = test_options
MEMORY_TEST_EXE = test_memory_controller

.PHONY: all build test test_options test_memory clean

all: build

build: $(SRC_FILES)
	$(CC) $(CFLAGS) -o $(MAIN_EXE) $(SRC_FILES)

# Regra principal para rodar todos os testes
test: test_options test_memory test_reader

# Testes do módulo options
test_options: $(OPTIONS_TEST_FILES) $(CONFIG_DIR)/options.c $(UNITY_SRC)
	@echo "Compilando e executando testes do módulo options..."
	$(CC) $(CFLAGS) -DTESTING -I$(UNITY_DIR) -I$(CONFIG_DIR) -o $(OPTIONS_TEST_EXE) $(OPTIONS_TEST_FILES) $(CONFIG_DIR)/options.c $(UNITY_SRC)
	./$(OPTIONS_TEST_EXE)

# Testes do módulo memory_controller
test_memory: $(MEMORY_TEST_FILES) $(MEMORY_CONTROLLER_DIR)/memory_controller.c $(UNITY_SRC)
	@echo "Compilando e executando testes do módulo memory_controller..."
	$(CC) $(CFLAGS) -DTESTING -I$(UNITY_DIR) -I$(MEMORY_CONTROLLER_DIR) -o $(MEMORY_TEST_EXE) $(MEMORY_TEST_FILES) $(MEMORY_CONTROLLER_DIR)/memory_controller.c $(UNITY_SRC)
	./$(MEMORY_TEST_EXE)

# Testes do módulo reader
test_reader: $(READER_TEST_FILES) $(READER_SRC_FILE) $(MEMORY_CONTROLLER_DIR)/memory_controller.c $(UNITY_SRC)
	$(CC) $(CFLAGS) -DTESTING -I$(UNITY_DIR) -I$(READER_DIR) -I$(MEMORY_CONTROLLER_DIR) -o $(READER_TEST_EXE) \
		$(READER_TEST_FILES) $(READER_SRC_FILE) $(MEMORY_CONTROLLER_DIR)/memory_controller.c $(UNITY_SRC)
	./$(READER_TEST_EXE)

clean:
	@echo "Removendo executáveis..."
	rm -f $(MAIN_EXE) $(OPTIONS_TEST_EXE) $(MEMORY_TEST_EXE) $(READER_TEST_EXE)
