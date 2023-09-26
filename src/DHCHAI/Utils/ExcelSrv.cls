/// 名称: DHCHAI.Utils.ExcelSrv
/// 描述: Excel导出打印服务类
/// 创建者: zhoubo
/// 创建日期: 2023-03-09
Class DHCHAI.Utils.ExcelSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2020-06-18
/// Description:  导出query内容到服务器
/// Input：       aFileName  : 文件名
///               aExtension  : 扩展名（xls,csv,txt）
///               aClassName  : 类名
///               aQueryName  : query名
///               aArguments  : query参数
///               aViewFields  : 导出的query输出字段
///               aViewTitles  : 表头（title1^title2...titleN）
/// w ##class(MA.IPMR.SSService.ExcelSrv).ExportGridFromServer("接诊日志","xls","MA.IPMR.SS.test","QueryTest","","^Property1^Property2^Property3","^表头1^表头2^表头3")
/// w ##class(MA.IPMR.SSService.ExcelSrv).ExportGridFromServer("测试","xls","MA.IPMR.SS.test","QueryTest","","Property1^Property2^Property3","表头1^表头2^表头3")
/// w ##class(MA.IPMR.SSService.ExcelSrv).ExportGridFromServer("测试","csv","MA.IPMR.SS.test","QueryTest","","Property1^Property2^Property3","表头1^表头2^表头3")
/// w ##class(MA.IPMR.SSService.ExcelSrv).ExportGridFromServer("测试","txt","MA.IPMR.SS.test","QueryTest","","Property1^Property2^Property3","表头1^表头2^表头3")
ClassMethod ExportGridFromServer(aFileName As %String, aExtension As %String, aClassName As %String, aQueryName As %String, aArguments As %String, aViewFields As %String, aViewTitles As %String) As %String
{
	New (aFileName,aExtension,aClassName,aQueryName,aArguments,aViewFields,aViewTitles)
	//Set ^TMP("ExportGridFromServer")=$lb(aFileName,aExtension,aClassName,aQueryName,aArguments,aViewFields,aViewTitles)
	Set return=""
	Quit:(aFileName="")||(aExtension="")||(aClassName="")||(aQueryName="")||(aViewTitles="") return
	Quit:$listfind($lb("xls","csv","txt"),aExtension)=0 return
	
	Set aSeparate = $s(aExtension="xls":$c(9),aExtension="csv":",",aExtension="txt":$c(9),1:"")
	//创建文件
	Set cDate=$tr($zd(+$h,3),"-","")
	Set cTime=$tr($zt($p($h,",",2),1),":","")
	Set FileName=aFileName_"."_aExtension
	Set FileDir=..GetTempDir()  //获取服务器文件目录
	New File
	Set File=##class(%File).%New(FileDir_FileName)
	Do File.Open("NWRS")
	
	//导出表头
	Do File.WriteLine($tr(aViewTitles,"^",aSeparate))
	
	//导出内容
	set rset = ##class(%Library.ResultSet).%New(aClassName_":"_aQueryName)
	set Arguments=""
	if aArguments'="" {
		for indArg=1:1:$length(aArguments,"^") {
			set Arg=$p(aArguments,"^",indArg)
			set Arg=""""_Arg_""""
			set Arguments=Arguments_","_Arg
		}
	}
	set:Arguments'="" Arguments=$e(Arguments,2,$l(Arguments))
	if Arguments="" {
		set execute="do rset.Execute()"
	}else{
		set execute="do rset.Execute("_Arguments_")"
	}
	X execute
	
	Set Properties=..GetQryProperties(aClassName,aQueryName)
	while (rset.Next()) {
		set RowData=""
		for Col=1:1:$length(aViewFields,"^") {
			set FieldVal = ""
			set Field=$p(aViewFields,"^",Col)
			if Field'="" {
				if ($ListFind(Properties,Field)>0) {
					set FieldVal=rset.Data(Field)
					if FieldVal'="" {
						if (aExtension="xls")||(aExtension="csv") {
							Set RegCheck = $match(FieldVal,"^-?[1-9]\d*$")
							if ((RegCheck=1)&&($l(FieldVal)>10)) {	//整数且>10位
								Set FieldVal = FieldVal_$c(2)
							}else {
								Set FieldVal = FieldVal
							}
						}
					}
				}
			}
			set RowData=RowData_aSeparate_FieldVal
		}
		continue:RowData=""
		set RowData=$e(RowData,2,$l(RowData))
		Do File.WriteLine(RowData)
		
	}
	do rset.Close()
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set url="ma.ipmr.filedownload.csp?1=1&act=download&filename="_FileName_"&dirname="_FileDir_"&2=2"
	Quit url
}

