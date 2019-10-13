/**************************************************************************
 **
 ** Copyright (C) 2019 Spectrecoin Team.
 **
 **************************************************************************/

function Component()
{
    // default constructor
}

Component.prototype.createOperations = function()
{
    // call default implementation to actually install README.txt!
    component.createOperations();

    if (systemInfo.productType === "windows") {
        // Spectrecoin itself
        component.addOperation("CreateShortcut", "@TargetDir@/Spectrecoin.exe", "@StartMenuDir@/Spectrecoin.lnk",
            "workingDirectory=@TargetDir@",
            "iconId=2", "description=Start Spectrecoin Wallet");
        // Maintenance tool
        component.addOperation("CreateShortcut", "@TargetDir@/Spectrecoin-Maintenance.exe", "@StartMenuDir@/Updater.lnk",
            "workingDirectory=@TargetDir@",
            "iconId=3", "description=Start Maintenance Tool");
    }
}
