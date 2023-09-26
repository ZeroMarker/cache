/// ///保存报表的相关数据
Class DHCCPMWeb.CPMBL.DHCBLReports Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 验证当前的报表是否存在
ClassMethod CheckCurSelRep(RowID As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(RowID)
	n (RowID)
	s myrtn=0
	s mysrc=##class(DHCCPM.DHCReports).%ExistsId(RowID)
	i mysrc'=1 d
	.s myrtn=-1102	;	
	q myrtn
}

/// 验证此报表名称存在
ClassMethod CheckRepName(RepName As %String) As %String
{
	n (RepName)
	;^DHCCPM.DHCReportsI("RNameIdx", RepName, "")
	s myrtn=0
	
	i $d(^DHCCPM.DHCReportsI("RNameIdx", RepName)) d
	.s myrtn=-1106			;名称重复错误
	
	q myrtn
}

ClassMethod DELETE(RowID As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).DELETE(4)
	n (RowID)
	;验证报表是否存在
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	s RowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RowID)
	
	q:(RowID="") myrtn
	s myrtn=..CheckCurSelRep(RowID)
	q:(+myrtn) myrtn
	
	ts
	
	Set mysc=##class(DHCCPM.DHCReports).%DeleteId(RowID)
	
	If $$$ISERR(mysc) {
    	s myrtn=-106
    }
	
	if (+myrtn=0){
		TCommit
	}else{
		tro
	}
	
	QUIT myrtn
}

/// DTO转换为对象
ClassMethod DTOTransObj(ERep As DHCCPMWeb.CPMSevice.entity.DHCEReports) As DHCCPM.DHCReports
{
	n (ERep)
	
	s myRowID=ERep.RowID
	if (myRowID'=""){
		s myrep=##class(DHCCPM.DHCReports).%OpenId(myRowID)
	}else{
		s myrep=##class(DHCCPM.DHCReports).%New()
	}
	;记录一个RowID
	s myrep.ComponentDR=ERep.ComponentDR
	s myrep.ComponentName=ERep.ComponentName
	
	s myrep.DateFrom=ERep.DateFrom
	s myrep.PublishVersion=ERep.PublishVersion
	s myrep.DateTo=ERep.DateTo
	s myrep.RepCaption=ERep.RepCaption
	s myrep.LastVersion=ERep.LastVersion
	s myrep.RepDescription=ERep.RepDescription
	s myrep.RepName=ERep.RepName
	
	q myrep
}

/// 使用组件名称查找当前
ClassMethod GetCompNameByCompDR(ComponentName As %String = "") As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCompNameByCompDR("udhcOPAdmFindCSPTEST")
	;
	n (ComponentName)
	
	s CompName = $ZConvert(ComponentName, "U")
	s myCompDR = $o(^websys.ComponentI("UniqueNameIndex", CompName,0))
	
	q myCompDR
}

