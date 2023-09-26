Class DHCWL.MKPIIO.OutputToXML Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
d ##class(DHCWL.MKPIIO.OutputToXML).Output("218","C:\","mkpis.xml")
*Creator:李海红
*导出指标及其和指标相关的所有数据，格式为XML。
*Inpute:mkpiCodes,以逗号为分隔符的指标代码;path保存文件的路径；fileName:要保存文件的名字
*Output：XML格式的文件
*Time:2012-10-30
*/
ClassMethod Output(mkpiCodes As %Text, path = "D:/test/", fileName = "mkpis.xml") As %String
{
	n (mkpiCodes,path,fileName)
	set writer=##class(%XML.Writer).%New()
	set writer.Charset="UTF-8"
	s filePathName=..GetFilePathName(path,fileName)   
    s sc= writer.OutputToFile(filePathName)
    q:sc="" ""
    s sc= writer.StartDocument()
    s verNode=$o(^DHCWL.MKPI.Version(""),-1)
    s version=1.0
    s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
    s sc=writer.RootElement("List")
    d writer.WriteAttribute("version",version)
    s mkpiCodes=..ConvertToMKPIId(mkpiCodes)
	s ith=1
	s len=$l(mkpiCodes,",")
	f ith=1:1:len d
	.s mkpiCode=$p(mkpiCodes,",",ith)
	.s id=+mkpiCode
	.q:id=0
	.s mkpiCode=$list(^DHCWL.MKPI.MKPID(id),2)
	.s sc=writer.Element(mkpiCode)
    .d:($g(id))>0 ..Out(id,.writer)
    .set sc=writer.EndElement()
	s sc=writer.EndRootElement()
    d writer.EndDocument()
    d writer.%Close()
    q $p(filePathName,"||")
}

/// d ##class(DHCWL.MKPIIO.OutputToXML).OutputOfStream("RegLocSexAge,RegLocOpNumsRT,EPRMRDepOpNums,RegLocOpNums",.s)
ClassMethod OutputOfStream(mkpiCodes As %Text, ByRef stream As %Library.FileBinaryStream) As %String
{
	n (mkpiCodes,stream)
	set writer=##class(%XML.Writer).%New()
	set writer.Charset="UTF-8"
    s sc= writer.OutputToStream(.stream)  ;.OutputToFile(filePathName)
    q:sc="" ""
    s sc= writer.StartDocument()
    s verNode=$o(^DHCWL.MKPI.Version(""),-1)
    s version=1.0
    s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
    s sc=writer.RootElement("List")
    d writer.WriteAttribute("version",version)
    s mkpiCodes=..ConvertToMKPIId(mkpiCodes)
	s ith=1
	s len=$l(mkpiCodes,",")
	f ith=1:1:len d
	.s mkpiCode=$p(mkpiCodes,",",ith)
	.s id=+mkpiCode
	.q:id=0
	.s mkpiCode=$list(^DHCWL.MKPI.MKPID(id),2)
	.s sc=writer.Element(mkpiCode)
    .d:($g(id))>0 ..Out(id,.writer)
    .set sc=writer.EndElement()
	s sc=writer.EndRootElement()
    d writer.EndDocument()
    d writer.%Close()
    //q $p(filePathName,"||")
}

