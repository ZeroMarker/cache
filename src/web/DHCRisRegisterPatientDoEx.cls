Import SQLUser

/// liao333@tom.com
/// 程序名DHCRisRegisterPatientDo 病人登记
Class web.DHCRisRegisterPatientDoEx Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 208;

/// 函数名称：GetSelRegInfo
/// 功能：根据OEorditem.Rowid获得病人登记信息,没有登记则返回要登记的信息
/// 输入参数：OEorditem.Rowid
/// 返回：登记的信息
/// 作者：龚平
/// 日期：2007-03-05
/// d ##class(web.DHCRisRegisterPatientDoEx).GetSelRegInfo("19216||12","19218")
ClassMethod GetSelRegInfo(oeorditemrowid, paadmdr, gbodyinfo As %String = "") As %String
{

  n (oeorditemrowid, paadmdr,gbodyinfo)
  s (GetstrRegDate,GetstrRegTime,GetIndex,GetEQDesc,GetEQDr,GetMainDoc,GetAssDoc)=""
  s (GetRoomDesc,GetRoomDr,GetEQGroupDesc,GetEQGroupDR,NO,MainDr,AssDocDR,BodyPart,Num,ReportInfo,PrintItem,strRegDate4,GroupIndex,RoomIndex,Urgent)=""
  s (AppRowid)=""
  s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
  s GetRegNo=$p(PatInfo,"^",1)
  s GetName=$p(PatInfo,"^",2)
  s GetstrDOB=$p(PatInfo,"^",3)
  s Weight=$p(PatInfo,"^",21)
  s TelNo=$p(PatInfo,"^",19)
  s TelNo=..TrimVal(TelNo)
  
  s IPNO=$p(PatInfo,"^",9)
  s IPNO=..TrimVal(IPNO)
  
  s Type=$p(PatInfo,"^",6)
  s LocName=$p(PatInfo,"^",8)
  
  s OPNO=$p(PatInfo,"^",32)
  s OPNO=..TrimVal(OPNO)
  
  s BedCode=$p(PatInfo,"^",11)
  i (oeorditemrowid'="") 
  {
	  s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemrowid,0))
	  i AppRowid'="" d 
	  .s Urgent=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
  }
  
  s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemrowid,gbodyinfo)
  s GetStudyNo=$p(RegInfo,"^",1)
  i GetStudyNo'="" d
  .s GetstrRegDate=$p(RegInfo,"^",2)
  .s GetstrRegTime=$p(RegInfo,"^",3)
  .s GetIndex=$p(RegInfo,"^",4)
  .s GetEQDesc=$p(RegInfo,"^",5)
  .s GetEQDr=$p(RegInfo,"^",10)
  .s GetMainDoc=$p(RegInfo,"^",6)
  .s GetAssDoc=$p(RegInfo,"^",7)
  .s GetRoomDesc=$p(RegInfo,"^",8)
  .s GetRoomDr=$p(RegInfo,"^",9)
  .s GetEQGroupDesc=$p(RegInfo,"^",11)
  .s GetEQGroupDR=$p(RegInfo,"^",12)
  .s NO=$p(RegInfo,"^",13)
  .s MainDr=$p(RegInfo,"^",15)
  .s AssDocDR=$p(RegInfo,"^",16)
  .s BodyPart=$p(RegInfo,"^",17)
  .s Num=$p(RegInfo,"^",18)
  .s ReportInfo=$p(RegInfo,"^",19)
  .s strRegDate4=$p(RegInfo,"^",20)
  .s Urgent=$p(RegInfo,"^",21)
  .s GroupIndex=$p(RegInfo,"^",22)
  .s RoomIndex=$p(RegInfo,"^",23)
  .s PrintItem=##class(web.DHCRisRegisterPatientDoEx).GetPrintItem(GetStudyNo)
  s Info=GetName_"^"_GetstrDOB_"^"_Weight_"^"_TelNo_"^"_IPNO_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_GetIndex_"^"_GetEQDesc_"^"_GetEQDr_"^"_GetMainDoc_"^"_MainDr_"^"_GetAssDoc_"^"_AssDocDR_"^"_GetRoomDesc_"^"_GetRoomDr_"^"_GetEQGroupDesc_"^"_GetEQGroupDR
  s Info1=NO_"^"_BodyPart_"^"_Num_"^"_ReportInfo_"^"_Type_"^"_LocName_"^"_OPNO_"^"_BedCode_"^"_PrintItem_"^"_strRegDate4_"^"_GroupIndex_"^"_RoomIndex_"^"_Urgent_"^"_GetStudyNo
  q Info_"^"_Info1
}

/// 函数名称：InsertRegInfo
/// 功能：插入或者修改病人的基本信息
/// 输入参数：Info:登记的基本信息,Bodynum:部位的个数,BodyInfo部位的信息
/// 返回：SQLCODE
/// -10001：此类型病人没有收费不允许登记！
/// -10002 ：传入登记函数就诊信息的与医嘱对应的就诊记录不一致，不能登记！
/// -10003：病人已经出院,不能登记！
/// -10004：病人已欠费,不能登记！
/// -10005：检查号重复不允许登记！
/// 作者：龚平
/// 日期：2007-03-05
/// s ret=##class(web.DHCRisRegisterPatientDoEx).InsertRegInfo(^TMP("RIS",5),^TMP("RIS",6),^TMP("RIS",7))
/// Info="^^^oeoriditemrowid^paadmrowid^^ssurid^766_45^^^^^^^^,"",""
/// S RET=##class(web.DHCRisRegisterPatientDoEx).InsertRegInfo(^t1,^t2,^t3)
/// s RET=##class(web.DHCRisRegisterPatientDoEx).InsertRegInfo(^tt,^tt1,^tt2)
ClassMethod InsertRegInfo(Info, bodyNum, BodyInfo As %String = "") As %String
{
	/*
	n (Info, bodyNum, BodyInfo)
	s ^tt=Info
	s ^tt1=bodyNum
	s ^tt2=BodyInfo
	
	s RegLOCDr=$p(Info,"^",7)
	s AssDocDr=$p(Info,"^",1)
	s MainDocDr=$p(Info,"^",2)
	s NoDR=$p(Info,"^",3)
	s MuitOEORIDr=$p(Info,"^",4)
	s paadr=$p(Info,"^",5)
	s RegEQDr=$p(Info,"^",6)
	s SSUSERDr=$p(Info,"^",8)
	s MuitStudyNo=$p(Info,"^",9)   ;检查号为空
	s Index=$p(Info,"^",10)
    s RoomDR=$p(Info,"^",11)
    s EQGroupDR=$p(Info,"^",12)
    s RegDate=$p(Info,"^",13)
 	s RegTime=$p(Info,"^",14)
	i RegTime="" d
	.s RegTime=$p($h,",",2)
	else  d
	.s RegTime=$zth(RegTime,3)
    s IpNo=$p(Info,"^",15)
    s TelNo=$p(Info,"^",16)
    s Weight=$p(Info,"^",17)
    s ReportInfo=$p(Info,"^",18)
    s InputRegDate=$p(Info,"^",19)
    s GroupIndex=$p(Info,"^",20)
    s RoomIndex=$p(Info,"^",21)
    s UgentFlag=$p(Info,"^",22)
    
    i RegDate="" d
	.i InputRegDate="" d
	..s RegDate=+$h
	.else  d
	..s RegDate=$zdh(InputRegDate,4)
	else  d
	.s RegDate=$zdh(RegDate,3)
	
	i paadr'="" d
	.s papatmasmdr=$p(^PAADM(paadr),"^",1)
	.s patienttype=$p($g(^PAADM(paadr)),"^",2) ;病人类型 
	.i papatmasmdr'="" d     
	..s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)  
    ..s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
    ..s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
    ..i SexDr'="" s SexDesc=$p($g(^CT("SEX",SexDr)),"^",2)
   
    
	s SQLCODE=0
	//先判断是不是同一个病人的医嘱
	s isSamePat=..isSamePatient(MuitOEORIDr)
	q:(isSamePat="N") "-11111"
	/  *
	s DRNum=$l(BodyInfo,"^")
	for DRN=1:1:DRNum
	.s BodylistDR=$p(BodyInfo,"^",DRN)
	.s OrditemRowid=$p(MuitOEORIDr,"@",1)
	.s IsBodyDR=##class(web.DHCRisTestPan).IsBodyDR(OrditemRowid,BodylistDR)
	q:(IsBodyDR="Y") "-11119" 
	*  /
	Trans
	Set $ZT="ERROR"	
    lock +(^DHCRisTMPReg)     
   
   
    ;有停止的医嘱不允许一起登记
    s Exist=""
    s Exist=##class(web.DHCRisCommFunctionEx).ExistStopItem(MuitOEORIDr)
    i Exist="Y" lock -(^DHCRisTMPReg)
    q:(Exist="Y") -10006
    
    s GetMaxIndexInfo="",IndexDataInfo="",IsUpdateIndex="Y",isUpdateCheckGroupIndex="N",isUpdateRoomIndex="N"
    s isUpdateRegDate="N"
	s GetMaxIndexInfo=RegLOCDr_"^"_Index_"^"_EQGroupDR_"^"_GroupIndex_"^"_RoomDR_"^"_RoomIndex_"^"_RegDate

	;获取最大的序号
	s IndexDataInfo=..GetMaxIndex(GetMaxIndexInfo)
	i IndexDataInfo'="" d
	.s Index=$p(IndexDataInfo,"^",1)
	.s GroupIndex=$p(IndexDataInfo,"^",2)
	.s RoomIndex=$p(IndexDataInfo,"^",3)
	
	s EQGroupDesc="",EQGroupDR=""
	if RegEQDr'="" d
	.s EQGroupInfo=##class(web.DHCRisCommFunction).GetEQGroup(RegEQDr)
    .s EQGroupDesc=$p(EQGroupInfo,"^",1)
    .s EQGroupDR=$p(EQGroupInfo,"^",2)
    
    // 医嘱对应的就诊记录是否一致
    s OEORIDr=$p(MuitOEORIDr,"@")
    s OrderID=$p(OEORIDr,"||",1)
    s GetPaadmID=$p(^OEORD(OrderID),"^",1)
    i (paadr'=GetPaadmID) lock -(^DHCRisTMPReg)
    q:paadr'=GetPaadmID -10002 
    
  
    //如有退费审核的话,则退出
	/ *s redr=""
	s redr=$o(^DHCORDItem(0,OEORIDr,0))
	q:redr'="" 100
	*  /
	//判断此病人是否出院
	s Status=$p(^PAADM(GetPaadmID),"^",20)
	i (Status="D") lock -(^DHCRisTMPReg)
	q:Status="D" -10003 
	
	 / *
    ; 调用计费组的函数， 病人
    s Arrearage=""
	s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(paadr,"A","完全控制")
	i (Arrearage="1") lock -(^DHCRisTMPReg)
	i Arrearage="1" q -10004
	* /
	;根据系统配置判断未收费的应允许一块进行登记
	s ret=##class(web.DHCRisRegisterPatientDoEx).AllowMutiOrditemRegister(MuitOEORIDr)
	i ret="N" lock -(^DHCRisTMPReg)  
	q:ret="N" -10001
    s RCODE=0

   TSTART
    //E:执行状态
    //根据传入的检查号， 在后台重新获取检查号，如果插入登记插入失败回滚更新的检查号
    s MuitOEORIDrIn=MuitOEORIDr
   
    s BodyInfoList=BodyInfo
    ;s MuitStudyNo=..GetMutiStudyNo(MuitOEORIDr,EQGroupDesc,RegLOCDr,InputRegDate,EQGroupDR)
   
    s MuitStudyNo=##class(web.DHCRisTestPan).GetMutiStudyNo(MuitOEORIDr,EQGroupDesc,RegLOCDr,InputRegDate,EQGroupDR,BodyInfoList)
    ;根据科室配置如果多条医嘱嘱产生一个检查号，会自动获取所有预约医嘱一起登记
    / *
    s RuleFlag="",RequestInfo="",hasSameOrder="Y"
    i RegLOCDr'="" d
    .s RuleFlag=..IsFindOtherBookItem(RegLOCDr)
    .i RuleFlag="Y" d
    ..s RequestInfo=..GetBookItembyStudyNo(MuitStudyNo)
    ..i RequestInfo'="" d
    ...s MuitOEORIDr=$p($g(RequestInfo),"^",1)
    ...s MuitStudyNo=$p($g(RequestInfo),"^",2)
    ...;查找是否有相同的医嘱记录
    ...s hasSameOrder=..hasSameRecord(MuitOEORIDrIn,MuitOEORIDr)
    ...;增加遗漏的未预约的医嘱
    ...i hasSameOrder="Y"  d
    ....s lenOfinOrder=$l(MuitOEORIDrIn,"@")
    ....f i=1:1:lenOfinOrder d
    .....s getOrder=$p(MuitOEORIDrIn,"@",i)
    .....i ..isInList(getOrder,MuitOEORIDr)="N" d
    ......s MuitOEORIDr=MuitOEORIDr_"@"_getOrder
    ......s MuitStudyNo=MuitStudyNo_"@"_$p(MuitStudyNo,"@",1)
    
    I hasSameOrder="N" TRollback  	
	I hasSameOrder="N" lock -(^DHCRisTMPReg)  
	I hasSameOrder="N" q "-11112"
	* /
    s count=$l(MuitOEORIDr,"@")
    for i=1:1:count d
    .s perOrditemRowid=$p(MuitOEORIDr,"@",i)
    .s StudyNo=$p($g(MuitStudyNo),"@",i)
    .;s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(perOrditemRowid,"E",SSUSERDr)
    .s Now=$zd(+$H,8)_$zt($p($h,",",2))
    .s UserCode=""
    .i SSUSERDr'="" s UserCode=$p(^SSU("SSUSR",SSUSERDr),"^",1) 
    
    .&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_Note5)values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:GroupIndex,:RoomIndex,:UgentFlag))
    .s rowid=$p(%ROWID,$c(1))
    .;w !,"rowid="_rowid
    .;w !,BodyInfo
    .i BodyInfo'=""  d
    ..s regsql=##class(web.DHCRisRegisterPatientDoEx).RegBdyPart(rowid,BodyInfo)  
    .s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowid,"SC",Now,StudyNo,UserCode,"Y")
	

	 / *
	.s regrowid=0
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,regrowid))
	.i regrowid'="" d
	..s GetStudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	..s Reportrowid="",IsUpdateIndex="Y"
	..i GetStudyNo'=""  s Reportrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,""))
	..i Reportrowid="" d
	...s IsUpdateIndex="N"
	...s IndexOld=$p($g(^DHCPACRegInfo(regrowid)),"^",15) ;add by sunyi 
	...s roomDrOld=$p($g(^DHCPACRegInfo(regrowid)),"^",16)
	...s checkGroupOld=$p($g(^DHCPACRegInfo(regrowid)),"^",17)
	...s roomIndexOld=$p($g(^DHCPACRegInfo(regrowid)),"^",24)
	...s checkGroupIndexOld=$p($g(^DHCPACRegInfo(regrowid)),"^",28)
	...s RegDateOld=$p($g(^DHCPACRegInfo(regrowid)),"^",8)
	...;i (RegDate'=RegDateOld) d  ;判断传入的执行日期是否有变动
	....;s isUpdateRegDate="Y"
	...;e  d
	....;s isUpdateRegDate="N"
	....;s Index=IndexOld
	...;if (roomDrOld'=RoomDR)!(isUpdateRegDate="Y") d   ;判断房间ID或执行日期
	....;s isUpdateRoomIndex="Y"
	...;e  d
	....;s isUpdateRoomIndex="N"
	....;s RoomIndex=roomIndexOld
	...;if (checkGroupOld'=EQGroupDR)!(isUpdateRegDate="Y") d ;判断资源组ID或执行日期
	....;s isUpdateCheckGroupIndex="Y"
	...;e  d
	....;s isUpdateCheckGroupIndex="N"
	....;s GroupIndex=checkGroupIndexOld
	...;&sql(update  DHCRB_RegInfo (RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_Note5,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_RegEQ_Index) values (:MainDocDr,:AssDocDr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:RoomDR,:EQGroupDR,:ReportInfo,:UgentFlag,:GroupIndex,:RoomIndex,:Index) where RAR_Rowid=:regrowid)
	...;s regsql=##class(web.DHCRisRegisterPatientDoEx).RegBdyPart(regrowid,BodyInfo)
	.else  d
	..;不同病人，或者是不同就诊，检查号不能相同
	..s mayreg=0
	..s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	..if regrowid'="" d
	...s getpaadm=$p(^DHCPACRegInfo(regrowid),"^",10)
	...;i getpaadm=paadr d  //只允许同一个人插入 
	...i getpaadm'="" d  //同病人不同就诊允许插入 
	....&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_Note5)values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:GroupIndex,:RoomIndex,:UgentFlag))
    ....q:SQLCODE'=0
	....s rowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,""))
	....s childsub=""
	....i rowid'="" s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,rowid,0)) 
	....i childsub'="" d
	.....&sql(delete from DHCRB_RegInfo_BodyParts where  RRB_ParRef=:rowid)
   	....i (rowid'="")&(bodyNum'="") d
	.....s regsql=##class(web.DHCRisRegisterPatientDoEx).RegBdyPart(rowid,BodyInfo)
	...else  d  //不同病人的检查号重复
	....s SQLCODE=-10005
	....;s ret2=..AddNumber(RegLOCDr,EQGroupDR,InputRegDate,StudyNo)
	..else  d    //登记表为空
	...;插入叫号对列表
	...&sql(insert into DHCRB_CallQueue(DRCQ_PatId,DRCQ_Name,DRCQ_Sex,DRCQ_StudyNo,DRCQ_RegDate,DRCQ_LocDr,DRCQ_LocIndex,DRCQ_EqDr, DRCQ_EqIndex,DRCQ_RoomDr,DRCQ_RoomIndex)values(:RegNo,:Name,:SexDesc,:StudyNo,:RegDate,:RegLOCDr,:Index,:EQGroupDR,:GroupIndex,:RoomDR,:RoomIndex))
	...&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_Note5)values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:GroupIndex,:RoomIndex,:UgentFlag))
    ...q:SQLCODE'=0
	...s rowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,""))
	...s childsub=""
	...i rowid'="" s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,rowid,0)) 
	...i childsub'="" D
	....&sql(delete from DHCRB_RegInfo_BodyParts where  RRB_ParRef=:rowid)
   	...i (rowid'="")&(bodyNum'="") d
	....s regsql=##class(web.DHCRisRegisterPatientDoEx).RegBdyPart(rowid,BodyInfo)
   * /
    
	I SQLCODE TRollback  	
	I SQLCODE lock -(^DHCRisTMPReg)  
	I SQLCODE q SQLCODE
    
    i ((SQLCODE=0)&(IsUpdateIndex="Y")) d
	.d ..UpdateIndex(RegLOCDr,Index,RegDate)
	.d ..UpdateGroupIndex(EQGroupDR,GroupIndex,RegDate)
	.d ..UpdateRoomIndex(RoomDR,RoomIndex,RegDate) 

	i ((SQLCODE=0)&(IsUpdateIndex="N")) d
	.i isUpdateRegDate="Y" d
	..d ..UpdateIndex(RegLOCDr,Index,RegDate)
	.i (isUpdateRoomIndex="Y") d
	..d ..UpdateRoomIndex(RoomDR,RoomIndex,RegDate) 
	.i isUpdateCheckGroupIndex="Y" d
	..d ..UpdateGroupIndex(EQGroupDR,GroupIndex,RegDate)
	
	//update weight 2006-10-16
	s mrrowid=$p(^PAADM(paadr),"^",61)

	s papatmasdr=$p(^PAADM(paadr),"^",1)
	&sql(update MR_Adm SET MRADM_Weight=:Weight where MRADM_Rowid=:mrrowid)
     //update 住院号
    &sql(update PA_PATMAS set PAPMI_Medicare=:IpNo where PAPMI_RowId=:papatmasdr)
    //update 电话号
    &sql(update pa_person set PAPER_TelH =:TelNo where PAPER_Rowid=:papatmasdr) 
    
    
  	TCOMMIT
  	/ *
  	;BILL病人的账单
	if ($g(^DHCRisCheckFee)="Y")
	{
    	s rtn=##Class(web.UDHCJFBILLIP).BILLN(paadr,SSUSERDr,OEORIDr)
    }
    * /
  	//do ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4(MuitOEORIDr)
  	lock -(^DHCRisTMPReg)     		       //回滚事务
  	d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000005",MuitStudyNo) //调平台接口,给第三方传消息
 	Quit SQLCODE

  	
  	/ *
    s ResDesc=""
  	I RegEQDr'="" s ResDesc=$p(^RBC("EQ",RegEQDr),"^",2) 
	s RegisterDateTime=$zd(RegDate,8)_""_$tr($zt(RegTime,1),":")
	s Note="",operater=""
	i SSUSERDr'="" s operater=$p($g(^SSU("SSUSR",SSUSERDr)),"^",2)
	s OperateDate=$zd(+$h,8)
	;Set CurrentNS=$ZNSPACE 
	;zn "RIS"
	;s retinfo=##class(RISInterfaceLayer.OutRISInfoProcess).SendStatusToEns(OEORIDr, ResDesc, RegisterDateTime, Note , operater, OperateDate ,"2","","")
	;zn CurrentNS
	;s retCodeInfo=$p(retinfo,"<Returncode>",2)
    ;s retCode=$p(retCodeInfo,"</Returncode>",1)
    ;i retCode'=0 s SQLCODE="-10000"
   
 	//s ret=##class(web.DHCRisRegisterPatientDoEx).updatenumber("781","","11","05/06/2008")
	//设备的接口设计
	//s ret=##class(web.DHCEQIUsedRecord).BuildRISUseRecord(RegEQDr,OEORIDr)
    //w !,"TCOMMIT"
    * /
    
  
    / *if RegLOCDr'="" d 
    .s LocCode=$p(^CTLOC(RegLOCDr),"^",1)
    .i (LocCode="2304")!(LocCode="5001")!(LocCode="6501") d * /
    ..; 内镜系统的检查信息传输
    ..;s ret=##class(RISService.InvokeRISService).InsertAppStudyInfo(StudyNo) //sunyi 2011-09-28
    
            
    ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit SQLCODE
 	*/
 	q "-1"
}

