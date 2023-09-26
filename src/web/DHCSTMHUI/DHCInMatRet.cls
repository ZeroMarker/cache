Import sqluser

/// Descript:	物资住院退回
/// Creator:	lxt
/// CreateDate:	2021-04-20
Class web.DHCSTMHUI.DHCInMatRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTINMATDISPRETM";

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatRet","QueryInMatNeedRet",^templxt("QueryInMatNeedRet"))
Query QueryInMatNeedRet(Params As %String) As Query(ROWSPEC = "DMainId,DDetailId,WardLocId,WardLocDesc,DspId,PatNo,BedNo,UomId,UomDesc,DspQty:%Float,AlRetQty:%Float,RetQty:%Float,InciId,InciCode,InciDesc,DispDate,PatName,DispTime,DispNo") [ SqlProc ]
{
}

ClassMethod QueryInMatNeedRetExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s pStartDate=PJObj.%Get("StartDate")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s pEndDate=PJObj.%Get("EndDate")
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s pWardLocId=PJObj.%Get("WardLoc")
	s pInciId=PJObj.%Get("Inci")
	s pPatNo=PJObj.%Get("PatNo")
	s pDispNo=PJObj.%Get("DispNo")

	s Pid=..NewPid()
	
	s Date="",DspStatus="C"
	f Date=pStartDate:1:pEndDate d
	.s DispDate=..DL2H(Date)
	.s WardLocId=0
	.f  s WardLocId=$o(^User.DHCInMatDispI("DateLocWard",Date,gLocId,WardLocId)) q:(WardLocId="")  d
	..q:(pWardLocId'="")&&(pWardLocId'=WardLocId)
	..s WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
	..s DMainId=0
	..f  s DMainId=$o(^User.DHCInMatDispI("DateLocWard",Date,gLocId,WardLocId,DMainId)) q:(DMainId="")  d
	...s MainInfo=^User.DHCInMatDispD(DMainId)
	...s DispNo=$lg(MainInfo,2)
	...q:(pDispNo'="")&&(pDispNo'=DispNo)
	...s UserId=$lg(MainInfo,5)
	...s DispTime=$lg(MainInfo,4)
	...s:DispTime'="" DispTime=..TL2H(DispTime)
	...s Chl=0
	...f  s Chl=$o(^User.DHCInMatDispD(DMainId,"ChildDHCInMatDispItm",Chl)) q:(Chl="")  d
	....s DDetailId=DMainId_"||"_Chl
	....s DetailInfo=^User.DHCInMatDispD(DMainId,"ChildDHCInMatDispItm",Chl)
	....s AdmId=$lg(DetailInfo,2)
	....s PatId=$p(^PAADM(AdmId),"^",1)
	....s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	....q:(pPatNo'="")&&(pPatNo'=PatNo)
	....s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	....s AdmLocId=$lg(DetailInfo,3)
	....s Oeori=$lg(DetailInfo,4)
	....s DspId=$lg(DetailInfo,5)
	....s CheckDspConditonFlag=..CheckDspConditon(DspId)
	....q:CheckDspConditonFlag'="Y"
	....s BedNo=$lg(DetailInfo,6)
	....s DoseDate=$lg(DetailInfo,7)
	....s:DoseDate'="" DoseDate=..DL2H(DoseDate)
	....s InciId=$lg(DetailInfo,9)
	....s DspQty=+$lg(DetailInfo,10)
	....s Sp=$lg(DetailInfo,11)
	....s SpAmt=$lg(DetailInfo,12)
	....s AlRetQty=+$lg(DetailInfo,13)
	....s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
	....s UomDesc=$p(^CT("UOM",UomId),"^",2)
	....s InciCode=$p(^INCI(InciId,1),"^",1)
	....s InciDesc=$p(^INCI(InciId,1),"^",2)
	....s RetQty=DspQty-AlRetQty
	....q:RetQty'>0
	....d OutPutRow1
	
	Quit $$$OK
