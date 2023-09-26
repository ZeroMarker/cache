Import sqluser

Class web.DHCEMSkinTest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 皮试结果查询
/// Creator:     congyue
/// CreateDate:  2016-07-30
/// Table: 		 DHCNurSkinTestList
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMSkinTest).FindSkinPPD("12","1","1091||3")
ClassMethod FindOrditemExecute(ByRef qHandle As %Binary, wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, DocSearch As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i userId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	i queryTypeCode="",HospitalRowId="" q $$$OK
 	 
	s tempId=$j
	s rset=##class(%ResultSet).%New("web.DHCCLCom:FindOrditem")
	do rset.Execute(wardId,regNo,tempId,startDate,endDate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId,DocSearch)
	while (rset.Next()) {
		s prtFlag=rset.GetData(1)
		s PatName=rset.GetData(4)
		s PatAge=rset.GetData(6)
		s PatSex=""	//
		s PatLoc=""	//
		s RegNo=rset.GetData(2)
		s TestStartTime="" //
		s ObserveTime="" //
		s arcimDesc=rset.GetData(9)
		s doseQtyUnit=rset.GetData(13)
		s phcfrCode=rset.GetData(14)
		s phOrdQtyUnit=rset.GetData(15)
		s phcinDesc=rset.GetData(16)
		s notes=rset.GetData(17)
		s TestResult=""	//
		s TestUser=""	//
		s TestDateTime=rset.GetData(39)
		s ctcpDesc=rset.GetData(21)
		s createDateTime=rset.GetData(32)
		s EpisodeID=rset.GetData(40)
		s oeoriId=rset.GetData(33)

		s SkinTestFlag=$p($g(^OEORD(+oeoriId,"I",$P(oeoriId,"||",2),5)),"^",2)
		s papmiId=+^PAADM(+EpisodeID)
		i papmiId'="" d
		.s SexId=$p($g(^PAPER(papmiId,"ALL")),"^",7)
		.i SexId'="" s PatSex=$p($g(^CT("SEX",SexId)),"^",2)
		s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    	s EncryptLevel=$p(PatEncryptLevel,"^",1)
    	s PatLevel=$p(PatEncryptLevel,"^",2) 
		s ctlocId=$p(^PAADM(EpisodeID),"^",4)
		i ctlocId'="" s PatLoc=$p(^CTLOC(+ctlocId),"^",2)	
		s TestInfo=..GetSkinInfoByOrder(oeoriId)
		s TestStartTime=$P(TestInfo,"^",1)
		s ObserveTime=$P(TestInfo,"^",2)
		s TestMethod=$P(TestInfo,"^",3)
		s TestResult=$P(TestInfo,"^",4)
		s TestUser=$P(TestInfo,"^",5)
		d OutRow
	}	
	d rset.Close()
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRow
	//s Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),data("seqNo"),data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("placerNo"),data("skinTestDateTime"),EpisodeID,data("specDesc"),data("ordlocDesc"))
 	s Data=$lb(prtFlag,PatName,PatAge,PatSex,PatLoc,RegNo,TestStartTime,ObserveTime,arcimDesc,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,TestResult,TestUser,TestDateTime,ctcpDesc,createDateTime,EpisodeID,oeoriId,SkinTestFlag,TestMethod,EncryptLevel,PatLevel)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// 通过医嘱ID取皮试信息
/// w ##class(web.DHCEMSkinTest).GetSkinInfoByOrder("687||32")
ClassMethod GetSkinInfoByOrder(OeoriDr) As %String
{
	n (OeoriDr,%session)
	//w ##class(web.DHCNurSkinTestList).GetSkinInfoByOrder("77084||18")
	q:OeoriDr="" ""
	s TestStartDateTime="",ObserveTime="",TestMethod="",abnormFlag="",skinTestCtcpDesc="",skinTestAudtiCtcpDesc=""
	s TestResult="",skinTestDateTime="",TestResultDesc=""
	s oeordId=$P(OeoriDr,"||",1),oeoriSub=$P(OeoriDr,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub

	s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("OeoriDr"," "_oeoriId,curId)) q:(curId="")  d
	.s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	.i TestStartDate'="" s TestStartDate=$ZD(TestStartDate,3)
	.s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	.i TestStartTime'="" s TestStartTime=$ZT(TestStartTime)
	.s TestStartDateTime=TestStartDate_" "_TestStartTime
	.s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	.s TestMethod=$ListGet(^User.DHCNurSkinTestListD(curId),14)
	.s TestResult=$ListGet(^User.DHCNurSkinTestListD(curId),15)
	.s TestResultDesc=$ListGet(^User.DHCNurSkinTestListD(curId),16)

	s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
	s TrsY=##class(web.DHCEMCommonUtil).GetTrans("dhcem.skinTest.csp","阳性")
	s TrsN=##class(web.DHCEMCommonUtil).GetTrans("dhcem.skinTest.csp","阴性")
	s abnormFlag=$S(abnorm="Y":TrsY,abnorm="N":TrsN,1:"")
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId'="" d
	.s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
	.i skinTestCtcpId'="" s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
	.s skinTestAuditCtcpId=$p(^DHCORDItem(dhcoriId),"^",13)
	.i skinTestAuditCtcpId'="" s skinTestAudtiCtcpDesc=$p($g(^CTPCP(skinTestAuditCtcpId,1)),"^",2)
	.s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
	.i skinTestDate'="" s skinTestDate=$ZD(skinTestDate,3)
	.s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)
	.i skinTestTime'="" s skinTestTime=$ZT(skinTestTime)
	.s skinTestDateTime=skinTestDate_" "_skinTestTime
	.s skinTestCtcpDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",skinTestCtcpDesc) 
	.s skinTestAudtiCtcpDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",skinTestAudtiCtcpDesc) 
  	s Ret = TestStartDateTime_"^"_ObserveTime_"^"_TestMethod_"^"_abnormFlag_"^"_skinTestCtcpDesc_"^"_TestResult_"^"_skinTestDateTime_"^"_TestResultDesc
  	s Ret = Ret_"^"_skinTestAudtiCtcpDesc
  	q Ret
}

