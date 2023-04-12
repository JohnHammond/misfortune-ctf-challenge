SOURCES=$(wildcard ./src/*.c)
LDFLAGS:=-z relro -z now
CFLAGS:=-Wall -no-pie -fno-stack-protector
TARGET:=misfortune
CC:=gcc

.PHONY: all clean $(TARGET)

all: $(TARGET)

clean:
	rm -f $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) -o $(TARGET) $(CFLAGS) $(SOURCES) $(LDFLAGS)
