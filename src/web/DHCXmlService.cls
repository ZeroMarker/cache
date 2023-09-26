/// @author: wanghc
/// @date : 20130303
/// @desc: 解析xml串
Class web.DHCXmlService Extends %RegisteredObject
{

/// w ##class(web.DHCXmlService).GetValueByQNameTest()
ClassMethod GetValueByQNameTest()
{
	set xml = "<Request><instId>盘点主表id</instId><incRowid>药品id</incRowid><uomId>单位id</uomId><countQty>实盘数</countQty><userId>实盘人id</userId></Request>"
	;q ##class(web.DHCXmlService).GetValueByQName(xml,"incRowid")
	set xml = "<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'><cas:authenticationSuccess><cas:user>demo</cas:user></cas:authenticationSuccess></cas:serviceResponse>"
	q ##class(web.DHCXmlService).GetValueByQName(xml,"cas:authenticationSuccess->cas:user")
}

/// 
/// 查找Node节点中名字QName的子节点
ClassMethod GetNode(Node As %XML.Node, QName) As %XML.Node
{
	if $IsObject(Node){
		if (Node.HasChildNodes()){
			do Node.MoveToFirstChild()
			if (Node.QName'=QName){
				do{
					q:'Node.MoveToNextSibling()
					q:Node.QName=QName 
				}while(1)
			}
			if Node.QName = QName q Node
		}
	}
	q ""
}

/// 查找xml中子节的文本值
/// ##class(web.DHCXmlService).GetValueByQName("<User><UserName>wanghc</UserName><Sex>man</Sex></User>","UserName")
/// set xml = "<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'><cas:authenticationSuccess><cas:user>demo</cas:user></cas:authenticationSuccess></cas:serviceResponse>"
/// ##class(web.DHCXmlService).GetValueByQName(xml,"cas:authenticationSuccess->cas:user")
ClassMethod GetValueByQName(xml, qName)
{
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(xml)	
	s doc = reader.Document
	s text=""
	s node = doc.GetDocumentElement()
	s text="" 
	Set nodeNameLevel = $l(qName,"->")
	for j=1:1:nodeNameLevel {
		b ;j
		s node = ..GetNode(node,$p(qName,"->",j))
		b ;node		
	}
	if (node'=""){
		do node.GetText(.text)
	}
	q text
}

/// serviceResponse
ClassMethod GetValueByNodeName(xml, nodeName)
{
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenString(xml)	
	s doc = reader.Document
	s text=""
	s node = doc.GetDocumentElement()
	if (node.HasChildNodes()){
		d node.MoveToFirstChild()
		if (node.LocalName'=nodeName){
			do{
				q:'node.MoveToNextSibling()
				d:node.LocalName=nodeName node.GetText(.text)
			}while(1)		
		}else{
			d node.GetText(.text)
		}
	}
	q text
}

}
