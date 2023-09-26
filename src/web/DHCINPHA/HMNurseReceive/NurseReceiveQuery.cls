/// Description:颗粒剂药房发药查询相关
/// Creator:    hulihua
/// CreateDate: 2017-09-15
/// Table:      DHC_PHACollected-住院发药主表、DHC_PHACollectItm-住院发药子表
Class web.DHCINPHA.HMNurseReceive.NurseReceiveQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取该病区带接受的颗粒剂处方列表
/// Creator:	hulihua
/// CreateDate:	2017-09-15
/// Table:      DHC_PHACollected、DHC_PHACollectItm
/// Input:
/// Output:
/// Return：    待发药病区列表
/// Others:
/// w ##class(web.DHCINPHA.HMNurseReceive.NurseReceiveQuery).GetNurRecPrescnoList("50","1","06/12/2017^21/12/2017^404^N")
ClassMethod GetNurRecPrescnoList(rows, page, params) As %String
{
	n (rows, page, params)
	//s ^hlh($h)=$lb(rows, page, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardId=$p(params,"^",3)
	s NurseAuditFlag=$p(params,"^",4)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","GetNurRecPrescnoList",pid,"Prescno")
	s n=0
	f Date=StartDate:1:EndDate d
	.s phac=""
	.f  s phac=$o(^DHCPHACi("DateAuditFlag",Date,NurseAuditFlag,phac)) q:phac=""  d
	..q:'$d(^DHCPHAC(phac))
	..s prescNo=$p($g(^DHCPHAC(phac,1)),"^",1)
	..q:prescNo=""
	..s phmbRowId=$o(^DHCPHAMEDBi("PrescNo",prescNo,""))
	..q:phmbRowId=""	//未揭药的不允许接收
	..s phmbCompFlag=$p($g(^DHCPHAMEDB(phmbRowId)),"^",5)
	..q:phmbCompFlag'="Y"	//未揭药完成的不允许接收
	..s PhaWard=$p(^DHCPHAC(phac),"^",4)
	..q:WardId'=PhaWard
	..s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	..s PrescnoType=$p(prescStr,"^",8)	//处方类型
	..q:PrescnoType'["颗粒剂"
	..s phalocdr=$p(^DHCPHAC(phac),"^",1)
	..s PhaLoc=$p(^CTLOC(phalocdr),"^",2)
	..s CollectDate=$p(^DHCPHAC(phac),"^",2)
	..s CollectDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CollectDate)
	..s CollectTime=$p(^DHCPHAC(phac),"^",3)
	..s CollectTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CollectTime)
	..s CollectDate=CollectDate_" "_CollectTime
	..s CollectUserDR=$p(^DHCPHAC(phac),"^",13)
	..s CollectUser=$s(CollectUserDR'="":$p($G(^SSU("SSUSR",CollectUserDR)),"^",2),1:"")
	..s phach=$o(^DHCPHAC(phac,"I",""),-1)
	..Q:phach=""
	..s oeoriId=$p(^DHCPHAC(phac,"I",phach),"^",7)
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,""),-1)
	..s dspStatue=$p($g(^DHCOEDISQTY(dspId)),"^",7)
	..q:dspStatue="R"
	..s Adm=$p(^DHCPHAC(phac,"I",phach),"^",3)
	..s Instruc=$p(prescStr,"^",1)		//用法
	..s Facotor=$p(prescStr,"^",2)		//付数
	..s patinfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(Adm)
	..s PatNo=$p(patinfo,"^",1)
	..s PatMedNo=$p(patinfo,"^",12)
	..s PatName=$p(patinfo,"^",3)
	..s BedId=$p(^PAADM(Adm),"^",73)	//未转病区则取当前床位，转病区则床号为空
 	..s Bed=$S(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"")
 	..s AuditorDR=$p(^DHCPHAC(phac),"^",24)
 	..s Auditor=$s(AuditorDR'="":$p($G(^SSU("SSUSR",AuditorDR)),"^",2),1:"")
 	..s AuitDate=$p(^DHCPHAC(phac),"^",26)
 	..s AuitDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuitDate)
 	..s AuitTime=$p(^DHCPHAC(phac),"^",27)
 	..s AuitTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuitTime)
 	..s AuitDate=AuitDate_" "_AuitTime
 	..s Data1=PatMedNo_"^"_PatNo_"^"_PatName_"^"_Bed_"^"_prescNo
 	..s Data2=Instruc_"^"_Facotor_"^"_PhaLoc_"^"_CollectUser_"^"_CollectDate
 	..s Data3=phac_"^"_Auditor_"^"_AuitDate
 	..s index=phac
 	..s n=n+1
 	..s ^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetNurRecPrescnoList",pid,"Prescno",index)=Data1_"^"_Data2_"^"_Data3
 	.
 	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
 	i End>n s End=n
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(n,rows) //输出json前缀串
	s maxrow=n
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetNurRecPrescnoList",pid,"Prescno",index)) q:index=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.HMNurseCheck.NurseCheckQuery","GetNurRecPrescnoList",pid,"Prescno",index)
	.s count = count+1
	.s Title1="TPatMedNo^TPatNo^TPatName^TBed^TPrescNo"
	.s Title2="TInstruc^TFacotor^TPhaLoc^TCollectUser^TCollectDate"
	.s Title3="TPhac^TAuditor^TAuitDate"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","GetNurRecPrescnoList",pid,"Prescno")
	q ""
}

