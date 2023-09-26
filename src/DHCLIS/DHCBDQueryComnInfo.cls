Class DHCLIS.DHCBDQueryComnInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 返回1有配血记录 返回0 无
ClassMethod IsXMPlan(AdmID As %String)
{
	   S AdmID=$G(AdmID)
	   I '$L(AdmID) Q "-1^就诊号为空"
	   s indexAdmNo=##Class(LIS.Util.Common).IndexData(AdmID)
	   s BDReqFormRowID="",XMCount=0
	   for {
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAdmNo",indexAdmNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s PackDR="" 
			for {
				s PackDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR))
			    q:PackDR=""
			    s XMPlanDR=""
				for {
				    s XMPlanDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR,XMPlanDR))
			        q:XMPlanDR=""
			        s XMCount=XMCount+1
				
				    }
				}	
		}
		i XMCount>0 q "1"
		e  q "0"
}

/// 返回1有发血记录 返回0 无
ClassMethod IsIssPack(AdmID As %String)
{
	   S AdmID=$G(AdmID)
	   I '$L(AdmID) Q "-1^就诊号为空"
	   s indexAdmNo=##Class(LIS.Util.Common).IndexData(AdmID)
	   s BDReqFormRowID="",ISSCount=0
	   for {
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAdmNo",indexAdmNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s IssRecordDR="" 
			for {
				s IssRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormRowID,IssRecordDR))
			    q:IssRecordDR=""
			    s ISSCount=ISSCount+1
			}
		}
		i ISSCount>0 q "1"
		e  q "0"
}

