Import SQLUser

/// 名称: 	  DHCWMRService
/// 描述: 	  病案管理对外接口程序
/// 编写者：  刘学峰
/// 编写日期: 2009-01-13
Class web.DHCWMRService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：liyi
/// Description：根据Paadm查询病案卷状态信息
/// Debug：w ##Class(web.DHCWMRService).GetMrStatusString(Paadm)
/// Input：Paadm
/// output：状态名称^操作日期^操作时间^操作人$c(1)状态名称^操作日期^操作时间^操作人
ClassMethod GetMrStatusString(Paadm As %String) As %String
{
	n (Paadm)
	s return=""
	q:Paadm="" return
	s data=""
	s VolId=""
	f  s VolId=$o(^DHCWMRVOL(0,"PaadmDr",Paadm,VolId)) q:VolId=""  d
	.q:$p($g(^DHCWMRVOL(VolId)),"^",7)="N"
	.q:'$d(^DHCWMRVOL(+VolId,"S"))
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCWMRVOL(+VolId,"S",ChildSub)) q:ChildSub=""  d
	..s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	..s WorkItem=$p(VolStatus,"^",2)
	..s UserFrom=$p(VolStatus,"^",3)
	..s UserTo=$p(VolStatus,"^",6)
	..s $p(VolStatus,"^",2)=$p(WorkItem,"/",1)
	..s $p(VolStatus,"^",3)=$p(UserFrom,"/",1)
	..s $p(VolStatus,"^",6)=$p(UserTo,"/",1)
	..i data="" d
	...s data=$p(WorkItem,"/",3)_"^"_$p(VolStatus,"^",4)_"^"_$p(VolStatus,"^",5)_"^"_$p(UserFrom,"/",3)
	..e  d
	...s data=data_$c(1)_$p(WorkItem,"/",3)_"^"_$p(VolStatus,"^",4)_"^"_$p(VolStatus,"^",5)_"^"_$p(UserFrom,"/",3)
 	..s return=data
	q return
}

/// Creator：    liyi
/// CreatDate：  2014-09-04
/// Service User:电子病历组
/// Description：通过病案号取就诊号
/// Table：      
/// Input：      MrNO：病案号 MrType:病案类型(住院病案：7，门诊病案：6 ，急诊病案：101)
/// Debug: 		 w ##class(web.DHCWMRService).IGetEpisodeIDsByMrNo("90177029","7","")
/// Return：     按病人分号：历次就诊号List，按就诊分号：单次就诊号
ClassMethod IGetEpisodeIDsByMrNo(aMrNo As %String, aMrType As %String, ByRef ErrMsg As %String) As %String
{
	New (aMrNo,ErrMsg,aMrType)
	Set return ="-1:入参未空"
	Quit:(aMrNo="")||(aMrType="") return
	
	Set return ="-2:病案号码不存在"
	Quit:'$d(^DHCWMRNO(0,"TypeNo",aMrType,aMrNo)) return
	
	Set $ZT="IGetEpisodeIDsByMrNoError"
	
	Set LeadingFactor = ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(aMrType)
	Set EpisodeIDs=""
	If (LeadingFactor="V")     //就诊分号
	{
		Set xVolumeID = ""
		For {
			Set xVolumeID = $o(^DHCWMRVOL(0,"VolNo",aMrNo,"Y",xVolumeID))
			Quit:xVolumeID=""
			Set tmpVolume = $g(^DHCWMRVOL(xVolumeID))
			Set EpisodeID=$p(tmpVolume,"^",2)
			Set EpisodeIDs = EpisodeID
			}
	}
	else			//病人分号
	{
		Set xMainID = ""
		For {
			Set xMainID = $o(^DHCWMRMAIN(0,"TypeNO",aMrType,aMrNo,xMainID))
			Quit:xMainID=""
			Set tmpMain = $g(^DHCWMRMAIN(xMainID))
			Continue:tmpMain=""
			Continue:$p(tmpMain,"^",6)="N"
			Set xVolumeID =""
			For {
				Set xVolumeID = $o(^DHCWMRVOL(0,"Main",xMainID,xVolumeID))
				Quit:xVolumeID=""
				Set tmpVolume = $g(^DHCWMRVOL(xVolumeID))
				Continue:tmpVolume=""
				Continue:$p(tmpVolume,"^",7)="N"
				Set EpisodeID=$p(tmpVolume,"^",2)
				Set EpisodeIDs=EpisodeIDs_$lb(EpisodeID)
				}
			}
	}
	
	Set return =EpisodeIDs
	Quit return
IGetEpisodeIDsByMrNoError
	Set ErrMsg = $ZE
	Quit ErrMsg
}

/// Creator： 		刘学峰
/// CreatDate： 	2009-03-02
/// Service User:	计费组
/// Description：	根据病案类型(MrTypeDr)和病案号(MrNo)查看病案号是否有效，
///  				若无效(返回值为1时),可分配使用此病案号
/// Table： 		DHC_WMR_Main
/// Input： 		MrTypeDr:病案类型指针;MrNo:病案号
/// Return： 		-1:入参错误;0:病案号有效；1:病案号无效(可新建此号)
/// Debug: 			w ##Class(web.DHCWMRService).CheckMrNoActive(MrTypeDr,MrNo)
ClassMethod CheckMrNoActive(MrTypeDr, MrNo)
{
	n (MrTypeDr,MrNo)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).CheckMrNoActive(MrTypeDr,MrNo)
		quit return
	}
    
	s ret=-1
	q:MrTypeDr="" ret
	q:MrNo="" ret
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	s RowId=0
	s ret=1
	f  s RowId=$o(^DHCWMRMAIN(0,"TypeNO",MrTypeDr,MrNo,RowId)) q:RowId=""  d
	.s str=$g(^DHCWMRMAIN(RowId))
	.s IsActive=$p(str,"^",6)
	.q:IsActive'="Y"
	.s:IsActive="Y" ret=0
	q ret
}

