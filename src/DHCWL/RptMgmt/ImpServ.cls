Class DHCWL.RptMgmt.ImpServ Extends %RegisteredObject
{

ClassMethod JsonData(xmlPath, ByRef mkpiArr, checkFlag As %Boolean = 0) As %String
{


	//b
	//n (xmlPath,mkpiArr,checkFlag)
	k mkpiArr
	K ^||TEMPDHCWL($j,"MGMTIMP")
	s NO=0
	Set sc =##class(%XML.TextReader).ParseFile(xmlPath,.reader)
	s version=##class(DHCWL.MKPIIO.util.Read).GetXmlVersion(xmlPath)
	s generator=..GetXmlGenerator(xmlPath)
	//w "generator="_generator
	q:(generator'="mgmt")

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
							s NO=NO+1
							
						}
					}
				}
				d reader.MoveToElement()
	   		}
		}elseif (reader.NodeType="chars"){
			s ^||TEMPDHCWL($j,"MGMTIMP",NO,nodeName)=reader.Value
		}
	}
	//b
	
	s className=""
	s primaryValue=""
	s fieldName=""
	s filedValue=""
	s NO=0
	s jsonData=""
	s jsonDatas=""
	

	
	s fieldName=""
	s NO=0
	s jsonData=""

	w "["
	s aryJsData=""
	f {
		s NO=$o(^||TEMPDHCWL($j,"MGMTIMP",NO))
		q:NO=""
		s fieldName=""
		s jsonData=""
		f {
			s fieldName=$o(^||TEMPDHCWL($j,"MGMTIMP",NO,fieldName))
			q:fieldName=""
			
			s fieldValue=^||TEMPDHCWL($j,"MGMTIMP",NO,fieldName)
			if fieldName="CreateDate" || (fieldName="UPdateDate") {
				if +$g(fieldValue)>0 s fieldValue=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(fieldValue)
			}
			if jsonData'="" s jsonData=jsonData_","
			s jsonData=jsonData_""""_fieldName_""":"""_fieldValue_""""			
			
			//if jsonData'="" s jsonData=jsonData_","
			//s jsonData=jsonData_""""_fieldName_""":"""_^||TEMPDHCWL($j,"MGMTIMP",NO,fieldName)_""""
		}
		if aryJsData'="" s aryJsData=aryJsData_","
		s aryJsData=aryJsData_"{"_jsonData_"}"

	}
	w $g(aryJsData)
	w "]"
	K ^||TEMPDHCWL($j,"MGMTIMP")
	q
}

ClassMethod GetXmlGenerator(path = "", ByRef stream As %Library.FileBinaryStream = "") As %String
{
	//n (path,stream)
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

}