/// Creator：      JinChao
/// CreatDate：    20210716
/// Description:： 查询列表信息
/// Table：        BD_Reaction
/// Input：        
/// Output：       
/// Return：         
/// Others：         SttDate, EndDate, FRecordNo, FAddUserDR, FLocationDR, FRegNo, FSurName, FStatus
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QueryBDAdverseReactionSample","","","","","","","","","1708","","","","","","8388^^210^42^1")
Query QueryBDAdverseReactionSample(SttDate, EndDate, FRecordNo, FAddUserDR, fLocationCode, fRegNo, FSurName, fStatus, FAdmID, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,ReactionNo,PatName,RegNo,AgeDesc,BedNo,StatusDesc,Status,SpeciesName,LocationName,WardName,ABOName,RHName,Diagnosis,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment,AdverseReactionDate,AdverseReactionTime,RectionPerformance")
{
}

ClassMethod QueryBDAdverseReactionSampleExecute(ByRef qHandle As %Binary, SttDate, EndDate, FRecordNo, FAddUserDR, fLocationCode, fRegNo, FSurName, fStatus, FAdmID, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	s ^jcList=$lb(SttDate,EndDate,FRecordNo,FAddUserDR,fLocationCode,fRegNo,FSurName,fStatus, FAdmID, P9, P10, P11, PageSize, PageIndex, Sessions)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	s fStatus=$g(fStatus),fStatus=$g(fStatus),SttDate=$g(SttDate),EndDate=$g(EndDate)
 	S SttDate=$TR(SttDate,"-","")
 	S EndDate=$TR(EndDate,"-","")
 	I '$l(fRegNo),$L(FAdmID) S fRegNo=##Class(LISAPP.Common.BLL.PatientInfo).GetPatientID(FAdmID)
 	
 	
 	i '$l(fRegNo) d
 	.s DefaultDay="100"
 	.i '$l(SttDate) d
 	..s SttDate=$zd(+$h-DefaultDay,8)
 	..s EndDate=$zd(+$h,8)
 
 	i fStatus="RecAll" s fStatus="^7^9^11^"
 	i fStatus="DealAll" s fStatus="^11^9^"
   
 	i $l(fRegNo) d
 	.s IndexRegNo = ##Class(LIS.Util.Common).IndexData(fRegNo)
 	.s ReactionDR="" f  s ReactionDR=$o(^dbo.BDReactionI("IndexRegNo",IndexRegNo,ReactionDR),-1) q:ReactionDR=""  d
 	..b 
 	..d GetData
 	e  d
 	.s Date=SttDate-1 f  s Date=$o(^dbo.BDReactionI("IndexNurCheckDate",Date)) q:((Date="")||(Date>EndDate))  d
 	..s ReactionDR="" f  s ReactionDR=$o(^dbo.BDReactionI("IndexNurCheckDate",Date,ReactionDR)) q:ReactionDR=""  d
 	...d GetData
 	
 	s Count="" f  s Count=$o(^TMP($zn,repid,"DATA",Count)) q:Count=""  d
	.i FormRow>0,ToRow>0,FormRow>Count q
	.i FormRow>0,ToRow>0,ToRow<Count q 
	.s Data=$g(^TMP($zn,repid,"DATA",Count))
	.s ColFields="RowID,ReactionNo,PatName,RegNo,AgeDesc,BedNo,StatusDesc,Status,SpeciesName,LocationName,WardName,ABOName,RHName,Diagnosis,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment,AdverseReactionDate,AdverseReactionTime,RectionPerformance"
 	.s ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
    .S ind=ind+1  
    
 	k ^TMP($zn,repid,"DATA") 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

GetData
    s (RowID,ReactionNo,PatName,RegNo,AgeDesc,BedNo,StatusDesc,Status,SpeciesName,LocationName,WardName,ABOName,RHName,Diagnosis,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment,AdverseReactionDate,AdverseReactionTime,RectionPerformance)=""
 	s ReactionData=$g(^dbo.BDReactionD(ReactionDR))
 	s Status=$lg(ReactionData,86)
 	i $l(fStatus),fStatus'[ Status q
 	s RowID=ReactionDR
 	s ReactionNo=$lg(ReactionData,2)
 	s PatName=$lg(ReactionData,5)
 	s RegNo=$lg(ReactionData,3)
 	s SpeciesDR=$lg(ReactionData,7),SpeciesName=""
 	i ($l(SpeciesDR)) s SpeciesName=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
 	s AgeDesc=$lg(ReactionData,8)
 	s LocationDR=$lg(ReactionData,9),LocationCode="",LocationName=""
 	i ($l(LocationDR)) s LocationName=$lg($g(^dbo.BTLocationD(LocationDR)),3)
 	s WardDR=$lg(ReactionData,10),WardName=""
 	i ($l(WardDR)) s WardName=$lg($g(^dbo.BTWardD(WardDR)),3)
 	s Diagnosis=$lg(ReactionData,12)
 	i $l(LocationDR) s LocationCode=$lg(^dbo.BTLocationD(LocationDR),2)
 	i $l(fLocationCode),fLocationCode'=LocationDR q
 	s BedNo=$lg(ReactionData,11)
 	s StartTransfusionDate=$lg(ReactionData,20)
 	s StartTransfusionTime=$lg(ReactionData,21)
 	s ABODR=$lg(ReactionData,63),ABOName=""
 	i ($l(ABODR)) s ABOName=$lg($g(^dbo.BTABOBGD(ABODR)),3)
 	s RHDR=$lg(ReactionData,64),RHName=""
 	i ($l(RHDR)) s RHName=$lg($g(^dbo.BTRHBGD(RHDR)),3)
 	s RectionPerformance=$lg(ReactionData,42)
 	s ResultIn=$lg(ReactionData,47)
 	s ResultDate=$lg(ReactionData,48)
 	s ResultTime=$lg(ReactionData,49)
 	s ClinicalTreatment=$lg(ReactionData,41)
 	s AdverseReactionDate=$lg(ReactionData,24)  
 	s AdverseReactionTime=$lg(ReactionData,25)
    s ResultNote=$lg(ReactionData,50)
 	s StatusDesc=##Class(BLD.ENUM.BDReaction.Status).GetName(Status)
 	s Data=$lb(RowID,ReactionNo,PatName,RegNo,AgeDesc,BedNo,StatusDesc,Status,SpeciesName,LocationName,WardName,ABOName,RHName,Diagnosis,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment,AdverseReactionDate,AdverseReactionTime,RectionPerformance)
 	Set RowCount=RowCount+1
 	Set ^TMP($zn,repid,"DATA",RowCount)=Data 
 	Set ind=ind+1
	Quit
}

ClassMethod QueryBDAdverseReactionSampleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBDAdverseReactionSampleExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBDAdverseReactionSampleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBDAdverseReactionSampleExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator： 	 ShangChao/输血反应
/// Description: 不良反应单信息查询
/// CreatDate：  201608022
/// Input：		 SttDate:开始日期,EndDate:结束日期,FRecordNo：单号,FAddUserDR：创建人，FLocationDR：科室，FStatus：状态，FRegNo：登记号,FSurName：姓名
/// Output：	 满足条件的不良反应单信息
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QueryBDAdverseReactionSample","","","","","","08634841","","","","","","","","","1^^1^^1")
Query QueryBDAdverseReactionSampleOLD(SttDate, EndDate, FRecordNo, FAddUserDR, FLocationDR, FRegNo, FSurName, FStatus, FAdmNo, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "BDAdverseReactionRowID,RecordNo,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,Ethnicity,NativePlace,LocationName,WardName,BedNo,Diagnosis,StartTransfusionDate,StartTransfusionTime,AdverseReactionDate,AdverseReactionTime,RectionPerformance,Status,AdmType,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment")
{
}

ClassMethod QueryBDAdverseReactionSampleOLDExecute(ByRef qHandle As %Binary, SttDate, EndDate, FRecordNo, FAddUserDR, FLocationDR, FRegNo, FSurName, FStatus, FAdmNo, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
    s ^zyx = $lb(SttDate, EndDate, FRecordNo, FAddUserDR, FLocationDR, FRegNo, FSurName, FStatus, FAdmNo, P9, P10, P11, PageSize, PageIndex, Sessions)
	s Sessions=$g(Sessions) s FRecordNo=$g(FRecordNo) s FLocationDR=$g(FLocationDR)
	s FAddUserDR=$g(FAddUserDR) s FStatus=$g(FStatus) s FRegNo=$g(FRegNo)
	s FSurName=$g(FSurName)
	s SttDate=$tr($g(SttDate),"-")
	s EndDate=$tr($g(EndDate),"-")
	s HospitalDR=$p(Sessions,"^",5),WorkGroupDR=$p(Sessions,"^",2)
	s repid=$i(^CacheTemp)
 	s ind=1
    s RowCount=0
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
    i ($l(FAdmNo)){
	    s indexAdmNo=##Class(LIS.Util.Common).IndexData(FAdmNo)
	    s BDAdverseReactionRowID=""
	    s BDAdverseReactionRowID=$o(^dbo.BDAdverseReactionI("IndexAdmNo",indexAdmNo,BDAdverseReactionRowID)) q:BDAdverseReactionRowID=""  d
	    .d GetInfo
	    
	}
    i ($l(FRecordNo)){
	    s indexRecordNo=##Class(LIS.Util.Common).IndexData(FRecordNo)
	    s BDAdverseReactionRowID=""
	    s BDAdverseReactionRowID=$o(^dbo.BDAdverseReactionI("IndexRecordNo",indexRecordNo,BDAdverseReactionRowID)) q:BDAdverseReactionRowID=""  d
	    .d GetInfo
    }
    i ($l(FRegNo)){
	    s indexRegNo=##Class(LIS.Util.Common).IndexData(FRegNo)
	    s BDAdverseReactionRowID=""
	    for {
			s BDAdverseReactionRowID=$o(^dbo.BDAdverseReactionI("IndexRegNo",indexRegNo,BDAdverseReactionRowID))
			q:BDAdverseReactionRowID=""
			d GetInfo
		}
    }
    i (('$l(FRecordNo))&&('$l(FRegNo))){
	    s AddDate=$o(^dbo.BDAdverseReactionI("IndexAddDate",SttDate),-1)
	    for{
		    s AddDate=$o(^dbo.BDAdverseReactionI("IndexAddDate",AddDate))
		    q:((AddDate="")||($l(EndDate)&&(AddDate>EndDate)))
		    s BDAdverseReactionRowID=""
		    for {
			    s BDAdverseReactionRowID=$o(^dbo.BDAdverseReactionI("IndexAddDate",AddDate,BDAdverseReactionRowID))
			    q:BDAdverseReactionRowID=""
			    s AddUserDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),8)
			    s SurName=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),11)
			    s SurName=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),11)
			    s Status=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),60)
			    s LocationDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),24)
			    s PatName=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),11)
			    s RegNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),9)
			    i $l(FRegNo),FRegNo'=RegNo continue
			    i ((","_FLocationDR_",")'[(","_LocationDR_","))&&($l(FLocationDR)) continue
			    i ((","_FAddUserDR_",")'[(","_AddUserDR_","))&&($l(FAddUserDR)) continue
			    i ((","_FStatus_",")'[(","_Status_","))&&($l(FStatus)) continue
			    s $namespace="dhc-lisdata"
			    s SortName=##class(OTH.DHCINSUPort).GetCNCODE(PatName,4,"")	//把姓名变成首字母（或者ASCII码）
			    s $namespace="dhc-app"
				s SortName=$zcvt(SortName,"D")
				s PatName=SortName_PatName
				i $l(FSurName),PatName'[FSurName  continue
				d GetInfo
		    }
		}
	}
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetInfo
	
	s ABOName=""
	s RHName=""
	s AgeUnitName=""
	s AddUserName=""
	s SpeciesName=""
	s LocationName=""
	s WardName=""
	i '$l(BDAdverseReactionRowID) q
	s RecordNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),3)
	s AdmNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),5)
	s AddDate=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),6)
	s AddTime=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),7)
	s AddUserDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),8)
	i ($l(AddUserDR)) s AddUserName=$lg($g(^dbo.SYSUserD(AddUserDR)),3)
	s RegNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),9)
	s MedicalRecordNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),10)
	s SurName=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),11)
	s GivenName=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),12)
	s SpeciesDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),13)
	i ($l(SpeciesDR)) s SpeciesName=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	s Age=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),14)
	s AgeUnitDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),15)
	i ($l(AgeUnitDR)) s AgeUnitName=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
	//s CertTypeDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),16)

	s CertNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),17)
	s IDNumber=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),18)
	s ABODR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),19)
	i ($l(ABODR)) s ABOName=$lg($g(^dbo.BTABOBGD(ABODR)),3)
	s RHDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),20)
	i ($l(RHDR)) s RHName=$lg($g(^dbo.BTRHBGD(RHDR)),3)
	s RareBloodGroup=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),21)
	s Ethnicity=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),22)
	s NativePlace=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),23)
	s LocationDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),24)
	i ($l(LocationDR)) s LocationName=$lg($g(^dbo.BTLocationD(LocationDR)),3)
	s WardDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),25)
	i ($l(WardDR)) s WardName=$lg($g(^dbo.BTWardD(WardDR)),3)
	s BedNo=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),26)
	s Diagnosis=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),27)
	s StartTransfusionDate=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),49)
	s StartTransfusionTime=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),50)
	//s TransfusionUserDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),53)
	
	s AdverseReactionDate=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),54)
	s AdverseReactionTime=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),55)
	//s AdverseReactionFindUserDR=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),56)
	
	s RectionPerformance=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),57)
	s Status=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),60)
	s AdmType=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),61)
	s ResultIn=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),62)
	s ResultDate=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),63)
	s ResultTime=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),64)
	s ResultNote=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),65)
	s ClinicalTreatment=$lg($g(^dbo.BDAdverseReactionD(BDAdverseReactionRowID)),66)
	s RowCount = RowCount + 1
 
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q
	d OutPut

	Quit 
   
