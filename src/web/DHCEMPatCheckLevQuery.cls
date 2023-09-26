Import sqluser

/// Descript:   急诊病人登记
/// Creator:    bianshuai
/// CreateDate: 2016-04-11
Class web.DHCEMPatCheckLevQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 急诊病人登记
/// w ##class(web.DHCEMPatCheckLevQuery).QueryEmRegPatlist("12","1","0000000555^^Y^2^266^4636^199^^^")
ClassMethod QueryEmRegPatlist(rows As %String, page As %String, params As %String) As %String
{

	N (rows,page,params,%session)

	/// 获取系统配置类型
	s StrParam=$p(params,"^",4,7)  /// 系统参数
	s PatRegType=..GetEmSysConfig("PATTYPE",StrParam)
	i +PatRegType=1 D
	.D ##class(web.DHCEMPatCheckLevQuery).QueryEmRegPatListByQueue(rows,page,params)
	i (+PatRegType=2)||(+PatRegType=4) D
	.D ##class(web.DHCEMPatCheckLevQuery).QueryEmRegPatListByEmEmg(rows,page,params)
	i +PatRegType=3 D
	.D ##class(web.DHCEMPatCheckLevQuery).QueryEmPatByQueAndEmg(rows,page,params)
	Q ""
}

/// Descript: 急诊病人登记
/// w ##class(web.DHCEMPatCheckLevQuery).QueryEmRegPatListByEmEmg("12","1","")
ClassMethod QueryEmRegPatListByEmEmg(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s EmPatNo=$p(params,"^",1)
    s EmLevel=$p(params,"^",2)
    s EmChkFlag=$p(params,"^",3)
    s LgHospID=$p(params,"^",4)  /// 医院ID
    s EmStaTime=$p(params,"^",8) ///开始日期 2016-08-29 congyue
	S:EmStaTime'="" EmStaTime=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmStaTime) //hxy $zdh(EmStaTime,3)
    s EmEndTime=$p(params,"^",9) ///结束日期 2016-08-29 congyue
	S:EmEndTime'="" EmEndTime=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmEndTime) //$zdh(EmEndTime,3)
	;s HtmlPatName=$p(params,"^",11) //hxy 2022-09-16 //2023-02-02同登记号合二为一
    s EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevCnt4=0,EmPatLevNotCnt=0
    s del=""""
	s h=0,count=0
	s EmRegID=""
	f  s EmRegID=$o(^DOCEMREG("EM",EmRegID)) q:EmRegID=""  d
	.s PatientID=$p(^DOCEMREG("EM",EmRegID),"^",1)  /// 病人ID
	.s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记日期
	.s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	.Q:(+EmStaTime'=0)&(EmStaTime>EmRegDate) 		/// 过滤日期 2016-08-29 congyue
	.Q:(+EmEndTime'=0)&(EmRegDate>EmEndTime)		/// 过滤日期 2016-08-29 congyue
	.Q:(+EmStaTime=0)&(+$h>(EmRegDate+1))    		/// 24小时之内的病人　liangqiang
	.Q:(+EmEndTime=0)&(+$h=(EmRegDate+1))&(EmRegTime<$p($h,",",2)) //24小时之内的病人　liangqiang
	.;Q:(+$h>(EmRegDate+2))    //24小时之内的病人　liangqiang
	.;Q:(+$h=(EmRegDate+2))&(EmRegTime<$p($h,",",2)) //24小时之内的病人　liangqiang
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	.q:'$d(^PAPER(PatientID,"PAT",1))
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	.;Q:(EmPatNo'="")&(EmPatNo'=PatNo)
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	.Q:(EmPatNo'="")&(EmPatNo'=PatNo)&(PatName'[EmPatNo)
	.;q:(HtmlPatName'="")&(PatName'[HtmlPatName)
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	.s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	.;s IdentID=##Class(web.DHCEMPatCheckLev).GetPatCredTypeID() /// 身份证ID
	.;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=IdentID IdentNo=""
	.s IdentID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	.s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	.s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 /// 国家
	.s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	.s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	     /// 家庭住址
	.s SpecialPat = ##class(web.DHCEMPatCheckLevQuery).IsGroupPat(PatientID)
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	.s PatDiag=""
	.s PatCardNo="",CardTypeID=""
	.s CardNoID=..GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	.i CardNoID'="" d
	..s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 	 /// 卡号
	..s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 /// 卡类型
	.s EmPCLvID=""
	.F  s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,EmPCLvID)) Q:EmPCLvID=""  D /// 分诊ID
	..s LvLocID=$p($g(^DHCEMPCL(+EmPCLvID)),"^",10)
	..s EmRegTime=$p($g(^DHCEMPCL(+EmPCLvID)),"^",5)
	..s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	..s HospID=""
	..i LvLocID'="" s HospID=$p(^CTLOC(LvLocID),"^",22) 	/// 医院ID
	..Q:(HospID'="")&(LgHospID'=HospID)
	..//Q:+$p($g(^DHCEMPCL(+EmPCLvID)),"^",41)'=0     //zhouxin 2019-01-24  转到门诊的病人也要显示
	..s NurseLevel="",EmtArea="",EmPccID="",WaitTime="",EpisodeID=""
	..i EmPCLvID'="" d
	...s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)   /// 护士分级
	...s EmtArea=$p(^DHCEMPCL(EmPCLvID),"^",9)      /// 去向
	...s PCARowID = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""),-1)
	...;s EpisodeID="" //hxy 2020-03-24 上移
	...s:PCARowID'="" EpisodeID = $p(^DHCEMPCA(PCARowID),"^",2)
	...s WaitTime = ##class(web.DHCEMRegister).GetWaitTime(EmPCLvID,EpisodeID)
	...s:+WaitTime=0 WaitTime=##class(websys.Translation).Get("dhcem.patchecklev.hisui.csp",WaitTime)
	..s EmAdmListData=##Class(web.DHCEMPatCheckLev).GetEmPatCheckLvAdm(EmPCLvID)  /// 预检就诊ID
	..Q:(EmChkFlag="Y")&(EmAdmListData="")   ///  过滤已挂号
	..Q:(EmChkFlag="N")&(EmAdmListData'="")	 ///  过滤未挂号
	..
	..i NurseLevel'="" d
	...s EmPatLevTotal=EmPatLevTotal+1
	...;s:(NurseLevel=1)||(NurseLevel=2) EmPatLevCnt1=EmPatLevCnt1+1 //hxy 2020-02-19 st
	...;s:NurseLevel=3 EmPatLevCnt2=EmPatLevCnt2+1
	...;s:NurseLevel=4 EmPatLevCnt3=EmPatLevCnt3+1
	...s:NurseLevel=1 EmPatLevCnt1=EmPatLevCnt1+1
	...s:NurseLevel=2 EmPatLevCnt2=EmPatLevCnt2+1
	...s:NurseLevel=3 EmPatLevCnt3=EmPatLevCnt3+1
	...s:(NurseLevel=4)||(NurseLevel=5) EmPatLevCnt4=EmPatLevCnt4+1 //ed
	..E  s EmPatLevNotCnt=EmPatLevNotCnt+1
	..
	..Q:(EmLevel'="")&(EmLevel'=EmtArea)           ///  去向过滤
 	..Q:(EmPCLvID'="")&($p(params,"^",10)'="")&($p(params,"^",10)'=EmPCLvID)    //QQA 2016-11-12
 	..
	..s h=h+1
	..s ListData=EmRegID_"^"_EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_PatCardNo_"^"_CardNoID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatDiag
	..s ListData=ListData_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_EmPCLvID_"^"_NurseLevel_"^"_CardTypeID_"^"_""
	..s ListData=ListData_"^"_PatYBCode_"^"_IdentID_"^"_SpecialPat_"^"_WaitTime_"^"_EpisodeID
	..s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,h)=ListData
	.	
	//i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	//q:h=0 
	
	///转换数据为Json格式
	S ListTitle="EmRegID^EmRegDate^EmRegTime^PatientID^PatCardNo^CardNoID^PatNo^PatName^sexId^PatSex^PatDiag^PatAge^nationdr^countrydr^birthday^IdentNo^PatTelH^Address^BillType^EmPCLvID^NurseLevel^CardTypeID^Adm"
	S ListTitle=ListTitle_"^PatYBCode^IdentID^SpecialPat^WaitTime^EpisodeID"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-19
	w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt
	w "}"
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript: 急诊病人挂号队列
/// w ##class(web.DHCEMPatCheckLevQuery).QueryEmRegPatListByQueue("12","1","^^N")
ClassMethod QueryEmRegPatListByQueue(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
    
    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s StrParam=$p(params,"^",4,7)
    s OneSelfLoc=..GetEmSysConfig("ONSELFLOC",StrParam)   ///是否在分诊界面只显示挂了本科室号的就诊
    s EmPatNo=$p(params,"^",1)
    s EmLevel=$p(params,"^",2)
    s EmChkFlag=$p(params,"^",3)
    s LgHospID=$p(params,"^",4)   /// 医院ID
    s LgLocID=$p(params,"^",5)      /// 科室ID
    
    s EmStaDate=$p(params,"^",8) ///开始日期 2016-08-29 congyue
	S:EmStaDate'="" EmStaDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmStaDate)  //hxy $zdh(EmStaDate,3)
    s EmEndDate=$p(params,"^",9) ///结束日期 2016-08-29 congyue
	S:EmEndDate'="" EmEndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmEndDate)  //hxy $zdh(EmEndDate,3)
	;s HtmlPatName=$p(params,"^",11) //hxy 2022-09-16
	
    s EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevCnt4=0,EmPatLevNotCnt=0
    s del=""""
	s h=0,count=0

    i EmStaDate="" s EmStaDate=+$H-2
    i EmEndDate="" s EmEndDate=+$H
    
	f dd=EmEndDate:-1:EmStaDate D
	.s LocID=""
	.f  s LocID=$O(^User.DHCQueueI("QueDateDeptIndex",dd,LocID)) Q:LocID=""  D
	..Q:$p($g(^CTLOC(+LocID)),"^",22)'=LgHospID //hxy 2020-03-24 $g
	..q:(OneSelfLoc=1)&&(LgLocID'=LocID)
	..s que="" 
	..f  s que=$O(^User.DHCQueueI("QueDateDeptIndex",dd,LocID,que),-1) Q:que=""  D
	...s EpisodeID=$List(^User.DHCQueueD(que),11)
	...Q:$p(^PAADM(EpisodeID),"^",2)'="E" 	           /// 就诊类型
	...s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus="C"  //退号  liangqiang
	...s AdmTime=$p(^PAADM(EpisodeID),"^",7)
	...s WaitTime = ##class(web.DHCEMRegister).GetWaitTime("",EpisodeID)
	...s:+WaitTime=0 WaitTime=##class(websys.Translation).Get("dhcem.patchecklev.hisui.csp",WaitTime)
	...q:(+$h>(dd+1))&(EmStaDate="")
	...q:(+$h=(dd+1))&($p($h,",",2)>AdmTime)&(EmStaDate="")  //liangqiang 24小时就诊记录
    ...s AdmDocCodeDr=$p(^PAADM(EpisodeID),"^",9)
    ...s RegDocLocDr=$p(^CTPCP(AdmDocCodeDr,1),"^",2)
    ...s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	...s ststusDr=$List(^User.DHCQueueD(que),14)
	...s queDocDr=$List(^User.DHCQueueD(que),8)
	...s queDoc=$p(^CTPCP(queDocDr,1),"^",2)
	...s EmPCLvID=""
	...s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	...Q:+$p($g(^DHCEMPCL(+EmPCLvID)),"^",41)'=0
	...s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)  	/// 病人ID
	...s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	/// 登记日期
	...s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate)  //$zd(EmRegDate,3) 
	...s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	/// 登记时间
	...s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	...s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	...;Q:(EmPatNo'="")&(EmPatNo'=PatNo)
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	...Q:(EmPatNo'="")&(EmPatNo'=PatNo)&(PatName'[EmPatNo)
	...;q:(HtmlPatName'="")&(PatName'[HtmlPatName)
	...s PatSex=""
	...s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	...i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	...s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	...s PatAge= ##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  /// 年龄
	...s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	...i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	...s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	...;s IdentID=##Class(web.DHCEMPatCheckLev).GetPatCredTypeID() /// 身份证ID
	...;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=IdentID IdentNo=""
	...s IdentID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	...s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	...s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	  /// 国家
	...s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  /// 电话 
	...s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  /// 家庭住址
	...s SpecialPat = ##class(web.DHCEMPatCheckLevQuery).IsGroupPat(PatientID)
	...s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	...;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	...s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	...s PatDiag=""
	...s PatCardNo="",CardTypeID=""
	...s CardNoID=..GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	...i CardNoID'="" d
	....s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 	 /// 卡号
	....s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16)  /// 卡类型
	...s NurseLevel="",EmtArea=""
	...i EmPCLvID'="" d
	....s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)   /// 护士分级
	....s EmtArea=$p(^DHCEMPCL(EmPCLvID),"^",9)      /// 去向
	...i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	...
	.../// 已挂号别描述  2017-02-25 bianshuai
	...s index=PatientID_"^"_EmPCLvID
	...I '$D(TmpEmRegPat(index)) S TmpEmRegPat(index)=queDoc
	...E  S TmpEmRegPat(index)=TmpEmRegPat(index)_"、"_queDoc
	...
	...s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,PatientID_"^"_EmPCLvID,EpisodeID)=AdmDocCodeDr_","_AdmLocID
	...Q:$d(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,EmPCLvID_"^"_PatientID))
	...s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,EmPCLvID_"^"_PatientID)=""
	...
	...Q:(EmChkFlag="Y")&(EmPCLvID="")               ///  过滤已分诊
	...Q:(EmChkFlag="N")&(EmPCLvID'="")			    ///  过滤未分诊
	...
	...i NurseLevel'="" d
	....s EmPatLevTotal=EmPatLevTotal+1
	....;s:(NurseLevel=1)||(NurseLevel=2) EmPatLevCnt1=EmPatLevCnt1+1 //hxy 2020-02-19 st
	....;s:NurseLevel=3 EmPatLevCnt2=EmPatLevCnt2+1
	....;s:NurseLevel=4 EmPatLevCnt3=EmPatLevCnt3+1
	....s:NurseLevel=1 EmPatLevCnt1=EmPatLevCnt1+1
	....s:NurseLevel=2 EmPatLevCnt2=EmPatLevCnt2+1
	....s:NurseLevel=3 EmPatLevCnt3=EmPatLevCnt3+1
	....s:(NurseLevel=4)||(NurseLevel=5) EmPatLevCnt4=EmPatLevCnt4+1 //ed
	...E  s EmPatLevNotCnt=EmPatLevNotCnt+1
	...
	...Q:(EmLevel'="")&(EmLevel'=EmtArea)            ///  去向过滤
	...Q:(EmPCLvID'="")&($p(params,"^",10)'="")&($p(params,"^",10)'=EmPCLvID)    //QQA 2016-11-12
	...
	...s h=h+1
	...s ListData=""_"^"_EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_PatCardNo_"^"_CardNoID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatDiag
	...s ListData=ListData_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_EmPCLvID_"^"_NurseLevel_"^"_CardTypeID_"^"_queDoc
    ...s ListData=ListData_"^"_PatYBCode_"^"_IdentID_"^"_SpecialPat_"^"_WaitTime_"^"_EpisodeID
	...s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,PatientID_"^"_EmPCLvID)=ListData
	..
	
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index))
	.s AdmDate=$p(ListData,"^",2)
	.s AdmTime=$p(ListData,"^",3)
	.s newindex=AdmDate_"^"_AdmTime_","_index
	.s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlistNew",pid,newindex)=ListData
	.
	//w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	i h=0 d
	.w "{"_del_"total"_del_":"_h_","_del_"rows"_del_":[]"
	.w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	.w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	.w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-19
	.w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt
    .w "}"   //liangqiang
	q:h=0 
	
	///转换数据为Json格式:如需增加返回值保留Adm以及EpiRegData在最后在上方末尾拼接数据
	S ListTitle="EmRegID^EmRegDate^EmRegTime^PatientID^PatCardNo^CardNoID^PatNo^PatName^sexId^PatSex^PatDiag^PatAge^nationdr^countrydr^birthday^IdentNo^PatTelH^Address^BillType^EmPCLvID^NurseLevel^CardTypeID^QueDoc"
	s ListTitle = ListTitle_"^PatYBCode^IdentID^SpecialPat^WaitTime^EpisodeID"
	s ListTitle = ListTitle_"^Adm^EpiRegData"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlistNew",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlistNew",pid,index))
	.Q:ListData=""
	.s TmpEpiData="",TmpEpiRegData=""
	.s index3=$p(index,",",2)
	.s $p(ListData,"^",23)=$g(TmpEmRegPat(index3))  /// 挂号信息 2017-02-25 bianshuai
	.s index2=""
	.f  s index2=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index3,index2)) q:index2=""  d
	..s RegLocDr=^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid,index3,index2)
	..i TmpEpiData="" s TmpEpiData=index2
	..E  s TmpEpiData=TmpEpiData_"#"_index2
	..;
	..i '$d(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist","RegLoc",pid,index3,RegLocDr)) d
	...i TmpEpiRegData="" s TmpEpiRegData=RegLocDr
	...e  s TmpEpiRegData=TmpEpiRegData_"#"_RegLocDr
    ..s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist","RegLoc",pid,index3,RegLocDr)=""
	.. 
	.s ListData=ListData_"^"_TmpEpiData_"^"_TmpEpiRegData
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-19
	w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt
	w "}"
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript: 急诊病人挂号队列和登记
/// w ##class(web.DHCEMPatCheckLevQuery).QueryEmPatByQueAndEmg("12","1","^^N^2^67^69^199")
ClassMethod QueryEmPatByQueAndEmg(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
    
    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
   
    s EmPatNo=$p(params,"^",1)  /// 登记号
    s EmLevel=$p(params,"^",2)  /// 分级
    s EmChkFlag=$p(params,"^",3) /// 是否挂号/是否就诊
    ;s HtmlPatName=$p(params,"^",11) //hxy 2022-09-16
    
	/// 挂号队列
	D ..QueryEmPatByQue(pid, params)
	/// 登记队列
	D ..QueryEmPatByEmg(pid, params)

    s EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevCnt4=0,EmPatLevNotCnt=0
    s del=""""
	s h=0

	s index=""
	F  s index=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueAndEmg",pid,index)) Q:index=""  D
	.s PatientID=$p(index,"^",1)  /// 病人ID
	.s EpisodeID=$p(index,"^",2)  /// 就诊ID
	.s QueDoc=$p(index,"^",3)     /// 号别
	.s EmPCLvID=$p(index,"^",4)   /// 分级ID
	.s EmRegID=$p(index,"^",5)    /// 登记ID
	.s EmRegDate=$p(index,"^",6)  /// 登记日期
	.s EmRegTime=$p(index,"^",7)  /// 登记时间
	.s uniqueID=$p(index,"^",8)   /// 记录标示
	.s QueDocLoc=$p(index,"^",9)  /// 挂号记录
	.Q:'$d(^PAPER(PatientID,"PAT",1))
	.s index2=PatientID_"^"_EmPCLvID
	.i uniqueID="B" D
	..I '$D(TmpEmRegPat(index2)) S TmpEmRegPat(index2)=QueDoc 	    /// 号别
	..E  S TmpEmRegPat(index2)=TmpEmRegPat(index2)_"、"_QueDoc
	..I '$D(TmpEmPatEpi(index2)) S TmpEmPatEpi(index2)=EpisodeID 	/// 就诊ID
	..E  S TmpEmPatEpi(index2)=TmpEmPatEpi(index2)_"、"_EpisodeID
	..I '$D(TmpEmPatQue(index2)) S TmpEmPatQue(index2)=QueDocLoc 	/// 号别,科室
	..E  S TmpEmPatQue(index2)=TmpEmPatQue(index2)_"#"_QueDocLoc
	.Q:(uniqueID="B")&$D(TmpEmPat(index2))  /// 记录相同记录
	.i uniqueID="B" s TmpEmPat(index2)=""
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	.;Q:(EmPatNo'="")&(EmPatNo'=PatNo)
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	.Q:(EmPatNo'="")&(EmPatNo'=PatNo)&(PatName'[EmPatNo)
	.;q:(HtmlPatName'="")&(PatName'[HtmlPatName)
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	.s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	.;s IdentID=##Class(web.DHCEMPatCheckLev).GetPatCredTypeID() /// 身份证ID
	.;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=IdentID IdentNo=""
	.s IdentID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	.s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	.s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	 /// 国家
	.s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	.s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	     /// 家庭住址
	.s SpecialPat = ##class(web.DHCEMPatCheckLevQuery).IsGroupPat(PatientID)
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	.s PatDiag=""
	.i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	.s WaitTime = ##class(web.DHCEMRegister).GetWaitTime("",EpisodeID)
	.s:+WaitTime=0 WaitTime=##class(websys.Translation).Get("dhcem.patchecklev.hisui.csp",WaitTime)
	.s PatCardNo="",CardTypeID=""
	.s CardNoID=..GetPatCardNoID(PatientID)  		          /// 病人卡号ID
	.i CardNoID'="" d
	..s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 	  /// 卡号
	..s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	  /// 卡类型
	.s NurseLevel="",EmtArea="",EmPccID=""
	.i EmPCLvID'="" d
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)   /// 护士分级
	..s EmtArea=$p(^DHCEMPCL(EmPCLvID),"^",9)      /// 去向
	.
	.i NurseLevel'="" d
	..s EmPatLevTotal=EmPatLevTotal+1
	..;s:(NurseLevel=1)||(NurseLevel=2) EmPatLevCnt1=EmPatLevCnt1+1 //hxy 2020-02-19
	..;s:NurseLevel=3 EmPatLevCnt2=EmPatLevCnt2+1
	..;s:NurseLevel=4 EmPatLevCnt3=EmPatLevCnt3+1
	..s:NurseLevel=1 EmPatLevCnt1=EmPatLevCnt1+1
	..s:NurseLevel=2 EmPatLevCnt2=EmPatLevCnt2+1
	..s:NurseLevel=3 EmPatLevCnt3=EmPatLevCnt3+1
	..s:(NurseLevel=4)||(NurseLevel=5) EmPatLevCnt4=EmPatLevCnt4+1 //ed
	.E  s EmPatLevNotCnt=EmPatLevNotCnt+1
	.
	.Q:(EmLevel'="")&(EmLevel'=EmtArea)           ///  去向过滤
 	.Q:(EmPCLvID'="")&($p(params,"^",10)'="")&($p(params,"^",10)'=EmPCLvID)    //QQA 2016-11-12
 	.
	.s h=h+1
	.s ListData=EmRegID_"^"_EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_PatCardNo_"^"_CardNoID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatDiag
	.s ListData=ListData_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_EmPCLvID_"^"_NurseLevel_"^"_CardTypeID_"^^^^"_uniqueID
	.s ListData=ListData_"^"_PatYBCode_"^"_IdentID_"^"_SpecialPat_"^"_WaitTime_"^"_EpisodeID
	.s index3=EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_EmPCLvID_"^"_h
	.s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueEmgTotal",pid,index3)=ListData

	//i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	//q:h=0 
	
	///转换数据为Json格式
	s count=0
	S ListTitle="EmRegID^EmRegDate^EmRegTime^PatientID^PatCardNo^CardNoID^PatNo^PatName^sexId^PatSex^PatDiag^PatAge^nationdr^countrydr^birthday^IdentNo^PatTelH^Address^BillType^EmPCLvID^NurseLevel^CardTypeID^QueDoc^Adm^EpiRegData^uniqueID"
	S ListTitle=ListTitle_"^PatYBCode^IdentID^SpecialPat^WaitTime^EpisodeID"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueEmgTotal",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueEmgTotal",pid,index))
	.s index2=$p(index,"^",3)_"^"_$p(index,"^",4)
	.s $p(ListData,"^",23)=$g(TmpEmRegPat(index2))  /// 挂号信息
	.s $p(ListData,"^",24)=$g(TmpEmPatEpi(index2))  /// 就诊记录
	.s $p(ListData,"^",25)=$g(TmpEmPatQue(index2))  /// 挂号记录
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	w ","_del_"EmPatLevTotal"_del_":"_EmPatLevTotal_","_del_"EmPatLevCnt1"_del_":"_EmPatLevCnt1
	w ","_del_"EmPatLevCnt2"_del_":"_EmPatLevCnt2_","_del_"EmPatLevCnt3"_del_":"_EmPatLevCnt3
	w ","_del_"EmPatLevCnt4"_del_":"_EmPatLevCnt4 //hxy 2020-02-19
	w ","_del_"EmPatLevNotCnt"_del_":"_EmPatLevNotCnt
	w "}"
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript: 查询挂号队列
ClassMethod QueryEmPatByQue(pid As %String, params As %String) As %String
{
	n (pid, params,%session)
	s StrParam=$p(params,"^",4,7)
    s OneSelfLoc=..GetEmSysConfig("ONSELFLOC",StrParam)   ///是否在分诊界面只显示挂了本科室号的就诊
	/// 挂号队列
	s EmChkFlag=$p(params,"^",3)    /// 分诊标志
	s LgHospID=$p(params,"^",4)     /// 医院ID
	s LgLocID=$p(params,"^",5)      /// 科室ID
    s EmStaDate=$p(params,"^",8) 	/// 开始日期
	S:EmStaDate'="" EmStaDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmStaDate) ;$zdh(EmStaDate,3)
    s EmEndDate=$p(params,"^",9) 	/// 结束日期
	S:EmEndDate'="" EmEndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmEndDate) ;$zdh(EmEndDate,3)
	
	i EmStaDate="" s EmStaDate=+$H-2
    i EmEndDate="" s EmEndDate=+$H
	s num=0
	f dd=EmEndDate:-1:EmStaDate D
	.s LocID=""
	.f  s LocID=$O(^User.DHCQueueI("QueDateDeptIndex",dd,LocID)) Q:LocID=""  D
	..Q:$p($g(^CTLOC(+LocID)),"^",22)'=LgHospID //hxy 2020-03-24 $g
	..q:(OneSelfLoc=1)&&(LgLocID'=LocID)
	..s que="" 
	..f  s que=$O(^User.DHCQueueI("QueDateDeptIndex",dd,LocID,que),-1) Q:que=""  D
	...s EpisodeID=$List(^User.DHCQueueD(que),11)
	...Q:$p(^PAADM(EpisodeID),"^",2)'="E" 	           /// 就诊类型
	...s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
	...q:VisitStatus="C"  //退号  liangqiang
	...s AdmTime=$p(^PAADM(EpisodeID),"^",7)
	...q:(+$h>(dd+1))&(EmStaDate="")
	...q:(+$h=(dd+1))&($p($h,",",2)>AdmTime)&(EmStaDate="")  //liangqiang 24小时就诊记录
	...s AdmDocCodeDr=$p(^PAADM(EpisodeID),"^",9)
    ...s RegDocLocDr=$p(^CTPCP(AdmDocCodeDr,1),"^",2)
    ...s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	...s ststusDr=$List(^User.DHCQueueD(que),14)
	...s queDocDr=$List(^User.DHCQueueD(que),8)
	...s queDoc=$p(^CTPCP(queDocDr,1),"^",2)
    ...s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)  	/// 病人ID
    ...s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
    ...Q:+$p($g(^DHCEMPCL(+EmPCLvID)),"^",41)'=0
    ...//i EmPCLvID'="" Q:$d(^DHCEMPCC(0,"PatCheckLev",EmPCLvID))  	/// 有号别信息,属于分诊病人,此处过滤
    ...i EmPCLvID'="" Q:..GetEmPatFlag(EmPCLvID)
    ...Q:(EmChkFlag="Y")&(EmPCLvID="")              ///  过滤已分诊
	...Q:(EmChkFlag="N")&(EmPCLvID'="")			    ///  过滤未分诊
	...s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	///  就诊日期
	...s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy 2017-03-31 $zd(EmRegDate,3) 
	...s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	///  就诊时间
	...s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
    ...s num=num+1
    ...s index=PatientID_"^"_EpisodeID_"^"_queDoc_"^"_EmPCLvID_"^^"_EmRegDate_"^"_EmRegTime_"^B^"_AdmDocCodeDr_","_AdmLocID_"^"_num
	...s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueAndEmg",pid,index)=""
	Q ""
}

/// Descript: 查询登记队列
ClassMethod QueryEmPatByEmg(pid As %String, params As %String) As %String
{
	n (pid, params)
	/// 登记队列
	s EmChkFlag=$p(params,"^",3)    /// 挂号标志
	s LgHospID=$p(params,"^",4)     /// 医院ID
	s EmStaTime=$p(params,"^",8) 	/// 开始日期
	S:EmStaTime'="" EmStaTime=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmStaTime) ;$zdh(EmStaTime,3)
    s EmEndTime=$p(params,"^",9) 	/// 结束日期
	S:EmEndTime'="" EmEndTime=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EmEndTime ) ;$zdh(EmEndTime,3)
	s num=0
	s EmRegID="",EpisodeID=""
	f  s EmRegID=$o(^DOCEMREG("EM",EmRegID)) q:EmRegID=""  d
	.s PatientID=$p(^DOCEMREG("EM",EmRegID),"^",1)  /// 病人ID
	.s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记日期
	.s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	.Q:(+EmStaTime'=0)&(EmStaTime>EmRegDate) 		/// 过滤日期 2016-08-29 congyue
	.Q:(+EmEndTime'=0)&(EmRegDate>EmEndTime) 		/// 过滤日期 2016-08-29 congyue
	.Q:(+EmStaTime=0)&(+$h>(EmRegDate+1))   		/// 24小时之内的病人　liangqiang
	.Q:(+EmEndTime=0)&(+$h=(EmRegDate+1))&(EmRegTime<$p($h,",",2)) //24小时之内的病人　liangqiang
	.Q:EmChkFlag="N"
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	.s EmPCLvID=""
	.F  s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,EmPCLvID)) Q:EmPCLvID=""  D /// 分诊ID
	..s LvLocID=$p($g(^DHCEMPCL(+EmPCLvID)),"^",10)
	..s HospID=""
	..i LvLocID'="" s HospID=$p($g(^CTLOC(+LvLocID)),"^",22) 	/// 医院ID //hxy 2020-03-24 $g
	..Q:LgHospID'=HospID
	..Q:+$p($g(^DHCEMPCL(+EmPCLvID)),"^",41)'=0
	..//Q:'$d(^DHCEMPCC(0,"PatCheckLev",EmPCLvID))  	/// 无号别信息,属于先挂号病人,此处过滤
	..Q:'..GetEmPatFlag(EmPCLvID)
	..s PCAID = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,"")) //hxy 2020-03-24 st
	..s:PCAID'="" EpisodeID = $p($g(^DHCEMPCA(PCAID)),"^",2) //ed
	..s num=num+1
	..s index=PatientID_"^"_EpisodeID_"^^"_EmPCLvID_"^"_EmRegID_"^"_EmRegDate_"^"_EmRegTime_"^A^"_num
	..s ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueAndEmg",pid,index)=""
	Q ""
}

/// Descript: 是否是特殊病人【抢救、绿色通道、三无病人】
/// W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatFlag()
ClassMethod GetEmPatFlag(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	Q:$p(^DHCEMPCL(EmPCLvID),"^",47)'="" 1    		/// 抢救病区
	Q:$d(^DHCEMPGR(0,"PatCheckLev",EmPCLvID)) 1 	/// 绿色通道
    s EmPatTypeID=+$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群
    Q:$p($g(^DHCEMPT(EmPatTypeID)),"^",2)["三无" 1
    Q 0
}

/// Descript: 获取二次分诊对应的号别
/// w ##class(web.DHCEMPatCheckLevQuery).GetMarkTarget(67,3)
ClassMethod GetMarkTarget(loc As %String, mark As %String) As %String
{
	n (loc,mark)
	s i=0,ret=""
#;	&sql(DECLARE MarkCursor CURSOR FOR select MarkTarget INTO :markTarget from DHC_OPChgDepMarkSet where DepSource=:loc and MarkSource=:mark)
#;	&sql(OPEN MarkCursor)
#;    FOR { &sql(FETCH MarkCursor)
#;        QUIT:SQLCODE  
#;    	s i=i+1
#;    	s $p(ret,"^",i)=markTarget
#; 	}
#;   &sql(CLOSE MarkCursor)
   q ret
}

/// Descript: 急诊病人登记
/// w ##class(web.DHCEMPatCheckLevQuery).GetEmRegPatInfo("0000001281","1281")
ClassMethod GetEmRegPatInfo(EmPatNo As %String, PatientID As %String) As %String
{
	n (EmPatNo, PatientID,%session)
	s LgHospID=%session.Get("LOGON.HOSPID")
    i PatientID="" s PatientID=$o(^PAPERi("PAPMI_PatNo",EmPatNo,""))
    Q:PatientID="" ""
    s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)   ///病人死亡标记
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	//s PatAge=##Class(web.DHCEMPatCheckLevCom).GetAge(PatientID)  /// 年龄
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	b ;1
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s SpecialPat = ##class(web.DHCEMPatCheckLevQuery).IsGroupPat(PatientID)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	s PatDiag=""
	//s EpisodeID=$o(^PAPERdr(PatientID,"ADM","E",""),-1)
	//i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) //诊断
	s CardNoID=..GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	s PatCardNo="",CardTypeID=0
	i CardNoID'="" D
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 /// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 /// 卡类型
	s EmRegID=$o(^DOCEMREGi(0,"PAPMI",PatientID,""),-1) 	 /// 登记ID  显示最后一天登记记录
	s EmPCLvID="",EmRegDate="",EmRegTime="",NurseLevel=""
	
	i EmRegID'="" d
	.q:'$d(^DOCEMREG("EM",EmRegID))
	.s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)  /// 分诊ID
	.i EmPCLvID'="" d
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)    /// 护士分级
	.s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记时间
	.s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy $zd(EmRegDate,3)
	.s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	.s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	s IdentID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h) //$zd(+$h,3)
	s ListData=EmRegID_"^"_EmRegDate_"^"_EmRegTime_"^"_PatientID_"^"_PatCardNo_"^"_CardNoID_"^"_PatNo_"^"_PatName_"^"_sexId_"^"_PatSex_"^"_PatDiag
	s ListData=ListData_"^"_PatAge_"^"_nationdr_"^"_countrydr_"^"_birthday_"^"_IdentNo_"^"_PatTelH_"^"_Address_"^"_BillType_"^"_EmPCLvID_"^"_NurseLevel_"^"_CardTypeID
	s ListData=ListData_"^"_PatYBCode_"^"_IdentID_"^"_SpecialPat_"^"_IsDeath
	s ListTitle="EmRegID^EmRegDate^EmRegTime^PatientID^PatCardNo^CardNoID^PatNo^PatName^sexId^PatSex^PatDiag^PatAge^nationdr^countrydr^birthday^IdentNo^PatTelH^Address^BillType^EmPCLvID^NurseLevel^CardTypeID"
	s ListTitle=ListTitle_"^PatYBCode^IdentID^SpecialPat^IsDeath"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

ClassMethod PatIsGroupPat(PatientID)
{
	n (PatientID)
	s Ret=0
	s:$d(^DHCEMGPS(0,"PAPMI",PatientID)) Ret=1
	q Ret
}

/// Descritp:	意识状态
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonPatAWare()
ClassMethod jsonPatAWare(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PA_RowID ,PA_Desc FROM DHC_EmPatAware Where "
	s:+HospID'=0 sqlStr = sqlStr_"  PA_Hosp_Dr='"_HospID_"' And"
	s sqlStr = sqlStr_"  PA_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("PA_RowID")
		s Desc = result.Data("PA_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:	更改分级原因
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonEmUpdLevReson()
ClassMethod jsonEmUpdLevReson(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ULR_RowID ,ULR_Desc FROM DHC_EmUpdLevReson Where "
	s:+HospID'=0 sqlStr = sqlStr_"  ULR_Hosp_Dr='"_HospID_"' And"
	s sqlStr = sqlStr_"  ULR_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("ULR_RowID")
		s Desc = result.Data("ULR_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:	更改分级原因
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonEmDocUpdReson()
ClassMethod jsonEmDocUpdReson(HospID As %String, Type As %String) As %String
{
	n (HospID, Type,%session)
	;s HospID=0 //hxy 2019-12-26 云his公有，不再分医院 //hxy 2020-05-26 注释
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DUR_RowID ,DUR_Desc FROM DHC_EmDocUpdReason Where "
	;s:+HospID'=0 sqlStr = sqlStr_"  DUR_Hosp_Dr='"_HospID_"' And" //hxy 2020-05-26 注释 
	s:Type'="" sqlStr = sqlStr_"  DUR_Type='"_Type_"' And"
	s sqlStr = sqlStr_"  DUR_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("DUR_RowID")
		s Desc = result.Data("DUR_Desc")
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmDocUpdReason",RowId,HospID)'="Y" //hxy 2020-05-26 基础数据-私有
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmDocUpdReason","DURDesc","",Desc)
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descript:	既往史
/// W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatChkHis("")
ClassMethod GetEmPatChkHis(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PH_RowID,PH_Desc FROM DHC_EmPatHistory Where"
	s:+HospID'=0 sqlStr = sqlStr_"  PH_Hosp_Dr='"_HospID_"' And "
	s sqlStr = sqlStr_"  PH_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{
		s PatHisID = result.Data("PH_RowID")
		s PatHisDesc = result.Data("PH_Desc")
		s ListData=PatHisID_"^"_PatHisDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	病人来源
/// W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatSource("")
ClassMethod GetEmPatSource(HospID As %String) As %String
{
	n (LastRowid, HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PS_RowID ,PS_Desc FROM DHC_EmPatSource Where "
	s:+HospID'=0 sqlStr = sqlStr_"  PS_Hosp_Dr='"_HospID_"' And "
	s sqlStr = sqlStr_"  PS_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PatSouID = result.Data("PS_RowID")
		s PatSouDesc = result.Data("PS_Desc")
		s ListData=PatSouID_"^"_PatSouDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	来诊方式
/// W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatAdmWay("")
ClassMethod GetEmPatAdmWay(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PAW_RowID ,PAW_Desc FROM DHC_EmPatAdmWay Where"
	s:+HospID'=0 sqlStr = sqlStr_"  PAW_Hosp_Dr='"_HospID_"'  And"
	s sqlStr = sqlStr_"  PAW_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PatWayID = result.Data("PAW_RowID")
		s PatWayDesc = result.Data("PAW_Desc")
		s ListData=PatWayID_"^"_PatWayDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descritp:分诊科室
/// Creator :Qiaoqingao
/// CreateDate: 2017-01-13
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonGetEmPatLocLy("")	
ClassMethod jsonGetEmPatLocLy(HospID As %String)
{
	
	n (HospID,%session)
	s:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	;s HospID=2
	s count=0
	w "["
	s LocDr=""
	f  s LocDr=$o(^CTLOC(0,"LocType","E",LocDr)) q:LocDr=""  d
	.q:$d(^CTLOC(LocDr))=0
	.s DateFrom=$p(^CTLOC(LocDr),"^",24)
	.s DateTo=$p(^CTLOC(LocDr),"^",25)
	.s hosp=$p(^CTLOC(LocDr),"^",22)
	.q:(DateFrom>+$H)&(DateFrom'="")
	.q:(DateTo<+$H)&(DateTo'="")
	.q:hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s tmp=LocDr_"^"_LocDesc
	.q:LocDesc'["门诊科室"
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Descritp:	分诊科室
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonGetEmPatLoc("2")
ClassMethod jsonGetEmPatLoc(HospID As %String, q) As %String
{
	n (HospID,q,%session)
	s q = $$ALPHAUP^SSUTIL4($g(q))
	s:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc,CTLOC_Hospital_DR as lochosp, "
    s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo,CTLOC_WardSingleSex,CTLOC_AgeFrom,CTLOC_AgeTo FROM CT_LOC "
    s sqlStr = sqlStr_"Where  CTLOC_ROWID IN (SELECT ADMLOC_CTLOC_DR FROM PAC_AdmTypeLocation WHERE ADMLOC_AdmType='E') AND CTLOC_ROWID NOT in (141,142)"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s title="value^text^wardSingleSex^wardSingleSexDesc^ageFrom^ageTo"
	w "["
	While(result.Next())
	{	
		s DateFrom = result.Data("DateFrom")
		Continue:DateFrom>+$H
		s lochosp= result.Data("lochosp")
		s DateTo = result.Data("DateTo")
		i DateTo'="" Continue:DateTo<+$H
		s LocDr = result.Data("LocDr")
		s hosp=$p(^CTLOC(LocDr),"^",22)
		s locPY = $p(^CTLOC(LocDr),"^",43)
		s locPY = $$ALPHAUP^SSUTIL4($g(locPY))  //sufan 2019-02-13
		;Continue:hosp'=HospID //hxy 2020-05-26 注释
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocDr,HospID)'="Y" //hxy 2020-05-26
		s LocActive=$p(^CTLOC(LocDr),"^",14)
		Continue:(LocActive'="")&&(LocActive'="Y")
		s LocDesc = result.Data("LocDesc")
		s locAllDesc = locPY_LocDesc
		Continue:(q'="")&&(locAllDesc'[q)
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s LocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
		s wardSingleSex = result.Data("CTLOC_WardSingleSex")
		s wardSingleSexDesc=$p($g(^CT("SEX",+wardSingleSex)),"^",2)
		s ageFrom = result.Data("CTLOC_AgeFrom")
		s ageTo = result.Data("CTLOC_AgeTo")
		s tmp=LocDr_"^"_LocDesc_"^"_wardSingleSex_"^"_wardSingleSexDesc_"^"_ageFrom_"^"_ageTo
		
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData(title,tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmp)
	}
	w "]"
	q ""
}

/// Descritp:	号别
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonGetEmPatChkCare("67")
ClassMethod jsonGetEmPatChkCare(LocID As %String, HospID As %String) As %String
{
	
	n (LocID, HospID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RES_RowId,RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR='"_LocID_"' And (res_schedulerequired='Yes' or res_schedulerequired='Y')"
    //w sqlStr
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
		Continue:'$d(^RBAS(ResID,0,"DateSTime",+$H))
		Continue:..GetEmScheduleFlag(ResID)'=1
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",Desc)
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
/// w ##Class(web.DHCEMPatCheckLevQuery).GetEmScheduleFlag("3104||75")
ClassMethod GetEmScheduleFlag(ResID As %String) As %String
{
	n (ResID)
	s QuitFlag=0
	s sTime=""
	F  s sTime=$o(^RBAS(ResID,0,"DateSTime",+$H,sTime)) Q:(sTime="")||(QuitFlag=1)  D
	.s AsID=""
	.F  s AsID=$o(^RBAS(ResID,0,"DateSTime",+$H,sTime,AsID)) Q:(AsID="")||(QuitFlag=1)  D
	..Q:sTime>$p($H,",",2)
	..Q:$p(^RBAS(ResID,AsID),"^",5)<$p($H,",",2)
	..s StatusID=$p(^RBAS(ResID,AsID,"DHC"),"^",10)
	..s StopRegFlag=$p(^RBAS(ResID,AsID,"DHC"),"^",30)
	..q:StopRegFlag="Y"	;停止挂号
	..s Status=$p(^DHCRBCASStatus(StatusID),"^",1)
	..Q:(Status="S")||(Status="TR")||(Status="AUD")
	..//过滤未审核 zhouxin 2018-11-09
	..s NeedExa = ##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("SC",ResID_"||"_AsID)
	..s:+NeedExa=0 QuitFlag=1    ///不需审核
	..q:+NeedExa=0 
	..s RequestID=""
	..s IsAllAudit=##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus(ResID_"||"_AsID) ;所有待审批
	..q:(IsAllAudit'="")&&(IsAllAudit["新增")
	..s QuitFlag=1
	..;s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",ResID_"||"_AsID,""),-1)
	..;i RequestID'=""  d
	...;s RQObj=##class(User.DHCRBApptScheduleRequest).%OpenId(RequestID)
	...;s ASRRequestResult=RQObj.ASRRequestResult
	...;q:ASRRequestResult'="A"
	...;s QuitFlag=1
	.
	Q QuitFlag
}

///  Descript:	获取病人分级信息
///  W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatCheckLev("175")
ClassMethod GetEmPatCheckLev(EmPCLvID As %String) As %String
{
	n (EmPCLvID,%session)
	
	s ListTitle="EmRecLevel^NurseLevel^EmUpdLevRe^Area^EmLocID^EmAgainFlag^EmBatchFlag^EmBatchNum^EmPatSource^EmPatAdmWay^EmAware^EmScreenFlag"
	s ListTitle=ListTitle_"^EmHisDrug^EmHisDrugDesc^EmMaterial^EmMaterialDesc^EmCombFlag^EmECGFlag^EmPoisonFlag^EmPainFlag^EmOxygenFlag^EmPatAskFlag"
	s ListTitle=ListTitle_"^EmOtherDesc^EmPatChkHis^EmPatChkSign^EmPainLev^EmPainRange^EmPainTime^EmPatChkCare^EmPainRangeDesc^EmSymDesc^EmPatChkType^EmToLocID^AisDataStr^GCSDataStr^PChkHisOther"
	s ListTitle=ListTitle_"^EmPatGreFlag^EmWardID^EmPatAdm^EmGcsFlag^EmAisFlag^SixSick^EmPatGreHours"
	s ListTitle=ListTitle_"^AisIdStr^FallIdStr^EsiIdStr^RemsIdStr^MewsIdStr^GcsIdStr^AutoScoreStr^PainStr^ListHisArray^PCLNotes"
	s ListTitle=ListTitle_"^CreatDate^CreatTime^XZCSPF^ISS^ChildEarStr^GreReaDr^Vitalsign^FRFA^ChestPain"
	Q:EmPCLvID="" ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,"")

	s CreatDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 来诊日期
	s:CreatDate'="" CreatDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CreatDate)
	s CreatTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 来诊时间 
	s:CreatTime'="" CreatTime=$zt(CreatTime,1)
	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	i +EmUpdLevRe'=0 d
	.s:'$d(^DHCEMDUR(EmUpdLevRe)) EmUpdLevRe=""
	.q:'$d(^DHCEMDUR(EmUpdLevRe))
	.s:$p(^DHCEMDUR(EmUpdLevRe),"^",4)'="Y" EmUpdLevRe="" 
	e  d
	.s EmUpdLevRe=""
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	//s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	
	s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查
	s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	
	s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	
	s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate) //$zd(EmPainDate,3)
	s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	
	s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	s EmPatAskFlag=$p(^DHCEMPCL(EmPCLvID),"^",35) 	/// 请假
	s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	s EmSymDesc=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状
	s EmPatChkType=$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群 2016-09-05 congyue
	s EmToLocID=$p(^DHCEMPCL(EmPCLvID),"^",41) 		/// 转向科室 2016-09-09 congyue
	
	s EmLocID=""									/// 分诊科室 
	s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""))
	i EmPccID'="" s EmLocID=$p(^DHCEMPCC(EmPccID),"^",3) 
	s EmPatChkHis=..GetEmPatChkLvHis(EmPCLvID)		/// 既往史
	s EmPatChkSign=..GetEmPatChkSignItm(EmPCLvID)      /// 生命体征
	s EmPatChkCare=..GetEmPatChkCare(EmPCLvID)      /// 预检号别表
	S AisDataStr = ..GetAisData(EmPCLvID)       	/// 创伤分级
	S GCSDataStr = ..GetGCSData(EmPCLvID)    		/// 格拉斯哥
	S GcsFlag = $p(^DHCEMPCL(EmPCLvID),"^",45)		/// 格拉斯哥标注
	S AisFlag = $p(^DHCEMPCL(EmPCLvID),"^",46)      /// 创伤评分标注
	s PChkHisOther=$p(^DHCEMPCL(EmPCLvID),"^",14) 	/// 其他既往史 yuliping
	s SixSick = ##class(web.DHCEMPatCheckLevQuery).GetSixSick(EmPCLvID)
	
	//zhouxin 2017-03-13
	S AisIdStr = ..GetAisId(EmPCLvID)       	    /// 创伤分级Id
	S FallIdStr = ..GetFallId(EmPCLvID)       	    /// 坠跌分级Id
	S EsiIdStr = ..GetEsiId(EmPCLvID)       	    /// ESI分级Id
	S RemsIdStr = ..GetRemsId(EmPCLvID)       	    /// REMS分级Id
	S MewsIdStr = ..GetMewsId(EmPCLvID)       	    /// MEWS分级Id
	S GcsIdStr = ..GetGcsId(EmPCLvID)       	    /// GCS分级Id
	s AutoScoreStr=..GetAutoScore(EmPCLvID)         /// 自动评分项串
	s PainStr=..GetPainId(EmPCLvID)                 ///疼痛评分串
	s ChildEarStr=..GetChildEarId(EmPCLvID)         ///儿童早期预警评分串
	s XZCSPF =..GetRtsScore(EmPCLvID,"XZCSPF")		/// RTS
	s ISS =..GetRtsScore(EmPCLvID,"ISS")			/// ISS
	s FRFA =..GetRtsScore(EmPCLvID,"FRFA")			/// FRFA
	s ChestPain =..GetRtsScore(EmPCLvID,"ChestPain") /// ChestPain
	
	s EmPatGreFlag=##class(web.DHCEMPatGreenRec).checkGreenRec("",EmPCLvID,"Y")
	;##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(EmPCLvID,"")  /// 绿色通道 2017-02-28 bianshuai
	s EmPatGreHours=##Class(web.DHCEMPatCheckLev).GetEmPatGreenHours(EmPCLvID,"") /// 绿色通道有效时间 2018-07-27 bianshuai
	s EmPatAdm=##Class(web.DHCEMPatCheckLev).GetEmPatCheckLvAdm(EmPCLvID)   	/// 预检就诊ID  2017-02-28 bianshuai
	s EpisodeID=+EmPatAdm
	s EmWardID=$p(^DHCEMPCL(EmPCLvID),"^",47)         /// 病区
	s PCLNotes=$p(^DHCEMPCL(EmPCLvID),"^",56)         /// 备注
	s GreReaDr=""
	s:EmPatGreFlag=1 GreReaDr=##Class(web.DHCEMPatCheckLev).GetEmPatGreenReaDr(EmPCLvID,"")
	s phimId=""
	s pchimId=$o(^DHCEMPCHIM(0,"PatCheckLev",EmPCLvID,""))
	s:pchimId'="" phimId=$p(^DHCEMPCHIM(pchimId),"^",2)
	s Vitalsign=phimId
	s ListHisArray  =""
	s ListData=EmRecLevel_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_Area_"^"_EmLocID_"^"_EmAgainFlag_"^"_EmBatchFlag_"^"_EmBatchNum_"^"_EmPatSource_"^"_EmPatAdmWay_"^"_EmAware_"^"_EmScreenFlag
	s ListData=ListData_"^"_EmHisDrug_"^"_EmHisDrugDesc_"^"_EmMaterial_"^"_EmMaterialDesc_"^"_EmCombFlag_"^"_EmECGFlag_"^"_EmPoisonFlag_"^"_EmPainFlag_"^"_EmOxygenFlag_"^"_EmPatAskFlag
	s ListData=ListData_"^"_EmOtherDesc_"^"_EmPatChkHis_"^"_EmPatChkSign_"^"_EmPainLev_"^"_EmPainRange_"^"_EmPainTime_"^"_EmPatChkCare_"^"_EmPainRangeDesc_"^"_EmSymDesc_"^"_EmPatChkType_"^"_EmToLocID
	s ListData=ListData_"^"_AisDataStr_"^"_GCSDataStr_"^"_PChkHisOther_"^"_EmPatGreFlag_"^"_EmWardID_"^"_EmPatAdm_"^"_GcsFlag_"^"_AisFlag_"^"_SixSick_"^"_EmPatGreHours
	s ListData=ListData_"^"_AisIdStr_"^"_FallIdStr_"^"_EsiIdStr_"^"_RemsIdStr_"^"_MewsIdStr_"^"_GcsIdStr_"^"_AutoScoreStr_"^"_PainStr_"^"_ListHisArray_"^"_PCLNotes
	s ListData=ListData_"^"_CreatDate_"^"_CreatTime_"^"_XZCSPF_"^"_ISS_"^"_ChildEarStr_"^"_GreReaDr_"^"_Vitalsign_"^"_FRFA_"^"_ChestPain
	
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// lvpeng
/// 20200911
/// 获取儿童预警评分串
ClassMethod GetChildEarId(EmPCLvID)
{
	n (EmPCLvID)
	s id=+$o(^User.DHCEmChildEarWarnI("IndexChk",EmPCLvID,""))
	q:id=0 ""
	s data=^User.DHCEmChildEarWarnD(id)
	//q $LISTTOSTRING(data,",",1)
	q $LISTGET(data,3)_"#"_$LISTGET(data,4)_"#"_$LISTGET(data,5)
}

/// Creator:qqa
/// CreatDate:20180319  
/// 
ClassMethod GetSixSick(EmPCLvID)
{
	n (EmPCLvID)
	q:EmPCLvID="" ""
	s Rs=""
	s PCSPRowID=0
	f  s PCSPRowID = $o(^DHCEMPCSP(0,"PatCheckLev",EmPCLvID,PCSPRowID)) q:PCSPRowID=""  d
	.s PCSPSpecDiseDr = $p(^DHCEMPCSP(PCSPRowID),"^",2)
	.s:Rs'="" Rs=Rs_"#"_PCSPSpecDiseDr
	.s:Rs="" Rs=PCSPSpecDiseDr
	q Rs
}

/// Creator:qqa
/// CreatDate:20180319  
/// 
ClassMethod GetSixSickDesc(EmPCLvID)
{
	n (EmPCLvID)
	q:EmPCLvID="" ""
	s Rs=""
	s PCSPRowID=0
	f  s PCSPRowID = $o(^DHCEMPCSP(0,"PatCheckLev",EmPCLvID,PCSPRowID)) q:PCSPRowID=""  d
	.s PCSPSpecDiseDr = $p(^DHCEMPCSP(PCSPRowID),"^",2)
	.s PCSPSpecDise = $p(^DHCEMSPD(PCSPSpecDiseDr),"^",1)
	.s:Rs'="" Rs=Rs_","_PCSPSpecDise
	.s:Rs="" Rs=PCSPSpecDise
	q Rs
}

// 张海龙  2016-10-25  创伤分级

ClassMethod GetAisData(EmPCLvID)
{
	
	S PCAId="",AisDataStr="",AddScore=0,PCAAISIDr=""
	F  S PCAId=$o(^DHCEMPCAI(0,"CHECKLEV",EmPCLvID,PCAId))  Q:PCAId=""  D
	.S PCAAISIDr=$P($G(^DHCEMPCAI(PCAId)),"^",3)
	.Q:PCAAISIDr=""
	.S DHCEMAISDesc=""
	.S DHCEMAISDesc=$p($g(^DHCEMAIS($p(PCAAISIDr,"||",1))),"^",2)
	.Q:DHCEMAISDesc=""
	.S DHCEMAISSubScore=""
	.S DHCEMAISSubScore=$p(^DHCEMAIS($p(PCAAISIDr,"||",1),$p(PCAAISIDr,"||",2)),"^",5)
	.S AisDataStr=AisDataStr_DHCEMAISDesc_":("_DHCEMAISSubScore_"分)"_","
	.S AddScore=AddScore+DHCEMAISSubScore
	i (PCAAISIDr'="") d
	.S AisDataStr="总分:"_AddScore_"(分),"_AisDataStr
	Q AisDataStr
}

// 张海龙  2016-10-25  格拉斯哥

ClassMethod GetGCSData(EmPCLvID)
{
	S PCGId="",dStr=""
    F  S PCGId=$o(^DHCEMPCG(0,"ChkDr",EmPCLvID,PCGId))  Q:PCGId=""  D
    .S PCAGCSIDr=$P($G(^DHCEMPCG(PCGId)),"^",3)
	.Q:PCAGCSIDr=""
	.S DHCEMGCSDesc=""
	.S DHCEMGCSDesc=$p($g(^DHCEMGCS($p(PCAGCSIDr,"||",1))),"^",2)
	.Q:DHCEMGCSDesc=""
	.s DHCEMGCSIDesc=""
	.S DHCEMGCSIDesc=$p(^DHCEMGCS($p(PCAGCSIDr,"||",1),"I",$p(PCAGCSIDr,"||",2)),"^",3)
	.S DHCEMGCSSubScore=""
	.S DHCEMGCSSubScore=$p(^DHCEMGCS($p(PCAGCSIDr,"||",1),"I",$p(PCAGCSIDr,"||",2)),"^",5)
	.S dStr=dStr_DHCEMGCSDesc_":"_DHCEMGCSIDesc_"("_DHCEMGCSSubScore_"分)"_","
	Q dStr
}

/// Descript:	既往史
ClassMethod GetEmPatChkLvHis(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPchID=""
	f  s EmPchID=$o(^DHCEMPCH(0,"PatCheckLev",EmPCLvID,EmPchID)) Q:EmPchID=""  D
	.s EmPatChkHisID=$p(^DHCEMPCH(EmPchID),"^",2)   /// 既往史
	.i ListData="" s ListData=EmPatChkHisID
	.E  s ListData=ListData_"#"_EmPatChkHisID
	q ListData
}

/// Descript:	预检号别表
ClassMethod GetEmPatChkCare(EmPCLvID) As %String
{
	n (EmPCLvID,%session)
	s ListData=""
	s EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.s EmCareProvLocID=$p(^DHCEMPCC(EmPccID),"^",3)   ///
	.q:+EmCareProvID=0 
	.s EmCareProv=$p(^CTPCP(EmCareProvID,1),"^",2)
	.s EmCareProv=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",EmCareProv) //hxy 2022-07-25
	.//s ListData=EmCareProvID
	.i ListData="" s ListData=EmCareProvID_"@"_EmCareProv_"@"_EmCareProvLocID
	.E  s ListData=ListData_"#"_EmCareProvID_"@"_EmCareProv_"@"_EmCareProvLocID
	q ListData
}

/// Descript:	生命体征
ClassMethod GetEmPatChkSign(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPcsID=""
	f  s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID)) Q:EmPcsID=""  D
	.s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	.s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	.s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	.s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	.s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	.s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	.s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	.s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	.s EmPcsBreath=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	.i ListData="" s ListData=EmPcsTime_"@"_EmPcsTemp_"@"_EmPcsHeart_"@"_EmPcsPulse_"@"_EmPcsSBP_"@"_EmPcsDBP_"@"_EmPcsSoP2_"@"_EmPcsBreath
	.E  s ListData=ListData_"#"_EmPcsTime_"@"_EmPcsTemp_"@"_EmPcsHeart_"@"_EmPcsPulse_"@"_EmPcsSBP_"@"_EmPcsDBP_"@"_EmPcsSoP2_"@"_EmPcsBreath
	s:ListData="" ListData="@@@@@@@"
	q ListData
}

/// Descript:	生命体征
ClassMethod GetEmPatChkSignItm(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPcsID=""
	;s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID),-1) //hxy 2020-03-17 st
	s PcsID=""
	f  s PcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,PcsID),-1) q:(PcsID="")!(EmPcsID'="")  d
	.s PcsTime=$p(^DHCEMPCS(PcsID),"^",2)
	.;q:PcsTime'="" //分诊无时间，干预保存有时间,有时间退出
	.s EmPcsID=PcsID //ed
	
	s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	s EmPcsBreath=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	s EmPcsGLU=$p(^DHCEMPCS(EmPcsID),"^",10)   ///血糖
	S ListData=EmPcsTime_"@"_EmPcsTemp_"@"_EmPcsHeart_"@"_EmPcsPulse_"@"_EmPcsSBP_"@"_EmPcsDBP_"@"_EmPcsSoP2_"@"_EmPcsBreath_"@"_EmPcsGLU
	q ListData
}

///  Descript: 症状分级树 
/// w ##class(web.DHCEMPatCheckLevQuery).jsonEmPatSymptomLev()
ClassMethod jsonEmPatSymptomLev(q = "") As %String
{
    
	n (q,%session)
	s count = 0
	w "["
	s ID=0,count=0
  	f  s ID=$o(^User.DHCSymptomLevI("ParIdx","-100000000000000",ID)) q:ID=""  d
  	.q:'$d(^User.DHCSymptomLevD(ID))
  	.s Text=$LISTGET(^User.DHCSymptomLevD(ID),3)
	.q:..CheckSymLevChilden(ID,q)=0
	.s Text = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomLev","SYLDesc","",Text)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.d ..GetSymLevChilden(ID)
	.w "}"
	w "]"
  	q ""
}

///  Descript: 症状分级树孩子节点处理
/// w ##class(web.DHCEMPatCheckLevQuery).GetSymLevChilden("11")
ClassMethod GetSymLevChilden(ParentID As %String, q = "") As %String
{
	n (ParentID,q)
	///  是否存在孩子节点
	s ID=$o(^User.DHCSymptomLevI("ParIdx",ParentID,""))
	Q:ID="" ""
	///  存在孩子节点
	s ID="",count=0
	///  有孩子节点的初始化时收缩
	w ","_##class(web.DHCEMJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	f  s ID=$o(^User.DHCSymptomLevI("ParIdx",ParentID,ID)) q:ID=""  d
	.s Text=$LISTGET(^User.DHCSymptomLevD(ID),3)
	.q:..CheckSymLevChilden(ID,q)=0
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStartSign(ID,Text)
	.d ..GetSymLevChilden(ID)
	.w "}"
	w "]"
	Q ""
}

ClassMethod CheckSymLevChilden(ParentID As %String, q = "") As %String
{
	n (ParentID,q,%session)
	q:q="" 1
	s Text=$LISTGET(^User.DHCSymptomLevD(ParentID),3)
	s Text = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomLev","SYLDesc","",Text)
	q:Text[q 1
	s ID=$o(^User.DHCSymptomLevI("ParIdx",ParentID,""))
	Q:ID="" 0
	///  存在孩子节点
	s ID="",count=0,ret=0
	f  s ID=$o(^User.DHCSymptomLevI("ParIdx",ParentID,ID)) q:(ID="")||(ret'=0)  d
	.s Text=$LISTGET(^User.DHCSymptomLevD(ID),3)
	.s Text = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomLev","SYLDesc","",Text)
	.s:Text[q ret=1
	.s ret=..CheckSymLevChilden(ID,q)
	q ret
}

///  Descript:  症状知识库
/// W ##Class(web.DHCEMPatCheckLevQuery).GetSymptomFeild(2)
ClassMethod GetSymptomFeild(EmSymLevId As %String, EmSymEnter As %String) As %String
{
	n (EmSymLevId,EmSymEnter,%session)
	s count = 0
	s ListTitle="EmSymFId^EmSymFDesc"
	s last=+$LG(^User.DHCSymptomLevD(EmSymLevId),4)
	s parentDesc=$LG(^User.DHCSymptomLevD(EmSymLevId),3)
	s parentDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomLev","SYLDesc","",parentDesc)
	
	i last'=0 d
	.s parentDesc=$LG(^User.DHCSymptomLevD(last),3)_":"_parentDesc
	w "[{"
	w """EmSymFId"":"_EmSymLevId_","
	w """EmSymFDesc"":"""_parentDesc_""""
	w ",""children"":"
	w "["
	s EmSymFId=""
	f  s EmSymFId=$o(^DHCSYMCONi(0,EmSymLevId,EmSymFId)) Q:EmSymFId=""  D
	.s EmSymFDesc=$p(^DHCSYMFEI(EmSymFId),"^",2)
	.Q:$p(^DHCSYMFEI(EmSymFId),"^",3)'="Y"
	.s EmSymFDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomFeild","SYFDesc","",EmSymFDesc)
	.i EmSymFDesc[":" s EmSymFDesc=$p(EmSymFDesc,":",$l(EmSymFDesc,":"))
	.;s EmSymEnter=$$ALPHAUP^SSUTIL4(EmSymEnter) //hxy 2018-06-15 st
  	.s EmSymEnter=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(EmSymEnter))
  	.s TextPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(EmSymFDesc))
  	.i EmSymEnter'="" q:TextPY'=EmSymEnter //hxy ed
  	.
	.s ListData=EmSymFId_"^"_EmSymFDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]}]"
	
	q ""
}

///  Descript:  检查上一次就诊是否3天内(非当天)
///  OutPut:    1-是，0-否
ClassMethod CheckLastVisitTime(PatientID As %String) As %String
{
	n (PatientID)
	s QuitFlag=0,LastFlag=0
	s EmAdmTypeList="E^O"
	s Len=$L(EmAdmTypeList,"^")
	f i=1:1:Len Q:QuitFlag=1  D
	.s EmAdmType=$p(EmAdmTypeList,"^",i)
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(PatientID,"ADM",EmAdmType,EpisodeID),-1) Q:(EpisodeID="")||(QuitFlag=1)||(LastFlag=1)  D
	..s EmAdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	..q:EmAdmDate=+$H
	..s LastFlag=1
	..q:EmAdmDate'>(+$H-3)
	..s QuitFlag=1
	q QuitFlag
}

///  Descript:  是否隐藏病人列表 
///  OutPut:    1-隐藏，0-显示
ClassMethod CheckIfHideEmPatList() As %String
{
	Q 0
}

/// Descript:  获取病人预检分诊信息
/// w ##Class(web.DHCEMPatCheckLevQuery).GetEmPatInfo("13281","")
ClassMethod GetEmPatInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	s LgHospID=%session.Get("LOGON.HOSPID")
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	s PatBoD=""
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i birthday'="" s PatBoD=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	s PatIdNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s PatNation=""
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	s PatCountry=""
	s PatCyID=$p(^PAPER(PatientID,"PER",1),"^",8) 	    /// 国家
	i PatCyID'="" s PatCountry=$p(^CT("COU",PatCyID),"^",2)
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddress=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2)   /// 卡号
	
	s ListData=PatientID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatBoD_"^"_PatIdNo
	s ListData=ListData_"^"_PatNation_"^"_PatCountry_"^"_PatTelH_"^"_PatAddress_"^"_PatCardNo
	
	s ListTitle="PatientID^PatNo^PatName^PatSex^PatAge^PatBoD^PatIdNo^PatNation^PatCountry^PatTelH^PatAddress^PatCardNo"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

///  Descript:	获取病人分级信息
///  W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatCheckLevInfo("13281","")
ClassMethod GetEmPatCheckLevInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" ""
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)          /// 登记ID
	Q:EmRegID="" ""
	s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记时间
	s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)
	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1) /// 分诊ID
	Q:EmPCLvID="" ""
	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s EmRecLevel=$s(EmRecLevel=1:"一级",EmRecLevel=2:"二级",EmRecLevel=3:"三级",EmRecLevel=4:"四级",1:"")
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"一级",NurseLevel=2:"二级",NurseLevel=3:"三级",NurseLevel=4:"四级",1:"")
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	i EmUpdLevRe'="" s EmUpdLevRe=$p(^DHCEMULR(EmUpdLevRe),"^",2)
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	s Area=$s(Area=1:"红区",Area=2:"红区",Area=3:"黄区",Area=4:"绿区",1:"")
	s EmLocDesc=""
	s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	i EmLocID'="" s EmLocDesc=$p(^CTLOC(EmLocID),"^",2)
	
	s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	s EmAgainFlag=$s(EmAgainFlag="Y":"是",EmAgainFlag="N":"否",1:"")
	s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	s EmBatchFlag=$s(EmBatchFlag="Y":"是",EmBatchFlag="N":"否",1:"")
	s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	i EmPatSource'="" s EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2)
	s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	i EmPatAdmWay'="" s EmPatAdmWay=$p(^DHCEMPADW(EmPatAdmWay),"^",2)
	
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	i EmAware'="" s EmAware=$p(^DHCEMPAW(EmAware),"^",2)
	s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查
	s EmScreenFlag=$s(EmScreenFlag="1":"发热",EmScreenFlag="2":"肠道",1:"")
	s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	i EmHisDrug="N" s EmHisDrugDesc="无"
	s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	
	s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	i EmMaterial="N" s EmMaterialDesc="无"
	s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	s EmCombFlag=$s(EmCombFlag="Y":"是",EmCombFlag="N":"否",1:"")
	s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	s EmECGFlag=$s(EmECGFlag="Y":"是",EmECGFlag="N":"否",1:"")
	s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	s EmPoisonFlag=$s(EmPoisonFlag="Y":"是",EmPoisonFlag="N":"否",1:"")
	s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	
	s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate) //$zd(EmPainDate,3)
	s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	s EmPainLev="疼痛指数："_EmPainLev_"、疼痛范围："_EmPainRangeDesc_"、疼痛时间："_EmPainTime
	i EmPainFlag="N" s EmPainLev="无"
	
	s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	s EmOxygenFlag=$s(EmOxygenFlag="Y":"是",EmOxygenFlag="N":"否",1:"")
	s EmPatAskFlag=$p(^DHCEMPCL(EmPCLvID),"^",35) 	/// 请假
	s EmPatAskFlag=$s(EmPatAskFlag="Y":"是",EmPatAskFlag="N":"否",1:"")
	s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	s EmSymDesc=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状
	s EmSymDesc=..GetEmSymDesc(EmSymDesc)		    /// 症状
	
	s EmPatChkHis=..GetEmPatChkLvHisDesc(EmPCLvID)		/// 既往史
	s EmPatChkSign=..GetEmPatChkSignDesc(EmPCLvID)      /// 生命体征
	s EmPatChkCare=..GetEmPatChkCareDesc(EmPCLvID)      /// 预检号别表
	
	s ListData=EmRegDate_"^"_EmRecLevel_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_Area_"^"_EmLocDesc_"^"_EmAgainFlag_"^"_EmBatchFlag_"^"_EmBatchNum_"^"_EmPatSource_"^"_EmPatAdmWay_"^"_EmAware_"^"_EmScreenFlag
	s ListData=ListData_"^"_EmHisDrug_"^"_EmHisDrugDesc_"^"_EmMaterial_"^"_EmMaterialDesc_"^"_EmCombFlag_"^"_EmECGFlag_"^"_EmPoisonFlag_"^"_EmPainFlag_"^"_EmOxygenFlag_"^"_EmPatAskFlag
	s ListData=ListData_"^"_EmOtherDesc_"^"_EmPatChkHis_"^"_EmPatChkSign_"^"_EmPainLev_"^"_EmPatChkCare_"^"_EmPainRangeDesc_"^"_EmSymDesc
	
	s ListTitle="EmRegDate^EmRecLevel^NurseLevel^EmUpdLevRe^Area^EmLocDesc^EmAgainFlag^EmBatchFlag^EmBatchNum^EmPatSource^EmPatAdmWay^EmAware^EmScreenFlag"
	s ListTitle=ListTitle_"^EmHisDrug^EmHisDrugDesc^EmMaterial^EmMaterialDesc^EmCombFlag^EmECGFlag^EmPoisonFlag^EmPainFlag^EmOxygenFlag^EmPatAskFlag"
	s ListTitle=ListTitle_"^EmOtherDesc^EmPatChkHis^EmPatChkSign^EmPainLev^EmPatChkCare^EmPainRangeDesc^EmSymDesc"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:	预检号别表
ClassMethod GetEmPatChkCareDesc(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s EmCareProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	.s CareLocID = $p(^DHCEMPCC(EmPccID),"^",3)
	.s CareLoc = $p(^CTLOC(CareLocID),"^",2)
	.s EmCareProv=$p(^CTPCP(EmCareProvID,1),"^",2)
	.s:CareLoc'="" EmCareProv=CareLoc_"("_EmCareProv_")"
	.i ListData="" s ListData=EmCareProv
	.E  s ListData=ListData_"、"_EmCareProv
	q ListData
}

/// Descript:	既往史
/// w ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(109)
ClassMethod GetEmPatChkLvHisDesc(EmPCLvID) As %String
{
	n (EmPCLvID,%session)
	s ListData=""
	s EmPchID=""
	f  s EmPchID=$o(^DHCEMPCH(0,"PatCheckLev",EmPCLvID,EmPchID)) Q:EmPchID=""  D
	.s EmPatChkHisID=$p($g(^DHCEMPCH(EmPchID)),"^",2)   /// 既往史
	.Q:EmPatChkHisID="" 
	.s EmPatChkHisDesc=$p($g(^DHCEMPHI(EmPatChkHisID)),"^",2)   //QQA 加上了一个$g,防止undefined
	.s EmPatChkHisDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatHistory","PHDesc","",EmPatChkHisDesc)
	.i ListData="" s ListData=EmPatChkHisDesc
	.E  s ListData=ListData_"、"_EmPatChkHisDesc
	q ListData
}

/// Descript:	生命体征
ClassMethod GetEmPatChkSignDesc(EmPCLvID) As %String
{
	n (EmPCLvID)
	s ListData=""
	s EmPcsID=""
	f  s EmPcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,EmPcsID)) Q:EmPcsID=""  D
	.s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	.s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	.s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	.s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	.s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	.s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	.s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	.s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	.i ListData="" s ListData="1、时间："_EmPcsTime_","_" 体温："_EmPcsTemp_"℃,"_" HR："_EmPcsHeart_"(次/分) R: "_EmPcsPulse_"(次/分) BP："_EmPcsSBP_"-"_EmPcsDBP_"(mmHg), SOP2: "_EmPcsSoP2_"(%) "
	.E  s ListData=ListData_"；"_"2、时间："_EmPcsTime_","_" 体温："_EmPcsTemp_"℃,"_" HR："_EmPcsHeart_"(次/分) R: "_EmPcsPulse_"(次/分) BP："_EmPcsSBP_"-"_EmPcsDBP_"(mmHg), SOP2: "_EmPcsSoP2_"(%) "
	q ListData
}

/// Descript: 处理症状
ClassMethod GetEmSymDesc(EmSymStrDesc As %String) As %String
{
	n (EmSymStrDesc)
	s EmSymDesc=""
	f i=1:1:$L(EmSymStrDesc,"#")  d
	.s EmSymSingDesc=$p(EmSymStrDesc,"#",i)
	.i EmSymDesc="" s EmSymDesc=$p(EmSymSingDesc,"!",2)
	.E  s EmSymDesc=EmSymDesc_","_$p(EmSymSingDesc,"!",2)
	Q EmSymDesc
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlistT",pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlistNew",pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist",pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmRegPatlist","RegLoc",pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueAndEmg",pid)
	k ^TMP("DHCST","web.DHCEMPatCheckLevQuery","QueryEmPatByQueEmgTotal",pid)
}

///  Descript:	获取病人预检号别信息
///  W ##Class(web.DHCEMPatCheckLevQuery).getPatChkCare("0000000001")
///  input:登记号
///  output:CTCareProv id
ClassMethod getPatChkCare(RegNo)
{
	 n (RegNo)
	 s ret=""
	 q:RegNo="" ret
	 s PatientID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
	 q:+PatientID=0 ret
	 
	 s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)
	 q:+EmRegID=0 ret
	 s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)  /// 分诊ID
	 q:+EmPCLvID=0 ret
	 s EmPccID="",i=1
	 f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	 .s $p(ret,"^",i)=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	 .s i=i+1
	 q ret
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-16
/// Descript:	预检分诊配置类型
/// InPut:      AppCode-预检分诊参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     预检分诊参数类型值
ClassMethod GetEmSysConfig(AppCode As %String, Params As %String) As %String
{
	n (AppCode, Params)
	s LgHospID=$p(Params,"^",1)	  /// 医院ID
	s LgCtLocID=$p(Params,"^",2)  /// 科室ID
	s LgUserID=$p(Params,"^",3)   /// 用户ID
	s LgGroupID=$p(Params,"^",4)  /// 安全组ID
	s ResType=##Class(web.DHCAppComPar).GetAppPropValue("DHCEMCHK",AppCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Description: 查询特殊人群字典
/// Creator:     congyue
/// CreateDate:  2016-09-05
/// Table:       DHC_EmPatType
/// Input:  	
/// Output:   	 特殊人群信息
/// Others:		 W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatChkType()
ClassMethod GetEmPatChkType() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PT_RowID,PT_Desc FROM DHC_EmPatType "
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{
		s PatTypeID = result.Data("PT_RowID")
		s PatTypeDesc = result.Data("PT_Desc")
		s ListData=PatTypeID_"^"_PatTypeDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Description: 获取病人分级
/// Creator:     congyue
/// CreateDate:  2016-09-06
/// Table:       DHC_EmPatCheckLev
/// Input:  	 PatientID:病人id ^ EpisodeID:就诊id
/// Output:   	 ListData:推荐分级^护士分级
/// Others:		 d ##Class(web.DHCEMPatCheckLevQuery).QueryEmPatCheckLev("2","")
ClassMethod QueryEmPatCheckLev(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" ""
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)          /// 登记ID
	Q:EmRegID="" ""
	s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记时间
	s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)
	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1) /// 分诊ID
	Q:EmPCLvID="" ""
	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s EmRecLevel=$s(EmRecLevel=1:"一级",EmRecLevel=2:"二级",EmRecLevel=3:"三级",EmRecLevel=4:"四级",1:"")
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"一级",NurseLevel=2:"二级",NurseLevel=3:"三级",NurseLevel=4:"四级",1:"")
	s ListData=EmRecLevel_"^"_NurseLevel
	q ListData
}

/// Description: 获取分级打印信息
/// Creator:     congyue
/// CreateDate:  2016-09-08
/// Table:       DHC_EmPatCheckLev
/// Input:  	 PatientID:病人id ^ EpisodeID:就诊id
/// Output:   	 ListData:推荐分级^护士分级
/// Others:		 w ##Class(web.DHCEMPatCheckLevQuery).GetEmPatCheLevPriInfo("1346","2")
ClassMethod GetEmPatCheLevPriInfo(EmPCLvID As %String, hospDr As %String, queDoc As %String = "", PATTYPE As %String) As %String
{
	n (EmPCLvID,hospDr,queDoc,PATTYPE,%session)
	Q:EmPCLvID="" ""  
	Q:'$d(^DHCEMPCL(EmPCLvID)) ""
	s PatCardNo="",hospName="",PatientID=""
	s hospName = $p($g(^CT("HOSP",hospDr)),"^",2)   //QQA  2016-10-21
	s PatientID = $p(^DHCEMPCL(EmPCLvID),"^",1)    ///
	q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1) 
	s:+CardNoID'=0 PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2)   /// 卡号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(EmPCLvID)   ///年龄
	s CreateDate=$p(^DHCEMPCL(EmPCLvID),"^",4)  /// 分诊时间 2016-09-19
	s:CreateDate'="" CreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	s CreateTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 分诊时间 2016-09-19
	s:CreateTime'="" CreateTime=$zt(CreateTime,1)

	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",1:"")
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",1:"")
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	//i (EmUpdLevRe'="")&&($d(^DHCEMULR(EmUpdLevRe))) s EmUpdLevRe=$p(^DHCEMULR(EmUpdLevRe),"^",2)
	i (+EmUpdLevRe'=0)&&($d(^DHCEMDUR(EmUpdLevRe))) s EmUpdLevRe=$p(^DHCEMDUR(EmUpdLevRe),"^",2)
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	s Area=$s(Area=1:"红区",Area=2:"红区",Area=3:"黄区",Area=4:"绿区",1:"")
	s EmLocDesc="",EmToLocDesc=""
	//s EmLocID=+$p(^DHCEMPCL(EmPCLvID),"^",10) /// 分诊科室
	s EmLocID=""
	s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""),-1) 
	i EmPccID'=""  D
	.s EmLocID=+$p(^DHCEMPCC(EmPccID),"^",3)    /// 分诊科室
	s DontNo=""
	s:EmLocID'="" DontNo=##Class(web.DHCEMRegister).GetPatCare(EmPCLvID)  
	i +EmLocID'=0 d
	.s EmLocDesc=$p(^CTLOC(EmLocID),"^",2)
	.s:$f(EmLocDesc,"-")>0 EmLocDesc=$p(EmLocDesc,"-",2)
	s EmToLocID=+$p(^DHCEMPCL(EmPCLvID),"^",41) 	/// 转向科室 2016-09-22
	i EmToLocID'=0 d 
	.s EmToLocDesc=$p(^CTLOC(EmToLocID),"^",2)
	.s:$f(EmToLocDesc,"-")>0 EmToLocDesc=$p(EmToLocDesc,"-",2)
	.s EmLocDesc=EmToLocDesc
	//s:EmLocDesc="" EmLocDesc=$g(EmToLocDesc)
	s EmPatChkSign=..GetEmPatChkSignItm(EmPCLvID)      /// 生命体征
	s EmCreatorDr=$p(^DHCEMPCL(EmPCLvID),"^",3)     /// 操作人员
	s EmCreator=""
	s:EmCreatorDr'="" EmCreator=$p(^SSU("SSUSR",EmCreatorDr),"^",2)
	s PrintDate=+$H  //打印日期
	s:PrintDate'="" PrintDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PrintDate) //$zd(PrintDate,3)
	s PrintTime=$p($H,",",2)   	   ///  打印时间
	s:PrintTime'="" PrintTime=$zt(PrintTime,1)
	s EmAware=+$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态 2016-09-19
	i EmAware'=0 s EmAware=$p(^DHCEMPAW(EmAware),"^",2)
	s:EmAware=0 EmAware=""
	s EmRegDate=""
	s EmRegTime=""
	s EmLocDesc = ##class(web.DHCEMRegister).GetPCLCareLoc(EmPCLvID)  //分诊科室
	s ListData = ""
	s:queDoc'="" DontNo=queDoc
	
	s AdmID=""
	s PCAID = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""))
	s:PCAID'="" AdmID = $p(^DHCEMPCA(PCAID),"^",2)
	b ;err
	s LocSeqNo=""
	i AdmID'="" d
	.&SQL(SELECT ID into :RegId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:AdmID)
	.i RegId'="" d
	..s LocSeqNo=$List(^User.DHCRegistrationFeeD(RegId),8)
	
	s EmPatGreFlag=##class(web.DHCEMPatGreenRec).checkGreenRec("",EmPCLvID) //hxy 2022-06-22
	s:EmPatGreFlag=1 EmPatGreFlag="【绿通】"
	s:EmPatGreFlag="0" EmPatGreFlag=""

	s ListData=PatientID_"^"_PatNo_"^"_PatCardNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_EmRecLevel
	s ListData=ListData_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_EmLocDesc_"^"_EmPatChkSign_"^"_EmRegDate
	s ListData=ListData_"^"_EmCreator_"^"_PrintDate_"^"_PrintTime_"^"_EmRegTime_"^"_CreateDate
	s ListData=ListData_"^"_CreateTime_"^"_EmAware_"^"_hospName_"^"_DontNo
	s ListData=ListData_"^^"_LocSeqNo_"^"_EmPatGreFlag
	q ListData
}

/// Description: 获取分级打印信息(停用)
/// Creator:     congyue
/// CreateDate:  2016-09-08
/// Table:       DHC_EmPatCheckLev
/// Input:  	 PatientID:病人id ^ EpisodeID:就诊id
/// Output:   	 ListData:推荐分级^护士分级
/// Others:		 w ##Class(web.DHCEMPatCheckLevQuery).GetEmPatCheLevPriInfo("201","2")
ClassMethod GetEmPatCheLevPriInfoTy(PatientID As %String, hospDr As %String) As %String
{
	n (PatientID,hospDr)
	Q:PatientID="" ""   
	s PatCardNo="",hospName=""
	s hospName = $p($g(^CT("HOSP",hospDr)),"^",2)   //QQA  2016-10-21
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1) 
	s:+CardNoID'=0 PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2)   /// 卡号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",hospDr)  /// 年龄
	;s EmAdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	;s:EmAdmDate'="" EmAdmDate=$zd(EmAdmDate,3)
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)          /// 登记ID
	Q:EmRegID<=0 ""
	s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记时间
	s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //$zd(EmRegDate,3)
	s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间 2016-09-19  时间修改  重点
	s:EmRegTime'="" EmRegTime=$zt(EmRegTime,1)

	s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1) /// 分诊ID
	Q:EmPCLvID="" ""
	
	s CreateDate=$p(^DHCEMPCL(EmPCLvID),"^",4)  /// 分诊时间 2016-09-19
	s:CreateDate'="" CreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	s CreateTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 分诊时间 2016-09-19
	s:CreateTime'="" CreateTime=$zt(CreateTime,1)

	s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",1:"")
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",1:"")
	s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	i EmUpdLevRe'="" s EmUpdLevRe=$p(^DHCEMULR(EmUpdLevRe),"^",2)
	s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	s Area=$s(Area=1:"红区",Area=2:"红区",Area=3:"黄区",Area=4:"绿区",1:"")
	s EmLocDesc="",EmToLocDesc=""
	s EmLocID=+$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	s DontNo=""
	s:EmLocID'="" DontNo=..GetEmPatChkCare(EmPCLvID)  
	b ;err
	s:DontNo'="" DontNo= $p($g(^CTPCP($p(DontNo,"@",1),1)),"^",2)
	i EmLocID'=0 d
	.s EmLocDesc=$p(^CTLOC(EmLocID),"^",2)
	.s:$f(EmLocDesc,"-")>0 EmLocDesc=$p(EmLocDesc,"-",2)
	s EmToLocID=+$p(^DHCEMPCL(EmPCLvID),"^",41) 	/// 转向科室 2016-09-22
	i EmToLocID'=0 d 
	.s EmToLocDesc=$p(^CTLOC(EmToLocID),"^",2)
	.s:$f(EmToLocDesc,"-")>0 EmToLocDesc=$p(EmToLocDesc,"-",2)
	.s EmLocDesc=EmToLocDesc
	//s:EmLocDesc="" EmLocDesc=$g(EmToLocDesc)
	s EmPatChkSign=..GetEmPatChkSignItm(EmPCLvID)      /// 生命体征
	s EmCreatorDr=$p(^DHCEMPCL(EmPCLvID),"^",3)     /// 操作人员
	s EmCreator=""
	s:EmCreatorDr'="" EmCreator=$p(^SSU("SSUSR",EmCreatorDr),"^",2)
	s PrintDate=+$H  //打印日期
	s:PrintDate'="" PrintDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PrintDate) //$zd(PrintDate,3)
	s PrintTime=$p($H,",",2)   	   ///  打印时间
	s:PrintTime'="" PrintTime=$zt(PrintTime,1)
	s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态 2016-09-19
	i EmAware'="" s EmAware=$p(^DHCEMPAW(EmAware),"^",2)
	s ListData=PatientID_"^"_PatNo_"^"_PatCardNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_EmRecLevel_"^"_NurseLevel_"^"_EmUpdLevRe_"^"_EmLocDesc_"^"_EmPatChkSign_"^"_EmRegDate_"^"_EmCreator_"^"_PrintDate_"^"_PrintTime_"^"_EmRegTime_"^"_CreateDate_"^"_CreateTime_"^"_EmAware_"^"_hospName_"^"_DontNo
	
	q ListData
}

/// Creator:     zhanghailong
/// CreateDate:  2016-10-14
/// Table:       DHC_EmPatChkAIS
/// Input:  	预检病人ID^评分主表ID和评分字表ID
/// Output:   	
/// W ##Class(web.DHCEMPatCheckLevQuery).saveEmPatChkAIS(1,"35||8#36||5#37||1#38||1#39||1#")
ClassMethod saveEmPatChkAIS(EmPCLvID As %String, strAIS As %String) As %String
{
	n (EmPCLvID, strAIS)
	s qflag=0
	s Len=$L(strAIS,"#")-1
	for i=1:1:Len q:qflag'="0"  d
	.s a = ##Class(User.DHCEmPatChkAIS).%New()
  	.s AISChlidSub=$p(strAIS,"#",i)
  	.s AISParRefDr=$p(AISChlidSub,"||",1)
  	.s a.PCAAISIDr=##class(User.DHCEmAISItem).%OpenId(AISChlidSub,0)
  	.s a.PCAAISDr =##class(User.DHCEmAIS).%OpenId(AISParRefDr,0)
  	.s a.PCAChkDr = ##class(User.DHCEmPatCheckLev).%OpenId(EmPCLvID,0)
	.s sc=a.%Save()
	.i $$$ISERR(sc) s qflag="201"
	q qflag
}

/// Creator:     zhanghailong
/// CreateDate:  2016-10-31
/// Table:       DHC_EmPatChkAIS
/// Input:  	预检病人ID^评分主表ID和评分字表ID
/// Output:   	
/// W ##Class(web.DHCEMPatCheckLevQuery).saveEmPatChkAISBySql(1,"35||8#36||5#37||1#38||1#39||1#")
ClassMethod saveEmPatChkAISBySql(EmPCLvID As %String, strAIS As %String = "") As %String
{
	n (EmPCLvID,EmListData, strAIS)
	q:EmPCLvID="" 0
	s rs=0
	d ##class(web.DHCEMPatCheckLevQuery).clearAis(EmPCLvID)  //清除表中数据
	q:strAIS="" "0"
	for i=1:1:$l(strAIS,"#")-1 d
	.s rs=""
	.s AisiId = $p(strAIS,"#",i)
	.s AisId = $p(AisiId,"||",1)
	.q:AisId=""
	.s count =""
	.&sql(select count(*) from DHC_EmPatChkAIS where PCA_Chk_Dr=:EmPCLvID and PCA_AIS_Dr=:AisiId )
	.i (count>0)  d
	.. &sql(update DHC_EmPatChkAIS set PCA_AISI_Dr =:AisiId where PCA_Chk_Dr=:EmPCLvID and PCA_AIS_Dr=:AisiId )
	..s rs=SQLCODE
	.e  d 
	..&sql(insert into DHC_EmPatChkAIS values(:EmPCLvID,:AisId,:AisiId))
	..s rs=SQLCODE
	Q rs
}

/// Descript:  病人是否有挂号记录
ClassMethod HasAdmRecord(PatientID As %String) As %String
{
	n (PatientID)
	s quitflag=0
	s Type=""
	F  s Type=$o(^PAPERdr(PatientID,"ADM",Type)) Q:(Type="")||(quitflag=1)  D
	.s AdmID=""
	.F  s AdmID=$o(^PAPERdr(PatientID,"ADM",Type,AdmID))  Q:(AdmID="")||(quitflag=1)  D
	..s AdmDate=$p(^PAADM(AdmID),"^",6)
	..s AdmTime=$p(^PAADM(AdmID),"^",7)
	..Q:+$H>(AdmDate+1)
	..Q:(+$H=(AdmDate+1))&(AdmTime<$p($H,",",2))
	..s quitflag=1
	Q quitflag
}

/// W ##Class(web.DHCEMPatCheckLevQuery).clearGcs(166)
ClassMethod clearGcs(EmPCLvID) As %String
{
	n (EmPCLvID)
	q:EmPCLvID=""
	S GcsId=""
	F  S GcsId = $o(^DHCEMPCG(0,"ChkDr",EmPCLvID,GcsId)) Q:GcsId=""  D
	.S $p(^DHCEMPCG(GcsId),"^",3)=""
	Q ""
}

ClassMethod clearAis(EmPCLvID) As %String
{
	n (EmPCLvID)
	q:EmPCLvID=""
	S AisId=""
	F  S AisId = $o(^DHCEMPCAI(0,"CHECKLEV",EmPCLvID,AisId)) Q:AisId=""  D
	.S $p(^DHCEMPCAI(AisId),"^",3)=""
	Q ""
}

/// Description: 指向科室
/// Creator:     congyue 
/// CreateDate:  2016-09-12
/// Table: 		 CT_LOC
/// Output:  	 科室描述（下拉框显示）  
/// Others:		 w ##class(web.DHCEMPatCheckLevQuery).GetEmToLoc()
ClassMethod GetEmToLoc(HospID As %String, q As %String = "") As %String
{
	n (HospID,q,%session)
	s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc,CTLOC_ContactName as ContactName, "
	s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo,CTLOC_WardSingleSex,CTLOC_AgeFrom,CTLOC_AgeTo "
	s sqlStr = sqlStr_"FROM CT_LOC Where CTLOC_Dep_DR = '1'"

    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s title="value^text^wardSingleSex^ageFrom^ageTo"
	w "["
	While(result.Next())
	{	
		s DateFrom = result.Data("DateFrom")
		Continue:DateFrom>+$H
		s DateTo = result.Data("DateTo")
		i DateTo'="" Continue:DateTo<+$H
		s LocDr = result.Data("LocDr")
		;Continue:$p(^CTLOC(LocDr),"^",22)'=HospID //hxy 2020-05-26 注释
		Continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocDr,HospID)'="Y" //hxy 2020-05-26
		s LocDesc = result.Data("LocDesc")
		s ContactName = result.Data("ContactName")
		s ContactName =$SYSTEM.Util.Collation(ContactName,5)
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s:q'="" q=$SYSTEM.Util.Collation(q,5)
		s compare=LocDesc
		s:($a(q)>=65)&&($a(q)<=90) compare=ContactName
		Continue:(q'="")&&(compare'[q)
		s LocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
		
		s wardSingleSex = result.Data("CTLOC_WardSingleSex")
		s ageFrom = result.Data("CTLOC_AgeFrom")
		s ageTo = result.Data("CTLOC_AgeTo")
		
		s tmp=LocDr_"^"_LocDesc_"^"_wardSingleSex_"^"_ageFrom_"^"_ageTo
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData(title,tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmp)
	}
	w "]"
	q ""
}

/// Descritp:	更改分级原因
/// W ##Class(web.DHCEMPatCheckLevQuery).jsonEmUpdLevResons("2")
ClassMethod jsonEmUpdLevResons(HospID As %String) As %String
{
	n (HospID)
	
	s count=0
	w "["
	s phId=""
	f  s phId=$o(^DHCEMULR(phId)) q:phId=""  d
	.q:phId=0
	.s code=$p(^DHCEMULR(phId),"^",1)
	.s desc=$p(^DHCEMULR(phId),"^",2)
	.s ULRActiveFlag=$p(^DHCEMULR(phId),"^",3)
	.s ULRHospDr=$p(^DHCEMULR(phId),"^",4)
	.q:(ULRHospDr'=HospID)
	.q:(ULRActiveFlag'="Y")
	.s tmp=phId_"^"_desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descript: 取患者年龄
/// w ##Class(web.DHCEMPatCheckLevQuery).GetPatientAgeDesc("2019-07-04")
ClassMethod GetPatientAgeDesc(PatientDOB As %String) As %String
{
	n (PatientDOB)
	Q:PatientDOB="" ""
	i PatientDOB'="" s PatientDOB=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PatientDOB) ;$zdh(PatientDOB,3)
	q:+$H<PatientDOB "-1"
	q:+$H=PatientDOB "0天"
	s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

/// Descript: 格式化年龄
ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	n (AgeYear , AgeMonth , AgeDay)
	s AgeDesc=""
	i AgeYear>14 s AgeDesc=AgeYear_"岁"
	e  d
	.i AgeYear'=0 s AgeYear=AgeYear_"岁"
	.e  s AgeYear=""
	.i AgeMonth'=0 s AgeMonth=AgeMonth_"月"
	.e  s AgeMonth=""
	.i AgeDay'=0 s AgeDay=AgeDay_"天"
	.e  s AgeDay=""
	.i AgeYear'="" s AgeDesc=AgeYear
	.i AgeMonth'="" s AgeDesc=AgeDesc_AgeMonth
	.i (AgeDay'="")&(AgeYear="") s AgeDesc=AgeDesc_AgeDay
	Q AgeDesc
}

/// Descript: 入院病区下拉列表
/// W ##class(web.DHCEMPatCheckLevQuery).jsonWard(2)	
ClassMethod jsonWard(HospID As %String) As %String
{
	n (HospID,%session)
	s count = 0
	w "["
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
	.Q:$p(^CTLOC(LocID),"^",14)'="Y"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .;Q:$p(^CTLOC(LocID),"^",22)'=HospID //hxy 2020-05-26 注释
    .Q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y" //hxy 2020-05-26
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
 	.s HasBed=$o(^PAWARD(WardID,"BED",0))		///是否有床位
 	.q:'+HasBed
	.s HasRoom=$o(^PAWARD(WardID,"ROOM",0))		///是否有房间
 	.q:'+HasRoom
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s WardDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PACWard","WARDDesc","",WardDesc)
	.s tmp=WardID_"^"_WardDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)

	w "]"
	q ""
}

/// Descript: 取病人可用卡表ID
/// w ##Class(web.DHCEMPatCheckLevQuery).GetPatCardNoID("359")
ClassMethod GetPatCardNoID(PatientID As %String) As %String
{
	n (PatientID)
	Q:PatientID="" ""
	s CardNoID=""
 	s ID="0"
	f  s ID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,ID))  Q:(ID="")||(CardNoID'="")  D
 	.s ActiveFlag=$p(^DHCCARD("CF",ID),"^",10)
 	.Q:ActiveFlag'="N" //不要觉得我不对，我就是正常
 	.s CardNoID=ID
 	.
 	Q CardNoID
}

/// Descript:	六大病种
/// W ##Class(web.DHCEMPatCheckLevQuery).GetEmPatChkSpec("")
ClassMethod GetEmPatChkSpec(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SDI_RowID ,SDI_Desc FROM DHC_EmSpecDise Where"
	s:+HospID'=0 sqlStr = sqlStr_"  SDI_Hosp_Dr='"_HospID_"'  And"
	s sqlStr = sqlStr_"  SDI_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PatSpecID = result.Data("SDI_RowID")
		s PatSpecDesc = result.Data("SDI_Desc")
		s ListData=PatSpecID_"^"_PatSpecDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// zhouxin
/// zhouxin
/// 获取创伤id串
ClassMethod GetAisId(EmPCLvID)
{
	n (EmPCLvID)
	S PCAId="",Ret="",i=1
	F  S PCAId=$o(^DHCEMPCAI(0,"CHECKLEV",EmPCLvID,PCAId))  Q:PCAId=""  D
	.S id=$P($G(^DHCEMPCAI(PCAId)),"^",3)
	.Q:id=""
	.S $p(Ret,"#",i)=id
	.s i=i+1
	Q Ret
}

/// zhouxin
/// 获取坠跌id串
ClassMethod GetFallId(EmPCLvID)
{
	n (EmPCLvID)
	S PCFId="",Ret="",i=1
	F  S PCFId=$o(^DHCEMPCF(0,"CHECKLEV",EmPCLvID,PCFId))  Q:PCFId=""  D
	.S id=$P($G(^DHCEMPCF(PCFId)),"^",3)
	.Q:id=""
	.S $p(Ret,"#",i)=id
	.s i=i+1
	Q Ret
}

/// zhouxin
/// 获取esiid串
ClassMethod GetEsiId(EmPCLvID)
{
	n (EmPCLvID)
	s id=+$o(^User.DHCEmPatChkESII("IndexChk",EmPCLvID,""))
	q:id=0 ""
	s data=^User.DHCEmPatChkESID(id)
	q $LISTGET(data,3)_"#"_$LISTGET(data,4)_"#"_$LISTGET(data,5)_"#"_$LISTGET(data,6)_"#"_$LISTGET(data,7)_"#"_$LISTGET(data,9)
}

/// zhouxin
/// 获取Remsid串
ClassMethod GetRemsId(EmPCLvID)
{
	n (EmPCLvID)
	s id=+$o(^User.DHCEmPatChkREMSI("IndexChk",EmPCLvID,""))
	q:id=0 ""
	s data=^User.DHCEmPatChkREMSD(id)
	//q $LISTTOSTRING(data,",",1)
	q $LISTGET(data,6)_"#"_$LISTGET(data,7)_"#"_$LISTGET(data,8)_"#"_$LISTGET(data,9)_"#"_$LISTGET(data,10)_"#"_$LISTGET(data,12)
}

/// zhouxin
/// 获取Mewsid串
ClassMethod GetMewsId(EmPCLvID)
{
	n (EmPCLvID)
    s id=+$o(^User.DHCEmPatChkMEWSI("IndexChk",EmPCLvID,""))
	q:id=0 ""
	s data=^User.DHCEmPatChkMEWSD(id)
	//q $LISTTOSTRING(data,",",1)
	q $LISTGET(data,3)_"#"_$LISTGET(data,4)_"#"_$LISTGET(data,5)_"#"_$LISTGET(data,6)_"#"_$LISTGET(data,7)_"#"_$LISTGET(data,9)
}

/// zhouxin
/// 获取pain串
ClassMethod GetPainId(EmPCLvID)
{
	n (EmPCLvID)
   	s pcpRowId=+$o(^DHCEMPCP(0,"PatCheckLev",EmPCLvID,""))
   	q:pcpRowId=0 ""

	s EmPcpTime=$p(^DHCEMPCP(pcpRowId),"^",4)
	s EmPcpNature=$p(^DHCEMPCP(pcpRowId),"^",2)
	s EmPcpScore=$p(^DHCEMPCP(pcpRowId),"^",3)
	s EmMethod=$p(^DHCEMPCP(pcpRowId),"^",5)
	s painActive=$p(^DHCEMPCP(pcpRowId),"^",6)
	s painPos=$p(^DHCEMPCP(pcpRowId),"^",7)
	q EmPcpScore_"#"_painPos_"#"_EmPcpTime_"#"_EmPcpNature_"#"_EmMethod_"#"_painActive
}

/// w ##class(web.DHCEMPatCheckLevQuery).GetRtsScore("176","XZCSPF")
ClassMethod GetRtsScore(EmPCLvID, ScoreScaleCode)
{
	n (EmPCLvID,ScoreScaleCode)
	s Ret=""
	s ItmScoreDr = $o(^DHCEMCSS(0,"Code",$$ALPHAUP^SSUTIL4(ScoreScaleCode),""),-1)
	s ScoreRowID = ##Class(web.DHCEMCScore).GetScoreRowID(EmPCLvID,ItmScoreDr)
	q:ScoreRowID="" ""
	;EpisodeID +"^"+ LgUserID +"^"+ BusType +"^"+ ScoreID +"^"+ scoreVal +"^"+ PatChkID;
	s Type=$p(^DHCEMCS(ScoreRowID),"^",5)     /// 类型
	s ScoreID=$p(^DHCEMCS(ScoreRowID),"^",6)  /// 评分表ID
	s ScoreVal=$p(^DHCEMCS(ScoreRowID),"^",7) /// 分值
	s ScoreDesc="$c(94)$c(94)"_Type_"$c(94)"_ScoreID_"$c(94)"_ScoreVal_"$c(94)"_EmPCLvID
	
	s itmID="",ScoreItmDesc=""
	b ;err1
	F  s itmID=$o(^DHCEMCSI(0,"Score",ScoreRowID,itmID)) Q:itmID=""  D
	.s key=$p(^DHCEMCSI(itmID),"^",2)  /// key
	.s val=$p(^DHCEMCSI(itmID),"^",3)  /// val
	.s type=$p(^DHCEMCSI(itmID),"^",4) /// type
	.s ItmData=key_"$c(94)"_val_"$c(94)"_type
	.s:ScoreItmDesc'="" ScoreItmDesc=ScoreItmDesc_"@"_ItmData
	.s:ScoreItmDesc="" ScoreItmDesc=ItmData
	s Ret=ScoreDesc_"$c(2)"_ScoreItmDesc
	q Ret
}

/// zhouxin
/// 获取Gcsid串
ClassMethod GetGcsId(EmPCLvID)
{
   	n (EmPCLvID)
   	S PCGId="",ret="",i=1
    F  S PCGId=$o(^DHCEMPCG(0,"ChkDr",EmPCLvID,PCGId))  Q:PCGId=""  D
    .S id=$P($G(^DHCEMPCG(PCGId)),"^",3)
	.Q:id=""
	.S $p(ret,"#",i)=id
	.s i=i+1
	Q ret
}

/// zhouxin
/// 获取自动评分datagrid
ClassMethod GetAutoScore(EmPCLvID)
{
   	n (EmPCLvID,%session)
  	s ret=""
  	s scoreId="",i=1
  	f  s scoreId=$o(^User.DHCEmPatChkScoreItmI("IndexChk",EmPCLvID,scoreId)) q:scoreId=""  d
  	.s itmLbData = ^User.DHCEmPatChkScoreItmD(scoreId)
  	.s itmDesc = $lg(itmLbData,5)
  	.s itmType = $lg(itmLbData,6)
  	.i itmType["SYM" d
  	..s sysLev = $p(itmDesc,":",1,$l(itmDesc,":")-1)
  	..s sysDesc = $p(itmDesc,":",$l(itmDesc,":")-1,$l(itmDesc,":"))
  	..s sysLev = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomLev","SYLDesc","",sysLev)
  	..s sysDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCSymptomFeild","SYFDesc","",sysDesc)
  	..s $li(itmLbData,5)=sysLev_":"_sysDesc
  	.i itmType'["SYM" d
  	..;s itmDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OTHER","OTHER","",itmDesc)
  	..s itmDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.patchecklev.hisui.csp",itmDesc)
	..s $li(itmLbData,5)=itmDesc
	.s data=$LISTTOSTRING(itmLbData,"||",1)
	.
	.s $p(ret,"$$",i)=data
	.s i=i+1
	q ret
}

/// Descript: 急诊病人候诊人员统计
/// Creator:    yangyongtao 
/// CreateDate: 2018-09-03
/// W ##Class(web.DHCEMPatCheckLevQuery).QueryOutRegQuePatList("266")
ClassMethod QueryOutRegQuePatList(LocID As %String) As %String
{
	n (LocID)
	S StartDate=$H-1
	S EndDate=$H
	s StartTime = $p($H,",",2)
	S EmPatLevWait=0
	F Date=StartDate:1:EndDate Do
	.S:Date=StartDate Time=StartTime      //取24小时
	.S:Date'=StartDate Time=""            //第二天查全天
	.F  S Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  D
	..S EpisodeID=""
	..F  S EpisodeID=$O(^PAADMi("CurrLoc",LocID,Date,Time,EpisodeID)) Q:(EpisodeID="")  D
    ...s WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	...i WalkStatus="" s EmPatLevWait=EmPatLevWait+1
   Q EmPatLevWait
}

/// Descript: 通过就诊ID获取分诊记录中生命体征、既往史、症状
/// Creator:    yangyongtao 
/// CreateDate: 2018-09-03
/// W ##Class(web.DHCEMPatCheckLevQuery).QueryPatChkSign("")
ClassMethod QueryPatChkSign(EpisodeID As %String) As %String
{
	n (EpisodeID)
	S EmPatChkSign="",EmHisDesc="",EmSymDesc=""                  //生命体征、既往史、症状
	S EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""),-1) 

    s:EmPCLvID'="" EmPatChkSign=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSignDesc(EmPCLvID)      /// 生命体征
    S:EmPCLvID'="" EmHisDesc=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHisDesc(EmPCLvID)    /// 既往史
    s:EmPCLvID'="" EmSymDesc=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状
	S:EmSymDesc'="" EmSymDesc=##class(web.DHCEMPatCheckLevQuery).GetEmSymDesc(EmSymDesc)		    /// 症状
    Q EmPatChkSign_"#"_EmHisDesc_"#"_EmSymDesc
}

/// 急诊护士执行页面通过登记号查询腕带信息 add by xieyejian 20180711 end
/// Descript: 查询群伤病人登记
/// Creator: lvpeng
/// CreatDate: 2018-1-22
/// 
/// w ##Class(web.DHCEMPatCheckLevQuery).QueryGroupHurt(1,10,"^")
ClassMethod QueryGroupHurtNew(page = 1, rows = 10, params As %String)
{
	n (page,rows,params,%session)
	s Start=(page-1)*rows+1
	s End=page*rows
	s StDate=$p(params,"^",1)
	s:StDate'="" StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)  
	s:StDate="" StDate=+$h
	s EndDate=$p(params,"^",2)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:EndDate="" EndDate=+$h
	s LgHospID=$p(params,"^",3)
	
	s Pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	
	f Date=StDate:1:EndDate d
	.s GPSRowid=0
	.f  s GPSRowid=$o(^DHCEMGPS(0,"Date",Date,GPSRowid))  Q:+GPSRowid=0  D
 	..s GroupHurtStDate=$p(^DHCEMGPS(GPSRowid),"^",1)
 	..q:(StDate'="")&&(GroupHurtStDate<StDate)
 	..q:(EndDate'="")&&(GroupHurtStDate>EndDate)
 	..s GPSHospID = $p(^DHCEMGPS(GPSRowid),"^",12)
 	..q:(LgHospID'="")&&(LgHospID'=GPSHospID)
	..s CreatDate=Date
	..s CreatTime=$p(^DHCEMGPS(GPSRowid),"^",2)
 	..s GroupHurtTypeID=$p(^DHCEMGPS(GPSRowid),"^",4) 	//群伤类型
	..q:+GroupHurtTypeID=0
 	..s GroupHurtType = $p($g(^DHCEMGHU(GroupHurtTypeID)),"^",2)
	..s GroupHurtSite = $p(^DHCEMGPS(GPSRowid),"^",5)
 	..s GroupHurtDesc = $p(^DHCEMGPS(GPSRowid),"^",6)
 	..s GroupHurtDate = $p(^DHCEMGPS(GPSRowid),"^",7)
 	..s GroupHurtTime = $p(^DHCEMGPS(GPSRowid),"^",8)
 	..s GroupHurtDateTime = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(GroupHurtDate)_" "_$zt(+GroupHurtTime,2)
	..s Index = CreatDate_","_CreatTime_","_GPSHospID_","_GroupHurtTypeID
	..s GroupHurtPatNum = $i(TMPData("DataPatNum",Index))
	..s GroupHurtType = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmGroupHurt","GHUDesc","",GroupHurtType) //hxy 2023-02-09
	..s ItmData = GroupHurtTypeID_"^"_GroupHurtType_"^"_GroupHurtSite_"^"_GroupHurtDesc_"^"_GroupHurtDateTime_"^"_GroupHurtPatNum_"^"_Index
	..s ^TMP("web.DHCEMPatCheckLevQuery","QueryGroupHurtNew",Pid,Index)=ItmData
	..
	
	s ListTitle = "GroupHurtTypeID^GroupHurtType^GroupHurtSite^GroupHurtDesc^GroupHurtDateTime^GroupHurtPatNum^Index"
	s Count=0
	w "{""rows"":["
 	s Index=""
	f  s Index = $o(^TMP("web.DHCEMPatCheckLevQuery","QueryGroupHurtNew",Pid,Index)) q:Index=""  d
	.s ListData = ^TMP("web.DHCEMPatCheckLevQuery","QueryGroupHurtNew",Pid,Index)
	.s Count = Count+1
 	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",") 
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "],""total"":"_Count_"}"
 	Q ""
}

/// 急诊护士执行页面通过登记号查询腕带信息 add by xieyejian 20180711 end
/// Descript: 查询群伤病人登记
/// Creator: lvpeng
/// CreatDate: 2018-1-22
/// 
/// w ##Class(web.DHCEMPatCheckLevQuery).QueryGroupHurt(1,10,"^")
ClassMethod QueryGroupHurt(page = 1, rows = 10, params As %String) As %String
{
	n (page,rows,params)
	s start=(page-1)*rows+1
	s end=page*rows
	s StDate=$p(params,"^",1)
	s:StDate'="" StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)  
	s:StDate="" StDate=+$h
	s EndDate=$p(params,"^",2)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:EndDate="" EndDate=+$h
	s LgHospID=$p(params,"^",3)
	
	w "{""rows"":["
	s count=0
 	s GPSRowid=""
 	s ListTitle="PatientID^GroupHurtType^GroupHurtReg^GroupHurtName^GroupHurtSex^GroupHurtAge^GroupHurtNation^GroupHurtBirth^GroupHurtNationDr^GroupHurtcountrydr^GroupHurtSexDr^GroupHurtSite^GroupHurtDesc^GroupHurtDateTime"
	f  s GPSRowid=$o(^DHCEMGPS(GPSRowid),-1)  Q:+GPSRowid=0  D
 	.s GroupHurtStDate=$p(^DHCEMGPS(GPSRowid),"^",1)
 	.q:(StDate'="")&&(GroupHurtStDate<StDate)
 	.q:(EndDate'="")&&(GroupHurtStDate>EndDate)
 	.s GPSHospID = $p(^DHCEMGPS(GPSRowid),"^",12)
 	.q:(LgHospID'="")&&(LgHospID'=GPSHospID)
 	.s PatientID=$p(^DHCEMGPS(GPSRowid),"^",3) //病人id
 	.q:'$d(^PAPER(PatientID))
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",GPSHospID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	.;s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	.;s IdentID=##Class(web.DHCEMPatCheckLev).GetPatCredTypeID() /// 身份证ID
	.;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=IdentID IdentNo=""
	.s nationdesc=""
	.s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	.i nationdr'="" s nationdesc=$p(^CT("NAT",nationdr),"^",2)
	.s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	  /// 国家
	.;s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	  /// 电话 
	.;s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	  /// 家庭住址
	.;s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.s grouphurtdesc=""
 	.s grouphurtid=$p(^DHCEMGPS(GPSRowid),"^",4) //群伤类型id
 	.q:$p($g(^DHCEMGHU(grouphurtid)),"^",9)'="" //hxy 2019-10-21 群伤里重大事件退出
 	.i grouphurtid'="" s grouphurtdesc=$p($g(^DHCEMGHU(grouphurtid)),"^",2)
 	.s GroupHurtSite = $p(^DHCEMGPS(GPSRowid),"^",5)
 	.s GroupHurtDesc = $p(^DHCEMGPS(GPSRowid),"^",6)
 	.s GroupHurtDate = $p(^DHCEMGPS(GPSRowid),"^",7)
 	.s GroupHurtTime = $p(^DHCEMGPS(GPSRowid),"^",8)
 	.s GroupHurtDateTime = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(GroupHurtDate)_" "_$zt(+GroupHurtTime,2)
 	.s ListData=PatientID_"^"_grouphurtdesc_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_nationdesc_"^"_birthday_"^"_nationdr_"^"_countrydr_"^"_sexId
 	.s ListData = ListData_"^"_GroupHurtSite_"^"_GroupHurtDesc_"^"_GroupHurtDateTime
 	.s count = count+1
 	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w "],""total"":"_count_"}"
 	Q ""
}

/// w ##class(web.DHCEMPatCheckLevQuery).IsGroupPat("2670")
ClassMethod IsGroupPat(PatientID)
{
	n (PatientID)
	s Ret =""
	s:$d(^DHCEMGPS(0,"PAPMI",PatientID)) Ret=1
	q Ret
}

/// Descritp: 取群伤登记事件类型下拉
/// Createtor: lvpeng
/// CreateDate: 18-1-22
/// Table: DHC_EmGroupHurt
/// w ##class(web.DHCEMPatCheckLevCom).GetGroupHurtType()
ClassMethod GetGroupHurtType() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT GHU_RowId as GHUID,GHU_Desc as GHUDesc FROM DHC_EmGroupHurt,GHU_ActiveFlag as GHUFlag WHERE GHU_RowId <>0"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s NatDr = result.Data("GHUID")
		s NatDesc = result.Data("GHUDesc")
		s Flag = result.Data("GHUFlag")
		continue:Flag'="Y"
		s:NatDesc["-" NatDesc=$p(NatDesc,"-",2)
		s tmp=NatDr_"^"_NatDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// w ##class(web.DHCEMPatCheckLevQuery).GetEmPatCheLevPrtInfoByJSD(1879)
ClassMethod GetEmPatCheLevPrtInfoByJSD(EmPCLvID As %String)
{
	n (EmPCLvID)
	S ^QQA("222")=EmPCLvID
	Q:EmPCLvID="" ""  
	Q:'$d(^DHCEMPCL(EmPCLvID)) ""
	s PatCardNo="",hospName="",PatientID=""
	s PatientID = $p(^DHCEMPCL(EmPCLvID),"^",1)                    ///
	q:PatientID="" ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	                   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   		 		   /// 病人姓名
	s PatBoD=""
	s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i Birthday'="" s PatBoD=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Birthday) //$zd(Birthday,3)
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      				    /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1) 
	s:+CardNoID'=0 PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2)   /// 卡号
	s EmLocDesc=""
	s EmLocID=+$p(^DHCEMPCL(EmPCLvID),"^",10) 						 /// 分诊科室
	s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级          
	s:EmLocID'="" EmLocDesc=$p(^CTLOC(EmLocID),"^",2)
	s ProvDesc="",ProvID="",EmPccID=""
	f  s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,EmPccID)) Q:EmPccID=""  D
	.s ProvID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	s:ProvID'="" ProvDesc= $p(^CTPCP(ProvID,1),"^",2)
	s ListTitle ="PatName^PatSex^PatBoD^PatNo^PatCardNo^EmLocDesc^ProvDesc^NurseLevel"
	s ListData = PatName_"^"_PatSex_"^"_PatBoD_"^"_PatNo_"^"_PatCardNo_"^"_EmLocDesc_"^"_ProvDesc_"^"_NurseLevel
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Description: 判断界面输入日期格式是否正确
/// Creator:     zhouxin
/// Others:	w ##class(web.DHCEMPatCheckLevQuery).CheckDate("2017-13-03")
ClassMethod CheckDate(date As %String = "") As %String
{
	N (date)
	i date="" w ""
	q:date="" ""
	s DHCEMCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	w DHCEMCommonDate
	q ""
}

/// w ##Class(web.DHCEMPatCheckLevQuery).GetEmPatWDPrintData("73",2)
ClassMethod GetEmPatWDPrintData(EmPCLvID, HospDr)
{
	
	 //急诊分诊页面打印腕带，通过分诊id取数据，根据医院需求修改出参 add by xieyejian 20180716 start
	n (EmPCLvID,HospDr,%session)	
	q:+EmPCLvID="" ""
	s PatientID=$p(^DHCEMPCL(EmPCLvID),"^",1)      //根据分诊id取患者基本信息rowid
	q:+PatientID=0 ""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 性别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(EmPCLvID)   /// 年龄
	s BirthDate=$zd($p(^PAPER(PatientID,"ALL"),"^",6),3) //患者出生日期
	s AdmDate=$zd($p(^DHCEMPCL(EmPCLvID),"^",4),3)	//患者就诊日期
	s HospitalName = $p(^CT("HOSP",HospDr),"^",2)	//医院名称
	s:PatSex'="" PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-27 st
	s HospitalName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",HospitalName) //ed
	
	s Ret = PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_BirthDate_"^"_AdmDate_"^"_HospitalName
	q Ret
	//急诊分诊页面打印腕带取数据部分修改，根据医院需求修改出参 add by xieyejian 20180716 end
}

ClassMethod GetLifeSignDesc(lifeSignStr As %String) As %String
{
	n (lifeSignStr)
	q:lifeSignStr="" ""
	s retStr=""
	s len=$l(lifeSignStr,"-")
	
	f i=1:1:len  d
	.s id=$p(lifeSignStr,"-",i)
	.q:id=""
	.s desc=$p(^DHCEMPHIM(id),"^",2)
	.i retStr="" s retStr=desc
	.e  s retStr=retStr_"  "_desc
	
	q retStr
}

/// Creator：qqa
/// Descript:获取生命体征配置：用于检测生命体征输入的荒诞值
/// w ##class(web.DHCEMPatCheckLevQuery).GetSignNoralList()
ClassMethod GetSignNoralList(LgHospID = "")
{
	s LgHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("Nur_IP_MRCObservationItem",LgHospID) //hxy 2020-06-18
	s Count=0,Del=""""
	s ListTitle=""
	s OBItmID="",ListData=""
	f  s OBItmID = $o(^MRC("OBITM",OBItmID)) q:OBItmID=""  d
	.s Hosp = $p(^MRC("OBITM",OBItmID),"^",27) //hxy 2020-06-18 st
	.q:(LgHospID'="")&(Hosp'=LgHospID) //ed
	.s OBCode = $p(^MRC("OBITM",OBItmID),"^",1)
	.s NormalMin = $p(^MRC("OBITM",OBItmID),"^",13)
	.s NormalMax = $p(^MRC("OBITM",OBItmID),"^",14)
	.s ValueMin = $p(^MRC("OBITM",OBItmID),"^",19)
	.s ValueMax = $p(^MRC("OBITM",OBItmID),"^",20)
	.s ListItmData = NormalMin_"@"_NormalMax_"@"_ValueMin_"@"_ValueMax
	.;s Count=Count+1
	.;w $case(Count,1:"",:",")
	.s:ListTitle'="" ListTitle=ListTitle_"^"_OBCode
	.s:ListTitle="" ListTitle=OBCode
	.s:ListData'="" ListData=ListData_"^"_ListItmData
	.s:ListData="" ListData=ListItmData
	
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// 急诊护士执行页面打印腕带，通过患者就诊id查询腕带信息 add by xieyejian 20180711 start
/// w ##Class(web.DHCEMPatCheckLevQuery).GetEmPatWDPrintDataById("580",2)
ClassMethod GetEmPatWDPrintDataById(EpisodeID, HospDr)
{
	n (EpisodeID,HospDr,%session)	
	q:+EpisodeID="" ""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      //根据就诊id取患者基本信息rowid
	q:+PatientID=0 ""
	s PatNo= $p(^PAPER(PatientID,"PAT",1),"^",2)	//根据患者基本信息rowid取出患者登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    //患者姓名
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)		//患者性别
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  //患者年龄
	s BirthDate=$zd($p(^PAPER(PatientID,"ALL"),"^",6),3) //患者出生日期
	s AdmDate=$zd($p(^PAADM(EpisodeID),"^",6),3)	//患者就诊日期
	s HospitalName = $p(^CT("HOSP",HospDr),"^",2)	//医院名称
	s:PatSex'="" PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-27 st
	s HospitalName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",HospitalName) //ed
	
	s Ret = PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_BirthDate_"^"_AdmDate_"^"_HospitalName_"^"_""
	q Ret
}

