$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage();
	initEvent();
	initEquipTypeIDS();
	initStoreLocDR();
	initDepreTypeDR();
	initKeepDepreFee();
	initAdjustFlag();
	initInputFlag();
	initIsCurMonth();
	initReportEquipTypeIDS();
	initReportStoreLocDR();
	hiddenDepreElements(true);
	initTaskGrid();
	//initDepreGrid();
	//initReportGrid();
	//initSnapGrid();
	$HUI.tabs("#TabsData",{
		onSelect:function(title)
		{
			if (title=="�¼����ݵ���")
			{
				hiddenDepreElements(true);
			}
			else if (title=="׷�����ݵ���")
			{
				hiddenDepreElements(false);
			}
		}
	});
	$HUI.checkbox('#IsManageLocData',{
		onChecked:function(event,val){
			$("#AddAdjust").css('display','none');
			$("#AddInitReport").css('display','block');
		},
		onUnchecked:function(event,val){
			$("#AddAdjust").css('display','block');
			$("#AddInitReport").css('display','none');
		}
	});
}

function initEvent()
{
	jQuery("#BImport").on("click", BImport_Clicked);
	jQuery("#BDownLoad").on("click", BDownLoad_Clicked);
	jQuery("#BAddImport").on("click", BImport_Clicked);
	jQuery("#BAddDownLoad").on("click", BDownLoad_Clicked);
	jQuery("#BAdustData").on("click", BAdustData_Clicked);
	jQuery("#BDownLoadAdustdata").on("click", BDownLoadAdustdata_Clicked);
	
	jQuery("#BInitDepre").on("click", BInitDepre_Clicked);	//��ʼ���۾�
	jQuery("#BInitSnap").on("click", BInitSnap_Clicked);	//��ʼ������
	jQuery("#BInitReport").on("click", BInitReport_Clicked);	//��ʼ���±�
	jQuery("#BAddInitDepre").on("click", BAddInitDepre_Clicked);	//׷�����ݳ�ʼ���۾�
	jQuery("#BAddInitReport").on("click", BInitReport_Clicked);	//׷�����ݳ�ʼ���±�
	
	jQuery("#BExeInitDepre").on("click", BExeInitDepre_Clicked);
	jQuery("#BCloseDepre").on("click", BCloseDepre_Clicked);
	jQuery("#BExeInitReport").on("click", BExeInitReport_Clicked);
	jQuery("#BCloseReport").on("click", BCloseReport_Clicked);
}

//��ʼ������
function initEquipTypeIDS()
{
	$HUI.combogrid('#EquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	    ]]
	});
}

//��ʼ������
function initStoreLocDR()
{
	singlelookup("StoreLoc","PLAT.L.Loc");
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID);
}

//��ʼ���۾�����
function initDepreTypeDR()
{
	$HUI.combogrid('#DepreType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCDepreMethod",
	        QueryName:"DepreType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'�۾�����',width:150}
	    ]],
	    onSelect:function(index,rowData){
			setElement("DepreTypeDR",rowData.TRowID);
		}
	});
}
	
function initKeepDepreFee()
{
	var KeepDepreFee = $HUI.combobox("#KeepDepreFee",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'��'},
			{id:'1',text:'��'}
		]
	});
}
function initAdjustFlag()
{
	var AdjustFlag = $HUI.combobox("#AdjustFlag",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:'��'},
			{id:'Y',text:'��'}
		]
	});
}
function initInputFlag()
{
	var InputFlag = $HUI.combobox("#InputFlag",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:'��'},
			{id:'Y',text:'��'}
		]
	});
}
function initIsCurMonth()
{
	var IsCurMonth = $HUI.combobox("#IsCurMonth",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'����'},
			{id:'1',text:'����'}
		]
	});
}

function initReportEquipTypeIDS()
{
	$HUI.combogrid('#ReportEquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	    ]]
	});
}

function initReportStoreLocDR()
{
	singlelookup("ReportStoreLoc","PLAT.L.Loc");
}

function BImport_Clicked()
{
	var url="dhceqimportdata.csp?";
	showWindow(url,"���ݵ���","","","icon-w-paper","modal","","","verylarge"); 
}

function BDownLoad_Clicked()
{
	/*ecp·������ȡ������web��Ϣ
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQEquipImport.xls";
	window.open(TemplatePath)
	*/
	//czf 2022-04-06
	var AFRowID=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetAppenfFileIDBySource","67","1",32,"����׼��ģ��");
	if (AFRowID=="")
	{
		alertShow("����׼��ģ�岻����,���ڹ���������ϴ�������׼��ģ��.xls��!")
		return;
	}
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",AFRowID);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename)
}

