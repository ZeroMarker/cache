Import User

Include Nur.DateFormat

IncludeGenerator webimport

Class web.PAPerson Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2846;

Parameter SQLCODE = "PAPER_BillCode";

Parameter SQLDATEFROM = "PAPER_DiscDateFrom";

Parameter SQLDESCRIPTION = "PAPER_RowId";

Parameter SQLDATETO = "PAPER_DiscDateTo";

Parameter SQLROWID = "PAPER_RowId";

Property dummy As %String(TRUNCATE = 1);

/// cjb 10/08/2006 60139 - go through all the checkboxes on PAPerson.ExternalMerge.Edit and if ticked set the 'External' field values in ^TMP("WEB",%session.SessionId,"EXTERNALMERGE".  This is then picked up in paperson.edit.externalmerge.hidden.csp
ClassMethod setEXTERNALMERGE() As %Library.String
{
}

/// 48939
ClassMethod websysSavePhoto(compref As %String, PatientID As %String = "") As %Library.String
{
}

ClassMethod websysDeletePhoto(PatientID As %Library.String)
{
}

ClassMethod GetPatientPhoto(id As %Library.String) As %Boolean
{
}

ClassMethod ShowPatientPhoto(id As %Library.String)
{
}

ClassMethod AllocateManualMRN(PatientID As %String = "", Location As %String = "") As %Library.Boolean
{
	quit ""
}

ClassMethod websysDeleteFamilyLink(PatientID As %Library.String, LinkPat As %Library.String, relationcode As %Library.String)
{
}

ClassMethod FindFamilyLinksClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFamilyLinksExecute ]
{
}

ClassMethod FindFamilyLinksExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod FindFamilyLinksFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindFamilyLinksExecute ]
{
}

Query FindFamilyLinks(PatientID) As %Library.Query(CONTAINID = 0, ROWSPEC = "relation:%String,rego:%String,surname:%String,givenname:%String,dob:%Date,sex:%String,address:%String,suburb:%String,postcode:%String,tel:%String,mrn:%String,pat:%String,relationcode:%String")
{
}

ClassMethod IsPatientActive(PatientID As %String = "", compid As %String = "") As %Library.Boolean
{
}

/// JW 22/10/02: used in
/// 
/// web.PAPerson:GetArrayDetails
/// PACWard.ListPatientsInWard / PACWardRoom.ListPatients components
/// by wuqk 2011-06-21 * 未完成
ClassMethod CanGiveBirth(PatientID As %Library.String = "") As %Library.String
{
	quit $$$OK
}

/// JW: used in 
/// 
/// PAWaitingList.Edit Deceased 
/// PAWaitingListInquiry.List Deceased 
/// PAWaitingList.EditRemoveReinstate Deceased 
/// PAWaitingListAdm.Edit Deceased 
/// PAWaitingListNotAvailable.Edit Deceased 
/// PAWaitingList.Transfer.Find Deceased1 
/// PAWaitingListReview.Edit Deceased 
/// PAWaitingList.Transfer.New Deceased 
/// PAWaitingListAdm.List Deceased 
/// by wuqk 2011-06-02
ClassMethod CheckDeceased(PatientID As %Library.String) As %Library.Boolean
{
	Quit:PatientID="" ""
	;PAPMI_Deceased____  "ALL"__________  12______  "^"
	quit $p($g(^PAPER(PatientID,"ALL")),"^",12)
}

/// ab 37659 - check if a patient is stillborn, takes a comma delimited list of codes to check (PAC_OutcomeOfPregancy)
/// used in stillborn icon and PAPerson.GetArrayDetails
ClassMethod IsStillborn(PatientID As %String = "", codes As %String = "") As %Boolean
{
}

/*
ClassMethod FindCursorFetch(type As %Library.String, Mode As %Library.String) [ PlaceAfter = FindCursorOpen ]
{

 i type=1,Mode=1 d
 . &sql(FETCH PATREG INTO :ROWID)
 i type=1,Mode=2 d
 . &sql(FETCH PATRT INTO :ROWID)
 i type=2 d
 . &sql(FETCH PATMRN INTO :ROWID)
 i type=3 d
 . &sql(FETCH PATBIL INTO :ROWID)
 i type=4 d
 . &sql(FETCH PATADM INTO :ROWID)
 i type=5 d
 . &sql(FETCH PATGOV INTO :ROWID)
 i type=6 d
 . &sql(FETCH PATSSN INTO :ROWID)
 i type=7 d
 . &sql(FETCH PATNAT INTO :ROWID)
 q
}

ClassMethod FindCursorOpen(type As %Library.String)
{
 ; Use index by RegistrationNo
 &sql(DECLARE PATREG CURSOR FOR SELECT PAPMI_ROWID FROM PA_PatMas WHERE PAPMI_No = :Registration)
 &sql(DECLARE PATRT CURSOR FOR SELECT RTMAS_PatNo_DR FROM RT_Master WHERE RTMAS_MRNo %STARTSWITH :Registration AND (RTMAS_MRType_DR->TYP_Desc = :MRTypeDesc OR :MRTypeDesc IS NULL))
 i type=1 d
 . &sql(OPEN PATREG)
 
 ; Use index by Medical Record No
 &sql(DECLARE PATMRN CURSOR FOR SELECT RTMAS_PatNo_DR->PAPMI_RowId FROM RT_Master WHERE RTMAS_MRNo %STARTSWITH :MedicalRecordNo)
 i type=2 d
 . &sql(OPEN PATMRN)
 
 ; Use index by Bill No
 &sql(DECLARE PATBIL CURSOR FOR SELECT ARPBL_PAADM_DR->PAADM_PAPMI_DR->PAPMI_RowId FROM AR_PatientBill WHERE ARPBL_BillNo = :BillNo)
 i type=3 d
 . &sql(OPEN PATBIL)
 
 ; Use index by Admission/Epsiode No
 &sql(DECLARE PATADM CURSOR FOR SELECT PAADM_PAPMI_DR->PAPMI_RowId FROM PA_Adm WHERE PAADM_ADMNo %STARTSWITH :EpisodeNo)
 i type=4 d
 . &sql(OPEN PATADM)
 
 ; Use index by Government Card No
 &sql(DECLARE PATGOV CURSOR FOR SELECT PAPER_RowId FROM PA_Person WHERE PAPER_GovernCardNo %STARTSWITH :GovtCardNo)
 i type=5 d
 . &sql(OPEN PATGOV)
 
 ; Use index by SSN
 &sql(DECLARE PATSSN CURSOR FOR SELECT PAPMI_ROWID FROM PA_PatMas WHERE PAPMI_Medicare %STARTSWITH :SSN)
 i type=6 d
 . &sql(OPEN PATSSN)
 
 ; Use index by NationalID
 &sql(DECLARE PATNAT CURSOR FOR SELECT PAPER_ROWID FROM PA_Person WHERE PAPER_ID = :NationalID)
 i type=7 d
 . &sql(OPEN PATNAT)
 
 ; The rest !!!
 &sql(DECLARE PATXXX CURSOR FOR SELECT KEYW_ParRef FROM PA_PersonKeywords WHERE KEYW_Name %STARTSWITH :mName)
 
 q
}
*/
ClassMethod FindEpisodeStatusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeStatusFetch ]
{
}

ClassMethod FindEpisodeStatusExecute(ByRef QHandle As %Library.Binary, regostring As %Library.String, admstring As %Library.String, action As %Library.Status, btype As %Library.String) As %Library.Status [ PlaceAfter = FindClose ]
{
}

