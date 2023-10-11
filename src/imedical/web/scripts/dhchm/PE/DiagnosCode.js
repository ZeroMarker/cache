/*
 * FileName: dhchm/PE/DiagnosCode.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-ר�ҽ���ά��
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEDiagnosCode();
	$('#gridPEDiagnosCode').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	
	$('#gridPEDiagnosCode_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEDiagnosCode"),value,Public_gridsearch1);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEDiagnosCode();
	    }
    });
	
    //��ѯ
    $("#btnFind").click(function() {
		LoadGridPEDiagnosCode();
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEDiagnosCode').datagrid('getSelected');
		winPEDiagnosCodeEdit_layer(rd);
    });
	
    //���ʽ
    $("#btnExpress").click(function() {
		var rd = $('#gridPEDiagnosCode').datagrid('getSelected');
		winPEDiagnosExpressView_layer(rd);
    });
	
	//������-��ʼ��
	InitWinPEDiagnosCodeEdit();
	
	//������-���ʽ
	InitWinPEDiagnosExpressView();
})

//������-Open����
function winPEDiagnosExpressView_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
	}else{
		Public_layer_ID = "";
	}
	LoadgridPEDiagnosExpress(Public_layer_ID);
	$HUI.dialog('#winPEDiagnosExpressView').open();
}

function InitWinPEDiagnosExpressView(){
	//��ʼ���б�
	InitgridPEDiagnosExpress();
	//��ʼ���༭��
	$('#winPEDiagnosExpressView').dialog({
		title: 'ר�ҽ�����ʽ',
		iconCls:"icon-w-paper",
		width: 800,
		height: 500,
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEDiagnosExpressView').close();
			}
		}]
	});
}

function LoadgridPEDiagnosExpress(DiagnosDr){
	$cm ({
		ClassName:"HMS.PE.DiagnosSrv",
		QueryName:"QryDiagnosExpress",
		aDiagnosId:DiagnosDr,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiagnosExpress').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitgridPEDiagnosExpress(){
    // ��ʼ��DataGrid
    $('#gridPEDiagnosExpress').datagrid({
		fit: true,
		//title: "ר�ҽ�����ʽ�б�",
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
			,{ field:'PreBracket', width: 40, title:'ǰ��<br>����', sortable: true, resizable: true}
			,{ field:'ItemDtlDesc', width: 80, title:'վ��ϸ��', sortable: true, resizable: true}
			,{ field:'Operator', width: 40, title:'����<br>��', sortable: true, resizable: true}
			,{ field:'Reference', width: 80, title:'�Ƚ�ֵ', sortable: true, resizable: true}
			,{ field:'AfterBracket', width: 40, title:'����<br>����', sortable: true, resizable: true}
			,{ field:'Relation', width: 40, title:'�߼�<br>��ϵ', sortable: true, resizable: true}
			,{ field:'AgeRange', width: 50, title:'����<br>�޶�', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'NoBloodDesc', width: 60, title:'��Ѫ<br>��־', sortable: true, resizable: true}
			,{ field:'Sort', width: 50, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			//,{ field:'UpdateDate', width: 80, title:'��������', sortable: true, resizable: true}
			//,{ field:'UpdateTime', width: 60, title:'����ʱ��', sortable: true, resizable: true}
		]],
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
        }
    });
}

//������-�������
function winPEDiagnosCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.DiagnosSrv",
		MethodName: "UpdateDiagnosCode",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', 'ר�ҽ��鱣��ʧ��', 'error');
		} else {
			$.messager.popover({msg:'ר�ҽ��鱣��ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEDiagnosCodeEdit').close();
			LoadGridPEDiagnosCode();
		}
	})
}

//������-Open����
function winPEDiagnosCodeEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDiagnos',rd['Diagnos']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDiagnos','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winPEDiagnosCodeEdit').open();
}

function InitWinPEDiagnosCodeEdit(){
	//��ʼ���༭��
	$('#winPEDiagnosCodeEdit').dialog({
		title: 'ר�ҽ���༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEDiagnosCodeEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEDiagnosCodeEdit').close();
			}
		}]
	});
}

function LoadGridPEDiagnosCode(){
	$('#gridPEDiagnosCode').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.DiagnosSrv",
		QueryName:"QryDiagnosCode",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiagnosCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEDiagnosCode(){
    // ��ʼ��DataGrid
    $('#gridPEDiagnosCode').datagrid({
		fit: true,
		//title: "��׼վ����Ŀ�����б�",
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
			,{ field:'Code', width: 80, title:'���۴���', sortable: true, resizable: true}
			,{ field:'Diagnos', width: 180, title:'�������', sortable: true, resizable: true}
			,{ field:'Advice', width: 240, title:'ר�ҽ���', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 150, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'����', sortable: true, resizable: true}
			,{ field:'Alias', width: 80, title:'��ƴ', sortable: true, resizable: true}
			,{ field:'IllnessDesc', width: 50, title:'�Ƿ�<br>����', sortable: true, resizable: true}
			,{ field:'CommonIllDesc', width: 50, title:'�Ƿ�<br>������', sortable: true, resizable: true}
			,{ field:'HighRiskDesc', width: 50, title:'��Σ', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'HBVDesc', width: 50, title:'�Ҹ�', sortable: true, resizable: true}
			,{ field:'ClassDesc', width: 70, title:'���鼶��', sortable: true, resizable: true}
			,{ 
				field:'ExpressFlag',
				width:60,
				align:'center',
				title:'���ʽ',
				formatter: function (value, rec, rowIndex) {
					if(value=="1"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 100, title:'��������', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnExpress").linkbutton("disable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					if (rowData["ExpressFlag"] == '1'){
						$("#btnExpress").linkbutton("enable");
					} else {
						$("#btnExpress").linkbutton("disable");
					}
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEDiagnosCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ��bug
			$("#btnExpress").linkbutton("disable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}