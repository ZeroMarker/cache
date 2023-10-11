$.extend($.fn.datagrid.defaults, {
	onBeforeDrag: function(row){},	// return false to deny drag
	onStartDrag: function(row){},
	onStopDrag: function(row){},
	onDragEnter: function(targetRow, sourceRow){},	// return false to deny drop
	onDragOver: function(targetRow, sourceRow){},	// return false to deny drop
	onDragLeave: function(targetRow, sourceRow){},
	onBeforeDrop: function(targetRow, sourceRow, point){},
	onDrop: function(targetRow, sourceRow, point){},	// point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
	enableDnd: function(jq, index){
		return jq.each(function(){
			var target = this;
			var state = $.data(this, 'datagrid');
			state.disabledRows = [];
			var dg = $(this);
			var opts = state.options;
			if (index != undefined){
				var trs = opts.finder.getTr(this, index);
			} else {
				var trs = opts.finder.getTr(this, 0, 'allbody');
			}
			trs.draggable({
				disabled: false,
				revert: true,
				cursor: 'pointer',
				proxy: function(source) {
					var index = $(source).attr('datagrid-row-index');
					var tr1 = opts.finder.getTr(target, index, 'body', 1);
					var tr2 = opts.finder.getTr(target, index, 'body', 2);
					var p = $('<div style="z-index:9999999999999"></div>').appendTo('body');
					tr2.clone().removeAttr('id').removeClass('droppable').appendTo(p);
					tr1.clone().removeAttr('id').removeClass('droppable').find('td').insertBefore(p.find('td:first'));
					$('<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>').insertBefore(p.find('td:first'));
					p.find('td').css('vertical-align','middle');
					p.hide();
					return p;
				},
				deltaX: 15,
				deltaY: 15,
				onBeforeDrag:function(e){
					if (opts.onBeforeDrag.call(target, getRow(this)) == false){return false;}
					if ($(e.target).parent().hasClass('datagrid-cell-check')){return false;}
					if (e.which != 1){return false;}
					opts.finder.getTr(target, $(this).attr('datagrid-row-index')).droppable({accept:'no-accept'});
				},
				onStartDrag: function() {
					$(this).draggable('proxy').css({
						left: -10000,
						top: -10000
					});
					var row = getRow(this);
					opts.onStartDrag.call(target, row);
					state.draggingRow = row;
				},
				onDrag: function(e) {
					var x1=e.pageX,y1=e.pageY,x2=e.data.startX,y2=e.data.startY;
					var d = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
					if (d>3){	// when drag a little distance, show the proxy object
						$(this).draggable('proxy').show();
						var tr = opts.finder.getTr(target, parseInt($(this).attr('datagrid-row-index')), 'body');
						$.extend(e.data, {
							startX: tr.offset().left,
							startY: tr.offset().top,
							offsetWidth: 0,
							offsetHeight: 0
						});
					}
					this.pageY = e.pageY;
				},
				onStopDrag:function(){
					for(var i=0; i<state.disabledRows.length; i++){
						var index = dg.datagrid('getRowIndex', state.disabledRows[i]);
						if (index >= 0){
							opts.finder.getTr(target, index).droppable('enable');
						}
					}
					state.disabledRows = [];
					var index = dg.datagrid('getRowIndex', state.draggingRow);
					dg.datagrid('enableDnd', index);
					opts.onStopDrag.call(target, state.draggingRow);
				}
			}).droppable({
				accept: 'tr.datagrid-row',
				onDragEnter: function(e, source){
					if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false){
						allowDrop(source, false);
						var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(getRow(this));
					}
				},
				onDragOver: function(e, source) {
					var targetRow = getRow(this);
					if ($.inArray(targetRow, state.disabledRows) >= 0){return;}
					var pageY = source.pageY;
					var top = $(this).offset().top;
					var bottom = top + $(this).outerHeight();
					
					allowDrop(source, true);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					if (pageY > top + (bottom - top) / 2) {
						tr.children('td').css('border-bottom','1px solid red');
					} else {
						tr.children('td').css('border-top','1px solid red');
					}
					
					if (opts.onDragOver.call(target, targetRow, getRow(source)) == false){
						allowDrop(source, false);
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(targetRow);
					}
				},
				onDragLeave: function(e, source) {
					allowDrop(source, false);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					opts.onDragLeave.call(target, getRow(this), getRow(source));
				},
				onDrop: function(e, source) {
					var sourceIndex = parseInt($(source).attr('datagrid-row-index'));
					var destIndex = parseInt($(this).attr('datagrid-row-index'));
					
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					var td = tr.children('td');
					var point =  parseFloat(td.css('border-top-width')) ? 'top' : 'bottom';
					td.css('border','');
					
					var rows = dg.datagrid('getRows');
					var dRow = rows[destIndex];
					var sRow = rows[sourceIndex];
					if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false){
						return;
					}
					insert();
					opts.onDrop.call(target, dRow, sRow, point);
					
					function insert(){
						var row = $(target).datagrid('getRows')[sourceIndex];
						var index = 0;
						if (point == 'top'){
							index = destIndex;
						} else {
							index = destIndex+1;
						}
						if (index < sourceIndex){
							dg.datagrid('deleteRow', sourceIndex).datagrid('insertRow', {
								index: index,
								row: row
							});
							dg.datagrid('enableDnd', index);
						} else {
							dg.datagrid('insertRow', {
								index: index,
								row: row
							}).datagrid('deleteRow', sourceIndex);
							dg.datagrid('enableDnd', index-1);
						}
					}
				}
			});
			
			function allowDrop(source, allowed){
				var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
				icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
			}
			function getRow(tr){
				return opts.finder.getRow(target, $(tr));
			}
		});
	}
});
//===================================================================================================================