/// Creator： 		刘学峰
/// CreatDate： 	2009-03-30
/// Service User:	医生工作站组
/// Description：	变更病人基本信息界面：
/// 					修改病案号
/// 					生成病案信息 
/// 					生成病案号发放信息
/// Table： 		DHC_WMR_Main、DHC_WMR_No
/// Input： 		MrType			： 病案类型
///   				papmi			： Pa_PatMas.Rowid
///   				InPutMrNo		:  新分配的病案号
///  				UserId			： 接诊操作员Rowid   
/// Return： 		ret=MainRowid 成功    ret<0 失败;ret=0 既未取消病案，又未生成新的病案
/// Debug: 			w ##Class(web.DHCWMRService).IBuildMain(MrType, papmi, InPutMrNo, UserId)
ClassMethod IBuildMain(MrType, papmi, InPutMrNo, UserId)
{
	n (MrType, papmi , InPutMrNo, UserId)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=-1
		quit return
	}
    
	s ret=-1					 		;参数为空
	q:(MrType="")||(papmi="") ret
	
	s ctloc=""
	s:UserId'="" ctloc=+$p($g(^SSU("SSUSR",UserId)),"^",4)
	s InPutMrNo=$tr(InPutMrNo," ","")
    s InPutMrNo=$$ALPHAUP^SSUTIL4($g(InPutMrNo))
    s MainRowid=0						;将MainRowid初始值设为0，若既未取消病案，又未生成新的病案，则返回0
	;判断新输入的病案号是否可用。返回值：-1:入参错误;0:病案号有效；1:病案号无效(可新建此号)
	if (InPutMrNo'=""){
		s ret=-2						;新输入的病案号不可使用
		s InputMrNoAvaliable=..CheckMrNoActive(MrType,InPutMrNo)
		q:InputMrNoAvaliable'=1 ret
	}
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	//看传入的Papmi是否有对应的病案，如果有，直接返回病案的RowID
	s foundFlag=0
	s MainRowIDToPapmi=""
	s SavedMrRowID=""  
	f  s SavedMrRowID=$o(^DHCWMRMAIN(0,"PAPMI",papmi,SavedMrRowID),-1)  q:(SavedMrRowID="")||(foundFlag=1)  d
	.s strMain=$g(^DHCWMRMAIN(SavedMrRowID))
	.s:($p(strMain,"^",6)="Y")&&($p(strMain,"^",1)=MrType) foundFlag=1
	.s:($p(strMain,"^",6)="Y")&&($p(strMain,"^",1)=MrType) MainRowIDToPapmi=SavedMrRowID

	;w !,"MainRowIDToPapmi="_MainRowIDToPapmi
	Tstart
	i (MainRowIDToPapmi'="") {
		s ret=-3 							;无法取消病案
		s CancelFlag=1						;可以取消病案
		s volID="" 
		f  s volID=$o(^DHCWMRVOL(0,"Main",MainRowIDToPapmi,volID))  q:volID=""  d
		.s vol=$g(^DHCWMRVOL(volID))
		.s:$p(vol,"^",7)="Y" CancelFlag=0
		q:CancelFlag=0 ret
		s strMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowIDToPapmi)
		s $p(strMain,"^",7)="N" 			;IsActive
		;w !,"取消病案"
		s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(strMain) ;将老的病案主信息IsActive设置为N
		i +MainRowid<0 TRollBack
		;w !,"取消号码分配"
		;取消号码分配
		
		s MrNoOld=$p(strMain,"^",3)
		;w !,"MrNoOld="_MrNoOld
		s ret=-4
		s WMRNoRowId=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,MrNoOld)
		i +WMRNoRowId<0 TRollBack
		
	}
	if (InPutMrNo'=""){
		;^DHCWMRNO(0,"TypeNo",{MrType_Dr},{MrNo},{Rowid})
		;写入DHC_WMR_NO表
		s NoFlag=0
		s ret=-5             					;DHC_WMR_NO更新失败
		s sWMRNo=""
		s WMRNoRowId=""
		s WMRNoRowId=$o(^DHCWMRNO(0,"TypeNo",MrType,InPutMrNo,WMRNoRowId))
		s $p(sWMRNo,"^",1)=WMRNoRowId
		s $p(sWMRNo,"^",2)=MrType	      		;病案类型
		s $p(sWMRNo,"^",3)=InPutMrNo	      	;病案号
		s $p(sWMRNo,"^",4)="N"	      			;是否有效
		s $p(sWMRNo,"^",5)=ctloc	      		;所属接诊科室
		s $p(sWMRNo,"^",6)=UserId	      		;发放操作员
		s $p(sWMRNo,"^",7)=$zd(+$h,3)	      	;发放日起
		s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	;发放时间
		;w !,"sWMRNo="_sWMRNo
		s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
		;w !,"NoFlag="_NoFlag
		i NoFlag<0 TRollBack
		q:NoFlag<0 ret
		
		;写入DHC_WMR_MAIN表
		s ret=-6
		s sMain=""
		s $p(sMain,"^",2)=MrType
		s $p(sMain,"^",3)=InPutMrNo
		s $p(sMain,"^",4)=papmi
		s $p(sMain,"^",7)="Y"
		s $p(sMain,"^",8)="Y"
		s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
		i +MainRowid<0 TRollBack
		q:+MainRowid<0 ret
	}	
	s ret=-8
	;更新病案号
	s flag=0	
	;paperson.paper_governcardno
	s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(InPutMrNo,papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(InPutMrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(InPutMrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(InPutMrNo,papmi)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	TCommit
	q MainRowid
}

/// Creator：    刘学峰
/// CreatDate：  2009-03-23
/// Service User:计费组
/// Description：住院登记界面：
/// 				自动接诊
/// 				新建病案卷
/// Table：      DHC_WMR_MainVolume
/// Input：     
/// 			 MrType       ： 病案类型
///   			 paadm        ： 本次就诊 Pa_Adm.Rowid
///   			 NameSpell    :  病人姓名的拼音
///   			 InputMrNo    :  分配一个未入库的历史号码
///   			 UserId       ： 接诊操作员Rowid   
/// Return：     ret=VolRowid    ret<0 失败
/// Debug:       w ##Class(web.DHCWMRService).IBuildVolume(MrType, paadm, NameSpell, InputMrNo, UserId)
ClassMethod IBuildVolume(MrType, paadm, NameSpell, InputMrNo, UserId)
{
	n (MrType, paadm, NameSpell, InputMrNo, UserId)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=-1
		quit return
	}
    
	s ret=-1
	q:(MrType="")||(paadm="") ret
	s:MrType["东院" MrType=7
	s:MrType["西院" MrType=101
	s papmi=+$p($g(^PAADM(paadm)),"^",1)
	s strMain=##class(web.DHCWMRMainQry).GetMainByPapmi(MrType, papmi)
	s MainRowid=$p(strMain,"^",1)
	s ctloc=+$p($g(^SSU("SSUSR",UserId)),"^",4)
	;w !,"papmi="_papmi_"	;MainRowid="_MainRowid_"	;ctloc="_ctloc
	
	;s ^TempCacheLXF(0)=$lb(MrType,papmi,paadm,MainRowid,ctloc,NameSpell,InputMrNo,UserId)
	;q ret
	
	;取流的第一个操作项目
	s ret=-1.1
	s ItemDr=$$GetWorkFlow(MrType)
	q:ItemDr="" ret
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	
	Tstart
	s MrNo="",NoFlag=0
	
	s ret=-3
	;生成卷信息
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=##class(web.DHCWMRReceipt).GetIPCount("",MainRowid)
	s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	i +VolRowid<0 TRollBack
	q:+VolRowid<0 ret
	
	s ret=-3.1
	;生成卷病案号更改列表
	s sVolLog=""
	s $p(sVolLog,"^",1)=VolRowid
	s $p(sVolLog,"^",3)=+MainRowid
	s $p(sVolLog,"^",4)=UserId          ;User
	s VolLogRowid=##class(web.DHCWMRVolumeCtl).UpdateVolLog(sVolLog)
	i +VolLogRowid<0 TRollBack
	q:+VolLogRowid<0 ret
	
	s ret=-4
	;生成卷就诊列表信息   DHC_WMR_VolAdm
	s sVolAdm=""
    s $p(sVolAdm,"^",1)=VolRowid
    s $p(sVolAdm,"^",3)=paadm
	s VolAdmRowid=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
	i +VolAdmRowid<0 TRollBack
	q:+VolAdmRowid<0 ret
	
	s ret=-5
	;生成卷状态信息   DHC_WMR_VolStatus
	s sVolStatus=""
	s $p(sVolStatus,"^",1)=VolRowid
	s $p(sVolStatus,"^",3)=ItemDr
	s $p(sVolStatus,"^",4)=UserId
	s $p(sVolStatus,"^",7)=UserId
	s VolStatusRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sVolStatus)
	i +VolStatusRowid<0 TRollBack
	q:+VolStatusRowid<0 ret
	
	s ret=-6
	;生成卷信息   DHC_WMR_VolInfo
	s sVolInfo=##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(papmi,"")
	s $p(sVolInfo,"^",3)=NameSpell
	s $p(sVolInfo,"^",26)=VolRowid
	s VolInfoRowid=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(sVolInfo)
	i +VolInfoRowid<0 TRollBack
	q:+VolInfoRowid<0 ret
	
	/*
	s ret=-7
	s flag=0
	;更新入院时情况(病人入院状态--平稳/病重/病危)
	s:patcond'="" flag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(paadm,patcond)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	
	s ret=-8
	;更新病案号
	s flag=0	
	;paperson.paper_governcardno
	s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,papmi)
	i flag'=0 TRollBack
	q:flag'=0 ret
	*/
	
	TCommit
	
	;添加接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=1,xVolId=+VolRowid
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_papmi_"^"_paadm_"^"_ctloc_"^"_UserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=VolRowid
	q ret
	
GetWorkFlow(MrType)
    n (MrType)
    s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
    s ItemDr=""
    q:sFlow="" ItemDr
    s sTmp=$p(sFlow,$c(1),1)
    s ItemDr=$p(sTmp,"^",3)
    q ItemDr
}

/// Creator：    刘学峰
/// CreatDate：  2009-03-23
/// Service User:计费组
/// Description：住院登记界面：取消病案卷(不取消病案)
///              修改卷状态  IsActive=N
///              不取消病案号
/// Table：      DHC_WMR_MainVolume
/// Input：      Paadm     : 住院就诊PAADM RowID;
/// 			 RecUserId : 取消接诊操作人，SS_User表Rowid
/// Return：     ret=0 成功    ret<0 失败
/// Debug:       w ##Class(web.DHCWMRService).IUnReceiptByEpisodeID(Paadm, RecUserId)
ClassMethod IUnReceiptByEpisodeID(Paadm, RecUserId)
{
	n (Paadm, RecUserId)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=-1
		quit return
	}
    
	s ret=-1
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr}
	s RecLocId=+$p($g(^SSU("SSUSR",RecUserId)),"^",4)
	s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,""),-1)
	
	s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	q:sVol="" ret
	s MainRowid=+$p(sVol,"^",2)
	q:MainRowid'>0 ret
	s xVolId=+VolRowid
	
	s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s MrType=$p(sMrMain,"^",2)
	s xPapmi=$p(sMrMain,"^",4)
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	Tstart
	s ret=-2
	;取消卷
	s $p(sVol,"^",7)=+$p(sVol,"^",7)
	s $p(sVol,"^",8)="N"
	s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVol)
	i +flag<0 TRollBack
	q:+flag<0 ret
	
	/*  //根据中国医科大一附属医院需求，不取消病案号---by wuqk 2008-11-17
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    s MrType=$p(sMain,"^",2),MrNo=$p(sMain,"^",3),papmi=+$p(sMain,"^",4)
    s TmpVol="0",ActiveFlag=""             ;检查是否存在有效的卷
    
    s PapmiFlag=""
    ;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
    f  s TmpVol=$o(^DHCWMRVOL(0,"Main",MainRowid,TmpVol)) q:TmpVol=""  d
    .s IsActive=$p($g(^DHCWMRVOL(TmpVol)),"^",7)
    .i IsActive="Y" d
    ..s ActiveFlag="1"
    ..s tmpPaadm=$p($g(^DHCWMRVOL(TmpVol)),"^",2)
    ..i tmpPaadm'="" d
    ...s tmpPapmi=$p($g(^PAADM(+tmpPaadm)),"^",1)
    ...s:papmi=tmpPapmi PapmiFlag="1"
    
	s ret=-3
	;取消病案
    s:ActiveFlag="" $p(sMain,"^",7)="N"      ;无有效卷 取消main
    ;s:PapmiFlag="" $p(sMain,"^",4)=""        ;无相同papmi
    s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
    i +MainRowid<0 d
	.TRollBack
    q:+MainRowid<0 ret
    
    s MainFlag=0
    i ActiveFlag="" d
	.s ret=-4
	.;取消号码分配
	.s NoFlag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,MrNo)
	.i +NoFlag<0 d
	..TRollBack
	..s MainFlag=-1
	q:MainFlag<0 ret 
	
	s MainFlag=0
	i ActiveFlag="" d
	.s ret=-5
	.;更新住院病案号paperson.paper_governcardno
	.s flag=0
	.i papmi>0 d
	..s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",papmi)
	..s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",papmi)
	..;User.DHCPerson.PAPERFCMedicareCode1
	..s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(,papmi)
	..;User.DHCPerson.PAPERFCMedicareCode2
	..s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(,papmi)
	..;s flag=##class(web.DHCWMRMedBaseCtl).UpdateIPMrNo("",papmi)
	.i flag<0 d
	..TRollBack
	..s MainFlag=-1
	q:MainFlag<0 ret
	*/
	TCommit
	
	;添加取消接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=2,MrType="",MrNo="",Papmi="",Paadm=""
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_xPapmi_"^"_Paadm_"^"_RecLocId_"^"_RecUserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=0
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-04-08
/// Service User:
/// Description：根据传入的paadm，查询卷对应的有效的病案信息，传出病案号（MrNo）、病案类型（MrType）及病案类型描述
/// 			 add 2010-07-21	如果是卷主导,返回卷号
/// 任务单编号:  4940(妇产)
/// Table：      DHC_WMR_MainVolume、DHC_WMR_Main、DHC_WMR_Dictionary
/// Input：      EpisodeID
/// Return：     ret<0 失败；MrNo^MrTypeDR^MrTypeDesc
/// Debug:       w ##Class(web.DHCWMRService).IGetMrTypeInfo(EpisodeID)
ClassMethod IGetMrTypeInfo(EpisodeID)
{
	n (EpisodeID)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrTypeInfo(EpisodeID)
		quit return
	}
    
	s ret=-1
	q:EpisodeID="" ret
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s ret=-2
	q:'$d(^DHCWMRVOL(0,"VolAdm",EpisodeID)) ret
    s VolRowid=+$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,""),-1)
    
    s ret=-3
	q:'$d(^DHCWMRVOL(+VolRowid)) ret
	s sVolume=VolRowid_"^"_$g(^DHCWMRVOL(VolRowid))
	;w !,"sVolume="_sVolume
	s VolumeIsActive=$p(sVolume,"^",8)
	s ret=-4
	q:VolumeIsActive'="Y" ret
	s MainRowid=$p(sVolume,"^",2)
	s ret=-5
	q:'$d(^DHCWMRMAIN(MainRowid)) ret
    s sMain=$g(^DHCWMRMAIN(MainRowid))
    s sMain=MainRowid_"^"_sMain
	;w !,"sMain="_sMain
	s MainIsActive=$p(sMain,"^",7)
	s ret=-6
	q:MainIsActive'="Y" ret
	s MrTypeDR=$p(sMain,"^",2)
	s MrNo=$p(sMain,"^",3)
	;^DHCWMRDIC(0,"DicName","MrType","Y",6)=
	s ret=-7
	q:'$d(^DHCWMRDIC(MrTypeDR)) ret
	s sDic=MrTypeDR_"^"_$g(^DHCWMRDIC(MrTypeDR))
	s DicIsActive=$p(sDic,"^",11)
	s ret=-8
	q:DicIsActive'="Y" ret
	s MrTypeDesc=$p(sDic,"^",4)
	s ret=MrNo_"^"_MrTypeDR_"^"_MrTypeDesc
	
	s LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrTypeDR)
	//add 2010-07-21 如果是卷主导,返回卷号
	i (LeadingFactor="V") d
	.s VolNo=$p(sVolume,"^",11)
	.s ret=VolNo_"^"_MrTypeDR_"^"_MrTypeDesc
	;w !!
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-07-06
/// Service User:电子病历组
/// Description：根据EpisodeID取此次IP就诊对应的住院次数
/// Table：      DHC_WMR_MainVolume
/// Input：      EpisodeID
/// Return：     -1或住院次数。如果EpisodeID为空，返回-1
/// Debug:       w ##Class(web.DHCWMRService).IGetIPCountByEpisodeID(EpisodeID)
ClassMethod IGetIPCountByEpisodeID(EpisodeID)
{
    n (EpisodeID)
    
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetIPCountByEpisodeID(EpisodeID)
		quit return
	}
    
    ;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    s ret=-1
    q:EpisodeID="" ret
    s IPCount=0
    s FindFlag="N"
    s VolumeID=""
    f  s VolumeID=$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,VolumeID),-1) q:(VolumeID="")||(FindFlag="Y")  d
    .q:VolumeID=""
    .s sVolume=$g(^DHCWMRVOL(+VolumeID))
    .s IsActive=$p(sVolume,"^",7)
    .;w !,"IsActive="_IsActive
    .q:IsActive'="Y"
    .s FindFlag="Y"
    .s IPCount=$p(sVolume,"^",9)
	
    q IPCount
}

