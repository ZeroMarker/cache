Import SQLUser

Class web.UDHCJFPBNoLock Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 12;

ClassMethod CLOSE()
{
	k ROW
	q 0
}

ClassMethod DELETE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE %NOLOCK %NOCHECK FROM DHC_PatientBill WHERE PB_RowId= :RowId)
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
	K PLIST(1)
	S PLIST(20)=+$H,PLIST(21)=+$P($H,",",2)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT %NOLOCK %NOCHECK INTO DHC_PatientBill Values PLIST())
	d ..tc()
	;
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod OPEN(ADM)
{
	;
	i '$d(^DHCPB(0,"ADM",ADM)) s SQLCODE=100
	e  s ROW="",SQLCODE=0
	q SQLCODE
}

ClassMethod PBDEL(RowId)
{
	n (RowId)
	;&SQL(DELETE FROM DHC_PatBillDetails Where PBD_PBO_ParRef->PBO_PB_ParRef= :RowId)
	;q:SQLCODE SQLCODE
	;&SQL(DELETE FROM DHC_PatBillOrder Where PBO_PB_ParRef= :RowId)
	;q:SQLCODE SQLCODE
	&SQL(DELETE %NOLOCK %NOCHECK FROM DHC_PatientBill Where PB_RowId=:RowId)
	q SQLCODE
}

ClassMethod PBINS(adm, user)
{
	n (adm,user)
	;Set Config=##Class(websys.Configuration).%OpenId(1)
    ;Set MEDDATA=Config.DataNamespace       ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
    ;Set LABDATA=Config.LabDataNamespace    ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
    ;Set CurrentNS=$ZNSPACE                 ;保存当前所用的NameSpace 
	;ZN MEDDATA
	;s err=$$select^MVBPAADM(adm) ; q:err err 
	;ZN CurrentNS 
	Set err=1
	&sql(select %NOLOCK  * into:PLIST() from Pa_Adm  where paadm_rowid=:adm)
	Quit:SQLCODE err_"^"
	i $d(PLIST) m PAADM=PLIST
	k PLIST
	s PLIST(2)=adm
	s PLIST(3)=$p($g(PAADM(7)),$c(1))
	s PLIST(4)=$p($g(PAADM(22)),$c(1))
	s PLIST(5)=$p($g(PAADM(181)),$c(1))
	s PLIST(6)=$p($g(PAADM(180)),$c(1))
	s PLIST(17)="B"
	s PLIST(22)=$g(user)
	s err=..INSERT()
	i 'err q err_"^"_PLIST(1)
	q err
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT %NOLOCK * INTO PLIST() FROM DHC_PatientBill WHERE PB_RowId= :RowId) 
	s PLIST=$o(PLIST(""),-1)
 
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE %NOLOCK %NOCHECK DHC_PatientBill VALUES PLIST() WHERE PB_RowId= :RowId)
	d ..tc()
	;
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