/// Description: 皮试结果查询
/// Creator:     congyue
/// CreateDate:  2016-07-30
/// Table: 		 DHCNurSkinTestList
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 w ##class(web.DHCEMSkinTest).FindSkinPPD("12","1","1091||3")
/// w ##class(web.DHCEMSkinTest).FindSkinPPD("1091||3")
ClassMethod FindSkinPPD(Ordid As %String) As %String
{
	N (rows,page,Ordid)
	S rows=12
	S page=1
	S End = page*rows
	S Start = (page-1)*rows+1
	;S ^tmos("qwedw")=page_","_rows_","_Ordid
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
    S h=0,count=0
    Q:Ordid="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	S oeorid=+Ordid_"||"_$p(Ordid,"||",2)
	S id="" 
	F  S id=$o(^User.DHCNurSkinPPDI("ResultOeoriDr"," "_oeorid,id)) Q:id=""  D
	.S gg=^User.DHCNurSkinPPDD(id)
	.S SkinSity1=$ListGet(gg,7)  //硬结1
	.S SkinSity2=$ListGet(gg,8)   //硬结2
	.S SkinVcl1=$ListGet(gg,9)   //水泡1
	.S SkinVcl2=$ListGet(gg,10)   //水泡2
	.S SkinSwo1=$ListGet(gg,11)   //红肿1
	.S SkinSwo2=$ListGet(gg,12)   //红肿2
	.S SkinNecrosis=$ListGet(gg,13)   //坏死
	.S SkinInflam=$ListGet(gg,14)   //淋巴管炎
	.S SkinSing=$ListGet(gg,15)   //单个
	.S SkinSpora=$ListGet(gg,16)   //散在
	.S oeorid=oeorid   //医嘱id
	.S AdmDr=$ListGet(gg,2)   //就诊id
	.S Date=$ListGet(gg,4)   //置结果日期
	.S Time=$ListGet(gg,5)   //置结果时间
	.S RecUser=$ListGet(gg,3)   //置结果人
	.I $g(SkinSity1)'="" S TestSkinSity=SkinSity1_"mm*"_$g(SkinSity2)_"mm"
	.E  S TestSkinSity=""
	.I SkinVcl1'="" S TestSkinVcl=SkinVcl1_"mm*"_SkinVcl2_"mm"
	.E  S TestSkinVcl=""
	.I $g(SkinSwo1)'="" S TestSkinSwo=SkinSwo1_"mm*"_$g(SkinSwo2)_"mm"
	.E  S TestSkinSwo=""
	.I SkinNecrosis="1" S TestSkinNecrosis="√"
	.E  S TestSkinNecrosis=""
	.I SkinInflam="1" S TestSkinInflam="√"
	.E  S TestSkinInflam=""
	.I SkinSing="1" S TestSkinSing="√"
	.E  S TestSkinSing=""
	.I SkinSpora="1" S TestSkinSpora="√"
	.E  S TestSkinSpora=""
	.S EpisodeID=AdmDr
	.I Date'="" S TestDate=$zd(Date,3)
	.E  S TestDate=""
	.I Time'="" S TestTime=$zt(Time,2)
	.E  S TestTime=""
	.I RecUser'="" S TestUser=$p(^SSU("SSUSR",RecUser),"^",2)
	.E  S RecUser=""
	.S h=h+1
	.;S TempStr=ID_"^"_Code_"^"_Desc_"^"_EventType_"^"_Active
	.S TempStr=TestSkinSity_"^"_TestSkinVcl_"^"_TestSkinSwo_"^"_TestSkinNecrosis_"^"_TestSkinInflam_"^"_TestSkinSing_"^"_TestSkinSpora_"^"_EpisodeID_"^"_oeorid_"^"_TestDate_"^"_TestTime_"^"_TestUser_"^"_id
	
	
	.S ^TMP("DHCEM","web.DHCEMSkinTest","FindSkinPPD",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="TestSkinSity^TestSkinVcl^TestSkinSwo^TestSkinNecrosis^TestSkinInflam^TestSkinSing^TestSkinSpora^EpisodeID^oeorid^TestDate^TestTime^TestUser^id"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCEM","web.DHCEMSkinTest","FindSkinPPD",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCEM","web.DHCEMSkinTest","FindSkinPPD",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 皮试结果查询
/// Creator:     congyue
/// CreateDate:  2016-08-02
/// Table: 		 DHCNurSkinTestList
/// Input:  	 医嘱id
/// Return： 	 皮试结果信息
/// Others:		 W ##class(web.DHCEMSkinTest).ListPatHis(0,6,"1091||3")
ClassMethod ListPatHis(rows, page, Ordid)
{
	N (rows,page , Ordid)
	s Start=page-1*rows+1
	s End=page*rows
	;S ^tmos("qwedw12")=Start_","_End_","_Ordid
    S count=0
    Q:Ordid="" "{""rows"":[],""total"":"_count_"}"
    ;Q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"   ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	W "{""rows"":["
	S oeorid=+Ordid_"||"_$p(Ordid,"||",2)
	S id="" 
	F  S id=$o(^User.DHCNurSkinPPDI("ResultOeoriDr"," "_oeorid,id)) Q:id=""  D
	.S gg=^User.DHCNurSkinPPDD(id)
	.S SkinSity1=$ListGet(gg,7)  //硬结1
	.S SkinSity2=$ListGet(gg,8)   //硬结2
	.S SkinVcl1=$ListGet(gg,9)   //水泡1
	.S SkinVcl2=$ListGet(gg,10)   //水泡2
	.S SkinSwo1=$ListGet(gg,11)   //红肿1
	.S SkinSwo2=$ListGet(gg,12)   //红肿2
	.S SkinNecrosis=$ListGet(gg,13)   //坏死
	.S SkinInflam=$ListGet(gg,14)   //淋巴管炎
	.S SkinSing=$ListGet(gg,15)   //单个
	.S SkinSpora=$ListGet(gg,16)   //散在
	.S oeorid=oeorid   //医嘱id
	.S AdmDr=$ListGet(gg,2)   //就诊id
	.S Date=$ListGet(gg,4)   //置结果日期
	.S Time=$ListGet(gg,5)   //置结果时间
	.S RecUser=$ListGet(gg,3)   //置结果人
	.s PDDResult=$ListGet(gg,17)
	.I $g(SkinSity1)'="" S TestSkinSity=SkinSity1_"mm*"_$g(SkinSity2)_"mm"
	.E  S TestSkinSity=""
	.I SkinVcl1'="" S TestSkinVcl=SkinVcl1_"mm*"_SkinVcl2_"mm"
	.E  S TestSkinVcl=""
	.I $g(SkinSwo1)'="" S TestSkinSwo=SkinSwo1_"mm*"_$g(SkinSwo2)_"mm"
	.E  S TestSkinSwo=""
	.I SkinNecrosis="1" S TestSkinNecrosis="√"
	.E  S TestSkinNecrosis=""
	.I SkinInflam="1" S TestSkinInflam="√"
	.E  S TestSkinInflam=""
	.I SkinSing="1" S TestSkinSing="√"
	.E  S TestSkinSing=""
	.I SkinSpora="1" S TestSkinSpora="√"
	.E  S TestSkinSpora=""
	.S EpisodeID=AdmDr
	.I Date'="" S TestDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date) ;$zd(Date,3)
	.E  S TestDate=""
	.I Time'="" S TestTime=$zt(Time,2)
	.E  S TestTime=""
	.I RecUser'="" S TestUser=$p(^SSU("SSUSR",RecUser),"^",2)
	.E  S RecUser=""
	.;S TempStr=ID_"^"_Code_"^"_Desc_"^"_EventType_"^"_Active
	.S TempStr=TestSkinSity_"^"_TestSkinVcl_"^"_TestSkinSwo_"^"_TestSkinNecrosis_"^"_TestSkinInflam_"^"_TestSkinSing_"^"_TestSkinSpora_"^"_EpisodeID_"^"_oeorid_"^"_TestDate_"^"_TestTime_"^"_TestUser_"^"_id_"^"_$g(PDDResult)
	.S count=count+1

	.Q:count<Start
	.Q:count>End
	
    .W $case(count,Start:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData("TestSkinSity^TestSkinVcl^TestSkinSwo^TestSkinNecrosis^TestSkinInflam^TestSkinSing^TestSkinSpora^EpisodeID^oeorid^TestDate^TestTime^TestUser^id^PDDResult",TempStr)
	W "],""total"":"_count_"}"
	Q ""
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCEM","web.DHCEMSkinTest","FindSkinPPD",pid)
}

/// Description: 判断病人当天 是否在列表中(有无皮试)
/// Creator:     congyue
/// CreateDate:  2016-08-02
/// Table: 		 DHC_MatAdrReport
/// Input:  	 就诊id
/// Return： 	 有,且未做皮试,返回记录ID  无,或已做皮试,返回0  
/// Others:		 W ##class(web.DHCEMSkinTest).IfPatPSEnd(304)
ClassMethod IfPatPSEnd(Adm, oeoriId) As %String
{
	Q:(Adm="")||(oeoriId="") """"_""_""""
	s oeoreId=oeoriId
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
	
	S TestStartTime=""
	S flag=""
	S curDate="" F  S curDate=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate)) Q:(curDate="")!(flag=1)  D
	.Q:($TR(curDate," ","")'=+$h)
	.S curTime="" F  S curTime=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime)) Q:(curTime="")!(flag=1)  D
	..S curId="" F  S curId=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime,curId)) Q:(curId="")!(flag=1)  D
	...S TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	...Q:(TestDate'="") //已做过皮试
	...S TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	...S TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	...S TestOrdId=$ListGet(^User.DHCNurSkinTestListD(curId),11)
	...Q:(TestOrdId'=oeoriId)&&(TestOrdId'=oeoreId)
	...S ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	...I ObserveTime'="" D
	....I ObserveTime["分钟" S ObserveTime=+ObserveTime*60
	....I ObserveTime["小时" S ObserveTime=+ObserveTime*3600
	Q:TestStartTime="" """"_0_""""
	S curtime=$p($h,",",2)
	Q:(curtime-TestStartTime)<ObserveTime 1
  	Q 0
}

/// Description: 存储皮试计时时间信息 
/// Creator:     congyue
/// CreateDate:  2016-08-05
/// Table: 		 DHCNurSkinTestList
/// Input:  	 id 皮试计时信息 parr   typ现有 count:开始计时按钮,test:置皮试结果按钮,call:呼叫按钮
/// Return： 	 0 成功  非0  提示错误  
/// Others:		 W ##class(web.DHCEMSkinTest).Save("","TestAdmDr|616^TestStartDate|^TestStartTime|^RecUser|11^TestOeoriDr|597!!12^ObserveTime|10分钟^TestLocDr|182^TestMethod|静注法","count")
ClassMethod Save(id, parr As %String, typ = "") As %String
{
  	n (id,parr,typ)
  	S l=$L(parr,"^")
	for i=1:1:l
	{
		S itm=$P(parr,"^",i)
		if itm="" continue
		S name=$P(itm,"|")
		S val=$P(itm,"|",2)
		S tmp(name)=val
	}
	if $D(tmp("TestOeoriDr")) {
		S tmp("TestOeoriDr")=$TR($G(tmp("TestOeoriDr")),"!!","||")
	}
	if $G(id)'="" {
		//呼叫
		S IfOverTime=..IfOverTime(id)
		if IfOverTime'="" q IfOverTime 
		S a=##class(User.DHCNurSkinTestList).%OpenId(id)
	}
	else {
		//开始皮试计时,置皮试结果
		if ($G(tmp("TestAdmDr"))'="") {
			b ;1
			S id=..GetIdByAdm($G(tmp("TestAdmDr")),$G(tmp("TestOeoriDr")))
			if (id'=""){
				if typ="count" q """"_"已在皮试病人列表中或已做皮试!"_""""
				S IfOverTime=..IfOverTime(id)
				//if IfOverTime'="" q IfOverTime 
				if IfOverTime'="",typ'="test" q IfOverTime
				S a=##class(User.DHCNurSkinTestList).%OpenId(id)
			}
			else {
				S a=##class(User.DHCNurSkinTestList).%New()
			}
		}
		else {
			q """"_"请先选择一个病人!"_""""
		}
	}
	if $D(tmp("TestAdmDr")) S a.TestAdmDr=tmp("TestAdmDr")
	if $D(tmp("TestStartDate")) S a.TestStartDate=..TransDate($G(tmp("TestStartDate")))
	if $D(tmp("TestStartTime")) S a.TestStartTime=..TransTime($G(tmp("TestStartTime")))
	if $D(tmp("TestDate")) S a.TestDate=..TransDate($G(tmp("TestDate")))
	if $D(tmp("TestTime")) S a.TestTime=..TransTime($G(tmp("TestTime")))
	if $D(tmp("TestCallFlag")) S a.TestCallFlag=tmp("TestCallFlag")
	if $D(tmp("RecUser")) S a.RecUser=tmp("RecUser")
	if $D(tmp("TestOeoriDr")) S a.TestOeoriDr=tmp("TestOeoriDr")
	if $D(tmp("ObserveTime")) S a.ObserveTime=tmp("ObserveTime")
	if $D(tmp("TestLocDr")) S a.TestLocDr=tmp("TestLocDr")
	if $D(tmp("TestMethod")) S a.TestMethod=tmp("TestMethod")
	if $D(tmp("TestResult")) S a.TestResult=tmp("TestResult")
	if $D(tmp("TestResultDesc")) S a.TestResultDesc=tmp("TestResultDesc")	
	D a.%Save()
	//q a.%Id()
	Q """"_0_""""
}

/// 判断从置皮试结果到当前是否超过20分钟
/// "":超过,其它:未超过
ClassMethod IfOverTime(id) As %String
{
	Q:id="" "" 
	S a=##class(User.DHCNurSkinTestList).%OpenId(id)
	S TestStartDate=a.TestStartDate
	S TestStartTime=a.TestStartTime
	I TestStartDate="" Q "请先将病人加入到皮试病人列表中,进行计时!"
	S curDateTime=..GetAbsTime($h)
	S StartDateTime=..GetAbsTime(TestStartDate_","_TestStartTime)
	;I curDateTime-StartDateTime<(20*60) Q "未超过二十分钟!"
	Q ""
}

/// 转换数字格式日期
ClassMethod TransDate(Date) As %String
{
	I (Date'="") {
		I Date["/" Q $zdh(Date,4)
		I Date["-" Q $zdh(Date,3)
		Q Date
	}
	else {
		Q +$h
	}
}

/// 转换数字格式时间
ClassMethod TransTime(Time) As %String
{
	I (Time'="") {
		I $l(Time,":")=2 Q $zth(Time,2)
		I $l(Time,":")=3 Q $zth(Time)
		Q Time
	}
	else {
		Q $p($h,",",2)
	}
}

/// 日期+时间值
ClassMethod GetAbsTime(dt As %String) As %String
{
	S dat=$P(dt,",",1),tim=$P(dt,",",2)
	Q ((dat*86400)+tim)
}

/// 判断病人当天 是否在列表中(有无皮试)
/// 有,且未做皮试,返回记录ID
/// 无,或已做皮试,返回0
/// w ##class(web.DHCEMSkinTest).GetIdByAdm(616,"597||12")
ClassMethod GetIdByAdm(Adm, OeoriDr) As %String
{
	Q:Adm="" ""
	S flag=0,ret=""
	//按医嘱ID查询是否已在皮试病人列表中
	I OeoriDr'="" D 
	.S curId="" F  S curId=$O(^User.DHCNurSkinTestListI("OeoriDr"," "_OeoriDr,curId)) Q:(curId="")!(flag=1)  D
	..s skinTestDate = $lg(^User.DHCNurSkinTestListD(curId),4)   //皮试完成时间
	..q:skinTestDate'=""
	..S flag=1
	..S ret=curId
	
	/*
	I flag'=0 Q ret
	S curDate="" F  S curDate=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate)) Q:(curDate="")!(flag=1)  D
	.Q:($TR(curDate," ","")'=+$h)
	.S curTime="" F  S curTime=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime)) Q:(curTime="")!(flag=1)  D
	..S curId="" F  S curId=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime,curId)) Q:(curId="")!(flag=1)  D
	...S TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)  //qqa 获取皮试日期
	...q:TestDate'=+$h
	*/
	/*
	...I TestDate="" D
	....S flag=1
	....S ret=curId
	...E  D
	....S TestOeoriDr=$ListGet(^User.DHCNurSkinTestListD(curId),11)
	....I OeoriDr'="",OeoriDr=TestOeoriDr D
	.....S flag=1
	.....S ret=curId
	*/
  	Q ret
}

/// Description: 根据日期(默认当天)查询要做皮试病人(皮试时间倒计时查询)
/// Creator:     congyue
/// CreateDate:  2016-08-05
/// Table: 		 DHCNurSkinTestListi   DHCNurSkinTestListD
/// Input:  	 开始日期  皮试标志 科室id
/// Return： 	 皮试结果信息
/// Others:		 W ##class(web.DHCEMSkinTest).GetSkinTestPat(0,6,"64002","","100")
ClassMethod GetSkinTestPat(offset = 0, limit = 10, StartDate As %String, SkinFlag As %String, LocId As %String)
{
	N (offset , limit , StartDate,SkinFlag,LocId,%session)
	
	s TraHour=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","小时") 
	s TraMi=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","分")
	s TraSe=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","秒")
	S End = offset+limit
	S Start = offset+1
    S count=0
    i ($d(%session)&&(LocId="")) d
    .S LocId=%session.Data("LOGON.CTLOCID")
    Q:LocId="" "{""rows"":[],""total"":"_count_"}"
	W "{""rows"":["
 	S ind=1
 	I StartDate="" S StartDate=+$h-1
 	s EndDate=+$H
 	f Date=StartDate:1:EndDate d
 	.s curTime=""
 	.s:Date=StartDate curTime=$p($h,",",2) 
	.f  s curTime=$O(^User.DHCNurSkinTestListI("StartDateTime",Date,curTime)) Q:(curTime="")  D
	..s curId=""
	..f  s curId=$O(^User.DHCNurSkinTestListI("StartDateTime",Date,curTime,curId)) Q:(curId="")  D
	...S TestLocDr=$ListGet(^User.DHCNurSkinTestListD(curId),13)
	...s oeori=$ListGet(^User.DHCNurSkinTestListD(curId),11)
	...s ordStatusId=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",13)  
    ...s ordState=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
    ...q:ordState="D"
	...Q:TestLocDr'=LocId
	...S TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	...Q:(SkinFlag'="on")&(TestDate'="") //已做过皮试
	...S TestTime=$ListGet(^User.DHCNurSkinTestListD(curId),7)
	...I TestTime'="" S TestTime=$ZT(TestTime)
	...S TestAdmDr=$ListGet(^User.DHCNurSkinTestListD(curId),2)
	...Q:TestAdmDr=""
	...S Papmidr=$P($G(^PAADM(TestAdmDr)),"^",1)
	...Q:Papmidr=""
	...S PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	...S RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	...s Allgryparref=$o(^PAPERi("PAPMI_PatNo",RegNo,"")) 
	...s Allgrysub="",Allgryflag="" 
	...i Allgryparref'="" d
	....s Allgrysub=""
	....f  s Allgrysub=$o(^PAPER(+Allgryparref,"ALG",Allgrysub)) q:Allgrysub=""  d ;2016-10-25 congyue
	.....s AllStatus=$p($g(^PAPER(Allgryparref,"ALG",Allgrysub)),"^",8)
	.....q:AllStatus'="A"
	.....s Allgryflag=1  
	...S CardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",Papmidr,""))
	...I CardDr'="" S CardNo=$P($G(^DHCCARD("CF",CardDr)),"^",2)
	...E  S CardNo=""
	...S EpisodeID=TestAdmDr
	...S TestCallFlag=$ListGet(^User.DHCNurSkinTestListD(curId),3)
	...//判断显示颜色,等待(Wait)\过20分钟查看皮试结果(Ready)\呼叫(Call)\已做皮试(Already)
	...S CurStat="Wait"
	...S TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	...S TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	...S ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	...I ObserveTime'="" D
	....I ObserveTime["分钟" S ObserveTime=+ObserveTime*60
	....I ObserveTime["小时" S ObserveTime=+ObserveTime*3600
	...//
	...I +$h=TestStartDate,($P($h,",",2)-TestStartTime)>ObserveTime D
	....I TestCallFlag'="Y" S CurStat="Ready"
	....E  S CurStat="Call"
	...E  D
	....I TestDate="",TestCallFlag="Y" S CurStat="Call"
	...I TestDate'="" S CurStat="Already"
	...S ToObserveTime=""
	...I TestDate="" D
	....S IntervalTime=(+$h-TestStartDate)*86400+($P($h,",",2)-TestStartTime)
	....I ObserveTime>=IntervalTime D
	.....S ToObserveTime=ObserveTime-IntervalTime
	.....S ObserveHour=ToObserveTime\3600
	.....S ObserveMin=ToObserveTime#3600\60
	.....S ObserveSec=ToObserveTime#3600#60
	.....S ToObserveTime=$S(ObserveHour>0:ObserveHour_TraHour,1:"")_$S(ObserveMin>0:ObserveMin_TraMi,1:"")	
	.....I ObserveHour=0,ObserveMin=0,ObserveSec'="" S ToObserveTime=ObserveSec_TraSe
	...I TestStartTime'="" S TestStartTime=$ZT(TestStartTime)
	...s SkinUser = $lg(^User.DHCNurSkinTestListD(curId),10)
	...s SkinLoc = $lg(^User.DHCNurSkinTestListD(curId),13)
	...s TestOeoriDr=$lg(^User.DHCNurSkinTestListD(curId),11)
	...s TestOeoreDr="" ;$lg(^User.DHCNurSkinTestListD(curId),17)
	...i TestOeoreDr="" d
	....s Sub = $o(^OEORD(+TestOeoriDr,"I",$p(TestOeoriDr,"||",2),"X",0))
	....s TestOeoreDr=TestOeoriDr_"||"_Sub
	...s TestMethod=$lg(^User.DHCNurSkinTestListD(curId),14)
	...s ObserveTime=$lg(^User.DHCNurSkinTestListD(curId),12)
	...S ID=curId
	...S TempStr=PatName_"^"_RegNo_"^"_TestStartTime_"^"_ToObserveTime_"^"_TestTime_"^"_CardNo_"^"_EpisodeID_"^"_CurStat_"^"_ID_"^"_SkinUser_"^"_SkinLoc_"^"_Allgryflag_"^"_TestOeoreDr
	...S TempStr=TempStr_"^"_TestMethod_"^"_ObserveTime
	...S count=count+1
	...Q:count<Start
	...Q:count>End
    ...W $case(count,Start:"",:",") 
	...W ##class(web.DHCAPPJsonCommon).getJsonData("PatName^RegNo^TestStartTime^ToObserveTime^TestTime^CardNo^EpisodeID^CurStat^ID^SkinUser^SkinLoc^Allgryflag^TestOeoreDr^TestMethod^ObserveTime",TempStr)
	W "],""total"":"_count_"}"
	Q ""
}

/// Creator: wangxinlei
/// CreatDate: 2009-05-21
/// Description: 判断用户密码是否正确
/// Table：SS_User,CT_CareProv,CT_CarPrvTp
/// Input：userCode: 用户登陆名 passWord: 用户密码
/// Return：成功返回 0^用户ID 失败返回 密码错误
/// Others:		 w ##class(web.DHCLCNUREXCUTE).ConfirmPassWord("1","1")
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String, LocId = "") As %String
{
	s retStr=0
	s:LocId="" LocId=%session.Data("LOGON.CTLOCID")
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误!"
	s IfSameFlag=##class(web.DHCEMSkinTest).IfSameLoc(userId,LocId)
	q:IfSameFlag="0" "非本科室用户，不能进行确认!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	
	s active=$p($g(^SSU("SSUSR",userId)),"^",19)
	q:active'="Y" "用户未激活!"
	
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"

	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s pin=$$ENCR^SSUTIL2(passWord)
	i pin="" s retStr="密码错误"
	e  d
	.i pin'=$p($G(^SSU("SSUSR",userId)),"^",15) s retStr="密码错误"  /// 改为验证用户签名密码 bianshuai 2020-02-21
	zn oldnamespace
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Creator:一个糟老头
/// Descript:皮试计时或者皮试置结果判断费用（不能用于医嘱执行）
/// 		:原液是判断收费情况
/// 		:非原液用药不需判断收费
/// w ##class(web.DHCEMSkinTest).TestPayMoney("1099||8||1")
ClassMethod TestPayMoney(oriOreId) As %String
{
	n (oriOreId)
	s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
#;	s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21) //hxy 2022-07-27 st
#;  s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
#;  s actCode=""
#;  i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
#;  q:(skinTestFlag="Y")&(actCode'="YY") ""
    
    s OecprCode="" 
    s OecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s:OecprId'="" OecprCode=$p($g(^OECPR(OecprId)),"^")
    q:(OecprCode="OM")!(OecprCode="OMST")!(OecprCode="OMLSZT")!(OecprCode="OMCQZT") "" //ed
    
	s isPayManey=""     //1:已经收钱，0：未收钱
    s isJudgeMoney = ##class(web.DHCEMNurExe).IsJudgeMoney(oriOreId) //是否需要判断收费 1：需要  0：不需要
    s:isJudgeMoney=0 isPayManey=1
    s:isJudgeMoney=1 isPayManey = ##class(web.DHCEMNurExe).YetPayManey(oriOreId) 
    q:'isPayManey "未找到病人发票,或病人费用不足！！"
	q ""
}

/// Input:
///  	医嘱ID(必传)
/// 	用户ID(必传)
///     审核用户Code(必传)
///     复核用户Code(必传)
///     皮试结果(Y/N)
///     日期
/// 	时间
///     备注
/// 	是否执行皮试医嘱(1:执行)
/// 	PDD信息
/// Return:0:成功，其他:失败	
/// w ##class(web.DHCEMSkinTest).SetSkinTestResultXH("17||12||1","18850","jzhs01","jzhs01","Y","","","","TestAdmDr|22^TestDate|^TestTime|^RecUser|18850^TestOeoriDr|17!!12^TestSkinSityOne|^TestSkinSityTwo|^TestSkinVclOne|^TestSkinVclTwo|^TestSkinSwoOne|^TestSkinSwoTwo|^TestSkinNecrosis|^TestSkinInflam|^TestSkinSing|^TestSkinSpora|^PPDResult|","","2^50^22^18850")
ClassMethod SetSkinTestResultXH(oriOreId, userId, skinUserCode, skinRecUserCode, flag, SkinDate = "", SkinTime = "", skinNote = "", savePDDInfo = "", skinSize = "", lgParams = "") As %String
{
	//皮试处理
    n (oriOreId,userId,skinUserCode,skinRecUserCode,flag,SkinDate,SkinTime,skinNote,savePDDInfo,skinSize,lgParams,%session)
    ;s ^qqa("SetSkinTestResultXH")=$lb(oriOreId, userId, skinUserCode, skinRecUserCode, flag, SkinDate, SkinTime, skinNote, savePDDInfo, skinSize, lgParams)
    s SKINAUTOEXE=##class(web.DHCEMNurExe).GetConfigBySession("SKINAUTOEXE",lgParams)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
	s TestPayMoney=..TestPayMoney(oeoriId)
    q:TestPayMoney'="" TestPayMoney 
    q:skinUserCode="" "皮试用户不能为空！"
    q:skinRecUserCode="" "皮试复核用户不能为空！"
    s skinUserID="",skinRecUserID="",skinCtpcpDr="",skinRecCtpcpDr=""
    s skinUserID = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(skinUserCode),""))
    s skinRecUserID = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(skinRecUserCode),""))
    s:skinUserID'="" skinCtpcpDr = $p(^SSU("SSUSR",skinUserID),"^",14)
    s:skinRecUserID'="" skinRecCtpcpDr = $p(^SSU("SSUSR",skinRecUserID),"^",14)
    q:skinCtpcpDr="" "皮试人用户未找到医护人员！"
    q:skinRecCtpcpDr="" "皮试审核用户未找到医护人员！"
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    
    s oecprCode="" 
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s:oecprId'="" oecprCode=$p($g(^OECPR(oecprId)),"^")
    s isPayMoney=""
	s:oeoriBilled="P" isPayMoney=1
	s:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMLSZT")!(oecprCode="OMCQZT") isPayMoney=1
    
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(oeordId)
    s isSkinOrd=##class(web.DHCEMSkinTest).IsSkinOrder(oeordId,oeoriSub) 
    ;q:(((payMode'=1)&(stayFlag=1))!(stayFlag'=1))&(isPayMoney'=1)&(isSkinOrd=1) "原液未交费不能置皮试结果" 
    ;i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q "已结算医嘱不能置皮试结果!" //QQA 2017-12-28 取消判断
 
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
	s IfPPDOrder=##class(web.DHCEMSkinTest).GetIfPPDOrder(oriOreId)
	i IfPPDOrder'=1,preFlag=flag q "所置状态与原来相同,未改变皮试状态!"   
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2),skinTestInstr=""
	i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
	s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    s dispStat=##class(web.DHCCLCom).GetDispensingStat(oeoriId,"N") //070911
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	
	s AdmID=$p(^OEORD(+oeordId),"^",1)
	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmID)
	s PatientID=$p(^PAADM(AdmID),"^",1)
	s RegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	
	s passWordAudit=""
	
	
	////qqa 增加事物
	ts
	s ret=0
	
	//修改医嘱备注/PPD试验结果
	i $D(skinNote) s ret=..UpdateOrderNote(oriOreId,skinNote,skinSize)
	tro:ret'=0
	q:ret'=0 "插入PDD实验结果失败！"
	
	///写入扩展表
	s ret =..UpdOEOrdItem(oeoriId,skinCtpcpDr,skinRecCtpcpDr,curDate,curTime)
	tro:ret'=0
	q:ret'=0 "写入DHC_OE_OrdItem表失败！"	
	
	///修改皮试结果
	s ret=..SetSkinResult(oeoriId,flag)
	tro:ret'=0
	q:ret'=0 "置皮试结果失败！"
	
	///皮试计时的置完成
	s ret=..SetSkinTestListResult(oeoriId,flag,skinNote)
	tro:ret'=0
	q:ret'=0 "设置皮试计时队列完成！"
	
	///过敏录入,阳性录入
	s allergyFlag=$g(^DHCDocConfig("HospDr_"_AdmHospID,"ALGCheckConflictOpen"))
	s allergyFlag=$case(allergyFlag,1:"Y",:"N")
	s needInsAllerg = ##Class(DHCDoc.Interface.Inside.ServiceOrd).GetAutoInsertAllergiesFlag(oeoriId)
	i (needInsAllerg="Y")&&(flag="Y") s ret=##class(web.DHCEMSkinTest).UpdatePatAllergy(oeoriId,userId,allergyFlag)
	i (needInsAllerg="Y")&&(flag'="Y") s ret=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.CancelNursePatAllergy",oeoriId,userId) ;返回值：0 成功 其他：失败 需护士站和新产品在修改皮试结果为阴性时调用
	tro:ret'=0
	q:ret'=0 ret
	
	///治疗医嘱同步结果
	s skintest=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)			///皮试勾
	s:isSkinOrd=1 ret=..SynSkinResult(oeoriId,flag,skinCtpcpDr,skinRecCtpcpDr,curDate,curTime,skinNote)
	tro:ret'=0
	q:ret'=0 "同步治疗药试结果失败！"
	
	///执行医嘱
	;s oeoriId = ##class(web.DHCEMInComUseMethod).GetMainOrdItmID(oeoriId)
	s:(isSkinOrd=1)&&(+SKINAUTOEXE'=1) ret=	..AutoExecSkinOrd(oriOreId,lgParams) ;..UpdateOrdGroup("Y",oeoriId,userId,1)  //这里是执行医嘱
	tro:ret'=0
	q:ret'=0 "自动执行医嘱失败！"_ret
	
	///复核皮试结果同时判断密码及置过敏记录
	s ret=##class(web.DHCEMSkinTest).updateAudit(skinRecUserCode,"",oriOreId,flag,RegNo)
	tro:ret'=0
	q:ret'=0 "复核皮试结果同时判断密码及置过敏记录错误！"
	
	///保存PDD医嘱信息
	s:IfPPDOrder=1 ret =##class(User.DHCNurSkinPPD).Save("",savePDDInfo)
	tro:ret'=0
	q:ret'=0 "保存PDD医嘱信息错误！"
	
	tc
	q ret
}

/// w ##class(web.DHCEMSkinTest).AutoExecSkinOrd("17||12||1","2^39^175^18850")
ClassMethod AutoExecSkinOrd(oriOreId, lgParams)
{
	s ord = $p(oriOreId,"||",1)
	s itm = $p(oriOreId,"||",2)
	s sub = $p(oriOreId,"||",3)
	s execStat=##class(web.DHCEMOrdInfoVO).getExecStatCode(ord,itm,sub)
	q:execStat="F" 0  ;已经执行过的不再重复执行
	s mainOrdItm = ##class(web.DHCEMInComUseMethod).GetMainOrdItmID(ord_"||"_itm)
	s mainOrdExec = mainOrdItm_"||"_sub
	s ret = ##class(web.DHCEMNurExe).UpdateOrdGroupNew(mainOrdExec,"F","","","",lgParams,"PSDO","Y")
	q ret
}

/// 治疗医嘱同步结果
ClassMethod SynSkinResult(oeoriId, flag, skinCtpcpDr, skinRecCtpcpDr, curDate, curTime, skinNote = "")
{
	n (oeoriId,flag,skinCtpcpDr,skinRecCtpcpDr,curDate,curTime,skinNote)
	s Rs=0
	s TreatmentOrds = ##Class(web.DHCOEOrderGuideAllergy).GetLinkTreatOrdList(oeoriId)
	s Len=$l(TreatmentOrds,"^")
	f i=1:1:Len q:(Rs'=0)  d
	.s TreatmentOrd=$p(TreatmentOrds,"^",i)
	.q:TreatmentOrd=""
	.s Rs=..SetSkinResult(TreatmentOrd,flag)
	.q:Rs'=0
	.s Rs=..UpdOEOrdItem(TreatmentOrd,skinCtpcpDr,skinRecCtpcpDr,curDate,curTime)
	.q:Rs'=0
	.s Rs=..UpdateOrderNote(TreatmentOrd,skinNote)
	.q:Rs'=0
	
	q Rs
}

/// 置皮试结果扩展表
ClassMethod UpdOEOrdItem(oeoriId, skinCtpcpDr, skinRecCtpcpDr, curDate, curTime)
{
	n (oeoriId,skinCtpcpDr,skinRecCtpcpDr,curDate,curTime)
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" d
	.&sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestAuditCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:skinCtpcpDr,:skinRecCtpcpDr,:curDate,:curTime))
	e  d
	.&sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:skinCtpcpDr,DHCORI_SkinTestAuditCtcp_Dr=:skinRecCtpcpDr,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_RowId=:dhcoriId)
	q SQLCODE
}

/// 置皮试结果
ClassMethod SetSkinResult(oeoriId, flag)
{
	n (oeoriId,flag)
	s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
	&sql(UPDATE OE_OrdItem SET OEORI_Abnormal=:flag WHERE OEORI_RowId=:oeoriId)
	s ^OEORDi(0,"Abnorm",oeordId,oeoriSub)=""			///老版本残留，暂时不去除
	q SQLCODE
}

ClassMethod SetSkinTestListResult(oeoriId, flag, skinNote)
{
	n (oeoriId,flag,skinNote)
	s flag=$case(flag,"N":"(-)","Y":"(+)")
	s skinTestID = $o(^User.DHCNurSkinTestListI("OeoriDr"," "_oeoriId,""),-1)
	q:+skinTestID=0 0
	s curDate=+$h
	&SQL(UPDATE DHCNurSkinTestList SET TestResult=:flag,TestResultDesc=:skinNote,TestDate=:curDate WHERE ID =:skinTestID)
	q SQLCODE
}

ClassMethod setSkin()
{
}

/// 修改医嘱备注/PPD试验结果
/// ^DHCCLSet("Exec","PPDArcimDr")
ClassMethod UpdateOrderNoteBak(oeoriId, skinNote) As %String
{
	s IfPPDOrder=##class(web.DHCEMSkinTest).GetIfPPDOrder(oeoriId)
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)	
	
	s maxIndex=+$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	s lastNote=$G(^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex))
	s:IfPPDOrder'=1 ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote    ///皮试批次
	q:IfPPDOrder'=1 0
	i (lastNote="")!(lastNote["皮肤硬结")!(lastNote["局部水泡")!(lastNote["坏死")!(lastNote["淋巴管炎")!(lastNote["红肿") d
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	e  d
	.s maxIndex=maxIndex+1
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=maxIndex
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	q 0
}

/// 修改医嘱备注/PPD试验结果
/// ^DHCCLSet("Exec","PPDArcimDr")
/// w ##class(web.DHCEMSkinTest).UpdateOrderNote("85||10","77521")
ClassMethod UpdateOrderNote(oeoriId, skinNote, skinSize = "") As %String
{
	s IfPPDOrder=##class(web.DHCNurSkinTestList).GetIfPPDOrder(oeoriId)
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)	
	
	s:skinSize'="" ^OEORD(oeordId,"I",oeoriSub,"SKINPC",1)=skinSize
	
	s maxIndex=+$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	s lastNote=$G(^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex))
	s:IfPPDOrder'=1 ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote    ///皮试批次
	
	q:IfPPDOrder'=1 0
	i (lastNote="")!(lastNote["皮肤硬结")!(lastNote["局部水泡")!(lastNote["坏死")!(lastNote["淋巴管炎")!(lastNote["红肿") d
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	e  d
	.s maxIndex=maxIndex+1
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=maxIndex
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	q 0
}

/// Description:  置皮试批号
ClassMethod UpdTestBatch(oeoriId As %String, skinSize As %String)
{
	n (oeoriId,skinSize)
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	s:skinSize'="" ^OEORD(oeordId,"I",oeoriSub,"SKINPC",1)=skinSize
	q 0
}

/// Descript:插入过敏记录
/// Creator:qqa
/// CreatorDate:2020-06-24
/// w ##class(web.DHCEMSkinTest).UpdatePatAllergy("2766||7","13806","Y")
ClassMethod UpdatePatAllergy(oeoriId, userId, allergyFlag) As %String
{
   //无当前药品则插入
    n (oeoriId,userId,allergyFlag)
    q:(allergyFlag'="Y")&(allergyFlag'="N") 0
    
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    q:dhcoriId="" "置皮试信息失败!"
    s curDate=+$h,curTime=$p($h,",",2)
    
    s algId=$p(^DHCORDItem(dhcoriId),"^",5)
    s papmiId=+algId,algSub=+$p(algId,"||",2)
    i allergyFlag="N" d
	.i (algId'="") d
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",19)="Y"
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",8)="I"
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",16)=userId
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",23)=curDate
	..s $p(^PAPER(papmiId,"ALG",algSub),"^",24)=curTime
	..s $p(^DHCORDItem(dhcoriId),"^",5)=""
	
	;无论是否开启过敏冲突，均插入过敏记录
    ;i allergyFlag="N" q 0
    ;i (allergyFlag="Y")&(algId'="")&($p($g(^PAPER(papmiId,"ALG",algSub)),"^",19)="N") q 0
    
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "无药品指针!"
    k PLIST
    s PLIST(0)=+^PAADM(+^OEORD(oeordId)) //ALG_PAPMI_ParRef
    s PLIST(3)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11) //ALG_CTPCP_DR暂用下医嘱医生
    s PLIST(8)="" //ALG_Type_DR 取不到
    s PLIST(11)="A" //ALG_Status
    s PLIST(12)=curDate //ALG_Date
    s PLIST(13)=curDate //ALG_OnsetDate
    s PLIST(18)=curTime //ALG_Time
    s PLIST(19)=userId //ALG_UpdateUser_DR
    s PLIST(22)="N" //ALG_InActive
    s PLIST(23)=1 //ALG_LastUpdateHospital_DR
    s PLIST(24)="" //ALG_Severity_DR
    s PLIST(26)=curDate //ALG_LastUpdateDate
    s PLIST(27)=curTime //ALG_LastUpdateTime
    s PLIST(31)=+phcdfId //ALG_PHCDM_DR
    s PLIST(33)="" ;$o(^MRC("AT",0,"MRCAA_Desc","药物","")) //ALG_MRCAllType_DR
    s PLIST(34)=arcimId
    s PLIST(40)=oeordId_"||"_oeoriSub  //ALG_SkinTestOEORI_DR
    //w !,PLIST(0)_","_PLIST(3)_","_PLIST(8)_","_PLIST(11)_","_PLIST(12)_","_PLIST(13)_","_PLIST(18)_","_PLIST(19)_","_PLIST(22)_","_PLIST(23)_","_PLIST(26)_","_PLIST(27)_","_PLIST(31)_","_PLIST(33)
    &sql(Insert into PA_Allergy Values PLIST())
    i SQLCODE q "过敏记录插入有误!"
    ;s $p(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2)),"^",30)=PLIST(0)_"ALG"_$p(%ROWID,"||",2)
    s $p(^DHCORDItem(dhcoriId),"^",5)=%ROWID
    s $P(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2),"DHC"),"^",3)=allergyFlag
    q 0
}

/// w ##class(web.DHCEMSkinTest).UpdateOrdGroup("Y","610||76","4636","1","")
ClassMethod UpdateOrdGroup(setSkinTest, oreStr, userId, setExecFlag, excuteAndPrintFlag = "")
{
    //exDateTime 参数更新为setSkinTest,为"Y"是置皮试结果调用
    //setExecFlag=1 执行,=0撤消
    //执行关联医嘱	param="Y^"+basedose+"^"+curExecStatDesc+"^"+userId+"^"+oeoriId+"^"+arcicId;
    //^OEORDi(0,"NotExecE",{OE_Order.OEORD_RowId},{OEORE_ExStDate},
    //   +{OEORE_ExStTime},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
    n (setSkinTest,oreStr, userId,setExecFlag,excuteAndPrintFlag)
    s oeoreId=$p(oreStr,"^",1)
    s seatNo=$p(oreStr,"^",2)
    s userDeptId=$p(oreStr,"^",3)  //ypz 070125
    //ypz 070213 begin
    s statDesc=$p(oreStr,"^",4) 
    i statDesc="" d //门诊不弹出界面，为空的情况
        .s statId=$o(^OEC("STAT",0))
        .s statDesc=$p(^OEC("STAT",statId),"^",2)
    //ypz 070213
    s queryTypeCode=$p(oreStr,"^",5)  //ypz 070528
    s execDate=$p(oreStr,"^",6)
    s execTime=$p(oreStr,"^",7)
    s DrugCell=$p(oreStr,"^",8) // + wxl 090301
    //s ^TMPNurOPDebug("execS")=oreStr_"|"_execDate_"|"_execTime
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    q:(setSkinTest'="Y")&(mainOeoriId'="")&(setExecFlag=1) 0 //非置皮试的从医嘱不执行
    q:(setSkinTest'="Y")&(mainOeoriId'="")&(setExecFlag'=1)&(abnorm'="Y") 0 //非置皮试非皮试阳性从医嘱不能撤消
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
    i ordStatCode="E",setExecFlag'="1",arcicOrderType'="R" q "医嘱状态为执行,不能撤消!" //ypz 070204
    i ordStatCode="D",setExecFlag'="1" q "医嘱状态为停止,不能撤消!"
    //ypz 070213 begin
    s skinTest="",resStr=0
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) //,skinTestInstr="" //ypz 070318
    //i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) //ypz 070318
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    //i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(skinTestFlag="Y")&(abnorm="") s resStr="请先置皮试结果!"
    q:(skinTestFlag="Y")&((abnorm="")!(abnorm=" "))&(setExecFlag=1) "请先置皮试结果!" ;s resStr="请先置皮试结果!"

    //ypz 070413 主医嘱不控制//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(skinTestFlag="Y")&(abnorm="Y") s resStr="皮试阳性!"
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070411
    q:oecprCode="" "医嘱优先级为空!" //ypz 070411    
    
    i (setSkinTest'="Y")&(setExecFlag=1) s resStr=##Class(web.DHCCLCom).CanExecSkinTestOrd(oeoriId)
    i (resStr'=0) q resStr

    //ypz 070413//s exDate=$zdh($p(exDateTime," "),3)
    //ypz 070413//s exTime=$zth($p(exDateTime," ",2))
    s arcimStr=..GetArcim(oeoriId)
    s dose=$p(arcimStr,"^",2) //ypz 070204
    //s oecprDesc=$p(arcimStr,"^",3) //ypz 070413
    //s para="Y^"_dose_"^完成^"_userId_"^"_oeoreId_"^"_""_"^"_seatNo_"^"_userDeptId
    s para="Y^"_dose_"^"_statDesc_"^"_userId_"^"_oeoreId_"^^"_seatNo_"^"_userDeptId_"^"_queryTypeCode_"^"_execDate_"^"_execTime //ypz 070213改进
    i setExecFlag="1" d
        .//ypz 070105 begin
        .;i (setSkinTest'="Y")&(skinTestFlag="Y")&(abnorm="Y") q
        .s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 061113
        .i arcimId="" s resStr="无医嘱项!" q  //ypz 061113
        .s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 061113
        .s arcicOrdType=$p(^ARC("IC",arcicId),"^",7)
        .s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
        .s EpisodeID=+^OEORD(oeordId),feeRetStr=""
        .s printFlag=##class(web.DHCNurCom).getPrintFlag(oeoriId)
        .i (excuteAndPrintFlag="")&(arcicOrdType="L")&&(printFlag'["P") s resStr="请先打印检验条码再执行!" q
        .s userDeptId=$p($G(^PAADM(EpisodeID)),"^",4)
        .s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    	.s payMode= ##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(oeordId) 
    	.s orderDep=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",3)
        .s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(orderDep)
        .//i arcicOrdType'="R" s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, oeoriId_$c(2)_phOrdQty,"NE")
        .i (payMode=1)&&(checkLocDeposit=0)&(stayFlag=1) s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, oeoriId_$c(2)_phOrdQty,"NE")
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") s resStr="费用不足,不能执行!" q
        .s feeflag="1"              //lrl
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="Y") d     //lrl
        ..
        ..s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE(EpisodeID,$p(feeRetStr,"^",3), arcimId)
        .i feeflag="0" s resStr="费用不足,不能执行!" q                   //lrl
        .//ypz 070105 end
        .s resStr=..UpdateExecStat("","",para,"")
        .i resStr=0 s resStr=..UpdateDHCPAPatMas(oeoriId,DrugCell,userId) // + 修改DHC_PA_PatMas扩展表 wxl 090301
        .d ..UpdatespecCollDatetime(oeoriId,userId)  ///更新采血时间
    e  d
        .s resStr=..UndoUpdateExecStat(oeoreId,"","",userId) //ypz 070413 oecprDesc,userId)
        .//d ..CancelspecCollDatetime(oeoreId)   ///撤销执行时撤销采血时间，没想好要不要这样做
        .//s ^Gd=oeoreId_"   "_oecprDesc_"  "_userId
    i resStr'=0 q resStr
    //2017-3-23
    //置皮试剂阴阳性时跟其成组的氯化钠同时执行
    //这里只是皮试执行用到
    //i (setSkinTest="Y") q resStr //ypz 070413 置皮试为主医嘱时，从医嘱不执行
    //s ^TMPNurOPDebug(oeordId,oeoriSub)=oeoriId
    i resStr=0 s rtn=##Class(web.UDHCJFBILL).BILLN(+^OEORD(oeordId),userId,oeoriId) //ypz 070105
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")!(resStr'=0)  d
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId) //ypz 070204
        .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
        .q:ordStatCode="U" //ljw 091124 跳过作废的
        .//s ^TMPNurOPDebug(oeordId,curOriSub)=oeoriId
        .s arcimStr=..GetArcim(oeordId_"||"_curOriSub)
        .s dose=$p(arcimStr,"^",2) //ypz 070204
        .//s oecprDesc=$p(arcimStr,"^",3) //ypz 070413
        .//ypz 080908 rem//i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",curOriSub,"X",0)) //ypz 070413//$o(^OEORDi(0,"NotExecE",oeordId,exDate,exTime,curOriSub,0))
        .//ypz 080908 rem//i admType="I",setExecFlag="1" s oeoreSub=""
        .s curOreId=oeordId_"||"_curOriSub_"||"_oeoreSub  //s arcimId=$p($g(^OEORD(oeordId,"I",curOriSub,1)),"^",2)
        .//s para="Y^"_dose_"^完成^"_userId_"^"_curOreId_"^"_""_"^"_seatNo  //
        .s para="Y^"_dose_"^"_statDesc_"^"_userId_"^"_curOreId_"^^"_seatNo_"^"_userDeptId_"^"_queryTypeCode_"^"_execDate_"^"_execTime  //ypz 070213改进
        .
        .i setExecFlag="1" d
            ..s resStr=..UpdateExecStat("","",para,"")
        .e  d
            ..s resStr=..UndoUpdateExecStat(curOreId,"","",userId) //ypz 070413 oecprDesc, userId)
    q resStr
}

ClassMethod GetArcim(oeoriId)
{
    n (oeoriId)
    q:oeoriId="" ""
    s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s scrip=$p(arcimId,"||")
	s ver=$p(arcimId,"||",2)
	s arcimDescAll=$p(^ARCIM(scrip,ver,1),"^",2)
	s arcimDesc=arcimDescAll  //$p(arcimDescAll,"(",1)
	s arcimDesc=$p(arcimDesc,"#",1)
	s arcimDesc=$p(arcimDesc,"$",1)
	;s arcimDesc=$p(arcimDesc,"*",1)  //dj20111021
	s arcimDesc=$p(arcimDesc,"@",1)
	;s arcimDesc=$p(arcimDesc,"[",1)
	;s arcimDesc=$p(arcimDesc,"(",1)
	i $p(arcimDescAll,"-",2)'="" s arcimDesc=arcimDesc_"("_$p(arcimDescAll,"-",2)  //ypz 060903
	
	s seqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    i seqNo'="" s arcimDesc="____"_arcimDesc  //ypz 060617 val("arcimDesc")="____"_sortOriSub_val("arcimDesc")
    s ordEffDesc=##Class(web.DHCNurCom).GetOrdEffDesc(oeoriId) //ypz 070621
    i (ordEffDesc'="")&(ordEffDesc'=0) s arcimDesc=arcimDesc_"("_ordEffDesc_")" //ypz 070621

	//显示皮试
	s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    //ypz 061128 begin
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s arcimDesc=arcimDesc_"(皮试:"_actDesc_")"
    //ypz 061128
    i (skinTestFlag="Y")!(actCode="YY") d  //ypz 061128
        .s skinTestCtcpDesc=""
        .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
        .i dhcoriId'="" d
            ..s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
            ..i skinTestCtcpId'="" s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
        .i (abnorm="N") s arcimDesc=arcimDesc_" (-)" q  //_skinTestCtcpDesc q
        .i (abnorm="Y") s arcimDesc=arcimDesc_" (+)"  //_skinTestCtcpDesc
        .i (abnorm="") s arcimDesc=arcimDesc_" ( )"
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    s unitUomId="",unitDesc="" //ypz 060427
    i doseQty'="" d
        .s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
        .i $p(doseQty,".",1)="" s doseQty="0"_doseQty
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    s dose=doseQty_" "_unitDesc
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	i phcfrId'="" s phcfrCode=$p(^PHCFR(phcfrId),"^",3) //ypz 070418 统一取
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
    i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)

    s oriNote=""
    f i=1:1:+$g(^OEORD(oeordId,"I",oeoriSub,"DEP",0)) d
    	.i oriNote'="" s oriNote=oriNote_" "
    	.s oriNote=oriNote_(^OEORD(oeordId,"I",oeoriSub,"DEP",i))
    s arcimStr=arcimDesc_"^"_dose_"^"_$g(oecprDesc)_"^"_$g(phcfrCode)_"^"_$g(phcinDesc)_"^"_oriNote  //ypz 070204"|"->"^"
    q arcimStr
}

ClassMethod UpdateExecStat(itmjs As %Library.String = "", itmjsex As %Library.String = "", param As %String, skinTestCode As %String)
{
    //n oeordId,oeoriSub,ok,arcicId,oeoriId,unit,num,uom,uomid,stat,statid,usr,ssusr,ctpcpId,dat,tim,ret  ;xuqy 2005-04-20
    n (itmjs,itmjsex,param,skinTestCode)
    s newid=""
    s skinTestCode=$g(skinTestCode)
    s ok=1
    s exeMark=$p(param,"^",1)  ;标记:Y/S/X 
    s oeoriId=$p(param,"^",4)    ;Oeori_rowid
    s arcicId=$p(param,"^",5)   ;判断是否为输血类或其它处置/治疗类 
    
    s now=$zt($p($h,",",2))
    
    i exeMark="X" d            ;如果是停止医嘱
        .s men=$p(param,"^",3)
        .&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
        .s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
        .s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
        .s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    
    i exeMark="S" d            ;如果是长期医嘱或处置/治疗类 
        .i (arcicId=90)!(arcicId=228) d  ;如果是输血类或其它处置/治疗类?在此执行
            ..s statid=7    ;完成状态设为完成(7为完成)
            ..s usr=$p(param,"^",3)   ;执行人姓名和ctpcpId码
            ..&sql(select SSUSR_CareProv_DR,SSUSR_Name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
            ..s dat=+$h,tim=$p($h,",",2)   ;执行的日期和时间
            ..s PLIST(26)=dat,PLIST(26)=dat,PLIST(27)=tim,PLIST(35)=$h,PLIST(37)=ctpcpId,PLIST(40)=7
            ..s PLIST(41)=0,PLIST(42)=0,PLIST(43)="TB"_$c(1)_"To Bill",PLIST(46)=dat,PLIST(47)=tim
            ..s ok=$$insert^MVBOEEXE(oeoriId)
        .e  d
            ..s men=$p(param,"^",3)
            ..&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
            ..s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
            ..s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
            ..s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    ;如果是即刻医嘱或处置/治疗类    ;Y^1^完成^777^8412||395^49
    i exeMark="Y" d 
        .s ok=0
        .s userId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .//s arcicId=$p(param,"^",6)
        .s oeoriId=$p(param,"^",5)         ;医嘱RowId或医嘱执行RowId
        .s seatNo=$p(param,"^",7)
        .s userDeptId=$p(param,"^",8) //ypz 070125
        .s queryTypeCode=$p(param,"^",9) //ypz 070528
        .s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
        .s execDate=$p(param,"^",10)
        .i execDate'=""  s execDate=$zdh(execDate,4)
        .i execDate="" s execDate=curDate
        .s execTime=$p(param,"^",11)
        .i execTime'="" s execTime=$zth(execTime)
        .i execTime="" s execTime=curTime
        .s execTime=+execTime
        .i ((execDate>curDate)!((execDate=curDate)&(execTime>curTime))) d
            ..s execDate=curDate,execTime=curTime
        .s wardId=""
        .i userDeptId'="" s wardId=$O(^PAWARD(0,"WARD_LocationDR",userDeptId,""),-1)
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .i ($g(oeordId)="")!($g(oeoriSub)="") s ok="医嘱项不能为空!" q
		.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.i (oeordId="62")&(oeoriSub="2") s ^tmeo245(1)=execDate_"^"_sttDate_"^"_execTime_"^"_sttTime
		.//i ((execDate<sttDate)!((execDate=sttDate)&(execTime<sttTime))) s ok="执行时间不应大于开始时间!" q
        .s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 061113
        .i arcimId="" s ok="无医嘱项!" q  //ypz 061113
        .s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 061113
        .s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
        .s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //ypz 060707自备药
        .i oecprId="" s ok="无医嘱优先级!" q
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070413
        .i oecprCode="" s ok="无医嘱优先级!" q //ypz 070413
        .//s oecprDesc=$p($g(^OECPR(oecprId)),"^",2) //ypz 070413
        .//s ^TMPNurOPDebug(oeoriId,1)="/1:"
        .s canDo=0
        .//i (admType'="I")&(oecprDesc'["自备药") s canDo=..CanUpdateExec(oeoriId,userId) //ypz 070413
        .s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	    .q:(ordstat="D")!(ordstat="U")!(ordstat="C")
        .i (admType'="I")&(oecprCode'["OM")&(oecprCode'["OMST") s canDo=..CanUpdateExec(oeoriId,userId) //ypz 070413
        .i (canDo'=0)&(canDo'="-1")&(canDo'="-2") s ok=canDo q
        .s unit=$p(param,"^",2)
        .s num=+$p(unit," ",1)
        .s uom=$p(unit," ",2)
        .i (num[".")&(num<1) s num="."_$p($g(num),".",2)
        .;&sql(select ctuom_rowid into :uomid from ct_uom where ctuom_desc=:uom)
        .;s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .;s uomid=$o(^CT("UOM",0,"Desc",uom,"")) ,uomid=$g(uomid)
        .i uom="" d
            ..s uomid=""
        .e  d
            ..s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .s stat=$p(param,"^",3),stat=$g(stat) ;完成状态
        .;&sql(select stat_rowid into :statid from OEC_Order_AdminStatus where stat_desc=:stat)
        .////????s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
        .////????i (dhcoriId'="")&($p(^DHCORDItem(dhcoriId,1),"^",1)="A") s ok="该医嘱已通过退费审核!不能执行!" q
        .//s ^TMPNurOPDebug(oeoriId,2)="/2"
        .
        .s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)  //皮试
        .s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
        .//ypz 061128 begin
        .s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
        .s actCode=""
        .i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
        .//ypz 061128
        .//s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) //,skinTestInstr=""
        .//i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
        .s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
        .
        .//i ((skinTestFlag="Y")!(actCode="YY"))&(stat'="过敏")&(abnorm="") d
            .//.////s setRet=..SetSkinTestResult(oeordId_"||"_oeoriSub,"N")
        .//ypz 070914//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&((skinTestFlag="Y")!(actCode="YY"))&(abnorm="")  s ok="未皮试医嘱不能执行!"  q
        .s statid=$o(^OEC("STAT",0,"Desc",$$ALPHAUP^SSUTIL4(stat),""))
        .
        .//&js<alert("come in class "+"#(userId)#"+"/");>
        .;&sql(select ssusr_careprov_dr,ssusr_name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
        .//s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usr),""))
        .//s ssusr=$g(ssusr)
        .s ctpcpId=$p(^SSU("SSUSR",userId),"^",14) //SSUSR_CareProv_DR
        .//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"3/"_ctpcpId
        .i ctpcpId="" s ok="请以医护人员身份登录后操作!" q //ypz 060430 用户不是医护人员时提示
        .;s userName=$p(^SSU("SSUSR",ssusr),"^",2)
        .
        .s feeRetStr="",EpisodeID=+^OEORD(oeordId)
        .i admType="I" d 
        	..q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	
        	..i oeoreSub'="" d
        	...s insAttStr=..GetAttOrdStr(oeoriId_"||"_oeoreSub)
        	..e  s insAttStr=..GetAttOrdStr(oeoriId)
        	..q:insAttStr=""
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,32)=insAttStr
        	..s addAmount=0
        	..f iAtt=1:1:$l(insAttStr,"^") d
        		...s attItem=$p(insAttStr,"^",iAtt)
        		...s insArcimId=$p(attItem,$c(2))
        		...s insQty=$p(attItem,$c(2),2)
        		...s patType=$p(^PAADM(EpisodeID,1),"^",6)
        		...s insType=$p(^PAADM(EpisodeID,1),"^",7)
        		...s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(patType,insType,insArcimId,+$h,"","","","")
        		...s addAmount=addAmount+(insQty*retPrice)
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,"add")=addAmount
        	..s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, addAmount,"OE")
        .//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,4)=feeRetStr
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") s ok="费用不足,不能执行!" q
        .
        .i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d  //无执行记录
            ..//&js<alert("come in oeore i "+"#(oeordId)#"+"/"+"#(oeoriSub)#");>
            ..s PLIST(0)=oeoriId
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
            ..s PLIST(41)=0    ;OEORE_PhQtyIss
            ..s PLIST(42)=num      ;剂量OEORE_QtyAdmin
            ..s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
            ..s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
            ..s PLIST(46)=execDate      ;日期OEORE_DateExecuted
            ..s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
            ..s PLIST(50)=seatNo   ;OEORE_SignFile 座位号
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..i SQLCODE s ok="执行记录插入有误!"
            ..s oeoreId=$g(%ROWID)
        .e  d  //有执行记录
        ..i admType="I",oeoreSub="" d  //住院非PDA执行
        ...s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:oeoreSub=""  d
        ....s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
        ....s curCtcpId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)   ;//1 changed to oeoreSub !! OEORE_CTPCP_DR
        ....i $g(curCtcpId)="" d
        .....s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
        .....//s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
        .....s PLIST(42)=num      ;剂量OEORE_QtyAdmin
        .....s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
        .....s PLIST(46)=execDate      ;日期OEORE_DateExecuted 
        .....s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
        .....s PLIST(50)=seatNo   ;OEORE_SignFile 座位号 //ypz 060531    //OEORE_Order_Status_DR=:statid,
        .....&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:execDate,
                   OEORE_TimeExecuted=:execTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
        .....i SQLCODE s ok="执行记录修改有误!"
        .....i SQLCODE=0 s $P(^OEORD($P(oeoreId,"||",1),"I",$P(oeoreId,"||",2),"X",$P(oeoreId,"||",3)),"^",16)=statid
        .....s ok=..UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
        .....i ok'=0 q
        ..e  d  ////住院PDA执行或门急诊
        ...i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
        ...s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
        ...//w "oeoreId="_oeoreId,!
        ...//s ret=$$select^MVBOEEXE(oeoreId)  ;取出原有数据
        ...//s ^TMPNurOPDebug(oeordId,oeoriSub,11)=oeordId_"/"_oeoriSub_"/"_oeoreSub
        ...s curCtcpId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)   ;//1 changed to oeoreSub !! OEORE_CTPCP_DR
        ...//&js<alert("come in oeore else "+"#(oeordId)#"+"/"+"#(oeoriSub)#"+"/"+"#(curCtcpId)#"+"/");>
        ...;i $g(PLIST(37))="" d
        ...i $g(curCtcpId)="" d
        ....;i (num[".")&(num<1) s num="."_$p($g(num),".",3)
        ....s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
        ....s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
        ....s PLIST(42)=num      ;剂量OEORE_QtyAdmin
        ....s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
        ....s PLIST(46)=execDate      ;日期OEORE_DateExecuted 
        ....s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
        ....s PLIST(50)=seatNo   ;OEORE_SignFile 座位号 //ypz 060531
        ....//&js<alert("come in oeori else "+"#(num)#"+"/"+"#(ctpcpId)#"+"/"+"#(statid_" "_uomid_" "_dat_"-"_tim)#"+"/");>
        ....////ypz add .
        ....//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
        ....&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,OEORE_Order_Status_DR=:statid,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:execDate,
                   OEORE_TimeExecuted=:execTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
        ....i SQLCODE s ok="执行记录修改有误!"
        .//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/4"_ok
        .i ok'=0 q
        .s resStr=0
        .i (admType'="I")&(oeoreSub'="")&(canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s resStr=..AdjustStock(oeoreId) //ypz 070413
        .i (resStr'=-1)&(resStr'=-2) s ok=resStr
        .i admType="I" d 
        ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
        ..s oeoreId=oeoriId_"||"_oeoreSub
        .i ok'=0 q
        .s ok=..UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
        .//i oeoreId'="" d //修改执行扩展表
        	.//.s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	.//.i dhcoreId="" d
        	    .//..&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Ssuser_Dr,DHCORE_OEORE_Date,DHCORE_OEORE_Time,DHCORE_CTLOC_Dr,DHCORE_QueryCode) Values(:oeoreId,:userId,:curDate,:curTime,:userDeptId,:queryTypeCode))
        	.//.e  d
        	    .//..&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:userId,DHCORE_OEORE_Date=:curDate,DHCORE_OEORE_Time=:curTime,DHCORE_CTLOC_Dr=:userDeptId,DHCORE_QueryCode=:queryTypeCode where DHCORE_RowId=:dhcoreId)
        	.//.s ok=SQLCODE
        .i ok'=0 q
        .i admType="I" d 
        	..q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	..q:insAttStr=""
         	..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
         	..q:phcinId=""
        	..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        	..q:phcfrId=""
        	..s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
        	..//s ^TMPNurOPDebug(oeordId,oeoriSub,34)=arcimId_"/"_userDeptId
       		..TStart
        	..s isAbort=0
        	..f iInst=1:1:$l(insAttStr,"^")  d
        		...s insItem=$p(insAttStr,"^",iInst)
        		...s arcimId=$p(insItem,$c(2)),qty=$p(insItem,$c(2),2)
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,35)=userId_"/"_oeordId_"/"_arcimId_"/"_qty_"/"_userDeptId
        		...;s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,36)=retInsord
        		...;i retInsord'=0 s isAbort=1
        								
					
        		...s retInsord=..InsertOrdItems(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","","Y")
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,36)=retInsord
        		...//i retInsord'=0 s isAbort=1
				...//返回用法关联医嘱RowID//执行医嘱与新插入医嘱关联^DHCNurExecAttachOrd
        		...s retok=$P(retInsord,"^",1)
        		...s AttOrdId=$P(retInsord,"^",2)
        		...i retok=0 d
        		....i oeoreSub'="" d
        		.....s ^DHCNurExecAttachOrd(oeordId_"||"_oeoriSub_"||"_oeoreSub,AttOrdId)=""
        		....e  s ^DHCNurExecAttachOrd(oeordId_"||"_oeoriSub,AttOrdId)=""
        		...i retok'=0 s isAbort=1
        	
        	..i isAbort TRollBack  s insTimes=0 q
        	..TCommit
        	..s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
        	..s insTimes=phfactor-maxPhfactor
        	..i insTimes<0 s insTimes=0
        	..i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
        	..q //下面程序不执行
        	..//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/5"
        	..//k ^TMPNurOPDebug
        	..k inattList
        	..s inattId="",itmmstStr=""
        	..f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        	    ...s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        	    ...q:inattType=""
        	    ...s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        	    ...q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        	    ...i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        	    ...i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        	    ...s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
        	    ...
        	..//m ^TMPNurOPDebug("inList")=inattList
        	..s inattType=""
        	..f  s inattType=$o(inattList(inattType)) q:(inattType="")!(ok'=0)  d
        		...i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        		...i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
        		...//s ^TMPNurOPDebug("in")=$g(^TMPNurOPDebug("in"))_"///"_oeoriId_":"_inattType_"/"_inattList(inattType)_"/"_phcinId_"/"_phfactor_"/"_userId_"/"_oeordId_"/"_userDeptId
        	..s ok=..insertAttOrd(.inattList,phcinId,phfactor,userId, oeordId,userDeptId)

        //s retval=itmjs_"('"_$ZCVT(ok,"O","JS")_"');"  //ypz 060615
        //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ok,"O","JS")_"');"  //060615
        //&javascript<#(retval)#>  //060615
    q ok
}

/// 修改DHC_PA_PatMas 门诊输液 注射单执行
ClassMethod UpdateDHCPAPatMas(oeoriId, DrugCell, userId) As %String
{
	n (oeoriId, DrugCell, userId)
    i oeoriId="" q ""
    s curDate=+$h,curTime=$p($h,",",2)
    s EpisodeID=+^OEORD(+oeoriId)
    q:EpisodeID="" "无就诊ID!"
    s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	&sql(update DHC_PA_PatMas set PAPMI_DrugCell=:DrugCell,PAPMI_DrugCellUser_Dr=:userId,PAPMI_DrugCellDate=:curDate,PAPMI_DrugCellTime=:curTime where PAPMI_RowId=:PaitentID)
    q SQLCODE
}

/// /门诊护士执行时更新采血时间
ClassMethod UpdatespecCollDatetime(oeoriId As %String, userId As %String)
{
 
   n (oeoriId,userId)
   s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
   s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
   q:labNo="" ""   ///标本号为空的认为不是检验医嘱
   i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
   q:oeoreSub="" ""
   s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
   s curDate=+$h,curTime=$p($h,",",2)
   ts
   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj) tro  q ""
   s SpecCollUserDR=obj.OEORESpecCollUserDR
   i SpecCollUserDR'="" tro  q ""  ///已经采血过的不再更新
   s obj.OEORESpecCollUserDR=##class(User.SSUser).%OpenId(userId)
   s obj.OEORESpecCollDate=curDate
   s obj.OEORESpecCollTime=curTime
   b ;123
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   tro
	   q ret
   }
   tc
   q 0
}

/// 	;撤消已处理记录
ClassMethod UndoUpdateExecStat(oeoreId, arcicId, oecprDesc, userId)
{
 //入参arcicId, oecprDesc不起作用 070413
	n (oeoreId, arcicId, oecprDesc, userId)
	s oeordId=$p($g(oeoreId),"||",1) //oeoriId为医嘱或医嘱执行的RowId
	s oeoriSub=$p($g(oeoreId),"||",2)
	s oeoreSub=$p($g(oeoreId),"||",3) //ypz 060308
	s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 070413
    i arcimId="" q "无医嘱项!" //ypz 070413
    s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 070413
	s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070413
	q:oecprCode="" "无医嘱优先级!" //ypz 070413
	
	s ctcpName=""
	&sql(select ssusr_careprov_dr->ctpcp_desc into :ctcpName from ss_user where ssusr_RowId=:userId)
	k PLIST
	s resStr=0
	//&js<alert("ctcpName="+"#($g(ctcpName))#"+"/");>
	////i oecprDesc["长期" d   ;长期医嘱删除处理
	////    .//s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
	////    .s userAuthoriseDesc=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"^",2),7)),"^",3)
	////    .&js<alert("userAuthoriseDesc="+"#(userAuthoriseDesc)#");>
	////    .////i userAuthoriseDesc'[ctcpName  d
	////        .////.s resStr=-2 ;如果不是同一执行人?设置标记
	////    .i userAuthoriseDesc[ctcpName d
	////        ..s userAuthoriseDesc=""   ;添加记录到字段oeori_userauthorise 清空原有记录?恢复到未处理状态
	////        ..&sql(update OE_OrdItem set OEORI_UserAuthorise=:userAuthoriseDesc where oeori_RowId=:oeoriId)   ;添加记录完成
	//ypz 070413 rem //i (oecprDesc'["即刻")&(oecprDesc'["临时")&(oecprDesc'["长期")&(oecprDesc'["自备药")&(oecprDesc'["取药")  q "该状态医嘱不能撤消!"
	//&js<alert("arcicId="+"#(arcicId)#");>
	i arcicId=-90 d   //;待改!!!!????(arcicId=90)!(arcicId=228)  d   ;查询是否为即刻执行医嘱?删除记录
	    .&sql(select oeore_rowid,oeore_ctpcp_dr->ctpcp_desc into :oeoreId,:ctcpDesc from oe_ordexec where oeore_oeori_parref=:oeoriId)
	    .i $g(ctcpDesc)'[ctcpName d
	        ..s resStr=-2
	    .e  d
	        ..//ypz 070413 rem 禁止这种方式//d delete^MVBOEEXE(oeoreId)
	//i arcicId'=-90 d  //;以下为执行程序
	//ypz 080908 rem//i oeoreSub="" s oeoreSub=$o(^OEORD(+oeoriId,"I",oeoriSub,"X",0)) //ypz
	//ypz 080908 rem//i oeoreSub="" q "该医嘱未执行过!" 
	//ypz 080908 rem//s oeoreId=oeoriId_"||"_oeoreSub
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
    //s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //ypz 060707自备药
    //i oecprId="" q "无医嘱优先级!"
    //s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)  //ypz 070413
    s canDo=0
    //i (admType'="I")&(oecprDesc'["自备药") s canDo=..CanUpdateExec(oeoriId,userId)
    s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
	q:(ordstat="D")!(ordstat="U")!(ordstat="C") "0"
    i (admType'="I")&(oecprCode'="OM")&(oecprCode'="OMST") s canDo=..CanUpdateExec(oeoriId,userId)  //ypz 070413
    i (canDo'=0)&(canDo'="-1")&(canDo'="-2") s ok=canDo q ok
	
	&sql(select oeore_ctpcp_dr->ctpcp_desc into :ctcpDesc from oe_ordexec where oeore_rowid=:oeoreId)
	i 2<1 d
	    .s resStr="只有原执行人能撤消操作!"
	e  d
	    .s billFlag="I",nullStr=""
	    .
	    .i oeoreSub'="" d  //住院PDA执行或门急诊
	        ..s oeoreId=oeoriId_"||"_oeoreSub
	        ..&sql(update Oe_ordexec set OEORE_CTPCP_DR=:nullStr,OEORE_Order_Status_DR=:nullStr,OEORE_QtyAdmin=:nullStr,OEORE_CTUOM_DR=:nullStr,OEORE_DateExecuted=:nullStr,OEORE_TimeExecuted=:nullStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	        ..i SQLCODE s resStr="医嘱撤消执行失败!"
	        ..i resStr'=0 q 
	        ..s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
	        ..i (admType'="I")&(canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s retStr=..RetrunStock(oeoreId,userId) //ypz 070413
	        ..i resStr'=0 q 
	        ..
        	..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	..i dhcoreId'="" d //修改医嘱执行扩展表
        	    ...&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:nullStr,DHCORE_OEORE_Date=:nullStr,DHCORE_OEORE_Time=:nullStr,DHCORE_CTLOC_Dr=:nullStr where DHCORE_RowId=:dhcoreId)
        	    ...s resStr=SQLCODE
         ..i resStr'=0 s resStr="修改医嘱执行扩展表有误!"
     .e  d  //住院非PDA执行
         ..s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:oeoreSub=""  d
	            ...s oeoreId=oeoriId_"||"_oeoreSub
	            ...&sql(update Oe_ordexec set OEORE_CTPCP_DR=:nullStr,OEORE_Order_Status_DR=:nullStr,OEORE_QtyAdmin=:nullStr,OEORE_CTUOM_DR=:nullStr,OEORE_DateExecuted=:nullStr,OEORE_TimeExecuted=:nullStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	            ...i SQLCODE s resStr="医嘱撤消执行失败!"
	            ...i resStr'=0 q 
	            ...
        	    ...s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	    ...i dhcoreId'="" d //修改医嘱执行扩展表
        	        ....&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:nullStr,DHCORE_OEORE_Date=:nullStr,DHCORE_OEORE_Time=:nullStr,DHCORE_CTLOC_Dr=:nullStr where DHCORE_RowId=:dhcoreId)
        	        ....s resStr=SQLCODE
             ...i resStr'=0 s resStr="修改医嘱执行扩展表有误!"
	q resStr
}

ClassMethod CanUpdateExec(oeoriId, userId)
{
	n (oeoriId,userId)
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	s resStr=0
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
    i ordStatCode="D" q "停止医嘱不能操作!"
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
	s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
	s actCode=""
	i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
	
	s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
	s IsSkinOrd=##class(web.DHCEMSkinTest).IsSkinOrder(oeordId,oeoriSub) 
	q:IsSkinOrd=2 0	 
	
	s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	s oecprCode="" 
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s:oecprId'="" oecprCode=$p($g(^OECPR(oecprId)),"^")
	s isPayMoney=""
	s:oeoriBilled="P" isPayMoney=1
	s:(oecprCode="OM")!(oecprCode="OMST")!(oecprCode="OMLSZT")!(oecprCode="OMCQZT") isPayMoney=1
	
    s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByOrdItm(oeordId) 
    
    q:(((payMode'=1)&(stayFlag=1))||((stayFlag'=1))&(isPayMoney'=1)&(IsSkinOrd=1)) "皮试未交费不能置皮试结果"
    
     s prtId=""
     i stayFlag'=1 d
     .s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
     i (stayFlag'=1)&(prtId="")&&(IsSkinOrd=1) q "未找到病人发票!不能操作!"
    
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1  //not affect
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag'=1 q -2  //not affect

    s phwId=$o(^DHCPHWINi(phlId,""))
    s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
    i phpId="" q "未设定药房用户,不能操作!"
	q resStr
}

ClassMethod GetAttOrdStr(oeoriId)
{
	n (oeoriId)
	q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2),chl=$p($g(oeoriId),"||",3)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub_"||"_chl
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) ,skinTestInstr="" // + wxl 090411
    i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) // + wxl 090411
	q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    ;---------------by yys 2009.12.11 每周几次的用法不能直接取频率要素---------------
    s WeekFlag=$P($g(^PHCFR(+$g(phcfrId),"DHC")),"^",1)
    i WeekFlag=1 s phfactor=1
    e  s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;---------------------------------------------------------------------------------
    k inattList
    s inattId="",itmmstStr=""
    s adm=+($p(^OEORD(oeordId),"^")) //lijingwei 20091109
    s patloc=+($p(^PAADM(adm),"^",70)) //lijingwei 20091109
    s patloclink=$p($g(^PAWARD(patloc)),"^",5) 
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inattloc=$p(^DHCOEInstrAttachOrd(inattId),"^",8) //lijingwei 20091109
        .q:(inattloc'="")&(inattloc[patloclink) //lijingwei 20091109
        .//按维护的病区插入用法关联的医嘱
        .s execlocId=$p(^DHCOEInstrAttachOrd(inattId),"^",9)
        .q:(execlocId'="")&(execlocId'=patloclink)
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    k insOrdList,normInsOrdList
    s prefiTimes=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
    i $g(prefiTimes)="" s oneTimes=1
    e  s oneTimes=0
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=1
    
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    i $d(inattList("D")) s inattList("D","times")=oneTimes
    i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))

    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s number=$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..s qty=inattList(inattType,"times")*number
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..s qty=insOrdList(inattType,arcimId)
        	..i retStr'="" s retStr=retStr_"^"

        	..s retStr=retStr_arcimId_$c(2)_qty //s ^TMPNurOPDebug("res",inattType,arcimId)=qty
    q retStr
}

ClassMethod UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode) As %String
{
	   n (oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
    i oeoreId="" q 0  //d //修改执行扩展表
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId="" d
        .&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Ssuser_Dr,DHCORE_OEORE_Date,DHCORE_OEORE_Time,DHCORE_CTLOC_Dr,DHCORE_QueryCode) Values(:oeoreId,:userId,:curDate,:curTime,:userDeptId,:queryTypeCode))
    e  d
        .&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:userId,DHCORE_OEORE_Date=:curDate,DHCORE_OEORE_Time=:curTime,DHCORE_CTLOC_Dr=:userDeptId,DHCORE_QueryCode=:queryTypeCode where DHCORE_RowId=:dhcoreId)
    q SQLCODE
}

ClassMethod InsertOrdItems(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes, ifRetRowID = "N") As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2)  ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=userDeptId  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo1(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s admId=+^OEORD(oeordId)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s AdmDocCodeDR=$p(^PAADM(admId),"^",9)
	s PLIST(53)=notes //OEORI_DepProcNotes
	s res=$$insert^MVBOEIT0(oeordId,"Y")	
	s oeitm=""
	i res=0 d
	.s oeitm=%ROWID
	.s res=$$InsertDsp^DHCDocOrderCommon(oeitm)
	s $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC"),"^",15)=$$GetMedUnitByLoc^DHCDocOrderCommon(AdmDocCodeDR,PLIST(161),PLIST(161),AdmDocCodeDR,oeitm)
	zn oldNameSpace  ; Restore the namespace
	i ifRetRowID="Y" q res_"^"_$G(oeitm)
	q res
GetSeqNo1(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

ClassMethod insertAttOrd(inattList, phcinId, phfactor, userId, oeordId, userDeptId)
{
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
    
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor-insTimes
    i $d(inattList("F")) s inattList("F","times")=insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
    //s ^TMPNurOPDebug("ins")=insOrdList
    //m ^TMPNurOPDebug("insAtt")=inattList

    TStart
    s inattType="",isAbort=0
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")!(isAbort)  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")!(isAbort)  d
        	..s qty=insOrdList(inattType,arcimId)
        	..//s ^TMPNurOPDebug("res",inattType,arcimId)=qty
        	..s retInsord=..InsertOrdItems(userId, oeordId, arcimId,3,1,userDeptId, "", "", "","")
        	..i retInsord'=0 s isAbort=1
    i isAbort TRollBack  s insTimes=0 q
    TCommit
    i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
	q 0
}

ClassMethod RetrunStock(oeoreId, userId)
{
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub

    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1
    s resStr=0
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag=1 d
        .//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
        .//s ordStatDesc=""
        .//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
        .//i ordStatDesc["停止" s resStr="停止医嘱不能撤消执行!" q
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
        .i ordStatCode="D" s resStr="停止医嘱不能撤消执行!" q
        .s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
        .i prtId="" s resStr="未找到病人发票!不能退库存!" q
        .s phwId=$o(^DHCPHWINi(phlId,""))
        .s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
        .s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
        .i phpId="" s resStr="非药房用户,不能退药!" q
		.s phdId="",count=0
		.f  s phdId=$o(^DHCPHDISPi("PRT",phlId,prtId,phdId)) q:(phdId="")!(count>0)  d
			..s phdPrescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	  		..q:phdPrescNo'=prescNo
	  		..s phdiSub=""
	  		..f  s phdiSub=$o(^DHCPHDI(phdId,"PHDI",phdiSub)) q:(phdiSub="")!(count>0)  d
	    		...s curOreId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",11) //ypz
	    		...q:curOreId'=oeoreId  //ypz 按执行走
	    		...s qty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",4)
	    		...s retQty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",6)
	    		...i retQty=qty q
	    		...s retUomId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",8)
	    		...s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	    		...////i oeordId=1325 w phdId_"||"_phdiSub,! q
	    		...s phretId=##CLASS(web.DHCNurOPExec).DoReturn(reclocId, userId,phdId_"||"_phdiSub, "", "","","")
	    		...i phretId<1 s resStr="退药错误!",count=1 q
	    		...s retStr=##CLASS(web.DHCNurOPExec).DoRetItm(phretId,phdId_"||"_phdiSub)
	    		...i retStr s resStr="返库存错误!",count=1 q
	q resStr
}

ClassMethod AdjustStock(oeoreId)
{
    //ypz 060602
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1
    s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
    q:prtId="" -2
    s resStr=0
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag=1 d
        .//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
        .//s ordStatDesc=""
        .//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
        .//i ordStatDesc["停止" s resStr="停止医嘱不执行!" q
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
        .i ordStatCode="D" s resStr="停止医嘱不执行!" q
        .s phwId=$o(^DHCPHWINi(phlId,""))
        .s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
        .s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
        .i phpId="" s resStr="你缺少药房人员身份!" q
        .s retStr=##class(web.DHCNurOPExec).InsertPHDisp(prtId,phlId,phwId,phpId,phpId,prescNo,"",oeoreId)
        .i retStr s resStr="插入发药记录错误!" q
        .
        .s retStr=##class(web.DHCNurOPExec).UpdatePyd("","",prtId, phlId, phpId, phpId,prescNo,"",oeoreId)
        .i retStr s resStr="减库存错误!" q
    i resStr=0 d
        .s oeoreSub=0,oeoreStatus="P"
		.f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
		    ..s dspSub=0
	    	..f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	        	...i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6)="C" s oeoreStatus="C"
		.i oeoreStatus'="C" d
		    ..s $p(^OEORD(oeordId,"I",oeoriSub,6),"^",7)="1"
			..s retStr=##class(web.DHCOutPhDisp).collect(oeordId,oeoriSub)
			..i retStr s resStr="置发药状态错误!"
    q resStr
}

