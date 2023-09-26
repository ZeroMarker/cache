Class web.DHCHM.Service.GetInfo [ Not ProcedureBlock ]
{

//qID:DHC_HM_OQEQuestion的ID

//得到his中的检查结果

//

ClassMethod GetHisResult(qID)
{
	n (qID)
	s OEID=+qID
	s OEObj=##class(User.DHCHMOEvaluationRecord).GetObj(OEID)
	s regNo=OEObj.QOBaseInfoDR.BIPAPMINo
	q:regNo="" "-1"_$C(1)_"人员没有和外部系统的对照"
	s PAADM=..GetPAADM(regNo)
	q:PAADM="" "-1"_$C(1)_"人员在外部系统中没有就诊记录"
	s OESub=$p(qID,"||",2)
	s titleStr=""
	s resultStr=""
	s sub=0
	f  s sub=$o(^User.DHCHMOQEQuestionD(OEID,OESub,"DHCHMOQResult",sub)) q:sub=""  d
	.s rID=qID_"||"_sub
	.s rObj=##class(User.DHCHMOQResult).GetObj(rID)
	.s detailType=rObj.QRCQuestionsDetailDR.QDType
	.q:(detailType="S")||(detailType="M")
	.s LinkCode=rObj.QRCQuestionsDetailDR.QDLinkCode
	.q:LinkCode=""
	.s result=..GetResult(LinkCode,PAADM)
	.q:result=""
	.i titleStr="" d
	..s titleStr="Q"_qID_"^"_rID
	.e  d
	..s titleStr=titleStr_$C(1)_"Q"_qID_"^"_rID
	.i resultStr="" d
	..s resultStr=result
	.e  d
	..s resultStr=resultStr_$C(1)_result
	q:resultStr="" "-1"_$C(1)_"没有得到外部系统中的结果"
	s jsonStr=##class(web.DHCHM.Json.JsonObj).GetJsonStr(titleStr,resultStr,$C(1))
	q "0"_$C(1)_jsonStr
}

//根据登记号得到最后一次体检记录

ClassMethod GetPAADM(regNo)
{
	n (regNo)
	s baseId=$o(^PAPERi("PAPMI_PatNo",regNo,0))
	q:baseId="" ""
	s PAADM=$O(^PAPERdr(baseId,"ADM","H",""),-1)
	q PAADM
}

//根据外部关联码和PAADM得到外部结果

ClassMethod GetResult(LinkCode, PAADM)
{
	n (LinkCode,PAADM)
	s stID=$O(^DHCPEST(0,"OD_Code",LinkCode,0))
	q:stID="" ""
	s sub=$O(^DHCPEST(0,"OD_Code",LinkCode,stID,0))
	q:sub="" ""
	s detailID=stID_"||"_sub
	s rltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,detailID,0))
	q:rltID="" ""
	s result=$P(^DHCPERLT(rltID),"^",4)
	q result
}

//w ##class(web.DHCHM.Service.GetInfo).GetPatientInfo("0000000001")

ClassMethod GetPatientInfo(PatientNo)
{
	n (PatientNo)
	//调取接口方法得到his病人信息
	s hisInfo=..GetPatientInformation(PatientNo)
	q:hisInfo="" ""
	//性别有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",2)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010003"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010003"," Y",0))
	s $P(hisInfo,"^",2)=Code
	//证件类型有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",4)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010006"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010006"," Y",0))
	s $P(hisInfo,"^",4)=Code
	//婚姻状况有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",6)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010004"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010004"," Y",0))
	s $P(hisInfo,"^",6)=Code
	//职业有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",9)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010001"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010001"," Y",0))
	s $P(hisInfo,"^",9)=Code
	//民族有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",10)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010005"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010005"," Y",0))
	s $P(hisInfo,"^",10)=Code
	//学位有代码取对照的，没有取默认的
	s Code=$P(hisInfo,"^",11)
	i Code'="" d
	.s Code=$O(^User.DHCHMCCodeTableI("TypeExpandCodeIndex"," 10010002"," "_Code,0))
	e  d
	.s Code=$O(^User.DHCHMCCodeTableI("CTDefault"," 10010002"," Y",0))
	s $P(hisInfo,"^",11)=Code
	q hisInfo
}

//取Medtrak信息

//w ##class(web.DHCHM.Service.GetInfo).GetPatientInformation("0000000001")

//返回""登记号不存在

