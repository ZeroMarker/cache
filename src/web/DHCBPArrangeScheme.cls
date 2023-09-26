Import SQLUser

Class web.DHCBPArrangeScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// w ##class(web.DHCBPArrangeScheme).InsertArrangeScheme("193"_$c(3)_"1"_$c(3)_"3"_"^"_"193"_$c(3)_"1"_$c(3)_"3"_"^"_"193"_$c(3)_"1"_$c(3)_"3"_"^"_"193"_$c(3)_"1"_$c(3)_"3",144)

// w ##class(web.DHCBPArrangeScheme).InsertArrangeScheme("")

ClassMethod SaveArrangeScheme(paraStr As %String, schemeId As %String) As %String
{
	 //s paraStr=^TMPzt("SaveArrangeScheme")
	 //s schemeId=30
	 q:paraStr="" "0"
	 q:schemeId="0" "0"
	 s ifActive=""
	 s quit=0 
     TSTART
     s SQLCODE=0	 
     k BPMODE
     s arrangeSchemeId=""
     f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:arrangeSchemeId=""  d
     .s dialysisMethodId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)
     .s BPMODE(dialysisMethodId,"COUNT")=0
	 f i=1:1:$l(paraStr,"^") q:SQLCODE'=0  d
	.s singlePara=$p(paraStr,"^",i)
	.q:singlePara=""
	.s registerId=$p(singlePara,$c(3),1)
	.s dialysisMethodId=$p(singlePara,$c(3),2)
	.s therapyDuration=$p(singlePara,$c(3),3)
	.s anticoagulantModeId=$p(singlePara,$c(3),4)
	.s anticoagulantDrugPara=$p(singlePara,$c(3),5)
	.s consumableBusinessPara=$p(singlePara,$c(3),6)
	.s isTemporary=$p(singlePara,$c(3),7)
	.s filterReplaceMode=$p(singlePara,$c(3),8)
	.s filterReplaceAmount=$p(singlePara,$c(3),9)
	.s dialysateAmount=$p(singlePara,$c(3),10)
	.s singleInAmount=$p(singlePara,$c(3),11)
	.s exchangeTimes=$p(singlePara,$c(3),12)
	.s theLastReservation=$p(singlePara,$c(3),13)
	.s totalAmountOfMachine=$p(singlePara,$c(3),14)
	.s BPMODE(dialysisMethodId)=registerId_"^"_therapyDuration_"^"_anticoagulantModeId_"^"_anticoagulantDrugPara_"^"_consumableBusinessPara_"^"_isTemporary_"^"_filterReplaceMode_"^"_filterReplaceAmount_"^"_dialysateAmount_"^"_singleInAmount_"^"_exchangeTimes_"^"_theLastReservation_"^"_totalAmountOfMachine
	.s BPMODE(dialysisMethodId,"COUNT")=$g(BPMODE(dialysisMethodId,"COUNT"))+1
		
	s result=1
	s dialysisMethodId=""
	f  s dialysisMethodId=$o(BPMODE(dialysisMethodId))  q:(dialysisMethodId="")!(+result'=1)  d
	.s ndCt=BPMODE(dialysisMethodId,"COUNT") //要保存的数量	
	.i ndCt=0 d
	..&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='Y' where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null))
	.q:ndCt=0
	.s isTemporary=$p(BPMODE(dialysisMethodId),"^",6)
	.i isTemporary="Y" d
	..&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='Y',BPAS_IfActive='N' where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId )
	.q:isTemporary="Y"
	.k PLIST
	.s null=""
	.s PLIST(6)=null
	.s PLIST(7)=null
	.s PLIST(8)=null
	.s PLIST(9)=null
	.s PLIST(11)=null
	.s PLIST(12)=null
	.s PLIST(13)=null
	.s PLIST(14)=null
	.s PLIST(15)=null
	.s PLIST(16)=null
	.s PLIST(17)=null
	.s PLIST(19)=null
	.s PLIST(20)=null
	.s PLIST(18)="Y"
	.&sql(update DHC_BP_ArrangeScheme values PLIST() where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null) and BPAS_IsTemporary='Y') //删除临时方案
	.s registerId=$p(BPMODE(dialysisMethodId),"^",1)
	.s therapyDuration=$p(BPMODE(dialysisMethodId),"^",2)
	.s anticoagulantModeId=$p(BPMODE(dialysisMethodId),"^",3)
	.s anticoagulantDrugPara=$p(BPMODE(dialysisMethodId),"^",4)
	.s consumableBusinessPara=$p(BPMODE(dialysisMethodId),"^",5)
	.s filterReplaceMode=$p(BPMODE(dialysisMethodId),"^",7)
	.s filterReplaceAmount=$p(BPMODE(dialysisMethodId),"^",8)
	.s dialysateAmount=$p(BPMODE(dialysisMethodId),"^",9)
	.s singleInAmount=$p(BPMODE(dialysisMethodId),"^",10)
	.s exchangeTimes=$p(BPMODE(dialysisMethodId),"^",11)
	.s theLastReservation=$p(BPMODE(dialysisMethodId),"^",12)
	.s totalAmountOfMachine=$p(BPMODE(dialysisMethodId),"^",13)	
	.s ct1=0 //数据库中已存在的该透析方法的未置删除状态的数量
	.s ct2=0 //数据库中已存在的该透析方法且未置删除状态的处于激活状态的数量
	.s ct3=0 //数据库中已存在的该透析方法的已置删除状态的数量
	.s ct4=0 //数据库中已存在的该透析方法的已置删除状态的并且还处于激活状态的数量
	.&sql(select count(*) into :ct1 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null))
	.&sql(select count(*) into :ct2 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null) and BPAS_IfActive='Y')
	.&sql(select count(*) into :ct3 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y')
	.&sql(select count(*) into :ct4 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IfActive='Y' )
	.s ct5=ct1-ct2 ////数据库中已存在的该透析方法的未经删除的并且未激活状态的数量
	.s ct6=ct3-ct4 ////数据库中已存在的该透析方法的已经删除的并且未激活状态的数量
	.b ;2
	.i ndCt>=ct1 d
	..s PLIST(18)="N"
	..s incCt=ndCt-ct1 //需要增加的数量
	..i incCt<=ct3  d     //如果需要增加的数量小于数据库中该透析方法中已置删除状态的数量
	...i incCt<=ct4 d     //如果需要增加的数量小于等于已删除的并且还在激活状态的数量，优先把这些已删除还处于激活状态的数量还原为正常使用状态
	....&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='N' where %ID in (select top :incCt %ID from DHC_BP_ArrangeScheme where
	BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IfActive='Y'))
	...e  d
	....b ;32
	....&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='N' where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IfActive='Y')
	....s count=incCt-ct4
	....&sql(update DHC_BP_ArrangeScheme values PLIST() where %ID in (select top :count %ID from DHC_BP_ArrangeScheme where
	BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and (BPAS_IfActive='N' OR BPAS_IfActive is null))) 
	..e  d  //需要增加的数量大于已置删除的数量，则需要将所有置删除状态的的记录还原为正常使用，并且新插入记录。
	...b ;4
	...&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='N' where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IfActive='Y')
	...&sql(update DHC_BP_ArrangeScheme values PLIST() where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and (BPAS_IfActive='N' OR BPAS_IfActive is null))
	...s count=incCt-ct3
	...b ;41
	...f i=1:1:count d
	....b ;411
	....&sql(insert into DHC_BP_ArrangeScheme (BPAS_BPPatRegister_Dr,BPAS_BPScheme_Dr,BPAS_BPCBPMode_Dr,BPAS_TherapyDuration,BPAS_IfAbandon,BPAS_FilterReplaceMode,BPAS_FilterReplaceAmount,BPAS_DialysateAmount,BPAS_SingleInAmount,BPAS_ExchangeTimes,BPAS_TheLastReservation,BPAS_TotalAmountOfMachine) values(:registerId,:schemeId,:dialysisMethodId,:therapyDuration,'N',:filterReplaceMode,:filterReplaceAmount,:dialysateAmount,:singleInAmount,:exchangeTimes,:theLastReservation,:totalAmountOfMachine))
    .e  d   //数量更改的减少了 
    ..s count=ct1-ndCt
    ..b ;5
    ..i count<=ct5 d //置删除状态的时候，优先选择未激活状态的记录进行删除
    ...b ;6
    ...&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='Y' where %ID in (select top :count %ID from DHC_BP_ArrangeScheme where
	BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null) and (BPAS_IfActive='N' OR BPAS_IfActive is null)))
	..e  d
	...b ;7
	...&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='Y' where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null) and (BPAS_IfActive='N' OR BPAS_IfActive is null))
	...s count=count-ct5
	...&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='Y' where %ID in (select top :count %ID from DHC_BP_ArrangeScheme where
	BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and (BPAS_IfAbandon='N' OR BPAS_IfAbandon is null) and BPAS_IfActive='Y'))	
	.&sql(update DHC_BP_ArrangeScheme set BPAS_TherapyDuration=:therapyDuration,BPAS_AnticoagulantMode_Dr=:anticoagulantModeId,BPAS_FilterReplaceMode=:filterReplaceMode,BPAS_FilterReplaceAmount=:filterReplaceAmount,BPAS_DialysateAmount=:dialysateAmount,BPAS_SingleInAmount=:singleInAmount,BPAS_ExchangeTimes=:exchangeTimes,BPAS_TheLastReservation=:theLastReservation,BPAS_TotalAmountOfMachine=:totalAmountOfMachine where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId)
	.i (SQLCODE'=0)&(SQLCODE'=100) s result="更新安排计划出错"
	.q:(SQLCODE'=0)&(SQLCODE'=100)
	.s arrangeSchemeId=""
    .f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:arrangeSchemeId=""  d
    ..s diaMethodId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)
    ..q:diaMethodId'=dialysisMethodId
    ..s ifAbandon=$lg(^DHCBPArrangeScheme(arrangeSchemeId),17)
    ..q:ifAbandon="Y"
    ..s isTemporary=$lg(^DHCBPArrangeScheme(arrangeSchemeId),19)
    ..q:isTemporary="Y"
    ..i anticoagulantDrugPara'="" d //20201209 过滤
    	...s result=..SaveSchemeAnticoagulantDrug(arrangeSchemeId,anticoagulantDrugPara)
    	...i +result'=1 s result="更新抗凝方案出错"
    ..i consumableBusinessPara'="" d
    	...s result=..SaveSchemeConsumableList(arrangeSchemeId, consumableBusinessPara)
    	...i +result'=1 s result="更新透析器材出错"
    b ;update finish
	i +result'=1  Trollback  q result
	
	///处理临时方案方式
	s dialysisMethodId=""
	f  s dialysisMethodId=$o(BPMODE(dialysisMethodId))  q:(dialysisMethodId="")!(+result'=1)  d
	.q:BPMODE(dialysisMethodId,"COUNT")=0
	.s registerId=$p(BPMODE(dialysisMethodId),"^",1)
	.s therapyDuration=$p(BPMODE(dialysisMethodId),"^",2)
	.s anticoagulantModeId=$p(BPMODE(dialysisMethodId),"^",3)
	.s anticoagulantDrugPara=$p(BPMODE(dialysisMethodId),"^",4)
	.s consumableBusinessPara=$p(BPMODE(dialysisMethodId),"^",5)
	.s isTemporary=$p(BPMODE(dialysisMethodId),"^",6)
	.q:isTemporary'="Y"
	.s filterReplaceMode=$p(BPMODE(dialysisMethodId),"^",7)
	.s filterReplaceAmount=$p(BPMODE(dialysisMethodId),"^",8)
	.s dialysateAmount=$p(BPMODE(dialysisMethodId),"^",9)
	.s singleInAmount=$p(BPMODE(dialysisMethodId),"^",10)
	.s exchangeTimes=$p(BPMODE(dialysisMethodId),"^",11)
	.s theLastReservation=$p(BPMODE(dialysisMethodId),"^",12)
	.s totalAmountOfMachine=$p(BPMODE(dialysisMethodId),"^",13)
	.s ctt1=0
	.&sql(select count(*) into :ctt1 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IsTemporary='Y')
	.i ctt1>0 d
	..&sql(update DHC_BP_ArrangeScheme set BPAS_IfAbandon='N',BPAS_IfActive='Y' where %ID in (select top 1 %ID from DHC_BP_ArrangeScheme where
	BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:dialysisMethodId and BPAS_IfAbandon='Y' and BPAS_IsTemporary='Y'))
	.e  d
	..&sql(insert into DHC_BP_ArrangeScheme (BPAS_BPPatRegister_Dr,BPAS_BPScheme_Dr,BPAS_BPCBPMode_Dr,BPAS_IfActive,BPAS_TherapyDuration,BPAS_IfAbandon,BPAS_IsTemporary,BPAS_FilterReplaceMode,BPAS_FilterReplaceAmount,BPAS_DialysateAmount,BPAS_SingleInAmount,BPAS_ExchangeTimes,BPAS_TheLastReservation,BPAS_TotalAmountOfMachine) values(:registerId,:schemeId,:dialysisMethodId,'Y',:therapyDuration,'N','Y',:filterReplaceMode,:filterReplaceAmount,:dialysateAmount,:singleInAmount,:exchangeTimes,:theLastReservation,:totalAmountOfMachine))
	.s arrangeSchemeId=$g(%ROWID)
	.&sql(update DHC_BP_ArrangeScheme set BPAS_TherapyDuration=:therapyDuration,BPAS_AnticoagulantMode_Dr=:anticoagulantModeId,BPAS_FilterReplaceMode=:filterReplaceMode,BPAS_FilterReplaceAmount=:filterReplaceAmount,BPAS_DialysateAmount=:dialysateAmount,BPAS_SingleInAmount=:singleInAmount,BPAS_ExchangeTimes=:exchangeTimes,BPAS_TheLastReservation=:theLastReservation,BPAS_TotalAmountOfMachine=:totalAmountOfMachine where %ID=:arrangeSchemeId)
	.i anticoagulantDrugPara'="" d //20201209 过滤
		..s result=..SaveSchemeAnticoagulantDrug(arrangeSchemeId,anticoagulantDrugPara)
    	..i +result'=1 s result="更新抗凝方案出错"
    .i consumableBusinessPara'="" d	
    	..s result=..SaveSchemeConsumableList(arrangeSchemeId, consumableBusinessPara)
    	..i +result'=1 s result="更新透析器材出错"
    i +result'=1  Trollback  q result
	TCommit
	q 1
}

