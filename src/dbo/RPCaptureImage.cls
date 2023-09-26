/// RPCaptureImage
Class dbo.RPCaptureImage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_CaptureImage ]
{

Index IndexAssayNo On (BllType, BllGroupID, AssayNo, ImageClass, ImageOrder) [ SqlName = Index_AssayNo, Type = index ];

Index IndexMaster On (BllType, BllGroupID, ReceiveDate, AssayNo, ImageClass, ImageOrder) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPCAPTUREIMAGE On RowID [ PrimaryKey, SqlName = PK_RP_CAPTUREIMAGE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// BllType  
Property BllType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

/// BllGroupID  
Property BllGroupID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 检测号  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 6 ];

/// 图像类别  
Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

/// 图像序号  
Property ImageOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 文件名称  
Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 文件名称  
Property Caption As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 显示系数  
Property DisplayRatio As %Library.Float [ SqlColumnNumber = 11 ];

/// 高度  
Property Height As %Library.Float [ SqlColumnNumber = 12 ];

/// 宽度  
Property Width As %Library.Float [ SqlColumnNumber = 13 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RPCaptureImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BllType</Value>
</Value>
<Value name="3">
<Value>BllGroupID</Value>
</Value>
<Value name="4">
<Value>ReceiveDate</Value>
</Value>
<Value name="5">
<Value>AssayNo</Value>
</Value>
<Value name="6">
<Value>ImageClass</Value>
</Value>
<Value name="7">
<Value>ImageOrder</Value>
</Value>
<Value name="8">
<Value>FileName</Value>
</Value>
<Value name="9">
<Value>Caption</Value>
</Value>
<Value name="10">
<Value>DisplayRatio</Value>
</Value>
<Value name="11">
<Value>Height</Value>
</Value>
<Value name="12">
<Value>Width</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPCaptureImageD</DataLocation>
<DefaultData>RPCaptureImageDefaultData</DefaultData>
<IdLocation>^dbo.RPCaptureImageD</IdLocation>
<IndexLocation>^dbo.RPCaptureImageI</IndexLocation>
<StreamLocation>^dbo.RPCaptureImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