OutPut
	Set Data=$lb(BDAdverseReactionRowID,RecordNo,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,Ethnicity,NativePlace,LocationName,WardName,BedNo,Diagnosis,StartTransfusionDate,StartTransfusionTime,AdverseReactionDate,AdverseReactionTime,RectionPerformance,Status,AdmType,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment)
	set ColFields="BDAdverseReactionRowID,RecordNo,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,Ethnicity,NativePlace,LocationName,WardName,BedNo,Diagnosis,StartTransfusionDate,StartTransfusionTime,AdverseReactionDate,AdverseReactionTime,RectionPerformance,Status,AdmType,ResultIn,ResultDate,ResultTime,ResultNote,ClinicalTreatment"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QueryBDAdverseReactionSampleOLDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBDAdverseReactionSampleOLDExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBDAdverseReactionSampleOLDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBDAdverseReactionSampleOLDExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CreatDate：    20190619/取血单查询
/// Description:：取血单查询
/// Table：        
/// Input：        
/// Output：       
/// Return：       fPatientID, pName,
/// Others：  
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBldMultiQuery","QryTakeRecordPackNew","2019-03-01","2020-04-30","","","","","0000000008","","","","","",20,1,"106^10^^13^1")
Query QryTakeRecordPackNew(StartDate, EndDate, fReqFormNum, fLocation, fTakeRecordNo, fIsPrint, fPatientID, fAdmNo, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "TakeReqProductInfo,TakeRecordNo,IsPrinted,PatName,RegNo,WardDesc,BedNo,ReqFormDR,IsIssued,TakeRecordDR,LocationDesc")
{
}

ClassMethod QryTakeRecordPackNewExecute(ByRef qHandle As %Binary, StartDate, EndDate, fReqFormNum, fLocation, fTakeRecordNo, fIsPrint, fPatientID, fAdmNo, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s labnamespace="dhc-lisdata"
    s webnamespace="dhc-app"
    s ^TMP("XVC")=$LB(StartDate, EndDate, fReqFormNum, fLocation, fTakeRecordNo, fIsPrint, fPatientID, pName,Sessions)
	//Set UserID=$p(Sessions,"^",1),WorkGroupDR=$p(Sessions,"^",2),HospitalDR=$p(Sessions,"^",5),LocationDR=$p(Sessions,"^",3)
    s RowCount=0,StartDate=$g(StartDate),EndDate=$g(EndDate),fReqFormNum=$G(fReqFormNum),fPatientID=$G(fPatientID)
    S pName=$G(pName),fPatientID=$G(fPatientID),fTakeRecordNo=$g(fTakeRecordNo),fIsPrint=$g(fIsPrint)
 	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
 	
 	i fIsPrint=0 s fIsPrint=""
 	i StartDate["-" s StartDate=$tr(StartDate,"-")
 	i EndDate["-" s EndDate=$tr(EndDate,"-")
 	s returnflag=0
 	i $l(fPatientID) d
 	.s indexRegNo=##Class(LIS.Util.Common).IndexData(fPatientID)
 	.s BDReqFormRowID=""
	.f  s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexRegNo",indexRegNo,BDReqFormRowID)) q:BDReqFormRowID=""  d
    ..s TakeRecordDR=""
	..f  s TakeRecordDR=$o(^dbo.BDTakeRecordI("IndexRequestForm",BDReqFormRowID,TakeRecordDR))  q:TakeRecordDR=""  d
    ...d GetTakeBDInfo	
    ...i returnflag=1 q
    e  i $L(fAdmNo) d
    .s indexAdmNo=##Class(LIS.Util.Common).IndexData(fAdmNo)
 	.s BDReqFormRowID=""
	.f  s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAdmNo",indexAdmNo,BDReqFormRowID)) q:BDReqFormRowID=""  d
    ..s TakeRecordDR=""
	..f  s TakeRecordDR=$o(^dbo.BDTakeRecordI("IndexRequestForm",BDReqFormRowID,TakeRecordDR))  q:TakeRecordDR=""  d
    ...d GetTakeBDInfo	
    ...i returnflag=1 q
 	e  d
 	.s Curdate=$o(^|labnamespace|dbo.BDTakeRecordI("IndexAddDate",StartDate),-1)
 	.i Curdate="" s Curdate=StartDate-1
 	.f  s Curdate=$o(^|labnamespace|dbo.BDTakeRecordI("IndexAddDate",Curdate)) q:Curdate=""  d
 	..i Curdate>EndDate q
    ..s TakeRecordDR=""
 	..f  s TakeRecordDR=$o(^|labnamespace|dbo.BDTakeRecordI("IndexAddDate",Curdate,TakeRecordDR)) q:TakeRecordDR=""  d	
 	...d GetTakeBDInfo
 	...i returnflag=1 q
 	
 	
 	Set qHandle=$lb(0,repid,0)
    q $$$OK
GetPatInfo
     i '$l(ReqFormDR) q
	 s BDReqFormData=$g(^|labnamespace|dbo.BDReqFormD(ReqFormDR))
	 s AddUserDR=$lg(BDReqFormData,7),AddUser=""
	 i $l(AddUserDR) s AddUser=$lg(^|labnamespace|dbo.SYSUserD(AddUserDR),3) 
	 s SurName=$lg(BDReqFormData,10)
 	 s GivenName=$lg(BDReqFormData,11)
	i SurName=GivenName s PatName=SurName
	e  s PatName=SurName_GivenName
	i $l(pName),pName'=PatName s returnflag=1 q
	s SpeciesDR=$lg(BDReqFormData,12),patSex="" 
    i $l(SpeciesDR) s patSex=$lg($g(^|labnamespace|dbo.BTSpeciesD(SpeciesDR)),3)
	s Age=$lg(BDReqFormData,13)
    s AgeUnitDR=$lg(BDReqFormData,14),AgeUnit=""
	i $l(AgeUnitDR) s AgeUnit=$lg($g(^|labnamespace|dbo.BTAgeUnitD(AgeUnitDR)),3)
	s PatAge=Age_AgeUnit
	s RegNo=$lg(BDReqFormData,8)
	//b 
	i $l(fPatientID),fPatientID'=RegNo s returnflag=1 q
	b ;;
	s MedicalRecordNo=$lg(BDReqFormData,9)
	s SampleNo=$lg(BDReqFormData,46)
	s LocationDR=$lg(BDReqFormData,23),LocationDesc=""
    i $l(LocationDR) s LocationDesc=$lg($g(^|labnamespace|dbo.BTLocationD(LocationDR)),3)
    i $l(LocationDesc,"-")>1 s LocationDesc = $p(LocationDesc,"-",2)
	s WardDR=$lg(BDReqFormData,24),WardDesc=""
	i $l(fLocation),fLocation'=WardDR s returnflag=1 q
    i $l(WardDR) s WardDesc=$lg($g(^|labnamespace|dbo.BTWardD(WardDR)),3) 
    i $l(WardDesc,"-")>1 s WardDesc = $p(WardDesc,"-",2)
	s BedNo=$lg(BDReqFormData,25)
	s ReqProductDR="",TakeReqProductInfo=""
	for {
		s ReqProductDR = $o(^dbo.BDTakeRecordProductI("IndexMaster",TakeRecordDR,ReqProductDR))
		q:ReqProductDR=""
		s TakeRecordProductDR = $o(^dbo.BDTakeRecordProductI("IndexMaster",TakeRecordDR,ReqProductDR,""))
		q:TakeRecordProductDR=""
	    s TakeRecordProductData = $g(^dbo.BDTakeRecordProductD(TakeRecordProductDR))
		s ReqProductDR = $lg(TakeRecordProductData,3)
		s SReqProductDR = $lg(TakeRecordProductData,3)
		s TakeVolume = $lg(TakeRecordProductData,4)
		s Units = $lg(TakeRecordProductData,6)
		s ReqProductData = $g(^dbo.BBReqProductD(ReqProductDR))
		s ReqProductName = $lg(ReqProductData,3)
		s IssueRecordDR=""
		S IssueRecordNos="",IssueDate="",IssueTime=""
		for{ 
		 s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR))
		 q:IssueRecordDR="" 
		 s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
		 s RecordNo=$lg(IssueRecordData,2)
		 s IssTakeRecordDR=$lg(IssueRecordData,8)  
		 
		 
		 s IssueDate=$lg(IssueRecordData,3)
		 s IssueTime=$lg(IssueRecordData,4)
		 
		}
		
	    s BloodGroupDR = $lg(TakeRecordProductData,7)
	    s BloodGroup=""
	    i $l(BloodGroupDR) s BloodGroup = $lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
	    i '$l(BloodGroupDR){
		    
		    s BDProductDR=$O(^dbo.BDReqFormProductI("IndexMaster",ReqFormDR,SReqProductDR,""))
		    
		    i BDProductDR'="" S BloodGroupDR=$LG($G(^dbo.BDReqFormProductD(BDProductDR)),9)
		    i $l(BloodGroupDR) s BloodGroup = $lg($g(^dbo.BBBloodGroupD(BloodGroupDR)),3)
		    
		}
	    i $l(TakeReqProductInfo) {
		    s TakeReqProductInfo = TakeReqProductInfo_"/ "_"["_BloodGroup_"] "_ReqProductName_":"_TakeVolume_Units
	    }
	    else {
		    s TakeReqProductInfo = "["_BloodGroup_"] "_ReqProductName_":"_TakeVolume_Units
	    }
	}	
 	q
 	