ClassMethod INSERT(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).INSERT(myrep)
	;s myrep.ComponentDR="1011"
	;s myrep.RepCategoryDR=1
	n (Reps)
	s $ZT="ERROR^DHCSSERR"
	
	;q:(Reps.RowID'="")
	;1 验证报表目录是否存在
	;2 验证报表名称是否重复
	
	s myCurRepRowID=""
	s myCatRowID=Reps.RepCategoryDR
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).CheckCurSelCat(myCatRowID)
	q:(+myrtn) myrtn
	
	i (myCatRowID="") d
	.s myrtn=-1105
	
	q:(+myrtn) myrtn
	
	s myrtn=..CheckRepName(Reps.RepName)
	
	q:(+myrtn) myrtn
	
	s myCompobj=##class(websys.Component).%OpenId(Reps.ComponentDR)
	s myCompName=myCompobj.Name
	d myCompobj.%Close()
	
	TS
	
	s myobj=##class(DHCCPM.DHCReports).%New()
	;记录一个RowID
	s myobj.ComponentDR=Reps.ComponentDR
	
	s myobj.ComponentName=myCompName
	
	s myobj.DateFrom=Reps.DateFrom
	s myobj.PublishVersion=Reps.PublishVersion
	s myobj.DateTo=Reps.DateTo
	s myobj.RepCaption=Reps.RepCaption
	;把最大版本设置为最后版本
	s mylastVer=Reps.ReportsVersion.RVVersionNumber
	s Reps.LastVersion=mylastVer
	s myobj.LastVersion=Reps.LastVersion
	s myobj.RepName=Reps.RepName
	s myobj.RepDescription=Reps.RepDescription
	
	s myCatObj=##class(DHCCPM.DHCReportsCategory).%OpenId(Reps.RepCategoryDR)
	;指引报表目录
	s myobj.RepCategoryDR=myCatObj
	d myCatObj.%Close()
	
	;增加Panels
	s myPCount=Reps.RepPanels.Count()
	for i=1:1:myPCount  d
	.s myepobj=Reps.RepPanels.GetAt(i)
	.q:(myepobj.RPType'="Q")		;现在只存Query
	.s mypobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DTOTransObj(myepobj)
	.d myobj.RepPanels.Insert(mypobj)
	.;增加Fields
	.;myepobj
	.s myFCount=myepobj.RepFields.Count()
	.f myIdx=1:1:myFCount  d
	..s myefobj=myepobj.RepFields.GetAt(myIdx)
	..s myfobj=##class(DHCCPMWeb.CPMBL.DHCBLRepFields).DTOTransObj(myefobj)
	..d mypobj.RepFields.Insert(myfobj)
	..d myefobj.%Close()
	..d myfobj.%Close()
	.;增加Parameter
	.s myPMCount=myepobj.RepParameters.Count()
	.f myIdx=1:1:myPMCount  d
	..s myepmobj=myepobj.RepParameters.GetAt(myIdx)
	..s mypmobj=##class(DHCCPMWeb.CPMBL.DHCBLRepParameters).DTOTransObj(myepmobj)
	..d mypobj.RepParameters.Insert(mypmobj)
	..d myepmobj.%Close()
	..d mypmobj.%Close()
	.;关闭Panel对象
	.d myepobj.%Close()
	.d mypobj.%Close()
	
	;保存报表的样式表
	;s myVCount=Reps.ReportsVersion.Count()
	s myVCount=0
	
	f i=1:1:myVCount  d
	.s myeverobj=Reps.ReportsVersion.GetAt(i)
	.s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(myeverobj)
	.d myobj.ReportsVersion.Insert(myverobj)
	.d myeverobj.%Close()
	.d myverobj.%Close()
	
	s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(Reps.ReportsVersion)
	d myobj.ReportsVersion.Insert(myverobj)
	s myRepVerRowID=myverobj.%Id()
	
	;代表报表的DataSet  Schema
	d Reps.XMLSchemaFile.Rewind()
	d myobj.XMLSchemaFile.CopyFrom(Reps.XMLSchemaFile)
	b	;save
	s mysc=myobj.%Save()
	
	s myCurRepRowID=myobj.%Id()
	
	d myobj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	Quit myrtn_"^"_myCurRepRowID_"^"_myRepVerRowID
}

