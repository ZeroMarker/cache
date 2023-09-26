Import sqluser

/// Description:移动药房发药表操作相关
/// Creator:    hulihua
/// CreateDate: 2017-04-14
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB
Class web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter AppName = "DHCSTORDDISP";

/// Description:保存发药主表信息
/// Creator:	hulihua
/// CreateDate:	2017-04-14
/// Table:      DHC_PHACollected
/// Input:		adm-就诊ID
/// Output:		
/// Return：	发药主表ID   
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).CreatePhaCollected("94^1^1847^64400^64400^1^")  ;;"94^1^1847^64400^64400^1^"
ClassMethod CreatePhaCollected(listData As %String) As %String
{
	n (listData)
	q:listData="" ""	
	s PhacLoc=$p(listData,"^",1)
	s PhacWard=$p(listData,"^",2)
	s wardphdrstr=$p(listData,"^",3)
	s len=$l(wardphdrstr,"#")
	s PhacUser=""
	f j=1:1:len d
	.s WardPhdrId=$p(wardphdrstr,"#",j)
	.q:WardPhdrId=""
	.s UserCompUser=$p(^DHCPHDRAW(WardPhdrId),"^",7)
	.s PhacUser=$s(PhacUser="":UserCompUser,PhacUser'[UserCompUser:PhacUser_","_UserCompUser,1:PhacUser)
	s PhacDateFrom=$p(listData,"^",4)
	s PhacDateTo=$p(listData,"^",5)
	s PhacType=$p(listData,"^",6)
	s TakeDrugUser=$p(listData,"^",7)
	s PhacDate=+$h
	s PhacTime=$p($h,",",2)
	s PhacStatus="Print"
	l +^DHCSTLOCK("DHCSTORDDISP"):2 e  q ""   ;加锁，应与正常发药的锁一致，避免单号重复
	s DspNo=##class(web.DHCSTPCHCOLLS).GetDispNo($g(PhacLoc))
	&sql(INSERT INTO DHC_PHACollected(DHC_PHALoc_DR,DHC_PHACollectDate,DHC_PHACollectTime,
	DHC_PHAWard_DR,DHC_PHAOperator,DHC_PHACollectStatus,DHC_PHAPrintDate,DHC_PHAPrintTime,
	DHC_PHADateFrom,DHC_PHADateTo,DHC_PHAOrdType,DHC_PHACollectUser,DHC_PHADispNo,DHC_PHAAuditor) 
	VALUES (:PhacLoc,:PhacDate,:PhacTime,:PhacWard,:PhacUser,:PhacStatus,:PhacDate,:PhacTime,
	:PhacDateFrom,:PhacDateTo,:PhacType,:PhacUser,:DspNo,:TakeDrugUser))
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("CreatePhaCollected:DHC_PHACollected",PhacWard,SQLCODE_":"_%msg)
 	l -^DHCSTLOCK("DHCSTORDDISP")
 	q:SQLCODE ""
 	q $p(%ROWID,$c(1))
}

/// Description:更新备药主表信息
/// Creator:	hulihua
/// CreateDate:	2017-04-14
/// Table:      DHC_PHDraw
/// Input:		发药主表ID^备药单串^病区科室ID		
/// Output:		
/// Return：	0-成功，空-失败 
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdatePHDraw("1")
ClassMethod UpdatePHDraw(listData As %String) As %String
{
	n (listData)
	s inphacrowid=$p(listData,"^",1)
	s wardphdrstr=$p(listData,"^",2)
	s WardLocId=$p(listData,"^",3)
	s DispFlag=$p(listData,"^",4)
	s len=$l(wardphdrstr,"#")
	s PhdwStatus="50"
	l +^DHCINPHALOCK("UpdatePHDraw"_wardphdrstr):2 e  q ""   ;加锁
	s err=0
	f j=1:1:len d
	.q:err'=0
	.s WardPhdrId=$p(wardphdrstr,"#",j)
	.s WardLoc=$p(^DHCPHDRAW(WardPhdrId),"^",3)
	.q:WardLoc'=WardLocId			//再次判断，以防万一
	.s PhacDrawRowid=$p(^DHCPHDRAW(WardPhdrId),"^",17)
	.q:(##class(web.DHCST.Common.UtilCommon).FindInList(PhacDrawRowid,inphacrowid,",")'=0)
	.s phacrowid=$s(PhacDrawRowid'="":PhacDrawRowid_","_inphacrowid,1:inphacrowid)
	.i DispFlag=1  d
	..&sql(UPDATE DHC_PHDraw SET PHDW_Phac_Dr=:phacrowid WHERE PHDW_RowID=:WardPhdrId)
	.e  d
	..&sql(UPDATE DHC_PHDraw SET PHDW_Phac_Dr=:phacrowid,PHDW_Status=:PhdwStatus WHERE PHDW_RowID=:WardPhdrId)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("UpdatePHDraw:DHC_PHDraw",WardPhdrId,SQLCODE_":"_%msg)
 	..s err=-1
 	.
 	l -^DHCINPHALOCK("UpdatePHDraw"_wardphdrstr)
 	q:err'=0 ""
 	q err
}

/// Description:更新备药孙表信息
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_PHDrawOrder
/// Input:		发药子表ID^备药孙表ID串	
/// Output:		
/// Return：	0-成功，空-失败 
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdatePHDrawOrder("1")
ClassMethod UpdatePHDrawOrder(listData As %String) As %String
{
	n (listData)
	s phacirowid=$p(listData,"^",1)
	q:phacirowid="" "" 
	s phdrsubidstr=$p(listData,"^",2)
	s len=$l(phdrsubidstr,",")
	l +^DHCINPHALOCK("UpdatePHDrawOrder"_phdrsubidstr):2 e  q ""   ;加锁
	s err=0
	f j=1:1:len d
	.q:err'=0
	.s phdrsubid=$p(phdrsubidstr,",",j)
	.&sql(UPDATE DHC_PHDrawOrder SET PHDWO_PHACI_Dr=:phacirowid WHERE PHDWO_RowID=:phdrsubid)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("UpdatePHDrawOrder:DHC_PHDrawOrder",phdrsubid,SQLCODE_":"_%msg)
 	..s err=-1
 	.
 	l -^DHCINPHALOCK("UpdatePHDrawOrder"_phdrsubidstr)
 	q:err'=0 ""
 	q:SQLCODE ""
 	q err
}

/// Description:保存发药子表记录
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_PHACollectItm
/// Input:		主表id^医嘱id^库存项id^数量^配药表id（串）
/// Output:
/// Return：	成功：子表id; 失败:""
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).InsPhacItm("")
ClassMethod InsPhacItm(listData As %String) As %String
{
	
	n (listData)
	s phacrowid=$p(listData,"^",1)
	q:phacrowid="" ""
	s oeori=$p(listData,"^",2)
	q:oeori="" ""
	s dhcoedis=$p(listData,"^",3)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s phaciadm=$P(^OEORD(ord),"^",1) ;adm_dr
	s phacipresc=$p(^OEORD(ord,"I",itm,1),"^",14)   ;处方号
	s phaciloc=$p(^PAADM(phaciadm),"^",4)   ;admloc
	s bedid=$p(^PAADM(phaciadm),"^",73)                                             ;PA_Beds RowId
	i bedid="" s phacibed=""
	e  s phacibed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)        ;病人床号
	s tmpdodis=$p(dhcoedis,",",1)
	s datedosing=$p(^DHCOEDISQTY(tmpdodis),"^",21)  ;分发日期
	s j=$o(^DHCPHAC(phacrowid,"I",""),-1)+1   ;child sub
	&sql(INSERT INTO DHC_PHACollectItm(PHACI_PHAC_ParRef,PHACI_Adm_DR,PHACI_PrescNo,
	PHACI_OEDIS_DR,PHACI_ChildSub,PHACI_BED,PHACI_AdmLoc_DR,PHACI_DODIS_DR,PHACI_DateDosing) 
	VALUES(:phacrowid,:phaciadm,:phacipresc,:oeori,:j,:phacibed,:phaciloc,:dhcoedis,:datedosing))
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("InsPhacItm:DHC_PHACollectItm",oeori,SQLCODE_":"_%msg)
	q:SQLCODE ""
	q $p(%ROWID,$c(1))
}

/// Description:保存发药孙表记录
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_PHACollectItmLB
/// Input:		发药子表id^批次id^批次数量^售价^售价金额^进价^进价金额
/// Output:
/// Return：	成功：批次表id; 失败:""
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).InsPhacItmLB("")
ClassMethod InsPhacItmLB(listData As %String) As %String
{
	n (listData)
	s phacirowid=$p(listData,"^",1)
	q:phacirowid="" ""
	s inclb=$p(listData,"^",2)
	s qty=$p(listData,"^",3)
	s sp=$p(listData,"^",4)
	s spamt=$p(listData,"^",5)
	s rp=$p(listData,"^",6)
	s rpamt=$p(listData,"^",7)
	s dspbatch=$p(listData,"^",8)
	s childsub=$o(^DHCPHAC(+phacirowid,"I",$p(phacirowid,"||",2),"B",""),-1)+1   ;child sub
 	;
 	&sql(INSERT INTO DHC_PhaCollectItmLB(PHACIL_PHACI_ParRef,PHACIL_ChildSub,PHACIL_INCLB_Dr,
 	PHACIL_Qty,PHACIL_Rp,PHACIL_RpAmt,PHACIL_Sp,PHACIL_SpAmt,PHACIL_DSPB_Dr) 
 	VALUES (:phacirowid,:childsub,:inclb,:qty,:rp,:rpamt,:sp,:spamt,:dspbatch))
 	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("InsPhacItmLB:DHC_PHACollectItmLB",inclb,SQLCODE_":"_%msg)
 	q:SQLCODE ""
 	q $p(%ROWID,$c(1))
}

