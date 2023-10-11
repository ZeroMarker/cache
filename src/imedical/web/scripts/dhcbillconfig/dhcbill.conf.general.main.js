/**
 * FileName: dhcbill.conf.general.main.js
 * Author: ZhYW
 * Date: 2022-02-28
 * Description: 通用配置主界面
 */
var init = function() {
	$("#mod-search").searchbox({
		searcher: function(value) {
			GV.ModTree.search(value);
		}
	});
	
	$("#cfg-search").searchbox({
		searcher: function(value) {
			loadCfgPointList();
		}
	});
	
	initModTree();
	
	initCfgPointList();
	
};

var initModTree = function() {
	GV.ModTree = $HUI.tree("#modTree", {
		fit: true,
		animate: true,
		url: $URL + '?ClassName=BILL.CFG.COM.GeneralCfg&MethodName=BuildProModuleTree&ResultSetType=array',
		onClick: function (node) {
			$(this).tree("toggle", node.target);
		},
		onSelect: function(node) {
			loadCfgPointList(node);
		},
		onContextMenu: function(e,node){
			if (!node) return;
			GV.ModTree.select(node.target);
			onContextMenuHandler(e);
		}
	});
};
// 加载配置点代码列表
var initCfgPointList = function() {
	var tb = [{
	        text: '新增',
	        iconCls: 'icon-add',
	        disabled: true,
	        handler: editPointClick
	    }, {
	        text: '修改',
	        iconCls: 'icon-write-order',
	        disabled: true,
	        handler: editPointClick
	    }, {
	        text: '导入',
	        iconCls: 'icon-import',
	        //disabled: true,
	        handler: importPointClick
	    }
	];
	GV.CfgPointList = $HUI.datagrid("#cfgPointList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		displayMsg: '',
		toolbar: tb,
		columns: [[
			{title: '配置点', field: 'text', width: 275},
			{filed: 'id', hidden: true},
			{filed: 'code', hidden: true},
			{filed: 'limitFlag', hidden: true}
		]],
		onLoadSuccess: function(data) {
			var node = GV.ModTree.getSelected();
			if (node && GV.ModTree.getParent(node.target)) {
				GV.CfgPointList.getPanel().find(".datagrid-toolbar .icon-add").parents("a.l-btn").linkbutton("enable");
			}else {
				GV.CfgPointList.getPanel().find(".datagrid-toolbar .icon-add").parents("a.l-btn").linkbutton("disable");
			}
			GV.CfgPointList.getPanel().find(".datagrid-toolbar .icon-write-order").parents("a.l-btn").linkbutton("disable");
			$("iframe").attr("src", "dhcbill.nodata.warning.csp");
		},
		onSelect: function(index, row) {
			GV.CfgPointList.getPanel().find(".datagrid-toolbar .icon-write-order").parents("a.l-btn").linkbutton("enable");
			loadCfgPage(row);
		},
		onDblClickRow:function(index,row){
			var node = GV.ModTree.getSelected();
			if (!GV.ModTree.getParent(node.target)) {
				return;
			}
			GV.dicCode = GV.ModTree.getParent(node.target).attributes.code;
			GV.modCode = node.attributes.code;
			if (!GV.dicCode) {
				return;
			}
			GV.opt = {
				iconCls: 'icon-w-edit',
				title: '修改'
			};
			
			var row = GV.CfgPointList.getSelected();
			GV.ptId = row.id;
			$("#edit-pt-dlg").show();
			ptDlgObj();
		},
		onRowContextMenu:function(e, index, row){
			$('#cfgPointList').datagrid('selectRow', index);
			onContextMenuHandler(e);
		}
	});

};

var loadCfgPointList = function() {
	var node = GV.ModTree.getSelected();
	var _dicCode = "";
	var _modCode = "";
	if (GV.ModTree.getParent(node.target)) {
		_dicCode = GV.ModTree.getParent(node.target).attributes.code;
		_modCode = node.attributes.code;
	}else {
		_dicCode = node.attributes.code;
	}
	var queryParams = {
		ClassName: "BILL.CFG.COM.GeneralCfg",
		QueryName: "QryCfgPointList",
		dicCode: _dicCode,
		modCode: _modCode,
		cfgDesc: $("#cfg-search").searchbox("getValue")
	};
	loadDataGridStore("cfgPointList", queryParams);
};

var loadCfgPage = function (row) {
	var ptId = row.id;
	var url = getPropValById("CF_BILL_COM.CfgPoint", ptId, "CPLinkURL");
	// url新增类型后缀
	var str = url.split("|");
	var type = url.substring((url.indexOf("|") == -1 ? 99:url.indexOf("|"))+1); //str[1];
		url = str[0];
	var limitFlag = row.limitFlag;
	var src = url + "?CfgPtId=" + ptId + "&Type=" + type + "&LimitFlag=" + limitFlag;
	if ('undefined' !== typeof websys_getMWToken){
		src += "&MWToken="+websys_getMWToken();
	}
	if ($("iframe").attr("src") != src) {
		$("iframe").attr("src", src);
	}
};

