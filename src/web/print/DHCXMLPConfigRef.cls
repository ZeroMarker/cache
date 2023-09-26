Class web.print.DHCXMLPConfigRef Extends %Persistent
{

/// 指向User.DHCXMLPConfig
Property XMLPConfig As %String;

/***
var inpara = 
"patname"+ch2+"病人甲"+"^"+ "pno"+ch2+"8766779"+"^"+ "link"+ch2+"http://www.dhc.com"
*/
/// 可以写串
Property XMLTxtData As %String(MAXLEN = 30000);

/**
var inlist = 
"医嘱名^数量^代码"+ch2+ "葡萄糖^3瓶^ptt"+ch2+ "氯化钠(50%100)^9袋^lfn"
*/
/// 可以写串
Property XMLListData As %String(MAXLEN = 30000);

/// 保存DHCXMLPConfig表时置为N, 预览时重新生成mac成功后改成Y
Property GenFlag As %String;

/// 类方法与query的入参值
Property XMLClassMethodPara As %String(MAXLEN = 20000);

Index XMLPConfigIndex On XMLPConfig As Exact;

ClassMethod Save(XMLPConfig, XMLTxtData = "", XMLListData = "", GenFlag = "N", XMLClassMethodPara = "")
{
	;Set ^Wanghc("XMLRef",1)=$lb(XMLPConfig, XMLTxtData, XMLListData, GenFlag, XMLClassMethod, XMLClassQuery)
	Quit:XMLPConfig="" -1
	Set Id = $O(^web.print.DHCXMLPConfigRefI("XMLPConfigIndex",XMLPConfig,""),-1)
	If (Id>0){
		Set configRefObj = ##class(web.print.DHCXMLPConfigRef).%OpenId(Id)
	}else{
		Set configRefObj = ##class(web.print.DHCXMLPConfigRef).%New()
	}
	
	If $IsObject(configRefObj){
		Set configRefObj.XMLPConfig = XMLPConfig
		if (XMLListData'="") Set configRefObj.XMLListData = XMLListData
		if (XMLTxtData'="") Set configRefObj.XMLTxtData = XMLTxtData
		if (GenFlag'="") Set configRefObj.GenFlag = GenFlag
		if (XMLClassMethodPara'="") Set configRefObj.XMLClassMethodPara = XMLClassMethodPara
		Set sc = configRefObj.%Save()
		if $$$ISERR(sc){
			Set Id = "-1^"_$SYSTEM.Status.GetErrorText(sc)
		}else{
			Set Id = configRefObj.%Id()
		}
	}
	Quit Id
}

Storage Default
{
<Data name="DHCXMLPConfigRefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMLPConfig</Value>
</Value>
<Value name="3">
<Value>XMLTxtData</Value>
</Value>
<Value name="4">
<Value>XMLListData</Value>
</Value>
<Value name="5">
<Value>GenFlag</Value>
</Value>
<Value name="6">
<Value>XMLClassMethodPara</Value>
</Value>
</Data>
<DataLocation>^web.print.DHCXMLPConfigRefD</DataLocation>
<DefaultData>DHCXMLPConfigRefDefaultData</DefaultData>
<IdLocation>^web.print.DHCXMLPConfigRefD</IdLocation>
<IndexLocation>^web.print.DHCXMLPConfigRefI</IndexLocation>
<StreamLocation>^web.print.DHCXMLPConfigRefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
