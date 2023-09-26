Import SQLUser

/// 程序名web.DHCRisNewPatient 新增病人
/// 乔治国 _2007/02/25
/// 
Class web.DHCRisNewPatient Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 326;

// d ##class(web.DHCRisNewPatient).UnRegister("BC20080613-011","ris001");

ClassMethod UnRegister(StudyNo As %String, UserCode As %String) As %String
{
	n (StudyNo,UserCode)
	k ^DHCTEMPRIS
	s rowid=0  f  s rowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,rowid)) q:rowid=""  d
	.s oeordrowid=$p(^DHCPACRegInfo(rowid),"^",11)
	.s ^DHCTEMPRIS(rowid)=oeordrowid
	
	s ret=##class(web.DHCRisUnRegisterPatient).UnRegister(StudyNo,"","",UserCode,"")

	s StatusDr=$o(^OEC("OSTAT",0,"Code","D",0))
	s rowid=0  f  s rowid=$o(^DHCTEMPRIS(rowid)) q:rowid=""  d
	.s oeordrowid=^DHCTEMPRIS(rowid)
	.&sql(update OE_OrdItem set OEORI_ItemStat_DR=:StatusDr where OEORI_Rowid=:oeordrowid)
	.s ^DHCTEMPRIS=StatusDr_"^"_oeordrowid_"^"_SQLCODE
	q ret
}

// web.DHCRisNewPatient.GetICDInfo(

ClassMethod GetICDInfo(ICDAlias As %String)
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunctionEx:QueryIDCWithAlias")
	s count=0
	s ret=""
	do rset.Execute(ICDAlias)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

ClassMethod dd()
{
  d ##class(web.DHCRisNewPatient).UpDateNewPatient3(^tmpVal,^tmpOrdItemInfo,^tmpUser,^tmpRecLoc,^tmpExamInfo,^tmpClinicDesc,^tmpICDInfoDR)
}

