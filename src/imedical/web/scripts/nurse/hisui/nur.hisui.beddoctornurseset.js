$(function() {
	hospComp = GenHospComp("Nur_IP_ImedicalStaffOfBed",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
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
	getLinkDocData("","");
	getLinkNurseData();
	initTable();
}
// 病区列表
function getLinkWardData(wardId,wardDesc){
	$HUI.combogrid("#linkWard", {
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'wardid',
		textField: 'warddesc',
		columns: [[
			{field:'warddesc',title:'名称',width:100},
			{field:'wardid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew",
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
			param = $.extend(param,{desc:desc,hospid:$HUI.combogrid('#_HospList').getValue(),bizTable:"Nur_IP_ImedicalStaffOfBed"});
		},
		onLoadSuccess:function(){
			if(wardId){
				$(this).combogrid("setValue",wardId);	
				wardId="";
			}	
		},
		onSelect:function(record){
			getLinkDocData();
			getLinkNurseData();
			reloadDataGrid();
		}
	});	
}
//值班医生列表
function getLinkDocData(id,name){
	$HUI.combogrid("#linkDoctor", {
		panelWidth: 300,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'doctorname',
		columns: [[
			{field:'doctorname',title:'姓名',width:100},
			{field:'rowid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWarddoctor",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(name){
				param['q']=wardDesc;
				name=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{docName:desc,wardid:$HUI.combogrid('#linkWard').getValue()});
		},
		onLoadSuccess:function(){
			if(id){
				$(this).combogrid("setValue",id);	
				id="";
			}	
		}
	});	
}
//值班护士列表
function getLinkNurseData(id,name){
	$HUI.combogrid("#linkNurse", {
		panelWidth: 300,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'nursename',
		columns: [[
			{field:'nursename',title:'姓名',width:100},
			{field:'rowid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardnurse",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(name){
				param['q']=wardDesc;
				name=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{nurName:desc,wardid:$HUI.combogrid('#linkWard').getValue()});
		},
		onLoadSuccess:function(){
			if(id){
				$(this).combogrid("setValue",id);	
				id="";
			}	
		}
	});	
}

// 初始化列表
function initTable(){
	$("#dg").datagrid({
		fit:true,
		columns :[[
			{field:'ck',title:'ck',checkbox:true},  
	    	{field:'床位',title:'床位',width:100},  
	    	{field:'床位ID',title:'床位ID',width:100}, 
	    	{field:'值班医生',title:'值班医生',width:300},
	    	{field:'值班护士',title:'值班护士',width:300}	       
		]],
		loadMsg : '加载中..'	
	});
}
function reloadDataGrid(){
	$("#dg").datagrid("uncheckAll");
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardbed",
		wardid:$HUI.combogrid('#linkWard').getValue(), 
		rows:99999
	},function(data){
		console.log(data);
		$("#dg").datagrid('loadData',data); 
	}) 
}

// 保存设置
function save(flag){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length==0){
	   return $.messager.popover({ msg: "请选择要维护的床位！", type:'info', style:{top:"100px",left:""}});		
	}
	var bedArr=[];
	var docId=$("#linkDoctor").combogrid("getValue");
	var nurseId=$("#linkNurse").combogrid("getValue");
	rows.forEach(function(val){
		var arr=[];
		arr.push(val["床位ID"]);
		arr.push(docId);
		arr.push(nurseId);
		bedArr.push(arr);	
	})
	$.m({
		ClassName:"Nur.NIS.Service.Base.Bed",
		MethodName:"UdateStaffOfBed",
		wardID:rows[0].wardid, 
		rowData:JSON.stringify(bedArr),
		ifUpdateNurse: flag ? flag : ""
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "保存成功！", type:'success' ,style:{top:"100px",left:""}});
			$("#linkDoctor,#linkNurse").combogrid("setValue","");
			getLinkDocData("","");
			getLinkNurseData();
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: result, type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}