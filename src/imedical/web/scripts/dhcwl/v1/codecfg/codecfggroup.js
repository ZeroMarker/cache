/**
* Creator    :  wk
* CreatDate  :  2018-08-09
* Desc       :  统计子组展示界面
**/﻿

var kpiBodyHeight = getViewportOffset().y;
var GRP_SELECTED_ID = "";
var GRP_DETAIL_ADD = "";
var SELECT_SUBGRP_ROW = ""
  

/*var codecfgDetailObj = $HUI.datagrid("#codecfgDetailGrpTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		QueryName:'GetItemGrpDetail'
	},
	fitColumns:true,
	toolbar:'#detailRoleToobar',
	onLoadSuccess:function(){
		$(this).datagrid('enableDnd');   //表格支持排序
	}
})*/


//归集子组配置树
var subGrpTreeObj = $HUI.treegrid("#subGrpRuleTree",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCWL.V1.CodeCFG.GrpFunModule",
		QueryName:"GetSubGrpTreeQuery",
		//inputRule:dimRule,
		rows:10000,
		page:1
	},
	fitColumns:true,
	toolbar:"#detailRoleToobar",
	/*onContextMenu:function(e){
		e.preventDefault();   //阻止浏览器自带的右键菜单弹出  
		$('#grpMenu').menu('show', {
			left:e.pageX,
			top: e.pageY
		});
		e.preventDefault();   //阻止浏览器自带的右键菜单弹出
	},*/
	onClickRow:function(row){
		var row = $("#subGrpRuleTree").treegrid("find",row);
		var flag = row.flag;
		var p = subGrpTreeObj.getPanel();
		if ((flag != "0")||(flag != 0)){
			p.find("#itemGrpDetailAddButton").linkbutton("enable",true);
			GRP_DETAIL_ADD = 1;
		}else{
			p.find("#itemGrpDetailAddButton").linkbutton("disable",true);
			GRP_DETAIL_ADD = 0;
		}
		
	}
})

var codecfgObj = $HUI.datagrid("#codecfgTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		QueryName:'GetGroupQuery'
	},
	fitColumns:true,
	pagination:true,  //分页可用
	//striped:true,  //表格斑马线状态
	pageSize:15,  //当前页每页条数
	pageList:[15,20,50],  //每页可以选中的显示条数
	toolbar:'#codecfgToobar',
	onClickRow:function(rowIndex,rowData){
		var p = subGrpTreeObj.getPanel();
		p.find("#itemGrpDetailAddButton").linkbutton("disable",true);
		$('#subGrpRuleTree').treegrid('clearSelections');
		$("#subGrpRuleTree").treegrid('load',{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetSubGrpTreeQuery',grpID:rowData.ID,rows:10000,page:1})
		//var grpID = rowData.ID;
		//alert(grpID);
	}
})


/*--指标区间下拉框数据获取--*/
var dimObj = $HUI.combobox("#codecfgDim",{
	url:$URL+"?ClassName=web.DHCWL.V1.CodeCFG.FunModule&QueryName=GetDimQuery&ResultSetType=array",
	valueField:'dimID',
	textField:'dimDesc',
	onHidePanel: function() {
		var value = $(this).combobox("getValue");
		var text = $(this).combobox("getText");
		if (value == text){
			$(this).combobox("clear");
			$('#codecfgDim').combobox('reload');
		}
	}
});


/*--鼠标悬停维度描述单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

/*--归集大组新增--*/
$("#codecfgAddButton").click(function(e){
	$("#codecfgAddForm").form('reset');
	$("#codecfgAddDialog").show();
	$HUI.dialog("#codecfgAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#codecfgAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var dimValue = $("#codecfgDim").combobox("getText");
				//var dimValue = $("#codecfgDim").combobox("getValue");
				var code = $("#codecfgCode").val();
				var desc = $("#codecfgDesc").val();
				var creator = $("#codecfgCreator").val();
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'AddCodecfggrp',
					grpCode:code,
					grpDesc:desc,
					grpDimDr:dimValue,
					grpCreator:creator
				},function(txtData){
					myMsg(txtData);
					$HUI.dialog("#codecfgAddDialog").close();
					$("#codecfgTable").datagrid('reload');
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#codecfgAddDialog").close();
			}
		}]
	})
})

