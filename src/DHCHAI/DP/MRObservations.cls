/// 名称: DHCHAI.DP.MRObservations
/// 描述: 护理记录
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.MRObservations Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property OBEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 项目代码
Property OBItemCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 项目名称
Property OBItemDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目值
Property OBItemValue As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 录入日期
Property OBEntryDate As %Date [ Required ];

/// 录入时间
Property OBEntryTime As %Time [ Required ];

/// 录入人（ID|Code|Desc）
Property OBEntryUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property OBSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property OBXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property OBIsActive As %Boolean [ Required ];

/// 更新日期
Property OBUpdateDate As %Date [ Required ];

/// 更新时间
Property OBUpdateTime As %Time [ Required ];

/// 子系统代码 + 记录索引码 索引
Index IndexSCodeXCode On (OBSCode As Exact, OBXCode As Exact);

/// 子系统代码 + 项目名称 索引
Index IndexItemDescDate On (OBSCode As Exact, OBItemDesc As Exact, OBEntryDate);

/// 就诊 + 子系统代码 + 项目名称索引
Index IndexEpisodeItemDescDate On (OBEpisodeDr, OBSCode As Exact, OBItemDesc As Exact, OBEntryDate);

/// 就诊记录索引
Index IndexEpisodeDr On OBEpisodeDr;

/// 接收日期时间索引
Index IndexEntryDateTime On (OBEntryDate, OBEntryTime);

/// 更新日期 索引
Index IndexEpisUpdateDate On (OBEpisodeDr, OBUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废护理记录
/// Table：       DHCHAI.DP.MRObservations
/// Input：       id:    DHCHAI.DP.MRObservations.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRObservations).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.MRObservations).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.OBIsActive   = 0
	Set obj.OBUpdateDate = +$h
	Set obj.OBUpdateTime = $p($h,",",2)
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
/// Description:  根据ID取护理记录
/// Table：       DHCHAI.DP.MRObservations
/// Input：       ID:    DHCHAI.DP.MRObservations.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRObservations).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.MRObservations
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.MRObservations).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.MRObservations).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据子系统代码，记录索引码取护理记录
/// Table：       DHCHAI.DP.MRObservations
/// Input：       aSCode: 子系统代码
///               aXCode: 记录索引码
/// Return：      返回Object
/// w ##class(DHCHAI.DP.MRObservations).GetObjByXCode(1)
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.MRObservations
{
	New (aSCode,aXCode)
	Set return = ""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id=$o(^DHCHAI.DP.MRObservationsI("IndexSCodeXCode",aSCode,aXCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新护理记录
/// Table：       DHCHAI.DP.MRObservations
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.MRObservations).Update("^1^代码^项目^项目值^2017-12-11^12:00:00^录入人^子系统代码^记录索引码^1^2017-01-01^18:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set ItemCode	= $p(InStr,aSeparete,3)
	Set ItemDesc	= $p(InStr,aSeparete,4)
	Set ItemValue	= $p(InStr,aSeparete,5)
	Set EntryDate	= $p(InStr,aSeparete,6)
	Set EntryTime	= $p(InStr,aSeparete,7)
	Set EntryUser	= $p(InStr,aSeparete,8)
	Set SCode		= $p(InStr,aSeparete,9)
	Set XCode		= $p(InStr,aSeparete,10)
	Set IsActive	= $p(InStr,aSeparete,11)
	Set UpdateDate	= $p(InStr,aSeparete,12)
	Set UpdateTime	= $p(InStr,aSeparete,13)
	Set:EntryDate["-" EntryDate = $zdh(EntryDate,3)
	Set:EntryTime[":" EntryTime = $zth(EntryTime,1)
	Quit:(EpisodeDr="")||(ItemDesc="")||(ItemValue="")||(EntryDate="")||(EntryTime="") return
	Quit:(SCode="")||(XCode="")||(IsActive="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.MRObservationsI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.MRObservations).%New()
	}else{
		Set obj=##class(DHCHAI.DP.MRObservations).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.OBEpisodeDr		= objAdm
	Set obj.OBItemCode		= ItemCode
	Set obj.OBItemDesc		= ItemDesc	
	Set obj.OBItemValue		= ItemValue
	Set obj.OBEntryDate		= EntryDate
	Set obj.OBEntryTime		= EntryTime
	Set obj.OBEntryUser		= EntryUser
	Set obj.OBSCode			= SCode
	Set obj.OBXCode			= XCode
	Set obj.OBIsActive		= IsActive
	Set obj.OBUpdateDate	= +$h
	Set obj.OBUpdateTime	= $p($h,",",2)

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
/// Description:  删除护理记录
/// Table：       DHCHAI.DP.MRObservations
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.MRObservations).%DeleteId(+Id)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OBEpisodeDr</Value>
</Value>
<Value name="3">
<Value>OBItemCode</Value>
</Value>
<Value name="4">
<Value>OBItemDesc</Value>
</Value>
<Value name="5">
<Value>OBItemValue</Value>
</Value>
<Value name="6">
<Value>OBEntryDate</Value>
</Value>
<Value name="7">
<Value>OBEntryTime</Value>
</Value>
<Value name="8">
<Value>OBEntryUser</Value>
</Value>
<Value name="9">
<Value>OBSCode</Value>
</Value>
<Value name="10">
<Value>OBXCode</Value>
</Value>
<Value name="11">
<Value>OBIsActive</Value>
</Value>
<Value name="12">
<Value>OBUpdateDate</Value>
</Value>
<Value name="13">
<Value>OBUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.MRObservationsD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.MRObservationsD</IdLocation>
<IndexLocation>^DHCHAI.DP.MRObservationsI</IndexLocation>
<StreamLocation>^DHCHAI.DP.MRObservationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
