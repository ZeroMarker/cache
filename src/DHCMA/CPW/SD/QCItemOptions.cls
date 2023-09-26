/// 名称: DHCMA.CPW.SD.QCItemOptions
/// 描述: 单病种质控项目选项（值域）
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCItemOptions Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目
Property EntityItemDr As DHCMA.CPW.SD.QCEntityItem;

/// 项目选项代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目选项描述
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目选项更新日期
Property BTDate As %String;

/// 项目选项更新时间
Property BTTime As %String;

Property BTActive As %String;

/// 项目选项操作人
Property BTUpdateUser As %String;

/// 项目选项排序
Property BTIndNo As %String;

Index IndexOfItem On EntityItemDr;

Index IndexOfItemDrCode On (EntityItemDr, BTCode) [ Unique ];

/// w ##class(DHCMA.CPW.SD.QCItemOptions).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCItemOptions
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCItemOptions).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCItemOptions).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCItemOptions).Update("9||283^^a^医嘱离院^1^1^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set EntityItemDr	 = $p(aInputStr,aSeparete,1)
	Set ID               = $p(aInputStr,aSeparete,2)	
	Set Code             = $p(aInputStr,aSeparete,3)
	Set Desc             = $p(aInputStr,aSeparete,4)
	Set Date             = +$h
	Set Time             = $p($h,",",2)
	Set IsActive         = $p(aInputStr,aSeparete,5)
	Set UpdateUser       = $p(aInputStr,aSeparete,6)
	Set IndNo            = $p(aInputStr,aSeparete,7)               
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCItemOptions).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCItemOptions).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.EntityItemDr        =##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(EntityItemDr)
	Set obj.BTCode        		= Code
	Set obj.BTDesc        		= Desc
	Set obj.BTDate				= Date
	Set obj.BTTime				= Time
	Set obj.BTActive    		= IsActive
	Set obj.BTUpdateUser		= UpdateUser
	Set obj.BTIndNo				= IndNo
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

/// w ##class(DHCMA.CPW.SD.QCItemOptions).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCItemOptions).%DeleteId(aId)
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
<Data name="QCItemOptionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EntityItemDr</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTDate</Value>
</Value>
<Value name="6">
<Value>BTTime</Value>
</Value>
<Value name="7">
<Value>BTIndex</Value>
</Value>
<Value name="8">
<Value>BTUpdateUser</Value>
</Value>
<Value name="9">
<Value>BTActive</Value>
</Value>
<Value name="10">
<Value>BTIndNo</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCItemOptionsD</DataLocation>
<DefaultData>QCItemOptionsDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCItemOptionsD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCItemOptionsI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCItemOptionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
