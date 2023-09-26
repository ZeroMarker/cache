Import SQLUser

/// Create by Lou 2010-03-02 上海东方医院
Class web.DHCINSUDivideSubCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 443;

/// 核对明细上传记录与账单明细表记录，如果有未上传的明细就插入DIVIDESUB表
/// 入参：账单号
ClassMethod CheckDivSubByBillDr(BillDr As %String) As %String
{
	;n (BillDr)
	Q:BillDr="" "-1"
	s i=0,DivDr=""
	s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
	s AdmReasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	q:AdmReasonDr="" "-2"
	;s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6)
	q:InsuType="" "-3" 
	s BillOrd=0
	f  s BillOrd=$o(^DHCPB(BillDr,"O",BillOrd))  q:BillOrd=""   d
	.s PBODate=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",12)
	.q:PBODate=""
	.s ArcItmDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",3)
	.s OEORIDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",4)
	.s BillDetsub=0
	.f  s BillDetsub=$o(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	..s InsuItmDr="",InsuFlag="",InsuCode="",InsuDesc="",Qty="",Unit="",TotalAmount=""
	..s JyFy="",YBFee="",FYBFee="",Flzf=""
	..s TarDr=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",3)
	..q:TarDr=""
	..q:$g(^DHCTARI(TarDr))=""
	..s Qty=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",5) ;数量
	..s Unit=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",4) ;单价
	..s TotalAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",7) ;总额
	..s DiscAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",8)  ;折扣金额
	..s PayorAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",9) ;记帐金额 
    ..s PatAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",10)  ;自费金额
	..s OPSubCat=$p($g(^DHCTARI(TarDr)),"^",15)
	..s CateCode=$p(^DHCTarC("IC",OPSubCat),"^",1)
	..s factorID="",factor="" //dhc_tarfactor计费折扣比例表
	..f  s factorID=$o(^DHCTARF(0,"TARI",AdmReasonDr,TarDr,PBODate,factorID)) q:factorID=""  d
	...s factor=$p(^DHCTARF(factorID),"^",7) ;记账比例
	...s factor=1-factor ;自负比例
	..i factor=1 s InsuFlag="1" ;可报销标志 0：可报销项目  1：不可报销项目
	..e  s InsuFlag="0"
	..i InsuFlag="0" d
	...s JyFy=PayorAmount  ;交易费用总额
	...s YBFee=TotalAmount ;医保内费用
	...s FYBFee="0"        ;非医保费用
	...s Flzf=PatAmount    ;乙类自负
	..e  d
	...s JyFy="0"  ;交易费用总额
	...s YBFee="0" ;医保内费用
	...s FYBFee=TotalAmount   ;非医保费用
	...s Flzf="0"    ;乙类自负
	..s TarConInfo=$$CheckCon^DHCINSUTarContrast(TarDr,InsuType,PBODate,"")

	..s ConId=$p(TarConInfo,"!",2)
	..i ConId'="" d 
	...s InsuItmDr=$p($g(^DHCINTCT(ConId)),"^",4)
	...s InsuCode=$p($g(^DHCINTIM(InsuItmDr)),"^",3)
	...s InsuDesc=$p($g(^DHCINTIM(InsuItmDr)),"^",4)
	..s Str="^"_DivDr_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr
	..s Str=Str_"^"_BillDr_"^"_BillDr_"||"_BillOrd_"||"_BillDetsub_"^"_InsuCode_"^"_InsuDesc_"^"_""  //医保类别赋空
	..s Str=Str_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_OPSubCat_"^"_factor_"^"_JyFy_"^"_Flzf_"^"_"I"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"" //明细序号开始赋空
	..s Str=Str_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee_"^"_""_"^"_""_"^"_""
	..q:+TotalAmount=0
	..q:$p($$CheckFeesInsert^DHCINSUFacade(BillDr_"||"_BillOrd_"||"_BillDetsub),"^",1)="Y"
	..s rtncode=$$InsertDivideSub^DHCINSUDivide(Str)
	q 1
}

/// 根据账单号取账单明细(住院),用于保存到insu_dividesub表进行明细库上传
ClassMethod GetBillDetailsByBillDr(BillDr As %String) As %String
{
	n (BillDr)
	Q:BillDr="" "-1"
	k ^DHCINSUDivideSub("BillDr",BillDr)
	s i=0,DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCPB",BillDr,""),-1)
	s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
	s AdmReasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	q:AdmReasonDr=""
	s BillOrd=0
	f  s BillOrd=$o(^DHCPB(BillDr,"O",BillOrd))  q:BillOrd=""   d
	.s PBODate=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",12)
	.q:PBODate=""
	.s ArcItmDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",3)
	.s OEORIDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",4)
	.s BillDetsub=0
	.f  s BillDetsub=$o(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	..s InsuItmDr="",InsuFlag="",InsuCode="",InsuDesc="",Qty="",Unit="",TotalAmount=""
	..s JyFy="",YBFee="",FYBFee="",Flzf=""
	..s TarDr=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",3)
	..q:$g(^DHCTARI(TarDr))=""
	..s Qty=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",5) ;数量
	..s Unit=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",4) ;单价
	..s TotalAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",7) ;总额
	..s DiscAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",8)  ;折扣金额
	..s PayorAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",9) ;记帐金额 
    ..s PatAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",10)  ;自费金额
	..s OPSubCat=$p($g(^DHCTARI(TarDr)),"^",15)
	..s CateCode=$p(^DHCTarC("IC",OPSubCat),"^",1)
	..s factorID="",factor="" //dhc_tarfactor计费折扣比例表
	..f  s factorID=$o(^DHCTARF(0,"TARI",AdmReasonDr,TarDr,PBODate,factorID)) q:factorID=""  d
	...s factor=$p(^DHCTARF(factorID),"^",7) ;记账比例
	...s factor=1-factor ;自负比例
	..i factor=1 s InsuFlag="1" ;可报销标志 0：可报销项目  1：不可报销项目
	..e  s InsuFlag="0"
	..i InsuFlag="0" d
	...s JyFy=PayorAmount  ;交易费用总额
	...s YBFee=TotalAmount ;医保内费用
	...s FYBFee="0"        ;非医保费用
	...s Flzf=PatAmount    ;乙类自负
	..e  d
	...s JyFy="0"  ;交易费用总额
	...s YBFee="0" ;医保内费用
	...s FYBFee=TotalAmount   ;非医保费用
	...s Flzf="0"    ;乙类自负
	..s InsuType="SH"
	..s TarConInfo=$$CheckCon^DHCINSUTarContrast(TarDr,InsuType,PBODate)
	..s ConId=$p(TarConInfo,"!",2)
	..i ConId'="" d 
	...s InsuItmDr=$p($g(^DHCINTCT(ConId)),"^",4)
	...s InsuCode=$p($g(^DHCINTIM(InsuItmDr)),"^",3)
	...s InsuDesc=$p($g(^DHCINTIM(InsuItmDr)),"^",4)
	..s Str=DivDr_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr
	..s Str=Str_"^"_BillDr_"^"_BillDr_"||"_BillDetsub_"^"_InsuCode_"^"_InsuDesc_"^"_""  //医保类别赋空
	..s Str=Str_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_CateCode_"^"_factor_"^"_JyFy_"^"_Flzf_"^"_"1"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"" //明细序号开始赋空
	..s Str=Str_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee_"^"_""_"^"_""_"^"_""
	..s i=i+1
	..s ^DHCINSUDivideSub("BillDr",BillDr,i)=Str
	q i
}

/// 根据发票ID取账单明细(门诊),用于保存到insu_dividesub表进行明细库上传
ClassMethod GetBillDetailsByInvPrtDr(InvPrtDr As %String) As %String
{
	n (InvPrtDr)
	q:InvPrtDr="" "-1"
	k ^DHCINSUDivideSub("InvPrtDr",InvPrtDr)
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,""),-1)
	s Condr="",i=0
	f  s Condr=$o(^DHCBCI(0,"INV",InvPrtDr,Condr))  q:Condr=""  d
	.s BillDr=$p($g(^DHCBCI(Condr)),"^",2)
	.Q:BillDr=""
	.s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
	.s AdmReasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	.q:AdmReasonDr=""
	.s BillOrd=0
	.f  s BillOrd=$o(^DHCPB(BillDr,"O",BillOrd))  q:BillOrd=""   d
	..s PBODate=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",12)
	..q:PBODate=""
	..s ArcItmDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",3)
	..s OEORIDr=$p($g(^DHCPB(BillDr,"O",BillOrd)),"^",4)
	..s BillDetsub=0
	..f  s BillDetsub=$o(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	...w BillOrd,!
	...s InsuItmDr="",InsuFlag="",InsuCode="",InsuDesc="",Qty="",Unit="",TotalAmount=""
	...s JyFy="",YBFee="",FYBFee="",Flzf=""
	...s TarDr=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",3)
	...q:$g(^DHCTARI(TarDr))=""
	...s Qty=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",5) ;数量
	...s Unit=$p($g(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub)),"^",4) ;单价
	...s TotalAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",7) ;总额
	...s DiscAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",8)  ;折扣金额
	...s PayorAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",9) ;记帐金额 
    ...s PatAmount=$p(^DHCPB(BillDr,"O",BillOrd,"D",BillDetsub),"^",10)  ;自费金额
	...s OPSubCat=$p($g(^DHCTARI(TarDr)),"^",15)
	...s CateCode=$p(^DHCTarC("OC",OPSubCat),"^",1)
	...s factorID="",factor="" //dhc_tarfactor计费折扣比例表
	...f  s factorID=$o(^DHCTARF(0,"TARI",AdmReasonDr,TarDr,PBODate,factorID)) q:factorID=""  d
	....s factor=$p(^DHCTARF(factorID),"^",7) ;记账比例
	....i factor'="" s factor=1-factor ;自负比例
	...;;可报销标志 0：可报销项目  1：不可报销项目
	...i $j(PatAmount,3,2)=$j(TotalAmount,3,2) s InsuFlag="1" 
	...e  s InsuFlag="0"
	...i InsuFlag="0" d
	....s JyFy=PayorAmount  ;交易费用总额
	....s YBFee=TotalAmount ;医保内费用
	....s FYBFee="0"        ;非医保费用
	....s Flzf=PatAmount    ;乙类自负
	...e  d
	....s JyFy="0"  ;交易费用总额
	....s YBFee="0" ;医保内费用
	....s FYBFee=TotalAmount   ;非医保费用
	....s Flzf="0"    ;乙类自负
	...s InsuType="SH"
	...s TarConInfo=$$CheckCon^DHCINSUTarContrast(TarDr,InsuType,PBODate)
	...s ConId=$p(TarConInfo,"!",2)
	...i ConId'="" d 
	....s InsuItmDr=$p($g(^DHCINTCT(ConId)),"^",4)
	....s InsuCode=$p($g(^DHCINTIM(InsuItmDr)),"^",3)
	....s InsuDesc=$p($g(^DHCINTIM(InsuItmDr)),"^",4)
	...s Str=DivDr_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr
	...s Str=Str_"^"_BillDr_"^"_BillDr_"||"_BillOrd_"||"_BillDetsub_"^"_InsuCode_"^"_InsuDesc_"^"_""  //医保类别赋空
	...s Str=Str_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_CateCode_"^"_factor_"^"_JyFy_"^"_Flzf_"^"_"0"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"" //明细序号开始赋空
	...s Str=Str_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee_"^"_""_"^"_""_"^"_""
	...s i=i+1
	...s ^DHCINSUDivideSub("InvPrtDr",InvPrtDr,i)=Str
	q i
}

