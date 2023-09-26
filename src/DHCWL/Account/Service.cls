/// 名称: DHCWL.Account.Service
/// 描述: 未结账单和在院病人费用
/// 编写者：ycm 
/// 编写日期:2017-03-04
Class DHCWL.Account.Service Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 未结账单和在院病人费用使用中参数初始化过程
/// ycm 2017-03-04
/// d ##Class(DHCWL.Account.Service).InitSysPara()
ClassMethod InitSysPara() As %Status
{
	/// 根据DHCWorkLoad的收费项目的分类导数据
	s ^DHCWLAccountServie("Stat")=40
	
	/// 任务失败的错误记录global
	/// ^DHCWLAccountServie("Err")
	
	/// 任务运行开始日期和结束日期记录
	/// ^DHCWLAccountServie("Task")
	
	q 1
}

/// 收费项目分类描述解析输出：Id^Desc
ClassMethod GetStatDesc(Id As %String) As %String
{
	n (Id)
	d ##Class(DHCWL.Account.Service).InitSysPara()
	s DataNod=+$g(^DHCWLAccountServie("Stat"))
	
	s ret=""
	q:+Id=0 ret
	i DataNod=40 d   ///会计分类
	.q:'$d(^DHCTarC("AC",Id))
	.s TARTACDr=$P(^DHCTarC("AC",Id),"^",3)
	.s TARTACDesc=$P(^DHCTarC("TAC",TARTACDr),"^",2)
	.s ret=TARTACDr_"^"_TARTACDesc
	
	i DataNod=41 d
	.q:'$d(^DHCTarC("EC",Id))
	.s TARTECDr=$P(^DHCTarC("EC",Id),"^",3)
	.s TARTECDesc=$P(^DHCTarC("TEC",TARTECDr),"^",2)
	.s ret=TARTECDr_"^"_TARTECDesc
	
	i DataNod=42 d
	.q:'$d(^DHCTarC("IC",Id))
	.s TARTICDr=$P(^DHCTarC("IC",Id),"^",3)
	.s TARTICDesc=$P(^DHCTarC("TIC",TARTICDr),"^",2)
	.s ret=TARTICDr_"^"_TARTICDesc
	
	i DataNod=43 d
	.q:'$d(^DHCTarC("MC",Id))
	.s TARTMCDr=$P(^DHCTarC("MC",Id),"^",3)
	.s TARTMCDesc=$P(^DHCTarC("TMC",TARTMCDr),"^",2)
	.s ret=TARTMCDr_"^"_TARTMCDesc
	
	i DataNod=44 d
	.q:'$d(^DHCTarC("OC",Id))
	.s TARTOCDr=$P(^DHCTarC("OC",Id),"^",3)
	.s TARTOCDesc=$P(^DHCTarC("TOC",TARTOCDr),"^",2)
	.s ret=TARTOCDr_"^"_TARTOCDesc
	
	i DataNod=45 d
	.q:'$d(^DHCTarC("SC",Id))
	.s TARTSCDr=$P(^DHCTarC("SC",Id),"^",3)
	.s TARTCCDesc=$P(^DHCTarC("CC",TARTSCDr),"^",2)
	.s ret=TARTSCDr_"^"_TARTCCDesc
	
	q ret
}

