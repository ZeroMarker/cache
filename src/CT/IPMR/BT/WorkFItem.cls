/// 名称: CT.IPMR.BT.WorkFItem
/// 描述: 工作流操作项目
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.WorkFItem Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As CT.IPMR.BT.WorkFlow [ Cardinality = parent, Inverse = ChildItem ];

/// 操作项目
Property BWItem As CT.IPMR.BT.WorkItem [ Required ];

/// 项目序号
Property BWIndex As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目别名
Property BWAlias As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目类型（顺序项O、突发项E）
Property BWType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 操作流程（顺序O、质控Q、借阅L、复印C、封存S）
Property BWSubFlow As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 操作步骤（在院A、出院D、归档S）
Property BWPostStep As %String(TRUNCATE = 1);

/// 系统操作
Property BWSysOpera As %String(MAXLEN = 100, TRUNCATE = 1);

/// 前置步骤（在院A、出院D、归档S） 多值#分隔
Property BWPreStep As %String(TRUNCATE = 1);

/// 前提操作(指向CT.IPMR.BT.WorkItem) 多值#分隔
Property BWPreItems As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否校验用户
Property BWCheckUser As %Boolean;

/// 是否需要申请
Property BWBeRequest As %Boolean;

/// 是否允许批次操作
Property BWBatchOper As %Boolean;

/// 病历类型（纸张病历1、电子病历2）
Property BWMRCategory As %String(TRUNCATE = 1);

/// 是否有效
Property BWIsActive As %Boolean;

/// 备注
Property BWResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexItemDr On (Parref, BWItem) [ Unique ];

