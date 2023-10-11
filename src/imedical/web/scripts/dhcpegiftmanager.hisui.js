
/*
 * FileName:    dhcpegiftmanager.hisui.js
 * Author:      xy
 * Date:        20221205
 * Description: 赠品管理
 */
 
 $(function(){
	 
	 //下拉列表框
	 InitCombobox();
	
	//初始化列表
	InitGiftManagerGrid();
	
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
     
    //发放赠品
	$("#BSendGift").click(function() {	
		BSendGift_click();		
     });
	
     
})

//发放赠品
function BSendGift_click()
{	
	var selected = $('#GiftManagerGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('提示', "请选择待发放的人", 'info');
		return;
	}
    
	var TPEADMID=selected.TPEADM;
	if (TPEADMID=="")
	{
		$.messager.alert("提示","请选择待发放的人","info");
		return false;	
	}
	Update("0",TPEADMID);
	return false;
}

function Update(Type,TPEADMID)
{
	var GiftName="";
	var GiftName=$("#GiftName").val();
	if (GiftName=="")
	{
		$.messager.alert("提示","赠品不能为空","info");
		return false;
	}
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateGift",TPEADMID,Type,GiftName);

	if (ReturnStr=="Success")
	{
		$.messager.popover({msg: "赠品发放成功！", type: "success",timeout: 1000});
		BFind_click();
		return true;
	}
	if (ReturnStr=="HadGift")
	{
		$.messager.confirm("确认", "已经发过赠品，是否再次发放？", function(r){
		if (r){
				Update("1",TPEADMID)
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
	
	var iGiftFlag="";
	var GiftFlag=$("#GiftFlag").checkbox('getValue');
	if(GiftFlag){iGiftFlag="1";}  
	  
	var iGiftName=$("#GiftName").val();
	
	$("#GiftManagerGrid").datagrid('load',{
		ClassName:"web.DHCPE.DietManager",
		QueryName:"SearchIADMGift",
		BeginDate:$("#BeginDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		GroupID:iGroupID,
		VIPLevel:$("#VIPLevel").combobox('getValue'),
		RegNo:iRegNo,
		GiftFlag:iGiftFlag,
		GiftName:iGiftName

	});
}

//清屏
function BClear_click()
{
	$("#RegNo,#GiftName").val("");
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#VIPLevel").combobox('select','');
	$("#GroupName").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	BFind_click();
}


function InitGiftManagerGrid(){

	$HUI.datagrid("#GiftManagerGrid",{
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
			QueryName:"SearchIADMGift",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
						
		},
		columns:[[       
		    {field:'TPEADM',title:'IADM',hidden: true},
			{field:'TRegNo',width:140,title:'登记号'},
			{field:'TName',width:180,title:'姓名'},	
			{field:'TGroupDesc',width:200,title:'团体名称'},
			{field:'TDate',width:120,title:'发放日期'},
			{field:'TTime',width:120,title:'发放时间'},
			{field:'TCount',width:120,title:'发放次数'},
			{field:'TRegDate',width:120,title:'到达日期'},
			{field:'TVIPDesc',width:100,title:'VIP等级'},
			{field:'TReason',width:240,title:'赠品'}
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			
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
