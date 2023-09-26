/// 名称: DHCHAI.DP.LabSpecMap
/// 描述: 标本对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabSpecMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 标本名称
Property BTSpecDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准标本名称
Property BTMapItemDr As DHCHAI.DP.LabSpecimen;

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

/// 标准标本名称索引
Index IndexMapItemDr On BTMapItemDr;

/// 子系统代码+标本名称 索引
Index IndexSCodeSpecDesc On (BTSCode As Exact, BTSpecDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       ID:    DHCHAI.DP.LabSpecMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabSpecMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabSpecMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabSpecMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabSpecMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据子系统代码+标本名称取标本字典对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       aSCode ： 子系统代码
/// 			  aBacteria：细菌名称
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen("LIS02","痰")
ClassMethod GetObjBySpecimen(aSCode As %String, aSpecimen As %String) As DHCHAI.DP.LabSpecMap
{
	New (aSCode,aSpecimen)
	Set return = ""
	Quit:(aSCode="")||(aSpecimen="") return
	
	Set aSpecimen=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aSpecimen)  //去掉特殊字符
	Set id=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",aSCode,aSpecimen,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-04
/// Description:  根据子系统代码+标本名称取标本标准字典
/// Table：       DHCHAI.DP.LabSpecMap、DHCHAI.DP.LabSpecimen
/// Input：       aSCode:       DHCHAI.BT.SystemMap.BTCode
///               aSpecDesc:    DHCHAI.DP.LabSpecMap.BTSpecDesc
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc("Lab01","痰")
ClassMethod GetStanSpecByDesc(aSCode As %String, aSpecimen As %String) As DHCHAI.DP.LabSpecimen
{
	New (aSCode,aSpecimen)
	Set return=""
	Quit:(aSCode="")||(aSpecimen="") return
	Set obj=..GetObjBySpecimen(aSCode,aSpecimen)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTMapItemDr) return
	Set return=obj.BTMapItemDr
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabSpecMap).Update("^血液^1^血液全血^LIS01^1^2017-02-08^18:00:00^系统自动")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set SpecDesc	= $p(InStr,aSeparete,2)
	Set MapItemDr	= $p(InStr,aSeparete,3)
	Set MapNote		= $p(InStr,aSeparete,4)
	Set SCode		= $p(InStr,aSeparete,5)
	Set IsActive	= +$p(InStr,aSeparete,6)
	Set ActDate		= $p(InStr,aSeparete,7)
	Set ActTime		= $p(InStr,aSeparete,8)
	Set ActUser		= $p(InStr,aSeparete,9)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(SpecDesc="")||(SCode="")||(IsActive="") return
	
	Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)  //去掉特殊字符
	
	//子系统代码+标本名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,SpecDesc,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem = ##class(DHCHAI.DP.LabSpecimen).GetObjById(MapItemDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabSpecMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabSpecMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTSpecDesc	= SpecDesc
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
/// Description:  删除标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabSpecMap).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2017-08-04
/// Description:  删除标本对照关系
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.LabSpecMap).%OpenId(Id)
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

/// Creator：     mayanpeng
/// CreatDate：   2017-09-28
/// Description:  导入标本对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabSpecMap).ImportLabSpecMap("PICC引流液^LIS01")
ClassMethod ImportLabSpecMap(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set SpecDesc	= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Quit:(SpecDesc="")||(SCode="") return
	
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set IsActive=1
	Set ID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",SCode,SpecDesc,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.LabSpecMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_SpecDesc
	Set InputStr=InputStr_"^"_MapItemDr
	Set InputStr=InputStr_"^"_MapNote
	Set InputStr=InputStr_"^"_SCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUser
	Set return = ..Update(InputStr,"^")
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTSpecDesc</Value>
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
<DataLocation>^DHCHAI.DP.LabSpecMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabSpecMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabSpecMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabSpecMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
