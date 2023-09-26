Class dhcinterface.RISMSGTransact Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 处理RIS发来的取消检查的消息
ClassMethod ORMO01OC(OEOrdItemID As %String, Status As %String, DateTime As %String, UserInitials As %String) As %String
{
	///检查医嘱指针 OEOrdItemID  XXXXX||XXX
	///HL7消息状态  Status="CA"	 RIS 取消检查 (Order is Canceled)
	///时间         DateTime="YYYYMMDDHHMM" 
	///
	//检查医嘱是否存在
	Set OEOrdItemID=$G(OEOrdItemID)
	Set Ord=$P(OEOrdItemID,"||",1)
	Set Chl=$P(OEOrdItemID,"||",2)

	Quit:(Ord="")!(Chl="") 100

	Quit:'$D(^OEORD(Ord)) 100

	Quit:'$D(^OEORD(Ord,"I",Chl)) 100
	Set admId=$p(^OEORD(Ord),"^",1)  //ADD BY 20090113
	
    //如果病人已经出院，则不能更改
    Quit:($p(^PAADM(admId),"^",17)'="")&&(($p(^PAADM(admId),"^",2))="I") 100
	///

	///Status为空或或状态码在HIS未定义,不执行操作返回正确状态
	Quit:$G(Status)="" 0
	Set RESST=$O(^OEC("RESST",0,"Code",Status,""))
	//Quit:RESST="" 0

	///
	///检查时间是否正确?如果不正确?取当前时间
	Set UpdateDate=+$H,UpdateTime=$P($H,",",2)
	If DateTime?12N {
		Set Year=$E(DateTime,1,4)
		Set Month=$E(DateTime,5,6)
		Set Day=$E(DateTime,7,8)
		Set Hour=$E(DateTime,9,10)
		Set Minute=$E(DateTime,11,12)
		;
		If (+Month'>12)&(+Month'<1)&(+Day'>31)&(+Day'<1) {
			Set Date=Year_"-"_Month_"-"_Day
			Set Time=Hour_":"_Minute
			Set UpdateDate=$ZDH(Date,3)
			Set UpdateTime=$ZTH(Time,3)
		}
	}

	///
	///当医嘱状态为"E"时,将状态修改为"V",允许医生停医嘱退费
	///当医嘱状态不为"E"时,保持医嘱原来的状态
	Set VerifyStatus=$O(^OEC("OSTAT",0,"Code","V",""))
	Set OrdStatus=$P($G(^OEORD(Ord,"I",Chl,1)),"^",13)
	Set OrdStatusCode=$P($G(^OEC("OSTAT",OrdStatus)),"^",1)
	If OrdStatusCode="E" Set OrdStatus=VerifyStatus
    b ;
	///
	s UserId=..GetUserId($g(UserInitials))
	if UserId="" s UserId=4973
	TS
	&SQL(Update SQLUser.OE_OrdItem 
				Set OEORI_ResultUpdateDate= :UpdateDate,
					OEORI_ResultUpdateTime= :UpdateTime,
					OEORI_ResultFlag= :Status
				Where OEORI_RowId= :OEOrdItemID)
	b ;3;
	If SQLCODE TRollback  Quit SQLCODE
	Set:(OrdStatusCode="E") SQLCODE=##Class(web.DHCOEOrdItem).UpdateStatus(OEOrdItemID,UserId,OrdStatus)
	If SQLCODE TRollback  Quit SQLCODE
	TC
	Quit SQLCODE
}

/// 根据RIS发来的状态信息更新HIS中对应医嘱的状态
ClassMethod ORMO01XX(OEOrdItemID As %String, Status As %String, DateTime As %String, SeriesNo As %String, UserInitials As %String) As %Status
{
	;w ##class(dhcinterface.RISMSGTransact).ORMO01XX("1242542||3","SC","200807281230","222438")
	;s ^zhou("ORMO01XX")=OEOrdItemID_","_Status_","_DateTime_","_SeriesNo
	;"1242542||3,SC,200807281230,222438"
	;w ##class(dhcinterface.RISMSGTransact).ORMO01XX("440934-3","SC","200803311935",101619)
	///检查医嘱指针 OEOrdItemID  XXXXX||XXX
	///HL7消息状态  Status
	///时间         DateTime="YYYYMMDDHHMM" 
	///
	///Status="SC"	RIS 登记,安排检查时间 (Scheduled)
	///Status="IP"	RIS 检查开始 (In Process)
	///Status="CM"	RIS 检查完成 (Order is Complete)
	///Status="BK" RIS预约
	///Status="IM" RIS有图像
	///Status="RP" RIS已写报告
	///Status="V"  RIS审核报告
	//检查医嘱是否存在
	Set OEOrdItemID=$G(OEOrdItemID)
	Set Ord=$P(OEOrdItemID,"||",1)
	Set Chl=$P(OEOrdItemID,"||",2)
	Quit:(Ord="")!(Chl="") 100
	Quit:'$D(^OEORD(Ord)) 100
	Quit:'$D(^OEORD(Ord,"I",Chl)) 100
	s OEOrdItemID=Ord_"||"_Chl
	Set admId=$p(^OEORD(Ord),"^",1)  //ADD BY 20090113
    Quit:($p(^PAADM(admId),"^",17)'="")&&(($p(^PAADM(admId),"^",2))="I") 100
	///
	///Status为空或或状态码在HIS未定义,不执行操作返回正确状态
	Quit:$G(Status)="" 0
	Set RESST=$O(^OEC("RESST",0,"Code",Status,""))
	///Quit:RESST="" 0
	///
	///检查时间是否正确?如果不正确?取当前时间
	Set UpdateDate=+$H
	Set UpdateTime=$P($H,",",2)
	If DateTime?12N {
		Set Year=$E(DateTime,1,4)
		Set Month=$E(DateTime,5,6)
		Set Day=$E(DateTime,7,8)
		Set Hour=$E(DateTime,9,10)
		Set Minute=$E(DateTime,11,12)
		;
		If (+Month'>12)&(+Month'<1)&(+Day'>31)&(+Day'<1) {
			Set Date=Year_"-"_Month_"-"_Day
			Set Time=Hour_":"_Minute
			Set UpdateDate=$ZDH(Date,3)
			Set UpdateTime=$ZTH(Time,3)
		}
	}
	///
	///当操作状态为"SC"并且医嘱状态为"V"时,将状态修改为"E"
	Set ExecStatus=$O(^OEC("OSTAT",0,"Code","E",""))
	Set OrdStatus=$P($G(^OEORD(Ord,"I",Chl,1)),"^",13)
	Set OrdStatusCode=$P($G(^OEC("OSTAT",OrdStatus)),"^",1)
	//2009-05-13
	//If ((Status="IP")!(Status="CM")!(Status="SC"))&(OrdStatusCode="V") Set OrdStatus=ExecStatus
	Set OrdStatus=ExecStatus
	//2009-05-13
    s UserId=..GetUserId($g(UserInitials))
    if UserId="" s UserId=4973
	TS
	;w UpdateTime,!
	&SQL(Update SQLUser.OE_OrdItem 
				Set OEORI_ResultUpdateDate= :UpdateDate,
					OEORI_ResultUpdateTime= :UpdateTime,
					OEORI_ResultFlag= :Status,
					OEORI_SeriesNo=:SeriesNo
				Where OEORI_RowId= :OEOrdItemID)
	;b ;SQLCODE
	If SQLCODE TRollback  Quit SQLCODE
	s:(OrdStatusCode="V") SQLCODE=##Class(web.DHCOEOrdItem).UpdateStatus(OEOrdItemID,UserId,OrdStatus)
	If SQLCODE TRollback  Quit SQLCODE
	TC
	Quit SQLCODE
}

/// 修改医嘱执行人和执行时间
ClassMethod UpdateExecuteUser(OEOrdItemID As %String, UserID As %String) As %String
{
	/// w ##class(dhcinterface.RISMSGTransact).UpdateExecuteUser("1-2","2665","0001234567","1.2.3.1.1")
	///执行时间取当前时间
	set OrdItemID1=$p(OEOrdItemID,"-",1)_"||"_$p(OEOrdItemID,"-",2)	//转换医嘱格式
	Set UpdateDate=+$H
	Set UpdateTime=$P($H,",",2)
	&SQL(Update SQLUser.OE_OrdItem 
				Set OEORI_UserExecuted=:UserID,
				    OEORI_ResultUpdateDate= :UpdateDate,
					OEORI_ResultUpdateTime= :UpdateTime
				Where OEORI_RowId=:OrdItemID1 and OEORI_ItemStat_DR=6)
	
    Quit SQLCODE
}

/// 修改医嘱执行人和执行时间
ClassMethod UpdateExecuteUser1(OEOrdItemID As %String, UserID As %String, PatientID As %String, AccessNum As %String) As %String
{
	/// w ##class(dhcinterface.RISMSGTransact).UpdateExecuteUser("1-2","2665","0001234567","1.2.3.1.1")
	///执行时间取当前时间
	set OrdItemID1=$p(OEOrdItemID,"-",1)_"||"_$p(OEOrdItemID,"-",2)	//转换医嘱格式
	set OrdItemID1=OEOrdItemID
	Set UpdateDate=+$H
	Set UpdateTime=$P($H,",",2)		
	//S ^DHCXU($h,OEOrdItemID,"1")=OrdItemID1
	//医生代码转换成ROWID
	i UserID'="" 
	{
	  
	  if $d(^SSU("SSUSR",0,"SSUSR_Initials",UserID))  s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserID,""))
	  if '$d(^SSU("SSUSR",0,"SSUSR_Initials",UserID)) s UserID=""
	}
	i UserID="" //如果传过来的执行人不存在，则用默认用户
	{
		 s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials","100006",""))
	}
 
	&SQL(Update SQLUser.OE_OrdItem 
				Set OEORI_UserExecuted=:UserID,
				    OEORI_ResultUpdateDate= :UpdateDate,
					OEORI_ResultUpdateTime= :UpdateTime
				Where OEORI_RowId=:OrdItemID1 and OEORI_ItemStat_DR=6)
	If SQLCODE Quit SQLCODE
	
    //可屏蔽
	Set SQLCODE=..InsertImagePath(OrdItemID1,UserID,PatientID,AccessNum)  //插入图象路径信息
	
	
    Quit SQLCODE
}