/*--归集大组修改--*/
$("#codecfgModifyButton").click(function(e){
	$("#codecfgModifyForm").form('reset');    //内容重置
	//获取选中记录
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要修改的大组");
		return;
	}
	var ID,code,desc,creator;
	ID = row.ID;
	code = row.codecfgCode;
	desc = row.codecfgName;
	creator = row.codecfgCreator;
	dim = row.codecfgDim;
	if ((!code)||(!ID)){
		myMsg("获取大组失败");
		return;
	}
	
	//给表单赋值
	$("#codecfgModifyCode").val(code);
	$("#codecfgModifyDesc").val(desc);
	$("#codecfgModifyCreator").val(creator);
	$("#codecfgModifyDialog").show();
	
	$("#codecfgModifyForm").form('validate'); //表单验证
	$HUI.dialog("#codecfgModifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var grpCode = $("#codecfgModifyCode").val();
				var grpDesc = $("#codecfgModifyDesc").val();
				var grpCreator = $("#codecfgModifyCreator").val();
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'UpdateCodecfggrp',
					grpID:ID,
					grpCode:grpCode,
					grpDesc:grpDesc,
					grpCreator:grpCreator,
					grpDimDr:dim
				},function(text){
					myMsg(text);  //弹出返回信息
					$HUI.dialog("#codecfgModifyDialog").close(); //关闭修改框
					$("#codecfgTable").datagrid('reload');  //统计大组表格重新加载
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#codecfgModifyDialog").close();
			}
		}]
	})
})

/*--归集大组删除--*/
$("#codecfgDeleteButton").click(function(e){
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要删除的大组");
		return;
	}
	var ID = row.ID;
	if ((!ID)){
		myMsg("获取大组失败");
		return;
	}
	$.messager.confirm("提示", "删除后归集大组将不能恢复,是否继续进行", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
				MethodName:'DeleteCodecfggrp',
				grpID:ID
			},function(text){
				myMsg(text);
				$("#codecfgTable").datagrid('reload');  //统计大组表格重新加载
			})
		} 
	});
})

/*--统计子组导出--*/
$("#codecfgExportButton").click(function(e){
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要导出的大组");
		return;
	}
	var selectID = row.ID;
	
	$cm({
		ResultSetType:"Excel",  //表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		//ResultSetTypeDo:"Export",    //默认Export，可以设置为：Print
		//localDir:"D:\\tmp\\",	      //固定文件路径
		//localDir:"Self",            //用户选择路径
		//loca//lDir:""                 //默认桌面
		ExcelName:"excelname",				 //默认DHCCExcel
		ClassName:"web.DHCWL.V1.CodeCFG.GrpFunModule",
		QueryName:"ExportSubGrpQuery",
		selectID:selectID ,
		page:1 ,
		rows:10000
	},false,function(json){
		console.log(json);
		parent.location.href = json.responseText;
	});
	return;
	
	
	
	
	var excelObj=new Excel();
	excelObj.setTitle("统计子组导出");
	excelObj.setTable("DHCWL.CodeCfg.ItemGroup");
	//excelObj.setHead(['大组编码','大组描述','创建时间','创建人','维度类型','明细ID','明细描述','明细排序值']);
	excelObj.setHead(['归集大组编码','归集大组描述','创建时间','创建人','维度类型','当前节点','归集子组编码','归集子组描述','排序值',"层级",'明细ID','明细描述']);
	//excelObj.setServerUrl(serviceUrl+'?action=exportGrp');
	excelObj.exportExcelAll("web.DHCWL.V1.CodeCFG.GrpFunModule","ExportSubGrp",selectID);
})

/*--子组日志--*/
$("#codecfgLogButton").click(function(e){
	cleanCfgLogSearch();
	$HUI.datagrid("#logGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
			QueryName:'GetLogInforQuery',
			grpFlag:1
		},
		fitColumns:true,
		pagination:true,  //分页可用
		//striped:true,  //表格斑马线状态
		pageSize:15,  //当前页每页条数
		pageList:[15,20,50],  //每页可以选中的显示条数
		toolbar:'#codecfgLogToolbar'
	})
	
	$("#codecfgLogDialog").show();
	$HUI.dialog("#codecfgLogDialog",{
		iconCls:'icon-w-list',
		height:kpiBodyHeight-20,
		resizable:true,
		modal:true
	})
})
 function linkHisVerGrid(value,row,index){
	 //onclick='verHisInforFun(\""+row.vmDr+"\")'
	var type = row.operModule;
	if (type == "子组明细"){
		return "<a href='javascript:void(0)' onclick='verLogDetailFun(\""+row.logID+"\")' title='日志明细查看'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
	}else{
		return "";
	}
 }
 
 function verLogDetailFun(logID){
	 //alert(logID);
	 $HUI.datagrid("#logDetailGrid",{
		 url:$URL,
		 queryParams:{
			ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
			QueryName:'GetLogDetail',
			logID:logID
		 },
		fitColumns:true
	 })
	 $("#logDetailDialog").show();
	 $HUI.dialog("#logDetailDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-list'
	 })
 }





