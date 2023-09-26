/// Description:  项目限额管理
/// Created by wangguoying
Class web.DHCPE.ArcimPreManager Extends %RegisteredObject
{

/// Descript:获取项目分类json树
/// Input:
/// 					ARCIMDR:ARC_ItmMast
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2020-03-17
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetArcimTree("")
ClassMethod GetArcimTree(ARCIMDesc = "", CurDate = "", LocID = "")
{
	Set ^tmpwgy("GetArcimTree")=ARCIMDesc	
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	Set ^tmpwgy("GetArcimTree")=$LISTBUILD(ARCIMDesc,CurDate,LocID)	
	If CurDate="" Set CurDate=+$HOROLOG
	Set rootList=""
	If ARCIMDesc'="" 
	{
		Set rootList=..GetRootByARCIMDesc(LocID,ARCIMDesc)
		Set:rootList="" rootList="^"  ;过滤医嘱项未检索到任何节点的情况
	}
	Set TreeObj=##class(web.DHCPE.ArcimManager.Entity.TreeNode).%New()
	Set TreeObj.id="root"
	Set TreeObj.text="全部"
	Set TreeObj.text=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.arcimpremanager.csp",TreeObj.text)
	Do ..SetChildrenNode(TreeObj,rootList,LocID)
	Set extJson=##class(web.DHCPE.Utils.JsonObject).%New()
	Do extJson.FromObject(TreeObj)
	Quit "["_extJson.Json()_"]"
}

/// Descript:递归设置子节点集合
/// Input:
/// 					RootNode:根节点
/// 						RootList:限定的节点ID集合(^节点ID^节点ID^)
/// Return: 
/// Creater:	wangguoying
/// CreateDate:	2020-03-17
/// Debug: w ##class(web.DHCPE.ArcimPreManager).SetChildrenNode()
ClassMethod SetChildrenNode(ByRef RootNode As %ObjectHandle, RootList As %String = "", LocID = "")
{
	Set rootId=RootNode.id
	If rootId="root" Set rootId=""
	Set id=""
	For  Set id=$ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_rootId,id)) Quit:id=""  Do
	.Break ;1
	.Quit:(RootList'="")&&(RootList'[("^"_id_"^"))
	.Quit:(LocID'="")&&($LISTGET(^User.DHCPEArcimPreTreeD(id),11)'=LocID)
	.Set childObj=##class(web.DHCPE.ArcimManager.Entity.TreeNode).%New()
	.Set childObj.id=id
	.Set childObj.code=$LISTGET(^User.DHCPEArcimPreTreeD(id),2)
	.Set childObj.text=$LISTGET(^User.DHCPEArcimPreTreeD(id),3)
	.Set:childObj.text'="" childObj.text=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEArcimPreTree",childObj.text,"APTDesc","cls")
	.Set childObj.desc=$LISTGET(^User.DHCPEArcimPreTreeD(id),3)
	.Set:childObj.desc'="" childObj.desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEArcimPreTree",childObj.desc,"APTDesc","cls")
	.Set childObj.type=$LISTGET(^User.DHCPEArcimPreTreeD(id),5)
	.Set:childObj.type="A" childObj.iconCls="icon-star"
	.Set:childObj.type="D" childObj.iconCls="icon-doctor"
	.Set childObj.sourceId=$LISTGET(^User.DHCPEArcimPreTreeD(id),6)
	.Set conditionSub=$ORDER(^User.DHCPEArcimPreTreeD(id,"APTCondition",0))
	.Set conditionObj=##class(web.DHCPE.HM.Entity.NodeCondition).%New()
	.Set conditionObj.sexId=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),2)
	.Set conditionObj.minAge=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),3)
	.Set conditionObj.maxAge=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),4)
	.Set conditionObj.vipLevel=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),5)
	.Set childObj.text=childObj.text_..GetConditionDesc(id_"||"_conditionSub)
	.Set childObj.condition=conditionObj
	.Do ..SetChildrenNode(.childObj)
	.Do RootNode.children.Insert(childObj)
	Quit 0
}

/// Descript:根据医嘱名称查询节点(模糊查询)
/// Input:
/// 					ARCIMDesc:医嘱项名称
/// Return: 节点ID^节点ID
/// Creater:	wangguoying
/// CreateDate:	2020-03-27
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetNodeByARCIMDesc("心电")
ClassMethod GetNodeByARCIMDesc(LocID, ARCIMDesc)
{
	//s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
	Set nodeList=""
	Set arcimId=""
	For  Set arcimId=$ORDER(^User.DHCPEArcimPreTreeI("LocTypeSourceIndex",LocID,$CHAR(32)_"A",arcimId))  Quit:arcimId=""  Do
	.Set factArcim=$REPLACE(arcimId,$CHAR(32),"")
	.Set arcimDesc=$PIECE(^ARCIM(+factArcim,$PIECE(factArcim,"||",2),1),"^",2)
	.Quit:arcimDesc'[ARCIMDesc
	.Set id=""
	.For  Set id=$ORDER(^User.DHCPEArcimPreTreeI("LocTypeSourceIndex",LocID,$CHAR(32)_"A",arcimId,id))  Quit:id=""  Do
	..Set:nodeList'="" nodeList=nodeList_"^"_id
	..Set:nodeList="" nodeList=id
	Quit nodeList
}

/// Descript:根据医嘱名称查询医嘱项所在的根节点(模糊查询)
/// Input:
/// 					ARCIMDesc:医嘱项名称
/// Return: ^节点ID^节点ID^
/// Creater:	wangguoying
/// CreateDate:	2020-03-27
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRootByARCIMDesc("心电")
ClassMethod GetRootByARCIMDesc(LocID, ARCIMDesc)
{
	Set nodeList=..GetNodeByARCIMDesc(LocID,ARCIMDesc)
	Quit:nodeList="" ""
	Set rootList="^"
	For i=1:1:$LENGTH(nodeList,"^")
	{
		Set nodeId=$PIECE(nodeList,"^",i)
		Set root=..GetRootNode(nodeId)
		Quit:rootList[("^"_root_"^")
		Set rootList=rootList_root_"^"
	}
	Quit rootList
}

/// Descript:更新节点数据
/// Input:
/// 					ID:节点ID
/// 					ValueStr:APTCode^APTDesc^APTParentNode^APTType^APTSourceDR^APTRemark^APTUpdateUserDR$C(0)APCSexDR^APCMinAge^APCMaxAge^APCVIPLevel^APCUpdateUserDR
/// Return: 0：成功 , 非0：失败
/// Creater:	wangguoying
/// CreateDate:	2020-03-18
/// Debug: w ##class(web.DHCPE.ArcimPreManager).UpdateTreeNode("","cswj^超声胃镜检查术^4^A^4296||1^^11849"_$c(0)_"^60^^1^11849")
ClassMethod UpdateTreeNode(ID As %String = "", ValueStr As %String, LocID = "")
{
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	Set ^tmpwgy("UpdateTreeNode")=$LISTBUILD(ID,ValueStr)
	Set nodeStr="APTCode^APTDesc^APTParentNode^APTType^APTSourceDR^APTRemark^APTUpdateUserDR^APTUpdateDate^APTUpdateTime^APTLocDR"
	Set conditionStr="ANCParRef^APCSexDR^APCMinAge^APCMaxAge^APCVIPLevel^APCUpdateUserDR^APCUpdateDate^APCUpdateTime"
	Set childVal=$PIECE(ValueStr,$CHAR(0),2)
	Set ValueStr=$PIECE(ValueStr,$CHAR(0),1)
	Set code = $PIECE(ValueStr,"^",1)
	Set parentId = $PIECE(ValueStr,"^",3)
	Set nodeType = $PIECE(ValueStr,"^",4)
	Set sourceId = $PIECE(ValueStr,"^",5)
	Set existId = $ORDER(^User.DHCPEArcimPreTreeI("CodeIndex",$ZCONVERT(code,"U"),""))
	If (existId'="")&&((ID="")||(ID'=existId)) Quit "-1^代码已存在！" 
	
	If nodeType = "A"
	{
		Set existId = ..GetArcimTreeID(parentId,sourceId)
		If (existId'="")&&((ID="")||(ID'=existId)) Quit "-1^同层级下该医嘱已存在！" 
	}
	
	Tstart
	Set curDate=+$HOROLOG
	Set curTime=$PIECE($HOROLOG,",",2)
	Set ValueStr=ValueStr_"^"_curDate_"^"_curTime_"^"_LocID
	Set ret=##class(User.DHCPEArcimPreTree).SaveData(ID,ValueStr,nodeStr)
	If +ret<0  Trollback  Quit ret
	Set ID=+ret
	Set Parent=$LISTGET(^User.DHCPEArcimPreTreeD(ID),4)
	Set childSub=$ORDER(^User.DHCPEArcimPreTreeD(ID,"APTCondition",0)) 
	Set childId=""
	Set:childSub'="" childId=ID_"||"_childSub	
	Set conditionStr=conditionStr_"^"_curDate_"^"_curTime
   	Set ret=##class(User.DHCPEArcimNodeCondition).SaveData(childId,ID_"^"_childVal,conditionStr)
	If +ret<0  Trollback  Quit ret 
	Set ret=..ConditionCompare(Parent,ID)
	If ret'=1  Trollback  Quit "-1^与父节点条件冲突，请核实！"
	Set child=""
	For  Set child=$ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_ID,child)) Quit:(child="")||(ret'=1)  Do
	.Set ret=..ConditionCompare(ID,child)
	If ret'=1  Trollback  Quit "-1^与子节点条件冲突，请核实！"
	Tcommit
	Quit 0
}

