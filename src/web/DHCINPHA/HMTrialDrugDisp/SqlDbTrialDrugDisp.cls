Import sqluser

/// Description:住院草药房审方发药表操作相关
/// Creator:    hulihua
/// CreateDate: 2017-07-14
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB、DHC_STDRUGREFUSE
Class web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:住院草药发药相关
/// Creator:	hulihua
/// CreateDate:	2017-07-14
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB
/// Input:		处方号、开始日期、截至日期、药房科室ID、发药人ID
/// Output:
/// Return：    发药主表ID
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).SaveData("I18011602231^96^5710^N")
ClassMethod SaveData(params)
{
	n (params)
	//s ^hlh($h)=$lb(params)
	s prescNo=$p(params,"^",1)
	s PhacLoc=$p(params,"^",2)
	s HospId=$p($g(^CTLOC(PhacLoc)),"^",22)
	s PhaLocation=$o(^DHCPL(0,"Loc",PhacLoc,""))
	s NurseSeekFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
 	s preOrdStr=##class(PHA.COM.Order).GetPreOrdInfo(prescNo)
 	s seekType=$p(preOrdStr,"^",5)
 	q:(NurseSeekFlag="Y")&&(seekType'="A") "-1^该处方护士已撤销！"			
	s PhacUser=$p(params,"^",3)
	s Operater=$p(params,"^",5)
	i Operater="" s Operater=PhacUser
	s UrgentFlag=$p(params,"^",4)
 	s HospID=$s(PhacLoc'="":$p($g(^CTLOC(PhacLoc)),"^",22),1:"")
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)
	s prescOeoriStr=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetOrdStrByPrescno(prescNo)
	s mainOrditm=$p(prescOeoriStr,"&&",2)
	s mDsp=$o(^DHCOEDISQTY(0,"OEORI",mainOrditm,""))
    q:mDsp="" "-1^该处方主医嘱在打包表记录为空！" 
	s WardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    q:WardLocId="" "-1^该处方主医嘱接收科室为空！" 
    s PhaLocConfig=##Class(web.DHCSTPHALOC).GetPhaflag(PhacLoc)
	s OweDispFlag=$p(PhaLocConfig,"^",23)	
    s oeoreStr=$p(prescOeoriStr,"&&",3)
    s admId=$p(^DHCOEDISQTY(mDsp),"^",26)
    s amtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",admId,oeoreStr,PhacLoc)
    q:(OweDispFlag="Y")&&(amtRet="N") "-1^该病人已欠费！" 
	l +^DHCINPHALOCKSaveDispData(prescNo):5  e  q "-1^加锁失败！"   
	s $ZT="Error^DHCSTERROR"							
	ts
	s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
    s WardRowid=WardId
    s PhacType=$p(^DHCOEDISQTY(mDsp),"^",27)
    s PhacDateFrom=$p(^DHCOEDISQTY(mDsp),"^",21)
    s PhacDateTo=PhacDateFrom
    s listdata=PhacLoc_"^"_WardRowid_"^"_Operater_"^"_PhacDateFrom_"^"_PhacDateTo_"^"_PhacType_"^"_UrgentFlag_"^^"_PhacUser_"^"_prescNo_"^"_PhacUser
    s errDispCode=""
    s PhacRowid=##class(web.DHCINPHA.Disp.Save).InsertDHCPHACollected(listdata)
    i $p(PhacRowid,"^",1)<0 s errDispCode=PhacRowid
    i errDispCode'="" tro
    i errDispCode'="" l -^DHCINPHALOCKSaveDispData(prescNo)
    q:errDispCode'="" errDispCode
	s ord="",succCnt=0
	f  s ord=$o(^OEORD(0,"PrescNo",prescNo,ord))  q:(ord="")!(errDispCode'="")  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescNo,ord,itm))  q:(itm="")!(errDispCode'="")  d
	..s OrdItmRowid=ord_"||"_itm
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescNo'=OEPrescNo
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItmRowid,""))
	..q:dsp=""
    ..s RecLoc=$p(^DHCOEDISQTY(dsp),"^",24)
    ..q:(PhacLoc'="")&&(PhacLoc'=RecLoc)
    ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ..s:status'="TC" errDispCode="-1^该处方药品已发"
    ..q:errDispCode'=""
    ..s dispRet=##class(web.DHCINPHA.Disp.Save).Dispensing(PhacRowid,dsp,OrdItmRowid,RuleFlag)
    ..s:$p(dispRet,"^",1)="-1" errDispCode=dispRet
	..q:errDispCode'=""
    ..s succCnt=succCnt+1
    i errDispCode'="" tro
	i errDispCode'="" l -^DHCINPHALOCKSaveDispData(prescNo)
    q:errDispCode'="" errDispCode
    i succCnt=0  d
    .d ##class(web.DHCINPHA.Disp.Save).DeleteDHCPHACollected(PhacRowid)
	i succCnt=0 tro
	i succCnt=0 l -^DHCINPHALOCKSaveDispData(prescNo)
	q:succCnt=0 "-1^未发出药品！"
	//更新发药主表的状态
	s operateDate=+$h,operateTime=$p($h,",",2)
	&SQL(UPDATE DHC_PHACollected SET DHC_PHACollectStatus='Collect',DHC_PHAOperateDate=:operateDate,DHC_PHAOperateTime=:operateTime WHERE DHC_PHACollect_RowID=:PhacRowid)
	tc
	l -^DHCINPHALOCKSaveDispData(prescNo)   
	//1、草药处方是否走揭药室！--此处代码已迁移至煎药室
	//2、草药处方需要插入处方追踪信息！
	s SqlStr="^^"_prescNo_"^C5^"_PhacLoc_"^"_PhacUser
	job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
	//3、发药后账单！
	job ##class(web.DHCINPHA.Disp.Save).MakeBill(PhacRowid)
	//4、发药后插入HERP中间表！
	job ##class(web.DHCST.HERP).SendData(PhacRowid,"P","")
	q PhacRowid
}

