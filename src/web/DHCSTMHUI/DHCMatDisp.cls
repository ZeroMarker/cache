Import sqluser

/// Descript:	物资门诊发放
/// Creator:	lxt
/// CreateDate:	2021-03-01
Class web.DHCSTMHUI.DHCMatDisp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTMATDISPM";

/// Descript:	查询待发放病人信息
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	病人信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatDisp","QueryNeedDisp",^templxt("QueryNeedDisp"))
Query QueryNeedDisp(Params As %String) As Query(ROWSPEC = "PatId,PatName,PatNo") [ SqlProc ]
{
}

ClassMethod QueryNeedDispExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pStartDate=PJObj.%Get("StartDate")
	q:pStartDate="" $$$OK
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s PayMode=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(gHospId)	//急诊留观收费模式
	
	s Pid=..NewPid()
	k ^DHCSTMPID("QUERYNEEDDISP",Pid)
	s Ord=""
	f  s Ord=$o(^OEORDi(0,"LocStDtArr",gLocId,0,pStartDate,Ord)) q:Ord=""  d
	.s Adm=$p(^OEORD(Ord),"^",1) 
	.q:Adm=""
	.
	.s AdmType=$p(^PAADM(Adm),"^",2)
	.q:(AdmType'="O")&(AdmType'="E")&(AdmType'="H")	//只处理门诊,急诊,体检类病人
	.
	.s PatId=$p(^PAADM(Adm),"^",1)
	.q:PatId=""
	.
	.s chl="" 
	.f  s chl=$o(^OEORDi(0,"LocStDtArr",gLocId,0,pStartDate,Ord,chl)) q:chl=""  d
	..s Oeori=Ord_"||"_chl
	..s CheckOeoriConditonFlag=..CheckOeoriConditon(Adm,Oeori,PayMode)
	..q:CheckOeoriConditonFlag'="Y"
	..s ArcimId=$p(^OEORD(Ord,"I",chl,1),"^",2)		//医嘱项
	..s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	..s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..s MatParamDesc="MatDisp"
	..s:HvFlag="Y" MatParamDesc="HVMatDisp"
	..s Loc=$p(^OEORD(Ord,"I",chl,3),"^",6)
	..s MatParam="^"_Loc_"^^"_gHospId
	..s MatDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM",MatParamDesc,MatParam)
	..q:MatDisp="N"
	..s DispFlag=..GetOeoriDispFlag(Oeori)
	..q:DispFlag'=0
	..
	..q:$d(^DHCSTMPID("QUERYNEEDDISP",Pid,PatId))
	..s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	..s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	..s ^DHCSTMPID("QUERYNEEDDISP",Pid,PatId)=PatNo_"^"_PatName
	
	s PatId=""
	f  s PatId=$o(^DHCSTMPID("QUERYNEEDDISP",Pid,PatId)) q:PatId=""  d
	.s PatStr=^DHCSTMPID("QUERYNEEDDISP",Pid,PatId)
	.s PatNo=$p(PatStr,"^",1)
	.s PatName=$p(PatStr,"^",2)
	.d OutPutRow1
	
	Quit $$$OK
OutPutRow1
	s Data=$lb(PatId,PatName,PatNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description: 检查医嘱是否已发放材料 0 未发, 1 已发, 2已退, -1不存在
/// Creator: lxt
/// CreatDate: 2021-03-01-6-1
/// w ##class(web.DHCSTMHUI.DHCMatDisp).GetOeoriDispFlag("11||1")
ClassMethod GetOeoriDispFlag(Oeori) As %String
{
	n (Oeori)
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	q:dsp="" -1
	
	s ret=0
	s status=$p(^DHCOEDISQTY(dsp),"^",7)
	i status="TC" s ret=0
	e  i status="C" s ret=1	//发药
	e  i status="R" s ret=2	//退药
	e  s ret=-1
	q ret
}

/// Description: 检查医嘱是否材料
/// Creator: lxt
/// CreatDate: 2021-03-01-6-1
/// w ##class(web.DHCSTMHUI.DHCMatDisp).GetMatFlag("11||1")
ClassMethod GetMatFlag(Oeori) As %String
{
	n (Oeori)
	s Oeord=$p(Oeori,"||",1),Ch=$p(Oeori,"||",2)
	s Arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	q:Arcim="" ""
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),""))
	q:Inci="" ""
	s Incsc=$p(^INCI(Inci,2),"^",2)
	q:Incsc="" ""
	s StkType=$p(^INC("SC",Incsc),"^",3)
	q StkType
}

/// Descript:	查询门诊待发放就诊列表
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	门诊发放信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatDisp","QueryMatDisp",^templxt("QueryMatDisp"))
Query QueryMatDisp(Params As %String) As Query(ROWSPEC = "Adm,PatId,PatName,PatNo,PatSex,PatBir,PatOld,PatTel,PatLoc,PrtId,PrtCode,PrtDate,PrtTime,PrtAmt:%Float,DspDate,DispFlag,DispId") [ SqlProc ]
{
}

