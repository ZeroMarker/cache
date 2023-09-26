Class CIS.AN.SRV.AjaxAPI Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean
{
	if ($g(%request.Data("MethodName",1))="GetCAImage")
	{
		Set %response.ContentType = "image/png"
		//Do %response.SetHeader("Content-Disposition","attachment;filename=""test.png""")
		Set %response.NoCharSetConvert=1
		Set %response.Headers("Access-Control-Allow-Origin")="*"
	}
	quit 1
}

ClassMethod DeCodeBase64(base64Stream) As %GlobalCharacterStream
{
	// It is not so simple. Before decoding, you should strip any special characters, like line endings. Then you should read input stream in fixed size devisable by 4, and decode this value.
	// https://community.intersystems.com/post/decode-base64-file
	set stream1=##class(%Stream.GlobalBinary).%New()
	while 'base64Stream.AtEnd {
    set temp=base64Stream.Read()
    set temp=$translate(temp, $c(13,10))

    do stream1.Write(temp)
    }
    set base64Stream=stream1
	Set stream=##class(%GlobalCharacterStream).%New()
	set len=4000
	While ('base64Stream.AtEnd) {
		set base64=base64Stream.Read(.len)
		set bytes=$system.Encryption.Base64Decode(base64)
		do stream.Write(bytes)
    }
    quit stream
}

ClassMethod EnCodeBase64(stream) As %GlobalCharacterStream
{
	Set base64Stream=##class(%GlobalCharacterStream).%New()
	set len=570
	While (stream.AtEnd = 0) {
		set bytes=stream.Read(.len)
		set base64=$system.Encryption.Base64Encode(bytes)
		do base64Stream.Write(base64)
    }
    quit base64Stream
}

ClassMethod OnPage() As %Status
{
	try{
		s clsName=$g(%request.Data("ClassName",1))
		s queryName=$g(%request.Data("QueryName",1))
		s stream=""
		set errorStr=""
		if (queryName=""){
			s methodName=%request.Data("MethodName",1)
			s stream=..RunMethod(clsName,methodName,.errorStr)
		}
		else{
			s queryName=%request.Data("QueryName",1)
			s stream=..RunQuery(clsName,queryName,.errorStr)
		}
		if (errorStr'=""){
			write errorStr,!
		}
	    elseif (..IsClass(stream,"%GlobalCharacterStream")){
		    While (stream.AtEnd = 0) {
		    Set len=1024
		    Write stream.Read(.len)
		  }
	    }
	    else{
		    Write stream
	    }
	}
	catch(e)
	{
		w e.AsSystemError() ,!

	}
	Quit $$$OK
}