/// 保存医保结算明细信息
ClassMethod InsertDivInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
    s DisId=+$p(InString,"^",1)
    i DisId=0 d
    .s InsertDivInfo=$$InsertDivideSub^DHCINSUDivide(InString)
    e  d
    .i $d(^DHCINDIS(DisId))=0 d
    ..s InsertDivInfo=$$InsertDivideSub^DHCINSUDivide(InString)
    .e  d
    ..s InsertDivInfo=$$UpdateDivideSub^DHCINSUDivide(InString)

    q InsertDivInfo
}

ClassMethod SaveToDivSubSH(HisDr, Type) As %String
{
	n (HisDr, Type)
	q:(HisDr="") "-1"
	q:(Type'="O")&&(Type'="I") "-1"
	if Type="O" s jd="InvPrtDr"
	if Type="I" s jd="BillDr"
	s i="",success="true"
	f  s i=$o(^DHCINSUDivideSub(jd,HisDr,i)) q:i=""  d
	.s Str=$g(^DHCINSUDivideSub(jd,HisDr,i))
	.s Str=""_"^"_Str //拼上Rowid
	.s Flag=..InsertDivInfo(Str)
	.i Flag<1 s succes="false"
	i success="false" q "-2"
	i success="true"  q "1"
}

/// 上海取账单明细数据,用于保存到divsub表中
/// 入参:HisDr(门诊传InvPrtDr,住院传Billdr)
///      Type(O或I),SaveFlag(Y或N)
/// 出参: 小于1为错误
ClassMethod GetBillDetailsSH(HisDr, Type, SaveFlag) As %String
{
	n (HisDr, Type,SaveFlag)
	q:(HisDr="") "-1"
	q:(Type'="O")&&(Type'="I") "-1"
	if Type="O" s Flag=..GetBillDetailsByInvPrtDr(HisDr)
	if Type="I" s Flag=..GetBillDetailsByBillDr(HisDr)
	i SaveFlag="Y" d
	.i Flag>0 d
	..s Flag=..SaveToDivSubSH(HisDr,Type)
	q Flag
}

/// 保存医保结算明细信息
/// w ##class(web.DHCINSUDivideSubCtl).InsertDivInfoTest("")
ClassMethod InsertDivInfoTest(InString As %String) As %String
{
	;s Str=""_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr_"^"_BillDr_"^"_BillDr_"||"_BillOrd_"||"_BillDetsub_"^"_InsuCode
	;s Str=Str_"^"_InsuDesc_"^"_""_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_CateCode_"^"_factor_"^"_JyFy_"^"_Flzf  //医保类别赋空
	;s Str=Str_"^"_"0"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee
	;s Str=Str_"^"_""_"^"_""_"^"_""
	n (InString)
	s InsertDivInfo=""
	s i=0
    w !,$h
	f i=1:1:100000 d
	.s Str="210020"_"^"_""_"^"_1_"^"_1_"^"_1_"^"_1_"^"_1_"^"_"100"_"||"_"1"_"||"_"1"_"^"_1
	.s Str=Str_"^"_1_"^"_"10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"_"^"_1_"^"_1_"^"_1_"^"_1_"^"_1_"^"_1_"^"_1  //医保类别赋空
	.s Str=Str_"^"_"0"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_1_"^"_""_"^"_1_"^"_1
	.s Str=Str_"^"_""_"^"_""_"^"_""
	.s flag=..InsertDivInfo(Str)
    w !,$h
    q InsertDivInfo
}

/// 保存医保上传明细信息
/// w ##class(web.DHCINSUDivideSubCtl).SaveDivSubInfo(GlobalTyle,ID)
ClassMethod SaveDivSubInfoold(GlobalTyle As %String, ID As %String) As %String
{
	;s Str=""_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr_"^"_BillDr_"^"_PBDID_"^"_InsuCode_"^"_InsuDesc
	;s Str=Str_"^"_""_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_CateCode_"^"_factor_"^"_JyFy_"^"_Flzf_"^"_"0"_"^"_""
	;s Str=Str_"^"_""_"^"_""_"^"_""_"^"_""_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee_"^"_""_"^"_""
	;s Str=Str_"^"_""
	n (GlobalTyle, ID)
	s InsertDivInfo=""
	s i=0
	f  s i=$o(^CacheTemp(GlobalTyle,ID ,i)) q:i=""  d
	.s TempStrInfo=$g(^CacheTemp(GlobalTyle,ID ,i))
	.s BillDr=$p(TempStrInfo,"=",1)
	.s PatBillDetailsInfo=$p(TempStrInfo,"=",3)
	.;w !,PatBillDetailsInfo
	.s PBDTARIInfo=$p(TempStrInfo,"=",4)
	.s OEORDInfo=$p(TempStrInfo,"=",5)
	.s OEORDInfoTxt=$p(TempStrInfo,"=",6)    
	.s TarContrastInfo=$p(TempStrInfo,"=",7)
	.s ArcItmDr=$p(OEORDInfo,"^",15)
	.s TarDr=$p(PBDTARIInfo,"^",1)
	.s InsuItmDr=$p(TarContrastInfo,"^",5)
	.s OEORIDr=$p(PatBillDetailsInfo,"^",16)
	.s PBDID=$p(PatBillDetailsInfo,"^",15)
	.s InsuCode=$p(PBDTARIInfo,"^",57)
	.s InsuDesc=$p(PBDTARIInfo,"^",58)
	.s Qty=$p(PatBillDetailsInfo,"^",5)
	.s Unit=$p(PatBillDetailsInfo,"^",6)
	.s TotalAmount=$p(PatBillDetailsInfo,"^",7)
	.s flag=$$CheckFees^DHCINSUFacade(PBDID)		
	.q:flag="Y"
	.s Str=""_"^"_""_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr_"^"_BillDr_"^"_PBDID_"^"_InsuCode_"^"_InsuDesc
	.s Str=Str_"^"_""_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"I"_"^"_""    //收集费用的时候打上标志吗？
	.s Str=Str_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	.s Str=Str_"^"_""
	.//
	.s flag=..InsertDivInfo(Str)
	.i flag>=0 d
	..
	.
    q SaveDivSubInfo
}