/// 时间是否大于当前时间
/// w ##class(web.DHCEMPatCheckLevQuery).ValidDate("21/02/2020 11:45")
ClassMethod ValidDate(DateTime = "")
{
	n (DateTime)
	s Ret=""
	s Date = $p(DateTime," ",1)
	s Time = $p(DateTime," ",2)
	s:Date'="" Date=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
	s:Time'="" Time=$zth(Time)
	s CurDate = +$h
	s CurTime=$p($h,",",2)
	s:Date>CurDate Ret=1
	s:(Date=CurDate)&&(Time>CurTime) Ret=1
	q Ret
}

/// Creator:handong
/// Date:2019-9-25
/// Desc:多次保存生命体征（预检分级界面左侧列表，绿色加号）
/// 调用：w ##class(web.DHCEMPatCheckLevQuery).MultSaveVitSigns("^37^1^2^3^4^5^6^7^26")
ClassMethod MultSaveVitSigns(ListData As %String)
{
	s ResCode=1
	
	s EmPcsDateAgain=$p($h,",",1)  //日期
	
	s EmPcsTimeAgain=$p(ListData,"^",1) //时间
	s EmPcsTimeAgain=$p($h,",",2)
	
	s EmPcsTempAgain=$p(ListData,"^",2) //体温
	s EmPcsPulseAgain=$p(ListData,"^",3) //脉搏	
	s EmPcsHeartAgain=$p(ListData,"^",4) //心率
	s EmPcsBreathAgain=$p(ListData,"^",5) //呼吸
	
	s EmPcsSBPAgain=$p(ListData,"^",6) //SBP
	s EmPcsDBPAgain=$p(ListData,"^",7) //DBP
	
	s EmPcsSoP2Again=$p(ListData,"^",8) //SPO2	
	s EmPcsGluAgain=$p(ListData,"^",9) //血糖
	
	s PcsCheckDr=$p(ListData,"^",10) //PcsCheckDr
	
	Ts
	&sql(INSERT INTO SQLUser.DHC_EmPatChkSign (PCS_Chk_Dr,PCS_Time,PCS_Temp,PCS_Heart,PCS_PCS_Pulse,
			PCS_SBP,PCS_DBP,PCS_SoP2,PCS_Breathe,PCS_GLU,PCS_Date)
			VALUES(:PcsCheckDr,:EmPcsTimeAgain,:EmPcsTempAgain,:EmPcsHeartAgain,:EmPcsPulseAgain,
			       :EmPcsSBPAgain,:EmPcsDBPAgain,:EmPcsSoP2Again,:EmPcsBreathAgain,:EmPcsGluAgain,:EmPcsDateAgain))
	if (SQLCODE=0){
		Tc
	}else{
		Tro
	}
	Q SQLCODE
}