// w ##class(web.DHCBPArrangeScheme).UpdateArrangeSchemeList("")

ClassMethod UpdateArrangeSchemeList(paraStr As %String, arrWeekCount As %String) As %String
{
	s ^TMPzt("UPdate")=paraStr
	//s paraStr=^TMPzt("UPdate")
	s result=1
	TSTART
	s schemeId=""
	s SQLCODE=0
	f i=1:1:$l(paraStr,"^") q:(+result'=1)  d
	.s singlePara=$p(paraStr,"^",i)
	.q:singlePara=""
	.s ifActive=$p(singlePara,$c(3),10)
	.;q:ifActive'="Y"
	.s schemeId=$p(singlePara,$c(3),3)
	.s daySeq=$p(singlePara,$c(3),9)
	.i daySeq="AM" s daySeq="A"
	.i daySeq="PM" s daySeq="P"
	.i daySeq="Evening"   s daySeq="E"
	.s mainArrangeSchemeDr=$p(singlePara,$c(3),12)
	.s count=0
	.&sql(select count(*) into :count from DHC_BP_ArrangeScheme where %ID=:mainArrangeSchemeDr)
	.q:(mainArrangeSchemeDr'="")&(count=0)
	.&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme where BPS_RowId=:schemeId)
	.i registerId="" s result=-1 q
	.i (+$h<schemeStartDate)!(+$h>schemeEndDate) s result="透析方案没在有效期内" q
	.s status=$lg(^DHCBPPatRegister(registerId),14)
	.i (status'="N") s result="病人已经转归,无法安排透析计划" q
	.s effectDate=$p(singlePara,$c(3),11)
	.s effectDate=##class(web.DHCClinicCom).ConvertToDateH(effectDate)
	.k PLIST
	.s id=$p(singlePara,$c(3),1)
	.s PLIST(2)=$p(singlePara,$c(3),2)
	.s PLIST(3)=schemeId
	.s PLIST(4)=$p(singlePara,$c(3),4)
	.s PLIST(5)=$p(singlePara,$c(3),5)
	.s PLIST(6)=$p(singlePara,$c(3),6)
	.s PLIST(7)=$p(singlePara,$c(3),7)
	.s PLIST(8)=$p(singlePara,$c(3),8)
	.s PLIST(9)=daySeq
	.s PLIST(10)=ifActive
	.;s PLIST(11)=effectDate
    .s PLIST(12)=mainArrangeSchemeDr
	.s PLIST(18)=$p(singlePara,$c(3),14)
	.s userId=$p(singlePara,$c(3),15)
	.b ;DHC_BP_ArrangeScheme
	.&sql(update DHC_BP_ArrangeScheme Values :PLIST() where %ID=:id)
	.i (SQLCODE'=0)&(SQLCODE'=100) s result="更新计划表错误"_SQLCODE
	.q:(SQLCODE'=0)&(SQLCODE'=100)
	.s consumableBusinessPara=$p(singlePara,$c(3),13)
	.q:id=""
	.s result=..SaveSchemeConsumableList(id, consumableBusinessPara)
	.i +result'=1 s result="更新器材表错误"_result
	i +result'=1 Trollback  q result
	b ;eidt
	s result=..EditBPArrange(schemeId,userId,arrWeekCount)  
    i +result'=1 TROLLBACK  q result
	s result=1
	TCommit
	q result
}

ClassMethod SaveSchemeAnticoagulantDrug(arrangeSchemeId, paraStr) As %String
{
	q:arrangeSchemeId="0" 0	
	s curDate=+$h
	s curTime=$p($h,",",2)
	s SQLCODE=0
	&sql(update DHC_BP_SchemeAnticoagulantDrug set BPSAD_IfAbandon='Y' where BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId)
	;&sql(delete from DHC_BP_SchemeAnticoagulantDrug where BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId)
	i (SQLCODE'=0)&(SQLCODE'=100)  q 0
    s outerSpliter="&",innerSpliter="$"
	f i=1:1:$l(paraStr,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(paraStr,outerSpliter,i)
	.s id=$p(singleParaStr,innerSpliter,1)
	.s anticoagulantDrugId=$p(singleParaStr,innerSpliter,2)
	.s amount=$p(singleParaStr,innerSpliter,3)
	.s firstAmount=$p(singleParaStr,innerSpliter,4)
	.s dose=$p(singleParaStr,innerSpliter,5)
	.s frequency=$p(singleParaStr,innerSpliter,6)
	.s note=$p(singleParaStr,innerSpliter,7)
	.s duration=$p(singleParaStr,innerSpliter,8)
	.s intervalMinute=$p(singleParaStr,innerSpliter,9)
	.s concentration=$p(singleParaStr,innerSpliter,10)
	.s lastReservation=$p(singleParaStr,innerSpliter,11)	
    .i id="" d
	..&sql(insert into DHC_BP_SchemeAnticoagulantDrug (BPSAD_BPArrangeScheme_Dr,BPSAD_BPCAD_Dr,
	 BPSAD_Amount,BPSAD_FirstAmount,BPSAD_Dose,BPSAD_Frequency,BPSAD_Note,BPSAD_IfAbandon,
	 BPSAD_OperationDate,BPSAD_OperationTime,BPSAD_Duration,BPSAD_IntervalMinute,BPSAD_Concentration,BPSAD_LastReservation)
	 values(:arrangeSchemeId,:anticoagulantDrugId,:amount,:firstAmount,:dose,:frequency,:note,'N',:curDate,:curTime,:duration,:intervalMinute,:concentration,:lastReservation))
	.e  d
    ..&sql(update DHC_BP_SchemeAnticoagulantDrug set BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId,BPSAD_BPCAD_Dr=:anticoagulantDrugId,
	 BPSAD_Amount=:amount,BPSAD_FirstAmount=:firstAmount,BPSAD_Dose=:dose,BPSAD_Frequency=:frequency,
	 BPSAD_Note=:note,BPSAD_IfAbandon='N',BPSAD_OperationDate=:curDate,BPSAD_OperationTime=:curTime,
	 BPSAD_Duration=:duration,BPSAD_IntervalMinute=:intervalMinute,BPSAD_Concentration=:concentration,BPSAD_LastReservation=:lastReservation where BPSAD_RowId=:id)
    i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
	q 1
}

/// Creator: ZT
/// CreatDate: 2015-02-06
/// Description: 保存透析器材列表
/// Table：DHC_BP_SchemeConsumable
/// Input：arrangeSchemeId，consumableBuisinessPara
/// Return：正确 "1" 错误SQLCODE
/// w ##class(web.DHCBPArrangeScheme).SaveSchemeConsumableList("","")
ClassMethod SaveSchemeConsumableList(arrangeSchemeId, paraStr) As %String
{
	//s ^TMPzt("SaveSchemeConsumableList")=arrangeSchemeId_"/"_paraStr
	//s arrangeSchemeId=$p(^TMPzt("SaveSchemeConsumableList"),"/",1)
	//s paraStr=$p(^TMPzt("SaveSchemeConsumableList"),"/",2)
	q:+arrangeSchemeId="0" "无id"
	s curDate=+$h
	s curTime=$p($h,",",2)
	s SQLCODE=0
	&sql(update DHC_BP_SchemeConsumable set BPSC_IfAbandon='Y' where BPSC_BPArrangeScheme_Dr=:arrangeSchemeId) //筛选一下
    i (SQLCODE'=0)&(SQLCODE'=100)  q 0
    s outerSpliter="&",innerSpliter="$"
	f i=1:1:$l(paraStr,outerSpliter) q:(SQLCODE'=0)&(SQLCODE'=100)  d
	.s singleParaStr=$p(paraStr,outerSpliter,i)
	.q:singleParaStr=""
	.s id=$p(singleParaStr,innerSpliter,1)
	.s consumableId=$p(singleParaStr,innerSpliter,2)
	.q:(consumableId="")!(consumableId=0)
	.s type=$p(singleParaStr,innerSpliter,3)
	.s amount=$p(singleParaStr,innerSpliter,4)
	.i id="" d
	..&sql(insert into DHC_BP_SchemeConsumable (BPSC_BPArrangeScheme_Dr,BPSC_BPCConsumable_Dr,BPSC_Type,BPSC_Amount,BPSC_IfAbandon,BPSC_OperationDate,BPSC_OperationTime) values(:arrangeSchemeId,:consumableId,:type,:amount,'N',:curDate,:curTime))
    .e  d
    ..&sql(update DHC_BP_SchemeConsumable set BPSC_BPArrangeScheme_Dr=:arrangeSchemeId,BPSC_BPCConsumable_Dr=:consumableId,BPSC_Type=:type,BPSC_Amount=:amount,BPSC_IfAbandon='N',BPSC_OperationDate=:curDate,BPSC_OperationTime=:curTime where BPSC_RowId=:id)
	i (SQLCODE'=0)&(SQLCODE'=100) q SQLCODE
	q 1
}

/// Creator: mfc
/// CreatDate: 2020-10-20
/// Description: 获取透析计划安排数据
/// Table：DHC_BP_ArrangeScheme
/// Input：schemeId透析方案id，antModeId透析方式id
/// Return：返回透析计划记录
Query GetCurArrangeSchemeList(schemeId As %String, antModeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 select %ID As Id,
	 BPAS_BPPatRegister_Dr As RegisterId,
	 BPAS_BPScheme_Dr as SchemeId,
	 BPAS_BPCBPMode_Dr as DialysisMethodId,
	 BPAS_BedDr as BedId,
	 BPAS_WeekSeqNo as WeekSeq,
	 BPAS_WeekDay as WeekDay,
	 BPAS_DaySeqNo as DaySeqCode,
	 BPAS_IfActive as IfActive,
	 BPAS_EffectDate as EffectDate,
	 BPAS_MainBPAS_Dr as MainArrangeSchemeDr,
	 BPAS_BPCConsumable_Dr as ConsumableId,
	 BPAS_SecondBPCConsumable_Dr as SecondConsumableId,
	 BPAS_ThirdBPCConsumable_Dr as ThirdConsumableId,
	 BPAS_FourthBPCConsumable_Dr as FourthConsumableId,
	 BPAS_TherapyDuration as TherapyDuration,
	 BPAS_IfAbandon	as IfAbandon,
	 BPAS_AnticoagulantMode_Dr as AnticoagulantModeId,
	 BPAS_IsTemporary as IsTemporary,
	 BPAS_FilterReplaceMode as FilterReplaceMode,
	 BPAS_FilterReplaceAmount as FilterReplaceAmount,
	 BPAS_DialysateAmount as DialysateAmount,
	 BPAS_SingleInAmount as SingleInAmount,
	 BPAS_ExchangeTimes as ExchangeTimes,
	 BPAS_TheLastReservation as TheLastReservation,
	 BPAS_TotalAmountOfMachine as TotalAmountOfMachine
	 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_BPCBPMode_Dr=:antModeId and (BPAS_IfAbandon='N' or BPAS_IfAbandon is null) order by BPAS_WeekSeqNo,BPAS_WeekDay asc
}

Query GetArrangeSchemeList(schemeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 select %ID As Id,
	 BPAS_BPPatRegister_Dr As RegisterId,
	 BPAS_BPScheme_Dr as SchemeId,
	 BPAS_BPCBPMode_Dr as DialysisMethodId,
	 BPAS_BedDr as BedId,
	 BPAS_WeekSeqNo as WeekSeq,
	 BPAS_WeekDay as WeekDay,
	 BPAS_DaySeqNo as DaySeqCode,
	 BPAS_IfActive as IfActive,
	 BPAS_EffectDate as EffectDate,
	 BPAS_MainBPAS_Dr as MainArrangeSchemeDr,
	 BPAS_BPCConsumable_Dr as ConsumableId,
	 BPAS_SecondBPCConsumable_Dr as SecondConsumableId,
	 BPAS_ThirdBPCConsumable_Dr as ThirdConsumableId,
	 BPAS_FourthBPCConsumable_Dr as FourthConsumableId,
	 BPAS_TherapyDuration as TherapyDuration,
	 BPAS_IfAbandon	as IfAbandon,
	 BPAS_AnticoagulantMode_Dr as AnticoagulantModeId,
	 BPAS_IsTemporary as IsTemporary,
	 BPAS_FilterReplaceMode as FilterReplaceMode,
	 BPAS_FilterReplaceAmount as FilterReplaceAmount,
	 BPAS_DialysateAmount as DialysateAmount,
	 BPAS_SingleInAmount as SingleInAmount,
	 BPAS_ExchangeTimes as ExchangeTimes,
	 BPAS_TheLastReservation as TheLastReservation,
	 BPAS_TotalAmountOfMachine as TotalAmountOfMachine
	 from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and (BPAS_IfAbandon='N' or BPAS_IfAbandon is null) order by BPAS_WeekSeqNo,BPAS_WeekDay asc
}

Query GetSchemeAnticoagulantDrugList(arrangeSchemeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPSAD_RowId As Id,
	 BPSAD_BPCAD_Dr As AnticoagulantDrugId,
	 BPSAD_Amount As Amount,
	 BPSAD_FirstAmount As FirstAmount,
	 BPSAD_Dose As Dose,
	 BPSAD_Frequency As Frequency,
	 BPSAD_Note As Note,
	 BPSAD_Duration As Duration,
	 BPSAD_IntervalMinute As IntervalMinute,
	 BPSAD_Concentration As Concentration,
	 BPSAD_LastReservation As LastReservation
	 from DHC_BP_SchemeAnticoagulantDrug where BPSAD_BPArrangeScheme_Dr=:arrangeSchemeId and (BPSAD_IfAbandon='N' or BPSAD_IfAbandon is null) and BPSAD_BPCAD_Dr is not null
}

/// Creator: ZT
/// CreatDate: 2015-02-06
/// Description: 获取透析器材列表
/// Table：DHC_BP_ArrangeConsumable
/// Input：arrangeSchemeId
/// Return：透析器材列表
Query GetSchemeConsumableList(arrangeSchemeId As %String) As %SQLQuery(CONTAINID = 1)
{
	 SELECT 
	 BPSC_RowId As Id,
	 BPSC_BPCConsumable_Dr As ConsumableId,
	 BPSC_Type As Type,
	 BPSC_Amount As Amount from DHC_BP_SchemeConsumable where BPSC_BPArrangeScheme_Dr=:arrangeSchemeId and (BPSC_IfAbandon='N' or BPSC_IfAbandon is null)
}

// w ##class(web.DHCBPArrangeScheme).EffectArrangeSchemeList("30",3879)

ClassMethod EffectArrangeSchemeList(schemeId, userId, arrWeekCount) As %String
{
	s result=1
	s registerId="",schemeStartDate="",schemeEndDate=""
	&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	q:registerId="" -1
	q:(+$h<schemeStartDate)!(+$h>schemeEndDate) "透析方案没在有效期内"
	s status=$lg(^DHCBPPatRegister(registerId),14)
	q:(status'="N") "病人已经转归,无法安排透析计划"
	s count=0
	&sql(select count(*) into :count from dhc_bp_arrangescheme where BPAS_BPScheme_Dr=:schemeId 
	and ((BPAS_IfActive='Y' and BPAS_IfAbandon='Y' and BPAS_IsTemporary!='Y') OR ((BPAS_IfActive='N' OR BPAS_IfActive is null) and (BPAS_IfAbandon='N' OR  BPAS_IfAbandon is null))))
	q:count>0 "方案做过更改"
	TSTART
	s effectDate=""
	&sql(select min(BPAS_EffectDate) into :effectDate from dhc_bp_arrangescheme where BPAS_BPScheme_Dr=:schemeId)
	s curDate=+$h
	i (effectDate'="")&(effectDate<+$h)  s curDate=effectDate
	s id=""
    f  s id=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,id)) q:id=""  d
    .q:$lg(^DHCBPArrangeScheme(id),9)'="Y"
    .s effectDate=$lg(^DHCBPArrangeScheme(id),10)
    .q:(effectDate'="")&(effectDate<+$h)
    .s ifAbandon=$lg(^DHCBPArrangeScheme(id),17)
    .q:ifAbandon="Y"
    .s isTemporary=$lg(^DHCBPArrangeScheme(id),19)
    .q:isTemporary="Y"
    .&sql(update DHC_BP_ArrangeScheme set BPAS_EffectDate=:curDate where %ID=:id)
    .i SQLCODE'=0 s result="更新生效时间时出错" 
    i +result'=1 TROLLBACK  q result   
    s result=..EditBPArrange(schemeId,userId,arrWeekCount)  
    i +result'=1 TROLLBACK  q result
    TCOMMIT
	q result
}

// w ##class(web.DHCBPArrangeScheme).InsertAllEffectiveSchemeArrange(221)

ClassMethod InsertAllEffectiveSchemeArrange(userId, arrWeekCount, EditType, effectDate As %String = "") As %String
{
	//where BPS_StartDate<:curDate and BPS_EndDate>:curDate
	s schemeId=""
	s result=0
	s curDate=+$h
	s endDate="",registerId=""
	&sql(declare C3 cursor for select BPS_RowId,BPS_BPRegister_Dr,BPS_EndDate into :schemeId,:registerId,:endDate from DHC_BP_Scheme where BPS_StartDate<=:curDate and BPS_EndDate>:curDate )
	&sql(open C3)
	&sql(fetch C3)
	while(SQLCODE=0)
	{
		b ;1
	  q:(schemeId="")!(schemeId=0)!(registerId="")!(registerId=0)
	  s status=$lg($g(^DHCBPPatRegister(registerId)),14)
	  i status'="D" d
	  .;s result=..EditBPArrange(schemeId,userId,arrWeekCount)
	  .i EditType="LaterDay" s result=..EditBPArrange(schemeId,userId,arrWeekCount)
	  .i EditType="ToDay" s result=..EditTodayBPArrange(schemeId,userId,arrWeekCount)
	  .i EditType="NextWeek" s result=..EditWeeklyBPArrange(schemeId,userId,arrWeekCount,effectDate)
	  &sql(fetch C3)
	  
	}
	&sql(close C3)
	q result
}

// w ##class(web.DHCBPArrangeScheme).EditBPArrange("37","221")

ClassMethod EditBPArrange(schemeId, userId, arrWeekCount) As %String
{
	s ^TMPzt("schemeId","test")=schemeId_"/"_userId_"/"_$h
	s registerId="",schemeStartDate="",schemeEndDate=""
	&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	q:registerId="" -1
	q:(+$h<schemeStartDate)!(+$h>schemeEndDate) "透析方案没在有效期内"
	i schemeId="" b ;scheme is null
	;s cycle=..GetWeekCycle(schemeId)
	;q:cycle<0 -2
	;s cycle=2
	i (+arrWeekCount=0)||(+arrWeekCount=2) s cycle=2
	e  s cycle=1
	k ARRANGE
    k CONSUMABLE
	TSTART
	s fromDate=$h+1
	//i $zd(+$h,10)=5 s fromDate=$h+3 
	s weekDay=$zd(fromDate,10)
	i $zd(+$h,10)=0 s weekDay=8
	i weekDay=0 s weekDay=7    ///by wq 周六与周日当天生成排班时算第一周
	s SQLCODE=0
	s curDate=fromDate-1
	s n=2 //安排两周内的排班
	f i=weekDay:1:7*n q:((SQLCODE'=0)&(SQLCODE'=100))  d
	.s curDate=curDate+1
	.s arrangeWeekDay=i#7
	.;i arrangeWeekDay=0 s arrangeWeekDay=7       by wq 20170809  星期日系统时间是0
	.s arrangeSchemeId=""
	.f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:(arrangeSchemeId="")!((SQLCODE'=0)&(SQLCODE'=100))  d
	..s effectDate=$lg(^DHCBPArrangeScheme(arrangeSchemeId),10)
	..q:effectDate=""
	..s ifActive=$lg(^DHCBPArrangeScheme(arrangeSchemeId),9)
	..q:ifActive'="Y"
	..s ifAbandon=$lg(^DHCBPArrangeScheme(arrangeSchemeId),17)
	..q:ifAbandon="Y"
	..s asWeekSeqNo=$lg(^DHCBPArrangeScheme(arrangeSchemeId),6)
	..s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
	..s asDaySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..;s weekSeqNo=(curDate-effectDate)\7+1
	..s effectWeekDay=$zd(effectDate,10)
	..s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	..s virWeekSeqNo=(curDate-virtualEffectDate)\7+1
	..;s remainder=weekSeqNo#cycle
	..s remainder=virWeekSeqNo#cycle
	..i remainder=0 s cirWeekSeq=cycle
	..e  s cirWeekSeq=remainder
	..q:asWeekSeqNo'=cirWeekSeq
	..q:asWeekDay'=arrangeWeekDay
	..q:curDate>schemeEndDate         ///0818 透析方案结束日期之后的计划不生成
	..s registerId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),1)
	..s schemeId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),2)
	..s dialysisMethodId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)
	..s bedId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),5)
	..s daySeqCode=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..s mainArrangeSchemeDr=$lg(^DHCBPArrangeScheme(arrangeSchemeId),11)
	..s isTemporary=$lg(^DHCBPArrangeScheme(arrangeSchemeId),19)
    ..q:isTemporary="Y"
    ..s arrangeId="",needCount=0,bpaDocOperateStatus="",bpabedId="",status="A"
    ..&sql(select BPA_RowId,BPA_BPCBed_Dr,BPA_Status,count(*) into :arrangeId,:bpabedId,:status,:needCount from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	..i needCount=0 s arrangeId=""
	..i arrangeId'="" d
    ...s bpaDocOperateStatus=$lg(^DHCBPArrange(arrangeId),55)
    ...s bedId=bpabedId
	..q:bpaDocOperateStatus'="" //医生透析前保存后过滤（透析耗材）
	..i (mainArrangeSchemeDr="")!(mainArrangeSchemeDr="0") d
	...k PLIST
	...s PLIST(2)=registerId
	...s PLIST(4)=schemeId
	...s PLIST(5)=curDate
	...s PLIST(7)=daySeqCode
	...s PLIST(8)=bedId
	...s PLIST(9)="M"
	...i (bedId'=0)&(bedId'="") d
	....s PLIST(10)="R"
	....s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    ....s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    ....s PLIST(26)=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)  
	...e  s PLIST(10)="A"
	...s PLIST(27)=dialysisMethodId
	...s PLIST(89)=userId
	...s PLIST(90)=+$h
	...s PLIST(91)=$p($h,",",2)
	...//s bedId=""
	...//s status="A"
	...i arrangeId="" d
	....&SQL(insert into DHC_BP_Arrange Values :PLIST())
	....s ARRANGE($g(%ROWID))=PLIST(10)
	...e  d
	....s PLIST(8)=bedId
	....s PLIST(10)=status
	....i (bedId'=0)&(bedId'="") s PLIST(10)="R"
	....i (status="R")!(status="A") s ARRANGE(arrangeId)=PLIST(10)
	....&SQL(update DHC_BP_Arrange Values :PLIST() where BPA_RowId=:arrangeId and (BPA_Status='A' or BPA_Status='R'))
	...s arrangeId=$g(%ROWID)
	...s MAINSCHEME(arrangeSchemeId)=arrangeId
	...s schemeConsumaleId=""
	...f  s schemeConsumaleId=$o(^DHCBPSchemeConsumable(0,"ArrangeScheme",arrangeSchemeId,schemeConsumaleId)) q:schemeConsumaleId=""  d
	....s consumableId=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),2)
	....s type=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),3)
	....s ifAbandon=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),6)
	....q:ifAbandon="Y"
	....if arrangeId'="" s CONSUMABLE(arrangeId,consumableId)=type
	..e  d
	...s ADDITIONL(arrangeSchemeId)=mainArrangeSchemeDr_"^"_dialysisMethodId		
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(ADDITIONL(arrangeSchemeId)) q:arrangeSchemeId=""  d
	.s mainArrangeSchemeDr=$p(ADDITIONL(arrangeSchemeId),"^",1)
	.s dialysisMethodId=$p(ADDITIONL(arrangeSchemeId),"^",2)
	.s arrangeId=$g(MAINSCHEME(mainArrangeSchemeDr))
	.q:arrangeId=""
	.&SQL(update DHC_BP_Arrange set BPA_SecondBPCBPMode_Dr=:dialysisMethodId where BPA_RowId=:arrangeId)
	s curDate=+$h
	&sql(update DHC_BP_Arrange set BPA_Status='D' where BPA_Date>=:fromDate and BPA_BPScheme_Dr=:schemeId and (BPA_Status='A' OR BPA_Status='R') and BPA_ArrangeType='M' and BPA_DocOperateStatus="")
	s arrangeId=""
	f  s arrangeId=$o(ARRANGE(arrangeId)) q:arrangeId=""  d	
	.s status=ARRANGE(arrangeId)
	.;s ^TMPzt("ARRANGE",arrangeId)=status
	.b ;status
	.&sql(update DHC_BP_Arrange set BPA_Status=:status where BPA_RowId=:arrangeId)
	i ((SQLCODE'=0)&(SQLCODE'=100)) TROLLBACK  q "更新安排表状态时出错"
	s result=1
	s arrangeId=""
	f  s arrangeId=$o(CONSUMABLE(arrangeId)) q:(arrangeId="")!(+result'="1")  d
	.s paraStr=""
	.s consumableId=""
	.f  s consumableId=$o(CONSUMABLE(arrangeId,consumableId)) q:consumableId=""  d
	..s type=CONSUMABLE(arrangeId,consumableId)
	..i paraStr="" s paraStr="$"_consumableId_"$"_type_"$"_"1"
	..e  s paraStr=paraStr_"&"_"$"_consumableId_"$"_type_"$"_"1"
	..s result=##class(web.DHCBPArrange).SaveArrangeConsumableList(arrangeId,paraStr)
	i +result'=1 TROLLBACK  q "保存透析耗材错误"
	TCOMMIT
	q result
}

