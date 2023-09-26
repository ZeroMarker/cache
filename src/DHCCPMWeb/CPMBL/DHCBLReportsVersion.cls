Class DHCCPMWeb.CPMBL.DHCBLReportsVersion Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 删除当前版本报表样式表
ClassMethod DELETE(RowID As %String) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DELETE("1||2")
	;删除报表
	;更新Report对象中的
	;LastVersion
	;PublishVersion
	
	n (RowID)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(+RowID)
	q:(myrtn) myrtn
	
	s myrtn=..CheckCurSelVer(RowID)
	
	q:(+myrtn) myrtn
	
	TSTart
	s mySelVerRepobj=##class(DHCCPM.DHCReportsVersion).%OpenId(RowID)
	s mySelVerNum=mySelVerRepobj.RVVersionNumber
	
	s myrepobj=##class(DHCCPM.DHCReports).%OpenId(+RowID)
	s myrepobj.LastVersion=+myrepobj.LastVersion-1
	
	i (mySelVerNum=myrepobj.PublishVersion){
		s myrepobj.PublishVersion=0
	}
	
	Set mysc=##class(DHCCPM.DHCReportsVersion).%DeleteId(RowID)
	
	If $$$ISERR(mysc) {
    	s myrtn=-106
    }
    if (+myrtn=0){
	    d myrepobj.%Save()
    }
	
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn
}

/// 新增一个报表样式表
ClassMethod AddNewVer(RepRowID As %String, RepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).AddNewVer(1,myrepv)
	;增加一个版本
	;修改Report中的LastVersion
	n (RepRowID, RepVer)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(RepRowID)
	q:(myrtn) myrtn
	
	ts
	
	s myRepObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	
	s myRepObj.LastVersion=myRepObj.LastVersion+1
	s myNewRepVer=..DTOTransObj(RepVer)
	
	d myRepObj.ReportsVersion.Insert(myNewRepVer)
	
	s mysc=myRepObj.%Save()
	
	;s myMaxID=myRepObj.ReportsVersion.Count()
	;s myRVRowID=myRepObj.ReportsVersion.GetAt(myMaxID).%Id()
	;获取新增Ver的RowID
	s myRVRowID=myNewRepVer.%Id()
	
	d RepVer.%Close()
	d myNewRepVer.%Close()
	d myRepObj.%Close()
	
	If $$$ISERR(mysc) {
    	s myrtn=-104
    }
	if (+myrtn=0){
		tcommit
	}else{
		tro
	}
	
	q myrtn_"^"_myRVRowID
}

/// 验证当前的样式表是否存在
ClassMethod CheckCurSelVer(RowID As %String) As %String
{
	n (RowID)
	
	s myrtn=0
	s mysrc=##class(DHCCPM.DHCReportsVersion).%ExistsId(RowID)
	i mysrc'=1 d
	.s myrtn=-1102	;
	
	q myrtn
}

/// DTO转换为对象
ClassMethod DTOTransObj(ERepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As DHCCPM.DHCReportsVersion
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj()
	;##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara()
	n (ERepVer)
	
	s ERepVer.RowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ERepVer.RowID)
	
	s myRepVerRowID=ERepVer.RowID
	if (myRepVerRowID'=""){
		s myRepVer=##class(DHCCPM.DHCReportsVersion).%OpenId(myRepVerRowID)
	}else{
		s myRepVer=##class(DHCCPM.DHCReportsVersion).%New()
	}
	
	s myRepVer.RVAuthor=ERepVer.RVAuthor
	s myRepVer.RVCreateDate=ERepVer.RVCreateDate
	s myRepVer.RVCreateTime=ERepVer.RVCreateTime
	
	d ERepVer.RVData.Rewind()
	
	;s ^TMPFFFFFFF=""_ERepVer.RVData.Read()  ;_"^"_myRepVer.RVAuthor
	d ERepVer.RVData.Rewind()
	d myRepVer.RVData.CopyFrom(ERepVer.RVData)
	
	s myRepVer.RVPublicationDate=ERepVer.RVPublicationDate
	s myRepVer.RVPublicationTime=ERepVer.RVPublicationTime
	
	d ERepVer.RVXMLSchemaFile.Rewind()
	d myRepVer.RVXMLSchemaFile.CopyFrom(ERepVer.RVXMLSchemaFile)
	
	s myRepVer.RVStatus=ERepVer.RVStatus
	s myRepVer.RVVersionNumber=ERepVer.RVVersionNumber
	
	q myRepVer
}

/// 得到当前报表最大的版本号
ClassMethod GetCurRepMaxVerNum(RepRowID As %String) As %String
{
	n (RepRowID)
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetCurRepMaxVerNum(1)
	
	;^DHCCPM.DHCReportsD(RepRowID,"ReportsVersion",mySub)
	;
	s myrtn=""
	s myMVNum=""
	s mySub=0
	f  s mySub=$o(^DHCCPM.DHCReportsD(RepRowID,"ReportsVersion",mySub)) q:(mySub="")  d
	.s myVerRowID=RepRowID_"||"_mySub
	.s myobj=##class(DHCCPM.DHCReportsVersion).%OpenId(myVerRowID)
	.s myCVerNum=myobj.RVVersionNumber
	.i (+myMVNum<+myCVerNum)  d
	..s myMVNum=myCVerNum
	.d myobj.%Close()
	
	s myrtn=myMVNum+1
	q myrtn
}