/// 保存医保上传明细信息
/// w ##class(web.DHCINSUDivideSubCtl).SaveDivSubInfo(GlobalTyle,ID,i)
ClassMethod SaveDivSubInfo(GlobalTyle As %String, ID As %String, i As %String, AdmreasonCodeNo As %String) As %String
{
	;s Str=""_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr_"^"_BillDr_"^"_PBDID_"^"_InsuCode_"^"_InsuDesc
	;s Str=Str_"^"_""_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_CateCode_"^"_factor_"^"_JyFy_"^"_Flzf_"^"_"0"_"^"_""
	;s Str=Str_"^"_""_"^"_""_"^"_""_"^"_""_"^"_InsuFlag_"^"_""_"^"_YBFee_"^"_FYBFee_"^"_""_"^"_""
	;s Str=Str_"^"_""_"^"_PBOExeDr_"^"_UpQty_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	n (GlobalTyle, ID,i)
	s AdmreasonCodeNo=""
	s SaveDivSubInfo="",UpQty=""
	s TempStrInfo=$g(^CacheTemp(GlobalTyle,ID ,i))
	s BillDr=$p(TempStrInfo,"=",1)
	s PatBillDetailsInfo=$p(TempStrInfo,"=",3)
	s PBDTARIInfo=$p(TempStrInfo,"=",4)
	s OEORDInfo=$p(TempStrInfo,"=",5)
	s OEORDInfoTxt=$p(TempStrInfo,"=",6)    
	s TarContrastInfo=$p(TempStrInfo,"=",7)
	;取上传明细流水号，流水号保存  modefy by zhangdongliang 2011-07-19
	s Sequence1=""
	s ArcItmDr=$p(OEORDInfo,"^",15)
	s TarDr=$p(PBDTARIInfo,"^",1)
	s InsuItmDr=$p(TarContrastInfo,"^",5)
	s OEORIDr=$p(PatBillDetailsInfo,"^",16)
	s PBDID=$p(PatBillDetailsInfo,"^",15)
	s InsuCode=$p(PBDTARIInfo,"^",57)
	s InsuDesc=$p(PBDTARIInfo,"^",58)
	s Qty=$p(PatBillDetailsInfo,"^",5)
	s Unit=$p(PatBillDetailsInfo,"^",6)
	s TotalAmount=$p(PatBillDetailsInfo,"^",7)
	s ZFBL=$p(PBDTARIInfo,"^",72)  ;add hwq 2010 11 08
	s DrugFlag=$p(PBDTARIInfo,"^",53) ;add hwq 2010 11 11
	s TarOCate=$p(PBDTARIInfo,"^",19) ;add hwq 2011 06 09   ;  modefy by zhangdongliang 2011-10-09
	s XMLB=$p(PBDTARIInfo,"^",77)  ;add zhangdongliang 结算属类
	s ZMBZ=$p(PBDTARIInfo,"^",79)
	s PBOExeDr=$p(OEORDInfoTxt,"^",21)     ;add hkj 20180326 执行记录rowid
	s UpQty="",ReQty=""
	s:Qty>0 UpQty=Qty                      ;add hkj 20180326 已上传数量
	s InsuRetSeqNo=""
	s:Qty<0 InsuRetSeqNo=..GetRowidoldByPBDIDAndTarID(PBDID,TarDr)
	s:Qty<0 ReQty=Qty
	s Str=""_"^"_""_"^"_ArcItmDr_"^"_TarDr_"^"_InsuItmDr_"^"_OEORIDr_"^"_BillDr_"^"_PBDID_"^"_InsuCode_"^"_InsuDesc
	s Str=Str_"^"_XMLB_"^"_Qty_"^"_Unit_"^"_TotalAmount_"^"_TarOCate_"^"_ZFBL_"^"_""_"^"_""_"^"_"I"_"^"_Sequence1    //收集费用的时候打上标志吗？
	s Str=Str_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_DrugFlag_"^"_""
	;            Demo5 ^ 执行记录dr^已上传Qty      ;增加demo5后9位新增字段保存
	s Str=Str_"^"_""_"^"_PBOExeDr_"^"_UpQty_"^"_ReQty_"^"_InsuRetSeqNo_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	s Rtn=$$CheckFeesInsert^DHCINSUFacade(PBDID)	
	i $p(Rtn,"^",1)="Y" d
	.s subrowid=$p(Rtn,"^",2)
	.s $p(Str,"^",1)=subrowid
	.s flag=..InsertDivInfo(Str)
	e  d 
	.s flag=..InsertDivInfo(Str)
	i flag>0  d
	.s $p(PatBillDetailsInfo,"^",18)=flag
	.s $p(^CacheTemp(GlobalTyle,ID,i),"=",3)=PatBillDetailsInfo
	.s $p(^CacheTemp(GlobalTyle,ID,i),"=",8)=flag_"^"_$g(^DHCINDIS(flag))
	s SaveDivSubInfo=flag
    q SaveDivSubInfo
}

// w ##class(web.DHCINSUDivideSubCtl).UpdateDivInfoFlag("210087","N")

// add by zhangdongliang 2010-10-22

ClassMethod UpdateDivInfoFlag(DivDr As %String, ExpStr As %String) As %String
{
	q:(+DivDr<1) "-1"
	s Flag=$p(ExpStr,"^",1)
	&sql(Update INSU_DivideSub set INDIS_Flag=:Flag where INDIS_RowID=:DivDr)
	q SQLCODE
}

// w ##class(web.DHCINSUDivideSubCtl).DeleteDivInfo("198779")

ClassMethod DeleteDivInfo(BillNo As %String) As %String
{
	q:(+BillNo<1) "-1"
	&sql(delete from INSU_DivideSub where INDIS_PB_Dr=:BillNo)
	q SQLCODE
}

/// w ##class(web.DHCINSUDivideSubCtl).GetDivSubInfoByInvPrtDr("179131","")
ClassMethod GetDivSubInfoByInvPrtDr(InvPrtDr As %String, InsuType As %String) As %String
{
	n (InvPrtDr)
	q:InvPrtDr="" "-1"
	s InsuPID=$I(^CacheTemp("DHCInvPrt"))			//增量函数$Increment(number[,num]),将变量增加1或者指定的值
	k ^CacheTemp("DHCInvPrt",InsuPID)
	k ^DHCINSUDivideSub("InvPrtDr",InvPrtDr)

	s i=1
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,""),-1)
	q:DivDr="" "-1"
	
	s Condr="",i=0
	f  s Condr=$o(^DHCBCI(0,"INV",InvPrtDr,Condr))  q:Condr=""  d
	.s BillDr=$p($g(^DHCBCI(Condr)),"^",2)
	.Q:BillDr=""
	.s DivSubDr=""
	.;w "BillDr="_BillDr,!
	.f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr)) q:DivSubDr=""  d
	..s DivSubInfo=$g(^DHCINDIS(DivSubDr))
	..s TarItemDr=$p(DivSubInfo,"^",3)
	..s TarItemInfo=$g(^DHCTARI(TarItemDr))
	..;w "DivSubInfo="_DivSubInfo,!
	..s DivSubFlag=$p(DivSubInfo,"^",18)
	..;w "DivSubFlag="_DivSubFlag,!
	..q:DivSubFlag="N"
	..s DivSubInfo=DivSubDr_"^"_TarItemInfo
	..s TarItemInfo=TarItemDr_"^"_TarItemInfo
	..s ^CacheTemp("DHCInvPrt",InsuPID ,i)=tmpStr
	..s i=i+1
	q i-1_"|"_InsuPID
}

