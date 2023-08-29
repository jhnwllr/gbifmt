# gbifmt 

## Installation 

GBIF has machine tags for datasets, organizations, and installations. These can be made via the registry API. 

https://www.gbif.org/developer/registry

```R 
devtools::install_github("jhnwllr/gbifmt")
```

Set up GBIF credential before using. Making a machine tag requires that you are a **GBIF employee**, so this won't work if you want to use this privately. 

```R 
usethis::edit_r_environ()
```

``` 
GBIF_USER="username"
GBIF_PWD="yourpassword"
```

## Example usage

```R
library(gbifmt)

create_mt(
uuid="38b4c89f-584c-41bb-bd8f-cd1def33e92f",
namespace="testMachineTag.jwaller.gbif.org",
name="testMachineTag",
value=1,
api="uat")

get_mt(machineTagNamespace="testMachineTag.jwaller.gbif.org",api="uat")

delete_mt("38b4c89f-584c-41bb-bd8f-cd1def33e92f",6229107,api="uat")
```