/// Description:住院草药拒绝发药相关
/// Creator:	hulihua
/// CreateDate:	2017-07-14
/// Table:      DHC_STDRUGREFUSE
/// Input:		处方号、拒绝人ID、拒绝原因ID
/// Output:
/// Return：    0-成功，非0-失败
/// Others:
/// 		"I211231000138","13847","1"
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).RefusetDrug("I211231000138","13847","1")
ClassMethod RefusetDrug(prescno, gUserId, resondr)
{
	n (prescno, gUserId, resondr)
	//s ^PHATMP("myq",$this,"RefusetDrug")=$lb(prescno, gUserId, resondr)
	s date=+$h
	s time=$p($h,",",2)
	s Err=0
	
	l +^DHCINPHALOCKRefusetDrugData(prescno):5  e  q -23   ;加锁
	ts
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")!(Err'=0)  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:(itm="")!(Err'=0)  d
	..s OrdItmRowid=ord_"||"_itm
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrdItmRowid,""))
	..q:dsp=""
	..s stdf=$o(^STDF("DODIS",dsp,""))
	..q:stdf'=""
    ..s RecLoc=$p(^DHCOEDISQTY(dsp),"^",24)
    ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ..s:status'="TC" Err=-100
    ..i Err'=0 tro
    ..i Err'=0 l -^DHCINPHALOCKRefusetDrugData(prescno)
    ..q:Err'=0
    ..&Sql(insert into dhc_stdrugrefuse (stdf_oedi_dr,stdf_date,stdf_time,stdf_user_dr,stdf_loc_dr,
		STDF_RefReason_DR,STDF_DODIS_DR,STDF_PRESCNO)
		values (:OrdItmRowid,:date,:time,:gUserId,:RecLoc,:resondr,:dsp,:prescno))
	..i SQLCODE'=0  d
	...s ret=$$SqlErrorRecord^DHCSTERROR("InsertDrugRefuse:dhc_stdrugrefuse",dodis,SQLCODE_":"_%msg)
	...s Err=-101
	..i Err'=0 tro
	..i Err'=0 l -^DHCINPHALOCKRefusetDrugData(prescno)
    ..q:Err'=0
    ..s sendRet=##class(web.DHCSTInterfaceMessage).SendIPRefuseDisp(dsp,"Send",gUserId)
    q:Err'=0 Err
    tc
    l -^DHCINPHALOCKRefusetDrugData(prescno)
    //草药处方需要插入处方追踪信息！
	s SqlStr="^^"_prescno_"^C17^"_RecLoc_"^"_gUserId
	job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
    q Err
    
LK()
	l +^INCI(inci,"IL",ILSub):5 e  q -1
	q 0
UK
	l -^INCI(inci,"IL",ILSub)
	l -^DHCOEDISPENSING(oeori)  ;去锁
	q
}

/// Description:处方置可退药信息处理表结构相关
/// Creator:	hulihua
/// CreateDate:	2017-12-25
/// Table:      DHC_PHACollected--发药主表
/// Input:		处方号、置可退用户ID、可退备注
/// Output:
/// Return：    0-成功，非0-失败
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).SaveAgreeData("1744","","","")
ClassMethod SaveAgreeRetData(PhacId, AgrRetUserId, AgrRetRemark)
{
	n (PhacId, AgrRetUserId, AgrRetRemark)
	s AgrRetDate=+$h,AgrRetTime=$p($h,",",2)
	s AgrRetFlag="Y"
	s Err=0
	&Sql(update DHC_PHACollected set DHC_PHAAgreeRetFlag=:AgrRetFlag,DHC_PHAAgreeRetUser_Dr=:AgrRetUserId,DHC_PHAAgreeRetDate=:AgrRetDate,
	DHC_PHAAgreeRetTime=:AgrRetTime,DHC_PHAAgreeRetRemark=:AgrRetRemark where DHC_PHACollect_RowID=:PhacId)
	i SQLCODE'=0  d
	.s ret=$$SqlErrorRecord^DHCSTERROR("SaveAgreeRetData:DHC_PHACollected",PhacId,SQLCODE_":"_%msg)
	.s Err=SQLCODE
	q:Err'=0 Err
	q Err
}

/// Description:取消拒绝发药
/// Creator:	pushaungcai
/// CreateDate:	2017-12-25
/// Table:      DHC_STDRUGREFUSE
/// Input:		dodis-打包表指针,prescno-处方号
/// Output:		
/// Return：	0-成功，非0-失败   
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).CancelRefuse("","")	
ClassMethod CancelRefuse(prescno As %String, dodis As %String, params As %String) As %String
{
 n (prescno,dodis,params)
 q:prescno="" -1
 q:dodis="" -1
 s OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3)     ;OE_OrdExec表指针 ..
 q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0 -2  ;不可取消拒绝
 s Err=0
 &sql(delete from dhc_stdrugrefuse where STDF_PRESCNO=:prescno)
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("CancelRefuse:DHC_STDRUGREFUSE",prescno,SQLCODE_":"_%msg)
 .s Err=-101
 e  d
 .//草药处方需要插入处方追踪信息！
 .s gUserId=$p(params,"^",1)
 .s phaLoc=$p(params,"^",2)
 .s SqlStr="^^"_prescno_"^C18^"_phaLoc_"^"_gUserId
 .job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
 q Err
}

}
