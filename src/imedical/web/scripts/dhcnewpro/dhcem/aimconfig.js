///CreatDate:  2016-09-08
///Author:    zhanghailong 
var HospDr="";//全局变量：(父表)的医院id
var SAId=""//全局变量:父表id
var editRowF=0//全局变量：父表双击编辑index 
var editRow=0//全局变量：子表双击编辑index 
$(function(){
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
});

///新增行 (父表) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'AISActiveFlag':'Y','AISHospDr':LgHospID}}) //hxy 2019-07-26 LgHospID
}

///双击编辑 (父表) 
function onClickRowSys(index,row){
	editRowF=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid");
	AISHospDr=row.AISHospDrID
	$("#Hosp").attr("formatter",row.AISHospDr.HOSPDesc);
}
///单击编辑 (父表) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	SAId=row.ID; ///父id
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEmAISItem&MethodName=ListSysItm&SAId='+SAId
	});
	}
	
///保存 (父表) 
function saveSys(){
	saveByDataGrid("web.DHCEmAIS","SaveSys","#datagrid",function(data){
			if(data==0){				
				$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('load')
				$("#datagrid2").datagrid('load')
			}else if(data==10){
				$.messager.alert("提示","项目描述已存在,不能重复保存!"); 
				$("#datagrid").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				$("#datagrid").datagrid('load')
				
			}
		});		
}

///删除 (父表) 
function cancelSys(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEmAIS","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///新增行 (子表) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 父表');
		return;
	 }
	 $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-08
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///父id  
	commonAddRow({'datagrid':'#datagrid1',value:{'AISActiveFlag':'Y','AISParRefDr':SAId}})
}

///双击编辑 (子表)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
    $("#datagrid").datagrid('endEdit', editRowF);//add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}

///单击编辑 (子表)
function ClickRowSysItm(){
	var row =$("#datagrid1").datagrid('getSelected');
	SAItmId=row.ID; ///子表id
	$('#datagrid2').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListSysItmAut&SAItmId='+SAItmId
	});
	}

///保存 (子表)
function saveSysItm(){
	saveByDataGrid("web.DHCEmAISItem","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("提示","保存成功!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","项目描述已存在,不能重复保存!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
			}
		});		
}

///删除 (子表)
function cancelSysItm(){
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEmAISItem","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}