/// Creator：lhh
/// Description： 根据对象的类全名和ID输出该类的多个实例数据的XML文档。
/// input：ids为要导出的类Id好，多个id用英文逗号分开，若要导出连续的id可用英文冒号分开(*可以输出从1开始所有连续的)。如"1,3,7,11:22,33";className问要导出的类类全名；path为导出文件存放路径；fileName为导出的文件名以.xml结束。
/// d ##class(DHCWL.MKPIIO.OutputToXML).OutputObject("19:21","DHCWL.MKPI.MKPI","C:\","testObj.xml")
ClassMethod OutputObject(ids As %Text, className, path = "D:/test/", fileName = "testAll.xml")
{
	n (ids,className,path,fileName)
	q:ids=""
	set writer=##class(%XML.Writer).%New()
	s filePathName=..GetFilePathName(path,fileName)  ;测试输入错误的分隔符
    s sc= writer.OutputToFile(filePathName)
    q:sc="" 0
    s sc= writer.StartDocument()
    set writer.Charset="UTF-8"
    s sc=writer.RootElement("List") //className_"-object" )
    i ids="*"{
	    s id=0
	    d{
		    s id=id+1
		    s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(id,className)
		    i code="" s code="Code-"_id
		    s sc=writer.Element(code)
		    s st=$$output(id)
		    set sc=writer.EndElement()
	    }while(st)
    }else{
    	f i=$l(ids,","):-1:1  d
    	.s id=$p(ids,",",i)
    	.i $l(id,":")>1  d
    	..s id2=id
    	..f j=+$p(id2,":",1):1:+$p(id2,":",2) d
    	...s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(j,className)
    	...i code="" s code="Code-"_j
		...s sc=writer.Element(code)
    	...d output(j)
    	...set sc=writer.EndElement()
    	.e  d
    	..s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(id,className)
    	..i code="" s code="Code-"_id
		..s sc=writer.Element(code)
    	..d output(id)
    	..set sc=writer.EndElement()
    }
    s sc=writer.EndRootElement()
    d writer.EndDocument()
    d writer.%Close()
    s obj=""
    q
output(aId)
    s obj=""
	s xecStr="s obj=##class("_className_").%OpenId("_aId_")"
	xecute xecStr
	i obj'="" d
	.d ..OutputHostObject(0,className ,className,aId,className,aId,1,.writer)
	q obj
}

ClassMethod Out(id, ByRef writer As %XML.Writer) As %Integer
{
  s listObj=##class(DHCWL.MKPIIO.ListObjectOutput).Inite(id)   //inite need output with mkpi
  s verNode=$o(^DHCWL.MKPI.Version(""),-1)
  s version=1.0
  s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
  /*
  i +version<3 d
  .s obj=listObj.mkpi
  .s className=obj.%ClassName()
  .s classFullName=obj.%PackageName()_"."_className
  .s objId=obj.%Id()
  .d ..OutputHostObject(0,classFullName ,classFullName,objId,classFullName,objId,1,.writer)
  
  .s listCreateDataTask=listObj.taskList
  .s len=listCreateDataTask.Count()
  .f i=1:1:len  d
  ..s obj=listCreateDataTask.GetAt(i)
  ..q:obj=""
  ..s className=obj.%ClassName()
  ..s classFullName=obj.%PackageName()_"."_className
  ..s objId=obj.%Id()
  ..d ..OutputHostObject(0,classFullName ,classFullName,objId,"DHCWL.MKPI.MKPI",objId,1,.writer)
  i +version<3.0 q $$$OK
  */
  // out put kpi
  s obj=listObj.mkpi
  s className=obj.%ClassName()
  s classFullName=obj.%PackageName()_"."_className
  s objId=obj.%Id()
  d ..OutputHostObject(0,classFullName ,classFullName,objId,classFullName,objId,1,.writer)
  //output mkpiDim
  i +version>=3.0 d
  .s kpiDimList=listObj.mkpiDimList
  .s len=kpiDimList.Count()
  .k dimArr
  .f i=1:1:len d			
  ..s obj=kpiDimList.GetAt(i)
  ..q:obj=""
  ..s dim=obj.MKPIDimDimDr
  ..s dimArr(dim.%Id())=""
  ..s className=obj.%ClassName()
  ..s classFullName=obj.%PackageName()_"."_className
  ..s objId=obj.%Id()
  ..d ..OutputHostObject(0,classFullName ,classFullName,objId,"DHCWL.MKPI.MKPI",objId,1,.writer)
  //output kpi task
  s listCreateDataTask=listObj.taskList
  s len=listCreateDataTask.Count()
  f i=1:1:len  d
  .s obj=listCreateDataTask.GetAt(i)
  .q:obj=""
  .s className=obj.%ClassName()
  .s classFullName=obj.%PackageName()_"."_className
  .s objId=obj.%Id()
  .d ..OutputHostObject(0,classFullName ,classFullName,objId,"DHCWL.MKPI.MKPI",objId,1,.writer)
  q:+version<3.0 $$$OK
  //now process dimpro
  s dimId="" f  s dimId=$o(dimArr(dimId)) q:dimId=""  d
  .s dimProList=##class(DHCWL.MKPIIO.DimPropertyService).FindObjectById(dimId)
  .s len=0
  .s:dimProList len=dimProList.Count()
  .f i=1:1:len  d
  ..s obj=dimProList.GetAt(i)
  ..q:obj=""
  ..s className=obj.%ClassName()
  ..s classFullName=obj.%PackageName()_"."_className
  ..s objId=obj.%Id()
  ..d ..OutputHostObject(0,classFullName ,classFullName,objId,"DHCWL.MKPI.MKPIDimType",,1,.writer)
  q $$$OK
}

