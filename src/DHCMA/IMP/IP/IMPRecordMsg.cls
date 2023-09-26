/// 名称: DHCMA.IMP.IP.IMPRecordMsg
/// 描述: 消息记录
/// 编写者：zhangdc
/// 编写日期: 2020-08-27
Class DHCMA.IMP.IP.IMPRecordMsg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.IP.IMPRecord [ Cardinality = parent, Inverse = ChildMsg ];

/// 消息类型（1管理、2临床）
Property MsgType As %Integer;

/// 消息日期
Property MsgDate As %Date;

/// 消息时间
Property MsgTime As %Time;

/// 消息人ID（指向DHCMA.Util.EP.SSUser.OID）
Property MsgUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 消息科室（指向DHCMA.Util.EP.Location.OID）
Property MsgLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 消息内容
Property MsgMessage As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否阅读
Property MsgIsRead As %Boolean;

/// 阅读日期
Property MsgReadDate As %Date;

/// 阅读时间
Property MsgReadTime As %Time;

/// 阅读人ID（指向DHCMA.Util.EP.SSUser.OID）
Property MsgReadUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 外部消息ID（HIS消息，为同步状态使用 ^websys.DHCMessageDetails）
Property MsgDtlID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 外部消息ID 索引
Index IndexMsgDtlID On MsgDtlID As Exact;

/// 消息日期时间 索引
Index IndexMsgDateTime On (MsgDate, MsgTime);

/// Creator：     zhangdc
/// CreatDate：   2020-09-01
/// Description:  根据ID取消息记录信息
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// Input：       Id : DHCMA.IMP.IP.IMPRecordMsg.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.IP.IMPRecordMsg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.IMPRecordMsg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.IMPRecordMsg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.IMPRecordMsg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-09-01
/// Description:  删除消息记录信息
/// Table：       DHCMA.IMP.IP.IMPRecordMsg
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.IMPRecordMsg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.IMPRecordMsg).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MsgEpisodeID</Value>
</Value>
<Value name="3">
<Value>MsgType</Value>
</Value>
<Value name="4">
<Value>MsgDate</Value>
</Value>
<Value name="5">
<Value>MsgTime</Value>
</Value>
<Value name="6">
<Value>MsgUserID</Value>
</Value>
<Value name="7">
<Value>MsgLocID</Value>
</Value>
<Value name="8">
<Value>MsgMessage</Value>
</Value>
<Value name="9">
<Value>MsgIsRead</Value>
</Value>
<Value name="10">
<Value>MsgReadDate</Value>
</Value>
<Value name="11">
<Value>MsgReadTime</Value>
</Value>
<Value name="12">
<Value>MsgReadUserID</Value>
</Value>
<Value name="13">
<Value>MsgDtlID</Value>
</Value>
<Value name="14">
<Value>MsgRecordDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Msg")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Msg")</IdLocation>
<IndexLocation>^MA.IMP.IPIMPRecordI("Msg")</IndexLocation>
<StreamLocation>^MA.IMP.IPIMPRecordMsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
