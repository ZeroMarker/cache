Class EPRinstance.AnySignLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property IsValid As %Boolean;

Property EpisodeID As %String(TRUNCATE = 1);

Property DocUserID As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property EPRNum As %String(TRUNCATE = 1);

Property InsID As %String(TRUNCATE = 1);

Property SeqNum As %Integer;

//以下六个字段是将BJCA返回的签名值JSON拆分存储

Property Algorithm As %String(MAXLEN = 999999, TRUNCATE = 1);

Property BioFeature As %GlobalCharacterStream(LOCATION = "^DHCEPRI.AnySignLogS");

Property EventCert As %String(MAXLEN = 999999, TRUNCATE = 1);

Property SigValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property TSValue As %String(MAXLEN = 999999, TRUNCATE = 1);

Property Version As %String(TRUNCATE = 1);

Property SignUser As %String(MAXLEN = 256, TRUNCATE = 1);

Property SignTime As %String(TRUNCATE = 1);

Property SignScript As %GlobalCharacterStream(LOCATION = "^DHCEPRI.AnySignLogS");

Property FingerPrint As %GlobalCharacterStream(LOCATION = "^DHCEPRI.AnySignLogS");

Property PlainText As %String(MAXLEN = 999999, TRUNCATE = 1);

Index Idx On (EpisodeID, PrintDocID, EPRNum, SeqNum);

/// 取最后一次签名
ClassMethod getAnySignLog(EpisodeID As %String = "", PrintDocID As %String = "", EPRNum As %String = "", SeqNum As %Integer = 1) As %String
{
	Quit:(EpisodeID = "") ""
	Quit:(PrintDocID = "") ""
	Quit:(EPRNum = "") ""
	
	s oid = $o(^DHCEPRI.AnySignLogI("Idx"," "_EpisodeID," "_PrintDocID," "_EPRNum, SeqNum, ""), -1)
	q:(oid="") ""
	
	q oid
}

ClassMethod getValidSign(EpisodeID As %String = "", PrintDocID As %String = "", EPRNum As %String = "", SeqNum As %Integer = 1) As EPRinstance.AnySignLog
{
	s id=..getAnySignLog(EpisodeID, PrintDocID, EPRNum, SeqNum)
	Quit:(""=id) ""
	
	s anySignLog = ##Class(EPRinstance.AnySignLog).%OpenId(id)
	q:(anySignLog.IsValid=0) ""
	q anySignLog
}

/// 设置指定签名失效
ClassMethod setUnvalid(anySignLogID As %String)
{
	s anySignLog = ##Class(EPRinstance.AnySignLog).%OpenId(anySignLogID)
	
	if (anySignLog'="")
	{
		s anySignLog.IsValid=0
		d anySignLog.%Save()
		s anySignLog = ""
	}
}

/// 设置同一模板所有签名失效
ClassMethod setAnySignUnvalid(EpisodeID As %String = "", PrintDocID As %String = "", EPRNum As %String = "")
{
	s SeqNum = ""
	for {
		s SeqNum = $o(^DHCEPRI.AnySignLogI("Idx"," "_EpisodeID," "_PrintDocID," "_EPRNum, SeqNum))
		q:(SeqNum="")
		
		s oid = ""
		for {
			s oid = $o(^DHCEPRI.AnySignLogI("Idx"," "_EpisodeID," "_PrintDocID," "_EPRNum, SeqNum, oid))
			q:(oid = "")
			
			s obj = ##Class(EPRinstance.AnySignLog).%OpenId(oid)
			continue:(obj="")
			continue:(obj.IsValid = "0")
			
			s obj.IsValid = "0"
			d obj.%Save()
		}
	}
}

/// 查询病历签名值的状态
/// 0 无签名；1 有效签名；2签名失效
/// w ##Class(EPRinstance.AnySignLog).getSignStatus("","","")
ClassMethod getSignStatus(EpisodeID As %String, PrintDocID As %String, EPRNum As %String) As %String
{
	s signFlag = 0
	s userDesc = ""
	
	s SeqNum = ""
	for {
		s SeqNum = $o(^DHCEPRI.AnySignLogI("Idx"," "_EpisodeID," "_PrintDocID," "_EPRNum, SeqNum))
		q:(SeqNum="")
		if signFlag = 2
		{
			q
		}
		
		s oid = ""
		for {
			s oid = $o(^DHCEPRI.AnySignLogI("Idx"," "_EpisodeID," "_PrintDocID," "_EPRNum, SeqNum, oid))
			q:(oid = "")
			
			s obj = ##Class(EPRinstance.AnySignLog).%OpenId(oid)
			continue:(obj="")
			
			s:(obj.DocUserID'="") userDesc = ##class(EPRmeta.Privilege.PowerUser).GetUserName(obj.DocUserID)
			s:(obj.DocUserID'="") userDesc = $tr(userDesc,$c(13,10))
			s signFlag = 2
			
			if (obj.IsValid=1)
			{
				s signFlag = 1
				q
			}
		}
	}
	
	q:(signFlag = 0) ""
	q:(signFlag = 1) "1^患者签名有效(由 "_userDesc_" 发起)"
	q:(signFlag = 2) "2^当前患者签名已失效"
}

Storage Default
{
<Data name="AnySignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PrintDocID</Value>
</Value>
<Value name="4">
<Value>EPRNum</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>SignScript</Value>
</Value>
<Value name="7">
<Value>FingerPrint</Value>
</Value>
<Value name="8">
<Value>SignUser</Value>
</Value>
<Value name="9">
<Value>SignTime</Value>
</Value>
<Value name="10">
<Value>PlainText</Value>
</Value>
<Value name="11">
<Value>SeqNum</Value>
</Value>
<Value name="12">
<Value>Algorithm</Value>
</Value>
<Value name="13">
<Value>BioFeature</Value>
</Value>
<Value name="14">
<Value>EventCert</Value>
</Value>
<Value name="15">
<Value>SigValue</Value>
</Value>
<Value name="16">
<Value>TSValue</Value>
</Value>
<Value name="17">
<Value>Version</Value>
</Value>
<Value name="18">
<Value>InsID</Value>
</Value>
<Value name="19">
<Value>DocUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.AnySignLogD</DataLocation>
<DefaultData>AnySignLogDefaultData</DefaultData>
<IdLocation>^DHCEPRI.AnySignLogD</IdLocation>
<IndexLocation>^DHCEPRI.AnySignLogI</IndexLocation>
<StreamLocation>^DHCEPRI.AnySignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
