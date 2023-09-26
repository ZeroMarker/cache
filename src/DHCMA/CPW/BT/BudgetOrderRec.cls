/// 名称: DHCMA.CPW.BT.BudgetOrderRec
/// 描述: 表单测算医嘱明细记录类
/// 编写者：yankai
/// 编写日期: 2022-01-25
Class DHCMA.CPW.BT.BudgetOrderRec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 父类
Relationship BRParref As DHCMA.CPW.BT.BudgetCost [ Cardinality = parent, Inverse = ChildOrd ];

/// 表单阶段指针
Property BRFormEpDr As DHCMA.CPW.BT.PathFormEp [ Required ];

/// 表单项目指针	
Property BRFormItemDr As DHCMA.CPW.BT.PathFormItem [ Required ];

/// 表单关联医嘱指针
Property BRFormOrderID As %String;

/// 医嘱类型（医嘱项:测算只针对医嘱项）
Property BROrdTypeDr As DHCMA.Util.BT.Dictionary;

/// 医嘱项ID (指向ARC_Itmmast.Rowid)
Property BROrdMastID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 通用名 指向PHC_Generic
Property BROrdGeneID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医嘱优先级 指向OEC_Priority
Property BROrdPriorityID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 单次剂量
Property BROrdDoseQty As %Float;

/// 剂量单位 指向CT_UOM
Property BROrdUOMID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 频次 指向PHCFreq
Property BROrdFreqID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 疗程 指向PHCDuration
Property BROrdDuratID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 用法 指向PHCInstruc
Property BROrdInstrucID As %String(MAXLEN = 50, TRUNCATE = 1);

/// （长期类医嘱）用药天数（单位天）
Property BROrdUseDays As %Integer;

/// （临时类、出院带药类医嘱）用药数量
Property BROrdQty As %Float;

/// 数量单位（指向CT_UOM）
Property BROrdQtyUomID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 医嘱备注
Property BROrdNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检查部位
Property BROrdChkPosID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关联序号（关联医嘱按1,1.1,1.2…进行排序，其中1为主医嘱，其他为从医嘱）
Property BROrdLnkOrdDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否首选项（默认选项）
Property BROrdIsDefault As %Boolean;

/// 是否主要医嘱
Property BROrdIsFluInfu As %Boolean;

/// 是否有效
Property BROrdIsActive As %Boolean;

/// 排序码
Property BRSeqCode As %Integer;

/// 处置日期
Property BROrdActDate As %Date;

/// 处置时间
Property BROrdActTime As %Time;