OutPutRow1
	s Data=$lb(DMainId,DDetailId,WardLocId,WardLocDesc,DspId,PatNo,BedNo,UomId,UomDesc,DspQty,AlRetQty,RetQty,InciId,InciCode,InciDesc,DispDate,PatName,DispTime,DispNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod CheckDspConditon(DspId) As %Library.String
{
	n (DspId)
	s DspData=^DHCOEDISQTY(DspId)
	s Oeori=$p(DspData,"^",1)	//医嘱id
	s Oeore=$p(DspData,"^",3)	//执行记录id
	s Status=$p(DspData,"^",7)
	q:Status'="C" "N"
	s OrdId=+Oeori
	s OrdItm=+$p(Oeori,"||",2)
	s Ore=$p(Oeore,"||",3)
	s AdmId=$p(^OEORD(OrdId),"^",1)
	s AdmType=$p($g(^PAADM(AdmId)),"^",2)
	q:AdmType'="I" "N"	//过滤非住院
	
	s OStat=$p(^OEORD(OrdId,"I",OrdItm,1),"^",13)	;医嘱状态id
	s OeFlag=$p(^OEC("OSTAT",OStat),"^",1)
	q:(OeFlag'="C")&&(OeFlag'="U")&&(OeFlag'="D") "N"	;撤销,作废,停止
	
	s VisitStatus=##class(web.DHCSTMHUI.Common.ServiceCommon).GetCurrentAdmStatus(AdmId)
	q:VisitStatus=0 "N"
	
	q:$p(^OEORD(OrdId,"I",OrdItm,1),"^",13)="" "N"
	
	//过滤-医生科室
	s DocLocId=$p(^OEORD(OrdId,"I",OrdItm,7),"^",2)
	//q:..DoctorLocRefuse(LocId,DocLocId)=1 "N"
	
	//过滤
	s PriorityId=$p(^OEORD(OrdId,"I",OrdItm,1),"^",8) 
	q:PriorityId="" "N"
	s PriCode=$p($g(^OECPR(+PriorityId)),"^",1)
	
	s AdminStatus=""
	i PriCode="S" d
	.s OreStatusDr=$p(^OEORD(OrdId,"I",OrdItm,"X",Ore),"^",16)		;护士执行状态
	.q:OreStatusDr=""
	.s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1) 
	q:(PriCode="S")&&(AdminStatus'="D") "N"
	
	q "Y"
}

/// w ##class(web.DHCSTMHUI.DHCInMatRet).jsInMatRet(^templxt("jsInMatRet1"),^templxt("jsInMatRet2"))
ClassMethod jsInMatRet(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..InMatRet(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod InMatRet(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-2,"","明细入参解析失败!")
	
	s gHospId=MainObj.%Get("gHospId")
	s gGroupId=MainObj.%Get("gGroupId")
	s gLocId=MainObj.%Get("gLocId")
	s gUserId=MainObj.%Get("gUserId")
	
	s AppName=..%GetParameter("AppName")
	s Date=+$h
	s Time=$p($h,",",2)
	s Pid=..NewPid()
	k ^TMPDHCSTM(Pid,"InMatRet")
	while(RtnObj.success=0){
		s Obj=DetailObj.%Pop()
		q:Obj=""
		s DMainId=Obj.%Get("DMainId")
		s DDetailId=Obj.%Get("DDetailId")
		s WardLocId=Obj.%Get("WardLocId")
		s DspId=Obj.%Get("DspId")
		s RetQty=Obj.%Get("RetQty")
		s ^TMPDHCSTM(Pid,"InMatRet",WardLocId,DspId)=DMainId_"^"_DDetailId_"^"_RetQty
	}
	s IntrType="MDY",DispType="MDP"
	s WardLocId="",MainIdStr=""
	f  s WardLocId=$o(^TMPDHCSTM(Pid,"InMatRet",WardLocId))  q:(WardLocId="")||(RtnObj.success'=0)  d
	.s MatRetNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",gLocId)
	.i MatRetNo="" d RtnObj.Err(-2,"","退回单号生成失败！")
	.&sql(insert into DHC_InMatRet(IRE_No,IRE_Date,IRE_Time,IRE_SSUSR_DR,IRE_CTLOC_DR,IRE_WardLoc_DR)
		values(:MatRetNo,:Date,:Time,:gUserId,:gLocId,:WardLocId))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","退回主单保存失败！")
	.s MainId=%ROWID
	.i MainIdStr="" s MainIdStr=MainId
	.e  s MainIdStr=MainIdStr_","_MainId
	.s DspId="",chl=0
	.f  s DspId=$o(^TMPDHCSTM(Pid,"InMatRet",WardLocId,DspId))  q:(DspId="")||(RtnObj.success'=0)  d
	..s Data=^TMPDHCSTM(Pid,"InMatRet",WardLocId,DspId)
	..s DMainId=$p(Data,"^",1)
	..s DDetailId=$p(Data,"^",2)
	..s RetQty=$p(Data,"^",3)
	..s DDInfo=^User.DHCInMatDispD(DMainId,"ChildDHCInMatDispItm",$p(DDetailId,"||",2))
	..s AdmId=$lg(DDInfo,2)
	..s PatId=$p(^PAADM(AdmId),"^",1)
	..s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	..s AdmLocId=$lg(DDInfo,3)
	..s Oeori=$lg(DDInfo,4)
	..s DspId=$lg(DDInfo,5)
	..s InciId=$lg(DDInfo,9)
	..s DspQty=$lg(DDInfo,10)
	..s Sp=$lg(DDInfo,11)
	..s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
	..s Oeore=$p(^DHCOEDISQTY(DspId),"^",3)
	..s AlRetQty=+$lg(DDInfo,13)
	..i (DspQty-AlRetQty)>RetQty d RtnObj.Err(-4,"","退回数量超过可退回数量","",0)
	..s SpAmt=RetQty*Sp
	..s chl=chl+1
	..&sql(insert into DHC_InMatRetItm(IREI_ParRef,IREI_ChildSub,IREI_ADM_DR,IREI_ADMLOC_DR,
		IREI_OEORI_DR,IREI_DSP_DR,IREI_INCI_DR,IREI_Qty,IREI_Sp,IREI_SpAmt,IREI_MatDsp_DR)
		values(:MainId,:chl,:AdmId,:AdmLocId,:Oeori,"",:InciId,:RetQty,:Sp,:SpAmt,:DDetailId))
	..i SQLCODE'=0 d RtnObj.Err(-4,"","退回明细保存失败！")
	..s DetailId=%ROWID
	..s tmpQty=AlRetQty+RetQty
	..&sql(update DHC_InMatDispItm set IDSI_RetQty=:tmpQty where %ID=:DDetailId)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","更新退回数量失败！")
	..s LBChl="",LeftQty=RetQty,DChl=$p(DDetailId,"||",2),RetLbChl=0
	..f  s LBChl=$o(^User.DHCInMatDispD(DMainId,"ChildDHCInMatDispItm",DChl,"ChildDHCInMatDispInclb",LBChl)) q:(LBChl="")||(LeftQty=0)||(RtnObj.success'=0)  d
	...s DispInclb=DMainId_"||"_DChl_"||"_LBChl
	...s LBInfo=^User.DHCInMatDispD(DMainId,"ChildDHCInMatDispItm",DChl,"ChildDHCInMatDispInclb",LBChl)
	...s Inclb=$lg(LBInfo,2)
	...s DspI=$lg(LBInfo,3)
	...s LBDspQty=$lg(LBInfo,4)
	...s LBSp=$lg(LBInfo,5)
	...s LBAlRetQty=$lg(LBInfo,7)
	...i (LBAlRetQty+LeftQty)>LBDspQty d
	....s DelQty=LBDspQty-LBAlRetQty
	....s LBAlRetQty=LBDspQty
	...e  d
	....s DelQty=LeftQty
	....s LBAlRetQty=LBAlRetQty+DelQty
	...&sql(update DHC_InMatDispInclb set IDSLB_RetQty=:LBAlRetQty where %ID=:DispInclb)
	...i SQLCODE'=0 d RtnObj.Err(-33,"","更新明细退回数量失败")
	...s RetLbChl=RetLbChl+1
	...s LBSpAmt=DelQty*LBSp
	...&sql(insert into DHC_InMatRetInclb(IRELB_ParRef,IRELB_ChildSub,IRELB_INCLB_DR,IRELB_DSPI_DR,
		IRELB_Qty,IRELB_Sp,IRELB_SpAmt,IRELB_MatDsp_DR) 
		values
		(:DetailId,:RetLbChl,:Inclb,"",:DelQty,:LBSp,:LBSpAmt,:DispInclb))
	...i SQLCODE'=0 d RtnObj.Err(-33,"","保存批次退回信息失败")
	...s RetLBId=%ROWID
	...s LeftQty=LeftQty-DelQty
	...s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,DelQty)
	...i Ret'=0 d RtnObj.Err(-34,"","处理库存失败")
	...s LBRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,gHospId)		;批次进价
	...s LBRpAmt=DelQty*LBRp
	...s Data=IntrType_"^"_""_"^"_Inclb_"^"_DelQty_"^"_UomId_"^"_LBSp_"^"_gUserId_"^"_RetLBId_"^"_LBRp_"^"_LBRpAmt_"^"_LBSpAmt
	...s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(Data)
	..s err=##Class(web.DHCSTMHUI.COMMOE).InsDispensing(Oeore,"R",+$h,$p($h,",",2),gUserId,IntrType,"",RetQty,UomId)
	..i err'=0 d RtnObj.Err(-33,"","插入打包表失败")
	..s tmpRetDspId="",RetDspId=""
	..f  s tmpRetDspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,tmpRetDspId),-1)  q:(tmpRetDspId="")||(RetDspId'="")  d
	...s DspStat=$p(^DHCOEDISQTY(tmpRetDspId),"^",7)
	...i DspStat="R" s RetDspId=tmpRetDspId
	..&sql(update DHC_InMatRetItm set IREI_DSP_DR=:RetDspId where ID=:DetailId)
	..i SQLCODE'=0 d RtnObj.Err(-34,"","记录打包表失败！")

	q RtnObj
}

/// 查询住院退回主表信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatRet","QueryInMatDispMain",^templxt("QueryInMatDispMain"))
Query QueryInMatDispRetMain(Params As %String) As Query(ROWSPEC = "RowId,DispRetNo,Date,Time,UserId,UserName,LocId,LocDesc,WardLocId,WardLocDesc") [ SqlProc ]
{
}

ClassMethod QueryInMatDispRetMainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s pStartDate=PJObj.%Get("StartDate")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s pEndDate=PJObj.%Get("EndDate")
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s pWardLocId=PJObj.%Get("WardLoc")
	s pRetNo=PJObj.%Get("RetNo")
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"IRE_No as DispRetNo,"
	s SqlStr=SqlStr_"IRE_Date as DspRetDate,"
	s SqlStr=SqlStr_"IRE_Time as DspRetTime,"
	s SqlStr=SqlStr_"IRE_SSUSR_DR as UserId,"
	s SqlStr=SqlStr_"IRE_CTLOC_DR as LocId,"
	s SqlStr=SqlStr_"IRE_WardLoc_DR as WardLocId "
	s SqlStr=SqlStr_" from DHC_InMatRet"
	s SqlStr=SqlStr_" where IRE_CTLOC_DR="_gLocId
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s LocDesc="",WardLocDesc="",UserName=""
		s RowId = Result.Data("RowId")
		s DispRetNo = Result.Data("DispRetNo")
		continue:(pRetNo'="")&&(pRetNo'=DispRetNo)
		s Date=Result.Data("DspRetDate")
		continue:Date<pStartDate
		continue:Date>pEndDate
		s:Date'="" Date=..DL2H(Date)
		s Time=Result.Data("DspRetTime")
		s:Time'="" Time=..TL2H(Time)
		s UserId=Result.Data("UserId")
		s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
		s LocId=Result.Data("LocId")
		s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
		s WardLocId=Result.Data("WardLocId")
		s:WardLocId'="" WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
		continue:(pWardLocId'="")&&(pWardLocId'=WardLocId)
		d OutPutInDispRetMain
	}
	Quit $$$OK
	
OutPutInDispRetMain
	s Data=$lb(RowId,DispRetNo,Date,Time,UserId,UserName,LocId,LocDesc,WardLocId,WardLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatRet","QueryInMatDispRetItm",^templxt("QueryInMatDispItm"))
Query QueryInMatDispRetItm(Parref As %String) As Query(ROWSPEC = "RowId,AdmId,AdmLocId,AdmLocDesc,Oeori,DspId,UomId,UomDesc,InciId,InciCode,InciDesc,Spec,Qty:%Float,Sp:%Float,SpAmt:%Float,PatName,BedNo,DispDate,DispTime") [ SqlProc ]
{
}

ClassMethod QueryInMatDispRetItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"IREI_ADM_DR as AdmId,"
	s SqlStr=SqlStr_"IREI_ADMLOC_DR as AdmLocId,"
	s SqlStr=SqlStr_"IREI_OEORI_DR as Oeori,"
	s SqlStr=SqlStr_"IREI_DSP_DR as DspId,"
	s SqlStr=SqlStr_"IREI_MatDsp_DR->IDSI_BedNo as BedNo,"
	s SqlStr=SqlStr_"IREI_INCI_DR as InciId,"
	s SqlStr=SqlStr_"IREI_Qty as Qty,"
	s SqlStr=SqlStr_"IREI_Sp as Sp,"
	s SqlStr=SqlStr_"IREI_MatDsp_DR as InMatDispItm,"
	s SqlStr=SqlStr_"IREI_SpAmt as SpAmt "
	s SqlStr=SqlStr_" from DHC_InMatRetItm where IREI_ParRef="_Parref
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s AdmLocDesc="",UomDesc=""
		s RowId = Result.Data("RowId")
		s AdmId = Result.Data("AdmId")
		s AdmLocId=Result.Data("AdmLocId")
		s:AdmLocId'="" AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
		s Oeori=Result.Data("Oeori")
		s DspId=Result.Data("DspId")
		s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s InciId=Result.Data("InciId")
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s Qty=Result.Data("Qty")
		s Sp=Result.Data("Sp")
		s SpAmt=Result.Data("SpAmt")
		s BedNo=Result.Data("BedNo")
		s PatId=$p(^PAADM(AdmId),"^",1)
		s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
		s InMatDispItm=Result.Data("InMatDispItm")
		s (DispDate,DispTime)=""
		i +InMatDispItm>0 d
		.s DMainId=+InMatDispItm
		.s MainInfo=^User.DHCInMatDispD(DMainId)
		.s DispTime=$lg(MainInfo,4)
		.s DispDate=$lg(MainInfo,3)
		.s:DispTime'="" DispTime=..TL2H(DispTime)
		.s:DispDate'="" DispDate=..DL2H(DispDate)
		d OutPutInDispRetDetail
	}
	Quit $$$OK
	
OutPutInDispRetDetail
	s Data=$lb(RowId,AdmId,AdmLocId,AdmLocDesc,Oeori,DspId,UomId,UomDesc,InciId,InciCode,InciDesc,Spec,Qty,Sp,SpAmt,PatName,BedNo,DispDate,DispTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