// w ##class(web.DHCBPArrangeScheme).BindingBedToArrangeScheme("448","0")

ClassMethod BindingBedToArrangeScheme(arrangeId As %String, isBinding As %String) As %String
{
	//s ^TMPzt("arrangeId?")=arrangeId_"/"_isBinding
	s result=0
	s schemeId="",curDate="",bedId=""
	&sql(select BPA_BPScheme_Dr,BPA_Date,BPA_BPCBed_Dr into :schemeId,:curDate,:bedId from DHC_BP_Arrange where BPA_RowId=:arrangeId)
	q:schemeId="" "无透析方案"
	&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	i isBinding="0" s bedId=""
	q:registerId="" -1
	q:(curDate<schemeStartDate)!(curDate>schemeEndDate) "透析方案已过期"
	s cycle=..GetWeekCycle(schemeId)
	w cycle,!
	q:cycle<0 "没有透析计划，不能绑定床位！"
	s weekDay=$zd(curDate,10)
	TSTART
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId))  q:arrangeSchemeId=""  d
	.s effectDate=$lg(^DHCBPArrangeScheme(arrangeSchemeId),10)
	.q:effectDate=""
	.s asWeekSeqNo=$lg(^DHCBPArrangeScheme(arrangeSchemeId),6)
	.s effectWeekDay=$zd(effectDate,10)
	.s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	.s virWeekSeqNo=(curDate-virtualEffectDate)\7+1	
	.s remainder=virWeekSeqNo#cycle
	.i remainder=0 s cirWeekSeq=cycle
	.e  s cirWeekSeq=remainder
	.q:asWeekSeqNo'=cirWeekSeq
	.s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
	.q:weekDay'=asWeekDay
	.s result=1
	.&sql(update dhc_bp_arrangescheme set BPAS_BedDr=:bedId where %ID=:arrangeSchemeId)
	i SQLCODE'=0 TROLLBACK  q -1	
	TCOMMIT
	q result
}

