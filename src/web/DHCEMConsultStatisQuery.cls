Import SQLUSER

Class web.DHCEMConsultStatisQuery Extends %Persistent [ Not ProcedureBlock ]
{

/// Description: 会诊申请统计金额
/// Creator:     QQA
/// CreateDate:  2018-06-29
/// Table: 		 DHC_EmConsult
/// Input:  	 
/// Return： 	 
/// Others:		w ##class(web.DHCEMConsultStatisQuery).GetConsultList("^^2^Y^47")
ClassMethod GetConsultListBak(Params As %String)
{
	n (Params)
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i StartDate="" s StartDate=+$H-7
    i EndDate="" s EndDate=+$H
	s QueryType=$p(Params,"^",3)
	s:QueryType=1 QueryType="SendLoc"
	s:QueryType=2 QueryType="GetLoc"
	s showDetail=$p(Params,"^",4)
	s CurLocID = $p(Params,"^",5)
	s CosultType = $p(Params,"^",6)
	s CurLoc=""
	s:+CurLocID'=0 CurLoc=$p(^CTLOC(CurLocID),"^",2)
	k TMPConsultList
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s OneOrMore=$p(^DHCEMCON(CstID),"^",31)
	..s:OneOrMore'="Y" OneOrMore="N"
	..q:(CosultType'="")&&(CosultType'=OneOrMore)
	..s CstType = $p(^DHCEMCON(CstID),"^",19)            /// DOCA为抗菌药物
	..q:CstType="DOCA"                         /// 不统计抗菌药物
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRUser=""
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	..s CstStatusID=$p(^DHCEMCON(CstID),"^",18)  /// 状态
	..q:+CstStatusID=0
	..q:$p($g(^DHCEMCONS(+CstStatusID)),"^",2)'="完成"  //非完成状态直接
	..
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	...s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	...;q:(LocID'="")&&(CsLocID'=LocID)
	...s CareProvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)        /// 职称
	...s CsOrdID = $P($g(^DHCEMCON(CstID,"I",CH)),"^",10)
	...s OrdPrice = ..GetOrdPriceByOrd(CsOrdID)
	...
	...s Num=Num+1
	...q:+CstRLocID=0
	...q:+CsLocID=0
	...q:+CareProvTpID=0
	...q:+CareProvID=0
	...i $d(TMPListData("SendLoc",CstRLocID,CsLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("SendLoc",CstRLocID,CsLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("SendLoc",CstRLocID,CsLocID,CareProvTpID,CsUserID,+OrdPrice)+1
	...i '$d(TMPListData("SendLoc",CstRLocID,CsLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("SendLoc",CstRLocID,CsLocID,CareProvTpID,CsUserID,+OrdPrice) = 1
	...i $d(TMPListData("GetLoc",CsLocID,CstRLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("GetLoc",CsLocID,CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("GetLoc",CsLocID,CstRLocID,CareProvTpID,CsUserID,+OrdPrice)+1
	...i '$d(TMPListData("GetLoc",CsLocID,CstRLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("GetLoc",CsLocID,CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = 1

	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s:QueryType="SendLoc" ListString = "CstRLoc^CsLocDesc^CareProvTpDesc^CsUserDesc^Number^OrdAllPress"
	s:QueryType="GetLoc" ListString = "CsLocDesc^CstRLoc^CareProvTpDesc^CsUserDesc^Number^OrdAllPress"
	s Count=0

	s CstRLocID=""
	f  s CstRLocID = $o(TMPListData(QueryType,CstRLocID)) q:CstRLocID=""  d
	.s CsLocID=""
	.f  s CsLocID = $o(TMPListData(QueryType,CstRLocID,CsLocID)) q:CsLocID=""  d
	..s CareProvTpID = ""
	..f  s CareProvTpID = $o(TMPListData(QueryType,CstRLocID,CsLocID,CareProvTpID)) q:CareProvTpID=""  d
	...s ProvTpNum=0,ProvTpAllPress=0  						//不查询明细,按级别查询
	...s CstRLoc = $p(^CTLOC(CstRLocID),"^",2)              //申请科室
	...s CsLocDesc = $p(^CTLOC(CsLocID),"^",2)				//接收科室
	...s CareProvTpDesc = $p(^CT("CPT",CareProvTpID),"^",2) //级别
	...s CsUserID = ""
	...f  s CsUserID = $o(TMPListData(QueryType,CstRLocID,CsLocID,CareProvTpID,CsUserID)) q:CsUserID=""  d
	....s Number = 0,OrdAllPress=0    		//按具体的人统计人数和价格
	....s OrdPrice=""
	....f  s OrdPrice = $o(TMPListData(QueryType,CstRLocID,CsLocID,CareProvTpID,CsUserID,OrdPrice)) q:OrdPrice=""  d
	.....s ThisNum = TMPListData(QueryType,CstRLocID,CsLocID,CareProvTpID,CsUserID,OrdPrice) 
	.....s Number = Number+ThisNum
	.....s AllOrdPress =  OrdPrice*ThisNum    //数量*单价
	.....s OrdAllPress = OrdAllPress+AllOrdPress
	.....s ProvTpNum = ProvTpNum+ThisNum
	.....s ProvTpAllPress = ProvTpAllPress+AllOrdPress
	....q:showDetail'="Y"                                 //是否显示明细
	....s CsUserDesc = $p(^SSU("SSUSR",CsUserID),"^",2)   //医生名称
	....q:(CurLoc'="")&&(CurLoc'=CstRLoc)
	....b ;err
	....s Count =Count+1								  
	....s ListData = CstRLoc_"^"_CsLocDesc_"^"_CareProvTpDesc_"^"_CsUserDesc_"^"_Number_"^"_OrdAllPress
	....w $case(Count,1:"",Count:",")                     //显示明细的时候这里输出
	....w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	...q:showDetail="Y"                   				  //是否显示明细
	...q:(CurLoc'="")&&(CurLoc'=CstRLoc)  
	...;q:(CurLoc'="")&&(CurLoc'=CsLocDesc)&&(CurLoc'=CstRLoc) 
	...s Count =Count+1		
	...s ListData = CstRLoc_"^"_CsLocDesc_"^"_CareProvTpDesc_"^^"_ProvTpNum_"^"_ProvTpAllPress
	...w $case(Count,1:"",Count:",")
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	Q ""
}

/// Description: 会诊申请统计金额
/// Creator:     QQA
/// CreateDate:  2018-06-29
/// Table: 		 DHC_EmConsult
/// Input:  	 
/// Return： 	 
/// Others:		w ##class(web.DHCEMConsultStatisQuery).GetConsultList("2020-09-03^2020-09-10^1^Y^^1^^2")
ClassMethod GetConsultList(Params As %String)
{
	n (Params,%session)
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i StartDate="" s StartDate=+$H-7
    i EndDate="" s EndDate=+$H
	s QueryType=$p(Params,"^",3)
	s QueryTypeItms=""
	s:QueryType=1 QueryTypeItms="SendLocConsItms"
	s:QueryType=2 QueryTypeItms="GetLocConsItms"
	s:QueryType=1 QueryType="SendLoc"
	s:QueryType=2 QueryType="GetLoc"
	s showDetail=$p(Params,"^",4)
	s CurLocID = $p(Params,"^",5)
	s CosultType = $p(Params,"^",6)
	s ConsNature = $p(Params,"^",7)
	s LgHospID=$p(Params,"^",8)
	s CurLoc=""
	s:+CurLocID'=0 CurLoc=$p(^CTLOC(CurLocID),"^",2)
	k TMPConsultList
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s CstEmFlag=$p(^DHCEMCON(+CstID),"^",23)
	..s CstEmNature=$p(^DHCEMCON(+CstID),"^",45) //hxy 2020-03-03 原：41
	..q:(ConsNature'="")&(ConsNature'=CstEmNature)
	..;s OneOrMore=$p(^DHCEMCON(CstID),"^",31)
	..;s:OneOrMore'="Y" OneOrMore="N"
	..;q:(CosultType'="")&&(CosultType'=OneOrMore)
	..s CstType = $p(^DHCEMCON(CstID),"^",19)            /// DOCA为抗菌药物
	..
	..;q:CstType="DOCA"                         /// 不统计抗菌药物
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CurHospID=$p($g(^CTLOC(+CstRLocID)),"^",22)
	..q:(LgHospID'="")&(LgHospID'=CurHospID) //hxy 2020-09-18
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRUser=""
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	..s CstStatusID=$p(^DHCEMCON(CstID),"^",18)  /// 状态
	..s CstCat = $p(^DHCEMCON(CstID),"^",8)
	..q:(CosultType'="")&&(CosultType'=CstCat)
	..q:+CstStatusID=0
	..
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s ConsItmID = CstID_"||"_CH
	...s CstItmStaID = $p(^DHCEMCON(CstID,"I",CH),"^",6)
	...q:+CstItmStaID=0 
	...s CstItmStaDes= $p($g(^DHCEMCONS(+CstItmStaID)),"^",2)
	...q:CstItmStaDes=""
	...s CstItmStaCode=$p($g(^DHCEMCONS(+CstItmStaID)),"^",1)
	...;q:(CstItmStaDes'="完成")&&(CstItmStaDes'="确认")&&(CstItmStaDes'="评价") //非完成状态直接
	...;Q:(CstItmStaCode<50)||(CstItmStaCode=51)||(CstItmStaDes["审核")    ///不统计未完成的会诊 //hxy 2021-04-06 st 【标准版测试】会诊统计界面增加“拒收会诊次数”列和“驳回会诊次数”列；
	...Q:((CstItmStaCode<50)&&(CstItmStaCode'=22)&&(CstItmStaCode'=25))||(CstItmStaCode=51)||(CstItmStaDes["审核")    ///不统计未完成的会诊 //ed
	...s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	...i CareProvID="" s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)     /// 会诊医生
	...s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	...;q:(LocID'="")&&(CsLocID'=LocID)
	...s CareProvTpID=+$p(^DHCEMCON(CstID,"I",CH),"^",11)        /// 职称
	...s:(CareProvTpID="")&&(CareProvID'="") CareProvTpID=+##Class(web.DHCEMConsultCom).GetPrvTpIDByCareProvID(CareProvID)
	...s:QueryType=1 CsOrdID = $P($g(^DHCEMCON(CstID,"I",CH)),"^",9)
	...s:QueryType'=1 CsOrdID = $P($g(^DHCEMCON(CstID,"I",CH)),"^",10)
	...s OrdPrice = ..GetOrdPriceByOrd(CsOrdID)
	...
	...s Num=Num+1
	...q:+CstRLocID=0
	...q:+CsLocID=0
	...;q:+CareProvTpID=0 //hxy 2021-04-06 st
	...;q:+CareProvID=0
	...s CareProvID=+CareProvID
	...s CsUserID=+CsUserID
	...s OrdPrice=+OrdPrice //ed
	...;
	...;说明：SendLoc 发送科室统计节点   GetLoc 申请科室统计节点   --ConsItms 记录个数对应的会诊ID
	...i $d(TMPListData("SendLoc",CstRLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("SendLoc",CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("SendLoc",CstRLocID,CareProvTpID,CsUserID,+OrdPrice)+1
	....s TMPListData("SendLocConsItms",CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("SendLocConsItms",CstRLocID,CareProvTpID,CsUserID,+OrdPrice)_"!!"_ConsItmID
	...
	...i '$d(TMPListData("SendLoc",CstRLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("SendLoc",CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = 1
	....s TMPListData("SendLocConsItms",CstRLocID,CareProvTpID,CsUserID,+OrdPrice) = ConsItmID
	...
	...i $d(TMPListData("GetLoc",CsLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("GetLoc",CsLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("GetLoc",CsLocID,CareProvTpID,CsUserID,+OrdPrice)+1
	....s TMPListData("GetLocConsItms",CsLocID,CareProvTpID,CsUserID,+OrdPrice) = TMPListData("GetLocConsItms",CsLocID,CareProvTpID,CsUserID,+OrdPrice)_"!!"_ConsItmID
	...
	...i '$d(TMPListData("GetLoc",CsLocID,CareProvTpID,CsUserID,+OrdPrice)) d
	....s TMPListData("GetLoc",CsLocID,CareProvTpID,CsUserID,+OrdPrice) = 1
	....s TMPListData("GetLocConsItms",CsLocID,CareProvTpID,CsUserID,+OrdPrice) = ConsItmID
	
	b ;data
	
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s:QueryType="SendLoc" ListString = "CstRLoc^CareProvTpDesc^CsUserDesc^Number^OrdAllPress^ConsItms^OverTimeNumber^OverTimeItmIDs^RefNumber^RefItms^RejNumber^RejItms"
	s:QueryType="GetLoc" ListString = "CsLocDesc^CareProvTpDesc^CsUserDesc^Number^OrdAllPress^ConsItms^OverTimeNumber^OverTimeItmIDs^RefNumber^RefItms^RejNumber^RejItms"
	s Count=0

	s ConsLocID=""     //发送和接收的时候取的不一样
	f  s ConsLocID = $o(TMPListData(QueryType,ConsLocID)) q:ConsLocID=""  d
	.s CareProvTpID = ""
	.f  s CareProvTpID = $o(TMPListData(QueryType,ConsLocID,CareProvTpID)) q:CareProvTpID=""  d
	..s ProvTpNum=0,ProvTpAllPress=0  						//不查询明细,按级别查询
	..s ProvTpItmIDs=""
	..s ConsLocDesc = $p(^CTLOC(ConsLocID),"^",2)           //申请科室
	..s CareProvTpDesc = $p(^CT("CPT",CareProvTpID),"^",2) //级别
	..s CareProvTpDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CareProvTpDesc)
	..s CsUserID = ""
	..f  s CsUserID = $o(TMPListData(QueryType,ConsLocID,CareProvTpID,CsUserID)) q:CsUserID=""  d
	...s ItmIDs=""                          //后期新增，用于显示明细
	...s Number = 0,OrdAllPress=0    		//按具体的人统计人数和价格
	...s OrdPrice=""
	...f  s OrdPrice = $o(TMPListData(QueryType,ConsLocID,CareProvTpID,CsUserID,OrdPrice)) q:OrdPrice=""  d
	....s ThisNum = TMPListData(QueryType,ConsLocID,CareProvTpID,CsUserID,OrdPrice) 
	....s ThisItmIDs = TMPListData(QueryTypeItms,ConsLocID,CareProvTpID,CsUserID,OrdPrice)  ///数字对应的会诊ID
	....s ThisItmIDsReal=..GetNotCstByStatusCodes(ThisItmIDs,"^22^25^") //hxy 2021-04-13 st 取非驳回拒绝的会诊ID串(原s的ThisNum未使用)
	....s ThisNum=$case(ThisItmIDsReal,"":0,:$l(ThisItmIDsReal,"!!"))   //完成会诊次数(为了价格的计算) //ed
	....s Number = Number+ThisNum
	....s:ItmIDs'="" ItmIDs=ItmIDs_"!!"_ThisItmIDs   
	....s:ItmIDs="" ItmIDs = ThisItmIDs
	....s:ProvTpItmIDs'="" ProvTpItmIDs = ProvTpItmIDs_"!!"_ThisItmIDs
	....s:ProvTpItmIDs="" ProvTpItmIDs = ThisItmIDs
	....s AllOrdPress =  OrdPrice*ThisNum    //数量*单价
	....s OrdAllPress = OrdAllPress+AllOrdPress
	....s ProvTpNum = ProvTpNum+ThisNum
	....s ProvTpAllPress = ProvTpAllPress+AllOrdPress
	...q:showDetail'="Y"                                 //是否显示明细
	...s CsUserDesc = $p(^SSU("SSUSR",CsUserID),"^",2)   //医生名称
	...q:(CurLoc'="")&&(CurLoc'=ConsLocDesc)
	...s OverTimeItmIDs = ##class(web.DHCEMConsultStatisQuery).GetOverTimeCst(ItmIDs)
	...s OverTimeNumber = $case(OverTimeItmIDs,"":0,:$l(OverTimeItmIDs,"!!"))
	...s RefItms = ##class(web.DHCEMConsultStatisQuery).GetCstByStatusCode(ItmIDs,"25") //拒绝 //hxy 2021-04-06 st
	...s RefNumber = $case(RefItms,"":0,:$l(RefItms,"!!"))
	...s RejItms = ##class(web.DHCEMConsultStatisQuery).GetCstByStatusCode(ItmIDs,"22") //驳回
	...s RejNumber = $case(RejItms,"":0,:$l(RejItms,"!!")) //ed
	...s ItmIDs=..GetNotCstByStatusCodes(ItmIDs,"^22^25^") //hxy 2021-04-13
	...s Count =Count+1		
	...s LangConsLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ConsLocDesc)	
	...s LangCareProvTpDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProvTpDesc)	
	...s LangCsUserDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CsUserDesc)							  
	...s ListData = LangConsLocDesc_"^"_LangCareProvTpDesc_"^"_LangCsUserDesc_"^"_Number_"^"_OrdAllPress_"^"_ItmIDs_"^"_OverTimeNumber_"^"_OverTimeItmIDs
	...s ListData = ListData_"^"_RefNumber_"^"_RefItms_"^"_RejNumber_"^"_RejItms //
	...w $case(Count,1:"",Count:",")                     //显示明细的时候这里输出
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	..q:showDetail="Y"                   				  //是否显示明细
	..q:(CurLoc'="")&&(CurLoc'=ConsLocDesc)  
	..s OverTimeItmIDs = ##class(web.DHCEMConsultStatisQuery).GetOverTimeCst(ProvTpItmIDs)
	..s OverTimeNumber = $case(OverTimeItmIDs,"":0,:$l(OverTimeItmIDs,"!!"))
	..s RefItms = ##class(web.DHCEMConsultStatisQuery).GetCstByStatusCode(ProvTpItmIDs,"25") //hxy 2021-04-06 st
	..s RefNumber = $case(RefItms,"":0,:$l(RefItms,"!!"))
	..s RejItms = ##class(web.DHCEMConsultStatisQuery).GetCstByStatusCode(ProvTpItmIDs,"22")
	..s RejNumber = $case(RejItms,"":0,:$l(RejItms,"!!")) //ed
	..s ProvTpItmIDs=..GetNotCstByStatusCodes(ProvTpItmIDs,"^22^25^") //hxy 2021-04-13 因为s时加了驳回、拒绝(22、25)的记录，需去掉
	..s Count =Count+1
	..s LangConsLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ConsLocDesc)	
	..s LangCareProvTpDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProvTpDesc)			
	..s ListData = LangConsLocDesc_"^"_LangCareProvTpDesc_"^^"_ProvTpNum_"^"_ProvTpAllPress_"^"_ProvTpItmIDs_"^"_OverTimeNumber_"^"_OverTimeItmIDs
	..s ListData = ListData_"^"_RefNumber_"^"_RefItms_"^"_RejNumber_"^"_RejItms //
	..w $case(Count,1:"",Count:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	Q ""
}

/// Creator:qqa
/// Descript:获取超时的会诊
/// Input:会诊Id串
/// w ##class(web.DHCEMConsultStatisQuery).GetOverTimeCst("114||1")
ClassMethod GetOverTimeCst(ItmIDs)
{
	n (ItmIDs)
	s RetItmIDs=""
	s Len = $l(ItmIDs,"!!")
	f i=1:1:Len d
	.s ItmID = $P(ItmIDs,"!!",i)
	.;s OverTimeFlag = ##Class(web.DHCEMConsultStatisQuery).GetCstIsOverTime(ItmID) //hxy 2021-04-03 st
	.;q:OverTimeFlag'=1
	.s OverTime = ##Class(web.DHCEMFindConsult).GetCsOverTime(ItmID)
	.q:OverTime="" //ed
	.s:RetItmIDs'="" RetItmIDs=RetItmIDs_"!!"_ItmID
	.s:RetItmIDs="" RetItmIDs=ItmID
	q RetItmIDs
}

/// w ##class(web.DHCEMConsultStatisQuery).GetCstIsOverTime("288||1")
ClassMethod GetCstIsOverTime(ItmID)
{
	n (ItmID)
	s Ret=""
	s CstID = +ItmID
	s CH = $p(ItmID,"||",2) 
	s CstEmFlag=$p(^DHCEMCON(+CstID),"^",23)   /// 是否加急
	s CsRDate=$p(^DHCEMCON(+CstID),"^",3)      /// 申请日期
	s CsRTime=$p(^DHCEMCON(+CstID),"^",4)      /// 申请时间
	s CmpDate=$p($g(^DHCEMCON(CstID,"I",CH)),"^",16) ///完成日期
	s CmpTime=$p($g(^DHCEMCON(CstID,"I",CH)),"^",17) ///完成时间	
	s:CmpDate="" CmpDate=+$H
	s:CmpTime="" CmpTime=$p($H,",",2)
#;	s LimitDate = +CmpDate-+CsRDate //hxy 2021-03-03 st 注释&add
#;	s LimitTime = +CmpTime-+CsRTime
#;	i CstEmFlag="Y" d
#;	.s:LimitDate>0 Ret=1
#;	.s:(LimitDate=0)&(LimitTime>7200) Ret=1
#;	i CstEmFlag'="Y" d
#;	.s:LimitDate>1 Ret=1
#;	.s:(LimitDate=1)&&(LimitTime>0) Ret=1 //hxy 2020-09-23 < -> >
	s CsPropID = $p(^DHCEMCON(+CstID),"^",45)   /// 会诊性质
	s Hours=24
	i CstEmFlag="Y" s Hours=2
	s HoursConfig=##Class(web.DHCEMConsultQuery).GetHoursConfig(CsPropID,"OVERTIEMHOUR")
	s:+HoursConfig'=0 Hours=HoursConfig
	;s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CmpDate_","_CmpTime) //hxy 2021-03-16 st
	s CstRLocID=$p(^DHCEMCON(+CstID),"^",2) /// 申请科室 
	s HospID=##Class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CstRLocID)
	s OverTimeFilter=##class(web.DHCEMConsultCom).GetEmSysConfig("OVERTIMEFILTER",HospID)
	i (OverTimeFilter=1)!(OverTimeFilter=2) d
	.s SSCut=##Class(web.DHCEMConsultQuery).GetDateDiff(CsRDate,CsRTime,CmpDate,CmpTime,OverTimeFilter)
	e  d
	.s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,CmpDate_","_CmpTime) //ed
	q:SSCut<=0 "" 
	s CrTime=Hours*3600-SSCut
	s:CrTime<0 Ret=1 //ed
	q Ret
}

/// Creator:qqa
/// Descript:会诊统计查询明细
/// Input:会诊ID串
/// w ##class(web.DHCEMConsultStatisQuery).GetConsultDetailList("1","10","69||1")
ClassMethod GetConsultDetailList(page, rows, Params)
{
	n (page,rows,Params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	w:Params="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	q:Params="" ""
	s Count=0
	s ListString  = "CstRLoc^CstRUser^CstLoc^CstRDate^CstRTime^PatName^EpisodeID^CstType^CstID^CstItmID^CmpDate^CmpTime^TypeCode^ArrDate^ArrTime^OverTimeVal"
	s ListString=ListString_"^RefUser^RefRea^RejUser^RejRea^Oeori" //hxy 2021-05-06
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s Len = $l(Params,"!!")
	f i=1:1:Len d
	.s CstItmID = $p(Params,"!!",i)
	.s CstID = +CstItmID
	.s CH = $p(CstItmID,"||",2)
	.;s OneOrMore=$p(^DHCEMCON(CstID),"^",31)
	.;s:OneOrMore'="Y" OneOrMore="N"
	.s CstType = $p(^DHCEMCON(CstID),"^",19)  /// 
	.s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	.s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	.s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CmpDate=$p($g(^DHCEMCON(CstID,"I",CH)),"^",16) 
	.s CmpTime=$p($g(^DHCEMCON(CstID,"I",CH)),"^",17) 
	.s:CmpDate'="" CmpDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CmpDate)
	.s:CmpTime'="" CmpTime = $zt(CmpTime,1)
	.s ArrDate=$p(^DHCEMCON(CstID,"I",CH),"^",18) ///到达日期
	.s ArrTime=$p(^DHCEMCON(CstID,"I",CH),"^",19) ///到达时间
	.s:ArrDate'="" ArrDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)
	.s:ArrTime'="" ArrTime=$zt(ArrTime,1)
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)          /// 医嘱ID
	.i Oeori=""  s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",10)
	.s CstRUser=""
	.s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	.s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	.s CstStatusID=$p(^DHCEMCON(CstID),"^",18)  /// 状态
	.s CstLoc = "" ;##Class(web.DHCEMConsultQuery).GetConsultLoc(CstID,CH)  ///会诊科室
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CstLoc=$p(^CTLOC(CsLocID),"^",2)
	.s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	.s OneOrMore=$p(^DHCEMCON(CstID),"^",31)  /// 是否多科
	.s CstType=""
	.s CstCatDr = $p(^DHCEMCON(CstID),"^",8)
	.s:CstCatDr'="" CstType = $p(^DHCEMCDI(CstCatDr),"^",2)
	.;s:(CstOutFlag'="Y")&(OneOrMore'="Y") CstType="单科院内"
	.;s:(CstOutFlag="Y")&(OneOrMore'="Y") CstType="单科院外"
	.;s:(CstOutFlag'="Y")&(OneOrMore="Y") CstType="多科院内"
	.;s:(CstOutFlag="Y")&(OneOrMore="Y") CstType="多科院外"
	.s EpisodeID=$p(^DHCEMCON(CstID),"^",1)		/// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	.s Count = Count+1
	.s CstRLoc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	.s CstRUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstRUser)
	.s CstLoc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstLoc)
	.s PatName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
	.s CstType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CstType)
	.s TypeCode = $p(^DHCEMCON(CstID),"^",19) //hxy 2020-09-18
	.s OverTimeVal=##Class(web.DHCEMFindConsult).GetCsOverTime(CstID_"||"_CH) //会诊超时时间 hxy 2021-04-03
	.s RefStr=##Class(web.DHCEMConsultCom).GetLogDataByStCode(CstID_"||"_CH,"25") //拒绝 //hxy 2021-05-06 st
	.s RejStr=##Class(web.DHCEMConsultCom).GetLogDataByStCode(CstID_"||"_CH,"22") //驳回
	.s RefUser=$p(RefStr,"^",1),RefRea=$p(RefStr,"^",2)
	.s RejUser=$p(RejStr,"^",1),RejRea=$p(RejStr,"^",2) //ed
	.s ListData = CstRLoc_"^"_CstRUser_"^"_CstLoc_"^"_CstRDate_"^"_CstRTime_"^"_PatName_"^"_EpisodeID_"^"_CstType_"^"_CstID_"^"_CstItmID
	.s ListData = ListData_"^"_CmpDate_"^"_CmpTime_"^"_TypeCode_"^"_ArrDate_"^"_ArrTime_"^"_OverTimeVal_"^"_RefUser_"^"_RefRea_"^"_RejUser_"^"_RejRea_"^"_Oeori //
	.Q:(Count<Start)||(Count>End)
	.;w $case(Count,1:"",Count:",")
	.w $case(Count,Start:"",Count:",") //hxy 2021-06-15
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// w ##class(web.DHCEMConsultStatisQuery).GetOrdPriceByOrd("106||17")
ClassMethod GetOrdPriceByOrd(OrdID)
{
	n (OrdID)
	q:OrdID="" ""
	s OrdPrice = ""
	s ARCIItm = $p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",2)
	s OrdDate = $p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),1)),"^",9)
	s OeoriPrice=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",25)
	s RecLocID=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
    s HospitalID=$p($g(^CTLOC(RecLocID)),"^",22)
	s OrdPrice = ##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIItm,OrdDate,"","","",OeoriPrice,HospitalID,"")
	q OrdPrice
}

/// Creator:hxy
/// CreateDate:  2021-04-06
/// Descript:获取该状态code的会诊Id串
/// Input:会诊Id串
/// w ##class(web.DHCEMConsultStatisQuery).GetCstByStatusCode("114||1")
ClassMethod GetCstByStatusCode(ItmIDs, Code)
{
	n (ItmIDs,Code)
	s RetItmIDs=""
	s Len = $l(ItmIDs,"!!")
	f i=1:1:Len d
	.s ItmID = $P(ItmIDs,"!!",i)
	.s StaID = $p($g(^DHCEMCON(+ItmID,"I",+$p(ItmID,"||",2))),"^",6)
	.q:+StaID=0 
	.s StaCode=$p($g(^DHCEMCONS(+StaID)),"^",1)
	.q:StaCode'=Code
	.s:RetItmIDs'="" RetItmIDs=RetItmIDs_"!!"_ItmID
	.s:RetItmIDs="" RetItmIDs=ItmID
	q RetItmIDs
}

/// Creator:hxy
/// CreateDate:  2021-04-13
/// Descript:获取非该状态code串的会诊Id串
/// Input:会诊Id串
/// w ##class(web.DHCEMConsultStatisQuery).GetNotCstByStatusCodes("114||1","^22^25^")
ClassMethod GetNotCstByStatusCodes(ItmIDs, Codes)
{
	n (ItmIDs,Codes)
	s RetItmIDs=""
	s Len = $l(ItmIDs,"!!")
	f i=1:1:Len d
	.s ItmID = $P(ItmIDs,"!!",i)
	.s StaID = $p($g(^DHCEMCON(+ItmID,"I",+$p(ItmID,"||",2))),"^",6)
	.q:+StaID=0 
	.s StaCode="^"_$p($g(^DHCEMCONS(+StaID)),"^",1)_"^"
	.q:Codes[StaCode
	.s:RetItmIDs'="" RetItmIDs=RetItmIDs_"!!"_ItmID
	.s:RetItmIDs="" RetItmIDs=ItmID
	q RetItmIDs
}

/// Creator:     hxy
/// CreateDate:  2022-07-22
/// Descript:    获取十二个月的会诊数据统计
/// Input:       Params
/// w ##Class(web.DHCEMConsultStatisQuery).GetDataByMon("18881^2022^^^C")
ClassMethod GetDataByMon(Params As %String) As %String
{
	n (Params,%session)
	s LgUserID=$p(Params,"^",1) //登录人
	s Year=$p(Params,"^",2)     //年
	s LocID=$p(Params,"^",3)    //科室
	s Flag=$p(Params,"^",4)     //院内院外标识
	s QryType=$p(Params,"^",5)  //类型 R:按申请; C:按接收
	s LgHospID=$p(Params,"^",8) //医院
	s StDate=$zdh(Year_"-01-01",3)
	s EdDate=$zdh(Year_"-12-31",3)

	k ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",+LgUserID)
	
	F Date=StDate:1:EdDate D
	.s ID=""
	.F  s ID=$o(^DHCEMCON(0,"ReqDateIndex",Date,ID)) Q:ID=""  D
	..Q:$p(^DHCEMCON(ID),"^",18)=""
	..s CstRLocID=$p(^DHCEMCON(ID),"^",2)   /// 申请科室
	..Q:(QryType="R")&(LocID'="")&(LocID'=CstRLocID)
	..s CstOutFlag=$p(^DHCEMCON(ID),"^",24) /// 是否院外
	..Q:(Flag'="")&(Flag'=CstOutFlag)
	..s CurHospID=##Class(web.DHCEMConsultCom).GetPatHospID(ID)
	..Q:(LgHospID'="")&(LgHospID'=CurHospID)
	..s Month=$SYSTEM.SQL.MONTH(Date)
	..s CH=""
	..F  s CH=$o(^DHCEMCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCEMCON(ID,"I",CH),"^",1) /// 会诊科室
	...q:(QryType="C")&(LocID'="")&(LocID'=CsLocID)
	...s:QryType="C" CstRLocID=CsLocID
	...q:CsLocID=""
	...s ConsItmID=ID_"||"_CH
	...s ConCompDate=##Class(web.DHCEMConsultQuery).GetCstNodeTime(ConsItmID,"50") //完成时间
	...q:ConCompDate=""
    ...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,QryType,CstRLocID)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,QryType,CstRLocID))+1
    ...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"COUNT",CstRLocID,Year)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"COUNT",CstRLocID,Year))+1
    ...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTH",CstRLocID,Year,Month)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTH",CstRLocID,Year,Month))+1
    ...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNT",Year,Month)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNT",Year,Month))+1
     
    ...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTHSTR",CstRLocID,Year,Month)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTHSTR",CstRLocID,Year,Month))_"*"_ConsItmID
	...s ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNTSTR",Year,Month)=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNTSTR",Year,Month))_"*"_ConsItmID
	
    s Num=0
    s CstRLocID=""
	f  s CstRLocID=$o(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,QryType,CstRLocID)) q:CstRLocID=""  d
	.s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	.s CstRLoc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)	
    .s countData="",DataStr="",monthStr=""
	.f month=1:1:12 d
	..s monthData=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTH",CstRLocID,Year,month))
	..s:monthData="" monthData="0"
	..s countData=$s(countData="":monthData,1:countData_"^"_monthData)
	.s count=$g( ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"COUNT",CstRLocID,Year))
	.s:count="" count="0"
	.s countData=countData_"^"_count
	.s DataStr=$s(DataStr="":countData,1:DataStr_"^"_countData)
	.
	.f month=1:1:12 d
	..s monData=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"MONTHSTR",CstRLocID,Year,month))
	..s monthStr=$s(month=1:monData,1:monthStr_"^"_monData)
	.
	.s Num=Num+1
	.s ListData=CstRLoc_"^"_DataStr_"^"_monthStr
	.s TMPListData(Num)=ListData
	
	
	S EMonStr="",AllTotle=0
	f month=1:1:12 d     //获取总合计
	.s EMonData=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNT",Year,month))
	.s:EMonData="" EMonData="0"
	.s AllTotle=AllTotle+EMonData
	.s EMonStr=$s(EMonStr="":EMonData,1:EMonStr_"^"_EMonData)
	s Str=""
	f month=1:1:12 d
	.s Data=$g(^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",LgUserID,"AllCOUNTSTR",Year,month))
	.s Str=$s(month=1:Data,1:Str_"^"_Data)
	s TMPListData(Num+1)=##class(websys.Translation).Get("dhcem.consultstatbymon.csp","合计")_"^"_EMonStr_"^"_AllTotle_"^"_Str
	
	///转换数据为Json格式
	s ListTitle="CstRLoc^OneMonNum^TwoMonNum^ThreeMonNum^FourMonNum^FiveMonNum^SixMonNum^SevenMonNum^EightMonNum^NineMonNum^TenMonNum^ElevenMonNum^TwelveMonNum^TotleNum"
	s ListTitle=ListTitle_"^OneMon^TwoMon^ThreeMon^FourMon^FiveMon^SixMon^SevenMon^EightMon^NineMon^TenMon^ElevenMon^TwelveMon"
    W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num+1) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index)) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.i count=1 D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	
	k ^TMP("DHCCON","web.DHCEMConsultStatisQuery","GetDataByMon",+LgUserID)

	Q ""
}

