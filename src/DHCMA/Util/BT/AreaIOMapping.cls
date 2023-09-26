/// 名称: DHCMA.Util.BT.AreaIOMapping
/// 描述: 省市县乡字典对照数据
/// 编写者：pylian
/// 编写日期: 2021-01-15
Class DHCMA.Util.BT.AreaIOMapping Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 对照源值(地址字典ID)
Property BTSrcID As %String(TRUNCATE = 1) [ Required ];

/// 对照源代码(保留代码为同步处理传染病地址准备)
Property BTSrcCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 对照源名称
Property BTSrcDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 目标字典
Property BTTargetDr As DHCMA.Util.BT.AreaIODictionary;

/// 有效标志
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 字典代码 索引
Index IdxofSrCode On BTSrcCode;

/// 目标字典 索引
Index IdxofTargetDr On BTTargetDr;

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  取对照数据
/// Table：       DHCMA.Util.BT.AreaIOMapping
/// Input：       DHCMA.Util.BT.AreaIOMapping.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.AreaIOMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.AreaIOMapping
{
	New (aId)
	Set obj=##Class(DHCMA.Util.BT.AreaIOMapping).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  更新对照数据
/// Table：       DHCMA.Util.BT.AreaIOMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMA.Util.BT.AreaIOMapping).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set ID       = $p(aInput,aSeparate,1)
	Set SrcID    = $p(aInput,aSeparate,2)
	Set SrcCode  = $p(aInput,aSeparate,3)
	Set SrcDesc  = $p(aInput,aSeparate,4)
	Set TargetDr = $p(aInput,aSeparate,5)
	Set IsActive = $p(aInput,aSeparate,6)
   	Set objTarget = ##class(DHCMA.Util.BT.AreaIODictionary).GetObjById(TargetDr)
	Quit:'$IsObject(objTarget) return
	If (ID="") {
		Set obj=##class(DHCMA.Util.BT.AreaIOMapping).%New()
	} Else {
		Set obj=##class(DHCMA.Util.BT.AreaIOMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTSrcID    =SrcID
	Set obj.BTSrcCode  =SrcCode
	Set obj.BTSrcDesc  =SrcDesc
	Set obj.BTTargetDr =objTarget
	Set obj.BTIsActive =IsActive
	Set obj.BTActDate  =+$h
	Set obj.BTActTime  =$p($h,",",2)
	
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

/// Creator：     pylian
/// CreatDate：   2021-01-18
/// Description:  更新对照数据
/// Table：       DHCMA.Util.BT.AreaIOMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMA.Util.BT.AreaIOMapping).UpdateMap("","^")
ClassMethod UpdateMap(aID As %String, aSrcID As %String, aTargetID As %String) As %String
{
	New (aID,aSrcID,aTargetID)
	Set return=0

	Quit:(aSrcID="")||(aTargetID="") return
	
	Set AreaDic=$g(^DHCMed.SS.AreaDicD(aSrcID))
	Quit:AreaDic="" return
	Set SrcCode=$lg(AreaDic,2)
	Set SrcDesc=$lg(AreaDic,3)
   	Set objTarget = ##class(DHCMA.Util.BT.AreaIODictionary).GetObjById(aTargetID)
    Quit:'$IsObject(objTarget) return
	If (aID="") {
		Set obj=##class(DHCMA.Util.BT.AreaIOMapping).%New()
	} Else {
		Set obj=##class(DHCMA.Util.BT.AreaIOMapping).%OpenId(aID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTSrcID    =aSrcID
	Set obj.BTSrcCode  =SrcCode
	Set obj.BTSrcDesc  =SrcDesc
	Set obj.BTTargetDr =objTarget
	Set obj.BTIsActive =1
	Set obj.BTActDate  =+$h
	Set obj.BTActTime  =$p($h,",",2)
	
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

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  删除对照数据
/// Table：       DHCMA.Util.BT.AreaIOMapping
/// Input：       DHCMA.Util.BT.AreaIOMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMA.Util.BT.AreaIOMapping).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
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
<Value>BTSrcID</Value>
</Value>
<Value name="3">
<Value>BTSrcCode</Value>
</Value>
<Value name="4">
<Value>BTSrcDesc</Value>
</Value>
<Value name="5">
<Value>BTTargetDr</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
</Data>
<DataLocation>^CF.MA.Util.BT.AreaIOMappingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.Util.BT.AreaIOMappingD</IdLocation>
<IndexLocation>^CF.MA.Util.BT.AreaIOMappingI</IndexLocation>
<StreamLocation>^CF.MA.Util.BT.AreaIOMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
