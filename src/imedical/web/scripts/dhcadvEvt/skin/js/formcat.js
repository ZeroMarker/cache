
$(function(){ 
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
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{hospDr:LgHospID}}) //hxy 2019-07-03 LgHospID
}

function save(){
	saveByDataGrid("web.DHCADVFormCat","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�');
			$("#datagrid").datagrid('reload'); 
		}else{
			if((data=11)||(data=12)){
				$.messager.alert('��ʾ','����ʧ��:��������Ѵ���!')
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		}
		
	});	
}
function back(){
	window.location.href="dhcadv.formname.csp"
}
/// ɾ��
function delCat(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ������!");
		return;	
	}
	
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ��������", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFormCat",
				    "remove",
					{
		 				'id':rowsData.ID
		 			},
		 			function(data){
			 			//�޸�
						if(data==0){
							$.messager.alert('��ʾ','ɾ���ɹ�');
							$("#datagrid").datagrid('reload'); 
						}else{
							if((data=-1)){
								$.messager.alert('��ʾ','ɾ��ʧ��:�������ڱ�ά����ʹ��!')
							}else{
								$.messager.alert('��ʾ','ɾ��ʧ��:'+data)
							}
						}
					},"text");
            } 
    }); 
}
