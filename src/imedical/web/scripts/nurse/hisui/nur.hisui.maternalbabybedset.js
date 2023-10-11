$(function() {
	hospComp = GenHospComp("Nur_IP_DHCBedMaternalBaby",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getLinkWardData("","");    	
		reloadDataGrid();
	}  ///选中事件	
	
	initUI();
})

///初始化页面
function initUI(){
	getLinkWardData("","");
	initTable();
	reloadDataGrid();
}
// 科室列表
function getLinkWardData(wardId,wardDesc){
	$HUI.combogrid("#linkWard", {
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'WardDr',
		textField: 'Ward',
		columns: [[
			{field:'Ward',title:'名称',width:100},
			{field:'WardDr',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.MaternalBabyBedSetting&QueryName=FindWardItem",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(wardDesc){
				param['q']=wardDesc;
				wardDesc=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{CtLocDesc:"",Ward:desc,HospID:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(wardId){
				$(this).combogrid("setValue",wardId);	
				wardId="";
			}	
		}
	});	
}

// 初始化列表
function initTable(){
	$("#dg").datagrid({
		fit:true,
		columns :[[
	    	{field:'tBMBID',title:'ID',width:100},  
	    	{field:'tWardID',title:'WardID',width:100}, 
	    	{field:'tPacWard',title:'病区',width:300}   	       
		]],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex,rowData){
			getLinkWardData(rowData.tWardID,rowData.tPacWard);
		}	
	});
}
function reloadDataGrid(){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.MaternalBabyBedSetting",
		QueryName:"FindBedMaternalBaby",
		HospitalRowId:hospID, 
		rows:99999
	},function(data){
		$("#dg").datagrid('loadData',data); 
	}) 
}

// 保存设置
function saveData(flag){
   	var BMBID="", WardID="", BedTypeID="", LeftOffset="", TopOffset="", IntervalX="", IntervalY="", Width="10", Height="10", BabyIntervalY="", MaxAttachBabies="";
   	var row=$("#dg").datagrid("getSelections");
   	if(flag){ //修改
	   	if(row.length==0){
		   return $.messager.popover({ msg: "请选择要修改的数据！", type:'info', style:{top:"100px",left:""}});		
		}
		BMBID=row[0].tBMBID;	
	}
	WardID=$("#linkWard").combobox("getValue");
	if(WardID==""){
		return $.messager.popover({ msg: "病区不能为空！", type:'alert' ,style:{top:"100px",left:""}});
	}	
	$.m({
		ClassName:"Nur.NIS.Service.Base.MaternalBabyBedSetting",
		MethodName:"SaveMaternalBaby",
		BMBID:BMBID, 
		WardID:WardID, 
		BedTypeID:BedTypeID, 
		LeftOffset:LeftOffset, 
		TopOffset:TopOffset, 
		IntervalX:IntervalX, 
		IntervalY:IntervalY, 
		Width:Width, 
		Height:Height, 
		BabyIntervalY:BabyIntervalY, 
		MaxAttachBabies:MaxAttachBabies
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "保存成功！", type:'success' ,style:{top:"100px",left:""}});
			$("#linkWard").combogrid("setValue","");
			getLinkWardData("",""); 
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: result, type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}
// 删除设置
function delData(){
   	var row=$("#dg").datagrid("getSelections");
   	if(row.length==0){
	   return $.messager.popover({ msg: "请选择要删除的数据！", type:'info' ,style:{top:"100px",left:""}});		
	}
	$.m({
		ClassName:"Nur.NIS.Service.Base.MaternalBabyBedSetting",
		MethodName:"DeleteMaternalBaby",
		BMBID:row[0].tBMBID
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "删除成功！", type:'success' ,style:{top:"100px",left:""}});
			$("#linkWard").combogrid("setValue","");
			getLinkWardData("",""); 
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: "删除失败！", type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}