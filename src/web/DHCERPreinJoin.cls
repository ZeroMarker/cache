/// Descript:   院前院内现金平台
/// Creator:    sunhe
/// CreateDate: 2022-08-15
Class web.DHCERPreinJoin Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 院前急救患者列表
/// W ##Class(web.DHCERPreinJoin).GetErPatList("30","1","25702^19^2^^^^")
ClassMethod GetErPatList(rows As %String, page As %String, Params As %String)
{
	// s ^TempArr("czb")=params
	n (rows,page,Params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TempArr
	s TempArr=""
	
	s UserID=$p(Params,"^",1)												// 登录ID
	s LocID=$p(Params,"^",2)												// 科室ID
	s HospID=$p(Params,"^",3)												// 医院ID
	
	s StartDate=$p(Params,"^",4)
	i StartDate="" s StartDate=+$h-90
	e  s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)  // 如果没有传入开始日期，则取现在日期后退30天
	
	s EndDate=$p(Params,"^",5)
	i EndDate=""  s EndDate=+$h
	e  s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)   // 如果没有传入结束日期，则取现在日期
	
	s registNo=$p(Params,"^",6)												// 登记号		
	s name=$p(Params,"^",7)												// 姓名		
	w "{""rows"":["
	s count=0
	s ListTitle="ItmXH^PatNo^PatName^PatAge^PatSex^FirstAssessment^PAAdmDate^PAAdmTime^SpecialDis^HelpType^EpisodeID^EMIsEmergency^EMDisease^EMDispJud^EMTaskType^PatTel^EDLicNum^VispTaskNo^admDr^SN"
	s EpisodeID=""												  /// 院前就诊id
	f dd=StartDate:1:EndDate  d
	.f  s EpisodeID=$o(^User.DHCERAdmI("CreateDate",dd,EpisodeID),-1) q:EpisodeID=""  d
	..s PatientID=$lg(^User.DHCERAdmD(EpisodeID),2)				  /// 病人id
	..s PatName=$lg(^User.DHCERPersonD(PatientID),2) 			  /// 获取病人姓名
	..s PreId=$lg(^User.DHCERAdmD(EpisodeID),6)		  			  /// 出诊记录ID
	..s:PatName="" PatName=$p(^DHCEMPHV(PreId),"^",3)			  /// 就诊表姓名为空时，从调度表取
	..q:(name'="")&(PatName'[name)								  /// 判断是否符合姓名查询条件
	..s ZiyunHospID=$p(^DHCEMPHV(PreId),"^",35)                   //紫云医院id
	..s VispTaskNo=$p(^DHCEMPHV(PreId),"^",18)                    /// 任务号
	..s InAdmDr=$lg(^User.DHCERAdmD(EpisodeID),10)				  /// 获取院内his就诊id	 
	..s:InAdmDr'="" InPatientID=$p($g(^PAADM(InAdmDr)),"^",1)  					  /// 院内患者ID
	..s:$g(InPatientID)'="" PatNo=$p(^PAPER(InPatientID,"PAT",1),"^",1)	      /// 登记号
	..q:(registNo'="")&&($g(PatNo)'=registNo)								  /// 登记号判断							 
	..s:InAdmDr'="" ambManId=$o(^DHCEMDAM(0,"ADM",InAdmDr,""))							  /// 根据就诊id获取派车记录id
	..s:$g(ambManId)'="" AmbDr=$p(^DHCEMDAM(ambManId),"^",11)					  /// 获取车辆信息指向
	..s:$g(AmbDr)'="" CarCode=$Listget(^User.DHCERAmbulanceD(AmbDr),3) 	  /// 获取车牌号
	..s:ambManId'="" AmbDr=$p(^DHCEMDAM(ambManId),"^",11)
	..s SN=""
	...
	..//q:(carNo'="")&&(carNo'=$g(CarCode))
	..s recID=""
	..s:InAdmDr'="" recID=$o(^User.DHCERMedRecI("Adm",InAdmDr,recID))		  /// 获取病历id
	..s:recID'="" CstEmFlag= ##Class(web.DHCERCom).GetFormEleValue(recID,"CstEmFlag")  /// 获取急救种类
	..//q:(HelpType'="")&(HelpType'=$g(CstEmFlag))
	..s:recID'="" FirstAssessment = ##Class(web.DHCERCom).GetFormEleValue(recID,"FirstAssessment")  /// 获取初步评级的数据
	..s count=count + 1
	..q:(count<Start)||(count>End)
	..//s PatAge=$lg(^User.DHCERPersonD(PatientID),4)    		  	  	 /// 年龄
	..//s:PatAge="" PatAge=$p(^DHCEMPHV(PreId),"^",5)					 /// 就诊年龄为空时，在调度表取
	..s patId = $p($g(^PAADM(InAdmDr)), "^", 1) // 
	..i patId'="" s PatAge = ##class(web.DHCBillInterface).GetPapmiAge(patId, "", 2)
	..s sexId=$lg(^User.DHCERPersonD(PatientID),3)     				 /// 姓别指向
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)			  	 /// 姓别描述
	..s:$g(PatSex)="" PatSex=$p(^DHCEMPHV(PreId),"^",4)				 /// 姓别描述就诊性别为空时，在调度表取
	..s time=$lg(^User.DHCERAdmD(EpisodeID),8)					  	 /// 就诊时间
	..s PAAdmDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(dd) /// 就诊日期
	..s:time'="" time=$zt(time,2)
	..s PatTel=$lg(^User.DHCERPersonD(PatientID),14)				 /// 获取患者电话
	..s EMDispJud=$p(^DHCEMPHV(PreId),"^",19)						 /// 获取调度判断
	..s EMTaskType=$p(^DHCEMPHV(PreId),"^",25)						 /// 获取任务类型
	..s EMIsEmergency=$p(^DHCEMPHV(PreId),"^",31)					 /// 获取是否是突发事件
	..i $g(EMIsEmergency)=0 s EMIsEmergency="是"
	..e  s EMIsEmergency="否"
	..s EMDisease=$p(^DHCEMPHV(PreId),"^",34)						 /// 获取病种
	..s ListData=count_"^"_$g(PatNo)_"^"_$g(PatName)_"^"_$g(PatAge)_"^"_$g(PatSex)_"^"_$g(FirstAssessment)_"^"_$g(PAAdmDate)_"^"_$g(time)
	..s ListData=ListData_"^^"_$g(CstEmFlag)_"^"_$g(InAdmDr)_"^"_EMIsEmergency_"^"_EMDisease_"^"_EMDispJud_"^"_EMTaskType_"^"_PatTel_"^"_$g(CarCode)_"^"_$g(VispTaskNo)_"^"_$g(EpisodeID)_"^"_$g(SN)
	..i count '= Start d
	...w ","
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "],"
	w """total"":"_count_"}"
	
	q ""
}

/// Creator: 		sunhe
/// CreateDate: 	2022-08-18
/// Descript: 	    根据工号获取会诊组页面维护的对应紫云医院id
/// W ##Class(web.DHCERPreinJoin).GetUserList()
ClassMethod GetZiyunHosp(UserID As %String) As %String
{
	n (UserID)
	s code=$p(^SSU("SSUSR",UserID),"^",1) /// 工号
	s CsUserID=$o(^User.DHCERCsUserI("IndexCode",code,""))    //会诊人员表id
	s CsGrpID=$lg(^User.DHCERCsUserD(CsUserID),5)             //会诊组表id
	s HosID=$lg(^User.DHCERCsGrpSD(CsGrpID),5)                //紫云医院表id
		
	q HosID
}

}
