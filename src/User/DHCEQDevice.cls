Class User.DHCEQDevice Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = D_RowID, SqlTableName = DHC_EQDevice, StorageStrategy = SQLStorage ]
{

///  第三方效益分析仪器表          DHC_EQDevice
///  D_RowID             1           
///  D_SysName           2	       仪器系统名称
///  D_SysVersion        3          系统版本
///  D_DeviceID          4          仪器ID
///  D_Device            5          仪器名称
///  D_AddDate           6          仪器添加日期
///  D_LastUpdateDate    7          最好一次更新日期
///  D_InvalidFlag       8          无效标记
///  D_Remark            9          备注
Parameter EXTENTSIZE = 250;

Property DSysName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = D_SysName ];

///  D_SysName 
Property DSysVersion As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = D_SysVersion ];

///  D_SysVersion
Property DDeviceID As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = D_DeviceID ];

///  D_DeviceID
Property DDevice As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = D_Device ];

///  D_Device
Property DAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = D_AddDate ];

///  D_AddDate
Property DLastUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = D_LastUpdateDate ];

///  D_LastUpdateDate
Property DInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = D_InvalidFlag ];

///  D_InvalidFlag
Property DRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = D_Remark ];

///      D_Remark

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDevice("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="D_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="D_Device">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="D_DeviceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="D_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="D_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="D_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="D_SysName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="D_SysVersion">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQDevice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>D_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{D_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSysDevice">
<Global>^DHCEQDevice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>D_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SysName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{D_SysName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{D_Device}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{D_DeviceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{D_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDeviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
