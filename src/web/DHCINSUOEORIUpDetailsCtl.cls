Import SQLUser

Class web.DHCINSUOEORIUpDetailsCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 443;

/// 保存医保医嘱上传明细信息
/// w ##class(web.DHCINSUOEORIUpDetailsCtl).InsertOEORIUpDetails("^11546359^WF^10086||1^10086||1^1^65^66^N^1^^^9001^1076^2016-05-20 09:00:25^2016-05-20 09:00:25^2016-05-20 09:00:25^1076^测试医嘱项目^无^1^35^||dd|www|ddd||dd|||^^^^^^^")
ClassMethod InsertOEORIUpDetails(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
    s Yzlsh=$p(InString,"^",4)
    s YzGrp=$p(InString,"^",5)
    s YzInd=$p(InString,"^",6)
    s DisId=+$P($$CheckOEORIUpDetails^DHCINSUOEORIUpDetails(Yzlsh,YzGrp,YzInd),"^",2)
    i DisId=0 d
    .s InsertDivInfo=$$InsertOEORIUpDetails^DHCINSUOEORIUpDetails(InString)
    e  d
    .i $d(^DHCINSUDOEORI(DisId))=0 d
    ..s InsertDivInfo=$$InsertOEORIUpDetails^DHCINSUOEORIUpDetails(InString)
    .e  d
    ..s $P(InString,"^",1)=DisId
    ..s InsertDivInfo=$$UpdateOEORIUpDetails^DHCINSUOEORIUpDetails(InString)

    q InsertDivInfo
}

/// w ##class(web.DHCINSUOEORIUpDetailsCtl).UpdateOEORIUpDetailsFlag("1","N")
/// add by DingSH 2016-05-20
ClassMethod UpdateOEORIUpDetailsFlag(Id As %String, ExpStr As %String) As %String
{
	q:(+Id<1) "-1"
	s Flag=$p(ExpStr,"^",1)
	&sql(Update SQLUSER.INSU_OEORIUpDetails set INSUD_OEORI_Flag=:Flag where INSUD_OEORI_Rowid=:Id)
	q SQLCODE
}

/// w ##class(web.DHCINSUOEORIUpDetailsCtl).DeleteOEORIUpDetails("198779","")
ClassMethod DeleteOEORIUpDetails(BillNo As %String, InvPrtDr) As %String
{
	q:((+BillNo<1)&&(+InvPrtDr<1)) "-1"
	i '(+BillNo<1) d
	.&sql(delete from SQLUSER.INSU_OEORIUpDetails where INSUD_OEORI_BillNo=:BillNo)
	e  i '(+InvPrtDr<1) d
	.&sql(delete from SQLUSER.INSU_OEORIUpDetails where INSUD_OEORI_InvPrtDr=:InvPrtDr)
	q SQLCODE
}

/// w ##class(web.DHCINSUOEORIUpDetailsCtl).DeleteOEORIUpDetById("198779","")
ClassMethod DeleteOEORIUpDetById(Id As %String) As %String
{
	q:(+Id<1) "-1"
	&sql(delete from SQLUSER.INSU_OEORIUpDetails where INSUD_OEORI_Rowid=:Id)
	q SQLCODE
}

/// w ##class(web.DHCINSUOEORIUpDetailsCtl).CheckOEORIUpDetails("198779","")
ClassMethod CheckOEORIUpDetails(Yzlsh As %String, YzGrp As %String, YzInd As %String) As %String
{
	n (Yzlsh,YzGrp,YzInd)
    s OutStr=$$CheckOEORIUpDetails^DHCINSUOEORIUpDetails(Yzlsh,YzGrp,YzInd)
	q OutStr
}

/// w ##class(web.DHCINSUOEORIUpDetailsCtl).GetOEORIUpDetailsByInDivDr("805582","N")
ClassMethod GetOEORIUpDetailsByInDivDr(InDivDr As %String, Flag As %String) As %String
{
	n (InDivDr,Flag)
	s id="",OutStr=""
	f  s id=$o(^DHCINSUDOEORI("0","InDivDr",InDivDr,id)) q:id=""  d
	.s UpOrdInfo=$$GetOEORIUpDetails^DHCINSUOEORIUpDetails(id)
	.s tFlag=$P(UpOrdInfo,"^",9)
	.q:(Flag'="")&&(tFlag'=Flag)
	.s OutStr=OutStr_"!"_UpOrdInfo
	q OutStr
}

/*
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
	..;s TarConInfo=$$CheckCon^DHCINSUTarContrast(TarDr,InsuType,PBODate,"")

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
	..;q:$p($$CheckFeesInsert^DHCINSUFacade(BillDr_"||"_BillOrd_"||"_BillDetsub),"^",1)="Y"
	..;s rtncode=$$InsertDivideSub^DHCINSUDivide(Str)
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
	..;s TarConInfo=$$CheckCon^DHCINSUTarContrast(TarDr,InsuType,PBODate)
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
*/
}
