/**************************************************************************
 **
 ** Copyright (C) 2019 Spectrecoin Team.
 **
 **************************************************************************/

function Component()
{
}

Component.prototype.createOperationsForArchive = function(archive)
{
    // don't use the default operation
    // component.createOperationsForArchive(archive);

    // Cleanup existing blockchain data
    component.addOperation("Delete", "@HomeDir@/AppData/Roaming/InstallerTest/subfolder")
    component.addOperation("Delete", "@HomeDir@/AppData/Roaming/InstallerTest/.gitignore")
    // add an extract operation with a modified path
    // component.addOperation("Extract", archive, "@TargetDir@/extractToAnotherPath");
    component.addOperation("Extract", archive, "@HomeDir@/AppData/Roaming/InstallerTest");
}
