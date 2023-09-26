/// CA认证(数字证书认证)
Class User.DHCEmSignVerify Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, Owner = {_SYSTEM}, SqlRowIdName = SV_RowID, SqlTableName = DHC_EmSignVerify, StorageStrategy = CacheStorage ]
{

/// 关联指针 SV_Pointer_Dr EXEC(执行记录ID),MDT(DHC_MDTConsultItm)
Property SVPointerDr As %String [ SqlColumnNumber = 2, SqlFieldName = SV_Pointer_Dr ];

/// 医嘱主要信息原文(使用HASH数据存储)
Property SVMainInfo As %String(MAXLEN = 5000) [ SqlColumnNumber = 3, SqlFieldName = SV_MainInfo ];

/// 医嘱主要信息签名证书(仅数据签名服务器验签需要此参数,其它P7和XML都封装在签名信息中)
Property SVMainSignCert As %String(MAXLEN = 5000) [ SqlColumnNumber = 4, SqlFieldName = SV_MainSignCert ];

/// 医嘱时间戳
Property SVMainSignTimeStamp As %String(MAXLEN = 99999) [ SqlColumnNumber = 5, SqlFieldName = SV_MainSignTimeStamp ];

/// 医嘱主要信息签名信息
Property SVMainSignValue As %String(MAXLEN = 5000) [ SqlColumnNumber = 6, SqlFieldName = SV_MainSignValue ];

/// 记录创建人
Property SVCreateUserDr As %String [ SqlColumnNumber = 7, SqlFieldName = SV_CreateUser_Dr ];

/// 记录创建日期
Property SVCreateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SV_CreateDate ];

/// 记录创建时间
Property SVCreateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = SV_CreateTime ];

/// 操作类型 SVModuleMark不同,意义不同
/// EXEC：F 执行，C 撤销执行
Property SVOperationType As %String [ SqlColumnNumber = 10, SqlFieldName = SV_OperationType ];

/// 模块标识 EXEC(护士执行)/MDT(MDT会诊)
Property SVModuleMark As %String [ SqlColumnNumber = 11, SqlFieldName = SV_ModuleMark ];

/// 指向 CA.DigitalSignature (电子病历接口表关联)
Property SVDigitalSignatureDr As CA.DigitalSignature [ SqlColumnNumber = 12, SqlFieldName = SV_DigitalSignature_Dr ];

Storage CacheStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEmSignVerify)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SV_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SV_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SV_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SV_DigitalSignature_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SV_MainInfo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SV_MainSignCert">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SV_MainSignTimeStamp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SV_MainSignValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SV_ModuleMark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SV_OperationType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SV_Pointer_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMSV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SV_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SV_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOre">
<Global>^DHCEMSV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexOre"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_Pointer_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCEMSV</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_ModuleMark}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SV_Pointer_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SV_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEmSignVerifyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