/// Description:更新DHC_INTRANS的相关字段内容
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_INTRANS--台账表
/// Input:		台帐表ID^发药孙表ID
/// Output:
/// Return：	0-成功，空-失败   
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdateIntrans("")
ClassMethod UpdateIntrans(listData As %String) As %String
{
	n (listData)
	s intr=$p(listData,"^",1)
	s phacil=$p(listData,"^",2)
	q:(intr="")||(phacil="") ""
	s intrtype="P"
	s dispno=$p(^DHCPHAC(+phacil),"^",14)
	s err=0
	//
	&sql(update DHC_INTRANS set INTR_Pointer=:phacil, INTR_Type=:intrtype, INTR_No=:dispno where INTR_RowId=:intr)
	i SQLCODE'=0  d
	.s err=-1 
	.s ret=$$SqlErrorRecord^DHCSTERROR("UpdateIntrans:DHC_INTRANS",intr,SQLCODE_":"_%msg)
	q:err=-1 ""	
	q SQLCODE
}

/// Description:更新dhc_oedispensing的字段内容
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_OEDispensing--新医嘱打包表
/// Input:		发药子表ID、医嘱打包串
/// Output:
/// Return：   
/// Others:		当所有打包子表都是发药状态之后最后再更新打包表！
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdStatusForDODISS("0","20405")
ClassMethod UpdStatusForDODISS(phaci As %String, dspId As %String) As %String
{
	n (phaci,dspId)
	q:dspId="" ""
	q:$d(^DHCOEDISQTYi("DSPBINCIStatus","TC",dspId)) 0
	s phac=+phaci,dd=+$h,tt=$p($h,",",2),pointer=phaci,type="P",code="C"  //"已发药状态"
	s user=$p($g(^DHCPHAC(phac)),"^",5)
	s err=0
	&sql(update DHC_OEDispensing set dsp_status=:code,dsp_date=:dd,dsp_time=:tt,
	dsp_user=:user,dsp_type=:type,dsp_pointer=:pointer where dsp_rowid=:dspId)
	i SQLCODE'=0  d
	.s err=-1 
	.s ret=$$SqlErrorRecord^DHCSTERROR("UpdStatusForDODISS:DHC_OEDispensing",dspId,SQLCODE_":"_$g(%msg))
	q:err'=0 ""	
	q err
}

