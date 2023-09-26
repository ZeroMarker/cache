/// 名称: CT.IPMR.FP.DataItemMap
/// 描述: 编目数据项对照
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.DataItemMap Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 术语集指针
Property FDGlossaryDr As CT.IPMR.BT.Glossary;

/// 编目数据项指针
Property FDDataItemDr As CT.IPMR.FP.DataItem;

Index IndexDataItemDr On FDDataItemDr;

Index IndexGlossaryDr On FDGlossaryDr [ Unique ];

/// Creator：     liyi
/// CreatDate：   2022-10-12
/// Description:  根据编目数据项取不同首页类型的编目数据项对照ID
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       aDataItemID : 编目数据项ID
/// 				  aFPTypeID ：首页类型ID
/// Return：      返回ID
/// w ##class(CT.IPMR.FP.DataItemMap).GetObjByDataItem()
ClassMethod GetIDByDataItem(aDataItemID As %String, aFPTypeID As %String) As %String
{
	new (aDataItemID,aFPTypeID)
	Set return =""
	Quit:(aDataItemID="")||(aFPTypeID="") return
	
	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.FP.DataItemMapI("IndexDataItemDr",aDataItemID,xID))
	 	Quit:xID=""
	 	Quit:return'=""
	 	Set Str = $g(^CT.IPMR.FP.DataItemMapD(xID))
	 	Continue:Str=""
	 	Set GlossaryID = $lg(Str,2)
	 	Continue:GlossaryID=""
	 	Set GlossaryInfo = $g(^CT.IPMR.BT.GlossaryD(GlossaryID))
	 	Continue:GlossaryInfo=""
	 	Set GlossaryFPTypeID = $lg(GlossaryInfo,2)
	 	Continue:aFPTypeID'[GlossaryFPTypeID
	 	Set return = xID
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  根据编目数据项取不同首页类型的编目数据项对照
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       aDataItemID : 编目数据项ID
/// 				  aFPTypeID ：首页类型ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItemMap).GetObjByDataItem()
ClassMethod GetObjByDataItem(aDataItemID As %String, aFPTypeID As %String) As CT.IPMR.FP.DataItemMap
{
	new (aDataItemID,aFPTypeID)
	Set return =""
	Quit:(aDataItemID="")||(aFPTypeID="") return
	
	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.FP.DataItemMapI("IndexDataItemDr",aDataItemID,xID))
	 	Quit:xID=""
	 	Quit:return'=""
	 	Set obj = ..GetObjById(xID)
	 	Continue:'$isobject(obj)
	 	Continue:'$isobject(obj.FDGlossaryDr)
	 	Continue:'$isobject(obj.FDGlossaryDr.BGFPTypeDr)
	 	;Continue:obj.FDGlossaryDr.BGFPTypeDr.%Id()'=aFPTypeID
	 	Continue:aFPTypeID'[obj.FDGlossaryDr.BGFPTypeDr.%Id()
	 	Set return = obj
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取编目数据项对照
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       Id : CT.IPMR.FP.DataItemMap.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.DataItemMap).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.DataItemMap
{
	new (aId)
	quit:'##class(CT.IPMR.FP.DataItemMap).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.DataItemMap).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新编目数据项对照
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       InputStr ：对照数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.DataItemMap).Update("^1^175","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set GlossaryID	= $p(aInputStr,aSeparate,2)
	Set DataItemID 	= $p(aInputStr,aSeparate,3)
	Quit:(GlossaryID="")||(DataItemID="") return

	Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjById(DataItemID)
	Quit:'$IsObject(objDataItem) return
	
	Set objGlossary = ##class(CT.IPMR.BT.Glossary).GetObjById(GlossaryID)
	Quit:'$IsObject(objGlossary) return
	
	
	Set tID2 = $o(^CT.IPMR.FP.DataItemMapI("IndexGlossaryDr",GlossaryID,""))
	Quit:tID2'="" -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.DataItemMap).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.DataItemMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FDDataItemDr	= objDataItem
	Set obj.FDGlossaryDr	= objGlossary
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
/// CreatDate：   2019-10-08
/// Description:  删除编目数据项对照
/// Table：       CT.IPMR.FP.DataItemMap
/// Input：       Id : CT.IPMR.FP.DataItemMap.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.DataItemMap).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.DataItemMap).%DeleteId(aId)
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
<Value>FDGlossaryDr</Value>
</Value>
<Value name="3">
<Value>FDDataItemDr</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.DataItemMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.DataItemMapD</IdLocation>
<IndexLocation>^CT.IPMR.FP.DataItemMapI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.DataItemMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
