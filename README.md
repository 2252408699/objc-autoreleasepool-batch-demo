/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
/Users/yangmizhao/.rvm/scripts/rvm:29: operation not permitted: ps
# Objective-C Autorelease Pool Batch Demo

A Foundation command-line example showing two practical facts about `@autoreleasepool`:

1. a temporary object can be released when a nested pool drains;
2. a large import can place explicit pools around bounded batches of temporary strings.

The sample processes 10,000 CSV-like rows in batches of 250 and verifies a deterministic checksum.

## Requirements

- macOS
- Xcode Command Line Tools

Install the tools if needed:

```bash
xcode-select --install
```

## Run

```bash
git clone https://github.com/2252408699/objc-autoreleasepool-batch-demo.git
cd objc-autoreleasepool-batch-demo
make run
```

Expected final output:

```text
PASS temporary token was released when the inner pool drained
PASS 10,000 generated rows were processed in bounded batches
All checks passed. (checksum: 178900)
```

## Clean

```bash
make clean
```

## Notes

- ARC and autorelease pools solve different problems; ARC does not eliminate autoreleased temporaries.
- Pool drain timing is a lifetime boundary, not a guarantee that every object created inside is destroyed there.
- Batch size is a tuning choice. Measure memory and throughput with Instruments before changing production code.
