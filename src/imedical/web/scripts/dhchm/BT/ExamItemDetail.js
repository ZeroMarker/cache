/*
 * FileName: dhchm/BT/ExamItemDetail.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: ֪ʶ��ά��-��׼վ��ϸ��
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
    InitGridBTExamItemDetail();
	$('#gridBTExamItemDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	LoadGridBTExamItemDetail();
	
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
		}
	});
	
    //����
    $("#btnAdd").click(function() {  
        winBTExamItemDetailEdit_layer("");
    });
	
    //�޸�
    $("#btnUpdate").click(function() {
		var rd = $('#gridBTExamItemDetail').datagrid('getSelected');
		winBTExamItemDetailEdit_layer(rd);
    });
	
	//������-��ʼ��
	InitWinBTExamItemDetailEdit();
})

//������-�������
function winBTExamItemDetailEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Desc = Common_GetValue("txtDesc");
    var Desc2 = Common_GetValue("txtDesc2");
    var ItemCatID = Common_GetValue("cboItemCat");
    var BaseType = Common_GetValue("cboBaseType");
    var DataFormat = Common_GetValue("cboDataFormat");
    var Unit = Common_GetValue("txtUnit");
    var Sex = Common_GetValue("cboSex");
    var Express = Common_GetValue("txtExpress");
    var Explain = Common_GetValue("txtExplain");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Desc + "^" + Desc2 + "^" + ItemCatID + "^" + BaseType + "^" + DataFormat + "^" + Unit + "^" + Express + "^" + Explain + "^" + Sex + "^" + Sort + "^" + Active + "^" + session['LOGON.USERID'];
	
	$.m({
		ClassName: "HMS.BT.ExamItemDetail",
		MethodName: "UpdateItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('��ʾ', 'վ��ϸ���ʧ��', 'error');
		} else {
			$.messager.popover({msg:'վ��ϸ���ɹ�',type:'success',timeout: 1000});
			$HUI.dialog('#winBTExamItemDetailEdit').close();
			LoadGridBTExamItemDetail();
		}
	})
}

//������-Open����
function winBTExamItemDetailEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		//Common_SetValue('cboItemCat',rd['ItemCatID'],rd['ItemCatDesc']);
		$("#cboItemCat").combobox('select',rd['ItemCatID']);
		//Common_SetValue('cboBaseType',rd['BaseType'],rd['BaseTypeDesc']);
		$("#cboBaseType").combobox('select',rd['BaseType']);
		//Common_SetValue('cboDataFormat',rd['DataFormat'],rd['DataFormatDesc']);
		$("#cboDataFormat").combobox('select',rd['DataFormat']);
		Common_SetValue('txtUnit',rd['Unit']);
		//Common_SetValue('cboSex',rd['Sex'],rd['SexDesc']);
		$("#cboSex").combobox('select',rd['Sex']);
		Common_SetValue('txtExpress',rd['Express']);
		Common_SetValue('txtExplain',rd['Explain']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('cboItemCat','','');
		Common_SetValue('cboBaseType','','');
		Common_SetValue('cboDataFormat','','');
		Common_SetValue('txtUnit','');
		Common_SetValue('cboSex','','');
		Common_SetValue('txtExpress','');
		Common_SetValue('txtExplain','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winBTExamItemDetailEdit').open();
}

function InitWinBTExamItemDetailEdit(){
	//��ʼ���༭��
	$('#winBTExamItemDetailEdit').dialog({
		title: 'վ��ϸ��༭',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '����',
			handler:function(){
				winBTExamItemDetailEdit_btnSave_click();
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#winBTExamItemDetailEdit').close();
			}
		}]
	});
	//��ʼ�����ؼ���������
	Common_ComboToExamItemCat('cboItemCat');
	Common_ComboToBaseType('cboBaseType');
	Common_ComboToDataFormat('cboDataFormat')
	Common_ComboToSex('cboSex');
}

function LoadGridBTExamItemDetail(){
	$cm ({
		ClassName:"HMS.BT.ExamItemDetail",
		QueryName:"QryItemDtlEdit",
		aActive:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridBTExamItemDetail(){
    // ��ʼ��DataGrid
    $('#gridBTExamItemDetail').datagrid({
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
			,{ field:'Code', width: 100, title:'�ڲ�����', sortable: true, resizable: true}
			,{ field:'Desc', width: 200, title:'ϸ������', sortable: true, resizable: true}
			,{ field:'Desc2', width: 200, title:'����', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 100, title:'��Ŀ����', sortable: true, resizable: true}
			,{ field:'BaseTypeDesc', width: 50, title:'����<br>����', sortable: true, resizable: true}
			,{ field:'DataFormatDesc', width: 60, title:'����<br>��ʽ', sortable: true, resizable: true}
			,{ field:'Unit', width: 80, title:'��λ', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 60, title:'�Ա�', sortable: true, resizable: true}
			,{ field:'Express', width: 150, title:'���㹫ʽ', sortable: true, resizable: true}
			,{ field:'Explain', width: 150, title:'˵��', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'˳���', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'�Ƿ�<br>��Ч', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 100, title:'��������', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'����ʱ��', sortable: true, resizable: true}
			,{ field:'UpdateUser', width: 80, title:'������', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
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
				winBTExamItemDetailEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //�����ѯ������ѯ�󣬷�ҳ��ȥ����ѯ�������޷���ѯ��bug
			$("#btnAdd").linkbutton("enable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}

//����վ����Ŀ����������
function Common_ComboToExamItemCat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		allowNull: true,
		valueField: 'EICRowId',
		textField: 'EICDesc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'HMS.BT.ExamItemCat';
			param.QueryName = 'QueryExamItemCat';
			param.aActive = "1";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //��ʼ���ظ�ֵ
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['EICRowId']);
			}
		}
	});
	return  cbox;
}

//�������ݸ�ʽ������
function Common_ComboToDataFormat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '˵����', Code: 'T' }
			,{ Desc: '��ֵ��', Code: 'N' }
			,{ Desc: '������', Code: 'C' }
			,{ Desc: 'ѡ����', Code: 'S' }
			,{ Desc: '�����ı�', Code: 'A' }
		],
		defaultFilter:0
	});
	return  cbox;
}

//�������ݸ�ʽ������
function Common_ComboToBaseType(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '����', Code: 'L' }
			,{ Desc: '���', Code: 'X' }
			,{ Desc: 'ҩƷ', Code: 'R' }
			,{ Desc: '�Ĳ�', Code: 'M' }
			,{ Desc: '����', Code: 'N' }
		],
		defaultFilter:0
	});
	return  cbox;
}

//�������ݸ�ʽ������
function Common_ComboToSex(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '��', Code: 'M' }
			,{ Desc: 'Ů', Code: 'F' }
			,{ Desc: '����', Code: 'N' }
		],
		defaultFilter:0
	});
	return  cbox;
}