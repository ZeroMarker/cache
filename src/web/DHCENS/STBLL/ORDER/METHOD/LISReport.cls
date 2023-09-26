Class web.DHCENS.STBLL.ORDER.METHOD.LISReport Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000004","11606807||A30||1")

/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.LISReport).Test()
ClassMethod Test()
{
	set i=0
	set rowId="0"  for  set rowId=$o(^PAPER(rowId))  q:((rowId="")||(rowId>20000))  d
	.set admType=""  for  set admType=$o(^PAPERdr(rowId,"ADM",admType)) q:admType=""  d
	..set admRowId=""  for  set admRowId=$o(^PAPERdr(rowId,"ADM",admType,admRowId)) q:admRowId=""  d
	...Quit:admRowId=2
	...set subId=""  for  set subId=$o(^OEORD(0,"Adm",admRowId,subId)) q:subId=""  d
	....set childId="0"  for  set childId=$o(^OEORD(subId,"I",childId)) q:childId=""  d	
	.....set reportId=$p(^OEORD(subId,"I",childId,3),"^",35)
	.....Quit:reportId=""
	.....set tSc=##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000004",reportId)
	.....set i=i+1
	QUit i
}

// w ##class(web.DHCENS.STBLL.ORDER.METHOD.LISReport).GetReport("11672763||A30||1")