// w ##class(web.DHCBPArrangeScheme).GetBedStatus("1","2014-09-04")

ClassMethod GetBedStatus(bedId, curDate, dayPart) As %String
{
	s bedStatus="I"
	s date=##class(web.DHCClinicCom).ConvertToDateH(curDate)
	s weekDay=$zd(date,10)
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"BedDay",bedId,"Y",weekDay,arrangeSchemeId)) q:arrangeSchemeId=""  d
	.s arrangeScheme=^DHCBPArrangeScheme(arrangeSchemeId)
	.s schemeId=$lg(arrangeScheme,2)
	.q:schemeId=""
	.q:($lg(arrangeScheme,17)="Y")
	.s registerId="",schemeStartDate="",schemeEndDate=""
	.&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	.q:registerId=""
	.q:'$d(^DHCBPPatRegister(registerId))
	.s bpprStatus=$lg(^DHCBPPatRegister(registerId),14)
	.q:bpprStatus="D"
	.q:(date<schemeStartDate)!(date>=schemeEndDate)
	.s effectDate=$lg(arrangeScheme,10)
	.q:effectDate>date	
    .s cycOrdinalWeek=..GetCycOrdinalWeek(schemeId,date,effectDate)
    .s weekSeqNo=$lg(arrangeScheme,6)
    .q:cycOrdinalWeek'=weekSeqNo
    .s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
    .q:asWeekDay'=weekDay
    .s daySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
    .i dayPart="AM" s dayPart="A"
    .i dayPart="PM" s dayPart="P"
    .i dayPart="Evening" s dayPart="E"
    .q:dayPart'=daySeq
    .s bedStatus="O"
    q bedStatus
}

