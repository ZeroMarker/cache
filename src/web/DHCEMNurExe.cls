Import SQLUSER

/// Creator:      周鑫
/// CreatDate:    2016.06.30
/// Description:  护士门诊新执行
Class web.DHCEMNurExe Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator: zhouxin
/// CreatDate: 2016.06.30
/// Description: 
/// Table：
/// Input：
/// Return
/// w ##class(web.DHCEMNurExe).updateDisposeStatCode(394,3,"")
/// RegNo=0000000198&QueryType=MZQBYZ&HospId=0&Exec=false&UnExec=true&StartDate=07%2F04%2F2011&EndDate=07%2F04%2F2017
/// w ##class(web.DHCEMNurExe).getExeOrders("0","200","0000000155","PSDO","2019-12-04","2019-12-04","2^212^22^11843","","false","true")
/// w ##class(web.DHCEMNurExe).getExeOrders("0","200","0000001388","SYD[KQ]","2020-06-15","2020-06-15","3^230^22^10211","","false","true")
/// w ##class(web.DHCEMNurExe).getExeOrders("0","200","0000001398","MZQBYZ","2020-06-15","2020-06-16","10^566^22^10870","","false","true")
/// w ##class(web.DHCEMNurExe).getExeOrders("0","200","0000000973","SYDO","2021-01-01","2021-01-04","2^70^22^13806","","false","true")
ClassMethod getExeOrders(page, rows, RegNo, QueryType, StartDate, EndDate, LgParams, Loc, Exec = "false", UnExec = "true", OneAdmId = "")
{
	n (page,rows,RegNo,QueryType ,StartDate,EndDate,LgParams, Loc , Exec, UnExec, OneAdmId,%session)
	
	q:RegNo="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	//s start=offset+1
    //s end=offset+limit
    s end=page*rows
	s start=(page-1)*rows+1
	
	s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) //hxy $zdh(StartDate,3)
    s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //hxy $zdh(EndDate,3)
    
    s TraImmed=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","即刻需处理")
    s TraTemp=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","需处理临嘱")
    s TraExec=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","已处理")
    s TraSkinTest=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","皮试")
    s TraSkinNorm=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","皮试阴性")
    s TraSkinAbnorm=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","皮试阳性")
    s TraUnPaid=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","未收费")
    s TraDisc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","需处理停止")
    s TraNeedl=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","不需处理")
    
    s hosp=0
	s HospId = $p(LgParams,"^",1)
	s userId=$p(LgParams,"^",4)
	s pid=##Class(web.DHCAPPCommonUtil).NewPid()
	s total=0
	k ^TMP("web.DHCEMNurExe","getExeOrders",pid)
	k ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid)
	k ^TMP("NurExecOrderAttach",userId)
	k ^TMP("web.DHCEMNurExe","allOrders",pid)
	s OrdType = ##class(web.DHCEMNurExe).GetConfigBySession("SEEORDTYPE",LgParams)   ///查看的类型：O：门诊，E:急诊，OE：门急诊都看
	s RelyOnMainOrd = ##class(web.DHCEMNurExe).GetConfigBySession("RELYONMAINORD",LgParams)
	
	s patsAdm=""
	s:+OneAdmId=0 patsAdm=..getAdmStrByRegNo(RegNo,OrdType,StartDate,EndDate)
	s:+OneAdmId'=0 patsAdm=OneAdmId
	
    s num=$l(patsAdm,"^")
    s total=0
	f i=1:1:num d
	.s admId=$p(patsAdm,"^",i)
	.q:+admId=0 
	.s patTempLoc=$P($g(^PAADM(admId)),"^",74)
	.s ord=0
	.f  s ord=$o(^OEORD(0,"Adm",admId,ord)) q:ord=""  d
	..s itm=""
	..f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	...s reclocDr=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	...s rechop=""
	...s:+reclocDr'=0 rechop=$p(^CTLOC(reclocDr),"^",22)
	...q:(+reclocDr'=0)&&($g(rechop)'=HospId)
	...//分院医嘱判断
	...i $d(^OEORD(ord,"I",itm,"X"))<10 d //无执行医嘱:处置治疗类
	....d ##class(web.DHCEMNurExe).setOrdExecData(pid,LgParams,ord,itm,"",Exec,UnExec,StartDate,EndDate,RelyOnMainOrd)
	...q:$d(^OEORD(ord,"I",itm,"X"))<10
	...s sub=0
	...f  s sub=$o(^OEORD(ord,"I",itm,"X",sub))  q:sub=""  d //执行记录id
	....d ##class(web.DHCEMNurExe).setOrdExecData(pid,LgParams,ord,itm,sub,Exec,UnExec,StartDate,EndDate,RelyOnMainOrd)
	
	
	
	s ListTitle="adm&skinTestFlag&mainOeoreId&oeoriId&oeoreId&subOrder&prtFlag"
	s ListTitle=ListTitle_"&seqNo&execCtcpDesc&prescNo&disposeStatDesc&disposeStatCode&execDateTime&createDateTime"
	s ListTitle=ListTitle_"&sttDateTime&arcimDesc&patName&admLoc&regNo&medCareNo&bedCode"
	s ListTitle=ListTitle_"&patIdentity&orcatDesc&oecprDesc&doseQtyUnit&phcfrCode&phOrdQtyUnit&dosage&phcinDesc"
	s ListTitle=ListTitle_"&notes&execXUserDesc&execXDateTime&price&totalAmount&Durat&specDesc"
	s ListTitle=ListTitle_"&specCollDateTime&flowSpeed&seeOrderUserName&seeOrderUserDateTime&ordDep&reclocDesc&execStat"
	s ListTitle=ListTitle_"&ordStatDesc&ctcpDesc&DspStat&skinTestDateTime&xDateTime&xCtcpDesc&tubeColor"
	s ListTitle=ListTitle_"&EncryptLevel&PatLevel&labNo&placerNo&placerCode&age&skinRs&skinFlag2&mainOrdItmID"
	s ListTitle=ListTitle_"&arciSkinSet&LockStatus&execPrice&groupNo&overTimeReqExecDate&isCaExec"
	s ListTitle=ListTitle_"&execNotes&allgryFlag&emOrdCat&SkinTestPay"
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s sumcount=0,groupStartNo=1
	w "{""rows"":["
	s i="" f  s i=$o(^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i)) q:i=""  d
	.s stdt="" f  s stdt=$o(^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i,stdt)) q:stdt=""  d
	..s seqNo="" f  s seqNo=$o(^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i,stdt,seqNo)) q:seqNo=""  d
	...s itm="" f  s itm=$o(^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i,stdt,seqNo,itm)) q:itm=""  d
	....s sub="" f  s sub=$o(^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i,stdt,seqNo,itm,sub)) q:sub=""  d
	.....s obj=##class(web.DHCEMOrdInfoVO).%New()
	.....s sumcount=sumcount+1
  	.....q:sumcount<start
  	.....q:sumcount>end
    .....w $case(sumcount,start:"",:",")
	.....s ord=+seqNo
	.....;组号:1.1,2.1/2.2,3.1/3.2这种
	.....s groupNo=""		;组号1 1.1 1.2 1.3 这种
    .....i $d(^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid,seqNo)) d
    ......s groupNo=^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid,seqNo)+0.1
    ......s ^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid,seqNo)=groupNo
    .....i '$d(^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid,seqNo)) d
    ......s groupNo=groupStartNo
    ......s ^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid,seqNo)=groupNo
    ......s groupStartNo=groupStartNo+1
	.....
	.....s skinTestFlag= $p($g(^OEORD(ord,"I",itm,5)),"^",2)
    .....s oeoreId=ord_"||"_itm_"||"_sub
    .....s:sub="X" oeoreId=ord_"||"_itm
    .....s oeoriId=ord_"||"_itm
    .....s dataInfo=^TMP("web.DHCEMNurExe","getExeOrders",pid,QueryType,i,stdt,seqNo,itm,sub)
	.....s stat=$p(dataInfo,"^",1)
	.....s labNoInfo=$p(dataInfo,"^",2)
	.....s placerStr=##class(web.DHCNurCom).GetSpecContainerCode(oeoriId)
	.....;s disposeStatDesc=$case(stat,"Immediate":"即刻需处理","Temp":"需处理临嘱","Exec":"已处理","SkinTest":"皮试","SkinTestNorm":"皮试阴性","SkinTestAbnorm":"皮试阳性","UnPaid":"未收费","Discontinue":"需处理停止","Needless":"不需处理",:"")
	.....s disposeStatDesc=$case(stat,"Immediate":TraImmed,"Temp":TraTemp,"Exec":TraExec,"SkinTest":TraSkinTest,"SkinTestNorm":TraSkinNorm,"SkinTestAbnorm":TraSkinAbnorm,"UnPaid":TraUnPaid,"Discontinue":TraDisc,"Needless":TraNeedl,:"")
	.....s pmark=$p($g(^OEORD(ord,"I",itm,"X",sub,"NUR")),"^",1)
	.....s execDate=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",19)
	.....s execTime=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",20)
	.....s execCTPCP=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",15)
	.....s execCtcpDesc=""
    .....s:execCTPCP'="" execCtcpDesc=$p($g(^CTPCP(execCTPCP,1)),"^",2)	//执行科室描述
    .....s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
    .....s oeoriCreateDate=$p($g(^OEORD(ord,"I",itm,3)),"^",7)
    .....s oeoriCreateTime=$p($g(^OEORD(ord,"I",itm,1)),"^",17)
    .....s islink=##class(web.DHCEMOrdInfoVO).CheckLink(ord_"||"_itm)
    .....s subOrder=0
    .....s:(seqNo'=oeoriId)&&(islink=1) subOrder=1
    .....s adm=$p(^OEORD(ord),"^",1)
    .....s skinTestFlag=skinTestFlag
    .....s mainOeoreId=seqNo_"||"_sub
    .....s oeoriId=oeoriId
    .....s oeoreId=oeoreId
    .....s subOrder=subOrder
    .....s prtFlag=pmark
    .....s seqNo=seqNo
    .....s execCtcpDesc=$g(execCtcpDesc)
    .....s prescNo=prescno
    .....s disposeStatDesc=disposeStatDesc
    .....s disposeStatCode=stat
    .....s execDateTime=""
    .....s:+execDate'=0 execDateTime=##class(web.DHCEMCommonUtil).DateLogicalToHtml(execDate)_" "_$zt(execTime,2)
    .....s createDateTime=##class(web.DHCEMCommonUtil).DateLogicalToHtml(oeoriCreateDate)_" "_$zt(oeoriCreateTime,2)
 	.....
 	.....s sttDateTime=##class(web.DHCEMOrdInfoVO).GetSttDateTime(ord,itm,sub)
 	.....s skinResultUser=##class(web.DHCEMOrdInfoVO).GetSkinResultUser(ord_"||"_itm)
	.....s arcimDesc=##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)_skinResultUser
	.....s arcimDescJC=##Class(web.DHCAPPInterface).GetExaReqItemDesc(ord_"||"_itm)
	.....s:arcimDescJC'="" arcimDesc=arcimDescJC
    .....//s arcimDesc=$s(subOrder=1:"______",subOrder=0:"")_arcimdesc_skinResultUser
	.....;s:(QueryType="SYDO") arcimDesc=##class(web.DHCEMOrdInfoVO).getGrpArcimDesc(ord,itm,arcimDesc)
    .....s patName=##class(web.DHCEMOrdInfoVO).getPatName(ord,itm)
    .....s age=##class(web.DHCEMOrdInfoVO).getPatAge(ord)
    .....s patName=##class(web.DHCEMOrdInfoVO).getPatName(ord)
    .....s admLoc=##class(web.DHCEMOrdInfoVO).getAdmLoc(ord)
    .....s regNo=##class(web.DHCEMOrdInfoVO).getPatRegNo(ord)
    .....s medCareNo=##class(web.DHCEMOrdInfoVO).getMedCareNo(ord)
    .....s bedCode=##class(web.DHCEMOrdInfoVO).getPaBedCode(ord)
    .....s patIdentity=##class(web.DHCEMOrdInfoVO).getPatIdentity(ord)
    .....s orcatDesc=##class(web.DHCEMOrdInfoVO).getOrcatDesc(ord,itm)
    .....s oecprDesc=##class(web.DHCEMOrdInfoVO).getOecprDesc(ord,itm)
    .....s doseQtyUnit=##class(web.DHCEMOrdInfoVO).GetdoseQtyUnit(ord,itm,sub)
    .....s phcfrCode=##class(web.DHCEMOrdInfoVO).getPhcfrCode(ord,itm)
    .....s phOrdQtyUnit=##class(web.DHCEMOrdInfoVO).getPhOrdQtyUnit(ord,itm)
    .....s dosage=phOrdQtyUnit
    .....s phcinDesc=##class(web.DHCEMOrdInfoVO).getPhcinDesc(ord,itm)
    .....s notes=##class(web.DHCEMOrdInfoVO).getNote(ord,itm)
    .....s execXUserDesc=##class(web.DHCEMOrdInfoVO).getExecXUserDesc(ord,itm)
    .....s execXDateTime=##class(web.DHCEMOrdInfoVO).getExecXDateTime(ord,itm)
    .....s price=##class(web.DHCEMOrdInfoVO).getPrice(ord,itm,hosp)
    .....s totalAmount=##class(web.DHCEMOrdInfoVO).getTotalAmountNew(ord,itm)
    .....s Durat=##class(web.DHCEMOrdInfoVO).getDurat(ord,itm)
    .....s specDesc=##class(web.DHCEMOrdInfoVO).getSpecDesc(ord,itm)
    .....s specCollDateTime=##class(web.DHCEMOrdInfoVO).getSpecCollDateTime(ord,itm,sub)
    .....s flowSpeed=##class(web.DHCEMOrdInfoVO).getFlowSpeed(ord,itm)
    .....s seeOrderUserName=##class(web.DHCEMOrdInfoVO).getSeeOrderUserName(ord,itm)
    .....s seeOrderUserDateTime=##class(web.DHCEMOrdInfoVO).getSeeOrderUserDateTime(ord,itm)
    .....s ordDep=##class(web.DHCEMOrdInfoVO).getOrdDep(ord,itm)
    .....s reclocDesc=##class(web.DHCEMNurExe).getReclocDesc(ord,itm)
    .....s execStat=##class(web.DHCEMOrdInfoVO).getExecStat(ord,itm,sub)
    .....s ordStatDesc=##class(web.DHCEMOrdInfoVO).getOrdStatDesc(ord,itm)
    .....s ctcpDesc=##class(web.DHCEMOrdInfoVO).getCtcpDesc(ord,itm)
    .....s PatEncryptLevel=##class(web.DHCEMOrdInfoVO).GetPatEncryptLevel(ord,itm)
    .....s DspStat=##class(web.DHCEMOrdInfoVO).GetDispensingStat(oeoreId,"N")
    .....s skinTestDateTime=##class(web.DHCEMOrdInfoVO).GetSkinTestDate(ord_"||"_itm)
    .....s xDateTime=##class(web.DHCEMOrdInfoVO).GetxDateTime(ord,itm)
    .....s xCtcpDesc=##class(web.DHCEMOrdInfoVO).GetxCtcpDesc(ord,itm)
    .....s tubeColor=##class(web.DHCEMOrdInfoVO).getTubeColor(ord,itm)
    .....s mainOrdItmID = ##class(web.DHCEMOrdInfoVO).getMainOrdItmID(ord,itm)
    .....s arciSkinSet=##class(web.DHCEMOrdInfoVO).IsSkinOrd(ord,itm)
    .....s LockStatus = ##class(web.DHCEMOrdInfoVO).GetOrdLockStatus(ord,itm)
    .....s execPrice = ##class(web.DHCEMNurExe).GetExecPrice(oeoreId)
    .....s EncryptLevel=""
    .....s:$p(PatEncryptLevel,"^",1)'="" EncryptLevel=$p(PatEncryptLevel,"^",1)_"("_$p(PatEncryptLevel,"^",4)_")"
    .....s PatLevel=$p(PatEncryptLevel,"^",2)
    .....
    .....s labNo=$p(labNoInfo,"^",1)
    .....s labNoSpecDesc = $p(labNoInfo,"^",2)
    .....s:labNoSpecDesc'="" specDesc=labNoSpecDesc
    .....s placerNo=$p(^OEORD(ord,"I",itm,3),"^",36)
    .....s placerCode=$p(placerStr,"^",1)
	.....s skinRs = ##class(web.DHCEMOrdInfoVO).getSkinResult(ord_"||"_itm)
	.....s skinFlag2=##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(ord_"||"_itm)  //皮试标志，按用法维护，和以前皮试标志或关系
	.....s overTimeReqExecDate=##class(web.DHCEMOrdInfoVO).GetOverTimeReqExecDateHours(oeoreId)
	.....s isCaExec=$o(^DHCEMSV(0,"IndexOre",oeoreId,""),-1)
	.....s execNotes=##class(web.DHCEMOrdInfoVO).GetExecNotes(oeoreId)
	.....s allgryFlag= ##class(web.DHCEMOrdInfoVO).GetAllgryFlag(ord)
	.....s emOrdCat = ##class(web.DHCEMOrdInfoVO).emOrdCat(ord_"||"_itm)
	.....s SkinTestPay=""
	.....s:disposeStatCode="SkinTest" SkinTestPay=##class(web.DHCEMSkinTest).TestPayMoney(ord_"||"_itm)
	.....s ListData=adm_"&"_skinTestFlag_"&"_mainOeoreId_"&"_oeoriId_"&"_oeoreId_"&"_subOrder_"&"_prtFlag
	.....s ListData=ListData_"&"_seqNo_"&"_execCtcpDesc_"&"_prescNo_"&"_disposeStatDesc_"&"_disposeStatCode_"&"_execDateTime_"&"_createDateTime
	.....s ListData=ListData_"&"_sttDateTime_"&"_arcimDesc_"&"_patName_"&"_admLoc_"&"_regNo_"&"_medCareNo_"&"_bedCode
	.....s ListData=ListData_"&"_patIdentity_"&"_orcatDesc_"&"_oecprDesc_"&"_doseQtyUnit_"&"_phcfrCode_"&"_phOrdQtyUnit_"&"_dosage_"&"_phcinDesc
	.....s ListData=ListData_"&"_notes_"&"_execXUserDesc_"&"_execXDateTime_"&"_price_"&"_totalAmount_"&"_Durat_"&"_specDesc
	.....s ListData=ListData_"&"_specCollDateTime_"&"_flowSpeed_"&"_seeOrderUserName_"&"_seeOrderUserDateTime_"&"_ordDep_"&"_reclocDesc_"&"_execStat
	.....s ListData=ListData_"&"_ordStatDesc_"&"_ctcpDesc_"&"_DspStat_"&"_skinTestDateTime_"&"_xDateTime_"&"_xCtcpDesc_"&"_tubeColor
	.....s ListData=ListData_"&"_EncryptLevel_"&"_PatLevel_"&"_labNo_"&"_placerNo_"&"_placerCode_"&"_age_"&"_skinRs_"&"_skinFlag2
	.....s ListData=ListData_"&"_mainOrdItmID_"&"_arciSkinSet_"&"_LockStatus_"&"_execPrice_"&"_groupNo_"&"_overTimeReqExecDate_"&"_isCaExec
	.....s ListData=ListData_"&"_execNotes_"&"_allgryFlag_"&"_emOrdCat_"&"_SkinTestPay
	.....w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData,"&")
	.....s subflag=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
    .....i subflag="" d
    ......s ^TMP("NurExecOrderAttach",userId,$p(^OEORD(ord),"^",1),ord,itm,+sub)=""
	w "],""total"":"_sumcount
	
	s count=1
	w ",""info"":["
	s shet=""
	f  s shet=$o(^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,shet)) q:shet=""  d
	.w $case(count,1:"",:",")
	.s num=+^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,shet)
	.s jsonObj=##class(web.DHCAPPJsonObject).%New()
	.d jsonObj.Put("shet",shet)
	.d jsonObj.Put("num",num)
	.w jsonObj.Json()
	.s count=count+1
	w "]"
	w "}"
	k ^TMP("web.DHCEMNurExe","getExeOrders",pid)
	k ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid)
	k ^TMP("web.DHCEMNurExe","allOrders",pid)
	k ^TMP("web.DHCEMNurExe","getExeOrders","OneGroup",pid)
	k ^TMP("web.DHCEMNurExe","getExeOrders","groupNo",pid)
	q ""
}

