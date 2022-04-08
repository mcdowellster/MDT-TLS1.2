# MDT TLS 1.2 Support

<!--Do a walk-through of the Browser, because time.-->

## Steps to get working in SCCM/MDT
-   Create a new folder and copy the contents to it.
-   Copy folder to your deployment share
-   Edit your TS, adding a "run command line" near the beginning of the PE Phase (and after any reboot back into PE)
-   Enter the command line: `powershell.exe -executionpolicy bypass -file "\\<YOUR SERVER>\deploymentShare$\<YOUR FOLDER PATH>\install.ps1"`
-   Update any scripts used that reference the OLD driver in the SQL connection string. In most cases only ZTIDataAccess.wsf will need to be updated. Looks for the line: `"sDSNRef = "Provider=SQLOLEDB;OLE DB Services=0;Data Source=" & dicSQLData("SQLServer")"`

-   Replace SQLOLEDB with MSOLEDBSQL and save the file(s).
-   Use the MSI (included) to install support into the Windows deployment if you are doing SQL queries outside of WinPE. Win10 out of box still requires this driver to be installed. Since I do queries during the Windows Phase, I install it as one of the first `POST PE` steps.