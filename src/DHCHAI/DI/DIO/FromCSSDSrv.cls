/// 名称: DHCHAI.DI.DIO.FromCSSDSrv
/// 描述: 消毒供应室数据接口
/// 编写者：chenjb
/// 编写日期: 2019-04-17
Class DHCHAI.DI.DIO.FromCSSDSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zhaona(赵娜)
/// CreatDate:2019-04-09
/// Description:通过病人就诊号获取消毒包信息
/// Table:
/// Input:label
/// Output:
/// Return:
/// Others：
/// w ##class(DHCHAI.DI.DIO.FromCSSDSrv).GetPkgInfoByPation("35","")
ClassMethod GetPkgInfoByPation(aEpisodeID As %Integer, Output retValue As %String) As %String [ SqlProc ]
{
    n (aEpisodeID,retValue)
    s aEpisodeInfo=##Class(User.PAAdm).%OpenId(aEpisodeID)
    q:'$isObject(aEpisodeInfo) retValue
    s AdmType=aEpisodeInfo.PAADMType        //就诊类型(I-住院，O-门诊，E-急诊)

    s BarCodes=..GetPationIDByLabel(aEpisodeID)   //消毒包条码   
    ;s BarCodes="001016001000001,001001001000099"
    quit:BarCodes="" retValue
    s codeLen=$l(BarCodes,",")
    s ret=""
    f k=1:1:codeLen q:ret'=""  d
    .s BarCode=$p(BarCodes,",",k)
    .s PackageInfo=..GetTransDetailInfo(BarCode)  //list
    .q:(PackageInfo="")
    .;1^zhangfei^miaoshu^^^^^^
    .;s aEpisodeID
    .//s PatientID=$p(PackageInfo,"^",1)           //病人ID
    .s PatientID=aEpisodeInfo.PAADMPAPMIDR.%Id()   //病人ID
    .s PatName=$li(PackageInfo,34)             //病人姓名)
    .q:PatName="" 
    .s Desc=$li(PackageInfo,4)                //消毒包名称
    .s Note=""                //说明
    
    .s useDept =$li(PackageInfo,41)
    .q:useDept=""
    .s LocID=$p(useDept,"@",1)               //绑定科室ID  41 使用科室
    .s LocCode=$p(useDept,"@",2)             //绑定科室Code
    .s LocDesc=$p(useDept,"@",3)             //绑定科室Desc
    .s LocInfo=LocID_"|"_LocCode_"|"_LocDesc
    
    .s BatchNumberC=$li(PackageInfo,30)        //清洗批次
    .s CleanDateTime=$li(PackageInfo,28)       //清洗时间
    
    .s cleanUserInfo = $li(PackageInfo,26) 
    .s CleanID=$p(cleanUserInfo,"@",1)
    .s CleanCode=$p(cleanUserInfo,"@",2)
    .s CleanDesc=$p(cleanUserInfo,"@",3)
    .s CleanUser=CleanID_"|"_CleanCode_"|"_CleanDesc         //清洗人（ID|Code|Desc）
    
    .s DispDateTime=$li(PackageInfo,9)        //配包时间 
    .s DispUserInfo = $li(PackageInfo,8)
    .s DispID=$p(DispUserInfo,"@",1)
    .s DispCode=$p(DispUserInfo,"@",2)
    .s DispDesc=$p(DispUserInfo,"@",3)
    .s DispUser=DispID_"|"_DispCode_"|"_DispDesc             //配包人 
                   
    .s BatchNumberS=$li(PackageInfo,16)        //灭菌批次 
    .s BatchG=$li(PackageInfo,15)              //灭菌锅号              
    .s SterilDateTime=$li(PackageInfo,13)      //灭菌时间（2019-04-01 14:55::10）
    
    .s SterilUserInfo = $li(PackageInfo,12)
    .s SterilID=$p(SterilUserInfo,"@",1) 
    .s SterilCode=$p(SterilUserInfo,"@",2)
    .s SterilDesc=$p(SterilUserInfo,"@",3)
    .s SterilUser=SterilID_"|"_SterilCode_"|"_SterilDesc   //灭菌人（ID|Code|Desc）
    .//b //w SterilUserInfo
    .s SterilYsUserInfo = $li(PackageInfo,17)
    .s SterilYsID=$p(SterilYsUserInfo,"@",1)
    .s SterilYsCode=$p(SterilYsUserInfo,"@",2)
    .s SterilYsDesc=$p(SterilYsUserInfo,"@",3)
    .s SterilYsUser=SterilYsID_"|"_SterilYsCode_"|"_SterilYsDesc            //灭菌验收人
    
    .s SterilYxqDateTime=$li(PackageInfo,14)       //灭菌有效期至（2019-04-01 14:55::10）
    .s SendDateTime=$li(PackageInfo,20)            //发放时间（2019-04-01 14:55::10）
    .;s SendUserInfo = $li(PackageInfo,19) 
    .;s SendID=$p(SendUserInfo,"@",1)
    .;s SendCode=$p(SendUserInfo,"@",2)
    .;s SendDesc=$p(SendUserInfo,"@",3)
    .;s SendUser=SendID_"|"_SendCode_"|"_SendDesc                //发放人（ID|Code|Desc）
    .s SendUser=$li(PackageInfo,19) 
    .s ReceptDateTime=$li(PackageInfo,38)          //手术时间（2019-04-01 14:55::10）
    
    .//s ReceptID=$p(PackageInfo,"^",31)
    .//s ReceptCode=$p(PackageInfo,"^",32)
    .//s ReceptDesc=$p(PackageInfo,"^",33)
    .//s ReceptUser=ReceptID_"|"_ReceptCode_"|"_ReceptDesc              //手术医生（ID|Code|Desc）
    .s ReceptUser= $li(PackageInfo,35)
    .;s ReceptHsID=$p(PackageInfo,"^",34)
    .;s ReceptHsCode=$p(PackageInfo,"^",35)
    .;s ReceptHsDesc=$p(PackageInfo,"^",36)
    .;s ReceptHsUser=ReceptHsID_"|"_ReceptHsCode_"|"_ReceptHsDesc            //器械护士（ID|Code|Desc）
    .s ReceptHsUser= $li(PackageInfo,36)           //器械护士 名称
    .s OperLoc=$li(PackageInfo,39)             //手术室
    .s OperBed=$li(PackageInfo,40)             //手术房间号
    .s InfDiagnos=$li(PackageInfo,42)          //感染名称
    .s BackDateTime=$li(PackageInfo,24)        //回收时间（2019-04-01 14:55::10）
    .;s BackID=$p(PackageInfo,"^",41)
    .;s BackCode=$p(PackageInfo,"^",42)
    .;s BackDesc=$p(PackageInfo,"^",43)
    .;s BackUser=BackID_"|"_BackCode_"|"_BackDesc            //回收人（ID|Code|Desc） 
    .s BackUser=$li(PackageInfo,23)
    .i retValue="" d    
    ..s retValue=aEpisodeID_"^"_PatientID_"^"_PatName_"^"_AdmType_"^"_BarCode_"^"_Desc_"^"_Note_"^"_LocInfo_"^"_BatchNumberC_"^"_CleanDateTime_"^"_CleanUser_"^"_DispDateTime_"^"_DispUser_"^"_BatchNumberS_"^"_BatchG_"^"_SterilDateTime_"^"_SterilUser_"^"_SterilYsUser_"^"_SterilYxqDateTime_"^"_SendDateTime_"^"_SendUser_"^"_ReceptDateTime_"^"_ReceptUser_"^"_ReceptHsUser_"^"_OperLoc_"^"_OperBed_"^"_InfDiagnos_"^"_BackDateTime_"^"_BackUser
    .e  d
    ..s retValue=retValue_"#"_aEpisodeID_"^"_PatientID_"^"_PatName_"^"_AdmType_"^"_BarCode_"^"_Desc_"^"_Note_"^"_LocInfo_"^"_BatchNumberC_"^"_CleanDateTime_"^"_CleanUser_"^"_DispDateTime_"^"_DispUser_"^"_BatchNumberS_"^"_BatchG_"^"_SterilDateTime_"^"_SterilUser_"^"_SterilYsUser_"^"_SterilYxqDateTime_"^"_SendDateTime_"^"_SendUser_"^"_ReceptDateTime_"^"_ReceptUser_"^"_ReceptHsUser_"^"_OperLoc_"^"_OperBed_"^"_InfDiagnos_"^"_BackDateTime_"^"_BackUser
    q retValue
}