GetTakeBDInfo
    s (PatName,RegNo,WardDesc,BedNo)=""
 	s TakeRecordData=$g(^|labnamespace|dbo.BDTakeRecordD(TakeRecordDR))
 	s TakeRecordNo=$lg(TakeRecordData,2)
 	i $L(fTakeRecordNo),fTakeRecordNo'=TakeRecordNo q
 	s IsPrinted = $lg(TakeRecordData,19)
 	i $l(IsPrinted),IsPrinted=1 s IsPrinted="是"
 	s ReqFormDR=$lg(TakeRecordData,3)
 	s returnflag=0
 	d GetPatInfo
 	i returnflag=1 q
    s Data=$lb(TakeReqProductInfo,TakeRecordNo,IsPrinted,PatName,RegNo,WardDesc,BedNo,ReqFormDR,IsIssued,TakeRecordDR,LocationDesc)
 	d OutPut
 	q
	
 
 	
OutPut
    //B ;09IJJ
	set ColFields="TakeReqProductInfo,TakeRecordNo,IsPrinted,PatName,RegNo,WardDesc,BedNo,ReqFormDR,IsIssued,TakeRecordDR,LocationDesc"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTakeRecordPackNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTakeRecordPackNewExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTakeRecordPackNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTakeRecordPackNewExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      baoguotao/发血单
/// CreatDate：    20160506
/// Description:： 根据申请单查询发血信息
/// Input：        
/// Output：       根据申请单查询发血信息
/// d ##Class(%ResultSet).RunQuery("BLD.WS.BLL.DHCBldMultiQuery","QryBdIssueByDate","20190301","20200808","","0000000008","","","","","","","","","","","1^^1^^1")	
Query QryBdIssueByDate(SttAccDate, EndAccDate, IssRecordNum, FRegNo, FLocationDR, fIssueUserDR, FAdmID, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "IssueDR,RecordNo,IssueDate,IssueTime,PackID,BloodProductName,PackType,packVol,MedicalRecordNo,patName,PatType,LocationDesc,BedNo")
{
}