ClassMethod UpDateNewPatient3(val As %String, OrdItemStrInfo As %String, CreateUser As %String, RecLoc As %String, ExamInfo As %String, ClinicDesc As %String, ICDInfoDR As %String) As %String
{
 ;取参数
 s ^TMP("RIS",2)=val
 s ^tmpVal=val
 s ^tmpOrdItemInfo=OrdItemStrInfo
 s ^tmpUser=CreateUser
 s ^tmpRecLoc=RecLoc
 s ^tmpExamInfo=ExamInfo
 s ^tmpClinicDesc=ClinicDesc
 s ^tmpICDInfoDR=ICDInfoDR
 

 s RegNoPar=$p($g(val),"^",1)
 s Namepar=$p($g(val),"^",2)
 s Sexpar=$p($g(val),"^",3)
 s Birthpar=$p($g(val),"^",4)
 s TelNopar=$p($g(val),"^",5)
 s OpMedicare=$p($g(val),"^",6)
 s InMedicare=$p($g(val),"^",7)
 s PatType=$p($g(val),"^",8)
 s IDCardNo1=$p($g(val),"^",9)
 s Vocation=$p($g(val),"^",10)
 s Company=$p($g(val),"^",11)
 s Address=$p($g(val),"^",12)
 
 s AdmDep=$p($g(val),"^",13)
 s AdmDoc=$p($g(val),"^",14)
 
 s strAge=$p($g(val),"^",15)
 s UnitAge=$p($g(val),"^",16)
 s WardDr=$p($g(val),"^",17)
 s BedDr=$p($g(val),"^",18)
 s StudyNo=$p($g(val),"^",19)
 s Pinyin=$p($g(val),"^",20)
 
 // var ExamInfo=DeviceDR+"^"+ROOMDR + EQGroupDR+"^"+MainDocDR+"^"+OptionDocDR+"^"+StudyNo+"^"+No+"^"+Weight
 //var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+MainDocDR+"^"+OptionDocDR+"^"+No+"^"+Weight+"^"+Index+"^"+Flag+"^"+RegDate;
 //var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+gLocID+"^"+MainDocDR+"^"+OptionDocDR+"^"+No+"^"+Weight+"^"+Index+"^"+Flag+"^"+RegDate;

 s DeviceDR=$p(ExamInfo,"^",1)
 s RoomDR=$p(ExamInfo,"^",2)
 s EQGroupDR=$p(ExamInfo,"^",3)
 s CurrentLocID=$p(ExamInfo,"^",4)
 s MainDocDR=$p(ExamInfo,"^",5)
 s OptionDocDR=$p(ExamInfo,"^",6)
 s No=$p(ExamInfo,"^",7)
 s Weight=$p(ExamInfo,"^",8)
 s Index=$p(ExamInfo,"^",9)
 s Index=23
 s Flag=$p(ExamInfo,"^",10)
 s strRegDate=$p(ExamInfo,"^",11) ; 登记时间（执行时间）
 s RegDate=$ZDH(strRegDate,4)
 s userid=%session.Get("LOGON.USERID")

 //var ExamInfo=DeviceDR+"^"+RoomDR+"^"+EQGroupDR+"^"+MainDocDR+"^"+OptionDocDR+"^"+StudyNo+"^"+No+"^"+Weight
 ;如果登记号为空，则生成一个最大的登记号
 s TmpStr=""
 if RegNoPar="" d
 .s RegNoPar=##class(DHCRisCommFunctionEx).CreateNewPatientID(1)
 else  d
 .;if '$d(^DHCRisPNOLen) s ^DHCRisPNOLen=8
 .;s count=^DHCRisPNOLen-$Length(RegNoPar)
 .s len=##class(web.DHCRisCommFunctionEx).GetRegNoLength()
 .s count=len-$Length(RegNoPar)
 .FOR i=1:1:count d
 ..s TmpStr=TmpStr_"0"
 .s RegNoPar=TmpStr_RegNoPar
 q:RegNoPar="" "^"
 If $g(AdmDoc)="" d
 .i CreateUser'="" s AdmDoc=$p(^SSU("SSUSR",CreateUser),"^",14) 
 If $g(AdmDep)="" s AdmDep=CurrentLocID

 S PDate=+$H,PTime=$P($H,",",2)
 s SexDr=0
 s SexDr=$o(^CT("SEX",0,"Desc",Sexpar,SexDr))
 s Birthpar=$ZDH(Birthpar,4)
 s AdmDate=+$H
 s AdmTime=$p($H,",",2)
 Set CurrentNS=$ZNSPACE   
 
 d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
 //更新病人信息
 s PapmiDR=""
 //PatNo,Namepar,SexDr,Birthpar,TelNopar,OpMedicare,InMedicare,strAge,UnitAge,
 //ID1,WorkUnits,TelNo,Adress,OccupationDR
 //)
 //UpdatPatMas(PatNo,Namepar,SexDr,Birthpar,MobTelNopar,OpMedicare,InMedicare,strAge,UnitAge,ID1,WorkUnits,TelNo,Adress,OccupationDR)
 //s PapmiDR=$$UpdatPatMas^DHCRisNewPatientM(RegNoPar,Namepar,SexDr,Birthpar,TelNopar,OpMedicare,InMedicare,strAge,UnitAge) 
 s PapmiDR=$$UpdatPatMas^DHCRisNewPatientM(RegNoPar,Namepar,SexDr,Birthpar,TelNopar,OpMedicare,InMedicare,strAge,UnitAge,IDCardNo1,Company,TelNopar,Address,Vocation) 
 i PapmiDR="" q "^"
 
 ////////////判断病人的PAADM 
 //写就诊表
 s PaadmDr=""
 if PatType="I" d 
 .s PaadmDr=$$GetCurrentPaadm^DHCRisNewPatientM(RegNoPar)
 
 
 i PaadmDr="" d
 .s PaadmDr=$$InsertPaadm^DHCRisNewPatientM(PapmiDR,AdmDep,PatType,CreateUser,AdmDoc,WardDr,BedDr)
 
 i PaadmDr="" q "^"
 s admdate=+$H ,admtime=$p($H,",",2)
 ;&sql(insert into DHCRB_PAAdmInfo (DPA_Name,DPA_PatientID,DPA_Adm_DR,DPA_TYPE)values (:Namepar,:RegNoPar,:PaadmDr,:PatType))
 s ^DHCRBPAAdmInfo(PaadmDr)=Namepar_"^"_RegNoPar_"^"_PaadmDr_"^"_PatType
 
 ////////////////写临床诊断和ICD描述
 s count1=$LENGTH(ICDInfoDR,"^")
 for i=1:1:count1  d
 .s ICDCODEDR=$p(ICDInfoDR,"^",1)
 .s ret=$$InsertICDDesc^DHCRisNewPatientM(PaadmDr,ICDCODEDR,CreateUser,ClinicDesc)
 
 //写医嘱表
 s countdown = 0
 s GetOeorditemInfo=""
 s countdown = $LENGTH(OrdItemStrInfo,";")
 FOR i=1:1:countdown-1  d
 .s OrdItemStr=$P(OrdItemStrInfo,";",i)
 .;s Ret=$$INSERT^DHCOrdItem(PaadmDr,OrdItemStr,CreateUser,RecLoc,"",AdmDoc,"")
 .s Info=$$INSERT^DHCRisNewPatientM(PaadmDr,OrdItemStr,CreateUser,RecLoc,"",AdmDoc,"")
 .s ret=$p(Info,"^",1)
 .i ret="0" d
 ..s OEORIDr=$p(Info,"^",2)
 ..i GetOeorditemInfo="" d
 ...s GetOeorditemInfo=OEORIDr
 ..else  d
 ...s GetOeorditemInfo=GetOeorditemInfo_"^"_OEORIDr
 ZN CurrentNS
 q:GetOeorditemInfo="" "^"
 
 //更新编号
 s Nodr=##class(web.DHCRisNewPatient).UpdateNo(No,RegNoPar,AdmDep,EQGroupDR)
 ////////////////////////////////////////
 //写DHCRB_RegInfo 
 s GetStudyNoInfo=""
 ;s RegDate=+$H
 s RegTime=$p($H,",",2)
 s GetStudyNo="",EQGroup=""
 s count= $LENGTH(GetOeorditemInfo,"^")
 if (StudyNo="") d
   .if count>0 d
   ..s OeorditemRowid=$p(GetOeorditemInfo,"^",1)
   ..i EQGroupDR'="" s EQGroup=$p($g(^RBC("GRP",EQGroupDR)),"^",2)
   ..s ^DHCRISTMP("StudyNo")=OeorditemRowid_"^"_EQGroup_"^"_AdmDep
   ..; ss GetStudyNoInfo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNo("57754||1","心脏超声","780")
   ..s GetStudyNoInfo=##class(web.DHCRisRegisterPatientDoEx).GetStudyNo(OeorditemRowid,EQGroup,CurrentLocID,strRegDate)
   ..s Number=$p(GetStudyNoInfo,"^",2)
   ..s GetStudyNo=$p(GetStudyNoInfo,"^",1)_$p(GetStudyNoInfo,"^",2)
 else  d
  .s GetStudyNo=StudyNo
 q:GetStudyNo="" "^"

 ///对于同一个病人的同一就诊，允许检查相同，否则不允许重复
 s MayReg=1
 s regrowid=$o(^DHCPACRegInfoi("StudyNo",GetStudyNo,""))
 i regrowid'="" d
 .s GetPAADMDR=$p(^DHCPACRegInfo(regrowid),"^",10)
 .i PaadmDr=GetPAADMDR  d
 ..s MayReg=1
 .else  d
 ..s MayReg=0
 q:MayReg=0 "^" 
 

 FOR i=1:1:count  d
 .s OEORIDr=$P(GetOeorditemInfo,"^",i)
 .s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(OEORIDr,"E")
 .s regrowid=0
 .s regrowid=$o(^DHCPACRegInfoi("OEORI",OEORIDr,regrowid))
 .i regrowid'="" d
 ..;&sql(update  DHCRB_RegInfo (RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_Room_DR,RAR_EQGroup_DR,RAR_Note1,RAR_Note3,RAR_SSUSER_DR,RAR_MainDoctor_DR,RAR_AssistantDoctor_DR) values (:DeviceDR,:RegDate,:AdmDep,:RegTime,:AdmDoc,:GetStudyNo,:NoDR,:RoomDR,:EQGroupDR,:Flag,:Pinyin,:userid,:MainDocDR,:OptionDocDR) where RAR_OEORI_DR=:OEORIDr)
 ..&sql(update  DHCRB_RegInfo (RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_Room_DR,RAR_EQGroup_DR,RAR_Note1,RAR_Note3,RAR_MainDoctor_DR,RAR_AssistantDoctor_DR) values (:DeviceDR,:RegDate,:AdmDep,:RegTime,:AdmDoc,:GetStudyNo,:NoDR,:RoomDR,:EQGroupDR,:Flag,:Pinyin,:MainDocDR,:OptionDocDR) where RAR_OEORI_DR=:OEORIDr)
 .else  d
 ..;&sql(insert into DHCRB_RegInfo(RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_Room_DR,RAR_EQGroup_DR,RAR_Note1,RAR_Note3,RAR_SSUSER_DR,RAR_MainDoctor_DR,RAR_AssistantDoctor_DR)values(:OEORIDr,:PaadmDr,:DeviceDR,:RegDate,:AdmDep,:RegTime,:AdmDoc,:GetStudyNo,:Nodr,:RoomDR,:EQGroupDR,:Flag,:Pinyin,:userid,:MainDocDR,:OptionDocDR))
 ..&sql(insert into DHCRB_RegInfo(RAR_OEORI_DR,RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_Room_DR,RAR_EQGroup_DR,RAR_Note1,RAR_Note3,RAR_MainDoctor_DR,RAR_AssistantDoctor_DR)values(:OEORIDr,:PaadmDr,:DeviceDR,:RegDate,:AdmDep,:RegTime,:AdmDoc,:GetStudyNo,:Nodr,:RoomDR,:EQGroupDR,:Flag,:Pinyin,:MainDocDR,:OptionDocDR))
 ..i (SQLCODE=0)&(StudyNo="") d 
 ...s ret=##class(web.DHCRisRegisterPatientDoEx).updatenumber(CurrentLocID, EQGroupDR, Number, strRegDate)
 q:SQLCODE=0 RegNoPar_"^"_GetStudyNo_$c(1)_GetStudyNoInfo
 q "^"
}

