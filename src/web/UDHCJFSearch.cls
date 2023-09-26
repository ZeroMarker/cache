Import sqluser

Class web.UDHCJFSearch Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

ClassMethod Getadminform(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatientID)
{
    k P1
    s sexdr="",sexdesc="",stname=""
	s maritaldr="",maritaldesc=""
	s age=0,mon=0,day=0
	s admdate=$zd(+$h,3)	 
	s papno=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s papname=$p(^PAPER(PatientID,"ALL"),"^",1)	
	&sql(select PAPMI_PAPER_DR,papmi_safetynetcardno into:paperdr,:cardno from pa_patmas where papmi_rowid=:PatientID)
	&sql(select paper_ageyr,paper_agemth,paper_ageday,paper_foreignaddress into:age,:mon,:day,:workst from pa_person where paper_rowid=:paperdr)	
	s stname=^PAPER(paperdr,"PER","ADD",1)
	i age=0  d
	.i mon=0  d
	..s admage=day_"天"
	.e  d
	..s admage=mon_"月"
	i age'=0  s admage=age
	s sexdr=$p(^PAPER(PatientID,"ALL"),"^",7)   ;性别
	i sexdr'=""  d
	.s sexdesc=$p(^CT("SEX",sexdr),"^",2)
	s telph=$p(^PAPER(paperdr,"PER",1),"^",11)   ;电话	
	i $d(^PAPER(paperdr,"PER",2))  d
	.s maritaldr=$p(^PAPER(paperdr,"PER",2),"^",3)   ;婚否
	.i maritaldr'=""  d
	..s maritaldesc=$p(^CT("MAR",maritaldr),"^",2)		
	s str=papno_"^"_papname_"^"_admdate_"^"_sexdesc_"^"_telph_"^"_maritaldesc_"^"_admage_"^"_stname_"^"_cardno_"^"_workst
	;s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    ;&javascript<#(retval)#>    
    s P1=str
    q P1
}

ClassMethod Getadminform1(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatientID, admdate)
{
    k P1
    s sexdr="",sexdesc="",stname=""
	s maritaldr="",maritaldesc=""
	s age=0,mon=0,day=0
	i admdate="" s admdate=$zd(+$h,3)
	s papno=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s papname=$p(^PAPER(PatientID,"ALL"),"^",1)	
	&sql(select PAPMI_PAPER_DR,papmi_safetynetcardno into:paperdr,:cardno from pa_patmas where papmi_rowid=:PatientID)
	&sql(select paper_ageyr,paper_agemth,paper_ageday,paper_foreignaddress into:age,:mon,:day,:workst from pa_person where paper_rowid=:paperdr)	
	s stname=^PAPER(paperdr,"PER","ADD",1)
	i age=0  d
	.i mon=0  d
	..s admage=day_"天"
	.e  d
	..s admage=mon_"月"
	i age'=0  s admage=age
	s sexdr=$p(^PAPER(PatientID,"ALL"),"^",7)   ;性别
	i sexdr'=""  d
	.s sexdesc=$p(^CT("SEX",sexdr),"^",2)
	s telph=$p(^PAPER(paperdr,"PER",1),"^",11)   ;电话	
	i $d(^PAPER(paperdr,"PER",2))  d
	.s maritaldr=$p(^PAPER(paperdr,"PER",2),"^",3)   ;婚否
	.i maritaldr'=""  d
	..s maritaldesc=$p(^CT("MAR",maritaldr),"^",2)		
	s str=papno_"^"_papname_"^"_admdate_"^"_sexdesc_"^"_telph_"^"_maritaldesc_"^"_admage_"^"_stname_"^"_cardno_"^"_workst
	;s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    ;&javascript<#(retval)#>    
    s P1=str
    q P1
}

ClassMethod PrintAdmInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", admid)
{
 
    s sexdr="",sexdesc="",stname=""
    s depid="",depname=""
	s maritaldr="",maritaldesc=""
	s age=0,mon=0,day=0
	s admdate=$zd(+$h,3)
	s PatientID=$p(^PAADM(admid),"^",1)
	s depcode=$p(^PAADM(admid),"^",4)
	i depcode'="" s depcode=$p(^CTLOC(depcode),"^",2)
	s depcode=$p(depcode,"-",2)
	s admdate=$p(^PAADM(admid),"^",6)
	i admdate'=""  s admdate=$zd(admdate,3)	 
	q:(PatientID="")
	q:($d(^PAPER(PatientID))=0)
	s patinfo=..Getadminform1("","",PatientID,admdate)
	
	s patinfo=patinfo_"^"_depcode
	q patinfo
	q
}

}
