/// Creator:    yn
/// Desc       	解析word xml
Class EMRservice.ParseWordXML Extends EMRservice.BLBSParseXML
{

Parameter FONTSTYLE = "font-size:10.5pt;";

/// Creator:    yn
/// CreateDate: 2020-09-12
/// Input:      拼接html文档
/// Out      	病历html
/// Debug:      w ##Class(EMRservice.BLBSParseXML).concatHtml("270||8")
ClassMethod concatHtml(htmlS As %GlobalBinaryStream, styleS As %GlobalBinaryStream, bodyS As %GlobalBinaryStream)
{
	d styleS.Rewind()
	s styleHtml = "<style>"_styleS.Read()_"</style>"
	d htmlS.Write("<!DOCTYPE html><html>")
	d htmlS.Write("<head><meta  charset=""utf-8"" /><title >电子病历</title>"_styleHtml_"</head>")
	d htmlS.Write("<body style=""margin:0"">")
	d htmlS.Write("<div class=""page-size page-style"">")
	d bodyS.Rewind()
	while (bodyS.AtEnd = 0)
	{
		d htmlS.Write(bodyS.Read(32000))
	}
	d htmlS.Write("</div>")
	d htmlS.Write("</body>")
	d htmlS.Write("</html>")
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Desc:		从维护程序中读取全局字体样式,没有配置时设置默认字体大小为10.5pt
/// Input:      拼接html文档
/// Out      	全局样式
/// Debug:     
ClassMethod GetDefaultFont()
{
	s cssFont = ""
	s fontStyle = ""
	if ($d(%session)){
		s fontStyle = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetDefaultFontStyle")
	}
	if (fontStyle=""){
		s cssFont = ..#FONTSTYLE
	}else{
		s len = $l(fontStyle,",")
		for i=1:1:len{
			s fontStr = $p(fontStyle,",",i)
			s name = $replace($p(fontStr,":",1),"'","")
			s value = $replace($p(fontStr,":",2),"'","")
			s name = $case(name,"fontFamily":"font-family","fontSize":"font-size",:name)
			s cssFont = cssFont_name_":"_value_";"
			}
		}
	q cssFont
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      拼接html文档
/// Out      	全局样式
/// Debug:     
ClassMethod initStyle(styleS)
{
	s cssFont = ..GetDefaultFont()
	s pageStyle = ".page-style{padding: 1cm;margin: 0 auto;border: 1px #D3D3D3 solid;border-radius: 5px;background: white;box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);margin-bottom: 5px;}"
	s pageTable = ".page-content table,.page-header table {border-spacing: 0;}"
	s pageTableTd = ".page-content table tr td,.page-content table,.page-header table,.page-header table tr td {border: 0.8px solid #000;}"
	s headerP = "header table td p{text-indent: 0px !important;}"
	d styleS.Write("p{font-family:宋体;margin:0px;"_cssFont_"}")
	d styleS.Write(".page-content table tr{height:40px;}")
	d styleS.Write(pageStyle)
	d styleS.Write(pageTableTd)
	d styleS.Write(pageTable)
	d styleS.Write(headerP)
}

/// Desc:       处理array输出string
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      array
/// Output: 	string
ClassMethod ArrayToString(obj)
{
	s count = obj.Count()
	s str = "",key=""
	for i=1:1:count{
		s key = obj.Next(key)
		s value = obj.GetAt(key)
		w !,key_":"_value
		}
	w !,"总计："_count
}

/// Creator:    yn
/// CreateDate: 2023-04-07
/// Input:      
/// Out      	病历的imgdata数据
/// Desc       	通过xpath取病历的imgdata数据
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).handleImgDataByXPath()
ClassMethod handleImgDataByXPath(xmlStream)
{
	s res = ##Class(%ArrayOfDataTypes).%New()
	s sc = ##class(%XML.XPATH.Document).CreateFromStream(xmlStream,.doc)
	if ($$$ERROR(sc)) {
		q res
	}
	s doc.PrefixMappings = "prefix "_"http://www.abisource.com/awml.dtd"
	s sc = doc.EvaluateExpression("/Document/StructuredBody/NInstanceData/prefix:abiword","count(prefix:data/prefix:d)",.dNum)
	s dNum = $case(dNum.Count(),0:0,:dNum.GetAt(1).Value)
	for i=1:1:dNum{
		s sc = doc.EvaluateExpression("/Document/StructuredBody/NInstanceData/prefix:abiword","prefix:data/prefix:d["_i_"]/@name",.dName)	
		s sc = doc.EvaluateExpression("/Document/StructuredBody/NInstanceData/prefix:abiword","prefix:data/prefix:d["_i_"]/text()",.dText)	
		d:(dText.Count()>0) res.SetAt(dText.GetAt(1).Value,dName.GetAt(1).Value)
		}
	q res
}

ClassMethod initErrorPage(res, message = "")
{
	d res.Write("<div style=""display:none;"">"_message_"</div>")
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      病历xml流数据，AInstanceId：实例ID
/// Out      	病历xml异常返回"" 正常返回html流
/// Desc       	对病历xml节点进行遍历，获取所需要的header以及section部分并处理获得最终的html流
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).handleWordXml()
ClassMethod handleSingleDom(xmlStream, AInstanceId, bodyS, styleS, flag = "parse") As %GlobalBinaryStream
{
	//判断病历是否为压缩病历
	s zipFlag = ..GetPluginEMRZipFlag(AInstanceId)	
	if (zipFlag="TRUE"){
		d ..initErrorPage(bodyS,"插件压缩不支持解析")
		q		
		}
	s imgData = ..handleImgDataByXPath(xmlStream)
	s status = ##class(EMRservice.ExtendDomParse).GetDocumentFromStream(xmlStream,.document)
	if $$$ISERR(status) {
		d ..initErrorPage(bodyS,"糟糕,该病历无法显示呢")
		q
	}
	s scatterNode = ..GetNodeTargetSite(document,"ScatterData")
	//获取scatterNote的array值
	s scatterArry = ..GetScatterArry(scatterNode)
	//对abiword进行遍历
	s node = ..GetNodeTargetSite(document,"abiword")
	
	s status = node.MoveToFirstChild(1)
	s bodyNodeId="",headerNodeId=""
	do{
		if (node.LocalName="pagesize"){
			d ..handlePageSize(styleS,node)	
		}
		if (node.LocalName="section"){
			if ((node.GetAttributeValue("type")'="header")&&(node.GetAttributeValue("type")'="footer")){
				s bodyNodeId = node.NodeId
				}
			if (node.GetAttributeValue("type")="header"){
				s headerNodeId = node.NodeId
				}
		}
		/*if (node.LocalName="data"){
			s imgData = ..handleImgData(node)
		}*/
	}while(node.MoveToNextSibling(1))
	
	
	
	s paramList = ##Class(%ArrayOfDataTypes).%New()
	d paramList.SetAt(scatterArry,"scatterArry")
	
	if (flag="parse"){
		//获取在header处的指针，处理header
		d bodyS.Write("<header>")
		if (headerNodeId'=""){	
			s headerNode = document.GetNode(headerNodeId)
			d paramList.SetAt(AInstanceId,"InstanceId")
			d paramList.SetAt(bodyS,"bodyS")
			d paramList.SetAt(headerNode,"node")
			d paramList.SetAt(imgData,"imgData")
			d ..handleSection(paramList)
		}
		d bodyS.Write("</header>")
	}
	
	//获取在正文section处的指针,处理section	
	d bodyS.Write("<section class=""page-content"">")
	if (bodyNodeId'=""){
		s bodyNode = document.GetNode(bodyNodeId)
		d paramList.SetAt(AInstanceId,"InstanceId")
		d paramList.SetAt(bodyS,"bodyS")
		d paramList.SetAt(bodyNode,"node")
		d paramList.SetAt(imgData,"imgData")
		d ..handleSection(paramList)
	}
	d bodyS.Write("</section>")
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      病历xml流数据，AInstanceId：实例ID
/// Out      	病历xml异常返回"" 正常返回html流
/// Desc       	对病历xml节点进行遍历，获取所需要的header以及section部分并处理获得最终的html流
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).handleWordXml()
ClassMethod handleWordXmlByDom(xmlStream, instanceIDs, htmlResArry = "") As %GlobalBinaryStream
{
	s $zt = "Error"
	s htmlS = ##class(%GlobalBinaryStream).%New()
	s styleS = ##class(%GlobalBinaryStream).%New()
	s bodyS = ##class(%GlobalBinaryStream).%New()
	d ..initStyle(styleS)	
	s flag = "parse"
	s total = instanceIDs.Size
	if (total=1){
		s instanceid = instanceIDs.GetAt(1)
		d ..handleSingleDom(xmlStream,instanceid, bodyS, styleS,flag)
	}else{
		s argSeparator = "-----------------------------7da4a26140fde"
		s lastStream = xmlStream
		for i=1:1:total{
			s instanceid = instanceIDs.GetAt(i)
			s argOutFirstStream = ##Class(%GlobalBinaryStream).%New()			
			s lastStream = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(lastStream, argSeparator, argOutFirstStream)
			s:i'=1 flag="skip"
			d ..handleSingleDom(argOutFirstStream,instanceid, bodyS, styleS,flag)
		}
	}
	//拼装html
	d ..concatHtml(htmlS,styleS,bodyS)
	
	q htmlS
Error
	d:htmlResArry'="" htmlResArry.SetAt("-1^文档处理发生异常"_$zerror,"resDesc")
	q htmlS
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      node:指在data的位置
/// Out      	key:name value:text
/// Desc		获取打散数据，以键值对的形式返回
/// Debug:      
ClassMethod GetScatterArry(pNode) As %ArrayOfDataTypes
{
	s codeValue = ##Class(%ArrayOfDataTypes).%New()
	s comStatus = pNode.MoveToFirstChild(1) //指到ScatterData->Component
	s sectatus = 0
	s:(comStatus=1) sectatus = pNode.MoveToFirstChild(1) //指到ScatterData->Component->Section
	q:(sectatus'=1)||(comStatus'=1) codeValue
	do{
		//处理section
		d GetScatterSectionData
		
	}while(pNode.MoveToNextSibling(1))
	q codeValue
GetScatterSectionData
	//section内部循环
	s seChildStatus = pNode.MoveToFirstChild(1) //指到ScatterData->Component->Section->child
	if (seChildStatus=1){
		s path = "",sectionPath = ""
		do{
			s:pNode.LocalName="Code" sectionPath = pNode.GetAttributeValue("Code")
			if (pNode.LocalName="Composite"){
				//遍历Composite
				s comChildStatus = pNode.MoveToFirstChild(1) //指到ScatterData->Component->Section->Composite->child
				do{
					if (pNode.LocalName="Code"){
						s str = ""
						
						s:pNode.GetAttributeValue("Code")'="" str="_"_pNode.GetAttributeValue("Code")
						s path = sectionPath_str
					}
					if (pNode.LocalName="SubItems"){
						d:(pNode.HasChildNodes(1)=1) ..GetSubItems(pNode,path,codeValue)
					}
				}while(pNode.MoveToNextSibling(1))
				d:comChildStatus=1 GoToParent //ScatterData->Component->Section->Composite
			}
		}while(pNode.MoveToNextSibling(1))
		d:seChildStatus=1 GoToParent //ScatterData->Component->Section
	}
	q
GoToParent
	d pNode.MoveToParent()
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      node:指在data的位置
/// Out      	key:name value:text
/// Desc		获取结构化元素的值
/// Debug:      
ClassMethod GetSubItems(subNode, path, codeValue)
{
	s MIStatus = subNode.MoveToFirstChild(1) //指到subItem->MIString
	q:(MIStatus'=1)
	do{
		d ..GetSubChildData(subNode, path, codeValue)
		}while(subNode.MoveToNextSibling(1))
	d:MIStatus=1 subNode.MoveToParent()
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      node:指在data的位置
/// Out      	key:name value:text
/// Desc		获取结构化元素的值
/// Debug:      
ClassMethod GetSubChildData(subNode, path, codeValue)
{
	//取子元素的code和value
	s subStatus = subNode.MoveToFirstChild(1) //指到subItem->MIString->child
	q:(subStatus'=1)
	s itemPath = "",Separator="-1"
	do{
		s code = "",value=""
		if (subNode.LocalName="Code"){
			s code = subNode.GetAttributeValue("Code")
			s:code'="" itemPath = path_"_"_code
			}
		if (subNode.LocalName="Value"){
			//对value进行遍历
			s valueStatus = subNode.MoveToFirstChild(1) //subItem->MIString->value->child
			if (valueStatus=1){
				do{
					if (subNode.NodeType=$$$xmlTEXTNODE){
						//值类型
						s value = subNode.NodeData
					}else{
						//对子节点遍历	
						if (subNode.LocalName="Choice"){
							if (value=""){
							s value = subNode.GetAttributeValue("DisplayName")
							}else{
							s value = value_"-"_subNode.GetAttributeValue("DisplayName")	
							}
						}
					}
				}while(subNode.MoveToNextSibling(1))
				d GoToParent
				d codeValue.SetAt(value,itemPath)	
			}else{
					d codeValue.SetAt("",itemPath)
					}	
		}
		
		if (subNode.LocalName="Separator"){
			d subNode.GetText(.Separator)
		}
		if (subNode.LocalName="SubItems"){
			d ..GetSubItems(subNode, itemPath, codeValue)
			}
	}while(subNode.MoveToNextSibling(1))
	//获取当前结构化元素的分隔符
	if (value'=""&&(itemPath'="")){
		s value = codeValue.GetAt(itemPath)
		d:Separator'="-1" codeValue.SetAt($replace(value,"-",Separator),itemPath)
	}
	d:(subStatus=1) GoToParent //指到subItem->MIString
	q
GoToParent
	d subNode.MoveToParent()
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      node:指在data的位置
/// Out      	key:name value:text
/// Desc		获取imgdata数据，以键值对的形式返回
/// Debug:      
ClassMethod handleImgData(pNode) As %ArrayOfDataTypes
{
	s arry = ##Class(%ArrayOfDataTypes).%New()
	if (pNode.HasChildNodes(1)=1){
		s status = pNode.MoveToFirstChild(1) 
		do{
			s key = pNode.GetAttributeValue("name")
			s status = pNode.GetText(.value,1)
			d:key'="" arry.SetAt(value,key)
			s value = ""
		}while(pNode.MoveToNextSibling(1))
	}
	q arry
}

/// Creator:    yn
/// CreateDate: 2022-09-09
/// Input:      bodyS:body流,imgData[value,key],bodyNode当前指在正文section %XML.Node类型
/// Out      	流
/// Desc:		对section正文进行处理并直接写在body流中
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).handleBody()
ClassMethod handleSection(param As %ArrayOfDataTypes)
{
	s InstanceId = param.GetAt("InstanceId")
	s bodyS = param.GetAt("bodyS")
	s imgData = param.GetAt("imgData")
	s node = param.GetAt("node")
	s scatterArry = param.GetAt("scatterArry")
	//全局变量定义
	
	s ktb = $i(^CacheTableTrWH)
	s ^CacheTableTrWH(ktb) = ""
	s ^CacheTableTrWH(ktb,"instanceId") = InstanceId
	s ^CacheTableTrWH(ktb,"compositeCode") = ""
	d ..deepNode(node,bodyS,imgData,ktb,scatterArry)
	k ^CacheTableTrWH(ktb)
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      node %XML.Node类型
/// Out      	str
/// desc  		递归遍历xml节点树，处理元素、文本、空白节点，节点类型：元素0，文本1，空白2
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).deepNode()
ClassMethod deepNode(node As %XML.Node, res As %GlobalBinaryStream, imgData As %ArrayOfDataTypes, ktb As %String = "", scatterArry As %ArrayOfDataTypes)
{
	s status = node.MoveToFirstChild()
	do{
		s type = node.NodeType
		
		//标签起始
		if (type=$$$xmlELEMENTNODE){
			s nodeName = node.LocalName
			d StartTag
			}
		if (type=$$$xmlTEXTNODE){
			//对值进行处理
			d ..handleNodeValue(node,res,ktb,scatterArry)
			}
		//if (type=2){
			//空白节点处理第二种方式
			//对空白节点处理-父节点是标签类型，第一个孩子是空白节点将被忽略
			//d res.Write($replace(node.NodeData," ","&nbsp;"))
			//}
		if (type=$$$xmlELEMENTNODE&&(node.HasChildNodes()=1)){
			if (node.HasChildNodes(1)'=1){
				//空白节点处理第一种方式如果子节点都是空白节点直接取值不进行递归子节点
				s status = node.MoveToFirstChild()
				//空白节点默认给8pt
				if (node.NodeData[$c(9)){
					d res.Write($replace(node.NodeData,$c(9),"<span style=""padding-left:36px;""></span>"))
				}
				//因浏览器对空白节点的处理不一致，ie上出现换行的问题，white-space设置效果不佳，所以不使用连续的空白节点占位，使用文字占位-2023-03-24
				d res.Write($replace(node.NodeData," ","<span style=""font-size:6pt;display:inline-block;width:8px;height:8px;visibility:hidden;color:transparent;""></span>"))	
			}else{
				//有嵌套的元素节点则进行递归
				d ..deepNode(node,res,imgData,ktb,scatterArry)
			}	
			s status = node.MoveToParent() //还原指针
		}
		//标签结束
		if (type=$$$xmlELEMENTNODE){
			d EndTag
			}
}while(node.MoveToNextSibling(1))
	q
StartTag
	s props = node.GetAttributeValue("props")
	if (nodeName="table"){
		//获取行高
		d ..GetTrWH(props,ktb)
	}
	d $Case(
			nodeName
			,"p":..TagP(node,res)
			,"table":..TagTable(node,res)
			,"bookmark":..TagBookmark(node,res)
			,"cell":..TagBeginCell(node,res,ktb)
			,"c":..TagC(node,res)
			,"field":..TagField(node,res,ktb,scatterArry)
			,"math":..TagMath(node,res)
			,"image":..TagImage(node,res,imgData)
			,"br": res.Write("<br/>")
			,:default
		) 
	q
EndTag
	if (nodeName="table"){
		s ^CacheTableTrWH(ktb)=0
	}
	d $Case(
		nodeName
		,"p":TagEndP
		,"table":res.Write("</table>")
		,"bookmark":res.Write("</span>")
		,"cell":TagEndCell
		,"c":res.Write("</span>")
		,"field":res.Write("</span>")
		,"math":res.Write("</span>")
		,:default
	)
	q
TagEndP
	if (node.HasChildNodes()'=1||(node.HasChildNodes(1)'=1)){
			d res.Write("&nbsp;")
		}else{
		//判断是否都是bookmark标签
			s flag = 1
			s status = node.MoveToFirstChild()
			do{
				s pChildName = node.LocalName
				if (pChildName'="bookmark"){
					s flag = 0
					q
				}
			}while(node.MoveToNextSibling(1))	
			d:flag=1 res.Write("&nbsp;")
			d:status=1 node.MoveToParent()
		}
	d res.Write("</p>")
	
	q
TagEndCell
	s TempProps = node.GetAttributeValue("props")
	d res.Write("</td>")
	s TempArray = ..handleCellStyle(TempProps)
	s rowNum = TempArray.GetAt("trNum")
	//获取当前节点的弟弟节点
	s hasYoungNode = node.MoveToNextSibling(1)
	if ('hasYoungNode){
		//没有弟弟节点此为最后一个孩子节点
		d res.Write("</tr>")
		d createTR
	}else{
		s TempProps = node.GetAttributeValue("props")
		s TempArray = ..handleCellStyle(TempProps)
		s youngRowNum = TempArray.GetAt("trNum")
		if (rowNum'=youngRowNum){
				d res.Write("</tr>")
				//判断当前td前有几个哥哥节点以及获取他们的rowspan用于生成空的tr
				s status = node.MoveToPreviousSibling(1)
				d createTR
			}else{
				// 回到当前节点
				s status = node.MoveToPreviousSibling(1)				
			}
	}
default
    q
createTR
	//修改同一行td为相同的rowspan表格显示错误的bug
	//第一行每一列都是合并多行时应该找最小的合并行减一生成空tr
	s tdNodeId = node.NodeId
	s props = node.GetAttributeValue("props")
	s TempArray = ..handleCellStyle(props)
	s tdSpan = TempArray.GetAt("rowspan")
	q:(+tdSpan=1)
	s hasOther = 0
	s minspan = +tdSpan
	while (node.MoveToPreviousSibling(1)){
		s hasOther = 1
		s props = node.GetAttributeValue("props")
		s TempArray = ..handleCellStyle(props)
		s curRowSpan = +TempArray.GetAt("rowspan")
		if (minspan>curRowSpan){
			s minspan = curRowSpan
			}
	}
	if (minspan>1&&hasOther){
		for i=1:1:(minspan-1){
			d res.Write("<tr></tr>")
			}
		}
	if (hasOther){
		//回到当前节点
		 d node.MoveToParent()
		 d node.MoveToFirstChild(1)
		 s moveId = node.NodeId
		 if (moveId'=tdNodeId){
			 while(node.MoveToNextSibling(1)){
				 s moveId = node.NodeId
				 q:(moveId=tdNodeId)
				 }
		 }
	}
	
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-15
/// Input:      node：文本节点
/// debug 		w ##Class(EMRservice.BLBSParseXML).GetTrWH("text-align:left; line-height:1pt;top-color:000000; top-style:0;")
/// Out      	病历html
/// Desc		对父节点是c标签的文本节点进行处理，返回结果是：原值显示或从表中取的数据【空白节点单独处理】
ClassMethod handleNodeValue(node As %XML.Node, res As %GlobalBinaryStream, ktb As %String = "", scatterArry As %ArrayOfDataTypes)
{
	q:ktb=""
	s instanceId = ^CacheTableTrWH(ktb,"instanceId")
	//保存当前节点的NodeId
	s NodeId = node.NodeId
	s NodeData = node.NodeData
	if (instanceId=""){
		d res.Write(NodeData)
		q
		}
	//获取当前值元素的父元素
	s status = node.MoveToParent()
	s id = ""
	s revision = 1 //是否为留痕节点 
	s et = ""
	if (status){
		//只对c标签进行留痕显示的判断，其他标签不存值不判断
		s tagName = node.LocalName
		if (tagName="c"){
			s props = node.GetAttributeValue("props")
			s revision = node.GetAttributeValue("revision") //是否为留痕节点
			s array = ..GetKeyValue(props)
			s et = array.GetAt("et")
			s codeValue = $replace(array.GetAt("code")," ","")
			if (codeValue'=""){
				s leng = $l(codeValue,"^")
				s type = ""
				if (leng=1){
					//医院名称处理
					s id = codeValue
					}elseif(leng=2){
					//简单元素+医学概念+签名单元
					s id = $p(codeValue,"^",2)
					}	
				}			
			}
			//还原指针
			d ResetNode
		}
	if ('(..hiddenRevision(revision))){
	//隐藏的留痕节点不显示
		if (id'=""){			
				//if (NodeData["["){处置用药不包含[
					//提示信息处理
					s NodeData = ..GetCompositeValueByScatter(id,NodeData,ktb,scatterArry,"",et)
					//s NodeData = ..GetCompositeValue(id,NodeData,ktb,scatterArry) //从后台去
				//}
			}
		
		}
	s NodeData = $replace(NodeData," ","<span style=""font-size:6pt;display:inline-block;width:8px;height:8px;visibility:hidden;color:transparent;""></span>")		
	s NodeData = $replace(NodeData,$c(13),"<br/>")	
	d res.Write(NodeData)
	q
ResetNode
	s firstChild = node.MoveToFirstChild(1)
	do{
		q:NodeId=node.NodeId
		}while(node.MoveToNextSibling(1))
}

/// Creator:    yn
/// CreateDate: 2023-02-22
/// Desc: 用scatterdata数据对父节点是c标签的文本节点进行处理，返回结果是：原值显示或从表中取的数据【空白节点单独处理】
/// Input: 
/// debug:
/// Out      	
ClassMethod GetCompositeValueByScatter(id, NodeData, ktb, scatterArry, type = "", et = "")
{
	s res = NodeData
	q:id="" res
	q:id="GuideTitle" res
	if (scatterArry.IsDefined(id)){
		if (type="field"){
			s res = scatterArry.GetAt(id)
		}else{
			if (scatterArry.GetAt(id)=""){
				s res = ""
				}
		}
	}
	if (et="3"||(et="1")){
		if (scatterArry.GetAt(id)=""){
			s res = ""
			}		
		}
	q res
}

/// desc: 获取组件是否显示
/// output: 1隐藏留痕组件，0显示留痕组件
ClassMethod hiddenRevision(data)
{
	s res = 0
	q:data="" 0
	if (data[","){
		s len = $l(data,",")
		s value = $p(data,",",len)
		s:+value<0 res = 1
	}else{
		s:+data<0 res = 1
	}

	q res
}

/// Creator:    yn
/// CreateDate: 2022-09-14
/// Input:      id:Composite的唯一标识
/// debug 		w ##Class(EMRservice.BLBSParseXML).GetCompositeValue("S011_V010_MCC0012_N9155","")
/// Out      	Composite的值
ClassMethod GetCompositeValue(id As %String, value As %String, ktb As %String = "", scatterArry) As %String
{
	q:ktb=""
	s res = ""
	s instanceId = ^CacheTableTrWH(ktb,"instanceId")
	q:(id="")||(instanceId="") res
	s num = $l(id,"_")
	q:num<3 value
	s type = ""
	if (num>3){
		if (id["MCC"){
			s type = "MCC" //医学概念
		}else{
			//佳木斯中心存在S010_V009_V022_L0017为签名单元，直接返回值
			q value
			}
	}	
				
	s sectionCode = $replace($p(id,"_",1)," ","")
	q:sectionCode="" res
	s compositecode = $replace($p(id,"_",2)," ","")
	q:compositecode="" res
	s codeStr = ^CacheTableTrWH(ktb,"compositeCode")
	if (codeStr'[id){
		if (type=""){
			d Simple
		}elseif(type="MCC"){
			d MCC
		}
	}
	q res
Simple
	s ^CacheTableTrWH(ktb,"compositeCode") = ^CacheTableTrWH(ktb,"compositeCode")_"#"_id
	s simpleitemcode = $replace($p(id,"_",3)," ","")
	q:simpleitemcode="" res
	s UCode = $zconvert(sectionCode,"U")
	s rowid = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_instanceId," "_UCode," "_compositecode," "_simpleitemcode,""))
	q:rowid="" res
	s obj = ##Class(EMRinstance.ICompositeSimple).%OpenId(rowid)	
	s res = obj.DataValue
	q
MCC
	s ^CacheTableTrWH(ktb,"compositeCode") = ^CacheTableTrWH(ktb,"compositeCode")_"#"_id
	s conceptCode = $replace($p(id,"_",3)," ","")
	q:conceptCode="" res
	s simpleitemcode = $replace($p(id,"_",4)," ","")
	q:simpleitemcode="" res
	s UCode = $zconvert(sectionCode,"U")
	s rowid = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_instanceId," "_UCode," "_compositecode," "_conceptCode," "_simpleitemcode,""))
	q:rowid="" res
	s obj = ##Class(EMRinstance.ICompositeConceptSimple).%OpenId(rowid)	
	s res = obj.DataValue
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-14
/// Input:      table的props
/// debug 		w ##Class(EMRservice.BLBSParseXML).GetTrWH("text-align:left; line-height:1pt;top-color:000000; top-style:0;")
/// Out      	病历html
/// Desc		表格行高，列宽，线样式处理
ClassMethod GetTrWH(props As %String, ktb As %String = "") As %ArrayOfDataTypes
{
	q:ktb=""
	s ^CacheTableTrWH(ktb) = 1
	s array = ..GetKeyValue(props)
	
	s rowHeightStr = array.GetAt("table-row-heights")
	s ^CacheTableTrWH(ktb,"rowHeight") = rowHeightStr
	s colWidthStr = array.GetAt("table-column-props")
	s ^CacheTableTrWH(ktb,"colWidth") = colWidthStr
	s ^CacheTableTrWH(ktb,"border-top-style") = "solid"
	s ^CacheTableTrWH(ktb,"border-bottom-style") = "solid"
	s ^CacheTableTrWH(ktb,"border-right-style") = "solid"
	s ^CacheTableTrWH(ktb,"border-left-style") = "solid"
	s:array.GetAt("top-style")="0" ^CacheTableTrWH(ktb,"border-top-style") = "none"
	s:array.GetAt("bot-style")="0" ^CacheTableTrWH(ktb,"border-bottom-style") = "none"
	s:array.GetAt("right-style")="0" ^CacheTableTrWH(ktb,"border-right-style") = "none"
	s:array.GetAt("left-style")="0" ^CacheTableTrWH(ktb,"border-left-style") = "none"
	s count1 = $l(rowHeightStr,"/")
	for i=1:1:count1{
		s item = $p(rowHeightStr,"/",i)
		s ^CacheTableTrWH(ktb,"rowHeight",i)=item
		}
	s count2 = $l(colWidthStr,"/")
	for i=1:1:count2{
		s item = $p(colWidthStr,"/",i)
		s ^CacheTableTrWH(ktb,"colWidth",i)=item
	}
}

/// Creator:    yn
/// CreateDate: 2022-09-14
/// Input:      node:标签节点
/// debug 		w ##Class(EMRservice.BLBSParseXML).handleStyle("text-align:left; line-height:1pt;top-color:000000; top-style:0;")
/// Out      	样式字符串
/// Desc		获取每个标签上属性对应的css样式
ClassMethod transplateStyle(props)
{
	s str = ""
	if (props'=""){
		s total = $l(props,";")
		for i=1:1:total{
			s item = $p(props,";",i)
			s propName = $replace($p(item,":",1)," ","")
			s propValue = $p(item,":",2)
			s CssName = ""
			s CssValue = propValue
			d $Case(
				propName
				,"page-margin-top":margin("top")
				,"margin-top":margin("top")
				,"page-margin-left":margin("left")
				,"margin-left":margin("left")
				,"page-margin-right":margin("right")
				,"margin-right":margin("right")
				,"page-margin-bottom":margin("bottom")
				,"margin-bottom":margin("bottom")
				,"text-indent":textindent
				,"left-color":bordercolor("left")
				,"left-style":borderstyle("left")
				,"left-thickness":borderwidth("left")
				,"right-color":bordercolor("right")
				,"right-style":borderstyle("right")
				,"right-thickness":borderwidth("right")
				,"bot-color":bordercolor("bottom")
				,"bot-style":borderstyle("bottom")
				,"bot-thickness":borderwidth("bottom")
				,"top-color":bordercolor("top")
				,"top-style":borderstyle("top")
				,"top-thickness":borderwidth("top")
				//,"bgcolor":backgroundColor
				,"color":color
				,"display":default
				,"line-height":default
				,"text-align":default			
				,"text-transform":default
				,"list-style":default
				,"text-decoration":default
				,"height":default
				,"font-weight":default
				,"font-size":default
				,"font-family":default
				,"font-stretch":default
				,"font-variant":default
				,"font-style":default
				,"vert-align":verticalAlign
				,:empty
				)
			if (CssName'=""){
				s str=str_CssName_":"_CssValue_";"	
			}
			
		}
	}
	q str
verticalAlign
	s CssName = "vertical-align"
	s CssValue = $case(propValue,"center":"top",:"")
	q	
color
	s CssName = "color"
	s CssValue = "#"_propValue
	q	
backgroundColor
	s CssName = "background-color"
	s CssValue = "#"_propValue
	q
textindent
	s CssName = "text-indent"
	q
margin(dir)
	s CssName = "margin-"_dir
	q
bordercolor(dir)
 	s CssName = "border-"_dir_"-color"
 	s CssValue = "#"_propValue
 	q
borderstyle(dir)
	s CssName = "border-"_dir_"-style"
	if (+propValue=0){
		s CssValue = "none"
		}else{
		s CssValue = "solid"	
		}
	q
borderwidth(dir)
	s CssName = "border-"_dir_"-width"
	q
default
	s CssName = propName
	q
empty
	s CssName = ""
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-14
/// Input:      node:标签节点
/// debug 		w ##Class(EMRservice.BLBSParseXML).handleStyle("text-align:left; line-height:1pt;top-color:000000; top-style:0;")
/// Out      	样式字符串
/// Desc		获取每个标签上属性对应的css样式
ClassMethod handleStyle(node As %XML.Node)
{
	s props = node.GetAttributeValue("props")
	s revision = node.GetAttributeValue("revision")
	q:(props=""&&revision="") ""
	s str = ..transplateStyle(props)
	//对留痕节点样式进行处理

	s revisionStyle = ..GetRevisionStyle(revision)
	s str = str_revisionStyle
		
	q str
}

/// Creator:    yn
/// CreateDate: 2022-03-29
/// Input:      处理P标签
/// Out      	无
ClassMethod GetRevisionStyle(str As %String)
{
	q:str="" ""
	s res = ""
	if ('..hiddenRevision(str)){
		s len = $l(str,",")
		s lastChildStr = $p(str,",",len)
		if (lastChildStr["{"){
			s start = $f(lastChildStr,"{")
			s end = $f(lastChildStr,"}")
			s styleProp = $e(lastChildStr,start,end-2)
			s res = ..transplateStyle(styleProp)
		}
	}else{
		s res = "display:none !important;"	
	}
	q res
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理P标签
/// Out      	无
ClassMethod TagP(node As %XML.Node, res As %GlobalBinaryStream)
{
	s style = ..handleStyle(node)
	s tag = "<p style="""_style_"display:block;"">"
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2023-03-30
/// Input:      获取cell的子节点的个数
/// Out      	无
ClassMethod GetElementChildNum(node As %XML.Node)
{
	//保存当前元素位置
	s nodeId = node.NodeId
	s status = node.MoveToParent()
	q:'status 
	s localName = node.LocalName
	if (localName'="cell"){
		d GoToNowNode
		q ""
	}
	s status = node.MoveToFirstChild(1)
	s num = 0
	do{
		s num = num+1
		}while(node.MoveToNextSibling(1))
	//回到当前节点
	s nowId = node.NodeId
	if (nowId'=nodeId){
		s status = node.MoveToParent()
		d GoToNowNode
		}
	q num
GoToNowNode
		s status = node.MoveToFirstChild(1)
		do{
			q:(node.NodeId=nodeId)
		}while(node.MoveToNextSibling(1))
		q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理table标签
/// Out      	无
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetKeyValue("270||8")
ClassMethod TagTable(node As %XML.Node, res As %GlobalBinaryStream)
{
	s style = ..handleStyle(node)
	s tag = "<table style=""width:100%;border-spacing:0px;border-collapse: collapse;"_style_""">"
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理bookmark标签
/// Out      	无
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetKeyValue("270||8")
ClassMethod TagBookmark(node As %XML.Node, res As %GlobalBinaryStream)
{
	s style = ..handleStyle(node)
	s tag = "<span style="""_style_""">"
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理cell标签
/// Out      	无
/// Desc		判断当前节点是否跟他的前后节点在同一行用于写tr
/// Debug:      
ClassMethod TagBeginCell(node As %XML.Node, res As %GlobalBinaryStream, ktb As %String = "")
{
	q:ktb=""
	s props = node.GetAttributeValue("props")
	//td合并样式处理
	s TempArray = ..handleCellStyle(props)
	s rowNum = TempArray.GetAt("trNum")
	s colNum = TempArray.GetAt("colNum")
	
	s colspan = TempArray.GetAt("colspan")
	s rowspan = TempArray.GetAt("rowspan")
	//td线样式处理
	s nowStyle = ..handleStyle(node)
	
	//获取当前节点的哥哥节点
	s hasOldNode = node.MoveToPreviousSibling(1)
	s trStr = ""
	if ('hasOldNode){
		//没有哥哥节点此为第一个孩子节点
		s trStr = "<tr"
	}else{
		s props = node.GetAttributeValue("props")
		s TempArray = ..handleCellStyle(props)
		s oldRowNum = TempArray.GetAt("trNum")
		if (rowNum>oldRowNum){
			s trStr = "<tr"
			}
			//回到当前节点
		s status = node.MoveToNextSibling(1)
	}
	s tdwidth = ""
	s rowHeight = ""
	if (^CacheTableTrWH(ktb)=1){
		s maxNum = $l(^CacheTableTrWH(ktb,"rowHeight"),"/")
		if ((trStr'="")&&(^CacheTableTrWH(ktb,"rowHeight")'="")){
				s:(+rowNum+1<=maxNum) rowHeight = ^CacheTableTrWH(ktb,"rowHeight",rowNum+1)		
			}
		if (^CacheTableTrWH(ktb,"colWidth")'=""){	
			s tdwidth =  ^CacheTableTrWH(ktb,"colWidth",colNum)
			for kk=1:1:(colspan-1){
				s tdwidth = tdwidth+^CacheTableTrWH(ktb,"colWidth",colNum-kk)
				}
			s:(tdwidth'["cm") tdwidth = tdwidth_"cm"
		}
		s borderTop = ^CacheTableTrWH(ktb,"border-top-style")
		s borderBottom = ^CacheTableTrWH(ktb,"border-bottom-style")
		s borderRight = ^CacheTableTrWH(ktb,"border-right-style")
		s borderLeft = ^CacheTableTrWH(ktb,"border-left-style")
		s nowStyle = "border-top-style:"_borderTop_";"
		_"border-bottom-style:"_borderBottom_";"
		_"border-right-style:"_borderRight_";"
		_"border-left-style:"_borderLeft_";"
		_nowStyle
		}
	if (trStr'=""){
		s trStr = trStr_" style=""height:"_rowHeight_";"""
		s trStr = trStr_" >"
		d res.Write(trStr)	
		}
	
	s tag = "<td colspan="_colspan_"  rowspan="_rowspan_" style=""border:1px solid #000;width:"_tdwidth_";border:0.8px solid #000;border-style:solid;"_nowStyle_""">"
	
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理cell标签的样式
/// Out      	返回单元格行列合并信息的键值对
/// Debug:     
ClassMethod handleCellStyle(props As %String) As %ArrayOfDataTypes
{
	s res = ##Class(%ArrayOfDataTypes).%New()
	q:props="" res
	s array = ..GetKeyValue(props)
	//行列合并样式
	s colspan = array.GetAt("right-attach")-array.GetAt("left-attach")
	s rowspan = array.GetAt("bot-attach")-array.GetAt("top-attach")
	d res.SetAt(array.GetAt("top-attach"),"trNum")
	d res.SetAt(colspan,"colspan")
	d res.SetAt(rowspan,"rowspan")
	d res.SetAt(array.GetAt("right-attach"),"colNum")
	
	q res
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理c标签
/// Out      	无
/// Debug:      
ClassMethod TagC(node As %XML.Node, res As %GlobalBinaryStream)
{
	s style = ..handleStyle(node)
	s tag = "<span style="""_style_""">"
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Modify:     2023-01-29
/// Input:      处理field标签,包括动态单元、复选框、单选框等
/// Out      	无
/// Debug:      
ClassMethod TagField(node As %XML.Node, res As %GlobalBinaryStream, ktb As %String = "", scatterArry = "")
{
	q:ktb=""
	s style = ..handleStyle(node)
	s props = node.GetAttributeValue("props")
	s type = node.GetAttributeValue("type")
	s param = node.GetAttributeValue("param")
	if (type["choice"){
		d CheckOrRadio
		}else{	
		d Dynamic	
		}	
	d res.Write(tag)
	q
CheckOrRadio
	s paramArry = ..GetKeyValue(param)
	s ChoiceType = paramArry.GetAt("ChoiceType")
	s isChecked = $case(paramArry.GetAt("Value"),"1":"checked",:"")
	s NodeData = paramArry.GetAt("Context")
	if (ChoiceType="1"){
		//radio
		s tag = "<span style="""_style_"""><input type=""radio"" disabled "_isChecked_"/>"_NodeData
		}else{
		//checkbox
		s tag = "<span style="""_style_"""><input type=""checkbox"" disabled "_isChecked_"/>"_NodeData	
		}
	q
Dynamic
	s array = ..GetKeyValue(props)
	s id = $replace(array.GetAt("code")," ","")	
	s NodeData = ..GetCompositeValueByScatter(id,"", ktb, scatterArry,"field")
	s tag = "<span style="""_style_""">"_NodeData
	q
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理math标签
/// Out      	无
/// Debug:      
ClassMethod TagMath(node As %XML.Node, res As %GlobalBinaryStream)
{
	s style = ..handleStyle(node)
	s tag = "<span style="""_style_""">"
	d res.Write(tag)
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      处理image标签
/// Out      	无
/// Debug:     
ClassMethod TagImage(node As %XML.Node, res As %GlobalBinaryStream, imgData = "")
{
	s props = node.GetAttributeValue("props")
	s dataid = node.GetAttributeValue("dataid")
	s style = ..handleStyle(node)
	s tag = ##Class(%GlobalBinaryStream).%New()
	d tag.Write("<img style=")
	if (dataid'=""&&(imgData'="")){
		s data = imgData.GetAt(dataid)
		d tag.Write(""""_style_"""")
		d tag.Write(" src="""_"data:image/png;base64,")
		if ($isObject(data)){
			d data.Rewind()
			while (data.AtEnd = 0)
			{
				s tmpOut = data.Read(32000)
				d tag.Write(tmpOut)
			}
		}else{
			d tag.Write(data)
		}
		d tag.Write(""" />")
	}

	d tag.Rewind()
	while (tag.AtEnd = 0)
	{
		s tmpOut = tag.Read(32000)
		d res.Write(tmpOut)
	}
}

/// Creator:    yn
/// CreateDate: 2022-09-10
/// Desc:		获取页面纸张大小的全局样式
/// Input:      styleS全局样式流，node:当前指在pagesize
/// Out      	页面纸张大小，高为min-height
/// Debug:      
ClassMethod handlePageSize(styleS As %GlobalBinaryStream, node)
{
  s width = node.GetAttributeValue("width")
  s height = node.GetAttributeValue("height")
  s units = node.GetAttributeValue("units")
  d styleS.Write(".page-size{")
  d styleS.Write("width:"_width_units_";")
  d styleS.Write("min-height:"_height_units_";")
  d styleS.Write("}")
}

}
