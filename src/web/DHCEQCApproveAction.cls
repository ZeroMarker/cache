/// 创建:zy 2010-02-28  No ZY0018
/// 描述：审批动作
/// -------------------------------
Class web.DHCEQCApproveAction Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zy 2010-02-28  No ZY0018
/// 描述:单签角色动作查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveAction","GetApproveAction")
/// -------------------------------
/// Modified By QW-2018-0914 需求号:598458 增加输出,TRow:%String
Query GetApproveAction(StepRowID) As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TClassName:%String,TMethod:%String,TRow:%String")
{
}

ClassMethod GetApproveActionExecute(ByRef qHandle As %Binary, StepRowID) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s TRow=0    ;Modified By QW-2018-0914 需求号:598458
	s index=1
	s rowid=0
	d BuildDataApproveAction
	Quit $$$OK
BuildDataApproveAction
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApprFlowStepAction",0,"Flow",StepRowID,rowid))  quit:rowid=""  d
	.d ResetVariablesApproveAction
	.s TRowID = $p($g(^DHCEQCCode("DHCEQCApprFlowStepAction",rowid)),"^",2)
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCApproveAction",TRowID)),"^",1)
	.s TClassName = $p($g(^DHCEQCCode("DHCEQCApproveAction",TRowID)),"^",2)
	.s TMethod = $p($g(^DHCEQCCode("DHCEQCApproveAction",TRowID)),"^",3)
	.d OutputRowApproveAction
	quit
OutputRowApproveAction
    ;Modified By QW-2018-0914 需求号:598458
	s TRow=TRow+1
	s Data=$lb(TRowID,TDesc,TClassName,TMethod,TRow)
	;End By QW-2018-0914 需求号:598458
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesApproveAction
	s (TRowID,TDesc,TClassName,TMethod)=""
	quit
}

ClassMethod GetApproveActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveActionExecute ]
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

ClassMethod GetApproveActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建:zy 2010-02-28  No ZY0018
/// 描述：数据添加,修改,删除
/// -------------------------------
/// modified by sjh SJH0042 增加数据修改日志
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
		
	 new (val,isDel,%session)
	 Set $ZT="ERROR"
	 s rowid=$p(val,"^",1)
	 s PLIST(2) = $p(val,"^",2)	;Desc
 	 s PLIST(3) = $p(val,"^",3)	;ClassName
 	 s PLIST(4) = $p(val,"^",4) ;Method
 	 s AFSARowID = $p(val,"^",5) ;DHC_EQCApprFlowStepAction
 	 s TableName="DHC_EQCApproveAction"
	 s ClassName="User.DHCEQCApproveAction"
 	 s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	 s BussID=rowid	
 	 s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	 s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	 s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New() 
	 TSTART
	 i (+isDel=0)  //新增按钮操作
	 {
		 Set BussID="",OperateType="A"
		 &SQL(Insert Into SQLUSER.DHC_EQCApproveAction Values :PLIST())
	 	i SQLCODE
	 	{
	 		TROLLBACK
	 		q SQLCODE
	 	}
		s ID=$G(%ROWID)
		s FList(2)=AFSARowID
		s FList(3)=ID
		&SQL(Insert Into SQLUSER.DHC_EQCApprFlowStepAction Values :FList())
	 }
	 i (+isDel=1)  //删除按钮操作
	 {
		
	 	&SQL(Delete from SQLUser.DHC_EQCApprFlowStepAction where AFSA_FlowDR = :AFSARowID and AFSA_ActionDR = :rowid)
	 	s OldObject=##Class(User.DHCEQCApproveAction).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

	 	&SQL(Delete from SQLUser.DHC_EQCApproveAction where AA_RowID = :rowid)	 	
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		TCOMMIT
	 	Quit SQLCODE 	
	 }
	 i (+isDel=2) //更新按钮操作
	 {
		Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCApproveAction).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update SQLUSER.DHC_EQCApproveAction Values :PLIST() where AA_RowID = :rowid)
	 	i SQLCODE
	 	{
	 		TROLLBACK
	 		q SQLCODE
	 	}
	 } 
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCApproveAction).%OpenId(ID))

	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
	}
 	TCOMMIT
 	q SQLCODE
