Import sqluser

/// CreatDate:	2019.10.15
/// Description:回收申请
/// Table:		CSSD_PackageApply
Class web.CSSDHUI.Apply.PackageApply Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Description:查询回收单据信息
/// 			ps:润乾打印也使用此Query(RowId传入时,不使用其他变量过滤)
/// call web_CSSDHUI_Apply.PackageApply_SelectAll("{}",1)
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.PackageApply","SelectAll","{""FSupLoc"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FReqLoc"":"""",""FStartDate"":""2023-04-19"",""FEndDate"":""2023-04-20"",""LineCode"":"""",""SterType"":""1"",""ReqType"":""0,4,5"",""ReqLevel"":"""",""FReqNo"":"""",""DateType"":1,""ReqStatus"":5,""IsCallBackAll"":""N""}","")
Query SelectAll(Params As %String, ID = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,ReqType,ReqTypeDesc,ReqLevel,ReqLevelDesc,LocRowId,ReqLocDesc,SupRowId,SupLocDesc,ReqFlag,commitUser,commitDate,ReqDate,RefuseReason,CreateDate,CreateUser,PackClassDr,PackClassDrDesc,BeInfected,DispStatus") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String, ID = "") As %Status
{
	n (qHandle,Params,ID,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s FReqLoc=PJObj.%Get("FReqLoc")
	s FSupLoc=PJObj.%Get("FSupLoc")
	s FStartDate=PJObj.%Get("FStartDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s FReqType=PJObj.%Get("ReqType")				;用逗号隔开类型串
	s PReqLevel=PJObj.%Get("ReqLevel")
	s DateType=PJObj.%Get("DateType")				;日期类型
	s FReqNo=PJObj.%Get("FReqNo")
	s PReqStatus=PJObj.%Get("ReqStatus")			;单据状态, 逗号隔开
	s PLineId=PJObj.%Get("LineCode")
	s PRowId=PJObj.%Get("ApplyRowIds")
	s IsCallBackAll=PJObj.%Get("IsCallBackAll")		;是否全部回收
	s FSterTypeId=PJObj.%Get("SterType")
	q:(ID="")&&((FStartDate="")||(FEndDate="")) $$$OK

	;兼容报表传递ID字段
	i ID'="" s PRowId=ID

	s:DateType="" DateType=1
	s FStartDate=..DH2L(FStartDate)
	s FEndDate=..DH2L(FEndDate)
	q:(ID="")&&((FStartDate="")||(FEndDate="")) $$$OK
	s LineLocStr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLocByLine(PLineId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID As RowId,CSSDPA_NO,CSSDPA_Type,CSSDPA_IsBack,CSSDPA_ReqLevel,CSSDPA_LOCDR,"
		_"CSSDPA_BackDateTime,CSSDPA_Flag,CSSDPA_IsSend,CSSDPA_SendDateTime,CSSDPA_UseDate,"
		_"CSSDPA_APPLYUSERDR,CSSDPA_DATE,CSSDPA_APPLYUSERDR->SSUSR_Name, CSSDPA_APPLYLOCDR,"
		_"CSSDPA_CreateDate as CreateDate,"
		_"CSSDPA_CreateUser->SSUSR_Name as CreateUser,CSSDPA_SenderDR->SSUSR_Name as sendname,"
		_"CSSDPA_RefuseReason,CSSDPA_PackageClassDr,CSSDPA_PackageClassDr->CSSDPC_PackClassName as PackClassName,"
		_"CSSDPA_SubmitDate,CSSDPA_SubmitTime,CSSDPA_BeInfected "
		_" from CSSD_PackageApply "
	i PRowId'="" d
	.s SqlStr=SqlStr_" where ID in ("_PRowId_")"
	e  d
	.s SqlStr=SqlStr_" where CSSDPA_CreateDate between "_FStartDate_" AND "_FEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		s No=Result.Data("CSSDPA_NO")
		s ReqType=Result.Data("CSSDPA_Type")			;请领类型
		s ReqLevel=Result.Data("CSSDPA_ReqLevel")		;紧急程度
		s commitUser=Result.Data("SSUSR_Name")			;提交人
		s commitDate=Result.Data("CSSDPA_SubmitDate")
		s SubmitTime=Result.Data("CSSDPA_SubmitTime")
		s LocRowId=Result.Data("CSSDPA_APPLYLOCDR")
		s SupRowId=Result.Data("CSSDPA_LOCDR")
		s ReqFlag=Result.Data("CSSDPA_Flag")
		s UseDate=Result.Data("CSSDPA_UseDate")
		s RefuseReason=Result.Data("CSSDPA_RefuseReason")
		s CreateUser=Result.Data("CreateUser")
		s PackClassDr=Result.Data("CSSDPA_PackageClassDr")
		s PackClassDrDesc=Result.Data("PackClassName")
		s BeInfected=Result.Data("CSSDPA_BeInfected")
		s CreateDate=Result.Data("CreateDate")
		s CBAllFlag=##class(web.CSSDHUI.CallBack.CallBack).IsCallBackAll(RowId)

		continue:LocRowId=""
		continue:SupRowId=""
		continue:(PRowId="")&&(FReqLoc'="")&&(FReqLoc'=LocRowId)
		continue:(PRowId="")&&(FSupLoc'="")&&(FSupLoc'=SupRowId)
		continue:(PRowId="")&&(PReqStatus'="")&&((","_PReqStatus_",")'[(","_ReqFlag_","))	//过滤单据状态
		continue:(PRowId="")&&(FReqNo'="")&&(No'[FReqNo)
		continue:(PRowId="")&&(FReqType'="")&&((","_FReqType_",")'[(","_ReqType_","))
		continue:(PRowId="")&&(PReqLevel'="")&&(PReqLevel'=ReqLevel)
		continue:(PRowId="")&&(IsCallBackAll="N")&&(CBAllFlag=0)
		continue:(PRowId="")&&(IsCallBackAll="Y")&&(CBAllFlag'=0)
		s Flag=##class(web.CSSDHUI.Apply.PackageApply).IFSterTypeInApplyDetail(RowId,FSterTypeId)
		continue:(FSterTypeId'="")&&(Flag="N")
		
		continue:(PRowId="")&&(DateType=1)&&((commitDate="")||((FStartDate'="")&&(FStartDate>commitDate)))
		continue:(PRowId="")&&(DateType=1)&&((commitDate="")||((FEndDate'="")&&(FEndDate<commitDate)))
		continue:(PRowId="")&&(DateType=2)&&(UseDate'="")&&((FStartDate'="")&&(FStartDate>UseDate))
		continue:(PRowId="")&&(DateType=2)&&(UseDate'="")&&((FEndDate'="")&&(FEndDate<UseDate))
		continue:(PRowId="")&&(LineLocStr'="")&&(LineLocStr'[("^"_LocRowId_"^"))

		s ReqTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(ReqType)
		s ReqLevelDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqLevelDesc(ReqLevel)
		s commitUser=..%FieldTranslate("User.SSUser","SSUSRName",commitUser)
		s commitDateNew=..DL2H(commitDate)
		s commitDateTime=..TL2H(SubmitTime)
		s commitDate=commitDateNew_" "_commitDateTime

		s ReqLocDesc=..sssLocDesc(LocRowId)
		s SupLocDesc=..sssLocDesc(SupRowId)
		s CreateDate=..DL2H(CreateDate)
		s ReqDate=..DL2H(UseDate)
		s CreateUser=..%FieldTranslate("User.SSUser","SSUSRName",CreateUser)

		s DispStatus=..GetDispStatus(RowId)
		i DispStatus=1 s DispStatus=..%Translate($CLASSNAME(),"已发放")
		e  i DispStatus=2 s DispStatus=..%Translate($CLASSNAME(),"部分发放")
		e  s DispStatus=..%Translate($CLASSNAME(),"未发放")

		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,No,ReqType,ReqTypeDesc,ReqLevel,ReqLevelDesc,LocRowId,ReqLocDesc,
		SupRowId,SupLocDesc,ReqFlag,commitUser,commitDate,ReqDate,RefuseReason,CreateDate,CreateUser,
		PackClassDr,PackClassDrDesc,BeInfected,DispStatus)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:2019.11.05
/// Description:保存请领主表
/// Input:新增单据的数据
/// w ##class(web.CSSDHUI.Apply.PackageApply).jsSave("[{""LocRowId"":""1"",""ReqLocDesc"":""内科普通门诊"",""SupRowId"":""382"",""SupLocDesc"":""消毒供应室"",""ReqType"":"""",""ReqLevel"":"""",""ReqDate"":""""}]","{""FromLoc"":""382"",""CreateUser"":""6461""}")
ClassMethod jsSave(Params, MainParams) As %Library.String
{
	n (%session,Params,MainParams)
	s $ZT=..sssError()
	ts
	s RtnObj=..Save(Params,MainParams)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 回收申请制单
/// ##class(web.CSSDHUI.Apply.PackageApply).Save
ClassMethod Save(Params, MainParams) As web.CSSDHUI.RtnObj
{
	n (%session,Params,MainParams)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	s MainPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MainPJObj.%FromJSON(MainParams)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	s CreateUser=MainPJObj.%Get("CreateUser")
	s FromLoc=MainPJObj.%Get("FromLoc")

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))

	s ApplyRowIds=""
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s ReqLoc=Obj.%Get("LocRowId")
		s reqlevel=Obj.%Get("ReqLevel")
		s ReqDate=Obj.%Get("ReqDate")
		s PkgClassDr=Obj.%Get("PackClassDr")
		s DeptCenter=Obj.%Get("SupRowId")
		s type=Obj.%Get("ReqType")

		s ret=..sssLock("Apply")
		i ret'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"生成请领单号加锁失败！"))
		q:RtnObj.success'=0
		i RowId="" d
		.s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Apply")
		.i No="" d ..sssUnLock("Apply") d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"生成请领单号失败！"))
		q:RtnObj.success'=0

		i DeptCenter="" s DeptCenter=FromLoc

		s usedate=+$h
		s:ReqDate'="" usedate=..DH2L(ReqDate)
		s Flag=0
		i type="" s type=0
		i reqlevel="" s reqlevel=0
		s CreateDate=+$h

		i ReqLoc=DeptCenter d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"请领科室和供应科室不能相同"))
		q:RtnObj.success'=0
		i ReqLoc="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"请领科室不能为空"))
		q:RtnObj.success'=0
		i usedate<+$h d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"需求日期不能早于当前日期"))
		q:RtnObj.success'=0

		;检查科室所在线路是否在允许时间段内
		s PermitFlag=##class(web.CSSDHUI.System.SendRoadLine).CheckLocTime(ReqLoc,$p($h,",",2),DeptCenter)
		i PermitFlag.success'=0 d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),PermitFlag.msg))
		q:RtnObj.success'=0

		i RowId="" d
		.s ApplyObj=##class(User.CSSDPackageApply).%New()
		.s ApplyObj.CSSDPANO=No
		e  d
		.s ApplyObj=##class(User.CSSDPackageApply).%OpenId(RowId)
		.d ApplyObj.%Reload()
		d ApplyObj.CSSDPAAPPLYLOCDRSetObjectId(ReqLoc)
		s ApplyObj.CSSDPAReqLevel=reqlevel
		s ApplyObj.CSSDPAUseDate=usedate
		s ApplyObj.CSSDPAFlag=Flag
		s ApplyObj.CSSDPAType=type
		d ApplyObj.CSSDPALOCDRSetObjectId(DeptCenter)
		d ApplyObj.CSSDPACreateUserSetObjectId(CreateUser)
		d ApplyObj.CSSDPAPackageClassDrSetObjectId(PkgClassDr)
		s ApplyObj.CSSDPACreateDate=CreateDate
		s Sc=ApplyObj.%Save()
		i $$$ISERR(Sc) d
		.d ..sssUnLock("Apply")
		.d RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"保存失败!"))
		q:RtnObj.success'=0

		d ..sssUnLock("Apply")
		s RowId=ApplyObj.%Id()

		i ApplyRowIds="" s ApplyRowIds=RowId
		e  s ApplyRowIds=ApplyRowIds_","_RowId
	}
	s RtnObj.rowid=ApplyRowIds
	q RtnObj
}

/// CreatDate:2019.11.05
/// Description:删除请求单
/// Table:CSSD_PackageApply, CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.Apply.PackageApply).jsDelete("{""RowIdStr"":""203^205^206^207^212^213^214^215""}")
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()

	tc
	q RtnObj.Json()
}

ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))

	s MainObj=##Class(User.CSSDPackageApply).%OpenId(RowId)
	i '$IsObject(MainObj) q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"单据不存在,请刷新核实!"))
	d MainObj.%Reload()
	s Flag=MainObj.CSSDPAFlag
	i Flag'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"只有未提交单据可以删除"))

	&sql(Delete FROM CSSD_PackageApplyDetail where CSSDPAD_Parref=:RowId)
	i SQLCODE<0 q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除明细失败!"))

	&sql(Delete FROM CSSD_PackageApply where ID=:RowId)
	i SQLCODE<0 q RtnObj.Err(-5,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))

	q RtnObj
}