/// Descript:根据父节点 查找医嘱项对应节点ID
/// Input:
/// 					ParentID: 父节点Id
/// 					ArcimID：医嘱项ID
/// Return:     节点ID
/// Creater:	wangguoying
/// CreateDate:	2020-03-17
/// Debug: w ##class(web.DHCPE.ArcimPreManager).DelTreeNode()
ClassMethod GetArcimTreeID(ParentID, ArcimID)
{
	Quit:ParentID="" ""
	Set locId = $LISTGET(^User.DHCPEArcimPreTreeD(ParentID),11)
	Set id = "",ret=""
	For  Set id = $ORDER(^User.DHCPEArcimPreTreeI("LocTypeSourceIndex",locId," A",$CHAR(32)_ArcimID,id),-1) Quit:(id="")||(ret'="")  Do
	.Set curParent = $LISTGET(^User.DHCPEArcimPreTreeD(id),4)
	.Quit:curParent'=ParentID
	.Set ret = id
	Quit ret
}

/// Descript:删除节点
/// Input:
/// 					NodeID:节点Id
/// Return: 0^成功 非0^失败
/// Creater:	wangguoying
/// CreateDate:	2020-03-17
/// Debug: w ##class(web.DHCPE.ArcimPreManager).DelTreeNode()
ClassMethod DelTreeNode(NodeId, UserID = "")
{
	Set ^tmpwgy("DelTreeNode")=$LISTBUILD(NodeId, UserID )
	Set err = ""
	Tstart
	Set locId = ""
	For  Set locId = $ORDER(^User.DHCPEArcimPreManagerI("NodeLocDateIndex",NodeId,locId))  Quit:(locId="")||(err'="")  Do
	.Set date = ""
	.For  Set date = $ORDER(^User.DHCPEArcimPreManagerI("NodeLocDateIndex",NodeId,locId,date))  Quit:(date="")||(err'="")  Do
	..Set apmId = ""
	..For  Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("NodeLocDateIndex",NodeId,locId,date,apmId))  Quit:(apmId="")||(err'="")  Do
	...Break
	...Set oldInfo = ##class(User.DHCPEArcimPreManager).%OpenId(apmId).ToString() 
	...Do ..Log("D",apmId,oldInfo_"^","删除节点，同步删除排班",UserID)
	...Set ret = ##class(User.DHCPEArcimPreManager).Delete(apmId)
	...If +ret'=0 Set err = ret
	
	
	If err'="" Trollback  Quit err
	Set ret = ##class(User.DHCPEArcimPreTree).Delete(NodeId)
	If +ret'=0  Trollback  Quit ret
	Tcommit
	Quit 0
}

ClassMethod GetConditionDesc(ConditionId)
{
	Set SexTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.arcimpremanager.detail.csp","性别")
	Set AgeTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.arcimpremanager.detail.csp","年龄")
	Set AgeAboveTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.arcimpremanager.detail.csp","岁以上")
	Set AgeUnderTemp=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpe.arcimpremanager.detail.csp","岁以下")
	Quit:ConditionId="" "" ;"性别":<font style='font-size:small' color='#339eff'>不限</font>  年龄:<font style='font-size:small' color='#339eff'>不限</font>"
	Set sexDesc="",AgeDesc="",vipDesc=""
	Set sexId=$LISTGET(^User.DHCPEArcimPreTreeD(+ConditionId,"APTCondition",$PIECE(ConditionId,"||",2)),2)
	If sexId'=""
	{
		Set sexDesc=$PIECE(^CT("SEX",sexId),"^",2)
		Set:sexDesc'="" sexDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",sexDesc,"CTSEXDesc","cls")
		Set sexDesc=SexTemp_":<font style='font-size:small' color='#339eff'>"_sexDesc_"</font>"
	}
	Set minAge=$LISTGET(^User.DHCPEArcimPreTreeD(+ConditionId,"APTCondition",$PIECE(ConditionId,"||",2)),3)
	Set maxAge=$LISTGET(^User.DHCPEArcimPreTreeD(+ConditionId,"APTCondition",$PIECE(ConditionId,"||",2)),4)
	If (minAge'="")||(maxAge'=""){
		Set AgeDesc=AgeTemp_":<font style='font-size:small' color='#339eff'>"
		If minAge="" Set AgeDesc=AgeDesc_maxAge_AgeUnderTemp_"</font>"
		e  If maxAge=""  Set AgeDesc=AgeDesc_minAge_AgeAboveTemp_"</font>"
		e  Set AgeDesc=AgeDesc_minAge_"-"_maxAge_"</font>"
	}
	
	Set vipLevel=$LISTGET(^User.DHCPEArcimPreTreeD(+ConditionId,"APTCondition",$PIECE(ConditionId,"||",2)),5)
	If vipLevel'=""
	{
		Set vipDesc=$LISTGET(^CT.PE.VIPLevelD(vipLevel),3)
		Set:vipDesc'="" vipDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",vipDesc,"VLDesc","cls")
		Set vipDesc="<b><font style='font-size:smaller' color='red'>"_vipDesc_"</font></b>"
	}
	Quit:(sexDesc="")&&(AgeDesc="")&&(vipDesc="") ""
	Quit "   <font style='font-size:smaller'>("_sexDesc_" "_AgeDesc_" "_vipDesc_")</font>"
}

/// 递归未加条件，暂时不用 
ClassMethod ConditionIsVaild(NodeID)
{
	Set ret=1
	Set childNode=""
	For  Set childNode=$ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",NodeID,childNode))  Quit:(childNode="")||(ret=0)  Do
	.Set ret=..ConditionIsVaild(NodeID)
	Quit ret
}

/// Descript:判断父子节点的条件是否匹配
/// Input:
/// 					Parent:父节点ID
/// 					Child:子节点ID
/// Return: 0：不匹配  , 1：匹配
/// Creater:	wangguoying
/// CreateDate:	2020-03-18
/// Debug: w ##class(web.DHCPE.ArcimPreManager).ConditionCompare("1","2")
ClassMethod ConditionCompare(Parent, Child)
{
	Quit:Parent="" 1
	Set parentSub=$ORDER(^User.DHCPEArcimPreTreeD(Parent,"APTCondition",0))
	Quit:parentSub="" 1 ;父节点没有条件肯定匹配
	Set childSub=$ORDER(^User.DHCPEArcimPreTreeD(Child,"APTCondition",0))
	Quit:parentSub="" 0 ;父节点有条件，子节点无条件 肯定不匹配(不考虑各种不限)
	Set parentSex=$LISTGET(^User.DHCPEArcimPreTreeD(Parent,"APTCondition",parentSub),2)
	Set childSex=$LISTGET(^User.DHCPEArcimPreTreeD(Child,"APTCondition",childSub),2)
	Quit:(parentSex'="")&&(((childSex'="")&&(parentSex'=childSex))||(childSex="")) 0
	Set parentVip=$LISTGET(^User.DHCPEArcimPreTreeD(Parent,"APTCondition",parentSub),5)
	Set childVip=$LISTGET(^User.DHCPEArcimPreTreeD(Child,"APTCondition",childSub),5)
	Quit:(parentVip'="")&&(((childVip'="")&&(parentVip'=childVip))||(childVip="")) 0
	Set parentMinAge=$LISTGET(^User.DHCPEArcimPreTreeD(Parent,"APTCondition",parentSub),3)
	Set parentMaxAge=$LISTGET(^User.DHCPEArcimPreTreeD(Parent,"APTCondition",parentSub),4)
	Set childMinAge=$LISTGET(^User.DHCPEArcimPreTreeD(Child,"APTCondition",childSub),3)
	Set childMaxAge=$LISTGET(^User.DHCPEArcimPreTreeD(Child,"APTCondition",childSub),4)
	Set:parentMinAge="" parentMinAge=0
	Set:parentMaxAge="" parentMaxAge=9999
	Set:childMinAge="" childMinAge=0
	Set:childMaxAge="" childMaxAge=9999
	Quit:(childMinAge<parentMinAge)||(childMaxAge>parentMaxAge) 0
	Quit 1
}

/// Description:获取节点所在分支的根
/// Input:
/// 					NodeID:节点ID
/// Return: 根节点ID
/// Creater:	wangguoying
/// CreateDate:	2020-03-18
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRootNode("1")
ClassMethod GetRootNode(NodeID)
{
	Set root=""
	While(root="")
	{
		Set parentId=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID),4)
		If parentId="" Set root=NodeID 
		e  Set NodeID=parentId
	}
	Quit root
}

/// Description:获取节点剩余名额 返回当前节点往上所有父节点的可用余额最小值
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return: 
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetWeekNumByNode("1",+$H,304)
ClassMethod GetNodeAvailNum(NodeID, Date, LocID = "")
{
	If LocID=""
	{
		Set:$DATA(%session) LocID=%session.Get("LOGON.CTLOCID")
		Set:LocID="" LocID=304
	}
	
	Set mNum = ..GetNodeManagerNum(NodeID,Date,LocID)
	Set regNum = 0 
	Set nodeType = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),5)
	If nodeType = "D"
	{
		Set doctorId = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),6)
		Set regNum = ..GetRegNumByDoctor(doctorId,LocID,Date)
	}Else{
		Set regNum = ..GetRegNumByNode(NodeID,LocID,Date)
	}
	Set avaliNum = mNum - regNum
	Set parentId = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),4)
	If parentId'=""
	{
		Set parentAvailNum = ..GetNodeAvailNum(parentId,Date,LocID)
		Set avaliNum = $CASE(parentAvailNum<avaliNum,"1":parentAvailNum,:avaliNum)
	}
	Quit avaliNum
}

