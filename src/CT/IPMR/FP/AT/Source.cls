/// 名称: CT.IPMR.FP.AT.Source
/// 描述: 适配主表
/// 创建者：zhouyang
/// 创建日期: 2022-04-21
Class CT.IPMR.FP.AT.Source Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 编目配置
Property FAConfigDr As CT.IPMR.FP.Config;

/// Code
Property FACode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property FADesc As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On FACode;

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  取适配主表
/// Table：       CT.IPMR.FP.AT.Source
/// Input：       Id : CT.IPMR.FP.AT.Source.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.AT.Source).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.AT.Source
{
	new (aId)
	quit:'##class(CT.IPMR.FP.AT.Source).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.AT.Source).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  更新适配主表
/// Table：       CT.IPMR.FP.AT.Source
/// Input：       InputStr ：适配器数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.AT.Source).Update("^1^3^5","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set ConfigID	= $p(aInputStr,aSeparate,2)
	Set Code 		= $p(aInputStr,aSeparate,3)
	Set Desc 		= $p(aInputStr,aSeparate,4)
	Quit:(Code="")||(ConfigID="") return
	
	Set objConfig = ##class(CT.IPMR.FP.Config).GetObjById(ConfigID)
	Quit:'$IsObject(objConfig) return

	Set tID=$o(^CT.IPMR.FP.AT.SourceI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:ID'=tID -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.AT.Source).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.AT.Source).%OpenId(ID)
	}
	
	Set obj.FACode			= Code
	Set obj.FADesc			= Desc
	Set obj.FAConfigDr 		= objConfig
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

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  删除适配主表
/// Table：       CT.IPMR.FP.AT.Source
/// Input：       Id : CT.IPMR.FP.AT.Source.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.AT.Source).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.AT.Source).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  导入适配主表
/// Table：       CT.IPMR.FP.AT.Source
/// Input：       InputStr ：工作流代码^操作项目^编目版本^代码^描述
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.AT.Source).ImportSource("IP^病案编目^国家临床版^JCBA^金创病案","^")
ClassMethod ImportSource(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set WFCode	= $p(aInputStr,aSeparate,1)	// 工作流
	Set WIDesc	= $p(aInputStr,aSeparate,2)	// 操作项目
	Set MultiVer	= $p(aInputStr,aSeparate,3)	// 编目版本
	Set Code		= $p(aInputStr,aSeparate,4)	// 代码
	Set Desc		= $p(aInputStr,aSeparate,5)	// 描述
	Set objWorkFlow = ##class(CT.IPMR.BT.WorkFlow).GetObjByCode(WFCode)
	Set objWorkItem = ##class(CT.IPMR.BT.WorkItem).GetObjByDesc(WIDesc)
	Set objMultiVer = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("CodeMultiVer",MultiVer)
	Quit:'$IsObject(objWorkFlow) return
	Quit:'$IsObject(objWorkItem) return
	Quit:'$IsObject(objMultiVer) return
	Set WorkFlowID = objWorkFlow.%Id()
	Set WorkItemID = objWorkItem.%Id()
	
	Set WFISub = $o(^CT.IPMR.BT.WorkFlowI("I","IndexItemDr",WorkFlowID,WorkItemID,0))
	Set objWFItem = ##class(CT.IPMR.BT.WorkFItem).GetObjById(WorkFlowID_"||"_WFISub)
	Quit:'$IsObject(objWFItem) return
	
	Set ConfigID = $o(^CT.IPMR.FP.ConfigI("IndexCodeMultiVer",objWFItem.%Id(),objMultiVer.%Id(),0))
	Set ID = $o(^CT.IPMR.FP.AT.SourceI("IndexCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr = ID
	Set InputStr = InputStr_aSeparate_ConfigID
	Set InputStr = InputStr_aSeparate_Code
	Set InputStr = InputStr_aSeparate_Desc
	Set return = ##class(CT.IPMR.FP.AT.Source).Update(InputStr,aSeparate)
	Quit return
}

Storage Default
{
<Data name="SourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FAConfigDr</Value>
</Value>
<Value name="3">
<Value>FACode</Value>
</Value>
<Value name="4">
<Value>FADesc</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.AT.SourceD</DataLocation>
<DefaultData>SourceDefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.AT.SourceD</IdLocation>
<IndexLocation>^CT.IPMR.FP.AT.SourceI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.AT.SourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
