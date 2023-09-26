Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-05-11
/// description:处方点评抽取数据核心类
/// 数据抽取\生成随机数
Class web.DHCSTCNTS.Extract Extends %RegisteredObject
{

/// description: 抽取处方-基础方法
/// 			 查询条件如果为多选则均以逗号分隔","
/// input:		 globalFlag(不为空时存临时global)
/// output:		 0^处方总数^进程号
/// "1/12/2018^18/12/2018^^^10^^^^^P^^^^^^^0^^^^^7","306",1
/// w ##class(web.DHCSTCNTS.Extract).ExtraPresc("1/12/2018^18/12/2018^^^10^^^^^P^^^^^^^0^^^^^7","306","")
ClassMethod ExtraPresc(inputStr, lgLocId, globalFlag = "")
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Extract","ExtraPresc")=$lb(inputStr, lgLocId, globalFlag)
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s StDate=$p(inputStr,"^",1)
	s StDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(StDate)
	s EdDate=$p(inputStr,"^",2)
	s EdDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(EdDate)
	s DocLocStr=$p(inputStr,"^",3) 					// 医生科室
	i DocLocStr'="" s DocLocList=$lfs(DocLocStr,",")
	s IncId=$p(inputStr,"^",4) 						// 库存项Id
	s ArcItmId=$p(inputStr,"^",4) 					// 医嘱项Id,医嘱改造,修改为医嘱项Id
	s RandNum=+$p(inputStr,"^",5)					// 随机数
	s RandNum=$p(RandNum,".",1)
	s AdmType=$p(inputStr,"^",7)					// 就诊类型
	s DoctorId=$p(inputStr,"^",8)					// 医生
	s AntLevelStr=$p(inputStr,"^",9)				// 抗菌药级别(包含)
	i AntLevelStr'="" s AntLevelList=$lfs(AntLevelStr,",")
    s WayCode=$p(inputStr,"^",10)					// 点评方式代码
	s OrdCatStr=$p(inputStr,"^",11) 				// 处方类型 (医嘱大类)
	i OrdCatStr'="" s OrdCatList=$lfs(OrdCatStr)
    s AdmReasonId=$p(inputStr,"^",12)				// 病人费别
    s RecLocId=$p(inputStr,"^",13) 					// 接收科室
    s PoisonStr=$p(inputStr,"^",14) 				// 管制分类 (包含)
    i PoisonStr'="" s PoisonList=$lfs(PoisonStr,",")
    s NewPhcCatId=$p(inputStr,"^",15) 				// 新药学分类
    s SpAmt=$p(inputStr,"^",16) 					// 处方金额
    s BasicFlag=$p(inputStr,"^",17) 				// 基本药物
    s BasicFlag=$s(BasicFlag=1:"Y",1:"")
    s MinAge=$p(inputStr,"^",18)					// 病人年龄大于
    s MaxAge=$p(inputStr,"^",20) 					// 病人年龄小于
    s FormIdStr=$p(inputStr,"^",21)  				// 剂型
    i FormIdStr'="" s FormIdList=$lfs(FormIdStr,",")
    s DuraId=$p(inputStr,"^",22)  					// 疗程 
	s LgHospId=$p($g(^CTLOC(+lgLocId)),"^",22) 		// 登陆科室所在院区
	s needCheckItm="1"
	i (ArcItmId="")&&(BasicFlag="")&&(FormIdStr="")&&(PoisonStr="")&&(AntLevelStr="")&&(SpAmt="")&&(DuraId="")&&(NewPhcCatId="") d
	.s needCheckItm=""
	s wayId=$o(^DHCPCWAY(0,"Code",WayCode,""),-1)
	s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
	s indexAdmType="O,E",indexATI=""					// 查询就诊类型
	i AdmType=1 s indexAdmType="O",AdmType="O"
	e  i AdmType=2 s indexAdmType="E",AdmType="E"
	e  s AdmType=""
	s indexATLen=$l(indexAdmType,",")
	s cnt=0
	s calcuDate=""
	// 明细数据根据直接索引至少筛选到百万条,否则太慢
	d GetDataByCommonIndex	
	q 0_"^"_cnt_"^"_pid
 // 保存数据由此glolbal取数据
SetSaveData
	i globalFlag'="" d
	.s ^TMPDHCSTCNTS("Extract","Common",pid,cnt)=phcoId
	q
 // 没条件的时候走这
GetDataByOrdDate
	f indexATI=1:1:indexATLen d
	.s indexATIType=$p(indexAdmType,",",indexATI)
	.f calcuDate=StDate:1:EdDate d
	..s recLocId=""
	..f  s recLocId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId)) q:recLocId=""  d
	...s phcoId=""
	...f  s phcoId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId,phcoId)) q:phcoId=""  d
	....q:+phcoId=0
	....s chkMain=$$CheckMain()
	....q:chkMain=0
	....s chkItm=$$CheckItm()
	....q:chkItm=0
	....s cnt=cnt+1
	....d SetSaveData
	q
