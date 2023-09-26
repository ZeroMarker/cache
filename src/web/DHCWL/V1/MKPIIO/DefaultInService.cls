/// Creator    : wk 
/// CreatDate  : 2018-08-07
/// Desc       : 指标导入
Class web.DHCWL.V1.MKPIIO.DefaultInService Extends %RegisteredObject
{

///  Creator   : wk
///  CreatDate : 2018-08-06
///  Desc      : 读入指标文件内容
///  Other     : do ##class(web.DHCWL.V1.MKPIIO.DefaultInService).UPFILE()
ClassMethod UPFILE(theStep, inputCont, inputType As %String)
{
	s wrong=0,wrongMes=""
	s deli=##class(DHCWL.util.DirectoryFile).SetPathOS()
	s deli=$p(deli,"||",2)
	s tmp=##class(DHCWL.util.DirectoryFile).GetTempDir()
	i $e(tmp,$l(tmp))'=deli s tmp=tmp_deli
	s index=$g(^DHCWL.MKPI.TEMPCONT("NODEINDEX")) 
	s fileName="tempDHCWLXML"_index_".xml"
	s tempFile=tmp_fileName
	s index=+index+1
	s ^DHCWL.MKPI.TEMPCONT("NODEINDEX")=index
	i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
	s file=##class(%File).%New(tempFile)
	d file.Open("WN")

	s step=""
	s i=1
	for{
		s step=$o(inputCont(step))
		q:step=""
		s content=inputCont(step)
		s ^DHCWL.MKPI.TEMPCONT("Node"_i)=content
		s i=i+1
		s sc=file.Write(content)
		if sc'=1 {
			s wrongMes=sc
			s wrong=1
			q
		}
	}


	d:file'="" file.Close()
	s ^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",+$h,index-1)=tempFile
	if wrong=0{
		;w "{success:true,info:'ok',tips:'"_fileName_"'}"
		
		Set sc =##class(%XML.TextReader).ParseFile(tempFile,.reader)
		If $$$ISERR(sc) {
			s ret=$System.Status.GetErrorText(sc)
			w "{success:true,info:'wrong',tips:'解析文件时发生错误，请确认导入的文件是否正确！'}"
			q ""	
		}
		s generator=##class(DHCWL.MKPIIO.util.Read).GetXmlGenerator(tempFile)
		if ((($zcvt(generator,"U"))'="KPI")&&(inputType="")){
			w "{success:true,info:'wrong',tips:'请导入正确的指标文件！'}"
			q ""
		}
		if ((($zcvt(generator,"U"))'="TASK")&&(inputType="taskGroup")){
			w "{success:true,info:'wrong',tips:'请导入正确的指标文件！'}"
			q ""
		}
		w "{""root"":"
		if (inputType="taskGroup"){
			d ##class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpiTask(tempFile)
		}elseif(inputType="module"){
			d ##class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpi(tempFile)
		}else{
			d ##class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpiNew(tempFile)
		}
		w ",""tips"":"""_fileName_"""}"
	}else {
		w "{success:true,info:'wrong',tips:'文件上传失败！无法进行下面的操作'}"
	}
	//若历史上有没有删除掉的临时文件，则全部删除了。
	s day=+$h f  s day=$o(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day),-1) q:day=""  d
	.s indI="" f  s indI=$o(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day,indI)) q:indI=""  d
	..s tf=$g(^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day,indI))
	..i tf'="" d
	...i ##class(%File).Exists(tf) d ##class(%File).Delete(tf)
	.k ^DHCWL.MKPI.TEMPCONT("TEMPINPUTFILE",day)
	q ""
}

/// creator:     wk
/// creatDate:   2017-08-01
/// description: 解析导入的文件，将任务组信息解析出来
/// other：      d ##class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpiTask("C:\Users\Administrator\Desktop\2013-09-11 161436outputKpis.xml",.arr)
ClassMethod JsonKpiTask(xmlPath, ByRef mkpiArr)
{
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
		s flag=0
		if ($d(^DHCWL.MKPI.ConfigTaskGroupI("Code"," "_$zcvt(mkpi,"U")))){
			s flag=1
		}
		if count>0 w ","
		//w "["""_mkpi_""","""_mkpiArr("DHCWL.MKPI.ConfigTaskGroup",mkpi)_"""]"
		w "{""groupCode"":"_""""_mkpi_""",""groupDesc"":"""_mkpiArr("DHCWL.MKPI.ConfigTaskGroup",mkpi)_""",""flag"":"""_flag_"""}"
		s count=count+1
	}
	w "]"
}

/// Creator   : wk
/// CreatDate : 2018-08-07
/// Desc      : 读取指标文件内容，返回需要的数据
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpiNew()
ClassMethod JsonKpiNew(xmlPath, ByRef mkpiArr, checkFlag As %Boolean = 0)
{
	k mkpiArr
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	
	s version=##class(DHCWL.MKPIIO.util.Read).GetXmlVersion(xmlPath)
	/*if ($d(^DHCWL.MKPI.SetConfig("NewIOConfigVersion"))) s ioConfigVersion=^DHCWL.MKPI.SetConfig("NewIOConfigVersion")
	else  s ioConfigVersion=3.22
	if (version<ioConfigVersion){
		 d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked(xmlPath,checkFlag)
		 q
	}*/
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
		w "["
		//w "{success:true,root:["
		s mkpi=""
		f {
			s mkpi=$o(mkpiArr("DHCWL.MKPI.MKPI",mkpi))
			q:mkpi=""
			s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
			i num>0 w ","
			//w "{className:'DHCWL.MKPI.MKPI',propertyCode:'"_mkpi_"',codeValue:'"_mkpi_"',id:'"_mkpiId_"'}"
			s flag=1
			if (mkpiId=""){
				s flag=0
			}
			w "{""kpiCode"":"_""""_mkpi_""",""kpiDesc"":"""_mkpiArr("DHCWL.MKPI.MKPI",mkpi)_""",""flag"":"""_flag_"""}"
			s num=num+1
		}
		w "]"
		//w "],totalNum:"_num_"}"
		q
	}
	s mkpi="",count=0
	w "["
	f {
		s mkpi=$o(mkpiArr("DHCWL.MKPI.MKPI",mkpi))
		q:mkpi=""
		if count>0 w ","
		w "{""kpiCode"":"_""""_mkpi_""",""kpiDesc"":"""_mkpiArr("DHCWL.MKPI.MKPI",mkpi)_"""}"
		s count=count+1
	}
	w "]"
}

