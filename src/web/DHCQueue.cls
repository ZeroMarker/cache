Include webimport

IncludeGenerator webimport

Class web.DHCQueue Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 396;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

ClassMethod Fadd(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
 s sadd=""		
 s add=""
 s na=""  
 &sql(select ctpcp_smcno,ctpcp_carprvtp_dr->ctcpt_desc into :add,:zc from SQLUser.ct_careprov
 where ctpcp_rowid1=:rowid ) 
 s sadd=add_"@"_zc ;_na
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(sadd,"O","JS")_"');"
 .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(sadd,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

ClassMethod ghClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ghExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod ghExecute(ByRef QHandle As %Binary, da, SuseID, Syn, Ghuse) As %Status
{
 ;New repid, ind
	;New CTCode,CTDesc    stdate As %Library.Date,
	k ^REGTMP
 s ^XINTMP=da_"^"_SuseID_"^"_Syn_"^"_Ghuse
 Set repid=$I(^CacheTemp)
	s ind=1
	s i=1
	;i Ghuse="" d 
	.;s Ghuse="tttt"
 i da="" Set QHandle=$lb(0,repid,0) Quit $$$OK
 s da=$ZDH(da,4)
 s PaadmRowid=0 f  s PaadmRowid=$o(^PAADMi("PAADM_AdmDate",da,PaadmRowid)) q:PaadmRowid=""  d 
	 .if Syn="1" d
	 ..s createuser=$p($g(^PAADM(PaadmRowid)),"^",43) ;pa_adm.PAADM_CreateUser
 .e  d
 ..s createuser=$p($g(^PAADM(PaadmRowid,2)),"^",69) 

 .i Ghuse'="" d  
 ..i Syn="1" d
	 ...i createuser=SuseID d
	 ....s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20) ;pa_adm.paadm_VisitStatus
	 ....i VisitStatus="A" d
	 .....s depcode=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.paadm_depcode_dr
	 .....s depdesc=$p($g(^CTLOC(depcode)),"^",2) ;pa_adm.paadm_depcode_dr->ctloc_desc
	 .....s doccode=$p($g(^PAADM(PaadmRowid)),"^",9) ;a_adm.paadm_admdoccodedr
	 .....s docdesc=$p($g(^CTPCP(doccode,1)),"^",2) ;pa_adm.paadm_admdoccodedr->ctpcp_desc
	 .....s rowid=PaadmRowid
	 .....s nname=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 .....q:$g(createuser)=""
	 .....q:'$d(^SSU("SSUSR",createuser))
	 .....s no=$p($g(^SSU("SSUSR",createuser)),"^",1) ;ss_user.ssusr_initials
	 .....s name=$p($g(^SSU("SSUSR",createuser)),"^",2) ;ss_user.ssusr_name
	 .....s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
	 .....s udate=$p($g(^PAADM(PaadmRowid,1)),"^",42) ;paadm.paadm_updatedate          
	 .....s utime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
	 .....s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
	 .....s patname=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	 .....s papmino=$p($g(^PAPER(papmidr,"PAT",1)),"^",1)
	 .....s Admi=" "_PaadmRowid
	 .....s k=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 .....i k'="" d
	 ......s ff=$List(^User.DHCRegistrationFeeD(k),4)
	 ......s ^REGTMP(depcode,doccode,rowid)=depcode_"!"_depdesc_"!"_doccode_"!"_docdesc_"!"_rowid_"!"_no_"!"_name_"!"_$zt(time,1)_"!"_nname_"!"_$zd($p(udate,$c(1)),3)_"!"_$zt(utime,1)_"!"_papmino_"!"_patname_"!"_ff
	 ......s i=i+1

	 ..i Syn="0" d
	 ...i createuser=Ghuse d
	 ....s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20) ;pa_adm.paadm_VisitStatus
	 ....i VisitStatus="C" d
	 .....s depcode=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.paadm_depcode_dr
	 .....s depdesc=$p($g(^CTLOC(depcode)),"^",2) ;pa_adm.paadm_depcode_dr->ctloc_desc
	 .....s doccode=$p($g(^PAADM(PaadmRowid)),"^",9) ;a_adm.paadm_admdoccodedr
	 .....s docdesc=$p($g(^CTPCP(doccode,1)),"^",2) ;pa_adm.paadm_admdoccodedr->ctpcp_desc
	 .....s rowid=PaadmRowid
	 .....s nname=$p($g(^PAADM(PaadmRowid)),"^",43) ;paadm
	 .....q:nname=""
	 .....q:'$d(^SSU("SSUSR",nname))
	 .....s no=$p($g(^SSU("SSUSR",nname)),"^",1) ;ss_user.ssusr_initials
	 .....s name=$p($g(^SSU("SSUSR",nname)),"^",2) ;ss_user.ssusr_name
	 .....s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
	 .....s udate=$p($g(^PAADM(PaadmRowid,1)),"^",42) ;paadm.paadm_updatedate              
	 .....s utime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
	 .....s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
	 .....s patname=$p($g(^PAPER(papmidr,"ALL")),"^",1) 
	 .....s papmino=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) 
	 .....s Admi=" "_PaadmRowid
	 .....s k=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 .....i k'="" d
	 ......s ff=$List(^User.DHCRegistrationFeeD(k),4)
	 ......s ^REGTMP(depcode,doccode,rowid)=depcode_"!"_depdesc_"!"_doccode_"!"_docdesc_"!"_rowid_"!"_no_"!"_name_"!"_$zt(time,1)_"!"_createuser_"!"_$zd($p(udate,$c(1)),3)_"!"_$zt(utime,1)_"!"_papmino_"!"_patname_"!"_ff
	 ......s i=i+1
	 .i Ghuse="" d

 ..i Syn="1" d

	 ...s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20) ;pa_adm.paadm_VisitStatus
	 ...i VisitStatus="A" d
	 ....s depcode=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.paadm_depcode_dr
	 ....s depdesc=$p($g(^CTLOC(depcode)),"^",2) ;pa_adm.paadm_depcode_dr->ctloc_desc
	 ....s doccode=$p($g(^PAADM(PaadmRowid)),"^",9) ;a_adm.paadm_admdoccodedr
	 ....s docdesc=$p($g(^CTPCP(doccode,1)),"^",2) ;pa_adm.paadm_admdoccodedr->ctpcp_desc
	 ....s rowid=PaadmRowid
	 ....s nname=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 ....q:createuser=""
	 ....q:'$D(^SSU("SSUSR",createuser))
	 ....s no=$p($g(^SSU("SSUSR",createuser)),"^",1) ;ss_user.ssusr_initials
	 
	 ....s name=$p($g(^SSU("SSUSR",createuser)),"^",2) ;ss_user.ssusr_name
	 ....s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
	 ....s udate=$p($g(^PAADM(PaadmRowid,1)),"^",42) ;paadm.paadm_updatedate          
	 ....s utime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
	 ....s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
	 ....s patname=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	 ....s papmino=$p($g(^PAPER(papmidr,"PAT",1)),"^",1)
	 ....s Admi=" "_PaadmRowid
	 ....s k=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ....if k'="" d
	 .....s ff=$List(^User.DHCRegistrationFeeD(k),4)
	 .....s ^REGTMP(depcode,doccode,rowid)=depcode_"!"_depdesc_"!"_doccode_"!"_docdesc_"!"_rowid_"!"_no_"!"_name_"!"_$zt(time,1)_"!"_nname_"!"_$zd($p(udate,$c(1)),3)_"!"_$zt(utime,1)_"!"_papmino_"!"_patname_"!"_ff
	 .....s i=i+1
	 ..i Syn="0" d
	 
	 ...s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20) ;pa_adm.paadm_VisitStatus
	 ...i VisitStatus="C" d
	 ....s depcode=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.paadm_depcode_dr
	 ....s depdesc=$p($g(^CTLOC(depcode)),"^",2) ;pa_adm.paadm_depcode_dr->ctloc_desc
	 ....s doccode=$p($g(^PAADM(PaadmRowid)),"^",9) ;a_adm.paadm_admdoccodedr
	 ....s docdesc=$p($g(^CTPCP(doccode,1)),"^",2) ;pa_adm.paadm_admdoccodedr->ctpcp_desc
	 ....s rowid=PaadmRowid
	 ....s nname=$p($g(^PAADM(PaadmRowid)),"^",43) ;paadm
	 ....q:nname=""
	 ....q:'$d(^SSU("SSUSR",nname))
	 ....s no=$p($g(^SSU("SSUSR",nname)),"^",1) ;ss_user.ssusr_initials
	 ....s name=$p($g(^SSU("SSUSR",nname)),"^",2) ;ss_user.ssusr_name
	 ....s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
	 ....s udate=$p($g(^PAADM(PaadmRowid,1)),"^",42) ;paadm.paadm_updatedate              
	 ....s utime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
	 ....s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
	 ....s patname=$p($g(^PAPER(papmidr,"ALL")),"^",1) 
	 ....s papmino=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) 
	 ....s Admi=" "_PaadmRowid
	 ....s k=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ....if k'="" d
	 .....s ff=$List(^User.DHCRegistrationFeeD(k),4)
	 .....s ^REGTMP(depcode,doccode,rowid)=depcode_"!"_depdesc_"!"_doccode_"!"_docdesc_"!"_rowid_"!"_no_"!"_name_"!"_$zt(time,1)_"!"_createuser_"!"_$zd($p(udate,$c(1)),3)_"!"_$zt(utime,1)_"!"_papmino_"!"_patname_"!"_ff
	 .....s i=i+1
	 ;
	 s j=0
	 s depcodeid=0 f  s depcodeid=$o(^REGTMP(depcodeid)) q:depcodeid=""  d
	 .s doccodeid=0 f  s doccodeid=$o(^REGTMP(depcodeid,doccodeid))  q:doccodeid=""  d
	 ..s rowidid=0 f  s rowidid=$o(^REGTMP(depcodeid,doccodeid,rowidid))  q:rowidid=""  d
	 ...s Sdepcode=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",1)
	 ...s Sdep=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",2)
	 ...s Sdoccode=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",3)
	 ...s Sdoc=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",4)
	 ...s Srid=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",5)
	 ...s Suseid=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",6)
	 ...s Susename=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",7)
	 ...s Sdate=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",8)
	 ...s Stusename=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",9)
	 ...s Stdate=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",10)
	 ...i Stdate="1840-12-31" d  s Stdate=""
	 ...s Sttime=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",11)
	 ...s Sperid=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",12)
	 ...s Spername=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",13)
	 ...s ff=$p($g(^REGTMP(depcodeid,doccodeid,rowidid)),"!",14)
	 ...;s ^tenyn=Sdepcode_"^"_Sdep ;_"^"_name_"^"_time_"^"_udate_"^"_utime_"^"_papmidr_"^"_patname_"^"_papmino

	 ...Do OutputRow
	 ...;s j=j+1
	 ...;s mPLIST=j
	 ...;s mPLIST(j)=$g(^REGTMP(depcodeid,doccodeid,rowidid))
	 
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 ;w !Sdepcode_"!"_Sdep
 set Total=i-1
	set Data=$lb(Sdepcode,Sdep,Sdoccode,Sdoc,Srid,Suseid,Susename,Sdate,Stusename,Stdate,Sttime,Sperid,Spername,ff,Total)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
 ;ResetVariables
	;set (Sdepcode,Sdep,Sdoccode,Sdoc,Srid,Suseid,Susename,Sdate,Stusename,Stdate,Sttime,Sperid,Spername)=""
	;quit
}