ClassMethod QueryMatDispExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pPatNo=PJObj.%Get("PatNo")	//登记号
	s pDispFlag=PJObj.%Get("DispFlag")	//发放标志
	s pCardNo=PJObj.%Get("CardNo")	//卡号
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pPatId=PJObj.%Get("PatId")	//病人id
	s pAdmLocId=PJObj.%Get("AdmLoc")	//就诊科室
	s pInciId=PJObj.%Get("Inci")
	s pInciDesc=PJObj.%Get("InciDesc")
	s pDateFlag=PJObj.%Get("DateFlag")	//0开单日期 1收费日期
	
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	i (pPatNo="")&&(pCardNo'="") d
	.s pPatNo=..GetPatNoByCardNo(pCardNo)
	q:(pCardNo'="")&&(pPatNo="") $$$OK
	s PayMode=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(gHospId)	//急诊留观收费模式
	
	s Pid=..NewPid()
	k ^DHCSTMPID("QUERYMATDISP",Pid)
	k PatInfo,PrtInfo
	
	i pDateFlag=0 d
	.f OrdDate=pStartDate:1:pEndDate  d
	..s Ord=""
	..f  s Ord=$o(^OEORDi(0,"LocStDtArr",gLocId,0,OrdDate,Ord)) q:Ord=""  d
	...s Adm=$p(^OEORD(Ord),"^",1) 
	...q:Adm=""
	...
	...s AdmType=$p(^PAADM(Adm),"^",2)
	...q:(AdmType'="O")&(AdmType'="E")&(AdmType'="H")	//只处理门诊,急诊,体检类病人
	...
	...s PatId=$p(^PAADM(Adm),"^",1)
	...q:PatId=""
	...
	...s chl="" 
	...f  s chl=$o(^OEORDi(0,"LocStDtArr",gLocId,0,OrdDate,Ord,chl)) q:chl=""  d
	....s Oeori=Ord_"||"_chl
	....
	....s CheckOeoriConditonFlag=..CheckOeoriConditon(Adm,Oeori,PayMode)
	....q:CheckOeoriConditonFlag'="Y"
	....s ArcimId=$p(^OEORD(Ord,"I",chl,1),"^",2)		//医嘱项
	....s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	....s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	....s MatParamDesc="MatDisp"
	....s:HvFlag="Y" MatParamDesc="HVMatDisp"
	....s Loc=$p(^OEORD(Ord,"I",chl,3),"^",6)
	....s MatParam="^"_Loc_"^^"_gHospId
	....s MatDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM",MatParamDesc,MatParam)
	....q:MatDisp="N"
	....s DspDate=""
	....s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	....s DspDate=$p(^DHCOEDISQTY(Dsp),"^",8)
	....s:DspDate'="" DspDate=..DL2H(DspDate)
	....
	....s DispFlag=..GetOeoriDispFlag(Oeori)
	....q:DispFlag<0
	....
	....s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	....
	....s DispId=""
	....&sql(SELECT DSI_ParRef into:DispId FROM DHC_MatDispItm WHERE DSI_OEORI_DR=:Oeori)
	....s DispId=DispFlag_"^"_DispId
	....
	....q:$d(^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispId,Oeori))
	....s ^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispId,Oeori)=PatId_"^"_DspDate_"^"_DispFlag
	e  i pDateFlag=1 d
	.f PrtDate=pStartDate:1:pEndDate  d
	..s PrtId=""
	..f  s PrtId=$o(^DHCINVPRT(0,"Date",PrtDate,PrtId)) q:PrtId=""  d
	...
	...s BCIRowid=$o(^DHCBCI(0,"INV",PrtId,""))
	...q:('$d(^DHCBCI(BCIRowid)))||(BCIRowid="")
	...s Adm=$p(^DHCBCI(BCIRowid),"^",3)
	...q:Adm=""
	...
	...s AdmType=$p(^PAADM(Adm),"^",2)
	...q:(AdmType'="O")&(AdmType'="E")&(AdmType'="H")	//只处理门诊,急诊,体检类病人
	...
	...s PatId=$p(^PAADM(Adm),"^",1)
	...q:PatId=""
	...
	...s PatBillDr=$p(^DHCBCI(BCIRowid),"^",2)
	...s sub=""
	...f  s sub=$o(^DHCPB(PatBillDr,"O",sub)) q:sub=""  d
	....s Oeori=$p($g(^DHCPB(PatBillDr,"O",sub)),"^",4)
	....q:Oeori=""
	....s CheckOeoriConditonFlag=..CheckOeoriConditon(Adm,Oeori,PayMode)
	....q:CheckOeoriConditonFlag'="Y"
	....
	....s Ord=$p(Oeori,"||",1)
	....s chl=$p(Oeori,"||",2)
	....s RecLocId=$p(^OEORD(Ord,"I",chl,3),"^",6) ;接收科室
	....q:(RecLocId'=gLocId)
	....
	....s DspDate=""
	....s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	....s DspDate=$p(^DHCOEDISQTY(Dsp),"^",8)
	....s:DspDate'="" DspDate=..DL2H(DspDate)
	....
	....s DispFlag=..GetOeoriDispFlag(Oeori)
	....q:DispFlag<0
	....
	....s DispId=""
	....&sql(SELECT DSI_ParRef into:DispId FROM DHC_MatDispItm WHERE DSI_OEORI_DR=:Oeori)
	....s DispStr=DispFlag_"^"_DispId
	....
	....q:$d(^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispStr,Oeori))
	....s ^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispStr,Oeori)=PatId_"^"_DspDate_"^"_DispFlag
	
	s Adm=""
	f  s Adm=$o(^DHCSTMPID("QUERYMATDISP",Pid,Adm)) q:Adm=""  d
	.s AdmLocId=+$p(^PAADM(Adm),"^",4)
	.q:(pAdmLocId'="")&&(pAdmLocId'=AdmLocId)
	.s PrtId=""
	.f  s PrtId=$o(^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId)) q:PrtId=""  d
	..s DispStr=""
	..f  s DispStr=$o(^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispStr)) q:DispStr=""  d
	...s DispFlag=$p(DispStr,"^",1)
	...s DispId=$p(DispStr,"^",2)
	...s Oeori=""
	...s ShowFlag="N"
	...f  s Oeori=$o(^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispStr,Oeori)) q:(Oeori="")||(ShowFlag="Y")  d
	....s MATDISPStr=^DHCSTMPID("QUERYMATDISP",Pid,Adm,PrtId,DispStr,Oeori)
	....s PatId=$p(MATDISPStr,"^",1)
	....s DspDate=$p(MATDISPStr,"^",2)
	....s DispFlag=$p(MATDISPStr,"^",3)
	....s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	....q:(pPatId'="")&&(PatId'=pPatId)
	....q:(pPatNo'="")&&(PatNo'=pPatNo)
	....q:(DispFlag'=0)&(pDispFlag'="Y")
	....q:(DispFlag=0)&(pDispFlag="Y")
	....s Ord=+Oeori
	....s chl=$p(Oeori,"||",2)
	....s ArcimId=$p(^OEORD(Ord,"I",chl,1),"^",2)		//医嘱项
	....s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	....q:(pInciId'="")&&(pInciId'=InciId)
	....s InciCode=$p(^INCI(InciId,1),"^",1)
	....s InciDesc=$p(^INCI(InciId,1),"^",2)
	....q:(pInciDesc'="")&&(InciDesc'[pInciDesc)
	....s ShowFlag="Y"
	...
	...i ShowFlag="Y" d
	....s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	....s PatSex=$p(^PAPER(PatId,"ALL"),"^",7)
	....s:PatSex'="" PatSex=$p(^CT("SEX",PatSex),"^",2)
	....s PatBir=$p(^PAPER(PatId,"ALL"),"^",6)
	....s PatTel=$p(^PAPER(PatId,"PER",1),"^",11)
	....s PatOld=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPapmiAge(PatId,Adm,gHospId)
	....s PatLoc=$p(^PAADM(Adm),"^",4)	//就诊科室
	....s:PatLoc'="" PatLoc=$p(^CTLOC(PatLoc),"^",2)
	....
	....s PrtDate=$p(^DHCINVPRT(PrtId),"^",5)
	....s:PrtDate'="" PrtDate=..DL2H(PrtDate)
	....s PrtTime=$p(^DHCINVPRT(PrtId),"^",20)
	....s:PrtTime'="" PrtTime=..TL2H(PrtTime)
	....s PrtCode=$p(^DHCINVPRT(PrtId),"^",14)
	....s PrtAmt=$p(^DHCINVPRT(PrtId),"^",1)
	....d OutPutRow2
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(Adm,PatId,PatName,PatNo,PatSex,PatBir,PatOld,PatTel,PatLoc,PrtId,PrtCode,PrtDate,PrtTime,PrtAmt,DspDate,DispFlag,DispId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod CheckOeoriConditon(Adm, Oeori, PayMode = "")
{
	n (Adm,Oeori,PayMode)
	
	q:..GetMatFlag(Oeori)'=..sssCode() "N"
	s StayFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus(Adm)
	
	s Ord=$p(Oeori,"||",1)
	s chl=$p(Oeori,"||",2)
	q:'$d(^OEORD(Ord,"I",chl)) "N"
	
	i PayMode="" d
	.s RecLocId=+$p(^OEORD(Ord,"I",chl,3),"^",6)
	.s HospId=..sssHospId(RecLocId)
	.s PayMode=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospId)
	
	s Priority=$p(^OEORD(Ord,"I",chl,1),"^",8)		//医嘱类型
	s (PriCode,PriDesc)=""
	i Priority'="" s PriDesc=$p(^OECPR(Priority),"^",2),PriCode=$p(^OECPR(Priority),"^",1)
	q:(PriDesc["自备")||(PriCode["OM") "N"
	
	
	s EmLGflag=$p(^OEORD(Ord,"I",chl,"DHC"),"^",17)		//医嘱先诊疗后收费标识
	q:(EmLGflag="1")&(PayMode="0") "N"		//押金收费模式，可先发药
	
	s PayFlag=$p(^OEORD(Ord,"I",chl,3),"^",5)
	q:(PayFlag'="P")&&((PayMode'="1")!(StayFlag'="1")) "N"	//未交费时,不是留观或者不是押金过滤
	
	s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	q:Dsp="" "N"
	
	//s PrtId=..GetPrtId(Oeori)
	s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	q:PrtId="" "N"
	
	s Cat=$p(^DHCOEDISQTY(Dsp),"^",27)
	q:Cat=0 "N"	//过虑配液医嘱
	
	q "Y"
}

/// Description: 取医嘱子表关联的正常收费的收据主表id
/// Creator: tsr
/// CreatDate: 2017-02-13
/// Table: DHC_INVOEItemAuthorize,dhc_invprt
ClassMethod GetPrtId(Oeori) As %String
{
	n (Oeori)
	q:Oeori="" ""
	s OeordId=$p(Oeori,"||",1)
	s Adm=$p(^OEORD(OeordId),"^",1)
	s BCIRowid=""
	s PRTRowid=""
	f  s BCIRowid=$o(^DHCBCI(0,"ADM",Adm,BCIRowid)) q:BCIRowid=""  d
	.s InvRowid=$p(^DHCBCI(BCIRowid),"^",1)
	.s PatBillDr=$p(^DHCBCI(BCIRowid),"^",2)
	.s sub=""
	.f  s sub=$o(^DHCPB(PatBillDr,"O",sub)) q:sub=""  d
	..s OEORIDr=$p(^DHCPB(PatBillDr,"O",sub),"^",4)
	..q:OEORIDr'=Oeori
	..s PRTRowid=InvRowid
	q PRTRowid
}

/// Descript:	查询门诊待发放材料列表
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	门诊发放信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatDisp","QueryMatDispDetail",^templxt("QueryMatDispDetail1"),^templxt("QueryMatDispDetail2"))
Query QueryMatDispDetail(Params As %String, Others As %String) As Query(ROWSPEC = "Oeori,InciId,InciCode,InciDesc,Qty:%Float,UomId,UomDesc,Sp:%Float,SpAmt:%Float,OeoriFlag,OrdUserName,StkBin,AvaQty:%Float,Manf,HvFlag,Spec,Barcode,DispFlag,Adm,CheckBarcode,DispItmId") [ SqlProc ]
{
}

ClassMethod QueryMatDispDetailExecute(ByRef qHandle As %Binary, Params As %String, Others As %String) As %Status
{
	n (qHandle,Params,Others)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s OthersObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d OthersObj.%FromJSON(Others)
	
	s pDispFlag=OthersObj.%Get("DispFlag")
	s pInciId=OthersObj.%Get("Inci")
	s pInciDesc=OthersObj.%Get("InciDesc")
	s gLocId=OthersObj.%Get("gLocId")
	s gHospId=OthersObj.%Get("gHospId")
	s PayMode=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(gHospId)	//急诊留观收费模式
	
	while(1){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Adm=Obj.%Get("Adm")
		s pPrtId=Obj.%Get("PrtId")
		s Ord=""
		f  s Ord=$o(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
		.s Itm=0
		.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
		..
		..s Data=..GetOeoriInfo(Adm,Ord,Itm,pDispFlag,gLocId,gHospId,PayMode)
		..q:Data=""
		..
		..s Oeori=Ord_"||"_Itm
		..//s PrtId=..GetPrtId(Oeori)	//收费ID
		..s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
		..q:(pPrtId'="")&&(PrtId'=pPrtId) 	//根据收费ID过滤发放材料
		..
		..s DispFlag=..GetOeoriDispFlag(Oeori)
		..q:DispFlag<0
		..q:(DispFlag'=0)&(pDispFlag'="Y") 
		..q:(DispFlag=0)&(pDispFlag="Y")
		..
		..s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)		//医嘱项
		..s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
		..q:(pInciId'="")&&(pInciId'=InciId)
		..s InciCode=$p(^INCI(InciId,1),"^",1)
		..s InciDesc=$p(^INCI(InciId,1),"^",2)
		..q:(pInciDesc'="")&&(InciDesc'[pInciDesc)
		..d OutPutRow3
	}
	
	Quit $$$OK
OutPutRow3
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询门诊待发放材料列表(润乾打印)
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	门诊发放信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatDisp","QueryMatDispDetail",^templxt("QueryMatDispDetail1"),^templxt("QueryMatDispDetail2"))
Query QueryMatDispDetailPrint(Adm As %String, PrtId As %String, LocId As %String, DispFlag As %String) As Query(ROWSPEC = "Oeori,InciId,InciCode,InciDesc,Qty:%Float,UomId,UomDesc,Sp:%Float,SpAmt:%Float,OeoriFlag,OrdUserName,StkBin,AvaQty:%Float,Manf,HvFlag,Spec,Barcode,DispFlag,Adm,CheckBarcode,DispItmId") [ SqlProc ]
{
}

ClassMethod QueryMatDispDetailPrintExecute(ByRef qHandle As %Binary, Adm As %String, PrtId As %String, LocId As %String, DispFlag As %String) As %Status
{
	n (qHandle,Adm,PrtId,LocId,DispFlag)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s HospId=..sssHospId(LocId)
	s PayMode=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospId)	//急诊留观收费模式
	
	s Ord=""
	f  s Ord=$o(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
	.s Itm=0
	.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	..s Data=..GetOeoriInfo(Adm,Ord,Itm,DispFlag,LocId,HospId,PayMode)
	..q:Data=""
	..d OutPutRow4
	
	Quit $$$OK
OutPutRow4
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetOeoriInfo(Adm, Ord, Itm, pDispFlag, gLocId, gHospId, PayMode)
{
	n (Adm,Ord,Itm,pDispFlag,gLocId,gHospId,PayMode)
	
	s RecLocId=+$p(^OEORD(Ord,"I",Itm,3),"^",6)
	
	q:(RecLocId="")!(RecLocId'=gLocId) ""
	s Oeori=Ord_"||"_Itm
	
	s CheckOeoriConditonFlag=..CheckOeoriConditon(Adm,Oeori,PayMode)
	q:CheckOeoriConditonFlag'="Y" ""
	
	s (DispItmId,Qty,Sp,SpAmt,DspDate)=""
	&sql(SELECT DSI_RowId,DSI_Qty,DSI_Sp,DSI_SpAmt,DSI_ParRef->DISP_Date into :DispItmId,:Qty,:Sp,:SpAmt,:DspDate FROM DHC_MatDispItm WHERE DSI_OEORI_DR=:Oeori)
	
	s OeoriFlag=$p(^OEC("OSTAT",$p(^OEORD(Ord,"I",Itm,1),"^",13)),"^",1)	//医嘱状态
	s OrdUserId=+$p(^OEORD(Ord,"I",Itm,7),"^",1)	//录医嘱人
	s OrdUserName=$p(^SSU("SSUSR",OrdUserId),"^",2)
	s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)		//医嘱项
	s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	s InciCode=$p(^INCI(InciId,1),"^",1)
	s InciDesc=$p(^INCI(InciId,1),"^",2)
	s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	s UomId=$p(^DHCOEDISQTY(Dsp),"^",6)	;发放单位
	s UomDesc=$p(^CT("UOM",UomId),"^",2)
	
	i DispItmId="" d
	.s Qty=$p(^DHCOEDISQTY(Dsp),"^",2)
	.s DspDate=$p(^DHCOEDISQTY(Dsp),"^",8)
	.i DspDate="" s DspDate=+$h
	.s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,DspDate,UomId,gHospId,"")
	.s SpAmt=Sp*Qty
	.s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(SpAmt,gHospId,2)
	
	s StkBin=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(InciId),":",2)	;货位
	s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciId),"^",3) ;生产厂家
	s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(gLocId,InciId,UomId)
	s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	s Barcode=$p(^OEORD(Ord,"I",Itm,"DHC"),"^",14)
	i pDispFlag="Y" s CheckBarcode=Barcode
	
	s Data=$lb(Oeori,InciId,InciCode,InciDesc,Qty,UomId,UomDesc,Sp,SpAmt,OeoriFlag,OrdUserName,StkBin,AvaQty,Manf,HvFlag,Spec,Barcode,DispFlag,Adm,CheckBarcode,DispItmId)
	q Data
}

/// w ##class(web.DHCSTMHUI.DHCMatDisp).jsMatDisp(^templxt("jsMatDisp1"),^templxt("jsMatDisp2"))
ClassMethod jsMatDisp(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..MatDisp(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod MatDisp(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-2,"","明细入参解析失败!")
	
	s gUserId=MainObj.%Get("gUserId")
	s gGroupId=MainObj.%Get("gGroupId")
	s gHospId=MainObj.%Get("gHospId")
	s gLocId=MainObj.%Get("gLocId")
	s Date=$p($h,",",1)
	s Time=$p($h,",",2)
	s AppName=..%GetParameter("AppName")
	
	s Pid=..NewPid()
	k ^DHCSTMPID("MATDISP",Pid)
	while(RtnObj.success=0){
		s Obj=DetailObj.%Pop()
		q:Obj=""
		s Adm=Obj.%Get("Adm")
		s Oeori=Obj.%Get("Oeori")
		s InciId=Obj.%Get("InciId")
		s Qty=Obj.%Get("Qty")
		s UomId=Obj.%Get("UomId")
		s Sp=Obj.%Get("Sp")
		s SpAmt=Obj.%Get("SpAmt")
		s Barcode=Obj.%Get("Barcode")
		s DispFlag=..GetOeoriDispFlag(Oeori)
		i DispFlag'=0 d RtnObj.Err(-3,"","存在已发放明细","",0) q
		s ^DHCSTMPID("MATDISP",Pid,Adm,Oeori)=Oeori_"^"_InciId_"^"_Qty_"^"_UomId_"^"_Sp_"^"_SpAmt_"^"_Barcode
	}
	
	q:RtnObj.success'=0 RtnObj
	
	s Adm="",MainIdStr=""
	f  s Adm=$o(^DHCSTMPID("MATDISP",Pid,Adm)) q:(Adm="")||(RtnObj.success'=0)  d
	.s PatId=$p(^PAADM(Adm),"^",1)
	.s AdmLocId=$p(^PAADM(Adm),"^",4)
	.s MatDispNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",gLocId)
	.i MatDispNo="" d RtnObj.Err(-4,"","发放单号生成失败！","",0)
	.&sql(insert into DHC_MatDisp(DISP_No,DISP_Date,DISP_Time,DISP_SSUSR_DR,DISP_CTLOC_DR,DISP_Pat_DR,DISP_AdmLoc_DR)
		values(:MatDispNo,:Date,:Time,:gUserId,:gLocId,:PatId,:AdmLocId))
	.i SQLCODE'=0 d RtnObj.Err(-5,"","发放主单保存失败！","",0)
	.s MainId=%ROWID
	.i MainIdStr="" s MainIdStr=MainId
	.e  s MainIdStr=MainIdStr_","_MainId
	.s Oeori="",chl=0
	.f  s Oeori=$o(^DHCSTMPID("MATDISP",Pid,Adm,Oeori)) q:(Oeori="")||(RtnObj.success'=0)  d
	..s OeoriInfo=^DHCSTMPID("MATDISP",Pid,Adm,Oeori)
	..s InciId=$p(OeoriInfo,"^",2)
	..s Qty=$p(OeoriInfo,"^",3)
	..s UomId=$p(OeoriInfo,"^",4)
	..s Sp=$p(OeoriInfo,"^",5)
	..s SpAmt=$p(OeoriInfo,"^",6)
	..s Barcode=$p(OeoriInfo,"^",7)
	..s Ord=+Oeori
	..s Itm=$p(Oeori,"||",2)
	..s OeFlagId=$p(^OEORD(Ord,"I",Itm,1),"^",13)	//医嘱状态
	..s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	..s PrescNo=$p(^OEORD(Ord,"I",Itm,1),"^",14)	//处方号
	..s OeoriFlag=$p(^OEORD(Ord,"I",Itm,1),"^",13)
	..s chl=chl+1
	..&sql(insert into DHC_MatDispItm(DSI_ParRef,DSI_ChildSub,DSI_OEORI_DR,DSI_Dispensing_DR,DSI_PrescNo,DSI_OriStatus,DSI_INCI_DR,DSI_Qty,DSI_Sp,DSI_SpAmt)
		values(:MainId,:chl,:Oeori,:Dsp,:PrescNo,:OeoriFlag,:InciId,:Qty,:Sp,:SpAmt))
	..i SQLCODE'=0 d RtnObj.Err(-6,"","发放明细保存失败！") q
	..s DetailId=%ROWID
	..s BatSpFlag=..sssBatSpFlag(gHospId,InciId)
	..
	..i Barcode'="" d	//高值
	...s RtnObj=..DispHV(DetailId,MatDispNo,gLocId,gUserId,OeoriInfo,BatSpFlag)
	..e  d	//低值
	...i BatSpFlag=1 d	//批次价
	....s RtnObj=..DispMatBat(DetailId,MatDispNo,gLocId,gUserId,OeoriInfo)
	...e  d	//统一价
	....s RtnObj=..DispMat(DetailId,MatDispNo,gLocId,gUserId,OeoriInfo)
	
	i RtnObj.success=0 s RtnObj.rowid=MainIdStr
	q RtnObj
}

/// 普通高值发放
/// dspiRow, oeori, dispno, ctlocdr, inci, qty, userId, barcode
ClassMethod DispHV(DetailId, MatDispNo, LocId, UserId, OeoriInfo, BatSpFlag) As RtnObj
{
	n (DetailId, MatDispNo, LocId, UserId, OeoriInfo,BatSpFlag)
	s RtnObj=##class(RtnObj).%New()
	
	s Oeori=$p(OeoriInfo,"^",1)
	s InciId=$p(OeoriInfo,"^",2)
	s Qty=$p(OeoriInfo,"^",3)
	s UomId=$p(OeoriInfo,"^",4)
	s Sp=$p(OeoriInfo,"^",5)
	s SpAmt=$p(OeoriInfo,"^",6)
	s Barcode=$p(OeoriInfo,"^",7)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Ord=+Oeori
	s Itm=$p(Oeori,"||",2)
	s AdmLocId=$p(^OEORD(Ord,"I",Itm,9),"^",2)
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s IntrType=$p(IntrTypeInfo,"^",1)
	
	s Dhcit=$o(^DHCIT(0,"LABEL",Barcode,0))
	s:Dhcit="" Dhcit=$o(^DHCIT(0,"ORIGINALCODE",Barcode,""))
	q:Dhcit="" RtnObj.Err(-11,"","高值条码不存在")
	
	s Inclb=$p(^DHCIT(Dhcit),"^",12)
	s DhcitStatus=$p(^DHCIT(Dhcit),"^",5)
	s VendorId=$p(^DHCIT(Dhcit),"^",11)
	s OriginalStatus=$p(^DHCIT(Dhcit),"^",35)
	i OriginalStatus="NotUnique" d
	.s Inclb=##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByBarcodeQty(LocId,Barcode,Qty)
	q:(Inclb="")||($p(Inclb,"||",1)'=InciId) RtnObj.Err(-12,"","高值条码没有对应批次")
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	s RpAmt=Rp*Qty
	
	//1.锁定
	l +^DHCOEDISPENSING(Oeori):20  e  q RtnObj.Err(-13,"","医嘱锁定失败！")
	l +^DHCINCLCBT(Inclb):20  e  q RtnObj.Err(-13,"","批次锁定失败！")

	//2.插入批次发放表
	s chl=1
	&sql(insert into DHC_MatDispItmInclb(DSLB_ParRef,DSLB_ChildSub,DSLB_Qty,DSLB_INCLB_DR,DSLB_Sp,DSLB_SpAmt)
		values(:DetailId,:chl,:Qty,:Inclb,:Sp,:SpAmt))
	i SQLCODE'=0 d
	.d RtnObj.Err(-14,"","保存批次发放表失败！")
	.l -^DHCINCLCBT(Inclb)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//3.处理高值条码状态(高值状态改到增加在途的方法中处理)
	i DhcitStatus'="Used" {
		s operData="^"_UserId_"^"_InciId_"^^^^"
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(IntrType,Oeori,Barcode,operData)
		i RtnObj.success'=0 d
		.d RtnObj.Err(-15,"","更新高值条码状态失败！")
		.l -^DHCINCLCBT(Inclb)
		.l -^DHCOEDISPENSING(Oeori)
	}
	q:RtnObj.success'=0 RtnObj
	
	//4.处理打包表状态
	s ret=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(Oeori,"C",+$h,$p($h,",",2),UserId,IntrType,"")
	i ret'=0 d
	.d RtnObj.Err(-16,"","更新医嘱发放状态失败！")
	.l -^DHCINCLCBT(Inclb)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//5.插入医嘱提取表
	s Incib="",BatNo="",ExpDate="",ManfId=""
	s Remark="高值材料发放"
	s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1)
	i Incib'="" d
	.s IB=$p(Incib,"||",2)
	.s BatNo=$p(^INCI(InciId,"IB",IB),"^",1)
	.s ExpDate=$p(^INCI(InciId,"IB",IB),"^",2)
	.i ExpDate'="" s ExpDate=$zd(ExpDate,3)
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,""),-1)
	.i dhcIncib'="" s ManfId=$p(^DHCINCIB(dhcIncib),"^",7)
	s $p(data,"^",1)=""
	s $p(data,"^",2)=Oeori
	s $p(data,"^",3)=""
	s $p(data,"^",4)=""
	s $p(data,"^",5)=""
	s $p(data,"^",6)=""
	s $p(data,"^",7)=SpAmt
	s $p(data,"^",8)=AdmLocId
	s $p(data,"^",9)=UserId
	s $p(data,"^",10)=""
	s $p(data,"^",11)=BatNo
	s $p(data,"^",12)=ManfId
	s $p(data,"^",13)=VendorId
	s $p(data,"^",14)=UomId
	s $p(data,"^",15)=Qty
	s $p(data,"^",16)=Rp
	s $p(data,"^",17)=Sp
	s $p(data,"^",18)=Barcode
	s $p(data,"^",19)=ExpDate
	s $p(data,"^",20)=""
	s $p(data,"^",21)=""
	s $p(data,"^",22)=""
	s $p(data,"^",23)=""
	s $p(data,"^",24)=InciId
	s $p(data,"^",25)=Remark
	s $p(data,"^",26)=##class(web.DHCSTMHUI.PCHCOLLSM).GetIngri(Barcode)
	s ret=##class(web.DHCSTMHUI.HVMatOrdItm).Update(data)
	i +ret'>0 d
	.d RtnObj.Err(-17,"","保存高值医嘱提取信息失败！")
	.l -^DHCINCLCBT(Inclb)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//6.处理在途数（区分批次售价和统一售价）
	s Qty=-Qty
	s RpAmt=-RpAmt
	s SpAmt=-SpAmt
	i BatSpFlag=1 d
	.s DspID=""
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspID)) q:(DspID="")||(RtnObj.success'=0)  d
	..s TemDspSub=0
	..s TemDspSub=$o(^DHCOEDISQTY(DspID,"I",TemDspSub))
	..i TemDspSub="" d RtnObj.Err(-18,"","获取批次发药表数据失败！")
	..q:RtnObj.success<0
	..s DspSub=0
	..f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(RtnObj.success'=0)  d
	...s DspBatId=DspID_"||"_DspSub
	...s ReservedObj={}
	...s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=Qty
	...s ReservedParams=ReservedObj.%ToJSON()
	...s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	...q:RtnObj.success<0
	e  d
	.;s ret=##class(web.DHCSTMHUI.PCHCOLLSM).ClearResQty(Inclb,Qty)
	.s ReservedObj={}
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=Oeori,ReservedObj.Inclb=Inclb,ReservedObj.Qty=Qty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.q:RtnObj.success<0
	
	//7.处理库存
	s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,Qty)
	i +ret<0 d
	.d RtnObj.Err(-18,"","处理高值库存失败！")
	.l -^DHCINCLCBT(Inclb)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//8.处理台账
	s lstdata=IntrType_"^"_MatDispNo_"^"_Inclb_"^"_Qty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_Oeori_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	i RtnObj.success'=0 d
	.l -^DHCINCLCBT(Inclb)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	l -^DHCINCLCBT(Inclb)
	l -^DHCOEDISPENSING(Oeori)
	q RtnObj
}

/// 低值材料发放
/// dspiRow,oeori,dispno,ctlocdr,inci,qty,userId
ClassMethod DispMat(DetailId, MatDispNo, LocId, UserId, OeoriInfo) As RtnObj
{
	n (DetailId, MatDispNo, LocId, UserId, OeoriInfo)
	s RtnObj=##class(RtnObj).%New()
	
	s Oeori=$p(OeoriInfo,"^",1)
	s InciId=$p(OeoriInfo,"^",2)
	s Qty=$p(OeoriInfo,"^",3)
	s UomId=$p(OeoriInfo,"^",4)
	s Sp=$p(OeoriInfo,"^",5)
	s SpAmt=$p(OeoriInfo,"^",6)
	//s Barcode=$p(OeoriInfo,"^",7)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Ord=+Oeori
	s Itm=$p(Oeori,"||",2)
	s AdmLocId=$p(^OEORD(Ord,"I",Itm,9),"^",2)
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s IntrType=$p(IntrTypeInfo,"^",1)
	
	//1.锁定
	l +^DHCOEDISPENSING(Oeori):20  e  q RtnObj.Err(-11,"","医嘱锁定失败！")
	
	//2.取可用批次和数量
	s Pid=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).SelClbQty(LocId,InciId,Qty)
	i Pid=""  d
	.d RtnObj.Err(-13,"","库存不足","",0)
	.l -^DHCINCIL(LocId,InciId)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//3.处理库存和台账
	s i=0,chl=0
	f  s i=$o(^TMPDHCSTM("SelClbQty",Pid,i)) q:(i="")||(RtnObj.success'=0)  d
	.s Inclb=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",1)
	.s InclbQty=$p(^TMPDHCSTM("SelClbQty",Pid,i),"^",2)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)		;批次进价
	.s RpAmt=Rp*InclbQty
	.s SpAmt=Sp*InclbQty
	.//3.1插入批次发放表
	.s chl=chl+1
	.&sql(insert into DHC_MatDispItmInclb(DSLB_ParRef,DSLB_ChildSub,DSLB_Qty,DSLB_INCLB_DR,DSLB_Sp,DSLB_SpAmt)
		values(:DetailId,:chl,:InclbQty,:Inclb,:Sp,:SpAmt))
	.i SQLCODE'=0 d RtnObj.Err(-14,"","保存批次发放表失败！") q
	.s InclbQty=-InclbQty
	.s RpAmt=-RpAmt
	.s SpAmt=-SpAmt
	.//3.2清在途
	.;s ret=##class(web.DHCSTMHUI.PCHCOLLSM).ClearResQty(Inclb,InclbQty)
	.;i ret'=0 d RtnObj.Err(-14,"","清在途失败") q
	.s ReservedObj={}
	.s Incil=$p(Inclb,"||",1,2)
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=Oeori,ReservedObj.Incil=Incil,ReservedObj.Qty=InclbQty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.q:RtnObj.success<0
	.
	.//3.3处理库存
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,InclbQty)
	.i ret<0 d RtnObj.Err(-15,"","库存消减失败") q
	.//3.4处理台账
	.s lstdata=IntrType_"^"_MatDispNo_"^"_Inclb_"^"_InclbQty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_Oeori_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	
	i RtnObj.success'=0  d
	.l -^DHCINCIL(LocId,InciId)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//4.处理打包表状态
	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(Oeori,"C",+$h,$p($h,",",2),UserId,IntrType,"")
	i err'=0 d
	.d RtnObj.Err(-16,"","更新医嘱发放状态失败！")
	.l -^DHCINCIL(LocId,InciId)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	l -^DHCINCIL(LocId,InciId)
	l -^DHCOEDISPENSING(Oeori)
	q RtnObj
}

