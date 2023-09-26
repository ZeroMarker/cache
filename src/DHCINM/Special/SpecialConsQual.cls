/// Creater:wangpf
/// Descriptions:重会诊资质成员
/// Date:2020-07-27
Class DHCINM.Special.SpecialConsQual Extends %Persistent
{

/// 人员
Property QualPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Qual_Per ];

/// 专业组
Property QualGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Qual_Group ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 4, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = Create_Time ];

Index Per On (QualPer, QualGroup);

Storage Default
{
<Data name="SpecialConsQualDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualPer</Value>
</Value>
<Value name="3">
<Value>QualGroup</Value>
</Value>
<Value name="4">
<Value>Creator</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialConsQualD</DataLocation>
<DefaultData>SpecialConsQualDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialConsQualD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialConsQualI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialConsQualS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
