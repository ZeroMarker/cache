/// 
/// 
/// 调查类型管理
Class DHCNMG.DB.MgNurSurveyType Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgNurSurveyTypeSub [ Cardinality = children, Inverse = Parref ];

/// 调查形式
Property TypeForm As %String [ SqlColumnNumber = 2, SqlFieldName = Type_Form ];

/// 调查开始日期
Property TypeStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Type_StDate ];

/// 调查标题
Property TypeTitle As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = Type_Title ];

/// 调查说明
Property TypeExplanation As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Type_Explanation ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 6, SqlFieldName = Create_User ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

/// 状态
Property Status As %String [ SqlColumnNumber = 9, SqlFieldName = Status ];

Index USER On CreateUser;

Index Date On TypeStDate;

Storage Default
{
<Data name="MgNurSurveyTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeForm</Value>
</Value>
<Value name="3">
<Value>TypeStDate</Value>
</Value>
<Value name="4">
<Value>TypeTitle</Value>
</Value>
<Value name="5">
<Value>TypeExplanation</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurSurveyTypeD</DataLocation>
<DefaultData>MgNurSurveyTypeDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgNurSurveyTypeD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurSurveyTypeI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurSurveyTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
