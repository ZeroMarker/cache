Class web.DHCQCTestCodeMethod Extends %Persistent
{

/// Creator：      DaiYi
/// CreatDate：    20140927
/// Description:： 项目方法学名称保存
/// Table：        DHCQC_TCMethod
/// Input：        RecordStr:日志记录
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTestCodeMethod).InsertTestCodeMethod("A1130^发光法^2014-09-01^2015-09-01^Y^N^AC1500")
ClassMethod InsertTestCodeMethod(RecordStr As %String) As %String
{
	Set RecordStr=$Get(RecordStr)
	Set TCCode=$p(RecordStr,"^",1)
	i '$l(TCCode) q
	s TCRowId=$Order(^DHCQCTM(TCCode,""),-1)+1
	s TCMDesc=$p(RecordStr,"^",2)
	s TCMStartDate=$p(RecordStr,"^",3)
	s TCMEndDate=$p(RecordStr,"^",4)
	s MCurFlag=$p(RecordStr,"^",5)
	s MDelFlag=$p(RecordStr,"^",6)
	s TCMachCode=$p(RecordStr,"^",7)
	//------保存---------------
	Set PLIST(2)=TCCode
	Set PLIST(3)=TCRowId
	Set PLIST(4)=TCMDesc
	Set PLIST(5)=$zdh(TCMStartDate,3)
	Set PLIST(6)=$zdh(TCMEndDate,3)
	Set PLIST(7)=MCurFlag
	Set PLIST(8)=MDelFlag
	Set PLIST(9)=TCMachCode
	//-------------------------
	&SQL(Insert Into lab.DHCQC_TCMethod Values :PLIST())
	b ;111
	Quit SQLCODE
}

/// Creator：      DaiYi
/// CreatDate：    20140927
/// Description:： 项目方法学名称保存
/// Table：        DHCQC_TCMethod
/// Input：        RecordStr:日志记录
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCTestCodeMethod).UpdateTestCodeMethod("A1130||1","A1130^发光法^2014-9-1^2015-9-1^N^N^AC1500")
ClassMethod UpdateTestCodeMethod(RowId As %String, RecordStr As %String) As %String
{
	s RowId=$g(RowId)
	Set RecordStr=$Get(RecordStr)
	Set TCCode=$p(RecordStr,"^",1)
	i '$l(TCCode) q
	s TCMDesc=$p(RecordStr,"^",2)
	s TCMStartDate=$p(RecordStr,"^",3)
	s TCMEndDate=$p(RecordStr,"^",4)
	s MCurFlag=$p(RecordStr,"^",5)
	s MDelFlag=$p(RecordStr,"^",6)
	s TCMachCode=$p(RecordStr,"^",7)
	//------保存---------------
	k PLIST
	//Set PLIST(1)=RowId
	//Set PLIST(2)=$p(RowId,"||",1)
	//Set PLIST(3)=$p(RowId,"||",2)
	Set PLIST(4)=TCMDesc
	Set PLIST(5)=$zdh(TCMStartDate,3)
	Set PLIST(6)=$zdh(TCMEndDate,3)
	Set PLIST(7)=MCurFlag
	Set PLIST(8)=MDelFlag
	Set PLIST(9)=TCMachCode
	//-------------------------
	b ;123
	&SQL(Update lab.DHCQC_TCMethod Values :PLIST() where DHCQC_RowId =:RowId )
	b ;111
	Quit SQLCODE
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCTestCodeMethod","QueryTCMethod","AC1500","A1130")
ClassMethod QueryTCMethodExecute(ByRef qHandle As %Binary, MachCode As %String, TCCode As %String) As %Status
{
	Set MachCode=$Get(MachCode),TCCode=$Get(TCCode)
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	i '$l(MachCode) q $$$OK
	i '$l(TCCode) q $$$OK
	s Num=1
	i $d(^DHCQCTM(TCCode)) d
	.s TCMCode="" f  s TCMCode=$o(^DHCQCTM(TCCode,TCMCode)) q:TCMCode=""  d
	..s StrData=$g(^DHCQCTM(TCCode,TCMCode))
	..s RowId=TCCode_"||"_TCMCode
	..s TCName=$P($g(^TTAB("TC",TCCode)),"\",1)
	..s TCMDesc=$p(StrData,"^",3)
	..s TCMStartDate=$zd($p(StrData,"^",4),3)
	..s TCMEndDate=$zd($p(StrData,"^",5),3)
	..s MCurFlag=$p(StrData,"^",6)
	..i MCurFlag="Y" s MCurFlag="true"
	..e  s MCurFlag="false"
	..s MDelFlag=$p(StrData,"^",7)
	..i MDelFlag="Y" q
	..s TCMachCode=$p(StrData,"^",8)
	..i $L(MachCode),MachCode'=TCMachCode q 
	..Do Output
	..s Num=Num+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(Num,RowId,TCMCode,TCName,TCMDesc,TCMStartDate,TCMEndDate,MCurFlag,MDelFlag,TCMachCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTCMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCMethodExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
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

/// Creator：      DaiYi
/// CreatDate：    20130601
/// Description:： 查询日志列表
/// Table：        DHCQC_ResultLog
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryTCMethod(MachCode As %String, TCCode As %String) As %Query(ROWSPEC = "Num,RowId,TCMCode,TCName,TCMDesc,TCMStartDate,TCMEndDate,MCurFlag,MDelFlag,TCMachCode") [ SqlProc ]
{
}

ClassMethod QueryTCMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="DHCQCTestCodeMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCTestCodeMethodD</DataLocation>
<DefaultData>DHCQCTestCodeMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCTestCodeMethodD</IdLocation>
<IndexLocation>^web.DHCQCTestCodeMethodI</IndexLocation>
<StreamLocation>^web.DHCQCTestCodeMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
