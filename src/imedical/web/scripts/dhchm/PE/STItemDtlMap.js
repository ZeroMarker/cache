/*
 * FileName: dhchm/PE/STItemDtlMap.js
 * Author: zhufei
 * Date: 2021-11-10
 * Description: ֪ʶ��ά��-վ��ϸ����չ���ҳ��
 */
var Public_FindType = "";
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
	//$.parser.parse(); // ��������ҳ�� 
	Common_ComboToHospTags("cboHospTags");
	InitGridBTExamItemDetail();
    InitGridPESTItemDtlMap();
	$('#gridPESTItemDtlMap').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridBTExamItemDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	LoadGridBTExamItemDetail();
	
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPESTItemDtlMap_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPESTItemDtlMap"),value,Public_gridsearch2);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			Public_FindType = "";
			LoadGridPESTItemDtlMap();
	    }
    });
	
    //ȫ��
    $("#btnFindAll").click(function() {
		Public_FindType = "";
        LoadGridPESTItemDtlMap();
    });
	
    //δ����
    $("#btnFindNo").click(function() {
		Public_FindType = "N";
        LoadGridPESTItemDtlMap();
    });
	
    //�Ѷ���
    $("#btnFindYes").click(function() {
		Public_FindType = "Y";
        LoadGridPESTItemDtlMap();
    });
	
	//��������ϸ��
    $("#btnFindExpAll").click(function() {
		Public_FindType = "E";
        LoadGridPESTItemDtlMap();
    });
	
	//��������ϸ��
    $("#btnFindExpNo").click(function() {
		Public_FindType = "EN";
        LoadGridPESTItemDtlMap();
    });
	
	//��������ϸ��
    $("#btnFindExpYes").click(function() {
		Public_FindType = "EY";
        LoadGridPESTItemDtlMap();
    });
	
    //ϸ�����
    $("#btnMapping").click(function() {
		btnMapping_click();
    });
	
    //��������
    $("#btnCancel").click(function() {
		btnCancel_click();
    });
	
    //�޸�
    $("#btnEdit").click(function() {
		btnEdit_click();
    });
	
	//������-��ʼ��
	InitWinSTItemDtlEdit();
})

//������-�������
function winSTItemDtlEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Sort + "^" + Active;
	$.m({
		ClassName: "HMS.PE.STItemDtlMap",
		MethodName: "UpdateItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			$.messager.alert('��ʾ', 'վ��ϸ���޸ı���ʧ��', 'error');
		} else {
			$.messager.popover({msg:'վ��ϸ���޸ı���ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winSTItemDtlEdit').close();
			LoadGridPESTItemDtlMap();
		}
	})
}

//������-Open����
function winSTItemDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtItemCat',rd['ItemCatDesc']);
		Common_SetValue('txtItemDtl',rd['ItemDtlDesc']);
		Common_SetValue('txtDataFormat',rd['DataFormat']);
		Common_SetValue('txtExpress',rd['Express']);
		Common_SetValue('txtUnit',rd['Unit']);
		Common_SetValue('txtExplain',rd['Explain']);
		Common_SetValue('txtSex',rd['SexDesc']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtItemCat','');
		Common_SetValue('txtItemDtl','');
		Common_SetValue('txtDataFormat','');
		Common_SetValue('txtExpress','');
		Common_SetValue('txtUnit','');
		Common_SetValue('txtExplain','');
		Common_SetValue('txtSex','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winSTItemDtlEdit').open();
}

function InitWinSTItemDtlEdit(){
	//��ʼ���༭��
	$('#winSTItemDtlEdit').dialog({
		title: 'վ��ϸ��༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winSTItemDtlEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winSTItemDtlEdit').close();
			}
		}]
	});
}

//�޸Ĳ���
function btnEdit_click(){
	var rd = $('#gridPESTItemDtlMap').datagrid('getSelected');
	winSTItemDtlEdit_layer(rd);
}

//ϸ����ղ���
function btnMapping_click(){
    var BTExamItemDtlID = Common_GetValue("gridBTExamItemDetail_ID");
    var PESTItemDtlID = Common_GetValue("gridPESTItemDtlMap_ID");
	if ((!PESTItemDtlID)||(!BTExamItemDtlID)){
		$.messager.alert('��ʾ', "��ѡ�����ϸ��", 'info');
        return;
	}
	var InputStr = PESTItemDtlID+"^"+BTExamItemDtlID;
	$.m({
		ClassName: "HM.PE.STItemDtlMap",
		MethodName: "Mapping",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			$.messager.alert('��ʾ', 'ϸ�����ʧ��', 'error');
		} else {
			$.messager.popover({msg:'ϸ����ճɹ�',type:'success',timeout: 1000});
			LoadGridPESTItemDtlMap();
		}
	})
}