GetDataByCommonIndex
	s mayRepeat=""	// 该索引是否可能抽到重复数据
	s indexName="",indexData=""
	i DoctorId'="" s indexName="Doctor",indexData=DoctorId
	e  i ArcItmId'="" s indexName="Arcim",indexData=ArcItmId,mayRepeat="Y"
	e  i DocLocStr'="" s indexName="DocLoc",indexData=DocLocStr
	e  i AdmReasonId'="" s indexName="AdmReason",indexData=AdmReasonId
	i indexName="" d GetDataByOrdDate q
	s indexLen=$l(indexData,","),indexI=""
	f indexATI=1:1:indexATLen d
	.s indexATIType=$p(indexAdmType,",",indexATI)
	.f indexI=1:1:indexLen d // 涉及条件多选
	..s indexIData=$p(indexData,",",indexI)
	..q:indexIData=""
	..f calcuDate=StDate:1:EdDate d
	...s phcoId=""
	...f  s phcoId=$o(^DHCPHCNTSORDER(0,indexName,LgHospId,indexATIType,calcuDate,indexIData,phcoId)) q:phcoId=""  d
	....q:+phcoId=0
	....q:$d(^TMPDHCSTCNTS("Extract","MayRepeat",pid,phcoId))  // 可能重复
	....i mayRepeat="Y" s ^TMPDHCSTCNTS("Extract","MayRepeat",pid,phcoId)=""
	....s chkMain=$$CheckMain()
	....q:chkMain=0
	....s chkItm=$$CheckItm()
	....q:chkItm=0
	....s cnt=cnt+1
	....d SetSaveData
	q
 // 验证主信息(返回0不符合条件)
 // 除了医嘱费别/医嘱大类/病人年龄下限/疗程大于/处方金额大于/病人年龄上限这六个
