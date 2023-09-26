Class web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-04
/// Description：科室部门组集合信息
/// Table：RBC_DepartmentGroup
/// Input： 
/// Return：科室部门组集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup).GetCTDeptDepartmentGroup("1").Read()
ClassMethod GetCTDeptDepartmentGroup(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTDeptDepartmentGroupByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-04
/// Description：科室部门组集合信息
/// Table：RBC_DepartmentGroup
/// Input： 
/// Return：科室部门组集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup).SendCTDeptDepartmentGroup("")
ClassMethod SendCTDeptDepartmentGroup(input As %String = "") As %GlobalCharacterStream
{
	s $zt="Exception"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	set rowid="0" f  set rowid=$o(^RBC("DEP",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTDeptDepartmentGroupByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptDepartmentGroup",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTDeptDepartmentGroupByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptDepartmentGroup",tSC)
	
	q "0" ;sc
#;	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptDepartmentGroup).%New()
#;	.set insObj.CTDDGCode=$p($g(^RBC("DEP",rowid)),"^",1)
#;	.set insObj.CTDDGDesc=$p($g(^RBC("DEP",rowid)),"^",2)
#;	.set insObj.CTDDGCodesystemCode="CT_DeptDepartmentGroup"
#;	.set insObj.CTDDGCreatDate=$p($g(^RBC("DEP",rowid)),"^",3)
#;	.set insObj.CTDDGStartDate=$p($g(^RBC("DEP",rowid)),"^",3)
#;	.set hospId=$o(^CT("HOSP","0"))
#;	.set hospCode=$p(^CT("HOSP",hospId),"^",1)	
#;	.set insObj.CTDDGHosCode=hospCode
#;	.set insObj.CTDDGStatus="1"
#;	.d ListInfo.CTDeptDepartmentGroup.Insert(insObj)
#;	d ListInfo.XMLExportToString(.String)
#;	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptDepartmentGroup",.Jsonobj)
#;	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
#;	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptDepartmentGroup",JsonString)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
#;	if resultCode=0 d
#;	.set success=0
#;	else  d
#;	.set success=-1
#;	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回科室部门组字典密文流
/// Table：RBC_DepartmentGroup
/// Input： Array集合
/// Return：科室部门组密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTDeptDepartmentGroupByID()
ClassMethod GetCTDeptDepartmentGroupByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptDepartmentGroup).%New()
		set insObj.businessrowid=rowid
		set insObj.CTDDGCode=$p($g(^RBC("DEP",rowid)),"^",1)
		set insObj.CTDDGDesc=$p($g(^RBC("DEP",rowid)),"^",2)
		set insObj.CTDDGCodesystemCode="CT_DeptDepartmentGroup"
		set insObj.CTDDGCreatDate=$p($g(^RBC("DEP",rowid)),"^",3)
		set insObj.CTDDGStartDate=$p($g(^RBC("DEP",rowid)),"^",3)
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set insObj.CTDDGHosCode=hospId //hospCode
		set insObj.CTDDGStatus="1"
		d ListInfo.CTDeptDepartmentGroup.Insert(insObj)
		;b ;insobj
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptDepartmentGroup",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptDepartmentGroup",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
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

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetDeptDescription(39)
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
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetFirstGradeDept(1)
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
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetSuperGradeDept(1)
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

}
