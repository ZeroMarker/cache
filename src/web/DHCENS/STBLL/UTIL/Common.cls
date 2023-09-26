Class web.DHCENS.STBLL.UTIL.Common Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—05-14
/// Description：字符串替换
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr("")
ClassMethod ReplaceStr(inStr As %String, idStr As %String, ass As %String) As %String(MAXLEN=32767)
{
	s retStr=""
	s len=$l(inStr,idStr)
	f i=1:1:len
	{
		i i'=len d
		.s retStr=retStr_$p(inStr,idStr,i)_ass
		e  d
		.s retStr=retStr_$p(inStr,idStr,i)
	}
	q retStr
}

/// Creator：WuXianPu
/// CreatDate：2010-12-18
/// Description：去掉字符串中某种类型的字符
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.UTIL.Common).DeleteChar("farfaf","")
ClassMethod DeleteChar(Input As %String, Char As %String) As %String
{
   s len=$l(Input,Char)	
   s Output=""
   f i=1:1:len d
   .s str=$p(Input,Char,i)
   .s Output=Output_str
   q Output
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：获得某月的最大天数
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.UTIL.Common).GetMonthDays("2")
ClassMethod GetMonthDays(Month As %String) As %String
{
	s Days="0"
	q:(+Month<1)!(+Month>12) "0"
	i (+Month=2) d
	.s Days="28"
	else  i (+Month=1)!(+Month=3)!(+Month=5)!(+Month=7)!(+Month=8)!(+Month=10)!(+Month=12)  d
	.s Days="31"
	else  i (+Month=4)!(+Month=6)!(+Month=9)!(+Month=11)  d
	.s Days="30"
	q Days
}

/// Creator：WuXianPu
/// CreatDate：2012—05-09
/// Description：把病案号补足8位
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.UTIL.Common).TransMedicare("2344")
ClassMethod TransMedicare(Medicare As %String) As %String
{
	s Medi=Medicare
	s Len=$l(Medi)
	i Len<8 
	{
		f i=1:1:8-Len
		{
			s Medi="0"_Medi
		}
	}
	s Medicare=Medi
	q Medicare
}

/// Creator：WuXianPu
/// CreatDate：2016—05-31
/// Description：生成系统消息ID
/// Table：
/// Input： 
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID("64069")
ClassMethod CreateMessageID(messageDate As %String) As %String
{
	set $zt="Exception"
	set messageDate=$zd(messageDate,3)
	set messageDate=$tr(messageDate,"-","")
	set MessageID=$I(^MessageIDCounter(messageDate))
	Quit MessageID
Exception
	Quit "0"
}

/// Creator：WuXianPu
/// CreatDate：2014—04-17
/// Description：导出工程下所有类文件到指定路径
/// Table：
/// Input：package:保存路径,input:工程名称
/// Return："1^"_返回应导出文件个数
/// Others：w ##class(web.DHCENS.STBLL.UTIL.Common).ExportClass("D:\DHCENS\","DHCENS")
ClassMethod ExportClass(package As %String, input As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New("%Studio.Project:ProjectItemsList")
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(input)
	set rowData="",i=0	
	for  q:rs.Next()=0  d
	.set name=rs.GetData(2)
	.set type=rs.GetData(3)
	.if type'="CLS" d
	..set className=name
	.e  d
	..set className=name_"."_type
	.set sc=##class(%File).Exists(package_name_".xml")
	.if sc d
	..set sc=##class(%File).Delete(package_name_".xml")
	.set sc=$SYSTEM.OBJ.Export(className,package_name_".xml","","UTF8")
	.set i=i+1
	Quit "1^"_i
Exception
	Quit "-1^"_$ze
}

