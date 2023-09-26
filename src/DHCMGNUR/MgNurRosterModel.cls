/// 排班模板
Class DHCMGNUR.MgNurRosterModel Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 模板名称
Property ModelName As %String(TRUNCATE = 1) [ SqlFieldName = Model_Name ];

/// 病区
Property ModelWardDR As %String(TRUNCATE = 1) [ SqlFieldName = Model_Ward_DR ];

Index ModelWardDRIndex On ModelWardDR;

/// 添加模板
/// w ##class(DHCMGNUR.MgNurRosterModel).AddModelData("模板一^1018")
ClassMethod AddModelData(parr As %String) As %String
{
	q:parr=""
	set ModelName = $P(parr,"^",1)
	set ModelWardDR = $P(parr,"^",2)
	set ModelObject = ##class(DHCMGNUR.MgNurRosterModel).%New()
	set ModelObject.ModelName = ModelName
	set ModelObject.ModelWardDR = ModelWardDR
	TStart
	set sc = ModelObject.%Save()
	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "fail"
	}
	else
	{
		TCommit
		q ModelObject.%Id()
	}
}

/// 按病区查询排班模板
/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurRosterModel","FindModelData",1018)
Query FindModelData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindModelDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
	s ^TMPP("parr1")=parr
	s ret=""
	i (parr="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	set ModelId = ""
	for  set ModelId=$O(^DHCMGNUR.MgNurRosterModelI("ModelWardDRIndex"," "_parr,ModelId)) q:ModelId=""  do
	.set ModelObj=##class(DHCMGNUR.MgNurRosterModel).%OpenId(ModelId)
	.set ModelName=ModelObj.ModelName
	.s ret="ModelId|"_ModelId_"^ModelName|"_ModelName
	.Do OutPutModel
	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutPutModel
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindModelDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModelDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindModelDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModelDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="MgNurRosterModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelName</Value>
</Value>
<Value name="3">
<Value>ModelWardDR</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurRosterModelD</DataLocation>
<DefaultData>MgNurRosterModelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurRosterModelD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurRosterModelI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurRosterModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
