Class web.DHCQCPublicFunction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20120615
/// Description:： 查询服务器的日期和时间
/// Table：        无
/// Input：        RetCode:参数
/// Output：       按照参数或者时间
/// Return：       1:日期，2:时间,3:日期时间
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryDateTime("4")
ClassMethod QueryDateTime(RetCode As %String) As %String
{
	Set RetCode=$Get(RetCode)
	Set Ret=""
	If RetCode="" Set RetCode=1
	If RetCode=1 Do
	.Set Ret=$ZD(+$H,3)
	If RetCode=2 Do
	.Set Ret=$ZT($Piece($H,",",2))
	If RetCode=3 Do
	.Set Ret=$ZD(+$H,3)_"^"_$ZT($Piece($H,",",2))
	If RetCode=4 Do
	.Set Ret=$ZD(+$H,3)_" "_$ZT($Piece($H,",",2))
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120615
/// Description:： 返回日期时间格式
/// Table：        无
/// Input：        RetCode:参数,CurDate:日期
/// Output：       返回月初月末日期
/// Return：       1:月初日期，2:月末日期
/// Others：
/// d ##class(web.DHCQCPublicFunction)ReturnDate("1","2013-01-02")
ClassMethod ReturnDate(RetCode As %String, CurDate As %String) As %String
{
	Set RetCode=$Get(RetCode)
	Set CurDate=$Get(CurDate)
	Set Ret=""
	If RetCode="" Set RetCode=1
	If RetCode=1 Do
	.Set CurDate=$Piece(CurDate,"-",1,2)
	.Set Ret=CurDate_"-01"
	If RetCode=2 Do
	.Set CurMoth=$Piece(CurDate,"-",2,2)
	.Set CurYear=$Piece(CurDate,"-",1)
	.If CurMoth<12 Set CurMoth=CurMoth+1
	.Else  Set CurMoth=01,CurYear=CurYear+1
	.Set CurDate=CurYear_"-"_CurMoth_"-01"
	.Set CurDate=$ZDH(CurDate,3)
	.Set CurDate=$ZD((CurDate-1),3)
	.Set Ret=CurDate
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询科室名称
/// Table：        ct_Dept
/// Input：        DeptCode:参数
/// Output：       DeptName:科室名称
/// Return：       DeptName:科室名称
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryDeptName("A")
ClassMethod QueryDeptName(DeptCode As %String) As %String
{
	Set DeptCode=$Get(DeptCode)
	If DeptCode="" Quit ""
    Set DeptName=$Piece(^TTAB("DEP",DeptCode),"\",1)
	Quit DeptName
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询仪器名称
/// Table：        MIF_MACHINE
/// Input：        MachCode:参数
/// Output：       MachName:仪器名称
/// Return：       MachName:仪器名称
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryMachName("")
ClassMethod QueryMachName(MachCode As %String) As %String
{
	Set MachCode=$Get(MachCode)
	If MachCode="" Quit ""
    Set MachName=$Piece(^TMIF(MachCode),"\",1)
	Quit MachName
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询质控物名称
/// Table：        web.DHCQC_Material
/// Input：        MatCode:质控物代码
/// Output：       MatName:质控物名称
/// Return：       MatName:质控物名称
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryMatName("A")
ClassMethod QueryMatName(MatCode As %String) As %String
{
	Set MatCode=$Get(MatCode)
	If MatCode="" Quit ""
    Set MatName=$Piece(^DHCQCMAT(MatCode),"^",2)
	Quit MatName
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询批次物名称
/// Table：        web.DHCQC_Lot
/// Input：        LotCode:质控物代码
/// Output：       LotName:质控物名称
/// Return：       LotName:质控物名称
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryLotName("32500810/32520811/32500812")
ClassMethod QueryLotName(MatCode As %String, LotCode As %String) As %String
{
	Set LotCode=$Get(LotCode)
	If LotCode="" Quit ""
	If MatCode="" Quit ""
	//质控物批次名称改为取12号位置 DaiYi 2015-03-30
    Set LotName=$Piece(^DHCQCLOT(MatCode,LotCode),"^",12)
	Quit LotName
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询指定的的日期和时间
/// Table：        无
/// Input：        RetCode:日期类型,CurDate:输入日期
/// Output：       按照参数或者时间
/// Return：       1:上个月日期，2:下个月日期
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryDateByMoth("2","2013-12-1")
ClassMethod QueryDateByMoth(RetCode As %String, CurDate As %String) As %String
{
	Set Ret="",CurDate=$Get(CurDate)
	Set CurYear=$Piece(CurDate,"-",1),CurMouth=$Piece(CurDate,"-",2),CurDay=$Piece(CurDate,"-",3)
	If RetCode=1 Do
	.Set StatDate=CurYear_"-"_CurMouth_"-01"
	.Set CurDateDec=$ZDh(StatDate,3)
	.If CurMouth>1 Set Ret=CurYear_"-"_(CurMouth-1)_"-01"
	.Else  Set Ret=(CurYear-1)_"-12-01"
	.Set Ret=Ret_"^"_$ZD(CurDateDec-1,3)
    If RetCode=2 Do
	.Set StatDate=CurYear_"-"_CurMouth_"-01"
	.Set CurDateDec=$ZDh(StatDate,3)
	.If CurMouth<12 Do
	..Set Ret=CurYear_"-"_(CurMouth+1)_"-01"
	.Else  Set Ret=(CurYear+1)_"-01-01"
	.If (CurMouth+1)<12 Set StatDate=CurYear_"-"_(CurMouth+2)_"-01"
	.Else  Set StatDate=(CurYear+1)_"-02-01"
	.Set CurDateDec=$ZDh(StatDate,3)
	.Set Ret=Ret_"^"_$ZD(CurDateDec-1,3)
	If Ret="" Set Ret="^"
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20131108
/// Description:： 查询指定的的日期和时间
/// Table：        无
/// Input：        RetCode:日期类型,CurDate:输入日期
/// Output：       按照参数或者时间
/// Return：       1:三个月日期，2:半年的日期
/// Others：
/// d ##class(web.DHCQCPublicFunction).QueryDateByMoths("1","2013-11-1")
ClassMethod QueryDateByMoths(RetCode As %String, CurDate As %String) As %String
{
	Set Ret="",CurDate=$Get(CurDate)
	Set CurYear=$Piece(CurDate,"-",1),CurMouth=$Piece(CurDate,"-",2),CurDay=$Piece(CurDate,"-",3)
	If RetCode=1 Do
	.If CurMouth>2 Set Ret=CurYear_"-"_(CurMouth-2)_"-01"
	.Else  Do 
	..If CurMouth=2 Set Ret=(CurYear-1)_"-12-01"
	..If CurMouth=1 Set Ret=(CurYear-1)_"-11-01"
	.If CurMouth<12 Set EndDate=CurYear_"-"_(CurMouth+1)_"-01"
	.Else  Set EndDate=(CurYear+1)_"-01-01"
	.Set CurDateDec=$ZDh(EndDate,3)
	.Set Ret=Ret_"^"_$ZD(CurDateDec-1,3)
	If RetCode=2 Do
	.If CurMouth>5 Set Ret=CurYear_"-"_(CurMouth-5)_"-01"
	.Else  Do 
	..If CurMouth=5 Set Ret=(CurYear-1)_"-12-01"
	..If CurMouth=4 Set Ret=(CurYear-1)_"-11-01"
	..If CurMouth=3 Set Ret=(CurYear-1)_"-10-01"
	..If CurMouth=2 Set Ret=(CurYear-1)_"-09-01"
	..If CurMouth=1 Set Ret=(CurYear-1)_"-08-01"
	.If CurMouth<12 Set EndDate=CurYear_"-"_(CurMouth+1)_"-01"
	.Else  Set EndDate=(CurYear+1)_"-01-01"
	.Set CurDateDec=$ZDh(EndDate,3)
	.Set Ret=Ret_"^"_$ZD(CurDateDec-1,3)
	Quit Ret
}

Storage Default
{
<Data name="DHCQCPublicFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCPublicFunctionD</DataLocation>
<DefaultData>DHCQCPublicFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCPublicFunctionD</IdLocation>
<IndexLocation>^web.DHCQCPublicFunctionI</IndexLocation>
<StreamLocation>^web.DHCQCPublicFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