ClassMethod GetDivInfoFromCacheTmp(ID, index) As %String
{
     new (ID,index)
     s mCurrRowCacheTemp=""
     s outstr=""
     s mCurrRowCacheTemp=$g(^CacheTemp("DHCInvPrt",ID ,index))
     s outstr=mCurrRowCacheTemp
     i $o(^CacheTemp("DHCInvPrt",ID,""),-1)=index d
  	 .k ^CacheTemp("DHCInvPrt",ID)			;add by zhangdongliang 2010-12-15
     q outstr
}

// w ##class(web.DHCINSUDivideSubCtl).UpdateInsuDivSubFlag(202868,"S","")

ClassMethod UpdateInsuDivSubFlag(DHCBillId As %String, Flag As %String, Rowid As %String) As %String
{
	n (DHCBillId,Flag,Rowid)
	Set $ZT="ERROR"	
	q:(+DHCBillId<1) "-1"
	s DivSubDr=""
	s SQLCODE=0     //20220830 
	d ##class(web.DHCINSUBase).BeginTran()
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",DHCBillId,DivSubDr)) q:DivSubDr=""  d
	.&sql(Update INSU_DivideSub set INDIS_Flag=:Flag where INDIS_Rowid=:DivSubDr)
	.i SQLCODE'=0 d ##class(web.DHCINSUBase).RollBack()
	d ##class(web.DHCINSUBase).Commit()
	q SQLCODE
	
ERROR
    Set $ZT=""                      //20220830 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	//TROLLBACK		               //回滚事务
 	If $TLevel>0 TROLLBACK        //-修改 DingSH 20220830 
 	Quit "<ERROR>"_ErrorMsg       //返回错误消息 ;

	
	//////&sql(Update INSU_DivideSub set INDIS_Flag=:Flag where INDIS_PB_Dr=:DHCBillId)
}

///  
///  20100425
///  modify by yangjianzhang   只取未结算的上传明细
/// w ##class(web.DHCINSUDivideSubCtl).GetDivSubByBillDr("91985")
ClassMethod GetDivSubByBillDr(BillDr As %String) As %String
{
	n (BillDr)
	k ^CacheTemp("DivSubInfo",$j)
	s OutStr=0
	q:BillDr="" OutStr
	q:$d(^DHCINDIS("0","PBDr",BillDr))=0 OutStr
	s DivSubDr="",i=1
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr))  q:DivSubDr=""  d
	.s DivSubInfo=$g(^DHCINDIS(+DivSubDr))
	.s DivSubFlag=$p(DivSubInfo,"^",18)
	.q:DivSubFlag'="N"
	.s PayFlag=""
	.i $d(^DHCPB(PBDr))  s PayFlag=$P(^DHCPB(PBDr),"^",16)
	.q:(PayFlag="P")
	.s ^CacheTemp("DivSubInfo",$j,i)=DivSubDr_"^"_DivSubInfo
	.s i=i+1
	q i-1_"|"_$j_"|"
}

/// Zhan 20140105
/// BillDr:账单号
/// Upflag:上传标志:A：全部，N：正常，I：未上传
ClassMethod GetDivSubDataByBillDr(BillDr As %String, Upflag As %String) As %CharacterStream
{
	n (BillDr,Upflag)
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	s Ret="-1"
	d objstream.Write(Ret)
	q:$g(BillDr)="" objstream
	s:"N,I,A"'[Upflag Upflag="A"
	;q:$d(^DHCINDIS("0","PBDr",BillDr))=0 objstream
	s PayFlag=""
	i $d(^DHCPB(BillDr))'=0  s PayFlag=$P(^DHCPB(BillDr),"^",16)
	q:(PayFlag="P") objstream
	//调用一下CheckDivSubByBillDr
	s tmp=..CheckDivSubByBillDr(BillDr)
	s DivSubDr="",i=0
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr))  q:DivSubDr=""  d
	.s DivSubInfo=$g(^DHCINDIS(+DivSubDr))
	.s DivSubFlag=$p(DivSubInfo,"^",18)
	.q:(DivSubFlag="N")&&(Upflag="I")
	.q:(DivSubFlag="I")&&(Upflag="N")
	.s TarDr=$p(DivSubInfo,"^",3)
	.s TarCode=""
	.s:TarDr'="" TarCode=$p(^DHCTARI(TarDr),"^",1)
	.s pbdamt=$p(DivSubInfo,"^",13)
	.s pbdid=$p(DivSubInfo,"^",7)
	.i $d(^DHCPB($p(pbdid,"||",1),"O",$p(pbdid,"||",2),"D",$p(pbdid,"||",3))) d
	..s pbdamt=$p(^DHCPB($p(pbdid,"||",1),"O",$p(pbdid,"||",2),"D",$p(pbdid,"||",3)),"^",7)
	.;s PayFlag=""
	.;i $d(^DHCPB(PBDr))  s PayFlag=$P(^DHCPB(BillDr),"^",16)
	.;q:(PayFlag="P")
	.i i=0 d
	..d objstream.Clear()
	.d objstream.Write(DivSubDr_"^"_DivSubInfo_"^"_TarCode_"^"_pbdamt_$c(1))
	.s i=i+1
	q objstream
}

ClassMethod GetDivSubInfoFromCacheTmp(ID, index) As %String
{
	n (ID,index)
	s mCurrRowCacheTemp=""
	s outstr=""
	s mCurrRowCacheTemp=$g(^CacheTemp("DivSubInfo",ID ,index))
	s outstr=mCurrRowCacheTemp
	q outstr
}

/// w ##class(web.DHCINSUDivideSubCtl).UpdateDivSubByBillDr("202865","997")
ClassMethod UpdateDivSubByBillDr(BillNo As %String, DivDr As %String) As %String
{
	q:(+BillNo<1) "-1"
	&sql(Update INSU_DivideSub set INDIS_DivideDr=:DivDr where INDIS_PB_Dr=:BillNo)
	q SQLCODE
}

/// w ##class(web.DHCINSUDivideSubCtl).GetDivSubUpConutByBillDr("261396","")
ClassMethod GetDivSubUpConutByBillDr(BillNo As %String, DivDr As %String) As %String
{
	q:(+BillNo<1) "-1"
	s Num=0
	s Flag="N"
	&sql(select Count(*) into Num from INSU_DivideSub where INDIS_PB_Dr=:BillNo And INDIS_Flag=:Flag)
	q Num
}

/// 	20170706
/// 	根据执行记录rowid获取医保主键相关信息及之前上传同一PBOExeDr的数量合计，用于费用明细部分退费情况
/// 	入参：BillDr：账单表rowid ；PBOExeDr：执行医嘱rowid ；INDISTaritmDrIN：收费项dr
///           INDISTaritmDrIN  收费项的rowid，用于处理一个医嘱多个收费项的情况
/// w ##class(web.DHCINSUDivideSubCtl).GetDINDISCcInfoByBillDrAndPBOEDAndTd("319909","","")
ClassMethod GetDINDISCcInfoByBillDrAndPBOEDAndTd(BillDr As %String, PBOExeDr As %String, INDISTaritmDrIN As %String) As %String
{
	n (BillDr,PBOExeDr,INDISTaritmDrIN)
	s OutStr="0",INDISSequence1="",INDISSequence2="",INDISSequence2LS="",INDISSequence2FH=""
    s QtyHZ=0,Qty=0
	q:BillDr="" OutStr
	q:$d(^DHCINDIS("0","PBDr",BillDr))=0 OutStr
	s DivSubDr=0,i=1
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr))  q:DivSubDr=""  d
	.s DivSubInfo=$g(^DHCINDIS(+DivSubDr))
	.s INDISSequence1=$p(DivSubInfo,"^",19)         ;获取明细主键信息，用于撤销明细
	.s INDISExecDr=$p(DivSubInfo,"^",31)            ;执行记录dr
	.s INDISTaritmDr=$p(DivSubInfo,"^",3)           ;收费项dr
	.q:INDISExecDr'=PBOExeDr                        ;判断传入的执行记录dr是否相同
    .q:INDISTaritmDr'=INDISTaritmDrIN               ;判断传入的收费项dr是否相同
	.s DivSubFlag=$p(DivSubInfo,"^",18)             ;获取上传flag标志
	.s INDISReQty=+$p(DivSubInfo,"^",33)		    ;退费数量
	.s INDISUpQty=+$p(DivSubInfo,"^",32)            ;实际上传的数量
	.q:(DivSubFlag'="N")	                        ;已经部分退费的时候，继续获取数量
	.s Qty=+$p(DivSubInfo,"^",11)                   ;获取账单数量
	.s QtyHZ=QtyHZ+Qty                              ;计算已经上传过明细的账单数量合计
	.q:INDISReQty=-INDISUpQty                       ;判断是否退费，未退费继续获取需要退费明细的主键信息
	.i INDISSequence2FH=""  d
	..s INDISSequence2FH=INDISSequence1_"|"_Qty
	.e  d
	..s INDISSequence2FH=INDISSequence2FH_"^"_INDISSequence1_"|"_Qty
	
    s INDISSequence2FH=INDISSequence2FH_"|"_QtyHZ
	q INDISSequence2FH
}