/// Creator:handong
/// Date:2019-9-25
/// Desc:获取生命体征历史测量信息（急诊预检分级左侧列表，绿色加号，干预记录）
/// 调用：w ##class(web.DHCEMPatCheckLevQuery).InitMedHistory(459,1,10)
ClassMethod InitMedHistory(EmPCLvID As %String, page = 1, rows = 10)
{
	s rowId=""
	
	s count=0
	s start=(page-1)*rows+1
	s end=page*rows
	
	w "{""rows"":["
	
	f  s rowId=$o(^DHCEMPCS(rowId)) Quit:rowId=""  d
	.s sub=$g(^DHCEMPCS(rowId))
	.s PCSChkDr=$p(sub,"^",1)
	.Q:(PCSChkDr'=EmPCLvID)
	.s EmPcsTimeAgain=$p(sub,"^",2)  //时间
	.s ^TempEmPcsTimeAgain=EmPcsTimeAgain
	.i (EmPcsTimeAgain'="") s EmPcsTimeAgain=$zt(EmPcsTimeAgain)
	.i (EmPcsTimeAgain="") s EmPcsTimeAgain=##class(websys.Translation).Get("dhcem.patchksign.csp","分诊时")
	.s phimId=""
	.s pchimId=$o(^DHCEMPCHIM(0,"PatCheckLev",EmPCLvID,""))
	.s:pchimId'="" phimId=$p(^DHCEMPCHIM(pchimId),"^",2)
	.s phim=$p($g(^DHCEMPHIM(+phimId)),"^",2)
	.s EmPcsTimeAgain=EmPcsTimeAgain_phim
	.s EmPcsTimeAgain=$tr(EmPcsTimeAgain,"/",":")
	.s EmPcsTempAgain=$p(sub,"^",3)  //体温
	.s EmPcsPulseAgain=$p(sub,"^",5) //脉搏
	.s EmPcsHeartAgain=$p(sub,"^",4) //心率
	.s EmPcsBreathAgain=$p(sub,"^",9) //呼吸
	.s EmPcsSBPAgain=$p(sub,"^",6) //SBP
	.s EmPcsDBPAgain=$p(sub,"^",7) // DBP
	.s EmPcsSoP2Again=$p(sub,"^",8) //SPO2 xyj2019-10-25顺序
	.s EmPcsGluAgain=$p(sub,"^",10) //血糖
	.s EmPcsDateAgain=$p(sub,"^",11)  //日期
	.s EmPcsDateAgain=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPcsDateAgain) //hxy 2020-03-17
	.;s EmPcsDateAgain=$zd(EmPcsDateAgain,3)
	.i EmPcsDateAgain="1840-12-31" s EmPcsDateAgain=""
	.s count=count+1
	.s tmp=EmPcsDateAgain_"^"_EmPcsTimeAgain_"^"_EmPcsTempAgain_"^"_EmPcsPulseAgain_"^"_EmPcsHeartAgain_"^"_EmPcsBreathAgain_"^"
	.s tmp=tmp_EmPcsSBPAgain_"^"_EmPcsDBPAgain_"^"_EmPcsSoP2Again_"^"_EmPcsGluAgain
	.s txt="EmPcsDateAgain^EmPcsTimeAgain^EmPcsTempAgain^EmPcsPulseAgain^EmPcsHeartAgain^EmPcsBreathAgain^EmPcsSBPAgain^EmPcsDBPAgain^EmPcsSoP2Again^EmPcsGluAgain"
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData(txt,tmp)
	w "],""total"":"_count_"}"
	Q ""
}

/// w ##class().(,"65757,41639,2,12")
ClassMethod GetPatInfo(page = 1, rows = 10, Params)
{
	n (page, rows ,Params,%session)
	s start=(page-1)*rows+1
	s end=page*rows
	s count = 0
	
	q:Params="" "{""rows"":[],""total"":0}"
	
	s InCreatDate=$p(Params,",",1)
	s InCreatTime=$p(Params,",",2)
	s InHospID=$p(Params,",",3)
	s InQsTypeID=$p(Params,",",4)

	
	s ListTitle="GPSRowID^PatientID^PatNo^PatName^PatSex^PatAge^nationdesc^birthday^nationdr^countrydr^sexId"
	w "{""rows"":["
	s GPSRowID=0
	f  s GPSRowID=$o(^DHCEMGPS(0,"Date",InCreatDate,GPSRowID))  Q:+GPSRowID=0  D
 	.s CreatDate=$p(^DHCEMGPS(GPSRowID),"^",1)
	.s CreatTime=$p(^DHCEMGPS(GPSRowID),"^",2)
	.q:InCreatTime'=CreatTime
	.s GroupHurtTypeID=$p(^DHCEMGPS(GPSRowID),"^",4) 	//群伤类型
	.q:+GroupHurtTypeID=0
	.q:GroupHurtTypeID'=InQsTypeID
	.s GPSHospID = $p(^DHCEMGPS(GPSRowID),"^",12)
 	.q:(InHospID'="")&&(InHospID'=GPSHospID)
	.s PatientID=$p(^DHCEMGPS(GPSRowID),"^",3) //病人id
 	.q:'$d(^PAPER(PatientID))
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",GPSHospID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) //$zd(birthday,3)
	.;s IdentNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)        /// 证件号
	.;s IdentID=##Class(web.DHCEMPatCheckLev).GetPatCredTypeID() /// 身份证ID
	.;s:$p($g(^PAPER(PatientID,"PAT",3)),"^",7)'=IdentID IdentNo=""
	.s nationdesc=""
	.s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	.i nationdr'="" s nationdesc=$p(^CT("NAT",nationdr),"^",2)
	.s countrydr=$p(^PAPER(PatientID,"PER",1),"^",8) 	  /// 国家
	.s ListData=GPSRowID_"^"_PatientID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_nationdesc_"^"_birthday_"^"_nationdr_"^"_countrydr_"^"_sexId
 	.s count = count+1
 	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "],""total"":"_count_"}"
 	Q ""
}

