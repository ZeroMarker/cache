//Modify By DJ 2017-12-14 JQuery+��Ǭ����������������Ը������ӦJS��
//�������
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
///modify by lmm 2018-09-29 hisui���죺��ӱ�����ʽ lookup��ʼ�� ��ť����һ��
function initDocument()
{
	defindTitleStyle()
	initLookUp();
	initButton();
	initButtonWidth();
}

/***************************************��ť���ú���*****************************************************/
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
	//ֱ�Ӵ�ӡ
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
	//Ԥ��
	var fileName=ReportFileName+lnk+PrintStr
	DHCST_RQPrint(fileName)

	//�ɰ汾
	var PrintFlag=getElementValue("PrintFlag")
	var PrintObj='ReportFile'
	if (PrintFlag==1) PrintObj='ReportFilePrint'
	document.getElementById(PrintObj).contentWindow.document.frames["RunQianReport"].report1_print()
	*/
}
function BFind_Clicked()
{	 //add  by wl 2020-04-01 ������Ǭ����ɫ
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
	//V8.2֮���ֱ�����ش�ӡ,������ʾ��ӡģ��ֿ�
	//if (PrintFlag==1) document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}
///add by lmm 2018-09-20
///������������dr��ֵ
///��Σ�vElementID ������id
///      item ѡ��������
function setSelectValue(vElementID,item)
{
	//��ȡLookupԪ�ص�idField����
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
