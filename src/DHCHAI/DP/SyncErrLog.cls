/// 名称: DHCHAI.DP.SyncErrLog
/// 描述: 数据抓取异常日志
/// 编写者：liyi
/// 编写日期: 2017-04-12
Class DHCHAI.DP.SyncErrLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊序号
Property ELEpisodeIDx As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抓取类
Property ELSyncClass As %String(MAXLEN = 200, TRUNCATE = 1);

/// 抓取方法
Property ELSyncMethod As %String(MAXLEN = 200, TRUNCATE = 1);

/// 抓取参数
Property ELArgs As %List;

/// 抓取日期
Property ELSyncDate As %Date;

/// 抓取时间
Property ELSyncTime As %Time;

/// 日期时间索引
Index IndexOnDateTime On (ELSyncDate, ELSyncTime);

/// 类方法索引
Index IndexEpisodeClassMethod On (ELEpisodeIDx, ELSyncClass, ELSyncMethod);

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取数据抓取异常日志
/// Table：       DHCHAI.DP.SyncErrLog
/// Input：       ID:    DHCHAI.DP.SyncErrLog.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.SyncErrLog).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.SyncErrLog
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.SyncErrLog).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.SyncErrLog).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新数据抓取异常日志
/// Table：       DHCHAI.DP.SyncErrLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.SyncErrLog).Update("")
ClassMethod Update(InStr As %String, aArgs As %List, aSeparete As %String = "^") As %String
{
	New (InStr,aArgs,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set EpisodeIDx	= $p(InStr,aSeparete,2)
	Set:EpisodeIDx="" EpisodeIDx=0
	Set SyncClass	= $p(InStr,aSeparete,3)
	Set SyncMethod	= $p(InStr,aSeparete,4)
	Set SyncDate   	= $p(InStr,aSeparete,5)
	Set SyncTime   	= $p(InStr,aSeparete,6)
	Quit:(SyncClass="")||(SyncMethod="") return
	
	If ID="" {
		Set obj=##class(DHCHAI.DP.SyncErrLog).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.SyncErrLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ELEpisodeIDx	= EpisodeIDx
	Set obj.ELSyncClass		= SyncClass
	Set obj.ELSyncMethod	= SyncMethod
	Set obj.ELArgs			= aArgs
	Set obj.ELSyncDate		= SyncDate
	Set obj.ELSyncTime		= SyncTime
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
/// Description:  删除数据抓取异常日志
/// Table：       DHCHAI.DP.SyncErrLog
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.SyncErrLog).%DeleteId(+Id)
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
<Data name="SyncErrLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ELEpisodeIDx</Value>
</Value>
<Value name="3">
<Value>ELSyncMethod</Value>
</Value>
<Value name="4">
<Value>ELSyncDate</Value>
</Value>
<Value name="5">
<Value>ELSyncTime</Value>
</Value>
<Value name="6">
<Value>ELSyncClass</Value>
</Value>
<Value name="7">
<Value>ElArgs</Value>
</Value>
<Value name="8">
<Value>ELArgs</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.SyncErrLogD</DataLocation>
<DefaultData>SyncErrLogDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.SyncErrLogD</IdLocation>
<IndexLocation>^DHCHAI.DP.SyncErrLogI</IndexLocation>
<StreamLocation>^DHCHAI.DP.SyncErrLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