/// Description:删除发药主表记录
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      dhc_phacollected
/// Input:		发药主表ID
/// Output:
/// Return：	成功：0; 失败:""
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DelPhaCollected("")
ClassMethod DelPhaCollected(PhacRowid As %String) As %String
{
	n (PhacRowid)
	q:PhacRowid="" ""
	s err=0
	&sql(delete from DHC_PHACollected where DHC_PHACollect_RowID=:PhacRowid)
	i SQLCODE'=0  d
	.s err=-1 
	.s ret=$$SqlErrorRecord^DHCSTERROR("DelPhaCollected:DHC_PHACollected",PhacRowid,SQLCODE_":"_$G(%msg))
	q:err'=0 ""	
	q SQLCODE
}

/// Description:更新发药主表状态
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      dhc_phacollected
/// Input:		主表id,更新人
/// Output:
/// Return：	成功：0;失败:其它
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).Collect("")
ClassMethod Collect(phacdr As %String, Nurse As %String, SendUser As %String = "") As %String
{
	n (phacdr,Nurse,SendUser)
	s Nurse=$g(Nurse)
	s Col="Collect"
	i '$d(^DHCPHAC(phacdr)) q -1
	;calculate the rowcount of items 
	s phacdate=+$h
	s phactime=$p($h,",",2)
	s phaci=0 
	s cnt=0 
	f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	.s cnt=cnt+1
	.	
	s ret=0 
	i cnt=0 d
	. &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
	e  d
	.s $p(^DHCPHAC(phacdr),"^",6)=Col
	.s $p(^DHCPHAC(phacdr),"^",9)=cnt
	.s $p(^DHCPHAC(phacdr),"^",13)=Nurse
	.i SendUser'="" s $p(^DHCPHAC(phacdr),"^",17)=SendUser
	q ret
}

