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
        component.addOperation("CreateShortcut", "@TargetDir@/Spectrecoin.exe", "@StartMenuDir@/Spectrecoin.lnk",
            "workingDirectory=@TargetDir@", "iconPath=@TargetDir@/spectrecoin-128.png",
            "iconId=2", "description=Start Spectrecoin Wallet");
    }
}
