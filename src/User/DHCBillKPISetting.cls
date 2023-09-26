Class User.DHCBillKPISetting Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPI_RowID, SqlTableName = DHC_BillKPISetting, StorageStrategy = SQLStorage ]
{

/// KPI_TaskType
Property KPITaskType As User.DHCBillKPITaskType [ Required, SqlColumnNumber = 2, SqlFieldName = KPI_TaskType ];

/// KPI_Type
Property KPIType As %Library.String(DISPLAYLIST = ",Inherent,Custom", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,C") [ SqlColumnNumber = 3, SqlFieldName = KPI_Type ];

/// KPI_Code
Property KPICode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = KPI_Code ];

/// KPI_Name
Property KPIName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = KPI_Name ];

/// KPI_Order
Property KPIOrder As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = KPI_Order ];

/// KPI_Class
Property KPIClass As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = KPI_Class ];

/// KPI_Method
Property KPIMethod As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = KPI_Method ];

/// KPI_StorageType
Property KPIStorageType As %Library.String(DISPLAYLIST = ",Table,Global", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",T,G") [ SqlColumnNumber = 9, SqlFieldName = KPI_StorageType ];

/// KPI_TableName
Property KPITableName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = KPI_TableName ];

/// KPI_DataNode
Property KPIDataNode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = KPI_DataNode ];

/// KPI_DataDimen
Property KPIDataDimen As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = KPI_DataDimen ];

/// KPI_Active
Property KPIActive As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = KPI_Active ];

/// KPI_Creator
Property KPICreator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = KPI_Creator ];

/// KPI_CreatDate
Property KPICreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = KPI_CreatDate ];

/// KPI_CreatTime
Property KPICreatTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = KPI_CreatTime ];

/// KPI_ReMark
Property KPIReMark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = KPI_ReMark ];

Index KPICodeUnqIdx On KPICode [ Unique ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBILLKPISETTING)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="KPI_Active">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="KPI_Class">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KPI_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KPI_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="KPI_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="KPI_Creator">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="KPI_DataDimen">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="KPI_DataNode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="KPI_Method">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="KPI_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KPI_Order">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="KPI_ReMark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="KPI_StorageType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="KPI_TableName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="KPI_TaskType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KPI_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBILLKPISETTING</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{KPI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCBILLKPISETTING</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTaskType">
<Global>^DHCBILLKPISETTING</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TaskType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPI_TaskType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillKPISettingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