/// Creator: wangxinlei
/// CreatDate: 2009-05-21
/// Description: 复核皮试结果同时判断密码及置过敏记录
/// Table：SS_User,OE_OrdTtem,DHC_OE_OrdItem,PA_Allergy
/// Input：userCode: 用户登陆名 passWord: 用户密码 oeoriStr: 医嘱RowId skinTest: 复核皮试结果
/// Return：成功返回 0 失败返回 错误信息
/// w ##class(web.DHCEMSkinTest).updateAudit("jzhs01","1","339||35||1","Y","0000000251 ")
ClassMethod updateAudit(userCode As %String, passWord = "", oeoriStr As %String, skinTest As %String, RegNo As %String) As %String
{
	n (userCode,passWord,oeoriStr,skinTest,RegNo)
	s retStr=""
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	s skinTestAuditCtcpDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	s skinTestAuditDate=+$H
	s skinTestAuditTime=+$P($H,",",2)
	s strLen=$L(oeoriStr,"!")
	s retStr=""
	f i=1:1:strLen d
    .s oeoriId=$P(oeoriStr,"!",i)
    .s oeordId=+$P(oeoriId,"||")
    .s oeoriSub=+$P(oeoriId,"||",2)
    .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    .i dhcoriId="" &sql(INSERT INTO DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestAuditCtcp_Dr,DHCORI_SkinTestAuditDate,DHCORI_SkinTestAuditTime) values(:oeoriId,:skinTestAuditCtcpDr,:skinTestAuditDate,:skinTestAuditTime))
    .i dhcoriId'="" &sql(UPDATE DHC_OE_OrdItem set DHCORI_SkinTestAuditCtcp_Dr=:skinTestAuditCtcpDr,DHCORI_SkinTestAuditDate=:skinTestAuditDate,DHCORI_SkinTestAuditTime=:skinTestAuditTime where DHCORI_OEORI_Dr=:oeoriId)
    .s retStr=SQLCODE
    ;过敏记录插入
    ;i skinTest="Y" d
    ;.s arcimID =$p($g(^OEORD(+$P(oeoriStr,"||"),"I",+$P(oeoriStr,"||",2),1)),"^",2) ;2016-10-26
    ;.s adm=$p(^OEORD(+oeoriStr),"^",1)
    ;.s list=adm_"!!"_skinTestAuditDate_"!!"_"Pharmacy Item"_"!!"_"2"_"!!"_""_"!!"_arcimID_"!!"_""_"!!"_""_"!!"_"P"_"!!"_userId_"!!"_RegNo_"!!"_"I" ;2016-10-26
	;.s retStr=##class(web.DHCEMAllergyEnter).SaveAllergyInfo(list,"") ;2016-10-26
	;.i retStr=-1 s retStr=retStr_"过敏记录插入失败!"
	;.e  s retStr=0
	q retStr
}

