/// huaxiaoying
/// 2016-04-26
/// 医嘱分类关联维护
var HospDrID=""//全局标量 函数库的医院id
$(function(){
   //函数面板初始显示
	$('#CatLib').tree({
		url: LINK_CSP+'?ClassName=web.DHCEMLevFunCat&MethodName=ListCatLibTree', 
		//checkbox:true,
		multiple: true,
		lines:true,
		animate:true,   
		required: true,
		onClick:function(node, checked){
			//alert(node.id);
			if(node.id==1){
				$('#tabs').tabs('select', 0);
				//$('#tabs').tabs('enableTab', 0);          // 启用第二个选项卡面板
                //$('#tabs').tabs('enableTab', 'Tab2');     // 启用标题为Tab2的选项卡面板
            }else{
              
                $('#tabs').tabs('select', 1);
	            }
			 }
	});
	
	/*$('#hospDrID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
	 }) //hxy ed 
	 
	 $('#hospDr').combobox({ //hxy 2019-07-21 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryButton').on('click',function(){
		 commonQuery({'datagrid':'#datagrid1','formid':'#toolbar1'}); //调用查询
	 }) //hxy ed *///hxy 2020-12-25 注释

   
})


///LevFunCat_TAB
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LFCActiveFlag':'Y','LFCHospDr':'2','LFCRemark':''}})
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMLevFunCat","SaveLevFunCat","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
				$("#datagrid1").datagrid('reload')
				$('#CatLib').tree('reload')   
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
		 runClassMethod("web.DHCEMLevFunCat","RemoveLevFunCat",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
		 $('#CatLib').tree('reload')  
    }    
    }); 
}

///LevFunLib_TAB
function addRowLib(){
	commonAddRow({'datagrid':'#datagrid1',value:{'LFLActiveFlag':'Y','LFLHospDr':'2','LFLRemark':''}})
}
//双击编辑
function onClickRowLib(index,row){
	CommonRowClick(index,row,"#datagrid1");
	
	/*if(row.LFLHospDrID!=2){
		HospDrID=row.LFLHospDrID
		var rowIndex=$('#datagrid1').datagrid('getRowIndex',$('#datagrid1').datagrid('getSelected'))
    	rowIndex=rowIndex==-1?0:rowIndex
    	var varEditor = $('#datagrid1').datagrid('getEditor', { index: rowIndex, field: 'LFLCatDr' });
    	//$(varEditor.target).combobox('clear');//清空类型值
    	$(varEditor.target).combobox( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMLevFunLib&MethodName=GetLFLCatDr&type='+HospDrID
    	 })
    	 
    	$(varEditor.target).combobox('select', row.LFLCatDr);
	}*///hxy 2020-12-25 注释
	
}

function saveLib(){
	saveByDataGrid("web.DHCEMLevFunLib","SaveLevFunLib","#datagrid1",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
				$("#datagrid1").datagrid('reload')
				$('#CatLib').tree('reload')  
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid1").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

function cancelLib(){
	
	if ($("#datagrid1").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid1").datagrid('getSelected');     
		 runClassMethod("web.DHCEMLevFunLib","RemoveLevFunLib",{'Id':row.ID},function(data){ $('#datagrid1').datagrid('load'); })
         $('#CatLib').tree('reload')  
    }    
    }); 
}