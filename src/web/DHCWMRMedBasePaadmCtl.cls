Import SQLUser

Class web.DHCWMRMedBasePaadmCtl Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

ClassMethod GetAdmInfo(paadm)
{
    n (paadm)
    q:'$d(^PAADM(+paadm)) ""
    s LocDesc="",DocDesc="",WardDesc="",RoomDesc="",BedDesc="",DischgDate="",DischgTime=""
    s tmp=$g(^PAADM(+paadm))
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$zd($p(tmp,"^",6),3),AdmTime=$zt($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18))
    
    s:CTLoc'=0 LocDesc=##Class(DHCWMRMedBase).GetCtlocStr(CTLoc)    
    s:Doc'=0 DocDesc=##Class(DHCWMRMedBase).GetUserByCTCP(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    
    s s=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime
    q s
}

ClassMethod GetMrDiagnose(paadm)
{
	n (paadm)
    s MrAdm=+$p($g(^PAADM(+paadm)),"^",61)
    s s=""
    q:'$d(^MR(+MrAdm,"DIA")) s
        
    ;^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
    s Childsub=0
    f  s Childsub=$o(^MR(+MrAdm,"DIA",Childsub)) q:Childsub=""  d
    .s tmp=..BuildDisInfo(+MrAdm,Childsub)
    .q:tmp=""  //add by zf 过滤掉诊断描述
    .s s=s_tmp_$c(1)
        
    ;取电子病历诊断
    ;数据组织格式同$$BuildDisInfo
    s EPRDiag=##Class(DHCWMRMedBaseEPR).GetEPRDischDiag(paadm)
    s s=s_EPRDiag_$c(1)
        
    q s
}

ClassMethod GetAdmsByPatNo(PatNo, AdmType)
{
   n (PatNo,AdmType)
   ;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
   ;Add by wuqk 2008-04-25
   s PatNo=##Class(web.DHCWMRMedBase01).RegNoCon(PatNo)
   s PAPMI=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
   q:(PAPMI="")!(AdmType="") ""
   q:'$d(^PAPERdr(PAPMI,"ADM",AdmType)) ""
   s sPaadm=""
   s paadm=""
   f  s paadm=$o(^PAPERdr(PAPMI,"ADM",AdmType,paadm)) q:paadm=""  d
   .s sPaadm=sPaadm_$g(paadm)_$c(1)
   q sPaadm
}

ClassMethod BuildDisInfo(MRADM, MRDIAChildsub)
{
     n (MRADM,MRDIAChildsub)
     s sDIA=$g(^MR(+MRADM,"DIA",MRDIAChildsub))
     s ICDDR=$p(sDIA,"^",1)
     s ICDDoctorDR=$p(sDIA,"^",4)
     s ICDDate=$zd(+$p(sDIA,"^",7),3)
     s ICDTime=$zt(+$p(sDIA,"^",8))
     s ICDType=$g(^MR(+MRADM,"DIA",MRDIAChildsub,"TYP","1"))
     
     //add by zf 20091025 过滤掉诊断描述
     q:ICDDR="" ""
     
     s:ICDDR'="" ICDDR=ICDDR_"/"_$tr($p($g(^MRC("ID",ICDDR)),"^",4),"/","\")_"/"_$p($g(^MRC("ID",ICDDR)),"^",2)
     ;s:ICDDoctorDR'=0 ICDDoctorDR=ICDDoctorDR_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",2)
     
     ;s:ICDDoctorDR'=0 ICDDoctorDR=$$GetSSUSERByCode^DHCWMRMedBase($p($g(^CTPCP(ICDDoctorDR,1)),"^",1))_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",2)
     
     s:ICDDoctorDR'="" ICDDoctorDR=##Class(DHCWMRMedBase).GetUserByCTCP(ICDDoctorDR)
     ;GetSSUSERByCode
     s:ICDType'="" ICDType=ICDType_"/"_$p($g(^MRC("DTYP",ICDType)),"^",1)_"/"_$p($g(^MRC("DTYP",ICDType)),"^",2)
     
     s paadm=+$p($g(^MR(+MRADM,"PRO",1)),"^",9)
     s paadmtype=$p($g(^PAADM(paadm)),"^",2)
     s ctloc=$p($g(^PAADM(paadm)),"^",4)
     s LocDesc=ctloc_"/"_$p(^CTLOC(+ctloc),"^",2)
     s s=paadm_$c(2)_paadmtype_$c(2)_LocDesc_$c(2)_MRADM_"||"_MRDIAChildsub_$c(2)_ICDDR_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime
     q s
}