/// Description: 存储PPD试验信息 
/// Creator:     congyue
/// CreateDate:  2016-08-10
/// Table: 		 DHCNurSkinPPD
/// Input:  	 id 皮试计时信息 parr   typ现有 count:开始计时按钮,test:置皮试结果按钮,call:呼叫按钮
/// Return： 	 0 成功  非0  提示错误  
/// Others:		 W ##class(web.DHCEMSkinTest).SavePPD("","TestAdmDr|341^TestStartDate|^TestStartTime|^RecUser|69^TestOeoriDr|^ObserveTime|5分钟^TestLocDr|67^TestMethod|","count")
ClassMethod SavePPD(id, parr As %String) As %String
{
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	if $D(tmp("TestOeoriDr")) {
		s tmp("TestOeoriDr")=$TR($G(tmp("TestOeoriDr")),"!!","||")
	}
	q:$g(tmp("TestOeoriDr"))="" ""
	s ret=..IfSkinOrd(tmp("TestOeoriDr"))
	q:ret'="0" ret
	if $G(id)'="" {
		s a=##class(User.DHCNurSkinPPD).%OpenId(id)
	}
	else
	{
			s a=##class(User.DHCNurSkinPPD).%New(id)
		}
    if $D(tmp("TestAdmDr")) s a.TestAdmDr=tmp("TestAdmDr")  //患者
    if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")           //记录人
	if $D(tmp("TestDate")) s a.TestDate=..TransDate($G(tmp("TestDate")))  //记录日期
	if $D(tmp("TestTime")) s a.TestTime=..TransTime($G(tmp("TestTime")))   //记录时间
	if $D(tmp("TestOeoriDr")) s a.TestOeoriDr=tmp("TestOeoriDr")            //医嘱id
	
	if $D(tmp("TestSkinSityOne")) s a.TestSkinSityOne=tmp("TestSkinSityOne")   //皮肤硬结1
	if $D(tmp("TestSkinSityTwo")) s a.TestSkinSityTwo=tmp("TestSkinSityTwo")   //皮肤硬结2
	if $D(tmp("TestSkinVclOne")) s a.TestSkinVclOne=tmp("TestSkinVclOne")     //局部水泡1
	if $D(tmp("TestSkinVclTwo")) s a.TestSkinVclTwo=tmp("TestSkinVclTwo")     //局部水泡2
	if $D(tmp("TestSkinSwoOne")) s a.TestSkinSwoOne=tmp("TestSkinSwoOne")     //红肿1
	if $D(tmp("TestSkinSwoTwo")) s a.TestSkinSwoTwo=tmp("TestSkinSwoTwo")     //红肿2
	if $D(tmp("TestSkinNecrosis")) s a.TestSkinNecrosis=tmp("TestSkinNecrosis")  //坏死
	
	if $D(tmp("TestSkinInflam")) s a.TestSkinInflam=tmp("TestSkinInflam")     //淋巴管炎
	if $D(tmp("TestSkinSing")) s a.TestSkinSing=tmp("TestSkinSing")     //单个
	if $D(tmp("TestSkinSpora")) s a.TestSkinSpora=tmp("TestSkinSpora")     //散在	
	///if $D(tmp("TestBatch")) s a.TestBatch=tmp("TestBatch")    //批号
	d a.%Save()
	//q a.%Id()
	q 0
}

