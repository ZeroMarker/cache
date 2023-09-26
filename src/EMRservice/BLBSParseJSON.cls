Class EMRservice.BLBSParseJSON Extends %RegisteredObject
{

/// 绝对单位(默认厘米cm)与像素px互换单位常量
Parameter DPI = 96;

/// 设置默认行高
Parameter LineHeight = 1.7;

/// Desc:       测试本地JSON数据展现
/// Creator:    yn
/// CreateDate: 2023-02-03
/// Input:      空
/// Output：    JSON流
/// Debug:      w ##Class(EMRservice.BLBSParseJSON).TestJSON()
ClassMethod TestJSON() As %GlobalBinaryStream
{
	s res = ##class(%GlobalBinaryStream).%New()
	s argOutData =##class(%FileBinaryStream).%New()
	s argOutData.Filename = "d:\emrparse\emr4\"_"emr"_".json"
	q:argOutData.FileBinarySize()=0 res 
	s res = ..GetEMRHtmlData(argOutData)
	q res
}

/// Desc:       将病历JSON转换成html入口方法
/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      病历json数据
/// Debug:      w ##Class(EMRservice.BLBSParseJSON).GetEMRHtmlData("19||1","test").Read()
ClassMethod GetEMRHtmlData(AJson As %GlobalBinaryStream, htmlResArry = "") As %GlobalBinaryStream
{
	s res = ##class(%GlobalBinaryStream).%New() 
	
	s $zt = "GetEMRHtmlDataError"
	s jsonObj = ##class(%DynamicAbstractObject).%FromJSON(AJson)
	s res = ..handleJSONData(jsonObj,htmlResArry)
	q res
GetEMRHtmlDataError
	d:htmlResArry'="" htmlResArry.SetAt("-1^json解析异常"_$zerror,"resDesc")
	s res = ##class(%GlobalBinaryStream).%New() 
	q res
}

/// Desc:       将json数据解析成html：处理过程
/// Creator:    yn
/// CreateDate: 2023-02-03
/// Input:      json对象
/// Output: 	html二进制流  
ClassMethod handleJSONData(AJsonObj, htmlResArry = "") As %GlobalBinaryStream
{
	s res = ##Class(%GlobalBinaryStream).%New()
	s htmlArry = ##Class(%Library.ArrayOfDataTypes).%New()
	s styleS = ##Class(%GlobalBinaryStream).%New()
	d ..initStyle(styleS)
	d htmlArry.SetAt(styleS,"styleS")
	s iter  = AJsonObj.%GetIterator()
 	while iter.%GetNext(.key , .value ) {
	       d $case(key
	       ,"headFoot":..PropHeadFoot(value,htmlArry)
	       ,"paper":..PropPager(value,htmlArry)
	       ,"value":..PropArticle(value,htmlArry)
	       ,"title":..PropTitle(value,htmlArry)
	       ,"font":..PropFont(value,htmlArry)
	       )
	   }
	
	d ..concatHtml(res,htmlArry)	
	q res
}

/// Desc:       全局样式定义
/// Creator:    yn
/// CreateDate: 2023-02-03
/// Input:      json对象
/// Output: 	html二进制流  
ClassMethod initStyle(styles)
{
	s pageStyle = ".page-style{margin: 0 auto;border: 1px #D3D3D3 solid;border-radius: 5px;background: white;box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);margin-bottom: 5px;}"
	s pagetable = ".page-table{border-collapse:collapse;table-layout:fixed;}  table tr td{border:1px solid #000;}  .content table tr td>div{height:23.8px;}"
	s pageContent = ".content{width:100%;height:100%;position:relative;}"

	d styles.Write(pageContent)
	d styles.Write(pagetable)
	d styles.Write(pageStyle)
}

/// Desc:       将一个流拷贝到另一个流中，并进行转码
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      stream
/// Output: 	stream
ClassMethod appendCodyStream(newStream, oldStream)
{
	q:(oldStream="") 
	d oldStream.Rewind()
	while (oldStream.AtEnd = 0)
	{
		s tmpOut = oldStream.Read(32000)
		d newStream.Write(tmpOut)
	}
}

ClassMethod concatHtml(htmlS, htmlArry) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()	
	s styleS = htmlArry.GetAt("styleS")
	s styleStr = ""
	d styleS.Rewind()
	while (styleS.AtEnd = 0)
	{
		s tmpOut = styleS.Read(32000)
		s styleStr = styleStr_$zcvt(tmpOut,"I","UTF8")
	}
	s styleHtml = "<style>"_styleStr_"</style>"
	s head = "<head><meta charset=""utf-8"" /><title>电子病历(四版)</title>"_styleHtml_"</head>"
	s bodyStr = ""
	s bodyS = ##Class(%GlobalBinaryStream).%New()
	d bodyS.Write("<div class=""page-size page-style"">")
	d bodyS.Write("<div class=""page-header"">")
	d ..appendCodyStream(bodyS,htmlArry.GetAt("header"))
	d bodyS.Write("</div>")
	d bodyS.Write("<div data-type=""content"" class=""content"">")
	d ..appendCodyStream(bodyS,htmlArry.GetAt("title"))
	d ..appendCodyStream(bodyS,htmlArry.GetAt("article"))
	d bodyS.Write("</div>")
#;	d ..appendCodyStream(bodyS,htmlArry.GetAt("footer"))
	d bodyS.Write("</div>")
	d bodyS.Rewind()
	while (bodyS.AtEnd = 0)
	{
		s bodyStr = bodyStr_bodyS.Read(32000)
	}
	s bodyHtml = "<body>"_bodyStr_"</body>"
	d htmlS.Write("<!DOCTYPE html><html>")
	d htmlS.Write(head)
	d htmlS.Write(bodyHtml)
	d htmlS.Write("</html>")
}

