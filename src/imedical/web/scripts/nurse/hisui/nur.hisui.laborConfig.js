/*
 * @Author: ouzilin 
 * @Date: 2022-08-15 18:37:21 
 * @Last Modified by: ouzilin
 * @Last Modified time: 2023-04-14 11:04:22
 */

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

$.extend($.fn.datagrid.methods, {
	getEditingRowIndex: function(jq){
		var rows= $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
		var indexs = [];
		rows.each(function(i, row){
			var index = row.sectionRowIndex;
			if (indexs.indexOf(index) == -1)
			{
				indexs.push(index);
			}
		})
		return indexs
	}
})

var GV = {
    _CLASSNAME: "Nur.NIS.Service.Labor.Config",
	FieldType: [],
	FieldAlign: [{
		value:"left",
		desc:"左对齐"
	},{
		value:"right",
		desc:"右对齐"
	},{
		value:"center",
		desc:"居中"
	}],
	FontFamilyList: [{
		value:"黑体",
		desc:"黑体"
	},{
		value:"宋体",
		desc:"宋体"
	},{
		value:"Microsoft Himalaya",
		desc:"Microsoft Himalaya"
	}],
	FontAlignList: [{
		value:"Center",
		desc:"居中"
	},{
		value:"start",
		desc:"左对齐"
	},{
		value:"end",
		desc:"右对齐"
	}],
	FontWeightList:[{
		value:"bold",
		desc:"加粗"
	},{
		value:"normal",
		desc:"正常"
	}],
	TextBasicData: [],
	OBSItem: [],
	LineTypeList:[{
		value:"Y",
		desc:"实线"
	},{
		value:"N",
		desc:"虚线"
	}],
	LineWidthList:[{
		value:"Y",
		desc:"普通"
	},{
		value:"N",
		desc:"加粗"
	}],
	ConditionList:[{
		value:">",
		desc:">"
	},{
		value:">=",
		desc:">="
	}]
}

function HospChange(){
	initLogoConfig({})
	$(".show-img").hide();
	$('#obsItemTable,#charsTable,#textConfigTable,#sheetConfigTable,#curveConfigTable,#curveStartConfigTable').datagrid("rejectChanges")
	initUI();    	
}

$(function() {
	initTextDataSourceWin()
    initUI()
})

function initUI(){
	initBasicData()             //获取基础数据
    initObsItemTable()          //产程记录配置
    initCharsTable()            //产程图打印列表配置
	//initLogoConfig()
    initTextConfigTable()       //产程图文本配置
    initSheetConfigTable()      //产程图表格配置
    initCurveConfigTable()      //产程图曲线配置
    initCurveStartConfigTable() //产程图开始条件配置
    initBorderWin()             //线框定义弹窗
	initWpLineConfig()          //警戒线、处理线
	initFullWombConfig()        //宫口全开
	initBirthMarkerConfig()     //分娩标记
	$('#save').on('click',function(){
		initSaveBtn()          //保存按钮
	})
}

/**
 * 获取基础数据
 */
function initBasicData(){
	
	GV.TextBasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getTextConfigBasicData",
		
	},false)

	GV.OBSItem = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getOBSItemCombox",
		hospID: getHosp()
	},false)

	GV.FieldType = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getOBSItemFieldType"
	},false)

	GV.LaborDataField = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getLaborDataField"
	},false)
}


/**
 * 文本配置-基础数据类型维护
 */
function openTextDataSourceWin()
{
	$('#textDataSourceWin').window('open')
	$('#textDataSourceTable').datagrid('reload')
}

/**
 * 初始化 文本配置-基础数据类型维护弹窗
 */
function initTextDataSourceWin(){

	
	$('#textDataSourceWin').window({
		top:"70px",
		width:900,  
		height:600,
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '文本配置-基础数据类型维护',
		iconCls:'icon-w-config'
	})


	$("#textDataSourceTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'code',title:'数据编码', width:100,editor:{type:'text'}},
				{field:'name',title:'名称', width:100,editor:{type:'text'}},
				{field:'note',title:'备注', width:100,editor:{type:'text'}},
				{field:'expression',title:'表达式', width:450,editor:{type:'text'}},
				{field: 'handler', title: '操作', width: 100, align:"center", formatter:function(value, row, index){
					return  "<span style='cursor:pointer' onclick='textDataSourceHandler.delete(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
					}
				}
			]
		],
		nowrap: false,
		singleSelect : true,
		autoSizeColumn:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getTextDataSource"
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#textDataSourceTable').datagrid("acceptChanges");
				$('#textDataSourceTable').datagrid("unselectAll");
				$('#textDataSourceTable').datagrid('appendRow',{});
                var rows= $('#textDataSourceTable').datagrid('getRows');
                $('#textDataSourceTable').datagrid('beginEdit',rows.length-1);
				$('#textDataSourceTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('保存'),
			handler: function(){
				textDataSourceHandler.save()
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#textDataSourceTable').datagrid("acceptChanges");
            $('#textDataSourceTable').datagrid("unselectAll");
            $('#textDataSourceTable').datagrid("beginEdit", rowIndex);
            $('#textDataSourceTable').datagrid("selectRow",rowIndex);
        }

	})
}