/// Description:扫面颗粒剂条码获取处方相关信息
/// Creator:	hulihua
/// CreateDate:	2018-01-18
/// Table:      
/// Input:		barcode-条码号,logonLocId-登录科室
/// Output:		
/// Return：	处方号、登记号、姓名、性别、年龄、用法、付数、煎药方式、开方科室
/// Others: 
/// w ##class(web.DHCINPHA.HMNurseReceive.NurseReceiveQuery).GetGranPresByBarCode("O190104000032")
ClassMethod GetGranPresByBarCode(barcode As %String, logonLocId As %String = "") As %String
{
	n (barcode,logonLocId)
	s prescNo=$s($F(barcode,$c(16)):$P(barcode,$c(16),2),1:barcode)
	q:prescNo="" -1
	s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	q:ord="" -2
	S phac=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPhacByPres(prescNo)
	Q:phac="" -3
	s logonHospId=$p($g(^CTLOC(logonLocId)),"^",22)
	s phacLocId=$p((^DHCPHAC(phac)),"^",1)
	s phacHospId=$p($g(^CTLOC(phacLocId)),"^",22)
	q:(logonHospId'="")&&(logonHospId'=phacHospId) "-7"		//判断条码院区
	S preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	S DoctorLoc=$p(preOrdStr,"^",1)
	S prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	S prescForm=$p(prescStr,"^",8)
	Q:prescForm'["颗粒剂" -5
	S PhmbId=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	Q:PhmbId'="" -6
	S Instruc=$p(prescStr,"^")
	S Factor=$p(prescStr,"^",2)
	S CoookType=$p(prescStr,"^",7)
	S admDr=$p(prescStr,"^",27)
	S patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	S PatNo=$p(patInfo,"^")
	S PatName=$p(patInfo,"^",3)
	S PatSex=$p(patInfo,"^",4)
	S PatAge=$p(patInfo,"^",5)
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	S ResutStr1=prescNo_DataDelim_PatNo_DataDelim_PatName_DataDelim_PatSex_DataDelim_PatAge
	S ResutStr2=Instruc_DataDelim_Factor_DataDelim_CoookType_DataDelim_DoctorLoc_DataDelim_phac
	S ResutStr=ResutStr1_DataDelim_ResutStr2
	Q ResutStr
}