/// zn 2019-04-09
/// 通过病人就诊号获取消毒包label
/// w ##class(DHCHAI.DI.DIO.FromCSSDSrv).GetPationIDByLabel("118")
ClassMethod GetPationIDByLabel(aEpisodeID)
{
    n (qty,retValue,aEpisodeID)
    s label=""
    s qty=""
    s id=0
    s labels=""
    &sql(SELECT count(*) into:qty FROM SQLUser.CSSD_Trans_OP WHERE CSSDTOP_PationtDR=:aEpisodeID)
    i qty'=0 d
    .f i=1:1:qty  d
    ..s id=$o(^User.CSSDTransOPI("CSSDTOPPationtDRIndex",aEpisodeID,id)) 
    ..s labelinfo=##class(User.CSSDTransOP).%OpenId(id)
    ..s label=labelinfo.CSSDTOPLabel
        
    ..i label'="" d
    ...i labels=""  d
    ....s labels= label
    ...e   d
    ....s labels= labels_","_label
    ..e  d
    ...s labels=label
    q labels
}

/// 获得消毒包追踪的详细信息
/// 配包，打包，灭菌，发放，(使用),回收，清洗 的详情
///        消毒包条码号：
///        消毒包名称：
///        消毒包状态：
///        是否召回：
/// 清洗   --清洗批次
///        --清洗锅号
///        清洗人
///        清洗时间
/// 配包	配包人：
///         审核人
///         配包时间：
/// 灭菌	灭菌人
///        灭菌时间
///        有效期至：
///        灭菌锅号
///        灭菌批次
///        灭菌合格确认人---
/// 发放   发送人
///        发送时间
///        接收人
///        接收科室
/// 使用   使用病人ID号
///        病人姓名：
///        手术医生
///        护士    --
///        手术时间--
/// 回收   回收人
///        回收时间
/// w ##Class(web.CSSDHUI.Stat.TransStat).GetTransDetailInfo("104002001000001")
/// zw ##Class(DHCHAI.DI.DIO.FromCSSDSrv).GetTransDetailInfo("00072022010700001")
ClassMethod GetTransDetailInfo(label As %String) As %String
{
	n (label)
	s retval=""
	s i=0
	Quit:label="" retval
	s (transRowid,deptName,packageLoc,packageName,status,recallflag)=""
	s transRowid=$o(^User.CSSDTransI("CSSDTLabel",label,transRowid),-1)
	q:transRowid="" retval
	s transObj=##class(User.CSSDTrans).%OpenId(transRowid)
	q:'$IsObject(transObj) retval
	s status=transObj.CSSDTStatus
	s packagedr=transObj.CSSDTPackage.%Id()
	i $L(label)="15" s packageName=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(label)
	e  s packageName=$lg(^User.CSSDPackageD(packagedr),5)
	s deptName=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictBindLocName(label)
	;配包打包
	s (packUserName,packDateTime,ackUserName,packInfo,packDr)=""
	s packObj=transObj.CSSDTPack
	i $IsObject(packObj) s packDr=packObj.%Id()
	s:packDr'="" packInfo=$g(^User.CSSDPackagePackD(packDr))
	i packInfo'=""  d
	.s packLocDr=$lg(packInfo,4)
	.s packLocDesc=$p(^CTLOC(packLocDr),"^",2)
	.s packUser=$lg(packInfo,9)
	.s:packUser'="" packUserName=packUser_"@"_$p(^SSU("SSUSR",packUser),"^",1)_"@"_$p(^SSU("SSUSR",packUser),"^",2)
	.s ackUser=$lg(packInfo,11)
	.s:ackUser'="" ackUserName=$p(^SSU("SSUSR",ackUser),"^",2)
	.s packDate=$lg(packInfo,2)
	.s:+packDate'=0 packDate=..DL2H(packDate)
	.s packTime=$lg(packInfo,8)
	.s packDateTime=""
	.i ((packTime'="")||(packTime'=0)) d
	..s packTime=..TL2H(packTime)
	..s packDateTime=packDate_" "_packTime
	.e  d
	..s packDateTime=packDate
	.s ackDate=$lg(packInfo,12)
	.s:+ackDate'=0 ackDate=..DL2H(ackDate)
	
	;灭菌
	s (sterilizeDetailDr,sterilizeDetailInfo,sterilizeUserName,steDateTime,expDate,machineNo,batchNo,steChkerName,steChkDateTime,recallTime,recallUserName,recallReason)=""
	s SterilizeObj=transObj.CSSDTSterilize
	i $IsObject(SterilizeObj) s sterilizeDetailDr=SterilizeObj.%Id()
	s:sterilizeDetailDr'="" sterilizeDetailInfo=$g(^User.CSSDPackageSterilizeD(sterilizeDetailDr))
	i sterilizeDetailInfo'="" d
	.;召回标志
	.s recallflag=$lg(sterilizeDetailInfo,14)
	.i recallflag="Y" d
	..s recallTime=$lg(sterilizeDetailInfo,17)
	..s recallUser=$lg(sterilizeDetailInfo,16)
	..s recallReason=$lg(sterilizeDetailInfo,15)
	..s recallUserName=$p(^SSU("SSUSR",recallUser),"^",2)
	..s recallReason=$List(^User.CSSDRecallReasonD(recallReason),3)
	.s sterilizeMainDr=$lg(sterilizeDetailInfo,13)
	.s sterilizeMainInfo=$g(^User.CSSDSterilizeRecordD(sterilizeMainDr))
	.q:sterilizeMainInfo=""
	.;灭菌批号
	.s batchNo=$lg(sterilizeMainInfo,4)
	.;灭菌器号
	.s machineNo=$lg(sterilizeMainInfo,18)
	.;失效日期
	.;s expDate=##Class(web.CSSDTransManager).GetExpDate(label)
	.s SteLoc=$lg(sterilizeMainInfo,17)
	.s expDate=transObj.CSSDTExpDate
	.s expDate=..DL2H(expDate)
	.s sterilizeUser=$lg(sterilizeMainInfo,9)
	.s:sterilizeUser'="" sterilizeUserName=sterilizeUser_"@"_$p(^SSU("SSUSR",sterilizeUser),"^",1)_"@"_$p(^SSU("SSUSR",sterilizeUser),"^",2)
	.s sterilizeDate=$lg(sterilizeMainInfo,2)
	.s sterilizeDate=..DL2H(sterilizeDate)
	.s sterilizeTime=$lg(sterilizeMainInfo,8)
	.s sterilizeTime=..TL2H(sterilizeTime)
	.s steDateTime=sterilizeDate_" "_sterilizeTime
	.s steChker=$lg(sterilizeMainInfo,25)
	.s:steChker'="" steChkerName=steChker_"@"_$p(^SSU("SSUSR",steChker),"^",1)_"@"_$p(^SSU("SSUSR",steChker),"^",2)
	.s sterilizeChkDate=$lg(sterilizeMainInfo,46)
	.s sterilizeChkDate=..DL2H(sterilizeChkDate)
	.s steChkTime=$lg(sterilizeMainInfo,26)
	.s:steChkTime'="" steChkTime=..TL2H(steChkTime)
	.s steChkDateTime=sterilizeChkDate_" "_steChkTime
	
	;发放
	s (dispUserName,dispDate,toUserName,toLocDesc,dispInfo,dispDr)=""
	s DispObj=transObj.CSSDTDisp
	i $IsObject(DispObj) s dispDr=DispObj.%Id()
	s:dispDr'="" dispInfo=$g(^User.CSSDPackageDispD(dispDr))
	i dispInfo'="" d
	.s dispMainId = $lg(dispInfo,26)
	.s dispMainInfo="" 
	.s:dispMainId'="" dispMainInfo=$g(^User.CSSDPackageDispMainD(dispMainId))
	.i dispMainInfo'="" d
	..s dispLoc=$lg(dispMainInfo,2)
	..s:dispLoc'="" dispLocDesc=$p(^CTLOC(dispLoc),"^",2)
	..s dispUser=$lg(dispMainInfo,3)
	..s:dispUser'="" dispUserName=$p(^SSU("SSUSR",dispUser),"^",2)
	..s toLoc=$lg(dispMainInfo,7)
	..s:toLoc'="" toLocDesc=$p(^CTLOC(toLoc),"^",2)
	..s toUser=$lg(dispMainInfo,8)
	..s:toUser'="" toUserName=$p($g(^SSU("SSUSR",toUser)),"^",2)
	..s dispDate=$lg(dispMainInfo,6)
	..s dispDateD=$p(dispDate," ",1)
	..s dispDateTime=$p(dispDate," ",2)
	..s dispDateDF=..DH2L(dispDateD)
	..s dispDateF=..DL2H(dispDateDF)
	..s dispDate=dispDateF_" "_dispDateTime
	..s rcvDate=$lg(dispMainInfo,10)
	
	;回收
	s (callbackUserName,callBackInfo,callbackDateTime,fromUserName,callBackDr)=""
	s CallBackObj=transObj.CSSDTCallBack
	i $IsObject(CallBackObj) s callBackDr=CallBackObj.%Id()
	s:callBackDr'="" callBackInfo=$g(^User.CSSDPackageCallbackD(callBackDr))
	i callBackInfo'="" d
	.s callbackLoc=$lg(callBackInfo,10)
	.i callbackLoc'="" d
	..i $G(^CTLOC(callbackLoc))
	...s callbackLocDesc=$p(^CTLOC(callbackLoc),"^",2)
	.s callbackUser=$lg(callBackInfo,11)
	.s:callbackUser'="" callbackUserName=$p(^SSU("SSUSR",callbackUser),"^",2)
	.s fromLoc= $lg(callBackInfo,3)
	.s:fromLoc'="" fromLocDesc=$p(^CTLOC(fromLoc),"^",2)
	.s fromUser=$lg(callBackInfo,4)
	.s:fromUser'="" fromUserName=$p(^SSU("SSUSR",fromUser),"^",2)
	.s callbackDate=$lg(callBackInfo,2)
	.s:+callbackDate'=0 callbackDate=..DL2H(callbackDate)
	.s callbackTime=$lg(callBackInfo,9) 
	.s:+callbackTime'=0 callbackTime=..TL2H(callbackTime)
	.s callbackDateTime=callbackDate_" "_callbackTime
	.s completeFlag=$lg(callBackInfo,14)
	
	;清洗详情
	s (cleanDatailId,cleanerName,cleanTypeName,cleanDateTime,cleanMachineNo,cleanBatchNo,cleanChkerName,cleanChkDateTime)=""
	s cleanDetail=transObj.CSSDTClean
	i $IsObject(cleanDetail) d
	.s cleanDatailId=cleanDetail.%Id()
	.s cleanMain=cleanDetail.CSSDCDPCleanMain
	.s cleanMachineNo=cleanMain.CSSDCMachineNo
	.s cleanBatchNo=cleanMain.CSSDCNo
	.s cleanType=cleanMain.CSSDCCleanMethod
	.i $IsObject(cleanType) d
	..s cleanTypeId=cleanType.%Id()
	..s cleanTypeInfo=##Class(User.CSSDCleanType).%OpenId(cleanTypeId)
	..s cleanTypeName=cleanTypeInfo.CSSDCTCleanMode		;清洗方式
	.s cleaner=cleanMain.CSSDCCleaner
	.i $IsObject(cleaner) d
	..s cleanerName=cleaner.%Id()_"@"_cleaner.SSUSRInitials_"@"_cleaner.SSUSRName 
	.s chker=cleanMain.CSSDCChker
	.i $IsObject(chker) d
	..s cleanChkerName=chker.SSUSRName
	.s cleanDate=cleanMain.CSSDCDate
	.s cleanDate=..DL2H(cleanDate)
    .s cleanChkDate=$s(##class(%Dictionary.CompiledProperty).%ExistsId("User.CSSDClean||CSSDCChkDate"):cleanMain.CSSDCChkDate,1:"")
	.s cleanChkDate=..DL2H(cleanChkDate)
	.s cleanTime=cleanMain.CSSDCTime
	.s cleanTime=..TL2H(cleanTime)
	.s cleanDateTime=cleanDate_" "_cleanTime
	.s cleanChkTime=cleanMain.CSSDCChkTime
	.s cleanChkTime=..TL2H(cleanChkTime)
	.s cleanChkDateTime=cleanChkDate_" "_cleanChkTime
	;手术室使用信息
	s (patientId,patientName,oprDoctorName,instNurseName,circNurseName,oprDt,oprRoom,oprRoomNo,useDept,infectName)=""
	s useinfo=..GetPkgUseInfo(label)
	i useinfo'="" d
	.s patientId=$p(useinfo,"|",1)
	.s patientName=$p(useinfo,"|",2)
	.s oprDoctorName=$p(useinfo,"|",3)
	.s instNurseName=$p(useinfo,"|",4)
	.s circNurseName=$p(useinfo,"|",5)
	.s oprDt=$p(useinfo,"|",6)
	.s oprDtD=$p(oprDt," ",1)
	.s oprDtTime=$p(oprDt," ",2)
	.s oprDtDF=..DH2L(oprDtD)
	.s oprDtF=..DL2H(oprDtDF)
	.s oprDt=oprDtF_" "_oprDtTime
	.s oprRoom=$p(useinfo,"|",7)
	.s oprRoomNo=$p(useinfo,"|",8)
	.s useDept=$p(useinfo,"|",9)
	.s infectName=$p(useinfo,"|",10)
	s packageLoc=packLocDesc
	i status="D"  d
	.s packageLoc=toLocDesc
	s status=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(status)
	s retval=$lb(transRowid,deptName,packageLoc,packageName,label,status,recallflag,
		packUserName,packDateTime,ackUserName,sterilizeDetailDr,sterilizeUserName,
		steDateTime,expDate,machineNo,batchNo,steChkerName,steChkDateTime,dispUserName,
		dispDate,toUserName,toLocDesc,callbackUserName,callbackDateTime,cleanDatailId,cleanerName,
		cleanTypeName,cleanDateTime,cleanMachineNo,cleanBatchNo,cleanChkerName,cleanChkDateTime
		,patientId,patientName,oprDoctorName,instNurseName,circNurseName,oprDt,oprRoom,
		oprRoomNo,useDept,infectName,rcvDate,fromLocDesc,SteLoc,toLoc,recallTime,recallUserName,recallReason)
	q retval
}

/// w ##class(web.CSSDHUI.Stat.TransStat).GetPkgUseInfo("00022021072100002")
ClassMethod GetPkgUseInfo(label As %String) As %String
{
	n (label)
	q:label="" ""
	s opid = $o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
	q:opid="" ""

	s transOp=##Class(User.CSSDTransOP).%OpenId(opid)
	s paadm=transOp.CSSDTOPPationtDR
	s oprDoctor=transOp.CSSDTOPOPDoctor
	s instNurse=transOp.CSSDTOPCountNurseDR	;器械护士
	s circNurse=transOp.CSSDOPCircNurse
	s oprDt=transOp.CSSDTOPCountNurseTime		;清点时间
	s oprRoomNo=transOp.CSSDTOPOPRoom			;手术房间号
	s opArrange=transOp.CSSDTOPANOPID
	s infectName=transOp.CSSDTOPInfectName

	s patientId=paadm.%Id()
	s admLocId=$p($g(^PAADM(patientId)),"^",4) ;病人所在的科室
    q:'##class(DHCHAI.Utils.CommonSrv).IsValidMethodName("web.CSSDHUI.Common.PackageInfoCommon","GetLocName") "" 
	s useDept=admLocId_"@"_$p(^CTLOC(admLocId),"^",1)_"@"_##Class(web.CSSDHUI.Common.PackageInfoCommon).GetLocName(admLocId)
	;s papmi=paadm.PAADMPAPMIDR
	;s patientName=papmi.PAPMIName
	s PatientInfo=##class(web.CSSDHUI.PackageRegister.PkgRegister).ByAdmGetPatInfoText(patientId)
	s patientId=$p(PatientInfo,"^",1)
	s patientName=$p(PatientInfo,"^",2)
	s (oprDoctorName,instNurseName,circNurseName,oprRoom)=""
	i $IsObject(oprDoctor) d
	.s oprDoctorName=oprDoctor.CTPCPDesc
	i $IsObject(instNurse) d
	.s instNurseName=instNurse.CTPCPDesc
	i $IsObject(circNurse) d
	.s circNurseName=circNurse.CTPCPDesc
	i $IsObject(opArrange) d
	.s opaId=opArrange.%Id()
	.s deptDr=opArrange.OPAPatDeptDr
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s admID=$P($P(^DHCANOPArrange(opaId),"^",2),"||",1)
	.s subchl=$o(^OR(admID,"ANA",chl,"OP",0))	;手术室 比如 第一手术室
	.s operLocId=$P(^OR(admID,"ANA",chl,"OP",subchl),"^",10)
	.s oprRoom=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetLocName(operLocId)
	
	;使用病人ID号;病人姓名;手术医生;器械护士;巡回护士;手术时间;手术室;手术房间号;使用科室;感染名称 
	s ret = patientId_"|"_patientName_"|"_oprDoctorName_"|"_instNurseName_"|"_circNurseName_"|"_oprDt_"|"_oprRoom_"|"_oprRoomNo_"|"_useDept_"|"_infectName
	q ret
}

/// Description:html日期(date)Logical格式,转换为html格式
ClassMethod DL2H(d As %String) As %String [ Final ]
{
	n (d)
	q ##class(websys.Conversions).DateLogicalToHtml(d)
}

/// Description:html日期(date)格式,转换为Logical格式
ClassMethod DH2L(d As %String) As %String [ Final ]
{
	n (d)
	q ##class(websys.Conversions).DateHtmlToLogical(d)
}

/// Description:html时间(time)Logical格式,转换为html格式
ClassMethod TL2H(t As %String) As %String [ Final ]
{
	n (t)
	q ##class(websys.Conversions).TimeLogicalToHtml(t)
}

/// Description:html时间(time)格式,转换为Logical格式
ClassMethod TH2L(t As %String) As %String [ Final ]
{
	n (t)
	q ##class(websys.Conversions).TimeHtmlToLogical(t)
}

/*
/// 获得消毒包追踪的详细信息
/// 配包，打包，灭菌，发放，(使用),回收，清洗 的详情
///        消毒包条码号：
///        消毒包名称：
///        消毒包状态：
///        是否召回：
/// 清洗   --清洗批次
///        --清洗锅号
///        清洗人
///        清洗时间
/// 配包  配包人：
///         审核人
///         配包时间：
/// 灭菌  灭菌人
///        灭菌时间
///        有效期至：
///        灭菌锅号
///        灭菌批次
///        灭菌合格确认人---
/// 发放   发送人
///        发送时间
///        接收人
///        接收科室
/// 使用   使用病人ID号
///        病人姓名：
///        手术医生
///        护士    --
///        手术时间--
/// 回收   回收人
///        回收时间
/// zn 2019-04-09
/// w ##Class(DHCHAI.DI.DIO.FromCSSDSrv).GetTransDetailInfo("232323232323333","")
ClassMethod GetTransDetailInfo(label As %String, Output retval As %String) As %String
{
    n (label,retval)

    s queryPid=$I(^TMPPackageTrans)
    s retval=""
    s i=0
    s tmpDate=""
    s tmpDate=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,tmpDate),-1)
    q:tmpDate="" retval
    s transRowid=""
    s transRowid=$o(^User.CSSDTransI("CSSDTLabelDate",$c(32)_label,tmpDate,transRowid),-1)
    q:transRowid="" retval
    s transInfo=$g(^User.CSSDTransD(transRowid))
    q:transInfo="" retval
    s transobj=""
    s transobj=##Class(User.CSSDTrans).%OpenId(transRowid)
    s status=$lg(transInfo,8)       
    s status=##Class(DHCHAI.DI.DIO.CSSDCommon).GetStatusChinese(status)       //状态
    s packagedr=$li(transInfo,16)       //消毒包id
    i $L(label)="15" s packageName=##Class(DHCHAI.DI.DIO.CSSDCommon).GetCodeDictName(label)
    e  s packageName=$lg(^User.CSSDPackageD(packagedr),5)
    s fixlabel=$e(label,1,9)
    ;w $L(label),!
    ;s packageName=##Class(web.CSSDCommon).GetCodeDictName(label)
    s deptName=##Class(DHCHAI.DI.DIO.CSSDCommon).GetCodeDictBindLocName(label)
    s LocID=""
    &sql(select cssdcd_oprlocid into :LocID  from SQLUser.cssd_codedict where cssdcd_code=:fixlabel )
    i LocID'="" d
    .s LocInfo=$g(^CTLOC(LocID))
    .s LocCode=$p(LocInfo,"^",1)
    .s LocDesc=$p(LocInfo,"^",2)
    ;s retval=packagedr_"^"_packageName
    ;s packageName=$li(^User.CSSDPackageD(packagedr),5)
    
    
    ;配包打包
    s packDr=$lg(transInfo,15)
    s packInfo=""
    s:packDr'="" packInfo=$g(^User.CSSDPackagePackD(packDr))
    i packInfo'=""  d
    .s packLocDr=$lg(packInfo,4)
    .s packLocDesc=$p(^CTLOC(packLocDr),"^",2)
    .s packUser=$lg(packInfo,9)         //配包人ID
    .s:packUser'="" packUserName=$p($g(^SSU("SSUSR",packUser)),"^",2)   //配包人name
    .s packUserCode=$p($g(^SSU("SSUSR",packUser)),"^",1)                //配包人code
    .s ackUser=$lg(packInfo,11)         //审核人id
    .s:ackUser'="" ackUserName=$p($g(^SSU("SSUSR",ackUser)),"^",2)
    .s packDate=$lg(packInfo,2)
    .s:+packDate'=0 packDate=$zd(packDate,3)
    .s packTime=$lg(packInfo,8)
    .s:+packTime'=0 packTime=$zt(packTime,1)
    .s packDateTime=packDate_" "_packTime
    .s ackDate=$lg(packInfo,12)
    .s:+ackDate'=0 ackDate=$zd(ackDate,3)
    .s dataPack=packDate_"^"_$g(packUserName)_"^"_"配包"_"^"_""_"^"_""
    .i status'="EP"  d
    ..s dataAck=ackDate_"^"_$g(ackUserName)_"^"_"打包"_"^"_""_"^"_""

    ;灭菌
    s sterilizeDetailDr=$lg(transInfo,17)
    s sterilizeDetailInfo=""
    s:sterilizeDetailDr'="" sterilizeDetailInfo=$g(^User.CSSDPackageSterilizeD(sterilizeDetailDr))
    i sterilizeDetailInfo'="" d
    .;召回标志
    .s recallflag=$lg(sterilizeDetailInfo,14)
    .s sterilizeMainDr=$lg(sterilizeDetailInfo,13)
    .s sterilizeMainInfo=$g(^User.CSSDSterilizeRecordD(sterilizeMainDr))
    .q:sterilizeMainInfo=""
    .;灭菌批号
    .s batchNo=$lg(sterilizeMainInfo,4)
    .;灭菌锅号
    .s machineNo=$lg(sterilizeMainInfo,18)
    .;失效日期
    .;s expDate=##Class(web.CSSDTransManager).GetExpDate(label)
    .s expDate=transobj.CSSDTExpDate
    .s expDate=$zd(expDate,3)           //灭菌有效期至
    .s sterilizeUser=$lg(sterilizeMainInfo,9)           //灭菌人id
    .s sterilizeUserName=""
    .s:sterilizeUser'="" sterilizeUserName=$p($g(^SSU("SSUSR",sterilizeUser)),"^",2)    //灭菌人name
    .s sterilizeUserCode=$p($g(^SSU("SSUSR",sterilizeUser)),"^",1)      //灭菌人code   
    .s sterilizeDate=$lg(sterilizeMainInfo,2)
    .s:sterilizeDate'="" sterilizeDate=$zd(sterilizeDate,3)
    .s sterilizeTime=$lg(sterilizeMainInfo,8)
    .s:sterilizeTime'="" sterilizeTime=$zt(sterilizeTime,1)
    .s steDateTime=sterilizeDate_" "_sterilizeTime              //灭菌时间
    .s steChker=$lg(sterilizeMainInfo,25)                       //灭菌验收人id
    .s:steChker'="" steChkerName=$p($g(^SSU("SSUSR",steChker)),"^",2) //灭菌验收人name
    .s steChkerCode=$p($g(^SSU("SSUSR",steChker)),"^",1)            //灭菌验收人code
    .s steChkTime=$lg(sterilizeMainInfo,26)
    .s:steChkTime'="" steChkTime=$zt(steChkTime,1)
    .;s steChkDateTime=sterilizeDate_" "_steChkTime
    .s steChkDateTime=steChkTime
    .s dataSterilize=sterilizeDate_"^"_$g(sterilizeUserName)_"^"_"灭菌"_"^"_""_"^"_""
    
    ;发放
    s dispDr=$lg(transInfo,14)
    s dispInfo="" 
    s:dispDr'="" dispInfo=$g(^User.CSSDPackageDispD(dispDr))
    i dispInfo'="" d
    .s (dispLocDesc,dispUserName,toLocDesc,toUserName)=""
    .s dispLoc=$lg(dispInfo,3)
    .s:dispLoc'="" dispLocDesc=$p($g(^CTLOC(dispLoc)),"^",2)
    .s dispUser=$lg(dispInfo,4)                                     //发放人id
    .s:dispUser'="" dispUserName=$p($g(^SSU("SSUSR",dispUser)),"^",2)   //发放人name
    .s:dispUser'="" dispUserCode=$p($g(^SSU("SSUSR",dispUser)),"^",1)                //发放人code
    .s toLoc=$lg(dispInfo,10)
    .s:toLoc'="" toLocDesc=$p(^CTLOC(toLoc),"^",2)
    .s toUser=$lg(dispInfo,11)
    .s:toUser'="" toUserName=$p($g(^SSU("SSUSR",toUser)),"^",2)
    .s dispDate=$lg(dispInfo,2)             //发放时间
    .;s:+dispDate'=0 dispDate=$zd(dispDate,3)
    .s rcvDate=$lg(dispInfo,17)
    .s dataDisp=dispDate_"^"_$g(dispUserName)_"^"_"发放"_"^"_$g(toUserName)_"^"_$g(toLocDesc)
    

    ;回收
    s callBackDr=$lg(transInfo,13)
    ;s callBackInfo=$g(^User.CSSDPackageCallbackD(""))
    ;这样是会报错的
    s callBackInfo=""
    s:callBackDr'="" callBackInfo=$g(^User.CSSDPackageCallbackD(callBackDr))
    i callBackInfo'="" d
    .s callbackLoc=$lg(callBackInfo,10)
    .;s:callbackLoc'="" callbackLocDesc=$p(^CTLOC(callbackLoc),"^",2)
    .i callbackLoc'="" d
    ..i $G(^CTLOC(callbackLoc))
    ...s callbackLocDesc=$p($g(^CTLOC(callbackLoc)),"^",2)
    .s callbackUser=$lg(callBackInfo,11)              //回收人id                          
    .s:callbackUser'="" callbackUserName=$p($g(^SSU("SSUSR",callbackUser)),"^",2)   //回收人name
    .s callbackUserCode=$p($g(^SSU("SSUSR",callbackUser)),"^",1)            //回收人code
    .s fromLoc= $lg(callBackInfo,3)
    .s:fromLoc'="" fromLocDesc=$p($g(^CTLOC(fromLoc)),"^",2)
    .s fromUser=$lg(callBackInfo,4)
    .s:fromUser'="" fromUserName=$p($g(^SSU("SSUSR",fromUser)),"^",2)
    .s callbackDate=$lg(callBackInfo,2)
    .s:+callbackDate'=0 callbackDate=$zd(callbackDate,3)
    .s callbackTime=$lg(callBackInfo,9) 
    .s:+callbackTime'=0 callbackTime=$zt(callbackTime,1)
    .s callbackDateTime=callbackDate_" "_callbackTime
    .s completeFlag=$lg(callBackInfo,14)
    .;s status="回收"
    .s dataCallback=callbackDate_"^"_$g(callbackUserName)_"^回收^"_$g(fromUserName)_"^"_$g(fromLocDesc)
    
    ;清洗详情
    s cleanDetail=transobj.CSSDTClean
    
    i $IsObject(cleanDetail) d
    .s cleanDatailId=cleanDetail.%Id()
    .s cleanMain=cleanDetail.CSSDCDPCleanMain
    .s cleanMachineNo=cleanMain.CSSDCMachineNo
    .s cleanBatchNo=cleanMain.CSSDCNo       //清洗批次
    .s cleaner=cleanMain.CSSDCCleaner     
    .i $IsObject(cleaner) d
    ..s cleanerId=cleaner.%Id()              //清洗人id
    ..s cleanerName=cleaner.SSUSRName       //清洗人name
    ..s cleanerCode=cleaner.SSUSRInitials   //清洗人code
    .s chker=cleanMain.CSSDCChker
    .i $IsObject(chker) d
    ..s cleanChkerName=chker.SSUSRName
    .s cleanDate=cleanMain.CSSDCDate
    .s cleanDate=$zd(cleanDate,3)
    .s cleanTime=cleanMain.CSSDCTime
    .s cleanTime=$zt(cleanTime,1)
    .s cleanDateTime=cleanDate_" "_cleanTime        //清洗时间
    .s cleanChkTime=cleanMain.CSSDCChkTime
    .s cleanChkTime=$zt(cleanChkTime,1)
    .s cleanChkDateTime=cleanDate_" "_cleanChkTime

    ;手术室使用信息
    ;s useinfo=..GetPkgUseInfo(label)
    s useinfo=##Class(DHCHAI.DI.DIO.FromCSSDSrv).GetPkgUseInfo(label)
    i useinfo'="" d
    .s PatientID=$p(useinfo,"|",1)          //病人id
    .s PatName=$p(useinfo,"|",2)            //病人name     
    .s oprDoctorName=$p(useinfo,"|",3)      //手术医生name
    .s instNurseName=$p(useinfo,"|",4)      //器械护士name
    .s circNurseName=$p(useinfo,"|",5)
    .s oprDt=$p(useinfo,"|",6)              //手术时间  
    .s oprRoom=$p(useinfo,"|",7)            //手术室
    .s oprRoomNo=$p(useinfo,"|",8)          //手术房间号
    .s useDept=$p(useinfo,"|",9)
    .s infectName=$p(useinfo,"|",10)        //感染名称
    .s oprDoctorID=$p(useinfo,"|",11)       //手术医生id
    .s oprDoctorCode=$p(useinfo,"|",12)     //手术医生code
    .s instNurseid=$p(useinfo,"|",13)       //器械护士id
    .s instNurseCode=$p(useinfo,"|",14)     //器械护士code

    s packageLoc=$g(packLocDesc)
    i status="D"  d
    .s packageLoc=$g(toLocDesc)
    s retval=$g(PatientID)_"^"_$g(PatName)_"^"_$g(packageName)_"^"_$g(LocID)_"^"_$g(LocCode)_"^"_$g(LocDesc)_"^"_$g(cleanBatchNo)_"^"_$g(cleanDateTime)_"^"_$g(cleanerId)_"^"_$g(cleanerCode)_"^"_$g(cleanerName)_"^"_$g(packDateTime)_"^"_$g(packUser)_"^"_$g(packUserCode)_"^"_$g(packUserName)
    s retval=retval_"^"_$g(batchNo)_"^"_$g(machineNo)_"^"_$g(steDateTime)_"^"_$g(sterilizeUser)_"^"_$g(sterilizeUserCode)_"^"_$g(sterilizeUserName)_"^"_$g(steChker)_"^"_$g(steChkerCode)_"^"_$g(steChkerName)_"^"_$g(expDate)_"^"_$g(dispDate)_"^"_$g(dispUser)_"^"_$g(dispUserCode)
    s retval=retval_"^"_$g(dispUserNameoprDt)_"^"_$g(oprDoctorID)_"^"_$g(oprDoctorCode)_"^"_$g(oprDoctorName)_"^"_$g(instNurseid)_"^"_$g(instNurseCode)_"^"_$g(instNurseName)_"^"_$g(oprRoom)_"^"_$g(oprRoomNo)_"^"_$g(infectName)_"^"_$g(callbackDateTime)_"^"_$g(callbackUser)_"^"_$g(callbackUserCode)_"^"_$g(callbackUserName)
    q retval
}

// w ##Class(web.CSSDPackageTrans).GetPkgUseInfo("000158016000002")

ClassMethod GetPkgUseInfo(label As %String) As %String
{
	;使用
		
	;使用病人ID号  
	;病人姓名
    ;手术医生   
    ;器械护士
    ;巡回护士   
    ;手术时间 
    ;手术室 
    ;手术房间号  
    ;使用科室   
    ;感染名称 
    n (label)
    s ret=""
    s opid = $o(^User.CSSDTransOPI("CSSDTOPLabelIndex",label,""))
    ;q:opid="" ""
    ;b
    i opid'="" d
    .s transOp=""
    .s transOp=##Class(User.CSSDTransOP).%OpenId(opid)
    .;w transOp
    .s paadm=transOp.CSSDTOPPationtDR
    .s patientId=paadm.%Id()
    .;病人所在的科室
    .s admLocId=$p($g(^PAADM(patientId)),"^",4) 
    .s useDept=##Class(DHCHAI.DI.DIO.CSSDCommon).GetLocName(admLocId)
    .s papmi=paadm.PAADMPAPMIDR
    .s patientName=papmi.PAPMIName
    .s oprDoctor=transOp.CSSDTOPOPDoctor
    .;b
    .i $IsObject(oprDoctor) d
    ..s oprDoctorName=oprDoctor.CTPCPDesc
    .;器械护士
    .;b
    .s instNurse=transOp.CSSDTOPCountNurseDR
    .i $IsObject(instNurse) d
    ..;s instNurseName=instNurse.CTPCPDesc
     ..s instNurseid=instNurse.%Id()
    ..s instNurseName=##Class(DHCHAI.DI.DIO.CSSDCommon).GetUserName(instNurseid)
    .;b
    .s circNurse=transOp.CSSDOPCircNurse
    .i $IsObject(circNurse) d
    ..s circNurseName=circNurse.CTPCPDesc
    .;清点时间
    .;b
    .;s oprDt=$zdt(transOp.CSSDTOPCountNurseTime,3)
    .s oprDt=transOp.CSSDTOPCountNurseTime
    .;手术房间号
    .s oprRoomNo=transOp.CSSDTOPOPRoom
    
    .s opArrange=transOp.CSSDTOPANOPID
    .;b
    .i $IsObject(opArrange) d
    ..s opaId=opArrange.%Id()
    ..s deptDr=opArrange.OPAPatDeptDr
    ..;i deptDr'="" d
    ..;使用科室 比如 肝胆外科
    ...;s useDept=##Class(DHCHAI.DI.DIO.CSSDCommon).GetLocName(deptDr)
	..s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	..;手术室 比如 第一手术室
	..s subchl=$o(^OR(patientId,"ANA",chl,"OP",""))
	..i subchl'="" d
	...s operLocId=$P(^OR(patientId,"ANA",chl,"OP",subchl),"^",10)
    ...s oprRoom=##Class(DHCHAI.DI.DIO.CSSDCommon).GetLocName(operLocId)
	.s infectName=transOp.CSSDTOPInfectName
	;w ret,!
	s ret = $g(patientId)_"|"_ $g(patientName)_"|"_$g(oprDoctorName)_"|"_$g(instNurseName)_"|"_$g(circNurseName)_"|"_$g(oprDt)_"|"_$g(oprRoom)_"|"_$g(oprRoomNo)_"|"_$g(useDept)_"|"_$g(infectName)
    q ret
}
*/
}