ClassMethod GetPatientData(QsIndex, PatNo, LgHospID)
{
	n (QsIndex,PatNo,LgHospID,%session)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatNo,""),-1)
	q:+PatientID=0 "-2"
	
	s AllPatientID = ##class(web.DHCEMPatCheckLevQuery).GetQsAllPat(QsIndex)
	s:AllPatientID'="" AllPatientID="^"_AllPatientID_"^"
	q:(AllPatientID'="")&&(AllPatientID[("^"_PatientID_"^")) "-1"
	
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i Birthday'="" s Birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Birthday) //$zd(birthday,3)
	s ListTitle = "PatientID^PatNo^PatName^PatSex^PatAge^Birthday"
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2023-02-09
	s ListData = PatientID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_Birthday
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

ClassMethod GetQsAllPat(QsIndex)
{
	n (QsIndex)
	s InCreatDate=$p(QsIndex,",",1)
	s InCreatTime=$p(QsIndex,",",2)
	s InHospID=$p(QsIndex,",",3)
	s InQsTypeID=$p(QsIndex,",",4)
	s Ret=""
	s GPSRowID=0
	f  s GPSRowID=$o(^DHCEMGPS(0,"Date",InCreatDate,GPSRowID))  Q:+GPSRowID=0  D
 	.s CreatDate=$p(^DHCEMGPS(GPSRowID),"^",1)
	.s CreatTime=$p(^DHCEMGPS(GPSRowID),"^",2)
	.q:InCreatTime'=CreatTime
	.s GroupHurtTypeID=$p(^DHCEMGPS(GPSRowID),"^",4) 	//群伤类型
	.q:+GroupHurtTypeID=0
	.q:GroupHurtTypeID'=InQsTypeID
	.s GPSHospID = $p(^DHCEMGPS(GPSRowID),"^",12)
 	.q:(InHospID'="")&&(InHospID'=GPSHospID)
	.s PatientID=$p(^DHCEMGPS(GPSRowID),"^",3) //病人id
	.s:Ret'="" Ret=Ret_"^"_PatientID
	.s:Ret="" Ret=PatientID
	q Ret
}

/// Desc:获取生命体征历史测量信息（急诊预检分级左侧列表，绿色加号，干预记录）
/// 调用：w ##class(web.DHCEMPatCheckLevQuery).GetQsRowID(459,1,10)
ClassMethod GetQsRowID(QsIndex)
{
	n (QsIndex)
	s InCreatDate=$p(QsIndex,",",1)
	s InCreatTime=$p(QsIndex,",",2)
	s InHospID=$p(QsIndex,",",3)
	s InQsTypeID=$p(QsIndex,",",4)
	s Ret=""
	s GPSRowID=0
	f  s GPSRowID=$o(^DHCEMGPS(0,"Date",InCreatDate,GPSRowID))  Q:(+GPSRowID=0)||(Ret'="")  D
 	.s CreatDate=$p(^DHCEMGPS(GPSRowID),"^",1)
	.s CreatTime=$p(^DHCEMGPS(GPSRowID),"^",2)
	.q:InCreatTime'=CreatTime
	.s GroupHurtTypeID=$p(^DHCEMGPS(GPSRowID),"^",4) 	//群伤类型
	.q:+GroupHurtTypeID=0
	.q:GroupHurtTypeID'=InQsTypeID
	.s GPSHospID = $p(^DHCEMGPS(GPSRowID),"^",12)
 	.q:(InHospID'="")&&(InHospID'=GPSHospID)
	.s Ret=GPSRowID
	q Ret
}

/// Description: 24小时内超时患者
/// Creator:     hxy
/// CreateDate:  2019-11-13
/// Table: 		 
/// Input:  	 LgHospID
/// Return： 	 等候超时患者信息
/// Others:		 W ##class(web.DHCEMPatCheckLevQuery).GetWaitOutPat(0,10,2)
ClassMethod GetWaitOutPat(offset = 0, limit = 10, LgHospID)
{
	N (offset,limit,LgHospID,%session)
	
	s EmStaTime="",EmEndTime=""
	
	S End = offset+limit
	S Start = offset+1
    S count=0
    
    s StDate=+$H-1,EndDate=+$H
    
	W "{""rows"":["
	f Date=StDate:1:EndDate d
	.s EmRegID=""
	.f  s EmRegID=$o(^DOCEMREGi(0,"Date",Date,EmRegID)) q:EmRegID=""  d
	..s PatientID=$p(^DOCEMREG("EM",EmRegID),"^",1)  /// 病人ID
	..s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记日期
	..s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	..;Q:(+EmStaTime'=0)&(EmStaTime>EmRegDate) 		/// 过滤日期 2016-08-29 congyue
	..;Q:(+EmEndTime'=0)&(EmRegDate>EmEndTime)		/// 过滤日期 2016-08-29 congyue
	..Q:(+EmStaTime=0)&(+$h>(EmRegDate+1))    		/// 24小时之内的病人　liangqiang
	..Q:(+EmEndTime=0)&(+$h=(EmRegDate+1))&(EmRegTime<$p($h,",",2)) //24小时之内的病人　liangqiang
	..q:'$d(^PAPER(PatientID,"PAT",1))
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	..s EmPCLvID=""
	..F  s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,EmPCLvID)) Q:EmPCLvID=""  D /// 分诊ID
	...s LvLocID=$p($g(^DHCEMPCL(+EmPCLvID)),"^",10)
	...s HospID=""
	...i LvLocID'="" s HospID=$p(^CTLOC(LvLocID),"^",22) 	/// 医院ID
	...Q:(HospID'="")&(LgHospID'=HospID)
	...s WaitTime=""
	...;i EmPCLvID'="" d
	...s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)   /// 护士分级
	...s PCARowID = $o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,""),-1) //hxy 2019-09-25 st
	...s EpisodeID=""
	...s:PCARowID'="" EpisodeID = $p(^DHCEMPCA(PCARowID),"^",2)
	...s CurStatus="" //hxy 2019-12-07 st
	...s:EpisodeID'="" CurStatus = ##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	...q:CurStatus'="" //ed 已就诊的退出
	...s WaitTime = ##class(web.DHCEMRegister).GetWaitTime(EmPCLvID,EpisodeID) //hxy ed
	...q:(WaitTime="未挂号")||(WaitTime="已就诊")||(WaitTime="已退号")||(WaitTime="已离院")
	...s:+WaitTime=0 WaitTime=##class(websys.Translation).Get("dhcem.patchecklev.hisui.csp",WaitTime)
	...s EmLvCode=+NurseLevel_"级"
	...s Priority=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(EmLvCode),""))
	...s WaitMin = $p($g(^CT("ACU",Priority)),"^",3)
	...q:WaitMin>+WaitTime
	...;q:WaitTime'["超时" 
	...s CreateDate=$p(^DHCEMPCL(EmPCLvID),"^",4)  /// 分诊时间 2016-09-19
	...s:CreateDate'="" CreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...s CreateTime=$p(^DHCEMPCL(EmPCLvID),"^",5)  /// 分诊时间 2016-09-19
	...s:CreateTime'="" CreateTime=$zt(CreateTime,2)
	...s PatChkDateTime=CreateDate_" "_CreateTime
	...s PaAdmDate = $p(^PAADM(EpisodeID),"^",6)
	...s PaAdmTime = $p(^PAADM(EpisodeID),"^",7)
	...s:PaAdmDate'="" PaAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PaAdmDate) //$zd(CreateDate,3)
	...s:PaAdmTime'="" PaAdmTime=$zt(PaAdmTime,2)
	...s AdmDateTime=PaAdmDate_" "_PaAdmTime
	...s IfHaveWaitOutDeal=..IfHaveWaitOutDeal(EmPCLvID,"DDCS") //等待超时
	...q:IfHaveWaitOutDeal=1 //已经处理过的退出
	...S TempStr=PatName_"^"_EmPCLvID_"^"_EpisodeID_"^"_NurseLevel_"^"_PatNo_"^"_PatChkDateTime_"^"_AdmDateTime
	...S count=count+1
	...Q:count<Start
	...Q:count>End
    ...W $case(count,Start:"",:",") 
	...W ##class(web.DHCAPPJsonCommon).getJsonData("PatName^EmPCLvID^EpisodeID^NurseLevel^PatNo^PatChkDateTime^AdmDateTime",TempStr)
	W "],""total"":"_count_"}"
	Q ""
}

