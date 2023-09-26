Import sqluser

Class web.DHCSTMHUI.INRequest Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTINREQM";

/// 插入或更新转移请求单主表记录
/// Author:XuChao
/// Date:2018-06-11
/// Argu: 
/// Return:
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Req=PJObj.%Get("RowId")
	s FrLoc=PJObj.%Get("SupLoc")
	s ToLoc=PJObj.%Get("ReqLoc")
	s User=PJObj.%Get("gUserId")		//请求人
	s gGroupId=PJObj.%Get("gGroupId")		//安全组
	s HospId=PJObj.%Get("gHospId")		//医院
	s Loc=PJObj.%Get("gLocId")			//登录科室
	s Scg=PJObj.%Get("ScgStk")			//类组
	s ReqType=PJObj.%Get("ReqType")		//申领计划标志
	s Remark=PJObj.%Get("ReqRemarks")	//备注
	s Template=PJObj.%Get("Template")	//模板标志
	s RelateReq=PJObj.%Get("RelateReq")	//关联的计划rowid
	s ZnccNum=PJObj.%Get("ZnccNum")		//智能仓储单号  目的为以后的出库审核做判断
	s AnArr=PJObj.%Get("AnArr")			//手术安排表ID
	s Medicare=PJObj.%Get("Medicare")	//住院号
	
	i FrLoc="" d
	.s Sc=RtnObj.Err(-1,"","供应科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i ToLoc="" d
	.s Sc=RtnObj.Err(-2,"","请求科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Date=+$h
	s Time=$p($h,",",2)
	s AddFlag="Y"	//是否新增
	s PAPatMasId=""
	s:Medicare'="" PAPatMasId=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(Medicare),""))
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Remark=$lfs(Remark,memoDelim)
	s StkType=..sssCode()
	
	s Param=gGroupId_"^"_ToLoc_"^"_User_"^"_HospId
	s AllowBusiness=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINSTKTKM","AllowBusiness",Param)
	s ToLocIfExistInStkTk=""
	s:AllowBusiness'="Y" ToLocIfExistInStkTk=##class(web.DHCSTMHUI.INStkTk).CheckInStkTkByLoc(ToLoc) 
	i ToLocIfExistInStkTk="Y" q RtnObj.Err(-3,"","存在未完成盘点单，请盘点完成后再进行物资请领","",0)
	
	s LockName=..%GetParameter("AppName")_Req
	i (Req'="")&&(..sssLock(LockName)<0)  d
	.s Sc=RtnObj.Err(-99,Req,"加锁失败!")
	q:RtnObj.success'=0 RtnObj
	
	i Req="" d
	.s ReqNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),Scg,ToLoc)
	.i (ReqNo<0)||(ReqNo="") d
	..d RtnObj.Err(-3,"","单号生成失败:"_ReqNo)
	.q:RtnObj.success<0
	.
	.s obj=##class(User.INRequest).%New()
	.s obj.INRQNo=ReqNo
	.s obj.INRQDate=Date
	.s obj.INRQTime=Time
	.d obj.INRQSSUSRDRSetObjectId(User)
	e  d
	.s AddFlag="N"
	.s obj=##class(User.INRequest).%OpenId(Req)
	q:RtnObj.success<0 RtnObj
	
	d obj.INRQRecLocDRSetObjectId(ToLoc)
	d obj.INRQReqLocDRSetObjectId(FrLoc)
	s obj.INRQStatus=ReqType			;这个地方,和附加表重复?
	d obj.INRQRemarks.Clear()
	d obj.INRQRemarks.InsertList(Remark)
	s sc=obj.%Save()
	i $$$ISERR(sc) d ..sssUnLock(LockName) q RtnObj.Err(-5,"","更新失败!")
	s SaveReqId=obj.%Id()
	
	s dhcReq=$o(^DHCINRQ(0,"INRQ",SaveReqId,0))
	i (AddFlag="Y")&&(dhcReq'="") d
	.s dhcReq=""
	.&sql(delete from DHC_INRequest where INRQ_INRQ_DR=:SaveReqId)
	.i SQLCODE'=0 d RtnObj.Err(-12,SaveReqId,"附加表历史数据删除失败!"_SQLCODE)
	i RtnObj.success'=0 d ..sssUnLock(LockName) q RtnObj

	i dhcReq="" d
	.s dhcObj=##class(User.DHCINRequest).%New()
	.d dhcObj.INRQINRQDRSetObjectId(SaveReqId)
	.d dhcObj.INRQRelateReqDRSetObjectId(RelateReq)
	.s dhcObj.INRQSNCCNum=ZnccNum
	.s dhcObj.INRQANArrDR=AnArr
	.d dhcObj.INRQCreateLocDRSetObjectId(Loc)
	.s dhcObj.INRQStkType=StkType
	e  d
	.s dhcObj=##class(User.DHCINRequest).%OpenId(dhcReq)
	s dhcObj.INRQType=ReqType
	d dhcObj.INRQSCGDRSetObjectId(Scg)
	s dhcObj.INRQTemplate=Template
	s dhcObj.INRQMrNo=Medicare
	s sc=dhcObj.%Save()
	i $$$ISERR(sc) d ..sssUnLock(LockName) q RtnObj.Err(-8,"","附加表插入失败!")
	
	d ..sssUnLock(LockName)
	s RtnObj.rowid=SaveReqId
	q RtnObj
}

/// 检索库存转移请求单主表记录数据
/// Author:XuChao
/// Date:2018-06-11
/// Argu:
/// req - 转移请求单主表Rowid
/// Return:请求单主表记录数据JSON串
/// w ##class(web.DHCSTMHUI.INRequest).Select(43)
ClassMethod Select(Req As %String) As %String
{
	n (Req)
	s (INRQRowId,INRQNo,INRQRecLocDR,INRQSSUSRDR,INRQStatus,INRQDate,INRQReqLocDR,INRQTime,ReqRemarks,Comp)=""
	&sql(select INRQ_RowId, INRQ_No, INRQ_RecLoc_DR, INRQ_SSUSR_DR, INRQ_Status, INRQ_Date, INRQ_ReqLoc_DR, INRQ_Time, INRQ_Remarks, INRQ_UserCompleted
		into :INRQRowId, :INRQNo, :INRQRecLocDR, :INRQSSUSRDR, :INRQStatus, :INRQDate, :INRQReqLocDR, :INRQTime, :ReqRemarks, :Comp
		from IN_Request where %ID=:Req)
	q:SQLCODE "{}"
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s INRQDate=..DL2H(INRQDate)
	s INRQTime=..TL2H(INRQTime)
	s ReqRemarks=$LTS(ReqRemarks,memoDelim)
	
	s ReqLocId=$p(^INRQ(Req),"^",5)		//供应科室
	s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2)
	s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	s ReqLoc=..sssComboStr(ReqLocId,ReqLocDesc)
	s RecLocId=$p(^INRQ(Req),"^",6)		//请求科室
	s RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	s RecLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLocDesc)
	s RecLoc=..sssComboStr(RecLocId,RecLocDesc)
	s User=$p(^INRQ(Req),"^",4)
	s UserName=$P(^SSU("SSUSR",User),"^",2)
	s (Inrqtype,ScgStk,ScgStkDesc,InrqType)=""
	s DHCInrq=$o(^DHCINRQ(0,"INRQ",Req,""),-1)
	i DHCInrq'="" d
	.s ScgStk=$p(^DHCINRQ(DHCInrq),"^",10)
	.s InrqType=$p(^DHCINRQ(DHCInrq),"^",1)
	.i ScgStk'="" s ScgStkDesc=$p($G(^DHCSCG(ScgStk)),"^",2)
	.s Template=$p(^DHCINRQ(DHCInrq),"^",18)
	.s AutoSum=$p(^DHCINRQ(DHCInrq),"^",19)
	.s ANArrDR=$p(^DHCINRQ(DHCInrq),"^",27)		//手术安排ID
	.s Medicare="",PatientName="",RegNo="",PAAdmDR=""
	.s Medicare=$p(^DHCINRQ(DHCInrq),"^",34)
	.i Medicare'="" d
	..s PAAdmDR=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPatientIDByMrNo(Medicare,"",.ErrMsg)
	..s PatientName=$p(^PAPER(PAAdmDR,"ALL"),"^",1)
	..s RegNo=$p(^PAPER(PAAdmDR,"PAT",1),"^",1)		;登记号
	
	;SupLocId需要处理
	
	s Data=Req_"^"_INRQNo_"^"_RecLocId_"^"_User
		_"^"_INRQStatus_"^"_INRQDate_"^"_ReqLocId_"^"_INRQTime
		_"^"_ReqRemarks_"^"_Comp_"^"_RecLoc_"^"_ReqLoc_"^"_UserName
		_"^"_ScgStkDesc_"^"_ScgStk_"^"_InrqType_"^"_Template_"^"_AutoSum
		_"^"_ANArrDR_"^"_Medicare_"^"_PatientName_"^"_RegNo
	s Title="RowId^ReqNo^ReqLocId^User"
		_"^ReqType^Date^SupLocId^Time"
		_"^ReqRemarks^Comp^ReqLoc^SupLoc^UserName"
		_"^ScgStkDesc^ScgStk^InrqType^Template^AutoSum"
		_"^ANArrDR^Medicare^PatientName^RegNo"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// 删除库存转移请求单主表