function onContextMenuHandler(e) {
	e.preventDefault();
	
	var target = "rightMenu";
	var $target = $("#" + target);
	if (!$target.length) {
		$target = $("<div id=\"" + target + "\"></div>").appendTo("body");
	}
	
	var menus =  Array.apply(menus, [{
	                    text: '导出',
                        iconCls: 'icon-export',
                        handler: 'exportPointClick'
	                },
	                {
	                    text: '导出配置',
                        iconCls: 'icon-batch-cfg',
                        handler: 'openExportExcel'
	                }
	            ]);
	
	$target.menu().empty();   //需要清空集合
	menus.forEach(function(item, idx) {
		$target.menu("appendItem", {
			text: item.text,
			iconCls: item.iconCls,
			onclick: eval("(" + item.handler + ")")
		});
	});
	$target.menu("show", {
		left: e.pageX,
		top: e.pageY
	});
};

		
/**
* 新增/修改模块
*/
var editModClick = function() {
	var node = GV.ModTree.getSelected();
	var _dicCode = "";
	if (GV.ModTree.getParent(node.target)) {
		_dicCode = GV.ModTree.getParent(node.target).attributes.code;
	}else {
		_dicCode = node.attributes.code;
	}
	if (!_dicCode) {
		return;
	}
	var _opt = {
		iconCls: 'icon-w-add',
		title: '新增'
	};
	var _modId = "";
	if ($(this).find(".menu-icon.icon-write-order").length > 0) {
		_modId = node.attributes.id;
		_opt.iconCls = "icon-w-edit";
		_opt.title = "修改";
	}
	$("#edit-mod-dlg").show();
	var modDlgObj = $HUI.dialog("#edit-mod-dlg", {
			iconCls: _opt.iconCls,
			title: _opt.title,
			draggable: false,
			resizable: false,
			modal: true,
			buttons: [{
					text: '确定',
					handler: function () {
						var bool = true;
						$("#edit-mod-dlg .validatebox-text").each(function(index, item) {
							if (!$(this).validatebox("isValid")) {
								$.messager.popover({msg: "<font color='red'>" + $(this).parents("td").prev().text() + "</font>" + "验证不通过", type: "info"});
								bool = false;
								return false;
							}
						});
						if (!bool) {
							return;
						}
						$.messager.confirm("确认", "是否确认保存？", function(r) {
							if (!r) {
								return;
							}
							// 屏蔽代码和描述的特殊字符
							var code=getValueById("dlg-mod-code");
							var desc=getValueById("dlg-mod-desc");
							code = code.replace(GV.m_RegularExp, '');
							desc = desc.replace(GV.m_RegularExp, '');
							var json = {
								dicCode: _dicCode,
								modId: _modId,
								code: code,
								desc: desc
							};
							$.m({
								ClassName: "BILL.CFG.COM.GeneralCfg",
								MethodName: "SaveProModule",
								jsonStr: JSON.stringify(json)
							}, function(rtn) {
								var myAry = rtn.split("^");
								if (myAry[0] != 0) {
									$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
									setValueById("dlg-mod-code",code);
									setValueById("dlg-mod-desc",desc);
									return;
								}
								GV.ModTree.reload();
								modDlgObj.close();
							});
						});
					}
				}, {
					text: '取消',
					handler: function () {
						modDlgObj.close();
					}
				}
			],
			onBeforeOpen: function() {
				$("#edit-mod-dlg").form("clear");
				
				if (_modId > 0) {
					setValueById("dlg-mod-code", node.attributes.code);
					setValueById("dlg-mod-desc", node.text);
				}
					
				$.extend($.fn.validatebox.defaults.rules, {
					checkModCodeExist: {    //校验代码是否存在
					    validator: function(value) {
						    return $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckModCodeExist", dicCode: _dicCode, modId: _modId, code: $.trim(value)}, false) == 0;
						},
						message: "代码已存在"
					}
				});
				$("#edit-mod-dlg .validatebox-text").each(function() {
					$(this).validatebox("validate");
				});
			}
		});
};

