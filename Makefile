CXX := g++
CXXFLAGS := -std=c++17 -Wall -O2
INCLUDES := -I./duckdb/src/include
DUCKDB_LIB_DIR := ./duckdb/build/release
DUCKDB_LIBS := $(shell find $(DUCKDB_LIB_DIR) -name "*.a")
LIBS := -lssl -lcrypto -lpthread -ldl
TARGET := dag
SRC := dag.cpp

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $^ -o $@ \
		-Wl,--start-group $(DUCKDB_LIBS) -Wl,--end-group \
		$(LIBS)

clean:
	rm -f $(TARGET)
