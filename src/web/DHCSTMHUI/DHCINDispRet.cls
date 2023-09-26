Import sqluser

Class web.DHCSTMHUI.DHCINDispRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINDISPRETM";

/// Description:查询退回单列表
/// Creator:	tsr
/// CreatDate:	2019-04-04
/// Table:		dhc_indispret
/// Input:		
/// Return:	
Query DHCINDispRet(Params As %String) As Query(ROWSPEC = "RowId,DsrNo,LocDesc,CreateDate,CreateTime,CreateUser,AuditUser,AuditDate,AuditTime,ScgDesc,Comp,Status,ChkFlag,RetLoc") [ SqlProc ]
{
}

ClassMethod DHCINDispRetExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s LocId=PJObj.%Get("LocId")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s AuditFlag=PJObj.%Get("AuditFlag")
	s CompFlag=PJObj.%Get("CompFlag")
	q:LocId="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s:AuditFlag="" AuditFlag="N"
	s Type=..sssCode()

	s SqlStr="select %ID RowId,"
	s SqlStr=SqlStr_"dsr_NO DsrNo,"
	s SqlStr=SqlStr_"dsr_ctloc_dr->ctloc_desc LocDesc,"
	s SqlStr=SqlStr_"dsr_date CreateDate,"
	s SqlStr=SqlStr_"dsr_time CreateTime,"
	s SqlStr=SqlStr_"dsr_ssusr_dr->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"dsr_AckDate AuditDate,"
	s SqlStr=SqlStr_"dsr_acktime AuditTime,"
	s SqlStr=SqlStr_"dsr_ackuser_dr->ssusr_name AuditUser,"
	s SqlStr=SqlStr_"dsr_scg_dr->scg_desc ScgDesc,"
	s SqlStr=SqlStr_"nvl(dsr_completed,'N') Comp,"
	s SqlStr=SqlStr_"nvl(dsr_ackflag,'N') ChkFlag,"
	s SqlStr=SqlStr_"DSR_Status Status,"
	s SqlStr=SqlStr_"DSR_RetLOC_DR RetLocId,"
	s SqlStr=SqlStr_"DSR_RetLOC_DR->CTLoc_Desc RetLoc"
	s SqlStr=SqlStr_" From dhc_indispret"
	s SqlStr=SqlStr_" Where dsr_ctloc_dr="_LocId
	s SqlStr=SqlStr_" And dsr_stktype='"_Type_"'"
	s SqlStr=SqlStr_" And dsr_date between "_StartDate_" And "_EndDate
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s DsrNo=xrs.Data("DsrNo")
		s LocDesc=xrs.Data("LocDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s AuditUser=xrs.Data("AuditUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s ScgDesc=xrs.Data("ScgDesc")
		s Comp=xrs.Data("Comp")
		s Status=xrs.Data("Status")
		s ChkFlag=xrs.Data("ChkFlag")
		s RetLocId=xrs.Data("RetLocId")
		s RetLoc=xrs.Data("RetLoc")
		CONTINUE:AuditFlag'=ChkFlag
		CONTINUE:(CompFlag'="")&&(CompFlag'=Comp)
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s RetLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RetLoc)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		d OutPutRow
	} 
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DsrNo,LocDesc,CreateDate,CreateTime,CreateUser,AuditUser,AuditDate,AuditTime,ScgDesc,Comp,Status,ChkFlag,RetLoc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod jsAudit(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(Main,Detail)
	q RtnObj.Json()
}

/// Description:审核退回单
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indispret
ClassMethod Audit(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s gUserId=PJObj.%Get("gUserId")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		i ..sssLock(..%GetParameter("AppName")_RowId)<0 d RtnObj.Err(-99,"","加锁失败!")
		q:RtnObj.success'=0
		s RtnObj=..AllowAudit(RowId)
		i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_RowId)
		q:RtnObj.success'=0
		s ErrMsg=..ChkDispRetItmData(RowId)	//核查数据
		i ErrMsg'="" d
		.d ..sssUnLock(..%GetParameter("AppName")_RowId)
		.d RtnObj.Err(-5,"",ErrMsg)
		q:RtnObj.success'=0
		s Status="20",Chk="Y",Date=+$h,Time=$p($h,",",2)
		&sql(update dhc_indispret set dsr_ackflag=:Chk,dsr_AckDate=:Date,dsr_acktime=:Time,dsr_ackuser_dr=:gUserId
			where %ID=:RowId)
     	i SQLCODE'=0 d
		.d ..sssUnLock(..%GetParameter("AppName")_RowId)
		.d RtnObj.Err(-6,"",SQLCODE_"更新退回单失败!")
		q:RtnObj.success'=0
		//库存\台账处理
		s RtnObj=..HandleStkQty(RowId,gUserId)
		i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_RowId)
		q:RtnObj.success'=0
		d ..sssUnLock(..%GetParameter("AppName")_RowId)
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Description:判断退回单是否允许审核
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
ClassMethod AllowAudit(dsr As %String) As RtnObj
{
	n (dsr)
	s RtnObj=##class(RtnObj).%New()
	s CompFlag=$p(^DHCINDSR(dsr),"^",5)
	i CompFlag'="Y" d RtnObj.Err(-1,"","退回单未完成!","",0)
	q:RtnObj.success'=0 RtnObj
	s AckFlag=$p(^DHCINDSR(dsr),"^",6)
	i AckFlag="Y" d RtnObj.Err(-2,"","退回单已审核!","",0)
	q RtnObj
}