ClassMethod FindEpisodeStatusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeStatusExecute ]
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by wuqk 2011-06 部分参数L315、输出L433不确定
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, Registration As %String = "", PAPERName As %String = "", PAPERName2 As %String = "", PAPERName3 As %String = "", NationalID As %String = "", SSN As %String = "", CTSEXDesc As %String = "", GovtCardNo As %String = "", ProvOB As %String = "", MedicalRecordNo As %String = "", BillNo As %String = "", EpisodeNo As %String = "", PAPERDob As %Date = "", soundex As %String = "", Phone As %String = "", hiddenFlag As %String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s index=$i(^Temp)
	
	//m ^Temp("Upgrade","FindExecute","%req")=%request.Data
	/*
	s ^Temp("Upgrade","FindExecute","Registration")=Registration
	s ^Temp("Upgrade","FindExecute","PAPERName")=PAPERName
	s ^Temp("Upgrade","FindExecute","PAPERName2")=PAPERName2
	s ^Temp("Upgrade","FindExecute","PAPERName3")=PAPERName3
	s ^Temp("Upgrade","FindExecute","NationalID")=NationalID
	s ^Temp("Upgrade","FindExecute","SSN")=SSN
	s ^Temp("Upgrade","FindExecute","CTSEXDesc")=CTSEXDesc
	s ^Temp("Upgrade","FindExecute","GovtCardNo")=GovtCardNo
	s ^Temp("Upgrade","FindExecute","ProvOB")=ProvOB
	s ^Temp("Upgrade","FindExecute","MedicalRecordNo")=MedicalRecordNo
	s ^Temp("Upgrade","FindExecute","BillNo")=BillNo
	s ^Temp("Upgrade","FindExecute","EpisodeNo")=EpisodeNo
	s ^Temp("Upgrade","FindExecute","PAPERDob")=PAPERDob
	s ^Temp("Upgrade","FindExecute","soundex")=soundex
	s ^Temp("Upgrade","FindExecute","Phone")=Phone
	s ^Temp("Upgrade","FindExecute","hiddenFlag")=hiddenFlag
	*/
	/*
	//"^^^^On^^1^^^北京地坛医院|北京地坛分院^E|I^^26/08/2010^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	  aryPATCF=web.CFPatConf.GetSystemConfig.split("^")
	  * layout 页面仅有的checkbox元素
	  hiddenFlag 的组成顺序如下
		1	var objCur=document.getElementById('current');	On
		2	var objReg=document.getElementById('regoflag');	On
		3	var objMRType=document.getElementById('MRType');	
		4	objage.value+"|"+objagetype.value	
		5	var objEx=document.getElementById('exact');	On        *
		6	var objDVA=document.getElementById('DVANumber');	
		7	var objSecGrp=document.getElementById('secgrp');	
		8	var objAll=document.getElementById('allnames');	On    *
		9	if aryPATCF[1]="Y"  On	else ""
		10	var objSelHosp=document.getElementById("SelHospital");	
		11	var obj=document.getElementById("SelAdmissionType");	
		12	VisitStatus	
		13	AdmDateFrom	
		14	admToDate	
		15	AdmDoc	
		16	AdmLoc	
		17	AdmRespUnit	
		18	AdmWard	
		19	ExpAdmDateFrom	
		20	ExpAdmDateTo	
		21	SelBookingType	
		22	AdmissionPoint	
		23	SignificantFacility	
		24	CurrAppts	
		25	AdmDateFrom2	
		26	AdmDateTo2	
		27	SelAdmHospital	
		28	GroupNo	
		29	null	
		30	null	
		31	PENSTYPEDesc	
		32	name4	
		33	soundex	               *
		34	mobile	
		35	ziprowid	
		36	PassportNumber	
		37	SafetyCard	
		38	CTOCCDesc	
		39	EmployeeNo	
		40	aryPATCF[10]	
	*/
	s current=$p(hiddenFlag,"^",1 )      //On
	s regoflag=$p(hiddenFlag,"^",2 )     //On
	s MRType=$p(hiddenFlag,"^",3 )
	s ageString=$p(hiddenFlag,"^",4 )    //objage.value+"|"+objagetype.value
	s age=+$p(ageString,"|",1)
	s ageType=$p(ageString,"|",2)
	s exact=$p(hiddenFlag,"^",5 )        //On
	s DVANumber=$p(hiddenFlag,"^",6 )
	s secgrp=$p(hiddenFlag,"^",7 )
	s allnames=$p(hiddenFlag,"^",8 )     //On
	s config1=$p(hiddenFlag,"^",9 )      //aryPATCF[1]="Y"  On 
	s SelHospital=$p(hiddenFlag,"^",10)
	s SelAdmissionType=$p(hiddenFlag,"^",11)
	s VisitStatus=$p(hiddenFlag,"^",12)
	s AdmDateFrom=$p(hiddenFlag,"^",13)
	s admToDate=$p(hiddenFlag,"^",14)
	s AdmDoc=$p(hiddenFlag,"^",15)
	s AdmLoc=$p(hiddenFlag,"^",16)
	s AdmRespUnit=$p(hiddenFlag,"^",17)
	s AdmWard=$p(hiddenFlag,"^",18)
	s ExpAdmDateFrom=$p(hiddenFlag,"^",19)
	s ExpAdmDateTo=$p(hiddenFlag,"^",20)
	s SelBookingType=$p(hiddenFlag,"^",21)
	s AdmissionPoint=$p(hiddenFlag,"^",22)
	s SignificantFacility=$p(hiddenFlag,"^",23)
	s CurrAppts=$p(hiddenFlag,"^",24)
	s AdmDateFrom2=$p(hiddenFlag,"^",25)
	s AdmDateTo2=$p(hiddenFlag,"^",26)
	s SelAdmHospital=$p(hiddenFlag,"^",27)
	s GroupNo=$p(hiddenFlag,"^",28)
	//s null=$p(hiddenFlag,"^",29)          //js未赋值
	//s null=$p(hiddenFlag,"^",30)          //js未赋值
	s PENSTYPEDesc=$p(hiddenFlag,"^",31)
	s name4=$p(hiddenFlag,"^",32)
	//s soundex=$p(hiddenFlag,"^",33)        //On  与传入参数重复
	s mobile=$p(hiddenFlag,"^",34)
	s ziprowid=$p(hiddenFlag,"^",35)
	s PassportNumber=$p(hiddenFlag,"^",36)
	s SafetyCard=$p(hiddenFlag,"^",37)
	s CTOCCDesc=$p(hiddenFlag,"^",38)
	s EmployeeNo=$p(hiddenFlag,"^",39)
	s config10=$p(hiddenFlag,"^",40)   //aryPATCF[10]
		
	s MaxPerson=$g(^PAPER(0))
	;$ZBITSTR size:The integer must be in the range 1 to 262,128 bits (32766 x 8).
	s MaxPerson=100000
	s PersonBitString=$zbitstr(MaxPerson,0)
	s EpisodeBitString=$zbitstr(MaxPerson,0)
	
	//s FlagOut=0,PatientID=""
	s sqlstr=" PAPMI_RowId as PatientID from PA_PatMas,PA_Person where PAPMI_RowId=PAPER_RowId"
	s admsqlstr="select distinct PAADM_PAPMI_DR as PatientID from PA_Adm where 1=1"
	
	s patientwherestr=..BuildCondition()         //构造基本信息的查询  暂不包含soundex,BillNo,***SSN,hiddenFlag
	//EpisodeNo,SelHospital,SelAdmissionType,VisitStatus,AdmDateFrom,admToDate,AdmDoc,AdmLoc,AdmWard,,,,,,,
	s episodewherestr=..BuildPaadmCondition()    //构造就诊信息相关查询
	
	if (patientwherestr="")&(episodewherestr=""){
		s sqlstr= "select top 1000 "_ sqlstr
	}
	else{
		s sqlstr= "select "_ sqlstr
	}
	//s PatientIDs=",",PatientID=""
	s patFlag=0,episodeFlag=0
	k ^||Temp($J,"PAPMIFind"),^||Temp($J,"PAADMPAPMIFind"),^||Temp($J,"Find")
	//根据基本信息查询
	if (episodewherestr="")||(patientwherestr'=""){
		s patFlag=1
		s sqlstr=sqlstr_patientwherestr_" order by PatientID"
		;20140328
		;如果查询条件只有一个，就不用连表查询。
		;例如: 用病人名字查询时，连表查询100万条记录要13秒多,如果单表查询就不到1ms.
		If ($L(patientwherestr," and ")=2){
			Set condItem = $P(patientwherestr," and ",2)
			If (condItem [ "PAPMI_"){
				S sqlstr = "SELECT PAPMI_RowId as PatientID from PA_PatMas where "_condItem _" order by PatientID"
			}
			if (condItem [ "PAPER_"){
				S sqlstr = "select PAPER_RowId as PatientID from PA_Person where "_condItem_"  order by PatientID"
			}
		}
		s rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
		s ^DHCUpgrade("Upgrade","Finds","sqlstr")=sqlstr
		s sc = rset.Prepare(sqlstr)
		s sc=rset.Execute()
		while rset.%Next(){
			set papmi=+rset.Data("PatientID")
			s ^||Temp($J,"PAPMIFind",papmi)=""
	       
			;s PersonBitString=$zbitset(PersonBitString,papmi,1)
		}
		;s ^Temp("Upgrade","Find11")=$zbitcount(PersonBitString)
	}
	
	//根据就诊信息查询
	if episodewherestr'=""{
		s episodeFlag=1
		s admsqlstr=admsqlstr_episodewherestr_" order by PatientID"
		s ^Temp("Upgrade","Finds","admsqlstr")=admsqlstr
		s rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
		s sc = rset.Prepare(admsqlstr)
		s sc=rset.Execute()
		while rset.%Next(){
			set papmi=+rset.Data("PatientID")
			s ^||Temp($J,"PAADMPAPMIFind",papmi)=""
			;s EpisodeBitString=$zbitset(EpisodeBitString,papmi,1)
			;s $Bit(EpisodeBitString,papmi)=1
		}
		;s ^Temp("Upgrade","Find22")=$zbitcount(EpisodeBitString)
	}
	
	//比较基本信息查询后就诊信息查询后的结果
	quit:('patFlag)&('episodeFlag) $$$OK
	
	if patFlag&episodeFlag {
		s papmi="" for {
			s papmi=$O(^||Temp($J,"PAPMIFind",papmi))
			Quit:papmi=""
			if $d(^||Temp($J,"PAADMPAPMIFind",papmi)) s ^||Temp($J,"Find",papmi)=""
		}
	}elseif (patFlag) {
		m ^||Temp($J,"Find")=^||Temp($J,"PAPMIFind")
	}elseif episodeFlag{
		m ^||Temp($J,"Find")=^||Temp($J,"PAADMPAPMIFind")
	}
	
	s PatientID="" for {
		s PatientID=$O(^||Temp($J,"Find",PatientID))
		Q:PatientID=""
		d buildFindData
		Q:papmi=""
	}

	/*
	if patFlag&episodeFlag {s papmibit=$zbitand(PersonBitString,EpisodeBitString)}
	elseif patFlag{s papmibit=PersonBitString}
	elseif episodeFlag{s papmibit=EpisodeBitString}
	else{}
	//if (patientwherestr=""){s papmibit=EpisodeBitString s ^Temp("Upgrade","Find41")=""}
	//if (episodewherestr=""){s papmibit=PersonBitString s ^Temp("Upgrade","Find42")=""}
	//else {s papmibit=$zbitand(PersonBitString,EpisodeBitString) s ^Temp("Upgrade","Find43")=""}
	for pos=1:0 {
	      s pos=$ZBITFIND(papmibit,1,pos) 
	      q:'pos
	      //发现ZBITFIND后的pos是 位置+1
	      s PatientID=+pos-1
	      d buildFindData
	}
	*/
	
	/*
	for pos=1:1:$zbitlen(papmibit){
		continue:'$zbitget(papmibit,pos)
		s PatientID=+pos
		s ^Temp("Upgrade","Find3",PatientID)=pos
		d buildFindData
	}*/
	
	//^PAPERi("Prov-Birth",{PAPER_Province_Birth_DR},{PAPER_RowId})  //ProvOB -> CT_Province 出生地
	//^PAPERi("DVA",$$ALPHAUP({PAPMI_DVAnumber}),{PAPMI_RowId})   //DVANumber 身份证号
	
	q $$$OK
	
	
buildFindData
	//papmi
	//set objPerson=##class(User.PAPerson).%New()
	//s ^Temp("Upgrade","FindExecute","papmi")=PatientID
	set objPerson=##class(User.PAPerson).%OpenId(PatientID)
	set objPatMas=##class(User.PAPatMas).%OpenId(PatientID)
	s ^Temp("Upgrade","FindExecute","objPerson")=objPerson
	quit:'$IsObject(objPerson)
	quit:'$IsObject(objPatMas)
	
	
	//基本信息相关条件判断
	//ageString,exact,allnames,name4,mobile,ziprowid,PAPER_EmployeeNo,,,,,,,,,,,,,,
	q:(ageType="Y")&&(objPerson.PAPERAgeYr'=age)
	q:(ageType="M")&&(objPerson.PAPERAgeMth'=age)
	q:(ageType="D")&&(objPerson.PAPERAgeDay'=age)
	
	q:(name4'="")&&(objPerson.PAPERName4'=name4)
	q:(mobile'="")&&(objPerson.PAPERMobPhone'=mobile)
	q:(ziprowid'="")&&(objPerson.PAPERZipDR.%Id()'=ziprowid)
	q:(EmployeeNo'="")&&(objPerson.PAPEREmployeeNo'=EmployeeNo)
	
	set data=$lb()
	set $li(data,1)=objPerson.%Id()            //ID
	set $li(data,2)=objPatMas.PAPMINo           //RegistrationNo
	set $li(data,3)=objPerson.PAPERName_","_objPerson.PAPERName2        //Name
	set $li(data,4)=objPerson.PAPERName2       //Name2
	set $li(data,5)=objPerson.PAPERName3       //Name3
	set $li(data,6)=objPerson.PAPERDob         //Dob
	//set $li(data,6)=##class(websys.Conversions).DateLogicalToHtml(objPerson.PAPERDob) //Dob
	set $li(data,7)=objPerson.PAPERSexDR.CTSEXDesc         //Sex 
	set $li(data,8)=objPerson.PAPERTelH         //Tel                       
	set $li(data,9)=objPatMas.PAPMIMedicare         //Medicare  PAPMI_Medicare                 
	set $li(data,10)=objPerson.PAPERStNameLine1         //AddressLine1    从原环境中查询发现调用的是此字段 PAPER_StNameLine1         
	
	/**/
	set $li(data,11)=objPerson.PAPERCityCodeDR.CTCITDesc         //City    PAPER_CityCode_DR	                   
	set $li(data,12)=objPerson.PAPERZipDR.CTZIPDesc         //Zip          PAPER_Zip_DR             
	set $li(data,13)=objPerson.PAPERMaritalDR.CTMARDesc         //Marital     PAPER_Marital_DR              
	set $li(data,14)=objPerson.PAPERDeceased         //Deceased       PAPER_Deceased           
	set $li(data,15)=objPerson.PAPERAddress2        //Address2                  
	//set $li(data,16)="Y"         //edob                      
	//set $li(data,17)=objPerson.PAPERDob         //mergereg                  
	set $li(data,18)=objPatMas.PAPMIDVAnumber         //DVA    PAPMI_DVAnumber                     
	set $li(data,19)=objPerson.PAPERName4         //Name4                     
	set $li(data,20)=objPerson.PAPERName5         //Name5                     
	set $li(data,21)=objPerson.PAPERName6         //Name6                     
	set $li(data,22)=objPerson.PAPERName7         //Name7                     
	set $li(data,23)=objPerson.PAPERName8         //Name8                     
	set $li(data,24)=objPerson.PAPERAddress2         //PAPERAddress2             
	set $li(data,25)=objPerson.%Id()         //PAPERID                   
	set $li(data,26)=objPatMas.PAPMIVIPFlag         //VIPStatus    PAPMI_VIPFlag             
	set $li(data,27)=objPerson.PAPEROccupationDR.CTOCCDesc         //Occupation PAPER_Occupation_DR               
	set $li(data,28)=objPerson.PAPEREmployeeNo         //EmplNo      PAPER_EmployeeNo              
	//set $li(data,29)=objPerson.PAPERPreferredContactMethod         //PreferredContactMethod    PAPER_PreferredContactMethod
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q $$$OK
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEXTERNALClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEXTERNALFetch ]
{
}

ClassMethod FindEXTERNALExecute(ByRef QHandle As %Library.Binary, Registration As %String = "", PAPERName As %String = "", PAPERName2 As %String = "", PAPERName3 As %String = "", CTSEXDesc As %String = "", PAPERDob As %Date = "", QueryType As %String = "", Continue As %String = "", Interface1 As %String = "", Interface2 As %String = "", CHINo As %String = "") As %Library.Status
{
}

ClassMethod FindEXTERNALFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEXTERNALExecute ]
{
}

/// Purpose - To return a string of 0 and 1 respresenting if there is information behind the four links.  The pieces 
/// are as follows - 
/// 1 - Contact Details
/// 2 - Other Addresses
/// 3 - Alias
/// 4 - Patient Alert
/// 
/// Author - John Hart
/// modified - JW
ClassMethod FindIfLinksDataPAPersonEdit(PatientID As %Library.String)
{
	quit 0
}

ClassMethod FindInEpisodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindInEpisodeFetch ]
{
}

ClassMethod FindInEpisodeExecute(ByRef QHandle As %Library.Binary, RegoString As %Library.String, Unit As %Library.String, Ward As %Library.String, Gp As %Library.String, admtype As %Library.String, totD As %Library.Status, TGP As %Library.String) As %Library.Status
{
}

ClassMethod FindInEpisodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindInEpisodeExecute ]
{
}