ClassMethod setOrdExecData(pid, LgParams, ord, itm, sub, Exec, UnExec, StartDate, EndDate, RelyOnMainOrd)
{
	n (pid,LgParams,QueryType,ord,itm,sub,Exec,UnExec,StartDate,EndDate,RelyOnMainOrd)

	s ordSttDate="",ordSttTime="",mainOrdExeID=""
	s mainOrdItmID=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
	s:mainOrdItmID="" mainOrdItmID=ord_"||"_itm
	i sub'="" d
	.s ordSttDate=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",1)
    	.s ordSttTime=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",2)
    	.s mainOrdExeID=mainOrdItmID_"||"_sub
   	 i sub="" d
	.s ordSttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   
    	.s ordSttTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)
    	.s mainOrdExeID=mainOrdItmID
	
	q:ordSttDate<StartDate
	q:ordSttDate>EndDate
	
	;取停止时间
	s stopDate=$p(^OEORD(ord,"I",itm,3),"^",34)		
	s stopTime=$p($g(^OEORD(ord,"I",itm,2)),"^",15)	
	;没停止日期时,取预停日期
	s:stopDate="" stopDate=$p(^OEORD(ord,"I",itm,9),"^",9)		
	s:stopTime="" stopTime=$p(^OEORD(ord,"I",itm,9),"^",10)			
	;过滤停止或预停时间之后的执行记录
	q:((ordSttDate>stopDate)||((ordSttDate=stopDate)&&(ordSttTime>stopTime)))&&(stopDate'="")&&(stopTime'="") 
	
	s LgHospID = $p(LgParams,"^",1)
	s LgLocID = $p(LgParams,"^",2)
 	s LgGroupID=$p(LgParams,"^",3)
 	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",LgHospID) 
 	
	q:##class(web.DHCEMNurExe).checkExec(ord,itm,sub,Exec,UnExec)=0
	s DisposeStatCode=##class(web.DHCEMNurExe).updateDisposeStatCode(ord,itm,sub)
	s MainSeqNo=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
	s LabNoInfo=##class(web.DHCEMOrdInfoVO).getLisOrdLabNo(ord,itm)
 	s LabNo=$p(LabNoInfo,"^",1)
 	
	s ID=##class(web.DHCEMNurExe).GetExecFormAutID(HospID,LgLocID,LgGroupID)
 	s Type=$p($g(^DHCEMEFSAA(ID)),"^",2)	
	s DefaultTypeID=$p($g(^DHCEMEFSAA(ID)),"^",3)
 	i Type'="" d
 	.s Len=$L(Type,"#")
 	.for i=1:1:Len d
 	..s ExecFormID=$p(Type,"#",i)
 	..s SheetCode=$p(^DHCEMEFS(ExecFormID),"^",1)
 	..q:SheetCode="Default"
 	..q:..CheckCon(LgParams,SheetCode,ord,itm,DisposeStatCode,Exec,UnExec)=0
 	..;下面是主子医嘱是否含皮试医嘱不显示的判断
 	..s IsHasLinkOrd=1
	..i RelyOnMainOrd=2 d
	...s Link=..GetLinkOEORI(ord_"||"_itm)
	...q:Link=""
	...s LinkLen=$L(Link,"^")
 	...for k=1:1:LinkLen q:IsHasLinkOrd=0  d
 	....s LinkOrd=$p(Link,"^",k)
	....s DisposeStatCodeLink = ##class(web.DHCEMNurExe).updateDisposeStatCode(+LinkOrd,$p(LinkOrd,"||",2),sub)
	....s IsHasLinkOrd=..CheckCon(LgParams,SheetCode,+LinkOrd,$p(LinkOrd,"||",2),DisposeStatCodeLink,Exec,UnExec)
	..q:(+RelyOnMainOrd=2)&&(+IsHasLinkOrd=0)		///主子医嘱不单独显示 //依赖子医嘱显示
 	..;下面是子医嘱是否显示的判断
 	..s SeqNoOrd="",SeqNoItm=""
	..s:MainSeqNo'="" SeqNoOrd=+MainSeqNo,SeqNoItm=$p(MainSeqNo,"||",2)
	..s IsHasMainOrd=""
	..i RelyOnMainOrd=1 d
	...s:MainSeqNo="" IsHasMainOrd=1
	...q:IsHasMainOrd=1
	...s SeqNoDisposeStatCode = ##class(web.DHCEMNurExe).updateDisposeStatCode(SeqNoOrd,SeqNoItm,sub)
	...s IsHasMainOrd=..CheckCon(LgParams,SheetCode,SeqNoOrd,SeqNoItm,SeqNoDisposeStatCode,Exec,UnExec)
	..q:(+RelyOnMainOrd=1)&&(+IsHasMainOrd=0)		///子医嘱不单独显示
	..s ThisOrdExecID= ord_"||"_itm_"||"_sub
	..s Order="X"
	..s:DisposeStatCode="Immediate" Order="A" 
 	..;执行单医嘱或者执行记录ID
 	..i sub="" d
	...s Order=Order_"^"_+LabNo
	...s SeqNo=""
	...s:MainSeqNo'="" SeqNo=MainSeqNo
	...s:MainSeqNo="" SeqNo=ord_"||"_itm
	...s ^TMP("web.DHCEMNurExe","getExeOrders",pid,SheetCode,Order,ordSttDate_"^"_ordSttTime,SeqNo,itm,"X")=DisposeStatCode_"^"_LabNoInfo
	..i sub'="" d
	...s SeqNo=""
    ...s:MainSeqNo'="" SeqNo=+MainSeqNo_"||"_$p(MainSeqNo,"||",2)_"||"_sub
	...s:MainSeqNo="" SeqNo=ord_"||"_itm_"||"_sub
	...s Order=Order_"^"_+LabNo
	...;存一组医嘱的总医嘱数
	...i '$d(^TMP("web.DHCEMNurExe","getExeOrders",pid,Order,SeqNo)) d
	....s ^TMP("web.DHCEMNurExe","getExeOrders",pid,Order,SeqNo)=1
	...e  d
	....i ((ord_"||"_itm)'=SeqNo)&&('$d(^TMP("web.DHCEMNurExe","getExeOrders",pid,Order,SeqNo,itm))) d
	.....s ^TMP("web.DHCEMNurExe","getExeOrders",pid,Order,SeqNo)=+^TMP("web.DHCEMNurExe","getExeOrders",pid,Order,SeqNo)+1  //一组医嘱的医嘱数
	...;存医嘱
	...s ^TMP("web.DHCEMNurExe","getExeOrders",pid,SheetCode,Order,ordSttDate_"^"_ordSttTime,SeqNo,itm)=1
	...;存执行记录
	...s ^TMP("web.DHCEMNurExe","getExeOrders",pid,SheetCode,Order,ordSttDate_"^"_ordSttTime,SeqNo,itm,sub)=DisposeStatCode_"^"_LabNoInfo
 	..q:$d(^TMP("web.DHCEMNurExe","getExeOrders","OneGroup",pid,SheetCode,mainOrdExeID))
 	..s ^TMP("web.DHCEMNurExe","getExeOrders","OneGroup",pid,SheetCode,mainOrdExeID)=""	///使界面按照组显示数量
 	..;每组医嘱数量显示
 	..i $d(^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,SheetCode)) d
 	...s ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,SheetCode)=^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,SheetCode)+1
 	..e  d
 	...s ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,SheetCode)=1	
 	q 0
}

