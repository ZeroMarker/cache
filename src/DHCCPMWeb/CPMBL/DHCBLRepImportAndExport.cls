Class DHCCPMWeb.CPMBL.DHCBLRepImportAndExport Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 根据报表名称判断要导入的报表是否存在。
/// 如果不存在返回："0^^^^^^^^^"
/// 如果存在返回：-1106_"^"_报表报表所在的目录的路径。
ClassMethod CheckImportRep(RepName As %String, RepCatDR As %String) As %String
{
	n (RepName,RepCatDR)
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepImpAndExp).CheckImportRep("test","4")		
	s $ZT="ERROR^DHCSSERR"
	
	s myCurRepRowID=""
	s myCatRowID=RepCatDR
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).CheckCurSelCat(myCatRowID)
	q:(+myrtn) myrtn
	i (myCatRowID="") d
	.s myrtn=-1105	
	q:(+myrtn) myrtn	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckRepName(RepName)
	if (myrtn=-1106)
	{	
		s myrtn = myrtn _"^"_..GetCatPath(RepName)	
	}
	else
	{
		s myrtn="0^^^^^^^^^"
	}
	q myrtn
}

/// 根据报表名称获取报表所在的目录的路径。
/// 返回：mystrId 是由报表上级目录的RowID组成的串，
/// 		 myPath 是由报表上级目录的Name组成的串，
/// 		 RepRowID是报表的RowID。
/// 		 RepName是报表的Name。
/// 
ClassMethod GetCatPath(RepName As %String) As %String
{
	n (RepName)
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepImpAndExp).GetCatPath()
	
	
	//根据报表模版的名称获取它的RowID
	s RepRowID=$O(^DHCCPM.DHCReportsI("RNameIdx", RepName,0))
	s myRepObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	
	s RepCatDR=myRepObj.RepCategoryDR
	s RepCatRowID = RepCatDR.%Id()
	
	s mystrId=RepCatRowID
	s myPath=RepCatDR.RCName
	
	s myCatObj=##class(DHCCPM.DHCReportsCategory).%OpenId(RepCatRowID)	
		
	f  s RepCatDR=myCatObj.RCategoryDR q:RepCatDR=""  d
	.s myobj=RepCatDR.%Id()
	.s mystrId=myobj_"/"_mystrId
	.s myPath=RepCatDR.RCName_"/"_myPath
	.s myCatObj=##class(DHCCPM.DHCReportsCategory).%OpenId(myobj)	
	d myRepObj.%Close()
	;s str=mystrId_"^"_myPath
	s str=mystrId_"/"_RepRowID_"^"_myPath_"/"_myRepObj.RepCaption
	q str
}

