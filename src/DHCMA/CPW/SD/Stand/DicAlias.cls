Class DHCMA.CPW.SD.Stand.DicAlias Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联字典/字典子项ID
Property LinkDicID As %String;

/// 别名
Property Alias As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxAlias On Alias As Exact;

Index IdxDicAlias On (LinkDicID As Exact, Alias As Exact);

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.DicAlias
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.DicAlias).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.DicAlias).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新项目标准化字典子项
/// Table：       DHCMA.CPW.SD.Stand.DicAlias
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.DicAlias).Update("125^心电检查")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID		 	 	 = $p(aInputStr,aSeparete,1)
	Set LinkDicID		 = $p(aInputStr,aSeparete,2)
	Set Alias          	 = $p(aInputStr,aSeparete,3)
	Quit:(LinkDicID="")||(Alias="") return
	Set:ID="" ID=$o(^DHCMA.CPW.SD.Stand.DicAliasI("IdxDicAlias",LinkDicID,Alias,""),-1)
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.DicAlias).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.DicAlias).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.LinkDicID     = LinkDicID
	Set obj.Alias 	  	  = Alias
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
/// CreatDate：   2021-05-07
/// Description:  删除项目标准化字典别名
/// Table：       DHCMA.CPW.SD.Stand.DicAlias
/// Input：       aId :  DHCMA.CPW.SD.Stand.DicAlias.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.DicAlias).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.DicAlias).%DeleteId(aId)
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
<Data name="DicAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkDicID</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.DicAliasD</DataLocation>
<DefaultData>DicAliasDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.DicAliasD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.DicAliasI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.DicAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
