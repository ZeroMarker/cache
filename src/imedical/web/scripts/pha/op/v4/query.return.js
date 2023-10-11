/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.08.24
 *	Description	����ҩ��--��ҩ��ѯ
 *	JS			scripts/pha/op/v4/query.retrun.js
 */
 
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
$(function () {
	COMPOMENTS = OP_COMPOMENTS;
	InitGridReturnList();	//	�����б�
	InitGridReturnDetail();	//	������ϸ
	InitDict();
	InitEvent();			//	��ť�¼�
	ResizePanel();			//	���ֵ���	
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryReturnList();});
	//��� toolbar
	PHA_EVENT.Bind('#btnRePrint', 		'click', function () {RePrint();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnCancel', 		'click', function () {CancelReturn();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {
		PHAOP_COM.ExportGrid("gridReturnList");
	});
	// �ǼǺ�
	$('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryReturnList();
            }
        }
    });
}
// ���ֵ���
function ResizePanel(){	
	if(APP_PROP.CancleRetPermissions !=="Y"){
		$("#btnCancel").hide();
	}
	setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
	// ҩƷ�������
    PHA_UX.ComboBox.INCItm('inci', {
        width: 397,
        qParams: {
            pJsonStr: {
                stkType: App_StkType,
                scgId: "",
                locId: PHAOP_COM.LogonData.LocId
            }
        }
    });
	InitRetStat();
}
//��ʼ����ҩ״̬
function InitRetStat(){
    var data = [
        { RowId: 0, Description: $g("ȫ��") },
        { RowId: 1, Description: $g("��ҩ") }, 
		{ RowId: 2, Description: $g("�ѳ���") }
     ];
    PHA.ComboBox('retState',{
        editable:false, 
        data: data,
        onSelect:function(data){
            QueryReturnList();
        }
    }); 
}
// ��ʼ����ѯ����
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#retState").combobox("setValue",0) ;
	$("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");
}
function InitGridReturnList(){
	var frozenCol=[[
		{ field: 'TPmiNo', 			title: ('�ǼǺ�'), 			width: 120,		align: 'left'},
		{ field: 'TPatName', 		title: ('����'),	 		width: 80,		align: 'left'},
		{ field: 'TRetDate', 		title: ('��ҩ����'),	 	width: 120,		align: 'left'},
		{ field: 'TRetTime', 		title: ('��ҩʱ��'),	 	width: 80,		align: 'left'},
        { field: 'TPrescNo',		title: ('������'),			width: 130,		align: 'left'}
	]];
	var normalCol = [[
		{ field: 'TRetMoney', 		title: ('��ҩ���'),	 	width: 60,		align: 'left'},
		{ field: 'TRetUser', 		title: ('������'),	 		width: 80,		align: 'right'},
		{ field: 'TDoctor', 		title: ('ҽ��'),	 		width: 80,		align: 'left'},
		{ field: 'TLocDesc', 		title: ('����'),	 		width: 150,		align: 'left'},
		{ field: 'TRetReason', 		title: ('��ҩԭ��'),	 	width: 120,		align: 'left'},
		{ field: 'TDispDate', 		title: ('��ҩ����'),	 	width: 120,		align: 'left'},
		{ field: 'TCancleUser', 	title: ('������'),	 		width: 80,		align: 'left'},
		{ field: 'TCancleDate', 	title: ('��������'),	 	width: 120,		align: 'left'},
		{ field: 'TCancleTime', 	title: ('����ʱ��'),	 	width: 120,		align: 'left'},
		{ field: 'TRetRowid', 		title: ('��ҩ��Id'),	 	width: 200,		align: 'left', 		hidden: true},
		{ field: 'TPatLevel', 		title: ('���˼���'),	 	width: 120,		align: 'left', 		hidden: true},
		{ field: 'TEncryptLevel', 	title: ('�����ܼ�'), 		width: 200,		align: 'left', 		hidden: PHAOP_COM.ColHidden.PatLevel},
		{ field: 'TPatLevel', 		title: ('���˼���'),	 	width: 120,		align: 'left', 		hidden: PHAOP_COM.ColHidden.PatLevel}
	]]
	COMPOMENTS.ComomGrid("gridReturnList",{
		columns: normalCol,
		frozenColumns: frozenCol,
		toolbar : '#gridReturnListBar',
		onSelect : function(rowIndex, rowData) {
			QueryReturnDetail();
		},onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridReturnList').datagrid("selectRow",0);
			}else{
				$('#gridReturnDetail').datagrid('clear');
			}
		}
	})
}
function InitGridReturnDetail(){
	var normalCol = [[
		{field: 'TPhDesc',			title: ("ҩƷ����"),		width: 300,		align: 'left'}, 
		{field: 'TPhUom',			title: ("��λ"),			width: 125,		align: 'left'}, 
		{field: 'TRetQty',			title: ("��ҩ����"),		width: 125,		align: 'right'}, 
		{field: 'TPhprice',			title: ("����"),			width: 125,		align: 'right'},
		{field: 'TRetMoney',		title: ("��ҩ���"),		width: 125,		align: 'right'}, 
		{field: 'TBatExpStr',		title: ("����~Ч��"),		width: 125,		align: 'left'}
	]];
	COMPOMENTS.ComomGrid("gridReturnDetail",{
		columns: normalCol
	})
}
function GetParams(){
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.locId = PHAOP_COM.LogonData.LocId;
	return pJson;
}
// ��ѯ�����б�
function QueryReturnList(){
	var $grid =  $("#gridReturnList");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.RetQuery.Api' ,
        pMethodName:'GetReturnList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 

}

// ��ѯ������ϸ
function QueryReturnDetail(){	
	var $grid =  $("#gridReturnDetail");
	var rowData = $("#gridReturnList").datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "��ѡ������ҩ���ݣ�");
		return false;
	}
	var pJson = {};
	pJson.retId = rowData.TRetRowid;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.RetQuery.Api' ,
        pMethodName:'GetReturnDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridReturnList').datagrid('clear');
	$('#gridReturnDetail').datagrid('clear');
	InitDefVal();
}
// ������ҩ
function CancelReturn(){
	var $grid = $("#gridReturnList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "��ѡ������ҩ���ݣ�");
		return false;
	}
	var pJson={
		retId : rowData.TRetRowid,
		locId : PHAOP_COM.LogonData.LocId,
		userId : PHAOP_COM.LogonData.UserId,
		groupId : PHAOP_COM.LogonData.GroupId,
	}
	var retVal = PHA.CM({
		pClassName: 'PHA.OP.Return.Api',
		pMethodName: 'CancelReturn',
		pJson: JSON.stringify(pJson)
	},false);
	var retCode = retVal.code; 
	if(retCode == 0){
		PHAOP_COM._Msg("success","�����ɹ�!");
		QueryReturnList();
	} else {
		PHAOP_COM._Alert(retVal.msg);
		return false;
	}
}


// ��ӡ
function RePrint(){
	var $grid = $("#gridReturnList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "��ѡ���ӡ����ҩ���ݣ�");
		return false;
	}
	var retId = rowData.TRetRowid;
	OP_PRINTCOM.PrintReturn(retId, "��");
}
