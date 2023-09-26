Class web.DHCOPCheckRegister Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CheckRegisterInfo(Name As %String = "", Sex As %String = "", Birth As %String = "") As %String
{
  s ^gry("CheckRegisterInfo")=Name_"^"_Sex_"^"_Birth
  q:(Name="")||(Birth="")
  s Name=$ZCVT(Name,"U")
  s Birth=$zdh(Birth,3)
  s sexx=""
  s paperrowid=""
  s find=1
  f  s paperrowid=$o(^PAPERi("PAPER_PatName",Name,paperrowid)) q:(paperrowid="")||(find'<2)  d
  .s sexxid=$p(^PAPER(paperrowid,"ALL"),"^",7)
  .s sexx=$p(^CT("SEX",sexxid),"^",2)
  .q:sexx'=Sex
  .s dob=$p(^PAPER(paperrowid,"ALL"),"^",6)
  .q:dob'=Birth
  .s find=find+1
  q find
}

ClassMethod CheckPatCredNo(CredNo As %String = "")
{
	q:CredNo=""
	s find=1
	s PatMasRowid=""
	f  s PatMasRowid=$o(^PAPERi("DVA",CredNo,PatMasRowid)) q:(PatMasRowid="")||(find'<2)  d
	.s Dvanumble=$p(^PAPER(PatMasRowid,"PAT",3),"^",6)
	.i Dvanumble=CredNo s find=find+1
	.q:find'<2
	q find
}

ClassMethod CheckPatYBCodeNo(YBCodeNo As %String = "")
{
	s Str=""
	q:YBCodeNo="" ""
	q:(YBCodeNo="99999999999S")||(YBCodeNo="99999999999s") ""
	s find=1
	s PatMasRowid=""
	f  s PatMasRowid=$o(^PAPERi("PAPER_YBCode",YBCodeNo,PatMasRowid)) q:(PatMasRowid="")  d
	.s PatName=$p(^PAPER(PatMasRowid,"ALL"),"^",1)
	.s PatSexDR=$p(^PAPER(PatMasRowid,"ALL"),"^",7)
	.s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
	.s PatBirth=$p(^PAPER(PatMasRowid,"ALL"),"^",6)
	.s CardNo=$o(^DHCCARDi("CF",0,"PAPMIDR",PatMasRowid,""))
	.i Str="" d
	..s Str=CardNo_"^"_PatName_"^"_PatSex_"^"_$zd(PatBirth,3)
	.e  d
	..s Str=Str_"!"_CardNo_"^"_PatName_"^"_PatSex_"^"_$zd(PatBirth,3)
	.s find=find+1
	
	q Str_"$"_find
}

}
