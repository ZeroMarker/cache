/// 名称: DHCHAI.DP.MRICDDxMap
/// 描述: 诊断对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MRICDDxMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 诊断名称
Property BTDiagDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准名称
Property BTMapItemDr As DHCHAI.DP.MRICDDx;

/// 标准备注
Property BTMapNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property BTSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准名称索引
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码 + 诊断名称 索引
Index IndexSCodeDiagDesc On (BTSCode As Exact, BTDiagDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取诊断对照
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       ID:    DHCHAI.DP.MRICDDxMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRICDDxMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MRICDDxMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MRICDDxMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MRICDDxMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  根据诊断名称取诊断对照
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       aSCode: DHCHAI.DP.MRICDDxMap.BTSCode
/// 			  aDiagDesc: DHCHAI.DP.MRICDDxMap.BTDiagDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRICDDxMap).GetObjByDiagDesc(1)
ClassMethod GetObjByDiagDesc(aSCode As %String, aDiagDesc As %String) As DHCHAI.DP.MRICDDxMap
{
	New (aSCode,aDiagDesc)
	Set return=""
	
	Set aDiagDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aDiagDesc)  //去掉特殊字符
	Quit:(aSCode="")||(aDiagDesc="") return
	
	Set id = $o(^DHCHAI.DP.MRICDDxMapI("IndexSCodeDiagDesc",aSCode,aDiagDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新诊断对照
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRICDDxMap).Update("^慢性粒细胞性白血病（慢性期）BCR/ABL基因阳性 t(9,22)(q34,q11)^^^HIS01^1^^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set DiagDesc	= $p(InStr,aSeparete,2)
	Set MapItemDr	= $p(InStr,aSeparete,3)
	Set MapNote		= $p(InStr,aSeparete,4)
	Set SCode		= $p(InStr,aSeparete,5)
	Set IsActive	= $p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate = +$h
	Set:ActTime="" ActTime = +$p($h,2)
	
	Set DiagDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(DiagDesc)  //去掉特殊字符
	Quit:(DiagDesc="")||(SCode="")||(IsActive="") return	
	
	// 子系统代码+诊断名称 唯一性
	Set tID =$o(^DHCHAI.DP.MRICDDxMapI("IndexSCodeDiagDesc",SCode,DiagDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	Set objMapItem = ##class(DHCHAI.DP.MRICDDx).GetObjById(MapItemDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.MRICDDxMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MRICDDxMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTDiagDesc	= DiagDesc
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTMapNote	= MapNote
	Set obj.BTSCode		= SCode
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUser	= ActUser

	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除诊断对照
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.MRICDDxMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-07-30
/// Description:  删除诊断名称对照关系
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.MRICDDxMap).%OpenId(Id)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr     = ""
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTDiagDesc</Value>
</Value>
<Value name="3">
<Value>BTMapItemDr</Value>
</Value>
<Value name="4">
<Value>BTMapNote</Value>
</Value>
<Value name="5">
<Value>BTSCode</Value>
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
<Value name="9">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MRICDDxMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MRICDDxMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.MRICDDxMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MRICDDxMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
