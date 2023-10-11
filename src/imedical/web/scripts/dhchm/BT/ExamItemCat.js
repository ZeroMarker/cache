/*
 * FileName: dhchm/BT/ExamItemCat.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-��׼վ����Ŀ����
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
    InitGridBTExamItemCat();
	$('#gridBTExamItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	LoadGridBTExamItemCat();
	
	$('#gridBTExamItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemCat"),value,Public_gridsearch1);
		}
	});
	
    //����
    $("#btnAdd").click(function() {  
        winBTExamItemCatEdit_layer("");
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridBTExamItemCat').datagrid('getSelected');
		winBTExamItemCatEdit_layer(rd);
    });
	
	//������-��ʼ��
	InitWinBTExamItemCatEdit();
})

//������-�������
function winBTExamItemCatEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Desc = Common_GetValue("txtDesc");
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Desc + "^" + Desc2 + "^" + Sort + "^" + Active + "^" + session['LOGON.USERID'];
	$.m({
		ClassName: "HMS.BT.ExamItemCat",
		MethodName: "UpdateItemCat",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', 'վ����Ŀ���ౣ��ʧ��', 'error');
		} else {
			$.messager.popover({msg:'վ����Ŀ���ౣ��ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winBTExamItemCatEdit').close();
			LoadGridBTExamItemCat();
		}
	})
}

//������-Open����
function winBTExamItemCatEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['EICRowId'];
		Common_SetValue('txtCode',rd['EICCode']);
		Common_SetValue('txtDesc',rd['EICDesc']);
		Common_SetValue('txtDesc2',rd['EICDesc2']);
		Common_SetValue('txtSort',rd['EICSort']);
		Common_SetValue('chkActive',(rd['EICActive']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winBTExamItemCatEdit').open();
}

function InitWinBTExamItemCatEdit(){
	//��ʼ���༭��
	$('#winBTExamItemCatEdit').dialog({
		title: 'վ����Ŀ����༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winBTExamItemCatEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winBTExamItemCatEdit').close();
			}
		}]
	});
}

function LoadGridBTExamItemCat(){
	$cm ({
		ClassName:"HMS.BT.ExamItemCat",
		QueryName:"QueryExamItemCat",
		aActive:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridBTExamItemCat(){
    // ��ʼ��DataGrid
    $('#gridBTExamItemCat').datagrid({
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
            { field:'EICRowId', title:'EICRowId', hidden:true }
			,{ field:'EICCode', width: 100, title:'�ڲ�����', sortable: true, resizable: true}
			,{ field:'EICDesc', width: 150, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'EICDesc2', width: 200, title:'����', sortable: true, resizable: true}
			,{ field:'EICSort', width: 80, title:'˳���', sortable: true, resizable: true}
			,{ field:'EICActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'EICUpdateDate', width: 100, title:'��������', sortable: true, resizable: true}
			,{ field:'EICUpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
			,{ field:'EICUpdateUser', width: 80, title:'������', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["EICRowId"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnAdd").linkbutton("enable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnAdd").linkbutton("disable");
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winBTExamItemCatEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = [];  //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ
			$("#btnAdd").linkbutton("enable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}