var hospComp="",hospID = session['LOGON.HOSPID']
var applyAreaList=[],sourceList=[],applyColList=[],sourceList2=[];
$(function() {
	hospComp = GenHospComp("Nur_IP_ChartPatient",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;  
		initPatientZoneSet();   	
    	reloadFieldGrid();
    	reloadColorGrid();
	}  ///选中事件	
	
	initCombobox();
	initPatientZoneSet();
	initFieldTable();    
    reloadFieldGrid();
    initColorTable();
    reloadColorGrid();
})

// 获取数据源及适用区域数据
function initCombobox(){
	applyAreaList=$.cm({
		ClassName:"Nur.NIS.Service.Chart.DictConfig",
		QueryName:"ChartDictList",
		category:"applyArea",
		filterStop:"Y"
	},false)["rows"];
	sourceList=$.cm({
		ClassName:"Nur.NIS.Service.Chart.DictConfig",
		QueryName:"ChartDictList",
		category:"patientInfo",
		filterStop:"Y"
	},false)["rows"];
	$('#applyArea').combobox({
        valueField:"CValue",
        textField:"Description",
		data: applyAreaList
	});
	$('#fieldSource').combobox({
        valueField:"rowid",
        textField:"Description",
		data: sourceList
	});
	/// 显示信息颜色配置-数据源
	sourceList2=$.cm({
		ClassName:"Nur.NIS.Service.Chart.DictConfig",
		QueryName:"ChartDictList",
		category:"patientColor",
		filterStop:"Y"
	},false)["rows"];
	$('#itemSource').combobox({
        valueField:"rowid",
        textField:"Description",
		data: sourceList2
	});
}


// 保存区域设置
function savePatientZoneSet(){
	var IfShowTransing=$("#Transing").switchbox('getValue') ? "Y" : "N";
	var TransDays=$.trim($("#TransDays").numberbox("getValue")); 
	var IfShowDischarge=$("#Discharge").switchbox('getValue') ? "Y" : "N"; 
	var DischargeDays=$.trim($("#DischargeDays").numberbox("getValue")); 
	$.m({
		ClassName:"Nur.NIS.Service.Chart.PatientSetting",
		MethodName:"SavePatientZoneSet",
		"IfShowTransing":IfShowTransing,
		"TransDays":TransDays,
		"IfShowDischarge":IfShowDischarge,
		"DischargeDays":DischargeDays,
		"HospID":hospID
	},function testget(result){
		if(result == "0"){
			$.messager.alert("简单提示", "保存成功！", 'success');							
		}else{
			$.messager.alert("简单提示", "保存失败！", 'error');		
		}
	});
}

// 区域配置
function initPatientZoneSet(){
	runClassMethod("Nur.NIS.Service.Chart.PatientSetting","GetPatientZoneSet",{"hospID":hospID},function(data){
		if(data.length>0){
			$("#Transing").switchbox('setValue',data[0]=="Y" ? true : false);
			$("#TransDays").numberbox("setValue",data[1]);	
			$("#Discharge").switchbox('setValue',data[2]=="Y" ? true : false);
			$("#DischargeDays").numberbox("setValue",data[3]);
		}
	},'json',false)	
}

