Import SQLUser

/// Creator：
Class web.DHCDocIPBookingCtl Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 261;

ClassMethod Test()
{
	;w ##class(web.DHCDocIPBookingCtl).Test()
	k ^DHCDocIPBK
	k ^DHCDocIPBKS
	k ^DHCDocIPBKD
	q "0"
}

/// CreatDate：  2008-10-24
/// Description：保存住院证主信息
/// Input：      
/// Instring：   用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID。
/// Debug:	   
/// bug find at 2012.6.15 d ##class(web.DHCDocIPBookingCtl).Update("^^^^^^^^^^^^^^^") 
ClassMethod Update(Instring)
{
	;"18^52^214^^^^6^6^8^Y^^26^26||1^29^^"
	s ^RP("UpdateInProof")=Instring
	;w ##class(web.DHCDocIPBookingCtl).Update(Instring)
	n (Instring)
	set RowID = $p(Instring, "^",1)
	set PLIST(2)=$p(Instring,"^",2)         ;PatientID       
    set PLIST(3)=$p(Instring,"^",3)         ;门诊就诊PAADM  指向PA_ADM
    set PLIST(4)=$p(Instring,"^",4)         ;住院就诊PAADM  指向PA_ADM
    set CreateDate = $p(Instring,"^",5)
    set:CreateDate="" CreateDate=..%SysDate()
    ;set:(CreateDate'="")&(CreateDate["-") CreateDate=$zdh(CreateDate,3)
    ;set:(CreateDate'="")&(CreateDate["/") CreateDate=$zdh(CreateDate,4)
    i CreateDate'="" s CreateDate=..%ZDH(CreateDate)
    set PLIST(5)=CreateDate         		;建住院证日期
    set CreateTime = $p(Instring,"^",6)
    set:CreateTime="" CreateTime=..%SysTime()
    set:(CreateTime'="")&(CreateTime[":") CreateTime=..%ZTH(CreateTime,2)
    set PLIST(6)=CreateTime         		;建住院证时间
    set PLIST(7)=$p(Instring,"^",7)         ;建住院证操作员ID 指向SS_User
    set PLIST(8)=$p(Instring,"^",8)         ;建住院证医师ID 指向SS_User
    set PLIST(9)=$p(Instring,"^",9)         ;当前状态ID 指向DHC_MedDictory
    set PLIST(10)=$p(Instring,"^",10)       ;有效状态 Yes/No
    set BookDate = $p(Instring,"^",11)
    set:BookDate="" BookDate=0    //$p($h,",",1)
    ;set:(BookDate'="")&(BookDate["-") BookDate=$zdh(BookDate,3)
    ;set:(BookDate'="")&(BookDate["/") BookDate=$zdh(BookDate,4)
    i BookDate'="" s BookDate=..%ZDH(BookDate)
    set PLIST(11)=BookDate         			;预约日期    	
    set PLIST(12)=$p(Instring,"^",12)       ;Text1    病区ID	
    set PLIST(13)=$p(Instring,"^",13)       ;Text2    床位ID	
    set PLIST(14)=$p(Instring,"^",14)       ;Text3    科室ID
    set PLIST(15)=$p(Instring,"^",15)       ;Text4	  诊断ID
    set PLIST(16)=$p(Instring,"^",16)       ;备注 
    Set PLIST(18)=$p(Instring,"^",18)       ;IPDeposit 住院押金
    Set PLIST(17)=$p(Instring,"^",19)		;入院病情
    //Set PLIST(21)=$p(Instring,"^",20)		;住院证号
	s NewRowID=""
    TS
    i RowID="" d
    .&sql(Insert into DHCDocIPBooking values :PLIST())
    .s RowID =$p(%ROWID,$c(1))
    .;&sql(delete from DHCDocIPBKDetail where bookID=:RowID)
	.s NewRowID=RowID
    e  d
    .k PLIST(5),PLIST(6)
    .&sql(Update DHCDocIPBooking values :PLIST() where Rowid=:RowID)
     
    S Rtn=SQLCODE
    i Rtn=0 {
    	;如果是预住院,需要插入预住院的就诊记录
    	s CurrentStateCode=""
    	s CurrentStateID=$p(Instring,"^",9)
    	i CurrentStateID'="" s CurrentStateCode=$p(^DHCDocIPBDIC(CurrentStateID),"^",1)
    	i CurrentStateCode="PreInPatient" s Rtn=..UpdatePreInPatient(RowID)
    }
    
    i Rtn=0 {
	    TC
		if (NewRowID'="") {
		    s CurrentDate=$zd(+$h,3)
		    s CurrentDate=$p(CurrentDate,"-",2,3)
		    s CurrentDate=$tr(CurrentDate,"-","")
		    s IPBookingNo=CurrentDate_""_(+$g(^DHCDocIPBK(0)))
		    //s $p(^DHCDocIPBK(NewRowID),"^",20)=IPBookingNo
			//&sql(Update DHCDocIPBooking set IPBookNo=:IPBookingNo where RowID=:NewRowID)
		}
	    quit RowID
    }else{
	    TRO
	    quit "-100"
    }
}

ClassMethod UpdatePreInPatient(RowID As %String) As %String
{
	n (RowID)
	s myrtn=0
	s AdmDate=..%SysDate(),AdmTime=..%SysTime()
	s AdmType="I"
	;预住院状态
	s VisitusStatus="P"
	s PatientID=$p(^DHCDocIPBK(RowID),"^",1)
	s EpisodeIDFrom=$p(^DHCDocIPBK(RowID),"^",2)
	s EpisodeIDTo=$p(^DHCDocIPBK(RowID),"^",3)
	s CreateUser=$p(^DHCDocIPBK(RowID),"^",6)
	s CurrentStateID=$p(^DHCDocIPBK(RowID),"^",8)
	s WardId=$p(^DHCDocIPBK(RowID),"^",11)
	s BedId=$p(^DHCDocIPBK(RowID),"^",12)
	s DepId=$p(^DHCDocIPBK(RowID),"^",13)
	s DiagnosICDId=$p(^DHCDocIPBK(RowID),"^",14)
	
	i EpisodeIDTo'="" {
		s EpisodeIDToVisitusStatus=$P(^PAADM(EpisodeIDTo),"^",20)
		i EpisodeIDToVisitusStatus=VisitusStatus {
			&SQL(update SQLUser.PA_ADM  set PAADM_DepCode_DR=:DepId,PAADM_CurrentWard_DR=:WardId where PAADM_RowID=:EpisodeIDTo)
			s myrtn=SQLCODE
		}
	}else{
		;插入预住院的急诊记录
		s AdmReasonId=""
		s AdmRoom=""
		s AdmDoc=""
		s AdmBed=""
		s Epissubtype=""
		s AdmCate=""
		s AdmRefDocListDR=""
		s AdmDiagnosCatRowId=""
		s AdmInPatNo=""
		s AdmSrcDr=""
		s FirstOrReadmis=""
		s InsuCoRowid=""
		s RegConDisId=""
		s Para=PatientID_"^"_AdmType_"^"_AdmDate_"^"_AdmTime_"^"_DepId_"^"_AdmDoc_"^"_AdmReasonId_"^"_CreateUser_"^"_WardId
		s Para=Para_"^"_AdmRoom_"^"_AdmBed_"^"_Epissubtype_"^"_AdmCate_"^"_AdmRefDocListDR_"^"_AdmDiagnosCatRowId_"^"_""_"^"_AdmInPatNo
		s Para=Para_"^"_AdmSrcDr_"^"_FirstOrReadmis_"^"_InsuCoRowid_"^"_RegConDisId
		s IPEpisodeID=##class(web.DHCPAADM).ADMInsert(Para)
		i IPEpisodeID'="" {
			;更新PAADMVisitStatus字段为预住院
			&SQL(Update SQLUser.PA_Adm set PAADM_VisitStatus=:VisitusStatus where PAADM_RowId=:IPEpisodeID)
			s myrtn=SQLCODE
			
			;更新住院证记录的住院就诊ID
			i myrtn=0 {
				&SQL(Update SQLUser.DHCDocIPBooking  set EpisodeIDTo=:IPEpisodeID where RowID=:RowID)
				s myrtn=SQLCODE
			}
		}
	}
	
	
	q myrtn
}

/// 
/// ReName:联系人, RePhone:联系人姓名
/// Creator：   
/// CreatDate：  
/// Description：更新病人基本信息（很少部分）
/// Input：      
/// PatientID：病人ID
/// Company：工作单位, 
/// HomeAddress：家庭住址, 
/// Tel：联系电话, 
/// PersonalID：身份证号码, 
/// ReName：联系人姓名, 
/// RePhone：联系电话
/// RelationNameDr:和联系人的关系Dr   CT_Relation表
/// Return：     1
ClassMethod UpdatePatientBaseInfo(PatientID, Company, HomeAddress, Tel, PersonalID, RelationName, RePhone, RelationNameDr)
{
	;3^11^22^12312321^^33^44^4
	s ^RP("UpdateotherInfo")=PatientID_"^"_Company_"^"_HomeAddress_"^"_Tel_"^"_PersonalID_"^"_RelationName_"^"_RePhone_"^"_RelationNameDr
	; w ##class(web.DHCDocIPBookingCtl).UpdatePatientBaseInfo(3,11,22,12312321,"",33,44,4)
	n (PatientID, Company, HomeAddress, Tel, PersonalID, RelationName, RePhone, RelationNameDr)
	TS
	&sql(update PA_Person set 
		PAPER_SecondPhone = :Company,
		PAPER_TelH = :Tel,
		PAPER_ForeignPhone = :RePhone,
		PAPER_CTRLT_DR = :RelationNameDr,
		PAPER_ForeignId=:RelationName
		   WHERE PAPER_RowId = :PatientID
	)
	i SQLCODE'="0" {
		trollback
		q "1"
	}

	&sql(update pa_patmas set 
		papmi_id=:PersonalID,PAPMI_DVAnumber=:PersonalID
		where papmi_rowid=:PatientID)
	i SQLCODE'="0" {
		trollback
		q "1"
	}
	//身份证号字段定义的长度位数不够,通过写入Global方式更新
	s $p(^PAPER(PatientID,"ALL"),"^",9)=PersonalID	
	S ^PAPER(PatientID,"PER","ADD",1)=HomeAddress
	
	do ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PatientID,PersonalID)
	
	TC
	quit SQLCODE
}

/// Description：保存住院证的附加信息
/// Input：      用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID。	   
ClassMethod UpdateDetail(Instring)
{
	n (Instring,counter)
	s counter=$I(^DHCYL)
	s ^RP("Instring",counter)=Instring
	;w ##class(web.DHCDocIPBookingCtl).UpdateDetail(Instring)
	
	set RowID = $p(Instring, "^", 1)
	set PLIST(2) = $p(Instring, "^", 2)
	set PLIST(3) = $p(Instring, "^", 3)
	set PLIST(4) = $p(Instring, "^", 4)
      
    i RowID="" d
    .//&sql(Insert into DHCDocIPBKDetail values :PLIST())
    .s BDObj=##class(User.DHCDocIPBKDetail).%New()
    .d BDObj.BookIDSetObjectId($p(Instring, "^", 2))
    .d BDObj.ItemIDSetObjectId($p(Instring,"^",3))
    .s BDObj.ItemValue=$p(Instring, "^", 4)
    .s SaveRS=BDObj.%Save()
    .s RowID=BDObj.%Id()
    .s ^RP("Instring",counter,"SaveResult")=SaveRS
    .//s RowID =$p(%ROWID,$c(1))
    e  d
    .&sql(Update DHCDocIPBKDetail values :PLIST() where Rowid=:RowID)
    quit RowID
}

