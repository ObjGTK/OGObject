ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif
PATH  := /usr/local/bin:$(PATH)
CC    := clang
CFLAGS := $$(objfw-config --package OGObject --cppflags)
OBJCFLAGS := $$(objfw-config --objcflags)
LIBS := $$(objfw-config --package OGObject --rpath --libs)

OBJ := obj

SOURCES := $(wildcard *.m)
OBJECTS := $(patsubst %.m, $(OBJ)/%.o, $(SOURCES))

MemoryTest: $(OBJECTS)
	$(CC) $^ -o $@ $(LIBS)

$(OBJ)/%.o: %.m
	@mkdir -p $(@D)
	$(CC) $(OBJCFLAGS) $(CFLAGS) -c $< -o $@

build: MemoryTest

install: MemoryTest
	@install -d $(DESTDIR)$(PREFIX)/bin/
	@install -m 755 MemoryTest $(DESTDIR)$(PREFIX)/bin/

run: MemoryTest
	@./MemoryTest