/// Author:XuChao
/// Date:2018-05-8
/// Argu:
/// Return:
ClassMethod Delete(Req As %String) As %String
{
	n (Req)
	s RtnObj=##class(RtnObj).%New()
	i Req="" s Sc=RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s LockName=..%GetParameter("AppName")_Req
	i ..sssLock(LockName)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ..AllowDel(Req)<0 d ..sssUnLock(LockName) s Sc=RtnObj.Err(-2,"","完成或依据此单据制单,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	;先删除子表对应扩展表中的数据
	&sql(delete from dhc_inreqitm where INRQI_INRQI_DR->INRQI_INRQ_ParRef=:Req)
	i SQLCODE<0 d ..sssUnLock(LockName) tro  s Sc=RtnObj.Err(-3,"","扩展表删除失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(delete from DHC_INRequest where INRQ_INRQ_DR=:Req)
	i SQLCODE'=0 d ..sssUnLock(LockName) tro  s Sc=RtnObj.Err(-4,"","扩展表删除失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(delete from in_request where %ID=:Req)
	i SQLCODE'=0 d ..sssUnLock(LockName) tro  s Sc=RtnObj.Err(-5,"","删除失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	d ..sssUnLock(LockName)
	tc
	q RtnObj.Json()
}

/// 检查是否允许删除
/// Author:zhwh
/// Date:2012-07-11
/// Argu:
///  req - 转移请求单主表Rowid///
/// Return:
///   0 - success
///   <0  -failure (-1,-2,-3)
///   
ClassMethod AllowDel(req As %String) As %String
{
	n (req)
	s obj=##class(User.INRequest).%OpenId(req)
	d obj.%Reload()
	s comp=obj.INRQUserCompleted
	i comp="Y" q -1
	s init=""
	&sql(select %ID into :init from dhc_inistrf where init_inrq_dr=:req)
	i +init>0 q -2

	//检查请求明细内容是否已经转采购计划明细
	s ch=0
	s inpp=0
	f  s ch=$o(^INRQ(req,"RQI",ch))  q:(ch="")!(+inpp>0)  d
	.s reqi=req_"||"_ch
	.s inpp=$O(^INPP(0,"RQI",reqi,""))
	.q:+inpp>0
	i +inpp>0 q -3
	q 0
}

/// 库存转移请求单主记录查询
/// Author:XuChao
/// Date:2018-06-11
/// Argu:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequest","INReqM","{""StartDate"":""2019-12-16"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""ReqLoc"":""2"",""Complate"":"""",""EndDate"":""2020-01-15"",""SupLoc"":"""",""AllTransfer"":""Y"",""PartTransfer"":""Y"",""NoTransfer"":""Y"",""HvFlag"":""N""}")
Query INReqM(Params As %String) As Query(ROWSPEC = "RowId:%String,ToLoc:%String,ToLocDesc:%String,FrLoc:%String,FrLocDesc:%String,ReqUser:%String,UserName:%String,Date:%String,Time:%String,Status:%String,Complete:%String,ReqNo:%String,Remark:%String,RecLocAudited:%String,ProvLocAudited:%String,Template:%String,ReqType:%String,ScgDesc:%String,AuditDate:%String,AuditTime:%String,AuditUser:%String,AuditDateProv:%String,AuditTimeProv:%String,AuditUserProv:%String,PreFlag:%String,AutoSum:%String,Medicare:%String,PatientName:%String,RegNo:%String")
{
}

ClassMethod INReqMExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate")
	s pToLoc=PJobj.%Get("ReqLoc")					//申请部门 
	s pFrLoc=PJobj.%Get("SupLoc")					//供给部门
	s pComp=PJobj.%Get("Complate")					//包含完成的
	s pAllTransfer=PJobj.%Get("AllTransfer")
	s pPartTransfer=PJobj.%Get("PartTransfer")
	s pNoTransfer=PJobj.%Get("NoTransfer")
	s pRecLocAudited=PJobj.%Get("RecLocAudited")	//请求方已审核
	s pProvLocAudited=PJobj.%Get("ProvLocAudited")	//供应方已审核
	s pReqType=PJobj.%Get("ReqType")				//请求单类型
	s pInrqPreFlag=PJobj.%Get("InrqPreFlag")		//仓库是否拒绝
	s pScg=PJobj.%Get("Scg")						//类组
	s pUserId=PJobj.%Get("gUserId")	
	s pLocId=PJobj.%Get("gLocId")
	s gHospId=PJobj.%Get("gHospId")
	s pHV=PJobj.%Get("HvFlag")						//高值标志
	s pAnArrFlag=PJobj.%Get("AnArrFlag")			//手术标志
	s pInciDesc=PJobj.%Get("InciDesc")				//物资名称
	s pInci = PJobj.%Get("Inci")
	s StkType=..sssCode()
	s pHospId=..sssHospId(pFrLoc)
	s:pHospId="" pHospId=gHospId
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),"",pScg,pHospId)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s sql="select %ID RowId,"
	s sql=sql_"inrq_recloc_dr ToLoc,"
	s sql=sql_"inrq_recloc_dr->ctloc_Desc ToLocDesc,"
	s sql=sql_"inrq_reqloc_dr FrLoc,"
	s sql=sql_"inrq_reqloc_dr->ctloc_desc FrLocDesc,"
	s sql=sql_"inrq_ssusr_dr ReqUser,"
	s sql=sql_"inrq_ssusr_dr->ssusr_name UserName,"
	s sql=sql_"inrq_date ReqDate,"
	s sql=sql_"inrq_time ReqTime,"
	s sql=sql_"inrq_status ReqStatus,"
	s sql=sql_"inrq_usercompleted Comp,"
	s sql=sql_"INRQ_No ReqNo, "
	s sql=sql_"INRQ_Remarks Remark "
	s sql=sql_" from in_request"
	s sql=sql_" where inrq_date between "_StartDate_" and "_EndDate
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s IfMatDoc=##class(web.DHCSTMHUI.Common.UtilCommon).IfMatDoc(RowId,"REQ")
		continue:(IfMatDoc="N")
		s ToLoc=xrs.Data("ToLoc")
		i pToLoc'="" continue:pToLoc'=ToLoc
		s ToLocDesc=xrs.Data("ToLocDesc")
		s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
		s FrLoc=xrs.Data("FrLoc")
		i pFrLoc'="" continue:pFrLoc'=FrLoc
		s FrLocDesc=xrs.Data("FrLocDesc")
		s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
		s ReqUser=xrs.Data("ReqUser")
		s UserName=xrs.Data("UserName")
		s ReqDate=xrs.Data("ReqDate")
		i ReqDate'="" s ReqDate=..DL2H(ReqDate)
		s ReqTime=xrs.Data("ReqTime")
		i ReqTime'="" s ReqTime=..TL2H(ReqTime)
		s ReqStatus=xrs.Data("ReqStatus")
		s Comp=xrs.Data("Comp")
		s ReqNo=xrs.Data("ReqNo")
		s Remark=xrs.Data("Remark")
		s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Remark=$LTS(Remark,memoDelim)
		s RecLocAudited="N",ProvLocAudited="N"
		s (AuditUser,AuditUserProv,Template,PreFlag,ReqType,Scg,ScgDesc,AuditDateProv,AuditTimeProv,AutoSum)=""
		&sql(select inrq_audituser_dr,inrq_audituser_prov_dr,inrq_template,inrq_type,inrq_scg_dr,
				inrq_scg_dr->scg_desc,INRQ_PreFlag,INRQ_AuditDate,INRQ_AuditTime,INRQ_AuditDate_Prov,
				INRQ_AuditTime_Prov,INRQ_AutoSum,INRQ_AnArrDR,INRQ_StkType,INRQ_MrNo
			into :AuditUser,:AuditUserProv,:Template,:ReqType,:Scg,
				:ScgDesc,:PreFlag,:AuditDate,:AuditTime,:AuditDateProv,
				:AuditTimeProv,:AutoSum,:AnArr,:ReqStkType,:Medicare
			from dhc_inrequest where inrq_inrq_dr=:RowId )
		continue:(ScgStr'="")&&(Scg'="")&&(("^"_ScgStr_"^")'[("^"_Scg_"^"))
		s Ret=0
		s:(pInciDesc'="")||(pInci'="") Ret=..CheckInciDesc(RowId,pInciDesc,pInci)
		continue:((pInciDesc'="")||(pInci'=""))&&(Ret'=0)
		continue:(pInciDesc'="")&&(Ret'=0)
		continue:ReqStkType'=StkType
		i AuditDate'="" s RecLocAudited="Y"			//根据日期判断
		i AuditDateProv'="" s ProvLocAudited="Y"
		i pRecLocAudited'="" continue:RecLocAudited'=pRecLocAudited
		i pProvLocAudited'="" continue:ProvLocAudited'=pProvLocAudited
		i PreFlag="" s PreFlag="N"
		i pInrqPreFlag'="" continue:PreFlag'=pInrqPreFlag
		i pAnArrFlag="Y" continue:AnArr=""
		continue:Template="Y"		//排除模板请求单
		s:PreFlag="" PreFlag="N"
		i pReqType'="" continue:ReqType'=pReqType		//请求单类型
		i AuditDate'="" s AuditDate=..DL2H(AuditDate)
		i AuditTime'="" s AuditTime=..TL2H(AuditTime)
		i AuditUser'="" s AuditUser=$p(^SSU("SSUSR",AuditUser),"^",2)
		i AuditDateProv'="" s AuditDateProv=..DL2H(AuditDateProv)
		i AuditTimeProv'="" s AuditTimeProv=..TL2H(AuditTimeProv)
		i AuditUserProv'="" s AuditUserProv=$p(^SSU("SSUSR",AuditUserProv),"^",2)
		// 0 - 未完成, 1 - 部分完成, 2 - 完成
		s Status=##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(RowId)
		i Status="0" continue:pNoTransfer'="Y"
		i Status="1" continue:pPartTransfer'="Y"
		i Status="2" continue:pAllTransfer'="Y"
		i Comp="" s Comp="N"
		continue:(pComp'="")&&(pComp'=Comp)
		s HVFlag=..GetReqHVFlag(RowId)
		continue:(pHV'="")&&(HVFlag'=pHV)
		s PatientName="",RegNo="",PAAdmDR=""
		i Medicare'="" d
		.s PAAdmDR=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPatientIDByMrNo(Medicare,"",.ErrMsg)
		.s PatientName=$p(^PAPER(PAAdmDR,"ALL"),"^",1)
		.s RegNo=$p(^PAPER(PAAdmDR,"PAT",1),"^",1)		;登记号
		d OutPutRow1
	}
	Quit $$$OK

OutPutRow1
	s Data=$lb(RowId,ToLoc,ToLocDesc,FrLoc,FrLocDesc,ReqUser,UserName,ReqDate,ReqTime,Status,Comp,ReqNo,Remark,RecLocAudited,ProvLocAudited,Template,ReqType,ScgDesc,AuditDate,AuditTime,AuditUser,AuditDateProv,AuditTimeProv,AuditUserProv,PreFlag,AutoSum,Medicare,PatientName,RegNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 请求单完成
ClassMethod jsSetComp(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	tstart
	s RtnObj=..SetComp(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// 设置完成状态
/// Author:XuChao
/// Date:2018-05-8
/// Argu:
/// Return:
ClassMethod SetComp(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s Req=PJObj.%Get("RowId")
	s User=PJObj.%Get("gUserId")
	s Group=PJObj.%Get("gGroupId")
	i Req="" q RtnObj.Err(-1,"","Req不能为空!","",0)
	
	s Comp="N"
	&sql(select inrq_usercompleted into :Comp from IN_Request where %ID=:Req)
	i Comp="Y" q RtnObj.Err(-1,"","已经完成,不能重复完成!","",0)
	
	s LockName=..%GetParameter("AppName")_Req
	i ..sssLock(LockName)<0 q RtnObj.Err(-99,"","加锁失败!")
	
	//检查请求单是否已经使用
	&sql(select %id into :init From dhc_inistrf where init_inrq_Dr=:Req)
	i 'SQLCODE d ..sssUnLock(LockName) q RtnObj.Err(-1,"","已经出库!","",0)
	
	ts
	s Comp="Y"
	&sql(update IN_Request set inrq_usercompleted=:Comp where %ID=:Req)
	i SQLCODE d ..sssUnLock(LockName) tro  q RtnObj.Err(-1,"","更新失败!")
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Req,"RD",User,"RQ")
	//若请求方审核参数不为Y,自动进行请求方审核(设置date,time,不处理user_dr)
	s AppName=..%GetParameter("AppName")
	s RecLoc=$p(^INRQ(Req),"^",6)
	s HospId=$p(^CTLOC(RecLoc),"^",22)
	s Param=Group_"^"_RecLoc_"^"_User_"^"_HospId
	s RecLocAuditRequired=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"RecLocAuditRequired",Param)
	i RecLocAuditRequired'="Y" d
	.s Param=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Req_"^"_Group,"Req^gGroupId")
	.s RtnObj=..ReqSideAudit(Param)		//不传user
	i RtnObj.success'=0 d ..sssUnLock(LockName) tro  q RtnObj
	
	s MoveStatus="RD"		//request done
	s Rtn=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,"",User,Param)
	i Rtn<0 d ..sssUnLock(LockName) tro  q RtnObj.Err(-2,"","记录追踪信息失败!")
	
	;设置供应方在途数
	s Rtn=..HandleResQty(Req,1)
	i Rtn<0 d ..sssUnLock(LockName) tro  q RtnObj.Err(-2,"","设置在途数失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	d ..sssUnLock(LockName)
	tc
	
	s RtnObj.rowid=Req
	q RtnObj
}

/// 出库退回申请单 多选
/// Author:	lihui
/// Date:	20191112
/// w ##class(web.DHCSTMHUI.INRequest).jsCancelCompStr("99","")
ClassMethod jsCancelCompStr(ReqStr As %String, Flag As %String = "") As %String
{
	n (ReqStr,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s del="^"
	s len=$l(ReqStr,del)
	i len=0 q RtnObj.Err(-1,"","没有需要退回的单据","",0).Json()
	ts
	f i=1:1:len q:RtnObj.success'=0  d
	.s Req=$p(ReqStr,del,i)
	.q:Req=""
	.s RtnObj=..CancelComp(Req,Flag)
	.i RtnObj.success<0 q
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// w ##class(web.DHCSTMHUI.INRequest).jsCancelComp("99","")
ClassMethod jsCancelComp(Req As %String, Flag As %String = "") As %String
{
	n (Req,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Req="" q RtnObj.Err(-1,"","参数为空","",0)
	ts
	s RtnObj=..CancelComp(Req,Flag)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 取消完成状态
/// Author:	XuChao
/// Date:	2018-6-6
/// Argu:
///   Req -  请求单主表rowid,
///   Flag - 调用标志("":直接取消完成, "R":req请求方拒绝调用, "P":prov供应方拒绝调用, "T":库存转移制单退回)
/// Return:
ClassMethod CancelComp(Req As %String, Flag As %String = "") As RtnObj
{
	n (Req,Flag)
	s RtnObj=##class(RtnObj).%New()
	i Req="" s Sc=RtnObj.Err(-1,"","Req不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	;已采购的不允许取消完成
	s Inpp="",Ch=0
	f  s Ch=$o(^INRQ(Req,"RQI",Ch)) q:(Ch="")||(+Inpp>0)  d
	.s Inrqi=Req_"||"_Ch
	.s Inpp=$O(^INPP(0,"RQI",Inrqi,""))
	.q:+Inpp>0
	i +Inpp>0 q RtnObj.Err(-11,"","已经采购,不可以取消完成!","",0)
	
	s Comp="Y"
	&sql(select inrq_usercompleted into :Comp from IN_Request where %ID=:Req)
	i Comp'="Y" q RtnObj.Err(-1,"","未完成,不能取消完成!","",0)

	s LockName=..%GetParameter("AppName")_Req
	i ..sssLock(LockName)<0 q RtnObj.Err(-11,"","加锁失败!")
	
	//检查请求单是否已经使用
	&sql(select %id into :init From dhc_inistrf where init_inrq_Dr=:Req)
	i 'SQLCODE d ..sssUnLock(LockName) q RtnObj.Err(-11,"","已经使用,不得修改状态!","",0)
	
	//根据审核人dr判断是否为系统自动审核
	s (AuditUser,AuditUserProv,AuditDate,AuditDateProv,AutoSum)=""
	&sql(select INRQ_AuditUser_Dr,INRQ_AuditUser_Prov_Dr,INRQ_AuditDate,INRQ_AuditDate_Prov,INRQ_AutoSum
		into :AuditUser,:AuditUserProv,:AuditDate,:AuditDateProv,:AutoSum
		from dhc_inrequest where INRQ_INRQ_DR=:Req)
	i AutoSum="Y" d ..sssUnLock(LockName) q RtnObj.Err(-11,"","已经汇总不可以取消完成","",0)
	
	i Flag="" d
	.i (AuditUser'="")||(AuditUserProv'="") d
	..s Sc=RtnObj.Err(-11,"","已经审核不可以取消完成!","",0)
	e  i Flag="R" d
	.i AuditDate'="" d		//请求方已审核
	..s Sc=RtnObj.Err(-11,"","请求方已经审核不可以取消完成!","",0)
	e  i Flag="P" d
	.i AuditDateProv'="" d	//供应方已审核
	..s Sc=RtnObj.Err(-11,"","供应方已经审核不可以取消完成!","",0)
	e  i Flag="T" d
	.//库存转移制单退回
	i RtnObj.success'=0 d ..sssUnLock(LockName) q RtnObj
	ts
	;清除供应方在途数
	s Rtn=..HandleResQty(Req,0)
	i Rtn<0 d ..sssUnLock(LockName) tro  q RtnObj.Err(-11,"","清除供应方在途数失败!")
	
	s Comp="N"
	&sql(update IN_Request set inrq_usercompleted=:Romp where %ID=:Req)
	i SQLCODE d ..sssUnLock(LockName) tro  q RtnObj.Err(-21,"","更新标志失败!")
	
	&sql(update dhc_inrequest set INRQ_AuditUser_Dr=null,INRQ_AuditDate=null,INRQ_AuditTime=null,INRQ_AuditUser_Prov_Dr=null, INRQ_AuditDate_Prov=null,
		INRQ_AuditTime_Prov=null
		where INRQ_INRQ_DR=:Req)
	i SQLCODE d ..sssUnLock(LockName) tro  q RtnObj.Err(-11,"","更新附加表失败!")
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Req,"RD","RQ")
	d ..sssUnLock(LockName)
	tc
	s RtnObj.rowid=Req
	q RtnObj
}

/// 保存请求单主表和明细表的数据
/// Author:XuChao
/// Date:2018-05-02
/// Argu:
///  Main - 主表信息
///  Detail - 明细
/// Return
/// w ##class(web.DHCSTMHUI.INRequest).Save(^tmpljljjj,^tmpoook)
ClassMethod Save(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)	
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	tstart
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.INReqItm).Save(MainId,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tcommit
	s RtnObj.rowid=MainId
	q RtnObj.Json()
}

/// Description:通过就诊号获取病人信息返回Json格式
/// Table:PA_Adm 就诊表
/// w ##class(web.DHCSTMHUI.INRequest).ByAdmGetPatInfo("1")
ClassMethod ByAdmGetPatInfo(Adm As %String) As %Status
{
	n (Adm)
	s RtnObj=##class(RtnObj).%New()
	i Adm="" d RtnObj.Err(-1,"","请选择病人","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s RegNo="",PatName="",HospNo=""
	s PAADMPAPMIDR=$p(^PAADM(Adm),"^",1)
	;s PAADMDepCodeDR=$p(^PAADM(Adm),"^",4)
	s PatName=$p(^PAPER($p(^PAADM(Adm),"^",1),"ALL"),"^",1)
	s HospNo=$p(^PAPER($p(^PAADM(Adm),"^",1),"PAT",1),"^",22) ;住院号
	s RegNo=$p(^PAPER(PAADMPAPMIDR,"PAT",1),"^",1)
	;s PatLoc=$p(^CTLOC(PAADMDepCodeDR),"^",2)
	s rtn=RegNo_"^"_PatName_"^"_HospNo
	s RtnObj.rowid=rtn
	q RtnObj.Json()
}

/// 请求方审核
/// Author:XuChao
/// Date:2018-05-15
/// Return:
ClassMethod jsReqSideAudit(Params As %String) As %String
{
	n (Params)
	tstart
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..ReqSideAudit(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

ClassMethod ReqSideAudit(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Req=PJObj.%Get("Req")
	i Req="" s Sc=RtnObj.Err(-1,"","Req不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	&sql(select inrq_rowid,inrq_audituser_dr,inrq_auditdate,inrq_audittime 
		into
	 	:RowId,:AuditUser,:AuditDate,:AuditTime
		From dhc_inrequest where inrq_inrq_dr=:Req)
	i SQLCODE d
	.&sql(insert into DHC_INRequest (INRQ_INRQ_DR) values (:Req))
	.i SQLCODE'=0 s Sc=RtnObj.Err(-1,"","插入附加表失败!")  q
	.e  s RowId=$G(%ROWID)
	e  d
	.i AuditDate'="" s Sc=RtnObj.Err(-1,"","已经审核!","",0)  q		//已经审核(根据inrq_auditdate判断是否请求方审核)
	q:RtnObj.success'=0 RtnObj
	s AuditDate=+$h, AuditTime=$p($h,",",2)
	&sql(update dhc_inrequest 
		set 
		inrq_audituser_dr=:User,inrq_auditdate=:AuditDate,inrq_audittime=:AuditTime 
		where inrq_rowid=:RowId
		)
	i SQLCODE'=0 s Sc=RtnObj.Err(-1,"","更新附加表失败!")
	q:RtnObj.success'=0 RtnObj
	//临时请求和申领计划均做此处理
	s Ret=..SetDefaultQtyApproved(Req)
	i Ret<0 s Sc=RtnObj.Err(-1,"","更新批准数量!","",0)
	q:RtnObj.success'=0 RtnObj
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Req,"RA",User,"RQ")
	
	//供应方审核参数不为Y时,自动进行供应方审核(设置date,time,不处理user_dr)
	s AppName=..%GetParameter("AppName")
	s ReqLoc=$p(^INRQ(Req),"^",5)
	s HospId=$p(^CTLOC(ReqLoc),"^",22)
	s Param=GroupId_"^"_ReqLoc_"^"_User_"^"_HospId
	
	s ProvLocAuditRequired=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ProvLocAuditRequired",Param)
	i ProvLocAuditRequired'="Y" d
	.s Param=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Req_"^"_GroupId,"Req^gGroupId")
	.s RtnObj=..ProvSideAudit(Param)		//不传user

	i RtnObj.success'=0  tro
	q:RtnObj.success'=0 RtnObj
	//处理请领单 movestatus - zhwh 2014-08-2
	s MoveStatus="RA"  //reqloc audited
	s Ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,$zn,User,Param)
	i Ret<0 s Sc=RtnObj.Err(-1,"","处理MoveStatus失败!")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// 请求方拒绝
ClassMethod ReqSideDeny(Params As %String) As %String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Req=PJObj.%Get("Req")
	i Req="" s Sc=RtnObj.Err(-1,"","Req不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	tstart
	&sql(select inrq_rowid into :DhcInrq From dhc_inrequest where inrq_inrq_dr=:Req)
	i SQLCODE d
	.&sql(insert into DHC_INRequest (INRQ_INRQ_DR) values (:Req))
	.i SQLCODE'=0  tro  s Sc=RtnObj.Err(-1,"","插入附加表失败!")  q	
	.e  s DhcInrq=$G(%ROWID)
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(select 
		inrq_auditdate,inrq_audittime,INRQ_AuditDate_Prov,INRQ_AuditTime_Prov 
		into 
		:AuditDate,:AuditTime,:AuditDateProv,:AuditTimeProv
		From dhc_inrequest where %id=:DhcInrq)
	s UserProvDr=""
	&sql(SELECT INRQ_AuditUser_Prov_Dr into :UserProvDr FROM DHC_INRequest where INRQ_INRQ_DR=:Req)
	i UserProvDr="" d
	.i AuditDate'="" tro  s Sc=RtnObj.Err(-1,"","请求方已审核!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i AuditDateProv'="" tro  s Sc=RtnObj.Err(-1,"","供方已审核!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Req,"RD","RQ")

	s RtnObj=..CancelComp(Req,"R")
	i RtnObj.success'=0  tro  q RtnObj.Json()
	
	s ReqLoc=$p(^INRQ(Req),"^",5)
	s HospId=$p(^CTLOC(ReqLoc),"^",22)
	s Param=GroupId_"^"_ReqLoc_"^"_User_"^"_HospId
	//处理请领单 movestatus - zhwh 2014-08-2
	s MoveStatus="RAN"  //reqloc audited
	s Ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,$zn,User,Param)
	i Ret<0 tro  s Sc=RtnObj.Err(-1,"","记录MoveStatus失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// 供应方审核
/// Author:XuChao
/// Date:2014-05-15
/// Return:
ClassMethod jsProvSideAudit(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	tstart
	s RtnObj=..ProvSideAudit(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod ProvSideAudit(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Req=PJObj.%Get("Req")
	i Req="" s Sc=RtnObj.Err(-1,"","Req不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	//取是否需要供方审核参数
	s RecLocId=$p(^INRQ(Req),"^",6)
	s InrqUser=$p(^INRQ(Req),"^",4)
	
	s Param=GroupId_"^"_RecLocId_"^"_InrqUser
	s AppName=..%GetParameter("AppName")
	s RecLocAuditRequired=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"RecLocAuditRequired",Param)

	//根据auditdate判断单据是否审核(请领方,供应方)
	&sql(select INRQ_RowId,INRQ_AuditDate,INRQ_AuditDate_Prov 
		into 
		:DhcInrq,:AuditDate,:AuditDateProv
		From dhc_inrequest 
		where INRQ_INRQ_DR=:Req)
	i SQLCODE d
	.&sql(insert into DHC_INRequest (INRQ_INRQ_DR) values (:Req))
	.i SQLCODE'=0 s Sc=RtnObj.Err(-1,"","插入附加表失败!")  q 
	.e  s dhcInrq=$G(%ROWID)
	e  d
	.i RecLocAuditRequired="Y",AuditDate="" s Sc=RtnObj.Err(-1,"","请求方尚未审核!","",0)  q
	.i AuditDateProv'="" s Sc=RtnObj.Err(-1,"","已经审核!","",0)  q
	s AuditDate=+$h,AuditDateProv=$p($h,",",2)
	&sql(update dhc_inrequest 
		set
		inrq_audituser_prov_dr=:User,
		inrq_auditdate_prov=:AuditDate,
		inrq_audittime_prov=:AuditTime 
		where inrq_rowid=:DhcInrq
	)
	i SQLCODE'=0 s Sc=RtnObj.Err(-1,"","更新失败!")
	q:RtnObj.success'=0 RtnObj
	//处理请领单 movestatus
	s MoveStatus="EA"  //reqloc audited
	s Param=..sssParamStr()	
	s Ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,$zn,User,Param)
	i Ret<0 s Sc=RtnObj.Err(-1,"","记录MoveStatus失败!")
	q:RtnObj.success'=0 RtnObj
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Req,"EA",User,"RQ")
	q RtnObj
}

/// 供应方拒绝
ClassMethod ProvSideDeny(Params As %String) As %String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Req=PJObj.%Get("Req")
	i Req="" s Sc=RtnObj.Err(-1,"","Req不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	tstart
	&sql(select 
		inrq_rowid,INRQ_AuditDate,INRQ_AuditDate_Prov 
		into
		:RowId,:AuditDate,:AuditDateProv
		From dhc_inrequest 
		where inrq_inrq_dr=:Req
	)
	i SQLCODE d
	.&sql(insert into DHC_INRequest (INRQ_INRQ_DR) values (:Req))
	.i SQLCODE'=0  tro  s Sc=RtnObj.Err(-1,"","插入附加表失败!") q
	.e  s RowId=$G(%ROWID)
	e  d
	.i AuditDate=""  tro  s Sc=RtnObj.Err(-1,"","请求方尚未审核!","",0) q
	.i AuditDateProv'=""  tro  s Sc=RtnObj.Err(-1,"","已经审核","",0) q
	q:RtnObj.success'=0 RtnObj.Json()
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Req,"RA","RQ")
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Req,"RD","RQ")

	s RtnObj=..CancelComp(Req,"P")
	i RtnObj.success'=0  tro  q RtnObj.Json()
	
	s Param=..sssParamStr()
	//处理请领单 movestatus - zhwh 2014-08-2
	s MoveStatus="EAN"  //reqloc audited
	s Ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,$zn,User,Param)
	i Ret<0 tro  s Sc=RtnObj.Err(-2,"","")
	i RtnObj.success'=0  q RtnObj.Json()
	tcommit
	
	q RtnObj.Json()
}

/// 取审核状态
/// Author:zhwh
/// Date:2014-01-7
/// Return:
///  0 -未经任何审核
///  1 - 请求方审核
///  2 -供应方审核
ClassMethod AuditStatus(req As %String) As %String
{
	n (req)
	s ret=0
	&sql(select INRQ_AuditDate,INRQ_AuditDate_Prov into :d,:dp from dhc_inrequest where inrq_inrq_dr=:req)	
	q:SQLCODE ret
	i d'="" s ret=1
	i dp'="" s ret=2
	q ret
}

/// Descript:根据药品id取药品采购默认信息
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:	
/// Return：供应商id^供应商名称^产地id^产地名称^配送商id^配送商名称^入库单位id
/// ^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
/// w ##class(web.DHCSTMHUI.INRequest).GetItmInfo(534,274)
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s GroupId=$p(Params,"^",1)
	s LocId=$p(Params,"^",2)
	s UserId=$p(Params,"^",3)
	s Uom=$p(Params,"^",4)  //库存项单位
	s frLoc=$p(Params,"^",5)  //供应科室
	
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigManf(IncId,..%GetParameter("AppName"),ParamStr)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",2)
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s UomDesc=""
	i Uom="" s Uom=PurUomId,UomDesc=PurUomDesc
	e  d
	.i Uom=BUomId s UomDesc=BUomDesc
	.i Uom=PurUomId s UomDesc=PurUomDesc
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(IncId,Uom,HospId)
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$h,Uom,HospId)
	s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,Uom,+$h)
	s QtyInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,Uom)
	s MinQty=$p(QtyInfo,"^",1)
	s MaxQty=$p(QtyInfo,"^",2)
	s GoodName=""
	s incil="",repLev=0
	s:frLoc="" frLoc=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(IncId,LocId),"^",1)
	s:frLoc'="" incil=$o(^INCI("IL_LOC",frLoc,IncId,""))
	s:incil'="" repLev=$p(^INCI(IncId,"IL",incil),"^",5)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUomId)
	s:Uom'=BUomId repLev=repLev/Fac
	s LimitAmtStr=##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtStr(LocId,IncId)
	s LimitType=$p(LimitAmtStr,"^",1)
	s ReqAmt=$p(LimitAmtStr,"^",2)
	s LeftAmt=$p(LimitAmtStr,"^",3)
	s ProLocAllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(frLoc,IncId,Uom) ;取供应科室物资库存项当前可用库存
	s Data=ManfId_"^"_ManfDesc_"^"_Uom_"^"_UomDesc_"^"_Rp_"^"_Sp_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_GoodName_"^"_repLev_"^"_LimitType_"^"_ReqAmt_"^"_LeftAmt_"^"_ProLocAllAvaQty
	q Data
}

