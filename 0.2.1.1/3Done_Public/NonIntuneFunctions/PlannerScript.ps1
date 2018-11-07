import-module C:\Git\UnofficialIntuneManagement



$id = "lm9ncYGXpU-D86fYQntSbJYAFlhu"
$TaskResource = "planner/plans/$id/tasks"
$t = Invoke-GraphAPI -Method GET -Resource $TaskResource



            
$DetailResource = "/planner/tasks/$id/details"
$details = Invoke-GraphAPI -Method PATCH -Resource $DetailResource
$t | Export-Excel C:\Git\Planner.xlsx

$t.checklist
$Resource = "/planner/tasks/$id/checklist"