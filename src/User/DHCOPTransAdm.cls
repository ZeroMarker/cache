/// 存储转诊前数据
Class User.DHCOPTransAdm Extends %Persistent [ Inheritance = right, Owner = {_SYSTEM}, SqlRowIdName = Trans_RowID, SqlTableName = DHCOPTransAdm, StorageStrategy = SQLStorage ]
{

// 存储取自PAAdm

Property TransAdm As PAAdm [ SqlColumnNumber = 2, SqlFieldName = Trans_Adm ];

Property TransAdmDep As CTLoc [ SqlColumnNumber = 3, SqlFieldName = Trans_AdmDep ];

Property TransAdmDoc As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = Trans_AdmDoc ];

// 存储取自DHCRegistrationFee

Property TransRegFeeDep As CTLoc [ SqlColumnNumber = 5, SqlFieldName = Trans_RegFeeDep ];

Property TransRegFeeDoc As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = Trans_RegFeeDoc ];

Property TransRegFeeRoom As CTLoc [ SqlColumnNumber = 7, SqlFieldName = Trans_RegFeeRoom ];

Property TransRegFeeSessionType As RBCSessionType [ SqlColumnNumber = 8, SqlFieldName = Trans_RegFeeSessionType ];

// 存储取自DHCQueue

Property TransQueDep As CTLoc [ SqlColumnNumber = 9, SqlFieldName = Trans_QueDep ];

Property TransQueMark As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = Trans_QueMark ];

Property TransQueExabdr As DHCExaBorough [ SqlColumnNumber = 11, SqlFieldName = Trans_QueExabdr ];

// 转诊实时记录信息

Property TransUser As SSUser [ SqlColumnNumber = 12, SqlFieldName = Trans_User ];

Property TransDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Trans_Date ];

Property TransTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Trans_Time ];

Property TransAdmType As %String [ SqlColumnNumber = 15, SqlFieldName = Trans_AdmType ];

Property TransAdmNo As %String [ SqlColumnNumber = 16, SqlFieldName = Trans_AdmNo ];

// 实时转诊科室 、号别

Property TransToAdmDep As CTLoc [ SqlColumnNumber = 17, SqlFieldName = Trans_ToAdmDep ];

Property TransToAdmDoc As CTCareProv [ SqlColumnNumber = 18, SqlFieldName = Trans_ToAdmDoc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<Final>1</Final>
<IdExpression>Trans_RowID</IdExpression>
<IdLocation>^DHCOPTransAdm</IdLocation>
<IndexLocation>^DHCOPTransAdmI</IndexLocation>
<SqlIdExpression>$i(^DHCOPTransAdmN(0))</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCOPTransAdmI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Trans_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Trans_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Trans_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainData">
<Data name="Trans_Adm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Trans_AdmDep">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Trans_AdmDoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Trans_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Trans_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Trans_Date">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Trans_QueDep">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Trans_QueExabdr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Trans_QueMark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Trans_RegFeeDep">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Trans_RegFeeDoc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Trans_RegFeeRoom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Trans_RegFeeSessionType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Trans_Time">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Trans_ToAdmDep">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Trans_ToAdmDoc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="Trans_User">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCOPTransAdm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Trans_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Trans_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAdm">
<Global>^DHCOPTransAdmI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Trans_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Trans_Adm}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Trans_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Trans_RowID</SqlRowIdName>
<StreamLocation>^User.DHCOPTransAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
