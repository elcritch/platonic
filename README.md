
# Platonic: core math types

The goal of this project is to provide common core math types to enabled re-use between projects.

However, it's currently more of a proposal and is not used anywhere.


## Open Questions 

### Dynamic vs Static

Big questions are regarding "static" vs "dynamic" matrix and vector types. For example Arraymancer's `Tensor[T]` type 
is dynamic in that the type doesn't encode the dimensions, or number of dimensions. 

Dynamic types have been the dominant matrix / vector type in scientific software. However, as the Nim compiler has improved with Concepts and semi-dependent typing the possibility of more static type has become more plausible. 