/// Descript:	是否已有等待超时处理 hxy 2019-11-14
/// w ##Class(web.DHCEMPatCheckLevQuery).IfHaveWaitOutDeal(518,"DDCS")
ClassMethod IfHaveWaitOutDeal(EmPCLvID As %String, Flag As %String) As %String
{
	n (EmPCLvID,Flag)
	s ret="0"	
	s PCHIMId=""
	f  s PCHIMId=$o(^DHCEMPCHIM("0","PatCheckLev",EmPCLvID,PCHIMId)) q:PCHIMId=""  d
	.s PCHIMHisDr=$P($g(^DHCEMPCHIM(+PCHIMId)),"^",2)
	.q:+PCHIMHisDr=0
	.s PHIMType=$p(^DHCEMPHIM(PCHIMHisDr),"^",5)
	.q:PHIMType'=Flag
	.s ret="1"
	
	q ret
}

/// Descritp:分诊科室
/// Creator :Qiaoqingao
/// CreateDate: 2017-01-13
/// W ##Class(web.DHCEMPatCheckLevQuery).JsonGetEmPatType("2")	
ClassMethod JsonGetEmPatType(HospID As %String)
{
	
	n (HospID,%session)
	s:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	;s HospID = ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatType",HospID)
	b ;err
	s Count=0
	w "["
	s ID=0
	f  s ID=$o(^DHCEMPT(ID)) q:ID=""  d
	.q:$d(^DHCEMPT(ID))=0 ;"老人^老人^Y^10^"
	.s ThisData=^DHCEMPT(ID)
	.s IsActive=$p(ThisData,"^",3)
	.q:IsActive'="Y"
	.s ThisDataHosp=$p(ThisData,"^",4)
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatType",ID,HospID)'="Y"
	.s ThisDataDesc=$p(ThisData,"^",2)
	.s ThisDataDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatType","PTDesc","",ThisDataDesc)
	.s Tmp=ID_"^"_ThisDataDesc
	.s Count = Count+1
	.I Count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// 翻译
ClassMethod OtherTrans(Desc)
{
	s Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OTHER","OTHER","",Desc)
	q Desc
}

/// Descript:获取万能表维护的数据
/// W ##class(web.DHCEMPatCheckLevQuery).GetVitalsigns("Vitalsigns")	
ClassMethod GetVitalsigns(phimType As %String) As %String
{
	n (phimType,%session)
	s count = 0
	w "["
	s phimId=0 
	f  s phimId=$o(^DHCEMPHIM(phimId)) Q:(+phimId=0)  D
    .q:$p(^DHCEMPHIM(phimId),"^",3)'="Y"
    .q:$p(^DHCEMPHIM(phimId),"^",5)'=phimType
    .s vitalDesc=$p($g(^DHCEMPHIM(phimId)),"^",2)
    .s vitalDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatHistoryMore","PHIMDesc","",vitalDesc)
	.s tmp=phimId_"^"_vitalDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)

	w "]"
	q ""
}

}
