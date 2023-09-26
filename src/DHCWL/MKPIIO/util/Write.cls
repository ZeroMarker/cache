Class DHCWL.MKPIIO.util.Write Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
s list=##Class(%Library.ListOfObjects).%New()
;d list.Insert(##class(DHCWL.MKPI.MKPI).%OpenId(2036))
d list.Insert(##class(DHCWL.MKPI.MMgrDataSetCfg).%OpenId(262))
s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,"D:\test3.xml")
*/
ClassMethod WriteXML(ByRef objHandle As %ListOfObjects, ByRef writeService As DHCWL.MKPIIO.util.OutputInterface = "", path = "", ByRef stream As %Library.FileBinaryStream = "", generator = "kpi", dimFlag = 0) As %Status
{
	n (objHandle,writeService,path,stream,generator,dimFlag)
	;q:((path="")&&(stream="")) "参数path和stream不能同时为空"
	;s objHandle=##Class(%Library.ListOfObjects).%New()
	;d objHandle.Insert(##class(DHCWL.MKPI.MKPIDimensions).%OpenId(1061))
	set writer=##class(%XML.Writer).%New()
	set writer.Charset="UTF-8"
	if (path'=""){
		s path=##class(DHCWL.util.DirectoryFile).SetPathOS(path)
		s path=$p(path,"||")
		s sc= writer.OutputToFile(path)
	}else{
		s sc= writer.OutputToStream(.stream)
	}
	if ($$$ISERR(sc)){ 
		d $system.OBJ.DisplayError(sc) 
		q "解析文档失败，请检查XML文档的格式"
	}
	if (writeService=""){
		s writeService=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	}
    s sc= writer.StartDocument()
    s sc=writer.RootElement("structDS")
    s version=##class(DHCWL.MKPIService.VersionPath).GetVersion()
    d writer.WriteAttribute("Version",version)
    //++add by wz 2014-3-27;加入“生成者”。
    d writer.WriteAttribute("generator",generator)
    //++add by wk 2016-5-25;如果不导入维度信息,加入标志。
    if (dimFlag=1){
	    d writer.WriteAttribute("dimFlag",dimFlag)
    }
    
    s len=objHandle.Count()
    f i=1:1:len {
	    s obj=objHandle.GetAt(i)
	    d:obj'="" ..WriteObjToXML(.writer,.session,.obj,.writeService,,"Object",dimFlag)
    }
    d ..CacheAllHandle(.session,.writeService)
    d writer.Element("referencedDS")
    d writer.WriteAttribute("Mark","MKPIPrivate")
    s class=""
    for {
	    s class=$o(session(class))
	    q:class=""
	    s handle=""
	    for {
		    s handle=$o(session(class,handle))
		    q:handle=""
		    s objHandle=session(class,handle)
		    d:objHandle'="" ..WriteObjToXML(.writer,.tempSession,objHandle,.writeService,,"Single")
	    }
    }
    s sc=writer.EndElement()
    s sc=writer.EndRootElement()
    d writer.EndDocument()
    d writer.%Close()
    q $$$OK
}

ClassMethod WriteObjToXML(ByRef writer As %XML.Writer, ByRef refSessionArr, obj As %ObjectHandle, ByRef outService As DHCWL.MKPIIO.util.OutputInterface, nodeName = "", defType = "", dimFlag = 0) As %Status
{
	n (obj,writer,outService,refSessionArr,nodeName,defType,dimFlag)
	s classFullName=..GetClassFullNameFromHandle(obj)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(classFullName)
	q:$g(cdef)="" "无法打开"_classFullName_"类的定义原型，请编译该类！"
	s primaryField=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(classFullName)
	s primaryValue=##class(DHCWL.MKPIIO.XMLIOConfige).GetPrimaryValue(obj,primaryField)
	if primaryValue [ "||" {
		s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue,"||","__")
	}else{
		s primaryValue2=primaryValue
	}
	if $g(primaryValue2) [ "^" {
		s primaryValue2=##class(DHCWL.util.StringUtil).ReplaceStr(primaryValue2,"^","R_")
	}
	s fieldName=nodeName
	if (nodeName="") s nodeName=classFullName_"-"_primaryValue2
	//元素里面不能含有小括号
	s nodeName=##class(DHCWL.util.StringUtil).ReplaceStr(nodeName,"(")
	s nodeName=##class(DHCWL.util.StringUtil).ReplaceStr(nodeName,")")
	s sc=writer.Element(nodeName)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	d writer.WriteAttribute("ClassFullName",classFullName)
	d writer.WriteAttribute("PrimaryField",primaryField)
	s sc=writer.WriteAttribute("PrimaryFieldValue",primaryValue)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	if (fieldName'="") d writer.WriteAttribute("Field",fieldName)
	s objFilterType= outService.JudgeNodeType(classFullName,primaryValue,primaryField)
	if ($g(objFilterType)="") s objFilterType="Base"
	if (defType="Single") s objFilterType=defType
	if (defType="Object") s objFilterType=defType
	d writer.WriteAttribute("Type",objFilterType)
	s count = cdef.Properties.Count()
	f proI=1:1:count {
 		s pro=cdef.Properties.GetAt(proI)
 		s proType=pro.Type
 		s proName=pro.Name
 		s proValue=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(obj,pro.Name)
 		continue:($g(proValue)="")||($g(proValue)=$c(0))
 		s tempObjFilterType= outService.JudgeNodeType(proType,primaryValue,proName,classFullName,primaryValue)
 		if ($g(tempObjFilterType)="") s tempObjFilterType="Null"
 		continue:tempObjFilterType="Null"
 		if ((tempObjFilterType'="Base")&&(defType="Single")) s tempObjFilterType=defType
 		if (tempObjFilterType="Base"){
	 		d writer.Element(proName)
	 		d writer.WriteAttribute("ClassFullName",proType)
	 	
	 		s sc=writer.WriteCData(proValue)
	 		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	 		d writer.EndElement()
 		}elseif (tempObjFilterType="Ref"){
	 		d writer.Element(proName)
	 		d writer.WriteAttribute("ClassFullName",proType)
	 		s tempPrimaryField=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(proType)
	 		d writer.WriteAttribute("PrimaryField",tempPrimaryField)
	 		s tempPrimaryValue=##class(DHCWL.MKPIIO.XMLIOConfige).GetPrimaryValue(proValue,tempPrimaryField)
	 		d writer.WriteAttribute("Type","Ref")
	 		d writer.WriteAttribute("Field",proName)
	 		d writer.WriteCData(tempPrimaryValue)
	 		d writer.EndElement()
	 		if ((dimFlag'=1)||(proType'="DHCWL.MKPI.MKPIDimType")){
	 			s:('$d(refSessionArr(proType,proValue))) refSessionArr(proType,proValue)=proValue
	 		}
 		}elseif (tempObjFilterType="Object"){
	 		d ..WriteObjToXML(.writer,.refSessionArr,.proValue,.outService,proName)
 		}elseif (tempObjFilterType="Single"){
	 		d writer.Element(proName)
	 		d writer.WriteAttribute("ClassFullName",proType)
	 		;d writer.WriteAttribute("Field",proName)
	 		s tempPrimaryField=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(proType)
	 		d writer.WriteAttribute("PrimaryField",tempPrimaryField)
	 		s tempPrimaryValue=##class(DHCWL.MKPIIO.XMLIOConfige).GetPrimaryValue(proValue,tempPrimaryField)
	 		d writer.WriteAttribute("Type","Ref")
	 		d writer.WriteAttribute("Field",proName)
	 		d writer.WriteCData(tempPrimaryValue)
	 		d writer.EndElement()
 		}
	}
	d writer.EndElement()
}

ClassMethod CacheAllHandle(ByRef cacheArr, ByRef outService As DHCWL.MKPIIO.util.OutputInterface)
{
	n (cacheArr,outService)
	s class=""
	f {
		s class=$o(cacheArr(class))
		q:class=""
		s handle=""
		f {
			s handle=$o(cacheArr(class,handle))
			q:handle=""
			s objHandle=cacheArr(class,handle)
			d ..CacheSingleHandle(.objHandle,.cacheArr,.outService)
		}
	}
}

/// 提取出所有的对象属性到缓存中。
ClassMethod CacheSingleHandle(ByRef handle As %ObjectHandle, ByRef sessionArr, ByRef outService As DHCWL.MKPIIO.util.OutputInterface)
{
	n (handle,sessionArr,outService)
	s classFullName=..GetClassFullNameFromHandle(handle)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(classFullName)
	q:$g(cdef)="" "无法打开"_classFullName_"类的定义原型，请编译该类！"
	s count = cdef.Properties.Count()
	f proI=1:1:count {
 		s pro=cdef.Properties.GetAt(proI)
 		s proType=pro.Type
 		s proName=pro.Name
 		s proValue=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(handle,pro.Name)
 		continue:($g(proValue)="")||($g(proValue)=$c(0))
 		s tempObjFilterType= outService.JudgeNodeType(proType,proValue)
 		if (tempObjFilterType'="Base"){
	 		if (('$d(sessionArr(proType,proValue)))&(proType'="DHCWL.MKPI.MKPIDimType")){
		 		s sessionArr(proType,proValue)=proValue
	 			d ..CacheSingleHandle(proValue,.sessionArr,.outService)
	 		}
 		}
	}
}

ClassMethod GetClassFullNameFromHandle(handle As %ObjectHandle) As %String
{
	n (handle)
	s classFullName=handle.%PackageName()
	if (classFullName'="") s classFullName=classFullName_"."_handle.%ClassName()
	else  s classFullName=handle.%ClassName()
	q classFullName
}

}
