Class DHCEPRFS.BL.BLEstimatePages Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveLog(AEpisodeID As %String, AUserID As %String, AUnitPrice As %String, ATotalPages As %String, ATotalPrice As %String, AEstimatePagesDetail As %String)
{
	q:(AEpisodeID = "") ""
	
	s APatientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPapmiDR(AEpisodeID)
	s AMedRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(APatientID)
	s ARegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(APatientID)
	
	s obj = ##class(DHCEPRFS.INST.EstimatePagesLog).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.EpisodeID = AEpisodeID
	s obj.PatientID = APatientID
	s obj.MedRecordNo = AMedRecordNo
	s obj.RegNo = ARegNo
	s obj.UserID = AUserID
	s obj.UnitPrice = AUnitPrice
	s obj.TotalPages = ATotalPages
	s obj.TotalPrice = ATotalPrice
	s obj.EstimatePagesDetail = AEstimatePagesDetail
	for i = 1:1:$l(AEstimatePagesDetail,"^")
	{
		s detail = $p(AEstimatePagesDetail,"^",i)
		s objSub = ##class(DHCEPRFS.INST.EstimatePagesItem).%New()
		s objSub.EstimatePagesLog = obj
		s ItemID = $p(detail,"|",1)
		s ItemName = $p(detail,"|",2)
		s ItemPages = $p(detail,"|",3)
		s TotalPrice = $p(detail,"|",4)
		s objSub.ItemID = ItemID
		s objSub.ItemName = ItemName
		s objSub.ItemPages = ItemPages
		s objSub.TotalPrice = TotalPrice
		s scSub = objSub.%Save()
	}
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLEstimatePages","GetPatientList","","")
Query GetPatientList(ARegNo As %String, AMedRecordNo As %String) As %Query(ROWSPEC = "PAStatusType:%String,PAStatusTypeDesc:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, ARegNo As %String, AMedRecordNo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	d DealParamter   //处理参数
 	

	if (ARegNo '= "")
	{
		s papmi = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByRegNo(ARegNo)
	 	q:(papmi = "") $$$OK
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByPAPMI")
		d result.Execute(papmi)
			
		while(result.Next())
		{
			s PAAdm = $g(result.Data("EpisodeID"))
			q:(PAAdm = "")
	 		d OutPutRow
		}
	}
	elseif (AMedRecordNo '= "")
	{
		s papmi = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByMedRecord(AMedRecordNo)
		q:(papmi = "") $$$OK
		s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetEpisodeIDByPAPMI")
		d result.Execute(papmi)
			
		while(result.Next())
		{
			s PAAdm = $g(result.Data("EpisodeID"))
			q:(PAAdm = "")
	 		d OutPutRow
		} 
	} 
	Quit $$$OK
	
OutPutRow
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s arrFiles = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(PAAdm)
	
	s PAStatusType = ""
	s PAStatusType = arrFiles.GetAt("PAStatusType")
	s PAStatusTypeDesc = ""
	s PAStatusTypeDesc = arrFiles.GetAt("PAStatusTypeDesc")
	s PAAdmType = ""
	s PAAdmType = arrFiles.GetAt("PAAdmType")
	s PAPMIName = ""
	s PAPMIName = arrFiles.GetAt("PAPMIName")
	s PAPMINO = ""
	s PAPMINO = arrFiles.GetAt("PAPMINO")
	s PAPMIDOB = ""
	s PAPMIDOB = arrFiles.GetAt("PAPMIDOB")
	s PAPMIAge = ""
	s PAPMIAge = arrFiles.GetAt("PAPMIAge")
	s PAPMISex = ""
	s PAPMISex = arrFiles.GetAt("PAPMISex")
	s PAAdmDateTime = ""
	s PAAdmDateTime = arrFiles.GetAt("PAAdmDateTime")
	s PAAdmWard = ""
	s PAAdmWard = arrFiles.GetAt("PAAdmWard")
	s PAAdmRoom = ""
	s PAAdmRoom = arrFiles.GetAt("PAAdmRoom")
	s PAAdmBed = ""
	s PAAdmBed = arrFiles.GetAt("PAAdmBed")
	s PAAdmLoc = ""
	s PAAdmLoc = arrFiles.GetAt("PAAdmLoc")
	s PADischgeDateTime = ""
	s PADischgeDateTime = arrFiles.GetAt("PADischgeDateTime")
	s PAAdmDoc = ""
	s PAAdmDoc = arrFiles.GetAt("PAAdmDoc")
	s PayMode = ""
	s PayMode = arrFiles.GetAt("PayMode")
	s PAAdm = ""
	s PAAdm = arrFiles.GetAt("PAAdm")
	s PatientID = ""
	s PatientID = arrFiles.GetAt("PatientID")
	
	/*
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2) 
	q:(PAAdmType '= "I")  
	//就诊类型
	if (PAAdmType = "I")
	{
		s PAAdmType = "住院"
	}
	elseif (PAAdmType = "O")
	{
		s PAAdmType = "门诊"
	}
	elseif (PAAdmType = "E")
	{
		s PAAdmType = "急诊"
	}

	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	s PAPMISex = ""
	if (Sex'=""){
		s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	}
	//婚姻
 	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	//职业
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if WardDr '= "" s PAAdmWard = $p($P($g(^PAWARD(WardDr)),"^",2),"-",2)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	s PAAdmLoc = $p($P($g(^CTLOC(Loc)),"^",2),"-",2)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	if (PAStatusType = "A")
	{
		s PAStatusTypeDesc = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusTypeDesc = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
	*/
 	s data = $lb(PAStatusType,PAStatusTypeDesc,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
    if ARegNo = $c(0) s ARegNo = ""

	if AMedRecordNo = $c(0) s AMedRecordNo = "" 
	if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")	
	}

    q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLEstimatePages).GetPatientInfo(114)
ClassMethod GetPatientInfo(AEpisodeID) As %String
{
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID)
	s regNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
	s name = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID)
	s gender = $p(##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(patientID),"^",3)
	s birthday = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetBirthday(patientID)
	s:(birthday '= "") birthday = $zd(birthday,3)
	
	s admLoc = $p(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).AdmDept(AEpisodeID),"^",3)
	s admDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(AEpisodeID)
	s:(admDate '= "") admDate = $zd(admDate,3)
	s disLoc = $p(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDept(AEpisodeID),"^",3)
	s disDate = $p(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID),"^",1)
	s:(disDate '= "") disDate = $zd(disDate,3)
	
	q regNo_"^"_medRecordNo_"^"_name_"^"_gender_"^"_birthday_"^"_admLoc_"^"_admDate_"^"_disLoc_"^"_disDate
}

/// Desc:	创建估算页数项目
ClassMethod CreateEstimatePagesItem(AItemCode As %String, AItemName As %String, AItemDesc As %String, ATypeParam As %String, AType As %String, AAvailable As %String, ASequence As %Integer) As %String
{
	s obj = ##class(DHCEPRFS.META.EstimatePagesItem).%New()
	s obj.ItemCode = AItemCode
	s obj.ItemName = AItemName
	s obj.ItemDesc = AItemDesc
	s obj.Type = AType
	s obj.TypeParam = ATypeParam
	s obj.Available = AAvailable
	s obj.Sequence = ASequence
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLEstimatePages","GetItem","10885846")
Query GetItem(AEpisodeID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemName:%String,ItemDesc:%String,TypeParam:%String,Type:%String,UnitPrice:%String,Pages:%String,SubTotal:%String")
{
}

ClassMethod GetItemExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.EstimatePageI("IdxSequence"," Y",sequence))
		q:(sequence = "")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.EstimatePageI("IdxSequence"," Y",sequence,rowID))
			q:(rowID = "")
		
			s obj = ##class(DHCEPRFS.META.EstimatePagesItem).%OpenId(rowID)
			s ItemCode = obj.ItemCode
			s ItemName = obj.ItemName
			s ItemDesc = obj.ItemDesc
			s TypeParam = obj.TypeParam
			s Type = obj.Type
			s RelatedItems = obj.RelatedItems
			
			s UnitPrice = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintPrice")
			s Pages = "0"
			if (Type = "71")
			{
				s Pages = ..GetEMRPages(AEpisodeID,TypeParam)
			}
			elseif (Type = "31")
			{
				s Pages = ..GetOrdPages(AEpisodeID,"long")
			}
			elseif (Type = "32")
			{
				s Pages = ..GetOrdPages(AEpisodeID,"temp")
			}
			elseif (Type = "82")
			{
				s Pages = ..GetLISPages(AEpisodeID)
			}
			elseif(Type = "83")
			{
				s Pages = ..GetPACSPages(AEpisodeID)
			}
			
			for index=1:1:$l(RelatedItems,"^")
			{
				//b "s"
				q:($l(RelatedItems,"^")=1)
				s oneRelatedItem = $p(RelatedItems,"^",index)
				s oneRelatedItemRowID = $o(^DHCEPRFS.META.EstimatePageI("IdxMain"," "_oneRelatedItem,""))
				s objRelatedItem = ##class(DHCEPRFS.META.EstimatePagesItem).%OpenId(oneRelatedItemRowID)
				s oneRelatedItemType = objRelatedItem.Type
				s oneRelatedItemTypeParam = objRelatedItem.TypeParam
				if (Type = "71")
				{
					s OnePages = ..GetEMRPages(AEpisodeID,oneRelatedItemTypeParam)
					s Pages = (+Pages) + (+OnePages)
				}
			}
			
			continue:(Pages = "")
			continue:(Pages = $c(0))
			
			s SubTotal = (+UnitPrice)*(+Pages)
			
			s ^CacheTemp(repid,ind) = $lb(rowID,ItemCode,ItemName,ItemDesc,TypeParam,Type,UnitPrice,Pages,SubTotal)
	    	s ind=ind+1	
		}
   }	
   Quit $$$OK
}

