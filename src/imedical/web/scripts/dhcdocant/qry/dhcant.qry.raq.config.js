/**
 * dhcant.qry.raq.config.js - KJ QRY Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2017-2018 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-05-02
 * 
 */
$(function(){
	ANT.initCheckboxSetting("#i-active");
	ANT.initEasyUIPage(17,[10,17,30,40,50]);
	$('#i-beType').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.QRY.Config.RAQ";
			param.QueryName="QryCommonType";
			param.ModuleName="combobox";
			param.Arg1= "CFGNAME";
			param.Arg2= "";
			param.ArgCnt=2;
		},
		onSelect:function(record){
			$("#i-cfgType").val(""); // added by ws@20200207 这一行为了清空配置类型
			var $raqGrid = $("#i-raqGrid");
			if (record.id == "DATA") {
				setTypeCfg("#i-cfgType", record.id, "DATATYPE", "");
				showColumn($raqGrid);
			} else {
				removeValueCfg("#i-cfgType");
				if (record.id == "PDI") {
					showPDIColumn($raqGrid);
				} else if (record.id == "PBI") {
					showPBIColumn($raqGrid);
				} 
				else if (record.id == "FUNC") {
					hiddenColumn($raqGrid);
				} else {
					showColumn($raqGrid);
				};
			};
			// added by ws@20200207 这一行为了清空配置类型,配置数值,配置描述,重置激活选矿(不激活)
			$("#i-cfgType").val("");$("#i-cfgValue").val("");$("#i-cfgDesc").val("");$("#i-active").iCheck('uncheck');
			loadRaqGrid();
		},
		onUnselect:function(row) {
			removeValueCfg("#i-cfgType");
			loadRaqGrid();
		}
		
	});
    
    $('#i-raqGrid').simpledatagrid({
	    singleSelect:true,
        pagination:true,
		rownumbers:false,
		queryParams: {
			ClassName:"DHCAnt.QRY.Config.RAQ",
			QueryName:"QryCommonData",
			ModuleName:"datagrid",
			Arg1:"",
			Arg2:"",
			ArgCnt:2
		},
		columns:[[
			{field:'rowId',title:'ID',width:50,hidden:true},
			{field:'curBeType',title:'所属类型',width:100},
			{field:'curCfgType',title:'配置类型',width:100},
			{field:'curCfgValue',title:'配置数值',width:120},
			{field:'curCfgDesc',title:'配置描述',width:250},
			{field:'curActive',title:'是否激活',width:60},
			{field:'curCfgExtendA',title:'备注',width:100,hidden:true}

		]],
		onSelect:function(rowIndex, rowData){
			//if ((rowData.curCfgExtendB == "PBI") || (rowData.curCfgExtendB == "PDI")) {
				//$(this).simpledatagrid("clearSelections");
				//return false;
			//};
			if ((rowData.curCfgExtendB != "PBI") && (rowData.curCfgExtendB != "PDI")) {
				$("#i-beType").simplecombobox("setValue",rowData.curBeType);
				var beType = $('#i-beType').simplecombobox('getValue');
				$("#i-beType").simplecombobox("disable");
				if (beType == "DATA") {
					$('#i-cfgType').simplecombobox('setValue',rowData.curCfgType);
					$('#i-cfgType').simplecombobox("disable");
				} else {
					$('#i-cfgType').val(rowData.curCfgType);
				};
				$("#i-cfgValue").val(rowData.curCfgValue);
				$("#i-cfgDesc").val(rowData.curCfgDesc);
				if(rowData.curActive == 'Y'){
					//$('#i-active').attr('checked','checked'); 
					$("#i-active").iCheck('check'); 
				} else {
					//$('#i-active').removeAttr('checked'); 
					$("#i-active").iCheck('uncheck'); 
				};
			};
		},
		onUnselect: function(rowIndex, rowData) {
			//if ((rowData.curCfgExtendB == "PBI") || (rowData.curCfgExtendB == "PDI")) {
			//	$(this).simpledatagrid("clearSelections");
			//	return false;
			//};
			if ((rowData.curCfgExtendB != "PBI") && (rowData.curCfgExtendB != "PDI")) {
				$("#i-beType").simplecombobox("enable");
				if ($("#i-beType").simplecombobox('getValue') == "DATA") {
					$('#i-cfgType').simplecombobox("enable");
					$('#i-cfgType').simplecombobox("setValue","");
				} else {
					$('#i-cfgType').val("");
				};
				$("#i-beType").simplecombobox("setValue","");
				$("#i-cfgValue").val("");
				$("#i-cfgDesc").val("");
				//$('#i-active').removeAttr('checked'); 
				$("#i-active").iCheck('uncheck'); 
			};
			
		},
		onLoadSuccess: function() {// added by ws@20200207 注释掉全选按钮
			$("#i-list .datagrid-header-check").html("");
		}
    });
	var pager = $('#i-raqGrid').datagrid('getPager'); 
	$(pager).pagination({ 
        pageSize: 17,
        pageList: [5,17,30],
        beforePageText: '第',
        afterPageText: '页    共 {pages} 页', 
        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
		onSelectPage: function(pageNo, pageSize) {
			reloadRaqGrid(pageNo, pageSize);
			//clearBaseText();
			//setRowNumbers(50);
		}
    }); 
	
	///添加
	$("#i-btn-save").on('click', function(){
			var beType = $('#i-beType').simplecombobox('getValue')||"";
			if(beType == ""){
				layer.alert("所属类型不能为空...", {title:'提示',icon: 0}); 
				return false;
			};
			if (beType == "PBI") {
				var dialogStr = drawDOMNode("PBI");
				var $dialogStr = $(dialogStr);
				$("#i-list").append($dialogStr);
				drawPBIDialog("add");
				
				$('#i-pbi-add').window({
					title: '添加病人信息',
					modal: true,
					minimizable:false,
					iconCls:'fa fa-plus-circle',
					maximizable:false,
					collapsible:false,
					onClose: function () {
						$("#i-pbi-add").window('destroy');
						$dialogStr.remove();
					}
				});
				$("#i-pbi-add-save").on('click', function(){
					var para = getPBIData("^", "add");
					if (!para) return false;
					var rtn = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSavePBICfgData",para,"^");
					if (rtn == 0) {
						layer.alert("表里已存在，不需要添加...", {title:'提示',icon: 0}); 
						return false;
					}
					if (rtn == "-1") {
						layer.alert("添加失败...", {title:'提示',icon: 2}); 
						return false;
					}
					layer.alert("添加成功...", {title:'提示',icon: 1}); 
					$('#i-pbi-add').window('close');
					var pgOptions = $(pager).pagination("options");
					var pageNumber = pgOptions.pageNumber;
					var pageSize = pgOptions.pageSize;
					reloadRaqGrid(pageNumber, pageSize);
					return false;
				});
				
			} else if (beType == "PDI") {
				var dialogStr = drawDOMNode("PDI");
				var $dialogStr = $(dialogStr);
				$("#i-list").append($dialogStr);
				drawPDIDialog("add");
				$('#i-pdi-add').window({
					title: '添加科室信息',
					modal: true,
					minimizable:false,
					iconCls:'fa fa-plus-circle',
					maximizable:false,
					collapsible:false,
					onClose: function () {
						$("#i-pdi-add").window('destroy');
						$dialogStr.remove();
					}
				});
				$("#i-pdi-add-save").on('click', function(){
					var para = getPDIData("^", "add");
					if (!para) return false;
					var rtn = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSavePDICfgData",para,"^");
					if (rtn == 0) {
						layer.alert("表里已存在，不需要添加...", {title:'提示',icon: 0}); 
						return false;
					}
					if (rtn == "-1") {
						layer.alert("添加失败...", {title:'提示',icon: 2}); 
						return false;
					}
					layer.alert("添加成功...", {title:'提示',icon: 1}); 
					$('#i-pdi-add').window('close');
					var pgOptions = $(pager).pagination("options");
					var pageNumber = pgOptions.pageNumber;
					var pageSize = pgOptions.pageSize;
					reloadRaqGrid(pageNumber, pageSize);
					return false;
				});
				
			} else {
				if (beType == "DATA") {
					var cfgType = $('#i-cfgType').simplecombobox('getValue')||"";
				}else {
					var cfgType = $.trim($('#i-cfgType').val());
				}
				var cfgDesc = $.trim($("#i-cfgDesc").val());
				var cfgValue = $.trim($("#i-cfgValue").val());
				var active = $('#i-active').is(':checked')?"Y":"N";
				
				if(cfgType == ""){
					layer.alert("配置类型不能为空...", {title:'提示',icon: 0}); 
					return false;
				};
				
				var paraStr = "^" + beType + "^" + cfgType + "^" + cfgDesc + "^" + cfgValue + "^" + active;
								
	            // added by ws@20191205  判断数据库中是否已存在，防止重复插入（根据 beType,cfgType,cfgDesc,cfgValue 判断）
	            var queryData = $cm({
	            	ClassName:"DHCAnt.QRY.Config.RAQ",
	            	QueryName:"QryCommonData",
	                ResultSetType: "array",
	                beType:beType,
	                cfgType:cfgType,
	                cfgDesc:cfgDesc,
	                cfgValue:cfgValue,
	                // ArgCnt:4 // 不知道这个是啥？
	            },false);
	            queryData = queryData || [];
	            if(queryData && queryData.length>0) {
	            	var flag = false;
	            	for(var i=0; i<queryData.length; i++) {
	            		if(queryData[i].curCfgDesc==cfgDesc && queryData[i].curCfgValue==cfgValue){
	            			flag = true;
	            		}
	            	}
	            	if(flag) {
	            		layer.alert("表里已存在，不需要添加...", {title:'提示',icon: 0});
	            		return false;
	            	}
	            }
	            
				
				var result = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSaveRAQConfig",paraStr,"^");
				if (result < "0") {
					layer.alert("添加失败...", {title:'提示',icon: 5}); 
					return false;
				};
				layer.alert("添加成功...", {title:'提示',icon: 6}); 
				//$("#i-btn-clear").trigger("click");
				$("#i-cfgValue").val("");
				$("#i-cfgDesc").val("");
				$("#i-active").iCheck('uncheck'); 
				//$('#i-raqGrid').datagrid('reload');
				reloadRaqGrid();
				return false;
			};
			
	});
	
	$("#i-btn-search").on('click', function(){
		loadRaqGrid();
		return false;
	});
	
	//修改
	$("#i-btn-update").on('click', function(){
	 	var selected = $('#i-raqGrid').simpledatagrid('getSelected');
		if (!selected){
			layer.alert("请选择一行...", {title:'提示',icon: 0}); 
			return false;
		};
		var beType = $("#i-beType").simplecombobox("getValue");
		
		if (beType == "PBI") {
			var dialogStr = drawDOMNode("PBI");
			var $dialogStr = $(dialogStr);
			$("#i-list").append($dialogStr);
			drawPBIDialog("update", selected);
			
			$('#i-pbi-add').window({
				title: '修改病人信息',
				modal: true,
				minimizable:false,
				iconCls:'fa fa-pencil',
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-pbi-add").window('destroy');
					$dialogStr.remove();
				}
			});
			$("#i-pbi-add-save").on('click', function(){
				var para = getPBIData("^", "update");
				if (!para) return false;
				var rtn = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSavePBICfgData",para,"^");
				if (rtn == 0) {
					//layer.alert("表里没有改记录...", {title:'提示',icon: 0});
					layer.alert("表里没有该记录...", {title:'提示',icon: 0});//ws@20200210把"改"改为"该"
					return false;
				}
				if (rtn == "-1") {
					layer.alert("修改失败...", {title:'提示',icon: 2}); 
					return false;
				}
				layer.alert("修改成功...", {title:'提示',icon: 1}); 
				$('#i-pbi-add').window('close');
				var pgOptions = $(pager).pagination("options");
				var pageNumber = pgOptions.pageNumber;
				var pageSize = pgOptions.pageSize;
				
				reloadRaqGrid(pageNumber,pageSize);
				return false;
			});
		} else if (beType == "PDI") {
			var dialogStr = drawDOMNode("PDI");
			var $dialogStr = $(dialogStr);
			$("#i-list").append($dialogStr);
			drawPDIDialog("update", selected);
			
			$('#i-pdi-add').window({
				title: '修改科室信息',
				modal: true,
				minimizable:false,
				iconCls:'fa fa-pencil',
				maximizable:false,
				collapsible:false,
				onClose: function () {
					$("#i-pdi-add").window('destroy');
					$dialogStr.remove();
				}
			});
			$("#i-pdi-add-save").on('click', function(){
				var para = getPDIData("^", "update");
				if (!para) return false;
				var rtn = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSavePDICfgData",para,"^");
				if (rtn == 0) {
					//layer.alert("表里没有改记录...", {title:'提示',icon: 0});
					layer.alert("表里没有该记录...", {title:'提示',icon: 0});//ws@20200210把"改"改为"该"
					return false;
				}
				if (rtn == "-1") {
					layer.alert("修改失败...", {title:'提示',icon: 2}); 
					return false;
				}
				layer.alert("修改成功...", {title:'提示',icon: 1}); 
				$('#i-pdi-add').window('close');
				var pgOptions = $(pager).pagination("options");
				var pageNumber = pgOptions.pageNumber;
				var pageSize = pgOptions.pageSize;
				
				reloadRaqGrid(pageNumber,pageSize);
				return false;
			});
		} else {
			if (beType == "DATA") {
				var cfgType = $("#i-cfgType").simplecombobox("getValue");
			} else {
				var cfgType = $("#i-cfgType").val();
			};
			var cfgDesc = $("#i-cfgDesc").val();
			var cfgValue = $("#i-cfgValue").val();
			var active = $('#i-active').is(':checked')?"Y":"N";
			
			var paraStr = selected.rowId + "^" + beType + "^" + cfgType + "^" + cfgDesc
						 + "^" + cfgValue + "^" + active;
			
			// added by ws@20200220 修改时配置类型不能为空
			if(cfgType == ""){
				layer.alert("配置类型不能为空...", {title:'提示',icon: 0}); 
				return false;
			};
			
			// added by ws@20200207  判断数据库中是否已存在，防止修改出两个相同的数据（根据 beType,cfgType,cfgDesc,cfgValue,rowId 判断）
			var queryData = $cm({
				ClassName:"DHCAnt.QRY.Config.RAQ",
				QueryName:"QryCommonData",
				ResultSetType: "array",
				beType:beType,
				cfgType:cfgType,
				cfgDesc:cfgDesc,
				cfgValue:cfgValue,
				// ArgCnt:4 // 不知道这个是啥？
			},false);
			queryData = queryData || [];
			if(queryData && queryData.length>0) {
				var flag = false;
				for(var i=0; i<queryData.length; i++) { // 比新增时的判断多了个 rowId
					if(queryData[i].curCfgDesc==cfgDesc && queryData[i].curCfgValue==cfgValue  &&  selected.rowId!=queryData[i].rowId){
						flag = true;
					}
				}
				if(flag) {
					layer.alert("数据重复，请检查是否填写错误...", {title:'提示',icon: 0});
					return false;
				}
			}
			
			var result = $.InvokeMethod("DHCAnt.QRY.Config.RAQ","DBSaveRAQConfig",paraStr,"^");
			if (result < "0") {
				layer.alert("更新失败...", {title:'提示',icon: 5}); 
				return false;
			};
			layer.alert("更新成功...", {title:'提示',icon: 6}); 
			$("#i-beType").simplecombobox("enable");
			if ($("#i-beType").simplecombobox('getValue') == "DATA") {
				$('#i-cfgType').simplecombobox("enable");
			}
			$("#i-cfgValue").val("");
			$("#i-cfgDesc").val("");
			//$('#i-active').removeAttr('checked'); 
			$("#i-cfgType").val(""); // added by ws@20191204 这一行为了清空配置类型
			$("#i-active").iCheck('uncheck'); 
			var pgOptions = $(pager).pagination("options");
			var pageNumber = pgOptions.pageNumber;
			var pageSize = pgOptions.pageSize;
			reloadRaqGrid(pageNumber,pageSize);
			return false;
		};
		
		
	});
	
	$("#i-btn-clear").on('click', function(){
		$("#i-beType").simplecombobox("enable");
		if ($("#i-beType").simplecombobox('getValue') == "DATA") {
			$('#i-cfgType').simplecombobox("enable");
			$('#i-cfgType').simplecombobox("setValue","");
		} else {
			$('#i-cfgType').val("");
		};
		$("#i-beType").simplecombobox("setValue","");
		$("#i-cfgValue").val("");
		$("#i-cfgDesc").val("");
		//$('#i-active').removeAttr('checked'); 
		$("#i-active").iCheck('uncheck'); 
		$('#i-raqGrid').simpledatagrid("clearSelections");
		//reloadRaqGrid();
		return false;
	});
	
	var browserType = ANT.getBrowserType();
	var hiddenColumn = function (jq) {
		jq.datagrid("setColumnTitle",{field:'curCfgValue',text:'执行函数'})
			.datagrid("setColumnTitle",{field:'curCfgDesc',text:'函数说明'})
			.datagrid("setColumnTitle",{field:'curCfgType',text:'执行M名'})
			.datagrid("setColumnTitle",{field:'curActive',text:'是否激活'})
			.datagrid("hideColumn","curCfgExtendA")
			.datagrid("hideColumn","rowId")
			.datagrid("hideColumn","curBeType");
	};
	var showColumn = function (jq) {
		jq.datagrid("setColumnTitle",{field:'curCfgValue',text:'配置数值'})
			.datagrid("setColumnTitle",{field:'curBeType',text:'所属类型'})
			.datagrid("setColumnTitle",{field:'curCfgDesc',text:'配置描述'})
			.datagrid("setColumnTitle",{field:'curCfgType',text:'配置类型'})
			.datagrid("setColumnTitle",{field:'curActive',text:'是否激活'})
			.datagrid("hideColumn","curCfgExtendA")
			.datagrid("hideColumn","rowId")
			.datagrid("showColumn","curBeType");
	};
	var showPDIColumn = function (jq) {
		jq.datagrid("setColumnTitle",{field:'curBeType',text:'编码'})
			.datagrid("setColumnTitle",{field:'curCfgType',text:'取值标志'})
			.datagrid("setColumnTitle",{field:'curCfgValue',text:'取值函数'})
			.datagrid("setColumnTitle",{field:'curCfgDesc',text:'描述'})
			.datagrid("setColumnTitle",{field:'curActive',text:'时间属性'})
			.datagrid("setColumnTitle",{field:'curCfgExtendA',text:'就诊类型'})
			.datagrid("showColumn","rowId")
			.datagrid("showColumn","curCfgExtendA");
	};
	var showPBIColumn = function (jq) {
		jq.datagrid("setColumnTitle",{field:'curBeType',text:'编码'})
			.datagrid("setColumnTitle",{field:'curCfgType',text:'取值标志'})
			.datagrid("setColumnTitle",{field:'curCfgValue',text:'取值函数'})
			.datagrid("setColumnTitle",{field:'curCfgDesc',text:'描述'})
			.datagrid("setColumnTitle",{field:'curActive',text:'时间属性'})
			.datagrid("setColumnTitle",{field:'curCfgExtendA',text:'自然属性'})
			.datagrid("showColumn","rowId")
			.datagrid("showColumn","curCfgExtendA");
	};
	var setTypeCfg = function (selector, type, arg1, arg2) {
		if (type === "DATA") {
			$(selector).css('display','none');
			$(selector).simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryCommonType";
					param.ModuleName="combobox";
					param.Arg1= arg1;
					param.Arg2= "";
					param.ArgCnt=2;
				}
			});
			
			$('.combo-arrow').css('display','');
			if (browserType == "Chrome") {
				$(selector).next().children("input:first-child").css('width', '135');
			}
		} else {
			$(selector).next().remove();
			$(selector).css('display','');
		}
	};
	
	var removeValueCfg = function (selector) {
		$(selector).next().remove();
		$(selector).css('display','');
		$(selector).removeAttr('comboname');
		$(selector).attr('name','value');
		$(selector).removeClass('combobox-f').removeClass('combo-f');
	};
	var clearBaseText = function () {
		$("#i-cfgValue").val("");
		$("#i-cfgDesc").val("");
	};
	var setRowNumbers = function(time) {
		window.setTimeout(function() {
			var start = (pageNo - 1) * pageSize; 
			var end = start + pageSize; 
			var rowNumbers = $('.datagrid-cell-rownumber');
			$(rowNumbers).each(function(index){
				var row = parseInt($(rowNumbers[index]).html()) + parseInt(start);
				$(rowNumbers[index]).html("");
				$(rowNumbers[index]).html(row);
			});
		}, time);
	};
	var reloadRaqGrid = function (pageNumber, pageSize) {
		var arg1 = $("#i-beType").simplecombobox('getValue')||"",
			arg2 = "",
			arg3 = $("#i-cfgValue").val(),
			arg4 = $("#i-cfgDesc").val();
		if (arg1 == "DATA") {
			arg2 = $('#i-cfgType').simplecombobox('getValue')||"";
		} else {
			arg2 = $('#i-cfgType').val();
		};
		if (!pageNumber) {
			pageNumber = pageSize = "";
		};
		$('#i-raqGrid').simpledatagrid("clearSelections");
		$('#i-raqGrid').simpledatagrid("reload",{
			ClassName:"DHCAnt.QRY.Config.RAQ",
			QueryName:"QryCommonData",
			ModuleName:"datagrid",
			Arg1:arg1,
			Arg2:arg2,
			Arg3:arg3,
			Arg4:arg4,
			rows2:pageSize,
			page2:pageNumber,
			ArgCnt:4
			
		});
	};
	
	var getPBIData = function (sp, action) {
		var id = "";
		if (action == "update") {
			id = $.trim($("#i-pbi-add-id").val());
		};
		var code = $.trim($("#i-pbi-add-code").val());
		var desc = $.trim($("#i-pbi-add-desc").val());
		var interFlag = $("#i-pbi-add-interflag").simplecombobox('getValue')||"";
		var dateFlag = $("#i-pbi-add-dateflag").simplecombobox('getValue')||"";
		var nature = $("#i-pbi-add-natrue").localcombobox("getValue")||"";
		var func = $.trim($("#i-pbi-add-function").val());
		if (code == "") {
			layer.alert("配置代码不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (desc == "") {//added by ws@20200227
			layer.alert("配置描述不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (interFlag == "") {
			layer.alert("取值标志不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (nature == "") {
			layer.alert("自然属性不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (dateFlag == "") {
			layer.alert("时间属性不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (func == "") {
			layer.alert("取值函数不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		var para = id + sp + code + sp + desc + sp + interFlag + sp + dateFlag + sp + nature + sp + func
		return para;
	};
	
	var getPDIData = function (sp, action) {
		var id = "";
		if (action == "update") {
			id = $.trim($("#i-pdi-add-id").val());
		};
		var code = $.trim($("#i-pdi-add-code").val());
		var desc = $.trim($("#i-pdi-add-desc").val());
		var interFlag = $("#i-pdi-add-interflag").simplecombobox('getValue')||"";
		var dateFlag = $("#i-pdi-add-dateflag").simplecombobox('getValue')||"";
		var admtype = $("#i-pdi-add-admtype").localcombobox("getValue")||"";
		var func = $.trim($("#i-pdi-add-function").val());
		if (code == "") {
			layer.alert("配置代码不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (desc == "") {//added by ws@20200210
			layer.alert("配置描述不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (interFlag == "") {
			layer.alert("取值标志不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (admtype == "") {
			layer.alert("就诊类型不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (dateFlag == "") {
			layer.alert("时间属性不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		if (func == "") {
			layer.alert("取值函数不能为空...", {title:'提示',icon: 0}); 
			return false;
		};
		var para = id + sp + code + sp + desc + sp + interFlag + sp + dateFlag + sp + admtype + sp + func
		return para;
	};
	
	var drawPBIDialog = function (action, rowObj) {
		$("#i-pbi-add-function").tooltip({content:'取值函数需要和m里方法匹配',position:'right'});//added@20200317 添加个提示
		if (action == "add") {
			$("#i-pbi-add-natrue").localcombobox({
				//disabled: true,
				data: [{id: 'RF', text: '更新(RF)'}, {id: 'AF',text: '累计(AF)'}]
				//value: admType
				,editable:false//added by ws@20200227不允许手工输入
			});
			
			$("#i-pbi-add-interflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryInterFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
				,editable:false//added by ws@20200227不允许手工输入
			});
			
			$("#i-pbi-add-dateflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryDateFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
				,editable:false//added by ws@20200227不允许手工输入
			});
			//added by ws@20200227新增时可以修改code
			$("#i-pbi-add-code").removeAttr("disabled");$("#i-pbi-add-code").removeAttr("readonly");
		} else {
			$("#i-pbi-add-function").val(rowObj.curCfgValue);
			$("#i-pbi-add-code").val(rowObj.curBeType);
			$("#i-pbi-add-desc").val(rowObj.curCfgDesc);
			$("#i-pbi-add-id").val(rowObj.rowId);
			//added by ws@20200227修改时不能修改code
			$("#i-pbi-add-code").attr("disabled","disabled");$("#i-pbi-add-code").attr("readonly",true);
			$("#i-pbi-add-natrue").localcombobox({
				data: [{id: 'RF', text: '更新(RF)'}, {id: 'AF',text: '累计(AF)'}],
				value: rowObj.curCfgExtendA
				,editable:false//added by ws@20200227不允许手工输入
			});
			
			$("#i-pbi-add-interflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryInterFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				value: rowObj.curCfgType
				,editable:false//added by ws@20200227不允许手工输入
			});
			
			$("#i-pbi-add-dateflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryDateFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				value: rowObj.curActive
				,editable:false//added by ws@20200227不允许手工输入
			});
		};
		
			
	};
	
	var drawPDIDialog = function (action, rowObj) {
		$("#i-pdi-add-function").tooltip({content:'取值函数需要和m里方法匹配',position:'right'});//added@20200317 添加个提示
		if (action == "add") {
			$("#i-pdi-add-admtype").localcombobox({
				data: [{id: 'I', text: '住院'}],
				value: "I",editable:false//added by ws@20200210不允许手工输入
			});
			
			$("#i-pdi-add-interflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryInterFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},editable:false//added by ws@20200210不允许手工输入
			});
			
			$("#i-pdi-add-dateflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryDateFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},editable:false//added by ws@20200210不允许手工输入
			});
			//added by ws@20200210新增时可以修改code
			$("#i-pdi-add-code").removeAttr("disabled");$("#i-pdi-add-code").removeAttr("readonly");
		} else {
			$("#i-pdi-add-function").val(rowObj.curCfgValue);
			$("#i-pdi-add-code").val(rowObj.curBeType);
			$("#i-pdi-add-desc").val(rowObj.curCfgDesc);
			$("#i-pdi-add-id").val(rowObj.rowId);
			$("#i-pdi-add-admtype").localcombobox({
				data: [{id: 'I', text: '住院'}],
				value: "I" 
				,editable:false//added by ws@20200210不允许手工输入
			});
			
			$("#i-pdi-add-interflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryInterFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				value: rowObj.curCfgType
				,editable:false//added by ws@20200210不允许手工输入
			});
			
			$("#i-pdi-add-dateflag").simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.QRY.Config.RAQ";
					param.QueryName="QryDateFlag";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				value: rowObj.curActive
				,editable:false//added by ws@20200210不允许手工输入
			});
			//added by ws@20200210修改时不能修改code
			$("#i-pdi-add-code").attr("disabled","disabled");$("#i-pdi-add-code").attr("readonly",true);
		};
	};
	
	var drawDOMNode = function (type) {
		var dialogStr = "";
		if ( type == "PBI") {
			dialogStr = "<div id='i-pbi-add' class='c-dialog container'>" +
					"<input id='i-pbi-add-id' type='hidden' name='id' />" +
					"<div class='row'>"  +
						"<div class='col-xs-6'><span class='c-span'>配置代码</span><input id='i-pbi-add-code' type='text' /></div>" +
						"<div class='col-xs-6'><span class='c-span'>配置描述</span><input id='i-pbi-add-desc' type='text' /></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-6'><span class='c-span'>取值标志</span><input id='i-pbi-add-interflag' type='text'/></div>" +
						"<div class='col-xs-6'><span class='c-span'>自然属性</span><input id='i-pbi-add-natrue' type='text' /></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-6'><span class='c-span'>时间属性</span><input id='i-pbi-add-dateflag' type='text' /></div>" +
						"<div class='col-xs-6'><span class='c-span'>取值函数</span><input id='i-pbi-add-function' type='text' /></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-12' style='text-align:center;'><a id='i-pbi-add-save' class='btn btn-info' style='width:100px;'>保存</a></div>" +
					"</div>" +							
			"</div>";
		};
		if (type == "PDI") {
			dialogStr = "<div id='i-pdi-add' class='c-dialog container'>" +
					"<input id='i-pdi-add-id' type='hidden' name='id' />" +
					"<div class='row'>"  +
						"<div class='col-xs-6'><span class='c-span'>配置代码</span><input id='i-pdi-add-code' type='text'/></div>" +
						"<div class='col-xs-6'><span class='c-span'>配置描述</span><input id='i-pdi-add-desc' type='text' /></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-6'><span class='c-span'>取值标志</span><input id='i-pdi-add-interflag' type='text' /></div>" +
						"<div class='col-xs-6'><span class='c-span'>就诊类型</span><input id='i-pdi-add-admtype' type='text' /></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-6'><span class='c-span'>时间属性</span><input id='i-pdi-add-dateflag' type='text' /></div>" +
						"<div class='col-xs-6'><span class='c-span'>取值函数</span><input id='i-pdi-add-function' type='text'/></div>" +
					"</div>" +
					"<div class='row'>" +
						"<div class='col-xs-12' style='text-align:center;'><a id='i-pdi-add-save' class='btn btn-info' style='width:100px;'>保存</a></div>" +
					"</div>" +							
			"</div>";
		}
				
		return dialogStr;
	};
	
	var loadRaqGrid = function (pageNumber, pageSize) {
		var arg1 = $("#i-beType").simplecombobox('getValue')||"",
			arg2 = "",
			arg3 = $("#i-cfgValue").val(),
			arg4 = $("#i-cfgDesc").val();
		if (arg1 == "DATA") {
			arg2 = $('#i-cfgType').simplecombobox('getValue')||"";
		} else {
			arg2 = $('#i-cfgType').val();
		};
		if (!pageNumber) {
			pageNumber = pageSize = "";
		};
		$('#i-raqGrid').simpledatagrid("clearSelections");
		$('#i-raqGrid').simpledatagrid("load",{
			ClassName:"DHCAnt.QRY.Config.RAQ",
			QueryName:"QryCommonData",
			ModuleName:"datagrid",
			Arg1:arg1,
			Arg2:arg2,
			Arg3:arg3,
			Arg4:arg4,
			rows2:pageSize,
			page2:pageNumber,
			ArgCnt:4
			
		});
	};
});