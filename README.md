# zig-radix-tree

Adaptive Radix Tree (compressed trie) in Zig designed for IP routing tables and fast prefix search.

## Features
- **Compressed Edges**: Merges non-branching common prefix sequences for minimal pointer hops.
- **Prefix Matching**: Logarithmic prefix lookups with zero external libraries.