/// Description:处理不可发药的打包记录串，包括改孙表状态加库存以及删台帐
/// Creator:	hulihua
/// CreateDate:	2017-04-17
/// Table:      DHC_INTRANS
/// Input:		备药主表串^不可发药医嘱打包串^药品ID
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).HandleCalDsp("1^7630^1001^1")
ClassMethod HandleCalDsp(listData As %String) As %String
{
	n (listData)
	s dspBatchId=$p(listData,"^",2)
	q:dspBatchId="" 0
	s phdrsubid=$p(listData,"^",1)
	s PhdRefFlag=$p(^DHCPHDRAW(+phdrsubid,"INC",$p(phdrsubid,"||",2),"ORDER",$p(phdrsubid,"||",3)),"^",3)
	q:PhdRefFlag="Y" 0														;拒绝发药的没有发药直接返0
	s pid=$p(listData,"^",3)
	l +^DHCINPHAHandleCalDsp(dspBatchId):5  e  q -1000   					;加锁
	s intrid=$o(^DHCINTR(0,"TypePointer","L",phdrsubid,""),-1)
	i intrid="" d Unlock
	q:intrid="" 0
	s cnt=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetInclbQty(phdrsubid,pid)
	i cnt<=0 d Unlock
	q:cnt<=0 -1
	s err=0
	tstart
	s $ZT="Error^DHCSTERROR"												;增加错误处理
	s err=..UpPhOrderStopFlag(phdrsubid)								//更新备药孙表停止标志
	i err'=0 trollback  d Unlock
	q:err'=0 -2
	s err=..UpDspBatchStatus(phdrsubid)									//将撤销的药品打包子表更新为未发状态
	i err'=0 trollback  d Unlock
	q:err'=0 -3
	s newclb=""
	f  s newclb=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB",newclb)) q:(newclb="")!(err'=0)  d
	.s tmpdata=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB",newclb)
	.s qty=$p(tmpdata,"^",1)
	.s data="^^"_newclb_"^"_-qty_"^^^^^"
	.s ret=##class(web.DHCST01).UPDINCI(data,1)								//加库存
	.s:ret'=1 err=-4
	.q:ret'=1
	.s intr=$p(tmpdata,"^",6)
	.s ret=..DeleteTrans(intr)												//删台帐
	.s:ret'=0 err=-5
	.q:ret'=0
	i err'=0 trollback  d Unlock
	q:err'=0 err
 	;提交事务
 	tcommit
 	d Unlock
 	q 0		
Unlock		;去锁
	l -^DHCINPHAHandleCalDsp(dspBatchId)  
	k ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB")
	q
}

