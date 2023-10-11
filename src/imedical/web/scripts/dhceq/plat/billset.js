// ���ݴ�ӡģ������
// ����csp:dhceq.plat.ctbillset.csp
///��̬��ȡdatagrid����Ϣ
var Columns=getCurColumnsInfo('PLAT.G.CT.BillSet','','','')
var editIndex=undefined;
var SelectedRow=-1;
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initUserInfo();
	initLookUp();
	initMessage();
	defindTitleStyle();
	initButton();
	initButtonWidth();
	initBussType();
	initFileType();
	initEquipType();
	$HUI.datagrid("#ctbillsetdatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.CTBillSet",
	        	QueryName:"GetBillSet",
		},
	    toolbar:[{
    			iconCls: 'icon-save',
                text:'����',
				id:'save',
                handler: function(){
                     saveBillSet();
                }},'----------',
                {
                iconCls: 'icon-cancel',
                text:'ɾ��',
				id:'del',
                handler: function(){
                     delBillSet();
                }}
        ],
		rownumbers: true,  //���Ϊtrue����ʾһ���к���
		singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20,40,60,80],
		onLoadSuccess:function(){}
	});
	setRequiredElements("BussType^FileType^File");
}
function initBussType()
{
	var RiskGrade = $HUI.combobox('#BussType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '���յ�'
			},{
				id: '2',
				text: '��ⵥ'
			},{
				id: '3',
				text: 'ת�Ƶ�'
			},{
				id: '4',
				text: '�˻����ٵ�'
		}],
	});
}
function initFileType()
{
	var FileType = $HUI.combobox('#FileType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: 'Excel'
			},{
				id: '1',
				text: '��ǬRaq/Rpx'
		}]
	});
}
function initEquipType()
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
	        //{field:'TCode',title:'����',width:150},
	    ]]/*,
	    onSelect:function(e){
		    //alert("onSelect:")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		},
		onClickRow:function(index, row){
			alert("onClickRow")
			//setElement("IEquipTypeIDs",$(this).combogrid("getValues"));
		}*/
	});
}
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function onClickRow(index)
{
	var rowData = $('#ctbillsetdatagrid').datagrid('getSelected');
	if (SelectedRow==index)
	{
		SelectedRow=-1;
		setElement("BSRowID","");
		setElement("BussType","");
		setElement("SubTypes","");
		setElement("FileType","");
		setElement("File","");
		setElement("HospitalDR_HDesc","");
		setElement("HospitalDR","");
		setElement("EquipType","");
		setElement("EquipTypeIDs","");
		$('#ctbillsetdatagrid').datagrid('unselectAll');	//add by FX0006	2022-08-25
	}
	else
	{
		SelectedRow=index;
		setElement("BSRowID",rowData.TRowID);
		var results=tkMakeServerCall("web.DHCEQ.Plat.CTBillSet","GetOneBillSet",getElementValue("BSRowID"));
		var list=results.split("^")
		//alert(results)
		setElement("BussType",list[0]);
		setElement("SubTypes",list[1]);
		setElement("FileType",list[2]);
		setElement("File",list[3]);
		setElement("HospitalDR",list[4]);
		setElement("HospitalDR_HDesc",list[13]);
		setElement("EquipType","");
		setElement("EquipTypeIDs",list[5]);
		if (list[5]!="")
		{
			var arr=list[5].split(",");
			$('#EquipType').combogrid('setValues', arr);
		}
	}
}
///Description: ���ݱ��淽��
function saveBillSet()
{
	if(checkMustItemNull()){return;}
    setElement("EquipTypeIDs",$("#EquipType").combogrid("getValues"));
	var BSData=$("#BSRowID").val()+"^"+$("#BussType").combogrid("getValues")+"^"+$("#SubTypes").val()+"^"+$("#FileType").combogrid("getValues")+"^"+$("#File").val()+"^"+$("#HospitalDR").val()+"^"+$("#EquipTypeIDs").val();
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTBillSet","UpdateBillSet",BSData,"");
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","����ɹ���");
	var url="dhceq.plat.ctbillset.csp"
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url}, 50);		// MZY0099	2254720		2021-11-13
}
// MZY0101	2294019		2021-11-22	����ȷ��
///Description: ����ɾ������
function delBillSet()
{
	if (getElementValue("BSRowID")=="")
	{
		messageShow('alert','error','������ʾ','��ѡ���¼!');
		return;
	}
	messageShow("confirm","info","��ʾ","��ȷ��Ҫɾ���ü�¼��?","",confirmDelete,unconfirmDelete);
}
function confirmDelete()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTBillSet","UpdateBillSet",getElementValue("BSRowID"), 1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
	var url="dhceq.plat.ctbillset.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url}, 50);
}
function unconfirmDelete()
{
}