/// Descript: 库房拒绝临床科室申领计划
/// Creater: taosongrui
/// CreateDate: 2014-8-18
/// Table:
/// Input: 请求单id,请求单id...
/// Output: 
/// Return：0~拒绝成功  -1~请求单已部分转移  非0且非-1,请求单id~未拒绝成功  
/// w ##class(web.DHCSTMHUI.INRequest).ProvLocDeny("3568,3570,3571") 
ClassMethod ProvLocDeny(reqs As %String) As %Library.String
{
	n (reqs)
	s ret=0
	f i=1:1:$l(reqs,",") q:ret'=0  d
	.s req=$P(reqs,",",i)
	.s TransferStatus=##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(req)
	.i TransferStatus="1" d
	..s ret=-1
	.e  d 
	..&sql(UPDATE DHC_INRequest SET INRQ_PreFlag='Y' WHERE INRQ_INRQ_DR=:req)
	..i SQLCODE'=0 s ret=req
	q ret
}

/// /根据原始申购计划  查询拆分后的单据
ClassMethod QueryRelate(Start As %String, Limit As %String, Req As %String) As %String
{
	n (Start,Limit,Req)
	s sql="select INRQ_INRQ_DR req,"
	s sql=sql_"INRQ_INRQ_DR->inrq_recloc_dr toLoc,"
	s sql=sql_"INRQ_INRQ_DR->inrq_recloc_dr->ctloc_Desc toLocDesc,"
	s sql=sql_"INRQ_INRQ_DR->inrq_reqloc_dr frLoc,"
	s sql=sql_"INRQ_INRQ_DR->inrq_reqloc_dr->ctloc_desc frLocDesc,"
	s sql=sql_"INRQ_INRQ_DR->inrq_ssusr_dr reqUser,"
	s sql=sql_"INRQ_INRQ_DR->inrq_ssusr_dr->ssusr_name userName,"
	s sql=sql_"INRQ_INRQ_DR->inrq_date d,"
	s sql=sql_"INRQ_INRQ_DR->inrq_time t,"
	s sql=sql_"INRQ_INRQ_DR->inrq_status reqStatus,"
	s sql=sql_"INRQ_INRQ_DR->inrq_usercompleted comp,"
	s sql=sql_"INRQ_INRQ_DR->INRQ_No reqNo, "
	s sql=sql_"INRQ_INRQ_DR->INRQ_Remarks remark "
	s sql=sql_" from DHC_INRequest "
	s sql=sql_" where INRQ_RelateReq_DR="_Req
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count = 0
	while (xrs.Next())
	{
		s req=xrs.Data("req")
		s toLoc=xrs.Data("toLoc")
		s toLocDesc=xrs.Data("toLocDesc")
		s frLoc=xrs.Data("frLoc")
		s frLocDesc=xrs.Data("frLocDesc")
		s date=xrs.Data("d")
		i date'="" s date=..DL2H(date)
		s time=xrs.Data("t")
		i time'="" s time=..TL2H(time)
		s reqNo=xrs.Data("reqNo")
		s comp=xrs.Data("comp")
		s remark=xrs.Data("remark")		//备注
		s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s remark=$LTS(remark,memoDelim)
		s tmp=req_"^"_toLoc_"^"_toLocDesc_"^"_frLoc_"^"_frLocDesc_"^"_date_"^"_time_"^"_reqNo_"^"_remark_"^"_comp
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d xrs.Close()
	d json.getJsonData("req^toLoc^toLocDesc^frLoc^frLocDesc^date^time^reqNo^remark^comp",count)
	k json
}

/// 2016-04-15 获取请求单高值标志
ClassMethod GetReqHVFlag(req As %String) As %String
{
	n (req)

	s HVFlag="N"
	s ch=0
	f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(HVFlag="Y")  d
	.s inci=$P(^INRQ(req,"RQI",ch),"^",4)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	q HVFlag
}

/// Descript:根据手术安排ID取req
/// Creater: xuchao
/// CreateDate: 2016-12-26
/// Table:
/// Input: 
/// Output: 
/// Return：0~拒绝成功  -1~请求单已部分转移  非0且非-1,请求单id~未拒绝成功  
/// w ##class(web.DHCSTMHUI.INRequest)GetReqByOpaId("71674") 
ClassMethod GetReqByOpaId(opaId As %String) As %Library.String
{
	n (opaId)
	s req=""
	&sql(select INRQ_INRQ_DR into :req from DHC_INRequest where INRQ_ANArrDR=:opaId)
 	q req
}

/// Descript:	根据请求单设置供应部门在途数
/// Creator:	wangjiabin
/// CreateDate:	2017-03-24
/// Input:		请求单rowid, sign(1:加在途,0:减在途)
/// Output:		0:成功, 其他:失败
/// w ##class(web.DHCSTMHUI.INRequest).HandleResQty(4381,1)
ClassMethod HandleResQty(inrq As %String, sign As %String) As %Library.String
{
	n (inrq,sign)
	q:inrq="" ""
	q:sign="" ""
	s SupplyLoc=$p(^INRQ(inrq),"^",5)
	
	s err=0
	ts
	s ch=0
	f  s ch=$o(^INRQ(inrq,"RQI",ch)) q:(ch="")||(err'=0)  d
	.s inrqi=inrq_"||"_ch
	.s inci=$p(^INRQ(inrq,"RQI",ch),"^",4)
	.s il=$o(^INCI("IL_LOC",SupplyLoc,inci,0))
	.q:il'>0
	.s incil=inci_"||"_il
	.s qty=$p(^INRQ(inrq,"RQI",ch),"^",3)
	.s uom=$p(^INRQ(inrq,"RQI",ch),"^",5)
	.s buom=$p(^INCI(inci,1),"^",10)
	.s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s:sign=0 qty=-qty
	.
	.s qtyBuom=qty*uomFac
	.s ret=..HandleItmResQty(inrqi,qtyBuom)
	.i ret'=0 s err=-1
	.
	i err'=0 tro  q err
	tc
	q 0
}

/// Descript:	根据请求单明细供应部门在途数
/// Creator:	wangjiabin
/// CreateDate:	2017-03-24
/// Input:		inrqi, 数量(基本单位)
/// Output:		0:设置成功, 其他:失败
ClassMethod HandleItmResQty(inrqi As %String, qtyBuom As %String) As %String
{
	n (inrqi,qtyBuom)
	q:inrqi="" ""
	
	s inrq=$p(inrqi,"||",1),ch=$p(inrqi,"||",2)
	s SupplyLoc=$p(^INRQ(inrq),"^",5)
	s RecLoc=$p(^INRQ(inrq),"^",6)
	s dhcInrq=$o(^DHCINRQ(0,"INRQ",inrq,""),-1)
	s inrqType=$s(dhcInrq'="":$p(^DHCINRQ(dhcInrq),"^",1),1:"")
	;申领计划(供应方=请求方)不设置在途
	q:(SupplyLoc=RecLoc)||(inrqType="C") 0
	
	s HospId=$p(^CTLOC(SupplyLoc),"^",22)
	s Param="^"_SupplyLoc_"^^"_HospId
	s AppName=..%GetParameter("AppName")
	;供应方是否设置在途的参数
	s SetReserverdQty=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SetReserverdQty",Param)
	q:(qtyBuom>0)&&(SetReserverdQty'="Y") 0
	
	s inci=$p(^INRQ(inrq,"RQI",ch),"^",4)
	s il=$o(^INCI("IL_LOC",SupplyLoc,inci,0))
	q:il'>0 0
	s incil=inci_"||"_il
	s uom=$p(^INRQ(inrq,"RQI",ch),"^",5)
	s buom=$p(^INCI(inci,1),"^",10)
	s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qty=qtyBuom/uomFac	;qty单位和请求单一致
	
	s dhcInrqi=$o(^DHCINRQI(0,"INRQI",inrqi,""),-1)
	i dhcInrqi="" d
	.s obj=##class(User.DHCINReqItm).%New()
	.d obj.INRQIINRQIDRSetObjectId(inrqi)
	e  d
	.s obj=##class(User.DHCINReqItm).%OpenId(dhcInrqi)
	
	s reqQty=##class(web.DHCSTMHUI.INReqItm).GetApprovedQty(inrqi)
	s reserverdQty=obj.INRQIReservedQty
	i reserverdQty+qty<0 s qty=-reserverdQty	;避免出现负数
	i reserverdQty+qty>reqQty s qty=reqQty-reserverdQty	;避免出现大于请求数量的情况
	i +qty=0 k obj q 0		;qty=0时,过滤
	
	ts
	s obj.INRQIReservedQty=reserverdQty+qty
	s sc=obj.%Save()
	i $$$ISERR(sc) tro  q -1
	
	s qtyBuom=qty*uomFac
	s AvaQtyBUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(SupplyLoc,inci,buom)
	i (qtyBuom<0)&&(qtyBuom>AvaQtyBUom) tro  q -10
	;s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateResQty(incil,qtyBuom)
	;i ret'=0 tro  q -2
	s ReservedObj={}
	s ReservedObj.Type="Inrqi",ReservedObj.Pointer=inrqi,ReservedObj.Incil=incil,ReservedObj.Qty=qtyBuom
	s ReservedParams=ReservedObj.%ToJSON()
	s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	i RtnObj.success<0 tro  q -2
	tc
	q 0
}

/// Description:获取请求单的一些信息(如数量合计,金额合计等)
/// Creator:	wangjiabin
/// CreateDate:	2020-09-02
/// Input:		请求单Id
/// Output:		Json型数据
/// w ##class(web.DHCSTMHUI.INRequest).GetReqData(85)
ClassMethod GetReqData(RowId) As %String
{
	n (RowId)
	s ReqLocId=$p(^INRQ(RowId),"^",5)
	s ReqDate=$p(^INRQ(RowId),"^",2)
	s HospId=$p(^CTLOC(ReqLocId),"^",22)
	s (SumQty,SumRpAmt,SumSpAmt)=0
	s Ch=0
	f  s Ch=$o(^INRQ(RowId,"RQI",Ch)) q:Ch=""  d
	.s Inrqi=RowId_"||"_Ch
	.s DHCInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,0))
	.q:DHCInrqi=""
	.
	.s Inci=$p(^INRQ(RowId,"RQI",Ch),"^",4)
	.s UomId=$p(^INRQ(RowId,"RQI",Ch),"^",5)
	.s QtyApproved=$p(^DHCINRQI(DHCInrqi),"^",3)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,UomId,HospId)
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,ReqDate,UomId,HospId)
	.s RpAmt=Rp*QtyApproved
	.s SpAmt=Sp*QtyApproved
	.
	.s SumQty=SumQty+QtyApproved
	.s SumRpAmt=SumRpAmt+RpAmt
	.s SumSpAmt=SumSpAmt+SpAmt
	
	s TitleStr="SumQty^SumRpAmt^SumSpAmt"
	s DataStr=SumQty_"^"_SumRpAmt_"^"_SumSpAmt
	s Str=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Str
}

