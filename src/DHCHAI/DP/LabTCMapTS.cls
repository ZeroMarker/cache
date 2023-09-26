/// 名称: DHCHAI.DP.LabTCMapTS
/// 描述: 检验项目匹配医嘱
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabTCMapTS Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验项目
Property BTTCMapDr As DHCHAI.DP.LabTCMap;

/// 检验医嘱
Property BTTSMapDr As DHCHAI.DP.LabTestSetMap;

/// 检验医嘱索引
Index IndexTCMapTSMap On (BTTCMapDr, BTTSMapDr) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取检验项目匹配医嘱
/// Table：       DHCHAI.DP.LabTCMapTS
/// Input：       ID:    DHCHAI.DP.LabTCMapTS.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMapTS).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTCMapTS
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTCMapTS).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTCMapTS).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据检验项目对照ID取检验项目匹配医嘱
/// Table：       DHCHAI.DP.LabTCMapTS
/// Input：       aTCMapID:    DHCHAI.DP.LabTCMapTS.BTTCMapDr
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMapTS).GetObjByTSMapDr()
ClassMethod GetObjByTSMapDr(aTCMapID As %String, aTSMapID As %String) As DHCHAI.DP.LabTCMapTS
{
	New (aTCMapID,aTSMapID)
	Set return=""
	Quit:(aTCMapID="")||(aTSMapID="") return
	
	Set id = $o(^DHCHAI.DP.LabTCMapTSI("IndexTCMapTSMap",aTCMapID,aTSMapID,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检验项目匹配医嘱
/// Table：       DHCHAI.DP.LabTCMapTS
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTCMapTS).Update("^1^定性结果^标准结果（阴性、阳性等）^标准备注^1^2017-09-01^13:00:00^处置人")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set TCMapDr	    = $p(InStr,aSeparete,2)
	Set TSMapDr		= $p(InStr,aSeparete,3)
	Quit:(TCMapDr="")||(TSMapDr="") return
	
	//代码名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabTCMapTSI("IndexTCMapTSMap",TCMapDr,TSMapDr,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100 
	
	Set objTCMap = ##class(DHCHAI.DP.LabTCMap).GetObjById(TCMapDr)
	Quit:'$IsObject(objTCMap) return
	Set objTSMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(TSMapDr)
	Quit:'$IsObject(objTSMap) return
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabTCMapTS).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabTCMapTS).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTCMapDr	= objTCMap
	Set obj.BTTSMapDr	= objTSMap
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
/// Description:  删除检验项目匹配医嘱
/// Table：       DHCHAI.DP.LabTCMapTS
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabTCMapTS).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="LabTCMapTSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTCMapDr</Value>
</Value>
<Value name="3">
<Value>BTTSMapDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabTCMapTSD</DataLocation>
<DefaultData>LabTCMapTSDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTCMapTSD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTCMapTSI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTCMapTSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
