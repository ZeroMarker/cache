var preRowID=0
var t=[]             //add hly 20190724
t[-3003]="�����ظ�"  //add hly 20190724
var columns=getCurColumnsInfo('RM.L.Rent.PriceType','','',''); //��ȡ�ж���
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	defindTitleStyle();
	initButton(); //��ť��ʼ��
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	initButtonWidth();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  �޸ĵ�����ʾundefined
	setRequiredElements("PTCode^PTDesc")
	setEnabled();		//��ť����
	initDHCEQSCPriceType();			//��ʼ�����
}
///��ʼ����ť״̬
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///ѡ���а�ť״̬
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}	
function OnclickRow()
{
	var selected=$('#tDHCEQSCPriceType').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			setElement("PTRowID",selectedRowID);
			setElement("PTCode",selected.TCode);
			setElement("PTDesc",selected.TDesc);
			setElement("PTRemark",selected.TRemark);
			preRowID=selectedRowID;
			UnderSelect()
		}
		else
		{
			ClearElement();
			$('#tDHCEQSCPriceType').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
			setEnabled()
		}
	}
}
function ClearElement()
{
	setElement("PTRowID","");
	setElement("PTCode","");
	setElement("PTDesc","");
	setElement("PTRemark","");
}
function BFind_Clicked()
{
	initDHCEQSCPriceType()
}

function BAdd_Clicked()
{
	if(getElementValue("PTRowID")!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function BSave_Clicked()
{
	if(getElementValue("PTRowID")==""){$.messager.alert('��ʾ','����ʧ��,��Ҫѡ��һ����¼��','warning');return;}
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"2");
	jsonData=eval('(' + jsonData + ')')
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","���³ɹ�");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function BDelete_Clicked()
{
	if(getElementValue("PTRowID")==""){$.messager.alert('��ʾ','��ѡ��һ����Ҫɾ���ļ�¼��','warning');return;}
	messageShow("confirm","info","��ʾ",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTPriceType","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
	var url="dhceq.rm.pricetype.csp";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
function initDHCEQSCPriceType()
{
	$HUI.datagrid("#tDHCEQSCPriceType",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.CTPriceType",
	        QueryName:"GetPriceType",
	        Code:getElementValue("PTCode"),
			Desc:getElementValue("PTDesc"),
	    },
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		rownumbers:true,  //modefied by zc0107 2021-11-14 �����к�����
		pagination:true,
    	columns:columns,
		onClickRow:function(rowIndex,rowData){OnclickRow();},

});
}