/// 更新数据类型对照 Success=0  fail<>0
ClassMethod UPDATE(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As %String
{
	n (Reps)
	;判断报表是否存在
	;否则更新失败
	;$IsObject
	;RepDataCont.RowID
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).UPDATE()
	s $ZT="ERROR^DHCSSERR"
	
	s myRowID=Reps.RowID
	s myrtn=..CheckCurSelRep(myRowID)
	q:(+myrtn) myrtn
	;s ^TMPReps=Reps
	
	TS
	
	s myobj=..DTOTransObj(Reps)
	;记录一个RowID
	
	s myCatObj=##class(DHCCPM.DHCReportsCategory).%OpenId(Reps.RepCategoryDR)
	;指引报表目录
	s myobj.RepCategoryDR=myCatObj
	d myCatObj.%Close()
	
	;增加Panels
	s myPCount=Reps.RepPanels.Count()
	for i=1:1:myPCount  d
	.s myepobj=Reps.RepPanels.GetAt(i)
	.q:(myepobj.RPType'="Q")		;现在只存Query
	.s mypobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DTOTransObj(myepobj)
	.d mypobj.%Save()
	.;增加Fields
	.;myepobj
	.s myFCount=myepobj.RepFields.Count()
	.f myIdx=1:1:myFCount  d
	..s myefobj=myepobj.RepFields.GetAt(myIdx)
	..s myfobj=##class(DHCCPMWeb.CPMBL.DHCBLRepFields).DTOTransObj(myefobj)
	..
	..;d mypobj.RepFields.Insert(myfobj)
	..d myefobj.%Close()
	..d myfobj.%Close()
	.;增加Parameter
	.s myPMCount=myepobj.RepParameters.Count()
	.f myIdx=1:1:myPMCount  d
	..s myepmobj=myepobj.RepParameters.GetAt(myIdx)
	..s mypmobj=##class(DHCCPMWeb.CPMBL.DHCBLRepParameters).DTOTransObj(myepmobj)
	..;d mypobj.RepParameters.Insert(mypmobj)
	..d myepmobj.%Close()
	..d mypmobj.%Close()
	.;关闭Panel对象
	.d myepobj.%Close()
	.d mypobj.%Close()
	
	;保存报表的样式表
	;s myVCount=Reps.ReportsVersion.Count()
		s myVCount=0
		
		f i=1:1:myVCount  d
		.s myeverobj=Reps.ReportsVersion.GetAt(i)
		.s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(myeverobj)
		.;d myobj.ReportsVersion.Insert(myverobj)
		.d myeverobj.%Close()
		.d myverobj.%Close()
	
	if ($IsObject(Reps.ReportsVersion)){
		
		s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(Reps.ReportsVersion)
	}
	s mysc=myverobj.%Save()
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	
	;版本号码
	s myrtnvernum=Reps.ReportsVersion.RVVersionNumber
	
	;代表报表的DataSet  Schema
	d Reps.XMLSchemaFile.Rewind()
	d myobj.XMLSchemaFile.CopyFrom(Reps.XMLSchemaFile)
	if (+myrtn=0){
		;b	;save
		s mysc=myobj.%Save()
		
		s myCurRepRowID=myobj.%Id()
	}
	
	d myobj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	Quit myrtn_"^"_myCurRepRowID
}

ClassMethod GetPublicVerByRepName(RepName As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	;1.验证当前的报表是否存在
	;s myobj=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetPublicVerByRepName("udhcOPAdmFindCSPTEST")
	;
	n (RepName)
	s $ZT="ERROR^DHCSSERR"
	
	s RepName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepName)
	
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.DHCEReports).%New()
	
	s myrtn=..CheckRepName(RepName)
	q:(+myrtn=0) myrtn
	
	;^DHCCPM.DHCReportsI("RNameIdx", RepName)
	s myRepRowID=$o(^DHCCPM.DHCReportsI("RNameIdx", RepName, 0))
	q:(myRepRowID="") myrtn
	
	s myrtn=..CheckCurSelRep(myRepRowID)
	q:(+myrtn'=0) myrtn
	
	s myReportObj=##class(DHCCPM.DHCReports).%OpenId(myRepRowID)
	s myPublicVerNum=myReportObj.PublishVersion
	b
	q:(+myPublicVerNum<=0) -1107			;没有发布
	
	d myobj.%Close()
	d myReportObj.%Close()
	///s myPublicVerRep=..GetCurVerRep(myRepRowID, myPublicVerNum)//2008.03.01
	s myPublicVerRep=..GetCurVerRep(myRepRowID, myPublicVerNum)
	q myPublicVerRep
}

