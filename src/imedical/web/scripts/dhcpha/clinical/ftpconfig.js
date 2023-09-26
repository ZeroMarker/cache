/** Descript  : FTP��ַ��ά��
 *  Creator   : sufan
 *  CreatDate : 2017-08-21
 */
var editRow = ""; 
$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st ����༭ʱ�ļ���
      password: {//datetimebox������Ҫ�Զ���editor������
         init: function(container, options){
             var input = $('<input style="border:none;width:100%" type="password">').appendTo(container);
             return input
         },
         getValue: function(target){
             return $(target).val();
        },
         setValue: function(target, value){
             $(target).val(value);
         },
         resize: function(target, width){
         }
     }
});  //hxy ed
/// ҳ���ʼ������
function initPageDefault(){
	
	initFTPlist();          /// ��ʼҳ��DataGrid
	initButton();           /// ҳ��Button���¼�	
}

///����״̬�б� 
function initFTPlist(){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"FTPCode",title:'����',width:100,align:'center',editor:textEditor},
		{field:"FTPDesc",title:'����',width:100,align:'center',editor:textEditor},
		{field:"FTPAddressIP",title:'IP��ַ',width:160,align:'center',editor:textEditor},
		{field:"FTPPort",title:'�˿�',width:100,align:'center',editor:textEditor},
		{field:"FTPUserName",title:'�û���',width:100,align:'center',editor:textEditor},
		{field:"FTPPassWord",title:'����',width:100,align:'center',editor:"password", //huaxiaoying 2018-02-06 st
			formatter: function(value,row,index){ return "***";} //ed
        },
		{field:"FTPRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0){ 
                $("#ftplist").datagrid('endEdit', editRow); 
            } 
            $("#ftplist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCPHFTPConfig&MethodName=QueryFTPConfig';
	new ListComponent('ftplist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ����
	$('#insert').bind("click",insertFTPRow);
	
	///  ����
	$('#save').bind("click",saveFTPRow);
	
	///  ɾ��
	$('#delete').bind("click",deleteFTPRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findStatuslist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findftplist(); //���ò�ѯ
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findftplist(); //���ò�ѯ
    }); 
}

/// ��������״̬
function insertFTPRow(){

	if(editRow>="0"){
		$("#ftplist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#ftplist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {FTPRowID:'',FTPCode:'',FTPDesc:'',FTPAddressIP:'',FTPUserName:'',FTPPassWord:'',FTPPort:''}
	});
    
	$("#ftplist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������״̬
function saveFTPRow(){
	
	if(editRow>="0"){
		$("#ftplist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#ftplist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].FTPCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].FTPDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].FTPAddressIP==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��IP��ַΪ�գ�"); 
			return false;
		}
		if(rowsData[i].FTPUserName==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"���û���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].FTPPassWord==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].FTPPort==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�ж˿�Ϊ�գ�"); 
			return false;
		}
		if(isValidIP(rowsData[i].FTPAddressIP)==false){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��IP��ʽ���ԣ����������룡"); 
			return false;
		}
		var tmp=rowsData[i].FTPRowID +"^"+ rowsData[i].FTPCode +"^"+ rowsData[i].FTPDesc +"^"+ rowsData[i].FTPAddressIP +"^"+ rowsData[i].FTPUserName +"^"+ rowsData[i].FTPPassWord +"^"+ rowsData[i].FTPPort;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCPHFTPConfig","SaveFTPConfig",{"params":params},function(jsonString){
		if ((jsonString == "-1")||(jsonString == "-2")){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		$('#ftplist').datagrid('reload'); //���¼���
	});
}
///�ж��Ƿ���ip����
function isValidIP(ip) {
    var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
    return reg.test(ip);
} 
/// ɾ��
function deleteFTPRow(){
	
	var rowsData = $("#ftplist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCPHFTPConfig","DeleteFTPConfig",{"FTPRowID":rowsData.FTPRowID},function(jsonString){
					$('#ftplist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findftplist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#ftplist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