/// A function to produce a sting of the Address, Address 2, Suburb, Postcode, State
/// and Home Phone number of the patient delimited by "^".
/// 23670
/// The string is used by PANok.Edit to allow population of address fields if a check box is ticked
ClassMethod GetAddress(id As %Library.String) As %Library.String
{
	n obj
	s addr=""
	s obj = ##class(User.PAPerson).%OpenId(id,0)
	if $IsObject(obj) s addr=obj.PAPERNokAddress1
	q addr
}

ClassMethod GetAddressDetails(PatientID As %String = "") As %String
{
}

/// JW: do not use this method - to be deleted.
/// JW: use calculateage to return full years, or calculateageunits for display of age
ClassMethod GetAge(PatientID As %String, param As %String = "") As %String
{
	set Dob = $p(^PAPER(PatientID,"ALL"),"^",6)
	set EstAgeYear = $p(^PAPER(PatientID,"ALL"),"^",15)
	set EstAgeMonth = $p(^PAPER(PatientID,"ALL"),"^",16)
	set EstAgeTmStmp = $p(^PAPER(PatientID,"ALL"),"^",17)
	set age = $$CalAge^at182(Dob,+$h,EstAgeMonth,EstAgeYear,EstAgeTmStmp)
	quit age
}

/// by wuqk 2011-06-17
ClassMethod GetFeedbackConsentData(PatientID As %Library.String) As %Library.String
{
	n obj,ret
	set obj=##class(User.PAPerson).%OpenId(PatientID)
	quit:'$IsObject(obj) ""
	set ret=obj.PAPERFeedBackConsent
	set obj=""
	quit ret
}

/// KM 12-Aug-2002: This method was created for putting details from PAPerson
/// and PAPatmas into an array so that they can be accessed from methods associated
/// with the floorplan and patients lists.
/// 
/// If you add to this list so that you can use it in other places then comment
/// what you have added and why so that if it all starts to get too heavy it can be split
/// *** NB: All array items created here should begin with PAPER ***
/// 
/// do not new 't', fetch only if it doesn't already exist
/// 
/// dynamic age calculation - 0-14days, 2-13 wks, 4-23 mnths, 2+ yrs
/// JW:now done as parameter default 2 weeks, 3 months, 5 years
ClassMethod GetArrayDetails(PatientID As %Library.String, ByRef ARY As %Library.String)
{
}

