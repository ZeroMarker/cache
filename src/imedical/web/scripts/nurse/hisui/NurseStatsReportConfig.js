var PageLogicObj={
	m_WardJson:""
}
editRow = undefined;
$(function(){
	InitHospList();
	InitEvent();
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:205});
	hospComp.jdata.options.onSelect = function(e,t){
		RefreshData();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitWardJson();
	InitReportListTabTab();
	InitReportItemListTab();
}
function InitEvent(){
	$("#BReportCopy").click(ReportCopyHandle);
	$("#BCancel").click(function(){
	 	$("#CopyWin").window('close');
	});
}
function RefreshData(){
	$("#ReportListTab").datagrid("reload");
	$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
}
function InitWardJson(){
	PageLogicObj.m_WardJson=$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.LocUtils",
		QueryName:"NurseCtloc",
		desc:"",
		hosId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false)
}
function InitReportListTabTab(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#ReportListTab").datagrid("getRows");
					$("#ReportListTab").datagrid("appendRow", {
	                    ReportRowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#ReportListTab").datagrid("beginEdit", editRow);
	                var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
					$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
				}else{
					$.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
				}
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#ReportListTab").datagrid("getSelections");
				if (rows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {
							var ids = [];
	                        for (var i = 0; i < rows.length; i++) {
	                            ids.push(rows[i].ReportRowId);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#ReportListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
								MethodName:"HandleReport",
								rowID:ID, event:"DELETE"
							},false);
					        if(value=="0"){
						       $('#ReportListTab').datagrid('deleteRow',$('#ReportListTab').datagrid('getRowIndex',ID));
						       $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
					        editRow = undefined;
	                    }
	                });
				}else{
					$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
				}
			}
	    },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				 if (editRow != undefined) {
					var rows=$("#ReportListTab").datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					var name = editors[0].target.val();
					if(name==""){
						$.messager.popover({msg: '表单名称不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var validLocs=editors[1].target.combobox("getValues").join("^");
					var inValidLocs=editors[2].target.combobox("getValues").join("^");
					var ReportRowId = rows.ReportRowId;
					if (!ReportRowId) ReportRowId="";
	                $.m({ 
						ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
						MethodName:"HandleReport",
						rowID:ReportRowId,
						name:name,
						validLocs:validLocs,
						inValidLocs:inValidLocs,
						hospId:$HUI.combogrid('#_HospList').getValue(),
						event:"SAVE"
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						   $("#ReportListTab").datagrid('unselectAll').datagrid('load');
						   $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
						   $.messager.popover({msg: '保存成功!',type: 'success'});
						}else{
							$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },'-',{
			text: '复制',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#ReportListTab").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg: '请选择需要复制的报表！',type: 'error'});
					return false;
				}else if(!selected.ReportRowId){
					$.messager.popover({msg: '请选择已保存的报表！',type: 'error'});
					return false;
				}
				$("#CopyWin" ).window({
				   modal: true,
				   collapsible:false,
				   minimizable:false,
				   maximizable:false,
				   closed:true
				}).window('open');
				$("#CopyReportName").val("").focus();
				$("#CopyReportName").val(selected.ReportName+"-复制");
			}
	    }];
	var Columns=[[
		{ field: 'ReportRowId', title: 'ID',width:50},
		{ field: 'ReportName', title: '表单名称',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'ReportValidLocs', title: '适用范围',width:180, editor : 
			{
				type:'combobox',  
				options:{
					mode: "local",
					valueField:'locID',
					textField:'locDesc',
					mode: "local",
					multiple:true,
					rowStyle:"checkbox",
					data:PageLogicObj.m_WardJson.rows
				}
			},
			formatter: function(value,row,index){
				return row["ReportValidLocsDesc"];
			}
		},
		{ field: 'ReportInValidLocs', title: '不适用范围',width:180, editor : 
			{
				type:'combobox',  
				options:{
					mode: "local",
					valueField:'locID',
					textField:'locDesc',
					mode: "local",
					multiple:true,
					rowStyle:"checkbox",
					data:PageLogicObj.m_WardJson.rows
				}
			},
			formatter: function(value,row,index){
				return row["ReportInValidLocDescs"];
			}
		}
	]];
	$('#ReportListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		idField:"ReportRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&QueryName=GetReportList",
		onBeforeLoad:function(param){
			$('#ReportListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue")
			});
		},
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow != undefined) {
	            $.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
		        return false;
			}
			$('#ReportListTab').datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
       },
       onClickRow:function(rowIndex, rowData){
	       $("#ReportItemListTab").datagrid("reload")
	   }
	})
}
function GetSelReportId(){
	var rows = $("#ReportListTab").datagrid("getSelected");
	if (rows){
		return rows["ReportRowId"] || "";
	}
	return "";
}
function InitReportItemListTab(){
	var ToolBar = [{
			text: '增加',
			iconCls: '	icon-add',
			handler: function() {
					var ReportRowId=GetSelReportId();
					if (!ReportRowId){
						$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
		        		return false;
					}
					var maxRow=$("#ReportItemListTab").datagrid("getRows");
					$("#ReportItemListTab").datagrid("appendRow", {
	                    ReportItemRowId: ''
	                })
	                $("#ReportItemListTab").datagrid("beginEdit", maxRow.length-1);
	                var editors = $("#ReportItemListTab").datagrid('getEditors', maxRow.length-1);
					$(editors[0].target).focus();
					var target=$('#ReportItemListTab').datagrid('getEditor',{'index':maxRow.length-1,'field':'ReportItemAlternativeVal'}).target;
	        		$(target).attr("placeHolder","多个选项用^分割");
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var selRows = $("#ReportItemListTab").datagrid("getSelections");
				if (selRows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {
		                    var ErrMsg=[];
							var ids = [];delSeqNoObj={};
							var rows = $("#ReportItemListTab").datagrid("getSelections");
	                        for (var i = 0; i < selRows.length; i++) {
	                            var ReportItemRowId=selRows[i].ReportItemRowId;
	                            var ReportItemSeqNo=selRows[i].ReportItemSeqNo;
	                            ids.push(ReportItemRowId);
	                            if ((ReportItemSeqNo!="")&&(ReportItemRowId)){
		                            var index=$("#ReportItemListTab").datagrid("getRowIndex",ReportItemRowId);
		                            delSeqNoObj[ReportItemSeqNo]=index+1;
		                        }
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
				                $("#ReportItemListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var rows=$("#ReportItemListTab").datagrid("getRows");
	                        for (var i=0;i<rows.length;i++){
		                        var ReportItemSeqNo=rows[i]["ReportItemSeqNo"];
		                        if (ReportItemSeqNo){
			                        var ItemSeqNoArr=ReportItemSeqNo.split(".");
			                        if (ItemSeqNoArr.length ==2){
				                        if (delSeqNoObj[ItemSeqNoArr[0]]){
					                        ErrMsg.push("第"+delSeqNoObj[ItemSeqNoArr[0]]+"行存在子序号，请核实!");
					                    }
				                    }else if(ItemSeqNoArr.length ==3){
					                    if (delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]){
						                    ErrMsg.push("第"+delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]+"行存在子序号，请核实!");
					                    }
					                }
			                    }
		                    }
		                    if (ErrMsg.length>0){
								$.messager.popover({msg: ErrMsg.join("</br>"),type: 'error'});
								return false;
							}
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
								MethodName:"HandleReportItem",
								SaveDataArr:JSON.stringify(ids), event:"DELETE"
							},false);
					        if(value=="0"){
						       for (var i = 0; i < ids.length; i++) {
	                              var index=$('#ReportItemListTab').datagrid("getRowIndex",ids[i]);
	                              $('#ReportItemListTab').datagrid('deleteRow',index);
	                           }
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
	                    }
	                });
				}else{
					$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
				}
			}
	    },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var ReportRowId=GetSelReportId();
				if (!ReportRowId){
					$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
	        		return false;
				}
				var MsgArr=[]; //错误信息提示数组
				var SeqNoVerify={}; //用来验证序号的父序号是否存在
				var SaveDataArr=[],ReportItemNameObj={},ReportItemSeqObj={};
				var rows=$("#ReportItemListTab").datagrid("getRows");
				for (var i=0;i<rows.length;i++){
					var editors = $("#ReportItemListTab").datagrid('getEditors', i);
					if (editors.length==0) {
						ReportItemNameObj[rows[i]["ReportItemName"]]=1;
						if (rows[i]["ReportItemSeqNo"]!=""){
							ReportItemSeqObj[rows[i]["ReportItemSeqNo"]]=1;
						}
						continue;
					}
					var SSReportItemName = $.trim(editors[0].target.val());
					if(SSReportItemName==""){
						$.messager.popover({msg: '第'+(i+1)+'行 列名不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var SSReportItemDataType = editors[1].target.combobox("getValue");
					if(SSReportItemDataType==""){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型不能为空!',type: 'error'});
						$(editors[1].target).next('span').find('input').focus();
						return false;
					};
					if (SSReportItemDataType=="ManualEntry" || SSReportItemDataType=="EmptyHeader"){
						var SSReportItemLinkSource=editors[2].target.combobox("getText");
					}else{
						var SSReportItemLinkSource=editors[2].target.combobox("getValue");
						if ($.hisui.indexOfArray(editors[2].target.combobox("getData"),"SourceRowId",SSReportItemLinkSource)<0){
							$.messager.popover({msg: '第'+(i+1)+'行请在下拉框中选择关联数据！',type: 'error'});
							$(editors[2].target).next('span').find('input').focus();
							return false;
						}
					}
					if((SSReportItemLinkSource=="")&&(SSReportItemDataType!="ManualEntry")&&(SSReportItemDataType!="EmptyHeader")){
						$.messager.popover({msg: '第'+(i+1)+'行关联数据不能为空!',type: 'error'});
						$(editors[2].target).next('span').find('input').focus();
						return false;
					};
					var SSReportItemComponentType = editors[3].target.combobox("getValue");
					if (SSReportItemComponentType){
						if ($.hisui.indexOfArray(editors[3].target.combobox("getData"),"value",SSReportItemComponentType)<0){
							$.messager.popover({msg: '第'+(i+1)+'行请在下拉框中选择组件类型！',type: 'error'});
							$(editors[3].target).next('span').find('input').focus();
							return false;
						}
					}
					if ((SSReportItemComponentType=="")&&(SSReportItemDataType=="ManualEntry")){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型是手工录入时组件类型不能为空!',type: 'error'});
						$(editors[3].target).next('span').find('input').focus();
						return false;
					};
					var SSReportItemAlternativeVal=editors[4].target.val();
					if ((SSReportItemComponentType!="")&&(SSReportItemComponentType!="text")&&(!SSReportItemAlternativeVal)){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型是单选或多选时备选值不能为空！',type: 'error'});
						$(editors[4].target).focus();
						return false;
					}
					var SSReportItemRequired=editors[5].target.checkbox("getValue")?"Y":"N";
					var SSReportItemRowMerge=editors[6].target.checkbox("getValue")?"Y":"N";
					var SSReportItemSeqNo=$.trim(editors[7].target.val());
					var SSReportItemWidth = $.trim(editors[8].target.val());
				
					if (ReportItemNameObj[SSReportItemName]){
						//MsgArr.push('第'+(i+1)+'行列名重复！');  --列名可能会重复 不做校验
					}else{
						ReportItemNameObj[SSReportItemName]=1;
					}
					if (ReportItemSeqObj[SSReportItemSeqNo]){
						MsgArr.push('第'+(i+1)+'行列排序重复！');
					}else if (SSReportItemSeqNo!=""){
						ReportItemSeqObj[SSReportItemSeqNo]=1;
						delete SeqNoVerify[SSReportItemSeqNo];
						var SeqNoArr=SSReportItemSeqNo.split(".");
						if (SeqNoArr.length ==2){
							if (!ReportItemSeqObj[SeqNoArr[0]]){
								SeqNoVerify[SeqNoArr[0]]='第'+(i+1)+'行序号 '+SSReportItemSeqNo+" 的父序号 "+SeqNoArr[0]+" 不存在！";
							}else{
								delete SeqNoVerify[SeqNoArr[0]];
							}
						}else if(SeqNoArr.length ==3){
							if (!ReportItemSeqObj[SeqNoArr[0]+"."+SeqNoArr[1]]){
								SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]]='第'+(i+1)+'行序号 '+SSReportItemSeqNo+" 的父序号 "+SeqNoArr[0]+"."+SeqNoArr[1]+" 不存在！";
							}else{
								delete SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]];
							}
						}
					}
					var ReportItemRowId = rows[i].ReportItemRowId;
					if (!ReportRowId) ReportItemRowId="";
					SaveDataArr.push({
						ReportRowId:ReportRowId,
						ReportItemRowId:ReportItemRowId,
						SSReportItemName:SSReportItemName,
						SSReportItemDataType:SSReportItemDataType,
						SSReportItemLinkSource:SSReportItemLinkSource,
						SSReportItemComponentType:SSReportItemComponentType,
						SSReportItemAlternativeVal:SSReportItemAlternativeVal,
						SSReportItemDelFlag:"N",
						SSReportItemRequired:SSReportItemRequired,
						SSReportItemRowMerge:SSReportItemRowMerge,
						SSReportItemSeqNo:SSReportItemSeqNo,
						SSReportItemWidth:SSReportItemWidth
					});
				}
				if (SaveDataArr.length==0){
					$.messager.popover({msg: "没有需要保存的数据！",type: 'error'});
					return false;
				}
				for (item in SeqNoVerify){
					MsgArr.push(SeqNoVerify[item]);
				}
				if (MsgArr.length>0){
					$.messager.popover({msg: MsgArr.join("</br>"),type: 'error'});
					return false;
				}
				$.m({ 
					ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
					MethodName:"HandleReportItem",
					SaveDataArr:JSON.stringify(SaveDataArr),
					event:"SAVE"
				},function(rtn){
					if(rtn==0){
					   $("#ReportItemListTab").datagrid('unselectAll').datagrid('load');
					   $.messager.popover({msg: '保存成功!',type: 'success'});
					}else{
						$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
					    return false;
					}
				}); 
			}
	    }];
	var Columns=[[ 
		{ field: 'ReportItemRowId', checkbox:"true"},
		{ field: 'ReportItemName', title: '列名',width:130, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'ReportItemDataType', title: '数据类型',width:110, editor : 
			{
				type:'combobox',  
				options:{
					editable:false,
					mode: "local",
					data:ServerObj.ReportItemDataTypeJson,
					onSelect: function (rowIndex, rowData){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var sourceObj=$('#ReportItemListTab').datagrid('getEditor', {index:index,field:'ReportItemLinkSource'});
						sourceObj.target.combobox('setValue',"").combobox('reload');
					}
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemDataTypeDesc"];
			}
		},
		{ field: 'ReportItemLinkSource', title: '关联数据',width:100, editor : 
			{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.ReportV2.SourceConfig&QueryName=GetSourceConfigList&rows=999999",
					valueField:'SourceRowId',
					textField:'SourceDesc',
					loadFilter:function(data){
					    return data['rows'];
					},
					onBeforeLoad:function(param){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var ReportItemDataType=""
						var editors = $('#ReportItemListTab').datagrid('getEditors', index); 
						if (editors[1]){
							var ReportItemDataType=editors[1].target.combobox('getValue');
						}
						if (ReportItemDataType=="") {
							var ReportItemDataType=$('#ReportItemListTab').datagrid("getData").rows[index].ReportItemDataType || "";
						}									
						param = $.extend(param,{
							SearchDesc:"",
							SearchType:ReportItemDataType,
							HospId:$HUI.combogrid('#_HospList').getValue(),
							SearchByType:"Y"
						});
					}
				 }
			},
			formatter: function(value,row,index){
				return row["ReportItemLinkSourceDesc"];
			}
		},
		{ field: 'ReportItemComponentType', title: '组件类型',width:80, editor : 
			{
				type:'combobox',  
				options:{
					//editable:false,
					mode: "local",
					data:ServerObj.ReportItemComponentTypeJson
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemComponentTypeDesc"];
			}
		},
		{ field: 'ReportItemAlternativeVal', title: '备选值',width:180, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemRequired', title: '必填项',width:70, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			}
		},

		{ field: 'ReportItemRowMerge', title: '数据行合并',width:100, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			}
		},
		{ field: 'ReportItemSeqNo', title: '列排序',width:70, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemWidth', title: '列宽',width:70, editor : 
			{
				type:'text'
			}
		}
	]];
	$('#ReportItemListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"ReportItemRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&QueryName=GetReportListItem&rows=999999",
		onBeforeLoad:function(param){
			$('#ReportItemListTab').datagrid("unselectAll");
			param = $.extend(param,{
				ReportRowId:GetSelReportId()
			});
		},
		onDblClickRow:function(rowIndex, rowData){ 
			$('#ReportItemListTab').datagrid("beginEdit", rowIndex);
			var target=$('#ReportItemListTab').datagrid('getEditor',{'index':rowIndex,'field':'ReportItemAlternativeVal'}).target;
	        $(target).attr("placeHolder","多个选项用^分割");
       }
	})
}
function ReportCopyHandle(){
	var CopyReportName = $.trim($("#CopyReportName").val());
	if(CopyReportName==""){
		$.messager.popover({msg: '表单名称不能为空!',type: 'error'});
		$("#CopyReportName").focus();
		return false;
	};
	var selected = $("#ReportListTab").datagrid("getSelected");
	var CopyFromReportRowId=selected.ReportRowId;
	$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.ReportConfig",
		MethodName:"CopyReport",
		CopyFromReportRowId:CopyFromReportRowId,
		CopyReportName:CopyReportName
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '复制成功！',type: 'success'});
			$("#CopyWin").window('close');
			RefreshData();
		}else{
			$.messager.popover({msg: '复制失败！'+rtn,type: 'error'});
		}
	})
}