/// 获取一个默认的报表样式对象
ClassMethod GetDefaultVer() As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion
{
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetDefaultVer()
	n (ad)
	
	s myRepVerObj=##class(DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion).%New()
	
	s myRepVerObj.RVAuthor="Default"
	s myRepVerObj.RVCreateDate=+$h
	s myRepVerObj.RVCreateTime=$p($h,",",2)
	;获取系统配置
	d myRepVerObj.RVData.Write("")
	s myRepVerObj.RVStatus=0
	s myRepVerObj.RVVersionNumber=1
	
	q myRepVerObj
}

/// 获取一个默认的报表样式对象
ClassMethod GetNewRepVer(RepRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion
{
	;s myrepv=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetNewRepVer(1)
	n (RepRowID)
	s myRepVerObj=##class(DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion).%New()
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(RepRowID)
	q:(+myrtn'=0) myRepVerObj
	
	s myRepVerObj.ParRef=RepRowID
	s myRepVerObj.RVAuthor="Default"
	s myRepVerObj.RVCreateDate=+$h
	s myRepVerObj.RVCreateTime=$p($h,",",2)
	;获取系统配置
	;s myRepVerObj.RVData.Write()
	s myRepVerObj.RVStatus=0
	s myRepVerObj.RVVersionNumber=..GetCurRepMaxVerNum(RepRowID)
	
	q myRepVerObj
}

/// 得到当前选择的报表格式,附加条件:报表已经被打开的情况,如果报表没有被打开,
/// 着使用Report对象打开,而不是这个
ClassMethod GetSelRepVer(RVRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion
{
	n (RVRowID)
	
	s myobj=..OBJTransDTO(RVRowID)
	
	q myobj
}

/// 更新样式表的信息
ClassMethod UPDATE(RepRowID As %String, RepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String
{
	n (RepRowID, RepVer)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckCurSelRep(RepRowID)
	q:(myrtn) myrtn
	
	s myRepVerRowID=RepVer.RowID
	s myrtn=..CheckCurSelVer(myRepVerRowID)
	
	q:(myrtn) myrtn
	
	ts
	
	s myRepObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	
	s myRepVerRowID=RepVer.RowID
	s myNewRepVer=##class(DHCCPM.DHCReportsVersion).%OpenId(myRepVerRowID)
	
	s myNewRepVer.RVAuthor=RepVer.RVAuthor
	s myNewRepVer.RVCreateDate=RepVer.RVCreateDate
	s myNewRepVer.RVCreateTime=RepVer.RVCreateTime
	
	d myNewRepVer.RVData.Write(RepVer.RVData)
	
	s myNewRepVer.RVPublicationDate=RepVer.RVPublicationDate
	s myNewRepVer.RVPublicationTime=RepVer.RVPublicationTime
	
	d myNewRepVer.RVXMLSchemaFile.Write( RepVer.RVXMLSchemaFile)
	
	s myNewRepVer.RVStatus=RepVer.RVStatus
	s myNewRepVer.RVVersionNumber=RepVer.RVVersionNumber
	
	d myRepObj.ReportsVersion(myNewRepVer)
	
	d myRepObj.%Save()
	
	d myNewRepVer.%Close()
	d myRepObj.%Close()
	
	q myrtn
}

/// 把数据库中的对象转换为DTO
ClassMethod OBJTransDTO(RepVRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion
{
	n (RepVRowID)
	;w ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).OBJTransDTO()
	
	s myrtn=..CheckCurSelVer(RepVRowID)
	q:(+myrtn) myrtn
	
	s myobj=##class(DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion).%New()
	
	s myRepVObj=##class(DHCCPM.DHCReportsVersion).%OpenId(RepVRowID)
	
	s myobj.ParRef=+RepVRowID
	s myobj.RowID=myRepVObj.%Id()
	s myobj.RVAuthor=myRepVObj.RVAuthor
	s myobj.RVCreateDate=myRepVObj.RVCreateDate
	s myobj.RVCreateTime=myRepVObj.RVCreateTime
	
	d myRepVObj.RVData.Rewind()
	d myobj.RVData.CopyFrom(myRepVObj.RVData)
	
	s myobj.RVPublicationDate=myRepVObj.RVPublicationDate
	s myobj.RVPublicationTime=myRepVObj.RVPublicationTime
	
	d myRepVObj.RVXMLSchemaFile.Rewind()
	d myobj.RVXMLSchemaFile.CopyFrom(myRepVObj.RVXMLSchemaFile)
	
	s myobj.RVStatus=myRepVObj.RVStatus
	s myobj.RVVersionNumber=myRepVObj.RVVersionNumber
	
	q myobj
}

}
