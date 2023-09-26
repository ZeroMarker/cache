/// 标准字典关联检验项目
Class DHCMA.CPW.SD.Stand.TestCodeLink Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 字典子项
Property DicSub As DHCMA.CPW.SD.Stand.Dicsub;

/// 关联检验项目 DHCMA.Util.EPx.TestCode
Property TestCodeDr As DHCMA.Util.EPx.TestCode;

Index IdxDicSub On DicSub;

Index IdxDicTC On (DicSub As Exact, TestCodeDr As Exact);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.TestCodeLink
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.TestCodeLink).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.TestCodeLink).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zgz
/// CreatDate：   2021-03-30
/// Description:  更新标准化-检验项目对照
/// Table：       DHCMA.CPW.SD.Stand.TestCodeLink
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID      		= $p(aInputStr,aSeparete,1)
	Set DicSubId      	= $p(aInputStr,aSeparete,2)
	Set TestCodeID      = $p(aInputStr,aSeparete,3)	
	Quit:(DicSubId="") return
	Set objDicSub=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(DicSubId)
	Quit:'$IsObject(objDicSub) return
	Set objTestCode=""
	Set:TestCodeID'="" objTestCode=##class(DHCMA.Util.EPx.TestCode).GetObjById(TestCodeID)
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.TestCodeLink).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.TestCodeLink).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.DicSub     	= objDicSub
	Set obj.TestCodeDr	= objTestCode
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zgz
/// CreatDate：   2021-03-30
/// Description:  删除标准化-检验项目对照
/// Table：       DHCMA.CPW.SD.Stand.TestCodeLink
/// Input：       aId :  DHCMA.CPW.SD.Stand.TestCodeLink.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.TestCodeLink).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.TestCodeLink).%DeleteId(aId)
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
<Data name="TestCodeLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DicSub</Value>
</Value>
<Value name="3">
<Value>TestCodeDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.TCLD</DataLocation>
<DefaultData>TestCodeLinkDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.TCLD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.TCLI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.TCLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