/// CreatDate：  2008-10-24
/// Description：保存住院证的状态信息
/// Input：      
/// Instring：   用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID
ClassMethod UpdateBookState(Instring)
{
	s ^RP("InProof")=Instring
	;w ##class(web.DHCDocIPBookingCtl).UpdateBookState(Instring)
	n (Instring)
	set RowID = $p(Instring, "^", 1)
	set PLIST(2) = $p(Instring, "^", 2)
	set PLIST(3) = $p(Instring, "^", 3)
	set PLIST(4) = $p(Instring, "^", 4)
	set PLIST(5) = $p(Instring, "^", 5)
	set:$p(Instring,"^",5)="" PLIST(5)=..%SysDate()
	set PLIST(6) = $p(Instring, "^", 6)
	set:$p(Instring,"^",6)="" PLIST(6)=..%SysTime()
	set PLIST(7) = $p(Instring, "^", 7)	
	set PLIST(8) = $p(Instring, "^", 8)
	
    i RowID="" d
    .&sql(Insert into DHCDocIPBKStates values :PLIST())
    .s RowID =$p(%ROWID,$c(1))
    e  d
    .&sql(Update DHCDocIPBKStates values :PLIST() where Rowid=:RowID)
    
    &sql(Update DHCDocIPBooking set CurrentStateID = :PLIST(3) where Rowid=:PLIST(2))
    quit RowID
}

/// CreatDate：  2008-10-24
/// Description：取住院证的状态信息
/// Input：      paadmrowid
/// Return：     备注
ClassMethod GetBookState(Paadm, RowID As %String = "")
{
	s ^RP("GetBookState")=Paadm_","_RowID
	;w ##class(web.DHCDocIPBookingCtl).GetBookState(^RP("GetBookState"))
	s ResumeStr=""
	if RowID'="" {
		s BookID=RowID
	}else{
		quit:Paadm="" ""
		set BookID = $o(^DHCDocIPBK(0, "EpisodeIDFrom", Paadm, ""))
	}
	quit:BookID="" ""
	s stateid=""
	for{
		s stateid=$o(^DHCDocIPBKS(0,"BookID",BookID,stateid))
		q:stateid="" 
		s ResumeText=$p($g(^DHCDocIPBKS(stateid)),"^",7)
		i ResumeStr=""{
			s ResumeStr=ResumeText
		}else{
			s ResumeStr=ResumeText
			;s ResumeStr=ResumeStr_","_ResumeText
		}
	}
	
    quit ResumeStr
}

/// Creator：    李阳
/// CreatDate：  2008-11-4
/// Description：接口，通过调用此接口 ，将住院证的IsActive设置为N，并把状态更改为住院
/// Input：      
/// 		BookID：住院证ID
/// 		IPaadm：住院ADM的RowID
/// 		UserID:操作员的ID
/// Return：     更新成功返回1，否则返回0
/// Debug:	   w ##class(web.DHCDocIPBookingCtl).PatientArrive(BookID, IPaadm, UserID)
ClassMethod PatientArrive(BookID, IPaadm, UserID)
{
	n (BookID, IPaadm, UserID)
	s ActiveFalse="N"
	quit:BookID="" 0
	quit:$d(^DHCDocIPBK(BookID))=0 0
	set ArriveDicRowID = $o(^DHCDocIPBDIC(0, "TypeCode", "IPBookingState", "Admission", ""))  //住院证状态：已住院
	set ReasonDicRowID = $o(^DHCDocIPBDIC(0, "TypeCode", "IPBookingStateChangeReason", "Admit", ""))  //更改住院证状态原因：住院
	set PLIST(2) = BookID
	set PLIST(3) = ArriveDicRowID
	set PLIST(4) = UserID
	set PLIST(5) = $p($h, "," , 1)
	set PLIST(6) = $p($h, "," , 2)
	set PLIST(7) = ReasonDicRowID
	set PLIST(8) = ""
	s retcode=0
	&sql(Insert into DHCDocIPBKStates values :PLIST())
	s retcode=retcode+SQLCODE
	i retcode=0  d
	.&sql(Update DHCDocIPBooking set EpisodeIDTo = :IPaadm, CurrentStateID = :ArriveDicRowID, IsActive =:ActiveFalse where Rowid=:BookID)
	.s retcode=retcode+SQLCODE
	.i retcode=0  d
	..s retcode=##class(Nur.InService.DHCDocIPAppointment).UpdateIPAppointmentInfo(BookID,IPaadm)
	..;s retcode=##class(web.DHCDocIPAppointment).UpdateIPAppointmentInfo(BookID,IPaadm)
	quit retcode
}

/// CreatDate：  2008-10-24
/// Description：通过ID获取住院证信息
/// Input：      住院证的ID
/// Return：     更新成功返回数据
/// Debug:	  
ClassMethod GetIPBookByID(RowID)
{
	; w ##class(web.DHCDocIPBookingCtl).GetIPBookByID(RowID)
	n (RowID)
	quit:+RowID=0 ""
	quit:$d(^DHCDocIPBK(+RowID))=0 ""
	set ret = $g(^DHCDocIPBK(+RowID))
	if $P(ret,"^",10)=0 Set $P(ret,"^",10)=""
	if $P(ret,"^",10)'="" do
	.set $P(ret,"^",10)=..%ZD($P(ret,"^",10)) //$ZD($P(ret,"^",10),4)
	quit RowID_"^"_ret
}

/// CreatDate：  2008-10-24
/// Description：通过门诊的Paadm取得住院证信息
/// Input：		 门诊的Paadm ID
/// Return：     更新成功返回数据
ClassMethod GetIPBookByPaadm(Paadm, RowID As %String)
{
	s ^RP("IPBook")=Paadm_","_RowID
	;w ##class(web.DHCDocIPBookingCtl).GetIPBookByPaadm(264)
	n (Paadm,RowID)
	i RowID'="" {
		quit ..GetIPBookByID(RowID)
	}else{
		quit ""
		
		quit:Paadm="" ""
		set BookID = $o(^DHCDocIPBK(0, "EpisodeIDFrom", Paadm, ""))
		quit:BookID="" ""
		quit ..GetIPBookByID(BookID)
	}
}

