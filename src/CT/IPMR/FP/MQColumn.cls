/// 名称: CT.IPMR.FP.MQColumn
/// 描述: 输出列配置
/// 创建者：liyi
/// 创建日期: 2019-12-11
Class CT.IPMR.FP.MQColumn Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 输出列代码
Property FMCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输出列名称
Property FMDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编目数据项（编目数据项代码,多值逗号分隔）
Property FMDataItems As %String(MAXLEN = 20000, TRUNCATE = 1);

/// 输出分类
Property FMColCatDr As CT.IPMR.BT.Dictionary [ Required ];

/// 是否有效
Property FMIsActive As %Boolean;

/// 排序码
Property FMOrderNo As %String(TRUNCATE = 1);

Index IndexCode On FMCode [ Unique ];

Index IndexDesc On FMDesc;

Index IndexColCatOrderNo On (FMColCatDr, FMOrderNo As Exact);

Index IndexOrderNoCode On (FMOrderNo As Exact, FMCode);

/// Creator：     liyi
/// CreatDate：   2019-12-11
/// Description:  取输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       Id : CT.IPMR.FP.MQColumn.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.MQColumn).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.MQColumn
{
	new (aId)
	quit:'##class(CT.IPMR.FP.MQColumn).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.MQColumn).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-12-11
/// Description:  更新输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.MQColumn).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID				= $p(aInputStr,aSeparate,1)
	Set Code			= $p(aInputStr,aSeparate,2)
	Set Desc 			= $p(aInputStr,aSeparate,3)
	Set DataItems 		= $p(aInputStr,aSeparate,4)
	Set ColCatID		= $p(aInputStr,aSeparate,5)
	Set IsActive		= +$p(aInputStr,aSeparate,6)
	Set OrderNo			= $p(aInputStr,aSeparate,7)
	Quit:(Code="")||(Desc="") return
	
	Set objColCat = ##class(CT.IPMR.BT.Dictionary).GetObjById(ColCatID)
	Quit:'$IsObject(objColCat) return
	
	Set tID = $o(^CT.IPMR.FP.MQColumnI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Quit:(ID'="")&&(ID'=tID) return
	Set ID = tID
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.MQColumn).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.MQColumn).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FMCode			= Code
	Set obj.FMDesc			= Desc
	Set obj.FMDataItems		= DataItems
	Set obj.FMColCatDr		= objColCat
	Set obj.FMIsActive		= IsActive
	Set obj.FMOrderNo 		= OrderNo 
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

/// Creator：     liyi
/// CreatDate：   2019-12-11
/// Description:  删除输出列配置
/// Table：       CT.IPMR.FP.MQColumn
/// Input：       Id : CT.IPMR.FP.MQColumn.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.MQColumn).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.MQColumn).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FMCode</Value>
</Value>
<Value name="3">
<Value>FMDesc</Value>
</Value>
<Value name="4">
<Value>FMDataItems</Value>
</Value>
<Value name="5">
<Value>FMColCatDr</Value>
</Value>
<Value name="6">
<Value>FMIsActive</Value>
</Value>
<Value name="7">
<Value>FMOrderNo</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.MQColumnD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.MQColumnD</IdLocation>
<IndexLocation>^CT.IPMR.FP.MQColumnI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.MQColumnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
