Class EPRinstance.RecInstanceData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxEpisodeID On EpisodeID;

Index IdxInstanceIDSeqNo On (InstanceID, SeqNo);

Property InstanceID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

/// 病历创建日期
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.RecInstanceDataS");

Property ListNo As %String(TRUNCATE = 1);

Property SeqNo As %Integer;

//d ##class(EPRinstance.RecInstanceData).CheckStatus(AInstanceID)

/// 病历修改日期
Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property Title As %String(TRUNCATE = 1);

/// 历次病程记录备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 查询指定被删除的病历的ID号,需要传对应的SeqNo
ClassMethod GetDumpedDataID(AInstanceID As %String = "", ASeqNo As %Integer = 1)
{
	Quit:(AInstanceID="") -1
	
	s AInstanceID=" "_AInstanceID
	s ind = ""
	
	s ind = $o(^DHCEPRI.RecInstanceDataI("IdxInstanceIDSeqNo",AInstanceID,ASeqNo,""))	
	Quit:(ind="") -1
	
	Quit $TR(ind," ")
}

/// 返回同一InstancID最后一个dumped实例数据的SeqNo
ClassMethod EndofSeq(AInstanceID As %String) As %Integer
{
	s ind="", count=""
	s AInstanceID=" "_AInstanceID
	
	for {
		s ind=$o(^DHCEPRI.RecInstanceDataI("IdxInstanceIDSeqNo",AInstanceID,ind))
		if (ind'="")
		{
			s count = ind
		}
		Quit:ind=""
	}
	
	Quit:(count="") 0
	Quit $TR(count," ")
}

/// 获取一条RecInstance记录，ASeqNo为-1时返回最后一条
ClassMethod FetchDumpedData(AInstanceID As %String, ASeqNo As %Integer = 1)
{
	if (ASeqNo=-1)
	{
		s SeqNo = ..EndofSeq(AInstanceID)
		s ind = ..GetDumpedDataID(AInstanceID,SeqNo)
		Quit:(ind=-1) -1
	}
	else
	{
		s ind = ..GetDumpedDataID(AInstanceID,ASeqNo)
		Quit:(ind=-1) -1
	}
	
	s dumpedData =  ##class(EPRinstance.RecInstanceData).%OpenId(ind)
	Quit:($$$NULLOREF=dumpedData) $$$NULLOREF
	
	Quit dumpedData
}

/// 检查记录状态字段Status
ClassMethod CheckStatus(AInstanceID As %String = "", ASeqNo = -1) As %String
{
	Quit:(AInstanceID="") -1
	
	s objRec = ##class(EPRinstance.RecInstanceData).FetchDumpedData(AInstanceID,ASeqNo)
	Quit:(objRec=-1) -1
	
	Quit objRec.Status
}

ClassMethod ModifyData() As %Integer
{
	Quit -1
}

Storage Default
{
<Data name="RecInstanceDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
<Value name="7">
<Value>GroupItemID</Value>
</Value>
<Value name="8">
<Value>GroupItemName</Value>
</Value>
<Value name="9">
<Value>HappenDate</Value>
</Value>
<Value name="10">
<Value>HappenTime</Value>
</Value>
<Value name="11">
<Value>InstanceData</Value>
</Value>
<Value name="12">
<Value>ListNo</Value>
</Value>
<Value name="13">
<Value>SeqNo</Value>
</Value>
<Value name="14">
<Value>Log</Value>
</Value>
<Value name="15">
<Value>ModifyDate</Value>
</Value>
<Value name="16">
<Value>ModifyTime</Value>
</Value>
<Value name="17">
<Value>ModifyUser</Value>
</Value>
<Value name="18">
<Value>Status</Value>
</Value>
<Value name="19">
<Value>TemplateID</Value>
</Value>
<Value name="20">
<Value>TemplateVersion</Value>
</Value>
<Value name="21">
<Value>Title</Value>
</Value>
<Value name="22">
<Value>Remark</Value>
</Value>
<Value name="23">
<Value>MetaData</Value>
</Value>
<Value name="24">
<Value>PresentationData</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.RecInstanceDataD</DataLocation>
<DefaultData>RecInstanceDataDefaultData</DefaultData>
<IdLocation>^DHCEPRI.RecInstanceDataD</IdLocation>
<IndexLocation>^DHCEPRI.RecInstanceDataI</IndexLocation>
<StreamLocation>^DHCEPRI.RecInstanceDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
