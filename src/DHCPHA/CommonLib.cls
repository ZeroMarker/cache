/// creator:yunhaibao
/// createdate:20160804
/// description:引入药房的公共js
Class DHCPHA.CommonLib Extends %RegisteredObject
{

Parameter EasyUIPath = "scripts_lib/jquery-easyui-1.3.5/";

Parameter CommonPath = "scripts/dhcpha/common/";

Parameter BootstrapPath = "scripts_lib/bootstrap-3.3.5/";

Parameter FontAwesomePath = "scripts/pharmacy/plugins/Font-Awesome-4.6.3/";

/// 导入BootStrap库文件
ClassMethod LoadBootstrapLib(ss)
{
	Set Application=%request.Application
	//<!--Bootstrap css-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_Application_..#BootstrapPath_"css/bootstrap.min.css"" />"
    
    //<!--Font-Awesome-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_Application_..#FontAwesomePath_"css/font-awesome.min.css"" />"
    
	//<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_Application_..#BootstrapPath_"js/jquery-1.11.0.min.js""></script>"
    
    //<!-- Include all compiled plugins (below), or include individual files as needed -->
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_Application_..#BootstrapPath_"js/bootstrap.min.js""></script>"
    //s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_Application_..#BootstrapPath_"customplugins/jquery.bootstrap.min.js""></script>"
    
   /* s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#BootstrapPath_"css/bootstrap.min.css"" />"
    
    //<!--Font-Awesome-->
    s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_pre_..#FontAwesomePath_"css/font-awesome.min.css"" />"
    
	//<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"js/jquery-1.11.0.min.js""></script>"
    
    //<!-- Include all compiled plugins (below), or include individual files as needed -->
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"js/bootstrap.min.js""></script>"
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_pre_..#BootstrapPath_"customplugins/jquery.bootstrap.min.js""></script>"*/
    
    f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// 导入easyUI公共js及css
ClassMethod LoadCommonLib()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/default/easyui.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/icon.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/color.css"" />"
	//<!-- 第三方插件CSS end  -->
	
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jquery-1.8.0.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jqueryEasyUI-1.3.5.js""></script>"	
	//<!-- 第三方插件 end  -->
    // 公用JS
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#CommonPath_"dhcdoc.config.common.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#CommonPath_"dhcdoc.config.commonutil.js""></script>"		


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// 导入美康js及css
ClassMethod LoadMKLib()
{
	/*
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/default/easyui.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/icon.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#EasyUIPath_"themes/color.css"" />"
	//<!-- 第三方插件CSS end  -->
	
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jquery-1.8.0.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#EasyUIPath_"jqueryEasyUI-1.3.5.js""></script>"	
	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
	*/
	q
}

ClassMethod LoadLanguage()
{
	s user = $G(%session.Data("LOGON.USERID"))
	s lang = $p($g(^SSU("SSUSR", +user)), "^", 13)
	s langCode = $p($g(^SS("LAN", +lang)), "^", 1)
	d ##class(ext.websys.ExtLib).Version321()
	if (langCode '= "")&&(langCode '= "CH") {
 		d ##class(ext.websys.ExtLib).Version321()	
	}else{
		d ..AddGFunction()
	}
}

ClassMethod AddGFunction()
{
	&html<
		 <SCRIPT Language="Javascript">
		 if(!$g){
			var $g = function(input){
				return input;
			} 
		 }
		</SCRIPT> 
	>
}

}