ClassMethod QPatByRegNo(RegNo As %String, LocDR As %String)
{
	s count=0,TmpStr=""
 	s count=8-$Length(RegNo)
 	FOR i=1:1:count d
    .s TmpStr=TmpStr_"0"
    s RegNo=TmpStr_RegNo
	s Name="",SexDr="",Sex="",BirthDay="",Type="",No="",IPNO=""
    s InRegNo=$ZCONVERT(RegNo,"U")
	s NoRowid=$o(^PAPERi("PAPMI_PatNo",InRegNo,0))
	if NoRowid=""  q ""
	s Name=$p(^PAPER(NoRowid,"ALL"),"^",1)
	s DOB=$p(^PAPER(NoRowid,"ALL"),"^",6)
	s BirthDay=$ZD(DOB,4)
	s SexDr=$p(^PAPER(NoRowid,"ALL"),"^",7)
	s Sex=$p(^CT("SEX",SexDr),"^",2)
	s Noinfo=##class(web.DHCRisNewPatient).GetNo(RegNo,"",LocDR)
	s No=$p(Noinfo,"^",1)_$p(Noinfo,"^",2)
    s IPNO=##class(web.DHCRisCommFunctionEx).GetIPNO(NoRowid)   //获得住院号
    s WorkUnit=$p(^PAPER(NoRowid,"PER",4),"^",18)
    //pa_person
    s Age=""
    &sql(select  PAPER_Age into :Age from PA_Person where PAPER_RowId=:NoRowid)
    s Age=$P(Age,"|",12)
    s ID=$p(^PAPER(NoRowid,"ALL"),"^",9)
    s TelNo=$p(^PAPER(NoRowid,"PER",1),"^",11)
    s OccupationDR=$p($g(^PAPER(NoRowid,"PER",2)),"^",6)
    s Occupation=""
    i OccupationDR'="" s Occupation=$p(^CT("OCC",OccupationDR),"^",2) 
    s Adress=$g(^PAPER(NoRowid,"PER","ADD",1))
   	s PatInfo=Name_"^"_Sex_"^"_BirthDay_"^"_No_"^"_IPNO_"^"_Age_"^"_ID_"^"_TelNo_"^"_Occupation_"^"_OccupationDR_"^"_WorkUnit
	q PatInfo
}

