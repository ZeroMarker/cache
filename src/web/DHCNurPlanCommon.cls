/// 护理计划公共类
Class web.DHCNurPlanCommon Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: csp引入easyUI、JQuery的js文件
/// Table：
/// Input：
/// Return：
ClassMethod LinkWebUIFile()
{
	
	w !,"<script type=""text/javascript"" src=""../scripts/NurPlan/js/jquery/jquery-1.8.3.min.js""></script>"
    w !,"<script type=""text/javascript"" src=""../scripts/NurPlan/js/common.js""></script>"
    w !,"<script type=""text/javascript"" src=""../scripts/NurPlan/js/commonUI.js""></script>"
    w !,"<script type=""text/javascript"" src=""../scripts/NurPlan/js/commonValidate.js""></script>"
	w ##class(jquery.websys.EasyuiLib).LoadCSS("../skin/default/css/websys.easyui.1.3.2.css"),!
	d ..WriteDateFormat()
}

ClassMethod WriteDateFormat()
{
	Set format = ##class(websys.Conversions).DateFormat()
	w "<script type='text/javascript'>",!
	;w "if ($.fn.datebox){",!
	w "",!
	w "dateBoxFormatter= function(date){",!
	w "	var y = date.getFullYear();",!
	w "	var m = date.getMonth()+1;",!
	w "	var d = date.getDate();",!
	w:format=3 "	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);",!
	w:format=4 "	return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;",!
	w "};",!
	w "dateBoxParser = function(s){",!
	w "	if (!s) return new Date();",!
	if (format=3){	
		w "	var ss = s.split('-');",!
		w "	var y = parseInt(ss[0],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[2],10);",!
	}elseif(format=4){
		w "	var ss = s.split('/');",!
		w "	var y = parseInt(ss[2],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[0],10);",!
	}
	w "	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){",!
	w "		return new Date(y,m-1,d);",!
	w "	} else {",!
	w "		return new Date();",!
	w "	}",!
	w "};",!
	;w "}",!
	w "</"_"script>",!
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: csp引入easyUI、JQuery的js文件
/// Table：
/// Input：
/// Return
ClassMethod LinkWebUIFile1()
{
	w !,"<script type=""text/javascript"" src=""../../scripts/NurPlan/js/jquery/jquery-1.8.3.min.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/NurPlan/js/common.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/NurPlan/js/commonUI.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/NurPlan/js/commonValidate.js""></script>"
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: csp引入websys等js文件
/// Table：
/// Input：
/// Return
ClassMethod LinkWebSysFile1()
{
	w !,"<script type=""text/javascript"" src=""../../scripts/websys.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/websys.listrows.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/websys.List.js""></script>"
    w !,"<script type=""text/javascript"" src=""../../scripts/websys.List.Tools.js""></script>"
}

}