/// 函数名称：UnRegister
/// 功能：取消病人登记，同时在退费中插入记录(合肥要求）
/// 输入参数：Info:登记的基本信息,Bodynum:部位的个数,BodyInfo部位的信息
/// 返回：SQLCODE
/// 作者：龚平
/// 日期：2007-03-05
/// ///////////////////
ClassMethod UnRegister(OEordDr, Reason, LocDR, usercode, price) As %String
{
	n (OEordDr, Reason, LocDR, usercode, price)
    s date1=+$h,time1=$p($h,",",2)
	
	TSTART
	
	&sql(delete from DHCRB_RegInfo where RAR_OEORI_DR=:OEordDr)
    
    ;I SQLCODE TRollBack  Quit SQLCODE
   	
   	&sql(delete from OE_OrdResult where RES_ParRef=:OEordDr)
	&sql(select OSTAT_RowId into :StatusDr from OEC_OrderStatus where  OSTAT_Code='V')
	&sql(update OE_OrdItem set OEORI_ItemStat_DR=:StatusDr where OEORI_RowId=:OEordDr)
    
    I SQLCODE TRollBack  Quit SQLCODE
    s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
    
    //V:审核状态
	s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(OEORIDr,"V",userid)


    if Reason'="" d
    .&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    .i (rrowid="") d 
    ..&sql(insert into DHCRB_ReturnReason (DBRR_Reason)values(:Reason))
    ..&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    
    &sql(insert into  DHCRB_ReturnFee(DRBR_Reason_DR,DRBR_Loc_DR,DRBR_OEORDITEM_DR,DRBR_DATE,DRBR_Time,DRBR_USSER_DR,DRBR_TotalPrice)
    							values (:rrowid,:LocDR,:OEordDr,:date1,:time1,:userid,:price))
    I SQLCODE TRollBack  Quit SQLCODE
    TCOMMIT
	q SQLCODE
}

// d ##class(web.DHCRisRegisterPatientDoEx).CanRegisterArcItmMaster(^tmpOrdItemID)

