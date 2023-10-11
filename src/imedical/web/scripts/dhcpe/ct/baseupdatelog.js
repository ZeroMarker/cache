/*
 * FileName: dhcpe/ct/baseupdatelog.js
 * Author: xy
 * Date: 2021-08-19
 * Description: �����������־��ѯ
 */
 
 $(function(){
	 
	 //��ʼ�� ��־Grid		
	 InitUpdatelogGrid();
	 
	//��ѯ
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
 
 
 //��ѯ
  function BFind_click(){
	 $('#UpdatelogGrid').datagrid('load',{
			ClassName:"web.DHCPE.CT.BaseLog",
			QueryName:"FindUpdateLog",
			TabName:$("#TabCode").val(), 
			ClsName:$("#ClsCode").val()
			
	});	
	 
 }
 
 
 //��ʼ�� ��־Grid	
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
	{field:'TTableCode',title:'����',width: 180},
	{field:'TTableDesc',title:'�����',width: 150},
	{field:'TRecordID',title:'����ID',width: 80},
	{field:'TStatus',title:'����״̬',width: 80},
	{field:'TOldRecord',title:'ԭʼ��¼',width: 400},
	{field:'TNewRecord',title:'�¼�¼',width: 400},
 	{field:'TUpdateDate',title:'��������',width: 110},
	{field:'TUpdateTime',title:'����ʱ��',width: 110},
	{field:'TUpdateUser',title:'������',width: 110}
	
]]