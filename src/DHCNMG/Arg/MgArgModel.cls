/// creator: xbl
/// createdate: 20170901
/// description: 排班模板
Class DHCNMG.Arg.MgArgModel Extends %Persistent
{

/// 病区Id
Property ArgWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Arg_WardDR ];

/// 模板单号 开始日期+病区Id
Property ModelCode As %String [ SqlColumnNumber = 3, SqlFieldName = Model_Code ];

/// 模板名称
Property ModelDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Model_Desc ];

/// 备注
Property ArgRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Arg_Remark ];

/// 创建人
Property ArgCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Arg_CrtUser ];

/// 创建日期
Property ArgCrtDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Arg_CrtDate ];

/// 创建时间
Property ArgCrtTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Arg_CrtTime ];

Index Ward On ArgWardDR;

Storage Default
{
<Data name="MgArgModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgWardDR</Value>
</Value>
<Value name="3">
<Value>ModelCode</Value>
</Value>
<Value name="4">
<Value>ModelDesc</Value>
</Value>
<Value name="5">
<Value>ArgRemark</Value>
</Value>
<Value name="6">
<Value>ArgCrtUser</Value>
</Value>
<Value name="7">
<Value>ArgCrtDate</Value>
</Value>
<Value name="8">
<Value>ArgCrtTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArgModelD</DataLocation>
<DefaultData>MgArgModelDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArgModelD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArgModelI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArgModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