/// w ##class(MA.IPMR.SSService.ExcelSrv).GetTempDir()
ClassMethod GetTempDir() As %String
{
	New
	Set $zt="GetTempDirError"
	Set version=$ZVERSION
	If version["Windows" {
		//Set tmp="C:\InterSystems\Cache\mgr\Temp\"
		Set tempChild=##class(%File).TempFilename()
		Set temp=##class(%File).ParentDirectoryName(tempChild)
		Set:(tempChild'="")&&(temp="")&&(tempChild["\") temp=$e(tempChild,1,$l(tempChild)-$l($p(tempChild,"\",$l(tempChild,"\"))))
	} Else {
		Set temp="/tmp/excel/"
	}
	Set path=..SetPathOS(temp)
	Quit $p(path,"||")
	
GetTempDirError
	Set version=$ZVERSION
	If version["Windows" {
		Set temp="c:\tmp\excel\"
	} Else {
		Set temp="/tmp/excel/"
	}
	Set path=..SetPathOS(temp)
	Quit $p(path,"||")
}

/// w ##class(MA.IPMR.SSService.ExcelSrv).SetPathOS("D:\hello\test\a")
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
		s:name(i)'[deli path=path_$get(name(i))_deli
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
	i $p(path2,deli,$l(path2,deli)) ["." d ;若路径中最后一个为文件，则创建该文件。
	.s len=$l(path2,deli)
	.s path=$p(path2,deli,0,len-1),fileName=$p(path2,deli,len)
	e  d
	.s path=path2
	i '##class(%File).Exists(path) d
	.d ##class(%File).CreateDirectoryChain(path)
	i ($g(fileName)'="") d
	.if '(##class(%File).Exists(path_deli_fileName)) d
	..s file=##class(%File).%New(path_deli_fileName)
	..d file.Open("WN")
	..d file.Close()
	.s path=path_deli_fileName
	q path_"||"_deli
}

/// Creator：     liyi
/// CreatDate：   2020-06-18
/// Description:  取Query的ROWSPEC值（输出列）
/// Input：       aClassName  : 类名称
///               aQueryName  : Query名称
/// w ##class(MA.IPMR.SSService.ExcelSrv).GetQryProperties("MA.IPMR.SS.test","QueryTest")
ClassMethod GetQryProperties(aClassName As %String, aQueryName As %String) As %List
{
	New (aClassName,aQueryName)
	Set return=""
	Quit:(aClassName="")||(aQueryName="") return
	
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(aClassName)
	set count = cdef.Queries.Count() 
	For i = 1:1:count {
		if (cdef.Queries.GetAt(i).Name=aQueryName)
	 	 {		 	
		 	Set Propertystr = cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		 	if (Propertystr'="")
		 	{ 
		 		For indPro=1:1:$l(Propertystr,",") {
		 			Set Property=$p($p(Propertystr,",",indPro),":",1)
		 			Set Property=$tr(Property," ","")
		 			Set return=return_$lb(Property)
		 		}
		 	}
		 }
	}
	Quit return
}

/// w ##class(MA.IPMR.SSService.ExcelSrv).GetCurrDateTime()
ClassMethod GetCurrDateTime()
{
	New
	Set CurrDate = ##Class(MA.IPMR.ImedicalSrv).DateLogicalToHtml(+$h)
	Set CurrTime=$zt($p($h,",",2),1)
	Quit CurrDate_" "_CurrTime
}

/// 获取模板文件存放目录
/// w ##class(MA.IPMR.SSService.ExcelSrv).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set strPath=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EPDTemplatePath")
	If strPath="" {
		Set objConfig=##class(websys.Configuration).%OpenId(1)
		Do objConfig.%Close()
		Set strPath=objConfig.PathToReports
	} Else {
		Set strPath=$tr(strPath,"/","\")
	}
	Quit strPath
}

/// Creator：     liyi
/// CreatDate：   2020-06-18
/// Description:  通过Jsxlsx导出数据
/// Input：       aClassName  : 类名
///               aQueryName  : query名
///               aArguments  : query参数
///               aFields  : 导出的query输出字段
///               aTitles  : 表头（title1^title2...titleN）
/// w ##class(MA.IPMR.SSService.ExcelSrv).exportByJsxlsx("DHCHAI.IRS.INFICUPICCSrv","QryICUAdmByStatus","2023-03-09^2023-03-09^80^^3^ALL^","PapmiNo^PatientName^Sex^Age^PAAdmDate^PADischDate^AdmWardDesc","病案号^姓名^性别^年龄^入院日期^出院日期^就诊科别")
ClassMethod exportByJsxlsx(aClassName As %String, aQueryName As %String, aArguments As %String, aFields As %String, aTitles As %String) As %String
{
	New (aClassName,aQueryName,aArguments,aFields,aTitles)
	//Set ^TMP("exportByJsxlsx")=$lb(aClassName,aQueryName,aArguments,aFields,aTitles)
	Set return=""
	Quit:(aClassName="")||(aQueryName="") return
	//导出内容
	set rset = ##class(%Library.ResultSet).%New(aClassName_":"_aQueryName)
	set Arguments=""
	if aArguments'="" {
		for indArg=1:1:$length(aArguments,"^") {
			set Arg=$p(aArguments,"^",indArg)
			set Arg=""""_Arg_""""
			set Arguments=Arguments_","_Arg
		}
	}
	set:Arguments'="" Arguments=$e(Arguments,2,$l(Arguments))
	if Arguments="" {
		set execute="do rset.Execute()"
	}else{
		set execute="do rset.Execute("_Arguments_")"
	}
	X execute
	w "{"
	w """"_"rows"_""""_":"
	w "["
	Set Properties=..GetQryProperties(aClassName,aQueryName)
	set displayRows = 0
	while (rset.Next()) {
		set row=""
		for Col=1:1:$length(aFields,"^") {
			set FieldVal = ""
			set Field=$p(aFields,"^",Col)
			set Title=$p(aTitles,"^",Col)
			if Field'="" {
				if ($ListFind(Properties,Field)>0) {
					set FieldVal=rset.Data(Field)
					set FieldVal = ..EvalJSON(FieldVal)
				}
			}
			set row = row_$case(Col,1:"",:",")_""""_Title_""":"""_FieldVal_""""
		}
		write $case(displayRows,0:"",:","),"{",row,"}"
		set displayRows = displayRows+1
	}
	w "]"
	w ","_""""_"total"_""""_":"_displayRows_"}"
	Quit ""
}

/// 按标准JSON来处理字符转义
ClassMethod EvalJSON(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr
	s mystr = ..Replace(mystr,"\", "\\")
	s mystr = ..Replace(mystr,"""", "\""")
	s mystr = ..Replace(mystr,$c(8), "\b") 			// 退格(BS)
	s mystr = ..Replace(mystr,$c(9), "\t")
	s mystr = ..Replace(mystr,$c(10), "\n")
	s mystr = ..Replace(mystr,$c(12), "") // FF(NP from feed, new page)
	s mystr = ..Replace(mystr,$c(13), "\r")
	s mystr = ..Replace(mystr,$c(14), "") //SO(shift out)  
	s mystr = ..Replace(mystr,$c(0), "")
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

}