/// Creator   : wk
/// CreatDate : 2018-08-07
/// Desc      : 导入指标信息
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).inputKpiFile("tt.xml",1) 
ClassMethod inputKpiFile(fileName As %String, checkedInput As %String = 0, realInputKpiList As %String)
{
	s wrong=0,wrongMes=""
	s deli=##class(DHCWL.util.DirectoryFile).SetPathOS()
	s deli=$p(deli,"||",2)
	s tmp=##class(DHCWL.util.DirectoryFile).GetTempDir()
	i $e(tmp,$l(tmp))'=deli s tmp=tmp_deli
	s tempFile=tmp_fileName
	if checkedInput=1 {
		;d:wrong=0 ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked(tempFile)
		d:wrong=0 ##class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpiNew(tempFile,.arr,1)
		q ""
	}
	if (realInputKpiList=""){
		w "{success:true,info:'ok',tips:'导入0个指标'}"
		i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
		q
	}
	;w "tempFile="_tempFile
	k ^TEMPDHCWL("REALINPUT",$j)
	for i=$l(realInputKpiList,","):-1:1 {
		s kpiCode=$p(realInputKpiList,",",i)
		continue:kpiCode=""
		s ^TEMPDHCWL("REALINPUT",$j,kpiCode)=kpiCode
	}
	if wrong=0{
		//s sc=##class(DHCWL.MKPIIO.InputFromXML).InputFromXML(tempFile,0,0,1)
		s sc=##class(DHCWL.MKPIIO.DefaultInService).InputXML(tempFile)
		if +sc=1{
			s result=##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskByInput()
			if result'=""{
				w "{success:true,info:'ok',tips:'"_result_"'}"
				k ^TEMPDHCWL("REALINPUT",$j)
				d ##class(%File).Delete(tempFile)
				q
			}
		}
		k ^TEMPDHCWL("REALINPUT",$j)
		i +sc=1 {
			q "导入成功！"
			k errorInforList
			do ##class(DHCWL.util.CheckKpiData).CheckKpiExCode(1,.errorInforList)
			do ##class(DHCWL.util.CheckKpiData).CheckSection(1,.errorInforList)
			do ##class(DHCWL.util.CheckKpiData).CheckDimExeCode(1,.errorInforList)
			do ##class(DHCWL.util.CheckKpiData).CheckKpiDimOrder(1,.errorInforList)
			do ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskOrder(.errorInforList)
			set secFlag=##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.tempSec)
			s secHYID=$o(^DHCWL.MKPI.SectionI("SecCode","HY",""))
			if (($o(errorInforList(""))'="")||(secHYID'="")||('secFlag)){
				//w "{success:true,info:'ok',tips:'导入成功！指标环境异常,请点击:系统配置-指标常见问题检查,查看具体问题'}"
				q "导入成功！指标环境异常,请点击:系统配置-指标常见问题检查,查看具体问题"
			}else{
				w "{success:true,info:'ok',tips:'指标导入成功！'}" ;_tempFile_"'}"
			}
		}else{
			q "导入失败"_sc
			//w "{success:true,info:'wrong',tips:'"_"指标导入失败,"_sc_"'}"
		}
		;e  w "{success:true,info:'wrong',tips:'"_tempFile_"  指标导入失败，请检查XML文件是否是格式良好的，并且要导入数据至少要在第三层节点上。"_sc_"'}"
		d ##class(%File).Delete(tempFile)
		q
	}
	i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
	w "{success:true,info:'wrong',tips:'"_wrongMes_"'}" ;_tempFile_"'"
	q
}

