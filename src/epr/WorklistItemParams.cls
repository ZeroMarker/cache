Class epr.WorklistItemParams Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 365;

Parameter SQLCODE = "ID";

Parameter SQLDATEFROM = "WIPDateFrom";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLDATETO = "WIPDateTo";

Parameter SQLROWID = "ID";

/// Index for property WIPWorklistItemDefDR
Index WIPWorklistItemDefDRIndex On WIPWorklistItemDefDR;

Property WIPAccessionNo As %Library.String(TRUNCATE = 1);

Property WIPAdmType As %Library.String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", TRUNCATE = 1, VALUELIST = ",I,O,E,N,H");

Property WIPCareProvDR As User.CTCareProv;

Property WIPDateFrom As %Library.Date;

Property WIPDateFromToday As %Library.Boolean;

Property WIPDateTo As %Library.Date;

Property WIPDateToToday As %Library.Boolean;

Property WIPEQDR As User.RBCEquipment;

/// $$ delimited string of (event status*show) for care provider list
Property WIPEventStatus As %Library.String(MAXLEN = 300, TRUNCATE = 1);

Property WIPHospitalDR As User.CTHospital;

/// $$ delimited string of (referral status*show) for care provider list
Property WIPInqReqStatus As %Library.String(MAXLEN = 300, TRUNCATE = 1);

Property WIPLocationDR As User.CTLoc;

Property WIPLogonCP As %Library.Boolean [ InitialExpression = 1 ];

Property WIPLogonLoc As %Library.Boolean [ InitialExpression = 1 ];

Property WIPLogonRoundCP As %Library.Boolean [ InitialExpression = 0 ];

Property WIPLogonRoundRR As %Library.Boolean [ InitialExpression = 0 ];

Property WIPNoAppts As %Library.Boolean;

Property WIPOutpatLoc As %Library.Boolean [ InitialExpression = 1 ];

Property WIPPatientNo As %Library.String(TRUNCATE = 1);

Property WIPRadStatus As %Library.String(MAXLEN = 300, TRUNCATE = 1);

/// $$ delimited string of (referral status*show) for care provider list
Property WIPReferralStatus As %Library.String(MAXLEN = 300, TRUNCATE = 1);

Property WIPResourceDR As User.RBResource;

Property WIPSortDirection As %Library.String(TRUNCATE = 1) [ InitialExpression = "D" ];

/// $$ delimited string of (referral status*show) for care provider list
Property WIPSortOrder As %Library.String(TRUNCATE = 1);

Property WIPViewAdm As %Library.Boolean;

Property WIPViewAll As %Library.Boolean [ InitialExpression = 1 ];

Property WIPViewDisch As %Library.Boolean;

Property WIPViewPread As %Library.Boolean;

Property WIPVisitNo As %Library.String(TRUNCATE = 1);

Property WIPVisitStatus As %Library.String(MAXLEN = 300, TRUNCATE = 1);

/// custom parameter worklist item
Property WIPWLI As %Library.String(TRUNCATE = 1);

Property WIPWorklistItemDefDR As epr.CTWorklistItemDef;

Property WIPDtFromOffset As %Library.String(TRUNCATE = 1);

Property WIPDtToOffset As %Library.String(TRUNCATE = 1);

Property WIPClinicListType As %Library.String(TRUNCATE = 1);

Property WIPLogonHosp As %Library.Boolean [ InitialExpression = 1 ];

Property WIPHospitalList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPLogonSpecialty As %Library.Boolean [ InitialExpression = 1 ];

Property WIPSpecialtyList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPCPList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPEpisodeTypeList As %Library.String(TRUNCATE = 1);

Property WIPOrderCatList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPOrderSubCatList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPLocList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPWardList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPResultStatus As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPOrderStatus As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPInpatAdmTypeDR As User.PACInPatAdmissionType;

Property WIPUnitList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPNurseTabList As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPOnlyEpsOutstandingDS As %Library.Boolean;

Property WIPReceivingLoc As %Library.String(MAXLEN = 999, TRUNCATE = 1);

Property WIPCaseManager As User.CTCareProv;

Property WIPLogonCaseMan As %Library.Boolean;

Property WIPARCIMDR As User.ARCItmMast;

/// ab 21.01.04 - 41754 - converts a list of hosps/locs to a string of id's, used on CPEpisode and PAAdm.ListDocCurrent
/// select WIPHospitalList,* from epr.WorklistItemParams
/// WIPHospitalList是空的
/// s val=##class(epr.WorklistItemParams).ConvertToIDString(val,"loc","^") ;->DTGCOM1911.1.mac
ClassMethod ConvertToIDString(val As %String = "", class As %String = "", delim As %String = "") As %String
{
}

/// read params from default for item definition or get custom params from worklist item
ClassMethod ReadParams(ByRef itm As epr.WorklistItem) As %Library.String
{
}

/// worklist.frame.csp用到
/// epr.WorklistItem->workSettingsSelectByFrame()中写了params,但不知道params中是什么顺序
/// set params in request object
ClassMethod SetParams(params As %Library.String, link As %Library.String = "")
{
}

