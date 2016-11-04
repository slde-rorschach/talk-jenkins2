# Types of QA tools?

- Does my code, what it should?
    + Tests
- Is my code maintainable?
    + Code analysis
- Is my application fast enough?
    + Profiler

---

# Note on installing QA tools

Do NOT add php QA tools to your `composer.json`

Install them globaly (`--global` with composer, or download the `.phar` file)

**You don't want your project dependencies rely on the qa tools dependencies**

--
In your ansible playbook:
```yaml
- name: install php phar qa tools
  get_url: 
  url: "{{ item.value }}"
  dest: "/usr/local/bin/{{ item.key }}"
  mode: 0755
  with_dict:
    deptrac: http://get.sensiolabs.de/deptrac.phar
    insight: http://get.insight.sensiolabs.com/insight.phar
    phpcbf: https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
    phpcpd: https://phar.phpunit.de/phpcpd.phar
    phpcs: https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
    phpmd: http://static.phpmd.org/php/latest/phpmd.phar
    #[...]
```