/// This returns description,id,code (this is to be consitent with lookups)
/// 
/// TN:1-May-2002
/// overwrite generic code as it was not meaningful for this class
/// returns exactly the same as the PAPatMas class
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod GetDVANum(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetDetails(PatientID As %Library.String)
{
	n (PatientID,%request)
	s obj=##class(User.PAPerson).%OpenId(PatientID)
	if $ISObject(obj){
		s PAPERDeceasedDate = obj.PAPERDeceasedDate
		s PAPERDeceasedTime = obj.PAPERDeceasedTime
		if (PAPERDeceasedDate'=""){ //wanghc 日期格式不对 2012-11-30
			s PAPERDeceasedDate = ##class(websys.Conversions).DateLogicalToHtml(PAPERDeceasedDate)
			s PAPERDeceasedTime = ##class(websys.Conversions).TimeLogicalToHtml(PAPERDeceasedTime)
		}
		d %request.Set("PAPERDeceasedDate",PAPERDeceasedDate)
		d %request.Set("PAPERDeceasedTime",PAPERDeceasedTime)
		 
		;d %request.Set("PAPERDeceasedDate",$s(obj.PAPERDeceasedDate'="":$ZD(obj.PAPERDeceasedDate),1:""))
		;d %request.Set("PAPERDeceasedTime",$s(obj.PAPERDeceasedTime'="":$ZT(obj.PAPERDeceasedTime),1:""))
	}
}

ClassMethod GetDonateOrgan(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetLocalDoctor(PatID As %Library.String, ByRef docid As %Library.String = "", ByRef doccode As %Library.String = "", ByRef clinicid As %Library.String = "", ByRef clncode As %Library.String = "", ByRef clnaddr As %Library.String = "", ByRef clnprovno As %Library.String = "", ByRef clncity As %Library.String = "", ByRef clnphone As %Library.String = "", ByRef clndesc As %Library.String = "", ByRef clnzip As %Library.String = "", ByRef fulladdress As %Library.String = "") As %Library.String
{
}

ClassMethod GetLocalDoctorWebDetails(ID As %Library.String)
{
}

/// KM 18-Sept-2001: Copied this routine from web.PAPerson.FindFetch so that it can be 
/// re-used in web.PAPatMas.FindWithIconsFetch
/// 
ClassMethod GetMergeRego(pat As %Library.String) As %Library.String
{
	quit ""
}

/// BC 14-Jan-2002
/// 
/// This is a simple routine to return the name of the patient to be unmerged from the present patient
ClassMethod GetNameOfMergedPat(ID As %Library.String) As %Library.String
{
}

/// KM 24-Oct-2001: Created to be called from component item gotAlias in component PAPerson.Banner.
ClassMethod GetOthernameAlias(pat As %Library.String) As %Library.String
{
}

/// by wuqk 2011-06-17 未实现
ClassMethod GetPatientOutstanding(PatientID As %String) As %String
{
	quit "0"
}

ClassMethod GetPrefLanguage(PatID As %Library.String) As %Library.String
{
}

ClassMethod GetPrevHACCEligible(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetReligion(PatID As %Library.String) As %Library.String
{
}

/// by xuqy 2011-07-26
ClassMethod GetSex(PatientID As %String) As %String
{
	q:PatientID="" ""
 	s sexdr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
 	q:sexdr="" ""
 	s sex=$p($g(^CT("SEX",+sexdr)),"^",2)
 	q sex
}

/// KM 18-Sept-2001: Copied this routine from web.PAPerson.FindFetch so that it can be 
/// re-used in web.PAPatMas.FindWithIconsFetch
ClassMethod GetSurnameAlias(pat As %Library.String) As %Library.String
{
}

/// KM 24-Oct-2001: Created to be called from component item gotAlias in component PAPerson.Banner.
ClassMethod GotSurnameOrOthernameAlias(PatientID As %Library.String) As %Library.String
{
}

/// Removed from websysSave
ClassMethod InsertPerson(id As %Library.String)
{
}

/// KM 12-Aug-2002: Created for showing birthday Icon on Icon Profiles.
ClassMethod IsBirthday(dob As %Library.String, IncludeDaysBefore As %Library.String = 0, dead As %Library.String = "N") As %Library.Integer
{
}

ClassMethod IsPatientCancerRegistered(PatientID As %Library.String)
{
}

ClassMethod MarkAsDeceased(id As %String, date As %String, time As %String, place As %String = "", notifiedby As %String = "")
{
}

ClassMethod PatientDeceased(PatientID As %Library.String = "") As %Library.String
{
}

ClassMethod PrintLabelUnknown(compref As %Library.String, id As %Library.String)
{
}

ClassMethod ReverseDeceased(id As %Library.String) As %Library.String
{
	if $g(id)="" quit ""
	if $g(^PAPER(id,"ALL"))="" quit ""
	
	s $p(^PAPER(id,"ALL"),"^",12)=""	;PAPER_Deceased
	s $p(^PAPER(id,"ALL"),"^",13)=""	;PAPER_DeceasedDate
	s $p(^PAPER(id,"ALL"),"^",8)=""		;PAPER_DeceasedTime
    ;PAADM_VisitStatus
	;s mrAdmId=##Class(web.PAAdm).GetMRAdm($g(EpisodeID)) 
	;i disConDesc="" s disconId=""
	;e  s disconId=$o(^PAC("DISCON",0,"Desc",disConDesc,""))
	;&sql(update MR_Adm set MRADM_ConditAtDisch_DR=:disconId	where MRADM_RowId=:mrAdmId)		
	quit ""
}

ClassMethod UpdateFamilyDocAndClinic(id As %Library.String, DoctorID As %Library.String, DocClinicID As %Library.String)
{
}

ClassMethod ValidateQASFields(QASPROVDesc As %Library.String = "", QASCTCITDesc As %Library.String = "", QASCTZIPCode As %Library.String = "", QASHealthCareArea As %Library.String = "", PROVDesc As %Library.String = "", CTCITDesc As %Library.String = "", CTZIPCode As %Library.String = "", QASHealthCareRegion As %Library.String = "") As %Library.Boolean
{
}

ClassMethod alias(pat As %Library.String) As %Library.String
{
}

/// JW: used in
/// 
/// PAPerson.Edit PAPERAge 
/// web.PAPerson:GetArrayDetails
/// web.PAPerson:calculateAgeUnitsShow
/// by wuqk 2011-06-21 used in PAAdm.Edit Component
/// 需要根据param判断输出，测试发现param=Y,M 是输出的都是年，param=D时输出N
ClassMethod calculateAge(PatientID As %String, param As %String = "") As %String
{
	n Age,comp,unitsArray,DOB,CalDate,AgeYear,AgeMonth,AgeDay
	s Age=""
	quit:PatientID="" Age
	//s ^Temp("Upgrade","calculateAgeUnits","PatientID")=PatientID
	//s comp=##Class(websys.Component).OpenName("PAPerson.Banner")
 	//i comp d comp.LoadTrans(),comp.%Close()
 	//s unitsArray=t("AgeFullTrans")
 	s DOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	q:DOB="" Age
	i DOB["/" s DOB=$$$zdh(DOB,4)
	i DOB["-" s DOB=$$$zdh(DOB,3)
	s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	quit:param="Y" AgeYear
	quit:param="M" AgeYear
	quit "N"
}

/// ab 17.06.02 - calculate age units (years,months,weeks,days) from dob
/// 
/// JW: used in 
/// 
/// PAPerson.Edit AgeUnits 
/// PAPerson.Edit AgeDynamic
/// web.PAPerson:GetArrayDetails
/// by wuqk 2011-06-17
ClassMethod calculateAgeUnits(PatientID As %String = "", param As %String = "0") As %String
{
	n units,Age,comp,unitsArray,DOB,CalDate,AgeYear,AgeMonth,AgeDay
	s units=""
	quit:PatientID="" units
	//s ^Temp("Upgrade","calculateAgeUnits","PatientID")=PatientID
	s comp=##Class(websys.Component).OpenName("PAPerson.Banner")
 	i comp d comp.LoadTrans(),comp.%Close()
 	s unitsArray=t("AgeFullTrans")
 	s DOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	q:DOB="" units
	i DOB["/" s DOB=$$$zdh(DOB,4)
	i DOB["-" s DOB=$$$zdh(DOB,3)
	s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	i AgeYear'="" s units=$p(unitsArray,",",1)
	e  i AgeMonth'="" s units=$p(unitsArray,",",2)
	e  i AgeDay'="" s units=$p(unitsArray,",",3)
	quit units
}

/// cjb 27/02/2006 56793 - moved this code from the calculateAgeUnits method to allow it to be called without a PatientID (for NOK)
ClassMethod calculateAgeUnitsFromDates(dob As %String = "", agedate As %String = "", param As %String = "0") As %String
{
}

/// JW: used in
/// 
/// web.PAPerson:GetArrayDetails
/// zhouzq 2011.05.31.  PAPerson.Banner
/// 从原版测试应该调用了组件翻译,但不知如何使用  
ClassMethod calculateAgeUnitsShow(PatientID As %String) As %String
{
	s AgeYear=""
	if PatientID'="" {
		s comp=##Class(websys.Component).OpenName("PAPerson.Banner")
	 	i comp d comp.LoadTrans(),comp.%Close()
	 	s DOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
		q:DOB="" ""
		i DOB["/" s DOB=$$$zdh(DOB,4)
		i DOB["-" s DOB=$$$zdh(DOB,3)
		s CalDate=+$h
		s Age=$$CalAge^at182(DOB,CalDate,"","","")
		s AgeYear=$P(Age,"|",12)
		s AgeMonth=$P(Age,"|",13)
		s AgeDay=$P(Age,"|",14)
		If ((AgeYear'>0)&&(AgeMonth'>0)){
			Set AgeYear = AgeDay_"日"
		}elseif(AgeYear'>0){
			Set AgeYear = AgeMonth_"月"
		}else{
			Set AgeYear = AgeYear_"岁"
		}
		;s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	}
	if (##class(websys.Conversions).IsValidMethodName("web.DHCBillInterface","GetPapmiAge")){
		Set age = ##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
		Quit age
	}
	Q AgeYear
}

/// Log 49660 BoC calculate full age Y-M-D
/// by wuqk 2011-07-12
ClassMethod calculateFullAgeShow(PatientID As %String) As %String
{
	s comp=##Class(websys.Component).OpenName("PAPerson.Banner")
 	i comp d comp.LoadTrans(),comp.%Close()
	s DOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	q:DOB="" ""
	i DOB["/" s DOB=$$$zdh(DOB,4)
	i DOB["-" s DOB=$$$zdh(DOB,3)
	s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=AgeYear_"-"_AgeMonth_"-"_AgeDay
	Q AgeDesc
}

ClassMethod calculateFullAge(PatientID As %String = "", param As %String = "0") As %String
{
}

ClassMethod calculateFullAgeFromDates(dob As %String = "", agedate As %String = "", param As %String = "0") As %String
{
}

/// KM 21-Sep-2001: Called From PAPerson.Find to set variables if Only one match is found
/// by wuqk 2011-06-21 
ClassMethod checkFindUnique(Registration As %String, PAPERName As %String, PAPERName2 As %String, PAPERName3 As %String, NationalID As %String, SSN As %String, CTSEXDesc As %String, GovtCardNo As %String, ProvOB As %String, MedicalRecordNo As %String, BillNo As %String, EpisodeNo As %String, PAPERDob As %Date, soundex As %String, Phone As %String, hiddenFlag As %String)
{
	//精确定位到患者后，转向PAADM.List 页面
	n rowid,ipnoLength
	s rowid=$o(^CF("PATCF",""))
    s ipnoLength = $p(^CF("PATCF",rowid,3),"^",5)
	while $length(Registration)<ipnoLength
	{
		s Registration="0"_Registration
	}
	set PatientID=..getUniquePat(Registration, PAPERName, PAPERName2, PAPERName3, NationalID, SSN, CTSEXDesc, GovtCardNo, ProvOB, MedicalRecordNo, BillNo, EpisodeNo, PAPERDob, soundex, Phone, hiddenFlag)
	set:PatientID'="" %request.Data("FirstPatientID",1)=PatientID
	//m ^Temp(index,"checkFindUnique","%req")=%request.Data
	//s %request.Data("FirstPatientID",1)=107703
	quit
}

/// Called From custom PAPerson.Find.js for site QP. To return Patient Id if only one match is found.
/// by wuqk 2011-06-21
/// by wuqk 2011-06-22 未判断hiddenFlag；soundex、BillNo、SSN
ClassMethod getUniquePat(Registration As %String, PAPERName As %String, PAPERName2 As %String, PAPERName3 As %String, NationalID As %String, SSN As %String, CTSEXDesc As %String, GovtCardNo As %String, ProvOB As %String, MedicalRecordNo As %String, BillNo As %String, EpisodeNo As %String, PAPERDob As %Date, soundex As %String, Phone As %String, hiddenFlag As %String) As %String
{
	n PatientID,FlagOut,TempAlias,sqlStr,wherestr,PatientIDs
	//s FlagOut=0,PatientID=""
	s sqlstr="select PAPMI_RowId as PatientID from PA_PatMas,PA_Person where PAPMI_RowId=PAPER_RowId"
	s wherestr=""
	s wherestr=..BuildCondition()
	quit:wherestr="" ""
	
	n rset,sc
	s PatientIDs=",",PatientID=""
	s sqlstr=sqlstr_wherestr_" order by PatientID"
	s ^Temp("Upgrade","getUniquePat","sql")=sqlstr
	s rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
	s sc = rset.Prepare(sqlstr)
	s sc=rset.Execute()
	s index=1
	while rset.%Next(){
		s ^Temp("Upgrade","getUniquePat",index)=rset.Data("PatientID")
		set PatientIDs=PatientIDs_rset.Data("PatientID")_","
		quit:$l(PatientIDs)>20000
	}
	
	//^PAADMi("No",$$ALPHAUP({PAADM_ADMNo}),{PAADM_RowID})
	if EpisodeNo'="" {
		s FlagOut=0
		s TempAlias=$zu(28,EpisodeNo,6)
		s:'$d(^PAADMi("No",TempAlias)) FlagOut=1
		if FlagOut=0{
			s tmpEpisodeID=$o(^PAADMi("No",TempAlias,0))
			s tmpPatientID=$p($g(^PAADM(tmpEpisodeID)),"^",1)
		}
		
		if PatientIDs'=""{
			s:PatientIDs[(","_tmpPatientID_",") PatientID=tmpPatientID
		}
		else{s PatientID=tmpPatientID}
	}
	
	
	if PatientID=""{
		if $l(PatientIDs,",")=3{s PatientID=$p(PatientIDs,",",2)}
	}
	/*
	if soundex'="" {}
	if BillNo'="" {}
	
	*/
	
	if hiddenFlag'="" {}
	quit PatientID
	
	/*
		//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	if Registration'="" {
		s TempAlias=$zu(28,Registration,6)
		s:'$d(^PAPERi("PAPMI_PatNo",TempAlias)) FlagOut=1
		if FlagOut=0{s PatientID=$o(^PAPERi("PAPMI_PatNo",TempAlias,0))}
	}
	quit:FlagOut ""
	
		//^PAPERi("PAPER_PatName",$$ALPHAUP({PAPER_Name}),{PAPER_RowId})
	if PAPERName'="" {
		if PatientID'=""{
			s TempAlias=##class(User.PAPerson).%OpenId(PatientID).PAPERName
			s:TempAlias'[PAPERName FlagOut=1
		}
		else{
			s TempAlias=$zu(28,PAPERName,6)
			s:'$d(^PAPERi("PAPER_PatName",TempAlias)) FlagOut=1
			if FlagOut=0{s PatientID=$o(^PAPERi("PAPER_PatName",TempAlias,0))}
		}
	}
	quit:FlagOut ""
	
	if PAPERName2'="" {
		if PatientID'=""{
			s TempAlias=##class(User.PAPerson).%OpenId(PatientID).PAPERName2
			s:TempAlias'[PAPERName2 FlagOut=1
		}
		else{
			s TempAlias=$zu(28,PAPERName2,6)
			s:'$d(^PAPERi("PAPER_PatName",TempAlias)) FlagOut=1
			if FlagOut=0{s PatientID=$o(^PAPERi("PAPER_PatName",TempAlias,0))}
		}
	}
	quit:FlagOut ""
	
	if PAPERName3'="" {
		if PatientID'=""{
			s TempAlias=##class(User.PAPerson).%OpenId(PatientID).PAPERName3
			s:TempAlias'[PAPERName3 FlagOut=1
		}
		else{
			s TempAlias=$zu(28,PAPERName3,6)
			s:'$d(^PAPERi("PAPER_PatName",TempAlias)) FlagOut=1
			if FlagOut=0{s PatientID=$o(^PAPERi("PAPER_PatName",TempAlias,0))}
		}
	}
	quit:FlagOut ""
	
	if NationalID'="" {}
	if SSN'="" {}
	if CTSEXDesc'="" {}
	if GovtCardNo'="" {}
	//^PAPERi("Prov-Birth",{PAPER_Province_Birth_DR},{PAPER_RowId})  //ProvOB -> CT_Province 出生地
	if ProvOB'="" {}
	if MedicalRecordNo'="" {}
	if BillNo'="" {}
	
		//^PAADMi("No",$$ALPHAUP({PAADM_ADMNo}),{PAADM_RowID})
	if EpisodeNo'="" {
		s TempAlias=$zu(28,EpisodeNo,6)
		s:'$d(^PAADMi("No",TempAlias)) FlagOut=1
		if FlagOut=0{
			s tmpEpisodeID=$o(^PAADMi("No",TempAlias,0))
			s tmpPatientID=$p($g(^PAADM(tmpEpisodeID)),"^",1)
		}
		
		if PatientID'=""{
			s:PatientID'=tmpPatientID FlagOut=1
		}
		else{s PatientID=tmpPatientID}
	}
	quit:FlagOut ""
	
		//^PAPERi("DOB2",{PAPER_Dob},{PAPER_RowId})
	if PAPERDob'="" {}
	if soundex'="" {}
	
		//^PAPERi("Phone",$$ALPHAUP({PAPER_TelH})_"Z",{PAPER_RowId})
	if Phone'="" {}
	*/
}

/// add by wuqk 2011-06-22 构造基本信息查询条件
/// for Find & getUniquePat
ClassMethod BuildCondition() [ Private ]
{
	s wherestr=""
	//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	if Registration'="" {
		s TempAlias=$zu(28,Registration,6)
		s wherestr=" and PAPMI_No='"_TempAlias_"'"
	}
	
	//^PAPERi("PAPER_PatName",$$ALPHAUP({PAPER_Name}),{PAPER_RowId})
	if PAPERName'="" {
		s TempAlias=$zu(28,PAPERName,6)
		s wherestr=wherestr_" and PAPER_Name %STARTSWITH '"_TempAlias_"'"
		
	}
	
	//^PAPERi("PAPER_PatName",$$ALPHAUP({PAPER_Name2}),{PAPER_RowId})
	if PAPERName2'="" {
		s TempAlias=$zu(28,PAPERName2,6)
		s wherestr=wherestr_" and PAPER_Name2 %STARTSWITH '"_TempAlias_"'"
	}
	
	if PAPERName3'="" {
		s TempAlias=$zu(28,PAPERName3,6)
		s wherestr=wherestr_" and PAPER_Name3 %STARTSWITH '"_TempAlias_"'"
	}
	
	// PAPER_Nation_DR
	if NationalID'="" {
		s wherestr=wherestr_" and PAPER_Nation_DR="_NationalID		
	}
	
	// 匹配？
	if SSN'="" {}
	
	// PAPMI_Sex_DR->CTSEX_Desc
	if CTSEXDesc'="" {
		s wherestr=wherestr_" and PAPMI_Sex_DR->CTSEX_Desc = '"_CTSEXDesc_"'"
	}
	
	// PAPER_GovernCardNo
	if GovtCardNo'="" {
		s wherestr=wherestr_" and PAPER_GovernCardNo = '"_GovtCardNo_"'"
	}
	
	//^PAPERi("Prov-Birth",{PAPER_Province_Birth_DR},{PAPER_RowId})  //ProvOB -> CT_Province 出生地
	if ProvOB'="" {
		s wherestr=wherestr_" and PAPER_Province_Birth_DR ="_ProvOB	
	}
	
	// PAPMI_Medicare ??
	if MedicalRecordNo'="" {
		s wherestr=wherestr_" and PAPMI_Medicare = '"_MedicalRecordNo_"'"
	}
	
	//^PAPERi("DOB2",{PAPER_Dob},{PAPER_RowId})
	if PAPERDob'="" {
		s wherestr=wherestr_" and PAPER_Dob = '"_PAPERDob_"'"
	}
	
	//^PAPERi("Phone",$$ALPHAUP({PAPER_TelH})_"Z",{PAPER_RowId})
	if Phone'="" {
		s TempAlias=$zu(28,Phone,6)
		s wherestr=wherestr_" and PAPER_TelH = '"_TempAlias_"'"
	}
	quit wherestr
}

/// add by wuqk 2011-06-22 构造就诊信息查询条件
/// for Find 
ClassMethod BuildPaadmCondition()
{
	s wherestr=""
	// PAADM_ADMNo
	if EpisodeNo'=""{
		s TempAlias=$zu(28,EpisodeNo,6)
		s wherestr=" and PAADM_ADMNo = '"_TempAlias_"'"
	}
	
	// PAADM_Hospital_DR
	/*
	if SelHospital'=""{
		s wherestr=wherestr_" and PAADM_Hospital_DR->HOSP_Desc in '"_SelHospital_"'"
	}*/
	//原环境中未判断医院，是否在paadm中判断
	if SelHospital'=""{
		set hospCondition=""
		for index=1:1:$l(SelHospital,"|"){
			if $p(SelHospital,"|",index)'=""{
				set:hospCondition'="" hospCondition=hospCondition_" OR "
				set hospCondition=hospCondition_" (PAADM_Hospital_DR="_$p(SelHospital,"|",index)_")"
			}
		}
		set:hospCondition'="" wherestr=wherestr_" and ("_hospCondition_")"
	}
	
	// PAADM_Type
	if SelAdmissionType'=""{
		s wherestr=wherestr_" and '"_SelAdmissionType_"'[PAADM_Type"
	}
	
	// PAADM_VisitStatus
	if VisitStatus'=""{
		s wherestr=wherestr_" and '"_VisitStatus_"'=PAADM_VisitStatus"
	}
	
	// PAADM_AdmDate
	if AdmDateFrom'=""{
		s TempAlias=##class(websys.Conversions).DateHtmlToLogical(AdmDateFrom)
		s wherestr=wherestr_" and PAADM_AdmDate > "_(TempAlias-1)
	}
	
	// PAADM_AdmDate
	if admToDate'=""{
		s TempAlias=##class(websys.Conversions).DateHtmlToLogical(admToDate)
		s wherestr=wherestr_" and PAADM_AdmDate < "_(TempAlias+1)
	}
	
	// PAADM_AdmDocCodeDR
	if AdmDoc'=""{
		s wherestr=wherestr_" and PAADM_AdmDocCodeDR = "_AdmDoc
	}
	
	// PAADM_DepCode_DR
	if AdmLoc'=""{
		s wherestr=wherestr_" and PAADM_DepCode_DR = "_AdmLoc
	}
	
	// PAADM_CurrentWard_DR
	if AdmWard'=""{
		s wherestr=wherestr_" and PAADM_CurrentWard_DR = "_AdmWard
	}
	quit wherestr
}

