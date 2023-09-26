Class DHCWL.MKPIIO.util.Read Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 导入程序主体框架

// Set sc =##class(%XML.TextReader).ParseFile("D:\test.xml",.reader)

// d ##class(DHCWL.MKPIIO.util.Read).ReadStructNode("D:\test.xml")

ClassMethod ReadStructNode(path = "", ByRef inService As DHCWL.MKPIIO.util.InputInterface = "", ByRef stream As %Library.FileBinaryStream = "") As %Status
{
	n (path,inService,stream)
	q:((path="")&&(stream="")) "参数path和stream不能同时为空"
	k structNodeArr
	if (inService="") s inService=##class(DHCWL.MKPIIO.CustormService.DefaultInputService).%New()  ;##class(DHCWL.MKPIIO.util.InputInterface).%New()
	if (path'=""){
		Set sc =##class(%XML.TextReader).ParseFile(path,.reader)
	}else{
		Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	;s $ET="d ##class(DHCWL.MKPIIO.util.Read).RunError()"
	s version=..GetXmlVersion(path,.stream)
	s dimFlag=..GetXmlDimFlag(path,.stream)
	/*if ($d(^DHCWL.MKPI.SetConfig("NewIOConfigVersion"))) s ioConfigVersion=^DHCWL.MKPI.SetConfig("NewIOConfigVersion")
	else  s ioConfigVersion=3.22
	if (version<ioConfigVersion){
		q ##class(DHCWL.MKPIIO.InputFromXML).InputFromXML(path,0,0,1)
	}*/
	if ('reader.ReadStartElement("structDS")){
		d reader.Rewind()
		q:'(reader.ReadStartElement("structDS")) "不存在该节点：structDS，请检查版本是否正确。"
	}
	//缓存XML节点的对象或引用类型的信息到临时global下，以备接口程序使用。
	k ^TEMPDHCWLKPIDATA("XMLNodeSession",$j)
	d ..ReadXmlNodeToGlobalMap(.reader)
	d reader.Rewind()
	//++add by wz.2014-4-17.如果这是一个模块文件，那么可以不必有"referencedDS"节点
	s generator=##class(DHCWL.ModuleManageServ.MMServ).GetXmlGenerator(path)
	//缓存所有引用区对象
	//if ('reader.ReadStartElement("referencedDS")){	//--modify by wz.如果这是一个模块文件，那么可以不必有"referencedDS"节点
	if (('reader.ReadStartElement("referencedDS")) && (generator'="module") ){
		d reader.Rewind()
		q:'(reader.ReadStartElement("referencedDS")) "不存在该节点：referencedDS，请检查版本是否正确。"
	}
	s thePostion=1 //为了一次性读入引用去XML记住出现位置。
	if (reader.HasAttributes) {
		k cacheRefArr
		s refDep=reader.Depth
		if (reader.MoveToAttributeName("Mark")){
			s attValue=reader.Value
			if (attValue="MKPIPrivate"){
				while (reader.Read()){
					if ((reader.NodeType="element")){
						if (reader.MoveToAttributeName("Type")){
							if (reader.Value="Single"){
								if (reader.HasAttributes) {
									d reader.MoveToAttributeName("ClassFullName")
									s classFullName=reader.Value
									d reader.MoveToAttributeName("PrimaryField")
									s primaryField=reader.Value
									d reader.MoveToAttributeName("PrimaryFieldValue")
									s rimaryValue=reader.Value
									s cacheRefArr(thePostion,classFullName,rimaryValue)=""
									s thePostion=thePostion+1
								}
								d reader.MoveToElement()
							}
						}
					}
				}
			}
		}
	}
	//检查是否有半年区间
	s sign=0
	s num=""
	for{
		s num=$o(cacheRefArr(num))
		q:num=""
		if ($d(cacheRefArr(num,"DHCWL.MKPI.Section"))){
			s secCode=$o(cacheRefArr(num,"DHCWL.MKPI.Section",""))
			q:secCode=""
			if ((secCode'="D")&(secCode'="M")&(secCode'="Q")&(secCode'="Y")){
				s sign=1
				q
			}
		}
	}
	if (sign=1){
		q "指标导入文件中有非法区间"_secCode_",请维护好指标文件后导入"
	}
	
	//根据文件结构依次导入，缓存出所有需要导入的结构体
	d reader.Rewind()
	while (reader.Read()){
		if ((reader.NodeType="element")&&(reader.Name="referencedDS")) q
		if ((reader.Depth=2)&&(reader.NodeType="element")){
			s nodeName=reader.Name
			s structNodeArr(nodeName)=""
			if (reader.HasAttributes) {
				s refFlag=0
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
	 		 		s attName=reader.Name,attValue=reader.Value
	 		 		s structNodeArr(nodeName,attName)=attValue
				}
			}
		}
	}
	//检查指标维度关联的基础维度及其维度属性是否存在
	//add by wk~2016-5-25
	if (generator="kpi"){
		s structDimCode=""
		k dimSaveArr,meaSaveArr
		for{
			s structDimCode=$o(structNodeArr(structDimCode))
			q:structDimCode=""
			s class=$p(structDimCode,"-",1)
			if ((class="DHCWL.MKPI.MKPIDimensions")||(class="DHCWL.MKPI.MKPIMeasure")){
				if ($d(structNodeArr(structDimCode,"ClassFullName"))){
				s classFullName=structNodeArr(structDimCode,"ClassFullName")
				s primaryValue=structNodeArr(structDimCode,"PrimaryFieldValue")
				s primaryField=structNodeArr(structDimCode,"PrimaryField")
				d ..ReadXMLDimNodeToTest(.reader,classFullName,primaryValue,,.inService,.kpiDimInforArr)
				if ($d(kpiDimInforArr("MKPIDimDimDr"))){
					s dimSaveArr(kpiDimInforArr("MKPIDimDimDr"))=""
				}elseif($d(kpiDimInforArr("MKPIMeaDr"))){
					s meaSaveArr(kpiDimInforArr("MKPIMeaDr"))=""
				}
				}
			}
		}
		s dimCode=""
		s sign=0
		for{
			s dimCode=$o(dimSaveArr(dimCode))
			q:dimCode=""
			s sign=1
			s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
			s:id'="" sign=0
			/*s dimProCode=""
			for{
				s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,dimProCode))
				q:dimProCode=""
				s dimProID=""
				for{
					s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,dimProCode,dimProID))
					q:dimProID=""
					if ($d(^DHCWL.MKPI.DimPropertyD(dimProID))){
						s sign=0
						q
					}
				}
				q:sign=0
			}*/
			q:sign=1
		}
		if (sign=1){
			q "数据库内不存在指标文件中需要的基础维度:"_dimCode_",请检查后导入"
		}
		s meaCode=""
		for {
			s meaCode=$o(meaSaveArr(meaCode))
			q:meaCode=""
			if ('$d(^DHCWL.MeasureDimrole.MeasureI("Code"," "_$zcvt(meaCode,"U")))){
				s sign=1
				q
			}else{
				s meaID=""
				for {
					s meaID=$o(^DHCWL.MeasureDimrole.MeasureI("Code"," "_$zcvt(meaCode,"U"),meaID))
					q:meaID=""
					s voidFlag=$lg(^DHCWL.MeasureDimrole.MeasureD(meaID),9)
					if (voidFlag=1){
						s sign=1
						q
					}
				}
			}
		}
		if (sign=1){
			q "数据库内不存在指标文件中需要的度量,请检查后导入"
		}
	}
	//将引用转换为对象并Map
	k cachedRefObjHandle,cachedObjPool
	s cacheClass="",thePostion=0
	f {
		s thePostion=$o(cacheRefArr(thePostion))
		q:thePostion=""
		s cacheClass=$o(cacheRefArr(thePostion,""))
		continue:cacheClass=""
		s cachePriValue=""
		f {
			s cachePriValue=$o(cacheRefArr(thePostion,cacheClass,cachePriValue))
			q:cachePriValue=""
			d ..ReadRefedToMap(.reader,cacheClass,cachePriValue,,.cachedRefObjHandle,.inService,.cachedObjPool)
		}
	}
	;b ;003
	//ByRef reader As %XML.TextReader, classFullName As %String, markedValue = "", nodeLocationName = "", ByRef needRefMap, ByRef inService As DHCWL.MKPIIO.util.InputInterface, ByRef objectRefPool As %ObjectHandle = ""
	//将缓存的map转换为对象，并将引用链依次连接上
	s cacheClass="",thePostion=0
	f {
		s thePostion=$o(cacheRefArr(thePostion))
		q:thePostion=""
		s cacheClass=$o(cacheRefArr(thePostion,""))
		continue:cacheClass=""
		s cachePriValue=""
		f {
			s cachePriValue=$o(cacheRefArr(thePostion,cacheClass,cachePriValue))
			q:cachePriValue=""
			d ..LinkRefHandle(cacheClass,cachePriValue,.cachedRefObjHandle,.cachedObjPool,.inService)
		}
	}
	//
	//根据文件结构依次导入，缓存出所有需要导入的结构体
	/*d reader.Rewind()
	while (reader.Read()){
		if ((reader.NodeType="element")&&(reader.Name="referencedDS")) q
		if ((reader.Depth=2)&&(reader.NodeType="element")){
			s nodeName=reader.Name
			s structNodeArr(nodeName)=""
			if (reader.HasAttributes) {
				s refFlag=0
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
	 		 		s attName=reader.Name,attValue=reader.Value
	 		 		s structNodeArr(nodeName,attName)=attValue
				}
			}
		}
	}*/
	s structNode=""
	f {
		s structNode=$o(structNodeArr(structNode))
		q:structNode=""
		if ($d(structNodeArr(structNode,"ClassFullName"))){
			s classFullName=structNodeArr(structNode,"ClassFullName")
			s primaryValue=structNodeArr(structNode,"PrimaryFieldValue")
			s primaryField=structNodeArr(structNode,"PrimaryField")
			s obj= ..ReadXMLNodeToObj(.reader,classFullName,primaryValue,,.inService,.cachedObjPool)
		}
	}
	k ^TEMPDHCWLKPIDATA("XMLNodeSession",$j),structNodeArr,cachedObjPool,cacheRefArr
	q $$$OK
}

