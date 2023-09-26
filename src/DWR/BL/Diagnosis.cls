Class DWR.BL.Diagnosis Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.Diagnosis).GetAdmDiagnos(Param)
ClassMethod GetAdmDiagnos(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:($G(admId)="") "201^入参不完整!"
	s mrAdmId=$P($G(^PAADM(admId)),"^",61)
	q:mrAdmId="" "202^诊断信息不存在!"
	s mrChildSub=""
	f  s mrChildSub=$O(^MR(mrAdmId,"DIA",mrChildSub)) q:mrChildSub=""  d
	.q:mrChildSub=0
	.s mrDiaStr=$G(^MR(mrAdmId,"DIA",mrChildSub))
	.q:mrDiaStr=""
	.s diaId=mrAdmId_"||"_mrChildSub
	.s diaICDId=$P(mrDiaStr,"^",1)
	.i diaICDId'="" s diaDesc=$P($G(^MRC("ID",diaICDId)),"^",2)
	.e  s diaDesc=""
	.s diaNote=""
	.s mrDiaNoteId=""
	.f  s mrDiaNoteId=$O(^MR(mrAdmId,"DIA",mrChildSub,"DES",mrDiaNoteId)) q:mrDiaNoteId=""  d
	..q:mrDiaNoteId=0
	..s mrDiaNote=$G(^MR(mrAdmId,"DIA",mrChildSub,"DES",mrDiaNoteId))
	..s mrDiaNote=$TR(mrDiaNote," ")
	..q:mrDiaNote=""
	..i diaNote="" s diaNote=mrDiaNote
	..e  s diaNote=diaNote_","_mrDiaNote
	.//i diaNote'="" s diaDesc=diaDesc_" "_diaNote
	.s diaDoctorId=$P(mrDiaStr,"^",4)
	.i diaDoctorId'="" s diaDoctor=$P($G(^CTPCP(diaDoctorId,1)),"^",2)
	.e  s diaDoctor=""
	.s diaDate=$P(mrDiaStr,"^",7)
	.i +diaDate>0 s diaDate=$ZD(diaDate,3)
	.s diaTime=$P(mrDiaStr,"^",8)
	.i +diaTime>0 s diaTime=$ZT(diaTime)
	.s typeSub=$O(^MR(mrAdmId,"DIA",mrChildSub,"TYP","0"))
	.s diaType=""
	.i typeSub'="" d
	..s diaTypeID=$P(^MR(mrAdmId,"DIA",mrChildSub,"TYP",typeSub),"^",1)
	..s diaType=$P($G(^MRC("DTYP",diaTypeID)),"^",2)
	.q:(diaDesc="")&&(diaNote="")
	.s myobj=##class(DWR.MSG.Diagnosis).%New()
	.s myobj.diaId=diaId
	.i diaDesc="" s diaDesc=$C(0)
	.s myobj.diaDesc=diaDesc
	.s myobj.diaNote=diaNote
	.s myobj.diaType=diaType
	.i diaDoctor="" s diaDoctor=$C(0)
	.s myobj.diaDoctor=$P(diaDoctor,"-")
	.s myobj.diaDate=diaDate
	.s myobj.diaTime=diaTime
	.d myobj.%Close()
	.s Xml=""
	.s ret=myobj.XMLExportToString(.Xml,"Diagnosis")
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

// w ##Class(DWR.BL.Diagnosis).GetRecDiagnos()

ClassMethod GetRecDiagnos(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:($G(admId)="") "201^入参不完整!"
	s diaCount=0
	s patId=$P($G(^PAADM(admId)),"^",1)
	q:patId="" "202^患者信息不存在!"
	s admType=""
	f  s admType=$O(^PAPERdr(patId,"ADM",admType)) q:admType=""  d
	.s recAdmId=""
	.f  s recAdmId=$O(^PAPERdr(patId,"ADM",admType,recAdmId),-1) q:recAdmId=""  d
	..q:+recAdmId=0
	..q:recAdmId=admId
	..s mrAdmId=$P($G(^PAADM(recAdmId)),"^",61)
	..q:mrAdmId=""
	..s mrChildSub=""
	..f  s mrChildSub=$O(^MR(mrAdmId,"DIA",mrChildSub)) q:mrChildSub=""  d
	...q:mrChildSub=0
	...s mrDiaStr=$G(^MR(mrAdmId,"DIA",mrChildSub))
	...q:mrDiaStr=""
	...s diaId=mrAdmId_"||"_mrChildSub
	...s diaICDId=$P(mrDiaStr,"^",1)
	...i diaICDId'="" s diaDesc=$P($G(^MRC("ID",diaICDId)),"^",2)
	...e  s diaDesc=""
	...s diaNote=""
	...s mrDiaNoteId=""
	...f  s mrDiaNoteId=$O(^MR(mrAdmId,"DIA",mrChildSub,"DES",mrDiaNoteId)) q:mrDiaNoteId=""  d
	....q:mrDiaNoteId=0
	....s mrDiaNote=$G(^MR(mrAdmId,"DIA",mrChildSub,"DES",mrDiaNoteId))
	....s mrDiaNote=$TR(mrDiaNote," ")
	....q:mrDiaNote=""
	....i diaNote="" s diaNote=mrDiaNote
	....e  s diaNote=diaNote_","_mrDiaNote
	...s diaDoctorId=$P(mrDiaStr,"^",4)
	...i diaDoctorId'="" s diaDoctor=$P($G(^CTPCP(diaDoctorId,1)),"^",2)
	...e  s diaDoctor=""
	...s diaDate=$P(mrDiaStr,"^",7)
	...i +diaDate>0 s diaDate=$ZD(diaDate,3)
	...s diaTime=$P(mrDiaStr,"^",8)
	...i +diaTime>0 s diaTime=$ZT(diaTime)
	...s typeSub=$O(^MR(mrAdmId,"DIA",mrChildSub,"TYP","0"))
	...s diaType=""
	...i typeSub'="" d
	....s diaTypeID=$P(^MR(mrAdmId,"DIA",mrChildSub,"TYP",typeSub),"^",1)
	....s diaType=$P($G(^MRC("DTYP",diaTypeID)),"^",2)
	...q:(diaDesc="")&&(diaNote="")
	...s myobj=##class(DWR.MSG.Diagnosis).%New()
	...s myobj.diaId=diaId
	...i diaDesc="" s diaDesc=$C(0)
	...s myobj.diaDesc=diaDesc
	...s myobj.diaNote=diaNote
	...s myobj.diaType=diaType
	...s myobj.diaDoctor=$P(diaDoctor,"-")
	...s myobj.diaDate=diaDate
	...s myobj.diaTime=diaTime
	...d myobj.%Close()
	...s Xml=""
	...s ret=myobj.XMLExportToString(.Xml,"Diagnosis")
	...q:diaCount>50
	...i ret=1 s retStr=retStr_Xml
	...s diaCount=diaCount+1
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).GetDiagType()
ClassMethod GetDiagType(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:($G(admId)="") "201^入参不完整!"
	s diagTypeId=""  f  s diagTypeId=$O(^MRC("DTYP",diagTypeId)) q:diagTypeId=""  d
	.q:+diagTypeId=0
	.s diagTypeCode=$P($G(^MRC("DTYP",diagTypeId)),"^",1)
	.s diagTypeDesc=$P($G(^MRC("DTYP",diagTypeId)),"^",2)
	.s diagTypeDesc=$P(diagTypeDesc,"-")
	.s myObj=##class(DWR.MSG.DiagType).%New()
	.s myObj.diagTypeId=diagTypeId
	.s myObj.diagTypeCode=diagTypeCode
	.s myObj.diagTypeDesc=diagTypeDesc
	.d myObj.%Close()
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).GetDiagStatus()
ClassMethod GetDiagStatus(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:($G(admId)="") "201^入参不完整!"
	s diagStatId=""  f  s diagStatId=$O(^MRC("DSTAT",diagStatId)) q:diagStatId=""  d
	.q:+diagStatId=0
	.s diagStatCode=$P($G(^MRC("DSTAT",diagStatId)),"^",1)
	.s diagStatDesc=$P($G(^MRC("DSTAT",diagStatId)),"^",2)
	.s myObj=##class(DWR.MSG.DiagStatus).%New()
	.s myObj.diagStatId=diagStatId
	.s myObj.diagStatCode=diagStatCode
	.s myObj.diagStatDesc=diagStatDesc
	.d myObj.%Close()
	.s Xml=""
	.s ret=myObj.XMLExportToString(.Xml)
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).GetDiagTabs()
ClassMethod GetDiagTabs(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><departmentId>839</departmentId><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(departmentId)="" "203^科室Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s tabUserNode="USER"
	s tabLocNode="CTLOC"
	s nodeIndex=""
	f  s nodeIndex=$O(^DHCDIAMAS(tabUserNode,userId,nodeIndex)) q:nodeIndex=""  d
	.q:+nodeIndex=0
	.s tabId=""
	.f  s tabId=$O(^DHCDIAMAS(tabUserNode,userId,nodeIndex,tabId)) q:tabId=""  d
	..q:+tabId=0
	..s tabName=$P($G(^DHCDIAMAS(tabId)),"^",2)
	..q:tabName=""
	..s myObj=##class(DWR.MSG.DiagTabs).%New()
	..s myObj.tabId=tabId
	..s myObj.tabName=tabName
	..s Xml=""
	..s ret=myObj.XMLExportToString(.Xml)
	..i ret=1 s retStr=retStr_Xml
	q:retStr'="" retStr
	s nodeIndex=""
	f  s nodeIndex=$O(^DHCDIAMAS(tabLocNode,departmentId,nodeIndex)) q:nodeIndex=""  d
	.q:+nodeIndex=0
	.s tabId=""
	.f  s tabId=$O(^DHCDIAMAS(tabLocNode,departmentId,nodeIndex,tabId)) q:tabId=""  d
	..q:+tabId=0
	..s tabName=$P($G(^DHCDIAMAS(tabId)),"^",2)
	..q:tabName=""
	..s myObj=##class(DWR.MSG.DiagTabs).%New()
	..s myObj.tabId=tabId
	..s myObj.tabName=tabName
	..s Xml=""
	..s ret=myObj.XMLExportToString(.Xml)
	..i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).GetDiagTabList()
ClassMethod GetDiagTabList(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><tabId>447</tabId><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s tabId=request.tabId
	   s tabId=$TR(tabId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(tabId)="" "203^诊断模板页签Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s listNum=""
	f  s listNum=$O(^DHCDIAICD("MASTER",tabId,listNum)) q:listNum=""  d
	.s listIndex=""
	.f  s listIndex=$O(^DHCDIAICD("MASTER",tabId,listNum,listIndex)) q:listIndex=""  d
	..s diaTabDetailId=""
	..f  s diaTabDetailId=$O(^DHCDIAICD("MASTER",tabId,listNum,listIndex,diaTabDetailId)) q:diaTabDetailId=""  d
	...q:+diaTabDetailId=0
	...s diagICDId=$P($G(^DHCDIAICD(diaTabDetailId)),"^",3)
	...q:diagICDId=""
	...s diagICDDesc=$P($G(^MRC("ID",diagICDId)),"^",2)
	...q:diagICDDesc=""
	...s myObj=##class(DWR.MSG.DiagTabs).%New()
	...s myObj.diagICDId=diagICDId
	...s myObj.diagICDDesc=diagICDDesc
	...s Xml=""
	...s ret=myObj.XMLExportToString(.Xml)
	...i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).GetDiagList()
ClassMethod GetDiagList(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><departmentId>839</departmentId><diagCode>gm</diagCode><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s diagCode=request.diagCode
	   s diagCode=$TR(diagCode,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(diagCode)="" "203^诊断检索码不能为空!"
    s queryName="web.DHCMRDiagnos:LookUpWithAlias"
    s resSet = ##class(%ResultSet).%New(queryName)
    s columns = resSet.GetColumnCount()
    s sc = resSet.Execute(diagCode,departmentId,"")
    q:sc=0 "206^查询失败!"
   	s showIndex=0
   	While (resSet.Next()) {
	   	if showIndex>50  q
		s myObj=##class(DWR.MSG.DiagItem).%New()
		s showIndex=showIndex+1
		s diagICDId=resSet.GetData(2)
		s myObj.diagICDId=diagICDId
		s diagICDDesc=resSet.GetData(1)
		s myObj.diagICDDesc=diagICDDesc
		s Xml=""
		s ret=myObj.XMLExportToString(.Xml)
		i ret=1 s retStr=retStr_Xml
 	}
	q retStr
}

/// w ##Class(DWR.BL.Diagnosis).InsertDiag(Param)
ClassMethod InsertDiag(Param As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	s retStr=""
	i Param="" s Param="<Request><diagICDId>4805</diagICDId><departmentId>839</departmentId><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s diagICDId=request.diagICDId
	   s diagICDId=$TR(diagICDId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	   s diagTypeId=request.diagTypeId
	   s diagTypeId=$TR(diagTypeId,$C(0))
	   s diagNote=request.diagNote
	   s diagNote=$TR(diagNote,$C(0))
	   s diagStatId=request.diagStatId
	   s diagStatId=$TR(diagStatId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(diagICDId)="" "203^诊断Id不能为空!"
	q:$G(departmentId)="" "204^科室Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s diagTypeDesc=""
	i diagTypeId'="" d
	.s diagTypeDesc=$P($G(^MRC("DTYP",diagTypeId)),"^",2)
	s diagStatDesc=""
	i diagStatId'="" d
	.s diagStatDesc=$P($G(^MRC("DSTAT",diagStatId)),"^",2)
	s mrAdmId=$P($G(^PAADM(admId)),"^",61)
	q:mrAdmId="" "205^诊断信息不存在!"
	s insertRet=##Class(web.DHCMRDiagnos).InsertMRDiagnos(departmentId,mrAdmId,diagICDId,userId, diagNote,diagTypeDesc,diagStatDesc)
	i insertRet>0 q "0^诊断插入成功!"
	q "200^诊断插入失败!"
}

/// /web.DHCMRDiagnos
/// w ##Class(DWR.BL.Diagnosis).UpdateDiagNote()
ClassMethod UpdateDiagNote(Param As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	s retStr=""
	i Param="" s Param="<Request><diagNote>诊断备注</diagNote><diagId>99948||2</diagId><departmentId>839</departmentId><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s diagId=request.diagId
	   s diagId=$TR(diagId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	   s diagNote=request.diagNote
	   s diagNote=$TR(diagNote,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(diagId)="" "203^诊断Id不能为空!"
	q:$G(diagNote)="" "204^诊断备注不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s updateRet=##Class(web.DHCMRDiagnos).UpdateMRDiagnosNote(diagId,diagNote)
	i updateRet=0 q "0^诊断备注更新成功!"
	q "200^诊断备注更新失败!错误代码:"_updateRet
}

/// w ##Class(DWR.BL.Diagnosis).DeleteDiag()
ClassMethod DeleteDiag(Param As %String = "") As %String
{
	//q "100^此模块暂时不开放!"
	s retStr=""
	i Param="" s Param="<Request><diagId>99948||2</diagId><departmentId>839</departmentId><userCode>030414</userCode><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s userCode=request.userCode
	   s userCode=$TR(userCode,$C(0))
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s diagId=request.diagId
	   s diagId=$TR(diagId,$C(0))
	   s departmentId=request.departmentId
	   s departmentId=$TR(departmentId,$C(0))
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(admId)="" "202^就诊Id不能为空!"
	q:$G(diagId)="" "203^诊断Id不能为空!"
	s userCode=$ZConvert(userCode,"U")
	s userId=$order(^SSU("SSUSR",0,"SSUSR_Initials",userCode,"0"))
	s deleteRet=##Class(web.DHCMRDiagnos).DeleteMRDiagnos(diagId)
	i deleteRet=0 q "0^诊断删除成功!"
	i deleteRet="Discharged" q "300^删除失败,患者已经结算!"
	i deleteRet="Timeout" q "301^删除失败超出可删除的时间范围!"
	q "302^删除失败,错误代码:"_updateRet
}

}
