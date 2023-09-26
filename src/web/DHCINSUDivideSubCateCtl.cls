Import SQLUser

/// Create by WangL 2017-06-28 
Class web.DHCINSUDivideSubCateCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right ]
{

Parameter BUILD = 682;

/// 保存HIS分类信息
ClassMethod InsertHisCateInfo(InStr As %String) As %String
{
	q:InStr="" 100
	s ReturnFlag=""
	q:$p(InStr,"^",4)="" -100
	s Rowid=$$CheckINDIS^DHCINSUDivideSubCate(InStr)
	
	i Rowid="" d
	
	.s ReturnFlag=$$InsertDivideSubCate^DHCINSUDivideSubCate(InStr)
	e     d
	.i $d(^DHCINDIVS(Rowid)) d

	..s:$p(InStr,"^",1)="" InStr=Rowid_InStr	;Zhan 20150418
	..s ReturnFlag=$$UpdateDivideSubCate^DHCINSUDivideSubCate(InStr)
	.e      d

	..s ReturnFlag=$$InsertDivideSubCate^DHCINSUDivideSubCate(InStr)
	q ReturnFlag
}

/// 保存医保分类信息
ClassMethod InsertInsuCateInfo(InStr As %String) As %String
{
	q:InStr="" 100
	s ReturnFlag=""
	q:$p(InStr,"^",5)="" -100
	s Rowid=$$CheckINDISCate^DHCINSUDivideSubCate(InStr)
	
	i Rowid="" d
	.s ReturnFlag=$$InsertDivideSubCate^DHCINSUDivideSubCate(InStr)

	e     d
	.i $d(^DHCINDIVS(Rowid)) d
    
	..s:$p(InStr,"^",1)="" InStr=Rowid_InStr	;Zhan 20150418
	..s ReturnFlag=$$UpdateDivideSubCate^DHCINSUDivideSubCate(InStr)
	.e      d
    
	..s ReturnFlag=$$InsertDivideSubCate^DHCINSUDivideSubCate(InStr)
	q ReturnFlag
}

ClassMethod DaleteSubCate(BillNo As %String) As %String
{
	q:(+BillNo<1) "-1"
	&sql(delete from INSU_DivideSubCate where INDIVS_PB_Dr=:BillNo)
	q SQLCODE
}

/// w ##class(web.DHCINSUDivideSubCateCtl).UpdateDivSubCateByBillDr("202865","997")
ClassMethod UpdateDivSubCateByBillDr(BillNo As %String, DivDr As %String) As %String
{
	q:(+BillNo<1) "-1"
	&sql(Update INSU_DivideSubCate set INDIVS_DivideDr=:DivDr where INDIVS_PB_Dr=:BillNo)
	q SQLCODE
}

/// Creator：      WangL
/// CreatDate：    20170702
/// Description:： 根据账单号获取Insu_divide表数据保存Insu_divideSubCate
/// Table：        Insu_divide,Insu_divideSubCate
/// Input：        账单号
/// Output：       保存标识
/// Return：       大于0成功否则失败
/// w ##class(web.DHCINSUDivideSubCateCtl).Save("6030313","")
ClassMethod Save(BillNo As %String, DivideDr As %String) As %String
{
	
	
	q:(+BillNo<1) -1
	k ^||CacheTemp("INSUDivSubHisCate")
	k ^||CacheTemp("INSUDivSubInsuCate")
	s Flag="-1"
	s AmountSum="0"
	s INDIVSDate="",INDIVSTime="",INDIVSTCJJ="0",INDIVSYLXZF="0",INDIVSJLFY="0",INDIVSYLFY="0",INDIVSBLFY="0",INDIVSDLFY="0",INDIVSGRZFFY="0",INDIVSCXJZFFY="0"
    s INDIVSDemo1="",INDIVSDemo2="",INDIVSDemo3="",INDIVSDemo4="",INDIVSDemo5=""
	s INDIVSYLXZFSum="0",INDIVSGRZFFYSum="0",INDIVSCXJZFFYSum="0",INDIVSTCJJSum="0",INDIVSJLFYSum="0",INDIVSYLFYSum="0",INDIVSBLFYSum="0",INDIVSDLFYSum="0"
	s IndisDr=0
	f  s IndisDr=$o(^DHCINDIS("0","PBDr",BillNo,IndisDr))  q:IndisDr=""    d
	.s Flag=$p($g(^DHCINDIS(IndisDr)),"^",18)
	.q:Flag'="N"
	.;s DivideDr=$p($g(^DHCINDIS(IndisDr)),"^",1)	;upt 20220624
	.;s Amount=$p($g(^DHCINDIS(IndisDr)),"^",13)                           ;HIS金额
	.s Amount=$p($g(^DHCINDIS(IndisDr)),"^",19)                            ;医保返回金额    (每家医院字段不固定)
	.s TarItemDr=$p($g(^DHCINDIS(IndisDr)),"^",3)
	.s InsuTarItemDr=$p($g(^DHCINDIS(IndisDr)),"^",4)
	.s InsuCate=$p($g(^DHCINTIM(InsuTarItemDr)),"^",1)
	.i InsuCate=""  s Intimdlbm="91"                                       ;如果未对照,默认医保分类为91其他
	.s Intimbxbl=$p($g(^DHCINTIM(InsuTarItemDr)),"^",18)                   ;自付比例
	.s HisCate=$p($g(^DHCTARI(TarItemDr)),"^",4)
	.s HisCateCode=$p($g(^DHCTarC("SC",HisCate)),"^",1)
	.s INDIVSYLXZF=$p($g(^DHCINDIS(IndisDr)),"^",17)                       ;乙类先自付费用  (每家医院字段不固定)
	.s INDIVSGRZFFY=$p($g(^DHCINDIS(IndisDr)),"^",20)                      ;个人自费费用    (每家医院字段不固定)
	.s INDIVSCXJZFFY=$p($g(^DHCINDIS(IndisDr)),"^",26)                     ;超限价自付费用  (每家医院字段不固定)
	.s INDIVSTCJJ=Amount-INDIVSYLXZF-INDIVSGRZFFY-INDIVSCXJZFFY            ;统筹基金支付范围内费用(金额合计-乙类先自付费用-个人自费费用-超限价自付费用)
	.s Xmlb=$p($g(^DHCINDIS(IndisDr)),"^",10)                              ;项目类别(甲乙丙丁类)(有的医院可能存的编码) 
	.i Xmlb="甲类"   d
	..s INDIVSJLFY=Amount * (1-Intimbxbl)
	..s INDIVSYLFY=0,INDIVSBLFY=0,INDIVSBLFY=0,INDIVSDLFY=0
	.e  i Xmlb="乙类"   d
	..s INDIVSYLFY=Amount * (1-Intimbxbl)
	..s INDIVSJLFY=0,INDIVSBLFY=0,INDIVSDLFY=0
	.e  i Xmlb="丙类"   d
	..s INDIVSBLFY=Amount * Intimbxbl                                      ;(丙类医保目录自付比例都是1,有待确定?)
	..s INDIVSJLFY=0,INDIVSYLFY=0,INDIVSDLFY=0
	.e   d
	..s INDIVSDLFY=Amount * Intimbxbl                                      
	..s INDIVSJLFY=0,INDIVSYLFY=0,INDIVSBLFY=0
	
	.;按照HIS子分类汇总(存Gloabl)
	.;                                                  INSUDivide指针 账单号  医院收费类别代码 医保收费类别代码  统计日期         
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)=DivideDr_"^"_BillNo_"^"_HisCateCode_"^"_InsuCate_"^"_INDIVSDate
	.;                                                                                                               时间           金额       统筹范围内      乙类先自付     甲类
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)=^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)_"^"_INDIVSTime_"^"_Amount_"^"_INDIVSTCJJ_"^"_INDIVSYLXZF_"^"_INDIVSJLFY
	.;                                                                                                               乙类费用       丙类费用       丁类费用       个人自费          超限价自付
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)=^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)_"^"_INDIVSYLFY_"^"_INDIVSBLFY_"^"_INDIVSDLFY_"^"_INDIVSGRZFFY_"^"_INDIVSCXJZFFY
	.;                                                                                                               预留1           预留2           预留3           预留4           预留5 
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)=^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)_"^"_INDIVSDemo1_"^"_INDIVSDemo2_"^"_INDIVSDemo3_"^"_INDIVSDemo4_"^"_INDIVSDemo5
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"Amount")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"Amount"))+Amount
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLXZF")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLXZF"))+INDIVSYLXZF
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSGRZFFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSGRZFFY"))+INDIVSGRZFFY
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSCXJZFFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSCXJZFFY"))+INDIVSCXJZFFY
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSTCJJ")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSTCJJ"))+INDIVSTCJJ
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSJLFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSJLFY"))+INDIVSJLFY
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLFY"))+INDIVSYLFY
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSBLFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSBLFY"))+INDIVSBLFY
	.s ^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSDLFY")=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSDLFY"))+INDIVSDLFY
	
	.;按照医保分类汇总
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)=DivideDr_"^"_BillNo_"^"_HisCateCode_"^"_InsuCate_"^"_INDIVSDate
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)=^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)_"^"_INDIVSTime_"^"_Amount_"^"_INDIVSTCJJ_"^"_INDIVSYLXZF_"^"_INDIVSJLFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)=^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)_"^"_INDIVSYLFY_"^"_INDIVSBLFY_"^"_INDIVSDLFY_"^"_INDIVSGRZFFY_"^"_INDIVSCXJZFFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)=^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate)_"^"_INDIVSDemo1_"^"_INDIVSDemo2_"^"_INDIVSDemo3_"^"_INDIVSDemo4_"^"_INDIVSDemo5
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"Amount")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"Amount"))+Amount
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSYLXZF")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSYLXZF"))+INDIVSYLXZF
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSGRZFFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSGRZFFY"))+INDIVSGRZFFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSCXJZFFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSCXJZFFY"))+INDIVSCXJZFFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSTCJJ")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSTCJJ"))+INDIVSTCJJ
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSJLFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSJLFY"))+INDIVSJLFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSYLFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSYLFY"))+INDIVSYLFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSBLFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSBLFY"))+INDIVSBLFY
	.s ^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSDLFY")=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,InsuCate,"INDIVSDLFY"))+INDIVSDLFY
	
	
	
	;抽取数据
	;循环HIS分类,保存HIS分类数据
	s Flag=..GetDivSubHisCateInfo(BillNo)
    k ^||CacheTemp("INSUDivSubHisCate")
    
	;循环医保分类,保存医保分类数据
	s Flag=..GetDivSubInsuCateInfo(BillNo)
    k ^||CacheTemp("INSUDivSubInsuCate")
    q Flag
}