/// CreatDate:2019.11.05
/// Description:提交请求单
/// Table:CSSD_PackageApply
/// w ##class(web.CSSDHUI.Apply.PackageApply).jsSubmitOrder(^tmpoooo)
ClassMethod jsSubmitOrder(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SubmitOrder(Params)
	q RtnObj.Json()
}

ClassMethod SubmitOrder(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败！"))

	s gUser=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s mainRowId=PJObj.%Get("mainRowId")
	i mainRowId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))

	s MainObj=##Class(User.CSSDPackageApply).%OpenId(mainRowId)
	i '$IsObject(MainObj) q RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"入参错误！"))
	d MainObj.%Reload()
	s No=MainObj.CSSDPANO
	s Flag=MainObj.CSSDPAFlag
	s ReqType=MainObj.CSSDPAType
	s ReqLevel=MainObj.CSSDPAReqLevel
	s ApplyLocDr=MainObj.CSSDPAAPPLYLOCDR.%Id()
	s ApplyLocDesc=MainObj.CSSDPAAPPLYLOCDR.CTLOCDesc
	s SupplyLocDr=MainObj.CSSDPALOCDR.%Id()
	;检查科室所在线路是否在允许时间段内
	s PermitFlag=##class(web.CSSDHUI.System.SendRoadLine).CheckLocTime(ApplyLocDr,$p($h,",",2),SupplyLocDr)
	i PermitFlag.success'=0 q RtnObj.Err(-6,"",..%Translate($CLASSNAME(),PermitFlag.msg))

	i Flag'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"只有未提交单据可以提交！"))

	s DetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",mainRowId,""))
	i DetailId="" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"无明细不能提交！"))

	s DetailQty=0
	s DetailQtyId=$o(^User.CSSDPackageApplyDetailI("CSSDPADApplyNoReqQtyIndex",mainRowId,DetailQty,""))
	i DetailQtyId'="" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"提交单据存在请领数量为0的消毒包，不能提交！"))

	s etime=$P($h,",",2)
	s edate=$P($h,",",1)
	s InfectFlag=..GetApplyDetailInfectSign(mainRowId)

	s Message=..%Translate($CLASSNAME(),"消息通知:")_ApplyLocDesc_..%Translate($CLASSNAME(),"申请了")_No

	s Param=gGroupId_"^"_gLocId_"^"_gUser_"^"_gHospId
	s AutAuditAfterSub=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDAPPLAY","AutAuditAfterSub",Param)
	s SetRecLoc=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDAPPLAY","SetRecLoc",Param)
	s IsCreateCallBack=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsCreatCallBack",Param)
	s:((ReqType=1)||(ReqType=2)) AutAuditAfterSub="Y"	//借包单、非循环包申请单提交时自动确认


	ts
	//提交主表数据，更新字段
	&sql(Update CSSD_PackageApply set CSSDPA_APPLYUSERDR=:gUser,CSSDPA_Flag=1,
		CSSDPA_SubmitDate=:edate,CSSDPA_SubmitTime=:etime,CSSDPA_BeInfected=:InfectFlag
		WHERE ID=:mainRowId)
	i SQLCODE'=0 q RtnObj.Err(-4,mainRowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))

	i AutAuditAfterSub="Y" d	//默认自动确认
	.s RtnObj=..autAuditAfterSub(Params,mainRowId,ReqType)
	i RtnObj.success<0 tro  q RtnObj

	//借包单、非循环包申请单提交时，默认往回收表插入数据
	i ((ReqType=1)||(ReqType=2)) d
	.s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).CreateCallBackByBorrow(mainRowId)
	i RtnObj.success<0 tro  q RtnObj

	//插入科室配置表
	i SetRecLoc="Y" d
	.s RtnObj=##class(web.CSSDHUI.System.BindLoc).UpdateBindLoc(ApplyLocDr,"RecLoc",SupplyLocDr)
	i RtnObj.success<0 tro  q RtnObj

	//自动生成回收单
	i ((ReqType=0)||(ReqType=4))&&(AutAuditAfterSub="Y")&&(IsCreateCallBack="Y") d
	.s ApplyDetails=##Class(web.CSSDHUI.Apply.ApplyCheck).GetApplyDetails(mainRowId)
	.s RtnObj=##Class(web.CSSDHUI.CallBack.CallBack).CreateCallBackByApply(Params,ApplyDetails)
	i RtnObj.success<0 tro  q RtnObj

	tc
	d ##class(web.CSSDHUI.Common.UtilCommon).PushMessageApplyToSupply(ReqType,ReqLevel,ApplyLocDr,gUser,SupplyLocDr,Message)
	q RtnObj
}

