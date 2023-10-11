var hospComp="",hospID = session['LOGON.HOSPID'],wardID = session['LOGON.WARDID'],locID=session['LOGON.LOCID'],userID=session['LOGON.USERID'];
var setDataGrid,setOrderGrid,setRuleGrid,setCaseGrid;
$(function() {
	hospComp = GenHospComp("Nur_IP_ThresholdConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;     	
    	var tab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex',tab);
		if(index==0){
			reloadDataGrid();
		}else{
			reloadOrderGrid();
			reloadRuleGrid("");
			reloadCaseGrid("");
		}
	}  ///选中事件
	
	initTable();    
    reloadDataGrid();
    
    $('#keyword').bind('keydown',function(event){
        if(event.keyCode == "13"){
         	searchData();
        }
  	});
	
	// 阈值配置新增
	$("#btn-add").click(function(){
		$("#add-dialog").dialog({title:"新增阈值配置"}).dialog("open");
 		//清空表单数据
 		$('#form').form("clear");
 		getFormData("",false);
	});
		
	// 切换页签
	var ruleTabLoadFlag=false;
	$HUI.tabs("#tabs",
	{
		onSelect:function(title,index){
			if(index==0){
				reloadDataGrid();
			}else{
				if(!ruleTabLoadFlag){
					initRuleTab();
					ruleTabLoadFlag=true;
				}
				reloadOrderGrid();
				reloadRuleGrid("");
				reloadCaseGrid("");				
			}
		}
	});
})

// 初始化table
function initTable(){
    var setColumns = [[
    	{field:'tableName',title:'表单名称',width:260},  
    	{field:'scoreField',title:'分值字段',width:120}, 
    	{field:'validLocs',title:'生效科室',width:260,formatter:function(value,row,index){
	    	return value=="" ? "全院" : value.substr(1,value.length);
	    }},   
    	{field:'code',title:'编码',width:120},
    	{field:'expression',title:'阈值表达式',width:300},
    	{field:'desc',title:'阈值描述',width:300}
	]];
	setDataGrid = $('#thresholdGrid').datagrid({
		fit : true,
		columns :setColumns,
		rownumbers:true,
		toolbar:"#toolbar",
		pagination : true,  //是否分页
		pageSize: 15,
		pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '加载中..' 
	});  
}

// 阈值配置查询
function searchData(){
	var tab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',tab);
	if(index==0){
		var keyword=$.trim($("#keyword").val());
		reloadDataGrid(keyword)
	}else{
		reloadOrderGrid();
	}    
}

// 列表数据加载
function reloadDataGrid(keyword)
{
	$.cm({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		QueryName:"GetThresholdList",
		hospDR:hospID,
		keyword:keyword,
		rows:99999
	},function(data){
		setDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})
};

// 获取表单名称列表
function getFormData(guid,mult) {
    $cm({
        ClassName: "NurMp.NursingRecordsChart",
        QueryName: "GetAssessItems",
        keyword: "",
        loc: locID,
        Hospital:hospID,
        rows:99999
    },function (obj) {
        $HUI.combobox(".formSel", {
            valueField: "id",
            textField: "desc",
            multiple: mult,
            selectOnNavigation: false,
            // panelHeight: "210",
            editable: true,
            data: obj.rows,
            onLoadSuccess: function(data){
                if(guid){
	                if(mult){
		            	$(this).combobox('setValues', guid.split("^"));   
		            }else{
			            $(this).combobox('setValue', guid);
			        }	            	     
	            }
            }
        });
    });
}

// 修改选中的阈值配置数据时，数据回显
function updateData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog({title:"修改阈值配置"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//清空表单数据
 		$('#form').form("clear");
	 	$('#form').form("load",{
	 		Rowid: rows[0].rowid,
	 		ScoreField: rows[0].scoreField,
	 		Code: rows[0].code,
	 		Expression: rows[0].expression,
	 		Desc: rows[0].desc		
 		}); 			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的配置数据", "info");
 	}
}

// 复制选中的阈值配置数据
function copyData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog({title:"复制阈值配置"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//清空表单数据
 		$('#form').form("clear");
	 	$('#form').form("load",{
	 		ScoreField: rows[0].scoreField,
	 		Code: rows[0].code,
	 		Expression: rows[0].expression,
	 		Desc: rows[0].desc		
 		}); 			
 	}else{
    	$.messager.alert("简单提示", "请选择要复制的配置数据", "info");
 	}
}

