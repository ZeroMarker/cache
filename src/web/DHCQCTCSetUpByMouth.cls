/// 名称:     按月保存批次质控物靶值
/// 描述:     按月保存批次质控物靶值
/// 编写者：  DaiYi
/// 编写日期: 20140901
Class web.DHCQCTCSetUpByMouth Extends %Persistent
{

/// Creator：      DaiYi
/// CreatDate：    20140901
/// Description:： 按月保存批次质控物靶值
/// Table：        lab.DHCQCTestCodeByMouth
/// Input：        结果字符串,保存结果(成功返回0,失败返回-1^错误提示)
/// Output：       无
/// Return：       保存或者更新结果 
/// Others
/// d ##class(web.DHCQCTCSetUpByMouth).Save("")
ClassMethod Save(Record) As %String
{
	//s Record="CA1500||CA1500||A1130^1^2014^9^低值^3.64^0.20^^^^^^^^"
	s ParRef=$p(Record,"^",1)
	s Level=$p(Record,"^",2)
	s QCYear=+$p(Record,"^",3)
	s QCMouth=+$p(Record,"^",4)
	i ParRef="" q "质控物批次参数不能为空！"
	i Level="" q "浓度参数不能为空！"
	i QCYear="" q "年份参数不能为空！"
	i QCMouth="" q "月份参数不能为空！"
	//保存记录单
	s RowId=ParRef_"||"_QCYear_"||"_QCMouth
	s err=""
	i '$d(^DHCQCTCM(ParRef,Level,QCYear,QCMouth)) d
	.s objByMouth=##class(lab.DHCQCTestCodeByMouth).%New()
	.S objByMouth.DQCIParRef=ParRef
	.s objByMouth.DQCILevel=Level
	.S objByMouth.DQCIYear=QCYear
	.s objByMouth.DQCIMouth=QCMouth
	.S objByMouth.DQCITargetDesc=$p(Record,"^",5)
	.S objByMouth.DQCITargetValue=$p(Record,"^",6)
	.s objByMouth.DQCITargetSD=$p(Record,"^",7)
	.S objByMouth.DQCIDecimal=$p(Record,"^",8)
	.S objByMouth.DTCLLastMean=$p(Record,"^",9)
	.s objByMouth.DTCLLastCSD=$p(Record,"^",10)
	.S objByMouth.DQCILastcCV=$p(Record,"^",11)
	.S objByMouth.DQCILastTCSum=$p(Record,"^",12)
	.s objByMouth.DQCIComments1=$p(Record,"^",13)
	.S objByMouth.DQCIComments2=$p(Record,"^",14)
	.S objByMouth.DQCIComments3=$p(Record,"^",15)
	.s objByMouth.DQCIComments4=$p(Record,"^",16) 
	.s objByMouth.DQCIComments5=$p(Record,"^",17)
	.S objByMouth.DQCIComments6=$p(Record,"^",18)
	.S objByMouth.DQCIComments7=$p(Record,"^",19)
	.S objByMouth.DQCIComments8=$p(Record,"^",20)
    .s ret=objByMouth.%Save()
	.i ($SYSTEM.Status.IsOK(ret)) d
	.else  d 
	..s err=$SYSTEM.Status.GetErrorText(ret) 
	e  d
	.S DQCITargetDesc=$p(Record,"^",5)
	.S DQCITargetValue=$p(Record,"^",6)
	.s DQCITargetSD=$p(Record,"^",7)
	.S DQCIDecimal=$p(Record,"^",8)
	.//S objByMouth.DTCLLastMean=$p(Record,"^",9)
	.//s objByMouth.DTCLLastCSD=$p(Record,"^",10)
	.//S objByMouth.DQCILastcCV=$p(Record,"^",11)
	.//S objByMouth.DQCILastTCSum=$p(Record,"^",12)
	.//s objByMouth.DQCIComments1=$p(Record,"^",13)
	.//S objByMouth.DQCIComments2=$p(Record,"^",14)
	.//S objByMouth.DQCIComments3=$p(Record,"^",15)
	.//s objByMouth.DQCIComments4=$p(Record,"^",16) 
	.//s objByMouth.DQCIComments5=$p(Record,"^",17)
	.//S objByMouth.DQCIComments6=$p(Record,"^",18)
	.//S objByMouth.DQCIComments7=$p(Record,"^",19)
	.//S objByMouth.DQCIComments8=$p(Record,"^",20)
	.//为什么terminal下导出来的表，rowid不管用，不能要对象保存？至今未搞清楚
    .s $p(^DHCQCTCM(ParRef,Level,QCYear,QCMouth),"^",1)=DQCITargetDesc
    .s $p(^DHCQCTCM(ParRef,Level,QCYear,QCMouth),"^",2)=DQCITargetValue
    .s $p(^DHCQCTCM(ParRef,Level,QCYear,QCMouth),"^",3)=DQCITargetSD
    .s $p(^DHCQCTCM(ParRef,Level,QCYear,QCMouth),"^",4)=DQCIDecimal
    .s err=""
    .b ;123
    q err
}

/// Creator：      DaiYi
/// CreatDate：    20140901
/// Description:： 查询是否已经按月保存过记录，如果没有保存记录的话，需要保存所有的记录。
/// Table：        lab.DHCQCTestCodeByMouth
/// Input：        结果字符串,保存结果(成功返回0,失败返回-1^错误提示)
/// Output：       无
/// Return：       保存或者更新结果 
/// Others
/// d ##class(web.DHCQCTCSetUpByMouth).IsSave("CA1500||CA1500",1,2014,8)
ClassMethod IsSave(ParRef, Level, QCYear, QCMouth) As %String
{
	s Ret=0
	i $d(^DHCQCTCM(ParRef,Level,QCYear,QCMouth)) d
	.s Ret=1
	q Ret
}

/// Creator：      DaiYi
/// CreatDate：    20140903
/// Description:： 查询按月设定批次的数据信息。
/// Table：        lab.DHCQCTestCodeByMouth
/// Input：        ParRef:RowId,TcCode:项目代码,Year:年份,Mouth:月份
/// Output：       结果集合
/// Return：       
/// Others：
Query QueryTCInfByMouth(ParRef As %String, TcCode As %String, Year As %String, Mouth As %String) As %Query(ROWSPEC = "ParRef,LevelNo,Year,Mouth,TargetDesc,TargetValue,TargetSD,Decimal,LastMean,LastCSD,LastcCV,LastTCSum,ACTCMean,ACSD,isFlagSetUp") [ SqlProc ]
{
}

ClassMethod QueryTCInfByMouthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCInfByMouthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCQCTCSetUpByMouth","QueryTCInfByMouth","CA1500||CA1500","A1130","2014","8")
ClassMethod QueryTCInfByMouthExecute(ByRef qHandle As %Binary, ParRef As %String, TcCode As %String, Year As %String, Mouth As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	s Mouth=+Mouth
	s isFlag=0,ACTCMean="",ACSD=""
	//是否为手工设置。
	s isFlagSetUp="false"
	i $d(^DHCQCTCM(ParRef_"||"_TcCode)) d 
	.s LevelNo="" f  s LevelNo=$o(^DHCQCTCM(ParRef_"||"_TcCode,LevelNo)) q:LevelNo=""  d
	..i $d(^DHCQCTCM(ParRef_"||"_TcCode,LevelNo,Year,Mouth)) d
	...s StrData=$g(^DHCQCTCM(ParRef_"||"_TcCode,LevelNo,Year,Mouth))
	...s TargetDesc=$p(StrData,"^",1)
	...s TargetValue=$p(StrData,"^",2)
	...s TargetSD=$p(StrData,"^",3)
	...i Mouth=1 s LastYear=Year-1,LastMouth=12
	...e  s LastYear=Year,LastMouth=Mouth-1
	...s Ret=..QueryLastXSD(ParRef_"||"_TcCode_"||"_LevelNo,LastYear,LastMouth)
	...s LastMean=$p(Ret,"^",1)
	...s LastCSD=$p(Ret,"^",2)
	...s LastTCSum=$p(Ret,"^",3)
	...s LastcCV=""
	...s StrDataTC=$g(^DHCQCTC(ParRef,TcCode,LevelNo)) 
	...s Decimal=$p(StrDataTC,"^",8)
	...i LastMean>0 s LastcCV=$fn(LastCSD/LastMean,"",Decimal)
	...s ACTCMean=$p(StrDataTC,"^",15)
	...s ACSD=$p(StrDataTC,"^",16),isFlag=1,isFlagSetUp="true"
	...d Output
	e  d
	.s LevelNo="" f  s LevelNo=$o(^DHCQCTC(ParRef,TcCode,LevelNo)) q:LevelNo=""  d
	..s StrData=$g(^DHCQCTC(ParRef,TcCode,LevelNo))
	..i Mouth=1 s LastYear=Year-1,LastMouth=12
	..e  s LastYear=Year,LastMouth=Mouth-1
	..s Ret=##class(web.DHCQCTCSetUpByMouth).QueryLastXSD(ParRef_"||"_TcCode_"||"_LevelNo,LastYear,LastMouth)
	..s TargetDesc=$p(StrData,"^",5)
	..s TargetValue=$p(Ret,"^",1)
	..s TargetSD=$p(Ret,"^",2)
	..s TargetValue=$p(Ret,"^",1)
	..s Decimal=$p(StrData,"^",8)
	..s LastMean=$p(Ret,"^",1)
	..s LastCSD=$p(Ret,"^",2)
	..s LastTCSum=$p(Ret,"^",3)
	..s LastcCV=""
	..i LastMean>0 s LastcCV=$fn(LastCSD/LastMean,"",Decimal) 
	..s ACTCMean=$p(StrData,"^",15)
	..s ACSD=$p(StrData,"^",16),isFlag=1
	..//设定的改为批次汇总的
	..s TargetValue=ACTCMean,TargetSD=ACSD
	..d Output
	
	i isFlag=0 d
	.s LevelNo="" f  s LevelNo=$o(^DHCQCTC(ParRef,TcCode,LevelNo)) q:LevelNo=""  d
	..s StrData=$g(^DHCQCTC(ParRef,TcCode,LevelNo))
	..i Mouth=1 s LastYear=Year-1,LastMouth=12
	..e  s LastYear=Year,LastMouth=Mouth-1
	..s Ret=##class(web.DHCQCTCSetUpByMouth).QueryLastXSD(ParRef_"||"_TcCode_"||"_LevelNo,LastYear,LastMouth)
	..s TargetDesc=$p(StrData,"^",5)
	..s TargetValue=$p(Ret,"^",1)
	..s TargetSD=$p(Ret,"^",2)
	..s TargetValue=$p(Ret,"^",1)
	..s Decimal=$p(StrData,"^",8)
	..s LastMean=$p(Ret,"^",1)
	..s LastCSD=$p(Ret,"^",2)
	..s LastTCSum=$p(Ret,"^",3)
	..s LastcCV=""
	..i LastMean>0 s LastcCV=$fn(LastCSD/LastMean,"",Decimal) 
	..s ACTCMean=$p(StrData,"^",15)
	..s ACSD=$p(StrData,"^",16)
	..//设定的改为批次汇总的
	..s TargetValue=ACTCMean,TargetSD=ACSD
	..d Output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(ParRef,LevelNo,Year,Mouth,TargetDesc,TargetValue,TargetSD,Decimal,LastMean,LastCSD,LastcCV,LastTCSum,ACTCMean,ACSD,isFlagSetUp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTCInfByMouthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCInfByMouthExecute ]
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

ClassMethod QueryLastXSD(RowId, LastYear, LastMouth)
{
	s Ret=""
	s LastData=$g(^DHCQCAT(RowId,LastYear,LastMouth))
	s QCMean=$p(LastData,"^",4)
	s QCSD=$p(LastData,"^",5)
	s TCSum=$p(LastData,"^",3)
	s Ret=QCMean_"^"_QCSD_"^"_TCSum
	q Ret
}

Storage Default
{
<Data name="DHCQCTCSetUpByMouthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCTCSetUpByMouthD</DataLocation>
<DefaultData>DHCQCTCSetUpByMouthDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCTCSetUpByMouthD</IdLocation>
<IndexLocation>^web.DHCQCTCSetUpByMouthI</IndexLocation>
<StreamLocation>^web.DHCQCTCSetUpByMouthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
