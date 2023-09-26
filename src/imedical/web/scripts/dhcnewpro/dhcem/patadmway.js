///CreatDate:  2016-05-12
///Author:    huaxiaoying 
$(function(){ 
	//同时给代码和描述绑定回车事件
    $('#PAWCode,#PAWDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        query(); //hxy 2020-05-13 st
            //commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询 //ed
        }
    });
    
    hospComp = GenHospComp("DHC_EmPatAdmWay");  //hxy 2020-05-13 st
    query(); //初始化默认查询
	hospComp.options().onSelect = function(){///选中事件
		query();
	}//ed
});

function addRow(){
	var HospDr=hospComp.getValue();
	commonAddRow({'datagrid':'#datagrid',value:{'PAWActiveFlag':'Y','PAWHospDr':HospDr,'HospDr':HospDr}}) //hxy 2020-05-13 HospDr
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMPatAdmWay","SavePatAdmWay","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload') 
			}else if(data==-11){ //hxy 2020-05-24 st
				$.messager.alert("提示","没有开启医院级授权!"); 
				$("#datagrid").datagrid('reload') //ed
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


