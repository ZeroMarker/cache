Import SQLUser

/// 体温单打印记录
/// web.DHCADMQTREC
Class web.DHCTEMPPRINT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod PrintFlag(Adm As %String) As %String
{
	s flag=0
	s AdmDate=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.if Typ="入院" s AdmDate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	if AdmDate="" s AdmDate=$p(^PAADM(Adm),"^",6)
    s num1=($h-AdmDate)/7
    s num2=($h-AdmDate)\7
    if ((num1=num2)&&(num1'=0)) d
    .s Page=0
    .s RowId="" f  s RowId=$O(^DHCTEMPPRINT(0,"adm",Adm,RowId)) q:(RowId="")||(Page=num2)  d
    ..s Page=$P(^DHCTEMPPRINT(RowId),"^",4)
    .if Page'=num2 s flag=num2
    q flag
}

ClassMethod InsertPrintPage(Adm As %String, UserDr As %String, Page As %String) As %String
{
    s PLIST(2)=Adm
  	s PLIST(3)=$P($h,",",1)
  	s PLIST(4)=$P($h,",",2)
  	s PLIST(5)=Page
  	s PLIST(6)=UserDr
  	s PLIST(7)="Y"
  	s PrintPage=0
  	s RowId="" f  s RowId=$O(^DHCTEMPPRINT(0,"adm",Adm,RowId)) q:(RowId="")||(PrintPage=Page)  d
  	.s PrintPage=$P(^DHCTEMPPRINT(RowId),"^",4)
  	if PrintPage'=Page d
  	.&sql(insert into DHC_TEMPPRINT values PLIST())
  	q 0
}

}
