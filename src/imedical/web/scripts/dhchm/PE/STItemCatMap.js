/*
 * FileName: dhchm/PE/STItemCatMap.js
 * Author: yupeng
 * Date: 2021-11-10
 * Description: ֪ʶ��ά��-վ��������
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
    Common_ComboToHospTags("cboHospTags");
    InitGridPESTItemCat();
    InitGridBTExamItemCat();
	$('#gridPESTItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	$('#gridBTExamItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	LoadGridPESTItemCat();
	LoadGridBTExamItemCat();
	
	$('#gridPESTItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPESTItemCat"),value,Public_gridsearch1);
		}
	});
	
	$('#gridBTExamItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridBTExamItemCat"),value,Public_gridsearch2);
		}
	});
	
	//֪ʶ��汾����
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPESTItemCat();
	    }
    });
	
    //��ѯ
    $("#btnFind").click(function() {  
        LoadGridPESTItemCat();
    });
    
    //����
    $("#btnMapping").click(function() {  
        btnMapping_click();      
    });
})

//����
function btnMapping_click(){
    var SICRowId=$("#gridPESTItemCat_ID").val();
    if(SICRowId==""){
        $.messager.alert("��ʾ", "��ѡ��ҽԺ���࣡", "info");
        return false;
    }
    var EICRowId=$("#gridBTExamItemCat_ID").val();
    if(EICRowId==""){
        $.messager.alert("��ʾ", "��ѡ���׼���࣡", "info");
        return false;
    }
    
    $.m({
           ClassName: "HM.PE.STItemCatMap",
           MethodName: "Mapping",
           aInputStr:SICRowId+"^"+EICRowId,
           aDelimiter:"^"
		}, function (rtn) {
			var rtnArr=rtn.split("^");
			if(rtnArr[0]=="-1"){    
				$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');
			}else{
				$.messager.popover({msg:'���ճɹ�',type:'success',timeout: 1000});
			}
     });
     LoadGridPESTItemCat();
}

function LoadGridPESTItemCat(){
	$cm ({
		ClassName:"HMS.PE.STItemCatMap",
        QueryName:"QuerySTItemCatMap",
        HospId:Common_GetValue("cboHospTags"),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPESTItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function LoadGridBTExamItemCat(){
	$cm ({
		ClassName:"HMS.BT.ExamItemCat",
		QueryName:"QueryExamItemCat",
		aActive:"1",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPESTItemCat(){
    // ��ʼ��DataGrid
    $('#gridPESTItemCat').datagrid({
		fit: true,
		//title: "ҽԺվ����Ŀ�����б�",
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
            { field:'SICRowId', title:'SICRowId', hidden:true }
			//,{ field:'SICCode', width: 80, title:'�������', sortable: true, resizable: true}
			,{ field:'SICDesc', width: 150, title:'��������', sortable: true, resizable: true}
			,{ field:'SICType', width: 60, title:'����', sortable: true, resizable: true}
			,{ field:'SICItemCat', width: 150, title:'��׼����', sortable: true, resizable: true}
			,{ field:'SICSort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'SICActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field: 'SICUpdateDate', width: 100, title: '��������' }
			,{ field: 'SICUpdateTime', width: 80, title: '����ʱ��' }
			,{ field: 'SICMappingDate', width: 100, title: '��������' }
			,{ field: 'SICMappingTime', width: 80, title: '����ʱ��'}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["SICRowId"];
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
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ
        }
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
			//,{ field:'EICCode', width: 100, title:'�ڲ�����', sortable: true, resizable: true}
			,{ field:'EICDesc', width: 120, title:'��������', sortable: true, resizable: true}
			,{ field:'EICDesc2', width: 180, title:'����', sortable: true, resizable: true}
			,{ field:'EICSort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'EICActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["EICRowId"];
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
			//Public_gridsearch2 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ
        }
    });
}