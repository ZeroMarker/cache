
/*
 * FileName: dhcpe/ct/powercontrol.js
 * Author: xy
 * Date: 2021-08-17
 * Description: ���¼��Ȩ��ѯ
 */
 var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 
 $(function(){
	
		
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//���������б�change
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

	 //��ʼ�� ���¼��ȨGrid		
	 InitPowerControlGrid();
	
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
 
 //��ʼ�� ���¼��ȨGrid	
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
	{field:'TTableCode',title:'����',width: 180},
	{field:'TTableDesc',title:'�����',width: 150},
	{field:'TRecordID',title:'����ID',width: 90},
	{field:'TPowerTypeDesc',title:'��Ȩ����',width: 80},
	{field:'TEffPower',title:'�Ƿ���Ч',width: 70,align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TLocGrpDesc',title:'������',width: 120},
	{field:'TEmpower',title:'������Ȩ',width: 70,align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TLocDesc',title:'����',width: 120},
 	{field:'TUpdateDate',title:'��������',width: 110},
	{field:'TUpdateTime',title:'����ʱ��',width: 110},
	{field:'TUserName',title:'������',width: 120}
]]