/// Creator：    刘学峰
/// CreatDate：  2009-08-25
/// Service User:电子病历组
/// Description：需求6338：根据患者就诊号取得病案回收状态 
/// Table：      DHC_WMR_MainVolume、DHC_WMR_Main、DHC_WMR_WorkFlow、DHC_WMR_WorkFlowSub
/// Input：      EpisodeID
/// Return：     病历回收状态:已回收返回1;未回收返回0;其他返回负值
/// Debug:       w ##Class(web.DHCWMRService).IGetMrRetrieveStatus(EpisodeID)
ClassMethod IGetMrRetrieveStatus(EpisodeID)
{
    n (EpisodeID)
    
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrRetrieveStatus(EpisodeID)
		quit return
	}
    
    s ret=-1							;EpisodeID为空，返回-1
    q:EpisodeID="" ret
    ;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s VolId=""
	s VolId=$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,VolId),-1)
	s ret=-2							;未找到卷Rowid，返回-2
	q:VolId="" ret
	s sVol=$g(^DHCWMRVOL(VolId))
	s VolIsActive=$p(sVol,"^",7)
	s ret=-3							;卷状态无效，返回-3
	q:VolIsActive'="Y" ret
	s MainDr=$p(sVol,"^",1)
	s sMain=$g(^DHCWMRMAIN(MainDr))
	s MainIsActive=$p(sMain,"^",6)
	s ret=-4							;卷状态有效，但病案状态无效，返回-4
	q:MainIsActive'="Y" ret
	s MrType=$p(sMain,"^",1)
	s VolCurrStatus=$p(sVol,"^",6)
	s WorkFlowId=""
	s WorkFlowId=$o(^DHCWMRWFLOW(0,"TypeActive",MrType,"Y",WorkFlowId))
	s ret=-5							;对应病案类型无有效工作流，返回-5
	q:WorkFlowId="" ret					
	s InitialWorkItem=$p($g(^DHCWMRWFLOW(WorkFlowId,"S",1)),"^",2)
	s ret=-6							;工作流未定义，返回-6
	q:InitialWorkItem="" ret
	i InitialWorkItem=VolCurrStatus d
	.s ret=0
	e  d
	.s ret=1
    q ret
}