ClassMethod EvalXMLStream(val As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s newStream=##class(%GlobalCharacterStream).%New()
	while ('val.AtEnd) {
		s str=val.Read()
		s str = ..ReplaceStr(str,"&","&amp;")
		s str = ..ReplaceStr(str,"<","&lt;")
		s str = ..ReplaceStr(str,">","&gt;")
		s str = ..ReplaceStr(str,"""","&quot;")
		s str = ..ReplaceStr(str,"'","&apos;")
		//控制字符转义
		for i=1:1:31 {
			set str=..ReplaceStr(str,$c(i),"")
		}
		set str=..ReplaceStr(str,$c(127),"")
		set str=..ReplaceStr(str,$c(34),"")
		d newStream.Write(str)
	}
	q newStream
}

ClassMethod GetResultCode(inputContent As %GlobalCharacterStream) As %String
{
	
	set $zt="Exception"
	set resultCode="-1^"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		;set tSC=tDocument.EvaluateExpression("/Request/Body/ResultCode","text()",.tRes)
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set resultCode=tRes.GetAt(1).Value
		}
	}
	Quit resultCode
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2014—04-17
/// Description：重建类索引
/// Table：
/// Input：className：类名称
/// Return："1^"_状态
/// Others：w ##class(web.DHCENS.STBLL.UTIL.Common).BuildIndices("User.EnsTarLookUpTData")
ClassMethod BuildIndices(className As %String) As %String
{
	set exestr="sc=##class("_className_").%BuildIndices()",@exestr
	Quit "1^"_@("sc")
}

/// Creator：WuXianPu
/// CreatDate：2014—04-17
/// Description：导入CSV文件中字典表说明信息
/// Table：
/// Input：filePath: csv文件存放路径
/// Return："1^"_返回应导入字典表个数
/// Others：w ##class(web.DHCENS.STBLL.UTIL.Common).ImportTableConfigByCSVFile("C:\Documents and Settings\admin\桌面\术语集\a.csv")
ClassMethod ImportTableConfigByCSVFile(filePath As %String) As %String
{
	set $zt="Exception"
	set message = ##class(%FileCharacterStream).%New()
	set message.Filename = filePath  
	set tSc="1^导入成功"
	set i=0
	while 'message.AtEnd {
		set record=message.ReadLine()
		set code=$p(record,",",1)
		set i=i+1
		set ^TEMP("CSVFILE",i)=code
	}
	Quit "1^"_i
Exception
	Quit "-1^"_$ze
}

/// Others：w ##class(web.DHCENS.STBLL.UTIL.Common).CreateClass("web.DHCENS.CSV")
ClassMethod CreateClass(packageName As %String) As %String
{
	set $zt="Exception"
	set i=0
	set id="" f  set id=$o(^TEMP("CSVFILE",id)) q:id=""  d
	.set code=$g(^TEMP("CSVFILE",id))
	.set className=$tr(code,".","")
	.set className=$tr(className," ","")
	.set className=$tr(className,"/","")
	.set className=$tr(className,"-","")
	.set classFullName=packageName_"."_className
	.set sc=##class(%Dictionary.ClassDefinition).%ExistsId(classFullName)
	.if sc'=0 d
	..set sc=$SYSTEM.OBJ.Delete(classFullName)
	.set tClassDef = ##class(%Dictionary.ClassDefinition).%New(classFullName)
	.set tClassDef.ClassType="view"
	.set tClassDef.Owner="_SYSTEM"
	.set tClassDef.SqlTableName=className
	.set tClassDef.ViewQuery="SELECT CtmDictCode,CtmDictDesc,CtmDictAlias,CtmDictID,CtmDictLink FROM EMRmeta.CustomDictionary WHERE CtmDictType ='"_code_"'"
	.set sc= tClassDef.%Save()
	.if sc=1 d
	..set i=i+1
	Quit  i
Exception
	b ;0
}

/// w ##class(web.DHCENS.STBLL.UTIL.Common)LockGlobal()
ClassMethod LockGlobal() As %String
{
	set $zt="LockGobal"
	set Accdr="1"
	lock +^wangjia("Accm",Accdr)
	set aa=bb
LockGobal
	lock -^wangjia("Accm",Accdr)
}

/// Others：w ##class(LockGlobal).documentNode()
ClassMethod documentNode() As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<PatientInfo Desc=""患者基本信息"" aa=""bbb""><E00020000001 NationalCode=""HDSD00.11.110"" InCode="""" Name=""姓名"" Value=""""/><E00020000002 NationalCode=""HDSD00.11.111"" InCode="""" Name=""姓名2"" Value=""""/></PatientInfo>")
	set reader=##class(%XML.Reader).%New()
	set status=reader.OpenStream(stream)
	set document=reader.Document
	set node=document.GetDocumentElement()
	Set count=node.GetNumberAttributes()
	Set first=node.FirstAttributeName()
	Set next=node.NextAttributeName(first)
	d node.SetAttribute(first,"","vvvvv")
}

ClassMethod XMLtoJSONPro(path, xmlInput, listNodes, Output obj As %ObjectHandle = "") As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set sc = ##class(%XML.TextReader).ParseStream(xmlInput,.textreader,,,,,1)
	set num=0,sId=""
	;循环XML每一层节点,并存入临时的Global
	while (textreader.Read()) {
	set num=num+1
	set ^TMPXMLnodes($j,num)=$lb(textreader.Path,textreader.NodeType,textreader.Value)
	;将每个节点的全路径和入参进行对比,确定从哪个节点开始转换XML成JSON
	if (sId="")&&(textreader.Path=path)&&(textreader.NodeType="element")
	{
	set sId=num
	}
	}
	;将是数组的节点的全路径存入到临时Global中
	set len=$length(listNodes,"^")
	for i=1:1:len {
	set tmp=$p(listNodes,"^",i)
	continue:tmp=""
	set ^TMPXMLlistNodes($j,tmp)=""
	}
	set obj={}
	;当找不到开始转换的节点时,默认从第一个节点开始转换
	set:sId="" sId=1
	set rootName=$p($listGet(^TMPXMLnodes($j,sId),1),"/",*)
	;开始转换,返回的为sId后的XML转成的JSON,不包含sId
	set ret=..foreachXML(sId,.eId)
	do obj.%Set(rootName,ret)
	set json=##class(%GlobalCharacterStream).%New()
	do obj.%ToJSON(json)
	kill ^TMPXMLnodes($j)
	kill ^TMPXMLlistNodes($j)
	quit json
	
MsgErr
	b ;$ze
	set ^tmpzch("XMLtoJSONPro")=xmlInput
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1"_$ze)
	quit stream
}

/// set ret=##class(DHCENSLib.DB.DataManagerMethod).foreachXML(1,.id)
ClassMethod foreachXML(sId As %String, Output eId As %String) As %ObjectHandle
{
	set sPath=$listGet(^TMPXMLnodes($j,sId),1)
	set obj={},id=sId
	for {
	set id=$o(^TMPXMLnodes($j,id))
	quit:id=""
	set path=$listGet(^TMPXMLnodes($j,id),1)
	
	set type=$listGet(^TMPXMLnodes($j,id),2)
	set name=$p(path,"/",*)
	if (path=sPath)
	{
	if (type="chars")
	{
	set obj=$listGet(^TMPXMLnodes($j,id),3)
	}
	set:((sId+1)=id)&&(type="endelement") obj=""
	quit:(type="endelement")
	}
	else
	{
	set ret=..foreachXML(id,.id)
	quit:id=""
	if $d(^TMPXMLlistNodes($j,path))
	{
	if obj.%IsDefined(name)
	{
	do obj.%Get(name).%Push(ret)
	}
	else
	{
	do obj.%Set(name,[])
	do obj.%Get(name).%Push(ret)
	}
	}
	else
	{
	do obj.%Set(name,ret)
	}
	}
	}
	
	set eId=id
	quit obj
}

/// Creator：ZhangXinying
/// CreatDate：2023—04-14
/// Description：通过webservice地址获取HIS库dhwebservice用户密码
/// Input： webservice地址
/// Return：dhwebservice用户密码
/// Debug: w ##class(web.DHCENS.STBLL.UTIL.Common).GetWebSerPwd("https://localhost:1443/imedical/ekgwebservice/Interface.DHCC.EKGService4ENS.cls")
ClassMethod GetWebSerPwd(location As %String) As %String
{
	try
	{
		s postType=$p(location,":",1)
		if postType="https"
		{
			s addr=$p($p(location,"//",2),"/",1)
			s ip=$p(addr,":",1)
			s port=$p(addr,":",2)
			s url="https://"_ip_":"_port_"/imedical/web/csp/xml/iMedical.xml"
			s (httpip,httpport,relativePath)=""
			s startTag="http://"
			i (url["https://")
			{
				s startTag="https://"
			}
			s httpip=$p($p($p(url,startTag,2),"/",1),":",1)
			s httpport=$p($p($p(url,startTag,2),"/",1),":",2)
			i (httpport="") s httpport=""
			s relativePath=$replace(url,startTag,"")
			s relativePath=$e(relativePath,$find(relativePath,"/"),$l(relativePath))
			/// get http xml info
			s httprequest=##class(%Net.HttpRequest).%New()
			//tps证书配置
			s SSLName="SSLECP"
			i $l(SSLName){
				s httprequest.SSLConfiguration=SSLName
				s httprequest.SSLCheckServerIdentity=0
			}
			s httprequest.Https=1
			s httprequest.Server=httpip
			s httprequest.Port=httpport
			s tSc = httprequest.Get("/"_relativePath)
			s httpResponse=##class(%Net.HttpResponse).%New()
			s httpResponse=httprequest.HttpResponse
			s data=##class(%GlobalBinaryStream).%New()
			s data=httpResponse.Data
			s ret=data.Read(data.Size,.sc)
			s pwd=""
			set tSC=##class(%XML.XPATH.Document).CreateFromString(ret,.tDocument)
			set tSC=tDocument.EvaluateExpression("/Config/WebServicePassword","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set pwd=$tr(fieldValue,$c(0),"")
			}
		}
	}
	catch
	{
		s pwd=""
		s $zt=""
	}
	q pwd
}

}
