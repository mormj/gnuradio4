# Performance and capacity

## Purpose

Assess whether supported or reachable workloads exceed a relevant time, space, or resource bound. ID: `performance-capacity`.

## Applicability signals

Complexity, allocations, buffering, fan-out, blocking, hot paths, batching, retries, or retention changes.

## Questions

- Which input/workload controls cost, and is that workload supported or adversarially reachable?
- Can retries, queues, or fan-out amplify work faster than backpressure limits it?
- Does partial progress retain resources or repeat expensive work indefinitely?

## Trace techniques

Express cost in terms of actual input/work units and concurrent users. Include downstream amplification and retained state. Locate the stated budget or user-visible degradation; avoid preference-based optimization.

## Useful verification

Use bounded workload scaling, matched environments, and a recorded baseline. Measure the relevant latency, throughput, memory, or resource quantity. A complete complexity argument may establish unbounded behavior without destructive stress.

## Common false positives

Microbenchmarks that exclude dominant costs, intentional bounded caches, unsupported workloads, or noisy timing presented as a regression.

## Disproof checks

Check upper bounds, batching, amortization, caller throttles, and deployment capacity. Confirm measurement inputs/environment match and the cost affects a promised property. Account for warmup and instrumentation where relevant.

## Escalation triggers

Challenge unbounded queues/retries, input-controlled recursion/fan-out, or new blocking on a shared critical path.

## Completion evidence

Record workload admissibility, cost mechanism, applicable budget/consequence, measurements or proof, and limits of extrapolation.