// 判断是否是皮试医嘱，返回0是，否则不是

ClassMethod IfSkinOrd(oeoreId) As %String
{
	q:oeoreId="" ""
	s oeordId=+oeoreId
    s oeoriSub=$p(oeoreId,"||",2)
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q "非皮试医嘱!"
	q 0
}

ClassMethod remove(id) As %String
{

	;s oeord=$ListGet(^User.DHCNurSkinPPDD(id),6) 
	;s $p(^OEORD(+oeord,"I",$p(oeord,"||",2),11),"^",3)=""
	S sc=##class(User.DHCNurSkinPPD).%DeleteId(id)
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  w -1
 	  q ""
 	}
 	w 0
 	q ""
}

/// Creator:qqa
/// CreatorDate:2020-06-18
/// Descripts:8.4皮试改造后获取医嘱是不是皮试医嘱
/// Return: 1:皮试药，2：治疗药，0:非皮试治疗
/// W ##class(web.DHCEMSkinTest).IsSkinOrder("279","71")
ClassMethod IsSkinOrder(Ord, Itm) As %String
{
	n (Ord,Itm)
	s PhcinDesc=##class(web.DHCEMOrdInfoVO).getPhcinDesc(Ord,Itm)
	s SkinFlag=$p($g(^OEORD(Ord,"I",Itm,5)),"^",2)    				///皮试勾
	s ActId=$p($g(^OEORD(Ord,"I",Itm,11)),"^",21)
    s ActCode=""
    i ActId'="" s ActCode=$p(^OEC("ACT",ActId),"^",1)
    q:(PhcinDesc="皮试")&&(SkinFlag="Y") 1
    q:(PhcinDesc'="皮试")&&((SkinFlag="Y")||(ActCode'="")) 2
	q 0
}

