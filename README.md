# Terraform docker action

## Example usage

``` yml
- uses: labrats-work/action-terraform@v1
  with:
    varsFile: default.tfvars
```

## Inputs

|Variable|Required|Default|
|---|---|---|
|workingDirectory|false|.|
|varsFile|false||
|verb|false||

## Outputs

|Variable|Type|
|---|---|
|terraformVersion|string|
---

## Requirements

- [x] Ability to specify working directory
- [ ] Ability to exec and output terraform verbs ['plan', 'apply', 'destroy']
- [ ] Ability to specify vars file
- [ ] Ability to specify and load sshkey
- [x] Outputs the terraform version
- [ ] Tests to validate passing scenarios
- [ ] Tests to validate failing scenarios
