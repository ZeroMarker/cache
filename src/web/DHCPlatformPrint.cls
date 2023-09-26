Include webgen

/// @date : 2013-03-20
/// @author : wanghc
/// @desc: 解析xml打印模板成M
Class web.DHCPlatformPrint Extends %RegisteredObject [ LegacyInstanceContext, Not ProcedureBlock ]
{

Parameter QUALIFIERS = "/displaylog=0";

/// name $c(2) wanghc^no $c(2) 1234
Parameter ITEMCHAR = "^";

Parameter VALCHAR = "$c(2)";

Parameter PT2PX = 3.78;

Property Data As %String [ InitialExpression = 0, MultiDimensional ];

Property XMLName As %String;

/*
<?xml version="1.0" encoding="gb2312" ?>
<appsetting>
	<invoice height="13.89" width="20.9" PrtPaperSet="WIN" PrtDevice="REG" PrtPage="" > 
		<TxtData RePrtHeadFlag="N">
			<txtdatapara name = "note1" xcol = "1.058" yrow = "1.058" fontsize = "9" fontbold = "true" fontname = "黑体" defaultvalue = "" printvalue = ""  ></txtdatapara>
			<txtdatapara name = "HospName" xcol = "21.958" yrow = "5.026" fontsize = "12" fontbold = "true" fontname = "宋体" defaultvalue = "北京地坛医院" printvalue = ""  ></txtdatapara>
		</TxtData>
		<ListData PrintType="List"  YStep="2.91" XStep="0" CurrentRow="0" PageRows="50" RePrtHeadFlag="Y" >
			<Listdatapara name="DrugName" xcol="2.116" yrow="66.931" fontsize = "8" fontbold = "false" fontname = "宋体"  printvalue="" defaultvalue = ""  ></Listdatapara>
			<Listdatapara name="Price" xcol="43.122" yrow="66.931" fontsize = "8" fontbold = "false" fontname = "宋体"  printvalue="" defaultvalue = ""  ></Listdatapara>
		</ListData> 
		<PLDataTest desc="下面的划线为例子Copy到PLData中">
			<PLine BeginX="10" BeginY="6" EndX="10" EndY="26"></PLine>
			<PLine BeginX="10" BeginY="26" EndX="30" EndY="26"></PLine>
			<PLine BeginX="30" BeginY="26" EndX="30" EndY="6"></PLine>
			<PLine BeginX="30" BeginY="6" EndX="10" EndY="6"></PLine>
			<PLine BeginX="10" BeginY="6" EndX="30" EndY="26"></PLine>
			<PLine BeginX="10" BeginY="26" EndX="30" EndY="6"></PLine>
		</PLDataTest>
		<PICData RePrtHeadFlag="N">
			<PICdatapara name="img0" xcol="65.079" yrow="39.683" height="34.392" width="34.392" defaultvalue="http://127.0.0.1/dthealth/web/scripts/xmldesigner/img/defaultimg.jpg" printvalue="" />
			<PICdatapara name="img1" xcol="13.492" yrow="39.418" height="34.392" width="34.392" defaultvalue="C:\imedical\xmlprint\cache\3.gif" printvalue="" />
		</PICData>
		<PLData RePrtHeadFlag="N">
			<PLine BeginX="9.524" BeginY="32.275" EndX="135.979" EndY="32.275" />
			<PLine BeginX="10.053" BeginY="21.693" EndX="9.788" EndY="32.275" />
			<PLine BeginX="10.053" BeginY="21.693" EndX="135.185" EndY="21.693" />
			<PLine BeginX="135.45" BeginY="21.429" EndX="135.45" EndY="32.011" />
		</PLData>
	</invoice>
</appsetting>
*/
ClassMethod ExportXml()
{
	Set dataObj = ##class(web.print.DHCTxtData).%New()
	Set dataObj.RePrtHeadFlag = "Y"
	Set obj = ##class(web.print.DHCTxtDataPara).%New()
	Set obj.name="wanghc1"
	Do dataObj.txtdatapara.Insert(obj)
	Do dataObj.XMLExportToString(.xml)
	Do obj.%Close()
	set obj=""
	Do dataObj.%Close()
	set dataObj=""
	q xml
}

ClassMethod Enter()
{
	d routine.WriteLine(" w !")
}

ClassMethod RWL(mRoutine)
{
 	d routine.WriteLine(mRoutine)
}

ClassMethod RWLHTML(mHtml)
{
	d routine.Write(" w """)
	d routine.Write($replace(mHtml,"""",""""""))
	d routine.WriteLine("""")
}

/// d Show^DTGCOMXML2("patname^wanghc"_$c(1)_"medcare^0001"_$c(1)_"inadmdate^20140109"_$c(1)_"outadmdate^2014-9-9"_$c(1)_"username^师爷"_$c(1)_"Date^09"_$c(1)_"time^10:00")
/// w ##class(web.DHCPlatformPrint).Gen("DHCXMLPrintTest")
ClassMethod Gen(XMLName, XMLString As %String = "", User As %String = "", Group As %String = "", Hospital As %String = "") [ ProcedureBlock = 0 ]
{
	Set ^Wanghc("XMLGEN",XMLName)=XMLString
	;Set $ZT = "GenErr"
	Set XMLStream="",YStep=18
	If XMLString="" {
		S XMLId = $O(^User.DHCXMLPConfigI("XPCFlagIndex"," "_$ZCVT(XMLName,"U"),0))
		If (XMLId){
			Set XMLStream=##class(%GlobalCharacterStream).%New()
			set myconfig=##class(User.DHCXMLPConfig).%OpenId(XMLId,0)
			Set xmlencode = "<?xml version=""1.0"" encoding=""gb2312"" ?>"
			s ind=1
			do myconfig.XPCFileData.Rewind()
			While('myconfig.XPCFileData.AtEnd){
				Set tmpstr=myconfig.XPCFileData.Read()
				set ind=ind+1
				If ($zcvt(tmpstr,"L")[xmlencode){
					Set tmpstr = $replace(tmpstr,xmlencode,"")
				}
				if (tmpstr["YStep="""){
					Set YStep = $p($p($p(tmpstr,"YStep=""",2),"""")," ") ;列表行高
				}
				If $IsObject(XMLStream) Do XMLStream.Write(tmpstr)	
			}
			SEt myconfig=""
			if $IsObject(XMLStream) DO XMLStream.Rewind()
		}
	}
	s reader = ##class(%XML.Reader).%New()
	s sc = reader.OpenStream(XMLStream)
	;s sc = reader.OpenFile("E:\DtHealth\app\dthis\web\xml\1.xml")
	if $$$ISERR(sc) quit $system.Status.GetErrorText(sc)
	d reader.Correlate("invoice","web.print.DHCInvoice")
	#dim obj As web.print.DHCInvoice	
	d reader.Next(.obj,.sc)
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorText(sc)
	}
	
	if $IsObject(obj){
		Set RoutineName = "DTGCOMXML"_XMLId
		Set mLineIndex = 0 
 		Set routine = ##class(%Routine).%New(RoutineName)
		Do ..RWL("Show(mDataStr)")
		Do ..RWL(" Set mData=""""")
		Do ..RWL(" Set itemChar = """_..#ITEMCHAR_"""")
		Do ..RWL(" Set valChar = "_..#VALCHAR)
		Set mLineIndex = mLineIndex+4
		Set XMLClassMethod = obj.XMLClassMethod
		if (XMLClassMethod'="")&&($l(XMLClassMethod)>1){
			Set XMLClassName = $p(XMLClassMethod,".",1,$l(XMLClassMethod,".")-1)
			Set XMLClassMethodName = $p(XMLClassMethod,".",$l(XMLClassMethod,"."))
			set myobj=##class(%Dictionary.CompiledMethod).%OpenId(XMLClassName_"||"_XMLClassMethodName,0)
			set FormalSpecParsed = myobj.FormalSpecParsed
			Set paramsNames=""
			for tempind=1:1:$ll(FormalSpecParsed) {
				Set Spec = $lg(FormalSpecParsed,tempind)
				if ($lg(Spec,4)'=""){
					Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1),"_$lg(Spec,4)_")"
				}else{
					Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
				}
				if (tempind=1) Set paramsNames=paramName
				else  Set paramsNames=paramsNames_","_paramName
			}
			Do ..RWL(" If $g(mDataStr)="""" Set mDataStr = ##class("_XMLClassName_")."_XMLClassMethodName_"("_paramsNames_")")
			Set mLineIndex = mLineIndex+1
		}
		Do ..RWL(" If $g(mDataStr)'="""" {")
		Do ..RWL("	 Set len = $length(mDataStr,itemChar)")
		Do ..RWL("	 for j=1:1:len d")
		Do ..RWL("	 .Set item = $p(mDataStr,itemChar,j)")
		Do ..RWL("	 .Set key = $p(item,valChar,1)")
		Do ..RWL("	 .Set val = $p(item,valChar,2)")
		Do ..RWL("	 .Set mData(key)=val")
		Do ..RWL(" }")
		Set mLineIndex = mLineIndex+8

		Do ..RWL(" ;Name:"_XMLName_",Id:"_XMLId_",RoutineName:"_RoutineName_" "_$zd(+$h,3)_" "_$zt($p($h,",",2)))
		Do ..Enter()
		Do ..RWLHTML(" <style type=""text/css"">")
		Do ..RWLHTML(" label,img{")
		Do ..RWLHTML("     position: absolute;	")
		Do ..RWLHTML(" }")
		Do ..RWLHTML(" .invbg{")
		Do ..RWLHTML("     background-color:#fff;")
		Do ..RWLHTML(" }")
		Do ..RWLHTML(" </style>")
		Do ..Enter()
		Set Width = obj.width*3.78*10
		Set Height = obj.height*3.78*10
		
		
		Do ..RWLHTML(" <div id='invbg"_XMLId_"' class='invbg' style=""width:"_Width_"px;height:"_Height_"px;position:relative;"">")
		Do ..Enter()
		Do ..RWLHTML("  <canvas id='lineLayout' width='"_Width_"px' height='"_Height_"px'></canvas>")
		Do ..Enter()
		Set mLineIndex = mLineIndex+15
		Set txtLength = obj.TxtData.Count()
		;-----txt
		#dim txtObj As web.print.DHCTxtDataPara
		for j=1:1:txtLength{
			Set txtObj = obj.TxtData.GetAt(j)
			do txtObj.ShowItem(routine)
			Set mLineIndex = mLineIndex+1
			if (mLineIndex#200=0) {
				d ..SaveAndNewRoutine(RoutineName,mLineIndex)
			}
		}
		b ;
		;-----pic
		#dim picObj As web.print.DHCPICDataPara
		Set picLength = obj.PICData.Count()
		for j=1:1:picLength{
			Set picObj = obj.PICData.GetAt(j)
			do picObj.ShowItem(routine)
			Set mLineIndex = mLineIndex+1
			if (mLineIndex#200=0) {
				d ..SaveAndNewRoutine(RoutineName,mLineIndex)
			}
		}
		b ;212
		Do routine.WriteLine(" w !,""<script type='text/javascript'>""")
		;-----line
		#dim lineObj As web.print.DHCPLine
		Set lineLength = obj.PLData.Count()
		for j=1:1:lineLength{
			Set lineObj = obj.PLData.GetAt(j)
			do lineObj.ShowItem(routine)
			Set mLineIndex = mLineIndex+1
			if (mLineIndex#200=0) {
				d ..SaveAndNewRoutine(RoutineName,mLineIndex)
			}
		}
		b ;226
		Do routine.WriteLine(" w !,""</script>"",!")
		b ;list
		;-----list
		Set XMLClassQuery = obj.XMLClassQuery
		if (XMLClassQuery'="")&&($l(XMLClassQuery)>1){
			Set XMLClassQName = $p(XMLClassQuery,".",1,$l(XMLClassQuery,".")-1)
			Set XMLQueryName = $p(XMLClassQuery,".",$l(XMLClassQuery,"."))
			Do ..RWL(" Set rs = ##Class(%ResultSet).%New("""_XMLClassQName_":"_XMLQueryName_""")")
			Set mLineIndex = mLineIndex+1
			set FormalSpecParsed = ##class(websys.Query).GetFormalSpecParsed(XMLClassQName,XMLQueryName)
			for tempind=1:1:$ll(FormalSpecParsed) {
				Set Spec = $lg(FormalSpecParsed,tempind)
				if ($lg(Spec,4)'=""){
					Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1),"_$lg(Spec,4)_")"
				}else{
					Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
				}
				if (tempind=1) Set paramsNames=paramName
				else  Set paramsNames=paramsNames_","_paramName
			}
			Do routine.WriteLine(" d rs.Execute("_paramsNames_")")
			Set mLineIndex = mLineIndex+1
			b ;listdatapara
			#dim listitm As web.print.DHCListDataPara
			
			Set listItmLength = obj.ListData.Listdatapara.Count()
			Do ..RWL(" set top = "_(obj.ListData.Listdatapara.GetAt(1).yrow*..#PT2PX)) 
			Do ..RWL(" set rowsInd = -1 ")
			Do ..RWL(" while(rs.Next()){")
			Do ..RWL("  set rowsInd = rowsInd+1")
			Do ..RWL("  set YRowStep = rowsInd*"_(YStep*..#PT2PX))
			;Do ..RWL("  s top = top+"_ ;(YStep*..#PT2PX))  //不走list的top，走listitem的top
			for j=1:1:listItmLength{
				Set listitmObj = obj.ListData.Listdatapara.GetAt(j)
				Do ..RWL("  s top = "_(listitmObj.yrow*..#PT2PX)_"+YRowStep")
				;do listitmObj.ShowItem(routine)
			 	Do routine.WriteLine("  w ""<label style='top:""_top_""px;left:"_(listitmObj.xcol*..#PT2PX)_"px;font-size:"_listitmObj.fontsize_"pt;font-family:"_listitmObj.fontname_";'>""_rs.GetData("_j_")_""</label>""")
				Set mLineIndex = mLineIndex+1
				if (mLineIndex#200=0) {
					d ..SaveAndNewRoutine(RoutineName,mLineIndex)
				}			
			}
			
			Do ..RWL(" }")
		}
		
		Set BackSlashWidth = obj.ListData.BackSlashWidth
		if (BackSlashWidth>0){
			Do ..RWL(" ;打印反斜线")
			do ..RWL(" set BackSlashWidth="_BackSlashWidth)
			Do ..RWL(" if (BackSlashWidth>0){")
			Do ..RWL(" 	set PageRows="_obj.ListData.PageRows)
			Do ..RWL(" 	set rowsInd = rowsInd+1")
			Do ..RWL(" 	set endY = "_(YStep*..#PT2PX)_"+top")
			Do ..RWL(" 	set endX = "_(listitmObj.xcol*..#PT2PX)_"")
			Do ..RWL(" 	set startX = endX-(BackSlashWidth*"_..#PT2PX_")")
			Do ..RWL(" 	set startY = endY+((PageRows-rowsInd)*"_(YStep*..#PT2PX)_")")
			Do ..RWL(" 	w !,""<script type='text/javascript'>""")
			Do ..RWL(" 	w !,""lineData.push({""""beginx"""":""""""_startX_"""""",""""beginy"""":""""""_startY_"""""",""""endx"""":""""""_endX_"""""",""""endy"""":""""""_endY_""""""})""")
			Do ..RWL(" 	w !,""</script>"",!")
			Do ..RWL(" }")
		}
		Do ..RWLHTML(" </div> ")
 		d reader.%Close()
 		s reader=""
 		b ;269
		do ..SaveRoutine(RoutineName,mLineIndex)
	}
	If (XMLId>0){
		Do ##class(web.print.DHCXMLPConfigRef).Save(XMLId,"","","Y")
	}
	q 1
GenErr
  Set ^Wanghc("XMLGEN","Error",XMLName)=$ZE
  Quit -2
}

/// 在routine加上D Show^Routine ,再保存, 现新建新的Routine
ClassMethod SaveAndNewRoutine(RoutineName, mLineIndex)
{
	if (mLineIndex=0){
		$$$macinit(RoutineName)
		Set routine = ##class(%Routine).%New(RoutineName)
	}else{	
		Set RoutineNameEx = RoutineName_"."_(mLineIndex\200)
		Do ..RWL(" d Show^"_RoutineNameEx)
		Do ..SaveRoutine(RoutineName, mLineIndex)
		$$$macinit(RoutineNameEx_".MAC")
		Set routine = ##class(%Routine).%New(RoutineNameEx_".MAC")
		Do ..RWL("Show")
	}
	Quit routine
}

ClassMethod SaveRoutine(RoutineName, mLineIndex)
{
	Do routine.Save()
	Do routine.Compile(..#QUALIFIERS)
	; close the routine object
	Do routine.%Close()
	Set routine=""
}

Method Put(key, value)
{
	Set i%Data(key)=value
	Set i%Data = 1	
	Quit %this
}

Method PrintData(XMLName As %String = "")
{
	m mData = i%Data
	If (XMLName'=""){
		Set i%XMLName = XMLName
	}
	If i%XMLName'="" {
		Set XMLId = $O(^User.DHCXMLPConfigI("XPCFlagIndex"," "_$ZCVT(i%XMLName,"U"),0))
		If (XMLId>0) {
			;##class(%Routine).Exists("DTGCOMXML"_XMLId)
			Set XId = $O(^web.print.DHCXMLPConfigRefI("XMLPConfigIndex",XMLId,""),-1)
			Set GenFlag="N"
			If XId>0 Set GenFlag = $lg(^web.print.DHCXMLPConfigRefD(XId),5)
			;Set ^Wanghc("XMLPrint","GenFlag")=GenFlag
			if GenFlag="N"{
				Set rtn = ##class(web.DHCPlatformPrint).Gen(i%XMLName)
				if rtn=1 {
					x "d Show^DTGCOMXML"_XMLId_"("""")"
				}else{
					Quit rtn
				}
			}else{
				x "d Show^DTGCOMXML"_XMLId_"("""")"
			}
		}
	}
	Quit $$$OK
}

Method %OnNew(initvalue As %CacheString = "") As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%XMLName = initvalue
	Quit $$$OK
}

ClassMethod Test()
{
	Set obj = ##class(web.DHCPlatformPrint).%New()
	Do obj.Put("patname","wanghc").Put("medcare","9023").Put("inadmdata","20140109").Put("outadmdate","2014-9-9")
	Do obj.Put("username","刘三姐").Put("Date","09").Put("time","10:00")
	Do obj.PrintData("DHCJFIPReceipt")
	q 0
}

ClassMethod XMLReaderBug()
{
	s XMLString = "<?xml version=""1.0"" encoding=""GB2312"" ?>"
		_"<txtdatapara name=""name"" xcol=""11.905"" yrow=""24.339"" defaultvalue="""" printvalue="""" fontbold=""false"" "
		_"fontname=""宋体"" fontsize=""12"" />"
	s reader = ##class(%XML.Reader).%New()
	s sc = reader.OpenString(XMLString)	
	#dim node As %XML.Node
	s node = reader.Document.GetDocumentElement()
	d node.MoveToFirstChild()
	w node.GetAttributeValue("fontname")
	Set reader =""
	q 1
}

Method GetPrintData()
{
	Set rtn=""
	Set key=""
	For {
		Set key = $o(i%Data(key))
		quit:key=""
		if (rtn="") {
			Set rtn=key_$c(2)_$g(i%Data(key))
		}else{
			Set rtn=rtn_..#ITEMCHAR_key_$c(2)_$g(i%Data(key))
		}
	}
	Quit rtn
}

ClassMethod RunQuery(ClassName, QueryName)
{
	New (ClassName,QueryName,%request,%session)
	if (ClassName="" )|| (QueryName=""){
		w "var listInfo ="""";"
		Quit ""
	}
	Set paramsNames=""
	set FormalSpecParsed = ##class(websys.Query).GetFormalSpecParsed(ClassName,QueryName)
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
	Set rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""_","_paramsNames_")"
	;Set ^Temp("ext.util.JsonObject","ClassQuery2Json")=execute
	Xecute execute
	Set myjsonstr=""
	w "var listInfo ="""
	Quit:'##class(websys.Conversions).IsValidResultSet(rs) "Not Vaild ResultSet"
	Set count=1
	Set columns=rs.GetColumnCount()
	/*for i=1:1:columns{
		w:i>1 "^"
		w rs.GetColumnHeader(i)
	}*/
	while(rs.Next()){
		write $c(2)
		for i=1:1:columns {
			w:i>1 "^"
			;w rs.GetData(i)
			s tdValue = rs.GetData(i)
			if (tdValue [ $c(10)) {
				s tdValue = $replace(tdValue, $c(10), "")
				s tdValue = $replace(tdValue, """", "\""")
			}
			w tdValue
		}
		set count=count+1
	}
	w """",!
	quit ""
}

ClassMethod RunClass(ClassName, MethodName)
{
	n (ClassName,MethodName,%request,%session)
	Set wantreturnval = $g(%request.Data("wantreturnval",1),1)	;控制是不是有返回值
	if ClassName'="",MethodName'=""{
		Quit:'##class(websys.Conversions).IsValidClassName(ClassName) "{err:'Not Find Class: "_ClassName_"'}"
		Quit:'##class(websys.Conversions).IsValidMethodName(ClassName,MethodName) "{err:'Not Find Method: "_ClassName_":"_MethodName_"'}"
		set myobj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName,0)
		if '$IsObject(myobj) quit "{err:'Not Open "_ClassName_":"_MethodName_" Object'}"
		
		set FormalSpecParsed = myobj.FormalSpecParsed
		Set paramsNames=""
		for tempind=1:1:$ll(FormalSpecParsed) {
			Set Spec = $lg(FormalSpecParsed,tempind)
			If ('$D(%request.Data($lg(Spec,1),1))) { 	;没传req,走入参默认值
				Set paramName = $lg(Spec,4)		;没传req,且没有默认值
				if paramName="" Set paramName=""""""
			}else{
				Set paramName = "$g(%request.Data("""_$lg(Spec,1)_""",1))"
			}
			if (tempind=1) Set paramsNames=paramName
			else  Set paramsNames=paramsNames_","_paramName
		}
		if (wantreturnval){
			Set code="Set rs=##class("_ClassName_")."_MethodName_"("_paramsNames_")"
			XECUTE code
			Quit rs
		} Else {
			Set code="Do ##class("_ClassName_")."_MethodName_"("_paramsNames_")"
			XECUTE code
		}
	}
}

}