/// 根据账单号取患者就诊,登记,结算,明细,分类汇总信息
/// WangL
/// Creator：      WangL
/// CreatDate：    20170707
/// Description:： 根据账单号取患者就诊,登记,结算,明细,分类汇总信息
/// Table：        Pa_adm,Insu_AdmInfo，Insu_divide,Insu_dividesub,Insu_divideSubCate
/// Input：        账单号
/// Output：       Pa_adm
/// w ##class(web.DHCINSUDivideSubCateCtl).QueryDivSubCateInfo("6030313")
ClassMethod QueryIPPatientInfo(BillNo As %String) As %String
{
   
    s OutStr=""
    q:$d(^DHCINDIVS("0","PBDr","TarCate",BillNo))=0 OutStr
    s TarCate=""
    f  s TarCate=$o(^DHCINDIVS("0","PBDr","TarCate",BillNo,TarCate))  q:TarCate=""  d
    .s Rowid=""
    .f  s Rowid=$o(^DHCINDIVS("0","PBDr","TarCate",BillNo,TarCate,Rowid)) q:Rowid=""  d
    ..s InsuDivSubCateInfo=$g(^DHCINDIVS(Rowid))
    ..i OutStr=""  d 
    ...s OutStr=InsuDivSubCateInfo
    ..e   d
    ...s OutStr=OutStr_"!"_InsuDivSubCateInfo
    q OutStr
}

