/*
ģ��:		������Һ����
��ģ��:		������Һ����-��ҩ���ά��
Creator:	hulihua
CreateDate:	2016-12-16
*/
var PolIdDr=""
var editRow="";			 //��ǰ�༭�к�
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
/// �������tab�б�
var tabsObjArr = [
	{"tabTitle":"ҩƷ��Һ����","tabCsp":"dhcst.piva.drugcat.csp"},
	{"tabTitle":"�����÷�","tabCsp":"dhcst.piva.catlinkuse.csp"},
	{"tabTitle":"Һ����","tabCsp":"dhcst.piva.liquid.csp"}
	];

$(function(){
	///��ʼ��ҳǩ
	InitDefault()		
	///��ʼ����Һ����б�
	InitPIVAcatList();
	///��ʼ�����水ť�¼�
	InitWidListener();
})

/// ��ʼ������Ĭ����Ϣ
function InitDefault(){	
	for(var i=0;i<tabsObjArr.length;i++){
		addTab(tabsObjArr[i].tabTitle, tabsObjArr[i].tabCsp);
	}
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
    $("#tabs").tabs({
	    onSelect:function(title,index){
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,PolIdDr)}});
		}
	});
}

///��ʼ����Һ����б�
function InitPIVAcatList(){
	// ����columns
	var columns=[[
		{field:"PolId",title:'ID',width:20,align:'center',hidden:true},
		{field:"PolDesc",title:'��Һ��������',width:360,align:'center',editor:texteditor}
	]];
	// ����datagrid
	$('#phcpivacatlist').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaCatList',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#phcpivacatlist").datagrid('endEdit', editRow); 
            } 
            $("#phcpivacatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        PolIdDr=rowData.PolId;
			var currTab =$('#tabs').tabs('getSelected'); 
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			$('#tabs').tabs('update', {tab: currTab, options: {content: createFrame(src,PolIdDr)}});
			
	    }
	});
}

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#phcpivacatlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#phcpivacatlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {PolId: '',PolDesc: ''}
	});
            
	$("#phcpivacatlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ����༭��
function saveRow(){
	if(editRow>="0"){
		$("#phcpivacatlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#phcpivacatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PolDesc==null)||(rowsData[i].PolDesc=="")){
			$.messager.alert("��ʾ","��Һ������������Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].PolId +"^"+ rowsData[i].PolDesc;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//��������
	var savetype="1";
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVAOrderLink",params,savetype)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","��Һ��������Ϊ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!');		
		}else{	
			$.messager.alert('��ʾ','���³ɹ�!');		
		}
		$("#phcpivacatlist").datagrid('reload');
	}
}
/// ɾ��
function deleteRow(){
	if ($("#phcpivacatlist").datagrid('getSelections').length != 1) {		
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm("��ʾ", "��Һ����Ϊ��������,��ȷ��ɾ����?", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			var rowsData = $("#phcpivacatlist").datagrid('getSelected'); //ѡ��Ҫɾ������
			if (rowsData != null) {
				if (rowsData.PolId!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVAOrderLink",rowsData.PolId)
					if(data!=""){
						if(data==-1){
							$.messager.alert("��ʾ","û��ѡ����Ҫɾ���ļ�¼!"); 
						}else if(data==-2){	
							$.messager.alert('��ʾ','ɾ��ʧ��!');		
						}else{	
							$.messager.alert('��ʾ','ɾ���ɹ�!');		
						}
						$("#phcpivacatlist").datagrid('reload');
					}
				}else{
				        var rowIndex = $('#phcpivacatlist').datagrid('getRowIndex', rowsData);
         				$('#phcpivacatlist').datagrid('deleteRow', rowIndex);  
				}				
			}
		}
	})
}
/// ���ѡ�
function addTab(tabTitle, tabUrl){

    $('#tabs').tabs('add',{
        title : tabTitle,
        content : createFrame(tabUrl,"")
    });
}

/// �������
function createFrame(tabUrl, PolIdDr){
	tabUrl = tabUrl.split("?")[0];
	var content = '<iframe scrolling="auto" frameborder="0" src="' +tabUrl+ '?polid='+ PolIdDr +'" style="width:100%;height:100%;"></iframe>';
	return content;
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}