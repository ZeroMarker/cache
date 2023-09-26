/// 名称: DHCHAI.DP.LabAntiMap
/// 描述: 抗生素字典对照
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.LabAntiMap Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 抗生素名称
Property BTAntiDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 标准抗生素名称
Property BTMapItemDr As DHCHAI.DP.LabAntibiotic;

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

/// 子系统代码+抗生素名称 索引
Index IndexSCodeAntiDesc On (BTSCode As Exact, BTAntiDesc As Exact);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       ID:    DHCHAI.DP.LabAntiMap.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.LabAntiMap).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.LabAntiMap
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabAntiMap).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabAntiMap).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据 子系统代码、抗生素名称 取抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       aSCode ： 子系统代码
/// 			  aAntDesc：抗生素名称
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc("LIS02","5-氟胞嘧啶1ug")
ClassMethod GetObjByAntDesc(aSCode As %String, aAntDesc As %String) As DHCHAI.DP.LabAntiMap
{
	New (aSCode,aAntDesc)
	Set return = ""
	Quit:(aSCode="")||(aAntDesc="") return
	
	Set aAntDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(aAntDesc)  //去掉特殊字符
	Set id=$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",aSCode,aAntDesc,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-22
/// Description:  根据子系统代码+抗生素名称取抗生素标准字典
/// Table：       DHCHAI.DP.LabAntiMap、DHCHAI.DP.LabAntibiotic
/// Input：       aSCode ： 子系统代码
/// 			  aBacteria：抗生素名称
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabAntiMap).GetStanAntiByDesc("LIS01","高单位的庆大霉素")
ClassMethod GetStanAntiByDesc(aSCode As %String, aAnti As %String) As DHCHAI.DP.LabAntibiotic
{
	New (aSCode,aAnti)
	Set return = ""
	Quit:(aSCode="")||(aAnti="") return
	
	Set obj=..GetObjByAntDesc(aSCode,aAnti)
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.BTMapItemDr) return
	Set return=obj.BTMapItemDr
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabAntiMap).Update("1^5-氟胞嘧啶1ug^^^标准备注^LIS01^1^2017-06-01^13:00:00^处置人")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set AntiDesc	= $p(InStr,aSeparete,2)
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
	Quit:(AntiDesc="")||(SCode="")||(IsActive="")||(ActDate="")||(ActTime="") return
	
	Set AntiDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(AntiDesc)  //去掉特殊字符
	
	//子系统代码+抗生素名称 唯一性
	Set tID =$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",SCode,AntiDesc,"")) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objMapItem = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(MapItemDr)
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.LabAntiMap).%New()
	}else{
		Set obj=##class(DHCHAI.DP.LabAntiMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTAntiDesc	= AntiDesc
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
/// Description:  删除抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.LabAntiMap).%DeleteId(+Id)
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
/// Description:  删除抗生素对照关系
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteMapById(Id)
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.DP.LabAntiMap).%OpenId(Id)
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
/// Description:  导入抗生素对照修改信息
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabAntiMap).ImportLabAntiMap("两性霉素B^LIS01")
ClassMethod ImportLabAntiMap(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set AntiDesc	= $p(aInputStr,aSeparete,1)
	Set SCode		= $p(aInputStr,aSeparete,2)
	Quit:(AntiDesc="")||(SCode="") return
	
	//子系统代码+抗生素名称 唯一性
	Set (MapItemDr,MapNote,ActDate,ActTime,ActUser)=""
	Set IsActive=1
	Set ID=$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",SCode,AntiDesc,0))
	If (ID'=""){
		Set obj = ##class(DHCHAI.DP.LabAntiMap).GetObjById(ID)
		Quit:'$IsObject(obj) return
		
		Set:$IsObject(obj.BTMapItemDr) MapItemDr=obj.BTMapItemDr.%Id()
		Set MapNote=obj.BTMapNote
		Set IsActive=obj.BTIsActive
		Set ActDate=obj.BTActDate
		Set ActTime=obj.BTActTime
		Set ActUser=obj.BTActUser
	}
	Set InputStr=ID
	Set InputStr=InputStr_"^"_AntiDesc
	Set InputStr=InputStr_"^"_MapItemDr
	Set InputStr=InputStr_"^"_MapNote
	Set InputStr=InputStr_"^"_SCode
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_ActDate
	Set InputStr=InputStr_"^"_ActTime
	Set InputStr=InputStr_"^"_ActUser
	Set return=..Update(InputStr)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTAntiDesc</Value>
</Value>
<Value name="3">
<Value>BTMapItemDr</Value>
</Value>
<Value name="4">
<Value>BTMapCatDr</Value>
</Value>
<Value name="5">
<Value>BTMapNote</Value>
</Value>
<Value name="6">
<Value>BTSCode</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.LabAntiMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabAntiMapD</IdLocation>
<IndexLocation>^DHCHAI.DP.LabAntiMapI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabAntiMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
