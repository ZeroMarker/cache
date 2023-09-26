Class EMRservice.Tools.ExportToExcel Extends %RegisteredObject
{

/// desc 导出excel  (具体可参考文档)
/// creator duan
///    2019-11-11
/// input  AExcelName 导出文件名
///       AClassName 取数据类名 (必填)
///       AMethod     取数据方法(必填)
///       AParams    取数据入参
///  开发返回的数据格式：   返回类型 %ListOfDataTypes 格式: 第一条列名称         %ListOfDataTypes
///                                                   		后接导出的每组数据    %ListOfDataTypes
/// output 返回下载地址   
/// w ##class(EMRservice.Tools.ExportToExcel).toExcelByEMR("医生01-1573628517157","web.eprajax.query.basicquery","getExcelData","480,HIS^EpisodeID^EpisodeID^就诊指针^str^1&HIS^EpisodeNo^EpisodeNo^就诊号^str^1&HIS^RegNo^RegNo^登记号^str^1&HIS^RecordNo^RecordNo^病案号^str^1&HIS^Name^Name^姓名^str^1")
ClassMethod toExcelByEMR(AExcelName As %String, AClassName As %String, AMethod As %String, AParams As %String)
{
	s ^Temp("duan","toExcelByEMR")=AExcelName_","_AClassName_","_AMethod_","_AParams
	s result="0"
	s key=""
	q:(AClassName="")||(AMethod="") result
	s:AExcelName="" AExcelName="excelName"
	Set excelDir = "\temp\excel\"
	if ($p(AExcelName,".",$l(AExcelName,"."))="csv") { 	
	}else{
		Set AExcelName = AExcelName_".csv"
	}
	Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	Set File = ##class(%File).%New(PhyDir_AExcelName)
	do File.Open("NWRS")
	s param=""	
	for i=1:1:$L(AParams,",")
	{
		s:(param '= "") param = param_","
		
		//如果入参中包含双引号，替换为2个双引号，保证参数格式。
		s param = param_""""_$replace($P(AParams,",",i),"""","""""")_""""	
	}
	s execCode = "result=##class("_AClassName_")."_AMethod_"("_param_")"
    s @execCode
    s data = @"result"
    s count = data.Count()
    q:count<=1 result
    for j=1:1:count
    {
		s arr = data.GetAt(j)
		if (j=1){
		//设置列名
	    	s itemCount=arr.Count()
			for i=1:1:itemCount{
				 s pData=arr.GetAt(i)
	     		 d File.Write(..csvEscape(pData)_",")
			}
			d File.WriteLine("")
		}else{
			//取数据
			s itemCount=arr.Count()
			for i=1:1:itemCount{
				 s pData=arr.GetAt(i)
	     		 d File.Write(..csvEscape(pData)_",")
			}
			d File.WriteLine("")
		}
	}
	Do File.Flush()
	Do File.%Save()
	Do File.Close()
	q "websys.file.utf8.csp?act=download&filename="_##class(%CSP.Page).EscapeURL(AExcelName)_"&dirname="_PhyDir_"&servertype=HTTP"
}

/// 字符处理
/// w ##class(EMRservice.Tools.ExportToExcel).csvEscape(""abc,we")
ClassMethod csvEscape(AValue As %String)
{
	q:AValue="" AValue
	s result = AValue
	s flag = "false"
	s:result["," flag="true"
	if (result[""""){
		s flag="true"
		s result = $Replace(result,"""","""""")
	}
	s:flag="true" result=""""_result_""""
	q result
}

}
