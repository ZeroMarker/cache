/*
 * FileName: dhchm/PE/DiseaseCode.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-��켲��ά��
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEDiseaseCode();
	$('#gridPEDiseaseCode').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	
	$('#gridPEDiseaseCode_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEDiseaseCode"),value,Public_gridsearch1);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEDiseaseCode();
	    }
    });
	
    //��ѯ
    $("#btnFind").click(function() {
		LoadGridPEDiseaseCode();
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEDiseaseCode').datagrid('getSelected');
		winPEDiseaseCodeEdit_layer(rd);
    });
	
    //��������ר�ҽ���
    $("#btnDiagnos").click(function() {
		var rd = $('#gridPEDiseaseCode').datagrid('getSelected');
		winPEDiseaseDiagnosView_layer(rd);
    });
	
	//������-��ʼ��
	InitWinPEDiseaseCodeEdit();
	
	//������-����ר�ҽ���
	InitWinPEDiseaseDiagnosView();
})

//������-Open����
function winPEDiseaseDiagnosView_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
	}else{
		Public_layer_ID = "";
	}
	LoadgridPEDiseaseDiagnos(Public_layer_ID);
	$HUI.dialog('#winPEDiseaseDiagnosView').open();
}

function InitWinPEDiseaseDiagnosView(){
	//��ʼ���б�
	InitgridPEDiseaseDiagnos();
	//��ʼ���༭��
	$('#winPEDiseaseDiagnosView').dialog({
		title: '��켲������ר�ҽ���',
		iconCls:"icon-w-paper",
		width: 400,
		height: 400,
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEDiseaseDiagnosView').close();
			}
		}]
	});
}

function LoadgridPEDiseaseDiagnos(DiseaseDr){
	$cm ({
		ClassName:"HMS.PE.DiseaseSrv",
		QueryName:"QryDiseaseDiagnos",
		aDiseaseId:DiseaseDr,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiseaseDiagnos').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitgridPEDiseaseDiagnos(){
    // ��ʼ��DataGrid
    $('#gridPEDiseaseDiagnos').datagrid({
		fit: true,
		//title: "��������ר�ҽ���",
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
			,{ field:'DiagnosDesc', width: 150, title:'ר�ҽ���', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 70, title:'�Ƿ���Ч', sortable: true, resizable: true}
			//,{ field:'UpdateDate', width: 80, title:'��������', sortable: true, resizable: true}
			//,{ field:'UpdateTime', width: 60, title:'����ʱ��', sortable: true, resizable: true}
		]],
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
        }
    });
}

//������-�������
function winPEDiseaseCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.DiseaseSrv",
		MethodName: "UpdateDiseaseCode",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', '��켲������ʧ��', 'error');
		} else {
			$.messager.popover({msg:'��켲������ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winPEDiseaseCodeEdit').close();
			LoadGridPEDiseaseCode();
		}
	})
}

//������-Open����
function winPEDiseaseCodeEdit_layer(rd){
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
	$HUI.dialog('#winPEDiseaseCodeEdit').open();
}

function InitWinPEDiseaseCodeEdit(){
	//��ʼ���༭��
	$('#winPEDiseaseCodeEdit').dialog({
		title: '��켲���༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winPEDiseaseCodeEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winPEDiseaseCodeEdit').close();
			}
		}]
	});
}

function LoadGridPEDiseaseCode(){
	$('#gridPEDiseaseCode').datagrid('loadData',{ 'total':'0',rows:[]});  //��ʼ������ʾ��¼Ϊ0
	$cm ({
		ClassName:"HMS.PE.DiseaseSrv",
		QueryName:"QryDiseaseCode",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiseaseCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEDiseaseCode(){
    // ��ʼ��DataGrid
    $('#gridPEDiseaseCode').datagrid({
		fit: true,
		//title: "��켲���б�",
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
			,{ field:'Code', width: 80, title:'��������', sortable: true, resizable: true}
			,{ field:'Desc', width: 240, title:'��������', sortable: true, resizable: true}
			,{ field:'Detail', width: 240, title:'��������', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'����', sortable: true, resizable: true}
			,{ field:'Alias', width: 80, title:'��ƴ', sortable: true, resizable: true}
			,{ field:'IllnessDesc', width: 50, title:'�Ƿ�<br>����', sortable: true, resizable: true}
			,{ field:'CommonIllDesc', width: 50, title:'�Ƿ�<br>������', sortable: true, resizable: true}
			,{ field:'ToReportDesc', width: 50, title:'�Ƿ�<br>�ϱ�', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'TypeDesc', width: 100, title:'����', sortable: true, resizable: true}
			,{ 
				field:'DiagnosFlag',
				width:60,
				align:'center',
				title:'����ר<br>�ҽ���',
				formatter: function (value, rec, rowIndex) {
					if(value=="1"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			,{ field:'Sort', width: 100, title:'˳���', sortable: true, resizable: true}
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
					$("#btnDiagnos").linkbutton("disable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					if (rowData["DiagnosFlag"] == '1'){
						$("#btnDiagnos").linkbutton("enable");
					} else {
						$("#btnDiagnos").linkbutton("disable");
					}
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEDiseaseCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ��bug
			$("#btnDiagnos").linkbutton("disable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}