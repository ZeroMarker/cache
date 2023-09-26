Import SQLUser

/// 名称: 	  DHCWMRGroupReceipt
/// 描述: 	  集团化分号接诊程序
/// 编写者：  刘学峰
/// 编写日期: 2010-02-05
Class web.DHCWMRGroup.DHCWMRGroupReceipt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    刘学峰
/// CreatDate：  2010-02-05
/// Description：集团化接诊方法
/// Input：      EpisodeID：住院就诊EpisodeID RowID
/// Return：     ret>0,返回VolRowid;ret<0,错误
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GroupReceipt("230","77292","12150001","641","I")
ClassMethod GroupReceipt(CTLocID, EpisodeID, MrNo, UserId, AdmTypeCode)
{
	n (CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s parameter="CTLocID:"_CTLocID_"&EpisodeID:"_EpisodeID_"&MrNo:"_MrNo_"&UserId:"_UserId_"&AdmTypeCode:"_AdmTypeCode
	s saveRecLog=..SaveRecLog("In",1,parameter)
	;s ^DHCWMRGroupReceipt(0)=$lb(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s ret=-100.1
	s MrType=7   //..GetGroupMrType(CTLocID,AdmTypeCode)
	q:MrType'>0 ret
	//获取病案分号主导方式(V为卷主导,空或M为病案主导)
	s LeadingFactor=..GetLeadingFactor(MrType)
	;s ^CacheTemp("DDDDD")=CTLocID_"||"_EpisodeID_"||"_MrNo_"||"_UserId_"||"_AdmTypeCode
	b ;LeadingFactor
	i (LeadingFactor="V") d
	.s ret=..GroupReceiptVolume(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	e  d
	.s ret=..GroupReceiptMain(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)

	q ret
}

/// Creator：    刘宇辉
/// CreatDate：  2012-09-03
/// Description：住院病案自动接诊方法
/// Input：      UserId : 住院登记用户ID
/// Table：      DHC_WMR_Main,DHC_WMR_No
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).AutoReceipt("2012-08-01","2012-08-31","")
ClassMethod AutoReceipt(DateFrom As %String, DateTo As %String, UserId As %String) As %String
{
	n (DateFrom,DateTo,UserId)	
	
	s $zt="GetReturnInfoErr"
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	
	f AdmDate=DateFrom:1:DateTo d
    .s Paadm=0
	.f  s Paadm=$o(^PAADMi("PAADM_AdmDate",AdmDate,Paadm)) q:Paadm=""  d
	..s AdmInfo=$g(^PAADM(Paadm))
	..q:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	..q:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	..q:$d(DHCWMRVOL(0,"PaadmDr",Paadm)) 	//已经接诊患者过滤掉
	..s papmi=$p($g(^PAADM(Paadm)),"^",1)
	..q:papmi=""
	..s MrNo=##class(web.DHCWMRMedBaseCtl).GetHISMrNo(papmi,7)	//获取His病案号
	..i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
	...s MainID=""
	...f  s MainID=$o(^DHCWMRMAIN(0,"PAPMI",papmi,MainID)) q:MainID=""  d
	....s IsActive=$p(^DHCWMRMAIN(MainID),"^",6)
	....s:IsActive="Y" MrNo=$p(^DHCWMRMAIN(MainID),"^",2)
	..s ret=..GroupReceiptMain("",Paadm,MrNo,UserId,"")
	..s:ret<0 ^DHCWMRRECEIPT("AutoReceipt",+$h,Paadm)=""	//记录接诊失败患者
	
	q ""

GetReturnInfoErr
	Quit return
}

/// Creator：    刘学峰
/// CreatDate：  2010-07-21
/// Description：病案主导接诊方法
/// Table：      DHC_WMR_Main,DHC_WMR_No
/// Input：      EpisodeID：住院就诊EpisodeID RowID
/// Return：     ret>0,返回VolRowid;ret<0,错误
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GroupReceiptMain(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
ClassMethod GroupReceiptMain(CTLocID, EpisodeID, MrNo, UserId, AdmTypeCode)
{
	n (CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s ^DHCWMRGroupReceipt(0)=$lb(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s ret=-10.1
	s MrType=7    //..GetGroupMrType(CTLocID,AdmTypeCode)
	q:MrType'>0 ret
	s MrNo=$tr(MrNo," ","")
	s VolNo=""							;卷号,传入为空时，接诊使用就诊号
	s LeadingFactor=""					;主导标志,病案主导时为空即可
	s NoTypeStr=$g(^DHCWMRNOTYPE("NoFormat",MrType))
	;w "NoTypeStr="_NoTypeStr,!
	s AssignTypeID=$p(NoTypeStr,"^",11) //号码发放方式 DHC_WMR_Dictionary  A自动分号,M手工分号
	s AssignTypeCode=$p($g(^DHCWMRDIC(AssignTypeID)),"^",2)
	;w "AssignTypeCode="_AssignTypeCode,!
	//手工分号
	if (AssignTypeCode="Manual")
	{
		s ret=-10.3
		q:MrNo="" ret
		s ret=..ReceiptByReg(MrType,EpisodeID,MrNo,UserId,VolNo,LeadingFactor)
	}	
	//自动分号--分两种情况:a、传入病案号不为空(非初次就诊或者有历史病案号数据)
	elseif ((AssignTypeCode="Auto")&&(MrNo'=""))
	{
		s ret=..ReceiptByReg(MrType,EpisodeID,MrNo,UserId,VolNo,LeadingFactor)	
	}
	//自动分号--b、传入病案号为空
	elseif ((AssignTypeCode="Auto")&&(MrNo=""))
	{
		;根据papmi查询病案信息
		s ret=10.4
		s papmi=+$p($g(^PAADM(EpisodeID)),"^",1)
		s pMainID=0,pMrNo=""
		i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
		.s mainRowid=""
		.s findMainFlag="N"
		.f  s mainRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,mainRowid),-1) q:(mainRowid="")||(findMainFlag="Y")  d
		..s Type=$p($g(^DHCWMRMAIN(mainRowid)),"^",1)
		..q:Type'=MrType          ;病案类型不一致
		..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
		..q:Active'="Y"
		..s findMainFlag="Y"
		..s pMainID=mainRowid
		..s pMrNo=$p($g(^DHCWMRMAIN(pMainID)),"^",2)

		if (pMainID>0)  {
			;s ^LXFReceipt(MrType,EpisodeID,pMrNo,UserId)=""
			s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,LeadingFactor)
		}else{
			;^DHCWMRNO(0,"TypeActive",{MrType_Dr},{IsActive},{Rowid})
			//首先使用DHC_WMR_No表中可用病案号
			s CurrNoEmptyFlag="N"
			i $d(^DHCWMRNO(0,"TypeActive",MrType,"Y"))  d
			.s NoRowID=$o(^DHCWMRNO(0,"TypeActive",MrType,"Y",""))
			.s pMrNo=$p($g(^DHCWMRNO(NoRowID)),"^",2)
			.;w "pMrNo="_pMrNo
			.;s ^LXFReceipt(MrType,EpisodeID,pMrNo,UserId)=""
			.s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,LeadingFactor)
			e  d
			.s MaxMrNo=$g(^DHCWMRNOTYPE("CurrentNo",MrType))
			.;w "MaxMrNo="_MaxMrNo,!
			.s:MaxMrNo="" CurrNoEmptyFlag="Y"
			.q:MaxMrNo=""
			.s CurrentNo=MaxMrNo+1
			.s ^DHCWMRNOTYPE("CurrentNo",MrType)=CurrentNo
			.s pMrNo=##class(web.DHCWMRMedBaseCtl).FormatMrNo(MrType,CurrentNo)
			.s pMrNo=..GetRightOfMrNo(pMrNo,MrType)
			.s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,LeadingFactor)
			.;s:ret>0 ^DHCWMRNOTYPE("CurrentNo",MrType)=CurrentNo
			/*
			.//接诊错误日志 add 2010-03-17
			.i ret<0  d
			..s ErrorIndex=$o(^DHCWMRRecErr("Main",""),-1)
			..s:ErrorIndex="" ErrorIndex=0
			..s ErrorIndex=ErrorIndex+1
			..s ^DHCWMRRecErr("Main",ErrorIndex,$zd(+$h,3))="MrType="_MrType_";EpisodeID="_EpisodeID_";pMrNo="_pMrNo_";UserId="_UserId_";ret="_ret
			*/
			q:CurrNoEmptyFlag="Y" -10.5
		}
	}
	q ret
}

/// Debug:w ##Class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetRightOfMrNo(554009,7)
ClassMethod GetRightOfMrNo(MrNo As %String, MrType As %String)
{
	New (MrNo,MrType)
	Set Rtn="",IsUsed="true",CurrNo=MrNo
	Set IsUsed=..IsUsed(CurrNo,MrType)
	While(IsUsed="true"){
		Set CurrMaxNo=+$g(^DHCWMRNOTYPE("CurrentNo",MrType))+1
		Set CurrNo=##class(web.DHCWMRMedBaseCtl).FormatMrNo(MrType,CurrMaxNo)
		Set ^DHCWMRNOTYPE("CurrentNo",MrType)=CurrMaxNo
		;b ;11
		Set IsUsed=..IsUsed(CurrNo,MrType)
	}
	Quit CurrNo
}

/// Debug:w ##Class(web.DHCWMRGroup.DHCWMRGroupReceipt).IsUsed(554009,7)
ClassMethod IsUsed(MrNo As %String, MrType As %String)
{
	New (MrNo,MrType)
	Set Rtn="false",IsUsedOfPaPatMas="false",IsUsedOfMain="false",IsUsedOfNo="false"
	
	Set:$d(^PAPERi("Medicare1",$ZCVT(MrNo,"U"))) IsUsedOfPaPatMas="true"       ;病人基本信息病案号已存在
	Set:$d(^DHCWMRMAIN(0,"TypeNO",MrType,$ZCVT(MrNo,"U"))) IsUsedOfMain="true" ;病案卷表病案号已存在
	Set:$d(^DHCWMRNO(0,"TypeNo",MrType,$ZCVT(MrNo,"U"))) IsUsedOfNo="true"     ;病案号表病案号已存在
	Set:(IsUsedOfPaPatMas="true")||(IsUsedOfMain="true")||(IsUsedOfNo="true") Rtn="true" 
	Quit Rtn
}

/// Creator：    刘学峰
/// CreatDate：  2010-02-05
/// Description：卷主导接诊方法
/// Table：      DHC_WMR_Main,DHC_WMR_No
/// Input：      EpisodeID：住院就诊EpisodeID RowID
/// Return：     ret>0,返回VolRowid;ret<0,错误
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GroupReceiptVolume(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
ClassMethod GroupReceiptVolume(CTLocID, EpisodeID, MrNo, UserId, AdmTypeCode)
{
	n (CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s ^DHCWMRGroupReceipt(0)=$lb(CTLocID,EpisodeID,MrNo,UserId,AdmTypeCode)
	s ret=-20.1
	s MrType=7   //..GetGroupMrType(CTLocID,AdmTypeCode)
	q:MrType'>0 ret
	s MrNo=$tr(MrNo," ","")
	
	;根据papmi查询病案信息
	s ret=20.4
	s papmi=+$p($g(^PAADM(EpisodeID)),"^",1)
	s pMainID=0,pMrNo=""
	i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
	.s mainRowid=""
	.s findMainFlag="N"
	.f  s mainRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,mainRowid),-1) q:(mainRowid="")||(findMainFlag="Y")  d
	..s Type=$p($g(^DHCWMRMAIN(mainRowid)),"^",1)
	..q:Type'=MrType          ;病案类型不一致
	..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
	..q:Active'="Y"
	..s findMainFlag="Y"
	..s pMainID=mainRowid
	..s pMrNo=$p($g(^DHCWMRMAIN(pMainID)),"^",2)
	
	s AssignTypeCode=..GetAssignType(MrType)  ;$p($g(^DHCWMRDIC(AssignTypeID)),"^",2)
	if (AssignTypeCode="Manual"){
		//**********手动分配病案号*************
		s ret=-10.3	
		q:MrNo="" ret
		s VolNo=MrNo  
		;s pMrNo=MrNo            ;卷病案号和病案号是同一个号
		s:pMrNo="" pMrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)  ;取登记号
		s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,"V")
		//********手动分配病案号结束*************
	}
	elseif (AssignTypeCode="Auto"){
	       //********自动分配病案号开始************
	       ;^DHCWMRNO(0,"TypeActive",{MrType_Dr},{IsActive},{Rowid})
	       //首先使用DHC_WMR_No表中可用卷号
	       s CurrNoEmptyFlag="N" //判断$g(^DHCWMRNOTYPE("CurrentNo",MrType)是否为空标志
	       if ($d(^DHCWMRNO(0,"TypeActive",MrType,"Y"))) {
	           s NoRowID=$o(^DHCWMRNO(0,"TypeActive",MrType,"Y",""))
	           s VolNo=$p($g(^DHCWMRNO(NoRowID)),"^",2)
	       }else {
	           s MaxVolNo=$g(^DHCWMRNOTYPE("CurrentNo",MrType))
	           ;w "MaxVolNo="_MaxVolNo,!
	           s:MaxVolNo="" CurrNoEmptyFlag="Y"
	           q:MaxVolNo=""
	           s CurrentNo=MaxVolNo+1
	           s ^DHCWMRNOTYPE("CurrentNo",MrType)=CurrentNo
	           s VolNo=##class(web.DHCWMRMedBaseCtl).FormatMrNo(MrType,CurrentNo)
	           Set VolNo=..GetRightOfMrNo(VolNo,MrType)
	       }
	       q:CurrNoEmptyFlag="Y" -20.5
	       if (pMainID>0)  
	       {
		       s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,"V")
	       }else{
		       //获取登记号
		       s PAPMINo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		       //以登记号作为病案号
		       s pMrNo=PAPMINo
		       s ret=..ReceiptByReg(MrType,EpisodeID,pMrNo,UserId,VolNo,"V")
		       ;s:ret>0 ^DHCWMRNOTYPE("CurrentNo",MrType)=CurrentNo
		       /*
		       //接诊错误日志 add 2010-03-17
		       i ret<0  d
		       .s ErrorIndex=$o(^DHCWMRRecErr("Vol",""),-1)
		       .s:ErrorIndex="" ErrorIndex=0
		       .s ErrorIndex=ErrorIndex+1
		       .s ^DHCWMRRecErr("Vol",ErrorIndex,$zd(+$h,3))="MrType="_MrType_";EpisodeID="_EpisodeID_";pMrNo="_pMrNo_";UserId="_UserId_";ret="_ret_";VolNo="_VolNo
		       */
		       q:CurrNoEmptyFlag="Y" -20.5
	       }
	 //********自动分配病案号结束************
	}
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2010-02-05
/// Description：接诊方法
/// Table：      DHC_WMR_Main, DHC_WMR_MainVolume, DHC_WMR_No
/// Input：      EpisodeID：住院就诊EpisodeID RowID
/// Return：     “”、"N"或“Y”。如果EpisodeID对应的患者已完成编目，则返回“Y”，否则返回“N”
/// Debug:       w ##class(web.DHCWMRService).IGetFPStatus(EpisodeID)
ClassMethod ReceiptByReg(MrType, paadm, RegMrNo, UserId, VolNo, LeadingFactor)
{
	n (MrType,paadm,RegMrNo,UserId,VolNo,LeadingFactor)
	s ^CacheTempWMR("ReceiptByReg")=MrType_","_paadm_","_RegMrNo_","_UserId
	s NameSpell=""
	s ret=-1
	q:$p($g(^PAADM(+paadm)),"^",75)'="" 1    //婴儿不建病案
	q:(MrType="")||(paadm="") ret
	q:'$d(^PAADM(paadm)) ret
	
	q:RegMrNo="" ret
	
	
	//已经建病案,不再重复建病案
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    s TMPVolId=0,TMPFlg=0
    f  s TMPVolId=$o(^DHCWMRVOL(0,"VolAdm",paadm,TMPVolId)) q:((TMPVolId="")||((+TMPFlg)>0))  d
    .s TMPVol=$g(^DHCWMRVOL(TMPVolId))
    .q:$p(TMPVol,"^",7)'="Y"
    .s TMPFlg=TMPVolId
    q:(+TMPFlg)>0 +TMPFlg
	
	s papmi=+$p($g(^PAADM(paadm)),"^",1)
	s patcond=""
	s MainRowid=""
	s ctloc=+$p($g(^SSU("SSUSR",UserId)),"^",4)
	s OldNo=$$ALPHAUP^SSUTIL4(RegMrNo)
	
	
	;取流的第一个操作项目
	s ret=-1.1
	s ItemDr=$$GetWorkFlow(MrType)
	q:ItemDr="" ret
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	s MrNo="",NoFlag=0
	
	;1、根据papmi查询病案信息
	s ret=-2.1
	s pMain="",pMrNo=OldNo
	i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
	.s mainRowid=0
	.f  s mainRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,mainRowid)) q:mainRowid=""  d
	..s Type=$p($g(^DHCWMRMAIN(mainRowid)),"^",1)
	..q:Type'=MrType          ;病案类型不一致
	..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
	..q:Active'="Y"
	..s pMain=mainRowid
	..s pMrNo=$p($g(^DHCWMRMAIN(pMain)),"^",2)
	..;s OldNo=pMrNo
	;s ^CacheTempWMR("ReceiptByReg",2)="pMrNo="_pMrNo_";OldNo="_OldNo
	q:pMrNo'=OldNo ret
	
	;2、根据MrNo查询病案信息   ^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	s ret=-2.2
	s mMain="",mPapmi=papmi
	i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	.s mainRowid=0
	.f  s mainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo,mainRowid)) q:mainRowid=""  d
	..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
	..q:Active'="Y"
	..s mMain=mainRowid
	..s mPapmi=+$p($g(^DHCWMRMAIN(mMain)),"^",3)
	q:mPapmi'=papmi ret
	
	;校准
	s ret=-2.3
	q:(pMain'=mMain) ret
	s MainRowid=mMain
	
	
	Tstart
	if (LeadingFactor="V")
	{
		;记录卷号码发放
		s ret=-2.4
		i $d(^DHCWMRNO(0,"TypeNo",MrType,VolNo)) d
		.s WMRNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,VolNo,""),-1)
		.s sWMRNo=##class(web.DHCWMRNoCtl).GetDataById(+WMRNoRowid)
		.i $p(sWMRNo,"^",4)="N" d
		..s:MainRowid="" NoFlag=-2222     ;已经用完 不可再用
		.e  d
		..s $p(sWMRNo,"^",4)="N"
		..s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
		..s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
		..s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
		..s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
		..s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
		..i NoFlag<0 TRollBack
		..s MrNo=VolNo
		e  d
		.s ret=-2.5             ;分配一个未入库的历史号码
		.s sWMRNo=""
		.s $p(sWMRNo,"^",2)=MrType	      ;病案类型
		.s $p(sWMRNo,"^",3)=VolNo	      ;病案号
		.s $p(sWMRNo,"^",4)="N"	      ;是否有效
		.s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
		.s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
		.s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
		.s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
		.s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
		.i NoFlag<0 TRollBack
		q:NoFlag<0 ret
		s MrNo=RegMrNo
	}else{
		;记录病案号码发放
		s ret=-2.4
		i $d(^DHCWMRNO(0,"TypeNo",MrType,OldNo)) d
		.s WMRNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,OldNo,""),-1)
		.s sWMRNo=##class(web.DHCWMRNoCtl).GetDataById(+WMRNoRowid)
		.i $p(sWMRNo,"^",4)="N" d
		..s:MainRowid="" NoFlag=-2222     ;已经用完 不可再用
		.e  d
		..s $p(sWMRNo,"^",4)="N"
		..s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
		..s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
		..s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
		..s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
		..s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
		..i NoFlag<0 TRollBack
		..s MrNo=OldNo
		e  d
		.s ret=-2.5             ;分配一个未入库的历史号码
		.s sWMRNo=""
		.s $p(sWMRNo,"^",2)=MrType	      ;病案类型
		.s $p(sWMRNo,"^",3)=OldNo	      ;病案号
		.s $p(sWMRNo,"^",4)="N"	      ;是否有效
		.s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
		.s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
		.s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
		.s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
		.s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	
		.i NoFlag<0 TRollBack
		.s MrNo=OldNo
		q:NoFlag<0 ret
	}
	s ret=-3
	;生成病案信息
	i MainRowid="" d
	.s sMain=""
	.s $p(sMain,"^",2)=MrType
	.s $p(sMain,"^",3)=MrNo
	.s $p(sMain,"^",4)=papmi
	.s $p(sMain,"^",7)="Y"
	.s $p(sMain,"^",8)="Y"
	e  d
	.s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	.s MrNo=$p(sMain,"^",3)
	i sMain="" TRollBack
	q:sMain="" ret
	s ret=-3.1
	s $p(sMain,"^",4)=papmi
	s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	i +MainRowid<0 TRollBack
	q:+MainRowid<0 ret
	
	s ret=-3
	;生成卷信息
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=..GetIPCount("",MainRowid)
	
	//add by liuxuefeng 2010-06-21 增加生成卷号程序
	i VolNo="" d
	.s ADMNo=$p($g(^PAADM(+paadm)),"^",81)
	.s VolNo=ADMNo		;默认设置就诊号为卷号
	//或者使用^DHCWMRNOTYPE("CurrVolNo",AdmType)=
	s $p(sVolume,"^",11)=VolNo
	//////////////////// End //////////////////////
	
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
	
	s ret=-7
	s flag=0
	;更新入院时情况(病人入院状态--平稳/病重/病危)
	s:patcond'="" flag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(paadm,patcond)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	s ret=-8
	;更新病案号
	s flag=0
		
	s AssignTypeCode=..GetAssignType(MrType) 
	if (LeadingFactor="V"){
		s MrNo=VolNo
	}
	/*
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

/// 取住院次数
/// w ##Class(web.DHCWMRReceipt).GetIPCount(IPCount,MainRowid)
ClassMethod GetIPCount(IPCount, MainRowid)
{
    n (IPCount,MainRowid)
    if +IPCount>0 d      ;如果录入第几次住院，取录入的数据
    .s IPCount=+IPCount
    e  d
    .;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})   ;未录入，且无历史，默认为首次住院
    .if '$d(^DHCWMRVOL(0,"Main",+MainRowid)) s IPCount=1
    .e  d
    ..s VolRowid=0,IPCount=0      ;未录入，取所有卷中第一次住院中最大数，加1
    ..f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid))  q:VolRowid=""  d
    ...s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    ...q:Active'="Y"
    ...s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    ...s:IPCount<Count IPCount=Count
    ..s IPCount=IPCount+1
    
    q IPCount
}

/// *****************************************************************
/// 事务           :  GroupUnReceipt
/// 功能描述       ： 住院登记退院
///                   检查paadm是否已取消
///                   修改卷状态  IsActive=N
/// 入参           ：
///   Paadm        :  EpisodeId
///   RecUserId    :  取消接诊操作人
/// 返回值         ： ret=0 成功    ret<0 失败
/// *****************************************************************
ClassMethod GroupUnReceipt(Paadm, RecUserId)
{
	n (Paadm, RecUserId)
	s ret=-1
	q:Paadm="" ret
	q:$p($g(^PAADM(+Paadm)),"^",75)'="" 0    //婴儿不建病案
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	
	s ret=0
	//已经取消病案,不再重复取消病案
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    s TMPVolId=0,TMPFlg=0
    f  s TMPVolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,TMPVolId)) q:((TMPVolId="")||((+TMPFlg)>0))  d
    .s TMPVol=$g(^DHCWMRVOL(TMPVolId))
    .q:$p(TMPVol,"^",7)'="Y"
    .s TMPFlg=TMPVolId
    q:(+TMPFlg)=0 ret
	
	s ret=-1
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr}
	s RecLocId=+$p($g(^SSU("SSUSR",RecUserId)),"^",4)
	s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,""),-1)
	
	s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	q:sVol="" ret
	s MainRowid=+$p(sVol,"^",2)
	q:MainRowid'>0 ret
	s xVolId=+VolRowid
	//add 2010-07-21 获取卷号
	s VolNo=$p(sVol,"^",11)
	
	
	s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s MrType=$p(sMrMain,"^",2)
	s xPapmi=$p(sMrMain,"^",4)
	
	//取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	//add 2009-06-30 获取是否取消病案号设置
	s MrNoCancelFlag=$p(strMrType,"^",6)
	//add 2010-07-21 获取分号主导方式
	s LeadingFactor=..GetLeadingFactor(MrType)
	//获取是否释放卷号(是否重用取消卷的卷号)
	s IsReuseVolNo=$p(strMrType,"^",15)
	
	Tstart
	s ret=-2
	//取消卷
	s $p(sVol,"^",7)=+$p(sVol,"^",7)
	s $p(sVol,"^",8)="N"
	s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVol)
	i +flag<0 TRollBack
	q:+flag<0 ret
	
	//add 2010-07-21 如果为卷主导,且释放病案号,则取消号码分配
	i (LeadingFactor="V")&&(IsReuseVolNo="Y") d
	.s NoFlag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,VolNo)
	.i +NoFlag<0 d
	..TRollBack
	
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


    ;Modify 2010-07-21 如果MrNoCancelFlag为“Y”，且无剩余有效卷,且分号方式不为卷主导,则取消病案号
    if ((MrNoCancelFlag="Y")&&(ActiveFlag="")&&(LeadingFactor'="V"))
    {
		s ret=-3
		;取消病案
	    s $p(sMain,"^",7)="N"      ;无有效卷 取消main
	    ;s:PapmiFlag="" $p(sMain,"^",4)=""        ;无相同papmi
	    s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	    i +MainRowid<0 d
		.TRollBack
	    q:+MainRowid<0 ret
	    
	    s MainFlag=0
		s ret=-4
		;取消号码分配
		s NoFlag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,MrNo)
		i +NoFlag<0 d
		.TRollBack
		.s MainFlag=-1
		q:MainFlag<0 ret
		
		;add by liuxuefeng 2009-06-30 取消病案号时，将病案基本信息中对应病案号置空
		s ret=-8
		;更新病案号
		s flag=0	
		s MrNoEmpty=""
		;paperson.paper_governcardno
		s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNoEmpty,papmi)
		;PA_PatMas.PAPMI_Medicare
		s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode1
		s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode2
		s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNoEmpty,papmi)
		i flag'=0 TRollBack
		q:flag'=0 ret
    }
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
/// CreatDate：  2010-02-05
/// Description：通过登录科室和就诊类型查找病案类型
/// Table：      DHC_WMR_NoType
/// Input：      EpisodeID：住院就诊EpisodeID RowID
/// Return：     ret>0,返回MrType;ret<0,错误
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetGroupMrType(CTLocID,AdmTypeCode)
ClassMethod GetGroupMrType(CTLocID, AdmTypeCode)
{
	n (CTLocID,AdmTypeCode)
	s ret=-1
	q:(CTLocID="")||(AdmTypeCode="") ret
	s ret=-2
	s HospitalID=##class(web.DHCWMRMedBaseCtl).GetHospitalDRByCTLocID(CTLocID)
	q:+HospitalID=0 ret
	s AdmTypeID=$o(^DHCWMRDIC(0,"DicNameCode","AdmType",AdmTypeCode,"")) //就诊类型字典ID
	;w "AdmTypeID="_AdmTypeID,!
	s ret=-3
	q:AdmTypeID="" ret
	s MrType=""
	
	;^DHCWMRNOTYPE(0,"HospitalAdmType",{HospitalID},{AdmType},{Rowid})
	s MrType=$o(^DHCWMRNOTYPE(0,"HospitalAdmType",HospitalID,AdmTypeID,MrType))
	s ret=-4
	q:+MrType=0 ret	
	q MrType
}

/// Creator：    刘学峰
/// CreatDate：  2010-07-21
/// Description：根据病案类型，获取分号主导方式
/// Table：      DHC_WMR_NoType
/// Input：      MrType
/// Return：     ret>0,返回LeadingFactor;ret<0,错误
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
ClassMethod GetLeadingFactor(MrType)
{
	n (MrType)
	q:+MrType=0 -200
	s LeadingFactor=$p($g(^DHCWMRNOTYPE("NoFormat",MrType)),"^",14)
	s LeadingFactor=$ZCVT(LeadingFactor,"U")
	q LeadingFactor
}

ClassMethod GetAssignType(MrType)
{
	n (MrType)
	s NoTypeStr=$g(^DHCWMRNOTYPE("NoFormat",MrType))
	s AssignTypeID=$p(NoTypeStr,"^",11) //号码发放方式 DHC_WMR_Dictionary  A自动分号,M手工分号
	s AssignTypeCode=$p($g(^DHCWMRDIC(AssignTypeID)),"^",2)	
	q AssignTypeCode
}

/// Creator：    刘学峰
/// CreatDate：  2010-09-26
/// Description：保存“接诊/取消接诊”错误日志
/// Table：      无
/// Input：      type:节点类型；errRet:错误返回值；parameter节点值字符串
/// Return：     1
/// Debug:       w ##class(web.DHCWMRGroup.DHCWMRGroupReceipt).SaveRecLog(type, errRet , parameter)
ClassMethod SaveRecLog(type, errRet, parameter)
{
	n (type, errRet , parameter)
	s ErrorIndex=$o(^DHCWMRRecErr(type,""),-1)
	s:ErrorIndex="" ErrorIndex=0
	s ErrorIndex=ErrorIndex+1
	s ^DHCWMRRecErr(type,ErrorIndex,$zd(+$h,3),+errRet)=parameter
	q 1
}

}
