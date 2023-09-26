/// 名称: DHCHAI.IRS.INFMBRSrv
/// 描述: 耐药菌报告相关服务
/// 编写者：pylian
/// 编写日期: 2017-08-11
Class DHCHAI.IRS.INFMBRSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFMBRSrv","QryINFMBRPrint",7)
Query QryINFMBRPrint(aMRBRepID As %String) As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,xLabRepID:%String,ResultID:%String,SpeCode:%String,SpecDesc:%String,SubmissDate:%String,LocCode:%String,LocDesc:%String,BacCode:%String,BacDesc:%String,BactDesc:%String,MRBCode:%String,MRBDesc:%String,InfTypeCode:%String,InfTypeDesc:%String,HandCode:%String,HandDesc:%String,CaseCode:%String,CaseDesc:%String,InsulatCode:%String,InsulatDesc:%String,ContactListCode:%String,ContactListDesc:%String,DropletListCode:%String,DropletListDesc:%String,PlaceListCode:%String,PlaceListDesc:%String,UnitListCode:%String,UnitListDesc:%String,UintExt:%String,TreatCode:%String,TreatDesc:%String,EnvCode:%String,EnvDesc:%String,ClothCode:%String,ClothDesc:%String,VisitListCode:%String,VisitListDesc:%String,EndListCode:%String,EndListDesc:%String,Resume:%String,StatusCode:%String,RepStatus:%String,RepDate:%String,RepUser:%String,RepLocDesc:%String,ActDate:%String,ActTime:%String,SumAssess:%String,Comments:%String,DoTS:%String,MainDiag:%String,xLabRepID:%String,SpecimenDr:%String,LabEpisodeNo:%String") [ SqlProc ]
{
}