/// qqa 2018-01-03
/// 皮试界面加载数据
/// w ##class(web.DHCEMSkinTest).GetSkinRsData("687||41||1")
ClassMethod GetSkinRsData(oeoriId) As %String
{
	n (oeoriId,%session)
	s oeoreId=oeoriId
	s execStat=##class(web.DHCEMOrdInfoVO).getExecStat(+oeoreId,$p(oeoreId,"||",2),$p(oeoreId,"||",3))
	s oeoriId = +oeoriId_"||"_$p(oeoriId,"||",2)
	s IsPPDFlag = ##class(web.DHCEMSkinTest).GetIfPPDOrder(oeoriId)
	s SkinInfo=""
	s:execStat="已执行" SkinInfo = ##class(web.DHCEMSkinTest).GetSkinInfoByOrder(oeoriId)
	q IsPPDFlag_"#"_SkinInfo
}

/// Description: 皮试执行/护士执行置皮试结果中 	 	设置Global ^DHCCLSet("Exec","PPDArcimDr")
/// Creator:     congyue
/// CreateDate:  2016-08-10
/// Table: 		 DHC_MatAdrReport
/// Input:  	 医嘱id
/// Return： 	 判断皮试是否是PPD试验医嘱,是可以不用选皮试结果
/// Others:		 w ##class(web.DHCEMSkinTest).GetIfPPDOrder("343||15||1")
ClassMethod GetIfPPDOrder(oeoriId) As %String
{
	
	s oeoriId=$p(oeoriId,"^") 
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	q:(oeordId="")!(oeoriSub="") 0
	s IfPPDOrder=##Class(web.DHCEMCommonUtil).IfPPDOrder(oeordId_"||"_oeoriSub) //hxy 2023-02-07 st
	q:IfPPDOrder="Y" 1
#;	s AdmID=$p($g(^OEORD(oeordId)),"^",1)
#;	s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmID)
#;	s ArcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
#;	q:$G(^DHCCLSet("Exec","PPDArcimDr"))[ArcimDr 1
#;	q:$G(^DHCCLSet("Exec","PPDArcimDr",AdmHospID))[ArcimDr 1 //ed
	q 0
}