/// Creator：    郭荣勇
/// CreatDate：  2014-8-12
/// Description：通过门诊的Paadm取得住院证信息,如果住院证Rowid为空则默认取最后一条住院证记录
/// Input：		 门诊的Paadm ID
/// Return：     更新成功返回数据
ClassMethod GetIPBookPrtStrByOPAdm(OPAdm As %String, RowID As %String = "", UserID As %String = "") As %String
{
	s ^tmpgry("GetIPBookPrtStrByOPAdm")=OPAdm_","_RowID_","_UserID
	;w ##class(web.DHCDocIPBookingCtl).GetIPBookPrtStrByOPAdm(534,"","600")
	n (OPAdm,RowID,UserID)
	quit:(OPAdm="")&&(RowID="")
	i RowID="" {
		set RowID = $o(^DHCDocIPBK(0, "EpisodeIDFrom", OPAdm, ""),-1)
	}
	quit:RowID="" ""
	
	s PatientID=$p(^DHCDocIPBK(RowID),"^",1)
	s IPBookInfo=..GetIPBookByID(RowID)
	s IPBookPatInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientID)
	
	set PatientName=$p(IPBookPatInfo,"^",3)
	set Sex=$p(IPBookPatInfo,"^",4)
	set Age=$p(IPBookPatInfo,"^",5)
	set PatientNo=$p(IPBookPatInfo,"^",2)
	set Company=$p(IPBookPatInfo,"^",11)
	set NowAddress=$p(IPBookPatInfo,"^",15)
	set Telephone=$p(IPBookPatInfo,"^",25)
	set PatContact=$p(^PAPER(PatientID,"PER",2),"^",13)
	s PatRelation=""
	set PatRelationDR=$p(^PAPER(PatientID,"EMP"),"^",4)
	if PatRelationDR'="" s PatRelation=$p(^CT("RLT",PatRelationDR),"^",2)
	set PatReTel=$p(^PAPER(PatientID,"ALL"),"^",4)
	
	set MRDiagnos=""
	set MRDiagnosID=$p(IPBookInfo,"^",15)
	if MRDiagnosID'="" set MRDiagnos=..GetMRDiagnosByID(MRDiagnosID)
	s PatInDep=""
	set PatInDepDR=$p(IPBookInfo,"^",14)
	if PatInDepDR'="" s PatInDep=$p(^CTLOC(PatInDepDR),"^",2)
	
	set PatInDays=""
	set PatFirHos=""
	
	set PatUserCode=""
	if UserID'="" s PatUserCode=$p(^SSU("SSUSR",UserID),"^",1)
	set PatDate=$p(IPBookInfo,"^",5)
	if (PatDate'="")&(PatDate'["-") s PatDate=..%ZD(PatDate) //$zd(PatDate,3)
	
	s IPBookPrtStr=PatientName_"^"_Sex_"^"_Age_"^"_PatientNo_"^"_Company_"^"_NowAddress_"^"_Telephone_"^"_PatContact_"^"_PatRelation
	s IPBookPrtStr=IPBookPrtStr_"^"_PatReTel_"^"_MRDiagnos_"^"_PatInDep_"^"_PatInDays_"^"_PatFirHos_"^"_PatUserCode_"^"_PatDate
	
	q IPBookPrtStr
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：通过BookID、模板项目代码获得 指定住院证的 附加项目值
/// Input：      
/// 		Paadm：门诊的Paadm ID
/// 		ItemCode:模板项目的Code，对应DHCDocIPBKTempItem表
/// Return：     更新成功返回数据
/// Debug:	   w ##class(web.DHCDocIPBookingCtl).GetBookItemByItemCode(BookID, ItemCode)
ClassMethod GetBookItemByItemCode(BookID, ItemCode)
{
	n (BookID, ItemCode)
	quit:BookID=""!ItemCode="" ""
	set ItemRowID = $o(^DHCDocIPBKTI(0, "ItemCode", ItemCode, ""))
	quit:ItemRowID="" ""
	set DetailID = $o(^DHCDocIPBKD(0, "BookItem", BookID, ItemRowID, ""))
	quit:DetailID="" ""
	set strDetail = $g(^DHCDocIPBKD(DetailID))
	quit $p(strDetail, "^", 3)
}

ClassMethod QueryBookByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryIPBookDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPBookDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QueryBookByDateLoc","2023-01-31","2023-03-08","","","","","18881","2","","","430181900423436")

ClassMethod QueryBookByDateLocExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String = "", PacWardId As %String = "", DocCreateBookId As %String, OrderOrCreateDate As %String, OrdLoc As %String = "", PatName As %String = "", IDCardNo As %String = "") As %Status
{
	n (qHandle, FromDate, ToDate, CtLoc, State,RegNo, PacWardId,DocCreateBookId,OrderOrCreateDate,OrdLoc,%session,IDCardNo,PatName)
	s ^tmpQueryBookByDateLocExecute=$LB(FromDate, ToDate, CtLoc, State, RegNo, PacWardId, DocCreateBookId, OrderOrCreateDate, OrdLoc, PatName, IDCardNo)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s logonUserID=%session.Get("LOGON.USERID")
	k ^TMP("QueryBookByDateLoc",logonUserID)
	if (((FromDate'="")&&(ToDate'=""))){
	//quit:(FromDate="")!(ToDate="") $$$OK
	set RowID = ""
	set tmpDate = ""
	//set:FromDate["/" FromDate = $zdh(FromDate, 4)
	//set:ToDate["/" ToDate = $zdh(ToDate, 4)
	i FromDate'="" s FromDate=..%ZDH(FromDate)
	i ToDate'="" s ToDate=..%ZDH(ToDate)
	if (+OrderOrCreateDate=1){
	if State="" do
	.Set State=##class(web.DHCDocIPBDictionaryCtl).GetStateByGroupDesc(%session.Get("LOGON.GROUPDESC"))  
	
	for tmpDate=FromDate:1:ToDate
	{
		set RowID = ""
		//while 1
		for { 
			//User.DHCDocIPBKDetail
			set RowID = $o(^DHCDocIPBK(0,"BookingDate", tmpDate, RowID))
			quit:RowID=""
			continue:$$checkLogonLoc(RowID)=0
			set strData = $g(^DHCDocIPBK(RowID))
			if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) continue:UsserId'=DocCreateBookId
			continue:(("^"_State_"^")'[("^"_$p(strData,"^",8)_"^"))&(State'="") //状态校验
			//set IP =$g(^PAADM(+$p(strData,"^",3)))
			//set IPLocID = $p(IP, "^", 4)
			//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			s patientId=$p(strData,"^",1)
			continue:patientId=""
			s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			s patientName=$P($G(^PAPER(patientId,"ALL",1)),"^",1)
			continue:(PatName'="")&&(patientName'[PatName)
			s PatientIDCardNo=$P($G(^PAPER(patientId,"PAT",3)),"^",6)
			continue:(IDCardNo'="")&&(IDCardNo'=PatientIDCardNo)
			s admId=$p(strData,"^",2)
			continue:admId=""
			s patiLoc=$p(^PAADM(admId),"^",4)
			continue:(OrdLoc'="")&&(patiLoc'=OrdLoc)
			continue:(RegNo'=patientNo)&(RegNo'="")
			continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="") //&($p(strData,"^",11)'="")
			s ctLocStr=""
			i PacWardId'="" d
			.s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			.i PacWardCTLoc'="" d
			..s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			...i ctLocStr="" s ctLocStr=ctLocId
			...e  s ctLocStr=ctLocStr_"^"_ctLocId
			s isPacWardLink=1
			i (ctLocStr'="")&($p(strData,"^",13)'="") d
			.s linkNum=$L(ctLocStr,"^")
			.f iii=1:1:linkNum d
			..i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			//continue:(PacWardId'="")&isPacWardLink
			continue:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			set PatientLevelID =$P($g(^DHCDocIPBK(RowID)),"^",29)
			if (PatientLevelID="") s PatientLevelID=999
			s indi=PatientLevelID_$E("00000000",1,8-$L(ind))_ind
			set ^CacheTemp(repid, indi) = $$BuildQueryBookInfo(RowID,patientId,ind)
			set ind = ind + 1
		}
	}
		set RowID = ""
		while 1
		{ 
			//User.DHCDocIPBKDetail
			set RowID = $o(^DHCDocIPBK(0,"BookingDate", 0, RowID))
			quit:RowID=""
			continue:$$checkLogonLoc(RowID)=0
			set strData = $g(^DHCDocIPBK(RowID))
			if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) continue:UsserId'=DocCreateBookId
			continue:(("^"_State_"^")'[("^"_$p(strData,"^",8)_"^"))&(State'="") //状态校验
			//set IP =$g(^PAADM(+$p(strData,"^",3)))
			//set IPLocID = $p(IP, "^", 4)
			//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			s patientId=$p(strData,"^",1)
			continue:patientId=""
			s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			s patientName=$P($G(^PAPER(patientId,"ALL")),"^",1)
			
			continue:(PatName'="")&&(patientName'[PatName)
			s PatientIDCardNo=$P($G(^PAPER(patientId,"PAT",3)),"^",6)
			continue:(IDCardNo'="")&&(IDCardNo'=PatientIDCardNo)
			
			s admId=$p(strData,"^",2)
			continue:admId=""
			s patiLoc=$p(^PAADM(admId),"^",4)
			continue:(OrdLoc'="")&&(patiLoc'=OrdLoc)
			
			continue:(RegNo'=patientNo)&(RegNo'="")
			continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="") //&($p(strData,"^",11)'="")
			s ctLocStr=""
			i PacWardId'="" d
			.s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			.i PacWardCTLoc'="" d
			..s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			...i ctLocStr="" s ctLocStr=ctLocId
			...e  s ctLocStr=ctLocStr_"^"_ctLocId
			s isPacWardLink=1
			i (ctLocStr'="")&($p(strData,"^",13)'="") d
			.s linkNum=$L(ctLocStr,"^")
			.f iii=1:1:linkNum d
			..i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			continue:(PacWardId'="")&isPacWardLink
			//continue:(ctLocStr'="")&($p(strData,"^",13)'="")&($P(ctLocStr,$p(strData,"^",13))="")
			continue:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			set PatientLevelID =$P($g(^DHCDocIPBK(RowID)),"^",29)
			if (PatientLevelID="") s PatientLevelID=999
			s indi=PatientLevelID_$E("00000000",1,8-$L(ind))_ind
			set ^CacheTemp(repid, indi) = $$BuildQueryBookInfo(RowID,patientId,ind)
			set ind = ind + 1
			}
	}
	if (+OrderOrCreateDate=2)
	{
		for tmpDate=FromDate:1:ToDate
		{set CreateTime=0 f  set CreateTime= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime)) q:CreateTime=""  d 
			.set CurrentStateID=0 f  set CurrentStateID= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime,CurrentStateID)) q:CurrentStateID=""  d
			..set RowID="" f  set RowID= $o(^DHCDocIPBK(0,"CreateDateTimeState",tmpDate,CreateTime,CurrentStateID,RowID)) q:RowID=""  d
			...quit:RowID=""
			...Quit:$$checkLogonLoc(RowID)=0
			...set strData = $g(^DHCDocIPBK(RowID))
			...if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
			...continue:($p(strData,"^",8)'=State)&(State'="") //状态校验
			...//set IP =$g(^PAADM(+$p(strData,"^",3)))
			...//set IPLocID = $p(IP, "^", 4)
			...//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			...s patientId=$p(strData,"^",1)
			...continue:patientId=""
			...s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			...s patientName=$P($G(^PAPER(patientId,"ALL")),"^",1)
			...q:(PatName'="")&&(patientName'[PatName)
			...s PatientIDCardNo=$P($G(^PAPER(patientId,"PAT",3)),"^",6)
			...q:(IDCardNo'="")&&(IDCardNo'=PatientIDCardNo)
			...s admId=$p(strData,"^",2)
			...q:admId="" 
			...s patiLoc=$p(^PAADM(admId),"^",4)
			...q:(OrdLoc'="")&&(patiLoc'=OrdLoc)
			
			...continue:(RegNo'=patientNo)&(RegNo'="")
			...continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="") //&($p(strData,"^",11)'="")
			...s ctLocStr=""
			...i PacWardId'="" d
			....s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			....i PacWardCTLoc'="" d
			.....s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			......i ctLocStr="" s ctLocStr=ctLocId
			......e  s ctLocStr=ctLocStr_"^"_ctLocId
			...s isPacWardLink=1
			...i (ctLocStr'="")&($p(strData,"^",13)'="") d
			....s linkNum=$L(ctLocStr,"^")
			....f iii=1:1:linkNum d
			.....i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			...//continue:(PacWardId'="")&isPacWardLink
			...continue:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			...set PatientLevelID =$P($g(^DHCDocIPBK(RowID)),"^",29)
			...if (PatientLevelID="") s PatientLevelID=999
			...s indi=PatientLevelID_$E("00000000",1,8-$L(ind))_ind
			...set ^CacheTemp(repid, indi) = $$BuildQueryBookInfo(RowID,patientId,ind)
			...set ind = ind + 1
		
			}
		}
	}
 else
	{		quit:RegNo="" $$$OK
			set RowID="" f  set RowID= $o(^DHCDocIPBK(RowID)) q:RowID=""  d
			.Quit:$$checkLogonLoc(RowID)=0
			.set strData = $g(^DHCDocIPBK(RowID))
			.if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
			.q:($p(strData,"^",8)'=State)&(State'="") //状态校验
			.//set IP =$g(^PAADM(+$p(strData,"^",3)))
			.//set IPLocID = $p(IP, "^", 4)
			.//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			.s patientId=$p(strData,"^",1)
			.q:patientId=""
			.s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			.s patientName=$P($G(^PAPER(patientId,"ALL")),"^",1)
			.q:(PatName'="")&&(patientName'[PatName)
			.s PatientIDCardNo=$P($G(^PAPER(patientId,"PAT",3)),"^",6)
			.q:(IDCardNo'="")&&(IDCardNo'=PatientIDCardNo)
			.s admId=$p(strData,"^",2)
			.q:admId="" 
			.s patiLoc=$p(^PAADM(admId),"^",4)
			.q:(OrdLoc'="")&&(patiLoc'=OrdLoc)
			
			.q:(RegNo'=patientNo)&(RegNo'="")
			.q:($p(strData,"^",11)'=PacWardId)&(PacWardId'="") //&($p(strData,"^",11)'="")
			.s ctLocStr=""
			.i PacWardId'="" d
			..s PacWardCTLoc=$P($G(^PAWARD(PacWardId)),"^",5)
			..i PacWardCTLoc'="" d
			...s ctLocId="" f  s ctLocId=$O(^CTLOC(PacWardCTLoc,"LINK",0,"Loc",ctLocId)) q:ctLocId=""  d
			....i ctLocStr="" s ctLocStr=ctLocId
			....e  s ctLocStr=ctLocStr_"^"_ctLocId
			.s isPacWardLink=1
			.i (ctLocStr'="")&($p(strData,"^",13)'="") d
			..s linkNum=$L(ctLocStr,"^")
			..f iii=1:1:linkNum d
			..i $P(ctLocStr,"^",iii)=$p(strData,"^",13) s isPacWardLink=0
			.//q:(PacWardId'="")&isPacWardLink
			.//continue:(ctLocStr'="")&($p(strData,"^",13)'="")&($P(ctLocStr,$p(strData,"^",13))="")
			.q:($p(strData,"^",13)'=CtLoc)&(CtLoc'="")&(CtLoc'="115")
			.set PatientLevelID =$P($g(^DHCDocIPBK(RowID)),"^",29)
			.if (PatientLevelID="") s PatientLevelID=999
			.s indi=PatientLevelID_$E("00000000",1,8-$L(ind))_ind
			.set ^CacheTemp(repid, indi) = $$BuildQueryBookInfo(RowID,patientId,ind)
			.set ind = ind + 1
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
checkLogonLoc(BookID)
	Set LogonLoc=%session.Get("LOGON.CTLOCID")
	Set TargetDepId=$p(^DHCDocIPBK(BookID),"^",13)
	Set TargetHospId=##class(web.DHCDocCommon).GetHospIdByLocId(TargetDepId)
	Set LoginHospId=##class(web.DHCDocCommon).GetHospIdByLocId(LogonLoc)
	Quit:TargetHospId'=LoginHospId 0
	Quit:($o(^PAC("ADMLOC",0,"AdmType","O",LogonLoc,0))'="")&&(+$p($g(^DHCDocIPBK(BookID)), "^", 6)'=DocCreateBookId&&(DocCreateBookId'="")) 0
	Quit 1
BuildQueryBookInfo(BookID,patientId,ind)
	n (BookID,patientId,%session,ind)
	Set langid=..%LanguageID()
	set strData = $g(^DHCDocIPBK(BookID))
	//取到预约日期
	Set dtBookingDate=$P(##class(web.DHCDocIPBookingCtl).GetIPBookByID(BookID),"^",11)
	//if $P(##class(web.DHCDocIPBookingCtl).GetIPBookByID(BookID),"^",11)'="" do
	//.set dtBookingDate=$ZD($ZDH($P(##class(web.DHCDocIPBookingCtl).GetIPBookByID(BookID),"^",11),4),3)
	//取得卡号
	
	s patNo=##class(web.DHCDocCommon).GetCardNoByPAPER("LAST","",patientId,"")
	
	set Patient = ##class(web.DHCDocIPBBaseCtl).GetPatInfo(+$p(strData, "^", 1),$p(strData,"^",2))
	set OP = ##class(web.DHCDocIPBBasePaadmCtl).GetAdmInfo(+$p(strData,"^",2))
	Set IP = ##class(web.DHCDocIPBBasePaadmCtl).GetAdmInfo(+$p(strData,"^",3))
	set Doctor = ##class(web.DHCDocIPBBaseCtl).GetUsrStr(+$p(strData, "^", 7))
	set User = ##class(web.DHCDocIPBBaseCtl).GetUsrStr(+$p(strData, "^", 6))
	set State = $g(^DHCDocIPBDIC(+$p(strData, "^", 8)))
	set StateDesc = $p(State,"^",2)
	s StateDesc=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",StateDesc,langid)
	set DiagnoseID=$p(strData, "^", 14) //add by lxf 2008-11-12
	set data = $lb("")
	set $li(data, 1) = BookID
	set $li(data, 2) = $p(Patient, $c(2), 23)
	set $li(data, 3) = $p(Patient, $c(2), 22)
	set $li(data, 4) = $p(Patient, $c(2), 1)
	set $li(data, 5) = $p(Patient, $c(2), 2)
	set $li(data, 6) = $p(Patient, $c(2), 4)
	set $li(data, 7) = $p(OP, "^", 4)
	//set $li(data, 8) = $p($p(IP, "^", 7),"/",2)
	set ctLocId=$p(strData, "^", 13)
	if ctLocId'="" d
	.s ctLocDesc=$P($G(^CTLOC(ctLocId)),"^",2) 
	.s ctLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctLocDesc,langid)
	.s ctLocDesc=##class(web.DHCOPAdmReg).LocDescFormate(ctLocDesc)
	e  s ctLocDesc=""
	set $li(data, 8)=$G(ctLocDesc)
	set IsCanAdmission=0 //是否可办理入院
	s CurrentState=$p(State, "^", 2)
	s CurrentStateCode=$p(State, "^", 1)
	if (CurrentStateCode="Void"){
		s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",BookID,""))
		if (IPAppID'=""){
			s CancleReasonDr=$p($g(^DHCDocIPApp(IPAppID)),"^",13)
			if (CancleReasonDr'=""){
				s CancleReason=$p($g(^DHCDocIPCR(CancleReasonDr)),"^",2)
				i CancleReason'="" s CurrentState=CurrentState_"("_CancleReason_")"
			}
		}
	}
	set CTLOCBeInHospitalF=$p($g(^CTLOC(ctLocId)),"^",87)
	if (CTLOCBeInHospitalF="Y"){
		if (CurrentState="签床") set IsCanAdmission=1
	}else{
		if (CurrentState="申请")||(CurrentState="预约")||(CurrentState="签床") set IsCanAdmission=1
	}
	//始终获取住院证信息
	set WardDesc=""
	//Set WardDesc=$p(IP, "^", 9)
	//if WardDesc=""{
		Set WardId=$p(strData, "^", 11)	
		if WardId'="" d
		.Set WardDesc=$p($g(^PAWARD(WardId)),"^",2) 
		.s WardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",WardDesc,langid)
		.s WardDesc=##class(web.DHCOPAdmReg).LocDescFormate(WardDesc)
	//}
	set $li(data, 9) =WardDesc     //$p(IP, "^", 9)
	set $li(data, 10) = $p(Doctor, "/", 3)
	set $li(data, 11) = $p(User, "/", 3)
	if CurrentState["(" d
	.s CurrentState=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",$p(CurrentState,"("),langid)_"("_..%Translate("doc.ipbookquery.hui.csp",$p($p(CurrentState,"(",2),")",1),langid)_")"
	e  d
	.s CurrentState=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",CurrentState,langid)
	set $li(data, 12) = CurrentState //$p(State, "^", 2)
	set $li(data, 13) = $p(Patient, $c(2), 11) //工作单位
	set $li(data, 14) = $p(Patient, $c(2), 18) //地址
	set $li(data, 15) = $p(Patient, $c(2), 5) //身份证号
	set $li(data, 16) = ..GetBookItemByItemCode(BookID, "Days") //与预计住院天数
	;set $li(data, 17) = ..GetBookItemByItemCode(BookID, "Diagnose") //门诊诊断
	i DiagnoseID'="" set $li(data, 17) = ..GetMRDiagnosByID(DiagnoseID) //门诊诊断 modify by lxf 2008-11-12
	set $li(data, 18) = $p(strData, "^", 2)
	set wardId=$p(strData, "^", 11)
	if wardId'="" d
	.Set wardDesc=$P($G(^PAWARD(wardId)),"^",2)
	.s wardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",wardDesc,langid)
	e  set wardDesc=""
	set $li(data, 19) = $G(wardDesc)
	//set $li(data, 20) = $p(strData, "^", 12)
	i wardId'="" d
	.s bedState=..GetPacBedState(wardId)
	.i bedState=0 set $li(data, 20) ="满"
	.e  set $li(data, 20) ="空"
	e  set $li(data, 20) =""
	set $li(data, 21) = ..%ZD($p(strData, "^", 10)) //$ZD($p(strData, "^", 10),3)
	set $li(data, 22) = ..GetBookItemByItemCode(BookID, "IPDeposit") //预交金
	set $li(data, 23) =dtBookingDate  //预约日期
	set $li(data, 24) =patNo	//卡号
	Set phone=$p($g(^PAPER(patientId,"PER",1)),"^",11)
	Set $li(data,25)=phone
	set EpisodeIDOP=$P(OP,"^",1) i EpisodeIDOP=0 s EpisodeIDOP=""
	set EpisodeIDIP=$P(IP,"^",1) i EpisodeIDIP=0 s EpisodeIDIP=""
	set $li(data, 26) =EpisodeIDOP
	set $li(data, 27) =EpisodeIDIP
	set $li(data,28)=""
	set tmpAdmType=""
	i EpisodeIDOP'=""{
		set tmpAdmType=$p(^PAADM(+EpisodeIDOP),"^",2)
		s:tmpAdmType="O" $li(data,28)="门诊"
		i (tmpAdmType="E"){
		  Set WardDesc=$p(OP, "^", 9)
		  s:WardDesc="" $li(data,28)="急诊留观"
		  s:WardDesc'="" $li(data,28)="急诊"
		}
	}
	;入院病情
	s PriorityCondtion=""
	s PriorityCondtionId=$p(strData, "^", 16)
	i PriorityCondtionId'="" {
		s PriorityCondtion=$p(^PAC("REFPRI",PriorityCondtionId),"^",2)
		Set PriorityCondtion=##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc",PriorityCondtion,langid)
	}
	set $li(data,29)=PriorityCondtionId
	set $li(data,30)=PriorityCondtion
	
	//新住院证-获取诊断描述
	s BookSrt=##class(web.DHCDocIPBookNew).GetBookMesage(BookID)
	s DiaDescStr=""
	s DiaList=$P(BookSrt,"^",37)
	for IDia=1:1:$L(DiaList,"!")  d
	.s Desc1=$P($P(DiaList,"!",IDia),$C(2),2)
	.if DiaDescStr="" s DiaDescStr=Desc1
	.else  s DiaDescStr=DiaDescStr_","_Desc1
	set $li(data, 17) =DiaDescStr //诊断描述
	set $li(data,29)=$P(BookSrt,"^",21) //入院病情ID
	s PriorityCondtion=$P(BookSrt,"^",33) //病情描述
	Set PriorityCondtion=##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc",PriorityCondtion,langid)
	set $li(data,30)=PriorityCondtion //病情描述
	set $li(data,31)=$p(Patient, $c(2),28) //TPAPMICardType=
	set TabWaitDate=""
	set BookingDate = $P($g(^DHCDocIPBK(+BookID)),"^",10)
	if BookingDate'="" {
		s StateIDDCode=""
		s CurrentStateID=$p(^DHCDocIPBK(BookID),"^",8) ;住院证状态
		s:CurrentStateID'="" StateIDDCode=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",1)
		if (StateIDDCode="Admission"){
			s EpisodeIDTo=$P(BookSrt,"^",4)
			s EpisodeIDToAdmDate=$p(^PAADM(EpisodeIDTo),"^",6)
			s TabWaitDate=EpisodeIDToAdmDate-BookingDate
		}elseif (StateIDDCode="Cancel"){
			s TabWaitDate=0
		}else{
			s TabWaitDate=..%SysDate()-BookingDate
		}
	}
	if TabWaitDate<0 s TabWaitDate=0
	set $li(data,32)=TabWaitDate
	set $li(data,33)=IsCanAdmission
	s logonUserID=%session.Get("LOGON.USERID")
	set $li(data, 34) = $P($p(IP, "^", 7),"/",2)
	;患者等级
	set PatientLevel=""
	set PatientLevelID =$P($g(^DHCDocIPBK(+BookID)),"^",29)
	if PatientLevelID'="" s PatientLevel=$P(^DHCDocIPBDIC(PatientLevelID),"^",2)
	s PatientLevel=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",PatientLevel,langid)
	set $li(data, 35) = PatientLevel
	Set ^TMP("QueryBookByDateLoc",logonUserID,ind)=$p(Patient,$c(2),23)_"^"_$p(Patient,$c(2),1)_"^"_$p(Patient,$c(2),2)_"^"_$p(Patient,$c(2),4)_"^"_$p(Patient,$c(2),5)_"^"_$p(Patient,$c(2),11)_"^"_$p(Patient,$c(2),18)_"^"_$p(OP, "^", 4)_"^"_$g(ctLocDesc)_"^"_$g(WardDesc)_"^"_$p(Doctor,"/",3)_"^"_..GetBookItemByItemCode(BookID,"Days")_"^"_DiaDescStr_"^"_StateDesc_"^"_$p(User,"/",3)_"^"_$p(Patient, $c(2), 28)_"^"_$P(BookSrt,"^",33)_"^"_TabWaitDate_"^"_PatientLevel
	
	quit data
}

/// 显示附加项的Query
/// 如果BookID不为空，显示附加项目结果   TemplateID不为空 显示空模板 
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QueryIPBookDetail",3,1)
ClassMethod QueryIPBookDetailExecute(ByRef qHandle As %Binary, BookID As %String, TemplateID As %String) As %Status
{
	n (qHandle, BookID, TemplateID)

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(BookID="")&(TemplateID="") $$$OK
	if (BookID '= "")&(($d(^DHCDocIPBKD(0, "BookItem", +BookID)) '= 0))
	{
		set ItemID = ""
		while (1)
		{
			set ItemID = $o(^DHCDocIPBKD(0, "BookItem", +BookID, ItemID))
			quit:ItemID=""
			b ;	quit:ItemID=""
			set RowID = ""
			while (1)
			{
				set RowID = $o(^DHCDocIPBKD(0, "BookItem", +BookID, ItemID, RowID))
				quit:RowID=""
				set data = $$BuildDetail(ItemID, RowID)
				set ^CacheTemp(repid, ind) = data
				set ind = ind + 1
				b ;	set ind = ind + 1
			}
		}
		quit $$$OK
	}
	b //002
	if (TemplateID '= "")
	{
			set RowID = ""
			set ItemID = ""
			while (1)
			{
				set ItemID = $o(^DHCDocIPBKTD(0, "TempItem", TemplateID, ItemID)) 
				quit:ItemID=""
				set RowID = ""
				while (1)
				{
					set RowID = $o(^DHCDocIPBKTD(0, "TempItem", TemplateID, ItemID, RowID)) 
					quit:RowID=""
					set data = $$BuildTemplate(RowID)
					set ^CacheTemp(repid, ind) = data
					set ind = ind + 1	
				}
			}
		quit $$$OK
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDetail(ItemID, DetailID)
 //Item 项目,ToolTip提示,Value:值,IsNeed必输项目,ResumeText备注,ItemDr,RowID,ItemCode,         DataType
 //首诊科室:            :      :     N:                        :1     :9:    FristVisitHospital:String:
 //首诊科室:::                       N:                        :1:    197:   FristVisitHospital:String:
 //首诊科室:            :222:        N:                        :1:    213:   FristVisitHospital:String:
	n (ItemID, DetailID)
	set strData = $g(^DHCDocIPBKD(DetailID))
	set ItemData = $g(^DHCDocIPBKTI(ItemID))
	set DataType = $g(^DHCDocIPBDIC(+$p(ItemData, "^", 3)))
	set data = $lb("")
	set $li(data, 1) = $p(ItemData, "^", 2)
	set $li(data, 2) = ""
	set $li(data, 3) = $p(strData, "^", 3)
	set $li(data, 4) = "N"
	set $li(data, 5) = $p(ItemData, "^", 6)
	set $li(data, 6) = ItemID
	set $li(data, 7) = DetailID
	set $li(data, 8) = $p(ItemData, "^", 1) //Item Code
	set $li(data, 9) = $p(DataType, "^", 1)
	quit data
	
BuildTemplate(TemplateDtlID)
	n (TemplateDtlID)
	set strData = $g(^DHCDocIPBKTD(TemplateDtlID))
	set ItemData = $g(^DHCDocIPBKTI(+$p(strData,"^",2)))
	set DataType = $g(^DHCDocIPBDIC(+$p(ItemData, "^", 3)))
	set data = $lb("")
	set $li(data, 1) = $p(ItemData, "^", 2)
	set $li(data, 2) = $p(strData, "^", 5)
	set $li(data, 3) = $p(strData, "^", 3)
	set $li(data, 4) = $p(strData, "^", 4)
	set $li(data, 5) = $p(ItemData, "^", 6)
	set $li(data, 6) = $p(strData,"^",2)
	set $li(data, 7) = ""
	set $li(data, 8) = $p(ItemData, "^", 1) //Item Code
	set $li(data, 9) = $p(DataType, "^", 1)
	//w !,DataType
	quit data
}

ClassMethod QueryBookByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookByDateLocExecute ]
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

ClassMethod QueryIPBookDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPBookDetailExecute ]
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

ClassMethod QueryStateByBookIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStateByBookIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：通过日期、科室、登记号、状态、病房号查询住院证
/// Input：      
/// 		FromDate：开始日期, 
/// 		ToDate：结束日期, 
/// 		CtLoc：科室, 
/// 		State：状态, 
/// 		RegNo：登记号
/// 		PacWardIdD：病房ID 
Query QueryBookByDateLoc(FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String, PacWardId As %String, DocCreateBookId As %String, OrderOrCreateDate As %String, OrdLoc As %String = "", PatName As %String = "", IDCardNo As %String = "") As %Query(ROWSPEC = "RowID:%String,RegNo:%String:登记号,PatientID:%String,PatientName:%String:病人姓名,Sex:%String:性别,Age:%String:年龄,OPDate:%String:门诊日期,IPDep:%String:住院科室,IPLoc:%String:住院科室,InputDoctor:%String:医师,InputUser:%String:录入人,CurrentState:%String:当前状态,Company:%String:工作单位,Address:%String:家庭住址,PersonalID:%String:身份证号,Days:%String:预计住院天数,Diagnose:%String:门诊诊断,OPAdm:%String,PacWard:%String,PacBed:%String,BookingDate:%String,IPDeposit:%String,dtBookingDate:%String,patNo:%String,phone:%String,EpisodeIDOP:%String,EpisodeIDIP:%String,Source:%String,PriorityCondtionId:%String,PriorityCondtion:%String,TPAPMICardType:%String,TabWaitDate:%String,IsCanAdmission:%String,ConIPDep:%String,PatientLevel:%String ")
{
}

ClassMethod QueryStateByBookIDExecute(ByRef qHandle As %Binary, BookID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:BookID="" $$$OK
	s RowID = ""
	f  s RowID=$o(^DHCDocIPBKS(0, "BookID",+BookID,RowID),-1) q:RowID=""  d
	.s Data=$$BuildStateInfo(RowID)
	.s ^CacheTemp(repid,ind)=Data
	.s ind =ind+1
	q $$$OK
	
BuildStateInfo(RowID)
	n (RowID)
	s strData=$g(^DHCDocIPBKS(+RowID))
	s StateDic=$g(^DHCDocIPBDIC(+$p(strData,"^",2)))
	s ReasonDic=$g(^DHCDocIPBDIC(+$p(strData,"^",6)))
	s User=##class(web.DHCDocIPBBaseCtl).GetUsrStr(+$p(strData,"^",3))
	
	s data=$lb("")
	s $li(data,1)=RowID
	s $li(data,2)=$p(StateDic,"^",2)
	s $li(data,3)=$p(ReasonDic,"^",2)
	s $li(data,4)=$p(User,"/",3)
	s $li(data,5)=..%ZD(+$p(strData,"^",4)) //$zd(+$p(strData,"^",4),3)
	s $li(data,6)=..%ZT(+$p(strData,"^",5),2)
	s $li(data,7)=$p(strData,"^",7)
	q data
}

/// CreatDate：  2008-10-24
/// Description：显示住院证的附加信息
/// Input：      
/// 		BookID:住院证ID
/// 		TemplateID：住院证附加项目模板ID
/// Return：     如果指明BoookID，显示已经保存的附加项目。否则读取模板信息，显示一个空的表格等待填写。
Query QueryIPBookDetail(BookID As %String, TemplateID As %String) As %Query(ROWSPEC = "Item:%String:项目,ToolTip:%String:提示,Value:%String:值,IsNeed:%String:必输项目,ResumeText:%String:备注,ItemDr:%String,RowID:%String,ItemCode:%String,DataType:%String")
{
}

ClassMethod QueryStateByBookIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStateByBookIDExecute ]
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

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：显示住院证的状态历史
/// Input：      
/// 		BookID:住院证ID
Query QueryStateByBookID(BookID As %String) As %Query(ROWSPEC = "RowID:%String,OpeName:%String:状态名称,Reason:%String:原因,Operator:%String:操作员,OpeDate:%String:日期,OpeTime:%String:时间,ResumeText:%String:备注")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-04
/// Description：通过就诊卡卡号获得登记号
/// Input：      就诊卡卡号
/// Return：     登记号
/// Debug:	     w ##class(web.DHCDocIPBookingCtl).GetRegNoByCardNo(cardNo) 
ClassMethod GetRegNoByCardNo(cardNo As %String = "") As %String
{
	q:cardNo="" ""
	s ind=$O(^DHCCARDi("CF",0,"CardNo",cardNo,""))
	q:ind="" ""
	q:'$d(^DHCCARD("CF",ind)) ""
	q:$p($g(^DHCCARD("CF",ind)),"^",10)'="N" ""
	s patientId=$p($g(^DHCCARD("CF",ind)),"^",6)
	q:patientId="" ""
	s papmiDr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientId),""))
	s regNo=$p(^PAPER(papmiDr,"PAT",1),"^",2)
	q regNo
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-04
/// Description：格式化登记号
/// Input：      登记号
/// Return：     格式化后的登记号，格式化位数
/// Debug:	     w ##class(web.DHCDocIPBookingCtl).RegNoCon(RegNo) 
ClassMethod RegNoCon(RegNo As %String) As %String
{
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(RegNo)<len d
	.s prelen=len-$l(RegNo)
	.for i=1:1:prelen s RegNo="0"_RegNo
	Q RegNo
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-04
/// Description：提供住院登记时接口程序
/// Table：      DHCDocIPBooking，DHCDocIPBKDetail,DHCDocIPBKTempItem 
/// Input：      IPBookID(住院证ID)
/// Output：     科室ID^病区ID^床位ID^医生ID^预交金
/// 		     预交金数值在表DHCDocIPBKDetail中，其他在表DHCDocIPBooking中
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetIPBKPatInfo(IPBookID)
ClassMethod GetIPBKPatInfo(IPBookID As %String) As %String
{
	;n (EpisodeIDFrom)
	;s ret="^^^^"
	;q:EpisodeIDFrom="" ret
	;q:'$d(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeIDFrom)) ret
	;s IPBookID=""
	;s IPBookID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeIDFrom,IPBookID))
	n (IPBookID)
	s ret="^^^^^^^"
	q:'$d(^DHCDocIPBK(IPBookID)) ret
	s str=$g(^DHCDocIPBK(IPBookID))
	s EpisodeIDFrom=$p(str,"^",2)	//门诊就诊Rowid
	s EpisodeIDTo=$p(str,"^",3)		//住院就诊Rowid
	s CtlocID=$p(str,"^",13)		//科室ID
	s WardID=$p(str,"^",11)			//病区ID
	s BedID=$p(str,"^",12)			//床位ID
	s DocID=$p(str,"^",7)			//医生ID
	s DiagnoseID=$p(str,"^",14) 	//诊断ID
	s TemplateItemCode="IPDeposit" 	//取预交金金额约定代码
	s CreaterUserID=$p(str,"^",6) 	//创建住院证人
	s DocID=$P($G(^SSU("SSUSR",DocID)),"^",14)
	s MRCCondtion=$p(str,"^",16)
	s IPDeposit=""
	i $d(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode)) {
		s ItemID=$o(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode,""))
		i $d(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID)) {
			s DetailID=""
			s DetailID=$o(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID,DetailID))
			i DetailID'=""  d
			.s IPDeposit=$p($g(^DHCDocIPBKD(DetailID)),"^",3)
		}
	}
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit_"^"_DiagnoseID_"^"_EpisodeIDFrom_"^"_EpisodeIDTo_"^"_CreaterUserID_"^"_MRCCondtion
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-05
/// Description：根据门诊就诊号查询paadm表paadm_papmi_dr，然后看paadm表中是否存在
/// 			 对应的住院记录(即paadm_type=“I”,paadm_visitstatus=“A”)
/// Table：      pa_adm
/// Input：      EpisodeID
/// Return：     1(存在)/0(不存在)/-1(Error)
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).IfInPatient("")
ClassMethod IfInPatient(EpisodeID)
{
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	n (EpisodeID)
	s ret=-1
	q:EpisodeID="" ret
	q:'$d(^PAADM(EpisodeID)) ret
	s str=$g(^PAADM(EpisodeID))
	s PAPMIDr=$p(str,"^",1)
	s PAADMType="I"
	s IPEpisodeID=""
	f  s IPEpisodeID=$o(^PAPERdr(PAPMIDr,"ADM",PAADMType,IPEpisodeID))  q:IPEpisodeID=""  d
	.s strInPat=$g(^PAADM(IPEpisodeID))
	.s PAADMVisitStatus=$p(strInPat,"^",20)
	.;w !,"PAADMVisitStatus"_PAADMVisitStatus
	.i PAADMVisitStatus="A" d
	..s ret=1
	.e  d
	..s ret=0
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-09
/// Description：根据ct_loc表RowID取科室描述
/// Table：      ct_loc
/// Input：      RowID
/// Return：     Desc
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetCTLocDescByID("")
ClassMethod GetCTLocDescByID(RowID)
{
	n (RowID)
	q:RowID=""
	s Desc=""
	q:'$d(^CTLOC(RowID)) Desc
	s str=$g(^CTLOC(RowID))
	s Desc=$p(str,"^",2)
	if Desc["-" Set Desc=$p(Desc,"-",2)
	q Desc
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-10
/// Description：根据PA_ADM表RowID获取就诊诊断(只能获取一个诊断，华西用，不可通用)
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetMRDiagnosByEpisodeID(EpisodeID)
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID)
{
	q:+EpisodeID=0 ""
	n (EpisodeID)
	s MRDiagnos=""
	s mradmId=$P(^PAADM(+EpisodeID),"^",61)
	;w !,mradmId
	s mrdiaSub=0
	;取所有诊断程序
	;f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
	;.s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	;.q:MRDIAICDCodeDR=""
	;.i MRDiagnos="" d
	;..s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	;.e  d
	;..s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	
	s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")
	s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	q:MRDIAICDCodeDR=""
	s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	q MRDIAICDCodeDR_"^"_MRDiagnos
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-10
/// Description：根据RowID获取就诊诊断名称
/// Table：      MRC_ICDDx
/// Input：      RowID
/// Return：     MRDiagnos
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetMRDiagnosByID("")
ClassMethod GetMRDiagnosByID(RowID)
{
	n (RowID,%session)
	q:RowID="" ""
	Set langid=..%LanguageID()
	s MRDiagnos=""
	s str=$g(^MRC("ID",RowID))
	s Desc=$p(str,"^",2)
	s Desc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",Desc,langid)
	q Desc
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-11
/// Description：根据WARD_LocationDR(指向CT_Loc)获取PAC_Ward的RowID
/// Table：      PAC_Ward
/// Input：      WARDLocDR
/// Return：     PACWardRowID
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetWardRowIDByLocDR(WARDLocDR)
ClassMethod GetWardRowIDByLocDR(WARDLocDR)
{
	;^PAWARD(0,"WARD_LocationDR",{WARD_LocationDR},{WARD_RowID})
	n (WARDLocDR)
	q:WARDLocDR=""
	s PACWardRowID=0
	q:'$d(^PAWARD(0,"WARD_LocationDR",WARDLocDR))
	s PACWardRowID=$o(^PAWARD(0,"WARD_LocationDR",WARDLocDR,PACWardRowID))
	q PACWardRowID
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-13
/// Description：获取医院名称
/// Table：      
/// Input：      
/// Return：     HospName
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetHospName()
ClassMethod GetHospName()
{
	s HospName=""
	s HospName=$o(^CT("HOSP",0,"Desc",HospName))
	q HospName
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-12
/// Description：根据PersonID获取联系人关系
/// Table：      CT_Relation
/// Input：      PersonID
/// Return：     RelationID^RelationDesc
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetRelationByPersonID(PersonID)
ClassMethod GetRelationByPersonID(PersonID)
{
	n (PersonID)
	q:PersonID=""
	q:'$d(^PAPER(PersonID,"EMP"))
	s RelationID=$p($g(^PAPER(PersonID,"EMP")),"^",4)
	q:RelationID=""
	q:'$d(^CT("RLT",RelationID))
	s str=$g(^CT("RLT",RelationID))
	s RelationDesc=$p(str,"^",2)
	q RelationID_"^"_RelationDesc
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-13
/// Description：根据PersonID获取联系人电话
/// Table：      CT_Relation
/// Input：      PersonID
/// Return：     RelationID^RelationDesc
/// Debug:		 w ##class(web.DHCDocIPBookingCtl).GetFPhoneByPersonID(PersonID)
ClassMethod GetFPhoneByPersonID(PersonID)
{
	n (PersonID)
	q:PersonID=""
	q:'$d(^PAPER(PersonID,"ALL"))
	s FPhone=$p($g(^PAPER(PersonID,"ALL")),"^",4)
	q FPhone
}

ClassMethod QueryRelationAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRelationAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryRelationAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Rowid=0
	f  s Rowid=$o(^CT("RLT",Rowid)) q:Rowid=""  d
	.s str=$g(^CT("RLT",+Rowid))
	.s Code=$p(str,"^",1)
	.s Desc=$p(str,"^",2)
	.s DateFrom=$p(str,"^",3)
	.s DateTo=$p(str,"^",4)
	.s str=Desc_"^"_Rowid
    .d BuildData
    Quit $$$OK
    
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(str,"^") d
 	.s $li(Data,iBuild)=$p(str,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryRelationAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRelationAllExecute ]
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

/// Creator：    刘学峰
/// CreatDate：  2008-11-13
/// Description：查询CT_Relation中所有关系名称
/// Table：      CT_Relation
/// Input：      无
/// Output：     Rowid,Desc
Query QueryRelationAll() As %Query(ROWSPEC = "Desc,Rowid")
{
}

ClassMethod GetPacBedState(wardid)
{
	n (wardid)
	q:wardid=""
	s ret=0
	s bedno=""
	s stdate=..%SysDate()
	s bedid="0"  
	f  s bedid=$o(^PAWARD(wardid,"BED",bedid))  q:bedid=""   d
	.s beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.s datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	.s dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	.q:(datefrom'="")&(stdate<datefrom)
	.q:(dateto'="")&(stdate>dateto)
	.s roomid=$p(^PAWARD(wardid,"BED",bedid),"^",3)
	.q:($d(^PAROOM(roomid))=0)
	.s rmdtfrom=$p(^PAROOM(roomid),"^",8)
	.s rmdtto=$p(^PAROOM(roomid),"^",9)
	.q:(rmdtfrom'="")&(stdate<rmdtfrom)
	.q:(rmdtto'="")&(stdate>rmdtto)
	.s flag=..checkini(wardid,bedid)
	.q:flag["N"
	.s roomtypeid=$p(^PAROOM(roomid),"^",3)
	.q:(roomtypeid="")
	.q:($d(^PAC("ROOMT",roomtypeid))=0)
	.s roomtype=$p(^PAC("ROOMT",roomtypeid),"^",2)
	.s roomdesc=$p(^PAROOM(roomid),"^",2)
	.s bedtypeid=$p(^PAWARD(wardid,"BED",bedid),"^",2)
	.q:(bedtypeid="")
	.q:($d(^PAC("BEDTP",bedtypeid))=0)
	.s bedtype=$p(^PAC("BEDTP",bedtypeid),"^",2)
	.s bedrowid=wardid_"||"_bedid
	.&sql(select BED_Available into :bedavail 
	      from pac_bed where bed_rowid=:bedrowid)
	.s bedavail=$p(bedavail,$c(1))
	.q:bedavail="N"
	.i bedavail="N"  d
	..s bedstatus="使用中"
	.e  d 
	..s bedstatus="空"
	.q:(bedstatus="使用中")
	.s warddesc=$p(^PAWARD(wardid),"^",2)
	.s ret=ret+1
	q ret
}

ClassMethod checkini(ward, bed) As %String
{
	n (ward,bed)
	q:($g(ward)="")||($g(bed)="") ""
	s falg=""
	s inidate=..%SysDate()+1
	f  s inidate=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate),-1)  q:(inidate="")||(falg="N")  d
	.s initime=""
	.s:inidate=..%SysDate() initime=+..%SysTime()+1
	.f  s initime=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime),-1)  q:(initime="")||(falg="N")  d
	..s sub=""
	..f  s sub=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime,sub),-1)  q:(sub="")||(falg="N")  d 
	...s dateto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",5)
	...s:+dateto=0 falg="N"
	...s timeto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",6)
	...q:((+dateto<+$h)||((dateto=..%SysDate())&&(timeto<+..%SysTime())))
	...s falg="N"
    q falg
}

/// w ##Class(web.DHCDocIPBookingCtl).CheckCardIsTemp(2192117)
ClassMethod CheckCardIsTemp(EpisodeID) As %String
{
	n (EpisodeID)
	s tempType=""
	s retFlag=0
	&sql(select CTD_RowID into :tempType from sqluser.dhc_cardtypedef where CTD_Code='02')
	s str=$g(^PAADM(EpisodeID))
	s PAPMIDr=$p(str,"^",1)
	s CardDr=""
	f  s CardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDr,CardDr)) q:CardDr=""  d
	.q:$p($g(^DHCCARD("CF",CardDr)),"^",10)'="N"
	.b
	.i $p($g(^DHCCARD("CF",CardDr)),"^",16)=tempType s retFlag=1
	q retFlag
}

/// Creator：    刘学峰
/// CreatDate：  2009-01-07
/// Description：(电子病历组使用接口程序)根据本次住院的就诊号（paadm）查询住院证信息
/// Table：      DHCDocIPBooking 住院证表
/// Input：      Paadm：住院的Paadm RowId
/// Return：     RowID^PatientID^EpisodeIDFrom^EpisodeIDTo^CreateDate^CreateTime^CreateUserID^CreateDocID^CurrentStateID^IsActive^BookingDate^Text1^Text2^Text3^Text4^ResumeText
/// 		顺序	字段名称			说明				指向表
/// 		1		RowID				RowID		
/// 		2		PatientID			PA_PatMas.RowID		PA_PatMas
/// 		3		EpisodeIDFrom		门诊就诊PAADM RowID	PA_ADM
/// 		4		EpisodeIDTo			住院就诊PAADM RowID	PA_ADM
/// 		5		CreateDate			建住院证日
/// 		6		CreateTime			建住院证时间	
/// 		7		CreateUserID		建住院证操作员ID 	SS_User
/// 		8		CreateDocID			建住院证医师ID		SS_User
/// 		9		CurrentStateID		当前状态ID 			DR	DHC_MedDictory
/// 		10		IsActive			有效状态			
/// 		11		BookingDate			预约日期				
/// 		12		Text1				病区ID				PAC_Ward
/// 		13		Text2				床位ID				PAC_Bed
/// 		14		Text3				科室ID				CT_Loc
/// 		15		Text4				诊断ID				MRC_ICDDx
/// 		16		ResumeText			备注	
/// 		下面FristVisitHospital和Days为表住院证明细表DHCDocIPBKDetail中数据
/// 		17      FristVisitHospital  首诊医院            
/// 		18      Days                预计住院天数        
/// Debug: w ##class(web.DHCDocIPBookingCtl).IGetIPBookByIPPaadm(2347560)
ClassMethod IGetIPBookByIPPaadm(Paadm)
{
	n (Paadm)
	s ret=""
	q:Paadm="" ret
	
	s BookID=$o(^DHCDocIPBK(0, "EpisodeIDTo", Paadm, ""),-1)
	q:BookID="" ret
	q:'$d(^DHCDocIPBK(+BookID)) ret
	s IPBookData = $g(^DHCDocIPBK(+BookID))

    //下面取 “首诊医院” 和 “预计住院天数”
	s ItemCode="FristVisitHospital" ;“首诊医院”约定Code
	s IPBKDetail=..IGetIPBKDtlByCode(BookID,ItemCode)
	s FristVisitHospital=$p(IPBKDetail,"^",4)
	
	s ItemCode="Days" ;“预计住院天数"约定Code
	s IPBKDetail=..IGetIPBKDtlByCode(BookID,ItemCode)
	s Days=$p(IPBKDetail,"^",4)
	
	q BookID_"^"_IPBookData_"^"_FristVisitHospital_"^"_Days
}

/// Creator：    刘学峰
/// CreatDate：  2009-01-09
/// Description：(电子病历组使用接口程序)供IGetIPBookByIPPaadm(Paadm)方法调用
/// Table：      DHCDocIPBKTempItem住院证模板项目字典表、DHCDocIPBKDetail住院证明细表
/// Input：      BookID：住院证RowId，ItemCode：DHCDocIPBKTempItem表中ItemCode字段
/// Return：     RowID^BookID^ItemID^ItemValue
/// Debug:       w ##class(web.DHCDocIPBookingCtl).IGetIPBKDtlByCode(BookID,ItemCode)
ClassMethod IGetIPBKDtlByCode(BookID, ItemCode)
{
	;^DHCDocIPBKTI(0,"ItemCode",{ItemCode},{RowID})
	;^DHCDocIPBKD(0,"BookItem",{BookID},{ItemID},{RowID})
	n (BookID,ItemCode)
	s ret=""
	q:BookID="" ret
	q:ItemCode="" ret
    s ItemID=$o(^DHCDocIPBKTI(0,"ItemCode",ItemCode,""))
    q:ItemID="" ret
	s DetailID=$o(^DHCDocIPBKD(0,"BookItem",BookID,ItemID,""))
	q:DetailID="" ret
	q:'$d(^DHCDocIPBKD(DetailID)) ret
	s Detail=$g(^DHCDocIPBKD(DetailID))
    q DetailID_"^"_Detail
}

/// Creator：    郭荣勇
/// CreatDate：  2011-10-24
/// Description：改变住院证状态接口
/// Table：      DHCDocIPBooking 住院证表
/// Input：      Paadm 住院就诊Rowid,StateCode 状态代码
/// Return：     0 成功, 其他 失败
/// Debug:       w ##class(web.DHCDocIPBookingCtl).IGetIPBKDtlByCode(Paadm, StateCode)
ClassMethod IUpdateIPBState(Paadm, StateCode)
{
	;StateCode 枚举
	;StateCode="Booking"	预约住院	;有事件
	;StateCode="Register"	报到		;有事件
	;StateCode="SignBed"	签床		;有事件
	;StateCode="Admission"	正在住院
	;StateCode="Admit"		办理住院
	;StateCode="Wait"		待住
	;StateCode="Death"		死亡
	;StateCode="Transferred"	转院
	;StateCode="OnceAdmission"	曾住院

	n (Paadm,StateCode)
	s ret="0"
	q:Paadm="" ret
	q:StateCode="" "-102"
	
	s BookID=$o(^DHCDocIPBK(0, "EpisodeIDTo", Paadm, ""),-1)
	q:BookID="" ret
	q:'$d(^DHCDocIPBK(+BookID)) ret
	;s IPBookData = $g(^DHCDocIPBK(+BookID))
	
	s StateID=$o(^DHCDocIPBDIC(0, "TypeCode", "IPBookingState", StateCode, ""))
	q:StateID="" "-102"
	
	&sql(Update SQLUser.DHCDocIPBooking Set CurrentStateID=:StateID where RowID=:BookID)
	
	s Patientid=+^PAADM(Paadm)
	s Appointid=$o(^Nur.DHCBedApointflagI("PatientId"," "_Patientid,""),-1)
	i Appointid'=""
	{
		s OldStatus=$listget($g(^Nur.DHCBedApointflagD(Appointid)),6)
		i OldStatus="V"
		{
	 		s Appointstatus="E"
			&sql(update Nur.DHCBedApointflag (Status) Values (:Appointstatus) where ID=:Appointid)
		}
	}
	q SQLCODE
}

/// Creator：    郭荣勇
/// CreatDate：  2012-12-24
/// Description：判断就诊是否已经收住院
/// Table：      DHCDocIPBooking 住院证表
/// Input：      Paadm 住院就诊Rowid
/// Return：     1 已经收住院, 0 未收
/// Debug:       w ##class(web.DHCDocIPBookingCtl).CheckIsRecIPByAdmId(272514)
ClassMethod CheckIsRecIPByAdmId(Paadm)
{

	n (Paadm)
	s ret="0"
	s retDesc=""
	s RowID=""
	q:Paadm="" ret_"^"_RowID_"^"_retDesc
	s BookID=""
	for {
		s BookID=$o(^DHCDocIPBK(0, "EpisodeIDFrom", Paadm, BookID)) q:BookID=""
		s CurrentStateCode=""
		s CurrentStateID=$p($g(^DHCDocIPBK(BookID)),"^",8)
		i CurrentStateID'="" s CurrentStateCode=$p($g(^DHCDocIPBDIC(CurrentStateID)),"^",1)
		i CurrentStateCode="Register" s ret="1"
		s CtlocID=$p($g(^DHCDocIPBK(BookID)),"^",13)		//科室ID
		s WardID=$p($g(^DHCDocIPBK(BookID)),"^",11)			//病区ID
		s BedID=$p($g(^DHCDocIPBK(BookID)),"^",12)			//床位ID
		s CtlocDesc="",WardDesc="",BedCode=""
		i CtlocID'="" s CtlocDesc=$p($g(^CTLOC(CtlocID)),"^",2)
		i WardID'="" s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
		i BedID'="" s BedCode=$p($g(^PAWARD(+BedID,"BED",$p(BedID,"||",2))),"^",1)
		i ret="1" {
			s RowID=BookID
			s retDesc="此病人已经被收住院到["_CtlocDesc_" "_WardDesc_" "_BedCode_"]"
			q
		}
	}
	q ret_"^"_RowID_"^"_retDesc
}

// 根据登记号查询最新的就诊记录ID w ##class(web.DHCDocIPBookingCtl).GetEpisodeID("00008968")

ClassMethod GetEpisodeID(PAPMINo)
{
	q:+PAPMINo=0 ""
	q:$d(^PAPERi("PAPMI_PatNo",$ZCVT(PAPMINo,"U")))=0 ""
	set PatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PAPMINo,"U"),0))
	set EpisodeID=$o(^PAPERdr(PatientID,"ADM","O",""),-1)
	set PAPMIActive=$p(^PAPER(PatientID,"PAT",1),"^", 6)
	q:PAPMIActive="N" ""
	quit EpisodeID_"^"_PatientID
}

Query GetDocCreateBookInfo(DocCreateBook As %String, txtAdmDepID As %String = "", LogonHospId As %String = "") As %Query(ROWSPEC = "DocDesc:%String,DocNo:%String,SSUSRInitials:%String")
{
}

ClassMethod GetDocCreateBookInfoExecute(ByRef qHandle As %Binary, DocCreateBook As %String, txtAdmDepID As %String = "", LogonHospId As %String = "") As %Status
{
	Set ^liyufeng("GetDocCreateBookInfo")=DocCreateBook_","_txtAdmDepID
	//d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","GetDocCreateBookInfo","",31)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LogonHospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
 	Set langid=..%LanguageID()
 	if txtAdmDepID=""{
		s UserId=0  f  s UserId=$O(^SSU("SSUSR",UserId))  q:UserId=""  d
		.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",UserId,LogonHospId)
		.s Username=$P(^SSU("SSUSR",UserId),"^",2)
		.Set UserInitials=$P(^SSU("SSUSR",UserId),"^",1)
		.Set UserInitials=$ZCVT(UserInitials,"U")
		.s SSUSRDateFrom=$P(^SSU("SSUSR",UserId),"^",96)
		.s SSUSRDateTo=$P(^SSU("SSUSR",UserId),"^",97)
		.Q:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$H)
		.Q:(SSUSRDateTo'="")&&(SSUSRDateTo<+$H)
		.if DocCreateBook'="" q:(Username'[DocCreateBook)&&(UserInitials'=$ZCVT(DocCreateBook,"U"))
		. s Username =##class(User.SSUser).GetTranByDesc("SSUSRName",Username,langid)
		.s DocDesc=Username,DocNo=UserId
		.Do OutputRowDocDesc
 	}else{
		Set ResRowid=0
		For  Set ResRowid=$o(^RB("RES",0,"CTLOC",txtAdmDepID,ResRowid)) Quit:ResRowid=""  do
		.Set DocId=$p(^RB("RES",ResRowid),"^",2)
		.Set UserId=$o(^SSU("SSUSR",0,"CTPCP",DocId,0))
		.Quit:UserId=""
		.s Username=$P(^SSU("SSUSR",UserId),"^",2)
		.Set UserInitials=$P(^SSU("SSUSR",UserId),"^",1)
		.s SSUSRDateFrom=$P(^SSU("SSUSR",UserId),"^",96)
		.s SSUSRDateTo=$P(^SSU("SSUSR",UserId),"^",97)
		.Q:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$H)
		.Q:(SSUSRDateTo'="")&&(SSUSRDateTo<+$H)
		.if DocCreateBook'="" q:Username'[DocCreateBook
		.s Username =##class(User.SSUser).GetTranByDesc("SSUSRName",Username,langid)
		.s DocDesc=Username,DocNo=UserId
		.Do OutputRowDocDesc
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDocDesc
	set Data=$lb(DocDesc,DocNo,UserInitials)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDocCreateBookInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocCreateBookInfoExecute ]
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

ClassMethod GetDocCreateBookInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocCreateBookInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCDocIPBookingCtl).GetPatientIpBookingStatus(211)
ClassMethod GetPatientIpBookingStatus(RowID)
{
	s RowID="" ,MDICDesc=""
	q:RowID="" 0
	s CurrentStateID=$p($g(^DHCDocIPBK(RowID)),"^",8)
	s MDICDesc=$p(^DHCDocIPBDIC(CurrentStateID),"^",2)
	q $g(CurrentStateID)
}

/// Desc 获取患者对应的有效住院证数量 提供给计费组使用
/// input:
/// 1>PatID 患者ID 
/// 2>ActiveFlag 1 查询预约日期=当日 的有效住院证数量 
/// 	 ActiveFlag 其他 查询日期=》当日 的有效住院证数量 
/// OuptPut:Num_"^"_ID  有效住院证数量_"^"_住院证ID（当且仅当Num=1的时候该值不为空）
/// w ##class(web.DHCDocIPBookingCtl).GetIPBKNum(181,1)
ClassMethod GetIPBKNum(PatID As %String, ActiveFlag As %String = "", LogonHospId As %String = "") As %String
{
	//住院:Admission
	//预约:Booking
	//撤销:Cancel
	//预住院:PreInPatient
	//登记:Register
	//签床:SignBed
	//Void 作废
	//Suspend 挂起
	//Register->改为签床后才是有效
	;设置无效的住院证状态
	s Unstatu="Admission^Cancel^Void"
	s ActiveNum=0
	s IPBookID=""
	s SubID="0"
	s LogonHospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	f  s SubID=$O(^DHCDocIPBK(0,"PatientID",PatID,SubID)) Q:SubID=""  d
	.s CurrentStateID=$P($G(^DHCDocIPBK(SubID)),"^",8)
	.s ActiveFlag=$P($G(^DHCDocIPBK(SubID)),"^",9)
	.Q:ActiveFlag="N"
	.s CurrentStateCode=""
	.s:CurrentStateID'="" CurrentStateCode=$p($G(^DHCDocIPBDIC(CurrentStateID)),"^",1)
	.Q:Unstatu[CurrentStateCode
	.s CtlocID=$p($g(^DHCDocIPBK(SubID)),"^",13)
	.s CurLogonHosp =$p($g(^CTLOC(CtlocID)),"^",22)
	.q:CurLogonHosp'=LogonHospId
	.s BookingDate=$P($G(^DHCDocIPBK(SubID)),"^",10)
	.Q:BookingDate="" ;没有预约日期的住院证认为是无效的预约记录
	.;Q:BookingDate<+$H	;2016-10-26 Lid 调用计费组接口判断住院证是否再有效范围内
	.s isExpire=##class(web.DHCBillInterface).IIsIPBook(SubID)
	.q:isExpire'=""
	.Q:(ActiveFlag=2)&&(BookingDate'=..%SysDate())
	.s ActiveNum=ActiveNum+1
	.s IPBookID=SubID
	i ActiveNum'=1 s IPBookID="" ;找到唯一记录才返回对应的BookID
	Q ActiveNum_"^"_IPBookID
}

/// Desc 获取患者入院病情
ClassMethod GetAdmCondition(JSFunName As %String = "", ListName As %String = "") As %String
{
	s REeprid=""
	s i=0
	s rtnval=""
	f  s REeprid=$o(^PAC("REFPRI",REeprid)) q:REeprid=""  d
	.s desc=$p(^PAC("REFPRI",REeprid),"^",2)
	.s i=i+1
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(desc),"O","JS")_"','"_$ZCVT($g(REeprid),"O","JS")_"','"_$ZCVT($g(i)-1,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	q rtnval
}

/// 查看所登录的科室是不是门诊科室
ClassMethod IsMZLoc(CTLOCID) As %String
{
		q:CTLOCID="" "N"
		Q:$D(^PAC("ADMLOC",0,"AdmType","O",CTLOCID)) "Y"
		Q:$D(^PAC("ADMLOC",0,"AdmType","E",CTLOCID)) "Y"
		q "N"
}

/// 得到打印的模板路径
ClassMethod getpath() As %String
{
	&sql(select pathtoreports into :path from websys.configuration )
	q path
}

/// w ##class().getnum("600")
ClassMethod getnum(logonUserID) As %String
{
	s gnum=$o(^TMP("QueryBookByDateLoc",logonUserID,""),-1)
	q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", logonUserID, num)
{
    
	s str=^TMP("QueryBookByDateLoc",logonUserID,num)
	q str
}

ClassMethod admwardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admwardlookupbakExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl", "admwardlookup","","")
ClassMethod admwardlookupExecute(ByRef qHandle As %Binary, admdepid As %String, desc As %String, HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ind=1
	k TempWardIdArr
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	Set langid=..%LanguageID()
	s limitfalg=##class(web.DHCDocIPBookNew).GetLocCureLimit(admdepid)
	if (limitfalg="Y") s admdepid=""
    //i admdepid="" s qHandle=$lb(0,repid,0) Quit $$$OK
    i desc'="" d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	if (admdepid=""){
		s admdepid=""
		f  s admdepid=$o(^PAC("ADMLOC",0,"AdmType","I",admdepid))  q:admdepid=""  d
		.q:($d(^CTLOC(admdepid))=0)
		.d GetPACWardList
	}else{
		d GetPACWardList
		d GetLinkOtherWardList
	}
	k TempWardIdArr
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ctdesc,rowid,ctContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetPACWardList
	s childid=""
	f  s childid=$o(^CTLOC(admdepid,"LINK",childid))  q:childid=""  d
	.s linkid=$p(^CTLOC(admdepid,"LINK",childid),"^",1)
	.q:($d(^CTLOC(linkid))=0)
	.s loctype=$p(^CTLOC(linkid),"^",13)
	.q:(loctype'="W")
	.s ctdesc=$p(^CTLOC(linkid),"^",2)
	.s rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,""))
	.s HospitalDr=$p($g(^CTLOC(linkid)),"^",22)
	.Q:HospitalDr'=HospId
	.s ctContactName=$p(^CTLOC(linkid),"^",43)   //科室检索码
	.s ctContactName=$$ALPHAUP^SSUTIL4(ctContactName)
	.q:((desc'="")&&(ctContactName'[desc)&&($$ALPHAUP^SSUTIL4(ctdesc)'[desc))
	.s ctdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctdesc,langid)
    .s:($f(ctdesc,"-")'=0) ctdesc=$p(ctdesc,"-",2)
	.s ActiveDateTo=$p($g(^CTLOC(linkid)),"^",25)
	.q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
	.q:($P(^CTLOC(linkid),"^",14)'="Y")
    .q:$d(TempWardIdArr(rowid))
    .s TempWardIdArr(rowid)=0
    .d OutputRow1
    quit
GetLinkOtherWardList
	s linkwardstr=##class(web.DHCDocIPBookNew).GetLinkWard(admdepid)
	f i=1:1:$L(linkwardstr,"!")  d
	.s oneward=$P(linkwardstr,"!",i)
	.Q:oneward=""
	.s wardr=$P(oneward,"^",2)
	.s rowid=$p($g(^PAWARD(+wardr)),"^",5)
	.s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	.Q:HospitalDr'=HospId
	.s ctdesc=$p($g(^CTLOC(rowid)),"^",2)
	.s ctContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	.q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
	.q:($P(^CTLOC(rowid),"^",14)'="Y")
	.s ctdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctdesc,langid)
	.d OutputRow1
   quit
}

ClassMethod admwardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admwardlookupbakExecute ]
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

Query admwardlookup(admdepid As %String, desc As %String, HospId = "") As %Query(ROWSPEC = "ward:%String,wardid:%String,ctContactName:%String")
{
}

Query QueryBookByDateLocExport(FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String, PacWardId As %String, DocCreateBookId As %String, OrderOrCreateDate As %String, OrdLoc As %String = "") As %Library.Query(ROWSPEC = "RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,TPAPMICardType:%String:证件类型,PersonalID:%String:证件号码,Company:%String:工作单位,Address:%String:家庭住址,OPDate:%String:门诊日期,IPDep:%String:住院科室,IPLoc:%String:病房,InputDoctor:%String:医师,Diagnose:%String:门诊诊断,CurrentState:%String:当前状态,InputUser:%String:录入人,PriorityCondtion:%String:入院病情,TabWaitDate:%String:等候天数")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QueryBookByDateLocExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod QueryBookByDateLocExportExecute(ByRef qHandle As %Library.Binary, FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String, PacWardId As %String, DocCreateBookId As %String, OrderOrCreateDate As %String, OrdLoc As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCDocIPBookingCtl:QueryBookByDateLoc")
	d rset.Execute(FromDate,ToDate,CtLoc,State,RegNo,PacWardId,DocCreateBookId,OrderOrCreateDate,OrdLoc)
	While (rset.Next()) {
		s RegNo=rset.Data("RegNo")
		s PatientName=rset.Data("PatientName")
		s Sex=rset.Data("Sex")
		s Age=rset.Data("Age")
		s TPAPMICardType=rset.Data("TPAPMICardType")
		s PersonalID=rset.Data("PersonalID")
		s Company=rset.Data("Company")
		s Address=rset.Data("Address")
		s OPDate=rset.Data("OPDate")
		s IPDep=rset.Data("IPDep")
		s IPLoc=rset.Data("IPLoc")
		s InputDoctor=rset.Data("InputDoctor")
		s Diagnose=rset.Data("Diagnose")
		s Diagnose=$tr(Diagnose,",","、")
		s CurrentState=rset.Data("CurrentState")
		s InputUser=rset.Data("InputUser")
		s PriorityCondtion=rset.Data("PriorityCondtion")
		s TabWaitDate=rset.Data("TabWaitDate")
		s OutputList=$lb(RegNo,PatientName,Sex,Age,TPAPMICardType,PersonalID,Company,Address,OPDate,IPDep,IPLoc,InputDoctor,Diagnose,CurrentState,InputUser,PriorityCondtion,TabWaitDate)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryBookByDateLocExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QueryBookByDateLocExportExecute ]
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

ClassMethod QueryBookByDateLocExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QueryBookByDateLocExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// w ##class(web.DHCDocIPBookingCtl).GetBookStatusCount(10209)

ClassMethod GetBookStatusCount(logonUserID As %String) As %String
{
	k BookStatusArr
	s JsonObj=[]
	s JsonData={}
	s Sum=..getnum(logonUserID)
	for num=1:1:Sum {
		s str=$g(^TMP("QueryBookByDateLoc",logonUserID,num))
		s CurrentState=$p(str,"^",14)
		s BookStatusArr(CurrentState)=(+$g(BookStatusArr(CurrentState)))+1
	}
	s id=0
	for {
		s id=$o(BookStatusArr(id)) q:id="" 
		d JsonData.%Set(id,+$g(BookStatusArr(id)))
	}
	do JsonObj.%Push(JsonData,"")
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
}

Query admdeplookup(desc As %String, UserDepID As %String) As websys.Query(ROWSPEC = "dep:%String,depid:%String,ctContactName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl", "admdeplookup", "内分泌科", "197")
ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String, UserDepID As %String) As %Status
{
  	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

 	if (desc'="") do
    .set desc=$$ALPHAUP^SSUTIL4(desc)
    Set langid=..%LanguageID()
    set UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UserDepID)
	set rowid="0"
	for  set rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  quit:(rowid="")  do
	.quit:($d(^CTLOC(rowid))=0)
	.set DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(rowid)
	.quit:((UserDepHosDr'=DepHosDr)&&(UserDepHosDr'="")&&(DepHosDr'=""))
	.set ctdesc=$p(^CTLOC(rowid),"^",2)
	.s LocDateTo=$p($g(^CTLOC(rowid)),"^",25)
	.Q:(LocDateTo'="")&&(LocDateTo<+$H)
	.set ctContactName=$p(^CTLOC(rowid),"^",43)   //科室检索码
	.quit:((desc'="")&&($$ALPHAUP^SSUTIL4(ctContactName)'[desc)&&($$ALPHAUP^SSUTIL4(ctdesc)'[desc))
	.Q:($P(^CTLOC(rowid),"^",14)'="Y")
	.s ctdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctdesc,langid)
	.set:($f(ctdesc,"-")'=0) ctdesc=$p(ctdesc,"-",2)
    .do OutputRow

	quit $$$OK
OutputRow
	set Data=$lb(ctdesc,rowid,ctContactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
