# Terraform docker action

## Example usage

``` yml
- uses: labrats-work/action-terraform@v1
  with:
    chdir: /tests/default    
    varsFile: default.tfvars
    action: plan
```

## Inputs

|Variable|Required|Default|
|---|---|---|
|chdir|false||
|init|false|yes|
|varsFile|false||
|planFile|true|tfplan|
|verb|false|apply|
|sshKey|false||

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
- [x] Tests to validate passing scenarios
- [x] Tests to validate failing scenarios
