Class web.DHCENS.STBLL.DICT.METHOD.CTDept Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：科室字典信息
/// Table：CT_Loc
/// Input： 
/// Return：科室信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).CTDept("")
ClassMethod CTDept(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDept).%New()
	.set insObj.CTDCode=$p($g(^CTLOC(rowid)),"^",1)
	.set insObj.CTDDesc=$p($g(^CTLOC(rowid)),"^",2)
	.set insObj.CTDOfficeAddress=$p($g(^CTLOC(rowid)),"^",16) ;$g(^CTLOC(rowid,"ADDR"))
	.set insObj.CTDCodesystemCode="CT_Dept"
	.set hospId=$p(^CTLOC(rowid),"^",22)
	.set:hospId="" hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.set insObj.CTDHosCode=hospCode
	.set insObj.CTDStatus="1"
	.set ParentDeptInfo=..GetFirstGradeDept(rowid)
	.set insObj.CTDRemarks=$p(ParentDeptInfo,"^",4)
	.set insObj.CTDUpdateUserCode="无"
	.set insObj.CTDCategoryCode=$p($g(^CTLOC(rowid)),"^",13)
	.set dateActiveFrom=$p($g(^CTLOC(rowid)),"^",24)
	.set:dateActiveFrom'="" insObj.CTDStartDate=$zdt(dateActiveFrom,3)
	.set dateActiveTo=$p($g(^CTLOC(rowid)),"^",25)
	.set:dateActiveTo'="" insObj.CTDEndDate=$zdt(dateActiveTo,3)
	.set insObj.CTDOfficePhone=$p($g(^CTLOC(rowid)),"^",40)
	.set insObj.CTDParentDeptCode=$p(ParentDeptInfo,"^",2)
	.set insObj.CTDParentDeptDesc=$p(ParentDeptInfo,"^",3)
	.set insObj.CTDParentDeptType=$p(ParentDeptInfo,"^",5)
	.set ParentDeptRowid=$p(ParentDeptInfo,"^",1)
	.set SuperDeptInfo=..GetSuperGradeDept(ParentDeptRowid)
	.set insObj.CTDSuperDeptCode=$p(SuperDeptInfo,"^",1)
	.set insObj.CTDSuperDeptDesc=$p(SuperDeptInfo,"^",2)
	.d body.depts.Insert(insObj)
	.if ((input'="")&&(insObj.CTDCategoryCode="W"))  d
	..set id=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(insObj.CTDCode),"")) 
	..set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000039","PAC_Ward",id)
	.Quit:input'=""
	.set Count=body.depts.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_Dept",stream)
	..d body.depts.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.depts.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Dept",stream)
		d body.depts.Clear()
	    set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.set SuccessFlag=-1
	}
	if SuccessFlag'=0 {
		s RetStr="-1^失败"
	}
	else{
		s RetStr="0^成功"
	}
	Quit RetStr
Exception
	b ;xx
	Quit "-1^"_$ze
}

ClassMethod SaveCTDept(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	s $zt="Exception"
	k ^LiyTemp("SaveCTDept")
	s RetState=1,RetString="<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^格式错误："_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments","count(Department)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			for i=1:1:hsCount {	
				set (code,desc)=""
				s TargetObj=##class(User.CTLoc).%New()
				
				// 科室代码
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTDCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set code=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCCode=$tr(fieldValue,$c(0),"")
				}
				// 科室名称
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTDDesc","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCDesc=$tr(fieldValue,$c(0),"")
				}
				// 科室类型
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTDTypeCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCType=$tr(fieldValue,$c(0),"")
				}
				// 科室部门组代码
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTDGroupCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set locCode=$tr(fieldValue,$c(0),"")
					i locCode'="" s locDr=$o(^CTLOC(0,"Code",locCode,""))
					i +locDr'=0 d TargetObj.CTLOCDepDRSetObjectId(locDr)
				}
				// 物理位置
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTCPosition","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCAddress=$tr(fieldValue,$c(0),"")
				}
				// 科室电话
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTCTelephone","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCTelephone=$tr(fieldValue,$c(0),"")
				}
				// 科室状态
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTCStatusCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCActiveFlag=$tr(fieldValue,$c(0),"")
				}
				// 启用日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTCStartDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCStartTime=$tr(fieldValue,$c(0),"")
				}
				// 停用日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/DepartmentRegisterRt/Departments/Department["_i_"]/CTCEndDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTLOCEndTime=$tr(fieldValue,$c(0),"")
				}
				s RetState=TargetObj.%Save()
				;d $system.Status.DisplayError(RetState)
				b ;beforeSave
				i RetState'=1 s ^LiyTemp("SaveCTDept",code)=RetState
			}
		}
	i RetState'=1 s RetString="<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败</ResultContent></Body></Response>"
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write(RetString)
	q ReturnStream