// w ##class(web.DHCBPArrangeScheme).GetRegisterDrByBed("1","2016-10-17","A")

ClassMethod GetRegisterDrByBed(bedId, curDate, dayPart) As %String
{
	s registerDr=""
	s date=##class(web.DHCClinicCom).ConvertToDateH(curDate)
	s weekDay=$zd(date,10)
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"BedDay",bedId,"Y",weekDay,arrangeSchemeId)) q:arrangeSchemeId=""  d
	.s arrangeScheme=^DHCBPArrangeScheme(arrangeSchemeId)
	.s schemeId=$lg(arrangeScheme,2)
	.q:schemeId=""
	.q:($lg(arrangeScheme,17)="Y")
	.s registerId="",schemeStartDate="",schemeEndDate=""
	.&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	.q:registerId=""
	.q:'$d(^DHCBPPatRegister(registerId))
	.s bpprStatus=$lg(^DHCBPPatRegister(registerId),14)
	.q:bpprStatus="D"
	.q:(date<schemeStartDate)!(date>=schemeEndDate)
	.b ;1
	.s effectDate=$lg(arrangeScheme,10)
	.q:effectDate>date	
    .s cycOrdinalWeek=..GetCycOrdinalWeek(schemeId,date,effectDate)
    .s weekSeqNo=$lg(arrangeScheme,6)
    .q:cycOrdinalWeek'=weekSeqNo
    .b ;2
    .s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
    .q:asWeekDay'=weekDay
    .b ;3
    .s daySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
    .i dayPart="AM" s dayPart="A"
    .i dayPart="PM" s dayPart="P"
    .i dayPart="Evening" s dayPart="E"
    .q:dayPart'=daySeq
    .s registerDr=registerId
    q registerDr
}

// w ##class(web.DHCBPArrangeScheme).GetWeekCycle(101)

ClassMethod GetWeekCycle(schemeId As %String) As %Integer
{
	s cycle1=0,cycle2=0
	s weekSeqNo=0
	&sql(declare C2 cursor for select BPAS_WeekSeqNo into :weekSeqNo from DHC_BP_ArrangeScheme where BPAS_BPScheme_Dr=:schemeId and BPAS_IfActive='Y' and (BPAS_MainBPAS_Dr is null OR BPAS_MainBPAS_Dr=0) )
	&sql(open C2)
	&sql(fetch C2)
	while(SQLCODE=0)
	{
	  i weekSeqNo=1 s cycle1=1
	  i weekSeqNo=2 s cycle2=1
	  &sql(fetch C2)	
	}
	&sql(close C2)
	s cycle=0
	i (cycle1)!(cycle2) s cycle=1
	i (cycle1)&(cycle2) s cycle=2	
	q:'cycle -2
	q cycle
}

ClassMethod GetCycOrdinalWeek(schemeId As %String, curDate As %Date, effectDate As %Date) As %Integer
{
	s cycle=..GetWeekCycle(schemeId)
	s weekSeqNo=(curDate-effectDate)\7+1
	s effectWeekDay=$zd(effectDate,10)
	s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	s virWeekSeqNo=(curDate-virtualEffectDate)\7+1
	s remainder=virWeekSeqNo#cycle
	i remainder=0 s ordinalWeek=cycle
	e  s ordinalWeek=remainder
	q ordinalWeek
}

/// 获取最新透析方式
ClassMethod GetBPCModeDesc(bpprId As %String, needNote As %String = "") As %String
{
	q:bpprId=""
	s bpasId="",retStr=""		
	f  s bpasId=$o(^DHCBPArrangeScheme(0,"Register",bpprId,bpasId)) q:bpasId=""  d
	.s bpcBPModeRowId=$lg(^DHCBPArrangeScheme(bpasId),3)
	.q:bpcBPModeRowId=""
	.q:$lg(^DHCBPArrangeScheme(bpasId),17)="Y"
	.s bpcBPModeDesc=$lg(^DHCBPC("BloodPurificationMode",bpcBPModeRowId),2)
	.q:(bpcBPModeDesc'="")&&(needNote'="")&&(("^"_needNote_"^")'[("^"_bpcBPModeDesc_"^"))
	.s retStr=bpcBPModeDesc
	q retStr
}

/// w ##class(web.DHCBPArrangeScheme).EditTodayBPArrange(101)
/// 补齐当日透析计划安排
ClassMethod EditTodayBPArrange(schemeId, userId, arrWeekCount) As %String
{
	//s ^dhctmpmfc(schemeId,userId)=schemeId_"/"_userId	
	s registerId="",schemeStartDate="",schemeEndDate=""
	&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	q:registerId="" -1
	q:(+$h<schemeStartDate)!(+$h>schemeEndDate) "透析方案没在有效期内"
	i schemeId="" b ;scheme is null
	;s cycle=..GetWeekCycle(schemeId)
	;q:cycle<0 -2
	;s cycle=2
	i (+arrWeekCount=0)||(+arrWeekCount=2) s cycle=2
	e  s cycle=1
	k ARRANGE
    k CONSUMABLE
	TSTART
	s fromDate=$h
	s weekDay=$zd(fromDate,10)
	i $zd(+$h,10)=0 s weekDay=8
	i weekDay=0 s weekDay=7
	s SQLCODE=0
	s curDate=fromDate-1
	//s n=2 //安排两周内的排班
	f i=weekDay:1:weekDay q:((SQLCODE'=0)&(SQLCODE'=100))  d
	.s curDate=curDate+1
	.s arrangeWeekDay=i#7
	.s arrangeSchemeId=""
	.f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:(arrangeSchemeId="")!((SQLCODE'=0)&(SQLCODE'=100))  d
	..s effectDate=$lg(^DHCBPArrangeScheme(arrangeSchemeId),10)
	..q:effectDate=""
	..s ifActive=$lg(^DHCBPArrangeScheme(arrangeSchemeId),9)
	..q:ifActive'="Y"
	..s ifAbandon=$lg(^DHCBPArrangeScheme(arrangeSchemeId),17)
	..q:ifAbandon="Y"
	..s asWeekSeqNo=$lg(^DHCBPArrangeScheme(arrangeSchemeId),6)
	..s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
	..s asDaySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..;s weekSeqNo=(curDate-effectDate)\7+1
	..s effectWeekDay=$zd(effectDate,10)
	..s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	..s virWeekSeqNo=(curDate-virtualEffectDate)\7+1
	..;s remainder=weekSeqNo#cycle
	..s remainder=virWeekSeqNo#cycle
	..i remainder=0 s cirWeekSeq=cycle
	..e  s cirWeekSeq=remainder
	..q:asWeekSeqNo'=cirWeekSeq
	..q:asWeekDay'=arrangeWeekDay
	..q:curDate>schemeEndDate         ///0818 透析方案结束日期之后的计划不生成
	..s registerId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),1)
	..s schemeId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),2)
	..s dialysisMethodId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)
	..s bedId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),5)
	..s daySeqCode=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..s mainArrangeSchemeDr=$lg(^DHCBPArrangeScheme(arrangeSchemeId),11)
	..s isTemporary=$lg(^DHCBPArrangeScheme(arrangeSchemeId),19)
    ..q:isTemporary="Y"
	..i (mainArrangeSchemeDr="")!(mainArrangeSchemeDr="0") d
	...k PLIST
	...s PLIST(2)=registerId
	...s PLIST(4)=schemeId
	...s PLIST(5)=curDate
	...s PLIST(7)=daySeqCode
	...s PLIST(8)=bedId
	...s PLIST(9)="M"
	...i (bedId'=0)&(bedId'="") d
	....s PLIST(10)="R"
	....s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    ....s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    ....s PLIST(26)=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)  
	...e  s PLIST(10)="A"
	...s PLIST(27)=dialysisMethodId
	...s PLIST(89)=userId
	...s PLIST(90)=+$h
	...s PLIST(91)=$p($h,",",2)
	...s arrangeId=""
	...s bedId=""
	...s status="A"
	...s needCount=0
	...;&sql(select BPA_RowId,BPA_BPCBed_Dr,BPA_Status into :arrangeId,:bedId,:status from DHC_BP_Arrange where BPA_BPScheme_Dr=:schemeId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D') 
	...&sql(select BPA_RowId,BPA_BPCBed_Dr,BPA_Status,count(*) into :arrangeId,:bedId,:status,:needCount from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	...;&sql(select count(*) into :ccc from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D') 
	...i needCount=0 s arrangeId=""
	...i arrangeId="" d
	....&SQL(insert into DHC_BP_Arrange Values :PLIST())
	....s arrangeId=$g(%ROWID)
	...s MAINSCHEME(arrangeSchemeId)=arrangeId
	...s schemeConsumaleId=""
	...f  s schemeConsumaleId=$o(^DHCBPSchemeConsumable(0,"ArrangeScheme",arrangeSchemeId,schemeConsumaleId)) q:schemeConsumaleId=""  d
	....s consumableId=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),2)
	....s type=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),3)
	....s ifAbandon=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),6)
	....q:ifAbandon="Y"
	....s CONSUMABLE(arrangeId,consumableId)=type
	..e  d
	...s ADDITIONL(arrangeSchemeId)=mainArrangeSchemeDr_"^"_dialysisMethodId		
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(ADDITIONL(arrangeSchemeId)) q:arrangeSchemeId=""  d
	.s mainArrangeSchemeDr=$p(ADDITIONL(arrangeSchemeId),"^",1)
	.s dialysisMethodId=$p(ADDITIONL(arrangeSchemeId),"^",2)
	.s arrangeId=$g(MAINSCHEME(mainArrangeSchemeDr))
	.q:arrangeId=""
	.&SQL(update DHC_BP_Arrange set BPA_SecondBPCBPMode_Dr=:dialysisMethodId where BPA_RowId=:arrangeId)
	s result=1
	s arrangeId=""
	f  s arrangeId=$o(CONSUMABLE(arrangeId)) q:(arrangeId="")!(+result'="1")  d
	.s paraStr=""
	.s consumableId=""
	.f  s consumableId=$o(CONSUMABLE(arrangeId,consumableId)) q:consumableId=""  d
	..s type=CONSUMABLE(arrangeId,consumableId)
	..i paraStr="" s paraStr="$"_consumableId_"$"_type_"$"_"1"
	..e  s paraStr=paraStr_"&"_"$"_consumableId_"$"_type_"$"_"1"
	..s result=##class(web.DHCBPArrange).SaveArrangeConsumableList(arrangeId,paraStr)
	i +result'=1 TROLLBACK  q "保存透析耗材错误"
	TCOMMIT
	q result
}

