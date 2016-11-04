# Code analysis

- PHP_CodeSniffer
- PHP Mess Detector
- pdepend
- Copy Paste Detector
- Deprecation Detector
- SensioLabs Insight

---

# PHP_CodeSniffer

Keep your code in style

- **Use-case:** ensure codestyle
- **When to start:** Early, at least, when a second dev joins the project
- **When to run:** With every change/commit
- **Provides:** Checkstyle report
- **On error:** codenazi ? fail build : provide report

Special feature: Can fix some violations by itself.
--
Configure PHP_CodeSniffer
```xml
<?xml version="1.0"?>
<ruleset name="Custom Standard">
    <description>Coding standards for chessdb</description>
    <file>./src</file>
    <file>./tests</file>
    <arg name="report" value="checkstyle"/>
    <arg name="report-file" value="reports/phpcs.cs.xml"/>
    <rule ref="PSR1"/>
    <rule ref="PSR2"/>
</ruleset>
```

--
```bash
$ phpcs --standard=phpcs.xml
```

---

# PHP Mess Detector

Find bad code

- **Use-case:** reduce/avoid code smells
- **When to start:** When project/team grows, when "wtf does this code do" moments appear
- **When to run:** With every change/commit
- **Provides:** pmd report

--
PHP Mess Detector configuration
```xml
<?xml version="1.0"?>
<ruleset name="My first PHPMD rule set"
         xmlns="http://pmd.sf.net/ruleset/1.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://pmd.sf.net/ruleset/1.0.0 http://pmd.sf.net/ruleset_xml_schema.xsd"
         xsi:noNamespaceSchemaLocation="http://pmd.sf.net/ruleset_xml_schema.xsd">
    <description>PHPMD Ruleset for Chessdb</description>
    <!-- Import the entire unused code rule set -->
    <rule ref="rulesets/cleancode.xml"/>
    <rule ref="rulesets/unusedcode.xml"/>
    <rule ref="rulesets/codesize.xml"/>
    <rule ref="rulesets/controversial.xml"/>
    <rule ref="rulesets/design.xml"/>
    <rule ref="rulesets/naming.xml"/>
</ruleset>
```
--

Run phpmd and create report
```
phpmd src xml phpmd.xml --reportfile reports/phpmd.pmd.xml
```

---

# pdepend

Your code in numbers

- **Use-case:** reduce/avoid architecture smells
- **When to start:** When you understand the metrics ;) good for preventing things going worse in big projects
- **When to run:** With every commit/pull-request
- **Provides:** jdepend report, svgs
- **On error:** provide report

--
running pdepend and create report
```bash
$ pdepend \
    --jdepend-xml=reports/pdepend.jdepend.xml \
    --jdepend-chart=reports/pdepend.chart.svg \
    --overview-pyramid=reports/pdepend.pyramid.svg
    src
```
```bash
PDepend 2.2.4
Parsing source files:
......................................                          38
Calculating Dependency metrics:
.........                                                      200
Calculating Coupling metrics:
..............                                                 289
Calculating Cyclomatic Complexity metrics:
..............                                                 289
Calculating Inheritance metrics:
..                                                              52
Calculating Node Count metrics:
.........                                                      200
Calculating Node Loc metrics:
...........                                                    238
Generating pdepend log files, this may take a moment.
Time: 0:00:01; Memory: 12.00Mb
```

---

# PHP Copy/Paste Detector

Don't repeat repeat yourself!

- **Use-case:** Find doublicated code
- **When to start:** Early, just at the beginning
- **When to run:** With every change/commit
- **Provides:** dry report
- **On error:** provide report

--
Run phpcpd and create report
```bash
$ phpcpd --log-pmd=reports/phpcpd.dry.xml src
phpcpd 2.0.4 by Sebastian Bergmann.

0.00% duplicated lines out of 2408 total lines of code.

Time: 63 ms, Memory: 4.00Mb
```

---

# Deprecation Detector

Find deprecations in your project

- **Use-case:** Find usages of deprecations
- **When to start:** When you mark your own code as deprecated, when switching to a new version of a library
- **When to run:** With every change/commit
- **Provides:** html report
- **On error:** fail build

--

```bash
$ deprecation-detector check
Checking your application for deprecations - this could take a while ...
Loading RuleSet...
# really, this could take a while...
RuleSet loaded.
Parsing files & Searching for deprecations...
Finished searching for deprecations.
Rendering output...
Finished rendering output.
There are no violations - congratulations!
Checked 38 source files in 7.229 seconds, 10 MB memory used
```

---

# SensioLabs Insight

Noble metal for your developers

- **Use-case:** A lot of different checks
- **When to start:** Early, before going live
- **When to run:** With every commit/pull-request
- **Provides:** pmd report
- **On error:** Depending on check level

--
```bash
# create report
insight analyze <project-uuid>

# get report
insight analysis \
    <project-uuid> \
    --format=pmd > reports/insight.pmd.xml
```