/// Creator   : wk
/// CreatDate : 2018-11-09
/// Desc      : 模块与报表导入前检查与导入
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).inputModuleInfor() 
ClassMethod inputModuleInfor()
{
	s className=""
	s primaryValue=""
	s fieldName=""
	s filedValue=""
	s NO=0
	s jsonData=""
	s jsonDatas=""

	w "["
	f {
		s NO=$o(^TEMPDHCWLModule(NO))
		q:NO=""
		s className=""
		f {
			s className=$o(^TEMPDHCWLModule(NO,className))
			q:className=""
			s primaryValue=""
			f {
				s primaryValue=$o(^TEMPDHCWLModule(NO,className,primaryValue))
				q:primaryValue=""
				s jsonData="{""className"":"""_className_""""_",""primaryValue"":"""_primaryValue_""""
				s flag=##Class(web.DHCWL.V1.MKPIIO.DefaultInService).GetModuleFlag(className,primaryValue)
				s jsonData=jsonData_",""flag"":"""_flag_""""
				s fieldName=""
				f {
					s fieldName=$o(^TEMPDHCWLModule(NO,className,primaryValue,fieldName))
					q:fieldName=""
					s jsonData=jsonData_ ","
					s jsonData=jsonData_""""_fieldName_""":"""_^TEMPDHCWLModule(NO,className,primaryValue,fieldName)_""""
				}
				s jsonData=jsonData_"}"
			}

			i jsonData'="" {
				i jsonDatas="" {
					s jsonDatas=jsonDatas_jsonData
					w jsonData
				}else{
					w ","_jsonData
				}	
			}
		}
	}
	w "]"	
	K ^TEMPDHCWLModule
	q ""
}