ClassMethod GetCurVerRep(RepRowID As %String, VerNum As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(20,1)
	;s rtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(1,1)
	;加载当前版本的模版；
	;加载Panel： 系统的Panel，对应组件Panel，对应Query的 Panel
	;加载panel下的Fields
	;Fields包含：
	;
	n (RepRowID, VerNum, myRep)
	s $ZT="ERROR^DHCSSERR"
	S ^Test1=VerNum
	s RepRowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepRowID)
	s VerNum=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(VerNum)
	s ^Test1=^Test1_"^"_VerNum
	s myrtn=..CheckCurSelRep(RepRowID)
	q:(+myrtn) myrtn
	
	;s myRep=##class(DHCCPMWeb.CPMSevice.entity.DHCEReports).%New()
	s myobj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
		
	s myRep=..OBJTransDTO(RepRowID)

	;加载Sys Panel
	s mysyspanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetDefaultSysPanel()
	d myRep.RepPanels.Insert(mysyspanel)

	
	;加载组件的Panel
	s myComDR=myRep.ComponentDR
	s myCompName = myRep.ComponentName
	;s myecompanelobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompDR("",myComDR,"")
	
	s myecompanelobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompName("",myCompName,"")
	d myRep.RepPanels.Insert(myecompanelobj)
	
	///s myRep.RepCategoryDR=myobj.RepCategoryDR
	;把Panel属性分别赋给Rep对象
	s myPCount=myobj.RepPanels.Count()
	f i=1:1:myPCount  d
	.s mypanelobj=myobj.RepPanels.GetAt(i)
	.s myclsname=mypanelobj.RPClassName
	.s myqueryname=mypanelobj.RPQueryName
	.s myprowid=mypanelobj.%Id()
	.s myExpStr=""
	.s myepanelobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByClsQuery(myprowid,myclsname,myqueryname,myExpStr)
	.d myRep.RepPanels.Insert(myepanelobj)
	
	;s myRep.RepPanels=myobj.RepPanels
	
	s myVCount=myobj.ReportsVersion.Count()
	f i=1:1:myVCount d
	.s myverobj=myobj.ReportsVersion.GetAt(i)
	.s myVRowID=myverobj.%Id()
	.s myVerNum=myverobj.RVVersionNumber
	.q:(VerNum'=myVerNum)
	.s myerepverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).OBJTransDTO(myVRowID)
	.s myRep.ReportsVersion=myerepverobj
	
	Q myRep
	/*
	.s myverobj=myobj.ReportsVersion.GetAt(i)
	.s myVRowID=myverobj.%Id()
	.s myVerNum=myverobj.RVVersionNumber
	.s str=$Extract(myVRowID,$Find(myVRowID,"|")+1,$Length(myVRowID))
	.;q:(VerNum'=myVerNum) //2008.03.02 lidong,根据报表的RowId获取报表。
	.q:(VerNum'=str)
	.s myerepverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).OBJTransDTO(myVRowID)
	.s myRep.ReportsVersion=myerepverobj
	.*/
}

/// 返回给客户端一个默认的空白报表，这个报表在数据库中不存在的
/// 需要输入的参数：
/// 名称
/// 标题
/// 描述等
/// 返回 DHCEReports 对象
ClassMethod GetDefaultRep(RepName As %String, RepCaption As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetDefaultRep("abc","abcd")
	n (RepName, RepCaption, RepDesc)
	
	s RepName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepName)
	s RepCaption=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepCaption)
	
	;提供Rep对象
	;提供一个系统Panel对象
	;提供一个RepVer报表
	
	s myRep=##class(DHCCPMWeb.CPMSevice.entity.DHCEReports).%New()
	s myRep.RepCaption=RepCaption
	s myRep.RepName=RepName
	s myRep.DateFrom=+$h
	s myRep.PublishVersion=0
	s myRep.LastVersion=1
	
	s myPanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetDefaultSysPanel()
	
	d myRep.RepPanels.Insert( myPanel)
	
	s myRepVerObj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetDefaultVer()
	
	s myRep.ReportsVersion=myRepVerObj
	
	q myRep
}