/**
* 新增/修改配置点
*/
var editPointClick = function() {
	var node = GV.ModTree.getSelected();
	if (!GV.ModTree.getParent(node.target)) {
		return;
	}
	GV.dicCode = GV.ModTree.getParent(node.target).attributes.code;
	GV.modCode = node.attributes.code;
	if (!GV.dicCode) {
		return;
	}
	GV.opt = {
		iconCls: 'icon-w-add',
		title: '新增'
	};
	
	var row = GV.CfgPointList.getSelected();
	GV.ptId = "";
	if ($(this).find(".l-btn-icon.icon-write-order").length > 0) {
		GV.ptId = row.id;
		GV.opt.iconCls = "icon-w-edit";
		GV.opt.title = "修改";
	}
	$("#edit-pt-dlg").show();
	ptDlgObj();
};
function openExportExcel(){
	var url = "websys.query.customisecolumn.csp?CONTEXT=KBILL.CFG.COM.GeneralCfg:ExportPointData&PAGENAME=dhcbill.conf.general.main.csp&PREFID=0";
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}
/**
* 导出
*/
function exportPointClick() {
	/* 
	导出逻辑：
		1.如果选中了配置点，则提示是否导出选中的配置点
		2.如果选中的是产品线/模块，则提示是否导出该产品线/模块下所有的配置点
	*/
	debugger;
	var node = GV.ModTree.getSelected();
	
	var row = GV.CfgPointList.getSelected();
	if (row == null){// 未选中配置点
		if (node == null){// 未选中产品线、模块
			$.messager.popover({msg: "请选择产品线、模块或者配置点", type: "error"});
			return;
		}else{// 选中产品线、模块
			if (node.attributes.type == "ProLine"){// 选中的产品线
				$.messager.confirm("确认", "是否导出选中产品线 <font color=red>" + node.text + "</font> 下所有的配置点？", function(r) {
					if(!r) return;
					exportPoint(1,node.attributes.id,"产品线l"+ node.text);
				})
			}else 
			if (node.attributes.type == "ProModule"){// 选中的模块
				$.messager.confirm("确认", "是否导出选中模块 <font color=red>" + node.text + "</font> 下所有的配置点？", function(r) {
					if(!r) return;
					var nodeProline = GV.ModTree.getParent(node.target);
					//exportPoint(2,row.attributes.id,"配置点" + nodeProline.text + " " + node.text);
					exportPoint(2,node.attributes.id,"模块l" + node.text);
				})
			}
		}
	}else{// 选中配置点
		$.messager.confirm("确认", "是否导出选中的配置点 <font color=red>" + row.text + "</font> ？", function(r) {
			if(!r) return;
			var nodeProline = GV.ModTree.getParent(node.target);
			//exportPoint(3,row.id,"配置点 " + nodeProline.text + "\-" + node.text + "-" + row.text);
			exportPoint(3,row.id,"配置点l" + row.text);
		})
	}
	function exportPoint(type,id,fileName){
		$.messager.progress({
			title: "提示",
			msg: '正在导出数据',
			text: '导出中....'
		});
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:fileName,		  
			PageName:"ExportALLData",      
			ClassName:"BILL.CFG.COM.GeneralCfg",
			QueryName:"ExportPointData",
			Type:type,
			ID:id
		},
		function(){
		  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
	}
}
/**
* 导入
*/
function importPointClick() {
	var UserDr = "1";
	var GlobalDataFlg = "0"; //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
	var ClassName = "BILL.CFG.COM.GeneralCfg"; //导入处理类名
	var MethodName = "ImportDicdataByExcel"; //导入处理方法名
	var ExtStrPam = ""; //备用参数()
	//Insuqc_ExcelTool.ExcelImport(ClassName,MethodName,"0",ExtStrPam,UserDr,2,SetDicInfoItem());
	ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,"");		
}
function ptDlgObj(){
	var ptDlgObj=$HUI.dialog("#edit-pt-dlg", {
		iconCls: GV.opt.iconCls,
		title: GV.opt.title,
		draggable: false,
		resizable: false,
		modal: true,
		buttons: [{
			id: 'save',
			text: '保存',
			handler: function () {
				var bool = true;
				$("#edit-pt-dlg .validatebox-text").each(function(index, item) {
					if (!$(this).validatebox("isValid")) {
						$.messager.popover({msg: "<font color=red>" + $(this).parents("td:first").prev().text() + "</font>" + "验证不通过", type: "info"});
						bool = false;
						return false;
					}
				});
				if (!bool) {
					return;
				}
				$.messager.confirm("确认", "是否确认保存？", function(r) {
					if (!r) {
						return;
					}
					var json = {
						dicCode: GV.dicCode,
						modCode: GV.modCode,
						ptId: GV.ptId,
						code: getValueById("dlg-pt-code"),
						desc: getValueById("dlg-pt-desc"),
						linkURL: getValueById("dlg-pt-url"),
						collDataSrc: getValueById("dlg-pt-collDataSrc"),
						collDataSrcQry: getValueById("dlg-pt-collDataSrcQry"),
						collDataSrcDicType: getValueById("dlg-pt-collDataSrcDicType"),
						collDataSrcViewType: getValueById("dlg-pt-dataViewType"),
						collDataSrcMulFlag: getValueById("dlg-pt-dataMulFlag"),
						tgtDataSrc: getValueById("dlg-pt-tgtDataSrc"),
						tgtDataSrcQry: getValueById("dlg-pt-tgtDataSrcQry"),
						tgtDataSrcDicType: getValueById("dlg-pt-tgtDataSrcDicType"),
						isDeleteFlag: "0",//getValueById("dlg-pt-isOneToMany"),
						activeDateFrom: getValueById("dlg-pt-activeDateFrom"),			// 生效开始日期
						activeDateTo: getValueById("dlg-pt-activeDateTo"),				// 生效结束日期
						ctrlLevelDicCode: GV.CtrlLevelDicCode,							// 控制级别
						ctrlLevelRemark: getValueById("dlg-pt-ctrlLevelRemark"),		// 控制文字说明
						updLevelDicCode: getValueById("dlg-pt-updLevelDicCode"),		// 修改级别
						remark: getValueById("dlg-pt-remark"),							// 说明
						collDataSrcQryDicDR:getValueById("dlg-pt-collDataSrcQryDicDR"),	// 源数据Query字典表指针
						tgtDataSrcQryDicDR: getValueById("dlg-pt-tgtDataSrcQryDicDR"),	// 目标数据Query字典表指针
						ctrlType:getValueById("dlg-pt-ctrlType"),						// 控制类型
						resultType:getValueById("dlg-pt-resultType"),					// 结果类型
						publicFlag:getValueById("dlg-pt-publicFlag")					// 是否公用						
					};
					$.m({
						ClassName: "BILL.CFG.COM.GeneralCfg",
						MethodName: "SaveCfgPoint",
						jsonStr: JSON.stringify(json)
					}, function(rtn) {
						var myAry = rtn.split("^");
						if (myAry[0] != 0) {
							$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
							return;
						}
						loadCfgPointList();
						ptDlgObj.close();
					});
				});
			}
		}, {
			id: 'close',
			text: '关闭',
			handler: function () {
				ptDlgObj.close();
			}
		}, {
			id: 'relase',
			text: '发布',
			handler: function () {			
				$.messager.confirm("确认", "发布后无法再修改配置点数据，是否确认发布？", function(r) {
					if (!r) {
						return;
					}
					
					$.m({
						ClassName: "BILL.CFG.COM.GeneralCfg",
						MethodName: "RelaseCfgPoint",
						ID: GV.ptId,
						Relase: "1"
					}, function(rtn) {
						var myAry = rtn.split("^");
						if (myAry[0] != 0) {
							$.messager.popover({msg: "发布失败：" + (myAry[1] || myAry[0]), type: "error"});
							return;
						}
						loadCfgPointList();
						ptDlgObj.close();
					});
				});
			}
		}, {
			id: 'cancel',
			text: '作废',
			handler: function () {
				$.messager.confirm("确认", "废弃后无法再修改、使用配置，是否确认废弃？", function(r) {
					if (!r) {
						return;
					}
					$.m({
						ClassName: "BILL.CFG.COM.GeneralCfg",
						MethodName: "RelaseCfgPoint",
						ID: GV.ptId,
						Relase:"2"
					}, function(rtn) {
						var myAry = rtn.split("^");
						if (myAry[0] != 0) {
							$.messager.popover({msg: "作废失败：" + (myAry[1] || myAry[0]), type: "error"});
							return;
						}
						loadCfgPointList();
						ptDlgObj.close();
					});
				});
			}
		}
	],
	onBeforeOpen: function() {
		$("#edit-pt-dlg").form("clear");
		// 加载前先删除临时变量
		deleteTmpGV();
		// 发布状态 
		$("#dlg-pt-isReleased").combobox({
      			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPIsReleased"+"&ResultSetType=array",
      			valueField: 'value',    
      			textField: 'text',
      			onLoadSuccess: function() {
	      			var Array  = ["dlg-pt-activeDateFrom",		// 生效开始日期
								"dlg-pt-activeDateTo",			// 生效结束日期
								"dlg-pt-desc"					// 名称
								];
					if( getValueById("dlg-pt-isReleased") == "2"){
						setReadOnly(Array);
					}else{
						setEnableOnly(Array);
					}
			}
		});
		// 发布状态 修改其它字段disabled 通用方法
		function changeLabelByRelase(array,id){
			var relaseFlag = getValueById("dlg-pt-isReleased");
			if ( relaseFlag == "新增" || relaseFlag == "0" ){
				if ( id != "" ) enableById(id);
			}else{
				if ( array != ""){
					for(var i=0;i<array.length;i++){
						disableById(array[i]);	
					}
				}
				if ( id != "" ) disableById(id);
			}
		};
		
		// 结果类型
		$("#dlg-pt-resultType").combobox({
			panelHeight: 62,
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPResultType"+"&ResultSetType=array",
			valueField: 'value',    
			textField: 'text',
			editable: false,    
			onChange: function(newValue,oldValue) {
				checkResultTypeRequired();
			},
			onLoadSuccess: function() {
				if(getValueById("dlg-pt-ctrlType") == ""){
					checkResultTypeRequired();
				}
			}
		});
		function checkResultTypeRequired(){
			var ArrayCtrl 	= ["dlg-pt-ctrlType"		// 控制类型
							];
			var ArrayLev 	= ["dlg-pt-ctrlLevelDicCode"	// 控制级别
							];
			if( getValueById("dlg-pt-resultType") == "2"){// 2:返回判断
				openLabel(ArrayCtrl);
				setEnableOnly(ArrayLev);				
			}else{// 1:返回值  空
				closeLabel(ArrayCtrl);
				closeLabel(ArrayLev);
			}
			changeLabelByRelase(ArrayCtrl,"dlg-pt-resultType");
		}
		
		// 控制类型
		$("#dlg-pt-ctrlType").combobox({
			panelHeight: 62,
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPCtrlType"+"&ResultSetType=array",
			valueField: 'value',    
			textField: 'text',
			editable: false
		});
		
		// 描述 回车生成代码
		$("#dlg-pt-desc").keydown(function (e) {
			var key = websys_getKey(e);
			if (key == 13) {
				checkDesc(this.value)
				getCode(this.value);
			}
		});
		
		// 是否公用
		$("#dlg-pt-publicFlag").combobox({
			panelHeight: 62,
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPPublicFlag"+"&ResultSetType=array",
			valueField: 'value',    
			textField: 'text',
			editable: false,
			onLoadSuccess: function() {
				changeLabelByRelase("","dlg-pt-publicFlag");
			}
		});	
		
		
		// 是否支持多选
		$("#dlg-pt-dataMulFlag").combobox({
			panelHeight: 62,
			data: [{value: '1', text: '是'},
				   {value: '0', text: '否'}
				],
			valueField: 'value',
			textField: 'text',
			blurValidValue: true,
			editable: false
		});
		
		// 是否一对多 已作废
		$("#dlg-pt-isOneToMany").combobox({
			panelHeight: 62,
			data: [{value: '1', text: '是'},
				   {value: '0', text: '否'}
				],
			valueField: 'value',
			textField: 'text',
			blurValidValue: true,
			editable: false
		});
		
		//配置URL
		$HUI.linkbutton("#dlg-pt-setUrl", {
			onClick: function () {
				setUrl();
			}
		})
		$("#dlg-pt-collDataSrcQry").validatebox({
			validType: ['checkQrySpec']
		});
		
		// 源数据Query
		$("#dlg-pt-collDataSrcQry").combogrid({
			panelWidth: 1020,
			panelHeight: 300,
			striped: true,
			method: 'GET',
			pagination: true,
			fitColumns: false,
			blurValidValue:true,
			url: $URL + "?ClassName=BILL.CFG.COM.DictionaryCtl&QueryName=QueryDicDataInfo&Type=" + "QUERY",
			idField: 'DefaultValue',
			textField: 'DefaultValue',
			columns: [[{field: 'DefaultValue', title: 'QUERY', width: 300,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
					   {field: 'DicDesc', title: '描述', width: 150},
					   {field: 'DataSrcFilterMode', title: '数据源检索模式', width: 150},
					   {field: 'DataSrcTableProperty', title: '表名||字段名', width: 150,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
					   {field: 'DicMemo', title: '备注', width: 250,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}}
				]],
			onSelect: function(index, row) {
				setValueById("dlg-pt-collDataSrcQryDicDR",row.ID);
			},filter: function(q, row){
				return (row.DicDesc.indexOf(q) != -1||row.DefaultValue.indexOf(q) != -1);
			}

		});

		// 源数据字典
		$("#dlg-pt-collDataSrcDicType").combobox({
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByMode",//&Mode=" + getValueById("dlg-pt-collDataSrc") +"&ResultSetType=array",
			panelHeight: 150,
			valueField: 'code',
			textField: 'text',
			blurValidValue: true,
			mode: 'local',
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) != -1;
			},
			onBeforeLoad: function(param){
				var type = getValueById("dlg-pt-collDataSrc");
				if ((type != "")&&(type != "Query")){
					param.Mode = getValueById("dlg-pt-collDataSrc");
					param.ResultSetType = 'array';
				}else{
					return false;
				}
			},
			onLoadSuccess:function(){
				if(GV.cfgData.CPCollDataSrcDicTypeFlag == ""){
					setValueById("dlg-pt-collDataSrcDicType", GV.cfgData.CPCollDataSrcDicType);
					GV.cfgData.CPCollDataSrcDicTypeFlag = 1;
				}
			}
		});
		
		// 源数据类型
		$("#dlg-pt-collDataSrc").combobox({
			panelHeight: 'auto',
			data: [{value: 'Dictionary', text: '字典'},
				   {value: 'Query', text: 'Query'},
				   {value: 'DicINSU', text: '医保字典'}
				],
			valueField: 'value',
			textField: 'text',
			blurValidValue: true,
			editable: false,
			onChange: function(newValue, oldValue) {
				var Array=["dlg-pt-collDataSrcDicType",	// 源数据字典
							"dlg-pt-collDataSrcQry"		// 源数据Query
							];
				var ArrayDic = ["dlg-pt-collDataSrcDicType"	// 源数据字典
								];
				var ArrayQry = ["dlg-pt-collDataSrcQry"		// 源数据Query
								];
				// 新增判断，如果配置点已配置数据，不允许修改
				if(!checkUpdateFlag()){
					setReadOnly(Array);
					$("#dlg-pt-collDataSrcDicType").combobox('reload');
					return;
				}
				if ((newValue == "Dictionary")||(newValue == "DicINSU")) {
					closeLabel(Array);
					openLabel(ArrayDic);
					$("#dlg-pt-collDataSrcDicType").combobox('reload');
				}else if(newValue == "Query"){
					closeLabel(Array);
					openLabel(ArrayQry);
				}else{
					closeLabel(Array);
				}
				changeLabelByRelase(Array,"");
			},
			onLoadSuccess: function(data) {
				if(getValueById("dlg-pt-collDataSrc") == ""){
					var Array=["dlg-pt-collDataSrcDicType",	// 源数据字典
							"dlg-pt-collDataSrcQry"			// 源数据Query
							];
					closeLabel(Array);
				}
			}
		});
		
		
		
		// 目标数据Query
		$("#dlg-pt-tgtDataSrcQry").combogrid({
			panelWidth: 1020,
			panelHeight: 300,
			striped: true,
			method: 'GET',
			pagination: true,
			fitColumns: true,
			blurValidValue:true,
			url: $URL + "?ClassName=BILL.CFG.COM.DictionaryCtl&QueryName=QueryDicDataInfo&Type=" + "QUERY",
			idField: 'DefaultValue',
			textField: 'DefaultValue',
			columns: [[{field: 'DefaultValue', title: 'QUERY', width: 300,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
					   {field: 'DicDesc', title: '描述', width: 150},
					   {field: 'DataSrcFilterMode', title: '数据源检索模式', width: 150},
					   {field: 'DataSrcTableProperty', title: '表名||字段名', width: 150,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
					   {field: 'DicMemo', title: '备注', width: 250,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}}
				]],
			onSelect: function(index, row) {
				setValueById("dlg-pt-tgtDataSrcQryDicDR",row.ID);
			},filter: function(q, row){
				return (row.DicDesc.indexOf(q) != -1||row.DefaultValue.indexOf(q) != -1);
			}
		});
		// 目标数据字典
		$("#dlg-pt-tgtDataSrcDicType").combobox({
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByMode",//&Mode=" + getValueById("dlg-pt-tgtDataSrc") +"&ResultSetType=array",
			panelHeight: 150,
			valueField: 'code',
			textField: 'text',
			blurValidValue: true,
			mode: 'local',
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) != -1;
			},
			onBeforeLoad: function(param){
				var type = getValueById("dlg-pt-tgtDataSrc");
				if ((type != "")&&(type != "Query")){
					param.Mode = getValueById("dlg-pt-tgtDataSrc");
					param.ResultSetType = 'array';
				}else{
					return false;
				}
			},
			onLoadSuccess:function(){
				if(GV.cfgData.CPTgtDataSrcDicTypeFlag == null){
					setValueById("dlg-pt-tgtDataSrcDicType", GV.cfgData.CPTgtDataSrcDicType);
					GV.cfgData.CPTgtDataSrcDicTypeFlag = 1;
				}
			}
		});
		// 目标数据类型
		$("#dlg-pt-tgtDataSrc").combobox({
			panelHeight: 'auto',
			data: [{value: 'Dictionary', text: '字典'},
				   {value: 'Query', text: 'Query'},
				   {value: 'DicINSU', text: '医保字典'}
				],
			valueField: 'value',
			textField: 'text',
			blurValidValue: true,
			editable: false,
			onChange: function(newValue, oldValue) {
				var Array=["dlg-pt-tgtDataSrcDicType",	// 目标数据字典
							"dlg-pt-tgtDataSrcQry"		// 目标数据Query
							];
				var ArrayDic = ["dlg-pt-tgtDataSrcDicType"	// 目标数据字典
								];
				var ArrayQry = ["dlg-pt-tgtDataSrcQry"		// 目标数据Query
								];
				// 新增判断，如果配置点已配置数据，不允许修改
				if(!checkUpdateFlag()){
					$("#dlg-pt-tgtDataSrcDicType").combobox('reload');
					setReadOnly(Array);
				}else{
					if ((newValue == "Dictionary")||(newValue == "DicINSU")) {
						closeLabel(Array);
						openLabel(ArrayDic);
						$("#dlg-pt-tgtDataSrcDicType").combobox('reload');
					}else if(newValue == "Query"){
						closeLabel(Array);
						openLabel(ArrayQry);
					}else{
						closeLabel(Array);
					}
					changeLabelByRelase(Array,"");
				}
			},
			onLoadSuccess: function(data) {
				if(getValueById("dlg-pt-tgtDataSrc") == ""){
					var Array=["dlg-pt-tgtDataSrcDicType",	// 目标数据字典
							"dlg-pt-tgtDataSrcQry"			// 目标数据Query
							];
					closeLabel(Array);
				}
			}
		});
		
		// 源数据展示形式 
		/*
		源数据展示形式 控制 源数据类型 的开放与否。
		当源数据展示形式为combobox的时候， 源数据类型 可填，否则disabled
		*/
		$("#dlg-pt-dataViewType").combobox({
			panelHeight: 182,
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPDataViewType"+"&ResultSetType=array",
			valueField: 'value',    
			textField: 'text',
			editable: false,
			onChange: function(newValue, oldValue) {
				checkSrcTypeRequired(newValue);
			},
			onLoadSuccess: function(data) {
				if(getValueById("dlg-pt-dataViewType") == ""){
					checkSrcTypeRequired("");
				}
				
			}
		});
		function checkSrcTypeRequired(param){
			var Array 	= ["dlg-pt-tgtDataSrc"	// 目标数据类型
							];
			// 新增判断，如果配置点已配置数据，不允许修改
			if(!checkUpdateFlag()){
				setReadOnly(Array);
				return;
			}
			if(param=="combobox"||param=="datagrid"){
				openLabel(Array);	
			}else{
				closeLabel(Array);
			}
			changeLabelByRelase(Array,"");
		}
		
		$("#dlg-pt-tgtDataSrcQry").validatebox({
			validType: ['checkQrySpec']
		});
		
		// 控制级别
		$("#dlg-pt-ctrlLevelDicCode").combogrid({
			panelWidth: 650,
			panelHeight: 300,
			striped: true,
			method: 'GET',
			pagination: true,
			fitColumns: false,
			editable: false,
			url: $URL + "?ClassName=BILL.CFG.COM.DictionaryCtl&QueryName=QueryDicDataInfo&Type=" + "CPCtrlLevel",
			idField: 'ID',
			textField: 'DicDesc',
			columns: [[{field: 'ID', title: 'ID', width: 1, hidden: true},
					   {field: 'DefaultValue', title: '控制级别', width: 80, hidden: true},
					   {field: 'DicDesc', title: '控制级别', width: 150},
					   {field: 'DataSrcFilterMode', title: '提示内容', width: 150,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
					   {field: 'DicMemo', title: '备注', width: 250,
					   		formatter:function(val,rowData,rowIndex){
          							return '<span title='+val+'>'+val+'</span>';
      						}},
				]],
			onSelect: function(index, row) {
				GV.CtrlLevelDicCode = row.DefaultValue;
				checkCtrlLvRequired(row.DefaultValue);
				if(getValueById("dlg-pt-ctrlLevelRemark") == "")  {setValueById("dlg-pt-ctrlLevelRemark",row.DataSrcFilterMode); }
			},
			onLoadSuccess: function(data) {
				//checkCtrlLvRequired(getValueById("dlg-pt-ctrlLevelDicCode"));	
			}
		});
		function checkCtrlLvRequired(param){
			var Array 	= ["dlg-pt-ctrlLevelRemark"	// 控制文字说明
							];
			// 新增判断，如果配置点已配置数据，不允许修改
			if(!checkUpdateFlag()){
				setReadOnly(Array);
				return;
			}
			if(param != ""){
				openLabel(Array);	
			}else{
				closeLabel(Array);
			}
			changeLabelByRelase(Array,"");
		}

		// 修改级别
		$("#dlg-pt-updLevelDicCode").combobox({
			panelHeight: 92,
			url: $URL + "?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryDicDataByType&dicType=" + "CPUpdLevel"+"&ResultSetType=array",
			valueField: 'value',    
			textField: 'text',
			editable: false,
			onLoadSuccess: function(data) {
				//changeLabelByRelase("","dlg-pt-updLevelDicCode");
				if (GV.ptId != ""){
					disableById("dlg-pt-updLevelDicCode");
				}
			}
		});
		
		// 描述 的光标离开方法
		/*
		$("#dlg-pt-desc").blur(function(){
			getCode(this.value);
		});
		*/
		
		$.extend($.fn.validatebox.defaults.rules, {
			checkPointCodeExist: {    //校验代码是否存在
			    validator: function(value) {
				    return $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckPointCodeExist", dicCode: GV.dicCode, modCode: GV.modCode, ptId: GV.ptId, code: $.trim(value)}, false) == 0;
				},
				message: "代码已存在"
			},
			checkQrySpec: {        //校验query格式
			    validator: function(value) {
				    if (!value) {
					    return true;
					}
					var myAry = $.trim(value).split("||");
					var className = myAry[0] || "";
					var queryName = myAry[1] || "";
					if (!className) {
						return false;
					}
					if (!queryName) {
						return false;
					}
				    return $.m({ClassName: "websys.Conversions", MethodName: "IsValidQueryName", classname: className, queryname: queryName}, false) == 1;
				},
				message: "请输入正确的Query格式：类名||Query名"
			}			
		});
		$("#edit-pt-dlg .validatebox-text").each(function() {
			$(this).validatebox("validate");
		});
		
		//新增、修改配置点-开启数组中的input：可填写
		function openLabel(Array){
			for(var i = 0; i < Array.length; i++){ 
				setRequired(Array[i],true);
				$("#"+Array[i]+"Label").addClass("clsRequired");
				enableById(Array[i]);
			}
		}
		//新增、修改配置点-关闭数组中的input：不可填写，置空
		function closeLabel(Array){
			for(var i = 0; i < Array.length; i++){
				setRequired(Array[i],false);
				/*
				$("#"+Array[i]+"Label").removeClass("clsRequired");
				var idClass = $("#"+Array[i]).attr("class").slice($("#"+Array[i]).attr("class").indexOf("-") + 1,$("#"+Array[i]).attr("class").indexOf(" "));
				switch(idClass){
					case "combobox":
						setValueById(Array[i],'');
						$("#"+Array[i]).combobox('clear');
						break;
					default:
					setValueById(Array[i],'');
				}*/
				setValueById(Array[i],'');
				disableById(Array[i]);
			}
		}
		//新增、修改配置点-关闭数组中的input：不可填写
		function setReadOnly(Array){
			for(var i = 0; i < Array.length; i++){
				disableById(Array[i]);
			}
		}
		//新增、修改配置点-关闭数组中的input：可填写
		function setEnableOnly(Array){
			for(var i = 0; i < Array.length; i++){
				enableById(Array[i]);
			}
		}
		// 将指定元素设置为必填/非必填
		function setRequired(id,boolean){
			var idClass = $("#"+id).attr("class").slice($("#"+id).attr("class").indexOf("-") + 1,$("#"+id).attr("class").indexOf(" "));
			var options;
			switch(idClass){
				case "combogrid":
					options = $("#"+id).combogrid("options");
					options.required = boolean;
					$("#"+id).combogrid(options);
					break;
				case "datebox":
					options = $("#"+id).datebox("options");
					options.required = boolean;
					$("#"+id).datebox(options);
					break;
				case "combobox":
					options = $("#"+id).combobox("options");
					options.required = boolean;
					$("#"+id).combobox(options);
					break;
				default:
			}
		}
		
		//根据描述生成代码
		/*
		function getCode(param){
			if(GV.ptId == ""){
				$.m({
					ClassName: "web.DHCINSUPort",
					MethodName: "GetCNCODE",
					HANZIS: param,
					FLAG:"4"
				}, function(rtn) {
					if (rtn== 0) {
						$.messager.popover({msg: "描述文字异常，请重新输入！", type: "error"});
						return;
					}
					setValueById("dlg-pt-code",rtn);
					getCpCode()
				});
			}
		}*/
		//生成配置点全代码
		function getCpCode(){
			var cpCode = GV.dicCode+"."+GV.modCode+"."+getValueById("dlg-pt-code")
			setValueById("dlg-pt-cpCode", cpCode);	
		}
		
		// 校验描述文字，并去掉特殊字符串
		function checkDesc(param){
			var str = param.replace(GV.m_RegularExp,'');
			setValueById("dlg-pt-desc",str) 
		}
		
		// 检验是否可以修改数据
		function checkUpdateFlag(){
			//Date:2023.03.23 wzh 优化判断逻辑。加载一次以后，存一个全局变量，不再每次判断都取后端数据
			if (typeof GV.checkUpdateFlag == "undefined"){
				if (GV.ptId == "") {// 新增无需判断
					GV.checkUpdateFlag = true;
				}else{
					var flag = $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckCfgRelaExistData", RelaCode: getValueById("dlg-pt-cpCode")}, false)
					if (flag == 1){
						GV.checkUpdateFlag = false;
					}else{
						GV.checkUpdateFlag = true;
					}
				}
			}
			return GV.checkUpdateFlag;			
		}

		//数据加载
		if (GV.ptId > 0) {
			var _ptJson = getPersistClsObj("CF.BILL.COM.CfgPoint", GV.ptId);
			GV.cfgData = _ptJson;
			// 填充核心字段 代码、全代码（由代码生成）   
			setValueById("dlg-pt-code", _ptJson.CPCode);								// 代码
			getCpCode();																// 生成全代码
			
			// 加载 配置点重要属性
			setValueById("dlg-pt-isReleased", _ptJson.CPIsReleased);					// 发布状态	
			
			// 加载无影响字段（不影响其它字段）
			setValueById("dlg-pt-desc", _ptJson.CPDesc);								// 名称
			setValueById("dlg-pt-activeDateFrom", _ptJson.CPActiveDateFrom);			// 生效开始日期
			setValueById("dlg-pt-activeDateTo", _ptJson.CPActiveDateTo);				// 生效结束日期
			setValueById("dlg-pt-updLevelDicCode", _ptJson.CPUpdLevelDicCode);			// 修改级别
			setValueById("dlg-pt-remark", _ptJson.CPRemark);							// 说明
			setValueById("dlg-pt-publicFlag", _ptJson.CPPublicFlag);					// 是否公用
			
			// 填充 结果类型 及其附属字段
			setValueById("dlg-pt-resultType", _ptJson.CPResultType);					// 结果类型
			setValueById("dlg-pt-ctrlType", _ptJson.CPCtrlType);						// 控制类型
			var ctrlLvRtn = $.m({ClassName: "BILL.CFG.COM.DictionaryCtl", MethodName: "getIDByTypeValue", Type: "CPCtrlLevel",Value: _ptJson.CPCtrlLevelDicCode}, false)
			if(ctrlLvRtn.split("^")[0] === "1"){
				setValueById("dlg-pt-ctrlLevelDicCode", ctrlLvRtn.split("^")[1]);		// 控制级别
			}
			
			// 填充 控制级别 附属字段
			setValueById("dlg-pt-ctrlLevelRemark", _ptJson.CPCtrlLevelRemark);			// 提示内容
			
			// 开始填充 配置界面URL ，决定后续字段的disabled属性
			setValueById("dlg-pt-url", _ptJson.CPLinkURL);								// 配置界面URL
			urlConfig();
			// 填充 源数据展示形式 及其附属字段
			setValueById("dlg-pt-dataViewType", _ptJson.CPDataViewType);				// 数据展示形式
			setValueById("dlg-pt-tgtDataSrc", _ptJson.CPTgtDataSrc);					// 目标数据类型
			// 填充 源数据类型 及其附属字段
			setValueById("dlg-pt-collDataSrc", _ptJson.CPCollDataSrc);					// 源数据类型
			setValueById("dlg-pt-collDataSrcQry", _ptJson.CPCollDataSrcQry);			// 源数据Query
			//setValueById("dlg-pt-collDataSrcDicType", _ptJson.CPCollDataSrcDicType);	// 源数据字典
			
			// 填充 目标数据类型 的附属字段
			//setValueById("dlg-pt-tgtDataSrcDicType", _ptJson.CPTgtDataSrcDicType);		// 目标数据字典
			setValueById("dlg-pt-tgtDataSrcQry", _ptJson.CPTgtDataSrcQry);				// 目标数据Query
			
			// 填充 目标数据剩余字段
			setValueById("dlg-pt-dataMulFlag", _ptJson.CPDataMulFlag);					// 是否支持多选
			//setValueById("dlg-pt-isOneToMany", _ptJson.CPIsOneToMany);				// 是否一对多
			
						
			//加载隐藏字段
			setValueById("dlg-pt-collDataSrcQryDicDR", _ptJson.CPCollDataSrcQryDicDR);	// 源数据Query字典表指针
			setValueById("dlg-pt-tgtDataSrcQryDicDR", _ptJson.CPTgtDataSrcQryDicDR);	// 目标数据Query字典表指针
			
			var dlgPtUrlvalStr=getValueById("dlg-pt-url");
			if(dlgPtUrlvalStr != "" && dlgPtUrlvalStr != null && dlgPtUrlvalStr != undefined){
				//urlConfig(dlgPtUrlvalStr);
			}
			// 描述生成代码-修改时描述与代码脱离
			var getCode = function(param){
			}
		}else{
			setValueById("dlg-pt-isReleased", "新增");										// 发布状态	
			enableById("dlg-pt-code");
			enableById("dlg-pt-setUrl");
			// 描述生成代码-新增时根据描述回车生成代码
			var getCode = function(param){
				if(GV.ptId == ""){
					$.m({
						ClassName: "web.DHCINSUPort",
						MethodName: "GetCNCODE",
						HANZIS: param,
						FLAG:"4"
					}, function(rtn) {
						if (rtn== 0) {
							$.messager.popover({msg: "描述文字异常，请重新输入！", type: "error"});
							return;
						}
						setValueById("dlg-pt-code",rtn);
						getCpCode()
					});
				}
			}
			//url为空的时候，数据展示形式、源数据类型、是否支持多选置灰，不可填。
			var Array 	= ["dlg-pt-dataViewType",			// 数据展示形式
							"dlg-pt-dataMulFlag",			// 是否支持多选
							"dlg-pt-collDataSrc"			// 源数据类型
							];
					
			closeLabel(Array);	
		}
		// 加载完数据以后，根据 发布状态 屏蔽按钮
		if (getValueById("dlg-pt-isReleased") == "新增"){// 新增去掉 发布、作废按钮
			$('#relase').remove();
			$('#cancel').remove();
		}else 
		if (getValueById("dlg-pt-isReleased") == "0"){// 未发布 去掉 作废按钮
			$('#cancel').remove();
		}else 
		if (getValueById("dlg-pt-isReleased") == "1"){// 已发布 去掉 发布按钮
			$('#relase').remove();
		}else 
		if (getValueById("dlg-pt-isReleased") == "2"){// 已作废 去掉 保存、发布、作废按钮
			$('#save').remove();
			$('#relase').remove();
			$('#cancel').remove();
		}
					
		
		// 配置URL
		function setUrl(){
			var url=getValueById('dlg-pt-url');
			websys_showModal({			
				url: "dhcbill.conf.general.seturl.csp?url=" + url + "&MWToken="+websys_getMWToken(),
				title: "配置URL",
				iconCls: "icon-w-edit",
				width: "650",
				height: "550",
				CallBackFunc:function(url,flag){
					if (flag){
						var urlOld = getValueById("dlg-pt-url");
						setUrlValue(url);
						// 如果csp一致则不变更
						if (urlOld.split("|")[0] != url.split("|")[0]){
							urlConfig();
						}
					}
					websys_showModal("close");
				}
			})
		}
		function setUrlValue(url){
			setValueById('dlg-pt-url',url);
		}
		function urlConfig(){
			var url = getValueById("dlg-pt-url");
			var flag = url.split(".")[3];	
			var Array 	= ["dlg-pt-dataViewType",			// 数据展示形式
							"dlg-pt-dataMulFlag",			// 是否支持多选
							"dlg-pt-collDataSrc"			// 源数据类型
							];
							
			var ArrayDataViewType = ["dlg-pt-dataViewType"];		// 数据展示形式				
			var ArrayCollDataSrc= ["dlg-pt-collDataSrc",			// 源数据类型			
									"dlg-pt-dataMulFlag"];				
			
			var ArrayTgtDataSrc = ["dlg-pt-dataMulFlag"];			// 目标数据类型
												
			
			// 新增判断，如果配置点已配置数据，不允许修改
			// Date:2023.04.20	发布、作废状况下不允许修改 dlg-pt-isReleased
			if((!checkUpdateFlag())||(getValueById("dlg-pt-isReleased") == "1" || getValueById("dlg-pt-isReleased") == "2")){
				setReadOnly(Array);
				disableById("dlg-pt-setUrl");
				//disableById("dlg-pt-url");
				return;
			}else{
				enableById("dlg-pt-setUrl");
			}
			if(flag == ""){
				closeLabel(Array);
				return ;
			}
			if(flag != "basic" && flag != "coll" && flag != "cont" ){
				closeLabel(Array);
				$.messager.popover({msg:"所选CSP配置错误，应为\"值\"、\"集合\"\"对照\"的一种！", type: "info",delay:{hide:20000}});
				return ;
			}				
			if(flag=="basic"){//值
			//数据展示形式：可选;dlg-pt-dataViewType
			//源数据类型-不可选;dlg-pt-collDataSrc
			//目标数据类型-不可选;只有数据展示形式=combobox，目标数据类型放开dlg-pt-tgtDataSrc
				openLabel(ArrayDataViewType);
				closeLabel(ArrayCollDataSrc);
				var dataViewTypeVal=getValueById("dlg-pt-dataViewType");
				if(dataViewTypeVal && dataViewTypeVal=="combobox"){
					openLabel(ArrayTgtDataSrc);
				}else{
					closeLabel(ArrayTgtDataSrc);
				}
			}else if(flag=="coll"){// 集合
			//数据展示形式：不可选 直接赋值 datagrid;
			//源数据类型-不可选;
			//目标数据类型-可选
				closeLabel(ArrayDataViewType);
				setValueById("dlg-pt-dataViewType", "datagrid");
				closeLabel(ArrayCollDataSrc);
				openLabel(ArrayTgtDataSrc);
			}else if(flag=="cont"){// 对照
			//数据展示形式：不可选 直接赋值 datagrid;
			//源数据类型-可选;
			//目标数据类型-可选;
				closeLabel(ArrayDataViewType);
				setValueById("dlg-pt-dataViewType", "datagrid");
				openLabel(ArrayCollDataSrc);
				openLabel(ArrayTgtDataSrc);	
			}
			changeLabelByRelase(Array,"");
		}
		// 删除临时变量
		function deleteTmpGV(){
			delete GV.checkUpdateFlag;	// 检查是否可以修改数据
			delete GV.cfgData;			// 
			GV.cfgData = {}
			
		}
	}
	});
}
$(init);

