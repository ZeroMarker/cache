$(function() {
	hospComp = GenHospComp("Nur_IP_DHCCLSetExec",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getLinkOrderData("","");  
		reloadData();	
	}  ///选中事件	
	
	initUI();
})

///初始化页面
function initUI(){
	getLinkOrderData("","");
	initTable();
	reloadData();
}
// 获取关联医嘱列表
function getLinkOrderData(arcItmDR,arcItmName) {	
	//医嘱类型
	$HUI.combogrid("#linkOrd", {
		panelWidth: 500,
		panelHeight: 330,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'项目名称',width:100},
			{field:'ArcimDR',title:'项目ID',width:30}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	});
}

// 初始化配置项
function initTable(){
	$("#dg").datagrid({
		fit:true,
		columns :[[
	    	{field:'arcimDesc',title:'医嘱项',width:500}, 
	        {field:'oper',title:'操作',align:"center",width:80,formatter:function(value,row,index){
		    	return '<a class="btnCls icon-cancel" href="#" onclick=deleteArcItms(\'' + row.arcimID + '\')></a>';
		    }}    	       
		]],
		singleSelect : true,
		rownumbers:true,
		loadMsg : '加载中..'
	})	
}
function reloadData(){
	$.m({
		ClassName:"web.DHCNurSkinTestList",
		MethodName:"GetPPDConfig",
		HospitalRowId:hospID
	},function(data){
		var data=eval(data);
		$("#dg").datagrid("loadData",data); 
	}) 
}

// 保存设置
function save(){
	var arcimIDs=$("#linkOrd").combogrid("getValues");
	if(arcimIDs.length==0){
	   return $.messager.popover({ msg: "医嘱项不能为空！", type:'alert', style:{top:"100px",left:""}});		
	}
	var rows=$("#dg").datagrid("getRows");
	if(rows.length>0){
		var desc="";
		rows.forEach(function(val){
			var index=arcimIDs.indexOf(val.arcimID);
			if(index>-1){
				desc=desc=="" ? val.arcimDesc : desc+"；"+val.arcimDesc;
				arcimIDs.splice(index,1);	
			}	
		})
		if(desc!=""){
			return $.messager.alert("简单提示", "医嘱项："+desc+"已存在，请勿重复添加！", 'info');
		}
	}
	$.m({
		ClassName:"web.DHCNurSkinTestList",
		MethodName:"InsertPPDConfig",
		arcimID:arcimIDs.join("^"), 
		HospID:hospID
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "保存成功！", type:'success' ,style:{top:"100px",left:""},timeout:3000});
			$("#linkOrd").combogrid("setValues",[]);
			getLinkOrderData("","");
			reloadData();	
		}else{
			$.messager.popover({ msg: result, type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}
// 删除
function deleteArcItms(arcimID){
	$.messager.confirm("简单提示", "确定要删除该配置项吗？", function (r) {
		if (r) {
			$.m({
				ClassName:"web.DHCNurSkinTestList",
				MethodName:"UpdatePPDConfig",
				ppdConfig:arcimID, 
				HospitalRowId:hospID
			},function testget(result){
				if(result == 0){
					$.messager.popover({msg:"删除成功！", type:'success'});			
					reloadData();					
				}else{	
					$.messager.popover({ msg: "删除失败！", type:'error' });	
				}
			}); 			
		}
	});	
}