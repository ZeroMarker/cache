/// Creator: Candyxu
/// Create Date:2012-08-13
/// Desc：知情同意书业务层相关操作
Class EPRservice.BLL.BLRecordScan Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:根据条件查询病人基本信息列表
/// Creator: Candyxu
/// Create Date：2012-07-27 
/// Input: AStartDate 开始日期，AStartTime 开始时间，AEndDate 结束日期，AEndTime 结束时间
///       AWard 病区ID，APatientNo 病人登记号，APatientName 病人姓名
///       ALocID 科室ID，ADoctor 医护人员ID,AAdmType 就诊类型
/// Output:PAAdmType 就诊类型,PAPMINO 登记号,PAPMIDOB 出生日期,PAPMIAge 年龄,PAPMISex 性别
///       PAAdmDateTime 入院时间,PAAdmWard 病区,PAAdmRoom 病房,PAAdmBed病床,PAAdmLoc就诊科室
///       PADischgeDateTime出院时间,PAAdmDoc医生,PayMode付费类型
/// Debug:do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLRecordScan","GetPatientList","","","","","","0000986342","","","","")
Query GetPatientList(AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AWard As %String, APatientNo As %String, APatientName As %String, ALocID As %String, ADoctor As %String, AAdmVStatus As %String, AAdmType As %String, AMedicare As %String) As %Query(ROWSPEC = "PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpsoideID:%String,PatientID:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AWard As %String, APatientNo As %String, APatientName As %String, ALocID As %String, ADoctor As %String, AAdmVStatus As %String, AAdmType As %String, AMedicare As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	d DealParamter   //处理参数
 	
 	//s ^TempCandyxu = AStartDate_"^"_AStartTime_"^"_AEndDate_"^"_AEndTime_"^"_AWard_"^"_APatientNo_"^"_APatientName_"^"_ALocID_"^"_ADoctor_"^"_AAdmVStatus
    /*
    s AStartDate = $p(^TempCandyxu,"^",1)
 	s AStartTime = $p(^TempCandyxu,"^",2)
 	s AEndDate = $p(^TempCandyxu,"^",3)
 	s AEndTime =$p(^TempCandyxu,"^",4)
 	s AWard = $p(^TempCandyxu,"^",5)
 	s APatientNo = $p(^TempCandyxu,"^",6)
 	s APatientName= $p(^TempCandyxu,"^",7)
 	s ALocID =$p(^TempCandyxu,"^",8)
 	s ADoctor=$p(^TempCandyxu,"^",9)
 	s AAdmVStatus =$p(^TempCandyxu,"^",10)
    */
 	q:(AAdmVStatus = "" ) $$$OK
 	if (APatientNo '= "")
 	{
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",APatientNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}elseif (APatientName '= "")
	{ 
		s PAPMI = ""
		for {
		   s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
		   q:(PAPMI = "")
		   d OutPutPAMI
	    }	 
	}elseif(AMedicare '= "")
	{
		s ^TempCandy = AMedicare
		s PAPMI = $O(^PAPERi("Medicare1",AMedicare,""))
		q:(PAPMI = "") $$$OK
		d OutPutPAMI
	}elseif(AWard '= "")
	{
		s RoomID = ""
		for {
			 s RoomID = $o(^PAADMi("CurrWard",AWard,RoomID))
			 q:(RoomID = "")
			 s PAAdm = ""
			 for {
				 s PAAdm = $o(^PAADMi("CurrWard",AWard,RoomID,PAAdm))
				 q:(PAAdm = "")
                 q:..CheckVisitStatus(PAAdm,AAdmVStatus)
		         q:..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime)
		         d OutPutRow 
			 }
		}		
	}else
	{
		if (AStartDate '= "") {s TempDate = AStartDate-1} else {s TempDate = ""}
		for {
			s TempDate = $o(^PAADMi("DepDateTime",ALocID,TempDate))
			q:((TempDate > AEndDate) && (AEndDate '= ""))
			q:(TempDate = "")
			s TempTime = ""
			for {
				s TempTime = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime))
				q:((TempDate = AStartDate)&&(TempTime < AStartTime))
				q:((TempDate = AEndTime)&&(TempDate > AEndTime))
				q:(TempTime = "")
				s PAAdm = ""
				for {
					s PAAdm = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime,PAAdm))
					q:(PAAdm = "")
					q:..CheckVisitStatus(PAAdm,AAdmVStatus) 
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
	
OutPutPAMI
    s AdmType = ""
    for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:( AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
		     q:..CheckVisitStatus(PAAdm,AAdmVStatus)
		     //q:..CheckAdmDate(PAAdm,AStartDate,AEndDate,AStartTime,AEndTime)
		     d OutPutRow
		}
	}
	quit
OutPutRow
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   //就诊类型
	q:(PAAdmType '="")&&(PAAdmType '= AAdmType)
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  //病人姓名
	//病人姓名是否符合参数条件
	if ((APatientName '= "") && (APatientName '= PAPMIName)) q
	
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)  //登记号
	//登记号是否符合参数条件
	if ((APatientNo '= "") && (APatientNo '= PAPMINO)) q
	
	s PAPMIDOB = "" ,PAPMIAge = ""  //出生日期,年龄
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  //性别
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	if (PAAdmDateTime = ",") s PAAdmDateTime = ""
	
	s PAAdmWard = ""  //病区
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	//病区是否符合参数条件
	if ((AWard '= "") && (AWard '= WardDr)) q
	if WardDr '= "" s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	
	s PAAdmLoc = ""    //当前科室
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	//科室是否符合参数条件
	if ((ALocID '= "") && (ALocID '= Loc)) q	
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",1)

	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) //出院日期
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)  //出院时间
	s PADischgeDateTime = PADischgeDate_","_PADischgeTime
	if (PADischgeDateTime = ",") s PADischgeDateTime = ""
	
	s PAAdmDoc = ""  //医生 
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	//医生是否符合参数条件
	if ((ADoctor '= "") && (ADoctor '= Doctor)) q
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	
	s PayMode = "" //付费方式
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
 	s data = $lb(PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
DealParamter
    if ((AStartDate = $c(0)) || (AStartDate = "")) {s AStartDate = ""} else {s AStartDate = $zdh(AStartDate,3)}
    if ((AStartTime = $c(0)) || (AStartTime = "")) {s AStartTime = ""} else {s AStartTime = $zth(AStartTime)}
    if ((AEndDate = $c(0)) || (AEndDate = "")) {s AEndDate = ""} else {s AEndDate = $zdh(AEndDate,3)}
    if ((AEndTime =$c(0)) || (AEndTime = "")) {s AEndTime = ""} else {s AEndTime = $zth(AEndTime)}
    if AWard = $c(0) s AWard = ""
    if AWard '= ""
    {
       s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
       if TempWard '= "" s AWard = TempWard
    }
    if APatientNo = $c(0) s APatientNo = ""
    if APatientName = $c(0) s APatientName = ""
    if ALocID = $c(0) s ALocID = ""
    if ADoctor = $c(0) s ADoctor = ""
    if ((AAdmVStatus = $c(0)) || (AAdmVStatus = "")) s AAdmVStatus = "A"
    if ((AAdmType = $c(0)) || (AAdmType = "")) s AAdmType = "I"
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

/// Desc:时间是否在查询范围内
/// Creator: Candyxu
/// Create Date:2012-07-27
/// [Previously private]
/// [Previously private]
ClassMethod CheckAdmDate(Adm As %String, DateFrom As %Date, DateTo As %Date, TimeFrom As %Time, TimeTo As %Time) As %Status
{
	s AdmDate = $P($g(^PAADM(Adm)),"^",6)
	s AdmTime = $P($g(^PAADM(Adm)),"^",7)
	if (DateFrom '= "")&&(AdmDate < DateFrom) q 1 
	if (TimeFrom '= "") && (AdmDate = DateFrom)&&(AdmTime < TimeFrom) q 1
	If (DateTo '= "")&&(AdmDate > DateTo) q 1 
	if (TimeTo '= "")&&(AdmDate = DateTo)&&(AdmTime>TimeTo) q 1
	q 0
}

/// Desc:诊断是否有效(在院状态)
/// Creator: Candyxu
/// Create Date:2012-07-27
/// [Previously private]
ClassMethod CheckVisitStatus(Adm As %String, AAdmVisitStatue) As %Status
{
	s PAAdmVisitStatus = $p($g(^PAADM(Adm)),"^",20)
	if (PAAdmVisitStatus '= AAdmVisitStatue)
	{
		q 1
	}else
	{
		q 0
	}
}

/// Desc:查询EPRinstance.RecordScan
/// Creator:Candyxu
/// Create Date:2012-08
/// Input :AParentID,APatientID,AEpsoideID
/// Debug:do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLRecordScan","GetRecordScanList","288","0000986342","2454823")
Query GetRecordScanList(AParentID As %String, APatientID As %String, AEpsoideID As %String) As %Query(ROWSPEC = "AID:%String,AName:%String,AliasName:%String,ADescription:%String,APostion:%String,AParentID:%String,AUserID:%String,APatientID:%String,AEpisodeID:%String,ASequence:%String")
{
}

ClassMethod GetRecordScanListExecute(ByRef qHandle As %Binary, AParentID As %String, APatientID As %String, AEpsoideID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	if (APatientID '= "") && (AEpsoideID '="" && AParentID '="")
 	{
	 	s RowID = ""
	 	for {
		 	s RowID = $o(^DHCEPRI.RecordScanI("IdxParentPatientEpisodeID"," "_AParentID," "_APatientID," "_AEpsoideID,RowID))
		 	q:(RowID = "")
		 	s Name = $li(^DHCEPRI.RecordScanD(RowID),2)
		 	s Description =  $li(^DHCEPRI.RecordScanD(RowID),3)
		 	s Postion = $li(^DHCEPRI.RecordScanD(RowID),7)
		 	s ParentID = $li(^DHCEPRI.RecordScanD(RowID),4)
		 	s UserID = $li(^DHCEPRI.RecordScanD(RowID),8)
		 	s PatientID = $li(^DHCEPRI.RecordScanD(RowID),6)
		 	s EpisodeID = $li(^DHCEPRI.RecordScanD(RowID),5)
		 	s Sequence = $li(^DHCEPRI.RecordScanD(RowID),9)
		 	s AliasName = $li(^DHCEPRI.RecordScanD(RowID),10)
		    s data = $lb(RowID,Name,AliasName,Description,Postion,ParentID,UserID,PatientID,EpisodeID,Sequence)
	        s ^CacheTemp(repid,ind)=data
	        s ind=ind+1 
		}
	}

	Quit $$$OK
}

ClassMethod GetRecordScanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordScanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecordScanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordScanListExecute ]
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

/// Desc:或得科室或病区
/// Creator: Candyxu
/// Create Date: 2012-08-15
/// Input: AType 类型：E为科室，W为病区、ALocID 科室ID
/// Output: ID，描述，拼音描述
/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.BLRecordScan","GetLocOrWard","E","")
Query GetLocOrWard(AType As %String, ALocID As %String = "", ALocName As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,AliasDesc:%String")
{
}

ClassMethod GetLocOrWardExecute(ByRef qHandle As %Binary, AType As %String, ALocID As %String = "", ALocName As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($d(AType) = 0)||(AType = "") $$$OK
	
	// 业务逻辑：
	// 如果AType为“E”代表执行科室，则加载所有执行科室；如果此时LocID不为空，则加载该科室；如果ALocName不为空，则加载包含ALocName的科室；
	// 如果AType为“W”代表科室病区，则加载所有科室病区；如果此时LocID不为空，则加载该科室下的病区；如果ALocName不为空，则加载包含ALocName的病区；
	
	s Type		 = $g(AType)
	s LocID		 = $g(ALocID)
	s LocName	 = $g(ALocName)
		
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType",Type,RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		
		s Desc = $p(objCtLoc,"^",2)
		continue:(Desc [ "门诊")
		continue:(Desc [ "医院")					//华西医院专用
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		
		// 匹配科室或者病区名称，包括拼音码
		continue:(LocName '= "")&&( Desc '[ LocName)&&( $zcvt(ContactName,"U") '[ $zcvt(LocName,"U"))
		
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 

		// 匹配科室ID，如果Type为E，则只需要找到
		if (LocID '= "")
		{
			if (Type = "E")
			{
				continue:(LocID '= RowID)	
				
				s Data = $lb(RowID,Desc,ContactName)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind+1		
			}
			else
			{
				// 找指定科室下的病区
				
				//根据科室遍历病区^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
				s WardID = ""
				for { 
					s WardID = $o(^CTLOC(LocID,"LINK",0,"Loc",WardID))
					q:(WardID = "")
					
					continue:(WardID '= RowID)
										
					s Title = $p(^CTLOC(+WardID),"^",2)
					s:(Title [ "-") Title = $p(Title,"-",2)
					s TitleDesc = $p(^CTLOC(+WardID),"^",43)
					s Data = $lb(WardID,Title,TitleDesc)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1
				}
			}
		}
		else
		{
			s Data = $lb(RowID,Desc,ContactName)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1		
		}	
	}
	q $$$OK
}

ClassMethod GetLocOrWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocOrWardExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid) 	
 	q $$$OK
}

ClassMethod GetLocOrWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocOrWardExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{			
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

/// Desc:科室下所有医生
/// Creator: Candyxu
/// Create Date: 2012-08-15
/// Input:ALocID 科室ID
/// Output:用户ID,名称,拼音-Code,位置
/// Debug:d ##class(%ResultSet).RunQuery("EPRservice.BLL.BLRecordScan","GetUserListByLocID","1")
Query GetUserListByLocID(ALocID As %String) As %Query(ROWSPEC = "UserID:%String,UserDesc:%String,AliasDesc:%String,Location:%String")
{
}

ClassMethod GetUserListByLocIDExecute(ByRef qHandle As %Binary, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
		
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})

	s LocID = $g(ALocID)
	
	q:(LocID = "") $$$OK
	
	s RowID = 0
	for {
		s RowID = $o(^RB("RES",0,"CTLOC",ALocID,RowID)) 
		q:(RowID = "")
		
		s CareProvID = $p(^RB("RES",RowID),"^",2)
		continue:(CareProvID = "")
		continue:($d(^CTPCP(CareProvID)) = 0)
		
		s CareProvCode = $p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc = $p($g(^CTPCP(+CareProvID,1)),"^",2)
    	s CareProvOtherName = $p($g(^CTPCP(+CareProvID,3)),"^",28)		
		s Location = $p(^CTLOC(LocID),"^",2)
		s:(Location [ "-") Location = $p(Location,"-",2)
		s AliasDesc = CareProvCode_"-"_CareProvOtherName
    	s Data = $lb(CareProvID,CareProvDesc,AliasDesc,Location)
    	s ^CacheTemp(repid,ind) = Data
    	s ind = ind+1
	}
	q $$$OK
}

ClassMethod GetUserListByLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListByLocIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetUserListByLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListByLocIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

}
