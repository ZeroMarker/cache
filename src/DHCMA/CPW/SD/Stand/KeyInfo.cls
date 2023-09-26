/// 名称: DHCMA.CPW.SD.Stand.KeyInfo
/// 描述: 标准化-基础信息关键字
/// 编写者：zqy
/// 编写日期: 2021-03-30
Class DHCMA.CPW.SD.Stand.KeyInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = "" ]
{

/// 标准化字典子项
Property DicSubId As DHCMA.CPW.SD.Stand.Dicsub;

/// 包含关键字
Property ResultKeys As %String(MAXLEN = 50, TRUNCATE = 1);

/// 排除关键字
Property ResultFilter As %String(MAXLEN = 50, TRUNCATE = 1);

Index IdxDic On DicSubId As Exact;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.KeyInfo
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.KeyInfo).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.KeyInfo).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新标准化-基础信息关键字
/// Table：       DHCMA.CPW.SD.Stand.KeyInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          	= $p(aInputStr,aSeparete,1)
	Set DicSubId        = $p(aInputStr,aSeparete,2)
	Set ResultKeys      = $p(aInputStr,aSeparete,3)
	Set ResultFilter    = $p(aInputStr,aSeparete,4)
	Quit:(DicSubId="") return
	Set objDicSub=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(DicSubId)
	Quit:'$IsObject(objDicSub) return
	Set ID=$o(^DHCMA.CPW.SD.Stand.KeyInfoI("IdxDic",DicSubId,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.KeyInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.KeyInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.DicSubId   	 	= objDicSub
	Set obj.ResultKeys		= ResultKeys
	Set obj.ResultFilter	= ResultFilter
	
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

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  删除标准化-基础信息关键字
/// Table：       DHCMA.CPW.SD.Stand.KeyInfo
/// Input：       aId :  DHCMA.CPW.SD.Stand.KeyInfo.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.BaseMatch).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.KeyInfo).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.SD.Stand.KeyInfo).GetKeyStrByDic("2||6")
ClassMethod GetKeyStrByDic(aDicID) As %String
{
	New (aDicID)
	Set return=""
	Set ID=$o(^DHCMA.CPW.SD.Stand.KeyInfoI("IdxDic",aDicID,0))
	Quit:ID="" return
	Set obj=##class(DHCMA.CPW.SD.Stand.KeyInfo).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set ResultKeys=obj.ResultKeys
	Set ResultFilter=obj.ResultFilter
	Set return=ResultKeys_"^"_ResultFilter
	Quit return
}

Storage Default
{
<Data name="KeyInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DicSubId</Value>
</Value>
<Value name="3">
<Value>ResultKeys</Value>
</Value>
<Value name="4">
<Value>ResultFilter</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.KeyInfoD</DataLocation>
<DefaultData>KeyInfoDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.KeyInfoD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.KeyInfoI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.KeyInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