/// Desc:       处理页眉页脚
/// Creator:    yn
/// CreateDate: 2023-02-06
/// Input:      json对象
/// Output: 	html二进制流 
ClassMethod PropHeadFoot(jsonObj, htmlArry)
{
	//对对象进行递归遍历
   set iter = jsonObj.%GetIterator()
   while iter.%GetNext(.key , .value ) {
	  //d:(key="first") htmlArry.SetAt(value,key)
	  //d:(key="evenOdd") htmlArry.SetAt(value,key)
	  //if (key="dividerHeader"){}
	  //if (key="dividerFooter"){}
	  d:(key="header") HeaderProp
   }
   q
HeaderProp
	q:jsonObj.%GetTypeOf(key)'="array" 
	//对header进行遍历
	s headerArry = value
	//对最小结构进行递归处理
	s headerStr = ##Class(%GlobalBinaryStream).%New()
	d ..doMinStruct(headerArry,headerStr)
	d htmlArry.SetAt(headerStr,"header")
	q
}

/// Desc:       处理页面大小及样式
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      jsonObj:json对象（pager部分）、htmlArry:包含各个部分的数组
/// Output: 	none
ClassMethod PropPager(jsonObj, htmlArry)
{
	s paperType = jsonObj.%Get("paperType")
	s width = ..GetPx(jsonObj.%Get("width"))
	s height =..GetPx( jsonObj.%Get("height"))
	s top = ..GetPx(jsonObj.%Get("top")) 
	s right = ..GetPx(jsonObj.%Get("right"))
	s bottom = ..GetPx(jsonObj.%Get("bottom"))
	s left = ..GetPx(jsonObj.%Get("left"))
	s styleS = htmlArry.GetAt("styleS")
	s pageSize = ".page-size{"
	s pageSize = pageSize_"width:"_width_";"
	//s pageSize = pageSize_"height:"_height_";"
	s pageSize = pageSize_"padding-top:"_top_";"
	s pageSize = pageSize_"padding-right:"_right_";"
	s pageSize = pageSize_"padding-left:"_left_";"
	s pageSize = pageSize_"padding-bottom:"_bottom_";"
	s pageSize = pageSize_"box-sizing:border-box;"
	s pageSize = pageSize_"line-height:"_..#LineHeight_";"
	s pageSize = pageSize_"}"
	
	
	d styleS.Write(pageSize)

	q
}