ClassMethod GetPatientInformation(PatientNo)
{
 	n (PatientNo) 
 	s ret=""
  	s PapmiRowid=0 
  	s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",PatientNo,PapmiRowid))
  	q:PapmiRowid="" ""
 	s PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
 	s PatientSexDr=$P($G(^PAPER(PapmiRowid,"ALL")),"^",7)
 	s PatSexCode=$P($G(^CT("SEX",PatientSexDr)),"^",1)
 	s PatientSex = PatSexCode
 	s PatientBirthday=$P($G(^PAPER(PapmiRowid,"ALL")),"^",6)
 	s PatientBirthday=$ZD($G(PatientBirthday),3)
 	s CardType=""      ;证件类型 PAPMI_CardType_DR
 	s CardTypeid=$P($G(^PAPER(PapmiRowid,"PAT",3)),"^",7)
 	s CardTypecode=""
 	i CardTypeid'=""  d
 	.s CardTypecode=$p(^PAC("CARD",CardTypeid),"^",1)
 	s CardType = CardTypecode
 	s DVAnumber=""     ;证件号 PAPMI_DVAnumber
 	s DVAnumber=$P($G(^PAPER(PapmiRowid,"PAT",3)),"^",6)
 	s PatMarital=""    ;婚姻状况 PAPER_Marital_DR
 	s Maritalid=$P($G(^PAPER(PapmiRowid,"PER",2)),"^",3)
 	s Maritalcode=""
 	i Maritalid'=""  d
 	.s Maritalcode=$P(^CT("MAR",Maritalid),"^",1)
 	s PatMarital = Maritalcode
 	s PAPERTel=$P($G(^PAPER(PapmiRowid,"PER",1)),"^",11)    ;电话 取得是家庭电话字段 PAPER_TelH
 	s PatMobPhone=$P($G(^PAPER(PapmiRowid,"PER",4)),"^",21)  ;手机 PAPER_MobPhone
 	s PatOccup=""  ;职业 PAPER_Occupation_DR
 	s Occupid=$P($G(^PAPER(PapmiRowid,"PER",2)),"^",6)
 	s Occupcode=""
 	i Occupid'=""  d
 	.s Occupcode=$P(^CT("OCC",Occupid),"^",1)
 	s PatOccup = Occupcode
    s PatNation=""  ;民族 
    s Nationid=$P($G(^PAPER(PapmiRowid,"PER",2)),"^",1)
 	s Nationcode=""
 	i Nationid'=""  d
 	.s Nationcode=$P(^CT("NAT",Nationid),"^",1)
 	s PatNation = Nationcode
	s PatEdu=""   ;学历  PAPER_Education_DR
	s Eduid=$P($G(^PAPER(PapmiRowid,"PER",2)),"^",5)
 	s Educode=""
 	i Eduid'=""  d
 	.s Educode=$P(^CT("EDU",Eduid),"^",1)
 	s PatEdu = Educode
	s PatEmail=""  ;Email  PAPER_Email
	s PatEmail=$P($G(^PAPER(PapmiRowid,"PER",4)),"^",19)
	s PatZip=""  ;邮编 DHC_Person 表里 PAPER_Comment1
	s dhcpersonid=$o(^DHCPERSON(0,"PAPERSON",PapmiRowid,""))
	i dhcpersonid'=""  s PatZip=$p(^DHCPERSON(dhcpersonid),"^",7)
	s PatCity=""  ;居住城市: PAPER_Country_DR
	s Countryid=$P($G(^PAPER(PapmiRowid,"PER",1)),"^",8)
	i Countryid'=""  s PatCity=$P(^CT("COU",Countryid),"^",2)
	s PatCompany=""  ;工作单位: PAPER_SecondPhon
	s PatCompany=$P($G(^PAPER(PapmiRowid,"PER",4)),"^",18)
	s PatAddress=""  ;联系地址: PAPER_StName
	s PatAddress=$G(^PAPER(PapmiRowid,"PER","ADD",1))
 	s ret=PatientName_"^"_PatientSex_"^"_PatientBirthday_"^"_CardType_"^"_DVAnumber_"^"_PatMarital_"^"_PAPERTel_"^"_PatMobPhone_"^"_PatOccup_"^"_PatNation_"^"_PatEdu_"^"_PatEmail_"^"_PatZip_"^"_PatCity_"^"_PatCompany_"^"_PatAddress
 	q ret
}

}
