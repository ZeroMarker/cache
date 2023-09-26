/// 体检数据修改记录
Class User.DHCPEModifyRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ModifyRecord ]
{

Parameter ClassName = "User.DHCPEModifyRecord";

/// 数据源ID
Property MRSourceID As %String [ Required, SqlFieldName = MR_SourceDR ];

/// 数据源类型
Property MRSourceType As %String [ Required, SqlFieldName = MR_SourceType ];

/// 修改日期
Property MRDate As %Date [ Required, SqlFieldName = MR_Date ];

/// 修改时间
Property MRTime As %Time [ Required, SqlFieldName = MR_Time ];

/// 修改前信息
Property MROldInfo As %String(MAXLEN = 1000) [ SqlFieldName = MR_OldInfo ];

/// 修改后信息
Property MRNewInfo As %String(MAXLEN = 1000) [ SqlFieldName = MR_NewInfo ];

/// 修改人ID
Property MRUserDR As User.SSUser [ Required, SqlFieldName = MR_UserDR ];

/// 修改记录索引
Index SourceIndex On (MRSourceType As AlphaUp, MRSourceID As AlphaUp);

Storage Default
{
<Data name="DHCPEModifyRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRSourceID</Value>
</Value>
<Value name="3">
<Value>MRSourceType</Value>
</Value>
<Value name="4">
<Value>MRUserDR</Value>
</Value>
<Value name="5">
<Value>MRDate</Value>
</Value>
<Value name="6">
<Value>MRTime</Value>
</Value>
<Value name="7">
<Value>MROldInfo</Value>
</Value>
<Value name="8">
<Value>MRNewInfo</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEModifyRecordD</DataLocation>
<DefaultData>DHCPEModifyRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEModifyRecordD</IdLocation>
<IndexLocation>^User.DHCPEModifyRecordI</IndexLocation>
<StreamLocation>^User.DHCPEModifyRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
