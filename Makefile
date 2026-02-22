CXX := g++
CXXFLAGS := -std=c++17 -Wall -O2 -ffunction-sections -fdata-sections
INCLUDES := -I./duckdb/src/include
DUCKDB_LIB_DIR := ./duckdb/build/release
DUCKDB_LIBS := $(shell find $(DUCKDB_LIB_DIR) ./duckdb/extensions -name "*.a" 2>/dev/null)
LIBS := -lssl -lcrypto -lpthread -ldl
TARGET := dag
SRC := dag.cpp

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	DUCKDB_LIBS_LINKED := -Wl,--start-group $(DUCKDB_LIBS) -Wl,--end-group
else
	DUCKDB_LIBS_LINKED := $(DUCKDB_LIBS)
endif

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $^ -o $@ \
		$(DUCKDB_LIBS_LINKED) \
		-Wl,--gc-sections,--strip-all \
		$(LIBS)

clean:
	rm -f $(TARGET)
