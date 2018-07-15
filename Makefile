CFLAGS=-g -O2 -Wall -Wall -Isrc -rdynamic $(OPTFLAGS)
LIBS=-ldl $(OPTLIBS)
PREFIX?=/usr/local

SOURCES=$(wildcard src/**/*.c src/*.c)
OBJECTS=$(patsubst %.c,%.o,$(SOURCES))

TARGET=build/libbuffer.a

# The target build
all: $(TARGET)

dev:CFLAGS+=-DNDEBUG -Wextra
dev: all

$(TARGET): CFLAGS += -fPIC
$(TARGET): build $(OBJECTS)
	ar rcs $@ $(OBJECTS)
	ranlib $@

build:
	@mkdir -p build
	@mkdir -p bin

valgrind:
	VALGRIND="valgrind --leak-check=full --log-file=/tmp/valgrind-%p.log" $(MAKE)

# The cleaner
clean:
	rm -rf build $(OBJECTS)
	rm -rf tests/tests.log
	find . -name "*.gc*" -exec rm {} \;
	rm -rf 'find . -name "*.dSYM" -print'

# The install
install: all
	install -d $(DESTDIR)/$(PREFIX)/lib/
	install $(TARGET) $(DESTDIR)/$(PREFIX)/lib/

# The checker
BADFUNCS='[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)'
check:
	@echo Files with potentially dangerous functions
	@egrep $(BADFUNCS) $(SOURCES) || true