// 新增/修改选中的阈值配置数据
function saveData(){
	var rowid=$.trim($("#rowid").val());
	var tableNameDR=$("#name").combobox('getValue');
	var scoreField=$.trim($("#scoreField").val());
	var code=$.trim($("#code").val());
	var expression=$.trim($("#expression").val());
	var desc=$.trim($("#desc").val());
	if(tableNameDR == "")
	{
		$.messager.popover({ msg: '表单名称不能为空！', type:'error' });
    	return false;
	}
	if(scoreField == "")
	{
		$.messager.popover({ msg: '分值字段不能为空！', type:'error' });
    	return false;
	}		
	if(code == "")
	{
		$.messager.popover({ msg: '编码不能为空！', type:'error' });
    	return false;
	}
	if(expression == "")
	{
		$.messager.popover({ msg: '阈值表达式不能为空！', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveThresholdConfig",
		"rowid":rowid,
		"guid":tableNameDR,
		"scoreField":scoreField,
		"code":code,
		"expression":expression,
		"desc":desc,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});	
			var keyword = $.trim($("#keyword").val());		
			reloadDataGrid(keyword);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 删除选中的阈值配置数据
function delData(){	
	var rows=$('#thresholdGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("简单提示", "删除阈值配置，护理级别提醒规则触发条件将失效，确定要删除吗", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteThresholdConfig",
					"rowid":rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"删除成功！", type:'success'});	
						var keyword=$.trim($("#keyword").val());		
						reloadDataGrid(keyword);						
					}else{	
						$.messager.popover({ msg: "删除失败！", type:'error' });	
					}
				}); 
			}
		});				
 	}else{
    	$.messager.alert("简单提示", "请选择要删除的配置数据", "info");
 	}
}

/* =======护理级别提醒规则配置======= */
// 初始化table
function initRuleTab(){	
	// 护理级别医嘱配置
	setOrderGrid = $('#orderGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'desc',title:'医嘱描述',width:150},  
	    	{field:'arcItmName',title:'关联医嘱',width:150}, 
	    	{field:'status',title:'状态',width:80,formatter:function(value, row, index){
	        	return value == "Y" ? "启用" : "停用"	
	        }}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
	                $("#add-dialog-order").dialog({title:"新增护理级别医嘱配置"}).dialog("open");
 					//清空表单数据
 					$('#order-form').form("clear"); 					
 					// 默认启用
	 				$HUI.switchbox("#status").setValue(true);
	 				getLinkOrderData("","");
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
	                updateOrderData();
	            }
	        }
        ],
		singleSelect : true,
		loadMsg : '加载中..',
		onClickRow:function(rowIndex, rowData){
			reloadRuleGrid(rowData.rowid);
			reloadCaseGrid(rowData.rowid);				
		} 
	});
	
	// 提醒规则配置
	setRuleGrid = $('#ruleGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'code',title:'编码',width:150},  
	    	{field:'condition',title:'触发条件',width:360}, 
	    	{field:'remindTmpl',title:'提醒表单',width:360}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
		            var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            $("#add-dialog-rule").dialog({title:"新增提醒规则配置"}).dialog("open");
 						//清空表单数据
 						$('#rule-form').form("clear");
 						$("#nurLevel").val(rows[0].desc);
 						// 触发条件
 						getConditionList("","");
 						getFormData("",true);
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }	                	
	            }
			},{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
		            var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateRuleData(0);
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
	            }
	        },{
            	iconCls: 'icon-copy',
            	text: '复制',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateRuleData(1);
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
            	},
	        },{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            delRuleData();
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..'		
	}); 
	
	// 病历必填配置
	setCaseGrid = $('#caseGrid').datagrid({
		fit : true,
		columns :[[
	    	{field:'code',title:'病历code',width:200},  
	    	{field:'templateName',title:'表单名称',width:260}, 
	    	{field:'validLocs',title:'生效科室',width:260,formatter:function(value,row,index){
		    	return value=="" ? "全院" : value.substr(1,value.length);
		    }}, 
	    	{field:'requiredField',title:'必填项字段',width:350}
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
	                var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            $("#add-dialog-case").dialog({title:"新增病历必填配置"}).dialog("open");
 						//清空表单数据
 						$('#case-form').form("clear");
 						// 表单名称
 						getFormData("",false);
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
	            }
			},{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
	                var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            updateCaseData();
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
	            }
	        },{
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	var rows=$('#orderGrid').datagrid("getSelections");
		            if(rows.length==1){
			            delCaseData();
			        }else{
				        $.messager.alert("简单提示", "请选择一条医嘱配置数据", "info");
				    }
            	}
         	}
		],
		singleSelect : true,
		loadMsg : '加载中..' 
	}); 
}

