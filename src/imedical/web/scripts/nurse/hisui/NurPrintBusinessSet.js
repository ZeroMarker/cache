var PageLogicObj={
	gridArr:[{
				tableID:"PatInfoPrtSet",
				tabName:"CF_NUR_NIS.PatInfoPrtSet",
				tabClass:"CF.NUR.NIS.PatInfoPrtSet",
				title:"床头卡/腕带批量打印配置"
			},
			{
				tableID:"PrtOrdFilterSet",
				tabName:"CF_NUR_NIS.PrtOrdFilterSet",
				tabClass:"CF.NUR.NIS.PrtOrdFilterSet",
				title:"打印医嘱过滤配置"
			},
			{
				tableID:"LabPrtExceptSet",
				tabName:"CF_NUR_NIS.LabPrtExceptSet",
				tabClass:"CF.NUR.NIS.LabPrtExceptSet",
				title:"检验条码打印执行配置-例外配置"
			}],
	PrtBusinessSetId:""
}

$(window).load(function() {
	$("#loading").hide();
})
$(function(){
	InitHospList();
})
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_PrtBusinessSet");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.PrtBusinessSetId="";
		loadPageData();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		initTable();
		loadPageData();
	}
}
function initTable(){
	initPatInfoPrtSet();
	initPrtOrdFilterSet();
	initLabPrtExceptSet();
}
function loadPageData(loadTabId){
	$.cm({ 
		ClassName:"Nur.NIS.Service.OrderExcute.NurPrintBusinessSet", 
		MethodName:"GetNurPrintBusinessSetJson",
		hospId:$HUI.combogrid('#_HospList').getValue()
	},function(data){
		/*for (tableId in data){
			if (tableId=="PrtBusinessSet"){
				clearCheckboxChange();
				var tabData=data[tableId].rows;
				if (tabData.length==0){
					PageLogicObj.PrtBusinessSetId="";
					$("#PBSLabPrintLaterOrdSttDT").checkbox("setValue",false);
					$("#PBSLabExecNeedPrinted").checkbox("setValue",false);
					$("#PBSLabExecutedForBidRepeatPrt").checkbox("setValue",false);
					continue;
				}
				tabData=tabData[0];
				PageLogicObj.PrtBusinessSetId=tabData.ID;
				for (item in tabData){
					if ($("#"+item).length==0) continue;
					$("#"+item).checkbox("setValue",tabData[item]=="Y"?true:false);
				}
				setCheckboxChange();
			}else{
				if ((loadTabId)&&(loadTabId!=tableId)) continue;
				$("#"+tableId).datagrid("loadData",data[tableId]);
			}
		}*/
		$.each(data,function(tableId,val){
			if (tableId=="PrtBusinessSet"){
				clearCheckboxChange();
				var tabData=data[tableId].rows;
				if (tabData.length==0){
					PageLogicObj.PrtBusinessSetId="";
					$("#PBSLabPrintLaterOrdSttDT").checkbox("setValue",false);
					$("#PBSLabExecNeedPrinted").checkbox("setValue",false);
					$("#PBSLabExecutedForBidRepeatPrt").checkbox("setValue",false);
				}else{
					tabData=tabData[0];
					PageLogicObj.PrtBusinessSetId=tabData.ID;
					$.each(tabData,function(item,val){
						if ($("#"+item).length>0) {
							$("#"+item).checkbox("setValue",tabData[item]=="Y"?true:false);
						}
					})
				}
				setCheckboxChange();
			}else{
				if ((!loadTabId)||((loadTabId)&&(loadTabId==tableId))) $("#"+tableId).datagrid("loadData",data[tableId]);
			}
		});
	});
}
function initPatInfoPrtSet(){
	var ToolBar = [{
		text: '新增',
		iconCls: '	icon-add',
		handler: function() {
			var maxRow=$("#PatInfoPrtSet").datagrid("getRows");
			$("#PatInfoPrtSet").datagrid("appendRow", {
				Index:maxRow.length,
                ID: '',
                PIPSActive:'Y'
            })
            var editIndex=maxRow.length-1;
            $("#PatInfoPrtSet").datagrid("beginEdit", editIndex);
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			saveGridData("PatInfoPrtSet");
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			delGridData("PatInfoPrtSet");
		}
    }];		
    var PIPSBtnNameList=$.cm({ 
		ClassName:"Nur.NIS.Common.QueryBrokerNew", 
		MethodName:"GetOptionOfProperty",
		className:"CF.NUR.NIS.PatInfoPrtSet",
		propertyName:"PIPSBtnName"
	},false);
	var Columns=[[
		{ field: 'PIPSBtnName', title: '按钮名称',width:100,editor :{
				type:'combobox',  
				options:{
					required: true,
					mode:"local",
					editable:false,
					valueField:'value',
					textField:'text',
					data:PIPSBtnNameList
				 }
			},
			formatter: function(value,row,index){
				return row.PIPSBtnNameDesc;
			}
		},
		{ field: 'PIPSFormworkDr', title: '调用打印模板',width:160,editor :{
				type:'combobox',  
				options:{
					required: true,
					mode:"local",
					defaultFilter:6,
					url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetXMLFomworkList&rows=99999",
					valueField:'RowID',
					textField:'SPSName',
					loadFilter: function(data){
						return data['rows'];
					},
					onBeforeLoad:function(param){
						$.extend(param, {
							hospId:$HUI.combogrid('#_HospList').getValue()
						});
					}
				}
			},
			formatter: function(value,row,index){
				return row.PIPSFormworkDrDesc;
			}	
		},
		{ field: 'PIPSApplyWards', title: '病区',width:200,editor :{
				type:'combobox',  
				options:{
					mode:"local",
					multiple:true,
					defaultFilter:6,
					rowStyle:"checkbox",
					url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&rows=99999&bizTable=Nur_IP_PrtBusinessSet",
					valueField:'wardid',
					textField:'warddesc',
					loadFilter: function(data){
						return data['rows'];
					},
					onBeforeLoad:function(param){
						$.extend(param, {
							hospid:$HUI.combogrid('#_HospList').getValue(),
							desc:param["q"]
						});
					}
				}
			},
			formatter: function(value,row,index){
				return row.PIPSApplyWardsDesc;
			}	
		},
		{ field: 'PIPSActive', title: '状态',width:80, align:'center',editor : 
			{
				type : 'icheckbox',options:{on:'Y',off:'N',required: true}
			},
			formatter: function(value,row,index){
				return row.PIPSActiveDesc;
			},
			styler: function(value,row,index){
				if (value !="N"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
	]];
	$('#PatInfoPrtSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,
		onDblClickRow:function(rowIndex, rowData){ 
			$('#PatInfoPrtSet').datagrid("beginEdit", rowIndex);
			setTimeout(function(){
				var editors=$('#PatInfoPrtSet').datagrid('getEditors',rowIndex);
				editors[2].target.combogrid('setText',rowData.PIPSApplyWardsDesc.split(","));
			},200)
        }
	})
}
function initPrtOrdFilterSet(){
	var ToolBar = [{
		text: '新增',
		iconCls: '	icon-add',
		handler: function() {
			var maxRow=$("#PrtOrdFilterSet").datagrid("getRows");
			$("#PrtOrdFilterSet").datagrid("appendRow", {
				Index:maxRow.length,
                ID: ''
            })
            var editIndex=maxRow.length-1;
            $("#PrtOrdFilterSet").datagrid("beginEdit", editIndex);
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			saveGridData("PrtOrdFilterSet");
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			delGridData("PrtOrdFilterSet");
		}
    }];		
	var LPESFilterTypeList=$.cm({ 
		ClassName:"Nur.NIS.Common.QueryBrokerNew", 
		MethodName:"GetOptionOfProperty",
		className:"CF.NUR.NIS.PrtOrdFilterSet",
		propertyName:"LPESFilterType"
	},false);
	var Columns=[[
		{ field: 'LPESPrtItem', title: '打印项目',width:180,editor :{
				type:'combobox',  
				options:{
					required: true,
					mode:"local",
					multiple:true,
					rowStyle:"checkbox",
					editable:false,
					valueField:'value',
					textField:'text',
					data:[{"value":"ZXD","text":"执行单"},{"value":"SYK","text":"输液卡"},{"value":"Other","text":"其他打印"}]
				 }
			},
			formatter: function(value,row,index){
				return row.LPESPrtItemDesc;
			}
		},
		{ field: 'LPESFilterType', title: '过滤类型',width:100,editor :{
				type:'combobox',  
				options:{
					required: true,
					mode:"local",
					editable:false,
					valueField:'value',
					textField:'text',
					data:LPESFilterTypeList,
					onSelect:function(rec){
						var tr = $(this).closest("tr.datagrid-row");
						var editRowIndex = tr.attr("datagrid-row-index");
						var rows=$('#PrtOrdFilterSet').datagrid("selectRow",editRowIndex).datagrid("getSelected");
						rows.LPESFilterType=rec.value;
						var obj=$('#PrtOrdFilterSet').datagrid('getEditor', {index:editRowIndex,field:'LPESFilterItems'});
						obj.target.combogrid("grid").datagrid('load',{filterType:rec.value});
					}
				}
			},
			formatter: function(value,row,index){
				return row.LPESFilterTypeDesc;
			}	
		},
		{ field: 'LPESFilterItems', title: '过滤项目',width:260,editor :{
				type:'combogrid',
				options:{
					required: true,
					mode:'remote',
					required: true,
					multiple:true,
					url:$URL+"?ClassName=Nur.NIS.Service.OrderExcute.NurPrintBusinessSet&QueryName=getFilterItemList",
					idField:'id',
					textField:'name',
					columns:[[
                        {field:'name',title:'名称',width:230,sortable:false}
                     ]],
					onBeforeLoad:function(param){
						var filterType="";
						if ($("input:focus").length){
							var tr=$("input:focus").closest("tr.datagrid-row");
							var editRowIndex = tr.attr("datagrid-row-index");
							if (editRowIndex>=0){
								var rows=$('#PrtOrdFilterSet').datagrid("selectRow",editRowIndex).datagrid("getSelected");
								filterType=rows.LPESFilterType;
							}
						}
						$.extend(param, {
							hospid:$HUI.combogrid('#_HospList').getValue(),
							desc:param["q"],
							filterType:filterType
						});
					}
				}
			},
			formatter: function(value,row,index){
				return row.LPESFilterItemsDesc;
			}	
		}
	]];
	$('#PrtOrdFilterSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,
		onDblClickRow:function(rowIndex, rowData){ 
			$('#PrtOrdFilterSet').datagrid("beginEdit", rowIndex);
			setTimeout(function(){
				var editors=$('#PrtOrdFilterSet').datagrid('getEditors',rowIndex);
				editors[0].target.combobox('setValues',rowData.LPESPrtItem.split("^"));
				
				var editors=$('#PrtOrdFilterSet').datagrid('getEditors',rowIndex);
				editors[2].target.combogrid('setText',rowData.LPESFilterItemsDesc.split(","));
			},200)
        }
	})
}
function initLabPrtExceptSet(){
	var ToolBar = [{
		text: '新增',
		iconCls: '	icon-add',
		handler: function() {
			var maxRow=$("#LabPrtExceptSet").datagrid("getRows");
			$("#LabPrtExceptSet").datagrid("appendRow", {
				Index:maxRow.length,
                ID: ''
            })
            var editIndex=maxRow.length-1;
            $("#LabPrtExceptSet").datagrid("beginEdit", editIndex);
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			saveGridData("LabPrtExceptSet");
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			delGridData("LabPrtExceptSet");
		}
    }];		
	var Columns=[[
		{ field: 'LPESArcimDr', title: '医嘱项',width:260,editor :{
				type:'combobox',
				options:{
					required: true,
					mode:'remote',
					required: true,
					multiple:false,
					url:$URL+"?ClassName=Nur.NIS.Service.OrderExcute.NurPrintBusinessSet&QueryName=getFilterItemList",
					valueField:'id',
					textField:'name',
					columns:[[
                        {field:'name',title:'名称',width:230,sortable:false}
                     ]],
                    loadFilter: function(data){
						return data['rows'];
					},
					onBeforeLoad:function(param){
						$.extend(param, {
							hospid:$HUI.combogrid('#_HospList').getValue(),
							desc:param["q"],
							filterType:"ARCIM",
							TYPE:"L"
						});
					},
					onSelect:function(rec){
						var tr = $(this).closest("tr.datagrid-row");
						var editRowIndex = tr.attr("datagrid-row-index");
						var rows=$("#LabPrtExceptSet").datagrid("getRows");
						for (var i=0;i<rows.length;i++){
							if (i==editRowIndex) continue;
							var obj=$('#LabPrtExceptSet').datagrid('getEditor', {index:i,field:'LPESArcimDr'});
							var editors=$('#LabPrtExceptSet').datagrid('getEditors',i);
							if (editors.length ==0) {
								var arcimId=rows[i].LPESArcimDr;
							}else{
								var arcimId=obj.target.combogrid("getValue");
							}
							if (rec.id==arcimId) {
								$.messager.popover({msg: '医嘱项重复',type: 'error'});
								$(this).combobox("setValue","").combobox("setText","");
							}
						}
					}
				}
			},
			formatter: function(value,row,index){
				return row.LPESArcimDrDesc;
			}	
		},
		{ field: 'LPESExecNotNeedPrted', title: '条码打印不控制执行',width:140, align:'center',editor : 
			{
				type : 'icheckbox',options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.LPESExecNotNeedPrtedDesc;
			}
		},
		{ field: 'LPESExecutedAllowPrt', title: '医技执行后允许打印',width:140, align:'center',editor : 
			{
				type : 'icheckbox',options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.LPESExecutedAllowPrtDesc;
			}
		}
	]];
	$('#LabPrtExceptSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,
		onDblClickRow:function(rowIndex, rowData){ 
			$('#LabPrtExceptSet').datagrid("beginEdit", rowIndex);
			setTimeout(function(){
				var editors=$('#LabPrtExceptSet').datagrid('getEditors',rowIndex);
				editors[0].target.combobox('setText',rowData.LPESArcimDrDesc);
			},200)
        }
	})
}
function saveGridData(tableID){
	var index=$.hisui.indexOfArray(PageLogicObj.gridArr,"tableID",tableID);
	var saveDataArr=[],tableDataArr=[],chkTableDataArr=[],repeatDataArr=[];;
	var NullValColumnArr=[];
	var rows=$("#"+tableID).datagrid("getRows");
	for (var j=0;j<rows.length;j++){
		var rowDataArr=[];
		var editors=$('#'+tableID).datagrid('getEditors',j);
		if (editors.length ==0) {
			if (tableID=="PatInfoPrtSet"){
				chkTableDataArr.push({"PIPSBtnName":rows[j].PIPSBtnName,"PIPSFormworkDr":rows[j].PIPSFormworkDr,"PIPSApplyWards":rows[j].PIPSApplyWards});
			}
			continue;
		}
		var rowNullValArr=[],editObj={};
		for (var k=0;k<editors.length;k++){
			var field=editors[k].field;
			var fieldType=editors[k].type;
			if (fieldType =="combobox"){
				var comOpts=editors[k].target.combobox("options");
				if (comOpts.multiple){
					var value=editors[k].target.combobox('getValues').join("^");
				}else{
					var value=editors[k].target.combobox('getValue');
				}						
			}else if(fieldType=="combogrid"){
				var comOpts=editors[k].target.combogrid("options");
				if (comOpts.multiple){
					var value=editors[k].target.combogrid('getValues').join("^");
				}else{
					var value=editors[k].target.combogrid('getValue');
				}
			}else if(fieldType =="icheckbox"){
				var value=editors[k].target.checkbox('getValue')?"Y":"N";
			}else if(fieldType =="numberbox"){
				var value=editors[k].target.numberbox('getValue');
			}else {
				var value=editors[k].target.val();
			}
			value=$.trim(value);
			var fieldOpts = $('#'+tableID).datagrid('getColumnOption',field);
			if (fieldOpts.editor.options){
				if ((fieldOpts.editor.options.required)&&(!value)){
					rowNullValArr.push(fieldOpts.title);
				}
			}
			rowDataArr.push({"field":field,"fieldValue":value});
			editObj[field]=value;
		}
		if (tableID=="PatInfoPrtSet"){
			for (var m=0;m<chkTableDataArr.length;m++){
				if ((chkTableDataArr[m].PIPSBtnName==editObj.PIPSBtnName)&&(chkTableDataArr[m].PIPSFormworkDr==editObj.PIPSFormworkDr)){
					var chkApplyWards=chkTableDataArr[m].PIPSApplyWards;
					var ApplyWards=editObj.PIPSApplyWards;
					if ((ApplyWards=="")&&(chkApplyWards=="")){
						repeatDataArr.push("第"+(j+1)+"行");
					}else if(ApplyWards!="" && chkApplyWards!=""){
						for (var n=0;n<ApplyWards.split("^").length;n++){
							if (("^"+chkApplyWards+"^").indexOf("^"+ApplyWards.split("^")[n]+"^")>=0){
								repeatDataArr.push("第"+(j+1)+"行");
							}
						}
					}
				}
			}
			chkTableDataArr.push(editObj);
		}
		if (rowNullValArr.length>0){
			NullValColumnArr.push("第"+(j+1)+"行"+rowNullValArr.join("、"));
		}
		if (rowDataArr.length>0){
			var ID=rows[j].ID;
			if (!ID) ID="";
			rowDataArr.push({"field":"ID","fieldValue":ID});
			tableDataArr.push(rowDataArr);
		}
	}
	var errMsgArr=[];
	if (NullValColumnArr.length>0){
		errMsgArr.push(NullValColumnArr.join("</br>")+"不能为空！");
	}
	if (repeatDataArr.length>0){
		errMsgArr.push(repeatDataArr.join("、")+"数据重复！");
	}
	if (errMsgArr.length>0){
		$.messager.alert("提示",PageLogicObj.gridArr[index].title+errMsgArr.join("</br>"));
		return false;
	}
	if (tableDataArr.length>0){
		saveDataArr.push({
			"tabName":PageLogicObj.gridArr[index].tabName,
			"tabClass":PageLogicObj.gridArr[index].tabClass,
			"TableConfigData":JSON.stringify(tableDataArr),
			"PrtBusinessSetId":PageLogicObj.PrtBusinessSetId,
			hospId:$HUI.combogrid('#_HospList').getValue()
		});
	}else{
		$.messager.popover({msg: '没有需要保存的数据！',type: 'error'});
		return false;
	}
	
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.NurPrintBusinessSet",
		MethodName:"handleNurPrintBusinessSet",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			loadPageData(tableID);
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
function checkboxChangeHandle(){
	var rowDataArr=[];
	var PBSLabPrintLaterOrdSttDT=$("#PBSLabPrintLaterOrdSttDT").checkbox("getValue")?"Y":"N";
	var PBSLabExecNeedPrinted=$("#PBSLabExecNeedPrinted").checkbox("getValue")?"Y":"N";
	var PBSLabExecutedForBidRepeatPrt=$("#PBSLabExecutedForBidRepeatPrt").checkbox("getValue")?"Y":"N";
	rowDataArr.push({"field":"PBSLabPrintLaterOrdSttDT","fieldValue":PBSLabPrintLaterOrdSttDT});
	rowDataArr.push({"field":"PBSLabExecNeedPrinted","fieldValue":PBSLabExecNeedPrinted});
	rowDataArr.push({"field":"PBSLabExecutedForBidRepeatPrt","fieldValue":PBSLabExecutedForBidRepeatPrt});
	rowDataArr.push({"field":"PBSHospDr","fieldValue":$HUI.combogrid('#_HospList').getValue()});
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.NurPrintBusinessSet",
		MethodName:"saveNurPrintBusinessSet",
		dataArr:JSON.stringify(rowDataArr),
		PrtBusinessSetId:PageLogicObj.PrtBusinessSetId
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			loadPageData("PrtBusinessSet");
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
function delGridData(tableID){
	var rows = $("#"+tableID).datagrid("getSelections");
	if (rows.length > 0) {
		$.messager.confirm("提示", "确定要删除吗?",
        function(r) {
            if (r) {
                var delDataArr=[],delIndexArr=[];
                for (var i = 0; i < rows.length; i++) {
                    var ID=rows[i].ID;
                    if (ID) {
                        delDataArr.push(ID);
                    }
                    delIndexArr.push($("#"+tableID).datagrid("getRowIndex",rows[i].Index));
                }
                var index=$.hisui.indexOfArray(PageLogicObj.gridArr,"tableID",tableID);
                var dataArr={
                    "tabName":PageLogicObj.gridArr[index].tabName,
                    delDataArr:delDataArr
                };
                var value=$.m({ 
					ClassName:"Nur.NIS.Service.OrderExcute.NurPrintBusinessSet", 
					MethodName:"handleNurPrintBusinessSet",
					event:"DELETE",
					dataArr:JSON.stringify(dataArr)
				},false);
		        if(value=="0"){
			        delIndexArr = delIndexArr.sort(function(a,b){
						return a-b;
					});
			       for (var i = delIndexArr.length-1; i >=0; i--) {
				       $("#"+tableID).datagrid("deleteRow",delIndexArr[i]);
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
function clearCheckboxChange(){
	$("#PBSLabPrintLaterOrdSttDT,#PBSLabExecNeedPrinted,#PBSLabExecutedForBidRepeatPrt").checkbox({onCheckChange:function(){}})
}
function setCheckboxChange(){
	$("#PBSLabPrintLaterOrdSttDT,#PBSLabExecNeedPrinted,#PBSLabExecutedForBidRepeatPrt").checkbox({onCheckChange:checkboxChangeHandle})
}