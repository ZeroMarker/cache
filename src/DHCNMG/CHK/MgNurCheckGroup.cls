/// Descriptions:护士长夜查房分组【安贞夜查房人员分组列表】
/// Date:2018-04-09
/// Creator:guozj
Class DHCNMG.CHK.MgNurCheckGroup Extends %Persistent
{

/// 类型【安贞：N:夜班,H:节假日，W:周末班】
Property GroupType As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Type ];

/// 组别【安贞分两个组I:大内科、O:大外科】
Property GroupCategory As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Category ];

/// 组员【安贞一个人。对应DHCNMG.HR.MgPersons表】
Property GroupPerson As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Person ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 5, SqlFieldName = Create_User ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = Create_Time ];

/// 当前状态
Property GroupStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Group_Status ];

/// 跳过
Property GroupJump As %String [ SqlColumnNumber = 9, SqlFieldName = Group_Jump ];

/// 序号【安贞版人员顺序】
Property GroupSort As %Integer [ SqlColumnNumber = 10, SqlFieldName = Group_Sort ];

Index type On (GroupType, GroupCategory);

Index sort On (GroupType, GroupSort);

Index TypeSort On (GroupType, GroupCategory, GroupSort);

Index Per On (GroupType, GroupPerson);

Index Nur On (GroupType, GroupCategory, GroupPerson);

Storage Default
{
<Data name="MgNurCheckGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupType</Value>
</Value>
<Value name="3">
<Value>GroupCategory</Value>
</Value>
<Value name="4">
<Value>GroupPerson</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>GroupStatus</Value>
</Value>
<Value name="9">
<Value>GroupJump</Value>
</Value>
<Value name="10">
<Value>GroupSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurCheckGroupD</DataLocation>
<DefaultData>MgNurCheckGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurCheckGroupD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurCheckGroupI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurCheckGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
