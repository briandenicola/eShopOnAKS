# Overview
Kubernetes Developer Workshop
This is a hands-on, technical workshop intended / hack to get comfortable working with Kubernetes, and deploying and configuring applications. It should take roughly 6~8 hours to complete the main set of sections, but this is very approximate. This workshop is intended partially as a companion to this Kubernetes Technical Primer which can be read through, referenced or used to get an initial grounding on the concepts.

This workshop is very much designed for software engineers & developers with little or zero Kubernetes experience, but wish to get hands on and learn how to deploy and manage applications. It is not focused on the administration, network configuration & day-2 operations of Kubernetes itself, so some aspects may not be relevant to dedicated platform/infrastructure engineers.

📝 NOTE: if you've never used Kubernetes before, it is recommended to read the 'Introduction To Kubernetes' section in Kubernetes Technical Primer PDF

The application used will be one that has already been written and built, so no application code will need to be written.

If you get stuck, the GitHub source repo for this workshop contains example code, and working files for most of the sections.

To start with the workshop, first you need to choose which path you'd like to follow, either using AKS or hosting Kubernetes yourself in a VM. If you are unsure you should pick AKS.

Table of contents
=================

<!--ts-->
   * [Installation](#installation)
   * [Usage](#usage)
      * [STDIN](#stdin)
      * [Local files](#local-files)
      * [Remote files](#remote-files)
      * [Multiple files](#multiple-files)
      * [Combo](#combo)
      * [Auto insert and update TOC](#auto-insert-and-update-toc)
      * [GitHub token](#github-token)
      * [TOC generation with Github Actions](#toc-generation-with-github-actions)
   * [Tests](#tests)
   * [Dependency](#dependency)
   * [Docker](#docker)
     * [Local](#local)
     * [Public](#public)
<!--te-->


Installation
============

# Architecture 
![eShop Reference Application architecture diagram](https://github.com/dotnet/eShop/blob/main/img/eshop_architecture.png?raw=true)

# To Do
- [X] Build container images
- [X] Deploy to Kubernetes
- [ ] Add Keda Scalers Examples
- [X] Review Azure Monitor and Application Insights
- [ ] Update documentation