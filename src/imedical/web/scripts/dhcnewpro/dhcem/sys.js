///CreatDate:  2016-06-07
///Author:    huaxiaoying 
var SAtypeID="";//全局变量：产品功能授权表(孙表)的类型id
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
	
	//标识绑定回车事件
     $('#SYGroupName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
   
   
});

///csp中孙表类型值调用
function fillValue(rowIndex, rowData){
	$('#datagrid2').datagrid('getRows')[editIndex]['SAPointer']=rowData.id
}

///新增行 产品表(父表) 
function addRowSys(){
	commonAddRow({'datagrid':'#datagrid',value:{'SYActiveFlag':'Y','SYHospDr':'2'}})
}
///双击编辑 产品表(父表) 
function onClickRowSys(index,row){
	CommonRowClick(index,row,"#datagrid");
	$("#Hosp").attr("formatter",row.SYHospDr.HOSPDesc);
}
///保存 产品表(父表) 
function saveSys(){
	saveByDataGrid("web.DHCEMSys","SaveSys","#datagrid",function(data){
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

///删除 产品表(父表) 
function cancelSys(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSys","RemoveSys",{'Id':row.ID},function(data){ 
		 $('#datagrid').datagrid('load');
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///新增行 产品功能表(子表) 
function addRowSysItm(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品表');
		return;
	 }
	 var row =$("#datagrid").datagrid('getSelected');
	 SAId=row.ID; ///父id  
	 
	commonAddRow({'datagrid':'#datagrid1',value:{'SYRemark':' ','SYParRefDr':SAId}})
}
///双击编辑 产品功能表(子表)
function onClickRowSysItm(index,row){
	CommonRowClick(index,row,"#datagrid1");
}
///保存 产品功能表(子表)
function saveSysItm(){
	saveByDataGrid("web.DHCEMSysItm","SaveSysItm","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid1").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid1").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

///删除 产品功能表(子表)
function cancelSysItm(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItm","RemoveSysItm",{'Id':row.ID},function(data){ 
		 $('#datagrid1').datagrid('load');
		 $('#datagrid2').datagrid('load');
		  })
    }    
}); 
}

///新增行 产品功能授权表(孙表)
function addRowSysItmAut(){
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 产品功能表');
		return;
	 }
	var row =$("#datagrid1").datagrid('getSelected');
	SAid=row.ID; ///子表id
	  
	commonAddRow({'datagrid':'#datagrid2',value:{'SAType':'G','SAHospDr':'2','SAParRefDr':SAid}})
	//SAtypeID="G";

}

///双击编辑 产品功能授权表(孙表)
function onClickRowAut(index,row){
	CommonRowClick(index,row,"#datagrid2");
	$("#Hosp1").attr("formatter",row.SAHospDr.HOSPDesc);
	SAtypeID=row.SAType
	var rowIndex=$('#datagrid2').datagrid('getRowIndex',$('#datagrid2').datagrid('getSelected'))
	var varEditor = $('#datagrid2').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });
	
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSysItmAut&MethodName=ListGroup&type='+SAtypeID
	})
	
	
		
}
///保存 产品功能授权表(孙表)
function saveSysItmAut(){
	saveByDataGrid("web.DHCEMSysItmAut","SaveSysItmAut","#datagrid2",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid2").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid2").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

///删除 产品功能授权表(孙表)
function cancelSysItmAut(){
	
	if ($("#datagrid2").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid2").datagrid('getSelected');     
		 runClassMethod("web.DHCEMSysItmAut","RemoveSysItmAut",{'Id':row.ID},function(data){ $('#datagrid2').datagrid('load'); })
    }    
}); 
}