/// Creator：    刘学峰
/// CreatDate：  2010-09-15
/// Service User:电子病历组
/// Description：根据患者EpisodeID取得病案归档状态 
/// Table：      DHC_WMR_MainVolume、DHC_WMR_Main、DHC_WMR_WorkFlow、DHC_WMR_WorkFlowSub
/// Input：      EpisodeID
/// Return：     病历归档状态:已归档(电子病历不能修改)返回1;
/// 						 未归档(电子病历可以修改)返回0;
/// 							其他返回负值
/// Debug:       w ##Class(web.DHCWMRService).IGetMrArchiveStatus(EpisodeID)
ClassMethod IGetMrArchiveStatus(EpisodeID)
{
    n (EpisodeID)
    
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrArchiveStatus(EpisodeID)
		quit return
	}
    
    s ret=-1							//EpisodeID为空，返回-1
    q:EpisodeID="" ret
    ;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s VolId=""
	s VolId=$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,VolId),-1)
	s ret=-2							//未找到卷Rowid，返回-2
	q:VolId="" ret
	s sVol=$g(^DHCWMRVOL(VolId))
	s VolIsActive=$p(sVol,"^",7)
	s ret=-3							//卷状态无效，返回-3
	q:VolIsActive'="Y" ret
	s MainDr=$p(sVol,"^",1)
	s sMain=$g(^DHCWMRMAIN(MainDr))
	s MainIsActive=$p(sMain,"^",6)
	s ret=-4							//卷状态有效，但病案状态无效，返回-4
	q:MainIsActive'="Y" ret
	s MrType=$p(sMain,"^",1)
	s VolCurrStatus=$p(sVol,"^",6)		//卷当前状态
	s PatientID=$p(sMain,"^",3)			//PatientID
 
	;w "VolCurrStatus="_VolCurrStatus,!
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
	s ret=-5
    q:sFlow="" ret
    s sFlowLength=$l(sFlow,$c(1))
    //取工作流最后一个状态
    s sTmp=$p(sFlow,$c(1),sFlowLength)
    s LastWorkItem=$p(sTmp,"^",3)		//归档上架状态ID
    s WorkFlowId=$p(sTmp,"||",1)		//工作流ID
    s ArchiveItemID=..GetArchiveItemID(MrType) //根据病案类型获取归档状态ID配置
    s:ArchiveItemID'>0 ArchiveItemID=LastWorkItem //未获取到配置ID，设置工作流最后一个状态为默认
    ;w "WorkFlowId="_WorkFlowId_";LastWorkItem="_LastWorkItem,!
	;^DHCWMRWFLOW({DHC_WMR_WorkFlow.Rowid},"S",0,"ItemDr",{Item_Dr},{ChildSub})                                         
	//第一种情况，卷当前状态在顺序工作流中
	if ($d(^DHCWMRWFLOW(WorkFlowId,"S",0,"ItemDr",VolCurrStatus))){
		;w "In Flow",!
		s CurrStatusPos=$o(^DHCWMRWFLOW(WorkFlowId,"S",0,"ItemDr",VolCurrStatus,"")) //当前操作状态在工作流中的位置
		s ArchiveItemIDPos=$o(^DHCWMRWFLOW(WorkFlowId,"S",0,"ItemDr",ArchiveItemID,"")) //当前操作状态在工作流中的位置
		;w "CurrStatusPos="_CurrStatusPos_";ArchiveItemIDPos="_ArchiveItemIDPos,!
		i CurrStatusPos>=ArchiveItemIDPos d
		.s ret=1 //当前状态位置大于等于设置状态位置，则为归档
		e  d
		.s ret=0
	}else{
	//第二种情况，卷当前状态不在顺序工作流中,经过“配置状态”操作，算作归档
		;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",0,"Status",{Status_Dr},{ChildSub})
		;w "Out Flow",!
		i $d(^DHCWMRVOL(VolId,"S",0,"Status",ArchiveItemID)) d
		.s ret=1
		e  d
		.s ret=0
	}
	
	//特殊情况：积水潭医院--卷状态为“病历核对”(ID为20)时，认为是未归架
	s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
	i (HospCode="BeiJing_JST")&&(VolCurrStatus=20) d
	.s ret=0 
	//特殊情况：华西医院--如果卷未归档(ret=0)，判断出院日期是否超过时间要求
	e  i (HospCode="ChengDu_HX")&&(ret=0) d
	.s DisDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(EpisodeID)
	.//如果出院日期不为空
	.i $tr(DisDateTime," ","")'="" d
	..s DisDate=$p(DisDateTime," ",1)
	..s DisDate=$zdh(DisDateTime,3)
	..s DaysSpan=+$h-DisDate //出院天数
	..//判断病人是否死亡
	..s IsDead=$p($g(^PAPER(PatientID,"ALL")),"^",12) ;PAPER_Deceased
	..s ScheduleDays=##class(web.DHCWMRService).GetScheduleDays(MrType,IsDead)
	..;w "DisDate="_DisDate_";DaysSpan="_DaysSpan_";ScheduleDays="_ScheduleDays_";IsDead="_IsDead,!
	..s:(ScheduleDays'=0)&&(DaysSpan>ScheduleDays) ret=1 //出院日期超过规定日期，不能修改病历
    q ret
}