function BAdustData_Clicked()
{
	messageShow("confirm","alert","","ȷ���Ƿ������������������׷�ӣ�","",function(){
		$("#IsManageLocData").checkbox('setValue',true);
		alertShow("��ִ�г�ʼ���±�!")
		return;
	},function(){
		$("#IsManageLocData").checkbox('setValue',false);
		var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataFind&UserFlag=false";
		showWindow(url,"�������ݵ���","","","icon-w-paper","modal","","","verylarge");
	},"��","��");
}

function BDownLoadAdustdata_Clicked()
{
	/*
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQAdjustData.xls";
	window.open(TemplatePath)
	*/
	//czf 2022-04-06
	var AFRowID=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetAppenfFileIDBySource","67","2",32,"�������ݵ���");
	if (AFRowID=="")
	{
		alertShow("�������ݵ���ģ�岻����,���ڹ���������ϴ����������ݵ���.xls��ģ��!")
		return;
	}
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",AFRowID);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename)
}

function BInitDepre_Clicked()
{
	messageShow("confirm","alert","","����ϸ�Ķ�ע����������,ȷ�����������ú���ִ�У�","",function(){
		clearDepreData();
		setRequiredElements("vDate^KeepDepreFee");
		$HUI.dialog('#DepreWin', {
			iconCls:'icon-w-paper',
			width: 1100,
			height: 335,
			modal:true,
			title: '��ʼ���۾�',
			onOpen: function(){
				
			}
		}).open();
	},function(){
		return;
	},"����","ȡ��");
}

function BAddInitDepre_Clicked()
{
	messageShow("confirm","alert","","����ϸ�Ķ�ע����������,ȷ�����������ú���ִ�У�","",function(){
		clearDepreData();
		setElement("InputFlag","Y");
		setRequiredElements("vDate^KeepDepreFee");
		$HUI.dialog('#DepreWin', {
			iconCls:'icon-w-paper',
			width: 1100,
			height: 485,
			modal:true,
			title: '׷�����ݳ�ʼ���۾�',
			onOpen: function(){
				
			}
		}).open();
	},function(){
		return;
	},"����","ȡ��");
}

//��ʼ������
function BInitSnap_Clicked()
{
	var	result=tkMakeServerCall("web.DHCEQInit","InitSnap")
	if (result==0)
	{
		alertShow("ִ�гɹ�!")
	}
	else
	{
		alertShow("ִ��ʧ��!")
	}
	//initSnapGrid();
	initTaskGrid();
}

function BInitReport_Clicked()
{
	messageShow("confirm","alert","","����ϸ�Ķ�ע����������,��ȷ��֮ǰ������ִ�У�","",function(){
		clearReportData();
		setRequiredElements("IsCurMonth");
		$HUI.dialog('#ReportWin', {
			iconCls:'icon-w-paper',
			width: 750,
			height: 205,
			modal:true,
			title: '��ʼ���±�',
			onOpen: function(){
				//
			}
		}).open();
	},function(){
		return;
	},"����","ȡ��");
}

//��ʼ���۾�
function BExeInitDepre_Clicked()
{
	if (checkMustItemNull("")) return
	var EquipTypeIDS=$("#EquipType").combogrid('getValues').toString()
	var	result=tkMakeServerCall("web.DHCEQInit","InitEquipDepre",getElementValue("vDate"),EquipTypeIDS,getElementValue("StoreLocDR"),getElementValue("DepreTypeDR"),getElementValue("KeepDepreFee"),getElementValue("MinEquipID"),getElementValue("MaxEquipID"),getElementValue("DepreMonthNum"),getElementValue("AdjustFlag"),getElementValue("InputFlag"))
	if (result==0)
	{
		alertShow("ִ�гɹ�!")
		BCloseDepre_Clicked()
	}
	else
	{
		alertShow("��"+result+"������δ��ʼ��!")
	}
	//initDepreGrid();
	initTaskGrid();
}

//��ʼ���±�
function BExeInitReport_Clicked()
{
	if (getElementValue("IsCurMonth")=="") 
	{
		alertShow("��ʼ���·ݲ���Ϊ��!")
		return;
	}
	var ReportEquipTypeIDS=$("#ReportEquipType").combogrid('getValues').toString()
	var ReportStoreLocDR=getElementValue("ReportStoreLocDR");
	var result=tkMakeServerCall("web.DHCEQInit","InitReport",getElementValue("IsCurMonth"),ReportEquipTypeIDS,ReportStoreLocDR)
	alertShow("ִ�����!")
	BCloseReport_Clicked()
	//initReportGrid();
	initTaskGrid();
}