ClassMethod DispMatBat(DetailId, MatDispNo, LocId, UserId, OeoriInfo) As RtnObj
{
	n (DetailId, MatDispNo, LocId, UserId, OeoriInfo)
	s RtnObj=##class(RtnObj).%New()
	
	s Oeori=$p(OeoriInfo,"^",1)
	s InciId=$p(OeoriInfo,"^",2)
	s Qty=$p(OeoriInfo,"^",3)
	s UomId=$p(OeoriInfo,"^",4)
	s Sp=$p(OeoriInfo,"^",5)
	s SpAmt=$p(OeoriInfo,"^",6)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Ord=+Oeori
	s Itm=$p(Oeori,"||",2)
	s AdmLocId=$p(^OEORD(Ord,"I",Itm,9),"^",2)
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s IntrType=$p(IntrTypeInfo,"^",1)
	
	//1.锁定
	l +^DHCOEDISPENSING(Oeori):20  e  q RtnObj.Err(-11,"","医嘱锁定失败！")
	//l +^DHCINCIL(LocId,InciId):20  q RtnObj.Err(-12,"","科室库存锁定失败！")
	//2.处理库存及台账
	s DspID="",chl=0
	f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspID)) q:(DspID="")!(RtnObj.success'=0)  d
	.s DspSub=0,TemDspSub=0
	.s TemDspSub=$o(^DHCOEDISQTY(DspID,"I",TemDspSub))
	.i TemDspSub="" d RtnObj.Err(-14,"","无对应批次打包表数据！","",0)
	.q:RtnObj.success'=0
	.;i TemDspSub="" s RetCode=-1 q
	.s Sp=$p(^DHCOEDISQTY(DspID,"I",TemDspSub),"^",4)
	.f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(RtnObj.success'=0)  d
	..s DspBatId=DspID_"||"_DspSub
	..s Inclb=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",1)
	..s InclbQty=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",2)
	..s Rp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",3)
	..s RpAmt=InclbQty*Rp
	..s SpAmt=InclbQty*Sp
	..s chl=chl+1
	..//2.1插入批次发放表
	..&sql(insert into DHC_MatDispItmInclb(DSLB_ParRef,DSLB_ChildSub,DSLB_Qty,DSLB_INCLB_DR,DSLB_Sp,DSLB_SpAmt)
		values(:DetailId,:chl,:InclbQty,:Inclb,:Sp,:SpAmt))
	..i SQLCODE'=0 d RtnObj.Err(-14,"","保存批次发放表失败！")
	..s InclbQty=-InclbQty
	..s RpAmt=-RpAmt
	..s SpAmt=-SpAmt
	..//2.2处理在途
	..;s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,InclbQty)
	..;i ret'=0 d RtnObj.Err(-15,"","清在途失败！")
	..s ReservedObj={}
	..s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspBatId,ReservedObj.Inclb=Inclb,ReservedObj.Qty=InclbQty
	..s ReservedParams=ReservedObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	..q:RtnObj.success<0
	..
	..//2.3处理库存
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,InclbQty)	//处理库存
	..i ret='0 d RtnObj.Err(-16,"","处理库存失败！")
	..//2.4插入台账
	..s Data=IntrType_"^^"_Inclb_"^"_InclbQty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_Oeori_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(Data) //处理台帐
	i RtnObj.success'=0  d
	.l -^DHCINCIL(LocId,InciId)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//3.处理打包表状态
	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(Oeori,"C",+$h,$p($h,",",2),UserId,IntrType,"")
	i err'=0 d
	.d RtnObj.Err(-17,"","更新医嘱发放状态失败！")
	.l -^DHCINCIL(LocId,InciId)
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	l -^DHCINCIL(LocId,InciId)
	l -^DHCOEDISPENSING(Oeori)
	q RtnObj
}

