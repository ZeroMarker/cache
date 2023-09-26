Import SQLUser

/// Creator: 	hxy
/// CreateDate: 2019-10-19
/// Descript: 	重大事件
Class web.DHCEMGroupPatMajor Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  分诊id取患者姓名登记号
/// w ##Class(web.DHCEMGroupPatMajor).GetInfo("290")
ClassMethod GetInfo(PatientID As %String) As %String
{
	n (PatientID)
	q:PatientID="" ""
	q:'$d(^PAPER(PatientID)) ""
	s ret=""
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	    /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   	/// 病人姓名
	;s ret="姓名："_PatName_"<br>  登记号："_PatNo
	s ret=PatName_"^"_PatNo
	q ret
}

/// Creator：      hxy
/// CreatDate：    2019-10-21
/// Description:： 保存或者新增 群伤管理事件字典
/// Table：        DHC_EmGroupHurt
/// Input：	       GHUCode：代码
///                GHUDesc：描述
///                GHUCreateDate: 事件日期
///                GHUCreateTime: 事件时间
///                //GHUGeneralSpec: 概要说明
///                GHUDetailSpec: 详细说明
///                GHUActiveFlag：是否可用             
///                GHUHospDr: 医院id
/// 			   GHU_Type:事件类型
///                GHU_ReportFor: 汇报对象
///                GHU_ReportUser_Dr: 汇报人
///                GHU_ReportTime: 汇报时间
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
	 s GHUCreateDateAndTime=$p(str,"^",1)
	 s GHUCreateDate="",GHUCreateTime=""
	 s:GHUCreateDateAndTime'="" GHUCreateDate=$p(GHUCreateDateAndTime," ",1) //事件日期
	 s:GHUCreateDateAndTime'="" GHUCreateTime=$p(GHUCreateDateAndTime," ",2) //事件时间
	 s GHUGroupHurtSite=$p(str,"^",2) //事件地点
	 s GHUDetailSpec=$p(str,"^",3) //详细说明
	 s GHUCode=$e(GHUDetailSpec,1,3) //代码
	 s GHUDesc=$e(GHUDetailSpec,1,3) //描述
	 s GHUReportFor=$p(str,"^",4) //汇报对象
	 s GHUReportUserDr=$p(str,"^",5) //汇报人
	 s GHUReportTime=$p(str,"^",6) //汇报时间
	 s GHUHospDr=$p(str,"^",7) //医院
	 s GHUType=$p(str,"^",8) //事件类型
	 s ID=$p(str,"^",9)
	 
	 i +ID=0 
	 { 
	 	 s obj=##class(User.DHCEmGroupHurt).%New()
	 }else{
		 s obj=##class(User.DHCEmGroupHurt).%OpenId(ID)
	 }
	 s obj.GHUCreateDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(GHUCreateDate)
	 s obj.GHUCreateTime=$zth(GHUCreateTime,1)
	 s obj.GHUSite=GHUGroupHurtSite
	 s obj.GHUDetailSpec=GHUDetailSpec
	 s obj.GHUCode=GHUCode
	 s obj.GHUDesc=GHUDesc
	 s obj.GHUReportFor=GHUReportFor
	 s obj.GHUReportUserDr=##class(User.SSUser).%OpenId(GHUReportUserDr,0)
	 s obj.GHUReportTime=GHUReportTime
	 s obj.GHUHospDr=##class(User.CTHospital).%OpenId(GHUHospDr,0)
	 s obj.GHUType=GHUType
	 s obj.GHUActiveFlag="Y"
     s sc=obj.%Save() 
     ;d obj.%close()  
	 ;i $$$ISERR(sc) q -2
	 q 0
}