/// //////////////////////////////////////////////////////
/// 函数名称：GetStudyNo/// 功能：根据医嘱，科室，和设备组获得检查号
/// 输入参数：orditmrowid 医嘱的ROWID EQGoupDr：设备组ROWID, LocDr：科室ROWID
/// 返回：检查号
/// 作者：龚平
/// 日期：2007-03-05
/// //////////////////////////////////////////////////////
ClassMethod GetStudyNo(orditmrowid, EQGoup, LocDr, SelectDate = "") As %String
{
	s ^t("GetStudyNo")=orditmrowid_"^"_EQGoup_"^"_LocDr_"^"_SelectDate
	n (orditmrowid, EQGoup, LocDr,SelectDate)
	s rowid=0,StudyNo="^^"
	s IsCreateType="",StudyNoL=""
	q:orditmrowid="" StudyNo
	
	s rowid="",AppType="",ItmCatRowid="",OperationDR="",IsCreateType=""
	s EQGoupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGoup)
	s ItmCatRowid=##class(web.DHCRisCodeTableAdd).GetItmCatDR(orditmrowid)

	
	i EQGoupDr'="" s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGoupDr,rowid))
	i ((ItmCatRowid'="")&(rowid="")) s rowid=$o(^DHCPACRegInfoCRi("SubOrderCat",ItmCatRowid,rowid))
	if rowid="" s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	i rowid'="" d
	.s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	.s OperationDR=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",7)
	.i OperationDR'="" s IsCreateType=$p($g(^DHCRBCStatus("PatientStatus",OperationDR)),"^",1)
	
	i IsCreateType="" s IsCreateType="B"
	i (IsCreateType'="I")
	{
		//查找已预约的检查号
		s BookedInfo=""
		s BookedInfo=##class(web.DHCRisResourceApptSchudleEx).GetBookedResult(orditmrowid)
		
		i (BookedInfo'="")
		{
			s StudyNo=$p(BookedInfo,"^",1)
			i StudyNo'="" s StudyNoL=$p($g(StudyNo),"-",2)
			i (StudyNoL'="") d
			.s PreFix=$p(StudyNo,"-",1)
		    .s StudyNo=$p(StudyNo,"-",2)
		    .s StudyNo=PreFix_"-^"_StudyNo_"^0"
		    else  d
		    .s StudyNo="^"_StudyNo_"^"_0 	
		}
		
		q:(StudyNo'="") StudyNo
	}
	
	//查找已经登记的检查号
	s regrowid=$o(^DHCPACRegInfoi("OEORI",orditmrowid,0))
	i (regrowid'="")&(regrowid'=0) d
	.s Info=^DHCPACRegInfo(regrowid)
	.s StudyNo=$p(Info,"^",2)
	.i StudyNo'="" s StudyNoL=$p($g(StudyNo),"-",2)
	.i ((rowid'="")&(StudyNoL'="")) d   ; ----------------------按规则生成
	..s PreFix=$p(StudyNo,"-",1)
	..s StudyNo=$p(StudyNo,"-",2)
	..s StudyNo=PreFix_"-^"_StudyNo_"^0"
	.else  d
	..s StudyNo="^"_StudyNo_"^"_0 
    q:(regrowid'="")&(regrowid'=0)&(StudyNo'="") StudyNo
    
   
    //找默认的检查号 医嘱Rowid 
	s Oeordrowid=$p(orditmrowid,"||",1)
	s childsub=$p(orditmrowid,"||",2)
	//s StudyNo=$p(^OEORD(Oeordrowid,"I",childsub,8),"^",19)
	//s StudyNo=$TR(StudyNo,"/","-")
	s StudyNo=Oeordrowid_"-"_childsub
	s StudyNo="^"_StudyNo_"^0"
	q:(EQGoupDr="")&(LocDr="") StudyNo 
	q:(rowid="")!(rowid=0)!(AppType=0) StudyNo
	
	
    //新增一个检查号
    //例如前缀为：XX+t 或者是 XX+T 的话：生成的 XX+当前日期（20080130）+加当前的流水号
	//否则是 前缀+顺序号
	/*i rowid'="" d
	.s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
	.s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
	.if (Number="t")!(Number="T") d
	..i SelectDate="" d
	...s currentdate=$zd(+$h,8)
	..else  d
	...s currentdatedigital=$zdh(SelectDate,4)
	...s currentdate=$zd(currentdatedigital,8) 
	..i $g(^DHCRisStudyNoDate(LocDr,currentdate))="" s ^DHCRisStudyNoDate(LocDr,currentdate)=0
	..s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
	..s Number=Number+1
	..s Number=..Out3Number(Number)
	..s Prefix=Prefix_currentdate
    .else  d
	..s Number=Number+1
	.s StudyNo=Prefix_"-^"_Number_"^1"*/
	
	if (rowid'="") 
	{
		s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
		s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
		if (Number="t")!(Number="T") 
		{
			if (SelectDate="")
			{
				s currentdate=$zd(+$h,8)
			}
			else 
			{
				s currentdatedigital=$zdh(SelectDate,4)
				s currentdate=$zd(currentdatedigital,8)
			} 
			if $g(^DHCRisStudyNoDate(LocDr,currentdate))=""  s ^DHCRisStudyNoDate(LocDr,currentdate)=0
			s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
			s Number=Number+1
			
			s Prefix=Prefix_currentdate
			;判断是否已经使用，找到一个未使用的检查号
			
			s isFind="N"
			
			while(isFind'="Y")
			{
				s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
				s studyNoFind=Prefix_"-"_Number
				s detailDrFind=""
				s regInfoDrFind=""
				s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
				s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
				if ((detailDrFind="")&&(regInfoDrFind=""))
				{
					s isFind="Y"
				}
				else
				{
					s Number=Number+1
				}
			}
			
		}
		else 
		{
			s Number=Number+1
		}
		
		s StudyNo=Prefix_"-^"_Number_"^1"
	}

	q StudyNo
}

ClassMethod Out3Number(Number) As %String
{
	s strNum=Number
	s len=$l(Number)
	for i=2:-1:len  d
	.s strNum="0"_strNum
    q strNum
}

/// //////////////////////////////////////////////////////
/// 函数名称：updatenumber
/// 功能：更新检查号生成规则
/// 输入参数：LocDr：科室ROWID, EQGroupDr：设备组ROWID, Number：当前最大的值
/// 返回：检查号
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
/// s ret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(LocDr, EQGroupDr, Number, SelectDate)
ClassMethod updatenumber(LocDr, EQGroupDr, Number, SelectDate = "") As %String
{
	n (LocDr, EQGroupDr, Number,SelectDate)
	s ^RIS("sunyi")=LocDr_"^"_EQGroupDr_"^"_Number_"^"_SelectDate
	s SQLCODE=0
	s rowid=""
  	i (EQGroupDr'="")&(LocDr'="") d 
	.s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGroupDr,rowid))
	if rowid="" d
	.s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,0))
	i (rowid'="")&(rowid'=0) d
	.s Number1=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
	.i ((Number1="t")!(Number1="T")) d
	..i SelectDate="" d
  	...s currentdate=$zd(+$h,8)
  	..else  d
  	...s currentdatedigital=$zdh(SelectDate,4)
	...s currentdate=$zd(currentdatedigital,8) 
	..s ^DHCRisStudyNoDate(LocDr,currentdate)=Number
	.else  d
	..&sql(update DHCRB_StudyNo_Createrule set RSC_MaxNumber=:Number where RSC_Rowid =:rowid)
	q SQLCODE
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetNo
/// 功能：获得病人的编号（如CT号，MRI，超声号，每次来做检查，他的编号是一样的）
/// 输入参数：LocDr：科室ROWID, EQGroupDr：设备组ROWID, Number：当前最大的值
/// 返回：检查号
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod GetNo(orditmrowid, EQGroup, LocDr) As %String
{
	n (orditmrowid, EQGroup, LocDr)
	
	s rowid=0,No="^^"
	q:orditmrowid="" No
	if EQGroup=" " s EQGroup=""
	
	s EQGroupDr=""
	if EQGroup'="" d
	.s EQGroupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGroup)

	//查找已经登记的医嘱的编号，找到则退出
	s rowid=$o(^DHCPACRegInfoi("OEORI",orditmrowid,0))
	i (rowid'="")&(rowid'=0) d
	.s Info=^DHCPACRegInfo(rowid)
	.s NoDR=$p(Info,"^",3)
	.s No=""
	.i NoDR'="" s No=$p($g(^DHCPACRegInfoNO("NO",0,NoDR)),"^",3)
	.s No="^"_No_"^0"
    q:(rowid'="")&(rowid'=0) No
    
    //查找原来的编号
    s oeordrowid=$p(orditmrowid,"||",1)
    s paadmdr=$p(^OEORD(oeordrowid),"^",1)
    s papatmasdr=$p(^PAADM(paadmdr),"^",1)
    s GetOldNo=""
    ;i $g(EQDr)'="" s EQGoupDr=$p(^RBC("EQ",EQDr),"^",3)
    s norowid=0 f  s norowid=$o(^DHCPACRegInfoNOi("Loc",0,LocDr,norowid)) q:norowid=""  d
    .s getpatmasdr=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",1)
    .s GetEQGroupDR=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",5)
    .i papatmasdr=getpatmasdr d 
    ..s No=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",3)
    ..s GetOldNo=No
    ..i (EQGroupDr'="")&(GetEQGroupDR=EQGroupDr) d
    ...s No=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",3)
    ...s GetOldNo=No
    i (GetOldNo'="") s No="^"_GetOldNo_"^0"
    q:(GetOldNo'="") No
    
    //按照编号生成器的规则生成一个新的编号
    s rowid=0,AppType=""
	i (EQGroupDr'="")&(LocDr'="") d 
	.s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGroupDr,rowid))
	.i rowid'="" s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	else  if LocDr'=""   d
	.s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	.i rowid'="" s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	i AppType=0 d
	.s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
	.s Number=Number+1
	.s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
	.s No=Prefix_"^"_Number_"^1"
	q No
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateNo
/// 功能：更新编号生成器的最大数值
/// 输入参数：LocDr：科室ROWID, EQGroupDr：设备组ROWID, Number：当前最大的值
/// 返回：检查号 
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateNo(NO As %String, paadmdr As %String, LocDr As %String, EQGroup As %String) As %String
{
	 n (NO,paadmdr,LocDr,EQGroup)
	 ;s ^DHCRISTMP=NO_"^"_paadmdr_"^"_LocDr_"^"_EQGroup
     s papatmasdr=$p(^PAADM(paadmdr),"^",1)
     q:NO="" ""
     
     s Selrowid=""
     s EQGroupDR=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGroup)
   
	 //查找原来的编号
	 s norowid=0 f  s norowid=$o(^DHCPACRegInfoNOi("Loc",0,LocDr,norowid)) q:norowid=""  d
     .s getpatmasdr=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",1)
     .s GetEQGroupDR=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",5)
     .s No=$p(^DHCPACRegInfoNO("NO",0,norowid),"^",3)
     .i papatmasdr=getpatmasdr d
     ..s Selrowid=norowid
     ..i (EQGroupDR'="")&(GetEQGroupDR=EQGroupDR) d
     ...s Selrowid=norowid
     &sql(update DHCRB_NO set RNO_NO=:NO where RNO_Rowid=:Selrowid)
     q:(Selrowid'="") Selrowid
    
     //没有找到则插入编号，返回ROWID
     &sql(Insert into DHCRB_NO (RNO_PAPATMAS_DR,RNO_LOC_DR,RNO_NO,RNO_EQGroup_DR) values (:papatmasdr,:LocDr,:NO,:EQGroupDR))
     q:SQLCODE ""
     s rowid=$p(%ROWID,$c(1))
     q rowid
}

/// //////////////////////////////////////////////////////
/// 函数名称：IniRegIndex
/// 功能：每天需要初始化登记的序号
/// 输入参数：空
/// 返回：
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod IniRegIndex()
{
	s Locrowid=0  f  s locrowid=$o(^DHCRisRegIndex(locrowid)) q:locrowid=""  d
	.s ^DHCRisRegIndex(locrowid)=0 
	q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetCurentIndex
/// 功能：获得科室当前的序号
/// 输入参数：空
/// 返回：
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod GetCurentIndex(LocDr, Day As %String = "") As %String
{
	n (LocDr,Day)
	q:LocDr="" ""
	s CurrentIndex=""
	i Day="" s Day=+$h
	else  s Day=$zdh(Day,4)
	
	i (LocDr'="")
	{
	  i $g(^DHCRisRegIndex(Day,LocDr))="" s ^DHCRisRegIndex(Day,LocDr)=0
	  s CurrentIndex=$g(^DHCRisRegIndex(Day,LocDr))+1
	}
	
	q CurrentIndex
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateIndex
/// 功能：//更新当前的流水号
/// 输入参数：LocDr：科室ROWID, Index：序号
/// 返回：
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateIndex(LocDr, Index, Day As %String = "") As %String
{
  n (LocDr, Index,Day)
  q:LocDr="" 100
  q:((Index="")!(Index=" ")) 100
  i Day="" s Day=+$h
  s ^DHCRisRegIndex(Day,LocDr)=Index
  
  q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetRoomIndex
/// 功能：获得房间当前的序号
/// 输入参数：空
/// 返回：
/// 日期：2007-03-05
/// 作者：龚平
/// ////////////////////////////////////////////////////////
ClassMethod GetRoomIndex(RoomDR, Day As %String = "") As %String
{
	n (RoomDR,Day)
	s RoomCurrentIndex=""
	q:RoomDR="" ""
	i Day="" s Day=+$h
	else  s Day=$zdh(Day,4)
	if (RoomDR'="")
	{
	  i $g(^DHCRisCheckRoomIndex(Day,RoomDR))="" s ^DHCRisCheckRoomIndex(Day,RoomDR)=0
	  s RoomCurrentIndex=^DHCRisCheckRoomIndex(Day,RoomDR)+1
	}
	q RoomCurrentIndex
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateRoomIndex
/// 功能：//更新房间的流水号
/// 输入参数：RoomDR：科室ROWID, Index：序号
/// 返回：
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateRoomIndex(RoomDR, Index, Day As %String = "") As %String
{
  n (RoomDR,Index,Day)
  q:RoomDR="" 100
  q:((Index="")!(Index=" ")) 100
  i Day="" s Day=+$h
  s ^DHCRisCheckRoomIndex(Day,RoomDR)=Index
  q 0
}

/// 得当前到资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod GetGroupIndex(CheckGroupDr, Day) As %String
{
    n (CheckGroupDr,Day)
    s CheckGroupIndex=""
    q:CheckGroupDr="" ""
    
	i Day="" s Day=+$h
	else  s Day=$zdh(Day,4)
	
	i (CheckGroupDr'="")
	{
	   i $g(^DHCRisCheckGroupIndex(Day,CheckGroupDr))="" s ^DHCRisCheckGroupIndex(Day,CheckGroupDr)=0
	   s CheckGroupIndex=^DHCRisCheckGroupIndex(Day,CheckGroupDr)+1
	}
	q CheckGroupIndex
}

/// 跟新资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod UpdateGroupIndex(CheckGroupDr, Index, Day) As %String
{
    n (CheckGroupDr,Index,Day)
    q:CheckGroupDr="" 100
    q:((Index="")!(Index=" ")) 100
	i Day="" s Day=+$h
	s ^DHCRisCheckGroupIndex(Day,CheckGroupDr)=Index
	q 0
}

Query QueryBodyParts(StudyNo As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QueryBodyPartsExecute(ByRef qHandle As %Binary, StudyNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s bodydr="",Code="",Desc=""
	s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	i regrowid '="" d
    .s childsub=0 f  s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,childsub)) q:childsub=""  d
    ..s bodydr=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,childsub),"^",1)
    ..s Desc=$p(^MRC("BODP",bodydr),"^",2) 
    ..Do OutBodys 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutBodys
	set Data=$lb(bodydr,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryBodyPartsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBodyPartsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBodyPartsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBodyPartsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// ##class(web.DHCRisRegisterPatientDoEx).GetGroupRoom("402","病房01诊室")
ClassMethod GetGroupRoom(LocDR, EQDesc)
{
  n (EQDesc, LocDR)
  s EQGroupInfo="^"
  s RoomInfo="^"
  s EQDR=##class(web.DHCRisCommFunction).GetEQDR(LocDR,EQDesc)
  if EQDR'="" d
  .s EQGroupInfo=##class(web.DHCRisCommFunction).GetEQGroup(EQDR)
  .s RoomInfo=##class(web.DHCRisCommFunction).GetRoomByEQ(EQDR)
  s ret=$g(EQGroupInfo)_"^"_$g(RoomInfo)
  q ret
}

ClassMethod GetEQSuportWorkList(EQDesc, LocDR)
{
  n (EQDesc,LocDR)
  s SupportWorkList="N"
  s EQDR=##class(web.DHCRisCommFunction).GetEQDR(LocDR,EQDesc)
  if EQDR'="" d 
  .s ClientDR=$o(^DHCRBCi("Client","Equipment",EQDR,0))
  .i ClientDR'="" s SupportWorkList=$p(^DHCRBC("Client",ClientDR),"^",5)
  q SupportWorkList
}

ClassMethod GetLocPrintTemplate(LocDR As %String) As %String
{
  n (LocDR)
  s PrintName=""
  if LocDR'="" d 
  .s locprowid=$o(^DHCRBC("Loc",LocDR,0)) 
  .i locprowid'="" d
  ..s PrintName=$p(^DHCRBC("LocParam",locprowid),"^",11)
  q PrintName
}

ClassMethod GetEQRegPrintTemplate(EQDR)
{
  n (EQDR)
  s PrintName=""
  if EQDR'="" d 
  .s ClientDR=$o(^DHCRBCi("Client","Equipment",EQDR,0))
  .i ClientDR'="" s PrintName=$p(^DHCRBC("Client",ClientDR),"^",7)
  q PrintName
}

ClassMethod GetFilmSendDate() As %String
{
	s Date=$zd($h+2,3)
	q Date
}

ClassMethod GetPrintItem(StudyNo) As %String
{
	n (StudyNo)
    i StudyNo="" q
	s OrderDr="",OrderRowid="",itemsub="",OrderName="",OrderNames="",arcimid=""
	s rowid=0 f  s rowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,rowid)) q:rowid=""  d
	.s OrderDr=$p(^DHCPACRegInfo(rowid),"^",11)
	.s OrderRowid=$p(OrderDr,"||",1)
	.i OrderRowid="" q
	.s itemsub=$p(OrderDr,"||",2)
	.i $g(^OEORD(OrderRowid,"I",itemsub,1))="" q
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    .s OrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    .s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
    .q:ServerMaterial="M"
    .s OrderNames=OrderNames_" "_OrderName
    q OrderNames
}

/// 函数：CanRegisterArcItmMaster
/// 功能：根据计费设置判断医嘱是否允许登记
/// 返回：Y/N
ClassMethod CanRegisterArcItmMaster(OrdItemID) As %String
{
  n (OrdItemID)
  q:OrdItemID="" ""
  s stay=""
  s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
  s DHCRisVersion=$p(SystemParamInfo,"^",15)
  s AllowOpRegNotPaid=$p(SystemParamInfo,"^",11)
  s AllowIpRegNotPaid=$p(SystemParamInfo,"^",12)
  s AllowHPRegNotPaid=$p(SystemParamInfo,"^",13)
  s AllowEMRegNotPaid=$p(SystemParamInfo,"^",14)
  s OrderRowid=$p(OrdItemID,"||",1)
  s itemsub=$p(OrdItemID,"||",2)
  s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
  s paadmdr=$p(^OEORD(OrderRowid),"^",1)
  s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
  s stay=##class(web.DHCADMVisitStat).GetPatCurStat(paadmdr)
  i stay'="" s stay=$zcvt($p($g(stay),"^",1),"U")
  
  if (DHCRisVersion="HN_XYOYY") d
  .; 湘雅医院处理
  .;s billed=##class(web.DHCRisCommFunctionEx).GetOEordBilled(OrdItemID)
  .s Flag=##class(web.DHCRisWorkBenchDoEx).CheckStatus(OrdItemID,paadmdr)
  .i Flag=0 s billed="P"
  
  /*   注释病人的类别，具体的项目可以修改此代码
  i paadmdr'="" s PaadmInfo="" s PaadmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
  i PaadmInfo'="" s admreasondr=$p($g(PaadmInfo),"^",37)
  q:(admreasondr="1") "Y"
  */
  
  if (patienttype="H")
  {
	  b //001
	  s hasMethod=##class(websys.Conversions).IsValidMethodName("web.DHCPE.CRM.GatewayDHC","CanRegister")
	  b //002
	  if ( hasMethod)
	  {
		  s ret=##Class("web.DHCPE.CRM.GatewayDHC").CanRegister(OrdItemID)
		  if (ret=1) 
		  {
			  q "Y"
		  }
		  else
		  {
			  q "N"
		  }
	  }
  }
  
  q:billed="P" "Y"    ;已经收费的允许登记
  q:(patienttype="I")&(AllowIpRegNotPaid="Y") "Y"
  q:(patienttype="O")&(AllowOpRegNotPaid="Y") "Y"
  q:(patienttype="H")&(AllowHPRegNotPaid="Y") "Y"
  q:(patienttype="E")&(AllowEMRegNotPaid="Y") "Y"
  ;q:(patienttype="E")&(stay="STAY") "Y"  ;暂时不处理留观病人
  q "N"
}

// ##

ClassMethod TrimVal(Val As %String) As %String
{
	s Val=$p(Val,$c(0))
	q Val
}

ClassMethod AddNumber(LocDr, EQGroupDr, SelectDate, InStudyNo)
{
	n (LocDr, EQGroupDr,SelectDate,InStudyNo)
	s SQLCODE=0
	s rowid=""
  	i (EQGroupDr'="")&(LocDr'="") d 
	.s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGroupDr,rowid))
	if rowid="" d
	.s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,0))
	i (rowid'="")&(rowid'=0) d
	.s Number1=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
	.s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
	.i ((Number1="t")!(Number1="T")) d
	..i SelectDate="" d
  	...s currentdate=$zd(+$h,8)
  	..else  d
  	...s currentdatedigital=$zdh(SelectDate,4)
	...s currentdate=$zd(currentdatedigital,8)
	..i $g(^DHCRisStudyNoDate(LocDr,currentdate))="" s ^DHCRisStudyNoDate(LocDr,currentdate)=0
    ..s GetNumber=^DHCRisStudyNoDate(LocDr,currentdate)+1
    ..s GetNumber=##class(web.DHCRisRegisterPatientDoEx).Out3Number(GetNumber)
    ..s GetStudyNo=Prefix_currentdate_"-"_GetNumber
    ..i GetStudyNo=InStudyNo  d
  	...s ^DHCRisStudyNoDate(LocDr,currentdate)=^DHCRisStudyNoDate(LocDr,currentdate)+1
	.else  d
	..s Number1=Number1+1
	..s GetStudyNo=Prefix_Number1
	..i GetStudyNo=InStudyNo  d  
	...&sql(update DHCRB_StudyNo_Createrule set RSC_MaxNumber=:Number1 where RSC_Rowid =:rowid)
	q SQLCODE
}

/// 查询申请单中没有登记的医嘱,考虑一个申请单跨页的情况,强制一个申请单一起登记
/// d ##class(web.DHCRisRegisterPatientDoEx).ForceRegisterAppOrditem(^dhcristmp1,^dhcristmp2,^dhcristmp3)
ClassMethod ForceRegisterAppOrditem(Info, bodyNum, BodyInfo) As %String
{
	s perOEOrditemRowid=$p(Info,"^",4)
	s ret=""
	s AppRowid=$o(^DHCRBAppOrdi(0,perOEOrditemRowid,0))
	if AppRowid'="" d
	.s Childsub=0 f  s Childsub=$o(^DHCRBAppOrd("OrdItem",AppRowid,Childsub)) q:Childsub=""  d
	..s OEOrdRowid=$p(^DHCRBAppOrd("OrdItem",AppRowid,Childsub),"^",1)
	..s Info1=$p(Info,"^",1,3)_"^"_OEOrdRowid_"^"_$p(Info,"^",5,21)
	..s regrowid=$o(^DHCPACRegInfoi("OEORI",OEOrdRowid,0))
	..i regrowid="" d
    ...s ret=##class(web.DHCRisRegisterPatientDoEx).InsertRegInfo(Info1, bodyNum, BodyInfo)
    q ret
}

ClassMethod SendORMO01Message(Info As %String, Operation As %String, CM As %String = "") As %String
{
 
 s PatientID=$p(Info,"~",1)
 s PatientName=$p(Info,"~",2)
 s PatientNamePY=$p(Info,"~",3)
 S PatientNamePY=$ZCONVERT(PatientNamePY,"U")
 s DOB=$p(Info,"~",4)
 s Sex=$p(Info,"~",5)
 s StudyNo=$p(Info,"~",6)
 s weight=$p(Info,"~",7)
 s bodyinfo="" 
 s bodyinfo=$p(Info,"~",8)
 s regEQ=$p(Info,"~",9)
 s executedate=$p(Info,"~",10)
 s strAge=$p(Info,"~",11)

 s AgeUnit=$e(strAge,$l(strAge))
 i (AgeUnit="年")!(AgeUnit="岁") s AgeUnit="Y"
 i (AgeUnit="月") s AgeUnit="M"
 i (AgeUnit="日")!(AgeUnit="天") s AgeUnit="D"
 
 s Age=$e(strAge,1,$l(strAge)-1)
 s strAge=Age_AgeUnit
 
 if regEQ="2室CR" d 
 .s PatientNamePY=PatientNamePY_"^^^"_strAge 
 
 s StationName=""
      
       if regEQ="9室RF" d
       .s StationName="*"
 
 
 s CurrentDate=""
 i executedate'="" d
 .s exeyear=$p(executedate,"/",3)
 .s exemonth=$p(executedate,"/",2)
 .s exeday=$p(executedate,"/",1)
 .i $l(exeday)="1" d 
 ..s exeday="0"_exeday 
 .s CurrentDate=exeyear_exemonth_exeday
 s strReferringPhysiciansName=""
 
    i CurrentDate=""    s CurrentDate=$zd(+$h,8)
    s strCurrentTime=$zt($p($h,",",2))
    s CurrentTime=$p(strCurrentTime,":",1)_$p(strCurrentTime,":",2)_$p(strCurrentTime,":",3)
    s CurrentDateTime=CurrentDate_CurrentTime
    
    s MessageID="O01"_Operation_StudyNo
    
    i Sex="男"  s Sex="M"
    else  s Sex="F"  
 
 s Year=$p(DOB,"-",1)
 s Month=$p(DOB,"-",2)
 s Day=$p(DOB,"-",3)
 i Month="" d 
 . s Year=$p(DOB,"/",1)
 . s Month=$p(DOB,"/",2)
 . s Day=$p(DOB,"/",3)
 
 s DOB=Year_Month_Day
 i $g(^DHCRisDicomReqest)="" s ^DHCRisDicomReqest=0 
 s ^DHCRisDicomReqest=^DHCRisDicomReqest+1
 
 s CM=$p(CM,$c(0))
 
 ;s bodyinfo=""
 s Modality=""
 
 s MSH="MSH|^~\&|trak^^|R|ragon^^|R^^|20030408132351||ORM^O01|"_MessageID_"|P^|2.3.1|101637||||||"_$C(13)
 
    s PID="PID|1||"_PatientID_"||"_PatientNamePY_"||"_DOB_"|"_Sex_"|"_strAge_"|"_weight_"|||||||"_$C(13)
 
 s ORC="ORC|"_Operation_"|"_StudyNo_"^IHD|||"_CM_"||||"_CurrentDateTime_"|||||"_$C(13)
  
    //OBR.Format("OBR||%s|%d|%s^std|||%s||^|^^^^^^^^^^^^^||^^^^^|||%s|||||||||%s|||||||||||%s||||||||",strAccessionNumber,m_RequestID,strBodyPart,strCurDateTime,stationAE,strModality,strReferringPhysiciansName);
 
    s OBR="OBR||"_StudyNo_"|1|"_bodyinfo_"|"_StationName_"||"_CurrentDateTime_"||^|^^^^^^^^^^^^^||^^^^^|||"_Modality_"|||||||||"_regEQ_"|||||||||||"_strReferringPhysiciansName_"||||||||"_$C(13)
    s ORMO01=$C(11)_MSH_PID_ORC_OBR_$C(28)_$C(13)
  s Index=$g(^DHCRisHL7Index(MessageID))
    i Index="" d    ; 已经生成过HL7消息的医嘱不生成HL7消息
    .lock +(^DHCRisHL7No)                                            
    .i $g(^DHCRisHL7No)="" s ^DHCRisHL7No=0
    .s ^DHCRisHL7No=^DHCRisHL7No+1
    .s ^DHCRisHL7Message(^DHCRisHL7No)=ORMO01
    .s ^DHCRisHL7Index(MessageID)=^DHCRisHL7No
    .lock -(^DHCRisHL7No)
  
    ; ROX收到图像后，系统发送CA消息，同时设置有图状态
    if (Operation="CA")&(StudyNo'="") d
    .s ret=..InsertStudyImageTable(StudyNo)
  
    QUIT 0
}

/// s ret=##class(web.DHCRisRegisterPatientDoEx).InsertStudyImageTable("M20110610-001")
ClassMethod InsertStudyImageTable(StudyNo As %String) As %Integer
{
	;s ^TMPRISImageArrive(StudyNo)=""
	s SQLCODE=-1
	s regRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	i regRowid'="" d
    .&sql(INSERT INTO DHCRB_StudyImages(DRSI_StudyNo,DRSI_ExtName)
          VALUES (:StudyNo,'dcm'))
    q SQLCODE
}

/// 汉字转换拼音的函数
/// w ##class(web.DHCRisRegisterPatientDoEx).HZtoPin("孙毅")
ClassMethod HZtoPin(HZ As %String) As %String
{
	s Pin=""
	s count=$l(HZ)
	for i=1:1:count d
	.s perHZ=$e(HZ,i)
	.s perPin=$g(^RISHZPYK(perHZ))
	.i Pin="" d
	..s Pin=perPin
	.else  d
	..s Pin=Pin_" "_perPin
	q Pin
}

/// w ##class(web.DHCRisRegisterPatientDoEx).GetUrgent("20017||3885")
ClassMethod GetUrgent(oeorditemrowid As %String) As %String
{
	s Urgent=""
	q:(oeorditemrowid="") Urgent
	s OrderRowid=$p(oeorditemrowid,"||",1)
	s itemsub=$p(oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	
	q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1))
	
	s (ItmCatDR)=""
	s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	
	i (ItmCatDR'="")
	{
		s Code=$p($g(^ARC("IC",ItmCatDR)),"^",1)
		i Code="10077" s Urgent="Y"
	}
	
	q Urgent
}

/// w ##class(web.DHCRisRegisterPatientDoEx).GetMaxIndex("83^1^^1^6^1")
ClassMethod GetMaxIndex(Info As %String = "") As %String
{
   
  s MaxInfo=""
  s (InRegLOCDr,InIndex,InEQGroupDR,InGroupIndex,InRoomDR,InRoomIndex,InRegDate)=""
  
  s InRegLOCDr=$p(Info,"^",1)
  s InIndex=$p(Info,"^",2)
  s InEQGroupDR=$p(Info,"^",3)
  s InGroupIndex=$p(Info,"^",4)
  s InRoomDR=$p(Info,"^",5)
  s InRoomIndex=$p(Info,"^",6)
  s InRegDate=$p(Info,"^",7)
  i InRegDate'="" s InRegDate=$zd(InRegDate,"4")
  i (InRegLOCDr'="") d
  .s InIndex=..GetCurentIndex(InRegLOCDr,InRegDate)
  
  i (InEQGroupDR'="") d
  .s InGroupIndex=..GetGroupIndex(InEQGroupDR,InRegDate)
 
  i (InRoomDR'="") d
  .s InRoomIndex=..GetRoomIndex(InRoomDR,InRegDate)
  
  s MaxInfo=InIndex_"^"_InGroupIndex_"^"_InRoomIndex
  
  q MaxInfo
}

/// w ##class(web.DHCRisRegisterPatientDoEx).IsFindOtherBookItem("83")
/// 函数:IsFindOtherBookItem
/// 功能:根据科室ID获取是否产生一个或多个检查号标示 
/// 返回值:Y/N  N多个/Y一个
/// 作者:sunyi 2015-01-12
ClassMethod IsFindOtherBookItem(IniLocDR As %String) As %String
{
	s IsRule="Y" ;默认产生一个检查号
	
	s IsFindrowid=""
	s IsFindrowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,IniLocDR,IsFindrowid))
	s IsMoreStudyNo=""
	i IsFindrowid'="" d
	.s IsMoreStudyNo=$p(^DHCPACRegInfoCR("CreateRule",0,IsFindrowid),"^",8)
	.i IsMoreStudyNo="Y" s IsRule="N"
	
	q IsRule
}

/// w ##class(web.DHCRisRegisterPatientDoEx).GetBookItembyStudyNo("CS20150109-009")
/// 函数:GetBookItembyStudyNo
/// 功能:根据检查号获取预约的医嘱项目ID
/// 返回值:oeorditemrowid@oeorditemrowid@.....
/// 作者:sunyi 2015-01-12
ClassMethod GetBookItembyStudyNo(StudyNoGroup As %String) As %String
{
	s perStudyNo=""
	s perStudyNo=$p(StudyNoGroup,"@",1)
	s OEItemIDGroup="",StudyGroup="",BFind=0
	
    s DetailRowid="" f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("StudyNo",perStudyNo,DetailRowid)) q:DetailRowid=""  d
    .s oeorditemrowid=""
 	.s oeorditemrowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	.i OEItemIDGroup="" s OEItemIDGroup=oeorditemrowid
	.e  d
	..s OEItemIDGroup=OEItemIDGroup_"@"_oeorditemrowid
	.i StudyGroup="" s StudyGroup=perStudyNo
	.e  d
	..s StudyGroup=StudyGroup_"@"_perStudyNo
	.s BFind=1
	
	q:(BFind=0) ""
	q OEItemIDGroup_"^"_StudyGroup
}

/// w ##class(web.DHCRisRegisterPatientDoEx).RegSameStudyGroup("1@2@3","1||2@1||3@1||5")
/// 登记时病人检查号相同医嘱放在一起。
/// sunyi 2013-07-26
ClassMethod RegSameStudyGroup(MuitStudyNo As %String, MuitOeItemRowid As %String) As %String
{
 
	  s Info=""
	  q:(MuitStudyNo="") Info
	  q:(MuitOeItemRowid="") Info
	  s count=0
	  s count=$l(MuitStudyNo,"@")
	  
	  for i=1:1:count d
	  .s perOrditemRowid=$p($g(MuitOeItemRowid),"@",i)
	  .s StudyNo=$p($g(MuitStudyNo),"@",i)
	  .i $g(SamesReg(StudyNo))="" d
	  ..s SamesReg(StudyNo)=perOrditemRowid
	  .e  d
	  ..s SamesReg(StudyNo)=SamesReg(StudyNo)_"@"_perOrditemRowid
	  
	 
	  s Rowid=0 f  s Rowid=$o(SamesReg(Rowid)) q:(Rowid="")  d
	  .i Info="" d
	  ..s Info=SamesReg(Rowid)
	  .e  d
	  ..s Info=Info_"^"_SamesReg(Rowid)
	
	  k SamesReg
	
	  q Info
}

/*ClassMethod GetMutiStudyNo(InOrditmGroup As %String, GroupDesc As %String = "", GetLocDR As %String, SelectDate As %String, GroupDR As %String) As %String
{
	s MutiCount=0
	s MutiCount=$l(InOrditmGroup,"@")
	s MutiStudyNoGroup=""
	s IsExit="N",LastStudyNo=""

	for l=1:1:MutiCount 
    {
	   s StudyInfo="",gIsUpdate="",perOrditemID=""
	   s perOrditemID=$p(InOrditmGroup,"@",l)
	   s StudyInfo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNo(perOrditemID,GroupDesc,GetLocDR,SelectDate)
       ;w !,"StudyInfossss="_StudyInfo
	   i StudyInfo'="" d
	   .s InStudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	   .s StudyNumber=$p($g(StudyInfo),"^",2)
       .s IsUpdate=$p($g(StudyInfo),"^",3)
	  
	   i IsExit="Y" s InStudyNo=LastStudyNo
	   s IsMore="N"
	   s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(GetLocDR,perOrditemID,GroupDesc)
	   
	   //多条医嘱产生多个检查号
	   i (IsMore="Y")&(IsUpdate="1") d
	   .s Upret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	   e  d
	   .i (IsExit="N") d
	   ..s LastStudyNo=InStudyNo  s IsExit="Y"
	   ..i (IsUpdate="1") d
	   ...s Upret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	  
	   i MutiStudyNoGroup="" d
	   .s MutiStudyNoGroup=InStudyNo
	   e  d
	   .s MutiStudyNoGroup=MutiStudyNoGroup_"@"_InStudyNo
	   
    	}
    q MutiStudyNoGroup
}*/
/// 按检查号生成规则判断产生一个或多个检查号
/// 默认没有配置生成规则,按医嘱号生成一个检查号
/// w ##class(web.DHCRisRegisterPatientDoEx).GetMutiStudyNo("3||107@3||111","","83","27/11/2015","3")
ClassMethod GetMutiStudyNo(InOrditmGroup As %String, GroupDesc As %String = "", GetLocDR As %String, SelectDate As %String, GroupDR As %String) As %String
{
	s MutiCount=0
	s MutiCount=$l(InOrditmGroup,"@")
	s MutiStudyNoGroup=""
	s IsExit="N",LastStudyNo=""

	for l=1:1:MutiCount 
    {
	   s StudyInfo="",gIsUpdate="",perOrditemID=""
	   s perOrditemID=$p(InOrditmGroup,"@",l)
	   s StudyInfo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNo(perOrditemID,GroupDesc,GetLocDR,SelectDate)
     
	   i StudyInfo'="" d
	   .s InStudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	   .s StudyNumber=$p($g(StudyInfo),"^",2)
       .s IsUpdate=$p($g(StudyInfo),"^",3)
	  
	   i IsExit="Y" s InStudyNo=LastStudyNo
	   s IsMore="N"
	   s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(GetLocDR,perOrditemID,GroupDesc)
	  
	   //多条医嘱产生多个检查号(前缀+日期+序号)
	   i (IsUpdate="1")
	   {
		   i (IsMore="Y") d
		   .s Upret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
		   e  d
		   .i (IsExit="N") d
		   ..s LastStudyNo=InStudyNo  s IsExit="Y"
		   ..i (IsUpdate="1") d
		   ...s Upret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	   }else
	   {    
		   i (IsExit="N") s LastStudyNo=InStudyNo
		   i (IsMore="N") s IsExit="Y"
	   }
	   
	   i MutiStudyNoGroup="" d
	   .s MutiStudyNoGroup=InStudyNo
	   e  d
	   .s MutiStudyNoGroup=MutiStudyNoGroup_"@"_InStudyNo
	   
    	}
    q MutiStudyNoGroup
}

/// 函数：AllowMutiOrditemRegister
/// 功能：根据计费设置判断多条医嘱是否允许登记（有一条不允许登记，则不能登记）
/// 返回：Y/N
/// w ##class(web.DHCRisRegisterPatientDoEx).AllowMutiOrditemRegister("3212||2")
ClassMethod AllowMutiOrditemRegister(MuitiOrditem As %String) As %String
{
	s ^TempRis("AllowMutiOrditemRegister")=MuitiOrditem
	s AllowReg="Y"
	s execList=""
	s count=$l(MuitiOrditem,"@")
	f i=1:1:count d
	.s perOrderItemBody=$p(MuitiOrditem,"@",i)
	.s perOrderItem=$p(perOrderItemBody,"$",1)
	.s bodyList=$p(perOrderItemBody,"$",2)
	.s paadmdr=$p(^OEORD($p(perOrderItem,"||",1)),"^",1)
  	.s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
  	.if patienttype="I" d
  	..i bodyList="" d
  	...;b //02
  	...s execChildsub=0 for  s execChildsub=$o(^OEORD($p(perOrderItem,"||",1),"I",$p(perOrderItem,"||",2),"X",execChildsub)) q:(execChildsub="")  d
  	....i $g(execInfo)="" s execInfo=perOrderItem_"||"_execChildsub_$c(2)_1
  	....e  s execInfo=execInfo_"^"_perOrderItem_"||"_execChildsub_$c(2)_1
  	....;w !,execInfo
  	..e  d 
  	...b //03
  	...s execInfoRet=##class(web.DHCAPPInterface).GetOeoriExec(perOrderItem,$Replace(bodyList,",","^"))
  	...;w !,execInfo
  	...for i=1:1:$l(execInfoRet,"^") d
  	....s execInfoTemp=$p(execInfoRet,"^",i)
  	....i execInfoTemp'="" d
  	.....i $g(execInfo)="" s execInfo=execInfoTemp_$c(2)_1
  	.....e  s execInfo=execInfo_"^"_execInfoTemp_$c(2)_1
  	..if $g(execInfo)'="" d
  	...if execList="" s execList=execInfo
  	...e  s execList=execList_"^"_execInfo
  	.else  if ((patienttype="O")||(patienttype="E"))  d
  	..s ret=##class(web.UDHCJFARREARSMANAGE).CheckArrears(paadmdr,perOrderItem_$c(2)_1,"RIS","")
  	..s flag=$p(ret,"^",7)
	..if flag="N" d
	...s AllowReg="N"
  	..;门诊医嘱增加医嘱状态的判断 分部位退回后会直接改变医嘱部位状态 wf 20190228
  	..b //01
  	..for ll=1:1:$l(bodyList,",") d
  	...s bodyRowidStatus=$p(bodyList,",",ll)
  	...s appOrderStatus=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(perOrderItem,bodyRowidStatus)
	...b //02
	...;w !,appOrderStatus
	...s appOrderStatus=$p(appOrderStatus,"^",1)
	...i ((appOrderStatus="D")||(appOrderStatus="C")) d
	....s AllowReg="N"
  	.e  d
	..s Ret=..CanRegisterArcItmMaster(perOrderItem)
	..i Ret="N" s AllowReg="N"
	
	if (execList'="" )
	{
		b //01
		s ret=##class(web.UDHCJFARREARSMANAGE).CheckArrears(paadmdr,execList,"RIS","")
		s flag=$p(ret,"^",7)
		if (flag="N")
		{
			s AllowReg="N"
		}
	}
	q AllowReg
}

/// 函数:RequestRegisterReturnParam
/// 功能:根据登记后医嘱获取其对应的检查号和流水号信息并回置前台
/// 返回:检查号@检查号@...^科室流水号^资源组流水号^诊间流水号
/// 作者:sunyi
/// w ##class(web.DHCRisRegisterPatientDoEx).RequestRegisterReturnParam("20017||3870@20017||3879")
ClassMethod RequestRegisterReturnParam(MuitiOrditem As %String, BodyCodeStr As %String) As %String
{
    s RegInfo="",ReturnInfo="",count=0
    s (LocNo,GroupNo,RoomNo,RecLocDR,MoreStudyNo)=""
    q:(MuitiOrditem="") ""
    s FistOrderItem=$p(MuitiOrditem,"@",1)
    s count=$l(MuitiOrditem,"@")
    s RecLocDR=$p($g(^OEORD($p(FistOrderItem,"||",1),"I",$p(FistOrderItem,"||",2),3)),"^",6)
    
    s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(FistOrderItem,BodyCodeStr) 
    s LocNo=$p($g(RegInfo),"^",4)
    s GroupNo=$p($g(RegInfo),"^",22)
    s RoomNo=$p($g(RegInfo),"^",23)
    
    f i=1:1:count d
    .s perOrderItem=$p(MuitiOrditem,"@",i)
    .s regID="",StudyNo=""
    .s regID=$o(^DHCPACRegInfoi("OEORI",perOrderItem,""))
    .i regID'="" s StudyNo=$p(^DHCPACRegInfo(regID),"^",2)
    .i MoreStudyNo="" d
    ..s MoreStudyNo=StudyNo
    .e  d
    ..s MoreStudyNo=MoreStudyNo_"@"_StudyNo

	s ReturnInfo=MoreStudyNo_"^"_LocNo_"^"_GroupNo_"^"_RoomNo
	
	q ReturnInfo
}

/// w ##class(web.DHCRisRegisterPatientDoEx).IsCanReg("20017||3870")
ClassMethod IsCanReg(oeorditemdr As %String) As %String
{
    s Reg="Y"
	q:(oeorditemdr="") "N"
	s Rptrowid=""
    s Rptrowid=$o(^DHCRBStudyi("Report-Oeorditm",oeorditemdr,""),-1)
    i Rptrowid'="" s Reg="N" 
    q Reg
}

/// w ##Class(web.DHCRisRegisterPatientDoEx).GetRegBillData("20017||3883")
/// sunyi 2013-07-26
/// 对于统一检查号的多条医嘱，合并打印。
ClassMethod GetRegBillData(MuitOeItemRowid As %String) As %String
{
	s (StudyNo,Name,Sex,Age,Date,Time,RecLoc,RecLocdr,ItemName,Index,IndexType)=""
	s (EQDesc,RoomDesc,perOrditemRowid,paadmdr,patienttype,papatmasmdr)=""
	s (RegNo,SexDr,DOB,strDOB,strToday,RegInfo,CheckGroupIndex,RoomIndex,EqIndex)=""
	s (CheckGroupDesc,No,INPNO,OPNO,InLocName,BedCode,InLocdr,beddr,EqDR,Info)=""
	
	s count=0
	s count=$l(MuitOeItemRowid,"@")

	for i=1:1:count d
	.s perOrditemRowid=$p($g(MuitOeItemRowid),"@",i)
	.s OrderRowid=$p(perOrditemRowid,"||",1)
	.s itemsub=$p(perOrditemRowid,"||",2)
	.s arcimid=""
	.i $d(^OEORD(OrderRowid,"I",itemsub,1)) s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.i arcimid'="" s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.i ItemName="" s ItemName=strOrderName
	.e  d
	..s ItemName=ItemName_","_strOrderName
	
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	i (paadmdr'="")
	{
		s InLocdr=$p(^PAADM(paadmdr),"^",4)
		i $g(InLocdr)'="" d
        .s InLocName=$p(^CTLOC(InLocdr),"^",2)
        .i $f(InLocName,"-")>0 d
        ..s InLocName=$p(InLocName,"-",2)
        
	    s patienttype=$p(^PAADM(paadmdr),"^",2)
	    s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	    i (papatmasmdr'="")
	    {
		    s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
	        s OPNO=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",4)   
		    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
		    s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
		    s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
	        i SexDr'="" s Sex=$p($g(^CT("SEX",SexDr)),"^",2) 
	        s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
	    }
        if (DOB="")
        {
	        s strDOB=""
 	 	    s Age=""
	    }
 	 	else
 	 	{ 
	        s strDOB=$ZD(DOB,3)
	        s strToday=$ZD(+$h,3)
	        s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
 	 	} 
 	 	
 	 	s beddr=$p(^PAADM(paadmdr),"^",73)
        s BedCode="",wardrowid="",bedchildsub=""
        i beddr'=""  d 
        .s wardrowid=$p(beddr,"||",1)
        .s bedchildsub=$p(beddr,"||",2)
        .i $g(bedchildsub)'="" s BedCode=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
        
	}
	
	if ((OrderRowid'="")&(itemsub'=""))
	{
		s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
		if RecLocdr'="" d
		.s RecLoc=$p(^CTLOC(RecLocdr),"^",2)
		.i $f(RecLoc,"-")>0 d
		..s RecLoc=$p(RecLoc,"-",2)
		
		s RegInfo=##Class(web.DHCRisCommFunctionEx).GetRegInfo(perOrditemRowid)
		i RegInfo'="" d
		.s StudyNo=$p(RegInfo,"^",1)
		.s Date=$p(RegInfo,"^",2)
		.s Time=$p(RegInfo,"^",3)
		.s EqIndex=$p(RegInfo,"^",4)
		.s RoomIndex=$p(RegInfo,"^",23)
		.s CheckGroupIndex=$p(RegInfo,"^",22)
		.s IndexType=$p(RegInfo,"^",26)
		.s EQDesc=$p(RegInfo,"^",5)
		.s RoomDesc=$p(RegInfo,"^",8)
		.s CheckGroupDesc=$p(RegInfo,"^",11)
		.s EqDR=$p(RegInfo,"^",10)
		.s No=$p(RegInfo,"^",13)
		.s Info=StudyNo_"^"_RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_RecLoc_"^"_ItemName_"^"_IndexType_"^"_$g(Index)_"^"_EQDesc_"^"_RoomDesc_"^"_CheckGroupDesc_"^"_patienttype_"^"_IPNO_"^"_OPNO_"^"_InLocName_"^"_BedCode_"^"_EqDR_"^"_No_"^"_Date_"^"_Time_"^"_EqIndex_"^"_RoomIndex_"^"_CheckGroupIndex_"^"_RecLocdr
		
	}
	
	q Info
}

/// w ##class(web.DHCRisRegisterPatientDoEx).IsSameSubCat("3||64@3||110")
/// 判断是否是同一医嘱子类
/// add by qzg 20150919
ClassMethod IsSameSubCat(OEOrdItmIDArray As %String) As %String
{
	 s isSame="Y"
	 s subCatDescOld=""
	 s subCatDesc = ""
     s countArray=0
	 s countArray=$l(OEOrdItmIDArray,"@")
     for j=1:1:countArray 
     {  
        q:(isSame="N")
        s perOrditemID=$p(OEOrdItmIDArray,"@",j)
        s OrderRowid=$p(perOrditemID,"||",1)
        s itemsub=$p(perOrditemID,"||",2)
        s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
        s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
		s subCatDesc=$p(^ARC("IC",ItmCatDR),"^",2) ; 医嘱子类
		i subCatDescOld="" s subCatDescOld=subCatDesc
		i subCatDesc'=subCatDescOld  d 
		.s isSame="N"
		e  d
		.s subCatDescOld=subCatDesc

     }
     
     q isSame
}

/// w ##Class(web.DHCRisRegisterPatientDoEx).isSamePatient("3||111@3||107@3||64")
ClassMethod isSamePatient(MuitOeItemRowid As %String) As %String
{
	s ^Temp("isSamePatient")=MuitOeItemRowid
	s ret="Y"
	s patientIdGet=""
	for numOrder=1:1:$l(MuitOeItemRowid,"@")
	{
		s orderItemBody=$p(MuitOeItemRowid,"@",numOrder)
		if (orderItemBody="")
		{
			continue	
		}
		s orderDrSame=$p(orderItemBody,"$",1)
		if (orderDrSame="")
		{
			continue
		}
		s OrderItemRowidSame=""
		s OrderItemRowidSame=$p(orderDrSame,"||",1)
		s paadmdrSame=$p(^OEORD(OrderItemRowidSame),"^",1)     
		s padmatSame=$p(^PAADM(paadmdrSame),"^",1) 
		s padmatidSame=$p($g(^PAPER(padmatSame,"PAT",1)),"^",1)
		;w !,OrderItemRowidSame_"**"_paadmdrSame_"**"_padmatSame_"**"_padmatidSame
		if ( (patientIdGet'="") &&(patientIdGet'=padmatidSame))
		{
			s ret="N"
		}
		else
		{
			s patientIdGet=padmatidSame
		}
	}
	q ret
}

// wf 20150922

ClassMethod isInList(item, list) As %String
{
	s isIn="N"
	s len=$l(list,"@")
	for j=1:1:len
	{
		;w !,"j="_j
		q:(isIn="Y")
		s itemGet=$p(list,"@",j)
		if (itemGet=item)
		{
			s isIn="Y"
		}
	}
	q isIn
}

// wf 20151014

// w ##class(web.DHCRisRegisterPatientDoEx).hasSameRecord("1@2@3","4@5@6")

ClassMethod hasSameRecord(listOne, list) As %String
{
	s isSame="N"
	s lenOne=$l(listOne,"@")
	for jj=1:1:lenOne
	{
		;w !,"jj="_jj
		q:(isSame="Y")
		s itemOne=$p(listOne,"@",jj)
		if (itemOne'="" )
		{
			s isHave=..isInList(itemOne,list)
			if (isHave="Y")
			{
				s isSame="Y"
			}
		}	
	}
	q isSame
}

// w ##class(web.DHCRisRegisterPatientDoEx).RegBdyPart("14938","32^31^")

ClassMethod RegBdyPart(rowid, BodyInfo As %String = "") As %String
{
    s ^panbody=rowid
	s SQLCODE=0
	N (rowid,BodyInfo)
	s BodyList=##Class(web.DHCRisWorkBenchDoEx).GetBodyPart(BodyInfo)
    s Num=$l(BodyList,"^")
    f j=1:1:Num  d 
    .s BodyPart=$p(BodyList,"^",j)
    .s BodyId=$p(BodyPart,":",1)
    .s BodyDesc=$p(BodyPart,":",2)
    .s BodyCode=""
    .&sql(select AP_Code into:BodyCode from DHC_AppPart where AP_RowId=:BodyId)
    .&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR,RRB_BodyPart_Code,RRB_BodyPart_Desc ) values (:rowid,:BodyId,:BodyCode,:BodyDesc))
    q SQLCODE
}

// wf 20160730 登记用于河南省人民医院

// w ##class(web.DHCRisRegisterPatientDoEx).register()

// orderBodyList+"^"+EQDR+"^"+RoomDR+"^"+EQGroupDR+"^"+userid+"^"+AssiantDocDR+"^"+MainDocDR+"^"+TelNo+"^"+weight+"^"+locdr;

ClassMethod register(Info) As %String
{
	//
	s ^TempDHCRis("DHCRisRegister.register")=Info
	//分解参数
	//q "1"
	
	s listOrderItemBody=$p(Info,"^",1)
	s RegEQDr=$p(Info,"^",2)
	s RoomDR=$p(Info,"^",3)
	s EQGroupDR=$p(Info,"^",4)
	s operateDocDr=$p(Info,"^",5)   //RAR_SSUSER_DR
	s AssDocDr=$p(Info,"^",6)
	s MainDocDr=$p(Info,"^",7)
	s TelNo=$p(Info,"^",8)   //RAR_SSUSER_DR
	s Weight=$p(Info,"^",9)
	s recLocDr=$p(Info,"^",10)
	s UgentFlag=$p(Info,"^",11)
	
	s RegDate=+$h
	s RegTime=$p($h,",",2)
	

	//先判断是不是同一个病人的医嘱
	s isSamePat=..isSamePatient(listOrderItemBody)
	q:(isSamePat="N") "-11111"
	   
    //有停止的医嘱不允许一起登记
    s Exist=""
    s Exist=##class(web.DHCRisCommFunctionEx).ExistStopItem(listOrderItemBody)
    i Exist="Y" lock -(^DHCRisTMPReg)
    q:(Exist="Y") -10006
    
    //是否有已登记记录
    s isRegister=..hasRegisterItem(listOrderItemBody)
    q:(isRegister="Y") -10007
    
    //如果病人已经出院或最终结算，则不能更改
    s orderListBodyJudge=$p(listOrderItemBody,"@",1)
    s orderRowidJudge=$p(orderListBodyJudge,"$",1)
    s GetPaadmID=$p(^OEORD($p(orderRowidJudge,"||",1)),"^",1)
    i (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","GetCurrentDischargeStatus") )
    {
	    s disChargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(GetPaadmID)
	    q:((disChargeStatus="F")||(disChargeStatus="T")) "-10003"
    }
    else
    {
	    q:($p(^PAADM(GetPaadmID),"^",17)'="")&&(($p(^PAADM(GetPaadmID),"^",2))="I") "-10003"
    }
     // 医嘱对应的就诊记录是否一致
    /*
    s OEORIDr=$p(MuitOEORIDr,"@")
    s OrderID=$p(OEORIDr,"||",1)
    s GetPaadmID=$p(^OEORD(OrderID),"^",1)
    i (paadr'=GetPaadmID) lock -(^DHCRisTMPReg)
    q:paadr'=GetPaadmID -10002 

	//判断此病人是否出院
	s Status=$p(^PAADM(GetPaadmID),"^",20)
	i (Status="D") lock -(^DHCRisTMPReg)
	q:Status="D" -10003 	
	*/
	
	/*s Arrearage=""
	s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(paadr,"A","完全控制")
	i (Arrearage="1") lock -(^DHCRisTMPReg)
	i Arrearage="1" q -10004
	*/
	;根据系统配置判断未收费的应允许一块进行登记
	s ret=##class(web.DHCRisRegisterPatientDoEx).AllowMutiOrditemRegister(listOrderItemBody)
	i ret="N" lock -(^DHCRisTMPReg)  
	q:ret="N" -10001
    s RCODE=0
	
    
	Set $ZT="ERROR"	
    lock +(^DHCRisTMPReg)  
    s SQLCODE=0
    
    TSTART
    
    s (StudyNoList,studyNo,locNum,groupNum,roomNum)=""
	s regTime=$p($h,",",2)
	s regDate=+$h
	s studyNo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNoNew(listOrderItemBody,"",recLocDr)
	;w !,"studyNo="_studyNo
	if (studyNo="")
	{
		tro	
		lock -(^DHCRisTMPReg)
		quit
	}

	;获取流水号
	s locNum=##class(web.DHCRisRegisterPatientDoEx).GetCurentIndex(recLocDr)  ;,regDate)
	//w !,"locNum="_locNum
	/*if ( rbcEquipmentGroupDr'="" )
	{
		s groupNum=##class(web.DHCRisRegisterPatientDoEx).GetGroupIndex(rbcEquipmentGroupDr)  ;,regDate)
	}*/
	s roomNum=""
	if (RoomDR'="" )
	{
		s roomNum=##class(web.DHCRisRegisterPatientDoEx).GetRoomIndex(RoomDR) ;;,regDate)
	}
	//w !,"roomNum="_roomNum
    
    //E:执行状态
    //根据传入的检查号， 在后台重新获取检查号，如果插入登记插入失败回滚更新的检查号
    ;b //1
    s (papatmasmdr)=""
    s count=$l(listOrderItemBody,"@")
    for i=1:1:count d
    .;b //01
    .s orderItemBody=$p(listOrderItemBody,"@",i)
    .s perOrditemRowid=$p(orderItemBody,"$",1)
    .s paadmDr=$p(^OEORD($p(perOrditemRowid,"||",1)),"^",1)
	.s papatmasmdr=$p(^PAADM(paadmDr),"^",1)
    .s bodyList=$p(orderItemBody,"$",2)
    .s perOrditemRowidbodyList=perOrditemRowid_"^"_bodyList
    .;s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(perOrditemRowid,"E",SSUSERDr)
    .;s Now=$zd(+$H,8)_$zt($p($h,",",2))
    .;s UserCode=""
    .;i operateDocDr'="" s UserCode=$p(^SSU("SSUSR",operateDocDr),"^",1) 
    .s ^TempDHCRis("regInfo")=MainDocDr_"^"_AssDocDr_"^"_perOrditemRowid_"^"_paadmDr_"^"_RegEQDr_"^"_RegDate_"^"_recLocDr_"^"_RegTime_"^"_operateDocDr_"^"_studyNo_"^"_locNum_"^"_RoomDR_"^"_EQGroupDR_"^"_""_"^"_""_"^"_roomNum_"^"_UgentFlag
    .&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_RoomIndex,RAR_Note5)
                             values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadmDr,:RegEQDr,:RegDate,:recLocDr,:RegTime,:operateDocDr,:studyNo,:locNum,:RoomDR,:EQGroupDR,:roomNum,:UgentFlag))
    .;b //register
    .s rowid=$p(%ROWID,$c(1))
    .i bodyList'=""  d
    ..;s regsql=##class(web.DHCRisRegisterPatientDoEx).RegBdyPart(rowid,BodyInfo) 
    ..s bodyLength=$l(bodyList,",")
    ..for bodyNum=1:1:bodyLength d
    ...s bodyRowid=$p(bodyList,",",bodyNum)
    ...s BodyCode=$p(^DHCAPPART(bodyRowid),"^",1)
    ...s BodyDesc=$p(^DHCAPPART(bodyRowid),"^",2)
    ...&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR,RRB_BodyPart_Code,RRB_BodyPart_Desc ) values (:rowid,:bodyRowid,:BodyCode,:BodyDesc) )
    ...;b //bodypart
    .;b //ORMO01XX
    .s registerOrm(perOrditemRowidbodyList)=studyNo
    .;s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowidbodyList,"SC",Now,studyNo,UserCode,"Y")
	.;b //ORMO01XX return
    ;b //03
	I SQLCODE TRollback
	I SQLCODE lock -(^DHCRisTMPReg)  
	I SQLCODE q SQLCODE
   
	d ..UpdateIndex(recLocDr,locNum)
	//d ..UpdateGroupIndex(EQGroupDR,GroupIndex,RegDate)
	d ..UpdateRoomIndex(RoomDR,roomNum) 

	
    s Now=$zd(+$H,8)_$zt($p($h,",",2))
    s UserCode=""
    s success="Y"
    i operateDocDr'="" s UserCode=$p(^SSU("SSUSR",operateDocDr),"^",1) 
    s orderGet="" f  s orderGet=$o(registerOrm(orderGet)) q:(orderGet="")  d
    .s ret=##class(RISService.TrakRISService).ORMO01XX(orderGet,"SC",Now,registerOrm(orderGet),UserCode,"Y")
    .if ret'="0" s success="N"

    
    k registerOrm
    
    if (success="N")
    {
	    TRollback
		lock -(^DHCRisTMPReg)  
		q SQLCODE
    }
    
	//s papatmasdr=$p(^PAADM(paadr),"^",1)
	//&sql(update MR_Adm SET MRADM_Weight=:Weight where MRADM_Rowid=:mrrowid)
     //update 住院号
    //&sql(update PA_PATMAS set PAPMI_Medicare=:IpNo where PAPMI_RowId=:papatmasdr)
    //update 电话号
    /*if (papatmasmdr'="")
    {
    	&sql(update pa_person set PAPER_TelH =:TelNo where PAPER_Rowid=:papatmasmdr) 
    }
    */
    b //commit
  	TCOMMIT
  	/*
  	;BILL病人的账单
	if ($g(^DHCRisCheckFee)="Y")
	{
    	s rtn=##Class(web.UDHCJFBILLIP).BILLN(paadr,SSUSERDr,OEORIDr)
    }
    */
  	//do ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4(MuitOEORIDr)
  	
  	
    
  	lock -(^DHCRisTMPReg)     		       //回滚事务
  	//d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000005",MuitStudyNo) //调平台接口,给第三方传消息
 	
 	
 	//
 	
 	s count=$l(listOrderItemBody,"@")
    for i=1:1:count
    {
    	
   		s orderItemBody=$p(listOrderItemBody,"@",i)
    	s perOrditemRowid=$p(orderItemBody,"$",1)
    	s bodyList=$p(orderItemBody,"$",2)
    
    
    	i bodyList'=""
    	{
    	 
    		s bodyLength=$l(bodyList,",")
    		for bodyNum=1:1:bodyLength 
    		{
    			s bodyRowid=$p(bodyList,",",bodyNum)
    			s bookRowid=..getBookDetailRowid(perOrditemRowid,bodyRowid)
    			if (bookRowid'="")
    			{
	    			if ($d(bookList(bookRowid,perOrditemRowid)))
	    			{
	    				s bookList(bookRowid,perOrditemRowid)=bookList(bookRowid,perOrditemRowid)_","_bodyRowid
	    			}
	    			else
	    			{
		    			s bookList(bookRowid,perOrditemRowid)=bodyRowid
	    			}
    			}
    		}
    	}
    	else
    	{
	    	s bookRowid=..getBookDetailRowid(perOrditemRowid,"")
	    	if (bookRowid'="")
	    	{
		    	s bookList(bookRowid,perOrditemRowid)=""
	    	}
    	}
    }
    
    s bookId="" f  s bookId=$o(bookList(bookId)) q:(bookId="")  d
    .s bookNo=$p(^DHCRBCResSchduleDetail("Detail",bookId),"^",6)
    .s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(bookNo,"B")
    .s orderRowidGet="" f  s orderRowidGet=$o(bookList(bookId,orderRowidGet)) q:(orderRowidGet="")  d
    ..s cancelRet=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNo,orderRowidGet,bookList(bookId,orderRowidGet),"Y")
 	..s ^DHCRisTemp("Register",orderRowidGet,bookNo)=$lb(bookNo,orderRowidGet,bookList(bookId,orderRowidGet),"Y",cancelRet)
 	//do ##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNo,OrderItemRowid,bodyRowid,"Y")
 	
 	d ##class(RISService.InvokeRISService).InsertStudyInfoPACS(studyNo)
 	//do ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4(studyNo)
	
	
	
	//调用接口
	//状态接口 	
   	if ($g(operateDocDr)'="")
   	{
	   	s userName=$p($g(^SSU("SSUSR",operateDocDr)),"^",2)
	   	//2019/09/25修复Ens_Status、Ens_Statuslog表中“ES_OperatorID”字段值错误的问题
	   	s userID = $p($g(^SSU("SSUSR",operateDocDr)),"^",1)
   	}
   	//##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus("59||35","222",studyNo,"SC",$g(operateDocDr),$g(userName))
	s Count=$l(listOrderItemBody,"@")
    for num=1:1:Count 
    {
      s perOrditemRowid=$p(listOrderItemBody,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyListNoBook=""
	      s bodyLength=$l(bodyList,",")
	      s bodyDescList=""
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      
		      if (bodyRowid'="")
		      {
			      s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			      if bodyDescList= "" s bodyDescList=bodyDesc
			      else  s bodyDescList=bodyDescList_"@@"_bodyDesc
		      }
		      
	      }	      
	      s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,bodyDescList,studyNo,"SC",$g(userID),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,bodyDescList,$zd(+$h,3),$zt($p($h,",",2),1))=studyNo_"^"_"SC"_"^"_$g(userID)_"^"_$g(userName)_"^"_$g(ret)
	      
      }
      else
      {

      	  s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,"",studyNo,"SC",$g(userID),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=studyNo_"^"_"SC"_"^"_$g(userID)_"^"_$g(userName)_"^"_$g(ret)

      }
      
    }
    
    /*
	//ris4.0
	s bookNoList=""
	s bookNo=""
 	s insertObj=##class(RISService.BookPlatformClass.InsertStudyInfo).%New()
 	s insertObj.StudyNo=studyNo
 	s insertObj.BookOrArrive="Arrive"
 	
 	s Count=$l(listOrderItemBody,"@")
    for num=1:1:Count 
    {
	    s itemObj=##class(RISService.BookPlatformClass.Item).%New()
	    
      s perOrditemRowid=$p(listOrderItemBody,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyListNoBook=""
	      s bodyLength=$l(bodyList,",")
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      if (bodyRowid'="")
		      {
			      s BodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",1)
			      s rowid=..getRegRowid(perOrditemRowid,bodyRowid)
			      s bookRowid=..getBookDetailRowid(perOrditemRowid,bodyRowid)
			      if (bookRowid'="")
			      {
				      s bookNoGet=$p(^DHCRBCResSchduleDetail("Detail",bookRowid),"^",6)
				      //studyInfo的booknolist
				      if ( '$d(bookNo(bookNoGet)))
				      {
					      if bookNoList="" s bookNoList=bookNoGet
					      e  s bookNoList=bookNoList_"^"_bookNoGet
				      }
				      s bookNo(bookNoGet)=""
				      if ($d(bodylist(bookNoGet)))
				      {
					      s bodylist(bookNoGet)=BodyCode
				      }
				      else
				      {
					      s bodylist(bookNoGet)=bookNoList(bookNoGet)_","_BodyCode
				      }
			      }
			      else
			      {
				      if bodyListNoBook="" s bodyListNoBook=BodyCode
				      e  s bodyListNoBook=bodyListNoBook_"^"_BodyCode
				      
			      }
			     
		      }
	      }
	      s bodyCodeList=""
	      s bookRowid=""
	      s no=""
	      for 
	      {
		      s no=$o(bodylist(no)) q:(no="")
		      if bodyCodeList="" s bodyCodeList=bodylist(no)
		      e  s bodyCodeList=bodyCodeList_"^"_bodylist(no)
		      if bookRowid="" s bookRowid=no
		      e  s bookRowid=bookRowid_"^"_no
		      
	      }
	      k bodylist
	      if (bodyCodeList'="")
	      {
	       	s itemObj.BodyCodeList=bodyCodeList
	       	s itemObj.BookNumber=bookRowid
			      s itemObj.OEORowid=perOrditemRowid
			      s itemObj.Rowid=rowid
			      d insertObj.Items.Insert(itemObj)
	      }
			      
	     if (bodyListNoBook'="")
	     {
		     s itemObj.BodyCodeList=bodyListNoBook
	       	s itemObj.BookNumber=""
			      s itemObj.OEORowid=perOrditemRowid
			      s itemObj.Rowid=rowid
			      d insertObj.Items.Insert(itemObj)
	     }
      }
      else
      {

      	  s rowid=..getRegRowid(perOrditemRowid,"")
      	  s bookRowidNoBody=..getBookDetailRowid(perOrditemRowid,"")
      	  if (bookRowidNoBody="")
      	  {
      	  	s bookNoGetNoBody=$p(^DHCRBCResSchduleDetail("Detail",bookRowidNoBody),"^",6)
      	  	
      	  	  if ( '$d(bookNo(bookNoGetNoBody)))
		      {
			      if bookNoList="" s bookNoList=bookNoGetNoBody
			      e  s bookNoList=bookNoList_"^"_bookNoGetNoBody
		      }
		      s bookNo(bookNoGetNoBody)=""
      	  }
	      s itemObj.BodyCodeList=""
	      s itemObj.BookNumber=$g(bookNoGetNoBody)
	      s itemObj.OEORowid=perOrditemRowid
	      s itemObj.Rowid=rowid
	      d insertObj.Items.Insert(itemObj)
      	
      }
      //s OrdRowid=$p(perOrditemRowid,"||",1)
      //s itemsub=$p(perOrditemRowid,"||",2)
	  //s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
    }
    s insertObj.BookNumberList=bookNoList
    s info=##Class(RISService.BookPlatformInterface).WriteXmlToStream(insertObj,"")
    s ret=##Class(RISService.BookPlatformInterface).InsertStudyInfoPACS(info)
    s ^DHCRisTemp("sendRegToRis",studyNo,$zd(+$h,3),$zt($p($h,",",2),1))=info_"^"_ret
	*/
	
	
 	Quit SQLCODE
 	
           
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	b //error
	s ^TempDHCRis("registerError")=ErrorMsg_"^"_listOrderItemBody
 	TROLLBACK
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit "-0001"
}

ClassMethod getBookDetailRowid(orderItemRowid As %String, bodyRowid As %String = "") As %String
{
	n (orderItemRowid,bodyRowid)
	s retRowid=""

	s ResDetailRowid=""
	for 
	{
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderItemRowid,ResDetailRowid)) 
		q:(ResDetailRowid="")
		
		if (bodyRowid'="")
		{
		    s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid,bodyRowid,0))
		    if (detailBodyRowid'="")
		    {
			   s retRowid=ResDetailRowid
		    }
		}
		else
		{
			s retRowid=ResDetailRowid
		}
	   
		
	}

	q retRowid
}

// wf  20160730 生成检查号，传入医嘱串，生成一个检查号

// 生成检查号，暂时不考虑EQGroup

// w ##class(web.DHCRisRegisterPatientDoEx).GetStudyNoNew()

ClassMethod GetStudyNoNew(orditmrowid, EQGroup, LocDr, SelectDate = "") As %String
{
	s ^DHCRisTemp("GetStudyNoNew")=orditmrowid_"^"_EQGroup_"^"_LocDr_"^"_SelectDate
	s rowid="",AppType="",ItmCatRowid="",OperationDR="",IsCreateType=""
	//s EQGoupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGoup)
	//s ItmCatRowid=##class(web.DHCRisCodeTableAdd).GetItmCatDR(orditmrowid)

	
	//i EQGoupDr'="" s rowid=$o(^DHCPACRegInfoCRi("LocEQGroupRule",LocDr,EQGoupDr,rowid))
	//i ((ItmCatRowid'="")&(rowid="")) s rowid=$o(^DHCPACRegInfoCRi("SubOrderCat",ItmCatRowid,rowid))
	//if rowid="" 
	s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	/*
	i rowid'="" d
	.s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",5)
	.s OperationDR=$p(^DHCPACRegInfoCR("CreateRule",0,rowid),"^",7)
	.i OperationDR'="" s IsCreateType=$p($g(^DHCRBCStatus("PatientStatus",OperationDR)),"^",1)
	*/

	if (rowid'="") 
	{
		s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
		s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
		
		if (Number="t")!(Number="T") 
		{
			/*if (SelectDate="")
			{
				
			}
			else 
			{
				s currentdatedigital=$zdh(SelectDate,4)
				s currentdate=$zd(currentdatedigital,8)
			} 
			*/
			s currentdate=$zd(+$h,8)
			
			if $g(^DHCRisStudyNoDate(LocDr,currentdate))=""  s ^DHCRisStudyNoDate(LocDr,currentdate)=0
			s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
			s Number=Number+1
			
			s Prefix=Prefix_currentdate
			;判断是否已经使用，找到一个未使用的检查号
			
			s isFind="N"
			
			while(isFind'="Y")
			{
				s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
				s studyNoFind=Prefix_"-"_Number
				s detailDrFind=""
				s regInfoDrFind=""
				//s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
				s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
				if (regInfoDrFind="")
				{
					s isFind="Y"
				}
				else
				{
					s Number=Number+1
				}
			}
			s ^DHCRisStudyNoDate(LocDr,currentdate)=Number
		}
		else 
		{
			s Number=Number+1
			s isFind="N"
			while(isFind'="Y")
			{
				s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
				s studyNoFind=Prefix_"-"_Number
				s detailDrFind=""
				s regInfoDrFind=""
				//s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
				s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
				if (regInfoDrFind="")
				{
					s isFind="Y"
				}
				else
				{
					s Number=Number+1
				}
			}
			
			&sql(update DHCRB_StudyNo_Createrule set RSC_MaxNumber=:Number where RSC_Rowid =:rowid)
		}
		
		s StudyNo=Prefix_"-"_Number
	}
	else
	{
		//找默认的检查号 医嘱Rowid 
		s orderBodyList=$p(orditmrowid,"@",1)
		s orderItemRowid=$p(orderBodyList,"$",1)
		s orderRowid=$p(orderItemRowid,"||",1)
		s itemSub=$p(orderItemRowid,"||",2)
		s Prefix=orderRowid_"-"_itemSub
		s Number=1
		s isFind="N"
			
		while(isFind'="Y")
		{
			s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
			s studyNoFind=Prefix_"-"_Number
			
			s detailDrFind=""
			s regInfoDrFind=""
			//s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
			s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
			if (regInfoDrFind="")
			{
				s isFind="Y"
			}
			else
			{
				s Number=Number+1
			}
		}
		
		s StudyNo=Prefix_"-"_Number
		
	}
   
	q StudyNo
}

/// 打印登记单函数
/// pan
/// input:检查号
/// w ##class(web.DHCRisRegisterPatientDoEx).GetRegBillDataNew("CS-018")
ClassMethod GetRegBillDataNew(StudyNo As %String) As %String
{
	s ^pan(20160730)=StudyNo
	q:(StudyNo="") ""
	
	s MuitOeItemRowidBp=""
	s BodyPartDR=""
	s ItemName=""
	s RegRowid=0 f  s RegRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowid)) q:RegRowid=""  d
    .;w !,"RegRowid="_RegRowid
    .s OEDRowid=$p($g(^DHCPACRegInfo(RegRowid)),"^",11)
    .s BodyPartDR=""
	.;i oeorditemrowid'="" s oeorditemrowid=oeorditemrowid_"@"_OEDRowid
	.;E  s oeorditemrowid=OEDRowid
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,RegRowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,RegRowid,ChildSub),"^",1) 
	..i BodyPartDR'="" s BodyPartDR=BodyPartDR_","_BodyDr
	..E  s BodyPartDR=BodyDr
	.;b //02
	.i MuitOeItemRowidBp'="" s MuitOeItemRowidBp=MuitOeItemRowidBp_"@"_OEDRowid_"$"_BodyPartDR
	.E  s MuitOeItemRowidBp=OEDRowid_"$"_BodyPartDR
	b //01
	s RegInfo=##class(web.DHCRisRegisterPatientDoEx).GetRegNameNewData(MuitOeItemRowidBp)
	q RegInfo
}

/// w ##class(web.DHCRisRegisterPatientDoEx).GetRegNameNewData("3||134^200*3||135^200@203")
ClassMethod GetRegNameNewData(MuitOeItemRowidBp As %String) As %String
{
	
	s ^DHCRisTemp("GetRegNameNewData")=MuitOeItemRowidBp
	s count=0
	s count=$l(MuitOeItemRowidBp,"@")
	s ItemName="",BodyPartDR=""
	for i=1:1:count d
	.s perOrditemRowid=$p($g(MuitOeItemRowidBp),"@",i)
	.q:(perOrditemRowid="")
	.s OrditemRowid=$p($g(perOrditemRowid),"$",1)
	.s BodyPartDR=$p($g(perOrditemRowid),"$",2)
	.s OrderRowid=$p($g(OrditemRowid),"||",1)
	.s itemsub=$p($g(OrditemRowid),"||",2)
	.s arcimid="",BodyPartData=""
	.i $d(^OEORD(OrderRowid,"I",itemsub,1)) d
	..s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	i (paadmdr'="")
	{
		s InLocdr=$p(^PAADM(paadmdr),"^",4)
		i $g(InLocdr)'="" d
        .s InLocName=$p(^CTLOC(InLocdr),"^",2)
        .i $f(InLocName,"-")>0 d
        ..s InLocName=$p(InLocName,"-",2)
        
	    s patienttype=$p(^PAADM(paadmdr),"^",2)
	    s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	    i (papatmasmdr'="")
	    {
		    s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(papatmasmdr)   //获得住院号
	        s OPNO=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",4)   
		    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
		    s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
		    s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
	        i SexDr'="" s Sex=$p($g(^CT("SEX",SexDr)),"^",2) 
	        s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
	        s CardNo=""
			s RowId=0  f  s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papatmasmdr,RowId)) q:RowId=""  d
			.s ActiveFlag=$p($g(^DHCCARD("CF",RowId)),"^",10)
			.i ActiveFlag="N" d  
			..s CardNo=$p($g(^DHCCARD("CF",RowId)),"^",2)
	    }
        if (DOB="")
        {
	        s strDOB=""
 	 	    s Age=""
	    }
 	 	else
 	 	{ 
	        s strDOB=$ZD(DOB,3)
	        s strToday=$ZD(+$h,3)
	        s Age= ##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,paadmdr)
	        //s Age=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
 	 	} 
 	 	
 	 	s beddr=$p(^PAADM(paadmdr),"^",73)
        s BedCode="",wardrowid="",bedchildsub=""
        i beddr'=""  d 
        .s wardrowid=$p(beddr,"||",1)
        .s bedchildsub=$p(beddr,"||",2)
        .i $g(bedchildsub)'="" s BedCode=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
        
	}
	
	if ((OrderRowid'="")&(itemsub'=""))
	{
		s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
		if RecLocdr'="" d
		.s RecLoc=$p(^CTLOC(RecLocdr),"^",2)
		.i $f(RecLoc,"-")>0 d
		..s RecLoc=$p(RecLoc,"-",2)
		;w !,"OrditemRowid="_OrditemRowid
		s RegInfo=##Class(web.DHCRisCommFunctionEx).GetRegInfo(OrditemRowid,"")
		i RegInfo'="" d
		.s StudyNo=$p(RegInfo,"^",1)
		.s Date=$p(RegInfo,"^",2)
		.s Time=$p(RegInfo,"^",3)
		.s EqIndex=$p(RegInfo,"^",4)
		.s RoomIndex=$p(RegInfo,"^",23)
		.s CheckGroupIndex=$p(RegInfo,"^",22)
		.s IndexType=$p(RegInfo,"^",26)
		.s EQDesc=$p(RegInfo,"^",5)
		.s RoomDesc=$p(RegInfo,"^",8)
		.s CheckGroupDesc=$p($g(RegInfo),"^",11)
		.s EqDR=$p(RegInfo,"^",10)
		.s No=$p(RegInfo,"^",13)
		.s Info=StudyNo_"^"_RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_RecLoc_"^"_IndexType_"^"_$g(Index)_"^"_EQDesc_"^"_RoomDesc_"^"_CheckGroupDesc_"^"_patienttype_"^"_IPNO_"^"_OPNO_"^"_InLocName_"^"_BedCode_"^"_EqDR_"^"_No_"^"_Date_"^"_Time_"^"_EqIndex_"^"_RoomIndex_"^"_CheckGroupIndex_"^"_RecLocdr_"^"_CardNo
		
	}
	s ItemName=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(MuitOeItemRowidBp)
	s ItemName=$EXTRACT(ItemName,1,15)_$c(13,10)_"  "_$e(ItemName,16,31)_$c(13,10)_"   "_$e(ItemName,32,$l(ItemName))
	q Info_"^"_ItemName
}

/// w ##class(web.DHCRisRegisterPatientDoEx).GetRegBodyPartData("8039@8040")
ClassMethod GetRegBodyPartData(BodyPartDR As %String) As %String
{
	  s ^BodyPartDR("2016")=BodyPartDR
	  s BPcont=$l(BodyPartDR,"@")
	  s BodyPartName="",PartDesc=""
	  for dr=1:1:BPcont d
	  .S BodyDr=$P(BodyPartDR,"@",dr)
	  .s PartDesc=$p($g(^DHCAPPART(BodyDr)),"^",2)
	  .;w !,"PartDesc="_PartDesc
	  .i BodyPartName'="" s BodyPartName=BodyPartName_","_PartDesc
	  .E  s BodyPartName=PartDesc
	  s BodyPartName="("_BodyPartName_")"
	  q BodyPartName
}

/// 根据设备的id获取设备获得设备组名称（检查室）和设备获得房间名称
/// input:EQDR    output:EQGroupInfo,RoomInfo
/// 
/// w ##class(web.DHCRisRegisterPatientDoEx).GetRegGroupRoom("54")
ClassMethod GetRegGroupRoom(EQDR As %String) As %String
{
  s EQDR=EQDR	
  s EQGroupInfo=##class(web.DHCRisCommFunction).GetEQGroup(EQDR)
  s RoomInfo=##class(web.DHCRisCommFunction).GetRoomByEQ(EQDR)
  s ret=$g(EQGroupInfo)_"@"_$g(RoomInfo)
  q ret
}

// 根据登记医嘱串，获取申请单号串("^")

// w ##class(web.DHCRisRegisterPatientDoEx).getAppBillNo("")

ClassMethod getAppBillNo(orderItemList As %String) As %String
{
	s ^TempDHCRis("getAppBillNo")=orderItemList
	s ret=""
	s appBillNo=""
	for numOfOrder=1:1:$l(orderItemList,"@")
	{
		s orderBodyList=$p(orderItemList,"@",numOfOrder)
		s ordItemRowid=$p(orderBodyList,"$",1)
		s billNo=##Class(web.DHCAPPInterface).GetExaReqNo(ordItemRowid)
		if (billNo'="")
		{
			s appBillNo(billNo)=ordItemRowid
		}
	}
	s billNo=""
	for
	{
		s billNo=$o(appBillNo(billNo))
		q:(billNo="")
		if (ret="")
		{
			s ret=billNo
		}
		else
		{
			s ret=ret_"^"_billNo
		}
	}
	
	q ret
}

/// 是否有已经登记过的记录
/// wf  20160805 入参为  医嘱rowid$部位,部位@医嘱
/// w ##class(web.DHCRisRegisterPatientDoEx).hasRegisterItem("1666||5$3146")
ClassMethod hasRegisterItem(listOrderItemBody) As %String
{
	s ^TempDHCRis("hasRegisterItem")=listOrderItemBody
	s ret="N"
	for num=1:1:$l(listOrderItemBody,"@")
	{
		s orderbodylist=$p(listOrderItemBody,"@",num)
		s orderitemRowid=$p(orderbodylist,"$",1)
		s bodyList=$p(orderbodylist,"$",2)
		s reginfoRowid=""
		for
		{
			s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",orderitemRowid,reginfoRowid))
			q:(reginfoRowid="")
			if (bodyList="")
			{
				s ret="Y"
			}
			if (bodyList'="")
			{
				s childSub=""
				for 
				{
					s childSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub))
					q:(childSub="")
					s bodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub),"^",1)
					if (..isExistInGroup(bodyList,bodyDr)=1)
					{
						s ret="Y"
					}
				}
			}
		}
	}
	
	q ret
}

ClassMethod getRegRowid(orderItemRowid As %String, bodyRowID As %String = "") As %String
{
	s ^TempDHCRis("getRegRowid")=$lb(orderItemRowid,bodyRowID)
	
	n (orderItemRowid,bodyRowID)
	s rowidRet=""
	s reginfoRowid=""
	for
	{
		s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",orderItemRowid,reginfoRowid))
		q:(reginfoRowid="")
		if (bodyRowID="")
		{
			s rowidRet=reginfoRowid
		}
		else
		{
			s childSub=""
			for 
			{
				s childSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub))
				q:(childSub="")
				s bodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub),"^",1)
				if (bodyDr=bodyRowID )
				{
					s rowidRet=reginfoRowid
				}
			}
		}
		
	}
	
	q rowidRet
}