/// CreatDate:2019.11.05
/// Description:撤销请求单
/// Table:CSSD_PackageApply
/// w ##class(web.CSSDHUI.Apply.PackageApply).jsCancelOrder(^bintmp(379))
ClassMethod jsCancelOrder(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CancelOrder(Params)
	q RtnObj.Json()
}

ClassMethod CancelOrder(Params As %String) As %Library.String
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败！"))

	s mainRowId=PJObj.%Get("mainRowId")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	i mainRowId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))

	s MainObj=##Class(User.CSSDPackageApply).%OpenId(mainRowId)
	i '$IsObject(MainObj) q RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"入参错误！"))
	d MainObj.%Reload()
	s Flag=MainObj.CSSDPAFlag
	s IsCount=MainObj.CSSDPAIsCount  ;回收汇总
	s ReqType=MainObj.CSSDPAType

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s autAuditAfterSub=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDAPPLAY","AutAuditAfterSub",Param)
	s IsCreateCallBack=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsCreatCallBack",Param)

	;(是否自动生成Flag)只有一个回收单 && 回收单未提交 && 全部回收明细都对应
	;自动生成Flag && 参数设置自动生成, 则允许撤销回收申请
	s AutoCBFlag=""		;注意""和"N"的区别
	i (autAuditAfterSub'="Y")||(IsCreateCallBack'="Y") s AutoCBFlag="N"
	s ApplyCBCount=0
	s CBId=0
	f  s CBId=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",mainRowId,CBId)) q:(CBId="")||(AutoCBFlag="N")  d
	.s ApplyCBCount=ApplyCBCount+1
	.i ApplyCBCount>1 s AutoCBFlag="N" q
	.s CompFlag=$lg(^User.CSSDPackageCallbackD(CBId),14)
	.i CompFlag="Y" s AutoCBFlag="N"
	i ApplyCBCount'=1 s AutoCBFlag="N"
	i AutoCBFlag="" d
	.s AutoCBFlag="Y"			;仅所有明细 回收数量=申请数量, 此值才设置为Y
	.s ApplyItmId=0
	.f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",mainRowId,ApplyItmId)) q:(ApplyItmId="")||(AutoCBFlag="N")  d
	..s CBQty=$lg(^User.CSSDPackageApplyDetailD(ApplyItmId),8)
	..s ApplyQty=$lg(^User.CSSDPackageApplyDetailD(ApplyItmId),11)
	..i CBQty'=ApplyQty s AutoCBFlag="N" q

	i autAuditAfterSub="N"  d
	.i Flag'=1 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"只有提交状态单据可以撤销！"),"",0) q
	.i IsCount'="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"已经进行回收汇总不能撤销！"),"",0) q
	e  d
	.i Flag=3 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"已经发放的单据不能撤销！"),"",0) q
	.i Flag=6 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"已经接收的单据不能撤销！"),"",0) q
	.i (AutoCBFlag'="Y")&&(IsCount'="") d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"已经进行回收汇总不能撤销！"),"",0) q
	q:RtnObj.success'=0 RtnObj

	s ApplyItmId=0
	f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",mainRowId,ApplyItmId)) q:ApplyItmId=""  d
	.s CBItm=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,""))
	.q:CBItm=""
	.s DispQty=$lg(^User.CSSDCallbackDetailNewD(CBItm),5)
	.i +DispQty>0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"该申请已发放,不可撤销!"),"",0) q
	.s PackId=$o(^User.CSSDPackagePackI("CallBackDetail",CBItm,""))
	.i PackId d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"该申请已打包,不能撤销!"),"",0) q
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update cssd_packageapply set CSSDPA_Flag=0 ,CSSDPA_APPLYUSERDR=null,
		CSSDPA_DATE=null,CSSDPA_SubmitDate=null,CSSDPA_SubmitTime=null,CSSDPA_BeInfected='N' where ID=:mainRowId)
	i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"撤销更新请领数据失败!"))
	i RtnObj.success'=0 tro  q RtnObj

	;前面已经判断,最多仅存在一个回收单
	s CallBackRowid=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",mainRowId,""))
	i CallBackRowid'="" d
	.i ((ReqType=1)||(ReqType=2)) d
	..&sql(Delete FROM CSSD_PackageCallBack WHERE CSSDPC_PackageApplyDR=:mainRowId)
	..i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"删除回收主表失败!")) q
	..&sql(Delete FROM CSSD_CallBackDetailNew WHERE CSSDCD_Parref_DR=:CallBackRowid)
	..i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"删除回收明细表失败!")) q
	.e  i (autAuditAfterSub="Y")&&(AutoCBFlag="Y") d
	..s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).Delete(CallBackRowid)

	i RtnObj.success'=0 tro  q RtnObj

	tc
	q RtnObj
}