/// Description:获取指定节点的子节点限额之和（指定节点未设置限额时调用）
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return: 	
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetChildrenTotal("1",+$H,304)
ClassMethod GetChildrenTotal(NodeID, Date, LocID = "")
{
	Set ret = 0
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	Set child = ""
	For  Set child = $ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_NodeID,child)) Quit:child=""  Do
	.Set num = 0
	.Set ampId = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,child,Date,""))
	.If ampId = ""  Set num = ..GetChildrenTotal(child,Date,LocID)
	.e  Set num = $LISTGET(^User.DHCPEArcimPreManagerD(ampId),5)
	.Set ret = ret + num 
	Quit ret
}

/// Description:获取节点的限额数量 
/// 				如果当前节点维护了限额，则返回当前限额
/// 				如果当前节点未维护限额，取出向上节点取出第一个维护限额的数量A,向下取子节点限额数量之和B
/// 					向上父节点都未维护限额时， 返回B，
/// 					向下未维护子节点时，返回A    反之返回A和B的最小值
/// 					
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return: 	限额ID
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetNodeManagerNum("1",+$H,304)
ClassMethod GetNodeManagerNum(NodeID, Date, LocID = "")
{
	Set ret = 0
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,NodeID,Date,""))
	Quit:apmId'="" $LISTGET(^User.DHCPEArcimPreManagerD(apmId),5)  //当前节点设置了限额 直接返回
	Set childNum = ..GetChildrenTotal(NodeID,Date,LocID)
	Set managerId = ..GetNodeManagerID(NodeID, Date, LocID)
	If managerId="" Quit childNum //向上未维护限额时，返回子节点限额之和
	Set parentNum = $LISTGET(^User.DHCPEArcimPreManagerD(managerId),5) 
	If '$DATA(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_NodeID))  Quit parentNum
	Set ret = $CASE(parentNum<childNum,"1":parentNum,:childNum)
	Quit ret
}

/// Description:获取节点设置的限额ID （如果当前节点无限额，则向上找父节点）
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return: 	限额ID
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetWeekNumByNode("1",+$H,304)
ClassMethod GetNodeManagerID(NodeID, Date, LocID = "")
{
	If LocID=""
	{
		Set:$DATA(%session) LocID=%session.Get("LOGON.CTLOCID")
		Set:LocID="" LocID=304
	}
	Set parentNodeId = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),4)
	Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,NodeID,Date,""))
	While(apmId="")&&(parentNodeId'=""){
		Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,parentNodeId,Date,""))
		Set parentNodeId = $LISTGET(^User.DHCPEArcimPreTreeD(parentNodeId),4)
	}
	Quit apmId
}

/// Description:获取节点预约数量 （节点为自定义类型时，预约数量为子节点之和；节点为医嘱项时，预约数量即该医嘱预约数量）
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical				
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByARCIM("9",66458,105)
ClassMethod GetRegNumByNode(NodeID, LocID, Date)
{
	//q:NodeID=10 25 
	//q:NodeID=30 3
	Set ret = 0
	Set type = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),5)
	If type = "A"
	{
		Set arcim = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),6)
		Set ret = ..GetRegNumByARCIM(arcim,LocID,Date,NodeID)
	}ElseIf type = "D"{
		Set doctorId = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),6)
		Set ret = ..GetRegNumByDoctor(doctorId,LocID,Date)
	}
	ElseIf type = "S"{
		Set child = ""
		For  Set child = $ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_NodeID,child)) Quit:child=""  Do
		.Set ret = ret + ..GetRegNumByNode(child,LocID,Date)
	}
	Quit ret
}

/// Description:获取医嘱预约 数量
/// Input:
/// 					ARCIMDR：医嘱ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// 					NodeID:节点ID 为空时查询医嘱全部条件下的数量
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByARCIM("4390||1",304,65283,28)
ClassMethod GetRegNumByARCIM(ARCIMDR, LocID, Date, NodeID As %String = "")
{
	Set regNum=0,netBusIds="",piadmIds=""
	// 线上预约且未同步至体检系统的记录
	Set regNum = regNum + ..GetOnlyNetRegNum(ARCIMDR, LocID, Date, NodeID)	
	
	// 预约未登记的
	Set regNum = regNum + ..GetNoRegisterRegNum(ARCIMDR, LocID, Date, NodeID)	
	// 登记或到达的
	Set regNum = regNum + ..GetRegisteredRegNum(ARCIMDR, LocID, Date, NodeID)		
	Quit regNum
}

/// Description:获取医嘱预约数量  (线上预约且未同步至体检系统的记录)
/// Input:
/// 					ARCIMDR：医嘱ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// 					NodeID:节点ID 为空时查询医嘱全部条件下的数量
/// 						BusIDSFlag:业务ID标记，为Y时返回业务ID集合，上箭头分割 
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetOnlyNetRegNum("1",+$H,304)
ClassMethod GetOnlyNetRegNum(ARCIMDR, LocID, Date, NodeID As %String = "", BusIDSFlag = "N")
{
	Set regNum=0,sexDr="",vipLevel="",minAge=0,maxAge=999,busIds = "^"
	If NodeID'="" Do
	.Set childSub=$ORDER(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",0))
	.If childSub'=""
	..Set sexDr=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),2)
	..Set minAge=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),3)
	..Set maxAge=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),4)
	..Set vipLevel=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),5)
	
	//线上预约  未生成业务记录
	Set netpid = ""
	For  Set netpid = $ORDER(^User.DHCPENetPreRecordI("PreDateIndex",Date,netpid))  Quit:netpid=""  Do 
	.Set status = $LISTGET(^User.DHCPENetPreRecordD(netpid),7)
	.Quit:status'=0
	.Set netpreiadm = $LISTGET(^User.DHCPENetPreRecordD(netpid),13)
	.Quit:netpreiadm'=""
	.Set locId = $LISTGET(^User.DHCPENetPreRecordD(netpid),17)
	.Quit:locId'=LocID
	.Set curSex = $LISTGET(^User.DHCPENetPreRecordD(netpid),4)
	.Quit:(sexDr'="")&&(sexDr'=curSex)
	.Set levelDesc = $LISTGET(^User.DHCPENetPreRecordD(netpid),16)
	.Set curVIP = ##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(levelDesc)
	.Quit:(vipLevel'="")&&(curVIP'=levelDesc)
	.Set curAge = $LISTGET(^User.DHCPENetPreRecordD(netpid),5)
	.Quit:(curAge<minAge)||(curAge>maxAge)
	.//不可拆分套餐
	.Set entSub = ""
	.For  Set entSub = $ORDER(^User.DHCPENetPreRecordD(netpid,"NPRPreOrdSetsRec",entSub)) Quit:(entSub="")  Do
	..Set break = $LISTGET(^User.DHCPENetPreRecordD(netpid,"NPRPreOrdSetsRec",entSub),4)
	..Quit:break="Y"  //可拆分的存储 在项目表
	..Set ordSetsId = $LISTGET(^User.DHCPENetPreRecordD(netpid,"NPRPreOrdSetsRec",entSub),2)
	..Set itemIds = ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ordSetsId)
	..Quit:("^"_itemIds_"^")'[("^"_ARCIMDR_"^")
	..Set regNum = regNum + 1
	..Set:busIds'[("^"_netpid_"^") busIds = busIds_netpid_"^"
	.//单项 或拆分的套餐项目
	.Set itemSub = ""
	.For  Set itemSub = $ORDER(^User.DHCPENetPreRecordD(netpid,"NPRPreItemRecord",itemSub)) Quit:(itemSub="")  Do
	..Set itemId = $LISTGET(^User.DHCPENetPreRecordD(netpid,"NPRPreItemRecord",entSub),2)
	..Quit:itemId'=ARCIMDR	
	..Set regNum = regNum + 1
	..Set:busIds'[("^"_netpid_"^") busIds = busIds_netpid_"^"
	Set:busIds="^" busIds=""	
	If BusIDSFlag="Y" 
	{
		Quit:busIds="" ""
		If $PIECE(busIds,"^",1)="" Set busIds = $PIECE(busIds,"^",2,$LENGTH(busIds,"^"))  //去掉第一个^
		If $PIECE(busIds,"^",$LENGTH(busIds,"^"))="" Set busIds = $PIECE(busIds,"^",1,$LENGTH(busIds,"^")-1)  //去掉最后一个^
		Quit busIds
	}
	Quit regNum
}

/// Description:获取医嘱预约数量  (预约未登记)
/// Input:
/// 					ARCIMDR：医嘱ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// 					NodeID:节点ID 为空时查询医嘱全部条件下的数量
/// 						BusIDSFlag:业务ID标记，为Y时返回业务ID集合，上箭头分割 
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetNoRegisterRegNum("1",+$H,304)
ClassMethod GetNoRegisterRegNum(ARCIMDR, LocID, Date, NodeID As %String = "", BusIDSFlag = "N")
{
	Set regNum=0,busIds="^"
	
	//预约 未登记记录
	Set time=""
	For  Set time=$ORDER(^DHCPEPreIADM(0,"BookDateTime",Date,Date,time))  Quit:time=""  Do
	.Set preIadm=0
	.For  Set preIadm=$ORDER(^DHCPEPreIADM(0,"BookDateTime",Date,Date,time,preIadm))  Quit:preIadm=""  Do
	..Set status = $PIECE(^DHCPEPreIADM(preIadm),"^",8)
	..Quit:(status'="PREREG")&&(status'="PREREGED")
	..Set locId = $PIECE(^DHCPEPreIADM(preIadm),"^",26)
	..Quit:locId'=LocID
	..Set flag = ..IsContainsArcim(preIadm,ARCIMDR,NodeID)
	..Quit:flag'=1
	..Set regNum = regNum + 1
	..Set:busIds'[("^"_preIadm_"^") busIds=busIds_preIadm_"^"
	Set:busIds="^" busIds=""
	If BusIDSFlag="Y" 
	{
		Quit:busIds="" ""
		If $PIECE(busIds,"^",1)="" Set busIds = $PIECE(busIds,"^",2,$LENGTH(busIds,"^"))  //去掉第一个^
		If $PIECE(busIds,"^",$LENGTH(busIds,"^"))="" Set busIds = $PIECE(busIds,"^",1,$LENGTH(busIds,"^")-1)  //去掉最后一个^
		Quit busIds
	}
	
	Quit regNum
}