ClassMethod ghFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ghExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod inperson(itmjs As %Library.String = "", itmjsex As %Library.String = "", uid As %Library.String = "", yno As %Library.String = "")
{
 Set AdmDate=+$H,AdmTime=$P($H,",",2)		
 &sql(insert into SQLUSER.PA_Person
	 (paper_ageday,paper_agemth,paper_ageyr,
	  paper_langprim_dr,paper_dob,paper_name,
	  paper_sex_dr,paper_age,paper_userupdate,paper_soundex1,
	  paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	  paper_useradded_dr,paper_incompleteregistration)
	  values("","","","2","60124","未用","3","|||||||||||0|0|0","2","未用00",
	  :AdmDate,:AdmTime,"N",:AdmDate,:uid,"N")) 
 i SQLCODE=0 d
 .s mid=^PAPER(0)   //人的最大id
 .i $d(^PAPER(0,"CNT","I")) d
 . .s mno=^PAPER(0,"CNT","I") //最大登记号
 .e  d
 ..s mno=0
 .s ^PAPER(0,"CNT","I")=mno+1
 .s mn=mno+1

 .s count=8-$l(mno+1)
 .;s ^tenyn=SQLCODE_"^"_mn_"^"_count
 .f i=0:1:count-1 d
 ..s mn = "0"_mn
 ..  &sql(update SQLUSER.pa_patmas
	                  set papmi_No=:mn,
	                      papmi_ipno=:mn,
	                      papmi_opno=:mn
	                where papmi_rowid=:mid
	              )
 .if yno="1"  d
 ..&sql(insert into SQLUSER.DHC_cardref (cf_cardno,cf_papmi_dr,cf_papmino) 
 values(:mn,:mid,:mn))
 .e  d
 ..&sql(insert into SQLUSER.DHC_cardref (cf_papmi_dr,cf_papmino) 
 values(:mid,:mn))      	                 
 .s retval=itmjs_"('"_$ZCVT(mid,"O","JS")_"');"
 .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(mid,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

ClassMethod inperson2(itmjs As %Library.String = "", itmjsex As %Library.String = "", uid As %Library.String = "", yno As %Library.String = "")
{
 s j=1
 f j=1:1:100000  d
 .
 .Set AdmDate=+$H,AdmTime=$P($H,",",2)		
 .&sql(insert into SQLUSER.PA_Person
	 (paper_ageday,paper_agemth,paper_ageyr,
	  paper_langprim_dr,paper_dob,paper_name,
	  paper_sex_dr,paper_age,paper_userupdate,paper_soundex1,
	  paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	  paper_useradded_dr,paper_incompleteregistration)
	  values("","","","2","60124","未用","3","|||||||||||0|0|0","2","未用00",
	  :AdmDate,:AdmTime,"N",:AdmDate,:uid,"N")) 
 .i SQLCODE=0 d
 ..s mid=^PAPER(0)   //人的最大id
 ..i $d(^PAPER(0,"CNT","I")) d
 .. .s mno=^PAPER(0,"CNT","I") //最大登记号
 ..e  d
 ...s mno=0
 ..s ^PAPER(0,"CNT","I")=mno+1
 ..s mn=mno+1

 ..s count=8-$l(mno+1)
 ..;s ^tenyn=SQLCODE_"^"_mn_"^"_count
 ..f i=0:1:count-1 d
 ...s mn = "0"_mn
 ...  &sql(update SQLUSER.pa_patmas
	                  set papmi_No=:mn,
	                      papmi_ipno=:mn,
	                      papmi_opno=:mn
	                where papmi_rowid=:mid
	              )
 ..if yno="1"  d
 ...&sql(insert into SQLUSER.DHC_cardref (cf_cardno,cf_papmi_dr,cf_papmino) 
 values(:mn,:mid,:mn))
 ..e  d
 ...&sql(insert into SQLUSER.DHC_cardref (cf_papmi_dr,cf_papmino) 
 values(:mid,:mn))      	                 
 ..;s retval=itmjs_"('"_$ZCVT(mid,"O","JS")_"');"
 ..;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(mid,"O","JS")_"');"
 ..;&javascript<#(retval)#>
 q 1
}

ClassMethod spno(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
 if $d(^PAPER(0,"CNT","I")) d
 . s aa=^PAPER(0,"CNT","I")
 e  s aa=1
 s retval=itmjs_"('"_$ZCVT(aa,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(aa,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod updatequ(itmjs As %Library.String = "", itmjsex As %Library.String = "", st As %Library.String = "", rowid As %Library.String = "")
{
 s ccode=""		
 &sql(update SQLUser.DHCQueue
 set QueStateDr=:st
 where id=:rowid) 
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

Query UFind(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%Integer,Code:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR  FROM SQLUSER.RB_RESOURCE
 WHERE (RES_CTLOC_DR = :depid )
}

Query UFindQueue(loc, docid, stid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "TQueNo:%String,TQuePersonId:%String,TQueName:%String,TQueRoomname:%String,Tlocname:%String,Tmarkname:%String,Tdocname:%String,Troomid:%String,Tlocid:%String,Tmarkid:%String,Tdocid:%String,Tstname:%String,Tfiname:%String,Tstid:%String,Tfiid:%String,Tid:%String")
{
SELECT QueNo,QuePersonId,QueName,QueRoomDr->ExarName,
CTLOC_DESC,RES_Desc,CTPCP_DESC,QueRoomDr,QueDepDr,QueMarkDr,
QueDocDr,QueStateDr->PersName,QueFirstDr->FirstcName,QueStateDr,QueFirstDr,ID
FROM SQLUser.DHCQueue,SQLUser.CT_LOC,SQLUser.RB_Resource,SQLUser.CT_CareProv
where (SQLUser.CT_LOC.CTLOC_ROWID=SQLUser.DHCQueue.QueDepDr and 
SQLUser.RB_Resource.RES_RowID=SQLUser.DHCQueue.QueMarkDr and 
SQLUser.CT_CareProv.CTPCP_ROWID=SQLUser.DHCQueue.QueDocDr
and SQLUser.DHCQueue.QueDepDr %startswith :loc 
and SQLUser.DHCQueue.QueDocDr %startswith :docid
and SQLUser.DHCQueue.QueStateDr %startswith :stid)
}

Query gh(da, SuseID, Syn, Ghuse) As %Query(ROWSPEC = "Tdepcode:%String,Tdep:%String,Tdoccode:%String,Tdoc:%String,Trid:%String,Tuseid:%String,Tusename:%String,Tdate:%String,Ttusename:%String,Ttdate:%String,Tttime:%String,Tperid:%String,Tpername:%String,Tff:%String,Total:%String")
{
}

}