function BCloseDepre_Clicked()
{
	$HUI.dialog("#DepreWin").close();
}

function BCloseReport_Clicked()
{
	$HUI.dialog("#ReportWin").close();
}

function hiddenDepreElements(value)
{
	hiddenObj("cMinEquipID",value);
	hiddenObj("MinEquipID",value);
	hiddenObj("cMaxEquipID",value);
	hiddenObj("MaxEquipID",value);
	hiddenObj("cDepreMonthNum",value);
	hiddenObj("DepreMonthNum",value);
	hiddenObj("cAdjustFlag",value);
	hiddenObj("miniddesc",value);
	hiddenObj("maxiddesc",value);
	hiddenObj("deprenumdesc",value);
	hiddenObj("adjustdesc",value);
	hiddenObj("inputdesc",value);
	if (value==true||value==1) $("#AdjustFlag").next().hide();
	else $("#AdjustFlag").next().show();
	hiddenObj("cInputFlag",value);
	if (value==true||value==1) $("#InputFlag").next().hide();
	else $("#InputFlag").next().show();
}

function initTaskGrid()
{
	var initTaskObj=$HUI.datagrid("#tDHCEQInitTask",{
		url:$URL,
		border:false,
	    fit:true,
	    toolbar:[],
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitTaskInfo"
		},
	    columns:[[
	    	{field:'TaskType',title:'��������'},
			{field:'ExeDate',title:'ִ��ʱ��'},
			{field:'result',title:'ִ�н��'},
			{field:'InitDate',title:'��ʼ����������'},
			{field:'EquipTypes',title:'��������'},
			{field:'StoreLoc',title:'����'},
			{field:'DepreType',title:'�۾�����'},
			{field:'KeepDepreFee',title:'�Ƿ����ۼ��۾�'},
			{field:'MinEquipID',title:'��С�豸ID'},
			{field:'MaxEquipID',title:'����豸ID'},
			{field:'DepreMonthNum',title:'�����۾�����'},
			{field:'AdjustFlag',title:'�Ƿ��������ݵ���'},
			{field:'InputFlag',title:'�Ƿ�ֻ��ʼ����������'},
			{field:'IsCurMonth',title:'�Ƿ�ǰ��'}
		]]
	});
}

///��ʼ���۾ɽ��
function initDepreGrid()
{
	var initDepreObj=$HUI.datagrid("#tDHCEQInitDepre",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitDepreInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'ִ��ʱ��'},
			{field:'result',title:'ִ�н��'},
			{field:'InitDate',title:'��ʼ����������'},
			{field:'EquipTypes',title:'��������'},
			{field:'StoreLoc',title:'����'},
			{field:'DepreType',title:'�۾�����'},
			{field:'KeepDepreFee',title:'�Ƿ����ۼ��۾�'},
			{field:'MinEquipID',title:'��С�豸ID'},
			{field:'MaxEquipID',title:'����豸ID'},
			{field:'DepreMonthNum',title:'�����۾�����'},
			{field:'AdjustFlag',title:'�Ƿ��������ݵ���'},
			{field:'InputFlag',title:'�Ƿ�ֻ��ʼ����������'}
		]]
	});
}

///��ʼ���±����
function initReportGrid()
{
	var initReportObj=$HUI.datagrid("#tDHCEQInitReport",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitReportInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'ִ��ʱ��'},
			{field:'result',title:'ִ�н��'},
			{field:'IsCurMonth',title:'�Ƿ�ǰ��'},
			{field:'EquipTypes',title:'��������'},
			{field:'StoreLoc',title:'����'}
		]]
	});
}

///��ʼ�����ս��
function initSnapGrid()
{
	var initSnapObj=$HUI.datagrid("#tDHCEQInitSnap",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitSnapInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'ִ��ʱ��'},
			{field:'result',title:'ִ�н��'}
		]]
	});
}

function clearDepreData()
{
	setElement("vDate","");
	setElement("MinEquipID","");
	setElement("EquipType","");
	setElement("MaxEquipID","");
	setElement("StoreLoc","");
	setElement("DepreMonthNum","");
	setElement("DepreType","");
	setElement("AdjustFlag","");
	setElement("KeepDepreFee","");
	setElement("InputFlag","");
	setElement("DepreTypeDR","");
	setElement("StoreLocDR","");
}

function clearReportData()
{
	setElement("IsCurMonth","");
	setElement("ReportEquipType","");
	setElement("ReportStoreLoc","");
	setElement("ReportStoreLocDR","");
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","");
}
