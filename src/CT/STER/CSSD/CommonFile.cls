Class CT.STER.CSSD.CommonFile Extends (%Persistent, User.Abstract) [ SqlTableName = CommonFile ]
{

/// 文件名称
Property CFName As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CF_Name ];

/// 文件属性（JPG，PDF，File其他）
Property CFType As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CF_Type ];

/// 图片链接
Property CFSrc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4, SqlFieldName = CF_Src ];

/// 上传人员
Property CFUserDR As User.SSUser [ Required, SqlColumnNumber = 5, SqlFieldName = CF_User_DR ];

/// 上传日期
Property CFDate As %Library.Date [ Required, SqlColumnNumber = 6, SqlFieldName = CF_Date ];

/// 上传时间
Property CFTime As %Library.Time [ Required, SqlColumnNumber = 7, SqlFieldName = CF_Time ];

/// 数据类型（Clean，Ster）
Property CFPointerType As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 8, SqlFieldName = CF_PointerType ];

/// 数据指向表ID
Property CFPointer As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 9, SqlFieldName = CF_Pointer ];

Index TypePointer On (CFPointerType As Exact, CFPointer As Exact);

Index DateSrc On (CFDate As Exact, CFSrc As Exact);

Index TypePointerName On (CFPointerType As Exact, CFPointer As Exact, CFName As Exact);

Storage Default
{
<Data name="CommonFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CFName</Value>
</Value>
<Value name="3">
<Value>CFType</Value>
</Value>
<Value name="4">
<Value>CFSrc</Value>
</Value>
<Value name="5">
<Value>CFUserDR</Value>
</Value>
<Value name="6">
<Value>CFDate</Value>
</Value>
<Value name="7">
<Value>CFTime</Value>
</Value>
<Value name="8">
<Value>CFPointerType</Value>
</Value>
<Value name="9">
<Value>CFPointer</Value>
</Value>
<Value name="10">
<Value>CFDayNum</Value>
</Value>
</Data>
<DataLocation>^CT.STER.CSSD.CommonFileD</DataLocation>
<DefaultData>CommonFileDefaultData</DefaultData>
<IdLocation>^CT.STER.CSSD.CommonFileD</IdLocation>
<IndexLocation>^CT.STER.CSSD.CommonFileI</IndexLocation>
<StreamLocation>^CT.STER.CSSD.CommonFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
