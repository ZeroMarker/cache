/// Associates an icon against a code to pictorial description
Class epr.CTIconAssociation Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1502;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Code";

Parameter SQLROWID = "ID";

Property Code As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property CondDescription As %Library.String(MAXLEN = "", TRUNCATE = 1);

/// Conditional Expression
Property CondExpr As %Library.String(MAXLEN = "", TRUNCATE = 1);

Property Description As %Library.String(MAXLEN = 250, TRUNCATE = 1);

Property Icon As %Library.String(TRUNCATE = 1);

/// internal flag for marking the record has been updated on site, so that this does not get overwritten in full builds.
///  - updated only if websys.Configuration property TrakEnabledOptions is turned off (usual for sites)
/// and sites update the record.
/// 
Property IsDirty As %Library.Boolean;

/// 是否激活
Property Active As %Boolean;

/// 就诊类型
Property AdmType As %String;

/// 医护类型
Property CareType As %String;

/// 临床类型
Property CliType As %String;

/// Uniqueness index for property Code
Index UniqueCodeIndex On Code [ Unique ];

/// called from epr.floorplan.csp and epr.floorplanredraw.csp
/// w ##class(epr.CTIconAssociation).FPBookingRoomShow(77211,"10$BA$77211^24610^77211^张三,,32,女,0000024610^^^^^^^^^^^^^^^^^$1$$$$$0$",.ARY,.COL)
ClassMethod FPBookingRoomShow(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef COL As %Library.String) As %Library.String
{
}

ClassMethod FPData(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef imgLIST As %Library.String, ByRef imgDONE As %Library.String)
{
}

/// 	Any information required by the condition expressions on the icons is gathered in this method.
/// 	On top of that all the information required by the epr.floorplan.csp is gathered in this method.
/// 	And this method is subsequently called by many components that require similar information.  These include:
/// 	PACWard.ListPatientsInWard
/// 	PACWardRoom.ListPatients
/// 	PAAdm.ListCurrentInLoc
/// 	PAPerson.Banner
/// 		qse modify 2011.07.23
ClassMethod FPGatheringData(EpisodeID As %Library.String = "", PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef pColorArray As %Library.String)
{
}

/// qse add 2011.07.23 
ClassMethod Diag(mradm, typ = "")
{
}

/// KM: 19-Mar-2002: Called from epr.floorplan.csp and pacward.listpatients.csp
/// FPLayout 的输出值尚不清楚
/// Header的排列顺序的机制还不清楚 zhouzq
ClassMethod FPHeadingShow(isSetup As %Library.String, page As %Library.String, ByRef LocID As %Library.String, ByRef WardID As %Library.String, ByRef isEMLoc As %Library.String, ByRef DeptType As %Library.String, ByRef FPLayout As %Library.String)
{
}

/// qse add 2011.07.23
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
}

/// ab 10.03.04 - 42654 - defines the tooltip for the standard floorplan, from CO108^at84b
ClassMethod FPTitle(PatientID As %String = "", EpisodeID As %String = "", ByRef ARY As %String) As %String
{
}

ClassMethod FPTitleR(PatientID As %String, ByRef ARY As %String, rmQueryType As %String = "") As %String
{
}

/// add by zhouzq 2011.11.08
/// 获得床位图上定的图标HTML
ClassMethod GetImages(ProfileID As %String) As %String
{
}

ClassMethod FPWaitingRoomShow(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef COL As %Library.String) As %Library.String
{
}

ClassMethod GetCTIcons(EpisodeID As %Library.String, ByRef count As %Library.String, ByRef ARY As %Library.String, ByRef imgLIST As %Library.String, ProfileID As %String)
{
}

/// returns a list of the icons and there priorities
/// "codes" is a comma delimited string with of the codes to retrieve
ClassMethod GetIconList(ByRef list As %Library.String, codes As %Library.String) As %Library.String
{
}

/// KM 24-Sept-2001: Called from component web.PAPerson.Banner
ClassMethod GetImageFromCode(Code As %Library.String) As %Library.String
{
}

/// ab 16.06.03 32081 - returns patient type(s) based on patientid or episodeid
/// I,E,O,B (booked inpatient),D (recently discharged)
/// definitions from 30968
ClassMethod GetPatientType(PatientID As %String = "", EpisodeID As %String = "") As %String
{
}

/// ab - 5.11.03 40435 - gets the latest episode for the patient type icons when they are displayed on patient list
ClassMethod GetEpisodeForIcon(PatientID As %String = "", EpisodeID As %String = "", PatType As %String = "") As %String
{
}

/// by wuqk 2011-05-27 
ClassMethod websysDeleteProcedure(compref As %String, id As %String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
/// by wuqk 2011-05-27 
ClassMethod websysSaveAll(compref As %String, id As %String)
{
}

/// ab 10.09.03 - 35675 - compare patients to find which is the next most urgent
/// most urgent patient is:
/// 1. patient without care provider
/// 2. patient with highest triage catagory
/// 3. patient waiting the longest (based on triage date/time)
ClassMethod NextMostUrgentPatient(MostUrgent As %String = "", EpisodeID As %String = "") As %String
{
}

Query Find(Code As %String, Description As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Code,Icon,Description")
{
SELECT  ID,Code,Icon,Description
FROM     epr.CTIconAssociation
WHERE (Code %STARTSWITH :Code)
AND ((%ALPHAUP Description [ %ALPHAUP :Description) OR (:Description IS NULL))
}

Query LookUpCustom(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Code:%String,HIDDEN:%String,Description:%String,Icon:%String")
{
SELECT CODE, ID, DESCRIPTION, Icon
FROM epr.CTIconAssociation
WHERE (%ALPHAUP CODE %STARTSWITH %ALPHAUP :desc)
}

ClassMethod IsShowIcon(EpisodeID, iconobj)
{
}

Storage Default
{
<Data name="CTIconAssociationClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTIconAssociationDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Icon</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>CondExpr</Value>
</Value>
<Value name="6">
<Value>CondDescription</Value>
</Value>
<Value name="7">
<Value>IsDirty</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>AdmType</Value>
</Value>
<Value name="10">
<Value>CareType</Value>
</Value>
<Value name="11">
<Value>CliType</Value>
</Value>
</Data>
<DataLocation>^epr.CTIconAssociationD</DataLocation>
<DefaultData>CTIconAssociationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTIconAssociationD</IdLocation>
<IndexLocation>^epr.CTIconAssociationI</IndexLocation>
<StreamLocation>^epr.CTIconAssociationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
