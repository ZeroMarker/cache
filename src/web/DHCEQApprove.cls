/// 创建日期：2010-8-11
/// 创建人：JDL
/// 重新整理通用的审批程序
Class web.DHCEQApprove Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 修改自web.DHCEQInStockNew.GetApproveInfoByRowID
/// 获取单据审批信息
/// w ##Class(web.DHCEQApprove).GetApproveInfoBySourceID("11",40)
ClassMethod GetApproveInfoBySourceID(ApproveTypeCode, SourceID, paraApproveRoleDR As %String = "")
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
	q AIRowID_"^"_ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR_"^"_ApproveRole_"^"_NextRole
}

/// 描述:取系统设置修改字段
/// w ##class(web.DHCEQApprove).GetRequiredFields("13","")
/// ----------------------------------
ClassMethod GetRequiredFields(ApproveSetDR, Role, ActionCode As %String = "")
{
	n (ApproveSetDR,Role,ActionCode)
	i ApproveSetDR="" q ""
    	//add by zx 2017-06-20 BUG ZX0038 Role可以为空处理
    	i (Role="")&&(ActionCode="") q ""
	s FlowDR=""
	i ActionCode=""  d		//Add By DJ 2016-05-11 begin
	.s FlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,Role,0))
	e  d
	.s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ActionCode,0))
	.i ActionDR'="" s FlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSetDR,ActionDR,0))		//Add By DJ 2016-05-11 end
	i FlowDR="" q ""
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
	..;Mozy0040 2011-2-10
	..s Hold2=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",9)
	..i EditFields="" s EditFields=RRFRowID_","_Field_","_TableName_","_MustFlag_","_Hold1_","_FieldType_","_Hold2
	..e  s EditFields=EditFields_"^"_RRFRowID_","_Field_","_TableName_","_MustFlag_","_Hold1_","_FieldType_","_Hold2
	q EditFields
}

/// ----------------------------------
/// 描述:审批编辑字段
/// 入参:editFieldsInfo: 编辑字段及值信息,其格式如下
/// 				表信息1@表信息2...@表信息n
/// 			 	表信息中记录格式为：表名&记录1&记录2...&记录n
/// 			 	记录信息中记录格式为：ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
/// w ##Class(web.DHCEQApprove).EditRoleReqFields("DHC_EQMMaintRequest&88^Y,89^3333,92")
ClassMethod EditRoleReqFields(editFieldsInfo)
{
	new (editFieldsInfo)
	s tableCount=$L(editFieldsInfo,"@")
	s SQLCODE=0
	for i=1:1:tableCount
	{
		i SQLCODE q
		s tableInfo=$p(editFieldsInfo,"@",i)
		s rowCount=$L(tableInfo,"&")
		s TableName=$p(tableInfo,"&",1)
		
		for j=2:1:rowCount
		{
			i SQLCODE q
			s rowInfo=$p(tableInfo,"&",j)
			s SQLCODE=..UpdateRowEditField(TableName,rowInfo)
		}		
	}
	quit SQLCODE
}

