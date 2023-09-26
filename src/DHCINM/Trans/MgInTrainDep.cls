/// desc:来院进修调科记录
Class DHCINM.Trans.MgInTrainDep Extends %Persistent
{

/// 护士ID
Property NurseId As %String [ SqlColumnNumber = 2, SqlFieldName = Train_NurseId ];

/// 转入病区
Property InWard As %String [ SqlColumnNumber = 3, SqlFieldName = Train_InWard ];

/// 调配开始日期
Property TransStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Train_TransStDate ];

/// 调配结束日期
Property TransEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Train_TransEndDate ];

/// 带教老师
Property Teacher As %String [ SqlColumnNumber = 6, SqlFieldName = Train_Teacher ];

/// 调配状态
Property TransStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Train_Status ];

Index ssdr On NurseId;

Storage Default
{
<Data name="MgInTrainDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseId</Value>
</Value>
<Value name="3">
<Value>InWard</Value>
</Value>
<Value name="4">
<Value>TransStDate</Value>
</Value>
<Value name="5">
<Value>TransEndDate</Value>
</Value>
<Value name="6">
<Value>Teacher</Value>
</Value>
<Value name="7">
<Value>TransStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgInTrainDepD</DataLocation>
<DefaultData>MgInTrainDepDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgInTrainDepD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgInTrainDepI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgInTrainDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
