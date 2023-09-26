Class EPRinstance.Dental.ToothRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

//多个牙位之间使用","分割,如：12,45

Property ToothPositionCode As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property RecordContent As %String(MAXLEN = 320000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property InstanceDataID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property TemplateID As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property MetaItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Property EPRDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property EPRNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property CreateDate As %Date [ SqlColumnNumber = 11 ];

Property CreateTime As EPRmeta.Time [ SqlColumnNumber = 12 ];

Property UpdateDate As %Date [ SqlColumnNumber = 13 ];

Property UpdateTime As EPRmeta.Time [ SqlColumnNumber = 14 ];

Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Property UpdateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

Property RowNo As %Integer [ SqlColumnNumber = 17 ];

Index IdxAdmCreateDT On (PatientID, EpisodeID, CreateDate, CreateTime) [ Data = ToothPositionCode ];

Index IdxPatCreateDT On (PatientID, CreateDate, CreateTime) [ Data = ToothPositionCode ];

Index IdxInstanceDataID On (EpisodeID, InstanceDataID, TemplateID, MetaItemCode, RowNo) [ Unique ];

Storage Default
{
<Data name="ToothRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ToothPositionCode</Value>
</Value>
<Value name="5">
<Value>RecordContent</Value>
</Value>
<Value name="6">
<Value>InstanceDataID</Value>
</Value>
<Value name="7">
<Value>TemplateID</Value>
</Value>
<Value name="8">
<Value>MetaItemCode</Value>
</Value>
<Value name="9">
<Value>EPRDocID</Value>
</Value>
<Value name="10">
<Value>EPRNum</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateTime</Value>
</Value>
<Value name="15">
<Value>CreateUserID</Value>
</Value>
<Value name="16">
<Value>UpdateUserID</Value>
</Value>
<Value name="17">
<Value>RowNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.Dental.ToothRecordD</DataLocation>
<DefaultData>ToothRecordDefaultData</DefaultData>
<IdLocation>^DHCEPRI.Dental.ToothRecordD</IdLocation>
<IndexLocation>^DHCEPRI.Dental.ToothRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.Dental.ToothRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
