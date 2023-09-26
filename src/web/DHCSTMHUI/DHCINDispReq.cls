Import sqluser

Class web.DHCSTMHUI.DHCINDispReq Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCINDISPREQM";

/// Description:查询请领单主表信息
/// Creator:	tsr
/// CreatDate:	2019-04-27
/// Table:		dhc_indispreq
/// w ##class(web.DHCSTMHUI.DHCINDispReq).Select(2)
ClassMethod Select(Dsrq) As %String
{
	n (Dsrq)
	q:Dsrq="" "{}"

	&sql(SELECT DSRQ_RowId, DSRQ_No, DSRQ_DispLoc_DR, DSRQ_SCG_DR, DSRQ_Date,
			DSRQ_Time, DSRQ_SSUSR_DR, DSRQ_ReqMode, DSRQ_ReqUserGrp_DR, DSRQ_ReqUser_DR,
			DSRQ_Complete, DSRQ_Status, DSRQ_Remark, DSRQ_DispLoc_DR->CTLoc_Desc, DSRQ_SCG_DR->SCG_Desc,
			DSRQ_ReqUserGrp_DR->lug_groupdesc,DSRQ_Template
		INTO :RowId, :DsrqNo, :LocId, :Scg, :CreateDate,
			:CreateTime, :UserId, :ReqMode, :ReqUserGrp, :ReqUser,
			:Complete, :Status, :Remark, :LocDesc, :ScgDesc,
			:GrpDesc,TemplateFlag
		FROM SQLUser.DHC_INDispReq WHERE DSRQ_RowId=:Dsrq) 
	q:SQLCODE "{}"
	s Remarks=$lts(Remark,..sssMemoDelim())
	s CreateDate=..DL2H(CreateDate)
	s CreateTime=..TL2H(CreateTime)
	s User=$s(UserId'="":$p(^SSU("SSUSR",UserId),"^",2),1:"")
	s User=..sssComboStr(UserId,User)
	s:ReqUser'="" ReqUser=$p(^SSU("SSUSR",ReqUser),"^",2)
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	s LocId=..sssComboStr(LocId,LocDesc)
	s UserGrp=..sssComboStr(ReqUserGrp,GrpDesc)
	s DataStr=RowId_"^"_DsrqNo_"^"_CreateDate_"^"_CreateTime_"^"_User
		_"^"_Complete_"^"_ReqMode_"^"_ReqUserGrp_"^"_GrpDesc_"^"_ReqUser
		_"^"_Scg_"^"_ScgDesc_"^"_Remarks_"^"_LocId_"^"_Status
		_"^"_TemplateFlag_"^"_UserGrp

	s TitleStr="RowId^DsrqNo^CreateDate^CreateTime^User"
		_"^CompFlag^ReqMode^ReqUserGrp^GrpDesc^ReqUser"
		_"^Scg^ScgDesc^Remarks^LocId^Status"
		_"^TemplateFlag^UserGrp"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Description:查询请领单列表
/// Creator:	tsr
/// CreatDate:	2019-04-27
/// Table:		dhc_indispreq
/// Others:		d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINDispReq","DHCINDispReq",^tmpbin(58))
Query DHCINDispReq(Params As %String) As Query(ROWSPEC = "RowId,DsrqNo,LocDesc,CreateDate,CreateTime,CreateUser,ReqUser,GrpDesc,ScgDesc,Comp,Status,ReqMode,Remark,DispSchedule,TemplateFlag") [ SqlProc ]
{
}

ClassMethod DHCINDispReqExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId=PJObj.%Get("LocId")
	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pStatus=PJObj.%Get("Status")
	s pCompFlag=PJObj.%Get("CompFlag")
	s pUserGroup=PJObj.%Get("UserGroup")
	s pUser=PJObj.%Get("gUserId")
	s NotDisp=PJObj.%Get("NotDisp")
	s PartDisp=PJObj.%Get("PartDisp")
	s AllDisp=PJObj.%Get("AllDisp")
	s UserGrp=PJObj.%Get("UserGrp")
	s pTemplateFlag=PJObj.%Get("TemplateFlag")
	q:pLocId="" $$$OK
	q:pStartDate="" $$$OK
	q:pEndDate="" $$$OK
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s DispStatus=""
	i NotDisp'="" s DispStatus=NotDisp
	i PartDisp'="" s DispStatus=DispStatus_","_PartDisp
	i AllDisp'="" s DispStatus=DispStatus_","_AllDisp
	s:pTemplateFlag="" pTemplateFlag="N"
	s SqlStr="select %ID RowId,"
		_"dsrq_no DsrqNo,"
		_"dsrq_disploc_dr->ctloc_desc LocDesc,"
		_"dsrq_date CreateDate,"
		_"dsrq_time CreateTime,"
		_"dsrq_ssusr_dr->ssusr_name CreateUser,"
		_"dsrq_requser_dr ReqUserId,"
		_"dsrq_requser_dr->ssusr_name ReqUser,"
		_"dsrq_scg_dr->scg_desc ScgDesc,"
		_"nvl(dsrq_complete,'N') Comp,"
		_"dsrq_status Status,"
		_"dsrq_reqmode ReqMode,"
		_"dsrq_requsergrp_dr Grp,"
		_"dsrq_requsergrp_dr->lug_groupdesc GrpDesc,"
		_"dsrq_remark Remark,"
		_"dsrq_Template TemplateFlag"
		_" From dhc_indispreq"
		_" Where dsrq_disploc_dr="_pLocId
		_" And dsrq_date between "_pStartDate_" And "_pEndDate
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s DsrqNo=xrs.Data("DsrqNo")
		s LocDesc=xrs.Data("LocDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s ReqUserId=xrs.Data("ReqUserId")
		s ReqUser=xrs.Data("ReqUser")
		s ReqGrp=xrs.Data("Grp")
		s GrpDesc=xrs.Data("GrpDesc")
		s ScgDesc=xrs.Data("ScgDesc")
		s Comp=xrs.Data("Comp")
		s Status=xrs.Data("Status")
		s ReqMode=xrs.Data("ReqMode")
		s Remark=xrs.Data("Remark")
		s TemplateFlag=xrs.Data("TemplateFlag")
		s:TemplateFlag="" TemplateFlag="N"
		continue:(pTemplateFlag'="")&&(TemplateFlag'=pTemplateFlag)
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Remark=$lts(Remark,MemoDelim)
		CONTINUE:(pCompFlag'="")&&(pCompFlag'=Comp)
		CONTINUE:(pStatus'="")&&(pStatus'=Status)
		CONTINUE:(pUserGroup'="")&&(pUserGroup'=ReqGrp)
		CONTINUE:(UserGrp'="")&&(UserGrp'=ReqGrp)
		i pUser'="",ReqUserId'="" CONTINUE:pUser'=ReqUserId
		i pUser'="",ReqGrp'="" CONTINUE:..SelfGrp(pUser,ReqGrp)<0
		s DispSchedule=..GetINDispReqSchedule(RowId)	//0:未发放, 1:部分发放, 2:全部发放
		CONTINUE:(DispStatus'="")&&('$f(DispStatus,DispSchedule))
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DsrqNo,LocDesc,CreateDate,CreateTime,CreateUser,ReqUser,GrpDesc,ScgDesc,Comp,Status,ReqMode,Remark,DispSchedule,TemplateFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:判断用户是否属于该专业组
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_sublocuser
/// Input:		用户Id,专业组Id
ClassMethod SelfGrp(LocUser, ReqGrp) As %String
{
	n (LocUser,ReqGrp)
	s grp=""
	&sql(select %id into :grp From dhc_sublocuser where slu_user_dr=:LocUser and slu_group_parref=:ReqGrp)  
	q:grp="" -1
	q 0
}

/// Description:保存请领单
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
	s DsrqId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINDispReqItm).Save(DsrqId,Detail)
	i RtnObj.success'=0 tro  q RtnObj
	tc
	s RtnObj.rowid=DsrqId
	q RtnObj
}

/// Description:插入更新请领单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_InDispReq
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","Update入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s DsrqId=PJObj.%Get("RowId")
	s CompFlag=$s(DsrqId'="":$p(^DHCINDSREQ(DsrqId),"^",11),1:"")
	i CompFlag="Y" d RtnObj.Err(-2,"","单据已完成!","",0)
	q:RtnObj.success'=0 RtnObj

	s LocId=PJObj.%Get("LocId")
	s UserId=PJObj.%Get("User")
	s:UserId="" UserId=PJObj.%Get("gUserId")
	s DsrqScg=PJObj.%Get("Scg")				//类组RowId
	s ReqMode=PJObj.%Get("ReqMode")
	s UserGrp=PJObj.%Get("UserGrp")
	s Remarks=PJObj.%Get("Remarks")
	s TemplateFlag=PJObj.%Get("TemplateFlag")	;模板标记
	s MemoDelim=..sssMemoDelim()
	s Remarks=$lfs(Remarks,MemoDelim)
	s Date=+$h
	s Time=$p($h,",",2)
	s AppName=..%GetParameter("AppName")

	i DsrqId="" d
	.s DsrqNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,DsrqScg,LocId)
	.i (DsrqNo<0)||(DsrqNo="") d RtnObj.Err(-3,"","单号生成失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCINDispReq).%New()
	.s obj.DSRQNo=DsrqNo
	.s obj.DSRQDate=Date
	.s obj.DSRQTime=Time
	e  d
	.i ..sssLock(AppName_DsrqId)'=0 d RtnObj.Err(-99,"",DsrqId_"锁定失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCINDispReq).%OpenId(DsrqId)
	.d obj.%Reload()
	q:RtnObj.success'=0 RtnObj
	
	d obj.DSRQDispLocDRSetObjectId(LocId)
	d obj.DSRQSSUSRDRSetObjectId(UserId) 
	d obj.DSRQReqUserDRSetObjectId(UserId) 
	s obj.DSRQRemark=Remarks
	d obj.DSRQSCGDRSetObjectId(DsrqScg)
	s obj.DSRQReqMode=ReqMode
	d obj.DSRQReqUserGrpDRSetObjectId(UserGrp)
	s obj.DSRQStatus="O"
	s obj.DSRQTemplate=TemplateFlag
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.d ..sssUnLock(AppName_DsrqId)
	.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
	.d RtnObj.Err(-5,"","请领单保存失败:"_sc)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(AppName_DsrqId)
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Description:删除请领单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispreq
/// Input:		请领单Id
ClassMethod Delete(DsrqId As %String) As %String
{
	n (DsrqId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_DsrqId)'=0 d RtnObj.Err(-99,"",DsrqId_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=..AllowDel(DsrqId)
	i RtnObj.success'=0 d ..sssUnLock(DsrqId)
	q:RtnObj.success'=0 RtnObj.Json()
		
	&sql(delete from dhc_indispreq where %ID=:DsrqId)	
	d ..sssUnLock(AppName_DsrqId)
	i SQLCODE'=0 d RtnObj.Err(-1,DsrqId,SQLCODE_"删除失败!")
	q RtnObj.Json()
}

/// Description:判断是否允许删除请领单主表记录
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		dhc_indispreq,dhc_indisp
/// Input:		请领单Id
ClassMethod AllowDel(Dsrq As %String) As RtnObj
{
	n (Dsrq)
	s RtnObj=##class(RtnObj).%New()
	s CompFlag=$p(^DHCINDSREQ(Dsrq),"^",11)
	i CompFlag="Y" d RtnObj.Err(-11,Dsrq,"已完成,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="C" d RtnObj.Err(-12,Dsrq,"已处理,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	i Status="X" d RtnObj.Err(-13,Dsrq,"已作废,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	s Inds=""
	&sql(select %id into :Inds From dhc_indisp where inds_Rq_dr=:Dsrq)
	i +Inds>0 d RtnObj.Err(-14,Dsrq,"已发放,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:完成请领单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreq
/// Input:		
/// Return:		
ClassMethod SetComp(Dsrq As %String) As %String
{
	n (Dsrq)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s CompFlag=$p(^DHCINDSREQ(Dsrq),"^",11)
	i CompFlag="Y" d RtnObj.Err(-1,Dsrq,"该请领单已完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq)'=0 d RtnObj.Err(-99,"",Dsrq_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Comp="Y",Status="O"
	&sql(update dhc_indispreq set DSRQ_Complete=:Comp, DSRQ_Status=:Status where %id=:Dsrq)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsrq)
	.d RtnObj.Err(-3,Dsrq,"完成失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ..sssUnLock(AppName_Dsrq)
	s RtnObj.rowid=Dsrq
	q RtnObj.Json()
}

/// Description:取消完成请领单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreq
/// Input:		请领单Id
/// Return:		
ClassMethod CancelComp(Dsrq As %String) As %String
{
	n (Dsrq)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s CompFlag=$p(^DHCINDSREQ(Dsrq),"^",11)
	i CompFlag'="Y" d RtnObj.Err(-1,Dsrq,"该请领单未完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="C" d RtnObj.Err(-5,Dsrq,"已处理,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj
	i Status="X" d RtnObj.Err(-6,Dsrq,"已作废,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq)'=0 d RtnObj.Err(-99,"",Dsrq_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Comp="N",Status="O"
	&sql(update dhc_indispreq set DSRQ_Complete=:Comp, DSRQ_Status=:Status where %id=:Dsrq)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsrq)
	.d RtnObj.Err(-3,Dsrq,"取消完成失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(update dhc_indispreqitm set DSRQI_MoveStatus='G' where DSRQI_DSRQ_ParRef=:Dsrq)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsrq)
	.d RtnObj.Err(-4,Dsrq,"更新请领单明细状态失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ..sssUnLock(AppName_Dsrq)
	s RtnObj.rowid=Dsrq
	q RtnObj.Json()
}

/// Description:作废请领单
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreq
/// Input:		请领单Id
ClassMethod CancelReq(Dsrq As %String) As %String
{
	n (Dsrq)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()

	s Inds=""
	&sql(select %id into :Inds From dhc_indisp where inds_Rq_dr=:Dsrq)
	i +Inds>0 d RtnObj.Err(-1,Dsrq,"已发放,不能作废!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s CompFlag=$p(^DHCINDSREQ(Dsrq),"^",11)
	i CompFlag'="Y" d RtnObj.Err(-1,Dsrq,"该请领单未完成,无需作废!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="C" d RtnObj.Err(-2,Dsrq,"已处理,不能作废!","",0)
	q:RtnObj.success'=0 RtnObj

	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="X" d RtnObj.Err(-3,Dsrq,"已作废,不能重复作废!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq)'=0 d RtnObj.Err(-99,"",Dsrq_"锁定失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(UPDATE SQLUser.DHC_INDispReq SET DSRQ_Status = 'X' WHERE DSRQ_RowId = :Dsrq)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Dsrq)
	.d RtnObj.Err(-3,Dsrq,"作废失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ..sssUnLock(AppName_Dsrq)
	s RtnObj.rowid=Dsrq
	q RtnObj.Json()
}

/// Description:根据已审核发放数量来判断请领单执行情况
/// Creater:    wangjiabin
/// CreateDate: 2013-12-08
/// Table:		dhc_indispreq,dhc_indisp
/// Input:		请领单主表rowid
/// Output:     
/// Return：	0:未发放, 1:部分发放审核, 2:全部发放审核
ClassMethod GetINDispReqSchedule(dsrq As %String) As %String
{
	n (dsrq)
	s inds=$o(^DHCINDS(0,"RQ",dsrq,0))
	q:inds="" 0
	s Flag=2   ;初始化为全部发放
	s ChlNum=0,ZeroNum=0
	s Chl=0
	f  s Chl=$o(^DHCINDSREQ(dsrq,"I",Chl))  q:(Chl="")!(Flag=1)  d
	.s inci=$p(^DHCINDSREQ(dsrq,"I",Chl),"^",1)
	.s reqQty=$p(^DHCINDSREQ(dsrq,"I",Chl),"^",2)
	.s reqUom=$p(^DHCINDSREQ(dsrq,"I",Chl),"^",3)
	.s bUom=$p(^INCI(inci,1),"^",10)
	.s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(reqUom,bUom)
	.s qtyBuom=reqQty*uomFac
	.s dsrqi=dsrq_"||"_Chl
	.s ChlNum=ChlNum+1
	.s indsiQty=##class(web.DHCSTMHUI.DHCINDispReqItm).GetDispQty(dsrqi)
	.s AuditIndsiQty=$p(indsiQty,"^",2)
	.i AuditIndsiQty=0 d
	..s ZeroNum=ZeroNum+1
	.e  i AuditIndsiQty<qtyBuom d
	..s Flag=1
	i (Flag'=1)&&(ZeroNum=ChlNum) s Flag=0
	i (Flag'=1)&&(ZeroNum'=0)&&(ZeroNum<ChlNum) s Flag=1
	q Flag
}

/// Description:拒绝请领单,先执行"取消完成"操作,控制已请领数据的数值
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		dhc_indispreq
/// Input:		请领主表id
ClassMethod DenyReq(Dsrq As %String) As %String
{
	n (Dsrq)
	s RtnObj=##class(RtnObj).%New()	
	i Dsrq="" d RtnObj.Err(-1,"","请选择请领单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName_Dsrq) d RtnObj.Err(-99,Dsrq,"请领单加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Inds=$o(^DHCINDS(0,"RQ",Dsrq,0))
	i Inds'="" d
	.d RtnObj.Err(-2,Dsrq,"请领单已处理,不能拒绝!","",0)
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()

	s Complete=$p(^DHCINDSREQ(Dsrq),"^",11)
	i Complete'="Y" d
	.d RtnObj.Err(-3,Dsrq,"请领单未完成,不能拒绝!","",0)
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()

	s Status=$p(^DHCINDSREQ(Dsrq),"^",9)
	i Status="C" d RtnObj.Err(-4,Dsrq,"请领单已处理,不能拒绝!","",0)
	i Status="X" d RtnObj.Err(-5,Dsrq,"请领单已作废,不能拒绝!","",0)
	i Status="R" d RtnObj.Err(-6,Dsrq,"请领单已拒绝,无需再次拒绝!","",0)
	i RtnObj.success'=0 d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()

	&sql(UPDATE SQLUser.DHC_INDispReq SET DSRQ_Status = 'R' WHERE DSRQ_RowId = :Dsrq)
	i SQLCODE'=0 d
	.d RtnObj.Err(-7,Dsrq,"更新请领单状态失败!") 
	.d ..sssUnLock(AppName_Dsrq)
	q:RtnObj.success'=0 RtnObj.Json()
	q RtnObj.Json()
}

/// w ##class(web.DHCSTMHUI.DHCINDispReq).CheckDsrqStatus(78)
/// 检查并重设请领单和请领单子表的status,moveStatus
/// D-->G
ClassMethod ResetDsrqStatus(dsrq As %String) As %String
{
	n (dsrq)
	q:dsrq="" 0
	s $ZT=..sssError()
	s lockName=..%GetParameter("AppName")_dsrq
	q:..sssLock(lockName)<0 -99
	
	ts
	s ret=0,readyStatus="G"
	s ch=0
	f  s ch=$o(^DHCINDSREQ(dsrq,"I",ch)) q:(ch="")!(ret<0)  d
	.s dsrqi=dsrq_"||"_ch
	.s ret=##class(web.DHCSTMHUI.DHCINDispReqItm).ResetDsrqiStatus(dsrqi)
	i ret<0 d ..sssUnLock(lockName) tro  q ret
	
	i '$d(^DHCINDS(0,"RQ",dsrq)) d
	.s status="O"
	.&sql(update dhc_indispreq set DSRQ_Status=:status where %id=:dsrq)
	.i SQLCODE s ret=-2
	i ret<0 d ..sssUnLock(lockName) tro  q ret
	
	d ..sssUnLock(lockName)
	tc
	q 0
}

ClassMethod CheckLocReqMode(Mode, LocId, UserId, GrpId) As %String
{
	n (Mode,LocId,UserId,GrpId)
	q:(Mode="")||(LocId="") "N"
	
	s Flag="N"
	s RowId=""
	i Mode="0" d //判断专业组
	.&sql(select LUG_RowId into :RowId from DHC_SubLocUserGroup where LUG_CTLOC_DR=:LocId and LUG_RowId=:GrpId)
	e  d
	.&sql(select SSUSR_RowId into :RowId from SS_User where SSUSR_DefaultDept_DR=:LocId and SSUSR_RowId=:UserId union select othll_parref as RowId from SS_UserOtherLogonLoc where othll_ctloc_dr=:LocId and othll_parref=:UserId)

	i RowId'="" s Flag="Y"
	q Flag
}

}