Index IndexItemNo On (Parref As Exact, BWIndex As Exact);

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取工作流操作项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       Id : CT.IPMR.BT.WorkFItem.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFItem).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.WorkFItem
{
	New (aId)
	Quit:'##class(CT.IPMR.BT.WorkFItem).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.BT.WorkFItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     WHui
/// CreatDate：   2019-11-20
/// Description:  根据病案类型取初始状态对应工作流项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFItem).GetInitWFItem(7)
ClassMethod GetInitWFItem(aMrTypeID As %String) As CT.IPMR.BT.WorkFItem
{
	New (aMrTypeID)
	Set return=""
	Quit:aMrTypeID="" return
	
	Set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:'$IsObject(objMrType.BMWorkFlow) return
	Set objWorkFlow=objMrType.BMWorkFlow
	For indItm=1:1:objWorkFlow.ChildItem.Count() {
		Quit:return'=""  //退出循环
		Set objWFItem=objWorkFlow.ChildItem.GetAt(indItm)
		Continue:'$IsObject(objWFItem)
		Continue:objWFItem.BWIsActive'=1
		Continue:'$IsObject(objWFItem.BWItem)
		Continue:objWFItem.BWSysOpera'="I"  //初始状态 对应系统操作代码
		Set return=objWFItem
	}
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-24
/// Description:  更新工作流项目信息
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       InputStr : 更新工作流操作项目
///               Separate : 分隔符
/// Return：      return>0:成功（记录ID）  return<=0:失败
/// w ##class(CT.IPMR.BT.WorkFItem).Update("1^^1^Alias^21^24^34^A^A^^1^0^0^0^1^Resume","^")
/// w ##class(CT.IPMR.BT.WorkFItem).Update("1^1^1^Alias^21^24^34^A^A^^1^0^0^0^1^Resume","^")
/// w ##class(CT.IPMR.BT.WorkFItem).Update("1^4^13^归档上架别名^21^24^39^D^S^1#3#7^1^0^0^1^1^归档上架备注","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	;Set ^TMPWHui10251 = $lb(aInputStr,aSeparate)
	Set Parref			= $p(aInputStr,aSeparate,1)	; (工作流ID)(WorkFlow.ID)
	Set Childsub		= $p(aInputStr,aSeparate,2)	; (工作流项目childsub)(WorkFItem.childsub)
	Set ItemID			= $p(aInputStr,aSeparate,3)	; (操作项目ID)(WorkItem.ID)
	Set ItemAlias		= $p(aInputStr,aSeparate,4)	; 项目别名
	Set TypeID			= $p(aInputStr,aSeparate,5)	; (项目类型)(顺序项O,突发项E)(Dictionary.ID)("WorkType")
	Set SubFlowID		= $p(aInputStr,aSeparate,6)	; (操作流程)(顺序O,质控Q,借阅L,复印C,封存S)(Dictionary.ID)("WorkSubFlow")
	Set SysOperaID		= $p(aInputStr,aSeparate,7)	; (系统操作)(Dictionary.ID)(病案回收RC,病案编目FP,病历质控QC,归档上架S...)("SysOperation")
	Set PreStepCode		= $p(aInputStr,aSeparate,8)	; (前提(置)步骤)(在院A,出院D,归档S,多值用"#"分开)(Dictionary.BDCode)("WorkFlowStep")
	Set PreStepCode		= $tr(PreStepCode,",","#")
	Set PostStepCode	= $p(aInputStr,aSeparate,9)	; (操作步骤)(在院A,出院D,归档S)(Dictionary.BDCode)("WorkFlowStep")
	Set PreItems		= $p(aInputStr,aSeparate,10) ; (前提操作)(指向WorkItem) 多值#分隔
	Set IsActive		=+$p(aInputStr,aSeparate,11) ; 是否有效
	Set CheckUser		=+$p(aInputStr,aSeparate,12) ; 校验用户
	Set BeRequest		=+$p(aInputStr,aSeparate,13) ; 需申请
	Set BatchOper		=+$p(aInputStr,aSeparate,14) ; 批量操作
	Set MRCategory		= $p(aInputStr,aSeparate,15) ; 病历类型代码(Dictionary.BDCode)(纸张病历1,电子病历2)("MRCategory")
	Set Resume			= $p(aInputStr,aSeparate,16) ; 备注
	Quit:(Parref="")||(ItemID="")||(TypeID="") return
	
	Set objWorkItem=##class(CT.IPMR.BT.WorkItem).GetObjById(ItemID) ;3 操作项目
	Quit:'$IsObject(objWorkItem) return
	;5 项目类型,(顺序项O、突发项E)
	Set TypeCode=""
	Set objType=##class(CT.IPMR.BT.Dictionary).GetObjById(TypeID)
	If $IsObject(objType){
		Set TypeCode=objType.BDCode
	}
	Quit:TypeCode="" return
	;6 操作流程（顺序O、质控Q、借阅L、复印C、封存S）
	Set SubFlowCode=""
	Set objSubFlow=##class(CT.IPMR.BT.Dictionary).GetObjById(SubFlowID)
	If $IsObject(objSubFlow){
		Set SubFlowCode=objSubFlow.BDCode
	}
	;7 系统操作
	Set SysOperaCode=""
	Set objSysOpera=##class(CT.IPMR.BT.Dictionary).GetObjById(SysOperaID)
	If $IsObject(objSysOpera){
		Set SysOperaCode=objSysOpera.BDCode
	}
	;1 工作流
	Set objParref=##class(CT.IPMR.BT.WorkFlow).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	;2 工作流项目childsub
	If Childsub="" {
		Set obj=##class(CT.IPMR.BT.WorkFItem).%New()
	} Else {
		Set obj=##class(CT.IPMR.BT.WorkFItem).%OpenId(Parref_"||"_Childsub)
	}
	;b	;1
	Quit:obj="" return
	
	Set obj.Parref		= objParref
	Set obj.BWItem		= objWorkItem		; 操作项目
	Set obj.BWAlias		= ItemAlias			; 项目别名
	Set obj.BWType		= TypeCode			; 项目类型（顺序项O、突发项E）
	Set obj.BWSubFlow	= SubFlowCode		; 操作流程（顺序O、质控Q、借阅L、复印C、封存S）
	Set obj.BWSysOpera  = SysOperaCode		; 系统操作
	
	Set obj.BWPreStep	= PreStepCode		; 前置步骤（在院A、出院D、归档S） 多值#分隔
	Set obj.BWPostStep  = PostStepCode		; 操作步骤（在院A、出院D、归档S）
	Set obj.BWPreItems  = PreItems			; 前提操作(指向CT.IPMR.BT.WorkItem) 多值#分隔
	
	Set obj.BWIsActive	= IsActive
	Set obj.BWCheckUser	= CheckUser
	Set obj.BWBatchOper	= BatchOper
	Set obj.BWBeRequest = BeRequest
	Set obj.BWMRCategory= MRCategory
	Set obj.BWResume	= Resume
	//设置工作流项目顺序号
	If obj.BWIndex="" {
		Set ItemIndex=..GetMaxIndex(Parref)
		Set ItemIndex=ItemIndex+1
		Set obj.BWIndex=ItemIndex
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

/// Creator：     WHui
/// CreatDate：   2019-10-24
/// Description:  取值工作流项目最大顺序号
/// Table：       CT.IPMR.BT.WorkFlow	CT.IPMR.BT.WorkFItem
/// Input：       WFlowID : 工作流ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(CT.IPMR.BT.WorkFItem).GetMaxIndex(1)
ClassMethod GetMaxIndex(aWFlowID As %String) As %String
{
	New (aWFlowID)
	Set return=0
	Quit:(aWFlowID="") return
	
	Set xSub="",MaxIndex=0
 	FOr {
	 	Set xSub = $O(^CT.IPMR.BT.WorkFlowD(aWFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
		Set objWFItem=..GetObjById(aWFlowID_"||"_xSub)
		Continue:'$IsObject(objWFItem)
		Set ItemIndex=objWFItem.BWIndex
		Set ItemIndex=+ItemIndex
		Continue:ItemIndex<=MaxIndex
		Set MaxIndex=ItemIndex
 	}
	Set return=MaxIndex
	
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-26
/// Description:  交换两个.工作流操作项目.顺序
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       Id1 ：前一项目ID
///               Id2 ：后一项目ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.WorkFItem).SwapIndex("1||2","1||1")
ClassMethod SwapIndex(aId1 As %String, aId2 As %String)
{
	New (aId1,aId2)
	Set return=0
	Quit:(aId1="")||(aId2="") return
	
	Set obj=..GetObjById(aId1)
	Quit:'$IsObject(obj) return
	Set ItemIndex1=obj.BWIndex
	
	Set obj=..GetObjById(aId2)
	Quit:'$IsObject(obj) return
	Set ItemIndex2=obj.BWIndex
	
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

/// Creator：     WHui
/// CreatDate：   2019-10-26
/// Description:  保存工作流操作项.顺序号
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       Id : CT.IPMR.BT.WorkFItem.ID
///               Index : 顺序号
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(CT.IPMR.BT.WorkFItem).UpdateIndex("1||1",2)
ClassMethod UpdateIndex(aId As %String, aIndex As %String) As %String
{
	New (aId,aIndex)
	Set return=0
	Quit:(aId="")||(aIndex="") return
	
	Set obj=##class(CT.IPMR.BT.WorkFItem).%OpenId(aId)
	Quit:'$IsObject(obj) return
	Set obj.BWIndex=aIndex
	
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

/// Creator：     zhouyang
/// CreatDate：   2019-12-18
/// Description:  根据病案类型和操作项取工作流项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       aMrTypeID : 病案类型ID
///               aWorkItemID ：操作项ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFItem).GetWFItem(7,1)
ClassMethod GetWFItem(aMrTypeID As %String, aWorkItemID As %String) As CT.IPMR.BT.WorkFItem
{
	new (aMrTypeID,aWorkItemID)
	set return=""
	quit:(aMrTypeID="")||(aWorkItemID="") return
	
	set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.BMWorkFlow) return
	set WorkFlowID=objMrType.BMWorkFlow.%Id()
	set xSub=$o(^CT.IPMR.BT.WorkFlowI("I","IndexItemDr",WorkFlowID,aWorkItemID,0))
	quit:xSub="" return
	set return=##class(CT.IPMR.BT.WorkFItem).GetObjById(WorkFlowID_"||"_xSub)
	quit return
}

/// Creator：     liyi
/// CreatDate：   2023-04-11
/// Description:  根据病案类型和操作项取下一个工作流项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       aMrTypeID : 病案类型ID
///               aWorkItemID ：操作项ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFItem).GetNextWFItem(7,11)
ClassMethod GetNextWFItem(aMrTypeID As %String, aWorkItemID As %String) As CT.IPMR.BT.WorkFItem
{
	new (aMrTypeID,aWorkItemID)
	set return=""
	quit:(aMrTypeID="")||(aWorkItemID="") return
	
	set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.BMWorkFlow) return
	set WorkFlowID=objMrType.BMWorkFlow.%Id()
	set xSub=$o(^CT.IPMR.BT.WorkFlowI("I","IndexItemDr",WorkFlowID,aWorkItemID,0))
	quit:xSub="" return
	set objWorkItem=##class(CT.IPMR.BT.WorkFItem).GetObjById(WorkFlowID_"||"_xSub)
	quit:'$IsObject(objWorkItem) return
	Set Index = objWorkItem.BWIndex
	Set Index = $o(^CT.IPMR.BT.WorkFlowI("I","IndexItemNo",WorkFlowID,Index))
	Set xSub = $o(^CT.IPMR.BT.WorkFlowI("I","IndexItemNo",WorkFlowID,Index,0))
	quit:xSub="" return
	set obj=##class(CT.IPMR.BT.WorkFItem).GetObjById(WorkFlowID_"||"_xSub)
	quit:'$IsObject(obj) return
	quit:obj.BWType'="O" return
	if obj.BWSysOpera="FP" {	// 编目不能撤销
		if $isobject(obj) {
			Set obj = ##class(CT.IPMR.BT.WorkFItem).GetNextWFItem(aMrTypeID,obj.BWItem.%Id())
		}
	}
	Set return=obj
	quit return
}

/// Creator：     WHui
/// CreatDate：   2019-12-25
/// Description:  根据病案类型,系统操作代码"SysOperation"取工作流项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// 			  aSysOpera : CT_IPMR_BT.Dictionary.BDCode
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFItem).GetWFItemBySysOpera(7,"RC")
ClassMethod GetWFItemBySysOpera(aMrTypeID As %String, aSysOpera As %String, aWorkSubFlow As %String = "") As CT.IPMR.BT.WorkFItem
{
	New (aMrTypeID,aSysOpera,aWorkSubFlow)
	Set return=""
	Quit:(aMrTypeID="")||(aSysOpera="") return
	
	Set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:'$IsObject(objMrType.BMWorkFlow) return
	Set objWorkFlow=objMrType.BMWorkFlow
	for indItm=1:1:objWorkFlow.ChildItem.Count() {
		Quit:return'=""  //退出循环
		Set objWFItem = objWorkFlow.ChildItem.GetAt(indItm)
		Continue:'$IsObject(objWFItem)
		Continue:objWFItem.BWIsActive'=1
		Continue:'$IsObject(objWFItem.BWItem)
		Continue:objWFItem.BWSysOpera'=aSysOpera  //系统操作代码
		if aWorkSubFlow'="" {
			Continue:objWFItem.BWSubFlow'=aWorkSubFlow  //系统操作代码
		}
		Set return = objWFItem
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BWItem</Value>
</Value>
<Value name="3">
<Value>BWIndex</Value>
</Value>
<Value name="4">
<Value>BWAlias</Value>
</Value>
<Value name="5">
<Value>BWType</Value>
</Value>
<Value name="6">
<Value>BWSubFlow</Value>
</Value>
<Value name="7">
<Value>BWPostStep</Value>
</Value>
<Value name="8">
<Value>BWSysOpera</Value>
</Value>
<Value name="9">
<Value>BWPreStep</Value>
</Value>
<Value name="10">
<Value>BWPreItems</Value>
</Value>
<Value name="11">
<Value>BWCheckUser</Value>
</Value>
<Value name="12">
<Value>BWBeRequest</Value>
</Value>
<Value name="13">
<Value>BWBatchOper</Value>
</Value>
<Value name="14">
<Value>BWMRCategory</Value>
</Value>
<Value name="15">
<Value>BWIsActive</Value>
</Value>
<Value name="16">
<Value>BWResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^CT.IPMR.BT.WorkFlowI("I")</IndexLocation>
<StreamLocation>^CT.IPMR.BT.WorkFItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