/// Creator   : wk
/// CreatDate : 2018-11-09
/// Desc      : 判断模块与报表、数据集是否存在表中
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).GetModuleFlag()
ClassMethod GetModuleFlag(className, value)
{
	if (className="DHCWL.MKPI.MMgrModuleCfg"){
		if ($d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",value))){
			q 1
		}else{
			q 0
		}
	}elseif(className="DHCWL.MKPI.MMgrRptCfg"){
		s moduleCode=$p(value,"||",1)
		s rptCode=$p(value,"||",2)
		if ($d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",moduleCode,rptCode))){
			q 1
		}else{
			q 0
		}
	}elseif(className="DHCWL.MKPI.MMgrDataSetCfg"){
		s moduleCode=$p(value,"||",1)
		s rptCode=$p(value,"||",2)
		s dsCode=$p(value,"||",3)
		if ($d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",moduleCode,rptCode,dsCode))){
			q 1
		}else{
			q 0
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-11-09
/// Desc      : 读取模块文件
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).JsonKpi() 
ClassMethod JsonKpi(xmlPath, ByRef mkpiArr, checkFlag As %Boolean = 0) As %String
{
	k mkpiArr
	K ^TEMPDHCWL($j,"MODULEIMP")
	k ^TEMPDHCWLModule
	s NO=0
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	s version=##class(DHCWL.MKPIIO.util.Read).GetXmlVersion(xmlPath)
	s generator=##class(DHCWL.ModuleManageServ.MMServ).GetXmlGenerator(xmlPath)
	q:(generator'="module")
	/*if ($d(^DHCWL.MKPI.SetConfig("NewIOConfigVersion"))) s ioConfigVersion=^DHCWL.MKPI.SetConfig("NewIOConfigVersion")
	else  s ioConfigVersion=3.22
	if (version<ioConfigVersion){
		 d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked(xmlPath,checkFlag)
		 q
	}*/

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
							if ((class="DHCWL.MKPI.MMgrKPICfg")||(class="DHCWL.MKPI.MMgrModuleCfg")||(class="DHCWL.MKPI.MMgrRptCfg")||(class="DHCWL.MKPI.MMgrDataSetCfg")) {
								s KeyCode=primaryValue
								s NO=NO+1
							}
							
						}
					}
				}
				d reader.MoveToElement()
	   		}
		}elseif (reader.NodeType="chars"){
			if ((class="DHCWL.MKPI.MMgrKPICfg")||(class="DHCWL.MKPI.MMgrModuleCfg")||(class="DHCWL.MKPI.MMgrRptCfg")||(class="DHCWL.MKPI.MMgrDataSetCfg")) {
				s ^TEMPDHCWL($j,"MODULEIMP",NO,class,KeyCode,nodeName)=reader.Value
			}
		}
	}
	
	s className=""
	s primaryValue=""
	s fieldName=""
	s filedValue=""
	s NO=0
	s jsonData=""
	s jsonDatas=""
	Merge ^TEMPDHCWLModule=^TEMPDHCWL($j,"MODULEIMP")
	
	w "["
	f {
		s NO=$o(^TEMPDHCWL($j,"MODULEIMP",NO))
		q:NO=""
		s className=""
		f {
			s className=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className))
			q:className=""
			s primaryValue=""
			f {
				s primaryValue=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue))
				q:primaryValue=""
				s jsonData="{""className"":"""_className_""""_",""primaryValue"":"""_primaryValue_""""
				s fieldName=""
				f {
					s fieldName=$o(^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName))
					q:fieldName=""
					s jsonData=jsonData_ ","
					s jsonData=jsonData_""""_fieldName_""":"""_^TEMPDHCWL($j,"MODULEIMP",NO,className,primaryValue,fieldName)_""""
				}
				s jsonData=jsonData_"}"
			}

			i jsonData'="" {
				i jsonDatas="" {
					s jsonDatas=jsonDatas_jsonData
					w jsonData
				}else{
					w ","_jsonData
				}	
			}
		}
	}
	w "]"	
	K ^TEMPDHCWL($j,"MODULEIMP")
	q
}

/// Creator   : wk
/// CreatDate : 2018-11-14
/// Desc      : 导入模块信息
/// Other     : do ##Class(web.DHCWL.V1.MKPIIO.DefaultInService).InputModuleFile() 
ClassMethod InputModuleFile(fileName, realInputModuleList)
{
	s wrong=0,wrongMes=""
	s deli=##class(DHCWL.util.DirectoryFile).SetPathOS()
	s deli=$p(deli,"||",2)
	s tmp=##class(DHCWL.util.DirectoryFile).GetTempDir()
	i $e(tmp,$l(tmp))'=deli s tmp=tmp_deli
	s tempFile=tmp_fileName
	if (realInputModuleList=""){
		w "{success:true,info:'ok',tips:'导入0个指标'}"
		i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
		q
	}
	k ^TEMPDHCWL("REALINPUT",$j)
	for i=$l(realInputModuleList,","):-1:1 {
		s moduleCode=$p(realInputModuleList,",",i)
		continue:moduleCode=""
		s ^TEMPDHCWL("REALINPUT",$j,moduleCode)=moduleCode
	}
	if wrong=0{
		s sc=##class(DHCWL.ModuleManageServ.MMServ).InputXML(tempFile)
		
		k ^TEMPDHCWL("REALINPUT",$j)
		i +sc=1 s infor="数据导入成功!"  
		e  s infor=tempFile_"  数据导入失败!XML文件是否是格式良好的导入数据至少要在第三层节点上!"_sc 
		d ##class(%File).Delete(tempFile)
		q infor
	}
	i ##class(%File).Exists(tempFile) d ##class(%File).Delete(tempFile)
	q wrongMes
}

}
