Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2022-11-12
/// Description：根据就诊rowid取病案首页记录(ACC0050)
/// Table：
/// encounterId：encounterId：患者就诊rowid
/// Output：
/// Return：病案首页记录(json)
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).CreateAdmFirstPage("21865247").Read()
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).CreateAdmFirstPage("21876059").Read()
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).CreateAdmFirstPage("21895395").Read()
ClassMethod CreateAdmFirstPage(encounterId As %String) As %GlobalCharacterStream
{
	try{
		s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(encounterId,"HDSD00.11")
		s mainObjList={}
		s mainData=[]
		s mainObj={}
		s businessfieldcode="00001"
		s mainObj."businessfieldcode"=businessfieldcode  ///业务域代码
		s mainObj."emrborgcode"=arr.GetAt("HDSD00.11.119") ///医疗机构代码
		s mainObj."emrborgdesc"=arr.GetAt("HDSD00.11.118") ///医疗机构名称
		if mainObj."emrborgdesc"=""
		{
			s admLocDr=$p($g(^PAADM(encounterId)),"^",4)
			s admHospDr=$p($g(^CTLOC(admLocDr)),"^",22),admHospDesc=""
			s:admHospDr'="" admHospDesc=$p($g(^CT("HOSP",admHospDr)),"^",2)
			s mainObj."emrborgdesc"=admHospDesc
		}
		s mainObj."paadmrelvisitnumber"=businessfieldcode_"_"_encounterId ///全局就诊号
		s patientId=$p($g(^PAADM(encounterId)),"^",1)
		s:patientId'="" patientNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)
		s mainObj."papatrelpatientid"=businessfieldcode_"_"_patientId  ///全局患者id
		s mainObj."emrbdocumentno"=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(encounterId,"I",.ErrMsg) ///病案号
		s mainObj."emrbinpatienttimes"= arr.GetAt("HDSD00.11.139") ///住院次数
		s mainObj."emrbinhospdatetime"=..transdate(arr.GetAt("HDSD00.11.085")) ///入院时间
		set:$l(mainObj."emrbinhospdatetime")<19 mainObj."emrbinhospdatetime"=mainObj."emrbinhospdatetime"_":00"
		s mainObj."emrbdischgdatetime"=..transdate(arr.GetAt("HDSD00.11.019"))
		set:$l(mainObj."emrbdischgdatetime")<19 mainObj."emrbdischgdatetime"=mainObj."emrbdischgdatetime"_":00"
		s mainObj."emrbpathealthcardno"= arr.GetAt("HDSD00.11.053")
		s mainObj."emrbpaytypecode"= arr.GetAt("HDSD00.11.117") ///医疗付费方式代码
		///医疗付费方式描述
		s mainObj."emrbpaytypedesc"= arr.GetAt("HDSD00.11.585") ;$case(mainObj."emrbpaytypecode","1":"城镇职工基本医疗保险","2":"城镇居民基本医疗保险","3":"新型农村合作医疗","4":"贫困救助","5":"商业医疗保险","6":"全公费","7":"全自费","8":"其他社会保险","9":"其他",:"")
		s mainObj."emrbpatientname"= arr.GetAt("HDSD00.11.110") ///姓名
		s genderID=arr.GetAt("HDSD00.11.109")
		s:genderID'="" mainObj."emrbgendercode"= genderID ///性别代码
		s:genderID'="" mainObj."emrbgenderdesc"= $p($g(^CT("SEX",genderID)),"^",2) ///性别描述
		s mData=arr.GetAt("HDSD00.11.014")
		s mData=$tr($tr($tr(mData,"年",""),"月",""),"日","")
		s mainObj."emrbbirthdate"= mData ///出生日期
		s mainObj."emrbageyear"= $e(arr.GetAt("HDSD00.11.085"),1,4)-$e(mData,1,4) ///年龄（岁）
		s country=arr.GetAt("HDSD00.11.563"),countryID=""
		s:country'="" countryID=$o(^CT("COU",0,"Desc",country,""))
		s mainObj."emrbcountrycode"= countryID ///国籍代码
		s mainObj."emrbcountrydesc"= country ///国籍描述
		s marital=arr.GetAt("HDSD00.11.050"),maritalID=""
		s:marital'="" maritalID=$o(^CT("MAR",0,"Desc",marital,"")) 
		s mainObj."emrbmaristatuscode"= maritalID ///婚姻代码
		s mainObj."emrbmaristatusdesc"= marital ///婚姻描述
		s occuDesc=arr.GetAt("HDSD00.11.125"),occuID=""
		s:occuDesc'="" occuID=$o(^CT("OCC",0,"Desc",occuDesc,""))
		s mainObj."emrboccucode"= occuID ///职业代码
		s mainObj."emrboccudesc"= occuDesc ///职业描述
		s nationCode=arr.GetAt("HDSD00.11.077")
		s nationID=$o(^CT("NAT",0,"Code",nationCode,""))
		s mainObj."emrbnationcode"= nationID ///民族
		s:nationID'="" mainObj."emrbnationdesc"= $p($g(^CT("NAT",nationID)),"^",2) ///民族描述
		s credTypeDr=arr.GetAt("HDSD00.11.049"),credType=""
		s mainObj."emrbcredtypecode"= credTypeDr ///证件类别代码
		s:credTypeDr'="" mainObj."emrbcredtypedesc"=$p($g(^PAC("CARD",credTypeDr)),"^",2) ///证件类别描述
		s mainObj."emrbcredno"= arr.GetAt("HDSD00.11.048") ///证件号码
		s:mainObj."emrbcredno"="－" mainObj."emrbcredno"="-"
		s:mainObj."emrbcredno"="—" mainObj."emrbcredno"="-"
		s bornProvince=arr.GetAt("HDSD00.11.051")
		s bornCity=arr.GetAt("HDSD00.11.012")
		s bornCounty=arr.GetAt("HDSD00.11.013")
		s mainObj."emrbbornaddrdesc"= bornProvince_bornCity_bornCounty ///出生地址
		s mainObj."emrbnativeprovdesc"= arr.GetAt("HDSD00.11.051") ///籍贯省（自治区、直辖市）
		s addressProvince=arr.GetAt("HDSD00.11.102")
		s addressCity=arr.GetAt("HDSD00.11.103")
		s addressCounty=arr.GetAt("HDSD00.11.104")
		s addressXiang=arr.GetAt("HDSD00.11.105")
		s addressVillage=arr.GetAt("HDSD00.11.100")
		s addressNumber=arr.GetAt("HDSD00.11.101")
		s mainObj."emrbdomicileaddrdesc"= addressProvince_addressCity_addressCounty_addressXiang_addressVillage_addressNumber ///户口地址
		s mainObj."emrbdomicilepostcode"= arr.GetAt("HDSD00.11.106") ///户口地址邮政编码
		s residentProvince=arr.GetAt("HDSD00.11.043")
		s residentCity=arr.GetAt("HDSD00.11.044")
		s residentCounty=arr.GetAt("HDSD00.11.045")
		s residentXiang=arr.GetAt("HDSD00.11.046")
		s residentVillage=arr.GetAt("HDSD00.11.041")
		s residentNumber=arr.GetAt("HDSD00.11.042")
		s mainObj."emrbhomeaddress"= residentProvince_residentCity_residentCounty_residentXiang_residentVillage_residentNumber ///现住址
		s mainObj."emrbhometel"= arr.GetAt("HDSD00.11.026") ///现住址电话
		s mainObj."emrbhomepostcode"=arr.GetAt("HDSD00.11.047")  ///现住址邮政编码
		s mainObj."emrbworkplacedesc"= arr.GetAt("HDSD00.11.029") ///工作单位及地址
		s mainObj."emrbworkplacetel"= arr.GetAt("HDSD00.11.034") ///工作单位电话
		s mainObj."emrbworkplacepostcode"= arr.GetAt("HDSD00.11.033") ///工作单位邮政编码
		s mainObj."emrbcontname"= arr.GetAt("HDSD00.11.065") ///联系人姓名
		s mainObj."emrbcontrelcode"= arr.GetAt("HDSD00.11.066") ///联系人关系代码
		s mainObj."emrbcontreldesc"= arr.GetAt("HDSD00.11.066") ///联系人关系描述
		s mainObj."emrbcontactaddress"= arr.GetAt("HDSD00.11.565")
		s mainObj."emrbcontactphone"= arr.GetAt("HDSD00.11.064")
		s mainObj."emrbdaysurgeryflag"= "0"
		s mainObj."emrbinhospway"= arr.GetAt("HDSD00.11.086") //入院途径
		s ryks=arr.GetAt("HDSD00.11.084")
		s mainObj."emrbinhospdeptcode"= ryks
		s mainObj."emrbinhospwardcode"= arr.GetAt("HDSD00.11.083")
		s mainObj."emrbtransdeptcode"= $p(arr.GetAt("HDSD00.11.144"),"->",2)
		s mainObj."emrbdischgdeptcode"= arr.GetAt("HDSD00.11.018")
		s mainObj."emrbdischgroom"= arr.GetAt("HDSD00.11.017")
		s ry=..transdate(arr.GetAt("HDSD00.11.085"))
		set AdmDDate=arr.GetAt("HDSD00.11.019")
		set cy=..transdate(AdmDDate)
		s mainObj."emrbinpatientdays"= $zdh($p(cy," ",1),8)-ry
		s:mainObj."emrbinpatientdays"="0" mainObj."emrbinpatientdays"="1"
		s MJDiagStr=##class(DHCWMR.IO.OutService).IGetFrontPageICD(encounterId,"D/6") //编目后门急诊诊断
		s mainObj."emrbopdiagcode"= $p(MJDiagStr,$c(2),1) 
		s mainObj."emrbopdiagdesc"= $p(MJDiagStr,$c(2),2) 
		s mainObj."emrbinhospcondition"= arr.GetAt("HDSD00.11.883") 
		s mainObj."emrbinhospdiagcode"= $p(MJDiagStr,$c(2),1) 
		s mainObj."emrbinhospdiagdesc"= $p(MJDiagStr,$c(2),1) 
		s mainObj."emrbipdiagconfirmdate"= arr.GetAt("HDSD00.11.876") 
		set OtherStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/5") ;##Class(web.DHCWMRCodingInterface).getFrontPageICDList(encounterId,"D/5")
		if ($P(OtherStr,$c(2),1)'=""){
			s mainObj."emrbinjurypoisonreasoncode"= $P(OtherStr,$c(2),1)
			s mainObj."emrbinjurypoisonreasondesc"= $P(OtherStr,$c(2),1)
		}
		s mainObj."emrballergyflag"= arr.GetAt("HDSD00.11.037")
		s mainObj."emrballergydrug"= arr.GetAt("HDSD00.11.116")
		s mainObj."emrbhbsag"= ""
		s mainObj."emrbhcvab"= ""
		s mainObj."emrbhivab"= ""
		s mainObj."emrbdeptdirectorname"= arr.GetAt("HDSD00.11.137"),DocRowId=""
		if mainObj."emrbdeptdirectorname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbdeptdirectorname",""))
		if DocRowId'="" s mainObj."emrbdeptdirectorcode"=$P(^CTPCP(DocRowId,2),"^",8)
		else  s mainObj."emrbdeptdirectorcode"="-"
		s mainObj."emrbchiefdocname"= arr.GetAt("HDSD00.11.137")
		if mainObj."emrbchiefdocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbchiefdocname",""))
	    if DocRowId'="" s mainObj."emrbchiefdoccode"=$P(^CTPCP(DocRowId,2),"^",8)
		else  s mainObj."emrbchiefdoccode"="-"
		s mainObj."emrbmaindocname"=arr.GetAt("HDSD00.11.138")
		if mainObj."emrbmaindocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbmaindocname",""))
    	if DocRowId'="" s mainObj."emrbmaindoccode"=$P(^CTPCP(DocRowId,2),"^",8)
		else  s mainObj."emrbmaindoccode"="-"
		s mainObj."emrbinhospdocname"= arr.GetAt("HDSD00.11.141") 
		if mainObj."emrbinhospdocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbinhospdocname",""))
    	if DocRowId'="" s mainObj."emrbinhospdoccode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbinhospdoccode" = "-"
		
		s mainObj."emrbrespnurname"= arr.GetAt("HDSD00.11.120")
		if mainObj."emrbrespnurname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbrespnurname",""))
		if DocRowId'="" s mainObj."emrbrespnurcode"=$P(^CTPCP(DocRowId,2),"^",8)
		else  s mainObj."emrbrespnurcode"="-"
		
		s mainObj."emrbstudydocname"= arr.GetAt("HDSD00.11.580")
		if mainObj."emrbstudydocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbstudydocname",""))
    	if DocRowId'="" s mainObj."emrbstudydoccode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbstudydoccode"="-"

		s mainObj."emrbpracticedocname"= arr.GetAt("HDSD00.11.581")
		if mainObj."emrbpracticedocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbpracticedocname",""))
    	if DocRowId'="" s mainObj."emrbpracticedoccode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbpracticedoccode"="-"

		s mainObj."emrbcodername"= arr.GetAt("HDSD00.11.582")
		if mainObj."emrbcodername"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbcodername",""))
    	if DocRowId'="" s mainObj."emrbcodercode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbcodercode"="-"
		s mainObj."emrbmedirecquality"= arr.GetAt("HDSD00.11.007")
		
		s mainObj."emrbmedirecqualitydocname"= arr.GetAt("HDSD00.11.128")
		if mainObj."emrbmedirecqualitydocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbmedirecqualitydocname",""))
    	if DocRowId'="" s mainObj."emrbmedirecqualitydoccode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbmedirecqualitydoccode"="-"

		s mainObj."emrbmedirecqualitynurname"= arr.GetAt("HDSD00.11.126")
		if mainObj."emrbmedirecqualitynurname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",mainObj."emrbmedirecqualitynurname",""))
    	if DocRowId'="" s mainObj."emrbmedirecqualitynurcode"=$P(^CTPCP(DocRowId,2),"^",8)
    	else  s mainObj."emrbmedirecqualitynurcode"="-"
    	
		set QualityDays=arr.GetAt("HDSD00.11.127")	
		set QualityDays=$tr(QualityDays,"年","-")
		set QualityDays=$tr(QualityDays,"月","-")
		set QualityDays=$tr(QualityDays,"日","")
		s mainObj."emrbmedirecqualitydate"= QualityDays
		s feathFlag=arr.GetAt("HDSD00.11.095")
		s:(feathFlag["-") mainObj."emrbautopsyflag"="2"
		s mainObj."emrbabo"= arr.GetAt("HDSD00.11.003")
		s mainObj."emrbrh"= arr.GetAt("HDSD00.11.004")
		s mainObj."emrbsupercaredays"= arr.GetAt("HDSD00.11.892")
		s mainObj."emrblevelonecaredays"= arr.GetAt("HDSD00.11.893")
		s mainObj."emrbleveltwocaredays"= arr.GetAt("HDSD00.11.894")
		s mainObj."emrblevelthreecaredays"= arr.GetAt("HDSD00.11.895")
		s mainObj."emrbbloodreaction"= ""
		s mainObj."emrberythrocytenum"= arr.GetAt("HDSD00.11.994") 
		s mainObj."emrbplateletnum"= arr.GetAt("HDSD00.11.995")
		s mainObj."emrbplasmanum"= arr.GetAt("HDSD00.11.996")
		s mainObj."emrbfullbloodnum"= arr.GetAt("HDSD00.11.997")
		s mainObj."emrbselfbloodrettrans"= arr.GetAt("HDSD00.11.998")
		s age=$P(arr.GetAt("HDSD00.11.079"),"岁",1)
		s ageY=$P(arr.GetAt("HDSD00.11.079"),"月",1)
		s ageM=arr.GetAt("HDSD00.11.080")
		i ((age="")&&(ageY'="")&&(ageM="")) s ageM=ageY
		s mainObj."emrbagelessthan1y"= +ageM
		set bornweight=arr.GetAt("HDSD00.11.107")  
		s mainObj."emrbbornweight1"= bornweight
		s mainObj."emrbbornweight2"= ""
		s mainObj."emrbbornweight3"= ""
		s mainObj."emrbbornweight4"= ""
		s mainObj."emrbbornweight5"= ""
		s mainObj."emrbinhospweight"= arr.GetAt("HDSD00.11.108") 
		s mainObj."emrbcomadaysbeforeadmbybraininjury"= arr.GetAt("HDSD00.11.070") //颅脑损伤
		s mainObj."emrbcomahoursbeforeadmbybraininjury"= arr.GetAt("HDSD00.11.071")
		s mainObj."emrbcomaminutesbeforeadmbybraininjury"= arr.GetAt("HDSD00.11.072")
		s mainObj."emrbcomadaysafteradmbybraininjury"= arr.GetAt("HDSD00.11.067")
		s mainObj."emrbcomahoursafteradmbybraininjury"= arr.GetAt("HDSD00.11.068")
		s mainObj."emrbcomaminutesafteradmbybraininjury"= arr.GetAt("HDSD00.11.069")
		s mainObj."emrbbreathmachusagetime"= arr.GetAt("HDSD00.11.555")
		s mainObj."emrbrehospin31daysflag"= arr.GetAt("HDSD00.11.015")
		s mainObj."emrbrehospin31dayspurp"= arr.GetAt("HDSD00.11.604") 
		s mainObj."emrbleavewaycode"= arr.GetAt("HDSD00.11.057")
		s mainObj."emrbleavewaydesc"= arr.GetAt("HDSD00.11.057")
		s mainObj."emrbtransinmediorgdesc"= arr.GetAt("HDSD00.11.1002") ;医嘱转社区卫生服务机构/乡镇卫生院，拟接收医疗机构名称
		s DiagnoseObjList=[]
		// 取编目后门（急）诊断信息
		s mJDiagStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/1")
		s orDiagoseObj={}
		//s orDiagoseObj."id"=""  //encounterId_"_1" //诊断id
		s orDiagoseObj."emrdshowseq"="1"
		s orDiagoseObj."emrddiagnosecode"=$p(mJDiagStr,$c(2),1)
		s orDiagoseObj."emrddiagnosedesc"=$p(mJDiagStr,$c(2),2)
		s orDiagoseObj."emrdinhospcondcode"=$p(mJDiagStr,$c(2),5)
		s orDiagoseObj."emrdinhospconddesc"=$p(mJDiagStr,$c(2),6)
		s orDiagoseObj."emrdouthospcondcode"=$p(mJDiagStr,$c(2),3)
		s orDiagoseObj."emrdouthospconddesc"=$p(mJDiagStr,$c(2),4)
		s orDiagoseObj."emrddiagtypecode"="1"
		s orDiagoseObj."emrddiagtypedesc"="门（急）诊断"
		s orDiagoseObj."emrdmainflag"=""
		d DiagnoseObjList.%Push(orDiagoseObj)

		// 取编目后中主要诊断信息
		s mMainDiagStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/3")
		s mDiagoseObj={}
		//s mDiagoseObj."id"=""  //encounterId_"_2"
		s mDiagoseObj."emrdshowseq"="2"
		s mDiagoseObj."emrddiagnosecode"=$p(mMainDiagStr,$c(2),1)
		s mDiagoseObj."emrddiagnosedesc"=$p(mMainDiagStr,$c(2),2)
		s mDiagoseObj."emrdinhospcondcode"=$p(mMainDiagStr,$c(2),5)
		s mDiagoseObj."emrdinhospconddesc"=$p(mMainDiagStr,$c(2),6)
		s mDiagoseObj."emrdouthospcondcode"=$p(mMainDiagStr,$c(2),3)
		s mDiagoseObj."emrdouthospconddesc"=$p(mMainDiagStr,$c(2),4)
		s mDiagoseObj."emrddiagtypecode"="3"
		s mDiagoseObj."emrddiagtypedesc"="主要诊断"
		s mDiagoseObj."emrdmainflag"="Y"
		d DiagnoseObjList.%Push(mDiagoseObj)

		//取编目中其他诊断信息
		s otherDiagStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/4")
		set OLength=$L(otherDiagStr,$c(1))
		f j=1:1:OLength
		{
			set TmpStr=$p(otherDiagStr,$c(1),j)
			continue:TmpStr=""
			s otherDiagoseObj={}
			//s otherDiagoseObj."id"=""  //encounterId_"_"_(j+2)
			s otherDiagoseObj."emrdshowseq"=j+2
			s otherDiagoseObj."emrddiagnosecode"=$p(TmpStr,$c(2),1)
			s otherDiagoseObj."emrddiagnosedesc"=$p(TmpStr,$c(2),2)
			s otherDiagoseObj."emrdinhospcondcode"=$P(TmpStr,$c(2),5)
			s otherDiagoseObj."emrdinhospconddesc"=$P(TmpStr,$c(2),6)
			s otherDiagoseObj."emrdouthospcondcode"=$P(TmpStr,$c(2),3)
			s otherDiagoseObj."emrdouthospconddesc"=$P(TmpStr,$c(2),4)
			s otherDiagoseObj."emrddiagtypecode"="4"
			s otherDiagoseObj."emrddiagtypedesc"="其他诊断"
			s otherDiagoseObj."emrdmainflag"=""
			d DiagnoseObjList.%Push(otherDiagoseObj)
		}

		set OtherStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/5") 
		if ($P(OtherStr,$c(2),1)'=""){
		set MarDiagnoseObj={}
		//set MarDiagnoseObj."id"=""  //encounterId_"_"_(OLength+3)
		set MarDiagnoseObj."emrdshowseq"=OLength+3
		set MarDiagnoseObj."emrddiagnosecode"=$P(OtherStr,$c(2),1)
		set MarDiagnoseObj."emrddiagnosedesc"=$P(OtherStr,$c(2),2)
		set MarDiagnoseObj."emrdinhospcondcode"=$P(OtherStr,$c(2),5)
		set MarDiagnoseObj."emrdinhospconddesc"=$P(OtherStr,$c(2),6)
		set MarDiagnoseObj."emrdouthospcondcode"=$P(OtherStr,$c(2),3)
		set MarDiagnoseObj."emrdouthospconddesc"=$P(OtherStr,$c(2),4)
		set MarDiagnoseObj."emrddiagtypecode"="5"
		set MarDiagnoseObj."emrddiagtypedesc"="损伤中毒的外部因素"
		set MarDiagnoseObj."emrdmainflag"=""
		d DiagnoseObjList.%Push(MarDiagnoseObj)
		
	}
	set pisDiagStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"D/7")   
	if ($P(pisDiagStr,$c(2),1)'=""){
		set PISDiagnoseObj={}
		//set PISDiagnoseObj."id"=""  //encounterId_"_"_(OLength+4)
		set PISDiagnoseObj."emrdshowseq"=OLength+4
		set PISDiagnoseObj."emrddiagnosecode"=$P(pisDiagStr,$c(2),1)
		set PISDiagnoseObj."emrddiagnosedesc"=$P(pisDiagStr,$c(2),2)
		set PISDiagnoseObj."emrdinhospcondcode"=$P(pisDiagStr,$c(2),5)
		set PISDiagnoseObj."emrdinhospconddesc"=$P(pisDiagStr,$c(2),6)
		set PISDiagnoseObj."emrdouthospcondcode"=$P(pisDiagStr,$c(2),3)
		set PISDiagnoseObj."emrdouthospconddesc"=$P(pisDiagStr,$c(2),4)
		set PISDiagnoseObj."emrddiagtypecode"="7"
		set PISDiagnoseObj."emrddiagtypedesc"="病理诊断"
		set PISDiagnoseObj."emrdmainflag"=""
		d DiagnoseObjList.%Push(PISDiagnoseObj)
	}
	else {
		s ZYZDCode=$P(pisDiagStr,$c(2),1)
		i ZYZDCode["C" {
			set PISDiagnoseObj={}
			//set PISDiagnoseObj."id"=""  //encounterId_"_"_(OLength+4)
			set PISDiagnoseObj."emrdshowseq"=OLength+4
			set PISDiagnoseObj."emrddiagnosecode"="M80000/3"
			set PISDiagnoseObj."emrddiagnosedesc"="恶性肿瘤"
			;set PISDiagnose.PathologyNo=arr.GetAt("HDSD00.11.008")
			;i PISDiagnose.PathologyNo="" s PISDiagnose.PathologyNo="-"
			;set PISDiagnose.DiagnoseMarker=4
			set PISDiagnoseObj."emrdinhospcondcode"=""
			set PISDiagnoseObj."emrdinhospconddesc"=""
			set PISDiagnoseObj."emrdouthospcondcode"=""
			set PISDiagnoseObj."emrdouthospconddesc"=""
			set PISDiagnoseObj."emrddiagtypecode"=""
			set PISDiagnoseObj."emrddiagtypedesc"=""
			set PISDiagnoseObj."emrdmainflag"=""
			d DiagnoseObjList.%Push(PISDiagnoseObj)
		}elseif ZYZDCode["D0" {
			set PISDiagnose={}
			//set PISDiagnoseObj."id"=""  //encounterId_"_"_(OLength+4)
			set PISDiagnoseObj."emrdshowseq"=OLength+4
			set PISDiagnose."emrddiagnosecode"="M80100/3"
			set PISDiagnose."emrddiagnosedesc"="原位癌"
			set PISDiagnoseObj."emrdinhospcondcode"=""
			set PISDiagnoseObj."emrdinhospconddesc"=""
			set PISDiagnoseObj."emrdouthospcondcode"=""
			set PISDiagnoseObj."emrdouthospconddesc"=""
			set PISDiagnoseObj."emrddiagtypecode"=""
			set PISDiagnoseObj."emrddiagtypedesc"=""
			set PISDiagnoseObj."emrdmainflag"=""
			d DiagnoseObjList.%Push(PISDiagnoseObj)
		}elseif ((ZYZDCode["D1")||(ZYZDCode["D2")||(ZYZDCode["D3")||(ZYZDCode["D4")) {
			set PISDiagnose={}
			//set PISDiagnoseObj."id"=""  //encounterId_"_"_(OLength+4)
			set PISDiagnoseObj."emrdshowseq"=OLength+4
			set PISDiagnoseObj."emrddiagnosecode"="M80000/0"
			set PISDiagnoseObj."emrddiagnosedesc"="良性肿瘤"
			set PISDiagnoseObj."emrdinhospcondcode"=""
			set PISDiagnoseObj."emrdinhospconddesc"=""
			set PISDiagnoseObj."emrdouthospcondcode"=""
			set PISDiagnoseObj."emrdouthospconddesc"=""
			set PISDiagnoseObj."emrddiagtypecode"=""
			set PISDiagnoseObj."emrddiagtypedesc"=""
			set PISDiagnoseObj."emrdmainflag"=""
			d DiagnoseObjList.%Push(PISDiagnoseObj)
		}
		s mainObj."emrdiagoseinfo"=DiagnoseObjList
		///手术、重症、费用！
		set OperListObj=[]
		set operStr=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(encounterId,"O") //取出所有手术
		set operlen=$L(operStr,$c(1))
		f k=1:1:operlen
		{	
		set TmpStr=$p(operStr,$c(1),k)
		set oper={}
		//set oper."id"=""
		set oper."emroshowseq"=k
		set oper."emrooperationcode"=$P(TmpStr,$c(2),1)
		Continue:$P(TmpStr,$c(2),1)=""
		set oper."emrooperationdesc"=$P(TmpStr,$c(2),2)
		set oper."emrooperationdate"=$P(TmpStr,$c(2),3)
		set oper."emrooperlevelcode"=$P(TmpStr,$c(2),21)
		set oper."emrooperleveldesc"=$P(TmpStr,$c(2),22)
		set oper."emroopertypecode"=""
		set oper."emroopertypedesc"="" //手术类型（择期/急诊/日间）
		set oper."emrooperlasttime"=""
		set OperationDocName=$P(TmpStr,$c(2),8)
		set oper."emrooperdocname"=OperationDocName
		if oper."emrooperdocname"'="" Set DocRowId=$O(^CTPCP(0,"Decs",oper."emrooperdocname",""))
    	if DocRowId'="" s oper."emrooperdoccode"=DocRowId  //$P(^CTPCP(DocRowId,1),"^",1)
    	else  s oper."emrooperdoccode" = "-"
		;set oper."emrofirstassicode"=""
		set oper."emrofirstassiname"=$P(TmpStr,$c(2),10),firstDocRowId=""
		if oper."emrooperdocname"'="" Set firstDocRowId=$O(^CTPCP(0,"Decs",oper."emrofirstassiname",""))
    	if firstDocRowId'="" s oper."emrofirstassicode"=firstDocRowId  //$P(^CTPCP(firstDocRowId,1),"^",1)
		;set oper."emrosecondassicode"=""
		set oper."emrosecondassiname"=$P(TmpStr,$c(2),12),secondDocRowId=""
		if oper."emrosecondassiname"'="" Set secondDocRowId=$O(^CTPCP(0,"Decs",oper."emrosecondassiname",""))
    	if secondDocRowId'="" s oper."emrosecondassicode"=secondDocRowId  //$P(^CTPCP(secondDocRowId,1),"^",1)
		set oper."emrocutheallevelcode"=$Case($P(TmpStr,$c(2),18)_"/"_$P(TmpStr,$c(2),20),"Ⅰ/甲":"1","Ⅰ/乙":"2","Ⅰ/丙":"3","Ⅱ/甲":"4","Ⅱ/乙":"5","Ⅱ/丙":"6","Ⅲ/甲":"7","Ⅲ/乙":"8","Ⅲ/丙":"9","无/无":"0/其他",:"1")
		set oper."emrocuthealleveldesc"=$P(TmpStr,$c(2),18)_"/"_$P(TmpStr,$c(2),20)
		;set oper."emroanesmethodcode"=""
		set oper."emroanesmethoddesc"=$P(TmpStr,$c(2),14),AnMethodRowId=""
		if oper."emroanesmethoddesc"'="" Set AnMethodRowId=$O(^ORC("ANMET",0,"Desc",oper."emroanesmethoddesc",""))
    	if AnMethodRowId'="" s oper."emroanesmethodcode"=AnMethodRowId  //$P(^ORC("ANMET",AnMethodRowId),"^",1)
		set oper."emroanesclass"=""
		;set oper."emroanesdoccode"=""
		set oper."emroanesdocname"=$P(TmpStr,$c(2),16),anesDocRowId=""
		if oper."emroanesdocname"'="" Set anesDocRowId=$O(^CTPCP(0,"Decs",oper."emroanesdocname",""))
    	if anesDocRowId'="" s oper."emroanesdoccode"=anesDocRowId  //$P(^CTPCP(anesDocRowId,1),"^",1)
		
		set oper."emromainflag"=$P(TmpStr,$c(2),26) ;$case($P(TmpStr,$c(2),26),"手术":"1","操作":"0",:"")
		d OperListObj.%Push(oper)
	
	}
	set mainObj."emroopainfo"=OperListObj
	// 患者重症监护信息
	set StartDiagnose=545
	set SeverityWardList=[]
	for
	{
		set StartDiagnose=+StartDiagnose+1
		q:(StartDiagnose>554)
		set tmpInput="HDSD00.11."_StartDiagnose
		set TmpString=arr.GetAt(tmpInput)
		q:(TmpString="")
		set SeverityWard={}
		//set SeverityWard."id"=""
		set SeverityWard."emrsshowseq"=""
		set SeverityWard."emrsicucode"=arr.GetAt(tmpInput)
		set SeverityWard."emrsicudesc"=arr.GetAt(tmpInput)
		set StartDiagnose=+StartDiagnose+1
		set tmpInput=$E(tmpInput,1,10)_StartDiagnose
		set SeverityWard."emrsinicudatetime"=..transdate(arr.GetAt(tmpInput))
		set StartDiagnose=+StartDiagnose+1
		set tmpInput=$E(tmpInput,1,10)_StartDiagnose
		set SeverityWard."emrsouticudatetime"=..transdate(arr.GetAt(tmpInput))
		d SeverityWardList.%Push(SeverityWard)			
	}
	set mainObj."emrserveinfo"=SeverityWardList

	
	set chargeListObj=[]
	/// 得到新病案首页子类
	s TotalMoney=0
    s TMCNewChargeStr=##class(web.DHCBillInterface).IGetTarItemCate(encounterId,"","TMCNew","^^^^") 
	s TMCNewLength=$Length(TMCNewChargeStr,"!")
	s LcwlCharge="",FLcwlCharge="",MzCharge="",ShoushuCharge="",KangjunCharge="",XYF=""
	//s TotalMoney=0 
	set chargeObj={}
	s i=1 for i=1:1:TMCNewLength
	{
		s TmpStr=$p(TMCNewChargeStr,"!",i)
		// 临床物理治疗费（取代码）
 		if $p(TmpStr,"^",2)="临床物理治疗费"
		{
			s chargeObj."emrcclinicphysiofee"=$p(TmpStr,"^",4)
		}
 
 		// 麻醉费（取代码）
 		if $p(TmpStr,"^",2)="麻醉费"
		{
 			s chargeObj."emrcanesthesiafee"=$p(TmpStr,"^",4)
		}
 
 		// 手术费（取代码）
 		if $p(TmpStr,"^",2)="手术费"
		{
 			s chargeObj."emrcoperationfee"=$p(TmpStr,"^",4)
		}
 
 		// 抗菌药物费（取代码）
 		if $p(TmpStr,"^",2)="抗菌药物费"
		{
 			s chargeObj."emrcantibioticsfee"=$p(TmpStr,"^",4)
		}
 
 		if $p(TmpStr,"^",2)="西药费"
		{
 			s chargeObj."emrcmedicinefee"=$p(TmpStr,"^",4)

		}

		if $p(TmpStr,"^",2)="一般医疗服务费"
		{
			s chargeObj."emrcgenemediservicefee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="一般治疗操作费"
		{
			s chargeObj."emrcgenetreatoperfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="护理费"
		{
			s chargeObj."emrccarefee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="综合医疗服务类其他费用"
		{
			s chargeObj."emrcintegmediserviceothfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="病理诊断费"
		{
			s chargeObj."emrcpathodiagfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="实验室诊断费"
		{
			s chargeObj."emrclabdiagfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="影像学诊断费"
		{
			s chargeObj."emrcimgdiagfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="临床诊断项目费"
		{
			s chargeObj."emrcclinicdiagfee"=$p(TmpStr,"^",4)
		}
		/// 非手术治疗项目费
		s chargeObj."emrcnonopertreatfee"=chargeObj."emrcclinicphysiofee"
		
		///手术治疗费
		s chargeObj."emrcgenemediservicefee"=chargeObj."emrcanesthesiafee"+chargeObj."emrcoperationfee"
		
		if $p(TmpStr,"^",2)="康复费"
		{
			s chargeObj."emrcrehabilitationfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="中医治疗费"
		{
			s chargeObj."emrcchimeditreatfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="中成药费"
		{
			s chargeObj."emrcpropchimedfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="中草药费"
		{
			s chargeObj."emrcchiherbalfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="血费"
		{
			s chargeObj."emrcbloodfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="白蛋白类制品费"
		{
			s chargeObj."emrcalbuminproductfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="球蛋白类制品费"
		{
			s chargeObj."emrcballproteinproductfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="凝血因子类制品费"
		{
			s chargeObj."emrccoagfactproductfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="细胞因子类制品费"
		{
			s chargeObj."emrccellfactproductfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="检查用一次性医用材料费"
		{
			s chargeObj."emrcexammaterialsfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="治疗用一次性医用材料费"
		{
			s chargeObj."emrctreatmaterialsfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="手术用一次性医用材料费"
		{
			s chargeObj."emrcopermaterialsfee"=$p(TmpStr,"^",4)
		}
		if $p(TmpStr,"^",2)="其他费"
		{
			s chargeObj."emrcotherfee"=$p(TmpStr,"^",4)
		}
		s TotalMoney=+$p(TmpStr,"^",4)+TotalMoney
	}
	s chargeObj."emrctotalfee"=TotalMoney
	s chargeObj."emrcselfpay"=""
	d chargeListObj.%Push(chargeObj)
	set mainObj."emrchargeinfo"=chargeListObj  //chargeObj
 
	}
	do mainData.%Push(mainObj)
	s mainObjList."data"=mainData
	s rtn= mainObjList.%ToJSON()
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(rtn)
	}
	catch{
		s $zt=""
		s stream=##class(%Stream.GlobalCharacter).%New()
		d stream.Write($ze)
	}
	q stream
}

/// Desc:日期格式转换
/// Debug:w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).transdate("20211003T130034")
ClassMethod transdate(dateTime As %String) As %String
{
	s dtime=""
	i (dateTime["T")&&($l(dateTime)=15)
	{
		s year=$e(dateTime,1,4)
		s month=$e(dateTime,5,6)
		s day=$e(dateTime,7,8)
		s hour=$e(dateTime,10,11)
		s min=$e(dateTime,12,13)
		s sec=$e(dateTime,14,15)
		s dtime=year_"-"_month_"-"_day_" "_hour_":"_min_":"_sec
	}
	i (dateTime["年")||(dateTime["分")
	{
		s dtime=$replace($replace($replace($replace($replace(dateTime,"年","-"),"月","-"),"日",""),"时",":"),"分",":")
		s:$l(dtime)=17 dtime=dtime_"00"
	}
	q dtime
}

/// Debug:w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).GetAdmByMasterID("1")
ClassMethod GetAdmByMasterID(xMasterID As %String) As %String
{
	try{
		set episodeID=""
		set volumeID=$lg($g(^MA.IPMR.FP.DataMasterD(xMasterID)),2)
		q:volumeID=""
		set volAdmStr=##class(MA.IPMR.SS.VolPaadm).GetAdmStrByVol(volumeID)
		q:volAdmStr=""
		set episodeID=$p(volAdmStr,",",2)
		}
	catch{
		s $zt=""
	}
	q episodeID
}

/// Creator：ZhangXinying
/// CreatDate：2022—11-18
/// Description：数据中心-通过病案卷ID获取就诊ID
/// Table：MA_IPMR_SS.Volume、MA_IPMR_SS.VolPaadm
/// Input：卷ID
/// Return：就诊ID
/// Debug: w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).GetAdmFirstPageByVolID(42294).Read()
ClassMethod GetAdmFirstPageByVolID(volumeID As %String) As %Stream.GlobalCharacter
{
	try{
		set episodeID=""
		set stream=##class(%Stream.GlobalCharacter).%New()
		set svOrdStep=$lg($g(^MA.IPMR.SS.VolumeD(volumeID)),4)
		q:(svOrdStep'="D")&&(svOrdStep'="S") //归档D，上架S
		set volAdmStr=##class(MA.IPMR.SS.VolPaadm).GetAdmStrByVol(volumeID)
		q:volAdmStr=""
		set episodeID=$p(volAdmStr,",",2)
		set:episodeID["||" episodeID=$p(episodeID,"||",1)
		set stream=..CreateAdmFirstPage(episodeID)
	}
	catch{
		set stream=##class(%Stream.GlobalCharacter).%New()
		set $zt=""
	}
	q stream
}

/// Creator：ZhangXinying
/// CreatDate：2023—01-08
/// Description：数据中心-上传病案编目归档上架历史数据
/// Table：MA_IPMR_SS.Volume
/// Input：空
/// Return：0
/// Debug:w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmFirstPage).SendAdmFirstPageHistory()
ClassMethod SendAdmFirstPageHistory() As %String
{
	try
	{
		s volID=""
		for
		{
			s volID=$o(^MA.IPMR.SS.VolumeD(volID))
			q:volID=""
			s svOrdStep=$lg($g(^MA.IPMR.SS.VolumeD(volID)),4)
			continue:(svOrdStep'="D")&&(svOrdStep'="S") //归档D，上架S
			s soap=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Soap.HIPMessageServerSoap).%New()
			s stream=##class(%Stream.GlobalCharacter).%New()
			d stream.Write(volID)
			s rtnStream=soap.HIPMessageServer("ACC0050",stream)
			s rtn=rtnStream.Read()
			w !,"上传病案编目归档上架历史数据,卷号:"_volID_","_rtn
			d stream.Clear()
		}
	}
	catch
	{
		s $zt=""	
	}
	q "0"
}

}