ERROR 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2010-02-28  No ZY0018
/// 描述：根据rowid取数据
/// -------------------------------
ClassMethod GetDataByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQCCode("DHCEQCApproveAction",rowid))
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// 修改:zy 2010-02-28  No ZY0018
/// 描述:取审批角色可以操作的动作
/// w ##Class(web.DHCEQCApproveAction).GetApproveActions("37","2","19")
ClassMethod GetApproveActions(ApproveSet, CurStep, CurRole)
{
	n (ApproveSet,CurStep, CurRole)
	s AFRowID=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,CurStep,rowid))  q:((rowid="")||(AFRowID'=""))  d
	.s role=$p(^DHCEQCCode("DHCEQCApproveFlow",rowid),"^",2)
	.i CurRole=role s AFRowID=rowid
	
	s Actions=""
	
	i AFRowID'=""  d
	.s AFSARowID=0
	.f  s AFSARowID= $o(^DHCEQCCode("DHCEQCApprFlowStepAction",0,"Flow",AFRowID,AFSARowID)) q:AFSARowID=""  d
	..s AARowID = $p($g(^DHCEQCCode("DHCEQCApprFlowStepAction",AFSARowID)),"^",2)
	..s ClassName = $p($g(^DHCEQCCode("DHCEQCApproveAction",AARowID)),"^",2)
	..s MethodName = $p($g(^DHCEQCCode("DHCEQCApproveAction",AARowID)),"^",3)
	..i Actions="" s Actions=ClassName_","_MethodName
	..e  s Actions=Actions_"^"_ClassName_","_MethodName
	q Actions
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:执行动作
/// 入参:RowID:业务单据的RowID
/// 	 User：操作员
/// 	 Actions：动作信息串
/// 	 EditFieldsInfo：可编辑字段信息
/// 	 AppendInfo:附加信息	
/// w ##Class(web.DHCEQCApproveAction).DoActions("","","","web.DHCEQInStockNew,InsertOtherData^web.DHCEQInStockNew,EditRoleReqFields")
ClassMethod DoActions(RowID, User, Actions, EditFieldsInfo, AppendInfo As %Library.String = "", ActionCode As %Library.String = "")
{
	n Length,Date,Flag
	n Action,ClassName,MethodName
	
	s Length=$L(Actions,"^")
	s Date=+$H
	s Flag=0
	for i=1:1:Length
 	{
	 	q:Flag'=0
	 	
		s Action=$P(Actions,"^",i)
		s ClassName=$P(Action,",",1)
		s MethodName=$P(Action,",",2)
		i (ClassName="web.DHCEQInStockNew")
		{
			;i (MethodName="EditRoleReqFields")  s Flag=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)		//编辑要修改的字段
			;i (MethodName="InsertOtherData")  	s Flag=##class(web.DHCEQInStockNew).ChangeStock(RowID,User,Date)		//写入设备信息
			;i (MethodName="BillUpdateInvoice")  s Flag=##class(web.DHCEQInStockNew).BillUpdateInvoice(RowID)				//修改发票状态
		}
		elseif (ClassName="web.DHCEQStoreMoveNew")
		{
			;i (MethodName="EditRoleReqFields")  s Flag=##class(web.DHCEQStoreMoveNew).EditRoleReqFields(EditFieldsInfo)	//编辑要修改的字段
			;i (MethodName="InsertEQLifeInfo")   s Flag=##class(web.DHCEQStoreMoveNew).InsertEQLifeInfo(RowID,User)		//修改发票状态
			;i (MethodName="InsertChangeStock")  s Flag=##class(web.DHCEQStoreMoveNew).InsertChangeStock(RowID,User)		//写入设备变动信息
			;i (MethodName="UpdateEQWhenOut")  	s Flag=##class(web.DHCEQStoreMoveNew).UpdateEQWhenOut(RowID,User)		//出库时修改设备信息
			;i (MethodName="StoreToLocWhenIn")  	s Flag=##class(web.DHCEQStoreMoveNew).StoreToLocWhenIn(RowID,User)		//入库,库房分配,修改设备信息
			;i (MethodName="LocToLocWhenIn")  	s Flag=##class(web.DHCEQStoreMoveNew).LocToLocWhenIn(RowID,User)		//入库,科室调配,修改设备信息
			;i (MethodName="LocToStoreWhenIn")  	s Flag=##class(web.DHCEQStoreMoveNew).LocToStoreWhenIn(RowID,User)		//入库,科室退库,修改设备信息
		}
		elseif (ClassName="web.DHCEQBudget")
		{
			//##Class(web.DHCEQBudget).UpdateBudgetInfo(7,1,1)
			i (MethodName="UpdateBudgetInfo")  s Flag=##Class(web.DHCEQBudget).UpdateBudgetInfo(7,RowID,1,AppendInfo)	//更新设备预算信息
		}
		elseif (ClassName="web.DHCEQM.DHCEQMMaintRequest")
		{
			i (MethodName="UpdAcceptInfo") s Flag=##class(web.DHCEQM.DHCEQMMaintRequest).UpdAcceptInfo(RowID,User) //Mofied by HHM20160420移动端处理session值		//更新受理人信息
			i (MethodName="UpdFinishInfo") s Flag=##class(web.DHCEQM.DHCEQMMaintRequest).UpdFinishInfo(RowID) //Add by czf	 579085	//更新完成时间
		}
		elseif (ClassName="web.DHCEQ.EM.BUSMMaintRequest") 
		{
			 i (MethodName="SaveRetrieve") 	s Flag=##Class(web.DHCEQ.EM.BUSMMaintRequest).SaveMove(RowID, ActionCode, User)  //add by wy 2022-8-22取回保存配送信息
			 i (MethodName="SaveReturn") 	s Flag=##Class(web.DHCEQ.EM.BUSMMaintRequest).SaveMove(RowID, ActionCode, User)  //add by wy 2022-8-22归还时保存配送信息
			 i (MethodName="UpdFaultEquipMap") s Flag=##Class(web.DHCEQ.EM.BUSMMaintRequest).UpdFaultEquipMap(RowID)  //add by wy 2022-9-14 生成故障原因，解决方法跟设备项对照
		}
 	}
 	q Flag
}

}
