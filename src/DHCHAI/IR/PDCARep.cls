/// 名称: DHCHAI.IR.PDCARep
/// 描述: PDCA报告
/// 编写者：ShenC
/// 编写日期: 2022-09-14
Class DHCHAI.IR.PDCARep Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.PDCARepExt [ Cardinality = children, Inverse = Parref ];

/// 整改科室
Relationship ChildLoc As DHCHAI.IR.PDCARepLoc [ Cardinality = children, Inverse = Parref ];

/// 更新日志
Relationship ChildLog As DHCHAI.IR.PDCARepLog [ Cardinality = children, Inverse = Parref ];

/// 项目类型
Property PAItemType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目名称
Property PAItemDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 指标名称
Property PAItemIndex As DHCHAI.IR.PDCAIndexBase [ Required ];

/// 登记日期
Property PARegDate As %Date;

/// 登记时间
Property PARegTime As %Time;

/// 登记科室
Property PARegLocDr As DHCHAI.BT.Location;

/// 登记人
Property PARegUser As DHCHAI.BT.SysUser;

/// 目标值
Property PATargetVal As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 模板类型
Property PAModTypeDr As DHCHAI.IR.PDCAMod;

/// 项目类型索引
Index IndexItemType On PAItemType As Exact;

/// 登记日期索引
Index IndexRegDate On PARegDate As Exact;

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  根据ID取PDCA报告
/// Table：       DHCHAI.IR.PDCARep
/// Input：       aId : DHCHAI.IR.PDCARep.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCARep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.PDCARep
{
	New (aId)
	Quit:'##class(DHCHAI.IR.PDCARep).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.PDCARep).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-06-28
/// Description:  更新PDCA报告
/// Table：       DHCHAI.IR.PDCARep
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARep).Update("^123^降低呼吸机肺炎感染发病率^1^^^474^821^1^22^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID				= $p(aInputStr,aSeparete,1)
	Set ItemType		= $p(aInputStr,aSeparete,2)		//PDCA项目
	Set ItemDesc		= $p(aInputStr,aSeparete,3)		//PDCA名称
	Set ItemIndexID		= $p(aInputStr,aSeparete,4)		//指标名称
	Set objItemIndex	=##class(DHCHAI.IR.PDCAIndexBase).GetObjById(ItemIndexID)
	Quit:'$ISObject(objItemIndex) return
	Set RegDate			= $p(aInputStr,aSeparete,5)		//登记日期
	Set RegDate			=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RegDate)
	Set:RegDate="" RegDate=+$h
	Set RegTime			= $p(aInputStr,aSeparete,6)		//登记时间
	Set:RegTime[":" RegTime=$zth(RegTime,1)
	Set:RegTime="" RegTime=$p($h,",",2)
	Set RegLocID		= $p(aInputStr,aSeparete,7)		//登记科室
	Set objRegLoc		=##class(DHCHAI.BT.Location).GetObjById(RegLocID)
	Quit:'$ISObject(objRegLoc) return
	Set RegUserID		= $p(aInputStr,aSeparete,8)		//登记人
	Set objRegUser=##class(DHCHAI.BT.SysUser).GetObjById(RegUserID)
	Quit:'$ISObject(objRegUser) return
	Set TargetVal		= $p(aInputStr,aSeparete,9)		//目标值
	Set ModTypeID		= $p(aInputStr,aSeparete,10)	//模板ID
	
	Set objModType=##class(DHCHAI.IR.PDCAMod).GetObjById(ModTypeID)
	Quit:'$ISObject(objModType) return
	If ID="" {
		Set obj=##class(DHCHAI.IR.PDCARep).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.PDCARep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
		
	Set obj.PAItemType		= ItemType
	Set obj.PAItemDesc		= ItemDesc
	Set obj.PAItemIndex		= objItemIndex
	Set obj.PARegDate		= RegDate
	Set obj.PARegTime 		= RegTime
	Set obj.PARegLocDr		= objRegLoc
	Set obj.PARegUser		= objRegUser
	Set obj.PATargetVal		= TargetVal
	Set obj.PAModTypeDr		= objModType
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

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  删除PDCA报告
/// Table：       DHCHAI.IR.PDCARep
/// Input：       aId : DHCHAI.IR.PDCARep.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARep).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCARep).%DeleteId(aID)
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
<Data name="PDCARepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAItemType</Value>
</Value>
<Value name="3">
<Value>PAItemDesc</Value>
</Value>
<Value name="4">
<Value>PAItemIndex</Value>
</Value>
<Value name="5">
<Value>PARegDate</Value>
</Value>
<Value name="6">
<Value>PARegTime</Value>
</Value>
<Value name="7">
<Value>PARegLocDr</Value>
</Value>
<Value name="8">
<Value>PARegUser</Value>
</Value>
<Value name="9">
<Value>PATargetVal</Value>
</Value>
<Value name="10">
<Value>PAModTypeDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.PDCARepD</DataLocation>
<DefaultData>PDCARepDefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.PDCARepD</IdLocation>
<IndexLocation>^MA.HAI.IR.PDCARepI</IndexLocation>
<StreamLocation>^MA.HAI.IR.PDCARepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
