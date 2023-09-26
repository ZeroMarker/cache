Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2019—06-21
/// Description：根据患者ID获取患者基本信息(ACC0001)
/// Table：PA_PatMas / pa_person
/// Input：patRowId：患者ID
/// Output：
/// Return：数据中心pa_patient患者基本信息(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo).PAPatientByPatRowId("10")
ClassMethod PAPatientByPatRowId(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PatientInfo).%New()
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..getSubPatInfo(patRowId)
	d obj.PatientInfoList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo).getSubPatInfo(10)
ClassMethod getSubPatInfo(patRowId As %String) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PatientInfo
{
	
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PatientInfo).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set papathosregno=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set subObj.papathosregno=papathosregno                              //院内登记号
	set subObj.papatrelregno=businessfieldcode_"_"_papathosregno	//全局登记号
	set subObj.papathospatientid=patRowId                            //院内患者id
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.papatdename=$e($replace($p($g(^PAPER(patRowId,"ALL")),"^",1)," ",""),1,60)     //患者姓名
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay'="" subObj.papatdedob=$zd(birthDay,3)             //出生日期
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set subObj.papatdesexcode=sexRowID
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set subObj.papatdemaritalstatuscode=marryRowID   
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	set subObj.papatdenationcode=nationRowID 
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set subObj.papatdecountrycode=countryRowID
	set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
	set:deathDate'="" subObj.papatdedeceaseddate=$zd(deathDate,3) //死亡日期
	set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)           
	set:deathTime'="" subObj.papatdedeceasedtime=$zt(deathTime)  //死亡时间
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)    
	set subObj.papatupdateusercode=UpdateUserDr
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" subObj.papatupdatedate=$zd(UpdateDate,3) //最后更新日期
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)           
	set:UpdateTime'="" subObj.papatupdatetime=$zt(UpdateTime,1) //最后更新时间
	set PATMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
	set:PATMotherID'="" subObj.papatmotherid=$p($g(^PAPER(PATMotherID,"PAT",1)),"^",1)  //母亲id
	set subObj.papatremarks=""                            //备注
	set subObj.papathealthcardid=""                       //健康卡号
	//患者联系人信息	
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set subObj.papatrelationcode=LinkManRelationDR
	set subObj.papatrelationname=$p($g(^PAPER(patRowId,"PER",2)),"^",13)    //联系人姓名
	set subObj.papatrelationphone=$replace($P($G(^PAPER(patRowId,"ALL")),"^",4)," ","")      //联系人电话
	set subObj.papatrelationaddressdesc=$P($G(^PAPER(patRowId,"PER",1)),"^",1)  //联系人地址
	set subObj.papatrelationhousenum=""   //	患者联系人地址-门牌号码
	set subObj.papatrelationvillage=""       //	患者联系人地址-村（街、路、弄等）
	set subObj.papatrelationcountryside=""      //	患者联系人地址-乡（镇、街道办事处）
	set subObj.papatrelationcounty=$p($g(^PAPER(patRowId,"PER",4)),"^",9)        //	患者联系人地址-县（区）代码
	set subObj.papatrelationcity=$p($g(^PAPER(patRowId,"PER",1)),"^",5)	     //	患者联系人地址-市（地区）代码
	set subObj.papatrelationprovince=$p($g(^PAPER(patRowId,"PER",4)),"^",2)	      //患者联系人地址-省（自治区、直辖市）代码
	set subObj.papatrelationpostalcode=$p($g(^PAPER(patRowId,"PER",1)),"^",7)  	  //患者联系人地址邮政编码
	set PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)
	set subObj.papattelephone=$e(PAPATTelephone,1,11)                   //本人联系电话
	set subObj.papatlinkpatientid=""  	                            //关联patientid，用于病人合并
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set subObj.papatworkplacename=$replace($p($g(^PAPER(patRowId,"PER",4)),"^",18)," ","")   //患者工作单位名称
	set subObj.papatworkplacetelnum=$p($g(^PAPER(patRowId,"PER",1)),"^",9)  //患者工作单位电话号码
	set subObj.papatpatientpositioncode=$p($g(^PAPER(patRowId,"PER",1)),"^",10)    //	社会地位代码
	set:subObj.papatdocumentno="" subObj.papatdocumentno=$p($g(^PAPER(patRowId,"PAT",1)),"^",22)   //病案号
	set Vocation=$p($g(^PAPER(patRowId,"PER",2)),"^",6) 
	set subObj.papatoccupationcode=Vocation
	quit subObj
}

