/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
/Users/yangmizhao/.rvm/scripts/rvm:29: operation not permitted: ps
APP := autoreleasepool-batch-demo
SOURCE := Sources/main.m

.PHONY: all run clean

all: $(APP)

$(APP): $(SOURCE)
	clang -fobjc-arc -framework Foundation $(SOURCE) -o $(APP)

run: $(APP)
	./$(APP)

clean:
	rm -f $(APP)
