Class EPRservice.HISInterface.PAADM Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Property PaName As %Library.String(TRUNCATE = 1);

ClassMethod diagnos(mradm As %Library.String) As %Library.String
{
 ;mr_diagtype  ^MR({MR_Adm.MRADM_RowId},"DIA",{MR_Diagnos.MRDIA_Childsub},"TYP",{TYP_Childsub})                                                     
 ;^MRC("ID",{MRCID_RowId}) mrc_icddx
 s dc=0 f  s dc=$o(^MR(mradm,"DIA",dc)) q:dc=""  d
 .s ty=0 f  s ty=$O(^MR(mradm,"DIA",dc,"TYP",ty)) q:ty=""  d
 ..s tydr=$P(^MR(mradm,"DIA",dc,"TYP",ty),"^",1)
 ..s tydesc=$P(^MRC("DTYP",tydr),"^",2)
 ..w !,tydr
 ..i tydr=1 d  ;??????
 ...f de=1:1:$g(^MR(mradm,"DIA",dc,"DES",0)) d
 ....s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",dc,"DES",de)) ;
 ...s mcdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s mcicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:mcicd=""
 ...s mcstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s mcdes=$P(^MRC("ID",mcicd),"^",2)
 ...s mcicd10=$P(^MRC("ID",mcicd),"^",4)
 ...s mctyp=tydesc
 ..i tydr=3 d    ;??????
 ...s mrdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s mricd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...;i mricd'="" d icd10(mricd)
 ...q:mricd=""
 ...w !,"ddd"
 ...s mrstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s mrdes=$P(^MRC("ID",mricd),"^",2)
 ...s mricd10=$P(^MRC("ID",mricd),"^",1)
 ...s mrtyp=tydesc
 ..i tydr=12  d  ;"????????"
 ...s blicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:blicd=""
 ...s bldes=$P(^MRC("ID",blicd),"^",2)
 ...s blicd10=$P(^MRC("ID",blicd),"^",4)
 ...;i blicd10'="" d icd10(blicd10)
 ...;i $G(icd10)'=""  s blicd10=icd10
 ..i tydr=2  d  ;??????
 ...s mrdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s mqicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:mqicd=""
 ...s mqstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s mqdes=$P(^MRC("ID",mqicd),"^",2)
 ...s mqicd10=$P(^MRC("ID",mqicd),"^",4)
 ...s mqtyp=tydesc
 ..i tydr=6   d  ;????????
 ...s mjdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s mjicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:mjicd=""
 ...s mjstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s mjdes=$P(^MRC("ID",mjicd),"^",2)
 ...s mjicd10=$P(^MRC("ID",mjicd),"^",4)
 ...s mjtyp=tydesc
 ..i tydr=7 d    ;????????
 ...s yndiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s ynicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:ynicd=""
 ...s ynstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s yndes=$P(^MRC("ID",ynicd),"^",2)
 ...s ynicd10=$P(^MRC("ID",ynicd),"^",4)
 ...;i ynicd10'="" d icd10(ynicd10)
 ...;i $G(icd10)'=""  s ynicd10=icd10
 ...s yntyp=tydesc
 ..i tydr=11 d  ;????
 ...s szdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
 ...s szicd=$P(^MR(mradm,"DIA",dc),"^",1)
 ...q:szicd=""
 ...s szstat=$P(^MR(mradm,"DIA",dc),"^",9)
 ...s szdes=$P(^MRC("ID",szicd),"^",2)
 ...s szicd10=$P(^MRC("ID",szicd),"^",4)
 ...;i szicd10'="" d icd10(szicd10)
 ...;i $G(icd10)'=""  s szicd10=icd10
 ...s sztyp=tydesc
 ..;mrc_icddx
 .
 q $G(mjdes)_"^"_$G(mrdes)_"^"_$P($G(mcdes),"-",2)_"^"_$P($G(yndes),"-",2)_"^"_$P($G(szdes),"-",2)_"^"_$P($G(bldes),"-",2)
}

ClassMethod getDiagMsg(adm As %Library.String) As %Library.List
{
 k ^%msql

 s admdate=$P(^PAADM(adm),"^",6) ;????????
 s admdate=$zd(admdate,3)
 s admtime=$P(^PAADM(adm),"^",7)  ;????????
 s admtime=$zt(admtime,3)
 s dep=$P(^PAADM(adm),"^",4) ;????????
 s dep=$P(^CTLOC(dep),"^",2) 

 s deptAll=##Class(DHC.EPR.PaAdm).transdep(adm)
 s sdept=$p(deptAll,"^",1)
 s edept=$p(deptAll,"^",2)
 i sdep'="" s rdep=sdep    ;????????
 i edep'="" s cdep=dep     ;????????                                            
 e  s cdep=dep
 i rdep=cdep d
 .s zdep="??"
 e  d
 .s zdep=cdep ;????????

 s roomAll=##Class(DHC.EPR.PaAdm).transroom(adm)
 s room=eroom                     ;????????
 s sroom=sroom                    ;????????  

 s disdate=$P(^PAADM(adm),"^",17)    ;????????
 s distime=$P(^PAADM(adm),"^",18)
 s Duration=disdate-admdate           ;???????? 
 s disdate=$ZD(disdate,3)
 s distime=$zt(distime,3)

 s mradm=$P(^PAADM(adm),"^",61)
 s conrudr=$P(^MR(mradm,"PRO",1),"^",40)
 i conrudr'=""  s conru=$P(^MRC("COND",conrudr),"^",2)  ;??????????
 e  s conru=""
 ;;????????????????? 2003-07-24 qse
 s papmidr=$P(^PAADM(adm),"^",1)
 s diedate=$ZD($P(^PAPER(papmidr,"ALL"),"^",13),3)  
 s dietime=$ZT($P(^PAPER(papmidr,"ALL"),"^",8),3)  

 s diagAll=##Class(DHC.EPR.PaAdm).diagnos(adm)
 s mjdes=$p(diagAll,"^",1)             ;????????????
 ;s mrdes=$p(diagAll,"^",2)            ;??????????
 ;s mcdes=$p(diagAll,"^",3)             ;??????????
 ;s yndes=$p(diagAll,"^",4)             ;????????????
 ;s szdes=$p(diagAll,"^",5)             ;????????????????????
 ;s bldes=$p(diagAll,"^",6)             ;????????   

 set MQueryPat=$LB($LB(admdate,admtime,rdep,sroom,zdep,disdate,distime,cdep,eroom,mjdes,conru))
 q MQueryPat
}