ClassMethod QueryByIPNO(IPNo As %String, LocDR As %String)
{
    s NoRowid="",Name="",SexDr="",Sex="",BirthDay="",Type="",No="",IPNO=""
    
    &sql(select PAPMI_RowId into :NoRowid from  PA_PatMas where PAPMI_Medicare=:IPNo)
    q:NoRowid="" "" 

    ;s InRegNo=$ZCONVERT(RegNo,"U")
	;s NoRowid=$o(^PAPERi("PAPMI_PatNo",InRegNo,0))
	;if NoRowid=""  q ""
    s RegNo=$p(^PAPER(NoRowid,"PAT",1),"^",1)  
	s Name=$p(^PAPER(NoRowid,"ALL"),"^",1)
	s DOB=$p(^PAPER(NoRowid,"ALL"),"^",6)
	s BirthDay=$ZD(DOB,4)
	s SexDr=$p(^PAPER(NoRowid,"ALL"),"^",7)
	s Sex=$p(^CT("SEX",SexDr),"^",2)
	s No=##class(web.DHCRisNewPatient).GetNo(RegNo,"",LocDR)
	
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    i DHCRisVersion="BJ_YY" d  
    .s IPNO=$p(^PAPER(NoRowid,"PER",4),"^",4)   ;住院号(友谊医院）
    else  if DHCRisVersion="BJ_AZ" d
    .s IPNO=$p(^PAPER(NoRowid,"PAT",1),"^",2)
    else  d
    .s IPNO=""
 	s PatInfo=Name_"^"_Sex_"^"_BirthDay_"^"_No_"^"_IPNO
	q PatInfo
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetNo
/// 功能：获得病人的编号（如CT号，MRI，超声号，每次来做检查，他的编号是一样的）
/// 输入参数：RegNo: 登记号 LocDr：科室ROWID, EQGroupDr：设备组ROWID
/// 返回：检查号
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod GetNo(RegNo, EQGroup, LocDr) As %String
{
	s rowid=0,No="^^"
	if EQGroup=" " s EQGroup=""
	
	s EQGroupDr=""
	if EQGroup'="" d
	.s EQGroupDr=##class(web.DHCRisCommFunction).GetEQGroupDR(LocDr,EQGroup)

    //查找原来的编号
    s papatmasdr=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
    q:papatmasdr="" No
    
    s GetOldNo=""
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
/// 输入参数：LocDr：科室ROWID, EQGroupDr：设备组ROWID, RegNo：登记号
/// 返回：检查号 
/// 作者：龚平
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
/// ##class(web.DHCRisNewPatient).UpdateNo(NO,RegNo,LocDr,EQGroup)
ClassMethod UpdateNo(NO As %String, RegNo As %String, LocDr As %String, EQGroup As %String) As %String
{
	 s Selrowid="",GetOldNo=""
	 //s ^Tmp=NO_"^"_RegNo_"^"_LocDr_"^"_EQGroup
     s papatmasdr=$o(^PAPERi("PAPMI_PatNo",RegNo,0))

     q:NO="" ""
   
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

Query QueryPadmType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPadmTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set ^CacheTemp(repid,1)=$lb("门诊病人","O")
 	Set ^CacheTemp(repid,2)=$lb("住院病人","I")
 	Set ^CacheTemp(repid,3)=$lb("急诊病人","E")
    Set ^CacheTemp(repid,4)=$lb("体检病人","H")
    Set ^CacheTemp(repid,5)=$lb("其他病人","N")
    //Set ^CacheTemp(repid,6)=$lb("所有","")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPadmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPadmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QuerySex() As %Query(ROWSPEC = "Trowid:%String,TDesc:%String")
{
}

ClassMethod QuerySexExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^CT("SEX",rowid) ) q:(rowid="")  d
	.s desc=$p(^CT("SEX",rowid),"^",2)
	.Do OutSex 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSex
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuerySexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySexExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuerySexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryLocInfo(Desc As %String, LocType As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod QueryLocInfoExecute(ByRef qHandle As %Binary, Desc As %String, LocType As %String) As %Status
{
	s Desc=$tr(Desc,$c(0))
	s Desc=$ZCONVERT(Desc,"U")
	s LocType=$tr(LocType,$c(0))
	;s LocType="E"
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2)
	.s Gettype=$p(^CTLOC(RowId),"^",13)
	.q:(LocType'="")&(Gettype'=LocType)
	.s GetDesc=$ZCONVERT(GetDesc,"U")
	.i (GetDesc[Desc) d
	..Do OutLocRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutLocRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocDR(LocName As %String) As %String
{
	s LocDR=$o(CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocName),0))
	q LocDR
}

Query QueryCareProv(LocName As %String) As %Query(ROWSPEC = "desc:%String,DocDR:%String")
{
}

ClassMethod QueryCareProvExecute(ByRef qHandle As %Binary, LocName As %String) As %Status
{
	s Locrowid=""
	s ^TempLocName=LocName
	i LocName="" q
	;s Locrowid=GetLocDR(LocName)
	s Locrowid=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocName),0))
	i Locrowid="" q
	s ^TempLocid=Locrowid
	;s Locrowid="1140"
	Set repid=$I(^CacheTemp)
	s ind=1
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.s ssusercode=""
	.i CareProvrowid'=""  d
	..s ssuserrowid=$o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,0))
	..i ssuserrowid'="" s ssusercode=$p(^SSU("SSUSR",ssuserrowid),"^",1)
	..i ^DHCRisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3)
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
	..s DocDR = 0
	..s DocDR = $o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,DocDR)) q:(DocDR="")
 	..Do OutCareProv 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCareProv
	;set Data=$lb(CareProvDesc,CareProvrowid,DocDR,ssusercode)
	set Data=$lb(CareProvDesc,DocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareProvExecute ]
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