/// Description:对于撤销发药的请领单需要更新备药孙表的状态（送药是装箱核对，取药的发药时候）
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_PHDrawOrder
/// Input:		备药孙表ID串
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).HandleCalDsp("0","85","")
ClassMethod UpPhOrderStopFlag(listData As %String) As %String
{
	n (listData)
	s phdrsubidstr=listData
	q:phdrsubidstr="" ""
	s StopFlag="Y"
	s len=$l(phdrsubidstr,",")
	l +^DHCINPHALOCK("UpPhOrderStopFlag"_phdrsubidstr):2 e  q ""   ;加锁
	s err=0
	f j=1:1:len d
	.q:err'=0
	.s phdrsubid=$p(phdrsubidstr,",",j)
	.&sql(UPDATE DHC_PHDrawOrder SET PHDWO_StopFlag=:StopFlag WHERE PHDWO_RowID=:phdrsubid)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("UpPhOrderStopFlag:DHC_PHDrawOrder",phdrsubid,SQLCODE_":"_%msg)
 	..s err=-1
 	.
 	l -^DHCINPHALOCK("UpPhOrderStopFlag"_phdrsubidstr)
 	q:err'=0 ""
 	q:SQLCODE ""
 	q err
}

/// Description:对于撤销发药的请领单需要更新打包子表的状态（送药是装箱核对，取药的发药时候）
/// Creator:	hulihua
/// CreateDate:	2017-12-18
/// Table:      DHC_OEDispBatch
/// Input:		备药孙表ID串
/// Output:
/// Return：   
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpDspBatchStatus("0","85","")
ClassMethod UpDspBatchStatus(listData As %String) As %String
{
	n (listData)
	s phdrsubidstr=listData
	q:phdrsubidstr="" ""
	s dspBatchStatus="TC"
	s len=$l(phdrsubidstr,",")
	l +^DHCINPHALOCK("UpDspBatchStatus"_phdrsubidstr):2 e  q ""   ;加锁
	s err=0
	f j=1:1:len d
	.q:err'=0
	.s phdrsubid=$p(phdrsubidstr,",",j)
	.s dspBatchId=$p(^DHCPHDRAW(+phdrsubid,"INC",$p(phdrsubid,"||",2),"ORDER",$p(phdrsubid,"||",3)),"^",1)
	.;已发的无需再次更新
	.q:$p(^DHCOEDISQTY(+dspBatchId),"^",7)'="TC"
	.;如果同一个打包子表ID撤销和正常的在一起做装箱核对时，则撤销的这条在核对时无需修改打包子表状态！
	.;
	.s phdrawid="",num=0
	.f  s phdrawid=$o(^DHCPHDRAWi("DSPBATCH",dspBatchId,phdrawid),-1)  q:(phdrawid="")||(num>1)  d
	..s phdrawstatus=$p(^DHCPHDRAW(phdrawid),"^",5)
	..q:phdrawstatus'="40"
	..s num=num+1
	.q:num>1	
	.&sql(UPDATE DHC_OEDispBatch SET DSPB_Status=:dspBatchStatus WHERE DSPB_RowId=:dspBatchId)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("UpDspBatchStatus:DHC_OEDispBatch",dspBatchId,SQLCODE_":"_%msg)
 	..s err=-1
 	.
 	l -^DHCINPHALOCK("UpDspBatchStatus"_phdrsubidstr)
 	q:err'=0 ""
 	q err
}

