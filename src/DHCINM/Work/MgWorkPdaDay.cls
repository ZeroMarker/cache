/// Creater:wangpf
/// Descriptions:PDA执行率
/// Date:2021-11-10
Class DHCINM.Work.MgWorkPdaDay Extends %Persistent
{

Relationship ChildSub As DHCINM.Work.MgWorkPdaDaySub [ Cardinality = children, Inverse = Paref ];

/// 病区
Property WorkWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Work_Ward ];

/// 日期
Property WorkDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Work_Date ];

/// 护士
Property WorkNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 4, SqlFieldName = Work_Nurse ];

/// Work_CreateUser 创建者
Property WorkCreateUser As %String [ SqlColumnNumber = 5, SqlFieldName = Work_CreateUser ];

/// Work_CreateDate 创建日期
Property WorkCreateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6, SqlFieldName = Work_CreateDate ];

/// Work_CreatTime 创建时间
Property WorkCreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = Work_CreatTime ];

Index Date On WorkDate;

Index Ward On WorkWard;

Index DateWard On (WorkDate, WorkWard);

Storage Default
{
<Data name="MgWorkPdaDayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkWard</Value>
</Value>
<Value name="3">
<Value>WorkDate</Value>
</Value>
<Value name="4">
<Value>WorkNurse</Value>
</Value>
<Value name="5">
<Value>WorkCreateUser</Value>
</Value>
<Value name="6">
<Value>WorkCreateDate</Value>
</Value>
<Value name="7">
<Value>WorkCreatTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Work.MgWorkPdaDayD</DataLocation>
<DefaultData>MgWorkPdaDayDefaultData</DefaultData>
<IdLocation>^DHCINM.Work.MgWorkPdaDayD</IdLocation>
<IndexLocation>^DHCINM.Work.MgWorkPdaDayI</IndexLocation>
<StreamLocation>^DHCINM.Work.MgWorkPdaDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