// 缓存XML节点的对象或引用类型的信息到临时global下，以备接口程序使用。

/*
	^TEMPDHCWLKPIDATA("XMLNodeSession",$j,classFullName,primaryValue)=primaryField
	^TEMPDHCWLKPIDATA("XMLNodeSession",$j,classFullName,primaryValue,refedFieldName)=refedPrimaryValue
	^TEMPDHCWLKPIDATA("XMLNodeSession",$j,classFullName,primaryValue,refedFieldName,"ClassFullName")=refedClassFullName
	^TEMPDHCWLKPIDATA("XMLNodeSession",$j,classFullName,primaryValue,refedFieldName,"Type")=Ref/Object
*/

// d ##class(DHCWL.MKPIIO.util.Read).ReadXmlNodeToGlobalMap("D:\test.xml")

ClassMethod ReadXmlNodeToGlobalMap(ByRef reader As %XML.TextReader, parentClassFullName = "", parentPrimaryValue = "", parentNodeName = "")
{
	n (reader,parentClassFullName,parentPrimaryValue,parentNodeName)
	;k ^TEMPDHCWLKPIDATA("XMLNodeSession",$j)
	s nodeValue="",nodeName=""
	while (reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				if ((reader.MoveToAttributeName("Type"))){
					s ignoreNodeFlag=0
					k attMap
					s cnt=reader.AttributeCountGet()
					s cnt=+$g(cnt)
					f i=1:1:cnt {
	 					d reader.MoveToAttributeIndex(i)
	 		 			s attName=reader.Name,attValue=reader.Value
	 		 			s attMap(attName)=attValue
					}
					d reader.MoveToElement()
					s classFullName=attMap("ClassFullName")
					if ((attMap("Type")="Object")||(attMap("Type")="Single")){
						s primaryField=attMap("PrimaryField")
						s primaryValue=attMap("PrimaryFieldValue")
						if ($d(attMap("Field"))&&(parentClassFullName'="")){
							s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,nodeName)=primaryValue
							s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,nodeName,"ClassFullName")=classFullName
							s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,nodeName,"Type")=attMap("Type")
						}else{
							s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,classFullName,primaryValue)=primaryField
						}
						d ..ReadXmlNodeToGlobalMap(.reader,classFullName,primaryValue,nodeName)
						k attMap
					}
				}else{
					s ignoreNodeFlag=1
				}
	   		}
		}elseif ((reader.NodeType="chars")&&(ignoreNodeFlag=0)){
			s nodeValue=reader.Value
			if ($d(attMap("Type"))){
				s type=attMap("Type")
				s primaryField=attMap("PrimaryField")
				s classFullName=attMap("ClassFullName")
				if ((type="Ref")&&(parentClassFullName'="")){
					s refFieldName=attMap("Field")
					s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,refFieldName)=nodeValue
					s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,refFieldName,"ClassFullName")=classFullName
					s ^TEMPDHCWLKPIDATA("XMLNodeSession",$j,parentClassFullName,parentPrimaryValue,refFieldName,"Type")=type
				}
				k attMap
			}
		}elseif ((reader.NodeType="endelement")&&(reader.Name=parentNodeName)){
			q
		}
	}
}