//�������ղ���
function btnCancel_click(){
    var PESTItemDtlID = Common_GetValue("gridPESTItemDtlMap_ID");
	if (!PESTItemDtlID){
		$.messager.alert('��ʾ', "��ѡ�������ռ�¼", 'info');
        return;
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫ�������ռ�¼��", function(r){
		if (r){
			var InputStr = PESTItemDtlID+"^"+"";
			$.m({
				ClassName: "HM.PE.STItemDtlMap",
				MethodName: "Mapping",
				aInputStr:InputStr,
				aDelimiter:"^"
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					$.messager.alert('��ʾ', '��������ʧ��', 'error');
				} else {
					$.messager.popover({msg:'�������ճɹ�',type:'success',timeout: 1000});
					LoadGridPESTItemDtlMap();
				}
			})
		}
	})
}

function LoadGridPESTItemDtlMap(){
	$cm ({
		ClassName:"HMS.PE.STItemDtlMap",
		QueryName:"QrySTItemDtlMap",
		aHospTagID:Common_GetValue("cboHospTags"),
		aAlias:"",
		aIsMapping:Public_FindType,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPESTItemDtlMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function LoadGridBTExamItemDetail(){
	$cm ({
		ClassName:"HMS.BT.ExamItemDetail",
		QueryName:"QryExamItemDtl",
		aAlias:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPESTItemDtlMap(){
    // ��ʼ��DataGrid
    $('#gridPESTItemDtlMap').datagrid({
		fit: true,
		//title: "վ��ϸ���б�",
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
			//,{ field:'XCode', width: 80, title:'�ⲿ��', sortable: true, resizable: true }
			//,{ field:'Code', width: 80, title:'ϸ�����', sortable: true, resizable: true }
			,{ field:'Desc', width: 200, title:'ϸ������', sortable: true, resizable: true }
			,{ field:'ItemCatDesc', width: 100, title:'��Ŀ����', sortable: true, resizable: true }
			,{ field:'ItemDescStr', width: 200, title:'�����Ŀ', sortable: true, resizable: true }
			,{ field:'ItemDtlDesc', width: 200, title:'��׼ϸ��', sortable: true, resizable: true }
			,{ field:'DataFormat', width: 50, title:'����<br>��ʽ', sortable: true, resizable: true }
			,{ field:'Unit', width: 70, title:'��λ', sortable: true, resizable: true }
			,{ field:'Sex', width: 50, title:'�Ա�', sortable: true, resizable: true }
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true }
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true }
			,{ field:'Express', width: 150, title:'���ʽ', sortable: true, resizable: true }
			,{ field:'Explain', width: 150, title:'˵��', sortable: true, resizable: true }
			,{ field:'UpdateDate', width: 100, title:'��������', sortable: true, resizable: true }
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true }
			,{ field:'MappingDate', width: 100, title:'��������', sortable: true, resizable: true }
			,{ field:'MappingTime', width: 80, title:'����ʱ��', sortable: true, resizable: true }
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnEdit").linkbutton("disable");
					$("#btnMapping").linkbutton("disable");
					$("#btnCancel").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnEdit").linkbutton("enable");
					$("#btnMapping").linkbutton("enable");
					$("#btnCancel").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winSTItemDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			$("#btnEdit").linkbutton("disable");
			$("#btnMapping").linkbutton("disable");
			$("#btnCancel").linkbutton("disable");
			//Public_gridsearch2 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ��bug
        }
    });
}

function InitGridBTExamItemDetail(){
    // ��ʼ��DataGrid
    $('#gridBTExamItemDetail').datagrid({
		fit: true,
		//title: "��׼վ��ϸ���б�",
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
			,{ field:'Code', width: 80, title:'ϸ�����', sortable: true, resizable: true }
			,{ field:'Desc', width: 200, title:'ϸ������', sortable: true, resizable: true }
			,{ field:'ItemCatDesc', width: 100, title:'��Ŀ����', sortable: true, resizable: true }
			,{ field:'DataFormat', width: 50, title:'����<br>��ʽ', sortable: true, resizable: true }
			,{ field:'Express', width: 200, title:'���ʽ', sortable: true, resizable: true }
			,{ field:'Unit', width: 80, title:'��λ', sortable: true, resizable: true }
			,{ field:'Explain', width: 200, title:'˵��', sortable: true, resizable: true }
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					
				}
			}
        },
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ��bug
        }
    });
}
