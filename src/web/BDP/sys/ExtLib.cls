Class web.BDP.sys.ExtLib Extends %RegisteredObject
{

Parameter pExtLibPath = "/scripts_lib/";

ClassMethod Version321()
{
	;Ext Version 3.2.1
	;d ##class(ext.websys.ExtLib).Version321()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.2.1/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.2.1/adapter/ext/ext-base.js""></script>"
	;s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.2.1/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.2.1/ext-all-debug.js""></script>"
	
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext3.2.1/ux/css/RowEditor.css""/>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.2.1/ux/RowEditor.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext3.2.1/src/locale/ext-lang-zh_CN.js""></script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

}