ClassMethod GetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLEstimatePages).GetEMRPages("10219630","CD_1_50")
ClassMethod GetEMRPages(AEpisodeID As %String, ATypeParam As %String) As %String
{
	q ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetEMRPages(AEpisodeID,ATypeParam)
}

ClassMethod GetOrdPages(AEpisodeID As %String, ALongOrTemp As %String) As %String
{
	q ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetOrdPages(AEpisodeID,ALongOrTemp)
}

/// debug: w ##class(DHCEPRFS.BL.BLEstimatePages).GetPACSPages("10762392")
ClassMethod GetPACSPages(AEpisodeID As %String) As %String
{
	s total = 0
	//取就诊下所有检查医嘱
	s orders = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPACSOrdIdByAdm(AEpisodeID)
	for index=1:1:$l(orders,"^")
	{
		s oneOrderID = $p(orders,"^",index)
		//s pages = ..GetPACSPagesOrder(oneOrderID)
		//报告有可能还没回来，那么一条检查医嘱应该有一份报告
		s pages = 1
		s total = total + (+pages)
	}
	
	q total
}

/// debug: w ##class(DHCEPRFS.BL.BLEstimatePages).GetPACSPagesOrder("10785828||27")
ClassMethod GetPACSPagesOrder(AOrderID As %String) As %String
{
	//需要将医嘱id中间的||转换为下划线
	s order = $p(AOrderID,"||",1)
	s orderSub = $p(AOrderID,"||",2)
	s orderIDParam = order_"_"_orderSub
	s service = ##class(DHCEPRFS.ThirdParty.WebService.GE.XieHeGEWebServicePort).%New()
	//w service
	s ret = service.QueryDocument(orderIDParam,"ORDER")
	
	//ret.DocumentUniqueIds
	q ret.TotalPdfPageNumber
}

