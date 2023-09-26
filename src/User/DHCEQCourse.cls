Class User.DHCEQCourse Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CO_RowID, SqlTableName = DHC_EQCourse, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index CONoUnqIdx1 On CONo [ Unique ];

/// CO_ClassHours
Property COClassHours As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CO_ClassHours ];

/// CO_CourseContent
Property COCourseContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CO_CourseContent ];

/// CO_Hold1
Property COHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CO_Hold1 ];

/// CO_Hold2
Property COHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CO_Hold2 ];

/// CO_Hold3
Property COHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CO_Hold3 ];

/// CO_Hold4
Property COHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CO_Hold4 ];

/// CO_Hold5
Property COHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CO_Hold5 ];

/// CO_Institution
Property COInstitution As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CO_Institution ];

/// CO_InvalidFlag
Property COInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = CO_InvalidFlag ];

/// CO_ItemDR
Property COItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 10, SqlFieldName = CO_ItemDR ];

/// CO_Manager
Property COManager As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CO_Manager ];

/// CO_ModelDR
Property COModelDR As User.DHCEQCModel [ SqlColumnNumber = 11, SqlFieldName = CO_ModelDR ];

/// CO_Name
Property COName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CO_Name ];

/// CO_No
Property CONo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CO_No ];

/// CO_Remark
Property CORemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CO_Remark ];

/// CO_SourceID
Property COSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CO_SourceID ];

/// CO_SourceType
Property COSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CO_SourceType ];

/// CO_Status
Property COStatus As %Library.String(DISPLAYLIST = ",新增,进行中,审核完成", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 16, SqlFieldName = CO_Status ];

/// CO_TrainEndDate
Property COTrainEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = CO_TrainEndDate ];

/// CO_TrainObj
Property COTrainObj As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CO_TrainObj ];

/// CO_TrainStartDate
Property COTrainStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = CO_TrainStartDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCourse("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CO_ClassHours">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CO_CourseContent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CO_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CO_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CO_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CO_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CO_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CO_Institution">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CO_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CO_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CO_Manager">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CO_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CO_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CO_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CO_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CO_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CO_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CO_TrainEndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CO_TrainObj">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CO_TrainStartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCourse</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CO_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQCourse</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CO_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQCourse</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CO_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CO_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCourseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
