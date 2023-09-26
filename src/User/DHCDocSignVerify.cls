/// CA认证(数字证书认证)
Class User.DHCDocSignVerify Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, Owner = {_SYSTEM}, SqlRowIdName = SV_Rowid, SqlTableName = DHC_DocSignVerify, StorageStrategy = CacheStorage ]
{

/// 医嘱关联 OE_OrdItem
Property SVOEORIDR As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = SV_OEORI_DR ];

/// 医嘱主要信息原文(使用HASH数据存储)
Property SVOEORIMainInfo As %String(MAXLEN = 5000) [ SqlColumnNumber = 3, SqlFieldName = SV_OEORIMainInfo ];

/// 医嘱主要信息签名证书(仅数据签名服务器验签需要此参数,其它P7和XML都封装在签名信息中)
Property SVOEORIMainSignCert As %String(MAXLEN = 5000) [ SqlColumnNumber = 4, SqlFieldName = SV_OEORIMainSignCert ];

/// 医嘱时间戳
Property SVOEORIMainSignTimeStamp As %String(MAXLEN = 99999) [ SqlColumnNumber = 5, SqlFieldName = SV_OEORIMainSignTimeStamp ];

/// 医嘱主要信息签名信息
Property SVOEORIMainSignValue As %String(MAXLEN = 5000) [ SqlColumnNumber = 6, SqlFieldName = SV_OEORIMainSignValue ];

/// 记录创建人
Property SVCreateUserDR As %String [ SqlColumnNumber = 7, SqlFieldName = SV_CreateUser_DR ];

/// 记录创建日期
Property SVCreateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SV_CreateDate ];

/// 记录创建时间
Property SVCreateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = SV_CreateTime ];

/// 操作类型(A 下医嘱,S 停医嘱,E 执行医嘱,I 作废医嘱,C 审核抗生素生效,O 其它,P 预停医嘱,D 诊断,DD 删除诊断,
/// CR 治疗记录,CA 治疗评估,DCR 撤销治疗记录,DCA 删除治疗评估,CS 治疗评定,DCS 撤销治疗评定)
Property SVOperationType As %String(DISPLAYLIST = ",Add Order,Stop Order,Exec Order,Invalid Order,Commit Order,Other,PreStop  Order,Diag ,DeDiag,CureRecord,CureAss,CancelCureRecord,DelCureAss,CureScale,CancelCureScale", MAXLEN = 16, SELECTIVITY = "16.6666%", TRUNCATE = 1, VALUELIST = ",A,S,E,I,C,O,P,D,DD,CR,CA,CCR,DCA,CS,DCS") [ SqlColumnNumber = 10, SqlFieldName = SV_OperationType ];

/// 其它医嘱信息签名记录
Property SVOEORIOtherSignRecord As list Of DHCDocOrdOtherSignRecord [ SqlColumnNumber = 11, SqlFieldName = SV_OEORIOtherSignRecord ];

/// 指向 CA.DigitalSignature (电子病历接口表关联)
Property SVDigitalSignatureDR As CA.DigitalSignature [ SqlColumnNumber = 12, SqlFieldName = SV_DigitalSignature_DR ];

/// 指向 CA.DigitalSignature (电子病历接口表关联)
Property SVDiagnosDR As MRDiagnos [ SqlColumnNumber = 13, SqlFieldName = SV_DiagnosDR ];

/// SV_SignTable CA认证的表数据表名称-除医嘱相关操作目前都往这里存值
Property SVSignTable As %String [ SqlColumnNumber = 14, SqlFieldName = SV_SignTable ];

/// SV_SignTableID CA认证的表数据表RowID-除医嘱相关操作目前都往这里存值
Property SVSignTableID As %String [ SqlColumnNumber = 15, SqlFieldName = SV_SignTableID ];

Method SVOEORIMainGet() As %String
{
	Quit ""
}

Method SVOEORIMainSet(Arg As %String) As %Status
{
	Quit $$$OK
}

Storage CacheStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocSignVerify)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SV_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SV_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SV_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SV_DiagnosDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SV_DigitalSignature_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SV_OEORIMainInfo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SV_OEORIMainSignCert">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SV_OEORIMainSignTimeStamp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SV_OEORIMainSignValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SV_OEORIOtherSignRecord">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SV_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SV_OperationType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SV_SignTable">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SV_SignTableID">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCDocSignVerify</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SV_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SV_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDigitalSignature">
<Global>^DHCDocSignVerify</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SV_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DigitalSignature"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_DigitalSignature_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCDocSignVerify</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SV_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SV_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDocSignVerifyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