/// 处置人（指向DHCMA.CPW.EP.SSUser.OID）
Property BROrdActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     yankai
/// CreatDate：   2022-01-25
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.BudgetOrderRec
/// Input：       aId :  DHCMA.CPW.BT.BudgetOrderRec.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.BudgetOrderRec).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.BudgetOrderRec
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.BudgetOrderRec).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.BudgetOrderRec).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-01-25
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.BudgetOrderRec
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetOrderRec).Update("^83^12000.233^9!!1^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set Parref       		= $p(aInputStr,aSeparete,1)		//Parref
	Set ChildSub			= $p(aInputStr,aSeparete,2)		//SubID
	Set FormEpDr			= $p(aInputStr,aSeparete,3)		//表单阶段
	Set FormItemDr   		= $p(aInputStr,aSeparete,4)		//表单项目
	Set FormOrderID			= $p(aInputStr,aSeparete,5)		//表单关联医嘱
	Set OrdTypeDr			= $p(aInputStr,aSeparete,6)		//医嘱类型
	Set OrdMastID			= $p(aInputStr,aSeparete,7)		//医嘱项ID
	Set OrdGeneID			= $p(aInputStr,aSeparete,8)		//通用名 指向PHC_Generic
	Set OrdPriorityID		= $p(aInputStr,aSeparete,9)		//医嘱优先级 指向OEC_Priority
	Set OrdDoseQty			= $p(aInputStr,aSeparete,10)	//剂量
	Set OrdUOMID			= $p(aInputStr,aSeparete,11)	//剂量单位  指向CT_UOM
	Set OrdFreqID			= $p(aInputStr,aSeparete,12)	//频次 指向PHCFreq
	Set OrdDuratID			= $p(aInputStr,aSeparete,13)	//疗程 指向PHCDuration
	Set OrdInstrucID		= $p(aInputStr,aSeparete,14)	//用法 指向PHCInstruc
	Set OrdUseDays			= $p(aInputStr,aSeparete,15)	//用药天数
	Set OrdQty				= $p(aInputStr,aSeparete,16)	//用药数量
	Set OrdQtyUomID			= $p(aInputStr,aSeparete,17)	//数量单位（指向CT_UOM）
	Set OrdNote				= $p(aInputStr,aSeparete,18)	//医嘱备注
	Set OrdChkPosID			= $p(aInputStr,aSeparete,19)	//检查部位
	Set OrdLnkOrdDr			= $p(aInputStr,aSeparete,20)	//关联序号
	Set OrdIsDefault		= $p(aInputStr,aSeparete,21)	//是否首选项（默认选项）
	Set OrdIsFluInfu		= $p(aInputStr,aSeparete,22)	//是否主要医嘱
	Set OrdIsActive			= $p(aInputStr,aSeparete,23)	//是否有效
	Set SeqCode				= $p(aInputStr,aSeparete,24)	//排序码
	Set OrdActDate			= $p(aInputStr,aSeparete,25)	//处置日期
	Set OrdActTime			= $p(aInputStr,aSeparete,26)	//处置时间
	Set OrdActUserID		= $p(aInputStr,aSeparete,27)	//处置人
	
	Set objParref=##class(DHCMA.CPW.BT.BudgetCost).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
	
	Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(FormEpDr)
	Quit:'$IsObject(objFormEp) -3
	
	Set objFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormItemDr)
	Quit:'$IsObject(objFormItem) -4
	Set objOrdType=##class(DHCMA.Util.BT.Dictionary).GetObjById(OrdTypeDr)
	Quit:'$IsObject(objFormItem) -5
	
	If ChildSub="" {                                  										//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.BudgetOrderRec).%New()	
	}Else{
		Set obj=##class(DHCMA.CPW.BT.BudgetOrderRec).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BRParref		= objParref
	Set obj.BRFormEpDr		= objFormEp
	Set obj.BRFormItemDr	= objFormItem
	Set obj.BRFormOrderID	= FormOrderID
	Set obj.BROrdTypeDr		= objOrdType
	Set obj.BROrdMastID		= OrdMastID
	Set obj.BROrdGeneID		= OrdGeneID
	Set obj.BROrdPriorityID	= OrdPriorityID
	Set obj.BROrdDoseQty	= OrdDoseQty
	Set obj.BROrdUOMID		= OrdUOMID
	Set obj.BROrdFreqID		= OrdFreqID
	Set obj.BROrdDuratID	= OrdDuratID
	Set obj.BROrdInstrucID	= OrdInstrucID
	Set obj.BROrdUseDays	= OrdUseDays
	Set obj.BROrdQty		= OrdQty
	Set obj.BROrdQtyUomID	= OrdQtyUomID
	Set obj.BROrdNote		= OrdNote
	Set obj.BROrdChkPosID	= OrdChkPosID
	Set obj.BROrdLnkOrdDr	= OrdLnkOrdDr
	Set obj.BROrdIsDefault	= OrdIsDefault
	Set obj.BROrdIsFluInfu	= OrdIsFluInfu
	Set obj.BROrdIsActive	= OrdIsActive
	Set obj.BRSeqCode		= SeqCode
	Set obj.BROrdActDate	= +$h
	Set obj.BROrdActTime	= $p($h,",",2)
	Set obj.BROrdActUserID	= OrdActUserID
		
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2022-01-25
/// Description:  删除申请记录
/// Table：       DHCMA.CPW.BT.BudgetOrderRec
/// Input：       aId :  DHCMA.CPW.BT.BudgetOrderRec.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.BudgetOrderRec).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.BT.BudgetOrderRec).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="BudgetOrderRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BRFormEpDr</Value>
</Value>
<Value name="3">
<Value>BRFormItemDr</Value>
</Value>
<Value name="4">
<Value>BRFormOrderID</Value>
</Value>
<Value name="5">
<Value>BROrdTypeDr</Value>
</Value>
<Value name="6">
<Value>BROrdMastID</Value>
</Value>
<Value name="7">
<Value>BROrdGeneID</Value>
</Value>
<Value name="8">
<Value>BROrdPriorityID</Value>
</Value>
<Value name="9">
<Value>BROrdDoseQty</Value>
</Value>
<Value name="10">
<Value>BROrdUOMID</Value>
</Value>
<Value name="11">
<Value>BROrdFreqID</Value>
</Value>
<Value name="12">
<Value>BROrdDuratID</Value>
</Value>
<Value name="13">
<Value>BROrdInstrucID</Value>
</Value>
<Value name="14">
<Value>BROrdUseDays</Value>
</Value>
<Value name="15">
<Value>BROrdQty</Value>
</Value>
<Value name="16">
<Value>BROrdQtyUomID</Value>
</Value>
<Value name="17">
<Value>BROrdNote</Value>
</Value>
<Value name="18">
<Value>BROrdChkPosID</Value>
</Value>
<Value name="19">
<Value>BROrdLnkOrdDr</Value>
</Value>
<Value name="20">
<Value>BROrdIsDefault</Value>
</Value>
<Value name="21">
<Value>BROrdIsFluInfu</Value>
</Value>
<Value name="22">
<Value>BROrdIsActive</Value>
</Value>
<Value name="23">
<Value>BRSeqCode</Value>
</Value>
<Value name="24">
<Value>BROrdActDate</Value>
</Value>
<Value name="25">
<Value>BROrdActTime</Value>
</Value>
<Value name="26">
<Value>BROrdActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORD")</DataLocation>
<DefaultData>BudgetOrderRecDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORD")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.BudgetCostI("ORD")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.BudgetOrderRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