/// w ##class(web.DHCINSUDivideSubCtl).UpdateDISZReQtyAndFPlusLinkNeg("10545","-4","10541","10545$-4$N")
/// 入参：ZDiSDr ：需要更新的正记录的insu_dividesub表的rowid
///       ReQty : 退费数量
///       FDiSDr: 需要更新的负记录的insu_dividesub表的rowid
/// PlusLinkNeg : 正记录dr$数量$退费标志！正记录dr$数量$退费标志...
/// 作用：退费成功后，更新正记录的退费数量，更新负记录的PlusLinkNeg
ClassMethod UpdateDISZReQtyAndFPlusLinkNeg(ZDiSDr As %String, ReQty As %String, FDiSDr As %String, PlusLinkNeg As %String) As %String
{
	q:(+ZDiSDr<1) "-1"
    q:(+FDiSDr<1) "-1"
	tstart
	s tmpflag=..UpdateDivInfoReQty(ZDiSDr,ReQty)
	s flag=..UpdatePlusLinkNeg(FDiSDr,PlusLinkNeg)
	i (flag="0")&(tmpflag="0") d      
	.tcommit
	e  d    
	.trollback
	.s flag=-100
	q flag
}

/// w ##class(web.DHCINSUDivideSubCtl).UpdateDivInfoReQty("91985","-1")
/// 入参：DiSDr ：需要更新的正记录的insu_dividesub表的rowid
///       ExpStr：ReQty^      ReQty:退费数量    ^后预留位置，以免有其他需要更新数据
/// 作用：更新退费数量
ClassMethod UpdateDivInfoReQty(DiSDr As %String, ReQty As %String) As %String
{
	q:(+DiSDr<1) "-1"
	s ReQty=+ReQty
	&sql(Update INSU_DivideSub set INDIS_ReQty=:ReQty + INDIS_ReQty where INDIS_RowID=:DiSDr)
	q SQLCODE
}

/// w ##class(web.DHCINSUDivideSubCtl).UpdatePlusLinkNeg("202865","997")
ClassMethod UpdatePlusLinkNeg(DiSDr As %String, PlusLinkNeg As %String) As %String
{
	q:(+DiSDr="") "-1"
	&sql(Update INSU_DivideSub set INDIS_PlusLinkNeg=:PlusLinkNeg where INDIS_RowID=:DiSDr)
	q SQLCODE
}

