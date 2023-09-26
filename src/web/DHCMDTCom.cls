Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2019-04-15
/// Descript: 	MDT会诊申请公共类
Class web.DHCMDTCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 医生
/// Input:       LocID - 科室ID
/// OutPut:      用户列表
/// w ##Class(web.DHCMDTCom).JsonLocUser("","1","1")
ClassMethod JsonLocUser(q As %String, LocID As %String, PrvTpID As %String) As %String
{
	n (q,LocID, PrvTpID)
	s input=q
	
	Write "["
	Set Result=##class(%Library.ResultSet).%New("web.DHCMDTCom:QueryLocUser")
 	Set Sc=Result.Execute(input,LocID,PrvTpID)
 	If $$$ISERR(Sc) Quit ""
	
	Set Count=0
	While(Result.Next()){ 
		Set Value = Result.Data("UserID")
		Set Text = Result.Data("UserName")
		
		Set Count=Count+1
		Write $case(Count,1:"",:",")
		Write ##class(web.DHCEMJsonCommon).getJsonData("value^text",Value_"^"_Text)
	}
	Write "]"
	Do Result.Close()
	Quit ""
}

/// Description: 获取患者有无检验医嘱
/// Creator:     qqa
/// CreateDate:  2021-06-08
/// Input:  	 PatientID,StDate(M),EndDate(M),QueryTypeCode(执行单Code)
/// 				 AdmType(O/E/OE),LgHospId(登录医院ID)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMInterfaceCom","QueryLocUser","90",65803,65903,"JYDO","OE","2")
Query QueryLocUser(Input, LocID, PrvTpID) As %Query(ROWSPEC = "UserID,UserName")
{
}

