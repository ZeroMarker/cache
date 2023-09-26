Import SQLUser

Class web.DHCEkgRegisterPatient Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 208;

ClassMethod register(Info) As %String
{
	//
	s ^TempDHCRis("DHCRisRegister.register","EKG")=Info
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
	s isSamePat=##class(web.DHCRisRegisterPatientDoEx).isSamePatient(listOrderItemBody)
	q:(isSamePat="N") "-11111"
	   
    //有停止的医嘱不允许一起登记
    s Exist=""
    s Exist=##class(web.DHCRisCommFunctionEx).ExistStopItem(listOrderItemBody)
    i Exist="Y" lock -(^DHCRisTMPReg)
    q:(Exist="Y") -10006
    
    //是否有已登记记录
    s isRegister=##class(web.DHCRisRegisterPatientDoEx).hasRegisterItem(listOrderItemBody)
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
     
    .s studyNo="EKG||"_perOrditemRowid
    
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
   
	d ##class(web.DHCRisRegisterPatientDoEx).UpdateIndex(recLocDr,locNum)
	//d ..UpdateGroupIndex(EQGroupDR,GroupIndex,RegDate)
	d ##class(web.DHCRisRegisterPatientDoEx).UpdateRoomIndex(RoomDR,roomNum) 

	
    
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
  	
  	s Now=$zd(+$H,8)_$zt($p($h,",",2))
    s UserCode=""
    i operateDocDr'="" s UserCode=$p(^SSU("SSUSR",operateDocDr),"^",1) 
    s orderGet="" f  s orderGet=$o(registerOrm(orderGet)) q:(orderGet="")  d
    .s ret=##class(RISService.TrakRISService).ORMO01XX(orderGet,"SC",Now,registerOrm(orderGet),UserCode,"Y")
    .;s ^DHCRisTemp("ORMO01XX",orderGet)=$lb(ret,orderGet,"SC",Now,registerOrm(orderGet),UserCode,"Y")
    
    k registerOrm
    
  	lock -(^DHCRisTMPReg)     		       //回滚事务
  	//d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000005",MuitStudyNo) //调平台接口,给第三方传消息
 	//d ##class(RISService.InvokeRISService).InsertStudyInfoPACS(studyNo)
 	//do ##class(web.DHCRisSendToRis4Set).SendStudytoRIS4(studyNo)

 	Quit SQLCODE

  	
  	
           
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	b //error
	s ^TempDHCRis("registerError")=ErrorMsg_"^"_listOrderItemBody
 	TROLLBACK
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit "-0001"
}

}