/*
将为对象类型的xml元素，初始化为对象，此时初始化的对象只是单对象，同时会将这些对象缓存起来。
数组的数据结构定义为：
缓存后的数据结构为：
objectRefPool(classFullName,primaryValue)=objectHandle

参数说明：
reader:已打开的xml引用，classFullName要搜索的对象节点类全名。markedValue该对象的primary value。
nodeLocationName：和classFullName，markedValue互斥使用，如果有该值说明查找对象的时候直接根据对象的字段名称去Map该对象。
fromXmlMap：将xml节点Map为数组数据的存放位置。
inService：导入该节点对象的时候的接口方法，该方法规定是否需要导入该对象
buildObjFromMapFlag：在Map的时候是否构建好对象，默认为不构建
objectRefPool：缓存的对象引用池，和上面的参数结合使用。

*/
ClassMethod ReadRefedToMap(ByRef reader As %XML.TextReader, classFullName As %String, markedValue = "", nodeLocationName = "", ByRef needRefMap, ByRef inService As DHCWL.MKPIIO.util.InputInterface, ByRef objectRefPool As %ObjectHandle = "") As %Status
{
	n (reader,classFullName,markedValue,nodeLocationName,needRefMap,inService,objectRefPool)
	q:reader="" "Error file not exists or not opened!"
	
	k ^TEMPDHCWLKPIDATA("CLASSPROPERTY",$j)
	//add by wz.2015-6.patch4.1.14取出该类下的所有属性，保存到^TEMPDHCWLKPIDATA("CLASSPROPERTY",$j)中
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(classFullName)
	Set count = cdef.Properties.Count()
	f i=1:1:count {
		s pro=cdef.Properties.GetAt(i).Name	
		s ^TEMPDHCWLKPIDATA("CLASSPROPERTY",$j,pro)=""
	}
	
	if (markedValue [ "||") s markedValue2=##class(DHCWL.util.StringUtil).ReplaceStr(markedValue,"||","__")
	else  s markedValue2=markedValue
	if (markedValue2 [ "^") s markedValue2=##class(DHCWL.util.StringUtil).ReplaceStr(markedValue2,"^","R_")
	s objPrimaryNodeName=classFullName_"-"_markedValue2
	if ($g(nodeLocationName)'="") s objPrimaryNodeName=nodeLocationName
	if ('reader.ReadStartElement(objPrimaryNodeName)){
		d reader.Rewind()
		q:'(reader.ReadStartElement(objPrimaryNodeName)) "不存在该节点："_objPrimaryNodeName
	}
	;b //013
	k propertyMap
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s refFlag=0
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
	 		 		s attName=reader.Name,attValue=reader.Value
	 		 		s propertyMap(nodeName,attName)=attValue
				}
				d reader.MoveToElement()
	   		}
		}
		if (reader.NodeType="chars") {
			s nodeValue=reader.Value
			s propertyMap(nodeName)=nodeValue
			if (($d(propertyMap(nodeName,"Type")))&&(propertyMap(nodeName,"Type")="Ref")){
				s propertyMap(nodeName,"Ref")=1
				s refedClassName=propertyMap(nodeName,"ClassFullName")
				s needRefMap(classFullName,markedValue,nodeName,"RefedPrimaryValue")=nodeValue
				s needRefMap(classFullName,markedValue,nodeName,"PrimaryValue")=markedValue
				s needRefMap(classFullName,markedValue,nodeName,"RefedClassFullName")=refedClassName
			}
		}
		if ((reader.NodeType="endelement")&&(reader.Name=objPrimaryNodeName)){
			q
		}
	}
	;b //012
	s field="",excStr=""
	f {
		s field=$o(propertyMap(field))
		q:field=""
		continue:'$d(^TEMPDHCWLKPIDATA("CLASSPROPERTY",$j,field))  //如果不存在这个字段就跳过
		continue:(($d(propertyMap(field,"Ref")))&&(propertyMap(field,"Ref")=1))
		s classType=propertyMap(field,"ClassFullName")
		if (excStr=""){
			s propertyMap(field)=##class(DHCWL.util.StringUtil).ReplaceStr(propertyMap(field),"""","""""")
			s excStr="s obj."_field_"="_..FormatExcuteStr(classType,propertyMap(field))
		}else{
			s propertyMap(field)=##class(DHCWL.util.StringUtil).ReplaceStr(propertyMap(field),"""","""""")
			s excStr=excStr_",obj."_field_"="_..FormatExcuteStr(classType,propertyMap(field))
		}
	}
	s obj="",objStr=""
	;w excStr,!
	s markedField=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(classFullName)
	s status=inService.JudgeInput(classFullName,markedValue,markedField) //调用接口
	s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(markedValue,classFullName)
	//b //010
	if (id'=""){
		s objStr="s obj=##class("_classFullName_").%OpenId("_id_")"
		x objStr
	}
	;w classFullName,!
	;b ;006
	if (status="00"){
		if (id'=""){
			s objectRefPool(classFullName,markedValue)=obj
			q obj
		}else{
			q ""
		}
	}elseif(status="01"){
		if (id=""){
			s objStr="s obj=##class("_classFullName_").%New()"
		}else{
			s objectRefPool(classFullName,markedValue)=obj
			;q obj
		}
	}elseif(status="10"){
		if (id'=""){
			s objectRefPool(classFullName,markedValue)=obj
			q obj
		}else{
			s objStr="s obj=##class("_classFullName_").%New()"
		}
	}elseif(status="11"){
		if (id=""){
			s objStr="s obj=##class("_classFullName_").%New()"
		}else{
			s objectRefPool(classFullName,markedValue)=obj
			;q obj
		}
	}else{
		q ""
	}
	;b //011
	if (objStr'="") x objStr
	if (excStr'="") {
		x excStr
		s objectRefPool(classFullName,markedValue)=obj
	}
	k ^TEMPDHCWLKPIDATA("CLASSPROPERTY",$j)
	q obj
}

