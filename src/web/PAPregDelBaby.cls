Class web.PAPregDelBaby Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 520;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BABY_RowId";

Parameter SQLDESCRIPTION = "BABY_RowId";

Parameter SQLROWID = "BABY_RowId";

/// Default implementation of LookUp Query.
ClassMethod FindRegWithNoBabyDtlClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRegWithNoBabyDtlFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindRegWithNoBabyDtlExecute(ByRef QHandle As %Library.Binary, mumId As %String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindRegWithNoBabyDtlFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRegWithNoBabyDtlExecute ]
{
}

ClassMethod FindEnquiryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindEnquiryExecute ]
{
}

ClassMethod FindEnquiryExecute(ByRef QHandle As %Binary, hFlag1, LABDELCOMPLDescString, INDINDCTRDescString, PUERPDescString, hFlag2, DELMTHDescString, RESUSDescString, CONGANOMDescString, NEOMORBDescString, AUGMTHDescString, INDMTHDescString, PRECOMPLDescString) As %Status
{
}

ClassMethod FindEnquiryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEnquiryExecute ]
{
}

// This method builds the enquiry query.

// The query is dynamic depending on the user criteria.

ClassMethod BuildEnquiryQuery(CntD, CntB, hFlag1, LDComplStr, IIStr, PuerpStr, hFlag2, DelMthStr, ResusStr, CongStr, NeoMorbStr, AugMthStr, IndMthStr, PreComplStr) As %String
{
}

// This method dynamically builds the select clause.

ClassMethod BuildEnquirySelectQuery(CntD As %String = "", CntB As %String = "") As %String
{
}

// This method dynamically builds the From clause

ClassMethod BuildEnquiryFromQuery(LDComplStr, IIStr, PuerpStr, DelMthStr, ResusStr, CongStr, NeoMorbStr, AugMthStr, IndMthStr, PreComplStr) As %String
{
}

// This method dynamically builds the Where clause

ClassMethod BuildEnquiryWhereQuery(hFlag1, LDComplStr, IIStr, PuerpStr, hFlag2, DelMthStr, ResusStr, CongStr, NeoMorbStr, AugMthStr, IndMthStr, PreComplStr) As %String
{
}

// This method builds the Order clause

ClassMethod BuildEnquiryOrderQuery() As %String
{
}

ClassMethod GetEnqTotals(hFlag1, LDComplStr, IIStr, PuerpStr, hFlag2, DelMthStr, ResusStr, CongStr, NeoMorbStr, AugMthStr, IndMthStr, PreComplStr) As %String
{
}

Query FindEnquiry(hFlag1, LABDELCOMPLDescString, INDINDCTRDescString, PUERPDescString, hFlag2, DELMTHDescString, RESUSDescString, CONGANOMDescString, NEOMORBDescString, AUGMTHDescString, INDMTHDescString, PRECOMPLDescString) As %Query(ROWSPEC = "BabyId,BirthOrderNumber,BirthDate,TimeOfBirth,CTSEXDesc,OPREGDesc,GestWeeks,GestDays,MotherId,MotherName,MotherName2,MotherBirthCountry,DelId,PregId,BabyPersonId,DelEpId,MthrAdmDate,EDDAgreed,Plurality,BabyVIPStatus,MotherVIPStatus")
{
}

/// Returns the no. of babies that have a mother link but 
/// do not have baby clinical details
ClassMethod GetNoUnlinkedBabies(mumId As %String) As %Integer
{
}

/// PatientID
ClassMethod FindLinkStatus(mumId As %String) As %String
{
	Q ""
}