/// Description:获取医嘱预约数量  (登记或到达)
/// Input:
/// 					ARCIMDR：医嘱ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// 					NodeID:节点ID 为空时查询医嘱全部条件下的数量
/// 						BusIDSFlag:业务ID标记，为Y时返回业务ID集合，上箭头分割
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegisteredRegNum("7700||1",105,66457,"9","N")
ClassMethod GetRegisteredRegNum(ARCIMDR, LocID, Date, NodeID As %String = "", BusIDSFlag = "N")
{
	Set ^tmpwgy("GetRegisteredRegNum") = $LISTBUILD(ARCIMDR, LocID, Date, NodeID, BusIDSFlag)
	Set regNum=0,busIds="^"
	Set time=""
	For  Set time=$ORDER(^DHCPEIADM(0,"AdmDateTime",Date,time))  Quit:time=""  Do
	.Set iadm=0
	.For  Set iadm=$ORDER(^DHCPEIADM(0,"AdmDateTime",Date,time,iadm))  Quit:iadm=""  Do
	..Set preIadm = $PIECE(^DHCPEIADM(iadm),"^",4)
	..Set status = $PIECE(^DHCPEPreIADM(preIadm),"^",8)
	..Quit:(status'="REGISTERED")&&(status'="ARRIVED")
	..Set locId = $PIECE(^DHCPEPreIADM(preIadm),"^",26)
	..Quit:locId'=LocID
	..Set flag = ..IsContainsArcim(preIadm,ARCIMDR,NodeID)
	..Quit:flag'=1
	..Set regNum = regNum + 1
	..Set:busIds'[("^"_preIadm_"^") busIds=busIds_preIadm_"^"
	Set:busIds="^" busIds=""
	Break //busIds
	If BusIDSFlag="Y" 
	{
		Quit:busIds="" ""
		If $PIECE(busIds,"^",1)="" Set busIds = $PIECE(busIds,"^",2,$LENGTH(busIds,"^"))  //去掉第一个^
		If $PIECE(busIds,"^",$LENGTH(busIds,"^"))="" Set busIds = $PIECE(busIds,"^",1,$LENGTH(busIds,"^")-1)  //去掉最后一个^
		Quit busIds
	}
	Quit regNum
}

/// Description:是否包含指定项目  预约状态、科室放在调用处判断  
/// Input:
/// 					PreIADM：体检预约ID
/// 					ARCIMDR：医嘱ID
/// 					NodeID:节点ID 为空时查询医嘱全部条件下
/// Return:  0：不包含   1：包含
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).IsContainsArcim("1451","7700||1",9)
ClassMethod IsContainsArcim(PreIADM, ARCIMDR, NodeID As %String = "")
{
	Set ret=0,sexDr="",vipLevel="",minAge="",maxAge=""
	If NodeID'="" Do
	.Set childSub=$ORDER(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",0))
	.If childSub'="" Do
	..Set sexDr=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),2)
	..Set minAge=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),3)
	..Set maxAge=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),4)
	..Set vipLevel=$LISTGET(^User.DHCPEArcimPreTreeD(NodeID,"APTCondition",childSub),5)
	Set:minAge="" minAge=0
	Set:maxAge="" maxAge=999
	Set curVIP = +##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	Quit:(vipLevel'="")&&(vipLevel'=curVIP) 0
	Set pibi = $PIECE(^DHCPEPreIADM(PreIADM),"^",1)
	Set locId = $PIECE(^DHCPEPreIADM(PreIADM),"^",26)
	Set hospId = $PIECE(^CTLOC(locId),"^",22)
	Set curSex = $PIECE(^DHCPEPreIBI(pibi),"^",3)
	Quit:(sexDr'="")&&(curSex'=sexDr) 0
	Set regNo = $PIECE(^DHCPEPreIBI(pibi),"^",1)
	Set patId = $ORDER(^PAPERi("PAPMI_PatNo",regNo,0))
	Set age = ##class(web.DHCPE.DHCPECommon).GetPapmiAge(patId,hospId,locId)
	Set age = $PIECE(age,"岁",1)
	Set:age="" age = 1
	Quit:(age<minAge)||(age>maxAge) 0
	Set sub=0
	For  Set sub=$ORDER(^DHCPEPreIADM(PreIADM,"ORDITEM",sub))  Quit:(sub="")||(ret=1)  Do
	.Quit:$DATA(^DHCPEPreIADM(PreIADM,"ORDITEM",sub))'=11
	.Set ItemStatus=$PIECE(^DHCPEPreIADM(PreIADM,"ORDITEM",sub),"^",16)
	.Quit:ItemStatus'="1"
	.Set arcim = $PIECE(^DHCPEPreIADM(PreIADM,"ORDITEM",sub),"^",1)
	.Quit:arcim'=ARCIMDR
	.Set ret = 1
	Quit ret
}