// 医嘱配置数据加载
function reloadOrderGrid()
{
	$.cm({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		QueryName:"GetNurLevelOrdList",
		hospDR:hospID,
		rows:99999
	},function(data){
		setOrderGrid.datagrid('loadData',data); 
	})
};

// 提醒规则配置数据加载
function reloadRuleGrid(parref)
{
	if(parref){
		$.cm({
			ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
			QueryName:"GetNurLevelRuleList",
			parref:parref,
			hospDR:hospID,
			rows:99999
		},function(data){
			setRuleGrid.datagrid('loadData',data); 
		})
	}else{
		setRuleGrid.datagrid('loadData',[]);
	}	
};

// 病历必填配置数据加载
function reloadCaseGrid(parref)
{
	if(parref){		
		$.cm({
			ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
			QueryName:"GetNurLevelCaseList",
			parref:parref,
			hospDR:hospID,
			rows:99999
		},function(data){
			setCaseGrid.datagrid('loadData',data); 
		})
	}else{
		setCaseGrid.datagrid('loadData',[]); 
	}
};

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
			console.log(arcItmName);
			console.log(param);
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

// 修改选中的医嘱配置数据时，数据回显
function updateOrderData(){	
	var rows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog-order").dialog({title:"修改护理级别医嘱配置"}).dialog("open");
   		getLinkOrderData(rows[0].arcItmDR,rows[0].arcItmName);
    	//清空表单数据
 		$('#order-form').form("clear");
	 	$('#order-form').form("load",{
	 		OrdRowid: rows[0].rowid,
	 		OrdDesc: rows[0].desc		
 		}); 
 		if(rows[0].status == "Y"){
	 		$HUI.switchbox("#status").setValue(true);	
	 	}else{
		 	$HUI.switchbox("#status").setValue(false);	
		}			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的医嘱配置数据", "info");
 	}
}

