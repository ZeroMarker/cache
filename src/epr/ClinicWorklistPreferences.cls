Class epr.ClinicWorklistPreferences Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetParam(component, context, worklistname, ReturnDescriptions = 0, ParamName, ByRef Ward)
{
}

ClassMethod GetAllParams(component, context, worklistname, ReturnDescriptions = 0)
{
}

ClassMethod GetDefParams(comp) As %String
{
}

ClassMethod DeleteClinicalPrefs(ID, sub1, sub2)
{
}

ClassMethod SaveClinicalPrefs(evnt, ID As %String, sub1, sub2)
{
}

ClassMethod GetPrefData(workname, TheItem, subKey) As %String
{
}

/// s val=##class(epr.ClinicWorklistPreferences).GetPreferences(
/// $g(%request.Data("WorkName",1)), 0, .tmp, $g(%request.Data("WorkComponent",1))_$g(%request.Data("WorkContext",1)))
/// set str = "WIPDateFromToday,WIPDtFromOffset,WIPDateToToday,WIPDTToOffset,WIPEpisodeTypeList,WIPHospitalList,"_
/// 	"WIPCPList,WIPSpecialtyList,WIPLocList,WIPOrderCatList,WIPOrderSubCatList,WIPResultStatus,WIPOrderStatus,WIPPrioList,OrderingCP,WIPUnitList"_
/// "WIPWardList,WIPBedList,WIPRoomList,WIPAdminStatsList,WIPTmFrom,WIPTmTo,WIPRecLocsList,WIPAdminRoutesList"
/// 参数	DTGCOM1033.2.mac  
ClassMethod GetPreferences(WorkName As %String, OnlyReturnArray = 0, ByRef ReturnArray, subKey = "") As %String
{
}

ClassMethod AddRowIds(type, value)
{
}

}
