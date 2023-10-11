/*
 * FileName: OnlineSets.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-���ԤԼ�ײ�ά��
 */
var Public_layer_ID = "";
var Public_layer_ID21 = "";
var Public_layer_ID22 = "";
var Public_layer_ID3 = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];
var Public_gridsearch3 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEOnlineSets();
    InitGridPEOnlineSetsItem();
    InitGridPEOnlineSetsItemDtl();
	$('#gridPEOnlineSets').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridPEOnlineSetsItem').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridPEOnlineSetsItemDtl').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	
	$('#gridPEOnlineSets_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEOnlineSets"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPEOnlineSetsItem_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPEOnlineSetsItem"),value,Public_gridsearch2);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEOnlineSets();
	    }
    });
	
    //��ѯ
    $("#btnFind").click(function() {
		LoadGridPEOnlineSets();
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEOnlineSets').datagrid('getSelected');
		winPEOnlineSetsEdit_layer(rd);
    });
	
    //�޸�
    $("#btnUpdate21").click(function() {
		var rd = $('#gridPEOnlineSetsItem').datagrid('getSelected');
		winPEOnlineSetsCatEdit_layer(rd);
    });
	
    //�޸�
    $("#btnUpdate22").click(function() {
		var rd = $('#gridPEOnlineSetsItem').datagrid('getSelected');
		winPEOnlineSetsItemEdit_layer(rd);
    });
	
    //�޸�
    $("#btnUpdate3").click(function() {
		var rd = $('#gridPEOnlineSetsItemDtl').datagrid('getSelected');
		winPEOnlineSetsItemDtlEdit_layer(rd);
    });
	
	//������-��ʼ��
	InitWinPEOnlineSetsEdit();
	
	//������-��ʼ��
	InitWinPEOnlineSetsCatEdit();
	
	//������-��ʼ��
	InitWinPEOnlineSetsItemEdit();
	
	//������-��ʼ��
	InitWinPEOnlineSetsItemDtlEdit();
})

//������-�������
function winPEOnlineSetsEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSets",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '���ԤԼ�ײͱ���ʧ��', 'error');
		} else {
			$.messager.popover({msg:'���ԤԼ�ײͱ���ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsEdit').close();
			LoadGridPEOnlineSets();
		}
	})
}

//������-Open����
function winPEOnlineSetsEdit_layer(rd){
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
	$HUI.dialog('#winPEOnlineSetsEdit').open();
}

function InitWinPEOnlineSetsEdit(){
	//��ʼ���༭��
	$('#winPEOnlineSetsEdit').dialog({
		title: '���ԤԼ�ײͱ༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOnlineSetsEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSets(){
	$('#gridPEOnlineSets').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSets",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSets').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSets(){
    // ��ʼ��DataGrid
    $('#gridPEOnlineSets').datagrid({
		fit: true,
		//title: "���ԤԼ�ײ��б�",
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
			,{ field:'Desc', width: 150, title:'�ײ�����', sortable: true, resizable: true}
			,{ field:'Price', width: 80, title:'�ײͶ���', sortable: true, resizable: true}
			,{ field:'GIFlagDesc', width: 50, title:'����<br>��־', sortable: true, resizable: true}
			,{ field:'VIPLevel', width: 50, title:'VIP<br>�ȼ�', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'OrdSetsDesc', width: 150, title:'���ԤԼ�ײ�', sortable: true, resizable: true}
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
				LoadGridPEOnlineSetsItem(); //�������ԤԼ�ײ���Ŀ�б�
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch1 = [];
			$("#btnUpdate").linkbutton("disable");
			LoadGridPEOnlineSetsItem(); //�������ԤԼ�ײ���Ŀ�б�
        }
    });
}

//������-�������
function winPEOnlineSetsCatEdit_btnSave_click(){
	var ID = Public_layer_ID21;
    var Sort = Common_GetValue("txtCatSort");
    var Active = (Common_GetValue("chkCatActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsCat",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '���ԤԼ�ײ���Ŀ���ౣ��ʧ��', 'error');
		} else {
			$.messager.popover({msg:'���ԤԼ�ײ���Ŀ���ౣ��ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsCatEdit').close();
			LoadGridPEOnlineSetsItem();
		}
	})
}

//������-Open����
function winPEOnlineSetsCatEdit_layer(rd){
	if(rd){
		Public_layer_ID21 = rd['CatID'];
		Common_SetValue('txtCatDesc',rd['CatDesc']);
		Common_SetValue('txtCatSort',rd['CatSort']);
		Common_SetValue('chkCatActive',(rd['CatActive']=='1'));
	}else{
		Public_layer_ID21 = "";
		Common_SetValue('txtCatDesc','');
		Common_SetValue('txtCatSort','');
		Common_SetValue('chkCatActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsCatEdit').open();
}

function InitWinPEOnlineSetsCatEdit(){
	//��ʼ���༭��
	$('#winPEOnlineSetsCatEdit').dialog({
		title: '���ԤԼ�ײ���Ŀ����༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOnlineSetsCatEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsCatEdit').close();
			}
		}]
	});
}