// 显示信息内容table
function initFieldTable(){
	$('#dg').datagrid({
		fit : true,
		columns :[[
	    	{field:'fieldName',title:'列名',width:120},  
	    	{field:'fieldWidth',title:'列宽',width:80},  
	    	{field:'fieldSource',title:'数据源',width:160}, 
	    	{field:'applyArea',title:'适用区域',width:200,formatter:function(value,row,index){
		    	var desc="全部";
		    	if(value!=""){			    	
			    	var arr=value.split("@"),descArr=[];
			    	applyAreaList.forEach(function(item){
				    	if(arr.indexOf(item.CValue)>-1){
					    	descArr.push(item.Description);
					    }	
				    })
				    desc=descArr.join(",");
		    	}
		    	return desc;	
		    }}, 
	    	{field:'ifFixedCol',title:'固定列',width:100,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    }},    
	    	{field:'ifSortCol',title:'排序切换',width:100,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    }}    
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
	                $('#field-dialog').dialog({title:"新增显示信息内容",iconCls:"icon-w-add"}).dialog("open");	
	                $('#field-form').form("clear");	                 
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
	                modifyField();
	            }
	        },
	        {
	            iconCls: 'icon-save',
	            text: '排序',
	            handler: function () {
	                saveSort();
	            }
	        },
	        {
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	delPatientSet("field");
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '加载中..',onLoadSuccess:function(){
			$(this).datagrid('enableDnd');
		},
		onDrop:function(targetRow,sourceRow,point){
			console.log(targetRow);
			console.log(sourceRow);
			console.log(point);	
			var rows=$("#dg").datagrid("getRows");
			console.log(rows);
			//dropBtnCol("dg-btn","B");
		} 
	});  
}

// 列表数据加载
function reloadFieldGrid()
{
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Chart.PatientSetting",
		QueryName:"GetPatientFeildList",
		hospID:hospID
	},false)
	$("#dg").datagrid('loadData',data); 
	applyColList=data.rows; // 颜色配置-适用列
}

function saveFields(){
	var rowid=$.trim($("#fieldID").val());
	var fieldName=$.trim($("#fieldName").val());
	var fieldWidth=$.trim($("#fieldWidth").val());
	var fieldSource=$("#fieldSource").combobox('getValue');
	var applyArea=$("#applyArea").combobox('getValues');
	var ifFixedCol=$("#ifFixedCol").radio('getValue') ? "Y" : "N";
	var ifSortCol=$("#ifSortCol").radio('getValue') ? "Y" : "N";
	var allRows=$("#dg").datagrid("getRows");
	var sequence=allRows.length+1;
	if(fieldName == "")
	{
		$.messager.popover({ msg: '列名不能为空！', type:'error' });
    	return false;
	}
	if(fieldWidth == "")
	{
		$.messager.popover({ msg: '列宽不能为空！', type:'error' });
    	return false;
	}
	if(fieldSource == "")
	{
		$.messager.popover({ msg: '数据源不能为空！', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.Chart.PatientSetting",
		MethodName:"SavePatientFieldSet",
		"rowid":rowid,
		"fieldName":fieldName,
		"fieldWidth":fieldWidth,
		"fieldSource":fieldSource,
		"applyArea":applyArea.join("@"),
		"ifFixedCol":ifFixedCol,
		"ifSortCol":ifSortCol,
		"sequence":sequence,
		"hospID":hospID
	},function testget(result){		
		$('#field-dialog').dialog("close");		
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadFieldGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});	
}

// 修改选中的配置数据时，数据回显
function modifyField(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
		$('#field-dialog').dialog({title:"修改显示信息内容",iconCls:"icon-w-edit"}).dialog("open");		
	   	$('#field-form').form("clear");
	 	$('#field-form').form("load",{
	 		fieldID: rows[0].rowid,
	 		fieldName: rows[0].fieldName,
	 		fieldWidth: rows[0].fieldWidth,
	 		fieldSource: rows[0].fieldSourceDR,
	 		applyArea: rows[0].applyArea ? rows[0].applyArea.split("@") : [],
	 		Source: rows[0].source
 		}); 
 		if(rows[0].ifFixedCol=="Y"){
			$("#ifFixedCol").checkbox("check");
		}else{
			$("#ifFixedCol").checkbox("uncheck");
		}
		if(rows[0].ifSortCol=="Y"){
			$("#ifSortCol").checkbox("check");
		}else{
			$("#ifSortCol").checkbox("uncheck");
		}			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的配置数据", "info");
 	}
}

// 删除选中的配置数据
function delPatientSet(flag){
	var rows=flag=="field" ? $('#dg').datagrid("getSelections") : $('#dg2').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("简单提示", "确定要删除该配置数据吗？", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.Chart.PatientSetting",
					MethodName:"DeletePatientSet",
					"rowid":rows[0].rowid,
					"flag":flag
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"删除成功！", type:'success'});
						if(flag=="field"){			
							reloadFieldGrid();
						}else{
							reloadColorGrid();	
						}						
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

