# Introduction

Who am I

# So, why Continous Integration?

- Because Automatate all the things
    + Running tests
    + Running QA tools
    + Generating API Docs
    + Deployment
- Become reports as fast as possible
- Shared reports (for the non-devs)

# Install jenkins

## By hand

On Debian bases systems:

```bash
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install openjdk-8-jdk jenkins
```

Then, got to (http://your-host:8080/) and follow instructions.

## With ansible

```yaml
# requirements.yml
---
- geerlingguy.jenkins

```

```yaml
# playbook.yml
  vars:
    jenkins_plugins:
      - workflow-aggregator 
      - git
      - greenballs
      # [...]
    # these are the defaults
    jenkins_hostname: "{{ hostname }}"
    jenkins_http_port: 8080
    jenkins_admin_username: admin
    jenkins_admin_password: admin
  roles:
    - role: geerlingguy.jenkins
      become: true

```

```bash
ansible-galaxy install -r requirements.yml -p roles
ansible-playbook playbook.yml
```


## New in Jenkins 2: Pipelines with Jenkinsfile

Add a `Jenkinsfile`to your project.

You need the Pipeline plugin (`workflow-aggregator`)

## Pipeline plugin

- Keep your build configuration in Version controll
- Snippet generator 
- groovy dsl for creating build configurations
- trivial(!) setup of multibranch builds


## Inital simple Jenkinsfile






## Where (and when to start)


## Overview of QA Tools

### Linter (php, twig, yaml)

Easy to setup, often forgotten

For:
- Check for syntax errors

When to start:
- Very early

When to run:
- With every commit

Provides:
- Error when failing

On Error:
- Fail build

Where to install:
- Global


### PHPUnit / PHPSpec

For:
- For Unit tests
- Test driven development

When to start
- Very early (best case: With inital commit)

When to run
- With every commit (or even with every change)

On error:
- Fail build

Provides:
- Junit Report -> Report about all tests and their result
- Crap4j -> Combination of code coverage and code complexity
- clover -> Code coverage xml
- code coverage html report -> clickibunti code coverage

Where to install:
- In project

### PHPCS

for:
- checking code styles (php, js, css)

When to start
- Very early, at least, when a second dev joins the project

When to run
- With every change

Provides:
- checkstyle report

on Error:
- notify developer

Where to install:
- Global


### Deptrac

For:
- Ensuring Software architecture

when to start
- When some kind of architecture appears

When to run
- With every commit

on error:
- fail build(?)

Provides:
- Report
- SVG file

Where to install:
- global

### Copy Paste Detector

For:
- detecting doublicated code

when to start:

Provides:
- report of doublicated code

Where to install:
- global

### PHPMD

For:
- Detecting bad code

When to start:
- When project grows
- When tem grows
- when the "wtf does this code do" moments appear

Provides:
- Report of bad code

Where to install
- global


### pdepend

For:
- Detailed software metrics

When to start:
- When you understood the metrics ;)
- Ensuring, a (bad) project does not go worse
- For big projects

Provides:
- Report
- SVGs

Where to install
- Global


### Blackfire

For:
- Performance testing
- Profiling

When to start:
- Before(!) performance becomes important

Provides:
- detailed profiles

Where to install
- Extension on the prod server

### Security checker

For:
- checking composer deps for security issues

when to start:
- With the first composer dep

Provides
- Report of known security issues

Where to install:
- global

### Deprecation detector

For:
- Find deprecations in your project

when to start:
- When you begin to mark your own code as deprecated
- When using libraries, that have deprecations (Symfony form component)

Provides
- report of deprecations

Where to install
- global



### Sami

For: 
- generating API Docs

when to start
- When creating an api
- When open sourcing the project

Provides
- HTML for API docs

Where to install:
- global