ClassMethod QryINFMBRPrintExecute(ByRef qHandle As %Binary, aMRBRepID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMRBRepID="" $$$OK
		
	Set objInf=##class(DHCHAI.IR.INFMBR).GetObjById(aMRBRepID)
	Quit:'$IsObject(objInf) $$$OK
	Quit:'$Isobject(objInf.IREpisodeDr) $$$OK
	
	//病人基本信息
	Set AdmID  = objInf.IREpisodeDr.%Id()
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
	If $Isobject(objAdm) {
	Set EpisodeID = objAdm.PAEpisodeIDx
	Set PatientID = objAdm.PAPatientIDx
	Set PapmiNo   = objAdm.PAPapmiNo
	Set MrNo      = objAdm.PAMrNo
	Set PatName   = objAdm.PAPatName
	Set Sex       = objAdm.PASex
	Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
	Set AdmDate   = objAdm.PAAdmDate
	Set AdmTime   = objAdm.PAAdmTime
	Set Age       = objAdm.PAAge
	Set DischDate = objAdm.PADischDate
	Set DischTime = objAdm.PADischTime
	Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
	Set:DischTime'="" DischTime=$zt(DischTime,1)
	Set (AdmBedDr,AdmBed)=""
	If $IsObject(objAdm.PAAdmBedDr){
		Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
		Set AdmBed=objAdm.PAAdmBedDr.BTDesc
	}
	Set objAdmLoc = objAdm.PAAdmLocDr
	Set AdmLocID="", AdmLocDesc=""    //就诊科室
	If $Isobject(objAdmLoc) {
		Set AdmLocID = objAdmLoc.%Id()
		Set AdmLocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc2 = objAdmLoc.BTDesc2
		Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
	}
	Set objAdmWard = objAdm.PAAdmWardDr
	Set AdmWardID="",AdmWardDesc=""   //就诊病区
	If $Isobject(objAdmWard) {
		Set AdmWardID  = objAdmWard.%Id()
		Set AdmWardDesc = objAdmWard.BTDesc
		Set AdmWardDesc2 = objAdmWard.BTDesc2
		Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
	}
	}
	Set MainDiag=""
	//主要诊断
	Set MainDiag = ##class(DHCHAI.DPS.MRDiagnosSrv).GetMRDiagnosByDR(AdmID,"M") 
	//多耐报告信息
	Set (ResultID,ActDate,ActTime,xLabRepID,LabEpisodeNo)=""
	If ($Isobject(objInf.IRLabRepDr)){
		Set xLabRepID=objInf.IRLabRepDr.%Id()    //检验报告指针
		If xLabRepID'="" {
			Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(xLabRepID)
			If $Isobject(objLabRep) {
				//Continue:objLabRep.LabIsActive'=1
				Set ActDate = objLabRep.LabAuthDate
				Set ActTime = objLabRep.LabAuthTime
				Set objLabVisitNumber = objLabRep.LabVisitNumberDr
				If $Isobject(objLabVisitNumber) {
				Set LabEpisodeNo = objLabVisitNumber.LabEpisodeNo
				}
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set xResultID="",ResultID=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xLabRepID,xResultID))
					Quit:xResultID=""
					Continue:'$d(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",xResultID))
					Set ResultID=xResultID
				}
			}
		}
	}Else{
		If ($Isobject(objInf.IROutLabRepDr)){
			Set ActDate = objInf.IROutLabRepDr.LabAuthDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		}
	}
	Set SpeID="",SpeCode="",SpecDesc=""
	If $IsObject(objInf.IRSpecimenDr){
		Set SpeID =  objInf.IRSpecimenDr.%Id()
		Set SpeCode = objInf.IRSpecimenDr.BTSpecCode
		Set SpecDesc = objInf.IRSpecimenDr.BTSpecDesc
	}
	Set SubmissDate    = objInf.IRSubmissDate  
	Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate) 
	
	Set LocID="", LocCode="", LocDesc=""
	If $IsObject(objInf.IRSubmissLocDr ){
		Set LocID =  objInf.IRSubmissLocDr.%Id()
		Set LocCode = objInf.IRSubmissLocDr.BTCode
		Set LocDesc = objInf.IRSubmissLocDr.BTDesc
	}
	
	Set BacID="",BacCode="",BacDesc=""
	If $IsObject(objInf.IRBactDicDr){
		Set BacID =  objInf.IRBactDicDr.%Id()
		Set BacCode = objInf.IRBactDicDr.BTBacCode
		Set BacDesc = objInf.IRBactDicDr.BTBacDesc
	} 
	Set BactDesc       = objInf.IRBactDesc 
	     
	Set MRBID="",MRBCode="",MRBDesc=""
	If $IsObject(objInf.IRMRBDicDr){
		Set MRBID =  objInf.IRMRBDicDr.%Id()
		Set MRBCode = objInf.IRMRBDicDr.BTCode
		Set MRBDesc = objInf.IRMRBDicDr.BTDesc
	}
	Set InfTypeID="",InfTypeCode="",InfTypeDesc=""
	If $IsObject(objInf.IRInfTypeDr){
		Set InfTypeID =  objInf.IRInfTypeDr.%Id()
		Set InfTypeCode = objInf.IRInfTypeDr.BTCode
		Set InfTypeDesc = objInf.IRInfTypeDr.BTDesc
	}  
	Set HandID="",HandCode="",HandDesc=""
	If $IsObject(objInf.IRHandHygieneDr){
		Set HandID =  objInf.IRHandHygieneDr.%Id()
		Set HandCode = objInf.IRHandHygieneDr.BTCode
		Set HandDesc = objInf.IRHandHygieneDr.BTDesc
	}   
	
	Set CaseID="",CaseCode="",CaseDesc=""
	If $IsObject(objInf.IRSecondCaseDr){
		Set CaseID =  objInf.IRSecondCaseDr.%Id()
		Set CaseCode = objInf.IRSecondCaseDr.BTCode
		Set CaseDesc = objInf.IRSecondCaseDr.BTDesc
	} 
	
	Set InsulatID="",InsulatCode="",InsulatDesc=""
	If $IsObject(objInf.IRInsulatTypeDr){
		Set InsulatID =  objInf.IRInsulatTypeDr.%Id()
		Set InsulatCode = objInf.IRInsulatTypeDr.BTCode
		Set InsulatDesc = objInf.IRInsulatTypeDr.BTDesc
	}  
	
	
	Set ContactListID   = objInf.IRContactList 
	Set ContactListCode="",ContactListDesc=""
	For indx=1:1:$l(ContactListID,","){
		Set ContactID=$p(ContactListID,",",indx)
		Continue:ContactID=""
		Set ContactCode="",ContactDesc=""	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(ContactID)
		If $IsObject(objDic){
			Set ContactCode = objDic.BTCode
			Set ContactDesc = objDic.BTDesc
		}  
		Set ContactListCode=ContactListCode_","_ContactCode
		Set ContactListDesc=ContactListDesc_","_ContactDesc
	} 
	Set:ContactListCode'="" ContactListCode=$e(ContactListCode,2,$l(ContactListCode))
	Set:ContactListDesc'="" ContactListDesc=$e(ContactListDesc,2,$l(ContactListDesc))
	
	Set DropletListID   = objInf.IRDropletList  	
	Set DropletListCode="",DropletListDesc=""
	For indy=1:1:$l(DropletListID,","){
		Set DropletID=$p(DropletListID,",",indy)
		Continue:DropletID=""
		Set DropletCode="",	DropletDesc=""
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(DropletID)
		If $IsObject(objDic){
			Set DropletCode = objDic.BTCode
			Set DropletDesc = objDic.BTDesc
		}  
		Set DropletListCode=DropletListCode_","_DropletCode
		Set DropletListDesc=DropletListDesc_","_DropletDesc
	} 
	Set:DropletListCode'="" DropletListCode=$e(DropletListCode,2,$l(DropletListCode))
	Set:DropletListDesc'="" DropletListDesc=$e(DropletListDesc,2,$l(DropletListDesc))
	     
	Set PlaceListID     = objInf.IRPlaceList 
	Set PlaceListCode="",PlaceListDesc=""
	For indz=1:1:$l(PlaceListID,","){
		Set PlaceID=$p(PlaceListID,",",indz)
		Continue:PlaceID=""
		Set PlaceCode="",	PlaceDesc=""
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(PlaceID)
		If $IsObject(objDic){
			Set PlaceCode = objDic.BTCode
			Set PlaceDesc = objDic.BTDesc
		}  
		Set PlaceListCode=PlaceListCode_","_PlaceCode
		Set PlaceListDesc=PlaceListDesc_","_PlaceDesc
	} 
	Set:PlaceListCode'="" PlaceListCode=$e(PlaceListCode,2,$l(PlaceListCode))
	Set:PlaceListDesc'="" PlaceListDesc=$e(PlaceListDesc,2,$l(PlaceListDesc))
	
	Set UnitListID      = objInf.IRUnitList 
	Set UnitListCode="",UnitListDesc=""
	For indm=1:1:$l(UnitListID,","){
		Set UnitID=$p(UnitListID,",",indm)
		Continue:UnitID=""
		Set UnitCode="",	UnitDesc=""
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(UnitID)
		If $IsObject(objDic){
			Set UnitCode = objDic.BTCode
			Set UnitDesc = objDic.BTDesc
		}  
		Set UnitListCode=UnitListCode_","_UnitCode
		Set UnitListDesc=UnitListDesc_","_UnitDesc
	} 
	Set:UnitListCode'="" UnitListCode=$e(UnitListCode,2,$l(UnitListCode))
	Set:UnitListDesc'="" UnitListDesc=$e(UnitListDesc,2,$l(UnitListDesc))
	
	Set UintExt        = objInf.IRUintExt       
	Set TreatID="",TreatCode="",TreatDesc=""
	If $IsObject(objInf.IRTreatMentDr){
		Set TreatID =  objInf.IRTreatMentDr.%Id()
		Set TreatCode = objInf.IRTreatMentDr.BTCode
		Set TreatDesc = objInf.IRTreatMentDr.BTDesc
	}   
	
	Set EnvID="",EnvCode="",EnvDesc=""
	If $IsObject(objInf.IREnvMentDr){
		Set EnvID =  objInf.IREnvMentDr.%Id()
		Set EnvCode = objInf.IREnvMentDr.BTCode
		Set EnvDesc = objInf.IREnvMentDr.BTDesc
	}        
	
	Set ClothID="",ClothCode="",ClothDesc=""
	If $IsObject(objInf.IRClothMentDr){
		Set ClothID =  objInf.IRClothMentDr.%Id()
		Set ClothCode = objInf.IRClothMentDr.BTCode
		Set ClothDesc = objInf.IRClothMentDr.BTDesc
	}     
	Set VisitListID     = objInf.IRVisitList
	Set VisitListCode="",VisitListDesc=""
	For indn=1:1:$l(VisitListID,","){
		Set VisitID=$p(VisitListID,",",indn)
		Continue:VisitID=""
		Set VisitCode="",	VisitDesc=""
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(VisitID)
		If $IsObject(objDic){
			Set VisitCode = objDic.BTCode
			Set VisitDesc = objDic.BTDesc
		}  
		Set VisitListCode=VisitListCode_","_VisitCode
		Set VisitListDesc=VisitListDesc_","_VisitDesc
	} 
	Set:VisitListCode'="" VisitListCode=$e(VisitListCode,2,$l(VisitListCode))
	Set:VisitListDesc'="" VisitListDesc=$e(VisitListDesc,2,$l(VisitListDesc))
	
	Set EndListID       = objInf.IREndList
	Set EndListCode="",EndListDesc=""
	For indt=1:1:$l(EndListID,","){
		Set EndID=$p(EndListID,",",indt)
		Continue:EndID=""
		Set EndCode="",	EndDesc=""
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(EndID)
		If $IsObject(objDic){
			Set EndCode = objDic.BTCode
			Set EndDesc = objDic.BTDesc
		}  
		Set EndListCode=EndListCode_","_EndCode
		Set EndListDesc=EndListDesc_","_EndDesc
	} 
	Set:EndListCode'="" EndListCode=$e(EndListCode,2,$l(EndListCode))
	Set:EndListDesc'="" EndListDesc=$e(EndListDesc,2,$l(EndListDesc))
	
	Set Resume         = objInf.IRResume 
	  
	// 院感报告信息
	Set (RepStatus,StatusCode,RepDate,RepUser,RepLocDesc)=""
	Set RepInfo =..GetMBRRepID(AdmID,aMRBRepID)
	If (RepInfo'=""){
		Set InfRepID = $p(RepInfo,"^",1)
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(InfRepID)
		Set RepDate  = objRep.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objRep.IRRepUser) {
			Set RepUserID   = objRep.IRRepUser.%Id() 
			Set RepUserDesc = objRep.IRRepUser.BTDesc
		}
		Set (StatusID,StatusCode,StatusDesc)=""
		If $IsObject(objRep.IRStatusDr) {
			Set StatusID   = objRep.IRStatusDr.%Id() 
			Set StatusCode = objRep.IRStatusDr.BTCode 
			Set StatusDesc = objRep.IRStatusDr.BTDesc
		}
		Set (RepLocID, RepLocCode,RepLocDesc)=""
		If $IsObject(objRep.IRRepLocDr) {
			Set RepLocID = objRep.IRRepLocDr.%Id()
			Set RepLocCode = objRep.IRRepLocDr.BTCode
			Set RepLocDesc = objRep.IRRepLocDr.BTDesc
			Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
		}
	}
	 
	Set SumAssess= objInf.IRSumAssess     //审核总结性评价	
	Set Comments= objInf.IRComments     //批注 add 20211116
	
	Set DoTS="" //易感因素
	Set DoTSListID = objInf.IRDoTS
	For indx=1:1:$l(DoTSListID,","){
		Set DoTSID=$p(DoTSListID,",",indx)
		Continue:DoTSID=""
		Set DoTSCode="",DoTSDesc=""	
		Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(DoTSID)
		If $IsObject(objDic){
			Set DoTSCode = objDic.BTCode
			Set DoTSDesc = objDic.BTDesc
		}  
		Set DoTS=DoTS_","_DoTSCode
		//Set ContactListDesc=ContactListDesc_","_ContactDesc
	} 
	Set:DoTS'="" DoTS=$e(DoTS,2,$l(DoTS))
	//Set:ContactListDesc'="" ContactListDesc=$e(ContactListDesc,2,$l(ContactListDesc))
	Set SpecimenDr= objInf.IRSpecimenDr.%Id() /// 检验标本	
	Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime)
	Set Data = Data_$lb(xLabRepID,ResultID,SpeCode,SpecDesc,SubmissDate,LocCode,LocDesc,BacCode,BacDesc)
	Set Data = Data_$lb(BactDesc,MRBCode,MRBDesc,InfTypeCode,InfTypeDesc)
	Set Data = Data_$lb(HandCode,HandDesc,CaseCode,CaseDesc,InsulatCode,InsulatDesc)
	Set Data = Data_$lb(ContactListCode,ContactListDesc,DropletListCode,DropletListDesc)
	Set Data = Data_$lb(PlaceListCode,PlaceListDesc,UnitListCode,UnitListDesc,UintExt)
	Set Data = Data_$lb(TreatCode,TreatDesc,EnvCode,EnvDesc,ClothCode,ClothDesc)
	Set Data = Data_$lb(VisitListCode,VisitListDesc,EndListCode,EndListDesc,Resume)
	Set Data = Data_$lb(StatusCode,StatusDesc,RepDate,RepUserDesc,RepLocDesc,ActDate,ActTime,SumAssess,Comments,DoTS,MainDiag,xLabRepID,SpecimenDr,LabEpisodeNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryINFMBRPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFMBRPrintExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryINFMBRPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFMBRPrintExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-16
/// Description:  取报告内容
/// Table：       DHCHAI.IR.INFMBR
/// Input：       ID:    DHCHAI.IR.INFMBR.ID
/// Return：      返回String
/// w ##class(DHCHAI.IRS.INFMBRSrv).GetReportString(1)
ClassMethod GetReportString(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	Set aSeparete = "^"
	
	Set obj=##class(DHCHAI.IR.INFMBR).GetObjById(aRepID)
	Quit:'$IsObject(obj) return

	Set return = aRepID_aSeparete                                     //1
	If $IsObject(obj.IREpisodeDr){                                    //2
		Set return = return_obj.IREpisodeDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	} 
	If $IsObject(obj.IRLabRepDr){                                     //3
		Set return = return_obj.IRLabRepDr.%Id()_aSeparete   	 
	}else {  
		Set return = return_""_aSeparete  
	} 
	If $IsObject(obj.IRSpecimenDr){                                   //4
		Set return = return_obj.IRSpecimenDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	} 
	Set return = return_obj.IRSubmissDate_aSeparete                   //5
	If $IsObject(obj.IRSubmissLocDr){                                 //6
		Set return = return_obj.IRSubmissLocDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	} 
	If $IsObject(obj.IRBactDicDr){                                    //7
		Set return = return_obj.IRBactDicDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	}         
	Set return = return_obj.IRBactDesc_aSeparete                      //8
	If $IsObject(obj.IRMRBDicDr){                                     //9
		Set return = return_obj.IRMRBDicDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	}         
	Set return = return_..GetDicByObj(obj.IRInfTypeDr)_aSeparete      //10  
	Set return = return_..GetDicByObj(obj.IRHandHygieneDr)_aSeparete  //11
	Set return = return_..GetDicByObj(obj.IRSecondCaseDr)_aSeparete   //12
	Set return = return_..GetDicByObj(obj.IRInsulatTypeDr)_aSeparete  //13
	Set return = return_obj.IRContactList_aSeparete                   //14
	Set return = return_obj.IRDropletList_aSeparete                   //15
	Set return = return_obj.IRPlaceList_aSeparete                     //16
	Set return = return_obj.IRUnitList_aSeparete                      //17
	Set return = return_obj.IRUintExt_aSeparete                       //18
	Set return = return_..GetDicByObj(obj.IRTreatMentDr)_aSeparete    //19 
	Set return = return_..GetDicByObj(obj.IREnvMentDr)_aSeparete      //20
	Set return = return_..GetDicByObj(obj.IRClothMentDr)_aSeparete    //21
	Set return = return_obj.IRVisitList_aSeparete                     //22
	Set return = return_obj.IREndList_aSeparete                       //23
	Set return = return_obj.IRResume_aSeparete                        //24
	Set return = return_obj.IRUpdateDate_aSeparete                    //25
	Set return = return_obj.IRUpdateTime_aSeparete                    //26
	If $IsObject(obj.IRUpdateUserDr){                                 //27
		Set return = return_obj.IRUpdateUserDr.%Id()_aSeparete   	
	}else {  
		Set return = return_""_aSeparete  
	}      
	Set return = return_obj.IRSumAssess_aSeparete                     // 28  //审核总结性评价
	Set return = return_obj.IRComments_aSeparete                      // 29  批注 add 20211116
	Set return = return_obj.IRDoTS_aSeparete                          // 30
	
    
	Quit return
}

ClassMethod GetDicByObj(obj As DHCHAI.BT.Dictionary) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_","_obj.BTDesc
	quit return
}

