//名称	dhcpe.ct.handlingopinions.js
//功能	系统配置 - 职业病体检 - 职业健康处理意见模板维护
//创建	2021-08-14
//创建人  zhongricheng
var tableName = "DHC_PE_HandlingOpinions";
var sessionStr = session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function () {
	
	InitCombobox();
	
	InitDataGrid();
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("0");
    });
});

function InitCombobox() {
	//获取下拉列表 dhcpe/ct/dhcpe.ct.common.js
	GetLocComp(sessionStr);
	
	//科室下拉列表change
	$("#LocList").combobox({
		onSelect:function() {
			BClear_click("0");
			BSearch_click();
		}
	});
	
	//检查种类
	$HUI.combobox("#OMEType, #OMETypeWin", {
		url:$URL+"?ClassName=web.DHCPE.OMEType&QueryName=SearchOMEType&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc',
	    panelHeight:'auto', //自动高度
	    panelMaxHeight:200, //最大高度
		defaultFilter:4
	});
	
	// 检查结论
	$HUI.combobox("#Conclusion, #ConclusionWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.Conclusion&QueryName=FindConclusion&Active=Y&ResultSetType=array",
		valueField:'TRowId',
		textField:'TDesc',
	    panelHeight:'auto', //自动高度
	    panelMaxHeight:200 //最大高度
	});
}

function InitDataGrid() {
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#HandlingOpinions", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.HandlingOpinions",
			QueryName:"SearchHandOpts",
			Code:"",
			Conclusion:"",
			OMEType:"",
			LocID:LocID,
			tableName:tableName
		},
		method: 'get',
		idField: 'ARCOSRowid',
		treeField: 'ARCOSOrdSubCat',
		columns:[[
			{field:'TId', title:'TId', hidden:true},
			{field:'TConclusion', title:'TConclusion', hidden:true},
			{field:'TOMEType', title:'TOMEType', hidden:true},
			
			{field:'TCode', title:'代码', align:'center', width:80},
			{field:'TConclusionDesc', title:'检查结论', width:100},
			{field:'TOMETypeDesc', title:'检查种类', width:100},
			{field:'TDesc', title:'处理意见', width:500},
			
			{field:'TSort', title:'顺序', align:'center', width:40},
			{field:'TActive', title:'激活', align:'center', width:40,
				formatter:function(value, rowData, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
				}
			},
			{field:'Empower', title:'单独授权', align:'center', width:70,
				formatter:function(value, rowData, rowIndex) {
					if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
				}
			},
			{ field:'TEffPowerFlag',width:100,title:'当前科室授权',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
			{field:'TRemark', title:'备注', width:100}
		]],
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,   // 树形表格 不能分页
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
					 
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'新增',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'保存',
						handler:function(){
							BAdd_click("Add");
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		}, {
			iconCls: 'icon-write-order',
			text:'修改',
			id:'BUpd',
			disabled:true,
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
				
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				if(SelRowData==null){
					$.messager.alert("提示","请选择待修改的数据！","info");
					return false
				}
				$("#CodeWin").val(SelRowData.TCode).validatebox("validate");
				$("#ConclusionWin").combobox("setValue",SelRowData.TConclusion);
				$("#SortWin").numberbox("setValue",SelRowData.TSort).validatebox("validate");
				$("#OMETypeWin").combobox("setValue",SelRowData.TOMEType);
				$("#RemarkWin").val(SelRowData.TRemark);
				$("#HanlingOpinionsWin").val(SelRowData.TDesc);
				
				$("#ActiveWin").checkbox("setValue",SelRowData.TActive=="Y"?true:false);
				
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'修改',
						handler:function() {
							BAdd_click("Upd");
						}
					},{
						text:'关闭',
						handler:function() {
							myWin.close();
						}
					}]
				});
			}
		}, {
			iconCls: 'icon-paper-key',
			text:'单独授权',
			id:'BPower',
			disabled:true,
			handler: function(){
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				var Id = SelRowData.TId;
				if (Id == "") {
					$.messager.alert("提示","请选择需要单独授权的数据！","info");
					return false;
				}else{
					//单独授权 
					var BEmpower=$.trim($("#BPower").text());
					var iEmpower="Y";
					if (BEmpower=="取消授权") iEmpower="N"

					var LocID=$("#LocList").combobox('getValue');
					var UserID=session['LOGON.USERID'];
	    			var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,Id,LocID,UserID,iEmpower)
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){
						if (BEmpower=="取消授权"){$.messager.alert("提示","取消授权失败","error");}
						else{$.messager.alert("提示","授权失败","error");}
					}else{
						if (BEmpower=="取消授权"){$.messager.popover({msg:'取消授权成功',type:'success',timeout: 1000});}
						else{$.messager.popover({msg:'授权成功',type:'success',timeout: 1000});}
			 			$("#HandlingOpinions").datagrid('reload');
			 			$("#HandlingOpinions").datagrid('clearSelections'); //取消选中状态
					}			
					
				}	
				
				
			}
		},{
			iconCls: 'icon-key',
			text:'数据关联科室',
			id:'BRelateLoc',
			disabled:true,
			handler: function(){
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				var Id = SelRowData.TId;
				if (Id == "") {
					$.messager.alert("提示","请选择处理意见后再关联科室！", "info");
					return false;
				}
				
				var LocID = $("#LocList").combobox('getValue');
                OpenLocWin(tableName,Id,sessionStr,LocID,InitDataGrid)
				
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
			$('#BUpd').linkbutton('enable');
			$('#BRelateLoc').linkbutton('enable');
			$('#BPower').linkbutton('enable');
			if(rowData.Empower=="Y"){	
				$("#BRelateLoc").linkbutton('enable');
				$("#BPower").linkbutton({text:'取消授权'});
			}else{
				$("#BRelateLoc").linkbutton('disable');
				$("#BPower").linkbutton('enable');
				$("#BPower").linkbutton({text:'单独授权'})
				
			}	
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data) {
			
		}
	});
}