ClassMethod QueryIPPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCINSUDivideSubCateCtl","QueryIPPatientInfo","10028211")

ClassMethod QueryIPPatientInfoExecute(ByRef qHandle As %Binary, BillNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:BillNo="" $$$OK
	s i=0,k=0
	s Name="",Sex="",InsuID="",AdmseriNo="",Idate=""
	s AdmDate="",OutDate="",TARIJXDesc="",HisCode="",HisDesc=""
	s InsuDesc="",Price="",Qty="",Amount="",GrzfAmount=""
	s XzfAmount="",QtySum=0,AmountSum=0,GrzfAmountSum=0,XzfAmountSum=0
	s QtySum1=0,AmountSum1=0,GrzfAmountSum1=0,XzfAmountSum1=0
	;获取基本,就诊,结算信息
	 
	q:$d(^DHCINDIV("0","DHCPB",BillNo))=0 $$$OK
	s DivID=""
	f  s DivID=$o(^DHCINDIV("0","DHCPB",BillNo,DivID)) q:DivID=""  d
	.s Flag=$p($g(^DHCINDIV(DivID)),"^",5)
	.q:Flag'="I"
	.s InsuID=$p($g(^DHCINDIV(DivID)),"^",18)                ;社保编号
	.s AdmseriNo=$p($g(^DHCINDIV(DivID)),"^",30)             ;住院号
	.s Idate=$p($g(^DHCINDIV(DivID)),"^",16) 
	.S Idate=$zd(Idate,3)
	.s ITime=$p($g(^DHCINDIV(DivID)),"^",17)
	.s ITime=$zt(ITime,3)
	.s ITime=$tr(ITime,"AM","")
    .S ITime=$TR(ITime,"PM","")
	.s Idate=Idate_" "_ITime                                 ;结算时间
	.s AdmDr=$p($g(^DHCINDIV(DivID)),"^",1)
	.q:AdmDr=""
	.s AdmInfoDr=$p($g(^DHCINDIV(DivID)),"^",2)
	.q:AdmInfoDr=""
	.s PapmiDr=$p($g(^PAADM(AdmDr)),"^",1) 
	.q:PapmiDr=""
	.s Name=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)              ;姓名
	.s SexDr=$p($g(^PAPER(PapmiDr,"ALL")),"^",7)
	.q:SexDr="" 
	.s Sex=$p($g(^CT("SEX",SexDr)),"^",2)                    ;性别 
	.s AdmDate=$p($g(^PAADM(AdmDr)),"^",6) 
	.s AdmDate=$zd(AdmDate,3) 
	.s AdmTime=$p($g(^PAADM(AdmDr)),"^",7)  
	.s AdmTime=$zt(AdmTime,3)
    .s AdmTime=$tr(AdmTime,"AM","")
    .S AdmTime=$TR(AdmTime,"PM","")
	.s AdmDate=AdmDate_" "_AdmTime                           ;入院时间
	.s OutDate=$p($g(^PAADM(AdmDr)),"^",17)
	.s OutDate=$zd(OutDate,3)   
	.s OutTime=$p($g(^PAADM(AdmDr)),"^",18)
	.s OutTime=$zt(OutTime,3)
	.s OutTime=$tr(OutTime,"AM","")
    .S OutTime=$TR(OutTime,"PM","")
	.s OutDate=OutDate_" "_OutTime                           ;出院时间
	.;d Build1
	;获取明细信息
	q:$d(^DHCINDIS("0","PBDr",BillNo))=0 $$$OK
    s DivSubDr=""
    f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillNo,DivSubDr))  q:DivSubDr=""  d
    .s Flag=$p($g(^DHCINDIS(DivSubDr)),"^",18)
    .q:Flag'="N"
    .s TarItmDr=$p($g(^DHCINDIS(DivSubDr)),"^",3)
    .q:TarItmDr=""
    .s ArcItmDr=$p($g(^DHCINDIS(DivSubDr)),"^",2)
    .q:ArcItmDr=""
    .s TarItmDr=$p($g(^DHCINDIS(DivSubDr)),"^",3)
    .s TarCate=$p($g(^DHCTARI(TarItmDr)),"^",4)
    .s TarCateCode=$p($g(^DHCTarC("SC",TarCate)),"^",1)
    .s TarCateDesc=$p($g(^DHCTarC("SC",TarCate)),"^",2)
    .s TARIJX=$$GetjxbyArcDr^DHCINSUFacade(ArcItmDr)
    .s TARIJX=$p(TARIJX,"^",2)                       ;剂型
    .s HisCode=$p($g(^DHCTARI(TarItmDr)),"^",1)              ;医院收费项目编码
    .s HisDesc=$p($g(^DHCTARI(TarItmDr)),"^",2)              ;医院收费项目名称
    .s InsuDesc=$p($g(^DHCINDIS(DivSubDr)),"^",8)            ;医保收费项目名称
    .s Price=$p($g(^DHCINDIS(DivSubDr)),"^",12)              ;单价
    .s Qty=$p($g(^DHCINDIS(DivSubDr)),"^",11)                ;数量
    .s Amount=$p($g(^DHCINDIS(DivSubDr)),"^",19)             ;金额
    .s GrzfAmount=$p($g(^DHCINDIS(DivSubDr)),"^",20)         ;自费金额
    .s XzfAmount=$p($g(^DHCINDIS(DivSubDr)),"^",17)          ;先自付金额
    .s i=i+1
    .s ^CacheTempTarCateDesc("TarCateDesc",$j,TarCateDesc,i)=HisCode_"^"_HisDesc_"^"_InsuDesc_"^"_TARIJX_"^"_Price_"^"_Qty_"^"_Amount_"^"_GrzfAmount_"^"_XzfAmount
    
    
     ;获取分类汇总信息
     s TarCateDescNew=""
     f  s TarCateDescNew=$o(^CacheTempTarCateDesc("TarCateDesc",$j,TarCateDescNew)) q:TarCateDescNew=""  d
     .f  s k=$o(^CacheTempTarCateDesc("TarCateDesc",$j,TarCateDescNew,k)) q:k=""  d
     ..s TarCateDescInfo=$g(^CacheTempTarCateDesc("TarCateDesc",$j,TarCateDescNew,k))
     ..s HisCode=$p(TarCateDescInfo,"^",1)
     ..s HisDesc=$p(TarCateDescInfo,"^",2)
     ..s InsuDesc=$p(TarCateDescInfo,"^",3)
     ..s TARIJX=$p(TarCateDescInfo,"^",4)
     ..s Price=$p(TarCateDescInfo,"^",5)
     ..s Qty=$p(TarCateDescInfo,"^",6)  
     ..s Amount=$p(TarCateDescInfo,"^",7)
     ..s GrzfAmount=$p(TarCateDescInfo,"^",8)
     ..s XzfAmount=$p(TarCateDescInfo,"^",9)
     ..s QtySum=QtySum+Qty
	 ..s AmountSum=AmountSum+Amount
	 ..s GrzfAmountSum=GrzfAmountSum+GrzfAmount
	 ..s XzfAmountSum=XzfAmountSum+XzfAmount
	 
	 ..s QtySum1=QtySum1+Qty
	 ..s AmountSum1=AmountSum1+Amount
	 ..s GrzfAmountSum1=GrzfAmountSum1+GrzfAmount
	 ..s XzfAmountSum1=XzfAmountSum1+XzfAmount
	 
     ..d Build2
	 
	 .s HisCode="", HisDesc=TarCateDescNew_"小计",InsuDesc="",TARIJX="",Price="",Qty=QtySum,Amount=AmountSum,GrzfAmount=GrzfAmountSum,XzfAmount=XzfAmountSum
	 .d Build2
	 .s QtySum=0,AmountSum=0,GrzfAmountSum=0,XzfAmountSum=0
	
	 ;s Name="",Sex="",InsuID="",AdmseriNo="",AdmDate="",OutDate="",Idate=""
	 s HisCode="", HisDesc="费用合计",InsuDesc="",TARIJX="",Price="",Qty=QtySum1,Amount=AmountSum1,GrzfAmount=GrzfAmountSum1,XzfAmount=XzfAmountSum1
	 d Build2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Build2
    
	set Data=$lb(Name,Sex,InsuID,AdmseriNo,AdmDate,OutDate,Idate,HisCode,HisDesc,TARIJX,InsuDesc,Price,Qty,Amount,GrzfAmount,XzfAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryIPPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPPatientInfoExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryIPPatientInfo(BillNo As %String) As %Query(ROWSPEC = "Name:%String,Sex:%String,InsuID:%String,AdmseriNo:%String,AdmDate:%String,OutDate:%String,Idate:%String,HisCode:%String,HisDesc:%String,TARIJX:%String,InsuDesc:%String,Price:%String,Qty:%String,Amount:%String,GrzfAmount:%String,XzfAmount:%String") [ SqlProc ]
{
}

/// Creator：      WangL
/// CreatDate：    20170702
/// Description:： 抽取数据把HIS分类保存Insu_divideSubCate
/// Table：        Insu_divideSubCate
/// Input：        账单号
/// Output：       保存标识
/// Return：       大于0成功否则失败
ClassMethod GetDivSubHisCateInfo(BillNo As %String) As %String
{
    
    s HisCateCode=""
	f   s HisCateCode=$o(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode)) q:HisCateCode=""   d
	.s Amount=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"Amount"))
    .s DivideDr=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",1)
    .s BillNo=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",2)
    .s HisCateCode=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",3)
    .s Intimdlbm=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",4)
    .s INDIVSDate=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",5)
    .s INDIVSTime=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",6)
	.s Intimdlbm=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",7)
	.s INDIVSTCJJ=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSTCJJ"))
	.s INDIVSYLXZF=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLXZF"))
	.s INDIVSJLFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSJLFY"))
	.s INDIVSYLFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSYLFY"))
	.s INDIVSBLFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSBLFY"))
	.s INDIVSDLFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSDLFY"))
	.s INDIVSGRZFFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSGRZFFY"))
	.s INDIVSCXJZFFY=+$g(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode,"INDIVSCXJZFFY"))
	.s INDIVSDemo1=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",16)
	.s INDIVSDemo2=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",17)
	.s INDIVSDemo3=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",18)
	.s INDIVSDemo4=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",19)
	.s INDIVSDemo5=$p(^||CacheTemp("INSUDivSubHisCate",BillNo,HisCateCode),"^",20)
	
	.s Instring="^"_DivideDr_"^"_BillNo_"^"_HisCateCode_"^"_""_"^"_INDIVSDate
	.s Instring=Instring_"^"_INDIVSTime_"^"_Amount_"^"_INDIVSTCJJ_"^"_INDIVSYLXZF_"^"_INDIVSJLFY
	.s Instring=Instring_"^"_INDIVSYLFY_"^"_INDIVSBLFY_"^"_INDIVSDLFY_"^"_INDIVSGRZFFY_"^"_INDIVSCXJZFFY
	.s Instring=Instring_"^"_INDIVSDemo1_"^"_INDIVSDemo2_"^"_INDIVSDemo3_"^"_INDIVSDemo4_"^"_INDIVSDemo5
    .TSTART
    .s Flag=..InsertHisCateInfo(Instring)
    .i Flag>0 d
    .tcommit
    .e  d    
    .trollback
    
    q Flag
}