/// 插入登记信息表,设置PACS图像路径
/// Rowid:医嘱号
/// UserID:执行用户
/// PatientID :病人登记号
/// AccessNum:西门子图像标识号
ClassMethod InsertImagePath(Rowid As %String, UserID As %String, PatientID As %String, AccessNum As %String) As %Status
{
	s ImageViewParam="op=OEM_LOAD_DATAE&us=clinic&pw=P@ssw0rd"_"&pi="_PatientID_"&su="_AccessNum

	s OEORDRowId=$p(Rowid,"||",1)
	q:$g(OEORDRowId)="" 100
    s OEORIChildsub=$p(Rowid,"||",2)
    s AdmDR=$P($g(^OEORD(OEORDRowId)),"^",1)
    Q:$g(AdmDR)="" 100
	//S ^DHCXU($h,Rowid)=AdmDR_"^"_UserID_"^"_PatientID_"^"_AccessNum
	s ReceiveDate=$p($h,",",1)
	s Receivetime=$p($h,",",2)
	s ReportDate=$p($h,",",1)
	s ReportTime=""
	s VerifyDate=$p($h,",",1)
	s VerifyTime=""

	
	//医嘱号做为检查号
	s StudyID=OEORDRowId_"_"_OEORIChildsub
	//S ^DHCXU($h,Rowid,"4")=AdmDR_"^"_UserID_"^"_PatientID_"^"_AccessNum
	s RegInfoCount=0
	s ReportStatusDR="" 
    S StudyLoc=""
    //S ^DHCXU($h,Rowid,"2")=AdmDR_"^"_UserID_"^"_PatientID_"^"_AccessNum
    q:(OEORDRowId="")!(OEORIChildsub="") 100
    q:'$d(^OEORD(OEORDRowId)) 100
    q:'$d(^OEORD(OEORDRowId,"I")) 100
    i ($d(^OEORD(OEORDRowId,"I",OEORIChildsub))>0) d
    .s StudyLoc=$P($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
    //S ^DHCXU($h,Rowid,"3")=AdmDR_"^"_UserID_"^"_PatientID_"^"_AccessNum
    s SQLCODE=0
	&sql(Insert into SQLUSER.DHCRB_RegInfo(RAR_StudyNo,RAR_SSUSER_DR,
	      RAR_RegDate,RAR_RegTime,RAR_PAADM_DR,RAR_OEORI_DR,RAR_RegLoc_DR,RAR_Note2) 
	      values(:StudyID,:UserID,:ReceiveDate,:Receivetime,:AdmDR,:Rowid,:StudyLoc,:ImageViewParam))
	//s ^DHCXU($h,Rowid,"SQLCODE")=$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)
	Q:SQLCODE'=0 100	
    q SQLCODE
}

/// 取用户信息
ClassMethod GetUserId(UserInistials As %String) As %String
{
	i UserInistials'="" 
	{
	  
	  if $d(^SSU("SSUSR",0,"SSUSR_Initials",UserInistials))  s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserInistials,""))
	  if '$d(^SSU("SSUSR",0,"SSUSR_Initials",UserInistials)) s UserId=""
	}
	q $g(UserId)
}

}
