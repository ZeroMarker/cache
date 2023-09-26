var SessionObj = {
	GUSERID : curUserID,
	GUSERCODE : curUserCode,
	GUSERNAME : curUserName,
	GGROURPID : session['LOGON.GROUPID'],
	GGROURPDESC : session['LOGON.GROUPDESC'],
	GLOCID : curLocID,
	GHOSPID : session['LOGON.HOSPID'],
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};

function log(val)
{
	//console.log(val);
}
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
	initPanel();
	initButtonWidth();
	//setFocus("Equip");;
}


function initPanel()
{
	initTopPanel();
	//initInsurFlagData();		//�ڱ���־
	//initReportTypeData();		//��������
	//initTopData();	//����������ݳ�ʼ����
}

//��ʼ����ѯͷ���
///modify by lmm 2018-09-20
///������hisui���죺��ťͼ���޸�
function initTopPanel()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BPrint").linkbutton({iconCls: 'icon-w-print'});
	jQuery("#BPrint").on("click", BPrint_Clicked);
	//��ֵԪ�ض���onchange�¼�,��У����Ч��
	
	//initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");

}
function initInsurFlagData()
{
	if (jQuery("#InsurFlag").prop("type")!="hidden")
	{
		jQuery("#InsurFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'All'
			},{
				id: 'Y',
				text: 'Yes'
			},{
				id: 'N',
				text: 'No'
			}],
			onSelect: function() {GlobalObj.InsurFlagDR=jQuery("#InsurFlag").combobox("getValue");}
		});
	}
}
function initReportTypeData()
{
	if (jQuery("#ReportType").prop("type")!="hidden")
	{
		jQuery("#ReportType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '1',
				text: '�����½�'
			},{
				id: '0',
				text: 'ʵ���½�'
			}],
			onSelect: function() {GlobalObj.ReportTypeDR=jQuery("#ReportType").combobox("getValue");}
		});
	}
}
function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		alertShow("����ȷ������ֵ!")
		return
	}
}
/***************************************��ť���ú���*****************************************************/
function BPrint_Clicked()
{
	document.getElementById('ReportFilePrint').contentWindow.document.frames["RunQianReport"].report1_print()
}
function GetComboGridDesc(vElements,vElements2)
{
	var ReturnStr=""
	if (vElements!="")
	{
		var ElementsInfo=vElements.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var vElementID=ElementsInfo[i-1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vElementID+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	if (vElements2!="")
	{
		var ElementsInfo=vElements2.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var CurElement=ElementsInfo[i-1]
			var CurElementInfo=CurElement.split("=");
			var vParamName=CurElementInfo[0];
			var vElementID=CurElementInfo[1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vParamName+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	return ReturnStr
}
///add by lmm 2018-09-20
///������������dr��ֵ
///��Σ�vElementID ������id
///      item ѡ��������
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}