ClassMethod GetReport(Input As %String) As %GlobalCharacterStream
{
	set $ztrap="ErrorMessage"
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	s labno=$p(Input,"||",1)
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	s request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set subId=$o(^OEORD(0,"EpisNo",labno,""))
	Quit:subId="" "-1^"_$ze
	set admRowId=$p($g(^OEORD(subId)),"^",1)	
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	// 取院区
	set HospCode="",hospId=""
	set:AdmDeptRowID'="" hospId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
	set:hospId="" hospId=$o(^CT("HOSP","0"))
	set:hospId'="" header.SourceSystem=$p($g(^CT("HOSP",hospId)),"^",1)
	set header.TargetSystem="医院信息平台"
	set request.header=header
    S reportID=labno   //检验号当作reportID
    if ('$L(labno))
    {
	    d request.XMLExportToStream(.xml)
	    q xml  
	}
	s tsCode=$o(^[LABDATA]TEPI(labno,1,""))
	if ('$L(tsCode))
    {
	    d request.XMLExportToStream(.xml)
	    q xml  
	}
	s body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
    S data=$G(^[LABDATA]TEPI(labno,1,tsCode,1))          
    S gName=$P($G(^[LABDATA]TEPI(labno)),"\",1)                          //1.姓名
    S sName=$P($G(^[LABDATA]TEPI(labno)),"\",2)
    S patName=gName_sName
    S:gName=sName patName=gName
    S spDesc=""                                                        	//2.性别
    S spCode=$P($G(^[LABDATA]TEPI(labno)),"\",3)
    S:$L(spCode) spDesc=$P($G(^TTAB("SP",spCode)),"\",1)
    S patDOB=$P($G(^[LABDATA]TEPI(labno)),"\",4)                        //3.生日
    S:$l(patDOB) patDOB=$ZD(patDOB,3)
    S debtor=$P($G(^[LABDATA]TEPI(labno)),"\",18)                  		//4.登记号
    /*S PatRowID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(debtor),""))
    S hospno=$p($g(^PAPER(PatRowID,"PAT",1)),"^",22)				   	//5.病案号
    s DOB=$P(^PAPER(PatRowID,"ALL"),"^",6)	
	s EstAgeMonth=$P(^PAPER(PatRowID,"ALL"),"^",16)
    s EstAgeYear=$P(^PAPER(PatRowID,"ALL"),"^",15)
 	s EstAgeTmStmp=$P(^PAPER(PatRowID,"ALL"),"^",17)
 	s AgeStr=$$CalAge^at182(DOB,+$H,EstAgeMonth,EstAgeYear,EstAgeTmStmp) 	//6.年龄
    S patloc=""                                                         	
    */
    S locCode=$P($G(^[LABDATA]TEPI(labno)),"\",36)
    S:$L(locCode) patloc=$P($G(^[LABDATA]TTAB("USLOC",locCode)),"\",1)		//7.就诊科室
    S requestDate=$P($G(^[LABDATA]TEPI(labno)),"\",12)               		//8.申请日期
    s requestTime=$P($G(^[LABDATA]TEPI(labno)),"\",50)                 		//9.申请时间
    S wardDesc=""                                                       	//10.病区
    S wardDr=$P($G(^[LABDATA]TEPI(labno)),"\",20)
    S:$L(wardDr) wardDesc=$P($G(^[LABDATA]TTAB("RH",wardDr)),"\",1)
    s doctorDesc=""                                                     	//11.医护人员表中的医生
    S doctorCode=$P($G(^[LABDATA]TEPI(labno)),"\",13)
    S:$L(doctorCode) doctorDesc=$P($G(^[LABDATA]TTAB("DR",doctorCode)),"\",1)
    s (CTProvDr,UserDr,UserCode)=""
    s:$L(doctorCode) CTProvDr=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(doctorCode),""))
    s:CTProvDr'="" UserDr=$o(^SSU("SSUSR",0,"CTPCP",CTProvDr,""))
    s:UserDr'="" UserCode=$p(^SSU("SSUSR",UserDr),"^",1)					
    S room=$P($G(^[LABDATA]TEPI(labno,0)),"\",28)                      		//12.房间号
    S bed=$p($G(^[LABDATA]TEPI(labno,0)),"\",29)                      		//13.床号
    s phoneHome=$p($G(^[LABDATA]TEPI(labno,0)),"\",12)               		//14.电话    
    s patAddress=$P($G(^[LABDATA]TEPI(labno,0)),"\",1)              		//15.地址                                                       			  		
    S (assayDate,assayTime)=""                                   			//16.化验日期,化验时间
    I $D(^DHCTSExtra(labno,1,tsCode,1)) D
    .S assayDate=$P($G(^DHCTSExtra(labno,1,tsCode,1)),"\",1)
    .S assayTime=$P($G(^DHCTSExtra(labno,1,tsCode,1)),"\",2)

    ;S secondLabno=$$GetSndLabNo^DHCLtkDoEpis(labno)           				//17.预置条码号
    S patType=$P($G(^[LABDATA]TEPI(labno)),"\",48)                         	//18.病人类型      
    S patDiag=$P($G(^[LABDATA]TEPI(labno,8)),"\",15)                        //19.诊断
  
    S stStus="" //$$GetSpecStatus^DHCUtlSpecQryStorage(labno)     		 //20.存储位置
 
    s sepcMemoDr=$P($G(^[LABDATA]TEPI(labno,8)),"\",6)                   //21.标本质量
    s specMemo=sepcMemoDr
    s requestMemo=""                                                  	//22.医嘱备注
    s SNSeq=+$G(^[LABDATA]TEPI(labno,1,tsCode,1,"SN",0))
    S:SNSeq>0 requestMemo=$G(^[LABDATA]TEPI(labno,1,tsCode,1,"SN",SNSeq))
    S tsName=$P($G(^[LABDATA]TTAB("TS",tsCode)),"\",1)                 //23.医嘱描述

    S recDate=$P(data,"\",21)                                      		//24.接收日期
    S recTime=+$P(data,"\",22)                                        	//25.接收时间
    S:$L(recTime) recTime=recTime*60
    S recUserDr=$P(data,"\",23)                                        	//26.接收者
    S:$P($G(^TTAB("DEP",$E(tsCode,1))),"\",7)="Y" recUserDr=$P(data,"\",3)
    S entryDate=$P(data,"\",1)                                        	//27.保存日期
    S entryTime=+$P(data,"\",2)                                        	//28.保存时间
    S:$L(entryTime) entryTime=entryTime*60
    S entryUserDr=$P(data,"\",3)                                   		//29.保存者
    S authDate=$P(data,"\",4)                                        	//30.审核日期
    S authTime=+$P(data,"\",5)                                        	//31.审核时间
    S:$L(authTime) authTime=authTime*60
    S authUserDr=$P(data,"\",6)                                    		//32.审核者    
    S colDate=$P(data,"\",44)                                        	//33.标本采集日期
    S colTime=$P(data,"\",45)                                        	//34.标本采集时间
    S episode=$P(data,"\",12)                                        	//35.流水号
    S temTG=$O(^DHCVisitTestSets(reportID,""))
    S:$L(temTG) episode=$P($G(^DHCVisitTestSets(reportID,temTG)),"\",1)
   
    S specCode=$P(data,"\",46)                                        	//36.标本类型
    S specDesc=""
    S:$L(specCode) specDesc=$P($G(^[LABDATA]TTAB("SPEC",specCode)),"\",1)
    S machineCode=$P(data,"\",27)                                   	//37.仪器代码
    S machineDesc=""
    S:$L(machineCode) machineDesc=$P($G(^[LABDATA]TMIF(machineCode)),"\",1)
    S printFlag=$P(data,"\",28)                                        	//38.打印标记
    S reportStatusDr=$P(data,"\",31)                              		//39.报告状态
    I $D(^DHCSpecimenRegister(labno)) d
    .S recDate=$p(^DHCSpecimenRegister(labno),"\",4)
    .S recTime=$p(^DHCSpecimenRegister(labno),"\",5)
    
    S patientID=$P(^[LABDATA]TEPI(labno),"\",18)
    S peID=""
    S:$L(patientID) peID=$O(^[LABDATA]TDEBi(patientID,"HOSPITAL",""),-1)  //体检号
    s report=##class(web.DHCENS.STBLL.ORDER.MODEL.LISReportResult).%New()
    s report.LISRRReportID=labno
  	s:locCode'="" locCode=$p($g(^CTLOC(locCode)),"^",1)
    s report.LISRRReportDeptCode=locCode
    s report.LISRRFirstCheckDate=##Class(LIS.Core.Util).CvtClientDate(authDate,"")
    s report.LISRRFirstCheckTime=##Class(LIS.Core.Util).CvtClientTime(authTime,"")
    s report.LISRRFirstCheckUserCode=authUserDr //##Class(LIS.Core.Util).GetUser(authUserDr)
    s report.LISRRCheckDate=##Class(LIS.Core.Util).CvtClientDate(authDate,"")
    s report.LISRRCheckTime=##Class(LIS.Core.Util).CvtClientTime(authTime,"")
    s report.LISRRCheckUserCode=authUserDr  //##Class(LIS.Core.Util).GetUser(authUserDr)
    s report.LISRRTestDate=##Class(LIS.Core.Util).CvtClientDate(recDate,"")
    s report.LISRRTestTime=##Class(LIS.Core.Util).CvtClientTime(recTime,"")
    s report.LISSRSpecimenID=labno
    s OEORDRowId="",admNo=""
    s OEORDRowId=$O(^OEORD(0,"EpisNo",labno,OEORDRowId))
    s:OEORDRowId'="" admNo = $P($g(^OEORD(+OEORDRowId)),"^",1)
    s report.LISRRVisitNumber=admNo
    s tsCode="" f  s tsCode=$o(^[LABDATA]TEPI(labno,1,tsCode)) q:tsCode=""  d
    .s Flag=$p(^[LABDATA]TEPI(labno,1,tsCode,1),"\",31)
    .//状态为A的是核实
    .q:Flag'="A"
    .i ($d(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA"))) d
    ..s tcCode=""
    ..f  s tcCode=($o(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode))) q:tcCode=""  d
    ...s result=##Class(web.DHCENS.STBLL.ORDER.MODEL.LISItemResult).%New()
    ...s resStr=$Get(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode))
    ...s tcDesc=$p(^[LABDATA]TTAB("TC",tcCode),"\",1)
 	...s tcSeq=+$p(resStr,"\",9)
 	...s tcResult=$p(resStr,"\",1)
 	...s tcFlag=$p(resStr,"\",2)
 	...s Machine=$p(resStr,"\",6)
 	...s WarnFlag=$p(resStr,"\",2)
 	...i '$Length(WarnFlag) d
 	....s WarnFlag="N"
 	...s (assayDate,assayTime)=""                                   			
    ...i $D(^[LABDATA]DHCTSExtra(labno,1,tsCode,1)) d
    ....s assayDate=$zd($P($G(^[LABDATA]DHCTSExtra(labno,1,tsCode,1)),"\",1),3)		//化验日期,化验时间
    ....s assayTime=$zt($P($G(^[LABDATA]DHCTSExtra(labno,1,tsCode,1)),"\",2))
 	...s tcRanges=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"Ranges"))
 	...s tcUnit=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"Unit"))
 	...s AuthDate=$p(resStr,"\",4)
 	...i tcUnit="",$l(AuthDate) d
 	....s tcUnit=##Class(DHCLabToEPR.DHCLabTestSetQuery).GetTCUnitByDate(tcCode,AuthDate)
 	...i tcRanges="",$l(AuthDate) d
 	....s tcRanges=##Class(DHCLabToEPR.DHCLabTestSetQuery).GetTCRanges(tcCode,PatAge,PatSpecies,"","0",AuthDate,"","",Machine,"")
	...s tcLabSerialNo=labno_tsCode_"||1||"_tcCode
	...//老库从此获取
	...set labTestRes=##class(web.DHCLabTestCode).GetTestCodeResult(labno,tcCode,tcResult,"")
	...set tcUnit=$p(labTestRes,$c(2),4)
	...set tcRanges=$p(labTestRes,$c(2),6)
	...set WarnFlag=$p(labTestRes,$c(2),8)
	...s result.LISIRRowID=tcLabSerialNo
	...s result.LISIRReportID=labno
	...s result.LISIRPatientID=patientID
	...s result.LISIRItemCode=tcCode
	...s result.LISIRItemDesc=tcDesc
	...s result.LISIRUint=tcUnit 
	...s result.LISIRRanges=tcRanges
	...s result.LISIRResult=tcResult
	...s result.LISIRAbnormalFlags=WarnFlag
	...s result.LISIRTestDate=assayDate
	...s result.LISIRTestTime=assayTime
	...s result.LISIRTestUserCode=UserCode
	...s result.LISIRShowSeq=tcSeq
	...d report.LISItemResultList.Insert(result)
 	...i $d(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT")) d
 	....//抗生素结果
	....s ant="",num="1"
	....f  s ant=$o(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT",ant)) q:ant=""  d
	.....s resultAntibiotic=##Class(web.DHCENS.STBLL.ORDER.MODEL.LISItemSenResult).%New()
	.....s temStr=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT",ant))     	
	.....s antName=""
	.....i $d(^[LABDATA]TTAB("ANT",ant)) d
	......s antName=$p(^[LABDATA]TTAB("ANT",ant),"\",1)
	.....;Antibiotics Extra Information 20081121
	.....s (engName,senResDesc,mic,mm,dosage,surem)=""
	.....i $d(^DHCANTIBIOTICS(ant)) d
	......s engName=$p(^DHCANTIBIOTICS(ant),"\",1)
	......s dosage=$p(^DHCANTIBIOTICS(ant),"\",4)
	......s surem=$p(^DHCANTIBIOTICS(ant),"\",5)
	.....s senResDr=$p(temStr,"\",1)
	.....i $l(senResDr)&&$d(^[LABDATA]TTAB("SENS",senResDr)) d
	......s senResDesc=$p(^[LABDATA]TTAB("SENS",senResDr),"\",1)
	.....s reportflag=$p(temStr,"\",2)
	.....s mic="",mm=""
	.....i reportflag="Y" d
	......s mic=$p(temStr,"\",3)
	......s mm=$p(temStr,"\",4)
	.....i $e(mic,1)="." d
	......s mic="0"_mic
	.....i $e(mm,1)="." d
	......s mm="0"_mm
	.....s LISISRSensitivityCode=$p(temStr,"\",1)
	.....s LISISRIRanges=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT",ant,"CLSI","I"))
	.....s LISISRSRanges=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT",ant,"CLSI","S"))
	.....s LISISRRRanges=$g(^[LABDATA]TEPI(labno,1,tsCode,1,"DATA",tcCode,"ANT",ant,"CLSI","R"))
	.....s antDesc=$p($g(^[LABDATA]TTAB("ANT",ant)),"\",1)
	.....s resultAntibiotic.LISISRResultID=reportID_"||"_tcCode_"||"_ant
	.....s resultAntibiotic.LISISRAntibioticsCode=antDesc
	.....s resultAntibiotic.LISISRResult=mic_" "_mm
	.....s resultAntibiotic.LISISRSensitivityCode=LISISRSensitivityCode
	.....s resultAntibiotic.LISISRIRanges=LISISRIRanges
	.....s resultAntibiotic.LISISRSRanges=LISISRSRanges
	.....s resultAntibiotic.LISISRRRanges=LISISRRRanges
	.....s resultAntibiotic.LISISRShowSeq=num
	.....d result.LISItemSenResult.Insert(resultAntibiotic)
	.....s num=num+1
	d body.lISReports.Insert(report)
	s request.body=body
	d request.XMLExportToStream(.xml)
	b ;00
	q xml
ErrorMessage
	b ;111
	S request=##Class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	d objreport.XMLExportToStream(.xml)
	q xml
}

}
