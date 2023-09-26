Import SQLUser

Class web.UDHCJFPB Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_PatientBill WHERE PB_RowId= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod FETCH(ADM)
{
	i $d(ROW) d
	.s ROW=$o(^DHCPB(0,"ADM",ADM,ROW))
	.s SQLCODE=..SELECT(ROW)
	e  s SQLCODE=100
	q SQLCODE
}

ClassMethod INSERT()
{
	k PLIST(1)
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_PatientBill VALUES PLIST())
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod OPEN(ADM)
{
	i '$d(^DHCPB(0,"ADM",ADM)) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
}

ClassMethod PBDEL(RowId)
{
	n (RowId)
	&SQL(DELETE FROM DHC_PatientBill WHERE PB_RowId=:RowId)
	q SQLCODE
}

/// Debug: w ##class(web.UDHCJFPB).PBINS(1287, 5)
ClassMethod PBINS(adm As %String, userId As %String) As %String
{
	new (adm, userId)
	
	set rtn=0
	set admDate=$p($g(^PAADM(adm)),"^",6)            //PAADM_AdmDate
	set dischgDate=$p($g(^PAADM(adm)),"^",17)        //PAADM_DischgDate
	set insTypeDR=$p($g(^PAADM(adm,1)),"^",7)        //PAADM_AdmReason_DR
	set episSubTypeDR=$p($g(^PAADM(adm,1)),"^",6)    //PAADM_Epissubtype_DR
	
	ts
	
	&SQL(
		INSERT DHC_PatientBill (
			PB_Adm_Dr, PB_AdmDate, PB_DisChargeDate, PB_PatInsType_DR, PB_PatAdmType_DR,
			PB_PayedFlag, PB_UpdateUser
		)
		VALUES (
			:adm, :admDate, :dischgDate, :insTypeDR, :episSubTypeDR,
			'B', :userId
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn_"^"_$g(%ROWID)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_PatientBill WHERE PB_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

/// w ##class(web.UDHCJFPB).UPDATE(23086)
ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_PatientBill VALUES PLIST() WHERE PB_RowId= :RowId)
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod tb()
{
 	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
