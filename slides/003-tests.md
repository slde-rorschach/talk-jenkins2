# Tests

- Linters
- PHPUnit
- PHPSpec
- Behat
- Deptrac
- Security Checker

---

# Linters

Easy to set up, often forgotten

- **Use-case:** find syntax errors
- **When to start:** Very early (project start)
- **When to run:** With every change/commit
- **Provides:** Error when failing
- **On error:** Fail build

--
PHP
```bash
# Single PHP file
$ php -l web/app.php
No syntax errors detected in web/app.php

# All PHP files in a directory
$ find ./src -name "*.php" -print0 | xargs -0 -n1 -P8 php -l
No syntax errors detected in src/AppBundle/AppBundle.php
No syntax errors detected in src/AppBundle/Controller/DefaultController.php
# [...]
```

--
Yaml
```
./bin/console lint:yaml app/config
 [OK] All 9 YAML files contain valid syntax.
```

Twig
```
./bin/console lint:twig app/Resources/views
 [OK] All 11 Twig files contain valid syntax.
```

---

# PHPUnit

De-facto standart for  unittests in PHP

- **Use-case:** Unit tests
- **When to start:** Very early (project start)
- **When to run:** With every change/commit
- **Provides:** Junit report, coverage report
- **On error:** Fail build

--
Writing tests
```php
namespace Tests\AppBundle\Factory;

class GameFactoryTest extends \PHPUnit_Framework_TestCase
{
    /** @dataProvider validPgnProvider */
    public function testCreateFromImportedPgn($pgn)
    {
        $chessMock = $this->createMock(ChessAdapter::class);
        $chessMock->expects($this->once())
            ->method('parsePgn')->willReturn(/* [...] */);
        
        $gameFactory = new GameFactory($chessMock);
        $game = $gameFactory->createFromPgn($pgn);
        $this->assertInstanceOf(Game::class, $game);
    }
}
```

--
Run tests and genereate reports
```bash
$ phpunit \
  --coverage-html=reports/phpunit-html-coverage \
  --log-junit=reports/phpunit.junit.xml \
  --coverage-clover=reports/phpunit.clover.xml
PHPUnit 5.5.4 by Sebastian Bergmann and contributors.

........................                              24 / 24 (100%)

Time: 327 ms, Memory: 12.00MB

OK (24 tests, 56 assertions)

Generating code coverage report in Clover XML format ... done

Generating code coverage report in HTML format ... done
```

---

# PHPSpec

Also unit-testing, very nice mocking api (prophecy)

- **Use-case:** Unit tests
- **When to start:** Very early (project start)
- **When to run:** With every change/commit
- **Provides:** Junit report
- **On error:** Fail build


Use this XOR PHPUnit. Not both in one project.

--
Writing tests
```php
namespace spec\AppBundle\Domain;

use AppBundle\Domain\PgnDate;
use PhpSpec\ObjectBehavior;

class PgnDateSpec extends ObjectBehavior
{
    function it_is_initializable()
    {
        $this->beConstructedThrough('fromString', ['1934.??.??']);
        $this->shouldHaveType(PgnDate::class);
        $this->getYear()->shouldReturn(1934);
        $this->getMonth()->shouldReturn(0);
        $this->getDay()->shouldReturn(0);
    }
}
```

--
Running tests and create report
```bash
$ phpspec run --format=junit > reports/phpspec.junit.xml
                               100%                               1
1 specs
1 example (1 passed)
53ms
```

---

# Behat

Functional testing with human readable scenarios

- **Use-case:** Behavior tests
- **When to start:** Early (project start)
- **When to run:** With every change/commit
- **Provides:** Junit test report
- **On error:** Fail build

--
Writing scenarios
```gherkin
Feature: Import Chess Games
  As a chess player
  I want to import my games

  Scenario: Import game via form
    When I go to "/en/import/pgn"
    And I should see "Import PGN" in the "h1" element
    And I should see an "button" element
```
--

Running tests and create report
```bash
$ behat
Feature: Import Chess Games
  As a chess player
  I want to import my games

  Scenario: Import game via form
    When I go to "/en/import/pgn"
    And I should see "Import PGN" in the "h1" element
    And I should see an "button" element

1 scenario (1 passed)
3 steps (3 passed)
0m0.39s (22.40Mb)

# create report
$ behat --format junit --out reports/behat.junit
```

---

# deptrac

Keep your architecture as defined

- **Use-case:** ensure software architecture
- **When to start:** When some kind of architecture appears
- **When to run:** With every commit/pull-request
- **Provides:** error when failing, svg file
- **On error:** fail build

--
Generate a ruleset
```yaml
paths: [./src]
exclude_files: [.*test.*]
layers:
  - name: Controller
    collectors:
      - type: className
        regex: .*Controller.*
  - name: Repository
    collectors:
      - type: className
        regex: .*Repository.*
ruleset:
  Controller:
    - Repository
  Repository:
```
--

Run Deptrac and create image
```bash
$ deptrac analyze --formatter-graphviz-dump-image=deptrac.png

Start to create an AstMap for 38 Files.
......................................
AstMap created.
start emitting dependencies "InheritanceDependencyEmitter"
start emitting dependencies "BasicDependencyEmitter"
end emitting dependencies
start flatten dependencies
end flatten dependencies
collecting violations.
formatting dependencies.

Found 0 Violations
```
--

deptrac graph image

![deptrac-graph](slides/img/003-deptrac.png "deptrac graph example")

---

# Security Checker

Check your dependencies for known security issues

- **Use-case:** Prevent security leaks
- **When to start:** With the first composer package
- **When to run:** With every new composer package / on each composer update
- **Provides:** Error on known issue
- **On error:** Fail build

--
```bash
$ security-checker security:check composer.lock

Security Check Report
~~~~~~~~~~~~~~~~~~~~~

Checked file: /srv/share/symfony/composer.lock


  [OK]
  0 packages have known vulnerabilities


             This checker can only detect vulnerabilities that are referenced
 Disclaimer  in the SensioLabs security advisories database. Execute this
             command regularly to check the newly discovered vulnerabilities.
```