/// Descript: 根据卡号取登记号
/// Creater: tsr
/// CreateDate: 2017-02-22
ClassMethod GetPatNoByCardNo(cardno)
{
	n (cardno)
	q:cardno="" ""
	s cardrow="0",retpatno=""
	f  s cardrow=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardrow)) q:(cardrow="")!(cardrow="0")  d
	.s cardstatus="",pmi=""
	.s cardstatus=$p(^DHCCARD("CF",cardrow),"^",10)
	.i cardstatus="" s cardstatus="N"
	.q:cardstatus'["N"
	.s pmi=+$p(^DHCCARD("CF",cardrow),"^",4)
	.s retpatno=$p(^PAPER(pmi,"PAT",1),"^",2)	
	q retpatno
}

/// w ##class(web.DHCSTMHUI.DHCMatDisp).GetPrintDispStr("115","6423","9","")
ClassMethod GetPrintDispStr(LocId, UserId, DispId = "", AdmStr = "")
{
	n (LocId,UserId,DispId,AdmStr)
	
	s Adm=$p(AdmStr,"^",1)
	s PrtId=$p(AdmStr,"^",2)
	s pDispFlag=$p(AdmStr,"^",3)
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s HospId=..sssHospId(LocId)
	
	s Pid=..NewPid()
	k ^DHCSTMPID("PrintDispInfo","MainTitle",Pid)
	k ^DHCSTMPID("PrintDispInfo","MainData",Pid)
	k ^DHCSTMPID("PrintDispInfo","Detail",Pid)
	
	s Ord="",SumSpAmt=0,num=0
	i DispId="" d
	.f  s Ord=$o(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
	..s Itm=0
	..f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	...s RecLocId=+$p(^OEORD(Ord,"I",Itm,3),"^",6)
	...q:(RecLocId="")!(RecLocId'=LocId)
	...s Oeori=Ord_"||"_Itm
	...s CheckOeoriConditonFlag=..CheckOeoriConditon(Adm,Oeori,"")
	...q:CheckOeoriConditonFlag'="Y"
	...
	...s Oeori=Ord_"||"_Itm
	...s OPPrtRowID=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	...q:(PrtId'="")&&(PrtId'=OPPrtRowID) 	//根据收费ID过滤发放材料
	...
	...s DispFlag=..GetOeoriDispFlag(Oeori)
	...q:DispFlag<0
	...q:(DispFlag'=0)&(pDispFlag'="Y") 
	...q:(DispFlag=0)&(pDispFlag="Y")
	...
	...s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)		//医嘱项
	...s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	...s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	...s Qty=$p(^DHCOEDISQTY(Dsp),"^",2)
	...s DspDate=$p(^DHCOEDISQTY(Dsp),"^",8)
	...i DspDate="" s DspDate=+$h
	...s UomId=$p(^DHCOEDISQTY(Dsp),"^",6)	;发放单位
	...s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,DspDate,UomId,HospId,"")
	...s SpAmt=Sp*Qty
	...s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(SpAmt,HospId,2)
	...s SumSpAmt=SumSpAmt+SpAmt
	...s num=num+1
	...s ^DHCSTMPID("PrintDispInfo","Detail",Pid,num)=Oeori_"^"_InciId_"^"_Qty_"^"_Sp_"^"_SpAmt_"^"_UomId
	e  d
	.s DispItmChl=""
	.f  s DispItmChl=$o(^DHCMATDISP(DispId,"I",DispItmChl)) q:DispItmChl=""  d
	..s Oeori=$p(^DHCMATDISP(DispId,"I",DispItmChl),"^",1)
	..s Adm=$p(^OEORD($p(Oeori,"||",1)),"^",1)
	..s InciId=$p(^DHCMATDISP(DispId,"I",DispItmChl),"^",5)
	..s Qty=$p(^DHCMATDISP(DispId,"I",DispItmChl),"^",6)
	..s Sp=$p(^DHCMATDISP(DispId,"I",DispItmChl),"^",7)
	..s SpAmt=$p(^DHCMATDISP(DispId,"I",DispItmChl),"^",8)
	..s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	..s UomId=$p(^DHCOEDISQTY(Dsp),"^",6)
	..s SumSpAmt=SumSpAmt+SpAmt
	..s num=num+1
	..s ^DHCSTMPID("PrintDispInfo","Detail",Pid,num)=Oeori_"^"_InciId_"^"_Qty_"^"_Sp_"^"_SpAmt_"^"_UomId
	
	s tmpnum=$o(^DHCSTMPID("PrintDispInfo","Detail",Pid,0))
	q:tmpnum="" ""
	s tmpOeori=$p(^DHCSTMPID("PrintDispInfo","Detail",Pid,tmpnum),"^",1)
	s OrdDate="",OrdTime="",BillType="",PrtNo=""
	i tmpOeori'="" d
	.s OeoriObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetOeoriData(tmpOeori)
	.s OrdDate=OeoriObj.OrdDate
	.s OrdTime=OeoriObj.OrdTime
	.s BillType=OeoriObj.BillType
	.s PrtNo=OeoriObj.PrtNo
	
	s AdmObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(Adm)
	s DiagDesc=AdmObj.DiagDesc
	s AdmType=AdmObj.AdmType
	s AdmLocDesc=AdmObj.AdmLocDesc
	s PatDocName=AdmObj.PatDocName
	
	s PatObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(Adm)
	s PatId=PatObj.PatId
	s PatName=PatObj.PatName
	s PatNo=PatObj.PatNo
	s PatAge=PatObj.PatAge
	s PatSex=PatObj.PatSex
	s PatCompany=PatObj.PatCompany
	s PatPhone=PatObj.PatPhone
	s PatAddress=PatObj.PatAddress
	s PatNation=PatObj.PatNation
	s PatCardNo=PatObj.PatCardNo
	s PatHeight=PatObj.PatHeight
	s PatWeight=PatObj.PatWeight
	s MrNo=PatObj.MrNo
	
	s HospDesc=$p(^CT("HOSP",HospId),"^",2)
	s Title=HospDesc_"材料发放单"
	s ZfFlag = "["_"正方"_"]"
	s PrescTitle=""
	s PrescNo=""
	s BarCode="*"_PrescNo_"*"
	s PatNoBarCode="*"_PatNo_"*"
	s SumSpAmt=SumSpAmt_"元"
	s PrescCount=""
	
	s ^DHCSTMPID("PrintDispInfo","MainTitle",Pid)="Pid^Title^ZDF^PrescTitle^PrescNo^BarCode^verDiagDesc1^Name^PatName^PANo^PatNoBarCode^PatNoBarCode^Age^PatAge^Sex^PatSex^AdmDep^PatLoc^Doctor^UserAddName^MrNo^RecLoc^Company^OrdDate^PatH^PatWeight^PatICD^PatCall^PatAdd^PatNation^patCardNo^PyName^FyName^BillType^Sum^PrescCount^prtNo^OeoriNum"
	s ^DHCSTMPID("PrintDispInfo","MainData",Pid)=Pid_"^"_Title_"^"_ZfFlag_"^"_PrescTitle_"^"_PrescNo_"^"_BarCode_"^"_DiagDesc_"^"_PatName_"^"_PatName_"^"_PatNo_"^"_PatNo_"^"_PatNoBarCode_"^"_PatAge_"^"_PatAge_"^"_PatSex_"^"_PatSex_"^"_AdmLocDesc_"^"_AdmLocDesc_"^"_PatDocName_"^"_PatDocName_"^"_MrNo_"^"_LocDesc_"^"_PatCompany_"^"_OrdDate_"^"_PatHeight_"^"_PatWeight_"^"_DiagDesc_"^"_PatPhone_"^"_PatAddress_"^"_PatNation_"^"_PatCardNo_"^"_UserName_"^"_UserName_"^"_BillType_"^"_SumSpAmt_"^"_PrescCount_"^"_PrtNo_"^"_num

	q Pid_"^"_num
}