ClassMethod QueryCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query LookUpItem(Item As %String, GroupID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String,SubCategoryDesc:%String,Price:%String")
{
}

ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String, GroupID As %String) As %Status
{
	New repid, index
	///do ResetVariables
	s Category="", SubCategory="", TYPE ="", LUCategoryDesc="", LUSubCategoryDesc="", EpisodeID="", BillingGrp="", BillingSubGrp ="", DateRestriction="", OrdCatGrp="", NonFormulary="", Form="", Strength="", Route =""
	Set repid=$I(^CacheTemp)
	s index=1
	s ^tmpGroupID=GroupID
	s SSOCATSUB=0  f  s SSOCATSUB=$o(^SSU("SSGRP",GroupID,"SSORD",SSOCATSUB)) q:SSOCATSUB=""  d
	.s Category=$p(^SSU("SSGRP",GroupID,"SSORD",SSOCATSUB),"^",1)
	.s SubCategory=$p(^SSU("SSGRP",GroupID,"SSORD",SSOCATSUB),"^",5)
	.;if Category'="" 
	.;.s CategoryID=$O(^OEC("ORCAT",0,"Desc",Category,0))
	.;.i CategoryID'="" s Category=CategoryID
	.;i SubCategory'="" d
	.;.s SubCategoryID=$O(^ARC("IC",0,"Desc",SubCategory,0))
	.;.i SubCategoryID'="" s SubCategory=SubCategoryID
	.if (Category'="")&(SubCategory="") d
	..i $$valordcat(GroupID,Category) d
	...s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	....set retval=$$open(SubCategory,Item,GroupID)
	....for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
    ..... Do OutputRow
	....set retval=$$close()
	.e  d
	..set retval=$$open(SubCategory,Item,GroupID)
	..for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
    ... Do OutputRow
	..set retval=$$close()
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0,TEXT0=TEXT 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it3
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 i type["ARCIM" s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	 i type["ARCOS" s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	 q 0
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i '$$valord(user,subCATEG,type,ROW1) g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 i type["ARCIM" s err=$$selectarcim(ROW1) 
	 i type["ARCOS" s err=$$selectarcos(ROW1)
	 g:err it31 
	 ;s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() k UserCat,TEXT,TEXT0
	 k ^TMP($zn,$j)
	 q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_ItemCat_DR->ARCIC_Desc
	   INTO :rowid,:desc,:subcatdesc
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	;s cost=$p($g(cost),$c(1)) s:cost="" cost="N"
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_$p(code,$c(1))_$c(2)_$p(code1,$c(1))_$c(2)_$p(code2,$c(1))_$c(2)_$p(rice,$c(1))_$c(2)_ricedes_$c(2)_$p(cons,$c(1))_$c(2)_consdes_$c(2)_categ_$c(2)_subcat_$c(2)_$p(mealt,$c(1))_$c(2)_mealtdes_$c(2)_cost_$c(2)_inssubcat_$c(2)_prior_$c(2)_priordesc_$c(2)_$p($g(^ARC("IC",+subcat)),"^",15)_$c(2)_arcimcode
	;s PLIST=$o(PLIST(""),-1)
	s ItemPrice=0
	s StockQty=""
	s PackedQty=""
	s rowid=$p(rowid,$c(1))
	s SttDate=+$H
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s retPrice=..GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	s ItemPrice=$fn($P(retPrice,"^",1),"",4)
	;i subcatcode="R" d
	;.s ret=..GetStockQty(EpisodeID,rowid)
	;.s StockQty=$P(ret,"^",1)
	;.s PackedQty=$P(ret,"^",2)
	;QZG
	s StockQty="",PackedQty=""
	s generic=""
	s desc=flag_desc
	s Data=$lb(desc,rowid,subcatdesc,ItemPrice)
	q
selectarcos(RowID)	k PLIST
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_code_$c(2)_$p($g(prior),$c(1))_$c(1)_$p($g(^OECPR(+$g(prior))),"^",2)
	;s PLIST=$o(PLIST(""),-1)
	s rowid=$p(rowid,$C(1),1)
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$C(4),1)
	s OSPrice=$fn($p(retval,$C(4),2),"",4)
	s desc=flag_desc
	s Data=$lb(desc,rowid,subcatdesc,OSPrice)
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	 i type="ARCOS",os'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
valordcat(user,CATEG)
	 ;1-valid,0-invalid
	 s found=0
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos,user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos,user)
	 s grp=$p($g(^SSU("SSUSR",+user)),"^",5)
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+grp,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	 s err=$$getall^MVBARCOI(arcos_"^ALL")
	 s found=0,ind=0
	 f  s ind=$o(PLIST(ind)) q:ind=""  q:found  d
	 .s arcim=$p(PLIST(ind),$c(2))
	 .s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
	 .s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	 .i '$d(UserCat(+orcat)) s found=61
	 q found
subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;if order subcategory is blank, index can be :
	; Desc - all order items, order sets
	; DescI - all order items,no order sets
	; DescVI - visible order items, no order sets
	; DescVIOS - visible order items, order sets
	;if order subcategory is not blank, index can be :
	; OrderCat-Desc - all order items, order sets
	; OrderCat-DescI - all order items,no order sets
	; OrderCat-DescVI - visible order items, no order sets
	; OrderCat-DescVIOS - visible order items, order sets
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	;do ..OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=+$h
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
    ..s ARCOSItemQty=$p(s,"^",2)
    ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
 ..s n=n+1
 ..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
 ..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
 i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
 q OSItemIDs
OutputRow
	;w Data,!
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpSubCatBroker(itmjs As %String = "", itmjsex As %String = "", Category As %String = "", SubCategory As %String = "", EpisodeID As %String = "", OrdCatGrp As %String = "") As %Library.Boolean
{
	&SQL(SELECT ARCIC_Desc,ARCIC_RowId,ARCIC_Code into :desc,:rowid,:code FROM ARC_ItemCat
	WHERE ((ARCIC_OrdCat_DR->ORCAT_RowId =:Category) OR (:Category IS NULL))
	AND (ARCIC_Code =:SubCategory))
	if SQLCODE d 
	.s desc="",rowid="",code=""
	s txt=desc_"^"_rowid_"^"_code
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(txt,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetOrderPrice(PatType As %String, InsType As %String, ARCIMRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
	s ARCIMSub=$p(ARCIMRowid,"||",1)
	if SttDate="" s SttDate=+$h
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	;w retPrice,!
	;s ^CacheTemp("zzq",1)=SttDate
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s INCIRowid=..GetINCI(ARCIMSub)
	s ConFac=1
	if INCIRowid'="" {
		s ConFac=..GetConFac(ARCIMRowid,INCIRowid)
		s Price=$fn(Price*ConFac,"",4)
		s DiscPrice=$fn(DiscPrice*ConFac,"",4)
		s InsPrice=$fn(InsPrice*ConFac,"",4)
		s PatPrice=$fn(PatPrice*ConFac,"",4)
	}
	Q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ConFac
}

ClassMethod GetINCI(ARCIMsub As %String) As %String
{
	n INCIrow
	s ARCIMsub=$p(ARCIMsub,$c(1),1)
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	q $g(INCIrow)
}

ClassMethod GetConFac(ARCIMRowid As %String, INCIRowid As %String) As %String
{
	;s convqty=$$ConvFac^ST02(billuom,baseuom)
	s ConFac=""
	s Billuom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s Baseuom=$p($g(^INCI(INCIRowid,1)),"^",10)                     ; INCI_CTUOM_DR  库存基本单位
	Q:(Baseuom=Billuom)&&(Billuom'="") 1
	s ConFacID="" s ConFacID=$O(^CT("CTCF",0,"UOM",Billuom,Baseuom,ConFacID))
    i ConFacID="" s ConFac=0
	e  s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	i ConFac=""  s ConFac=1
	q ConFac
}

ClassMethod InsertOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String)
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA		
	Set Ret=$$INSERT^DHCOrdItem(Adm,OrdItemStr,User,Loc,LABDATA,DocUserId,"")
	ZN CurrentNS
	QUIT Ret
}

Query QAddOrdItem(OrdName As %String, OrdPrice As %String, OrdQty As %String, OrdItemRowID As %String) As %Query(ROWSPEC = "TSelOEItem:%Library.Boolean,TOrdName:%String,TOrdPrice:%String,TOrdQty:%String,TOrdItemRowID:%String")
{
}

ClassMethod QAddOrdItemExecute(ByRef qHandle As %Binary, OrdName As %String, OrdPrice As %String, OrdQty As %String, OrdItemRowID As %String) As %Status
{
	New repid, ind
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	s Select=0
	s countInit=2 ;设置下医嘱的数量
	FOR i=1:1:countInit  d
	.Do AddOrdItem
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK
AddOrdItem
	set Data=$lb(Select,OrdName, OrdPrice, OrdQty, OrdItemRowID)
 	;w !,Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QAddOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QAddOrdItemExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QAddOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QAddOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDOB(Num As %String, Unit As %String)
{
	s today=+$h
	if (Unit="Days") 
	{
		s strDOB=today-Num
	}
	elseif (Unit="Months")  
	{
		s strDOB=today-(Num*30)
	}
	s strDOB=$zd(strDOB,4)
	q strDOB
}

// s ret=##class(web.DHCRisNewPatient).UpdatePatientInfo(^DHCRisTemp34)

ClassMethod UpdatePatientInfo(val)
{
 s ^DHCRisTemp34=val
 s RegNoPar=$p($g(val),"^",1)
 s Namepar=$p($g(val),"^",2)
 s SexDr=$p($g(val),"^",3)
 s Birthpar=$p($g(val),"^",4)
 s TelNopar=$p($g(val),"^",5)
 s OpMedicare=$p($g(val),"^",6)
 s InMedicare=$p($g(val),"^",7)
 s PatType=$p($g(val),"^",8)
 s IDCardNo1=$p($g(val),"^",9)
 s Vocation=$p($g(val),"^",10)
 s Company=$p($g(val),"^",11)
 s Address=$p($g(val),"^",12)
 s strAge=$p($g(val),"^",15)
 s UnitAge=$p($g(val),"^",16)
 //s WardDr=$p($g(val),"^",17)
 //s BedDr=$p($g(val),"^",18)

 ;s SexDr=0
 ;s SexDr=$o(^CT("SEX",0,"Desc",Sexpar,SexDr))
 s Birthpar=$ZDH(Birthpar,4)

 Set CurrentNS=$ZNSPACE   
 d ##class(web.DHCRisCommFunction).SetMedTrakNameSpace()
 //更新病人信息
 s PapmiDR=""
 s PapmiDR=$$UpdatPatMas^DHCRisNewPatientM(RegNoPar,Namepar,SexDr,Birthpar,TelNopar,OpMedicare,InMedicare,strAge,UnitAge,IDCardNo1,Company,TelNopar,Address,Vocation) 
 zn CurrentNS
 q SQLCODE
}

ClassMethod GetSexListStr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisNewPatient:QuerySex")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret=""  s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
		e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}
	d rset.Close()
	q ret
}

ClassMethod GetAgeUnitListStr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunctionEx:QueryAgeUnit")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetPatientTypeListstr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisNewPatient:QueryPadmType")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret=""  s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
		e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetWardInfoListstr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunctionEx:QueryWardInfo")
	s ret=""
	do rset.Execute("")
	while (rset.Next())
	{
		s rowid=rset.GetData(2)
		s Desc=rset.GetData(1)
		//Desc: xxxx-13病区  或者  13病区
		s Alias=$p(Desc,"-",1)
		s WardName=$p(Desc,"-",2)
		if WardName="" s retinfo=rowid_$C(1)_Alias_"-"_""
	    else  s retinfo=rowid_$C(1)_WardName_"-"_Alias
	    i ret="" s ret=retinfo
	    e  s ret=ret_"^"_retinfo
	}	
	d rset.Close()
	q ret
}

