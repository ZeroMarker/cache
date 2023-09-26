/// 描述：HRP人员，科室，接口开发，走平台
/// 编写人：李可凡
/// 编写日期：2022-05-25
Class web.DHCBL.BDP.UserLocSyncInterface Extends %RegisteredObject
{

/*****************************************科室同步接口*****************************************/
/// SaveCTLoc方法测试
/// w ##class(web.DHCBL.BDP.UserLocSyncInterface).Test1("")
ClassMethod Test1(input) As %String
{
	s:input="" input="<Request><Header><MessageID/><SourceSystem></SourceSystem></Header><Body><LocData><AUDFlag>A</AUDFlag><CTLOCCode>ceshi1230</CTLOCCode><CTLOCDesc>测试1230</CTLOCDesc><CTLOCType>E</CTLOCType><CTLOCHospitalCode>HYMHYY</CTLOCHospitalCode><CTLOCDateActiveFrom>2021-12-30</CTLOCDateActiveFrom><CTLOCDateActiveTo></CTLOCDateActiveTo></LocData></Body></Request>"
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input) 
	set responseStream=..SaveCTLoc(stream)
	q responseStream
	q ""
}

/// 描述：维护科室信息时，同步到HIS，保存多条数据
/// 编写人：基础数据平台-李可凡
/// 编写日期：2022-05-25
ClassMethod SaveCTLoc(InputStream As %GlobalCharacterStream) As %String
{
	s result=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	
	set AUDFlag=""  //增删改标识
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/AUDFlag","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set AUDFlag=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCCode=""  //科室代码
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCCode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCCode=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCDesc=""  //科室描述
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCDesc","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCDesc=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCType=""  //科室类型 W,E,DI,D,C,O,OP,EM,DS,MR,OR,CL,ADM
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCType","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCType=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCHospitalCode=""  //医院编码
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCHospitalCode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCHospitalCode=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCDateActiveFrom=""  //开始日期 yy-mm-dd
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCDateActiveFrom","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCDateActiveFrom=$tr(fieldValue,$c(0),"")
	}
	
	set CTLOCDateActiveTo=""  //结束日期 yy-mm-dd
	s tSC=tDocument.EvaluateExpression("/Request/Body/LocData/CTLOCDateActiveTo","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTLOCDateActiveTo=$tr(fieldValue,$c(0),"")
	}
	
	if (AUDFlag="A")||(AUDFlag="U")		//新增或修改科室
	{
		s eobj=##class(web.Entity.CT.CTLoc).%New()
		s eobj.CTLOCCode=CTLOCCode		//科室代码
		s eobj.CTLOCDesc=CTLOCDesc		//科室描述
		s eobj.CTLOCType=CTLOCType		//科室类型
		s:CTLOCHospitalCode'="" eobj.CTLOCHospitalDR=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(CTLOCHospitalCode),0))	//医院DR
		s:CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(CTLOCDateActiveFrom)	//开始日期
		s:CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(CTLOCDateActiveTo)  //结束日期
		//s:CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=$zdh(CTLOCDateActiveFrom,3)
		//s:CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=$zdh(CTLOCDateActiveTo,3)
		if ((eobj.CTLOCCode="")||(eobj.CTLOCDesc="")||(eobj.CTLOCType="")||(eobj.CTLOCDateActiveFrom=""))
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>代码/描述/类型/开始日期不能为空</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if '((eobj.CTLOCType="W")||(eobj.CTLOCType="E")||(eobj.CTLOCType="DI")||(eobj.CTLOCType="D")||(eobj.CTLOCType="C")||(eobj.CTLOCType="O")||(eobj.CTLOCType="OP")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="DS")||(eobj.CTLOCType="MR")||(eobj.CTLOCType="OR")||(eobj.CTLOCType="CL")||(eobj.CTLOCType="ADM"))
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>科室类型的值只能是W,E,DI,D,C,O,OP,EM,DS,MR,OR,CL,ADM</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if (eobj.CTLOCHospitalDR="")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>找不到医院</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		
		
		s eobj.CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTLOCCode),0))
		if (eobj.CTLOCRowID'="")&&(AUDFlag="A")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>已存在相同代码的科室，无法新增</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if (eobj.CTLOCRowID="")&&(AUDFlag="U")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>找不到科室，无法修改</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		//保存科室
		s result=..SaveCTLocEntity(eobj)
		s result="<ResultCode>"_$p(result,"^",1)_"</ResultCode><ResultContent>"_$p(result,"^",2)_"</ResultContent>"
	}
	
	s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
	q result
}