/// Creator:hxy
/// Descript:会诊统计查询明细
/// Input:会诊ID串
/// w ##class(web.DHCEMConsultStatisQuery).GetDetail("1","10","*23||1*24||1*24||2*25||1*28||1*29||1*30||1*31||1*32||1*35||1*37||1*41||1*45||1*47||1*53||1*54||1*54||2*55||1*55||2*56||1*56||2*62||1*66||1^R")
ClassMethod GetDetail(page, rows, Params)
{
	n (page,rows,Params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	s staType=$p(Params,"^",2)
	s Params=$p(Params,"^",1)
	w:Params="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:Params="" ""
	k TMPDetail
	
	s Len = $l(Params,"*")
	f i=1:1:Len d
	.s CstItmID = $p(Params,"*",i)
	.q:CstItmID=""
	.s CstID = +CstItmID
	.s CH = $p(CstItmID,"||",2)
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)        /// 申请科室
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)   /// 会诊科室
	.s:staType="R" CstRLocID=CsLocID
	.i $d(TMPDetail("Num",CstRLocID)) d
	..s TMPDetail("Num",CstRLocID) = TMPDetail("Num",CstRLocID)+1
	..s TMPDetail("Itm",CstRLocID) = TMPDetail("Itm",CstRLocID)_"*"_CstItmID
	.e  d
	..s TMPDetail("Num",CstRLocID) = 1
	..s TMPDetail("Itm",CstRLocID) = CstItmID

	s Count=0
	s ListString  = "Loc^Num^ItmStr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s LocDr=""     //发送和接收的时候取的不一样
	f  s LocDr = $o(TMPDetail("Num",LocDr)) q:LocDr=""  d
	.s Loc=$p($g(^CTLOC(+LocDr)),"^",2)
	.s Loc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",Loc)
	.s Num=TMPDetail("Num",LocDr)
	.s ItmStr=TMPDetail("Itm",LocDr)
	.s Count =Count+1		
	.s ListData = Loc_"^"_Num_"^"_ItmStr
	.w $case(Count,1:"",Count:",")                     //显示明细的时候这里输出
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	
	k TMPDetail
	q ""
}

