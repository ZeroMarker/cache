/// 名称: DHCHAI.IR.PDCARepExt
/// 描述: PDCA报告-扩展内容
/// 编写者：ShenC
/// 编写日期: 2022-09-14
Class DHCHAI.IR.PDCARepExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.PDCARep [ Cardinality = parent, Inverse = ChildExt ];

/// 关联项目
Property PAItemDr As DHCHAI.IR.PDCAModExt;

/// 项目名称
Property PAItemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据类型（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property PADataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目值(字典、是/否、有/无)
Property PAResultDr As DHCHAI.BT.Dictionary;

/// 项目值（列表）
Property PAResultList As list Of DHCHAI.BT.Dictionary;

/// 项目值（文本、数值）
Property PAResultTxt As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 更新日期
Property PAActDate As %Date;

/// 更新时间
Property PAActTime As %Time;

/// 更新人
Property PAActUserDr As DHCHAI.BT.SysUser;

/// 索引 关联项目
Index IndexItem On (Parref, PAItemDr As Exact);

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  根据ID取PDCA报告扩展
/// Table：       DHCHAI.IR.PDCARepExt
/// Input：       aId : DHCHAI.IR.PDCARepExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCARepExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.PDCARepExt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.PDCARepExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.PDCARepExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  更新PDCA报告扩展
/// Table：       DHCHAI.IR.PDCARepExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepExt).Update("6^^1||2^问题聚焦-描述^ED^^^<p>2</p>^^^1197#6^^1||19^事件分析开始日期^DD^^^^^^1197#6^^1||20^事件分析结束日期^DD^^^^^^1197")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
    Set Parref     = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set ItemDr	   = $p(aInputStr,aSeparete,3)
	Set ItemDesc   = $p(aInputStr,aSeparete,4)
	Set DataType   = $p(aInputStr,aSeparete,5)
	Set ResultDr   = $p(aInputStr,aSeparete,6)
	Set ResultList = $p(aInputStr,aSeparete,7)
	Set ResultTxt  = $p(aInputStr,aSeparete,8)
	Set ActDate	   = $p(aInputStr,aSeparete,9)
	Set ActTime	   = $p(aInputStr,aSeparete,10)
	Set ActUserDr  = $p(aInputStr,aSeparete,11)

	Quit:(Parref="")||(ItemDr="")||(ItemDesc="") return
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
		
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objItem = ##class(DHCHAI.IR.PDCAModExt).GetObjById(ItemDr)
	Quit:'$IsObject(objItem) return
	Set objResult = ##class(DHCHAI.BT.Dictionary).GetObjById(ResultDr)
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepExt).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.PAItemDr	 = objItem	  
	Set obj.PAItemDesc   = ItemDesc  
	Set obj.PADataType   = DataType  
	Set obj.PAResultDr   = objResult 
    
    //List 数据对象
    While (obj.PAResultList.Count()>0) {
		Do obj.PAResultList.RemoveAt(1)
	}	
	Set idxLB=""
	For ind=1:1:$length(ResultList,"#") {
		Set idxID=$p(ResultList,"#",ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objDic)
		Do obj.PAResultList.Insert(objDic)
	}
	Set obj.PAResultTxt  = ResultTxt 
	Set obj.PAActDate	 = ActDate	  
	Set obj.PAActTime	 = ActTime	  
	Set obj.PAActUserDr  = objActUser
	
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

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  删除PDCA报告扩展
/// Table：       DHCHAI.IR.PDCARepExt
/// Input：       aId : DHCHAI.IR.PDCARepExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.PDCARepExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  根据关联项目获得PDCA扩展表ID
/// Table：       DHCHAI.IR.PDCARep,DHCHAI.IR.PDCARepExt
/// Input：       aReportID : DHCHAI.IR.PDCARep.ID
///               aLabTimDr : DHCHAI.IR.PDCAModExt.ID
/// Return：      返回String
/// w ##class(DHCHAI.IR.PDCARepExt).GetIDByItemDr("1","1||2")
ClassMethod GetIDByItemDr(aReportID As %String, aItemDr) As %String
{
	New (aReportID,aItemDr)
	Set return=""
	Quit:(aReportID="")||(aItemDr="") return
	
	Set return=$o(^MA.HAI.IR.PDCARepI("Ext","IndexItem",aReportID,aItemDr,0))
	
	Quit return
}

Storage Default
{
<Data name="PDCARepExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAItemDr</Value>
</Value>
<Value name="3">
<Value>PAItemDesc</Value>
</Value>
<Value name="4">
<Value>PADataType</Value>
</Value>
<Value name="5">
<Value>PAResultDr</Value>
</Value>
<Value name="6">
<Value>PAResultList</Value>
</Value>
<Value name="7">
<Value>PAResultTxt</Value>
</Value>
<Value name="8">
<Value>PAActDate</Value>
</Value>
<Value name="9">
<Value>PAActTime</Value>
</Value>
<Value name="10">
<Value>PAActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Ext")</DataLocation>
<DefaultData>PDCARepExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Ext")</IdLocation>
<IndexLocation>^MA.HAI.IR.PDCARepI("Ext")</IndexLocation>
<StreamLocation>^MA.HAI.IR.PDCARepExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
