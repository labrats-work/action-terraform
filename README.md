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
|init|false|true|
|varsFile|false||
|verb|false||

## Outputs

|Variable|Type|
|---|---|
|terraformVersion|string|
---

## Requirements

- [x] Ability to specify working directory
- [x] Ability to optionally run terraform init
- [x] Ability to exec and output terraform verbs ['plan', 'apply', 'destroy']
- [x] Ability to specify vars file
- [x] Ability to specify and load sshkey
- [x] Outputs the terraform version
- [ ] Tests to validate passing scenarios
- [ ] Tests to validate failing scenarios
