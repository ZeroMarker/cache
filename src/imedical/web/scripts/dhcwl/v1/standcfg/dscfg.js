

var kpiBodyHeight = getViewportOffset().y;   // 获取屏幕高度
var ITEM_ADD_Flag = 0;
/*--统计项维护表格--*/
$HUI.datagrid("#itemGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
		QueryName:'GetDSItem'
	},
	fitColumns:true,
	toolbar:"#itemToolbar",
	pagination:true,
	pageList:[15,20,50,100],
	pageSize:15
})




/*--数据源新增表格--*/
$HUI.datagrid("#dsAddGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
		QueryName:'GetDS'
	},
	fitColumns:true,
	toolbar:[{
		text:'新增',
		iconCls:'icon-add',
		handler:function(e){
			$("#dsAddForm").form('reset');    //内容重置
			$("#package").val("User");
			$("#dsAddForm").form('validate');
			tableComboxShow();
			$("#dsAddDialog").show();
			$HUI.dialog("#dsAddDialog",{
				iconCls:'icon-w-add',
				resizable:true,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(e){
						var flag = $("#dsAddForm").form('validate');
						if (!flag){
							myMsg("请按照提示填写内容");
							return;
						}
						var tableName,packageName,dsDesc;
						tableName = $("#tableName").combobox("getText");
						packageName = $("#package").val();
						dsDesc = $("#dsDesc").val();
						$m({
							ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
							MethodName:'AddDataSource',
							dsDesc:dsDesc,
							packageName:packageName,
							tableName:tableName
						},function(e){
							myMsg(e);
							$("#dsAddGrid").datagrid("reload");
							$HUI.dialog("#dsAddDialog").close();
						})
						//alert(tableName+"^"+packageName+"^"+dsDesc);
						//$HUI.dialog("#dsAddDialog").close();
					}
				},{
					text:'关闭',
					handler:function(e){
						$HUI.dialog("#dsAddDialog").close();
					}
				}]
			})
		}
	},{
		text:'修改',
		iconCls:'icon-write-order',
		handler:function(e){
			var row = $("#dsAddGrid").datagrid("getSelected");
			if (!row){
				myMsg("请先选择一条需要修改的数据源");
				return;
			}
			var dsID = row.ID;
			var dsDesc = row.dsDesc;
			$("#dsModDesc").val(dsDesc);
			$("#dsModForm").form('validate');
			$("#dsModDialog").show();
			$HUI.dialog("#dsModDialog",{
				iconCls:'icon-w-edit',
				resizable:true,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(e){
						var flag = $("#dsModForm").form('validate');
						if (!flag){
							myMsg("请按照提示填写内容");
							return;
						}
						var dsDesc = $("#dsModDesc").val();
						$m({
							ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
							MethodName:'UpdateDS',
							ID:dsID,
							desc:dsDesc
						},function(e){
							myMsg(e);
							$("#dsAddGrid").datagrid("reload");
							$HUI.dialog("#dsModDialog").close();
						})
						//$HUI.dialog("#dsModDialog").close();
					}
				},{
					text:'关闭',
					handler:function(e){
						$HUI.dialog("#dsModDialog").close();
					}
				}]
			})
		}
	}]
})

/*--表格选择下拉框--*/
function tableComboxShow(){
	var tableNameObj = $HUI.combobox("#tableName",{
		url:$URL+"?ClassName=web.DHCWL.V1.StandCfg.DSCfg&QueryName=GetTableList&ResultSetType=array",
		valueField:'sort',
		textField:'tableName',
		onBeforeLoad:function(param){
			param.className = param.q;
			var packageName = $("#package").val();
			param.packageName = packageName;
		}
	});
}
/*--包名下拉框监听变化事件--*/
$("#package").on('change',function(){
	var packageName = $("#package").val();
	$('#tableName').combobox('reload',$URL+"?ClassName=web.DHCWL.V1.StandCfg.DSCfg&QueryName=GetTableList&ResultSetType=array&packageName=" + packageName);
})