/// Description:检查退回单数据
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indispret
/// Input:   	物资发放单RowId
/// Return:		错误信息
ClassMethod ChkDispRetItmData(dsr As %String) As %String
{
	n (dsr)
	s errMsg=""
	s ch=0
	f  s ch=$O(^DHCINDSR(dsr,"DSI",ch)) q:(ch="")!(errMsg'="")  d
	.s inclb=$P(^DHCINDSR(dsr,"DSI",ch),"^",3)
	.s sp=$P(^DHCINDSR(dsr,"DSI",ch),"^",10)
	.s uom=$P(^DHCINDSR(dsr,"DSI",ch),"^",4)
	.s rp=$P(^DHCINDSR(dsr,"DSI",ch),"^",2)
	.s inci=+inclb
	.s code=$p(^INCI(inci,1),"^",1)
	.s desc=$p(^INCI(inci,1),"^",2)
	.s buom=$p(^INCI(inci,1),"^",10)
	.i uom'=buom d
	..&sql( select %ID into :fac from  ct_confac where ctcf_frUOm_dr=:uom and ctcf_touom_dr=:buom)
	..i SQLCODE s errMsg="库存项：<"_desc_"> 单位换算错误!"
	.q:errMsg'=""
	.s loc=$$LOC^ST01(inclb)
	.s hospid=$p(^CTLOC(loc),"^",22)
	.s currentSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,hospid)
	q errMsg
}

/// Description:处理库存及台账信息
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
ClassMethod HandleStkQty(dsr As %String, user As %String) As RtnObj
{
	n (dsr,user)
	s RtnObj=##class(RtnObj).%New()
	s TrNo=""
	&sql(select dsr_no into :TrNo from dhc_indispret where %ID=:dsr)
	i SQLCODE'=0 d RtnObj.Err(-1,"",SQLCODE_"查询退回单失败!")
	q:RtnObj.success'=0 RtnObj
	
	s ch=0
	f  s ch=$o(^DHCINDSR(dsr,"I",ch)) q:(ch="")!(RtnObj.success'=0)  d
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s dsritm=dsr_"||"_ch
	.s obj=##class(User.DHCInDispRetItm).%OpenId(dsritm)
	.d obj.%Reload()
	.s inclb=obj.DSRIINCLBDRGetObjectId()
	.s qty=obj.DSRIQty
	.s uom=obj.DSRICTUOMDRGetObjectId()
	.s rp=obj.DSRIRp
	.s rpAmt=obj.DSRIRpAmt
	.s sp=obj.DSRISp
	.s spAmt=obj.DSRISpAmt
	.s trType="L"
	.s Pointer=dsritm
	.s trans=trType
	.s trans=trans_"^"_TrNo
	.s trans=trans_"^"_inclb
	.s trans=trans_"^"_qty 
	.s trans=trans_"^"_uom
	.s trans=trans_"^"_sp
	.s trans=trans_"^"_user
	.s trans=trans_"^"_Pointer
	.s trans=trans_"^"_rp
	.s trans=trans_"^"_rpAmt
	.s trans=trans_"^"_spAmt
	.s inci=+inclb
	.s buom=$p(^INCI(inci,1),"^",10)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s bqty=qty*fac   //换算成基本单位的数量
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,bqty)   //处理库存
	.i ret'=0 d RtnObj.Err(-2,"","处理库存失败!")
	.q:RtnObj.success'=0
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(trans)  //插入台账数据
	.i RtnObj.success'=0 d RtnObj.Err(-3,"","插入台账失败!")
	.q:RtnObj.success'=0
	q RtnObj
}

