
//��ں���
$(function(){
	setPageLayout(); //����ҳ�沼��
	setElementEvent(); //����Ԫ���¼�
});
//����ҳ�沼��
function setPageLayout(){
	initDicDataTypeCombo(); //��ʼ���ֵ�����������
	initDicDataGridItem();  //��ʼ���ֵ���ϸ�б�
}
//����Ԫ���¼�
function setElementEvent(){
	initSaveBtnEvent(); //��ʼ�����水ť�¼�
	initDeleteBtnEvent(); //��ʼ��ɾ����ť�¼�
	initClearBtnEvent(); //��ʼ����հ�ť�¼�
	initImportBtnEvent(); //��ʼ�����밴ť�¼�
}
//��ʼ���ֵ���ϸ�б�
function initDicDataGridItem(){
	$('#DicList').datagrid({
		pagination:true, // ��ҳ������
		pageSize:5,
    	pageList:[5, 15, 20], 
		singleSelect:true,
		striped:true, // ��ʾ������Ч��
		height: 600,
		rownumbers:true,
		fit:true,
		url:$URL,
		queryParams:{
			ClassName:"BILL.EINV.BL.COM.DicDataCtl",
			QueryName:"QueryDicDataInfo",
			Type:'SYS'
		},
		columns:[[
			{field:'ID',title:'ID',hidden:true},
			{field:'DicType',title:'�ֵ�����',width:150},
			{field:'DicCode',title:'�ֵ����',width:150},
			{field:'DicDesc',title:'�ֵ�����',width:150},
			{field:'DicBill1',title:'�ֵ������Ϣ1',width:100},
			{field:'DicBill2',title:'�ֵ������Ϣ2',width:100},
			{field:'DicDemo',title:'��ע',width:100},
			{field:'XStr1',title:'����1',width:100},
			{field:'XStr2',title:'����2',width:100},
			{field:'XStr3',title:'����3',width:100},
			{field:'XStr4',title:'����4',width:100},
			{field:'XStr5',title:'����5',width:100}
			
		]],
		onClickRow:function(rowIndex, rowData){
			var row = $('#DicList').datagrid('getSelected');
			if(row != null){
				SetInputInfo(row); //��ѡ�е�������¼������ʾ��ҳ����	
			}
		}
	});
}
//��ʼ���ֵ�����������
function initDicDataTypeCombo(){
	$HUI.combobox("#DicType",{
		valueField:'DicCode',
		textField:'DicDesc',
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="BILL.EINV.BL.COM.DicDataCtl";
			param.QueryName='QueryDetComboxInfo';
			param.ResultSetType='Array';
			$("#DicType").combobox('setValue',"SYS");
		},
		onSelect:function(){
			ReloadDicDataGridItem(); //���¼����ֵ��б���Ϣ
			ClearInputInfo();	//��������
		}
	});
}
//��ʼ�����水ť�¼�
function initSaveBtnEvent(){
	$('#UpdateBtn').click(function(){    
        SaveDicDataInfo(); //�����ֵ���Ϣ
    });
} 
//�����ֵ���Ϣ
function SaveDicDataInfo(){
	var DicType = $('#DicType').combobox('getValue') //�ֵ�����
	var DicCode = $('#DicCode').val();		//�ֵ����
	if($.trim(DicCode) == ""){
		$.messager.alert('��ʾ��Ϣ',"�ֵ���벻��Ϊ�գ�");
		return;
	}
	var DicDesc = $('#DicDesc').val();		//�ֵ�����
	var DicBill1 = $('#DicBill1').val();	//���մ���
	var DicBill2 = $('#DicBill2').val();	//��������
	var DicDemo = $('#DicDemo').val();		//��ע
	var XStr1 = $('#XStr1').val();			//��ע1
	var XStr2 = $('#XStr2').val();			//��ע2
	var XStr3 = $('#XStr3').val();			//��ע3
	var XStr4 = $('#XStr4').val();			//��ע4
	var XStr5 = $('#XStr5').val();			//��ע5
	var DataStr = DicType+"^"+DicCode+"^"+DicDesc+"^"+DicBill1+"^"+DicBill2+"^"+DicDemo+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+UserID;
	
	var row = $('#DicList').datagrid('getSelected');
	if(row == null){
		var MethodName="SaveDicdataInfo";
		Save(DataStr,MethodName);
	}else{
		DataStr = row.ID+"^"+DataStr;
		var MethodName="UpdateDicDataInfo";
		Save(DataStr,MethodName); //���ú�̨���淽��
	}
}

