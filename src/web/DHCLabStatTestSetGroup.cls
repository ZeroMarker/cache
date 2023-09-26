Class web.DHCLabStatTestSetGroup Extends %Persistent
{

/// 化验项目统计
Parameter BUILD = 60;

ClassMethod QueryTestSetGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTestSetGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCode","QueryTestSetGroup","2013-04-01","2013-05-15","demo","","","",0,"")
ClassMethod QueryTestSetGroupExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, User As %String, DepCode As %String, DateType As %String, PatientType As %String, ReceiveUser As %String, AutherUser As %String, Ward As %String, Doctor As %String, CliDepCode As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S DateS=$G(DateS), DateE=$G(DateE), User=$G(User), DepCode=$G(DepCode), DateType=$G(DateType), PatientType=$G(PatientType)
  S ReceiveUser=$G(ReceiveUser), AutherUser=$G(AutherUser),Ward=$G(Ward),Doctor=$G(Doctor),CliDepCode=$G(CliDepCode)
  I CliDepCode="null" S CliDepCode=""
  //I MachCode="null" S MachCode=""
  S (TestCode,TestName,Type,Number)=""
  S Data=$lb(TestCode,TestName,Type,Number)
  D Output
  S qHandle=$lb(0,repid,0)
  Q $$$OK

Output
	Set Data=$lb(TestCode,TestName,Type,Number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTestSetGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTestSetGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$O(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 化验项目统计
/// Table：        无
/// Input：        DateS:起始时间(格式："2013-04-01")，DateE：结束时间(格式："2013-04-01"),User:检验科用户(必填只检索该用户所分配科室权限的数据),DepCode:检验科科室代码(为空将检索所有科室),MachCode:仪器代码为空取全部仪器,MachTG:仪器组代码为空取全部仪器分组，DateType：接收审核类型(0:按接收日期查询，1:按审核日期查询)，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       TestCode:项目代码，TestName：项目名称，Type：项目类型，Number：项目数量
/// Return：       无
/// Others：       无
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestCode","QueryTestSetGroup","2013-04-01","2013-05-15","demo","","","",0,"")
Query QueryTestSetGroup(DateS As %String, DateE As %String, User As %String, DepCode As %String, DateType As %String, PatientType As %String, ReceiveUser As %String, AutherUser As %String, Ward As %String, Doctor As %String, CliDepCode As %String) As %Query(ROWSPEC = "TestCode:%String,TestName:%String,Type:%String,Number:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestSetGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestSetGroupD</DataLocation>
<DefaultData>DHCLabStatTestSetGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestSetGroupD</IdLocation>
<IndexLocation>^web.DHCLabStatTestSetGroupI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestSetGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
