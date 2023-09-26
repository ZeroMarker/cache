Class EPRinstance.Quality.QualityMessage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCreateDate On CreateDate;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 创建人 SS_User.SSUSR_RowID
Property CreateUserDR As %String(TRUNCATE = 1);

/// 反馈消息体
Property MessageBody As %String(MAXLEN = 800, TRUNCATE = 1);

Storage Default
{
<Data name="QualityMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>CreateUserDR</Value>
</Value>
<Value name="5">
<Value>MessageBody</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityMessageD</DataLocation>
<DefaultData>QualityMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualityMessageD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityMessageI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