// w ##class(web.DHCBPArrangeScheme).GetArrangeType("5","2019-03-07","A")

ClassMethod GetArrangeType(bedId, curDate, dayPart) As %String
{
	s ArrangeType="M"
	s date=##class(web.DHCClinicCom).ConvertToDateH(curDate)
	s arrangeId=""
	f  s arrangeId=$o(^DHCBPArrange(0,"Date",date,arrangeId)) q:arrangeId=""  d
	.q:bedId'=$lg(^DHCBPArrange(arrangeId),7)
	.q:dayPart'=$lg(^DHCBPArrange(arrangeId),6)
	.s ArrangeType=$lg(^DHCBPArrange(arrangeId),8)
    q ArrangeType
}

ClassMethod GetRegisterInfection(bedId, curDate, dayPart) As %String
{
	s Infection=""
	s date=##class(web.DHCClinicCom).ConvertToDateH(curDate)
	s arrangeId=""
	f  s arrangeId=$o(^DHCBPArrange(0,"Date",date,arrangeId)) q:arrangeId=""  d
	.q:bedId'=$lg(^DHCBPArrange(arrangeId),7)
	.q:dayPart'=$lg(^DHCBPArrange(arrangeId),6)
	.s registerId=$lg(^DHCBPArrange(arrangeId),1)
	.s Infection=$lg(^DHCBPPatRegister(registerId),20)
    q Infection
}

// w ##class(web.DHCBPArrangeScheme).EditWeeklyBPArrange("5","5286",2)

// 周排班使用

ClassMethod EditWeeklyBPArrange(schemeId, userId, arrWeekCount, standDate) As %String
{
	s ^TMPzt("schemeId","test")=schemeId_"/"_userId_"/"_$h
	s registerId="",schemeStartDate="",schemeEndDate=""
	&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme
	where BPS_RowId=:schemeId)
	q:registerId="" -1
	q:(+$h<schemeStartDate)!(+$h>schemeEndDate) "透析方案没在有效期内"
	i schemeId="" b ;scheme is null
	;s cycle=..GetWeekCycle(schemeId)
	;q:cycle<0 -2
	;s cycle=2
	i (+arrWeekCount=0)||(+arrWeekCount=2) s cycle=2
	e  s cycle=1
	k ARRANGE
    k CONSUMABLE
	TSTART
	
	s fromDate=$h-$zd($h,10)+8
	//i $zd(+$h,10)=5 s fromDate=$h+3 
	s weekDay=$zd(fromDate,10)
	s SQLCODE=0
	s curDate=fromDate-1
	s n=2 //安排两周内的排班
	f i=weekDay:1:7*n q:((SQLCODE'=0)&(SQLCODE'=100))  d
	.s curDate=curDate+1
	.s arrangeWeekDay=i#7
	.;i arrangeWeekDay=0 s arrangeWeekDay=7       by wq 20170809  星期日系统时间是0
	.s arrangeSchemeId=""
	.f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:(arrangeSchemeId="")!((SQLCODE'=0)&(SQLCODE'=100))  d
	..s effectDate=$lg(^DHCBPArrangeScheme(arrangeSchemeId),10)
	..q:effectDate=""
	..s ifActive=$lg(^DHCBPArrangeScheme(arrangeSchemeId),9)
	..q:ifActive'="Y"
	..s ifAbandon=$lg(^DHCBPArrangeScheme(arrangeSchemeId),17)
	..q:ifAbandon="Y"
	..s asWeekSeqNo=$lg(^DHCBPArrangeScheme(arrangeSchemeId),6)
	..s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
	..s asDaySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..;s weekSeqNo=(curDate-effectDate)\7+1
	..s effectWeekDay=$zd(effectDate,10)
	..//s virtualEffectDate=effectDate-effectWeekDay+1   //-- 20200402  //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	..s standDate=##class(web.DHCClinicCom).ConvertToDateH(standDate)
	..//s standDate="65470"   // 这个时间固定 按照2020-04-01所在周作为第一周进行循环 同getServerWeekSeqNo中显示一致 修改需同步
	..s standWeekDay=$zd(standDate,10)
	..s virtualEffectDate=standDate-standWeekDay+1  // -- 20200402
	..s virWeekSeqNo=(curDate-virtualEffectDate)\7+1   //计算当天是第几周
	..;s remainder=weekSeqNo#cycle
	..s remainder=virWeekSeqNo#cycle    
	..i remainder=0 s cirWeekSeq=cycle  //0是第二周
	..e  s cirWeekSeq=remainder    //1是第一周
	..;i arrangeSchemeId=15  b 
	..q:asWeekSeqNo'=cirWeekSeq
	..q:asWeekDay'=arrangeWeekDay
	..q:curDate>schemeEndDate         ///0818 透析方案结束日期之后的计划不生成
	..s registerId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),1)
	..s schemeId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),2)
	..s dialysisMethodId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),3)
	..s bedId=$lg(^DHCBPArrangeScheme(arrangeSchemeId),5)
	..s daySeqCode=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
	..s mainArrangeSchemeDr=$lg(^DHCBPArrangeScheme(arrangeSchemeId),11)
	..s isTemporary=$lg(^DHCBPArrangeScheme(arrangeSchemeId),19)
    ..q:isTemporary="Y"
    ..
	..i (mainArrangeSchemeDr="")!(mainArrangeSchemeDr="0") d
	...k PLIST
	...s PLIST(2)=registerId
	...s PLIST(4)=schemeId
	...s PLIST(5)=curDate
	...s PLIST(7)=daySeqCode
	...s PLIST(8)=bedId
	...s PLIST(9)="M"
	...i (bedId'=0)&(bedId'="") d
	....s PLIST(10)="R"
	....s bpBedEquipDr=$o(^DHCBPBedEquip(0,"Bed",+bedId,"")) //净化设备
    ....s bpEquipDr=$lg($g(^DHCBPBedEquip(+bpBedEquipDr)),2)
    ....s PLIST(26)=##class(User.DHCBPCEquip).%OpenId(bpEquipDr)  
	...e  s PLIST(10)="A"
	...s PLIST(27)=dialysisMethodId
	...s PLIST(89)=userId
	...s PLIST(90)=+$h
	...s PLIST(91)=$p($h,",",2)
	...s arrangeId=""
	...;s bedId=""
	...s status="A"
	...s needCount=0
	...i (bedId'=0)&(bedId'="") d
	....&SQL(update DHC_BP_Arrange set BPA_Status='D' where BPA_BPCBed_Dr=:bedId and BPA_Date=:curDate AND BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	...;&sql(select BPA_RowId,BPA_BPCBed_Dr,BPA_Status into :arrangeId,:bedId,:status from DHC_BP_Arrange where BPA_BPScheme_Dr=:schemeId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D') 
	...&sql(select BPA_RowId,BPA_Status,count(*) into :arrangeId,:status,:needCount from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D')
	...;&sql(select count(*) into :ccc from DHC_BP_Arrange where BPA_BPPatRegister_Dr=:registerId and BPA_Date=:curDate and BPA_DaySeqNo=:daySeqCode and BPA_Status<>'D') 
	...i needCount=0 s arrangeId=""
    ...
	...i arrangeId="" d
	....&SQL(insert into DHC_BP_Arrange Values :PLIST())
	....s ARRANGE($g(%ROWID))=PLIST(10)
	...e  d
	....s PLIST(8)=bedId
	....s PLIST(10)=status
	....i (bedId'=0)&(bedId'="") s PLIST(10)="R"
	....i (status="R")!(status="A") s ARRANGE(arrangeId)=PLIST(10)
	....i arrangeSchemeId=15 b ;2
	....&SQL(update DHC_BP_Arrange Values :PLIST() where BPA_RowId=:arrangeId and (BPA_Status='A' or BPA_Status='R'))
	...s arrangeId=$g(%ROWID)
	...s MAINSCHEME(arrangeSchemeId)=arrangeId
	...s schemeConsumaleId=""
	...f  s schemeConsumaleId=$o(^DHCBPSchemeConsumable(0,"ArrangeScheme",arrangeSchemeId,schemeConsumaleId)) q:schemeConsumaleId=""  d
	....s consumableId=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),2)
	....s type=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),3)
	....s ifAbandon=$lg(^DHCBPSchemeConsumable(schemeConsumaleId),6)
	....q:ifAbandon="Y"
	....if arrangeId'="" s CONSUMABLE(arrangeId,consumableId)=type
	..e  d
	...s ADDITIONL(arrangeSchemeId)=mainArrangeSchemeDr_"^"_dialysisMethodId		
	s arrangeSchemeId=""
	f  s arrangeSchemeId=$o(ADDITIONL(arrangeSchemeId)) q:arrangeSchemeId=""  d
	.s mainArrangeSchemeDr=$p(ADDITIONL(arrangeSchemeId),"^",1)
	.s dialysisMethodId=$p(ADDITIONL(arrangeSchemeId),"^",2)
	.s arrangeId=$g(MAINSCHEME(mainArrangeSchemeDr))
	.q:arrangeId=""
	.&SQL(update DHC_BP_Arrange set BPA_SecondBPCBPMode_Dr=:dialysisMethodId where BPA_RowId=:arrangeId)
	s curDate=+$h
	&sql(update DHC_BP_Arrange set BPA_Status='D' where BPA_Date>=:fromDate and BPA_BPScheme_Dr=:schemeId and (BPA_Status='A' OR BPA_Status='R') and BPA_ArrangeType='M')
	s arrangeId=""
	f  s arrangeId=$o(ARRANGE(arrangeId)) q:arrangeId=""  d	
	.s status=ARRANGE(arrangeId)
	.&sql(update DHC_BP_Arrange set BPA_Status=:status where BPA_RowId=:arrangeId)
	i ((SQLCODE'=0)&(SQLCODE'=100)) TROLLBACK  q "更新安排表状态时出错"
	s result=1
	s arrangeId=""
	f  s arrangeId=$o(CONSUMABLE(arrangeId)) q:(arrangeId="")!(+result'="1")  d
	.s paraStr=""
	.s consumableId=""
	.f  s consumableId=$o(CONSUMABLE(arrangeId,consumableId)) q:consumableId=""  d
	..s type=CONSUMABLE(arrangeId,consumableId)
	..i paraStr="" s paraStr="$"_consumableId_"$"_type_"$"_"1"
	..e  s paraStr=paraStr_"&"_"$"_consumableId_"$"_type_"$"_"1"
	..s result=##class(web.DHCBPArrange).SaveArrangeConsumableList(arrangeId,paraStr)
	i +result'=1 TROLLBACK  q "保存透析耗材错误"
	TCOMMIT
	q result
}