/// yanglei
/// delId为User.PAPregDelivery
/// maxBirthDate baby出生日期最大的
ClassMethod GetMaxBabyDob(delId As %String) As %String
{
	s maxBirthDate=""
	&SQL(SELECT max(baby_birthdate)into :maxBirthDate FROM SQLUser.PA_PregDelBaby where baby_Parref=:delId)
	i SQLCODE=0&(maxBirthDate'="")
	{
	  	q $zd(maxBirthDate,4)
	} else{
		q ""
	}
}

ClassMethod GetApgarScore(id As %String, apgarNo As %String) As %String
{
	set apgarId=##class(web.PAPrDelBabyApgarScore).GetRowId(id,apgarNo)
	if (apgarId'="") {
	set scoreOBJ=##class(User.PAPrDelBabyApgarScore).%OpenId(apgarId)
	set total=(+scoreOBJ.PDBASHeartRate)+(+scoreOBJ.PDBASRespiration)+(+scoreOBJ.PDBASTone)+(+scoreOBJ.PDBASReflex)+(+scoreOBJ.PDBASColour)
	}
    q $g(total)
}

ClassMethod GetDelCatStr(babyId As %String) As %String
{
}

/// yanglei
/// delId为User.PAPregDelivery 
/// maxBirthDate baby出生时间最大的
ClassMethod GetMaxBabyTob(delId As %String) As %String
{
	set maxBirthDate="",maxBirthTime=""
	&SQL(SELECT max(baby_birthdate)into :maxBirthDate FROM SQLUser.PA_PregDelBaby where baby_Parref=:delId)
	i SQLCODE=0&(maxBirthDate'="")
    {
	&SQL(SELECT (BABY_TimeOfBirth)into :maxBirthTime FROM SQLUser.PA_PregDelBaby where baby_Parref=:delId and baby_birthdate=:maxBirthDate)
	i SQLCODE=0
	q $e($zt(maxBirthTime),0,5)
    }
    else
    {
	    q ""
	}
}

/// /w ##class(web.PAPregDelBaby).SetBabyRegDefaults("143788")
ClassMethod SetBabyRegDefaults(babyId As %String)
{
	s %request.Data("ID",1)=""
	
	//跳转到PAPerson.Edit 页面传递婴儿性别和年龄
	s PregnancyRowID=$p(babyId,"||",1),deliverID=$p(babyId,"||",2),babyRowID=$p(babyId,"||",3)

	s TimeOfBirth=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",49)
	
	s babySex=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",48)	 
	s %request.Data("CTSEXDesc",1)=$S(babySex'=""'="":$p($g(^CT("SEX",babySex)),"^",2),1:"")
	
	s BirthDate=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",13)	
	s:BirthDate'="" %request.Data("PAPERDob",1)=$zdt($g(BirthDate),4)
	s %request.Data("Age",1)=0

	&sql(select PREG_Person_DR,PREG_Person_DR->PAPER_Name ,PREG_Person_DR->PAPER_Name2 
	into :motherId, :paperName,:paperName2 
	from  SQLUser.PA_Pregnancy 
	where PREG_RowId=:PregnancyRowID )	

	s %request.Data("RegistrationNo",1)=""	 
    s:$g(paperName)'="" %request.Data("PAPERName",1)=paperName_"之婴"
    s PARREF=%request.Data("PARREF",1)
    s babyOrdNum = $g(%request.Data("BABYBirthOrderNumber",1))
    i babyOrdNum="" s babyOrdNum = ..GetLatestBirthOrder($g(PARREF))
    i babyOrdNum>1 s:$g(paperName)'="" %request.Data("PAPERName",1)=paperName_"之婴"_babyOrdNum
    s:$g(paperName2)'="" %request.Data("PAPERName2",1)=paperName2 
	s %request.Data("PAPERBabyDR",1)=babyId
	s %request.Data("PAPERMotherDR",1)=motherId
}

ClassMethod SetPerson(babymatid As %String, babypersondr As %String)
{
}

ClassMethod GetBabyIdByPatId(babypatid As %String) As %String
{
}

ClassMethod GetDetailsByPatId(babypatid As %String) As %String
{
}

/// d ##class(web.PAPregDelBaby).SetBabyAdmitDefaults(4016008)
ClassMethod SetBabyAdmitDefaults(babypatid As %String)
{
	s parentpaadm=""
	&sql(select baby_parref->del_adm_dr,BABY_BirthDate,BABY_TimeOfBirth into :parentpaadm,:BirthDate,:BirthTime from SQLUser.PA_PregDelBaby where baby_Person_DR=:babypatid)
	
	s %request.Data("LeaveDate",1)=$ZD(BirthDate,4)	;出生日期为就诊日期
	s %request.Data("LeaveTime",1)=$ZT(BirthTime,1)  ;出生时间为就诊时间
	q:parentpaadm="" ""
	s tmpObj = ##class(User.PAAdm).%OpenId(parentpaadm,1)
	q:'$IsObject(tmpObj) ""
	s type="",ward="",loc="",warddr="",hosp=""
	s type = tmpObj.PAADMType
	i $IsObject(tmpObj.PAADMCurrentWardDR) s ward = tmpObj.PAADMCurrentWardDR.WARDDesc
	s loc = tmpObj.PAADMDepCodeDR.CTLOCDesc
	s warddr = tmpObj.PAADMCurrentWardDR
	i $IsObject(tmpObj.PAADMHospitalDR) s hosp = tmpObj.PAADMHospitalDR.HOSPDesc
	d tmpObj.%Close()
	s tmpObj=""
	S %request.Data("admType",1)=type
	;s %request.Data("LeaveHosp",1)=hosp
	;s %request.Data("LeaveWard",1)=ward ;WARDDesc
	;s %request.Data("LeaveLoc",1)=loc

	s %request.Data("PAADMParentWardDR",1)=warddr
	q ""
}

/// w ##class(web.PAPregDelBaby).CanAutoRegister("392||2||12")
ClassMethod CanAutoRegister(babymatid As %String) As %Boolean
{
	n obj
	s obj=##class(User.PAPregDelBaby).%OpenId(babymatid)
	if $IsObject(obj)&&($IsObject(obj.BABYOutcomeDR)){
		s register=obj.BABYOutcomeDR.OPREGAutoRegister
		d obj.%Close()
		s obj=""
		if register="Y" Q 1
	}
	Q 0
	/*
	//转移到PatientEdit
	q:$g(%request.Data("BablDelNew"))=1 0
	Q 1
	*/
}

/// w ##class(web.PAPregDelBaby).CanAutoAdmitByPatId(1)
ClassMethod CanAutoAdmitByPatId(patId As %String) As %Boolean
{
	n obj,babymatid,admit
	if patId="" Q 0
	&SQL(select BABY_RowId into :babymatid from SQLUser.PA_PregDelBaby where BABY_Person_DR=:patId)
	if SQLCODE Q 0
	if babymatid="" Q 0
	Q ..CanAutoAdmit(babymatid)
	
	 q:$g(%request.Data("BablDelNew",1))=1 0
	 q:$g(%request.Data("BablDelNew",1))'=1 1
}

/// w ##class(web.PAPregDelBaby).CanAutoAdmit("392||2||12")
ClassMethod CanAutoAdmit(babymatid As %String) As %Boolean
{
	n obj,admit
	s obj=##class(User.PAPregDelBaby).%OpenId(babymatid)
	if $IsObject(obj)&&($IsObject(obj.BABYOutcomeDR)){
		s admit=obj.BABYOutcomeDR.OPREGAutoAdmit
		d obj.%Close()
		s obj=""
		if admit="Y" Q 1
	}
	Q 0
}

ClassMethod GetPatIdFromRegistration(regid As %String) As %String
{
}

/// d ##class(web.PAPregDelBaby).websysDeleteRenumber("2||4||2")
ClassMethod websysDeleteRenumber(id As %String)
{
	//s $ZT="websysDeleteRenumberError"
	///因为加载分娩记录界面时，会调用web.DHCADTTransaction.web.DHCADTTransactiong查找母亲关联
	///的婴儿就诊记录上的记录当前床位去激活床位，所以必须在删除婴儿记录时,同时将只向母亲就诊记录
	///的PAADMMotherAdmDR字段置空,并更新床位记录的激活状态"N",这样床位图上才不会显示,但目前的情况是没有清空指向母亲的指针
	n obj,objadm
	s BABYPersonDR=""
	s obj=##class(User.PAPregDelBaby).%OpenId(id)
	if $IsObject(obj.BABYPersonDR) s BABYPersonDR=obj.BABYPersonDR.%Id()
	d obj.%Close()
	set obj=""
	if BABYPersonDR'="" {
		s BABYAdmDR=""
		s MotherAdmId=$p($g(^PAPRG(+id,"DEL",$P(id,"||",2))),"^",1)
		s AdmDR=0 f {
			s AdmDR=$O(^PAPERdr(BABYPersonDR,"ADM","I",AdmDR))
			Q:AdmDR=""
			s AdmMotherDR=$P($G(^PAADM(AdmDR)),"^",75)
			if AdmMotherDR=MotherAdmId s BABYAdmDR=AdmDR
		}
		if BABYAdmDR'="" {
			s objadm=##class(User.PAAdm).%OpenId(BABYAdmDR)
			if $IsObject(objadm) {
				s ordId=$o(^OEORD(0,"Adm",BABYAdmDR,0))
				s name = $zu(28,"PAPregDelBaby.EditFull1",6)    /// AlphaUp 规则
				s mycompid=$o(^websys.ComponentI("UniqueNameIndex",name,0))
				;加了msg,有时间不能正确提示,影响后面的工作流走
				;i ordId>0,mycompid>0 d msg.AddItem("E","Error", "病人已产生医嘱,不能删除,请办理出院", mycompid,"DELPlurality") 
				i ordId>0 q 1
				;d objadm.PAADMMotherAdmDRSetObjectId("")
				;d objadm.%Save()
				if $IsObject(objadm.PAADMCurrentBedDR){
					s CurrentBedDR=objadm.PAADMCurrentBedDR.%Id()
					&SQL(Update SQLUser.PAC_Bed Set BED_RcFlag='N' Where BED_RowId=:CurrentBedDR)
					&SQL(Delete from SQLUser.PAC_BedAdm where ADM_ParRef=:CurrentBedDR)
				}
				d objadm.%Close()
				s objadm=""
				&SQL(Update SQLUser.PA_adm set PAADM_VisitStatus='C' where PAADM_RowID=:BABYAdmDR)
			}
		}
	}
	&SQL(Delete From SQLUser.PA_PregDelBaby where BABY_RowId=:id)
	s %request.Data("BabyDeleted",1)=1
	Quit $$$OK
websysDeleteRenumberError
  	s ^TEMP("Upgrade","PAPRegDelBaby:websysDeleteRenumber","Error",$h)=$ZE
  	q ""
}