var textDataSourceHandler = {
	delete : function(id){
		if ("undefined" == id && id == "" ) return
		$.messager.confirm('提示','是否删除?',function(r){
			if (r)
			{
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "deleteTextDataSource",
					id: id
				},function(result){
					if (result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#textDataSourceTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		})
	},
	save: function(){
		var indexs = $('#textDataSourceTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#textDataSourceTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#textDataSourceTable').datagrid('getRows');
		$.m({	
			ClassName:GV._CLASSNAME,
			MethodName:"saveTextDataSource",
			saveDataJson:JSON.stringify(rows)
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#textDataSourceTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}
}

/**
 * 产程录入配置
 */
function initObsItemTable(){
    $("#obsItemTable").datagrid({
        url: $URL,
		fit: true,
		fitColumns: false,
		columns :[[
				{field:'id',hidden:true},
				{field:'code',title:'列选择', width:150,
				formatter: setFormatter(GV.LaborDataField),
				editor:{
					type:'combobox',
					options:{
						valueField:'value',
						textField:'desc',
						data: GV.LaborDataField,
						required : true,
						onSelect: function(newValue, oldValue){
							var indexs = $('#obsItemTable').datagrid('getEditingRowIndex');
							var editor=$("#obsItemTable").datagrid("getEditor",{index:indexs[0],field:'description'})
							$(editor.target).val(newValue.desc)
						}
					}
				}
				},	
				{field:'description',title:'描述',width:200,editor:{type:'text'}},
				{field:'startRange',title:'起始范围', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'endRange',title:'结束范围', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'fieldType',title:'类型', width:100,
					formatter: setFormatter(GV.FieldType ),
					editor:setEditor(GV.FieldType),
				},
				{field:'fieldWidth',title:'列宽', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'fieldAlign',title:'位置', width:100,
					formatter: setFormatter(GV.FieldAlign),
					editor:setEditor(GV.FieldAlign),  
				},
				{field:'options',title:'选项', width:300,editor:{type:'textarea'}},
				{field:'ifMultShow',title:'多胎时显示', width:90,align:'center',
            		formatter: function(value,row){
                		return value=="Y" ? "是":""
            		},	
            		editor:{type:'checkbox',options:{on:'Y',off:''}}
            	},
                {field: 'handler', title: '操作', width: 100, align:"center", formatter:function(value, row, index){
                    return  "<a onclick='deleteObsItem(\""+ row.id +"\")' class='icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
                    }
                }
			]
		],
        nowrap: false,
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
            param.ClassName = GV._CLASSNAME,
            param.MethodName = "getObsItem",
            param.hospID = getHosp()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
                $('#obsItemTable').datagrid("rejectChanges");
				$('#obsItemTable').datagrid("unselectAll");
				$('#obsItemTable').datagrid('appendRow',{});
                var rows= $('#obsItemTable').datagrid('getRows');
                $('#obsItemTable').datagrid('beginEdit',rows.length-1);
				$('#obsItemTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('保存'),
			handler: function(){
                var indexs = $('#obsItemTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "不存在正在编辑的行!", type:'error' });	
					return
				}
				$('#obsItemTable').datagrid('endEdit',indexs[0])
				var row = $('#obsItemTable').datagrid('getSelected',indexs[0])
				$.m({	
					ClassName:GV._CLASSNAME,
					MethodName:"saveObsItem",
					saveDataJson:JSON.stringify([row]),
					hospID:getHosp(),
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#obsItemTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#obsItemTable').datagrid("rejectChanges");
            $('#obsItemTable').datagrid("unselectAll");
            $('#obsItemTable').datagrid("beginEdit", rowIndex);
            $('#obsItemTable').datagrid("selectRow",rowIndex);
			var opts = $(this).datagrid("options");
			var trs = opts.finder.getTr(this, rowIndex);
			trs.draggable( 'disable')  //本列去掉拖拽，解决编辑的文本框不能选中的问题
        },
        onLoadSuccess:function(){
            //允许拖动行
			$(this).datagrid('enableDnd');
		},
        onDrop:function(targetRow,sourceRow,point){
			$cm({
				ClassName:GV._CLASSNAME,
				MethodName: "changeObsItemSequence",
				rows: JSON.stringify($('#obsItemTable').datagrid("getRows")),
				hospID:getHosp()
			}, function(rtn){
                if (rtn == 0)
                {
				    $.messager.popover({ msg: "保存成功！", type:'success' });
				    $('#obsItemTable').datagrid("reload");
                }else{
                    $.messager.popover({ msg: "保存失败！", type:'error' });
                }
			})
		}

	})	
}

/**
 * 
 * @param {*} id 产程记录表id 
 */
function deleteObsItem(id){
    if ("undefined" == id && id == "" ) return
	$.messager.confirm('提示','是否删除?',function(r){
		if (r)
		{
			$cm({
				ClassName: GV._CLASSNAME,
				MethodName: "deleteObsItem",
				id: id
			},function(result){
				if (result==0){
					$.messager.popover({ msg: "保存成功！", type:'success' });	
					$('#obsItemTable').datagrid('reload')
				}else{
					$.messager.popover({ msg: result, type:'error' });	
				}		
			})
		}
	})
}

/**
 * 产程图列表配置
 */
function initCharsTable(){
    $("#charsTable").datagrid({
	    fit:true,
        url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'isActive',title:'是否启用',width:70,align:'center',formatter:function(value,row,index){
                    return value=="Y" ? "<font color='green'>启用</font>" : "<font color='red'>停用</font>";	
                },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
				{field:'name',title:'描述',width:120,editor:{type:'text'}},
				{field:'ifHorizontalPrint',title:'横版打印',width:70,align:'center',formatter:function(value,row,index){
                    return value=="Y" ? "是" : "否";	
                },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
			]
		],
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
            param.ClassName = GV._CLASSNAME,
            param.MethodName = "getCharsTable",
            param.hospID = getHosp()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
                $('#charsTable').datagrid("rejectChanges");
				$('#charsTable').datagrid("unselectAll");
				$('#charsTable').datagrid('appendRow',{});
                var rows= $('#charsTable').datagrid('getRows');
                $('#charsTable').datagrid('beginEdit',rows.length-1);
				$('#charsTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('保存'),
			handler: function(){
                var indexs = $('#charsTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "不存在正在编辑的行!", type:'error' });	
					return
				}
				$('#charsTable').datagrid('endEdit',indexs[0])
				var row = $('#charsTable').datagrid('getSelected',indexs[0])
				$.cm({	
					ClassName:GV._CLASSNAME,
					MethodName:"saveCharsTable",
					saveDataJson:JSON.stringify([row]),
					hospID:getHosp(),
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#charsTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		},{
			iconCls: 'icon-copy',
			text:$g('复制'),
			handler: function(){
				$('#configCopyTable').datagrid('reload')
				$('#configCopyWin').window('open')
			}
		},{
			iconCls: 'icon-cancel',
			text:$g('删除'),
			handler: function(){
				var selectedRow = $('#charsTable').datagrid('getSelected')
				if (!selectedRow){
					$.messager.popover({ msg: "请选择一条记录！", type:'success' });
					return
				}
				$.messager.confirm('提示','是否删除?',function(r){
					if (r)
					{
						$cm({
							ClassName: GV._CLASSNAME,
							MethodName: "deleteConfigTable",
							id: selectedRow.id
						},function(result){
							if(result==0){
								$.messager.popover({ msg: "删除成功！", type:'success' });	
								$('#charsTable').datagrid('reload')
							}else{
								$.messager.popover({ msg: result, type:'error' });	
							}	
						})
					}
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#charsTable').datagrid("rejectChanges");
            $('#charsTable').datagrid("unselectAll");
            $('#charsTable').datagrid("beginEdit", rowIndex);
            $('#charsTable').datagrid("selectRow",rowIndex);
        },
        onClickRow: function(rowIndex, rowData){
            getLaborConfigInfo()
        }
	})	

	//跨院区复制弹窗
	$('#configCopyWin').window({
		top:"70px",
		width:900,  
		height:400,
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '复制',
		iconCls:'icon-w-config'
	})

	$("#configCopyTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'hospDesc',title:'医院名称', width:250},
				{field:'name',title:'描述', width:200},
				{field:'ifHorizontalPrint',title:'是否横向打印', align:"center",width:150},
				{field:'isActive',title:'是否启用', align:"center",width:150},
			]
		],
		nowrap: false,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getAllConfigTable"
        }
	})

	$('#closeConfigCopyWinBtn').on('click',function(){
		$('#configCopyWin').window('close')
	})
	
}

var charsTableHandler = {
	copy: function(){
		var selectedRow = $('#configCopyTable').datagrid('getSelected')
		if (!selectedRow){
			$.messager.popover({ msg: "请选择一条记录！", type:'success' });
			return
		}
		debugger
		$cm({
			ClassName: GV._CLASSNAME,
			MethodName: "copyConfigTable",
			copyId: selectedRow.id,
			hospID: getHosp()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "引入成功", type:'success' });
				$('#configCopyWin').window('close')
				$('#charsTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}	
		})
	}
}

/**
 * 图片设置
 */
function initLogoConfig(data){
	$(".td-img").html('<input id="img" class="hisui-filebox" name="file" value="'+data.ImgName+'" style="width:274px;" />');
		$HUI.filebox("#img",{
			plain:true,
			prompt:data.ImgName,
			onChange:function(){
				chooseImg();	
			}
		});
		$("#img").next().find("input.filebox-text").val(data.ImgName);
		$(".bg-layer").hide();
		$(".show-img img").attr("src",data.ImgSrc);
		if (!!data.ImgSrc)
		{
			$(".show-img").show();
		}
		$("#width").numberbox("setValue",data.ImgWidth);
		$("#height").numberbox("setValue",data.ImgHeight);
		$("#xAxis").numberbox("setValue",data.ImgXAxis);
		$("#yAxis").numberbox("setValue",data.ImgYAxis);
}

/**
 * 产程图 文本配置
 */
function initTextConfigTable(){

    createEditGrid('textConfigTable', [
        {field:'id',hidden:true},
        {field:'description',title:'描述', width:100,editor:{type:'text'}},
        {field:'printX',title:'坐标X',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'printY',title:'坐标Y', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'text',title:'文本', width:100, align:"center", editor:{type:'text'}},
        {field:'textWidth',title:'宽度(mm)', width:80, align:"center", editor:{type:'numberbox',options:{min:0}}},
        {field:'textFontFamily',title:'字体', width:80,align:'center',
            formatter: setFormatter(GV.FontFamilyList),
            editor:setEditor(GV.FontFamilyList),
        },
        {field:'textFontSize',title:'字号', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
		{field:'textFontColor',title:'字号颜色', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'textFontAlign',title:'对齐方式', width:90,align:'center',
            formatter: setFormatter(GV.FontAlignList),
            editor:setEditor(GV.FontAlignList),
        },
        {field:'textFontWeight',title:'加粗类型', width:90,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'item',title:'基础数据类型',width:110,align:'center',
            formatter: setFormatter(GV.TextBasicData),
            editor:setEditor(GV.TextBasicData),
        },
		{field:'loopTimes',title:'循环次数', width:80, align:'center',editor:{type:'numberbox',options:{min:1}}},
        {field:'itemWidth',title:'元素宽度(mm)',width:110,align:'center',editor:{type:'numberbox',options:{min:0}}},
        {field:'itemFontFamily',title:'元素字体',width:80,align:'center',
            formatter: setFormatter(GV.FontFamilyList),
            editor:setEditor(GV.FontFamilyList),
        },
        {field:'itemFontSize',title:'元素字号',width:80,align:'center',editor:{type:'numberbox',options:{min:0}}},
		{field:'itemFontColor',title:'元素颜色', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'itemFontAlign',title:'元素对齐方式',width:100,align:'center',
            formatter: setFormatter(GV.FontAlignList),
            editor:setEditor(GV.FontAlignList),
        },
        {field:'itemFontWeight',title:'元素加粗类型',width:100,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'itemUnderline',title:'是否加下划线',width:110,align:'center',
            formatter: function(value,row){
                return value=="Y" ? "是":""
            },	
            editor:{type:'checkbox',options:{on:'Y',off:''}}},
    ], function(rowIndex){
        var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'textFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'itemFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });
    },
    function(rowIndex,rowData){
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'textFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		if (rowData.textFontColor != "")
		{
			$(ed.target).color("setValue",rowData.textFontColor)
		}
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'itemFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });
		if (rowData.itemFontColor != "")
		{
			$(ed.target).color("setValue",rowData.itemFontColor)
		}
    })
}

/**
 * 产程图表格配置 //逻辑复杂，最后处理
 */
function initSheetConfigTable(){
    createEditGrid('sheetConfigTable', [
        {field:'id',hidden:true},
        {field:'positionDesc',title:'位置说明',width:200,editor:{type:'text'}},
        {field:'xAxis',title:'坐标X(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'yAxis',title:'坐标Y(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'height',title:'表格高度(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'width',title:'表格宽度(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'showWin',title:'线框定义',width:110, align:'center', formatter:function(){
            return '<img src="../images/uiimages/split_cells.png" style="cursor: pointer;">'
        } },
		{field:'border',hidden:true},
        {field:'cols',title:'拆分列',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'rows',title:'拆分行',width:110,editor:{type:'numberbox',options:{min:0}}},

    ])

    $('#sheetConfigTable').datagrid('options').onClickCell = function(rowIndex, field, value){
        if (field == 'showWin'){
			var rows = $('#sheetConfigTable').datagrid('getRows')
			var border = rows[rowIndex].border
			if (!!border)
			{
				$.each(border,function(index,single){
					var linkObj = $("."+$("#"+index).attr('link'))
					if (single.flag == "Y")
					{
						$("#"+index).css('background-position-y', '-46px')
						linkObj.addClass('active')
						if (single.linetype == 'bold'){
							linkObj.addClass('boldActive')
						}
						linkObj.css('border-color', single.color)
					}else{
						$("#"+index).css('background-position-y',  '0px')
						linkObj.removeClass('active')
						linkObj.removeClass('boldActive')
						linkObj.css('border-color', '')
					}
					
				})
			}else{
				$('.main-right a').each(function(index,single){
					$(single).css('background-position-y',  '0px')
					var linkObj = $("."+$(single).attr('link'))
					linkObj.removeClass('active')
					linkObj.removeClass('boldActive')
					linkObj.css('border-color', '')
				})
			}
			$('#selectSheetId').val(rowIndex)
            $('#borderWin').window('open')
        }
    }
}

/**
 * 产程图曲线配置
 */
function initCurveConfigTable(){

	/**
	 *
	var rowEditors=$('#'+obj).datagrid('getEditors',curEditIndex);	
	rowid=$(rowEditors[0].target).val();
	field1=$.trim($(rowEditors[1].target).val());
	index3=$.trim($(rowEditors[2].target).val());
	if(obj=="dg") field3=$(rowEditors[3].target).radio("getValue") ? "Y" : "";	
	if(obj=="dg2" || obj=="dg3") field3=$(rowEditors[3].target).numberbox("getValue");
	if(obj=="dg4") field3=$(rowEditors[3].target).color("getValue");
	field4=$(rowEditors[4].target).radio("getValue") ? "Y" : "";
	field2=$.trim($(rowEditors[5].target).numberbox("getValue"));
	 * 
	 */
    createEditGrid('curveConfigTable', [
        {field:'rowKey',hidden:true},
        {field:'itemDr',title:'关联产程记录', width:100,
            formatter: setFormatter(GV.OBSItem),
            editor:setEditor(GV.OBSItem),
        },
        {field:'xAxis',title:'坐标X',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'yAxis',title:'坐标Y', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'cHeight',title:'最小方格高度', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'cWidth',title:'最小方格宽度', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'minScaleValue',title:'最小刻度值', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'maxValue',title:'最大值', width:110,editor:{type:'numberbox'}},
        {field:'minValue',title:'最小值', width:110,editor:{type:'numberbox'}},
		{field:'offsetValue',title:'偏移量', width:110,editor:{type:'numberbox'}},
		{field:'ifOrderDesc',title:'倒序',width:60,align:'center',
		editor:{type:'checkbox',options:{on:'Y',off:''}}},
		{field:'ifLinkMarker',title:'连接分娩标记',width:110,align:'center',
		editor:{type:'checkbox',options:{on:'Y',off:''}}},
        {field:'color',title:'颜色', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'icon',title:'图标', width:100, editor:{type:'text'}},
        {field:'iconSize',title:'图标大小', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'iconFontStyle',title:'图标字体样式', width:80,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'lineWidth',title:'线宽', width:110,align:'center',
			formatter: setFormatter(GV.LineWidthList),
			editor:setEditor(GV.LineWidthList),},
        {field:'lineType',title:'线类型', width:80,align:'center',
            formatter: setFormatter(GV.LineTypeList),
            editor:setEditor(GV.LineTypeList),
        },        
        {field:'ifLinkStart',title:'是否连接起始值',width:110,align:'center',	
            editor:{type:'checkbox',options:{on:'Y',off:''}}},
        {field:'ifSupportMult',title:'多胎时显示',width:110,align:'center',	
            editor:{type:'checkbox',options:{on:'Y',off:''}}
        },
    ],
    function(rowIndex){
        var ed = $('#curveConfigTable').datagrid('getEditor', {index:rowIndex, field:'color'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
    },
    function(rowIndex,rowData){
        var ed = $('#curveConfigTable').datagrid('getEditor', {index:rowIndex, field:'color'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		if (rowData.color !="" )
		{
			$(ed.target).color("setValue",rowData.color)
		}
    })
}

/**
 * 产程图开始条件配置
 */
function initCurveStartConfigTable(){

    createEditGrid('curveStartConfigTable', [
        {field:'rowKey',hidden:true},
        {field:'itemDr',title:'关联产程记录', width:100,
            formatter: setFormatter(GV.OBSItem),
            editor:setEditor(GV.OBSItem),
        },
        {field:'condition',title:'条件',width:110,
            formatter: setFormatter(GV.ConditionList),
            editor:setEditor(GV.ConditionList),
        },
        {field:'value',title:'数值', width:110,editor:{type:'numberbox',options:{min:0}}},
    ])
}

/**
 * 线框定义弹窗
 */
function initBorderWin(){
    $('#borderWin').window({
	    height: 320,
        width: 440,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: '线框定义',
        iconCls:'icon-batch-cfg'
    })
    $("#selColorInput").color({
        width:90,
        height:30
    });	
    $("#lineStyle li").on('click',function(){
        $("#lineStyle li.active").removeClass('active')
        $(this).addClass('active')
    })
    
	$('.main-right a').each(function(index,single){
		$(single).on('click', function(){
			$(this).css('background-position-y',  $(this).css('background-position-y')=='0px' ? '-46px' : '0px')
			var link = $('.main-right .text .' + $(this).attr('link'))
			if ($(this).css('background-position-y')=='0px')
			{
				link.removeClass('active')
				link.removeClass('boldActive')
				link.css('border-color', '')
			}else{
				link.addClass('active')
				if ($("#lineStyle li.active").attr('value') == '1')
				{
					link.addClass('boldActive')	
				}
				link.css('border-color', $("#selColorInput").color('getValue'))
			}
		})
	})
	
	$("#borderWinCancel").on('click',function(){
		$('#borderWin').window('close')
	})
	
	$("#borderWinSave").on('click',function(){
		var border = {}
		var obj = $(".border-left")
		border.left = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-right")
		border.right = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-top")
		border.top = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-bottom")
		border.bottom = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".left-diagonal")
		border.leftDiagonal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".right-diagonal")
		border.rightDiagonal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".horizontal")
		border.horizontal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".vertical")
		border.vertical = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}

		$('#sheetConfigTable').datagrid('getRows')[ parseInt($('#selectSheetId').val())].border = border

		$('#borderWin').window('close')
			
	})
	
	

    //$('#borderWin').window('open')
}

/**
 * 表头图片配置
 */
function initImgSet()
{

}


/**获取产程图打印配置 */
function getLaborConfigInfo(){
    var row = $('#charsTable').datagrid("getSelected");
    if (row == null){
        $.messager.popover({ msg: "请选择打印列表!", type:'error' });
        return
    }
    $cm({
        ClassName: GV._CLASSNAME,
        MethodName:"getLaborConfigInfo",
        id:row.id
    },function(data){
        if (data.code == 0){
			assignPage(data.data)
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
    })

}

/**
 * 保存按钮点击
 */
function initSaveBtn(){

	var row = $('#charsTable').datagrid("getSelected");
    if (row == null){
        $.messager.popover({ msg: "请选择打印列表!", type:'error' });
        return
    }
	//logo配置
	var ImgName=$("#img").filebox("files").length>0 ? $("#img").next().find('input[type=file]')[0].files[0].name : $("#img").next().find('input.filebox-text').val();
	var ImgSrc=$(".show-img img").attr("src");
	var ImgWidth=$.trim($("#width").numberbox("getValue"));
	var ImgHeight=$.trim($("#height").numberbox("getValue"));
	var ImgXAxis=$.trim($("#xAxis").numberbox("getValue"));
	var ImgYAxis=$.trim($("#yAxis").numberbox("getValue"));
	var contentConfig = {
		ImgName:ImgName,
		ImgSrc:ImgSrc,
		ImgWidth:ImgWidth,
		ImgHeight:ImgHeight,
		ImgXAxis:ImgXAxis,
		ImgYAxis:ImgYAxis
	}
	//文本配置
	$('#textConfigTable').datagrid("acceptChanges");
	var indexs = $('#textConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#textConfigTable').datagrid('endEdit',indexs[0]);
	}
	var texts = $('#textConfigTable').datagrid('getRows')
	var textConfig = { texts: texts}

	//表格配置
	var indexs = $('#sheetConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#sheetConfigTable').datagrid('endEdit',indexs[0]);
	}
	var sheet = $('#sheetConfigTable').datagrid('getRows')
	var sheetConfig = { sheet: sheet}

	//曲线配置
	var indexs = $('#curveConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#curveConfigTable').datagrid('endEdit',indexs[0]);
	}
	var curve = $('#curveConfigTable').datagrid('getRows')
	sheetConfig.curve = curve

	//曲线开始配置
	var indexs = $('#curveStartConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#curveStartConfigTable').datagrid('endEdit',indexs[0]);
	}
	var curveStart = $('#curveStartConfigTable').datagrid('getRows')
	if (!checkUnique(curveStart,"itemDr"))
	{
		$.messager.popover({ msg: "产程曲线开始条件配置,关联产程记录不能重复", type:'error' });
		return
	}
	sheetConfig.curveStart = curveStart

	//打印规则配置 警示线和处理线 宫口全开 分娩标记
	var printRuleConfig = getFromValue("#printRuleConfig")
	
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName:"saveLaborConfigInfo",
		id:row.id,
		contentConfig:JSON.stringify(contentConfig), 
		printRuleConfig: JSON.stringify(printRuleConfig),
		tableConfig: JSON.stringify(sheetConfig),
		textConfig: JSON.stringify(textConfig)
	},function(data){
		if (data.code == 0){
			$.messager.popover({ msg: '保存成功', type:'success' });
			getLaborConfigInfo()
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
	})
}


/**
 * 赋值界面
 * @param {*} data 
 */
function assignPage(data){

	initLogoConfig({})
	setFromValue('#printRuleConfig',{})
	$('#textConfigTable').datagrid('loadData',[])
	$('#sheetConfigTable').datagrid('loadData',[])
	$('#curveConfigTable').datagrid('loadData',[])
	$('#curveStartConfigTable').datagrid('loadData',[])

	if (!!data.textConfig)
	{
		$('#textConfigTable').datagrid('loadData',$.parseJSON(data.textConfig).texts)
	}

	if (!!data.contentConfig)
	{
		var contentConfig =  $.parseJSON(data.contentConfig)
		initLogoConfig(contentConfig)
	}

	if (!!data.tableConfig)
	{
		var tableConfig =  $.parseJSON(data.tableConfig)
		$('#sheetConfigTable').datagrid('loadData',tableConfig.sheet)
		$('#curveConfigTable').datagrid('loadData',tableConfig.curve)
		$('#curveStartConfigTable').datagrid('loadData',tableConfig.curveStart)
	}

	if (!! data.printRuleConfig)
	{
		var printRuleConfig = $.parseJSON(data.printRuleConfig)
		setFromValue('#printRuleConfig',printRuleConfig)
	}
}

/**
 * 警戒线、处理线
 */
function initWpLineConfig(){
	//关联产程记录
	$('#wpLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//颜色
	$('#wpLineColor').color({
		editable:true,
		width:90,
		height:30
	});	
	//线条样式
	$('#wpLineType').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.LineTypeList
    })
}
/**
 * 宫口全开
 */
function initFullWombConfig()
{
	//关联产程记录
	$('#wombLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//颜色
	$('#wombFontColor').color({
		editable:true,
		width:90,
		height:30
	});	
}
/**
 * 分娩标记
 */
function initBirthMarkerConfig()
{
	//关联产程记录
	$('#markerLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//颜色
	$('#markerFontColor').color({
		editable:true,
		width:90,
		height:30
	});	
}

/**
 * 获取院区ID
 * @returns 院区ID
 */
function getHosp()
{
	try{
		return parent.$HUI.combogrid('#_HospList').getValue()		
	}catch(err){
		return "2"
	}

}

function setFormatter(data){
	return function(value){
		for(var index in data)
		{
			if (data[index].value == value){
				return data[index].desc
			}
		}
		return value
	}
}

function setEditor(data){
	return {
		type:'combobox',
		options:{
			valueField:'value',
			textField:'desc',
			data: data
		}
	}
}

/**
 * 新建表格
 */
 function createEditGrid(tableId,columns,addCallBack,dblClickCallBack)
 {
     var tableId = "#" + tableId
     $(tableId).datagrid({
	     fit: true,
         columns :[ columns ],
         rownumbers:true,
         singleSelect : true,
         autoSizeColumn:false,
         pagination:false,
         loadMsg : '加载中..',
         toolbar:[{
             iconCls: 'icon-add',
             text:$g('新增'),
             handler: function(){
				$(tableId).datagrid("acceptChanges");
                 //$(tableId).datagrid("rejectChanges");
				 $(tableId).datagrid("unselectAll");
                 $(tableId).datagrid('appendRow',{ rowKey : Math.random().toString(36).substr(2) });
				 $(tableId).datagrid("acceptChanges");
                 var rows= $(tableId).datagrid('getRows');
                 $(tableId).datagrid('beginEdit',rows.length-1);
                 $(tableId).datagrid('selectRow',rows.length-1);
                 if (!!addCallBack)
                 {
                     addCallBack(rows.length-1)
                 }
             }
         },{
             iconCls: 'icon-copy',
             text:$g('复制'),
             handler: function(){
				var row = $(tableId).datagrid("getSelected");
				if (row == null){
					$.messager.popover({ msg: "请选择一行!", type:'error' });
					return
				}
				$(tableId).datagrid("acceptChanges");
				//$(tableId).datagrid("rejectChanges");
				$(tableId).datagrid("unselectAll");
				var newRow = {}
				$.extend(true,newRow,row)
				newRow.rowKey = Math.random().toString(36).substr(2)
				$(tableId).datagrid('appendRow',newRow);
				var rows= $(tableId).datagrid('getRows');
				$(tableId).datagrid('beginEdit',rows.length-1);
				$(tableId).datagrid('selectRow',rows.length-1);

             }
         },{
			iconCls: 'icon-cancel',
			text:$g('删除'),
			handler: function(){
			   var row = $(tableId).datagrid("getSelected");
			   if (row == null){
				   $.messager.popover({ msg: "请选择一行!", type:'error' });
				   return
			   }
			   var index = $(tableId).datagrid("getRowIndex",row);
			   $(tableId).datagrid("deleteRow",index);
			}
		 }],
         onDblClickRow: function(rowIndex, rowData){
			$(tableId).datagrid("acceptChanges");
             //$(this).datagrid("rejectChanges");
			 $(this).datagrid("acceptChanges");
             $(this).datagrid("unselectAll");
             $(this).datagrid("beginEdit", rowIndex);
             $(this).datagrid("selectRow",rowIndex);
			 var opts = $(this).datagrid("options");
			 var trs = opts.finder.getTr(this, rowIndex);
			 trs.draggable( 'disable')  //本列去掉拖拽，解决编辑的文本框不能选中的问题
             if (!!dblClickCallBack)
             {
                 dblClickCallBack(rowIndex,rowData)
             }
         },
         onLoadSuccess:function(){
             //允许拖动行
             $(this).datagrid('enableDnd');
         },
		 onClickCell: function(){
			console.log("222")
		 }
     })	
 }

 // 选择图片
function chooseImg() {
	var files = $("#img").next().find('input[type=file]')[0].files[0];
	var size = files.size / 1024 / 1024;
	if (size <= 1) {
		var reader = new FileReader();
		reader.readAsDataURL(files);
		reader.onload = function(event){
			var imgFile = event.target.result;
			$(".show-img").show();
			$(".bg-layer").hide();
			$(".show-img img").attr("src",imgFile);
		};
	} else {
		$.messager.popover({ msg: "图片大小不能超过1M", type:'alert' });
	}
}
// 删除图片
function deleteImg(){
	$(".td-img").html('<input id="img" class="hisui-filebox" name="file" style="width:274px;" />');
	$HUI.filebox("#img",{
		plain:true,
		prompt:"",
		onChange:function(){
			chooseImg();	
		}
	});
	$(".show-img").hide();
	$(".show-img img").attr("src","");
}


 /**
  * 将rgb转换成16进制颜色代码
  * @param {rgb} color  
  * @returns 
  */
 function colorRGBtoHex(color) {
	var rgb = color.split(',');
	var r = parseInt(rgb[0].split('(')[1]);
	var g = parseInt(rgb[1]);
	var b = parseInt(rgb[2].split(')')[0]);
	var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
	return hex;
}




function getFromValue(container){
	var attrs = {}; // 返回的对象
	var gettedNames = []; // 需跳过的组件名数组
	var target = $(container);

	// combo&datebox
	var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
	var ipts = jQuery('[comboName]', target);
	if (ipts.length){
		ipts.each(function(){
			for(var i=0; i<cbxCls.length; i++){
				var type = cbxCls[i];
				var name = jQuery(this).attr('comboName');
				if (jQuery(this).hasClass(type+'-f')){
					if (jQuery(this)[type]('options').multiple){
						var val = jQuery(this)[type]('getValues');
						extendJSON(name, val);
					} else {
						var val = jQuery(this)[type]('getValue');
						extendJSON(name, val);
					}
					break;
				}
			}
		});
	}
	// radio&checkbox
	var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
	if(ipts.length) {
		var iptsNames = [];
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
				iptsNames.push(name);
			}
		});
		for(var i=0;i<iptsNames.length;i++) {
			var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
			var type = iptsFlts.eq(0).attr('type');
			if(type === 'radio') {
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						extendJSON(iptsNames[i], jQuery(this).val());
						return false;
					}
				});
			} else if(type === 'checkbox') {
				var vals = [];
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						vals.push(jQuery(this).val());
					}
				});
				extendJSON(iptsNames[i], vals);
			}
		}
	}
	// numberbox&slider
	var cTypes = ['numberbox', 'slider'];
	for(var i=0;i<cTypes.length;i++) {
		ipts = jQuery("input["+cTypes[i]+"Name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr(cTypes[i]+'Name');
				var val = jQuery(this)[cTypes[i]]('getValue');
				extendJSON(name, val);
			});
		}
	}
	// multiselect2side
	ipts = jQuery(".multiselect2side", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this)['multiselect2side']('getValue');
			extendJSON(name, val);
		});
	}
	// select
	ipts = jQuery("select[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			extendJSON(name, val);
		});
	}
	// validatebox&input&textarea
	ipts = jQuery("input[name], textarea[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			extendJSON(name, val);
		});
	}

	//swtichbox
	ipts = jQuery(".hisui-switchbox", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this)['switchbox']('getValue') ? "Y" : "N";
			extendJSON(name, val);
		});
	}

	// function
	function extendJSON(name, val) {
		if(!name) return;
		if(-1 !== $.inArray(name, gettedNames)) {
			// 只获取第一个name的值
			return;
		} else {
			gettedNames.push(name);
		}
		val = 'undefined'!==typeof(val)? val:'';
		var newObj = eval('({"'+name+'":'+JSON.stringify(val)+'})');
		jQuery.extend(attrs, newObj);
	}
	return attrs;
}