/// Description:查询项目限额信息
/// Input:
/// 					Date：日期
/// 						LocID：科室
/// Return: 
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.ArcimPreManager","SerchPreManagerNum","2021-09-28",304)
Query SerchPreManagerNum(Date As %String, ArcimDesc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TID:%String,_parentId:%String,TNode:%String:项目,NUM_M_1:%String:周一(限额),NUM_P_1:%String:周一(已约),NUM_A_1:%String:周一(剩余),NUM_M_2:%String:周二(限额),NUM_P_2:%String:周二(已约),NUM_A_2:%String:周二(剩余),NUM_M_3:%String:周三(限额),NUM_P_3:%String:周三(已约),NUM_A_3:%String:周三(剩余),NUM_M_4:%String:周四(限额),NUM_P_4:%String:周四(已约),NUM_A_4:%String:周四(剩余),NUM_M_5:%String:周五(限额),NUM_P_5:%String:周五(已约),NUM_A_5:%String:周五(剩余),NUM_M_6:%String:周六(限额),NUM_P_6:%String:周六(已约),NUM_A_6:%String:周六(剩余),NUM_M_0:%String:周日(限额),NUM_P_0:%String:周日(已约),NUM_A_0:%String:周日(剩余)")
{
}

ClassMethod SerchPreManagerNumExecute(ByRef qHandle As %Binary, Date As %String, ArcimDesc As %String = "", LocID As %String = "") As %Status
{
	Set ^tmpwgy("SerchPreManager")=$LISTBUILD(Date,ArcimDesc,LocID)
	Set repid=$INCREMENT(^CacheTemp)
 	Set ind=1
 	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
 	If Date=""
 	{
	 	Set Date = ##class(websys.Conversions).DateLogicalToHtml(+$HOROLOG)
 	}
 	Set dateStr = ##class(web.DHCPE.SetsPreTemplate).GetWeekDateRange(Date,"Logical")
 	Kill numList
 	
 	Set rootList=""
	If ArcimDesc'="" Set rootList=..GetRootByARCIMDesc(ArcimDesc)
	If ArcimDesc'="" 
	{
		Set rootList=..GetRootByARCIMDesc(LocID, ArcimDesc)
		If rootList=""
		{
			Set qHandle=$LISTBUILD(0,repid,0)
			Quit $$$OK
		}
	}
 	Set tmpparentId="",id=""
 	For  Set tmpparentId = $ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",tmpparentId)) Quit:tmpparentId=""  Do
 	.Set parentId = $REPLACE(tmpparentId," ","")
	.For  Set id=$ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_parentId,id)) Quit:id=""  Do
	..Quit:(parentId="")&&(rootList'="")&&(rootList'[("^"_id_"^"))  //根节点不包含指定医嘱项名称的子孙节点
	..Quit:($LISTGET(^User.DHCPEArcimPreTreeD(id),11)'=LocID)
	..Set text = $LISTGET(^User.DHCPEArcimPreTreeD(id),3)
	..Set:text'="" text=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEArcimPreTree",text,"APTDesc","cls")
	..Set conditionSub=$ORDER(^User.DHCPEArcimPreTreeD(id,"APTCondition",0))
	..Set text = text_..GetConditionDesc(id_"||"_conditionSub)
	..Set type = $LISTGET(^User.DHCPEArcimPreTreeD(id),5)
	..Set:type="D" text = text_"<font style='font-size:small;font-weight:bolder' color='red'>（点刀医生）</font>"
	..For i=1:1:$LENGTH(dateStr,"^") Do
	...Set date = $PIECE(dateStr,"^",i)
	...Set mNum= ..GetNodeManagerNum(id,date,LocID) 	//限额数量
	...Set pNum = ..GetRegNumByNode(id,LocID,date)	//预约数量
	...Set aNum = ..GetNodeAvailNum(id,date,LocID)	//可用数量
	...//s:id=10 pNum=25
	...//s:id=30 pNum=3
	...Set numList(id,i,"M") = mNum
	...Set numList(id,i,"P") = pNum
	...Set numList(id,i,"A") = aNum 
	..Do ManagerNumBuild
	Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
ManagerNumBuild      
	Set Data=$LISTBUILD(id,parentId, text,$GET(numList(id,1,"M")),$GET(numList(id,1,"P")),$GET(numList(id,1,"A")),$GET(numList(id,2,"M")),$GET(numList(id,2,"P")),$GET(numList(id,2,"A")),$GET(numList(id,3,"M")),$GET(numList(id,3,"P")),$GET(numList(id,3,"A")),$GET(numList(id,4,"M")),$GET(numList(id,4,"P")),$GET(numList(id,4,"A")),$GET(numList(id,5,"M")),$GET(numList(id,5,"P")),$GET(numList(id,5,"A")),$GET(numList(id,6,"M")),$GET(numList(id,6,"P")),$GET(numList(id,6,"A")),$GET(numList(id,7,"M")),$GET(numList(id,7,"P")),$GET(numList(id,7,"A")))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// Description:保存限额信息
/// Input:
/// 					InString：节点ID:日期,数量^日期,数量^……$C(0)节点ID:日期,数量^日期,数量^……$C(0)……  
/// 					LocID：科室ID
/// 					UserID：操作员
/// Return:  0：成功   非0^错误提示
/// Creator:	wangguoying
/// CreateDate:	2021-09-28
/// Debug: w ##class(web.DHCPE.ArcimPreManager).SavePreManager("28:2021-09-27,5","304","11849")
ClassMethod SavePreManager(InString, LocID, UserID As %String = "")
{
	//q "-1^ttt"
	Set ^tmpwgy("SavePreManager")=$LISTBUILD(InString, LocID, UserID)
	Set err = ""
	Set $ZTRAP="SavePMErr"
	Tstart
	For i=1:1:$LENGTH(InString,$CHAR(0))  Quit:err'=""  Do
	.Set info = $PIECE(InString,$CHAR(0),i)
	.Set nodeId = $PIECE(info,":",1)
	.Set wnStr = $PIECE(info,":",2)
	.For n=1:1:$LENGTH(wnStr,"^") Quit:err'=""  Do
	..Set dateNum = $PIECE(wnStr,"^",n)  
	..Set date = $PIECE(dateNum,",",1)
	..Set logicalDate = ##class(websys.Conversions).DateHtmlToLogical(date)
	..Set num = $PIECE(dateNum,",",2)
	..Set preNum = ..GetRegNumByNode(nodeId,LocID,logicalDate)
	..If preNum>num  Do
	...Set desc = $LISTGET(^User.DHCPEArcimPreTreeD(nodeId),3)
	...Set conditionSub=$ORDER(^User.DHCPEArcimPreTreeD(nodeId,"APTCondition",0))
	...Set desc = desc_..GetConditionDesc(nodeId_"||"_conditionSub)
	...Set err = "-1^【"_desc_"】【"_date_"】的限额【"_num_"】小于已预约数量【"_preNum_"】"
	..Quit:err'=""
	..Set type = "I" , oldRd = "" //更新类型 I：插入 U：更新
	..Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("NodeLocDateIndex",nodeId,LocID,logicalDate,""))
	..Break ;0
	..If apmId'="" Do
	...Set type = "U"
	...Set oldRd = ##class(User.DHCPEArcimPreManager).%OpenId(apmId).ToString()
	..Set pStr = "APMNode^APMDate^APMLoc^APMNum^APMUpdateUserDR^APMUpdateDate^APMUpdateTime"
	..Set vStr = nodeId_"^"_logicalDate_"^"_LocID_"^"_num_"^"_UserID_"^"_+$HOROLOG_"^"_$PIECE($HOROLOG,",",2)
	..Break
	..Set newId = ##class(User.DHCPEArcimPreManager).SaveData(apmId,vStr,pStr)
	..If +newId<0  Set err=newId Quit
	..Set logInfo = oldRd _"^"_ ##class(User.DHCPEArcimPreManager).%OpenId(newId).ToString()
	..Do ..Log(type,newId,logInfo,"",UserID)
	If err'="" Trollback  Quit err
	Tcommit
	Quit 0
SavePMErr
	Set $ZTRAP=""
	Trollback
	Quit "-100^"_$ZERROR
}

/// Description:记录限额信息日志
/// Input:
/// 						Type：操作类型 I：插入 U：更新 D：删除
/// 						APMID：排班ID
/// 						Info：原信息^新信息
/// 						Remark：备注
/// 					UserID：操作员
/// Return:  0：成功   非0^错误提示
/// Creator:	wangguoying
/// CreateDate:	2021-09-28
/// Debug: w ##class(web.DHCPE.ArcimPreManager).Log("1",+$H,304)
ClassMethod Log(Type, APMID, Info, Remark, UserID = "")
{
	Quit:APMID="" 0
	If UserID = ""
	{
		Set UserID = ##class(HS.BL.PECommon).GetDftSessionParam("USERID")
	}
	Set pStr = "APMLType^APMLNode^APMLLoc^APMLDate^APMLOldInfo^APMLNewInfo^APMLRemark^APMLUpdateUserDR^APMLUpdateDate^APMLUpdateTime"
	Set nodeId = $LISTGET(^User.DHCPEArcimPreManagerD(APMID),2)
	Set date = $LISTGET(^User.DHCPEArcimPreManagerD(APMID),3)
	Set loc = $LISTGET(^User.DHCPEArcimPreManagerD(APMID),4)
	Set vStr = Type_"^"_nodeId_"^"_loc_"^"_date_"^"_Info
	Set vStr = vStr_"^"_Remark_"^"_UserID_"^"_+$HOROLOG_"^"_$PIECE($HOROLOG,",",2)
	Set ret = ##class(User.DHCPEArcimPMLog).SaveData("",vStr,pStr)
	Set:+ret>0 ret = 0
	Quit ret
}

/// Description:复制限额信息  原日期复制到目标日期
/// Input:
/// 					NodeIDS：需要复制的节点集合 ^^^^^^
/// 					SourDate：原日期
/// 					TargetDate：目标日期
/// 					LocID：科室ID
/// 					UserID：操作员
/// Return:  0：成功   非0^错误提示
/// Creator:	wangguoying
/// CreateDate:	2021-09-29
/// Debug: w ##class(web.DHCPE.ArcimPreManager).SavePreManager("28:2021-09-27,5","304","11849")
ClassMethod CopyByDate(NodeIDS, SourDate, TargetDate, LocID, UserID As %String = "")
{
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID") 
	}
	Set $ZTRAP="CopyDateErr"
	Tstart
	Set err = ""
	Set LogicalSDate = ##class(websys.Conversions).DateHtmlToLogical(SourDate)
	Set LogicalTDate = ##class(websys.Conversions).DateHtmlToLogical(TargetDate)
	For i=1:1:$LENGTH(NodeIDS,"^")  Quit:err'=""  Do
	.Set nodeId = $PIECE(NodeIDS,"^",i)
	.Set sourceAPMID = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,nodeId,LogicalSDate,""))
	.Quit:sourceAPMID="" 
	.Set num = $LISTGET(^User.DHCPEArcimPreManagerD(sourceAPMID),5)
	.Set inString = nodeId_":"_TargetDate_","_num
	.Set ret = ..SavePreManager(inString,LocID,UserID)
	.If +ret'=0 Set err = ret  Quit
	If err'=""  Trollback  Quit err
	Tcommit
	Quit 0
CopyDateErr
	Set $ZTRAP=""
	Trollback 
	Quit "-100^"_$ZERROR
}

/// Description:按周复制限额信息  
/// Input:
/// 					NodeIDS：需要复制的节点集合 ^^^^^^
/// 					SourDate：原日期
/// 					TargetBeginDate：目标开始日期
/// 						TargetEndDate：目标结束日期
/// 					LocID：科室ID
/// 					UserID：操作员
/// Return:  0：成功   非0^错误提示
/// Creator:	wangguoying
/// CreateDate:	2021-09-29
/// Debug: w ##class(web.DHCPE.ArcimPreManager).CopyByWeek("4^10^30^17^19^21^28^22^20","2021-09-29","2021-10-04","2021-10-10","304","11849")
ClassMethod CopyByWeek(NodeIDS, SourDate, TargetBeginDate, TargetEndDate, LocID, UserID As %String = "")
{
	Set ^tmpwgy("CopyByWeek")=$LISTBUILD(NodeIDS, SourDate, TargetBeginDate, TargetEndDate, LocID, UserID)
	Quit:(TargetBeginDate=TargetEndDate) ..CopyByDate(NodeIDS,SourDate,TargetBeginDate,LocID,UserID)
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID") 
	}
	Kill NodeNumList
	Set $ZTRAP="CopyWeekErr"
	Tstart
	Set err = ""
	Set dateStr = ##class(web.DHCPE.SetsPreTemplate).GetWeekDateRange(SourDate,"Logical")
	For i=1:1:$LENGTH(NodeIDS,"^")  Do
	.Set nodeId = $PIECE(NodeIDS,"^",i)
	.For n=1:1:7  Do
	..Set date = $PIECE(dateStr,"^",n)
	..Set apmId = $ORDER(^User.DHCPEArcimPreManagerI("LocNodeDateIndex",LocID,nodeId,date,""))
	..If apmId'="" Set NodeNumList(nodeId,n)=$LISTGET(^User.DHCPEArcimPreManagerD(apmId),5)  //不存在就空着，不复制
	
	Set beginDate = ##class(websys.Conversions).DateHtmlToLogical(TargetBeginDate)
	Set endDate = ##class(websys.Conversions).DateHtmlToLogical(TargetEndDate)
	If beginDate>endDate  Trollback  Quit "-1^开始日期不能小于结束日期" 
	
	For date=beginDate:1:endDate  Quit:err'=""  Do
	.Set week = $ZDATE(date,10)
	.Set:week=0 week=7
	.For i=1:1:$LENGTH(NodeIDS,"^")  Quit:err'=""  Do
	..Set nodeId = $PIECE(NodeIDS,"^",i)
	..Quit:'$DATA(NodeNumList(nodeId,week))  
	..Set inString = nodeId_":"_##class(websys.Conversions).DateLogicalToHtml(date)_","_$GET(NodeNumList(nodeId,week))
	..Set ret = ..SavePreManager(inString,LocID,UserID)
	..If +ret'=0 Set err = ret  Quit
	If err'=""  Trollback  Quit err
	Tcommit
	Quit 0
