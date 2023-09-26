/// 描述: 移动端用户访问
/// 编写者：ZX
/// 编写日期: 2020-11-17
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTWChatUser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zx 2020-11-17
/// 描述：微信操作日志查询 
/// 入参：LogType：日志类型 
///       ChatID：访问用户微信id
///       User：访问用户系统userid
///       StartDate：访问开始时间
///       EndDate：访问结束时间
///       MethodDesc：访问方法代码
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTWChatUser","GetWChatOperationLog","","","","","","0001")
Query GetWChatOperationLog(LogType, ChatID, User, StartDate, EndDate, MethodDesc) As %Query(ROWSPEC = "TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE")
{
}

ClassMethod GetWChatOperationLogExecute(ByRef qHandle As %Binary, LogType, ChatID, User, StartDate, EndDate, MethodDesc) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s TRow=0
 	s rowid=0
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	i StartDate>EndDate q

 	if (LogType="1")||(LogType="")  d
 	.f  s rowid=$O(^DHCEQWChatBindLog(rowid)) q:rowid=""  d
 	..d ResetVariableGetWChatOperationLog
 	..q:(MethodDesc'="")
 	..s TLogType="绑定日志"
 	..s TRowID=rowid
 	..S TChatID=$P(^DHCEQWChatBindLog(rowid),"^",1)  ;微信id
 	..q:(ChatID'="")&&(ChatID'=TChatID)
 	..s TUserDR=$P(^DHCEQWChatBindLog(rowid),"^",2)  ;用户
	..i TUserDR '="" s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
 	..q:(User'="")&&(User'=TUserDR)
 	..s TGroupDR=$P(^DHCEQWChatBindLog(rowid),"^",3)  ;安全组
	..i TGroupDR '="" s TGroup = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TGroupDR)
 	..s TLocDR=$P(^DHCEQWChatBindLog(rowid),"^",4)  ;科室
	..i TLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
 	..s TLogDate=$P(^DHCEQWChatBindLog(rowid),"^",5)  ;日志日期
	..q:(TLogDate>EndDate)||(TLogDate<StartDate)
	..s TLogDate=##Class(web.DHCEQCommon).TransValueToPage(TLogDate,"date")
	..s TLogTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWChatBindLog(rowid)),"^",6),"time")
 	..s TBindType=$CASE($P(^DHCEQWChatBindLog(rowid),"^",7),"0":"绑定","1":"切换","2":"解绑",:"")  ;绑定类型
 	..s TRow=TRow+1
	..d OutputRowGetWChatOperationLog

	if (LogType="2")||(LogType="")  d 
 	.f  s rowid=$O(^DHCEQWChatLog(rowid)) q:rowid=""  d
 	..d ResetVariableGetWChatOperationLog
 	..s TLogType="调用日志"
 	..s TRowID=rowid
 	..q:TRowID=0
 	..S TChatID=$P(^DHCEQWChatLog(rowid),"^",1)  ;微信id
 	..q:(ChatID'="")&&(TChatID'=ChatID)
 	..s TUserDR=$P(^DHCEQWChatLog(rowid),"^",2)  ;用户
	..i TUserDR '="" s TUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
 	..q:(User'="")&&(User'=TUserDR)
 	..s TGroupDR=$P(^DHCEQWChatLog(rowid),"^",3)  ;安全组
	..i TGroupDR '="" s TGroup = ##class(web.DHCEQCommon).GetTrakNameByID("grp",TGroupDR)
 	..s TLocDR=$P(^DHCEQWChatLog(rowid),"^",4)  ;科室
	..i TLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
 	..s TLogDate=$P(^DHCEQWChatLog(rowid),"^",5)  ;日志日期
	..q:(TLogDate>EndDate)||(TLogDate<StartDate)
	..s TLogDate=##Class(web.DHCEQCommon).TransValueToPage(TLogDate,"date")
	..s TLogTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQWChatLog(rowid)),"^",6),"time")
 	..s TMethodCode=$P(^DHCEQWChatLog(rowid),"^",7)  ;方法代码
 	..i TMethodCode'="" s TMethodDescC=##Class(web.DHCEQ.Plat.CTWChatUser).GetMethodDescByCode(TMethodCode,0)
 	..i TMethodCode'="" s TMethodDescE=##Class(web.DHCEQ.Plat.CTWChatUser).GetMethodDescByCode(TMethodCode,1)
 	..q:(MethodDesc'="")&&(TMethodCode'[MethodDesc)
 	..s TPermission=$CASE($P(^DHCEQWChatLog(rowid),"^",8),"Y":"成功调用","N":"失败调用",:"")  ;许可
 	..s TRow=TRow+1
	..d OutputRowGetWChatOperationLog
 	
	Quit $$$OK
	
ResetVariableGetWChatOperationLog
	s (TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE)=""
	quit
	
OutputRowGetWChatOperationLog
	s Data=$lb(TRow,TRowID,TLogType,TChatID,TUserDR,TUser,TGroupDR,TGroup,TLocDR,TLoc,TLogDate,TLogTime,TBindType,TMethodCode,TPermission,TMethodDescC,TMethodDescE)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetWChatOperationLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWChatOperationLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWChatOperationLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWChatOperationLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// author zouxuan 2020-11-17
/// description 根据移动端调用webservice代码解析相关内容
/// input：
///     MethodCode	方法代码
///     DescType	方法描述类型 0:汉字 1:调用具体方法名
/// output：返回方法描述类型对应的描述
/// w ##Class(web.DHCEQ.Plat.CTWChatUser).GetMethodDescByCode("0001",0)
ClassMethod GetMethodDescByCode(MethodCode As %String = "", DescType)
{
	n MethodDesc
	s MethodDesc="未定义"
	if (DescType=1)
	{
		s MethodDesc=$CASE(MethodCode,
			              "0001":"web.DHCEQM.DHCEQMaintForService:GetEquipByEquipNo",
			              "0002":"web.DHCEQCommon:doFormatToXML",
			              "0003":"web.DHCEQM.DHCEQMMaintRequest:UpdateMaintRequest",
			              "0004":"web.DHCEQM.DHCEQMExObj:AutoSaveExObj",
						  "0005":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest",
						  "0006":"web.DHCEQM.DHCEQMMaintRequest:SubmitMaintRequest",
						  "0007":"web.DHCEQM.DHCEQMMaintRequest:AuditData",
						  "0008":"未调用",
						  "0010":"web.DHCEQM.DHCEQMMaintRequest:GetOneMaintRequest",
						  "0011":"web.DHCEQYJSRunQian:GetEvaluateType",
						  "0012":"web.DHCEQYJSRunQian:EvaluateDetail",
						  "0013":"web.DHCEQCommon:GetLocByUserID",
						  "0014":"web.DHCEQM.DHCEQ34MMaintRequest:SaveEvaluation",
						  "0015":"web.DHCEQCommon:GetSysInfo",
						  "0018":"web.DHCEQM.DHCEQMMaintRequest:GetOneEquipMaint",
						  "0019":"web.DHCEQM.DHCEQMMaintRequest:SaveMaintProgress",
						  "0020":"web.DHCEQM.DHCEQMMaintRequest:GetMaintProgress",
						  "0021":"web.DHCEQM.DHCEQMMaintRequest:GetOneEvaluate",
						  "0022":"web.DHCEQ.Process.DHCEQPicture:SaveData",
						  "0023":"web.DHCEQ.Process.DHCEQPictureList:GetPictureListInfo",
						  "0024":"web.DHCEQCSysMenus:GetAllowMenus",
						  "0025":"web.DHCEQMessages:GetBussDataByCode",
						  "0026":"web.DHCEQM.DHCEQMCEmergencyLevel:EmergencyLevel",
						  "0027":"web.DHCEQFind:EQUser",
						  "0028":"web.DHCEQM.DHCEQMCFaultType:FaultType",
						  "0029":"web.DHCEQM.DHCEQMCFaultReason:Faultreason",
						  "0030":"web.DHCEQM.DHCEQMCDealMethod:DealMethod",
						  "0031":"web.DHCEQM.DHCEQMCMaintMode:MaintMode",
						  "0032":"web.DHCEQCRoleBuss:GetBussByRole",
						  "0033":"web.DHCEQM.DHCEQMCFaultCase:FaultCase",
						  "0034":"web.DHCEQApprove:GetRequiredFields",
						  "0035":"web.DHCEQCApproveFlow:GetApproveFlowType",
						  "0036":"web.DHCEQCApproveFlow:GetUserApprovesForPDA",
						  "0037":"web.DHCEQApprove:GetApproveInfoBySourceID",
						  "0038":"web.DHCEQM.DHCEQMCSeverityLevel:SeverityLevel",
						  "0039":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetail",
						  "0040":"web.DHCEQCService:LookUp",
						  "0041":"web.DHCEQM.DHCEQMCMaintResults:LookUp",
						  "0042":"web.DHCEQCommon:Logon",
						  "0043":"web.DHCEQCommon:LogonLocGrp",
						  "0044":"web.DHCEQCommon:CheckFunction",
						  "0045":"web.DHCEQWChatUser:BindChatID",
						  "0046":"web.DHCEQCommon:OutputToXml",
						  "0047":"web.DHCEQMessages:GetBussDataForWChat",
						  "0048":"未调用",
						  "0049":"web.DHCEQMCMaintGroupList:GetMaintGroupList",
						  "0050":"web.DHCEQM.DHCEQMMaintPart:SaveData",
						  "0051":"web.DHCEQM.DHCEQMMaintPart:SubmitManage",
						  "0052":"web.DHCEQM.DHCEQMMaintPart:CancelManage",
						  "0053":"web.DHCEQM.DHCEQMMaintPart:MaintPart",
						  "0054":"web.DHCEQCManufacturer:LookUp",
						  "0055":"web.DHCEQCVendor:GetVendor",
						  "0056":"web.DHCEQFind:GetAccessoryType",
						  "0057":"web.DHCEQM.DHCEQMaintForService:GetAStockDetail",
						  "0058":"web.DHCEQM.DHCEQMMaintPart:GetOneMaintPart",
						  "0059":"web.DHCEQMessages:GetManagementInfo",
						  "0060":"web.DHCEQM.DHCEQMMaintPart:GetOneMaintPart",
						  "0061":"web.DHCEQEquipRent:GetEquipRentByEquipForWechat",
						  "0062":"web.DHCEQEquipRent:GetEquipRentByItemForWechat",
						  "0063":"web.DHCEQCommon:GetFirstIDByLocType",
						  "0064":"web.DHCEQRent:SaveData",
						  "0065":"web.DHCEQRent:GetRentByID",
						  "0066":"web.DHCEQEquip:GetEquipByID",
						  "0067":"web.DHCEQRent:GetRentList",
						  "0068":"web.DHCEQEquipRent:GetEquipUsedInfo",
						  "0069":"web.DHCEQCSysGroupMenu:GetGroupMenus",
						  "0070":"web.DHCEQMessages:GetApproveInfo",
						  "0071":"web.DHCEQ.EM.BUSEquip:GetShortEquip",
						  "0072":"web.DHCEQPrescription:GetBussPrcSum",
						  "0073":"web.DHCEQPrescription:GetBussPrcDetail",
						  "0074":"web.DHCEQM.DHCEQMCMaintProcess:LookUp",
						  "0075":"web.DHCEQM.DHCEQMMaintRequest:CheckMaintProcess",
						  "0076":"web.DHCEQM.DHCEQMaintForService:WeChatNotice",
						  "0090":"web.DHCEQMessageSendInfo:GetMSIDetail",
						  "0999":"web.DHCEQMessageSendInfo:UpdateData",
						  "1008":"web.DHCEQMessages:GetBussInfoBySourceID",
						  "eq101":"web.DHCEQEquip:GetEquipByID",
						  "aff101":"web.DHCEQAffix:GetAffixByID",
						  "maint101":"web.DHCEQ.EM.BUSMMaintRequest:CancelSubmitData",
						  "maint103":"web.DHCEQ.EM.BUSMMaintRequest:DeleteMaintRequest",
						  "disuse101":"web.DHCEQBatchDisuseRequest:BatchDisuseRequestBuild",
						  "disuse102":"web.DHCEQBatchDisuseRequest:AuditData",
						  "disuse103":"web.DHCEQBatchDisuseRequest:GetOneDisuseRequest",
						  "disuse104":"web.DHCEQBatchDisuseRequest:CancelSubmit",
						  "code101":"web.DHCEQM.DHCEQMaintForService:AutoSaveBaseCodeByTable",
						  "storemove101":"web.DHCEQ.EM.BUSStoreMove:GetOneStoreMove",
						  "storemove102":"web.DHCEQ.EM.BUSStoreMove:AuditData",
						  "pd101":"web.DHCEQInventory:GetInfoByEquipNo",
						  "pd102":"web.DHCEQInventory:SaveInventoryResult",
						  "pd103":"web.DHCEQInventory:CancelInventoryResult",
						  "pd104":"web.DHCEQInventory:SaveBindObj",
						  "pd105":"web.DHCEQ.EM.BUSInventory:LocInventory",
						  "jl101":"web.DHCEQStateInfo:GetOneStateInfo",
						  "jl102":"web.DHCEQStateInfo:SaveStateInfo",
						  "pm101":"web.DHCEQ.EM.BUSEquipRange:GetRangSourceByEquip",
						  "pm102":"web.DHCEQ.EM.BUSMaint:SaveData",
						  "pm103":"web.DHCEQ.EM.BUSMaint:SubmitData",
						  "2998":"web.DHCEQWChatUser:GetMethodResult",
						  "0091":"web.DHCEQEvaluate:EvaluateDetail",
						  "0092":"web.DHCEQEvaluate:GetBussEvaluate",
						  "0099":"web.DHCEQMessages:GetBussDataByCode",
						  "0112":"web.DHCEQTraining:GetOutMaintUserList",
						  "0089":"web.DHCEQFind:GetEQLoc",
						  "Eq201":"web.DHCEQEquip:GetShortEquip",
						  "file201":"web.DHCEQ.Plat.CTProduct:GetProductAppendFile",
						  "pic201":"web.DHCEQ.Process.DHCEQPicture:GetPictureList",
						  "aff201":"web.DHCEQAffix:GetAffix",
						  "2999":"web.DHCEQWChatUser:GetQueryResult",
						  "pd203":"web.DHCEQInventory:GetInventoryLoc",
						  "pd201":"web.DHCEQInventory:QueryInventory",
						  "pd202":"web.DHCEQInventory:GetInventoryDiffer",
						  "BC201":"web.DHCEQWChatBaseCode:GetBaseCodeByTable",
						  "Maint201":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetailByUser",
						  "Maint202":"web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestHiStory",
						  "storemove201":"web.DHCEQ.EM.BUSStoreMove:GetStoreMoveList",
						  "Eq202":"web.DHCEQ.EM.BUSLifeInfo:LifeInfo",
						  "disuse201":"web.DHCEQ.Plat.LIBMessages:GetDetailByMessages",
						  "pd204":"web.DHCEQ.EM.BUSInventory:QueryInventory",
						  "jl201":"web.DHCEQStateInfo:GetStateInfo",
						  "pm201":"web.DHCEQ.Code.DHCEQCPMTemplateList:PMTemplateList",
						  "pm202":"web.DHCEQ.EM.BUSMaintPlan:GetPlanName",
						  "pm203":"web.DHCEQ.EM.BUSMaintPlan:GetPlanExecuteList",
						  "0120":"web.DHCEQ.Plat.LIBFind:GetAccessoryOriginal",
						  "pm204":"web.DHCEQ.Code.DHCEQCPMTemplate:PMTemplateRange",
						  "pm205":"web.DHCEQ.EM.LIBFind:GetMaintMode",
						  :"未定义"
						  )
	}
	else
	{
		s MethodDesc=$CASE(MethodCode,
			              "0001":"根据编号获取设备信息",
			              "0002":"获取维修基础数据",
			              "0003":"保存维修单",
			              "0004":"自动保存维修对象",
						  "0005":"待操作维修单据查询",
						  "0006":"提交维修单",
						  "0007":"维修受理,完成操作",
						  "0008":"获取维修图片",
						  "0010":"获取一个维修单据",
						  "0011":"获取维修评价项目",
						  "0012":"获取评价列表",
						  "0013":"根据用户获取科室",
						  "0014":"保存维修评价信息",
						  "0015":"远程获取FTP信息",
						  "0018":"获取单个设备维修单",
						  "0019":"保存维修进度报告",
						  "0020":"获取维修进度报告信息",
						  "0021":"获取一个评价信息",
						  "0022":"保存图片信息",
						  "0024":"获取安全组可访问菜单代码",
						  "0025":"维修待办列表",
						  "0026":"紧急程度",
						  "0027":"人员列表",
						  "0028":"故障类型",
						  "0029":"故障原因",
						  "0030":"解决方法",
						  "0031":"维修方式",
						  "0032":"待办业务列表",
						  "0033":"故障现象",
						  "0034":"获取可编辑字段",
						  "0035":"获取审批流类型",
						  "0036":"获取可转向步骤",
						  "0037":"获取审批流信息",
						  "0038":"严重程度",
						  "0039":"维修个人列表",
						  "0040":"服务商",
						  "0041":"维修结果",
						  "0042":"验证登陆信息是否正确",
						  "0043":"获取安全组登陆科室",
						  "0044":"验证安全组是否正确",
						  "0045":"绑定id",
						  "0046":"检验用户微信是否绑定",
						  "0047":"消息获取",
						  "0048":"FTP服务器下载",
						  "0049":"维修人员信息",
						  "0050":"维修配件增删改",
						  "0051":"配件明细提交审核",
						  "0052":"配件明细取消提交审核",
						  "0053":"维修单配件列表信息",
						  "0054":"生产厂商",
						  "0055":"供应商",
						  "0056":"配件类组",
						  "0057":"配件项列表信息",
						  "0058":"更新图片上传标志",
						  "0059":"报表统计",
						  "0060":"单条配件信息",
						  "0061":"租赁设备信息",
						  "0062":"租赁设备项",
						  "0063":"获取租赁中心科室ID",
						  "0064":"租赁调用SavaData方法",
						  "0065":"根据ID获取租赁明细",
						  "0066":"获取台账表设备信息",
						  "0067":"租赁单据列表",
						  "0068":"过滤已租赁未归还设备",
						  "0069":"获取主界面菜单信息",
						  "0070":"获取审批进度信息",
						  "0071":"获取维修对象列表",
						  "0072":"获取业务单据预警统计",
						  "0073":"获取业务单据预警明细",
						  "0074":"获取维修进程基础数据",
						  "0075":"检测设备是否处于维修",
						  "0076":"获取预警消息",
						  "0090":"业务消息推送",
						  "0999":"消息发送结果回传",
						  "1008":"获取个人明细——消息表",
						  "eq101":"单台设备信息查阅",
						  "aff101":"附件明细查看",
						  "maint101":"维修单退回操作",
						  "maint103":"维修单删除操作",
						  "disuse101":"单台设备报废申请",
						  "disuse102":"报废单审核操作",
						  "disuse103":"报废单信息获取",
						  "disuse104":"报废单退回操作",
						  "code101":"维修基础数据保存",
						  "storemove101":"转移单信息获取",
						  "storemove102":"转移单审核操作",
						  "pd101":"根据设备编号获取盘点设备信息",
						  "pd102":"盘点设备保存操作",
						  "pd103":"取消盘点操作",
						  "pd104":"第三方编号绑定操作",
						  "pd105":"盘点单审核操作",
						  "jl101":"开机后使用记录获取",
						  "jl102":"保存使用记录",
						  "pm101":"根据设备获取相关执行计划、执行记录、模板信息",
						  "pm102":"记录保存",
						  "pm103":"记录提交",
						  "2998":"方法统一调用",
						  "0091":"获取评价明细列表",
						  "0092":"获取评价业务数据列表",
						  "0099":"获取设备待办业务明细",
						  "0112":"院外维修人员列表",
						  "0089":"获取科室列表信息",
						  "Eq201":"台账数据列表",
						  "file201":"文件资料列表",
						  "pic201":"图片信息列表",
						  "aff201":"附件列表",
						  "2999":"query调用处理",
						  "pd203":"获取盘点科室信息",
						  "pd201":"获取盘点单列表",
						  "pd202":"获取盘点结果列表",
						  "BC201":"基础数据获取",
						  "Maint201":"维修个人维修单",
						  "Maint202":"维修历史记录",
						  "storemove201":"转移明细列表",
						  "Eq202":"生命周期信息",
						  "disuse201":"个人报废单据",
						  "pd204":"新版本盘点单列表",
						  "jl201":"使用记录列表",
						  "pm201":"获取模板内容",
						  "pm202":"获取计划列表",
						  "pm203":"获取执行计划列表",
						  "0120":"维修配件来源",
						  "pm204":"获取模板列表",
						  "pm205":"获取保养方式",
						  :"未定义"
						  )
	}
	q MethodDesc
}

}