ClassMethod QryBdIssueByDateExecute(ByRef qHandle As %Binary, SttAccDate, EndAccDate, IssRecordNum, FRegNo, FLocationDR, fIssueUserDR, FAdmID, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0  
  	k ^TMP($zn,$j)   
    s SttAccDate=$tr(SttAccDate,"-"),EndAccDate=$tr(EndAccDate,"-")
    s FRegNo=$g(FRegNo),FAdmID=$G(FAdmID)
    I '$l(FRegNo),$L(FAdmID) S FRegNo=##Class(LISAPP.Common.BLL.PatientInfo).GetPatientID(FAdmID)
    i $l(FRegNo){
	    s indexRegNo=##Class(LIS.Util.Common).IndexData(FRegNo)
	    s IssueRecordDR=""
		f {
	      s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexRegNo",indexRegNo,IssueRecordDR))
	      q:IssueRecordDR=""
	      s IssueDate=$lg($g(^dbo.BDIssueRecordD(IssueRecordDR)),4)
	      b ;;
	      i $l(EndAccDate),IssueDate>EndAccDate continue
	      i $l(SttAccDate),IssueDate<SttAccDate continue
	      S Returnflag=0
	      d GetPackIssInfo
	      
	      
		}
	    
	} 
    elseif $l(IssRecordNum) {
	    s indexIssRecordNum=##Class(LIS.Util.Common).IndexData(IssRecordNum)
	    s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexRecordNo",indexIssRecordNum,""))
	    d GetPackIssInfo
	}
	else{
        s IssueDate=$o(^dbo.BDIssueRecordI("IndexIssueDate",SttAccDate),-1)
		f{
			s IssueDate=$o(^dbo.BDIssueRecordI("IndexIssueDate",IssueDate))
			q:((IssueDate="")||($l(EndAccDate)&&(IssueDate>EndAccDate)))
			s IssueRecordDR=""
		    f {
			    s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexIssueDate",IssueDate,IssueRecordDR))
			    q:IssueRecordDR=""
			    S Returnflag=0
		        d GetPackIssInfo
		    }
		
		}
    
	}
	
	k ^TMP($zn,$i,$j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetPackIssInfo
    s IssueRecordData=$g(^dbo.BDIssueRecordD(IssueRecordDR))
    s IssueDR=IssueRecordDR
    s IssueUserDR=$lg(IssueRecordData,6) 
    i $l(fIssueUserDR),IssueUserDR'=fIssueUserDR  S Returnflag=1 q
    s RecordNo=$lg(IssueRecordData,2)
    s IssueDate=$lg(IssueRecordData,4)
    s IssueTime=$lg(IssueRecordData,5) 
    s ReqFormDR=$lg(IssueRecordData,11) 
    s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
    s MedicalRecordNo=$lg(ReqFormData,9)
    s SurName=$lg(ReqFormData,10),GivenName=$lg(ReqFormData,11)
    s patName = SurName
    i SurName'= GivenName s patName=SurName_GivenName 
    s RegNo=$lg(ReqFormData,8) 
    i $l(FRegNo),FRegNo'=RegNo S Returnflag=1 q
    s PatType="",BLDABO="",BLDRH=""
  	S ABODR=$lg(ReqFormData,18)
  	S RHDR=$lg(ReqFormData,19)
  	I $L(ABODR) S BLDABO=$LG($G(^dbo.BTABOBGD(ABODR)),2)
  	I $L(RHDR) S BLDRH=$LG($G(^dbo.BTRHBGD(RHDR)),3)
  	i BLDRH["阳" s BLDRH="+"
    i BLDRH["阴" s BLDRH="-"
    i BLDRH["未" s BLDRH="未知"
    S PatType=BLDABO_BLDRH



    s LocationDR=$lg(ReqFormData,23),LocationDesc=""
    i $l(LocationDR) s LocationDesc=$lg($g(^dbo.BTLocationD(LocationDR)),3)
    I $L(FLocationDR),FLocationDR'=LocationDR S Returnflag=1 Q
    s BedNo=$lg(ReqFormData,25)  
    s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:(PackDR="")  d
    .s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
    .s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
    .s IsReturned=$lg(IssueRecordItemsData,4)
    .i IsReturned="1" q
    .s PackRowID=$lg(IssueRecordItemsData,3)
    .s packData=$g(^dbo.BDPackD(PackDR))
    .s PackID=$lg(packData,2)
    .s BloodProductDR=$lg(packData,3)
    .s BloodProductName=$lg(^dbo.BBBloodProductD(BloodProductDR),3)
    .s Unit=$lg(^dbo.BBBloodProductD(BloodProductDR),15)
    .s BloodGroupDR=$lg(packData,9)
    .s PackABO=$lg(^dbo.BBBloodGroupD(BloodGroupDR),4)
    .s PackRH=$lg(^dbo.BBBloodGroupD(BloodGroupDR),5)
    .i PackRH="P" s PackType=PackABO_"+"
    .i PackRH="N" s PackType=PackABO_"-"
    .i PackRH="U" s PackType=PackABO_"未知"
    .s packVol=$lg(packData,10)_Unit 
    .d OutPut
    q
    
   
	
OutPut
	Set Data=$lb(IssueDR,RecordNo,IssueDate,IssueTime,PackID,BloodProductName,PackType,packVol,MedicalRecordNo,patName,PatType,LocationDesc,BedNo,PackRowID)
    set ColFields="IssueDR,RecordNo,IssueDate,IssueTime,PackID,BloodProductName,PackType,packVol,MedicalRecordNo,patName,PatType,LocationDesc,BedNo,PackRowID" 
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryBdIssueByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBdIssueByDateExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBdIssueByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBdIssueByDateExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      baoguotao/配血报告
/// CreatDate：    20151021
/// Description:： 查询时间段内病人复查信息
/// Input：        
/// Output：       查询时间段内病人复查信息
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QryPatXMPlanByDate","2019-01-01","2020-03-10","","","","","","0000000008","","","","","","","1^^1^^1")	
Query QryPatXMPlanByDate(SttAccDate, EndAccDate, FXMPlanNo, FAddUserDR, fLocationDR, FRegNo, fMedicalRecordNo, FAdmNo, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "XMPlanDR,MedicalRecordNo,SurName,BLDABORH,XMMethodName,XMLastResultStr,packID,ProductBarcode,BloodGroupName,PackVolume,AddUserName,CheckUserName,AddDate,XMPlanNo")
{
}

ClassMethod QryPatXMPlanByDateExecute(ByRef qHandle As %Binary, SttAccDate, EndAccDate, FXMPlanNo, FAddUserDR, fLocationDR, FRegNo, fMedicalRecordNo, FAdmNo, P8, P9, P10, P11, PageSize, PageInde, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0    
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1 
	s FRegNo=$g(FRegNo),SttAccDate=$g(SttAccDate),EndAccDate=$g(EndAccDate),FXMPlanNo=$g(FXMPlanNo)
	s FAddUserDR=$g(FAddUserDR)
	k ^TMP($zn,repid,$j) 
	
	i $l(FAdmNo){
		s indexAdmNo=##Class(LIS.Util.Common).IndexData(FAdmNo)
		s BDReqFormRowID=""
	    for {
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAdmNo",indexAdmNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s PackDR="" 
			for {
				//b ;00
				s PackDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR))
			    q:PackDR=""
			    s XMPlanDR=""
			    //b ;01 
				for {
				    s XMPlanDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR,XMPlanDR))
			        q:XMPlanDR=""
			        s returnflag=0
			        //b ;02
			        d GetInfo
			        i returnflag=1 continue
				
				    }
				}	
		}
		
		
	}
	if $l(FRegNo) {
		s indexRegNo=##Class(LIS.Util.Common).IndexData(FRegNo)
	    s BDReqFormRowID=""
	    for {
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexRegNo",indexRegNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s PackDR="" 
			for {
				//b ;00
				s PackDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR))
			    q:PackDR=""
			    s XMPlanDR=""
			    //b ;01 
				for {
				    s XMPlanDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormRowID,PackDR,XMPlanDR))
			        q:XMPlanDR=""
			        s returnflag=0
			        //b ;02
			        d GetInfo
			        i returnflag=1 continue
				
				    }
				}	
		}
    }
    i ($l(SttAccDate)&&$l(EndAccDate))
    {
	        s SttAccDate=$tr(SttAccDate,"-"),EndAccDate=$tr(EndAccDate,"-")  
		    s CheckDate=$o(^dbo.BDXMPlanI("IndexXMCheckDate",SttAccDate),-1)
		    //b ;00
		    i CheckDate="" s CheckDate=SttAccDate-1
		  	for{
			  	 s CheckDate=$o(^dbo.BDXMPlanI("IndexXMCheckDate",CheckDate))
			  	 q:(CheckDate="")||($l(EndAccDate)&&(CheckDate>EndAccDate))  d
			  	 //b ;01zyx
			  	 s XMPlanDR="" 
			  	 for{
				  	  s XMPlanDR=$o(^dbo.BDXMPlanI("IndexXMCheckDate",CheckDate,XMPlanDR))
				  	  q:XMPlanDR="" 
				  	  s returnflag=0
				  	  d GetInfo
				  	  i returnflag=1 continue
				  	 }
			  	} 
       
	}
	
   
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
	
