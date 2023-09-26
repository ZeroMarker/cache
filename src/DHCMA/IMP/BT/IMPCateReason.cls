/// 名称: DHCMA.IMP.BT.IMPCateReason
/// 描述: 重点患者特因分类
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.BT.IMPCateReason Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.BT.IMPCategory [ Cardinality = parent, Inverse = ChildReason ];

/// 特因分类
Property BTReasonDr As DHCMA.IMP.BT.IMPReasonDic;

/// 是否有效
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者分类+特因分类 索引
Index IdxOfCateReason On (Parref, BTReasonDr) [ Unique ];

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  根据ID取重点患者特因信息
/// Table：       DHCMA.IMP.BT.IMPCateReason
/// Input：       aId : DHCMA.IMP.BT.IMPCateReason.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPCateReason).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPCateReason
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPCateReason).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPCateReason).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  更新重点患者特因信息
/// Table：       DHCMA.IMP.BT.IMPCateReason
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateReason).Update("6^^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^TEMPZDC20201013=aInputStr
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		      		= $p(aInputStr,aSeparete,1)
	set ChildSub     			= $p(aInputStr,aSeparete,2)
	Set ReasonDr                = $p(aInputStr,aSeparete,3)
	Set BTIsActive   			= +$p(aInputStr,aSeparete,4)
	Set BTActDate    			= $p(aInputStr,aSeparete,5)
	Set BTActTime    			= $p(aInputStr,aSeparete,6)
	Set BTActUserID  			= $p(aInputStr,aSeparete,7)
	Quit:(ReasonDr="") return
	
	Set ID=""
	Set tID=$o(^CT.MA.IMP.BTIMPCategoryI("Reason","IdxOfCateReason"," "_$zcvt(Parref,"U"),ReasonDr,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)
	
	Quit:(Parref="") -1
	Set objParref=##class(DHCMA.IMP.BT.IMPCategory).GetObjById(Parref)
	Quit:'$Isobject(objParref) return
	Set objReason=##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(ReasonDr)
	Quit:'$Isobject(objReason) return
	
	If ChildSub="" {
		Set obj=##class(DHCMA.IMP.BT.IMPCateReason).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.IMP.BT.IMPCateReason).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	set obj.Parref       = objParref
	Set obj.BTReasonDr   = objReason
	Set obj.BTIsActive	 = BTIsActive
	Set obj.BTActDate    = BTActDate
	Set obj.BTActTime    = BTActTime
	Set obj.BTActUserID  = BTActUserID
	
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-18
/// Description:  删除重点患者特因信息
/// Table：       DHCMA.IMP.BT.IMPCateReason
/// Input：       aId : DHCMA.IMP.BT.IMPCateReason.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateReason).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPCateReason).%DeleteId(aId)
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
<Value>BTReasonDr</Value>
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
<DataLocation>{%%PARENT}("Reason")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Reason")</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPCategoryI("Reason")</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPCateReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
