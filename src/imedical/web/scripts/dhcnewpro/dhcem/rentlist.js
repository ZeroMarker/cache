///CreatDate��   2016-10-26
///Creator��    liyarong
$(function(){ 
	//ͬʱ������������󶨻س��¼�
     $('#RLCode,#RLDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-21 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //���ò�ѯ //ed
        }
    });
    hospComp = GenHospComp("DHC_EmRentList");  //hxy 2020-05-21 st
    query(); //��ʼ��Ĭ�ϲ�ѯ
	hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	}//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-12 st
	commonAddRow({'datagrid':'#datagrid',value:{'RLActiveFlag':'Y','RLHospDr':HospDr}}) //hxy 2019-07-26 LgHospID //hxy 2020-05-12 LgHospID->HospDr
	//commonAddRow({'datagrid':'#datagrid',value:{'RLActiveFlag':'Y','RLHospDr':LgHospID}}) //hxy 2019-07-26 LgHospID//ed
}
//˫���༭
function onClickRow(index,row){

	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMRentList","SaveRentList","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
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
		 runClassMethod("web.DHCEMRentList","RemoveRentList",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMRentList&MethodName=ListRent&RLCode='+encodeURI($("#RLCode").val())+"&RLDesc="+encodeURI($("#RLDesc").val())+"&HospDr="+HospDr
	})
}
function queryReset(){
	//$('#queryForm').form('clear');
	$("#RLCode").val("");
	$("#RLDesc").val("");
	query();
}



