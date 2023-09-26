Import SQLUSER

Class web.DHCEMDeathRegQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:sufan
/// CreateDate:2018-12-12
/// Descript: 死亡患者
/// W ##Class(web.DHCEMDeathRegQuery).JSonQueryEmDeathData("30","1","2019-05-27^2020-06-03^^^")
ClassMethod JSonQueryEmDeathData(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
    s Sdate=$p(params,"^",1)    	//开始日期
    s Edate=$P(params,"^",2)	  	//结束日期
    s PatientNo=$P(params,"^",3)	//登记号
    s PatName=$P(params,"^",4)		//姓名
    s PatLocation=$P(params,"^",5)	//位置  急诊病区
    s LgHospID=$P(params,"^",6)	    //登录医院 hxy 2020-06-03
	
 	Set result=##class(%Library.ResultSet).%New("web.DHCEMDeathRegQuery:QryLocDeathRateStat")
 	Set sc=result.Execute(Sdate,Edate,PatientNo,PatName,PatLocation)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		
		s Adm=$P(result.%GetData(18),$C(13,10)) //hxy 2020-06-03 多院区 st
		s PatLocID=$p($g(^PAADM(+Adm)),"^",4) // 就诊科室
		s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
		Continue:CurHospID'=LgHospID //ed
		
		s count=count+1
		Continue:(count<Start)||(count>End)
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// Creator:sufan
/// CreateDate:2018-12-12
/// Descript: 获取死亡日期
/// W ##Class(web.DHCEMKeptPatient).getDeathDate()
ClassMethod getDeathDate(EpisodeID)
{
	n (EpisodeID)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13) /// 病人死亡日期
	Q DeceasedDate
	
#;    s Flag="N"
#;    s VisID="",VisDate=""
#;    for  s VisID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,VisID))	Q:(VisID="")||(Flag="Y")  d
#;    .s VistStatus=$p(^DHCADMVisitStatus(VisID),"^",2)		///患者状态
#;    .s VistCode=$p(^DHCPACVisitStatus(VistStatus),"^",1)	///状态Code
#;    .Q:VistCode'="DeathDischarge"
#;    .s VisDate=$p(^DHCADMVisitStatus(VisID),"^",8)
#;    .s Flag="Y"
#;    Q VisDate
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     科室死亡率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期 ,登记号,姓名,位置
/// OutPut:       留观科室^科室死亡率(一段时间内留观病人死亡总数/留观病人总数)
/// D ##Class(%ResultSet).RunQuery("web.DHCEMKeptPatient","QryLocDeathRateStat","2018-12-13","2018-12-13","","","")
Query QryLocDeathRateStat(StartDate As %String, EndDate As %String, PatientNo As %String, Name As %String, PatLocation As %String) As %Query(ROWSPEC = "seqNo:%String,DeathNum:%String,PatRegNo:%String,PatName:%String,PatSex:%String,PatAge:%String,HouseHoldName:%String,RegDate:%String,Birth:%String,VistDate:%String,DateDel:%String,DateSendMed:%String,Tel:%String,Add:%String,Come:%String,PatientID:%String,FundLetDis:%String,EpisodeID:%String") [ SqlProc ]
{
}

ClassMethod QryLocDeathRateStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientNo As %String, Name As %String, PatLocation As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 科室死亡率统计
    b ;err
	D ..GetLocDeathRateStat(StartDate, EndDate, .TmpCstArr)
	s seqNo=0
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s PatientID=$p(ListData,"^",1)		///患者ID
	.s EpisodeID=$p(ListData,"^",2)		///就诊ID
	.s WardID=$p(ListData,"^",3)		///病区ID
	.s DeathFlag=$p(ListData,"^",4)		///死亡标志
	.d OutPutData
	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutData
	Q:DeathFlag'="Y" 
	s DeathNum=""										///死亡患者编号
	s PatRegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)		/// 登记号
	Q:(PatientNo'="")&&(PatRegNo'=PatientNo)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)			/// 姓名
	Q:(Name'="")&&(Name'=PatName)
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    		/// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s HouseHoldName=""									/// 户主姓名
	s RegDate=""										/// 登记日期
	s Birth=$p($g(^PAPER(PatientID,"ALL")),"^",6)		/// 出生日期
	s Birth=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Birth)	
	s VistDate=..getDeathDate(EpisodeID)			    /// 死亡日期
	s VistDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(VistDate)	
	s DateDel=""										/// 送预防科日期
	s DateSendMed=""									/// 送病历室日期
	s Tel=$p($g(^PAPER(PatientID,"PER",4)),"^",21) 		/// 手机
    i Tel="" s Tel=$p($g(^PAPER(PatientID,"PER",1)),"^",11) /// 家庭电话
    s Add=$g(^PAPER(PatientID,"PER","ADD",1))			/// 地址
    s Come="",TransWardId=""
    s TranSub=""
    f  s TranSub=$o(^PAADM(EpisodeID,"TRANS",TranSub),-1) q:(TranSub="")||(Come'="")  d
   	.s TransWardId=$p(^PAADM(EpisodeID,"TRANS",TranSub),"^",9)
   	.q:TransWardId=""
    .s Come=$p($g(^PAWARD(+TransWardId)),"^",2)
    i Come="" d
    .s TransWardId = $p(^PAADM(EpisodeID),"^",70)
    .s Come=$p($g(^PAWARD(+TransWardId)),"^",2)
    
    s Come=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Come) //hxy 2022-12-06 st
    s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //ed
    Q:(PatLocation'="")&&(Come'[PatLocation)
    s seqNo=seqNo+1
    s FundLetDis=""
    s DeathRegID=$O(^DHCEMDR(0,"PAPMI",PatientID,""))
    i DeathRegID'="" d
    .s DeathNum=$p(^DHCEMDR(DeathRegID),"^",2)     		///死亡患者编号
    .s HouseHoldName=$p(^DHCEMDR(DeathRegID),"^",6)		///户主姓名
    .s RegDate=$p(^DHCEMDR(DeathRegID),"^",8)			///登记日期
    .i RegDate'="" s RegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(RegDate)	
    .s DateDel=$p(^DHCEMDR(DeathRegID),"^",3)			///送预防科日期
    .i DateDel'="" s DateDel=##class(web.DHCEMCommonUtil).DateLogicalToHtml(DateDel)	
    .s DateSendMed=$p(^DHCEMDR(DeathRegID),"^",4)		///送病历室日期
    .i DateSendMed'="" s DateSendMed=##class(web.DHCEMCommonUtil).DateLogicalToHtml(DateSendMed)	
    .s FundLetDis=$p(^DHCEMDR(DeathRegID),"^",5)		///根本致死原因
    ;s ListData=seqNo_"^"_DeathNum_"^"_PatRegNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_HouseHoldName_"^"_RegDate_"^"_Birth_"^"_VistDate_"^"_DateDel_"^"_DateSendMed_"^"_Tel_"^"_Add_"^"_Come_"^"_FundLetDis_"^"_EpisodeID
    d OutDeathsList

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
  
OutDeathsList
    ///序号,编号,登记号,姓名,性别,实足年龄,户主姓名,登记日期,出生日期,死亡日期,送预防科日期,送病历室日期,电话,地址,来源
    set Data=$lb(seqNo,DeathNum,PatRegNo,PatName,PatSex,PatAge,HouseHoldName,RegDate,Birth,VistDate,DateDel,DateSendMed,Tel,Add,Come,PatientID,FundLetDis,EpisodeID)		
	
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Set ind=ind+1
    quit
}