/// Description:保存退回单
/// Creator:	tsr
/// CreatDate:	2019-04-24
ClassMethod jsSave(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()

	ts
	s RtnObj=..Update(Main)
	i RtnObj.success'=0 tro  q RtnObj
	s DsrId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINDispRetItm).Save(DsrId,Detail)
	i RtnObj.success'=0 tro  q RtnObj
	
	
	s UserId=$p(^DHCINDSR(DsrId),"^",4)
	s CompFlag=$p(^DHCINDSR(DsrId),"^",5)
	s LocId=$p(^DHCINDSR(DsrId),"^",13)
	
	s AppName=..%GetParameter("AppName")
	s Param="^"_LocId_"^"_UserId_"^"
	s AutoCompAfterSave=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSave",Param)
	;保存后自动完成
	i (CompFlag'="Y")&&(AutoCompAfterSave="Y") d
	.s ParamsObj={}.%Set("gUserId",UserId).%Set("gLocId",LocId)
	.s Params=ParamsObj.%ToJSON()
	.s RtnObj=..SetComp(DsrId,Params)
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=DsrId
	q RtnObj
}

/// Description:插入更新退回单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDispRet
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","Update入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s DsrId=PJObj.%Get("RowId")
	s CompFlag=$s(DsrId'="":$p(^DHCINDSR(DsrId),"^",5),1:"")
	i CompFlag="Y" d RtnObj.Err(-2,"","单据已完成!","",0)
	q:RtnObj.success'=0 RtnObj

	s LocId=PJObj.%Get("LocId")		//制单科室RowId
	s ToLocId=PJObj.%Get("ToLocId")		//退回科室RowId
	s UserId=PJObj.%Get("User")			//制单人RowId
	s:UserId="" UserId=PJObj.%Get("gUserId")
	s DsrScg=PJObj.%Get("Scg")				//类组RowId
	s Remarks=PJObj.%Get("Remarks")
	s MemoDelim=..sssMemoDelim()
	s Remarks=$lfs(Remarks,MemoDelim)
	s Date=+$h
	s Time=$p($h,",",2)
	s StkType=..sssCode()
	s AppName=..%GetParameter("AppName")

	i DsrId="" d
	.s DsrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,DsrScg,LocId)
	.i (DsrNo<0)||(DsrNo="") d RtnObj.Err(-3,"","单号生成失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCInDispRet).%New()
	.s obj.DSRNo=DsrNo
	.s obj.DSRDate=Date
	.s obj.DSRTime=Time
	.d obj.DSRCTLOCDRSetObjectId(LocId)
	.d obj.DSRRetLOCDRSetObjectId(ToLocId)
	e  d
	.i ..sssLock(AppName_DsrId)'=0 d RtnObj.Err(-99,"",DsrId_"锁定失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCInDispRet).%OpenId(DsrId)
	.d obj.%Reload()
	q:RtnObj.success'=0 RtnObj
	
	s obj.DSRStkType=StkType
	d obj.DSRSCGDRSetObjectId(DsrScg)
	d obj.DSRSSUSRDRSetObjectId(UserId) 
	s obj.DSRRemark=Remarks
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.d ..sssUnLock(AppName_DsrId)
	.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
	.d RtnObj.Err(-5,"","退回单保存失败:"_sc)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(AppName_DsrId)
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Description:删除退回单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispret
/// Input:		退回单Id
ClassMethod Delete(Dsr As %String) As %String
{
	n (Dsr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsr)'=0 d RtnObj.Err(-99,"",Dsr_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=..AllowDel(Dsr)
	i RtnObj.success'=0 d ..sssUnLock(Dsr)
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("L",Dsr)
 	i RtnObj.success'=0 d
 	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-2,Dsr,"删除高值跟踪信息失败!")
	.tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ##class(web.DHCSTMHUI.DHCINDispRetItm).RestoreAllRetQty(Dsr)'=0 d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-2,Dsr,"恢复发放单退回数量失败!")
	.tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(delete from dhc_indispret where %ID=:Dsr)	
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-1,Dsr,SQLCODE_"删除失败!") 
	.tro
	tc
	d ..sssUnLock(AppName_Dsr)
	q RtnObj.Json()
}