/// Creator：      ycm
/// CreatDate：    2017-03-04
/// Description:   在院病人费用按照科室、病区、费用分类输出上期余额、本期应收、本期实收、本期余额
/// Table：       
/// Input：        SDate开始日期,EDate 结束日期,RowList:(科室、病区、项目);ColList:(总费用、医保费用、折扣费用、自付费用)
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","GetBalanceDetails","2017-06-02","2017-06-02","PatDep,PatWard,TARAC","fee,PayorShare,DisAmount,PatientShare")
Query GetBalanceDetails(SDate As %String, EDate As %String, RowList As %String = "", ColList As %String = "", HospList As %Text = "") As %Query(ROWSPEC = "PatDepdr:%String,PatDepDesc:%String,PatWardr:%String,PatWardDesc:%String,TARACDr:%String,TARACDesc:%String,DateIndex:%String,DataNod:%String,DataNodDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod GetBalanceDetailsExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, RowList As %String = "", ColList As %String = "", HospList As %Text = "") As %Status
{
	n (qHandle,SDate,EDate,RowList,ColList,HospList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(SDate="")||(EDate="") $$$OK
    
    k ^TEMPDHCWL($j)
    
    d ##Class(DHCWL.Account.Service).split(HospList,",","HospId")  ///分割医院字符串
    
    s SDate=$zdh(SDate,3)
    s EDate=$zdh(EDate,3)
    
    d ..QueryC(SDate-1,"C","LastC")  ///上期余额
    d ..QueryC(EDate,"C","C")     ///本期余额
    
    f day=SDate:1:EDate d
    .d ..QueryC(day,"H","H")
    .d ..QueryC(day,"I","I")
    

    s Nod=""
    f  s Nod=$O(^TEMPDHCWL($j,"Detail",Nod)) q:Nod=""  d
    .s PatDepdr=$P(Nod,",",1)
    .s PatWardr=$P(Nod,",",2)
    .s TARACDr=$P(Nod,",",3)
    .s PatDepDesc="",PatWardDesc="",TARACDesc=""
    .s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    .s HospId=+ret
    .q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
    .i (RowList="")||(RowList["PatDep") d
    ..s PatDepDesc=$P($g(^CTLOC(PatDepdr)),"^",2)
    ..i PatDepDesc="" s PatDepDesc="Null"
    ..i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
    .i (RowList="")||(RowList["PatWard") d
    ..s PatWardDesc=$P($g(^CTLOC(PatWardr)),"^",2)
    ..i PatWardDesc="" s PatWardDesc="Null"
    ..i PatWardDesc["-" s PatWardDesc=$P(PatWardDesc,"-",2)
    .i (RowList="")||(RowList["TARAC") d
    ..s ret=..GetStatDesc(TARACDr)
    ..s TARACDesc=$P(ret,"^",2)
    .s DateIndex=""
    .f  s DateIndex=$O(^TEMPDHCWL($j,"Detail",Nod,DateIndex)) q:DateIndex=""  d
    ..s DataNod=""
    ..f  s DataNod=$O(^TEMPDHCWL($j,"Detail",Nod,DateIndex,DataNod)) q:DataNod=""  d
    ...q:(ColList'="")&&(ColList'[DataNod)   ///内容过滤
    ...s DataNodDesc=$Case(DataNod,"fee":"总费用","PayorShare":"医保费用","DisAmount":"折扣费用","PatientShare":"自付费用")
    ...s value=+$g(^TEMPDHCWL($j,"Detail",Nod,DateIndex,DataNod))
    ...q:+value=0
	...s Data=$lb(PatDepdr,PatDepDesc,PatWardr,PatWardDesc,TARACDr,TARACDesc,DateIndex,DataNod,DataNodDesc,value)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q
    k ^TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetBalanceDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBalanceDetailsExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetBalanceDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBalanceDetailsExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ycm
/// CreatDate：    2017-03-04
/// Description:   在院病人费用按照日期输出上期余额、本期应收、本期实收、本期余额以及未结费用,用来检验数据是从什么日期开始不对
/// Table：       
/// Input：        SDate开始日期,EDate 结束日期
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","AccQuery","2017-03-03","2017-03-03","fee,PayorShare,DisAmount,PatientShare")
Query AccQuery(SDate As %String, EDate As %String, ColList As %String, HospList As %Text = "") As %Query(ROWSPEC = "date:%String,DataNod:%String,DataNodDesc:%String,LastC:%Float,H:%Float,I:%Float,C:%Float,UnPaid:%Float,PaidPBTomFee:%Float,flag:%Integer") [ SqlProc ]
{
}

ClassMethod AccQueryExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, ColList As %String, HospList As %Text = "") As %Status
{
	n (qHandle,SDate,EDate,ColList,HospList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(SDate="")||(EDate="") $$$OK
    
    k ^TEMPDHCWL($j)
    
    d ##Class(DHCWL.Account.Service).split(HospList,",","HospId")  ///分割医院字符串

    
    s SDate=$zdh(SDate,3)
    s EDate=$zdh(EDate,3)
    
    
    /// 取在院病人费用
    f day=SDate:1:EDate d
    .d ..QuerydayC(day,"H","H",HospList)
    .d ..QuerydayC(day,"I","I",HospList)
    .d ..QuerydayC(day,"C","C",HospList)
    .d ..GetUnPaidDetailsday(day,"C","UnPaid",HospList)  ///未结账单的余额
    .d ..GetPaidPBTomFeebyDay(day,HospList)   ///已结账单的明日医嘱
    
    s day=""
    f  s day=$O(^TEMPDHCWL($j,"Detail",day)) q:day=""  d
    .s DataNod=""
    .f  s DataNod=$O(^TEMPDHCWL($j,"Detail",day,DataNod)) q:DataNod=""  d
    ..q:(ColList'="")&&(ColList'[DataNod)   ///内容过滤
    ..s DataNodDesc=$Case(DataNod,"fee":"总费用","PayorShare":"医保费用","DisAmount":"折扣费用","PatientShare":"自付费用")
    ..s C=+$g(^TEMPDHCWL($j,"Detail",day,DataNod,"C"))
    ..s H=+$g(^TEMPDHCWL($j,"Detail",day,DataNod,"H"))
    ..s I=+$g(^TEMPDHCWL($j,"Detail",day,DataNod,"I"))
    ..s UnPaid=+$g(^TEMPDHCWL($j,"Detail",day,DataNod,"UnPaid"))
    ..s PaidPBTomFee=+$g(^TEMPDHCWL($j,"Detail",day,DataNod,"TomFee"))
    ..s LastC=C+I-H
    ..s flag=0
    ..i C+PaidPBTomFee'=UnPaid s flag=1
	..s Data=$lb($zd(day,3),DataNod,DataNodDesc,LastC,H,I,C,UnPaid,PaidPBTomFee,flag)
    ..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	..q
    k ^TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod AccQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AccQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccQueryExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ycm
/// CreatDate：    2017-03-07
/// Description:   在院病人费用余额 按照科室和费用分类来统计 
/// Table：       
/// Input：        Qday:日期,flag:(0->全部,1->出院病人,2->在院病人)
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","BalancePatDepItem","2017-03-03","0","fee,PayorShare,DisAmount,PatientShare")
Query BalancePatDepItem(Qday As %String, flag As %String, ColList As %String, HospList As %Text = "") As %Query(ROWSPEC = "PatDepdr:%String,PatDepDesc:%String,TARTACdr:%String,TARACDesc:%String,DataNod:%String,DataNodDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod BalancePatDepItemExecute(ByRef qHandle As %Binary, Qday As %String, flag As %String, ColList As %String, HospList As %Text = "") As %Status
{
	n (qHandle,Qday,flag,ColList,HospList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(Qday="") $$$OK
    
    k ^TEMPDHCWL($j)
    
    d ##Class(DHCWL.Account.Service).split(HospList,",","HospId")  ///分割医院字符串

    
    s day=$zdh(Qday,3)
    
    s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalanceType",PeriodDr," C",DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s PatDepdr=obj.PatDepdr
	..s PatWardr=obj.PatWardr
	..s ItemDr=obj.TARACDr
	..s PBRowid=obj.PBRowid
	..s fee=obj.fee
	..s PayorShare=obj.PayorShare
	..s DisAmount=obj.DisAmount
	..s PatientShare=obj.PatientShare
	..d obj.%Close()
	..s DisDate=$P(^PAADM(Admid),"^",17)
	..q:(+flag=1)&&(DisDate="")   ///出院病人
	..q:(+flag=1)&&(DisDate>day)
	..q:(+flag=2)&&(DisDate'="")&&(DisDate<=day)   ///day日期在院的病人
 	..s ^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"fee")=$g(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"fee"))+$g(fee)
 	..s ^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"PayorShare")=$g(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"PayorShare"))+$g(PayorShare)
 	..s ^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"DisAmount")=$g(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"DisAmount"))+$g(DisAmount)
 	..s ^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"PatientShare")=$g(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,"PatientShare"))+$g(PatientShare)
 	
    s PatDepdr=""
    f  s PatDepdr=$O(^TEMPDHCWL($j,"Detail",PatDepdr)) q:PatDepdr=""  d
    .s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    .s HospId=+ret
    .q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
    .s PatDepDesc=$P($g(^CTLOC(PatDepdr)),"^",2)
    .i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
    .s ItemDr=""
    .f  s ItemDr=$O(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr)) q:ItemDr=""  d
    ..s ret=..GetStatDesc(ItemDr)
    ..s TARACDesc=$P(ret,"^",2)
    ..s TARTACdr=$P(ret,"^",1)
    ..s DataNod=""
    ..f  s DataNod=$O(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,DataNod)) q:DataNod=""  d
    ...q:(ColList'="")&&(ColList'[DataNod)   ///内容过滤
    ...s DataNodDesc=$Case(DataNod,"fee":"总费用","PayorShare":"医保费用","DisAmount":"折扣费用","PatientShare":"自付费用")
    ...s value=+$g(^TEMPDHCWL($j,"Detail",PatDepdr,ItemDr,DataNod))
    ...q:+value=0
    ...
	...s Data=$lb(PatDepdr,PatDepDesc,TARTACdr,TARACDesc,DataNod,DataNodDesc,value)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q
    k ^TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod BalancePatDepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BalancePatDepItemExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BalancePatDepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BalancePatDepItemExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取day日期的余额,根据DataNod存值
ClassMethod QueryC(day As %String, DateIndex As %String, DataNod As %String) As %String
{
	n (day,DateIndex,DataNod)
	q:+day=0 $$$OK
	q:(day="")||(DataNod="")||(DateIndex="") $$$OK
	
	s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalanceType",PeriodDr," "_DateIndex,DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s PatDepdr=obj.PatDepdr
	..s PatWardr=obj.PatWardr
	..s ItemDr=obj.TARACDr
	..s PBRowid=obj.PBRowid
	..s fee=obj.fee
	..s PayorShare=obj.PayorShare
	..s DisAmount=obj.DisAmount
	..s PatientShare=obj.PatientShare
	..d obj.%Close()
	..s Nod=PatDepdr_","_PatWardr_","_ItemDr
 	..s ^TEMPDHCWL($j,"Detail",Nod,DataNod,"fee")=$g(^TEMPDHCWL($j,"Detail",Nod,DataNod,"fee"))+$g(fee)
 	..s ^TEMPDHCWL($j,"Detail",Nod,DataNod,"PayorShare")=$g(^TEMPDHCWL($j,"Detail",Nod,DataNod,"PayorShare"))+$g(PayorShare)
 	..s ^TEMPDHCWL($j,"Detail",Nod,DataNod,"DisAmount")=$g(^TEMPDHCWL($j,"Detail",Nod,DataNod,"DisAmount"))+$g(DisAmount)
 	..s ^TEMPDHCWL($j,"Detail",Nod,DataNod,"PatientShare")=$g(^TEMPDHCWL($j,"Detail",Nod,DataNod,"PatientShare"))+$g(PatientShare)
 	
 	q $$$OK
}

/// 获取day日期的余额,根据日期和DataNod存值
ClassMethod QuerydayC(day As %String, DateIndex As %String, DataNod As %String, HospList As %Text = "") As %String
{
	n (day,DateIndex,DataNod,HospList)
	q:+day=0 $$$OK
	q:(day="")||(DataNod="")||(DateIndex="") $$$OK
	
	s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalanceType",PeriodDr," "_DateIndex,DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s PatDepdr=obj.PatDepdr
	..s PatWardr=obj.PatWardr
	..s ItemDr=obj.TARACDr
	..s PBRowid=obj.PBRowid
	..s fee=obj.fee
	..s PayorShare=obj.PayorShare
	..s DisAmount=obj.DisAmount
	..s PatientShare=obj.PatientShare
	..d obj.%Close()
    ..s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    ..s HospId=+ret
    ..q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
 	..s ^TEMPDHCWL($j,"Detail",day,"fee",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"fee",DataNod))+$g(fee)
 	..s ^TEMPDHCWL($j,"Detail",day,"PayorShare",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"PayorShare",DataNod))+$g(PayorShare)
 	..s ^TEMPDHCWL($j,"Detail",day,"DisAmount",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"DisAmount",DataNod))+$g(DisAmount)
 	..s ^TEMPDHCWL($j,"Detail",day,"PatientShare",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"PatientShare",DataNod))+$g(PatientShare)
 	
 	q $$$OK
}

/// 获取未结账单的余额，根据日期来存储
ClassMethod GetUnPaidDetailsday(day As %String, DateIndex As %String, DataNod As %String, HospList As %Text = "") As %String
{
	n (day,DateIndex,DataNod,HospList)
	q:+day=0 $$$OK
	q:(day="")||(DataNod="")||(DateIndex="") $$$OK
	
	s PeriodDr=""
	f  s PeriodDr=$O(^DHCWL.Account.UnPaidPeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.UnPaidDetailsI("UnPaidType",PeriodDr," "_DateIndex,DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.UnPaidDetails).%OpenId(+DetailsId)
	..q:obj=""
	..s fee=obj.fee
	..s PayorShare=obj.PayorShare
	..s DisAmount=obj.DisAmount
	..s PatientShare=obj.PatientShare
	..s PatDepdr=obj.PatDepdr
	..d obj.%Close()
    ..s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    ..s HospId=+ret
    ..q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
 	..s ^TEMPDHCWL($j,"Detail",day,"fee",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"fee",DataNod))+$g(fee)
 	..s ^TEMPDHCWL($j,"Detail",day,"PayorShare",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"PayorShare",DataNod))+$g(PayorShare)
 	..s ^TEMPDHCWL($j,"Detail",day,"DisAmount",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"DisAmount",DataNod))+$g(DisAmount)
 	..s ^TEMPDHCWL($j,"Detail",day,"PatientShare",DataNod)=$g(^TEMPDHCWL($j,"Detail",day,"PatientShare",DataNod))+$g(PatientShare)

	q $$$OK
}