/// Description:对于重新分配批次的需要将下医嘱分配的批次先删除
/// Creator:	hulihua
/// CreateDate:	2017-04-18
/// Table:      DHC_OEDispBatch
/// Input:		dspID-打包表ID
/// Output:
/// Return： 	0-成功，空-失败  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DelDspBatch()
ClassMethod DelDspBatch(dspID As %String) As %String
{
	n (dspID)
 	s err=0
 	&sql(Delete From DHC_OEDispBatch Where DSPB_DSP_ParRef=:dspID)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("DelDspBatch:DHC_OEDispBatch",dspID,SQLCODE_":"_%msg)
 	.s err=-1
 	q:err'=0 ""
 	q SQLCODE
}

/// Description:对撤销的打包记录需要删除台帐
/// Creator:	hulihua
/// CreateDate:	2017-04-21
/// Table:      DHC_INTRANS
/// Input:		
/// Output:
/// Return： 	0-成功，非0-失败  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DeleteTrans()
ClassMethod DeleteTrans(intr As %String) As %String
{
	n (intr)
 	q:intr="" -1
 	s Err=0
	&sql(delete from DHC_InTrans Where intr_rowid=:intr)
	i SQLCODE'=0  d
	.s ret=$$ErrorRecord^DHCSTERROR("DeleteTrans:DHC_InTrans","rowid:"_intr,SQLCODE_":"_%msg) 
	.s Err=-2
	q Err
}

/// Description:对于重新分配批次的需要将下医嘱分配的批次库存项先删除
/// Creator:	hulihua
/// CreateDate:	2017-09-26
/// Table:      DHC_OEDispBatch
/// Input:		dspID-打包表ID, inci-库存项ID
/// Output:
/// Return： 	0-成功，空-失败  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DelDspBatchIn()
ClassMethod DelDspBatchIn(dspID As %String, inci As %String) As %String
{
	n (dspID,inci)
	s tmpinci=inci_"||%"
	&sql(Delete From DHC_OEDispBatch Where DSPB_DSP_ParRef=:dspID and DSPB_INCLB_DR like :tmpinci)
 	q SQLCODE
}