/*--统计子组日志查询--*/
$("#logSearchButton").click(function(e){
	var userName = "",moduleType = "",operType = "",operDate = "";
	userName = $("#operUserName").val();
	moduleType = $("#moduleType").combobox("getText");
	operType = $("#operType").combobox("getText");
	operDate = $('#operDate').datebox('getValue');
	//alert(userName+"^"+moduleType+"^"+operType+"^"+operDate);
	$("#logGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.FunModule',QueryName:'GetLogInforQuery',grpFlag:1,seaModeType:moduleType, seaOperType:operType, seaDate:operDate,seaName:userName})
})

/*--统计子组日志查询条件清空--*/
$("#logCleanButton").click(function(e){
	cleanCfgLogSearch();
})

/*--统计子组日志方法表单清空--*/
function cleanCfgLogSearch(){
	$("#operUserName").val("");
	$('#moduleType').combobox('setValue', '');
	$('#operType').combobox('setValue', '');
	$('#operDate').datebox('setValue', '');
}

/*--归集大组查询--*/
$('#grpSearchText').searchbox({
	searcher:function(value,name){
		codecfgObj.load({ClassName:"web.DHCWL.V1.CodeCFG.GrpFunModule",QueryName:"GetGroupQuery",filterValue:value});
	}
})

/*--归集子组查询--*/
$("#searchText").searchbox({
	searcher:function(value,name){
		var grpID = getSelectGrpID();
		if (!grpID){
			return;
		}
		$("#subGrpRuleTree").treegrid('load',{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetSubGrpTreeQuery',grpID:grpID,filterValue:value});
	}
})


	$HUI.datagrid("#grpSelectDetailGrid",{
		url:$URL,
		fitColumns:true,
		pagination:true,
		toolbar:'#grpSelectDetailoolbar',
		pageSize:15,  //当前页每页条数
		pageList:[15,20,50]  //每页可以选中的显示条数
	})
	
	$HUI.datagrid("#grpAllDetailGrid",{
		url:$URL,
		fitColumns:true,
		toolbar:'#grpAllDetailoolbar',
		pagination:true,  //分页可用
		pageSize:15,  //当前页每页条数
		pageList:[15,20,50]  //每页可以选中的显示条数
	})


/*--统计子组明细维护--*/
$("#itemGrpDetailAddButton").click(function(e){
	if (!GRP_DETAIL_ADD){
		return;
	}
	var row = $("#subGrpRuleTree").treegrid("getSelected");
	if (!row){
		return;
	}
	$('#grpAllDetailSearch').searchbox('setValue', '');
	$('#grpSelectDetailSearch').searchbox('setValue', '');
	var grpID = getSelectGrpID();
	if (!grpID){
		return;
	}
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	$("#grpSelectDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetSelectDetailQuery',subgrpId:subGrpID});
	$("#grpAllDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetAllDetailQuery',grpid:grpID});
	
	
	$("#grpDetailDialog").show();
	$HUI.dialog("#grpDetailDialog",{
		iconCls:'icon-w-config',
		height:kpiBodyHeight-20,
		resizable:true,
		modal:true,
		onOpen:function(){     //打开任务组明细添加界面时初始化日志记录global
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
				MethodName:'InitGrpLogGlobal'
			},function(text){
				if (text != 'ok'){
					myMsg(text);
					return;
				}
			})
		},
		onClose:function(){     //关闭任务组明细添加界面时将日志信息保存起来
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
				MethodName:'EndGrpLogGlobal'
			},function(text){
				if (text != 'ok'){
					myMsg(text);
					return;
				}
			})
		}
	})
})

/*--归集子组新增--*/
$("#itemGrpAddButton").click(function(e){
	var grpID = getSelectGrpID();
	if (!grpID){
		return;
	}
	$("#subGrpAddForm").form('reset');    //内容重置
	$("#subGrpAddDialog").show();
	$HUI.dialog("#subGrpAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#subGrpAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var subGrpCode = $("#subGrpAddCode").val();
				var subGrpDesc = $("#subGrpAddDesc").val();
				var grpID = getSelectGrpID();
				if (!grpID){
					return;
				}
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'AddCodecfgTreesubgrp',
					grpID:grpID,
					subGrpCode:subGrpCode,
					subGrpDesc:subGrpDesc
				},function(text){
					myMsg(text);
					$HUI.dialog("#subGrpAddDialog").close();
					$("#subGrpRuleTree").treegrid('reload');
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#subGrpAddDialog").close();
			}
		}]
	})
})