/// Creator：    李阳
/// CreatDate：  2009-11-11
/// Service User:体检组
/// Description：批量生成病案调阅申请 
/// Table：      DHC_WMR_Requset
/// Input：      MrType--病案类型 O：门诊 I：住院
/// 		     MrNo--病案号
/// 		     Paadm--病人就诊ID
/// 		     Ctloc--病人就诊科室
/// 		     User--操作员
/// 		     DateTime--日期、时间  用$h传入即可
/// Return：     -1 病案类型为空  -2 病案号为空  -3 没有此病案记录
///              正常：返回申请操作的Rowid
/// Debug:       w ##Class(web.DHCWMRService).PERequest("I",530045,5371460,324,2040,$h)
ClassMethod PERequest(MrType, MrNo, Paadm, Ctloc, User, DateTime)
{
	n (MrType,MrNo,Paadm,Ctloc,User,DateTime)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=-1
		quit return
	}
    
	s:MrType="O" MrType=6
	s:MrType="I" MrType=7
	q:(MrType'=6)&&(MrType'=7) -1
	q:MrNo="" -2
	
	s RequestType=$o(^DHCWMRDIC(0,"DicNameCode","RequestType","04","")) //体检类型
	
	s MainDr=""
	s MainID="" f  s MainID=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,MainID)) q:MainID=""  d
	.s data=$g(^DHCWMRMAIN(MainID))
	.q:$p(data,"^",6)'="Y"
	.s MainDr=MainID

	q:MainDr="" -3
	s WorkItemDr=16  //对应“出库”工作项目
	s AimDate=+DateTime
	s time=$p(DateTime,",",2)
	s instr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	s $p(instr,"^",1)=""
	s $p(instr,"^",2)=MrType
	s $p(instr,"^",3)=MainDr
	s $p(instr,"^",4)=RequestType
	s $p(instr,"^",5)=WorkItemDr
	s $p(instr,"^",6)=AimDate
	s $p(instr,"^",7)=Ctloc
	s $p(instr,"^",8)=""   //User
	s $p(instr,"^",9)="Y" //优先级
	s $p(instr,"^",10)=AimDate
	s $p(instr,"^",11)=time
	s $p(instr,"^",12)=User
	s $p(instr,"^",13)="Y"
	s $p(instr,"^",14)=""
	s $p(instr,"^",15)=""
	s $p(instr,"^",16)=""
	s $p(instr,"^",17)=""
	s $p(instr,"^",18)=""
	s $p(instr,"^",19)=Paadm
	s ret=##class(web.DHCWMRRequest).UpdateRequest(instr)
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-11-25
/// Service User:沈阳医大一院项目组
/// Description：自动接诊前一天漏接诊病案卷数据
/// Table：      Pa_Adm,DHC_WMR_MainVolume
/// Input：      MrType : 病案类型，医大一院住院病案类型为7
/// 			 UserId : 接诊用户ID,默认为1,即Demo
/// 			 Days   : 接诊天数(即接诊前Days天数据,不包括当前天)
/// Return：    
/// Debug:       w ##Class(web.DHCWMRService).IReceiptMissVolume(7,1,1)
ClassMethod IReceiptMissVolume(MrType, UserId, Days)
{
    n (MrType,UserId,Days)
    
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=-1
		quit return
	}
    
    s ret=-1							;Days为空，返回-1
	q:MrType="" ret
	q:UserId="" ret
	q:Days="" ret
	
	s SuccCnt=0								;成功接诊次数
	s FailCnt=0								;失败接诊次数
	;s LoopCnt=0								;循环EpisodeID次数
	
	s currDay=+$h							;设置当前日期
	s startDay=+$h-Days						;循环起始日期
	s endDay=+$h-1							;循环结束日期
	;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	f AdmDate=startDay:1:endDay d
	.w "日期:"_$zd(AdmDate,3),!
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",AdmDate,EpisodeID)) q:EpisodeID=""  d
	..s strPAADM=$g(^PAADM(EpisodeID))
	..q:strPAADM=""
	..s PAADMType=$p(strPAADM,"^",2)			
	..q:PAADMType'="I"
	..s PAADMVisitStatus=$p(strPAADM,"^",20)
	..q:(PAADMVisitStatus'="A")&&(PAADMVisitStatus'="D")
	..//add 2010-07-10 过滤新生儿就诊
	..s PaadmMotherAdmDR=$p($g(^PAADM(+EpisodeID)),"^",75)
    ..q:PaadmMotherAdmDR'=""
	..;新增索引:^DHCWMRVOL(0,"PaadmDr",{Paadm_Dr},{Rowid}) 
	..s VolRowid=""
	..s ExistFlag="N"
	..;检查DHC_WMR_MainVolume表中，该次住院就诊是否被接诊并且有效
	..f  s VolRowid=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,VolRowid)) q:(VolRowid="")||(ExistFlag="Y")  d
	...s strVolume=$g(^DHCWMRVOL(VolRowid))
	...q:strVolume=""
	...s IsActive=$p(strVolume,"^",7)
	...s:IsActive="Y" ExistFlag="Y"			;如果存在有效卷，说明此Adm已经接诊
	...q:IsActive="Y"
	..i ExistFlag="N" d
	...s PatientID=$p(strPAADM,"^",1)
	...s:PatientID="" ^DHCWMRRecTask($zd(+$h,3),"Fail","PatientIDEmpty",EpisodeID,RegMrNo)="EpisodeID:"_EpisodeID_";RegMrNo:"_RegMrNo
	...q:PatientID=""
	...s RegMrNo=""
	...s RegMrNo=##Class(web.DHCWMRMedBaseCtl).GetHISMrNo(PatientID, MrType)
	...s:RegMrNo="" ^DHCWMRRecTask($zd(+$h,3),"Fail","MrNoEmpty",EpisodeID,PatientID)="EpisodeID:"_EpisodeID_";PatientID:"_PatientID
	...s:RegMrNo="" FailCnt=FailCnt+1
	...q:RegMrNo=""
	...s NameSpell=""
	...s NewVolRowID=##Class(web.DHCWMRReceipt).ReceiptByReg(MrType, EpisodeID, NameSpell, RegMrNo, UserId)
	...s:NewVolRowID<0 ^DHCWMRRecTask($zd(+$h,3),"Fail","RecError",EpisodeID,PatientID,RegMrNo,NewVolRowID)="EpisodeID:"_EpisodeID_";PatientID:"_PatientID_";RegMrNo:"_RegMrNo_";NewVolRowID:"_NewVolRowID
	...s:NewVolRowID<0 FailCnt=FailCnt+1
	...s:NewVolRowID>0 ^DHCWMRRecTask($zd(+$h,3),"Succ",EpisodeID,PatientID,RegMrNo,NewVolRowID)="EpisodeID:"_EpisodeID_";PatientID:"_PatientID_";RegMrNo:"_RegMrNo_";NewVolRowID:"_NewVolRowID
	...s:NewVolRowID>0 SuccCnt=SuccCnt+1
    s ^DHCWMRRecTask(0,$zd(+$h,3),"SuccCnt")=SuccCnt
    s ^DHCWMRRecTask(0,$zd(+$h,3),"FailCnt")=FailCnt
    w:FailCnt>0 "病案接诊出现错误,请查看Global:DHCWMRRecTask;错误数量:"_FailCnt,!
    q "Receipt Miss Volume Finish!"
}

