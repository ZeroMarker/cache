Import SQLUser

Class web.DHCRisPatRegisterDoEx Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 208;

/// 函数名称：GetSelRegInfo
/// 功能：根据OEorditem.Rowid获得病人登记信息,没有登记则返回要登记的信息
/// 输入参数：OEorditem.Rowid
/// 返回：登记的信息
/// 作者：龚平
/// 日期：2007-03-05
/// d ##class(web.DHCRisPatRegisterDoEx).GetSelRegInfo("70113||279","70245")
ClassMethod GetSelRegInfo(oeorditemrowid, paadmdr) As %String
{

  n (oeorditemrowid, paadmdr)
  s (GetstrRegDate,GetstrRegTime,GetIndex,GetEQDesc,GetEQDr,GetMainDoc,GetAssDoc)=""
  s (GetRoomDesc,GetRoomDr,GetEQGroupDesc,GetEQGroupDR,NO,MainDr,AssDocDR,BodyPart,Num,ReportInfo,PrintItem,strRegDate4,GroupIndex,RoomIndex,Urgent)=""
  s (AppRowid,BookedInfo,GetIndexTypeDR,IndexTypeDesc,RecLocdr,IsCreateNo)=""
  
  s ^ts=oeorditemrowid_"^"_paadmdr
  
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
		
		s OrderRowid=$p(oeorditemrowid,"||",1)
		s itemsub=$p(oeorditemrowid,"||",2)
		
		s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
		if RecLocdr'="" d
		.s IsCreateNo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocdr)
		
		s BookedInfo=##class(web.DHCRisResourceApptSchudleEx).GetBookedResult(oeorditemrowid)
		i (BookedInfo'="")
		{
			s GetStudyNo= $p(BookedInfo,"^",1)
			s GetEQDesc=$p(BookedInfo,"^",5)
			s GetEQDr=$p(BookedInfo,"^",2)
			s GetRoomDesc=$p(BookedInfo,"^",7)
			s GetRoomDr=$p(BookedInfo,"^",4)
			s GetEQGroupDesc=$p(BookedInfo,"^",6)
			s GetEQGroupDR=$p(BookedInfo,"^",3)
			i IsCreateNo="B" d
			.s GetIndex=$p(BookedInfo,"^",8) 
			.s GroupIndex=$p(BookedInfo,"^",9)
		    .s RoomIndex=$p(BookedInfo,"^",10) 
		    s IndexTypeDesc=$p(BookedInfo,"^",11) 
		} 
		
		s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemrowid)
		s GetStudyNo=$p(RegInfo,"^",1)
		i GetStudyNo'="" d
		.s GetstrRegDate=$p(RegInfo,"^",2)
		.s GetstrRegTime=$p(RegInfo,"^",3)
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
		.i IsCreateNo="I" d
		..s GetIndex=$p(RegInfo,"^",4)
		..s GroupIndex=$p(RegInfo,"^",22)
		..s RoomIndex=$p(RegInfo,"^",23)
		.s GetIndexTypeDR=$p(RegInfo,"^",25)
		.i GetIndexTypeDR'="" s IndexTypeDesc=$p($g(^DHCRBCIndexType(GetIndexTypeDR)),"^",2)
		.s PrintItem=##class(web.DHCRisRegisterPatientDoEx).GetPrintItem(GetStudyNo)
  
 }
  s Info=GetName_"^"_GetstrDOB_"^"_Weight_"^"_TelNo_"^"_IPNO_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_GetIndex_"^"_GetEQDesc_"^"_GetEQDr_"^"_GetMainDoc_"^"_MainDr_"^"_GetAssDoc_"^"_AssDocDR_"^"_GetRoomDesc_"^"_GetRoomDr_"^"_GetEQGroupDesc_"^"_GetEQGroupDR
  s Info1=NO_"^"_BodyPart_"^"_Num_"^"_ReportInfo_"^"_Type_"^"_LocName_"^"_OPNO_"^"_BedCode_"^"_PrintItem_"^"_strRegDate4_"^"_GroupIndex_"^"_RoomIndex_"^"_Urgent_"^"_IndexTypeDesc
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
/// S RET=##class(web.DHCRisPatRegisterDoEx).InsertRegInfo(^tt,^tt1,^tt2)
ClassMethod InsertRegInfo(Info, bodyNum, BodyInfo) As %String
{
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
	s MuitStudyNo=$p(Info,"^",9)
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
    s ResSchduleID=$p(Info,"^",23)
    s AppDateType=$p(Info,"^",24)
    s IndexTypeDR=$p($g(Info),"^",25)

    
    i RegDate="" d
	.i InputRegDate="" d
	..s RegDate=+$h
	.else  d
	..s RegDate=$zdh(InputRegDate,3)
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
	
    s UseInfo="",UpType="",AppDateType=""
    s UseInfo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RegLOCDr)
    i (UseInfo'="")
    {
	  s UpType=$p(UseInfo,"^",1)
	  s AppDateType=$p(UseInfo,"^",2)
    }
    
    
	
Trans
	Set $ZT="ERROR"	
    lock +(^DHCRisTMPReg)     

	s EQGroupDesc="",EQGroupDR=""
	if RegEQDr'="" d
	.s EQGroupInfo=##class(web.DHCRisCommFunction).GetEQGroup(RegEQDr)
    .s EQGroupDesc=$p(EQGroupInfo,"^",1)
    .s EQGroupDR=$p(EQGroupInfo,"^",2)
 
	//s GetStudyNoInfo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNo(OEORIDr,EQGroupDesc,RegLOCDr,InputRegDate)
	//s Number=$p(GetStudyNoInfo,"^",2)
    //s StudyNo=$p(GetStudyNoInfo,"^",1)_$p(GetStudyNoInfo,"^",2)

    // 医嘱对应的就诊记录是否一致
    s OEORIDr=$p(MuitOEORIDr,"@")
    s OrderID=$p(OEORIDr,"||",1)
    s GetPaadmID=$p(^OEORD(OrderID),"^",1)
    
    i (paadr'=GetPaadmID) lock -(^DHCRisTMPReg)
    q:paadr'=GetPaadmID -10002 
    
    if (UpType'="B")
    {
	  s RegMax="",RegMaxInfo=""
	  s RegMax=RegEQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_RegLOCDr_"^"_OEORIDr_"^"_InputRegDate
	  s RegMaxInfo=##class(web.DHCRisPatRegisterDoEx).GetCurrentMaxIndex(RegMax)
      i RegMaxInfo'="" d
	  .s Index=$p(RegMaxInfo,"^",1)
	  .s GroupIndex=$p(RegMaxInfo,"^",2)
	  .s RoomIndex=$p(RegMaxInfo,"^",3)
	}
	
	s value=""
	s value=Index_"^"_GroupIndex_"^"_RoomIndex_"^"_RegEQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_AppDateType_"^"_InputRegDate
	
    
   
    //如有退费审核的话,则退出
	/*s redr=""
	s redr=$o(^DHCORDItem(0,OEORIDr,0))
	q:redr'="" 100
	*/
	//判断此病人是否出院
	s Status=$p(^PAADM(GetPaadmID),"^",20)
	i (Status="D") lock -(^DHCRisTMPReg) 
	q:Status="D" -10003 
	

	if ($g(^DHCRisCheckFee)="Y")
	{
		///宁波欠费管理---------
	   s OrderRowid=$p(OEORIDr,"||",1)
	   s itemsub=$p(OEORIDr,"||",2)
       s Billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
       if (Billed'="B")&&(Billed'="P")
       {
	       s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
	       s str=OEORIDr_$c(2)_Num
	  	   s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(paadr, str)
	  	   s P5="",P7="",P3=""
      	   if rtn'="0" d 
       	   .s P3=$p(rtn,"^",3)
       	   .s P5=$p(rtn,"^",5)
      	   .s P7=$p(rtn,"^",7)
           // 说明 -2000 表示欠费
           i ((P5="C")&(P7="N")) lock -(^DHCRisTMPReg)
      	   q:(P5="C")&(P7="N") -10004
      	   s feeflag="1"              //lrl
      	   i (P5="C")&(P7="Y") d     //lrl
      	   .s arcim=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)       //lrl
       	   .s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE(P3, arcim)  //lrl
       	   i feeflag="0" lock -(^DHCRisTMPReg)
      	   q:feeflag="0" -10004        //lrl
    	}
	}
	
	if ($g(^DHCRisCheckFee)="Y")
	{
    	s rtn=##Class(web.UDHCJFBILL).BILLN(paadr,SSUSERDr,OEORIDr)
    }
    
	
	s Arrearage=""
	s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(paadr,"A","完全控制")
	i (Arrearage="1") lock -(^DHCRisTMPReg)
	q:Arrearage="1" -10004
	
	s ret=##class(web.DHCRisRegisterPatientDoEx).CanRegisterArcItmMaster(OEORIDr)
	i ret="N" lock -(^DHCRisTMPReg)  
	q:ret="N" -10001
    s RCODE=0

    //d ##class(web.DHCRisRegister).UpdateIndex(RegLOCDr,Index,RegDate)
   TSTART
    //E:执行状态
    s count=$l(MuitOEORIDr,"@")
    for i=1:1:count d
    .s perOrditemRowid=$p(MuitOEORIDr,"@",i)
    .s StudyNo=$p($g(MuitStudyNo),"@",i)
    .;s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(perOrditemRowid,"E",SSUSERDr)
    .s Now=$zd(+$H,8)_$zt($p($h,",",2))
    .s UserCode=""
    .i SSUSERDr'="" s UserCode=$p(^SSU("SSUSR",SSUSERDr),"^",1) 
    .s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowid,"SC",Now,StudyNo,UserCode,"Y")
	.s regrowid=0
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,regrowid))
	.i regrowid'="" d
	..s GetStudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	..s Reportrowid=""
	..i GetStudyNo'=""  s Reportrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,""))
	..i Reportrowid="" d
	...&sql(update  DHCRB_RegInfo (RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_Note5,RAR_IndexType_DR) values (:MainDocDr,:AssDocDr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:UgentFlag,:IndexTypeDR) where RAR_Rowid=:regrowid)
	.else  d
	..;不同病人，或者是不同就诊，检查号不能相同
	..s mayreg=0
	..s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	..if regrowid'="" d
	...s getpaadm=$p(^DHCPACRegInfo(regrowid),"^",10)
	...i getpaadm=paadr d  //只允许同一个人插入 
	....&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_Note5,RAR_IndexType_DR)values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:GroupIndex,:RoomIndex,:UgentFlag,:IndexTypeDR))
    ....q:SQLCODE'=0
	....s rowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,""))
	....s childsub=""
	....i rowid'="" s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,rowid,0)) 
	....i childsub'="" d
	.....&sql(delete from DHCRB_RegInfo_BodyParts where  RRB_ParRef=:rowid)
   	....i (rowid'="")&(bodyNum'="") d
	.....for ii=1:1:bodyNum  d
    ......s bodydr=$p(BodyInfo,"^",ii)
	......&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR ) values (:rowid,:bodydr))
	...else  d  //不同病人的检查号重复
	....s Number=$p(StudyNo,"-",2)
	....d ..updatenumber(RegLOCDr, EQGroupDR, Number)
	....s SQLCODE=-10005
	....;s ret2=..AddNumber(RegLOCDr,EQGroupDR,InputRegDate,StudyNo)
	..else  d    //登记表为空
	...;插入叫号对列表
	...&sql(insert into DHCRB_CallQueue(DRCQ_PatId,DRCQ_Name,DRCQ_Sex,DRCQ_StudyNo,DRCQ_RegDate,DRCQ_LocDr,DRCQ_LocIndex,DRCQ_EqDr, DRCQ_EqIndex,DRCQ_RoomDr,DRCQ_RoomIndex)values(:RegNo,:Name,:SexDesc,:StudyNo,:RegDate,:RegLOCDr,:Index,:EQGroupDR,:GroupIndex,:RoomDR,:RoomIndex))
	...&sql(insert into DHCRB_RegInfo(RAR_MainDoctor_DR,RAR_AssistantDoctor_DR,RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index,RAR_Room_DR,RAR_EQGroup_DR,RAR_ReportInfo,RAR_CheckGroupIndex,RAR_RoomIndex,RAR_Note5,RAR_IndexType_DR)values(:MainDocDr,:AssDocDr,:perOrditemRowid,:paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:NoDR,:Index,:RoomDR,:EQGroupDR,:ReportInfo,:GroupIndex,:RoomIndex,:UgentFlag,:IndexTypeDR))
    ...q:SQLCODE'=0
	...s rowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,""))
	...s childsub=""
	...i rowid'="" s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,rowid,0)) 
	...i childsub'="" d
	....&sql(delete from DHCRB_RegInfo_BodyParts where  RRB_ParRef=:rowid)
   	...i (rowid'="")&(bodyNum'="") d
	....for ii=1:1:bodyNum  d
    .....s bodydr=$p(BodyInfo,"^",ii)
	.....&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR ) values (:rowid,:bodydr))
    
	I SQLCODE TRollback  	
	I SQLCODE lock -(^DHCRisTMPReg)  
	I SQLCODE q SQLCODE
    
    
     i ((SQLCODE=0)&(UpType="I")) d
	 .do ..UpdateIndexcls(RegLOCDr,value,ResSchduleID)
	
	
	//update weight 2006-10-16
	s mrrowid=$p(^PAADM(paadr),"^",61)

	s papatmasdr=$p(^PAADM(paadr),"^",1)
	
	&sql(update MR_Adm SET MRADM_Weight=:Weight where MRADM_Rowid=:mrrowid)
    
     //update 住院号
    &sql(update PA_PATMAS set PAPMI_Medicare=:IpNo where PAPMI_RowId=:papatmasdr)
    
    //update 电话号
    &sql(update pa_person set PAPER_TelH =:TelNo where PAPER_Rowid=:papatmasdr) 
    
   
    do ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4(MuitOEORIDr)
   
  	TCOMMIT
  	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit SQLCODE

  	
  	/*
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
    */
    
  
    /*if RegLOCDr'="" d 
    .s LocCode=$p(^CTLOC(RegLOCDr),"^",1)
    .i (LocCode="2304")!(LocCode="5001")!(LocCode="6501") d */
    ..; 内镜系统的检查信息传输
    ..;s ret=##class(RISService.InvokeRISService).InsertAppStudyInfo(StudyNo) //sunyi 2011-09-28
    
            
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit SQLCODE
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
/// ///////////////////
/// w ##class(web.DHCRisPatRegisterDoEx).GetStudyNo("3||109","超声","83","2015-10-27")
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
	
	;q:(rowid="")!(rowid=0)!(AppType=0) StudyNo
	
	i IsCreateType="" s IsCreateType="B"
	//b //001
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
    
   
    //找默认的检查号 ACCESSION NUMBER 
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
	...s currentdatedigital=$zdh(SelectDate,3)
	...s currentdate=$zd(currentdatedigital,8) 
	..i $g(^DHCRisStudyNoDate(LocDr,currentdate))="" s ^DHCRisStudyNoDate(LocDr,currentdate)=0
	..s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
	..s Number=Number+1
	..s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
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
				s currentdatedigital=$zdh(SelectDate,3)
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
  	...s currentdatedigital=$zdh(SelectDate,3)
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