//������-�������
function winPEOnlineSetsItemEdit_btnSave_click(){
	var ID = Public_layer_ID22;
    var Sort = Common_GetValue("txtItemSort");
    var Active = (Common_GetValue("chkItemActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsItem",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '���ԤԼ�ײ���Ŀ����ʧ��', 'error');
		} else {
			$.messager.popover({msg:'���ԤԼ�ײ���Ŀ����ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsItemEdit').close();
			LoadGridPEOnlineSetsItem();
		}
	})
}

//������-Open����
function winPEOnlineSetsItemEdit_layer(rd){
	if(rd){
		Public_layer_ID22 = rd['ID'];
		Common_SetValue('txtItemDesc',rd['ItemDesc']);
		Common_SetValue('txtItemSort',rd['ItemSort']);
		Common_SetValue('chkItemActive',(rd['ItemActive']=='1'));
	}else{
		Public_layer_ID22 = "";
		Common_SetValue('txtItemDesc','');
		Common_SetValue('txtItemSort','');
		Common_SetValue('chkItemActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsItemEdit').open();
}

function InitWinPEOnlineSetsItemEdit(){
	//��ʼ���༭��
	$('#winPEOnlineSetsItemEdit').dialog({
		title: '���ԤԼ�ײ���Ŀ�༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOnlineSetsItemEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsItemEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSetsItem(){
	$('#gridPEOnlineSetsItem').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSetsItem",
		aOrderSetsId: $('#gridPEOnlineSets_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSetsItem').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSetsItem(){
    // ��ʼ��DataGrid
    $('#gridPEOnlineSetsItem').datagrid({
		fit: true,
		//title: "���ԤԼ�ײ���Ŀ�б�",
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
			,{ field:'CatDesc', width: 100, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'ItemDesc', width: 150, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'SortDesc', width: 60, title:'˳���', sortable: true, resizable: true}
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
					$("#btnUpdate21").linkbutton("disable");
					$("#btnUpdate22").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate21").linkbutton("enable");
					$("#btnUpdate22").linkbutton("enable");
				}
				LoadGridPEOnlineSetsItemDtl(); //�������ԤԼ�ײ�ϸ���б�
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsItemEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch2 = [];
			$("#btnUpdate21").linkbutton("disable");
			$("#btnUpdate22").linkbutton("disable");
			LoadGridPEOnlineSetsItemDtl(); //�������ԤԼ�ײ�ϸ���б�
        }
    });
}

//������-�������
function winPEOnlineSetsItemDtlEdit_btnSave_click(){
	var ID = Public_layer_ID3;
    var Sort = Common_GetValue("txtItemDtlSort");
    var Active = (Common_GetValue("chkItemDtlActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '���ԤԼ�ײ�ϸ���ʧ��', 'error');
		} else {
			$.messager.popover({msg:'���ԤԼ�ײ�ϸ���ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsItemDtlEdit').close();
			LoadGridPEOnlineSetsItemDtl();
		}
	})
}

//������-Open����
function winPEOnlineSetsItemDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID3 = rd['ID'];
		Common_SetValue('txtItemDtlDesc',rd['Desc']);
		Common_SetValue('txtItemDtlSort',rd['Sort']);
		Common_SetValue('chkItemDtlActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID3 = "";
		Common_SetValue('txtItemDtlDesc','');
		Common_SetValue('txtItemDtlSort','');
		Common_SetValue('chkItemDtlActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsItemDtlEdit').open();
}

function InitWinPEOnlineSetsItemDtlEdit(){
	//��ʼ���༭��
	$('#winPEOnlineSetsItemDtlEdit').dialog({
		title: '���ԤԼ�ײ�ϸ��༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEOnlineSetsItemDtlEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsItemDtlEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSetsItemDtl(){
	$('#gridPEOnlineSetsItemDtl').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSetsItemDtl",
		aOrderSetsItemId: $('#gridPEOnlineSetsItem_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSetsItemDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSetsItemDtl(){
    // ��ʼ��DataGrid
    $('#gridPEOnlineSetsItemDtl').datagrid({
		fit: true,
		//title: "���ԤԼ�ײ���Ŀ�б�",
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
			,{ field:'Desc', width: 100, title:'ϸ������', sortable: true, resizable: true}
			,{ field:'Intent', width: 80, title:'��д', sortable: true, resizable: true}
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
					$("#btnUpdate3").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate3").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsItemDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch3 = [];
			$("#btnUpdate3").linkbutton("disable");
        }
    });
}