/// Creator：wl
/// CreatDate：2019—06-21
/// Description：根据患者ID获取患者基本信息(ACC0001) 历史数据Global
/// Table：PA_PatMas 、pa_person
/// Input：patRowId：患者ID
/// Output：
/// Return：数据中心pa_patient患者基本信息(Global) 
/// Others：w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PatientInfo).SendHistoryPatInfoGlobal("10","1486515")
ClassMethod SendHistoryPatInfoGlobal(strpatRowId As %String, endpatRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("papatient")=$lb("患者姓名","出生日期","性别代码","婚姻状况代码","民族代码","国籍代码","死亡日期","死亡时间",
											"最后更新人编码","最后更新日期","最后更新时间","母亲id","备注","健康卡号","联系人姓名","联系人电话",
											"本人联系电话","关联patientid","病人职业","时间戳","时间戳","患者工作单位名称","患者工作单位电话号码",
											"患者联系人关系代码","患者联系人地址","患者联系人地址-门牌号码","患者联系人地址-村（街、路、弄等）",
											"患者联系人地址-乡（镇、街道办事处）","患者联系人地址-县（区）代码","患者联系人地址-市（地区）代码",
											"患者联系人地址-省（自治区、直辖市）代码","患者联系人地址邮政编码","社会地位代码","病案号","院内患者id",
											"院内登记号","全局患者ID","全局登记号","业务域")
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PatientInfo).%New()
	set con=0,strtime=$zt($p($now(),",",2))
	if ((strpatRowId="")||(endpatRowId)="") {
		quit "-1^patRowId病人id不能为空"
	}
	set patRowId=""
	for patRowId=strpatRowId:1:endpatRowId{
		continue:$d(^PAPER(patRowId))=0
		continue:$p($g(^PAPER(patRowId,"PAT",1)),"^",1)=""
		set subObj=..getSubPatInfo(patRowId)
		set ^ExportHistoryData("papatient",patRowId)=$lb(subObj.papatdename,subObj.papatdedob,subObj.papatdesexcode,subObj.papatdemaritalstatuscode,subObj.papatdenationcode,
														 subObj.papatdecountrycode,subObj.papatdedeceaseddate,subObj.papatdedeceasedtime,subObj.papatupdateusercode,subObj.papatupdatedate,
														 subObj.papatupdatetime,subObj.papatmotherid,subObj.papatremarks,subObj.papathealthcardid,subObj.papatrelationname,
														 subObj.papatrelationphone,subObj.papattelephone,subObj.papatlinkpatientid,subObj.papatoccupationcode,subObj.updatedate,
														 subObj.updatetime,subObj.papatworkplacename,subObj.papatworkplacetelnum,subObj.papatrelationcode,subObj.papatrelationaddressdesc,
														 subObj.papatrelationhousenum,subObj.papatrelationvillage,subObj.papatrelationcountryside,subObj.papatrelationcounty,subObj.papatrelationcity,
														 subObj.papatrelationprovince,subObj.papatrelationpostalcode,subObj.papatpatientpositioncode,subObj.papatdocumentno,subObj.papathospatientid,
														 subObj.papathosregno,subObj.papatrelpatientid,subObj.papatrelregno,subObj.businessfieldcode)
														 
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strpatRowId, endpatRowId, con, patRowId)
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