ClassMethod QryLocDeathRateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocDeathRateStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryLocDeathRateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocDeathRateStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       
/// D ##Class(web.DHCEMDeathRegQuery).GetLocDeathRateStat("2019-07-16","2019-07-18","")
ClassMethod GetLocDeathRateStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) ;$zdh(StartDate,3)
	s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)   ;$zdh(EndDate,3)
	
	F Date=StartDate:1:EndDate D
	.s VsID=""
	.F  s VsID=$o(^DHCADMVisitStatus(0,"DateStatus",Date,VsID)) Q:VsID=""  D
	..
	..s VsCode=$p(^DHCPACVisitStatus(VsID),"^",1)
	..s ID=""
	..F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",Date,VsID,ID)) Q:ID=""  D
	...s WardID=$p(^DHCADMVisitStatus(ID),"^",10)
	...s EpisodeID=$p(^DHCADMVisitStatus(ID),"^",1)  	/// 就诊ID
	...s WardID = $p(^PAADM(EpisodeID),"^",70)
	...s VisitStatusID=$p(^DHCADMVisitStatus(ID),"^",2)
	...s VisitStatus=$p($g(^DHCPACVisitStatus(+VisitStatusID)),"^",2)
	...q:VisitStatus'["死亡"
	...s Ward=$p($g(^PAWARD(+WardID)),"^",2)  			/// 病区描述
	...s DeathFlag=..GetDeathFlag(EpisodeID)  			/// 病人是否死亡
	...s PatientID=$p(^PAADM(EpisodeID),"^",1)
	...s TmpCstArr(EpisodeID)=PatientID_"^"_EpisodeID_"^"_WardID_"^"_DeathFlag
	Q ""
}