/// d ##class(%ResultSet).RunQuery("web.PAPregDelBaby","FindOrderByDOBTime",""1||6||19"")
Query FindOrderByDOBTime(delId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT BABY_RowId, BABY_BirthOrderNumber, BABY_BirthDate, BABY_TimeOfBirth
FROM SQLUser.PA_PregDelBaby 
WHERE BABY_ParRef = :delId
ORDER BY BABY_BirthDate, BABY_TimeOfBirth
}

/// Default implementation of LookUp Query.
ClassMethod FindByDeliveryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByDeliveryFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// yanglei
/// Default implementation of LookUp Query.
/// d ##class(%ResultSet).RunQuery("web.PAPregDelBaby","FindByDelivery","3695||6") 
/// VIPStatus 不知道用处和来源
ClassMethod FindByDeliveryExecute(ByRef QHandle As %Library.Binary, PAPregDeliveryID As %String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	 
	 i PAPregDeliveryID=""
	 {
		 q $$$OK
	 }
	 s CTSEXDesc=""
	 s PregnancyRowID=$P(PAPregDeliveryID,"||",1),deliverID=$p(PAPregDeliveryID,"||",2)
	 
	 s paPatmasRowid=$p($g(^PAPRG(PregnancyRowID)),"^",19)
	 s:paPatmasRowid'="" VIPStatus=$p($g(^PAPER(paPatmasRowid,"PAT",4)),"^",1)
	 
     s babyRowID=0  f  s babyRowID=$o(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)) q:babyRowID=""  d     
	 .s ID=PAPregDeliveryID_"||"_babyRowID	
	 .s BirthDate=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",13)
	 .s BirthOrderNumber=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",15)
	 .s TimeOfBirth=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",49)
	 .s babySex=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",48)	 
	 .s:babySex'="" CTSEXDesc=$p($g(^CT("SEX",babySex)),"^",2)
	 .s OutCome=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",23)
	 .s GestDays=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",29)
	 .s GestWeeks=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",30)
	 .s:OutCome'="" OPREGDesc=$P(^PAC("OPREG",OutCome),"^",2)
	 .s BabyPersonDR=$P($g(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID)),"^",73)	
	 .s DeliveryMethod = "",DeliveryMethodDesc="",deliveryMethodID=0
	 .f  s deliveryMethodID = $o(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID,"PDBDM",deliveryMethodID)) q:deliveryMethodID=""  d
	 ..s DeliveryMethodDr=$p(^PAPRG(PregnancyRowID,"DEL",deliverID,"BABY",babyRowID,"PDBDM",deliveryMethodID),"^")
	 ..q:$g(DeliveryMethodDr)="" 
	 ..s DeliveryMethodDesc=$P($g(^PAC("DLMTH",DeliveryMethodDr)),"^",2)
	 ..i DeliveryMethod'="" s DeliveryMethod=DeliveryMethod_","_DeliveryMethodDesc
	 ..e  s DeliveryMethod=DeliveryMethodDesc
	 .s ^CacheTemp(repid,ind)=$lb(ID,PAPregDeliveryID,BirthOrderNumber,BirthDate,TimeOfBirth,CTSEXDesc,OPREGDesc,DeliveryMethod,GestWeeks,GestDays,BabyPersonDR,VIPStatus)
	 .s ind=ind+1
	 
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod FindByDeliveryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByDeliveryExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// yanglei
/// 获取婴儿数量
/// PARREF为User.PAPregDelivery的ID
ClassMethod GetLatestBirthOrder(PARREF As %Library.String = "") As %Library.Integer
{
   
	s maxBabyNumber=""
	&SQL(SELECT count(*) into:maxBabyNumber FROM SQLUser.PA_PregDelBaby where baby_Parref=:PARREF)	
	q (maxBabyNumber)
}