/*--统计项新增--*/
$("#itemAddButton").click(function(e){
	if(!ITEM_ADD_Flag){
		itemGridLoad();
	}else{
		$("#dsSelect").combobox("setValue","");
		$('#allItemGrid').datagrid('loadData',{total:0,rows:[]});
		$('#selectItemGrid').datagrid('loadData',{total:0,rows:[]});
	}
	$("#itemAddDig").show();
	$HUI.dialog("#itemAddDig",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true
	})
})

/*--统计项修改--*/
$("#itemModButton").click(function(e){
	var row = $("#itemGrid").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要修改的对象");
		return;
	}
	var name = row.name;
	var desc = row.desc;
	var itemID = row.ID;
	$("#dsItemModForm").form('reset');    //内容重置
	$("#dsItemModCode").val(name);
	$("#dsItemModDesc").val(desc);
	 $("#dsItemModForm").form('validate');
	$("#dsItemModDialog").show();
	$HUI.dialog("#dsItemModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#dsItemModForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var desc = $("#dsItemModDesc").val();
				//alert(itemID+"^"+desc);
				$m({
					ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
					MethodName:'ModifyDSItem',
					ID:itemID,
					desc:desc
				},function(e){
					myMsg(e);
					$HUI.dialog("#dsItemModDialog").close();
					$("#itemGrid").datagrid('load');
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#dsItemModDialog").close();
			}
		}]
	});
})

/*--统计项删除--*/
$("#itemRemoveButton").click(function(e){
	var row = $("#itemGrid").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要删除的对象");
		return;
	}
	var itemID = row.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
				MethodName:'DeleteDSItem',
				ID:itemID
			},function(e){
				myMsg(e);
				$("#itemGrid").datagrid('load');
			})
		}
	});
})

/*--统计项检索--*/
$('#itemSearch').searchbox({
	searcher:function(value,name){
		$("#itemGrid").datagrid("load",{ClassName:'web.DHCWL.V1.StandCfg.DSCfg',QueryName:'GetDSItem',filterValue:value});
	}
})

/*--左右图片提示--*/
$HUI.tooltip('#statDateButton,#measureButton',{
	content:'<span>移入</span>',
	position:'bottom'
})
$HUI.tooltip('#moveLeft',{
	content:'<span">移出</span>',
	position:'bottom'
})

/*--统计项新增表格加载方法--*/
function itemGridLoad(){
	ITEM_ADD_Flag = 1;
	var allItemObj = $HUI.datagrid("#allItemGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
			QueryName:"GetDSProperty"
		},
		fitColumns:true,
		toolbar:'#itemAddToolbar'
	})
	var selectItemObj = $HUI.datagrid("#selectItemGrid",{
		fitColumns:true,
		toolbar:[{
			text:'保存',
			iconCls:'icon-save',
			handler:function(e){
				var dsID = $("#dsSelect").combobox("getValue");
				var rows = $("#selectItemGrid").datagrid("getRows");
				var len = rows.length;
				if (len < 1){
					myMsg("没有可保存的数据项");
					return;
				}
				var names,descs,types,exes;
				for(var i = 0; i < len;i++){
					if (i == 0){
						names = rows[i].itemAddName;
						descs = rows[i].itemAddDesc;
						types = rows[i].itemAddType;
						exes = rows[i].itemAddExeCode;
					}else{
						names =names + "," + rows[i].itemAddName;
						descs = descs + "," + rows[i].itemAddDesc;
						types = types + "," + rows[i].itemAddType;
						exes = exes + "," + rows[i].itemAddExeCode;
					}
				}
				
				$m({
					ClassName:'web.DHCWL.V1.StandCfg.DSCfg',
					MethodName:'AddDSItem',
					names:names,
					descs:descs,
					types:types,
					exes:exes, 
					dsID:dsID
				},function(e){
					myMsg(e);
					$HUI.dialog("#itemAddDig").close();
					$("#itemGrid").datagrid("reload");
				})
				//alert(dsID+"^"+names+"^"+descs+"^"+types+"^"+exes);
			}
		},{
			text:'删除',
			iconCls:'icon-cancel',
			handler:function(){
				var row = $("#selectItemGrid").datagrid("getSelected");
				if (!row){
					myMsg("请先选择移除对象");
					return;
				}
				var index = $("#selectItemGrid").datagrid("getRowIndex",row);
				$("#selectItemGrid").datagrid("deleteRow",index);
			}
		}]
	})
	$HUI.combobox("#dsSelect",{
		url:$URL + "?ClassName=web.DHCWL.V1.StandCfg.DSCfg&QueryName=GetDSList&ResultSetType=array",
		valueField:'dsID',
		textField:'dsDesc',
		onSelect:function(record){
			var dsID = record.dsID;
			$("#allItemGrid").datagrid('load',{ClassName:'web.DHCWL.V1.StandCfg.DSCfg',QueryName:'GetDSProperty',dsID:dsID});
		}
	});
}

