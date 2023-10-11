/*
 * FileName:	dhcinsu.insuconbdptablelist.js
 * User:		tangzf
 * Date:		2020-06-22
 * Function:	
 * Description: ҽ��������ƽ̨���ö���
 */
var PassWardFlag = 'N';
 $(function () { 
 	//
 	var Insert = tkMakeServerCall("web.INSUDicDataCom","CheckAddINSUConBDPTableList");
	//
	init_dg(); 
	
	// 
	init_wdg(); 
	
	//
	init_QFactor();
	
	//
	init_rQFactor();
	
	//
	$('#r-Find').bind('click',function(){
		loadBDPDataGrid();	
	})
	$('#Find').bind('click',function(){
		loadINSUDataGrid();	
	})
	
});
/*
 * datagrid
 */
function init_wdg(){
	var dgColumns = [[
			{field:'ID',title:'Id',hidden:true},
			{field:'TableName',title:'����'},
			{field:'ClassName',title:'����/����'},
			{field:'TableDesc',title:'����'}
			
		]];
	// ��ʼ��DataGrid
	$('#wdg').datagrid({
		data:{'rows':[],'total':'0'},
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		fitColumns: true,
		onDblClickRow:function(index,rowData){
			checkPassward(index,rowData)	
		},
		frozenColumns:[[
			{
				field: 'Option', title: '����', width: 50
				,formatter:function(value,rowData,index){
					return "<a href='#' onclick='checkPassward("+index+','+JSON.stringify(rowData)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
		]]
	});
		
}
function checkPassward(index,rowData){
	var selectedRow = $('#dg').datagrid('getSelected');
	if(!selectedRow){
		$.messager.alert('��ʾ','����ѡ����ߵ�����','info');
		return;	
	}
	if(selectedRow.cBill1!=""){
		$.messager.confirm('��ʾ',selectedRow.cDesc + '�Ѿ����ڶ��գ��Ƿ�������и�����',function(r1){
			if(r1){
				if(PassWardFlag == "N"){
			    	$.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
						if (r) {
							PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
							if(PassWardFlag=='Y'){ 
								SaveCon(index,rowData,selectedRow)
							}else{
								$.messager.alert('��ʾ','�������!','info')
								return false;
							};
						} else {
							return false;
						}
					})
				}else{
					SaveCon(index,rowData,selectedRow);  
				}		
			}	
		})	
	}else{
		if(PassWardFlag == "N"){
			$.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
				if (r) {
					PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
					if(PassWardFlag=='Y'){ 
						SaveCon(index,rowData,selectedRow)
					}else{
						$.messager.alert('��ʾ','�������!','info')
						return false;
					}; 
				} else {
					return false;
				}
			})
		}else{
			SaveCon(index,rowData,selectedRow);  
		}	
	}
	
	
}
function SaveCon(index,rowData,selectedRow){
	if(!rowData.ClassName){
		$.messager.alert('��ʾ','��������Ϊ��','info')
		return;	
	}
	var rtn = tkMakeServerCall("web.INSUDicDataCom","UpdaDicInfoByJson",'{"INDIDDicBill1":"' + rowData.ClassName + '"}',selectedRow.id);
	if(rtn==0){
		$.messager.alert('��ʾ','����ɹ�','info',function(){
			loadINSUDataGrid();	
		});		
	}
}

/*
 * datagrid
 */
function init_dg(){
	var dgColumns = [[
			{field:'id',hidden:true},
			{field:'cCode',title:'�ֵ����'},
			{field:'cDesc',title:'�ֵ�����'},
			{field:'cBill1',title:'���մ���'},
			/*{field:'cBill2',title:'ҽ������'},*/
		]];
	// ��ʼ��DataGrid
	$('#dg').datagrid({
		data:{'rows':[],'total':'0'},
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		fitColumns: true
	});
		
}

/*
 * �������� ҽ���ֵ�
 */
function loadINSUDataGrid(){
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicINSUBDPTableList',
		type :'INSUConBDPTableList', 
		CodeAndDesc : getValueById('Keywords'),
		ConFlag : getValueById('QFactor')
	}
	loadDataGridStore('dg',QueryParam);
}
/*
 * �������� ��ṹ�Ǽ�
 */
 // RowId As %String, code As %String, desc As %String, table As %String, attribute As %String, datatype As %String, uniteflag As %String, type
function loadBDPDataGrid(){
	var QFactor = getValueById('r-QFactor');
	var tmpTable='';
	var tmpClass='';
	if(QFactor==1){
		tmpClass = getValueById('r-Keywords');	
	}else{
		tmpTable = getValueById('r-Keywords');
	}
    var queryParams = {
	    ClassName : 'web.DHCBL.BDP.BDPTableList',
	    QueryName : 'GetList',
	    RowId : '',
	    code : tmpTable,
	    desc : '',
	    table : tmpClass,
	    attribute : '',
	    datatype : '',
	    uniteflag: '',
	    type : 'ҽ��'
	}	
    loadDataGridStore('wdg',queryParams);
}  
function init_rQFactor(){
	// ��ѯ����
	$('#r-QFactor').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [
	    	{
				Code: '1',
				Desc: '������',
				selected:true
			},{
				Code: '2',
				Desc: '������'
			}]
	}); 	
}
function init_QFactor(){
	// ��ѯ����
	$('#QFactor').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
				Code: 'Y',
				Desc: '�Ѷ���',
				selected:true
			},{
				Code: 'N',
				Desc: 'δ����'
			}]
	}); 	
}
