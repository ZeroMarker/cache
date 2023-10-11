/**
* @author songchunli
* HISUI 分娩记录配置js
*/
$(function(){
	Init();
});
$(window).load(function() {
	$("#loading").hide();
})
function HospChange(){
	loadOtherSet();
	loadBabyNameSet();
	$('#tabDeliveryRecSyncVitalSignSet,#tabDeliveryRecordItemSet').datagrid("rejectChanges").datagrid("reload");
}
function Init(){
	//初始化分娩记录弹出框项目配置
	InitDeliveryRecordItemSet();
	//初始化姓名配置
	InitTabBabyNameSet();
	//初始化不插入分娩事件的分娩方式
	InitTabNotInsertDeliveryEventSet();
	// 初始化分娩记录同步体征项
	InitTabDeliveryRecSyncVitalSignSet();
	loadOtherSet();
	$("#BSaveOtherSet").click(SaveOtherSet);
	initTip();
}
function InitDeliveryRecordItemSet(){
	var ToolBar = [{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			saveDeliveryRecordItemSet();
		}
    }];	
    var Columns=[[
    	{ field: 'DRIRow', title: '行',width:100, editor : 
			{type : 'numberbox',options : {required:true}}
     	},
     	{ field: 'DRICol', title: '列',width:100,editor :{
			type:'combobox',  
			options:{
				mode:"local",
				editable:false,
				valueField:'value',
				textField:'text',
				data:[{"value":1,"text":1},{"value":2,"text":2}]
			 }
		}},
		{ field: 'DRIItemCode', title: '项目编码',width:120},
		{ field: 'DRIItemDr', title: '项目名称',width:120,
			formatter: function(value,row,index){
				return row.DRIItemDrDesc;
			}
		},
		{ field: 'DRIItemDefaultValues', title: '默认值',width:120,editor :
			{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=GetTableData&rows=99999",
					valueField:'id',
					textField:'desc',
					disabled:false,
					rowStyle:'checkbox',
					multiple:true,
					loadFilter:function(data){
					    return data['rows'];
					},
					onBeforeLoad:function(param){
						var tr = $(this).closest("tr.datagrid-row");
						var editIndex = tr.attr("datagrid-row-index");
						var rows=$("#tabDeliveryRecordItemSet").datagrid("getRows")
						var data=rows[editIndex];
						if(data.basicItemType==2){
						}else if(data.basicItemType==1){
							$(this).combobox("options").multiple=false;
						}else{
							$(this).combobox("disable");
						}
						param = $.extend(param,{tableName:rows[editIndex].basicRelateTable,tableId:rows[editIndex].basicRelateTableId});
					}
				  }
			 },
			formatter: function(value,row,index){
				return row.DRIItemDefaultValuesDesc;
			}
		},
		{ field: 'DRIRequired', title: '是否必填',width:90,align:'center',editor: 
			{type : 'icheckbox',options:{on:'Y',off:'N'}},
			formatter: function(value,row,index){
				return row.DRIRequiredDesc;
			}
		},
		{ field: 'DRIDisplayOnlyLiveBirth', title: '仅活产显示',align:'center',width:100,editor :{
				type : 'icheckbox',options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.DRIDisplayOnlyLiveBirthDesc;
			}
		},
		{ field: 'DRIDeliveryMethods', title: '适用分娩方式',width:150,editor :
			{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=GetTableData&tableName=User.PACDeliveryMethod&rows=99999",
					valueField:'id',
					textField:'desc',
					disabled:false,
					rowStyle:'checkbox',
					multiple:true,
					loadFilter:function(data){
					    return data['rows'];
					}
				  }
			},
			formatter: function(value,row,index){
				return row.DRIDeliveryMethodsDesc;
			}
		},
		{ field: 'DRIDisplayInList', title: '查询列表显示',align:'center',width:100,editor :
			{type : 'icheckbox',options:{on:'Y',off:'N'}},
			formatter: function(value,row,index){
				return row.DRIDisplayInListDesc;
			}
		},
		{ field: 'DRIAticve', title: '状态',align:'center',width:75,editor :{
				type : 'icheckbox',options:{on:'Y',off:'N'}
			},
			formatter: function(value,row,index){
				return row.DRIAticveDesc;
			},
			styler: function(value,row,index){
				if(value=="N"){
					return "color:red;";
				}
			}
		}
    ]];	
	$('#tabDeliveryRecordItemSet').datagrid({  
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
		idField:"DRIItemDr",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=getDeliveryRecordSetList&hospID="+window.parent.GetHospId(),
		onDblClickRow:function(rowIndex, rowData){ 
			$('#tabDeliveryRecordItemSet').datagrid("beginEdit", rowIndex);
			var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:'DRIItemDefaultValues'});
			ed.target.combobox('setValues',rowData.DRIItemDefaultValues?rowData.DRIItemDefaultValues.split("$"):"");
			
			var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:'DRIDeliveryMethods'});
			ed.target.combobox('setValues',rowData.DRIDeliveryMethods?rowData.DRIDeliveryMethods.split("$"):"");
			
			//分娩方式、出生时间、出生日期、结果等项目,必填/仅活产显示/适用分娩方式/查询列表显示/启用等列不可编辑
			if (("^birthType^outComeCode^birthDate^birthTime^").indexOf("^"+rowData.DRIItemCode+"^")>=0){
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIRequired"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIDisplayOnlyLiveBirth"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIDisplayInList"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIAticve"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIDeliveryMethods"});
				ed.target.combobox("disable");
				
			}
			if (("^name^midwife^deliveryDoctor^").indexOf("^"+rowData.DRIItemCode+"^")>=0){
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIItemDefaultValues"});
				ed.target.combobox("disable");
			}
			if (("^name^name2^sex^").indexOf("^"+rowData.DRIItemCode+"^")>=0){
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIRequired"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIDisplayInList"});
				ed.target.checkbox("disable");
				
				var ed = $('#tabDeliveryRecordItemSet').datagrid('getEditor', {index:rowIndex,field:"DRIAticve"});
				ed.target.checkbox("disable");
			}
        }
	})
}
function saveDeliveryRecordItemSet(){
	var tableDataArr=[];
	var NullValColumnArr=[],NotValidateColumnArr=[],RowColArr=[],RowColRepeatArr=[];
	var reg1 = /^[0-9]*[1-9][0-9]*$/; //大于0的正整数
	var hospId=window.parent.GetHospId();
	var rows=$("#tabDeliveryRecordItemSet").datagrid("getRows");
	for (var j=0;j<rows.length;j++){
		var rowDataArr=[];
		var editors=$('#tabDeliveryRecordItemSet').datagrid('getEditors',j);
		if (editors.length>0){
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				var fieldType=editors[k].type;
				if (fieldType =="combobox"){
					var comOpts=editors[k].target.combobox("options");
					if (comOpts.multiple){
						var value=editors[k].target.combobox('getValues').join("$");
					}else{
						var value=editors[k].target.combobox('getValue');
					}						
				}else if(fieldType =="icheckbox"){
					var value=editors[k].target.checkbox('getValue')?"Y":"N";
				}else if(fieldType =="numberbox"){
					var value=editors[k].target.numberbox('getValue');
				}else {
					var value=editors[k].target.val();
				}
				value=$.trim(value);
				var fieldOpts = $('#tabDeliveryRecordItemSet').datagrid('getColumnOption',field);
				// 必填验证
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						NullValColumnArr.push("第"+(j+1)+"行"+fieldOpts.title);
					}
				}
				// 数字验证
				if ((value)&&(fieldType =="numberbox")&&(!reg1.test(value))){
					NotValidateColumnArr.push("第"+(j+1)+"行"+fieldOpts.title);
				}
				rowDataArr.push({"field":field,"fieldValue":value});
			}
		}else{
			var opts = $('#tabDeliveryRecordItemSet').datagrid('getColumnFields');
			for (var k=0;k<opts.length;k++){
				rowDataArr.push({"field":opts[k],"fieldValue":rows[j][opts[k]]});
			}
		}
		var DRIRow=rowDataArr[0].fieldValue;
		var DRICol=rowDataArr[1].fieldValue;
		if (JSON.stringify(RowColArr).indexOf(JSON.stringify({"DRIRow":DRIRow,"DRICol":DRICol}))>=0) {
			RowColRepeatArr.push("第"+(j+1)+"行");
		}else{
			RowColArr.push({"DRIRow":DRIRow,"DRICol":DRICol});
		}
		rowDataArr.push(
			{"field":"ID","fieldValue":rows[j].DRIRowId},
			{"field":"DRIItemDr","fieldValue":rows[j].DRIItemDr},
			{"field":"DRIHospDr","fieldValue":hospId}
		);
		tableDataArr.push(rowDataArr);
	}
	var ErrMsgArr=[];
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("、")+"不能为空！");
	}
	if (NotValidateColumnArr.length>0){
		ErrMsgArr.push(NotValidateColumnArr.join("、")+"请输入大于等于0的正整数！");
	}
	if (RowColRepeatArr.length>0){
		ErrMsgArr.push(RowColRepeatArr.join("、")+ " 行和列位置重复！");
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("提示",ErrMsgArr.join("</br>"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"saveDeliveryRecordSet",
		event:"SAVE",
		dataArr:JSON.stringify(tableDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			$('#tabDeliveryRecordItemSet').datagrid('reload');
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
function InitTabBabyNameSet(){
	var sexArr=$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		QueryName:"GetTableData",
		tableName:"User.CTSex"
	},false)
	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			var maxRow=$("#tabBabyNameSet").datagrid("getRows");
			var newObj={
				Index:maxRow.length
			};
			for(var i=0;i<sexArr.total;i++){
				newObj["babyNameLimitSexId"+(i+1)]=sexArr.rows[i].id;
				newObj["babyNameSetId"+(i+1)]="";
			}
			$("#tabBabyNameSet").datagrid("appendRow", newObj);
            
            $("#tabBabyNameSet").datagrid("beginEdit", maxRow.length-1);
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = $("#tabBabyNameSet").datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("提示", "确定要删除吗?",
	                function(r) {
	                    if (r) {
		                    var delDataArr=[];
		                    for (var i = 0; i < rows.length; i++) {
			                    if (rows[i].babyNameSetId1){
				                    for(var k=0;k<sexArr.total;k++){
					                	delDataArr.push(rows[i]["babyNameSetId"+(k+1)]);
					            	}
				                }
			                }
			                 var value=$.m({ 
								ClassName:"Nur.NIS.Service.Delivery.RecordConfig", 
								MethodName:"delBabyNameSet",
								dataArr:JSON.stringify(delDataArr)
							},false);
					        if(value=="0"){
						       loadBabyNameSet();
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
		                }
	            })
			}else{
				$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
			}
		}
    }];	
    var Columns=[[
    	{ field: 'pregnancNumber', title: '怀胎数',width:90, editor :{ 
			type:'combobox',  
			options:{
				mode:"local",
				editable:false,
				valueField:'value',
				textField:'text',
				required:true,
				data:[{"value":1,"text":1},{"value":2,"text":2},{"value":3,"text":3},{"value":4,"text":4},{"value":5,"text":5},{"value":6,"text":6}],
				onSelect:function(rec){
					var sortNoArr=[];
					for (var i=1;i<=rec.value;i++){
						sortNoArr.push({"value":i,"text":i});
					}
					var tr = $(this).closest("tr.datagrid-row");
					var editIndex = tr.attr("datagrid-row-index");
					var sortNoObj=$('#tabBabyNameSet').datagrid('getEditor', {index:editIndex,field:'sortNo'});
					sortNoObj.target.combobox('setValue',"");
					sortNoObj.target.combobox('loadData',sortNoArr);
				}
			 }}
     	},
     	{ field: 'sortNo', title: '顺序',width:90,editor :{
			type:'combobox',  
			options:{
				mode:"local",
				editable:false,
				valueField:'value',
				textField:'text',
				required:true
			 }
		}}
    ]];
	for(var i=0;i<sexArr.total;i++){
		var field="babyName"+(i+1);
		Columns[0].push({ 
			field: field, title: sexArr.rows[i].desc,width:100,editor : 
				{type : 'text',options : {required:true}}
		})
	}
	$('#tabBabyNameSet').datagrid({ 
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		onDblClickRow:function(rowIndex, rowData){ 
			$('#tabBabyNameSet').datagrid("beginEdit", rowIndex);
        }
	})
	loadBabyNameSet();
}
function loadBabyNameSet(){
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"getBabyNameSetList",
		hospID:window.parent.GetHospId()
	},function(rows){
		$('#tabBabyNameSet').datagrid("loadData",{"total":rows.length,"rows":rows});
	})
}
function InitTabNotInsertDeliveryEventSet(){
	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			var maxRow=$("#tabNotInsertDeliveryEventSet").datagrid("getRows");
			$("#tabNotInsertDeliveryEventSet").datagrid("appendRow", {
                Index: maxRow.length
            })
            var maxRow=$("#tabNotInsertDeliveryEventSet").datagrid("getRows");
            $("#tabNotInsertDeliveryEventSet").datagrid("beginEdit", maxRow.length-1);
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = $("#tabNotInsertDeliveryEventSet").datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("提示", "确定要删除吗?",
	                function(r) {
	                    if (r) {
		                    var delDataArr=[];
		                    for (var i = 0; i < rows.length; i++) {
			                    if (rows[i].methodId){
					                delDataArr.push(rows[i]["methodId"]);
				                }			                }
			                var updateDataArr=[];
			                var allRows=$("#tabNotInsertDeliveryEventSet").datagrid("getRows");
			                for (var i = 0; i < allRows.length; i++) {
				                if ((allRows[i].methodId)&&(allRows[i].methodId.indexOf(delDataArr.join("$"))<0)){
					                updateDataArr.push(allRows[i]["methodId"])
					            }
				            }
			                 var value=$.m({ 
								ClassName:"Nur.NIS.Service.Delivery.RecordConfig", 
								MethodName:"updateNotInsertDeliveryEventSet",
								recordOtherSetId:recordOtherSet,
								updateData:updateDataArr.join("$")
							},false);
					        if(value=="0"){
						       $.cm({
									ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
									MethodName:"getDeliveryOtherSet",
									hospID:window.parent.GetHospId()
								},function(data){
									$("#tabNotInsertDeliveryEventSet").datagrid('loadData',{"total":data.noDeliveryEventMethods.length,"rows":data.noDeliveryEventMethods});
								})
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
		                }
	            })
			}else{
				$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
			}
		}
    }];	
    var Columns=[[
    	{ field: 'methodId', title: '分娩方式',width:200, editor :{ 
			type:'combobox',  
			options:{
				url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=GetTableData&tableName=User.PACDeliveryMethod&rows=99999",
				valueField:'id',
				textField:'desc',
				disabled:false,
				multiple:false,
				loadFilter:function(data){
				    return data['rows'];
				}
			  }
		},
		formatter: function(value,row,index){
			return row.methodDesc;
		}
     	}
    ]];	
	$('#tabNotInsertDeliveryEventSet').datagrid({ 
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		onDblClickRow:function(rowIndex, rowData){ 
			$('#tabNotInsertDeliveryEventSet').datagrid("beginEdit", rowIndex);
        }
	})
}
function InitTabDeliveryRecSyncVitalSignSet(){
	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			$("#tabDeliveryRecSyncVitalSignSet").datagrid("appendRow", {
                id: ''
            })
            var maxRow=$("#tabDeliveryRecSyncVitalSignSet").datagrid("getRows");
            $("#tabDeliveryRecSyncVitalSignSet").datagrid("beginEdit", maxRow.length-1);
		}
    },{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = $("#tabDeliveryRecSyncVitalSignSet").datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("提示", "确定要删除吗?",
	                function(r) {
	                    if (r) {
		                    var delDataArr=[];
		                    for (var i = 0; i < rows.length; i++) {
			                    if (rows[i].id){
					                delDataArr.push(rows[i]["id"]);
				                }
				            }
			                 var value=$.m({ 
								ClassName:"Nur.NIS.Service.Delivery.RecordConfig", 
								MethodName:"delNotInsertDeliveryEventSet",
								dataArr:JSON.stringify(delDataArr)
							},false);
					        if(value=="0"){
						       $('#tabDeliveryRecSyncVitalSignSet').datagrid("reload");
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
		                }
	            })
			}else{
				$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
			}
		}
    }];	
    var Columns=[[
    	{ field: 'DSSBasicDataDr', title: '分娩记录项目',width:120, editor :{ 
			type:'combobox',  
			options:{
				url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=getDeliveryRecordSetList&rows=99999",
				valueField:'DRIItemDr',
				textField:'DRIItemDrDesc',
				disabled:false,
				multiple:false,
				required:true,
				loadFilter:function(data){
				    return data['rows'];
				},
				onBeforeLoad:function(param){
					param = $.extend(param,{hospID:window.parent.GetHospId()});
				}
			  }
		},
		formatter: function(value,row,index){
			return row.basicDataDesc;
		}
      },
     	{ field: 'DSSVitalSignDr', title: '体征项',width:120, editor :{ 
			type:'combobox',  
			options:{
				//url:$URL+"?ClassName=Nur.NIS.Service.VitalSign.MRCObservationItem&QueryName=FindALLSignItem&rows=99999",
				url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&MethodName=GetObsItem",
				valueField:'rowid',
				textField:'desc',
				disabled:false,
				multiple:false,
				required:true,
				/*loadFilter:function(data){
				    return data['rows'];
				},*/
				onBeforeLoad:function(param){
					param = $.extend(param,{itemDesc:param["q"],signType:"",HospitalID:window.parent.GetHospId()});
				}
			  }
		},
		formatter: function(value,row,index){
			return row.vitalSign;
		}
     	}
    ]];	
	$('#tabDeliveryRecSyncVitalSignSet').datagrid({ 
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		idField:"id",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url:$URL+"?ClassName=Nur.NIS.Service.Delivery.RecordConfig&QueryName=getDeliveryRecSyncVitalSignSet",
		onDblClickRow:function(rowIndex, rowData){ 
			$('#tabDeliveryRecSyncVitalSignSet').datagrid("beginEdit", rowIndex);
        },
        onBeforeLoad:function(param){
			param = $.extend(param,{hospID:window.parent.GetHospId()});
		}
	})
}
var recordOtherSet="";
function loadOtherSet(){
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"getDeliveryOtherSet",
		hospID:window.parent.GetHospId()
	},function(data){
		recordOtherSet=data.recordOtherSet;
		$("#babyGenerateRule").switchbox("setValue",data.babyGenerateRule=="Manual"?true:false);
		$("#noRegisterNoAddRecord").checkbox("setValue",data.noRegisterNoAddRecord=="Y"?true:false);
		$("#tabNotInsertDeliveryEventSet").datagrid("rejectChanges").datagrid('loadData',{"total":data.noDeliveryEventMethods.length,"rows":data.noDeliveryEventMethods});
	})
}
function SaveOtherSet(){
	var saveDataArr=[];
	// 获取新生儿姓名命名规则、不插入分娩事件类型的分娩方式、做分娩登记,不允许添加分娩记录的保存数据
	var repeatRowArr=[];
	var babyGenerateRule=$("#babyGenerateRule").switchbox("getValue")?"Manual":"Auto";
	var noRegisterNoAddRecord=$("#noRegisterNoAddRecord").checkbox("getValue")?"Y":"N";
	var noDeliveryEventMethods="";
	var rows=$("#tabNotInsertDeliveryEventSet").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var editors=$('#tabNotInsertDeliveryEventSet').datagrid('getEditors',i);
		if (editors.length>0){
			var value=editors[0].target.combobox('getValue');
			if (value=="") continue;
		}else{
			var value=rows[i].methodId;
		}
		if (("$"+noDeliveryEventMethods+"$").indexOf("$"+value+"$")>=0){
			repeatRowArr.push("第"+(i+1)+"行");
	    }
		if (noDeliveryEventMethods=="") noDeliveryEventMethods=value;
		else  noDeliveryEventMethods=noDeliveryEventMethods+"$"+value;
	}
	if (repeatRowArr.length>0){
		$.messager.alert("提示","不插入分娩事件类型的分娩方式</br>"+repeatRowArr.join("</br>")+"数据重复！");
		return false;
	}
	saveDataArr.push({
		tableClass:"CF.NUR.Delivery.RecOtherSet",
		tableName:"CF_NUR_Delivery.RecOtherSet",
		tableData:[
			[{"field":"id","fieldValue":recordOtherSet},
			{"field":"DROBabyGenerateRule","fieldValue":babyGenerateRule},
			{"field":"DRONoRegisterNoAddRecord","fieldValue":noRegisterNoAddRecord},
			{"field":"DRONoDeliveryEventMethods","fieldValue":noDeliveryEventMethods},
			{"field":"DROHospDr","fieldValue":window.parent.GetHospId()}]
		]
	});
	//获取新生儿姓名配置数据
	var allTableDataArr=[];
	var NullValColumnArr=[],repeatRowArr=[];
	saveDataArr.push({
		tableClass:"CF.NUR.Delivery.BabyNameSet",
		tableName:"CF_NUR_Delivery.BabyNameSet",
		tableData:[]
	});
	var rows=$("#tabBabyNameSet").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var editors=$('#tabBabyNameSet').datagrid('getEditors',i);
		//if (editors.length ==0) continue;
		if (editors.length>0){
			var rowNullValColumnArr=[];
			var pregnancNumber=editors[0].target.combobox('getValue');
			if (!pregnancNumber){
				rowNullValColumnArr.push("行怀胎数");
			}
			var sortNo=editors[1].target.combobox('getValue');
			if (!sortNo){
				rowNullValColumnArr.push("行顺序");
			}
			if (JSON.stringify(allTableDataArr).indexOf(JSON.stringify([{"field":"DBNPregnancNumber","fieldValue":pregnancNumber},{"field":"DBNSortNo","fieldValue":sortNo}]))>=0) {
				repeatRowArr.push("第"+(i+1)+"行");
			}
			allTableDataArr.push([{"field":"DBNPregnancNumber","fieldValue":pregnancNumber},{"field":"DBNSortNo","fieldValue":sortNo}]);
			for (var k=2;k<editors.length;k++){
				var field=editors[k].field;
				var value=editors[k].target.val();
				value=$.trim(value);
				var fieldOpts = $('#tabBabyNameSet').datagrid('getColumnOption',field);
				// 必填验证
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						rowNullValColumnArr.push(fieldOpts.title);
					}
				}
				rowDataArr=[
					{"field":"DBNPregnancNumber","fieldValue":pregnancNumber},
					{"field":"DBNSortNo","fieldValue":sortNo},
					{"field":"DBNHospDr","fieldValue":window.parent.GetHospId()},
					{"field":"DBNLimitSexDr","fieldValue":rows[i]["babyNameLimitSexId"+(k-1)]},
					{"field":"DBNBabyName","fieldValue":value},
					{"field":"id","fieldValue":rows[i]["babyNameSetId"+(k-1)]},
					{"field":"DBNDelFlag","fieldValue":0},
				];
				saveDataArr[1].tableData.push(rowDataArr);
			}
			if (rowNullValColumnArr.length>0){
				NullValColumnArr.push("第"+(i+1)+"行"+rowNullValColumnArr.join("、"));
			}
		}else{
			allTableDataArr.push([{"field":"DBNPregnancNumber","fieldValue":rows[i].pregnancNumber.toString()},{"field":"DBNSortNo","fieldValue":rows[i].sortNo.toString()}]);
		}
	}
	var ErrMsgArr=[];
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("</br>")+"不能为空！")
	}
	if (repeatRowArr.length>0){
		ErrMsgArr.push(repeatRowArr.join("</br>")+"数据重复！")
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("提示","新生儿姓名配置 "+ErrMsgArr.join("</br>"));
		return false;
	}
	//获取分娩记录同步体征项配置数据
	var allTableDataArr=[];
	var NullValColumnArr=[],repeatRowArr=[];
	saveDataArr.push({
		tableClass:"CF.NUR.Delivery.SyncVitalSign",
		tableName:"CF_NUR_Delivery.SyncVitalSign",
		tableData:[]
	});
	var rows=$("#tabDeliveryRecSyncVitalSignSet").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var rowDataArr=[];
		var editors=$('#tabDeliveryRecSyncVitalSignSet').datagrid('getEditors',i);
		//if (editors.length ==0) continue;
		if(editors.length >0 ){
			var oneRepeatRowArr=[],oneNullValColumnArr=[];
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				var fieldType=editors[k].type;
				if (fieldType =="combobox"){
					var value=editors[k].target.combobox('getValue');
				}else {
					var value=editors[k].target.val();
				}
				value=$.trim(value);
				var fieldOpts = $('#tabDeliveryRecSyncVitalSignSet').datagrid('getColumnOption',field);
				// 必填验证
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						oneNullValColumnArr.push(fieldOpts.title);
					}
				}
				rowDataArr.push({"field":field,"fieldValue":value});
				if (JSON.stringify(allTableDataArr).indexOf(JSON.stringify({"field":field,"fieldValue":value}))>=0) {
					oneRepeatRowArr.push(fieldOpts.title)
				}
			}
			if (oneRepeatRowArr.length>0){
				repeatRowArr.push("第"+(i+1)+"行"+oneRepeatRowArr.join("、"));
			}
			if (oneNullValColumnArr.length>0){
				NullValColumnArr.push("第"+(i+1)+"行"+oneNullValColumnArr.join("、"));
			}
			rowDataArr.push({"field":"DSSHospDr","fieldValue":window.parent.GetHospId()});
			saveDataArr[2].tableData.push(rowDataArr);
		}else{
			var opts = $('#tabDeliveryRecSyncVitalSignSet').datagrid('getColumnFields');
			for (var k=0;k<opts.length;k++){
				var field=opts[k];
				rowDataArr.push({"field":field,"fieldValue":rows[i][field]});
			}  
			rowDataArr.push({"field":"DSSHospDr","fieldValue":window.parent.GetHospId()});
		}
		allTableDataArr.push(rowDataArr);
	}
	var ErrMsgArr=[];
	if (NullValColumnArr.length>0){
		ErrMsgArr.push(NullValColumnArr.join("、")+"不能为空！")
	}
	if (repeatRowArr.length>0){
		ErrMsgArr.push(repeatRowArr.join("、")+"数据重复！")
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("提示","分娩记录同步体征项 "+ErrMsgArr.join("</br>"));
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Delivery.RecordConfig",
		MethodName:"saveDeliverySet",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			loadOtherSet();
			loadBabyNameSet();
			$('#tabDeliveryRecSyncVitalSignSet').datagrid("reload");
			$.messager.popover({msg: '保存成功！',type: 'success'});
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
function initTip(){
	$('#babyGenerateRule').after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:"自动：新生儿姓名自动显示为“母亲姓名之+(子/女/婴)+性别对应的第几个或分娩序号”。<br>例如：例如第一个活产男孩、第二个活产女孩，第三个死胎女孩，第四个活产女孩、第五个活产未知性别，<br>活产新生儿姓名分别显示为“母亲姓名之子1、母亲姓名之女1、母亲姓名之女2、母亲姓名之婴5”。<br>"+
		        "手动：新生儿姓名为下拉单选，下拉框选项根据活产顺序数和性别来显示。<br>&nbsp&nbsp&nbsp&nbsp例如活产顺序数1维护了性别“男”的“之子、大男”，分娩记录添加的第一个活产男孩的姓名可选“母亲姓名之子、母亲姓名大男”。"
    }));
    
    var _content = "配置哪些分娩方式不自动插入“分娩”类型事件，例如刨宫产不插入分娩事件；如果分娩方式多选其中包含配置的分娩方式，不插入分娩事件。" 		
	$("#noInsertEvent-tip").tooltip({
		width:500,
		trigger:'hover',
		content:_content,
		position:'left'
	});
	
	var _content = "与体征项关联后，保存分娩记录自动同步为出生时间点下关联体征项的数值。" 		
	$("#syncSign-tip").tooltip({
		width:500,
		trigger:'hover',
		content:_content,
		position:'left'
	});
	
}