/*
/// meto moved to PAAdm
ClassMethod checkRegEpisode(admtype As %Library.String, totD As %Library.String)
{
 n date1,time1,action1,dtot1,stype,ddtot1,dttot1
 s (date1,time1,action1,dtot1,stype,ddtot1,dttot1)=0
 
 d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM,PAAdm.BatchProcess")
 
 s action1=%request.Get("admtype")
 i action1="A" s stype="Discharge"
 i action1="D" s stype="Admission"
 s dtot1=%request.Get("totD")
 s ddtot1=$p(dtot1,",",1)
 s dttot1=$p(dtot1,",",2)
 s ddtot1=##Class(websys.Conversions).DateHtmlToLogical(ddtot1)
 s dttot1=##Class(websys.Conversions).TimeHtmlToLogical(dttot1)
 i ddtot1 d
 .i (ddtot1 > +$h)  d 
 ..i action1="A" d:msg msg.AddItem("E","" ,stype_"Date cannot be in the future",compid,"dischdate") s oktoupdate=0
 ..i action1="D" d:msg msg.AddItem("E","" ,stype_"Date cannot be in the future",compid,"admdate") s oktoupdate=0
 i ddtot1,dttot1 d
 .i (ddtot1 = +$h),(dttot1 > +$p($h,",",2)) d
 ..i action1="A" d:msg msg.AddItem("E","" ,stype_"Time cannot be in the future",compid,"dischtime") s oktoupdate=0
 ..i action1="D" d:msg msg.AddItem("E","" ,stype_"Time cannot be in the future",compid,"admtime") s oktoupdate=0
 
 q
}
*/
/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	s $zt="SaveError"
	s MotherPatientID=%request.Get("PatientID")
	s %request.Data("PatientID",1)=id
	if %request.Get("TWKFL")'="" {
	s workflow=##class(websys.WorkFlow).%OpenId(%request.Get("TWKFL"))
	s:$IsObject(workflow) workflowName=workflow.Name
	i (($g(workflowName)="Trak.Maternity.Baby")&(id'="")) {
		s EpisodeID=%request.Get("EpisodeID")
		;wanghc start 2012/9/6 不能只取最后一个,页面上有元素
		s BabyID=%request.Get("PAPERBabyDR")
		/*
		s BabyID=$g(%request.Data("delbabyId",1))
		//s:BabyID="" BabyID=^Temp("paperson.edit.csp","delbabyId")
			//^PAPRG({PA_Pregnancy.PREG_RowId},"DEL",{DEL_Childsub})
			//^PAPRGi("DEL_Adm_DR",{DEL_Adm_DR},{PA_Pregnancy.PREG_RowId},"DEL",{DEL_Childsub})
	   // ^PAPRG({PA_Pregnancy.PREG_RowId},"DEL",{PA_PregDelivery.DEL_Childsub},"BABY",{BABY_Childsub})
	   s PAPregnancyPREGRowId=$o(^PAPRGi("DEL_Adm_DR",EpisodeID,""))
	   s DELChildsub=$o(^PAPRGi("DEL_Adm_DR",EpisodeID,PAPregnancyPREGRowId,"DEL",""))
	   s BABYChildsub=$o(^PAPRG(PAPregnancyPREGRowId,"DEL",DELChildsub,"BABY",""))
	   s oldBABYChildsub=""
	   while(BABYChildsub'=""){
		     s oldBABYChildsub=BABYChildsub
		     s BABYChildsub=$o(^PAPRG(PAPregnancyPREGRowId,"DEL",DELChildsub,"BABY",BABYChildsub))
	
	   }
	   s:BabyID="" BabyID=PAPregnancyPREGRowId_"||"_DELChildsub_"||"_oldBABYChildsub
	   */
	   ;wanghc end 2012/9/6
	   
		//跳转到 Episode Edit 工作流 新建PAAdm
		s %request.Data("EpisodeID",1)=""
		s %request.Data("ID",1)=""
		//补充保存 PAPERMother 年龄 月 日
		i MotherPatientID'="" {
			s PatientObj=##class(User.PAPerson).%OpenId(id)
			d PatientObj.PAPERMotherDRSetObjectId(MotherPatientID)
			i $l(BabyID,"||")>2 {
				s PAPERDob = $P(^PAPRG(+BabyID,"DEL",$p(BabyID,"||",2),"BABY",$p(BabyID,"||",3)),"^",13)
				s PAPERBirthTime = $P(^PAPRG(+BabyID,"DEL",$p(BabyID,"||",2),"BABY",$p(BabyID,"||",3)),"^",49)
				s PatientObj.PAPERDob=PAPERDob
			}
			s PatientObj.PAPERAgeDay=0
			s PatientObj.PAPERAgeMth=0
			s PatientObj.PAPERAgeYr=0
			
			d PatientObj.%Save()
			s PatientObj=""
						
			s patmas=##class(User.PAPatMas).%OpenId(id)
			d patmas.PAPMIMotherDRSetObjectId(MotherPatientID)
			
			i $d(^PAPER(0,"CNT","I")) d
			.;s myMAXNo=^PAPER(0,"CNT","I") //最大登记号
			e  d
			.s myMAXNo=0
			s myMAXNo=$i(^PAPER(0,"CNT","I"))
			s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
			s myMAXNo=$e("0000000000000000000",1,myPatLen-$l(myMAXNo))_myMAXNo 
			
			;wanghc 2016-11-24 号段为13361001至13461001
			//dhc-app>s ^COUNT("CNTTYPE","BABY")="^前缀^后缀^数字长度^当前最大登记号^登记号上限值"
			//dhc-app>s ^COUNT("CNTTYPE","BABY")="^^^8^13361000^13461001"
			/*
			s myMAXNo=""
			s cnttype="BABY"
			IF 1 D 
			.L +^COUNT("CNTTYPE",cnttype)
			.s s1=$g(^COUNT("CNTTYPE",cnttype)),pref=$p(s1,"^",2),suf=$p(s1,"^",3)
			.s len=$p(s1,"^",4),cnt=$p(s1,"^",5),max=$p(s1,"^",6)
			.s cnt=cnt+1
			.if cnt>max d
			..l -^COUNT("CNTTYPE",cnttype)
			..quit
			.S $P(^COUNT("CNTTYPE",cnttype),"^",5)=cnt
			.L -^COUNT("CNTTYPE",cnttype)
			.s myMAXNo=pref_..LPAD1(cnt,"0",len)_suf
			*/
			s patmas.PAPMINo=myMAXNo
			s patmas.PAPMIIPNo=myMAXNo
			s patmas.PAPMIOPNo=myMAXNo
			s patmasSave=patmas.%Save()
			d patmas.%Close()
			s patmas=""
			;w ##class(web.DHCBillInterface).GetPapmiAge方法中用到,用来计算小孩子年龄
			if (##class(websys.Conversions).IsValidMethodName("web.DHCBillInterface","ISaveNewBabyDob")){
				d ##class(web.DHCBillInterface).ISaveNewBabyDob(id,PAPERDob,PAPERBirthTime)
			}
		 }
		s %request.Data("PAADMPAPMIDR",1)=id
		s %request.Data("ADMTYPE",1)="I"
		//Papadm.Edit 就诊日期和时间
		s %request.Data("LeaveDate",1)=$$$zd(+$h,4)
	    s %request.Data("LeaveTime",1)=$zt($p($h,",",2))
		s:$length(BabyID,"||")=4 BabyID=$p(BabyID,"||",1)_"||"_$p(BabyID,"||",2)_"||"_$p(BabyID,"||",4)
		i ((EpisodeID'="")&(BabyID'="")) {
		    &sql(select PAPER_Sex_DR into :SexDR from SQLUser.PA_Person where PAPER_RowId=:id)
		    s babyObj=##class(User.PAPregDelBaby).%OpenId(BabyID)
		    d babyObj.BABYSexDRSetObjectId(SexDR)
		    d babyObj.BABYPersonDRSetObjectId(id)
		    s babySave=babyObj.%Save()	
		    d babyObj.%Close()
		    s babyObj=""	
		}
	}
  }
  q $$$OK