/// Creator：     pylian
/// CreatDate：   2017-09-15
/// Description:  保存报告内容
/// Table：       DHCHAI.IR.INFMBR,DHCHAI.IR.INFReport
/// Input：       aInputStr:多重耐菌报告内容
/// Return：      返回String
/// w ##class(DHCHAI.IRS.INFMBRSrv).SaveReport("1^1977^7923^3^^1540^1317^^^128^^^135^137,138,^143,147,^^154,^^159^^^^^^^^9#^1977^5^^^117^9^1#^1^^9","^")
ClassMethod SaveReport(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="") return
    Set aSeparete="^"
	Set $ZT="SaveReporErr"
	Set InputMBRStr = $p(aInputStr,"#",1)
	Set InputRepStr = $p(aInputStr,"#",2)
	Set InputLogStr = $p(aInputStr,"#",3)
	Set RepeatFlg   = $p(aInputStr,"#",4)
	TStart
	// 多重耐菌报告内容
	Set return = -1
	Set flg=##Class(DHCHAI.IR.INFMBR).Update(InputMBRStr,aSeparete)
	If flg=-1 TRollback
	Quit:(+flg)<1 return
	Set INFMBRID=+flg
	
	// 保存报告信息
	Set return = -2
	Set EpisodeDR  = $p(InputRepStr,aSeparete,2)
	Set RepType    = $p(InputRepStr,aSeparete,3)
	//*****************************************************
	//转换操作代码->ID
	Set StatusCode = $p(InputRepStr,aSeparete,8)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(InputRepStr,aSeparete,8)=StatusDr
	//*****************************************************
	Set INFRepInfo =..GetMBRRepID(EpisodeDR,INFMBRID)
	Set INFRepID=$p(INFRepInfo,aSeparete,1)
	If (INFRepID="") ||(RepeatFlg=1){   //重复提交更新提交日期、提交人、提交科室
		Set $p(InputRepStr,aSeparete,1)=INFRepID
		Set $p(InputRepStr,aSeparete,14)=INFMBRID
		Set flg=##Class(DHCHAI.IR.INFReport).Update(InputRepStr,aSeparete)
		If flg=-1 TRollback
		Quit:(+flg)<1 return
		Set ReportID=+flg
	}Else {
		Set ReportID=INFRepID
		Set flg=..SaveRepStatus(ReportID,StatusCode)
		If flg=-1 TRollback
		Quit:(+flg)<1 return	
	}
	
	// 保存报告日志信息
	Set return = -3
	Set $p(InputLogStr,aSeparete,1)=ReportID
	//*****************************************************
	//转换操作代码->ID
	Set StatusCode = $p(InputLogStr,aSeparete,2)
	Set StatusDr   = ""
	Set ObjStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",StatusCode)
	Set:$IsObject(ObjStatus) StatusDr=ObjStatus.%Id()
	Set $p(InputLogStr,aSeparete,2)=StatusDr
	//*****************************************************
	Set flg=##Class(DHCHAI.IR.INFRepLog).Update(InputLogStr,aSeparete)
	If flg=-1 TRollback
	Quit:(+flg)<1 return

    TCommit
	Set return=INFMBRID
	Quit return
SaveReporErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2017-09-15
/// Description:  保存报告内容(只保存更新状态)
/// Table：       DHCHAI.IR.INFReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCHAI.IRS.INFMBRSrv).SaveRepStatus("1","1")
ClassMethod SaveRepStatus(aReportID As %String, aStatus As %String) As %String
{
	New (aReportID,aStatus)
	Set return=0
	Quit:((aReportID="")||(aStatus="")) return
	Set $ZT="SaveRepStatusErr"

	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("InfReportStatus",aStatus)
	Quit:'$IsObject(objStatus) return
	
	Set obj=##class(DHCHAI.IR.INFReport).%OpenId(aReportID)
	Quit:'$IsObject(obj) return
	Set obj.IRStatusDr=objStatus
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
SaveRepStatusErr
	Quit -999_"^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2017-09-15
/// Description:  根据"就诊记录+报告类型+多耐信息"获取报告基本信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       inputStr : 多耐信息
/// Return：      返回DHCHAI.IR.INFReport.ID
/// w ##Class(DHCHAI.IRS.INFMBRSrv).GetMBRRepID("1977","5","1")
ClassMethod GetMBRRepID(aEpisodeDr As %String, aINFMBRID As %String) As %String
{
	New (aEpisodeDr,aINFMBRID,%session)
	Set return=""
	Quit:(aEpisodeDr="")||(aINFMBRID="") return
	
	Set DataType=$zcvt("DHCHAI.IR.INFMBR","U")
	Set ObjectID=$zcvt(aINFMBRID,"U")
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_DataType," "_ObjectID,xRepID))
		Quit:xRepID=""
		Quit:return'=""
		
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:objRep.IRRepType'="5"  //多耐报告
		
		Set RepDate  = objRep.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime = objRep.IRRepTime
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objRep.IRRepUser) {
			Set RepUserID   = objRep.IRRepUser.%Id() 
			Set RepUserDesc = objRep.IRRepUser.BTDesc
		}
		Set (StatusID,StatusCode,StatusDesc)=""
		If $IsObject(objRep.IRStatusDr) {
			Set StatusID   = objRep.IRStatusDr.%Id() 
			Set StatusCode = objRep.IRStatusDr.BTCode 
			Set StatusDesc = objRep.IRStatusDr.BTDesc
		}
		Set (RepLocID,RepLoc) =""
		If $IsObject(objRep.IRRepLocDr) {
			Set RepLocID   = objRep.IRRepLocDr.%Id() 
			Set RepLoc = objRep.IRRepLocDr.BTDesc
		}
		//多语言处理
		Set RepUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RepUserDesc,"User.SSUser")
		Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
		Set RepLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RepLoc,"User.CTLoc")
		
		Set return=xRepID_"^"_RepDate_"^"_RepUserID_"^"_RepUserDesc_"^"_StatusID_"^"_StatusCode_"^"_StatusDesc_"^"_RepTime_"^"_RepLocID_"^"_RepLoc
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-11
/// Description:  查询耐药菌报告情况
/// Table：       DHCHAI.IR.INFMBR
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFMBRSrv","QryINFMBRSrv","1|3|4","2022-08-01","2022-08-18","","","","")
Query QryINFMBRSrv(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aIntputs As %String = "", aStatus As %String = "") As %Query(ROWSPEC = "ID:%String,AdmID:%String,EpisodeID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmBed:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,xLabRepID:%String,ResultID:%String,SpeID:%String,SpeCode:%String,SpecDesc:%String,SubmissDate:%String,LocID:%String,LocCode:%String,LocDesc:%String,BacID:%String,BacCode:%String,BacDesc:%String,BactDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDesc:%String,HandID:%String,HandCode:%String,HandDesc:%String,CaseID:%String,CaseCode:%String,CaseDesc:%String,InsulatID:%String,InsulatCode:%String,InsulatDesc:%String,ContactListID:%String,ContactListCode:%String,ContactListDesc:%String,DropletListID:%String,DropletListCode:%String,DropletListDesc:%String,PlaceListID:%String,PlaceListCode:%String,PlaceListDesc:%String,UnitListID:%String,UnitListCode:%String,UnitListDesc:%String,UintExt:%String,TreatID:%String,TreatCode:%String,TreatDesc:%String,EnvID:%String,EnvCode:%String,EnvDesc:%String,ClothID:%String,ClothCode:%String,ClothDesc:%String,VisitListID:%String,VisitListCode:%String,VisitListDesc:%String,EndListID:%String,EndListCode:%String,EndListDesc:%String,StatusCode:%String,RepStatus:%String,RepDate:%String,RepUser:%String,ActDate:%String,ActTime:%String,SumAssess:%String,Comments:%String,RepID:%String,RepTime:%String,RepLoc:%String") [ SqlProc ]
{
}