ClassMethod GetBedListstr(Wardrowid) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunctionEx:QueryBed")
	s ret=""
	s Code=""
	do rset.Execute(Wardrowid,Code)
	while (rset.Next())
	{
		s rowid=rset.GetData(2)
		s Desc=rset.GetData(1)
	
	    i ret="" s ret=rowid_"$c(2)"_Desc
	    e  s ret=ret_"$c(1)"_rowid_"$c(2)"_Desc
	}	
	d rset.Close()
	q ret
}

ClassMethod GetOccuptionListstr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryOccuption")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
	    i ret="" s ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetHospListstr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryHospital")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
	    i ret="" s ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetEQListstr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryEQ")
	s ret=""
	s LocDR=%session.Get("LOGON.CTLOCID")
	do rset.Execute(LocDR,"")
	while (rset.Next())
	{
	    i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(3)_"-"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetCareProvListStr() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:GetCareProv")
	s ret=""
	s LocDR=%session.Get("LOGON.CTLOCID")
	do rset.Execute(LocDR)
	while (rset.Next())
	{
	    i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)_"-"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetPatientCount(PatientName As %String, LocDR As %String)
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunctionEx:QueryByPatientName")
	s ret=""
	s count=0
	do rset.Execute(PatientName,LocDR)
	while (rset.Next())
	{
	   s count=count+1
	}	
	d rset.Close()
	q count
}

