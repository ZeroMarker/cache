Import sqluser

Class web.DHCSTMHUI.DHCINDisp Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINDISPM";

/// Description:查询发放单列表
/// Creator:	tsr
/// CreatDate:	2019-03-27
/// Table:		dhc_indisp
Query DHCINDisp(Params As %String) As Query(ROWSPEC = "RowId,IndsNo,LocDesc,CreateDate,CreateTime,CreateUser,RecUser,GrpDesc,AuditUser,AuditDate,AuditTime,ScgDesc,Comp,State,ChkFlag,DispMode,ReqNo,Remark,ReqLoc") [ SqlProc ]
{
}

ClassMethod DHCINDispExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s PHVFlag=PJObj.%Get("HVFlag")
	s TempFlag=PJObj.%Get("TempFlag")	;模板查询标志
	q:LocId="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s:AuditFlag="" AuditFlag="N"
	//s:CompFlag="" CompFlag="N"
	s Type=..sssCode()

	s SqlStr="select %ID RowId,"
	s SqlStr=SqlStr_"inds_NO IndsNo,"
	s SqlStr=SqlStr_"inds_ctloc_dr->ctloc_desc LocDesc,"
	s SqlStr=SqlStr_"inds_date CreateDate,"
	s SqlStr=SqlStr_"inds_time CreateTime,"
	s SqlStr=SqlStr_"inds_ssusr_dr->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"INDS_AckDate AuditDate,"
	s SqlStr=SqlStr_"inds_acktime AuditTime,"
	s SqlStr=SqlStr_"INDS_SSUSR_Ack_DR->ssusr_name AuditUser,"
	s SqlStr=SqlStr_"inds_scg_dr->scg_desc ScgDesc,"
	s SqlStr=SqlStr_"nvl(inds_completed,'N') Comp,"
	s SqlStr=SqlStr_"inds_stat State,"
	s SqlStr=SqlStr_"nvl(inds_ackflag,'N') ChkFlag,"
	s SqlStr=SqlStr_"inds_dispmode DispMode,"
	s SqlStr=SqlStr_"inds_dispuser_dr->ssusr_name RecUser,"
	s SqlStr=SqlStr_"inds_dispusergrp_dr->lug_groupDesc GrpDesc,"
	s SqlStr=SqlStr_"inds_rq_dr->dsrq_no ReqNo,"
	s SqlStr=SqlStr_"inds_remarks Remark,"
	s SqlStr=SqlStr_"INDS_TOLOC_DR->CTLoc_Desc ReqLoc,"
	s SqlStr=SqlStr_"INDS_Template"
	s SqlStr=SqlStr_" From dhc_indisp"
	s SqlStr=SqlStr_" Where inds_ctloc_dr="_LocId
	s SqlStr=SqlStr_" And inds_stktype='"_Type_"'"
	s SqlStr=SqlStr_" And inds_date between "_StartDate_" And "_EndDate

	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s IndsNo=xrs.Data("IndsNo")
		s LocDesc=xrs.Data("LocDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s RecUser=xrs.Data("RecUser")
		s GrpDesc=xrs.Data("GrpDesc")
		s AuditUser=xrs.Data("AuditUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s ScgDesc=xrs.Data("ScgDesc")
		s Comp=xrs.Data("Comp")
		s State=xrs.Data("State")
		s ChkFlag=xrs.Data("ChkFlag")
		s DispMode=xrs.Data("DispMode")
		s ReqNo=xrs.Data("ReqNo")
		s Remark=xrs.Data("Remark")
		s ReqLoc=xrs.Data("ReqLoc")
		s Template=xrs.Data("INDS_Template")
		continue:(TempFlag="Y")&&(TempFlag'=Template)
		CONTINUE:(TempFlag'="Y")&&(AuditFlag'=ChkFlag)
		CONTINUE:(TempFlag'="Y")&&(CompFlag'="")&&(CompFlag'=Comp)
		s IsHVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(RowId,"C")
		CONTINUE:(PHVFlag'="")&&(PHVFlag'=IsHVFlag)
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s ReqLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLoc)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,IndsNo,LocDesc,CreateDate,CreateTime,CreateUser,RecUser,GrpDesc,AuditUser,AuditDate,AuditTime,ScgDesc,Comp,State,ChkFlag,DispMode,ReqNo,Remark,ReqLoc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod jsAudit(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(MainInfo,ListData)
	q RtnObj.Json()
}

/// Description:审核发放单
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
/// d ##class(web.DHCSTMHUI.DHCINDisp).Audit("",)
ClassMethod Audit(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s gUserId=PJObj.%Get("gUserId")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
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
		s QtyMsg=..CheckIndispQty(RowId)	//判断可用库存是否充足
		i QtyMsg'="" d
		.d ..sssUnLock(..%GetParameter("AppName")_RowId)
		.d RtnObj.Err(-4,"",QtyMsg)
		q:RtnObj.success'=0
		s ErrMsg=..ChkDispItmData(RowId)	//核查数据
		i ErrMsg'="" d
		.d ..sssUnLock(..%GetParameter("AppName")_RowId)
		.d RtnObj.Err(-5,"",ErrMsg)
		q:RtnObj.success'=0
		s Status="20",Chk="Y",Date=+$h,Time=$p($h,",",2)
		&sql(update dhc_indisp set inds_ackflag=:Chk,INDS_AckDate=:Date,inds_acktime=:Time,
     		INDS_SSUSR_Ack_DR=:gUserId,inds_stat=:Status where %ID=:RowId)
     	i SQLCODE'=0 d
		.d ..sssUnLock(..%GetParameter("AppName")_RowId)
		.d RtnObj.Err(-6,"",SQLCODE_"更新发放单失败!")
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

/// Description:判断发放单是否允许审核
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
ClassMethod AllowAudit(Inds As %String) As RtnObj
{
	n (Inds)
	s RtnObj=##class(RtnObj).%New()
	s CompFlag=$p(^DHCINDS(Inds),"^",14)
	i CompFlag'="Y" d RtnObj.Err(-1,"","发放单未完成!","",0)
	q:RtnObj.success'=0 RtnObj
	s AckFlag=$p(^DHCINDS(Inds),"^",17)
	i AckFlag="Y" d RtnObj.Err(-2,"","发放单已审核!","",0)
	q RtnObj
}

/// Description:检查发放单明细是否充足
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
/// Input:   	物资发放单RowId
/// Return:		库存不足的物资名称组成的字符串
ClassMethod CheckIndispQty(Indisp As %String) As %String
{
	n (Indisp)
	q:Indisp="" ""
	s str=""
	s ch=0
	f  s ch=$o(^DHCINDS(Indisp,"DSI",ch)) q:ch=""  d
	.s inclb=$p(^(ch),"^",3)
	.s dsQty=$p(^(ch),"^",1)
	.s dsUom=$p(^(ch),"^",4)
	.s inci=+inclb,il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	.q:inci=""
	.s inciDesc=$p(^INCI(inci,1),"^",2)
	.s bUom=$p(^INCI(inci,1),"^",10)
	.s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(dsUom,bUom)
	.s qtyBuom=dsQty*uomFac
	.
	.s inclbQty=$p(^INCI(inci,"IL",il,"LB",lb),"^",2)
	.s inclbDrityQty=$p(^INCI(inci,"IL",il,"LB",lb),"^",3)
	.s inclbAvaQty=inclbQty-inclbDrityQty+qtyBuom
	.
	.i qtyBuom>inclbAvaQty d
	..i str="" s str=inciDesc
	..e  s str=str_","_inciDesc

	i str'="" s str=str_"可用库存不足"
	q str
}

/// Description:检查发放单数据
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
/// Input:   	物资发放单RowId
/// Return:		错误信息
ClassMethod ChkDispItmData(Indisp As %String) As %String
{
	n (Indisp)
	s errMsg=""
	s ch=0
	f  s ch=$O(^DHCINDS(Indisp,"DSI",ch)) q:(ch="")!(errMsg'="")  d
	.s inclb=$P(^DHCINDS(Indisp,"DSI",ch),"^",3)
	.s sp=$P(^DHCINDS(Indisp,"DSI",ch),"^",10)
	.s uom=$P(^DHCINDS(Indisp,"DSI",ch),"^",4)
	.s rp=$P(^DHCINDS(Indisp,"DSI",ch),"^",2)
	.s inci=+inclb
	.s code=$p(^INCI(inci,1),"^",1)
	.s desc=$p(^INCI(inci,1),"^",2)
	.s buom=$p(^INCI(inci,1),"^",10)
	.i uom'=buom d
	..&sql(select %ID into :fac from ct_confac where ctcf_frUOm_dr=:uom and ctcf_touom_dr=:buom)
	..i SQLCODE s errMsg="库存项：<"_desc_"> 单位换算错误!"
	.q:errMsg'=""
	.
	.s loc=$$LOC^ST01(inclb)
	.s hospid=$p(^CTLOC(loc),"^",22)
	.s currentSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,hospid)
	.i sp'=currentSp s $P(^DHCINDS(Indisp,"DSI",ch),"^",10)=currentSp
	q errMsg
}

/// Description:处理库存及台账信息
/// Creator:	tsr
/// CreatDate:	2019-03-29
/// Table:		dhc_indisp
ClassMethod HandleStkQty(Inds As %String, user As %String) As RtnObj
{
	n (Inds,user)
	s RtnObj=##class(RtnObj).%New()
	s TrNo=""
	&sql(select inds_no into :TrNo from dhc_indisp where %ID=:Inds)
	i SQLCODE'=0 d RtnObj.Err(-1,"",SQLCODE_"查询发放单失败!")
	q:RtnObj.success'=0 RtnObj
	
	s ch=0
	f  s ch=$o(^DHCINDS(Inds,"DSI",ch)) q:(ch="")!(RtnObj.success'=0)  d
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s indsitm=Inds_"||"_ch
	.s obj=##class(User.DHCInDispItm).%OpenId(indsitm)
	.d obj.%Reload()
	.s inclb=obj.INDSIINCLBDRGetObjectId()
	.s qty=obj.INDSIQty
	.s uom=obj.INDSICTUOMDRGetObjectId()
	.s rp=obj.INDSIUCost
	.s rpAmt=obj.INDSIRpAmt
	.s sp=obj.INDSISalePrice
	.s spAmt=obj.INDSIAmountSoldFor
	.s trType="C"  //业务类型:科室内部发放
	.s Pointer=indsitm
	.s qty=-qty
	.s rpAmt=-rpAmt
	.s spAmt=-spAmt
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
	.s ret=..HandleItmDirtyQty(indsitm,0)	//处理占用
	.i ret<0 d RtnObj.Err(-4,"","处理库存占用失败!")
	.q:RtnObj.success'=0
	q RtnObj
}

/// Description:发放单明细库存占用处理
/// Creator:    wangjiabin
/// CreateDate: 2014-10-23
/// Table:
/// Input:		发放单子表id, 处理符号(1-加, 0-减)
/// Return：	0:成功, <0:失败
ClassMethod HandleItmDirtyQty(indsi As %String, sign As %String) As %String
{
	n (indsi,sign)
	s obj=##class(User.DHCInDispItm).%OpenId(indsi)
	d obj.%Reload()
	s inclb=obj.INDSIINCLBDR.%Id()
	s qty=obj.INDSIQty
	s uom=obj.INDSICTUOMDR.%Id()
	s buom=$p(^INCI(+inclb,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qty=qty*fac			;基本单位对应的数量
	i sign="0" s qty=-qty	;回退
	s err=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDirtyQty(inclb,qty)
	q err
}

/// Description:查询发放单主表信息
/// Creator:	tsr
/// CreatDate:	2019-04-27
/// Table:		DHC_INDisp
ClassMethod Select(Inds) As %String
{
	n (Inds)
	q:Inds="" "{}"

	&sql(SELECT INDS_Rowid, INDS_No, INDS_Date, INDS_Time, INDS_SSUSR_DR, 
			INDS_Remarks, INDS_CTLOC_DR, INDS_AckDate, INDS_AckTime,INDS_SSUSR_Ack_DR,  
			INDS_Stat, INDS_Completed, INDS_SCG_DR, INDS_StkType, INDS_AckFlag, 
			INDS_DispMode, INDS_DispUser_DR, INDS_DispUserGrp_DR, INDS_RQ_DR, INDS_TOLOC_DR,
			INDS_CTLOC_DR->CTLoc_Desc, INDS_TOLOC_DR->CTLoc_Desc, INDS_SCG_DR->SCG_Desc, INDS_DispUserGrp_DR->lug_groupdesc,INDS_Template
		INTO :RowId, :DispNo, :CreateDate, :CreateTime, :UserId,
			:Remarks, :LocId, :AckDate, :AckTime, :AckUserId,
			:Stat, :Completed, :Scg, :StkType, :AckFlag,
			:DispMode, :DispUserId, :DispUserGrpId, :RQ, :ReqLocId,
			:LocDesc, :ReqLocDesc, :ScgDesc, :UserGrp,:Template
		FROM SQLUser.DHC_InDisp WHERE INDS_Rowid = :Inds) 
	q:SQLCODE "{}"
	s CreateDate=..DL2H(CreateDate)
	s CreateTime=..TL2H(CreateTime)
	s AckDate=..DL2H(AckDate)
	s AckTime=..TL2H(AckTime)
	s User=$s(UserId'="":$p(^SSU("SSUSR",UserId),"^",2),1:"")
	s AckUser=$s(AckUserId'="":$p(^SSU("SSUSR",AckUserId),"^",2),1:"")
	s DispUser=$s(DispUserId'="":$p(^SSU("SSUSR",DispUserId),"^",2),1:"")
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	s LocId=..sssComboStr(LocId,LocDesc)
	s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	s ReqLoc=..sssComboStr(ReqLocId,ReqLocDesc)
	s ReqNo=$s(RQ'="":$p(^DHCINDSREQ(RQ),"^",1),1:"")
	s UserList=..sssComboStr(DispUserId,DispUser)
	s GrpList=..sssComboStr(DispUserGrpId,UserGrp)
	
	s DataStr=RowId_"^"_DispNo_"^"_CreateDate_"^"_CreateTime_"^"_User
		_"^"_Completed_"^"_Remarks_"^"_LocId_"^"_AckDate_"^"_AckTime
		_"^"_AckUser_"^"_Scg_"^"_ScgDesc_"^"_AckFlag_"^"_DispMode
		_"^"_UserList_"^"_GrpList_"^"_ReqLoc_"^"_ReqNo_"^"_Template
		
	s TitleStr="RowId^DispNo^CreateDate^CreateTime^User"
		_"^CompFlag^Remarks^LocId^AckDate^AckTime"
		_"^AckUser^Scg^ScgDesc^AckFlag^ReqMode"
		_"^UserList^GrpList^ReqLoc^ReqNo^Template"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Description:保存发放单
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
	s Inds=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINDispItm).Save(Inds,Detail)
	i RtnObj.success'=0 tro  q RtnObj
	s ret=..HandleDirtyQty(Inds,1)		//处理库存占用
	i ret'=0 tro  q RtnObj.Err(-1,"","库存占用处理失败!")
	
	s UserId=$p(^DHCINDS(Inds),"^",4)
	s LocId=$p(^DHCINDS(Inds),"^",9)
	s CompFlag=$p(^DHCINDS(Inds),"^",14)
	s AppName=..%GetParameter("AppName")
	s Param="^"_LocId_"^"_UserId_"^"
	s AutoCompAfterSave=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSave",Param)
	;保存后自动完成
	i (CompFlag'="Y")&&(AutoCompAfterSave="Y") d
	.s ParamsObj={}.%Set("gUserId",UserId).%Set("gLocId",LocId)
	.s Params=ParamsObj.%ToJSON()
	.s RtnObj=..SetComp(Inds,Params)
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=Inds
	q RtnObj
}

/// Description:插入更新发放单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDisp
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","Update入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s Inds=PJObj.%Get("RowId")
	s CompFlag=$s(Inds'="":$p(^DHCINDS(Inds),"^",14),1:"")
	i CompFlag="Y" d RtnObj.Err(-2,"","单据已完成!","",0)
	q:RtnObj.success'=0 RtnObj

	s DspLoc=PJObj.%Get("LocId")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s UserId=PJObj.%Get("gUserId")
	s Scg=PJObj.%Get("Scg")				//类组RowId
	s ReqMode=PJObj.%Get("ReqMode")
	s UserList=PJObj.%Get("UserList")
	s GrpList=PJObj.%Get("GrpList")
	s Remarks=PJObj.%Get("Remarks")
	s DispReq=PJObj.%Get("DispReq")
	s Template=PJObj.%Get("Template")	//模板标志
	s Date=+$h
	s Time=$p($h,",",2)
	s AppName=..%GetParameter("AppName")
	s StkType=..sssCode()

	i Inds'="" d
	.s ret=..HandleDirtyQty(Inds,0)	//不是新建,先释放占用
	.i ret'=0 d RtnObj.Err(-3,Inds,"释放占用失败!")
	q:RtnObj.success'=0 RtnObj

	i Inds="" d
	.s IndsNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,Scg,DspLoc)
	.i (IndsNo<0)||(IndsNo="") d RtnObj.Err(-4,"","单号生成失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCInDisp).%New()
	.s obj.INDSNo=IndsNo
	.s obj.INDSDate=Date
	.s obj.INDSTime=Time
	.d obj.INDSCTLOCDRSetObjectId(DspLoc)
	e  d
	.i ..sssLock(AppName_Inds)'=0 d RtnObj.Err(-99,"",Inds_"锁定失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCInDisp).%OpenId(Inds)
	.d obj.%Reload()
	q:RtnObj.success'=0 RtnObj

	s obj.INDSStkType=StkType
	d obj.INDSSCGDRSetObjectId(Scg)
	d obj.INDSSSUSRDRSetObjectId(UserId) 
	s obj.INDSRemarks=Remarks
	d obj.INDSRQDRSetObjectId(DispReq)
	d obj.INDSDispUserGrpDRSetObjectId(GrpList)
	d obj.INDSDispUserDRSetObjectId(UserList)
	s obj.INDSDispMode=ReqMode
	d obj.INDSTOLOCDRSetObjectId(ReqLoc)
	s obj.INDSTemplate=Template
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.d ..sssUnLock(AppName_Inds)
	.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
	.d RtnObj.Err(-5,"","发放单保存失败:"_sc)
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock(AppName_Inds)
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Description:删除发放单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indisp
/// Input:		发放单Id
ClassMethod Delete(Inds As %String) As %String
{
	n (Inds)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..AllowDel(Inds)
	q:RtnObj.success'=0 RtnObj.Json()

	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Inds)'=0 d RtnObj.Err(-99,"",Inds_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Dsrq=$p(^DHCINDS(Inds),"^",21)
	
	ts
	//清库存占用
	s ret=..HandleDirtyQty(Inds,0)
	i ret<0 d
	.d RtnObj.Err(-1,Inds,"清库存占用失败!")
	.d ..sssUnLock(AppName_Inds)
	.tro
	q:RtnObj.success'=0 RtnObj.Json()

	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("C",Inds)
	i RtnObj.success'=0 d
	.d RtnObj.Err(-4,Inds,"删除高值跟踪信息失败!")
	.d ..sssUnLock(AppName_Inds)
	.tro
	q:RtnObj.success'=0 RtnObj.Json()
 
	&sql(delete from dhc_indisp where %ID=:Inds)
	i SQLCODE'=0 d
	.d RtnObj.Err(-2,Inds,SQLCODE_"删除失败!")
	.d ..sssUnLock(AppName_Inds)
	.tro
	q:RtnObj.success'=0 RtnObj.Json()

	i Dsrq'="" d
	.s ret=##class(web.DHCSTMHUI.DHCINDispReq).ResetDsrqStatus(Dsrq)
	.i ret'=0 d
	..d RtnObj.Err(-3,Inds,"修改发放单状态失败!")
	..d ..sssUnLock(AppName_Inds)
	..tro
	q:RtnObj.success'=0 RtnObj.Json()

	tc
	d ..sssUnLock(AppName_Inds)
	q RtnObj.Json()
}

/// Description:判断是否允许删除发放单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indisp
/// Input:		发放单Id
ClassMethod AllowDel(Inds As %String) As RtnObj
{
	n (Inds)
	s RtnObj=##class(RtnObj).%New()
	s CompFlag=$p(^DHCINDS(Inds),"^",14)
	i CompFlag="Y" d RtnObj.Err(-11,Inds,"已完成,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	s AckFlag=$p(^DHCINDS(Inds),"^",17)
	i AckFlag="Y" d RtnObj.Err(-12,Inds,"已审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Description:发放单库存占用处理
/// Creator:    wangjiabin
/// CreateDate: 2014-10-23
/// Table:		dhc_indisp
/// Input:		发放单id, 处理符号(1-加, 0-减)
/// Return：	0:成功, <0:失败
ClassMethod HandleDirtyQty(inds As %String, sign As %String) As %String
{
	n (inds,sign)
	s err=0
	s ch=0
	f  s ch=$o(^DHCINDS(inds,"DSI",ch)) q:(ch="")!(err<0)  d
	.s indsi=inds_"||"_ch
	.s err=..HandleItmDirtyQty(indsi,sign)
	q err
}

/// Description:完成发放单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indisp
/// Input:		发放Id
/// w ##class(web.DHCSTMHUI.DHCINDisp).SetComp("26","[{""RowId"":""26||1"",""Inclb"":""4507||1||5"",""IncId"":""4507"",""InciCode"":""DZ01270"",""InciDesc"":""dhq24采血器(生化)"",""Spec"":"""",""Manf"":"""",""BatchNo"":""2021070670"",""ExpDate"":"""",""Qty"":""1"",""UomId"":""4"",""UomDesc"":""支"",""Rp"":""0"",""RpAmt"":""0"",""Sp"":""0"",""SpAmt"":""0"",""InclbQty"":""13"",""Remark"":"""",""RQI"":"""",""AvaQty"":""12"",""InclbDirtyQty"":""1"",""DirtyQty"":""1""}]")
/// w ##class(web.DHCSTMHUI.DHCINDisp).SetComp("28","{""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod jsSetComp(Inds As %String, Params As %String) As %String
{
	n (Inds,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComp(Inds,Params)
	q RtnObj.Json()
}

ClassMethod SetComp(Inds As %String, Params As %String) As RtnObj
{
	n (Inds,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	s LocId=PJObj.%Get("gLocId")
	
	s UserId=$p(^DHCINDS(Inds),"^",4)
	s CompFlag=$p(^DHCINDS(Inds),"^",14)
	i CompFlag="Y" q RtnObj.Err(-1,Inds,"该发放单已完成!","",0)

	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Inds)'=0 q RtnObj.Err(-99,"",Inds_"锁定失败!")

	s Comp="Y"
	ts
	&sql(update dhc_indisp set inds_completed=:Comp where %id=:Inds)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Inds)
	.d RtnObj.Err(-3,Inds,"完成失败!")
	i RtnObj.success'=0 tro  q RtnObj
	
	s Param=GroupId_"^"_LocId_"^"_User_"^"_HospId
	s AutoAckDispFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAckDispAfterCompleted",Param)
	;完成后自动审核
	i AutoAckDispFlag="Y" d
	.s title="gUserId"
	.s userInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(UserId,title)
	.s title1="RowId"
	.s IndsInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Inds,title1)
	.s IndsInfo="["_IndsInfo_"]"
	.s RtnObj=..Audit(userInfo,IndsInfo)
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	d ..sssUnLock(AppName_Inds)
	s RtnObj.rowid=Inds
	q RtnObj
}

/// Description:取消完成发放单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indisp
/// Input:		发放单Id
ClassMethod CancelComp(Inds As %String) As %String
{
	n (Inds)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()

	s CompFlag=$p(^DHCINDS(Inds),"^",14)
	i CompFlag'="Y" d RtnObj.Err(-1,Inds,"该发放单未完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s AckFlag=$p(^DHCINDS(Inds),"^",17)
	i AckFlag="Y" d RtnObj.Err(-2,Inds,"该发放单已审核!","",0)
	q:RtnObj.success'=0 RtnObj

	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Inds)'=0 d RtnObj.Err(-99,"",Inds_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Comp="N"
	&sql(update dhc_indisp set inds_completed=:Comp where %id=:Inds)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Inds)
	.d RtnObj.Err(-3,Inds,"取消完成失败!")
	q:RtnObj.success'=0 RtnObj.Json()
		
	d ..sssUnLock(AppName_Inds)
	s RtnObj.rowid=Inds
	q RtnObj.Json()
}

/// Description:根据科室请领单制发放单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDisp,DHC_InDispItm
/// Others:		##class(web.DHCSTMHUI.DHCINDisp).SaveDispByReq("{""RowId"":""4"",""DsrqNo"":""ZYXZ00120190523001"",""LocDesc"":""物资材料库"",""CreateDate"":""2019-05-23"",""CreateTime"":""11:21:49"",""CreateUser"":""dthealth"",""ReqUser"":""dthealth"",""GrpDesc"":"""",""ScgDesc"":"""",""Comp"":""Y"",""Status"":""O"",""ReqMode"":""1"",""Remark"":"""",""DispSchedule"":""0""}","[{""RowId"":""4||1""},{""RowId"":""4||2""}]","6423","326")
ClassMethod SaveDispByReq(Main As %String, Detail As %String, UserId As %String, DispLoc As %String) As %String
{
	n (Main,Detail,UserId,DispLoc)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Dsrq=PJObj.%Get("RowId")		//请求单Id
	i Dsrq="" d RtnObj.Err(-2,"","请选择请领单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i DispLoc="" d RtnObj.Err(-3,"","请选择发放科室!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s AppName=##class(web.DHCSTMHUI.DHCINDispReq).%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq)'=0 d RtnObj.Err(-99,"","请领单"_Dsrq_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	s DSRQNo=$p(^DHCINDSREQ(Dsrq),"^",1)
	i Status="X" d
	.d RtnObj.Err(-4,Dsrq,"请领单"_DSRQNo_"已作废!")
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()
	i Status="R" d
	.d RtnObj.Err(-4,Dsrq,"请领单"_DSRQNo_"已拒绝!")
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()
	s ReqMode=$p(^DHCINDSREQ(Dsrq),"^",6)
	s ReqGrp=$p(^DHCINDSREQ(Dsrq),"^",7)
	s ReqUser=$p(^DHCINDSREQ(Dsrq),"^",8)
	s ReqLoc=$p(^DHCINDSREQ(Dsrq),"^",2)
	s Scg=$p(^DHCINDSREQ(Dsrq),"^",10)
	s Main="{""LocId"":"""_DispLoc_""",""ReqLoc"":"""_ReqLoc_""",""gUserId"":"""_UserId_""",""Scg"":"""_Scg_""",""ReqMode"":"""_ReqMode_""",""DispReq"":"""_Dsrq_""",""UserList"":"""_ReqUser_""",""GrpList"":"""_ReqGrp_"""}"
	
	s Detail=""
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Dsrqi=Obj.%Get("RowId")		//请求单明细Id
		s DispQty=Obj.%Get("DispQty")	//发放数量
		s Ch=$p(Dsrqi,"||",2)
		s InciId=$p(^DHCINDSREQ(+Dsrqi,"I",Ch),"^",1)
		s UomId=$p(^DHCINDSREQ(+Dsrqi,"I",Ch),"^",3)
		s Remark=$p(^DHCINDSREQ(+Dsrqi,"I",Ch),"^",4)
		s MoveStatus=$p(^DHCINDSREQ(+Dsrqi,"I",Ch),"^",5)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		i MoveStatus="X" d RtnObj.Err(-5,Dsrqi,InciDesc_"请领已作废!")
		q:RtnObj.success'=0
		i MoveStatus="R" d RtnObj.Err(-6,Dsrqi,InciDesc_"请领已拒绝!")
		q:RtnObj.success'=0
		s HospId=..sssHospId(DispLoc)
		s InclbStr=..GetInclbString(InciId,DispLoc,DispQty,UomId)
		i InclbStr'=""
		{
			f j=1:1:$l(InclbStr,"!") q:RtnObj.success'=0  d
			.s str=$p(InclbStr,"!",j)
			.s Inclb=$P(str,"^",1)
			.s Qty=$P(str,"^",2)
			.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
			.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$H,UomId,HospId)
			.s JsonStr="{""RowId"":"""",""Inclb"":"""_Inclb_""",""Qty"":"""_Qty_""",""UomId"":"""_UomId_""",""Rp"":"""_Rp_""",""Sp"":"""_Sp_""",""RQI"":"""_Dsrqi_"""}"
			.i Detail="" d
			..s Detail=JsonStr
			.e  d
			..s Detail=Detail_","_JsonStr
			i Detail="" d RtnObj.Err(-7,"","单据明细为空!")
			q:RtnObj.success'=0
		}
		q:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj.Json()
	s Detail="["_Detail_"]"
	s RtnObj=..Save(Main,Detail)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Status="C"
	&sql(update dhc_indispreq set dsrq_status=:Status where dsrq_rowid=:Dsrq)
	i SQLCODE'=0 d RtnObj.Err(-8,"","修改请领单状态失败!")
	d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()	
	
	q RtnObj.Json()
}

/// Description:查找库存项目的可发放的批次
/// Creator:	zhwh
/// CreatDate:	2019-04-24
/// Table:		INC_ITMLCBT
ClassMethod GetInclbString(inci As %String, loc As %String, dsQty As %String, dsUom As %String) As %String
{
	n (inci,loc,dsQty,dsUom)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(dsUom,$p(^INCI(inci,1),"^",10))
	s dsQty=dsQty*fac  //转换成基本单位

	s ilch=$o(^INCI("IL_LOC",loc,inci,""))	
	q:ilch="" ""
	s incil=inci_"||"_ilch
	l +^DHCINCIL(incil):20  e  q ""
	//取出库存>0的批次
	&sql(DECLARE CurrExp CURSOR FOR
	SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
	WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
	&sql(open CurrExp)
	s num=0
	f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d                                                                            
	.i tqty>0 d
	..s num=num+1
	..s CLB(num)=tclb
	..s Eqty(num)=tqty
	&sql(close CurrExp)
	s cnum=num
	i cnum=0  l -^DHCINCIL(incil) q ""  
	s k=0
	s clbqty=dsQty
	s sumdqty=0
	f i=1:1:cnum q:clbqty'>0   d
	. i Eqty(i)'<clbqty d
	. .s k=k+1
	. .s xINCLB(k)=CLB(i)
	. .s xQTY(k)=clbqty
	. .s clbqty=clbqty-xQTY(k)
	. .s sumdqty=sumdqty+xQTY(k)
	. e  d
	. .s k=k+1
	. .s xINCLB(k)=CLB(i)
	. .s xQTY(k)=Eqty(i)
	. .s clbqty=clbqty-xQTY(k)
	s resultStr=""
	f i=1:1:k d
	.i resultStr="" s resultStr=xINCLB(i)_"^"_(xQTY(i)/fac)
	.e  s resultStr=resultStr_"!"_xINCLB(i)_"^"_(xQTY(i)/fac)
	l -^DHCINCIL(incil)
	q resultStr
}

/// Description:根据转移单生成发放单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		
/// Input:
/// Others:		##class(web.DHCSTMHUI.DHCINDisp).SaveDispByInit("{""RowId"":""47"",""InitNo"":""ZYMZ001MTR20190428002"",""FrLocId"":""1"",""FrLocDesc"":""呼吸内科门诊"",""ToLocId"":""326"",""ToLocDesc"":""物资材料库"",""InitDate"":""2019-04-28"",""InitTime"":""11:49:37"",""UserName"":""dthealth"",""Comp"":""Y"",""Status"":""31"",""ReqId"":"""",""ReqNo"":"""",""RpAmt"":""20"",""SpAmt"":""20.7"",""MarginAmt"":""0.7"",""Remark"":"""",""StatusCode"":""已接收"",""ScgId"":"""",""ScgDesc"":"""",""InAckDate"":""2019-04-28"",""InAckTime"":""42637"",""InAckUser"":""dthealth"",""ConfirmFlag"":""N"",""OperateTypeDesc"":""正常出库"",""IsHVFlag"":""N"",""InitDateTime"":""2019-04-28 11:49:37"",""PrintFlag"":""N""}","[{""RowId"":""47||1"",""Inclb"":""2085||2||1"",""UomId"":""98"",""DispQty"":""1""}]","{""StartDate"":""2018-04-29"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""FrLoc"":"""",""UserList"":""6423"",""EndDate"":""2019-05-23"",""GrpList"":"""",""DispMode"":""1""}","326","326")		
ClassMethod SaveDispByInit(Main As %String, Detail As %String, Params As %String, DispLoc As %String, ReqLoc As %String) As %String
{
	n (Main,Detail,Params,DispLoc,ReqLoc)
	;s ^tsr("SaveDispByInit")=$lb(Main,Detail,Params,DispLoc,ReqLoc)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Init=PJObj.%Get("RowId")		//转移单Id
	i Init="" d RtnObj.Err(-2,"","请选择转移单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i DispLoc="" d RtnObj.Err(-3,"","请选择发放科室!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s UserId=PJObj.%Get("gUserId")
	s DispMode=PJObj.%Get("DispMode")
	s UserList=PJObj.%Get("UserList")
	s GrpList=PJObj.%Get("GrpList")
	
	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	i ..sssLock(AppName_Init)'=0 d RtnObj.Err(-99,"","转移单"_Init_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Scg=$p(^DHCINIT(Init),"^",23)
	s Main="{""LocId"":"""_DispLoc_""",""ReqLoc"":"""_ReqLoc_""",""gUserId"":"""_UserId_""",""Scg"":"""_Scg_""",""ReqMode"":"""_DispMode_""",""UserList"":"""_UserList_""",""GrpList"":"""_GrpList_"""}"
	
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Detail=""
	while(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Initi=Obj.%Get("RowId")		//转移单明细Id
		s DispQty=Obj.%Get("DispQty")	//发放数量
		s intrid=$o(^DHCINTR(0,"TypePointer","K",Initi,""))
		q:intrid=""
		s Inclb=$p(^DHCINTR(intrid),"^",7)
		;s Inclb=Obj.%Get("Inclb")  ;出库科室的批次
		s UomId=Obj.%Get("UomId")
		s HospId=..sssHospId(DispLoc)
		s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$H,UomId,HospId)
		s JsonStr="{""RowId"":"""",""Inclb"":"""_Inclb_""",""Qty"":"""_DispQty_""",""UomId"":"""_UomId_""",""Rp"":"""_Rp_""",""Sp"":"""_Sp_"""}"
		i Detail="" d
		.s Detail=JsonStr
		e  d
		.s Detail=Detail_","_JsonStr
		i Detail="" d RtnObj.Err(-7,"","单据明细为空!")
		q:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj.Json()
	s Detail="["_Detail_"]"
	s RtnObj=..Save(Main,Detail)
	q:RtnObj.success'=0 RtnObj.Json()
		
	q RtnObj.Json()
}

}
