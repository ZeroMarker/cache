/**
 *	�����Ŀ���շ�2017-09-27�����ά��
 *	sufan  
**/
var editRow = ""; editTRow = "";textEditor="";

/// ҳ���ʼ������
function initPageDefault(){

	initTestItemList();         ///  ��ʼҳ������Ŀ
	initItemTarList();			///	 ��ʼҳ���շ���Ŀ	
	initBlButton();          	///  ҳ��Button���¼�
	
}

///�����Ŀ�б� 
function initTestItemList(){
	
	///  ����columns
	var columns=[[
		{field:'ATIRowID',title:'ATIRowID',width:100,hidden:true},
		{field:'ATICode',title:'ATICode',width:200,hidden:true},
		{field:'ATIDesc',title:'�����Ŀ',width:300},
		{field:'HospDr',title:'HospDr',width:200,hidden:true},
		{field:"ActiveFlag",title:'ActiveFlag',hidden:true}
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			$('#ItemTarList').datagrid('reload',{TsetItmID:rowData.ATIRowID});
	    }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestLinkTar&MethodName=QueryTestItem&HospID='+LgHospID;
	new ListComponent('ItemList', columns, uniturl, option).Init(); 
}

function initItemTarList()
{
	
	var TaritemEditor={		//������Ϊ�ɱ༭
		type: 'combogrid',	//���ñ༭��ʽ
		options:{
			required : true,
			id : 'ATLRowID',
			fitColumns : true,
			fit : true,//�Զ���С  
			pagination : true,
			panelWidth : 600,
			textField : 'desc',
			mode : 'remote',
			url : 'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
			columns:[[
					{field:'tarId',hidden:true},
					{field:'code',title:'����',width:60},
					{field:'desc',title:'����',width:140},
					{field:'price',title:'�շ���۸�',width:40}
					]],
				onSelect:function(rowIndex, rowData) {
   					fillValue(rowIndex, rowData);
				}		   
			}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'ATLRowID',title:'ATLRowID',width:100,hidden:'true'},
		{field:'ItemDr',title:'�����ĿID',width:200,hidden:'true'},
		{field:'TarID',title:'�շ���ĿID',width:100,hidden:'true',editor:textEditor},
		{field:'TarCode',title:'�շ������',width:100,align:'center',editor:textEditor},
		{field:'TarDesc',title:'�շ�������',width:200,align:'center',editor:TaritemEditor},
		{field:'TarQty',title:'����',width:100,align:'center',editor:textEditor},
		{field:'Price',title:'�۸�',width:100,align:'center',editor:textEditor},
		{field:'StaDate',title:'��ʼ����',width:100,editor:{type:'datebox'},align:'center'},
		{field:"EndDate",title:'��������',width:100,editor:{type:'datebox'},align:'center'},
		{field:"UpdUserName",title:'�����û�',width:100,align:'center'},
		{field:"UpdDate",title:'��������',width:100,align:'center'},
		{field:"UpdTime",title:'����ʱ��',width:100,align:'center'}
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
        onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
        
		    var e = $("#ItemTarList").datagrid('getColumnOption', 'TarCode');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'TarDesc');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'TarQty');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'Price');
			e.editor = {};
			var e = $("#ItemTarList").datagrid('getColumnOption', 'StaDate');
			e.editor = {};
		    	
            if (editRow != ""||editRow == 0){ 
                $("#ItemTarList").datagrid('endEdit', editRow); 
            } 
            $("#ItemTarList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestLinkTar&MethodName=QueryTarByItmID';
	new ListComponent('ItemTarList', columns, uniturl, option).Init(); 
}

