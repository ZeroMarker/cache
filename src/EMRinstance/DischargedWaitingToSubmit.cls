/// Desc:       患者出院待送病案室表
/// Creator:    DongLuLu
/// CreateDate: 2020-8-24
Class EMRinstance.DischargedWaitingToSubmit Extends (%Persistent, %XML.Adaptor)
{

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 护士结算日期
Property NurseSettlementDate As %Date;

/// 护士结算时间
Property NurseSettlementTime As %Time;

/// 医生下出院医嘱日期
Property DischargeOrderDate As %Date;

/// 医生下出院医嘱时间
Property DischargeOrderTime As %Time;

Index IdxEpisodeID On EpisodeID [ Unique ];

Index IdxOrderDateTime On (DischargeOrderDate, DischargeOrderTime);

Index IdxSettleDateTime On (NurseSettlementDate, NurseSettlementTime);

Storage Default
{
<Data name="DischargedWaitingToSubmitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>NurseSettlementDate</Value>
</Value>
<Value name="4">
<Value>NurseSettlementTime</Value>
</Value>
<Value name="5">
<Value>DischargeOrderDate</Value>
</Value>
<Value name="6">
<Value>DischargeOrderTime</Value>
</Value>
<Value name="7">
<Value>CalculateType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.DisWaitToSubmitD</DataLocation>
<DefaultData>DischargedWaitingToSubmitDefaultData</DefaultData>
<IdLocation>^DHCEMRI.DisWaitToSubmitD</IdLocation>
<IndexLocation>^DHCEMRI.DisWaitToSubmitI</IndexLocation>
<StreamLocation>^DHCEMRI.DisWaitToSubmitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
