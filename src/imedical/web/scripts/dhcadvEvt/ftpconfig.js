var dgrow=0;
var HospDr="";
$(function(){ 
    //��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
    InitHosp(); 
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
});
function InitDefault(){ 
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
	findftplist();    ///���ò�ѯ
}
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvFTPConfig"); 
	HospDr=hospComp.getValue();
	//hospComp.setValue("ȫ��"); 
	//$HUI.combogrid('#_HospList',{value:"11"})
	hospComp.options().onSelect = function(){///ѡ���¼�
 		HospDr=hospComp.getValue();
 		findftplist();    ///���ò�ѯ
	}
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	dgrow=index;
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{hospDr:HospDr,hospDrID:HospDr}}) //hxy 2019-07-03 LgHospID
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
function delRow(){
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
	var params=code+"^"+desc;
	$('#datagrid').datagrid('load',{params:params,HospID:HospDr}); 	
}	 