/// 导入报表，如果报表不存在，则添加报表，如果存在则更新报表（在原有版本信息上再添加
/// 一个版本。原报表模版如果存在Query类型的Panel，就判断它们是否与导入的Query类型的Panel
/// 相同，如果相同就不添加，不同就添加。）
ClassMethod IMPORTINSERTTest(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As DHCCPMWeb.CPMSevice.entity.DHCEReports
{
	n (Reps)	
	s myrep=""	
	s RepName=Reps.RepName
	s RepCatDR=Reps.RepCategoryDR
	s StrPath=..CheckImportRep(RepName,RepCatDR)
	
	if (StrPath'="0^^^^^^^^^")
	{
		s mystr=0
		TS
		s RepRowId=$O(^DHCCPM.DHCReportsI("RNameIdx",RepName,0))	
		s myobj=##class(DHCCPM.DHCReports).%OpenId(RepRowId)
		
		//根据报表目录名称获取目录的RowID。
		s myCatNameStr=myobj.RepCategoryDR.RCName
		;转换为大写字母；
		s myCatNameStr = $ZConvert(myCatNameStr, "U")
		//必须加一个空格,同时注意Global中字符的大小写问题。
		s myCatName=" "_myCatNameStr			
		s myCatID=$O(^DHCCPM.DHCReportsCategoryI("RCNameIndex", myCatName,0))				 
		s myCatObj=##class(DHCCPM.DHCReportsCategory).%OpenId(myCatID)
		;指引报表目录
		s myobj.RepCategoryDR=myCatObj
		d myCatObj.%Close()
					
			//ld-20080521
			;要根据组件名重新设置组建的ComponentDR
		s myobj.ComponentName=Reps.ComponentName
		s ComponentName=Reps.ComponentName
		s CompName = $ZConvert(ComponentName, "U")
		s myCompDR = $o(^websys.ComponentI("UniqueNameIndex", CompName,0))
		s myobj.ComponentDR=myCompDR
			//ld-20040521
			
		;增加Panels
		s myPCount=Reps.RepPanels.Count()
		for i=1:1:myPCount  d
		.s myepobj=Reps.RepPanels.GetAt(i)
		.;判断Panel是否已存在，如果存在返回 1，不存在返回 0。
		.s mystr=..CheckPanel(RepRowId,myepobj.RPClassName,myepobj.RPQueryName)	
		.i (+mystr=0) d
		.. s mypobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DTOTransObj(myepobj)
		.. d myobj.RepPanels.Insert(mypobj)	
		.. d mypobj.%Close()
		.;关闭Panel对象，注意关闭的顺序（后开先关）。
		.d myepobj.%Close()
		
 		//添加版本信息	
		s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(Reps.ReportsVersion)	
		s myverobj.RVCreateDate=$ZDATEH($ZDATE($HOROLOG))
		s myverobj.RVCreateTime=$ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
		s myverobj.RVStatus = 0
		
		//检查是否有版本信息，如果没有返回 0,如果有返回最大的版本号。
		s NewMaxVersion =..SELECTMAXVERSION(RepRowId)
		if NewMaxVersion=0
		{
			s myverobj.RVVersionNumber = 1
			//将报表的LastVersion指向它的最后版本。
			s myobj.LastVersion = myverobj.RVVersionNumber
		}
		else
		{
			s myverobj.RVVersionNumber = NewMaxVersion + 1
			//将报表的LastVersion指向它的最后版本。
			s myobj.LastVersion = myverobj.RVVersionNumber 
		}
		d myobj.ReportsVersion.Insert(myverobj)
		s myRepVerRowID=myverobj.%Id()
	
		;代表报表的DataSet  Schema
		d Reps.XMLSchemaFile.Rewind()
		d myobj.XMLSchemaFile.CopyFrom(Reps.XMLSchemaFile)
		s mysc=myobj.%Save()
		s myCurRepRowID=myobj.%Id()
	
		d myobj.%Close()
		s myrtn=0
		
		
		
		If $$$ISERR(mysc) {	
   		 	s myrtn=-104	
	    }	
		if (+myrtn=0){
			tc
			s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(myCurRepRowID,myverobj.RVVersionNumber)
		}else{
			tro
		}
	}
	else
	{
		TS
		s myobj=##class(DHCCPM.DHCReports).%New()
		;s myobj.ComponentDR=Reps.ComponentDR
		;要根据组件名重新设置组建的ComponentDR
		s myobj.ComponentName=Reps.ComponentName
		s ComponentName=Reps.ComponentName
		s CompName = $ZConvert(ComponentName, "U")
		s myCompDR = $o(^websys.ComponentI("UniqueNameIndex", CompName,0))
		s myobj.ComponentDR=myCompDR
		
		;s myobj.DateFrom=Reps.DateFrom
		;s myobj.DateTo=Reps.DateTo
		//重新设定报表建立的时间和日期（设为当前时间和日期）。
		s myobj.DateFrom=$ZDATEH($ZDATE($HOROLOG))
		s myobj.DateTo=""
		
		//s myobj.PublishVersion=0
		s myobj.RepCaption=Reps.RepCaption
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
		.s mypobj=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DTOTransObj(myepobj)
		.d myobj.RepPanels.Insert(mypobj)
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
		
		//添加版本信息	
		s myverobj=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DTOTransObj(Reps.ReportsVersion)
		
		//检查是否有版本信息，如果没有返回 0,如果有返回最大的版本号。
		s NewMaxVersion =..SELECTMAXVERSION(myobj.%Id())
		s myverobj.RVCreateDate=$ZDATEH($ZDATE($HOROLOG))
		s myverobj.RVCreateTime=$ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
				
		s myverobj.RVStatus = 0
		if NewMaxVersion=0
		{
			s myverobj.RVVersionNumber = 1
			//将报表的LastVersion指向它的最后版本。
			s myobj.LastVersion = myverobj.RVVersionNumber
		}
		else
		{
			s myverobj.RVVersionNumber = NewMaxVersion + 1
			//将报表的LastVersion指向它的最后版本。
			s myobj.LastVersion = myverobj.RVVersionNumber 
		}
		s myobj.PublishVersion= myobj.LastVersion-1
		d myobj.ReportsVersion.Insert(myverobj)
		s myRepVerRowID=myverobj.%Id()
	
		;代表报表的DataSet  Schema
		d Reps.XMLSchemaFile.Rewind()
		d myobj.XMLSchemaFile.CopyFrom(Reps.XMLSchemaFile)
		s mysc=myobj.%Save()
		s myCurRepRowID=myobj.%Id()
	
		d myobj.%Close()
		s myrtn=0
		
		
		
		If $$$ISERR(mysc) {	
   		 	s myrtn=-104	
	    }	
		if (+myrtn=0){
			tc		
			s myrep=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(myCurRepRowID,myverobj.RVVersionNumber)
		}else{
		
			tro
		}
	}
	
	q myrep
}

/// 获取最大的版本号,如果还没有版本,返回 0 ,如果有则返回最大的版本号.
ClassMethod SELECTMAXVERSION(ATEMPLATEID As %String) As %Integer
{
	
 ;w ##class(DHCCPMWeb.CPMBL.DHCBLRepImportAndExport).SELECTMAXVERSION(ATEMPLATEID)
 new Result	 
 &sql(SELECT Count(RV_VersionNumber)
 into :Result 
 FROM DHCCPM.DHC_ReportsVersion
 WHERE ParRef = :ATEMPLATEID)
 
 if '(Result=0)
 {
 &sql(SELECT MAX(RV_VersionNumber)
 into :Result 
 FROM DHCCPM.DHC_ReportsVersion
 WHERE ParRef = :ATEMPLATEID)
}
 QUIT Result
}

/// 判断导入的Query类型的Panel是否与报表已有的Query类型的Panel相同。
/// 如果相同，返回 1。
/// 不同，返回 0。
ClassMethod CheckPanel(RepRowID As %String, ClassName As %String, QueryName As %String) As %String
{
	n (RepRowID,ClassName,QueryName)
	
	;w ##class(DHCCPMWeb.CPMBL.DHCBLRepImpAndExp).CheckPanel("2","web.DHCOPAdmFind","GetADMOrder")
	;                                                             web.DHCOPAdmFind^  GetADMOrder
	s myrtn=0
	
	s myRepObj=##class(DHCCPM.DHCReports).%OpenId(RepRowID)
	s myPanelCount=myRepObj.RepPanels.Count()
	for i=1:1:myPanelCount q:(+myrtn=1)  d
	.s myPObj=myRepObj.RepPanels.GetAt(i)
	.i ((myPObj.RPClassName=ClassName) && (myPObj.RPQueryName=QueryName)) d
	.. s myrtn=1
	
	q myrtn
}

}