/*--归集子组修改--*/
$("#itemGrpModifyButton").click(function(e){
	$("#subGrpModifyForm").form('reset');    //内容重置
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	var row,subGrp,subGrpCode,subGrpDesc,subGrpSort,subGrpID;
	var row = $("#subGrpRuleTree").treegrid("getSelected");
	subGrpID = row.grpID;
	subGrpCode = row.code;
	subGrpDesc = row.name;
	subGrpSort = row.sort;
	$("#subGrpModifyCode").val(subGrpCode);
	$("#subGrpModifyDesc").val(subGrpDesc);
	$("#subGrpModifyForm").form('validate');
	$("#subGrpModifyDialog").show();
	$HUI.dialog("#subGrpModifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#subGrpModifyForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var grpID = getSelectGrpID();
				if (!grpID){
					return;
				}
				var newSubGrpDesc = $("#subGrpModifyDesc").val();
				/*--将信息传到后台保存--*/
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'UpdateCodecfgsubgrp',
					ID:subGrpID,
					subGrpCode:subGrpCode,
					subGrpDesc:newSubGrpDesc,
					grpID:grpID,
					subGrpSort:subGrpSort
				},function(text){
					myMsg(text);
					$HUI.dialog("#subGrpModifyDialog").close();
					$("#subGrpRuleTree").treegrid('reload');
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#subGrpModifyDialog").close();
			}
		}]
	})
})

/*--归集子组删除--*/
$("#itemGrpDeleteButton").click(function(e){
	var grpRow = $("#codecfgTable").datagrid("getSelected");
	if (!grpRow){
		myMsg('归集大组未选中');
		return "";
	}
	var row = $("#subGrpRuleTree").treegrid("getSelected");
	if (!row){
		myMsg("请先选择一条归集子组记录");
		return "";
	}
	var subGrpID = row.grpID;
	var rowID = row.ID;
	if (!subGrpID){
		return;
	}
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
				MethodName:'DeleteCodecfgsubtreegrp',
				subGrpID:subGrpID
			},function(text){
				myMsg(text);
				//$('#subGrpRuleTree').treegrid('remove',rowID);
				$("#subGrpRuleTree").treegrid('reload');
			})
		}
	});
})

 /*--归集子组移动--*/
 function moveSubGrpFun(value,row,index){
		//SELECT_SUBGRP_ROW = row;
		return "<a href='javascript:void(0)' onclick='AddChildSubGrp(\""+row.name + "," + row.ID +"\")' title='新增子统计项'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' />"+"\
			</a>" + 
			"<a href='javascript:void(0)' onclick='subGrpMoveup(\""+row.grpID+"\")' title='上移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_top.png' />"+"\
			</a>" + 
			"<a href='javascript:void(0)' onclick='subGrpMoveDown(\""+row.grpID+"\")' title='下移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_bottom.png' />"+"\
			</a>" +
			"<a href='javascript:void(0)' onclick='subGrpMoveTo(\""+row.grpID+"\")' title='跳转'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png' />"+"\
			</a>";
 }


/*--归集子组上移一位--*/
//$("#grpMoveUp").click(function(e){
function subGrpMoveup(subGrpID){
	//var subGrpID = getSubSelectGrpID();
	//alert(subGrpID);
	//return;
	if (!subGrpID){
		return;
	}
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		MethodName:'GrpMoveUpAndDown',
		subGrpID:subGrpID,
		sign:'up'
	},function(text){
		$("#subGrpRuleTree").treegrid('reload');
		myMsg(text);
	})
}//)

/*--归集子组下移一位--*/
//$("#grpMoveDown").click(function(e){
function subGrpMoveDown(subGrpID){
	//var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		MethodName:'GrpMoveUpAndDown',
		subGrpID:subGrpID,
		sign:'down'
	},function(text){
		$("#subGrpRuleTree").treegrid('reload');
		myMsg(text);
	})
}//)