/// 已结账单的明日医嘱按日期存储
ClassMethod GetPaidPBTomFeebyDay(day As %String, HospList As %Text = "") As %String
{
	n (day,HospList)
	s Id=0
	f  s Id=$O(^DHCWL.Account.PaidPBTomFeeI("day",day,Id)) q:+Id=0  d
	.s obj=##Class(DHCWL.Account.PaidPBTomFee).%OpenId(+Id)
	.q:obj=""
	.s Admid=obj.Admid
	.s fee=obj.fee
	.s PayorShare=obj.PayorShare
	.s DisAmount=obj.DisAmount
	.s PatientShare=obj.PatientShare
	.s PatDepdr=obj.PatDepdr
	.d obj.%Close()
	.s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    .s HospId=+ret
    .q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
 	.s ^TEMPDHCWL($j,"Detail",day,"fee","TomFee")=$g(^TEMPDHCWL($j,"Detail",day,"fee","TomFee"))+$g(fee)
 	.s ^TEMPDHCWL($j,"Detail",day,"PayorShare","TomFee")=$g(^TEMPDHCWL($j,"Detail",day,"PayorShare","TomFee"))+$g(PayorShare)
 	.s ^TEMPDHCWL($j,"Detail",day,"DisAmount","TomFee")=$g(^TEMPDHCWL($j,"Detail",day,"DisAmount","TomFee"))+$g(DisAmount)
 	.s ^TEMPDHCWL($j,"Detail",day,"PatientShare","TomFee")=$g(^TEMPDHCWL($j,"Detail",day,"PatientShare","TomFee"))+$g(PatientShare)
	
	q $$$OK
}

