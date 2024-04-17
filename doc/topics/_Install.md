---
description: How to install ABINIT
authors: XG
---
<!--- This is the source file for this topics. Can be edited. -->

This page gives hints on how to install ABINIT, mostly links to other files.

## Introduction

There are two methodologies to build ABINIT from scratch (compile dependencies, compile ABINIT, make the links).
The first, well-established one, is based on the Autotools (configure ; make ; make install).
The second one is based on CMake.
Instead of building ABINIT from scratch It is often more convenient to build ABINIT using a distribution, although such installation is not often up-to-date.

For the Autotools methodology, see the detailed tutorial [[tutorial:abinit_build|How to build ABINIT using the Autotools]].
For the recent (v10.0) CMake methodology, also needed for the installation of ABINIT on a machine with GPU(s), see [the GPU installation notes](/INSTALL_GPU).
For the use of distribution, see the generic [installation notes of ABINIT](/installation).

## Related Input Variables

{{ related_variables }}

## Selected Input Files

{{ selected_input_files }}

## Tutorials

* [[tutorial:abinit_build|How to build ABINIT using the Autotools]]. Detailed explanations. 
