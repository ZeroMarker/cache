/**
 * FileName: bill.einv.invlogicpath.js
 * Author: ZhaoZW
 * Date: 2019-09-16
 * Description:
 */
//��ں���
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	setElementEvent(); //ҳ���¼���ʼ��
});
//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	initBillIUPGrid(); //��ʼ�����
	initIUPTypeCombo(); //��ʼ������������
	initWinIUPActiveCombo(); //��ʼ���Ƿ�����������
	initwinIUDPrintTypeCombo(); //��ʼ��Ʊ������������
	initwinIUPTypeCombo(); //��ʼ������������
	initwinFactoryCodeCombo(); //��ʼ��������������
}
//ҳ���¼���ʼ��
function setElementEvent(){
	searchDataInfo(); //��ѯ��������
}

////��ѯ��������
function searchDataInfo(){
	$('#IUPSearch').on('click',function(){
		queryBillIUP();
	});
}
//��ʼ��������������
function initwinFactoryCodeCombo(){
	$('#winFactoryCodeCombo').combobox({
		width:157,
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array";
	 		param.Type="EInv_Factory_List"          
	    },
	    onLoadSuccess:function(){
			$('#winFactoryCodeCombo').combobox('setValue',"BS");   
		}
	});
}
//��ʼ������������
function initIUPTypeCombo(){
	$('#IUPTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'', text:'ȫ��', selected:'true'},
			{value:'I', text:'�ӿ�'},
			{value:'T', text:'����'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//��ʼ�����
function initBillIUPGrid() {
	$('#tBillIUP').datagrid({
		fit: true,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: false,
		autoRowHeight: false,
		pageSize:20,
		showFooter: true,
		loadMsg: 'Loading...',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageList: [20,40,60],  
		url:$URL,
		queryParams: {
			ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
			QueryName:"QueryBillIUPInfo"
		},
		columns:[[    
        	{field:'ID',title:'ID',hidden:true},    
        	{field:'IUPType',title:'�ӿ�/����',align:'left',halign:'center',width:110,
        		formatter: function(value){
					if(value == "I"){
						return '�ӿ�'
					}else{
						return '����'	
					}
				}
			},    
        	{field:'IUPCode',title:'�ӿڴ���',align:'left',halign:'center',width:130}, 
        	{field:'IUPDesc',title:'�ӿ�����',align:'left',halign:'center',width:150},    
        	{field:'IUPClassName',title:'����',align:'left',halign:'center',width:200},    
        	{field:'IUPMethodName',title:'������',align:'left',halign:'center',width:200},
        	{field:'IUPActive',title:'�Ƿ�����',align:'left',halign:'center',width:130,
        		formatter: function(value){
					if(value == "Y"){
						return '��'
					}else{
						return '��'	
					}
				}
        	},    
        	{field:'IUPReMark',title:'�ӿ�˵��',align:'left',halign:'center',width:200,
        		formatter:function(value){
	        		var abValue = value;
        			if (value.length>=22) {
            			abValue = value.substring(0,13) + "...";
            			var content = '<span href="#" title="' + value + '" class="note">' + abValue + '</span>';
        				return content;
        			}else{
        				return value;
        			}
	        	}
        	},
        	{field:'IUDPrintType',title:'Ʊ������',align:'left',halign:'center',width:130,
        		formatter: function(value){
					if(value == "E"){
						return '����Ʊ��ҵ��'
					}
					if(value == "P"){
						return 'ֽ��Ʊ��ҵ��'	
					}
					if(value == "C"){
						return 'ͨ��'	
					}
				}
        	},
        	{field:'FactoryCode',title:'�����̱���',align:'left',halign:'center',width:130},
        	{field:'FactoryDesc',title:'����������',align:'left',halign:'center',width:130},
        	{field:'XStr1',title:'����1',align:'left',halign:'center',width:130},
        	{field:'XStr2',title:'����2',align:'left',halign:'center',width:130},
        	{field:'XStr3',title:'����3',align:'left',halign:'center',width:130},
        	{field:'XStr4',title:'����4',align:'left',halign:'center',width:130},
        	{field:'XStr5',title:'����5',align:'left',halign:'center',width:130}
    	]],
    	onLoadSuccess:function(){
   			$(".showtip").tooltip({
                onShow: function(){
                    $(this).tooltip('tip').css({
                        width:'300',
                        boxShadow: '1px 1px 3px #292929'
                    });
                }
            });
		},
    	toolbar:[
    		{
	    		text:"���",
	    		iconCls:"icon-add",
	    		handler:addBillIUP
	    	},
	    	{
	    		text:"�޸�",
	    		iconCls:"icon-edit",
	    		handler:editBillIUP
	    	},
	    	{
	    		text:"ɾ��",
	    		iconCls:"icon-remove",
	    		handler:deleteBillIUP
	    	},
	    	{
	    		text:"����",
	    		iconCls:"icon-import",
	    		handler:importBillIUP
	    	}
    	]
	});
}
//�������
function addBillIUP(){
	$('#tBillIUP').datagrid('clearSelections'); //�������ѡ�����
	//ģ̬����
	$('#winBillIUP').dialog({  
		title:'���',
		width:600,
		height:400,
		modal:true,
		iconCls:'icon-add',
		minimizable:false, //�����Ƿ���ʾ��С����ť
		maximizable:false, //�����Ƿ���ʾ��󻯰�ť
		closable:false, //�����Ƿ���ʾ�رհ�ť
		collapsible:false, //�����Ƿ���ʾ���۵���ť
		resizable:true, //�����Ƿ��ܹ��ı䴰�ڴ�С
		buttons:[
			{
				text:'����',
				handler:saveBillIUP
			},{
				text:'ȡ��',
				handler:closeWin
			}
		]
	}).dialog('center'); 
}
//�޸�����
function editBillIUP(){
	var selectedRow=$('#tBillIUP').datagrid('getSelected'); //��ȡѡ����
	if (!selectedRow) {
		$.messager.alert('��Ϣ', '��ѡ����Ҫ�༭����');
		return;
	}else{
		GetBillIUPDetails(selectedRow);
	}
	//ģ̬����
	$('#winBillIUP').dialog({  
		title:'�޸�',
		width:600,
		height:400,
		modal:true,
		iconCls:'icon-edit',
		minimizable:false, //�����Ƿ���ʾ��С����ť
		maximizable:false, //�����Ƿ���ʾ��󻯰�ť
		closable:false, //�����Ƿ���ʾ�رհ�ť
		collapsible:false, //�����Ƿ���ʾ���۵���ť
		resizable:true, //�����Ƿ��ܹ��ı䴰�ڴ�С
		buttons:[
			{
				text:'����',
				handler:saveBillIUP
			},{
				text:'ȡ��',
				handler:closeWin
			}
		]
	}).dialog('center'); 
}
//ɾ������
function deleteBillIUP(){
	var selectedRow = $('#tBillIUP').datagrid('getSelected'); //��ȡѡ����
	if (!selectedRow) {
		$.messager.alert('��Ϣ', '��ѡ����Ҫɾ������');
		return;
	}
	$.messager.confirm('��Ϣ', '��ȷ��Ҫɾ��������¼��', function (r) {
		if (!r) {
			return;
		} else {
			var ID = selectedRow.ID;
			$m({
				ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
				MethodName:"DeleteBillIUPInfo",
				ID:ID
			},function(value){
				if(value.length > 0){
					$.messager.alert('��Ϣ',value);
					loadBillIUPGrid();
				}else{
					$.messager.alert('��Ϣ','�������ڲ���������ϵ����Ա��');
				}
			});
		}
	});
}
//��������
function importBillIUP(){
	var UserDr=UserID;
	var GlobalDataFlg="0";                          	 //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
	var ClassName="BILL.EINV.BL.COM.InvLogicPathCtl";    //���봦������
	var MethodName="ImportInvLogicPathByExcel";          //���봦������
	var ExtStrPam="";                   			     //���ò���()
	ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
}
//��ѯ����
function queryBillIUP(){
	loadBillIUPGrid();	
}
//����DataGrid����
function loadBillIUPGrid(){
	var IUPType = $('#IUPTypeCombo').combobox('getValue');
	var IUPCode = $('#IUPCode').val();
	var IUPDesc = $('#IUPDesc').val();
	$('#tBillIUP').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		QueryName:"QueryBillIUPInfo",
		PIUPType:IUPType,
		PIUPDesc:IUPDesc
	});
}
//��datagridѡ������
function GetBillIUPDetails(selectedRow){
	if ((!selectedRow) || (selectedRow.ID == undefined)){
		return;
	}
	var ID = selectedRow.ID;
	$m({
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		MethodName:"GetBillIUPInfo",
		ID:ID
	},function(value){
		if(value == ""){
			return;
		}
		var rtnAry = value.split('^');
		$('#winIUPTypeCombo').combobox('setValue',rtnAry[0]);
		$('#winIUPCode').val(rtnAry[1]);
		$('#winIUPDesc').val(rtnAry[2]);
		$('#winIUPClassName').val(rtnAry[3]);
		$('#winIUPMethodName').val(rtnAry[4]);
		$('#winIUPActiveCombo').combobox('setValue',rtnAry[5]);
		$('#winIUPReMark').val(rtnAry[6]);
		$('#winIUDPrintTypeCombo').combobox('setValue',rtnAry[7]);
		$('#winXStr1').val(rtnAry[8]);
		$('#winXStr2').val(rtnAry[9]);
		$('#winXStr3').val(rtnAry[10]);
		$('#winXStr4').val(rtnAry[11]);
		$('#winXStr5').val(rtnAry[12]);
		$('#winFactoryCodeCombo').combobox('setValue',rtnAry[13]);
	});
}
//ȡ����ť
function closeWin(){
	$('#winBillIUP').window('close');
	$('#tBillIUP').datagrid('clearSelections'); //�����ѡ��
	clearDialog(); //���Dialog������
}
//���Dialog������
function clearDialog(){
	$('#winIUPTypeCombo').combobox('setValue',"I");
	$('#winIUPCode').val("");
	$('#winIUPDesc').val("");
	$('#winIUPClassName').val("");
	$('#winIUPMethodName').val("");
	$('#winIUPActiveCombo').combobox('setValue',"Y");
	$('#winIUPReMark').val("");
	$('#winIUDPrintTypeCombo').combobox('setValue',"C");
	$('#winFactoryCodeCombo').combobox('setValue',"BS");
	$('#winXStr1').val("");
	$('#winXStr2').val("");
	$('#winXStr3').val("");
	$('#winXStr4').val("");
	$('#winXStr5').val("");
}
//���水ť
function saveBillIUP(){
	var selectedRow = $('#tBillIUP').datagrid('getSelected'); //��ȡѡ����
	var ID = '';
	if (selectedRow){
		ID = selectedRow.ID;
	}
	var IUPType = $('#winIUPTypeCombo').combobox('getValue');
	if ($.trim(IUPType) == ""){
		$('#winIUPTypeCombo').combobox({required: true});
		return;
	}
	var IUPCode = $('#winIUPCode').val();
	if ($.trim(IUPCode) == ""){
		$('#winIUPCode').attr('placeholder', '������ӿڴ���');
		return;
	}
	var IUPDesc = $('#winIUPDesc').val();
	if ($.trim(IUPDesc) == ""){
		$('#winIUPDesc').attr('placeholder', '������ӿ�����');
		return;
	}
	var IUPClassName = $('#winIUPClassName').val();
	if ($.trim(IUPClassName) == ""){
		$('#winIUPClassName').attr('placeholder', '����������');
		return;
	}
	var IUPMethodName = $('#winIUPMethodName').val();
	if ($.trim(IUPMethodName) == ""){
		$('#winIUPMethodName').attr('placeholder', '�����뷽����');
		return;
	}
	var IUPActive = $('#winIUPActiveCombo').combobox('getValue');
	if (IUPActive == ""){
		$('#winIUPActiveCombo').combobox({required: true});
		return;
	}
	var IUPReMark = $('#winIUPReMark').val();
	/*
	if ($.trim(IUPReMark) == ""){
		$('#winIUPReMark').attr('placeholder', '������ӿ�˵��');
		return;
	}
	*/
	var IUDPrintType = $('#winIUDPrintTypeCombo').combobox('getValue'); //Ʊ������
	var FactoryCode = $('#winFactoryCodeCombo').combobox('getValue'); //�����̱��� 
	var FactoryDesc = $('#winFactoryCodeCombo').combobox('getText'); //����������
	var XStr1 = $('#winXStr1').val(); //����1
	var XStr2 = $('#winXStr2').val(); //����2
	var XStr3 = $('#winXStr3').val(); //����3
	var XStr4 = $('#winXStr4').val(); //����4
	var XStr5 = $('#winXStr5').val(); //����5
	var IUPStr=IUPType+"^"+IUPCode+"^"+IUPDesc+"^"+IUPClassName+"^"+IUPMethodName+"^"+IUPActive+"^"+IUPReMark+"^"+IUDPrintType+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+FactoryCode+"^"+FactoryDesc;
	var IUPAry=IUPStr.split('^');
	if(IUPAry.length > 15){
		$.messager.alert('��Ϣ','���ݲ��ܰ���^�ţ�');
		return;
	}
	if(ID == ""){
		saveMethod('SaveBillIUPInfo',IUPStr);
	}else{
		IUPStr=ID+"^"+IUPStr;
		saveMethod('UpdateBillIUPInfo',IUPStr);
	}
}
//��ȡ����
function saveMethod(MethodName,IUPStr){
	$m({
		ClassName:"BILL.EINV.BL.COM.InvLogicPathCtl",
		MethodName:MethodName,
		IUPStr:IUPStr
	},function(value){
		if(value.length > 0){
			$.messager.alert('��Ϣ',value);
			loadBillIUPGrid();
			closeWin();
			return;
		}else{
			$.messager.alert('��Ϣ','�������ڲ���������ϵ����Ա��');
		}
	});
}
//��ʼ������������
function initwinIUPTypeCombo(){
	$('#winIUPTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'I', text:'�ӿ�', selected:'true'},
			{value:'T', text:'����'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//��ʼ���Ƿ�����������
function initWinIUPActiveCombo(){
	$('#winIUPActiveCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'Y', text:'����', selected:'true'},
			{value:'N', text:'ֹͣ'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
//��ʼ��Ʊ������������
function initwinIUDPrintTypeCombo(){
	$('#winIUDPrintTypeCombo').combobox({
		width:157,
		panelHeight: 'auto',
		multiple: false,
		valueField: 'value',
		textField: 'text',
		data: [
			{value:'E', text:'����Ʊ��ҵ��'},
			{value:'P', text:'ֽ��Ʊ��ҵ��'},
			{value:'C', text:'ͨ��', selected:'true'}
		],
		editable: false,
		disabled: false,
		readonly: false
	});
}
