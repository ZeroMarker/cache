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
var hospComp="",hospID = session['LOGON.HOSPID'],savedSheets=[]
var deptTypeList=[
	{
		value:"A",
		label:"全部"	
	},
	{
		value:"C",
		label:"本科室及病区"	
	},
	{
		value:"O",
		label:"其他科室"	
	}
];
$(function() {
	hospComp = GenHospComp("Nur_IP_ExecuteGroup",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId; 
		var type=$("#mode").combobox("getValue");
		getLinkData(type); 
		reloadDataGrid(type,"");
		getAllBills(); 
		$("#dg2").datagrid("loadData",[]);
	}  ///选中事件	
	
	initUI();
	
	$("body").on("click","#right .allBills li",function(){
		$(this).toggleClass("selected");	
	})
	$("body").on("click","#right .selectedBills li",function(){
		$(this).toggleClass("selected").siblings().removeClass("selected");	
	})
})

// 初始化页面
function initUI(){
    // 初始化配置方式
    $HUI.combobox("#mode",
	{
		panelHeight:"60",
		valueField:"value",
		textField:"label",
		data:[{value:1,label:"安全组"},{value:2,label:"科室"}],
		onSelect:function(record){
			if(record.value==1){
				// 安全组
				$("#left td.name").html("安全组").css("paddingLeft","0");
				getLinkData("1","","");	
			}else{
				// 科室	
				$("#left td.name").html("科室").css("paddingLeft","14px");
				getLinkData("2","","");
			}
		}
	});
	// 默认配置方式
	$("#mode").combobox("setValue",1);
	getLinkData("1","","");
	// 初始化table
	initTable();
	reloadDataGrid("1","");
	// 初始化全部单据
	initAllBillsTable();
	getAllBills();
	// 初始化选中单据
	initSelSheet();
}

// 查询
function onSearch(){
	var type=$("#mode").combobox("getValue");
	var desc=$("#linkData").combogrid("getText");
	reloadDataGrid(type,desc)	
}

// 安全组/科室列表
function getLinkData(type){
	$HUI.combogrid("#linkData", {
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ID',
		textField: 'Group',
		columns: [[
			{field:'Group',title:'名称',width:80},
			{field:'ID',title:'ID',width:20},
			{field:'setWayCode',title:'setWayCode',width:40},
			{field:'hospDesc',title:'院区',width:100,hidden:type=="1" ? true : false},
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.OrderExcute.GroupConfig&QueryName=GetGroupItem",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{type:type,desc:desc,hospId:$HUI.combogrid('#_HospList').getValue(),configName:"Nur_IP_ExecuteGroup"});
		}
	});	
}

// 初始化安全组/科室table
function initTable(){
	$('#dg').datagrid({
		fit:true,
		columns:[[
	    	{field:'ID',title:'ID',width:100},  
	    	{field:'Group',title:'名称',width:300}	    	       
		]],
		pagination:true,  //是否分页
		pageSize:20,
		pageList:[20,30,50,100],
		singleSelect:true,
		loadMsg:'加载中..',
		onClickRow:function(rowIndex,rowData){
			getAllBills();
			reloadSelSheet(rowData.ID);
//			var type=$("#mode").combobox("getValue");
//			$.cm({
//				ClassName:"Nur.NIS.Service.OrderExcute.GroupConfig",
//				QueryName:"GetGroupSheet",
//				hospId:hospID,
//				type:type,
//				groupItem:rowData.ID
//			},function(data){
//				var result=data.rows;
//				var html="";
//				if(result.length>0){					
//					result.forEach(function(val,index){
//						var billid=val.ID;
//						var name=val.Name;
//						var className=val.DefaultID=="Y" ? "selected" : "";
//						html+="<li class='"+className+"' data-billid="+billid+">"+name+"</li>";
//						$("#right .allBills li[data-billid="+billid+"]").addClass("selected");	
//					})									
//				}else{
//					$("#right .allBills li").removeClass("selected");
//				}
//				$("#right .selectedBills ul").html(html);		
//			})	
		}
	});	
}

// 加载安全组/科室table数据
function reloadDataGrid(type,desc){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.GroupConfig",
		QueryName:"GetGroupItem",
		"type":type,
		"desc":desc,
		"hospId":hospID,
		"configName":"Nur_IP_ExecuteGroup",
		rows:99999
	},function(data){
		$("#dg").datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})	
}

// 加载全部单据
function initAllBillsTable(){
	$('#dg-allsheet').datagrid({
		fit:true,
		columns:[[
	    	{field:'Name',title:'名称',width:180,styler:function(value,row,index){
		    	var style="";
		    	if(savedSheets.length>0){
			    	if(savedSheets.indexOf(row.ID)>-1){
				    	style="color:#40A2DE;"		
				    }
			    }
			    return style;
		    }}       
		]],
		toolbar:[],
		loadMsg:'加载中..'
	});		
}
function getAllBills(){
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetAllSheet",
		hospId:hospID,
		filter:"",
		applyServices:"NurExecute",
		rows:99999
	},function(data){
		$("#dg-allsheet").datagrid("loadData",data);
	})		
}

