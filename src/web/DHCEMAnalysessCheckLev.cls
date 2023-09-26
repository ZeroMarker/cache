/// QQA
/// 统计分诊数据
Class web.DHCEMAnalysessCheckLev Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMAnalysessCheckLev).GetAnalysessData("2020-06-01^2020-06-09^3")
ClassMethod GetAnalysessData(Params)
{
	n (Params,%session)
	s StDate =$p(Params,"^",1)
	s EndDate =$p(Params,"^",2)
	s HospID =$p(Params,"^",3)
	s Del=""""
	w "{"
	w Del_"GetCheckPatNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).GetCheckPatNum(StDate, EndDate,HospID)
	w ","
	w Del_"QsPatNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).GetQsPatNum(StDate, EndDate,HospID)
	w ","
	w Del_"ThreeNoPatNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).GetThreeNoPatNum(StDate, EndDate,HospID)
	w ","
	w Del_"GreenPatNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).GetGreenPatNum(StDate, EndDate,HospID)
	w ","
	w Del_"PatGetSource"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).PatGetSource(StDate, EndDate,HospID)
	w ","
	w Del_"PatAgeAnalysess"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).PatAgeAnalysess(StDate,EndDate,HospID)
	w ","
	w Del_"PatCheckLocNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).PatCheckLocNum(StDate, EndDate,HospID)
	w ","
	w Del_"PatCheckCareNum"_Del_":"
	d ##class(web.DHCEMAnalysessCheckLev).PatCheckCareNum(StDate, EndDate,HospID)
	w "}"
  	q ""
}

ClassMethod GetCheckPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID)
	s:StDate'="" StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	
	s AllCheckNum=0,RedCheckNum=0,YellowCheckNum=0,GreenCheckNum=0,OrangeCheckNum=0 //hxy 2020-02-21
	
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..s AllCheckNum =AllCheckNum+1
 	..s:NurCheckLev=1 RedCheckNum=RedCheckNum+1
 	..s:NurCheckLev=2 OrangeCheckNum=OrangeCheckNum+1 //hxy 2020-02-21 原：RedCheckNum=RedCheckNum+1
 	..s:NurCheckLev=3 YellowCheckNum=YellowCheckNum+1
 	..s:NurCheckLev=4 GreenCheckNum=GreenCheckNum+1
 	..s:NurCheckLev=5 GreenCheckNum=GreenCheckNum+1 //hxy 2020-02-21 add
 	
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("AllCheckNum^RedCheckNum^YellowCheckNum^GreenCheckNum^OrangeCheckNum",AllCheckNum_"^"_RedCheckNum_"^"_YellowCheckNum_"^"_GreenCheckNum_"^"_OrangeCheckNum)	
 	q ""
}

/// 会诊群伤统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).GetQsPatNum("01/01/2018","21/01/2018")
ClassMethod GetQsPatNum(StDate, EndDate, HospID)
{
	n (StDate, EndDate ,HospID)
	w "["
	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","1^1^1")
	w "]"
	q ""
	s:StDate'="" StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
 	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum")
 	s Ghu=""
 	f  s Ghu= $o(^DHCEMGHU(Ghu)) q:Ghu=""  d
 	.q:+Ghu=0
 	.s GhuDesc = $p(^DHCEMGHU(Ghu),"^",2)
 	.s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,GhuDesc)=0
 	s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,"无群伤")=0
 	
 	f Date=StDate:1:EndDate  d
 	.s PCLRowID="" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s GhuID  =$p(^DHCEMPCL(PCLRowID),"^",50)  // 群伤
 	..s:GhuID="" ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,"无群伤")=^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,"无群伤")+1
 	..i GhuID'="" d
 	...s GhuDesc = $p(^DHCEMGHU(GhuID),"^",2)
 	...s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,GhuDesc)=^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,GhuDesc)+1
 	
 	
 	s Count=0
	w "["
	s GhuDesc="" 
	f  s GhuDesc = $o(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,GhuDesc)) q:GhuDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid,GhuDesc)
	.s Name = GhuDesc
	.s Data = Name_"^"_Num
 	.w $case(Count,0:"",Count:",")
 	.s Count =Count+1
 	.W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value",Data)
 	w "]"
 	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","GetQsPatNum",Pid)
 	
	q ""
}

/// 三无人员统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).ThreeNoPat("2018-01-19","2018-01-19")
ClassMethod GetThreeNoPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID,%session)
	q:(StDate="")!(EndDate="") "[]"
	s RedAreaNum=0,YellowAreaNum=0,GreenAreaNum=0,OrangeAreaNum=0 //hxy 2020-02-21
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s PatTypeDesc=""
 	..s PatTypeDr= $p(^DHCEMPCL(PCLRowID),"^",40)
 	..s:+PatTypeDr'=0 PatTypeDesc = $p($g(^DHCEMPT(PatTypeDr)),"^",2)
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..i PatTypeDesc["三无人员" d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaNum=RedAreaNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...;s:(NurCheckLev=4) GreenAreaNum=GreenAreaNum+1
 	...s:(NurCheckLev=1) RedAreaNum=RedAreaNum+1
 	...s:(NurCheckLev=2) OrangeAreaNum=OrangeAreaNum+1
 	...s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaNum=GreenAreaNum+1 //ed
 	
 	s Del=""""
 	s ItmRedColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#F16E57"_Del_"}}"
 	s ItmYellowColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#FFB746"_Del_"}}"
 	s ItmGreenColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#2AB66A"_Del_"}}"
 	s ItmOrangeColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"orange"_Del_"}}" //hxy 2020-02-21
 	
 	s Red=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","红区") //hxy 2022-12-05 st
 	s Orange=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","橙区")
 	s Yellow=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","黄区")
 	s Green=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","绿区") //ed
 			
 	w "["
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Red_"^"_RedAreaNum_"^"_ItmRedColor)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Orange_"^"_OrangeAreaNum_"^"_ItmOrangeColor) //hxy 2020-02-21 st
 	w "," //ed
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Yellow_"^"_YellowAreaNum_"^"_ItmYellowColor)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Green_"^"_GreenAreaNum_"^"_ItmGreenColor)
 	w "]"
	q ""
}

