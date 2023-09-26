var dgrow=0;
$(function(){ 
	$.extend($.fn.datagrid.defaults.editors,{ //huaxiaoying 2018-02-06 st ����༭ʱ�ļ���
	      password: {//datetimebox������Ҫ�Զ���editor������
	         init: function(container, options){
	             var input = $('<input style="border:none;width:100%" type="password">').appendTo(container);
	             //options:{valueField:'value',textField:'text',editable:true}}
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
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	
	$(":radio").click(function(){
   		commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
  	});
  	
  	$('#hospID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	}) //ed
});
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	dgrow=index;
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{hospDr:LgHospDesc,hospDrID:LgHospID}}) //hxy 2019-07-03 LgHospID
}

function save(){
	if(!endEditing("#datagrid")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		if(rowsData[i].FTPRowID==undefined)
		{
		  rowsData[i].FTPRowID=""
		}
		var index = $("#datagrid").datagrid("getRowIndex",rowsData[i]) +1;
		if(isValidIP(rowsData[i].FTPAddressIP)==false){
			$.messager.alert("��ʾ","��"+index+"��IP��ʽ���ԣ����������룡"); 
			return false;
		}
		if(rowsData[i].FTPPassWord==""){
			$.messager.alert("��ʾ","��"+index+"������Ϊ�գ����������룡"); 
			return false;
		}
		var tmp=rowsData[i].FTPRowID +"^"+ rowsData[i].FTPCode +"^"+ rowsData[i].FTPDesc +"^"+ rowsData[i].FTPAddressIP +"^"+ rowsData[i].FTPPort +"^"+ rowsData[i].FTPUserName +"^"+ rowsData[i].FTPPassWord+"^"+ rowsData[i].hospDrID;
		dataList.push(tmp);
	} 
	    var params=dataList.join("$$");
       runClassMethod("web.DHCADVFTPConfig","SaveFTPConfig",{"params":params},function(jsonString){
		if ((jsonString == "-1")||(jsonString == "-2")){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}
		if(jsonString==0)
		{
			$.messager.alert('��ʾ',"����ɹ�")
		}
		$('#datagrid').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function remove(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ������!");
		return;	
	}
	
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ��������", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFTPConfig",
				    "DeleteFTPConfig",
					{
		 				'FTPRowID':rowsData.FTPRowID
		 			},
		 			function(data){
			 			//�޸�
						if(data==0){
							$.messager.alert('��ʾ','ɾ���ɹ�');
							$("#datagrid").datagrid('reload'); 
						}else{
						     $.messager.alert('��ʾ','ɾ��ʧ��:'+data)	
						     }
					},"text");
            } 
    }); 
}
///�ж��Ƿ���ip����
function isValidIP(ip) {
    var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
    return reg.test(ip);
} 
// ��ѯ
function findftplist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var hospID=$('#hospID').combobox("getValue")
	var params=code+"^"+desc;
	//alert(params)
	$('#datagrid').datagrid('load',{params:params,HospID:hospID}); 
}	 