function BAdd_click(Type) {
	if (Type == "Add") {
		var Id = "";
		var Al = "保存";
		var Opt = "insertRow";
		var OptIndex = 0;
	} else if (Type == "Upd") {
		var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("提示","请选择处理意见后再进行修改！", "info"); return false; }
		var Id = SelRowData.TId;
		var Al = "修改";
		var Opt = "updateRow";
		var OptIndex = $("#HandlingOpinions").datagrid("getRowIndex", SelRowData);
	} else {
		return false;
	}
	
	var Code = $("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"").toUpperCase();
	if (Code == "") { $.messager.alert("提示", "请输入代码！", "info"); return false; }
	
	var Conclusion = $("#ConclusionWin").combobox("getValue");
	if (Conclusion == "") { $.messager.alert("提示", "请选择检查结论！", "info"); return false; }
	
	var Sort = $("#SortWin").numberbox("getValue");
	if (Sort == "") { $.messager.alert("提示", "请输入顺序！", "info"); return false; }
	
	var Desc = $("#HanlingOpinionsWin").val().replace(/(^\s*)|(\s*$)/g,"");
	if (Desc == "") { $.messager.alert("提示", "请输入处理意见！", "info"); return false; }
	
	var OMEType = $("#OMETypeWin").combobox("getValue");
	var Remark = $("#RemarkWin").val();
	
	var Active = $("#ActiveWin").checkbox("getValue")?"Y":"N";
	
	var OMETypeDesc = $("#OMETypeWin").combobox("getText");
	var ConclusionDesc = $("#ConclusionWin").combobox("getText");
	
	var SplitChar = "^";
	var DataStr = Code + SplitChar + OMEType + SplitChar + Conclusion + SplitChar + Desc + SplitChar + Sort + SplitChar + Active + SplitChar + Remark + SplitChar + tableName;  // 代码^检查种类^检查结论^处理意见^顺序^激活^备注^表名

	$.cm({
		ClassName:"web.DHCPE.CT.HandlingOpinions",
		MethodName:"UpdateHandOpts",
		Id:Id,
		DataStr:DataStr,
		SplitChar:SplitChar,
		LocId:$("#LocList").combobox('getValue'),
		USERID:session["LOGON.USERID"]
	}, function(jsonData){
		if (jsonData.success == 0) {
			$.messager.alert("提示", Al + "失败！" + jsonData.msg, "error");
		} else if (jsonData.code == "-1") {
			$.messager.alert("提示", Al + "失败！" + jsonData.msg, "error");
		} else {
			$.messager.popover({msg:Al + "成功！", type:"success", timeout:2000});
			BClear_click();
			$("#HandlingOpinions").datagrid(Opt, {
				index:OptIndex,
				row:{
					TId:jsonData.code,
					TConclusion:Conclusion,
					TOMEType:OMEType,
					
					TCode:Code,
					TConclusionDesc:ConclusionDesc,
					TOMETypeDesc:OMETypeDesc,
					TDesc:Desc,
					
					TSort:Sort, 
					TActive:(Active=="Y"?"是":"否"),
					TRemark:Remark
				}
			});
			$("#HOWin").window("close");
		}
	});
}

function BSearch_click() {
	$("#HandlingOpinions").datagrid('clearSelections'); //取消选中状态

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#HandlingOpinions",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.HandlingOpinions",
			QueryName:"SearchHandOpts",
			Code:$("#Code").val(),
			Conclusion:$("#Conclusion").combobox("getValue"),
			OMEType:$("#OMEType").combobox("getValue"),
			LocID:LocID,
			tableName:tableName
			
		}
	});
}

function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Conclusion").combobox("setValue","");
		$("#OMEType").combobox("setValue","");
		BSearch_click();
	} else if (Type == "1") {
		$("#CodeWin").val("").validatebox("validate");;
		$("#ConclusionWin").combobox("setValue","");
		$("#OMETypeWin").combobox("setValue","");
		$("#SortWin").numberbox("setValue","").validatebox("validate");;
		$("#ActiveWin").checkbox("setValue","true");
		$("#HanlingOpinionsWin").val("");
	}
}