// 保存排序
function saveSort(){
	var allRows=$("#dg").datagrid("getRows");
	if(allRows.length>0){
		var arr=[],arr2=[];
		allRows.forEach(function(row){
			if(row.ifFixedCol=="Y"){
				arr.push(row.rowid);
			}else{
				arr2.push(row.rowid);
			}				
		})
		var newArr=arr.concat(arr2);
		var idStr=newArr.join("^");
		$.m({
			ClassName:"Nur.NIS.Service.Chart.PatientSetting",
			MethodName:"SortPatientField",
			idStr:idStr
		},function testget(result){			
			if(result == "0"){			
				$.messager.popover({msg:"排序成功！", type:'success'});			
				reloadFieldGrid();						
			}else{	
				$.messager.popover({ msg: result, type:'error' });	
			}
		});
	}	
}

// 显示信息颜色table
function initColorTable(){
	$('#dg2').datagrid({
		fit : true,
		columns :[[
	    	{field:'itemName',title:'项目名称',width:160},
	    	{field:'itemSource',title:'数据源',width:160}, 
	    	{field:'itemColor',title:'颜色',width:160,styler: function(value,row,index){
				return 'background-color:'+value;
			}}, 
	    	{field:'applyCol',title:'适用列',width:200,formatter:function(value,row,index){
		    	var desc="";
		    	if(value!=""){		
			    	applyColList.forEach(function(item){
				    	if(value==item.rowid){
					    	desc=item.fieldName;
					    }	
				    })
		    	}
		    	return desc;	
		    }}  
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '新增',
	            handler: function () {
	                $('#color-dialog').dialog({title:"新增显示信息颜色"}).dialog("open");	
	                $('#color-form').form("clear");	
	                $('#applyCol').combobox({
				        valueField:"rowid",
				        textField:"fieldName",
						data: applyColList
					}); 
                	$("#itemColor").color({
						editable:true,
						required:true,
						width:167,
						height:30
					}).color("setValue","").combo('setText', "");                
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '修改',
	            handler: function () {
	                modifyColorSet();
	            }
	        },
	        {
            	iconCls: 'icon-cancel',
            	text: '删除',
            	handler: function () {
                	delPatientSet("color");
            	}
         	}
        ],
		singleSelect : true
	});  
}

// 列表数据加载
function reloadColorGrid()
{
	$.cm({
		ClassName:"Nur.NIS.Service.Chart.PatientSetting",
		QueryName:"GetPatientColorList",
		hospID:hospID
	},function(data){
		$("#dg2").datagrid('loadData',data); 
	})
}

// 修改选中的颜色配置数据时，数据回显
function modifyColorSet(){	
	var rows=$('#dg2').datagrid("getSelections");
	if (rows.length == 1) {
		$('#color-dialog').dialog({title:"修改显示信息内容",iconCls:"icon-w-edit"}).dialog("open");	
		$('#applyCol').combobox({
	        valueField:"rowid",
	        textField:"fieldName",
			data: applyColList
		});     	   	
	   	$('#color-form').form("clear");	   	
	 	$('#color-form').form("load",{
	 		colorID: rows[0].rowid,
	 		itemName: rows[0].itemName,
	 		itemSource: rows[0].itemSourceDR,
	 		applyCol: rows[0].applyCol ? rows[0].applyCol : "",
 		});
 		$("#itemColor").color({
			editable:true,
			required:true,
			width:167,
			height:30
		}).color("setValue",rows[0].itemColor); 			
 	}else{
    	$.messager.alert("简单提示", "请选择要修改的配置数据", "info");
 	}
}

/// 保存显示信息颜色配置
function saveColorSet(){
	var rowid=$.trim($("#colorID").val());
	var itemName=$.trim($("#itemName").val());
	var itemSource=$("#itemSource").combobox('getValue');
	var applyCol=$("#applyCol").combobox('getValue');
	var itemColor=$("#itemColor").color("getValue");
	var allRows=$("#dg2").datagrid("getRows");
	if(itemName == "")
	{
		$.messager.popover({ msg: '项目名称不能为空！', type:'error' });
    	return false;
	}
	if(itemSource == "")
	{
		$.messager.popover({ msg: '数据源不能为空！', type:'error' });
    	return false;
	}
	if(applyCol == "")
	{
		$.messager.popover({ msg: '适用列不能为空！', type:'error' });
    	return false;
	}
	if(itemColor == "")
	{
		$.messager.popover({ msg: '颜色不能为空！', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.Chart.PatientSetting",
		MethodName:"SavePatientColorSet",
		"rowid":rowid,
		"itemName":itemName,
		"itemSource":itemSource,
		"applyCol":applyCol,
		"itemColor":itemColor,
		"hospID":hospID
	},function testget(result){		
		$('#color-dialog').dialog("close");		
		if(result == "0"){			
			$.messager.popover({msg:"保存成功！", type:'success'});			
			reloadColorGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});	
}