/// Description:第三方抓药开始和抓药结束回传给HIS相关抓药信息
/// Creator:	hulihua
/// CreateDate:	2017-09-27
/// Table:      DHC_PHACollected--发药主表
/// Input:		ListData-发药主表ID、开始抓药日期、开始抓药时间、开始抓药人、结束抓药日期、结束抓药时间、结束抓药人、机器号  
/// Output:
/// Return： 	""-空  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpDrugPackData("I18022402625^64703^48453^12479",1)
ClassMethod UpDrugPackData(ListData As %String) As %String
{
	n (ListData)
	s Phac=$p(ListData,"^",1)
	s DrugBeginDate=$p(ListData,"^",2)
	s DrugBeginTime=$p(ListData,"^",3)
	s DrugBeginName=$p(ListData,"^",4)
	s DrugBeginUser=$s(DrugBeginName'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DrugBeginName),""),-1),1:"")
	q:(DrugBeginName'="")&&(DrugBeginUser="") "-2^HIS系统开始抓药人工号不存在！"
	s DrugEndDate=$p(ListData,"^",5)
	s DrugEndTime=$p(ListData,"^",6)
	s DrugFinshName=$p(ListData,"^",7)
	s DrugFinshUser=$s(DrugFinshName'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DrugFinshName),""),-1),1:"")
	q:(DrugFinshName'="")&&(DrugFinshUser="") "-3^HIS系统结束抓药人工号不存在！"
	s MachineNo=$p(ListData,"^",8)
	l +^DHCINPHALOCK("UpDrugPackData"_Phac):2 e  q ""   ;加锁
	s err=0
	&sql(UPDATE DHC_PHACollected SET DHC_PHAOperateDate=:DrugBeginDate,DHC_PHAOperateTime=:DrugBeginTime,
	DHC_PHAOperator=:DrugBeginUser,DHC_PHACheckDate=:DrugEndDate,DHC_PHACheckTime=:DrugEndTime,
	DHC_PHAChecker=:DrugFinshUser,DHC_PHAMachNo=:MachineNo WHERE DHC_PHACollect_RowID=:Phac)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("UpDrugPackData:DHC_PHACollected",Phac,SQLCODE_":"_%msg)
 	.s err=-1
 	l -^DHCINPHALOCK("UpDrugPackData"_Phac)
 	q:err'=0 "-4^HIS更新表失败！"
 	q 0
}

/// Description:第三方移动端完成调剂之后回传给HIS调剂信息
/// Creator:	hulihua
/// CreateDate:	2017-09-29
/// Table:      DHC_PHACollected--发药主表
/// Input:		Phac-发药主表ID，ListData-发药主表ID^调剂完成日期^调剂完成时间^调剂人^复核日期^复核时间^复核人^发药日期^发药时间^发药人
/// Output:
/// Return： 	""-空  
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpDrugPackData()
ClassMethod UpdateDrugDisp(Phac, ListData As %String) As %String
{
	n (Phac,ListData)
	s MakeUpDate=$p(ListData,"^",1)
	s MakeUpTime=$p(ListData,"^",2)
	s MakeUpCode=$p(ListData,"^",3)
	//根据工号判断
	s MakeUpUser=$s(MakeUpCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MakeUpCode),""),-1),1:"") 
	q:(MakeUpCode'="")&&(MakeUpUser="") "-3^HIS系统中调剂人工号不存在！"
	s ValidationDate=$p(ListData,"^",4)
	s ValidationTime=$p(ListData,"^",5)
	s ValidationerCode=$p(ListData,"^",6)
	s ValidationerUser=$s(ValidationerCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ValidationerCode),""),-1),1:"")
	q:(ValidationerCode'="")&&(ValidationerUser="") "-4^HIS系统中复核人工号不存在！"
	s DrugDispDate=$p(ListData,"^",7)
	s DrugDispTime=$p(ListData,"^",8)
	s DrugDispCode=$p(ListData,"^",9)
	s DrugDispUser=$s(DrugDispCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(DrugDispCode),""),-1),1:"")
	q:(DrugDispCode'="")&&(DrugDispUser="") "-5^HIS系统中发药人工号不存在！"
	s DataSource="2"
	l +^DHCINPHALOCK("UpdateDrugDisp"_Phac):2 e  q ""   ;加锁
	s err=0
	&sql(UPDATE DHC_PHACollected SET DHC_PHAOperateDate=:MakeUpDate, DHC_PHAOperateTime=:MakeUpTime, DHC_PHAOperator=:MakeUpUser,
	DHC_PHACheckDate=:ValidationDate, DHC_PHACheckTime=:ValidationTime, DHC_PHAChecker=:ValidationerUser, 
	DHC_PHAOthDispDate=:DrugDispDate, DHC_PHAOthDispTime=:DrugDispTime, DHC_PHAOthDispUser=:DrugDispUser,DHC_PHADataSource=:DataSource 
	WHERE DHC_PHACollect_RowID=:Phac)
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("UpdateDrugDisp:DHC_PHACollected",Phac,SQLCODE_":"_%msg)
 	.s err=-1
 	l -^DHCINPHALOCK("UpdateDrugDisp"_Phac)
 	q:err'=0 "-6^HIS更新表失败！"
 	;草药处方需要插入处方追踪信息！
 	s PhLocId=$p(^DHCPHAC(Phac),"^",1)
	s PhaCh=$o(^DHCPHAC(Phac,"I",""),-1)
	s PrescNo=$p(^DHCPHAC(Phac,"I",PhaCh),"^",5)
	i (MakeUpDate'="")||(MakeUpTime'="")||(MakeUpUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C6^"_PhLocId_"^"_MakeUpUser_"^"_MakeUpDate_"^"_MakeUpTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
	i (ValidationDate'="")||(ValidationTime'="")||(ValidationerUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C7^"_PhLocId_"^"_ValidationerUser_"^"_ValidationDate_"^"_ValidationTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
	i (DrugDispDate'="")||(DrugDispTime'="")||(DrugDispUser'="")  d
	.s SqlStr="^^"_PrescNo_"^C8^"_PhLocId_"^"_DrugDispUser_"^"_DrugDispDate_"^"_DrugDispTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
 	q 0
}

}
