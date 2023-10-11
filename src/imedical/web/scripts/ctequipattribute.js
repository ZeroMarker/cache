var columns=getCurColumnsInfo('PLAT.G.CT.EquipAttribute','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
}); 
var PreSelectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
//�������
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);
///��ʼ������
function initDocument()
{
	defindTitleStyle(); //Ĭ��Style
	initMessage();
	initPage();			//�Ŵ󾵼���ť��ʼ��
	setEnabled();		//��ť����
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
//�Ŵ󾵼���ť��ʼ��
function initPage()
{
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSave").on("click", BSave_Clicked);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BDelete").on("click", BDelete_Clicked);
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
	initButtonWidth();
	initMaindatagrid();
	setRequiredElements("EACode^EAName")
}
//���Ұ�ť����¼�
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTEquipAttribute",
	    	QueryName:"GetEquipAttributeData",
	    	Code:getElementValue("EACode"),	//add by csj 20191202
	    	Name:getElementValue("EAName")	//add by csj 20191202
		}
	});
}
//������GRID
function initMaindatagrid()
{
	$(function(){
		$HUI.datagrid('#maindatagrid',{
			url:$URL,
			queryParams:{
        		ClassName:"web.DHCEQ.Plat.CTEquipAttribute",
        		QueryName:"GetEquipAttributeData",
    		},
			onSelect:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
			
			onLoadSuccess:function(data){

			},
			//autoSizeColumn:false,
			//fitColumns:true,
			fitColumns:true,
			cache: false,
			columns:columns,
			//idField:'id',
			pagination:true,
			pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
			//rownumbers:true,
			singleSelect:true,
			//width:500,
			//height:330,
		})
	})		
}
///������¼�
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("EARowID",rowData.TRowID);
		setElement("EACode",rowData.TCode);
		setElement("EAName",rowData.TName);
		setElement("EAGroup",rowData.TGroup);
		setElement("EARemark",rowData.TRemark);

		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}
	
}

//////////////////////////////////ҵ������/////////////////////////////////////////////

///Creator: jyp
///CreatDate: 2018-10-09
///Description: ������������
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"2");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

///Creator: jyp
///CreatDate: 2018-10-09
///Description: ���ݱ��淽��
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}

	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�޸ĳɹ���");
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
///Creator: jyp
///CreatDate: 2018-10-09
///Description: ����ɾ������
function BDelete_Clicked()
{
	//modified by wy 2021-9-14 2144478
	messageShow("confirm","info","��ʾ","�Ƿ�ɾ������Ϣ��","",BDelete,function(){
		return;
		});	

}
function BDelete()
{ 
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTEquipAttribute","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	else {messageShow("alert","success","��ʾ","ɾ���ɹ���");}
	var url="dhceq.plat.ctequipattribute.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},300);  //modified by wy 2021-9-6 2144478
}
//��հ�ť�����¼���ȡ��ѡ���д����¼�
function BClear_Clicked()
{
	setElement("EARowID","");
	setElement("EACode","");
	setElement("EAName","");
	setElement("EAGroup","");
	setElement("EARemark","");

	setEnabled();
	PreSelectedRowID=""
}
