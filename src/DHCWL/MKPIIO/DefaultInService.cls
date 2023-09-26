Class DHCWL.MKPIIO.DefaultInService Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(DHCWL.MKPIIO.DefaultInService).JsonKpi("C:\Users\Administrator\Desktop\2013-09-11 161436outputKpis.xml",.arr)

//reader as %XML.TextReader,

ClassMethod JsonKpi(xmlPath, ByRef mkpiArr, checkFlag As %Boolean = 0)
{
	n (xmlPath,mkpiArr,checkFlag)
	k mkpiArr
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	
	s version=##class(DHCWL.MKPIIO.util.Read).GetXmlVersion(xmlPath)
	if ($d(^DHCWL.MKPI.SetConfig("NewIOConfigVersion"))) s ioConfigVersion=^DHCWL.MKPI.SetConfig("NewIOConfigVersion")
	else  s ioConfigVersion=3.22
	if (version<ioConfigVersion){
		 d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked(xmlPath,checkFlag)
		 q
	}
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				if (cnt>=3){
					if (reader.MoveToAttributeName("ClassFullName")){
						s class=reader.Value
						if (reader.MoveToAttributeName("PrimaryFieldValue")){
							s primaryValue=reader.Value
							s mkpiArr(class,primaryValue)=""
							if (class="DHCWL.MKPI.MKPI"){
								s mkpiCode=primaryValue
							}
						}
					}
				}
				d reader.MoveToElement()
	   		}
		}elseif (reader.NodeType="chars"){
			if (nodeName="MKPIName"){
				s mkpiArr("DHCWL.MKPI.MKPI",mkpiCode)=reader.Value
			}
		}
	}
	if (checkFlag){
		s num=0
		w "{success:true,root:["
		s mkpi=""
		f {
			s mkpi=$o(mkpiArr("DHCWL.MKPI.MKPI",mkpi))
			q:mkpi=""
			s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
			if (mkpiId'=""){
				i num>0 w ","
				w "{className:'DHCWL.MKPI.MKPI',propertyCode:'"_mkpi_"',codeValue:'"_mkpi_"',id:'"_mkpiId_"'}"
				s num=num+1
			}
		}
		w "],totalNum:"_num_"}"
		q
	}
	s mkpi="",count=0
	w "["
	f {
		s mkpi=$o(mkpiArr("DHCWL.MKPI.MKPI",mkpi))
		q:mkpi=""
		;s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
		;continue:mkpiId=""
		;s mkpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(mkpiId)
		;continue:mkpiObj=""
		if count>0 w ","
		w "["""_mkpi_""","""_mkpiArr("DHCWL.MKPI.MKPI",mkpi)_"""]"
		s count=count+1
	}
	w "]"
}

/// creator:     wk
/// creatDate:   2017-08-01
/// description: 解析导入的文件，将任务组信息解析出来
/// other：      d ##class(DHCWL.MKPIIO.DefaultInService).JsonKpiTask("C:\Users\Administrator\Desktop\2013-09-11 161436outputKpis.xml",.arr)
ClassMethod JsonKpiTask(xmlPath, ByRef mkpiArr)
{
	n (xmlPath,mkpiArr)
	k mkpiArr
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				if (cnt>=3){
					if (reader.MoveToAttributeName("ClassFullName")){
						s class=reader.Value
						if (reader.MoveToAttributeName("PrimaryFieldValue")){
							s primaryValue=reader.Value
							s mkpiArr(class,primaryValue)=""
							if (class="DHCWL.MKPI.ConfigTaskGroup"){
								s mkpiCode=primaryValue
							}
						}
					}
				}
				d reader.MoveToElement()
	   		}
		}elseif (reader.NodeType="chars"){
			if (nodeName="DTaskGroupDesc"){
				s mkpiArr("DHCWL.MKPI.ConfigTaskGroup",mkpiCode)=reader.Value
			}
		}
	}
	s mkpi="",count=0
	w "["
	f {
		s mkpi=$o(mkpiArr("DHCWL.MKPI.ConfigTaskGroup",mkpi))
		q:mkpi=""
		if count>0 w ","
		w "["""_mkpi_""","""_mkpiArr("DHCWL.MKPI.ConfigTaskGroup",mkpi)_"""]"
		s count=count+1
	}
	w "]"
}

//d ##class(DHCWL.MKPIIO.DefaultInService).InputXML()

ClassMethod InputXML(path) As %Status
{
	n (path)
	s inService=##class(DHCWL.MKPIIO.CustormService.DefaultInputService).%New()
	;w "path="_path,!
	s sc= ##class(DHCWL.MKPIIO.util.Read).ReadStructNode(path,.inService)
	q sc
}

//d ##class(DHCWL.MKPIIO.DefaultInService).InputDim("C:\2016-06-03 104926outputDims.dim")

ClassMethod InputDim(path)
{
	s inService=##class(DHCWL.MKPIIO.CustormService.DimDefaultInputService).%New()
	s sc= ##class(DHCWL.MKPIIO.util.Read).ReadStructNode(path,.inService)
	i +sc=1 w "维度、维度属性导入成功！"
	e  w "维度、维度属性导入失败！"	
	q
}

/// creator:    wk
/// creatDate:  2017-08-02
/// decription: 导入指标任务组
/// other:      d ##class(DHCWL.MKPIIO.DefaultInService).InputTaskGroup("C:\2016-06-03 104926outputDims.dim")
ClassMethod InputTaskGroup(path) As %Status
{
	n (path)
	s inService=##class(DHCWL.MKPIIO.CustormService.DefaultInputService).%New()
	;w "path="_path,!
	s sc= ##class(DHCWL.MKPIIO.util.Read).ReadTaskStructNode(path,.inService)
	q sc
}

}
