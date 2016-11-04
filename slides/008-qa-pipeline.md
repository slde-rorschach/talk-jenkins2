# Lets bring QA and pipeline together

---

## What we want

- `Jenkinsfile` in our repository
- fail fast!
- build all branches
- deploy all branches

---

# Creating the build

## Some suggestions

---

### `Makefile` for build steps

Pros:
- Same targets for CI and developers
- Targets can be grouped
- Targets can be parameterized
- Available (almost) everywhere

Cons:
- No jenkins plugin available

At least, use a build tool/task runner

---

### Naming conventions for report files

`<tool>.<type>.<ext>`

Examples:

- `phpunit.junit.xml`
- `phpmd.pmd.xml`
- `phpcpd.dry.xml`
- `insight.pmd.xml`

---

# `Jenksinsfile`

--

## Checkout the repository

```groovy
#!groovy
node {
    stage 'Checkout'
        checkout scm
}

```

--
## Build the project

```groovy
node {
    // [...]
    stage 'build'
        parallel 'build php': {
            sh 'make composer-install'            
        }, 'build js': {
            sh 'make npm-install'
            sh 'make gulp-default'
        }
}
```

--
## Run QA tools
```groovy
node {
    // [...]
    stage 'tests + tarball'
        parallel 'lint': {
            sh 'make lint'
        }, 'phpunit': {
            sh 'make phpunit-report'
        }, 'phpcs': {
            sh returnStatus: true, script: 'make phpcs-report'
        }, 'phpmd': {
            sh returnStatus: true, script: 'make phpmd-report'
        }, 'phpcpd': {
            sh 'make phpcpd-report'
        }, 'tarball': {
            sh 'make tarball'
        }
}
```

--
## Publish PHPUnit results

```groovy
node {
    // [...]
    stage 'Publish Results'
        junit 'reports/*.junit.xml'

        step([
            $class: 'CloverPublisher', 
            cloverReportDir: 'reports', 
            cloverReportFileName: '*.clover.xml'
        ])
}
```
--
```groovy
node {
    // [...]
    stage 'Publish Results'
        // [...]
        publishHTML(target: [
            allowMissing: false, 
            alwaysLinkToLastBuild: false,
            keepAll: false,
            reportDir: 'reports/phpunit-html-coverage',
            reportFiles: 'index.html',
            reportName: 'PHPUnit Code Coverage Report'
        ])
}
```

--
## Publish pmd reports

this include PHPMD and Insight

```groovy
node {
    // [...]
    stage 'Publish Results'
        // [...]
        step([
            $class: 'PmdPublisher',
            canComputeNew: false,
            defaultEncoding: '',
            healthy: '',
            pattern: 'reports/*.pmd.xml',
            unHealthy: ''
        ])
}
```

--
## Only ask for branch `master` to deploy live

```groovy
// [...]
if ('master' == env.BRANCH_NAME) {
    timeout(time:30, unit:'MINUTES') {
        input message:'Deploy to live?'
    }

    node {
        stage 'deploy-live'
            sh 'make deploy'
    }
}
```

---

# Setup Multibranch Build

--
![Setup multibranch build1](slides/img/008-multibranch-1.png "Setup multibranch build1")
![Setup multibranch build2](slides/img/008-multibranch-2.png "Setup multibranch build2")

---


# What is missing?

- pdepend: There is no jdepend-plugin for pipeline