/// debug: w ##class(DHCEPRFS.BL.BLEstimatePages).GetLISPages(14876266)
ClassMethod GetLISPages(AEpisodeID As %String) As %String
{
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPapmiDR(AEpisodeID)
	s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(PatientID)
	s AdmDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDate(AEpisodeID)
	s DisDate = $p(##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID),",",1)
	
	s AdmDateTime = ""
	if (AdmDate '= "") 
	{
		s AdmDateTime = $zd(AdmDate,8)_" 000000"
	}
	else
	{
		q "0"	
	}
	
	s DisDateTime = ""
	if (DisDate '= "") 
	{
		s DisDateTime = $zd(DisDate,8)_" 235959"
	}
	else
	{
		q "0"	
	}
	
	s input = RegNo_"^"_AdmDateTime_"^"_DisDateTime
	
	s service = ##class(LisWebService.ThirdParty.WebService.LisWebServiceSoap).%New()
	//w service
	//入参格式：42680953^20150101 000000^20160601 235959  
    //        病人登记号^开始日期时间^结束日期时间
	s ret = service.GetLisReportCounts(input)
	
	if ($p(ret,"^",1) = "0")
	{
		q $p(ret,"^",2)
	}
	else
	{
		q "0"	
	}
	//q ret

	//q "0"
}

/// w ##class(DHCEPRFS.BL.BLEstimatePages).UpDate()
ClassMethod UpDate() As %String
{
	s count = 0
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.EstimatePag35ECD(rowID))
		q:(rowID ="")
		s obj = ##class(DHCEPRFS.INST.EstimatePagesLog).%OpenID(rowID)
		s EstimatePagesDetail = obj.EstimatePagesDetail
		for i = 1:1:$l(EstimatePagesDetail,"^") 
		{
			s detail = $p(EstimatePagesDetail,"^",i)
			s objSub = ##class(DHCEPRFS.INST.EstimatePagesItem).%New()
			s objSub.EstimatePagesLog = obj
			s ItemID = $p(detail,"|",1)
			s ItemName = $p(detail,"|",2)
			s ItemPages = $p(detail,"|",3)
			s TotalPrice = $p(detail,"|",4)
			s objSub.ItemID = ItemID
			s objSub.ItemName = ItemName
			s objSub.ItemPages = ItemPages
			s objSub.TotalPrice = TotalPrice
			s scSub = objSub.%Save()
			if ($$$ISOK(scSub))
			{
				s count = count +1
			}
		}
	}
	q count
}

/// Desc:返回化验单的预估页数（化验单的ItemID为295,化验单生成为PDF的项目ID为273）
/// Creator:liushuang
/// Createdate:2017-03-20
/// debug: w ##Class(DHCEPRFS.BL.BLEstimatePages).GetItemPages("2017-3-20","2017-3-20","295","273")
ClassMethod GetItemPages(AStartDate As %String, AEndDate As %String, AItemID As %String, AMRItemID As %String) As %String
{
	s AStartDate=$zdh(AStartDate,3)
    s AEndDate=$zdh(AEndDate,3)
    q:(AStartDate="") "-1"
	q:(AEndDate="") "-1"
	q:(AItemID = "") "-1"
	
	s countA = 0
	s countB = 0
   	for ActDate=AStartDate:1:AEndDate
   	{
	   	s rowID = ""
	   	for {
		   	s rowID = $o(^DHCEPRFS.INST.EstimatePag35ECI("IdxActDate",ActDate,rowID))
		   	q:(rowID = "")
		   	s rowIDSub = ""
		   	for {
			   	s rowIDSub =$o(^DHCEPRFS.INST.EstimateItemI("IdxMain",rowID," "_AItemID,rowIDSub))
			   	q:(rowIDSub = "")
			   	s obj = ##class(DHCEPRFS.INST.EstimatePagesItem).%OpenId(rowID_"||"_rowIDSub)
			   	s ItemPages = obj.ItemPages
			   	s ItemPages = +ItemPages
			   	if (countA = 0)
			   	{
				   	s countA = ItemPages
			   	}
			   	else
			   	{
				   	s countA = countA + ItemPages
			   	}
		   	}
		   	
		   	s objMain = ##class(DHCEPRFS.INST.EstimatePagesLog).%OpenId(rowID)
		   	s episodeID = objMain.EpisodeID
		   	s MREpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(episodeID,"DHC")
		   	s mrVerionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(MREpisodeID)
		   	s rowIDMRVer = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVerionID, " "_AMRItemID, ""))
			continue:(rowIDMRVer="")
			s obj = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(rowIDMRVer)
			s TotCount = obj.TotCount
			if (countB = 0)
			{
				s countB = TotCount
			}
			else
			{
				s countB = countB +TotCount
			}		   	
	   	}
   	}
   	q countA_"^"_countB
}

}