/// 库存请求单物资名称模糊查询
/// Author: litongxun
/// Date: 20210317
/// Return:	0~包含;1~不包含
/// w ##class(web.DHCSTMHUI.INRequest).CheckInciDesc(11,11)
ClassMethod CheckInciDesc(Inreq As %String, InciDesc As %String, inci As %String = "") As %String
{
	n (Inreq,InciDesc,inci)
	s err=1
	s Ch=0
	f  s Ch=$o(^INRQ(Inreq,"RQI",Ch)) q:(Ch="")||(err=0)  d
	.s Inci=$p(^INRQ(Inreq,"RQI",Ch),"^",4)
	.s:(inci'="")&&(inci=Inci) err=0
	.s Desc=$p(^INCI(Inci,1),"^",2)
	.s:(InciDesc'="")&&(Desc[InciDesc) err=0
	q err
}

/// 设置请求单明细的批准数量缺省等于请求数量
/// Author:zhwh
/// Date:2014-02-24
/// Arguments:
///  inrqi - rowid of in_request
/// Return:
///   0 - sucess
///   <0 - failure
ClassMethod SetDefaultQtyApproved(inrq)
{
	n (inrq)

	s err=0
	s ch=0
	f  s ch=$O(^INRQ(inrq,"RQI",ch)) q:(ch="")!(err<0 )  d
	.s inrqi=inrq_"||"_ch
	.s qty=$p(^INRQ(inrq,"RQI",ch),"^",3)  //请求数量
	.&sql(select %id into :dhcinrqi from dhc_inreqitm where inrqi_inrqi_dr=:inrqi)
	.i SQLCODE d
	..&sql(insert into dhc_inreqitm(inrqi_inrqi_dr) values (:inrqi) )
	..i SQLCODE'=0 s err=-2 q 
	..s dhcinrqi=$g(%ROWID)
	.q:err<0 
	.i dhcinrqi'="" d
	.. &sql(update dhc_inreqitm set inrqi_qtyapproved=:qty where inrqi_rowid=:dhcinrqi)  //缺省批准数量
	.. i SQLCODE'=0 s err=-3 q
	.q:err<0
	.
	q err
}

/// 获取请求单明细的类组串(^隔开)
/// Author:	wxj
/// Date:	2023-04-10
/// Input:ReqId - 请求单单RowId
/// Return:
ClassMethod GetReqDetailScg(ReqId As %String) As %String
{
	n (ReqId)
	q:ReqId="" ""
	s result=""
	s ch=0
	f  s ch=$o(^INRQ(ReqId,"RQI",ch)) q:ch=""  d
	.s inci=$p(^INRQ(ReqId,"RQI",ch),"^",4)
	.s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
	.i result="" d
	..s result=scg
	.e  i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(result,scg,"^")=0 d
	..s result=result_"^"_scg
	
	q result
}

}