CopyWeekErr
	Set $ZTRAP=""
	Trollback 
	Quit "-100^"_$ZERROR
}

/// Description:获取剩余名额
/// Input:
/// 						ARCIM：医嘱ID
/// 						Date：日期 Logical
/// 						RegNo：登记号
/// 						ExtStr: VIP等级ID^性别^年龄
/// 						LocID：科室ID
/// Return:  剩余名额  不存在限额时返回9999
/// Creator:	wangguoying
/// CreateDate:	2021-09-30
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetAavilNum("5002||1",,"0000000006","",105)
ClassMethod GetAavilNum(ARCIM, Date, RegNo, ExtStr, LocID = "")
{
	Quit:(RegNo="")&&(ExtStr="") 0  //条件不完整 直接返回0
	If LocID = ""
	{
		Set LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	Set aNum = 9999
	Set nodeIds = ..GetMatchNodes(LocID, ARCIM,RegNo,ExtStr)
	//w nodeIds,!
	Break ;nodeId
	Quit:nodeIds="" 9999
	For i=1:1:$LENGTH(nodeIds,"^")
	{
		Break ;2
		Set nodeId = $PIECE(nodeIds,"^",i)
		Set curAvialNum = ..GetNodeAvailNum(nodeId,Date,LocID)
		If curAvialNum<aNum  Set aNum =curAvialNum  //取最小值
	}
	Quit aNum
}

/// Description:获取符合条件的节点
/// Input:
/// 						ARCIM：医嘱ID
/// 						RegNo：登记号
/// 						ExtStr: VIP等级ID^性别^年龄
/// 						LocID：科室ID
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-09-30
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetMatchNodes("11551||1","0000000008","")
ClassMethod GetMatchNodes(LocID, ARCIM, RegNo, ExtStr)
{
	Set levelId = $PIECE(ExtStr,"^",1)
	Set sexId = $PIECE(ExtStr,"^",2)
	Set age = $PIECE(ExtStr,"^",3)
	If RegNo'=""
	{
		Set pibi = $ORDER(^DHCPEPreIBI(0,"PAPMINo",RegNo,""))
		Quit:pibi="" "" //登记号不存在直接返回
		Set:sexId="" sexId = $PIECE(^DHCPEPreIBI(pibi),"^",3)
		If levelId = "" Set levelId = $GET(^DHCPEVIPLevel("PIBI",RegNo))
		If age=""  Do
		.Set dob = $PIECE(^DHCPEPreIBI(pibi),"^",4)
		.Set age = ##class(web.DHCLCNUREXCUTE).CalAge(dob,+$HOROLOG)
		.Set age = $PIECE(age,"Y",1)
	}
	//w "levelId="_levelId_"  sexId="_sexId_"  age="_age,!  
	Set ret = ""
	Set id = ""
	For  Set id = $ORDER(^User.DHCPEArcimPreTreeI("LocTypeSourceIndex",LocID," A",$CHAR(32)_ARCIM,id))  Quit:id=""  Do
	.Set conditionSub=$ORDER(^User.DHCPEArcimPreTreeD(id,"APTCondition",0))
	.Set curSexId=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),2)
	.Set minAge=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),3)
	.Set:minAge="" minAge=0
	.Set maxAge=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),4)
	.Set:maxAge="" maxAge=999
	.Set curLevel=$LISTGET(^User.DHCPEArcimPreTreeD(id,"APTCondition",conditionSub),5)
	.Break
	.Quit:(curSexId'="")&&(curSexId'=sexId)
	.Quit:(curLevel'="")&&(curLevel'=levelId)
	.Quit:(age<minAge)||(age>maxAge)
	.If ret'=""  Set ret = ret_"^"_id
	.e  Set ret = id
	Quit ret
}

/// Description:获取套餐剩余名额
/// Input:
/// 						OrdSetsId：套餐ID
/// 						PreIADM: DHC_PE_PreIADM
/// Return:  名额^日期(HTML)^超额的项目名称  
/// Creator:	wangguoying
/// CreateDate:	2021-09-30
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetAavilNumBySets("11551||1",+$H,"0000000008","",304)
ClassMethod GetAavilNumBySets(OrdSetsId, PreIADM)
{
	Set pibi = $PIECE(^DHCPEPreIADM(PreIADM),"^",1)
	Set regNo = $PIECE(^DHCPEPreIBI(pibi),"^",1)
	Set preDate = $PIECE(^DHCPEPreIADM(PreIADM),"^",4)
	Set locId = $PIECE(^DHCPEPreIADM(PreIADM),"^",26)
	Set ret = 9999,descs=""
	Set itemIds = ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(OrdSetsId)
	For i=1:1:$LENGTH(itemIds,"^") 
	{
		Set itemId = $PIECE(itemIds,"^",i)
		Continue:itemId=""
		Set avaliNum = ..GetAavilNum(itemId,preDate, regNo, "", locId)
		If avaliNum<ret  Set ret = avaliNum
		If avaliNum<=0 Do
		.Set arcimDesc = $PIECE($GET(^ARCIM($PIECE(itemId,"||",1),$PIECE(itemId,"||",2),1)),"^",2)
		.Set:descs'="" descs = descs_"、"_arcimDesc
		.Set descs = arcimDesc
	}
	Quit:ret>0 ret
	Quit ret_"^"_##class(websys.Conversions).DateLogicalToHtml(preDate)_"^"_descs
}

/// Description:通过PreIADM获取剩余名额
/// Input:
/// 						PreIADM：DHC_PE_PreIADM
/// 						DateStr：预约日期
/// Return:  	剩余名额  
/// Creator:	wangguoying
/// CreateDate:	2021-10-21
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetAavilNumByPreIADM()
ClassMethod GetAavilNumByPreIADM(PreIADM, DateStr, UserID = "", ExtItem = "")
{
	Set date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	Set pibi = $PIECE(^DHCPEPreIADM(PreIADM),"^",1)
	Set regNo = $PIECE(^DHCPEPreIBI(pibi),"^",1)
	Set hadPreDate = $PIECE(^DHCPEPreIADM(PreIADM),"^",4)
	Set locId = $PIECE(^DHCPEPreIADM(PreIADM),"^",26)
	If ExtItem'=""
	{
		If $PIECE(ExtItem,"^",1)="I" Set itemIds = $PIECE(ExtItem,"^",2)
		.e  Set itemIds = ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet($PIECE(ExtItem,"^",2))
	}Else{
		Set itemIds = ..GetNoHadItemsByPreIADM(PreIADM,UserID)
	}
	If hadPreDate'=DateStr //当前日期不等于已预约日期时，已确认的项目也要重新判断限额
	{
		Set hadItems = ..GetHadItemsByPreIADM(PreIADM)
		Set:hadItems'="" itemIds = itemIds_"^"_hadItems
	}
	Set num = 9999
	
	For i=1:1:$LENGTH(itemIds,"^")
	{
		Set arcimDr = $PIECE(itemIds,"^",i)
		Continue:arcimDr=""
		Set availNum = ..GetAavilNum(arcimDr,date,regNo,"",locId)
		If availNum<num Set num = availNum
		Quit:num<=0
	}
	Quit num
}

/// Description:通过PreIADM获取已确认项目集合
/// Input:
/// 						PreIADM：DHC_PE_PreIADM
/// Return:  	已确认项目集合 
/// Creator:	wangguoying
/// CreateDate:	2021-10-21
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetHadItemsByPreIADM()
ClassMethod GetHadItemsByPreIADM(PreIADM)
{
	Set ret = ""
	Set sub=0
	For  Set sub=$ORDER(^DHCPEPreIADM(PreIADM,"ORDITEM",sub))  Quit:sub=""  Do
	.Set ItemStatus=$PIECE($GET(^DHCPEPreIADM(PreIADM,"ORDITEM",sub)),"^",16)
	.Quit:ItemStatus'="1"
	.Set arcimDr = $PIECE(^DHCPEPreIADM(PreIADM,"ORDITEM",sub),"^",1)
	.Set:ret'="" ret = ret_"^"_arcimDr
	.Set:ret="" ret = arcimDr
	Quit ret
}

/// Description:通过PreIADM获取未确认项目集合
/// Input:
/// 						PreIADM：DHC_PE_PreIADM
/// Return:  	未确认项目集合 
/// Creator:	wangguoying
/// CreateDate:	2021-10-21
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetNoHadItemsByPreIADM()
ClassMethod GetNoHadItemsByPreIADM(PreIADM, UserID)
{
	Set ret = ""
	Set id = ""
 	For  Set id = $ORDER(^User.DHCPEPreTempItemI("TypeAdmUserIndex","PERSON",PreIADM,UserID,id)) Quit:(id="")  Do
 	.Set arcimDr = $LISTGET(^User.DHCPEPreTempItemD(id),5)
	.Set:ret'="" ret = ret_"^"_arcimDr
	.Set:ret="" ret = arcimDr
	Quit ret
}

