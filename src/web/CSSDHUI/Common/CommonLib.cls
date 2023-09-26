Class web.CSSDHUI.Common.CommonLib Extends %RegisteredObject
{

Parameter pExtLibPath = "/scripts/cssd/";

ClassMethod LoadCommonJs()
{
	d ..WriteDateFormat()

	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/jquery.json-2.4.min.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/jquery.jdirk.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/datagrid-navigating.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/components.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/datagrid-cellediting.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/jquery.hotkeys.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/datagrid-timespinner.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/Acc.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/common.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/colHideShow.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/commonUI.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/datagrid-dnd.js""></script>"
	//报表打印公共js
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src=""../scripts/DHCCPMRQCommon.js""></script>"
	//grid打印公共js
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src=""../scripts/DHCPrtComm.js""></script>"
	//导出Excel
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/ExportExcel/Blob.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/ExportExcel/FileSaver.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/ExportExcel/ExportUtil.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/XLSX/xlsx.full.min.js""></script>"
	//BusyLoad
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/BusyLoad/app.js""></script>"
	//列设置
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/GridColSet.js""></script>"
	
	//css
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"Common/css/Common.css""/></link>"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"Common/BusyLoad/app.css""/></link>"

	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

ClassMethod WriteDateFormat()
{
	w !," "_"<script type='text/javascript'>"
	s format = ##class(web.CSSDHUI.CSSDType).GetDateFormat()
	w !," "_"websys_DateFormat='"_format_"';"
	w !," "_"</script>"
}

}
