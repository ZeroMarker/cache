Include webimport

IncludeGenerator webimport

Class web.DHCEmergency Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Query(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s desc=""
 if val="" q 1
 //s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
 // .s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)

 //S desc=$g(RName)_"^"_$g(RBirth)_"^"_$g(RSex)_"^"_$g(RIDCardNo)_"^"_$g(RTelNo)_"^"_$g(RInMedicare)_"^"_$g(RPatType)_"^"_$g(RAddress)_"^"_$g(ROpMedicare)_"^"_$g(RCompany)_"^"_$g(EMMedicare)
 s ACUCode=""
 s ACUDesc=""
 s ACURowid=$p(^PAADM(val),"^",33)
 if ACURowid'="" s ACUDesc=$p(^CT("ACU",ACURowid),"^",2)
 
 s MradmRowid=$P(^PAADM(val),"^",61)
 //mradm_bpsystolic,mradm_bpdiastolic,mradm_resp,mradm_pulserate,mradm_weight

 //"PRO",1,4; "PRO",1,5;   "PRO",1,8;            "PRO",1,6;          "PRO",1,27;  
 s bpsystolic=$p(^MR(MradmRowid,"PRO",1),"^",4)
 s bpdiastolic=$p(^MR(MradmRowid,"PRO",1),"^",5)
 s resp=$p(^MR(MradmRowid,"PRO",1),"^",8)
 s pulserate=$p(^MR(MradmRowid,"PRO",1),"^",6)
 s weight=$p(^MR(MradmRowid,"PRO",1),"^",27)
 s height=$p(^MR(MradmRowid,"PRO",1),"^",20)
 s InjuryDesc=$p(^MR(MradmRowid,"PRO",1),"^",90)
 s TransferMeansRowId=$p(^MR(MradmRowid,"PRO",1),"^",49)
 i TransferMeansRowId'="" s TransferMeansDesc=$p(^PAC("TRANSM",TransferMeansRowId),"^",2)
 e  s TransferMeansDesc=""
 ;s ^DHCApp=MradmRowid
 ;set ^MR({MR_Adm.MRADM_RowId},"EMC",{EMC_Childsub}
 set EMCChildSub=0
 set EMCEmerConDR=""
 set EMCEmerConDesc=""
 f  s EMCChildSub=$o(^MR(MradmRowid,"EMC",EMCChildSub)) q:EMCChildSub=""  d
 .s ^DHCApp(EMCChildSub)=^MR(MradmRowid,"EMC",EMCChildSub)
 .s EMCEmerConDR=^MR(MradmRowid,"EMC",EMCChildSub)
 .i EMCEmerConDesc=""  d
 ..s EMCEmerConDesc=EMCEmerConDR_"&"_$p(^MRC("EMC",EMCEmerConDR),"^",2)
 .e  d
 ..s EMCEmerConDesc=EMCEmerConDesc_"!"_EMCEmerConDR_"&"_$p(^MRC("EMC",EMCEmerConDR),"^",2)
 
 //i EMCEmerConDesc="" d
 //.s EmConRowid=0
 //.s EmConRowid=$o(^MRC("EMC",0,"Desc","生活伤",EmConRowid))
 //.if EmConRowid'="" d
 //..s EMConName=$p(^MRC("EMC",EmConRowid),"^",2)
 //..s EMCEmerConDesc=EmConRowid_"&"_EMConName  
 
 s ^DHCApp=EMCEmerConDesc
 
 s desc=bpsystolic_"^"_bpdiastolic_"^"_resp_"^"_pulserate_"^"_weight_"^"_height_"^"_ACUDesc_"^"_InjuryDesc_"^"_EMCEmerConDesc_"^"_TransferMeansDesc
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"');"
 &javascript<#(retval)#>
 q desc
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 set desc=""

 set PaadmRowid=$p(val,",",1)
 if PaadmRowid="" q 1

 set bpsystolic=$p(val,",",2)
 set bpdiastolic=$p(val,",",3)
 set resp=$p(val,",",4)
 set pulserate=$p(val,",",5)
 set weight=$p(val,",",6)
 
 
 set ACUDesc=$p(val,",",8)
 set EMCVal=$p(val,",",9)
 
 set SSUsrDr=""
 set CareProvDr=""
 set CarePrvTpDr=""
 set CarePrvTp=""
 set SSUsrDr=$p(val,",",10)
 set InjuryDesc=$p(val,",",11)
 if SSUsrDr'="" set CareProvDr=$p(^SSU("SSUSR",SSUsrDr),"^",14)
 if CareProvDr'="" set CarePrvTpDr=$p(^CTPCP(CareProvDr,1),"^",4)
 if CarePrvTpDr'="" set CarePrvTp=$p(^CT("CPT",CarePrvTpDr),"^",4)
 //set ^DHCApp(0)=CarePrvTp
 
 set ACUrowid=0
 set MrAdmRowid=""
 set MrAdmRowid=$p(^PAADM(PaadmRowid),"^",61)
 if ACUDesc'="" set ACUrowid=$o(^CT("ACU",0,"Desc",ACUDesc,ACUrowid))
 set TransferMeansDesc=$p(val,",",12)
 set TransferMeansRowId=""
 if TransferMeansDesc'="" d
 .set TransferMeansDesc=$$ALPHAUP^SSUTIL4(TransferMeansDesc)
 .set TransferMeansRowId=$o(^PAC("TRANSM",0,"Desc",TransferMeansDesc,TransferMeansRowId))

 tstart
 if ACUrowid'=""{
     &sql(update sqluser.pa_adm set paadm_priority_dr =:ACUrowid
    where paadm_rowid=:PaadmRowid)
 s desc =SQLCODE
 }
 
 if ((CarePrvTp="NURSE")!(CarePrvTp="")){
    &sql(update Mr_Adm 
        set mradm_bpsystolic=:bpsystolic,
            mradm_bpdiastolic=:bpdiastolic,
            mradm_resp=:resp,
            mradm_pulserate=:pulserate,
            mradm_weight=:weight
        where MrAdm_Rowid=:MrAdmRowid)
    s desc = desc + SQLCODE
 }
 
 &sql(update Mr_Adm 
        set mradm_InjuryDesc=:InjuryDesc,
        MRADM_TransferMeans_DR=:TransferMeansRowId
        where MrAdm_Rowid=:MrAdmRowid)
    s desc = desc + SQLCODE
  
 &sql(delete from MR_EMERgencycondition
 where emc_parref=:MrAdmRowid)
 
 if SQLCODE=100 SET SQLCODE=0
 
 s desc = desc + SQLCODE
 
 set Count=1
 set EMCDr=0
 f  s EMCDrMix=$p(EMCVal,"^",Count) q:EMCDrMix=""  d
 .s EMCDr=$p(EMCDrMix,$C(2),2)
 .i EMCDr="" s EMCDr=EMCDrMix
 .;set ^DHCApp(Count)=MrAdmRowid_"^"_EMCDr
 .&sql(insert into  MR_EMERgencycondition(emc_parref,emc_emergcond_dr) 
    values(:MrAdmRowid,:EMCDr))
 .s desc = desc + SQLCODE
 .s Count=Count+1
 
 
 if desc'=0{
    TRollback
 }else{
    TCommit
}

 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"');"
 &javascript<#(retval)#>
 q 0
 //}
}

ClassMethod FindTransferMeansClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransferMeansExecute ]
{
    Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindTransferMeansExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s rowid=0
 f  s rowid=$o(^PAC("TRANSM",rowid)) q:rowid=""  d
 .s ID=rowid
 .s Des=$p(^PAC("TRANSM",rowid),"^",2)
 .s dateTo=$p(^PAC("TRANSM",rowid),"^",6)
 .s dateFrom=$p(^PAC("TRANSM",rowid),"^",5)
 .q:(dateFrom'="")&(dateFrom>+$h)
 .q:(dateTo'="")&(dateTo<+$h)
 .Do OutputRow      
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutputRow
 set Data=$lb(Des,ID)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindTransferMeansFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransferMeansExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
    //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {                // fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query FindTransferMeans() As %Query(ROWSPEC = "Des:%String,ID:%String")
{
}

}
