/// 工作流操作项目定义
Class DHCWMR.SS.WorkFItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.WorkFlow [ Cardinality = parent, Inverse = ChildItem ];

/// 操作项目
Property WFIItem As DHCWMR.SS.WorkItem;

/// 项目序号
Property WFIIndex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目别名
Property WFIAlias As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目类型（顺序项O、突发项E）
Property WFIType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作流程（顺序O、质控Q、借阅L、复印C、封存S）
Property WFISubFlow As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作步骤（在院A、出院D、归档S）
Property WFIPostStep As %String(TRUNCATE = 1);

/// 系统操作
Property WFISysOpera As %String(MAXLEN = 100, TRUNCATE = 1);

/// 前置步骤（在院A、出院D、归档S） 多值#分隔
Property WFIPreStep As %String(TRUNCATE = 1);

/// 前提操作(指向DHCWMR.SS.WorkItem) 多值#分隔
Property WFIPreItems As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否校验用户
Property WFICheckUser As %Boolean;

/// 是否需要申请
Property WFIBeRequest As %Boolean;

/// 是否允许批次操作
Property WFIBatchOper As %Boolean;

/// 病历类型（纸张病历1、电子病历2）
Property WFIMRCategory As %String(TRUNCATE = 1);

/// 是否有效
Property WFIIsActive As %Boolean;

/// 备注
Property WFIResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexItemDr On (Parref, WFIItem) [ Unique ];

