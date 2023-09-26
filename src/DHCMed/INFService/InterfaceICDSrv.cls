/// 名称: DHCMed.INFService.InterfaceICDSrv
/// 描述: DHCMed.INF.InterfaceICD 监控主题应用常用方法
/// 编写者：liuyh
/// 编写日期: 2010-09-15
Class DHCMed.INFService.InterfaceICDSrv Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-15
/// Description:  
/// Table：      DHCMed.INF.InterfaceICD
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InterfaceICDSrv","QueryInterfaceICDInfo")
Query QueryInterfaceICDInfo(Type As %String, ICD As %String, Name As %String, PinYin As %String) As %Query(ROWSPEC = "rowid:%String,ICD:%String,Name:%String,LongName:%String,Type:%String,TypeDesc:%String,IsActive:%String,ResumeText:%String,PinYin:%String")
{
}

ClassMethod QueryInterfaceICDInfoExecute(ByRef qHandle As %Binary, Type As %String, ICD As %String, Name As %String, PinYin As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCMed.INF.InterfaceICDD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.InterfaceICD).%OpenId(rowid)
	.q:((Type'="")&(Type'=obj.Type))
	.q:((ICD'="")&(obj.ICD'[ICD))
	.q:((Name'="")&(obj.Name'[Name))
	.q:((PinYin'="")&(obj.PinYin'[PinYin))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ICD
	.s $li(data,3)=obj.Name
	.s $li(data,4)=obj.LongName
	.s $li(data,5)=obj.Type
	.s objDic=##class(DHCMed.SS.Dictionary).GetObjById(obj.Type)
	.q:'$IsObject(objDic)
	.s $li(data,6)=objDic.Description
	.s $li(data,7)=$s(obj.IsActive=1:"Y",1:"N")
	.s $li(data,8)=obj.ResumeText
	.s $li(data,9)=obj.PinYin
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
    .do objDic.%Close()
	q $$$OK
}

ClassMethod QueryInterfaceICDInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInterfaceICDInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInterfaceICDInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInterfaceICDInfoExecute ]
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

Storage Default
{
<Data name="InterfaceICDSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INFS5C1.InterfaceICD59CD</DataLocation>
<DefaultData>InterfaceICDSrvDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.INFS5C1.InterfaceICD59CD</IdLocation>
<IndexLocation>^DHCMed.INFS5C1.InterfaceICD59CI</IndexLocation>
<StreamLocation>^DHCMed.INFS5C1.InterfaceICD59CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