ClassMethod QryINFMBRSrvExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aInfID As %String, aBactID As %String, aMRBID As %String, aIntputs As %String = "", aStatus As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aPatName = $p(aIntputs,"^",1)
 	Set aPapmiNo = $p(aIntputs,"^",2)
 	Set aMrNo 	 = $p(aIntputs,"^",3)
	For xDate=aDateFrom:1:aDateTo {		
		Set xID=""
		For {
 			Set xID=$o(^DHCHAI.IR.INFMBRI("IndexSubmissDate",xDate,xID))
			Quit:xID=""
			Set objInf = ##class(DHCHAI.IR.INFMBR).GetObjById(xID)
			Continue:'$Isobject(objInf)
			Continue:'$Isobject(objInf.IREpisodeDr)
		   	//病人基本信息
			Set AdmID  = objInf.IREpisodeDr.%Id()
			Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(AdmID)
			Continue:'$Isobject(objAdm)
			Set EpisodeID = objAdm.PAEpisodeIDx
			Set PatientID = objAdm.PAPatientIDx
			Set PapmiNo   = objAdm.PAPapmiNo
			Continue:(aPapmiNo'="")&(aPapmiNo'=PapmiNo)
			Set MrNo      = objAdm.PAMrNo
			Continue:(aMrNo'="")&(aMrNo'=MrNo)
			Set PatName   = objAdm.PAPatName
			Continue:(aPatName'="")&(PatName'[aPatName)
			Set Sex       = objAdm.PASex
			Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
			Set AdmDate   = objAdm.PAAdmDate
			Set AdmTime   = objAdm.PAAdmTime
			Set Age       = objAdm.PAAge
			Set DischDate = objAdm.PADischDate
			Set DischTime = objAdm.PADischTime
			Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	        Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set:DischTime'="" DischTime=$zt(DischTime,1)
			Set (AdmBedDr,AdmBed)=""
			If $IsObject(objAdm.PAAdmBedDr){
				Set AdmBedDr=objAdm.PAAdmBedDr.%Id()
				Set AdmBed=objAdm.PAAdmBedDr.BTDesc
			}
			Set objAdmLoc = objAdm.PAAdmLocDr
			Set AdmLocID="", AdmLocDesc=""    //就诊科室
			If $Isobject(objAdmLoc) {
				Set AdmLocID = objAdmLoc.%Id()
				Set AdmLocDesc = objAdmLoc.BTDesc
				Set AdmLocDesc2 = objAdmLoc.BTDesc2
				Set AdmLocDesc = $s(AdmLocDesc2'="":AdmLocDesc2,1:AdmLocDesc)
			}
			Set objAdmWard = objAdm.PAAdmWardDr
			Set AdmWardID="",AdmWardDesc=""   //就诊病区
			If $Isobject(objAdmWard) {
				Set AdmWardID  = objAdmWard.%Id()
				Set AdmWardDesc = objAdmWard.BTDesc
				Set AdmWardDesc2 = objAdmWard.BTDesc2
				Set AdmWardDesc = $s(AdmWardDesc2'="":AdmWardDesc2,1:AdmWardDesc)
				If $IsObject(objAdmWard.BTHospDr){
					Set HospID=objAdmWard.BTHospDr.%Id()			
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)  	//医院过滤	
				}
			}
           	Continue:(aLocID'="")&&(aLocID'=AdmWardID)&&(aLocID'=AdmLocID)
           	//外院携带多耐信息
	        If ($IsObject(objInf.IROutLabRepDr)){
	        	Set xLabRepID=""
	        	Set ActDate = objInf.IROutLabRepDr.LabAuthDate
		        Set ActTime = "1"
		        Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set xResultID="",ResultID="",InfTypeID="",InfTypeDesc=""
				Set InfTypeCode=objInf.IROutLabRepDr.LabMakeInfType
	        }else{
		        //多耐报告信息
		         Continue:'$Isobject(objInf.IRLabRepDr)
		        Set xLabRepID=objInf.IRLabRepDr.%Id()    //检验报告指针
		        Continue:xLabRepID=""
		        Set objLabRep=##class(DHCHAI.DP.LabVisitReport).GetObjById(xLabRepID)
		        Continue:'$Isobject(objLabRep)
		        Continue:objLabRep.LabIsActive'=1
		        Set ActDate = objLabRep.LabAuthDate
		        Set ActTime = objLabRep.LabAuthTime
		        Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime,1)
			    Set xResultID="",ResultID="",InfTypeID="",InfTypeCode="",InfTypeDesc=""
				For {
					Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xLabRepID,xResultID))
					Quit:xResultID=""
				    Continue:'$d(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",xResultID))
				    Set ResultID=xResultID
				    Set objLabRes= ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(ResultID)
					If $IsObject(objLabRes) {
		   		 		Set InfTypeCode = objLabRes.LabMakeInfType   //感染类型
					}
				}
	        }
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByCode("IRInfType",InfTypeCode)
		    If $IsObject(objDic) {
			    Set InfTypeID 	= objDic.%Id()
			    Set InfTypeDesc = objDic.BTDesc		
			}
			Continue:(aInfID'="")&&(InfTypeID'=aInfID)
			Set SpeID="",SpeCode="",SpecDesc=""
			If $IsObject(objInf.IRSpecimenDr){
				Set SpeID =  objInf.IRSpecimenDr.%Id()
				Set SpeCode = objInf.IRSpecimenDr.BTSpecCode
				Set SpecDesc = objInf.IRSpecimenDr.BTSpecDesc
			}
			Set SubmissDate    = objInf.IRSubmissDate  
			Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate) 
		
			Set LocID="", LocCode="", LocDesc=""
			If $IsObject(objInf.IRSubmissLocDr ){
				Set LocID =  objInf.IRSubmissLocDr.%Id()
				Set LocCode = objInf.IRSubmissLocDr.BTCode
				Set LocDesc = objInf.IRSubmissLocDr.BTDesc
			}
			
			Set BacID="",BacCode="",BacDesc=""
			If $IsObject(objInf.IRBactDicDr){
				Set BacID =  objInf.IRBactDicDr.%Id()
				Set BacCode = objInf.IRBactDicDr.BTBacCode
				Set BacDesc = objInf.IRBactDicDr.BTBacDesc
			} 
			Continue:(aBactID'="")&&(BacID'=aBactID)   
			Set BactDesc       = objInf.IRBactDesc 
			     
			Set MRBID="",MRBCode="",MRBDesc=""
			If $IsObject(objInf.IRMRBDicDr){
				Set MRBID =  objInf.IRMRBDicDr.%Id()
				Set MRBCode = objInf.IRMRBDicDr.BTCode
				Set MRBDesc = objInf.IRMRBDicDr.BTDesc
			}
			Continue:(aMRBID'="")&&(aMRBID'=MRBID)         
			/*
			Set InfTypeID="",InfTypeCode="",InfTypeDesc=""
			If $IsObject(objInf.IRInfTypeDr){
				Set InfTypeID =  objInf.IRInfTypeDr.%Id()
				Set InfTypeCode = objInf.IRInfTypeDr.BTCode
				Set InfTypeDesc = objInf.IRInfTypeDr.BTDesc
			}  
			
			Continue:(aInfID'="")&&(InfTypeID'=aInfID)  
			*/         
			Set HandID="",HandCode="",HandDesc=""
			If $IsObject(objInf.IRHandHygieneDr){
				Set HandID =  objInf.IRHandHygieneDr.%Id()
				Set HandCode = objInf.IRHandHygieneDr.BTCode
				Set HandDesc = objInf.IRHandHygieneDr.BTDesc
			}   

			Set CaseID="",CaseCode="",CaseDesc=""
			If $IsObject(objInf.IRSecondCaseDr){
				Set CaseID =  objInf.IRSecondCaseDr.%Id()
				Set CaseCode = objInf.IRSecondCaseDr.BTCode
				Set CaseDesc = objInf.IRSecondCaseDr.BTDesc
			} 

			Set InsulatID="",InsulatCode="",InsulatDesc=""
			If $IsObject(objInf.IRInsulatTypeDr){
				Set InsulatID =  objInf.IRInsulatTypeDr.%Id()
				Set InsulatCode = objInf.IRInsulatTypeDr.BTCode
				Set InsulatDesc = objInf.IRInsulatTypeDr.BTDesc
			}  
			      
			Set ContactListID   = objInf.IRContactList 
			Set ContactListCode="",ContactListDesc=""
			For indx=1:1:$l(ContactListID,","){
				Set ContactID=$p(ContactListID,",",indx)
				Continue:ContactID=""
				Set ContactCode="",ContactDesc=""	
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(ContactID)
				If $IsObject(objDic){
					Set ContactCode = objDic.BTCode
					Set ContactDesc = objDic.BTDesc
				}  
				Set ContactListCode=ContactListCode_","_ContactCode
				Set ContactListDesc=ContactListDesc_","_ContactDesc
			} 
			Set:ContactListCode'="" ContactListCode=$e(ContactListCode,2,$l(ContactListCode))
			Set:ContactListDesc'="" ContactListDesc=$e(ContactListDesc,2,$l(ContactListDesc))
		
			Set DropletListID   = objInf.IRDropletList  	
			Set DropletListCode="",DropletListDesc=""
			For indy=1:1:$l(DropletListID,","){
				Set DropletID=$p(DropletListID,",",indy)
				Continue:DropletID=""
				Set DropletCode="",	DropletDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(DropletID)
				If $IsObject(objDic){
					Set DropletCode = objDic.BTCode
					Set DropletDesc = objDic.BTDesc
				}  
				Set DropletListCode=DropletListCode_","_DropletCode
				Set DropletListDesc=DropletListDesc_","_DropletDesc
			} 
			Set:DropletListCode'="" DropletListCode=$e(DropletListCode,2,$l(DropletListCode))
			Set:DropletListDesc'="" DropletListDesc=$e(DropletListDesc,2,$l(DropletListDesc))
           
			Set PlaceListID     = objInf.IRPlaceList 
			Set PlaceListCode="",PlaceListDesc=""
			For indz=1:1:$l(PlaceListID,","){
				Set PlaceID=$p(PlaceListID,",",indz)
				Continue:PlaceID=""
				Set PlaceCode="",	PlaceDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(PlaceID)
				If $IsObject(objDic){
					Set PlaceCode = objDic.BTCode
					Set PlaceDesc = objDic.BTDesc
				}  
				Set PlaceListCode=PlaceListCode_","_PlaceCode
				Set PlaceListDesc=PlaceListDesc_","_PlaceDesc
			} 
			Set:PlaceListCode'="" PlaceListCode=$e(PlaceListCode,2,$l(PlaceListCode))
			Set:PlaceListDesc'="" PlaceListDesc=$e(PlaceListDesc,2,$l(PlaceListDesc))
   
			Set UnitListID      = objInf.IRUnitList 
			Set UnitListCode="",UnitListDesc=""
			For indm=1:1:$l(UnitListID,","){
				Set UnitID=$p(UnitListID,",",indm)
				Continue:UnitID=""
				Set UnitCode="",	UnitDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(UnitID)
				If $IsObject(objDic){
					Set UnitCode = objDic.BTCode
					Set UnitDesc = objDic.BTDesc
				}  
				Set UnitListCode=UnitListCode_","_UnitCode
				Set UnitListDesc=UnitListDesc_","_UnitDesc
			} 
			Set:UnitListCode'="" UnitListCode=$e(UnitListCode,2,$l(UnitListCode))
			Set:UnitListDesc'="" UnitListDesc=$e(UnitListDesc,2,$l(UnitListDesc))
    
			Set UintExt        = objInf.IRUintExt       
			Set TreatID="",TreatCode="",TreatDesc=""
			If $IsObject(objInf.IRTreatMentDr){
				Set TreatID =  objInf.IRTreatMentDr.%Id()
				Set TreatCode = objInf.IRTreatMentDr.BTCode
				Set TreatDesc = objInf.IRTreatMentDr.BTDesc
			}   
		
			Set EnvID="",EnvCode="",EnvDesc=""
			If $IsObject(objInf.IREnvMentDr){
				Set EnvID =  objInf.IREnvMentDr.%Id()
				Set EnvCode = objInf.IREnvMentDr.BTCode
				Set EnvDesc = objInf.IREnvMentDr.BTDesc
			}        

			Set ClothID="",ClothCode="",ClothDesc=""
			If $IsObject(objInf.IRClothMentDr){
				Set ClothID =  objInf.IRClothMentDr.%Id()
				Set ClothCode = objInf.IRClothMentDr.BTCode
				Set ClothDesc = objInf.IRClothMentDr.BTDesc
			}     
			Set VisitListID     = objInf.IRVisitList
			Set VisitListCode="",VisitListDesc=""
			For indn=1:1:$l(VisitListID,","){
				Set VisitID=$p(VisitListID,",",indn)
				Continue:VisitID=""
				Set VisitCode="",	VisitDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(VisitID)
				If $IsObject(objDic){
					Set VisitCode = objDic.BTCode
					Set VisitDesc = objDic.BTDesc
				}  
				Set VisitListCode=VisitListCode_","_VisitCode
				Set VisitListDesc=VisitListDesc_","_VisitDesc
			} 
			Set:VisitListCode'="" VisitListCode=$e(VisitListCode,2,$l(VisitListCode))
			Set:VisitListDesc'="" VisitListDesc=$e(VisitListDesc,2,$l(VisitListDesc))
  
			Set EndListID       = objInf.IREndList
			Set EndListCode="",EndListDesc=""
			For indt=1:1:$l(EndListID,","){
				Set EndID=$p(EndListID,",",indt)
				Continue:EndID=""
				Set EndCode="",	EndDesc=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(EndID)
				If $IsObject(objDic){
					Set EndCode = objDic.BTCode
					Set EndDesc = objDic.BTDesc
				}  
				Set EndListCode=EndListCode_","_EndCode
				Set EndListDesc=EndListDesc_","_EndDesc
			} 
			Set:EndListCode'="" EndListCode=$e(EndListCode,2,$l(EndListCode))
			Set:EndListDesc'="" EndListDesc=$e(EndListDesc,2,$l(EndListDesc))
    
			Set Resume         = objInf.IRResume 
			  
			// 院感报告信息
			Set RepID="",RepStatus="",StatusCode="",RepUser="",RepDate="",RepTime="",RepLoc=""  
			Set RepInfo =..GetMBRRepID(AdmID,xID)
			If (RepInfo'=""){
				Set RepID      = $p(RepInfo,"^",1)
				Set RepDate    = $p(RepInfo,"^",2)
				Set RepUser    = $p(RepInfo,"^",4)
				Set RepStatus  = $p(RepInfo,"^",7)
				Set StatusCode = $p(RepInfo,"^",6)
				Set RepTime    = $p(RepInfo,"^",8)
				Set RepLoc     = $p(RepInfo,"^",10)
			}
	       	Set SumAssess      = objInf.IRSumAssess
	       	Set Comments       = objInf.IRComments   //批注 add  20211116 
	       	If (aStatus'=""){
		       	Quit:RepStatus'=aStatus
		    }
		    // 多语言处理
		    Set PatName=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PatName,"User.SSUser")
		    Set AdmWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWardDesc,"User.CTLoc")
		    Set SpecDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpecDesc,"DHCHAI.DP.LabSpecimen")  
            Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB") 
            Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
            Set InsulatDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InsulatDesc,"DHCHAI.BT.Dictionary")
            Set ContactListDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ContactListDesc,"DHCHAI.BT.Dictionary")
            Set PlaceListDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",PlaceListDesc,"DHCHAI.BT.Dictionary")
            Set UnitListDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",UnitListDesc,"DHCHAI.BT.Dictionary")
            Set TreatDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",TreatDesc,"DHCHAI.BT.Dictionary")
            Set EnvDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",EnvDesc,"DHCHAI.BT.Dictionary")
            Set ClothDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ClothDesc,"DHCHAI.BT.Dictionary")
            Set VisitListDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",VisitListDesc,"DHCHAI.BT.Dictionary")
            Set EndListDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",EndListDesc,"DHCHAI.BT.Dictionary")
            Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")  //性别
			Set:Age["岁" Age=$Replace(Age,"岁",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","岁"))  //年龄
			Set:Age["月" Age=$Replace(Age,"月",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","月"))
			Set:Age["天" Age=$Replace(Age,"天",##class(DHCHAI.Abstract).TranslationGet("Bill.Com.Age","天"))
			
            Set Data = $lb(xID,AdmID,EpisodeID,MrNo,PapmiNo,PatName,Sex,Age,AdmLocDesc,AdmWardDesc,AdmBed,AdmDate,AdmTime,DischDate,DischTime)
            Set Data = Data_$lb(xLabRepID,ResultID,SpeID,SpeCode,SpecDesc,SubmissDate,LocID,LocCode,LocDesc,BacID,BacCode,BacDesc)
			Set Data = Data_$lb(BactDesc,MRBID,MRBCode,MRBDesc,InfTypeID,InfTypeCode,InfTypeDesc)
			Set Data = Data_$lb(HandID,HandCode,HandDesc,CaseID,CaseCode,CaseDesc,InsulatID,InsulatCode,InsulatDesc)
			Set Data = Data_$lb(ContactListID,ContactListCode,ContactListDesc,DropletListID,DropletListCode,DropletListDesc)
            Set Data = Data_$lb(PlaceListID,PlaceListCode,PlaceListDesc,UnitListID,UnitListCode,UnitListDesc,UintExt)
            Set Data = Data_$lb(TreatID,TreatCode,TreatDesc,EnvID,EnvCode,EnvDesc,ClothID,ClothCode,ClothDesc)
			Set Data = Data_$lb(VisitListID,VisitListCode,VisitListDesc,EndListID,EndListCode,EndListDesc)
			Set Data = Data_$lb(StatusCode,RepStatus,RepDate,RepUser,ActDate,ActTime,SumAssess,Comments,RepID,RepTime,RepLoc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 		
	}
	Quit $$$OK
}

ClassMethod QryINFMBRSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFMBRSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryINFMBRSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFMBRSrvExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhaoyj
/// CreatDate：   2022-07-01
/// Description:  查询多耐报告操作明细
/// Table：       DHCHAI.IR.INFRepLog
/// Input:        aRepID：报告ID 
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFMBRSrv","QryMBRRepLog","3")
Query QryMBRRepLog(aRepID As %String, aStatus As %String = "") As %Query(ROWSPEC = "SubID:%String,LogID:%String,StatusCode:%String,StatusDesc:%String,Opinion:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserCode:%String,UpdateUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMBRRepLogExecute(ByRef qHandle As %Binary, aRepID As %String, aStatus As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Quit:(aRepID="") $$$OK
 	
 	Set xSubID=""
 	For {
	 	Set xSubID=$o(^DHCHAI.IR.INFReportD(aRepID,"LOG",xSubID))
	 	Quit:xSubID=""
	 	
	 	Set LogID=aRepID_"||"_xSubID
	 	Set objRegLog = ##class(DHCHAI.IR.INFRepLog).GetObjById(LogID)
	 	Continue:'$IsObject(objRegLog)
	 	
	 	Set objStatus=objRegLog.IRStatusDr
	 	Set StatusID="", StatusCode="",StatusDesc=""
		If $IsObject(objStatus) {
			Set StatusID = objStatus.%Id()
			Set StatusCode = objStatus.BTCode
			Set StatusDesc = objStatus.BTDesc
		}
		Continue:(aStatus'="")&&(aStatus'=StatusCode)
		Set Opinion=objRegLog.IROpinion
		Set UpdateDate=objRegLog.IRUpdateDate
		Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate) 
		Set UpdateTime=objRegLog.IRUpdateTime
	    Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	    		
		Set objUser=objRegLog.IRUpdateUserDr
		Set UpdateUserID="", UpdateUserCode="",UpdateUserDesc=""
		If $IsObject(objUser) {
			Set UpdateUserID = objUser.%Id()
			Set UpdateUserCode = objUser.BTCode
			Set UpdateUserDesc = objUser.BTDesc
 		} 
 		// 多语言处理
 		Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")  //报告状态
 		Set UpdateUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",UpdateUserDesc,"User.SSUser")            //审核人
 		
 		Set Data=$lb(xSubID,LogID,StatusCode,StatusDesc,Opinion,UpdateDate,UpdateTime,UpdateUserCode,UpdateUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	Quit $$$OK
}

ClassMethod QryMBRRepLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpRepLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMBRRepLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpRepLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     pylian
/// CreatDate：   2021-03-29
/// Description:  查询患者耐药菌报告情况
/// Table：       DHCHAI.IR.INFMBR
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.INFMBRSrv","QryMBRRepSrv","37")
Query QryMBRRepSrv(aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,EpisodeID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,MBRRepID:%String,LabRepID:%String,SpeID:%String,SpeCode:%String,SpecDesc:%String,SubmissDate:%String,LocID:%String,LocCode:%String,LocDesc:%String,MRBID:%String,MRBCode:%String,MRBDesc:%String,InfTypeID:%String,InfTypeCode:%String,InfTypeDesc:%String,HandID:%String,HandCode:%String,HandDesc:%String,CaseID:%String,CaseCode:%String,CaseDesc:%String,InsulatID:%String,InsulatCode:%String,InsulatDesc:%String,ContactListID:%String,ContactListCode:%String,ContactListDesc:%String,DropletListID:%String,DropletListCode:%String,DropletListDesc:%String,PlaceListID:%String,PlaceListCode:%String,PlaceListDesc:%String,StatusCode:%String,StatusDesc:%String,RepDate:%String,RepTime:%String,RepUser:%String") [ SqlProc ]
{
}

ClassMethod QryMBRRepSrvExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xRepID = ""
	For {
		Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,5,xRepID))
		Quit:xRepID=""
		
		Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		Set RepDate  = objRep.IRRepDate
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime  = objRep.IRRepTime
		Set:RepTime'="" RepTime=$zt(RepTime,1)
		
		Set (RepUserID,RepUserDesc)=""
		If $IsObject(objRep.IRRepUser) {
			Set RepUserID   = objRep.IRRepUser.%Id() 
			Set RepUserDesc = objRep.IRRepUser.BTDesc
		}
		Set (StatusID,StatusCode,StatusDesc)=""
		If $IsObject(objRep.IRStatusDr) {
			Set StatusID   = objRep.IRStatusDr.%Id() 
			Set StatusCode = objRep.IRStatusDr.BTCode 
			Set StatusDesc = objRep.IRStatusDr.BTDesc
		}
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
		Continue:'$Isobject(objAdm)	
		Set PapmiNo   = objAdm.PAPapmiNo
		Set MrNo      = objAdm.PAMrNo
		Set PatName   = objAdm.PAPatName
		Set Sex       = objAdm.PASex
		Set Sex       = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")
		Set Age       = objAdm.PAAge
	
		Set MBRRepID   = objRep.GetRepLinkIDs("DHCHAI.IR.INFMBR")  //多耐报告信息
		Set objInf=##class(DHCHAI.IR.INFMBR).GetObjById(MBRRepID)
		Continue:'$Isobject(objInf)
		Continue:'$Isobject(objInf.IRLabRepDr)
		Set LabRepID = objInf.IRLabRepDr.%Id()
	
		Set SpeID="",SpeCode="",SpecDesc=""
		If $IsObject(objInf.IRSpecimenDr){
			Set SpeID =  objInf.IRSpecimenDr.%Id()
			Set SpeCode = objInf.IRSpecimenDr.BTSpecCode
			Set SpecDesc = objInf.IRSpecimenDr.BTSpecDesc
		}
		Set SubmissDate    = objInf.IRSubmissDate  
		Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate) 
	
		Set LocID="", LocCode="", LocDesc=""
		If $IsObject(objInf.IRSubmissLocDr ){
			Set LocID =  objInf.IRSubmissLocDr.%Id()
			Set LocCode = objInf.IRSubmissLocDr.BTCode
			Set LocDesc = objInf.IRSubmissLocDr.BTDesc
		}
		
		Set MRBID="",MRBCode="",MRBDesc=""
		If $IsObject(objInf.IRMRBDicDr){
			Set MRBID =  objInf.IRMRBDicDr.%Id()
			Set MRBCode = objInf.IRMRBDicDr.BTCode
			Set MRBDesc = objInf.IRMRBDicDr.BTDesc
		}
		Set InfTypeID="",InfTypeCode="",InfTypeDesc=""
		If $IsObject(objInf.IRInfTypeDr){
			Set InfTypeID =  objInf.IRInfTypeDr.%Id()
			Set InfTypeCode = objInf.IRInfTypeDr.BTCode
			Set InfTypeDesc = objInf.IRInfTypeDr.BTDesc
		}  

		Set HandID="",HandCode="",HandDesc=""
		If $IsObject(objInf.IRHandHygieneDr){
			Set HandID =  objInf.IRHandHygieneDr.%Id()
			Set HandCode = objInf.IRHandHygieneDr.BTCode
			Set HandDesc = objInf.IRHandHygieneDr.BTDesc
		}   

		Set CaseID="",CaseCode="",CaseDesc=""
		If $IsObject(objInf.IRSecondCaseDr){
			Set CaseID =  objInf.IRSecondCaseDr.%Id()
			Set CaseCode = objInf.IRSecondCaseDr.BTCode
			Set CaseDesc = objInf.IRSecondCaseDr.BTDesc
		} 

		Set InsulatID="",InsulatCode="",InsulatDesc=""
		If $IsObject(objInf.IRInsulatTypeDr){
			Set InsulatID =  objInf.IRInsulatTypeDr.%Id()
			Set InsulatCode = objInf.IRInsulatTypeDr.BTCode
			Set InsulatDesc = objInf.IRInsulatTypeDr.BTDesc
		}  
			  
		Set ContactListID   = objInf.IRContactList 
		Set ContactListCode="",ContactListDesc=""
		For indx=1:1:$l(ContactListID,","){
			Set ContactID=$p(ContactListID,",",indx)
			Continue:ContactID=""
			Set ContactCode="",ContactDesc=""	
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(ContactID)
			If $IsObject(objDic){
				Set ContactCode = objDic.BTCode
				Set ContactDesc = objDic.BTDesc
			}  
			Set ContactListCode=ContactListCode_","_ContactCode
			//多语言处理 调整为界面取值
			//Set ContactListDesc=ContactListDesc_","_ContactDesc
			Set ContactListDesc=ContactListDesc_","_##class(websys.Translation).Get("dhcma.hai.ir.mrb.ctlreport.csp",ContactDesc)
			
		} 
		Set:ContactListCode'="" ContactListCode=$e(ContactListCode,2,$l(ContactListCode))
		Set:ContactListDesc'="" ContactListDesc=$e(ContactListDesc,2,$l(ContactListDesc))
	
		Set DropletListID   = objInf.IRDropletList  	
		Set DropletListCode="",DropletListDesc=""
		For indy=1:1:$l(DropletListID,","){
			Set DropletID=$p(DropletListID,",",indy)
			Continue:DropletID=""
			Set DropletCode="",	DropletDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(DropletID)
			If $IsObject(objDic){
				Set DropletCode = objDic.BTCode
				Set DropletDesc = objDic.BTDesc
			}  
			Set DropletListCode=DropletListCode_","_DropletCode
			Set DropletListDesc=DropletListDesc_","_DropletDesc
		} 
		Set:DropletListCode'="" DropletListCode=$e(DropletListCode,2,$l(DropletListCode))
		Set:DropletListDesc'="" DropletListDesc=$e(DropletListDesc,2,$l(DropletListDesc))
	   
		Set PlaceListID     = objInf.IRPlaceList 
		Set PlaceListCode="",PlaceListDesc=""
		For indz=1:1:$l(PlaceListID,","){
			Set PlaceID=$p(PlaceListID,",",indz)
			Continue:PlaceID=""
			Set PlaceCode="",	PlaceDesc=""
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(PlaceID)
			If $IsObject(objDic){
				Set PlaceCode = objDic.BTCode
				Set PlaceDesc = objDic.BTDesc
			}  
			Set PlaceListCode=PlaceListCode_","_PlaceCode
			Set PlaceListDesc=PlaceListDesc_","_PlaceDesc
		} 
		Set:PlaceListCode'="" PlaceListCode=$e(PlaceListCode,2,$l(PlaceListCode))
		Set:PlaceListDesc'="" PlaceListDesc=$e(PlaceListDesc,2,$l(PlaceListDesc))
		//多语言处理
		Set MRBDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",MRBDesc,"DHCHAI.IR.CRuleMRB")
		Set SpecDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTSpecDesc",SpecDesc,"DHCHAI.DP.LabSpecimen")
		Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		Set StatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",StatusDesc,"DHCHAI.BT.Dictionary")
		Set InsulatDesc=##class(websys.Translation).Get("dhcma.hai.ir.mrb.ctlreport.csp",InsulatDesc)
		Set InfTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfTypeDesc,"DHCHAI.BT.Dictionary")
		Set Data = $lb(xRepID,aEpisodeID,MrNo,PapmiNo,PatName,Sex,Age,MBRRepID,LabRepID,SpeID,SpeCode,SpecDesc,SubmissDate)
		Set Data = Data_$lb(LocID,LocCode,LocDesc,MRBID,MRBCode,MRBDesc,InfTypeID,InfTypeCode,InfTypeDesc)
		Set Data = Data_$lb(HandID,HandCode,HandDesc,CaseID,CaseCode,CaseDesc,InsulatID,InsulatCode,InsulatDesc)
		Set Data = Data_$lb(ContactListID,ContactListCode,ContactListDesc,DropletListID,DropletListCode,DropletListDesc)
		Set Data = Data_$lb(PlaceListID,PlaceListCode,PlaceListDesc,StatusCode,StatusDesc,RepDate,RepTime,RepUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryMBRRepSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMBRRepSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMBRRepSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMBRRepSrvExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