/// w ##Class(web.DHCEMNurExe).GetLinkOEORI("208||5")
ClassMethod GetLinkOEORI(ORI As %String) As %String
{
	n (ORI)
	s Ret=""
	s Ord=+ORI,ItmNum=$p(ORI,"||",2)
	s OEORIDR=$p(^OEORD(Ord,"I",ItmNum,11),"^",39)
	s:OEORIDR'="" Ret=OEORIDR //所有关联医嘱
	s:OEORIDR="" OEORIDR=ORI
	
	s CH=""
    f  s CH=$o(^OEORDi(0,"OEORI",Ord,OEORIDR,CH)) q:(CH="")  d
	.s OrdItm=Ord_"||"_CH
	.q:OrdItm=ORI
	.q:..GetIfSkin(Ord,CH)'="Y"
	.s:Ret'="" Ret=Ret_"^"_OrdItm
	.s:Ret="" Ret=OrdItm
	q Ret
}

/// 是否皮试
/// w ##Class(web.DHCEMNurExe).GetIfSkin("396||8")
ClassMethod GetIfSkin(ord As %String, itm As %String) As %String
{
	n (ord,itm)
	s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)    
	s skintest2=##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(ord_"||"_itm)
	s:skintest2=1 skintest="Y"
	q skintest
}

/// Creator: zhouxin
/// CreatDate: 2016.06.30
/// Description: 根据菜单类型,日期时间段,登记号取病人就诊串
/// Table：
/// Input：
/// Return：admStr 就诊号串 ^分割
ClassMethod getAdmStrByRegNo(RegNo As %String, Type As %String, StartDate As %String, EndDate As %String, papmiId = "")
{
	 n (RegNo, Type ,StartDate,EndDate, DayNum,papmiId)
	 i Type="" s Type="OE"
	 s:papmiId="" papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
     q:papmiId="" ""
     s admStr="",num=1
     
     s typeStr="O^E^I"
     f i=1:1:$l(typeStr,"^") d
     .s temptype=$p(typeStr,"^",i)
     .q:(temptype="O")&&(Type'["O")
     .q:(temptype="E")&&(Type'["E")
     .q:(temptype="I")&&(Type'["I")
     .s EpisodeID=""
     .f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",temptype,EpisodeID),-1) q:EpisodeID=""  d  
     ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
     ..q:(temptype'="I")&&(pavisit'="A")
     ..q:(temptype="I")&&(pavisit'="P")
     ..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
     ..//q:admDate<StartDate
     ..q:admDate>EndDate
     ..s $p(admStr,"^",num)=EpisodeID
     ..s num=num+1
     q admStr
}

ClassMethod getAllAdmStrByRegNo(AllPatientId, OrdType, StartDate, EndDate)
{
	n (AllPatientId,OrdType,StartDate,EndDate)
	s RetAllAdmStr=""
	s GetAdmPatLen=$l(AllPatientId,",")
	f GetAdmPatIndex=1:1:GetAdmPatLen d
	.s GetAdmPatientId=$p(AllPatientId,",",GetAdmPatIndex)
	.q:GetAdmPatientId=""
	.s AdmStrOnePat=##class(web.DHCEMNurExe).getAdmStrByRegNo("",OrdType, StartDate, EndDate,GetAdmPatientId)
	.b ;AdmStrOnePat
	.q:AdmStrOnePat=""
	.s:RetAllAdmStr'="" RetAllAdmStr=RetAllAdmStr_"^"_AdmStrOnePat
	.s:RetAllAdmStr="" RetAllAdmStr=AdmStrOnePat
	q RetAllAdmStr
}

/// 验证患者
/// 
ClassMethod validOrdAdm(ThisEpisodeID, AllPatientId, Type)
{
	n (ThisEpisodeID,AllPatientId,Type)	
	s DbAllPatientId=","_AllPatientId_","
	s ThisPatientID=+^PAADM(ThisEpisodeID)
	q:DbAllPatientId'[(","_ThisPatientID_",") "N"
	
	i Type="" s Type="OE"
	s ThisAdmType=$p(^PAADM(ThisEpisodeID),"^",2)
	q:Type'[ThisAdmType "N"
	s ThisAdmVisit=$p($g(^PAADM(ThisEpisodeID)),"^",20)
	q:(ThisAdmType'="I")&&(ThisAdmVisit'="A") "N"
    q:(ThisAdmType="I")&&(ThisAdmVisit'="P") "N"	;预住院
	q "Y"
}

/// 取处置状态代码
ClassMethod GetDisposeStatCode(codeStr)
{
	n (codeStr)
	s resCode=""
	s codeNum=$l(codeStr,"#")
	f ipos=1:1:codeNum d
	    .s codeId=$p(codeStr,"#",ipos)
	    .i codeId="" q
	    .s $p(resCode,"#",ipos)=$p($g(^DHCCLNurseExec("DisposeStat",codeId)),"^",2)
	q resCode
}

/// 返回执行记录状态更新为配置里维护的
/// w ##class(web.DHCEMNurExe).updateDisposeStatCode(1147,74,1)
ClassMethod updateDisposeStatCode(ord, itm, sub)
{
	n (ord, itm, sub)
	//0 不判断收费
    s feeflag=##class(web.DHCEMOrdInfoVO).checkFeeFlag(ord,itm)

	s disposeStatCode="Needless"
	s oecprCode="" 
    s oecprId=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
    s:oecprId'="" oecprCode=$p($g(^OECPR(oecprId)),"^")
    	
    s ordStatusId=$p($g(^OEORD(ord,"I",itm,1)),"^",13)  
    s ordState=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
    
    s:+sub'=0 execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	s execStatusCode=""
    i $g(execStatusId)'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1) 
    
    
	
    //医嘱停止
	s:ordState="D" disposeStatCode="Discontinue"
    //医嘱已执行
    s:execStatusCode="F" disposeStatCode="Exec"
    //需处理即刻
    s:(oecprCode="STAT")&(ordState="V")&(execStatusCode="") disposeStatCode="Immediate" 
    //需处理临嘱
    s:((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="ONE")!(oecprCode="OUT"))&(ordState'="D")&((execStatusCode="")) disposeStatCode="Temp" 

    //未收费	
    s isPayManey = ##class(web.DHCEMNurExe).YetPayManey(ord_"||"_itm_"||"_sub)    //计费接口
    s:'isPayManey disposeStatCode="UnPaid"
    
    ///自备药等不需收费，直接置需处理
    s:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMLSZT")!(oecprCode="OMCQZT") disposeStatCode = "Temp"   //qqa 2018-03-31
    
    //皮试:先判断收费,再判断皮试(在点击皮试按钮时会判断收费)
    s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)
    s abnorm=$p($g(^OEORD(ord,"I",itm,11)),"^",3)
    
	s skintest2=##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(ord_"||"_itm)
	s:skintest2=1 skintest="Y"
	
	//判断主医嘱皮试状态
	s moeori=$p(^OEORD(ord,"I",itm,11),"^",39)  // 主医嘱ID
	i (skintest'="Y")&&(+moeori'=0) d
	.s abnorm=$p($g(^OEORD(+moeori,"I",$p(moeori,"||",2),11)),"^",3)
	.s skintest=$p($g(^OEORD(+moeori,"I",$p(moeori,"||",2),5)),"^",2)
	.s skintest2=##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(moeori)
	.s:skintest2=1 skintest="Y"

    //执行记录皮试标志,ST表示皮试
    i (skintest="Y")&(ordState'="D") d
    .;i ($G(execStatusCode)'="F")&($G(execStatusCode)'="R") d  
    .i $G(execStatusCode)'="R" d
	..s disposeStatCode="SkinTest"
    ..s:(abnorm="N") disposeStatCode="SkinTestNorm"
	..s:(abnorm="Y") disposeStatCode="SkinTestAbnorm"	

    //不需处理
    s:oecprCode="OMLSZT" disposeStatCode="Needless"   //liangqiang  2018/03/30
    
    q disposeStatCode
}

/// Description: 执行医嘱
/// Table：
/// Input：oeoreId:医嘱执行表ID,execStatusCode:F 执行 C 撤销执行 ,userId:执行人SS_UserDr,userDeptId:执行人登陆科室,queryTypeCode:单据代码,execDate:执行日期,execTime:执行时间
/// Return：
ClassMethod UpdateExecStat(oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, exeRemark)
{

    n (oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,execDate,execTime,exeRemark)

    s execStatusId=$o(^OEC("STAT",0,"Code",execStatusCode,""))  
    s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
    i execDate'=""  s execDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(execDate) //hxy $zdh(execDate,4)
    i execDate="" s execDate=curDate
    i execTime'="" s execTime=$zth(execTime)
    i execTime="" s execTime=curTime
    s execTime=+execTime
    s ctpcpId=$p(^SSU("SSUSR",userId),"^",14)   
    s ok=""
    q:((execDate>curDate)!((execDate=curDate)&(execTime>curTime))) "执行时间不能大于当前时间！"
   
    s oeordId=$p($g(oeoreId),"||",1)
    s oeoriSub=$p($g(oeoreId),"||",2)
    s oeoreSub=$p($g(oeoreId),"||",3)  
    s admId=+^OEORD(oeordId)
    s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    ;s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,oeoreSub)),"^",1)
    ;s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,oeoreSub)),"^",2)
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) 
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    //i (((execDate<sttDate)!((execDate=sttDate)&(execTime<sttTime))))&(execStatusCode="F") s ok="执行时间不应小于开始时间!" q ok
    s canDo=0
    
    s oecprCode=##Class(web.DHCEMOrdInfoVO).GetOecprCode(oeoriId)
	q:oecprCode="" "无医嘱优先级!" 
    i (oecprCode'["OM")&(oecprCode'["OMST") s canDo=##Class(web.DHCEMNurExe).CanUpdateExec(oeoreId,userId) 
    q:(canDo'=0)&(canDo'="-1")&(canDo'="-2") canDo
    
    s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    s unitUomId=""
    i doseQty'="" d
        .s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
        
       
    //检验插入执行记录
    
    i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d  //无执行记录
    .//&js<alert("come in oeore i "+"#(oeordId)#"+"/"+"#(oeoriSub)#");>
    .K PLIST
    .s PLIST(0)=oeordId_"||"_oeoriSub
    .s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
    .s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
    .;s PLIST(35)=$h   ;OEORE_StDateTime
    .s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
    .s PLIST(40)=execStatusId   ;状态OEORE_Order_Status_DR
    .s PLIST(41)=0    ;OEORE_PhQtyIss
    .s PLIST(42)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)      ;剂量OEORE_QtyAdmin
    .s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
    .s PLIST(44)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)    ;单位OEORE_CTUOM_DR
    .s PLIST(46)=execDate      ;日期OEORE_DateExecuted
    .s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
    .s PLIST(50)=""   ;OEORE_SignFile 座位号
    .s PLIST(72)=exeRemark  ; 执行备注 bianshuai 2019-05-30
    .//s ok=$$insert^MVBOEEXE(oeoriId) ;
    .&sql(insert into OE_OrdExec Values PLIST())
    .i SQLCODE s ok="执行记录插入有误!"
    .q:ok'=""
    .s oeoreId=$g(%ROWID)
    q:ok'="" ok      
    
    ;OEORE_QtyAdmin=:doseQty,
	;OEORE_CTUOM_DR=:unitUomId,
	;这两个字段不做修改,医生站已经自动生成 2020-09-10 qqa
    
	&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,
				OEORE_Order_Status_DR=:execStatusId,
				OEORE_DateExecuted=:execDate,
                OEORE_TimeExecuted=:execTime,
                OEORE_Notes=:exeRemark
                    where oeore_rowid=:oeoreId)
     i SQLCODE s ok="执行记录修改有误!"
     q:ok'="" ok
     //s resStr=0
     //i (canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s resStr=##Class(web.DHCEMNurExe).AdjustStock(oeoreId) //ypz 070413
     //i (resStr'=-1)&(resStr'=-2) s ok=resStr
     q:ok'="" ok
     s ok=..UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
     s:+ok=0 ret=..UpdatespecCollDatetime(oeoreId,userId) //检验单执行更新采血时间操作
     q ok
}