/// w ##class(web.DHCEMSkinTest).GetOrderInfo("175||2||1")
ClassMethod GetOrderInfo(OrdItmID)
{
	n (OrdItmID)
	s Ord=+OrdItmID
	s Itm=$p(OrdItmID,"||",2)
	s Sub=$p(OrdItmID,"||",3)
	s OrdItmID=Ord_"||"_Itm
	s OrdExecID=Ord_"||"_Itm_"||"_Sub
	
	s EpisodeID=+^OEORD(Ord)
	s PatientID=+^PAADM(EpisodeID)
	s ListID=$o(^User.DHCNurSkinTestListI("OeoriDr"," "_OrdItmID,""),-1)
	
	s TestMethod="",ObserveTime=""
	i ListID'="" d
	.s TestMethod=$lg(^User.DHCNurSkinTestListD(ListID),14)
	.s ObserveTime=$lg(^User.DHCNurSkinTestListD(ListID),12)
	
	s OrdStatusId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)  
    s OrdState=$p($g(^OEC("OSTAT",+OrdStatusId)),"^",1)
    s:+Sub'=0 ExecStatusId=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",16) //执行状态
	s ExecStatusCode=""
    s:$g(ExecStatusId)'="" ExecStatusCode=$p($g(^OEC("STAT",ExecStatusId)),"^",1) 
	s Exec=$case(ExecStatusCode,"F":"Y",:"")
	s SkinSize=$g(^OEORD(Ord,"I",Itm,"SKINPC",1))
	
	s SkinRs=##class(web.DHCEMOrdInfoVO).getSkinResult(Ord_"||"_Itm)
	s ArciDesc = ##class(web.DHCEMOrdInfoVO).getArcimDesc(Ord,Itm)
	s DHCOriId=$o(^DHCORDItem(0,Ord_"||"_Itm,""))
	s SkinCtpcpName="",SkinRecCtpcpName="",SkinUserID="",SkinRecUserID="",SkinUserCode="",SkinRecUserCode=""
	i DHCOriId'="" d
	.s SkinCtpcpDr = $p($g(^DHCORDItem(DHCOriId)),"^",13)
	.s SkinRecCtpcpDr = $p($g(^DHCORDItem(DHCOriId,4)),"^",5)
	.q:SkinCtpcpDr=""     
	.q:SkinRecCtpcpDr=""
	.s SkinCtpcpName = $p(^CTPCP(SkinCtpcpDr,1),"^",2)
	.s SkinRecCtpcpName = $p(^CTPCP(SkinRecCtpcpDr,1),"^",2)
	.s SkinUserID=$o(^SSU("SSUSR",0,"CTPCP",+SkinCtpcpDr,""))
	.s SkinRecUserID=$o(^SSU("SSUSR",0,"CTPCP",+SkinRecCtpcpDr,""))
	.s:SkinUserID'="" SkinUserCode=$p(^SSU("SSUSR",SkinUserID),"^",1)
	.s:SkinRecUserID'="" SkinRecUserCode=$p(^SSU("SSUSR",SkinRecUserID),"^",1)
	
	s SkinPas=##class(web.DHCEMSkinTest).GetUserPassword(SkinUserID,"",1)
	s SkinRecPas=##class(web.DHCEMSkinTest).GetUserPassword(SkinRecUserID,"",1)
	
	
	s Ret = ArciDesc_"^"_SkinRs_"^"_ObserveTime_"^"_TestMethod_"^"_Exec_"^"_SkinSize_"^"_SkinUserCode_"^"_SkinRecUserCode
	s Ret = Ret_"^"_SkinPas_"^"_SkinRecPas
	q Ret
}

