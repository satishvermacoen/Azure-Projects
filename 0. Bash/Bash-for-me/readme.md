
# Azure CLI Managing Resource

Here is some important CLI command for Azure Resource Managment and to Resource create.

## To manage VM & query cmdlet

### Restart a VM

To restrat vm with in resource group

```bash
    az vm restart --group MyResourceGroup --name MyVm
```
```bash
  az vm restart -g MyResourceGroup -n MyVm
```
    
### Stop a VM

```bash
az vm stop \
    --name VM \
    --resource-group myrg42
```
To see the current running state of your VM

 ```bash
 az vm get-instance-view \
    --name vm \
    --resource-group myrg \
    --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" -o tsv
 ```   
### Start a VM

```bash
az vm start \
    --name VM \
    --resource-group myrg 
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    
### Installation

```bash
  
```
    