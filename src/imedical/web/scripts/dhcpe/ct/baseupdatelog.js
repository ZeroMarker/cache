/*
 * FileName: dhcpe/ct/baseupdatelog.js
 * Author: xy
 * Date: 2021-08-19
 * Description: 基础表更新日志查询
 */
 
 $(function(){
	 
	 //初始化 日志Grid		
	 InitUpdatelogGrid();
	 
	//查询
     $('#BFind').click(function(){
    	BFind_click();
    });
    
    
    $("#TabCode").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
	
	 $("#ClsCode").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
    
 })
 
 
 //查询
  function BFind_click(){
	 $('#UpdatelogGrid').datagrid('load',{
			ClassName:"web.DHCPE.CT.BaseLog",
			QueryName:"FindUpdateLog",
			TabName:$("#TabCode").val(), 
			ClsName:$("#ClsCode").val()
			
	});	
	 
 }
 
 
 //初始化 日志Grid	
 function InitUpdatelogGrid(){
 $('#UpdatelogGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: UpdatelogGridColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.BaseLog",
			QueryName:"FindUpdateLog",
			TabName:$("#TabCode").val(), 
			ClsName:$("#ClsCode").val()
	
		},
		onLoadSuccess: function (data) {
			
		}
	});
 }
 
  var UpdatelogGridColumns = [[
 	{field:'TID',title:'ID',hidden: true},
	{field:'TTableCode',title:'表名',width: 180},
	{field:'TTableDesc',title:'表别名',width: 150},
	{field:'TRecordID',title:'数据ID',width: 80},
	{field:'TStatus',title:'操作状态',width: 80},
	{field:'TOldRecord',title:'原始记录',width: 400},
	{field:'TNewRecord',title:'新记录',width: 400},
 	{field:'TUpdateDate',title:'操作日期',width: 110},
	{field:'TUpdateTime',title:'操作时间',width: 110},
	{field:'TUpdateUser',title:'操作人',width: 110}
	
]]