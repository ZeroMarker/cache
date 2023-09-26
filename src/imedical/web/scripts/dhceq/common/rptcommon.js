//Modify By DJ 2017-12-14 JQuery+润乾开发报表界面入库改自各报表对应JS内
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
///modify by lmm 2018-09-29 hisui改造：添加标题样式 lookup初始化 按钮长度一致
function initDocument()
{
	defindTitleStyle()
	initLookUp();
	initButton();
	initButtonWidth();
}

/***************************************按钮调用函数*****************************************************/
function BPrint_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var PrintFlag=getElementValue("PrintFlag");
	var PrintStr=""
	var lnk="";
	$("input").each(function(){
		var id=$(this)[0].id;
		var objClassInfo=$("#"+id).prop("class");
		var options=jQuery("#"+id).attr("data-options");
		if ((id!="")&&(id!="PrintFlag")&&(id!="ReportFileSrc")&&(id!="ReportFilePrintSrc")&&(id!="ReportFileName"))
		{
			if (objClassInfo.indexOf("hisui-datebox")>=0)
			{
				lnk=lnk+"&"+id+"="+GetJQueryDate("#"+id);
			}
			else
			{
				lnk=lnk+"&"+id+"="+getElementValue(id);
			}
		}
	})
	if ((PrintFlag==1)||(PrintFlag==2)) PrintStr="&PrintFlag=1"
	//直接打印
	var lnkStr=lnk+PrintStr
	var fileName="{+ReportFileName+}"
	if (lnkStr!="")
	{
		lnkStr=lnkStr.substring(1,lnkStr.length)
		lnkStr=lnkStr.replace(/&/g,";")
		fileName="{"+ReportFileName+"("+lnkStr+")}";
	}
	DHCCPM_RQDirectPrint(fileName)
	/*
	//预览
	var fileName=ReportFileName+lnk+PrintStr
	DHCST_RQPrint(fileName)

	//旧版本
	var PrintFlag=getElementValue("PrintFlag")
	var PrintObj='ReportFile'
	if (PrintFlag==1) PrintObj='ReportFilePrint'
	document.getElementById(PrintObj).contentWindow.document.frames["RunQianReport"].report1_print()
	*/
}
function BFind_Clicked()
{	 //add  by wl 2020-04-01 增加润乾背景色
	var ColTColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902001");
	var DataColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902002");
	var SumColor=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","902003");
	var Colorstr="&ColTColor="+ColTColor+"&DataColor="+DataColor+"&SumColor="+SumColor;
	var ReportFileName=jQuery("#ReportFileName").val();
	var PrintFlag=getElementValue("PrintFlag");
	var PrintStr=""
	var lnk="";
	$("input").each(function(){
		var id=$(this)[0].id;
		var objClassInfo=$("#"+id).prop("class");
		var options=jQuery("#"+id).attr("data-options");
		if ((id!="")&&(id!="PrintFlag")&&(id!="ReportFileSrc")&&(id!="ReportFilePrintSrc")&&(id!="ReportFileName"))
		{
			if (objClassInfo.indexOf("hisui-datebox")>=0)
			{
				lnk=lnk+"&"+id+"="+GetJQueryDate("#"+id);
			}
			else
			{
				lnk=lnk+"&"+id+"="+getElementValue(id);
			}
		}
	})
	if (PrintFlag==2) PrintStr="&PrintFlag=1"
	
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+PrintStr+Colorstr; //modify  by wl 2020-04-01
	//V8.2之后可直接隐藏打印,无须显示打印模版分开
	//if (PrintFlag==1) document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}
///add by lmm 2018-09-20
///描述：下拉框dr赋值
///入参：vElementID 下拉框id
///      item 选中行数据
function setSelectValue(vElementID,item)
{
	//获取Lookup元素的idField属性
	var OptionsObj=$("#"+vElementID).lookup("options")
	setElement(vElementID+"DR",item[OptionsObj.idField])
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function setIframeHeight(iframe) {
	if (iframe) {
		var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
		if (iframeWin.document.body) {
			iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight;
		}
	}
};
