Class User.DHCADMQTREC Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QTREC_ROWID, SqlTableName = DHC_ADMQTREC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// QTREC_ADM_DR
Property QTRECADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = QTREC_ADM_DR ];

/// QTREC_DATE
Property QTRECDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = QTREC_DATE ];

/// QTREC_TIME
Property QTRECTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = QTREC_TIME ];

/// QTREC_TYP_DR
Property QTRECTYPDR As User.DHCQTRECTYP [ SqlColumnNumber = 5, SqlFieldName = QTREC_TYP_DR ];

/// QTREC_LRDATE
Property QTRECLRDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = QTREC_LRDATE ];

/// QTREC_LRTIME
Property QTRECLRTIME As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = QTREC_LRTIME ];

/// QTREC_USR_DR
Property QTRECUSRDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = QTREC_USR_DR ];

/// QTREC_ORDER_DR
Property QTRECORDERDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = QTREC_ORDER_DR ];

/// QTREC_VOIDFLAG，作废标识
Property QTRECVOIDFLAG As %Library.String(TRUNCATE = 1, VALUELIST = ",1") [ SqlColumnNumber = 10, SqlFieldName = QTREC_VOIDFLAG ];

/// This trigger updates the LogTable after every insert
Trigger LogEvent [ Event = INSERT, Time = AFTER ]
{
	// get row id of inserted row
#;	n id,SQLCODE,%msg,%ok,%oper
	s id = {QTREC_ROWID}
	d ##class(Nur.NIS.Service.Trace.Manage).AddPatientTraceByEvent(id)
}

Trigger DelEvent [ Event = DELETE, Time = AFTER ]
{
#;	n id,SQLCODE,%msg,%ok,%oper
	s id = {QTREC_ROWID}
	d ##class(Nur.NIS.Service.Trace.Manage).VoidPatientTraceByEvent(id)
}

Trigger UpdateEvent [ Event = UPDATE, Time = AFTER ]
{
#;	n id,SQLCODE,%msg,%ok,%oper
	s id = {QTREC_ROWID}
    i 1=$p($g(^DHCADMQTREC("QTREC",id)),"^",9) {
        d ##class(Nur.NIS.Service.Trace.Manage).VoidPatientTraceByEvent(id)
    }
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCADMQTREC("QTREC"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QTREC_ADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTREC_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QTREC_LRDATE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QTREC_LRTIME">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QTREC_ORDER_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QTREC_TIME">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QTREC_TYP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QTREC_USR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QTREC_VOIDFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCADMQTREC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QTREC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QTREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QTREC_ROWID}</Expression>
<StartValue>0</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexadm">
<Global>^DHCADMQTREC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>QTREC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QTREC_ADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QTREC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexadmTime">
<Global>^DHCADMQTREC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"admTime"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QTREC_ADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QTREC_DATE}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QTREC_TIME}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QTREC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexadmTyp">
<Global>^DHCADMQTREC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"admTyp"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QTREC_ADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QTREC_TYP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QTREC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCADMQTRECS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