/// w ##class(web.DHCEMSkinTest).GetUserPassword("10198")
ClassMethod GetUserPassword(userId = "", userCode = "", type = "")
{
 q:(userId="")&&(userCode="") ""
 s pos=3
 s:type=1 pos=15
 
 s ok="",aa="",okk=""
 s:userId="" userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) 
 s pin=$p($G(^SSU("SSUSR",userId)),"^",pos)
 s leng=$l(pin)
 f pp=1:1:leng q:okk="1"  d  
 .s ppp=..GetPass(aa,pp,pin)
 .s aa=$p(ppp,"#",1)
 .s pp=$p(ppp,"#",2)
 .s okk=$p(ppp,"#",3)
 q aa
}

ClassMethod GetPass(aa As %String, pp As %String, pin As %String)
{
 s ok="",okk=""
 s p=33
 f d=p:1:126 q:ok="1"  d 
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

/// w ##Class(web.DHCEMSkinTest).GetJsonSkinMethod()
ClassMethod GetJsonSkinMethod()
{
	s DymArrObj=##Class(web.DHCEMInterfaceCom).GetSkinMethod()
	q DymArrObj.%ToJSON()
}

/// Description: 判断人员是否有本科登录权限
/// Creator:     cy
/// CreateDate:  2022-09-30  
/// Table:	     SS_UserOtherLogonLoc 
/// Input:  	 人员id
/// Output:   	 flag 0 无权限， 1 有权限
/// Others:		 w ##class(web.DHCEMSkinTest).IfSameLoc("1","1")
ClassMethod IfSameLoc(UserID As %String, LocID As %String) As %String
{
	N (UserID,LocID)
	S flag=0
	S UserLocID=$p(^SSU("SSUSR",UserID),"^",4)
	S:LocID=UserLocID flag=1
	Q:flag=1 flag
	S Sub=""
	F  S Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) Q:(Sub="")||(flag=1)  D
	.Q:Sub=0
	.Q:flag=1
	.S OthLogLocID=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	.S:(LocID=OthLogLocID) flag=1
	.Q:flag=1
	
	Q flag
}

}