/// CreatDate:2019.8.30
/// Description:提交是否默认审核
/// Table:CSSD_PackageApply
/// d ##class(web.CSSDHUI.Apply.PackageApply).jsAudit
ClassMethod autAuditAfterSub(Params As %String, mainRowId As %String, ReqType As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params,mainRowId,ReqType)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	&sql(update CSSD_PackageApply set CSSDPA_Flag=5 where ID=:mainRowId)
	i SQLCODE'=0 q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"默认自动确认失败!"))

	q RtnObj
}

/// Description:更新主表感染标志
ClassMethod ChangeInfectedFlag(ApplyId)
{
	n (%session,ApplyId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Flag=..GetApplyDetailInfectSign(ApplyId)
	
	s ApplyObj=##class(User.CSSDPackageApply).%OpenId(ApplyId)
	s CurrFlag=ApplyObj.CSSDPABeInfected
	q:CurrFlag=Flag RtnObj
	
	s ApplyObj.CSSDPABeInfected=Flag
	s Sc=ApplyObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","更新感染标记失败!")
	
	q RtnObj
}

/// Creator:why
/// CreatDate:2019.8.30
/// Description:获取主表感染标志
/// Table:CSSD_PackageApply
/// d ##class(web.CSSDHUI.Apply.PackageApply).jsAudit
ClassMethod GetApplyDetailInfectSign(RowId As %String) As %String
{
	n (%session,RowId)
	s Flag="N"
	s ApplyItmId=0
	f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",RowId,ApplyItmId)) q:(ApplyItmId="")||(Flag="Y")  d
	.s ItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.s Infect=ItmObj.CSSDPADBeInfected
	.i Infect="Y" s Flag="Y" q
	q Flag
}

/// CreatDate:2019.12.3
/// Description:查询请领主表信息
/// Table:CSSD_PackageApply
/// w ##class(web.CSSDHUI.Apply.PackageApply).Select(48)
ClassMethod Select(RowId) As %String
{
	n (%session,RowId)
	q:RowId="" "{}"
	&sql(SELECT ID,CSSDPA_APPLYLOCDR->CTLOC_Desc,CSSDPA_NO,CSSDPA_APPLYUSERDR->SSUSR_Name,CSSDPA_LOCDR->CTLOC_Desc,CSSDPA_SubmitDate,CSSDPA_SubmitTime,CSSDPA_APPLYLOCDR
		INTO :RowId,:ReqLocName,:SerialNo,:ReqUserName,:SupLocName,:ReqDate,:ReqTime,:ReqLocId
		FROM CSSD_PackageApply WHERE ID=:RowId
	)
	q:SQLCODE "{}"

	s ReqDate=..DL2H(ReqDate)
	s ReqTime=..DL2H(ReqTime)
	s ReqDateTime=ReqDate_" "_ReqTime
	s DataStr=RowId_"^"_ReqLocName_"^"_SerialNo_"^"_ReqUserName_"^"_SupLocName
		_"^"_ReqDateTime_"^"_ReqLocId
	s TitleStr="RowId^ReqLocName^SerialNo^ReqUserName^SupLocName"
		_"^ReqDateTime^ReqLocId"
	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// 汇总打印使用
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.PackageApply","SelectAllPrint","61,62,63")
Query SelectAllPrint(MainIds As %Text = "") As web.CSSDHUI.Query(ROWSPEC = "ApplyNo,ReqTypeDesc,LocDesc,ApplyUserName,PackageName,Remark,Qty:%Float,CallBackQty:%Float") [ SqlProc ]
{
}

ClassMethod SelectAllPrintExecute(ByRef qHandle As %Binary, MainIds As %Text) As %Status
{
	n (qHandle,%session,MainIds)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT main.CSSDPA_No as ApplyNo,CSSDPA_Type,CSSDPA_APPLYLOCDR,CSSDPA_APPLYUSERDR,CSSDPAD_PackageDr,"
		_" CSSDPAD_ReqQty,CSSDPAD_Desc, detail.ID as ApplyItmId "
		_" FROM CSSD_PackageApply main,CSSD_PackageApplyDetail detail"
		_" WHERE main.ID=detail.CSSDPAD_Parref AND main.ID IN ("_MainIds_")"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ApplyNo=Result.Data("ApplyNo")
		s ApplyItmId=Result.Data("ApplyItmId")
		s Type=Result.Data("CSSDPA_Type")
		s LOCDR=Result.Data("CSSDPA_APPLYLOCDR")
		s PackageDR=Result.Data("CSSDPAD_PackageDr")
		s Remark=Result.Data("CSSDPAD_Desc")
		s ApplyUserDR=Result.Data("CSSDPA_APPLYUSERDR")
		s Qty=Result.Data("CSSDPAD_ReqQty")

		s LocDesc=..sssLocDesc(LOCDR)
		s ApplyUserName=..sssUserName(ApplyUserDR)
		s ReqTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(Type)
		s PackageName=""
		i PackageDR'="" d
		.s packageObj=##class(User.CSSDPackage).%OpenId(PackageDR)
		.s PackageName=packageObj.CSSDPDesc

		s CallBackQty=""
		s CBItmId=""
		f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,CBItmId)) q:CBItmId=""  d
		.s CBItmQty=$lg(^User.CSSDCallbackDetailNewD(CBItmId),4)
		.s CallBackQty=CallBackQty+CBItmQty

		d OutPutRowPrint
	}
	d Result.Close()
	Quit $$$OK
