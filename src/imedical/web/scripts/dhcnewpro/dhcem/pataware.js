///CreatDate:  2016-05-25
///Author:    huaxiaoying 
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#PACode,#PADesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-13 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ //ed
        }
    });
    
    hospComp = GenHospComp("DHC_EmPatAware");  //hxy 2020-05-13 st
    query(); //��ʼ��Ĭ�ϲ�ѯ
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //
	commonAddRow({'datagrid':'#datagrid',value:{'PAActiveFlag':'Y','PAHospDr':HospDr,'HospDr':HospDr}}) //hxy 2020-05-12 HospDr
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMPatAware","SavePatAware","#datagrid",function(data){
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
		 runClassMethod("web.DHCEMPatAware","RemovePatAware",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatAware&MethodName=ListPatAware&PACode='+encodeURI($("#PACode").val())+"&PADesc="+encodeURI($("#PADesc").val())+"&HospDr="+HospDr
	})
}
function queryReset(){
	//$('#queryForm').form('clear');
	$("#PACode").val("");
	$("#PADesc").val("");
	query();
}