// 右移
function moveRight(){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length>0){
		var rows=$("#dg-allsheet").datagrid("getSelections");
		if(rows.length>0){
			var allSelSheet=$("#dg2").datagrid("getRows");
			rows.forEach(function(val){
				var billid=val.ID;
				var code=val.Code;
				var name=val.Name;
				if(allSelSheet.length==0){
					$('#dg2').datagrid('appendRow',{ID:billid,Name:name,Default:"",ordDepType:"C"}).datagrid('enableDnd');
				}else{
					var ind=allSelSheet.findIndex(function(val){
						return val.ID==billid;	
					});	
					if(ind==-1) $('#dg2').datagrid('appendRow',{ID:billid,Name:name,Default:"",ordDepType:"C"}).datagrid('enableDnd');
				}				
			})
			$("#dg-allsheet").datagrid("unselectAll");
		}else{
			$.messager.alert("简单提示", "请选择要右移的单据！", "info");		
		}
	}else{
		$.messager.alert("简单提示", "请选择安全组或科室！", "info");	
	}	
}
// 左移
function moveLeft(){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length>0){
		var selRows=$("#dg2").datagrid("getSelections");		
		if(selRows.length>0){
			var allRows=$("#dg2").datagrid("getRows");
			selRows.forEach(function(val){				
				var index=allRows.findIndex(function(val2){
					return val2.ID==val.ID;	
				})
				$("#dg2").datagrid("deleteRow",index);
			})
		}else{
			$.messager.alert("简单提示", "请选择要左移的单据！", "info");		
		}
	}else{
		$.messager.alert("简单提示", "请选择安全组或科室！", "info");	
	}	
}
// 上移
function moveUp(){
	var elements=$("#right .selectedBills li.selected");
	if(elements.length>0){
		$(elements[0]).prev().insertAfter($(elements[0]));
	}else{
		$.messager.alert("简单提示", "请选择要移动的单据！", "info");		
	}	
}
// 下移
function moveDown(){
	var elements=$("#right .selectedBills li.selected");
	if(elements.length>0){
		$(elements[0]).next().insertBefore($(elements[0]));
	}else{
		$.messager.alert("简单提示", "请选择要移动的单据！", "info");		
	}	
}

// 保存
function saveSheets(){
	if(editIndex!="undefined") $("#dg2").datagrid("endEdit",editIndex);
	var type=$("#mode").combobox("getValue");
	var rows=$("#dg").datagrid("getSelections");
	var groupid=rows[0].ID;
	var sheetIdStr="";
	var defaultSheetId=""
	var ordDepTypeStr=""
	var allSelSheet=$("#dg2").datagrid("getRows");
	console.log(allSelSheet);
	if(allSelSheet.length>0){
		allSelSheet.forEach(function(val,index){
			sheetIdStr=sheetIdStr=="" ? val.ID : sheetIdStr+"^"+val.ID;
			ordDepTypeStr=ordDepTypeStr=="" ? val.ordDepType : ordDepTypeStr+"^"+val.ordDepType;
		})
	}		
	var checkedRow=$("#dg2").datagrid("getChecked");
	if(checkedRow.length>0) defaultSheetId=checkedRow[0].ID;
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.GroupConfig",
		MethodName:"SaveGroupSheet",
		hospId:hospID,
		type:type,
		groupItem:groupid,
		sheetIdStr:sheetIdStr,
		defaultSheetId:defaultSheetId,
		rows:99999
	},function(data){
		if(data==0){
			$.messager.alert("简单提示", "保存成功！", "success");	
			editIndex=undefined;	
			reloadSelSheet(groupid);
		}else{
			$.messager.alert("简单提示", "保存失败！", "success");		
		}
	})	
}
var editIndex;
// 初始化选中的单据列表
function initSelSheet(){
	$('#dg2').datagrid({
		fit:true,
		columns:[[
			{field:'ck',title:'默认单据',checkbox:true},
	    	{field:'Name',title:'名称',width:200},  
	    	{field:'ordDepType',title:'开单科室',width:120,hidden:true,formatter:function(value,row,index){
		    	var desc="全部";
		    	if(value!=""){
			    	deptTypeList.forEach(function(val){
				    	if(value==val.value){
					    	desc=val.label;	
					    }	
				    })	
			    }	
			    return desc;
		    },editor:{type:'combobox'}}	    	       
		]],
		toolbar:[],
		checkOnSelect:false,
		selectOnCheck:false,
		loadMsg:'加载中..',
		onCheck:function(rowIndex,rowData){
			// 行多选，复选框单选，选中单据作为默认单据
			var checkedRows=$(this).datagrid("getChecked");
			var allRows=$(this).datagrid("getRows");
			if(checkedRows.length>0){
				checkedRows.forEach(function(val,index){
					if(val.ID!=rowData.ID){
						var ind=allRows.findIndex(function(val2){
							return val.ID==val2.ID;	
						})
						$("#dg2").datagrid("uncheckRow",ind);		
					}	
				})	
			}
		},
		onLoadSuccess:function(){
			$(this).datagrid('enableDnd');
		},
		onDblClickRow:function(rowIndex,rowData){
			if(editIndex!="undefined") $("#dg2").datagrid("endEdit",editIndex);
			editIndex=rowIndex;	
			$("#dg2").datagrid("beginEdit",editIndex);	
			var ed=$("#dg2").datagrid("getEditor",{index:editIndex,field:'ordDepType'});
			$(ed.target).combobox({
				valueField:"value",
				textField:"label",
				width:120,
				data:deptTypeList,
				onLoadSuccess:function(){
					$(this).combobox("setValue",ed.oldHtml);
				}
			})
		}
	});	
	//$(".datagrid-header-check").children('input')[0].style.visibility="hidden";  
	$(".datagrid-header-check").html('<span>默认单据</span>');		
}
function reloadSelSheet(groupID){
	var type=$("#mode").combobox("getValue");
	var data=$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.GroupConfig",
		QueryName:"GetGroupSheet",
		hospId:hospID,
		type:type,
		groupItem:groupID
	},false);
	savedSheets=[];
	$('#dg2').datagrid("loadData",data);
	if(data.rows.length>0){
		data.rows.forEach(function(val,index){
			savedSheets.push(val.ID);
			if(val.Default=="Y") $('#dg2').datagrid("checkRow",index);
		})
	}
}