ClassMethod ReadXMLNodeToObj(ByRef reader As %XML.TextReader, classFullName As %String, primaryValue, nodeLocationName = "", ByRef inService As DHCWL.MKPIIO.util.InputInterface, ByRef objectRefPool As %ObjectHandle = "") As %ObjectHandle
{
	n (classFullName,primaryValue,nodeLocationName,reader,inService,objectRefPool)
	q:reader="" ""
	q:((classFullName="")||(primaryValue="")) ""
	if ($d(objectRefPool(classFullName,primaryValue))) q objectRefPool(classFullName,primaryValue)
	if (primaryValue [ "||") s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue,"||","__")
	else  s primaryValue2=primaryValue
	if (primaryValue2 [ "^") s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue2,"^","R_")
	s objPrimaryNodeName=classFullName_"-"_primaryValue2
	
		//元素里面不能含有小括号
	s objPrimaryNodeName=##class(DHCWL.util.StringUtil).ReplaceStr(objPrimaryNodeName,"(")
	s objPrimaryNodeName=##class(DHCWL.util.StringUtil).ReplaceStr(objPrimaryNodeName,")")

	
	if ($g(nodeLocationName)'="") s objPrimaryNodeName=nodeLocationName
	if ('reader.ReadStartElement(objPrimaryNodeName)){
		d reader.Rewind()
		q:'(reader.ReadStartElement(objPrimaryNodeName)) "" ;"不存在该节点："_objPrimaryNodeName
	}
	s exeStr="",obj=""
	s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(primaryValue,classFullName)
	/*
	if (id'=""){
		s exeStr="s obj=##class("_classFullName_").%OpenId("_id_")"
		x exeStr
	}
	*/
	s status=inService.JudgeInput(classFullName,primaryValue) //调用接口
	if (status="00"){
		//add by wz.2014-10-15.如果status为0就退出，否则在导入时会导致错误。
		q ""
		/*
		if (id'=""){
			s exeStr="s obj=##class("_classFullName_").%OpenId("_id_")"
			;x exeStr
			;s objectRefPool(classFullName,primaryValue)=obj
			;q obj
		}else{
			q ""
		}
		*/
	}elseif(status="01"){
		if (id=""){
			s exeStr="s obj=##class("_classFullName_").%New()"
		}else{
			s exeStr="s obj=##class("_classFullName_").%OpenId("_id_")"
		}
	}elseif(status="10"){
		if (id'=""){
			s exeStr="s obj=##class("_classFullName_").%OpenId("_id_")"
			x exeStr
			s objectRefPool(classFullName,primaryValue)=obj
			q obj
		}else{
			s exeStr="s obj=##class("_classFullName_").%New()"
		}
	}elseif(status="11"){
		if (id=""){
			s exeStr="s obj=##class("_classFullName_").%New()"
		}else{
			s exeStr="s obj=##class("_classFullName_").%OpenId("_id_")"
		}
	}else{
		q ""
	}
	if (exeStr'="") {
		x exeStr
		if ('$d(objectRefPool(classFullName,primaryValue))){
			s objectRefPool(classFullName,primaryValue)=obj
		}
	}
	;b ;001
	s exeStr=""
	k fromXmlMap
	while(reader.Read()){
		if (reader.NodeType="element") {
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s refFlag=0,objFlag=0
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
	 		 		s attName=reader.Name,attValue=reader.Value
	 		 		s fromXmlMap(nodeName,attName)=attValue
				}
				d reader.MoveToElement()
				if ($d(fromXmlMap(nodeName,"Type"))){
					s type=fromXmlMap(nodeName,"Type")
					if ((type="Object")){
						s objClassFullName=fromXmlMap(nodeName,"ClassFullName")
						s objPrimaryValue=fromXmlMap(nodeName,"PrimaryFieldValue")
						if ($d(objectRefPool(objClassFullName,objPrimaryValue))){
							s nodeValue=objectRefPool(objClassFullName,objPrimaryValue)
							s fromXmlMap(nodeName)=nodeValue
							s fromXmlMap(nodeName,"RefFlag")=1
							while(reader.Read()){
								if (reader.NodeType="endelement"){
									q:reader.Name=nodeName
								}
							}
						}else{
							s nodeValue=..ReadXMLNodeToObj(.reader,objClassFullName,objPrimaryValue,nodeName,.inService,.objectRefPool)
							s objectRefPool(objClassFullName,objPrimaryValue)=nodeValue
							s fromXmlMap(nodeName)=nodeValue
							s fromXmlMap(nodeName,"RefFlag")=1
						}
					}
				}
			}
		}
		if (reader.NodeType="chars") {
			s nodeValue=reader.Value
			s fromXmlMap(nodeName)=nodeValue
		}
		if ((reader.NodeType="endelement")){
			if (reader.Name=objPrimaryNodeName){
				q
			}
		}
		if ((reader.NodeType="element")&&((nodeName="referencedDS"))){
			q
		}
	}
	
	//b  //111
	//zw fromXmlMap
	s nodeName=""
	f {
		s nodeName=$o(fromXmlMap(nodeName))
		q:nodeName=""
		s ignoreFieldFlag=0
		if ($d(fromXmlMap(nodeName,"ClassFullName"))){
			if ($d(fromXmlMap(nodeName,"Type"))){
				s type=fromXmlMap(nodeName,"Type")
			}else{
				s type="Base"
			}
			if (type="Ref"){
				s objClassFullName=fromXmlMap(nodeName,"ClassFullName")
				s objPrimaryValue=fromXmlMap(nodeName)
				if ((objClassFullName="DHCWL.MKPI.MKPIDimType")&(nodeName="MKPIDimDimDr")&('$d(objectRefPool(objClassFullName,objPrimaryValue)))){
					s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(objPrimaryValue,objClassFullName)
					s dimExeStr="s dimObj=##class("_objClassFullName_").%OpenId("_id_")"
					x dimExeStr
					s objectRefPool(objClassFullName,objPrimaryValue)=dimObj
				}
				if ($d(objectRefPool(objClassFullName,objPrimaryValue))){
					s fromXmlMap(nodeName)=objectRefPool(objClassFullName,objPrimaryValue)
					s fromXmlMap(nodeName,"RefFlag")=1
					//add by wz.2014-10-16
					//zw objectRefPool
					//b
				}else{
					s ignoreFieldFlag=0
				}
			}
			continue:(ignoreFieldFlag)
			s classType=fromXmlMap(nodeName,"ClassFullName")
			if (exeStr=""){
				if ($d(fromXmlMap(nodeName,"RefFlag"))&&(fromXmlMap(nodeName,"RefFlag")=1)){
					s exeStr="s obj."_nodeName_"=fromXmlMap("""_nodeName_""")"
				}else{
					s exeStr="s obj."_nodeName_"="_..FormatExcuteStr(classType,fromXmlMap(nodeName))
				}
			}else{
				if ($d(fromXmlMap(nodeName,"RefFlag"))&&(fromXmlMap(nodeName,"RefFlag")=1)){
					s refHandle=fromXmlMap(nodeName)
					s exeStr=exeStr_",obj."_nodeName_"=fromXmlMap("""_nodeName_""")"
				}else{
					s exeStr=exeStr_",obj."_nodeName_"="_..FormatExcuteStr(classType,fromXmlMap(nodeName))
				}
				
			}
		}
	}
	
	//w !,exeStr 
	//b
	//q ""
	if (exeStr'=""){
		//w "exeStr="_exeStr,!
		;s exeStr=$REPLACE(exeStr,"this is ENG AND.I HATE IT","&")
		x exeStr
		s sc=""
		;if ($e(status,2)="1") x "s sc=obj.%Save()"
		x "s sc=obj.%Save()"
		i sc=1 q obj
		e  q ""
	}else{
		q ""
	}
}

ClassMethod ReadXMLDimNodeToTest(ByRef reader As %XML.TextReader, classFullName As %String, primaryValue, nodeLocationName = "", ByRef inService As DHCWL.MKPIIO.util.InputInterface, ByRef fromXmlMap)
{
	n (classFullName,primaryValue,nodeLocationName,reader,inService,fromXmlMap)
	q:reader="" ""
	q:((classFullName="")||(primaryValue="")) ""
	if (primaryValue [ "||") s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue,"||","__")
	else  s primaryValue2=primaryValue
	if (primaryValue2 [ "^") s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue2,"^","R_")
	s objPrimaryNodeName=classFullName_"-"_primaryValue2
	
		//元素里面不能含有小括号
	s objPrimaryNodeName=##class(DHCWL.util.StringUtil).ReplaceStr(objPrimaryNodeName,"(")
	s objPrimaryNodeName=##class(DHCWL.util.StringUtil).ReplaceStr(objPrimaryNodeName,")")

	
	if ($g(nodeLocationName)'="") s objPrimaryNodeName=nodeLocationName
	if ('reader.ReadStartElement(objPrimaryNodeName)){
		d reader.Rewind()
		q:'(reader.ReadStartElement(objPrimaryNodeName)) "" ;"不存在该节点："_objPrimaryNodeName
	}
	k fromXmlMap
	while(reader.Read()){
		if (reader.NodeType="element") {
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s refFlag=0,objFlag=0
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
	 		 		s attName=reader.Name,attValue=reader.Value
	 		 		s fromXmlMap(nodeName,attName)=attValue
				}
				d reader.MoveToElement()
			}
		}
		if (reader.NodeType="chars") {
			s nodeValue=reader.Value
			s fromXmlMap(nodeName)=nodeValue
		}
		if ((reader.NodeType="endelement")){
			if (reader.Name=objPrimaryNodeName){
				q
			}
		}
		if ((reader.NodeType="element")&&((nodeName="referencedDS"))){
			q
		}
	}
}

ClassMethod LinkRefHandle(classFullName, primaryValue, ByRef singleRefHandleMap, objectHandlePool As %ObjectHandle, ByRef inService As DHCWL.MKPIIO.util.InputInterface) As %ObjectHandle
{
	n (classFullName,primaryValue,singleRefHandleMap,objectHandlePool,inService)
	q:((classFullName="")||(primaryValue="")) ""
	q:(('$d(objectHandlePool(classFullName)))||('$d(objectHandlePool(classFullName,primaryValue)))) ""
	s obj=objectHandlePool(classFullName,primaryValue)
	s field="",excStr=""
	k refedObjMap
	f {
		s field=$o(singleRefHandleMap(classFullName,primaryValue,field))
		q:field=""
		s refedPrimaryValue=$g(singleRefHandleMap(classFullName,primaryValue,field,"RefedPrimaryValue"))
		s theObjPrimaryValue=$g(singleRefHandleMap(classFullName,primaryValue,field,"PrimaryValue"))
		s refedClassFullName=$g(singleRefHandleMap(classFullName,primaryValue,field,"RefedClassFullName"))
		s refedObj=..LinkRefHandle(refedClassFullName,refedPrimaryValue,.singleRefHandleMap,.objectHandlePool,.inService)
		s refedObjMap(field)=refedObj
		if (excStr=""){
			s excStr="s obj."_field_"=refedObjMap("""_field_""")"
		}else{
			s excStr=excStr_",obj."_field_"=refedObjMap("""_field_""")"
		}
	}
	s status=inService.JudgeInput(classFullName,primaryValue) //调用接口
	if (status="00"){
		q obj
	}elseif(status="01"){
	}elseif(status="10"){
		q obj
	}elseif(status="11"){
		
	}else{
		q ""
	}
	if (excStr'="") x excStr
	if (($e(status,2)="1")&&obj'="") d:obj'="" obj.%Save()
	q obj
}

ClassMethod FormatExcuteStr(type, value) As %String
{
	n (type,value)
	if ((type ["String")||(type [ "Text")) q """"_value_""""
	q value
}

// w ##class(DHCWL.MKPIIO.util.Read).GetXmlDimFlag("D:\test.xml")

ClassMethod GetXmlDimFlag(path = "", ByRef stream As %Library.FileBinaryStream = "")
{
	n (path,stream)
	if (path'=""){
		Set sc =##class(%XML.TextReader).ParseFile(path,.reader)
	}else{
		Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	s dimFlag=0,ok=0
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if ($zcvt(nodeName,"U")="STRUCTDS"){
				if (reader.HasAttributes) {
					s cnt=reader.AttributeCountGet()
					f i=1:1:cnt {
						d reader.MoveToAttributeIndex(i)
						if ($zcvt(reader.Name,"U")="DIMFLAG"){
							s dimFlag=reader.Value
							s ok=1
							q
						}
					}
				}
			}
		}
		q:ok=1
	}
	d reader.Rewind()
	q dimFlag
}

// w ##class(DHCWL.MKPIIO.util.Read).GetXmlVersion("D:\test.xml")

ClassMethod GetXmlVersion(path = "", ByRef stream As %Library.FileBinaryStream = "") As %String
{
	n (path,stream)
	if (path'=""){
		Set sc =##class(%XML.TextReader).ParseFile(path,.reader)
	}else{
		Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	s version=0,ok=0
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
					d reader.MoveToAttributeIndex(i)
					if ($zcvt(reader.Name,"U")="VERSION"){
						s version=reader.Value
						s ok=1
						q
					}
				}
			}
		}
		q:ok=1
	}
	d reader.Rewind()
	q version
}

/// Creator:         wk
/// CreatDate:       2017-12-21
/// Description:     获取导入xml文件的类型
/// Table:           
/// Input: 		  path：文件路径
/// Output:		  xml文件类型
/// Return:
/// Others:     
ClassMethod GetXmlGenerator(path = "", ByRef stream As %Library.FileBinaryStream = "") As %String
{
	n (path,stream)
	if (path'=""){
		Set sc =##class(%XML.TextReader).ParseFile(path,.reader)
	}else{
		Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	s version=0,ok=0
	while(reader.Read()){
		if (reader.NodeType="element"){
			s nodeName=reader.Name
			if (reader.HasAttributes) {
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
					d reader.MoveToAttributeIndex(i)
					if ($zcvt(reader.Name,"U")="GENERATOR"){
						s version=reader.Value
						s ok=1
						q
					}
				}
			}
		}
		q:ok=1
	}
	d reader.Rewind()
	q version
}

ClassMethod RunError()
{
	w $zerror,!
	k ^TEMPDHCWLKPIDATA("XMLNodeSession",$j)
}

}