/// CreatDate:2021-03=23
/// Creator:lxt
/// Description:查询发放信息
/// Table:医嘱表
/// Input:就诊号
/// OutPut:发放信息
/// w ##class(web.DHCSTMHUI.DHCMatDisp).GetPrintDispInfo(43170,1)
ClassMethod GetPrintDispInfo(Pid, Page) As %String
{
	n (Pid,Page)
	
	s BaseNum=5
	s CountBeg=(Page-1)*BaseNum+1
	s CountEnd=Page*BaseNum
	
	s (Text111,Text112,Text211,Text212,Text121,Text122,Text221,Text222,Text131,Text132,Text231,Text232,Text141,Text142,Text241,Text242,Text151,Text152,Text251,Text251)=""
	s num=1
	f Count=CountBeg:1:CountEnd  d
	.q:'$d(^DHCSTMPID("PrintDispInfo","Detail",Pid,Count))
	.s OeoriStr=^DHCSTMPID("PrintDispInfo","Detail",Pid,Count)
	.s Oeori=$p(OeoriStr,"^",1)
	.s InciId=$p(OeoriStr,"^",2)
	.s Qty=$p(OeoriStr,"^",3)
	.s Sp=$p(OeoriStr,"^",4)
	.s SpAmt=$p(OeoriStr,"^",5)
	.s UomId=$p(OeoriStr,"^",6)
	.s Adm=$p(^OEORD($p(Oeori,"||",1)),"^",1)
	.s Ord=+Oeori
	.s Itm=$p(Oeori,"||",2)
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	.s UomDesc=$p(^CT("UOM",UomId),"^",2)
	.//医嘱信息
	.s OeoriObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetOeoriData(Oeori)
	.s Dosage=OeoriObj.Dosage
	.s InstrucDesc=OeoriObj.InstrucDesc
	.s Remark=OeoriObj.Remark
	.s FreqDesc=OeoriObj.FreqDesc
	.i Dosage'="" s Dosage="每次"_Dosage_" "
	.
	.s num=num+1
	.s ListStr1=Count_"、"_InciDesc_"  X  "_Qty_UomDesc
	.s ListStr2="             用法："_Dosage_InstrucDesc_" "_FreqDesc_" "_Remark
	.s:num=1 Text111=ListStr1,Text112=ListStr2,Text211=ListStr1,Text212=ListStr2
	.s:num=2 Text121=ListStr1,Text122=ListStr2,Text221=ListStr1,Text222=ListStr2
	.s:num=3 Text131=ListStr1,Text132=ListStr2,Text231=ListStr1,Text232=ListStr2
	.s:num=4 Text141=ListStr1,Text142=ListStr2,Text241=ListStr1,Text242=ListStr2
	.s:num=5 Text151=ListStr1,Text152=ListStr2,Text251=ListStr1,Text252=ListStr2
	.
	s MainTitle=^DHCSTMPID("PrintDispInfo","MainTitle",Pid)
	s MainData=^DHCSTMPID("PrintDispInfo","MainData",Pid)
	s DetailTitle="Text111^Text112^Text211^Text212^Text121^Text122^Text221^Text222^Text131^Text132^Text231^Text232^Text141^Text142^Text241^Text242^Text151^Text152^Text251^Text251"
	s DetailData=Text111_"^"_Text112_"^"_Text211_"^"_Text212_"^"_Text121_"^"_Text122_"^"_Text221_"^"_Text222_"^"_Text131_"^"_Text132_"^"_Text231_"^"_Text232_"^"_Text141_"^"_Text142_"^"_Text241_"^"_Text242_"^"_Text151_"^"_Text152_"^"_Text251_"^"_Text251
	
	s Title=MainTitle_"^"_DetailTitle
	s Data=MainData_"^"_DetailData
	s PrintData=##class(web.DHCSTMHUI.Common.UtilCommon).GetXmlPrintData(Title,Data)
	q PrintData
}

}