function setFromValue(container, json){
	var target = $(container);
	// combo&datebox
	var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
	var ipts = jQuery('[comboName]', target);
	if (ipts.length){
		ipts.each(function(){
			for(var i=0; i<cbxCls.length; i++){
				var type = cbxCls[i];
				var name = jQuery(this).attr('comboName');
				if (jQuery(this).hasClass(type+'-f')){
					if (name.indexOf('Color')>-1)
					{
						jQuery(this)['color']('setValue', json[name] || '');
					}else{
						if (jQuery(this)[type]('options').multiple){
							jQuery(this)[type]('setValues',json[name] || []);
						} else {
							jQuery(this)[type]('setValue', json[name] || '');
						}
					}
					break;
				}
			}
		});
	}
	// radio&checkbox
	var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
	if(ipts.length) {
		var iptsNames = [];
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
				iptsNames.push(name);
			}
		});
		for(var i=0;i<iptsNames.length;i++) {
			var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
			var type = iptsFlts.eq(0).attr('type');
			if(type === 'radio') {
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						//extendJSON(iptsNames[i], jQuery(this).val());
						return false;
					}
				});
			} else if(type === 'checkbox') {
				var vals = [];
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						vals.push(jQuery(this).val());
					}
				});
				//extendJSON(iptsNames[i], vals);
			}
		}
	}
	// numberbox&slider
	var cTypes = ['numberbox', 'slider'];
	for(var i=0;i<cTypes.length;i++) {
		ipts = jQuery("input["+cTypes[i]+"Name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr(cTypes[i]+'Name');
				jQuery(this)[cTypes[i]]('setValue',json[name] || '');
			});
		}
	}
	// multiselect2side
	ipts = jQuery(".multiselect2side", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this)['multiselect2side']('setValue',json[name] || '');
		});
	}
	// select
	ipts = jQuery("select[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this).val(json[name] || '');
		});
	}
	// validatebox&input&textarea
	ipts = jQuery("input[name], textarea[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this).val(json[name] || '');
		});
	}

	//swtichbox
	ipts = jQuery(".hisui-switchbox", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this)['switchbox']('setValue',json[name] =="Y" ? true : false)
		});
	}
	return true;
}

function checkUnique(rows, columnName) {
	var values = {};
	for (var i = 0; i < rows.length; i++) {
	  var value = rows[i][columnName];
	  if (values[value]) {
		return false; // 重复值
	  }
	  values[value] = true;
	}
	return true; // 唯一值
  }