ClassMethod GetPAPMINo(patid As %Library.String) As %Library.Integer
{
}

ClassMethod GetPlanDelPlaceByDelId(delId As %Library.String) As %Library.Integer
{
	n (delId)
	set delplace=0
	set obj = ##class(User.PAPregDelBaby).%OpenId(delId) 	
	if $IsObject(obj) s delPlace = obj.BABYActualDelivPlaceDRGetObjectId() ;obj. BABYActualDelivPlaceDR
	;IF $IsObject(delPlaceObj){
		;s delplace = delPlaceObj.DELPLNationalCode
	;}
	q delplace
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	s $ZT="websysAterSaveError"
	/*
	s %request.Data("PatientBanner",1)=1 
	s (%request.Data("ID",1), %request.Data("PAPregDeliveryID",1))=##Class(web.PAPregDelivery).GetIdByEpId($g(%request.Data("EpisodeID",1))) 
	s %request.Data("DelType",1)="Delivery" 
	s %request.Data("ShowPlacenta",1)=0 
	i $d(%request.Data("PAPregnancyID",1)) {s %request.Data("PARREF",1)=$g(%request.Data("PAPregnancyID",1))} else {s (%request.Data("PARREF",1), %request.Data("PAPregnancyID",1))=##Class(web.PAPregnancy).GetIDFromEpisodeID($g(%request.Data("EpisodeID",1)))} 
	s %request.Data("BabyWKFLName",1)="Trak.Maternity.Baby" 
	s %request.Data("ApgarWKFLName",1)="Trak.Maternity.ApgarScore"
	*/
	/*
	d ##Class(web.PAPregDelBaby).SetBabyAdmitDefaults($g(%request.Data("PatientID",1))) 
	s %request.Data("MaternityBabyWkfl",1)=1
	*/

    //PAPregDelBaby.EditFull1
    //目前只判断了分娩方式,其他类似有List的元素,也需要这样处理
    if $d(%request.Data("DELMTHDesc",1)) {
   		s DeliveryMethod=$g(%request.Data("DELMTHDescString",1))
		s DMRowIdStr=""
		s DMChild=0 f {
			s DMChild=$O(^PAPRG($p(id,"||",1),"DEL",$p(id,"||",2),"BABY",$p(id,"||",3),"PDBDM",DMChild))
			Q:DMChild=""
			s DMRowId=id_"||"_DMChild
			s DMRowIdStr=$S(DMRowIdStr="":DMRowId,1:DMRowIdStr_"^"_DMRowId)
		}
		f count1 = 1:1:$l(DMRowIdStr,"^") {
			s DMRowId=$p(DMRowIdStr,"^",count1)
			continue:DMRowId=""
			s find=0
	        s count=$l(DeliveryMethod,$c(1))
	        f start = 1:1:count {
	        	s DeliveryMethodStr=$p(DeliveryMethod,$c(1),start)
	        	s PDBDMRowId=$p(DeliveryMethodStr,$c(2),1)
	        	if PDBDMRowId=DMRowId s find=1
			}
			if find=0 {
				&SQL(Delete From SQLUser.PA_PrDelBabyDelMthd where PDBDM_RowId=:DMRowId)
			}
		}
		
        s count=$l(DeliveryMethod,$c(1))
        f start = 1:1:count {
        	s DeliveryMethodStr=$p(DeliveryMethod,$c(1),start)
        	s PDBDMRowId=$p(DeliveryMethodStr,$c(2),1)
        	s DeliveryMethodID=$p(DeliveryMethodStr,$c(2),2)
        	if (PDBDMRowId="")&&(DeliveryMethodID'="") {	
				s method=##class(User.PAPrDelBabyDelMthd).%New(id)			
				d method.PDBDMDelMthdDRSetObjectId(DeliveryMethodID)
				d method.PDBDMParRefSetObjectId(id)
				s rs=method.%Save()	
			}
		}
	}
	s %request.Data("PARREF",1)=$p(id,"||",1,2)
	s %request.Data("ID",1)=id

  	s %request.Data("delbabyId",1)=id

    q $$$OK
websysAterSaveError
  s ^TEMP("Upgrade","PAPRegDelBaby:websysAfterSave","Error",$h)=$ZE
  q ""
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	
	;2010版
	s PAPregDeliveryObj = ##class(User.PAPregDelivery).%OpenId($g(%request.Data("PARREF",1)),0)
	s PLURBabyCount=0
	if $IsObject(PAPregDeliveryObj),$IsObject(PAPregDeliveryObj.DELPlurality){
		s PLURBabyCount = PAPregDeliveryObj.DELPlurality.PLURBabyCount
	}
	s BABYBirthOrderNumber = $g(%request.Data("BABYBirthOrderNumber",1)) 
	if PLURBabyCount<BABYBirthOrderNumber {
		d ##Class(websys.Component).GetComponentMessages(.t,"PAPregDelBaby.EditFull1")
		d msg.AddItem("E","", $s($d(t("BabyNo_Greater")):t("BabyNo_Greater"),1:"Baby Number being entered is greater than expected number of babies."), compid, "BABYBirthDate")
		q 0
	}
	Q $$$OK
}

ClassMethod SetBabyMotherDefaults(BabyID As %Library.String = "")
{
}

Query FindByDelivery(PAPregDeliveryID As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,ParRef,BirthOrderNumber,BirthDate,TimeOfBirth,CTSEXDesc,OPREGDesc,DeliveryMethod,GestWeeks,GestDays,BabyPersonDR,VIPStatus")
{
}

Query FindDelMthd(babyID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DLMTHDesc")
{
SELECT PDBDM_DelMthd_DR->DLMTH_Desc
FROM SQLUser.PA_PrDelBabyDelMthd 
WHERE PDBDM_ParRef = :babyID
}

Query FindPersonsByMother(mumId As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name,Name2,Name3,Dob:%Date,Sex,Deceased")
{
 SELECT paper_rowid, paper_name, paper_name2, paper_name3, paper_dob, paper_sex_dr->ctsex_desc, paper_deceased
 FROM SQLUser.PA_Person
 WHERE PAPER_Mother_DR = :mumId
}

Query FindRegWithNoBabyDtl(mumId As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,RegistrationNo,Name,Name2,Name3,Dob:%Date,Sex,Deceased,VIPStatus")
{
}

}