//���ú�̨���淽��
function Save(DataStr,MethodName){
	$m({
		ClassName:"BILL.EINV.BL.COM.DicDataCtl",
		MethodName:MethodName,
		DataStr:DataStr
	},function(value){
		if(value.length != 0){
			$.messager.alert('��Ϣ',value);
			ClearInputInfo(); //���ҳ���������Ϣ
			ReloadDicDataGridItem(); //���¼����ֵ��б���Ϣ
		}else{
			$.messager.alert('��Ϣ','����������')
		}
	});
}
//��ʼ��ɾ����ť�¼�
function initDeleteBtnEvent(){
	$('#DeleteBtn').click(function(){    
        DeleteDicDataInfo();  //ɾ���ֵ���Ϣ 
    });
}
//ɾ���ֵ���Ϣ
function DeleteDicDataInfo(){
	var row = $('#DicList').datagrid('getSelected');
	if(row == null){
		$.messager.alert('��ʾ��Ϣ','��ѡ����Ҫɾ������');
		return;
	}
	$.messager.confirm('�Ի���','��ȷ��Ҫɾ��������¼��?',function(r){
		if(r){
			var ID = selectedRow.ID;
			$m({
				ClassName:"BILL.EINV.BL.COM.DicDataCtl",
				MethodName:"DeleteDicDataInfo",
				ID:ID
			},function(value){
				if(value.length != 0){
					$.messager.alert('��Ϣ',value);
					ClearInputInfo(); //���ҳ���������Ϣ
					ReloadDicDataGridItem(); //���¼����ֵ��б���Ϣ
				}else{
					$.messager.alert('��Ϣ','����������')
				}
			});
		}
	});
} 
//��ʼ����հ�ť�¼�
function initClearBtnEvent(){
	$('#clearBtn').click(function(){
		ClearInputInfo();	//���ҳ���������Ϣ
	});
}
//��ʼ�������ֵ���Ϣ��ť�¼�
function initImportBtnEvent(){
	$('#ImportBtn').click(function(){
		var UserDr=UserID;
		var GlobalDataFlg="0";                          //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName="BILL.EINV.BL.COM.DicDataCtl";    //���봦������
		var MethodName="ImportDicdataByExcel";         	//���봦������
		var ExtStrPam="";                   			//���ò���()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
} 
//���¼����ֵ��б���Ϣ
function ReloadDicDataGridItem(){
	var DicType = $('#DicType').combobox('getValue');
	$('#DicList').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.DicDataCtl",
		QueryName:"QueryDicDataInfo",
		Type:DicType
	});
}
//��ѡ�е�������¼������ʾ��ҳ����
function SetInputInfo(row){
	$("#DicType").combobox('setValue',row.DicType); //�����ֵ�����
	$('#DicCode').val(row.DicCode);		//�ֵ����
	$('#DicDesc').val(row.DicDesc);		//�ֵ�����
	$('#DicBill1').val(row.DicBill1);		//���մ���
	$('#DicBill2').val(row.DicBill2);		//��������
	$('#DicDemo').val(row.DicDemo);		//��ע
	$('#XStr1').val(row.XStr1);		//��ע1
	$('#XStr2').val(row.XStr2);		//��ע2
	$('#XStr3').val(row.XStr3);		//��ע3
	$('#XStr4').val(row.XStr4);		//��ע4
	$('#XStr5').val(row.XStr4);		//��ע5
}
// ��������
function ClearInputInfo(){
	$('#DicList').datagrid('clearSelections'); //���ѡ����
	$('#DicCode').val("");		//�ֵ����
	$('#DicDesc').val("");		//�ֵ�����
	$('#DicBill1').val("");		//���մ���
	$('#DicBill2').val("");		//��������
	$('#DicDemo').val("");		//��ע
	$('#XStr1').val("");		//��ע1
	$('#XStr2').val("");		//��ע2
	$('#XStr3').val("");		//��ע3
	$('#XStr4').val("");		//��ע4
	$('#XStr5').val("");		//��ע5
}