ClassMethod QueryLocUserExecute(ByRef qHandle As %Binary, Input, LocID, PrvTpID) As %Status
{
	n (qHandle,Input,LocID,PrvTpID)
	
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:+LocID=0 $$$OK
	;q:+PrvTpID=0 $$$OK
	s Input=$ZCVT(Input,"U")
	
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..Q:'$D(^RB("RES",0,"CTPCP",CareProvID,LocID))
	..s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	..q:(+PrvTpID'=0)&&(CTPCPCTId'=PrvTpID)
	..s DateActiveFrom = $p(^CTPCP(CareProvID,2),"^",14)
	..Q:(DateActiveFrom'="")&(DateActiveFrom>+$H) //过期退出
	..s DateActiveTo = $p(^CTPCP(CareProvID,2),"^",15)
	..Q:(DateActiveTo'="")&(DateActiveTo<+$H) //过期退出
	..s UserName=$p(^CTPCP(CareProvID,1),"^",2)
	..s OtherName=$p($g(^CTPCP(CareProvID,3)),"^",28) /// 拼音
	..Q:(Input'="")&(UserName'[Input)&($ZCVT(OtherName,"U")'[Input)
	..d OutPutUserData

    s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutPutUserData
 	s ^CacheTemp(repid,ind) = $lb(UserID,UserName)
 	s ind = ind+1
	quit
}

ClassMethod QueryLocUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocUserExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocUserExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 医生
/// Input:       LocID - 科室ID
/// OutPut:      用户列表
/// w ##Class(web.DHCMDTCom).JsonLocCareProv("","193","","2")
ClassMethod JsonLocCareProv(q, LocID As %String, PrvTpID As %String, DisGrpID As %String = "") As %String
{
	n (q, LocID, PrvTpID, DisGrpID,%session)
	s q=$ZCVT(q,"U")
	s count=0
	w "["
	
	s UserID=0
	f  s UserID=$o(^SSU("SSUSR",UserID)) q:UserID=""  d
	.s CareProvID=$p(^SSU("SSUSR",UserID),"^",14)
	.s ProvTypeID=""
	.s:CareProvID'="" ProvTypeID=$p(^CTPCP(+CareProvID,1),"^",4)
	.q:$p(^CT("CPT",+ProvTypeID),"^",3)'="Y"
	.q:$p(^CT("CPT",+ProvTypeID),"^",4)'="DOCTOR"
	.s IsHasApp=##class(web.DHCMDTCom).HasLoginApp(UserID,LocID)
	.q:IsHasApp'="Y"
	.q:'$D(^RB("RES",0,"CTPCP",CareProvID,LocID))
	.s isExist=0
	.i DisGrpID'="" s isExist=..isGrpTakUser(DisGrpID, LocID, UserID) /// 按病种组过滤
	.Q:(DisGrpID'="")&(isExist=0)
	.s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	.q:(+PrvTpID'=0)&&(CTPCPCTId'=PrvTpID)
	.s UserName=$p(^CTPCP(CareProvID,1),"^",2)   /// 用户名
	.s OtherName=$p($g(^CTPCP(CareProvID,3)),"^",28) /// 拼音
	.S UserName=##class(web.DHCMDTCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",UserName)
	.q:(q'="")&(UserName'[q)&($ZCVT(OtherName,"U")'[q)
	.s tmp=CareProvID_"^"_UserName
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 医生
/// w ##Class(web.DHCMDTCom).isGrpTakUser(2,193,13576)
ClassMethod isGrpTakUser(DisGrpID As %String, LocID As %String, UserID As %String) As %String
{
	n (DisGrpID, LocID, UserID)
	s CH="",isExist=0
	F  s CH=$o(^DHCMDTG(0,"User",UserID,DisGrpID,CH)) Q:(CH="")||(isExist=1)  D
	.Q:$p(^DHCMDTG(DisGrpID,"I",CH),"^",1)'=LocID
	.s isExist=1
	Q isExist
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 医生
/// Input:       LocID - 科室ID
/// OutPut:      用户列表
/// w ##Class(web.DHCMDTCom).IsHasLgUser("","","876")
ClassMethod IsHasLgUser(LocID As %String, PrvTpID As %String, LgUserID) As %String
{
	n (LocID,PrvTpID,LgUserID)
	s ^tempyzy("121")=$lb(LocID,PrvTpID,LgUserID)
	q:+LgUserID=0 ""
	s UserList="",Ret=""
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.Q:$p(^CT("CPT",ProvTypeID),"^",3)'="Y"
	.Q:$p(^CT("CPT",ProvTypeID),"^",4)'="DOCTOR"
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..q:LocID=""
	..Q:'$D(^RB("RES",0,"CTPCP",CareProvID,LocID))
	..s:UserList'="" UserList=UserList_"^"_UserID
	..s:UserList="" UserList=UserID
	s:UserList'="" UserList="^"_UserList_"^"
	s LgUserID="^"_LgUserID_"^"
	s:UserList[LgUserID Ret=1
	q Ret
}

/// 通过用户ID获取类别
/// w ##Class(web.DHCMDTCom).GetPrvTp("",14907)
ClassMethod GetPrvTp(CareProvID, UserID)
{
	n (CareProvID,UserID)
	s:+UserID'=0 CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	q:+CareProvID=0 ""

	s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	s CTPCPCTDesc = $p(^CT("CPT",CTPCPCTId),"^",2)
	q CTPCPCTId_"^"_CTPCPCTDesc
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 关联科室列表
/// Input:       HospID - 医院ID, LType - 科室类型代码, LocID - 科室ID
/// OutPut:      关联科室列表
/// w ##Class(web.DHCMDTCom).JsonLocList("","3","CONSULT","191")
ClassMethod JsonLocList(q As %String = "", HospID As %String, LType As %String, LocID As %String) As %String
{
	n (q, HospID, LType, LocID)
	s input=$ZCVT(q,"U")
	s count=0
	w "["
	s ParRef=$o(^CT("LL",0,"Code",LType,""))
	s CH=0
	F  s CH=$o(^CT("LL",ParRef,"LOC",CH)) Q:CH=""  D
	.s LocDr=$P($g(^CT("LL",ParRef,"LOC",CH)),"^",1)
	.Q:LocID=LocDr
	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s ContactName = $p(^CTLOC(LocDr),"^",43)
	.s ContactName = $ZCVT(ContactName,"U")   	//add sufan 2019-02-13  
	.Q:(input'="")&(LocDesc'[input)&(ContactName'[input)
	.s tmp=LocDr_"^"_LocDesc
	.Q:(HospID'="")&(HospID'=$P(^CT("LL",ParRef,"LOC",CH),"^",2))
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 科室
/// Input:       HospID - 医院ID
/// OutPut:      科室列表
/// w ##Class(web.DHCMDTCom).JsonLoc(3)
ClassMethod JsonLoc(q As %String = "", HospID As %String) As %String
{
	n (q, HospID,%session)

	s input=q 
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DateActiveFrom as DateActiveFrom, CTLOC_DateActiveTo as DateActiveTo,CTLOC_DESC as locDesc,CTLOC_Hospital_DR as HospitalId FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE UPPER(CTLOC_ContactName) LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "

    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s curDate=$p(($h),",",1)
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s DateActiveFrom=result.Data("DateActiveFrom")
		i DateActiveFrom'="" continue:DateActiveFrom>curDate //过期退出
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出
		continue:(HospID'="")&(HospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		s locDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTLoc","CTLOCDesc","",locDesc)
		s:locDesc["-" locDesc=$p(locDesc,"-",2)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 科室
/// Input:       HospID - 医院ID
/// OutPut:      科室列表
/// w ##Class(web.DHCMDTCom).JsonAllLoc("",2)
ClassMethod JsonAllLoc(q As %String = "", HospID As %String) As %String
{
	n (q, HospID)
	s q = $ZCVT(q,"U") 
	s Count=0
	w "["
	s LocID=""
	f  s LocID = $o(^CTLOC(LocID)) q:LocID=""  d
	.s Loc = $p(^CTLOC(LocID),"^",2)
	.s LocCode = $p(^CTLOC(LocID),"^",43)
	.s AllLocDesc = LocCode_Loc
	.q:(q'="")&&(AllLocDesc'[q)
	.s LocHospID=$p(^CTLOC(LocID),"^",22)
	.q:LocHospID'=HospID
	.s Tmp=LocID_"^"_Loc
	.s Count = Count+1
	.I Count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 会诊申请特殊符号转义处理
/// Input:       TmpString - 待处理字符串
/// OutPut:      转义处理后字符串
/// w ##Class(web.DHCMDTCom).TrsSpeSymbol("")
ClassMethod TrsSpeSymbol(TmpString As %String) As %String
{
	n (TmpString)
	i TmpString["TSS02" s TmpString=$REPLACE(TmpString,"TSS02","^")
	Q TmpString
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:    日期大小判断
/// Input:       FristTime - 偏移量，SecondTime - 偏移量
/// OutPut:      1-正常，0-异常
/// W ##Class(web.DHCMDTCom).isCompare("16/01/2019 11:17:54","16/01/2019 11:17:54")
ClassMethod isCompare(FristTime As %String, SecondTime As %String) As %String
{
	n (FristTime, SecondTime)
	s FristDate=$p(FristTime," ",1), FristTime=$p(FristTime," ",2)
	s SecondDate=$p(SecondTime," ",1), SecondTime=$p(SecondTime," ",2)
	Q:(FristDate="")||(SecondDate="") "1"
	s FristDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(FristDate)
	s SecondDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(SecondDate)
	Q:FristDate>SecondDate "0"
	Q:(FristTime="")||(SecondTime="") "1"
	s FristTime=$zth(FristTime,3)
	s SecondTime=$zth(SecondTime,3)
	Q:(FristDate=SecondDate)&(FristTime>SecondTime) "0"
	Q "1"
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 获取系统当前日期
/// Input:       offset - 偏移量
/// OutPut:      His格式化日期
/// w ##Class(web.DHCMDTCom).GetCurSysTime(2)
ClassMethod GetCurSysTime(offset As %String) As %String
{
	n (offset)
	s SystemDate=+$H+offset
	s SystemDate=##Class(web.DHCMDTCom).DateLogicalToHtml(SystemDate)
	Q SystemDate
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 获取系统当前日期
/// Input:       offset - 偏移量
/// OutPut:      xxxx-xx-xx格式化日期
/// w ##Class(web.DHCMDTCom).GetCurSysTime(2)
ClassMethod GetNowSysFixedDate(offset) As %String
{
	n (offset)
	s SystemDate=+$H+offset
	s SystemDate=$zd(SystemDate,3)
	Q SystemDate
}

/// Descript:js 获取医院字典信息
/// Creator:LiangQiang
/// CreateDate:2016-04-21
/// w ##Class(web.DHCMDTCom).GetHospDs()
ClassMethod GetHospDs() As %String
{
	s count=0
	w "["
	s hosprowid=""
	f  s hosprowid=$o(^CT("HOSP",hosprowid)) q:hosprowid=""  d
	.q:hosprowid=0
	.s edDate=$p(^CT("HOSP",hosprowid),"^",10) //hxy 2020-06-05 st
    	.q:(edDate'="")&(edDate<+$h) //ed
	.s hospdesc=$p(^CT("HOSP",hosprowid),"^",2) 
	.s tmp=hosprowid_"^"_hospdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 科室号别
/// Input:       LocID - 科室ID, HospID - 医院ID
/// OutPut:      号别列表
/// W ##Class(web.DHCMDTCom).jsonLocCare("67")
ClassMethod jsonLocCare(LocID As %String, HospID As %String) As %String
{
	
	n (LocID, HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RES_RowId,RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR='"_LocID_"' And (res_schedulerequired='Yes' or res_schedulerequired='Y')"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("RES_CTPCP_DR")
		s Desc = result.Data("CTPCP_Desc")
		s ResID = result.Data("RES_RowId")
		//Continue:$d(^SSU("SSUSR",0,"CTPCP",ID))
		s CTPCPCarPrvTpDR1=$p($g(^CTPCP(ID,1)),"^",4)    //人员类型ID
		s CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR1)),"^",4)
		Continue:CTCPTDesc'="DOCTOR"
		s activtFlag=$p(^CTPCP(ID,1),"^",9)
		Continue:activtFlag'="Y"
		s startDate=+$p(^CTPCP(ID,2),"^",14)
		s endDate=+$p(^CTPCP(ID,2),"^",15)
		Continue:(startDate'=0)&&(startDate>+$h)
		Continue:(endDate'=0)&&(endDate<+$h)
		//Continue:'$d(^RBAS(ResID,0,"DateSTime",+$H))
		//Continue:..HasScheduleFlag(ResID)'=1
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-17
/// Descript:   当前资源号是否有排班记录
/// Table:		RB_ApptSchedule
/// InPut:      ResID-资源表ID
/// OutPut:     0-没有排班记录，1-有排班记录
/// w ##Class(web.DHCMDTCom).HasScheduleFlag("")
ClassMethod HasScheduleFlag(ResID As %String) As %String
{
	n (ResID)
	s QuitFlag=0
	s sTime=""
	F  s sTime=$o(^RBAS(ResID,0,"DateSTime",+$H,sTime)) Q:(sTime="")||(QuitFlag=1)  D
	.s AsID=""
	.F  s AsID=$o(^RBAS(ResID,0,"DateSTime",+$H,sTime,AsID)) Q:(AsID="")||(QuitFlag=1)  D
	..Q:sTime>$p($H,",",2)
	..Q:$p(^RBAS(ResID,AsID),"^",5)<$p($H,",",2)
	..//过滤未审核 zhouxin 2018-11-09
	..s RequestID=""
	..s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",ResID_"||"_AsID,""),-1)
	..q:RequestID=""
	..s RQObj=##class(User.DHCRBApptScheduleRequest).%OpenId(RequestID)
	..s ASRRequestResult=RQObj.ASRRequestResult
	..q:ASRRequestResult'="A"
	..s QuitFlag=1
	.
	Q QuitFlag
}

/// Creator:    qqa
/// CreateDate: 2019-04-20
/// Descript:   配置权限类型
/// Table:		
/// InPut:      
/// OutPut:     JSON
/// w ##Class(web.DHCMDTCom).GetLisSetType("")
ClassMethod GetLisSetType()
{
	w "["
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text","C^职称")
	w ","
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text","G^安全组")
	w ","
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text","L^科室")
	w ","
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text","U^人员")
	w ","
	w ##class(web.DHCEMJsonCommon).getJsonData("value^text","D^全院")
	w "]"
	q ""
}

/// Descritp:	职称
/// w ##Class(web.DHCMDTCom).JsonPrvTp()
ClassMethod JsonPrvTp() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId ,CTCPT_Desc FROM CT_CarPrvTp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CTCPT_RowId")
		s Desc = result.Data("CTCPT_Desc")
		s Desc=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",Desc)
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator:    QQA
/// CreateDate: 2018-06-27
/// Descript:	
/// InPut:      
/// OutPut:     所有科室
/// w ##class(web.DHCMDTCom).QryEmConsLoc("")
ClassMethod QryEmConsLoc(q As %String)
{
	n (q)
	s Count = 0
	w "["
	s Count = Count+1
	W ##class(web.DHCEMJsonCommon).getJsonData("value^text","ALL^全院通用")
	s LocID=""
	f  s LocID = $o(^CTLOC(LocID)) q:LocID=""  d
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s LocCode = $p(^CTLOC(LocID),"^",43)
	.s LocCode = $ZCVT(LocCode,"U")   	//add sufan 2019-02-13  
	.s LocAllDesc = LocCode_LocDesc
	.q:(q'="")&&(LocAllDesc'[$$ALPHAUP^SSUTIL4(q))
	.s Count = Count+1
	.s Tmp=LocID_"^"_LocDesc
	.i Count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		疑难病专业组
/// w ##Class(web.DHCMDTCom).jsonGroup("","876")
ClassMethod jsonGroup(HospID As %String, userID As %String, LgGroupID As %String) As %String
{
	N (HospID, userID, LgGroupID)
	s LimitFlag=0 //..GetEmSysConfig("REQAUTH","^^^"_LgGroupID) /// 取产品配置参数
	i LgGroupID="567" s LimitFlag=1
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTGroup"
	i HospID'="" s sqlStr = sqlStr_" Where  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{
		s RowId = result.Data("MD_RowID")
		s Desc = result.Data("MD_Desc")
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
		//Continue:'$D(^DHCMDTG(0,"User",userID,RowId))
		s disable=""
		//i '$D(^DHCMDTG(0,"User",userID,RowId)) s disable="true"
		//i ('$D(^DHCMDTG(0,"User",userID,RowId)))&(LimitFlag=0) s disable="true"
		s TmpArr(disable_"^"_RowId)=RowId_"^"_Desc_"^"_disable
	}
	s index=""
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s tmp=$g(TmpArr(index))
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text^disabled",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text^disabled",tmp)
	w "]"
	Q ""
}

/// Descript:	是否允许开立MDT会诊
/// w ##class(web.DHCMDTCom).isPermitTakMDT("876")
ClassMethod isPermitTakMDT(userID As %String) As %String
{
	n (userID)
	Q:'$D(^DHCMDTG(0,"User",userID)) 0
	Q 1
}

/// Creator:    QQA
/// CreateDate: 2019-04-23
/// Descript:	当前用户是否有权限开MDT会诊
/// InPut:      医院ID^用户ID
/// OutPut:     0:无权限，1有权限
/// w ##class(web.DHCMDTCom).ReqMdtConsAbility("2^ALL^15222")
ClassMethod ReqMdtConsAbility(Params)
{
	n (Params)
	
	s HospID = $p(Params,"^",1)
	s LocID = $p(Params,"^",2)
	s UserID = $p(Params,"^",3)
	Q ..isPermitTakMDT(UserID)
#;	
#;	s PrvTpID=""
#;	s CareProvID=$p($g(^SSU("SSUSR",+UserID)),"^",14)
#;	s:CareProvID'="" PrvTpID=$p(^CTPCP(+CareProvID,1),"^",4)
#;	q:+PrvTpID=0 0
#;	b ;err
#;	s HasAbility=0
#;	s MDRowID=""
#;	f  s MDRowID=$o(^DHCMDTDA(0,"Loc","ALL",MDRowID)) q:(MDRowID="")||(HasAbility'=0)  d
#;	.s HasProvTpID = $p(^DHCMDTDA(MDRowID),"^",2)
#;	.s HasHospID = $p(^DHCMDTDA(MDRowID),"^",3)
#;	.s:(HasHospID=HospID)&&(HasProvTpID=PrvTpID) HasAbility=1
#;	
#;	s MDRowID=""
#;	f  s MDRowID=$o(^DHCMDTDA(0,"Loc",+LocID,MDRowID)) q:(MDRowID="")||(HasAbility'=0)  d
#;	.s HasProvTpID = $p(^DHCMDTDA(MDRowID),"^",2)
#;	.s HasHospID = $p(^DHCMDTDA(MDRowID),"^",3)
#;	.s:(HasHospID=HospID)&&(HasProvTpID=PrvTpID) HasAbility=1
#;	
#;	q HasAbility
}

/// Creator:    QQA
/// CreateDate: 2019-04-23
/// Descript:	会诊状态
/// InPut:      
/// OutPut:     
/// w ##class(web.DHCMDTCom).GetListMdtStatus()
ClassMethod GetListMdtStatus(HospID As %String) As %String
{
	n (HospID,%session)
	s Count=0
	w "["
	s StatID=0
	f  s StatID= $o(^DHCMDTS(StatID)) q:StatID=""  d
	.q:$p(^DHCMDTS(StatID),"^",3)'="Y"     /// 不可用
	.;q:$p(^DHCMDTS(StatID),"^",4)'=HospID  /// 医院
	.s Desc = $p(^DHCMDTS(StatID),"^",2)
	.q:(Desc="接收")||(Desc="拒绝")
	.s Desc=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTConsStatus","MDDesc","",Desc) //hxy 2023-01-11
	.s Count=Count+1
	.s Tmp = StatID_"^"_Desc
	.i Count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Creator:    QQA
/// CreateDate: 2019-04-24
/// Descript:	MDT会诊申请配置
/// InPut:      CosultCode-会诊申请参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     会诊申请参数类型值
/// w ##class(web.DHCMDTCom).GetEmSysConfig("HASCENTER","2")
ClassMethod GetEmSysConfig(CosultCode As %String, Params As %String) As %String
{
	n (CosultCode, Params)
	s LgHospID=$p(Params,"^",1)	  /// 医院ID
	s LgCtLocID=$p(Params,"^",2)  /// 科室ID
	s LgUserID=$p(Params,"^",3)   /// 用户ID
	s LgGroupID=$p(Params,"^",4)  /// 安全组ID
	s ResType=##Class(web.DHCMDTCom).GetAppPropValue("DHCMDT",CosultCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Descript:查询应用程序参数配置属性
/// CreateDate：2016-06-29
/// Creater：zhouxin
/// Table：DHC_EmSys,DHC_EmSysItm,DHC_EmSysItmAut
/// Input:AppCode DHC_EmSys 的code
/// FunCode DHC_EmSysItm 的code
/// Hosp:医院id
/// Loc:科室id
/// User:用户id
/// Group:安全组
/// Return:属性值
/// w ##class(web.DHCMDTCom).GetAppPropValue(2,2,2)
ClassMethod GetAppPropValue(AppCode = "", FunCode = "", Hosp = "", Loc = "", User = "", Group = "") As %Library.String
{

	s ret=""
	q:AppCode="" ret
	q:FunCode="" ret
	
	i Loc'="" d
	.s:Hosp="" Hosp=$p(^CTLOC(Loc),"^",22)
	q:Hosp="" ret
	s appId="",tmpAppId=0
	f  s tmpAppId=$o(^DHCEMS(0,"Code",AppCode,tmpAppId)) q:(tmpAppId="")||(appId'="")  d
	.s flag=$p(^DHCEMS(tmpAppId),"^",4)
	.q:flag'="Y"
	.s appHosp=$p(^DHCEMS(tmpAppId),"^",5)
	.s appId=tmpAppId
	q:appId="" ret
	s funcId=$o(^DHCEMS(0,"SYCode",appId,$$ALPHAUP^SSUTIL4(FunCode),0))
	q:funcId="" ret
	
	s priorityStr="U^G^L^D"
	f i=1:1:4 d
	.q:ret'=""
	.s type=$p(priorityStr,"^",i)
	.SET pointer=$SELECT(type="G":Group,type="L":Loc,type="U":User,type="D":"DHC")
	.q:pointer=""
	.s priorityId=""
	.f  s priorityId=$o(^DHCEMS(appId,"I",funcId,"A",priorityId)) q:(priorityId="")||(ret'="")  d
	..s code=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",1)
	..q:type'=code
	..s tmpPointer=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",2)
	..q:tmpPointer'=pointer
	..s priorityHop=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",4)
	..b
	..q:priorityHop'=Hosp
	..s ret=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",3)
	q ret
}

/// Creator:    QQA
/// CreateDate: 2019-04-24
/// Descript:	MDT签到验证
/// InPut:      用户ID,工号ID,密码
/// OutPut:     0:密码错误，1:密码验证通过,-1：用户不存在，-2：密码格式错误，
/// w ##class(web.DHCMDTCom).ViliUserPassword("","1797","2")
ClassMethod ViliUserPassword(UserID, CarePrvID, PassWord)
{
	n (UserID,CarePrvID,PassWord)
	s Ret=-1
	q:(UserID="")&&(CarePrvID="") "-2" 
	s:(UserID="")&&(CarePrvID'="") UserID= $o(^SSU("SSUSR",0,"CTPCP",CarePrvID,""),-1)
	q:'$d(^SSU("SSUSR",UserID)) "-2"
	s Pin=$$ENCR^SSUTIL2(PassWord)
	q:Pin="" "-3"
	s:Pin=$p($g(^SSU("SSUSR",UserID)),"^",15) Ret=0
	q Ret
}

/// Creator:    QQA
/// CreateDate: 2019-04-24
/// Descript:	MDT签到验证
/// InPut:      用户ID,工号ID,密码
/// OutPut:     0:密码错误，1:密码验证通过,-1：用户不存在，-2：密码格式错误，
/// w ##class(web.DHCMDTCom).ViliUserPassword("","1797","2")
ClassMethod ViliUserSignPassword(UserID, CarePrvID, PassWord)
{
	n (UserID,CarePrvID,PassWord)
	s Ret=-1
	q:(UserID="")&&(CarePrvID="") "-2" 
	s:(UserID="")&&(CarePrvID'="") UserID= $o(^SSU("SSUSR",0,"CTPCP",CarePrvID,""),-1)
	q:'$d(^SSU("SSUSR",UserID)) "-2"
	s Pin=$$ENCR^SSUTIL2(PassWord)
	q:Pin="" "-3"
	s:Pin=$p($g(^SSU("SSUSR",UserID)),"^",15) Ret=0
	q Ret
}

/// Creator:    QQA
/// CreateDate: 2019-04-24
/// Descript:	MDT会诊判断会诊是否签到：一个
/// InPut:      会诊字表ID
/// OutPut:     1：已经签到，其他:没有
/// w ##class(web.DHCMDTCom).UserIsConssignIn("139||3")
ClassMethod UserIsConssignIn(CstID)
{
	n (CstID)
	s Ret=0
	s TLRowID=""
	f  s TLRowID = $o(^DHCMDTL(0,"CstRef",CstID,TLRowID)) q:(TLRowID="")||(Ret'=0)  d
	.s Note = $p(^DHCMDTL(TLRowID),"^",6)
	.s StatusID = $p(^DHCMDTL(TLRowID),"^",3)
	.q:+StatusID=0
	.s StatusCode=$p(^DHCMDTS(StatusID),"^",1)
	.s:StatusCode="70" Ret=1
	.;s:Note["签到" Ret=1
	q Ret
}

/// Creator:    QQA
/// CreateDate: 2019-04-24
/// Descript:	MDT会诊判断会诊是否签到
/// InPut:      会诊ID
/// OutPut:     1：已经签到，其他:没有
/// w ##class(web.DHCMDTCom).IsConssignInAll("10")
ClassMethod IsConssignInAll(CstID)
{
	n (CstID)
	s Ret=1
	s CH=""
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:CH=""  D
	.s RetItm=0
	.s CstItmID = CstID_"||"_CH
	.s RetItm = ##class(web.DHCMDTCom).UserIsConssignIn(CstItmID)
	.s:RetItm=0 Ret=0
	q Ret
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT医嘱项获取
/// Input   : 	 
/// Return  :    JsonList
/// W ##Class(web.DHCMDTCom).ListArci()
ClassMethod ListArci(q) As %String
{
	n (q)
	s Count = 0
	w "["
	s ArciID=0
	f  s ArciID =$o(^ARCIM(ArciID)) q:ArciID=""  d
	.s ArciSub=0
	.f  s ArciSub =$o(^ARCIM(ArciID,ArciSub)) q:ArciSub=""  d
	..s ArciDesc = $p(^ARCIM(ArciID,ArciSub,1),"^",2)
	..s ArcAliasId=""
	..s ArcAliasId = $o(^ARC("ALIAS",0,"ARCIM",ArciID_"||"_ArciSub,""))
	..s:ArcAliasId'="" ArcAlias = $p(^ARC("ALIAS",ArcAliasId),"^",6)
	..s AllArciDesc = ArcAlias_ArciDesc
	..Q:ArciDesc'["会诊"
	..q:(q'="")&&(AllArciDesc'[$$ALPHAUP^SSUTIL4(q))
	..s Count = Count+1
	..s Tmp=ArciID_"||"_ArciSub_"^"_ArciDesc
	..i Count=1 d
	...W ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	..e  d
	...W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Descript:	插入医嘱
/// W ##Class(web.DHCMDTCom).SaveOrderItems("315","58841||1^123","4636","110","","","","","","1")
ClassMethod SaveOrderItems(EpisodeID As %String, itmmaststr As %String, UserID As %String, LocID As %String, arEmgFlag As %String, arExaReqNote As %String, arReqArcID As %String, SpeCode As %String = "", mOeori As %String = "", BillTypeID As %String = "", PackQty As %Integer = 1) As %String
{
	n (EpisodeID, itmmaststr, UserID, LocID, arEmgFlag, arExaReqNote, arReqArcID, SpeCode, mOeori, BillTypeID,PackQty)

	s CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)   /// 医生ID
	s OrderPriorId=$O(^OECPR(0,"Code","NORM",0))       /// 优先级
	s SeqNo=1
	s OrderStartDate=$zd(+$h,4)						   /// 医嘱日期
	s OrderStartTime=$zt($p($h,",",2),2)			   /// 医嘱时间
	s:BillTypeID="" BillTypeID=$o(^PAC("ADMREA",0,"Desc","自费",""),-1)  /// 费别指针:MDT会诊默认费别未自费
	s:PackQty="" PackQty=1
	s DoseQtySum=PackQty							   /// 基本单位总数量
	
	s itmmastid=$p(itmmaststr,"^",1)
	s recLocID=$p(itmmaststr,"^",2)		  	   /// 接收科室
	s ItemCatDR=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",10)  /// 医嘱子类ID
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  	   /// 医嘱子类类型
	s FreqRowid="",InstrRowid="",DurRowid=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itmmastid)
	i DrgFormRowid'="" d
	.s PHCDRowid=$P(DrgFormRowid,"||",1)
	.s ChildSub=$P(DrgFormRowid,"||",2)
	.s FreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)  /// 频次
	.s InstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5) /// 用法
	.s DurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)   /// 疗程
	/// 病人所属科研项目ID
	s PilotProStr=##Class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr(EpisodeID,UserID)
	s PPID=$P(PilotProStr,$c(1))
	
	s ListData=itmmastid_"^"_OrderType_"^"_OrderPriorId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_PackQty_"^"_""_"^"_recLocID_"^"_BillTypeID
	s ListData=ListData_"^"_DrgFormRowid_"^"_arExaReqNote_"^"_""_"^"_""_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid_"^"_""_"^"_""_"^"_SeqNo
	s ListData=ListData_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_SpeCode_"^"_""_"^"_arEmgFlag
	s $p(ListData,"^",56)=PPID
	s $p(ListData,"^",59)=arReqArcID
	s $p(ListData,"^",39)=mOeori   /// 主医嘱ID
	q:ListData="" "100"
	s ret=##Class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, ListData, UserID, LocID, CareProvID, "")
	Q:ret=100 ret
	/// 审核医嘱 (协和医院生成的医嘱未激活，需要调用此接口进行审核) bianshuai 2019-07-18
	//s Err=##class(web.DHCOEOrdItem).SavePractiseOrderItems(EpisodeID,UserID,ret,LocID)
	//Q:Err'=0 100
	q ret
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT医嘱是否收费
/// Input   : 	 
/// Return  :    1:收了，0：没收
/// W ##Class(web.DHCMDTCom).GetConsIsPayMoney(50)
ClassMethod GetConsIsPayMoney(CstID)
{
	n (CstID)	
	q:'$d(^DHCMDTORD(0,"IndexCst",CstID)) 0 //没有插入医嘱，按照未交费处理
	s AdmInAdm=$p(^DHCMDTCON(CstID),"^",20)	/// 就诊ID
	i AdmInAdm="" s AdmInAdm=$p(^DHCMDTCON(CstID),"^",1)
	s AdmInAdmType=""
	s:AdmInAdm'="" AdmInAdmType=$p(^PAADM(AdmInAdm),"^",2)
	
	s PayMoney=1
	s OrdBilled=""
	s MORowID = ""
	f  s MORowID = $o(^DHCMDTORD(0,"IndexCst",CstID,MORowID)) q:(MORowID="")||(PayMoney'=1)  d
	.//s IsPayMoney = $p(^DHCMDTORD(MORowID),"^",2)
	.s MDTOrdItm = $p(^DHCMDTORD(MORowID),"^",2)
	.Q:MDTOrdItm=""
	.s Ord=+MDTOrdItm
	.s Itm=$p(MDTOrdItm,"||",2)
	.s OrdBilled = $p(^OEORD(Ord,"I",Itm,3),"^",5)
	.
	.s:(AdmInAdmType'="I")&&(OrdBilled'="P") PayMoney=0
	.i (AdmInAdmType="I") d
	..s Sub=0
	..f  s Sub=$o(^OEORD(Ord,"I",Itm,"X",Sub)) q:Sub=""  d
	...s OrdBilled = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",6)
	...s:(OrdBilled'="P")&&(OrdBilled'="B") PayMoney=0    ///住院医嘱账单就算收费
	q PayMoney
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT获取申请科室和医生
/// Input   : 	 
/// Return  :    ListString
/// W ##Class(web.DHCMDTCom).GetConsultLocs(22)
ClassMethod GetConsultLocs(ID)
{
	n (ID)
	s CH="",CsLocDescS=""
	f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	.s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	.i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.s PrvTpID="",PrvTp=""
	.s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.i CsLocDescS="" d
	..s CsLocDescS = CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")
	.e  d
	..s CsLocDescS = CsLocDescS_","_CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")
	q CsLocDescS
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT获取预约日期
/// Input   : 	 
/// Return  :    日期
/// W ##Class(web.DHCMDTCom).GetPreDate(22)
ClassMethod GetPreDate(CstID)
{
	s PreDate=""
	s AppScDr = $p(^DHCMDTCON(CstID),"^",18)   /// 资源表ID
	s:AppScDr'="" PreDate =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	s:PreDate'="" PreDate=##Class(web.DHCMDTCom).DateLogicalToHtml(PreDate)	
	q PreDate
}

/// Creator:     qqa
/// CreateDate:  2019-04-25
/// Descript:    MDT获取预约日期
/// Input   : 	 
/// Return  :    日期
/// W ##Class(web.DHCMDTCom).GetPreDateInfo(22)
ClassMethod GetPreDateInfo(CstID)
{
	s PreDate=""
	s AppScDr = $p(^DHCMDTCON(CstID),"^",18)   /// 资源表ID
	s PreDate="",TimeRange=""
	i AppScDr'="" d
	.s PreDate =$p($g(^RBAS(+AppScDr,$p(AppScDr,"||",2))),"^",1)
	.s TimeRangeDr=$p($g(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"DHC"),"^",17)
	.s:+TimeRangeDr'=0 TimeRange=$p(^DHCTimeRange(TimeRangeDr),"^",2)
	
	s:PreDate'="" PreDate=##Class(web.DHCMDTCom).DateLogicalToHtml(PreDate)	
	q PreDate_"^"_TimeRange
}

/// Creator:     qqa
/// CreateDate:  2019-05-15
/// Descript:    MDT费别获取，如果病人类型对照费别有自费既为自费，不为自费取对照第一个
/// Input   : 	 
/// Return  :    
/// W ##Class(web.DHCMDTCom).GetMdtBilledType(2863062)
ClassMethod GetMdtBilledType(PatientID)
{
	n (PatientID)
	s BillTypeID=""
	s SocialStatusID=$p($g(^PAPER(PatientID,"PER",1)),"^",10)     /// 费别
	s:+SocialStatusID=0 BillTypeID=$o(^PAC("ADMREA",0,"Desc","自费",""),-1)  //病人类型为空费别默认自费
	s SocialToBill="^"
	//获取病人类型对应的费别串 
	s PACADMRowID ="",FirstContBill=""
	f  s PACADMRowID = $o(^DHCPACADM(0,"Social",SocialStatusID,PACADMRowID)) q:(PACADMRowID="")||(BillTypeID'="")  d
	.s AdmReasonID = $p(^DHCPACADM(PACADMRowID),"^",2)
	.s AdmReason = $p(^PAC("ADMREA",AdmReasonID),"^",2)
	.s SocialToBill=SocialToBill_AdmReason_"^"
	.s:FirstContBill="" FirstContBill=AdmReasonID
	s:SocialToBill["^自费^" BillTypeID=$o(^PAC("ADMREA",0,"Desc","自费",""),-1)
	s:SocialToBill'["^自费^" BillTypeID=FirstContBill
	s:BillTypeID="" BillTypeID=$o(^PAC("ADMREA",0,"Desc","自费",""),-1)   ///没有获取到费别取自费
	q BillTypeID
}

/// Creator:     qqa
/// CreateDate:  2019-05-15
/// Descript:    MDT患者会诊历史列表获取
/// Input   : 	 
/// Return  :    
/// W ##Class(web.DHCMDTCom).GetMdtConsList(1)
ClassMethod GetMdtConsList(PatientID, StDate = "", EndDate = "")
{
	n (PatientID,StDate,EndDate)
	s Ret=""
	s AdmType=""
	f  s AdmType = $o(^PAPERdr(PatientID,"ADM",AdmType)) q:AdmType=""  d
	.s AdmID=""
	.f  s AdmID = $o(^PAPERdr(PatientID,"ADM",AdmType,AdmID)) q:AdmID=""  d
	..s CstID = ""
	..
	..f  s CstID = $o(^DHCMDTCON(0,"Adm",AdmID,CstID)) q:CstID=""  d
	...s CstRDate=$p(^DHCMDTCON(CstID),"^",3)    /// 申请日期
	...q:(StDate'="")&&(CstRDate<StDate)
	...q:(EndDate'="")&&(CstRDate>EndDate)
	...s CstRDate=##class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)	
	...s CstRTime=$p(^DHCMDTCON(CstID),"^",4)    /// 申请时间
	...s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	...s DisGrpID=$p(^DHCMDTCON(CstID),"^",16)    /// 疑难病种
	...s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	...s ConsAddress=$p(^DHCMDTG(DisGrpID),"^",5)
	...s RBResID=$p(^DHCMDTCON(CstID),"^",17)       /// 资源ID
	...s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	...s PrvID=$p($g(^RB("RES",+RBResID)),"^",2)
	...s PrvDesc="",PrvLoc=""
	...s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	...s:PrvLocID'="" PrvLoc=$p($g(^CTLOC(PrvLocID)),"^",2)
	...s PreDateInfo = ##Class(web.DHCMDTCom).GetPreDateInfo(CstID)
	...s PreDate= $p(PreDateInfo,"^",1)
	...s PreTimeRange= $p(PreDateInfo,"^",2)
	...s ItmData = CstRDate_"^"_CstRTime_"^"_DisGroup_"^"_PrvLoc_"^"_PrvDesc_"^"_ConsAddress_"^"_PreDate_"^"_PreTimeRange
	...s:Ret'="" Ret=Ret_"!!"_ItmData
	...s:Ret="" Ret=ItmData
	q Ret
}

/// Creator:     qqa
/// CreateDate:  2019-05-15
/// Descript:    界面对于一周内再次发送MDT会诊的病人给与提示
/// Input   : 	 
/// Return  :    
/// W ##Class(web.DHCMDTCom).TipHasMdtCons("",5)
ClassMethod TipHasMdtCons(PatientID, EpisodeID = "")
{
	n (PatientID,EpisodeID)
	s:EpisodeID'="" PatientID = $p(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s MedicareNo=""
	s:EpisodeID'="" MedicareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	
	s StDate=$h-14   		//两个周
	s EndDate = $h
	s Ret=""
	s Data = ##Class(web.DHCMDTCom).GetMdtConsList(PatientID,StDate,EndDate)
	
	i Data'=""  d
	.s Ret="患者"_PatName_"，已预约"
	s Len=$L(Data,"!!")
	f i=1:1:Len d
	.s Itm = $p(Data,"!!",i)
	.q:Itm=""
	.s PreDate = $p(Itm,"^",7)
	.s PreTimeRange = $p(Itm,"^",8)
	.s DisGroup = $p(Itm,"^",3)
	.s Address =$p(Itm,"^",6)
	.s:i'=1 Ret=Ret_","
	.s Ret=Ret_PreDate_" "_PreTimeRange_"的病种为"_DisGroup_"的MDT会诊"
	s:Ret'="" Ret=Ret_"，请于当天携带病历资料前往"_Address_"参加会诊！"
	q Ret
}

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCMDTCom).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCAPPCommonDate=""
	s DHCAPPCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCAPPCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-03
/// Table: 		 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCMDTCom).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCAPPCommonDate=""
	s DHCAPPCommonDate=##class(websys.Conversions).DateLogicalToHtml(date)
	q DHCAPPCommonDate
}

/// Description: 公共 (获取系统日期格式配置)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-22
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
/// Others:	w ##class(web.DHCMDTCom).DateFormat()
ClassMethod DateFormat()
{
	n
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

/// Descript:	验证病人是否允许开医嘱
/// W ##Class(web.DHCMDTCom).GetPatNotTakOrdMsg("299","876","191","27233504")
ClassMethod GetPatNotTakOrdMsg(LgGroupID As %String, LgUserID As %String, LgLocID As %String, EpisodeID As %String) As %String
{
	n (LgGroupID, LgUserID, LgLocID, EpisodeID)
	s NotTakOrdMsg=""
	q:EpisodeID="" ""
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)  /// 病人当前状态
	s FinFlag=$p(^PAADM(EpisodeID),"^",45)      
	s PAADMDate=$p(^PAADM(EpisodeID),"^",6)     /// 就诊日期
	s PAADMTime=$p(^PAADM(EpisodeID),"^",7)     /// 就诊时间
	s PAADMDocDR=$p(^PAADM(EpisodeID),"^",9)    /// 主管医生
	s PAADMBedDR=$p(^PAADM(EpisodeID),"^",73)   /// 床位
	s today=$p($h,",",1)
	s DocID=$p(^SSU("SSUSR",LgUserID),"^",14)
 	
 	s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(EpisodeID)
 	s IfPilotAdm=$p(PilotAdmInfo,"^",1)
 	s AdmPPRowId=$p(PilotAdmInfo,"^",2)
 
 	/// 病人类型
 	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 	
 	/// 住院有主管医生才能录医嘱
 	s CFIPNeedDoctor=##Class(web.DHCDocConfig).GetConfigNode("IPNeedDoctor")
 	
 	/// 是否进行医疗结算.只有护士在医疗结算后可以录入医嘱,医生不许。
	s HaveMidDischarged=0
	i EpisodeID'="" {
	   s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
	}
	
	/// 登陆用户身份类型
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(LgUserID)
	s CareProvType=$zcvt(CareProvType,"U")
	
	/// 获取病人当前出院状态,调用护理组接口
 	s CurrentDischargeStatus="" //##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
 	
 	/// 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
    s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	s OPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("OPAdmDayLimit")
	i OPAdmDayLimit="" s OPAdmDayLimit=1
	
 	/// 系统默认疗程
 	s IPDefaultDurRowId=##Class(web.DHCDocConfig).GetConfigNode("IPDefaultDuration")

  	i (PAAdmType="I") D
  	.i (PAADMBedDR="")&(CurrentDischargeStatus'="B")&(VisitStatus'="P") d
    ..s NotTakOrdMsg="此病人未分配床位,不允许开申请."
 	.i (PAADMDocDR="")&&(CFIPNeedDoctor=1)&&(VisitStatus'="P") D
 	..s NotTakOrdMsg="此病人未分配医生,不允许开申请." 
 	.s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(EpisodeID)
	.i OrderUnabled=1 D
	..s NotTakOrdMsg="此病人正在结算中,不允许再开申请."
	.i FinFlag="Y" D
	..s NotTakOrdMsg="此病人已结算出院,不允许再开申请."
	.//i ((HaveMidDischarged=1)&&(CareProvType="DOCTOR")&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) D
	.i ((HaveMidDischarged=1)&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) D
	..s NotTakOrdMsg="此病人已做医疗结算,不允许医生再开申请."
	.i ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="")&(CurrentDischargeStatus'="B") D
	..s NotTakOrdMsg="此病人已做最终结算,不允许医护人员再开申请."
	e  d
	.i (" 1 2 "[(" "_GetStayStatusFlag_" "))&&(VisitStatus="D") D
	..s NotTakOrdMsg="此病人已结算出院,不允许再开申请."
	
	i ((VisitStatus="C")!((OPAdmDayLimit'=0)&(today-PAADMDate>(OPAdmDayLimit-1))))&(PAAdmType="O") D
	.s IfPilotAdm=##Class(web.PilotProject.DHCDocPilotProCommon).CheckPilotAdm(EpisodeID)
	.i VisitStatus="C" s warning="此病人已退号,不允许再开申请."
	.e  i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)  s NotTakOrdMsg="此就诊记录的挂号日期在"_OPAdmDayLimit_"天以前,不允许再开申请."
	
	i (PAAdmType="E")&&(" 1 2 "'[(" "_GetStayStatusFlag_" "))&&(IfPilotAdm'=1) d
 	.i ##class(web.DHCDocOrderCommon).CheckOEtime(PAADMDate,PAADMTime)=1 d
 	..s NotTakOrdMsg="此就诊记录的挂号时间在24小时以前,不允许再开申请."
 
	i NotTakOrdMsg="",PAAdmType="I",IPDefaultDurRowId="" D
	.s NotTakOrdMsg="住院没有设定默认的疗程?请与系统维护部门联系."
 	
 	/// 调用医生站新接口
	i PAAdmType'="I" D
 	.s TakOrdFlag="" //##Class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
 	.s LimUnit=$p(TakOrdFlag,"^",2)  /// 单位
 	.s LimTime=$p(TakOrdFlag,"^",3)  /// 时间
 	.i TakOrdFlag[-100 D
 	..s NotTakOrdMsg="此就诊记录的挂号时间在"_LimTime_LimUnit_"以前,不允许再开申请."
 	.
 	/// 患者状态
	s Status=##class(web.DHCDocTransfer).GetQueStatusByAdm(EpisodeID)
	i Status="报到" s NotTakOrdMsg="未报到患者不允许录入医嘱!"
 	
	Q NotTakOrdMsg
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-07-10
/// Descript:	 当前出诊列表
/// Input:       HospID - 医院ID, LType - 科室类型代码, LocID - 科室ID
/// OutPut:      关联科室列表
/// w ##Class(web.DHCMDTCom).JsOutCallLocList("","2","CONSULT")
ClassMethod JsOutCallLocList(q As %String = "", HospID As %String, LType As %String, LocID As %String) As %String
{
	n (q, HospID, LType, LocID)
	s input=$ZCVT(q,"U")
	s count=0
	w "["
	s ParRef=$o(^CT("LL",0,"Code",LType,""))
	s CH=0
	F  s CH=$o(^CT("LL",ParRef,"LOC",CH)) Q:CH=""  D
	.s LocDr=$P($g(^CT("LL",ParRef,"LOC",CH)),"^",1)
	.Q:LocID=LocDr
	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s ContactName = $p(^CTLOC(LocDr),"^",43)
	.s ContactName = $ZCVT(ContactName,"U")   	//add sufan 2019-02-13  
	.Q:(input'="")&(LocDesc'[input)&(ContactName'[input)
	.s tmp=LocDr_"^"_LocDesc
	.Q:(HospID'="")&(HospID'=$P(^CT("LL",ParRef,"LOC",CH),"^",2))
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// 获取病人登记号长度
ClassMethod GetPatRegNoLen() As %String
{
	 s PatLen=$p(^CF("PATCF",1,3),"^",5)
	 q PatLen
}

/// 通过用户ID获取类别
/// w ##Class(web.DHCMDTCom).GetPrvTpIDByCareProvID(4324)
ClassMethod GetPrvTpIDByCareProvID(CareProvID)
{
	n (CareProvID,%session)
	q:+CareProvID=0 ""
	s CTPCPCTId=$p($g(^CTPCP(CareProvID,1)),"^",4)
	s CTPCPCTDesc=$p($g(^CT("CPT",+CTPCPCTId)),"^",2)
	s CTPCPCTDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CTPCPCTDesc) //hxy 2022-12-07
	q CTPCPCTId_"^"_CTPCPCTDesc
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-15
/// Descritp:		疑难病专业组科室列表
/// w ##Class(web.DHCMDTCom).JsonGrpLoc()
ClassMethod JsonGrpLoc(q As %String = "", DisGrpID As %String = "") As %String
{
	n (q, DisGrpID,%session)
	s input=q 
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_Loc_Dr FROM DHC_MDTGroupItm"
	i DisGrpID'="" s sqlStr=sqlStr_" where MD_ParRef_Dr="_DisGrpID
    d result.Prepare(sqlStr)
	d result.Execute()
	k TmpArr
	s count = 0
	w "["
	While(result.Next())
	{
		s LocId = result.Data("MD_Loc_Dr")
		Continue:LocId=""
		s ContactName = $p(^CTLOC(LocId),"^",43)
		s LocDesc = $p(^CTLOC(LocId),"^",2)
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Continue:(input'="")&($ZCVT(ContactName,"U")'[input)&(LocDesc'[input)
		Continue:$D(TmpArr(LocId))
		s LocDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
		s TmpArr(LocId)=""
		s tmp=LocId_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator: 	 yangzongyi
/// CreateDate:  2019-07-17
/// Descript:	 医生取专家组成员
/// Input:       LocID - 科室ID 
/// OutPut:      专家组科室下拉医生
/// w ##Class(web.DHCMDTCom).JsonLocCareProv()
ClassMethod JsonLocCareProvOLD(LocID As %String) As %String
{
	n (LocID)
#;	s result = ##class(%Library.ResultSet).%New()
#;	s sqlStr = "SELECT MD_Loc_Dr,MD_User_Dr FROM DHC_MDTGroupItm"
#;  d result.Prepare(sqlStr)
#;	d result.Execute()
#;	s count = 0
#;	w "["
#;	While(result.Next())
#;	{
#;		s LocIdr = result.Data("MD_Loc_Dr")
#;		s MDUserid= result.Data("MD_User_Dr")
#;		Continue:LocIdr'=LocID
#;		s CareProvID=$p(^SSU("SSUSR",MDUserid),"^",14)
#;	    s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
#;		s tmp=CareProvID_"^"_CareProv
#;		s count = count+1
#;		I count=1 d
#;		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
#;		e  d
#;		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
#;	}
#;	w "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-15
/// Descritp:		资源预约时间
/// w ##Class(web.DHCMDTCom).JsMakResPreTime("37469||1")
ClassMethod JsMakResPreTime(mdtMakResID As %String) As %String
{
	n (mdtMakResID)
	Q:mdtMakResID="" ""
	s ID=+mdtMakResID, CH=$p(mdtMakResID,"||",2)
	s MakResDate=$p($g(^RBAS(ID,CH)),"^",1) /// 预约日期
	s:MakResDate'="" MakResDate=##Class(web.DHCMDTCom).DateLogicalToHtml(MakResDate)
	s TRRowId=$p($G(^RBAS(ID,CH,"DHC")),"^",17)
	s TRDesc=$p($g(^DHCTimeRange(+TRRowId)),"^",2)  /// 预约时段
	s StartTime=$p($g(^RBAS(ID,CH)),"^",4)
	s EndTime=$p($g(^RBAS(ID,CH)),"^",5)
	s TRange=$zt(StartTime,2)_"-"_$zt(EndTime,2)
	Q MakResDate_" "_TRange
}

/// Descript: 获取打印日期时段
/// w ##Class(web.DHCMDTCom).JsMakResDateTime("37469||8")
ClassMethod JsMakResDateTime(mdtMakResID As %String) As %String
{
	n (mdtMakResID)
	Q:mdtMakResID="" ""
	s ID=+mdtMakResID, CH=$p(mdtMakResID,"||",2)
	s MakResDate=$p($g(^RBAS(ID,CH)),"^",1) /// 预约日期
	s CsDataRange=$SYSTEM.SQL.YEAR(MakResDate)_"年"_$SYSTEM.SQL.MONTH(MakResDate)_"月"_$SYSTEM.SQL.DAYOFMONTH(MakResDate)_"日"
	s Week=$SYSTEM.SQL.DAYOFWEEK(MakResDate)
	s Week=$s(Week=2:"周一",Week=3:"周二",Week=4:"周三",Week=5:"周四",Week=6:"周五",1:"")
	s CsDataRange=CsDataRange
	s TRRowId=$p($G(^RBAS(ID,CH,"DHC")),"^",17)
	s TRDesc=$p($g(^DHCTimeRange(+TRRowId)),"^",2)  /// 预约时段
	s StartTime=$p($g(^RBAS(ID,CH)),"^",4)
	s EndTime=$p($g(^RBAS(ID,CH)),"^",5)
	s CsTimeRange=TRDesc_" "_$zt(StartTime,2)_"-"_$zt(EndTime,2)
	Q CsDataRange_"^"_CsTimeRange_"^"_Week
}

/// Creator:    bianshuai
/// CreateDate: 2019-08-05
/// Descript:   同一个病人同病种组一天内不允许申请两场会诊；
/// w ##Class(web.DHCMDTCom).isExistDisGrpCs("781","3","30/06/2021","54")
ClassMethod isExistDisGrpCs(EpisodeID As %String, DisGrpID As %String, MakResDate As %String, mdtID As %String) As %String
{
	n (EpisodeID, DisGrpID, MakResDate, mdtID)
	s MakResDate=##Class(web.DHCMDTCom).DateHtmlToLogical(MakResDate) /// 格式化
	s ID="",Flag=0
	F  s ID=$o(^DHCMDTCON(0,"Adm",EpisodeID,ID)) Q:ID=""  D
	.Q:mdtID=ID
	.s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	.Q:$p($g(^DHCMDTS(+CstStatusID)),"^",1)=10
	.Q:$p(^DHCMDTCON(ID),"^",16)'=DisGrpID   /// 疑难病种
	.Q:$p(^DHCMDTCON(ID),"^",8)'=MakResDate  /// 会诊日期
	.s Flag=1
	Q Flag
}

/// W ##Class(web.DHCMDTCom).JsonListDitItm("AppAut",2)
ClassMethod JsonListDitItm(DicCode, LgParams)
{
	n (DicCode,LgParams)
	s DicCode=$ZCONVERT(DicCode,"U")
	s LgHospID=$p(LgParams,"^",1)
	q:'$d(^DHCMDTDT(0,"Code",DicCode,LgHospID)) "[]"
	s TypeID=$o(^DHCMDTDT(0,"Code",DicCode,LgHospID,0))
	s Count=0
	w "["
	s DicItmID=0
	f  s DicItmID=$o(^DHCMDTDI(0,"Type",TypeID,DicItmID)) q:DicItmID=""  d
	.s DicItm=$p(^DHCMDTDI(DicItmID),"^",2)
	.Q:$p(^DHCMDTDI(DicItmID),"^",3)'="Y"
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s Tmp=DicItmID_"^"_DicItm
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Descript：MDT的价格
/// W ##Class(web.DHCMDTCom).GetConsPrice(163)
ClassMethod GetConsPrice(CstID)
{
	n (CstID)
	q:'$d(^DHCMDTORD(0,"IndexCst",CstID)) 0 //没有插入医嘱，按照未交费处理
	s Price=0
	s MORowID = ""
	f  s MORowID = $o(^DHCMDTORD(0,"IndexCst",CstID,MORowID)) q:MORowID=""  d
	.s MDTOrdItm = $p(^DHCMDTORD(MORowID),"^",2)
	.Q:MDTOrdItm=""
	.s Ord=+MDTOrdItm
	.s Itm=$p(MDTOrdItm,"||",2)
	.s OrdStr9=$g(^OEORD(Ord,"I",Itm,9))
	.s OrderPackQty=$p(OrdStr9,"^",4)
	.s ArcPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(MDTOrdItm)
	.s ArcPrice=ArcPrice*OrderPackQty
	.s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)
	.s Price=Price+ArcPrice
	q Price
}

ClassMethod GetAdmType(EpisodeID)
{
	n (EpisodeID)
	s AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
	q AdmType
}

/// w ##class(web.DHCMDTCom).ReqMdtConsAbilityNew("App","2","2^42^71^22067")
ClassMethod ReqMdtConsAbilityNew(AutItmCode, MID, LgParams)
{
	n (AutItmCode,MID,LgParams)
	s HospID=$p(LgParams,"^",1)
	s LocID=$p(LgParams,"^",2)
	s GroupID=$p(LgParams,"^",3)
	s UserID=$p(LgParams,"^",4)
	s HasAut="",Ret=0
	s DARowID=0
	f  s DARowID=$o(^DHCMDTDAA(0,"GroupType",MID,1,HospID,DARowID)) q:(DARowID="")||(Ret'=0)  d
	.s Ret=..IsHasAut(DARowID,AutItmCode)
	s DARowID=0
	f  s DARowID=$o(^DHCMDTDAA(0,"GroupType",MID,2,LocID,DARowID)) q:(DARowID="")||(Ret'=0)  d
	.s Ret=..IsHasAut(DARowID,AutItmCode)
	s DARowID=0
	f  s DARowID=$o(^DHCMDTDAA(0,"GroupType",MID,3,GroupID,DARowID)) q:(DARowID="")||(Ret'=0)  d
	.s Ret=..IsHasAut(DARowID,AutItmCode)
	s DARowID=0

	f  s DARowID=$o(^DHCMDTDAA(0,"GroupType",MID,4,UserID,DARowID)) q:(DARowID="")||(Ret'=0)  d
	.s Ret=..IsHasAut(DARowID,AutItmCode)
	q Ret
}

/// w ##class(web.DHCMDTCom).IsHasAut("12","App")
ClassMethod IsHasAut(DARowID, AutItmCode)
{
	n (DARowID,AutItmCode)
	s Sub=0,Ret=0
	f  s Sub=$o(^DHCMDTDAA(DARowID,"I",Sub)) q:(Sub="")||(Ret'=0)  d
	.s DicItmID=$p(^DHCMDTDAA(DARowID,"I",Sub),"^",1)
	.s DicItmCode=$p(^DHCMDTDI(+DicItmID),"^",1)
	.q:AutItmCode'=DicItmCode
	.s Ret=1
	q Ret
}

/// Creator:      周志强
/// CreatDate:    2009.03.12
/// Description:: 查询患者是否正在住院
/// Table:        PA_Adm
/// Input:        PatientID:病人ID
/// Output:         
/// Return:       AdmID
/// Others:      
/// w ##class(web.DHCMDTCom).PatInIPAdmID(2354679) 
ClassMethod PatInIPAdmID(PatientID As %String) As %String
{
	n (PatientID)
	s PaadmRowId=""
	s PatInIPAdmID=""
	f  s PaadmRowId=$O(^PAPERdr(PatientID,"ADM","I",PaadmRowId)) q:(PaadmRowId="")||(PatInIPAdmID'="")  d
	.s PatVistiStatus=$p($g(^PAADM(PaadmRowId)),"^",20)
	.q:PatVistiStatus'="A" // 不是在院病人则退出
	.q:+PaadmRowId=0
	.s PatInIPAdmID=PaadmRowId
	Q PatInIPAdmID
}

/// Desc:       取患者就诊列表
/// Creator:    zhouxin
/// CreateDate: 2014-8-19
/// Input:      EpisodeID 患者就诊id
/// OutPut:     j患者就诊信息
/// Debug:      w ##Class(web.DHCMDTCom).GetAdmList("1","10","587")
ClassMethod GetAdmList(page As %String, rows As %String, EpisodeID As %String) As %String
{
	s end = page*rows
	s start=(page-1)*rows+1
	q:+EpisodeID=0 ##class(web.DHCEMQuote).EmptyDataGrid()
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	//s FLastPeriod=+##class(web.DHCPUECommon).GetCollateLastPeriodDate(EpisodeID)

	s titlestr="EpisodeID^MedicareNo^EpisodeDate^EpisodeTime^Diagnosis^EpisodeType^EpisodeDeptDesc^MainDocName^EpisodeText^PatientID"
	
	k dataList
	
		s count=0
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
		d ds.Execute(PatientID)
		While (ds.Next())
		{
			s date=ds.Data("EpisodeDate")
			//s date=$zdh(date,3)
			s dateFlag=1
			//s:+FLastPeriod'=0 dateFlag=##class(web.DHCPUECommon).CheckQuoteDateScope(date,FLastPeriod)
			//continue:(+FLastPeriod'=0)&&(dateFlag=0)
			s $p(rowData,"^",1)=ds.Data("EpisodeID")
			s $p(rowData,"^",2)=ds.Data("MedicareNo")
			s $p(rowData,"^",3)=ds.Data("EpisodeDate")
			s $p(rowData,"^",4)=ds.Data("EpisodeTime")
			s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(ds.Data("EpisodeID"),"","","","Y")  ;##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(ds.Data("EpisodeID"))
			s $p(rowData,"^",5)=PatDiagDesc
			s $p(rowData,"^",6)=ds.Data("EpisodeType")
			s EpisodeDeptDesc=ds.Data("EpisodeDeptDesc")
			s $p(rowData,"^",7)=##Class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",EpisodeDeptDesc)
			s $p(rowData,"^",8)=ds.Data("MainDocName")
			s EpisodeText=ds.Data("EpisodeType")_" "_ds.Data("EpisodeDeptDesc")_" "_ds.Data("EpisodeDate")_" "_ds.Data("EpisodeTime")_" "_ds.Data("MainDocName")
			s $p(rowData,"^",9)=EpisodeText
			s $p(rowData,"^",10)=PatientID
			s count=count+1	
			s dataList(count)=rowData
		}		
	
	s count=0
	w "{""rows"":["
	s i=0 f  s i=$o(dataList(i)) q:i=""  d
	.s count=count+1
	.q:(count<start)||(count>end)
	.w $case(count,start:"",:",")
	.s rowData=dataList(i)
	.w ##class(web.DHCEMJsonCommon).getJsonData(titlestr,rowData)
    w "],""total"":"_count_"}"
    k dataList
	q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		字典项目
/// w ##Class(web.DHCMDTCom).GetDicItem("1")
ClassMethod GetDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s ID=$o(^DHCMDTDI(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	Q:$p(^DHCMDTDI(ID),"^",3)'="Y" ""
	Q $p(^DHCMDTDI(ID),"^",2)
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-03-21
/// Descritp:		取疑难病种专家组联络员UserID
/// w ##Class(web.DHCMDTCom).GetDisGrpConsUserID("1")
ClassMethod GetDisGrpConsUserID(mdtID As %String) As %String
{
	n (mdtID)
	s ID=$p(^DHCMDTCON(mdtID),"^",16)    /// 疑难病种
	s CH="", contUserInfo=""
	f  s CH=$o(^DHCMDTG(ID,"I",CH)) q:(CH="")||(contUserInfo'="")  d
	.s ContactsID=$p(^DHCMDTG(ID,"I",CH),"^",3)    /// 联络人标识
	.Q:ContactsID'="Y"
	.s LocID=$p(^DHCMDTG(ID,"I",CH),"^",1)     /// 科室ID
	.s userID=$p(^DHCMDTG(ID,"I",CH),"^",2)    /// 用户ID
	.s contUserInfo=LocID_"^"_userID
	.
	Q contUserInfo
}

/// Creator: 		lvpeng
/// CreateDate: 	2020-08-06
/// Descritp:		判断是否是疑难病种专家组联络员
/// w ##Class(web.DHCMDTCom).IfMDContactsFlag("1")
ClassMethod IfMDContactsFlag(mdtID As %String) As %String
{
	n (mdtID,%session)
	s LgUserID=%session.Get("LOGON.USERID")
	s LgCtLocID=%session.Get("LOGON.CTLOCID")
	s LgInfo=LgCtLocID_"^"_LgUserID
	//s LgInfo="93^11270"
	s ID=$p(^DHCMDTCON(mdtID),"^",16)    /// 疑难病种
	s CH="", contUserInfo=""
	f  s CH=$o(^DHCMDTG(ID,"I",CH)) q:(CH="")||(contUserInfo'="")  d
	.s ContactsID=$p(^DHCMDTG(ID,"I",CH),"^",3)    /// 联络人标识
	.Q:ContactsID'="Y"
	.s LocID=$p(^DHCMDTG(ID,"I",CH),"^",1)     /// 科室ID
	.s userID=$p(^DHCMDTG(ID,"I",CH),"^",2)    /// 用户ID
	.s contUserInfo=LocID_"^"_userID

	Q:LgInfo=contUserInfo 1
	Q 0
}

/// Creator:      bianshuai
/// CreateDate:   2020-04-08
/// Descript:     MDT会诊状态操作信息
/// InPut:        mdtID - 会诊ID, stCode - 状态代码
/// OutPut:       会诊状态操作信息
/// w ##Class(web.DHCMDTCom).GetCsNodeTime("2","30")
ClassMethod GetCsNodeTime(mdtID As %String, stCode As %String) As %String
{
	n (mdtID, stCode)
	Q:stCode="" ""
	Q:$p(^DHCMDTCON(+mdtID),"^",12)="" ""     /// 会诊状态
	s LgID="",LgNode="",QuitFlag=0
	F  s LgID=$o(^DHCMDTL(0,"CstRef",mdtID,LgID),-1) Q:(LgID="")||(LgNode'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCMDTL(LgID),"^",3)  /// 状态
	.Q:StatusID=""
	.Q:$p(^DHCMDTS(StatusID),"^",1)'=stCode
	.s LgUserID=$p(^DHCMDTL(LgID),"^",2)    /// 操作人
	.s LgUser=$p($g(^SSU("SSUSR",+LgUserID)),"^",2)
	.s LgDate=$p(^DHCMDTL(LgID),"^",4)      /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCMDTL(LgID),"^",5)      /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s LgNote=$p(^DHCMDTL(LgID),"^",6)      /// 备注
	.s LgNode=LgUserID_"^"_LgUser_"^"_LgDate_" "_LgTime_"^"_LgNote
	.
	Q LgNode
}

/// Creator:      bianshuai
/// CreateDate:   2020-05-07
/// Descript:     病案号
/// InPut:        mdtID - 会诊ID
/// OutPut:       会诊状态操作信息
/// w ##Class(web.DHCMDTCom).IGetMrNoByEpisodeID("2","30")
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s $ZT="ErrorMsg"
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s MedType=$p($g(^PAADM(+EpisodeID)),"^",2)	
	s MrNo=""
	s IfHaveClass=##class(websys.Conversions).IsValidClassName("DHCWMR.IO.OutService")
	i IfHaveClass=1 D
	.s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID, MedType, .ErrMsg)
	.//s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,MedType,HosptialID,.ErrMsg)
    E  D
    .s MrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
    .//s MrNo=##Class(web.DHCWMRService).IGetMrNoByPatientID(PatientID)
	Q MrNo
ErrorMsg
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2020-05-11
/// Descript:     多语言支持
/// InPut:        
/// OutPut:       
/// w ##Class(web.DHCMDTCom).GetTransDesc("2","30","","")
ClassMethod GetTransDesc(TableName As %String, FieldName As %String, Languages As %String, FieldDesc As %String) As %String
{
	n (TableName, FieldName, Languages, FieldDesc,%session)
	i $d(%session)&&(Languages="") d
	.s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
    .s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
	
	Q:(TableName="")||(FieldName="")||(Languages="")||(FieldDesc="") ""
	s $ZT="TrsErrMsg"
	s BTTransDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(TableName, FieldName, Languages, FieldDesc)
	Q BTTransDesc
TrsErrMsg
	Q FieldDesc
}

/// Creator:      bianshuai
/// CreateDate:   2020-05-11
/// Descript:     多语言支持
/// InPut:        
/// OutPut:       
/// w ##Class(web.DHCMDTCom).GetMulLanTrsDesc("2","30","")
ClassMethod GetMulLanTrsDesc(TrsType As %String, Languages As %String, FieldDesc As %String) As %String
{
	n (TrsType, Languages, FieldDesc,%session)
	i $d(%session)&&(Languages="") d
	.s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
    .s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
	i Languages="" s Languages="EN"
    
	Q:(TrsType="")||(Languages="")||(FieldDesc="") ""
	s BTTransDesc=""
	/// 科室
	i TrsType="Loc" D
	.s BTTransDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,FieldDesc)
	/// 用户
	i TrsType="User" D
	.s BTTransDesc=##class(web.DHCMDTCom).GetTransDesc("User.SSUser","SSUSRName",Languages,FieldDesc)
	/// 性别
	i TrsType="Sex" D
	.s BTTransDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTSex","CTSEXDesc",Languages,FieldDesc)
	/// 类别 hxy 2022-12-08
	i TrsType="PrvTp" D
	.s BTTransDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc",Languages,FieldDesc)
	/// 号别 hxy 2022-12-08
	i TrsType="CareProv" D
	.s BTTransDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,FieldDesc)
	Q BTTransDesc
}

/// Creator:      hxy
/// CreateDate:   2020-06-15
/// Descript:     就诊号取年龄
/// InPut:        就诊号
/// OutPut:       年龄
/// w ##Class(web.DHCMDTCom).GetPapmiAge("")
ClassMethod GetPapmiAge(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	Q:+EpisodeID=0 ""
	Q:'$d(^PAADM(EpisodeID)) ""
	s PatientID=+^PAADM(+EpisodeID)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	Q PatAge
}

/// Creator: 	 bianshuai
/// CreateDate:  2020-08-10
/// Descript:	 科室
/// Input:       HospID - 医院ID
/// OutPut:      科室列表
/// w ##Class(web.DHCMDTCom).JsonReqLoc("",2)
ClassMethod JsonReqLoc(q As %String = "", HospID As %String) As %String
{
	n (q, HospID,%session)

	s input=q 
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DateActiveTo as DateActiveTo,CTLOC_DESC as locDesc,CTLOC_Hospital_DR as HospitalId FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE UPPER(CTLOC_ContactName) LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "

    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s curDate=$p(($h),",",1)
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出
		continue:(HospID'="")&(HospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		;continue:'$D(^DHCMDTCON(0,"RLOC",locDr))  /// 科室未有过申请，退出
		s:locDesc["-" locDesc=$p(locDesc,"-",2)
		s locDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTLoc","CTLOCDesc","",locDesc)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Creator:      bianshuai
/// CreateDate:   2020-05-11
/// Descript:     获取会诊类型字典
/// W ##class(web.DHCMDTCom).JsGetDicItem("LocAddr", 2)
ClassMethod JsGetDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s mID=$o(^DHCMDTDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:mID=""
	w "["
	s ID="",count=0
	F  s ID=$o(^DHCMDTDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTDI(ID),"^",3) //可用标志
	.Q:ActCode'="Y"
	.s ListData=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.
	w "]"
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2021-01-26
/// Descript:     获取会诊费用字典
/// W ##class(web.DHCMDTCom).JsGetFeeDicItem("LocAddr", 2)
ClassMethod JsGetFeeDicItem(DisGrpID As %String, HospID As %String) As %String
{
	n (DisGrpID, HospID)

	w "["
	s ID="",count=0
	F  s ID=$o(^DHCMDTOC(0,"Group",DisGrpID,ID)) Q:ID=""  D
	.s arcimid=$p(^DHCMDTOC(ID),"^",2)
	.s itmmastid=$p(arcimid,"||",1), itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) // 医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) // 医嘱项名称
	.s ListData=arcimid_"^"_arcitmdesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.
	w "]"
	Q ""
}

/// W ##class(web.DHCMDTCom).LgUserIsContact("1", "12430")
ClassMethod LgUserIsContact(ID, LgUserID)
{
	n (ID,LgUserID)
	
	s Ret=""
	s CH=""
	f  s CH=$o(^DHCMDTG(ID,"I",CH)) q:CH=""  d
	.s LocID=$p(^DHCMDTG(ID,"I",CH),"^",1)    /// 科室ID
	.s PrvTpID=$p(^DHCMDTG(ID,"I",CH),"^",4)    /// 职称
	.s UserID=$p(^DHCMDTG(ID,"I",CH),"^",2)    /// 用户ID
	.s ContactsID=$p(^DHCMDTG(ID,"I",CH),"^",3)    /// 联络人标识
	.q:ContactsID'="Y"
	.s ValidOk=""
	.s:(UserID'="")&&(LgUserID=UserID) ValidOk=1
	.s:(UserID="") ValidOk=##class(web.DHCMDTCom).HasThisUser(LgUserID,LocID,PrvTpID)
	.q:ValidOk'=1
	.s Ret=ContactsID
	q Ret
}

/// W ##class(web.DHCMDTCom).LgUserIsConsExperts("60", "12624")
ClassMethod LgUserIsConsExperts(MdtID, LgUserID)
{
	n (MdtID,LgUserID)
	
	s Ret=""
	s CH=""
	f  s CH=$o(^DHCMDTCON(MdtID,"I",CH)) q:(CH="")||(Ret'="")  d
	.s LocID=$p(^DHCMDTCON(MdtID,"I",CH),"^",1)    /// 科室ID
	.s PrvTpID=$p(^DHCMDTCON(MdtID,"I",CH),"^",4)    /// 职称
	.s CareProvID=+$p(^DHCMDTCON(MdtID,"I",CH),"^",2)
	.s:+CareProvID=0 CareProvID=$p(^DHCMDTCON(MdtID,"I",CH),"^",3) 
	.s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s ValidOk=""
	.s:(UserID'="")&&(LgUserID=UserID) ValidOk=1
	.s:(UserID="") ValidOk=##class(web.DHCMDTCom).HasThisUser(LgUserID,LocID,PrvTpID)
	.q:ValidOk'=1
	.s:Ret="" Ret="Y"
	q Ret
}

/// Descript:通过科室和职称判断当前用户是否满足
/// Return:1:满足,"":不满足
/// W ##class(web.DHCMDTCom).HasThisUser("13454", 1,1)
ClassMethod HasThisUser(ThisUserId, LocID, PrvTpID)
{
	n (ThisUserId,LocID,PrvTpID)
	Set Ret=""
	Set Result=##class(%Library.ResultSet).%New("web.DHCMDTCom:QueryLocUser")
 	Set Sc=Result.Execute("",LocID,PrvTpID)
 	If $$$ISERR(Sc) Quit ""
	
	Set Count=0
	While(Result.Next()){ 
		Set Value = Result.Data("UserID")
		Set Text = Result.Data("UserName")
		Set:ThisUserId=Value Ret=1
		Quit:Ret
	}
	
	Quit Ret
}

/// Descript:  从电子病历获取信息
/// Creator:   lvpeng
/// CreatDate: 2021-4-16
/// Input:     adm|就诊ID
/// Outut: 	   既往史
/// w ##class(web.DHCMDTCom).GetHistoryDataByEPRService("27196920")
ClassMethod GetHistoryDataByEPRService(adm As %String = "") As %String
{
	n (adm)
    s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(adm,"HDSD00.13.01")
	s chiefcomplaint = arr.GetAt("HDSD00.13.114") ;	主诉
	s currentmedhistory = arr.GetAt("HDSD00.13.095") ;	现病史
	s pastmedhistory = arr.GetAt("HDSD00.13.300") ;	既往史
	s specialexam = arr.GetAt("HDSD00.13.118") ;	专科检查
	s auxiliaryexam = arr.GetAt("HDSD00.13.035") ;	辅助检查
	
	q chiefcomplaint_"^"_currentmedhistory_"^"_pastmedhistory_"^"_specialexam_"^"_auxiliaryexam
}

/// Creator:    QQA
/// CreateDate: 2019-11-53
/// Descript:	用户ID获取密码
/// InPut:      用户ID
/// OutPut:     密码
/// w ##class(web.DHCMDTCom).GetUserPas(1)
ClassMethod GetUserPas(userId, userCode = "")
{
	n (userId,userCode)
	s ok="",aa="",okk=""
	s:userId="" userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) //""的下一个索引
	s pin=$p($G(^SSU("SSUSR",userId)),"^",3) //密码
	s leng=$l(pin)
	q:(leng>12) ""  //加密生成超过12位退出
	f pp=1:1:leng q:okk="1"  d  //a:b:c b到c 从a开始循环
	.s ppp=..Passco(aa,pp,pin) //aa密码 pp某一位密码 pin 密文
	.;b
	.s aa=$p(ppp,"#",1)
	.s pp=$p(ppp,"#",2)
	.s okk=$p(ppp,"#",3)
	q aa
}

/// Creator:    QQA
/// CreateDate: 2019-11-53
/// Descript:	用户ID获取密码
/// InPut:      用户ID
/// OutPut:     密码
/// w ##class(web.DHCMDTCom).GetUserPas(1)
ClassMethod GetUserSignPas(userId, userCode = "")
{
	n (userId,userCode)
	s ok="",aa="",okk=""
	s:userId="" userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) //""的下一个索引
	s pin=$p($G(^SSU("SSUSR",userId)),"^",15) //签名密码
	s leng=$l(pin)
	q:(leng>12) ""  //加密生成超过12位退出
	f pp=1:1:leng q:okk="1"  d  //a:b:c b到c 从a开始循环
	.s ppp=..Passco(aa,pp,pin) //aa密码 pp某一位密码 pin 密文
	.;b
	.s aa=$p(ppp,"#",1)
	.s pp=$p(ppp,"#",2)
	.s okk=$p(ppp,"#",3)
	q aa
}

ClassMethod Passco(aa As %String, pp As %String, pin As %String)
{
	s ok="",okk=""
	s p=42
	f d=p:1:126 q:ok="1"  d //从42开始循环
	.s h=$c(d)
	.i aa="" s ppp=h
	.e  s ppp=aa_""_h 
	.s len=$l(ppp)
	.s pass=$$ENCR^SSUTIL2(ppp)
	.i pass=pin s ok="1",okk="1" 
	.i $e(pass,1,len)=$e(pin,1,len) s ok="1"
	.i ok'="1" s ppp=aa q
	.i aa="" s aa=h
	.e  s aa=aa_""_h
	q aa_"#"_pp_"#"_okk
}

/// Descript:费用总金额
/// w ##class(web.DHCMDTCom).GetCstBillFee(58)
ClassMethod GetCstBillFee(ID)
{
	n (ID)
	
	s AllBillFee=0
	s MORowID=""
	f  s MORowID=$o(^DHCMDTORD(0,"IndexCst",ID,MORowID)) q:MORowID=""  d
	.s OrdItmId=$p(^DHCMDTORD(MORowID),"^",2)
	.q:OrdItmId=""
	.s BillFee=##class(BILL.Interface.Inside.Service).IGetOrdBillFee(OrdItmId,"")
	.s AllBillFee=AllBillFee+BillFee
	q AllBillFee
}

/// Creator:    sunhuiyong
/// CreateDate: 2021-10-9
/// Descript:	MDT会诊签到日期时间
/// InPut:      会诊字表ID
/// OutPut:     日期 时间
/// w ##class(web.DHCMDTCom).UserIsConssignInDateTime("139||3")
ClassMethod UserIsConssignInDateTime(CstID)
{
	n (CstID)
	s Ret=0
	s Date=""
	s Time=""
	s TLRowID=""
	f  s TLRowID = $o(^DHCMDTL(0,"CstRef",CstID,TLRowID)) q:(TLRowID="")||(Ret'=0)  d
	.s Note = $p(^DHCMDTL(TLRowID),"^",6)
	.s StatusID = $p(^DHCMDTL(TLRowID),"^",3)
	.q:+StatusID=0
	.s StatusCode=$p(^DHCMDTS(StatusID),"^",1)
	.s:StatusCode="70" Ret=1
	.i Ret=1  d
	..s Date=$p(^DHCMDTL(TLRowID),"^",4)
	..s Time=$p(^DHCMDTL(TLRowID),"^",5)
	s:Date'="" Date=$zd(Date,3)
	s:Time'="" Time=$zt(Time,1)
	q Date_" "_Time
}

/// Descript:登录权限
/// w ##class(web.DHCMDTCom).HasLoginApp(58)
ClassMethod HasLoginApp(SSUSRRowId, CTLocId)
{
	n (SSUSRRowId,CTLocId)
	
	s DefLoginLocId=$p($G(^SSU("SSUSR",SSUSRRowId)),"^",4) //默认登录科室
	q:(DefLoginLocId=CTLocId) "Y"  ;默认登录科室
	
	s Ret="N"
	s OTHLLChildsub=""
	f  s OTHLLChildsub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub)) q:OTHLLChildsub=""  d
	.s OTHLLCTLOCDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",1)
	.s OTHLLUserGroupDR=$p(^SSU("SSUSR",SSUSRRowId,"OTHLL",OTHLLChildsub),"^",2)
	.s:CTLocId=OTHLLCTLOCDR Ret="Y"
	q Ret
}

/// Descript:医院下拉
/// w ##class(web.DHCMDTCom).getHosp()
ClassMethod getHosp()
{
		
	w "["
	s RowId=0 ,Count=0
	f  s RowId=$o(^CT("HOSP",RowId)) q:RowId=""  d
	.s HOSPDesc=$p($g(^CT("HOSP",RowId)),"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData("value^text",RowId_"^"_HOSPDesc)

	w "]"
	q ""
}

}
