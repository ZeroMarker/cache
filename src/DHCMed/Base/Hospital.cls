/// 名称: DHCMed.Base.Hospital
/// 描述: 医院表(CT_Hospital)的业务封装，定义常用属性和方法
/// 编写者：lyh
/// 编写日期: 2010-04-06
Class DHCMed.Base.Hospital Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 医院Id  HOSP_RowId
Property Rowid As %Integer;

/// 医院代码 HOSP_Code
Property Code As %String(TRUNCATE = 1);

/// 医院描述 HOSP_Desc
Property Descs As %String(TRUNCATE = 1);

/// 起始日期 HOSP_DateFrom
Property DateFrom As %Library.Date;

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       CT_Hospital
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Descs 4:DateFrom
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..Rowid_separete_..Code_separete_..Descs_separete_..DateFrom
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  根据CT_Hospital.HOSP_RowId取医院信息
/// Table：       CT_Hospital
/// Input：       HospId:    CT_Hospital.HOSP_RowId
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(HospId As %String) As DHCMed.Base.Hospital
{
	new (HospId)
	set return=""
	quit:HospId="" return
	quit:'$d(^CT("HOSP",+HospId)) return
	set obj=##Class(DHCMed.Base.Hospital).%New()
	set obj.Rowid=+HospId
	set obj.Code=$p($g(^CT("HOSP",+HospId)),"^",1)	 	 // 医院代码 HOSP_Code
	set obj.Descs=$p($g(^CT("HOSP",+HospId)),"^",2)   	 // 医院描述 HOSP_Desc
	set obj.DateFrom=$p($g(^CT("HOSP",+HospId)),"^",9)   // 起始日期 HOSP_DateFrom
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     lyh
/// CreatDate：   2010-04-06
/// Description:  根据CT_Hospital.HOSP_RowId取医院信息
/// Table：       CT_Hospital
/// Input：       HospId    CT_Hospital.HOSP_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.Hospital).GetStringById(1)
ClassMethod GetStringById(HospId As %String, separete As %String) As %String
{
	new (HospId,separete)
	set return=""
	set obj=..GetObjById(HospId)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-15
/// Description:  查询所有的医院
/// Table：       DHCMed.SS.Hosptial
/// Input：       
/// output:       所有的符合条件的医院           
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.Base.Hospital","QueryHosInfo")
Query QueryHosInfo() As %Query(ROWSPEC = "rowid:%String,hosName:%String") [ SqlProc ]
{
}

ClassMethod QueryHosInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s curDate=+$H
	s rowid=""
	f  s rowid=$o(^CT("HOSP",+rowid)) q:rowid=""  d
	.s startDate=$P(^CT("HOSP",+rowid),"^",9)
	.s endDate=$P(^CT("HOSP",+rowid),"^",10)
	.q:((endDate'="")&&(endDate<curDate))||((startDate'="")&&(startDate>curDate))
	.s $li(data,1)=rowid
	.s $li(data,2)=$p($g(^CT("HOSP",+rowid)),"^",2)   	 // 医院描述 HOSP_Desc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryHosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHosInfoExecute ]
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
<Data name="HospitalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DateFrom</Value>
</Value>
<Value name="4">
<Value>Desc</Value>
</Value>
<Value name="5">
<Value>Rowid</Value>
</Value>
</Data>
<DataLocation>^DHCMed.Base.HospitalD</DataLocation>
<DefaultData>HospitalDefaultData</DefaultData>
<IdLocation>^DHCMed.Base.HospitalD</IdLocation>
<IndexLocation>^DHCMed.Base.HospitalI</IndexLocation>
<StreamLocation>^DHCMed.Base.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
