///CreatDate：   2016-10-26
///Creator：    liyarong
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#RLCode,#RLDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-21 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询 //ed
        }
    });
    hospComp = GenHospComp("DHC_EmRentList");  //hxy 2020-05-21 st
    query(); //初始化默认查询
	hospComp.options().onSelect = function(){///选中事件
		query();
	}//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-12 st
	commonAddRow({'datagrid':'#datagrid',value:{'RLActiveFlag':'Y','RLHospDr':HospDr}}) //hxy 2019-07-26 LgHospID //hxy 2020-05-12 LgHospID->HospDr
	//commonAddRow({'datagrid':'#datagrid',value:{'RLActiveFlag':'Y','RLHospDr':LgHospID}}) //hxy 2019-07-26 LgHospID//ed
}
//双击编辑
function onClickRow(index,row){

	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMRentList","SaveRentList","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
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



