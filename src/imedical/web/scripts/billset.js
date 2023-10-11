// 单据打印模板配置
// 关联csp:dhceq.plat.ctbillset.csp
///动态获取datagrid列信息
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
                text:'保存',
				id:'save',
                handler: function(){
                     saveBillSet();
                }},'----------',
                {
                iconCls: 'icon-cancel',
                text:'删除',
				id:'del',
                handler: function(){
                     delBillSet();
                }}
        ],
		rownumbers: true,  //如果为true则显示一个行号列
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
				text: '验收单'
			},{
				id: '2',
				text: '入库单'
			},{
				id: '3',
				text: '转移单'
			},{
				id: '4',
				text: '退货减少单'
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
				text: '润乾Raq/Rpx'
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
	    rowStyle:'checkbox', //显示成勾选行形式
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
	        {field:'TName',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
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
///Description: 数据保存方法
function saveBillSet()
{
	if(checkMustItemNull()){return;}
    setElement("EquipTypeIDs",$("#EquipType").combogrid("getValues"));
	var BSData=$("#BSRowID").val()+"^"+$("#BussType").combogrid("getValues")+"^"+$("#SubTypes").val()+"^"+$("#FileType").combogrid("getValues")+"^"+$("#File").val()+"^"+$("#HospitalDR").val()+"^"+$("#EquipTypeIDs").val();
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTBillSet","UpdateBillSet",BSData,"");
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","保存成功！");
	var url="dhceq.plat.ctbillset.csp"
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url}, 50);		// MZY0099	2254720		2021-11-13
}
// MZY0101	2294019		2021-11-22	增加确认
///Description: 数据删除方法
function delBillSet()
{
	if (getElementValue("BSRowID")=="")
	{
		messageShow('alert','error','错误提示','请选择记录!');
		return;
	}
	messageShow("confirm","info","提示","您确认要删除该记录吗?","",confirmDelete,unconfirmDelete);
}
function confirmDelete()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTBillSet","UpdateBillSet",getElementValue("BSRowID"), 1);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	var url="dhceq.plat.ctbillset.csp";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url}, 50);
}
function unconfirmDelete()
{
}
