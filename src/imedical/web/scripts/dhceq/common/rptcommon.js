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
	//initButtonWidth(); //modify by zyq 2023-03-23
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
	
	setElement("EquipTypeIDs","");
	if (($("#EquipTypes").length>0)&&($("#EquipTypes").combogrid("getValues")!="")) setElement("EquipTypeIDs",$("#EquipTypes").combogrid("getValues").toString());
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
///add by ZY0250 20200106
///增加预折旧按钮得操作,按钮是否显示,在dhceq.fam.monthdeprelist.csp 中根据参数变量DepreFlag是否为1来控制.
/// 涉及三个菜单：分类折旧统计DHCEQ.S.Rpt.DepreCat；折旧明细DHCEQ.S.Rpt.DepreDetail；科室折旧 DHCEQ.S.Rpt.DepreLoc
/// 目前只科室折旧 DHCEQ.S.Rpt.DepreLoc增加了DepreFlag=1的参数传递.
function BDepre_Clicked()
{
	var pMonthStr=getElementValue("pMonthStr");
	if (pMonthStr=="")
	{
		messageShow('alert','error','错误提示',"预折旧月份不能为空!")
		return;
	}
	var EquipTypeIDS=getElementValue("EquipTypeIDS");
	var jsonData=tkMakeServerCall("web.DHCEQMonthDepre","GetPreMonthDepre",pMonthStr,EquipTypeIDS);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","success","","预折旧完成");
		return
	}
    else
    {
	    if (jsonData.SQLCODE=="-1001") messageShow("","","","错误信息:"+jsonData.Data);
	    else messageShow('alert','error','错误提示',"有"+jsonData.Data+"个资产折旧出错!")
		return;
	}
}
// MZY0118	2536230		2022-03-28
//元素参数重新获取值
function getParam(ID)
{
	if (ID=="EquipTypeDR") {return getElementValue("EquipTypeDR");}
}

///add by ZY0298 20220307
function BHandWork_Clicked()
{
	var url="dhceq.fam.accountperiod.csp?";
	showWindow(url,"手工折旧快照月结","","","icon-w-paper","modal","","","large"); 
}