CheckMain()
	s phcoData=$g(^DHCPHCNTSORDER(phcoId))
	s firstPhcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",""))
	q:firstPhcoItm="" 0
	s oeori=$p(^DHCPHCNTSORDER(phcoId,"I",firstPhcoItm),"^",7)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId="" 0
	q:$p(^DHCOEDISQTY(dspId),"^",7)'="C" 0 					// 查已发药
	q:(reSaveFlag'="Y")&&($d(^DHCPHCNTS(0,"OrdItem",oeori))) 0	// 不允许重复抽取
	q:(DoctorId'="")&&(DoctorId'=$p(phcoData,"^",2)) 0
	q:(DocLocStr'="")&&($lf(DocLocList,$p(phcoData,"^",3))=0) 0
	q:(AdmType'="")&&(AdmType'=$p(phcoData,"^",4)) 0
	q:(RecLocId'="")&&(RecLocId'=$p(phcoData,"^",5)) 0
	q:(AdmReasonId'="")&&(AdmReasonId'=$p(phcoData,"^",7)) 0
	q:(OrdCatStr'="")&&($lf(OrdCatList,$p(phcoData,"^",11))=0) 0
	q:(MaxAge'="")&&(+$p(phcoData,"^",8)>MaxAge) 0
	q:(MinAge'="")&&(+$p(phcoData,"^",8)<MinAge) 0
	// todo-疗程(是不是放子表)  疗程 已经放到了CheckItm中进行过滤 MaYuqiang 20181218
	q 1
 // 验证明细(返回0不符合条件)
CheckItm()
	q:needCheckItm="" 1
	s phcoItm=0,existItm="",spAmt=0
	f  s phcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",phcoItm)) q:(phcoItm="")||((SpAmt'="")&&(existItm'=""))  d
	.s phcoItmData=$g(^DHCPHCNTSORDER(phcoId,"I",phcoItm))
	.q:..ValidOeori($p(phcoItmData,"^",7))'="Y"
	.s spAmt=spAmt+$p(phcoItmData,"^",10)
	.q:(ArcItmId'="")&&(ArcItmId'=$p(phcoItmData,"^",2))
	.q:(BasicFlag'="")&&(BasicFlag'=$p(phcoItmData,"^",6))
	.q:(FormIdStr'="")&&($lf(FormIdList,$p(phcoItmData,"^",5))=0)
	.q:(PoisonStr'="")&&($lf(PoisonList,$p(phcoItmData,"^",3))=0) 
	.q:(AntLevelStr'="")&&($lf(AntLevelList,$p(phcoItmData,"^",3))=0)
	.q:(DuraId'="")&&(..ChkDuration($p(phcoItmData,"^",7),DuraId)=0)		//过滤疗程 MaYuqiang 20181218
	.s PhaCatAlls=$p(phcoItmData,"^",4)		//药学分类
	.q:(NewPhcCatId'="")&&(##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(NewPhcCatId,PhaCatAlls)=0)
	.s existItm=1
	q:(SpAmt'="")&&(spAmt<+SpAmt) 0
	q:existItm'="" 1
	q 0
}

/// description: 住院医嘱点评抽取
/// output:		 出院人数(按就诊)^进程号
/// 1/11/2018^18/12/2018^^^^^^^^^^^182^^false^IP,306,
/// w ##class(web.DHCSTCNTS.Extract).ExtraDisch("1/11/2018^18/12/2018^^^^^^^^^^^182^^false^IP","306","")
ClassMethod ExtraDisch(inputStr, lgLocId, globalFlag = "")
{
	//s ^tmyq($this,"ExtraDisch")=inputStr_","_lgLocId_","_globalFlag
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s StDate=$p(inputStr,"^",1)
	s StDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(StDate)
	s EdDate=$p(inputStr,"^",2)
	s EdDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(EdDate)
	s DocLocStr=$p(inputStr,"^",4) 					// 医生科室
	i DocLocStr'="" s DocLocList=$lfs(DocLocStr,",")
	s ArcItmId=$p(inputStr,"^",6) 					// 医嘱项Id,医嘱改造,修改为医嘱项Id
	s RandNum=+$p(inputStr,"^",5)					// 随机数
	s DoctorId=$p(inputStr,"^",7)					// 医生
	s PoisonStr=$p(inputStr,"^",8) 					// 管制分类 (包含)
    i PoisonStr'="" s PoisonList=$lfs(PoisonStr,",")	
	s AntLevelStr=$p(inputStr,"^",9)				// 抗菌药级别(包含)
	i AntLevelStr'="" s AntLevelList=$lfs(AntLevelStr,",")
	s MinAge=$p(inputStr,"^",10)	
	s AdmReasonId=$p(inputStr,"^",12)	
 	s NewPhcCatId=$p(inputStr,"^",13) 				// 新药学分类
 	s RecLocId=$p(inputStr,"^",14) 					// 接收科室
 	s BasicFlag=$p(inputStr,"^",15) 				// 基本药物
 	s BasicFlag=$s(BasicFlag="true":"Y",1:"")
 	i $p(inputStr,"^",16)="" s $p(inputStr,"^",16)="IP"
	s WayCode=$p(inputStr,"^",16)	
	s (OrdCatStr,MaxAge,AdmType,FormIdStr)=""
    s wayId=$o(^DHCPCWAY(0,"Code",WayCode,""),-1)	// 获取点评方式代码
    s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
	s cnt=0
	s admIndex="DischDate"
	f calcuDate=StDate:1:EdDate d
	.s admId=""
	.f  s admId=$o(^PAADMi(admIndex,calcuDate,admId)) q:admId=""  d
	..s admType=$p(^PAADM(admId),"^",2)
    ..q:admType'="I"
    ..q:(reSaveFlag'="Y")&&($d(^DHCPHCNTS(0,"Adm",admId)))
    ..s existFlag=""	
    ..s phcoId=""
    ..f  s phcoId=$o(^DHCPHCNTSORDER(0,"Adm",admId,phcoId)) q:(phcoId="")||(existFlag'="")  d
    ...q:+phcoId=0
    ...s chkIpMain=$$CheckIpMain()
    ...q:chkIpMain=0
    ...s chkIpItm=$$CheckIpItm()
    ...q:chkIpItm=0
    ...s existFlag=1
    ..q:existFlag=""
    ..s cnt=cnt+1
    ..i globalFlag'="" s ^TMPDHCSTCNTS("Extract","Common",pid,cnt)=admId
    q 0_"^"_cnt_"^"_pid
CheckIpMain()
	s phcoData=$g(^DHCPHCNTSORDER(phcoId))
	s firstPhcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",""))
	q:firstPhcoItm=0
	s oeori=$p(^DHCPHCNTSORDER(phcoId,"I",firstPhcoItm),"^",7)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId="" 0
	q:$p(^DHCOEDISQTY(dspId),"^",7)'="C" 0 						// 查已发药
	q:(reSaveFlag'="Y")&&($d(^DHCPHCNTS(0,"OrdItem",oeori))) 0	// 不允许重复抽取
	q:(DoctorId'="")&&(DoctorId'=$p(phcoData,"^",2)) 0
	q:(DocLocStr'="")&&($lf(DocLocList,$p(phcoData,"^",3))=0) 0
	q:(AdmType'="")&&(AdmType'=$p(phcoData,"^",4)) 0
	q:(RecLocId'="")&&(RecLocId'=$p(phcoData,"^",5)) 0
	q:(AdmReasonId'="")&&(AdmReasonId'=$p(phcoData,"^",7)) 0
	q:(OrdCatStr'="")&&($lf(OrdCatList,$p(phcoData,"^",11))=0) 0
	q:(MaxAge'="")&&(MaxAge>+$p(phcoData,"^",8))
	q:(MinAge'="")&&(MinAge<+$p(phcoData,"^",8))
	// todo-疗程(是不是放子表)
	q 1
 // 验证明细(返回0不符合条件)
CheckIpItm()
	s phcoItm=0,existItm="",spAmt=0
	f  s phcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",phcoItm)) q:(phcoItm="")||(existItm'="")  d
	.s phcoItmData=$g(^DHCPHCNTSORDER(phcoId,"I",phcoItm))
	.q:..ValidOeori($p(phcoItmData,"^",7))'="Y"
	.q:(ArcItmId'="")&&(ArcItmId'=$p(phcoItmData,"^",2))
	.q:(BasicFlag'="")&&(BasicFlag'=$p(phcoItmData,"^",6))
	.q:(FormIdStr'="")&&($lf(FormIdList,$p(phcoItmData,"^",5))=0)
	.q:(PoisonStr'="")&&($lf(PoisonList,$p(phcoItmData,"^",3))=0) 
	.q:(AntLevelStr'="")&&($lf(AntLevelList,$p(phcoItmData,"^",3))=0)
	.s PhaCatAlls=$p(phcoItmData,"^",4)		//药学分类
	.q:(NewPhcCatId'="")&&(##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(NewPhcCatId,PhaCatAlls)=0)
	.s existItm=1
	q:existItm'="" 1
	q 0
}

/// description: 抽取抗菌药处方-基础方法
/// 			 查询条件如果为多选则均以逗号分隔","
/// input:		 globalFlag(不为空时存临时global)
/// output:		 0^处方总数^进程号
/// w ##class(web.DHCSTCNTS.Extract).ExtraAntiPresc("18/10/2016^18/10/2018^1^1^^K","238","")
ClassMethod ExtraAntiPresc(inputStr, lgLocId, globalFlag = "")
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Extract","ExtraAntiPresc")=$lb(inputStr, lgLocId, globalFlag)
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s StDate=$p(inputStr,"^",1)
	s StDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(StDate)
	s EdDate=$p(inputStr,"^",2)
	s EdDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(EdDate)
	s DocCent=$p(inputStr,"^",3) 		// 医生比例				
	s PrescNum=$p(inputStr,"^",4) 		// 处方张数
	s AntLevelStr=$p(inputStr,"^",5)				// 抗菌药级别(包含)
	i AntLevelStr'="" s AntLevelList=$lfs(AntLevelStr,",")
    s WayCode=$p(inputStr,"^",6)					// 点评方式代码
	s LgHospId=$p($g(^CTLOC(+lgLocId)),"^",22) 		// 登陆科室所在院区
	s needCheckItm="1"
	s wayId=$o(^DHCPCWAY(0,"Code",WayCode,""),-1)
	s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
	s indexAdmType="O,E",indexATI=""					// 查询就诊类型
	s indexATLen=$l(indexAdmType,",")
	s doctorCnt=0,prescCnt=0
	s cnt=0
	s calcuDate=""	
	// 按医生汇总处方
	d GetDataByOrdDate
	// 取出处方数大于 处方张数(每位医生) 的数据 PrescCent
	s prescTotal=0,docTotal=0
	s doctorId=""
	f  s doctorId=$o(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid,doctorId)) q:doctorId=""  d
	.s docMaxNum=$o(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid,doctorId,""),-1)
	.q:docMaxNum<PrescNum
	.s prescTotal=prescTotal+PrescNum
	.s docTotal=docTotal+1
	.// 此global,用于随机抽取
	.s ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","NumDoctor",pid,docTotal,doctorId)=""
    q:docTotal=0 "-1^无满足条件的数据"
	s newDoctorCnt=$p(doctorCnt*(DocCent/100),".") // 医生比例*开了抗菌药的医生总数
	i newDoctorCnt<1 s newDoctorCnt=1
	q:docTotal<newDoctorCnt "-1^满足抽取处方张数的医生数小于抽取的百分比"  
 	s cnt=newDoctorCnt*PrescNum
 	// 查询统计在此退出,抽取还要继续
 	i globalFlag="" d KillQueryTmp q 0_"^"_cnt_"^"_pid 
 	s cnt=0
 	k GeneRandomData,GeneRandomDataItm  
    s randCnt=0
    // 大于40个处方的医生,随机抽取60%,再在每个医生随机抽40个处方
    s stTime=$p($h,",",2)
    f  q:(randCnt=newDoctorCnt)||($p($h,",",2)-stTime>1800)  d  // 30分钟还出不来就q了,但也保存下来
    .s rand=$r(newDoctorCnt)+1
    .q:$d(GeneRandomData(rand))
    .s GeneRandomData(rand)=""	
    .s doctorId=$o(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","NumDoctor",pid,rand,""))
    .q:doctorId=""
    .s randCnt=randCnt+1
    .k GeneRandomDataItm
    .s randPrescCnt=0
    .f  q:(randPrescCnt=PrescNum)||($p($h,",",2)-stTime>1800)  d
    ..s randItm=$r(PrescNum)+1
    ..q:$d(GeneRandomDataItm(randItm))
    ..s GeneRandomDataItm(randItm)=""
	..s phcoId=$g(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid,doctorId,randItm))
	..q:phcoId=""
    ..s randPrescCnt=randPrescCnt+1	
    ..s cnt=cnt+1
    ..d SetSaveData
	q 0_"^"_cnt_"^"_pid
KillQueryTmp
	i $d(pid) d
	.k ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Doctor",pid)
	.k ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Presc",pid)
	.k ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","NumDoctor",pid)
	.k ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid)
	q 
 // 保存数据由此glolbal取数据
SetSaveData
	s ^TMPDHCSTCNTS("Extract","Common",pid,cnt)=phcoId
	q
 // 没条件的时候走这
GetDataByOrdDate
	f indexATI=1:1:indexATLen d
	.s indexATIType=$p(indexAdmType,",",indexATI)
	.f calcuDate=StDate:1:EdDate d
	..s recLocId=""
	..f  s recLocId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId)) q:recLocId=""  d
	...s phcoId=""
	...f  s phcoId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId,phcoId)) q:phcoId=""  d
	....q:+phcoId=0
	....s phcoData=$g(^DHCPHCNTSORDER(phcoId))
	....s firstPhcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",""))
	....q:firstPhcoItm="" 
	....s oeori=$p(^DHCPHCNTSORDER(phcoId,"I",firstPhcoItm),"^",7)
	....s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	....q:dspId="" 
	....q:$p(^DHCOEDISQTY(dspId),"^",7)'="C"  						// 查已发药
	....q:(reSaveFlag'="Y")&&($d(^DHCPHCNTS(0,"OrdItem",oeori))) 	// 不允许重复抽取
	....s chkItm=$$CheckItm()
	....q:chkItm=0
	....d SetDoctorData
	q
 // 验证明细(返回0不符合条件)
CheckItm()
	s phcoItm=0,existItm=""
	f  s phcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",phcoItm)) q:(phcoItm="")||(existItm'="")  d
	.s phcoItmData=$g(^DHCPHCNTSORDER(phcoId,"I",phcoItm))
	.q:..ValidOeori($p(phcoItmData,"^",7))'="Y"
	.q:..GetAntiFlagByArc($p(phcoItmData,"^",2))'="Y"
	.q:(AntLevelStr'="")&&($lf(AntLevelList,$p(phcoItmData,"^",3))=0)
	.s existItm=1
	q:existItm'="" 1
	q 0
 // 医生处方排序汇总
SetDoctorData
	s doctorId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",1)
	q:doctorId=""
	s prescNo=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",14)
	q:prescNo=""
	// 医生处方总数
	i '$d(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Presc",pid,prescNo)) d
	.s docMaxNum=+$o(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid,doctorId,""),-1)+1
	.s ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","DocPrescNum",pid,doctorId,docMaxNum)=phcoId
	.s ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Presc",pid,prescNo)=""
	// 医生总数
	i '$d(^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Doctor",pid,doctorId)) d
	.s ^TMP("DHCST","web.DHCSTCNTS.Extract","ExtraAntiPresc","Doctor",pid,doctorId)=""
	.s doctorCnt=doctorCnt+1
	s prescCnt=prescCnt+1
	q
}

/// description: 成人专项点评-基础方法
/// 			 查询条件如果为多选则均以逗号分隔","
/// input:		 globalFlag(不为空时存临时global)
/// output:		 0^处方总数^进程号
/// w ##class(web.DHCSTCNTS.Extract).ExtraAdultPresc("1/01/2017^1/01/2017^^^^^^^^P^^1^^^^^0^^^^^","66","")
ClassMethod ExtraAdultPresc(inputStr, lgLocId, globalFlag = "")
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.Extract","ExtraAdultPresc")=$lb(inputStr, lgLocId, globalFlag)
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s StDate=$p(inputStr,"^",1)
	s StDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(StDate)
	s EdDate=$p(inputStr,"^",2)
	s EdDate=##class(web.DHCSTCNTS.Basic).DateHtmlToLogical(EdDate)
	s RandNum=+$p(inputStr,"^",3)					// 随机数
	s RandNum=$p(RandNum,".",1)
	s DocLocStr=$p(inputStr,"^",4) 					// 医生科室
	i DocLocStr'="" s DocLocList=$lfs(DocLocStr,",")
	s AntLevelStr=$p(inputStr,"^",5)				// 抗菌药级别(包含)
	i AntLevelStr'="" s AntLevelList=$lfs(AntLevelStr,",")
	s AdmType=$p(inputStr,"^",6)
	s WayCode=$p(inputStr,"^",7)					// 点评方式代码	
    s MinAge=$p(inputStr,"^",8)						// 病人年龄大于
    s MinAge=+$p(MinAge,">",2)
	s LgHospId=$p($g(^CTLOC(+lgLocId)),"^",22) 		// 登陆科室所在院区
	s needCheckItm="1"
	i (AntLevelStr="") d
	.s needCheckItm=""
	s wayId=$o(^DHCPCWAY(0,"Code",WayCode,""),-1)
	s reSaveFlag=""
    i wayId'="" s reSaveFlag=$p(^DHCPCWAY(wayId),"^",5)	// 重复抽取标记
	s indexAdmType="O,E",indexATI=""					// 查询就诊类型
	i AdmType=1 s indexAdmType="O",AdmType="O"
	e  i AdmType=2 s indexAdmType="E",AdmType="E"
	e  s AdmType=""
	s indexATLen=$l(indexAdmType,",")
	s cnt=0
	s calcuDate=""
	// 明细数据根据直接索引至少筛选到百万条,否则太慢
	d GetDataByCommonIndex	
	q 0_"^"_cnt_"^"_pid
 // 保存数据由此glolbal取数据
SetSaveData
	i globalFlag'="" d
	.s ^TMPDHCSTCNTS("Extract","Common",pid,cnt)=phcoId
	q
 // 没条件的时候走这
GetDataByOrdDate
	f indexATI=1:1:indexATLen d
	.s indexATIType=$p(indexAdmType,",",indexATI)
	.f calcuDate=StDate:1:EdDate d
	..s recLocId=""
	..f  s recLocId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId)) q:recLocId=""  d
	...s phcoId=""
	...f  s phcoId=$o(^DHCPHCNTSORDER(0,"RecDep",LgHospId,indexATIType,calcuDate,recLocId,phcoId)) q:phcoId=""  d
	....q:+phcoId=0
	....s chkMain=$$CheckMain()
	....q:chkMain=0
	....s chkItm=$$CheckItm()
	....q:chkItm=0
	....s cnt=cnt+1
	....d SetSaveData
	q
GetDataByCommonIndex
	s mayRepeat=""	// 该索引是否可能抽到重复数据
	s (DoctorId,ArcItmId,AdmReasonId)=""
	s indexName="",indexData=""
	i DoctorId'="" s indexName="Doctor",indexData=DoctorId
	e  i ArcItmId'="" s indexName="Arcim",indexData=ArcItmId,mayRepeat="Y"
	e  i DocLocStr'="" s indexName="DocLoc",indexData=DocLocStr
	e  i AdmReasonId'="" s indexName="AdmReason",indexData=AdmReasonId
	i indexName="" d GetDataByOrdDate q
	s indexLen=$l(indexData,","),indexI=""
	f indexATI=1:1:indexATLen d
	.s indexATIType=$p(indexAdmType,",",indexATI)
	.f indexI=1:1:indexLen d // 涉及条件多选
	..s indexIData=$p(indexData,",",indexI)
	..q:indexIData=""
	..f calcuDate=StDate:1:EdDate d
	...s phcoId=""
	...f  s phcoId=$o(^DHCPHCNTSORDER(0,indexName,LgHospId,indexATIType,calcuDate,indexIData,phcoId)) q:phcoId=""  d
	....q:+phcoId=0
	....q:$d(^TMPDHCSTCNTS("Extract","MayRepeat",pid,phcoId))  // 可能重复
	....i mayRepeat="Y" s ^TMPDHCSTCNTS("Extract","MayRepeat",pid,phcoId)=""
	....s chkMain=$$CheckMain()
	....q:chkMain=0
	....s chkItm=$$CheckItm()
	....q:chkItm=0
	....s cnt=cnt+1
	....d SetSaveData
	q
 // 验证主信息(返回0不符合条件)
 // 除了医嘱费别/药学分类/病人年龄下限/疗程大于/处方金额大于/病人年龄上限这六个
CheckMain()
	s phcoData=$g(^DHCPHCNTSORDER(phcoId))
	s firstPhcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",""))
	q:firstPhcoItm="" 0
	s oeori=$p(^DHCPHCNTSORDER(phcoId,"I",firstPhcoItm),"^",7)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId="" 0
	q:$p(^DHCOEDISQTY(dspId),"^",7)'="C" 0 					// 查已发药
	q:(reSaveFlag'="Y")&&($d(^DHCPHCNTS(0,"OrdItem",oeori))) 0	// 不允许重复抽取
	q:(DocLocStr'="")&&($lf(DocLocList,$p(phcoData,"^",3))=0) 0
	q:(AdmType'="")&&(AdmType'=$p(phcoData,"^",4)) 0
	q:(MinAge'="0")&&(+$p(phcoData,"^",8)<MinAge) 0
	// todo-疗程(是不是放子表)
	q 1
 // 验证明细(返回0不符合条件)
CheckItm()
	q:needCheckItm="" 1
	s phcoItm=0,existItm=""
	f  s phcoItm=$o(^DHCPHCNTSORDER(phcoId,"I",phcoItm)) q:(phcoItm="")||(existItm'="")  d
	.s phcoItmData=$g(^DHCPHCNTSORDER(phcoId,"I",phcoItm))
	.q:..ValidOeori($p(phcoItmData,"^",7))'="Y"
	.q:(AntLevelStr'="")&&($lf(AntLevelList,$p(phcoItmData,"^",3))=0)
	.s existItm=1
	q:existItm'="" 1
	q 0
}

/// description: 判断医嘱是否有效
/// return:		 Y(有效)
ClassMethod ValidOeori(oeori)
{
	s oeStateId=$P($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)
	q:oeStateId="" "N"
	s oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
	q:(oeStateCode'="V")&&(oeStateCode'="E") "N"
	q "Y"
}

/// Author : MaYuqiang
/// Date Created : 20181218
/// Description : 根据医嘱id检查疗程是否符合条件(判断疗程的fac字段)
/// Input : oeori - 医嘱id , duraid - 疗程id
/// output : 0 - 不符合条件 , 1 - 符合条件
/// 
ClassMethod ChkDuration(oeori, duraid) As %String
{
	q:(+oeori="0")||(+duraid="0") "0"
	s orderdur=+$p(^OEORD(+oeori,"I",$p(oeori,"||",2),2),"^",6)  //用药疗程ID
	s orderdurfac=$p(^PHCDU(orderdur),"^",2)
	s idurfac=$p(^PHCDU(duraid),"^",2)
	q:(orderdurfac<idurfac) "0"  	//医嘱疗程小于入参疗程
	q "1"
}

/// description: 生成随机数据
/// input:		 extraPid(进程号),extraCnt(抽取总数),randNum(随机数),centNum(抽取比例), spaceNum(间隔数)
ClassMethod GeneRandom(extraPid, extraCnt, randNum, centNum, spaceNum)
{
	i +centNum'=0 s randNum=(extraCnt*centNum)/100 // 抽取比例不为空,则随机数按抽取比例计算
    s randNum=$p(randNum,".")
    i randNum>(extraCnt*0.8) q -1_"^抽取比例不能大于80%"	// 抽取比例大于80%
    i +spaceNum=0 d    
    .// 按随机数
    .s randCnt=0
    .f  q:randCnt=randNum  d
    ..s rand=$r(extraCnt)+1
    ..q:$d(GeneRandomData(rand))
    ..s GeneRandomData(rand)=""
    ..s randCnt=randCnt+1
    e  d 				
    .// 按间隔数,按区间抽取随机数,均匀分布 extraCnt=10  spaceNum=2
    .s spaceCnt=extraCnt\spaceNum	// 按此间隔得到的总数-整
    .s remainder=extraCnt#spaceNum	// 余数
    .i spaceCnt>=randNum d			// 该总数需大于80%随机数
    ..s spaceI=""
    ..f spaceI=0:1:spaceCnt d
    ...q:(spaceI=spaceCnt)&&(remainder=0)
    ...s spaceSt=spaceI*spaceNum+1		
    ...s range=spaceNum				// 随机数区间,最后可能不同,余数部分
    ...i spaceI=spaceCnt s range=remainder
    ...s rand=$r(range)				
	...s rand=spaceSt+rand			
    ...s GeneRandomData(rand)=""
    // 获取计算后的随机数据
    s rand="",cnt=0
    f  s rand=$o(GeneRandomData(rand)) q:rand=""  d
    .s phcoId=$g(^TMPDHCSTCNTS("Extract","Common",extraPid,rand))
    .s cnt=cnt+1
    .s ^TMPDHCSTCNTS("Extract","GeneRandom",extraPid,cnt)=phcoId
    k ^TMPDHCSTCNTS("Extract","Common",extraPid)
	q 0
}

/// description: 获取抗菌药标志
/// return: 	 Y:是
ClassMethod GetAntiFlagByArc(arcItmId)
{
 	s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
 	q:+phcdfId=0 "N"
    s antiFlag=$p($G(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC")),"^",8)	
    q antiFlag
}

}
