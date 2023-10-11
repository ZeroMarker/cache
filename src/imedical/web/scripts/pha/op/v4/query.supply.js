/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	����ҩ��--����ҩ��������ѯ
 *	JS			scripts/pha/op/v4/query.supply.js
 */
 
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
$(function () {
	COMPOMENTS = OP_COMPOMENTS;
	InitGridSupplyList();	//	�����б�
	InitGridSupplyDetail();	//	������ϸ
	InitDict();
	InitEvent();			//	��ť�¼�
	ResizePanel();			//	���ֵ���	
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QuerySupplyList();});
	//��� toolbar
	PHA_EVENT.Bind('#btnRePrint', 		'click', function () {RePrint();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
}
// ���ֵ���
function ResizePanel(){	
	setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
	 // �������
    PHA.ComboBox('phLocId',{
	    editable:false, 
    	url: PHAOP_STORE.PHLOC().url,
    	onLoadSuccess: function () {
	    	var datas = $("#phLocId").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == session['LOGON.CTLOCID']) {
                    $("#phLocId").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
    	}
    });
     // ����ҩ
    PHA.ComboBox('baseLocId',{
	    blurValidValue:true,
    	url: PHAOP_STORE.BaseLoc().url
    });
}
// ��ʼ����ѯ����
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");
	$("#phLocId").combobox("setValue",session['LOGON.CTLOCID']);
}
function InitGridSupplyList(){
	var normalCol=[[
		{ field: 'Tward', 			title: ('����'), 			width: 120,		align: 'left', 		hidden: true},
		{ field: 'Tdocloc', 		title: ('��������'),		width: 150,		align: 'left'},
		{ field: 'Tsuppdate', 		title: ('����'),	 		width: 120,		align: 'left'},
        { field: 'Tsupptime',		title: ('ʱ��'),			width: 130,		align: 'left'},
		{ field: 'Tusername', 		title: ('������'),	 		width: 100,		align: 'left'},
		{ field: 'Tsuppno', 		title: ('����'),	 		width: 250,		align: 'left'},
		{ field: 'Tsupp', 			title: ('������id'),	 	width: 80,		align: 'left', 		hidden: true},
	]]
	COMPOMENTS.ComomGrid("gridSupplyList",{
		columns: normalCol,
		toolbar : '#gridSupplyListBar',
		onSelect : function(rowIndex, rowData) {
			QuerySupplyDetail();
		},onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridSupplyList').datagrid("selectRow",0);
			}else{
				$('#gridSupplyDetail').datagrid('clear');
			}
		}
	})
}
function InitGridSupplyDetail(){
	var normalCol = [[
		{field: 'Tincicode',		title: ("ҩƷ����"),		width: 100,		align: 'left'}, 
		{field: 'Tincidesc',		title: ("ҩƷ����"),		width: 300,		align: 'left'}, 
		{field: 'Tqty',				title: ("��ҩ����"),		width: 125,		align: 'right'}, 
		{field: 'Tspec',			title: ("���"),			width: 125,		align: 'left'}
	]];
	COMPOMENTS.ComomGrid("gridSupplyDetail",{
		columns: normalCol
	})
}
function GetParams(){
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.outFlag ="1";
	pJson.inFlag ="0";
	pJson.locId = PHAOP_COM.LogonData.LocId;
	
	return pJson;
}
// ��ѯ�����б�
function QuerySupplyList(){
	var $grid =  $("#gridSupplyList");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Supply.Api' ,
        pMethodName:'GetSupplyList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 

}

// ��ѯ������ϸ
function QuerySupplyDetail(){	
	var $grid =  $("#gridSupplyDetail");
	var rowData = $("#gridSupplyList").datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "��ѡ��������������ݣ�");
		return false;
	}
	var pJson = {};
	pJson.suppStr = rowData.Tsupp;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Supply.Api' ,
        pMethodName:'GetSupplyDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridSupplyList').datagrid('clear');
	$('#gridSupplyDetail').datagrid('clear');
	InitDefVal();
}


// ��ӡ
function RePrint(){
	var $grid = $("#gridSupplyList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "��ѡ��������������ݣ�");
		return false;
	}
	var suppId = rowData.Tsupp;
	OP_PRINTCOM.PrintSupply(suppId);
}