/// Description:获取点刀医生对应的全部医嘱
/// Input:
/// 					Doctor：医生ID
/// Return:  	医嘱ID^^^^
/// Creator:	wangguoying
/// CreateDate:	2021-11-02
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRelateArcims(65283)
ClassMethod GetRelateArcims(Doctor)
{
	Set ret = ""
	Set itemCarDr = "" 	//##class(web.DHCPE.DDDoctor).GetItemCat(Doctor) //全程医疗是根据医护人员与医嘱子分类做关联
	Quit:itemCarDr="" ""
	Set arcimSubscript = ""
	For  Set arcimSubscript = $ORDER(^ARCIM(0,"ARCIC_DR",itemCarDr,arcimSubscript)) Quit:arcimSubscript=""  Do
	.Set arcimVersion = ""
	.For  Set arcimVersion = $ORDER(^ARCIM(0,"ARCIC_DR",itemCarDr,arcimSubscript,arcimVersion)) Quit:arcimVersion=""  Do
	..Set itemId = arcimSubscript_"||"_arcimVersion
	..Set qybz=1  //启用标志
	..Set EffDateFInfo=$PIECE(^ARCIM($PIECE(itemId,"||",1),$PIECE(itemId,"||",2),1),"^",13)
	..If EffDateFInfo'="" Do
	...Set:(+EffDateFInfo)>+$HOROLOG qybz=0
	..Set EffDateTo=$PIECE(^ARCIM($PIECE(itemId,"||",1),$PIECE(itemId,"||",2),7),"^",1)
	..If EffDateTo'="" Do
	...Set:EffDateTo<+$HOROLOG qybz=0
	..Quit:qybz=0
	..If ret '= "" Set ret = ret_"^"_itemId
	..e  Set ret = itemId
	Quit ret
}

/// Description:获取点刀医生 医嘱预约数量 医生与医嘱子类对应
/// Input:
/// 					Doctor：医生ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-11-02
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByDoctor("4390||1",304,65283)
ClassMethod GetRegNumByDoctor(Doctor, LocID, Date)
{
	Set regNum=0
	Set itemIds = ..GetRelateArcims(Doctor)
	Quit:itemIds="" 0
	Quit ..GetRegNumByARCIMS(itemIds,LocID,Date)
}

/// Description:获取项目预约数量  不考虑节点和其他条件
/// Input:
/// 					Items：医嘱项ID^医嘱项ID……
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2021-11-02
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByDoctor("4390||1",304,65283)
ClassMethod GetRegNumByARCIMS(Items, LocID, Date)
{
	Set regNum=0
	For i=1:1:$LENGTH(Items,"^") 
	{
		Set itemId = $PIECE(Items,"^",i)
		// 线上预约且未同步至体检系统的记录
		Set regNum = regNum + ..GetOnlyNetRegNum(itemId, LocID, Date,)		
		// 预约未登记的
		Set regNum = regNum + ..GetNoRegisterRegNum(itemId, LocID, Date)	
		// 登记或到达的
		Set regNum = regNum + ..GetRegisteredRegNum(itemId, LocID, Date)		
	}
	Quit regNum
}

/// Description: 获取点刀医生剩余名额
/// Input:
/// 						Doctors：	医生ID^医生ID……
/// 						Date：		日期 Logical
/// 							LocID：		科室ID
/// Return:  	剩余名额  
/// Creator:	wangguoying
/// CreateDate:	2021-11-02
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetAavilNumByDoctor("12175^13930",66050,"23")
ClassMethod GetAavilNumByDoctor(Doctors, Date, LocID)
{
	Set ^tmpwgy("GetAavilNumByDoctor")=$LISTBUILD(Doctors, Date, LocID)
	Quit:Doctors="" 9999
	Set availNum = 9999
	For i=1:1:$LENGTH(Doctors,"^")
	{
		Set doctor = $PIECE(Doctors,"^",i)
		Continue:doctor=""
		Set id = ""
		For  Set id = $ORDER(^User.DHCPEArcimPreTreeI("LocTypeSourceIndex",LocID," D",$CHAR(32)_doctor,id))  Quit:(id="")||(availNum<=0)  Do
		.Set num = ..GetNodeAvailNum(id,Date,LocID)
		.Set:num<availNum availNum=num
		Quit:availNum<=0
	}
	Quit availNum
}

/// Description: 获取点刀医生剩余名额
/// Input:
/// 						Doctor：	医生ID
/// 						Date：		日期 Logical
/// 							LocID：		科室ID
/// Return:  	剩余名额  
/// Creator:	wangguoying
/// CreateDate:	2021-11-02
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetAavilNumByPreIADM()
ClassMethod GetDoctorAavilNumByPreIADM(PreIADM, DateStr, UserID, ExtItem = "")
{
	Set date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	Set hadPreDate = $PIECE(^DHCPEPreIADM(PreIADM),"^",4)
	Set locId = $PIECE(^DHCPEPreIADM(PreIADM),"^",26)
	
	Set doctors = "" //##class(web.DHCPE.DDDoctor).GetDDDoctorsByPreIADM(PreIADM)  //当前预约记录对应对的点刀医生  具体项目调用方法获取  可参考全程医疗
	Quit:doctors="" 9999
	Set availNum = ..GetAavilNumByDoctor(doctors,date,locId)
	Quit:availNum<=0 availNum
	
	Set extNum = 0 // 额外需要占用的名额
	
	If ExtItem'=""
	{
		If $PIECE(ExtItem,"^",1)="I" Set itemIds = $PIECE(ExtItem,"^",2)
		.e  Set itemIds = ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet($PIECE(ExtItem,"^",2))
	}Else{
		Set itemIds = ..GetNoHadItemsByPreIADM(PreIADM,UserID)
	}
	
	If hadPreDate'=DateStr //当前日期不等于已预约日期时，已确认的项目也要重新加入到点刀医生的名额里
	{
		Set hadItems = ..GetHadItemsByPreIADM(PreIADM)
		Set:hadItems'="" itemIds = itemIds_"^"_hadItems
	}
	If itemIds'=""
	{
		Set extNum = ..GetRegNumByARCIMS(itemIds,locId,date)
		Set availNum = availNum - extNum
	}
	Quit availNum
}

/// Description:获取节点预约业务IDS
/// Input:
/// 					NodeID:节点ID
/// 					LocID：科室ID
/// 					Date：日期 Logical				
/// Return:  	线上预约IDS(^分割)$C(0)线下预约IDS(^分割)
/// Creator:	wangguoying
/// CreateDate:	2021-09-26
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByARCIM("1",+$H,304)
ClassMethod GetPreBusIDSByNode(NodeID, LocID, Date)
{
	Set ret = ""
	Set type = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),5)
	If type = "A"
	{
		Set arcim = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),6)
		Set ret = ..GetBusIDByARCIM(arcim,LocID,Date,NodeID)
	}ElseIf type = "D"{
		//s doctorId = $lg(^User.DHCPEArcimPreTreeD(NodeID),6)
		//s ret = ..GetRegNumByDoctor(doctorId,LocID,Date)
	}
	ElseIf type = "S"{
		Set child = ""
		For  Set child = $ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_NodeID,child)) Quit:child=""  Do
		.Set info = ..GetPreBusIDSByNode(child,LocID,Date)
		.If ret = ""  Set ret = info
		.e  Do
		..Set netIds = $PIECE(ret,$CHAR(0),1)
		..Set piadmIds = $PIECE(ret,$CHAR(0),2)
		..Set netInfo = $PIECE(info,$CHAR(0),1)
		..Set piadmInfo = $PIECE(info,$CHAR(0),2)
		..Set netIds = ##class(web.DHCPE.Utils.StringUtil).GetUnionSet(netIds,netInfo,"^")
		..Set piadmIds = ##class(web.DHCPE.Utils.StringUtil).GetUnionSet(piadmIds,piadmInfo,"^")
		..Set ret = netIds_$CHAR(0)_piadmIds
	}
	Quit ret
}

/// Description:获取预约记录业务ID
/// Input:
/// 					ARCIMDR：医嘱ID
/// 					LocID：科室ID
/// 					Date：日期 Logical
/// 					NodeID:节点ID 为空时查询医嘱全部条件下的数量
/// Return:  
/// Creator:	wangguoying
/// CreateDate:	2022-09-22
/// Debug: w ##class(web.DHCPE.ArcimPreManager).GetRegNumByARCIM("4390||1",304,65283,28)
ClassMethod GetBusIDByARCIM(ARCIMDR, LocID, Date, NodeID As %String = "")
{
	Set netBusIds="",piadmIds=""
	// 线上预约且未同步至体检系统的记录
	Set netBusIds = ..GetOnlyNetRegNum(ARCIMDR, LocID, Date, NodeID,"Y")	
	// 预约未登记的
	Set piadmIds = ..GetNoRegisterRegNum(ARCIMDR, LocID, Date, NodeID,"Y")	
	// 登记或到达的
	Set ids = ..GetRegisteredRegNum(ARCIMDR, LocID, Date, NodeID,"Y")
	Break ;ids	
	If ids'=""
	{
		If piadmIds '="" Set piadmIds = piadmIds_"^"_ids
		e  Set piadmIds = ids
	}	
	Quit netBusIds_$CHAR(0)_piadmIds
}

