# Terraform docker action

## Example usage

``` yml
- uses: labrats-work/action-terraform@main
  with:
    chdir: /tests/default    
    varsFile: default.tfvars
    action: plan
  env:
    keyfile: ${ secrets.sshkey }
```

## Inputs

|Variable|Type|Required|Default|
|---|---|---|---|
|chdir|input|false||
|init|input|false|yes|
|varsFile|input|false||
|planFile|input|true|tfplan|
|backendConfigFile|input|false||
|verb|input|false|apply|
|sshKey|env|false||

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
- [x] Ability to specify backend config file
- [x] Outputs the terraform version
- [x] Tests to validate passing scenarios
- [x] Tests to validate failing scenarios