Index IndexItemNo On (Parref As Exact, WFIIndex As Exact);

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  取工作流操作项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       Id : DHCWMR.SS.WorkFItem.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.WorkFItem
{
	new (aId)
	quit:'##class(DHCWMR.SS.WorkFItem).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.WorkFItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型和操作项取工作流项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
///               WorkItemID ：操作项ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFItem).GetWFItem(7,1)
ClassMethod GetWFItem(aMrTypeID As %String, aWorkItemID As %String) As DHCWMR.SS.WorkFItem
{
	new (aMrTypeID,aWorkItemID)
	set return=""
	quit:(aMrTypeID="")||(aWorkItemID="") return
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.MTWorkFlow) return
	set WorkFlowID=objMrType.MTWorkFlow.%Id()
	set xSub=$o(^DHCWMR.SS.WorkFlowI("WFI","IndexItemDr",WorkFlowID,aWorkItemID,0))
	quit:xSub="" return
	set return=##class(DHCWMR.SS.WorkFItem).GetObjById(WorkFlowID_"||"_xSub)
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型取初始状态对应工作流项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFItem).GetInitWFItem(7)
ClassMethod GetInitWFItem(aMrTypeID As %String) As DHCWMR.SS.WorkFItem
{
	new (aMrTypeID)
	set return=""
	quit:aMrTypeID="" return
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.MTWorkFlow) return
	set objWorkFlow=objMrType.MTWorkFlow
	for indItm=1:1:objWorkFlow.ChildItem.Count() {
		quit:return'=""  //退出循环
		set objWFItem=objWorkFlow.ChildItem.GetAt(indItm)
		continue:'$IsObject(objWFItem)
		continue:objWFItem.WFIIsActive'=1
		continue:'$IsObject(objWFItem.WFIItem)
		continue:objWFItem.WFISysOpera'="I"  //初始状态 对应系统操作代码
		set return=objWFItem
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型取初始状态对应工作流项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(7,"I")
ClassMethod GetWFItemBySysOpera(aMrTypeID As %String, aSysOpera As %String) As DHCWMR.SS.WorkFItem
{
	new (aMrTypeID,aSysOpera)
	set return=""
	quit:(aMrTypeID="")||(aSysOpera="") return
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.MTWorkFlow) return
	set objWorkFlow=objMrType.MTWorkFlow
	for indItm=1:1:objWorkFlow.ChildItem.Count() {
		quit:return'=""  //退出循环
		set objWFItem=objWorkFlow.ChildItem.GetAt(indItm)
		continue:'$IsObject(objWFItem)
		continue:objWFItem.WFIIsActive'=1
		continue:'$IsObject(objWFItem.WFIItem)
		continue:objWFItem.WFISysOpera'=aSysOpera  //系统操作代码
		set return=objWFItem
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-25
/// Description:  更新工作流项目信息
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       InputStr : 更新工作流操作项目
///               Separate : 分隔符
/// Return：      return>0:成功（记录ID）  return<=0:失败
/// w ##class(DHCWMR.SS.WorkFItem).Update("2^99^O^^A^1^B^1^1^1^^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set Childsub=$p(aInputStr,aSeparate,2)
	Set ItemID=$p(aInputStr,aSeparate,3)
	Set ItemAlias=$p(aInputStr,aSeparate,4)
	Set TypeID=$p(aInputStr,aSeparate,5)
	Set PreStepCode=$p(aInputStr,aSeparate,6)
	Set PreStepCode=$tr(PreStepCode,",","#")
	Set PostStepCode=$p(aInputStr,aSeparate,7)
	Set PreItems=$p(aInputStr,aSeparate,8)
	Set SysOperaID=$p(aInputStr,aSeparate,9)
	Set CheckUser=+$p(aInputStr,aSeparate,10)
	Set BeRequest=+$p(aInputStr,aSeparate,11)
	Set SubFlowID=$p(aInputStr,aSeparate,12)
	Set BatchOper=+$p(aInputStr,aSeparate,13)
	Set MRCategory=$p(aInputStr,aSeparate,14)
	Set IsActive=+$p(aInputStr,aSeparate,15)
	Set Resume=$p(aInputStr,aSeparate,16)
	Quit:(Parref="")||(ItemID="")||(TypeID="") return
	
	Set objWorkItem=##class(DHCWMR.SS.WorkItem).GetObjById(ItemID)
	Quit:'$IsObject(objWorkItem) return
	
	Set TypeCode=""
	Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(TypeID)
	If $IsObject(objType){
		Set TypeCode=objType.SDCode
	}
	Quit:TypeCode="" return
	
	Set SysOperaCode=""
	Set objSysOpera=##class(DHCWMR.SS.Dictionary).GetObjById(SysOperaID)
	If $IsObject(objSysOpera){
		Set SysOperaCode=objSysOpera.SDCode
	}
	
	Set SubFlowCode=""
	Set objSubFlow=##class(DHCWMR.SS.Dictionary).GetObjById(SubFlowID)
	If $IsObject(objSubFlow){
		Set SubFlowCode=objSubFlow.SDCode
	}
	
	Set objParref=##class(DHCWMR.SS.WorkFlow).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If Childsub="" {
		Set obj=##class(DHCWMR.SS.WorkFItem).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.WorkFItem).%OpenId(Parref_"||"_Childsub)
	}
	Quit:obj="" return
	
	Set obj.Parref       = objParref
	Set obj.WFIItem      = objWorkItem
	Set obj.WFIAlias     = ItemAlias
	Set obj.WFIType      = TypeCode
	Set obj.WFIPreStep   = PreStepCode
	Set obj.WFIPostStep  = PostStepCode
	Set obj.WFIPreItems  = PreItems
	Set obj.WFISysOpera  = SysOperaCode
	Set obj.WFICheckUser = CheckUser
	Set obj.WFIBeRequest = BeRequest
	Set obj.WFISubFlow   = SubFlowCode
	Set obj.WFIBatchOper = BatchOper
	Set obj.WFIMRCategory= MRCategory
	Set obj.WFIIsActive  = IsActive
	Set obj.WFIResume    = Resume
	
	//设置工作流项目顺序号
	If obj.WFIIndex="" {
		Set ItemIndex=..GetMaxIndex(Parref)
		Set ItemIndex=ItemIndex+1
		Set obj.WFIIndex=ItemIndex
	}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  保存工作流操作项顺序号
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       Id : DHCWMR.SS.WorkFItem.ID
///               Index : 顺序号
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.WorkFItem).UpdateIndex("4||58",1)
ClassMethod UpdateIndex(aId As %String, aIndex As %String) As %String
{
	New (aId,aIndex)
	Set return=0
	Quit:(aId="")||(aIndex="") return
	
	Set obj=##class(DHCWMR.SS.WorkFItem).%OpenId(aId)
	Quit:'$IsObject(obj) return
	Set obj.WFIIndex=aIndex
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  删除工作流操作项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       Id : DHCWMR.SS.WorkFItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.SS.WorkFItem).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  交换两个流操作项目顺序
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       Id1 ：前一项目ID
///               Id2 ：后一项目ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.WorkFItem).SwapIndex(2,1)
ClassMethod SwapIndex(aId1 As %String, aId2 As %String)
{
	new (aId1,aId2)
	Set return=0
	Quit:(aId1="")||(aId2="") return
	
	Set obj=..GetObjById(aId1)
	Quit:'$IsObject(obj) return
	Set ItemIndex1=obj.WFIIndex
	
	Set obj=..GetObjById(aId2)
	Quit:'$IsObject(obj) return
	Set ItemIndex2=obj.WFIIndex
	
	TStart
	
	Set flg=..UpdateIndex(aId1,ItemIndex2)
	If flg<0 TRollBack
	Quit:flg<0 return
	
	Set flg=..UpdateIndex(aId2,ItemIndex1)
	If flg<0 TRollBack
	Quit:flg<0 return
	
	TCommit
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-18
/// Description:  取值工作流项目最大顺序号
/// Table：       DHCWMR.SS.WorkFlow
/// Input：       WFlowID : 工作流ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.WorkFItem).GetMaxIndex(1)
ClassMethod GetMaxIndex(aWFlowID As %String) As %String
{
	New (aWFlowID)
	Set return=0
	Quit:(aWFlowID="") return
	
	Set xSub="",MaxIndex=0
 	FOr {
	 	Set xSub = $O(^DHCWMR.SS.WorkFlowD(aWFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFlowID_"||"_xSub)
		Continue:'$IsObject(objWFItem)
		Set ItemIndex=objWFItem.WFIIndex
		Set ItemIndex=+ItemIndex
		Continue:ItemIndex<=MaxIndex
		Set MaxIndex=ItemIndex
 	}
	Set return=MaxIndex
	
	Quit return
}

///    Creator：     liyi
///    CreatDate：   2014-08-20
///    Description:  查询已配置的工作流
///    Table：       DHCWMR.SS.WorkFlow、DHCWMR.SS.WorkFItem
///    Input：       WFlowId : 工作流ID
///    Return：      返回Query
///    D ##class(%ResultSet).RunQuery("DHCWMR.SS.WorkFItem","QryWFItemList")
Query QryWFItemList(aWFlowID As %String) As %Query(ROWSPEC = "ID:%String,ItemID:%String,ItemDesc:%String,ItemIndex:%String,TypeCode:%String,TypeDesc:%String,PreStepCode:%String,PreStepDesc:%String,PostStepCode:%String,PostStepDesc:%String,PreItems:%String,SysOperaCode:%String,SysOperaDesc:%String,CheckUser:%String,CheckUserDesc:%String,BeRequest:%String,BeRequestDesc:%String,BatchOper:%String,BatchOperDesc:%String,SubFlow:%String,SubFlowDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QryWFItemListExecute(ByRef qHandle As %Binary, aWFlowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Kill arrWorkFlowItems
 	Set xSub=""
 	FOr {
	 	Set xSub = $O(^DHCWMR.SS.WorkFlowD(aWFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
	 	Set ID=aWFlowID_"||"_xSub
	 	Set obj=..GetObjById(ID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ItemID = obj.WFIItem.%Id()
	 	Set ItemDesc = obj.WFIItem.WIDesc
	 	Set ItemIndex = obj.WFIIndex
	 	
	 	Set TypeCode = obj.WFIType
	 	Set TypeDesc =""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkType",TypeCode,"")
	 	if $IsObject(objDic){
	 		Set TypeDesc=objDic.SDDesc
	 	}
	 	
	 	Set PreStepCode = obj.WFIPreStep
	 	Set PreStepDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkFlowStep",PreStepCode,"")
	 	if $IsObject(objDic){
	 		Set PreStepDesc=objDic.SDDesc
	 	}
	 	
	 	Set PostStepCode = obj.WFIPostStep
	 	Set PostStepDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkFlowStep",PostStepCode,"")
	 	if $IsObject(objDic){
	 		Set PostStepDesc=objDic.SDDesc
	 	}
	 	
	 	Set PreItems = obj.WFIPreItems
	 	
	 	Set SysOperaCode = obj.WFISysOpera
	 	Set SysOperaDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("SysOperation",SysOperaCode,"")
	 	if $IsObject(objDic){
	 		Set SysOperaDesc=objDic.SDDesc
	 	}
	 	
	 	Set CheckUser = obj.WFICheckUser
	 	Set CheckUserDesc=""
	 	Set:CheckUser="1" CheckUserDesc="是"
	 	Set:CheckUser="0" CheckUserDesc="否"
	 	
	 	Set BeRequest = obj.WFIBeRequest
	 	Set BeRequestDesc=""
	 	Set:BeRequest="1" BeRequestDesc="是"
	 	Set:BeRequest="0" BeRequestDesc="否"
	 	
	 	Set SubFlow = obj.WFISubFlow
	 	Set SubFlowDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("MrType",SubFlow,"")
	 	if $IsObject(objDic){
	 		Set SubFlowDesc=objDic.SDDesc
	 	}
	 	
	 	Set BatchOper = obj.WFIBatchOper
	 	Set BatchOperDesc=""
	 	Set:BatchOper="1" BatchOperDesc="是"
	 	Set:BatchOper="0" BatchOperDesc="否"
	 	
	 	Set IsActive = obj.WFIIsActive
	 	Set IsActiveDesc=""
	 	Set:IsActive="1" IsActiveDesc="是"
	 	Set:IsActive="0" IsActiveDesc="否"
	 	
	 	Set Resume = obj.WFIResume
	 	
	 	Set arrWorkFlowItems(ItemIndex)=$lb(ID,ItemID,ItemDesc,ItemIndex,TypeCode,TypeDesc,PreStepCode,PreStepDesc,PostStepCode,PostStepDesc,PreItems,SysOperaCode,SysOperaDesc,CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,SubFlow,SubFlowDesc,IsActive,IsActiveDesc,Resume)
	}
	
	Set xIndex=""
	For {
		Set xIndex=$o(arrWorkFlowItems(xIndex))
		Quit:xIndex=""
		
		Set Data=$g(arrWorkFlowItems(xIndex))
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1	
	}
	Kill arrWorkFlowItems
	
	Quit $$$OK
}

ClassMethod QryWFItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WFIItem</Value>
</Value>
<Value name="3">
<Value>WFIIndex</Value>
</Value>
<Value name="4">
<Value>WFIAlias</Value>
</Value>
<Value name="5">
<Value>WFIType</Value>
</Value>
<Value name="6">
<Value>WFIPreStep</Value>
</Value>
<Value name="7">
<Value>WFIPostStep</Value>
</Value>
<Value name="8">
<Value>WFIPreItems</Value>
</Value>
<Value name="9">
<Value>WFISysOpera</Value>
</Value>
<Value name="10">
<Value>WFICheckUser</Value>
</Value>
<Value name="11">
<Value>WFIBeRequest</Value>
</Value>
<Value name="12">
<Value>WFISubFlow</Value>
</Value>
<Value name="13">
<Value>WFIBatchOper</Value>
</Value>
<Value name="14">
<Value>WFIMRCategory</Value>
</Value>
<Value name="15">
<Value>WFIIsActive</Value>
</Value>
<Value name="16">
<Value>WFIResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^DHCWMR.SS.WorkFlowI("WFI")</IndexLocation>
<StreamLocation>^DHCWMR.SS.WorkFItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