/// Creator：    刘学峰
/// CreatDate：  2010-11-01
/// Service User:计费组
/// Description：根据传入的PatientID和MrType，查询病人对应的有效的病案信息，传出病案号（MrNo）、病案类型（MrType）及病案类型描述
/// Table：      DHC_WMR_MainVolume、DHC_WMR_Main、DHC_WMR_Dictionary
/// Input：      PatientID，病案类型
/// Return：     ret<0 失败；MrNo^MrTypeDR^MrTypeDesc
/// Debug:       w ##Class(web.DHCWMRService).IGetMrTypeInfoByPatID(PatientID)
ClassMethod IGetMrTypeInfoByPatID(PatientID, argMrType)
{
	n (PatientID,argMrType)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrTypeInfoByPatID(PatientID, argMrType)
		quit return
	}
    
	s PatientID=+PatientID
	s argMrType=+argMrType
	
	s ret=-1
	q:PatientID=0 ret
	q:argMrType=0 ret
	
	s ret=-2
	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	q:'$d(^DHCWMRMAIN(0,"PAPMI",PatientID)) ret
	
	s ret=-3
	s MainRowid="",findFlag=0
	f  s MainRowid=$o(^DHCWMRMAIN(0,"PAPMI",PatientID,MainRowid)) q:(MainRowid="")||(findFlag=1)  d
    .s sMain=$g(^DHCWMRMAIN(MainRowid))
    .s sMain=MainRowid_"^"_sMain
	.;w !,"sMain="_sMain
	.s MainIsActive=$p(sMain,"^",7)
	.q:MainIsActive'="Y"
	.s MrTypeDR=$p(sMain,"^",2)
	.q:MrTypeDR'=argMrType
	.s MrNo=$p(sMain,"^",3)
	.s findFlag=1
	q:findFlag=0 ret
	
	;^DHCWMRDIC(0,"DicName","MrType","Y",6)=
	s ret=-4
	q:'$d(^DHCWMRDIC(argMrType)) ret
	s sDic=argMrType_"^"_$g(^DHCWMRDIC(argMrType))
	s DicIsActive=$p(sDic,"^",11)
	s ret=-5
	q:DicIsActive'="Y" ret
	s MrTypeDesc=$p(sDic,"^",4)
	s ret=MrNo_"^"_argMrType_"^"_MrTypeDesc
	
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2010-11-24
/// Service User:医生站
/// Description：根据传入的病案号和病案类型，获取病人PatientID
/// Table：      DHC_WMR_Main
/// Input：      argMrNo病案号；argMrType病案类型(非集团化医院传入7)
/// Return：     ret=-1传入病案号为空，ret=-2未找到PatientID
/// Debug:       w ##Class(web.DHCWMRService).IGetPatIDByMrNo(argMrNo, argMrType)
ClassMethod IGetPatIDByMrNo(argMrNo, argMrType)
{
	n (argMrNo, argMrType)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set:+argMrType=0 argMrType=7  //add by zf 20150325
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetPatIDByMrNo(argMrNo, argMrType)
		quit return
	}
    
	s ret=-1
	q:argMrNo="" ret
	s:+argMrType=0 argMrType=7
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	s MainID=""
	s FindFlag="N"
	f  s MainID=$o(^DHCWMRMAIN(0,"TypeNO",argMrType,argMrNo,MainID),-1) q:(MainID="")||(FindFlag="Y")  d
	.s strMain=$g(^DHCWMRMAIN(+MainID))
	.s IsActive=$p(strMain,"^",6) 			;是否有效
	.q:IsActive'="Y"
	.s tmpPatientID=+$p(strMain,"^",3) 		;PatientID
	.q:tmpPatientID=0
	.s ret=tmpPatientID
	.s FindFlag="Y"
	s:FindFlag="N" ret=-2
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2010-12-17
/// Description：(华西医院)根据病案类型、病人是否死亡，获取病历规定上交天数
/// Table：      DHC_WMR_NoType
/// Input：      MrType,IsDead
/// Return：     病历规定上交天数
/// Debug:       w ##class(web.DHCWMRService).GetScheduleDays(MrType,IsDead)
ClassMethod GetScheduleDays(MrType, IsDead)
{
	n (MrType,IsDead)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//新版本病案此接口作废
		set return=0
		quit return
	}
    
	s DaysSpan=0 	//病历上交天数
	i IsDead="Y" d
	.s DaysSpan=$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",17) //死亡病历上交天数取Text4值
	e  d
	.s DaysSpan=$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",16) //正常病历上交天数取Text3值
	q +DaysSpan
}

/// Creator：    刘学峰
/// CreatDate：  2010-12-17
/// Description：根据病案类型获取归档操作项ID
/// Table：      DHC_WMR_NoType
/// Input：      MrType
/// Return：     归档操作项ID
/// Debug:       w ##class(web.DHCWMRService).GetArchiveItemID(MrType)
ClassMethod GetArchiveItemID(MrType)
{
	n (MrType)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).GetArchiveItemID(MrType)
		quit return
	}
    
	s DaysSpan=0 	//病历上交天数
	s ArchiveItemID=+$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",18) //ArchiveItemID字段值(配置表中待增)
	s ArchiveItemID=2
	q ArchiveItemID
}

/// 描述：根据EpisodeID获取病案号
/// 入参：EpisodeID 就诊ID
/// 正确返回值：病案号
/// 异常返回值：-10:入参为空 -1:错误信息 -2:病案卷不存在 -3:非住院病人 -4:无效病案 -5:卷无效 -7:就诊不存在 -8:病案号为空 -9:卷病案号为空
/// Debug:w ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
/// Modified by wuqk 2013-05-15
/// 增加入参，用于返回错误信息
/// 入参：EpisodeID: 就诊ID
///       ErrMsg   : 返回错误信息
/// 返回值：病案号,如果出现错误，返回空
/// Debug:Set MrNo = ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID,.ErrMsg)
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String, ByRef ErrMsg As %String = "") As %String
{
	New (EpisodeID,ErrMsg)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		;set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrNoByEpisodeID(EpisodeID,.ErrMsg)
		set return=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"","")
		quit return
	}
    
	Set ErrMsg = "-10:入参为空"
	Set MrNo = ""
	Quit:EpisodeID="" MrNo
	
	Set ErrMsg = "-7:就诊不存在"
	Quit:'$d(^PAADM(EpisodeID)) MrNo ;就诊不存在
	
	Set $ZT="IGetMrNoByEpisodeIDError"
	
	//add by zf 2013-12-04
	//增加新生儿的病案号取值
	Set MotherDr=$p($g(^PAADM(EpisodeID)),"^",75)  //母亲分娩记录对应就诊号
	If MotherDr'="" {
		Set MrNo=##class(web.DHCWMRService).GetNewBabyMrNo(EpisodeID)
		Quit MrNo
	}
	
	Set VolID=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,""),-1)
	Set ErrMsg = "-2:病案卷不存在"
	Quit:VolID="" MrNo  ;病案卷不存在
	
	Set AdmType=$p(^PAADM(EpisodeID),"^",2)
	Set ErrMsg = "-3:非住院病人"
	Quit:AdmType'="I" MrNo  ;非住院病人
	
	Set VolIsActive=$p(^DHCWMRVOL(VolID),"^",7)
	Set ErrMsg = "-5:卷无效"
	Quit:VolIsActive="N" MrNo ;卷无效
	
	Set MainID=$p(^DHCWMRVOL(VolID),"^",1)
	Set MrType=$p(^DHCWMRMAIN(MainID),"^",1)
	Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
	Set MrNo=$p(^DHCWMRMAIN(MainID),"^",2)
	Set IsActive=$p(^DHCWMRMAIN(MainID),"^",6)
	
	Set ErrMsg = "-4:无效病案"
	Quit:IsActive="N" MrNo ;无效病案
	Set ErrMsg="-8:病案号为空"
	Set:$ZCVT(LeadingFactor,"U")="V" MrNo=$p(^DHCWMRVOL(VolID),"^",10),ErrMsg = "-9:卷病案号为空"
	Quit:MrNo="" MrNo
	Set ErrMsg = ""
	Quit MrNo