/// Modified By HZY	2012-3-15 HZY0024
/// Desc:增加表名为DHC_EQIssue的处理.
/// ------------------------------------------------------------
/// 更新一条记录
/// 入参：TableName表名
/// 		 RowInfo：行信息，格式为
/// 				ID^fieldvalue1,fieldid1^fieldvalue2,fieldid2....^fieldvaluen,fieldidn
ClassMethod UpdateRowEditField(TableName, RowInfo)
{
	n (TableName,RowInfo)
	s SQLCODE=0
	
	//需要特殊处理的
	if (TableName="DHC_EQ")
	{
		s SQLCODE=..UpdateSpecialEditField(RowInfo)
	}
	else
	{	
		k PLIST
		s ColCount=$L(RowInfo,"^")
		s RowID=$p(RowInfo,"^",1)
		q:RowID="" 0
		for k=2:1:ColCount
		{
			s FieldInfo=$P(RowInfo,"^",k)
			s RRFRowID=$P(FieldInfo,",",$l(FieldInfo,","))
			s Position=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",5)
			s RRFType=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",4)
			s PLIST(Position)=$P(FieldInfo,",",1,$l(FieldInfo,",")-1)
			;日期型转化
			;//2011-02-18 ZY0060
			i RRFType=2 s PLIST(Position)=##Class(web.DHCEQCommon).TransValueFromPage($P(FieldInfo,",",1,$l(FieldInfo,",")-1),"date")
			i RRFType=4 s PLIST(Position)=##Class(web.DHCEQCommon).FormatNumber($P(FieldInfo,",",1,$l(FieldInfo,",")-1),"",2)			//Add By DJ 2014-09-23
			i RRFType=5 s PLIST(Position)=##Class(web.DHCEQCommon).TransValueFromPage($P(FieldInfo,",",1,$l(FieldInfo,",")-1),"time")	//20140228  Mozy0120
			i RRFType=6 s PLIST(Position)=##Class(web.DHCEQCommon).TransValueFromPage($P(FieldInfo,",",1,$l(FieldInfo,",")-1),"bool")	//Add By DJ 2016-05-24
		}
	
		if TableName="DHC_EQInStock"
		{
			&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQInStockList")
		{
			&SQL(update sqluser.DHC_EQInStockList values :PLIST() where ISL_RowID=:RowID)
		}	
		elseif  (TableName="DHC_EQStoreMove")
		{
			&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQStoreMoveList")
		{
			&SQL(update sqluser.DHC_EQStoreMoveList values :PLIST() where SML_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQReturn")
		{
			&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQReturnList")
		{
			&SQL(update sqluser.DHC_EQReturnList values :PLIST() where RL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQMaintRequest")	;Mozy	2010-9-1
		{
			&SQL(update sqluser.DHC_EQMaintRequest values :PLIST() where MR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQIFB")			;Mozy	2011-1-1
		{
			&SQL(update sqluser.DHC_EQIFB values :PLIST() where IFB_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQIFBBag")		;Mozy	2011-1-1
		{
			&SQL(update sqluser.DHC_EQIFBBag values :PLIST() where IFBB_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQIFBList")		;Mozy	2011-1-30
		{
			&SQL(update sqluser.DHC_EQIFBList values :PLIST() where IFBL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQBuyRequest")			;Mozy	2011-2-24
		{
			&SQL(update sqluser.DHC_EQBuyRequest values :PLIST() where BR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQBuyRequestList")		;Mozy	2011-2-24
		{
			&SQL(update sqluser.DHC_EQBuyRequestList values :PLIST() where BRL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQBuyRequestDetail")	;Mozy	2011-2-24
		{
			&SQL(update sqluser.DHC_EQBuyRequestDetail values :PLIST() where BRD_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQArgumentation")		;Mozy	2011-2-24
		{
			// 不需要保存数据
			//&SQL(update sqluser.DHC_EQArgumentation values :PLIST() where AR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQContract")		;zy	2011-03-14
		{
			&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQContractList")		;zy	2011-03-14
		{
			&SQL(update sqluser.DHC_EQContractList values :PLIST() where CTL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQBuyPlan")				;Mozy	2011-3-15
		{
			&SQL(update sqluser.DHC_EQBuyPlan values :PLIST() where BP_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQBuyPlanList")			;Mozy	2011-3-15
		{
			&SQL(update sqluser.DHC_EQBuyPlanList values :PLIST() where BPL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQIssue")			;Add By HZY	2012-3-15 HZY0024
		{
			&SQL(update sqluser.DHC_EQIssue values :PLIST() where I_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQDispatchVehicleList")			//20140228  Mozy0120
		{
			&SQL(update sqluser.DHC_EQDispatchVehicleList values :PLIST() where DVL_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQMMaintRequest")			
		{
			&SQL(update sqluser.DHC_EQMMaintRequest values :PLIST() where MR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQMEvaluate")			
		{
			//&SQL(update sqluser.DHC_EQMEvaluate values :PLIST() where E_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQOpenCheckRequest")
		{
			//add by QW 2017-12-01 bug号:QW0009 增加验收可编辑字段
			&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLIST() where OCR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQOpenCheckList")
		{
			s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest", RowID, 0))
			&SQL(Update SQLUSER.DHC_EQOpenCheckList Values :PLIST() where OCL_RowID=:OCLRowID)  //modify by jyp 2017-11-30
		}
		elseif  (TableName="DHC_EQMove")	//add by zx 2017-04-20 Bug ZX0038		
		{
			&SQL(update sqluser.DHC_EQMove values :PLIST() where M_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQDisuseRequest")	//ADD modify by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段	
		{
			&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:RowID)
		}
		elseif  (TableName="DHC_EQSRent")	//add by zx 2020-02-12		
		{
			&SQL(update sqluser.DHC_EQSRent values :PLIST() where R_RowID=:RowID)
		}
	}
	q SQLCODE
}

ClassMethod UpdateSpecialEditField(RowInfo)
{
	n (RowInfo)
	s ColCount=$L(RowInfo,"^")
	s RowID=$p(RowInfo,"^",1)
	s SQLCODE=0
	for k=2:1:ColCount
	{
		if SQLCODE q 
		s FieldInfo=$P(RowInfo,"^",k)
		s RRFRowID=$P(FieldInfo,",",$l(FieldInfo,","))
		s FieldStr=$p($g(^DHCEQCCode("DHCEQCRoleReqFields",RRFRowID)),"^",3)
		s FieldValue=$P(FieldInfo,",",1,$l(FieldInfo,",")-1)
		if (FieldStr="TInvoiceNos")
		{
			s SQLCODE=##Class(web.DHCEQInStockNew).UpdateInvoiceInfo(RowID,FieldValue, "","")
		}
		///add by ZY0235 增加验收单中出厂编号和档案号的特殊编辑字段处理
		elseif (FieldStr="LeaveFactoryNo")
		{
			s ^DHCEQOpenCheckList(RowID,"EX")=FieldValue
		}
		elseif (FieldStr="FileNo")
		{
			s ^DHCEQOpenCheckList(RowID,"FileNo")=FieldValue
		}
	}		
	q SQLCODE
}

/// Mozy0121	2014-03-20
/// 根据业务审批类型获取审批角色
/// d ##class(%ResultSet).RunQuery("web.DHCEQApprove","GetApproveRole","5","设备")
Query GetApproveRole(ApproveTypeCode As %String = "", ApproveRole As %String = "") As %Query(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod GetApproveRoleExecute(ByRef qHandle As %Binary, ApproveTypeCode As %String = "", ApproveRole As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If ApproveTypeCode="" Quit $$$OK
 	
 	Set index=1
 	Set ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType(ApproveTypeCode)		;20140409  Mozy0125
	k ^TempDHCEQ("web.DHCEQApprove.GetApproveRole",$j)
	
	;20140409  Mozy0125
 	;从审批流获取角色id
	Set ApproveSetDR=0
	For  Set ApproveSetDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR)) Quit:ApproveSetDR=""  Do
	.Quit:ApproveTypeDR'=$Piece($Get(^DHCEQCCode("DHCEQCApproveSet",ApproveSetDR)),"^",1)
	.Set ApproveRoleDR=0
	.For  Set ApproveRoleDR=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSetDR,ApproveRoleDR)) Quit:ApproveRoleDR=""  Do
	..Set ^TempDHCEQ("web.DHCEQApprove.GetApproveRole",$j,ApproveRoleDR)=""
	
	;从审批信息获取角色id
	Set ApproveRoleDR=0
	For  Set ApproveRoleDR=$Order(^DHCEQApproveList(0,"Role",ApproveTypeDR,ApproveRoleDR)) Quit:ApproveRoleDR=""  Do
	.Set ^TempDHCEQ("web.DHCEQApprove.GetApproveRole",$j,ApproveRoleDR)=""
	
	Set ApproveRoleDR=0	
	For  Set ApproveRoleDR=$Order(^TempDHCEQ("web.DHCEQApprove.GetApproveRole",$j,ApproveRoleDR)) Quit:ApproveRoleDR=""  Do
	.Do ResetVariablesGetApproveRole
	.Set Code=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",ApproveRoleDR)),"^",1)
	.Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",ApproveRoleDR)),"^",2)
	.Quit:(ApproveRole'="")&(Desc'[ApproveRole)
	.Set Remark=$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",ApproveRoleDR)),"^",3)
	.DO OutputRowGetApproveRole
	Quit $$$OK
OutputRowGetApproveRole
	Set Data=$lb(Desc,ApproveRoleDR,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetApproveRole
	Set (Desc,Code)=""
	Quit
}

ClassMethod GetApproveRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveRoleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApproveRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 20140409  Mozy0125
/// 审批角色过滤
/// SourceType:业务类型		SourceID:业务主单ID
/// ApproveRoleDR:角色
/// w ##class(web.DHCEQApprove).CheckApproveRole(5,7170,10,63284,63286)
ClassMethod CheckApproveRole(SourceType As %String = "", SourceID As %String = "", ApproveRoleDR As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	If (ApproveRoleDR="") Quit 0
	new (SourceType,SourceID,ApproveRoleDR,StartDate,EndDate)
	;s ^DHCEQMozy("CheckApproveRole")=SourceType_","_SourceID_","_ApproveRoleDR_","_StartDate_","_EndDate
	;select * from DHC_EQApproveList where al_approvetypedr=5 order by al_sourceid
	;遍历该报废单的审核信息
	Set Flag=1
	Set ApproveListDR=0
	For  Set ApproveListDR=$Order(^DHCEQApproveList(0,"Source",SourceType,SourceID,ApproveListDR)) Quit:(ApproveListDR="")||(Flag=0)  Do
	.Quit:(ApproveRoleDR'="")&(ApproveRoleDR'=$Piece($Get(^DHCEQApproveList(ApproveListDR)),"^",5))
	.Set ApproveDate=$Piece($Get(^DHCEQApproveList(ApproveListDR)),"^",7)
	.Quit:((StartDate'="")&(ApproveDate<StartDate))
	.Quit:((EndDate'="")&(ApproveDate>EndDate))
	.Set Flag=0
	
	Quit Flag
}

/// add by zy 2016-02-18
/// 把业务提交,审核,取消提交中处理DHC_EQApproveInfo的内容集中到一起处理.
/// 
/// w ##class(web.DHCEQApprove).SaveApproveInfo(37,123,18,1,"","",1)
ClassMethod SaveApproveInfo(ApproveSet, SourceID, NextRole, NextStep, RoleStep, CurRole, Status, CancelFlag As %String = "N", CanceToFlowlFlag As %String = "")
{
	new ApproveType,ApproveInfoID
	new LocID,EquipTypeID,SatatCatID,EquipCatID,ItemID,EquipID,AccessoryTypeID,ToLocID,SubType,MakerID
	s (ApproveType,ApproveInfoID)=""
	s (LocID,EquipTypeID,SatatCatID,EquipCatID,ItemID,EquipID,AccessoryTypeID,ToLocID,SubType,MakerID)="" 
	k AppInfo
	s ApproveType=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",1)
	Set AppInfo(2)=ApproveType
	Set AppInfo(3)=SourceID
	Set AppInfo(4)=ApproveSet
	Set AppInfo(5)=NextRole
	Set AppInfo(6)=NextStep
	Set AppInfo(7)=RoleStep			;ApproveStatus  当前审核步骤
	Set AppInfo(8)=CurRole			;ApproveRoleDR
	Set AppInfo(9)=Status			;Status
	
	d GetBussInfo
	Set AppInfo(10)=LocID			;AI_LocDR
	Set AppInfo(11)=EquipTypeID		;AI_EquipTypeDR
	Set AppInfo(12)=SatatCatID		;AI_StatCatDR
	Set AppInfo(13)=EquipCatID		;AI_EquipCatDR
	Set AppInfo(14)=ItemID			;AI_ItemDR
	Set AppInfo(15)=EquipID			;AI_EquipDR
	Set AppInfo(16)=AccessoryTypeID	;AI_AccessoryTypeDR
	Set AppInfo(17)=ToLocID			;AI_ToLocDR
	Set AppInfo(18)=SubType			;AI_SubType
	Set AppInfo(19)=""			;AI_BussInvalidFlag
	Set AppInfo(20)=""			;AI_UserDR
	if CancelFlag="Y" Set AppInfo(20)=MakerID	
	Set AppInfo(21)=CanceToFlowlFlag	;AI_Hold1 //modified by WY 2022-9-14 传回置标记给ApproveInfo
	Set AppInfo(22)=""			;AI_Hold2 
	Set AppInfo(23)=""			;AI_Hold3
	Set AppInfo(24)=""			;AI_Hold4
	Set AppInfo(25)=""			;AI_Hold5
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
	If ApproveInfoID=""
 	{
	 	&SQL(insert into sqluser.DHC_EQApproveInfo values :AppInfo())		
 	}
 	Else
 	{
		&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_RowID=:ApproveInfoID)		
 	}
 	Quit SQLCODE
 	
GetBussInfo
	;ApproveType
	;1	采购申请,2	采购计划,3	设备论证,4	采购审批,5	报废申请,6	调试验收,7	开箱验收,8	采购合同,9	委外申请,
	;10	备件入库,11	备件转移,12	年度计划分配,13	设备入库,14	设备转移,15	退货,16	设备维修,17	招标审批设置,18	工程管理,19	付款审批,
	;20	研究课题,21	备件退货,22	洗涤单,23	销毁更换单,24	车辆派遣,25	新设备维修,26	综合使用评价表,27	技术评估表,28	评价调查表,29	不良事件表,30	租赁管理,
	;36 设备拆分
 	if ApproveType=1
	{
		s LocID=$p($g(^DHCEQBuyRequest(SourceID)),"^",2)
		s EquipTypeID=$p($g(^DHCEQBuyRequest(SourceID)),"^",25)
		s MakerID=$p($g(^DHCEQBuyRequest(SourceID)),"^",10)
		
		s BuyRequestListID=$o(^DHCEQBuyRequestList(0,"BuyRequest",SourceID,""))
		i BuyRequestListID'="" d
		.s SatatCatID=$p($g(^DHCEQBuyRequestList(BuyRequestListID)),"^",25)
		.s EquipCatID=$p($g(^DHCEQBuyRequestList(BuyRequestListID)),"^",15)
		.s ItemID=$p($g(^DHCEQBuyRequestList(BuyRequestListID)),"^",17)
	}
	elseif ApproveType=2
	{
		s EquipTypeID=$p($g(^DHCEQBuyPlan(SourceID)),"^",12)
		s MakerID=$p($g(^DHCEQBuyPlan(SourceID)),"^",13)
	}
	elseif ApproveType=3
	{
		
	}
	elseif ApproveType=4
	{
		
	}
	elseif ApproveType=5
	{
		s LocID=$p($g(^DHCEQDisuseRequest(SourceID)),"^",3)
		s EquipTypeID=$p($g(^DHCEQDisuseRequest(SourceID)),"^",43)
		s MakerID=$p($g(^DHCEQDisuseRequest(SourceID)),"^",17)
	}
	elseif ApproveType=6
	{
		
	}
	elseif ApproveType=7
	{
		s OpenCheckListDR=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,""))
		i OpenCheckListDR'="" d
		.s EquipTypeID=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",3)
		.s SatatCatID=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",28)
		.s EquipCatID=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",6)
		.s ItemID=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",9)
		.s LocID=$p($g(^DHCEQOpenCheckList(OpenCheckListDR)),"^",33)
		s MakerID=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",22)
	}
	elseif ApproveType=8
	{
		s LocID=$p($g(^DHCEQContract(SourceID)),"^",8)
		s MakerID=$p($g(^DHCEQContract(SourceID)),"^",26)
	}
	elseif ApproveType=9
	{
		
	}
	elseif ApproveType=10
	{
		s LocID=$p($g(^DHCEQAInStock(SourceID)),"^",3)
		s MakerID=$p($g(^DHCEQAInStock(SourceID)),"^",20)
		s AccessoryTypeID=$p($g(^DHCEQAInStock(SourceID)),"^",2)
	}
	elseif ApproveType=11
	{
		Set LocID=$p($g(^DHCEQAMoveStock(SourceID)),"^",4)
		Set ToLocID=$p($g(^DHCEQAMoveStock(SourceID)),"^",5)
	    Set MakerID=$p($g(^DHCEQAMoveStock(SourceID)),"^",11)
	    Set AccessoryTypeID=$p($g(^DHCEQAMoveStock(SourceID)),"^",2)
	}
	elseif ApproveType=12
	{
		
	}
	elseif ApproveType=13
	{
	 	s LocID=$p($g(^DHCEQInStock(SourceID)),"^",2)
	 	s EquipTypeID=$p($g(^DHCEQInStock(SourceID)),"^",20)
		s SatatCatID=$p($g(^DHCEQInStock(SourceID)),"^",21)
		s MakerID = $p($g(^DHCEQInStock(SourceID)),"^",4)
	}
	elseif ApproveType=14
	{
		Set LocID=$p($g(^DHCEQStoreMove(SourceID)),"^",2)			
	    Set EquipTypeID=$p($g(^DHCEQStoreMove(SourceID)),"^",16)		
	    Set SatatCatID=$p($g(^DHCEQStoreMove(SourceID)),"^",17)	
	    Set ToLocID=$p($g(^DHCEQStoreMove(SourceID)),"^",3)
	    Set MakerID=$p($g(^DHCEQStoreMove(SourceID)),"^",4)
	}
	elseif ApproveType=15
	{
		Set LocID=$p($g(^DHCEQReturn(SourceID)),"^",2)			
	    Set EquipTypeID=$p($g(^DHCEQReturn(SourceID)),"^",15)		
	    Set SatatCatID=$p($g(^DHCEQReturn(SourceID)),"^",16)
	    Set MakerID=$p($g(^DHCEQReturn(SourceID)),"^",5)
	}
	elseif ApproveType=16
	{
		
	}
	elseif ApproveType=17
	{
		Set MakerID=$p($g(^DHCEQIFB(SourceID)),"^",44)
	}
	elseif ApproveType=18
	{
		
	}
	elseif ApproveType=19
	{
		
	}
	elseif ApproveType=20
	{
		
	}
	elseif ApproveType=21
	{
		s LocID=$p($g(^DHCEQAReduce(SourceID)),"^",4)
		s ToLocID=$p($g(^DHCEQAReduce(SourceID)),"^",5)
		s MakerID=$p($g(^DHCEQAReduce(SourceID)),"^",12)
		s AccessoryTypeID=$p($g(^DHCEQAReduce(SourceID)),"^",2)
	}
	elseif ApproveType=22
	{
		
	}
	elseif ApproveType=23
	{
		
	}
	elseif ApproveType=24
	{
		
	}
	elseif ApproveType=25
	{
		s (ExObjDR,SourceTypeID)=""
	 	s LocID=$p($g(^DHCEQMMaintRequest(SourceID)),"^",6)
	 	s EquipTypeID=$p($g(^DHCEQMMaintRequest(SourceID)),"^",3)	
		s ExObjDR = $p($g(^DHCEQMMaintRequest(SourceID)),"^",5)
		s SourceTypeID=$p($g(^DHCEQMMaintRequest(SourceID)),"^",63)
		i ExObjDR '=""  d
		.i (SourceTypeID=1)||(SourceTypeID=2)  d  //add by zx 2017-03-20 BUG ZX0036
		..s EquipID=$p($g(^DHCEQMExObj(ExObjDR)),"^",5)
		..i EquipID'=""  d
		...s SatatCatID=$p($g(^DHCEQEquip(EquipID)),"^",75)
		...s EquipCatID=$p($g(^DHCEQEquip(EquipID)),"^",4)
		...s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7)
		.e  d
		..
		Set MakerID = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",42)
	}
	elseif ApproveType=26
	{
		
	}
	elseif ApproveType=27
	{
		
	}
	elseif ApproveType=28
	{
		
	}
	elseif ApproveType=29
	{
		
	}
	elseif ApproveType=30  //add by zx 2016-11-03 ZX0036 处理租赁的ApproveInfo
	{
		//add by zx 2020-02-13 租赁表修改
		s LocID=$p($g(^DHCEQSRent(SourceID)),"^",2)
		s ItemID=$p($g(^DHCEQSRent(SourceID)),"^",7)
		i ItemID'="" d
		.s EquipTypeID=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",3)
		.s SatatCatID=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",4)
		.s EquipCatID=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemID)),"^",5)
		s ShareResourceID=$p($g(^DHCEQSRent(SourceID)),"^",9)
		i ShareResourceID'="" s EquipID=$p($g(^DHCEQSShareResource(ShareResourceID)),"^",3)
		s ToLocID=$p($g(^DHCEQSRent(SourceID)),"^",3)
		s MakerID=$p($g(^DHCEQSRent(SourceID)),"^",4)
	}
	elseif ApproveType=31  //add by zx 2017-02-06 设备配送 Bug ZX0038
	{
		s ObjType=$p($g(^DHCEQMove(SourceID)),"^",2)
		s EquipID=$p($g(^DHCEQMove(SourceID)),"^",3)
		i EquipID'="" d
		.s EquipTypeID=$p($g(^DHCEQEquip(EquipID)),"^",63)
		.s SatatCatID=$p($g(^DHCEQEquip(EquipID)),"^",75)
		.s EquipCatID=$p($g(^DHCEQEquip(EquipID)),"^",4)
		.s ItemID=$p($g(^DHCEQEquip(EquipID)),"^",7) 
		s MakerID=$p($g(^DHCEQMove(SourceID)),"^",23)
	}
	elseif ApproveType=32  //add by zx 2017-07-05 发票审批处理
	{
		s MakerID = $p($g(^DHCEQInvoice(SourceID)),"^",22)
	}
	elseif ApproveType=33  //设备鉴定报告表	Mozy0226	2019-9-22
	{
		s EquipID=$p($g(^DHCEQAppraisalReport(SourceID)),"^",2)
		s ItemID = $p($g(^DHCEQEquip(EquipID)),"^",7)
		s EquipTypeID = $p($g(^DHCEQEquip(EquipID)),"^",63)
		s SatatCatID = $p($g(^DHCEQEquip(EquipID)),"^",75)
		s EquipCatID = $p($g(^DHCEQEquip(EquipID)),"^",4)
		s LocID = $p($g(^DHCEQAppraisalReport(SourceID)),"^",5)
		s MakerID = $p($g(^DHCEQAppraisalReport(SourceID)),"^",18)
	}
	elseif ApproveType=36  //设备拆分 czf 2014955 2021-07-04
	{
		s EquipID=$p($g(^DHCEQSplit(SourceID)),"^",2)
		s ItemID = $p($g(^DHCEQEquip(EquipID)),"^",7)
		s EquipTypeID = $p($g(^DHCEQSplit(SourceID)),"^",8)
		s SatatCatID = $p($g(^DHCEQSplit(SourceID)),"^",9)
		s EquipCatID = $p($g(^DHCEQSplit(SourceID)),"^",10)
		s LocID = $p($g(^DHCEQSplit(SourceID)),"^",11)
		s MakerID = $p($g(^DHCEQSplit(SourceID)),"^",23)
	}
	q
}

}