GetInfo   
    //b ;000 
    s returnflag=0
  	s XMPlanData=$g(^dbo.BDXMPlanD(XMPlanDR)) 
  	s ReqFormDR=$lg(XMPlanData,2)
  	s PackDR=$lg(XMPlanData,3)
  	s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
  	s PackData=$g(^dbo.BDPackD(PackDR))
  	s RegNo=$lg(ReqFormData,8)
  	i FRegNo'="",FRegNo'= RegNo s returnflag=1 q
  	s MedicalRecordNo=$lg(ReqFormData,9)
  	i $l(fMedicalRecordNo),MedicalRecordNo'=fMedicalRecordNo s returnflag=1 q
  	//b  ;;
  	//i $l(fMedicalRecordNo),MedicalRecordNo'=fMedicalRecordNo q
  	s SurName=$lg(ReqFormData,10) 
  	//i $l(fPatName),fPatName'=SurName q
    s LocationDR=$lg(ReqFormData,23) 
    i $l(fLocationDR),fLocationDR'=LocationDR s returnflag=1 q
  	s BLDABORH="",BLDABO="",BLDRH=""
  	S ABODR=$lg(ReqFormData,18)
  	S RHDR=$lg(ReqFormData,19)
  	I $L(ABODR) S BLDABO=$LG($G(^dbo.BTABOBGD(ABODR)),3)
  	I $L(RHDR) S BLDRH=$LG($G(^dbo.BTRHBGD(RHDR)),3)
	s BLDABORH=BLDABO_BLDRH
	s XMMethodDR=$lg(XMPlanData,22)
	s XMMethodName="" 
	i '$l(XMMethodDR) q
	s XMMethodData=$g(^dbo.BBXMMethodD(XMMethodDR))
	s XMMethodName=$lg(XMMethodData,3)
	s XMPlanNo=$lg(XMPlanData,26)
	i $l(FXMPlanNo),FXMPlanNo'=XMPlanNo s returnflag=1 q
	s XMLastResultStr=$lg(XMPlanData,24)
	s packID=$lg(PackData,2)
	s BloodProductDR=$lg(PackData,3)
	s BloodProductData=$g(^dbo.BBBloodProductD(BloodProductDR))
	s Unit=$lg(BloodProductData,15)
	s ProductBarcode=$lg(PackData,6)
	s BloodGroupDR=$lg(PackData,9)
	s BloodGroupName=""
	i $l(BloodGroupDR) s BloodGroupData=$g(^dbo.BBBloodGroupD(BloodGroupDR))
	i $l(BloodGroupDR) s BloodGroupName=$lg(BloodGroupData,3)
	s PackVolume=$lg(PackData,10)_Unit
	s AddDate=$lg(XMPlanData,6)
	s AddTime=$lg(XMPlanData,7)
	s AddUserDR=$lg(XMPlanData,8)
	s AddUserName=""
	i $l(AddUserDR) s AddUser=$g(^dbo.SYSUserD(AddUserDR))
	i $l(FAddUserDR),FAddUserDR'=AddUserDR s returnflag=1 q
	i $l(AddUserDR) s AddUserName=$lg(AddUser,3) 
	s XMCheckTime=$lg(XMPlanData,28)
	s XMCheckUserDR=$lg(XMPlanData,29)
	s CheckUserName=""
	i $l(XMCheckUserDR) s CheckUser=$g(^dbo.SYSUserD(XMCheckUserDR))
	i $l(XMCheckUserDR) s CheckUserName=$lg(CheckUser,3)
	
  	d OutPut
  	q
	
   
OutPut 
    s RowCount = RowCount + 1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q
	
	Set Data=$lb(XMPlanDR,MedicalRecordNo,SurName,BLDABORH,XMMethodName,XMLastResultStr,packID,ProductBarcode,BloodGroupName,PackVolume,AddUserName,CheckUserName,AddDate,XMPlanNo)
    Set ColFields="XMPlanDR,MedicalRecordNo,SurName,BLDABORH,XMMethodName,XMLastResultStr,packID,ProductBarcode,BloodGroupName,PackVolume,AddUserName,CheckUserName,AddDate,XMPlanNo"
    S ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryPatXMPlanByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatXMPlanByDateExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPatXMPlanByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatXMPlanByDateExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator： 	 ShangChao/用血申请
/// Description: 按照申请单号或者日期查询
/// CreatDate：  20160809
/// Input：		 SttDate:开始日期,EndDate:结束日期,FReqFormNo：申请单号,FAddUserDR：创建人，FLocationDR：申请科室，FStatus：状态，FReqTypeDR：申请类型，FIsExcess：是否超量,FRegNo：登记号,FSurName：姓名
/// Output：	 满足条件的医嘱数据汇总
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QueryBDReqForm","","","","","","","","","","","142","","","","1^^1^^1")
Query QueryBDReqForm(SttDate, EndDate, FReqFormNo, FAddUserDR, FLocationDR, FStatus, FReqTypeDR, FIsExcess, FRegNo, FSurName, FAdmNo, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "BDReqFormRowID,ReqFormNo,ReqTypeName,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,NativePlace,LocationName,WardName,IsExcess,Status, CheckDate,CheckTime,CheckUserName,IsPrinted,ReceiveDate,ReceiveTime,ReceiveUserName,WorkGroupName,ProductList,IssueRecordStr")
{
}