IGetMrNoByEpisodeIDError
    Set ErrMsg = $ZE
    Quit MrNo
}

/// 描述：根据PatientID获取病案号
/// 入参：PatientID 病人基本信息ID
/// 正确返回值：病案号
/// 异常返回值：-10:入参为空 -1:错误信息 -3:不是住院病人 -4:无效病案 -6:病案不存在 -8:病案号为空 -9:卷病案号为空  -11:病案类型为空
/// Debug:w ##Class(web.DHCWMRService).IGetMrNoByPatientID(143809)
/// Modified by wuqk 2013-05-15
/// 增加入参，用于返回错误信息
/// 入参：PatientID: 病人基本信息ID
///       ErrMsg   : 返回错误信息
/// 返回值：病案号,如果出现错误，返回空
/// Debug:set MrNo = ##Class(web.DHCWMRService).IGetMrNoByPatientID(PatientID,.ErrMsg)
ClassMethod IGetMrNoByPatientID(PatientID As %String, ByRef ErrMsg As %String = "")
{
	New (PatientID,ErrMsg)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetMrNoByPatientID(PatientID,.ErrMsg)
		quit return
	}
    
	Set ErrMsg = "-10:入参为空"
	Set MrNo = ""
	Quit:PatientID="" MrNo
	
	Set $ZT="IGetMrNoByPatientIDError"
	
	//add by zf 2013-12-04
	//增加新生儿的病案号取值
	If MrNo="" {
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM","I",xEpisodeID))
			Quit:xEpisodeID=""
			Continue:MrNo'=""
			
			Set MotherDr=$p($g(^PAADM(xEpisodeID)),"^",75)  //母亲分娩记录对应就诊号
			Continue:MotherDr=""
			Set MrNo=##class(web.DHCWMRService).GetNewBabyMrNo(xEpisodeID)
		}
	}
	
	Set MainID=$o(^DHCWMRMAIN(0,"PAPMI",PatientID,""),-1)
	Set ErrMsg = "-6:病案不存在"
	Quit:MainID="" MrNo ;病案不存在
	
	Set IsActive=$p(^DHCWMRMAIN(MainID),"^",6)
	Set ErrMsg = "-4:无效病案"
	Quit:IsActive="N" MrNo ;无效病案
	
	Set MrType=$p(^DHCWMRMAIN(MainID),"^",1)
	;Set MTAdmTypeDR=$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",9)
	Set ErrMsg = "-11:病案类型为空"    //此处提供错误信息   by wuqk
	Quit:(MrType="")||'$d(^DHCWMRDIC(MrType)) MrNo
	
	Set MTAdmType=$p($g(^DHCWMRDIC(MrType)),"^",3)
	Set ErrMsg = "-3:不是住院病人"
	Quit:MTAdmType'["住院" MrNo ;不是住院病人
	
	Set MrNo=$p(^DHCWMRMAIN(MainID),"^",2),ErrMsg="-8:病案号为空"
	Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
	If ($ZCVT(LeadingFactor,"U")="V"){
		Set (LastVolID,VolNo)=""
		For {
		    Set LastVolID=$o(^DHCWMRVOL(0,"Main",MainID,LastVolID),-1)
		    Quit:(LastVolID="")||(VolNo'="")
		    Set Paadm=$p(^DHCWMRVOL(LastVolID),"^",2)
		    Continue:'$d(^PAADM(Paadm))
		    Set AdmType=$p(^PAADM(Paadm),"^",2)
		    Continue:AdmType'="I"  ;非住院病人
		    Set VolIsActive=$p(^DHCWMRVOL(LastVolID),"^",7)
		    Continue:VolIsActive="N"  ;无效病案卷
		    Set VolNo=$p(^DHCWMRVOL(LastVolID),"^",10)
		}
		Set MrNo=VolNo
		Set:VolNo="" ErrMsg="-9:卷病案号为空"
	}
	Quit:MrNo="" MrNo
	
	Set ErrMsg=""
	Quit MrNo
IGetMrNoByPatientIDError
     Set ErrMsg="-1:"_$ZE
     Quit MrNo
}

/// 描述：根据病案号获取PatientID
/// 入参：MrNo 病案号
///       ErrMsg 错误信息
/// 正确返回值：PatientID 病人基本信息ID
/// 异常返回值：-10:入参为空 -1:错误信息 -11:病案号错误
/// Debug:w ##Class(web.DHCWMRService).IGetPatientIDByMrNo(MrNo,.ErrMsg)
ClassMethod IGetPatientIDByMrNo(MrNo As %String, ByRef ErrMsg As %String) As %String
{
	New (MrNo,ErrMsg)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetPatientIDByMrNo(MrNo,.ErrMsg)
		quit return
	}
    
	Set ErrMsg="-10:入参为空"
	Set $ZT="IGetPatientIDByMrNoError"
	Quit:MrNo="" -10
	Set PatientID=""
	Set MrType=0
	For {
		Set MrType=$O(^DHCWMRMAIN(0,"TypeNO",MrType))
		Quit:(MrType="")||(PatientID'="") 
		;Set MTAdmTypeDR=$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",9)
		Continue:'$d(^DHCWMRDIC(MrType))
		Set MTAdmType=$p($g(^DHCWMRDIC(MrType)),"^",3)
		Continue:MTAdmType'["住院" 
		Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType) 
		If (($ZCVT(LeadingFactor,"U")="V")&&($d(^DHCWMRVOL(0,"VolNo",MrNo)))){
			Set VolID=$O(^DHCWMRVOL(0,"VolNo",MrNo,"Y",""),-1)
			Continue:VolID=""      ;卷不存在
			
			Set Paadm=$P($g(^DHCWMRVOL(VolID)),"^",2)
			Continue:Paadm=""      ;就诊不存在
			Set AdmType=$p(^PAADM(Paadm),"^",2)
		    Continue:AdmType'="I"  ;非住院病人
			Set IsActive=$P($g(^DHCWMRVOL(VolID)),"^",2)
			Continue:IsActive="N"  ;病案卷无效
			Set MainID=$P($g(^DHCWMRVOL(VolID)),"^",1)
			Continue:MainID=""     ;病案不存在
			Set MIsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)
			Continue:MIsActive="N" ;病案无效
			Set PatientID=$p($g(^DHCWMRMAIN(MainID)),"^",3)
		}ElseIf($d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo))&&($ZCVT(LeadingFactor,"U")'="V")){
			Set MainID=$O(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""),-1)
			Continue:MainID=""
			Set MIsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)
			Continue:MIsActive="N" ;病案无效
			Set PatientID=$p($g(^DHCWMRMAIN(MainID)),"^",3)	
		}
	}
	Set ErrMsg="-11:病案号错误"
	Quit:PatientID="" PatientID
	Set ErrMsg=""
	Quit PatientID