/// wanghc
/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// wanghc
/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

Query FindVisStatForList() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "hidden,desc")
{
SELECT StoredValue,Description
FROM websys.StandardTypeItem
WHERE ParRef='AdmStatus'
}

Storage Default
{
<Data name="WorklistItemParamsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="WorklistItemParamsDefaultData">
<Value name="1">
<Value>WIPDateFrom</Value>
</Value>
<Value name="2">
<Value>WIPDateTo</Value>
</Value>
<Value name="3">
<Value>WIPLogonCP</Value>
</Value>
<Value name="4">
<Value>WIPLogonLoc</Value>
</Value>
<Value name="5">
<Value>WIPWorklistItemDR</Value>
</Value>
<Value name="6">
<Value>WIPWorklistItemDefDR</Value>
</Value>
<Value name="7">
<Value>WIPDateFromToday</Value>
</Value>
<Value name="8">
<Value>WIPDateToToday</Value>
</Value>
<Value name="9">
<Value>WIPCareProvDR</Value>
</Value>
<Value name="10">
<Value>WIPLocationDR</Value>
</Value>
<Value name="11">
<Value>WIPHospitalDR</Value>
</Value>
<Value name="12">
<Value>WIPAdmType</Value>
</Value>
<Value name="13">
<Value>WIPWLI</Value>
</Value>
<Value name="14">
<Value>WIPViewAdm</Value>
</Value>
<Value name="15">
<Value>WIPViewAll</Value>
</Value>
<Value name="16">
<Value>WIPViewDisch</Value>
</Value>
<Value name="17">
<Value>WIPViewPread</Value>
</Value>
<Value name="18">
<Value>WIPEQDR</Value>
</Value>
<Value name="19">
<Value>WIPOutpatLoc</Value>
</Value>
<Value name="20">
<Value>WIPReferralStatus</Value>
</Value>
<Value name="21">
<Value>WIPResourceDR</Value>
</Value>
<Value name="22">
<Value>WIPLogonRoundCP</Value>
</Value>
<Value name="23">
<Value>WIPLogonRoundRR</Value>
</Value>
<Value name="24">
<Value>WIPNoAppts</Value>
</Value>
<Value name="25">
<Value>WIPInqReqStatus</Value>
</Value>
<Value name="26">
<Value>WIPSortOrder</Value>
</Value>
<Value name="27">
<Value>WIPRadStatus</Value>
</Value>
<Value name="28">
<Value>WIPPatientNo</Value>
</Value>
<Value name="29">
<Value>WIPVisitNo</Value>
</Value>
<Value name="30">
<Value>AccessionNo</Value>
</Value>
<Value name="31">
<Value>WIPAccessionNo</Value>
</Value>
<Value name="32">
<Value>WIPSortDirection</Value>
</Value>
<Value name="33">
<Value>WIPEventStatus</Value>
</Value>
<Value name="34">
<Value>WIPVisitStatus</Value>
</Value>
<Value name="35">
<Value>WIPDtFromOffset</Value>
</Value>
<Value name="36">
<Value>WIPDtToOffset</Value>
</Value>
<Value name="37">
<Value>WIPCPList</Value>
</Value>
<Value name="38">
<Value>WIPClinicListType</Value>
</Value>
<Value name="39">
<Value>WIPEpisodeTypeList</Value>
</Value>
<Value name="40">
<Value>WIPHospitalList</Value>
</Value>
<Value name="41">
<Value>WIPLocList</Value>
</Value>
<Value name="42">
<Value>WIPLogonHosp</Value>
</Value>
<Value name="43">
<Value>WIPLogonSpecialty</Value>
</Value>
<Value name="44">
<Value>WIPOrderCatList</Value>
</Value>
<Value name="45">
<Value>WIPOrderSubCatList</Value>
</Value>
<Value name="46">
<Value>WIPSpecialtyList</Value>
</Value>
<Value name="47">
<Value>WIPOrderStatus</Value>
</Value>
<Value name="48">
<Value>WIPResultStatus</Value>
</Value>
<Value name="49">
<Value>WIPCareTypeDR</Value>
</Value>
<Value name="50">
<Value>WIPInpatAdmTypeDR</Value>
</Value>
<Value name="51">
<Value>WIPUnitList</Value>
</Value>
<Value name="52">
<Value>WIPWardList</Value>
</Value>
<Value name="53">
<Value>WIPNurseTabList</Value>
</Value>
<Value name="54">
<Value>WIPOnlyEpsOutstandingDS</Value>
</Value>
<Value name="55">
<Value>WIPReceivingLoc</Value>
</Value>
<Value name="56">
<Value>WIPCaseManager</Value>
</Value>
<Value name="57">
<Value>WIPLogonCaseMan</Value>
</Value>
<Value name="58">
<Value>WIPARCIMDR</Value>
</Value>
</Data>
<DataLocation>^epr.WorklistItemParamsD</DataLocation>
<DefaultData>WorklistItemParamsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.WorklistItemParamsD</IdLocation>
<IndexLocation>^epr.WorklistItemParamsI</IndexLocation>
<StreamLocation>^epr.WorklistItemParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
