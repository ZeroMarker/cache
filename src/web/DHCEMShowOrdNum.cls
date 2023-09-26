Class web.DHCEMShowOrdNum Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 获取已经执行的医嘱信息
/// d ##class(web.DHCEMShowOrdNum).JsonListOrdDetail("1","20","2018-10-10","2018-10-10","266","")
ClassMethod JsonListOrdDetail(page As %String, rows As %String, stDate, endDate, lgParams, ordType, Params)
{
	n (page, rows,stDate ,endDate ,lgParams,ordType,Params,%session)
	s SaveMedNo=""
	s Count=0,Del=""""
	q:stDate="" ""
	q:endDate="" ""
	s locID=$p(lgParams,"^",2)
	s RegNoHtml=$p(Params,"^",1)
	s ExeNurHtml=$p(Params,"^",2)
	s ArcDescHtml=$p(Params,"^",3)
	s stDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
	s endDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
	s Start=page-1*rows+1
	s End=page*rows
	s repid=$i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid)
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s DataStr="ExecDate^ExecTime^ExecUser^AdmType^ArciName^PatName^RegNo^PatSex^PatAge^CTPCPCareDesc"
	f Date=stDate:1:endDate d
	.s Ord=""
	.f  s Ord= $o(^OEORDi(0,"DateExecute",Date,Ord)) q:Ord=""  d  //,{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub}
	..
	..s AdmDr = $p(^OEORD(Ord),"^",1)
	..q:$p(^PAADM(AdmDr),"^",20)'="A"
	..q:($p(^PAADM(AdmDr),"^",2)'="E")&($p(^PAADM(AdmDr),"^",2)'="O")  //退出的条件是不是急诊和门诊
	..q:(##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmDr))'=($p(lgParams,"^",1)) //hxy 2020-06-16 区分院区
	..s PatDr = $p(^PAADM(AdmDr),"^",1)
	..s Itm=""
	..f  s Itm = $o(^OEORDi(0,"DateExecute",Date,Ord,Itm)) q:Itm=""  d
	...s Sub=""
	...f  s Sub = $o(^OEORDi(0,"DateExecute",Date,Ord,Itm,Sub)) q:Sub=""  d   //这里遍历出当天执行的所有医嘱
	....s ExecStatusID=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",16) //执行状态
	....s ExecStatusCode=""
    ....s:ExecStatusID'="" ExecStatusCode=$p($g(^OEC("STAT",ExecStatusID)),"^",1)
    ....q:ExecStatusCode'="F"								  //执行状态
	....s ExecDate = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",19)   //执行日期
	....s ExecTime = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",20)	  //执行时间
	....s ExecDateDesc = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ExecDate)
	....s ExecTimeDesc = $zt(ExecTime,2)
	....s ExecUser = ##class(web.DHCEMShowOrdNum).GetExecUser(Ord,Itm,Sub)  //执行人
	....q:(ExeNurHtml'="")&&(ExecUser'[ExeNurHtml)
	....s ExecLocInfo = ##class(web.DHCEMShowOrdNum).GetAllLoginLoc(Ord,Itm,Sub) ;##class(web.DHCEMShowOrdNum).GetExecLocInfo(Ord,Itm,Sub)  //执行人所在科室,这里判断包含
	....q:ExecLocInfo'[locID
	....s AdmType=$p(^PAADM(AdmDr),"^",2)                     //就诊类型
	....;q:(AdmType'="")&(LocTypeDesc'=AdmType)
	....s ArciName = ##class(web.DHCEMOrdInfoVO).getArcimDesc(Ord,Itm)   //  医嘱名称
	....q:(ArcDescHtml'="")&&(ArciName'[ArcDescHtml)
	....s PatInfo = ##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,$p(lgParams,"^",1)) //hxy 2020-06-16 $p(lgParams,"^"),1
	....s PatName = $p(PatInfo,"^",2)
	....s RegNo = $p(PatInfo,"^",1)
	....q:(RegNoHtml'="")&&(RegNoHtml'=RegNo)
	....s PatSex = $p(PatInfo,"^",3)
	....s PatAge = $p(PatInfo,"^",4)
	....s TypeOrd = ##class(web.DHCEMShowOrdNum).GetOrdTypeByOEORIID(repid,Ord,Itm,Sub,PatDr,lgParams)
	....;s RecLocInfo = ##class(web.MyInterfaceMethod).GetReclocDesc(Ord,Itm)
	....;q:(locID'="")&&(+RecLocInfo'=locID)
	....s CTPCPCareDesc=""
	....s CTPCPCareInfo = ##class(web.DHCEMInComUseMethod).GetRegMark(AdmDr)  
	....s CTPCPCareDesc = $p(CTPCPCareInfo,"^",1)
	....q:(ordType'="")&&(TypeOrd'[ordType)
	....s Data = ExecDateDesc_"^"_ExecTimeDesc_"^"_ExecUser_"^"_AdmType_"^"_ArciName_"^"_PatName_"^"_RegNo_"^"_PatSex_"^"_PatAge_"^"_CTPCPCareDesc
	....s Count=Count+1
	....q:Count<Start
	....q:Count>End
	....w $case(Count,Start:"",:",")
	....w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,Data)
	....
	B ;ERR	
	s Date ="",retDate="0^0^0^0^0^0^0^0^0"
	f  s Date = $o(^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,Date)) q:Date=""  d
	.s ExecType="" 
	.f  s ExecType = $o(^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,Date,ExecType)) q:ExecType=""  d
	..s PatDr=""
	..f  s PatDr=  $o(^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,Date,ExecType,PatDr)) q:PatDr=""  d
	...s:ExecType="SYDO" $p(retDate,"^",1) =  $p(retDate,"^",1)+1
	...s:ExecType="ZSDO" $p(retDate,"^",2) =  $p(retDate,"^",2)+1
	...s:ExecType="PSDO" $p(retDate,"^",3) =  $p(retDate,"^",3)+1
	...s:ExecType="ZLDO" $p(retDate,"^",4) =  $p(retDate,"^",4)+1
	...s:ExecType="JYDO" $p(retDate,"^",5) =  $p(retDate,"^",5)+1
	...s:ExecType="JCDO" $p(retDate,"^",6) =  $p(retDate,"^",6)+1
	...s:ExecType="ECCC" $p(retDate,"^",7) =  $p(retDate,"^",7)+1
	...s:ExecType="XDT" $p(retDate,"^",8) =  $p(retDate,"^",8)+1
	...s:ExecType="JYDXQ" $p(retDate,"^",9) =  $p(retDate,"^",9)+1
	 w "]"
	 w ","_del_"number"_del_":"_del_retDate_del
	 w ","_del_"total"_del_":"_Count
	 w "}"
	 k ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid)
	 q ""
}

/// 返回类型值
ClassMethod GetOrdTypeByOEORIID(repid, Ord, Itm, Sub, PatDr, lgParams)
{
	n (repid,Ord,Itm,Sub,PatDr,lgParams)
	s ExecDate = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",19)
	s PhcinDesc = ##class(web.DHCEMOrdInfoVO).getPhcinDesc(Ord,Itm)
	s OrdType=##class(web.DHCEMShowOrdNum).GetOECCatByOEORDItmDr(Ord_"||"_Itm)
	s ArciName = ##class(web.DHCEMOrdInfoVO).getArcimDesc(Ord,Itm)
	s ArciCatDesc = ##class(web.DHCEMShowOrdNum).GetARCICatByOEORDItmDr(Ord_"||"_Itm)
	s ExecType="" 
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"SYDO",Ord,Itm,"Temp","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"SYDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"SYDO"
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"ZSDO",Ord,Itm,"Temp","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"ZSDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"ZSDO"
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"PSDO",Ord,Itm,"Exec","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"PSDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"PSDO"
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"ZLDO",Ord,Itm,"Temp","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"ZLDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"ZLDO"
	b ;err1
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"JYDO",Ord,Itm,"Temp","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"JYDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"JYDO"
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"JCDMZ",Ord,Itm,"Exec","true","false") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"JCDO",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"JCDO"
	
	i ##class(web.DHCEMNurExe).CheckCon(lgParams,"JYDXQ",Ord,Itm,"Temp","false","true") d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"JYDXQ",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"JYDXQ"
	
	i ArciCatDesc["心电图" d 
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"XDT",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"XDT"
	
	i $p($g(^OEORD(Ord,"I",Itm,"X",Sub,"NUR")),"^",27)'="" d
	.s ^TMP("DHCEM","web.DHCEMShowOrdNum","JsonListOrdDetail",repid,ExecDate,"ECCC",PatDr)=""
	.s ExecType=ExecType_$case(ExecType,"":"",:",")_"ECCC"

	q ExecType
}

ClassMethod GetExecUser(Ord, Itm, Sub)
{
	n (Ord,Itm,Sub,%session)
	s execCTPCP=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",15)
	s execCtcpDesc=""
    s:execCTPCP'="" execCtcpDesc=$p($g(^CTPCP(execCTPCP,1)),"^",2)	//执行科室描述	
    s execCtcpDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",execCtcpDesc) //hxy 2022-12-13
    q execCtcpDesc
}

/// d ##class(web.DHCEMShowOrdNum).GetExecLocInfo(Ord,Itm,Sub)
ClassMethod GetExecLocInfo(Ord, Itm, Sub)
{
	n (Ord,Itm,Sub)
	s retLoc=""
	s execCTPCP=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",15)
	q:execCTPCP="" ""
	s loc =""
	f  s loc=$o(^RB("RES",0,"CTPCP",execCTPCP,loc)) q:loc=""  d
	.s rbResID = $o(^RB("RES",0,"CTPCP",execCTPCP,loc,""))
	.s activeFromDate = $p(^RB("RES",rbResID),"^",22)
	.s activeToDate = $p(^RB("RES",rbResID),"^",23)
	.q:activeFromDate=""
	.q:+$h<activeFromDate
	.q:(activeToDate'="")&&(+$h>activeToDate)
	.s:retLoc'="" retLoc = retLoc_"^"_loc
	.s:retLoc="" retLoc = loc
	q retLoc
}

/// d ##class(web.DHCEMShowOrdNum).GetAllLoginLoc(Ord,Itm,Sub)
ClassMethod GetAllLoginLoc(Ord, Itm, Sub)
{
	n (Ord,Itm,Sub)
	s retLoc=""
	s CareProvID=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",15)
	q:CareProvID="" ""
	s OTHLLParRef=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s ChildSub=0
	f  s ChildSub=$o(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)) q:ChildSub=""  d
	.s OTHLLocId=$p(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub),"^",1)
	.s:retLoc'="" retLoc = retLoc_"^"_OTHLLocId
	.s:retLoc="" retLoc = OTHLLocId
	q retLoc
}

/// 通过医嘱子ID获取医嘱大类类别
/// w ##class(web.DHCEMShowOrdNum).GetOECCatByOEORDItmDr("410||5")
ClassMethod GetOECCatByOEORDItmDr(OEORIDr)
{
	n (OEORIDr)
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q:ArcimID="" ""
	s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	s OECCatDr = $p(^ARC("IC",ARCICatDr),"^",8)
	s OECCatDesc = $p(^OEC("ORCAT",OECCatDr),"^",2)
	q OECCatDesc
}

/// 通过医嘱子ID获取医嘱子类类别
/// w ##class(web.DHCEMShowOrdNum).GetARCICatByOEORDItmDr("6288||5")
ClassMethod GetARCICatByOEORDItmDr(OEORIDrStr)
{
	n (OEORIDrStr)
	s ret=""
	q:OEORIDrStr="" ret    //sufan 2018-03-08 医嘱ID为空时，返回空
	s Len = $l(OEORIDrStr,",")
	f i=1:1:Len d
	.s OEORIDr = $p(OEORIDrStr,",",i)
	.s Ord = +OEORIDr
	.s Itm = $p(OEORIDr,"||",2)
	.s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	.q:ArcimID="" 
	.s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	.s ARCICatDesc = $p(^ARC("IC",ARCICatDr),"^",2)
	.s:ret'="" ret=ret_"#"_ARCICatDr_"^"_ARCICatDesc
	.s:ret="" ret=ARCICatDr_"^"_ARCICatDesc
	q ret
}

}
