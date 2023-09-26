/// 名称: DHCHAI.IR.ComTempRep
/// 描述: 公共模板报告信息
/// 编写者: zhoubo
/// 编写日期: 2022-10-14
Class DHCHAI.IR.ComTempRep Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联报告ID
Property ComRelateDr As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 关联模板类型ID
Property ComDefDr As DHCHAI.IR.ComTemplateDef [ Required ];

/// 关联项目
Property ComItemDr As DHCHAI.IR.ComTempDefExt [ Required ];

/// 项目名称
Property ComItemDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据类型（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property ComDataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目值(字典、是/否、有/无)
Property ComResultDr As DHCHAI.BT.Dictionary;

/// 项目值（列表）
Property ComResultList As list Of DHCHAI.BT.Dictionary;

/// 项目值（文本、数值）
Property ComResultTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property ActDate As %Date;

/// 更新时间
Property ActTime As %Time;

/// 更新人
Property ActUserDr As DHCHAI.BT.SysUser;

/// 关联模板ID索引
Index IndexComRelateDr On ComRelateDr As Exact;

/// 关联报告项目索引
Index IndexComDefItem On (ComDefDr, ComRelateDr, ComItemDr) [ Unique ];

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  根据ID取公共模板报告信息
/// Table：       DHCHAI.IR.ComTempRep
/// Input：       aId : DHCHAI.IR.ComTempRep.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ComTempRep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ComTempRep
{
	New (aId)
	Quit:'##class(DHCHAI.IR.ComTempRep).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.ComTempRep).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-23
/// Description:  根据关联项目获得扩展表ID
/// Table：       DHCHAI.IR.ComTempRep
/// Input：       aReportID : DHCHAI.IR.OccExpReg.ID
///               aLabTimDr : DHCHAI.IR.OccExpRegExt.ID
/// Return：      返回String
/// w ##class(DHCHAI.IR.ComTempRep).GetIDByItemDr("1","1","1||2")
ClassMethod GetIDByItemDr(aRegTypeID As %String, aReportID As %String, aItemDr) As %String
{
	New (aRegTypeID,aReportID,aItemDr)
	Set return=""
	Quit:(aReportID="")||(aRegTypeID="")||(aItemDr="") return
	
	Set return=$o(^MA.HAI.IR.ComTempRepI("IndexComDefItem",aRegTypeID,aReportID,aItemDr,0))
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  更新公共模板报告信息
/// Table：       DHCHAI.IR.ComTempRep
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTempRep).Update("1^3^1||3^与上次间隔时间^T^^^1年^^^9")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set ID            = $p(aInputStr,aSeparete,1)
    Set ComDefDr      = $p(aInputStr,aSeparete,2)
	Set ComRelateDr   = $p(aInputStr,aSeparete,3)
	Set ComItemDr	  = $p(aInputStr,aSeparete,4)
	Set ComItemDesc   = $p(aInputStr,aSeparete,5)
	Set ComDataType   = $p(aInputStr,aSeparete,6)
	Set ComResultDr   = $p(aInputStr,aSeparete,7)
	Set ComResultList = $p(aInputStr,aSeparete,8)
	Set ComResultTxt  = $p(aInputStr,aSeparete,9)
	Set ActDate	      = $p(aInputStr,aSeparete,10)
	Set ActTime	      = $p(aInputStr,aSeparete,11)
	Set ActUserDr     = $p(aInputStr,aSeparete,12)
	Quit:(ComRelateDr="")||(ComItemDr="")||(ComDefDr="") return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set objType = ##class(DHCHAI.IR.ComTemplateDef).GetObjById(ComDefDr)
	Quit:'$IsObject(objType) return
	Set objItem = ##class(DHCHAI.IR.ComTempDefExt).GetObjById(ComItemDr)
	Quit:'$IsObject(objItem) return
	Set objResult = ##class(DHCHAI.BT.Dictionary).GetObjById(ComResultDr)
	
	Set ID =$o(^MA.HAI.IR.ComTempRepI("IndexComDefItem",ComDefDr," "_ComRelateDr,ComItemDr,0)) 
	If (ID="") {
		Set obj=##class(DHCHAI.IR.ComTempRep).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.ComTempRep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.ComDefDr      = objType
	Set obj.ComRelateDr   = ComRelateDr
	Set obj.ComItemDr	  = objItem	  
	Set obj.ComItemDesc   = ComItemDesc  
	Set obj.ComDataType   = ComDataType  
	Set obj.ComResultDr   = objResult 
    
    //List 数据对象
    While (obj.ComResultList.Count()>0) {
		Do obj.ComResultList.RemoveAt(1)
	}	
	Set idxLB=""
	For ind=1:1:$length(ComResultList,"#") {
		Set idxID=$p(ComResultList,"#",ind)
		Continue:idxID=""
		Continue:($listfind(idxLB,idxID)>0)
		Set idxLB=idxLB_$lb(idxID)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(idxID) 
		Continue:'$IsObject(objDic)
		Do obj.ComResultList.Insert(objDic)
	}
	Set obj.ComResultTxt = ComResultTxt 
	Set obj.ActDate	     = ActDate	  
	Set obj.ActTime	     = ActTime	  
	Set obj.ActUserDr    = objActUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  删除公共模板报告信息
/// Table：       DHCHAI.IR.ComTempRep
/// Input：       aId : DHCHAI.IR.ComTempRep.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTempRep).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ComTempRep).%DeleteId(aId)
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
<Data name="ComTempRepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComRelateDr</Value>
</Value>
<Value name="3">
<Value>ComDefDr</Value>
</Value>
<Value name="4">
<Value>ComItemDr</Value>
</Value>
<Value name="5">
<Value>ComItemDesc</Value>
</Value>
<Value name="6">
<Value>ComDataType</Value>
</Value>
<Value name="7">
<Value>ComResultDr</Value>
</Value>
<Value name="8">
<Value>ComResultList</Value>
</Value>
<Value name="9">
<Value>ComResultTxt</Value>
</Value>
<Value name="10">
<Value>ActDate</Value>
</Value>
<Value name="11">
<Value>ActTime</Value>
</Value>
<Value name="12">
<Value>ActUserDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.IR.ComTempRepD</DataLocation>
<DefaultData>ComTempRepDefaultData</DefaultData>
<IdLocation>^MA.HAI.IR.ComTempRepD</IdLocation>
<IndexLocation>^MA.HAI.IR.ComTempRepI</IndexLocation>
<StreamLocation>^MA.HAI.IR.ComTempRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
