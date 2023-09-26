///药房药库润乾打印封装
///Creator:		hulihua
///CreateDate:	2018-03-09
///scripts/dhcst/Common/DHCSTRQCommon.js

///润乾直接打印
/// 格式: {报表名称.raq}{报表名称.raq(par1=val1;par2=val2)}
function DHCCPM_RQDirectPrint(filename)
{
	if (filename==""){
		alert("请输入报表名称和报表参数");
		return;
	}
	var printobj=window.document.Dtreport1_directPrintApplet;
	
	try{
		printobj.print(filename);
	}catch(e){
		
	}
	
}

/// 润乾预览打印
/// 格式:  1.报表名称.raq
/// 2.报表名称.raq&arg1=val1&arg2=val2
/// 第二个参数：  width
/// 第三个参数：  height
function DHCST_RQPrint(parameter,target) {
	//use window.open so we can close this window, without closing everything
	//format reportname(reportarg1=value;reportarg2=value)
	var args = arguments.length
	var width = width||2000;
	var height= height||1000;
	var parm = ""
	if(args>=1){
		if (arguments[0]==""){
			alert("请输入报表名称和报表参数");
			return;
		}
		parm=arguments[0];
	}
	if(args>=2){
		if(arguments[1]!=""){
			width=arguments[1];
		}
	}
	if(args>=3){
		if(arguments[2]!=""){
			height=arguments[2];
		}
	}
	//var url="/dthealth/web/csp/dhccpmrunqianreportprint.csp?reportName="+parm;
	var url="/imedical/web/csp/dhccpmrunqianreportprint.csp?reportName="+parm;
	window.open(url,target,"width=" + width + ",height=" + height + ",top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}