SaveError 
   set ^Temp("PAPerson:AfterSave","Error",$h)=$ze_",id="_id_",babyID="_BabyID
   q 1
}

ClassMethod LPAD1(cnt, char, len)
{
	set mylen = $l(cnt)
	set mycnt = cnt
	if mylen>=len quit cnt
	for i=1:1:len-mylen set mycnt=char_mycnt
	quit mycnt
}

/// Invoked before websysSave - can be used to cancel the save.<br>
/// 页面上登记号和表中的去对比下,如有改变返回0.
/// PAPerson.Edit
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	i $g(id)="" q 1
	s patobj = ##class(User.PAPerson).%OpenId(id)
	i '$IsObject(patobj) q 0
	q:$p($G(^PAPER(id,"ALL")),"^",24)'=$g(%request.Data("RegistrationNumber",1)) 0	;PAPMINo
	;wanghc 2016-11-24  号段为13361001至13461001
	Set compid=$e($p(compref,"i",1),2,999)
	s myMAXNo="",cnt=0,max=0
	S cnttype="BABY"
	IF 1 D 
	.s s1=$g(^COUNT("CNTTYPE",cnttype)),pref=$p(s1,"^",2),suf=$p(s1,"^",3)
	.s len=$p(s1,"^",4),cnt=$p(s1,"^",5),max=$p(s1,"^",6)
	.s cnt=cnt+1
	.if cnt>max d
	..d msg.AddItem("E","Error","登记号已超出"_max_"号段！不能保存.!",compid,"RegistrationNumber")
	if cnt>max q 0
	q 1
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

