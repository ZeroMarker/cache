///CreatDate:  2017-10-25
///Author:    yangyongtao
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#SDICode,#SDIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-21 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ //ed
        }
    });
    hospComp = GenHospComp("DHC_EmSpecDise");  //hxy 2020-05-21 st
    query(); //��ʼ��Ĭ�ϲ�ѯ
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed

});

function addRow(){
	var HospDr=hospComp.getValue(); //
	commonAddRow({'datagrid':'#datagrid',value:{'SDIActiveFlag':'Y','SDIHospDr':HospDr,'HospDr':HospDr}}) //hxy 2019-07-26 LgHospID //hxy 2020-05-12 HospDr
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMSpecDise","SaveSpecDise","#datagrid",function(data){
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
		 runClassMethod("web.DHCEMSpecDise","RemoveSpecDise",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSpecDise&MethodName=ListSpecDise&SDICode='+encodeURI($("#SDICode").val())+"&SDIDesc="+encodeURI($("#SDIDesc").val())+"&HospDr="+HospDr
	})
}
function queryReset(){
	//$('#queryForm').form('clear');
	$("#SDICode").val("");
	$("#SDIDesc").val("");
	query();
}


