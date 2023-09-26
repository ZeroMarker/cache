/// 项目发生明细记录、到达时项目、加项时项目、停止时项目
Class User.DHCPEItemDetailRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ItemDetailRecord ]
{

Parameter ClassName = "User.DHCPEItemDetailRecord";

/// 医嘱ID
Property IDROEORIDR As User.OEOrdItem [ Required, SqlFieldName = IDR_OEORI_DR ];

/// 类型  A：添加项目  D：删除项目
Property IDRType As %String(MAXLEN = 1) [ Required, SqlFieldName = IDR_Type ];

/// 发生日期
Property IDRDate As %Library.Date [ Required, SqlFieldName = IDR_Date ];

/// 发生时间
Property IDRTime As %Library.Time [ Required, SqlFieldName = IDR_Time ];

/// 操作员
Property IDRUserDR As User.SSUser [ Required, SqlFieldName = IDR_User_DR ];

/// 日期索引
Index IDRDateIndex On IDRDate;

Storage Default
{
<Data name="DHCPEItemDetailRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDROEORIDR</Value>
</Value>
<Value name="3">
<Value>IDRType</Value>
</Value>
<Value name="4">
<Value>IDRDate</Value>
</Value>
<Value name="5">
<Value>IDRTime</Value>
</Value>
<Value name="6">
<Value>IDRUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEItemDetailRecordD</DataLocation>
<DefaultData>DHCPEItemDetailRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEItemDetailRecordD</IdLocation>
<IndexLocation>^User.DHCPEItemDetailRecordI</IndexLocation>
<StreamLocation>^User.DHCPEItemDetailRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
