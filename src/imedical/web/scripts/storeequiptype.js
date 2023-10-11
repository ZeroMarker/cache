/// Creator��      WY
/// CreatDate��    2020-10-16
/// Description:   �ⷿ��������
var PreSelectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  
});

function initDocument()
{
	initUserInfo();
    initMessage(""); //��ȡ����ҵ����Ϣ
    initLookUp(); //��ʼ���Ŵ�
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"LELStoreLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("LELStoreLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    //add by wy 2021-6-2 1967835 WY0093
    var paramsFrom=[{"name":"Desc","type":"1","value":"LELEquipTypeDR_ETDesc"},{"name":"QXType","type":"2","value":"1"}];
    singlelookup("LELEquipTypeDR_ETDesc","PLAT.L.EquipType",paramsFrom,"");
	defindTitleStyle();
    initButton(); //��ť��ʼ��
    initButtonWidth();
    setRequiredElements("LELStoreLocDR_CTLOCDesc^LELEquipTypeDR_ETDesc")
    //fillData(); //�������
    setEnabled(); //��ť����
	$HUI.datagrid("#DHCEQCStoreEquipType",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.CTStoreEquipType",
	        	QueryName:"GetStoreEquipType",
			    StoreLocDR:getElementValue("LELStoreLocDR"),
			    EquipTypeDR:getElementValue("LELEquipTypeDR"),
			    Flag:GetCheckValue("LELFlag")
		},
		fit:true,
		singleSelect:true, //modified by wy 20-21-5-28 �б�ĳɵ�ѡ
	    rownumbers: true,
   		fitColumns:true,  //add by wy 2021-5-287 �б�����Ӧ  
		onClickRow:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
		columns:[[
    	{field:'TLELRowID',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TLELStoreLoc',title:'�ⷿ',width:200,align:'center'},
        {field:'TLELEquipType',title:'�����豸����',width:200,align:'center'}, 
        {field:'TLELFlag',title:'Ĭ�Ϸ���',width:200,align:'center'} 
         ]], 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="LELStoreLocDR_CTLOCDesc") {setElement("LELStoreLocDR",rowData.TRowID)}
	else if(elementID=="LELEquipTypeDR_ETDesc") {setElement("LELEquipTypeDR",rowData.TRowID)}

}
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQCStoreEquipType",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.CTStoreEquipType",
	        	QueryName:"GetStoreEquipType",
			    StoreLocDR:getElementValue("LELStoreLocDR"),
			    EquipTypeDR:getElementValue("LELEquipTypeDR"),
			    Flag:GetCheckValue("LELFlag")
		},
		columns:[[
    	{field:'TLELRowID',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TLELStoreLoc',title:'�ⷿ',width:200,align:'center'},
        {field:'TLELEquipType',title:'�����豸����',width:200,align:'center'},
        {field:'TLELFlag',title:'Ĭ�Ϸ���',width:200,align:'center'} 
         ]], 
	    fit:true,
		singleSelect:true,
	    rownumbers: true
	});

}
///Creator: WY
///CreatDate: 2020-10-20
///Description: ������������
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTStoreEquipType","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");  
	var url="dhceq.plat.storeequiptype.csp?&RowID=";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

///Creator: WY
///CreatDate: 2020-10-20
///Description: ����ɾ������
function BDelete_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var truthBeTold = window.confirm("�Ƿ�ɾ��������¼��");  
	if (!truthBeTold) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTStoreEquipType","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");  
	var url="dhceq.plat.storeequiptype.csp?&RowID=";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
///������¼�
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TLELRowID)
	{
		setElement("LELRowID",rowData.TLELRowID);
		setElement("LELStoreLocDR_CTLOCDesc",rowData.TLELStoreLoc);
		setElement("LELStoreLocDR",rowData.TLELStoreLocDR);
		setElement("LELEquipTypeDR_ETDesc",rowData.TLELEquipType);
		setElement("LELEquipTypeDR",rowData.TLELEquipTypeDR);
		setElement("LELFlag",rowData.TLELFlagDR);
		disableElement("BSave",false);
	    disableElement("BDelete",false);
		PreSelectedRowID=rowData.TLELRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
		setEnabled();
	}	
}

//��հ�ť�����¼���ȡ��ѡ���д����¼�
function BClear_Clicked()
{
		setElement("LELRowID","");
		setElement("LELStoreLocDR_CTLOCDesc","");
		setElement("LELStoreLocDR","");
		setElement("LELEquipTypeDR_ETDesc","");
		setElement("LELEquipTypeDR","");
		setElement("LELFlag","");
}
function setEnabled()
{
	disableElement("BSave",false);
	disableElement("BDelete",true);
}

function clearData(elementID)
{
	if(elementID=="LELStoreLocDR_CTLOCDesc") {setElement("LELStoreLocDR","")}
	else if(elementID=="LELEquipTypeDR_ETDesc") {setElement("LELEquipTypeDR","")}
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"";
}