Class web.DHCBL.BDP.HOSInterface Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:   同步主数据管理平台推送的数据
/// Creator:    CHENYING
/// CreateDate: 2023-03-28
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSTest(^TMPBDP(43))
ClassMethod SyncHOSTest(JsonStr As %String) As %String
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write(JsonStr)	
	s result= ##class(web.DHCBL.BDP.HOSInterface).SyncHOSData(stream)
	q result
}

/*******************************对接主数据管理平台*********************************************************/
/// Function:   同步主数据管理平台推送的数据
/// Creator:    gss
/// CreateDate: 2023-02-21
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSData("")
ClassMethod SyncHOSData(JsonStr As %Stream.GlobalCharacter) As %String
{
	s $zt="ERROR"
	;S repid=$I(^TMPBDP)
	q:(JsonStr="") "{""response"":{""code"":""500"",""msg"":""请求消息为空"",""errorlist"":[]}}"
	;s ^TMPBDP("000")=$now()
	//s ^TMPBDP(repid)=JsonStr.OutputToDevice()
	//s ^TMPBDP(repid,"Read")= JsonStr.Read()
	s result=""
	//s JsonObj= ##class(PHA.COM.Object).FromJSON(JsonStr)
	s JsonObj={}.%FromJSON(JsonStr)
	s TableCode=JsonObj.%Get("request").%Get("tablecode")
	//s DataStr=JsonObj.%Get("request").%Get("data").%ToJSON()
	
	s DataObj=JsonObj.%Get("request").%Get("data")
	if (TableCode="hos_organization") //1、组织机构
	{
		s result=..SyncHOSOrganization(DataObj)
	}
	elseif (TableCode="hos_healthorg") //2、医疗机构
	{
		s result=..SyncCTRefClin(DataObj)
	}
	elseif (TableCode="hos_department") //3、组织部门
	{
		s result=..SyncHOSDepartment(DataObj)
	}
	elseif (TableCode="hos_position") //4、组织职位
	{
		s result=..SyncHOSPosition(DataObj)
	}
	elseif (TableCode="hos_proftitle") //5、组织职务
	{
		s result=..SyncHOSProfTitle(DataObj)
	}	
	elseif (TableCode="hos_businessunit") //6、业务单元
	{
		s result=..SyncCTLoc(DataObj)
	}
	elseif (TableCode="hos_procpost") //7、流程岗位
	{
		s result=..SyncHOSProcPost(DataObj)
	}
	elseif (TableCode="hos_post") //8、业务岗位
	{
		s result=..SyncHOSPost(DataObj)
	}
	elseif (TableCode="hos_procpostrelpost") //9、流程岗位与业务岗位关系
	{
		s result=..SyncHOSPostRelBusPost(DataObj)
	}
		elseif (TableCode="hos_person") //10、人员基本信息
	{ 
		s result=..SyncHOSPerson(DataObj)
	}
	elseif (TableCode="hos_orgemployee") //11、组织人员
	{ 
		s result=..SyncHOSORGEmployee(DataObj)
	}
	elseif (TableCode="hos_emppostion") //12、人员职位
	{ 
		s result=..SyncHOSEmpPostion(DataObj)
	}
	elseif (TableCode="hos_empproftitle") //13、人员职务
	{ 
		s result=..SyncHOSEmpProfTitle(DataObj)
	}
	elseif (TableCode="hos_emppost") //14、人员岗位
	{ 
		s result=..SyncHOSEmpPost(DataObj)
	}
	elseif (TableCode="hos_useraccountpost") //15、系统账户岗位
	{
		s result=..SyncHOSUserAccountPost(DataObj)
	}
	elseif (TableCode="hos_postrole") //16、岗位角色
	{
		s result=..SyncHOSPostRole(DataObj)
	}
	elseif (TableCode="hos_gender") //17、性别字典
	{
		s result=..SyncCTSex(DataObj)
	}
	elseif (TableCode="hos_country") //18、国家地区字典
	{
		s result=..SyncCTCountry(DataObj)
	}
	elseif (TableCode="hos_province") //19、行政区划省级字典
	{
		s result=..SyncCTProvince(DataObj)
	}
	elseif (TableCode="hos_city") //20、行政区划市级代码
	{
		s result=..SyncCTCity(DataObj)
	}
	elseif (TableCode="hos_district") //21、行政区化县级字典
	{
		s result=..SyncCTCityArea(DataObj)
	}
	elseif (TableCode="hos_marriagestatus") //22、婚姻状况字典
	{
		s result=..SyncCTMarital(DataObj)
	}
	elseif (TableCode="hos_degree") //23、学位字典
	{
		s result=..SyncHOSDegree(DataObj)
	}
	elseif (TableCode="hos_education") //24、学历字典
	{
		s result=..SyncCTEducation(DataObj)
	}
	elseif (TableCode="hos_nationality") //25、民族字典
	{
		s result=..SyncCTNation(DataObj)
	}
	//26、证件类型
	elseif (TableCode="hos_occucategory") //27、职业大类字典
	{
		s result=..SyncHOSOccuCategory(DataObj)
	}
	elseif (TableCode="hos_occupation") //28、职业字典
	{
		s result=..SyncCTOccupation(DataObj)
	}
	//29、职称字典
	elseif (TableCode="hos_religion") //30、宗教信仰字典
	{
		s result=..SyncCTRegion(DataObj)
	}
	//31、人员状态
	elseif (TableCode="hos_personstatusdict") 
	{
		s result=..SyncHOSPersonStatusDict(DataObj)
	}	
	//32、工作状态
	
	elseif (TableCode="hos_empstatusdict") 
	{
		s result=..SyncHOSEmpStatusDict(DataObj)
	}	
	elseif (TableCode="hos_orgcategory") //33、机构大类字典
	{
		s result=..SyncHOSOrgCategory(DataObj)
	}
	elseif (TableCode="hos_orgsubcategory") //34、机构子类字典
	{
		s result=..SyncHOSOrgSubCategory(DataObj)
	}
	elseif (TableCode="hos_orgmincategory") //35、机构小类字典
	{
		s result=..SyncHOSOrgMinCategory(DataObj)
	}
	elseif (TableCode="hos_orgadmintype") //36、组织行政属性字典
	{
		s result=..SyncHOSOrgAdminType(DataObj)
	}
	elseif (TableCode="hos_horggrade") //37、医院等级代码
	{
		s result=..SyncHOSHORGGrade(DataObj)
	}
	elseif (TableCode="hos_positiondict") //38、职位字典
	{
		s result=..SyncHOSPositionDict(DataObj)
	}
	elseif (TableCode="hos_proftitledict") //39、职务字典
	{
		s result=..SyncHOSProfTitleDict(DataObj)
	}
	elseif (TableCode="hos_profrank") //40、职务等级
	{
		s result=..SyncHOSProfRank(DataObj)
	}
	elseif (TableCode="hos_busi_domain") //41、业务域
	{
		s result=..SyncHOSBusiDomain(DataObj)
	}
	elseif (TableCode="hos_postdict") //42、岗位字典
	{
		s result=..SyncHOSPostDict(DataObj)
	}
	elseif (TableCode="hos_posttype") //43、岗位类型
	{
		s result=..SyncHOSPostType(DataObj)
	}
	elseif (TableCode="hos_postheadword") //44、岗位中心词
	{
		s result=..SyncHOSPostHeadWord(DataObj)
	}
	elseif (TableCode="hos_flowheadword") //45、流程中心词
	{
		s result=..SyncHOSFlowHeadWord(DataObj)
	}
	//46、系统角色字典
	else
	{
		s result="{""response"":{""code"":""200"",""msg"":""HIS没有此表"",""errorlist"":[]}}"		
	}
	//s ^TMPBDP(repid,"result",TableCode)=result
	;s ^TMPBDP("result")=result
	q result
ERROR
	S result="SyncHOSData"_$ze
	q result
}