ClassMethod QueryBDReqFormExecute(ByRef qHandle As %Binary, SttDate, EndDate, FReqFormNo, FAddUserDR, FLocationDR, FStatus, FReqTypeDR, FIsExcess, FRegNo, FSurName, FAdmNo, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	s ^SC("12")= $lb(SttDate, EndDate, FReqFormNo, FAddUserDR, FLocationDR, FStatus, FReqTypeDR, FIsExcess, FRegNo, FSurName, FAdmNo, P11, PageSize, PageIndex, Sessions)
	s Sessions=$g(Sessions) s FReqFormNo=$g(FReqFormNo) s FLocationDR=$g(FLocationDR)
	s FAddUserDR=$g(FAddUserDR) s FStatus=$g(FStatus) s FReqTypeDR=$g(FReqTypeDR)
	s FIsExcess=$g(FIsExcess) s FRegNo=$g(FRegNo)
	s SttDate=$tr($g(SttDate),"-")
	s EndDate=$tr($g(EndDate),"-")
	s HospitalDR=$p(Sessions,"^",5),WorkGroupDR=$p(Sessions,"^",2)
	s repid=$i(^CacheTemp)
 	s ind=1
    s RowCount=0
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	
    i ($l(FReqFormNo)){
	    s indexReqFormNo=##Class(LIS.Util.Common).IndexData(FReqFormNo)
		s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexReqFormNo",indexReqFormNo,""))
		d GetInfo
    }
    i ($l(FRegNo)){
	    s BDReqFormRowID=""
	    for {
		    s indexRegNo=##Class(LIS.Util.Common).IndexData(FRegNo)
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexRegNo",indexRegNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s ReqAddDate=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),5)
			i $l(EndDate),$l(SttDate),(ReqAddDate>EndDate)||(ReqAddDate<SttDate) continue
			d GetInfo
		}
    }
    i $l(FAdmNo){
	    
	    s BDReqFormRowID=""
	    for {
		    s indexAdmNo=##Class(LIS.Util.Common).IndexData(FAdmNo)
			s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAdmNo",indexAdmNo,BDReqFormRowID))
			q:BDReqFormRowID=""
			s ReqAddDate=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),5)
			b ;ss
			d GetInfo
		}
	    
	}
    i (('$l(FReqFormNo))&&('$l(FRegNo))) {
	    s AddDate=$o(^dbo.BDReqFormI("IndexAddDate",SttDate),-1)
	    for {
			s AddDate=$o(^dbo.BDReqFormI("IndexAddDate",AddDate))
			q:((AddDate="")||($l(EndDate)&&(AddDate>EndDate)))
			s BDReqFormRowID=""
		    for {
			    s BDReqFormRowID=$o(^dbo.BDReqFormI("IndexAddDate",AddDate,BDReqFormRowID))
			    q:BDReqFormRowID=""
			    s AddUserDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),7)
			    s LocationDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),23)
			    s Status=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),51)
			    s ReqTypeDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),3)
			    s IsExcess=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),50)
			    s ReqFormNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),2)
			    s SurName=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),10)
			    s PatName=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),10)
			    i ((","_FAddUserDR_",")'[(","_AddUserDR_","))&&($l(FAddUserDR)) continue
			    i ((","_FLocationDR_",")'[(","_LocationDR_","))&&($l(FLocationDR))  continue
				i ((","_FStatus_",")'[(","_Status_","))&&($l(FStatus))  continue
			    i ((","_FReqTypeDR_",")'[(","_ReqTypeDR_","))&&($l(FReqTypeDR)) continue
				//i ((","_FIsExcess_",")'[(","_IsExcess_","))&&($l(FIsExcess)) continue
				i (FIsExcess=1) {
					i (IsExcess'=1) continue
				}
				i (FIsExcess=0) {
					i (IsExcess=1) continue
				}
				S $NAMESPACE="DHC-LISDATA"
				s SortName=##class(OTH.DHCINSUPort).GetCNCODE(PatName,4,"")	//把姓名变成首字母（或者ASCII码）
				S $NAMESPACE="DHC-APP"
				s SortName=$zcvt(SortName,"D")
				s PatName=SortName_PatName
				i $l(FSurName),PatName'[FSurName  continue
				d GetInfo
			}
		}
	}
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetInfo
	s WorkGroupName=""
	s ReceiveUserName=""
	s CheckUserName=""
	s WardName=""
	s LocationName=""
	s RHName=""
	s ABOName=""
	s AgeUnitName=""
	s SpeciesName=""
	s AddUserName=""
	s ReqTypeName=""
	i '$l(BDReqFormRowID) q
	s ReqFormNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),2)
	s ReqTypeDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),3)
	i ($l(ReqTypeDR)) s ReqTypeName=$lg($g(^dbo.BBReqTypeD(ReqTypeDR)),3)
	s AdmNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),4)
	s AddDate=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),5)
	s AddTime=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),6)
	s AddUserDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),7)
	i ($l(AddUserDR)) s AddUserName=$lg($g(^dbo.SYSUserD(AddUserDR)),3)
	s RegNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),8)
	s MedicalRecordNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),9)
	s SurName=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),10)
	s GivenName=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),11)
	s SpeciesDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),12)
	i ($l(SpeciesDR)) s SpeciesName=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	s Age=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),13)
	s AgeUnitDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),14)
	i ($l(AgeUnitDR)) s AgeUnitName=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
	
	s CertNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),16)
	s IDNumber=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),17)
	s ABODR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),18)
	i ($l(ABODR)) s ABOName=$lg($g(^dbo.BTABOBGD(ABODR)),3)
	s RHDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),19)
	i ($l(RHDR)) s RHName=$lg($g(^dbo.BTRHBGD(RHDR)),3)
	s RareBloodGroup=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),20)
	s NativePlaceNum=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),22)
	i (NativePlaceNum=1) s NativePlace="本市"
	i (NativePlaceNum=2) s NativePlace="外埠"
	s LocationDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),23)
	i ($l(LocationDR)) s LocationName=$lg($g(^dbo.BTLocationD(LocationDR)),3)
	s WardDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),24)
	i ($l(WardDR)) s WardName=$lg($g(^dbo.BTWardD(WardDR)),3)
	s BedNo=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),25)
	s IsExcess=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),50)
	s StatusNum=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),51)
	i (StatusNum=10) s Status="待审"
	i (StatusNum=15) s Status="作废"
	i (StatusNum=20) s Status="医务待审"
	i (StatusNum=25) s Status="审核"
	i (StatusNum=35) s Status="接收"
	i (StatusNum=31) s Status="输血科拒审"
	i (StatusNum=21) s Status="输血科待审"
	i (StatusNum=37) s Status="取消接收"
	i (StatusNum=40) s Status="拒收"
	i (StatusNum=23) s Status="科主任待审"
	i (StatusNum=24) s Status="科主任拒审"
	
	s CheckDate=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),63)
	s CheckTime=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),64)
	s CheckUserDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),65)
	i ($l(CheckUserDR)) s CheckUserName=$lg($g(^dbo.SYSUserD(CheckUserDR)),3)
	s IsPrinted=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),66)
	s ReceiveDate=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),68)
	s ReceiveTime=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),69)
	s ReceiveUserDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),70)
	i ($l(ReceiveUserDR)) s ReceiveUserName=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
	s WorkGroupDR=$lg($g(^dbo.BDReqFormD(BDReqFormRowID)),71)
	i ($l(WorkGroupDR)) s WorkGroupName=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)
	
	s ProductList = ""
	s ReqProductDR = ""
 	for {
	 	s ReqProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",BDReqFormRowID,ReqProductDR))
	 	q:ReqProductDR=""
	 	s ReqFormProductDR = $o(^dbo.BDReqFormProductI("IndexMaster",BDReqFormRowID,ReqProductDR,""))
	 	s ReqFormProductData = $g(^dbo.BDReqFormProductD(ReqFormProductDR))
	 	s ReqProductDR = $lg(ReqFormProductData,3)
	 	s ReqProduct = $lg($g(^dbo.BBReqProductD(ReqProductDR)),3)
	 	s PurposeDR = $lg(ReqFormProductData,4)
	 	s Purpose = $lg(^dbo.BBPurposeD(PurposeDR),3)
	 	s Volumn = $lg(ReqFormProductData,5)
	 	s Unit = $lg(ReqFormProductData,6)
	 	s ReqBloodGroupDR = $lg(ReqFormProductData,9),ReqBloodGroup=""
 		i $l(ReqBloodGroupDR) s ReqBloodGroup = $lg(^dbo.BBBloodGroupD(ReqBloodGroupDR),3)
 		i $l(ProductList) d
	 	.s ProductList = ProductList_"/"_ReqProduct_"["_ReqBloodGroup_"]："_Volumn_Unit
	 	e  d
	 	.s ProductList = ReqProduct_"["_ReqBloodGroup_"]："_Volumn_Unit
 	}
 	
 	//发血数据
 	s IssueRecordStr=""
 	s IssueRecordDR="" 
    for { 
      s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",BDReqFormRowID,IssueRecordDR))
      q:IssueRecordDR="" 
      s PackDR="" 
      for
      {
        s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
        q:PackDR=""
        s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
        s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
        s IsReturned=$lg(IssueRecordItemsData,4)
        i IsReturned="1" continue
        s PackData = $g(^dbo.BDPackD(PackDR))
	 	s BloodProductDR = $lg(PackData,3)
	 	s BloodProduct=$lg(^dbo.BBBloodProductD(BloodProductDR),3)
	 	s Units=$lg(^dbo.BBBloodProductD(BloodProductDR),15)
	 	s BloodGroupDR = $lg(PackData,9),BloodGroup=""
	 	i $l(BloodGroupDR) s BloodGroup = $lg(^dbo.BBBloodGroupD(BloodGroupDR),3)
	 	s PackVolume = $lg(PackData,10)
	 	i $l(IssueRecordStr) d
	 	.s IssueRecordStr=IssueRecordStr_"/"_BloodProduct_"["_BloodGroup_"]:"_PackVolume_Units
	 	e  d
	 	.s IssueRecordStr=BloodProduct_"["_BloodGroup_"]:"_PackVolume_Units
      }
    }
	
	s RowCount = RowCount + 1
	i FormRow>0,ToRow>0,FormRow>RowCount q
	i FormRow>0,ToRow>0,ToRow<RowCount q
	d OutPut

	Quit 
   
