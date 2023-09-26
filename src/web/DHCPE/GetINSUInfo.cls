Import SQLUser

Class web.DHCPE.GetINSUInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 193;

//d ##class(web.DHCPE.GetINSUInfo).GetDate("302")

ClassMethod GetTADate(PAADM)
{
  Q:PAADM="" "^^^^^^^^^^^^"
  s PGBIDR="",AdmDate="",SexDRName="09",Str="",PatName="",BookDateBegin="",Linkman1="",Tel1=""
  S IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0)) 
  q:IADM="" "^^^^^^^^^^^^"
  s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
  i AdmDate'=""  s AdmDate=$p(($zd(AdmDate,3)),"-",1)
  s CRMIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
  q:CRMIADM="" "^^^^^^^^^^^^"
  s PGADMDR=$p($g(^DHCPEIADM(IADM)),"^",2)
  i PGADMDR'=""  s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
  i PGBIDR'=""   d
  . s Linkman1=$p(^DHCPEPreGBI(PGBIDR),"^",5)
  . s Linkman2=$p(^DHCPEPreGBI(PGBIDR),"^",11) 
  . i Linkman1=""  s Linkman1=Linkman2
  . s Tel1=$p(^DHCPEPreGBI(PGBIDR),"^",8)
  . s Tel2=$p(^DHCPEPreGBI(PGBIDR),"^",9) 
  . i Tel1=""  s Tel1=Tel2 
  s PIBIID=$P(^DHCPEPreIADM(CRMIADM),"^",1)
  S BookDateBegin= $P(^DHCPEPreIADM(CRMIADM),"^",4)
  i BookDateBegin'=""  s BookDateBegin=$zd(BookDateBegin,3)
  S BookDateEnd= $P(^DHCPEPreIADM(CRMIADM),"^",5)
  Q:PIBIID=""
  S CurData=$g(^DHCPEPreIBI(PIBIID))
  s PatName=$p(CurData,"^",2)
  s SexDR=$p(CurData,"^",3)
  s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
  i SexDRName="男"  s SexDRName="01"
  i SexDRName="女"  s SexDRName="02"
  s PatID=$p(CurData,"^",9)
  s Dob=$p(CurData,"^",4)
  i Dob'="" s PAPERDob=$ZD(Dob,3)
  s PIBICompany=$p(CurData,"^",12)
  s Str=""_"^"_PatName_"^"_SexDRName_"^"_""_"^"_""_"^"_AdmDate_"^"_""_"^"_BookDateBegin_"^"_Linkman1_"^"_Tel1_"^"_"陈魏"_"^"_"张华"_"^"_""
  q Str
}

ClassMethod GetTBDate(PAADM)
{
  Q:PAADM="" "^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  s PGBIDR="",AdmDate="",AdmYear="",SexDRName="09",CheckFlag="02",DoctorName=""
  S IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0)) 
  q:IADM=""
  s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
  i AdmDate'=""  s AdmYear=$p(($zd(AdmDate,3)),"-",1)
  i AdmDate'=""  s AdmDate=$zd(AdmDate,3)
  s CRMIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
  q:CRMIADM=""
  s GSRowId=$o(^DHCPEGS(0,"IADM",IADM,0))
  s GSAuditUserDR=$p(^DHCPEGS(GSRowId,1),"^",5)
  i GSAuditUserDR'="" Set DoctorName=$p(^SSU("SSUSR",GSAuditUserDR),"^",2)
  s PGADMDR=$p($g(^DHCPEIADM(IADM)),"^",2)
  i PGADMDR'=""  s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
  s PIBIID=$P(^DHCPEPreIADM(CRMIADM),"^",1)
  Q:PIBIID=""
  S CurData=$g(^DHCPEPreIBI(PIBIID))
  s PatName=$p(CurData,"^",2)
  s SexDR=$p(CurData,"^",3)
  s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
  i SexDRName="男"  s SexDRName="01"
  i SexDRName="女"  s SexDRName="02"
  s PatID=$p(CurData,"^",9)
  s Dob=$p(CurData,"^",4)
  i Dob'="" s PAPERDob=$ZD(Dob,3)                              
  i $d(^DHCPERLT(0,"ADM",PAADM))  s CheckFlag="01"                                                  //参加体检标志                    //总检医生                                                                
  s Str=PAADM_"^"_PAADM_"^^"_PatName_"^"_SexDRName_"^"_PAPERDob_"^^^^^^^^"_AdmYear_"^^^"_CheckFlag_"^^^"_AdmDate_"^^^"_DoctorName_"^^^^"_"陈魏"_"^"_"张华"
}

ClassMethod GetTCDate(PAADM)
{
  Q:PAADM="" "^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  s PGBIDR="",AdmDate="",AdmYear="",SexDRName="09",CheckFlag="02",DoctorName=""
  S IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0)) 
  q:IADM=""
  s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
  i AdmDate'=""  s AdmYear=$p(($zd(AdmDate,3)),"-",1)
   i AdmDate'=""  s AdmDate=$zd(AdmDate,3)
  s CRMIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
  q:CRMIADM=""
  s GSRowId=$o(^DHCPEGS(0,"IADM",IADM,0))
  s GSAuditUserDR=$p(^DHCPEGS(GSRowId,1),"^",5)
  i GSAuditUserDR'="" Set DoctorName=$p(^SSU("SSUSR",GSAuditUserDR),"^",2)
  s PGADMDR=$p($g(^DHCPEIADM(IADM)),"^",2)
  i PGADMDR'=""  s PGBIDR=$p(^DHCPEPreGADM(PGADMDR),"^",1)
  s PIBIID=$P(^DHCPEPreIADM(CRMIADM),"^",1)
  Q:PIBIID=""
  S CurData=$g(^DHCPEPreIBI(PIBIID))
  s PatName=$p(CurData,"^",2)
  s SexDR=$p(CurData,"^",3)
  s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
  i SexDRName="男"  s SexDRName="01"
  i SexDRName="女"  s SexDRName="02"
  s PatID=$p(CurData,"^",9)
  s Dob=$p(CurData,"^",4)
  i Dob'="" s PAPERDob=$ZD(Dob,3)                              
  i $d(^DHCPERLT(0,"ADM",PAADM))  s CheckFlag="01"                                                  //参加体检标志                    //总检医生                                                                
  s Str=PAADM_"^"_PAADM_"^"_"保健号"_"^"_PatName_"^"_SexDRName_"^"_PAPERDob_"^^^^^^^^"_AdmYear_"^^^"_CheckFlag_"^^^"_AdmDate_"^^^"_DoctorName_"^^^^"_"陈魏"_"^"_"张华"
  q Str
}

ClassMethod GetTEDate(PAADM)
{
  Q:PAADM="" "^^^^^^"
  S AdmDate="",ODDesc=""
  s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
  i AdmDate'=""  s AdmDate=$zd(AdmDate,3)
  s RLTRowId=0
  f  s RLTRowId=$o(^DHCPERLT(0,"ADM",PAADM,RLTRowId))  q:RLTRowId=""  d
  .s ODDR=$p(^DHCPERLT(RLTRowId),"^",3)
  .q:ODDR=""
  .s ODDesc=$p(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2)),"^",1)
  .s Str=""_"^"_PAADM_"^"_ODDesc_"^^^"_AdmDate_"^"
  q Str
}

}
