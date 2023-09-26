Class web.DHCEQ.Plat.BUSApprove Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-30
/// 描述:根据审批设置,角色,动作获取编辑字段清单
/// 入参:ApproveSetDR 审批设置RowID
/// 		CurRole 角色RowID
/// 		ActionCode 动作代码
/// 返回值:{"SQLCODE":成功失败代码,"Data":详细内容}
/// 		详细内容格式:"列1^列2^列3^...^列n"  
/// 		列格式:"编辑字段RowID,编辑字段名,编辑字段对应表名,是否必填项,是否列表元素,编辑字段类型,列表元素对应行RowID名"
ClassMethod GetRequiredFields(ApproveSetDR, Role, ActionCode As %String = "")
{
	n (ApproveSetDR,Role,ActionCode)
	i ApproveSetDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
    i (Role="")&&(ActionCode="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s FlowDR=""
	i ActionCode=""  d
	.s FlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,Role,0))
	e  d
	.s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))
	.i ActionDR'="" s FlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))
	i FlowDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s EditFields=""
	s Sort=0
	for  s Sort=$O(^DHCEQCCode("DHCEQCRoleReqFields",0,"Flow",FlowDR,Sort)) Quit:Sort=""  d
	.s RRFRowID=0
	.for  s RRFRowID=$O(^DHCEQCCode("DHCEQCRoleReqFields",0,"Flow",FlowDR,Sort,RRFRowID)) Quit:RRFRowID=""  d
	..s Field=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",3)
	..s TableName=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",6)   
	..s MustFlag=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",2)
	..s FieldType=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",4)
	..;是否列表元素
	..s Hold1=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",8)
	..s Hold2=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",9)
	..i EditFields="" s EditFields=RRFRowID_","_Field_","_TableName_","_MustFlag_","_Hold1_","_FieldType_","_Hold2
	..e  s EditFields=EditFields_"^"_RRFRowID_","_Field_","_TableName_","_MustFlag_","_Hold1_","_FieldType_","_Hold2
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EditFields)
}

/// Add By DJ 2019-10-16
/// 描述:HISUI版返回JSON对象
/// Modified by csj 20191128 传入业务信息对象
ClassMethod GetApproveInfoBySourceID(ApproveTypeCode, SourceID, paraApproveRoleDR As %String = "", AppInfoObj)
{
	new AIRowID,ApproveSetDR,NextRoleDR,NextFlowStep,ApproveStatu,ApproveRoleDR,CancelFlag,CancelToFlowDR,ApproveRole,NextRole,CancelType
	s (AIRowID,ApproveSetDR,NextRoleDR,NextFlowStep,ApproveStatu,ApproveRoleDR,CancelFlag,CancelToFlowDR,ApproveRole,NextRole,CancelType)=""
	s ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType(ApproveTypeCode)
	i ApproveTypeDR'="" s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,SourceID,0))  //审批流信息DHC_EQApproveInfo
	
	i AIRowID'=""  d
	.s ApproveSetDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",3)
	.s NextRoleDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",4)
	.s NextFlowStep=$p($g(^DHCEQApproveInfo(AIRowID)),"^",5)
	.s ApproveStatu=$p($g(^DHCEQApproveInfo(AIRowID)),"^",6)
	.s ApproveRoleDR=$p($g(^DHCEQApproveInfo(AIRowID)),"^",7)
	.
	.i (ApproveSetDR'="")&&(NextFlowStep'="") d
	..s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,NextFlowStep,0))
	..i AFRowID'="" d
	...s CancelType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",13)  //add by zx 2016-03-16 Bug ZX0035 审批流修改后取消角色处理
	...s CancelFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",5)
	...i (CancelType="1")||(CancelType="") d
	....s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",6)
	...i (CancelType="0") d
	....i ApproveStatu'="" d
	.....s CancelAFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,ApproveStatu,0))
	.....i CancelAFRowID'="" s CancelToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelAFRowID)),"^",6)
	....e  d
	.....s CancelToFlowDR=""
	
	/// Mozy	2015-12-31	新维修业务
	If (paraApproveRoleDR'="")&(paraApproveRoleDR'=NextRoleDR)&(NextFlowStep'="")	
	{
		;逆向取到本轮审批的开始步骤,是必要步骤则退出继续
		Set tmpNextFlowStep=NextFlowStep
		Set NextAFDR=""
		Set AFHold4Flag=""
		Do
		{
			Set tmpNextFlowStep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,tmpNextFlowStep),-1)
			If tmpNextFlowStep'="" Set NextAFDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,tmpNextFlowStep,""))
			If NextAFDR'="" Set AFHold4Flag=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",10)
		}While (AFHold4Flag="Y")&(tmpNextFlowStep'="")
		
		Set AFHold4Flag = "Y"		;重置非必填项
		For  Set tmpNextFlowStep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,tmpNextFlowStep)) Quit:(tmpNextFlowStep="")||(AFHold4Flag '= "Y")  Do
		.Set NextAFDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,tmpNextFlowStep,""))	
		.Set AFHold4Flag=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",10)
		.Quit:paraApproveRoleDR'=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",2)
		.;设置过滤两次审核时间300s
		.Set flag=0
		.Set id = $Order(^DHCEQApproveList(0,"ApproveRole",ApproveTypeDR,SourceID,$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",2),""),-1)
		.If id'="" Do
		..If $Piece($Get(^DHCEQApproveList(id)),"^",7)<+$H Set flag=1
		..If ($P($H,",",2)-$Piece($Get(^DHCEQApproveList(id)),"^",8))<300 Set flag=1
		.Quit:flag'=0
		.
		.Set NextRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",2)
		.Set NextFlowStep=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",3)
		.Set CancelFlag=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",5)
		.Set CancelToFlowDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",NextAFDR)),"^",6)
	}
	i ApproveRoleDR'="" s ApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",ApproveRoleDR)),"^",2)
	i NextRoleDR'="" s NextRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",NextRoleDR)),"^",2)
	
	d AppInfoObj.%Set("AIRowID",AIRowID)
	d AppInfoObj.%Set("ApproveSetDR",ApproveSetDR)
	d AppInfoObj.%Set("NextRoleDR",NextRoleDR)
	d AppInfoObj.%Set("NextFlowStep",NextFlowStep)
	d AppInfoObj.%Set("ApproveStatu",ApproveStatu)
	d AppInfoObj.%Set("ApproveRoleDR",ApproveRoleDR)
	d AppInfoObj.%Set("CancelFlag",CancelFlag)
	d AppInfoObj.%Set("CancelToFlowDR",CancelToFlowDR)
	d AppInfoObj.%Set("ApproveRole",ApproveRole)
	d AppInfoObj.%Set("NextRole",NextRole)
	q AppInfoObj.%ToJSON()
}

}