OutPut
	Set Data=$lb(BDReqFormRowID,ReqFormNo,ReqTypeName,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,NativePlace,LocationName,WardName,IsExcess,Status, CheckDate,CheckTime,CheckUserName,IsPrinted,ReceiveDate,ReceiveTime,ReceiveUserName,WorkGroupName,ProductList,IssueRecordStr)
	set ColFields="BDReqFormRowID,ReqFormNo,ReqTypeName,AdmNo,AddDate,AddTime,AddUserName,RegNo,MedicalRecordNo,SurName,GivenName,SpeciesName,Age,AgeUnitName,CertNo,IDNumber,ABOName,RHName,RareBloodGroup,NativePlace,LocationName,WardName,IsExcess,Status, CheckDate,CheckTime,CheckUserName,IsPrinted,ReceiveDate,ReceiveTime,ReceiveUserName,WorkGroupName,ProductList,IssueRecordStr"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QueryBDReqFormClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBDReqFormExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBDReqFormFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBDReqFormExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CreatDate：    20190118
/// Description:： 输出申请类型
/// Input：        
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QryReqType","","","","","","20","1","","","","","","","","1^^1^^1")	
Query QryReqType(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod QryReqTypeExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	s LabName="dhc-lisdata"
    
    
    S ReqTypeDR=""
    F  S ReqTypeDR=$O(^|LabName|dbo.BBReqTypeD(ReqTypeDR)) Q:ReqTypeDR=""  D
    .//b ;09
    .S BBReqTypeInfo=$g(^|LabName|dbo.BBReqTypeD(ReqTypeDR))
    .S Active=$LG(BBReqTypeInfo,6)
    .i Active'=1 q
    .s RowID=ReqTypeDR
    .s Code=$LG(BBReqTypeInfo,2)
    .s CName=$LG(BBReqTypeInfo,3)
    .//b ;08
    .d OutPut 
    
    
    
    s Count="" f  s Count=$o(^TMP($zn,$j,"DATA",Count)) q:Count=""  d 
	.i FormRow>0,ToRow>0,FormRow>Count q
	.i FormRow>0,ToRow>0,ToRow<Count q  
	.s Data=$g(^TMP($zn,$j,"DATA",Count)) 
	.Set ColFields="RowID,Code,CName"
	.//b ;09
 	.Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	.S ind=ind+1  
 	k ^TMP($zn,$j,"DATA")  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
 
OutPut  
	Set Data=$lb(RowID,Code,CName)
    Set RowCount=RowCount+1
 	Set ^TMP($zn,$j,"DATA",RowCount)=Data 
 	Set ind=ind+1
	Quit
}

ClassMethod QryReqTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReqTypeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReqTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReqTypeExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CreatDate：    20190118
/// Description:： 输出医护人员
/// Input：        
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QryUser","","","","","","20","1","","","","","","","","1^^1^^1")	
Query QryUser(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod QryUserExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	s LabName="dhc-lisdata"
    
    
    S SYSUserDR=""
    F  S SYSUserDR=$O(^|LabName|dbo.SYSUserD(SYSUserDR)) Q:SYSUserDR=""  D
    .//b ;09
    .S SYSUserInfo=$g(^|LabName|dbo.SYSUserD(SYSUserDR))
    .S Active=$LG(SYSUserInfo,11)
    .i Active'=1 q
    .s RowID=SYSUserDR
    .s Code=$LG(SYSUserInfo,2)
    .s CName=$LG(SYSUserInfo,3)
    .//b ;08
    .d OutPut 
    
    
    
    s Count="" f  s Count=$o(^TMP($zn,$j,"DATA",Count)) q:Count=""  d 
	.i FormRow>0,ToRow>0,FormRow>Count q
	.i FormRow>0,ToRow>0,ToRow<Count q  
	.s Data=$g(^TMP($zn,$j,"DATA",Count)) 
	.Set ColFields="RowID,Code,CName"
	.//b ;09
 	.Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	.S ind=ind+1  
 	k ^TMP($zn,$j,"DATA")  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
 
OutPut  
	Set Data=$lb(RowID,Code,CName)
    Set RowCount=RowCount+1
 	Set ^TMP($zn,$j,"DATA",RowCount)=Data 
 	Set ind=ind+1
	Quit
}

ClassMethod QryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CreatDate：    20190118
/// Description:： 输出病区
/// Input：        
/// Output：       
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBDQueryComnInfo","QryWard","","","","","","20","1","","","","","","","","1^^1^^1")	
Query QryWard(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod QryWardExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s RowCount=0
    s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	s LabName="dhc-lisdata"
    
    
    S BTWardDR=""
    F  S BTWardDR=$O(^|LabName|dbo.BTWardD(BTWardDR)) Q:BTWardDR=""  D
    .//b ;09
    .S BTWardInfo=$g(^|LabName|dbo.BTWardD(BTWardDR))
    .S Active=$LG(BTWardInfo,7)
    .i Active'=1 q
    .s RowID=BTWardDR
    .s Code=$LG(BTWardInfo,2)
    .s CName=$LG(BTWardInfo,3)
    .//b ;08
    .d OutPut 
    
    
    
    s Count="" f  s Count=$o(^TMP($zn,$j,"DATA",Count)) q:Count=""  d 
	.i FormRow>0,ToRow>0,FormRow>Count q
	.i FormRow>0,ToRow>0,ToRow<Count q  
	.s Data=$g(^TMP($zn,$j,"DATA",Count)) 
	.Set ColFields="RowID,Code,CName"
	.//b ;09
 	.Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	.S ind=ind+1  
 	k ^TMP($zn,$j,"DATA")  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
 
OutPut  
	Set Data=$lb(RowID,Code,CName)
    Set RowCount=RowCount+1
 	Set ^TMP($zn,$j,"DATA",RowCount)=Data 
 	Set ind=ind+1
	Quit
}

ClassMethod QryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3) 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
