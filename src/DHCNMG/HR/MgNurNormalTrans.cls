/// Creator:gzj
/// Date:2018-11-11
/// Description:规培生轮转记录主表
Class DHCNMG.HR.MgNurNormalTrans Extends %Persistent
{

Relationship ChildSub As DHCNMG.HR.MgNurNormalTransSub [ Cardinality = children, Inverse = Parref ];

Relationship DateSub As DHCNMG.HR.MgNurNormativeDate [ Cardinality = children, Inverse = DateParref ];

Relationship GroupSub As DHCNMG.HR.MgNurNormativeGroup [ Cardinality = children, Inverse = GroupParref ];

/// 年份
Property TransYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Trans_Year ];

/// 标题
Property TransTitle As %String [ SqlColumnNumber = 3, SqlFieldName = Trans_Title ];

/// 备注
Property TransRemart As %String [ SqlColumnNumber = 4, SqlFieldName = Trans_Remark ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 5, SqlFieldName = Create_User ];

/// 状态
Property TransFlag As %String [ SqlColumnNumber = 6, SqlFieldName = Trans_Flag ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

Index flag On (TransFlag, TransYear);

Storage Default
{
<Data name="MgNurNormalTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransYear</Value>
</Value>
<Value name="3">
<Value>TransTitle</Value>
</Value>
<Value name="4">
<Value>TransRemart</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreateUser</Value>
</Value>
<Value name="8">
<Value>TransFlag</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNormalTransD</DataLocation>
<DefaultData>MgNurNormalTransDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurNormalTransD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNormalTransI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNormalTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
