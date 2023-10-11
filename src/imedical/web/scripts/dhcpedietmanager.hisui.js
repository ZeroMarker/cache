
/*
 * FileName:    dhcpedietmanager.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: 客户就餐
 */
 
 $(function(){
	 
	 //下拉列表框
	 InitCombobox();
	
	//初始化列表
	InitDietManagerGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			Update(0);
		}
	});
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
    
	  //清屏
	 $("#BClear").click(function() {	
		BClear_click();		
     });
     
    //就餐
	$("#BDiet").click(function() {	
		BDiet_click();		
     });
	
	//取消就餐
	$("#BCancelDiet").click(function() {	
		BCancelDiet_click();		
     });
     
})



//就餐
function BDiet_click()
{	
	Update("0")
	return false;
}


function Update(Type)  
{
	var selected = $('#DietManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('提示', "请先选择待就餐的人", 'info');
		return;
	}
	
	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	

	var TPEADMID=selected.TPEADM;
	
	if(iRegNo==""){
		var TPEADMID=TPEADMID;
	}else{
		TPEADMID=iRegNo+"^";
	}
	
	if (TPEADMID=="")
	{
		 $.messager.alert("提示","请先选择待就餐的人","info"); 
		return false; 
	}
	
	var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
	
	if(IsDietFlag=="NCanntDiet")
	{
		 $.messager.alert("提示","没有就餐权限","info"); 
		return true;
	}
	else if(IsDietFlag=="NoPerson")
	{
		 $.messager.alert("提示","没有选择就餐人员或者人员没有到达","info"); 
		return false;
	}else if(IsDietFlag=="CanntDiet"){
		$.messager.alert("提示","餐前项目还未检查完,不能吃饭","info");
		return false;
	}else if(IsDietFlag=="HadDiet")
	{
	
		$.messager.confirm("确认", "已经就餐,是否再次就餐？", function(r){
		if (r){
			 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
			 if (ReturnStr=="Success")
			 { 
				$.messager.popover({msg: "就餐成功！", type: "success",timeout: 1000});
				BFind_click();
				return true;
			}
			
			}
		else{
			
		}
		});

		
	}else{
	

		var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
		if (ReturnStr=="Success")
		{ 
	    	$.messager.popover({msg: "就餐成功！", type: "success",timeout: 1000});
        	BFind_click();
			return true;
		}
	
	}
	
	return false;
	
	
}

//取消就餐
function BCancelDiet_click()
{
	CancelDiet("0");
	return false;
}

function CancelDiet(Type)
{
	var selected = $('#DietManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('提示', "请选择待取消就餐的人", 'info');
		return;
	}
	
	
	var TPEADMID=selected.TPEADM;
	var TCount=selected.TCount;
	if (TPEADMID=="")
	{
		$.messager.alert("提示","请选择待取消就餐的人","info");
		return false; 
	}
	
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","CancelDiet",TPEADMID,Type,TCount);	
	if (ReturnStr=="NCancelDiet")
	{ 
		$.messager.alert("提示","不能取消就餐","info");
		return true;
	}
	if (ReturnStr=="Success")
	{ 
	    $.messager.popover({msg: "取消就餐成功！", type: "success",timeout: 1000});
	    
		BFind_click();
		return true;
	}
	if (ReturnStr=="CancelDiet")
	{
		$.messager.confirm("确认", "是否确定取消就餐？", function(r){
		if (r){
				CancelDiet("1");
			}
		});
	}
	
	return false;
}


//查询
function BFind_click() {
	
	
	var CTLocID=session['LOGON.CTLOCID'];
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	var iGroupID=$("#GroupName").combogrid('getValue');
	if (($("#GroupName").combogrid('getValue')==undefined)||($("#GroupName").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iDietFlag="N";
	var DietFlag=$("#DietFlag").checkbox('getValue');
	if(DietFlag){iDietFlag="Y";}  
	  
	$("#DietManagerGrid").datagrid('load',{
		ClassName:"web.DHCPE.DietManager",
		QueryName:"SearchIADMDiet",
		BeginDate:$("#BeginDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		GroupID:iGroupID,
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		RegNo:iRegNo,
		DietFlag:iDietFlag

	});
}

//清屏
function BClear_click()
{
	$("#RegNo").val("");
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#VIPLevel").combobox('select','');
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	BFind_click();
}


function InitDietManagerGrid(){

	$HUI.datagrid("#DietManagerGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.DietManager",
			QueryName:"SearchIADMDiet",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},
		columns:[[       
		    {field:'TPEADM',title:'IADM',hidden: true},
			{field:'TRegNo',width:140,title:'登记号'},
			{field:'TName',width:200,title:'姓名'},	
			{field:'TGroupDesc',width:220,title:'团体名称'},
			{field:'TDate',width:120,title:'就餐日期'},
			{field:'TTime',width:120,title:'就餐时间'},
			{field:'TCount',width:120,title:'就餐次数'},
			{field:'TRegDate',width:120,title:'到达日期'},
			{field:'TVIPDesc',width:100,title:'VIP等级'},
			{field:'TReason',width:240,title:'原因'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			//$("#PAADM").val(rowData.TEpisodeID);
			//$("#ReportStatus").val(rowData.TStatus);
			
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
	
}


function InitCombobox()
{
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	});
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},

		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}			
			
		]]
	});
	
	
}