/// w ##class(web.DHCBPArrangeScheme).UpdateArrangeSchemeTemplet(11)
ClassMethod UpdateArrangeSchemeTemplet(arrangeSchemeTempletBedId As %String, arrangeSchemeTempletDaySeqCode As %String, arrangeSchemeTempletWeekSeq As %String, arrangeSchemeTempletWeekDay As %String) As %String
{
	;q:arrangeSchemeTempletId=""
	s result=1
	TSTART
	s SQLCODE=0
	k PLIST
	s null=""
	s PLIST(6)=null
	s PLIST(7)=null
	s PLIST(8)=null
	s PLIST(9)=null
	s PLIST(10)=null
	s PLIST(11)=null
	s PLIST(12)=null
	&sql(update DHC_BP_ArrangeScheme Values :PLIST() where BPAS_BedDr=:arrangeSchemeTempletBedId and BPAS_DaySeqNo=:arrangeSchemeTempletDaySeqCode and BPAS_WeekSeqNo=:arrangeSchemeTempletWeekSeq and BPAS_WeekDay=:arrangeSchemeTempletWeekDay)
	i (SQLCODE'=0)&(SQLCODE'=100) s result="更新计划表错误"_SQLCODE
    i +result'=1 TROLLBACK  q result
	TCommit
	q result
}