ClassMethod CanUpdateExec(oeoriId, userId)
{
	n (oeoriId,userId)
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	s resStr=0
    // 绿色通道 (1:是,其他：否)
	s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
	//（0：走普通收费模式，1：走押金模式）
    s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(oeordId)

    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag="Y")&(actCode'="YY") q 0
    s prtId=""  //2017.09.01统一取计费接口 liangqiang   
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1  //not affect
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag'=1 q -2  //not affect
    s phwId=$o(^DHCPHWINi(phlId,""))
    s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
    i phpId="" q "未设定药房用户,不能操作!"
	q resStr
}

ClassMethod UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode) As %String
{
	n (oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
    i oeoreId="" q 0  
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId="" d
        .&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Ssuser_Dr,DHCORE_OEORE_Date,DHCORE_OEORE_Time,DHCORE_CTLOC_Dr,DHCORE_QueryCode) Values(:oeoreId,:userId,:curDate,:curTime,:userDeptId,:queryTypeCode))
    e  d
        .&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:userId,DHCORE_OEORE_Date=:curDate,DHCORE_OEORE_Time=:curTime,DHCORE_CTLOC_Dr=:userDeptId,DHCORE_QueryCode=:queryTypeCode where DHCORE_RowId=:dhcoreId)
    q SQLCODE
}

