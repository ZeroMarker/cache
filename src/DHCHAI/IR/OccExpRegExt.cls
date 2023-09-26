/// 名称: DHCHAI.IR.OccExpRegExt
/// 描述: 职业暴露（occupational exposure to infectious materials） 扩展表
/// 编写者：zhufei
/// 编写日期: 2018-04-25
Class DHCHAI.IR.OccExpRegExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.OccExpReg [ Cardinality = parent, Inverse = ChildExt ];

/// 关联项目
Property OEItemDr As DHCHAI.IR.OccExpTypeExt;

/// 项目名称
Property OEItemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据类型（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property OEDataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目值(字典、是/否、有/无)
Property OEResultDr As DHCHAI.BT.Dictionary;

/// 项目值（列表）
Property OEResultList As list Of DHCHAI.BT.Dictionary;

/// 项目值（文本、数值）
Property OEResultTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property OEActDate As %Date;

/// 更新时间
Property OEActTime As %Time;

/// 更新人
Property OEActUserDr As DHCHAI.BT.SysUser;

/// 索引 关联项目
Index IndexItem On (Parref, OEItemDr As Exact);

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  根据ID取职业暴露扩展
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input：       aId : DHCHAI.IR.OccExpRegExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OccExpRegExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OccExpRegExt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OccExpRegExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OccExpRegExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2018-06-14
/// Description:  根据关联项目获得职业暴露扩展表ID
/// Table：       DHCHAI.IR.OccExpReg,DHCHAI.IR.OccExpRegExt
/// Input：       aReportID : DHCHAI.IR.OccExpReg.ID
///               aLabTimDr : DHCHAI.IR.OccExpRegExt.ID
/// Return：      返回String
/// w ##class(DHCHAI.IR.OccExpRegExt).GetIDByItemDr("1","1||2")
ClassMethod GetIDByItemDr(aReportID As %String, aItemDr) As %String
{
	New (aReportID,aItemDr)
	Set return=""
	Quit:(aReportID="")||(aItemDr="") return
	
	Set return=$o(^DHCHAI.IR.OccExpRegI("EXT","IndexItem",aReportID,aItemDr,0))
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  更新职业暴露扩展
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpRegExt).Update("1^3^1||3^与上次间隔时间^T^^^1年^^^9")
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
		
	Set objParref=##class(DHCHAI.IR.OccExpReg).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objItem = ##class(DHCHAI.IR.OccExpTypeExt).GetObjById(ItemDr)
	Quit:'$IsObject(objItem) return
	Set objResult = ##class(DHCHAI.BT.Dictionary).GetObjById(ResultDr)
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.OccExpRegExt).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.OccExpRegExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.OEItemDr	 = objItem	  
	Set obj.OEItemDesc   = ItemDesc  
	Set obj.OEDataType   = DataType  
	Set obj.OEResultDr   = objResult 
    
    //List 数据对象
    While (obj.OEResultList.Count()>0) {
		Do obj.OEResultList.RemoveAt(1)
	}	
	Set idxLB=""
	For ind=1:1:$length(ResultList,"#") {
		Set idxID=$p(ResultList,"#",ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objDic)
		Do obj.OEResultList.Insert(objDic)
	}
	Set obj.OEResultTxt  = ResultTxt 
	Set obj.OEActDate	 = ActDate	  
	Set obj.OEActTime	 = ActTime	  
	Set obj.OEActUserDr  = objActUser
	
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

/// Creator：     pylian
/// CreatDate：   2018-05-10
/// Description:  删除职业暴露扩展
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input：       aId : DHCHAI.IR.OccExpRegExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OccExpRegExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OccExpRegExt).%DeleteId(aId)
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
<Data name="OccExpRegExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEItemDr</Value>
</Value>
<Value name="3">
<Value>OEItemDesc</Value>
</Value>
<Value name="4">
<Value>OEDataType</Value>
</Value>
<Value name="5">
<Value>OEResultDr</Value>
</Value>
<Value name="6">
<Value>OEResultList</Value>
</Value>
<Value name="7">
<Value>OEResultTxt</Value>
</Value>
<Value name="8">
<Value>OEActDate</Value>
</Value>
<Value name="9">
<Value>OEActTime</Value>
</Value>
<Value name="10">
<Value>OEActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>OccExpRegExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCHAI.IR.OccExpRegI("EXT")</IndexLocation>
<StreamLocation>^DHCHAI.IR.OccExpRegExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
