/// 名称: DHCMA.Util.Test.ExportFileSrv
/// 描述: 类导出CSV文件
/// 编写者：zhufei
/// 编写日期: 2018-09-30
Class DHCMA.Util.Test.ExportFileSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ToExcel(ExcelName, ExcelTitles, ClassName, QueryName, aInArgs, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
{
	New rs,File
	New pcount Set pcount=$zutil(141)-3
	s ^TMPLiuhe=ExcelName_","_ExcelTitles_","_ClassName_","_QueryName_","_aInArgs_","_p1_","_ p2_","_ p3
	// 从websys.Configuration中转入 zutil(141)不准确
	If $d(%request.Data("WARGC",1),ppcount),(ppcount-5)>pcount Set pcount=ppcount
	s ^TMPLiuhe("pcount")=pcount
	// 老版的ajax方法会把p1-p16都设置上空,会影响query入参判断, 从query入参校正一下
	Set Spec = ##class(websys.Query).GetFormalSpecParsed(ClassName,QueryName)
	if pcount>$ll(Spec) set pcount=$ll(Spec) 
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
	Xecute execute	
	If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
	Set columns=rs.GetColumnCount()
	
	//d File.WriteLine("") 
	
	if (aInArgs'=""){
		
		Set colList=""
		For i=1:1:columns d 
		.Set colList=colList_$lb(rs.GetColumnHeader(i))
		
		Set NumList=""
		For i=1:1:$l(aInArgs,"^") d 
		.Quit:($listfind(colList,$p(aInArgs,"^",i))<1) 
		.Set num=$listfind(colList,$p(aInArgs,"^",i))
		.d File.Write($p(ExcelTitles,"^",i)_",")
		.if (NumList="") Set NumList=num quit
		.Set NumList=NumList_"^"_num
		
		For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:$l(NumList,"^") s data =rs.GetData($p(NumList,"^",i))  d File.Write($c(9)_data_",") } else { quit }
		
	}else{
		For i=1:1:columns d File.Write(rs.GetColumnHeader(i)_",")
		For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:columns s data =rs.GetData(i) d File.Write($c(9)_data_",") } else { quit }
		
	}
	if $$$ISERR(%sc) do $system.OBJ.DisplayError(%sc)
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set rs =""
    Quit "dhctt.file.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(ExcelName)_"&dirname="_PhyDir
}

/// w ##class(DHCMA.Util.Test.ExportFileSrv).ExportCSVFile()
ClassMethod ExportCSVFile()
{
	New
	
	Set fileName="TEST-"_$tr($zd(+$h,3),"-","")_$tr($zt($p($h,",",2),1),":","")_".csv"
	Set filePath="D:\"_fileName
	If ##class(%File).Exists(filePath) {
		Write "It exists",!
		Quit 1
	}
	
	Set file=##class(%File).%New(filePath)  // D:\file.csv
	Do file.Open("WN")
	For indRow=1:1:10000 {
		Do file.WriteLine(indRow_","_"This is a line of text")
	}
	Do file.Close()
	
	Quit 2
}

/// w ##class(DHCMA.Util.Test.ExportFileSrv).ToExcel("测试","ID^代码^名称","DHCMA.CPW.BTS.PathTypeSrv","QryPathType")
ClassMethod TestToExcel(ExcelName, ExcelTitle, ClassName, QueryName, InArgs As %String = "nothing") As %String
{
	New rs,File
	Set tmpspl=$c(94)	//^分割符
	
	Set CurrDate=$tr($zd(+$h,3),"-","")
	Set CurrTime=$tr($zt($p($h,",",2),1),":","")
	Set ExcelName="MR"_CurrDate_CurrTime
	
	//创建Excel文件
	Set ExcelDir=..GetTempDir()  //获取文件目录
	Set:$l(ExcelName,".")=1 ExcelName=ExcelName_".cvs"  //处理文件名
	Set File = ##class(%File).%New(ExcelDir_ExcelName)
	Do File.Open("NWRS")
	
	//执行Query
	Set rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	If InArgs'="nothing" {
		For i=1:1:$l(InArgs,"^") Set execute=execute_","_$c(34)_$p(InArgs,tmpspl,i)_$c(34)
	}
	Set execute=execute_")"
	Xecute execute
	If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
	Set Columns=rs.GetColumnCount()
	
	//导出表头
	Set ExcelTitle="序号^"_ExcelTitle
	Do File.WriteLine($tr(ExcelTitle,tmpspl,$c(9)))	//导出表头
	
	//导出内容
	Set rowIndex=1
	For {
		Quit:rs.Next(.%sc)=0
		If $$$ISOK(%sc) {
			Set rowData=rowIndex
			For colIndex=1:1:Columns {
				Set rowData=rowData_$c(9)_$zcvt("'"_rs.GetData(colIndex),"O","JS")
			}
			Do File.WriteLine(rowData)
			Set rowIndex=rowIndex+1
		} Else { Quit }
	}
	If $$$ISERR(%sc) Do $system.OBJ.DisplayError(%sc)
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	Set File=""
	Set rs =""
	Set url="dhcma.util.download.csp?1=1&act=download&filename="_ExcelName_"&dirname="_ExcelDir_"&2=2"
	Quit url
}

/// w ##class(DHCMRQ.MRService.SetDataService).GetTempDir()
ClassMethod GetTempDir() As %String
{
	New
	Set $zt="GetTempDirError"
	Set version=$ZVERSION
	If version["Windows" {
		//Set tmp="C:\InterSystems\Cache\mgr\Temp\"
		Set temp=##class(%File).TempFilename()
		Set temp=##class(%File).ParentDirectoryName(temp)
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

/// w ##class(DHCMRQ.MRService.SetDataService).SetPathOS("D:\hello\test\a")
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

}