ClassMethod GetParams(paramList)
{
	set len=$LISTLENGTH(paramList)
	set excuteStr=""
	for i=1:1:len {
	    set item=$LIST(paramList,i)
	    set name=$LIST(item,1)
	    set type=$LIST(item,2)
	    set param=$g(%request.Data(name,1))
	    s param=$Replace(param,"""","""""")
	    s excuteStr=excuteStr_","""_param_""""
	}
	quit excuteStr
}

ClassMethod RunMethod(className As %String, methodName As %String, errorStr As %String) As %GlobalCharacterStream
{
	set retStr=##class(%GlobalCharacterStream).%New()
    do retStr.Rewind()
    set myobj=##class(%Dictionary.CompiledMethod).%OpenId(className_"||"_methodName,0)
    set paramList=myobj.FormalSpecParsed
	set createInstanceStr="set instance=##class("_className_").%New()"
	set excuteStr="(resultStr)s resultStr=$CLASSMETHOD("""_className_""","""_methodName_""""
	set excuteStr=excuteStr_..GetParams(paramList)
	set excuteStr=excuteStr_")"
	set ^tempDebug("RunMethod")=excuteStr
	try
	{
		XECUTE createInstanceStr,(excuteStr,.resultStr)
		
		s returnType=myobj.ReturnType
		set retStr=resultStr
	}
	catch
	{
		set errorStr=$ZE
	}
	if $TLEVEL>0 TRollback 
	q retStr
}

ClassMethod RunQuery(className, queryName, errorStr) As %GlobalCharacterStream
{
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(className_"||"_queryName,0)
	set paramList=myobj.FormalSpecParsed
	s rset=##class(%ResultSet).%New(className_":"_queryName)
	s excuteStr="(rset)set %sc=$zobjmethod(rset,""Execute"""
	set excuteStr=excuteStr_..GetParams(paramList)
	
    s excuteStr=excuteStr_")"
	s retStr=##class(%GlobalCharacterStream).%New()
    d retStr.Rewind()
	s ret=""
	
	XECUTE (excuteStr,.rset)
	s count=rset.GetColumnCount()
    d retStr.Write("{""rows"":")
    d retStr.Write("[")
    set rowIndex=0
	while (rset.Next()) {
		if rowIndex'=0 d retStr.Write(",")
		d retStr.Write("{")
		f i=1:1:count  d
		.s name=rset.GetColumnName(i)
		.s value=rset.Get(name)
		.i i=1 d retStr.Write(""""_name_""":"""_value_"""")
		.e  d retStr.Write(","""_name_""":"""_value_"""")
		d retStr.Write("}")
		set rowIndex=rowIndex+1
	}
	d retStr.Write("]")
	d retStr.Write(",""total"":"_rowIndex)
	d retStr.Write(",""rowIndex"":"_1)
	d retStr.Write("}")
    q retStr
}

ClassMethod IsClass(obj, className) As %Boolean
{
	if ($isobject(obj)&&((obj.%ClassName()=className)||(obj.%IsA(className))))
	{
		quit $$$OK
	}
	quit 0
}

ClassMethod HISUI()
{
	set hisuiPath="../scripts/hisui/dist/"
	write "<link rel='stylesheet' type='text/css' href='"_hisuiPath_"/css/hisui.css'>"
	write "<script type='text/javascript' src='"_hisuiPath_"/js/jquery-1.11.3.min.js'></script>"
	write "<script type='text/javascript' src='"_hisuiPath_"/js/jquery.hisui.js'></script>",!
	write "<script type='text/javascript' src='../scripts/dhccl.hisui.request.js'></script>",!
	quit 0
}

// 该方法是测试代码，未正式使用

ClassMethod GetCAImage(userId As %String) As %GlobalCharacterStream
{
	// 来自文件
	Set stream=##class(%Stream.FileBinary).%New()
	Set sc=stream.LinkToFile("D:/img.png")
	Set len=1024
	
	set base64Stream=..EnCodeBase64(stream)
	/* 
    // 来至字符串
    set png="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=="
    set b64=$piece(png,"base64,", 2)
    Set base64Stream=##class(%GlobalCharacterStream).%New()
    do base64Stream.Write(b64)
    */
    // 解析并输出
    set stream=..DeCodeBase64(base64Stream)
	//Do stream.OutputToDevice()
	// Set tSC=$$$OK
	quit stream
}

// CIS.AN.SRV.AjaxAPI

/// 如果i为空则返回所有出参信息
/// 获得第i位出参列名
ClassMethod GetColumnPiece(ClassName, QueryName, i = "")
{
	Quit:'##class(websys.Conversions).IsValidClassName(ClassName) "" ;"Not Find Class: "_ClassName
	Quit:'##class(websys.Conversions).IsValidQueryName(ClassName,QueryName) "" ;"Not Find Query: "_ClassName_":"_QueryName
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(ClassName_"||"_QueryName,0)
	set rtn="",ROWSPEC=""
	i $IsObject(myobj){
		s ROWSPEC=myobj.Parameters.GetAt("ROWSPEC")
		d myobj.%Close()
	}else{
		s ROWSPEC=$g(^oddCOM(ClassName,"q",QueryName,"P","ROWSPEC"))
	}
	if ROWSPEC'=""{
		if (i>0){
			Set rtn = $p($p(ROWSPEC,",",i),":",1)
		}else{
			Set rtn = ROWSPEC
		}
	}
	quit rtn
}

/// 考虑列定义,如果query出参定义为HIDDEN时，前端列永远不可见，但数据可见
/// query出参中定义了%Integer/%Float时默认列内容居右
/// 列顺序,宽度,排序,隐藏
ClassMethod ColumnDefJson(cn, qn, ctx = "") [ ProcedureBlock = 1 ]
{
	set ^tempAnDebug("ColumnDefJson")=cn_","_qn_","_ctx
	Quit:(cn="")||(qn="") ""
	Set ROWSPEC = ##class(CIS.AN.SRV.AjaxAPI).GetColumnPiece(cn,qn)
	Quit:ROWSPEC="" ""
	Set t = ""
	s context="K"_cn_":"_qn
	if ctx'="" set context=context_":"_ctx
	set pageSize=15
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")),$g(%session.Data("LOGON.CTLOCID")))
	.s pageSize=$lg(rowsSet,1)
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")),$g(%session.Data("LOGON.CTLOCID")))
	.i activecontext'=context set uSet=""			;查询出的不是放大镜的列布局
	.i uSet=",," Set uSet=""
	.Q:uSet=""
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..i myIdx>0 S uSetArr(myIdx,"w")=$p(uSetItem,",",2), uSetArr(myIdx,"s")=$p(uSetItem,",",3)
	if pageSize="" set pageSize=15
	Set hiddenIndex = "" k ^||JsonArr
	// 当ajax请求时%request.PageName值为websys.Broker.cls/%CSP.Broker.cls...
	// 实际希望是界面csp
	Set OriginPage = $p(%request.CgiEnvs("HTTP_REFERER"),"/",$l(%request.CgiEnvs("HTTP_REFERER"),"/"))
	if (OriginPage["&TMENU="){ //转到菜单对应的csp上. 组件除外 20210825
		Set OriginPageMenuId = $p($P(OriginPage,"&TMENU=",2),"&")
		IF OriginPageMenuId>0,$d(^websys.MenuD(OriginPageMenuId)),$lg(^websys.MenuD(OriginPageMenuId),15)'>0{
			Set OriginPage = $lg(^websys.MenuD(OriginPageMenuId),9)
		}
	}
	If OriginPage["?" Set OriginPage=$P(OriginPage,"?") //只取csp名称
	if ROWSPEC'=""{
		for tmp = 1:1:$l(ROWSPEC,",") {
			set name=$p($p(ROWSPEC,",",tmp),":",1)
			set caption=$p($p(ROWSPEC,",",tmp),":",3)
			set coltype=$p($p(ROWSPEC,",",tmp),":",2)
			set width=$p($p(ROWSPEC,",",tmp),"$",2) ;默认放大镜的宽度
			set caption=$p(caption,"$") ;宽度结构影响 Description:%String:描述^200,
#;			写空翻译且取出翻译结果
			set nameTrans= name
			if ##class(websys.Conversions).IsValidMethodName("websys.Translation","Get"){
				 set nameTrans= ##class(websys.Translation).Get(OriginPage,name)
			}
#;			如果name翻译过,列头走翻译
			if name'=nameTrans Set caption = nameTrans
			if caption="" set caption=name
			If $zcvt(name,"U")="HIDDEN" {  ;2018-2-7 hidden,hidden,hidden转成hidden,hidden1,hidden2 与ext.util.JsonObject中ClassQuery2Json对应
				Set name=name_hiddenIndex
				Set hiddenIndex=hiddenIndex+1
				Set ^||JsonArr(tmp,"hidden")="true"
			}
			Set ^||JsonArr(tmp,"field")=name
			Set ^||JsonArr(tmp,"title")=caption
			if (coltype["Int")||(coltype["Float"){
				Set ^||JsonArr(tmp,"align")="right"
			}
			if width>0 Set ^||JsonArr(tmp,"width")=width
			if $d(uSetArr(tmp)){
				if uSetArr(tmp,"w")>0 Set ^||JsonArr(tmp,"width")=+uSetArr(tmp,"w")
				if uSetArr(tmp,"s")=1 Set ^||JsonArr(tmp,"sortable")="true"
			}
		}
	}
	set myjosnstr="" k ^||JsonSort
#;	先输出顺序
	if uSet'=""{
		for ind=1:1:$l(uSet,"|"){
			Set colInd = $p($p(uSet,"|",ind),",")
			if colInd'="" M ^||JsonSort("cm",ind,colInd) = ^||JsonArr(colInd) K ^||JsonArr(colInd)
		}
	}
#;	再输出其余隐藏的列
	M ^||JsonSort("cm","Hidden")=^||JsonArr
#;  Global输出成Json
	W "{""cm"":["
	Set colCount=0, sortInd="" for {
		Set sortInd = $o(^||JsonSort("cm",sortInd))
		Quit:sortInd=""
		Set colInd="" for {
			Set colInd = $o(^||JsonSort("cm",sortInd,colInd))
			Quit:colInd=""
			W:colCount>0 ","
			W "{"
			if (uSet'="")&&(sortInd="Hidden") Set ^||JsonSort("cm","Hidden",colInd,"hidden")="true"
			Set keyCount=0,key ="" for{
				Set key = $o(^||JsonSort("cm",sortInd,colInd,key))
				Quit:key=""
				w:keyCount>0 ","
				w """"_key_""":"
				if (key="sortable")||(key="width"){ w ^||JsonSort("cm",sortInd,colInd,key)}
				else{w """"_^||JsonSort("cm",sortInd,colInd,key)_""""}
				Set keyCount = keyCount+1
			}
			W "}"
			Set colCount=colCount+1
		}
	}
	w "],""pageSize"":"_pageSize_",""originPage"":"""_$zcvt(OriginPage,"O","JS")_"""}"
	q ""
}

ClassMethod ColumnToJson(cn, qn) [ ProcedureBlock = 1 ]
{
	
	Quit:'##class(websys.Conversions).IsValidClassName(cn) "" ;"Not Find Class: "_ClassName
	Quit:'##class(websys.Conversions).IsValidQueryName(cn,qn) "" ;"Not Find Query: "_ClassName_":"_QueryName
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(cn_"||"_qn,0)
	set rtn="",ROWSPEC=""
	i $IsObject(myobj){
		s ROWSPEC=myobj.Parameters.GetAt("ROWSPEC")
		d myobj.%Close()
	}else{
		s ROWSPEC=$g(^oddCOM(cn,"q",qn,"P","ROWSPEC"))
	}
	Set hiddenIndex = ""
	if ROWSPEC'=""{
		for tmp = 1:1:$l(ROWSPEC,",") {
			set name = $p($p(ROWSPEC,",",tmp),":",1)
			set caption = $p($p(ROWSPEC,",",tmp),":",3)
			if caption = "" set caption=name
			If $zcvt(name,"U")="HIDDEN" { ;2018-2-7 hidden,hidden,hidden转成hidden,hidden1,hidden2 与ext.util.JsonObject中ClassQuery2Json对应
				Set hiddenStr = "hidden:true,"
				Set name=name_hiddenIndex
				Set hiddenIndex=hiddenIndex+1
			}else{
				Set hiddenStr = ""
			}
			set rtn = rtn_$s(rtn="":"",1:",")_"{field:"""_name_""",title:"""_caption_""",align:""left"","_hiddenStr_"width:100}"
		}
	}
	Quit "["_rtn_"]"
}

/// 获得Query的入参
/// Arg1,Arg2,Arg3
ClassMethod GetParamNames(ClassName, QueryName) [ ProcedureBlock = 1 ]
{
	Quit:'##class(websys.Conversions).IsValidClassName(ClassName) "" ;"Not Find Class: "_ClassName
	Quit:'##class(websys.Conversions).IsValidQueryName(ClassName,QueryName) "" ;"Not Find Query: "_ClassName_":"_QueryName
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(ClassName_"||"_QueryName,0)
	set paramsNames = $lts(myobj.ParmNames)
	set myobj=""
	Quit paramsNames
}

/// 获得Query的入参
/// Arg1,Arg2,Arg3
ClassMethod GetFormalSpecParsed(ClassName, QueryName) [ ProcedureBlock = 1 ]
{
	Quit:'##class(websys.Conversions).IsValidClassName(ClassName) "" ;"Not Find Class: "_ClassName
	Quit:'##class(websys.Conversions).IsValidQueryName(ClassName,QueryName) "" ;"Not Find Query: "_ClassName_":"_QueryName
	set myobj=##class(%Dictionary.CompiledQuery).%OpenId(ClassName_"||"_QueryName,0)
	set FormalSpecParsed = myobj.FormalSpecParsed
	set myobj=""
	Quit FormalSpecParsed
}

/// 把Query结果返回成Array
/// 依赖ext.util.JsonObject类
/// 运行的query的入参来自request,
ClassMethod ToArray(ClassName, QueryName, Start = 0, Limit = 50) [ ProcedureBlock = 0 ]
{
	Set paramsNames=""
	set FormalSpecParsed = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	for tempind=1:1:$ll(FormalSpecParsed) {
		Set Spec = $lg(FormalSpecParsed,tempind)
		If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传,走入参默认值
			Set paramName = $lg(Spec,4)
			if paramName="" Set paramName=""""""
		}else{
			Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
		}
		if (tempind=1) Set paramsNames=paramName
		else  Set paramsNames=paramsNames_","_paramName
	}
	set execute = "d ##class(ext.util.JsonObject).ClassQuery2Array("""_ClassName_""","""_QueryName_""","_Start_","_Limit_",.total"
	if paramsNames'="" Set execute=execute_","_paramsNames
	Set execute=execute_")"
	x execute
	quit ""
}

/// var rtn = tkMakeServerCall("CIS.AN.SRV.AjaxAPI","ToExcel","group-("+groupDesc+")-menu","web.Util.Menu","SelectGroupMenu",groupId);
/// location.href = rtn ; 
/// 导出Query的结果成excel,返回Excel文件目录
/// w ##class(CIS.AN.SRV.AjaxAPI).ToExcel("excelname","web.SSUser","Query",p1,p2)
ClassMethod ToExcel(ExcelName, ClassName, QueryName, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
{
	//Set ^Temp("Upgrade","CIS.AN.SRV.AjaxAPI.ToExcel",ClassName,QueryName,"0="_%request.Data("WARGC",1))=p1_","_p2_","_p3_","_p4_","_p5_","_p6
	//New rs,File
	//New pcount Set pcount=$zutil(141)-3
	//Set ^Temp("Upgrade","CIS.AN.SRV.AjaxAPI.ToExcel",ClassName,QueryName,"1="_pcount)=1
	
	// 从websys.Configuration中转入 zutil(141)不准确
	If $d(%request.Data("WARGC",1),ppcount),(ppcount-5)>pcount Set pcount=ppcount
	 
	// 老版的ajax方法会把p1-p16都设置上空,会影响query入参判断, 从query入参校正一下
	Set Spec = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	if pcount>$ll(Spec) set pcount=$ll(Spec) 
	//Set ^Temp("Upgrade","CIS.AN.SRV.AjaxAPI.ToExcel",ClassName,QueryName,"2="_pcount)=Spec
	Set excelDir = "\temp\excel\"
	if ($p(ExcelName,".",$l(ExcelName,"."))="csv") { 	
	}else{
		Set ExcelName = ExcelName_".csv"
	}
	
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	Set File = ##class(%File).%New(PhyDir_ExcelName)
	do File.Open("NWRS")
	Set rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	//Set ^Temp("Upgrade","CIS.AN.SRV.AjaxAPI.ToExcel",ClassName,QueryName,pcount)=execute
	Xecute execute	
	If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
	Set columns=rs.GetColumnCount()
	//d File.WriteLine("") 
	For i=1:1:columns d File.Write(rs.GetColumnHeader(i)_",")
	For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:columns set val=rs.GetData(i) set:val["," val=""""_val_"""" d File.Write(val_",") } else { quit }
	if $$$ISERR(%sc) do $system.OBJ.DisplayError(%sc)
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set rs =""
	Quit "websys.file.utf8.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(ExcelName)_"&dirname="_PhyDir_"&servertype=HTTP"
    	Quit "dhctt.file.csp?act=download&filename="_ExcelName_"&dirname="_PhyDir
}

/// var rtn = tkMakeServerCall("CIS.AN.SRV.AjaxAPI","ToExcel","group-("+groupDesc+")-menu","web.Util.Menu","SelectGroupMenu",groupId);
/// location.href = rtn ; 
/// 导出Query的结果成excel,返回Excel文件目录
ClassMethod ToExcelReq(ExcelName, ClassName, QueryName)
{
	//n (ExcelName,ClassName,QueryName,%request,%session)
	//New rs,File
	//New pcount 
	Set pcount=$zutil(141)-3
	// 老版的ajax方法会把p1-p16都设置上空,会影响query入参判断, 从query入参校正一下
	Set Spec = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	if pcount>$l(Spec,",") set pcount=$l(Spec,",")   
	Set excelDir = "\temp\excel\"
	if ($p(ExcelName,".",$l(ExcelName,"."))="csv") { 	
	}else{
		Set ExcelName = ExcelName_".csv"
	}
	Set paramsNames=""
	set FormalSpecParsed = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	for tempind=1:1:$ll(FormalSpecParsed) {
		Set Spec = $lg(FormalSpecParsed,tempind)
		If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传,走入参默认值
			Set paramName = $lg(Spec,4)
			if paramName="" Set paramName=""""""
		}else{
			Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
		}
		if (tempind=1) Set paramsNames=paramName
		else  Set paramsNames=paramsNames_","_paramName
	}
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	Set File = ##class(%File).%New(PhyDir_ExcelName)
	do File.Open("NWRS")
	Set rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	;For i=1:1:pcount Set execute=execute_",.p"_i
	if paramsNames'="" Set execute=execute_","_paramsNames
	Set execute=execute_")"
	Xecute execute	
	If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
	Set columns=rs.GetColumnCount()
	d File.WriteLine("") 
	For i=1:1:columns d File.Write(rs.GetColumnHeader(i)_",")
	For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:columns set val=rs.GetData(i) set:val["," val=""""_val_"""" d File.Write(val_",") } else { quit }
	if $$$ISERR(%sc) do $system.OBJ.DisplayError(%sc)
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set rs =""
    Quit "websys.file.utf8.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(ExcelName)_"&dirname="_PhyDir_"&servertype=HTTP"
}

/// 调用c类m方法,m的入参通过%request.Data来配置
ClassMethod X(c, m)
{
	//n (c,m,%request,%session)
	Set paramsNames=""
	set FormalSpecParsed = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(c,m)
	for tempind=1:1:$ll(FormalSpecParsed) {
		Set Spec = $lg(FormalSpecParsed,tempind)
		If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传,走入参默认值
			Set paramName = $lg(Spec,4)
			if paramName="" Set paramName=""""""
		}else{
			Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
		}
		if (tempind=1) Set paramsNames=paramName
		else  Set paramsNames=paramsNames_","_paramName
	}
	set execute = "d ##class("_c_")."_m_"("
	if paramsNames'="" Set execute=execute_","_paramsNames
	Set execute=execute_")"
	x execute
	quit ""
}

/// 把Query结果返回成json
/// 依赖ext.util.JsonObject类
/// 运行的query的入参来自request,
ClassMethod ToJson(ClassName, QueryName, Start = 0, Limit = 50) [ ProcedureBlock = 0 ]
{
	Set paramsNames=""
	;set paramsNames = ##class(CIS.AN.SRV.AjaxAPI).GetParamNames(ClassName,QueryName)
	set FormalSpecParsed = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	;set paramsNames = "$g(%request.Data("""_$Replace(paramsNames, ",", """,1)),$g(%request.Data(""")_""",1))"
	;dubug %request-->""
	for tempind=1:1:$ll(FormalSpecParsed) {
		Set Spec = $lg(FormalSpecParsed,tempind)
		If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传,走入参默认值
			Set paramName = $lg(Spec,4)
			if paramName="" Set paramName=""""""
		}else{
			Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
		}
		if (tempind=1) Set paramsNames=paramName
		else  Set paramsNames=paramsNames_","_paramName
	}
	;set paramsNames = "$g(%request.Data("""_$Replace($lts(myobj.ParmNames), ",", """,1),""""),$g(%request.Data(""")_""",1),"""")"
	set execute = "d ##class(ext.util.JsonObject).ClassQuery2Json("""_ClassName_""","""_QueryName_""","_Start_","_Limit_",.total"
	if paramsNames'="" Set execute=execute_","_paramsNames
	Set execute=execute_")"
	set ^Temp("CIS.AN.SRV.AjaxAPI","ToJson",$i(^Temp("CIS.AN.SRV.AjaxAPI","ToJson"))) = execute
	x execute
	quit ""
}

ClassMethod GetJson(ClassName, QueryName, Start = 0, Limit = 50, ByRef total) [ ProcedureBlock = 0 ]
{
	Set paramsNames=""
	;set paramsNames = ##class(CIS.AN.SRV.AjaxAPI).GetParamNames(ClassName,QueryName)
	set FormalSpecParsed = ##class(CIS.AN.SRV.AjaxAPI).GetFormalSpecParsed(ClassName,QueryName)
	;set paramsNames = "$g(%request.Data("""_$Replace(paramsNames, ",", """,1)),$g(%request.Data(""")_""",1))"
	for tempind=1:1:$ll(FormalSpecParsed) {
		Set Spec = $lg(FormalSpecParsed,tempind)
		If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传,走入参默认值
			Set paramName = $lg(Spec,4) 
			if paramName="" Set paramName=""""""
		}else{
			Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
		}
		if (tempind=1) Set paramsNames=paramName
		else  Set paramsNames=paramsNames_","_paramName
	}
	;set paramsNames = "$g(%request.Data("""_$Replace($lts(myobj.ParmNames), ",", """,1),""""),$g(%request.Data(""")_""",1),"""")"
	set execute = "Set Json=##class(ext.util.JsonObject).ClassQuery2JsonQ("""_ClassName_""","""_QueryName_""","_Start_","_Limit_",.total"
	if paramsNames'="" Set execute=execute_","_paramsNames
	Set execute=execute_")"
	;set ^Temp("CIS.AN.SRV.AjaxAPI","GetJson",$i(^Temp("CIS.AN.SRV.AjaxAPI","GetJson"))) = execute
	x execute
	quit Json
}

ClassMethod Close(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
		$$$GENERATE(" Set repid=$LIST(qHandle,2)")
 		$$$GENERATE(" Kill ^CacheTemp(repid)")
 		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

ClassMethod Execute(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, ProcedureBlock = 1, ServerOnly = 1 ]
{
		s %code=0
		#; don't generate any code if it not for a query
		i %mode="method" QUIT $$$OK
		#; %mode is "propertymethod" for a valid query. We don't have any way currently to detect a misuse of a query class
		if '$$$comMemberDefined(%class,$$$cCLASSquery,%property) QUIT $$$OK
		#; Reset the formal list to the query declaration:
		#; write inputArgs
		$$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
		$$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
		$$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
		s sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) q:$$$ISERR(sc) sc

		#; Initialize qHandle...
		$$$GENERATE(" Set repid=$I(^CacheTemp)")
		$$$GENERATE(" If $g(ind)="""" Set ind=1")
		#; copy code to Excute
		$$$comMemberKeyGetLvar(query,%class,$$$cCLASSquery,%property,$$$cQUERYsqlquery)
		s qline=0
		f i=1:1:$l(query,$$$NL) s line=$p(query,$$$NL,i) i line'="" s qline=qline+1,qline(qline)=line
		f i=1:1:qline-1 $$$GENERATE($Char(9,9)_qline(i))
		i qline {
			$$$GENERATE($Char(9,9)_qline(qline))
		}
		$$$GENERATE(" Set qHandle=$lb(0,repid,0)")
		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

ClassMethod Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
		$$$GENERATE(" Set AtEnd=$LIST(qHandle,1)")
		$$$GENERATE(" Set repid=$LIST(qHandle,2)")
		$$$GENERATE(" Set ind=$LIST(qHandle,3)")
		$$$GENERATE(" Set ind=$o(^CacheTemp(repid,ind))")
		$$$GENERATE(" If ind="""" { // if there are no more rows, finish fetching")
		$$$GENERATE(" Set AtEnd=1")
		$$$GENERATE(" Set Row=""""")
		$$$GENERATE(" }Else{ // fetch row")
		$$$GENERATE(" Set Row=^CacheTemp(repid,ind)")
		$$$GENERATE(" }")
		$$$GENERATE(" s qHandle=$lb(AtEnd,repid,ind)")
		$$$GENERATE(" QUIT $$$OK")
		QUIT $$$OK
}

}
