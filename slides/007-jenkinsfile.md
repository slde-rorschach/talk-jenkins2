# The `Jenkinsfile`

- place in the root directory of your repository
- best practice: place `#!groovy` at the beginning
- Create a pipeline (or multibranch pipeline) build
- Thats it.

---

# Steps

- Drawback: Plugins must support Pipeline to provide steps
- Not all plugins support pipeline yet (in Sep. 2016)
- Have a look at [the list](https://github.com/jenkinsci/pipeline-plugin/blob/master/COMPATIBILITY.md)

---

![Where to find Pipeline Syntax help](slides/img/007-pipeline-syntax.png "Where to find Pipeline Syntax help")


---

# Some basics

---

## Define variables

```groovy
def hello = 'Hello World'
echo hello
```
--

Steps can have a return value:

```
def currentDirectory = pwd()
```

---

## Environment variables

```groovy
// read
echo env.PATH

// write
env.SYMFONY__DATABASE_PASSWORD = "this_is_secret"
```
--

### Best practice: `withEnv`

```
withEnv(['env.SYMFONY__DATABASE_PASSWORD=this_is_secret']) {
    sh 'php bin/console doctrine:fixtures:load'
}
```

---

## Conditionals

```groovy
if ('world' == hello ) {
    echo "Hi everybody!"
} else {
    echo "Hi ${hello}"
}
```

---

## Functions

```groovy
if (isDevelop()) {
    sh 'php bin/console doctrine:fixtures:load'
}

def isDevelop() {
    env.BRANCH_NAME == "develop"
}
```

Result of last statement is returned

---

## Regular expressions:

```groovy
def matcher = "Hello World" =~ 'Hello (.+)'
echo matcher[0][0]
echo matcher[0][1]

// output:
Hello World
World
```

---

# Some steps

---

## `sh`: execute shell scripts

```groovy
// very simple
sh 'echo "Hello World"'
// Multiline and shebang
sh '''#/bin/bash
    echo "Hello Again"
    echo "This is line two"
'''
// Prevent return status > 0 failing the build
sh returnStatus: true, script: 'false'
```

---

## `stage`: Run steps in a stage

```groovy
stage "one"
    sh 'echo "Hello World"'
stage "two"
    sh 'make'
stage "four"
    sh 'make something'
```

--
![Stage example](slides/img/007-stage-example.png "stage-example")

---

## `parallel`: Execute steps together

```groovy
parallel firstBranch: {
    sh 'echo "I am executed with others"'
}, secondBranch: {
    sh 'echo I am not alone'
},
failFast: true
```

Notice: `stage`s cannot be run parallel.

---

## `input` Ask for confirmation

```
input message:'Insert coin to continue'
```

--
### Best practices: 

- put `inputs` into a `timeout`.
- do `timeout`s outside of `node`s

```
timeout(time:30, unit:'MINUTES') {
    input message:'Deploy to live?'
}
node {
    stage "play"
        sh 'make deploy'
}
```
--
![Stage example](slides/img/007-message.png "message-example")
--

### More options
```
input message: 'Deploy to live?', 
    ok: 'Do it!', // Value of the button
    parameters: [password( // ask for parameters
        defaultValue: '', 
        description: '', 
        name: 'Password'
    )],
    submitter: 'admin' // who's allowed to answer?
```

---

## `mail` 

```
mail to: 'team@tester.de',
    cc: 'torben@tester.de', 
    bcc: 'tamara@tester.de', 
    subject: 'Your Build is done',
    body: 'Lorem ipsum, Dolores!'
```

---

## `writeFile` and `readFile`

```groovy
writeFile file: 'foo.txt', text: 'five'

def foo = readFile 'foo.txt'
```

---

## `step` Build Steps

```groovy
step([
    $class: 'CloverPublisher', 
    cloverReportDir: 'reports', 
    cloverReportFileName: '*.clover.xml'
])
```