OutPutRowPrint
	s Data=$lb(ApplyNo,ReqTypeDesc,LocDesc,ApplyUserName,PackageName,Remark,Qty,CallBackQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:根据申请单主表ID判断当前单据明细是否全部发放 1全部发放  2部分发放 3全部未发放(无明细单子暂定位全部未发放)
/// Table:CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.Apply.PackageApply).GetDispStatus(97)
ClassMethod GetDispStatus(MainId As %String) As %String
{
	n (%session,MainId)
	q:MainId="" ""
	q:$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId,""))="" 3
	
	s ZeroDispFlag="Y",AllDispFlag="Y"
	s ItmId=""
	f  s ItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId,ItmId))  q:(ItmId="")  d
	.s Qty=$lg(^User.CSSDPackageApplyDetailD(ItmId),11)		;请领数量
	.s OutQty=$lg(^User.CSSDPackageApplyDetailD(ItmId),9)	;发放数量
	.
	.i OutQty>0 s ZeroDispFlag="N"		;只要有1个非0, 就不是 全部未发放
	.i OutQty<Qty s AllDispFlag="N"	;只要有一个<=Qty,就不是 全部发放

	s DispStatus=""
	i ZeroDispFlag="Y" s DispStatus=3
	e  i AllDispFlag="Y" s DispStatus=1
	e  s DispStatus=2

	q DispStatus
}