/*--新增口径/度量--*/
$("#statDateButton,#measureButton").click(function(e){
	var val=$(this).attr("id");
	if (val == "measureButton"){
		type = "度量";
	}else{
		type = "口径";
	}
	var row = $("#allItemGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要维护的对象");
		return;
	}
	var fieldCode = row.fieldName;
	$("#descAddInforForm").form('reset');    //内容重置
	$("#propertyName").val(fieldCode);
	var flag = isRepeat(fieldCode);
	if (flag){
		myMsg("统计项名称不能重复");
		return;
	}
	$("#descAddDialog").show();
	$HUI.dialog("#descAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'确定',
			handler:function(e){
				var flag = $("#descAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var desc = $("#propertyDesc").val();
				$('#selectItemGrid').datagrid('insertRow',{
					row: {
						itemAddName: fieldCode,
						itemAddDesc: desc,
						itemAddType: type,
						itemAddExeCode:''
					}
				});
				$HUI.dialog("#descAddDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#descAddDialog").close();
			}
		}]
	})
})

/*--移除口径/度量--*/
$("#removeButton").click(function(e){
	var row = $("#selectItemGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择移除对象");
		return;
	}
	var index = $("#selectItemGrid").datagrid("getRowIndex",row);
	$("#selectItemGrid").datagrid("deleteRow",index);
	
})

/*--自定义表达式--*/
$("#diyItemAddButton").click(function(e){
	var dsValue = $("#dsSelect").combobox("getValue");
	if (!dsValue){
		myMsg("请先选择数据源");
		return;
	}
	$("#diyItemAddInforForm").form('reset');    //内容重置
	$("#diyItemAddDialog").show();
	$HUI.dialog("#diyItemAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#diyItemAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc,type,exeCode;
				code = $("#diyItemCode").val();
				desc = $("#diyItemDesc").val();
				type = $("#diyItemType").combobox("getValue");
				exeCode = $("#diyItemExeCode").val();
				var flag = isRepeat(code);
				if (flag){
					myMsg("统计项名称不能重复");
					return;
				}
				$('#selectItemGrid').datagrid('insertRow',{
					row: {
						itemAddName: code,
						itemAddDesc: desc,
						itemAddType: type,
						itemAddExeCode:exeCode
					}
				});
				$HUI.dialog("#diyItemAddDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#diyItemAddDialog").close();
			}
		}]
	})
})

/*--判断添加的统计项是否重复添加--*/
function isRepeat(fieldCode){
	var flag = 0;
	var proRows = $("#selectItemGrid").datagrid("getRows");
	var len = proRows.length;
	if (len > 0){
		var name = "";
		for (var i = 0;i < len;i++){
			name = proRows[i].itemAddName;
			if (name == fieldCode){
				flag = 1;
			}
		}
	}
	return flag;
}

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}
	
/*--调整整个系统配置界面--*/
 $(window).resize(function () {  
	 $('#dsBodyDiv').tabs({  
		 width: $("#dsBodyDiv").parent().width(),  
		 height: $("#dsBodyDiv").parent().height()  
	 });  
 })  
 $(function() {  
	 $('#dsBodyDiv').tabs({  
		 width: $("#dsBodyDiv").parent().width(),   
　　     height: $("#dsBodyDiv").parent().height()  
		});  
 });