/// Descript:  病人是否死亡:状态
/// w ##class(web.DHCEMDeathRegQuery).GetDeathFlag(1103)
ClassMethod GetDeathFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
    s PatientID = $p(^PAADM(EpisodeID),"^",1)
    s Flag = $p(^PAPER(PatientID,"ALL"),"^",12)   ///病人死亡标记
    q Flag
}

/// Creator:sufan
/// CreateDate:2018-12-17
/// Descript: 死亡登记保存
/// Input:	患者ID^死亡患者编号^送预防科日期^送病历室日期^根本致死疾病^户主姓名^操作者
/// w ##class(web.DHCEMDeathRegQuery).SaveDeathInfo("29977592^0001^2018-12-17^2018-12-17^^户主姓名^26581")
ClassMethod SaveDeathInfo(Params)
{
	n (Params)
	s PatientID=$p(Params,"^",1)       		///患者ID
	s DeathPatNum=$p(Params,"^",2)          ///死亡患者编号
	s DelPreSecDate=$p(Params,"^",3)        ///送预防科日期
	s DelMedRecDate=$p(Params,"^",4)        ///送病历室日期
	s FundLetDis=$p(Params,"^",5)        	///根本致死疾病
	s HouHolderName=$p(Params,"^",6)        ///户主姓名
	s UserId=$p(Params,"^",7)				///操作者
	i '$d(^DHCEMDR(0,"PAPMI",PatientID)) d
	.s Obj=##class(User.DHCEmDeathReg).%New()
	.s Obj.DRCreateUser=##class(User.SSUser).%OpenId(UserId,0)
	.s Obj.DRCreateDate=+$h
	.s Obj.DRCreateTime=$p($h,",",2)
	e  d
	.s DrRowID=$o(^DHCEMDR(0,"PAPMI",PatientID,""))
	.s Obj=##class(User.DHCEmDeathReg).%OpenId(DrRowID,0)
	.s Obj.DRUpdateUser=##class(User.SSUser).%OpenId(UserId,0)
	.s Obj.DRUpdateDate=+$h
	.s Obj.DRUpdateTime=$p($h,",",2)
	s Obj.DRPAPMIDr=##class(User.PAPatMas).%OpenId(PatientID,0)
	s Obj.DRDeathPatNum=DeathPatNum
	s Obj.DRDelPreSecDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(DelPreSecDate)	
	s Obj.DRDelMedRecDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(DelMedRecDate)	
	s Obj.DRFundLetDis=FundLetDis
	s Obj.DRHouHolderName=HouHolderName
	s sc=Obj.%Save()
	i $$$ISERR(sc) q -100  
	q 0
}

}
