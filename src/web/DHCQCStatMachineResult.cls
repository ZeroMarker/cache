Class web.DHCQCStatMachineResult Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20130520
/// Description:： 对仪器原始数据进行保存更新操作
/// Table：        DHCQC_MachineTCTotal
/// Input：        ResultDate:标本日期时间,MachCode:仪器代码,Epis:流水号,TCCode:项目代码,TCResult:项目结果
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCStatMachineResult).SaveMachineResultData("","","","","")
ClassMethod SaveMachineResultData(ResultDate, MachCode, Epis, TCCode, TCResult) As %String
{
	//Set ResultDate=63679,MachCode="AC1500",Epis=6,TCCode="A1130",TCResult=3.27
	Set ResultDate=$Get(ResultDate),MachCode=$Get(MachCode),Epis=$Get(Epis),TCCode=$Get(TCCode)
	Set TCResult=$Get(TCResult)
	//当前日期时间
	Set RecDate=$Piece($H,",",1)
	Set RecTime=+$Piece($H,",",2)
	If '$Length(MachCode) Quit 0
	If '$Length(TCCode) Quit 0
	Set SetUpDecimal=$TR($TR($Piece($Get(^TTAB("TC",TCCode)),"\",3),"N")," ")
	If SetUpDecimal="" Set SetUpDecimal=2
	Set TCResult=$Fn(TCResult,",",SetUpDecimal)
    //对结果进行判断,当天第一个结果就直接保存，非第一结果就更新计算.
    Set Ret=100
    If '$Data(^DHCMTCT(ResultDate,MachCode,TCCode)) Do
	.Set PLIST(2)=ResultDate
	.Set PLIST(3)=MachCode
	.Set PLIST(4)=TCCode,PLIST(5)=1
    .Set PLIST(6)=TCResult,PLIST(7)=0
    .Set PLIST(8)=TCResult,PLIST(9)=Epis
	.Set PLIST(10)=TCResult,PLIST(11)=Epis,PLIST(12)=RecDate,PLIST(13)=RecTime
	.Set PLIST(14)="",PLIST(15)="",PLIST(16)="",PLIST(17)=""
	.Set PLIST(18)="",PLIST(19)=""
	.&SQL(Insert Into lab.DHCQC_MachineTCTotal Values :PLIST())
	.Set Ret=SQLCODE
	Else  Do
	.Set StrData=$Get(^DHCMTCT(ResultDate,MachCode,TCCode))
	.Set TCMaxResult=$Piece(StrData,"^",4)
	.Set TCMinResult=$Piece(StrData,"^",6)
	.Set TCCurResult=$Piece(StrData,"^",2)
	.Set EpisMin=$Piece(StrData,"^",5)
	.Set EpisMax=$Piece(StrData,"^",7)
	.Set TCNum=$Piece(StrData,"^",1)
	.//计算最大，最小
	.Set TCDecimal=$Tr($Tr($Piece($Get(^TTAB("TC",TCCode)),"\",3),"N")," ")
	.//改为三位小数点
	.Set TCDecimal=3
	.If TCResult>TCMaxResult Set TCMaxResult=TCResult,EpisMax=Epis
	.If TCResult<TCMinResult Set TCMinResult=TCResult,EpisMin=Epis
	.//计算X，SD
	.Set TCMean=$Fn((TCCurResult*TCNum+TCResult)/(TCNum+1),",",TCDecimal)
	.Set TCSD=$Fn($ZSQR((((TCCurResult-TCMean)*(TCCurResult-TCMean))+((TCCurResult-TCMean)*(TCCurResult-TCMean)*TCNum))/(TCNum)),",",TCDecimal)
	.//更新表数据
	.Set PLIST(2)=ResultDate	
	.Set PLIST(3)=MachCode
	.Set PLIST(4)=TCCode,PLIST(5)=TCNum+1
    .Set PLIST(6)=TCMean,PLIST(7)=TCSD
    .Set PLIST(8)=TCMaxResult,PLIST(9)=EpisMax
	.Set PLIST(10)=TCMinResult,PLIST(11)=EpisMin,PLIST(12)=RecDate,PLIST(13)=RecTime
	.Set PLIST(14)="",PLIST(15)="",PLIST(16)="",PLIST(17)=""
	.Set PLIST(18)="",PLIST(19)=""
	.Set RowId=ResultDate_"||"_MachCode_"||"_TCCode
	.&SQL(Update lab.DHCQC_MachineTCTotal Values :PLIST() where DHCM_RowId=:RowId)
	.Set Ret=SQLCODE
	Quit Ret
}

ClassMethod QueryStatMachTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStatMachTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCStatMachineResult","QueryStatMachTC","LAB","A","XE5000","","2013-05-24","2013-05-24","LABDATA")
ClassMethod QueryStatMachTCExecute(ByRef qHandle As %Binary, HospCode As %String, DeptCode As %String, MachCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set HospCode=$Get(HospCode),DeptCode=$Get(DeptCode),MachCode=$Get(MachCode),TCCode=$Get(TCCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	Set (MachName,MachDate,TCode,TCName,TCMean,TCSD,TCCV,TCNum,TCMaxEpis,TCMaxResult,TCMinEpis,TCMinResult)=""
	Set Num=0
	For CurDate=StartDate:1:EndDate Do
	.Set MachDate=CurDate
	.Set MachDate=$ZD(MachDate,3)
	.If $Data(^DHCMTCT(CurDate)) Do
	..Set CurMachCode="" For  Set CurMachCode=$Order(^DHCMTCT(CurDate,CurMachCode)) Quit:CurMachCode=""  Do
	...If $Length(MachCode),MachCode'=CurMachCode Quit
	...Set CurHospCode=$Piece($Get(^[LabNameSpace]DHCMachinePara(CurMachCode)),"\",7)
	...Set MachineDept=$Piece($Get(^[LabNameSpace]DHCMachinePara(CurMachCode)),"\",1) 
	...Set MachName=$Piece($Get(^TMIF(CurMachCode)),"\",1)
	...If $Length(DeptCode),DeptCode'=MachineDept Quit
	...If $Length(HospCode),HospCode'=CurHospCode Quit
	...Set CurTCCode="" For  Set CurTCCode=$Order(^DHCMTCT(CurDate,CurMachCode,CurTCCode)) Quit:CurTCCode=""  Do
	....Set TCode=CurTCCode
	....If $Length(TCCode),TCCode'[CurTCCode Quit
	....Set TCName=$Piece($Get(^TTAB("TC",CurTCCode)),"\",1)
	....Set StrData=$Get(^DHCMTCT(CurDate,CurMachCode,CurTCCode))
	....Set TCMean=$Piece(StrData,"^",2)
	....Set TCSD=$Piece(StrData,"^",3)
	....Set TCCV=""
	....If +TCMean'=0 Set TCCV=$Fn((TCSD/TCMean)*100,",",3)
	....Set TCNum=$Piece(StrData,"^",1)
	....Set TCMaxEpis=$Piece(StrData,"^",5)
	....Set TCMaxResult=$Piece(StrData,"^",4)
	....Set TCMinEpis=$Piece(StrData,"^",7)
	....Set TCMinResult=$Piece(StrData,"^",6)
	....Set Num=Num+1
	....Do OutputRow
	If (Num<1) Do
	.Set (MachName,MachDate,TCode,TCName,TCMean,TCSD,TCCV,TCNum,TCMaxEpis,TCMaxResult,TCMinEpis,TCMinResult)=""
	.Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(MachName,MachDate,TCode,TCName,TCMean,TCSD,TCCV,TCNum,TCMaxEpis,TCMaxResult,TCMinEpis,TCMinResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryStatMachTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStatMachTCExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20130520
/// Description:： 查询仪器结果汇总
/// Table：        
/// Input：        HospCode:医院代码,DeptCode:科室代码,MachCode:仪器代码,TCCode:项目代码集合,StartDate:开始日期,EndDate:结束日期
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryStatMachTC(HospCode As %String, DeptCode As %String, MachCode As %String, TCCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Query(ROWSPEC = "MachName,MachDate,TCode,TCName,TCMean,TCSD,TCCV,TCNum,TCMaxEpis,TCMaxResult,TCMinEpis,TCMinResult") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20150506
/// Description:： 查询一段时间业务数据的趋势图
/// Table：        DHCQC_MachineTCTotal
/// Input：        StartDate:开始日期,EndDate:结束日期,MachCode:仪器代码,TCCode:项目代码
/// Output：       strData:数据返回值
/// Return：       0
/// Others：
/// d ##class(web.DHCQCStatMachineResult).QueryMachResult("2015-05-01","2015-05-06","AC1500","A1130")
ClassMethod QueryMachResult(StartDate, EndDate, MachCode, TCCode) As %String
{
	s StartDate=$g(StartDate),EndDate=$g(EndDate),MachCode=$g(MachCode),TCCode=$g(TCCode)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	i '$l(MachCode) q 0
	i '$l(TCCode) q 0
	s Num=0,TestX=0,avgSD="",StrData=""

	f CurDate=StartDate:1:EndDate d
	.i $d(^DHCMTCT(CurDate,MachCode,TCCode)) d
	..s Num=Num+1
	..s StrData=$g(^DHCMTCT(CurDate,MachCode,TCCode))
	..s ^TMP($ZU(67,15,$j),$J,Num)=$p(StrData,"^",2)_"|"_$p($zd(CurDate,3),"-",3)
	..s TestX=$p(StrData,"^",2)+TestX
	
	//计算值输出。
	i Num>0 d
	.s TotalX=0
	.s avgX=TestX/Num
	.s CurNum="" f  s CurNum=$o(^TMP($ZU(67,15,$j),$J,CurNum)) q:CurNum=""  d
	..s TestReult=$p(^TMP($ZU(67,15,$j),$J,CurNum),"|",1)
	..s TotalX=TotalX+(avgX-TestReult)*(avgX-TestReult)
	.s avgSD=$ZSQR(TotalX/(Num))
	.s decimal=$l($p(TestX,".",2))
	.s avgX=$fn(avgX,"",decimal),avgSD=$fn(avgSD,"",decimal)
	
	//结果值输出
	i Num>0 d
	.s StrData=""
	.s StrData=avgX_"|"_avgSD
	.s CurNum="" f  s CurNum=$o(^TMP($ZU(67,15,$j),$J,CurNum)) q:CurNum=""  d
	..s StrData=StrData_"!"_$g(^TMP($ZU(67,15,$j),$J,CurNum))
	b ;09
	q StrData
}

Storage Default
{
<Data name="DHCQCStatMachineResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCStatMachineResultD</DataLocation>
<DefaultData>DHCQCStatMachineResultDefaultData</DefaultData>
<IdLocation>^web.DHCQCStatMachineResultD</IdLocation>
<IndexLocation>^web.DHCQCStatMachineResultI</IndexLocation>
<StreamLocation>^web.DHCQCStatMachineResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