// d ##class(%ResultSet).RunQuery("web.DHCRisNewPatient","QueryOrdItemCS","cs")

Query QueryOrdItemCS(ItemDesc As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String,SubCategoryDesc:%String,Price:%String")
{
}

ClassMethod QueryOrdItemCSExecute(ByRef qHandle As %Binary, ItemDesc As %String) As %Status
{
	s rARCIMDesc="",rItemRowID="",rSubCategoryDesc="",rPrice=""
	Set repid=$I(^CacheTemp)
	s index=1
	s Today=+$h
	s ItemDesc=$g(ItemDesc)
	s ItemDesc=$ZCONVERT(ItemDesc,"U")
	s i=0
	s id=0 f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	.s text=$p(^ARC("ALIAS",id),"^",6)
	.s text=$ZCONVERT(text,"U")
	.q:($l(text)=0)
	.q:(($e((text),1,$l(ItemDesc)))'[ItemDesc)
	.s tarid=$p(^ARC("ALIAS",id),"^",1)
	.q:tarid=""
	.s id1=$p(tarid,"||",1)
	.s id2=$p(tarid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s rItemRowID=id1_"||"_id2
	.;w !,"rItemRowID="_rItemRowID
	.s rARCIMDesc=$p(^ARCIM(id1,id2,1),"^",2)
	.s StarDay=$p(^ARCIM(id1,id2,1),"^",13)
	.s StarDate=$p(StarDay,"Z",1)
	.;Q:((StarDate'="")||(StarDate>Today))
	.;w !,"rItemRowID="_rItemRowID
	.s endDay=$p(^ARCIM(id1,id2,7),"^",1)
	.;q:(endDay'="")
	.s yzcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s lei=""
	.s leiname=""
	.s daleicode=""
	.s daleiname=""
	.s uomcode=""
	.s uomdesc=""
	.;w !,"rItemRowID="_rItemRowID
	.s uomcode=$p(^ARCIM(id1,id2,8),"^",14)
	.i uomcode'="" s uomdesc=$p($g(^CT("UOM",uomcode)),"^",2)
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s rSubCategory=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" d
	..s rCategory=$p(^OEC("ORCAT",daleicode),"^",2)
	..;b //rCategory
	..i rCategory["检查" Do OutOrdItemCS
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOrdItemCS
	set Data=$lb(rARCIMDesc,rItemRowID, rSubCategory,rPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod QueryOrdItemCSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
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

ClassMethod QueryOrdItemCSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