ClassMethod GetTemperatureTMP(paadm)
{
     n (paadm)
     s MrAdm=+$p($g(^PAADM(+paadm)),"^",61)
     s s=""
     q:'$d(^MR(+MrAdm,"CLN")) s
        
     ;^MR({MR_Adm.MRADM_RowId},"CLN",{MRCLN_Childsub})
        
     s Childsub=0
     f  s Childsub=$o(^MR(+MrAdm,"CLN",Childsub)) q:Childsub=""  d
     .s sCLN=$g(^MR(+MrAdm,"CLN",Childsub))
     .s BodyTemp=$p(sCLN,"^",1)
     .s Date=$zd($p(sCLN,"^",8),3)
     .s Time=$zt($p(sCLN,"^",9))
     .s tmp=BodyTemp_$c(2)_Date_$c(2)_Time
     .s s=s_tmp_$c(1)        
     q s
}

ClassMethod GetTemperature(paadm)
{
        n (paadm)
        s MrAdm=+$p($g(^PAADM(+paadm)),"^",61)
        s s=""
        q:'$d(^MR(+MrAdm,"OBS")) s
        
        ;^MR({MR_Adm.MRADM_RowId},"OBS",{MRCLN_Childsub})
        
        s Childsub=0
        f  s Childsub=$o(^MR(+MrAdm,"OBS",Childsub)) q:Childsub=""  d
        .s sOBS=$g(^MR(+MrAdm,"OBS",Childsub))
        .s ItemDR=$p(sOBS,"^",1)
        .q:'$d(^MRC("OBITM",+ItemDR))
        .q:($p($g(^MRC("OBITM",+ItemDR)),"^",1)'["体温")
        .s BodyTemp=$p(sOBS,"^",2)
        .s Date=$zd($p(sOBS,"^",3),3)
        .s Time=$zt($p(sOBS,"^",4))
        .s tmp=BodyTemp_$c(2)_Date_$c(2)_Time
        .s s=s_tmp_$c(1)        
        q s
}

ClassMethod GetCurrPaadms(Ward)
{
     n (Ward)
     k ^CacheTemp($zn,$j)
     s num=0,s=""
     q:'$d(^PAADMi("CurrWard",+Ward)) s
   
     s Room="" f  s Room=$o(^PAADMi("CurrWard",+Ward,Room)) q:Room=""  d
     .s paadm="" f  s paadm=$o(^PAADMi("CurrWard",+Ward,Room,paadm)) q:paadm=""  d
     ..s TMP=..GetPaadmBaseInfo(+paadm)
     ..s s=s_TMP_$c(1)
     q s
}

ClassMethod GetPaadmBaseInfo(paadm)
{
   n (paadm)
   s TMP=..GetAdmInfo(+paadm)
   s tmp=$g(^PAADM(+paadm))
   s papmi=+$p(tmp,"^",1)
   s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
   s name=$p($g(^PAPER(papmi,"ALL")),"^",1)
   s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmi,"ALL")),"^",7))),"^",2)
   s birth=$p($g(^PAPER(papmi,"ALL")),"^",6),birthdate=""
   i birth'="" s birthdate=$zd(birth,3)
   s age=##Class(web.DHCWMRMedBase).CalAge(birth,+$h)
   s TMP=TMP_"^"_papmino_"^"_name_"^"_sex_"^"_birthdate_"^"_age
   q TMP
}

}
