# Banff
Banff is an evolution of my HdlMicroProcessor architecture. It removes all the negative aspects of that architecture (mem_clk:core_clk > 1), (branch after multiply critical path), (poor i/o subsystem). It also adds dynamic branch prediction to reduce the branch penalty due to the first two aforementioned fixes. I expect Banff to roughly double performance over my original uArchitecture mostly due to clock frequency increases.