/// Description:判断是否允许删除退回单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispret
/// Input:		退回单Id
ClassMethod AllowDel(Dsr As %String) As RtnObj
{
	n (Dsr)
	s RtnObj=##class(RtnObj).%New()
	s CompFlag=$p(^DHCINDSR(Dsr),"^",5)
	i CompFlag="Y" d RtnObj.Err(-11,Dsr,"已完成,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s AckFlag=$p(^DHCINDSR(Dsr),"^",6)
	i AckFlag="Y" d RtnObj.Err(-12,Dsr,"已审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:查询退回单主表记录
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispret
/// Input:		退回单Id
ClassMethod Select(Dsr As %String) As %String
{
	n (Dsr)
	q:Dsr="" "{}"
	&sql(select DSR_RowId, DSR_No, DSR_Date, DSR_Time, DSR_SSUSR_DR,
			DSR_Completed, DSR_AckFlag, DSR_AckDate, DSR_AckTime, DSR_AckUser_Dr,
			DSR_SCG_DR, DSR_StkType, DSR_Remark, DSR_Status, DSR_CTLOC_DR,
			DSR_RetLOC_DR, DSR_CTLOC_DR->CTLoc_Desc, DSR_RetLOC_DR->CTLoc_Desc, DSR_SCG_DR->SCG_Desc
		INTO RowId, DsrNo, CreateDate, CreateTime, UserId,
			CompFlag, AckFlag, AckDate, AckTime, AckUser,
			Scg, StkType, Remark, Status, LocId,
			RetLocId, LocDesc, RetLocDesc, ScgDesc
		FROM SQLUser.DHC_InDispRet WHERE DSR_RowId=:Dsr)
	q:SQLCODE'=0 "{}"
	s Remarks=$lts(Remark,..sssMemoDelim())
	s CreateDate=..DL2H(CreateDate)
	s CreateTime=..TL2H(CreateTime)
	s AckDate=..DL2H(AckDate)
	s AckTime=..TL2H(AckTime)
	s:UserId'="" User=$p(^SSU("SSUSR",UserId),"^",2)
	s:AckUser'="" AckUser=$p(^SSU("SSUSR",AckUser),"^",2)
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	s RetLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RetLocDesc)
	s LocId=..sssComboStr(RetLocId,LocDesc)
	s RetLoc=..sssComboStr(RetLocId,RetLocDesc)
	s DataStr=RowId_"^"_DsrNo_"^"_CreateDate_"^"_CreateTime_"^"_User
		_"^"_CompFlag_"^"_AckFlag_"^"_AckDate_"^"_AckTime_"^"_AckUser
		_"^"_Scg_"^"_ScgDesc_"^"_Remarks_"^"_LocId
		
	s TitleStr="RowId^DsrNo^CreateDate^CreateTime^User"
		_"^CompFlag^AckFlag^AckDate^AckTime^AckUser"
		_"^Scg^ScgDesc^Remarks^LocId^RetLoc"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Description:完成退回单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispret
/// Input:		
/// Return:		
ClassMethod jsSetComp(Dsr As %String, Params As %String) As %String
{
	n (Dsr,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComp(Dsr,Params)
	q RtnObj.Json()
}

ClassMethod SetComp(Dsr As %String, Params As %String) As RtnObj
{
	n (Dsr,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	s LocId=PJObj.%Get("gLocId")
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsr)'=0 q RtnObj.Err(-99,"",Dsr_"锁定失败!")
	
	s CompFlag=$p(^DHCINDSR(Dsr),"^",5)
	s AckFlag=$p(^DHCINDSR(Dsr),"^",6)
	i CompFlag="Y" d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-1,Dsr,"该退回单已完成!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i AckFlag="Y" d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-2,Dsr,"该退回单已审核!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Comp="Y"
	ts
	&sql(update dhc_indispret set dsr_completed=:Comp where %id=:Dsr)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-3,Dsr,"完成失败!")
	i RtnObj.success'=0 tro  q RtnObj
	
	s Param=GroupId_"^"_LocId_"^"_User_"^"_HospId
	s AutoAuditAfterComp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAuditAfterComp",Param)
	s userId=$p(^DHCINDSR(Dsr),"^",4)
	s title="gUserId"
	s userInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(userId,title)
	s title1="RowId"
	s DsrInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Dsr,title1)
	s DsrInfo="["_DsrInfo_"]"
	i AutoAuditAfterComp="Y"  d
	.s RtnObj=..Audit(userInfo,DsrInfo)
	i RtnObj.success'=0 d ..sssUnLock(AppName_Dsr) tro  q RtnObj
	tc
	
	d ..sssUnLock(AppName_Dsr)
	s RtnObj.rowid=Dsr
	q RtnObj
}

/// Description:取消完成退回单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispret
/// Input:		
/// Return:		
ClassMethod CancelComp(Dsr As %String) As %String
{
	n (Dsr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsr)'=0 d RtnObj.Err(-99,"",Dsr_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s CompFlag=$p(^DHCINDSR(Dsr),"^",5)
	s AckFlag=$p(^DHCINDSR(Dsr),"^",6)
	i CompFlag'="Y" d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-1,Dsr,"该退回单未完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i AckFlag="Y" d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-2,Dsr,"该退回单已审核!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Comp="N"
	&sql(update dhc_indispret set dsr_completed=:Comp where %id=:Dsr)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsr)
	.d RtnObj.Err(-3,Dsr,"取消完成失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ..sssUnLock(AppName_Dsr)
	s RtnObj.rowid=Dsr
	q RtnObj.Json()
}

/// Description:依据发放单退回
/// Creator:	wxj
/// CreatDate:	2022-07-18
/// W ##class(web.DHCSTMHUI.DHCINDispRet).jsSaveByDisp(^tempxj3)
ClassMethod jsSaveByDisp(Params As %Text) As %Library.String
{
	n (Params)
	;s ^tempxj3=Params
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveByDisp(Params)
	q RtnObj.Json()
}

ClassMethod SaveByDisp(Params As %Text) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Dsp=PJObj.%Get("Dsp")
	s DspiStr=PJObj.%Get("DspiStr")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	i Dsp="" s Sc=RtnObj.Err(-2,"","请选择要退回的发放单!","",0)
	q:RtnObj.success'=0 RtnObj
	s Status=$p(^DHCINDS(Dsp),"^",17)
	i Status'="Y" d RtnObj.Err(-3,"","发放单未审核!","",0)
	q:RtnObj.success<0 RtnObj
	s FrLocId=$p(^DHCINDS(Dsp),"^",9) ;发放单发放科室
	s ToLocId=$p(^DHCINDS(Dsp),"^",22) ;发放单接收科室
	s Scg=$p(^DHCINDS(Dsp),"^",15)
	s Main="{""LocId"":"""_FrLocId_""",""Scg"":"""_Scg_""",""gHospId"":"""_gHospId_""",""gGroupId"":"""_gGroupId_""",""ToLocId"":"""_ToLocId_""",""gUserId"":"""_gUserId_"""}"
	s Detail=""
	s Ch=""
	f  s Ch=$o(^DHCINDS(Dsp,"DSI",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	.s Dspi=Dsp_"||"_Ch
	.q:(DspiStr'="")&&(("^"_DspiStr_"^")'[("^"_Dspi_"^"))
	.s DispQty=$p(^DHCINDS(Dsp,"DSI",Ch),"^",1)
	.s Rp=$p(^DHCINDS(Dsp,"DSI",Ch),"^",2)
	.s Inclb=$p(^DHCINDS(Dsp,"DSI",Ch),"^",3)
	.s UomId=$p(^DHCINDS(Dsp,"DSI",Ch),"^",4)
	.s SpAmt=$p(^DHCINDS(Dsp,"DSI",Ch),"^",7)
	.s Sp=$p(^DHCINDS(Dsp,"DSI",Ch),"^",10)
	.s RpAmt=$p(^DHCINDS(Dsp,"DSI",Ch),"^",13)
	.s DisRetQty=+$p(^DHCINDS(Dsp,"DSI",Ch),"^",14)
	.s InciCode=$p(^INCI(+Inclb,1),"^",1)
	.s Qty=DispQty-DisRetQty
	.i Qty<=0  d RtnObj.Err(-4,"",InciCode_"可退数量为0或小于0!")
	.q:RtnObj.success<0
	.s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("C",Dspi)
	.s JsonStr="{""RowId"":"""",""Inclb"":"""_Inclb_""",""Qty"":"""_Qty_""",""UomId"":"""_UomId_""",""Rp"":"""_Rp_""",""RpAmt"":"""_RpAmt_""",""Sp"":"""_Sp_""",""SpAmt"":"""_SpAmt_""",""Indsi"":"""_Dspi_""",""HVBarCode"":"""_HVBarCode_"""}"
	.i Detail="" d
	..s Detail=JsonStr
	.e  d
	..s Detail=Detail_","_JsonStr
	q:RtnObj.success<0 RtnObj
	i Detail="" d RtnObj.Err(-5,"","单据明细为空!")
	q:RtnObj.success<0 RtnObj
	s Detail="["_Detail_"]"
	s RtnObj=..Save(Main,Detail)
	q RtnObj
}

}