///����ȡֵ����
function fillValue(rowIndex, rowObj){

	if (rowObj == null){
		var editors = $('#ItemTarList').datagrid('getEditors', editRow);
		///�����Ŀ
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();  ///���ý��� ��ѡ������
		return;
	}
	if (typeof rowObj.desc != "undefined"){
		
		/// ��Ŀ����
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarDesc'});
		$(ed.target).val(rowObj.desc);
		
		/// ��Ŀcode
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarCode'});		
		$(ed.target).val(rowObj.code);
		
		/// ��Ŀ����ID
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'TarID'});		
		$(ed.target).val(rowObj.tarId);
		
		/// ��Ŀ�۸�
		var ed=$("#ItemTarList").datagrid('getEditor',{index:editRow, field:'Price'});		
		$(ed.target).val(rowObj.price);
	}
}
/// ҳ�� Button ���¼�
function initBlButton(){
	
	///  ���������շ���
	$('#tartb a:contains("�����շ���")').bind("click",insertTarRow);
	
	///  ���������շ���
	$('#tartb a:contains("����")').bind("click",saveTar);
	
	///  ɾ�������շ���
	$('#tartb a:contains("ɾ��")').bind("click",deleteTarRow);
}

/// �����շ���
function insertTarRow(){

	var e = $("#ItemTarList").datagrid('getColumnOption','TarCode');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','Price');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','TarQty');
	e.editor = { type: 'text',options: {required: true}};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','StaDate');
	e.editor = {type:'datebox'};
	
	var e = $("#ItemTarList").datagrid('getColumnOption','TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id : 'ATLRowID',
										fitColumns : true,
										fit : true,//�Զ���С  
										pagination : true,
										panelWidth : 600,
										textField : 'desc',
										mode : 'remote',
										url : 'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
										columns:[[
											{field:'tarId',hidden:true},
											{field:'code',title:'����',width:60},
											{field:'desc',title:'����',width:140},
											{field:'price',title:'�շ���۸�',width:40}
										]],
										onSelect:function(rowIndex, rowData) {
   											fillValue(rowIndex, rowData);
											}		   
										}
									};
	var rowsData = $("#ItemList").datagrid('getSelected'); //ѡ����ߵļ����Ŀ����λ��
	if (rowsData == null){
		$.messager.alert("��ʾ", "��ѡ������Ŀ��");
		return;
	}
	if(editRow>="0"){
		$("#ItemTarList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#ItemTarList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ATLRowID:'',TarDesc:'',ItemDr:rowsData.ATIRowID,TarQty:'1','StaDate':new Date().Format("yyyy-MM-dd")}
	});
	$("#ItemTarList").datagrid('beginEdit', 0);	//�����༭������Ҫ�༭����
	editRow=0;
}

///�����շ���
function saveTar(){
	
	if(editRow>="0"){
		$("#ItemTarList").datagrid('endEdit', editRow);
	}
	var rowsData = $("#ItemTarList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].TarDesc==""){
			$.messager.alert("��ʾ","��༭�������ݣ�"); 
			return false;
		}
		var tmp=rowsData[i].ATLRowID+"^"+rowsData[i].ItemDr+"^"+rowsData[i].TarID+"^"+rowsData[i].TarQty +"^"+ rowsData[i].StaDate +"^"+ rowsData[i].EndDate +"^"+ LgUserID;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTestLinkTar","SaveTestTar",{"params":params},function(jsonString){
		if(jsonString==0){
			//$.messager.alert("��ʾ","����ɹ�!"); 
			$('#ItemTarList').datagrid('reload'); //���¼���
			//$('#ItemList').datagrid('reload'); //���¼���
		}
		if(jsonString==-11){
			$.messager.alert('��ʾ','��ʼʱ����ڽ���ʱ��')
			$('#ItemTarList').datagrid('reload');
		}
		if(jsonString==-12){
			$.messager.alert('��ʾ','�����������ڽ���')
			$('#ItemTarList').datagrid('reload');
		}
	});
}

/// ɾ�������Ŀ,��λѡ����
function deleteTarRow(){

	var rowsData = $("#ItemTarList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTestLinkTar","DelTestTar",{"ATLRowID":rowsData.ATLRowID},function(jsonString){
					$('#ItemTarList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}	 

///����Ǻϼ���,���ܱ༭
function onClickRowDisc(index,row){
	if(row.TarCode=="�ϼ�:") return;
	CommonRowClick(index,row,"#arctardatagrid");
}

//��չ datagrid combogrid ���Ե�editor 2016-07-24
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
})

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
