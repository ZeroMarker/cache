Class web.DHCST.Common.ExtCommonLib Extends %RegisteredObject
{

Parameter pExtLibPath = "/scripts/dhcst/";

Parameter pExtLibPathM = "/scripts/dhcstm/";

ClassMethod LoadCommonJs()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ExtUX/flashmessage/Ext.ux.MessageBox.flash.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ExtUX/css/Common.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"ExtUX/css/Ext.ux.form.LovCombo.css"" />"
		
	//<!-- 第三方插件CSS end  -->
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/Acc.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/flashmessage/Ext.ux.MessageBox.flash.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"URL/CSPUrl.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/DTHealthCommon.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"ExtUX/components.js""></script>"
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/WarnsWinCommon.js""></script>"
	

	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

ClassMethod LoadCommonJsM()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPathM_"ExtUX/flashmessage/Ext.ux.MessageBox.flash.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPathM_"ExtUX/css/Common.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPathM_"ExtUX/css/Ext.ux.form.LovCombo.css"" />"
		
	//<!-- 第三方插件CSS end  -->
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPathM_"Common/Acc.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPathM_"ExtUX/flashmessage/Ext.ux.MessageBox.flash.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPathM_"URL/CSPUrl.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPathM_"Common/DTHealthCommon.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPathM_"ExtUX/components.js""></script>"

	

	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

}