/// w ##class(web.DHCBPArrangeScheme).SaveArrangeSchemeTemplet("5$c(3)2$c(3)240$c(3)2$c(3)$c(3)$49$M$1$c(3)$c(3)无$c(3)0$c(3)0$c(3)0$c(3)0$c(3)0$c(3)7$c(3)8$c(3)1$c(3)4$c(3)A$c(3)9$c(3)Y$c(3)0^5$c(3)3$c(3)240$c(3)2$c(3)$c(3)$49$M$1$c(3)$c(3)无$c(3)0$c(3)0$c(3)0$c(3)0$c(3)0$c(3)9$c(3)8$c(3)1$c(3)4$c(3)A$c(3)$c(3)Y$c(3)0")
ClassMethod SaveArrangeSchemeTemplet(paraStr As %String, schemeId As %String) As %String
{
	 //s paraStr=^TMPzt("SaveArrangeScheme")
	 //s schemeId=30
	q:paraStr="" "0"
	q:schemeId="0" "0"
	s ^TMPzt("UPdate")=paraStr
	//s paraStr=^TMPzt("UPdate")
	s result=1
	TSTART
	s SQLCODE=0
	f i=1:1:$l(paraStr,"^") q:(+result'=1)  d
	.s singlePara=$p(paraStr,"^",i)
	.q:singlePara=""
	.s registerId=$p(singlePara,$c(3),1)
	.s dialysisMethodId=$p(singlePara,$c(3),2)
	.s therapyDuration=$p(singlePara,$c(3),3)
	.s anticoagulantModeId=$p(singlePara,$c(3),4)
	.s anticoagulantDrugPara=$p(singlePara,$c(3),5)
	.s consumableBusinessPara=$p(singlePara,$c(3),6)
	.s isTemporary=$p(singlePara,$c(3),7)
	.s filterReplaceMode=$p(singlePara,$c(3),8)
	.s filterReplaceAmount=$p(singlePara,$c(3),9)
	.s dialysateAmount=$p(singlePara,$c(3),10)
	.s singleInAmount=$p(singlePara,$c(3),11)
	.s exchangeTimes=$p(singlePara,$c(3),12)
	.s theLastReservation=$p(singlePara,$c(3),13)
	.s id=$p(singlePara,$c(3),14)
	.s BedId=$p(singlePara,$c(3),15)
	.s WeekSeq=$p(singlePara,$c(3),16)
	.s WeekDay=$p(singlePara,$c(3),17)
	.s daySeq=$p(singlePara,$c(3),18)
	.s mainArrangeSchemeDr=$p(singlePara,$c(3),19)
	.s ifActive=$p(singlePara,$c(3),20)
	.s effectDate=$p(singlePara,$c(3),21)
	.s ifAbandon=$p(singlePara,$c(3),22)
	.s totalAmountOfMachine=$p(singlePara,$c(3),23)
	.s count=0
	.&sql(select count(*) into :count from DHC_BP_ArrangeScheme where %ID=:mainArrangeSchemeDr)
	.q:(mainArrangeSchemeDr'="")&(count=0)
	.&sql(select BPS_BPRegister_Dr,BPS_StartDate,BPS_EndDate into :registerId,:schemeStartDate,:schemeEndDate from DHC_BP_Scheme where BPS_RowId=:schemeId)
	.i registerId="" s result=-1 q
	.i (+$h<schemeStartDate)!(+$h>schemeEndDate) s result="透析方案没在有效期内" q
	.s status=$lg(^DHCBPPatRegister(registerId),14)
	.i (status'="N") s result="病人已经转归,无法安排透析计划" q
	.s effectDate=##class(web.DHCClinicCom).ConvertToDateH(effectDate)
	.k PLIST
	.s PLIST(2)=registerId
	.s PLIST(3)=schemeId
	.s PLIST(4)=dialysisMethodId
	.s PLIST(6)=BedId
	.s PLIST(7)=WeekSeq
	.s PLIST(8)=WeekDay
	.s PLIST(9)=daySeq
	.s PLIST(10)=ifActive
	.s PLIST(11)=effectDate
    .s PLIST(12)=mainArrangeSchemeDr
	.s PLIST(18)=ifAbandon
	.b ;DHC_BP_ArrangeScheme
	.&sql(update DHC_BP_ArrangeScheme Values :PLIST() where %ID=:id)
	.i (SQLCODE'=0)&(SQLCODE'=100) s result="更新计划表错误"_SQLCODE
	.q:(SQLCODE'=0)&(SQLCODE'=100)
	.q:id=""
	.s result=..SaveSchemeConsumableList(id, consumableBusinessPara)
	.i +result'=1 s result="更新器材表错误"_result
	i +result'=1 Trollback  q result
	
	TCommit
	q 1
}

// d ##class(%ResultSet).RunQuery("web.DHCBPArrangeScheme","GetArrangeSchemeListTemplet","1")

// D ##class(%ResultSet).RunQuery("web.DHCBPArrangeScheme","GetArrangeSchemeListTemplet","2")

Query GetArrangeSchemeListTemplet(WeekSeqNo As %String, effectiveDate As %String) As %Query(ROWSPEC = "Id,RegisterId,SchemeId,DialysisMethodId,DialysisMethodDesc,BedId,WeekSeq,WeekDay,DaySeqCode,IfActive,MainArrangeSchemeDr,ConsumableId,SecondConsumableId,ThirdConsumableId,FourthConsumableId,TherapyDuration,IfAbandon,AnticoagulantModeId,IsTemporary,FilterReplaceMode,FilterReplaceAmount,DialysateAmount,SingleInAmount,ExchangeTimes,TheLastReservation,TotalAmountOfMachine,PatName,isExpiring")
{
}

ClassMethod GetArrangeSchemeListTempletExecute(ByRef qHandle As %Binary, WeekSeqNo As %String, effectiveDate As %String) As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$i(^CacheTemp)
	//If $g(ind)="" Set ind=1
	Set ind=1
	k ^TEMPASTemple($j)
	k ^TEMPASDTemple($j)
	S Id="",RegisterId="",SchemeId="",DialysisMethodId="",BedId="",WeekSeq="",WeekDay="",DaySeqCode="",IfActive="",PatName="",DialysisMethodDescStr=""
	S EffectDate="",MainArrangeSchemeDr="",ConsumableId="",SecondConsumableId="",ThirdConsumableId="",FourthConsumableId="",TherapyDuration="",IfAbandon="",AnticoagulantModeId=""
	S IsTemporary="",FilterReplaceMode="",FilterReplaceAmount="",DialysateAmount="",SingleInAmount="",ExchangeTimes="",TheLastReservation="",TotalAmountOfMachine="",ArrangeSchemeDr="",ArrangeId=""
	;s fromDate=$h-$zd($h,10)+8+8
	i WeekSeqNo=2 s fromDate=$h-$zd($h,10)+16 //下一周为单周，双周模板则是下下周
	e  s fromDate=$h-$zd($h,10)+8 //下一周默认为单周
	//i $zd(+$h,10)=5 s fromDate=$h+3 
	s weekDay=$zd(fromDate,10)
	s SQLCODE=0
	s cycle=2
	s curDate=fromDate
	S TempletId=""
	f  s TempletId=$o(^DHCBPArrangeScheme(TempletId)) q:TempletId=""  d
	.q:TempletId=0
	.S Id=TempletId
	.s WeekSeq=$lg(^DHCBPArrangeScheme(TempletId),6)
	.q:WeekSeq'=WeekSeqNo
	.s IfAbandon=$lg(^DHCBPArrangeScheme(TempletId),17)
	.q:IfAbandon'="N"
	.//i TempletId=15 b ;1
	.S RegisterId=$lg(^DHCBPArrangeScheme(TempletId),1)
	.S SchemeId=$lg(^DHCBPArrangeScheme(TempletId),2)
	.s SchemeEndDate=$lg(^DHCBPScheme(SchemeId),3)  // GY 20200511
	.q:SchemeEndDate<+$h // 判断模板方案是否已停止，依据截止日期对比
	.s isExpiring=0
	.i SchemeEndDate<=(+$h+7) s isExpiring=1   // 20200511 方案一旦停止，截止日期如果在服务器时间的一周内，提示用户
	.S DialysisMethodId=$lg(^DHCBPArrangeScheme(TempletId),3)
	.S DialysisMethodDesc=$lg($g(^DHCBPC("BloodPurificationMode",DialysisMethodId)),2)
	.S BedId=$lg(^DHCBPArrangeScheme(TempletId),5)
	.q:(BedId="")||(BedId=0)
	.S WeekDay=$lg(^DHCBPArrangeScheme(TempletId),7)
	.S DaySeqCode=$lg(^DHCBPArrangeScheme(TempletId),8)
	.S IfActive=$lg(^DHCBPArrangeScheme(TempletId),9)
	.//S EffectDate=$lg(^DHCBPArrangeScheme(TempletId),10)  // --20200401 20200402 注释 模板取消判断单双周
	.//s effectWeekDay=$zd(EffectDate,10)
	.//s virtualEffectDate=EffectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
	.//s virWeekSeqNo=(curDate-virtualEffectDate)\7+1   //计算当天是第几周
	.//s remainder=virWeekSeqNo#2 
	.//i remainder=0 s cirWeekSeq=cycle  //0是第二周
	.//e  s cirWeekSeq=remainder    //1是第一周
	.;q:cirWeekSeq'=WeekSeqNo
	.//q:WeekSeq'=cirWeekSeq
	.//S EffectDate=##class(web.DHCClinicCom).ConvertToDate(EffectDate)_" "_"00:00:00"
	.S EffectDate=""
	.S MainArrangeSchemeDr=$lg(^DHCBPArrangeScheme(TempletId),11)
	.S ConsumableId=$lg(^DHCBPArrangeScheme(TempletId),12)
	.S SecondConsumableId=$lg(^DHCBPArrangeScheme(TempletId),13)
	.S ThirdConsumableId=$lg(^DHCBPArrangeScheme(TempletId),14)
	.S FourthConsumableId=$lg(^DHCBPArrangeScheme(TempletId),15)
	.S TherapyDuration=$lg(^DHCBPArrangeScheme(TempletId),16)
	.S AnticoagulantModeId=$lg(^DHCBPArrangeScheme(TempletId),18)
	.S IsTemporary=$lg(^DHCBPArrangeScheme(TempletId),19)
	.S FilterReplaceMode=$lg(^DHCBPArrangeScheme(TempletId),20)
	.S FilterReplaceAmount=$lg(^DHCBPArrangeScheme(TempletId),21)
	.S DialysateAmount=$lg(^DHCBPArrangeScheme(TempletId),22)
	.S SingleInAmount=$lg(^DHCBPArrangeScheme(TempletId),23)
	.S ExchangeTimes=$lg(^DHCBPArrangeScheme(TempletId),24)
	.S TheLastReservation=$lg(^DHCBPArrangeScheme(TempletId),25)
	.S TotalAmountOfMachine=$lg(^DHCBPArrangeScheme(TempletId),26)
	.s papmiId=$lg(^DHCBPPatRegister(RegisterId),1)
	.q:papmiId="" 
	.q:'$d(^PAPER(papmiId,"PAT",1)) 
	.s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s ^TEMPASTemple($j,Id)=$lb(Id,RegisterId,SchemeId,DialysisMethodId,DialysisMethodDesc,BedId,WeekSeq,WeekDay,DaySeqCode,IfActive,MainArrangeSchemeDr,ConsumableId,SecondConsumableId,ThirdConsumableId,FourthConsumableId,TherapyDuration,IfAbandon,AnticoagulantModeId,IsTemporary,FilterReplaceMode,FilterReplaceAmount,DialysateAmount,SingleInAmount,ExchangeTimes,TheLastReservation,TotalAmountOfMachine,PatName,isExpiring)
	
	
	s Id="" f  s Id=$o(^TEMPASTemple($j,Id)) q:Id=""  d
	.do OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow           
	//set Data=$lb(Id,RegisterId,SchemeId,DialysisMethodId,BedId,WeekSeq,WeekDay,DaySeqCode,IfActive,EffectDate,MainArrangeSchemeDr,ConsumableId,SecondConsumableId,ThirdConsumableId,FourthConsumableId,TherapyDuration,IfAbandon,AnticoagulantModeId,IsTemporary,FilterReplaceMode,FilterReplaceAmount,DialysateAmount,SingleInAmount,ExchangeTimes,TheLastReservation,TotalAmountOfMachine,ArrangeSchemeDr,ArrangeId,PatName,DialysisMethodDescStr)
 	Set ^CacheTemp(repid,ind)=^TEMPASTemple($j,Id)
 	Set ind=ind+1
	quit
}

ClassMethod GetArrangeSchemeListTempletFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArrangeSchemeListTempletExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArrangeSchemeListTempletClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArrangeSchemeListTempletExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCBPArrangeScheme).GetPaAdmListByPatNoReg("","","0000000390")
ClassMethod GetPaAdmListByPatNoReg(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "")
{
	q:PapmiNo=""
	s outstr=""
    s PatmasID="0"
    
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    s PaadmType=""
    s tempdate=""
    s count=0
    f  s PaadmType=$o(^PAPERdr(PatmasID,"ADM",PaadmType))  q:(PaadmType="")||(count>0)  d
    .s PaadmRowID="0"
    .f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM",PaadmType,PaadmRowID)) q:(PaadmRowID="")||(count>0)  d
    ..s admdate=$p(^PAADM(PaadmRowID),"^",6)
    ..s admtime=$p(^PAADM(PaadmRowID),"^",7)
    ..s VisitStatus=$p(^PAADM(PaadmRowID),"^",20)
    ..s EstimDischargeDate=$p(^PAADM(PaadmRowID),"^",59)
    ..s EstimDischargetime=$p(^PAADM(PaadmRowID),"^",60)
    ..s EstimDischargetime=$p(^PAADM(PaadmRowID),"^",60)
    ..s DepDR=$p(^PAADM(PaadmRowID),"^",4)
    ..i tempdate<admdate d
    ...s tempdate=admdate
    ...i PaadmType="I" d
    ....q:(((VisitStatus="D")&(EstimDischargeDate<$h))||((VisitStatus="D")&(EstimDischargeDate=+$h)&(EstimDischargetime<$p($h,",",2))))
    ....s outstr=PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepDR),"^",2)
    ....s count=count+1
    ...e  d
    ....q:DepDR'=419
    ....s outstr=PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepDR),"^",2)
    ....s count=count+1
    q outstr
}

// 20200401

/// Description: 获取服务器当前时间所在周次 以20200401所在周次循环推断
/// w ##class(web.DHCBPArrangeScheme).getServerWeekSeqNo()
ClassMethod getServerWeekSeqNo(EffectiveDate As %String) As %String
{
	s result=""
	s standardDate=##class(web.DHCClinicCom).ConvertToDateH(EffectiveDate)
	//s standardDate=65470     // 20200401
	s standardWeek=$zd(standardDate,10)
	s standardDate=standardDate-standardWeek+1
	s curDate=+$h
	s curWeekSeqNo=(curDate-standardDate)\7+1   //计算当天是第几周
	s curWeekCycle=curWeekSeqNo#2 
	i curWeekCycle=0 s cirWeekSeq=2      //0是第二周
	e  s cirWeekSeq=curWeekCycle    //1是第一周
	i cirWeekSeq=1 s result="单周"
	e  i cirWeekSeq=2 s result="双周"
	q result
}

/// w ##class(web.DHCBPArrangeScheme).SaveArrangeSchemeForWeekly("2997"_$c(3)_"44"_$c(3)_"136"_$c(3)_"4"_$c(3)_"1"_$c(3)_"A")
ClassMethod SaveArrangeSchemeForWeekly(bedArrangePara As %String) As %String
{
	s ^TMPzt("SaveBPBedArrange")=bedArrangePara
	//s bedArrangePara=^TMPzt("SaveBPBedArrange")
	q:(bedArrangePara="") "参数为空"
	s arrangeId=$p(bedArrangePara,$c(3),1)
	q:arrangeId="" "安排表id为空"
    s result="",arrange=""
    s arrangeScheme=##class(User.DHCBPArrangeScheme).%OpenId(arrangeId)
    s registerId=$p(bedArrangePara,$c(3),2)
    q:registerId="" "登记表id为空"	    
    i (registerId'="") s arrangeScheme.BPASBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    
	s bedId=$p(bedArrangePara,$c(3),3)
	s WeekDay=$p(bedArrangePara,$c(3),4)
	s WeekSeq=$p(bedArrangePara,$c(3),5)
	
    s daySeqNo=$p(bedArrangePara,$c(3),6)
    s arrangeScheme.BPASWeekSeqNo=WeekSeq
    s arrangeScheme.BPASWeekDay=WeekDay
    s arrangeScheme.BPASDaySeqNo=daySeqNo
    s arrangeScheme.BPASBedDr=##class(User.DHCBPCBed).%OpenId(bedId) 
    
    d arrangeScheme.%Save()
    s result=arrangeScheme.%Id()
    q result
}

}
