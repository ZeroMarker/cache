Import SQLUser

/// WEB住院证
/// 主要负责保存、读取WEB住院证的数据
/// Creator：李阳
/// Updater：     刘学峰
/// UpdateDate：  2008-11-04
Class web.DHCMedIPBookingCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：保存住院证主信息
/// Input：      
/// 		Instring：用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID。
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).Update(Instring)
ClassMethod Update(Instring)
{
	n (Instring)
	set RowID = $p(Instring, "^", 1)
	set PLIST(2)=$p(Instring,"^",2)         ;PatientID       
    set PLIST(3)=$p(Instring,"^",3)         ;门诊就诊PAADM  指向PA_ADM
    set PLIST(4)=$p(Instring,"^",4)         ;住院就诊PAADM  指向PA_ADM
    set CreateDate = $p(Instring,"^",5)
    set:CreateDate="" CreateDate=$p($h,",",1)
    set:(CreateDate'="")&(CreateDate["-") CreateDate=$zdh(CreateDate,3)
    set:(CreateDate'="")&(CreateDate["/") CreateDate=$zdh(CreateDate,4)
    set PLIST(5)=CreateDate         		;建住院证日期
    set CreateTime = $p(Instring,"^",6)
    set:CreateTime="" CreateTime=$p($h,",",2)
    set:(CreateTime'="")&(CreateTime[":") CreateTime=$zth(CreateTime,2)
    set PLIST(6)=CreateTime         		;建住院证时间
    set PLIST(7)=$p(Instring,"^",7)         ;建住院证操作员ID 指向SS_User
    set PLIST(8)=$p(Instring,"^",8)         ;建住院证医师ID 指向SS_User
    set PLIST(9)=$p(Instring,"^",9)         ;当前状态ID 指向DHC_MedDictory
    set PLIST(10)=$p(Instring,"^",10)       ;有效状态 Yes/No
    set BookDate = $p(Instring,"^",11)
    set:BookDate="" BookDate=$p($h,",",1)
    set:(BookDate'="")&(BookDate["-") BookDate=$zdh(BookDate,3)
    set:(BookDate'="")&(BookDate["/") BookDate=$zdh(BookDate,4)
    set PLIST(11)=BookDate         			;预约日期    	
    set PLIST(12)=$p(Instring,"^",12)       ;Text1    病区ID	
    set PLIST(13)=$p(Instring,"^",13)       ;Text2    床位ID	
    set PLIST(14)=$p(Instring,"^",14)       ;Text3    科室ID
    set PLIST(15)=$p(Instring,"^",15)       ;Text4	  诊断ID
    set PLIST(16)=$p(Instring,"^",16)       ;备注    	
    i RowID="" d
    .&sql(Insert into DHC_MedIPBooking values :PLIST())
    .s RowID =$p(%ROWID,$c(1))
    e  d
    .&sql(Update DHC_MedIPBooking values :PLIST() where Rowid=:RowID)
    quit RowID
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：保存住院证的附加信息
/// Input：      
/// 		Instring：用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID。
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).UpdateDetail(Instring)
ClassMethod UpdateDetail(Instring)
{
	n (Instring)
	set RowID = $p(Instring, "^", 1)
	set PLIST(2) = $p(Instring, "^", 2)
	set PLIST(3) = $p(Instring, "^", 3)
	set PLIST(4) = $p(Instring, "^", 4)
    i RowID="" d
    .&sql(Insert into DHC_MedIPBKDetail values :PLIST())
    .s RowID =$p(%ROWID,$c(1))
    e  d
    .&sql(Update DHC_MedIPBKDetail values :PLIST() where Rowid=:RowID)
    quit RowID
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：保存住院证的状态信息
/// Input：      
/// 		Instring：用^分割的字段值
/// Return：     如果新增加一条记录，返回该记录的RowID。
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).UpdateBookState(Instring)
ClassMethod UpdateBookState(Instring)
{
	n (Instring)
	set RowID = $p(Instring, "^", 1)
	set PLIST(2) = $p(Instring, "^", 2)
	set PLIST(3) = $p(Instring, "^", 3)
	set PLIST(4) = $p(Instring, "^", 4)
	set PLIST(5) = $p(Instring, "^", 5)
	set:$p(Instring,"^",5)="" PLIST(5)=$p($h,",",1)
	set PLIST(6) = $p(Instring, "^", 6)
	set:$p(Instring,"^",6)="" PLIST(6)=$p($h,",",2)
	set PLIST(7) = $p(Instring, "^", 7)	
	set PLIST(8) = $p(Instring, "^", 8)
	
    i RowID="" d
    .&sql(Insert into DHC_MedIPBKStates values :PLIST())
    .s RowID =$p(%ROWID,$c(1))
    e  d
    .&sql(Update DHC_MedIPBKStates values :PLIST() where Rowid=:RowID)
    
    &sql(Update DHC_MedIPBooking set CurrentStateID = :PLIST(3) where Rowid=:PLIST(2))
    quit RowID
}

/// Creator：    李阳
/// CreatDate：  2008-11-4
/// Description：接口，通过调用此接口 ，将住院证的IsActive设置为N，并把状态更改为住院
/// Input：      
/// 		BookID：住院证ID
/// 		IPaadm：住院ADM的RowID
/// 		UserID:操作员的ID
/// Return：     更新成功返回1，否则返回0
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).PatientArrive(BookID, IPaadm, UserID)
ClassMethod PatientArrive(BookID, IPaadm, UserID)
{
	n (BookID, IPaadm, UserID)
	s ActiveFalse="N"
	quit:BookID="" 0
	quit:$d(^DHCMedIPBK(BookID))=0 0
	set ArriveDicRowID = $o(^DHCMDIC(0, "TypeCode", "IPBookingState", "Admission", ""))  //住院证状态：已住院
	set ReasonDicRowID = $o(^DHCMDIC(0, "TypeCode", "IPBookingStateChangeReason", "Admit", ""))  //更改住院证状态原因：住院
	set PLIST(2) = BookID
	set PLIST(3) = ArriveDicRowID
	set PLIST(4) = UserID
	set PLIST(5) = $p($h, "," , 1)
	set PLIST(6) = $p($h, "," , 2)
	set PLIST(7) = ReasonDicRowID
	set PLIST(8) = ""
	s retcode=0
	&sql(Insert into DHC_MedIPBKStates values :PLIST())
	s retcode=retcode+SQLCODE
	i retcode=0  d
	.&sql(Update DHC_MedIPBooking set EpisodeIDTo = :IPaadm, CurrentStateID = :ArriveDicRowID, IsActive =:ActiveFalse where Rowid=:BookID)
	.s retcode=retcode+SQLCODE
	quit retcode
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：通过ID获取住院证信息
/// Input：      
/// 		RowID：住院证的ID
/// Return：     更新成功返回数据
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).GetIPBookByID(RowID)
ClassMethod GetIPBookByID(RowID)
{
	n (RowID)
	quit:+RowID=0 ""
	quit:$d(^DHCMedIPBK(+RowID))=0 ""
	set ret = $g(^DHCMedIPBK(+RowID))
	quit RowID_"^"_ret
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：通过门诊的Paadm取得住院证信息
/// Input：      
/// 		Paadm：门诊的Paadm ID
/// Return：     更新成功返回数据
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).GetIPBookByPaadm(Paadm)
ClassMethod GetIPBookByPaadm(Paadm)
{
	n (Paadm)
	quit:Paadm="" ""
	set BookID = $o(^DHCMedIPBK(0, "EpisodeIDFrom", Paadm, ""))
	quit:BookID=""
	quit ..GetIPBookByID(BookID)
}

/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：通过BookID、模板项目代码获得 指定住院证的 附加项目值
/// Input：      
/// 		Paadm：门诊的Paadm ID
/// 		ItemCode:模板项目的Code，对应DHC_MedIPBKTempItem表
/// Return：     更新成功返回数据
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).GetBookItemByItemCode(BookID, ItemCode)
ClassMethod GetBookItemByItemCode(BookID, ItemCode)
{
	n (BookID, ItemCode)
	quit:BookID=""!ItemCode="" ""
	set ItemRowID = $o(^DHCMedIPBKTI(0, "ItemCode", ItemCode, ""))
	quit:ItemRowID="" ""
	set DetailID = $o(^DHCMedIPBKD(0, "BookItem", BookID, ItemRowID, ""))
	quit:DetailID="" ""
	set strDetail = $g(^DHCMedIPBKD(DetailID))
	quit $p(strDetail, "^", 3)
}

/// 
/// ReName:联系人, RePhone:联系人姓名
/// Creator：    李阳
/// CreatDate：  2008-10-24
/// Description：更新病人基本信息（很少部分）
/// Input：      
/// 		PatientID：病人ID
/// 		Company：工作单位, 
/// 		HomeAddress：家庭住址, 
/// 		Tel：联系电话, 
/// 		PersonalID：身份证号码, 
/// 		ReName：联系人姓名, 
/// 		RePhone：联系电话
/// 		RelationNameDr:和联系人的关系Dr   CT_Relation表
/// Return：     1
/// Debug:	   w ##class(web.DHCMedIPBookingCtl).UpdatePatientBaseInfo(PatientID, Company, HomeAddress, Tel, PersonalID, ReName, RePhone, RelationNameDr)
ClassMethod UpdatePatientBaseInfo(PatientID, Company, HomeAddress, Tel, PersonalID, ReName, RePhone, RelationNameDr)
{
	n (PatientID, Company, HomeAddress, Tel, PersonalID, ReName, RePhone, RelationNameDr)
	set Hospital = ##class(web.DHCMedBase01).GetDefaultHosp()
	set Code = $p(Hospital, "/", 4)
	if (Code = "BeiJing_YY")
	{
		&sql(update PA_Person set 
			PAPER_SecondPhone = :HomeAddress,
			PAPER_TelH = :Tel,
			PAPER_ForeignPhone = :RePhone,
			PAPER_CTRLT_DR  = :RelationNameDr
			   WHERE PAPER_RowId = :PatientID
		)
		&sql(update pa_patmas set 
			papmi_id=:PersonalID
			where papmi_rowid=:PatientID)
			
		S ^PAPER(PatientID,"PER","ADD",1)=Company
		
		//联系人
		s tmp = $g(^PAPER(PatientID,"PER",1))
		set $p(tmp, "^", 1) = ReName
		set ^PAPER(PatientID,"PER",1) = tmp
		//联系人电话
		s tmp = $g(^PAPER(PatientID,"PER",2))
		set $p(tmp, "^", 8) = RePhone
		set ^PAPER(PatientID,"PER",2) = tmp		
		
		
		
		
	}
	if (Code = "ChengDu_HX")
	{
		/*
		        s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
        s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
		/
		/&sql(update PA_Person set 
			PAPER_ID = :PersonalID,
			PAPER_StName = :HomeAddress,
			PAPER_TelH = :Tel,
			PAPER_StNameLine1 = :HomeAddress,
			PAPER_EmployeeCompany = :Company
			   WHERE PAPER_RowId = :PatientID
		)		
		b
		set tmp = $g(^PAPER(xPapmi,"PER",3))
		set $p(tmp, "^", 2) = Company
		set ^PAPER(xPapmi,"PER",3) = tmp
		//地坛医院的家庭住址与工作单位排列位置和友谊医院相反 ~
		//Company:工作单位
		//HomeAddress：家庭住址 
		PAPER_ForeignId=:ForeignId,
	        PAPER_ForeignPhone=:FPhone,
		
		*/
		
		&sql(update PA_Person set 
			PAPER_SecondPhone = :Company,
			PAPER_TelH = :Tel,
			PAPER_ForeignPhone = :RePhone,
			PAPER_CTRLT_DR  = :RelationNameDr
			   WHERE PAPER_RowId = :PatientID
		)
		&sql(update pa_patmas set 
			papmi_id=:PersonalID
			where papmi_rowid=:PatientID)
			
		S ^PAPER(PatientID,"PER","ADD",1)=HomeAddress
		//联系人
		s tmp = $g(^PAPER(PatientID,"PER",2))
		set $p(tmp, "^", 13) = ReName
		set ^PAPER(PatientID,"PER",2) = tmp
		//联系人电话
		s tmp = $g(^PAPER(PatientID,"PER",2))
		set $p(tmp, "^", 8) = RePhone
		set ^PAPER(PatientID,"PER",2) = tmp	
		
	}
	quit 1
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

ClassMethod QueryBookByDateLocExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String = "", PacWardId As %String = "") As %Status
{
	n (qHandle, FromDate, ToDate, CtLoc, State,RegNo, PacWardId)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(FromDate="")!(ToDate="") $$$OK
	set RowID = ""
	set tmpDate = ""
	set:FromDate["/" FromDate = $zdh(FromDate, 4)
	set:ToDate["/" ToDate = $zdh(ToDate, 4)
	for tmpDate=FromDate:1:ToDate
	{
		set RowID = ""
		while 1
		{
			set RowID = $o(^DHCMedIPBK(0, "BookingDate", tmpDate, RowID))
			quit:RowID=""
			set strData = $g(^DHCMedIPBK(RowID))
			continue:($p(strData,"^",8)'=State)&(State'="") //状态校验
			//set IP =$g(^PAADM(+$p(strData,"^",3)))
			//set IPLocID = $p(IP, "^", 4)
			//continue:(IPLocID'=CtLoc)&(CtLoc'="") //Location校验
			s patientId=$p(strData,"^",1)
			continue:patientId=""
			s patientNo=$P($G(^PAPER(patientId,"PAT",1)),"^",1)
			continue:(RegNo'=patientNo)&(RegNo'="")
			continue:($p(strData,"^",11)'=PacWardId)&(PacWardId'="")&($p(strData,"^",11)'="")
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
			set ^CacheTemp(repid, ind) = $$BuildQueryBookInfo(RowID)
			set ind = ind + 1
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildQueryBookInfo(BookID)
	n (BookID)
	set strData = $g(^DHCMedIPBK(BookID))
	set Patient = ##class(web.DHCMedBaseCtl).GetPatInfo(+$p(strData, "^", 1))
	set OP = ##class(web.DHCMedBasePaadmCtl).GetAdmInfo(+$p(strData,"^",2))
	Set IP = ##class(web.DHCMedBasePaadmCtl).GetAdmInfo(+$p(strData,"^",3))
	set Doctor = ##class(web.DHCMedBaseCtl).GetUsrStr(+$p(strData, "^", 7))
	set User = ##class(web.DHCMedBaseCtl).GetUsrStr(+$p(strData, "^", 6))
	set State = $g(^DHCMDIC(+$p(strData, "^", 8)))
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
	if ctLocId'="" s ctLocDesc=$P($G(^CTLOC(ctLocId)),"^",2)
	e  s ctLocDesc=""
	set $li(data, 8)=$G(ctLocDesc)
	set $li(data, 9) = $p(IP, "^", 9)
	set $li(data, 10) = $p(Doctor, "/", 3)
	set $li(data, 11) = $p(User, "/", 3)
	set $li(data, 12) = $p(State, "^", 2)
	set $li(data, 13) = $p(Patient, $c(2), 11) //工作单位
	set $li(data, 14) = $p(Patient, $c(2), 18) //地址
	set $li(data, 15) = $p(Patient, $c(2), 5) //身份证号
	set $li(data, 16) = ..GetBookItemByItemCode(BookID, "Days") //与预计住院天数
	;set $li(data, 17) = ..GetBookItemByItemCode(BookID, "Diagnose") //门诊诊断
	i DiagnoseID'="" set $li(data, 17) = ..GetMRDiagnosByID(DiagnoseID) //门诊诊断 modify by lxf 2008-11-12
	set $li(data, 18) = $p(strData, "^", 2)
	set wardId=$p(strData, "^", 11)
	if wardId'="" Set wardDesc=$P($G(^PAWARD(wardId)),"^",2)
	e  set wardDesc=""
	set $li(data, 19) = $G(wardDesc)
	//set $li(data, 20) = $p(strData, "^", 12)
	i wardId'="" d
	.s bedState=..GetPacBedState(wardId)
	.i bedState=0 set $li(data, 20) ="满"
	.e  set $li(data, 20) ="空"
	e  set $li(data, 20) =""
	set $li(data, 21) = $ZD($p(strData, "^", 10),3)
	set $li(data, 22) = ..GetBookItemByItemCode(BookID, "IPDeposit") //预交金
	quit data
}

/// 显示附加项的Query
/// 如果BookID不为空，显示附加项目结果   TemplateID不为空 显示空模板 
ClassMethod QueryIPBookDetailExecute(ByRef qHandle As %Binary, BookID As %String, TemplateID As %String) As %Status
{
	n (qHandle, BookID, TemplateID)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	quit:(BookID="")&(TemplateID="") $$$OK
	if (BookID '= "")&(($d(^DHCMedIPBKD(0, "BookItem", +BookID)) '= 0))
	{
		set ItemID = ""
		while (1)
		{
			set ItemID = $o(^DHCMedIPBKD(0, "BookItem", +BookID, ItemID))
			quit:ItemID=""
			set RowID = ""
			while (1)
			{
				set RowID = $o(^DHCMedIPBKD(0, "BookItem", +BookID, ItemID, RowID))
				quit:RowID=""
				set data = $$BuildDetail(ItemID, RowID)
				set ^CacheTemp(repid, ind) = data
				set ind = ind + 1
			}
		}
		quit $$$OK
	}
	if (TemplateID '= "")
	{
			set RowID = ""
			set ItemID = ""
			while (1)
			{
				set ItemID = $o(^DHCMedIPBKTD(0, "TempItem", TemplateID, ItemID)) 
				quit:ItemID=""
				set RowID = ""
				while (1)
				{
					set RowID = $o(^DHCMedIPBKTD(0, "TempItem", TemplateID, ItemID, RowID)) 
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
	n (ItemID, DetailID)
	set strData = $g(^DHCMedIPBKD(DetailID))
	set ItemData = $g(^DHCMedIPBKTI(ItemID))
	set DataType = $g(^DHCMDIC(+$p(ItemData, "^", 3)))
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
	//w !,DataType
	quit data
	
BuildTemplate(TemplateDtlID)
	n (TemplateDtlID)
	set strData = $g(^DHCMedIPBKTD(TemplateDtlID))
	set ItemData = $g(^DHCMedIPBKTI(+$p(strData,"^",2)))
	set DataType = $g(^DHCMDIC(+$p(ItemData, "^", 3)))
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
Query QueryBookByDateLoc(FromDate As %String, ToDate As %String, CtLoc As %String, State As %String, RegNo As %String, PacWardId As %String) As %Query(ROWSPEC = "RowID:%String,RegNo:%String:登记号,PatientID:%String,PatientName:%String:病人姓名,Sex:%String:性别,Age:%String:年龄,OPDate:%String:门诊日期,IPDep:%String:住院科室,IPLoc:%String:住院科室,InputDoctor:%String:医师,InputUser:%String:录入人,CurrentState:%String:当前状态,Company:%String:工作单位,Address:%String:家庭住址,PersonalID:%String:身份证号,Days:%String:预计住院天数,Diagnose:%String:门诊诊断,OPAdm:%String,PacWard:%String,PacBed:%String,BookingDate:%String,IPDeposit:%String")
{
}

ClassMethod QueryStateByBookIDExecute(ByRef qHandle As %Binary, BookID As %String) As %Status
{
	n (qHandle, BookID)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	quit:BookID="" $$$OK
	set RowID = ""
	while 1
	{
		set RowID = $o(^DHCMedIPBKS(0, "BookID", +BookID, RowID), -1)
		quit:RowID=""
		set ^CacheTemp(repid, ind) = $$BuildStateInfo(RowID)
		set ind = ind + 1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildStateInfo(RowID)
	n (RowID)
	set strData = $g(^DHCMedIPBKS(+RowID))
	set StateDic = $g(^DHCMDIC(+$p(strData, "^", 2)))
	set ReasonDic = $g(^DHCMDIC(+$p(strData, "^", 6)))
	set User = ##class(web.DHCMedBaseCtl).GetUsrStr(+$p(strData, "^", 3))
	set data = $lb("")
	set $li(data, 1) = RowID
	set $li(data, 2) = $p(StateDic, "^", 2)
	set $li(data, 3) = $p(ReasonDic, "^", 2)
	set $li(data, 4) = $p(User, "/", 3)
	set $li(data, 5) = $zd(+$p(strData, "^", 4), 3)
	set $li(data, 6) = $zt(+$p(strData, "^", 5), 2)
	set $li(data, 7) = $p(strData, "^", 7)
	quit data
}

/// Creator：    李阳
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
/// Debug:	     w ##class(web.DHCMedIPBookingCtl).GetRegNoByCardNo(cardNo) 
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
/// Debug:	     w ##class(web.DHCMedIPBookingCtl).RegNoCon(RegNo) 
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
/// Table：      DHC_MedIPBooking，DHC_MedIPBKDetail,DHC_MedIPBKTempItem 
/// Input：      IPBookID(住院证ID)
/// Output：     科室ID^病区ID^床位ID^医生ID^预交金
/// 		     预交金数值在表DHC_MedIPBKDetail中，其他在表DHC_MedIPBooking中
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetIPBKPatInfo(IPBookID)
ClassMethod GetIPBKPatInfo(IPBookID As %String) As %String
{
	;n (EpisodeIDFrom)
	;s ret="^^^^"
	;q:EpisodeIDFrom="" ret
	;q:'$d(^DHCMedIPBK(0,"EpisodeIDFrom",EpisodeIDFrom)) ret
	;s IPBookID=""
	;s IPBookID=$o(^DHCMedIPBK(0,"EpisodeIDFrom",EpisodeIDFrom,IPBookID))
	n (IPBookID)
	s ret="^^^^"
	q:'$d(^DHCMedIPBK(IPBookID)) ret
	s str=$g(^DHCMedIPBK(IPBookID))
	s CtlocID=$p(str,"^",13)		//科室ID
	s WardID=$p(str,"^",11)			//病区ID
	s BedID=$p(str,"^",12)			//床位ID
	s DocID=$p(str,"^",7)			//医生ID
	s DiagnoseID=$p(str,"^",14) 	//诊断ID
	s TemplateItemCode="IPDeposit" 	//取预交金金额约定代码
	
	s IPDeposit=""
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit
	q:'$d(^DHCMedIPBKTI(0,"ItemCode",TemplateItemCode)) ret
	s ItemRowID=""
	s ItemID=$o(^DHCMedIPBKTI(0,"ItemCode",TemplateItemCode,ItemRowID))
	
	q:'$d(^DHCMedIPBKD(0,"BookItem",IPBookID,ItemID)) ret
	s DetailID=""
	s DetailID=$o(^DHCMedIPBKD(0,"BookItem",IPBookID,ItemID,DetailID))
	i DetailID'=""  d
	.s IPDeposit=$p($g(^DHCMedIPBKD(DetailID)),"^",3)
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit_"^"_DiagnoseID
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-05
/// Description：根据门诊就诊号查询paadm表paadm_papmi_dr，然后看paadm表中是否存在
/// 			 对应的住院记录(即paadm_type=“I”,paadm_visitstatus=“A”)
/// Table：      pa_adm
/// Input：      EpisodeID
/// Return：     1(存在)/0(不存在)/-1(Error)
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).IfInPatient("")
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
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetCTLocDescByID("")
ClassMethod GetCTLocDescByID(RowID)
{
	n (RowID)
	q:RowID=""
	s Desc=""
	q:'$d(^CTLOC(RowID)) Desc
	s str=$g(^CTLOC(RowID))
	s Desc=$p(str,"^",2)
	q Desc
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-10
/// Description：根据PA_ADM表RowID获取就诊诊断(只能获取一个诊断，华西用，不可通用)
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetMRDiagnosByEpisodeID(EpisodeID)
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID)
{
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
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetMRDiagnosByID(RowID)
ClassMethod GetMRDiagnosByID(RowID)
{
	n (RowID)
	q:RowID=""
	s MRDiagnos=""
	s str=$g(^MRC("ID",RowID))
	s Desc=$p(str,"^",2)
	q Desc
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-11
/// Description：根据WARD_LocationDR(指向CT_Loc)获取PAC_Ward的RowID
/// Table：      PAC_Ward
/// Input：      WARDLocDR
/// Return：     PACWardRowID
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetWardRowIDByLocDR(WARDLocDR)
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
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetHospName()
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
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetRelationByPersonID(PersonID)
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
/// Debug:		 w ##class(web.DHCMedIPBookingCtl).GetFPhoneByPersonID(PersonID)
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
	s stdate=+$h
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
	s inidate=+$h+1
	f  s inidate=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate),-1)  q:(inidate="")||(falg="N")  d
	.s initime=""
	.s:inidate=+$h initime=+$p($h,",",2)+1
	.f  s initime=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime),-1)  q:(initime="")||(falg="N")  d
	..s sub=""
	..f  s sub=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime,sub),-1)  q:(sub="")||(falg="N")  d 
	...s dateto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",5)
	...s:+dateto=0 falg="N"
	...s timeto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",6)
	...q:((+dateto<+$h)||((dateto=+$h)&&(timeto<+$P($h,",",2))))
	...s falg="N"
    q falg
}

/// w ##Class(web.DHCMedIPBookingCtl).CheckCardIsTemp(2192117)
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
/// Table：      DHC_MedIPBooking 住院证表
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
/// 		下面FristVisitHospital和Days为表住院证明细表DHC_MedIPBKDetail中数据
/// 		17      FristVisitHospital  首诊医院            
/// 		18      Days                预计住院天数        
/// Debug: w ##class(web.DHCMedIPBookingCtl).IGetIPBookByIPPaadm(2347560)
ClassMethod IGetIPBookByIPPaadm(Paadm)
{
	n (Paadm)
	s ret=""
	q:Paadm="" ret
	
	s BookID=$o(^DHCMedIPBK(0, "EpisodeIDTo", Paadm, ""),-1)
	q:BookID="" ret
	q:'$d(^DHCMedIPBK(+BookID)) ret
	s IPBookData = $g(^DHCMedIPBK(+BookID))

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
/// Table：      DHC_MedIPBKTempItem住院证模板项目字典表、DHC_MedIPBKDetail住院证明细表
/// Input：      BookID：住院证RowId，ItemCode：DHC_MedIPBKTempItem表中ItemCode字段
/// Return：     RowID^BookID^ItemID^ItemValue
/// Debug:       w ##class(web.DHCMedIPBookingCtl).IGetIPBKDtlByCode(BookID,ItemCode)
ClassMethod IGetIPBKDtlByCode(BookID, ItemCode)
{
	;^DHCMedIPBKTI(0,"ItemCode",{ItemCode},{RowID})
	;^DHCMedIPBKD(0,"BookItem",{BookID},{ItemID},{RowID})
	n (BookID,ItemCode)
	s ret=""
	q:BookID="" ret
	q:ItemCode="" ret
    s ItemID=$o(^DHCMedIPBKTI(0,"ItemCode",ItemCode,""))
    q:ItemID="" ret
	s DetailID=$o(^DHCMedIPBKD(0,"BookItem",BookID,ItemID,""))
	q:DetailID="" ret
	q:'$d(^DHCMedIPBKD(DetailID)) ret
	s Detail=$g(^DHCMedIPBKD(DetailID))
    q DetailID_"^"_Detail
}

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