/// 	;撤消已处理记录
ClassMethod UndoUpdateExecStat(oeoreId, userId, queryTypeCode)
{
	n (oeoreId, userId,queryTypeCode)
	s oeordId=$p($g(oeoreId),"||",1)
	s oeoriSub=$p($g(oeoreId),"||",2)
	s oeoreSub=$p($g(oeoreId),"||",3) 
	s oeoriId=oeordId_"||"_oeoriSub 
	s ctcpName=""
	k PLIST
	s resStr=0
    s canDo=0
    s oecprCode=##Class(web.DHCEMOrdInfoVO).GetOecprCode(oeoriId)
	q:oecprCode="" "无医嘱优先级!" 
    
    i oecprCode'["OM" s canDo=..CanUpdateExec(oeoreId,userId)  //lq 170816嘱托、自备医嘱也不控制
    i (canDo'=0)&(canDo'="-1")&(canDo'="-2") s ok=canDo q ok
	s billFlag="I",nullStr=""
	s oeoreId=oeoriId_"||"_oeoreSub
	;OEORE_QtyAdmin=:nullStr,
	&sql(update Oe_ordexec set 
		OEORE_Order_Status_DR=:nullStr,
		OEORE_CTPCP_DR=:nullStr,
		OEORE_DateExecuted=:nullStr,
		OEORE_TimeExecuted=:nullStr,
		OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	i SQLCODE s resStr="医嘱撤消执行失败!"
	i resStr'=0 q resStr
	//i (canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s retStr=..RetrunStock(oeoreId,userId) //ypz 070413
	//i resStr'=0 q resStr
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId'="" d 
    .&sql(update DHC_OE_OrdExec set 
    	DHCORE_Ssuser_Dr=:nullStr,
    	DHCORE_OEORE_Date=:nullStr,
    	DHCORE_OEORE_Time=:nullStr,
    	DHCORE_CTLOC_Dr=:nullStr where DHCORE_RowId=:dhcoreId)
    .s resStr=SQLCODE
    i resStr'=0 s resStr="修改医嘱执行扩展表有误!"
	
	s ret = ##class(web.DHCEMNurExe).CancelNursePatAllergy(oeoriId,userId)
	q:ret<0 "停用过敏记录出错！"
	
	s:queryTypeCode["PSD" $p(^OEORD(+oeordId,"I",oeoriSub,11),"^",3)=""  //置空皮试结果
	
 	s ret=##Class(web.DHCEMSkinTest).SynSkinResult(oeoriId,"","","",+$h,$p($h,",",2)) //hxy 2020-07-09 治疗医嘱同步结果 st
 	q:ret'=0 ret //ed
    s resStr=+..CancelspecCollDatetime(oeoreId)
	q resStr
}

/// 撤销执行撤销过敏录入
/// w ##class(web.DHCEMNurExe).CancelNursePatAllergy("4833||4","13806")
ClassMethod CancelNursePatAllergy(OrdItmID, UserID)
{
	n (OrdItmID,UserID)
	
	s NeedInsAllerg = ##Class(DHCDoc.Interface.Inside.ServiceOrd).GetAutoInsertAllergiesFlag(OrdItmID)
	q:NeedInsAllerg'="Y" 0
	
	s Ord=+OrdItmID
	s Sub=$p(OrdItmID,"||",2)
	
	s SkinRs = $p(^OEORD(Ord,"I",Sub,11),"^",3)
	q:SkinRs'="Y" 0
	
	s Ret=+##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.CancelNursePatAllergy",OrdItmID,UserID) ;返回值：0 成功 其他：失败 需护士站和新产品在修改皮试结果为阴性时调用
	q Ret
}

/// Description: 判断医嘱是否能执行 
/// Table：
/// Input：oeoreId:医嘱执行表ID,execStatusCode:F 执行 C 撤销执行,userId:执行人SS_UserDr,userDeptId:执行人登陆科室
/// Return：
ClassMethod IfCanUpdateOrdGroup(oeoreId, execStatusCode, userId, hosp, NoNeedCheckUser = "", IsSkinExec = "")
{
	n ( oeoreId, execStatusCode, userId ,hosp,NoNeedCheckUser,IsSkinExec)
	s resStr=0
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14) 
    q:(ctpcpId="")&&(NoNeedCheckUser'=1) "请以医护人员身份登录后操作!" 	//用户不是医护人员时提示
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    //q:(mainOeoriId'="")&(execStatusCode="F") "非置皮试的从医嘱不执行!"
    //q:(mainOeoriId'="")&(execStatusCode="C")&(abnorm'="Y") "非置皮试非皮试阳性从医嘱不能撤消!"
    s ordStatusCode=##Class(web.DHCEMOrdInfoVO).GetOrdStatCode(oeoriId)  //070204
    s arcicOrderType=##Class(web.DHCEMOrdInfoVO).GetOrdSubCatType(oeoriId)
    i ordStatusCode="E",execStatusCode="C",arcicOrderType'="R" q "医嘱状态为执行,不能撤消!" //ypz 070204
    s oeoreState=##Class(web.DHCEMOrdInfoVO).getExecStatCode(oeordId,oeoriSub,oeoreSub)  
    i oeoreState="F",execStatusCode="F" q "已经执行,不能重复执行!" 
    i oeoreState'="F",execStatusCode="C" q "当前状态为未执行状态,不能撤销!"
    i ordStatusCode="D" q "医嘱状态为停止,不能操作!"
    i ordStatusCode="C" q "医嘱状态为撤销,不能操作!" //hxy 2020-03-27 add
	i oeoreState="D" q "执行记录状态为停止,不能操作!"
    s skinTest=""
    i (skinTestFlag="Y")&(abnorm="")&(execStatusCode="F")&(IsSkinExec'="Y") q "请先置皮试结果!" 	;IsSkinExec未皮试自动执行医嘱,这里不做判断
    i (execStatusCode="F")&&(IsSkinExec'="Y") s resStr=##Class(web.DHCEMOrdInfoVO).CanExecSkinTestOrd(oeoriId) //判断子医嘱有无需要皮试的医嘱
    i (resStr'=0) q resStr
    i (skinTestFlag="Y")&(abnorm="Y")&(execStatusCode="F")&(IsSkinExec'="Y") q "皮试阳性！"			;IsSkinExec未皮试自动执行医嘱,这里不做判断
    s price=##class(web.DHCEMOrdInfoVO).getPrice(oeordId,oeoriSub,hosp)
    s isPayManey=""     //1:已经收钱，0：未收钱
    s isJudgeMoney = ##class(web.DHCEMNurExe).IsJudgeMoney(oeordId_"||"_oeoriSub) //是否需要判断收费 1：需要  0：不需要
    s:isJudgeMoney=0 isPayManey=1
    s:isJudgeMoney=1 isPayManey = ##class(web.DHCEMNurExe).YetPayManey(oeoreId) 
    q:('isPayManey)&&(execStatusCode="F") "未找到病人发票,或病人费用不足！！"
    s skin=##Class(web.DHCEMOrdInfoVO).SkinTestResult(oeoriId)
    q:("Y"=skin)&(execStatusCode="F")&(IsSkinExec'="Y") "皮试阳性，不允许执行！！"					;IsSkinExec未皮试自动执行医嘱,这里不做判断
    ;判断治疗用药置了阴性且已经收费的不允许撤销执行
   	s IsCureSkinOrd = ##Class(web.DHCEMOrdInfoVO).GetIsCureSKinOrd(oeoriId)
   	;q:(IsCureSkinOrd=1)&(oeoriBilled="P")&(execStatusCode="C") "治疗用药已经收费,不能撤销执行！！"
   
	s IsTreatOrd=##Class(web.DHCEMOrdInfoVO).GetIsTreatOrd(oeoriId) ; 2022-10-28 cy
	q:(IsTreatOrd=1) "治疗申请医嘱,不能操作！"
    q resStr
}

/// Description: 医嘱串执行操作:走医生站
/// 执行记录处理 执行 作废 停止
/// IsSkinExec:是否皮试自动执行
/// w ##class(web.DHCDocInPatPortalCommon).MulOrdExecDealWithCom("347||3||5","01/26/2022","16:25:19","F","","")
/// w ##class(web.DHCEMNurExe).UpdateOrdGroupNew("17||20||6^17||21||6","F","2022-01-27","14:54","备注","2^50^22^18850","ZSDO")
ClassMethod UpdateOrdGroupNew(OrdExecStr, Type, Date, Time, Remark, LgParams, QueryCode = "", IsSkinExec = "")
{
    n (OrdExecStr,Type,Date,Time,Remark,LgParams,QueryCode,IsSkinExec)
    s ^qqa("UpdateOrdGroupNew")=$lb(OrdExecStr,Type,Date,Time,Remark,LgParams,QueryCode,IsSkinExec)
   
    ;s AllLen = $l(OrdExecStr,"^")
    ;s MainOrdExecStr="",PsOrdExecStr="" 	;主执行记录ID串,皮试执行记录ID串 
	;s FormatRetData = ##class(web.DHCEMNurExe).FormatMainOrdExecStr(OrdExecStr,QueryCode,.MainOrdExecStr,.PsOrdExecStr)
    ;q:MainOrdExecStr="" "未选择主医嘱!"

 
 	s:Date'="" Date=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
	s:Time'="" Time=$zth(Time)
    
    ts
    s Err=0
    
   	///是否允许执行
    s Err=##class(web.DHCEMNurExe).IfCanUpdateOrdExec(OrdExecStr,Type,LgParams,"",IsSkinExec)
    tro:Err'=0 1
	q:Err'=0 Err
    
    ///执行
    s:Type="F" Err = ##class(web.DHCEMNurExe).OrdExecGroupExec(OrdExecStr,Type,Date,Time,Remark,LgParams)
    tro:Err'=0 1
	q:Err'=0 Err
	
	///撤销执行
    s:Type="C" Err = ##class(web.DHCEMNurExe).OrdExecGroupUnExec(OrdExecStr,Type,Date,Time,LgParams,QueryCode)
    tro:Err'=0 1
	q:Err'=0 Err
	
	tc
	q Err
}

/// Creator: 		qqa
/// CreatDate: 		2022-01-27
/// Description: 	执行执行记录状态
/// Input：			oeoreId：主医嘱OE_OrdExec表ID，execStatusCode：执行状态代码
/// 				userId：执行用户ID，userDeptId：登录科室ID，changeReasonDr：执行备注
/// 				execDate：执行日期，execTime：执行时间
/// Return：		
/// Other:			w ##class(web.DHCEMNurExe).UpdateExecStat
ClassMethod OrdExecGroupExec(OrdExecStr, StatusCode, ExecDate, ExecTime, Remark, LgParams)
{
	
	s Err=0
	
	s HospID = $p(LgParams,"^",1)
	s LocID = $p(LgParams,"^",2)
	s UserID = $p(LgParams,"^",4)
	
	
	f i=1:1:$l(OrdExecStr,"^") q:Err'=0  d
	.s OrdExecID=$p(OrdExecStr,"^",i)
	.q:+OrdExecID=0
    .s Ord=+OrdExecID,Itm=$p(OrdExecID,"||",2),Sub=$p(OrdExecID,"||",3)
    .s OrdItemId=Ord_"||"_Itm
    .s MainOrd=$p(^OEORD(Ord,"I",Itm,11),"^",39)
    .b ;err1
    .s:MainOrd="" Err = ##class(web.DHCEMNurExe).OrdExecGroupUpdate(OrdExecID,"F",LocID,UserID,ExecDate,ExecTime) ;执行
    .b ;err2
    .q:Err'=0
    .s Err = ##class(web.DHCEMNurExe).UpdateExecNotes(OrdExecID,Remark)	;备注
    .s:Err'=0 Err="添加执行备注失败!"
    .q:Err'=0
    .
    .s Err= +##class(web.DHCEMNurExe).UpdatespecCollDatetime(OrdExecID,UserID) 				;检验单执行更新采血时间操作
    
    q Err
}

/// Creator: 		qqa
/// CreatDate: 		2022-01-27
/// Description: 	执行执行记录状态
/// Input：			oeoreId：主医嘱OE_OrdExec表ID，execStatusCode：执行状态代码
/// 				userId：执行用户ID，userDeptId：登录科室ID，changeReasonDr：执行备注
/// 				execDate：执行日期，execTime：执行时间
/// Return：		
/// Other:			w ##class(web.DHCEMNurExe).UpdateExecStat
ClassMethod OrdExecGroupUnExec(OrdExecStr, StatusCode, ExecDate, ExecTime, LgParams, QueryCode)
{
	
	s Err=0
	
	s HospID = $p(LgParams,"^",1)
	s LocID = $p(LgParams,"^",2)
	s UserID = $p(LgParams,"^",4)
	
	f i=1:1:$l(OrdExecStr,"^") q:Err'=0  d
	.s OrdExecID=$p(OrdExecStr,"^",i)
	.q:+OrdExecID=0
    .s Ord=+OrdExecID,Itm=$p(OrdExecID,"||",2),Sub=$p(OrdExecID,"||",3)
    .s OrdItemId=Ord_"||"_Itm
    .s MainOrd = $p(^OEORD(Ord,"I",Itm,11),"^",39)
    .s:MainOrd="" Err = ##class(web.DHCEMNurExe).OrdExecGroupUpdate(OrdExecID,"C",LocID,UserID,ExecDate,ExecTime) ;执行,只执行主医嘱
    .q:Err'=0
   	.
	.s Err = ##class(web.DHCEMNurExe).CancelNursePatAllergy(OrdItemId,UserID)
	.s:Err<0 Err="停用过敏记录出错！"
	.q:Err'=0
	.s:QueryCode["PSD" $p(^OEORD(+Ord,"I",Itm,11),"^",3)=""  								//置空皮试结果
	.
	.s Err=##Class(web.DHCEMSkinTest).SynSkinResult(OrdExecID,"","","",+$h,$p($h,",",2)) 	//治疗医嘱同步结果
	.s:Err<0 Err="治疗医嘱同步结果失败！"
 	.q:Err'=0 
 	.
    .s Err=+##class(web.DHCEMNurExe).CancelspecCollDatetime(OrdExecID) 					//清空采血时间
    q Err
}

/// Creator: 		qqa
/// CreatDate: 		2022-01-27
/// Description: 	更新执行记录状态
/// Input：			OrdExecStr：主医嘱OE_OrdExec表ID，
/// 					StatusCode：执行状态代码 F/C
/// 				UserId：执行用户ID，LocId：登录科室ID，ChangeReason：执行备注
/// 				ExecDate：执行日期，ExecTime：执行时间
/// Return：		
/// Other:			w 
ClassMethod OrdExecGroupUpdate(MainOrdExecID, StatusCode, LocId, UserId, ExecDate, ExecTime)
{
	s Ret = ##class(appcom.OEOrdExec).UpdateStatus(MainOrdExecID,StatusCode,UserId,ExecDate,ExecTime,"","","",LocId,"N")
	q Ret
}

/// 格式化执行记录
/// 主执行记录ID串!皮试执行记录ID串
ClassMethod FormatMainOrdExecStr(OrdExecStr, QueryCode, ByRef MainOrdExecStr, ByRef PsOrdExecStr)
{
	s AllLen = $l(OrdExecStr,"^")
    f i=1:1:AllLen d
	.s ItemOrdExec = $p(OrdExecStr,"^",i)
	.s Ord = $p(ItemOrdExec,"||",1)
	.s Itm = $p(ItemOrdExec,"||",2)
	.i QueryCode["PSD" d
	..s IsSkinOrd=##class(web.DHCEMSkinTest).IsSkinOrder(Ord,Itm) 
	..s:PsOrdExecStr PsOrdExecStr=PsOrdExecStr_"^"_ItemOrdExec
	..s:'PsOrdExecStr PsOrdExecStr=ItemOrdExec
	.s MainOrd=$p(^OEORD(Ord,"I",Itm,11),"^",39)
	.q:MainOrd'=""
	.s:MainOrdExecStr MainOrdExecStr=MainOrdExecStr_"^"_ItemOrdExec
	.s:'MainOrdExecStr MainOrdExecStr=ItemOrdExec	
	q MainOrdExecStr_"!"_PsOrdExecStr
}

/// 执行记录添加备注 
/// w ##class(web.DHCEMNurExe).UpdateExecNotes("4||80||1","测试")
ClassMethod UpdateExecNotes(OEORERowId As %String, Notes As %String) As %String
{
	
	;EORE_CTPCP_DR=:ctpcpId,
	;OEORE_Order_Status_DR=:execStatusId,
	;OEORE_DateExecuted=:execDate,
    ;OEORE_TimeExecuted=:execTime,
	&sql(UPDATE OE_OrdExec SET OEORE_Notes=:Notes WHERE OEORE_RowID=:OEORERowId)
    q SQLCODE
}

/// 是否允许执行/撤销执行
/// NoNeedCheckUser：是否要求用户为医护人员
/// w ##class(web.DHCEMNurExe).IfCanUpdateOrdExec("347||3||5","F","2^^^18850")
ClassMethod IfCanUpdateOrdExec(OrdExecIdStr, Type, LgParams, NoNeedCheckUser = "", IsSkinExec = "")
{
	n (OrdExecIdStr,Type,LgParams,NoNeedCheckUser,IsSkinExec)
	s LgHospID = $p(LgParams,"^",1)
	s LgUserID = $p(LgParams,"^",4)

	s Err=0
	s OrdExecLen=$l(OrdExecIdStr,"^")
	f OrdExecIndex=1:1:OrdExecLen q:Err'=0  d
	.s OrdExecRowID = $p(OrdExecIdStr,"^",OrdExecIndex)
	.s Err =##class(web.DHCEMNurExe).IfCanUpdateOrdGroup(OrdExecRowID,Type,LgUserID,LgHospID,NoNeedCheckUser,IsSkinExec)  ///qqa 2017-08-25 这里增加了医院，用于获取医嘱费用
	q Err
}

/// 撤销皮试结果和同步治疗药结果
ClassMethod UndoSkinRs(OrdExecStr)
{
	s Ret=0
	s Len = $l(OrdExecStr,"^")
	f i=1:1:Len q:Ret'=0  d
	.s ThisOrdExecId=$p(OrdExecStr,"^",i)
	.s Ord = $p(ThisOrdExecId,"||",1)
	.s Itm = $p(ThisOrdExecId,"||",2)
	.s $p(^OEORD(Ord,"I",Itm,11),"^",3)=""  //置空皮试结果
	.s Ret=##Class(web.DHCEMSkinTest).SynSkinResult(Ord_"||"_Itm,"","","",+$h,$p($h,",",2)) 	//治疗医嘱同步结果
 	
 	q Ret
}

/// Description: 医嘱串执行操作 
/// Table：
/// Input：oeoreId:医嘱执行表ID,execStatusCode:F 执行 C 撤销执行 ,userId:执行人SS_UserDr,userDeptId:执行人登陆科室
/// Return：成功返回 0 失败返回 错误信息
/// w ##class(web.DHCEMNurExe).UpdateOrdGroup("1","157||127||1^157||128||1","F","1326","617","SYDO","2019-05-19","18:02")
/// w ##class(web.DHCEMNurExe).UpdateOrdGroup("2","301||8||1","C","13828","103","PSDO")
ClassMethod UpdateOrdGroupBak(HospitalRowId, oeoreIdStr, execStatusCode, userId, userDeptId, queryTypeCode, execDate = "", execTime = "", exeRemark = "", NoNeedCheckUser = "")
{
    n (oeoreIdStr, execStatusCode,userId, userDeptId, queryTypeCode, execDate, execTime, exeRemark, HospitalRowId,NoNeedCheckUser)
    

    s $zt="Err"
	s resStr=0
	TStart
	for i=1:1:$l(oeoreIdStr,"^") d
	.s oeoreId=$p(oeoreIdStr,"^",i)
	.q:resStr'=0
    .s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    .s oeoriId=oeordId_"||"_oeoriSub
    .s resStr =##class(web.DHCEMNurExe).IfCanUpdateOrdGroup(oeoreId,execStatusCode,userId,HospitalRowId,NoNeedCheckUser)  ///qqa 2017-08-25 这里增加了医院，用于获取医嘱费用
    .q:resStr'=0
    .i execStatusCode="F" d
	..s resStr=##class(web.DHCEMNurExe).UpdateExecStat(oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,execDate,execTime,exeRemark)
    .i execStatusCode="C" d
    ..s resStr=##class(web.DHCEMNurExe).UndoUpdateExecStat(oeoreId,userId,queryTypeCode)
    i resStr'=0 d
    .TRollback
	e  d
	.Tcommit
    q resStr
Err    
  TRollback
  w $ze
  q $ze
}

/// 皮试结果
/// w ##class(web.DHCEMNurExe).SetSkinTestResult("412||1||1",4,"Y")
ClassMethod SetSkinTestResult(oeoreId As %String, userId As %String, flag As %String) As %String
{
    //皮试处理
    n (oeoreId,userId,flag)
    s oeordId=+oeoreId
    s oeoriSub=$p(oeoreId,"||",2)
    s oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub

    s admId=+^OEORD(oeordId)
	s admType=$p(^PAADM(admId),"^",2)
	
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q "非皮试医嘱!"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    q:(oeoriBilled'="P")&(actCode="YY") "原液未交费不能置皮试结果!"
    i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q "已结算医嘱不能置皮试结果!" //ypz 061128
    //ypz 060924 begin
	s ordStatCode=##Class(web.DHCEMOrdInfoVO).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    i preFlag=flag q "所置状态与原来相同,未改变皮试状态!"
    //由阳性改为阴性时，已执行医嘱可以撤消
    
    s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
	s execStatusCode=""
    i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1) 
    s IfExecOrder=0  
    s:(execStatusCode="F")!(execStatusCode="D")!(execStatusCode="R") IfExecOrder=1
	i (preFlag'="Y")&(IfExecOrder=1)  q "医嘱已执行，不能置皮试结果!" //070413
	
	s arcicOrderType=##Class(web.DHCEMOrdInfoVO).GetOrdSubCatType(oeoriId)

	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	//置皮试结果时,向皮试病人列表中置皮试时间
	s resStr=0
	i admType="O" d
	.s TestAdmDr=$p($g(^OEORD(oeordId)),"^",1)
	.s parr="TestAdmDr|"_TestAdmDr_"^TestDate|"_curDate_"^TestTime|"_curTime_"^RecUser|"_userId
	.s resStr=##class(User.DHCNurSkinTestList).Save("",parr)	
	i resStr'=0 q resStr
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
	s resStr=0
	i arcicOrderType="R" s resStr=##class(web.DHCEMOrdInfoVO).UpdatePatAllergy(oeoriId,userId,flag)
	i resStr'=0 q resStr
	
	q resStr
}

/// w ##class(web.DHCEMNurExe).CheckCon("2^214^22^11843","PSDO","1147","72","SkinTestAbnorm","true","false")
ClassMethod CheckCon(LgParams, QueryType, ord, itm, disposeStatCode, Exec, UnExec)
{
	n (LgParams,QueryType,ord,itm,disposeStatCode,Exec,UnExec)
	;qqa 这里兼容老版本,不在改变入参,先通过医院和执行单Code确定执行单ID
	s HospId=$p(LgParams,"^",1)
	s HospId=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",HospId) //hxy 2020-06-16 私有：像东院成组于总院，东院应该取总院配置
	s ExecFormID = ##Class(web.DHCEMNurExe).GetExecFormID(HospId,QueryType)
	q:+ExecFormID=0 0 
	
	//下面是单据对应的查询范围
	s oecatIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecCat")_"#" //医嘱分类
    s oecprIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecPro")_"#" //优先级
    s ordStatIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecStat")_"#" //医嘱状态
    s phcinIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecPhi")_"#"  //用药途径
    s specCodeStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecSpec")_"#"  //
    s recLocStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecRecLoc")_"#" //接收科室
	s disposeStatCodeStr="#"_..GetDisposeStatCode(##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecDis"))_"#" 	//处置状态
	s allowNullStr = "ExecPhi" //##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"AllowNull")
	
	s SkinSet = ##class(web.DHCEMNurExe).GetConfigBySession("ALLSKINORD",LgParams)
	s PSDOrdFlag=0
	i (QueryType["PSD")&&(SkinSet=1) d
	.s Ret = ##class(web.DHCEMNurExe).OrdIsCheckPs(ord,itm)
	.s:Ret PSDOrdFlag=1
	q:PSDOrdFlag 1
	
	//医嘱状态
	s ordStatDr=$P($G(^OEORD(ord,"I",itm,1)),"^",13)
	q:ordStatDr="" 0
	q:(ordStatIdStr'[("#"_ordStatDr_"#"))&(ordStatDr'="") 0
	//优先级
	s oecprId=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
	s oecprCode=$p(^OECPR(oecprId),"^",1)
	q:(oecprIdStr'[("#"_oecprId_"#"))&(oecprId'="") 0
	
	//用法途径
	s phcinId=$p($g(^OEORD(ord,"I",itm,2)),"^",7)		
	q:(allowNullStr'["ExecPhi")&(+phcinId=0) 0		;为空判断是否允许为空：治疗类材料等可能无用法          
	q:((phcinIdStr'[("#"_phcinId_"#"))&(+phcinId'=0)) 0	;不为空判断列表选中的属性
	
    //医嘱子类
    s arcimId=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
    q:+arcimId=0 0
	s arcicId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)		        
	q:(oecatIdStr'[("#"_arcicId_"#"))&(arcicId'="") 0
	//标本类型	
	s specCode=$p($g(^OEORD(ord,"I",itm,"SPEC",1)),"^")   
	q:(specCodeStr'[("#"_specCode_"#"))&(specCode'="")&(specCodeStr'="^^") 0
	//接受科室	     
	s reclocId=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	//q:(recLocStr'[("^"_reclocId_"^"))&(reclocId'="")&(recLocStr'="^^") 0
    q:(disposeStatCodeStr'[("#"_disposeStatCode_"#")) 0
    //皮试
    ;s skintest=$p($g(^OEORD(ord,"I",itm,5)),"^",2)
    //皮试单据只显示勾皮试勾的医嘱
    ;q:(skintest'="Y")&&(QueryType="PSDO") 0
    
     	    
    //q:(disposeStatCodeStr'[("^"_disposeStatCode_"^"))&&(Exec'="true")&&(UnExec'="true") 0
    //q:(disposeStatCode'="Exec")&&(Exec="true") 0
    //q:(disposeStatCode="Exec")&&(UnExec="true") 0
    q 1
}

ClassMethod setTypeCount(LgParams, pid, ord, itm, disposeStatCode, Exec, UnExec)
{
 n (LgParams,pid,ord,itm,disposeStatCode,Exec,UnExec,SkinSet,%session)
 s HospId = $p(LgParams,"^",1)
 s grp=$p(LgParams,"^",3)
 s:HospId="" HospId=%session.Data("LOGON.HOSPID")
 s:grp="" grp=%session.Data("LOGON.GROUPID")
 s HospId=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",HospId) //hxy 2020-06-17 私有：像东院成组于总院，东院应该取总院配置
 ;s id = $o(^DHCEMEFSAA(0,"IndexGroup",+grp,"")) //hxy 2020-06-15 注释 st
 s id=##class(web.DHCEMNurExe).GetExecFormAutID(HospID,LgLocID,LgGroupID)

 s type=$p($g(^DHCEMEFSAA(id)),"^",2)	
 s defaultTypeID=$p($g(^DHCEMEFSAA(id)),"^",3)
 i type'="" d
 .s len=$L(type,"#")
 .for i=1:1:len d
 ..s execFormID=$p(type,"#",i)
 ..s sheetCode=$p(^DHCEMEFS(execFormID),"^",1)
 ..q:sheetCode="Default"
 ..q:..CheckCon(LgParams,sheetCode,ord,itm,disposeStatCode,Exec,UnExec)=0
 ..i $d(^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,sheetCode)) d
 ...s ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,sheetCode)=^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,sheetCode)+1
 ..e  d
 ...s ^TMP("web.DHCEMNurExe","getExeOrders","INFO",pid,sheetCode)=1
 q ""
}

/// /门诊护士执行时更新采血时间
ClassMethod UpdatespecCollDatetime(oeoriId As %String, userId As %String)
{
 
   n (oeoriId,userId)
   s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
   s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
   q:labNo="" ""   ///标本号为空的认为不是检验医嘱
   i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
   q:oeoreSub="" ""
   s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
   s curDate=+$h,curTime=$p($h,",",2)

   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj) q ""
   s SpecCollUserDR=obj.OEORESpecCollUserDR
   i SpecCollUserDR'="" q ""  ///已经采血过的不再更新
   s obj.OEORESpecCollUserDR=##class(User.SSUser).%OpenId(userId,0)
   s obj.OEORESpecCollDate=curDate
   s obj.OEORESpecCollTime=curTime
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   q ret
   }
   q 0
}

/// /门诊护士撤销执行时将采血时间置空
ClassMethod CancelspecCollDatetime(oeoriId As %String)
{
   n (oeoriId)
   s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
   s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
   q:labNo="" ""   ///标本号为空的认为不是检验医嘱
   i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
   q:oeoreSub="" ""
   s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
   s nullValue=""
   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj)   q ""
   s obj.OEORESpecCollUserDR=nullValue
   s obj.OEORESpecCollDate=nullValue
   s obj.OEORESpecCollTime=nullValue
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   q ret
   }
   q 0
}

ClassMethod checkExec(ord, itm, sub, Exec, UnExec)
{
	n (ord, itm, sub,Exec,UnExec)

	s disposeStatCode="Needless"
	s oecprCode="" 
    s oecprId=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
    s:oecprId'="" oecprCode=$p($g(^OECPR(oecprId)),"^")
    	
    s ordStatusId=$p($g(^OEORD(ord,"I",itm,1)),"^",13)  
    s ordState=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
    
    s:+sub'=0 execStatusId=$p($g(^OEORD(ord,"I",itm,"X",sub)),"^",16) //执行状态
	s execStatusCode=""
    i $g(execStatusId)'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1) 
    

    //医嘱停止
	s:ordState="D" disposeStatCode="Discontinue"
    //医嘱已执行
    s:execStatusCode="F" disposeStatCode="Exec"
    //需处理即刻
    s:(oecprCode="STAT")&(ordState="V")&(execStatusCode="") disposeStatCode="Immediate" 
    //需处理临嘱
    s:((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="ONE")!(oecprCode="OUT"))&(ordState'="D")&((execStatusCode="")) disposeStatCode="Temp" 
    
    

    q:(disposeStatCode'="Exec")&&(Exec="true") 0
    q:(disposeStatCode="Exec")&&(UnExec="true") 0
    q 1
}

/// 打印执行单用到的获取打印执行列设置配置
/// w ##class(web.DHCEMNurExe).GetPrintTitle("3@SYD[KQ]")
ClassMethod GetPrintTitleOld(queryTypeCode = "0@CQSYD") As %String
{
	s HospitalRowId=$p(queryTypeCode,"@",1)
    s TypeCode=$p(queryTypeCode,"@",2)
    i (HospitalRowId="")!(TypeCode="") q ""
	s valStr="",captionStr="",lenStr="",codeStr=""
	if '$D(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode)) {
		if $D(^DHCCLNurseExec("VarSetColumnPrtDefTyp")) 
		{
			s queryTypeCode=^DHCCLNurseExec("VarSetColumnPrtDefTyp")
			s HospitalRowId=$p(queryTypeCode,"@",1)
    		s TypeCode=$p(queryTypeCode,"@",2)
    		i (HospitalRowId="")!(TypeCode="") q "" 
		}
	}
	s no=""  f  s no=$O(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no)) q:no=""  d
		.s caption=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|")
		.s len=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",2)
		.s code=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",4)
		.s seqno=+$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",5)
		.i seqno>0 d
		    ..s $P(captionStr,"|",seqno)=caption
		    ..s $P(lenStr,"|",seqno)=len
		    ..s $P(codeStr,"|",seqno)=code
	s valStr=captionStr_"^"_lenStr_"^"_codeStr
	q valStr
}

/// Creator:    hxy
/// CreateDate: 2020-06-16
/// Description:打印执行单用到的获取打印执行列设置配置
/// w ##class(web.DHCEMNurExe).GetPrintTitle("3@SYD[KQ]")
ClassMethod GetPrintTitle(queryTypeCode = "0@CQSYD") As %String
{
	s HospitalRowId=$p(queryTypeCode,"@",1)
    s TypeCode=$p(queryTypeCode,"@",2)
    i (HospitalRowId="")!(TypeCode="") q ""
    s HospitalRowId=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",HospitalRowId) //hxy 2020-06-16 私有
	s valStr="",captionStr="",lenStr="",codeStr=""
	s mID=..GetExecFormID(HospitalRowId,TypeCode)	 
	s HasData=""
	s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+mID,"PrintSetList",""))
	s:FSIRowID'="" HasData=$p(^DHCEMEFSI(FSIRowID),"^",3)
	
	s Num=$l(HasData,"##")
	f i=1:1:Num d
	.s ItmData=$p(HasData,"##",i)
	.q:ItmData=""
	.s RowName=$p(ItmData,"|",1)
	.s RowWidth=$p(ItmData,"|",2)
	.s OrdLinkID=$p(ItmData,"|",3)
	.s OrdLinkCode=""
	.s:OrdLinkID'="" OrdLinkCode=$p(^DHCCLNurseExec("Var",OrdLinkID),"^",2)
	.s captionStr=$case(i,1:RowName,:captionStr_"|"_RowName)
	.s lenStr=$case(i,1:RowWidth,:lenStr_"|"_RowWidth)
	.s codeStr=$case(i,1:OrdLinkCode,:codeStr_"|"_OrdLinkCode)
	s valStr=captionStr_"^"_lenStr_"^"_codeStr
	q valStr
}

/// Script: 通过医嘱ID获取该医嘱下执行记录的总次数
/// Input : 医嘱ID
/// 
/// w ##class(web.DHCEMNurExe).GetExecPrice("233||13^233||12||1^233||15^233||14||1")
ClassMethod GetExecPrice(oeoreIdData)
{
	n (oeoreIdData)
	s data = ""
	s len = $l(oeoreIdData,"^")
	f i=1:1:len d
	.s oeoreId = $p(oeoreIdData,"^",i)
	.s ord = $p(oeoreId,"||",1)
	.s itm = $p(oeoreId,"||",2)
	.s esub = $p(oeoreId,"||",3)	
	.s oeoreExecDate = $p($g(^OEORD(ord,"I",itm,"X",+esub)),"^",1)
	.s sub = "0",curDayPrice=0,curPriceInDay=0
	.f  s sub = $o(^OEORD(ord,"I",itm,"X",sub))  q:sub=""  d
	..s execDate = $p(^OEORD(ord,"I",itm,"X",sub),"^",1)
	..s:oeoreExecDate=execDate curDayPrice = curDayPrice+1
	..s:esub=sub curPriceInDay = curDayPrice
	.s allPrice = $o(^OEORD(ord,"I",itm,"X",""),-1)    //总次数
	.s curPrice = $p(oeoreId,"||",3)				   //当前次数
	.s ssuDr = $p($g(^OEORD(ord,"I",itm,"X",+esub,"NUR")),"^",4)
	.s:ssuDr'="" ssuName = $p($g(^SSU("SSUSR",ssuDr)),"^",2)
	.s:ssuDr="" ssuName=""
	.s:+allPrice=0 allPrice=1
	.s:+curPrice=0 curPrice=1
	.s:curDayPrice=0 curDayPrice=1
	.s:curPriceInDay=0 curPriceInDay=1
	.s:data'="" data = data_"!"_allPrice_"^"_curPrice_"^"_curDayPrice_"^"_curPriceInDay_"^"_ssuName
	.s:data="" data =allPrice_"^"_curPrice_"^"_curDayPrice_"^"_curPriceInDay_"^"_ssuName
	q data
}

/// 取接受科室
ClassMethod getReclocDesc(oeordId As %String, oeoriSub As %String) As %String
{
	n (oeordId,oeoriSub,%session)
	s reclocDr=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	i reclocDr'="" q ##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",$p($g(^CTLOC(reclocDr)),"^",2)) 
	e  q ""
}

/// Script: 数字媒体提供：通过clientIP查找CientName和ServeName
/// Input : 
///  w ##class(web.DHCEMNurExe).GetClintServerNameByIP(" SCZ-03-PC")
ClassMethod GetClintServerNameByIP(clientIP As %String = "") As %String
{
  s TrsNull=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","入参不能为空!")
  s TrsRoot=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","电脑没有叫号权限,请联系信息科!")
  s TrsTerm=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","叫号终端未设置叫号服务!")
  s TrsServ=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","叫号服务不可用!")
  q:clientIP="" TrsNull //"入参不能为空!"
  s clientId=$O(^DHCVISClienti(0,"ClientIP",clientIP,""))
  q:clientId="" TrsRoot //"电脑没有叫号权限,请联系信息科!"
  s clientName=$P($G(^DHCVISClient(clientId)),"^",3)
  s serverId=$P($G(^DHCVISClient(clientId)),"^",1)
  q:serverId="" TrsTerm //"叫号终端未设置叫号服务!"
  s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
  q:serverActive'="Y" TrsServ //"叫号服务不可用!"
  s serverName=$P($G(^DHCVISServer(serverId)),"^",2)
  q clientName_"^"_serverName
}

/// Creator:qqa
/// CreatDate:2018-03-10
/// Dscription:判断医嘱费用问题能否直接执行
///  w ##class(web.DHCEMNurExe).YetPayManey("307||3")
ClassMethod YetPayManey(OEOREId)
{
	n (OEOREId)
	q:+OEOREId=0 ""
	s AdmID=+^OEORD(+OEOREId)
	s AdmType=$p(^PAADM(AdmID),"^",2)
	s InOrdID=""
	s:AdmType="I" InOrdID=OEOREId
	s:AdmType'="I" InOrdID=+OEOREId_"||"_$p(OEOREId,"||",2)
    s YetPayManey=1
    ;s Qty = $p($g(^OEORD(+OEOREId,"I",$p(OEOREId,"||",2),1)),"^",12) //hxy 2022-11-12 st
    s QtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(+OEOREId_"||"_$p(OEOREId,"||",2))
    s Qty=$p(QtyInfo,"^",4) //ed 应为数量(换算成基本单位)
    s Chkarr=##class(web.UDHCJFARREARSMANAGE).CheckArrears(AdmID,InOrdID_$c(2)_Qty,"NE","")
    //s:($p(Chkarr,"^",5)="C")&($p(Chkarr,"^",7)="N") YetPayManey=0
	s:($p(Chkarr,"^",7)="N") YetPayManey=0     //和白云龙沟通，2019-03-12
    q YetPayManey
}

/// 交付中心要求:特殊处理的问题
/// w ##class(web.DHCEMNurExe).SpecialHandling("PSD","false","990||11")
ClassMethod SpecialHandling(QueryType, Exec, OrdItmID)
{
	n (QueryType,Exec,OrdItmID)
	S Ret=1
	i QueryType["PSD" d
	.s ExecStatus = ##class(web.DHCEMNurExe).GetPsdExec(OrdItmID)   //都是执行
	q Ret
}

/// 交付中心要求:特殊处理的问题,1:代表执行，0代表未执行
/// 
/// w ##class(web.DHCEMNurExe).GetPsdExec("990||11")
ClassMethod GetPsdExec(OrdItmID)
{
	n (Exec,OrdItmID)
	s Ret=0	
	s Abnorm=$p($g(^OEORD(+OrdItmID,"I",$p(OrdItmID,"||",2),11)),"^",3)
	s ActId=$p($g(^OEORD(OrdItmID,"I",OrdItmID,11)),"^",21)
    s ActCode=""
    i ActId'="" s ActCode=$p(^OEC("ACT",ActId),"^",1)
    s:((ActCode'="YY")&&(Abnorm'="")) Ret = 1
    q Ret
}

/// 执行的时候是否需要判断收费
/// 1: 需要   0：不需要
/// w ##class(web.DHCEMNurExe).IsJudgeMoney("990||11")
ClassMethod IsJudgeMoney(OrdID)
{
	n (OrdID)
	s Ret=1
	s OecprCode="" 
    s OecprId=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",8)
    s:OecprId'="" OecprCode=$p($g(^OECPR(OecprId)),"^")
    ;OMLSZT^临时嘱托   OMCQZT^长期嘱托 OMST^自备药长期 OM^自备药即刻
    s:(OecprCode="OM")!(OecprCode="OMST")!(OecprCode="OMLSZT")!(OecprCode="OMCQZT") Ret=0
    q Ret
}

/// 撤销绑定条码
/// 
ClassMethod ClearPlacerFlag(OrdID)
{
	n (OrdID)
	s ord=$p(OrdID,"||",1)
	s Itm=$p(OrdID,"||",2)
	s no=$p($g(^OEORD(ord,"I",Itm,3)),"^",36)
	q:no="" 0
	q ##class(web.DHCNurCom).clearPlacerFlage(no)
}

/// 查询绑定费用
/// 
ClassMethod GetAttach(ordId, page, rows)
{
	n (ordId,page, rows,%session)
	s TraPay=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","已收费")
	s TraUnPay=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.exec.hisui.csp","未收费")
	k mainOrdArr
	s end=page*rows
	s start=(page-1)*rows+1
	s ListTitle="admDeptDesc^orcatDesc^arcimDesc^phOrdQtyUnit^price^totalAmount^ctcpDesc^reclocDesc^createDateTime^sttDateTime^ordStatDesc^phcduDesc1^oeoriId^disposeStatCode"
	s sumcount=0
	w "{""rows"":["
	f i=1:1:$l(ordId,"^") d
	.s ordExe=$p(ordId,"^",i)
	.q:+ordExe=0
	.s ord=+ordExe
	.s itm=$p(ordExe,"||",2)
	.s exe=$p(ordExe,"||",3)
	.s mainOrd=$p(^OEORD(ord,"I",itm,11),"^",39)
	.s:mainOrd="" mainOrd=ord_"||"_itm
	.q:$D(mainOrdArr(mainOrd))
	.s mainOrdArr(mainOrd)=""
	.s EpisodeID=$p(^OEORD(ord),"^",1)
    .s admDeptId=$p(^PAADM(EpisodeID),"^",4)
	.i admDeptId'="" s admDeptDesc=$p($g(^CTLOC(+admDeptId)),"^",2) 
	.s linkItm=0
	.f  s linkItm=$o(^OEORDi(0,"OEORI",ord,mainOrd,linkItm)) q:linkItm=""  d
	..
	..
	..s ordStatId=$p($g(^OEORD(ord,"I",linkItm,1)),"^",13)  ;OEORI_ItemStat_DR
	..s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
	..q:ordStatCode'="V"
	..s ordStatDesc=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
	..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(ord_"||"_linkItm)
	..q:arcicOrderType="R"
	..s arcimId=$p($g(^OEORD(ord,"I",linkItm,1)),"^",2)
	..s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10)
	..s arcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
	..s sttDate=$p($g(^OEORD(ord,"I",linkItm,1)),"^",9)   //keep duplicate
    ..s sttTime=$p($g(^OEORD(ord,"I",linkItm,1)),"^",10)  //keep duplicate
    ..s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
    ..s createDate=$p($g(^OEORD(ord,"I",linkItm,3)),"^",7)
    ..s createTime=$p($g(^OEORD(ord,"I",linkItm,1)),"^",17)
    ..s createDateTime=##Class(web.DHCCLCom).FormatDate(createDate)_" "_##Class(web.DHCCLCom).FormatTime(createTime)
    ..s orcatId=$p($g(^ARC("IC",+arcicId)),"^",8) 
    ..s orcatDesc=$p($g(^OEC("ORCAT",+orcatId)),"^",2)
    ..s reclocId=$p($g(^OEORD(ord,"I",linkItm,3)),"^",6)
    ..s hospital=$p($g(^CTLOC(reclocId)),"^",22)
    ..s reclocDesc=$p($g(^CTLOC(+reclocId)),"^",2)
    ..i reclocDesc["-" s reclocDesc=$p($p($g(^CTLOC(+reclocId)),"^",2),"-",2)
    ..s userAddId=$p($g(^OEORD(ord,"I",linkItm,7)),"^",1)
    ..s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    ..s:ctcpId'="" ctcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
    ..s phcduId=$p($g(^OEORD(ord,"I",linkItm,2)),"^",6)
    ..s phcduDesc1=$p($G(^PHCDU(+phcduId)),"^",3)  //持续周期 Oeori_Durat_Dr-->PHC_Duration
    ..
    ..s packUomQty=$p($g(^OEORD(ord,"I",linkItm,9)),"^",4)
    ..s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    ..s packUomId=+packUomId,packUomDesc=""
    ..i (packUomId'=0)&(packUomQty'="") d 
    ...s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
    ..s phOrdQty=$p($g(^OEORD(ord,"I",linkItm,1)),"^",12)
    ..i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    ..i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_$g(packUomDesc)
    
    ..s oeoriPrice=$p($g(^OEORD(ord,"I",linkItm,3)),"^",25)
    ..i $d(^OEORD(ord,"I",linkItm,"X",exe)) d
    ...s sttDate=$p(^OEORD(ord,"I",linkItm,"X",exe),"^",1)
    ...s sttTime=$p(^OEORD(ord,"I",linkItm,"X",exe),"^",2)
    ...s expStr="^"_ord_"||"_linkItm_"^"_ord_"||"_linkItm_"||"_exe_"^"_EpisodeID_"^"_reclocId
    ...s price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital,expStr)
    ...s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
    ..e  d
    ...s price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital)
    ..s price=$fn(price,"",2)
    ..s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(ord_"||"_linkItm)
    ..s totalAmount=$fn(orderBaseQty*price,"",2)
    ..
    ..s disposeStatCode="Temp"
    ..s oeoriBilled=$p($g(^OEORD(ord,"I",linkItm,3)),"^",5)
    ..s stayFlag=$p($g(^OEORD(ord,"I",linkItm,"DHC")),"^",17)
    ..s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(ord)
    ..s oecprId=$p($g(^OEORD(ord,"I",linkItm,1)),"^",8)
	..s oecprCode=$p($g(^OECPR(oecprId)),"^")
    ..i ((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMCQZT")&(oecprCode'="OMLSZT")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) s disposeStatCode="UnPaid"   // 修改 wxl 090301
    ..s disposeStatDesc=$s(disposeStatCode="Temp":TraPay,disposeStatCode="UnPaid":TraUnPay,1:"")
	..s admDeptDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",admDeptDesc) //hxy 2022-12-27 st
	..s orcatDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",orcatDesc)
	..s arcimDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.ARCItmMast","ARCIMDesc","",arcimDesc)
	..s ctcpDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",ctcpDesc)
	..s reclocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",reclocDesc)
	..s ordStatDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderStatus","OSTATDesc","",ordStatDesc) //ed
	..s ListData=$g(admDeptDesc)_"^"_$g(orcatDesc)_"^"_$g(arcimDesc)_"^"_$g(phOrdQtyUnit)_"^"_$g(price)_"^"_$g(totalAmount)
	..s ListData=ListData_"^"_$g(ctcpDesc)_"^"_$g(reclocDesc)_"^"_$g(createDateTime)_"^"_$g(sttDateTime)_"^"_$g(ordStatDesc)_"^"_$g(phcduDesc1)
	..s ListData=ListData_"^"_ord_"||"_linkItm_"||"_exe_"^"_$g(disposeStatCode)
	..s sumcount = sumcount+1
	..q:(sumcount<start)||(sumcount>end)
	..w $case(sumcount,start:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData,"^")
	w "],""total"":"_sumcount_"}"
	k mainOrdArr
	q ""
}

/// Descritp:	获取系统日期时间
/// w ##Class(web.DHCEMNurExe).GetSystemTime()
ClassMethod GetSystemTime() As %String
{
	s SystemDate=+$H
	s SystemDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SystemDate)
	s SystemTime=$zt($p($H,",",2),2)
	s ListData=SystemDate_"^"_SystemTime
	w ##class(web.DHCAPPJsonCommon).getJsonData("SystemDate^SystemTime",SystemDate_"^"_SystemTime)
	q ""
}

/// 根据session获取参数配置的值
/// w ##class(web.DHCEMNurExe).GetConfigBySession("INSERTDOC")
ClassMethod GetConfigBySession(Type As %String, LgParams = "") As %String
{
	n (LgParams,Type,%session)
	s LgHospID = $p(LgParams,"^",1)
	s LgCtLocID = $p(LgParams,"^",2)
	s LgGroupID = $p(LgParams,"^",3)
	s LgUserID = $p(LgParams,"^",4)
	i ($d(%session)){
		s:LgHospID="" LgHospID=%session.Get("LOGON.HOSPID")
		s:LgCtLocID="" LgCtLocID=%session.Get("LOGON.CTLOCID")
		s:LgGroupID="" LgGroupID=%session.Get("LOGON.GROUPID")
		s:LgUserID="" LgUserID=%session.Get("LOGON.USERID")
	}
	s ResType=##Class(web.DHCEMComPar).GetAppPropValue("DHCEM",Type,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// w ##class(web.DHCEMNurExe).OrdIsCheckPs("840","3")
ClassMethod OrdIsCheckPs(Ord, Itm)
{
	n (Ord,Itm)
	s Ret=0
	s Ords = ##class(web.DHCEMNurExe).GetAllOrd(Ord,Itm)
	s Len = $l(Ords,"^")
	f i=1:1:Len q:Ret=1  d
	.s OrdItmID = $p(Ords,"^",i)
	.s Skintest=$p($g(^OEORD(+OrdItmID,"I",$p(OrdItmID,"||",2),5)),"^",2)
	.;s Skintest2=""
	.;s:Skintest'="Y" Skintest2=##class(DHCDoc.Interface.Inside.Service).CheckOrdIsSkinInstr(OrdItmID)   //医生站配置
	.;s:Skintest2=1 Skintest="Y"
	.s:Skintest="Y" Ret=1
	q Ret
}

/// w ##class(web.DHCEMNurExe).GetAllOrd("840","3")
ClassMethod GetAllOrd(Ord, Itm)
{
	n (Ord,Itm)
	s Ret=""
	s MainOrd = $p(^OEORD(Ord,"I",Itm,11),"^",39)
	s:MainOrd="" MainOrd=Ord_"||"_Itm
	
	s Ret=MainOrd   //主医嘱ID
	s ChildItm=""
	f  s ChildItm = $o(^OEORDi(0,"OEORI",Ord,MainOrd,ChildItm)) q:ChildItm=""  d
	.s OrdItmID = Ord_"||"_ChildItm
	.s Ret=Ret_"^"_OrdItmID
	q Ret
}

/// 访问类型位置：类型
/// w ##class(web.DHCEMNurExe).GetLocType(249)
ClassMethod GetLocType(LocID)
{
	n (LocID)
	s Ret=""
	s:$d(^PAC("ADMLOC",0,"AdmType","E",LocID)) Ret="E"
	s:$d(^PAC("ADMLOC",0,"AdmType","O",LocID)) Ret="O"
	s:$d(^PAC("ADMLOC",0,"AdmType","I",LocID)) Ret="I"
	q Ret
}

/// w ##Class(web.DHCEMNurExe).GetExecFormID("2","ZSDO")
ClassMethod GetExecFormID(HospID = "", ExecFormCode = "")
{
	n (HospID,ExecFormCode)
	q:(+HospID=0)||(ExecFormCode="") ""
	s Ret=""
	s ID=0
	f  s ID = $o(^DHCEMEFS(0,"Code",ExecFormCode,ID)) q:(ID="")||(Ret'="")  d
	.s ExecFormHosp=$p(^DHCEMEFS(ID),"^",3)
	.q:HospID'=ExecFormHosp
	.s Ret=ID
	q Ret
}

/// w ##Class(web.DHCEMNurExe).GetExecFormItmValue("2")
ClassMethod GetExecFormItmValue(ExecFormID, ExecFormCode)
{
	n (ExecFormID,ExecFormCode)
	q:ExecFormID="" ""
	q:ExecFormCode="" ""
	s ID = $o(^DHCEMEFSI(0,"ExecForm",ExecFormID,ExecFormCode,""))
	q:ID="" ""
	s Ret = $p(^DHCEMEFSI(ID),"^",3)
	q Ret
}

/// Decipts:获取执行单安全组配置
/// w ##class(web.DHCEMNurExe).GetExecFormAutID(2,1,5)
ClassMethod GetExecFormAutID(LgHospID, LgLocID, GroupID)
{
	s Id = "",RowID=""
	f  s RowID=$o(^DHCEMEFSAA(0,"IndexLoc",+LgLocID,RowID)) q:(RowID="")||(Id'="")  d
	.s HospID=$p($g(^DHCEMEFSAA(RowID)),"^",4)
	.;q:(LgHospID'="")&&(LgHospID'=HospID)
	.s Id=RowID
	q:Id'="" Id
	
	s RowID=""
	f  s RowID=$o(^DHCEMEFSAA(0,"IndexGroup",+GroupID,RowID)) q:(RowID="")||(Id'="")  d
	.s HospID=$p($g(^DHCEMEFSAA(RowID)),"^",4)
	.q:(LgHospID'="")&&(LgHospID'=HospID)
	.s Id=RowID
				
	q Id
}

/// w ##class(web.DHCEMNurExe).SetPlacerNo()
ClassMethod SetPlacerNo(userId, oeoreId, placerNo, clearFlag = "N") As %String
{
	q:$g(oeoreId)="" "医嘱不能为空!"
	q:(placerNo="")&&(clearFlag="N") "瓶号不能为空!"
	
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub
	s PFlage=1                                                              
	i clearFlag ="N" d
	.i ($d(^OEORDi(0,"PlacerNo",placerNo))>2)  d
	..s PFlage=##class(web.DHCNurCom).getPlacerFlage(placerNo)              
	s CPFlage=-1
	i (PFlage=0)&(clearFlag'="Y") d
	.s CPFlage=##class(web.DHCNurCom).clearPlacerFlage(placerNo)
	q:(clearFlag'="Y")&(PFlage=0)&(CPFlage<0) "清除停止医嘱的关联条码失败!"  
	s flag=""
	i (clearFlag'="Y") d
	.s flag=$d(^OEORDi(0,"PlacerNo",placerNo)) 
	q:$g(flag)>2 "已有该瓶号!"
	;i (placerNo'=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36))&(clearFlag="Y") q "无此瓶号!"
	s flag=""
	s oriLabEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)  ;OEORI_LabEpisodeNo
	i oriLabEpisodeNo="" q "该医嘱没有检验号!"
	;i clearFlag'="Y",$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",36)'="" q "该医嘱已有条码号!"
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
    i ordStatCode="D" q "医嘱状态为停止,不能置条码!"
    i ordStatCode="E" q "医嘱状态为执行,不能置条码!"
    s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
    s ordExecOrdStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub_"||"_oeoreSub) 
	i (ordExecOrdStatCode="F")!((ordExecOrdStatCode="D")) q "护士已执行,不能置条码!"

	s curOriSub=0,err="",oeoriIdStr=""
	f  s curOriSub=$O(^OEORD(0,"EpisNo",oriLabEpisodeNo,oeordId,curOriSub)) q:curOriSub=""  d
	    .s curLabEpisodeNo=$p($g(^OEORD(oeordId,"I",curOriSub,3)),"^",20)
	    .s oeoriId=oeordId_"||"_curOriSub
	    .k PLIST
	    .&sql(SELECT * INTO PLIST() FROM OE_OrdItem WHERE OEORI_RowId=:oeoriId)
	    .s PLIST(215)=placerNo         ;OEORI_PlacerNo
	    .i clearFlag="Y" s PLIST(215)=""
	    .i 'SQLCODE d
	        ..&sql(UPDATE OE_OrdItem VALUES PLIST() WHERE OEORI_RowId=:oeoriId)
	    .s err=SQLCODE
	    .i err'=0 q
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	i err=0,oeoriIdStr'="" d
	   	.s num=$l(oeoriIdStr,"^")
	   	.f i=1:1:num d
	   	    ..s oeoriId=$p(oeoriIdStr,"^",i)
	   	    ..s oeordId=+oeoriId
	   	    ..s oeoriSub=$p(oeoriId,"||",2)
	   	    ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
           ..s curDate=+$h,curTime=$p($h,",",2)
           ..i clearFlag="Y" s userId="",curDate="",curTime=""
           ..//更新采血时间
           ..d ..UpdatespecCollDatetime(oeordId_"||"_oeoriSub_"||"_oeoreSub,userId) ;,curDate,curTime
        
	q err
}

/// w ##class(web.DHCEMNurExe).getAllergData(1)
ClassMethod getAllergData(ord)
{
	n (ord)
	s ord=+ord
	s admId=+$g(^OEORD(+ord))
	q:+admId=0 ""
	s patientId=+^PAADM(admId)
	q:+patientId=0 ""
	s allgryFlag= ##class(web.DHCEMOrdInfoVO).GetAllgryFlag(ord)
	q patientId_"^"_allgryFlag
}

/// w ##class(web.DHCEMNurExe).GetPrintedData("50622327||4||1^50622327||2||1")
ClassMethod GetPrintedData(OreDatas)
{
	q:OreDatas="" {}
	w "{"
	s Count=0
	s Len = $l(OreDatas,"^")
	f i=1:1:Len d
	.s OrdItemId=$p(OreDatas,"^",i)
	.q:+OrdItemId=0
	.s Ord=+OrdItemId
	.s Itm=$p(OrdItemId,"||",2)
	.s Sub=$p(OrdItemId,"||",3)
	.;s ExecSta=""
	.s Pmark=$p($g(^OEORD(Ord,"I",Itm,"X",Sub,"NUR")),"^",1)
	.s placerNo=$p(^OEORD(Ord,"I",Itm,3),"^",36)
	.;s:Pmark'="" ExecSta="已打印"
	.s ExecSta="已打印"
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w """"_OrdItemId_""":"_##class(web.DHCAPPJsonCommon).getJsonData("ExecSta^prtFlag^placerNo",ExecSta_"^"_Pmark_"^"_placerNo)
	w "}"
	q ""
}

}
