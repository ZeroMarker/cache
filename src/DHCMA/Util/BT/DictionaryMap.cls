/// 名称: DHCMA.Util.BT.DictionaryMap
/// 描述: 基础字典对照表
/// 编写者：pylian
/// 编写日期: 2020-04-07
Class DHCMA.Util.BT.DictionaryMap Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 字典类型
Property MapDicTypeDr As DHCMA.Util.BT.DicTypeMap;

/// 标准描述
Property MapDicDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字典ID
Property MapDicDr As DHCMed.SS.Dictionary;

/// IsActive 是否有效
Property MapIsActive As %Boolean;

/// 对照索引
Index IndexMapDic On (MapDicTypeDr, MapDicDr);

/// 名称索引
Index IndexMapDicDesc On (MapDicTypeDr, MapDicDesc As Exact);

/// Creator     : pylian
/// CreatDate   : 2020-04-07
/// Description : 取基础字典对照表
/// Table       : DHCMA.Util.BT.DictionaryMap
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMA.Util.BT.DictionaryMap).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMA.Util.BT.DictionaryMap
{
	New (aID)
	Quit:'##class(DHCMA.Util.BT.DictionaryMap).%ExistsId(aID) ""
	Set obj=##class(DHCMA.Util.BT.DictionaryMap).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2020-04-07
/// Description : 更新基础字典对照表
/// Table       : DHCMA.Util.BT.DictionaryMap
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMA.Util.BT.DictionaryMap).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID          = $p(aInputStr,aSeparete,1)
	Set DicDesc     = $p(aInputStr,aSeparete,2) 
	Set DicTypeDr   = $p(aInputStr,aSeparete,3) 
	Set DicDr       = $p(aInputStr,aSeparete,4) 
	Set IsActive    = $p(aInputStr,aSeparete,5) 
	Quit:(DicTypeDr="")||(DicDr="") return
	
	Set tID=$o(^CF.MA.Util.BT.DictionaryMapD("IndexMapDic",DicTypeDr,DicDr,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	Set objMap = ##class(DHCMA.Util.BT.DicTypeMap).GetObjById(DicTypeDr)
	Quit:'$IsObject(objMap) return
	Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicDr)
	Quit:'$IsObject(objDic) return
	If (ID="") {
		Set obj=##class(DHCMA.Util.BT.DictionaryMap).%New()
	} Else {
		Set obj=##class(DHCMA.Util.BT.DictionaryMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MapDicDesc         = DicDesc 
	Set obj.MapDicTypeDr       = objMap    
	Set obj.MapDicDr           = objDic           
	Set obj.MapIsActive        = IsActive  
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2020-04-07
/// Description : 删除基础字典对照表
/// Table       : DHCMA.Util.BT.DictionaryMap
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMA.Util.BT.DictionaryMap).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMA.Util.BT.DictionaryMap).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
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
<Value>MapDicDesc</Value>
</Value>
<Value name="3">
<Value>MapDicTypeDr</Value>
</Value>
<Value name="4">
<Value>MapDicDr</Value>
</Value>
<Value name="5">
<Value>MapIsActive</Value>
</Value>
</Data>
<DataLocation>^CF.MA.Util.BT.DictionaryMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.Util.BT.DictionaryMapD</IdLocation>
<IndexLocation>^CF.MA.Util.BT.DictionaryMapI</IndexLocation>
<StreamLocation>^CF.MA.Util.BT.DictionaryMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
