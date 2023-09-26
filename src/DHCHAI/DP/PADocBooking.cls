/// 名称: DHCHAI.DP.PADocBooking
/// 描述: 住院证登记表
/// 编写者：pylian
/// 编写日期: 2022-07-12
Class DHCHAI.DP.PADocBooking Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 住院就诊记录
Property PAEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 门诊就诊记录
Property PAEpisodeDrF As DHCHAI.DP.PAAdm [ Required ];

/// HIS住院证ID
Property PABookID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// HIS住院就诊序号
Property PAEpisodeIDxT As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// HIS门诊就诊序号
Property PAEpisodeIDxF As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 建住院证日期
Property PACreateDate As %Date;

/// 建住院证时间
Property PACreateTime As %Time;

/// 有效状态
Property PAIsActive As %String;

/// 更新日期
Property PAUpdateDate As %Date [ Required ];

/// 更新时间
Property PAUpdateTime As %Time [ Required ];

/// 就诊序号索引
Index IndexEpisodeDr On PAEpisodeDr As Exact;

/// HIS就诊序号索引
Index IndexEpisodeIDx On PAEpisodeIDxT As Exact;

/// Creator：     pylian
/// CreatDate：   2022-07-12
/// Description:  根据ID取住院证登记表
/// Table：       DHCHAI.DP.PADocBooking
/// Input：       ID:    DHCHAI.DP.PADocBooking.ID
///               aSeparete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PADocBooking).GetObjById(5865)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.PADocBooking
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PADocBooking).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PADocBooking).%OpenId(+id)
	Quit:'$IsObject(obj) return
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-07-12
/// Description:  更新就诊表
/// Table：       DHCHAI.DP.PADocBooking
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
///  w ##class(DHCHAI.DP.PADocBooking).Update("^1^1^0009^0928^李毅^M^中国^^^^^^^0^2017-01-01^18:00:00^I^A^2017-01-01^18:00:00^^^^^^^^^^^^^^2017-01-01^18:00:00")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set EpisodeDrF	= $p(InStr,aSeparete,3)
	Set BookID		= $p(InStr,aSeparete,4)
	Set EpisodeIDxT = $p(InStr,aSeparete,5)
	Set EpisodeIDxF = $p(InStr,aSeparete,6)
	Set CreateDate	= $p(InStr,aSeparete,7)
	Set CreateTime	= $p(InStr,aSeparete,8)
	Set IsActive	= $p(InStr,aSeparete,9)
	Set UpdateDate	= $p(InStr,aSeparete,10)
	Set UpdateTime	= $p(InStr,aSeparete,11)
	
	Set:UpdateDate["-" UpdateDate = $zdh(UpdateDate,3)
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
 
	Quit:(EpisodeDr="")||(EpisodeDr="")||(BookID="")||(EpisodeIDxT="")||(EpisodeIDxF="") return

	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	Set objAdmF = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDrF)
	Quit:objAdmF="" return
	///就诊序号唯一性
	Set tID = $o(^MA.HAI.DP.PADocBookingI("IndexEpisodeDr",EpisodeDr,0))
	Quit:(tID'="")&(ID'=tID) -100
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.PADocBooking).%New()
	}else{
		Set obj=##class(DHCHAI.DP.PADocBooking).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PAEpisodeDr 	= objAdm
	Set obj.PAEpisodeDrF	= objAdmF
	Set obj.PABookID		= BookID
	Set obj.PAEpisodeIDxT   = EpisodeIDxT
	Set obj.PAEpisodeIDxF 	= EpisodeIDxF
	Set obj.PACreateDate	= CreateDate
	Set obj.PACreateTime	= CreateTime
	Set obj.PAIsActive		= IsActive
	Set obj.PAUpdateDate	= UpdateDate
	Set obj.PAUpdateTime	= UpdateTime
	
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

/// Creator：     pylian
/// CreatDate：   2022-07-12
/// Description:  住院证登记表
/// Table：       DHCHAI.DP.PADocBooking
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.PADocBooking).%DeleteId(+Id)
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
<Value>PAEpisodeDr</Value>
</Value>
<Value name="3">
<Value>PAEpisodeDrF</Value>
</Value>
<Value name="4">
<Value>PABookID</Value>
</Value>
<Value name="5">
<Value>PAEpisodeIDxT</Value>
</Value>
<Value name="6">
<Value>PAEpisodeIDxF</Value>
</Value>
<Value name="7">
<Value>PACreateDate</Value>
</Value>
<Value name="8">
<Value>PACreateTime</Value>
</Value>
<Value name="9">
<Value>PAIsActive</Value>
</Value>
<Value name="10">
<Value>PAUpdateDate</Value>
</Value>
<Value name="11">
<Value>PAUpdateTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.PADocBookingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.PADocBookingD</IdLocation>
<IndexLocation>^MA.HAI.DP.PADocBookingI</IndexLocation>
<StreamLocation>^MA.HAI.DP.PADocBookingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
