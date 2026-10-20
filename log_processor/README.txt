KT44502 Distributed Systems - Concurrent Log Processor (Elixir)

Environment: Ubuntu 22.04 (VirtualBox VM or WSL2), Elixir 1.12+ / Erlang OTP 24+

1. Install dependencies:
   sudo apt update
   sudo apt install -y elixir erlang git build-essential

2. Get the code:
   git clone <repo-url>
   cd <repo>/log_processor

3. Run everything (evidence, tests, demo):
   chmod +x run.sh
   ./run.sh

4. Run manually:
   mix test
   mix run -e 'LogProcessor.demo()'
   mix run -e 'LogProcessor.demo(3_000_000, 100_000)'

Modules:
  Generator/Parser  - create and parse log lines (pure)
  Analyzer/Merger   - count levels and errors, merge partial results (pure)
  LogProcessor      - concurrent pipeline (Task.async_stream)
  StatsServer       - GenServer actor receiving progress messages