/// 名称：
/// 功能：判断item是否在group(,串起来)组里
/// 参数：
/// 返回： 
/// 作者：wangfeng
/// 日期：20160811
/// w ##class(web.DHCRisRegisterPatientDoEx).isExistInGroup()
ClassMethod isExistInGroup(group As %String, itemIn As %String) As %String
{
	s isExist=0
	s lenOfGroup=$l(group,",")
	for k=1:1:lenOfGroup
	{
		s item=$p(group,",",k)
		if ( item'="")
		{
			if ( item=itemIn)
			{
				s isExist=1
			}
		}
	}
	q isExist
}

/// 函数：isChargeOrderList
/// 功能：医嘱串是否已收费(有一个未收费的也算)
/// 返回：Y/N
ClassMethod isChargeOrderList(MuitiOrditem As %String) As %String
{
	s isCharge="Y"
	s count=$l(MuitiOrditem,"@")
	f i=1:1:count d
	.s perOrderItem=$p(MuitiOrditem,"@",i)
	.s perOrderItem=$p(perOrderItem,"$",1)
	.s Ret=..CanRegisterArcItmMaster(perOrderItem)
	.i Ret="N" s isCharge="N"
	q isCharge
}

/// 函数：isChargeOrder
/// 功能：门诊未收费返回N
/// 返回：Y/N
ClassMethod isChargeOrder(OrdItemID) As %String
{
  n (OrdItemID)
  q:OrdItemID="" ""
  s OrderRowid=$p(OrdItemID,"||",1)
  s itemsub=$p(OrdItemID,"||",2)
  s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
  s paadmdr=$p(^OEORD(OrderRowid),"^",1)
  s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类
  
  ;q:billed="P" "Y"    ;已经收费的允许登记
  q:(patienttype="O")&(billed'="P") "N" 
  q "Y"
}

}
