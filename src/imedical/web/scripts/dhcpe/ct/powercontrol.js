
/*
 * FileName: dhcpe/ct/powercontrol.js
 * Author: xy
 * Date: 2021-08-17
 * Description: 表记录授权查询
 */
 var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 
 $(function(){
	
		
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
			BFind_click();
		}
	})
	
	$("#ClsCode").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
			
     });

	$("#TabCode").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
			
     });

	 //初始化 表记录授权Grid		
	 InitPowerControlGrid();
	
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
	 $('#PowerControlGrid').datagrid('load',{
		ClassName:"web.DHCPE.CT.PowerControl",
		QueryName:"FindPowerControlList",
		LocID:$("#LocList").combobox('getValue'),
		TabName:$("#TabCode").val(), 
		ClsName:$("#ClsCode").val(),
		Empower:$("#Empower").checkbox('getValue') ? "Y" : "N",
		EffPower:$("#EffPower").checkbox('getValue') ? "Y" : "N"
			
	});	
	 
 }
 
 //初始化 表记录授权Grid	
 function InitPowerControlGrid()
 {
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	$('#PowerControlGrid').datagrid({
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
		columns: PowerControlColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PowerControl",
			QueryName:"FindPowerControlList",
			LocID:LocID,
			TabName:$("#TabCode").val(), 
			ClsName:$("#ClsCode").val(),
			Empower:$("#Empower").checkbox('getValue') ? "Y" : "N",
			EffPower:$("#EffPower").checkbox('getValue') ? "Y" : "N"
		
		},
		onLoadSuccess: function (data) {
			
		}
	});
 }
 
 
 var PowerControlColumns = [[
 	{field:'TID',title:'ID',hidden: true},
	{field:'TTableCode',title:'表名',width: 180},
	{field:'TTableDesc',title:'表别名',width: 150},
	{field:'TRecordID',title:'数据ID',width: 90},
	{field:'TPowerTypeDesc',title:'授权类型',width: 80},
	{field:'TEffPower',title:'是否有效',width: 70,align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TLocGrpDesc',title:'科室组',width: 120},
	{field:'TEmpower',title:'单独授权',width: 70,align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TLocDesc',title:'科室',width: 120},
 	{field:'TUpdateDate',title:'操作日期',width: 110},
	{field:'TUpdateTime',title:'操作时间',width: 110},
	{field:'TUserName',title:'操作人',width: 120}
]]