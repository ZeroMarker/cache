/// 医嘱项 使用限制
Class User.DHCArcItemAut Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AUT_RowID, SqlTableName = DHC_ArcItemAut, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (AUTARCIMSubscript, AUTARCIMVersion, AUTChildsub) [ IdKey, PrimaryKey, Unique ];

/// AUT_ARCIMSubscript
Property AUTARCIMSubscript As %Library.Float [ Required, SqlColumnNumber = 2, SqlFieldName = AUT_ARCIMSubscript ];

/// AUT_ARCIMVersion
Property AUTARCIMVersion As %Library.Float [ Required, SqlColumnNumber = 3, SqlFieldName = AUT_ARCIMVersion ];

/// AUT_Childsub
Property AUTChildsub As %Library.Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"DHCAUT",0))}, SqlColumnNumber = 4, SqlFieldName = AUT_Childsub ];

/// AUT_Relation
Property AUTRelation As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "25.0000%", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AUT_Relation ];

/// AUT_Type
Property AUTType As %Library.String(DISPLAYLIST = ",CTLOC,CTCPT,SSUSR,CTEMF,AdmReason,PAT,HOSP", MAXLEN = 5, SELECTIVITY = "25.0000%", VALUELIST = ",KS,ZC,YS,JB,AR,BR,HP") [ SqlColumnNumber = 6, SqlFieldName = AUT_Type ];

/// AUT_Operate
Property AUTOperate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AUT_Operate ];

/// AUT_Pointer
Property AUTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AUT_Pointer ];

/// AUT_Qty
Property AUTQty As %Float [ SqlColumnNumber = 9, SqlFieldName = AUT_Qty ];

/// 药房
Property AUTDeptdr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = AUT_Deptdr ];

/// 限制原因
Property AUTReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AUT_Reason ];

/// 操作人
Property AUTAddUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = AUT_AddUser_Dr ];

/// 操作日期
Property AUTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AUT_Date ];

/// 操作时间
Property AUTTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = AUT_Time ];

/// 管控级别: Warn警示, Control管控, Stat统计
Property AUTManage As %String(DISPLAYLIST = ",Warn,Control,Stat", VALUELIST = ",W,C,S") [ SqlColumnNumber = 15, SqlFieldName = AUT_Manage ];

/// 关联的主记录
Property AUTAUTDr As User.DHCArcItemAut [ SqlColumnNumber = 16, SqlFieldName = AUT_AUT_Dr ];

/// 已经消耗数
Property AUTConQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = AUT_ConQty ];

/// 关联主记录：AUT_AUT_Dr
Storage SQLStorage
{
<Description>
<![CDATA[关联主记录：AUT_AUT_Dr]]></Description>
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^mdata("DHCArcItemAut"))</SqlIdExpression>
<SQLMap name="DataMasterAUT">
<Data name="AUT_AUT_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AUT_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AUT_ConQty">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AUT_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AUT_Deptdr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AUT_Manage">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AUT_Operate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUT_Reason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AUT_Relation">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUT_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AUT_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AUT_ARCIMSubscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>AUT_ARCIMVersion</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>AUT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AUT_ARCIMSubscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AUT_ARCIMVersion}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DHCAUT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUT_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCArcItemAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