ClassMethod PropArticle(jsonObj, htmlArry)
{
	s type = jsonObj.%Get("type")
	q:type'="article"
	//对正文部分进行递归遍历
	s children = jsonObj.%Get("children")
	s articleStr = ##Class(%GlobalBinaryStream).%New()
	d ..doMinStruct(children,articleStr)
	d htmlArry.SetAt(articleStr,"article")
}

ClassMethod PropTitle(jsonObj, htmlArry)
{
	s nameSpan = "",timeSpan = ""
	s showTitle = jsonObj.%Get("showTitle")
	if (showTitle=1){
		//处理title名
		s name = jsonObj.%Get("name")
		s nameStyle = "",nameText = ""
		s nameIter = name.%GetIterator()
		while nameIter.%GetNext(.key,.value){
			s nameStyle = ..GetTagStyle(nameStyle,key,value)
			}
		s nameText = name.%Get("doctorLevel")_name.%Get("doctor")_name.%Get("value")
		//根据textAlign的值判断name跟time的位置
		s siteStyle = "float:"_name.%Get("textAlign")_";"
		s nameSpan = "<span class=""page-font"" style="""_siteStyle_nameStyle_""">"_nameText_"</span>"
	}
	s showDate = jsonObj.%Get("showDate")
	if (showDate=1){
		//处理日期时间
		s time = jsonObj.%Get("time")
		s timeIter = time.%GetIterator()
		s timeStyle = "",timeText = ""
		while timeIter.%GetNext(.key,.value){
			s timeStyle = ..GetTagStyle(timeStyle,key,value)
			}
		s timeStamp = time.%Get("value")
		s format = time.%Get("format")
		s timeText = ..GetTimeFormat(timeStamp, format)
		//位置
		s siteStyle = "float:"_time.%Get("textAlign")_";"
		s timeSpan = "<span class=""page-font"" style="""_siteStyle_timeStyle_""">"_timeText_"</span>"
	}
	if ('((showTitle'=1)&&(showDate'=1))){
		s title = ##Class(%GlobalBinaryStream).%New()
		d title.Write("<div data-type=""section"" style=""overflow:hidden;"">")
		d title.Write(timeSpan)
		d title.Write(nameSpan)
		d title.Write("</div>")
		d htmlArry.SetAt(title,"title")
		}	
	q
}

ClassMethod PropFont(jsonObj, htmlArry)
{
	q:jsonObj.%Size()=0 
	s pageFont = ".page-font{"
	s pageFont = pageFont_"font-family:"_jsonObj.%Get("fontFamily")_";"
	s pageFont = pageFont_"font-size:"_jsonObj.%Get("fontSize")_"pt;" 
	s pageFont = pageFont_"color:"_jsonObj.%Get("color")_";" 
	s pageFont = pageFont_"}"
	s styleS = htmlArry.GetAt("styleS")
	d styleS.Write(pageFont)
	q
}

/// Desc:       将日期时间转换成需要的格式
/// Creator:    yn
/// CreateDate: 2023-02-08
/// Input:      jsonObj:json对象（pager部分）、htmlArry:包含各个部分的数组
/// Output: 	none
/// Debug:      w ##Class(EMRservice.BLBSParseJSON).GetTimeFormat(1675232038643,"YYYY-MM-DD HH:mm")
ClassMethod GetTimeFormat(timeStamp, format)
{
	s result = format
	s dateTime = ..TimestampToDateTime(timeStamp,"ms")
	s dateStr = $p(dateTime,",",1)
	s timeStr = $p(dateTime,",",2)
	s len = $l(format," ")
	for i=1:1:len{
		s resItem = ""
		s item = $p(format," ",i)
		s:(item="YYYY-MM-DD") resItem = $zd(dateStr,3)
		s:(item="HH:mm") resItem = $zt(timeStr,2)

		s result = $replace(result,item,resItem)
		}
	q result
}

/// Desc:       将时间戳转换成时间
/// Creator:    yn
/// CreateDate: 2023-02-08
/// Input:      jsonObj:json对象（pager部分）、htmlArry:包含各个部分的数组
/// Output: 	none
/// Debug:      w ##Class(EMRservice.BLBSParseJSON).TimestampToDateTime(1675232038643,"ms")
ClassMethod TimestampToDateTime(ATimestamp, AType As %String = "") As %String
{
	s timestamp = $g(ATimestamp)
	q:(timestamp = "") ""
	s:(AType = "ms") timestamp = timestamp \ 1000
	s datetime = timestamp + 4070937600
	s time = datetime # 86400
	s date = (datetime - time) / 86400
	s toDateTime = date _ "," _ time
	q toDateTime
}

/// Desc:       将绝对单位转换为px
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      cmStr:cm长度
/// Output: 	px长度值
ClassMethod GetPx(cmStr)
{
	s res = ""
	q:cmStr="" res
	s dpi = ..#DPI
	s in = 2.54
    s res = (+cmStr)/in*dpi
	q res_"px"
}

/// Desc:       处理array输出string
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      array
/// Output: 	string
ClassMethod ArrayToString(obj)
{
	s count = obj.Count()
	s str = ""
	for i=1:1:count{
		s str = str_" "_obj.GetNext(i)
		}
	w !,"array:"
	w str
	w !,";"
}

/// Desc:       处理值的最小结构，json的嵌套即为html的嵌套关系
/// Creator:    yn
/// CreateDate: 2023-02-06
/// Input:      json对象
/// Output: 	html二进制流 
ClassMethod doMinStruct(obj, htmlStr, parentProp = "")
{
	s size = obj.%Size()
	for i=0:1:(size-1){
		s item = obj.%Get(i)
		d ..GetTagStart(item,htmlStr,parentProp)
		if (item.%Get("children")'=""){
			if (item.%Get("sectionName")="true"){
				s htmlStr = ..doMinStruct(item.%Get("children"),htmlStr,":")
				}else{
				s htmlStr = ..doMinStruct(item.%Get("children"),htmlStr)	
				}
			}
		d ..GetTagEnd(item,htmlStr)
		}	
	q htmlStr
}

ClassMethod GetTagStart(item, htmlStr, parent = "")
{
    set iter = item.%GetIterator()
    s style = "",text = "",prop = "",child = ""
	while iter.%GetNext(.key,.value ) {
		if (key="text"){
			d GetText
		}else{
			s style = ..GetTagStyle(style,key,value)
			s prop = ..GetTagProp(prop,key,value)
		}	      
	}
	d ..GetTagName(item,style,prop,text, htmlStr)
	q
GetText
	s text = value
	//获取标签内文本值
	if ((parent'="")&&(value'="")){
		s text=value_parent //章节拼上 ":"
	}
	s textType = item.%Get("textType")
	if (item.%Get("textType")'=""){
		//月经生育史分式处理
		s:textType="numerator" text = "<span style=""display:block;border-bottom:1px solid #000;"">"_value_"</span>"
		s:textType="denominator" text = "<span style=""display:block;"">"_value_"</span>"
	}
	if ((item.%Get("doubleline")="true")||(item.%Get("doubleline")=1)){
		s text = value_"<div style=""position:absolute;top:4.2px;right:0;left:0;height:4px;border-top:1px solid #333;border-bottom:1px solid #333;""></div>"
		}
	if (item.%Get("sup")=1){
		s text = "<sup>"_value_"</sup>"
		}
	if (item.%Get("sub")=1){
		s text = "<sub>"_value_"</sub>"
		}
	q
}

ClassMethod GetTagProp(prop, key, value)
{
	s newProp = $case(key
		,"rowSpan":"rowspan="""_value_""" "
		,"colSpan":"colSpan="""_value_""" "
		,:"")
	s prop = prop_newProp
	q prop
}

ClassMethod GetTagStyle(style, key, value)
{
	s newStyle = $case(key
		,"textAlign":$case(value,"dispersed":"text-align:justify;text-align-last:justify;",:"text-align:"_value_";")
		,"lineHeight":"line-height:"_((+value)*(..#LineHeight))_";"
		,"hide":$case(value,"true":"display:none;",1:"display:none;",:"")
		,"bold":$case(value,1:"font-weight:bold;",:"")
		,"marginLeft":"margin-left:"_value_"px;"
		,"colgroup":..GetTableWidth(value)
		,"fontFamily":"font-family:"_value_";"
		,"italic":"font-style:italic;"
		,"underline":"text-decoration-line:underline;"
		,"strikethrough":$case(value,"true":"text-decoration-line:line-through;",1:"text-decoration-line:line-through;",:"")
		,"doubleline":$case(value,"true":"position:relative;",1:"position:relative;",:"")
		,"fontSize":"font-size:"_value_"pt;"
		,"delBorder":..GetTdBorder(value)
		,"color":"color:"_value_";"
		,"textBgColor":"background-color:"_value_";"
		,"attrs":..GetTagAttrs(value)
		,:"")
	s style = style_newStyle
	q style
}

ClassMethod GetTableWidth(obj)
{
	s width = 0
	s iter = obj.%GetIterator()
	while iter.%GetNext(.key,.value){
		s width = width+value
		}
	q:width="" ""
	q "width:"_width_"px;"
}

/// Desc:       处理table的td的边框样式，默认td的样式为全画
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      td的边框对象
/// Output: 	string
ClassMethod GetTdBorder(obj)
{
   s str = ""
   q:(obj.%Size()=0) str
   set iter = obj.%GetIterator()
   while iter.%GetNext(.key , .value ) {
      s:value="top" str = str_"border-top:none;"
      s:value="bottom" str = str_"border-bottom:none;"
      s:value="left" str = str_"border-left:none;"
      s:value="right" str = str_"border-right:none;"
   }
   q str
}

/// Desc:       处理结构化元素的样式,处理了部分属性
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      结构化元素attrs对象
/// Output: 	string
ClassMethod GetTagAttrs(obj)
{
   s str = ""
   q:(obj.%Size()=0) str
   set iter = obj.%GetIterator()
   while iter.%GetNext(.key , .value ) {
      s:key="backgroundColor" str = str_"background-color:"_value_";"
      s:key="fontFamily" str = str_"font-family:"_value_";"
      s:key="color" str = str_"color:"_value_";"
      s:key="fontSize" str = str_"font-size:"_value_";"
      s:key="bold" str = str_"font-weight:"_$case(value,"true":"blod",:"normal")_";"
      s:key="italic" str = str_"font-style:"_$case(value,"true":"italic",:"normal")_";"
      s:key="underline" str = str_"text-decoration:"_$case(value,"true":"underline",:"normal")_";"
      s:key="strikethrough" str = str_"text-decoration:"_$case(value,"true":"line-through",:"normal")_";"
      s:key="doubleline" str = str_"border-bottom:"_$case(value,"true":"double",:"none")_";"
   }
   q str
}

/// Desc:       根据key值获取标签元素名称并拼接属性和样式
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      item:json对象、style:样式、prop:属性、text:标签内文本、htmlStr:流
/// Output: 	none
ClassMethod GetTagName(item, style, prop, text, htmlStr)
{
	s tagType = item.%Get("type")
	//获取标签名
	d $case(tagType
	,"header":htmlStr.Write("<div data-type=""header"" style="""_style_""" "_prop_">")
	,"paragraph":htmlStr.Write("<div data-type=""paragraph"" style="""_style_""" "_prop_">")
	,"section":htmlStr.Write("<div data-type=""section"" style="""_style_""" "_prop_">")
	,"string":htmlStr.Write("<div data-type=""string"" style="""_style_"display:inline-block;"" "_prop_">")
	,"fraction": htmlStr.Write("<span style=""display:inline-block;line-height:1;text-align:center;vertical-align:middle;"">") //月经史生成
	,"radio":WriteRadioCheckBox("radio")
	,"checkbox":WriteRadioCheckBox("checkbox")
	,"logo":WriteImage
	,"image":WriteImage
	,"table":WriteTable
	,"tr":htmlStr.Write("<tr "_prop_">")
	,"td":htmlStr.Write("<td style="""_style_""" "_prop_">")
	,"line":htmlStr.Write("<div data-type=""line"" style="""_style_""" "_prop_">")
	,:htmlStr.Write("<span class=""page-font"" style="""_style_""" "_prop_">"_text)
	)
	q
WriteImage
	s sizeObj = "",imgW=""
	s:item.%Get("size")'="" sizeObj=item.%Get("size")
	s:item.%Get("currentSize")'="" sizeObj = item.%Get("currentSize")
	s:item.%Get("moveSize")'="" sizeObj = item.%Get("moveSize")
	s:sizeObj'="" imgW = sizeObj.%Get("width")
	d htmlStr.Write("<img src="""_item.%Get("url")_""" style=""width:"_imgW_"px;"">")
	q
WriteRadioCheckBox(inputType)
	s attrs = item.%Get("attrs")
	s value = attrs.%Get("value")
	s checked = attrs.%Get("checked")
	s checkedArry = ..GetCheckItem(checked)
	s isChecked = ""
	s:(checkedArry.GetAt(value)="1") isChecked = "checked"
	d htmlStr.Write("<input type="""_inputType_""" "_isChecked_" disabled>")
	q
WriteTable 
	d htmlStr.Write("<table class=""page-table"" style="""_style_""" "_prop_">")
	if (item.%GetTypeOf("colgroup")'="unassigned"){
		//处理table的子元素
		s iter = item.%Get("colgroup").%GetIterator()
		d htmlStr.Write("<colgroup>")
		while iter.%GetNext(.key,.value){
			d htmlStr.Write("<col width="""_value_""">")
			}
		d htmlStr.Write("</colgroup>")
		}
	q
}

/// Desc:       获取单选、复选框选中的值
/// Creator:    yn
/// CreateDate: 2023-02-09
/// Input:      item:json对象
/// Output: 	被选中的id的array
ClassMethod GetCheckItem(obj) As %ArrayOfDataTypes
{
	s res = ##Class(%ArrayOfDataTypes).%New()
	s total = obj.%Size()
	for i=0:1:(total-1){
		s item = obj.%Get(i)
		s value = item.%Get("value")
		d:value'="" res.SetAt("1",value)
		}
	q res
}

/// Desc:       根据key值获取结束标签
/// Creator:    yn
/// CreateDate: 2023-02-07
/// Input:      item:json对象、htmlStr:流
/// Output: 	none
ClassMethod GetTagEnd(item, htmlStr)
{
	s tagType = item.%Get("type")
	//获取标签名
	d $case(tagType
	,"header":htmlStr.Write("</div>")
	,"paragraph":htmlStr.Write("</div>")
	,"section":htmlStr.Write("</div>")
	,"string":htmlStr.Write("</div>")
	,"fraction":htmlStr.Write("</span>")
	,"table":htmlStr.Write("</table>")
	,"line":htmlStr.Write("</div>")
	,:htmlStr.Write("</span>")
	)
	q
}

}
