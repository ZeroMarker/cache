///CreatDate:  2016-05-12
///Author:    huaxiaoying 
$(function(){ 
	//ͬʱ������������󶨻س��¼�
    $('#PAWCode,#PAWDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-13 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ //ed
        }
    });
    
    hospComp = GenHospComp("DHC_EmPatAdmWay");  //hxy 2020-05-13 st
    query(); //��ʼ��Ĭ�ϲ�ѯ
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed
});

function addRow(){
	var HospDr=hospComp.getValue();
	commonAddRow({'datagrid':'#datagrid',value:{'PAWActiveFlag':'Y','PAWHospDr':HospDr,'HospDr':HospDr}}) //hxy 2020-05-13 HospDr
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMPatAdmWay","SavePatAdmWay","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload') 
			}else if(data==-11){ //hxy 2020-05-24 st
				$.messager.alert("��ʾ","û�п���ҽԺ����Ȩ!"); 
				$("#datagrid").datagrid('reload') //ed
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMPatAdmWay","RemovePatAdmWay",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatAdmWay&MethodName=ListPatAdmWay&PAWCode='+encodeURI($("#PAWCode").val())+"&PAWDesc="+encodeURI($("#PAWDesc").val())+"&HospDr="+HospDr
	})
}
function queryReset(){
	//$('#queryForm').form('clear');
	$("#PAWCode").val("");
	$("#PAWDesc").val("");
	query();
}