/*--归集子组跳转--*/
//$("#grpMoveTo").click(function(e){
function subGrpMoveTo(subGrpID){
	//var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	$.messager.prompt("提示", "请输入跳转位置", function (r) {
		if (r) {
			if(!isNaN(r)){
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'GrpMoveToLocation',
					subGrpID:subGrpID,
					aimsValue:r
				},function(text){
					$("#subGrpRuleTree").treegrid('reload');
					myMsg(text);
				})
			}else{
				myMsg("请输入数字");
			}
		}
	});
}//)
/*--归集子组新增子统计项(子节点)--*/
//$("#addChildSubGrp").click(function(e){
function AddChildSubGrp(grpRowInfor){
	var grpName = grpRowInfor.split(",")[0];
	var grpTreeCode = grpRowInfor.split(",")[1];
	var grpID = getSelectGrpID();
	if (!grpID){
		return;
	}
	/*var row =  $("#subGrpRuleTree").treegrid("getSelected");
	if (!row){
		myMsg("请先选择一条归集子组记录");
		return "";
	}*/
	$("#subGrpChildAddForm").form('reset');
	var code,name,nodeInfor,grpID,treeCode;
	//code = row.code;
	//name = row.name;
	name = grpName;
	nodeInfor = name + "---子节点新增";
	//subGrpID = row.grpID;
	//treeCode = row.ID;
	treeCode = grpTreeCode;
	$("#subGrpChildAddDialog").show();
	$HUI.dialog("#subGrpChildAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		title:nodeInfor,
		buttons:[{
			text:'保存',
			handler:function(){
				var flag = $("#subGrpChildAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var childCode,childDesc;
				childCode = $("#subGrpChildCode").val();
				childDesc = $("#subGrpChildDesc").val();			
				//alert(grpID+"^"+childCode+"^"+childDesc+"^"+treeCode);
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'SaveSubGroupChild',
					code:childCode,
					desc:childDesc,
					groupCode:treeCode,
					grpId:grpID
				},function(text){
					myMsg(text);
					$("#subGrpChildAddForm").form('reset'); 
					$HUI.dialog("#subGrpChildAddDialog").close();
					$("#subGrpRuleTree").treegrid('reload');
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#subGrpChildAddDialog").close();
			}
		}]
	})
}//)


/*--统计子组明细已选明细删除--*/
$("#selectDeleteButton").click(function(e){
	var row = $("#grpSelectDetailGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的明细");
		return;
	}
	var grpDetailID = row.ID;
	//alert(grpDetailID);
	$.messager.confirm("提示", "删除后不能恢复,确认删除么", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
				MethodName:'DeleteSubGrpDetail',
				grpDetailID:grpDetailID
			},function(text){
				myMsg(text);
				$("#grpSelectDetailGrid").datagrid("reload");
				$("#grpAllDetailGrid").datagrid("reload");
			})
			
		}
	});
})

/*--统计子组明细全部删除--*/
$("#selectDeleteAllButton").click(function(e){
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	$.messager.confirm("提示", "删除后不能恢复,确认删除么", function (r) {
		if (r) {
			$.messager.confirm("提示", "所有明细将被删除,确认删除么", function (r) {
				if (r) {
					$m({
						ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
						MethodName:'DeleteAllSubGrpDetail',
						subgrpID:subGrpID
					},function(text){
						myMsg(text);
						$("#grpSelectDetailGrid").datagrid("reload");
						$("#grpAllDetailGrid").datagrid("reload");
					})
				}
			});
			
		}
	});
})

/*---统计子组明细所有明细新增--*/
$("#selectAllAddButton").click(function(e){
	var grpID = getSelectGrpID();
	if (!grpID){
		return;
	}
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	var rows = $("#grpAllDetailGrid").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		myMsg("请先选择需要添加的明细");
		return;
	}
	var grpDetailIDs = "",grpDetailCodes = "";
	for (var i = 0;i < len;i++){
		if (grpDetailIDs == ""){
			grpDetailIDs = rows[i].ID;
		}else{
			grpDetailIDs = grpDetailIDs + "-" + rows[i].ID;
		}
		if (grpDetailCodes == ""){
			grpDetailCodes = rows[i].code;
		}else{
			grpDetailCodes = grpDetailCodes + "@" + rows[i].code;
		}
	}
	//alert(grpDetailCodes + "^" + grpDetailIDs);
	/*--访问后台方法--*/
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		MethodName:'Addsubgrpitem',
		grpID:grpID,
		subGrpID:subGrpID,
		selectItemPara:grpDetailIDs,
		selectItemCode:grpDetailCodes
	},function(text){
		myMsg(text);
		$("#grpSelectDetailGrid").datagrid("reload");
		$("#grpAllDetailGrid").datagrid("reload");
	})
})