///  
///    函数名：ClearPlusLinkNegByBillDr
///  增加时间：20180326
///      作用: 根据账单rowid，循环insu_dividesub表，将负记录的PlusLinkNeg中包含I的清空，为N的保留
///    增加人： hkj  
/// w ##class(web.DHCINSUDivideSubCtl).ClearPlusLinkNegByBillDr("263447")
ClassMethod ClearPlusLinkNegByBillDr(BillDr As %String) As %String
{
	n (BillDr)
	s OutStr=0
	q:BillDr="" OutStr
	q:$d(^DHCINDIS("0","PBDr",BillDr))=0 OutStr
	s DivSubDr="",i=1
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr)) q:((DivSubDr="")||(OutStr'=0))  d
	.s DivSubInfo=$g(^DHCINDIS(+DivSubDr))
	.s DivSubFlag=$p(DivSubInfo,"^",18)
	.s TempQty=$P(DivSubInfo,"^",11) 
	.s PlusLinkNegTmp=""                       ;临时保存需要更新的PlusLinkNeg字段
	.q:DivSubFlag'="I"                         ;只处理未上传数据
	.q:TempQty>0                               ;只处理负记录数据                  
	.s PlusLinkNeg=$p(DivSubInfo,"^",35)
	.i PlusLinkNeg["N"  d                      ;当已经部分撤销成功的时候，需要将成功的部分继续保存为N，不能清空
	..s PlusLinkNegCount=$L(PlusLinkNeg,"!")   ;获取！分解的条数
	..for i=1:1:PlusLinkNegCount d             ;如果PlusLinkNeg中有多个!分解，进行循环，将为N的继续组串保存
	...i $P($P(PlusLinkNeg,"!",i),"$",3)="N"  d  
	....i PlusLinkNegTmp=""  d
	.....s PlusLinkNegTmp=$P(PlusLinkNeg,"!",i)
	....e  d
	.....s PlusLinkNegTmp=PlusLinkNegTmp_"!"_$P(PlusLinkNeg,"!",i)
	.e  d
	..s PlusLinkNegTmp=""			;如果PlusLinkNeg中不包含N，说明还未成功退费，那就清空PlusLinkNeg         
	.s OutStr=..UpdatePlusLinkNeg(DivSubDr,PlusLinkNegTmp)  ;更新insu_dividesub表中的PlusLinkNeg字段
	q OutStr
}

/// GetPlusLinkNeg
/// Creator:tnagzf
/// CreatDate:2018-03-21
/// Description:拆分费用明细记录，并将正负记录关联，更新INSUDivideSub.PlusLinkNeg字段
/// Input：INDivSubDr 医保明细表:INSUDivideSub.RowId
/// Output: INSUDivideSub.PlusLinkNeg
/// Others: w ##class(web.DHCINSUDivideSubCtl).GetPlusLinkNeg("6||1||1","12127")
ClassMethod GetPlusLinkNeg(ExecDr, INDivSubDr) As %String
{
	Quit:INDivSubDr="" ""
	k ^CacheTemp("0","ZJLInfo")
	
	set DHCTarItemDr=$P(^DHCINDIS(INDivSubDr),"^",3)	;获取收费项rowid，用于后续同ExecDr一起精确定位正记录
	set ExecDr=$P(^DHCINDIS(INDivSubDr),"^",31)	
	set Qty=$P(^DHCINDIS(INDivSubDr),"^",11) ;INDivSubDr的数量
	set UPFlag="",FJLQty=0					;负记录中上传成功的数量
	Quit:Qty>0 ""							;正记录退出函数
	d checkISVaild							;检查当前执行记录下所有与INDivSubDr相同收费项的正记录是否可以拆分
	Quit:UPFlag="N" "-100"					;该执行记录下正记录数量不够负记录拆分
	Quit:(UPFlag="Y")&&(FJLQty-Qty=0) ""	;已经全部成功上传的不拆分
	Quit:($P(^DHCINDIS(INDivSubDr),"^",35)'["N")&&($P(^DHCINDIS(INDivSubDr),"^",35)'="") "" ;本次上传已经进行过拆分的不再进行拆分  
	
	;该循环给可拆分的正记录赋初值存入Global
	set TempDivSub=0  ;当前循环sub dr
	set (OutStr,TmpPlusLinkNeg)=""
	for  set TempDivSub=$O(^DHCINDIS(0,"ExecDr",ExecDr,TempDivSub)) Quit:TempDivSub=""  d
	.set TempQty=$P(^DHCINDIS(TempDivSub),"^",11)		;当前循环的正记录的实际数量
	.set UPQty=+$P(^DHCINDIS(TempDivSub),"^",32)		;正记录上传的数量
	.set REQty=+$P(^DHCINDIS(TempDivSub),"^",33)		;正记录已成功退费数量
	.set ZJLQty=UPQty+REQty								;正记录可拆分数量
	.set TempTarItem=$P(^DHCINDIS(TempDivSub),"^",3)	;收费项rowid	
	.Quit:(ZJLQty=0)&&(TempQty>0)						;该条正记录已被拆完,继续下个循环
	.Quit:TempTarItem'=DHCTarItemDr						;同一执行记录，但是不为同一收费项的，继续下个循环
	.if TempQty<0 d
	..set PlusLink=$P(^DHCINDIS(TempDivSub),"^",35)		;更新已经拆分过没拆完的正记录
	..if PlusLink'="" d
	...set PlusLinkLen=$L(PlusLink,"!")
	...for i=1:1:PlusLinkLen d
	....set LinkSub=$P($P(PlusLink,"!",i),"$",1)		;正记录rowid
	....set LinkQty=$P($P(PlusLink,"!",i),"$",2)		;正记录已经拆分过数量
	....Quit:$P($P(PlusLink,"!",i),"$",3)="N"			;成功上传的部分不拆分
	....set UseQty=$G(^CacheTemp("0","ZJLInfo",$J,LinkSub))+LinkQty				   ;本次拆分过程中正记录实际可供拆分数量
	....if (UseQty>0)&&(UseQty'=0) d
	.....set ^CacheTemp("0","ZJLInfo",$j,LinkSub)=+UseQty
	.....set ^CacheTemp("0","ZJLInfo",$j,LinkSub,"N")="Y"
	....else  d											;该正记录已被拆分完，不可继续拆分
	.....k ^CacheTemp("0","ZJLInfo",$j,LinkSub,"N")
	set Qty=Qty-FJLQty									;负记录实际需要拆分数量
	set StopFlag="N"
	set TempZJLSub=0
	;正记录的数量符合负记录的数量的处理方法
	for  set TempZJLSub=$O(^CacheTemp("0","ZJLInfo",$j,TempZJLSub)) Quit:(TempZJLSub="")||(Qty=0)  d
	.Quit:'$d(^CacheTemp("0","ZJLInfo",$j,TempZJLSub,"N"))	;过滤不可拆分的正记录
	.set ZJLQty=$G(^CacheTemp("0","ZJLInfo",$j,TempZJLSub))	;获取正记录的可退数量
	.s:ZJLQty=-Qty tempQty=Qty, OutStr=$G(OutStr)_TempZJLSub_"$"_tempQty_"$I"_"!",Qty=0	;负记录拆完，拼组OutStr串，用于后续给PlusLinkNeg赋值
	;正记录的数量不符合负记录的数量的处理方法
	for  set TempZJLSub=$O(^CacheTemp("0","ZJLInfo",$j,TempZJLSub)) Quit:(TempZJLSub="")||(Qty=0)  d
	.Quit:'$d(^CacheTemp("0","ZJLInfo",$j,TempZJLSub,"N"))	;过滤不可拆分的正记录
	.set ZJLQty=$G(^CacheTemp("0","ZJLInfo",$j,TempZJLSub))	;获取正记录的可退数量
	.s:ZJLQty>-Qty tempQty=Qty, Qty=0       				;负记录拆完
	.s:ZJLQty<-Qty tempQty=-ZJLQty,Qty=ZJLQty+Qty  			;正记录不够拆 继续循环拆分
	.set OutStr=$G(OutStr)_TempZJLSub_"$"_tempQty_"$I"_"!"	;拼组OutStr串，用于后续给PlusLinkNeg赋值
	
	k ^CacheTemp("0","ZJLInfo")
	
	;返回串处理
	set OutStr=$P(^DHCINDIS(INDivSubDr),"^",35)_"!"_OutStr		;用于在负记录已经退了一部分的情况使用
	if $e(OutStr,1)="!" set $e(OutStr,1)=""						;用于处理PlusLinkNeg第一位为!的情况，直接将!删除掉
	if $e(OutStr,$L(OutStr))="!" set $e(OutStr,$L(OutStr))=""	;用于处理PlusLinkNeg最后一位为!的情况，直接将!删除掉
    &sql(Update INSU_DivideSub set INDIS_PlusLinkNeg=:OutStr where INDIS_RowID=:INDivSubDr)
	Quit:SQLCODE'=0 "-100"
	Quit OutStr
	
checkISVaild
	;检查当前执行记录下所有与INDivSubDr相同收费项的正记录是否可以拆分,
	;并且将正记录的剩余可退数量存入Global，用于后续拆分负记录时，判断同一执行记录下的正记录
	;是否可用于拆分及可用于退的数量，进而将可用于退费的正记录及其可退数量拼串存入PlusLinkNeg字段
	set TemSub=0
	for  set TemSub=$O(^DHCINDIS(0,"ExecDr",ExecDr,TemSub)) Quit:(TemSub="")  d
	.set PlusLink=$P(^DHCINDIS(TemSub),"^",35)
	.set TemQty=$G(TemQty)+$P(^DHCINDIS(TemSub),"^",11) ;此执行记录下所有收费项的数量之和
	.Quit:($P(^DHCINDIS(TemSub),"^",3))'=($P(^DHCINDIS(INDivSubDr),"^",3)) ;与INDivSubDr的收费项不同的收费项退出下面的判断
	.if ($P(^DHCINDIS(TemSub),"^",11) >0)&&($P(^DHCINDIS(TemSub),"^",32)+$P(^DHCINDIS(TemSub),"^",33)'=0 ) d	;正记录赋初值存入Global 数量大于0，并且实际上传数量与退费数量之和不为0
	..set ^CacheTemp("0","ZJLInfo",$J,TemSub)=$P(^DHCINDIS(TemSub),"^",32)+$P(^DHCINDIS(TemSub),"^",33)			;将可退数量存入Global  实际上传数量与退费数量之和
	..set ^CacheTemp("0","ZJLInfo",$j,TemSub,"N")="Y"     ;可拆分标志：="Y" 表示赋值为可拆分
	.if (PlusLink["N") d
	..set UPFlag="Y" ;上传标志  Y：表示已经上传过 N：表示执行记录下所有正记录不够负记录拆分
	..set PlusLinkLen=$L(PlusLink,"!")
	..for i=1:1:PlusLinkLen d
	...set LinkSub=$P($P(PlusLink,"!",i),"$",1)	;对应正记录rowid
	...set LinkQty=$P($P(PlusLink,"!",i),"$",2)	;对应正记录已退数量
	...set:INDivSubDr=TemSub FJLQty=LinkQty+$G(FJLQty) ;同一收费项的PlusLink按!分解循环，FJLQty已退的正记录的数量之和(比如-1+-2=-3)
	set:TemQty<0 UPFlag="N" ;执行记录下所有正记录不够负记录拆分

	Quit
}

/// w ##class(web.DHCINSUDivideSubCtl).GetDivSubInfoByBillDr("263770","ZZB")
ClassMethod GetDivSubInfoByBillDr(BillDr As %String, InsuType As %String) As %String
{
	n (BillDr,InsuType)
	s OutStr="0|0"
	q:BillDr="" OutStr
	q:$d(^DHCINDIS("0","PBDr",BillDr))=0 OutStr
	s AdmDr=$p(^DHCPB(BillDr),"^",1)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200603
	s UpFDetailMode=+##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"UpFDetailMode",4,HospDr)	;负记录的上传模式 0 ：负记录分包上传(默认)  1：负记录退费时需要关联正记录，可以拆分正记录进行退费的方案 2：负记录退费时需要关联正记录，正记录全部撤销后重新上传正负记录合并后数量的方案
	s DivSubDr="",i=0,DivSubAmount=0
	f  s DivSubDr=$o(^DHCINDIS("0","PBDr",BillDr,DivSubDr))  q:DivSubDr=""  d
	.s DivSubInfo=$g(^DHCINDIS(+DivSubDr))
	.s DivSubFlag=$p(DivSubInfo,"^",18)
	.;q:DivSubFlag'="N"
	.s DivSubQty=+$p(DivSubInfo,"^",11)
	.s DivSubPrice=+$p(DivSubInfo,"^",12)
	.i UpFDetailMode=1 d
	..s UPQty=+$P(DivSubInfo,"^",32)  ;正记录上传的数量
	..s REQty=+$P(DivSubInfo,"^",33)  ;正记录已成功退费数量
	..i DivSubQty>0 d
	...q:DivSubFlag'="N"
	...s DivSubAmount=DivSubAmount+(UPQty*DivSubPrice)
	...s i=i+1
	..e  d
	...s PlusLink=$P(DivSubInfo,"^",35)
	...i PlusLink'="" d
	....s PlusLinkLen=$L(PlusLink,"!")
	....f i=1:1:PlusLinkLen d
	.....s LinkSub=$P($P(PlusLink,"!",i),"$",1)   ;正记录rowid
	.....s LinkQty=$P($P(PlusLink,"!",i),"$",2)   ;正记录已经拆分过数量
	.....i $P($P(PlusLink,"!",i),"$",3)="N"  d     ;成功上传的
	......s DivSubAmount=DivSubAmount+(LinkQty*DivSubPrice)
	......s i=i+1
	.e  i UpFDetailMode=2 d
	..i DivSubQty>0 d
	...s UPQty=+$P(DivSubInfo,"^",32)  ;正记录上传的数量
	...s REQty=+$P(DivSubInfo,"^",33)  ;正记录已成功退费数量
	...q:DivSubFlag'="N"
	...i REQty'=0 d		;正记录被全退
	....s i=i+2
	...e  d
	....s DivSubAmount=DivSubAmount+(UPQty*DivSubPrice)
	....s i=i+1
	..e  d
	...q:DivSubFlag'="N"
	...s UPQty=+$P(DivSubInfo,"^",32)  ;正记录上传的数量
	...s DivSubAmount=DivSubAmount+(UPQty*DivSubPrice)
	...s i=i+1	
	.e   d
	..q:DivSubFlag'="N"
	..s DivSubAmount=DivSubAmount+$p(DivSubInfo,"^",13)
	..s i=i+1
			
	q i_"|"_DivSubAmount
}

/// 根据发票ID和医保结算表ID更新结算子表
/// 入参Desc:
/// 	InvPrtDR:发票ID
/// 	DivDr:结算ID
/// 	ExpStr:     扩展串
/// 出参：非0为失败	
/// 备注:
/// 应用场景：门诊结算后更新明细表父表指针
/// w ##class(web.DHCINSUDivideSubCtl).UpdateDivSubByInvprtDr("4787","22","")
ClassMethod UpdateDivSubByInvprtDr(InvPrtDR As %String, DivDr As %String, ExpStr As %String) As %String
{
	s RtnStr="-1"
	s InvDr=$P(InvPrtDR,"!",1)
    q:$d(^DHCINVPRT(InvDr))=0 "-1"
    s InvPrt=$p(^DHCINVPRT(InvDr),"^",14)
    q:'$d(^DHCBCI(0,"INV",InvDr)) "-1"
    s instype=$p($g(^DHCINVPRT(InvDr)),"^",9)
    //q:instype=1 //自费的退出 -DingSH 20200609
    s Cnt =$l(InvPrtDR,"!") //+ DingSH 20200706 考虑集中打印情况  
    s i=1
    f i=1:1:Cnt d
    .s InvDr =$P(InvPrtDR,"!",i)
    .s BillConInvRowid=""
    .f  s BillConInvRowid=$o(^DHCBCI(0,"INV",InvDr,BillConInvRowid)) q:BillConInvRowid=""  d
    ..s ConStr=$g(^DHCBCI(BillConInvRowid))
    ..s BillNo=$p(ConStr,"^",2)
	..q:(+BillNo<1)
	..s SubNum =0
	..&sql(SELECT count(INDIS_Rowid) into :SubNum  FROM INSU_DivideSub WHERE INDIS_PB_Dr=:BillNo)
	..i SubNum>0 d
	...&sql(Update INSU_DivideSub set INDIS_DivideDr=:DivDr where INDIS_PB_Dr=:BillNo)
	...s RtnStr=SQLCODE
	..e  d
	...s RtnStr=0
	q RtnStr
}

/// 功能:根据负账单明细ID以及收费项ID获取正账单明细ID
/// 作者:WangL
/// 时间:20201211
/// 入参:负账单明细表id(DHC_PatBillDetails表Id),收费项id(DHC_Taritem表id)
/// 出参:正账单明细表id
/// w ##class(web.DHCINSUDivideSubCtl).GetRowidoldByPBDIDAndTarID("8676||1||1","8201")
ClassMethod GetRowidoldByPBDIDAndTarID(PBDID, TarID) As %String
{
 n (PBDID,TarID)
 q:PBDID="" ""
 q:TarID="" ""
  s PBRowId=$p(PBDID,"||",1)
  s PBOChildSub=$p(PBDID,"||",2)
  s PBDChildSub=$p(PBDID,"||",3)
  
  s OldInfo=$g(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))
  q:OldInfo="" ""
  s OldQty=-$p(OldInfo,"^",5)
  s OldPrice=$p(OldInfo,"^",4)
  
   s TARISpecialFlag = $P(^DHCTARI(TarID),"^",17) //判断虚拟收费标识  + 20221121
  i (TARISpecialFlag = "Y") {
	  s TarConDr = TarID
	  s AdmDr = $P(^DHCPB(PBRowId),"^",1)
	  s HospDr=##class(UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	  s InAdmId=""
	  s InAdmId = $O(^DHCINADM(0,"ADM",AdmDr,InAdmId),-1)
	  s HiType=""
	  i (+InAdmId>0)
	   {
		  s HiType=$P(^DHCINADM(InAdmId),"^",18)
		}
	  s PBOOEORIDR=$P(^DHCPB(PBRowId,"O",PBOChildSub),"^",4)
	  s TariSpecialFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_HiType,"TariSpecialFlag",HospDr),"^",4) //是否启用特殊收费项目对照 +DingSH 20200828
	  i (TariSpecialFlag="Y"){
		   s ARCIMType=$p($g(^OEORD(+PBOOEORIDR,"I",$p(PBOOEORIDR,"||",2),"DHC")),"^",3)	;Zhan 20151119 OEORI_InsurCat_DR 医保类别指针医保适应症代码(医保组
		   s TarID=##class(web.DHCINSUTarConTar).GetTarDrByTarConDr(TarConDr,ARCIMType,HiType,HospDr)
	  }
  }
  
  s PBDChildSubOld=""
  s OutStr=""
  s RowId=PBDChildSub
  s QFlag="1"
  f  s RowId=$o(^DHCPB(PBRowId,"O",PBOChildSub,"D",RowId),-1) q:(RowId="")!(QFlag="0")  d
  .s Info=$g(^DHCPB(PBRowId,"O",PBOChildSub,"D",RowId))
  .q:Info=""
  .s PBDTarID=$p(Info,"^",3)
  .q:PBDTarID'=TarID
  .s Qty=$p(Info,"^",5)
  .;b ;000
  .q:(+Qty < OldQty )
  .s PBDUnitPrice=$p(Info,"^",4)
  .q:OldPrice'=PBDUnitPrice
  .s QFlag="0"
  .s PBDChildSubOld=RowId
  i PBDChildSubOld '= "" d
  .s OutStr=PBRowId_"||"_PBOChildSub_"||"_PBDChildSubOld
    
    q OutStr
}

/// Description:根据医保明表Rowid更新医保指针
/// Creator:DingSH
/// CreatDate:2020-03-26
/// Input：Id 医保明细表:INSUDivideSub.RowId
/// Others: w ##class(web.DHCINSUDivideSubCtl).UpdateDivSubById("202865","997")
/// 应用场景：门诊挂号成功后更新明细表父表指针
ClassMethod UpdateDivSubById(Id As %String, DivDr As %String, ExpStr As %String) As %String
{
	q:(+Id<1) "-1"
	&sql(Update INSU_DivideSub set INDIS_DivideDr=:DivDr where INDIS_Rowid=:Id)
	q SQLCODE
}

/// 根据医保结算表ID更新结算子表账单号
/// 入参Desc:
/// 	DivDr:结算ID
/// 	InvPrtDR:发票ID
/// 	ExpStr:     扩展串
/// 出参：非0为失败	
/// DingSH 20200326
/// 备注:
/// 应用场景：门诊挂号成功后更新明细表账单号
ClassMethod UpdateDivSubInvprtDrByDivDr(DivDr As %String, InvPrtDR As %String, ExpStr As %String) As %String
{
	s RtnStr="-1"
    q:$d(^DHCINVPRT(InvPrtDR))=0 "-1"
    s InvPrt=$p(^DHCINVPRT(InvPrtDR),"^",14)
    q:'$d(^DHCBCI(0,"INV",InvPrtDR)) "-1"
    s instype=$p($g(^DHCINVPRT(InvPrtDR)),"^",9)
    //q:instype=1 //自费的退出 //- DingSH 20200609
    s BillConInvRowid=""
    f  s BillConInvRowid=$o(^DHCBCI(0,"INV",InvPrtDR,BillConInvRowid)) q:BillConInvRowid=""  d
    .s ConStr=$g(^DHCBCI(BillConInvRowid))
    .s BillNo=$p(ConStr,"^",2)
	.q:(+BillNo<1)
	.&sql(Update INSU_DivideSub set INDIS_PB_Dr=:BillNo where INDIS_DivideDr=:DivDr)
	.s RtnStr=SQLCODE
	q RtnStr
}

///  校验医嘱(医嘱执行记录)是否医保标识与已上传明细一致
/// 入参 
/// 	BillId:账单号
/// 	ExpStr:扩展串
/// 出参：不一致条数^进程号:0 或大于0 ^进程号
/// DingSH 20200708
/// 备注:
/// 应用场景：核查是否医保标识与已上传医保明细是否一致
/// zw ^CacheTemp("ChkInsuFlag")
/// 不一致情况：当前是否医保标识（取自：医嘱或执行记录或医保审核或医保控费） 与上传时的是否医保不一致，认定为异常
ClassMethod CheckINSUDivideSubSelfAmount(BillId As %String, ExpStr As %String) As %String
{
 n (BillId,ExpStr)
 
 s InsuPID=$I(^CacheTemp("ChkInsuFlag"))
 k ^CacheTemp("ChkInsuFlag",InsuPID)
 s ChkIndex=0
 //1 根据配置取是否医保标识取值方式(医嘱,医嘱的执行记录,医保医嘱审核,医保控费审核)
 s AdmDr = $P(^DHCPB(BillId),"^",1)
 s AdmReasonDr = $P(^DHCPB(BillId),"^",4)
 s HospId=##class(UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
 s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType", AdmReasonDr,6,HospId)
 s ChkFlag =##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType, "ChkInsuFlagMod",4,HospId) //+DingSH 20210222 
 //2 校验已经上传明细 当前是否医保标识是否一致
 s SumAmount=0,SumSelfPay=0,count=0
 s INDISRowid="0"
 f  s INDISRowid=$O(^DHCINDIS("0","PBDr",BillId,INDISRowid)) q:INDISRowid=""  d
 .q:$p(^DHCINDIS(INDISRowid),"^",18)'="N"
 .s DivedSubFlag=$p(^DHCINDIS(INDISRowid),"^",18)
 .s INDISOEORIDr=$p(^DHCINDIS(INDISRowid),"^",5)
 .s INDISTarItmDr=$p(^DHCINDIS(INDISRowid),"^",3)
 .s INDISExecDr=$p(^DHCINDIS(INDISRowid),"^",31) 
 .s TmpINDISOEORIDr=INDISOEORIDr
 .s:INDISExecDr'="" TmpINDISOEORIDr=INDISExecDr
 .d GetInsuFlag(TmpINDISOEORIDr,INDISTarItmDr,ChkFlag) 
 .//q:InsuFlag'="N"
 .s SelfPay =$p(^DHCINDIS(INDISRowid),"^",17)+ $p(^DHCINDIS(INDISRowid),"^",26)+$p(^DHCINDIS(INDISRowid),"^",28)  ;自费金额 = Demo1:全自费金额+Demo3:超限价金额
 .s INDISAmount=$p(^DHCINDIS(INDISRowid),"^",13)
 .s INDISINSUDesc=$p(^DHCINDIS(INDISRowid),"^",9)  ;医保项目名称
 .s INDISINSUCode=$p(^DHCINDIS(INDISRowid),"^",8)  ;医保项目编码
 .//s INDISDemo2=$p(^DHCINDIS(INDISRowid),"^",27)  ;demo2医保需审核标志
 .//q:INDISDemo2>0
 .s TarCode=$p(^DHCTARI(INDISTarItmDr),"^",1)
 .s TarDesc=$p(^DHCTARI(INDISTarItmDr),"^",2)
 .s ErrFalg="N"
 .//医保标识格式:是否医保标识(上传的值)|医院审批标识值|是否医保标识值(上传时)||医保医嘱审核医保标识值|医保控费医保标识值|中药使用方式
 .s INDISINSUFlag=$p(^DHCINDIS(INDISRowid),"^",24)
 .s UpInsuFlag=$P(INDISINSUFlag,"|",3)
 .//不一致情况1：当前医嘱或执行记录是否医保标识为Y或空,但是上传时否医保标识为N
 .if (InsuFlag'="N")&&(UpInsuFlag'=InsuFlag) d
 ..s ErrFalg="Y"
 .//不一致情况2：当前医嘱或执行记录是否医保标识为N,但是上传明细返回报销($zabs(SelfPay-INDISAmount)>0.01)
 .if (InsuFlag="N")&&($zabs(SelfPay-INDISAmount)>0.01) d
 ..s ErrFalg="Y"
 .if ErrFalg="Y" d
 ..s count=count+1
 ..s SumAmount=SumAmount+INDISAmount
 ..s SumSelfPay=SumSelfPay+SelfPay
 ..s ^CacheTemp("ChkInsuFlag",InsuPID,count) = "医嘱Id/执行记录Id:"_INDISOEORIDr_"/"_INDISExecDr_",医院项目编码/名称:"_TarCode_"/"_TarDesc_",医保编码/名称:"_INDISINSUCode_"/"_INDISINSUDesc_",总金额:"_INDISAmount_",个人自付:"_SelfPay_",是否医保(当前/已上传）:"_InsuFlag_"/"_UpInsuFlag
 
 q count_"^"_InsuPID
  
GetInsuFlag(INDISOEORIDr,INDISTarItmDr,ChkFlag)
 s InsuFlag = ""
 
 //ChkFlag = "0" 按医嘱取是否医保标识
 i ChkFlag="0" d
 .s InsuFlag=$p($g(^OEORD($p(INDISOEORIDr,"||",1),"I",$p(INDISOEORIDr,"||",2),3)),"^",3) //CoverMainIns
 
 //ChkFlag = "1" 按医嘱执行记录取是否医保标识
 i ChkFlag="1" d
 .//s InsuFlag=$p($g(^OEORD($p(INDISOEORIDr,"||",1),"I",$p(INDISOEORIDr,"||",2),"X",$p(INDISOEORIDr,"||",3))),"^",44) //OEOREInsuFlag  -注意，有些老项目扩展的是字段
 .s InsuFlag=$p($g(^OEORD($p(INDISOEORIDr,"||",1),"I",$p(INDISOEORIDr,"||",2),"X",$p(INDISOEORIDr,"||",3))),"^",49) //OEORECoverMainIns
 
 //ChkFlag = "2" 按医保医嘱审核取是否医保标识
  i ChkFlag="2" d
  .s INAUDRowid=""
  .s INAUDRowid=$O(^DHCINAUD("0","OEORI_Tar",INDISOEORIDr,INDISTarItmDr,""),-1)
  .s:+INAUDRowid>0 InsuFlag=$P($g(^DHCINAUD(INAUDRowid)),"^",6)
 
 //ChkFlag = "3" 按医保控费取是否医保标识
  i ChkFlag="3" d
  .//s InsuFlag=##class().xxx()
 q
}

///  获取医嘱(医嘱执行记录)是否医保标识与已上传明细不一致信息
/// 入参 
/// 	JobId:进程号
/// 	Index:序号 从 1开始
/// 出参：不一致医嘱信息
/// DingSH 20200708
/// 备注:
/// 应用场景：核查是否医保标识与已上传医保明细是否一致
ClassMethod GetINSUDivideSubSelfAmountFromCacheTemp(JobId As %String, Index As %String) As %String
{
	 n (JobId,Index)
     s mCurrRowCacheTemp=""
     s mCurrRowCacheTemp=$g(^CacheTemp("ChkInsuFlag",JobId ,Index))
     i $o(^CacheTemp("ChkInsuFlag",JobId,""),-1)<=Index d
  	 .k ^CacheTemp("ChkInsuFlag",JobId)	
  	 q mCurrRowCacheTemp
}

}
