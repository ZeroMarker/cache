Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-01-04
/// Descript: 	会诊申请公共类
Class web.DHCEMConsultCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:	职称
/// w ##Class(web.DHCEMConsultCom).JsonPrvTp("DOC^PHA")
ClassMethod JsonPrvTp(Type As %String, LgHospID = "") As %String
{
	n (Type,LgHospID,%session)
	s EndSqlStr=""
	s Len=$l(Type,"^")
	f i=1:1:Len d
	.s ItmType=$p(Type,"^",i)
	.s:EndSqlStr'="" EndSqlStr=EndSqlStr_"OR UPPER(CTCPT_InternalType) LIKE """_""_ItmType_""_"%"_""_""" "
	.s:EndSqlStr="" EndSqlStr=" UPPER(CTCPT_InternalType) LIKE """_""_ItmType_""_"%"_""_""" "
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId ,CTCPT_Desc FROM CT_CarPrvTp"
	s sqlStr=sqlStr_" WHERE "_EndSqlStr
	
	s NotPrvTp=##Class(web.DHCEMConsultCom).GetEmSysConfig("CANNOTACCPRVTP",LgHospID)
	s:NotPrvTp'="" NotPrvTp=","_NotPrvTp_","
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CTCPT_RowId")
		s Desc = result.Data("CTCPT_Desc")
		Continue:Desc=""
		Continue:(NotPrvTp'="")&(NotPrvTp[(","_Desc_",")) //hxy 2022-09-05
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",Desc)
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	科室
/// w ##Class(web.DHCEMConsultCom).JsonLoc(2)
ClassMethod JsonLoc(q As %String = "", HospID As %String) As %String
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
		;continue:(HospID'="")&(HospID'=$p(^CTLOC(locDr),"^",22)) //hxy 2020-05-28 注释
		continue:$p(^CTLOC(locDr),"^",14)'="Y" //hxy 2023-04-10
		continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",locDr,HospID)'="Y" //hxy 2020-05-28
		continue:(locDesc["停")||(locDesc["工作量")
		s locDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",locDesc)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
	
#;	s count=0
#;	w "["
#;	s LocDr=""
#;	f  s LocDr=$o(^CTLOC(0,"LocType","E",LocDr)) q:LocDr=""  d
#;	.Q:$d(^CTLOC(LocDr))=0
#;	.s DateFrom=$p(^CTLOC(LocDr),"^",24)
#;	.s DateTo=$p(^CTLOC(LocDr),"^",25)
#;	.Q:(DateFrom>+$H)&(DateFrom'="")
#;	.Q:(DateTo<+$H)&(DateTo'="")
#;	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
#;	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
#;	.s tmp=LocDr_"^"_LocDesc
#;	.s count = count+1
#;	.I count=1 d
#;	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
#;	.e  d
#;	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
#;	w "]"
#;	q ""
}

/// Descritp:	医生
/// w ##Class(web.DHCEMConsultCom).JsonLocCareProv("",71,"","","")
ClassMethod JsonLocCareProv(q = "", LocID As %String, PrvTpID As %String, ProvType As %String, LgUserID As %String) As %String
{
	n (q, LocID, PrvTpID, ProvType, LgUserID,%session)
	s count=0
	s ProvType=$zcvt(ProvType,"U")
	s ProvType=$s(ProvType["NUR":"NURSE",1:"DOCTOR")
	w "["
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.Q:$p(^CT("CPT",ProvTypeID),"^",3)'="Y"
	.s ThisProvType = $p(^CT("CPT",ProvTypeID),"^",4)
	.Q:(ProvType="NURSE")&&(ThisProvType'="NURSE") //"DOCTOR"
	.Q:(ProvType="DOCTOR")&&(ThisProvType'="DOCTOR")&&(ThisProvType'="Pharmacist")  ///药师
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s RESRowId=$o(^RB("RES",0,"CTPCP",CareProvID,LocID,"")) //hxy 2022-09-08 demo-科室关联医护人员配置结束日期过期屏蔽 st
	..s RESDateFrom=$p($g(^RB("RES",+RESRowId)),"^",22)
	..s RESDateTo=$p($g(^RB("RES",+RESRowId)),"^",23)
	..q:(RESDateFrom'="")&&(+$h<RESDateFrom)
	..q:(RESDateTo'="")&&(+$h>RESDateTo) //ed
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..s DateFrom=$p(^SSU("SSUSR",UserID),"^",96) //hxy 2021-04-13 st 用户过期无法登陆
	..s DateTo=$p(^SSU("SSUSR",UserID),"^",97)
	..q:(DateFrom'="")&&(+$h<DateFrom)
	..q:(DateTo'="")&&(+$h>DateTo) //ed
	..Q:(LgUserID'="")&(LgUserID=UserID)
	..s otherFlag=..GetUserOtherLoc(UserID,LocID)
	..Q:(LocID="")||(($p(^SSU("SSUSR",UserID),"^",4)'=LocID)&(otherFlag'=1))
	..s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	..Q:$p(^CTPCP(CareProvID,1),"^",9)'="Y"
	..s CareStDate=$p(^CTPCP(CareProvID,2),"^",14)
	..s CareEndDate=$p(^CTPCP(CareProvID,2),"^",15)
	..q:(CareStDate>+$h)
	..q:(CareEndDate'="")&&(CareEndDate<+$h)
	..q:(PrvTpID'="")&&(CTPCPCTId'=PrvTpID)
	..s UserName=$p(^CTPCP(CareProvID,1),"^",2)
	..Q:UserName'[q
	..s UserName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",UserName)
	..s tmp=CareProvID_"^"_UserName
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descritp:	用户的其他登录科室
/// w ##Class(web.DHCEMConsultCom).GetUserOtherLoc("","")
ClassMethod GetUserOtherLoc(userid As %String, mLocID As %String) As %String
{
	n (userid, mLocID)
	s othusr="0",quitflag=0
	f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")||(quitflag=1)  d
	.s LocID=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	.Q:mLocID'=LocID
	.s OtherStDate=$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",4) //hxy 2022-09-08 st demo-用户-其他登录科室的结束日期过期屏蔽
	.s OtherEndDate=$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",5)
	.q:(OtherStDate>+$h)
	.q:(OtherEndDate'="")&&(OtherEndDate<+$h) //ed
	.s quitflag=1
	.
	Q quitflag
}

/// Descritp:	获取系统当前日期
/// w ##Class(web.DHCEMConsultCom).GetCurSystemDate(2)
ClassMethod GetCurSystemDate(offset As %String) As %String
{
	n (offset)
	s SystemDate=+$H+offset
	s SystemDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SystemDate)
	Q SystemDate
}

/// Descritp:	会诊状态表
/// w ##Class(web.DHCEMConsultCom).JsonConsStatus()
ClassMethod JsonConsStatus() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ECS_RowID ,ECS_Desc FROM DHC_EmConsStatus"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("ECS_RowID")
		s Desc = result.Data("ECS_Desc")
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	用户
/// w ##Class(web.DHCEMConsultCom).JsonUser("")
ClassMethod JsonUser(q As %String, HospID, Type = "") As %String
{
	n (q, HospID,Type)
	s input=q 
	//s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT SSUSR_RowId, SSUSR_Name FROM SS_USER"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE SSUSR_Name LIKE """_"%"_input_"%"""_" "_"or SSUSR_Initials like """_"%"_input_"%"_""""
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s UserID = result.Data("SSUSR_RowId")
		s User = result.Data("SSUSR_Name")
	    continue:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,HospID)'="Y" //hxy 2020-05-28
	   	s DateFrom=$p(^SSU("SSUSR",UserID),"^",96) //hxy 2022-10-09 st 用户过期无法登陆
		s DateTo=$p(^SSU("SSUSR",UserID),"^",97)
		continue:(DateFrom'="")&&(+$h<DateFrom)
		continue:(DateTo'="")&&(+$h>DateTo) //ed
		continue:$p(^SSU("SSUSR",UserID),"^",19)'="Y" //hxy 2022-10-09 用户未激活
	    s CareProvID=$p($g(^SSU("SSUSR",+UserID)),"^",14) //hxy 2021-06-28 st
	    s PrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)
	    s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",4)
	    continue:(Type="NUR")&(PrvTp'="NURSE")
	    continue:(Type="DOC")&(PrvTp'="DOCTOR")&(PrvTp'="Pharmacist") //ed
		s tmp=UserID_"^"_User
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	医生
/// w ##Class(web.DHCEMConsultCom).JsonLocUser(333)
ClassMethod JsonLocUser(q As %String, LocID As %String, Type As %String = "", HospID = "") As %String
{
	n (q, LocID, Type,HospID)
	s input=q 
	s input=$ZCVT(input,"U")
	s count=0
	w "["
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.Q:$p(^CT("CPT",ProvTypeID),"^",3)'="Y"
	.Q:(Type="")&($p(^CT("CPT",ProvTypeID),"^",4)'="DOCTOR")
	.Q:(Type'="")&($p(^CT("CPT",ProvTypeID),"^",4)'=Type)
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..s DateFrom=$p(^SSU("SSUSR",UserID),"^",96)
	..s DateTo=$p(^SSU("SSUSR",UserID),"^",97)
	..q:(DateFrom'="")&&(+$H<DateFrom)
	..q:(DateTo'="")&&(+$H>DateTo)
	..Q:'$D(^RB("RES",0,"CTPCP",CareProvID,LocID))
	..Q:(HospID'="")&(##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,HospID)'="Y") //hxy 2020-05-28
	..s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	..s UserCode=$p(^CTPCP(CareProvID,1),"^",1)
	..s UserName=$p(^CTPCP(CareProvID,1),"^",2)
	..Q:($ZCVT(UserCode,"U")'[input)&($ZCVT(UserName,"U")'[input)
	..s tmp=UserID_"^"_UserName
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descript:获取诊断字典信息
/// W ##class(web.DHCEMConsultCom).GetMRCICDDx("2","1","")
ClassMethod GetMRCICDDx(rows As %String, page As %String, q As %String)
{
	n (rows,page,q)
	s EndPage=page*rows        //结束行
	s StPage=((page-1)*rows)+1 //开始行
	k TMPMRCArr
	s Num=0, MRCID=0 
    F  s MRCID=$o(^MRC("ID",MRCID)) Q:MRCID=""  D
    .s MRCCode=$p(^MRC("ID",MRCID),"^",1)  //代码
    .s MRCDesc=$p(^MRC("ID",MRCID),"^",2)  //描述
    .Q:MRCDesc'[q
	.s Num=Num+1
	.s TMPMRCArr(Num)=MRCID_"^"_MRCCode_"^"_MRCDesc

	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出空的json串
	Q:Num=0 ""
	
	s Title="MRCID^MRCCode^MRCDesc"
	s maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s Num=0
	s index=""
	F  S index=$o(TMPMRCArr(index)) Q:(index="")||(quitflag=1)  D
	.s mdata=$g(TMPMRCArr(index))
	.s Num=Num+1
	.Q:Num<StPage
	.s:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(Title,mdata)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	k TMPMRCArr
	Q ""
}

/// Descript:获取会诊类型字典
/// W ##class(web.DHCEMConsultCom).JsonCstType("12177","2","")
ClassMethod JsonCstType(LgUserID As %String, HospID As %String, CsRType As %String, PatType = "") As %String
{
	n (LgUserID, HospID, CsRType,PatType,%session)
#;	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4("CYT"),HospID,""))
#;	i mID="" w "[]"
#;	Q:mID=""
	s count=0
	w "["
	s HospDr=""
	F  s HospDr=$o(^DHCEMCDT(0,"Code","CYT",HospDr)) Q:HospDr=""  D
	.;q:HospID'=HospDr //hxy 2020-05-29 //hxy 2021-05-31 注释 st
	.q:##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID)'=HospDr //add ed
	.s mID=+$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4("CYT"),HospDr,""))
	.s itmID=""
	.F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	..Q:$p(^DHCEMCDI(itmID),"^",3)'="Y"
	..s PatTypeAut=##Class(web.DHCEMConsultQuery).GetHoursConfig(itmID,"AUT") //hxy 2021-03-02 st
	..q:(CsRType'="")&(PatType'="")&(PatTypeAut'="")&(PatTypeAut'[PatType)&('$d(^DHCEMCDA(0,"HospUser",HospID,LgUserID))) //ed
	..Q:(CsRType'="")&('$D(^DHCEMCDA(0,"User",LgUserID,itmID)))&($D(^DHCEMCDA(0,"User",LgUserID)))&($d(^DHCEMCDA(0,"HospUser",HospID,LgUserID))) //hxy 2020-06-10 add &"HospUser"
	..Q:(CsRType'="")&(($d(^DHCEMCDA(0,"HospUser",HospID,LgUserID)))&(##class(web.DHCEMConsDocAut).getID(LgUserID,itmID,HospID)="")) //hxy 2021-06-02 多院区
	..s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	..Q:itmCode'[CsRType
	..s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	..q:itmDesc["无权限"
	..s itmDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",itmDesc)
	..s tmp=itmID_"^"_itmDesc_"^"_itmCode
	..s count = count+1
	..I count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
	..E  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
	w "]"
	Q ""
}

/// Creator:    QQA
/// CreateDate: 2018-06-27
/// Descript:	
/// InPut:      
/// OutPut:     所有科室
/// w ##class(web.DHCEMConsultCom).QryEmConsLoc("")
ClassMethod QryEmConsLoc(HospID As %String, q As %String)
{
	n (HospID,q)
	s Count = 0
	w "["
	s Count = Count+1
	W ##class(web.DHCAPPJsonCommon).getJsonData("value^text","ALL^全院通用")
	//W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text","DF^默认医嘱")
	s LocID=0
	f  s LocID = $o(^CTLOC(LocID)) q:LocID=""  d
	.;s HospDr=$p($g(^CTLOC(+LocID)),"^",22) //hxy 2019-11-27 st //hxy 2020-05-28 st
	.;q:HospDr'=HospID //ed
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y" //ed
	.s LocDesc = $p(^CTLOC(LocID),"^",2)
	.s LocCode = $p(^CTLOC(LocID),"^",43)
	.s LocCode = $ZCVT(LocCode,"U")   	//add sufan 2019-02-13  
	.s LocAllDesc = LocCode_LocDesc
	.q:(q'="")&&(LocAllDesc'[$$ALPHAUP^SSUTIL4(q))
	.s Count = Count+1
	.s Tmp=LocID_"^"_LocDesc
	.i Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Creator:    hxy
/// CreateDate: 2020-09-22
/// Descript:	取医生、护士会诊列表科室
/// InPut:      医院ID
/// OutPut:     所有科室
/// w ##class(web.DHCEMConsultCom).QryEmConsLocNew("2","")
ClassMethod QryEmConsLocNew(HospID As %String, q As %String)
{
	n (HospID,q)
	s Count = 0
	w "["
	s Count = Count+1
	W ##class(web.DHCAPPJsonCommon).getJsonData("value^text","ALL^全院通用")
	s Count= ..JsonLocListByType(q,HospID,"CONSULT",Count)
	d ..JsonLocListByType(q,HospID,"CONSULTWARD",Count)
	w "]"
	q ""
}

/// Creator:    hxy
/// CreateDate: 2020-09-22
/// Descritp:	关联科室列表
/// w ##Class(web.DHCEMConsultCom).JsonLocListByType("","2","CONSULT","0")
ClassMethod JsonLocListByType(q As %String = "", HospID As %String, LType As %String, CountNow As %String) As %String
{
	n (q, HospID, LType, CountNow)
	s input=$ZCVT(q,"U")
	s count=CountNow
	s ParRef=$o(^CT("LL",0,"Code",LType,""))
	s CH=0
	F  s CH=$o(^CT("LL",ParRef,"LOC",CH)) Q:CH=""  D
	.s LocDr=$P($g(^CT("LL",ParRef,"LOC",CH)),"^",1)
	.s DateFrom=$p(^CTLOC(LocDr),"^",24)
	.s DateTo=$p(^CTLOC(LocDr),"^",25)
	.Q:(DateFrom>+$H)&(DateFrom'="")
	.Q:(DateTo<+$H)&(DateTo'="")
	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s ContactName = $p(^CTLOC(LocDr),"^",43)
	.s ContactName = $ZCVT(ContactName,"U")   	//add sufan 2019-02-13  
	.Q:(input'="")&(LocDesc'[input)&(ContactName'[input)
	.Q:(HospID'="")&(HospID'=$P(^CT("LL",ParRef,"LOC",CH),"^",2))
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	q count
}

/// Descritp:	职称
/// w ##Class(web.DHCEMConsultCom).JsonPrvTp()
ClassMethod JsonPrvTpBak() As %String
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
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator:    QQA
/// CreateDate: 2018-06-27
/// Descript:	
/// InPut:      
/// OutPut:     所有科室
/// w ##class(web.DHCEMConsultCom).QryEmConsArci("2")
ClassMethod QryEmConsArci(HospID As %String, q As %String)
{
	n (HospID,q)
	s Count = 0
	;s HospID="#"_HospID_"#" //hxy 2019-12-24 //hxy 2020-05-28 注释
	
	w "["
	s ArciID=0
	f  s ArciID =$o(^ARCIM(ArciID)) q:ArciID=""  d
	.s ArciSub=0
	.f  s ArciSub =$o(^ARCIM(ArciID,ArciSub)) q:ArciSub=""  d
	..q:'$d(^ARCIM(ArciID,ArciSub,1)) //hxy 2019-01-03 不是所有的医嘱项都会有描述，他错吾弃之
	..s EndDate=$p(^ARCIM(ArciID,ArciSub,1),"^",13)
	..s:EndDate'="" EndDate=$p(EndDate,"Z",1)
	..s EndDateTo=$p($g(^ARCIM(+ArciID,+ArciSub,7)),"^",1) //hxy 2021-02-05 +$g
	..q:(EndDate'="")&&(+$H<EndDate)
	..q:(EndDateTo'="")&&(+$H>EndDateTo)
	..s ArciDesc = $p(^ARCIM(ArciID,ArciSub,1),"^",2)
	..Q:ArciDesc'["会诊" //hxy 2019-12-25 上移此过滤
	..;s HospStr=..GetArciHosp(ArciID,ArciSub) //hxy 2019-12-24 //2020-05-28 注释
	..;q:(HospID'="##")&(HospStr'[HospID) //hxy 2019-12-24
	..;q:(HospID'="##")&(HospStr'[HospID)&(HospStr'="#") //hxy 2019-12-25 医嘱项未配置医院关联时，显示 //2020-05-28 注释
	..q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("ARC_ItmMast",ArciID_"||"_ArciSub,HospID)'="Y" //hxy 2020-05-28
	..s ArcAliasId=""
	..s ArcAliasId = $o(^ARC("ALIAS",0,"ARCIM",ArciID_"||"_ArciSub,""))
	..s:ArcAliasId'="" ArcAlias = $p(^ARC("ALIAS",ArcAliasId),"^",6)
	..B ;ERR
	..s AllArciDesc = ArcAlias_ArciDesc
	..;Q:ArciDesc'["会诊"
	..q:(q'="")&&(AllArciDesc'[$$ALPHAUP^SSUTIL4(q))
	..s Count = Count+1
	..s Tmp=ArciID_"||"_ArciSub_"^"_ArciDesc
	..i Count=1 d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	
	w "]"
	
	q ""
}

/// Descript:	取病人挂号类别
/// W ##Class(web.DHCEMConsultCom).GetPatRegDoc("4011")
ClassMethod GetPatRegDoc(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	Q:QueRowId="" ""
	s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	s RegDocCode="", RegDoctor=""
	s RegDocDr=QueObj.QueMarkDr.%Id()
	Q:RegDocDr=""
	s RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
	s RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	Q RegDocCode
}

/// Descript:	取MDT小组代码
/// W ##Class(web.DHCEMConsultCom).GetMdtGrpCode("4011")
ClassMethod GetMdtGrpCode(EpisodeID As %String, UserID As %String, HospID As %String) As %String
{
	n (EpisodeID, UserID, HospID)
	s mdtID=""
	i UserID'="" s mdtID=$o(^DHCEMCG(0,"User",UserID,""))
	Q:mdtID'="" mdtID
	s RegDocCode=##Class(web.DHCEMConsultCom).GetPatRegDoc(EpisodeID)
	Q:RegDocCode="" ""
	s mdtID=$o(^DHCEMCG(0,"Code",$$ALPHAUP^SSUTIL4(RegDocCode),HospID,""))
	Q mdtID
}

/// Descript:	取MDT小组组长
/// W ##Class(web.DHCEMConsultCom).GetMdtGrpUserID("4011")
ClassMethod GetMdtGrpUserID(ID As %String) As %String
{
	n (ID)
	s UserID=""
	s CH=""
	F  s CH=$o(^DHCEMCG(ID,"G",CH)) Q:(CH="")||(UserID'="")  D
	.Q:$p(^DHCEMCG(ID,"G",CH),"^",3)'="Y"    /// 联络人标识
	.s UserID=$p(^DHCEMCG(ID,"G",CH),"^",2)  /// 用户ID
	Q UserID
}

/// Descript:	根据成员取MDT小组组长
/// W ##Class(web.DHCEMConsultCom).GetMdtGrpUser("4011")
ClassMethod GetMdtGrpUser(UserID As %String)
{
	n (UserID)
	s mdtID=""
	i UserID'="" s mdtID=$o(^DHCEMCG(0,"User",UserID,""))
	Q:mdtID="" ""
	Q ..GetMdtGrpUserID(mdtID)
}

/// Descript:	是否是mdt小组成员
/// W ##Class(web.DHCEMConsultCom).isMdtUser("4011")
ClassMethod isMdtUser(LgUserID As %String)
{
	n (LgUserID)
	s mdtID=$o(^DHCEMCG(0,"User",LgUserID,""))
	Q mdtID
}

/// Descript:	取mdt小组科室列表
/// w ##class(web.DHCEMConsultCom).JsonConsMdtGroup("12","1","")
ClassMethod JsonConsMdtGroup(q As %String, mdtID As %String) As %String
{
	n (q, mdtID)
	s count=0
	w "["
	s ID="0"
	F  s ID=$o(^DHCEMCG(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCG(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCG(ID),"^",2)    //描述
	.Q:$p(^DHCEMCG(ID),"^",3)'="Y"
	.s tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descript:	取mdt小组科室列表
/// w ##class(web.DHCEMConsultCom).JsonConsGroupLoc("")
ClassMethod JsonConsGroupLoc(ID As %String) As %String
{
	n (ID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_RowID, EC_Loc_Dr, EC_User_Dr FROM DHC_EmConsultGroupItm WHERE EC_ParRef_Dr="_ID 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	k TMPLoc
	w "["
	While(result.Next())
	{
		s ID = result.Data("EC_RowID")	
		s LocID = result.Data("EC_Loc_Dr")
		Continue:$D(TMPLoc(LocID))
		s TMPLoc(LocID)=""
		s LocDesc=$p(^CTLOC(LocID),"^",2)
		s tmp=LocID_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:	取mdt小组科室列表
/// w ##class(web.DHCEMConsultCom).JsonConsGroupUser("")
ClassMethod JsonConsGroupUser(ID As %String, LocID As %String) As %String
{
	n (ID, LocID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_Loc_Dr, EC_User_Dr FROM DHC_EmConsultGroupItm WHERE EC_ParRef_Dr="_ID 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{
		Continue:LocID'=result.Data("EC_Loc_Dr")
		s User=""
		s UserID = result.Data("EC_User_Dr")
		s:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
		s CareProvID = $p(^SSU("SSUSR",UserID),"^",14)
		s tmp=CareProvID_"^"_User
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator:    QQA
/// CreateDate: 2018-06-27
/// Descript:	会诊申请配置
/// InPut:      CosultCode-会诊申请参数类型, Params-医院id^科室id^用户id^安全组id
/// OutPut:     会诊申请参数类型值
/// w ##class(web.DHCEMConsultCom).GetEmSysConfig("REQORD","2")
ClassMethod GetEmSysConfig(CosultCode As %String, Params As %String) As %String
{
	n (CosultCode, Params)
	s LgHospID=$p(Params,"^",1)	  /// 医院ID
	s LgCtLocID=$p(Params,"^",2)  /// 科室ID
	s LgUserID=$p(Params,"^",3)   /// 用户ID
	s LgGroupID=$p(Params,"^",4)  /// 安全组ID
	s ResType=##Class(web.DHCEMComPar).GetAppPropValue("DHCCON",CosultCode,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// 通过用户ID获取类别
/// w ##Class(web.DHCEMConsultCom).GetPrvTpIDByCareProvID()
ClassMethod GetPrvTpIDByCareProvID(CareProvID)
{
	n (CareProvID, %session)
	q:+CareProvID=0 ""
	s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	s CTPCPCTDesc = $p(^CT("CPT",CTPCPCTId),"^",2)
	s CTPCPCTDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CTPCPCTDesc)
	q CTPCPCTId_"^"_CTPCPCTDesc
}

/// Descript:获取会诊类型字典
/// W ##class(web.DHCEMConsultCom).JsonAllCstType(2)
ClassMethod JsonAllCstType(HospID, Ord = "") As %String
{
	
	n (HospID,Ord,%session)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //hxy 2021-06-02 多院区 add
	s mID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4("CYT"),HospID,""))
	Q:mID=""
	w "["
	s ID="",count=0
	;w:Ord="Y" ##class(web.DHCAPPJsonCommon).getJsonData("value^text","I^院内会诊") //hxy 2021-02-27 st Ord="Y" demo-会诊申请医嘱配置 界面使用
	;w:Ord="Y" ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text","O^院外会诊") 
	;s:Ord="Y" count=2 //ed
	F  s ID=$o(^DHCEMCDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCDI(ID),"^",2)    //描述
	.q:Desc="无权限" //2022-01-25
	.s ActCode=$p(^DHCEMCDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$p(^DHCEMCDI(ID),"^",5)    //类型ID
	.s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",Desc)
	.s ListData=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData)
	.
	w "]"
	Q ""
}

/// Descript:获取子表ID串
/// w ##class(web.DHCEMConsultCom).GetCstItmIDs(300)
ClassMethod GetCstItmIDs(CstID)
{
	n (CstID)
	q:CstID="" ""
	s Ret=""
	s CH=""
	f  s CH = $o(^DHCEMCON(CstID,"I",CH)) q:CH=""  d
	.
	.s CstItmID = CstID_"||"_CH
	.s:Ret'="" Ret=Ret_"^"_CstItmID
	.s:Ret="" Ret=CstItmID
	q Ret
}

/// Descritp:	关联科室列表
/// w ##Class(web.DHCEMConsultCom).JsonLoc("","2","CONSULT")
ClassMethod JsonLocList(q As %String = "", HospID As %String, LType As %String, LocID = "") As %String
{
	n (q, HospID, LType, LocID,%session)
	s input=$ZCVT(q,"U")
	s count=0
	w "["
	s ParRef=$o(^CT("LL",0,"Code",LType,""))
	s CH=0
	F  s CH=$o(^CT("LL",ParRef,"LOC",CH)) Q:CH=""  D
	.s LocDr=$P($g(^CT("LL",ParRef,"LOC",CH)),"^",1)
	.Q:(LocID=LocDr)&(LocID'="") //hxy 2020-09-21 add'=""
	.s DateFrom=$p(^CTLOC(LocDr),"^",24)
	.s DateTo=$p(^CTLOC(LocDr),"^",25)
	.Q:(DateFrom>+$H)&(DateFrom'="")
	.Q:(DateTo<+$H)&(DateTo'="")
	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s ContactName = $p(^CTLOC(LocDr),"^",43)
	.s ContactName = $ZCVT(ContactName,"U")   	//add sufan 2019-02-13  
	.Q:(input'="")&(LocDesc'[input)&(ContactName'[input)
	.s tmp=LocDr_"^"_LocDesc
	.Q:(HospID'="")&(HospID'=$P(^CT("LL",ParRef,"LOC",CH),"^",2))
	.s LocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descritp:	院区
/// w ##Class(web.DHCEMConsultCom).JsonHosp()
ClassMethod JsonHosp() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT HOSP_RowId, HOSP_Desc FROM CT_Hospital"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("HOSP_RowId")
		s Desc = result.Data("HOSP_Desc")
		Continue:Desc=""
		s EdDate=$p(^CT("HOSP",ID),"^",10) //hxy 2020-06-05 st
	    Continue:(EdDate'="")&(EdDate<+$h) //ed
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc","",Desc)
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	会诊申请特殊符号转义处理
/// w ##Class(web.DHCEMConsultCom).TrsSpeSymbol("")
ClassMethod TrsSpeSymbol(TmpString As %String) As %String
{
	n (TmpString)
	i TmpString["TSS02" s TmpString=$REPLACE(TmpString,"TSS02","^")
	Q TmpString
}

/// Descript:	判断会诊是否需要审核
/// w ##Class(web.DHCEMConsultCom).isCsAudit("")
ClassMethod isCsAudit(itemID As %String) As %String
{
	n (itemID)
	s QuitFlag=0
	s ID=""
	F  s ID=$o(^DHCEMCIP(0,"Item",itemID,ID)) Q:(ID="")||(QuitFlag=1)  D
	.Q:$p(^DHCEMCIP(ID),"^",1)'="AUDIT"
	.Q:$p(^DHCEMCIP(ID),"^",3)'="Y"
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Descript:   日期大小判断
/// W ##Class(web.DHCEMConsultCom).isCompare("16/01/2019 11:17:54","16/01/2019 11:17:54")
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

/// Descritp:	获取病人临床科研费别
/// w ##Class(web.DHCEMConsultCom).GetPilPatAdmReason()
ClassMethod GetPilPatAdmReason(EpisodeID As %String) As %String
{
	
	n (EpisodeID)
	s PatType=$p(^PAADM(EpisodeID),"^",2) /// 就诊类型
	i PatType="I" D
	.s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
	E  D
	.s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
	Q BillTypeID
}

/// Descritp:	获取会诊启用的状态
/// w ##Class(web.DHCEMConsultCom).GetConsUseStatus(2)
ClassMethod GetConsUseStatus(LgHospID) As %String
{
	n (LgHospID)
	s Ret=""
	s ID="0"
	F  s ID=$o(^DHCEMCONS(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCONS(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCONS(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCONS(ID),"^",3) //可用标志
	.q:ActCode'="Y"
	.s HospID=$p(^DHCEMCONS(ID),"^",4)  //医院
	.q:(HospID'="")&&(LgHospID'=HospID)
	.s:Ret'="" Ret=Ret_"^"_Desc
	.s:Ret="" Ret=Desc
	s:Ret'="" Ret="^"_Ret_"^"
	q Ret
}

/// Descritp:	获取会诊启用的状态
/// w ##Class(web.DHCEMConsultCom).GetConsUseStatusCode(2)
ClassMethod GetConsUseStatusCode(LgHospID) As %String
{
	n (LgHospID)
	s Ret=""
	s ID="0"
	F  s ID=$o(^DHCEMCONS(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCONS(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCONS(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCONS(ID),"^",3) //可用标志
	.q:ActCode'="Y"
	.s HospID=$p(^DHCEMCONS(ID),"^",4)  //医院
	.;q:(HospID'="")&&(LgHospID'=HospID) //hxy 2020-06-08
	.s:Ret'="" Ret=Ret_"^"_Code
	.s:Ret="" Ret=Code
	s:Ret'="" Ret="^"_Ret_"^"
	q Ret
}

/// Descript:是否启用了接收状态
/// w ##Class(web.DHCEMConsultCom).IsOpenAccStatus()
ClassMethod IsOpenAccStatus()
{
	s Ret="N"
	s StatusID=0
	f  s StatusID=$o(^DHCEMCONS(StatusID)) q:StatusID=""  d
	.s StatusCode=$p(^DHCEMCONS(StatusID),"^",1)
	.s IsActive=$p(^DHCEMCONS(StatusID),"^",3)
	.q:StatusCode'=30
	.q:IsActive'="Y"
	.s Ret="Y"
	q Ret
}

/// Descritp:	获取会诊是否启用某个状态
/// w ##Class(web.DHCEMConsultCom).ConsStatusIsUse(2,"完成")
ClassMethod ConsStatusIsUse(LgHospID, Status) As %String
{
	n (LgHospID,Status)
	s Ret=""
	s ConsStas = ##Class(web.DHCEMConsultCom).GetConsUseStatus(LgHospID)
	s:Status'="" Status="^"_Status_"^"
	s:ConsStas[Status Ret=1
	q Ret
}

/// Descritp:	获取会诊是否启用某个状态
/// w ##Class(web.DHCEMConsultCom).ConsStatusCodeIsUse(2,"50")
ClassMethod ConsStatusCodeIsUse(LgHospID, StatusCode) As %String
{
	n (LgHospID,StatusCode)
	s Ret=""
	s ConsCodeStas = ##Class(web.DHCEMConsultCom).GetConsUseStatusCode(LgHospID)
	s:StatusCode'="" StatusCode="^"_StatusCode_"^"
	s:ConsCodeStas[StatusCode Ret=1
	q Ret
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-22
/// Descript:   会诊申请按钮的可用状态  
/// w ##Class(web.DHCEMConsultCom).GetCsBtnSet("") 
ClassMethod GetCsBtnSet(HospID As %String) As %String
{
	n (HospID)
	w "["
	s ID="0",count=0
	F  s ID=$o(^DHCEMCONS(ID)) Q:ID=""  D
	.s BtCode=$p(^DHCEMCONS(ID),"^",1)    /// 代码
	.s BtDesc=$p(^DHCEMCONS(ID),"^",2)    /// 描述
	.Q:$p(^DHCEMCONS(ID),"^",3)'="Y"      /// 可用标志
	.//Q:$p(^DHCEMCONS(ID),"^",4)'=HospID   /// 医院
	.s count = count+1
	.i count=1 D
	..w ##class(web.DHCEMJsonCommon).getJsonData("BtCode^BtDesc",BtCode_"^"_BtDesc)
	.E  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("BtCode^BtDesc",BtCode_"^"_BtDesc)
    w "]"
    Q ""
}

/// Descript:获取会诊类型字典
/// w ##class(web.DHCEMConsultCom).JsonCstProp("")
ClassMethod JsonCstProp(CstID As %String = "", LgHospID) As %String
{
	n (CstID,%session,LgHospID)
	w "["
	s CsPropID=$p($g(^DHCEMCON(+CstID)),"^",41)   /// 会诊性质
	s HospID="",count=0
	F  s HospID=$o(^DHCEMCDT(0,"Code","CNAT",HospID)) Q:HospID=""  D
	.;q:LgHospID'=HospID //hxy 2020-05-29 //20201-05-31 注释 st
	.q:##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",LgHospID)'=HospID //add ed
	.s mID=""
	.F  s mID=$o(^DHCEMCDT(0,"Code","CNAT",HospID,mID)) Q:mID=""  D
	..s itmID=""
	..F  s itmID=$o(^DHCEMCDI(0,"Type",mID,itmID)) Q:itmID=""  D
	...Q:(CsPropID'=itmID)&($p(^DHCEMCDI(itmID),"^",3)'="Y")
	...s itmCode=$p(^DHCEMCDI(itmID),"^",1)  //项目代码
	...s itmDesc=$p(^DHCEMCDI(itmID),"^",2)  //项目描述
	...s itmDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",itmDesc)
	...s count = count+1
	...i count=1 D
	....w ##Class(web.DHCEMJsonCommon).getJsonData("itmID^itmDesc",itmID_"^"_itmDesc)
	...E  D
	....w ","_##Class(web.DHCEMJsonCommon).getJsonData("itmID^itmDesc",itmID_"^"_itmDesc)
	..
    w "]"
    Q ""
}

/// Creator:    hxy
/// CreateDate: 2019-11-27
/// Descript:	医嘱项的所有配置医院id分隔
/// InPut:      
/// OutPut:     #id1#id2#
/// w ##class(web.DHCEMConsultCom).GetArciHosp("5278","1")
ClassMethod GetArciHosp(ArciID As %String, ArciSub As %String)
{
	n (ArciID,ArciSub)
	s ret="#"
	s Sub=0
	f  s Sub =$o(^ARCIM(ArciID,ArciSub,"HOSP",Sub)) q:Sub=""  d
	.s HospID = $p(^ARCIM(ArciID,ArciSub,"HOSP",Sub),"^",1)
	.s ret=ret_HospID_"#"
	q ret
}

/// Descript:	验证病人是否允许开医嘱
/// W ##Class(web.DHCEMConsultCom).GetPatNotTakOrdMsg("104","10209","203","628")
ClassMethod GetPatNotTakOrdMsg(LgGroupID As %String, LgUserID As %String, LgLocID As %String, EpisodeID As %String) As %String
{
	n (LgGroupID, LgUserID, LgLocID, EpisodeID,%session)

	s NotTakOrdMsg=""
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
 	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
 	
 	/// 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
    s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	s OPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("OPAdmDayLimit")
	i OPAdmDayLimit="" s OPAdmDayLimit=1
	/// 不受就诊有效天数限制
    s NoAdmValidDaysLimit=##Class(web.DHCDocConfig).GetConfigNode1("NoAdmValidDaysLimit",LgGroupID)
	
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
	.e  i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1)  s NotTakOrdMsg="此就诊记录的挂号日期在"_OPAdmDayLimit_"天以前,不允许再开申请."
	
	i (PAAdmType="E")&&(" 1 2 "'[(" "_GetStayStatusFlag_" "))&&(IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1) d
 	.s checkDateStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
 	.i checkDateStr'=0 d
 	..s checkAdmDate=$p(checkDateStr,"^",2)
 	..s checkAdmDateUom=$p(checkDateStr,"^",3)
 	..s NotTakOrdMsg="此就诊记录的挂号时间在"_checkAdmDate_checkAdmDateUom_"以前,不允许再开申请."
 
	i NotTakOrdMsg="",PAAdmType="I",IPDefaultDurRowId="" D
	.s NotTakOrdMsg="住院没有设定默认的疗程?请与系统维护部门联系."
 	
 	/// 调用医生站新接口
	i (PAAdmType'="I")&&(IfPilotAdm'=1) D
 	.s TakOrdFlag=##Class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
 	.s LimUnit=$p(TakOrdFlag,"^",2)  /// 单位
 	.s LimTime=$p(TakOrdFlag,"^",3)  /// 时间
 	.i (TakOrdFlag[-100)&&(NoAdmValidDaysLimit'=1)&&(IfPilotAdm'=1) D
 	..s NotTakOrdMsg="此就诊记录的挂号时间在"_LimTime_LimUnit_"以前,不允许再开申请."
 	/// 患者状态
	//s Status=##class(web.DHCDocTransfer).GetQueStatusByAdm(EpisodeID)
	//i (Status="报到")&&(##class(web.DHCDocTransfer).GetExaNoCheckinDocCanRecAdm(EpisodeID)'="Y") s NotTakOrdMsg="未报到患者不允许录入医嘱!"
 	if (NotTakOrdMsg="")&&(PAAdmType'="I"){
 		s NotTakOrdMsg=##class(web.DHCDocOutPatientList).CheckIsAdmissions(EpisodeID,LgUserID)
 	}
#; 	if (NotTakOrdMsg=""){ //屏蔽加锁,会诊插医嘱不加锁
#;	 	s NotTakOrdMsg=##Class(web.DHCDocViewDataInit).GetOrdEntryWarning(EpisodeID)
#;	}
	Q NotTakOrdMsg
}

/// Descript:	专科小组科室维护中除过组长后，是否维护了其他科室
/// W ##Class(web.DHCEMConsultCom).isExistUnGrpLoc("4011")
ClassMethod isExistUnGrpLoc(ID As %String) As %String
{
	n (ID)
	Q:ID="" 0  //handong  2019-11-11
	s CH="", QuitFlag=0
	F  s CH=$o(^DHCEMCG(ID,"G",CH)) Q:(CH="")||(QuitFlag=1)  D
	.Q:$p(^DHCEMCG(ID,"G",CH),"^",3)="Y"   /// 联络人标识
	.s QuitFlag=1
	Q QuitFlag
}

/// Creator:    hxy
/// CreateDate: 2020-05-07
/// Descript:   取病案号
/// InPut:      EpisodeID- 就诊ID
/// OutPut:     病案号
/// w ##Class(web.DHCEMConsultCom).GetMrNo("16")
ClassMethod GetMrNo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:(+EpisodeID=0) ""
	q:'$d(^PAADM(EpisodeID)) ""
	s MrNo=""
	s MedType=$p($g(^PAADM(+EpisodeID)),"^",2)	
	s IfHaveMethodByEpis=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByEpisodeID")
	;s IfHaveMethodByPati=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByPatientID")
	i IfHaveMethodByEpis=1 d
	.s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
    .;s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,MedType,HosptialID,.ErrMsg)
    e  d
    .s MrNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
    .;s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
    .;s MrNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",22) //病案号
	q MrNo
}

/// Creator:    hxy
/// CreateDate: 2021-02-24
/// Descritp:	获取患者就诊类型
/// InPut:      EpisodeID- 就诊ID
/// OutPut:     就诊类型
/// w ##Class(web.DHCEMConsultCom).GetPatType(1)
ClassMethod GetPatType(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	q:'$d(^PAADM(EpisodeID)) ""
	s PatType=$p($g(^PAADM(+EpisodeID)),"^",2) /// 就诊类型
	q PatType
}

/// Creator:    hxy
/// CreateDate: 2021-03-12
/// Descritp:	该天是不是周末
/// InPut:      日期
/// OutPut:     1：是，0：不是
/// w ##Class(web.DHCEMConsultCom).GetWeekFlag("2021-03-12")
ClassMethod GetWeekFlag(Date As %String) As %String
{
	n (Date)
	s ret=0
	s Date=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
	s WeekFlag=$SYSTEM.SQL.DAYOFWEEK(Date)
	s:(WeekFlag=7)!(WeekFlag=1) ret=1
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-03-12
/// Descritp:	该天是不是节假日
/// InPut:      日期
/// OutPut:     1：是，0：不是
/// w ##Class(web.DHCEMConsultCom).GetHolidayFlag("2021-03-12")
ClassMethod GetHolidayFlag(Date As %String) As %String
{
	n (Date)
	s ret=0
	s Date=##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
	s HolidayFlag=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(Date,"","") //节日2/假日1/非节假日0 /错误-1
	s:HolidayFlag>0 ret=1
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descritp:	根据UserID取值职称描述
/// InPut:      UserID
/// OutPut:     职称描述
/// w ##Class(web.DHCEMConsultCom).GetPrvTpByUserID("12177")
ClassMethod GetPrvTpByUserID(UserID As %String) As %String
{
	n (UserID)
	q:+UserID=0 ""
	s CareProvID=$p($g(^SSU("SSUSR",+UserID)),"^",14)
	s PrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)
	s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	q PrvTp
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descritp:	根据会诊子表ItmID取值到达日期时间
/// InPut:      ItmID
/// OutPut:     到达日期时间
/// w ##Class(web.DHCEMConsultCom).GetArrTimeByItmID("124||1")
ClassMethod GetArrTimeByItmID(ItmID As %String) As %String
{
	n (ItmID)
	q:+ItmID=0 ""
	s ret=""
	s ArrDate=$p($g(^DHCEMCON(+ItmID,"I",+$p(ItmID,"||",2))),"^",18)
	s ArrTime=$p($g(^DHCEMCON(+ItmID,"I",+$p(ItmID,"||",2))),"^",19)
    s:ArrDate'="" ArrDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)
	s:ArrTime'="" ArrTime = $zt(ArrTime,1)
	s:ArrDate'="" ret=ArrDate_" "_ArrTime
	q ret
}

/// Creator:    hxy
/// CreateDate: 2020-09-27
/// Descript:   取签名
/// InPut:      UserID
/// OutPut:     base64
/// w ##Class(web.DHCEMConsultCom).GetImageByUserID("12175")
ClassMethod GetImageByUserID(UserID As %String) As %String
{
	n (UserID,%session)
	;q "iVBORw0KGgoAAAANSUhEUgAAAC4AAAAbCAIAAACMbCp+AAABuklEQVRIDe2WsW6DMBCGL1X3IucB2oHMZAkdGVEmZpQhDxDxNFEfgAGxNlOUrYwhS7qTF2glmi5Vt/aAYmLnTEIHTzCAfD7fff59PjH4+n4H+AEYKN6g7blREHAybSSAKDwrqY1WFJKA82lF4VlJJq0oJAHn04rCs5JMWlFIAs6nFYVnJZn0odyKfeVjF63SXJGejf2ZxcTJPF1twPFtQzDnr3G0V4VBT3M6d01hBQ4Gbd02e4lzq2Maw555E4k3S4g4MglIqkhndOaOBmb5gVVNZOtwlxvADDa0XFEYVCveGm7gSJsvlgw9eXtluPZuS6GUNoz4tAwPo7k7AhhaE0hwGKdHvoDZ3iK4PyzDTVbbssIHl5Ac6IQH9Fb3/s9d9KwslCogG9tsn2bNYZ/WSqnEEUxnMX2o85ff6w6oe61Uwdcn263T8mJEzRox6lnhS92A7rVShsSsTRFU98V0+KUQZtH/OlUQpaWvCDupBsodF6WQFD7nB0SEIUydVZF3jJJs73ypOIhEl03/vEGXA3f3IFVpeq45dVQx/+4LNppHT+XTyd56g4p/Xn1P/29Lad2r0qtCKUDZfgEglxNChc6SMAAAAABJRU5ErkJggg=="
	s ret=""
	s ret=##class(CA.BICAService).GetImageByUserID(UserID) //项目上用接口（标库没有）
	;s ret=##Class(CA.UsrSignatureInfo).GetCAImage(UserID)  //项目上用接口（标库没有）
#;	s SignID=##Class(CA.UsrSignatureInfo).GetInUseID(UserID)
#;	q:(SignID="") ""
#;	
#;	s obj=##Class(CA.UsrSignatureInfo).%OpenId(SignID,0)
#;	q:(obj'="") obj.SignImage
	q ret
}

/// Creator:    hxy
/// CreateDate: 2020-09-27
/// Descript:   是否有签名
/// InPut:      会诊子表ID
/// OutPut:     1：有
/// w ##Class(web.DHCEMConsultCom).GetIfSignByCstItmID("291||1","R")
ClassMethod GetIfSignByCstItmID(CstItmID As %String, ConsType As %String) As %String
{
	n (CstItmID,ConsType)
	;q 1 ///测试，需注释
	s Ret="",Ord=""
	s ConCH=$p(CstItmID,"||",2)
	s:ConsType="R" Ord=$p(^DHCEMCON(+CstItmID,"I",ConCH),"^",9)
	s:ConsType="C" Ord=$p(^DHCEMCON(+CstItmID,"I",ConCH),"^",10)   
	q:Ord="" Ret
	;s:$d(^DHCDocSignVerify(0,"OEORI",Ord)) Ret=1
	s DocSignID=$o(^DHCDocSignVerify(0,"OEORI",Ord,""),-1)
	s OpType=$p($g(^DHCDocSignVerify(+DocSignID)),"^",9)
	s:OpType="A" Ret=1
	s SignDr=$p($g(^DHCDocSignVerify(+DocSignID)),"^",11) //2022-01-22
	q Ret_"^"_SignDr
	;q Ret_"^"_DocSignID
}

/// Creator:    hxy
/// CreateDate: 2021-05-06
/// Descript:   由会诊子表ID、状态code取值日志数据-操作人^操作备注
/// InPut:      ItmID - 子表ID,StCode - 状态code
/// OutPut:     操作人^操作备注
/// w ##Class(web.DHCEMConsultCom).GetLogDataByStCode("144||1","25")
ClassMethod GetLogDataByStCode(ItmID As %String, StCode As %String) As %String
{
	n (ItmID, StCode,%session)
	q:(ItmID="")||(StCode="") ""
	s CstID=+ItmID
	q:$p(^DHCEMCON(CstID),"^",18)="" ""             /// 会诊状态
	s ret=""
	s LgID=""
	f  s LgID=$o(^DHCEMCONL(0,"Cst",ItmID,LgID),-1) q:(LgID="")||(ret'="")  d
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态ID
	.q:$p($g(^DHCEMCONS(+StatusID)),"^",1)'=StCode
	.s StatusDesc=$p($g(^DHCEMCONS(+StatusID)),"^",2)
	.s User=$p(^DHCEMCONL(LgID),"^",2)      /// 操作人
	.s:User'="" User=$p($g(^SSU("SSUSR",+User)),"^",2)
	.s User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
	.s Note=$p(^DHCEMCONL(LgID),"^",6)      /// 备注(原因)
	.s ret=User_"^"_Note
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-05-11
/// Descritp:	获取患者就诊医院ID
/// InPut:      CstID- 会诊主表ID
/// OutPut:     就诊医院ID
/// w ##Class(web.DHCEMConsultCom).GetPatHospID(471)
ClassMethod GetPatHospID(CstID As %String) As %String
{
	n (CstID)
	q:+CstID=0 ""
	s EpisodeID=$p(^DHCEMCON(+CstID),"^",1)      /// 就诊ID
	s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	q AdmHospID
}

/// Creator:    hxy
/// CreateDate: 2021-05-20
/// Descritp:	完成会诊时调用推送数据给电子病历接口(2022-03-02增加发送、取消、驳回时的调用)
/// Input:      CsPointer 会诊主表或者子表ID
///             CmpDate 完成日期logical
///             CmpTime 完成时间logical
///             (电子病历接口入参：APatientID 病人ID
///             AEpisodeID 就诊号
///             AConsultID 会诊ID
///             AApplyDate (cache内部格式) 会诊申请日期
///             AApplyTime (cache内部格式) 会诊申请时间
///             AApplyDoctor 会诊申请医生名称
///             AFinishDate (cache内部格式) 会诊完成日期
///             AFinishTime (cache内部格式) 会诊完成时间
///             AConsultDoctor 会诊医生名称
///             AConsultType 会诊类型(单科/多科)
///             AConsultLoc 会诊科室描述
///             AApplyLoc 会诊申请科室描述
///             AConDestination 会诊目的
///             AAttitude 会诊意见
///             AConsultStatus 会诊状态(完成/取消完成)，可不传，默认为完成【2022-03-02add】)
/// Output:     result 0成功 1失败
/// w ##Class(web.DHCEMConsultCom).SetDataForEmr("495","65884","51917")
ClassMethod SetDataForEmr(CstID As %String, CmpDate As %String, CmpTime As %String, Status = "") As %String
{
	n (CstID,CmpDate,CmpTime,Status)
	Q:'$D(^DHCEMCON(CstID)) 0
	s ECRStatus=$p(^DHCEMCON(CstID),"^",18)
	;q:$p(^DHCEMCONS(ECRStatus),"^",1)'="50" 0
	s ret=1
	s AConsultID=CstID
	s AEpisodeID=$p(^DHCEMCON(CstID),"^",1)    /// 就诊号
	s APatientID=$p(^PAADM(+AEpisodeID),"^",1) /// 病人ID
	s AApplyLoc=$p(^DHCEMCON(CstID),"^",2)     /// 申请科室
	s AApplyLoc=$p($g(^CTLOC(+AApplyLoc)),"^",2)
	s AApplyDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	s AApplyTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s AApplyDoctor=$p(^DHCEMCON(CstID),"^",5)  /// 申请医生
	s AApplyDoctor=$p($g(^SSU("SSUSR",+AApplyDoctor)),"^",2)
	s AFinishDate=CmpDate
	s AFinishTime=CmpTime
	s AConDestination=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)
	s AConsultType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	s AAttitude=$p(^DHCEMCON(CstID),"^",17)       /// 会诊意见
	s CstEcType=$p(^DHCEMCON(CstID),"^",19)
	s MoreFlag=$p(^DHCEMCON(CstID),"^",31)        /// 多科标志
	s Anti=$p(^DHCEMCON(CstID),"^",35)
	s Anti=$s(Anti="Y":"同意;",Anti="N":"不同意;",1:"")
	s:CstEcType="DOCA" AAttitude=Anti_AAttitude
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24)      /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)         /// 外院名称
	s CstLocName=$p(^DHCEMCON(CstID),"^",26)      /// 外院科室
	s AConsultLoc="",AConsultDoctor="",CsOpinion=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(ret'=1)  D
	.s ConLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)
	.s ConLoc=$p($g(^CTLOC(+ConLocID)),"^",2)
	.s:AConsultLoc'="" AConsultLoc=AConsultLoc_"、"_ConLoc
	.s:AConsultLoc="" AConsultLoc=ConLoc
	.s ConDocID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	.s:ConDocID="" ConDocID=$p(^DHCEMCON(CstID,"I",CH),"^",2)
	.s ConDoc=$p($g(^CTPCP(+ConDocID,1)),"^",2)
	.s:AConsultDoctor'="" AConsultDoctor=AConsultDoctor_"、"_ConDoc
	.s:AConsultDoctor="" AConsultDoctor=ConDoc
	.s Opinion=$p($g(^DHCEMCON(CstID,"I",CH)),"^",4)
	.s:ConDoc'="" ConDoc=ConDoc_":"
	.i CsOpinion="" s CsOpinion=ConDoc_Opinion
	.E  s CsOpinion=CsOpinion_";"_ConDoc_Opinion
	s:(AAttitude="")&&(MoreFlag="Y") AAttitude=CsOpinion
	s:AAttitude="" AAttitude=Opinion
	s:CstOutFlag="Y" AConsultLoc=CstLocName
	s AConsultStatus=Status
	s IfHaveAbility=##class(websys.Conversions).IsValidMethodName("EMRservice.HISInterface.Event.Consult","SetData")
	q:IfHaveAbility=0 0
	s ret=##Class(EMRservice.HISInterface.Event.Consult).SetData(APatientID, AEpisodeID, AConsultID, AApplyDate, AApplyTime, AApplyDoctor, AFinishDate, AFinishTime, AConsultDoctor, AConsultType, AConsultLoc, AApplyLoc, AConDestination, AAttitude,AConsultStatus)
	s:ret=1 ret=0 //接口返回：1成功 0失败
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-06-04
/// Descritp:	取消完成会诊时调用电子病历接口将会诊记录状态改为取消完成(2022-03-02弃用)
/// Input:      CstID 会诊主表ID
/// Output:     result 0成功 1失败
/// w ##Class(web.DHCEMConsultCom).RevCompForEmr("495")
ClassMethod RevCompForEmr(CstID As %String) As %String
{
	n (CstID)
	Q:'$D(^DHCEMCON(CstID)) 0
	s ret=1
	s IfHaveAbility=##class(websys.Conversions).IsValidMethodName("EMRservice.HISInterface.Event.Consult","CancelCompletion")
	q:IfHaveAbility=0 0
	s ret=##Class(EMRservice.HISInterface.Event.Consult).CancelCompletion(CstID)
	s:ret=1 ret=0 //接口返回: 1成功 0失败
	q ret
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

/// Creator:    hxy
/// CreateDate: 2022-12-22
/// Descritp:	调用平台状态统一存储接口存储状态【平台组接口】
/// Input:      CstID主表ID，ItmID子表ID, UserID用户ID, NodeCode平台状态代码, Status状态代码, Notes备注, LocID科室ID
/// Output:     result 0成功 
/// w (web.DHCEMConsultCom).UpdateSystemStatus("450","","18881","AP","20","","191") 
ClassMethod UpdateSystemStatus(CstID As %String, ItmID As %String, UserID As %String, NodeCode As %String, Status As %String, Notes As %String, LocID As %String) As %String
{
	n (CstID,ItmID,UserID,NodeCode,Status,Notes,LocID)
	q:(NodeCode="")!((CstID="")&(ItmID="")) 0
	;(20发送AP，5取消CAP，30接收CONREC,35取消接收CONCREC,25拒绝接收CONREJ,40到达CONARRIVE,50完成CONCOMPLETED,51取消完成CONCCOMPLETED,55会诊评价CONEVALUATION,56取消会诊评价CONCEVALUATION)
	;(60会诊确认CONCONFIRM,61取消确认CONCCONFIRM,70评价CONDOCEVA,79取消评价CONCDOCEVA,71科主任审核CONDIRAUDIT,72医务部审核CONMEDAUDIT)
	;(801科主任取消审核CONDIRUNAPPROVE,802医务部取消审核CONMEDUNAPPROVE,221科主任驳回CONDIRREJECT，222医务部驳回CONMEDREJECT)
	s ret=0
	s SourceSystem="HIS"
	s Usercode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	s OperateDeptCode=$p($g(^CTLOC(+LocID)),"^",1)
	s OperateDept=$p($g(^CTLOC(+LocID)),"^",2)
    s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(ret'=0)  D
	.s CurItm=CstID_"||"_CH
	.Q:(ItmID'="")&(ItmID'=CurItm)
	.s OperDateTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CurItm,Status)
	.s jsonStream=##class(%GlobalCharacterStream).%New()
	.d jsonStream.Write("[")
	.s jsonObj=##class(%Library.DynamicObject).%New()
	.s jsonObj.OEOrdItemID=ItmID 		 //医嘱号(会诊子表ID)
	.s jsonObj.Position=""       		 //检查部位
	.s jsonObj.ExamID=""         		 //检查号
	.s jsonObj.Status=NodeCode   		 //状态(20发送AP，5取消CAP，30接收CONREC,35取消接收CONCREC,25拒绝接收CONREJ,40到达CONARRIVE,50完成CONCOMPLETED,51取消完成CONCCOMPLETED,55会诊评价CONEVALUATION)
	.s jsonObj.UserID=Usercode   		 //操作人工号
	.s jsonObj.UserName=UserName 		 //操作人姓名
	.s jsonObj.UpDateTime=OperDateTime   //操作时间日期
	.s jsonObj.SourceSystem=SourceSystem //来源系统
	.s jsonObj.Notes=Notes   		     //备注
	.s jsonObj.OperateDeptCode=OperateDeptCode //操作科室代码
	.s jsonObj.OperateDept=OperateDept   //操作科室
	.s jsonStr=jsonObj.%ToJSON()
	.d jsonStream.Write(jsonStr)
	.d jsonStream.Write("]")
    .d jsonStream.Rewind()
    .;b ;jsonStream
	.s retStream= ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
	.s:+retStream<0 ret=-1

	q ret
}

}