/// Description:保存颗粒剂护士接收信息
/// Creator:	hulihua
/// CreateDate:	2017-09-18（又是一年的九一八）
/// Table:      DHC_PHACollected
/// Input:		发药主表ID串&&接收人
/// Output:		
/// Return：	0-成功，非0-失败    
/// Others:
/// w ##class(web.DHCINPHA.HMNurseReceive.NurseReceiveQuery).SavaPhacNurseRevice("207&&349")
ClassMethod SavaPhacNurseRevice(listData As %String) As %String
{
	n (listData)
	s PhacStr=$p(listData,"&&",1)
	q:PhacStr="" -1
	s AuditUser=$p(listData,"&&",2)
	q:AuditUser="" -2
	s AuditFlag="Y"
	s AuditDate=+$h
	s AuditTime=$p($h,",",2) 
	s len=$l(PhacStr,"^")
	s ret=0
	s $ZT="Error^DHCSTERROR"
	ts
	f i=1:1:len  q:ret'=0  d
	.s Phac=$p(PhacStr,"^",i)
	.s PhacAuditFlag=$p(^DHCPHAC(Phac),"^",25)
	.s:PhacAuditFlag="Y" ret=-3
	.i ret'=0 tro
	.q:ret'=0
	.s ListDataStr=Phac_"^"_AuditFlag_"^"_AuditDate_"^"_AuditTime_"^"_AuditUser
	.s err=##class(web.DHCINPHA.MTNurseCheck.SqlDbPhacAuitCheck).UpdateAuditInfo(ListDataStr)
	.s:err'=0 ret=-4
	.i err'=0 tro
	q:ret'=0 ret
	tc 
	q ret
}

/// Description:保存揭药室颗粒剂采集数据
/// Creator:	hulihua
/// CreateDate:	2018-01-18
/// Table:      
/// Input:		发药主表ID^采集人
/// Output:		
/// Return：	0-成功，非0-失败    
/// Others:
/// w ##class(web.DHCINPHA.HMNurseReceive.NurseReceiveQuery).SaveGranCollectData("207&&349")
ClassMethod SaveGranCollectData(SqlStr As %String) As %String
{
	n (SqlStr)
	//s ^tmyq($this,"SaveGranCollectData")=SqlStr
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s PhacId=$p(SqlStr,DataDelim,1)
	q:PhacId="" -1_"^该处方在新系统不存在！"
	s CollectUserId=$p(SqlStr,DataDelim,2)
	q:(CollectUserId="")||('$d(^SSU("SSUSR",CollectUserId))) -2_"^登录工号在新系统不存在！"
	s BrothBatNo=$p(SqlStr,DataDelim,3)
	q:BrothBatNo="" -3_"^批次不能为空！"
	s Ret=0,ErrorInfo=""
	s PhaCh=$o(^DHCPHAC(PhacId,"I",""),-1)
	q:PhaCh="" -4_"^该处方还未发药！"
	s prescNo=$p($g(^DHCPHAC(PhacId,1)),"^",1)
	q:prescNo="" -5_"^非草药处方不能收集！"
	s $ZT="Error^DHCSTERROR"
	ts
	s Ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).GetMedBrothDataByPhc(PhacId)
	i Ret'=0 tro
	q:Ret'=0 Ret
	s PhmbId=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	i PhmbId="" tro
	q:PhmbId="" -6_"^该处方系统流程还未到揭药室！"
	s PhmbCh=0
	f  s PhmbCh=$o(^DHCPHAMEDB(PhmbId,"I",PhmbCh))  q:(PhmbCh="")||(Ret'=0)  d
	.s ActPocNum=$p(^DHCPHAMEDB(PhmbId,"I",PhmbCh),"^",6)
	.s PhbmiId=PhmbId_"||"_PhmbCh
	.s ReMark="颗粒剂数据收集"
	.s ListStr=PhbmiId_"^^"_ActPocNum_"^"_ReMark_"^"_BrothBatNo
	.s Ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothDispDb(ListStr,CollectUserId)
	i Ret'=0 tro
	s:Ret=-1 ErrorInfo="-7^揭药明细表为空！"
	s:Ret=-2 ErrorInfo="-8^此颗粒剂已经登记！"
	s:(Ret<0)&&(Ret'=-1)&&((Ret'=-2)) ErrorInfo="-9^更新后台表数据失败！"
	q:Ret'=0 ErrorInfo
	tc 
	q Ret
}

}
