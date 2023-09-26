Class CIS.AN.BL.Anaesthesia Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-8
/// Description： 	查询手术间
/// Table：        	OperRoom
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Anaesthesia","FindAnaesthesia","1")
Query FindAnaesthesia(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT *,
	CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',AnaExpert,'Y') As AnaExpertDesc,
	CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Anesthesiologist,'Y') As AnesthesiologistDesc,
	CIS_AN_COM.String_GetDescByIDStr('User.ORCAnaestMethod','ANMETDesc',AnaMethod,',') As AnaMethodDesc,
	CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',ArrAnaExpert) As ArrAnaExpertDesc,
	CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',ArrAnesthesiologist) As ArrAnesthesiologistDesc,
	CIS_AN_COM.String_GetDescByIDStr('User.ORCAnaestMethod','ANMETDesc',ArrAnaMethod,',') As ArrAnaMethodDesc,
	CIS_AN_COM.String_GetDescByID('User.ORCASAClassPhActiv','ORASADesc',ASAClass) As ASAClassDesc,
	%EXTERNAL(PreFasting) As PreFastingDesc,
	%External(TheatreOutTransLoc) As TheatreOutTransLocDesc,
	%External(LaborEndTransLoc) As LaborEndTransLocDesc
	from CIS_AN.Anaesthesia
	where OperSchedule=:opsId
}

ClassMethod GetAnaesthesia(opsId As %String) As CIS.AN.Anaesthesia
{
	set rowId=""
	&sql(select RowId into :rowId from cis_an.anaesthesia where operschedule=:opsId)
	if (rowId=""){
		set rowId=..CreateAnaesthesia(opsId)
	}
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(rowId)
	quit anaesthesia
}

ClassMethod CreateAnaesthesia(opsId As %String) As %String
{
	set rowId=""
	
	if ##class(CIS.AN.OperSchedule).%ExistsId(opsId)
	{
		set anathesia=##class(CIS.AN.Anaesthesia).%New()
		set anathesia.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		
		do anathesia.%Save()
		set rowId=anathesia.%Id()
	}
	
	quit rowId
}

/// w ##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(3)
ClassMethod GetMainAnaId(opsId As %String) As %String
{
	set rowId=""
	&sql(select top 1 RowId into :rowId from cis_an.anaesthesia where operschedule=:opsId)
	
	if SQLCODE quit ""
	quit rowId
}

ClassMethod IsLocalAnaMethod(opsId As %String) As %String
{
	set anaMethod="",anaTypeDr="",anaType=""
	//set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	//set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(opsId)
	//set anaTypeCode=","_anaesthesia.AnaMethod.AnaType.Code_","
	&sql(select AnaMethod into :anaMethod from cis_an.anaesthesia where operschedule=:opsId)
	if anaMethod'="" &sql(select ANMET_Type_DR into :anaTypeDr from SqlUser.ORC_AnaestMethod where ANMET_RowId=:anaMethod)
	if anaTypeDr'="" &sql(select ANTYPE_Code into :anaType from SqlUser.ORC_AnaestType where ANTYPE_RowId=:anaTypeDr)
	set anaTypeCode=","_anaType_","
	set localAnaType=","_##class(CIS.AN.BL.DataConfiguration).GetValueByKey("LocalAnaType")_","
	b ;0
	quit:(localAnaType [ anaTypeCode) "Y"
	quit "N"
}

ClassMethod GetAnaMethodIdByDesc(desc As %String) As %String
{
	set anaTypeDr=""
	&sql(select ANMET_Type_DR into :anaTypeDr from SqlUser.ORC_AnaestMethod where ANMET_Desc=:v)
	quit anaTypeDr
}

/// 同步AnaestCather中的第一麻醉方法至Anaesthesia中
ClassMethod SyncAnaMethod(rowId) As %String
{
	set firstAnaMethod="",saveResult="S^"
	&sql(select top 1 AnaMethod into :firstAnaMethod from CIS_AN.AnaestCatheter where Anaesthesia=:rowId)
	if SQLCODE=0
	{
		kill anaesthesia
		set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
		set anaesthesia("RowId")=rowId
		set anaesthesia("AnaMethod")=firstAnaMethod
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	}
	
	quit saveResult
}

ClassMethod SaveASAClass(opsId As %String, ASAValue)
{
	set AnaId=..GetMainAnaId(opsId)
	quit:AnaId="" "E^"
	set AnaertObj=##class(CIS.AN.Anaesthesia).%OpenId(AnaId)
	set AnaertObj.ASAClass=ASAValue
	set sc=AnaertObj.%Save()
	quit "S^"
}

}