/// Thecompref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) As %Library.String
{
 s $ZT="saveerr"
 s compid=$e($p(compref,"i"),2,),oktosave=1,save=0
 i id'="",'##Class(websys.Lock).Lock($lb(id,"User.PAPerson"),%session.SessionId,%session.Get("LOGON.USERID"),.status) d  q 0
 . d msg.AddItem("E","LOCKED",status,compid) s oktosave=0
 i '##Class(web.PAPerson).websysBeforeSave(compref,.id) q 0
 s new=id=""
 s:id'="" obj=##Class(User.PAPerson).%OpenId(id)
 if id="" d
 . s parref=$g(%request.Data("PARREF",1))
 . i parref="" s obj=##Class(User.PAPerson).%New()
 . i parref'="" s obj=##Class(User.PAPerson).%New(parref)
 i $d(%request.Data("PAPERName",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERName",1)) s obj.PAPERName=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERName"),"姓"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERName") s oktosave=0
 i $d(%request.Data("PAPERName2",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERName2",1)) s obj.PAPERName2=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERName2"),"名"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERName2") s oktosave=0
 i $d(%request.Data("PAPERName3",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERName3",1)) s obj.PAPERName3=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERName3"),"曾用名"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERName3") s oktosave=0
 i $d(%request.Data("PAPERTelH",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERTelH",1)) s obj.PAPERTelH=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERTelH"),"家庭电话"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERTelH") s oktosave=0
 i $d(%request.Data("PAPERTelO",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERTelO",1)) s obj.PAPERTelO=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERTelO"),"办公室电话"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERTelO") s oktosave=0
 i $d(%request.Data("PAPERForeignAddress",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERForeignAddress",1)) s obj.PAPERForeignAddress=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERForeignAddress"),"地址2"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERForeignAddress") s oktosave=0
 i $d(%request.Data("PAPERSecondPhone",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERSecondPhone",1)) s obj.PAPERSecondPhone=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERSecondPhone"),"第二个电话号码"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERSecondPhone") s oktosave=0
 i $d(%request.Data("PAPEREmail",1)) d
 . s (val,oldval)=$g(%request.Data("PAPEREmail",1)) s obj.PAPEREmail=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPEREmail"),"电子邮件地址"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPEREmail") s oktosave=0
 i $d(%request.Data("PAPERNokName",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNokName",1)) s obj.PAPERNokName=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNokName"),"Next of Kin"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNokName") s oktosave=0
 i $d(%request.Data("PAPERNokPhone",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNokPhone",1)) s obj.PAPERNokPhone=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNokPhone"),"近亲"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNokPhone") s oktosave=0
 i $d(%request.Data("CTRLTDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTRLTDesc",1)) s:$l($g(val)) val=##Class(web.CTRelation).GetIdFromCodeOrDescription($g(val)) d obj.PAPERNokCTRLTDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTRLTDesc"),"联系人"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTRLTDesc") s oktosave=0
 i $d(%request.Data("CTMARDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTMARDesc",1)) s:$l($g(val)) val=##Class(web.CTMarital).GetIdFromCodeOrDescription($g(val)) d obj.PAPERMaritalDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTMARDesc"),"婚姻"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTMARDesc") s oktosave=0
 i $d(%request.Data("CITAREADesc",1)) d
 . s (val,oldval)=$g(%request.Data("CITAREADesc",1)) s:$l($g(val)) val=##Class(web.CTCityArea).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCityAreaDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CITAREADesc"),"城市"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CITAREADesc") s oktosave=0
 i $d(%request.Data("REFDDesc",1)) d
 . s (val,oldval)=$g(%request.Data("REFDDesc",1)) s:$l($g(val)) val=##Class(web.PACRefDoctor).GetIdFromCodeOrDescription($g(val)) d obj.PAPERFamilyDoctorDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("REFDDesc"),"GP Name"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"REFDDesc") s oktosave=0
 i $d(%request.Data("PROVDesc",1)) d
 . s (val,oldval)=$g(%request.Data("PROVDesc",1)) s:$l($g(val)) val=##Class(web.CTProvince).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCTProvinceDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PROVDesc"),"州"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PROVDesc") s oktosave=0
 i $d(%request.Data("CTCITDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTCITDesc",1)) ;s:$l($g(val)) val=##Class(web.CTCity).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCityCodeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTCITDesc"),"郊区"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTCITDesc") s oktosave=0
 i $d(%request.Data("CTNATDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTNATDesc",1)) s:$l($g(val)) val=##Class(web.CTNation).GetIdFromCodeOrDescription($g(val)) d obj.PAPERNationDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTNATDesc"),"国籍"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTNATDesc") s oktosave=0
 i $d(%request.Data("CTRLGDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTRLGDesc",1)) s:$l($g(val)) val=##Class(web.CTReligion).GetIdFromCodeOrDescription($g(val)) d obj.PAPERReligionDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTRLGDesc"),"宗教"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTRLGDesc") s oktosave=0
 i $d(%request.Data("CTSEXDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTSEXDesc",1)) s:$l($g(val)) val=##Class(web.CTSex).GetIdFromCodeOrDescription($g(val)) d obj.PAPERSexDRSetObjectId($g(val)) 
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTSEXDesc"),"性别"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTSEXDesc") s oktosave=0
 i $d(%request.Data("TTLDesc",1)) d
 . s (val,oldval)=$g(%request.Data("TTLDesc",1)) s:$l($g(val)) val=##Class(web.CTTitle).GetIdFromCodeOrDescription($g(val)) d obj.PAPERTitleDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("TTLDesc"),"头衔"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"TTLDesc") s oktosave=0
 i $d(%request.Data("CTCOUDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTCOUDesc",1)) s:$l($g(val)) val=##Class(web.CTCountry).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCountryBirthDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTCOUDesc"),"出生地"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTCOUDesc") s oktosave=0
 i $d(%request.Data("PAPERMobPhone",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERMobPhone",1)) s obj.PAPERMobPhone=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERMobPhone"),"手机号"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERMobPhone") s oktosave=0
 i $d(%request.Data("PAPERGovernCardNo",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERGovernCardNo",1)) s obj.PAPERGovernCardNo=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERGovernCardNo"),"养老金号"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERGovernCardNo") s oktosave=0
 i $d(%request.Data("PREFLDesc",1)) d
 . s (val,oldval)=$g(%request.Data("PREFLDesc",1)) ;s:$l($g(val)) val=##Class(web.PACPreferredLanguage).GetIdFromCodeOrDescription($g(val)) d obj.PAPERPrefLanguageDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PREFLDesc"),"首选语言"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PREFLDesc") s oktosave=0
 i $d(%request.Data("INDSTDesc",1)) d
 . s (val,oldval)=$g(%request.Data("INDSTDesc",1)) s:$l($g(val)) val=##Class(web.PACIndigStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAPERIndigStatDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("INDSTDesc"),"身份证"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"INDSTDesc") s oktosave=0
 i $d(%request.Data("PAPERRemark",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERRemark",1)) s obj.PAPERRemark=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERRemark"),"PMI Notes"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERRemark") s oktosave=0
 i $d(%request.Data("PAPERNokAddress1",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNokAddress1",1)) s obj.PAPERNokAddress1=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNokAddress1"),"Nok Address"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNokAddress1") s oktosave=0
 i $d(%request.Data("PAPERNokAddress2",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNokAddress2",1)) s obj.PAPERNokAddress2=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNokAddress2"),"NokAddress2"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNokAddress2") s oktosave=0
 i $d(%request.Data("PAPERUpdateDate",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERUpdateDate",1)) s obj.PAPERUpdateDate=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERUpdateDate"),"更新日期"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERUpdateDate") s oktosave=0
 i $d(%request.Data("PAPERUpdateTime",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERUpdateTime",1)) s obj.PAPERUpdateTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERUpdateTime"),"更新时间"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERUpdateTime") s oktosave=0
 i $d(%request.Data("PAPERLocationOfDeath",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERLocationOfDeath",1)) s obj.PAPERLocationOfDeath=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERLocationOfDeath"),"死亡科室"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERLocationOfDeath") s oktosave=0
 i $d(%request.Data("PAPERWhoNotified",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERWhoNotified",1)) s obj.PAPERWhoNotified=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERWhoNotified"),"死亡通知"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERWhoNotified") s oktosave=0
 i $d(%request.Data("PAPERDeceasedDate",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDeceasedDate",1)) s obj.PAPERDeceasedDate=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDeceasedDate"),"死亡日期"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDeceasedDate") s oktosave=0
 i $d(%request.Data("PAPERDeceasedTime",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDeceasedTime",1)) s obj.PAPERDeceasedTime=##Class(websys.Conversions).TimeHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDeceasedTime"),"死亡时间"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDeceasedTime") s oktosave=0
 i $d(%request.Data("CTOCCDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTOCCDesc",1)) s:$l($g(val)) val=##Class(web.CTOccupation).GetIdFromCodeOrDescription($g(val)) d obj.PAPEROccupationDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTOCCDesc"),"职业"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTOCCDesc") s oktosave=0
 i $d(%request.Data("PAPERID",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERID",1)) s obj.PAPERID=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERID"),"国家ID"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERID") s oktosave=0
 i $d(%request.Data("INSTDesc",1)) d
 . s (val,oldval)=$g(%request.Data("INSTDesc",1)) s:$l($g(val)) val=##Class(web.ARCInsuranceType).GetIdFromCodeOrDescription($g(val)) d obj.PAPERInsTypeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("INSTDesc"),"个人支付"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"INSTDesc") s oktosave=0
 i $d(%request.Data("AUXITDesc",1)) d
 . s (val,oldval)=$g(%request.Data("AUXITDesc",1)) s:$l($g(val)) val=##Class(web.ARCAuxilInsurType).GetIdFromCodeOrDescription($g(val)) d obj.PAPERAuxInsTypeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("AUXITDesc"),"支付计划"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"AUXITDesc") s oktosave=0
 i $d(%request.Data("PAPERDateOfEntry",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDateOfEntry",1)) s obj.PAPERDateOfEntry=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDateOfEntry"),"录入日期"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDateOfEntry") s oktosave=0
 i $d(%request.Data("PAPERDateOfInterview",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDateOfInterview",1)) s obj.PAPERDateOfInterview=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDateOfInterview"),"会见日期"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDateOfInterview") s oktosave=0
 i $d(%request.Data("PAPERInterviewedBy",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERInterviewedBy",1)) s obj.PAPERInterviewedBy=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERInterviewedBy"),"会见 "),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERInterviewedBy") s oktosave=0
 i $d(%request.Data("PAPERNationalResident",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNationalResident",1)) s obj.PAPERNationalResident=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNationalResident"),"居民"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNationalResident") s oktosave=0
 i $d(%request.Data("PAPERStayingPermanently",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERStayingPermanently",1)) s obj.PAPERStayingPermanently=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERStayingPermanently"),"永久居住"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERStayingPermanently") s oktosave=0
 i $d(%request.Data("CountryCameFrom",1)) d
 . s (val,oldval)=$g(%request.Data("CountryCameFrom",1)) s:$l($g(val)) val=##Class(web.CTCountry).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCountryCameFromDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CountryCameFrom"),""),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CountryCameFrom") s oktosave=0
 i $d(%request.Data("OVSDesc",1)) d
 . s (val,oldval)=$g(%request.Data("OVSDesc",1)) s:$l($g(val)) val=##Class(web.PACOSVisitorStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAPEROSVStatusDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("OVSDesc"),"OSV Status"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"OVSDesc") s oktosave=0
 i $d(%request.Data("PAPERNOKBusPhone",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERNOKBusPhone",1)) s obj.PAPERNOKBusPhone=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNOKBusPhone"),"NOK Business Phone"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNOKBusPhone") s oktosave=0
 i $d(%request.Data("HOSPDesc",1)) d
 . s (val,oldval)=$g(%request.Data("HOSPDesc",1)) s:$l($g(val)) val=##Class(web.CTHospital).GetIdFromCodeOrDescription($g(val)) d obj.PAPERLastUpdateHospitalDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("HOSPDesc"),"最后更新医院"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"HOSPDesc") s oktosave=0
 i $d(%request.Data("PAPERUsualRoundDR",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERUsualRoundDR",1)) s:$l($g(val)) val=##Class(web.RBResource).GetIdFromCodeOrDescription($g(val)) d obj.PAPERUsualRoundDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERUsualRoundDR"),"Usual Round"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERUsualRoundDR") s oktosave=0
 i $d(%request.Data("EMPLSTDesc",1)) d
 . s (val,oldval)=$g(%request.Data("EMPLSTDesc",1)) s:$l($g(val)) val=##Class(web.PACEmploymentStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAPEREmploymentStatDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EMPLSTDesc"),"就业状况"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"EMPLSTDesc") s oktosave=0
 i $d(%request.Data("SRCINCDesc",1)) d
 . s (val,oldval)=$g(%request.Data("SRCINCDesc",1)) s:$l($g(val)) val=##Class(web.PACSourceOfIncome).GetIdFromCodeOrDescription($g(val)) d obj.PAPERSourceOfIncomeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("SRCINCDesc"),"主要收入来源"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"SRCINCDesc") s oktosave=0
 i $d(%request.Data("LIVARRDesc",1)) d
 . s (val,oldval)=$g(%request.Data("LIVARRDesc",1)) s:$l($g(val)) val=##Class(web.PACLivingArrangement).GetIdFromCodeOrDescription($g(val)) d obj.PAPERLivingArrangementDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("LIVARRDesc"),"Living Arrangements"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"LIVARRDesc") s oktosave=0
 i $d(%request.Data("RESIDDesc",1)) d
 . s (val,oldval)=$g(%request.Data("RESIDDesc",1)) s:$l($g(val)) val=##Class(web.PACResidenceStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAPERResidenceStatusDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("RESIDDesc"),"居住状况"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"RESIDDesc") s oktosave=0
 i $d(%request.Data("TRUDesc",1)) d
 . s (val,oldval)=$g(%request.Data("TRUDesc",1)) s:$l($g(val)) val=##Class(web.PACTransportUsed).GetIdFromCodeOrDescription($g(val)) d obj.PAPERTransportUsedDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("TRUDesc"),"Transport Used"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"TRUDesc") s oktosave=0
 i $d(%request.Data("PAPEREffDateCurrAddress",1)) d
 . s (val,oldval)=$g(%request.Data("PAPEREffDateCurrAddress",1)) s obj.PAPEREffDateCurrAddress=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPEREffDateCurrAddress"),"地址开始日期"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPEREffDateCurrAddress") s oktosave=0
 i $d(%request.Data("PAPERAge",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERAge",1)) s obj.PAPERAge=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERAge"),"年龄"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERAge") s oktosave=0
 i $d(%request.Data("PAPERBloodTypeDR",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERBloodTypeDR",1)) s:$l($g(val)) val=##Class(web.PACBloodType).GetIdFromCodeOrDescription($g(val)) d obj.PAPERBloodTypeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERBloodTypeDR"),"血类型"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERBloodTypeDR") s oktosave=0
 i $d(%request.Data("HCADesc",1)) d
 . s (val,oldval)=$g(%request.Data("HCADesc",1)) s:$l($g(val)) val=##Class(web.CTHealthCareArea).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCTHCADRSetObjectId($g(val)) 
 . i oldval'="",val="" d msg.AddItem("E",$g(t("HCADesc"),"社区医疗"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"HCADesc") s oktosave=0
 i $d(%request.Data("CTCITDescBirth",1)) d
 . s (val,oldval)=$g(%request.Data("CTCITDescBirth",1)) s:$l($g(val)) val=##Class(web.CTCity).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCityBirthDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTCITDescBirth"),"出生城市"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTCITDescBirth") s oktosave=0
 i $d(%request.Data("ASSISDesc",1)) d
 . s (val,oldval)=$g(%request.Data("ASSISDesc",1)) s:$l($g(val)) val=##Class(web.PACAusSouthSeaIslander).GetIdFromCodeOrDescription($g(val)) d obj.PAPERAusSouthSeaIslanderDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ASSISDesc"),"Australian South Sea Islander"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"ASSISDesc") s oktosave=0
 i $d(%request.Data("PAPERFeedBackConsent",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERFeedBackConsent",1)) s obj.PAPERFeedBackConsent=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERFeedBackConsent"),"Feed back Consent"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERFeedBackConsent") s oktosave=0
 i $d(%request.Data("CTRGDesc",1)) d
 . s (val,oldval)=$g(%request.Data("CTRGDesc",1)) s:$l($g(val)) val=##Class(web.CTRegion).GetIdFromCodeOrDescription($g(val)) d obj.PAPERCTRegionDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("CTRGDesc"),"Region"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"CTRGDesc") s oktosave=0
 i $d(%request.Data("PAPEROccupation",1)) d
 . s (val,oldval)=$g(%request.Data("PAPEROccupation",1)) s obj.PAPEROccupation=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPEROccupation"),"FreeText Occupation"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPEROccupation") s oktosave=0
 i $d(%request.Data("PAPERFamilyLinkText",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERFamilyLinkText",1)) s obj.PAPERFamilyLinkText=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERFamilyLinkText"),"FamilyLinkText"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERFamilyLinkText") s oktosave=0
 i $d(%request.Data("PAPERDVAExpiryDate",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDVAExpiryDate",1)) s obj.PAPERDVAExpiryDate=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDVAExpiryDate"),"DVA Expiry Date"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDVAExpiryDate") s oktosave=0
 i $d(%request.Data("PAPERPensionCardExpiryDate",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERPensionCardExpiryDate",1)) s obj.PAPERPensionCardExpiryDate=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERPensionCardExpiryDate"),"养老金到期日"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERPensionCardExpiryDate") s oktosave=0
 i $d(%request.Data("PAPERReversedBy",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERReversedBy",1)) s obj.PAPERReversedBy=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERReversedBy"),"ReversedBy"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERReversedBy") s oktosave=0
 i $d(%request.Data("EDUDesc",1)) d
 . s (val,oldval)=$g(%request.Data("EDUDesc",1)) s:$l($g(val)) val=##Class(web.CTEducation).GetIdFromCodeOrDescription($g(val)) d obj.PAPEREducationDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EDUDesc"),"教育"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"EDUDesc") s oktosave=0
 i $d(%request.Data("SSDesc",1)) d
 . s (val,oldval)=$g(%request.Data("SSDesc",1)) s:$l($g(val)) val=##Class(web.CTSocialStatus).GetIdFromCodeOrDescription($g(val)) d obj.PAPERSocialStatusDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("SSDesc"),"社会状况"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"SSDesc") s oktosave=0
 i $d(%request.Data("PAPERForeignId",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERForeignId",1)) s obj.PAPERForeignId=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERForeignId"),"ForeignID"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERForeignId") s oktosave=0
 i $d(%request.Data("PAPERPassportNumber",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERPassportNumber",1)) s obj.PAPERPassportNumber=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERPassportNumber"),"护照号"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERPassportNumber") s oktosave=0
 i $d(%request.Data("PAPERContactNotes",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERContactNotes",1)) s obj.PAPERContactNotes=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERContactNotes"),"联机注释"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERContactNotes") s oktosave=0
 i $d(%request.Data("DEPCHLDesc",1)) d
 . s (val,oldval)=$g(%request.Data("DEPCHLDesc",1)) s:$l($g(val)) val=##Class(web.PACDependentChildren).GetIdFromCodeOrDescription($g(val)) d obj.PAPERDependChildrenDR.DEPCHLDescSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("DEPCHLDesc"),"依赖子女"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"DEPCHLDesc") s oktosave=0
 i $d(%request.Data("ACCOMSDesc",1)) d
 . s (val,oldval)=$g(%request.Data("ACCOMSDesc",1)) s:$l($g(val)) val=##Class(web.PACAccomSetting).GetIdFromCodeOrDescription($g(val)) d obj.PAPERAccomSettingDR.ACCOMSDescSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ACCOMSDesc"),"住宿/住宅设置"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"ACCOMSDesc") s oktosave=0
 i $d(%request.Data("PAPERCCC1",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC1",1)) s obj.PAPERCCC1=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC1"),"CCC1"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC1") s oktosave=0
 i $d(%request.Data("PAPERCCC2",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC2",1)) s obj.PAPERCCC2=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC2"),"CCC2"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC2") s oktosave=0
 i $d(%request.Data("PAPERCCC3",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC3",1)) s obj.PAPERCCC3=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC3"),"CCC3"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC3") s oktosave=0
 i $d(%request.Data("PAPERCCC4",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC4",1)) s obj.PAPERCCC4=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC4"),"CCC4"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC4") s oktosave=0
 i $d(%request.Data("PAPERCCC5",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC5",1)) s obj.PAPERCCC5=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC5"),"CCC5"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC5") s oktosave=0
 i $d(%request.Data("PAPERCCC6",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERCCC6",1)) s obj.PAPERCCC6=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERCCC6"),"CCC6"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERCCC6") s oktosave=0
 i $d(%request.Data("PAPERChineseName",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERChineseName",1)) s obj.PAPERChineseName=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERChineseName"),"Chinese Name"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERChineseName") s oktosave=0
 i $d(%request.Data("PAPERDocNumber",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDocNumber",1)) s obj.PAPERDocNumber=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDocNumber"),"Document Number"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDocNumber") s oktosave=0
 i $d(%request.Data("PAPERIDDocTypeDR",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERIDDocTypeDR",1)) s:$l($g(val)) val=##Class(web.PACIDDocType).GetIdFromCodeOrDescription($g(val)) d obj.PAPERIDDocTypeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERIDDocTypeDR"),"Document Type"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERIDDocTypeDR") s oktosave=0
 d
 . s (val,oldval)=$g(%request.Data("PAPERNoChinName",1)) s obj.PAPERNoChinName=##Class(websys.Conversions).YesNoHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERNoChinName"),"No Chinese Name"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERNoChinName") s oktosave=0
 i $d(%request.Data("PAPERChineseAddress",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERChineseAddress",1)) s obj.PAPERChineseAddress=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERChineseAddress"),"ChineseAddress"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERChineseAddress") s oktosave=0
 i $d(%request.Data("PAPERChineseArea",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERChineseArea",1)) s obj.PAPERChineseArea=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERChineseArea"),"ChineseArea"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERChineseArea") s oktosave=0
 i $d(%request.Data("PAPERChineseDistrict",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERChineseDistrict",1)) s obj.PAPERChineseDistrict=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERChineseDistrict"),"ChineseDistrict"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERChineseDistrict") s oktosave=0
 i $d(%request.Data("PAPERFax",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERFax",1)) s obj.PAPERFax=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERFax"),"传真"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERFax") s oktosave=0
 i $d(%request.Data("PAPERPager",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERPager",1)) s obj.PAPERPager=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERPager"),"Pager"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERPager") s oktosave=0
 //出生日期
 i $d(%request.Data("PAPERDob",1)) d
 . s (val,oldval)=$g(%request.Data("PAPERDob",1)) s:$g(val)'="" obj.PAPERDob=$$$zdh(val,4)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PAPERDob"),"Date of Birth"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PAPERDob") s oktosave=0
 i $d(%request.Data("PTYPEDesc",1)) d
 . s (val,oldval)=$g(%request.Data("PTYPEDesc",1)) s:$l($g(val)) val=##Class(web.PACPatientType).GetIdFromCodeOrDescription($g(val)) d obj.PAPERPatTypeDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("PTYPEDesc"),"Patient Type"),oldval_" "_$g(t("XINVALID")," is invalid"),49,"PTYPEDesc") s oktosave=0
 i 'oktosave,'$g(msg.Count("E")),$g(%request.Data("TOVERRIDE",1)) s oktosave=1
 s ^Temp("web.PAPerson","websysSave",1)=oktosave
 i oktosave d
 . s save=obj.%Save(0)
 . s ^Temp("web.PAPerson","websysSave",2)=$system.Status.GetErrorText(save)
 . i $d(msg) d msg.Status(save,49)
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""
 s idnew=id
 d:save ##Class(web.PAPerson).websysAfterSave(compref,id,new)
 i 'new d ##Class(websys.Lock).LockClear($lb(id,"User.PAPerson"),%session.SessionId)
 q save
saveerr
 d ##Class(websys.Lock).LockClear($lb(id,"User.PAPerson"),%session.SessionId)
 s ^Temp("web.PAPerson","websysSave",$h)=$ZE
 q 1
}

ClassMethod websysSaveTriagePatient(compref As %Library.String, PatientID As %Library.String) As %Library.String
{
}

/// create list of words
/// [Previously private]
ClassMethod words()
{
}

ClassMethod GetLastDischarge(PatientID As %String) As %String
{
  quit ""
}

ClassMethod GetMergeMRN(pat As %String = "") As %Library.String
{
	quit ""
}

/// ab 2.03.05 49709
Query LookUpEmployeeNo(empno As %String, PatientID As %String, type As %String) As %SQLQuery(CONTAINID = 4, ROWSPEC = "EmployeeNumber:%String,Surname:%String,GivenName:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT PAPER_EmployeeNo,PAPER_Name,PAPER_Name2,PAPER_RowId,PAPER_EmplDep_DR->CTLOC_Desc
FROM SQLUser.PA_Person
WHERE ((PAPER_EmployeeNo IS NOT NULL) AND ((%ALPHAUP PAPER_EmployeeNo %STARTSWITH %ALPHAUP :empno) OR (:empno IS NULL)))
AND ((PAPER_RowId <> :PatientID) OR (:PatientID IS NULL))
AND (PAPER_EmplType_DR->EPE_Code = 'DEMP')
AND (:type <> 'DEMP')
ORDER   BY PAPER_EmployeeNo
}

ClassMethod LookUpEmployeeNoBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", PatientID As %String = "", type As %String = "") As %Boolean
{
}

ClassMethod GetEmployeeDept(id As %String = "") As %String
{
}

/// ab 2.03.05 49709
ClassMethod websysSaveEmployee(compref As %String, id As %String) As %String
{
}

ClassMethod CheckExternal(id As %String)
{
}

/// md keep it 
ClassMethod PrepareBatchData()
{
}

Query Find(RegistrationNo, PAPERName, PAPERName2, PAPERName3, NationalID, SSN, CTSEXDesc, GovtCardNo, ProvOB, MedicalRecordNo, BillNo, EpisodeNo, PAPERDob, soundex, phone, hiddenFlag) As %Query(CONTAINID = 1, ROWSPEC = "ID,RegistrationNo,Name,Name2,Name3,Dob:%Date,Sex,Tel,Medicare,AddressLine1,City,Zip,Marital,Deceased,Address2,edob,mergereg,DVA,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String,PAPERAddress2:%String,PAPERID:%String,VIPStatus:%String,Occupation:%String,EmplNo:%String,PreferredContactMethod:%String")
{
}

Query FindEXTERNAL(RegistrationNo, PAPERName, PAPERName2, PAPERName3, CTSEXDesc, PAPERDob, QueryType, Continue, Interface1, Interface2, CHINo) As %Query(CONTAINID = 1, ROWSPEC = "ID,RegistrationNo,Name,Name2,Name3,Dob:%Date,Sex,AdmDate:%Date,DischDate:%Date,Hospital,Diagnosis,Name4,Address,Address2,Suburb,City,Zip,Docimile,DecDate,Ethnic1,Ethnic2,Ethnic3,Resident,PAPERID,ExtNum")
{
}

Query FindEpisodeStatus(regostring As %String, admstring As %String, action As %String, btype As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Status,RegistrationNo,Name,Name2,DOB,EpisodeNo,EpisodeID,Rfail")
{
}

Query FindInEpisode(RegoString As %String, Unit As %String, Ward As %String, GPcode As %String, admtype As %String, totD As %String, TGPcode As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RegistrationNo,Name,Name2,DOB,Sex,EpisodeNo,Unit,ward,bed,doctor,EpisodeID,trdoctor")
{
}

/// cjb 10/02/2005 49250 - dummy methods as the brokers aren't being used (not actually used, but they are on some hidden fields, DR's to PAAdm...)
/// the dummy methods ensure that websys.abstract doesn't generate nasty sql
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetIdFromCodeOrDescription(id As %Library.String) As %Library.String
{
	;wanghc
	;增加分娩记录时用到	
	q id
}

ClassMethod GetIdFromDateCodeOrDesc(id As %Library.String, date As %Library.Date = "") As %Library.String
{
}

/// Log 49558 9/10/2006 BoC: check if patient not contacting the hospital for X period
ClassMethod CheckContactPeriod(PatientID As %Library.String) As %Library.Boolean
{
}

/// Log 58325 BoC check if patient is Pregnant and/or Breastfeeding
ClassMethod CheckPregnBrFd(PatID As %Library.String) As %Library.String
{
}

ClassMethod SetPreg(PatientID As %Library.String) As %Library.String
{
}

}