/// w ##class(web.DHCEMGroupPatMajor).SavePatGroupHurt("2019-10-21 13:57:04^地点^描述^12^1320^2019-10-21 13:57:14^2^Major^")
ClassMethod SavePatGroupHurt(params)
{
	n (params)
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      hxy
/// CreatDate：    2019-10-21
/// Description:： 分页显示重大事件维护数据
/// Table：        DHC_EmGroupHurt
/// Input：	      page：当前页数
///               rows：每页条数    
/// d ##class(web.DHCEMGroupPatMajor).ListGroupHurt(1,10,"","","")
ClassMethod ListGroupHurt(page = 1, rows = 10, params)
{
	n (page, rows, params,%session)
    s start=(page-1)*rows+1
    s end=page*rows
    s StDate=$p(params,"^",1)
	s:StDate'="" StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)  
	s:StDate="" StDate=+$h
	s EndDate=$p(params,"^",2)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:EndDate="" EndDate=+$h
    s LgHospID=$p(params,"^",3)
    
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s ghtId=""
	f  s ghtId=$o(^DHCEMGHU(ghtId)) q:ghtId=""  d
	.q:ghtId=0
	.q:$p(^DHCEMGHU(ghtId),"^",9)'="Major" //hxy 2019-10-21 事件类型有值得退出
	.s GHUCreateDate=$p(^DHCEMGHU(ghtId),"^",3)
	.q:(StDate'="")&&(GHUCreateDate<StDate)
 	.q:(EndDate'="")&&(GHUCreateDate>EndDate)
	.s:GHUCreateDate'="" GHUCreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(GHUCreateDate)
	.s GHUCreateTime=$p(^DHCEMGHU(ghtId),"^",4)
	.s:GHUCreateTime'="" GHUCreateTime=$zt(GHUCreateTime,1)
	.s GHUDateAndTime=GHUCreateDate_" "_GHUCreateTime
	.s GHUDetailSpec=$p(^DHCEMGHU(ghtId),"^",6)
	.s GHUHospDr=$p(^DHCEMGHU(ghtId),"^",8)
	.s GHUSite=$p(^DHCEMGHU(ghtId),"^",10)
	.s GHUReportFor=$p(^DHCEMGHU(ghtId),"^",11)
	.s GHUReportUserDr=$p(^DHCEMGHU(ghtId),"^",12)
	.s GHUReportUser=$p(^SSU("SSUSR",GHUReportUserDr),"^",2)
	.s GHUReportUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",GHUReportUser)
	.s GHUReportTime=$p(^DHCEMGHU(ghtId),"^",13)
	.s tmp=ghtId_"^"_GHUDateAndTime_"^"_GHUSite_"^"_GHUDetailSpec_"^"_GHUReportFor_"^"_GHUReportUserDr_"^"_GHUReportUser_"^"_GHUReportTime
	.q:(LgHospID'="")&(LgHospID'=GHUHospDr)
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",") 
	.;w jsonObj.FromObject(##class(User.DHCEmPatHistory).%OpenId(phId)).Json()
	.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^GHUDateAndTime^GHUSite^GHUDetailSpec^GHUReportFor^GHUReportUserDr^GHUReportUser^GHUReportTime",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// w ##class(web.DHCEMGroupPatMajor).LinkPat("1391^38")
ClassMethod LinkPat(params)
{
	n (params) 
	s ret=0
	s GPSPAPMIDr=$p(params,"^",1)
	q:GPSPAPMIDr="" ret
	s GroupID=$p(params,"^",2)
	s GPSCreateDate=+$h
	s GPSCreateTime=$p($h,",",2)
	
	s isIN=0 //hxy 2020-03-20 st
    i $d(^DHCEMGPS(0,"PAPMI",GPSPAPMIDr)) d
    .s GPS=""
    .f  s GPS=$O(^DHCEMGPS(0,"PAPMI",GPSPAPMIDr,GPS)) q:(GPS="")!(isIN=1)  d
	..q:GPS=0
	..s Group=$p($g(^DHCEMGPS(+GPS)),"^",4)
    ..s:Group=GroupID isIN=1
    .
    q:isIN=1 1 //ed
	
	&SQL(insert into DHC_EmGroupPatAsso (GPS_CreateDate,GPS_CreateTime,GPS_PAPMI_Dr,GPS_GHU_Dr)
		values(:GPSCreateDate,:GPSCreateTime,:GPSPAPMIDr,:GroupID))
	s:SQLCODE'=0 ret=-1
	q ret
}

/// w ##Class(web.DHCEMGroupPatMajor).QueryGroupHurt(1,10,"^")
ClassMethod QueryGroupHurt(page = 1, rows = 10, params As %String) As %String
{
	n (page,rows,params,%session)
	s LgHospID=""
	s:$d(%session) LgHospID=%session.Get("LOGON.HOSPID")
	s start=(page-1)*rows+1
	s end=page*rows
	s GroupDr=$p(params,"^",1)
	
	w "{""rows"":["
	s count=0
 	s GPSRowid=""
 	s ListTitle="GroupHurtReg^GroupHurtName^GroupHurtSex^GroupHurtAge^GroupHurtBirth^ID"
	f  s GPSRowid=$o(^DHCEMGPS(GPSRowid),-1)  Q:+GPSRowid=0  D
 	.s Group=$p(^DHCEMGPS(GPSRowid),"^",4)
 	.q:GroupDr'=Group
 	.s PatientID=$p(^DHCEMGPS(GPSRowid),"^",3) //病人id
 	.q:'$d(^PAPER(PatientID))
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   /// 病人登记号
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatSex=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) 
 	.
 	.s ListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_birthday_"^"_GPSRowid
 	.s count = count+1
 	.q:count<start
	.q:count>end
	.w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)

	w "],""total"":"_count_"}"
 	Q ""
}

/// Creator：      hxy
/// CreatDate：    2020-04-07
/// Description:： 删除患者关联
/// Table：        DHC_EmGroupPatAsso
/// Input：	       Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod CanLinkPat(ID)
{
	n (ID)
	q:+ID=0 -1
	s ret=##class(User.DHCEmGroupPatAsso).%DeleteId(ID)
	q 0
}

/// Creator：      hxy
/// CreatDate：    2023-02-11
/// Description:： 取姓名翻译
/// Input：	       Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod GetTrsUser(LgUserName)
{
	n (LgUserName,%session)
	s LgUserName=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",LgUserName)
	q LgUserName
}

}