/// 判断某个医嘱是否属于某个节点  1:是 0:否
ClassMethod IsMatched(Arcim, NodeID) As %Status
{
	Set flag = 0
	Set type = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),5)
	If type = "A"{
		Set arcim = $LISTGET(^User.DHCPEArcimPreTreeD(NodeID),6)
		If arcim = Arcim  Set flag = 1
	}ElseIf type = "D"{
	}
	ElseIf type = "S"{
		Set child = ""
		For  Set child = $ORDER(^User.DHCPEArcimPreTreeI("ParentNodeIndex",$CHAR(32)_NodeID,child)) Quit:(child="")||(flag=1)  Do
		.Set flag = ..IsMatched(Arcim,child)
	}
	Quit flag
}

/// Description：查询预约明细
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2022-09-22
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.ArcimPreManager","QueryPreDetail",43,"2022-09-22",304)
Query QueryPreDetail(NodeID As %String = "", DateStr As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TNetPreID:%String,TPreIADM:%String,TRegNo:%String,TName:%String,TSexDesc:%String,TAge:%String,TIDCardNo:%String,TTelephone:%String,TStatusDesc:%String,THPNo:%String,TPreDate:%String,TGroupDesc:%String,TTeamDesc:%String,TCardDesc:%String,TARCIMDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryPreDetailExecute(ByRef qHandle As %Binary, NodeID As %String = "", DateStr As %String = "", LocID As %String = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1
    If (DateStr = "")||(LocID = "")||(NodeID = "")
    {
        Set qHandle=$LISTBUILD(0,repid,0)
        Quit $$$OK
    }
    Set date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
    Set ids = ..GetPreBusIDSByNode(NodeID,LocID,date)
    Set netIds = $PIECE(ids,$CHAR(0),1)
    Set preIadms = $PIECE(ids,$CHAR(0),2)
    If netIds'=""
    {
         For i=1:1:$LENGTH(netIds,"^")
        {
            Set netId = $PIECE(netIds,"^",i)
            Do GetNetPreRecord
        }
    }
    Break
    If preIadms'=""
    {
        For i=1:1:$LENGTH(preIadms,"^")
        {
            Set piadm = $PIECE(preIadms,"^",i)
            Set netId = ""
            Do GetPreIADM
        }
    }
    Set qHandle=$LISTBUILD(0,repid,0)
    Quit $$$OK
GetNetPreRecord
    Set piadm = $LISTGET(^User.DHCPENetPreRecordD(netId),13)
    If piadm'=""  Do GetPreIADM  Quit
    Set regNo = $LISTGET(^User.DHCPENetPreRecordD(netId),2)
    Set name = $LISTGET(^User.DHCPENetPreRecordD(netId),3)
    Set sexId = $LISTGET(^User.DHCPENetPreRecordD(netId),4)
    Set sexDesc = $PIECE(^CT("SEX",sexId),"^",2)
    Set age = $LISTGET(^User.DHCPENetPreRecordD(netId),5)
    //Set idCardNo = $LISTGET(^User.DHCPENetPreRecordD(netId),6)
    Set cardDesc = ""
    Set cardTypeDr=$PIECE($GET(^PAPER($ORDER(^PAPERi("PAPMI_PatNo",regNo,0)),"PAT",3)),"^",7)
	If cardTypeDr'=""  Set cardDesc=$PIECE($GET(^PAC("CARD",cardTypeDr)),"^",2)
	Set idCardNo=$PIECE($GET(^PAPER($ORDER(^PAPERi("PAPMI_PatNo",regNo,0)),"PAT",3)),"^",6)
    
    
    Set statusDesc = "网上预约"
    Set HPNo = ""
    Set telePhone = $LISTGET(^User.DHCPENetPreRecordD(netId),19)
    Set gDesc = "",teamDesc=""
    Do GetNetPreItem
    Quit
GetNetPreItem
	//不可拆分套餐
	Set entSub = ""
	For {
		Set entSub = $ORDER(^User.DHCPENetPreRecordD(netId,"NPRPreOrdSetsRec",entSub)) 
		Quit:(entSub="")  
		Set break = $LISTGET(^User.DHCPENetPreRecordD(netId,"NPRPreOrdSetsRec",entSub),4)
		Continue:break="Y"  //可拆分的存储 在项目表
		Set ordSetsId = $LISTGET(^User.DHCPENetPreRecordD(netId,"NPRPreOrdSetsRec",entSub),2)
		Set itemIds = ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(ordSetsId)
		For i=1:1:$LENGTH(itemIds,"^"){
			Set arcim = $PIECE(itemIds,"^",1)
			If ..IsMatched(arcim,NodeID) = 1 {
				Set arcimDesc = $PIECE($GET(^ARCIM($PIECE(arcim,"||",1),$PIECE(arcim,"||",2),1)),"^",2)
				Do OutputPreDetailRow
			}
		}
	}
	//单项 或拆分的套餐项目
	Set itemSub = ""
	For{
		Set itemSub = $ORDER(^User.DHCPENetPreRecordD(netId,"NPRPreItemRecord",itemSub)) 
		Quit:(itemSub="")  
		Set arcim = $LISTGET(^User.DHCPENetPreRecordD(netId,"NPRPreItemRecord",entSub),2)
		If ..IsMatched(arcim,NodeID) = 1 {
			Set arcimDesc = $PIECE($GET(^ARCIM($PIECE(arcim,"||",1),$PIECE(arcim,"||",2),1)),"^",2)
			Do OutputPreDetailRow
		}
	}
	Quit
GetPreIADM
    Set pibi = $PIECE(^DHCPEPreIADM(piadm),"^",1)
    Set regNo = $PIECE(^DHCPEPreIBI(pibi),"^",1)
    Set name = $PIECE(^DHCPEPreIBI(pibi),"^",2)
    Set sexId = $PIECE(^DHCPEPreIBI(pibi),"^",3)
    Set sexDesc = $PIECE(^CT("SEX",sexId),"^",2)
	Set hospId = $PIECE(^CTLOC(LocID),"^",22)
	Set patId = $ORDER(^PAPERi("PAPMI_PatNo",regNo,0))
	Set age = ##class(web.DHCPE.DHCPECommon).GetPapmiAge(patId,hospId,LocID)
    //Set idCardNo = $PIECE(^DHCPEPreIBI(pibi),"^",9)
     Set cardDesc = ""
    Set cardTypeDr=$PIECE($GET(^PAPER($ORDER(^PAPERi("PAPMI_PatNo",regNo,0)),"PAT",3)),"^",7)
	If cardTypeDr'=""  Set cardDesc=$PIECE($GET(^PAC("CARD",cardTypeDr)),"^",2)
	Set idCardNo=$PIECE($GET(^PAPER($ORDER(^PAPERi("PAPMI_PatNo",regNo,0)),"PAT",3)),"^",6)
    Set telePhone = $PIECE(^DHCPEPreIBI(pibi),"^",8)
    Set status = $PIECE(^DHCPEPreIADM(piadm),"^",8)
    Set statusDesc =  ##Class(web.DHCPE.PreCommon).TransStatus(status)
    Set HPNo = $PIECE(^DHCPEPreIADM(piadm),"^",27)
   
    Set gDesc = "",teamDesc=""
    Set gid = $PIECE(^DHCPEPreIADM(piadm),"^",2)
    If gid'=""{
        Set pgbi = $PIECE(^DHCPEPreGADM(gid),"^",1)
        Set gDesc = $PIECE(^DHCPEPreGBI(pgbi),"^",2)
        Set teamId = $PIECE(^DHCPEPreIADM(piadm),"^",3)
        Set teamDesc = $PIECE(^DHCPEPreGADM(gid,"Team",$PIECE(teamId,"||",2)),"^",1)
    }
    Do GetPIADMItem
    Quit
GetPIADMItem
	Set sub=0
	For{
		Set sub=$ORDER(^DHCPEPreIADM(piadm,"ORDITEM",sub))  
		Quit:(sub="")
		Continue:$GET(^DHCPEPreIADM(piadm,"ORDITEM",sub))=""
		Set ItemStatus=$PIECE(^DHCPEPreIADM(piadm,"ORDITEM",sub),"^",16)
		Continue:ItemStatus'="1"
		Set arcim = $PIECE(^DHCPEPreIADM(piadm,"ORDITEM",sub),"^",1)
		If ..IsMatched(arcim,NodeID) = 1 {
			Set arcimDesc = $PIECE($GET(^ARCIM($PIECE(arcim,"||",1),$PIECE(arcim,"||",2),1)),"^",2)
			Do OutputPreDetailRow
		}
	}
	Quit
OutputPreDetailRow
    Set Data=$LISTBUILD(netId,piadm,regNo,name,sexDesc,age,idCardNo,telePhone,statusDesc,HPNo,DateStr,gDesc,teamDesc,cardDesc,arcimDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// 初始化科室字段
/// 新在科室字段 ，全部更新成105（体检中心） 方便测试
/// w ##class(web.DHCPE.ArcimPreManager).UpdateLoc(105) 
ClassMethod UpdateLoc(LocID)
{
	Set code = ""
	For{
		Set code = $ORDER(^User.DHCPEArcimPreTreeI("CodeIndex",code))  
		Quit:code=""
		Set id = ""
		For{
			Set id = $ORDER(^User.DHCPEArcimPreTreeI("CodeIndex",code,id))  
			Quit:id=""
			Continue:$LISTGET(^User.DHCPEArcimPreTreeD(id),11)'=""
			Set obj = ##class(User.DHCPEArcimPreTree).%OpenId(id)
			Do obj.APTLocDRSetObjectId(LocID)
			Set sc = obj.%Save()
			If $$$ISERR(sc)
			{
				Write "id="_id_ "错误信息："_$SYSTEM.Status.GetErrorText(sc),!
			}
			Do obj.%Close()
		}
	}
	Quit 0
}

}