ClassMethod GetReportForExportOut(RepRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetReportForExportOut(13)
	n (RepRowID)
	
	s RepRowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepRowID)
	
	s myReportObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	s myPublicVerNum=myReportObj.PublishVersion
	
	if (+myPublicVerNum<=0){
		;如果没有发布， 获取最后一个版本的
		
	}
	
	d myReportObj.%Close()
	
	s myPublicVerRep=..GetCurVerRep(RepRowID, myPublicVerNum)
	
	q myPublicVerRep
}

/// 获取一个单独的Report对象  不包含子对象
ClassMethod GetSingleRep(RepRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetSingleRep(1)
	n (RepRowID)
	s RepRowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepRowID)
	
	s myobj=..OBJTransDTO(RepRowID)
	
	q myobj
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO(RepRowID) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	n (RepRowID)
	;s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).OBJTransDTO(1)
	
	s myrep=##class(DHCCPMWeb.CPMSevice.entity.DHCEReports).%New()
	
	s myRepObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	
	s myrep.RowID=RepRowID
	;记录一个RowID
	s myrep.ComponentDR=myRepObj.ComponentDR
	s myrep.ComponentName=myRepObj.ComponentName
	
	s myrep.DateFrom=myRepObj.DateFrom
	s myrep.PublishVersion=myRepObj.PublishVersion
	s myrep.DateTo=myRepObj.DateTo
	s myrep.RepCaption=myRepObj.RepCaption
	s myrep.LastVersion=myRepObj.LastVersion
	s myrep.RepCaption=myRepObj.RepCaption
	s myrep.RepDescription=myRepObj.RepDescription
	s myrep.RepName=myRepObj.RepName
	s myrep.RepCategoryDR=myRepObj.RepCategoryDR.%Id()
	;
	d myRepObj.XMLSchemaFile.Rewind()
	d myrep.XMLSchemaFile.CopyFrom(myRepObj.XMLSchemaFile)
	
	d myRepObj.%Close()
	
	q myrep
}

/// 发布当前的报表格式
ClassMethod PublishVersion(RepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String
{
	;s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).PublishVersion(myver)
	n (RepVer)
	s $ZT="ERROR^DHCSSERR"
	;Report更新
	;RepVer新报表更新
	;原发布报表更新
	
	s myRepRowID=RepVer.ParRef
	
	ts
	
	s myrtn=0
	s myVerNum=RepVer.RVVersionNumber
	
	s Repobj=##class(DHCCPM.DHCReports).%OpenId(myRepRowID)
	
	s myVerNum=Repobj.PublishVersion
	s Repobj.PublishVersion=RepVer.RVVersionNumber	; myVerNum
	
	;更新原来Ver的状态
	if ((+myrtn=0)&(+myVerNum'=0)){
		;^DHCCPM.DHCReportsD(4,"ReportsVersion",2)
		s myVerSub=0
		;f  s myVerSub=$o(^DHCCPM.DHCReportsD(myRepRowID,"ReportsVersion",myVerSub)) q:(myVerSub="")  d
		s myVerCount=Repobj.ReportsVersion.Count()
		f i=1:1:myVerCount  d
		.s myoldVer=Repobj.ReportsVersion.GetAt(i)
		.s myoldNum=myoldVer.RVVersionNumber
		.q:(myVerNum'=myoldNum)
		.;s myoldVer.RVStatus=1
		.;s myoldVer.RVPublicationDate=""
		.;s myoldVer.RVPublicationTime=""
	}
	
	s mysc=Repobj.%Save()
	
	d Repobj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-105
    }
    
	if (+myrtn=0){
		;
		s RepVer.RVStatus=2
		s RepVer.RVPublicationDate=+$h
		s RepVer.RVPublicationTime=$p($h,",",2)
		
		s myRVObj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(RepVer)
		s mysc=myRVObj.%Save()
		d myRVObj.%Close()
		If $$$ISERR(mysc) {
	    	s myrtn=-105
	    }
	}
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn
}

}
