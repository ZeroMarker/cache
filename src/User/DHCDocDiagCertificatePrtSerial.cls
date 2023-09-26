Class User.DHCDocDiagCertificatePrtSerial Extends %Persistent [ SqlTableName = DHC_DocDiagCertificatePrtSerial, StorageStrategy = NewStorage1 ]
{

Property DDCPDDCDR As User.DHCDocDiagnosCertificate [ SqlColumnNumber = 2, SqlFieldName = DDCP_DDC_DR ];

/// 打印json
Property DDCPDataJson As %String(COLLATION = "Exact", MAXLEN = 1000000) [ SqlColumnNumber = 3, SqlFieldName = DDCP_DataJson ];

/// 流水号
Property DDCPSerialNumber As %String [ Required, SqlColumnNumber = 4, SqlFieldName = DDCP_SerialNumber ];

Property DDCPCreatUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DDCP_CreatUser_Dr ];

Property DDCPCreatDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DDCP_CreatDate ];

Property DDCPCreatTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DDCP_CreatTime ];

Property DDCPLastUpdateUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DDCP_LastUpdateUser_Dr ];

Property DDCPLastUpdateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DDCP_LastUpdateDate ];

Property DDCPLastUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DDCP_LastUpdateTime ];

/// P 打印 U 打印记录已作废
Property DDCPStatus As %String [ SqlColumnNumber = 11, SqlFieldName = DDCP_Status ];

/// 当获取不到流水号时，根据处方号生成流水号,打印到处方上面
/// w ##Class(User.DHCDocDiagCertificatePrtSerial).InsertPrtSerial("1","{'HospName':'东华标准版数字化医院[总院]病情诊断证明书','AdmLoc':'内分泌科门诊','PatNo':'0000000011','PatName':'1448','PatSex':'女','PatAge':'30岁','DDCCompany':'','DiagnosDesc':'11111,胃肠型感冒','DDCDocNotes':'医生建议','DDCDaysOff':'10','DDCDaysRange':'11/11/2020 至21/11/2020','DDCNotes':'','PAAdmDoc':'医生01','PrintDate':'11/11/2020 17:07:38'}","12175")
ClassMethod InsertPrtSerial(DDCRowId As %String, PrintDataJson As %String, UserID As %String) As %String
{
	s ^temscpl("InsertPrtSerial")=DDCRowId_","_PrintDataJson_","_UserID
	TS
	s CurDate=+$h,CurTime=$P($H,",",2)
	&sql(update SQLUser.DHC_DocDiagCertificatePrtSerial set DDCP_Status="U", DDCP_LastUpdateUser_Dr=:UserID,DDCP_LastUpdateDate=:CurDate,DDCP_LastUpdateTime=:CurTime where DDCP_DDC_DR=:DDCRowId)
	s SerialNumber=$I(^DDPCPrt("Prt",+$H))
	s dt1=$zd(CurDate),mm=+dt1,yy=$p(dt1,"/",3)
	s yy1=$e(yy,3,4)
	s dt=$e($tr(dt1,"/"),1,4)
	s SerialNumber=yy1_dt_$e(1000000+SerialNumber,3,7)
	s SerialNumber="ZD"_SerialNumber
	kill PLIST
	s PLIST(2)=DDCRowId
	s PLIST(3)=PrintDataJson
	s PLIST(4)=SerialNumber
	s PLIST(5)=UserID
	s PLIST(6)=CurDate
	s PLIST(7)=CurTime
	s PLIST(8)=UserID
	s PLIST(9)=CurDate
	s PLIST(10)=CurTime
	s PLIST(11)="P"
	&sql(INSERT INTO SQLUser.DHC_DocDiagCertificatePrtSerial VALUES :PLIST())
	b 
	s err=SQLCODE
	i err {
		TRO
		Q ""
	}
	TC
	Q SerialNumber
}

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDOCDiagnosCertificatePrt(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DDCP_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCP_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDCP_CreatUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCP_DDC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCP_DataJson">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCP_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDCP_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDCP_LastUpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDCP_SerialNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCP_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCDOCDiagnosCertificatePrt</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDCP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDDCDr">
<Global>^DHCDOCDiagnosCertificatePrt</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDCP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DDC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDCP_DDC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocDiagC5666S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
