Class User.EnsAmountOfTube Extends (%Persistent, %XML.Adaptor)
{

/// 试管医嘱编码
Property TubeItemCode As %String(MAXLEN = 32767) [ SqlFieldName = Tube_ItemCode ];

/// 病人就诊号
Property AdmRowId As %String(MAXLEN = 32767) [ SqlFieldName = Adm_RowId ];

/// 对应检验医嘱
Property LabRowId As %String(MAXLEN = 32767) [ SqlFieldName = Lab_RowId ];

/// HIS产生试管医嘱费用ID
Property TubeRowId As %String(MAXLEN = 32767) [ SqlFieldName = Tube_RowId ];

/// 插入日期
Property IntInsDate As %Date [ SqlFieldName = Int_InsDate ];

/// 插入时间
Property IntInsTime As %Time [ SqlFieldName = Int_InsTime ];

/// 按病人就诊号、HIS产生试管医嘱费用ID进行检索
Index IndexAdmRowIdAndTubeRowId On (AdmRowId, TubeRowId);

Index IndexAdmRowIdAndLabRowId On (AdmRowId, LabRowId);

Storage Default
{
<Data name="EnsAmountOfTubeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TubeItemCode</Value>
</Value>
<Value name="3">
<Value>AdmRowId</Value>
</Value>
<Value name="4">
<Value>LabRowId</Value>
</Value>
<Value name="5">
<Value>TubeRowId</Value>
</Value>
<Value name="6">
<Value>IntInsDate</Value>
</Value>
<Value name="7">
<Value>IntInsTime</Value>
</Value>
</Data>
<DataLocation>^User.EnsAmountOfTubeD</DataLocation>
<DefaultData>EnsAmountOfTubeDefaultData</DefaultData>
<IdLocation>^User.EnsAmountOfTubeD</IdLocation>
<IndexLocation>^User.EnsAmountOfTubeI</IndexLocation>
<StreamLocation>^User.EnsAmountOfTubeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