/// Function:   同步性别字典
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.CTSex
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTSex("")
ClassMethod SyncCTSex(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	//s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s gendercode=DataInfo.%Get("gender_code") //性别代码
		s genderdesc=DataInfo.%Get("gender_desc") //性别描述
		s genderactivity=DataInfo.%Get("gender_activity") //是否有效
		s genderactivity=$case(genderactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:genderactivity) //是否有效 true/false
		s genderstartdate=DataInfo.%Get("gender_startdate") //开始日期
		s:genderstartdate'="" genderstartdate=..ConvertTimeStampToDate(genderstartdate)
		s genderenddate=DataInfo.%Get("gender_enddate") //结束日期
		s:genderenddate'="" genderenddate=..ConvertTimeStampToDate(genderenddate)
		s gendercreatedate=DataInfo.%Get("gender_createdate") //系统创建日期
		s:gendercreatedate'="" gendercreatedate=..ConvertTimeStampToDate(gendercreatedate)
		s gendercreatetime=DataInfo.%Get("gender_createtime") //系统创建时间
		s:gendercreatetime'="" gendercreatetime=..ConvertTimeStampToDate(gendercreatetime,"time")
		s gendercreateuser=DataInfo.%Get("gender_createuser") //系统创建人
		s gendercreateuserid=..GetIdByCode(gendercreateuser,"User.SSUser")
		s genderseqno=DataInfo.%Get("gender_seqno") //系统排序号
		s genderlastupdatedate=DataInfo.%Get("gender_lastupdatedate") //系统最后更新日期
		s genderlastupdatetime=DataInfo.%Get("gender_lastupdatetime") //系统最后更新时间
		s genderlastupdateuser=DataInfo.%Get("gender_lastupdateuser") //系统最后更新人
		s genderpycode=DataInfo.%Get("gender_pycode") //拼音码
		s genderwbcode=DataInfo.%Get("gender_wbcode") //五笔码
		s gendermark=DataInfo.%Get("gender_mark") //备注
		s eobj = ##class(web.Entity.CT.CTSex).%New()
		s eobj.CTSEXRowId=$o(^CT("SEX",0,"Code",$$ALPHAUP^SSUTIL4(gendercode),0))
		s eobj.CTSEXCode=gendercode
		s eobj.CTSEXDesc=genderdesc
		s eobj.CTSEXDateFrom=genderstartdate
		s eobj.CTSEXDateTo=genderenddate
		s eobj.CTSEXActivity=genderactivity
		if (eobj.CTSEXRowId=""){
			s eobj.CTSEXCreateDate=+$h
			s eobj.CTSEXCreateTime=$p($h,",",2)
			s eobj.CTSEXCreateUser=USERID
			s:gendercreatedate'="" eobj.CTSEXCreateDate=gendercreatedate
			s:gendercreatetime'="" eobj.CTSEXCreateTime=gendercreatetime
			s:gendercreateuserid'="" eobj.CTSEXCreateUser=gendercreateuserid
		}
		s eobj.CTSEXSeqNo=genderseqno
		s eobj.CTSEXLastUpdateDate=+$h
		s eobj.CTSEXLastUpdateTime=$p($h,",",2)
		s eobj.CTSEXLastUpdateUser=USERID
		s eobj.CTSEXPYCode=genderpycode
		s eobj.CTSEXWBCode=genderwbcode
		s eobj.CTSEXMark=gendermark
		s resSave=##class(web.DHCBL.CT.CTSex).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_gendercode_""""
			else  s DataRet=DataRet_","_""""_gendercode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_gendercode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_gendercode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步婚姻状况字典
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.CTMarital
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTMarital("")
ClassMethod SyncCTMarital(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s marriagecode=DataInfo.%Get("marriage_code") //婚姻状态代码
		s marriagedesc=DataInfo.%Get("marriage_desc") //婚姻状态描述
		s marriageactivity=DataInfo.%Get("marriage_activity") //是否有效
		s marriageactivity=$case(marriageactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:marriageactivity) //是否有效 true/false
		s marriagestartdate=DataInfo.%Get("marriage_startdate") //开始日期
		s:marriagestartdate'="" marriagestartdate=..ConvertTimeStampToDate(marriagestartdate)
		s marriageenddate=DataInfo.%Get("marriage_enddate") //结束日期
		s:marriageenddate'="" marriageenddate=..ConvertTimeStampToDate(marriageenddate)
		s marriagecreatedate=DataInfo.%Get("marriage_createdate") //系统创建日期
		s:marriagecreatedate'="" marriagecreatedate=..ConvertTimeStampToDate(marriagecreatedate)
		s marriagecreatetime=DataInfo.%Get("marriage_createtime") //系统创建时间
		s:marriagecreatetime'="" marriagecreatetime=..ConvertTimeStampToDate(marriagecreatetime,"time")
		s marriagecreateuser=DataInfo.%Get("marriage_createuser") //系统创建人
      	s marriagecreateuserid=..GetIdByCode(marriagecreateuser,"User.SSUser")
		s marriageseqno=DataInfo.%Get("marriage_seqno") //系统排序号
		s marriagelastupdatedate=DataInfo.%Get("marriage_lastupdatedate") //系统最后更新日期
		s marriagelastupdatetime=DataInfo.%Get("marriage_lastupdatetime") //系统最后更新时间
		s marriagelastupdateuser=DataInfo.%Get("marriage_lastupdateuser") //系统最后更新人
		s marriagepycode=DataInfo.%Get("marriage_pycode") //拼音码
		s marriagewbcode=DataInfo.%Get("marriage_wbcode") //五笔码
		s marriagemark=DataInfo.%Get("marriage_mark") //备注
		
		s eobj = ##class(web.Entity.CT.CTMarital).%New()
		s eobj.CTMARRowId=$o(^CT("MAR",0,"Code",$$ALPHAUP^SSUTIL4(marriagecode),0))
		s eobj.CTMARCode=marriagecode
		s eobj.CTMARDesc=marriagedesc
		s eobj.CTMARDateFrom=marriagestartdate
		s eobj.CTMARDateTo=marriageenddate
		s eobj.CTMARActivity=marriageactivity
		if (eobj.CTMARRowId=""){
			s eobj.CTMARCreateDate=+$h
			s eobj.CTMARCreateTime=$p($h,",",2)
			s eobj.CTMARCreateUser=USERID
			s:marriagecreatedate'="" eobj.CTMARCreateDate=marriagecreatedate
			s:marriagecreatetime'="" eobj.CTMARCreateTime=marriagecreatetime
			s:marriagecreateuserid'="" eobj.CTMARCreateUser=marriagecreateuserid
		}
		s eobj.CTMARSeqNo=marriageseqno
		s eobj.CTMARLastUpdateDate=+$h
		s eobj.CTMARLastUpdateTime=$p($h,",",2)
		s eobj.CTMARLastUpdateUser=USERID
		s eobj.CTMARPYCode=marriagepycode
		s eobj.CTMARWBCode=marriagewbcode
		s eobj.CTMARMark=marriagemark
		
 		s resSave=##class(web.DHCBL.CT.CTMarital).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_marriagecode_""""
			else  s DataRet=DataRet_","_""""_marriagecode_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_marriagecode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_marriagecode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步学位字典
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSDegree
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSDegree("")
ClassMethod SyncHOSDegree(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		
		s degcode=DataInfo.%Get("deg_code") //学位代码 
		s degdesc=DataInfo.%Get("deg_desc") //学位描述 
		s degactivity=DataInfo.%Get("deg_activity") //是否有效 
		s degactivity=$case(degactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:degactivity) //是否有效 true/false
		s degstartdate=DataInfo.%Get("deg_startdate") //开始日期 
		s:degstartdate'="" degstartdate=..ConvertTimeStampToDate(degstartdate)
		s degenddate=DataInfo.%Get("deg_enddate") //结束日期 
		s:degenddate'="" degenddate=..ConvertTimeStampToDate(degenddate)
		s degcreatedate=DataInfo.%Get("deg_createdate") //系统创建日期 
		s:degcreatedate'="" degcreatedate=..ConvertTimeStampToDate(degcreatedate)	
		s degcreatetime=DataInfo.%Get("deg_createtime") //系统创建时间 
		s:degcreatetime'="" degcreatetime=..ConvertTimeStampToDate(degcreatetime,"time")
		s degcreateuser=DataInfo.%Get("deg_createuser") //系统创建人 
		s degcreateuserid=..GetIdByCode(degcreateuser,"User.SSUser")
		s degseqno=DataInfo.%Get("deg_seqno") //系统排序号 
		s deglastupdatedate=DataInfo.%Get("deg_lastupdatedate") //系统最后更新日期 
		s deglastupdatetime=DataInfo.%Get("deg_lastupdatetime") //系统最后更新时间 
		s deglastupdateuser=DataInfo.%Get("deg_lastupdateuser") //系统最后更新人 
		s degpycode=DataInfo.%Get("deg_pycode") //拼音码 
		s degwbcode=DataInfo.%Get("deg_wbcode") //五笔码 
		s degmark=DataInfo.%Get("deg_mark") //备注
		
		s eobj = ##class(web.Entity.CT.HOSDegree).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSDegreeI("IndexCode"," "_$zconvert(degcode,"u"),0))
		s eobj.DEGCode=degcode
		s eobj.DEGDesc=degdesc
		s eobj.DEGActivity=degactivity
		s eobj.DEGStartDate=degstartdate
		s eobj.DEGEndDate=degenddate
		if (eobj.ID=""){
			s eobj.DEGCreateDate=+$h
			s eobj.DEGCreateTime=$p($h,",",2)
			s eobj.DEGCreateUser=USERID
			s:degcreatedate'="" eobj.DEGCreateDate=degcreatedate
			s:degcreatetime'="" eobj.DEGCreateTime=degcreatetime
			s:degcreateuserid'="" eobj.DEGCreateUser=degcreateuserid
		}
		s eobj.DEGSeqNo=degseqno
		s eobj.DEGLastUpdateDate=+$h
		s eobj.DEGLastUpdateTime=$p($h,",",2)
		s eobj.DEGLastUpdateUser=USERID
		s eobj.DEGPYCode=degpycode
		s eobj.DEGWBCode=degwbcode
		s eobj.DEGMark=degmark
		s resSave=##class(web.DHCBL.CT.HOSDegree).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_degcode_""""
			else  s DataRet=DataRet_","_""""_degcode_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_degcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_degcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步学历字典
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.CTEducation
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTEducation("")
ClassMethod SyncCTEducation(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s educode=DataInfo.%Get("edu_code") //学历代码 
		s edudesc=DataInfo.%Get("edu_desc") //学历代码描述 
		s educlass=DataInfo.%Get("edu_class") //学历层次 
		s edustatus=DataInfo.%Get("edu_status") //学历状态 
		s eduactivity=DataInfo.%Get("edu_activity") //是否有效
		s eduactivity=$case(eduactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:eduactivity) //是否有效 true/false 
		s edustartdate=DataInfo.%Get("edu_startdate") //开始日期 
		s:edustartdate'="" edustartdate=..ConvertTimeStampToDate(edustartdate)
		s eduenddate=DataInfo.%Get("edu_enddate") //结束日期 
		s:eduenddate'="" deglastupdatedate=..ConvertTimeStampToDate(eduenddate)
		s educreatedate=DataInfo.%Get("edu_createdate") //系统创建日期 
		s:educreatedate'="" educreatedate=..ConvertTimeStampToDate(educreatedate)
		s educreatetime=DataInfo.%Get("edu_createtime") //系统创建时间 
		s:educreatetime'="" educreatetime=..ConvertTimeStampToDate(educreatetime,"time")
		s educreateuser=DataInfo.%Get("edu_createuser") //系统创建人 
		s educreateuserid=..GetIdByCode(educreateuser,"User.SSUser")
		s eduseqno=DataInfo.%Get("edu_seqno") //系统排序号 
		s edulastupdatedate=DataInfo.%Get("edu_lastupdatedate") //系统最后更新日期 
		s edulastupdatetime=DataInfo.%Get("edu_lastupdatetime") //系统最后更新时间 
		s edulastupdateuser=DataInfo.%Get("edu_lastupdateuser") //系统最后更新人 
		s edupycode=DataInfo.%Get("edu_pycode") //拼音码 
		s eduwbcode=DataInfo.%Get("edu_wbcode") //五笔码 
		s edumark=DataInfo.%Get("edu_mark") //备注
		
		s eobj = ##class(web.Entity.CT.CTEducation).%New()
		s eobj.EDURowId=$o(^CT("EDU",0,"Code",$$ALPHAUP^SSUTIL4(educode),0))
		s eobj.EDUCode=educode
		s eobj.EDUDesc=edudesc
		s eobj.EDUClass=educlass
		s eobj.EDUStatus=edustatus
		s eobj.EDUActivity=eduactivity
		s eobj.EDUStartDate=edustartdate
		s eobj.EDUEndDate=eduenddate
		if (eobj.EDURowId=""){
			s eobj.EDUCreateDate=+$h
			s eobj.EDUCreateTime=$p($h,",",2)
			s eobj.EDUCreateUser=USERID
			s:educreatedate'="" eobj.EDUCreateDate=educreatedate
			s:educreatetime'="" eobj.EDUCreateTime=educreatetime
			s:educreateuserid'="" eobj.EDUCreateUser=educreateuserid
		}
		s eobj.EDUSeqNo=eduseqno
		s eobj.EDULastUpdateDate=+$h
		s eobj.EDULastUpdateTime=$p($h,",",2)
		s eobj.EDULastUpdateUser=USERID
		s eobj.EDUPYCode=edupycode
		s eobj.EDUWBCode=eduwbcode
		s eobj.EDUMark=edumark
		
		s resSave=##class(web.DHCBL.CT.CTEducation).SaveEntity(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_educode_""""
			else  s DataRet=DataRet_","_""""_educode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_educode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_educode_""",""errormsg"":"""_errormsg_"""}"
		}		
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步民族字典
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.CTNation
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTNation("")
ClassMethod SyncCTNation(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s natcode=DataInfo.%Get("nat_code") //民族数字代码
		s natdesc=DataInfo.%Get("nat_desc") //民族描述
		s natromancode=DataInfo.%Get("nat_romancode") //民族罗马代码
		s natromandesc=DataInfo.%Get("nat_romandesc") //民族罗马描述
		s natforeigndesc=DataInfo.%Get("nat_foreigndesc") //民族外国名称
		s natactivity=DataInfo.%Get("nat_activity") //是否有效
		s natactivity=$case(natactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:natactivity) //是否有效 true/false
		s natstartdate=DataInfo.%Get("nat_startdate") //开始日期
		s:natstartdate'="" natstartdate=..ConvertTimeStampToDate(natstartdate)
		s natenddate=DataInfo.%Get("nat_enddate") //结束日期
		s:natenddate'="" natenddate=..ConvertTimeStampToDate(natenddate)
		s natcreatedate=DataInfo.%Get("nat_createdate") //系统创建日期
		s:natcreatedate'="" natcreatedate=..ConvertTimeStampToDate(natcreatedate)
		s natcreatetime=DataInfo.%Get("nat_createtime") //系统创建时间
		s:natcreatetime'="" natcreatetime=..ConvertTimeStampToDate(natcreatetime,"time")
		s natcreateuser=DataInfo.%Get("nat_createuser") //系统创建人
		s natcreateuserid=..GetIdByCode(natcreateuser,"User.SSUser")
		s natseqno=DataInfo.%Get("nat_seqno") //系统排序号
		s natlastupdatedate=DataInfo.%Get("nat_lastupdatedate") //系统最后更新日期
		s natlastupdatetime=DataInfo.%Get("nat_lastupdatetime") //系统最后更新时间
		s natlastupdateuser=DataInfo.%Get("nat_lastupdateuser") //系统最后更新人
		s natpycode=DataInfo.%Get("nat_pycode") //拼音码
		s natwbcode=DataInfo.%Get("nat_wbcode") //五笔码
		s natmark=DataInfo.%Get("nat_mark") //备注
		
		s eobj = ##class(web.Entity.CT.CTNation).%New()
		s eobj.CTNATRowId=$o(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(natcode),0))
		s eobj.CTNATCode=natcode
		s eobj.CTNATDesc=natdesc
		s eobj.CTNATRomanCode=natromancode
		s eobj.CTNATRomanDesc=natromandesc
		s eobj.CTNATForeignDesc=natforeigndesc
		s eobj.CTNATActivity=natactivity
		s eobj.CTNATStartDate=natstartdate
		s eobj.CTNATEndDate=natenddate
		if (eobj.CTNATRowId=""){
			s eobj.CTNATCreateDate=+$h
			s eobj.CTNATCreateTime=$p($h,",",2)
			s eobj.CTNATCreateUser=USERID
			s:natcreatedate'="" eobj.CTNATCreateDate=natcreatedate
			s:natcreatetime'="" eobj.CTNATCreateTime=natcreatetime
			s:natcreateuserid'="" eobj.CTNATCreateUser=natcreateuserid
		}
		s eobj.CTNATSeqNo=natseqno
		s eobj.CTNATLastUpdateDate=+$h
		s eobj.CTNATLastUpdateTime=$p($h,",",2)
		s eobj.CTNATLastUpdateUser=USERID
		s eobj.CTNATPYCode=natpycode
		s eobj.CTNATWBCode=natwbcode
		s eobj.CTNATMark=natmark
		s resSave=##class(web.DHCBL.CT.CTNation).SaveEntity(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_natcode_""""
			else  s DataRet=DataRet_","_""""_natcode_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_natcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_natcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步人员基本信息
/// Creator:    gss
/// CreateDate: 2023-02-21
/// TableName:  CT.BDP.CT.HOSPerson
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPerson("")
ClassMethod SyncHOSPerson(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s papersonid=DataInfo.%Get("pa_personid") //唯一标识码
		s paname=DataInfo.%Get("pa_name") //姓名
		s paformername=DataInfo.%Get("pa_formername") //曾用名
		s pagendercode=DataInfo.%Get("pa_gendercode") //性别代码
		s pagenderid=..GetIdByCode(pagendercode,"User.CTSex") 
		s pabirthdate=DataInfo.%Get("pa_birthdate") //出生日期（格式：yyyy-mm-dd）
		s:pabirthdate'="" pabirthdate=..ConvertTimeStampToDate(pabirthdate)
		s panationalitycode=DataInfo.%Get("pa_nationalitycode") //国籍
		s panationalityid=..GetIdByCode(panationalitycode,"User.CTCountry")
		s palanguagecode1=DataInfo.%Get("pa_languagecode1") //第一语言
		s palanguageid1=..GetIdByCode(palanguagecode1,"User.SSLanguage")
		s palanguagecode2=DataInfo.%Get("pa_languagecode2") //第二语言
		s palanguageid2=..GetIdByCode(palanguagecode2,"User.SSLanguage")
		s paidentityid=DataInfo.%Get("pa_identityid") //身份证号
		s paidentitytype=DataInfo.%Get("pa_identitytype") //身份证件类型
		s paidentitytypeid=..GetIdByCode(paidentitytype,"User.DHCCredType")
		s panationcode=DataInfo.%Get("pa_nationcode") //民族代码
		s panationid=..GetIdByCode(panationcode,"User.CTNation")
		s paeducationcode=DataInfo.%Get("pa_educationcode") //学历代码
		s paeducationid=..GetIdByCode(paeducationcode,"User.CTEducation")
		s padegreecode=DataInfo.%Get("pa_degreecode") //学位代码
		s padegreeid=..GetIdByCode(padegreecode,"CT.BDP.CT.HOSDegree")
		s paoccupationcode=DataInfo.%Get("pa_occupationcode") //职业代码
		s paoccupationid=..GetIdByCode(paoccupationcode,"User.CTOccupation")
		s pamarriedcode=DataInfo.%Get("pa_marriedcode") //婚姻状态
		s pamarriedid=..GetIdByCode(pamarriedcode,"User.CTMarital")
		s pareligioncode=DataInfo.%Get("pa_religioncode") //宗教
		s pareligionid=..GetIdByCode(pareligioncode,"User.CTReligion")
		s panpcountrycode=DataInfo.%Get("pa_npcountrycode") //籍贯（国家）
		s panpcountryid=..GetIdByCode(panpcountrycode,"User.CTCountry")
		s panpprovcode=DataInfo.%Get("pa_npprovcode") //籍贯（省）
		s panpprovid=..GetIdByCode(panpprovcode,"User.CTProvince")
		s panpcitycode=DataInfo.%Get("pa_npcitycode") //籍贯（市）
		s panpcityid=..GetIdByCode(panpcitycode,"User.CTCity")
		s panpdistrcode=DataInfo.%Get("pa_npdistrcode") //籍贯（县区）
		s panpdistrid=..GetIdByCode(panpdistrcode,"User.CTCityArea")
		s paaddrcountrycode=DataInfo.%Get("pa_addrcountrycode") //现住址（国家）
		s paaddrcountryid=..GetIdByCode(paaddrcountrycode,"User.CTCountry")
		s paaddrprovcode=DataInfo.%Get("pa_addrprovcode") //现住址（省）
		s paaddrprovid=..GetIdByCode(paaddrprovcode,"User.CTProvince")
		s paaddrcitycode=DataInfo.%Get("pa_addrcitycode") //现住址（市）
		s paaddrcityid=..GetIdByCode(paaddrcitycode,"User.CTCity")
		s paaddrdistrcode=DataInfo.%Get("pa_addrdistrcode") //现住址（县区）
		s paaddrdistrid=..GetIdByCode(paaddrdistrcode,"User.CTCityArea")
		s paaddress=DataInfo.%Get("pa_address") //现住址（详细地址）
		s paphoto=DataInfo.%Get("pa_photo") //照片内容（将照片内容base64转码后的结果）
		s pamobile=DataInfo.%Get("pa_mobile") //手机号码
		s papersonstatus=DataInfo.%Get("pa_personstatus") //状态
		s papersonstatusid=..GetIdByCode(papersonstatus,"CT.BDP.CT.HOSPersonStatusDict")
		s paactivity=DataInfo.%Get("pa_activity") //是否有效
		s paactivity=$case(paactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:paactivity) //是否有效 true/false
		s pastartdate=DataInfo.%Get("pa_startdate") //开始日期
		s:pastartdate'="" pastartdate=..ConvertTimeStampToDate(pastartdate)
		s paenddate=DataInfo.%Get("pa_enddate") //结束日期
		s:paenddate'="" paenddate=..ConvertTimeStampToDate(paenddate)
		s pacreatedate=DataInfo.%Get("pa_createdate") //系统创建日期
		s:pacreatedate'="" pacreatedate=..ConvertTimeStampToDate(pacreatedate)
		s pacreatetime=DataInfo.%Get("pa_createtime") //系统创建时间
		s:pacreatetime'="" pacreatetime=..ConvertTimeStampToDate(pacreatetime,"time")
		s pacreateuser=DataInfo.%Get("pa_createuser") //系统创建人
		s pacreateuserid=..GetIdByCode(pacreateuser,"User.SSUser")
		s paseqno=DataInfo.%Get("pa_seqno") //系统排序号
		s palastupdatedate=DataInfo.%Get("pa_lastupdatedate") //系统最后更新日期
		s palastupdatetime=DataInfo.%Get("pa_lastupdatetime") //系统最后更新时间
		s palastupdateuser=DataInfo.%Get("pa_lastupdateuser") //系统最新更新人
		s palastupdateuserid=..GetIdByCode(palastupdateuser,"User.SSUser")
		s papycode=DataInfo.%Get("pa_pycode") //拼音码
		s pawbcode=DataInfo.%Get("pa_wbcode") //五笔码
		s pamark=DataInfo.%Get("pa_mark") //备注
		;eobj定义及赋值
		s eobj=##class(web.Entity.CT.HOSPerson).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSPersonI("IndexPersonID"," "_$zconvert(papersonid,"U"),0)) 
		s eobj.PAPersonID=papersonid //唯一标识码
		s eobj.PAName=paname //姓名
		s eobj.PAFormerName=paformername //曾用名
		s eobj.PAGenderCode=pagenderid //性别代码
		s eobj.PABirthDate=pabirthdate //出生日期（格式：yyyy-mm-dd）
		s eobj.PANationalityCode=panationalityid //国籍
		s eobj.PALanguageCode1=palanguageid1 //第一语言
		s eobj.PALanguageCode2=palanguageid2 //第二语言
		s eobj.PAIdentityID=paidentityid //身份证号
		s eobj.PAIdentityType=paidentitytypeid //身份证件类型
		s eobj.PANationCode=panationid //民族代码
		s eobj.PAEducationCode=paeducationid //学历代码
		s eobj.PADegreeCode=padegreeid //学位代码
		s eobj.PAOccupationCode=paoccupationid //职业代码
		s eobj.PAMarriedCode=pamarriedid //婚姻状态
		s eobj.PAReligionCode=pareligionid //宗教
		s eobj.PANPCountryCode=panpcountryid //籍贯（国家）
		s eobj.PANPPROVCode=panpprovid //籍贯（省）
		s eobj.PANPCITYCode=panpcityid //籍贯（市）
		s eobj.PANPDISTRCode=panpdistrid //籍贯（县区）
		s eobj.PAAddrCountryCode=paaddrcountryid //现住址（国家）
		s eobj.PAAddrPROVCode=paaddrprovid //现住址（省）
		s eobj.PAAddrCITYCode=paaddrcityid //现住址（市）
		s eobj.PAAddrDISTRCode=paaddrdistrid //现住址（县区）
		s eobj.PAAddress=paaddress //现住址（详细地址）
		s eobj.PAPhoto=paphoto //照片内容（将照片内容base64转码后的结果）
		s eobj.PAMobile=pamobile //手机号码
		s eobj.PAPersonStatus=papersonstatusid //状态
		s eobj.PAActivity=paactivity //是否有效
		s eobj.PAStartDate=pastartdate //开始日期
		s eobj.PAEndDate=paenddate //结束日期
		if (eobj.ID="")
		{
			s eobj.PACreateDate=+$h  ///系统创建日期
            s eobj.PACreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.PACreateUser="" eobj.PACreateUser=USERID   ///系统创建人
			s:pacreatedate'="" eobj.PACreateDate=pacreatedate
			s:pacreatetime'="" eobj.PACreateTime=pacreatetime
			s:pacreateuserid'="" eobj.PACreateUser=pacreateuserid
	
		}
		s eobj.PASeqNo=paseqno //系统排序号
		s eobj.PALastUpdateDate=+$h  ///系统最后更新日期
    	s eobj.PALastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    	s eobj.PALastUpdateUser=USERID  ///系统最新更新人
		s eobj.PAPYCode=papycode //拼音码
		s eobj.PAWBCode=pawbcode //五笔码
		s eobj.PAMark=pamark //备注
    	
		s resSave=##class(web.DHCBL.CT.HOSPerson).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_papersonid_""""
			else  s DataRet=DataRet_","_""""_papersonid_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_papersonid_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_papersonid_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织人员信息
/// Creator:    gss
/// CreateDate: 2023-03-02
/// TableName:  CT.BDP.CT.HOSORGEmployee
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSORGEmployee("")
ClassMethod SyncHOSORGEmployee(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s empid=DataInfo.%Get("emp_id") //机构人员关联id
		s emporgcode=DataInfo.%Get("emp_orgcode") //机构代码
		s emporgid=..GetIdByCode(emporgcode,"CT.BDP.CT.HOSOrganization")
		if (emporgid=""){
			if errorlist="" s errorlist="{""errordataid"":"""_empid_""",""errormsg"":""该人员关联的组织在HIS中不存在""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empid_""",""errormsg"":""该人员关联的组织在HIS中不存在""}"
			continue
		}
		s emppapersonid=DataInfo.%Get("emp_papersonid") //人员唯一标识码
		s emppapersonid=..GetIdByCode(emppapersonid,"CT.BDP.CT.HOSPerson")
		s emppapersonno=DataInfo.%Get("emp_papersonno") //人员工号
		s empjoindate=DataInfo.%Get("emp_joindate") //入职日期
		s:empjoindate'="" empjoindate=..ConvertTimeStampToDate(empjoindate)
		s empstatus=DataInfo.%Get("emp_status") //工作状态
		s empstatusid=..GetIdByCode(empstatus,"CT.BDP.CT.HOSEmpStatusDict")
		s empseparationdate=DataInfo.%Get("emp_separationdate") //离职日期（格式：yyyy-mm-dd）
		s:empseparationdate'="" empseparationdate=..ConvertTimeStampToDate(empseparationdate)
		s empactivity=DataInfo.%Get("emp_activity") //是否有效
		s empactivity=$case(empactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:empactivity) //是否有效 true/false
		s empstartdate =DataInfo.%Get("emp_startdate") //开始日期
		s:empstartdate'="" empstartdate=..ConvertTimeStampToDate(empstartdate)
		s empenddate=DataInfo.%Get("emp_enddate") //结束日期
		s:empenddate'="" empenddate=..ConvertTimeStampToDate(empenddate)
		s empcreatedate=DataInfo.%Get("emp_createdate") //系统创建日期
		s:empcreatedate'="" empcreatedate=..ConvertTimeStampToDate(empcreatedate)
		s empcreatetime=DataInfo.%Get("emp_createtime") //系统创建时间
		s:empcreatetime'="" empcreatetime=..ConvertTimeStampToDate(empcreatetime,"time")
		s empcreateuser=DataInfo.%Get("emp_createuser") //系统创建人
		s empcreateuserid=..GetIdByCode(empcreateuser,"User.SSUser")
		s empseqno=DataInfo.%Get("emp_seqno") //系统排序号
		s emplastupdatedate=DataInfo.%Get("emp_lastupdatedate") //系统最后更新日期
		s emplastupdatetime=DataInfo.%Get("emp_lastupdatetime") //系统最后更新时间
		s emplastupdateuser=DataInfo.%Get("emp_lastupdateuser") //系统最新更新人
		s emppycode=DataInfo.%Get("emp_pycode") //拼音码
		s empwbcode=DataInfo.%Get("emp_wbcode") //五笔码
		s empmark=DataInfo.%Get("emp_mark") //备注"
		
		;eobj定义及赋值
		s eobj = ##class(web.Entity.CT.HOSORGEmployee).%New()
	    s:((emporgid'="")&(emppapersonid'="")) eobj.ID = $o(^CT.BDP.CT.HOSORGEmployeeI("IndexMain",emporgid,emppapersonid,0)) 
	    s eobj.EMPORGCode = emporgid
	    s eobj.EMPPAPersonID = emppapersonid
	    s eobj.EMPPAPersonNo= emppapersonno
	    s eobj.EMPJoinDate= empjoindate
	    s eobj.EMPStatus = empstatusid
	    s eobj.EMPSeparationDate= empseparationdate
	    s eobj.EMPActivity = empactivity
	    s eobj.EMPStartDate= empstartdate
	    s eobj.EMPEndDate= empenddate
	    if (eobj.ID=""){
	    	s eobj.EMPCreateDate= +$h  
	    	s eobj.EMPCreateTime= $p($h,",",2) 
	    	s eobj.EMPCreateUser= USERID  
			s:empcreatedate'="" eobj.EMPCreateDate=empcreatedate
			s:empcreatetime'="" eobj.EMPCreateTime=empcreatetime
			s:empcreateuserid'="" eobj.EMPCreateUser=empcreateuserid
	    }
	    s eobj.EMPSeqNo= empseqno
	    s eobj.EMPLastUpdateDate= +$h  
	    s eobj.EMPLastUpdateTime= $p($h,",",2) 
	    s eobj.EMPLastUpdateUser= USERID  
	    s eobj.EMPPYCode= emppycode
	    s eobj.EMPWBCode= empwbcode
	    s eobj.EMPMark= empmark
	    
	    s resSave=##class(web.DHCBL.CT.HOSORGEmployee).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_empid_""""
			else  s DataRet=DataRet_","_""""_empid_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_empid_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empid_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步人员职位
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSEmpPostion
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSEmpPostion("")
ClassMethod SyncHOSEmpPostion(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s empposid=DataInfo.%Get("emppos_id") //部门人员职位关联ID
		s emppospapersonid=DataInfo.%Get("emppos_papersonid") //人员唯一标识码
		s emppospapersonid=..GetIdByCode(emppospapersonid,"CT.BDP.CT.HOSPerson")
		s empposdeptcode=DataInfo.%Get("emppos_deptcode") //部门代码
		s empposdeptid=..GetIdByCode(empposdeptcode,"CT.BDP.CT.HOSDepartment")
		if (empposdeptid=""){
			if errorlist="" s errorlist="{""errordataid"":"""_empposid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empposid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			continue	
		}
		s empposposcode=DataInfo.%Get("emppos_poscode") //职位代码
		s empposposid=..GetIdByCode(empposposcode,"CT.BDP.CT.HOSPosition")
		s empposappointdate=DataInfo.%Get("emppos_appointdate") //任职日期
		s:empposappointdate'="" empposappointdate=..ConvertTimeStampToDate(empposappointdate)
		s empposremovedate=DataInfo.%Get("emppos_removedate") //免职日期
		s:empposremovedate'="" empposremovedate=..ConvertTimeStampToDate(empposremovedate)
		s empposstatus=DataInfo.%Get("emppos_status") //任职状态
		s empposadminflag=DataInfo.%Get("emppos_adminflag") //是否行政归属部门
		s empposactivity=DataInfo.%Get("emppos_activity") //是否有效
		s empposactivity=$case(empposactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:empposactivity) //是否有效 true/false
		s empposstartdate=DataInfo.%Get("emppos_startdate") //开始日期
		s:empposstartdate'="" empposstartdate=..ConvertTimeStampToDate(empposstartdate)
		s empposenddate=DataInfo.%Get("emppos_enddate") //结束日期
		s:empposenddate'="" empposenddate=..ConvertTimeStampToDate(empposenddate)
		s empposcreatedate=DataInfo.%Get("emppos_createdate") //系统创建日期
		s:empposcreatedate'="" empposcreatedate=..ConvertTimeStampToDate(empposcreatedate)
		s empposcreatetime=DataInfo.%Get("emppos_createtime") //系统创建时间
		s:empposcreatetime'="" empposcreatetime=..ConvertTimeStampToDate(empposcreatetime,"time")
		s empposcreateuser=DataInfo.%Get("emppos_createuser") //系统创建人
		s empposcreateuserid=..GetIdByCode(empposcreateuser,"User.SSUser")
		s empposseqno=DataInfo.%Get("emppos_seqno") //系统排序号
		s empposlastupdatedate=DataInfo.%Get("emppos_lastupdatedate") //系统最后更新日期
		s empposlastupdatetime=DataInfo.%Get("emppos_lastupdatetime") //系统最后更新时间
		s empposlastupdateuser=DataInfo.%Get("emppos_lastupdateuser") //系统最新更新人
		s emppospycode=DataInfo.%Get("emppos_pycode") //拼音码
		s empposwbcode=DataInfo.%Get("emppos_wbcode") //五笔码
		s empposmark=DataInfo.%Get("emppos_mark") //备注

		s eobj = ##class(web.Entity.CT.HOSEmpPostion).%New()
		if ((emppospapersonid'="")&(empposdeptid'="")&(empposposid'="")){
	    	s eobj.ID = $o(^CT.BDP.CT.HOSEmpPostionI("IndexCode",emppospapersonid,empposdeptid,empposposid,0)) 
	    }
		s eobj.EMPPOSPAPersonID=emppospapersonid
		s eobj.EMPPOSDeptCode=empposdeptid
		s eobj.EMPPOSPOSCode=empposposid
		s eobj.EMPPOSAppointDate=empposappointdate
		s eobj.EMPPOSRemoveDate=empposremovedate
		s eobj.EMPPOSStatus=empposstatus
		s eobj.EMPPOSAdminFlag=empposadminflag
		s eobj.EMPPOSActivity=empposactivity
		s eobj.EMPPOSStartDate=empposstartdate
		s eobj.EMPPOSEndDate=empposenddate
		if (eobj.ID=""){
			s eobj.EMPPOSCreateDate=+$h
			s eobj.EMPPOSCreateTime=$p($h,",",2)
			s eobj.EMPPOSCreateUser=USERID
			s:empposcreatedate'="" eobj.EMPPOSCreateDate=empposcreatedate
			s:empposcreatetime'="" eobj.EMPPOSCreateTime=empposcreatetime
			s:empposcreateuserid'="" eobj.EMPPOSCreateUser=empposcreateuserid
		}
		s eobj.EMPPOSSeqNo=empposseqno
		s eobj.EMPPOSLastUpdateDate=+$h
		s eobj.EMPPOSLastUpdateTime=$p($h,",",2)
		s eobj.EMPPOSLastUpdateUser=USERID
		s eobj.EMPPOSPYCode=emppospycode
		s eobj.EMPPOSWBCode=empposwbcode
		s eobj.EMPPOSMark=empposmark
		
		s resSave=##class(web.DHCBL.CT.HOSEmpPostion).SaveEntity(eobj)
	
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_empposid_""""
			else  s DataRet=DataRet_","_""""_empposid_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_empposid_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empposid_""",""errormsg"":"""_errormsg_"""}"
		}	 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步人员职务
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSEmpProfTitle
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSEmpProfTitle("")
ClassMethod SyncHOSEmpProfTitle(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s empprofid=DataInfo.%Get("empprof_id") //部门人员职务关联ID
		s empprofdeptcode=DataInfo.%Get("empprof_deptcode") //部门代码
		s empprofdeptid=..GetIdByCode(empprofdeptcode,"CT.BDP.CT.HOSDepartment")
		if (empprofdeptid=""){
			if errorlist="" s errorlist="{""errordataid"":"""_empprofid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empprofid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			continue	
		}
		s empprofpapersonid=DataInfo.%Get("empprof_papersonid") //人员唯一标识码
		s empprofpapersonid=..GetIdByCode(empprofpapersonid,"CT.BDP.CT.HOSPerson")
		s empprofproftcode=DataInfo.%Get("empprof_proftcode") //部门职务代码
		s empprofproftid=..GetIdByCode(empprofproftcode,"CT.BDP.CT.HOSProfTitle")
		s empprofengagedate=DataInfo.%Get("empprof_engagedate") //聘用日期
		s:empprofengagedate'="" empprofengagedate=..ConvertTimeStampToDate(empprofengagedate)
		s empprofremovedate=DataInfo.%Get("empprof_removedate") //解聘日期
		s:empprofremovedate'="" empprofremovedate=..ConvertTimeStampToDate(empprofremovedate)
		s empprofstatus=DataInfo.%Get("empprof_status") //任职状态
		s empprofactivity=DataInfo.%Get("empprof_activity") //是否有效
		s empprofactivity=$case(empprofactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:empprofactivity) //是否有效 true/false
		s empprofstartdate=DataInfo.%Get("empprof_startdate") //开始日期
		s:empprofstartdate'="" empprofstartdate=..ConvertTimeStampToDate(empprofstartdate)
		s empprofenddate=DataInfo.%Get("empprof_enddate") //结束日期
		s:empprofenddate'="" empprofenddate=..ConvertTimeStampToDate(empprofenddate)
		s empprofcreatedate=DataInfo.%Get("empprof_createdate") //系统创建日期
		s:empprofcreatedate'="" empprofcreatedate=..ConvertTimeStampToDate(empprofcreatedate)
		s empprofcreatetime=DataInfo.%Get("empprof_createtime") //系统创建时间
		s:empprofcreatetime'="" empprofcreatetime=..ConvertTimeStampToDate(empprofcreatetime,"time")
		s empprofcreateuser=DataInfo.%Get("empprof_createuser") //系统创建人
		s empprofcreateuserid=..GetIdByCode(empprofcreateuser,"User.SSUser")
		s empprofseqno=DataInfo.%Get("empprof_seqno") //系统排序号
		s empproflastupdatedate=DataInfo.%Get("empprof_lastupdatedate") //系统最后更新日期
		s empproflastupdatetime=DataInfo.%Get("empprof_lastupdatetime") //系统最后更新时间
		s empproflastupdateuser=DataInfo.%Get("empprof_lastupdateuser") //系统最后更新人
		s empprofpycode=DataInfo.%Get("empprof_pycode") //拼音码
		s empprofwbcode=DataInfo.%Get("empprof_wbcode") //五笔码
		s empprofmark=DataInfo.%Get("empprof_mark") //备注

		s eobj=##class(web.Entity.CT.HOSEmpProfTitle).%New()
		if ((empprofpapersonid'="")&(empprofdeptid'="")&(empprofproftid'="")){
			s eobj.ID=$o(^CT.BDP.CT.HOSEmpProfTitleI("IndexCode",empprofpapersonid,empprofdeptid,empprofproftid,0)) 
		}
		s eobj.EMPPROFPAPersonID=empprofpapersonid
		s eobj.EMPPROFDeptCode=empprofdeptid
		s eobj.EMPPROFPROFTCode=empprofproftid
		s eobj.EMPPROFEngageDate=empprofengagedate
		s eobj.EMPPROFRemoveDate=empprofremovedate
		s eobj.EMPPROFStatus=empprofstatus
		s eobj.EMPPROFActivity=empprofactivity
		s eobj.EMPPROFStartDate=empprofstartdate
		s eobj.EMPPROFEndDate=empprofenddate
		if (eobj.ID=""){
			s eobj.EMPPROFCreateDate=+$h
			s eobj.EMPPROFCreateTime=$p($h,",",2)
			s eobj.EMPPROFCreateUser=empprofcreateuser
			s:empprofcreatedate'="" eobj.EMPPROFCreateDate=empprofcreatedate
			s:empproflastupdatetime'="" eobj.EMPPROFCreateTime=empproflastupdatetime
			s:empprofcreateuserid'="" eobj.EMPPROFCreateUser=empprofcreateuserid
		}
		s eobj.EMPPROFSeqNo=empprofseqno
		s eobj.EMPPROFLastUpdateDate=+$h
		s eobj.EMPPROFLastUpdateTime=$p($h,",",2)
		s eobj.EMPPROFLastUpdateUser=USERID
		s eobj.EMPPROFPYCode=empprofpycode
		s eobj.EMPPROFWBCode=empprofwbcode
		s eobj.EMPPROFMark=empprofmark
		
		s resSave=##class(web.DHCBL.CT.HOSEmpProfTitle).SaveEntity(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_empprofid_""""
			else  s DataRet=DataRet_","_""""_empprofid_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_empprofid_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_empprofid_""",""errormsg"":"""_errormsg_"""}"
		}	 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步人员岗位
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSEmpPost
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSEmpPost("")
ClassMethod SyncHOSEmpPost(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s emppostid=DataInfo.%Get("emppost_id") //部门人员岗位关联ID
		s emppostdeptcode=DataInfo.%Get("emppost_deptcode") //部门代码
		s emppostdeptid=..GetIdByCode(emppostdeptcode,"CT.BDP.CT.HOSDepartment")
		if (emppostdeptid=""){
			if errorlist="" s errorlist="{""errordataid"":"""_emppostid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_emppostid_""",""errormsg"":""该人员关联的组织部门在HIS中不存在""}"
			continue	
		}
		s emppostpapersonid=DataInfo.%Get("emppost_papersonid") //人员唯一标识码
		s emppostpapersonid=..GetIdByCode(emppostpapersonid,"CT.BDP.CT.HOSPerson")
		s emppostpostcode=DataInfo.%Get("emppost_postcode") //岗位代码
		s emppostpostid=..GetIdByCode(emppostpostcode,"CT.BDP.CT.HOSPost")
		s emppostbegindate=DataInfo.%Get("emppost_begindate") //上岗日期（格式：yyyy-mm-dd）
		s:emppostbegindate'="" emppostbegindate=..ConvertTimeStampToDate(emppostbegindate)
		s emppostremovedate=DataInfo.%Get("emppost_removedate") //下岗日期（格式：yyyy-mm-dd）
		s:emppostremovedate'="" emppostremovedate=..ConvertTimeStampToDate(emppostremovedate)
		s emppoststatus=DataInfo.%Get("emppost_status") //任职状态
		s emppostdefaultflag=DataInfo.%Get("emppost_defaultflag") //是否默认岗位
		s emppostactivity=DataInfo.%Get("emppost_activity") //是否有效
		s emppostactivity=$case(emppostactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:emppostactivity) //是否有效 true/false
		s emppoststartdate=DataInfo.%Get("emppost_startdate") //开始日期
		s:emppoststartdate'="" emppoststartdate=..ConvertTimeStampToDate(emppoststartdate)
		s emppostenddate=DataInfo.%Get("emppost_enddate") //结束日期
		s:emppostenddate'="" emppostenddate=..ConvertTimeStampToDate(emppostenddate)
		s emppostcreatedate=DataInfo.%Get("emppost_createdate") //系统创建日期
		s:emppostcreatedate'="" emppostcreatedate=..ConvertTimeStampToDate(emppostcreatedate)
		s emppostcreatetime=DataInfo.%Get("emppost_createtime") //系统创建时间
		s:emppostcreatetime'="" emppostcreatetime=..ConvertTimeStampToDate(emppostcreatetime,"time")
		s emppostcreateuser=DataInfo.%Get("emppost_createuser") //系统创建人
		s emppostcreateuserid=..GetIdByCode(emppostcreateuser,"User.SSUser")
		s emppostseqno=DataInfo.%Get("emppost_seqno") //系统排序号
		s emppostlastupdatedate=DataInfo.%Get("emppost_lastupdatedate") //系统最后更新日期
		s emppostlastupdatetime=DataInfo.%Get("emppost_lastupdatetime") //系统最后更新时间
		s emppostlastupdateuser=DataInfo.%Get("emppost_lastupdateuser") //系统最后更新人
		s emppostpycode=DataInfo.%Get("emppost_pycode") //拼音码
		s emppostwbcode=DataInfo.%Get("emppost_wbcode") //五笔码
		s emppostmark=DataInfo.%Get("emppost_mark") //备注
		
		s eobj = ##class(web.Entity.CT.HOSEmpPost).%New()
		if ((emppostpapersonid'="")&(emppostdeptid'="")&(emppostpostid'="")){
			s eobj.ID=$o(^CT.BDP.CT.HOSEmpPostI("IndexCode",emppostpapersonid,emppostdeptid,emppostpostid,0)) 
		}
		s eobj.EMPPOSTPAPersonID=emppostpapersonid
		s eobj.EMPPOSTDeptCode=emppostdeptid
		s eobj.EMPPOSTPOSTCode=emppostpostid
		s eobj.EMPPOSTBeginDate=emppostbegindate
		s eobj.EMPPOSTRemoveDate=emppostremovedate
		s eobj.EMPPOSTStatus=emppoststatus
		s eobj.EMPPOSTDefaultFlag=emppostdefaultflag
		s eobj.EMPPOSTActivity=emppostactivity
		s eobj.EMPPOSTStartDate=emppoststartdate
		s eobj.EMPPOSTEndDate=emppostenddate
		if (eobj.ID=""){
			s eobj.EMPPOSTCreateDate=+$h
			s eobj.EMPPOSTCreateTime=$p($h,",",2)
			s eobj.EMPPOSTCreateUser=USERID
			s:emppostcreatedate'="" eobj.EMPPOSTCreateDate=emppostcreatedate
			s:emppostcreatetime'="" eobj.EMPPOSTCreateTime=emppostcreatetime
			s:emppostcreateuserid'="" eobj.EMPPOSTCreateUser=emppostcreateuserid
		}
		s eobj.EMPPOSTSeqNo=emppostseqno
		s eobj.EMPPOSTLastUpdateDate=+$h
		s eobj.EMPPOSTLastUpdateTime=$p($h,",",2)
		s eobj.EMPPOSTLastUpdateUser=USERID
		s eobj.EMPPOSTPYCode=emppostpycode
		s eobj.EMPPOSTWBCode=emppostwbcode
		s eobj.EMPPOSTMark=emppostmark
	
		s resSave=##class(web.DHCBL.CT.HOSEmpPost).SaveEntity(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_emppostid_""""
			else  s DataRet=DataRet_","_""""_emppostid_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_emppostid_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_emppostid_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步岗位角色
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSPostRole
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPostRole("")
ClassMethod SyncHOSPostRole(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s poropostcode=DataInfo.%Get("poro_postcode") //岗位代码 
		s poropostid=..GetIdByCode(poropostcode,"CT.BDP.CT.HOSPost")
		s pororolecode=DataInfo.%Get("poro_rolecode") //角色代码 
		s pororoleid=..GetIdByCode(pororolecode,"User.SSGroup") 
		s poroactivity=DataInfo.%Get("poro_activity") //是否有效 
		s poroactivity=$case(poroactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:poroactivity) //是否有效 true/false
		s porostartdate=DataInfo.%Get("poro_startdate") //开始日期 
		s:porostartdate'="" porostartdate=..ConvertTimeStampToDate(porostartdate)
		s poroenddate=DataInfo.%Get("poro_enddate") //结束日期 
		s:poroenddate'="" poroenddate=..ConvertTimeStampToDate(poroenddate)
		s porocreatedate=DataInfo.%Get("poro_createdate") //系统创建日期 
		s:porocreatedate'="" porocreatedate=..ConvertTimeStampToDate(porocreatedate)
		s porocreatetime=DataInfo.%Get("poro_createtime") //系统创建时间 
		s:porocreatetime'="" porocreatetime=..ConvertTimeStampToDate(porocreatetime,"time")
		s porocreateuser=DataInfo.%Get("poro_createuser") //系统创建人 
		s porocreateuserid=..GetIdByCode(porocreateuser,"User.SSUser")
		s poroseqno=DataInfo.%Get("poro_seqno") //系统排序号 
		s porolastupdatedate=DataInfo.%Get("poro_lastupdatedate") //系统最后更新日期 
		s porolastupdatetime=DataInfo.%Get("poro_lastupdatetime") //系统最后更新时间 
		s porolastupdateuser=DataInfo.%Get("poro_lastupdateuser") //系统最后更新人 
		s poropycode=DataInfo.%Get("poro_pycode") //拼音码 
		s porowbcode=DataInfo.%Get("poro_wbcode") //五笔码 
		s poromark=DataInfo.%Get("poro_mark") //备注
		
		s eobj = ##class(web.Entity.CT.HOSPostRole).%New()
		if ((poropostid'="")&(pororoleid'="")){
			s eobj.ID=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTROLE",poropostid,pororoleid,0)) 
		}
		s eobj.POROPOSTCode=poropostid
		s eobj.POROROLECode=pororoleid
		s eobj.POROActivity=poroactivity
		s eobj.POROStartDate=porostartdate
		s eobj.POROEndDate=poroenddate
		if (eobj.ID=""){
			s eobj.POROCreateDate=+$h
			s eobj.POROCreateTime=$p($h,",",2)
			s eobj.POROCreateUser=USERID
			s:porocreatedate'="" eobj.POROCreateDate=porocreatedate
			s:porocreatetime'="" eobj.POROCreateTime=porocreatetime
			s:porocreateuserid'="" eobj.POROCreateUser=porocreateuserid
		}
		s eobj.POROSeqNo=poroseqno
		s eobj.POROLastUpdateDate=+$h
		s eobj.POROLastUpdateTime=$p($h,",",2)
		s eobj.POROLastUpdateUser=USERID
		s eobj.POROPYCode=poropycode
		s eobj.POROWBCode=porowbcode
		s eobj.POROMark=poromark

		s resSave=##class(web.DHCBL.CT.HOSPostRole).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_poropostcode_"-"_pororolecode_""""
			else  s DataRet=DataRet_","_""""_poropostcode_"-"_pororolecode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_poropostcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_poropostcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步系统账户岗位
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.HOSUserAccountPost
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSUserAccountPost("")
ClassMethod SyncHOSUserAccountPost(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s userpostaccountcode=DataInfo.%Get("userpost_accountcode") //账户代码
		s userpostparref=..GetIdByCode(userpostaccountcode,"User.SSUser")
		s userpostpostcode=DataInfo.%Get("userpost_postcode") //岗位代码
		s userpostpostid=..GetIdByCode(userpostpostcode,"CT.BDP.CT.HOSPost")
		s userpostrolecode=DataInfo.%Get("userpost_role_code") //上级角色
		s userpostactivity=DataInfo.%Get("userpost_activity") //是否有效
		s userpostactivity=$case(userpostactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:userpostactivity) //是否有效 true/false
		s userpoststartdate=DataInfo.%Get("userpost_startdate") //开始日期
		s:userpoststartdate'="" userpoststartdate=..ConvertTimeStampToDate(userpoststartdate)
		s userpostenddate=DataInfo.%Get("userpost_enddate") //结束日期
		s:userpostenddate'="" userpostenddate=..ConvertTimeStampToDate(userpostenddate)
		s userpostcreatedate=DataInfo.%Get("userpost_createdate") //系统创建日期
		s:userpostcreatedate'="" userpostcreatedate=..ConvertTimeStampToDate(userpostcreatedate)
		s userpostcreatetime=DataInfo.%Get("userpost_createtime") //系统创建时间
		s:userpostcreatetime'="" userpostcreatetime=..ConvertTimeStampToDate(userpostcreatetime,"time")
		s userpostcreateuser=DataInfo.%Get("userpost_createuser") //系统创建人
		s userpostcreateuserid=..GetIdByCode(userpostcreateuser,"User.SSUser")
		s userpostseqno=DataInfo.%Get("userpost_seqno") //系统排序号
		s userpostlastupdatedate=DataInfo.%Get("userpost_lastupdatedate") //系统最后更新日期
		s userpostlastupdatetime=DataInfo.%Get("userpost_lastupdatetime") //系统最后更新时间
		s userpostlastupdateuser=DataInfo.%Get("userpost_lastupdateuser") //系统最后更新人
		s userpostpycode=DataInfo.%Get("userpost_pycode") //拼音码
		s userpostwbcode=DataInfo.%Get("userpost_wbcode") //五笔码
		s userpostmark=DataInfo.%Get("userpost_mark") //备注

		s eobj = ##class(web.Entity.CT.HOSUserAccountPost).%New()
		s eobj.USERPOSTRowId=$o(^SSU("SSUSR",userpostparref,"USERPOST",0,"Post",userpostpostid,0))
		s eobj.USERPOSTParRef=userpostparref
		s eobj.USERPOSTPostCode=userpostpostid
		s eobj.USERPOSTActivity=userpostactivity
		s eobj.USERPOSTStartDate=userpoststartdate
		s eobj.USERPOSTEndDate=userpostenddate
		if (eobj.USERPOSTRowId=""){
			s eobj.USERPOSTCreateDate=+$h
			s eobj.USERPOSTCreateTime=$p($h,",",2)
			s eobj.USERPOSTCreateUser=USERID
			s:userpostcreatedate'="" eobj.USERPOSTCreateDate=userpostcreatedate
			s:userpostcreatetime'="" eobj.USERPOSTCreateTime=userpostcreatetime
			s:userpostcreateuserid'="" eobj.USERPOSTCreateUser=userpostcreateuserid
		}
		s eobj.USERPOSTSeqNo=userpostseqno
		s eobj.USERPOSTLastUpdateDate=+$h
		s eobj.USERPOSTLastUpdateTime=$p($h,",",2)
		s eobj.USERPOSTLastUpdateUser=USERID
		s eobj.USERPOSTPYCode=userpostpycode
		s eobj.USERPOSTWBCode=userpostwbcode
		s eobj.USERPOSTMark=userpostmark
		s eobj.USERPOSTDefault=""
		
		s resSave=##class(web.DHCBL.CT.HOSUserAccountPost).SaveEntity(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_userpostaccountcode_"-"_userpostpostcode_""""
			else  s DataRet=DataRet_","_""""_userpostaccountcode_"-"_userpostpostcode_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_userpostaccountcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_userpostaccountcode_""",""errormsg"":"""_errormsg_"""}"
		}	 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步医疗机构
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  User.CTRefClin
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTRefClin("")
ClassMethod SyncCTRefClin(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s horgorgcode=DataInfo.%Get("horg_orgcode") //机构代码
		s orgcode=horgorgcode,orgdesc=""
		s horgorgid=..GetIdByCode(horgorgcode,"CT.BDP.CT.HOSOrganization")
	    s:horgorgid'="" orgdesc=$listget($g(^CT.BDP.CT.HOSOrganizationD(horgorgid)),3)	//组织名称
		s horgbusinessclicensecode=DataInfo.%Get("horg_businessclicensecode") //医疗机构执业许可证号
		s horgbusinessclicensefrom=DataInfo.%Get("horg_businessclicensefrom") //医疗机构执业许可证效期
		s:horgbusinessclicensefrom'="" horgbusinessclicensefrom=..ConvertTimeStampToDate(horgbusinessclicensefrom)
		s horgbusinessclicenseto=DataInfo.%Get("horg_businessclicenseto") //医疗机构执业许可证效期
		s:horgbusinessclicenseto'="" horgbusinessclicenseto=..ConvertTimeStampToDate(horgbusinessclicenseto)
		s horgbeds=DataInfo.%Get("horg_beds") //编制床位数
		s horggradecode=DataInfo.%Get("horg_gradecode") //医院等级代码
		s horggradeid=..GetIdByCode(horggradecode,"CT.BDP.CT.HOSHORGGrade")
		s horgchargestandard=DataInfo.%Get("horg_chargestandard") //医院物价标准
		s horginsucode=DataInfo.%Get("horg_insucode") //医院医保代码
		s horgactivity=DataInfo.%Get("horg_activity") //是否有效
		s horgactivity=$case(horgactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:horgactivity) //是否有效 true/false
		s horgstartdate=DataInfo.%Get("horg_startdate") //开始日期
		s:horgstartdate'="" horgstartdate=..ConvertTimeStampToDate(horgstartdate)
		s horgenddate=DataInfo.%Get("horg_enddate") //结束日期
		s:horgenddate'="" horgenddate=..ConvertTimeStampToDate(horgenddate)
		s horgcreatedate=DataInfo.%Get("horg_createdate") //系统创建日期
		s:horgcreatedate'="" horgcreatedate=..ConvertTimeStampToDate(horgcreatedate)
		s horgcreatetime=DataInfo.%Get("horg_createtime") //系统创建时间
		s:horgcreatetime'="" horgcreatetime=..ConvertTimeStampToDate(horgcreatetime,"time")
		s horgcreateuser=DataInfo.%Get("horg_createuser") //系统创建人
		s horgcreateuserid=..GetIdByCode(horgcreateuser,"User.SSUser")
		s horgseqno=DataInfo.%Get("horg_seqno") //系统排序号
		s horglastupdatedate=DataInfo.%Get("horg_lastupdatedate") //系统最后更新日期
		s horglastupdatetime=DataInfo.%Get("horg_lastupdatetime") //系统最后更新时间
		s horglastupdateuser=DataInfo.%Get("horg_lastupdateuser") //系统最后更新人
		s horgpycode=DataInfo.%Get("horg_pycode") //拼音码
		s horgwbcode=DataInfo.%Get("horg_wbcode") //五笔码
		s horgmark=DataInfo.%Get("horg_mark") //备注

		s eobj = ##class(web.Entity.CT.CTRefClin).%New()
		s eobj.CTRFCRowId=$o(^CT("RFC",0,"Code",$$ALPHAUP^SSUTIL4(orgcode),0))
		s eobj.CTRFCCode=orgcode
		s eobj.CTRFCDesc=orgdesc
		s eobj.CTRFCORGCode=horgorgid
		s eobj.CTRFCBusinessClicenseCode=horgbusinessclicensecode
		s eobj.CTRFCBusinessClicenseFrom=horgbusinessclicensefrom
		s eobj.CTRFCBusinessClicenseTo=horgbusinessclicenseto
		s eobj.CTRFCBeds=horgbeds
		s eobj.CTRFCGradeCode=horggradecode
		s eobj.CTRFCChargeStandard=horgchargestandard
		s eobj.CTRFCInsuCode=horginsucode
		s eobj.CTRFCActiveFlag=horgactivity
		s eobj.CTRFCDateFrom=horgstartdate
		s eobj.CTRFCDateTo=horgenddate
		if (eobj.CTRFCRowId=""){
			s eobj.CTRFCCreateDate=+$h
			s eobj.CTRFCCreateTime=$p($h,",",2)
			s eobj.CTRFCCreateUser=USERID
			s:horgcreatedate'="" eobj.CTRFCCreateDate=horgcreatedate
			s:horglastupdatetime'="" eobj.CTRFCCreateTime=horglastupdatetime
			s:horgcreateuserid'="" eobj.CTRFCCreateUser=horgcreateuserid
		}
		s eobj.CTRFCSeqNo=horgseqno
		s eobj.CTRFCLastUpdateDate=+$h
		s eobj.CTRFCLastUpdateTime=$p($h,",",2)
		s eobj.CTRFCLastUpdateUser=USERID
		s eobj.CTRFCPYCode=horgpycode
		s eobj.CTRFCWBCode=horgwbcode
		s eobj.CTRFCMark=horgmark

		s resSave=..SaveCTRefClin(eobj)
		
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_horgorgcode_""""
			else  s DataRet=DataRet_","_""""_horgorgcode_""""
		}	
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			
			if errorlist="" s errorlist="{""errordataid"":"""_horgorgcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_horgorgcode_""",""errormsg"":"""_errormsg_"""}"
		}	 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Creator：gss
/// CreatDate: 2023-03-29
/// Description：保存医疗机构信息
/// Table：User.CTRefClin
/// Input：Entity
ClassMethod SaveCTRefClin(eobj As web.Entity.CT.CTRefClin) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CTRFCDateFrom'="" eobj.CTRFCDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCDateFrom)
		s:eobj.CTRFCDateTo'="" eobj.CTRFCDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCDateTo)
		s:eobj.CTRFCDateFrom="" eobj.CTRFCDateFrom=+$h
		s:eobj.CTRFCActiveFlag="" eobj.CTRFCActiveFlag ="N"
		s eobj.CTRFCLastUpdateDate=+$H               ///系统最后更新日期
		s eobj.CTRFCLastUpdateTime=$p($h,",",2)       ///系统最后更新时间

		if (eobj.CTRFCRowId="")  //新增
		{
			s eobj.CTRFCCreateDate=+$H           ///系统创建日期
			s eobj.CTRFCCreateTime=$p($h,",",2)  ///系统创建时间
		}
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID")) 
			if (eobj.CTRFCCreateUser="")&&(eobj.CTRFCRowId="") s eobj.CTRFCCreateUser=USERID   ///系统创建人
			if (eobj.CTRFCLastUpdateUser="") s eobj.CTRFCLastUpdateUser=USERID  ///系统最新更新人
		}
		s flag=##class(web.DHCBL.CT.CTRefClin).FormValidate(eobj.CTRFCRowId,eobj.CTRFCCode,eobj.CTRFCDesc)  //调用重复验证
		if (flag=1)
		{  
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.CTRFCRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.CTRefClin).%New()
				s obj.CTRFCCreateDate=eobj.CTRFCCreateDate         ///系统创建日期
				s obj.CTRFCCreateTime=eobj.CTRFCCreateTime  ///系统创建时间
				d obj.CTRFCCreateUserSetObjectId(eobj.CTRFCLastUpdateUser)  ///系统创建人
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.CTRefClin).%OpenId(eobj.CTRFCRowId)
				s bobj=##class(web.Entity.CT.CTRefClin).%New()
				s bobj.CTRFCRowId=eobj.CTRFCRowId
				s bobj.CTRFCCode = obj.CTRFCCode          //修改代码 
				s bobj.CTRFCDesc = obj.CTRFCDesc          //修改描述
				s bobj.CTRFCActiveFlag=obj.CTRFCActiveFlag
				//s bobj.CTRFCVEMD=obj.CTRFCVEMD
				s bobj.CTRFCDateFrom = obj.CTRFCDateFrom  //修改开始日期
				s bobj.CTRFCDateTo = obj.CTRFCDateTo      //修改结束日期   
				if $IsObject(obj.CTRFCORGCode)
				{
					s bobj.CTRFCORGCode = obj.CTRFCORGCode.%Id()   //组织机构-外键
				}
				s bobj.CTRFCBusinessClicenseCode=obj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
				s bobj.CTRFCBusinessClicenseFrom=obj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
				s bobj.CTRFCBusinessClicenseTo=obj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
				s bobj.CTRFCBeds=obj.CTRFCBeds ///编制床位数
				if $IsObject(obj.CTRFCGradeCode)
				{
					s bobj.CTRFCGradeCode = obj.CTRFCGradeCode.%Id()   ///医院等级代码
				}
				s bobj.CTRFCChargeStandard=obj.CTRFCChargeStandard ///医院物价标准
				s bobj.CTRFCInsuCode=obj.CTRFCInsuCode ///医院医保代码
				s bobj.CTRFCCreateDate=obj.CTRFCCreateDate ///系统创建日期
				s bobj.CTRFCCreateTime=obj.CTRFCCreateTime ///系统创建时间
				if $IsObject(obj.CTRFCCreateUser)
				{   
					s bobj.CTRFCCreateUser = obj.CTRFCCreateUser.%Id()   ///系统创建人
				}
				s bobj.CTRFCSeqNo=obj.CTRFCSeqNo ///排序号
				s bobj.CTRFCLastUpdateDate=obj.CTRFCLastUpdateDate ///系统最后更新日期
				s bobj.CTRFCLastUpdateTime=obj.CTRFCLastUpdateTime ///系统最后更新时间
				if $IsObject(obj.CTRFCLastUpdateUser)
				{   
					s bobj.CTRFCLastUpdateUser = obj.CTRFCLastUpdateUser.%Id()   ///系统最新更新人
				}
				s bobj.CTRFCPYCode=obj.CTRFCPYCode ///拼音码
				s bobj.CTRFCWBCode=obj.CTRFCWBCode ///五笔码
				s bobj.CTRFCMark=obj.CTRFCMark ///备注
			}
			Tstart          
			s obj.CTRFCCode = eobj.CTRFCCode          //代码
			s obj.CTRFCDesc = eobj.CTRFCDesc          //描述
			s obj.CTRFCActiveFlag=eobj.CTRFCActiveFlag
			//s obj.CTRFCVEMD=eobj.CTRFCVEMD
			s obj.CTRFCDateFrom = eobj.CTRFCDateFrom  //开始日期
			s obj.CTRFCDateTo = eobj.CTRFCDateTo      //结束日期 
			//s obj.CTRFCCategoryCode=eobj.CTRFCCategoryCode
			//s obj.CTRFCLevel=eobj.CTRFCLevel
			//d obj.CTRFCCityDRSetObjectId(eobj.CTRFCCityDR)
			//d obj.CTRFCCityAreaDRSetObjectId(eobj.CTRFCCityAreaDR)   
			d obj.CTRFCORGCodeSetObjectId(eobj.CTRFCORGCode) ///组织机构-外键
			s obj.CTRFCBusinessClicenseCode=eobj.CTRFCBusinessClicenseCode ///医疗机构执业许可证号
			s:eobj.CTRFCBusinessClicenseFrom'="" eobj.CTRFCBusinessClicenseFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCBusinessClicenseFrom)
			s obj.CTRFCBusinessClicenseFrom=eobj.CTRFCBusinessClicenseFrom ///医疗机构执业许可证效期开始日期
			s:eobj.CTRFCBusinessClicenseTo'="" eobj.CTRFCBusinessClicenseTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTRFCBusinessClicenseTo)
			s obj.CTRFCBusinessClicenseTo=eobj.CTRFCBusinessClicenseTo ///医疗机构执业许可证效期结束日期
			s obj.CTRFCBeds=eobj.CTRFCBeds          ///编制床位数
			d obj.CTRFCGradeCodeSetObjectId(eobj.CTRFCGradeCode) ///医院等级代码
			s obj.CTRFCChargeStandard=eobj.CTRFCChargeStandard ///医院物价标准
			s obj.CTRFCInsuCode=eobj.CTRFCInsuCode        ///医院医保代码
			s obj.CTRFCSeqNo=eobj.CTRFCSeqNo              ///排序号
			s obj.CTRFCLastUpdateDate=eobj.CTRFCLastUpdateDate   ///系统最后更新日期
			s obj.CTRFCLastUpdateTime=eobj.CTRFCLastUpdateTime   ///系统最后更新时间
			d obj.CTRFCLastUpdateUserSetObjectId(eobj.CTRFCLastUpdateUser)  ///系统最新更新人
			s obj.CTRFCPYCode=eobj.CTRFCPYCode ///拼音码
			s obj.CTRFCWBCode=eobj.CTRFCWBCode ///五笔码
			s obj.CTRFCMark=eobj.CTRFCMark ///备注
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.CTRFCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClin","User.CTRefClin","医疗机构",id,eobj.CTRFCDesc,"A",eobj)
				d:eobj.CTRFCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClin","User.CTRefClin","医疗机构",eobj.CTRFCRowId,eobj.CTRFCDesc,"U",eobj,bobj)
				
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构","web.DHCBL.CT.CTRefClin","SaveEntity",eobj)
				s ^ERRORLOGINFO(+logid)=$zconvert(sc,"O","JS")
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Function:   同步医院等级
/// Creator:    gss
/// CreateDate: 2023-03-06
/// TableName:  CT.BDP.CT.HOSHORGGrade
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSHORGGrade("")
ClassMethod SyncHOSHORGGrade(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s horggccode=DataInfo.%Get("horggc_code") //医院等级代码
		s horggcdesc=DataInfo.%Get("horggc_desc") //医院等级名称
		s horggcgrade=DataInfo.%Get("horggc_grade") //医院级别代码
		s horggcgradeclass=DataInfo.%Get("horggc_gradeclass") //医院子级代码
		s horggcsource=DataInfo.%Get("horggc_source") //分类来源
		s horggcactivity=DataInfo.%Get("horggc_activity") //是否有效
		s horggcactivity=$case(horggcactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:horggcactivity) //是否有效 true/false
		s horggcstartdate=DataInfo.%Get("horggc_startdate") //开始日期
		s:horggcstartdate'="" horggcstartdate=..ConvertTimeStampToDate(horggcstartdate)
		s horggcenddate=DataInfo.%Get("horggc_enddate") //结束日期
		s:horggcenddate'="" horggcenddate=..ConvertTimeStampToDate(horggcenddate)
		s horggccreatedate=DataInfo.%Get("horggc_createdate") //系统创建日期
		s:horggccreatedate'="" horggccreatedate=..ConvertTimeStampToDate(horggccreatedate)
		s horggccreatetime=DataInfo.%Get("horggc_createtime") //系统创建时间
		s:horggccreatetime'="" horggccreatetime=..ConvertTimeStampToDate(horggccreatetime,"time")
		s horggccreateuser=DataInfo.%Get("horggc_createuser") //系统创建人
		s horggccreateuserid=..GetIdByCode(horggccreateuser,"User.SSUser")
		s horggcseqno=DataInfo.%Get("horggc_seqno") //系统排序号
		s horggclastupdatedate=DataInfo.%Get("horggc_lastupdatedate") //系统最后更新日期
		s horggclastupdatetime=DataInfo.%Get("horggc_lastupdatetime") //系统最后更新时间
		s horggclastupdateuser=DataInfo.%Get("horggc_lastupdateuser") //系统最后更新人
		s horggcpycode=DataInfo.%Get("horggc_pycode") //拼音码
		s horggcwbcode=DataInfo.%Get("horggc_wbcode") //五笔码
		s horggcmark=DataInfo.%Get("horggc_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSHORGGrade).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSHORGGradeI("IndexCode"," "_$zconvert(horggccode,"u"),0))
		s eobj.HORGGCCode=horggccode
		s eobj.HORGGCDesc=horggcdesc
		s eobj.HORGGCGradeClass=horggcgradeclass
		s eobj.HORGGCSource=horggcsource
		s eobj.HORGGCActivity=horggcactivity
		s eobj.HORGGCStartDate=horggcstartdate
		s eobj.HORGGCEndDate=horggcenddate
		if (eobj.ID=""){
			s eobj.HORGGCCreateDate=+$h
			s eobj.HORGGCCreateTime=$p($h,",",2)
			s eobj.HORGGCCreateUser=USERID
			s:horggccreatedate'="" eobj.HORGGCCreateDate=horggccreatedate
			s:horggccreatetime'="" eobj.HORGGCCreateTime=horggccreatetime
			s:horggccreateuserid'="" eobj.HORGGCCreateUser=horggccreateuserid
		}
		s eobj.HORGGCSeqNo=horggcseqno
		s eobj.HORGGCLastUpdateDate=+$h
		s eobj.HORGGCLastUpdateTime=$p($h,",",2)
		s eobj.HORGGCLastUpdateUser=USERID
		s eobj.HORGGCPYCode=horggcpycode
		s eobj.HORGGCWBCode=horggcwbcode
		s eobj.HORGGCMark=horggcmark
		s resSave=##class(web.DHCBL.CT.HOSHORGGrade).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_horggccode_""""
			else  s DataRet=DataRet_","_""""_horggccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_horggccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_horggccode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步职业大类字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOccuCategory
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOccuCategory("")
ClassMethod SyncHOSOccuCategory(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s occuccode=DataInfo.%Get("occuc_code") //职业大类代码
		s occucdesc=DataInfo.%Get("occuc_desc") //职业大类描述	
		s occucactivity=DataInfo.%Get("occuc_activity") //是否有些
		s occucactivity=$case(occucactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:occucactivity) //是否有效 true/false
		s occucstartdate=DataInfo.%Get("occuc_startdate") //开始日期
		s:occucstartdate'="" occucstartdate=..ConvertTimeStampToDate(occucstartdate)
		s occucenddate=DataInfo.%Get("occuc_enddate") //结束日期
		s:occucenddate'="" occucenddate=..ConvertTimeStampToDate(occucenddate)
		s occuccreatedate=DataInfo.%Get("occuc_createdate") //系统创建日期
		s:occuccreatedate'="" occuccreatedate=..ConvertTimeStampToDate(occuccreatedate)
		s occuccreatetime=DataInfo.%Get("occuc_createtime") //系统创建时间
		s:occuccreatetime'="" occuccreatetime=..ConvertTimeStampToDate(occuccreatetime,"time")
		s occuccreateuser=DataInfo.%Get("occuc_createuser") //系统创建人
		s occucseqno=DataInfo.%Get("occuc_seqno") //系统排序号
		s occuclastupdatedate=DataInfo.%Get("occuc_lastupdatedate") //系统最后更新日期
		s occuclastupdatetime=DataInfo.%Get("occuc_lastupdatetime") //系统最后更新时间
		s occuclastupdateuser=DataInfo.%Get("occuc_lastupdateuser") //系统最后更新人
		s occucpycode=DataInfo.%Get("occuc_pycode") //拼音码
		s occucwbcode=DataInfo.%Get("occuc_wbcode") //五笔码
		s occucmark=DataInfo.%Get("occuc_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSOccuCategory).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSOccuCategoryI("IndexCode"," "_$zconvert(occuccode,"u"),0))
		
		s eobj.OCCUCCode=occuccode
		s eobj.OCCUCDesc=occucdesc
		s eobj.OCCUCActivity=occucactivity
		s eobj.OCCUCStartDate=occucstartdate
		s eobj.OCCUCEndDate=occucenddate
		if (eobj.ID=""){
			s:occuccreatedate'="" eobj.OCCUCCreateDate=occuccreatedate
			s:occuccreatetime'="" eobj.OCCUCCreateTime=occuccreatetime
			s:occuccreateuser'="" eobj.OCCUCCreateUser=occuccreateuser
		}
		s eobj.OCCUCSeqNo=occucseqno
		s eobj.OCCUCLastUpdateDate=+$h
		s eobj.OCCUCLastUpdateTime=$p($h,",",2)
		s eobj.OCCUCLastUpdateUser=USERID
		s eobj.OCCUCPYCode=occucpycode
		s eobj.OCCUCWBCode=occucwbcode
		s eobj.OCCUCMark=occucmark
		
		s resSave=##class(web.DHCBL.CT.HOSOccuCategory).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_occuccode_""""
			else  s DataRet=DataRet_","_""""_occuccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_occuccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_occuccode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步职业字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  User.CTOccupation
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTOccupation("")
ClassMethod SyncCTOccupation(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s occucode=DataInfo.%Get("occu_code") //职业代码
		s occudesc=DataInfo.%Get("occu_desc") //职业描述
		s occuoccuccode=DataInfo.%Get("occu_occuccode") //职业大类	
		s occuactivity=DataInfo.%Get("occu_activity") //是否有些
		s occuactivity=$case(occuactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:occuactivity) //是否有效 true/false
		s occustartdate=DataInfo.%Get("occu_startdate") //开始日期
		s:occustartdate'="" occustartdate=..ConvertTimeStampToDate(occustartdate)
		s occuenddate=DataInfo.%Get("occu_enddate") //结束日期
		s:occuenddate'="" occuenddate=..ConvertTimeStampToDate(occuenddate)
		s occucreatedate=DataInfo.%Get("occu_createdate") //系统创建日期
		s:occucreatedate'="" occucreatedate=..ConvertTimeStampToDate(occucreatedate)		
		s occucreatetime=DataInfo.%Get("occu_createtime") //系统创建时间
		s:occucreatetime'="" occucreatetime=..ConvertTimeStampToDate(occucreatetime,"time")		
		s occucreateuser=DataInfo.%Get("occu_createuser") //系统创建人
		s occuseqno=DataInfo.%Get("occu_seqno") //系统排序号
		s occulastupdatedate=DataInfo.%Get("occu_lastupdatedate") //系统最后更新日期
		s occulastupdatetime=DataInfo.%Get("occu_lastupdatetime") //系统最后更新时间
		s occulastupdateuser=DataInfo.%Get("occu_lastupdateuser") //系统最后更新人
		s occupycode=DataInfo.%Get("occu_pycode") //拼音码
		s occuwbcode=DataInfo.%Get("occu_wbcode") //五笔码
		s occumark=DataInfo.%Get("occu_mark") //备注
		s eobj = ##class(web.Entity.CT.CTOccupation).%New()
		s eobj.CTOCCRowId=$o(^CT("OCC",0,"Code",$$ALPHAUP^SSUTIL4(occucode),0))
		
		s eobj.CTOCCCode=occucode
		s eobj.CTOCCDesc=occudesc
		s eobj.OCCUSCActivity=occuactivity
		s eobj.CTOCCDateFrom=occustartdate
		s eobj.CTOCCDateTo=occuenddate
		if (eobj.CTOCCRowId=""){
			s:occucreatedate'="" eobj.OCCUSCCreateDate=occucreatedate
			s:occucreatetime'="" eobj.OCCUSCCreateTime=occucreatetime
			s:occucreateuser'="" eobj.OCCUSCCreateUser=occucreateuser			
		}
		s eobj.OCCUSCSeqNo=occuseqno
		s eobj.OCCUSCLastUpdateDate=+$h
		s eobj.OCCUSCLastUpdateTime=$p($h,",",2)
		s eobj.OCCUSCLastUpdateUser=USERID
		s eobj.OCCUSCPYCode=occupycode
		s eobj.OCCUSCWBCode=occuwbcode
		s eobj.OCCUSCMark=occumark
		
		s resSave=##class(web.DHCBL.CT.CTOccupation).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_occucode_""""
			else  s DataRet=DataRet_","_""""_occucode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_occucode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_occucode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步宗教信仰字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  User.CTRegion
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTRegion("")
ClassMethod SyncCTRegion(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s religcode=DataInfo.%Get("relig_code") //信仰宗教代码
		s religdesc=DataInfo.%Get("relig_desc") //信仰宗教描述	
		s religactivity=DataInfo.%Get("relig_activity") //是否有些
		s religactivity=$case(religactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:religactivity) //是否有效 true/false
		s religstartdate=DataInfo.%Get("relig_startdate") //开始日期
		s:religstartdate'="" religstartdate=..ConvertTimeStampToDate(religstartdate)
		s religenddate=DataInfo.%Get("relig_enddate") //结束日期
		s:religenddate'="" religenddate=..ConvertTimeStampToDate(religenddate)
		s religcreatedate=DataInfo.%Get("relig_createdate") //系统创建日期
		s:religcreatedate'="" religcreatedate=..ConvertTimeStampToDate(religcreatedate)
		s religcreatetime=DataInfo.%Get("relig_createtime") //系统创建时间
		s:religcreatetime'="" religcreatetime=..ConvertTimeStampToDate(religcreatetime,"time")
		s religcreateuser=DataInfo.%Get("relig_createuser") //系统创建人
		
		s religseqno=DataInfo.%Get("relig_seqno") //系统排序号
		s religlastupdatedate=DataInfo.%Get("relig_lastupdatedate") //系统最后更新日期
		s religlastupdatetime=DataInfo.%Get("relig_lastupdatetime") //系统最后更新时间
		s religlastupdateuser=DataInfo.%Get("relig_lastupdateuser") //系统最后更新人
		s religpycode=DataInfo.%Get("relig_pycode") //拼音码
		s religwbcode=DataInfo.%Get("relig_wbcode") //五笔码
		s religmark=DataInfo.%Get("relig_mark") //备注
		s eobj = ##class(web.Entity.CT.CTReligion).%New()
		s eobj.CTRLGRowId=$o(^CT("RLG",0,"Code",$$ALPHAUP^SSUTIL4(religcode),0))
		
		s eobj.CTRLGCode=religcode
		s eobj.CTRLGDesc=religdesc
		s eobj.CTRLGActivity=religactivity
		s eobj.CTRLGDateFrom=religstartdate
		s eobj.CTRLGDateTo=religenddate
		if (eobj.CTRLGRowId=""){
			s:religcreatedate'="" eobj.CTRLGCreateDate=religcreatedate
			s:religcreatetime'="" eobj.CTRLGCreateTime=religcreatetime
			s:religcreateuser'="" eobj.CTRLGCreateUser=religcreateuser				
		}
		s eobj.CTRLGSeqNo=religseqno
		s eobj.CTRLGLastUpdateDate=+$h
		s eobj.CTRLGLastUpdateTime=$p($h,",",2)
		s eobj.CTRLGLastUpdateUser=USERID
		s eobj.CTRLGPYCode=religpycode
		s eobj.CTRLGWBCode=religwbcode
		s eobj.CTRLGMark=religmark
		
		s resSave=##class(web.DHCBL.CT.CTReligion).SaveEntity(eobj)
		b //1
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_religcode_""""
			else  s DataRet=DataRet_","_""""_religcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_religcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_religcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步流程岗位字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSProcPost
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSProcPost("")
ClassMethod SyncHOSProcPost(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s ppostcode=DataInfo.%Get("ppost_code") //流程岗位代码		
		s ppostdesc=DataInfo.%Get("ppost_desc") //流程岗位描述
		s ppostbucode=DataInfo.%Get("ppost_bucode") //业务单元代码
		s ppostpostccode=DataInfo.%Get("ppost_postccode") //岗位字典代码
		s ppostactivity=DataInfo.%Get("ppost_activity") //是否有些
		s ppostactivity=$case(ppostactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:ppostactivity) //是否有效 true/false
		s ppoststartdate=DataInfo.%Get("ppost_startdate") //开始日期
		s:ppoststartdate'="" religstartdate=..ConvertTimeStampToDate(ppoststartdate)		
		s ppostenddate=DataInfo.%Get("ppost_enddate") //结束日期
		s:ppostenddate'="" ppostenddate=..ConvertTimeStampToDate(ppostenddate)
		s ppostcreatedate=DataInfo.%Get("ppost_createdate") //系统创建日期
		s:ppostcreatedate'="" ppostcreatedate=..ConvertTimeStampToDate(ppostcreatedate)		
		s ppostcreatetime=DataInfo.%Get("ppost_createtime") //系统创建时间
		s:ppostcreatetime'="" ppostcreatetime=..ConvertTimeStampToDate(ppostcreatetime,"time")	
		s ppostcreateuser=DataInfo.%Get("ppost_createuser") //系统创建人
		s ppostseqno=DataInfo.%Get("ppost_seqno") //系统排序号
		s ppostlastupdatedate=DataInfo.%Get("ppost_lastupdatedate") //系统最后更新日期
		s ppostlastupdatetime=DataInfo.%Get("ppost_lastupdatetime") //系统最后更新时间
		s ppostlastupdateuser=DataInfo.%Get("ppost_lastupdateuser") //系统最后更新人
		s ppostpycode=DataInfo.%Get("ppost_pycode") //拼音码
		s ppostwbcode=DataInfo.%Get("ppost_wbcode") //五笔码
		s ppostmark=DataInfo.%Get("ppost_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSProcPost).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSProcPostI("IndexCode"," "_$zconvert(ppostcode,"u"),0))
		
		s eobj.PPOSTCode=ppostcode
		s eobj.PPOSTDesc=ppostdesc
		s eobj.PPOSTBUCode=ppostbucode
		s eobj.PPOSTPOSTCCode=ppostpostccode		
		s eobj.PPOSTActivity=ppostactivity
		s eobj.PPOSTStartDate=ppoststartdate
		s eobj.PPOSTEndDate=ppostenddate
		if (eobj.ID=""){
			
			s:ppostcreatedate'="" eobj.PPOSTCreateDate=ppostcreatedate
			s:ppostcreatetime'="" eobj.PPOSTCreateTime=ppostcreatetime
			s:ppostcreateuser'="" eobj.PPOSTCreateUser=ppostcreateuser			
		}
		s eobj.PPOSTSeqNo=ppostseqno
		s eobj.PPOSTLastUpdateDate=+$h
		s eobj.PPOSTLastUpdateTime=$p($h,",",2)
		s eobj.PPOSTLastUpdateUser=USERID
		s eobj.PPOSTPYCode=ppostpycode
		s eobj.PPOSTWBCode=ppostwbcode
		s eobj.PPOSTMark=ppostmark
		
		s resSave=##class(web.DHCBL.CT.HOSProcPost).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_ppostcode_""""
			else  s DataRet=DataRet_","_""""_ppostcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_ppostcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_ppostcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步流程岗位与业务岗位关系字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSProcPostRelPost
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPostRelBusPost("")
ClassMethod SyncHOSPostRelBusPost(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s pprpid=DataInfo.%Get("pprp_id") //关联ID
		s pprpprocpostcode=DataInfo.%Get("pprp_procpostcode") //流程岗位代码
		s pprppostcode=DataInfo.%Get("pprp_postcode") //业务岗位代码
		
		s pprpactivity=DataInfo.%Get("pprp_activity") //是否有些
		s pprpactivity=$case(pprpactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:pprpactivity) //是否有效 true/false
		s pprpstartdate=DataInfo.%Get("pprp_startdate") //开始日期
		s:pprpstartdate'="" pprpstartdate=..ConvertTimeStampToDate(pprpstartdate)		
		s pprpenddate=DataInfo.%Get("pprp_enddate") //结束日期
		s pprpcreatedate=DataInfo.%Get("pprp_createdate") //系统创建日期
		s:pprpcreatedate'="" pprpcreatedate=..ConvertTimeStampToDate(pprpcreatedate)			
		s pprpcreatetime=DataInfo.%Get("pprp_createtime") //系统创建时间
		s:pprpcreatetime'="" pprpcreatetime=..ConvertTimeStampToDate(pprpcreatetime,"time")		
		s pprpcreateuser=DataInfo.%Get("pprp_createuser") //系统创建人
		s pprpseqno=DataInfo.%Get("pprp_seqno") //系统排序号
		s pprplastupdatedate=DataInfo.%Get("pprp_lastupdatedate") //系统最后更新日期
		s pprplastupdatetime=DataInfo.%Get("pprp_lastupdatetime") //系统最后更新时间
		s pprplastupdateuser=DataInfo.%Get("pprp_lastupdateuser") //系统最后更新人
		s pprppycode=DataInfo.%Get("pprp_pycode") //拼音码
		s pprpwbcode=DataInfo.%Get("pprp_wbcode") //五笔码
		s pprpmark=DataInfo.%Get("pprp_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSProcPostRelPost).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSProcPostRelPostI("IndexCode"," "_$zconvert(pprpcode,"u"),0))
		s eobj.ID=pprpid
		s eobj.PPRPProcPostCode=pprpprocpostcode
		s eobj.PPRPPostCode=pprppostcode	
		s eobj.PPRPActivity=pprpactivity
		s eobj.PPRPStartDate=pprpstartdate
		s eobj.PPRPEndDate=pprpenddate
		if (eobj.ID=""){
			s:pprpcreatedate'="" eobj.PPRPCreateDate=pprpcreatedate
			s:pprpcreatetime'="" eobj.PPRPCreateTime=pprpcreatetime
			s:pprpcreateuser'="" eobj.PPRPCreateUser=pprpcreateuser			
		}
		s eobj.PPRPSeqNo=pprpseqno
		s eobj.PPRPLastUpdateDate=+$h
		s eobj.PPRPLastUpdateTime=$p($h,",",2)
		s eobj.PPRPLastUpdateUser=USERID
		s eobj.PPRPPYCode=pprppycode
		s eobj.PPRPWBCode=pprpwbcode
		s eobj.PPRPMark=pprpmark
		
		s resSave=##class(web.DHCBL.CT.HOSPostRelBusPost).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_pprpprocpostcode_""""
			else  s DataRet=DataRet_","_""""_pprpprocpostcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_pprpprocpostcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_pprpprocpostcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步岗位类型
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPostType
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPostType("")
ClassMethod SyncHOSPostType(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s ptcode=DataInfo.%Get("pt_code") //岗位类型代码	
		s ptdesc=DataInfo.%Get("pt_desc") //岗位类型名称
		
		s ptactivity=DataInfo.%Get("pt_activity") //是否有些
		s ptactivity=$case(ptactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:ptactivity) //是否有效 true/false
		s ptstartdate=DataInfo.%Get("pt_startdate") //开始日期
		s:ptstartdate'="" ptstartdate=..ConvertTimeStampToDate(ptstartdate)			
		s ptenddate=DataInfo.%Get("pt_enddate") //结束日期
		s:ptenddate'="" ptenddate=..ConvertTimeStampToDate(ptenddate)
		s ptcreatedate=DataInfo.%Get("pt_createdate") //系统创建日期
		s:ptcreatedate'="" ptcreatedate=..ConvertTimeStampToDate(ptcreatedate)			
		s ptcreatetime=DataInfo.%Get("pt_createtime") //系统创建时间
		s:ptcreatetime'="" ptcreatetime=..ConvertTimeStampToDate(ptcreatetime,"time")			
		s ptcreateuser=DataInfo.%Get("pt_createuser") //系统创建人
		s ptseqno=DataInfo.%Get("pt_seqno") //系统排序号
		s ptlastupdatedate=DataInfo.%Get("pt_lastupdatedate") //系统最后更新日期
		s ptlastupdatetime=DataInfo.%Get("pt_lastupdatetime") //系统最后更新时间
		s ptlastupdateuser=DataInfo.%Get("pt_lastupdateuser") //系统最后更新人
		s ptpycode=DataInfo.%Get("pt_pycode") //拼音码
		s ptwbcode=DataInfo.%Get("pt_wbcode") //五笔码
		s ptmark=DataInfo.%Get("pt_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSPostType).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSPostTypeI("IndexPTCode"," "_$zconvert(ptcode,"u"),0))
		s eobj.PTCode=ptcode
		s eobj.PTDesc=ptdesc	
		s eobj.PTActivity=ptactivity
		s eobj.PTStartDate=ptstartdate
		s eobj.PTEndDate=ptenddate
		if (eobj.ID=""){
			s:ptcreatedate'="" eobj.PTCreateDate=ptcreatedate
			s:ptcreatetime'="" eobj.PTCreateTime=ptcreatetime
			s:ptcreateuser'="" eobj.PTCreateUser=ptcreateuser				

		}
		s eobj.PTSeqNo=ptseqno
		s eobj.PTLastUpdateDate=+$h
		s eobj.PTLastUpdateTime=$p($h,",",2)
		s eobj.PTLastUpdateUser=USERID
		s eobj.PTPYCode=ptpycode
		s eobj.PTWBCode=ptwbcode
		s eobj.PTMark=ptmark
		
		s resSave=##class(web.DHCBL.CT.HOSPostType).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_ptcode_""""
			else  s DataRet=DataRet_","_""""_ptcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_ptcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_ptcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步岗位中心词
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPostHeadWord
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPostHeadWord("")
ClassMethod SyncHOSPostHeadWord(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s phwcode=DataInfo.%Get("phw_code") //岗位中心词代码	
		s phwdesc=DataInfo.%Get("phw_desc") //岗位中心词名称
		s phwdomaincode=DataInfo.%Get("phw_domaincode") //业务域代码
		s:phwdomaincode'="" phwdomaincode=..GetIdByCode(phwdomaincode,"CT.BDP.CT.HOSBusiDomain")
		s phwactivity=DataInfo.%Get("phw_activity") //是否有些
		s phwactivity=$case(phwactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:phwactivity) //是否有效 true/false
		s phwstartdate=DataInfo.%Get("phw_startdate") //开始日期
		s:phwstartdate'="" phwstartdate=..ConvertTimeStampToDate(phwstartdate)			
		s phwenddate=DataInfo.%Get("phw_enddate") //结束日期
		s:phwenddate'="" phwenddate=..ConvertTimeStampToDate(phwenddate)
		s phwcreatedate=DataInfo.%Get("phw_createdate") //系统创建日期
		s:phwcreatedate'="" phwcreatedate=..ConvertTimeStampToDate(phwcreatedate)		
		s phwcreatetime=DataInfo.%Get("phw_createtime") //系统创建时间
		s:phwcreatetime'="" phwcreatetime=..ConvertTimeStampToDate(phwcreatetime,"time")		
		s phwcreateuser=DataInfo.%Get("phw_createuser") //系统创建人
		s phwseqno=DataInfo.%Get("phw_seqno") //系统排序号
		s phwlastupdatedate=DataInfo.%Get("phw_lastupdatedate") //系统最后更新日期
		s phwlastupdatetime=DataInfo.%Get("phw_lastupdatetime") //系统最后更新时间
		s phwlastupdateuser=DataInfo.%Get("phw_lastupdateuser") //系统最后更新人
		s phwpycode=DataInfo.%Get("phw_pycode") //拼音码
		s phwwbcode=DataInfo.%Get("phw_wbcode") //五笔码
		s phwmark=DataInfo.%Get("phw_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSPostHeadWord).%New()
		s pphwdomaincode=phwdomaincode
		s:phwdomaincode="" pphwdomaincode="-100000000000000"
		s eobj.ID=$o(^CT.BDP.CT.HOSPostHeadWordI("IndexPHWCode"," "_$zconvert(phwcode,"u"),0))		
		s eobj.PHWCode=phwcode
		s eobj.PHWDesc=phwdesc
		s eobj.PHWDomainCode=phwdomaincode	
		s eobj.PHWActivity=phwactivity
		s eobj.PHWStartDate=phwstartdate
		s eobj.PHWEndDate=phwenddate
		if (eobj.ID=""){
			s:phwcreatedate'="" eobj.PHWCreateDate=phwcreatedate
			s:phwcreatetime'="" eobj.PHWCreateTime=phwcreatetime
			s:phwcreateuser'="" eobj.PHWCreateUser=phwcreateuser			
		}
		s eobj.PHWSeqNo=phwseqno
		s eobj.PHWLastUpdateDate=+$h
		s eobj.PHWLastUpdateTime=$p($h,",",2)
		s eobj.PHWLastUpdateUser=USERID
		s eobj.PHWPYCode=phwpycode
		s eobj.PHWWBCode=phwwbcode
		s eobj.PHWMark=phwmark
		
		s resSave=##class(web.DHCBL.CT.HOSPostHeadWord).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_phwcode_""""
			else  s DataRet=DataRet_","_""""_phwcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_phwcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_phwcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步流程中心词
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSFlowHeadWord
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSFlowHeadWord("")
ClassMethod SyncHOSFlowHeadWord(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s fhwcode=DataInfo.%Get("fhw_code") //流程中心词代码	
		s fhwdesc=DataInfo.%Get("fhw_desc") //流程中心词名称
		s fhwdomaincode=DataInfo.%Get("fhw_domaincode") //业务域代码
		s:fhwdomaincode'="" fhwdomaincode=..GetIdByCode(fhwdomaincode,"CT.BDP.CT.HOSBusiDomain")
		s fhwactivity=DataInfo.%Get("fhw_activity") //是否有些
		s fhwactivity=$case(fhwactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:fhwactivity) //是否有效 true/false
		s fhwstartdate=DataInfo.%Get("fhw_startdate") //开始日期
		s:fhwstartdate'="" fhwstartdate=..ConvertTimeStampToDate(fhwstartdate)				
		s fhwenddate=DataInfo.%Get("fhw_enddate") //结束日期
		s:fhwenddate'="" fhwenddate=..ConvertTimeStampToDate(fhwenddate)
		s fhwcreatedate=DataInfo.%Get("fhw_createdate") //系统创建日期
		s:fhwcreatedate'="" fhwcreatedate=..ConvertTimeStampToDate(fhwcreatedate)		
		s fhwcreatetime=DataInfo.%Get("fhw_createtime") //系统创建时间
		s:fhwcreatetime'="" fhwcreatetime=..ConvertTimeStampToDate(fhwcreatetime,"time")			
		s fhwcreateuser=DataInfo.%Get("fhw_createuser") //系统创建人
		s fhwseqno=DataInfo.%Get("fhw_seqno") //系统排序号
		s fhwlastupdatedate=DataInfo.%Get("fhw_lastupdatedate") //系统最后更新日期
		s fhwlastupdatetime=DataInfo.%Get("fhw_lastupdatetime") //系统最后更新时间
		s fhwlastupdateuser=DataInfo.%Get("fhw_lastupdateuser") //系统最后更新人
		s fhwpycode=DataInfo.%Get("fhw_pycode") //拼音码
		s fhwwbcode=DataInfo.%Get("fhw_wbcode") //五笔码
		s fhwmark=DataInfo.%Get("fhw_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSFlowHeadWord).%New()
		s ffhwdomaincode=fhwdomaincode
		s:fhwdomaincode="" ffhwdomaincode="-100000000000000"
		s eobj.ID=$o(^CT.BDP.CT.HOSFlowHeadWordI("IndexFHWCode"," "_$zconvert(fhwcode,"u"),0))
		s eobj.FHWCode=fhwcode
		s eobj.FHWDesc=fhwdesc
		s eobj.FHWDomainCode=fhwdomaincode	
		s eobj.FHWActivity=fhwactivity
		s eobj.FHWStartDate=fhwstartdate
		s eobj.FHWEndDate=fhwenddate
		if (eobj.ID=""){
			s:fhwcreatedate'="" eobj.FHWCreateDate=fhwcreatedate
			s:fhwcreatetime'="" eobj.FHWCreateTime=fhwcreatetime
			s:fhwcreateuser'="" eobj.FHWCreateUser=fhwcreateuser			
		}
		s eobj.FHWSeqNo=fhwseqno
		s eobj.FHWLastUpdateDate=+$h
		s eobj.FHWLastUpdateTime=$p($h,",",2)
		s eobj.FHWLastUpdateUser=USERID
		s eobj.FHWPYCode=fhwpycode
		s eobj.FHWWBCode=fhwwbcode
		s eobj.FHWMark=fhwmark
		
		s resSave=##class(web.DHCBL.CT.HOSFlowHeadWord).SaveEntity(eobj)
		;b:fhwcode="dts0814"
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_fhwcode_""""
			else  s DataRet=DataRet_","_""""_fhwcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_fhwcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_fhwcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织职务
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSProfTitle
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSProfTitle("")
ClassMethod SyncHOSProfTitle(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s proftcode=DataInfo.%Get("proft_code") //职务代码
		s proftdeptcode=DataInfo.%Get("proft_deptcode") //所属部门
		s proftproftccode=DataInfo.%Get("proft_proftc_code") //职务字典代码
		s proftdesc=DataInfo.%Get("proft_desc") //职务名称
		s proftlimitednum=DataInfo.%Get("proft_limitednum") //额定人数
		s proftactivity=DataInfo.%Get("proft_activity") //是否有些
		s proftactivity=$case(proftactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:proftactivity) //是否有效 true/false
		s proftstartdate=DataInfo.%Get("proft_startdate") //开始日期
		s:proftstartdate'="" proftstartdate=..ConvertTimeStampToDate(proftstartdate)		
		s proftenddate=DataInfo.%Get("proft_enddate") //结束日期
		s:proftenddate'="" proftenddate=..ConvertTimeStampToDate(proftenddate)
		s proftcreatedate=DataInfo.%Get("proft_createdate") //系统创建日期
		s:proftcreatedate'="" proftcreatedate=..ConvertTimeStampToDate(proftcreatedate)		
		s proftcreatetime=DataInfo.%Get("proft_createtime") //系统创建时间
		s:proftcreatetime'="" proftcreatetime=..ConvertTimeStampToDate(proftcreatetime,"time")			
		s proftcreateuser=DataInfo.%Get("proft_createuser") //系统创建人
		s proftseqno=DataInfo.%Get("proft_seqno") //系统排序号
		s proftlastupdatedate=DataInfo.%Get("proft_lastupdatedate") //系统最后更新日期
		s proftlastupdatetime=DataInfo.%Get("proft_lastupdatetime") //系统最后更新时间
		s proftlastupdateuser=DataInfo.%Get("proft_lastupdateuser") //系统最后更新人
		s proftpycode=DataInfo.%Get("proft_pycode") //拼音码
		s proftwbcode=DataInfo.%Get("proft_wbcode") //五笔码
		s proftmark=DataInfo.%Get("proft_mark") //备注
		if (proftdeptcode="")
		{	
			s errormsg="该组织职务所属部门在HIS中不存在"
			if errorlist="" s errorlist="{""errordataid"":"""_proftcode_""",""errormsg"":"""_errormsg_"""}"
			continue		
		}		
		s eobj = ##class(web.Entity.CT.HOSProfTitle).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSProfTitleI("IndexCode"," "_$zconvert(proftcode,"u"),0))
		s eobj.PROFTCode=proftcode
		s eobj.PROFTDesc=proftdesc
		s eobj.PROFTDeptCode=proftdeptcode
		s eobj.PROFTPROFTCCode=proftproftccode
		s eobj.PROFTLimitedNum=proftlimitednum
		s eobj.PROFTActivity=proftactivity
		s eobj.PROFTStartDate=proftstartdate
		s eobj.PROFTEndDate=proftenddate
		if (eobj.ID=""){
			s:proftcreatedate'="" eobj.PROFTCreateDate=proftcreatedate
			s:proftcreatetime'="" eobj.PROFTCreateTime=proftcreatetime
			s:proftcreateuser'="" eobj.PROFTCreateUser=proftcreateuser			
		}
		s eobj.PROFTSeqNo=proftseqno
		s eobj.PROFTLastUpdateDate=+$h
		s eobj.PROFTLastUpdateTime=$p($h,",",2)
		s eobj.PROFTLastUpdateUser=USERID
		s eobj.PROFTPYCode=proftpycode
		s eobj.PROFTWBCode=proftwbcode
		s eobj.PROFTMark=proftmark
		
		s resSave=##class(web.DHCBL.CT.HOSProfTitle).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_proftcode_""""
			else  s DataRet=DataRet_","_""""_proftcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_proftcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_proftcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步职务字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSProfTitleDict
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSProfTitleDict("")
ClassMethod SyncHOSProfTitleDict(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s proftccode=DataInfo.%Get("proftc_code") //职务代码
		s proftcdesc=DataInfo.%Get("proftc_desc") //职务名称
		s proftctype=DataInfo.%Get("proftc_type") //职务分类
		s proftcprofrcode=DataInfo.%Get("proftc_profrcode") //职务分类代码
		s proftcactivity=DataInfo.%Get("proftc_activity") //是否有些
		s proftcactivity=$case(proftcactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:proftcactivity) //是否有效 true/false
		s proftcstartdate=DataInfo.%Get("proftc_startdate") //开始日期
		s:proftcstartdate'="" proftcstartdate=..ConvertTimeStampToDate(proftcstartdate)		
		s proftcenddate=DataInfo.%Get("proftc_enddate") //结束日期
		s:proftcenddate'="" proftcenddate=..ConvertTimeStampToDate(proftcenddate)
		s proftccreatedate=DataInfo.%Get("proftc_createdate") //系统创建日期
		s:proftccreatedate'="" proftccreatedate=..ConvertTimeStampToDate(proftccreatedate)			
		s proftccreatetime=DataInfo.%Get("proftc_createtime") //系统创建时间
		s:proftccreatetime'="" proftccreatetime=..ConvertTimeStampToDate(proftccreatetime,"time")			
		s proftccreateuser=DataInfo.%Get("proftc_createuser") //系统创建人
		s proftcseqno=DataInfo.%Get("proftc_seqno") //系统排序号
		s proftclastupdatedate=DataInfo.%Get("proftc_lastupdatedate") //系统最后更新日期
		s proftclastupdatetime=DataInfo.%Get("proftc_lastupdatetime") //系统最后更新时间
		s proftclastupdateuser=DataInfo.%Get("proftc_lastupdateuser") //系统最后更新人
		s proftcpycode=DataInfo.%Get("proftc_pycode") //拼音码
		s proftcwbcode=DataInfo.%Get("proftc_wbcode") //五笔码
		s proftcmark=DataInfo.%Get("proftc_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSProfTitleDict).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFTCCode"," "_$zconvert(proftccode,"u"),0))
		s eobj.PROFTCCode=proftccode
		s eobj.PROFTCDesc=proftcdesc
		s eobj.PROFTCType=proftctype
		s eobj.PROFTCPROFRCode=proftcprofrcode
		s eobj.PROFTCActivity=proftcactivity
		s eobj.PROFTCStartDate=proftcstartdate
		s eobj.PROFTCEndDate=proftcenddate
		if (eobj.ID=""){
			s:proftccreatedate'="" eobj.PROFTCCreateDate=proftccreatedate
			s:proftccreatetime'="" eobj.PROFTCCreateTime=proftccreatetime
			s:proftccreateuser'="" eobj.PROFTCCreateUser=proftccreateuser			
		}
		s eobj.PROFTCSeqNo=proftcseqno
		s eobj.PROFTCLastUpdateDate=+$h
		s eobj.PROFTCLastUpdateTime=$p($h,",",2)
		s eobj.PROFTCLastUpdateUser=USERID
		s eobj.PROFTCPYCode=proftcpycode
		s eobj.PROFTCWBCode=proftcwbcode
		s eobj.PROFTCMark=proftcmark
		
		s resSave=##class(web.DHCBL.CT.HOSProfTitleDict).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_proftccode_""""
			else  s DataRet=DataRet_","_""""_proftccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_proftccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_proftccode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步职务等级字典
/// Creator:    ljw
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSProfRank
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSProfRank("")
ClassMethod SyncHOSProfRank(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s profrcode=DataInfo.%Get("profr_code") //职务等级代码
		s profrdesc=DataInfo.%Get("profr_desc") //职务名称
		s profrrankvalue=DataInfo.%Get("profr_rankvalue") //职务等级
		s profractivity=DataInfo.%Get("proft_activity") //是否有些
		s profractivity=$case(profractivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:proftcactivity) //是否有效 true/false
		s profrstartdate=DataInfo.%Get("profr_startdate") //开始日期
		s:profrstartdate'="" profrstartdate=..ConvertTimeStampToDate(profrstartdate)			
		s profrenddate=DataInfo.%Get("profr_enddate") //结束日期
		s:profrenddate'="" profrenddate=..ConvertTimeStampToDate(profrenddate)
		s profrcreatedate=DataInfo.%Get("profr_createdate") //系统创建日期
		s:profrcreatedate'="" profrcreatedate=..ConvertTimeStampToDate(profrcreatedate)		
		s profrcreatetime=DataInfo.%Get("profr_createtime") //系统创建时间
		s:profrcreatetime'="" profrcreatetime=..ConvertTimeStampToDate(profrcreatetime,"time")			
		s profrcreateuser=DataInfo.%Get("profr_createuser") //系统创建人
		s profrseqno=DataInfo.%Get("profr_seqno") //系统排序号
		s profrlastupdatedate=DataInfo.%Get("profr_lastupdatedate") //系统最后更新日期
		s profrlastupdatetime=DataInfo.%Get("profr_lastupdatetime") //系统最后更新时间
		s profrlastupdateuser=DataInfo.%Get("profr_lastupdateuser") //系统最后更新人
		s profrpycode=DataInfo.%Get("profr_pycode") //拼音码
		s profrwbcode=DataInfo.%Get("profr_wbcode") //五笔码
		s profrmark=DataInfo.%Get("profr_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSProfRank).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSProfRankI("IndexCode"," "_$zconvert(profrcode,"u"),0))
		s eobj.PROFRCode=profrcode
		s eobj.PROFRDesc=profrdesc
		s eobj.PROFRRankValue=profrrankvalue
		s eobj.PROFRActivity=profractivity
		s eobj.PROFRStartDate=profrstartdate
		s eobj.PROFREndDate=profrenddate
		if (eobj.ID=""){
			s:profrcreatedate'="" eobj.PROFRCreateDate=profrcreatedate
			s:profrcreatetime'="" eobj.PROFRCreateTime=profrcreatetime
			s:profrcreateuser'="" eobj.PROFRCreateUser=profrcreateuser	
			
		}
		s eobj.PROFRSeqNo=profrseqno
		s eobj.PROFRLastUpdateDate=+$h
		s eobj.PROFRLastUpdateTime=$p($h,",",2)
		s eobj.PROFRLastUpdateUser=USERID
		s eobj.PROFRPYCode=profrpycode
		s eobj.PROFRWBCode=profrwbcode
		s eobj.PROFRMark=profrmark
		
		s resSave=##class(web.DHCBL.CT.HOSProfRank).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_profrcode_""""
			else  s DataRet=DataRet_","_""""_profrcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_profrcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_profrcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步人员状态字典
/// Creator:    ljw
/// CreateDate: 2023-03-20
/// TableName:  CT.BDP.CT.HOSPersonStatusDict
/// Debug:      w ##class(web.DHCBL.CT.HOSPersonStatusDict).SyncHOSPersonStatusDict("")
ClassMethod SyncHOSPersonStatusDict(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		
		s psdcode=DataInfo.%Get("psd_code") //人员状态代码
		s psddesc=DataInfo.%Get("psd_desc") //人员状态描述
		s psdactivity=DataInfo.%Get("psd_activity") //是否有些
		s psdactivity=$case(psdactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:psdactivity) //是否有效 true/false
		s psdstartdate=DataInfo.%Get("psd_startdate") //开始日期
		s:psdstartdate'="" psdstartdate=..ConvertTimeStampToDate(psdstartdate)
		s psdenddate=DataInfo.%Get("psd_enddate") //结束日期
		s:psdenddate'="" psdenddate=..ConvertTimeStampToDate(psdenddate)
		s psdcreatedate=DataInfo.%Get("psd_createdate") //系统创建日期
		s:psdcreatedate'="" psdcreatedate=..ConvertTimeStampToDate(psdcreatedate)
		s psdcreatetime=DataInfo.%Get("psd_createtime") //系统创建时间
		s:psdcreatetime'="" psdcreatetime=..ConvertTimeStampToDate(psdcreatetime,"time")		
		s psdcreateuser=DataInfo.%Get("psd_createuser") //系统创建人
		s psdseqno=DataInfo.%Get("psd_seqno") //系统排序号
		s psdlastupdatedate=DataInfo.%Get("psd_lastupdatedate") //系统最后更新日期
		s psdlastupdatetime=DataInfo.%Get("psd_lastupdatetime") //系统最后更新时间
		s psdlastupdateuser=DataInfo.%Get("psd_lastupdateuser") //系统最后更新人
		s psdpycode=DataInfo.%Get("psd_pycode") //拼音码
		s psdwbcode=DataInfo.%Get("psd_wbcode") //五笔码
		s psdmark=DataInfo.%Get("psd_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSPersonStatusDict).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSPersonStatusDictI("IndexCode"," "_$zconvert(psdcode,"u"),0))
		s eobj.PSDCode=psdcode
		s eobj.PSDDesc=psddesc
		s eobj.PSDActivity=psdactivity
		s eobj.PSDStartDate=psdstartdate
		s eobj.PSDEndDate=psdenddate
		if (eobj.ID=""){
			s:psdcreatedate'="" eobj.PSDCreateDate=psdcreatedate
			s:psdcreatetime'="" eobj.PSDCreateTime=psdcreatetime
			s:psdcreateuser'="" eobj.PSDCreateUser=psdcreateuser	
			
		}
		s eobj.PSDSeqNo=psdseqno
		s eobj.PSDLastUpdateDate=+$h
		s eobj.PSDLastUpdateTime=$p($h,",",2)
		s eobj.PSDLastUpdateUser=USERID
		s eobj.PSDPYCode=psdpycode
		s eobj.PSDWBCode=psdwbcode
		s eobj.PSDMark=psdmark
		
		s resSave=##class(web.DHCBL.CT.HOSPersonStatusDict).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_psdcode_""""
			else  s DataRet=DataRet_","_""""_psdcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_psdcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_psdcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步工作状态字典
/// Creator:    ljw
/// CreateDate: 2023-03-20
/// TableName:  CT.BDP.CT.HOSEmpStatusDict
/// Debug:      w ##class(web.DHCBL.CT.HOSEmpStatusDict).SyncHOSEmpStatusDict("")
ClassMethod SyncHOSEmpStatusDict(ByRef DataList) As %String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		
		s esdcode=DataInfo.%Get("esd_code") //工作状态代码
		s esddesc=DataInfo.%Get("esd_desc") //工作状态描述
		s esdactivity=DataInfo.%Get("esd_activity") //是否有些
		s esdactivity=$case(esdactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:esdactivity) //是否有效 true/false
		s esdstartdate=DataInfo.%Get("esd_startdate") //开始日期
		s:esdstartdate'="" esdstartdate=..ConvertTimeStampToDate(esdstartdate)		
		s esdenddate=DataInfo.%Get("esd_enddate") //结束日期
		s:esdenddate'="" esdenddate=..ConvertTimeStampToDate(esdenddate)
		s esdcreatedate=DataInfo.%Get("esd_createdate") //系统创建日期
		s:esdcreatedate'="" esdcreatedate=..ConvertTimeStampToDate(esdcreatedate)			
		s esdcreatetime=DataInfo.%Get("esd_createtime") //系统创建时间
		s:esdcreatetime'="" esdcreatetime=..ConvertTimeStampToDate(esdcreatetime,"time")		
		s esdcreateuser=DataInfo.%Get("esd_createuser") //系统创建人
		s esdseqno=DataInfo.%Get("esd_seqno") //系统排序号
		s esdlastupdatedate=DataInfo.%Get("esd_lastupdatedate") //系统最后更新日期
		s esdlastupdatetime=DataInfo.%Get("esd_lastupdatetime") //系统最后更新时间
		s esdlastupdateuser=DataInfo.%Get("esd_lastupdateuser") //系统最后更新人
		s esdpycode=DataInfo.%Get("esd_pycode") //拼音码
		s esdwbcode=DataInfo.%Get("esd_wbcode") //五笔码
		s esdmark=DataInfo.%Get("esd_mark") //备注
		s eobj = ##class(web.Entity.CT.HOSEmpStatusDict).%New()
		s eobj.ID=$o(^CT.BDP.CT.HOSEmpStatusDictI("IndexCode"," "_$zconvert(esdcode,"u"),0))
		s eobj.ESDCode=esdcode
		s eobj.ESDDesc=esddesc
		s eobj.ESDActivity=esdactivity
		s eobj.ESDStartDate=esdstartdate
		s eobj.ESDEndDate=esdenddate
		if (eobj.ID=""){
			s:esdcreatedate'="" eobj.ESDCreateDate=esdcreatedate
			s:esdcreatetime'="" eobj.ESDCreateTime=esdcreatetime
			s:esdcreateuser'="" eobj.ESDCreateUser=esdcreateuser	
			
		}
		s eobj.ESDSeqNo=esdseqno
		s eobj.ESDLastUpdateDate=+$h
		s eobj.ESDLastUpdateTime=$p($h,",",2)
		s eobj.ESDLastUpdateUser=USERID
		s eobj.ESDPYCode=esdpycode
		s eobj.ESDWBCode=esdwbcode
		s eobj.ESDMark=esdmark
		
		s resSave=##class(web.DHCBL.CT.HOSEmpStatusDict).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_esdcode_""""
			else  s DataRet=DataRet_","_""""_esdcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_esdcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_esdcode_""",""errormsg"":"""_errormsg_"""}"
		}		 
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步国家地区字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTCountry
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTCountry("")
ClassMethod SyncCTCountry(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
	q "{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":[]}}"
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		s countrycode=DataInfo.%Get("country_code") //国家代码
		s countrychnfulldesc=DataInfo.%Get("country_chnfulldesc") //国家中文全称
		s countrychnshortdesc=DataInfo.%Get("country_chnshortdesc") //国家中文简称
		s countryengfulldesc=DataInfo.%Get("country_engfulldesc") //国家英文全称
		s countryengshortdesc=DataInfo.%Get("country_engshortdesc") //国家英文简称
		s countryromancode2=DataInfo.%Get("country_romancode2") //罗马2字符代码
		s countryromancode3=DataInfo.%Get("country_romancode3") //罗马3字符代码
		s countryengshortdesc=DataInfo.%Get("country_engshortdesc") //国家英文简称
		s countryengshortdesc=DataInfo.%Get("country_engshortdesc") //国家英文简称
		
		s countryactivity=DataInfo.%Get("country_activity") //是否有效
		s countryactivity=$case(countryactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:countryactivity) //是否有效 true/false
		s countrystartdate=DataInfo.%Get("country_startdate") //开始日期
		s:countrystartdate'="" countrystartdate=..ConvertTimeStampToDate(countrystartdate)
		s countryenddate=DataInfo.%Get("country_enddate") //结束日期
		s:countryenddate'="" countryenddate=..ConvertTimeStampToDate(countryenddate)
		s countrycreatedate=DataInfo.%Get("country_createdate") //系统创建日期
		s:countrycreatedate'="" countrycreatedate=..ConvertTimeStampToDate(countrycreatedate)
		s countrycreatetime=DataInfo.%Get("country_createtime") //系统创建时间
		s:countrycreatedate'="" countrycreatedate=..ConvertTimeStampToDate(countrycreatedate,"time")
		
		s countrycreateuser=DataInfo.%Get("country_createuser") //系统创建人
		s:countrycreateuser'="" countrycreateuser=..GetIdByCode(countrycreateuser,"User.SSUser")
		s countryseqno=DataInfo.%Get("country_seqno") //系统排序号
		s countrylastupdatedate=DataInfo.%Get("country_lastupdatedate") //系统最后更新日期
		s countrylastupdatetime=DataInfo.%Get("country_lastupdatetime") //系统最后更新时间
		s countrylastupdateuser=DataInfo.%Get("country_lastupdateuser") //系统最后更新人
		s countrypycode=DataInfo.%Get("country_pycode") //拼音码
		s countrywbcode=DataInfo.%Get("country_wbcode") //五笔码
		s countrymark=DataInfo.%Get("country_mark") //备注
		s eobj = ##class(web.Entity.CT.CTCountry).%New()
        s eobj.CTCOURowId = $o(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(countrycode),0))
        s eobj.CTCOUCode = countrycode
        s eobj.CTCOUDesc = countrychnshortdesc
        s eobj.CTCOUActive = countryactivity		//是否有效(Y/N)
        s eobj.CTCOUDateActiveFrom = countrystartdate
        s eobj.CTCOUDateActiveTo = countrycreatedate
        s:eobj.CTCOURowId'="" eobj.CTCOULanguageDR=$p($g(^CT("COU",eobj.CTCOURowId)),"^",6)
        
        s eobj.CTCOUENGShortDesc = countryengshortdesc	//英文简称
        s eobj.CTCOUCHNFullDesc = countrychnfulldesc		//中文全称
        s eobj.CTCOUENGFullDesc = countryengfulldesc		//英文全称
        s eobj.CTCOURomanCode2 = countryromancode2		//罗马2字符代码
        s eobj.CTCOURomanCode3 = countryromancode3		//罗马3字符代码
        
	    s:countrycreatedate'="" eobj.CTCOUCreateDate=countrycreatedate
        s:countrycreatetime'="" eobj.CTCOUCreateTime=countrycreatetime
        s:countrycreateuser'="" eobj.CTCOUCreateUser=countrycreateuser
        
		s eobj.CTCOUSeqNo=countryseqno		//系统排序号
		
		s eobj.CTCOUPYCode=countrypycode		//拼音码
		s eobj.CTCOUWBCode=countrywbcode		//五笔码
		s eobj.CTCOUMark=countrymark		//备注
			
		s resSave=##class(web.DHCBL.CT.CTCountry).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_countrycode_""""
			else  s DataRet=DataRet_","_""""_countrycode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_countrycode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_countrycode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步省字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTProvince
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTProvince("")
ClassMethod SyncCTProvince(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
	q "{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":[]}}"
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
		
			
		s provcode=DataInfo.%Get("prov_code") //省级行政区代码
		s provdesc=DataInfo.%Get("prov_desc") //省级行政描述
		s provromancode=DataInfo.%Get("prov_romancode") //省级行政罗马代码
		s provromandesc=DataInfo.%Get("prov_romandesc") //省级行政罗马代码描述
		s provcountrycode=DataInfo.%Get("prov_countrycode") //国家地区代码
		s:provcountrycode'="" provcountrycode=..GetIdByCode(provcountrycode,"User.CTCountry")
		s provactivity=DataInfo.%Get("prov_activity") //是否有效
		s provactivity=$case(provactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:provactivity) //是否有效 true/false
		s provstartdate=DataInfo.%Get("prov_startdate") //开始日期
		s:provstartdate'="" provstartdate=..ConvertTimeStampToDate(provstartdate)
		s provenddate=DataInfo.%Get("prov_enddate") //结束日期
		s:provenddate'="" provenddate=..ConvertTimeStampToDate(provenddate)
		s provcreatedate=DataInfo.%Get("prov_createdate") //系统创建日期
		s:provcreatedate'="" provcreatedate=..ConvertTimeStampToDate(provcreatedate)
		s provcreatetime=DataInfo.%Get("prov_createtime") //系统创建时间
		s:provcreatetime'="" provcreatetime=..ConvertTimeStampToDate(provcreatetime,"time")
		s provcreateuser=DataInfo.%Get("prov_createuser") //系统创建人
		s:provcreateuser'="" provcreateuser=..GetIdByCode(provcreateuser,"User.SSUser")
		s provseqno=DataInfo.%Get("prov_seqno") //系统排序号
		s provlastupdatedate=DataInfo.%Get("prov_lastupdatedate") //系统最后更新日期
		s provlastupdatetime=DataInfo.%Get("prov_lastupdatetime") //系统最后更新时间
		s provlastupdateuser=DataInfo.%Get("prov_lastupdateuser") //系统最后更新人
		s provpycode=DataInfo.%Get("prov_pycode") //拼音码
		s provwbcode=DataInfo.%Get("prov_wbcode") //五笔码
		s provmark=DataInfo.%Get("prov_mark") //备注
		
		s eobj=##class(web.Entity.CT.CTProvince).%New()
        s eobj.PROVRowId = $o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(provcode),0))
        s eobj.PROVCode = provcode
        s eobj.PROVDesc = provdesc
 
        s eobj.PROVDateFrom=provstartdate
        s eobj.PROVDateTo=provenddate
        
        s eobj.PROVRomanCode=provromancode		//省级行政区罗马代码
        s eobj.PROVRomanDesc=provromandesc		//省级行政区罗马名称
        
        s eobj.PROVCountryCode = provcountrycode 		//国家-外键
        
        s eobj.PROVActivity=provactivity		//是否有效(Y/N)
        s:provcreatedate'="" eobj.PROVCreateDate=provcreatedate
        s:provcreatetime'="" eobj.PROVCreateTime=provcreatetime
        s:provcreateuser'="" eobj.PROVCreateUser=provcreateuser
        s eobj.PROVSeqNo=provseqno		//系统排序号
		
		s eobj.PROVPYCode=provpycode		//拼音码
		s eobj.PROVWBCode=provwbcode		//五笔码
		s eobj.PROVMark=provmark		//备注
			
			
		s resSave=##class(web.DHCBL.CT.CTProvince).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_provcode_""""
			else  s DataRet=DataRet_","_""""_provcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_provcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_provcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步城市字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTCity
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTCity("")
ClassMethod SyncCTCity(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
	q "{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":[]}}"
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		s DataInfo=DataList.%Get(di)
			
		s citycode=DataInfo.%Get("city_code") //市级行政区代码
		s citydesc=DataInfo.%Get("city_desc") //市级行政代码描述
		s cityromancode=DataInfo.%Get("city_romancode") //市级行政区罗马代码
		s cityromandesc=DataInfo.%Get("city_romandesc") //市级行政区罗马代码描述
		s cityprovcode=DataInfo.%Get("city_provcode") //省级行政代码
		s:cityprovcode'="" cityprovcode=..GetIdByCode(cityprovcode,"User.CTProvince")
		
		s cityactivity=DataInfo.%Get("city_activity") //是否有效
		s cityactivity=$case(cityactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:cityactivity) //是否有效 true/false
		s citystartdate=DataInfo.%Get("city_startdate") //开始日期
		s:citystartdate'="" citystartdate=..ConvertTimeStampToDate(citystartdate)
		s cityenddate=DataInfo.%Get("city_enddate") //结束日期
		s:cityenddate'="" cityenddate=..ConvertTimeStampToDate(cityenddate)
		s citycreatedate=DataInfo.%Get("city_createdate") //系统创建日期
		s:citycreatedate'="" citycreatedate=..ConvertTimeStampToDate(citycreatedate)
		s citycreatetime=DataInfo.%Get("city_createtime") //系统创建时间
		s citycreateuser=DataInfo.%Get("city_createuser") //系统创建人
		s:citycreateuser'="" citycreateuser=..GetIdByCode(citycreateuser,"User.SSUser")
		s cityseqno=DataInfo.%Get("city_seqno") //系统排序号
		s citylastupdatedate=DataInfo.%Get("city_lastupdatedate") //系统最后更新日期
		s:citylastupdatedate'="" citylastupdatedate=..ConvertTimeStampToDate(citylastupdatedate,"time")
		s citylastupdatetime=DataInfo.%Get("city_lastupdatetime") //系统最后更新时间
		s citylastupdateuser=DataInfo.%Get("city_lastupdateuser") //系统最后更新人
		s citypycode=DataInfo.%Get("city_pycode") //拼音码
		s citywbcode=DataInfo.%Get("city_wbcode") //五笔码
		s citymark=DataInfo.%Get("city_mark") //备注
		
		s eobj=##class(web.Entity.CT.CTCity).%New()
        s eobj.CTCITRowId = $o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(citycode),0))
        s eobj.CTCITCode = citycode
        s eobj.CTCITDesc = citydesc
        s eobj.CTCITProvinceDR = cityprovcode
		
        s eobj.CTCITDateFrom = citystartdate
        s eobj.CTCITDateTo   = cityenddate
        
        s eobj.CTCITRomanCode   = cityromancode		//市级行政区罗马代码
        s eobj.CTCITRomanDesc   = cityromandesc		//市级行政区罗马名称
        s eobj.CTCITActivity=cityactivity	//是否有效(Y/N)
        s:citycreatedate'="" eobj.CTCITCreateDate=citycreatedate
        s:citycreatetime'="" eobj.CTCITCreateTime=citycreatetime
        s:citycreateuser'="" eobj.CTCITCreateUser=citycreateuser
        
		s eobj.CTCITSeqNo=cityseqno		//系统排序号
		
		s eobj.CTCITPYCode=citypycode		//拼音码
		s eobj.CTCITWBCode=citywbcode		//五笔码
		s eobj.CTCITMark=citymark		//备注
        
		s resSave=##class(web.DHCBL.CT.CTCity).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_citycode_""""
			else  s DataRet=DataRet_","_""""_citycode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_citycode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_citycode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步区域字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTCityArea
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTCityArea("")
ClassMethod SyncCTCityArea(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
	q "{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":[]}}"
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
				
		s distrcode=DataInfo.%Get("distr_code") //县级行政代码
		s distrdesc=DataInfo.%Get("distr_desc") //县级行政代码描述
		s distrromancode=DataInfo.%Get("distr_romancode") //县级行政区罗马代码
		s distrromandesc=DataInfo.%Get("distr_romandesc") //县级行政区罗马代码描述
		s distrcitycode=DataInfo.%Get("distr_citycode") //省级行政代码
		s:distrcitycode'="" distrcitycode=..GetIdByCode(distrcitycode,"User.CTCity")
		s distractivity=DataInfo.%Get("distr_activity") //是否有效
		s distractivity=$case(distractivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:distractivity) //是否有效 true/false
		s distrstartdate=DataInfo.%Get("distr_startdate") //开始日期
		s:distrstartdate'="" distrstartdate=..ConvertTimeStampToDate(distrstartdate)
		s distrenddate=DataInfo.%Get("distr_enddate") //结束日期
		s:distrenddate'="" distrenddate=..ConvertTimeStampToDate(distrenddate)
		s distrcreatedate=DataInfo.%Get("distr_createdate") //系统创建日期
		s:distrcreatedate'="" distrcreatedate=..ConvertTimeStampToDate(distrcreatedate)
		s distrcreatetime=DataInfo.%Get("distr_createtime") //系统创建时间
		s:distrcreatetime'="" distrcreatetime=..ConvertTimeStampToDate(distrcreatetime,"time")
		s distrcreateuser=DataInfo.%Get("distr_createuser") //系统创建人
		s:distrcreateuser'="" distrcreateuser=..GetIdByCode(distrcreateuser,"User.SSUser")
		s distrseqno=DataInfo.%Get("distr_seqno") //系统排序号
		s distrlastupdatedate=DataInfo.%Get("distr_lastupdatedate") //系统最后更新日期
		s distrlastupdatetime=DataInfo.%Get("distr_lastupdatetime") //系统最后更新时间
		s distrlastupdateuser=DataInfo.%Get("distr_lastupdateuser") //系统最后更新人
		s distrpycode=DataInfo.%Get("distr_pycode") //拼音码
		s distrwbcode=DataInfo.%Get("distr_wbcode") //五笔码
		s distrmark=DataInfo.%Get("distr_mark") //备注
		
		s eobj=##class(web.Entity.CT.CTCityArea).%New()
	    s eobj.CITAREARowId = $o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(distrcode),0))
	    s eobj.CITAREACode = distrcode
	    s eobj.CITAREADesc = distrdesc
      	
        s eobj.CITAREACityDR = distrcitycode 
        
      	s eobj.CITAREADateFrom = distrstartdate
      	s eobj.CITAREADateTo   = distrenddate
      
      	s eobj.CITAREARomanCode=distrromancode		//县级行政区罗马代码
        s eobj.CITAREARomanDesc=distrromandesc		//县级行政区罗马名称
        
        s eobj.CITAREAActivity=distractivity		//是否有效(Y/N)
        s:distrcreatedate'="" eobj.CITAREACreateDate=distrcreatedate
        s:distrcreatetime'="" eobj.CITAREACreateTime=distrcreatetime
        s:distrcreateuser'="" eobj.CITAREACreateUser=distrcreateuser
        
        s eobj.CITAREASeqNo=distrseqno		//系统排序号
		
		s eobj.CITAREAPYCode=distrpycode		//拼音码
		s eobj.CITAREAWBCode=distrwbcode		//五笔码
		s eobj.CITAREAMark=distrmark		//备注
      
		s resSave=##class(web.DHCBL.CT.CTCityArea).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_distrcode_""""
			else  s DataRet=DataRet_","_""""_distrcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_distrcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_distrcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步机构大类字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOrgCategory
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOrgCategory("")
ClassMethod SyncHOSOrgCategory(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
				
		s orgccode=DataInfo.%Get("orgc_code") //组织机构大类代码
		s orgcdesc=DataInfo.%Get("orgc_desc") //组织机构大类名称
		s orgcsource=DataInfo.%Get("orgc_source") //分类来源
		
		s orgcactivity=DataInfo.%Get("orgc_activity") //是否有效
		s orgcactivity=$case(orgcactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:orgcactivity) //是否有效 true/false
		s orgcstartdate=DataInfo.%Get("orgc_startdate") //开始日期
		s:orgcstartdate'="" orgcstartdate=..ConvertTimeStampToDate(orgcstartdate)
		s orgcenddate=DataInfo.%Get("orgc_enddate") //结束日期
		s:orgcenddate'="" orgcenddate=..ConvertTimeStampToDate(orgcenddate)
		s orgccreatedate=DataInfo.%Get("orgc_createdate") //系统创建日期
		s:orgccreatedate'="" orgccreatedate=..ConvertTimeStampToDate(orgccreatedate)
		s orgccreatetime=DataInfo.%Get("orgc_createtime") //系统创建时间
		s:orgccreatetime'="" orgccreatetime=..ConvertTimeStampToDate(orgccreatetime,"time")
		s orgccreateuser=DataInfo.%Get("orgc_createuser") //系统创建人
		s:orgccreateuser'="" orgccreateuser=..GetIdByCode(orgccreateuser,"User.SSUser")
		s orgcseqno=DataInfo.%Get("orgc_seqno") //系统排序号
		s orgclastupdatedate=DataInfo.%Get("orgc_lastupdatedate") //系统最后更新日期
		s orgclastupdatetime=DataInfo.%Get("orgc_lastupdatetime") //系统最后更新时间
		s orgclastupdateuser=DataInfo.%Get("orgc_lastupdateuser") //系统最后更新人
		s orgcpycode=DataInfo.%Get("orgc_pycode") //拼音码
		s orgcwbcode=DataInfo.%Get("orgc_wbcode") //五笔码
		s orgcmark=DataInfo.%Get("orgc_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSOrgCategory).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSOrgCategoryI("IndexCode"," "_$zconvert(orgccode,"u"),0)) 
        s eobj.ORGCCode=orgccode	//组织机构大类代码
        s eobj.ORGCDesc= orgcdesc	//组织机构大类名称
		
		s eobj.ORGCSource=orgcsource		//分类来源
		s eobj.ORGCActivity=orgcactivity	//是否有效(Y/N)
		s eobj.ORGCStartDate=orgcstartdate		//开始日期
		s eobj.ORGCEndDate=orgcenddate		//结束日期
		s:orgccreatedate'="" eobj.ORGCCreateDate=orgccreatedate
        s:orgccreatetime'="" eobj.ORGCCreateTime=orgccreatetime
        s:orgccreateuser'="" eobj.ORGCCreateUser=orgccreateuser
        
		s eobj.ORGCSeqNo=orgcseqno		//系统排序号
		
		s eobj.ORGCPYCode=orgcpycode		//拼音码
		s eobj.ORGCWBCode=orgcwbcode		//五笔码
		s eobj.ORGCMark=orgcmark		//备注
		
      
		s resSave=##class(web.DHCBL.CT.HOSOrgCategory).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_orgccode_""""
			else  s DataRet=DataRet_","_""""_orgccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_orgccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_orgccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步机构子类字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOrgSubCategory
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOrgSubCategory("")
ClassMethod SyncHOSOrgSubCategory(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
				
		s orgsccode=DataInfo.%Get("orgsc_code") //机构分类代码
		s orgscdesc=DataInfo.%Get("orgsc_desc") //机构分类名称
		s orgscorgccode=DataInfo.%Get("orgsc_orgccode") //机构大类
		s:orgscorgccode'="" orgscorgccode=..GetIdByCode(orgscorgccode,"CT.BDP.CT.HOSOrgCategory")
		s orgscsource=DataInfo.%Get("orgsc_source") //分类来源
		
		s orgscactivity=DataInfo.%Get("orgsc_activity") //是否有效
		s orgscactivity=$case(orgscactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:orgscactivity) //是否有效 true/false
		s orgscstartdate=DataInfo.%Get("orgsc_startdate") //开始日期
		s:orgscstartdate'="" orgscstartdate=..ConvertTimeStampToDate(orgscstartdate)
		s orgscenddate=DataInfo.%Get("orgsc_enddate") //结束日期
		s:orgscenddate'="" orgscenddate=..ConvertTimeStampToDate(orgscenddate)
		s orgsccreatedate=DataInfo.%Get("orgsc_createdate") //系统创建日期
		s:orgsccreatedate'="" orgsccreatedate=..ConvertTimeStampToDate(orgsccreatedate)
		s orgsccreatetime=DataInfo.%Get("orgsc_createtime") //系统创建时间
		s:orgsccreatetime'="" orgsccreatetime=..ConvertTimeStampToDate(orgsccreatetime,"time")
		s orgsccreateuser=DataInfo.%Get("orgsc_createuser") //系统创建人
		s:orgsccreateuser'="" orgsccreateuser=..GetIdByCode(orgsccreateuser,"User.SSUser")
		s orgscseqno=DataInfo.%Get("orgsc_seqno") //系统排序号
		s orgsclastupdatedate=DataInfo.%Get("orgsc_lastupdatedate") //系统最后更新日期
		s orgsclastupdatetime=DataInfo.%Get("orgsc_lastupdatetime") //系统最后更新时间
		s orgsclastupdateuser=DataInfo.%Get("orgsc_lastupdateuser") //系统最后更新人
		s orgscpycode=DataInfo.%Get("orgsc_pycode") //拼音码
		s orgscwbcode=DataInfo.%Get("orgsc_wbcode") //五笔码
		s orgscmark=DataInfo.%Get("orgsc_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSOrgSubCategory).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSOrgSubCategoryI("IndexCode"," "_$zconvert(orgsccode,"u"),0))
        s eobj.ORGSCCode=orgsccode	//组织机构子类代码
        s eobj.ORGSCDesc= orgscdesc	//组织机构子类名称
        
		s eobj.ORGSCORGCCode =orgscorgccode	//组织机构大类-外键
		
		s eobj.ORGSCSource=orgscsource		//分类来源
		s eobj.ORGSCActivity=orgscactivity	//是否有效(Y/N)
		s eobj.ORGSCStartDate=orgscstartdate		//开始日期
		s eobj.ORGSCEndDate=orgscenddate		//结束日期
		s:orgsccreatedate'="" eobj.ORGSCCreateDate=orgsccreatedate
        s:orgsccreatetime'="" eobj.ORGSCCreateTime=orgsccreatetime
        s:orgsccreateuser'="" eobj.ORGSCCreateUser=orgsccreateuser
        
		s eobj.ORGSCSeqNo=orgscseqno		//系统排序号
		
		s eobj.ORGSCPYCode=orgscpycode		//拼音码
		s eobj.ORGSCWBCode=orgscwbcode		//五笔码
		s eobj.ORGSCMark=orgscmark		//备注
		
      
		s resSave=##class(web.DHCBL.CT.HOSOrgSubCategory).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_orgsccode_""""
			else  s DataRet=DataRet_","_""""_orgsccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_orgsccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_orgsccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步机构小类字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOrgMinCategory
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOrgMinCategory("")
ClassMethod SyncHOSOrgMinCategory(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
				
		s orgmccode=DataInfo.%Get("orgmc_code") //机构分类代码
		s orgmcdesc=DataInfo.%Get("orgmc_desc") //机构分类名称
		s orgmcorgscode=DataInfo.%Get("orgmc_orgscode") //机构分类子类
		s:orgmcorgscode'="" orgmcorgscode=..GetIdByCode(orgmcorgscode,"CT.BDP.CT.HOSOrgSubCategory")
		s orgmcsource=DataInfo.%Get("orgmc_source") //分类来源
		
		s orgmcactivity=DataInfo.%Get("orgmc_activity") //是否有效
		s orgmcactivity=$case(orgmcactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:orgmcactivity) //是否有效 true/false
		s orgmcstartdate=DataInfo.%Get("orgmc_startdate") //开始日期
		s:orgmcstartdate'="" orgmcstartdate=..ConvertTimeStampToDate(orgmcstartdate)
		s orgmcenddate=DataInfo.%Get("orgmc_enddate") //结束日期
		s:orgmcenddate'="" orgmcenddate=..ConvertTimeStampToDate(orgmcenddate)
		s orgmccreatedate=DataInfo.%Get("orgmc_createdate") //系统创建日期
		s:orgmccreatedate'="" orgmccreatedate=..ConvertTimeStampToDate(orgmccreatedate)
		s orgmccreatetime=DataInfo.%Get("orgmc_createtime") //系统创建时间
		s:orgmccreatetime'="" orgmccreatetime=..ConvertTimeStampToDate(orgmccreatetime,"time")
		s orgmccreateuser=DataInfo.%Get("orgmc_createuser") //系统创建人
		s:orgmccreateuser'="" orgmccreateuser=..GetIdByCode(orgmccreateuser,"User.SSUser")
		s orgmcseqno=DataInfo.%Get("orgmc_seqno") //系统排序号
		s orgmclastupdatedate=DataInfo.%Get("orgmc_lastupdatedate") //系统最后更新日期
		s orgmclastupdatetime=DataInfo.%Get("orgmc_lastupdatetime") //系统最后更新时间
		s orgmclastupdateuser=DataInfo.%Get("orgmc_lastupdateuser") //系统最后更新人
		s orgmcwbcode=DataInfo.%Get("orgmc_wbcode") //拼音码
		s orgmcpycode=DataInfo.%Get("orgmc_pycode") //五笔码
		s orgmcmark=DataInfo.%Get("orgmc_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSOrgMinCategory).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSOrgMinCategoryI("IndexCode"," "_$zconvert(orgmccode,"u"),0))
        s eobj.ORGMCCode=orgmccode	//组织机构小类代码
        s eobj.ORGMCDesc= orgmcdesc	//组织机构小类名称
		s eobj.ORGMCORGSCode = orgmcorgscode 	//组织机构子类-外键
		
		s eobj.ORGMCSource=orgmcsource		//分类来源
		s eobj.ORGMCActivity=orgmcactivity	//是否有效(Y/N)
		s eobj.ORGMCStartDate=orgmcstartdate		//开始日期
		s eobj.ORGMCEndDate=orgmcenddate		//结束日期
		s:orgmccreatedate'="" eobj.ORGMCCreateDate=orgmccreatedate
        s:orgmccreatetime'="" eobj.ORGMCCreateTime=orgmccreatetime
        s:orgmccreateuser'="" eobj.ORGMCCreateUser=orgmccreateuser
        
		s eobj.ORGMCSeqNo=orgmcseqno		//系统排序号
		
		s eobj.ORGMCPYCode=orgmcwbcode		//拼音码
		s eobj.ORGMCWBCode=orgmcpycode		//五笔码
		s eobj.ORGMCMark=orgmcmark		//备注
		
      
		s resSave=##class(web.DHCBL.CT.HOSOrgMinCategory).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_orgmccode_""""
			else  s DataRet=DataRet_","_""""_orgmccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_orgmccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_orgmccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织行政属性字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOrgAdminType
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOrgAdminType("")
ClassMethod SyncHOSOrgAdminType(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
					
		s orgaccode=DataInfo.%Get("orgac_code") //机构行政属性代码
		s orgacdesc=DataInfo.%Get("orgac_desc") //机构行政属性名称
		s orgacactivity=DataInfo.%Get("orgac_activity") //是否有效
		s orgacactivity=$case(orgacactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:orgacactivity) //是否有效 true/false
		s orgacstartdate=DataInfo.%Get("orgac_startdate") //开始日期
		s:orgacstartdate'="" orgacstartdate=..ConvertTimeStampToDate(orgacstartdate)
		s orgacenddate=DataInfo.%Get("orgac_enddate") //结束日期
		s:orgacenddate'="" orgacenddate=..ConvertTimeStampToDate(orgacenddate)
		s orgaccreatedate=DataInfo.%Get("orgac_createdate") //系统创建日期
		s:orgaccreatedate'="" orgaccreatedate=..ConvertTimeStampToDate(orgaccreatedate)
		s orgaccreatetime=DataInfo.%Get("orgac_createtime") //系统创建时间
		s:orgaccreatetime'="" orgaccreatetime=..ConvertTimeStampToDate(orgaccreatetime,"time")
		s orgaccreateuser=DataInfo.%Get("orgac_createuser") //系统创建人
		s:orgaccreateuser'="" orgaccreateuser=..GetIdByCode(orgaccreateuser,"User.SSUser")
		s orgacseqno=DataInfo.%Get("orgac_seqno") //系统排序号
		s orgaclastupdatedate=DataInfo.%Get("orgac_lastupdatedate") //系统最后更新日期
		s orgaclastupdatetime=DataInfo.%Get("orgac_lastupdatetime") //系统最后更新时间
		s orgaclastupdateuser=DataInfo.%Get("orgac_lastupdateuser") //系统最后更新人
		s orgacpycode=DataInfo.%Get("orgac_pycode") //拼音码
		s orgacwbcode=DataInfo.%Get("orgac_wbcode") //五笔码
		s orgacmark=DataInfo.%Get("orgac_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSOrgAdminType).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSOrgAdminTypeI("IndexCode"," "_$zconvert(orgaccode,"u"),0))
        s eobj.ORGACCode=orgaccode	//组织机构行政属性代码
        s eobj.ORGACDesc= orgacdesc	//组织机构行政属性名称

		s eobj.ORGACActivity=orgacactivity	//是否有效(Y/N)
		s eobj.ORGACStartDate=orgacstartdate		//开始日期
		s eobj.ORGACEndDate=orgacenddate		//结束日期
		s:orgaccreatedate'="" eobj.ORGACCreateDate=orgaccreatedate
        s:orgaccreatetime'="" eobj.ORGACCreateTime=orgaccreatetime
        s:orgaccreateuser'="" eobj.ORGACCreateUser=orgaccreateuser
        
		s eobj.ORGACSeqNo=orgacseqno		//系统排序号
		
		s eobj.ORGACPYCode=orgacpycode		//拼音码
		s eobj.ORGACWBCode=orgacwbcode		//五笔码
		s eobj.ORGACMark=orgacmark		//备注
		
      
		s resSave=##class(web.DHCBL.CT.HOSOrgAdminType).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_orgaccode_""""
			else  s DataRet=DataRet_","_""""_orgaccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_orgaccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_orgaccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织机构字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSOrganization
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSOrganization("")
ClassMethod SyncHOSOrganization(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
			
		s orgcode=DataInfo.%Get("org_code") //机构代码
		s orgdesc=DataInfo.%Get("org_desc") //机构名称
		s orguscc=DataInfo.%Get("org_uscc") //统一社会信用代码
		s orgabbrev=DataInfo.%Get("org_abbrev") //机构简称
		s orgintro=DataInfo.%Get("org_intro") //机构简介
		s orglegalentity=DataInfo.%Get("org_legalentity") //机构法人
		s orgheader=DataInfo.%Get("org_header") //机构负责人
		s orgorgcode=DataInfo.%Get("org_orgcode") //上级机构
		s:orgorgcode'="" orgorgcode=..GetIdByCode(orgorgcode,"CT.BDP.CT.HOSOrganization")
		s orgomccode=DataInfo.%Get("org_omccode") //机构小类
		s:orgomccode'="" orgomccode=..GetIdByCode(orgomccode,"CT.BDP.CT.HOSOrgMinCategory")
		s orgcountrycode=DataInfo.%Get("org_countrycode") //所在国家
		s:orgcountrycode'="" orgcountrycode=..GetIdByCode(orgcountrycode,"User.CTCountry")
		s orgprovcode=DataInfo.%Get("org_provcode") //所在省 
		s:orgprovcode'="" orgprovcode=..GetIdByCode(orgprovcode,"User.CTProvince")
		s orgcitycode=DataInfo.%Get("org_citycode") //所在市
		s:orgcitycode'="" orgcitycode=..GetIdByCode(orgcitycode,"User.CTCity")
		s orgdistrcode=DataInfo.%Get("org_distrcode") //所在区
		s:orgdistrcode'="" orgdistrcode=..GetIdByCode(orgdistrcode,"User.CTCityArea")
		s orgaddress=DataInfo.%Get("org_address") //机构地址
		s orgzipcode=DataInfo.%Get("org_zipcode") //机构邮编
		s orgtel=DataInfo.%Get("org_tel") //联系电话
		s orgfax=DataInfo.%Get("org_fax") //传真
		s orgemail=DataInfo.%Get("org_email") //邮件
		s orgwebsite=DataInfo.%Get("org_website") //官网
		s orgfounddate=DataInfo.%Get("org_founddate") //建立日期
		s:orgfounddate'="" orgfounddate=..ConvertTimeStampToDate(orgfounddate)
		s orgcanceldate=DataInfo.%Get("org_canceldate") //注销日期
		s:orgcanceldate'="" orgcanceldate=..ConvertTimeStampToDate(orgcanceldate)
		s orgactivity=DataInfo.%Get("org_activity") //是否有效
		s orgactivity=$case(orgactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:orgactivity) //是否有效 true/false
		s orgstartdate=DataInfo.%Get("org_startdate") //开始日期
		s:orgstartdate'="" orgstartdate=..ConvertTimeStampToDate(orgstartdate)
		s orgenddate=DataInfo.%Get("org_enddate") //结束日期
		s:orgenddate'="" orgenddate=..ConvertTimeStampToDate(orgenddate)
		s orgcreatedate=DataInfo.%Get("org_createdate") //系统创建日期
		s:orgcreatedate'="" orgcreatedate=..ConvertTimeStampToDate(orgcreatedate)
		s orgcreatetime=DataInfo.%Get("org_createtime") //系统创建时间
		s:orgcreatetime'="" orgcreatetime=..ConvertTimeStampToDate(orgcreatetime,"time")
		
		s orgcreateuser=DataInfo.%Get("org_createuser") //系统创建人
		s:orgcreateuser'="" orgcreateuser=..GetIdByCode(orgcreateuser,"User.SSUser")
		s orgseqno=DataInfo.%Get("org_seqno") //系统排序号
		s orglastupdatedate=DataInfo.%Get("org_lastupdatedate") //系统最后更新日期
		s orglastupdatetime=DataInfo.%Get("org_lastupdatetime") //系统最后更新时间
		s orglastupdateuser=DataInfo.%Get("org_lastupdateuser") //系统最后更新人
		s orgpycode=DataInfo.%Get("org_pycode") //拼音码
		s orgwbcode=DataInfo.%Get("org_wbcode") //五笔码
		s orgmark=DataInfo.%Get("org_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSOrganization).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSOrganizationI("IndexCode"," "_$zconvert(orgcode,"u"),0))
        s eobj.ORGCode=orgcode	//组织代码
        s eobj.ORGDesc= orgdesc	//组织名称
        s eobj.ORGUSCC=orguscc	//统一社会信用代码
		s eobj.ORGAbbrev=orgintro		//组织简称
		s eobj.ORGIntro=orgintro		//组织简介

		s eobj.ORGLegalEntity=orglegalentity		//组织法人
		s eobj.ORGHeader=orgheader		//组织负责人
		
		s eobj.ORGORGCode = orgorgcode 	//上级机构
		s eobj.ORGORGMCCode = orgomccode 	//组织小类
		s eobj.ORGCountryCode = orgcountrycode 	//组织所在国家
		s eobj.ORGPROVCode = orgprovcode 	//组织所在省
		s eobj.ORGCITYCode = orgcitycode 	//组织所在市
		s eobj.ORGDISTRCode = orgdistrcode 	//组织所在区
		
		s eobj.ORGAddress=orgaddress		//组织地址
		s eobj.ORGZipCode=orgzipcode		//组织邮编
		s eobj.ORGTel=orgtel		//联系电话
		s eobj.ORGFax=orgfax		//传真
		s eobj.ORGEmail=orgemail		//邮件
		s eobj.ORGWebSite=orgwebsite		//官网
		s eobj.ORGFoundDate=orgfounddate		//建立日期
		s eobj.ORGCancelDate=orgcanceldate		//注销日期
		
		s eobj.ORGActivity=orgactivity	//是否有效(Y/N)
		s eobj.ORGStartDate=orgstartdate		//开始日期
		s eobj.ORGEndDate=orgenddate		//结束日期
		s:orgcreatedate'="" eobj.ORGCreateDate=orgcreatedate
        s:orgcreatetime'="" eobj.ORGCreateTime=orgcreatetime
        s:orgcreateuser'="" eobj.ORGCreateUser=orgcreateuser
        
		s eobj.ORGSeqNo=orgseqno		//系统排序号
		
		s eobj.ORGPYCode=orgpycode		//拼音码
		s eobj.ORGWBCode=orgwbcode		//五笔码
		s eobj.ORGMark=orgmark		//备注
			
		s resSave=##class(web.DHCBL.CT.HOSOrganization).SaveEntity(eobj)
		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_orgcode_""""
			else  s DataRet=DataRet_","_""""_orgcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_orgcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_orgcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织部门字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSDepartment
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSDepartment("")
ClassMethod SyncHOSDepartment(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
		
			
		s deptcode=DataInfo.%Get("dept_code") //部门代码
		s deptdesc=DataInfo.%Get("dept_desc") //部门名称
		s deptabbrev=DataInfo.%Get("dept_abbrev") //部门简称
		s deptintro=DataInfo.%Get("dept_intro") //部门简介

		s deptdeptcode=DataInfo.%Get("dept_deptcode") //上级部门
		s:deptdeptcode'="" deptdeptcode=..GetIdByCode(deptdeptcode,"CT.BDP.CT.HOSDepartment")
		s deptorgcode=DataInfo.%Get("dept_orgcode") //所属机构
		s:deptorgcode'="" deptorgcode=..GetIdByCode(deptorgcode,"CT.BDP.CT.HOSOrganization")
		s deptorgaccode=DataInfo.%Get("dept_orgaccode") //行政类型
		s:deptorgaccode'="" deptorgaccode=..GetIdByCode(deptorgaccode,"CT.BDP.CT.HOSOrgAdminType")
		
		s deptaddress=DataInfo.%Get("dept_address") //部门地址（位置）
		s depttel=DataInfo.%Get("dept_tel") //联系电话
		s deptfax=DataInfo.%Get("dept_fax") //传真
		s deptemail=DataInfo.%Get("dept_email") //邮件
		s deptfounddate=DataInfo.%Get("dept_founddate") //建立日期
		s:deptfounddate'="" deptfounddate=..ConvertTimeStampToDate(deptfounddate)
		s deptcanceldate=DataInfo.%Get("dept_canceldate") //注销日期
		s:deptcanceldate'="" deptcanceldate=..ConvertTimeStampToDate(deptcanceldate)
		s deptactivity=DataInfo.%Get("dept_activity") //是否有效
		s deptactivity=$case(deptactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:deptactivity) //是否有效 true/false
		s deptstartdate=DataInfo.%Get("dept_startdate") //开始日期
		s:deptstartdate'="" deptstartdate=..ConvertTimeStampToDate(deptstartdate)
		s deptenddate=DataInfo.%Get("dept_enddate") //结束日期
		s:deptenddate'="" deptenddate=..ConvertTimeStampToDate(deptenddate)
		s deptcreatedate=DataInfo.%Get("dept_createdate") //系统创建日期
		s:deptcreatedate'="" deptcreatedate=..ConvertTimeStampToDate(deptcreatedate)
		s deptcreatetime=DataInfo.%Get("dept_createtime") //系统创建时间
		s:deptcreatetime'="" deptcreatetime=..ConvertTimeStampToDate(deptcreatetime,"time")
		s deptcreateuser=DataInfo.%Get("dept_createuser") //系统创建人
		s:deptcreateuser'="" deptcreateuser=..GetIdByCode(deptcreateuser,"User.SSUser")
		s deptseqno=DataInfo.%Get("dept_seqno") //系统排序号
		s deptlastupdatedate=DataInfo.%Get("dept_lastupdatedate") //系统最后更新日期
		s deptlastupdatetime=DataInfo.%Get("dept_lastupdatetime") //系统最后更新时间
		s deptlastupdateuser=DataInfo.%Get("dept_lastupdateuser") //系统最后更新人
		s deptpycode=DataInfo.%Get("dept_pycode") //拼音码
		s deptwbcode=DataInfo.%Get("dept_wbcode") //五笔码
		s deptmark=DataInfo.%Get("dept_mark") //备注
		
		if (deptorgcode="")
		{
			s errormsg="该部门所属机构在HIS中不存在"
			if errorlist="" s errorlist="{""errordataid"":"""_deptcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_deptcode_""",""errormsg"":"""_errormsg_"""}"
			continue
		}
		
		s eobj=##class(web.Entity.CT.HOSDepartment).%New()
		s pdeptcode=deptdeptcode
		s:deptdeptcode="" pdeptcode="-100000000000000"
        s eobj.ID=$o(^CT.BDP.CT.HOSDepartmentI("IndexLevelCode",pdeptcode,deptcode,0))
        s eobj.DEPTCode=deptcode	//部门代码
        s eobj.DEPTDesc= deptdesc	//部门名称
		s eobj.DEPTAbbrev=deptabbrev		//部门简称
		s eobj.DEPTIntro=deptintro		//部门简介

		s eobj.DEPTDeptCode = deptdeptcode	//上级部门
		s eobj.DEPTORGCode = deptorgcode 	//所属机构
		s eobj.DEPTORGACCode = deptorgaccode 	//行政类型
		s eobj.DEPTAddress=deptaddress		//部门地址（位置）
		s eobj.DEPTTel=depttel		//联系电话
		s eobj.DEPTFax=deptfax		//传真
		s eobj.DEPTEmail=deptemail		//邮件
		s eobj.DEPTFoundDate=deptfounddate		//建立日期
		s eobj.DEPTCancelDate=deptcanceldate		//注销日期
		
		s eobj.DEPTActivity=deptactivity	//是否有效(Y/N)
		s eobj.DEPTStartDate=deptstartdate		//开始日期
		s eobj.DEPTEndDate=deptenddate		//结束日期
		s:deptcreatedate'="" eobj.DEPTCreateDate=deptcreatedate
        s:deptcreatetime'="" eobj.DEPTCreateTime=deptcreatetime
        s:deptcreateuser'="" eobj.DEPTCreateUser=deptcreateuser
		
		s eobj.DEPTSeqNo=deptseqno		//系统排序号
		
		s eobj.DEPTPYCode=deptpycode		//拼音码
		s eobj.DEPTWBCode=deptwbcode		//五笔码
		s eobj.DEPTMark=deptmark		//备注
			
		s resSave=##class(web.DHCBL.CT.HOSDepartment).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_deptcode_""""
			else  s DataRet=DataRet_","_""""_deptcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_deptcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_deptcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步职位字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPositionDict
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPositionDict("")
ClassMethod SyncHOSPositionDict(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
	
			
		s posccode=DataInfo.%Get("posc_code") //职位代码
		s poscdesc=DataInfo.%Get("posc_desc") //职位名称
		
		s poscactivity=DataInfo.%Get("posc_activity") //是否有效
		s poscactivity=$case(poscactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:poscactivity) //是否有效 true/false
		s poscstartdate=DataInfo.%Get("posc_startdate") //开始日期
		s:poscstartdate'="" poscstartdate=..ConvertTimeStampToDate(poscstartdate)
		s poscenddate=DataInfo.%Get("posc_enddate") //结束日期
		s:poscenddate'="" poscenddate=..ConvertTimeStampToDate(poscenddate)
		s posccreatedate=DataInfo.%Get("posc_createdate") //系统创建日期
		s:posccreatedate'="" posccreatedate=..ConvertTimeStampToDate(posccreatedate)
		s posccreatetime=DataInfo.%Get("posc_createtime") //系统创建时间
		s:posccreatetime'="" posccreatetime=..ConvertTimeStampToDate(posccreatetime,"time")
		s posccreateuser=DataInfo.%Get("posc_createuser") //系统创建人
		s:posccreateuser'="" posccreateuser=..GetIdByCode(posccreateuser,"User.SSUser")
		s poscseqno=DataInfo.%Get("posc_seqno") //系统排序号
		s posclastupdatedate=DataInfo.%Get("posc_lastupdatedate") //系统最后更新日期
		s posclastupdatetime=DataInfo.%Get("posc_lastupdatetime") //系统最后更新时间
		s posclastupdateuser=DataInfo.%Get("posc_lastupdateuser") //系统最后更新人
		s poscpycode=DataInfo.%Get("posc_pycode") //拼音码
		s poscwbcode=DataInfo.%Get("posc_wbcode") //五笔码
		s poscmark=DataInfo.%Get("posc_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSPositionDict).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSPositionDictI("IndexCode"," "_$zconvert(posccode,"u"),0))
        s eobj.POSCCode=posccode	//职位字典代码
        s eobj.POSCDesc= poscdesc	//职位字典名称

		s eobj.POSCActivity=poscactivity	//是否有效(Y/N)
		s eobj.POSCStartDate=poscstartdate		//开始日期
		s eobj.POSCEndDate=poscenddate		//结束日期
		s:posccreatedate'="" eobj.POSCCreateDate=posccreatedate
        s:posccreatetime'="" eobj.POSCCreateTime=posccreatetime
        s:posccreateuser'="" eobj.POSCCreateUser=posccreateuser
		
		s eobj.POSCSeqNo=poscseqno		//系统排序号
		
		s eobj.POSCPYCode=poscpycode		//拼音码
		s eobj.POSCWBCode=poscwbcode		//五笔码
		s eobj.POSCMark=poscmark		//备注
			
		s resSave=##class(web.DHCBL.CT.HOSPositionDict).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_posccode_""""
			else  s DataRet=DataRet_","_""""_posccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_posccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_posccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步组织职位字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPosition
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPosition("")
ClassMethod SyncHOSPosition(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
	
		s poscode=DataInfo.%Get("pos_code") //组织职位代码
		s posdesc=DataInfo.%Get("pos_desc") //组织职位名称
		s posdeptcode=DataInfo.%Get("pos_deptcode") //所属部门
		s:posdeptcode'="" posdeptcode=..GetIdByCode(posdeptcode,"CT.BDP.CT.HOSDepartment")
		s posposccode=DataInfo.%Get("pos_posc_code") //职位字典代码
		s:posposccode'="" posposccode=..GetIdByCode(posposccode,"CT.BDP.CT.HOSPositionDict")
		s poslimitednum=DataInfo.%Get("pos_limitednum") //额定人数
		
		s posactivity=DataInfo.%Get("pos_activity") //是否有效
		s posactivity=$case(posactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:posactivity) //是否有效 true/false
		s posstartdate=DataInfo.%Get("pos_startdate") //开始日期
		s:posstartdate'="" posstartdate=..ConvertTimeStampToDate(posstartdate)
		s posenddate=DataInfo.%Get("pos_enddate") //结束日期
		s:posenddate'="" posenddate=..ConvertTimeStampToDate(posenddate)
		s poscreatedate=DataInfo.%Get("pos_createdate") //系统创建日期
		s:poscreatedate'="" poscreatedate=..ConvertTimeStampToDate(poscreatedate)
		s poscreatetime=DataInfo.%Get("pos_createtime") //系统创建时间
		s:poscreatetime'="" poscreatetime=..ConvertTimeStampToDate(poscreatetime,"time")
		s poscreateuser=DataInfo.%Get("pos_createuser") //系统创建人
		s:poscreateuser'="" poscreateuser=..GetIdByCode(poscreateuser,"User.SSUser")
		s posseqno=DataInfo.%Get("pos_seqno") //系统排序号
		s poslastupdatedate=DataInfo.%Get("pos_lastupdatedate") //系统最后更新日期
		s poslastupdatetime=DataInfo.%Get("pos_lastupdatetime") //系统最后更新时间
		s poslastupdateuser=DataInfo.%Get("pos_lastupdateuser") //系统最后更新人
		s pospycode=DataInfo.%Get("pos_pycode") //拼音码
		s poswbcode=DataInfo.%Get("pos_wbcode") //五笔码
		s posmark=DataInfo.%Get("pos_mark") //备注
		if (posdeptcode="")
		{
			s errormsg="该组织职位所属部门在HIS中不存在"
			if errorlist="" s errorlist="{""errordataid"":"""_poscode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_poscode_""",""errormsg"":"""_errormsg_"""}"
			continue
		}
		s eobj=##class(web.Entity.CT.HOSPosition).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSPositionI("IndexCode"," "_$zconvert(poscode,"u"),0))
        s eobj.POSCode=poscode	//组织职位代码
        s eobj.POSDesc= posdesc	//组织职位名称
		s eobj.POSDeptCode = posdeptcode 	//所属部门-外键
		s eobj.POSPOSCCode = posposccode 	//职位字典-外键

		s eobj.POSLimitedNum=poslimitednum	//额定人数
		
		s eobj.POSActivity=posactivity	//是否有效(Y/N)
		s eobj.POSStartDate=posstartdate		//开始日期
		s eobj.POSEndDate=posenddate		//结束日期
		s:poscreatedate'="" eobj.POSCreateDate=poscreatedate
        s:poscreatetime'="" eobj.POSCreateTime=poscreatetime
        s:poscreateuser'="" eobj.POSCreateUser=poscreateuser
        
		s eobj.POSSeqNo=posseqno		//系统排序号
		
		s eobj.POSPYCode=pospycode		//拼音码
		s eobj.POSWBCode=poswbcode		//五笔码
		s eobj.POSMark=posmark		//备注
		
		s resSave=##class(web.DHCBL.CT.HOSPosition).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_poscode_""""
			else  s DataRet=DataRet_","_""""_poscode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_poscode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_poscode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步业务域字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSBusiDomain
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSBusiDomain("")
ClassMethod SyncHOSBusiDomain(ByRef DataList) As web.BDP.sys.String
{
	s $zt="ERROR2"
	//s ^TMPBDP("CT.BDP.CT.HOSBusiDomain")=DataStr
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
		s domaincode=DataInfo.%Get("domain_code") //业务域代码
		s domaindesc=DataInfo.%Get("domain_desc") //业务域名称
		s parentdomaincode=DataInfo.%Get("parent_domain_code") //父级业务域代码
		s:parentdomaincode'="" parentdomaincode=..GetIdByCode(parentdomaincode,"CT.BDP.CT.HOSBusiDomain")
		s domainlevel=DataInfo.%Get("domain_level") //业务域层级
		s domainactivity=DataInfo.%Get("domain_activity") //是否有效
		s domainactivity=$case(domainactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:domainactivity) //是否有效 true/false
		s domainstartdate=DataInfo.%Get("domain_startdate") //开始日期
		s:domainstartdate'="" domainstartdate=..ConvertTimeStampToDate(domainstartdate)
		s domainenddate=DataInfo.%Get("domain_enddate") //结束日期
		s:domainenddate'="" domainenddate=..ConvertTimeStampToDate(domainenddate)
		s domaincreatedate=DataInfo.%Get("domain_createdate") //系统创建日期
		s:domaincreatedate'="" domaincreatedate=..ConvertTimeStampToDate(domaincreatedate)
		s domaincreatetime=DataInfo.%Get("domain_createtime") //系统创建时间
		s:domaincreatetime'="" domaincreatetime=..ConvertTimeStampToDate(domaincreatetime,"time")
		s domaincreateuser=DataInfo.%Get("domain_createuser") //系统创建人
		s:domaincreateuser'="" domaincreateuser=..GetIdByCode(domaincreateuser,"User.SSUser")
		s domainseqno=DataInfo.%Get("domain_seqno") //系统排序号
		s domainlastupdatedate=DataInfo.%Get("domain_lastupdatedate") //系统最后更新日期
		s domainlastupdatetime=DataInfo.%Get("domain_lastupdatetime") //系统最后更新时间
		s domainlastupdateuser=DataInfo.%Get("domain_lastupdateuser") //系统最后更新人
		s domainpycode=DataInfo.%Get("domain_pycode") //拼音码
		s domainwbcode=DataInfo.%Get("domain_wbcode") //五笔码
		s domainmark=DataInfo.%Get("domain_mark") //备注
		s pcode=parentdomaincode
		s:parentdomaincode="" pcode="-100000000000000"
		s eobj=##class(web.Entity.CT.HOSBusiDomain).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSBusiDomainI("IndexParCode",pcode,domaincode,0))
        s eobj.DomainCode=domaincode	//业务域代码
        s eobj.DomainDesc=domaindesc	//业务域名称
        
		s eobj.DomainParentCode = parentdomaincode 	//父级业务域代码-外键
		 
		s eobj.DomainLevel=domainlevel		//业务域层级
		s eobj.DomainActivity=domainactivity	//是否有效(Y/N)
		s eobj.DomainStartDate=domainstartdate		//开始日期
		s eobj.DomainEndDate=domainenddate		//结束日期
		s:domaincreatedate'="" eobj.DomainCreateDate=domaincreatedate
        s:domaincreatetime'="" eobj.DomainCreateTime=domaincreatetime
        s:domaincreateuser'="" eobj.DomainCreateUser=domaincreateuser
		
		s eobj.DomainSeqNo=domainseqno	//系统排序号
		
		s eobj.DomainPYCode=domainpycode		//拼音码
		s eobj.DomainWBCode=domainwbcode		//五笔码
		s eobj.DomainMark=domainmark		//备注
		
		
      
		s resSave=##class(web.DHCBL.CT.HOSBusiDomain).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_domaincode_""""
			else  s DataRet=DataRet_","_""""_domaincode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_domaincode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_domaincode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
ERROR2
	S result="SyncHOSBusiDomain"_$ze
	q result
}

/// Function:   同步业务单元字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTLoc
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncCTLoc("")
ClassMethod SyncCTLoc(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
	q "{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":[]}}"
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
		s bucode=DataInfo.%Get("bu_code") //业务单元代码
		s budesc=DataInfo.%Get("bu_desc") //业务单元名称
		s budeptcode=DataInfo.%Get("bu_deptcode") //部门代码
		s:budeptcode'="" budeptcode=..GetIdByCode(budeptcode,"CT.BDP.CT.HOSDepartment")
		s budomaincode=DataInfo.%Get("bu_domaincode") //业务域代码
		s:budomaincode'="" budomaincode=..GetIdByCode(budomaincode,"CT.BDP.CT.HOSBusiDomain")
		
		s bulocation=DataInfo.%Get("bu_location") //物理位置
		s buactivity=DataInfo.%Get("bu_activity") //是否有效
		s buactivity=$case(buactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:buactivity) //是否有效 true/false
		s bustartdate=DataInfo.%Get("bu_startdate") //开始日期
		s:bustartdate'="" bustartdate=..ConvertTimeStampToDate(bustartdate)
		s buenddate=DataInfo.%Get("bu_enddate") //结束日期
		s:buenddate'="" buenddate=..ConvertTimeStampToDate(buenddate)
		s bucreatedate=DataInfo.%Get("bu_createdate") //系统创建日期
		s:bucreatedate'="" bucreatedate=..ConvertTimeStampToDate(bucreatedate)
		s bucreatetime=DataInfo.%Get("bu_createtime") //系统创建时间
		s:bucreatetime'="" bucreatetime=..ConvertTimeStampToDate(bucreatetime,"time")
		s bucreateuser=DataInfo.%Get("bu_createuser") //系统创建人
		s:bucreateuser'="" bucreateuser=..GetIdByCode(bucreateuser,"User.SSUser")
		s buseqno=DataInfo.%Get("bu_seqno") //系统排序号
		s bulastupdatedate=DataInfo.%Get("bu_lastupdatedate") //系统最后更新日期
		s bulastupdatetime=DataInfo.%Get("bu_lastupdatetime") //系统最后更新时间
		s bulastupdateuser=DataInfo.%Get("bu_lastupdateuser") //系统最后更新人
		s bupycode=DataInfo.%Get("bu_pycode") //拼音码
		s buwbcode=DataInfo.%Get("bu_wbcode") //五笔码
		s bumark=DataInfo.%Get("bu_mark") //备注
		
		s eobj=##class(web.Entity.CT.CTLoc).%New()
        s eobj.CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(bucode),""))
        s eobj.CTLOCCode = bucode         //修改代码
        s eobj.CTLOCDesc = budesc         //修改描述
        
        s eobj.CTLOCDateActiveFrom = bustartdate	//开始日期
        s eobj.CTLOCDateActiveTo = buenddate		//结束日期
        
		s eobj.CTLOCDeptCode = budeptcode	//组织外码-外键
		s eobj.CTLOCDomainCode = budomaincode 	//业务域代码-外键

		s eobj.CTLOCLocation=bulocation		//物理位置
		s eobj.CTLOCActiveFlag=buactivity	//是否有效(Y/N)
		s:bucreatedate'="" eobj.CTLOCCreateDate=bucreatedate
        s:bucreatetime'="" eobj.CTLOCCreateTime=bucreatetime
        s:bucreateuser'="" eobj.CTLOCCreateUser=bucreateuser
        
		s eobj.CTLOCSeqNo=buseqno		//系统排序号
		
		s eobj.CTLOCPYCode=bupycode		//拼音码
		s eobj.CTLOCWBCode=buwbcode		//五笔码
		s eobj.CTLOCMark=bumark		//备注
		
		s resSave=..SaveLoc(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_bucode_""""
			else  s DataRet=DataRet_","_""""_bucode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_bucode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_bucode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   保存业务单元字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  User.CTLoc
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SaveLoc(eobj)
ClassMethod SaveLoc(eobj As web.Entity.CT.CTLoc)
{
	s $zt="ERROE"
    s result = ""
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 
    if $IsObject(eobj)
    {
        s:eobj.CTLOCDateActiveFrom="" eobj.CTLOCDateActiveFrom=+$h
        s:eobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveFrom)  //转换日期
        s:eobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveTo)  //转换日期

        s:eobj.CTLOCLastUpdateDate="" eobj.CTLOCLastUpdateDate=+$h		//系统最后更新日期
	    s:eobj.CTLOCLastUpdateTime="" eobj.CTLOCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
	    s:eobj.CTLOCLastUpdateUser="" eobj.CTLOCLastUpdateUser=UserID	//系统最新更新人
	    s:eobj.CTLOCActiveFlag="" eobj.CTLOCActiveFlag="N"		//是否有效
    
        s flag=##class(web.DHCBL.CT.CTLoc).FormValidate(eobj.CTLOCRowID,eobj.CTLOCCode,eobj.CTLOCDesc,eobj.CTLOCHospitalDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.CTLOCRowID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.CTLoc).%New()
                s:eobj.CTLOCCreateDate="" eobj.CTLOCCreateDate=+$h	//系统创建日期默认当前日期
			    s:eobj.CTLOCCreateTime="" eobj.CTLOCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
			    s:eobj.CTLOCCreateUser="" eobj.CTLOCCreateUser= UserID		//系统创建人默认当前登录人员
			    s obj.CTLOCCreateDate=eobj.CTLOCCreateDate		//系统创建日期
				s obj.CTLOCCreateTime=eobj.CTLOCCreateTime		//系统创建时间
				d obj.CTLOCCreateUserSetObjectId(eobj.CTLOCCreateUser)	//系统创建人
            }
            else
            {
	            
                s obj=##class(User.CTLoc).%OpenId(eobj.CTLOCRowID)
                s bobj=##class(web.Entity.CT.CTLoc).%New()
                s bobj.CTLOCRowID=eobj.CTLOCRowID
                s bobj.CTLOCCode = obj.CTLOCCode          //修改代码
                s bobj.CTLOCDesc = obj.CTLOCDesc          //修改描述
                s bobj.CTLOCAddress = obj.CTLOCAddress.GetAt(1)
                s bobj.CTLOCFloor = obj.CTLOCFloor
                s:obj.CTLOCWardSingleSex'="" bobj.CTLOCWardSingleSex = obj.CTLOCWardSingleSex.%Id()
                s bobj.CTLOCAgeFrom = obj.CTLOCAgeFrom
                s bobj.CTLOCAgeTo = obj.CTLOCAgeTo
                s bobj.CTLOCType = obj.CTLOCType 
                s:obj.CTLOCDepDR'="" bobj.CTLOCDepDR = obj.CTLOCDepDR.%Id()
                s bobj.CTLOCIndex = obj.CTLOCIndex
                s:obj.CTLOCHospitalDR'="" bobj.CTLOCHospitalDR = obj.CTLOCHospitalDR.%Id()
                s:obj.CTLOCDepartmentHeadUserDR'="" bobj.CTLOCDepartmentHeadUserDR = obj.CTLOCDepartmentHeadUserDR.%Id()
                s bobj.CTLOCMedicalRecordActive = obj.CTLOCMedicalRecordActive
                s bobj.CTLOCAllowNoCureLimit = obj.CTLOCAllowNoCureLimit  //
                s bobj.CTLOCBeInHospital = obj.CTLOCBeInHospital
                s bobj.CTLOCExecuteConfirmation = obj.CTLOCExecuteConfirmation
                s bobj.CTLOCDateActiveFrom = obj.CTLOCDateActiveFrom	//开始日期
                s bobj.CTLOCDateActiveTo = obj.CTLOCDateActiveTo		//结束日期
                s bobj.CTLOCContactName = obj.CTLOCContactName  
                s bobj.CTLOCClinicType = obj.CTLOCClinicType
                s:obj.CTLOCBroadPatientGroupDR'="" bobj.CTLOCBroadPatientGroupDR = obj.CTLOCBroadPatientGroupDR.%Id()
                s bobj.CTLOCTelephone = obj.CTLOCTelephone
                s bobj.CTLOCNationCode = obj.CTLOCNationCode
                
                s:obj.CTLOCCategoryDR'="" bobj.CTLOCCategoryDR = obj.CTLOCCategoryDR.%Id()	//upadte2020-1-2 钟荣枫 增加科室科室分类
                
                
                if $IsObject(obj.CTLOCDeptCode){
					s bobj.CTLOCDeptCode = obj.CTLOCDeptCode.%Id() 	//组织外码-外键
				}  
				if $IsObject(obj.CTLOCDomainCode){
					s bobj.CTLOCDomainCode = obj.CTLOCDomainCode.%Id() 	//业务域代码-外键
				}

				s bobj.CTLOCLocation=obj.CTLOCLocation		//物理位置
				s bobj.CTLOCActiveFlag=obj.CTLOCActiveFlag	//是否有效(Y/N)

				s bobj.CTLOCCreateDate=obj.CTLOCCreateDate		//系统创建日期
				s bobj.CTLOCCreateTime=obj.CTLOCCreateTime		//系统创建时间
				if $IsObject(obj.CTLOCCreateUser){
					s bobj.CTLOCCreateUser = obj.CTLOCCreateUser.%Id() 	//系统创建人
				}
				s bobj.CTLOCSeqNo=obj.CTLOCSeqNo		//系统排序号
				s bobj.CTLOCLastUpdateDate=obj.CTLOCLastUpdateDate		//系统最后更新日期
				s bobj.CTLOCLastUpdateTime=obj.CTLOCLastUpdateTime		//系统最后更新时间
				if $IsObject(obj.CTLOCLastUpdateUser){
					s bobj.CTLOCLastUpdateUser = obj.CTLOCLastUpdateUser.%Id() 	//系统最新更新人
				}
				s bobj.CTLOCPYCode=obj.CTLOCPYCode		//拼音码
				s bobj.CTLOCWBCode=obj.CTLOCWBCode		//五笔码
				s bobj.CTLOCMark=obj.CTLOCMark		//备注
				
				s eobj.CTLOCAddress = obj.CTLOCAddress.GetAt(1)
		        s eobj.CTLOCFloor = obj.CTLOCFloor
		        s:obj.CTLOCWardSingleSex'="" eobj.CTLOCWardSingleSex = obj.CTLOCWardSingleSex.%Id()
		        s eobj.CTLOCAgeFrom = obj.CTLOCAgeFrom
		        s eobj.CTLOCAgeTo = obj.CTLOCAgeTo
		        s eobj.CTLOCType = obj.CTLOCType 
		        s:obj.CTLOCDepDR'="" eobj.CTLOCDepDR = obj.CTLOCDepDR.%Id()
		        s eobj.CTLOCIndex = obj.CTLOCIndex
		        s:obj.CTLOCHospitalDR'="" eobj.CTLOCHospitalDR = obj.CTLOCHospitalDR.%Id()
		        s:obj.CTLOCDepartmentHeadUserDR'="" eobj.CTLOCDepartmentHeadUserDR = obj.CTLOCDepartmentHeadUserDR.%Id()
		        s eobj.CTLOCMedicalRecordActive = obj.CTLOCMedicalRecordActive
		        s eobj.CTLOCAllowNoCureLimit = obj.CTLOCAllowNoCureLimit  //
		        s eobj.CTLOCBeInHospital = obj.CTLOCBeInHospital
		        s eobj.CTLOCExecuteConfirmation = obj.CTLOCExecuteConfirmation
		        s eobj.CTLOCContactName = obj.CTLOCContactName  
		        s eobj.CTLOCClinicType = obj.CTLOCClinicType
		        s:obj.CTLOCBroadPatientGroupDR'="" eobj.CTLOCBroadPatientGroupDR = obj.CTLOCBroadPatientGroupDR.%Id()
		        s eobj.CTLOCTelephone = obj.CTLOCTelephone
		        s eobj.CTLOCNationCode = obj.CTLOCNationCode
		        
		        s:obj.CTLOCCategoryDR'="" eobj.CTLOCCategoryDR = obj.CTLOCCategoryDR.%Id()	//upadte2020-1-2 钟荣枫 增加科室科室分类
		        
		        if ((eobj.CTLOCType="W")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="OP"))
		        {
		            if (eobj.CTLOCType'=eobj.CTLOCType)
		            {
		            	s str=##class(web.DHCBL.CT.CTLoc).UpdateCTLOCType(eobj.CTLOCRowID,eobj.CTLOCType)
		            }
		        }
                
            }
            s obj.CTLOCCode = eobj.CTLOCCode          //修改代码
            s obj.CTLOCDesc = eobj.CTLOCDesc          //修改描述
           
            s obj.CTLOCDateActiveFrom = eobj.CTLOCDateActiveFrom
            s obj.CTLOCDateActiveTo = eobj.CTLOCDateActiveTo
            
            
			d obj.CTLOCDeptCodeSetObjectId(eobj.CTLOCDeptCode) 	//组织外码-外键
			 
			d obj.CTLOCDomainCodeSetObjectId(eobj.CTLOCDomainCode) 	//业务域代码-外键

			s obj.CTLOCLocation=eobj.CTLOCLocation		//物理位置
			s obj.CTLOCActiveFlag=eobj.CTLOCActiveFlag	//是否有效(Y/N)

			s obj.CTLOCSeqNo=eobj.CTLOCSeqNo		//系统排序号
			s obj.CTLOCLastUpdateDate=eobj.CTLOCLastUpdateDate		//系统最后更新日期
			s obj.CTLOCLastUpdateTime=eobj.CTLOCLastUpdateTime		//系统最后更新时间
			d obj.CTLOCLastUpdateUserSetObjectId(eobj.CTLOCLastUpdateUser) 	//系统最新更新人
			s:eobj.CTLOCPYCode="" eobj.CTLOCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTLOCDesc)
			s obj.CTLOCPYCode=eobj.CTLOCPYCode		//拼音码
			s:eobj.CTLOCWBCode="" eobj.CTLOCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTLOCDesc,1)
			s obj.CTLOCWBCode=eobj.CTLOCWBCode		//五笔码
			s obj.CTLOCMark=eobj.CTLOCMark		//备注
            
            Ts                              
                 
            s sc = obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
	            tc
	            s id = obj.%Id()
	            s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                s:eobj.CTLOCRowID'="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",eobj.CTLOCRowID,eobj.CTLOCDesc,"U",eobj,bobj)
                s:eobj.CTLOCRowID="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",id,eobj.CTLOCDesc,"A",eobj)
                
            }
            else
            {
                Trollback
                s errorMsg=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                s result = "{success:'false',errorinfo:'"_errorMsg_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.BDP.HOSInterface","SaveLoc",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
            }
        }           
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.BDP.HOSInterface","SaveLoc",eobj)
    s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Function:   同步岗位字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPostDict
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPostDict("")
ClassMethod SyncHOSPostDict(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)
		
		s postccode=DataInfo.%Get("postc_code") //岗位代码
		s postcdesc=DataInfo.%Get("postc_desc") //岗位全称
		s postcshortdesc=DataInfo.%Get("postc_shortdesc") //岗位简称
		s postctype=DataInfo.%Get("postc_type") //岗位类型
		s:postctype'="" postctype=..GetIdByCode(postctype,"CT.BDP.CT.HOSPostType")
		s postcdomaincode=DataInfo.%Get("postc_domaincode") //业务域代码
		s:postcdomaincode'="" postcdomaincode=..GetIdByCode(postcdomaincode,"CT.BDP.CT.HOSBusiDomain")
		s postcposccode=DataInfo.%Get("postc_posccode") //职位字典代码
		s:postcposccode'="" postcposccode=..GetIdByCode(postcposccode,"CT.BDP.CT.HOSPositionDict")
		s postcproftcode=DataInfo.%Get("postc_proftcode") //职务字典代码
		s:postcproftcode'="" postcproftcode=..GetIdByCode(postcproftcode,"CT.BDP.CT.HOSProfTitleDict")
		s postcphwcode=DataInfo.%Get("postc_phwcode") //岗位中心词
		s:postcphwcode'="" postcphwcode=..GetIdByCode(postcphwcode,"CT.BDP.CT.HOSPostHeadWord")
		s postcfhwcode=DataInfo.%Get("postc_fhwcode") //流程中心词
		s:postcfhwcode'="" postcfhwcode=..GetIdByCode(postcfhwcode,"CT.BDP.CT.HOSFlowHeadWord")
		
		s postcactivity=DataInfo.%Get("postc_activity") //是否有效
		s postcactivity=$case(postcactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:postcactivity) //是否有效 true/false
		s postcstartdate=DataInfo.%Get("postc_startdate") //开始日期
		s:postcstartdate'="" postcstartdate=..ConvertTimeStampToDate(postcstartdate)
		s postcenddate=DataInfo.%Get("postc_enddate") //结束日期
		s:postcenddate'="" postcenddate=..ConvertTimeStampToDate(postcenddate)
		s postccreatedate=DataInfo.%Get("postc_createdate") //系统创建日期
		s:postccreatedate'="" postccreatedate=..ConvertTimeStampToDate(postccreatedate)
		s postccreatetime=DataInfo.%Get("postc_createtime") //系统创建时间
		s:postccreatetime'="" postccreatetime=..ConvertTimeStampToDate(postccreatetime,"time")
		s postccreateuser=DataInfo.%Get("postc_createuser") //系统创建人
		s:postccreateuser'="" postccreateuser=..GetIdByCode(postccreateuser,"User.SSUser")
		s postcseqno=DataInfo.%Get("postc_seqno") //系统排序号
		s postclastupdatedate=DataInfo.%Get("postc_lastupdatedate") //系统最后更新日期
		s postclastupdatetime=DataInfo.%Get("postc_lastupdatetime") //系统最后更新时间
		s postclastupdateuser=DataInfo.%Get("postc_lastupdateuser") //系统最后更新人
		s postcpycode=DataInfo.%Get("postc_pycode") //拼音码
		s postcwbcode=DataInfo.%Get("postc_wbcode") //五笔码
		s postcmark=DataInfo.%Get("postc_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSPostDict).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSPostDictI("IndexCode"," "_$zconvert(postccode,"u"),0))
        s eobj.POSTCCode=postccode	//岗位代码
        s eobj.POSTCDesc= postcdesc	//岗位名称
		s eobj.POSTCDomainCode = postcdomaincode	//业务域代码
		s eobj.POSTCPOSCCode = postcposccode	//职位代码
		s eobj.POSTCPROFTCode =postcproftcode	//职务字典代码
		s eobj.POSTCPHWCode = postcphwcode 	//岗位中心词
		s eobj.POSTCFHWCode = postcfhwcode 	//流程中心词
		s eobj.POSTCShortDesc=postcshortdesc	//岗位简称   
		s eobj.POSTCType = postctype 	//岗位类型
		s eobj.POSTCActivity=postcactivity	//是否有效(Y/N)
		s eobj.POSTCStartDate=postcstartdate		//开始日期
		s eobj.POSTCEndDate=postcenddate		//结束日期
		s:postccreatedate'="" eobj.POSTCCreateDate=postccreatedate
        s:postccreatetime'="" eobj.POSTCCreateTime=postccreatetime
        s:postccreateuser'="" eobj.POSTCCreateUser=postccreateuser
        
		s eobj.POSTCSeqNo=postcseqno		//系统排序号
		
		s eobj.POSTCPYCode=postcpycode		//拼音码
		s eobj.POSTCWBCode=postcwbcode		//五笔码
		s eobj.POSTCMark=postcmark		//备注
			
      
		s resSave=##class(web.DHCBL.CT.HOSPostDict).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_postccode_""""
			else  s DataRet=DataRet_","_""""_postccode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_postccode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_postccode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   同步业务岗位字典
/// Creator:    zrf
/// CreateDate: 2023-03-16
/// TableName:  CT.BDP.CT.HOSPost
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncHOSPost("")
ClassMethod SyncHOSPost(ByRef DataList) As web.BDP.sys.String
{
	s result="",msg="",DataRet="",successcode=0,errorlist=""
	s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s:USERID="" USERID=##class(web.DHCBL.BDP.BDPDataChangeLog).AddUser("NoSession")
	;主数据管理平台推送数据获取
	;s DataList=[].%FromJSON(DataStr)
	for di=0:1:(DataList.%Size()-1)
	{
		
		s DataInfo=DataList.%Get(di)

		s postcode=DataInfo.%Get("post_code") //业务岗位代码
		s postdesc=DataInfo.%Get("post_desc") //业务岗位名称
		s postbucode=DataInfo.%Get("post_bucode") //业务单元代码
		s:postbucode'="" postbucode=..GetIdByCode(postbucode,"User.CTLoc")
		s postpostccode=DataInfo.%Get("post_postccode") //岗位字典代码
		s:postpostccode'="" postpostccode=..GetIdByCode(postpostccode,"CT.BDP.CT.HOSPostDict")
		
		s postactivity=DataInfo.%Get("post_activity") //是否有效
		s postactivity=$case(postactivity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:postactivity) //是否有效 true/false
		s poststartdate=DataInfo.%Get("post_startdate") //开始日期
		s:poststartdate'="" poststartdate=..ConvertTimeStampToDate(poststartdate)
		s postenddate=DataInfo.%Get("post_enddate") //结束日期
		s:postenddate'="" postenddate=..ConvertTimeStampToDate(poststartdate)
		s postcreatedate=DataInfo.%Get("post_createdate") //系统创建日期
		s:postcreatedate'="" postcreatedate=..ConvertTimeStampToDate(postcreatedate)
		s postcreatetime=DataInfo.%Get("post_createtime") //系统创建时间
		s:postcreatetime'="" postcreatetime=..ConvertTimeStampToDate(postcreatetime,"time")
		s postcreateuser=DataInfo.%Get("post_createuser") //系统创建人
		s:postcreateuser'="" postcreateuser=..GetIdByCode(postcreateuser,"User.SSUser")
		s postseqno=DataInfo.%Get("post_seqno") //系统排序号
		s postlastupdatedate=DataInfo.%Get("post_lastupdatedate") //系统最后更新日期
		s postlastupdatetime=DataInfo.%Get("post_lastupdatetime") //系统最后更新时间
		s postlastupdateuser=DataInfo.%Get("post_lastupdateuser") //系统最后更新人
		s postpycode=DataInfo.%Get("post_pycode") //拼音码
		s postwbcode=DataInfo.%Get("post_wbcode") //五笔码
		s postmark=DataInfo.%Get("post_mark") //备注
		
		s eobj=##class(web.Entity.CT.HOSPost).%New()
        s eobj.ID=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(postcode,"u"),0))
        s eobj.POSTCode=postcode	//业务岗位代码
        s eobj.POSTDesc= postdesc	//业务岗位名称
		s eobj.POSTBUCode = postbucode 	//业务单元代码-外键
		s eobj.POSTPOSTCCode = postpostccode 	//岗位字典代码-外键
		s eobj.POSTActivity=postactivity	//是否有效(Y/N)
		s eobj.POSTStartDate=poststartdate		//开始日期
		s eobj.POSTEndDate=postenddate		//结束日期
		s:postcreatedate'="" eobj.POSTCreateDate=postcreatedate
        s:postcreatetime'="" eobj.POSTCreateTime=postcreatetime
        s:postcreateuser'="" eobj.POSTCreateUser=postcreateuser
        
		s eobj.POSTSeqNo=postseqno		//系统排序号

		s eobj.POSTPYCode=postpycode		//拼音码
		s eobj.POSTWBCode=postwbcode		//五笔码
		s eobj.POSTMark=postmark		//备注
		
      
		s resSave=##class(web.DHCBL.CT.HOSPost).SaveEntity(eobj)

		if (resSave["true"){
        	s successcode=200		
			if DataRet="" s DataRet=""""_postcode_""""
			else  s DataRet=DataRet_","_""""_postcode_""""
		}
		else
		{
			s resObj=##class(ext.util.JsonObject).FromJSON(resSave)
			s errormsg=$e($p(resSave,"errorinfo",2),3,*-2) //resObj.Get("errorinfo")
			if errorlist="" s errorlist="{""errordataid"":"""_postcode_""",""errormsg"":"""_errormsg_"""}"
			else  s errorlist=errorlist_",{""errordataid"":"""_postcode_""",""errormsg"":"""_errormsg_"""}"
		}	
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s result="{""response"":{""code"":""200"",""msg"":""操作成功"",""errorlist"":["_errorlist_"]}}"	
	}
	else
	{
		s result="{""response"":{""code"":""500"",""msg"":""服务器内部错误"",""errorlist"":["_errorlist_"]}}"
	}
	q result
}

/// Function:   根据编码、表名获取rowid
/// Creator:    gss
/// CreateDate: 2023-02-21
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetIdByCode("唯一标识码","CT.BDP.CT.HOSPerson")
ClassMethod GetIdByCode(code As %String, tablename As %String) As %String
{
	q:((code="")||(tablename="")) ""
	s id=""
	if (tablename="User.CTSex") //性别
	{ 
		s id=$o(^CT("SEX",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTCountry") //国家
	{ 
		s id=$o(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.SSLanguage") //语言
	{ 
		s id=$o(^SS("LAN",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.DHCCredType") //身份证件类型
	{
		s id=$o(^DHCACCCredType(0,"Code",code,0))
	}
	if (tablename="User.CTNation") //民族
	{
		s id=$o(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(code),0))	
	}
	if (tablename="User.CTEducation") //学历 教育水平
	{
		s id=$o(^CT("EDU",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="CT.BDP.CT.HOSDegree") //学位
	{
		s id=$o(^CT.BDP.CT.HOSDegreeI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="User.CTOccupation") //职业
	{
		s id=$o(^CT("OCC",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTMarital") //婚姻状态
	{
		s id=$o(^CT("MAR",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTReligion") //宗教
	{
		s id=$o(^CT("RLG",0,"Code",$$ALPHAUP^SSUTIL4(code),0))	
	}
	if (tablename="User.CTCountry") //国家
	{
		s id=$o(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTProvince") //省
	{
		s id=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTCity") //市
	{
		s id=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.CTCityArea") //县区
	{
		s id=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="CT.BDP.CT.HOSPersonStatusDict") //人员状态
	{
		s id=$o(^CT.BDP.CT.HOSPersonStatusDictI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
	}
	if (tablename="User.SSUser") //用户
	{
		s id=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),0))
	}
	if (tablename="User.SSGroup") //安全组
	{
		s id=$o(^SSU("SSGRP",0,"Code",code,0))
	}
	if (tablename="CT.BDP.CT.HOSOrganization") //组织机构
	{
		s id=$o(^CT.BDP.CT.HOSOrganizationI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPerson") //人员基本信息
	{
		s id=$o(^CT.BDP.CT.HOSPersonI("IndexPersonID"," "_$zconvert(code,"U"),0)) 
	}
	if (tablename="CT.BDP.CT.HOSEmpStatusDict") //人员工作状态
	{
		s id=$o(^CT.BDP.CT.HOSEmpStatusDictI("IndexCode"," "_$ZCONVERT(code,"U"),0))
	}
	if (tablename="CT.BDP.CT.HOSDepartment") //组织部门
	{
		s id=$o(^CT.BDP.CT.HOSDepartmentI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPosition") //职位
	{
		s id=$o(^CT.BDP.CT.HOSPositionI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSProfTitle") //职务
	{
		s id=$o(^CT.BDP.CT.HOSProfTitleI("IndexCode"," "_$ZCONVERT(code,"U"),0))	
	}
	if (tablename="CT.BDP.CT.HOSPost") //岗位
	{
		s id=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(code,"u"),0))	
	}
	if (tablename="CT.BDP.CT.HOSHORGGrade") //医院等级
	{
		s id=$o(^CT.BDP.CT.HOSHORGGradeI("IndexCode"," "_$zconvert(code,"u"),0))
	}

	if (tablename="CT.BDP.CT.HOSOccuCategory") //职业大类字典
	{
		s id=$o(^CT.BDP.CT.HOSOccuCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	}

	if (tablename="CT.BDP.CT.HOSProcPost") //流程岗位字典
	{
		s id=$o(^CT.BDP.CT.HOSProcPostI("IndexCode"," "_$zconvert(code,"u"),0))
	}

	if (tablename="CT.BDP.CT.HOSProcPostRelPost") //流程岗位与业务岗位字典
	{
		s id=$o(^CT.BDP.CT.HOSProcPostRelPostI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPostType") //岗位类型字典
	{
		s id=$o(^CT.BDP.CT.HOSPostTypeI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	
	if (tablename="CT.BDP.CT.HOSPostHeadWord") //岗位中心词
	{
		s id=$o(^CT.BDP.CT.HOSPostHeadWordI("IndexCode"," "_$zconvert(code,"u"),0))
	}

	if (tablename="CT.BDP.CT.HOSFlowHeadWord") //流程中心词
	{
		s id=$o(^CT.BDP.CT.HOSFlowHeadWordI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSOrgCategory") //机构大类
	{
		s id=$o(^CT.BDP.CT.HOSOrgCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSOrgSubCategory") //机构子类
	{
		s id=$o(^CT.BDP.CT.HOSOrgSubCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSOrgMinCategory") //机构小类
	{
		s id=$o(^CT.BDP.CT.HOSOrgMinCategoryI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSOrgAdminType") //组织行政属性字典
	{
		s id=$o(^CT.BDP.CT.HOSOrgAdminTypeI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPositionDict") //职位字典
	{
		s id=$o(^CT.BDP.CT.HOSPositionDictI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSBusiDomain") //业务域
	{
		s id=$o(^CT.BDP.CT.HOSBusiDomainI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="User.CTLoc") //业务域
	{
		s id=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	}
	if (tablename="CT.BDP.CT.HOSPostDict") //岗位字典
	{
		s id=$o(^CT.BDP.CT.HOSPostDictI("IndexCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPostType") //岗位类型
	{
		s id=$o(^CT.BDP.CT.HOSPostDictI("IndexPTCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSProfTitleDict") //职务字典
	{
		s id=$o(^CT.BDP.CT.HOSProfTitleDictI("IndexPROFTCCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSPostHeadWord") //岗位中心词
	{
		s id=$o(^CT.BDP.CT.HOSPostHeadWordI("IndexPHWCode"," "_$zconvert(code,"u"),0))
	}
	if (tablename="CT.BDP.CT.HOSFlowHeadWord") //流程中心词
	{
		s id=$o(^CT.BDP.CT.HOSFlowHeadWordI("IndexFHWCode"," "_$zconvert(code,"u"),0))
	}											
	if (tablename="CT.BDP.CT.HOSProfRank") //职务等级
	{
		s id=$o(^CT.BDP.CT.HOSProfRankI("IndexCode"," "_$zconvert(code,"u"),0))
	}		

	q id
}

/// Function:   主数据管理平台入参日期格式转换
/// Creator:    gss
/// CreateDate: 2023-03-20
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).ConvertTimeStampToDate("702057600000")
ClassMethod ConvertTimeStampToDate(input As %String, type = "") As %String
{
	 set $Ztrap="Exception"
	 q:(input["-")||(input[":")||(input["/")||(input="") input
	 q:(input<0) ""
	 set len = $L(input)
	 set dateStamp = $e(input,1,len-3)
	 ;Quit $ZDT($ZDATETIMEH(dateStamp,-2),3)
	 s date=$p($ZDATETIMEH(dateStamp,-2),",",1)
	 s time=$p($ZDATETIMEH(dateStamp,-2),",",2)
	 
	 if (type="")
	 {
		 Quit date
	 }
	 else
	 {
		 Quit time
	 }
	 
Exception
	 Quit ""
}

/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).Test()
ClassMethod Test(str)
{
	S str=str.%ToJSON()
	s result=..SyncHOSData(str)
	q result
}

/*******************************对接统一用户平台*********************************************************/
/// Function:   同步人员接口 -hos -同步账号
/// Creator:    chenying
/// CreateDate: 2022-10-14
/// TableName:  SS_User  
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncUserData()
ClassMethod SyncUserData(JsonStr As %String) As %String
{
	s operationuser="UnifiedUserPlatform" 
	s results="",msg="",DataRet="",successcode=0
	s SSUSRPassword= ##class(BSP.SYS.BL.SSUser).ToCacheBCrypt("1")  //   给定一个初始密码  1
	s SSUSRPin= ##Class(web.SSUser).Encrypt("1")  //   给定一个初始密码  1
	s JsonInfo=[].%FromJSON(JsonStr)
	s DataList=JsonInfo.%Get("Request").%Get("Data")
	for DataListi=0:1:(DataList.%Size()-1)
	{
		s LastUpdateUser=""
		s:operationuser'="" LastUpdateUser=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByUserCode(operationuser) //SS_Group RowId 更新人rowid	
		
		s DetailInfo=DataList.%Get(DataListi)
		s operation=DetailInfo.%Get("operation")  //操作类型，update新增/修改,delete删除
		s portalid=DetailInfo.%Get("id")  //开放平台主键id
		s loginName=DetailInfo.%Get("loginName") //登录名
		s name=DetailInfo.%Get("name") //账号名称（例：医生01）
		s personId=DetailInfo.%Get("personId") //人员唯一标识码（主数据推送带的唯一值）
		s accountOrgCode=DetailInfo.%Get("accountOrgCode") //行政部门所属机构
		s activity=DetailInfo.%Get("activity") //是否有效 true/false
		s activity=$case(activity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:activity) //是否有效 true/false
		s startDate=DetailInfo.%Get("startDate") //开始日期，格式：yyyy-MM-dd
		s:startDate'="" startDate=$zdh(startDate,3)  //开始日期，格式：yyyy-MM-dd
		s:startDate="" startDate=+$h
		s endDate=DetailInfo.%Get("endDate") //结束日期，格式：yyyy-MM-dd
		s:endDate'="" endDate=$zdh(endDate,3) //结束日期，格式：yyyy-MM-dd
		s pyCode=DetailInfo.%Get("pyCode") //拼音码
		s:pyCode="" pyCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(name) //拼音码
		s wbCode=DetailInfo.%Get("wbCode")  //五笔码
		s:wbCode="" wbCode=##class(web.DHCBL.BDP.FunLib).GetWBCODE(name)  //五笔码
		s mark=DetailInfo.%Get("mark") //备注
		s seqNo=DetailInfo.%Get("seqNo") //排序值
		s password=DetailInfo.%Get("password") //密码 加密后
		s mobile=DetailInfo.%Get("mobile") //手机号
		s gender=DetailInfo.%Get("gender") //性别
		s identityId=DetailInfo.%Get("identityId") //身份证号
		s mail=DetailInfo.%Get("mail") //邮箱
		s title=DetailInfo.%Get("title") //职称
		s personStatus=DetailInfo.%Get("personStatus") //人员状态
		
		if operation=""  //操作类型
		{
			s info="操作类型operation为空"
			continue
		}
		if portalid=""  //开放平台主键id
		{
			s info="开放平台主键id为空"
			continue
		}
		if loginName=""  //登录名
		{
			s info="登录名loginName不能为空"
			continue
		}
		
		s SSUSRRowId=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByUserCode(loginName) //SS_USER RowId
		if (SSUSRRowId'=""){
			s successcode=200	
			s msg="此账号已存在"
			if DataRet="" s DataRet=""""_portalid_""""
			else  s DataRet=DataRet_","_""""_portalid_""""
			//continue
		}
		if operation="update" //操作类型
		{
			if name="" //账号名称（例：医生01）
			{
				s info="账号名称name为空"
				continue
			}
			s SSUSRHOSPersonDR=""
			if (personId'="")  //人员唯一标识码
			{
				s SSUSRHOSPersonDR=$o(^CT.BDP.CT.HOSPersonI("IndexPersonID"," "_$zcvt(personId,"U"),0))
				if SSUSRHOSPersonDR=""
				{
					s info="人员唯一标识码在his里没找到对应数据"_personId
					//continue
				}
			}
			else
			{
				s info="人员唯一标识码personId不能为空"
				//continue
			}
			
			s SSUSRFreeText2=""
			if (gender'=""){
				s SSUSRFreeText2=$o(^CT("SEX",0,"Desc",gender,0))
				if SSUSRFreeText2=""
				{
					s info="性别在his里没找到对应数据"_gender
					//continue
				}
			}
			s SSUSRFreeText1=identityId
			/*s SSUSRFreeText1=""
			if (##class(web.DHCBL.BDP.FunLib).IsValidIdNum(identityId)){
				s SSUSRFreeText1=identityId
			}else{
				s info="身份证号格式不正确"_identityId
				//continue
			}*/
			
			s deptList=DetailInfo.%Get("deptList") //部门岗职角色信息列表(全量数据)	
			continue:(deptList="")
			k LogonArray
			k CarPrvTpArr
			//处理默认登录科室安全组、其他登录科室安全组
			s rolenum=0
			for depti=0:1:(deptList.%Size()-1)
			{
				s deptInfo=deptList.%Get(depti)
				s postList=deptInfo.%Get("postList") //业务岗位对象集合
				continue:(postList="")
				for posti=0:1:(postList.%Size()-1){
					s postInfo=postList.%Get(posti) 
					s postCode=postInfo.%Get("postCode") //业务岗位编码
					s PostDR=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zconvert(postCode,"u"),0)) //业务岗位
					s:PostDR'="" PostArray(PostDR)=""
					/*if (PostDR'="")
					{
						s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(PostDR)),3)
						if POSTDesc["医师"{ s CarPrvTpArr("主任医师")="" }
						elseif POSTDesc["护士" { s CarPrvTpArr("主任护师")="" }
						elseif POSTDesc["药师" { s CarPrvTpArr("主任药师")="" }
					} */
					
					s buCode=postInfo.%Get("buCode") //业务单元编码
					s DeptDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(buCode),0))
					if DeptDR=""
					{
						s info="业务单元在his里没找到对应数据"_buCode
					}
					s:DeptDR'="" HospitalDR=$p($g(^CTLOC(DeptDR)),"^",22)     //医院
					s:DeptDR="" HospitalDR=""
					continue:((DeptDR="")||(HospitalDR="")) //过滤空值
					s roleList=postInfo.%Get("roleCodes") //岗位绑定角色编码集合
					continue:(roleList="")
					for rolei=0:1:(roleList.%Size()-1){
						s roleCode=roleList.%Get(rolei) //角色编码
						s GroupDR=$o(^SSU("SSGRP",0,"Code",roleCode,0))
						if GroupDR=""
						{
							 s info="角色在his里没找到对应数据"_roleCode
						}
						continue:(GroupDR="") //过滤空值
						continue:$d(LogonArray(HospitalDR_"^"_DeptDR_"^"_GroupDR)) //去重
					
						s LogonArray(HospitalDR_"^"_DeptDR_"^"_GroupDR)=""
						s postRoleBuArray(rolenum)=HospitalDR_"^"_DeptDR_"^"_GroupDR
						s rolenum=rolenum+1	
					}
				}
			}
			
			
			if ((SSUSRRowId=""))
			{
				s SSUSRHospitalDR=$p($g(postRoleBuArray(0)),"^",1)  //医院
				s SSUSRDefaultDeptDR=$p($g(postRoleBuArray(0)),"^",2)  //科室
				s SSUSRGroup=$p($g(postRoleBuArray(0)),"^",3)  //安全组
			}
			if (SSUSRRowId'="")
			{
				s oldSSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
				s oldSSUSRGroup=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",5)  //安全组DR
				s oldSSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
				
				if ($d(LogonArray(oldSSUSRHospitalDR_"^"_oldSSUSRDefaultDeptDR_"^"_oldSSUSRGroup))>0)||($g(postRoleBuArray(0))="")
				{
					//如果默认登陆科室数据在全量里还存在，或新数据未取到默认登录科室，则不修改
					s SSUSRHospitalDR=oldSSUSRHospitalDR  //医院
					s SSUSRDefaultDeptDR=oldSSUSRDefaultDeptDR  //科室
					s SSUSRGroup=oldSSUSRGroup //安全组
				}
				else
				{
					s SSUSRHospitalDR=$p($g(postRoleBuArray(0)),"^",1)  //医院
					s SSUSRDefaultDeptDR=$p($g(postRoleBuArray(0)),"^",2)  //科室
					s SSUSRGroup=$p($g(postRoleBuArray(0)),"^",3)  //安全组
				}
			}
			
			//新增医护人员
			/*s CareProvDR="",CTCPTDesc="",CTPCPCarPrvTpDR=""
			if $d(CarPrvTpArr("主任医师")){s CTCPTDesc="主任医师"}
			elseif $d(CarPrvTpArr("主任护师")){s CTCPTDesc="主任护师"}
			elseif $d(CarPrvTpArr("主任药师")){s CTCPTDesc="主任药师"}
			s:CTCPTDesc'="" CTPCPCarPrvTpDR=$o(^CT("CPT",0,"Desc",CTCPTDesc,0))
			if (CTPCPCarPrvTpDR'=""){
				s CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(loginName),0))
				s CareProveobj=##class(web.Entity.CT.CTCareProv).%New()
				s CareProveobj.CTPCPCode=loginName
				s CareProveobj.CTPCPDesc=name
				s CareProveobj.CTPCPOtherName=pyCode
				s CareProveobj.CTPCPCarPrvTpDR=CTPCPCarPrvTpDR
				s CareProveobj.CTPCPActiveFlag =activity  //是否有效
				s CareProveobj.CTPCPDateActiveFrom = startDate  //开始日期
				s CareProveobj.CTPCPDateActiveTo = endDate  //结束日期
				s CareProveobj.CTPCPUpdateDate = $p($h,",",1)
				s CareProveobj.CTPCPUpdateTime = $p($h,",",2)
				s CareProveobj.CTPCPUpdateUserDR =LastUpdateUser
				if (CTPCPRowId1="")
				{	
					s CareProvobj=##class(User.CTCareProv).%New()
					s CareProvobj.CTPCPCode = CareProveobj.CTPCPCode
					s CareProvobj.CTPCPDesc = CareProveobj.CTPCPDesc
					s CareProvobj.CTPCPOtherName = CareProveobj.CTPCPOtherName
					d CareProvobj.CTPCPCarPrvTpDRSetObjectId(CareProveobj.CTPCPCarPrvTpDR)
					s CareProvobj.CTPCPActiveFlag =CareProveobj.CTPCPActiveFlag
					s CareProvobj.CTPCPDateActiveFrom = CareProveobj.CTPCPDateActiveFrom
					s CareProvobj.CTPCPDateActiveTo = CareProveobj.CTPCPDateActiveTo
					s CareProvobj.CTPCPUpdateDate = CareProveobj.CTPCPUpdateDate
					s CareProvobj.CTPCPUpdateTime = CareProveobj.CTPCPUpdateTime
					d CareProvobj.CTPCPUpdateUserDRSetObjectId(CareProveobj.CTPCPUpdateUserDR)
					s CareProvsc=CareProvobj.%Save()
					d CareProvobj.%Close()
					If $$$ISOK(CareProvsc){
				
						s CareProvDR = CareProvobj.%Id()
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",CareProvDR,CareProveobj.CTPCPDesc,"A",CareProveobj,"",CareProvDR)
						if (SSUSRHospitalDR'="")
						{
							s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
							s hospeobj.HOSPRowId=""
							s hospeobj.HOSPHospitalDR=SSUSRHospitalDR
							s hospeobj.HOSPParRef=CareProvDR
							d ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
						}
						if (SSUSRDefaultDeptDR'="")
						{
							d ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(CareProvDR,SSUSRDefaultDeptDR,"Add",CareProveobj.CTPCPDateActiveFrom,CareProveobj.CTPCPDateActiveTo)	
						}
						if ((CTCPTDesc="主任医师")||(CTCPTDesc="主任护师")) {
							d ..CheckAllCareSelect(CareProvDR)	
						}
					}
				}
			}
			*/
			
			s eobj=##class(web.Entity.CT.SSUser).%New()  
		    s eobj.SSUSRRowId=SSUSRRowId
		    s eobj.SSUSRInitials = loginName //工号
			s eobj.SSUSRName = name    //姓名
			s eobj.SSUSRHOSPersonDR=SSUSRHOSPersonDR  // 人员唯一标识码 -人员基本信息表
			s eobj.SSUSRActive =activity  //是否有效
			s eobj.SSUSRDateFrom = startDate  //开始日期
			s eobj.SSUSRDateTo = endDate  //结束日期
			if (SSUSRRowId="")  //新增
		    {
		        s eobj.SSUSRCreatedByDR= LastUpdateUser //系统创建人
				s eobj.SSUSRCreatedDate= $p($h,",",1)    //系统创建日期
				s eobj.SSUSRCreatedTime=$p($h,",",2)     //系统创建时间
		    }
			s eobj.SSUSRSeqNo= seqNo    //顺序号
			s eobj.SSUSRLastUpdateUserDR=LastUpdateUser  //最后更新人
			s eobj.SSUSRLastUpdateDate= $p($h,",",1)    //最后更新日期
			s eobj.SSUSRLastUpdateTime=$p($h,",",2)     //最后更新时间
			s eobj.SSUSRPYCode= pyCode    //拼音码
			s eobj.SSUSRWBCode= wbCode    //五笔码
			s eobj.SSUSRMark= mark    //备注
			s eobj.SSUSRPassword=password //密码 加密后
			s:eobj.SSUSRPassword="" eobj.SSUSRPassword= SSUSRPassword
			s eobj.SSUSRPin=SSUSRPin
			s eobj.SSUSRMobile=mobile //手机号
			s eobj.SSUSRFreeText2=SSUSRFreeText2 //性别
			s eobj.SSUSRFreeText1=SSUSRFreeText1 //身份证号
			s eobj.SSUSREmail=mail //邮箱
			s eobj.SSUSRDefaultDeptDR=SSUSRDefaultDeptDR  //默认的登录科室
			s eobj.SSUSRGroup=SSUSRGroup /// 默认安全组   //安全组必填要去掉！！
			s eobj.SSUSRHospitalDR=SSUSRHospitalDR   //医院关联
			//s eobj.SSUSRCareProvDR=CareProvDR //医护人员关联
			if (SSUSRRowId="")  //新增
		    {
		        s obj=##class(User.SSUser).%New()
		    }
		    else  //修改
		    {
		        s obj=##class(User.SSUser).%OpenId(SSUSRRowId)
		        s bobj=##class(web.Entity.CT.SSUser).%New()  
			    s bobj.SSUSRRowId=SSUSRRowId
			    s bobj.SSUSRInitials = obj.SSUSRInitials //工号
				s bobj.SSUSRName = obj.SSUSRName     //姓名
				s:obj.SSUSRHOSPersonDR'="" bobj.SSUSRHOSPersonDR = obj.SSUSRHOSPersonDR.%Id() // 人员唯一标识码 -人员基本信息表
				s bobj.SSUSRActive =obj.SSUSRActive  //是否有效
				s bobj.SSUSRDateFrom = obj.SSUSRDateFrom  //开始日期
				s bobj.SSUSRDateTo = obj.SSUSRDateTo  //结束日期
				s:obj.SSUSRDefaultDeptDR'="" bobj.SSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id() //默认的登录科室
				s:obj.SSUSRGroup'="" bobj.SSUSRGroup = obj.SSUSRGroup.%Id()	  /// 默认安全组
				s:obj.SSUSRHospitalDR'="" bobj.SSUSRHospitalDR = obj.SSUSRHospitalDR.%Id()   //医院关联
				//s:obj.SSUSRCareProvDR'="" bobj.SSUSRCareProvDR = obj.SSUSRCareProvDR.%Id()   //医护人员关联
				s:obj.SSUSRCreatedByDR'="" bobj.SSUSRCreatedByDR = obj.SSUSRCreatedByDR.%Id() // 系统创建人
				s bobj.SSUSRCreatedDate =obj.SSUSRCreatedDate  //系统创建日期
				s bobj.SSUSRCreatedTime = obj.SSUSRCreatedTime  //系统创建时间
				s bobj.SSUSRSeqNo= obj.SSUSRSeqNo    //顺序号
				s:obj.SSUSRLastUpdateUserDR'="" bobj.SSUSRLastUpdateUserDR = obj.SSUSRLastUpdateUserDR.%Id() // 最后更新人
				s bobj.SSUSRLastUpdateDate =obj.SSUSRLastUpdateDate  //最后更新日期
				s bobj.SSUSRLastUpdateTime = obj.SSUSRLastUpdateTime  //最后更新时间
				s bobj.SSUSRPYCode= obj.SSUSRPYCode    //拼音码
				s bobj.SSUSRWBCode= obj.SSUSRWBCode    //五笔码
				s bobj.SSUSRMark= obj.SSUSRMark    //备注
				s bobj.SSUSRPassword=obj.SSUSRPassword //密码 加密后
				s bobj.SSUSRMobile=obj.SSUSRMobile //手机号
				s bobj.SSUSRFreeText2=obj.SSUSRFreeText2 //性别
				s bobj.SSUSRFreeText1=obj.SSUSRFreeText1 //身份证号
				s bobj.SSUSREmail=obj.SSUSREmail //邮箱	
		    } 
		    //保存用户
			s obj.SSUSRInitials = eobj.SSUSRInitials //工号
			s obj.SSUSRName = eobj.SSUSRName    //姓名
			d obj.SSUSRHOSPersonDRSetObjectId(eobj.SSUSRHOSPersonDR)  // 人员唯一标识码 -人员基本信息表
			s obj.SSUSRActive =eobj.SSUSRActive  //是否有效
			s obj.SSUSRDateFrom = eobj.SSUSRDateFrom  //开始日期
			s obj.SSUSRDateTo = eobj.SSUSRDateTo  //结束日期
			d obj.SSUSRCreatedByDRSetObjectId(eobj.SSUSRCreatedByDR)  //系统更新人
			s obj.SSUSRCreatedDate= eobj.SSUSRCreatedDate    //系统创建日期
			s obj.SSUSRCreatedTime= eobj.SSUSRCreatedTime     ////系统创建时间
			s obj.SSUSRSeqNo= eobj.SSUSRSeqNo    //顺序号
			d obj.SSUSRLastUpdateUserDRSetObjectId(eobj.SSUSRLastUpdateUserDR)  //最后更新人
			s obj.SSUSRLastUpdateDate= eobj.SSUSRLastUpdateDate    //最后更新日期
			s obj.SSUSRLastUpdateTime=eobj.SSUSRLastUpdateTime     //最后更新时间
			s obj.SSUSRPYCode= eobj.SSUSRPYCode    //拼音码
			s obj.SSUSRWBCode= eobj.SSUSRWBCode    //五笔码
			s obj.SSUSRMark= eobj.SSUSRMark    //备注
			s obj.SSUSRPassword=eobj.SSUSRPassword //密码 加密后
			s obj.SSUSRMobile=eobj.SSUSRMobile //手机号
			s obj.SSUSRFreeText2=eobj.SSUSRFreeText2 //性别
			s obj.SSUSRFreeText1=eobj.SSUSRFreeText1 //身份证号
			s obj.SSUSREmail=eobj.SSUSREmail //邮箱
			d obj.SSUSRDefaultDeptDRSetObjectId(SSUSRDefaultDeptDR)  //默认的登录科室
			d obj.SSUSRGroupSetObjectId(SSUSRGroup) /// 默认安全组   //安全组必填要去掉！！
			d obj.SSUSRHospitalDRSetObjectId(SSUSRHospitalDR)   //医院关联
			//d obj.SSUSRCareProvDRSetObjectId(eobj.SSUSRCareProvDR)   //医护人员关联
			
			if (SSUSRRowId="")
			{
				s obj.SSUSRPin= eobj.SSUSRPin 
				s obj.SSUSRChangeLocation = "Y"	//默认新增用户 允许更改登录科室 
			}
			TSTART
			s sc=obj.%Save()
			if ($$$ISOK(sc))
			{
				TCOMMIT
				d obj.%Close()
				s SSUserID=obj.%Id()
				s elogJson=eobj.JsonS()
				if (SSUSRRowId'="")
				{
					s blogJson=bobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",SSUserID,name,"U",elogJson,blogJson,LastUpdateUser)					
				}
				else
				{
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",SSUserID,name,"A",elogJson,"",LastUpdateUser)
				}

				if ((SSUSRRowId=""))
				{
					//新增其他登录科室
					s arrayi=0
					for
					{
						s arrayi=$o(postRoleBuArray(arrayi)) q:arrayi=""
						s olleobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
						s olleobj.OTHLLParRef=SSUserID
						s olleobj.OTHLLStartDate=+$h
						s olleobj.OTHLLEndDate=""
						s olleobj.OTHLLCTLOCDR=$p($g(postRoleBuArray(arrayi)),"^",2)  //科室
						s olleobj.OTHLLHospitalDR=$p($g(postRoleBuArray(arrayi)),"^",1)  //医院
						s olleobj.OTHLLUserGroupDR=$p($g(postRoleBuArray(arrayi)),"^",3)  //安全组
						d ##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveData(olleobj)					
					}
					
					//新增系统账户岗位
					s postnum=0
					s PostDR=""
					for{
						s PostDR=$o(PostArray(PostDR)) q:PostDR=""
						s uposteobj=##class(web.Entity.CT.HOSUserAccountPost).%New()
						s uposteobj.USERPOSTParRef=SSUserID
						s uposteobj.USERPOSTPostCode=PostDR
						s uposteobj.USERPOSTActivity="Y"
						s uposteobj.USERPOSTStartDate=+$h
						s uposteobj.USERPOSTEndDate=""
						if (postnum=0) s uposteobj.USERPOSTDefault="Y" //默认岗位
						else  s uposteobj.USERPOSTDefault=""
						s postnum=postnum+1
						
						d ##class(web.DHCBL.CT.HOSUserAccountPost).SaveEntity(uposteobj)
					}
					
				}
				if (SSUSRRowId'="")
				{
					//判断其他登录科室表数据在全量数据里是否还存在，不存在则删除。
					k ExistLogonArray
					s ChildSub =0
					for 
					{
						s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)) q:ChildSub=""  
						s OTHLLRowId=SSUSRRowId_"||"_ChildSub
						s OTHLLHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",3)
						s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",1)
						s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",2)
						s OTHLLHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",3)
						s OTHLLStartDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",4)
						s OTHLLEndDate=$p($g(^SSU("SSUSR",SSUSRRowId,"OTHLL",ChildSub)),"^",5)
						continue:(OTHLLEndDate'="")&&(OTHLLEndDate<+$H)  //过滤无效数据
						if $d(LogonArray(OTHLLHospitalDR_"^"_OTHLLCTLOCDR_"^"_OTHLLUserGroupDR))>0
						{
							//如果其他登陆科室数据在全量里还存在，则不修改
							s LogonArray(OTHLLHospitalDR_"^"_OTHLLCTLOCDR_"^"_OTHLLUserGroupDR)=OTHLLRowId
						}
						else
						{
							//加结束日期
							s othllobj=##class(User.SSUserOtherLogonLoc).%OpenId(OTHLLRowId)
							s othllobj.OTHLLEndDate = +$h
							s sc=othllobj.%Save()
							d othllobj.%Close()
						}
						s ExistLogonArray(OTHLLHospitalDR_"^"_OTHLLCTLOCDR_"^"_OTHLLUserGroupDR)=OTHLLRowId
					}
					
					//新增其他登录科室
					s arrayi=0
					for
					{
						s arrayi=$o(postRoleBuArray(arrayi)) q:arrayi=""
						s olleobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
						s OTHLLCTLOCDR=$p($g(postRoleBuArray(arrayi)),"^",2)  //科室
						s OTHLLHospitalDR=$p($g(postRoleBuArray(arrayi)),"^",1)  //医院
						s OTHLLUserGroupDR=$p($g(postRoleBuArray(arrayi)),"^",3)  //安全组
						
						if $d(ExistLogonArray(OTHLLHospitalDR_"^"_OTHLLCTLOCDR_"^"_OTHLLUserGroupDR))>0
						{
							//如果其他登陆科室数据已经存在，则不新增
							continue
						}
						else
						{
							//如果其他登陆科室数据不存在，则新增
							s olleobj.OTHLLParRef=SSUserID
							s olleobj.OTHLLStartDate=+$h
							s olleobj.OTHLLEndDate=""
							s olleobj.OTHLLCTLOCDR=OTHLLCTLOCDR  //科室
							s olleobj.OTHLLHospitalDR=OTHLLHospitalDR  //医院
							s olleobj.OTHLLUserGroupDR=OTHLLUserGroupDR //安全组
							d ##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveData(olleobj)
						}
					}
					
					
					//判断系统账户岗位数据在全量数据里是否还存在，不存在则删除。
					k ExistPostArray
					s Sub=0
			        for 
			        {
			            s Sub=$o(^SSU("SSUSR",SSUSRRowId,"USERPOST",Sub))
			            q:Sub="" 
			            s USERPOSTRowId=SSUSRRowId_"||"_Sub
				        s USERPOSTPostCode =$p($g(^SSU("SSUSR",SSUSRRowId,"USERPOST",Sub)),"^",1) /// 岗位字典-外键
				        s USERPOSTActivity =$p($g(^SSU("SSUSR",SSUSRRowId,"USERPOST",Sub)),"^",2) /// 是否有效(Y/N)
				        s USERPOSTStartDate =$p($g(^SSU("SSUSR",SSUSRRowId,"USERPOST",Sub)),"^",3) /// 开始日期
				        s USERPOSTEndDate =$p($g(^SSU("SSUSR",SSUSRRowId,"USERPOST",Sub)),"^",4) /// 结束日期
			        	continue:((USERPOSTEndDate'="")&&(USERPOSTEndDate<+$H))||(USERPOSTActivity="N")   //过滤无效数据
						if $d(PostArray(USERPOSTPostCode))>0
						{
							//如果系统账户岗位数据在全量里还存在，则不修改
							s PostArray(USERPOSTPostCode)=USERPOSTRowId
						}
						else
						{
							d ##class(web.DHCBL.CT.HOSUserAccountPost).DeleteData(USERPOSTRowId)
						}
						s ExistPostArray(USERPOSTPostCode)=USERPOSTRowId
					}
					//新增系统账户岗位
					s PostDR=0
					for
					{
						s PostDR=$o(PostArray(PostDR)) q:PostDR=""
						continue:$d(ExistPostArray(PostDR))
						s uposteobj=##class(web.Entity.CT.HOSUserAccountPost).%New()
						s uposteobj.USERPOSTParRef=SSUserID
						s uposteobj.USERPOSTPostCode=PostDR
						s uposteobj.USERPOSTActivity="Y"
						s uposteobj.USERPOSTStartDate=+$h
						s uposteobj.USERPOSTEndDate=""
						s uposteobj.USERPOSTDefault=""
						d ##class(web.DHCBL.CT.HOSUserAccountPost).SaveEntity(uposteobj)
					}
					//设置默认岗位
					if '$d(^SSU("SSUSR",SSUSRRowId,"USERPOST",0,"Default","Y")){
						s SubId=$o(^SSU("SSUSR",SSUSRRowId,"USERPOST",0,"Default","N",""))
						s:SubId="" SubId=$o(^SSU("SSUSR",SSUSRRowId,"USERPOST",0,"Default",-100000000000000,""))
						s:SubId'="" $p(^SSU("SSUSR",SSUSRRowId,"USERPOST",SubId),"^",15)="Y"	
					}
				}

				s successcode=200		
				s msg="数据保存成功"
				if DataRet="" s DataRet=""""_portalid_""""
				else  s DataRet=DataRet_","_""""_portalid_""""
			}
			else
			{
				TROLLBACK
				d obj.%Close()
				s info= "数据保存失败:"_$system.OBJ.DisplayError(sc)  //$SYSTEM.Status.GetErrorText(sc)
			}
		}
		elseif (operation="delete") /// 删除 ->在his里停用数据
		{
			if (SSUSRRowId'="")   //停用数据
			{
				s obj = ##class(User.SSUser).%OpenId(SSUSRRowId)
				//新数据
				s eobj = ##class(web.Entity.CT.SSUser).%New()
				s eobj.SSUSRRowId=SSUSRRowId
				s eobj.SSUSRInitials=obj.SSUSRInitials
				s eobj.SSUSRName=obj.SSUSRName
				s eobj.SSUSRDateTo=+$h-1
				s eobj.SSUSRActive="N"
				s eobj.SSUSRLastUpdateUserDR=LastUpdateUser  //最后更新人
				s eobj.SSUSRLastUpdateDate= $p($h,",",1)    //最后更新日期
				s eobj.SSUSRLastUpdateTime=$p($h,",",2)     //最后更新时间
				
				//旧数据
				s pobj = ##class(web.Entity.CT.SSUser).%New()
				s pobj.SSUSRRowId=SSUSRRowId
				s pobj.SSUSRInitials=obj.SSUSRInitials
				s pobj.SSUSRName=obj.SSUSRName
				s pobj.SSUSRDateTo=obj.SSUSRDateTo
				s pobj.SSUSRActive=obj.SSUSRActive
				s:obj.SSUSRCreatedByDR'="" pobj.SSUSRCreatedByDR = obj.SSUSRCreatedByDR.%Id() // 系统创建人
				s pobj.SSUSRCreatedDate =obj.SSUSRCreatedDate  //系统创建日期
				s pobj.SSUSRCreatedTime = obj.SSUSRCreatedTime  //系统创建时间
				s:obj.SSUSRLastUpdateUserDR'="" pobj.SSUSRLastUpdateUserDR = obj.SSUSRLastUpdateUserDR.%Id() // 最后更新人
				s pobj.SSUSRLastUpdateDate =obj.SSUSRLastUpdateDate  //最后更新日期
				s pobj.SSUSRLastUpdateTime = obj.SSUSRLastUpdateTime  //最后更新时间
				
				//保存数据
				s obj.SSUSRDateTo=eobj.SSUSRDateTo
				s obj.SSUSRActive=eobj.SSUSRActive
				d obj.SSUSRLastUpdateUserDRSetObjectId(eobj.SSUSRLastUpdateUserDR)  //最后更新人
				s obj.SSUSRLastUpdateDate= eobj.SSUSRLastUpdateDate    //最后更新日期
				s obj.SSUSRLastUpdateTime=eobj.SSUSRLastUpdateTime     //最后更新时间
				TS
				s sc=obj.%Save()
				if (sc=1)
				{
					TC
					d obj.%Close()
					s elogJson=eobj.JsonS()
					s plogJson=pobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",SSUSRRowId,eobj.SSUSRName,"U",elogJson,plogJson,LastUpdateUser)
					
					
					//如果关联了医护人员，同时停用医护人员
					s CTPCPRowId=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)
					if CTPCPRowId=""
					{
						s successcode=200		
						s msg="数据保存成功"
						if DataRet="" s DataRet=""""_portalid_""""
						else  s DataRet=DataRet_","_""""_portalid_""""
					}
					else
					{
						s obj = ##class(User.CTCareProv).%OpenId(CTPCPRowId)
						//新数据
						s eobj = ##class(web.Entity.CT.CTCareProv).%New()
						s eobj.CTPCPRowId1=CTPCPRowId
						s eobj.CTPCPCode=obj.CTPCPCode
						s eobj.CTPCPDesc=obj.CTPCPDesc
						s eobj.CTPCPDateActiveTo=+$h
						s eobj.CTPCPActiveFlag="N"
						
						//旧数据
						s pobj = ##class(web.Entity.CT.CTCareProv).%New()
						s pobj.CTPCPRowId1=CTPCPRowId
						s pobj.CTPCPCode=obj.CTPCPCode
						s pobj.CTPCPDesc=obj.CTPCPDesc
						s pobj.CTPCPDateActiveTo=obj.CTPCPDateActiveTo
						s pobj.CTPCPActiveFlag=obj.CTPCPActiveFlag
						
						//保存数据
						s obj.CTPCPDateActiveTo=eobj.CTPCPDateActiveTo
						s obj.CTPCPActiveFlag=eobj.CTPCPActiveFlag
						TS
						s sc=obj.%Save()
						d obj.%Close()
						if (sc=1)
						{
							TC
							s elogJson=eobj.JsonS()
							s plogJson=pobj.JsonS()
							d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",CTPCPRowId,eobj.CTPCPDesc,"U",elogJson,plogJson,LastUpdateUser)					
							
							s successcode=200		
							s msg="数据操作成功"
							if DataRet="" s DataRet=""""_portalid_""""
							else  s DataRet=DataRet_","_""""_portalid_""""
						}
						else
						{
							TROLLBACK
							d obj.%Close()
							s info= "医护人员数据操作失败:"_$system.OBJ.DisplayError(sc)
						}
					}
				}
				else
				{
					TROLLBACK
					d obj.%Close()
					s info= "数据操作失败:"_$system.OBJ.DisplayError(sc)
				}
			}
			else
			{
				s info= "数据不存在"
			}
		}
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s results="{""code"":""200"",""msg"":""success"",""data"":["_DataRet_"]}"	
	}
	else
	{
		s results="{""code"":""999999"",""msg"":""处理失败"",""data"":null}"
	}
	q results
}

/// 勾选某个医护人员的所有处方权、管制药品分类权限
/// likefan	2023-03-30
/// careid -医护人员rowid
/// d ##class(web.DHCBL.CT.CTCareProvPrescriptSet).CheckAllCareSelect("1")
ClassMethod CheckAllCareSelect(careid As %String) As %String
{
	q:careid="" ""
	
	//循环处方权字典
	s PSRowId=0
	for
	{
		s PSRowId=$o(^DHCPRESCRIPTSET(PSRowId)) q:PSRowId=""
		s PSDesc=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",2)
		s PSActive=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",5)	//是否有效
		continue:PSActive="N"
		d ##class(web.DHCBL.CT.CTCareProvPrescriptSet).UpdatePrescriptSet(careid,PSRowId_"$Y")
	}
	//循环管制药品分类权限字典
	s PHCPORowId=0
	for
	{
		s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""
		s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
		s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
		
		//过滤部分选项，与前台界面保持一致
		continue:(PHCPODesc["抗菌")
		continue:(PHCPODesc["辅助用药")
		continue:(PHCPOCode="ATD1")||(PHCPOCode="ATD2")
		
		d ##class(web.DHCBL.CT.CTCareProvPHCPoison).UpdatePoison(careid,PHCPORowId_"$Y")
	}
	q "1"
}

/// Function:   同步角色接口 -hos -同步账号
/// Creator:    chenying
/// CreateDate: 2022-10-15
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncGroupData()
ClassMethod SyncGroupData(JsonStr As %String) As %String
{
	s operationuser="UnifiedUserPlatform" 
	s results="",msg="",DataRet="",successcode=0
	s JsonInfo=[].%FromJSON(JsonStr)
	s DataList=JsonInfo.%Get("Request").%Get("Data")
	for DataListi=0:1:(DataList.%Size()-1)
	{
		s LastUpdateUser=""
		s:operationuser'="" LastUpdateUser=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByUserCode(operationuser) //SS_Group RowId 更新人rowid		
		s DetailInfo=DataList.%Get(DataListi)	
		s operation=DetailInfo.%Get("operation")  //操作类型，update新增/修改,delete删除
		s portalid=DetailInfo.%Get("id")  //开放平台主键id
		s code=DetailInfo.%Get("code") //角色编码
		s name=DetailInfo.%Get("name") //角色名称
		s parentCode=DetailInfo.%Get("parentCode") //父角色编码
		s activity=DetailInfo.%Get("activity") //是否有效 true/false
		s activity=$case(activity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:activity) //是否有效 true/false
		s startDate=DetailInfo.%Get("startDate") //开始日期，格式：yyyy-MM-dd
		s:startDate'="" startDate=$zdh(startDate,3)  //开始日期，格式：yyyy-MM-dd
		s:startDate="" startDate=+$h
		s endDate=DetailInfo.%Get("endDate") //结束日期，格式：yyyy-MM-dd
		s:endDate'="" endDate=$zdh(endDate,3) //结束日期，格式：yyyy-MM-dd
		s pyCode=DetailInfo.%Get("pyCode") //拼音码
		s:pyCode="" pyCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(pyCode) //拼音码
		s wbCode=DetailInfo.%Get("wbCode")  //五笔码
		s:wbCode="" wbCode=##class(web.DHCBL.BDP.FunLib).GetWBCODE(wbCode)  //五笔码
		s mark=DetailInfo.%Get("mark") //备注
		s seqNo=DetailInfo.%Get("seqNo") //排序值
		s orgCode=DetailInfo.%Get("orgCode") //机构编码-医院
			
		if operation=""  //操作类型
		{
			s info="操作类型operation为空"
			continue
		}
		if portalid=""  //开放平台主键id
		{
			s info="开放平台主键id为空"
			continue
		}
		if code=""  //角色编码
		{
			s info="角色编码code不能为空"
			continue
		}
		s SSGRPRowId=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByRoleCode(code) //SS_Group RowId
		
		if operation="update" //操作类型
		{
			if name="" //角色名称
			{
				s info="角色名称name为空"
				continue
			}
			s SSGRPGroupDr=""
			if (parentCode'="")&&(parentCode'=0) //父角色编码
			{
				s SSGRPGroupDr=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByRoleCode(parentCode)
				if SSGRPGroupDr=""
				{
					s info="父角色编码在his里没找到对应数据"_parentCode
					//continue  //?
				}
			}
			s eobj=##class(web.Entity.CT.SSGroup).%New()  
		    s eobj.SSGRPRowId=SSGRPRowId  //RowId
		    s eobj.SSGRPCode = code //角色编码
			s eobj.SSGRPDesc = name    //角色名称
			s eobj.SSGRPGroupDr=SSGRPGroupDr  // 父角色id
			s eobj.SSGRPActiveFlag =activity  //是否有效
			s eobj.SSGRPStartDate = startDate  //开始日期
			s eobj.SSGRPEndDate = endDate  //结束日期
			if (SSGRPRowId="")  //新增
		    {
		        s eobj.SSGRPCreateUser= LastUpdateUser //系统创建人
				s eobj.SSGRPCreateDate= $p($h,",",1)    //系统创建日期
				s eobj.SSGRPCreateTime=$p($h,",",2)     //系统创建时间
		    }
			s eobj.SSGRPSeqNo= seqNo    //顺序号
			s eobj.SSGRPLastUpdateUser=LastUpdateUser  //最后更新人
			s eobj.SSGRPLastUpdateDate= $p($h,",",1)    //最后更新日期
			s eobj.SSGRPLastUpdateTime=$p($h,",",2)     //最后更新时间
			s eobj.SSGRPPYCode= pyCode    //拼音码
			s eobj.SSGRPWBCode= wbCode    //五笔码
			s eobj.SSGRPMark= mark    //备注
			if (SSGRPRowId="")  //新增
		    {
		        s obj=##class(User.SSGroup).%New()
		    }
		    else  //修改
		    {
		        s obj=##class(User.SSGroup).%OpenId(SSGRPRowId)
		        s bobj=##class(web.Entity.CT.SSGroup).%New()  
			    s bobj.SSGRPRowId=SSGRPRowId
			    s bobj.SSGRPCode = obj.SSGRPCode //角色编码
				s bobj.SSGRPDesc = obj.SSGRPDesc     //角色名称
				s:obj.SSGRPGroupDr'="" bobj.SSGRPGroupDr = obj.SSGRPGroupDr.%Id() // 父角色id
				s bobj.SSGRPActiveFlag =obj.SSGRPActiveFlag  //是否有效
				s bobj.SSGRPStartDate = obj.SSGRPStartDate  //开始日期
				s bobj.SSGRPEndDate = obj.SSGRPEndDate  //结束日期
				s:obj.SSGRPCreateUser'="" bobj.SSGRPCreateUser = obj.SSGRPCreateUser.%Id() // 系统创建人
				s bobj.SSGRPCreateDate =obj.SSGRPCreateDate  //系统创建日期
				s bobj.SSGRPCreateTime = obj.SSGRPCreateTime  //系统创建时间
				s bobj.SSGRPSeqNo= obj.SSGRPSeqNo    //顺序号
				s:obj.SSGRPLastUpdateUser'="" bobj.SSGRPLastUpdateUser = obj.SSGRPLastUpdateUser.%Id() // 最后更新人
				s bobj.SSGRPLastUpdateDate =obj.SSGRPLastUpdateDate  //最后更新日期
				s bobj.SSGRPLastUpdateTime = obj.SSGRPLastUpdateTime  //最后更新时间
				s bobj.SSGRPPYCode= obj.SSGRPPYCode    //拼音码
				s bobj.SSGRPWBCode= obj.SSGRPWBCode    //五笔码
				s bobj.SSGRPMark= obj.SSGRPMark    //备注
				
		    }
		    //保存角色
		    s obj.SSGRPCode = eobj.SSGRPCode //角色编码
			s obj.SSGRPDesc = eobj.SSGRPDesc    //角色名称
			d obj.SSGRPGroupDrSetObjectId(eobj.SSGRPGroupDr)  // 父角色id
			s obj.SSGRPActiveFlag =eobj.SSGRPActiveFlag  //是否有效
			s obj.SSGRPStartDate = eobj.SSGRPStartDate  //开始日期
			s obj.SSGRPEndDate = eobj.SSGRPEndDate  //结束日期
			if (SSGRPRowId="")
			{
				d obj.SSGRPCreateUserSetObjectId(eobj.SSGRPCreateUser)  //系统更新人
				s obj.SSGRPCreateDate= eobj.SSGRPCreateDate    //系统创建日期
				s obj.SSGRPCreateTime= eobj.SSGRPCreateTime     ////系统创建时间
			}
			s obj.SSGRPSeqNo= eobj.SSGRPSeqNo    //顺序号
			d obj.SSGRPLastUpdateUserSetObjectId(eobj.SSGRPLastUpdateUser)  //最后更新人
			s obj.SSGRPLastUpdateDate= eobj.SSGRPLastUpdateDate    //最后更新日期
			s obj.SSGRPLastUpdateTime=eobj.SSGRPLastUpdateTime     //最后更新时间
			s obj.SSGRPPYCode= eobj.SSGRPPYCode    //拼音码
			s obj.SSGRPWBCode= eobj.SSGRPWBCode    //五笔码
			s obj.SSGRPMark= eobj.SSGRPMark    //备注
			
			TSTART
			s sc=obj.%Save()
			if ($$$ISOK(sc))
			{
				TCOMMIT
				d obj.%Close()
				s SSGroupID=obj.%Id()
				s elogJson=eobj.JsonS()
				if (SSGRPRowId'="")
				{
					s blogJson=bobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_Group","User.SSGroup","安全组",SSGroupID,name,"U",elogJson,blogJson,LastUpdateUser)					
				}
				else
				{
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_Group","User.SSGroup","安全组",SSGroupID,name,"A",elogJson,"",LastUpdateUser)
				}
				
				if (orgCode'="")
				{
					s HospitalDR=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByOrgCode(orgCode)
					if (HospitalDR'="")
					{
						if ($d(^SSU("SSGRP",SSGroupID,"HOSP",0,"Hosp",HospitalDR))=0)  //不存在的话就新增关联医院
						{
							s ssgheobj=##class(web.Entity.CT.SSGroupHospitals).%New()
							s ssgheobj.HOSPParRef=SSGroupID
							s ssgheobj.HOSPHospitalDR=HospitalDR
							d ##class(web.DHCBL.CT.SSGroupHospitals).SaveEntity(ssgheobj)
						}
					}
				}
				s successcode=200		
				s msg="数据保存成功"
				if DataRet="" s DataRet=""""_portalid_""""
				else  s DataRet=DataRet_","_""""_portalid_""""				
			}
			else
			{
				TROLLBACK
				d obj.%Close()
				s info= "数据操作失败:"_$system.OBJ.DisplayError(sc)  //$SYSTEM.Status.GetErrorText(sc)
			}
		}
		elseif (operation="delete") /// 删除 ->在his里停用数据
		{
			if (SSGRPRowId'="")   //停用数据
			{
				s obj = ##class(User.SSGroup).%OpenId(SSGRPRowId)
				//eobj
				s eobj = ##class(web.Entity.CT.SSGroup).%New()
				s eobj.SSGRPRowId=SSGRPRowId
				s eobj.SSGRPCode=obj.SSGRPCode
				s eobj.SSGRPDesc=obj.SSGRPDesc
				s eobj.SSGRPEndDate=+$h-1
				s eobj.SSGRPActiveFlag="N"
				s eobj.SSGRPLastUpdateUser=LastUpdateUser  //最后更新人
				s eobj.SSGRPLastUpdateDate= $p($h,",",1)    //最后更新日期
				s eobj.SSGRPLastUpdateTime=$p($h,",",2)     //最后更新时间
				
				//旧数据
				s pobj = ##class(web.Entity.CT.SSGroup).%New()
				s pobj.SSGRPRowId=SSGRPRowId
				s pobj.SSGRPCode=obj.SSGRPCode
				s pobj.SSGRPDesc=obj.SSGRPDesc
				s pobj.SSGRPEndDate=obj.SSGRPEndDate
				s pobj.SSGRPActiveFlag=obj.SSGRPActiveFlag
				s:obj.SSGRPCreateUser'="" pobj.SSGRPCreateUser = obj.SSGRPCreateUser.%Id() // 系统创建人
				s pobj.SSGRPCreateDate =obj.SSGRPCreateDate  //系统创建日期
				s pobj.SSGRPCreateTime = obj.SSGRPCreateTime  //系统创建时间
				s:obj.SSGRPLastUpdateUser'="" pobj.SSGRPLastUpdateUser = obj.SSGRPLastUpdateUser.%Id() // 最后更新人
				s pobj.SSGRPLastUpdateDate =obj.SSGRPLastUpdateDate  //最后更新日期
				s pobj.SSGRPLastUpdateTime = obj.SSGRPLastUpdateTime  //最后更新时间
				
				//保存数据
				s obj.SSGRPEndDate=eobj.SSGRPEndDate
				s obj.SSGRPActiveFlag=eobj.SSGRPActiveFlag
				d obj.SSGRPLastUpdateUserSetObjectId(eobj.SSGRPLastUpdateUser)  //最后更新人
				s obj.SSGRPLastUpdateDate= eobj.SSGRPLastUpdateDate    //最后更新日期
				s obj.SSGRPLastUpdateTime=eobj.SSGRPLastUpdateTime     //最后更新时间
				TS
				s sc=obj.%Save()
				if (sc=1)
				{
					TC
					d obj.%Close()
					s elogJson=eobj.JsonS()
					s plogJson=pobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_Group","User.SSGroup","安全组",SSGRPRowId,eobj.SSGRPDesc,"U",elogJson,plogJson,LastUpdateUser)
					s successcode=200		
					s msg="数据操作成功"
					if DataRet="" s DataRet=""""_portalid_""""
					else  s DataRet=DataRet_","_""""_portalid_""""
				}
				else
				{
					TROLLBACK
					d obj.%Close()
					s info= "数据操作失败:"_$system.OBJ.DisplayError(sc)
				}
			}
			else
			{
				s info= "数据不存在"
			}
		}
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s results="{""code"":""200"",""msg"":""success"",""data"":["_DataRet_"]}"	
	}
	else
	{
		s results="{""code"":""999999"",""msg"":""处理失败"",""data"":null}"
	}
	q results
}

/// Function:   同步岗位关联角色接口 -hos -同步账号
/// Creator:    chenying
/// CreateDate: 2022-10-17
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).SyncGroupPost()
ClassMethod SyncGroupPost(JsonStr As %String) As %String
{
	s operationuser="UnifiedUserPlatform" 
	s results="",msg="",DataRet="",successcode=0
	s JsonInfo=[].%FromJSON(JsonStr)
	s DataList=JsonInfo.%Get("Request").%Get("Data")
	for DataListii=0:1:(DataList.%Size()-1)
	{
		s LastUpdateUser=""
		s:operationuser'="" LastUpdateUser=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByUserCode(operationuser) //SS_Group RowId 更新人rowid	
		
		s DetailInfo=DataList.%Get(DataListii)
		
		s operation=DetailInfo.%Get("operation")  //操作类型，update新增/修改,delete删除
		s portalid=DetailInfo.%Get("id")  //开放平台主键id
		s operationuser=DetailInfo.%Get("operationuser") //更新人登录名
		s postCode=DetailInfo.%Get("postCode") //岗位编码
		s roleCode=DetailInfo.%Get("roleCode") //角色编码
		s orgCode=DetailInfo.%Get("orgCode") //机构编码
		s activity=DetailInfo.%Get("activity") //是否有效 true/false
		s activity=$case(activity,"true":"Y","false":"N","y":"Y","n":"N","":"N",1:"Y",0:"N",:activity) //是否有效 true/false
		s startDate=DetailInfo.%Get("startDate") //开始日期，格式：yyyy-MM-dd
		s:startDate'="" startDate=$zdh(startDate,3)  //开始日期，格式：yyyy-MM-dd
		s:startDate="" startDate=+$h
		s endDate=DetailInfo.%Get("endDate") //结束日期，格式：yyyy-MM-dd
		s:endDate'="" endDate=$zdh(endDate,3) //结束日期，格式：yyyy-MM-dd
		s pyCode=DetailInfo.%Get("pyCode") //拼音码
		s:pyCode="" pyCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(pyCode) //拼音码
		s wbCode=DetailInfo.%Get("wbCode")  //五笔码
		s:wbCode="" wbCode=##class(web.DHCBL.BDP.FunLib).GetWBCODE(wbCode)  //五笔码
		s mark=DetailInfo.%Get("mark") //备注
		s seqNo=DetailInfo.%Get("seqNo") //排序值
			
			
		if operation=""  //操作类型
		{
			s info="操作类型operation为空"
			continue
		}
		if portalid=""  //开放平台主键id
		{
			s info="开放平台主键id为空"
			continue
		}
		if postCode=""  //岗位编码
		{
			s info="岗位编码postCode不能为空"
			continue
		}
		else
		{
			//岗位编码对应的rowid
			s POROPOSTCode=$o(^CT.BDP.CT.HOSPostI("IndexCode"," "_$zcvt(postCode,"U"),0))

			if POROPOSTCode=""
			{
				s info="岗位编码postCode找不到对应的数据"_postCode
				continue
			}
		}
		if roleCode=""  //角色编码
		{
			s info="角色编码roleCode不能为空"
			continue
		}
		else
		{
			//角色编码对应的rowid
			s POROROLECode=##class(web.DHCBL.BDP.HOSInterface).GetRowIdByRoleCode(roleCode) //SS_Group RowId

			if POROROLECode=""
			{
				s info="角色编码码roleCode找不到对应的数据"_roleCode
				continue
			}
		}
		s ID=$o(^CT.BDP.CT.HOSPostRoleI("IndexPOSTROLE",POROPOSTCode,POROROLECode,0))

		if operation="update" //操作类型
		{
			s eobj=##class(web.Entity.CT.HOSPostRole).%New()  
		    s eobj.ID=ID  //RowId
		    s eobj.POROPOSTCode = POROPOSTCode //角色编码
			s eobj.POROROLECode = POROROLECode    //角色名称
			s eobj.POROActivity =activity  //是否有效
			s eobj.POROStartDate = startDate  //开始日期
			s eobj.POROEndDate = endDate  //结束日期
			if (ID="")  //新增
		    {
		        s eobj.POROCreateUser= LastUpdateUser //系统创建人
				s eobj.POROCreateDate= $p($h,",",1)    //系统创建日期
				s eobj.POROCreateTime=$p($h,",",2)     //系统创建时间
		    }
			s eobj.POROSeqNo= seqNo    //顺序号
			s eobj.POROLastUpdateUser=LastUpdateUser  //最后更新人
			s eobj.POROLastUpdateDate= $p($h,",",1)    //最后更新日期
			s eobj.POROLastUpdateTime=$p($h,",",2)     //最后更新时间
			s eobj.POROPYCode= pyCode    //拼音码
			s eobj.POROWBCode= wbCode    //五笔码
			s eobj.POROMark= mark    //备注
			if (ID="")  //新增
		    {
		        s obj=##class(CT.BDP.CT.HOSPostRole).%New()
		        s obj.POROCreateDate= eobj.POROCreateDate    //系统创建日期
				s obj.POROCreateTime= eobj.POROCreateTime     ////系统创建时间
		        d obj.POROCreateUserSetObjectId(eobj.POROCreateUser)  //系统更新人
		    }
		    else  //修改
		    {
		        s obj=##class(CT.BDP.CT.HOSPostRole).%OpenId(ID)
		        s bobj=##class(web.Entity.CT.HOSPostRole).%New()  
			    s bobj.ID=ID
				if $IsObject(obj.POROPOSTCode){
					s bobj.POROPOSTCode = obj.POROPOSTCode.%Id()   //岗位
				}
				if $IsObject(obj.POROROLECode){
					s bobj.POROROLECode = obj.POROROLECode.%Id()     //角色
				}
			    s bobj.POROActivity =obj.POROActivity  //是否有效
				s bobj.POROStartDate = obj.POROStartDate  //开始日期
				s bobj.POROEndDate = obj.POROEndDate  //结束日期
				if $IsObject(obj.POROCreateUser){
					s bobj.POROCreateUser = obj.POROCreateUser.%Id()     // 系统创建人
				}
				s bobj.POROCreateDate =obj.POROCreateDate  //系统创建日期
				s bobj.POROCreateTime = obj.POROCreateTime  //系统创建时间
				s bobj.POROSeqNo= obj.POROSeqNo    //顺序号
				if $IsObject(obj.POROLastUpdateUser){
					s bobj.POROLastUpdateUser = obj.POROLastUpdateUser.%Id()     // 最后更新人
				}
				s bobj.POROLastUpdateDate =obj.POROLastUpdateDate  //最后更新日期
				s bobj.POROLastUpdateTime = obj.POROLastUpdateTime  //最后更新时间
				s bobj.POROPYCode= obj.POROPYCode    //拼音码
				s bobj.POROWBCode= obj.POROWBCode    //五笔码
				s bobj.POROMark= obj.POROMark    //备注
				
		    }
		    //保存岗位角色关联
		    d obj.POROPOSTCodeSetObjectId(eobj.POROPOSTCode) //岗位
		    d obj.POROROLECodeSetObjectId(eobj.POROROLECode) //角色
		    s obj.POROActivity =eobj.POROActivity  //是否有效
			s obj.POROStartDate = eobj.POROStartDate  //开始日期
			s obj.POROEndDate = eobj.POROEndDate  //结束日期
			s obj.POROSeqNo= eobj.POROSeqNo    //顺序号
			d obj.POROLastUpdateUserSetObjectId(eobj.POROLastUpdateUser)  //最后更新人
			s obj.POROLastUpdateDate= eobj.POROLastUpdateDate    //最后更新日期
			s obj.POROLastUpdateTime=eobj.POROLastUpdateTime     //最后更新时间
			s obj.POROPYCode= eobj.POROPYCode    //拼音码
			s obj.POROWBCode= eobj.POROWBCode    //五笔码
			s obj.POROMark= eobj.POROMark    //备注

			TSTART
			s sc=obj.%Save()
			if ($$$ISOK(sc))
			{
				TCOMMIT
				d obj.%Close()
				s LinkID=obj.%Id()
				s elogJson=eobj.JsonS()
				if (ID'="")
				{
					s blogJson=bobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色字典",LinkID,postCode_"-"_roleCode,"U",elogJson,blogJson,LastUpdateUser)					
				}
				else
				{
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色字典",LinkID,postCode_"-"_roleCode,"A",elogJson,"",LastUpdateUser)
				}
				s successcode=200		
				s msg="数据保存成功"
				if DataRet="" s DataRet=""""_portalid_""""
				else  s DataRet=DataRet_","_""""_portalid_""""				
			}
			else
			{
				TROLLBACK
				d obj.%Close()
				s info= "数据操作失败:"_$system.OBJ.DisplayError(sc)  //$SYSTEM.Status.GetErrorText(sc)
			}
		}
		elseif (operation="delete") /// 删除 ->在his里停用数据
		{
			
			if (ID'="")   //停用数据
			{
				s obj = ##class(CT.BDP.CT.HOSPostRole).%OpenId(ID)
				//eobj
				s eobj = ##class(web.Entity.CT.HOSPostRole).%New()
				s eobj.ID=ID
				s eobj.POROPOSTCode = POROPOSTCode   //岗位
				s eobj.POROROLECode = POROROLECode     //角色
				s eobj.POROEndDate=+$h-1
				s eobj.POROActivity="N"
				s eobj.POROLastUpdateUser=LastUpdateUser  //最后更新人
				s eobj.POROLastUpdateDate= $p($h,",",1)    //最后更新日期
				s eobj.POROLastUpdateTime=$p($h,",",2)     //最后更新时间
			
				//旧数据
				s pobj = ##class(web.Entity.CT.HOSPostRole).%New()
				s pobj.ID=ID
				if $IsObject(obj.POROPOSTCode){
					s pobj.POROPOSTCode = obj.POROPOSTCode.%Id()   //岗位
				}
				if $IsObject(obj.POROROLECode){
					s pobj.POROROLECode = obj.POROROLECode.%Id()     //角色
				}
				s pobj.POROEndDate=obj.POROEndDate
				s pobj.POROActivity=obj.POROActivity
				if $IsObject(obj.POROCreateUser){
					s pobj.POROCreateUser = obj.POROCreateUser.%Id()    // 系统创建人
				}
				s pobj.POROCreateDate =obj.POROCreateDate  //系统创建日期
				s pobj.POROCreateTime = obj.POROCreateTime  //系统创建时间
				if $IsObject(obj.POROLastUpdateUser){
					s pobj.POROLastUpdateUser = obj.POROLastUpdateUser.%Id()     // 最后更新人
				}
				s pobj.POROLastUpdateDate =obj.POROLastUpdateDate  //最后更新日期
				s pobj.POROLastUpdateTime = obj.POROLastUpdateTime  //最后更新时间
				
				//保存数据
				s obj.POROEndDate=eobj.POROEndDate
				s obj.POROActivity=eobj.POROActivity
				
				d obj.POROLastUpdateUserSetObjectId(eobj.POROLastUpdateUser)  //最后更新人
				s obj.POROLastUpdateDate= eobj.POROLastUpdateDate    //最后更新日期
				s obj.POROLastUpdateTime=eobj.POROLastUpdateTime     //最后更新时间
				TS
				s sc=obj.%Save()
				
				if (sc=1)
				{
					TC
					d obj.%Close()
					s elogJson=eobj.JsonS()
					s plogJson=pobj.JsonS()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_BDP_CT.HOS_PostRole","CT.BDP.CT.HOSPostRole","岗位角色字典",ID,postCode_"-"_roleCode,"U",elogJson,plogJson,LastUpdateUser)
					s successcode=200		
					s msg="数据操作成功"
					if DataRet="" s DataRet=""""_portalid_""""
					else  s DataRet=DataRet_","_""""_portalid_""""
				}
				else
				{
					TROLLBACK
					d obj.%Close()
					s info= "数据操作失败:"_$system.OBJ.DisplayError(sc)
				}
			}
			else
			{
				s info= "数据不存在"
			}
		}
	}
	if (successcode=200)  //至少有一条执行成功
	{
		s results="{""code"":""200"",""msg"":""success"",""data"":["_DataRet_"]}"	
	}
	else
	{
		s results="{""code"":""999999"",""msg"":""处理失败"",""data"":null}"
	}
	q results
}

/// Function:   根据医院代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  CT_Hospital
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetRowIdByOrgCode("")
ClassMethod GetRowIdByOrgCode(code As %String) As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Function:   根据科室代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  CT_Loc
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetRowIdByBuCode("","")
ClassMethod GetRowIdByBuCode(code As %String, hospid As %String = "") As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Function:   根据角色代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  SS_Group
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetRowIdByRoleCode("Demo Group")
ClassMethod GetRowIdByRoleCode(code As %String) As %String
{
	q:code="" ""
	s rowid=$o(^SSU("SSGRP",0,"Code",code,0))
	q rowid
}

/// Function:   根据用户代码获取rowid
/// Creator:    chenying
/// CreateDate: 2022-10-25
/// TableName:  SS_User
/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetRowIdByUserCode("")
ClassMethod GetRowIdByUserCode(code As %String) As %String
{
	q:code="" ""
	q:$$ALPHAUP^SSUTIL4(code)="" ""
	s rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),0))
	q rowid
}

/// Debug:      w ##class(web.DHCBL.BDP.HOSInterface).GetUserByNOCare()
ClassMethod GetUserByNOCare() As %String
{
	s SSUSRRowId=""
	for  
	{
		s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       //人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		k CarPrvTpArr
		s ChildSub=0
        for 
        {
            s ChildSub=$o(^SSU("SSUSR",SSUSRRowId,"USERPOST",ChildSub))
            q:ChildSub="" 
          
	        s USERPOSTPostCode =$p($g(^SSU("SSUSR",SSUSRRowId,"USERPOST",ChildSub)),"^",1) /// 岗位字典-外键
	        s USERPOSTPostDesc=""
	        s:USERPOSTPostCode'="" USERPOSTPostDesc=$listget($g(^CT.BDP.CT.HOSPostD(USERPOSTPostCode)),3)
	        if USERPOSTPostDesc["医师"{ s CarPrvTpArr("主任医师")="" }
			elseif USERPOSTPostDesc["护士" { s CarPrvTpArr("主任护师")="" }
			elseif USERPOSTPostDesc["药师" { s CarPrvTpArr("主任药师")="" }
        }
        if $d(CarPrvTpArr)&(SSUSRCareProvDR=""){
	        w SSUSRInitials_","_SSUSRName,!
	    }
		
	}
	q "over"
}

}
