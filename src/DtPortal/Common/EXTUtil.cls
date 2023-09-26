Class DtPortal.Common.EXTUtil Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter pExtLibPath = "/scripts_lib/";

ClassMethod Version500()
{
	;Ext Version 5.0.0
	;d ##class(DtPortal.Common.EXTUtil).Version500()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ext-5.0.0/build/packages/ext-theme-crisp/build/resources/ext-theme-crisp-all-debug.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ext-5.0.0/build/ext-all.js""></script>"
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

}
