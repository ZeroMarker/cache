/// 名称: DHCMA.IMP.BT.IMPCateKeys
/// 描述: 重点患者筛查关键词
/// 编写者：zhufei
/// 编写日期: 2020-9-25
Class DHCMA.IMP.BT.IMPCateKeys Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.BT.IMPCategory [ Cardinality = parent, Inverse = ChildKeys ];

/// 关键词
Property BTKeywordDr As DHCMA.IMP.BT.IMPKeyword;

/// 是否有效
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// Creator：     zhangdc
/// CreatDate：   2020-09-27
/// Description:  根据ID取对象
/// Table：       DHCMA.IMP.BT.IMPCateKeys
/// Input：       aId : DHCMA.IMP.BT.IMPCateKeys.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPCateKeys).GetObjById("")
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPCateKeys
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPCateKeys).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPCateKeys).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-09-27
/// Description:  更新实体对象
/// Table：       DHCMA.IMP.BT.IMPCateKeys
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateKeys).Update("^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		 = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set:ChildSub["||" ChildSub= $p(ChildSub,"||",2)
	Set BTKeywordDr  = $p(aInputStr,aSeparete,3)
	Set BTIsActive   = +$p(aInputStr,aSeparete,4)
	Set BTActDate    = $p(aInputStr,aSeparete,5)
	Set BTActTime    = $p(aInputStr,aSeparete,6)
	Set BTActUserID  = $p(aInputStr,aSeparete,7)
	Quit:(BTKeywordDr="") return
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)	
	
	Quit:(Parref="") -1
	Set objCategory = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(Parref)
	Quit:'$Isobject(objCategory) -1
	Set objKeyword=##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(BTKeywordDr)
	Quit:'$Isobject(objKeyword) return
	
	If ChildSub="" {
		Set obj=##class(DHCMA.IMP.BT.IMPCateKeys).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.IMP.BT.IMPCateKeys).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objCategory  //对象
	Set obj.BTKeywordDr	 = objKeyword 
	Set obj.BTIsActive	 = BTIsActive
	Set obj.BTActDate    = BTActDate
	Set obj.BTActTime    = BTActTime
	Set obj.BTActUserID  = BTActUserID	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=$p(obj.%Id(),"||",2)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-09-27
/// Description:  删除对象信息
/// Table：       DHCMA.IMP.BT.IMPCateKeys
/// Input：       aId : DHCMA.IMP.BT.IMPCateKeys.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateKeys).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPCateKeys).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTKeywordDr</Value>
</Value>
<Value name="3">
<Value>BTIsActive</Value>
</Value>
<Value name="4">
<Value>BTActDate</Value>
</Value>
<Value name="5">
<Value>BTActTime</Value>
</Value>
<Value name="6">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Keys")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Keys")</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPCategoryI("Keys")</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPCateKeysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