/*
*Creator:李海红
*导出指标及其和指标相关的所有数据，格式为XML。
*Inpute: isRefered：是否为被引用对象？；nodeName：导出的节点名字；hostClassFullName：引用对象类全名；id：引用对象ID；referencedClassFullName：被引用对象类全名；referencedId：被引用对象ID
*isOnlyOid：是否对被引用对象只输出引用的ID？；writer：文件输出句柄
*Output：XML格式的文件
*Time:2012-10-30
*/
/// 将对象输出为符合XML格式数据的服务方法
/// Creator:lhh
/// CreateDate:2012-10-25
ClassMethod OutputHostObject(isRefered = 0, nodeName, hostClassFullName, id, referencedClassFullName, referencedId, isOnlyOid As %Boolean = 1, ByRef writer As %XML.Writer) As %Integer
{
	n (isRefered,nodeName,hostClassFullName,id,referencedClassFullName,referencedId,isOnlyOid,writer)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(hostClassFullName)
	q:$g(cdef)="" $$$OK
	Set count = cdef.Properties.Count()
	i count<1 q $$$OK
	//output obj is not the referenced
	i 'isRefered {
		d writer.Element(hostClassFullName_"-"_id)
		d writer.WriteAttribute("Property",nodeName)
		d writer.WriteAttribute("ID",id)
		s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(id,hostClassFullName)
		i code="" s code=id
		d writer.WriteAttribute("Code",code)
		d writer.WriteAttribute("ClassFullName",hostClassFullName)
	}
 	s hostObject=""
 	s xecStm="s hostObject=##class("_hostClassFullName_").%OpenId("_id_")"
 	NEW $ETRAP
 	s $ET="goto runError"
 	tstart
 	xecute xecStm
 	i $g(hostObject)="" {
	 	tcommit
	 	q $$$OK
 	}
 	f proI=1:1:count d
 	.s pro=cdef.Properties.GetAt(proI)
 	.s proType=pro.Type
 	.s v=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(hostObject,pro.Name) ;$PROPERTY(hostObject,pro.Name)
 	.q:($g(v)="")||($g(v)=$c(0))
 	.i ..IsDateType(proType) d 		//base type
 	..d writer.Element(pro.Name)
 	..i proType="%Date" s v=$zd(v,3)
 	..d writer.Write(v)
 	..d writer.EndElement()
 	.e  d
 	..i proType=referencedClassFullName d	//referenced obj
 	...i ('isRefered)&&(isOnlyOid) d
 	....s v=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(hostObject,pro.Name)
 	....s tempId=v.%Id()
 	....s:$g(tempId)="" tempId=referencedId
 	....d writer.Element(referencedClassFullName_"-"_tempId)
 	....d writer.WriteAttribute("ID",tempId)
 	....d writer.WriteAttribute("Property",pro.Name)
 	....d writer.WriteAttribute("ClassFullName",proType)
 	....s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(tempId,referencedClassFullName)
 	....i code="" s code=tempId
 	....d writer.WriteAttribute("Code",code)
 	....d writer.Write(code)
 	....d writer.EndElement()
 	....;do ok
 	..else  d //other obj
 	...i pro.Type=hostClassFullName d
 	....d writer.Element(pro.Type_"-"_v.%Id())
 	....d writer.WriteAttribute("ID",v.%Id())
 	....d writer.WriteAttribute("Property",pro.Name)
 	....d writer.WriteAttribute("ClassFullName",hostClassFullName)
 	....s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(v.%Id(),pro.Type)
 	....i code="" s code=v.%Id()
 	....d writer.WriteAttribute("Code",code)
 	....d writer.EndElement()
 	...e  d
 	....d writer.Element(pro.Type_"-"_v.%Id())
 	....d writer.WriteAttribute("ID",v.%Id())
 	....d writer.WriteAttribute("Property",pro.Name)
 	....d writer.WriteAttribute("ClassFullName",pro.Type)
 	....s code=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(v.%Id(),pro.Type)
 	....i code="" s code=v.%Id()
 	....d writer.WriteAttribute("Code",code)
 	....d ..OutputHostObject(1,pro.Name,pro.Type,v.%Id(),referencedClassFullName,referencedId,isOnlyOid,.writer)   ;d writer.Object($PROPERTY(hostObject,proI))
 	....d writer.EndElement()
 	d:'isRefered writer.EndElement()
 	tcommit
 	q $$$OK
runError
	trollback
	//s $ET=""
	q
}