Exception
	s RetString="<Response><Header><SourceSystem></SourceSystem>02<MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>"
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write(RetString)
	q ReturnStream
		
	}
}

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).GetDeptDescription(39)
ClassMethod GetDeptDescription(DeptRowID As %String) As %String
{
	q:DeptRowID="" ""
	s MHCDeptRowID=$o(^MHC.Store.LocInfoI("locIdIndex"," "_DeptRowID,""))
	q:MHCDeptRowID="" ""
	s DeptDescription=$list($g(^MHC.Store.LocInfoD(MHCDeptRowID)),7)
	s DeptDescription=$replace(DeptDescription,$c(31),"")
	q DeptDescription
}

/// 取一级科室
/// add by lipan 2016-09-03
/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).GetFirstGradeDept(1)
ClassMethod GetFirstGradeDept(DeptRowID As %String) As %String
{
	
	set MajorRowid="",Rowid="",Code="",Name="",Profile="",Type=""
	f{
		s MajorRowid=$o(^DHCCTLoc(0,"Minor",DeptRowID,MajorRowid)) 
		q:MajorRowid=""
		s ChildSub=""
		f{
			s ChildSub=$o(^DHCCTLoc(0,"Minor",DeptRowID,MajorRowid,ChildSub)) 
			q:ChildSub=""
		
			s active=$p(^DHCCTLoc(MajorRowid,"MINOR",ChildSub),"^",2)
			if active=1{
				s Rowid=MajorRowid
				s Code=$p(^DHCCTLoc(MajorRowid),"^",1)
				s Name=$p(^DHCCTLoc(MajorRowid),"^",2)
				s Profile=$p(^DHCCTLoc(MajorRowid),"^",5)
				s Type=$p(^DHCCTLoc(MajorRowid),"^",6)
				q 
			}
		}
	}
	q Rowid_"^"_Code_"^"_Name_"^"_Profile_"^"_$g(Type)
}

/// 取顶级科室
/// add by lipan 2016-09-03
/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).GetSuperGradeDept(1)
ClassMethod GetSuperGradeDept(MajorDeptRowID As %String) As %String
{
	
	set Code="",Name=""
	if MajorDeptRowID="" {
		q ""
	}
	set SuperDeptRowid=$o(^DHCCTLocM(0,"Main",MajorDeptRowID,"")) 
	if SuperDeptRowid'=""{
		s Code=$p(^DHCCTLocM(SuperDeptRowid),"^",1) 
		s Name=$p(^DHCCTLocM(SuperDeptRowid),"^",2) 
	}
	
	q Code_"^"_Name
}

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).Test()
ClassMethod Test() As %GlobalCharacterStream
{
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	s aa=##class(%GlobalCharacterStream).%New()
	;d aa.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><DepartmentRegisterRt><Departments><Department><CTDCode>liyTest1</CTDCode><CTDDesc>liy测试科室1</CTDDesc><CTDTypeCode>W</CTDTypeCode><CTDGroupCode></CTDGroupCode><CTCPosition></CTCPosition><CTCTelephone>12345678910</CTCTelephone><CTCStatusCode>Y</CTCStatusCode><CTCStartDate>63487</CTCStartDate><CTCEndDate></CTCEndDate></Department><Department><CTDCode>liyTest2</CTDCode><CTDDesc>liy测试科室2</CTDDesc><CTDTypeCode>E</CTDTypeCode><CTDGroupCode></CTDGroupCode><CTCPosition></CTCPosition><CTCTelephone>18791299101</CTCTelephone><CTCStatusCode>N</CTCStatusCode><CTCStartDate></CTCStartDate><CTCEndDate>63489</CTCEndDate></Department></Departments></DepartmentRegisterRt></Body></Request>")
	d aa.Write("<Request><Header/><Body><CT_CityList><CT_City><CTC_Code>310101</CTC_Code><CTC_Desc>黄浦区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310103</CTC_Code><CTC_Desc>卢湾区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310104</CTC_Code><CTC_Desc>徐汇区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310105</CTC_Code><CTC_Desc>长宁区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310106</CTC_Code><CTC_Desc>静安区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310107</CTC_Code><CTC_Desc>普陀区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310108</CTC_Code><CTC_Desc>闸北区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310109</CTC_Code><CTC_Desc>虹口区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310110</CTC_Code><CTC_Desc>杨浦区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310112</CTC_Code><CTC_Desc>闵行区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310113</CTC_Code><CTC_Desc>宝山区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310114</CTC_Code><CTC_Desc>嘉定区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310115</CTC_Code><CTC_Desc>浦东新区(*)</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310116</CTC_Code><CTC_Desc>金山区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310117</CTC_Code><CTC_Desc>松江区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310118</CTC_Code><CTC_Desc>青浦区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310120</CTC_Code><CTC_Desc>奉贤区</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City><CT_City><CTC_Code>310230</CTC_Code><CTC_Desc>崇明县</CTC_Desc><CTC_PCode>310000</CTC_PCode><CTC_CodesystemCode>CT_City</CTC_CodesystemCode><CTC_Status>1</CTC_Status><CTC_UpdateUserCode>无</CTC_UpdateUserCode><CTC_Remarks>无</CTC_Remarks></CT_City></CT_CityList></Body></Request>")
	set tSC=soapObj.SaveManagerDataInfo("CT_City",aa)
	q tSC
}

}