/// Creator：李可凡
/// CreatDate: 2022-05-25
/// Description：保存修改科室维护的内容
ClassMethod SaveCTLocEntity(eobj As web.Entity.CT.CTLoc) As %String
{
	s result=""
	if (eobj.CTLOCRowID="")		//添加科室
	{
		s obj=##class(User.CTLoc).%New()
	}
	else	//修改科室
	{
		s obj=##class(User.CTLoc).%OpenId(eobj.CTLOCRowID)
		s bobj=##class(web.Entity.CT.CTLoc).%New()
		s bobj.CTLOCRowID=eobj.CTLOCRowID
		s bobj.CTLOCCode=obj.CTLOCCode
		s bobj.CTLOCDesc=obj.CTLOCDesc
		//s bobj.CTLOCAddress=obj.CTLOCAddress.GetAt(1)
		s bobj.CTLOCType=obj.CTLOCType
		//s:obj.CTLOCDepDR'="" bobj.CTLOCDepDR=obj.CTLOCDepDR.%Id()
		s:obj.CTLOCHospitalDR'="" bobj.CTLOCHospitalDR=obj.CTLOCHospitalDR.%Id()
		s bobj.CTLOCDateActiveFrom=obj.CTLOCDateActiveFrom
		s bobj.CTLOCContactName=obj.CTLOCContactName
		//s bobj.CTLOCTelephone=obj.CTLOCTelephone
		if (bobj.CTLOCType="W")||(bobj.CTLOCType="EM")||(bobj.CTLOCType="OP")
		{
			if (eobj.CTLOCType'=bobj.CTLOCType)
			{
				s str=##class(web.DHCBL.CT.CTLoc).UpdateCTLOCType(eobj.CTLOCRowID,eobj.CTLOCType)
				q:str'="" "-1^"_str
			}
		}
		s blogJson=bobj.JsonS()
	}
	s obj.CTLOCCode=eobj.CTLOCCode		//科室代码
	s obj.CTLOCDesc=eobj.CTLOCDesc		//科室描述
	/*
	if (eobj.CTLOCAddress'="")		//修改地址
	{
		s AddressList=##class(%ListOfDataTypes).%New()
		d AddressList.Insert(eobj.CTLOCAddress)
		s obj.CTLOCAddress=AddressList
	}
	*/
	s obj.CTLOCType=eobj.CTLOCType		//科室类型
	//d obj.CTLOCDepDRSetObjectId(eobj.CTLOCDepDR)		//科室部门组
	d obj.CTLOCHospitalDRSetObjectId(eobj.CTLOCHospitalDR)	//医院
	s obj.CTLOCDateActiveFrom=eobj.CTLOCDateActiveFrom		//开始日期
	s obj.CTLOCDateActiveTo=eobj.CTLOCDateActiveTo		//结束日期
	s:eobj.CTLOCDesc'="" obj.CTLOCContactName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTLOCDesc)		//拼音检索码
	//s obj.CTLOCTelephone=eobj.CTLOCTelephone	//科室电话
	if (eobj.CTLOCType="W")
	{
	    s obj.CTLOCWardFlag="Y"
	}
	else
	{
	    s obj.CTLOCWardFlag="N"
	}
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s result="0^"_id
		s logJson=eobj.JsonS()
		d:eobj.CTLOCRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室/病区",id,eobj.CTLOCDesc,"A",logJson,"","1")
		d:eobj.CTLOCRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室/病区",id,eobj.CTLOCDesc,"U",logJson,blogJson,"1")
		//如果科室类型为ward,添加表PAC_Ward记录
		if (eobj.CTLOCType="W")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="OP")
        {
            s:eobj.WARDSingleRoom="" eobj.WARDSingleRoom="N"
            s:eobj.WARDActive="" eobj.WARDActive="N"
            s:eobj.WARDViewLinkedRooms="" eobj.WARDViewLinkedRooms="N"
            s:eobj.WARDViewNextMostUrgent="" eobj.WARDViewNextMostUrgent="N"
            s:eobj.WARDBeforehand="" eobj.WARDBeforehand="N"
            s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",id,0))
            if (WARDRowID'="")
            {
                s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
                s wobj.WARDSingleRoom = eobj.WARDSingleRoom
                s wobj.WARDActive = eobj.WARDActive
                s wobj.WARDViewLinkedRooms = eobj.WARDViewLinkedRooms
                s wobj.WARDViewNextMostUrgent = eobj.WARDViewNextMostUrgent
                s wobj.WARDInactiveDateFrom = eobj.CTLOCDateActiveFrom
                s wobj.WARDBeforehand = eobj.WARDBeforehand
                d wobj.%Save()
                d wobj.%Close()
            }
        }
	}
	else
	{
		Trollback
		s result="-1^"_eobj.CTLOCDesc_"保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/*****************************************人员同步接口*****************************************/
/// 测试SaveSSUser方法
/// w ##class(web.DHCBL.BDP.UserLocSyncInterface).Test2("")
ClassMethod Test2(input) As %String
{
	s:input="" input="<Request><Header><MessageID/><SourceSystem></SourceSystem></Header><Body><UserData><AUDFlag>A</AUDFlag><SSUSRInitials>ceshi1230</SSUSRInitials><SSUSRName>测试1230</SSUSRName><SSUSRDefaultDeptCode>ceshi1230</SSUSRDefaultDeptCode><SSUSRDateFrom>2021-12-30</SSUSRDateFrom><SSUSRDateTo></SSUSRDateTo><SSUSRFreeText1>532502199911112222</SSUSRFreeText1><CTPCPCarPrvTp>主任医师</CTPCPCarPrvTp></UserData></Body></Request>"
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(input) 
	set responseStream=..SaveSSUser(stream)
	q responseStream
	q ""
}

/// 描述：维护人员信息时，同步到HIS
/// 编写人：基础数据平台-李可凡
/// 编写日期：2022-05-25
ClassMethod SaveSSUser(InputStream As %GlobalCharacterStream) As %String
{
	s result=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	
	set AUDFlag=""  //增删改标识
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/AUDFlag","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set AUDFlag=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRInitials=""  //工号
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRInitials","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRInitials=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRName=""  //姓名
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRName","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRName=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRDefaultDeptCode=""  //默认登录科室代码
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRDefaultDeptCode","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRDefaultDeptCode=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRDateFrom=""  //开始日期 yy-mm-dd
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRDateFrom","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRDateFrom=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRDateTo=""  //结束日期 yy-mm-dd
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRDateTo","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRDateTo=$tr(fieldValue,$c(0),"")
	}
	
	set SSUSRFreeText1=""  //身份证号
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/SSUSRFreeText1","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set SSUSRFreeText1=$tr(fieldValue,$c(0),"")
	}
	
	set CTPCPCarPrvTp=""  //医护人员类型描述
	s tSC=tDocument.EvaluateExpression("/Request/Body/UserData/CTPCPCarPrvTp","text()",.tRes)
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set CTPCPCarPrvTp=$tr(fieldValue,$c(0),"")
	}
	
	if (AUDFlag="A")||(AUDFlag="U")		//新增或修改人员
	{
		//先保存医护人员
		if (CTPCPCarPrvTp'="")
		{
			s ecobj=##class(web.Entity.CT.CTCareProv).%New()
			s ecobj.CTPCPCode=SSUSRInitials		//工号
			s ecobj.CTPCPDesc=SSUSRName			//姓名
			s ecobj.CTPCPOtherName=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ecobj.CTPCPDesc)		//拼音检索码
			s ecobj.CTPCPCarPrvTpDR=$o(^CT("CPT",0,"Desc",$ZCONVERT(CTPCPCarPrvTp,"U"),0))		//医护人员类型
			s:SSUSRDateFrom'="" ecobj.CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(SSUSRDateFrom)	//开始日期
			s:SSUSRDateTo'="" ecobj.CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(SSUSRDateTo)		//结束日期
			
			if ((ecobj.CTPCPCode="")||(ecobj.CTPCPDesc="")||(ecobj.CTPCPDateActiveFrom=""))
			{
				s result="<ResultCode>-1</ResultCode><ResultContent>工号/姓名/开始日期不能为空</ResultContent>"
				s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
				q result
			}
			if (ecobj.CTPCPCarPrvTpDR="")
			{
				s result="<ResultCode>-1</ResultCode><ResultContent>医护人员类型错误</ResultContent>"
				s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
				q result
			}
			
			s ecobj.CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(ecobj.CTPCPCode),0))		//医护人员rowid
			s re=..SaveCareProvEntity(ecobj)			//保存医护人员
		}
		//保存用户
		s eobj=##class(web.Entity.CT.SSUser).%New()
		s eobj.SSUSRInitials=SSUSRInitials			//工号
		s eobj.SSUSRName=SSUSRName				//姓名
		s:SSUSRDefaultDeptCode'="" eobj.SSUSRDefaultDeptDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(SSUSRDefaultDeptCode),0))	//默认登录科室DR
		s:eobj.SSUSRDefaultDeptDR'="" eobj.SSUSRHospitalDR=$p($g(^CTLOC(eobj.SSUSRDefaultDeptDR)),"^",22)	//医院DR
		s:SSUSRDateFrom'="" eobj.SSUSRDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(SSUSRDateFrom)	//开始日期
		s:SSUSRDateTo'="" eobj.SSUSRDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(SSUSRDateTo)	//结束日期
		s eobj.SSUSRFreeText1=SSUSRFreeText1		//身份证号
		
		if ((eobj.SSUSRInitials="")||(eobj.SSUSRInitials="")||(SSUSRDefaultDeptCode="")||(eobj.SSUSRDateFrom=""))
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>工号/姓名/默认登录科室/开始日期不能为空</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if (eobj.SSUSRDefaultDeptDR="")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>找不到默认登录科室</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if (eobj.SSUSRHospitalDR="")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>找不到默认登录科室对应的医院</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		
		s eobj.SSUSRCareProvDR=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(eobj.SSUSRInitials),0))		//医护人员DR
		s eobj.SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(eobj.SSUSRInitials),0))	//用户rowid
		if (eobj.SSUSRRowId'="")&&(AUDFlag="A")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>已存在相同工号的用户，无法新增</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		if (eobj.SSUSRRowId="")&&(AUDFlag="U")
		{
			s result="<ResultCode>-1</ResultCode><ResultContent>找不到用户，无法修改</ResultContent>"
			s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
			q result
		}
		s result=..SaveSSUserEntity(eobj)	//保存用户
		
		//保存医护人员关联医院表
		if (eobj.SSUSRCareProvDR'="")&&($p(result,"^",1)=0)&&(eobj.SSUSRHospitalDR'="")	//已保存医护人员且用户保存成功
		{
			if '($d(^CTPCP(eobj.SSUSRCareProvDR,"HOSP",0,"Hosp",eobj.SSUSRHospitalDR)))	//判断重复
			{
				s hobj=##class(User.CTCareProvHospitals).%New(eobj.SSUSRCareProvDR)
				d hobj.HOSPParRefSetObjectId(eobj.SSUSRCareProvDR)
				d hobj.HOSPHospitalDRSetObjectId(eobj.SSUSRHospitalDR)
				s sch=hobj.%Save()
				d hobj.%Close()
			}
		}
		
		s result="<ResultCode>"_$p(result,"^",1)_"</ResultCode><ResultContent>"_$p(result,"^",2)_"</ResultContent>"
	}
	s result="<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body>"_result_"</Body></Response>"
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2022-05-25
/// Description：保存医护人员
ClassMethod SaveCareProvEntity(eobj As web.Entity.CT.CTCareProv) As %String
{
	s result=""
	if (eobj.CTPCPRowId1="")
	{	
		s obj=##class(User.CTCareProv).%New()
	}
	else
	{
	   	s obj=##class(User.CTCareProv).%OpenId(eobj.CTPCPRowId1)
		s bobj=##class(web.Entity.CT.CTCareProv).%New()
		s bobj.CTPCPRowId1 = eobj.CTPCPRowId1
		s bobj.CTPCPDesc = obj.CTPCPDesc
		s bobj.CTPCPCode = obj.CTPCPCode
		s bobj.CTPCPOtherName=obj.CTPCPOtherName
		//s bobj.CTPCPUnit=obj.CTPCPUnit
		s:obj.CTPCPCarPrvTpDR'="" bobj.CTPCPCarPrvTpDR = obj.CTPCPCarPrvTpDR.%Id()
		//s:obj.CTPCPTitleDR'="" bobj.CTPCPTitleDR = obj.CTPCPTitleDR.%Id()
		s bobj.CTPCPDateActiveFrom = obj.CTPCPDateActiveFrom
		s bobj.CTPCPDateActiveTo = obj.CTPCPDateActiveTo
		s blogJson=bobj.JsonS()
	}
	s obj.CTPCPCode=eobj.CTPCPCode						//工号
	s obj.CTPCPDesc=eobj.CTPCPDesc						//姓名
	s obj.CTPCPOtherName=eobj.CTPCPOtherName			//拼音检索码
	d obj.CTPCPCarPrvTpDRSetObjectId(eobj.CTPCPCarPrvTpDR)			//医护人员类型
	
	s obj.CTPCPDateActiveFrom=eobj.CTPCPDateActiveFrom				//开始日期
	s obj.CTPCPDateActiveTo=eobj.CTPCPDateActiveTo					//结束日期
	//d obj.CTPCPTitleDRSetObjectId(eobj.CTPCPTitleDR)				//医护人员职称
	//s obj.CTPCPUnit=eobj.CTPCPUnit						//资格证书号
	
	//写死
	s:eobj.CTPCPRowId1="" obj.CTPCPActiveFlag="Y"					//激活标识
	s:eobj.CTPCPRowId1="" obj.CTPCPSpecialistYN="N"					//是否专家
	s:eobj.CTPCPRowId1="" obj.CTPCPSurgeon="N"						//外科医生
	s:eobj.CTPCPRowId1="" obj.CTPCPHICApproved="N"					//毒麻处方权
	s:eobj.CTPCPRowId1="" obj.CTPCPAnaesthetist="N"					//麻醉师
	s obj.CTPCPUpdateDate=$p($h,",",1)			//修改日期
	s obj.CTPCPUpdateTime=$p($h,",",2)			//修改时间
	d obj.CTPCPUpdateUserDRSetObjectId(1)		//修改人
	
	Ts
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s result="0^"_id
		s logJson=eobj.JsonS()
		d:eobj.CTPCPRowId1="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"A",logJson,"","1")
		d:eobj.CTPCPRowId1'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",logJson,blogJson,"1")
	}
	else
	{
		Trollback
		s result="-1^医护人员"_eobj.CTPCPDesc_"保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2022-05-25
/// Description：保存用户
ClassMethod SaveSSUserEntity(eobj As web.Entity.CT.SSUser) As %String
{
	s result=""
	if (eobj.SSUSRRowId="")
	{
		s obj=##class(User.SSUser).%New()
	}
	else
	{
		s obj=##class(User.SSUser).%OpenId(eobj.SSUSRRowId)
		s bobj=##class(web.Entity.CT.SSUser).%New()
		s bobj.SSUSRRowId=eobj.SSUSRRowId
		s bobj.SSUSRInitials=obj.SSUSRInitials
		s bobj.SSUSRName=obj.SSUSRName
		s:obj.SSUSRDefaultDeptDR'="" bobj.SSUSRDefaultDeptDR = obj.SSUSRDefaultDeptDR.%Id()
		s:obj.SSUSRHospitalDR'="" bobj.SSUSRHospitalDR = obj.SSUSRHospitalDR.%Id()	
		s:obj.SSUSRCareProvDR'="" bobj.SSUSRCareProvDR = obj.SSUSRCareProvDR.%Id()
		s bobj.SSUSRDateFrom = obj.SSUSRDateFrom
		s bobj.SSUSRDateTo = obj.SSUSRDateTo
		s bobj.SSUSRFreeText1 =obj.SSUSRFreeText1
		//s bobj.SSUSRFreeText2 =obj.SSUSRFreeText2
		//s bobj.SSUSRMobile =obj.SSUSRMobile
		
		
		s blogJson=bobj.JsonS()
	}
	s obj.SSUSRInitials=eobj.SSUSRInitials 									//人事Id
    s obj.SSUSRName=eobj.SSUSRName 											//姓名
    d obj.SSUSRDefaultDeptDRSetObjectId(eobj.SSUSRDefaultDeptDR)			//默认登录科室
    d obj.SSUSRHospitalDRSetObjectId(eobj.SSUSRHospitalDR) 					//医院关联
    d obj.SSUSRCareProvDRSetObjectId(eobj.SSUSRCareProvDR)					//关联医护人员
    s obj.SSUSRDateFrom=eobj.SSUSRDateFrom									//生效日期
    s obj.SSUSRDateTo=eobj.SSUSRDateTo										//结束日期
    s obj.SSUSRFreeText1=eobj.SSUSRFreeText1								//身份证号
	//s obj.SSUSRFreeText2=eobj.SSUSRFreeText2								//性别
	//s obj.SSUSRMobile=eobj.SSUSRMobile									//手机号
	
	//写死
	d:eobj.SSUSRRowId="" obj.SSUSRGroupSetObjectId(327) 						//安全组：测试安全组
	d:eobj.SSUSRRowId="" obj.SSUSRCTLANDRSetObjectId(20) 						//默认语言
	s:eobj.SSUSRRowId="" obj.SSUSRActive="Y"									//激活标识
	s:eobj.SSUSRRowId="" obj.SSUSRChangeLocation="Y"							//允许用户更改登陆科室
	s:eobj.SSUSRRowId="" obj.SSUSRPassword=##Class(web.SSUser).Encrypt(1)		//登陆密码
    s:eobj.SSUSRRowId="" obj.SSUSRPin=##Class(web.SSUser).Encrypt(1)			//医嘱签名密码
    d obj.SSUSRLastUpdateUserDRSetObjectId(1)		//最后更新人
    s obj.SSUSRLastUpdateDate=$p($h,",",1)			//最后更新日期
    
    Ts
    s sc=obj.%Save()
    if $$$ISOK(sc)
	{
		Tc
		s id=obj.%Id()
		s result="0^"_id	//保存成功返回用户rowid
		s logJson=eobj.JsonS()
		d:eobj.SSUSRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"A",logJson,"","1")
		d:eobj.SSUSRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("SS_User","User.SSUser","用户",id,eobj.SSUSRName,"U",logJson,blogJson,"1")
		
	}
	else
	{
		Trollback
		s result="-1^用户"_eobj.SSUSRName_"保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
