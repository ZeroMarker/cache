///CreatDate:  2017-03-10
///Author:    qiaoqingao
$(function(){ 
	$("#info").css("width",$("#toolbar").width()-48); //hxy 2018-10-25
	/*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 $('#queryBTN').on('click',function(){
		 $("#datagrid").datagrid('reload',{hospDrID:$('#hospDrID').combobox('getValue')});
	 }) //hxy ed*/ //hxy 2020-05-26 注释
	 
	 hospComp = GenHospComp("DHC_EmExecBtnSet");  //hxy 2020-05-26 st
     query(); //初始化默认查询
	 hospComp.options().onSelect = function(){///选中事件
		query();
	 }//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	commonAddRow({'datagrid':'#datagrid',value:{'EBSRowID':'','EBSNurSheetCode':'','EBSShowBtn':'','EBSActiveFlag':'Y',EBSHosp:HospDr,'EBSHospDr':HospDr}}) //hxy 2020-05-26 HospID->HospDr
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function save(){
	saveByDataGrid("web.DHCEMExecBtnSet","Save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

function delet(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$("#datagrid").datagrid('getSelected');     
			 	runClassMethod("web.DHCEMExecBtnSet","Delete",{'Id':row.EBSRowID},function(data){ 
			 	$('#datagrid').datagrid('load'); 
			})
	    }    
	}); 
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMExecBtnSet&MethodName=GetExecBtnSetList&hospDrID='+HospDr
	})
}