/// Creator：      ycm
/// CreatDate：    2017-03-07
/// Description:   在院病人费用病人明细数据 
/// Table：       
/// Input：        Qday:日期,flag:(0->全部,1->出院病人,2->在院病人),Admid
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","BalancePatDetails","2022-08-20","0","")
Query BalancePatDetails(Qday As %String, flag As %String, AdmidList As %Text = "", HospList As %Text = "") As %Query(ROWSPEC = "Admid:%String,PatNo:%String,PatMedNo:%String,PatName:%String,PatAge:%String,PatSex:%String,READesc:%String,admDate:%String,disDate:%String,MRDesc:%String,PatDepDesc:%String,PatWardDesc:%String,PATLastC:%Float,PATH:%Float,PATI:%Float,PATC:%Float,UnPaid:%Float,PaidPBTomFee:%Float,PATDeposit:%Float,Status:%String,UnPaidTomFee:%Float,flag:%Integer,LastAmt:%Float,HAmt:%Float,IAmt:%Float") [ SqlProc ]
{
}

ClassMethod BalancePatDetailsExecute(ByRef qHandle As %Binary, Qday As %String, flag As %String, AdmidList As %Text = "", HospList As %Text = "") As %Status
{
	n (qHandle,Qday,flag,AdmidList,HospList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(Qday="") $$$OK
    
    k ^TEMPDHCWL($j)
    
    d ##Class(DHCWL.Account.Service).split(HospList,",","HospId")  ///分割医院字符串

    
    s day=$zdh(Qday,3)
    s Lastday=+day-1   ///上期
    
    ///上期余额
    s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",Lastday,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalanceType",PeriodDr," C",DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s fee=obj.fee
	..d obj.%Close()
 	..s ^TEMPDHCWL($j,"Admid",Admid,"LastC","fee")=$g(^TEMPDHCWL($j,"Admid",Admid,"LastC","fee"))+$g(fee)

	///本期数据
    s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalancePeriod",PeriodDr,DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s Type=obj.BalanceDetailsType
	..s fee=obj.fee
	..d obj.%Close()
 	..s ^TEMPDHCWL($j,"Admid",Admid,Type,"fee")=$g(^TEMPDHCWL($j,"Admid",Admid,Type,"fee"))+$g(fee)
 	.///预交金
 	.s DepositDr=0
 	.f  s DepositDr=$O(^DHCWL.Account.DepositI("PeriodDr",PeriodDr,DepositDr)) q:DepositDr=""  d
 	..s obj=##Class(DHCWL.Account.Deposit).%OpenId(+DepositDr)
 	..q:obj=""
 	..s Admid=obj.Admid
 	..q:+Admid=26
 	..s fee=obj.fee
 	..s (LastAmt,HAmt,HAmt)=0
 	..s depositBlId=$o(^DHCWL.Account.DepositBalanceI("dateAdmCodeIdx",day,Admid,""))
 	..i depositBlId'="" d
 	...s LastAmt=$lg(^DHCWL.Account.DepositBalanceD(depositBlId),6)
 	...s HAmt=$lg(^DHCWL.Account.DepositBalanceD(depositBlId),7)
 	...s HAmt=$lg(^DHCWL.Account.DepositBalanceD(depositBlId),8)
 	..s ^TEMPDHCWL($j,"Admid",Admid,"Deposit","LastAmt")=$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","LastAmt"))+$g(LastAmt)
 	..s ^TEMPDHCWL($j,"Admid",Admid,"Deposit","HAmt")=$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","HAmt"))+$g(HAmt)
 	..s ^TEMPDHCWL($j,"Admid",Admid,"Deposit","IAmt")=$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","IAmt"))+$g(IAmt)
 	..s ^TEMPDHCWL($j,"Admid",Admid,"Deposit","fee")=$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","fee"))+$g(fee)
 	

	///未结余额
	s PeriodDr=""
	f  s PeriodDr=$O(^DHCWL.Account.UnPaidPeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.UnPaidDetailsI("UnPaidType",PeriodDr," C",DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.UnPaidDetails).%OpenId(+DetailsId)
	..q:obj=""
	..s fee=obj.fee
	..s Admid=obj.Admid
	..d obj.%Close()
 	..s ^TEMPDHCWL($j,"Admid",Admid,"UnPaid","fee")=$g(^TEMPDHCWL($j,"Admid",Admid,"UnPaid","fee"))+$g(fee)

	///已结账单的明日医嘱
	s Id=0
	f  s Id=$O(^DHCWL.Account.PaidPBTomFeeI("day",day,Id)) q:+Id=0  d
	.s obj=##Class(DHCWL.Account.PaidPBTomFee).%OpenId(+Id)
	.q:obj=""
	.s Admid=obj.Admid
	.s fee=obj.fee
	.d obj.%Close()
 	.s ^TEMPDHCWL($j,"Admid",Admid,"PaidPBTomFee","fee")=$g(^TEMPDHCWL($j,"Admid",Admid,"PaidPBTomFee","fee"))+$g(fee)

	/// 未结账单的明日医嘱费用=未结账单的总费用-未结账单的费用
	s Id=0
	f  s Id=$O(^DHCWL.Account.UnPaidPBI("day",day,Id)) q:Id=""  d
	.s obj=##Class(DHCWL.Account.UnPaidPB).%OpenId(+Id)
	.q:obj=""
	.s Admid=obj.Admid
	.s fee=obj.fee
	.d obj.%Close()
	.////记录的账单表总费用
 	.s ^TEMPDHCWL($j,"Admid",Admid,"UnPaidT","fee")=$g(^TEMPDHCWL($j,"Admid",Admid,"UnPaidT","fee"))+$g(fee)
	

	s Admid=""
	f  s Admid=$O(^TEMPDHCWL($j,"Admid",Admid)) q:Admid=""  d
	.q:(AdmidList'="")&&(AdmidList'=Admid)   
	.s Papmidr=$P(^PAADM(Admid),"^",1)
 	.s PatNo=$$GetPapmiNo^DHCWLCommon(Papmidr)
 	.s PatMedNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(Admid) ;$$GetPapmiMedtare^DHCWLCommon(Papmidr)
 	.s PatName=$$GetPapmiName^DHCWLCommon(Papmidr)
 	.s PatAge=$$GetAge^DHCWLCommon(Papmidr)
 	.s PatSex=$$GetSex^DHCWLCommon(Papmidr)
 	.s READesc=$$GetReason^DHCWLCommon(Admid)
 	.s admDate=$zd($p($g(^PAADM(Admid)),"^",6),3)
 	.s disDate=$p($g(^PAADM(Admid)),"^",17)
 	.i disDate'="" s disDate=$zd(disDate,3)
 	.e  s disDate=""
	.q:(+flag=1)&&(disDate="")   ///出院病人
	.q:(+flag=1)&&(disDate>day)
	.q:(+flag=2)&&(disDate'="")&&(disDate<=day)   ///day日期在院的病人
 	.s MRDesc=""    ///诊断描述
 	.s PatDepdr=$P(^PAADM(Admid),"^",4)
 	.s PatWardr=$P(^PAADM(Admid),"^",70)
	.s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    .s HospId=+ret
    .q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
 	.s PatDepDesc=$P($g(^CTLOC(PatDepdr)),"^",2)
 	.i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
 	.s PatWardDesc=$P($g(^PAWARD(PatWardr)),"^",2)
 	.i PatWardDesc["-" s PatWardDesc=$P(PatWardDesc,"-",2)
 	.s PATLastC=+$g(^TEMPDHCWL($j,"Admid",Admid,"LastC","fee"))   ///上期余额
 	.s PATH=+$g(^TEMPDHCWL($j,"Admid",Admid,"H","fee"))   ///本期应收
 	.s PATI=+$g(^TEMPDHCWL($j,"Admid",Admid,"I","fee"))   ///本期实收
 	.s PATC=+$g(^TEMPDHCWL($j,"Admid",Admid,"C","fee"))   ///本期余额
	.s LastAmt=+$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","LastAmt"))	//上期预交金余额
 	.s HAmt=+$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","HAmt"))	//本期预交金应收
 	.s IAmt=+$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","IAmt"))	//本期预交金实收
 	.s PATDeposit=+$g(^TEMPDHCWL($j,"Admid",Admid,"Deposit","fee"))   ///预交金
 	.s UnPaid=+$g(^TEMPDHCWL($j,"Admid",Admid,"UnPaid","fee"))   ///未结账单费用(不包含明日医嘱)
 	.s PaidPBTomFee=+$g(^TEMPDHCWL($j,"Admid",Admid,"PaidPBTomFee","fee"))   ///已结账单明日医嘱
 	.s UnPaidT=+$g(^TEMPDHCWL($j,"Admid",Admid,"UnPaidT","fee"))   ///未结账单的总费用(含明日医嘱)
 	.s UnPaidTomFee=UnPaidT-UnPaid   ///未结账单的明日医嘱费用
	.s tag=9999
	.s ret=..GetBillFlag(Admid,day)
	.s Billflag=$P(ret,"^",1) 
	.s Status= $P(ret,"^",2)
	.s numberflag1=PATC-UnPaid
	.s numberflag2=PATC+PaidPBTomFee-UnPaid
	.s numberflag1=$fn(numberflag1,"",2)
	.s numberflag2=$fn(numberflag2,"",2)
	.i (+numberflag1'=0)&&(+numberflag2'=0) s tag=1   ///余额+已结明日医嘱不等于账单未结余额
	.i (+numberflag1'=0)&&(+numberflag2=0) s tag=3    ///余额不等,但余额+已结明日医嘱=账单余额
	.i (+numberflag1=0)&&(PATC'=0)&&(Billflag="Y") s tag=2     ///病人有结算记录,但是还存在未结费用
	.q:(+PATLastC=0)&&(+PATH=0)&&(+PATI=0)&&(+PATC=0)&&(+PATDeposit=0)&&(+UnPaid=0)&&(+PaidPBTomFee=0)&&(+UnPaidT=0)
	.s Data=$lb(Admid,PatNo,PatMedNo,PatName,PatAge,PatSex,READesc,admDate,disDate,MRDesc,PatDepDesc,PatWardDesc,PATLastC,PATH,PATI,PATC,UnPaid,PaidPBTomFee,PATDeposit,Status,UnPaidTomFee,tag,LastAmt,HAmt,IAmt)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	.q
    k ^TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod BalancePatDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BalancePatDetailsExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BalancePatDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BalancePatDetailsExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断病人在日期之前是否结算过
ClassMethod GetBillFlag(Admid As %String, day As %String) As %String
{
	n (Admid,day)
	s ret="N"
	s flag="未产生费用"
	s tag="N"   ///day日期后结算标志
	k data
	s PBRowid=""
	f  s PBRowid=$O(^DHCPB(0,"ADM",Admid,PBRowid)) q:PBRowid=""  d
	.s Payedflag=$P(^DHCPB(PBRowid),"^",16)
	.s flagDate=$P(^DHCPB(PBRowid),"^",19)
	.s fee=$P(^DHCPB(PBRowid),"^",8)
	.q:+fee=0
	.i (Payedflag="P")&&(flagDate<=day) d
	..s ret="Y"
	.i (Payedflag="P")&&(flagDate>day) d
	..s tag="Y"
	.s data(Payedflag)=""
	
	
	
	
	i $D(data("P"))&&('$D(data("B")))  d
	.i tag="N" s flag="全部结算"
	.i tag="Y" s flag="当时未全部结算(现已全部结算)"
	i $D(data("B"))&&('$D(data("P")))  s flag="全部未结算"
	i $D(data("B"))&&($D(data("P")))  s flag="部分结算"
	k data
	
	q ret_"^"_flag
}

/// Creator：      ycm
/// CreatDate：    2017-03-07
/// Description:   病人费用明细 
/// Table：       
/// Input：        Admid
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","GetPatfee","")
Query GetPatfee(Admid As %String) As %Query(ROWSPEC = "OrdDate:%String,TARACDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetPatfeeExecute(ByRef qHandle As %Binary, Admid As %String) As %Status
{
	n (qHandle,Admid)
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:Admid="" $$$OK 
    d ##Class(DHCWL.Account.Service).InitSysPara()
    
    s DataNod=+$g(^DHCWLAccountServie("Stat"))
    q:+DataNod=0 $$$OK
   
   	k ^TEMPDHCWL($j)

  	s WLRowid=0
  	f  s WLRowid=$o(^DHCWorkLoad(0,"PAADM",Admid,WLRowid)) q:WLRowid=""  d
  	.s OrdDate=$p(^DHCWorkLoad(WLRowid),"^",5)
  	.s TARACDr=$p(^DHCWorkLoad(WLRowid),"^",DataNod)
  	.s fee=$p(^DHCWorkLoad(WLRowid),"^",16)
  	.s ^TEMPDHCWL($j,OrdDate,TARACDr)=$g(^TEMPDHCWL($j,OrdDate,TARACDr))+fee
 
 	s OrdDate=0 
 	f  s OrdDate=$o(^TEMPDHCWL($j,OrdDate)) q:OrdDate=""  d
 	.s TARACDr=0 f  s TARACDr=$o(^TEMPDHCWL($j,OrdDate,TARACDr)) q:TARACDr=""  d
 	..s fee=$g(^TEMPDHCWL($j,OrdDate,TARACDr))
    ..s ret=..GetStatDesc(TARACDr)
    ..s TARACDesc=$P(ret,"^",2)
	..set Data=$lb($zd(OrdDate,3),TARACDesc,fee)
 	..Set ^CacheTemp(repid,ind)=Data
 	..Set ind=ind+1
	..quit 	
 	
 	k ^TEMPDHCWL($j)
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod GetPatfeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatfeeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatfeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatfeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ycm
/// CreatDate：    2017-06-12
/// Description:   在院病人费用明细  表五
/// Table：       
/// Input：        Qday:日期,flag:(0->全部,1->出院病人,2->在院病人),Admid
/// Output：  
/// Return：      
/// Others：   
/// d ##class(%ResultSet).RunQuery("DHCWL.Account.Service","GetPatBalanceDetails","2017-03-03","0","")
Query GetPatBalanceDetails(Qday As %String, flag As %String, AdmidList As %Text = "", HospList As %Text = "") As %Query(ROWSPEC = "Admid:%String,PatNo:%String,PatMedNo:%String,PatName:%String,PatAge:%String,PatSex:%String,READesc:%String,admDate:%String,disDate:%String,MRDesc:%String,PatDepDesc:%String,PatWardDesc:%String,PATC:%Float,PATDeposit:%Float,Status:%String,TARACDr:%String,TARACDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetPatBalanceDetailsExecute(ByRef qHandle As %Binary, Qday As %String, flag As %String, AdmidList As %Text = "", HospList As %Text = "") As %Status
{
	n (qHandle,Qday,flag,AdmidList,HospList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(Qday="") $$$OK
    
    k ^TEMPDHCWL($j)
    
    d ##Class(DHCWL.Account.Service).split(HospList,",","HospId")  ///分割医院字符串

    
    s day=$zdh(Qday,3)
    s Lastday=+day-1   ///上期
    
   
	///本期数据
    s PeriodDr=0
	f  s PeriodDr=$O(^DHCWL.Account.BalancePeriodI("PeriodDate",day,PeriodDr)) q:PeriodDr=""  d
	.s DetailsId=""
	.f  s DetailsId=$O(^DHCWL.Account.BalanceDetailsI("BalancePeriod",PeriodDr,DetailsId)) q:DetailsId=""  d
	..s obj=##Class(DHCWL.Account.BalanceDetails).%OpenId(DetailsId)
	..q:obj=""
	..s Admid=obj.Admid
	..s Type=obj.BalanceDetailsType
	..q:Type'="C"
	..s TARACDr=obj.TARACDr
	..s fee=obj.fee
	..d obj.%Close()
 	..s ^TEMPDHCWL($j,"Admid",Admid,Type,TARACDr,"fee")=$g(^TEMPDHCWL($j,"Admid",Admid,Type,TARACDr,"fee"))+$g(fee)
 	..s ^TEMPDHCWL($j,Type,Admid,"fee")=$g(^TEMPDHCWL($j,Type,Admid,"fee"))+$g(fee)
 	.///预交金
 	.s DepositDr=0
 	.f  s DepositDr=$O(^DHCWL.Account.DepositI("PeriodDr",PeriodDr,DepositDr)) q:DepositDr=""  d
 	..s obj=##Class(DHCWL.Account.Deposit).%OpenId(+DepositDr)
 	..q:obj=""
 	..s Admid=obj.Admid
 	..s fee=obj.fee
 	..s ^TEMPDHCWL($j,"Deposit",Admid,"fee")=$g(^TEMPDHCWL($j,"Deposit",Admid,"fee"))+$g(fee)
 	

	s Admid=""
	f  s Admid=$O(^TEMPDHCWL($j,"Admid",Admid)) q:Admid=""  d
	.q:(AdmidList'="")&&(AdmidList'=Admid)   
	.s Papmidr=$P(^PAADM(Admid),"^",1)
 	.s PatNo=$$GetPapmiNo^DHCWLCommon(Papmidr)
 	.s PatMedNo=##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(Admid) ;$$GetPapmiMedtare^DHCWLCommon(Papmidr)
 	.s PatName=$$GetPapmiName^DHCWLCommon(Papmidr)
 	.s PatAge=$$GetAge^DHCWLCommon(Papmidr)
 	.s PatSex=$$GetSex^DHCWLCommon(Papmidr)
 	.s READesc=$$GetReason^DHCWLCommon(Admid)
 	.s admDate=$zd($p($g(^PAADM(Admid)),"^",6),3)
 	.s disDate=$p($g(^PAADM(Admid)),"^",17)
 	.i disDate'="" s disDate=$zd(disDate,3)
 	.e  s disDate=""
	.q:(+flag=1)&&(disDate="")   ///出院病人
	.q:(+flag=1)&&(disDate>day)
	.q:(+flag=2)&&(disDate'="")&&(disDate<=day)   ///day日期在院的病人
 	.s MRDesc=""    ///诊断描述
 	.s PatDepdr=$P(^PAADM(Admid),"^",4)
 	.s PatWardr=$P(^PAADM(Admid),"^",70)
 	.s ret=##Class(DHCWL.Account.Service).GetHospbyLoc(PatDepdr)
    .s HospId=+ret
    .q:(HospList'="")&&('$d(^TEMPDHCWL($j,"S","HospId",+HospId)))   ///过滤医院
 	.s PatDepDesc=$P($g(^CTLOC(PatDepdr)),"^",2)
 	.i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
 	.s PatWardDesc=$P($g(^PAWARD(PatWardr)),"^",2)
 	.i PatWardDesc["-" s PatWardDesc=$P(PatWardDesc,"-",2)
 	.s PATC=+$g(^TEMPDHCWL($j,"C",Admid,"fee"))   ///本期余额
 	.s PATDeposit=+$g(^TEMPDHCWL($j,"Deposit",Admid,"fee"))   ///预交金
	.s ret=..GetBillFlag(Admid,day)
	.s Status= $P(ret,"^",2)
	.s Type=""
	.f  s Type=$O(^TEMPDHCWL($j,"Admid",Admid,Type)) q:Type=""  d
	..s TARACDr=""
	..f  s TARACDr=$O(^TEMPDHCWL($j,"Admid",Admid,Type,TARACDr)) q:TARACDr=""  d
	...s fee=+$g(^TEMPDHCWL($j,"Admid",Admid,Type,TARACDr,"fee"))
    ...s ret=..GetStatDesc(TARACDr)
    ...s TARACDesc=$P(ret,"^",2)
	...s Data=$lb(Admid,PatNo,PatMedNo,PatName,PatAge,PatSex,READesc,admDate,disDate,MRDesc,PatDepDesc,PatWardDesc,PATC,PATDeposit,Status,TARACDr,TARACDesc,fee)
    ...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	...q
    k ^TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPatBalanceDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBalanceDetailsExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatBalanceDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBalanceDetailsExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取账单表的状态和账单表的Update日期
ClassMethod GetPBStatus(PBRowid As %String) As %String
{
	n (PBRowid)
	s ret=""
	q:+PBRowid=0 ret
	q:'$d(^DHCPB(PBRowid)) ret
	s Status=$P(^DHCPB(PBRowid),"^",16)
	s UpDate=$P(^DHCPB(PBRowid),"^",19)
	
	s ret=Status_"^"_UpDate
	
	q ret
}

///  判断账单的状态是否是封账账单 
///  账单是P状态,但是没有对应的发票记录,过几天后在结算打发票,在此期间,账单属于应收费用
///  是：1,否：0
ClassMethod GetPBSealStatus(pbRowid As %String) As %String
{
	n (pbRowid)
	s ret=0
	q:+pbRowid=0 ret
	q:'$d(^DHCPB(pbRowid)) ret
	s Status=$P(^DHCPB(pbRowid),"^",16)
	q:Status'="P" ret
	
	q:'$d(^DHCINVPRTZY(0,"AR",pbRowid)) 1
	
	
	q ret
}

ClassMethod split(Str, sp, Nod) As %String
{
	n (Str,sp,Nod)
	q:(Str="")||(Nod="") ""
	i sp="" s sp=","
	f i=1:1:$L(Str,sp) d
	.s v=$P(Str,sp,i)
	.q:v=""
	.s ^TEMPDHCWL($j,"S",Nod,v)=""
	
	q 1
}

/// 通过科室获取医院
ClassMethod GetHospbyLoc(LocId As %String) As %String
{
	n (LocId)
	s ret=""
	q:+LocId=0 ret
	s HospId=$P($g(^CTLOC(+LocId)),"^",22)
	s HospDesc=$P($g(^CT("HOSP",+HospId)),"^",2)
	
	s ret=HospId_"^"_HospDesc
	
	q ret
}

}
