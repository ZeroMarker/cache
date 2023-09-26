/// 名称: DHCMed.EPD.ESurRegExt
/// 描述: 流调表扩展表
/// 编写者：chenrui
/// 编写日期: 2021-07-17
Class DHCMed.EPD.ESurRegExt Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.EPD.ESurRepReg [ Cardinality = parent, Inverse = ChildExt ];

/// 关联项目
Property SEItemDr As DHCMed.EPD.ESurTypeExt;

/// 项目名称
Property SEItemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据类型（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property SEDataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目值(字典、是/否、有/无)
Property SEResultDr As DHCMed.SS.Dictionary;

/// 项目值（列表）
Property SEResultList As list Of DHCMed.SS.Dictionary;

/// 项目值（文本、数值）
Property SEResultTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property SEActDate As %Date;

/// 更新时间
Property SEActTime As %Time;

/// 索引 关联项目
Index IndexItem On (Parref, SEItemDr As Exact);

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  根据ID取流调扩展
/// Table：       DHCMed.EPD.ESurRegExt
/// Input：       aId : DHCMed.EPD.ESurRegExt.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.ESurRegExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.ESurRegExt
{
	New (aId)
	Quit:'##class(DHCMed.EPD.ESurRegExt).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.ESurRegExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  根据关联项目获得流调扩展表ID
/// Table：       DHCMed.EPD.ESurRegExt
/// Input：       aReportID : DHCMed.EPD.ESurRepReg.ID
///               aLabTimDr : DHCMed.EPD.ESurRegExt.ID
/// Return：      返回String
/// w ##class(DHCMed.EPD.ESurRegExt).GetIDByItemDr("1","1||2")
ClassMethod GetIDByItemDr(aReportID As %String, aItemDr) As %String
{
	New (aReportID,aItemDr)
	Set return=""
	Quit:(aReportID="")||(aItemDr="") return
	
	Set return=$o(^DHCMed.EPD.ESurRepRegI("EXT","IndexItem",aReportID,aItemDr,0))
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-07-16
/// Description:  更新流调扩展
/// Table：       DHCMed_EPD.ESurRegExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRegExt).Update("2^8^3||17^2、七天内患者有无^DB^^2672,2676^^^","^")
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
	
	Quit:(Parref="")||(ItemDr="")||(ItemDesc="") return

	
	Set:ActDate'="" ActDate =##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
		
	Set objParref=##class(DHCMed.EPD.ESurRepReg).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set objItem = ##class(DHCMed.EPD.ESurTypeExt).GetObjById(ItemDr)
	Quit:'$IsObject(objItem) return
	Set objResult = ##class(DHCMed.SS.Dictionary).GetObjById(ResultDr)
	
	
	
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.EPD.ESurRegExt).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.ESurRegExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.SEItemDr	 = objItem	  
	Set obj.SEItemDesc   = ItemDesc  
	Set obj.SEDataType   = DataType  
	Set obj.SEResultDr   = objResult 
    
    //List 数据对象
    While (obj.SEResultList.Count()>0) {
		Do obj.SEResultList.RemoveAt(1)
	}	
	Set idxLB=""
	For ind=1:1:$length(ResultList,",") {
		Set idxID=$p(ResultList,",",ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objDic)
		Do obj.SEResultList.Insert(objDic)
	}
	Set obj.SEResultTxt  = ResultTxt 
	Set obj.SEActDate	 = ActDate	  
	Set obj.SEActTime	 = ActTime	 
	
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

/// Creator：     chenrui
/// CreatDate：   2021-07-17
/// Description:  删除流调扩展
/// Table：       DHCMed.EPD.ESurRegExt
/// Input：       aId : DHCMed.EPD.ESurRegExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ESurRegExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.ESurRegExt).%DeleteId(aId)
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
<Data name="ESurRegExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SEItemDr</Value>
</Value>
<Value name="3">
<Value>SEItemDesc</Value>
</Value>
<Value name="4">
<Value>SEDataType</Value>
</Value>
<Value name="5">
<Value>SEResultDr</Value>
</Value>
<Value name="6">
<Value>SEResultList</Value>
</Value>
<Value name="7">
<Value>SEResultTxt</Value>
</Value>
<Value name="8">
<Value>SEActDate</Value>
</Value>
<Value name="9">
<Value>SEActTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>ESurRegExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCMed.EPD.ESurRepRegI("EXT")</IndexLocation>
<StreamLocation>^DHCMed.EPD.ESurRegExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
