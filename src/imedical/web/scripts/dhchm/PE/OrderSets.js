/*
 * FileName: dhchm/PE/OrderSets.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-����ײ�ά��
 */
var Public_layer_ID = "";
var Public_layer_ID2 = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEOrderSets();
    InitGridPEOrderSetsDtl();
	$('#gridPEOrderSets').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridPEOrderSetsDtl').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	
	$('#gridPEOrderSets_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEOrderSets"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPEOrderSetsDtl_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPEOrderSetsDtl"),value,Public_gridsearch2);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEOrderSets();
	    }
    });
	
    //��ѯ
    $("#btnFind").click(function() {
		LoadGridPEOrderSets();
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEOrderSets').datagrid('getSelected');
		winPEOrderSetsEdit_layer(rd);
    });
	
    //�޸�
    $("#btnUpdate2").click(function() {
		var rd = $('#gridPEOrderSetsDtl').datagrid('getSelected');
		winPEOrderSetsDtlEdit_layer(rd);
    });
	
	//������-��ʼ��
	InitWinPEOrderSetsEdit();
	
	//������-��ʼ��
	InitWinPEOrderSetsDtlEdit();
})

//������-�������
function winPEOrderSetsEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OrderSetsSrv",
		MethodName: "UpdateOrderSets",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '����ײͱ���ʧ��', 'error');
		} else {
			$.messager.popover({msg:'����ײͱ���ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOrderSetsEdit').close();
			LoadGridPEOrderSets();
		}
	})
}

//������-Open����
function winPEOrderSetsEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winPEOrderSetsEdit').open();
}

function InitWinPEOrderSetsEdit(){
	//��ʼ���༭��
	$('#winPEOrderSetsEdit').dialog({
		title: '����ײͱ༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOrderSetsEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOrderSetsEdit').close();
			}
		}]
	});
}

function LoadGridPEOrderSets(){
	$('#gridPEOrderSets').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.OrderSetsSrv",
		QueryName:"QryOrderSets",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOrderSets').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOrderSets(){
    // ��ʼ��DataGrid
    $('#gridPEOrderSets').datagrid({
		fit: true,
		//title: "����ײ��б�",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //���Ϊfalse�������������ʾ���������
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			//,{ field:'Code', width: 80, title:'�ײͱ���', sortable: true, resizable: true}
			,{ field:'Desc', width: 180, title:'�ײ�����', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'����', sortable: true, resizable: true}
			,{ field:'Price', width: 80, title:'�ײͶ���', sortable: true, resizable: true}
			,{ field:'VIPLevel', width: 70, title:'VIP�ȼ�', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'DeitDesc', width: 50, title:'�Ƿ���<br>���', sortable: true, resizable: true}
			,{ field:'BreakDesc', width: 50, title:'�Ƿ�<br>���', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'DateBegin', width: 90, title:'��Ч��<br>ʼ����', sortable: true, resizable: true}
			,{ field:'DateEnd', width: 90, title:'��Ч��<br>ֹ����', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'��������', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate").linkbutton("enable");
				}
				LoadGridPEOrderSetsDtl(); //��������ײ���Ŀ�б�
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOrderSetsEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ
			$("#btnUpdate").linkbutton("disable");
			LoadGridPEOrderSetsDtl(); //��������ײ���Ŀ�б�
        }
    });
}

//������-�������
function winPEOrderSetsDtlEdit_btnSave_click(){
	var ID = Public_layer_ID2;
    var Sort = Common_GetValue("txtDtlSort");
    var Active = (Common_GetValue("chkDtlActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OrderSetsSrv",
		MethodName: "UpdateOrderSetsDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '����ײ���Ŀ����ʧ��', 'error');
		} else {
			$.messager.popover({msg:'����ײ���Ŀ����ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOrderSetsDtlEdit').close();
			LoadGridPEOrderSetsDtl();
		}
	})
}

//������-Open����
function winPEOrderSetsDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID2 = rd['ID'];
		Common_SetValue('txtDtlItemDesc',rd['ItemDesc']);
		Common_SetValue('txtDtlItemCatDesc',rd['ItemCatDesc']);
		Common_SetValue('txtDtlSort',rd['Sort']);
		Common_SetValue('chkDtlActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID2 = "";
		Common_SetValue('txtDtlItemCatDesc','');
		Common_SetValue('txtDtlItemDesc','');
		Common_SetValue('txtDtlSort','');
		Common_SetValue('chkDtlActive',0);
	}
	$HUI.dialog('#winPEOrderSetsDtlEdit').open();
}

function InitWinPEOrderSetsDtlEdit(){
	//��ʼ���༭��
	$('#winPEOrderSetsDtlEdit').dialog({
		title: '����ײ���Ŀ�༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOrderSetsDtlEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOrderSetsDtlEdit').close();
			}
		}]
	});
}

function LoadGridPEOrderSetsDtl(){
	$('#gridPEOrderSetsDtl').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.OrderSetsSrv",
		QueryName:"QryOrderSetsDtl",
		aOrderSetsId: $('#gridPEOrderSets_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOrderSetsDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOrderSetsDtl(){
    // ��ʼ��DataGrid
    $('#gridPEOrderSetsDtl').datagrid({
		fit: true,
		//title: "����ײ���Ŀ�б�",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //���Ϊfalse�������������ʾ���������
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			,{ field:'ItemDesc', width: 180, title:'�����Ŀ', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 150, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'��������', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate2").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate2").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOrderSetsDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch2 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ
			$("#btnUpdate2").linkbutton("disable");
        }
    });
}