ClassMethod GetGroupRoom(EQDesc, LocDR)
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

ClassMethod CanRegisterArcItmMaster(OrdItemID) As %String
{
  n (OrdItemID)
  s ^TMPOrditem=OrdItemID
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
  
  q:billed="P" "Y"    ;已经收费的允许登记
  q:(patienttype="I")&(AllowIpRegNotPaid="Y") "Y"
  q:(patienttype="O")&(AllowOpRegNotPaid="Y") "Y"
  q:(patienttype="H")&(AllowHPRegNotPaid="Y") "Y"
  q:(patienttype="E")&(AllowEMRegNotPaid="Y") "Y"
  q:(patienttype="E")&(stay="STAY") "Y"
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
/// w ##class(web.DHCRisRegisterPatientDoEx).HZtoPin("(孙毅)")
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
ClassMethod GetCurentIndex(LocDr, Today) As %String
{
	n (LocDr,Today)
	q:LocDr="" ""
	i Today="" s Today=+$h	
	
	i $g(^DHCRisRegIndex(Today,LocDr))="" s ^DHCRisRegIndex(Today,LocDr)=0
	s CurrentIndex=^DHCRisRegIndex(Today,LocDr)+1
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
ClassMethod UpdateIndex(LocDr, Index, Today) As %String
{
  n (LocDr, Index,Today)
  q:LocDr="" 100
  i Today="" s Today=+$h	
  s ^DHCRisRegIndex(Today,LocDr)=Index
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
ClassMethod GetRoomIndex(RoomDR, Today) As %String
{
	n (RoomDR,Today)
	q:RoomDR="" ""
	
    i Today="" s Today=+$h	
	i $g(^DHCRisCheckRoomIndex(Today,RoomDR))="" s ^DHCRisCheckRoomIndex(Today,RoomDR)=0
	s CurrentIndex=^DHCRisCheckRoomIndex(Today,RoomDR)+1
	q CurrentIndex
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateRoomIndex
/// 功能：//更新房间的流水号
/// 输入参数：RoomDR：科室ROWID, Index：序号
/// 返回：
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateRoomIndex(RoomDR, Index, Today) As %String
{
  n (RoomDR, Index,Today)
  q:RoomDR="" 100
  i Today="" s Today=+$h	
  s ^DHCRisCheckRoomIndex(Today,RoomDR)=Index
  q 0
}

/// 得当前到资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod GetGroupIndex(CheckGroupDr, Today) As %String
{
    n (CheckGroupDr,Today)
    q:CheckGroupDr="" ""
	
    i Today="" s Today=+$h	
	i $g(^DHCRisCheckGroupIndex(Today,CheckGroupDr))="" s ^DHCRisCheckGroupIndex(Today,CheckGroupDr)=0
	s CheckGroupIndex=^DHCRisCheckGroupIndex(Today,CheckGroupDr)+1
	q CheckGroupIndex
}

/// 跟新资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod UpdateGroupIndex(CheckGroupDr, Index, Today) As %String
{
    n (CheckGroupDr,Index,Today)
    q:CheckGroupDr="" 100
    
	i Today="" s Today=+$h	
	s ^DHCRisCheckGroupIndex(Today,CheckGroupDr)=Index
	q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetIndexbySchduleID
/// 功能：根据预约资源获得科室当前的序号
/// 输入参数：CT_LocID  ResSchduleID
/// 返回：
/// 作者：孙毅
/// 日期：2013-04-022
/// ////////////////////////////////////////////////////////
ClassMethod GetIndexbySchduleID(LocDr, ResSchduleID, Today) As %String
{
	n (LocDr,ResSchduleID,Today)
	q:LocDr="" ""
	q:ResSchduleID="" ""
	i Today="" s Today=+$h	
	i $g(^DHCRisResRegIndex(Today,LocDr,ResSchduleID))="" s ^DHCRisResRegIndex(Today,LocDr,ResSchduleID)=0
	s CurrentIndex=^DHCRisResRegIndex(Today,LocDr,ResSchduleID)+1
	q CurrentIndex
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateIndex
/// 功能：//更新当前的流水号
/// 输入参数：LocDr：科室ROWID, Index：序号,ResSchduleID预约资源记录ID
/// 返回：
/// 作者：sunyi
/// 日期：2013-04-22
/// ////////////////////////////////////////////////////////
ClassMethod UpdateIndexbySchduleID(LocDr, Index, ResSchduleID, Today) As %String
{
  n (LocDr,Index,ResSchduleID,Today)
  q:LocDr="" 100
  q:ResSchduleID="" 100
  i Today="" s Today=+$h	
  s ^DHCRisResRegIndex(Today,LocDr,ResSchduleID)=Index
  q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetRoomIndexbySchduleID
/// 功能：获得房间当前的序号
/// 输入参数：空
/// 返回：
/// 日期：2013-04-22
/// 作者：龚平
/// ////////////////////////////////////////////////////////
ClassMethod GetRoomIndexbySchduleID(RoomDR, ResSchduleID, Today) As %String
{
	n (RoomDR,ResSchduleID,Today)
	q:RoomDR="" ""
	q:ResSchduleID="" ""
	i Today="" s Today=+$h	
	i $g(^DHCRisResCheckRoomIndex(Today,RoomDR,ResSchduleID))="" s ^DHCRisResCheckRoomIndex(Today,RoomDR,ResSchduleID)=0
	s CurrentIndex=^DHCRisResCheckRoomIndex(Today,RoomDR,ResSchduleID)+1
	q CurrentIndex
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateRoomIndexbySchduleID
/// 功能：//根据预约记录更新房间的流水号
/// 输入参数：RoomDR：科室ROWID, Index：序号,ResSchduleID 预约资源记录ID
/// 返回：
/// 作者：孙毅
/// 日期：2013-04-22
/// ////////////////////////////////////////////////////////
ClassMethod UpdateRoomIndexbySchduleID(RoomDR, Index, ResSchduleID, Today) As %String
{
  n (RoomDR, Index,ResSchduleID,Today)
  q:RoomDR="" 100
  q:ResSchduleID="" 100
  i Today="" s Today=+$h	
  s ^DHCRisResCheckRoomIndex(Today,RoomDR,ResSchduleID)=Index
  q 0
}

/// 根据预约资源记录得当前到资源组的流水号
/// sunyi 2013-04-22
ClassMethod GetGroupIndexbySchduleID(CheckGroupDr, ResSchduleID, Today) As %String
{
    n (CheckGroupDr,ResSchduleID,Today)
    q:CheckGroupDr="" ""
    q:ResSchduleID="" ""
	i Today="" s Today=+$h	
	i $g(^DHCRisResCheckGroupIndex(Today,CheckGroupDr,ResSchduleID))="" s ^DHCRisResCheckGroupIndex(Today,CheckGroupDr,ResSchduleID)=0
	s CheckGroupIndex=^DHCRisResCheckGroupIndex(Today,CheckGroupDr,ResSchduleID)+1
	q CheckGroupIndex
}

/// 根据预约资源记录更新资源组的流水号
/// sunyi2013-04-22
ClassMethod UpGroupIndexbySchduleID(CheckGroupDr, Index, ResSchduleID, Today) As %String
{
    n (CheckGroupDr,Index,ResSchduleID,Today)
    q:ResSchduleID="" 100
    q:CheckGroupDr="" 100
	i Today="" s Today=+$h	
	s ^DHCRisResCheckGroupIndex(Today,CheckGroupDr,ResSchduleID)=Index
	q 0
}

/// 根据科室配置来更新对应的流水号
/// do ##class(web.DHCRisPatRegisterDoEx).UpdateIndexcls("83","1^^^4^3^^1","4153")
ClassMethod UpdateIndexcls(LocDR, Info, ResSchduleID As %String = "")
{
	s ^ttss=LocDR_"&"_Info_"&"_ResSchduleID
	q:(LocDR="")
	s Rowid=""
	s RegEQIndex=$p($g(Info),"^",1)
	s CheckGroupIndex=$p($g(Info),"^",2)
	s RoomIndex=$p($g(Info),"^",3)
	s EQDr=$p($g(Info),"^",4)
	s EQGroupDR=$p($g(Info),"^",5)
	s RoomDR=$p($g(Info),"^",6)
	s AppDateType=$p($g(Info),"^",7)
	s SelRegDate=$p($g(Info),"^",8)
	i SelRegDate'="" d
	.s SelRegDate=$zdh(SelRegDate,"3")
	
	i AppDateType="" s AppDateType="0"
	
	s Rowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocDR,Rowid))

	i (Rowid'="")
	{
		s OpertionDR="",NoRuleCode=""
	    s NoRuleDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",2)
	    
	    ;s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",3)
	    i NoRuleDR'="" s NoRuleCode=$p($g(^DHCRBCApp("USE-METHOD",NoRuleDR)),"^",1)
	   
        i (AppDateType="0") //天
        {
	       
	        if (NoRuleCode="L")
	        {
		       d ..UpdateIndex(LocDR, RegEQIndex,SelRegDate)
		      
		    }
		    elseif (NoRuleCode="Z")
		    {
			   d ..UpdateGroupIndex(EQGroupDR, CheckGroupIndex,SelRegDate)
			}
			elseif(NoRuleCode="R")
			{
			    d ..UpdateRoomIndex(RoomDR, RoomIndex,SelRegDate)
			}
	    }
	    elseif (AppDateType="1") //时间段
	    {   
		    if (NoRuleCode="L")
	        {
		        d ..UpdateIndexbySchduleID(LocDR,RegEQIndex,ResSchduleID,SelRegDate)
		    }
		    elseif(NoRuleCode="Z")
		    {
			     d ..UpGroupIndexbySchduleID(EQGroupDR,CheckGroupIndex,ResSchduleID,SelRegDate)
			}
			elseif(NoRuleCode="R")
			{
			 	 d ..UpdateRoomIndexbySchduleID(RoomDR,RoomIndex,ResSchduleID,SelRegDate)
			}
		}
	         
	}
}

/// 根据科室配置来更新对应的流水号
/// w ##class(web.DHCRisPatRegisterDoEx).GetIndexcls(^t)
ClassMethod GetIndexcls(Info As %String) As %String
{
	s ^TempL=Info
	s EQDr=$p($g(Info),"^",1)
	s EQGroupDR=$p($g(Info),"^",2)
	s RoomDR=$p($g(Info),"^",3)
	s LocDR=$p($g(Info),"^",4)
	s oeorditemrowid=$p($g(Info),"^",5)
	s ResSchduleRowid=$p($g(Info),"^",6)
	s SelRegDate=$p($g(Info),"^",7)
	i SelRegDate'="" d
	.s SelRegDate=$zdh(SelRegDate,"3")
	s ReBk=$p($g(Info),"^",8)
	
	s IsBooked="N",AppDateType="",IndexInfo="",Index=""
	s NoRuleCode="",NoRuleDR="",NoRuleCode="",Rowid="",TypeDesc="",TypeRowid=""
	s IndexInfo="",IsUpdateNo="",Exsit=""

	i (oeorditemrowid'="") 
	{
	    s Rowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocDR,Rowid))
	    i (Rowid'="")
	    {
			s NoRuleCode=""
		    s NoRuleDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",2)
		    i NoRuleDR'="" s NoRuleCode=$p($g(^DHCRBCApp("USE-METHOD",NoRuleDR)),"^",1) 
		    s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",3)
	    }
	  
	    s IsUpdateNo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(LocDR)
	    i IsUpdateNo'="" s IsUpdateNo=$p(IsUpdateNo,"^",1)
	   
	    s Exsit=..GetExistNoTypeInfo(oeorditemrowid,IsUpdateNo)
	  
	    i (Exsit'="")&(ReBk'="RE")
	    {
		    s TypeRowid=$p(Exsit,"^",1)
		    s TypeDesc=$p(Exsit,"^",2)
		    s Index=$p(Exsit,"^",3)
		    s IndexInfo=Index_"^"_NoRuleCode_"^"_TypeDesc_"^"_AppDateType_"^"_TypeRowid
		}
		
		
		q:(IndexInfo'="") IndexInfo

	    i (AppDateType="0")
	    {
		    if (NoRuleCode="L")
	        {
		       s Index=..GetCurentIndex(LocDR,SelRegDate)
		       s IndexInfo=..GetIndexTypeInfo("LD")
		    }
		    elseif (NoRuleCode="Z")
		    {
			   s Index=..GetGroupIndex(EQGroupDR,SelRegDate)
			   s IndexInfo=..GetIndexTypeInfo("ZD")
			}
			elseif(NoRuleCode="R")
			{
			   s Index=..GetRoomIndex(RoomDR,SelRegDate)
			   s IndexInfo=..GetIndexTypeInfo("RD")
			}
		}
		elseif(AppDateType="1")
		{
			if (NoRuleCode="L")
	        {
		       s Index=..GetIndexbySchduleID(LocDR,ResSchduleRowid,SelRegDate)
		       s IndexInfo=..GetIndexTypeInfo("LT")
		    }
		    elseif(NoRuleCode="Z")
		    {
			   s Index=..GetGroupIndexbySchduleID(EQGroupDR,ResSchduleRowid,SelRegDate)
			   s IndexInfo=..GetIndexTypeInfo("ZT") 
			}
			elseif(NoRuleCode="R")
			{
			 	s Index=..GetRoomIndexbySchduleID(RoomDR,ResSchduleRowid,SelRegDate)
			 	s IndexInfo=..GetIndexTypeInfo("RT")
			}
		}
		
	}
	
	i (IndexInfo'="")
	{
		s TypeDesc=$p(IndexInfo,"^",2)
		s TypeRowid=$p(IndexInfo,"^",1)
	}
	
	s IndexInfo=Index_"^"_NoRuleCode_"^"_TypeDesc_"^"_AppDateType_"^"_TypeRowid
	
	q IndexInfo
}

/// w ##class(web.DHCRisPatRegisterDoEx).GetIndexTypeInfo("LD")
ClassMethod GetIndexTypeInfo(Code As %String) As %String
{
	s Rowid="",Desc="",Info=""
	
	i Code'="" d
	.s Rowid=$o(^DHCRBCIndexTypei("Code",Code,Rowid))
	.i Rowid'="" d
	..s Desc=$p($g(^DHCRBCIndexType(Rowid)),"^",2)
	..s Info=Rowid_"^"_Desc
	
	q Info
}

ClassMethod GetExistNoTypeInfo(oeorditemrowid As %String, IsUpdateNo As %String = "I") As %String
{
	 s DRowid="",Flag="",Infos=""
	 s IndexTypeRowid="",Desc="",Code="",Index=""
	 
	 if (IsUpdateNo="B")
	 {
		s DRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemrowid,DRowid))
	    i DRowid'="" s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",7)
	    i ((Flag'="Cancel")&( DRowid'=""))
	    { 
	        
		       s IsBooked="Y" 
		       s IndexTypeRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",14)
		       i IndexTypeRowid'="" d
		       .s Desc=$p($g(^DHCRBCIndexType(IndexTypeRowid)),"^",2)
		       .s Code=$p($g(^DHCRBCIndexType(IndexTypeRowid)),"^",1) 
		       
		       i ((Code="LD")!(Code="LT"))
		       {
			       s Index=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",8)
			   }
			   elseif((Code="ZD")!(Code="ZT"))
			   {
				   s Index=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",9)
			   }
			   elseif((Code="RD")!(Code="RT"))
			   {
				   s Index=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",10)
			   }
			   
			   s Infos=IndexTypeRowid_"^"_Desc_"^"_Index
	    }  
	    
	   
	 }
	 elseif(IsUpdateNo="I")
	 {
		s regrowid=""
		s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemrowid,"")) 	
		i (regrowid'="")
		{
			   s IndexTypeRowid=$p($g(^DHCPACRegInfo(regrowid)),"^",30)  
			   i IndexTypeRowid'="" d
		       .s Desc=$p($g(^DHCRBCIndexType(IndexTypeRowid)),"^",2)
		       .s Code=$p($g(^DHCRBCIndexType(IndexTypeRowid)),"^",1) 
		       
		       i ((Code="LD")!(Code="LT"))
		       {
			       s Index=$p($g(^DHCPACRegInfo(regrowid)),"^",15)
			   }
			   elseif((Code="ZD")!(Code="ZT"))
			   {
				   s Index=$p($g(^DHCPACRegInfo(regrowid)),"^",28)
			   }
			   elseif((Code="RD")!(Code="RT"))
			   {
				   s Index=$p($g(^DHCPACRegInfo(regrowid)),"^",24)
			   }
			   
			   s Infos=IndexTypeRowid_"^"_Desc_"^"_Index
		}
	 }
	 
	 q Infos
}

/// w ##class(web.DHCRisPatRegisterDoEx).CreateRegPrint("1@2@3","1||2@1||3@1||5")
/// 病人检查号相同医嘱放在一起。
/// sunyi 2013-07-26
ClassMethod CreateRegPrint(MuitStudyNo As %String, MuitOeItemRowid As %String) As %String
{
	  k ^DHCRISSTUDYNOTMP
	  k ^DHCRISSTUDYNOINFOTMP
	  
	  s Info=""
	  q:(MuitStudyNo="") Info
	  q:(MuitOeItemRowid="") Info
	  s count=0
	  s count=$l(MuitStudyNo,"@")
	  
      for i=1:1:count d
      .s perOrditemRowid=$p($g(MuitOeItemRowid),"@",i)
      .s StudyNo=$p($g(MuitStudyNo),"@",i)
     
      .i '$d(^DHCRISSTUDYNOINFOTMP(StudyNo)) d
      ..s ^DHCRISSTUDYNOINFOTMP(StudyNo)=perOrditemRowid
      .e  d
      ..s ^DHCRISSTUDYNOINFOTMP(StudyNo)=^DHCRISSTUDYNOINFOTMP(StudyNo)_"@"_perOrditemRowid
      .s ^DHCRISSTUDYNOTMP(StudyNo)=StudyNo
     
      s StudyNoID="" f  s StudyNoID=$o(^DHCRISSTUDYNOINFOTMP(StudyNoID)) q:(StudyNoID="")  d
      .i Info="" s Info=$g(^DHCRISSTUDYNOINFOTMP(StudyNoID))
      .e  d
      ..s Info=Info_"^"_$g(^DHCRISSTUDYNOINFOTMP(StudyNoID))
      
      q Info
}

/// w ##Class(web.DHCRisPatRegisterDoEx).GetRegBillData("20017||3883")
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
		.i EqIndex'="" s Index=EqIndex
		.i RoomIndex'="" s Index=RoomIndex
		.i CheckGroupIndex'="" s Index=CheckGroupIndex
		.s Info=StudyNo_"^"_RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_RecLoc_"^"_ItemName_"^"_IndexType_"^"_Index_"^"_EQDesc_"^"_RoomDesc_"^"_CheckGroupDesc_"^"_patienttype_"^"_IPNO_"^"_OPNO_"^"_InLocName_"^"_BedCode_"^"_EqDR_"^"_No_"^"_Date_"^"_Time
		
	}
	
	q Info
}

ClassMethod GetCurrentMaxIndex(Param As %String) As %String
{
	s (val,GrourpIndex,RoomIndex,EQIndex,Infos)=""
	s (NoRuleCode,IndexNo)=""

	s val=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)

	q:(val="") ""
	
	s NoRuleCode=$p(val,"^",2)
	s IndexNo=$p(val,"^",1)
	
	if (NoRuleCode="L")
	{ 
	   s EQIndex=IndexNo
    }
	elseif(NoRuleCode="Z")
	{
		s GrourpIndex=IndexNo
	}
	elseif (NoRuleCode="R")
	{
	   s RoomIndex=IndexNo
	}
	
	s Infos=EQIndex_"^"_GrourpIndex_"^"_RoomIndex
	q Infos
}

}
