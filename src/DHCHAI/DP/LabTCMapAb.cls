/// 名称: DHCHAI.DP.LabTCMapAb
/// 描述: 检验项目定值结果（结果类型为以下类型才保存结果字典：列表S、血型A、阴性血型R）
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabTCMapAb Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验项目对照
Property BTTCMapDr As DHCHAI.DP.LabTCMap;

/// 异常标志
Property BTAbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常标志（H、L等）
Property BTMapText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准备注
Property BTMapNote As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验项目索引
Index IndexTCMapAbFlag On (BTTCMapDr, BTAbFlag) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       ID:    DHCHAI.DP.LabTCMapAb.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMapAb).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabTCMapAb
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabTCMapAb).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabTCMapAb).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据检验项目对照ID取检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       aTCMapID:    DHCHAI.DP.LabTCMapAb.BTTCMapDr
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabTCMapAb).GetObjByTCMapID(1)
ClassMethod GetObjByTCMapID(aTCMapID As %String, aAbFlag As %String) As DHCHAI.DP.LabTCMapAb
{
	New (aTCMapID,aAbFlag)
	Set return=""
	Quit:(aTCMapID="")||(aAbFlag="") return
	
	Set id = $o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",aTCMapID," "_$zcvt(aAbFlag,"U"),0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabTCMapAb).Update("^1^异常标志^异常标志（H、L等）^标准备注^1^2017-09-01^13:00:00^处置人")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set TCMapDr	    = $p(InStr,aSeparete,2)
	Set AbFlag		= $p(InStr,aSeparete,3)
	Set MapText	    = $p(InStr,aSeparete,4)
	Set MapNote		= $p(InStr,aSeparete,5)
	Set IsActive	= +$p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(TCMapDr="")||(AbFlag="")||(IsActive="") return
	
	//代码名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",TCMapDr," "_$zcvt(AbFlag,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objTCMap = ##class(DHCHAI.DP.LabTCMap).GetObjById(TCMapDr)
	Quit:'$IsObject(objTCMap) return
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.LabTCMapAb).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabTCMapAb).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTTCMapDr	= objTCMap
	Set obj.BTAbFlag	= AbFlag
	Set obj.BTMapText	= MapText
	Set obj.BTMapNote	= MapNote
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
/// Description:  删除检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabTCMapAb).%DeleteId(+Id)
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
<Data name="LabTestAbFlagMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTTCMapDr</Value>
</Value>
<Value name="3">
<Value>BTAbFlag</Value>
</Value>
<Value name="4">
<Value>BTMapText</Value>
</Value>
<Value name="5">
<Value>BTMapNote</Value>
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
<DataLocation>^DHCHAI.DP.LabTCMapAbD</DataLocation>
<DefaultData>LabTestAbFlagMapDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabTCMapAbD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabTCMapAbI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabTCMapAbS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