ClassMethod getOper(adm As %Library.String) As %Library.List
{
 k ^%msql
 s MQueryPat=""
 s opeId=0 f  s opeId=$O(^opeschi(0,"ADM",adm,opeId))  q:opeId=""  d
 .s opeStatus=$p(^opesch(opeId),"^",28)
 .q:opeStatus'["????"
 .s opeDate=$zd($p(^opesch(opeId),"^",17),3)
 .s opeDesc=$p(^opesch(opeId),"^",21)
 .s opeDoc=$p(^opesch(opeId),"^",12)
 .s opeAssis1=$p(^opesch(opeId),"^",5)
 .s opeAssis2=$p(^opesch(opeId),"^",6)
 .s opeAnamed=$p(^opesch(opeId),"^",34)
 .s opeAnaDoc=$p($p(^opesch(opeId),"^",3),"?",1)
 .set MQueryPat=MQueryPat_$LB($LB(opeDate,opeDesc,opeDoc,opeAssis1,opeAssis2,opeAnamed,opeAnaDoc))
 q MQueryPat
}

ClassMethod getOtherDiag(mradm As %Library.String) As %Library.List
{
 ;MRC_DiagnosType   ;
 k ^%msql
 s i=0
 s a2=0 f  s a2=$O(^MR(mradm,"DIA",a2))  q:a2=""  d
 .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
 .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
 .s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;????????
 .i (" ?????????? "[diatype)!(" ???????????? "[diatype) d
 ..s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;????
 ..s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
 ..i statusdr'="" d
 ...s status=$P($g(^MRC("DSTAT",statusdr)),"^",2)
 ..e  d
 ...s status=""
 ..i icdr'="" s icdcode=$P($g(^MRC("ID",icdr)),"^",2) s icd9=$P($g(^MRC("ID",icdr)),"^",1)    ;????????
 ..e  s icdcode="" s icd9=""
 ..s mrdesc=""
 ..f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
 ...s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
 ..;i icd9'="" d icd10(icd9)
 ..i (" ?????????? "[diatype)  s P9=$G(sicd10)  ;??????????????2003-1-25 
 ..s i=i+1
 ..s PLIST(i)=diatype_"&&"_icdcode_" "_$g(mrdesc)_"&&"_date_"&&"_status_"&&"_icd9_"&&"_$G(icd9)
 .
 s PLIST=i
 q 0
}

ClassMethod icd10(icd9 As %Library.String) As %Library.String
{
 ;^MICD10(0,"ICD9",{ICD910_MICD9},{ICD910_ROWID})
 s icd10=""
 s rw=""  f  s rw=$O(^MICD10(0,"ICD9",icd9,rw))  q:rw=""  d
 .s icd10=$P(^ICD910(rw),"^",1)
 .s sicd10=$P(^ICD910(rw),"^",5)
 q sicd10
}

ClassMethod transdep(adm As %Library.String) As %Library.String
{
 s sdep="",edep=""
 &sql(declare TRANSCur cursor for  
 select  
 TRANS_CTLOC_DR->ctloc_desc
 FROM  SQLUser.PA_AdmTransaction 
 where TRANS_ParRef=:adm
 and trans_ctloc_dr is not null
 order by TRANS_StartDate,TRANS_STartTime ) 
 &sql(open TRANSCur)
 s i=0             ;   
 f  &sql(fetch TRANSCur into :ddep) q:SQLCODE  d
 .i i=0 d
 ..s sdep=ddep
 ..s edep=ddep
 .e   d
 ..s edep=ddep
 .s i=i+1
 i i=1 d
 .s edep=sdep
 i i=0 d
 .s err=1
 e   d
 .s err=0
 &sql(close TRANSCur)
 i sdep="" s sdepid=$P($g(^PAADM(adm)),"^",4) s sdep=$P(^CTLOC(sdepid),"^",2)
 i edep="" s edep=sdep
 q sdep_"^"_edep
}

ClassMethod transroom(adm As %Library.String) As %Library.String
{
 ;??????????
 &sql(declare TRANroom cursor for  
 select  distinct trans_room_dr
 FROM  SQLUser.PA_AdmTransaction 
 where TRANS_ParRef=:adm
 and trans_room_dr is not null
 order by TRANS_StartDate,TRANS_STartTime ) 
 &sql(open TRANroom)
 s i=0             ;   
 f  &sql(fetch TRANroom into :room) q:SQLCODE  d
 .i i=0 d
 ..s sroom=room
 .s i=i+1
 .s eroom=room
 i i=0 d
 .s sroom="??"
 .s eroom="??"
 &sql(close TRANroom)
 q sroom_"^"_eroom
}

}