// 保存医嘱配置
function saveOrdData(){
	var rowid=$.trim($("#ordRowid").val());
	var desc=$.trim($("#ordDesc").val());
	var arcItmDR=$HUI.combogrid('#linkOrd').getValues();
	var status = $("#status").switchbox('getValue') ? "Y" : "N";
	if(desc == "")
	{
		$.messager.popover({ msg: '医嘱描述不能为空！', type:'error' });
    	return false;
	}
	if(arcItmDR.length==0)
	{
		$.messager.popover({ msg: '关联医嘱不能为空！', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelOrder",
		"rowid":rowid,
		"arcItmDr":arcItmDR.join("^"),
		"desc":desc,
		"status":status,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-order").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadOrderGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 获取触发条件列表（阈值配置）
function getConditionList(tcidStr,keyword){
	//医嘱类型
	$HUI.combogrid("#condition", {
		panelWidth: 400,
		panelHeight: 300,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'code',
		multiple:true,
		columns: [[
			{field:'rowid',title:'ID',width:20},
			{field:'code',title:'编码',width:40},
			{field:'expression',title:'阈值表达式',width:100}
			
		]],
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=GetThresholdList",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(keyword){
				param['q']=keyword;
				keyword=""
			}
			if (param['q']) {
				var keyword=param['q'];
			}
			param = $.extend(param,{hospDR:$HUI.combogrid('#_HospList').getValue(),keyword:keyword});
		},
		onLoadSuccess:function(){
			if(tcidStr){
	            $(this).combogrid('setValues', tcidStr.split("^"));
	            tcidStr=[];     
	        }
		}
	});	
}

// 修改选中的规则配置数据时，数据回显
function updateRuleData(flag){
	var rows=$('#ruleGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	var operate=flag ? "复制": "修改"
	if (rows.length == 1) {
   		$("#add-dialog-rule").dialog({title:operate+"提醒规则配置"}).dialog("open");
   		getConditionList(rows[0].tcidStr,"");
   		getFormData(rows[0].guidStr,true);
    	//清空表单数据
 		$('#rule-form').form("clear");
	 	$('#rule-form').form("load",{
	 		RuleRowid: flag ? "" : rows[0].rowid,
	 		NurLevel:ordRows[0].desc,
	 		RuleCode: rows[0].code
 		});			
 	}else{	 	
    	$.messager.alert("简单提示", "请选择要"+operate+"的规则配置数据", "info");
 	}
}

// 保存提醒规则配置
function saveRuleData(){
	var rows=$('#orderGrid').datagrid("getSelections");
	var parref=rows[0].rowid;
	var rowid=$.trim($("#ruleRowid").val());
	var code=$.trim($("#ruleCode").val());
	var condition=$HUI.combogrid('#condition').getValues();
	var tmpl=$HUI.combobox('#remindTmpl').getValues(); 
	if(code == "")
	{
		$.messager.popover({ msg: '编码不能为空！', type:'error' });
    	return false;
	}
	if(condition.length == 0)
	{
		$.messager.popover({ msg: '触发条件不能为空！', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelRule",
		"parref":parref,
		"rowid":rowid,
		"code":code,
		"condition":condition.join("^"),
		"guidStr":tmpl.join("^"),
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-rule").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadRuleGrid(parref);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 删除选中的规则配置数据
function delRuleData(){	
	var rows=$('#ruleGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("简单提示", "确定要删除此提醒规则吗？", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteNurLevelRule",
					"rowid":ordRows[0].rowid+"||"+rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"删除成功！", type:'success'});			
						reloadRuleGrid(ordRows[0].rowid);						
					}else{	
						$.messager.popover({ msg: "删除失败！", type:'error' });	
					}
				});
			}
		});   		 			
 	}else{
    	$.messager.alert("简单提示", "请选择要删除的配置数据", "info");
 	}
}

// 修改选中的病历必填项配置数据时，数据回显
function updateCaseData(){
	var rows=$('#caseGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog-case").dialog({title:"修改病历必填配置"}).dialog("open");
   		getFormData(rows[0].guid,false);
    	//清空表单数据
 		$('#case-form').form("clear");
	 	$('#case-form').form("load",{
	 		CaseRowid: rows[0].rowid,
	 		//CaseCode:rows[0].code,
	 		//ValidLocs: rows[0].validLocs,
	 		RequiredField: rows[0].requiredField
 		});			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的病历必填项配置数据", "info");
 	}
}

// 保存病历必填项配置
function saveCaseData(){
	var rows=$('#orderGrid').datagrid("getSelections");
	var parref=rows[0].rowid;
	var ID=$.trim($("#caseRowid").val());
	//var code=$.trim($("#caseCode").val());
	var guid=$HUI.combobox('#tmplName').getValue(); 
	var requiredField=$.trim($("#requiredField").val());
	if(guid == "")
	{
		$.messager.popover({ msg: '表单名称不能为空！', type:'error' });
    	return false;
	}
	if(requiredField == "")
	{
		$.messager.popover({ msg: '必填项字段不能为空！', type:'error' });
    	return false;
	}		
	$.m({
		ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
		MethodName:"SaveNurLevelCase",
		"parref":parref,
		"rowid":ID,
		"code":"",
		"guid":guid,
		"requiredField":requiredField,
		"userID":userID,
		"hospID":hospID
	},function testget(result){
		$("#add-dialog-case").dialog( "close" );
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadCaseGrid(parref);						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 删除选中的病历必填项配置数据
function delCaseData(){	
	var rows=$('#caseGrid').datagrid("getSelections");
	var ordRows=$('#orderGrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("简单提示", "确定要删除此配置项吗？", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.NursingGrade.DataConfig",
					MethodName:"DeleteNurLevelCase",
					"rowid":rows[0].rowid,
					"userId":userID
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"删除成功！", type:'success'});			
						reloadCaseGrid(ordRows[0].rowid);						
					}else{	
						$.messager.popover({ msg: "删除失败！", type:'error' });	
					}
				}); 
			}
		});			
 	}else{
    	$.messager.alert("简单提示", "请选择要删除的配置数据", "info");
 	}
}
