
function BodyLoadHandler(){		
	InitPage();
}


function InitPage()
{
	KeyUp("Module^Function^Type^BringUser^SolveUser^DutyUser^Custorm");
	Muilt_LookUp("Module^Function^Type^BringUser^SolveUser^DutyUser^Custorm");
}
function GetModule (value)
{
	GetLookUpID("ModuleDR",value);
}
function GetFunction (value)
{
    GetLookUpID("FunctionDR",value);
}
function GetType (value)
{
    GetLookUpID("TypeDR",value);
}
function GetBringUser (value)
{
    GetLookUpID("BringUserDR",value);
}
function GetSolveUser (value)
{
    GetLookUpID("SolveUserDR",value);
}
function GetDutyUser (value)
{
    GetLookUpID("DutyUserDR",value);
}
function GetCustorm (value)
{
    GetLookUpID("CustormDR",value);
}

document.body.onload = BodyLoadHandler;