Import sqluser

/// Descript:	发药、入库、出库、退货等相关业务数据插入至HERP业务表
/// Creater:    liangjiaquan
/// CreateDate: 2018-11-23
Class web.DHCST.HERP Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:	插入HERP业务表
/// Input:		业务主表ID,业务类型(G-入库,T-出库,R-退货,F-门诊发药,P-住院发药),StrParam(GroupId^LocId^UserId^HospId)
/// Return:		0-成功; <0-失败；
/// Creater:    liangjiaquan
/// CreateDate: 2018-11-23
/// w ##class(web.DHCST.HERP).SendData(228,"F","")
ClassMethod SendData(Input, Type, StrParam = "")
{
	n (Input, Type, StrParam)
	s HerpFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","SendHerpFlag",StrParam) 
	q:HerpFlag'="Y" 0
	q:(Type'="G")&&(Type'="R")&&(Type'="T")&&(Type'="F")&&(Type'="P") 0
	s $ZT="Error^DHCSTERROR"   
	i Type="G"  d			//入库
	.s Pid=..GetRecData(Input)
	i Type="T"  d			//出库
	.s Pid=..GetInitData(Input)
	i Type="R"  d			//退货
	.s Pid=..GetRetData(Input)
	i Type="F"  d			//门诊发药
	.s Pid=..GetOutDispData(Input)
	i Type="P"  d			//住院发药
	.s Pid=..GetInDispData(Input)
	q:$g(Pid)="" -1
	s Main=$g(^TMP("DHCST",$ClassName(),"SendData",Pid,"Main"))
	q:Main="" -2
	Tstart
	s SystemCode="Drug"				//业务系统编码  物资：Dura  药品：Drug 固定资产：Equi
	s SumlType=$p(Main,"^",1)		//入库/出库标志 入库：RG  发药：TK 转移：ZY 退货：SR
	s OrderNO=$p(Main,"^",2)		//单据号
	s BillNO=$p(Main,"^",3)			//发票号
	s Department=$p(Main,"^",4)		//出库/入库部门id
	s OpDate=$p(Main,"^",5)			//日期（出库/入库单日期）
	s OpTime=$p(Main,"^",6)			//时间
	s Status=1						//单据状态（0 未完成  1 已完成  2 作废）
	s AcctVouchStatus=0				//记账状态  0 提交  1 审核  2 记账（默认插入0）
	s DepartmentCode="",DepartmentName=""
	i Department'=""  d
	.s DepartmentCode=$p($g(^CTLOC(Department)),"^",1)
    .s DepartmentName=$p($g(^CTLOC(Department)),"^",2)
	s Err=0
	&SQL(Insert into herp_acct_data.FinanceintegrationMain(SystemCode,SumlType,OrderNO,BillNO,
		DepartmentCode,DepartmentName,Status,OpDate,OpTime,AcctVouchStatus) values(:SystemCode,:SumlType,:OrderNO,:BillNO,
		:DepartmentCode,:DepartmentName,:Status,:OpDate,:OpTime,:AcctVouchStatus))
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:herp_acct_data.FinanceintegrationMain","Type:"_Type_",ID:"_Input,SQLCODE_":"_$g(%msg))
    .s Err=-3
    i Err'=0 Trollback
    i Err'=0 k ^TMP("DHCST",$ClassName(),"SendData",Pid)
    q:Err'=0 Err
    s FinanceMainID=$p($g(%ROWID),$c(1))		
    s Index=""
    f  s Index=$o(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)) q:(Index="")!(Err'=0)  d
    .s Detail=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
    .s DepartmentCode="",DepartmentName=""
    .s VendorCode="",VendorName=""
    .s StkCatGroupCode="",StkCatGroupName=""
    .s StkCatCode="",StkCatName=""
    .s DepartmentDr=$p(Detail,"^",1)
    .i DepartmentDr'=""  d
    ..s DepartmentCode=$p($g(^CTLOC(DepartmentDr)),"^",1)
    ..s DepartmentName=$p($g(^CTLOC(DepartmentDr)),"^",2)
    .s VendorDr=$p(Detail,"^",2)
    .i VendorDr'=""  d
    ..s VendorCode=$p($g(^APC("APCVM",VendorDr)),"^",2)
    ..s VendorName=$p($g(^APC("APCVM",VendorDr)),"^",3)
    .s StkCatGroupDr=$p(Detail,"^",3)
    .i StkCatGroupDr'=""  d
    ..s StkCatGroupCode=$p($g(^DHCSCG(StkCatGroupDr)),"^",1)
    ..s StkCatGroupName=$p($g(^DHCSCG(StkCatGroupDr)),"^",2)
    .s StkCatDr=$p(Detail,"^",4)
    .i StkCatDr'=""  d
    ..s StkCatCode=$p($g(^INC("SC",StkCatDr)),"^",1)
    ..s StkCatName=$p($g(^INC("SC",StkCatDr)),"^",2)
    .s RpAmt=$p(Detail,"^",5)
    .s SpAmt=$p(Detail,"^",6)
    .&SQL(Insert into herp_acct_data.FinanceintegrationDetail(FinanceMainID,DepartmentCode,DepartmentName,
    	VendorCode,VendorName,StkCatGroupCode,StkCatGroupName,StkCatCode,StkCatName,RpAmt,SpAmt) 
    	values(:FinanceMainID,:DepartmentCode,:DepartmentName,:VendorCode,:VendorName,
    	:StkCatGroupCode,:StkCatGroupName,:StkCatCode,:StkCatName,:RpAmt,:SpAmt))
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Insert:herp_acct_data.FinanceintegrationDetail","Type:"_Type_",ID:"_Input,SQLCODE_":"_$g(%msg))
    ..s Err=-4
    ..k ^TMP("DHCST",$ClassName(),"SendData",Pid)
    .i Err'=0 Trollback
    i Err'=0 k ^TMP("DHCST",$ClassName(),"SendData",Pid) 
    q:Err'=0 Err
    Tcommit
    k ^TMP("DHCST",$ClassName(),"SendData",Pid)
    q Err
}

/// Descript:	删除HERP业务表
/// Input:		业务主表ID,业务类型(G-入库,T-出库,R-退货,F-门诊发药,P-住院发药),StrParam(GroupId^LocId^UserId^HospId)
/// Return:		0-成功; <0-失败；
/// Creater:    liangjiaquan
/// CreateDate: 2018-11-23
/// w ##class(web.DHCST.HERP).CancelData(228,"F","")
ClassMethod CancelData(Input, Type, StrParam = "")
{
	n (Input, Type, StrParam)
	s HerpFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","SendHerpFlag",StrParam) 
	q:HerpFlag'="Y" 0
	q:(Type'="G")&&(Type'="R")&&(Type'="T")&&(Type'="F")&&(Type'="P") 0
	i Type="G"  d		//入库
	.s No=$p(^DHCINGR(Input),"^",1)
	.s SumlType="RG"
	i Type="T"  d		//出库
	.s No=$p(^DHCINIT(Input),"^",1) 
	.s SumlType="ZY"
	i Type="R"  d		//退货
	.s No=$p(^INGRT(Input),"^",1)
	.s SumlType="SR"
	i Type="F"  d		//门诊发药
	.s No=$p(^DHCPHDISP(Input,2),"^",1)
	.s SumlType="TK"
	i Type="P"  d		//住院发药
	.s No=$p(^DHCPHAC(Input),"^",14)
	.s SumlType="TK"
	s SystemCode="Drug"
	d ##class(herp.acct.udata.uAcctFincnCommon).Delete(No,SystemCode,SumlType)
	q 0
}

/// 取入库信息
/// w ##class(web.DHCST.HERP).GetRecData(1)
ClassMethod GetRecData(INGDr)
{
	n (INGDr)
	q:INGDr="" ""
	s Pid=..NewPid()
	s SumlType="RG"
	S INGrNo=$p(^DHCINGR(INGDr),"^",1)
	s AuditDate=$p(^DHCINGR(INGDr),"^",4)
	s AuditTime=$p(^DHCINGR(INGDr),"^",9)
	s LocId=$p(^DHCINGR(INGDr),"^",13)
	s Vendor=$p(^DHCINGR(INGDr),"^",3)
	s INGRi="",InvnoStr=""
	f  s INGRi=$o(^DHCINGR(INGDr,"GRI",INGRi)) q:INGRi=""  d
	.s InciDr=$p(^DHCINGR(INGDr,"GRI",INGRi),"^",25)
	.s RpAmt=$p(^DHCINGR(INGDr,"GRI",INGRi),"^",31)
	.s SpAmt=$p(^DHCINGR(INGDr,"GRI",INGRi),"^",50)
	.s Invno=$p(^DHCINGR(INGDr,"GRI",INGRi),"^",27)
	.i InvnoStr=""  d
	..s InvnoStr=Invno
	.e  d
	..s InvnoStr=InvnoStr_","_Invno
	.s IncCatDr=$p(^INCI(InciDr,2),"^",2)
	.s ScgDr=""
	.i IncCatDr'=""   d
	..s ScgDr=$o(^DHCSCG("STKCAT",IncCatDr,""))
	.s Details=""_"^"_Vendor_"^"_ScgDr_"^"_IncCatDr_"^"_RpAmt_"^"_SpAmt
	.s Index=ScgDr_"^"_IncCatDr
	.i '$d(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index))  d
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Details
	.e  d
	..s Str=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
	..s $p(Str,"^",6)=$p(Str,"^",6)+RpAmt
	..s $p(Str,"^",7)=$p(Str,"^",7)+SpAmt
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Str
	s Data=SumlType_"^"_INGrNo_"^"_InvnoStr_"^"_LocId_"^"_AuditDate_"^"_AuditTime
	s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Main")=Data
	q Pid
}

/// 取出库信息
/// w ##class(web.DHCST.HERP).GetInitData(1)
ClassMethod GetInitData(Init)
{
	n (Init)
	q:Init="" ""
	s Pid=..NewPid()
	s SumlType="ZY"
	s LocId=$p(^DHCINIT(Init),"^",5) 
	s ToLoc=$p(^DHCINIT(Init),"^",6) 
	S InitNo=$p(^DHCINIT(Init),"^",1) 
	s AuditDate=$p(^DHCINIT(Init),"^",9) 
	s AuditTime=$p(^DHCINIT(Init),"^",10) 
	s Vendor="",InvnoStr=""
	s Initi=0
	f  s Initi=$o(^DHCINIT(Init,"ITI",Initi)) q:Initi=""  d
	.s Inclb=$p(^DHCINIT(Init,"ITI",Initi),"^",3)
	.s InciDr=+Inclb
	.s RpAmt=$p(^DHCINIT(Init,"ITI",Initi),"^",16)
	.s SpAmt=$p(^DHCINIT(Init,"ITI",Initi),"^",18)
	.s IncCatDr=$p(^INCI(InciDr,2),"^",2)
	.s ScgDr=""
	.i IncCatDr'=""   d
	..s ScgDr=$o(^DHCSCG("STKCAT",IncCatDr,""))
	.s Details=ToLoc_"^"_Vendor_"^"_ScgDr_"^"_IncCatDr_"^"_RpAmt_"^"_SpAmt
	.s Index=ScgDr_"^"_IncCatDr
	.i '$d(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index))  d
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Details
	.e  d
	..s Str=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
	..s $p(Str,"^",6)=$p(Str,"^",6)+RpAmt
	..s $p(Str,"^",7)=$p(Str,"^",7)+SpAmt
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Str
	s Data=SumlType_"^"_InitNo_"^"_InvnoStr_"^"_LocId_"^"_AuditDate_"^"_AuditTime
	s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Main")=Data
	q Pid
}

/// 取退货信息
/// w ##class(web.DHCST.HERP).GetRetData(1)
ClassMethod GetRetData(RetDr)
{
	n (RetDr)
	q:RetDr="" ""
	s Pid=..NewPid()
	s SumlType="SR"
	s LocId=$p(^INGRT(RetDr),"^",7) 
	s RetNo=$p(^INGRT(RetDr),"^",1)
	s Vendor=$p(^INGRT(RetDr),"^",2)
	s AuditDate=$p(^INGRT(RetDr),"^",9) 
	s AuditTime=$p(^INGRT(RetDr),"^",10) 
	s RetiDr=0,InvnoStr=""
	f  s RetiDr=$o(^INGRT(RetDr,"DHCGRR",RetiDr)) q:RetiDr=""  d
	.s INGRi=$p(^INGRT(RetDr,"DHCGRR",RetiDr),"^",1)
	.s RpAmt=$p(^INGRT(RetDr,"DHCGRR",RetiDr),"^",13)
	.s SpAmt=$p(^INGRT(RetDr,"DHCGRR",RetiDr),"^",9)
	.s Invno=$p(^INGRT(RetDr,"DHCGRR",RetiDr),"^",12)
	.i InvnoStr=""  d
	..s InvnoStr=Invno
	.e  d
	..s InvnoStr=InvnoStr_","_Invno
	.s InciDr=$p(^DHCINGR(+INGRi,"GRI",$p(INGRi,"||",2)),"^",25)
	.s IncCatDr=$p(^INCI(InciDr,2),"^",2)
	.s ScgDr=""
	.i IncCatDr'=""   d
	..s ScgDr=$o(^DHCSCG("STKCAT",IncCatDr,""))
	.s Details=""_"^"_Vendor_"^"_ScgDr_"^"_IncCatDr_"^"_RpAmt_"^"_SpAmt
	.s Index=ScgDr_"^"_IncCatDr
	.i '$d(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index))  d
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Details
	.e  d
	..s Str=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
	..s $p(Str,"^",6)=$p(Str,"^",6)+RpAmt
	..s $p(Str,"^",7)=$p(Str,"^",7)+SpAmt
	..s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Str
	s Data=SumlType_"^"_RetNo_"^"_InvnoStr_"^"_LocId_"^"_AuditDate_"^"_AuditTime
	s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Main")=Data
	q Pid
}

/// 取门诊发药信息
/// w ##class(web.DHCST.HERP).GetOutDispData(1)
ClassMethod GetOutDispData(Phd)
{
	n (Phd)
	q:Phd="" ""
	s Pid=..NewPid()
	s SumlType="TK"
	s Phl=$p(^DHCPHDISP(Phd,1),"^",1)
	s LocId=$p(^DHCPHLOC(Phl),"^",1)
	s PrescNo=$p(^DHCPHDISP(Phd,2),"^",1)
	s Vendor=""
	s AuditDate=$p(^DHCPHDISP(Phd),"^",3)
	s AuditTime=$p(^DHCPHDISP(Phd),"^",5)
	s Invno=""
	s Prt=$p(^DHCPHDISP(Phd),"^",2)
	s:Prt'="" Invno=$p($g(^DHCINVPRT(Prt)),"^",14)
	s Phdi=0
    f  s Phdi=$o(^DHCPHDI(Phd,"PHDI",Phdi)) q:Phdi=""  d
    .s PhdiSub=0
    .f  s PhdiSub=$o(^DHCPHDI(Phd,"PHDI",Phdi,"INCLB",PhdiSub)) q:PhdiSub=""  d
    ..s RpAmt=$p(^DHCPHDI(Phd,"PHDI",Phdi,"INCLB",PhdiSub),"^",6)
    ..s SpAmt=$p(^DHCPHDI(Phd,"PHDI",Phdi,"INCLB",PhdiSub),"^",8)
    ..s Inclb=$p(^DHCPHDI(Phd,"PHDI",Phdi,"INCLB",PhdiSub),"^",3)
    ..s InciDr=+Inclb
    ..s IncCatDr=$p(^INCI(InciDr,2),"^",2)
	..s ScgDr=""
	..i IncCatDr'=""   d
	...s ScgDr=$o(^DHCSCG("STKCAT",IncCatDr,""))
	..s Details=""_"^"_Vendor_"^"_ScgDr_"^"_IncCatDr_"^"_RpAmt_"^"_SpAmt
	..s Index=ScgDr_"^"_IncCatDr
	..i '$d(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index))  d
	...s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Details
	..e  d
	...s Str=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
	...s $p(Str,"^",6)=$p(Str,"^",6)+RpAmt
	...s $p(Str,"^",7)=$p(Str,"^",7)+SpAmt
	...s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Str
	s Data=SumlType_"^"_PrescNo_"^"_Invno_"^"_LocId_"^"_AuditDate_"^"_AuditTime
	s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Main")=Data
	q Pid
}

/// 取住院发药信息
/// w ##class(web.DHCST.HERP).GetInDispData(168)
ClassMethod GetInDispData(Phac)
{
	n (Phac)
	q:Phac="" ""
	s Pid=..NewPid()
	s SumlType="TK"
	s LocId=$p(^DHCPHAC(Phac),"^",1)
	s DispNo=$p(^DHCPHAC(Phac),"^",14)
	s Vendor=""
	s AuditDate=$p(^DHCPHAC(Phac),"^",2)
	s AuditTime=$p(^DHCPHAC(Phac),"^",3)
	s Invno=""
	s Phaci=0
	f  s Phaci=$o(^DHCPHAC(Phac,"I",Phaci)) q:Phaci=""  d
	.s PhaciSub=0
	.f  s PhaciSub=$o(^DHCPHAC(Phac,"I",Phaci,"B",PhaciSub)) q:PhaciSub=""  d
	..s RpAmt=$p(^DHCPHAC(Phac,"I",Phaci,"B",PhaciSub),"^",4)
    ..s SpAmt=$p(^DHCPHAC(Phac,"I",Phaci,"B",PhaciSub),"^",6)
    ..s Inclb=$p(^DHCPHAC(Phac,"I",Phaci,"B",PhaciSub),"^",1)
    ..s InciDr=+Inclb
    ..s IncCatDr=$p(^INCI(InciDr,2),"^",2)
	..s ScgDr=""
	..i IncCatDr'=""   d
	...s ScgDr=$o(^DHCSCG("STKCAT",IncCatDr,""))
	..s Details=""_"^"_Vendor_"^"_ScgDr_"^"_IncCatDr_"^"_RpAmt_"^"_SpAmt
	..s Index=ScgDr_"^"_IncCatDr
	..i '$d(^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index))  d
	...s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Details
	..e  d
	...s Str=^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)
	...s $p(Str,"^",6)=$p(Str,"^",6)+RpAmt
	...s $p(Str,"^",7)=$p(Str,"^",7)+SpAmt
	...s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Detail",Index)=Str
	s Data=SumlType_"^"_DispNo_"^"_Invno_"^"_LocId_"^"_AuditDate_"^"_AuditTime
	s ^TMP("DHCST",$ClassName(),"SendData",Pid,"Main")=Data
	q Pid
}

ClassMethod NewPid()
{
	q $I(^DHCST("web.DHCST.HERP"))
}

}