/// ##class(DHCWL.MKPIIO.OutputToXML).IsDateType
/// 判断类型是否为基本数据类型
ClassMethod IsDateType(type) As %Boolean
{
	n (type)
	s flag=0
	i type="%String" d
	.s flag=1
	else  if type="%Integer" d
	.s flag=1
	else  if type="%Double" d
	.s flag=1
	else  if type="%Date" d
	.s flag=1
	else  if type="%Double" d
	.s flag=1
	else  if type="%Decimal" d
	.s flag=1
	else  if type="%Float" d
	.s flag=1
	else  if type="%Boolean" d
	.s flag=1
	else  if type="%Binary" d
	.s flag=1
	else  if type="%Currency" d
	.s flag=1
	else  if type="%Name" d
	.s flag=1
	else  if type="%Time" d
	.s flag=1
	else  d
	.s flag=0
	q flag
}

/// 根据不同操作系统创建所给路径的文件路径（若不存在）
/// w ##class(DHCWL.MKPIIO.OutputToXML).GetFilePathName("D:/test/test.xml","MRLocRyrs,REGLOCOPNUMS,RegDocOpNums,RegLocEpNums")
ClassMethod GetFilePathName(pathName, name) As %String
{
	n (pathName, name)
	s pathInfo=##class(DHCWL.util.DirectoryFile).SetPathOS(pathName,name)
	s path=$p(pathInfo,"||",1)
	;s deli=$p(pathInfo,"||",2)
  	q path
}

ClassMethod SetPathOS(name... As %List) As %String
{
	n (name)
	s deli="/"
	s version=$ZVERSION
	s path=""
	i version ["Windows" {
		s deli="\"
	}
	s len=$get(name,0)
	f i=1:1:len-1  {
		s path=path_$get(name(i))_deli
	}
	s path=path_$get(name(len))
	i deli="/" d
	.s wrong="\"
	e  d
	.s wrong="/"
	s path2=""
	f i=1:1:$l(path) d
	.i $e(path,i)=wrong  s path2=path2_deli
	.e  s path2=path2_$e(path,i)
	i path2 ["."  d
	.s len=$l(path2,deli)
	.s path=$p(path2,deli,0,len-1),fileName=$p(path2,deli,len)
	d ##class(%File).CreateDirectoryChain(path)
	i $g(fileName)'=""  d
	.s file=##class(%File).%New(path_deli_fileName)
	.d file.Open("WN")
	.d file.Close()
	.s path=path_deli_fileName
	q path_"||"_deli
}

/// w ##class(DHCWL.MKPIIO.OutputToXML).ConvertToMKPIId("245-444")
ClassMethod ConvertToMKPIId(mkpi) As %Text
{
	n (mkpi)
	q:mkpi="" ""
	k arr
	f i=$l(mkpi,","):-1:1 {
		s kpiR=$p(mkpi,",",i)
		i $l(kpiR,"-")>1 {
			s kpiS=$p(kpiR,"-",1),kpiE=$p(kpiR,"-",2)
		}else{
			s kpiS=kpiR,kpiE=kpiR
		}
		s kpiS2=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiS)
		s kpiE2=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiE)
		s:+kpiS2>0 kpiS=kpiS2
		s:+kpiE2>0 kpiE=kpiE2
		s kpiS=+kpiS,kpiE=+kpiE
		f kpiId=kpiS:1:kpiE {
			s tmpkpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(kpiId)
			i (tmpkpiId="")||(+tmpkpiId=0) continue
			s arr(tmpkpiId)=""
		}
	}
	s res=""
	s kpiId="" f  s kpiId=$o(arr(kpiId)) q:kpiId=""  d
	.i res="" s res=kpiId
	.e  s res=res_","_kpiId
	q res
}

}