/*--统计子组明细已选明细检索--*/
$('#grpSelectDetailSearch').searchbox({
	searcher:function(value,name){
		var subGrpID = getSubSelectGrpID();
		if (!subGrpID){
			return;
		}
		$("#grpSelectDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetSelectDetailQuery',subgrpId:subGrpID,filterValue:value});
	}
})

/*--统计子组明细所有明细检索--*/
$('#grpAllDetailSearch').searchbox({
	searcher:function(value,name){
		var grpID = getSelectGrpID();
		if (!grpID){
			return;
		}
		$("#grpAllDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',QueryName:'GetAllDetailQuery',grpid:grpID,filterValue:value});
	}
})

 /*--子组明细移动--*/
 function moveSubGrpDetailFun(value,row,index){
		return "<a href='javascript:void(0)' onclick='subGrpDetailMoveup(\""+row.ID+"\")' title='上移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_top.png' />"+"\
			</a>" + 
			"<a href='javascript:void(0)' onclick='subGrpDetailMoveDown(\""+row.ID+"\")' title='下移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_bottom.png' />"+"\
			</a>" +
			"<a href='javascript:void(0)' onclick='subGrpDetailMoveTo(\""+row.ID+"\")' title='跳转'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png' />"+"\
			</a>";
 }

/*--统计子组明细上移一位--*/
//$("#moveUp").click(function(e){
function subGrpDetailMoveup(grpDetailID){
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	//var row = $("#grpSelectDetailGrid").datagrid("getSelected");
	if (!grpDetailID){
		myMsg("请先选择一条记录");
		return;
	}
	//var grpDetailID = row.ID;
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		MethodName:'MoveUp',
		subGrpID:subGrpID,
		itemID:grpDetailID
	},function(text){
		$("#grpSelectDetailGrid").datagrid("reload");
		myMsg(text);
	})
}//)

/*--统计子组明细下移一位--*/
function subGrpDetailMoveDown(grpDetailID){
//$("#moveDown").click(function(e){
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	//var row = $("#grpSelectDetailGrid").datagrid("getSelected");
	if (!grpDetailID){
		myMsg("请先选择一条记录");
		return;
	}
	//var grpDetailID = row.ID;
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
		MethodName:'MoveDown',
		subGrpID:subGrpID,
		itemID:grpDetailID
	},function(text){
		$("#grpSelectDetailGrid").datagrid("reload");
		myMsg(text);
	})
}//)

/*--统计子组明细跳转--*/
//$("#moveTo").click(function(e){
function subGrpDetailMoveTo(grpDetailID){	
	var subGrpID = getSubSelectGrpID();
	if (!subGrpID){
		return;
	}
	//var row = $("#grpSelectDetailGrid").datagrid("getSelected");
	if (!grpDetailID){
		myMsg("请先选择一条记录");
		return;
	}
	//var grpDetailID = row.ID;
	$.messager.prompt("提示", "请输入跳转位置", function (r) {
		if (r) {
			if(!isNaN(r)){
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.GrpFunModule',
					MethodName:'MoveToLocal',
					subGrpID:subGrpID,
					itemID:grpDetailID,
					aimsValue:r
				},function(text){
					$("#grpSelectDetailGrid").datagrid("reload");
					myMsg(text);
				})
			}else{
				myMsg("请输入数字");
			}
			//$.messager.popover({msg:"你的签名是：" + r,type:'info'});
		}
	});
}//)

/*--获取归集大组选中记录的ID--*/
function getSelectGrpID(){
	var row = $("#codecfgTable").datagrid("getSelected");
	if (!row){
		myMsg('请先选择一条归集大组记录');
		return "";
	}
	var grpID = row.ID
	return grpID;
}

/*--获取归集子组选中记录的ID--*/
function getSubSelectGrpID(){
	var grpRow = $("#codecfgTable").datagrid("getSelected");
	if (!grpRow){
		myMsg('归集大组未选中');
		return "";
	}
	var row = $("#subGrpRuleTree").treegrid("getSelected");
	if (!row){
		myMsg("请先选择一条归集子组记录");
		return "";
	}
	var grpID = row.grpID;
	return grpID;
}