IGetPatientIDByMrNoError
    Set ErrMsg="-1:"_$ZE
    Quit PatientID
}

/// w ##Class(web.DHCWMRService).GetIPMrNoByAdm(4)
ClassMethod GetIPMrNoByAdm(EpisodeID As %String) As %String
{
	New (EpisodeID)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).GetIPMrNoByAdm(EpisodeID)
		quit return
	}
    
	Set MrNo=""
	
	Set $ZT="GetIPMrNoByAdmErr"
	
	Set ErrMsg = "-1:入参为空"
	Quit:EpisodeID="" MrNo
	
	Set ErrMsg = "-2:就诊不存在"
	Quit:'$d(^PAADM(EpisodeID)) MrNo ;就诊不存在
	
	Set ErrMsg = "-3:非住院病人"
	Set AdmType=$p(^PAADM(EpisodeID),"^",2)
	Quit:AdmType'="I" MrNo  ;非住院病人
	
	Set ErrMsg = "-4:病案卷不存在"
	Set xVolID=0,VolID=""
	For {
		Set xVolID=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,xVolID))
		Quit:xVolID=""
		Quit:VolID'=""
		
		Set IsActive=$p(^DHCWMRVOL(xVolID),"^",7)
		Continue:IsActive'="Y"
		Set VolID=xVolID
	}
	Quit:VolID="" MrNo
	
	Set ErrMsg = "-5:无效病案"
	Set MainID=$p(^DHCWMRVOL(VolID),"^",1)
	Set IsActive=$p(^DHCWMRMAIN(MainID),"^",6)
	Quit:IsActive="N" MrNo ;无效病案
	
	Set ErrMsg="-6:病案号为空"
	Set MrNo=$p(^DHCWMRMAIN(MainID),"^",2)
	Quit:MrNo="" MrNo
	
	//更新PA_PatMas.PAPMI_Medicare字段
	Set PatientID=$p(^PAADM(EpisodeID),"^",1)
	Set xMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(PatientID)
	If xMrNo'=MrNo {
		Set flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,PatientID)
	}
	
	Set ErrMsg = ""
	Quit MrNo
	
GetIPMrNoByAdmErr
    Set ErrMsg = $ZE
    Quit MrNo
}

/// w ##class(web.DHCWMRService).GetNewBabyMrNo(125)
ClassMethod GetNewBabyMrNo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.OutService).GetNewBabyMrNo(aEpisodeID,"")
		quit return
	}
    
	Set MrNo=""
	Quit:aEpisodeID="" MrNo
	
	//母亲分娩记录对应就诊号
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set MotherDr=$p($g(^PAADM(aEpisodeID)),"^",75)
	Quit:MotherDr="" MrNo
	Set MotherPatID=$p($g(^PAADM(MotherDr)),"^",1)
	
	Set MotherMrNo=""
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMRVOL(0,"PaadmDr",MotherDr,xVolID))
		Quit:xVolID=""
		Continue:MotherMrNo'=""
		
		Set IsActive=$p($g(^DHCWMRVOL(xVolID)),"^",7)
		Continue:IsActive'="Y"
		Set MainID=+$p($g(^DHCWMRVOL(xVolID)),"^",1)
		Set IsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)
		Continue:IsActive'="Y"
		
		Set MotherMrNo=$p($g(^DHCWMRMAIN(MainID)),"^",2)
	}
	Quit:MotherMrNo="" MrNo
	
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set BabyPatList=""
	Set xMotherAdmID=""
	For {
		Set xMotherAdmID=$o(^PAPERdr(MotherPatID,"ADM","I",xMotherAdmID))
		Quit:xMotherAdmID=""
		Quit:MrNo'=""
		
		Set VisitStatus=$p($g(^PAADM(xMotherAdmID)),"^",20)
		Continue:VisitStatus="C"  //取消就诊
		
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi("Mother",xMotherAdmID,xEpisodeID))
			Quit:xEpisodeID=""
			Quit:MrNo'=""
			
			//Set VisitStatus=$p($g(^PAADM(xEpisodeID)),"^",20)
			//Continue:VisitStatus="C"  //取消就诊
			Set MotherDr=$p($g(^PAADM(xEpisodeID)),"^",75)
			Continue:MotherDr=""      //非分娩记录全部过滤掉
			
			Set PatientDr=$p($g(^PAADM(xEpisodeID)),"^",1)
			Continue:$listfind(BabyPatList,PatientDr)>0
			Set BabyPatList=BabyPatList_$lb(PatientDr)
			Continue:PatientDr'=PatientID
			
			Set Number=$listfind(BabyPatList,PatientID)
			Set MrNo=MotherMrNo_$e("ABCDEFGHIJKLMN",Number,Number)
		}
	}
	
	Quit MrNo
}

/// Creator：    刘学峰
/// CreatDate：  2009-01-13
/// Service User:电子病历组
/// Description：提供出院患者信息是否有编目状态信息,返回给电子病历组
/// Table：      DHC_WMR_VolAdm,DHC_WMR_FrontPage
/// Input：      EpisodeID：住院就诊PAADM RowID
/// Return：     “”、"N"或“Y”。如果EpisodeID对应的患者已完成编目，则返回“Y”，否则返回“N”
/// Debug:       w ##class(web.DHCWMRService).IGetFPStatus(EpisodeID)
ClassMethod IGetFPStatus(EpisodeID)
{
	n (EpisodeID)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetFPStatus(EpisodeID)
		quit return
	}
	
	s ret="N"
	q:EpisodeID="" ""
	
	s VolRowid=0,FPFlg=0,MainVolID=""
	f  s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",EpisodeID,VolRowid)) q:(VolRowid="")||(FPFlg=1)  d
	.s MainVolIsActive=$p($g(^DHCWMRVOL(VolRowid)),"^",7)
	.q:MainVolIsActive'="Y"
	.s FPFlg=1
	.s MainVolID=VolRowid
	q:MainVolID="" ret
	
	s FPRowId=""
	s FPRowId=$o(^DHCWMRFP(0,"VolumeDr",MainVolID,FPRowId))
	s:FPRowId'="" ret="Y"
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-02-04
/// Service User:计费组
/// Description：根据病案类型(MrTypeDr)和病案号(MrNo)取住院次数
/// Table：      DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：      MrTypeDr:病案类型指针,(妇产医院MrTypeDr参数:6 门诊病案(东);7 住院病案(东);100 门诊病案(西);101 住院病案(西))
///              MrNo:病案号
/// Return：     -1或住院次数。如果MrTypeDr或MrNo为空，返回-1
/// Debug:       w ##Class(web.DHCWMRService).IGetIPCount(MrTypeDr,MrNo)
ClassMethod IGetIPCount(MrTypeDr, MrNo)
{
    n (MrTypeDr,MrNo)
    
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).IGetIPCount(MrTypeDr,MrNo)
		quit return
	}
    
    s IPCount=0
    q:MrTypeDr="" -1
    q:MrNo="" -1
    s MrNo=$tr(MrNo," ","")
    s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))
    ;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
    s MainRowid=""
    s MainRowid=$o(^DHCWMRMAIN(0,"TypeNO",+MrTypeDr,MrNo,MainRowid))
    q:MainRowid="" IPCount
    ;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
    q:'$d(^DHCWMRVOL(0,"Main",+MainRowid)) IPCount
    s VolRowid=0
    f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid))  q:VolRowid=""  d
    .s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    .q:Active'="Y"
    .s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    .s:IPCount<Count IPCount=Count
    q IPCount
}

}