/// Creator：      WangL
/// CreatDate：    20170702
/// Description:： 抽取数据把医保分类保存Insu_divideSubCate
/// Table：        Insu_divideSubCate
/// Input：        账单号
/// Output：       保存标识
/// Return：       大于0成功否则失败
ClassMethod GetDivSubInsuCateInfo(BillNo As %String) As %String
{
    s INSUDivSubCate=""
	f   s INSUDivSubCate=$o(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate)) q:INSUDivSubCate=""   d
	.s Amount=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"Amount"))
    .s DivideDr=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",1)
    .s BillNo=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",2)
    .s HisCateCode=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",3)
    .s Intimdlbm=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",4)
    .s INDIVSDate=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",5)
    .s INDIVSTime=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",6)
	.s Intimdlbm=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",7)
	.s INDIVSTCJJ=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSTCJJ"))
	.s INDIVSYLXZF=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSYLXZF"))
	.s INDIVSJLFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSJLFY"))
	.s INDIVSYLFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSYLFY"))
	.s INDIVSBLFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSBLFY"))
	.s INDIVSDLFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSDLFY"))
	.s INDIVSGRZFFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSGRZFFY"))
	.s INDIVSCXJZFFY=+$g(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate,"INDIVSCXJZFFY"))
	.s INDIVSDemo1=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",16)
	.s INDIVSDemo2=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",17)
	.s INDIVSDemo3=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",18)
	.s INDIVSDemo4=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",19)
	.s INDIVSDemo5=$p(^||CacheTemp("INSUDivSubInsuCate",BillNo,INSUDivSubCate),"^",20)
	
	.s Instring="^"_DivideDr_"^"_BillNo_"^"_""_"^"_Intimdlbm_"^"_INDIVSDate
	.s Instring=Instring_"^"_INDIVSTime_"^"_Amount_"^"_INDIVSTCJJ_"^"_INDIVSYLXZF_"^"_INDIVSJLFY
	.s Instring=Instring_"^"_INDIVSYLFY_"^"_INDIVSBLFY_"^"_INDIVSDLFY_"^"_INDIVSGRZFFY_"^"_INDIVSCXJZFFY
	.s Instring=Instring_"^"_INDIVSDemo1_"^"_INDIVSDemo2_"^"_INDIVSDemo3_"^"_INDIVSDemo4_"^"_INDIVSDemo5
    .TSTART
    .s Flag=..InsertInsuCateInfo(Instring)
    .i Flag>0 d
    .tcommit
    .e  d    
    .trollback
    
    q Flag
}

/// w ##class(web.DHCINSUDivideSubCateCtl).DeleteSubCate("51615176")
ClassMethod DeleteSubCate(BillNo As %String) As %String
{
    q:(+BillNo<1) "-1"
    &sql(delete from INSU_DivideSubCate where INDIVS_PB_Dr=:BillNo)
    q SQLCODE
}

}