/// w ##class(web.CSSDHUI.Apply.PackageApply).GetReqType(5)
ClassMethod GetReqType(MainId As %String) As %String
{
	n (%session,MainId)
	q:MainId="" ""
	s (Type,ReqTypeDesc)=""
	s:$d(^User.CSSDPackageApplyD(MainId)) Type=$lg(^User.CSSDPackageApplyD(MainId),17)
	s ReqTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(Type)
	q Type_"^"_ReqTypeDesc
}

/// w ##class(web.CSSDHUI.Apply.PackageApply).GetIsExistDetail(14)
ClassMethod GetIsExistDetail(MainId As %String) As %String
{
	n (MainId)
	i $d(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId)) q "Y"
	q "N"
}

/// Descript:	申请单追踪状态
/// Creator:	ban
/// CreateDate:	2022-09-07
/// Table:		cssd_packageapply
/// Input:		ApplyMainId  申请主表id
/// Return：	申请单追踪状态
/// w ##class(web.CSSDHUI.Apply.PackageApply).GetApplyStatusById("1")
ClassMethod GetApplyStatusById(ApplyMainId As %String)
{
	n (%session,ApplyMainId)
	q:ApplyMainId="" "[]"

	s StepInfo=""
	s Title="title^context"
	s ApplyMainObj=##class(User.CSSDPackageApply).%OpenId(ApplyMainId)
	d ApplyMainObj.%Reload()
	q:'$IsObject(ApplyMainObj) "[]"
	s Flag=ApplyMainObj.CSSDPAFlag
	s CreateUserObj=ApplyMainObj.CSSDPACreateUser
	s CreateDate=ApplyMainObj.CSSDPACreateDate
	s ApplyUserObj=ApplyMainObj.CSSDPAAPPLYUSERDR
	s SubmitDate=ApplyMainObj.CSSDPASubmitDate
	s SubmitTime=ApplyMainObj.CSSDPASubmitTime


	s (CreateUserDesc,SubmitUserDesc,CallBackUserDesc,DispUserDesc,RecUserDesc)=""
	i $IsObject(CreateUserObj) s CreateUserDesc=CreateUserObj.SSUSRName
	i $IsObject(ApplyUserObj) s SubmitUserDesc=ApplyUserObj.SSUSRName
	s CreateDate=..DL2H(CreateDate)
	s SubmitDate=..DL2H(SubmitDate)
	s SubmitTime=..TL2H(SubmitTime)

	s ContextStr="<div style='font-weight:normal;margin-top:0px;'>"
		_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_CreateUserDesc_"</p>"
		_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_CreateDate_"</p>"
		_"</div>"
	s Data=..%Translate($CLASSNAME(),"未提交")_"^"_ContextStr
	s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	i StepInfo="" s StepInfo=StepStr
	e  s StepInfo=StepInfo_","_StepStr

	i SubmitDate'="" d
	.s SubmitStr="<div style='font-weight:normal;margin-top:0px;'>"
	.s SubmitStr=SubmitStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitUserDesc_"</p>"
	.s SubmitStr=SubmitStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitDate_" "_SubmitTime_"</p>"
	.s SubmitStr=SubmitStr_"</div>"
	.
	.s Data=..%Translate($CLASSNAME(),"提交")_"^"_SubmitStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr

	i ((Flag="5")||(Flag="2")||(Flag="3")||(Flag="6")) d
	.s ConfirmStr="<div style='font-weight:normal;margin-top:0px;'>"
	.s ConfirmStr=ConfirmStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitUserDesc_"</p>"
	.s ConfirmStr=ConfirmStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitDate_" "_SubmitTime_"</p>"
	.s ConfirmStr=ConfirmStr_"</div>"
	.s Data=..%Translate($CLASSNAME(),"确认")_"^"_ConfirmStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr
	e  i Flag="8" d
	.s RefuseStr="<div style='font-weight:normal;margin-top:0px;'>"
	.s RefuseStr=RefuseStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitUserDesc_"</p>"
	.s RefuseStr=RefuseStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_SubmitDate_" "_SubmitTime_"</p>"
	.s RefuseStr=RefuseStr_"</div>"
	.s Data=..%Translate($CLASSNAME(),"拒绝")_"^"_RefuseStr
	.s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i StepInfo="" s StepInfo=StepStr
	.e  s StepInfo=StepInfo_","_StepStr

	q:Flag="8" "["_StepInfo_"]"			;拒绝状态不再继续取值

	s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",ApplyMainId,""))
	i ((Flag="2")||(Flag="3")||(Flag="6")) d
	.i CallBackId'="" d
	..s CallBackObj=##class(User.CSSDPackageCallback).%OpenId(CallBackId)
	..q:'$IsObject(CallBackObj)
	..s CallBackUserObj=CallBackObj.CSSDPCAckUserDr
	..s CallBackDate=CallBackObj.CSSDPCAckDate
	..s CallBackTime=CallBackObj.CSSDPCAckTime
	..s CallBackUserDesc=""
	..i $IsObject(CallBackUserObj) s CallBackUserDesc=CallBackUserObj.SSUSRName
	..s CallBackDate=..DL2H(CallBackDate)
	..s CallBackTime=..TL2H(CallBackTime)
	..
	..s CallBackStr="<div style='font-weight:normal;margin-top:0px;'>"
	..s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_CallBackUserDesc_"</p>"
	..s CallBackStr=CallBackStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_CallBackDate_" "_CallBackTime_"</p>"
	..s CallBackStr=CallBackStr_"</div>"
	..
	..s Data=..%Translate($CLASSNAME(),"回收")_"^"_CallBackStr
	..s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	..i StepInfo="" s StepInfo=StepStr
	..e  s StepInfo=StepInfo_","_StepStr

	s DispId=""
	i CallBackId'="" s DispId=$o(^User.CSSDPackageDispMainI("CSSDPDMCallBackIndex",CallBackId,""))

	i ((Flag="3")||(Flag="6")) d
	.i DispId'="" d
	..s DispObj=##class(User.CSSDPackageDispMain).%OpenId(DispId)
	..q:'$IsObject(DispObj)
	..s DispUserObj=DispObj.CSSDPDMCHKUserDr
	..i $IsObject(DispUserObj) s DispUserDesc=DispUserObj.SSUSRName
	..s DispSubmitDate=DispObj.CSSDPDMSubmitDate
	..s DispSubmitDate=..DL2H(DispSubmitDate)
	..s DispSubmitTime=DispObj.CSSDPDMSubmitTime
	..s DispSubmitTime=..TL2H(DispSubmitTime)
	..s DispSubmitStr="<div style='font-weight:normal;margin-top:0px;'>"
	..s DispSubmitStr=DispSubmitStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_DispUserDesc_"</p>"
	..s DispSubmitStr=DispSubmitStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_DispSubmitDate_" "_DispSubmitTime_"</p>"
	..s DispSubmitStr=DispSubmitStr_"</div>"
	..s Data=..%Translate($CLASSNAME(),"发放")_"^"_DispSubmitStr
	..s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	..i StepInfo="" s StepInfo=StepStr
	..e  s StepInfo=StepInfo_","_StepStr
	..i Flag="6" d
	...s RecUserObj=DispObj.CSSDPDMToUserDr
	...i $IsObject(RecUserObj) s RecUserDesc=RecUserObj.SSUSRName
	...s RecDate=DispObj.CSSDPDMReceiveDate
	...s RecDate=..DL2H(RecDate)
	...s RecTime=DispObj.CSSDPDMReceiveTime
	...s RecTime=..TL2H(RecTime)
	...s RecStr="<div style='font-weight:normal;margin-top:0px;'>"
	...s RecStr=RecStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_RecUserDesc_"</p>"
	...s RecStr=RecStr_"<p style='font-size:14px;margin-right:50px;width:200px;'>"_RecDate_" "_RecTime_"</p>"
	...s RecStr=RecStr_"</div>"
	...s Data=..%Translate($CLASSNAME(),"接收")_"^"_RecStr
	...s StepStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	...i StepInfo="" s StepInfo=StepStr
	...e  s StepInfo=StepInfo_","_StepStr

	s StepInfo="["_StepInfo_"]"
	q StepInfo
}

/// Description:判断当前申请单是否存在符合当前灭菌方式的消毒包
/// Creator:DYL
/// CreatDate:2023-04-20
/// Input:申请主单id，灭菌方式
/// OutPut:Y-存在，N-不存在
ClassMethod IFSterTypeInApplyDetail(RowId, SterTypeId) As %String
{
	n (RowId,SterTypeId)
	s PkgId=""
	s Flag="N"
	f  s PkgId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",RowId,PkgId)) q:PkgId=""  d
	.s PSterTypeId=$lg(^User.CSSDPackageD(PkgId),21)
	.i (SterTypeId=PSterTypeId) s Flag="Y"
	.q:Flag="Y"
	
	q Flag
}

}