/// 绿色通道人员统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).GetGreenPatNum("2018-08-01","2018-08-31","")
ClassMethod GetGreenPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID,%session)
	q:(StDate="")!(EndDate="") "[]"
	s RedAreaNum=0,YellowAreaNum=0,GreenAreaNum=0,OrangeAreaNum=0 //hxy 2020-02-21
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(HospID'="")&&(LocInHosp'=HospID)
 	..s ChkAdmID = $o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,""),-1)
 	..q:ChkAdmID=""
 	..s Adm= $p(^DHCEMPCA(ChkAdmID),"^",2)
 	..q:Adm=""
 	..s EmPatGreFlag=$p($g(^PAADM(Adm)),"^",5)    ;##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(PCLRowID,"")
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..i EmPatGreFlag=1 d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaNum=RedAreaNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...;s:(NurCheckLev=4) GreenAreaNum=GreenAreaNum+1
 	...s:(NurCheckLev=1) RedAreaNum=RedAreaNum+1
 	...s:(NurCheckLev=2) OrangeAreaNum=OrangeAreaNum+1
 	...s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaNum=GreenAreaNum+1 //ed
 	
 	s Del=""""
 	s ItmRedColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#F16E57"_Del_"}}"
 	s ItmYellowColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#FFB746"_Del_"}}"
 	s ItmGreenColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#2AB66A"_Del_"}}"
 	s ItmOrangeColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"orange"_Del_"}}" //hxy 2020-02-21
 			
 	s Red=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","红区") //hxy 2022-12-05 st
 	s Orange=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","橙区")
 	s Yellow=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","黄区")
 	s Green=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","绿区") //ed
 	
 	w "["
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Red_"^"_RedAreaNum_"^"_ItmRedColor)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Orange_"^"_OrangeAreaNum_"^"_ItmOrangeColor) //hxy 2020-02-21
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Yellow_"^"_YellowAreaNum_"^"_ItmYellowColor)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^itemStyle",Green_"^"_GreenAreaNum_"^"_ItmGreenColor)
 	w "]"
	q ""
}

/// 病人来源统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).PatGetSource("2018-01-19","2018-01-19")
ClassMethod PatGetSource(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID,%session)
	q:(StDate="")!(EndDate="") "[]"
	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource")
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	
	s DHCEMPsoDr="0"
	f  s DHCEMPsoDr =$o(^DHCEMPSO(DHCEMPsoDr)) q:DHCEMPsoDr=""  d
	.s DHCEMPsoDesc= $p(^DHCEMPSO(DHCEMPsoDr),"^",2)
	.s DHCEMPsoStatus= $p(^DHCEMPSO(DHCEMPsoDr),"^",3)
	.s DHCEMPsoHospID= $p(^DHCEMPSO(DHCEMPsoDr),"^",4)
	.q:DHCEMPsoStatus'="Y"
	.;q:(HospID'="")&&(DHCEMPsoHospID'=HospID) //hxy 2020-06-09 注释
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",DHCEMPsoDr,HospID)'="Y" //hxy 2020-06-09 
	.s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,DHCEMPsoDesc)=0
	s Unknown=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","未知") //hxy 2022-12-05
	;s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,"未知")=0
	s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,Unknown)=0
	
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s EmPatSourceDesc=""
 	..s EmPatSource=$p(^DHCEMPCL(PCLRowID),"^",15)
 	..s:EmPatSource'="" EmPatSourceDesc =$p($g(^DHCEMPSO(EmPatSource)),"^",2)
 	..q:EmPatSourceDesc=""
	..s:EmPatSourceDesc="" EmPatSourceDesc=Unknown //"未知"
	..q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",EmPatSource,HospID)'="Y" //hxy 2020-06-09
	..s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,EmPatSourceDesc)=^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,EmPatSourceDesc)+1
	
	s PatSour=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","病人来源") //hxy 2022-12-05
	s Count=0
	w "["
	s EmPatSourceDesc="" 
	f  s EmPatSourceDesc = $o(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,EmPatSourceDesc)) q:EmPatSourceDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid,EmPatSourceDesc)
	.s Name = EmPatSourceDesc
	.s Name = ##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmPatSource","PSDesc","",Name) //hxy 2022-12-05
	.s Data = Name_"^"_Num_"^"_PatSour //"病人来源"
 	.w $case(Count,0:"",Count:",")
 	.s Count =Count+1
 	.W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	w "]"
 	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatGetSource",Pid)
	q ""
}

/// 年龄统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).PatAgeAnalysess("2018-01-19","2018-01-19")
ClassMethod PatAgeAnalysess(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID,%session)
	q:(StDate="")!(EndDate="") "[]"
	s Age1=0,Age2=0,Age3=0,Age4=0,Age5=0,Age6=0,Age7=0,Age8=0,Age9=0,Age10=0,Age11=0,Age12=0
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s PatDr = $p(^DHCEMPCL(PCLRowID),"^",1)
 	..q:+PatDr=0                                  //病人ID为空未错误数据
 	..s PatAge = ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)
 	..i PatAge'["岁"  d
 	...s PatAge=0
 	..i PatAge["岁"  d
 	...s PatAge = $p(PatAge,"岁",1)
 	..s:PatAge=0 Age1=Age1+1
 	..s:(0<PatAge)&&(PatAge<=15) Age2=Age2+1
 	..s:(15<PatAge)&&(PatAge<=30) Age3=Age3+1
 	..s:(30<PatAge)&&(PatAge<=40) Age5=Age5+1
 	..s:(40<PatAge)&&(PatAge<=50) Age6=Age6+1
 	..s:(50<PatAge)&&(PatAge<=60) Age7=Age7+1
 	..s:(60<PatAge)&&(PatAge<=70) Age8=Age8+1
 	..s:(70<PatAge)&&(PatAge<=80) Age9=Age9+1
 	..s:(80<PatAge)&&(PatAge<=90) Age10=Age10+1
 	..s:(90<PatAge)&&(PatAge<=100) Age11=Age11+1
 	..s:(100<PatAge) Age12=Age12+1
 	
 	s AgeDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","年龄") //hxy 2022-12-05

 	w "["
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","<1^"_Age1_"^"_AgeDesc) //"^年龄"
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","1-15^"_Age2_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","15-30^"_Age3_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","30-40^"_Age5_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","40-50^"_Age6_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","50-60^"_Age7_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","60-70^"_Age8_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","70-80^"_Age9_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","80-90^"_Age10_"^"_AgeDesc)
 	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","90-100^"_Age11_"^"_AgeDesc)
	w ","
 	W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",">100^"_Age12_"^"_AgeDesc)
 	w "]"
	q ""
}

/// 分诊科室统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).PatCheckLocNum("2018-05-08","2018-07-23")
ClassMethod PatCheckLocNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID,%session)
	
	q:(StDate="")!(EndDate="") "[]"
	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc")
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s CheckLocDesc="",PCCRowID=0
 	..f  s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,PCCRowID)) q:PCCRowID=""  d
 	...i +PCCRowID'=0 d
 	....s CheckLoc = $p(^DHCEMPCC(PCCRowID),"^",3)
 	....q:+CheckLoc=0
 	....s CheckLocDesc = $p(^CTLOC(CheckLoc),"^",2)
 	...s LocInHosp = ..GetPCLHosp(PCLRowID)
 	...q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	...q:CheckLocDesc=""
	...i $d(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc))=0 d
	....s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc)=1
	...e  d
	....s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc)=^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc)+1
	
	s CheckLocTr=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","分诊科室") //hxy 2022-12-05
	s Count=0
	w "["
	s CheckLocDesc="" 
	f  s CheckLocDesc = $o(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc)) q:CheckLocDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid,CheckLocDesc)
	.s Name = CheckLocDesc
	.s Name=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",Name) //hxy 2022-12-05
	.s Data = Name_"^"_Num_"^"_CheckLocTr //"分诊科室"
 	.w $case(Count,0:"",Count:",")
 	.s Count =Count+1
 	.W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	w "]"
 	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid)
	q ""
}

/// 
/// Return:分诊科室所属医院id
ClassMethod GetPCLHosp(PCLRowID)
{
	n (PCLRowID)
	q:+PCLRowID=0 ""
	s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,""))
 	s LocInHosp=""
 	i +PCCRowID'=0 d
 	.s CheckLoc = $p(^DHCEMPCC(PCCRowID),"^",3)
 	.q:+CheckLoc=0
 	.s LocInHosp = $p(^CTLOC(CheckLoc),"^",22)
 	q LocInHosp
}

/// 分诊号别统计数据
/// w ##class(web.DHCEMAnalysessCheckLev).PatCheckCareNum("2022-06-30","2022-06-30","2")
ClassMethod PatCheckCareNum(StDate, EndDate, HospID)
{
	
	n (StDate,EndDate,HospID,%session)
	
	q:(StDate="")!(EndDate="") "[]"
	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare")
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s PAPMIDr=$p(^DHCEMPCL(PCLRowID),"^",1) //hxy 2022-10-20st
 	..q:'$d(^PAPER(PAPMIDr)) //ed
 	..s EmCareProv="",PCCRowID=0
 	..f  s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,PCCRowID)) q:PCCRowID=""  d
 	...i +PCCRowID'=0 d
 	....s EmCareProvID=$p(^DHCEMPCC(PCCRowID),"^",2)
 	....q:+EmCareProvID=0
 	....s EmCareProv=$p(^CTPCP(EmCareProvID,1),"^",2)
 	...s LocInHosp = ..GetPCLHosp(PCLRowID)
 	...q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	...q:EmCareProv=""
	...i $d(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv))=0 d
	....s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv)=1
	...e  d
	....s ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv)=^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv)+1
	
	s CheckLocTr=##class(web.DHCEMCommonUtil).GetTrans("dhcem.checklevdataanalysess.csp","分诊号别") //hxy 2022-12-05
	s Count=0
	w "["
	s EmCareProv="" 
	f  s EmCareProv = $o(^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv)) q:EmCareProv=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckCare",Pid,EmCareProv)
	.s Name = EmCareProv
	.s Name=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",Name) //hxy 2022-12-05
	.s Data = Name_"^"_Num_"^"_CheckLocTr //"分诊号别"
 	.w $case(Count,0:"",Count:",")
 	.s Count =Count+1
 	.W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	w "]"
 	k ^TMP("DHCEM","web.DHCEMAnalysessCheckLev","PatCheckLoc",Pid)
	q ""
}

}
