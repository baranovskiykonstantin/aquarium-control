function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();

    if (systemInfo.productType === "windows")
    {
        component.addElevatedOperation("CreateShortcut",
            "@TargetDir@/aquarium-control.exe",
            "@AllUsersStartMenuProgramsPath@/Aquarium control.lnk"
        );
    }
}