/// Creator:hxy
/// Descript:会诊统计查询明细
/// Input:会诊ID串
/// w ##class(web.DHCEMConsultQuery).GetPatDetail("1","10","32420||1*32594||1")
ClassMethod GetPatDetail(page, rows, Params)
{
	n (page,rows,Params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	w:Params="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	q:Params="" ""
	s Count=0
	s ListString  = "PatNo^PatName^CstRDate^CstRUser^CstCDate^CstUser^Opinion"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s Len = $l(Params,"*")
	f i=1:1:Len d
	.s CstItmID = $p(Params,"*",i)
	.s CstID = +CstItmID
	.s CH = $p(CstItmID,"||",2)
	.s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号	
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	.s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	.s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	.s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	.s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	.s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	.s CstRUser="",CstUser=""
	.s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	.s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	.s CstRUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",CstRUser)
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)     /// 医生
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)   /// 医生
	.s:CareProvID'="" CstUser=$p(^CTPCP(CareProvID,1),"^",2)
	.s CstUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",CstUser)
	.s TreMeasures=$p(^DHCEMCON(CstID),"^",17)   /// 最终治疗措施
	.s Opinion=$p($g(^DHCEMCON(CstID,"I",CH)),"^",4)    /// 会诊意见
	.i Opinion="" s Opinion=TreMeasures
	.s Count = Count+1
	.s ListData = PatNo_"^"_PatName_"^"_CstRDate_"^"_CstRUser_"^"_CstNDate_"^"_CstUser_"^"_Opinion
	.Q:(Count<Start)||(Count>End)
	.w $case(Count,Start:"",Count:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

Storage Default
{
<Data name="DHCEMConsultStatisQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMConsultStatisQueryD</DataLocation>
<DefaultData>DHCEMConsultStatisQueryDefaultData</DefaultData>
<IdLocation>^web.DHCEMConsultStatisQueryD</IdLocation>
<IndexLocation>^web.DHCEMConsultStatisQueryI</IndexLocation>
<StreamLocation>^web.DHCEMConsultStatisQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
