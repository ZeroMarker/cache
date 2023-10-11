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
	getEditingRowIndex: function(jq) {
		var indexs = [];
	    var grid = $(jq);
	    var rows = grid.datagrid('getRows');
	    for (var i = 0; i < rows.length; i++) {
      		if (grid.datagrid('validateRow', i) && grid.datagrid('getEditors', i).length > 0) {
        		indexs.push(i);
      		}
    	}
	    return indexs;
	}
})
//===================================================================================================================
var hospComp="",hospID = session['LOGON.HOSPID'];
var type="L"
var GV={
	_CLASSNAME:"Nur.NIS.Service.OrderSheet.Setting",
	dateFormat:[
		{value:"1",label:"yyyy-MM-dd"},
		{value:"2",label:"dd/MM/yyyy"}
	],
	timeFormat:[
		{value:"1",label:"HH:mm:ss"},
		{value:"2",label:"HH:mm"}
	],
	DateTimeStyle:[],
	changePageList:[
		{id:"",item:"转科",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"术后",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"分娩",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"重整设置",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"}
	],
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
	HeaderLevelList:[{
		value: "1",
		desc: "一级",
	},{
		value: "2",
		desc: "二级"
	}],
	BasicData: [],
	TextBasicData: [],
	BasicOrderData: [],
	LocData:[],
	PriorityData: [],
	ArcCatData: []
}
$(function() {
	var HISUIStyleCode;
	hospComp = GenHospComp("Nur_IP_OrderSheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		initUI();    	       	
	}  ///选中事件	
	
	//获取基础数据
	GV.BasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getBasicData",
		
	},false)
	GV.TextBasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getTextConfigBasicData",
		
	},false)
	GV.BasicOrderData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getBasicOrderData",
	},false)
	
	GV.DateTimeStyle = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getDateTimeStyle",
	},false)

	$("#tabs").tabs({
		onSelect:function(title,index){
			if(index == 2){
				/**解决切换页签后 一些表格和面板不自动扩展的问题 */
				$('#oecprTable').datagrid({ fit:true})
				$('#skipTable').datagrid({ fit:true})
				$('#dgArcCat').datagrid({ fit:true})
				$('#dgArcItm').datagrid({ fit:true})
				$('#right_panel').panel({fit:true})
			}
		}
	})
	initsheetDataSourceWin()
	initUI()

})
function initUI(){
	initBasicData()
	initConfigTable()
	initTextConfig()
	initSheetConfig()
	initDispalyConfig()
	initCommonConfig()
}
/**
 * 加载一些，病区改变,数据也改变的数据
 */
function initBasicData()
{
	GV.PriorityData = $cm({
		ClassName: GV._CLASSNAME,
		QueryName: "getPriority",
	},false).rows
	GV.ArcCatData = $cm({
		ClassName: GV._CLASSNAME,
		QueryName: "getArcItmChart",
		q:"",
		HospID: getHosp()
	},false).rows
}
/**
 * 医嘱单配置列表
 */
function initConfigTable(){
	$("#configTable").datagrid({
        url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'IfActive',title:'状态',width:50,align:'center',formatter:function(value,row,index){
                    return value=="Y" ? "<font color='green'>启用</font>" : "<font color='red'>停用</font>";	
                }},
				{field:'Name',title:'描述',width:80},
				{field:'Mark',title:'标识符',width:50,hidden:true},
				{field:'AreaLocDesc',title:'病区',width:70},
				{field:'id',title:'id',hidden:true},
				{field: 'handler', title: '操作', width: 50, align:"center", rowspan:2, formatter:function(value, row, index){
					return  "<span style='cursor:pointer' onclick='configTableHandler.delete(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
				}
			}
			]
		],
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
			param.MethodName = "getConfigTable"
			param.hospID = getHosp()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				setFromValue("#configTableWin",{})
				$('#configTableWin').window('open')
			}
		},{
			iconCls: 'icon-copy',
			text:$g('复制'),
			handler: function(){
				$('#configCopyTable').datagrid('reload')
				$('#configCopyWin').window('open')
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
           setFromValue("#configTableWin",rowData)
		   $('#configTableWin').window('open')
        },
        onClickRow: function(rowIndex, rowData){
            //getLaborConfigInfo()
			if ( rowData.Mark.indexOf("L")>-1){
				$('.dispalyConfig>.right').css("display","block")
				$('#dgArcCat').datagrid({ fit:true})
				$('#dgArcItm').datagrid({ fit:true})
				$('#right_panel').panel({fit:true})
			}else{
				$('.dispalyConfig>.right').css("display","none")
			}
			initTextConfig()
			initSheetConfig()
			initDispalyConfig()
			initCommonConfig()
        }
	})	

	GV.LocData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName:"getLocsMultHosp",
		locType: "",
		HospID: getHosp()
	},false);


	function filter(q, row) {
		var opts = $(this).combobox('options');
		var text = row[opts.textField];
		var pyjp = getPinyin(text).toLowerCase();
		if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
			return true;
		}
		return false;
	}
	//适用科室
    $('#AreaLoc').combobox({
        valueField: 'id',
        textField: 'desc',
        data:GV.LocData,
        multiple:true,
        filter: filter
    })


	$('#configTableWin').window({
		top:"100px",
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '医嘱单配置列表',
		iconCls:'icon-w-add'
	})

	$('#closeConfigTableWinBtn').on('click',function(){
		$('#configTableWin').window('close')
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
				{field:'ifLongSheet',title:'是否长期医嘱单', align:"center",width:150},
				{field:'areaLoc',title:'有效科室', width:200},
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

/**
 * 医嘱单配置列表
 */
var configTableHandler = {
	save: function(){
		if (!verification("configTableWin")) return
		$m({
			ClassName: GV._CLASSNAME,
			MethodName: "saveConfigTable",
			saveDataJson: JSON.stringify(getFromValue("#configTableWin")),
			hospID: getHosp()
		},function(result){
			if(result==0){
				$('#configTableWin').window('close')
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#configTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}	
		})
	},
	delete: function(id){
		$.messager.confirm('提示','是否删除?',function(r){
			if (r)
			{
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "deleteConfigTable",
					id: id
				},function(result){
					if(result==0){
						$.messager.popover({ msg: "删除成功！", type:'success' });	
						$('#configTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}	
				})
			}
		})
	},
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
				$('#configTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}	
		})
		
	}
}
/**
 * 表格外内容
 */
function initTextConfig(){
	$("#textConfigTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true,rowspan:2},
				{field:'description',title:'项目描述',rowspan:2, width:100,editor:{type:'text'}},
				{field:'printX',title:'打印坐标X(mm)',rowspan:2,width:110,editor:{type:'numberbox',options:{min:0}}},
				{field:'printY',title:'打印坐标Y(mm)',rowspan:2, width:110,editor:{type:'numberbox',options:{min:0}}},
				{title:'内容',colspan:6},
				{title:'绑定元素',colspan:7},
				{field: 'handler', title: '操作', width: 100, align:"center", rowspan:2, formatter:function(value, row, index){
						return  "<span style='cursor:pointer' onclick='textConfigHandler.delete(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
					}
				}
			],[
				{field:'text',title:'文本', width:100, align:"center", editor:{type:'text'}},
				{field:'textWidth',title:'宽度(mm)', width:80, align:"center", editor:{type:'numberbox',options:{min:0}}},
				{field:'textFontFamily',title:'字体', width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'textFontSize',title:'字号', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
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
				{field:'itemWidth',title:'元素宽度(mm)',width:110,align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'itemFontFamily',title:'元素字体',width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'itemFontSize',title:'元素字号',width:80,align:'center',editor:{type:'numberbox',options:{min:0}}},
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
			]
		],
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getTextConfig",
            param.parId = getParId()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#textConfigTable').datagrid("acceptChanges");
				$('#textConfigTable').datagrid("unselectAll");
				$('#textConfigTable').datagrid('appendRow',{});
                var rows= $('#textConfigTable').datagrid('getRows');
                $('#textConfigTable').datagrid('beginEdit',rows.length-1);
				$('#textConfigTable').datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#textConfigTable').datagrid("acceptChanges");
            $('#textConfigTable').datagrid("unselectAll");
            $('#textConfigTable').datagrid("beginEdit", rowIndex);
            $('#textConfigTable').datagrid("selectRow",rowIndex);
        },

	})
}

/**
 * 表格外内容
 */
var textConfigHandler = {
	delete : function(id){
		if ("undefined" == id && id == "" ) return
		$.messager.confirm('提示','是否删除?',function(r){
			if (r)
			{
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "DeleteTextConfig",
					id: id
				},function(result){
					if (result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#textConfigTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		})
	},
	save: function(){
		var indexs = $('#textConfigTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#textConfigTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#textConfigTable').datagrid('getRows');
		$.cm({	
			ClassName:GV._CLASSNAME,
			MethodName:"SaveTextConfig",
			saveDataJson:JSON.stringify(rows),
			hospID:getHosp(),
			parId: getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#textConfigTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}
}

/**
 * 表格内容
 */
function initSheetConfig(){
	$("#sheetConfigTable").datagrid({
		url: $URL,
		columns :[[
				{field:'columnName',title:'列名',rowspan:2, width:100,editor:{type:'text'}},
				{field:'headerLevel',title:'表头层级',rowspan:2,width:100,
					formatter: setFormatter(GV.HeaderLevelList),
					editor:setEditor(GV.HeaderLevelList),
				},
				{field:'upperHeader',title:'上级表头',rowspan:2, width:100,editor:{type:'text'}},
				{field:'width',title:'宽度',rowspan:2, width:80, align:"center", editor:{type:'numberbox',options:{min:0}} },
				{title:'表头',colspan:4},
				{title:'绑定元素',colspan:5},
				{field: 'handler', title: '操作', width: 130, align:"center", rowspan:2, formatter:function(value, row, index){
					var del = "<span style='padding-left: 5px;cursor:pointer' class='icon icon-cancel' onclick='sheetConfigHandler.delete(\""+ row.id +"\")'>&nbsp;&nbsp;&nbsp;&nbsp</span>";
					var down = '<span style="padding-left: 5px;cursor:pointer" class="icon icon-down" onclick=sheetConfigHandler.upOrDown("'+row.id+'","down","'+index+'")>&nbsp;&nbsp;</span> ';
                    var up = '<span style="padding-left: 5px;width:10px;cursor:pointer" class="icon icon-up" onclick=sheetConfigHandler.upOrDown("'+row.id+'","up","'+index+'")>&nbsp;&nbsp;</span>';
                    return up + down + del ; 
					}
				}
			],[
				{field:'textFontFamily',title:'字体',width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'textFontSize',title:'字号',width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'textFontAlign',title:'对齐方式' , width:90,align:'center',
					formatter: setFormatter(GV.FontAlignList),
					editor:setEditor(GV.FontAlignList),
				},
				{field:'textontWeight',title:'加粗类型', width:90,align:'center',
					formatter: setFormatter(GV.FontWeightList),
					editor:setEditor(GV.FontWeightList),
				},
				{field:'item',title:'基础数据类型',width: 110,align:'center',
					formatter: setFormatter(GV.BasicData),
					editor:setEditor(GV.BasicData),
				},
				{field:'itemFontFamily',title:'字体', width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'itemFontSize',title:'字号', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'itemFontAlign',title:'对齐方式', width:90,align:'center',
					formatter: setFormatter(GV.FontAlignList),
					editor:setEditor(GV.FontAlignList),
				},
				{field:'itemFontWeight',title:'加粗类型', width:90,align:'center',
					formatter: setFormatter(GV.FontWeightList),
					editor:setEditor(GV.FontWeightList),
				}
			]
		],
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = "Nur.NIS.Service.OrderSheet.Setting"
			param.MethodName = "getSheetConfig"
            param.parId = getParId()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#sheetConfigTable').datagrid("acceptChanges");
				$('#sheetConfigTable').datagrid("unselectAll");
				$('#sheetConfigTable').datagrid('appendRow',{});
                var rows= $('#sheetConfigTable').datagrid('getRows');
                $('#sheetConfigTable').datagrid('beginEdit',rows.length-1);
				$('#sheetConfigTable').datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#sheetConfigTable').datagrid("acceptChanges");
            $('#sheetConfigTable').datagrid("unselectAll");
            $('#sheetConfigTable').datagrid("beginEdit", rowIndex);
            $('#sheetConfigTable').datagrid("selectRow",rowIndex);
        },

	})

	//医嘱附加信息设置
	$("#OrdSuffixConfigTable").datagrid({
		url: $URL,
		columns :[[
			{field:'id',hidden:true},
			{field:'Sequence',title:'顺序',width:40,hidden:true},
			{field:'Item',title:'医嘱名称后缀',width:100,
				formatter: setFormatter(GV.BasicOrderData),
				editor:setEditor(GV.BasicOrderData)},
	    	{field:'ItemDesc',title:'医嘱名称后缀',width:100, hidden:true}, 
	    	{field:'Code',title:'编码',width:150,hidden:true}, 
	        {field:'ActiveFlag',title:'是否启用',width:80,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}},hidden:true},
		    {field:'Prioritys',title:'优先级',width:150,
				formatter: setMultFormatter(GV.PriorityData),
				editor:setMultEditor(GV.PriorityData)},
			{field:'ArcCats',title:'医嘱子类',width:150,
				formatter: setMultFormatter(GV.ArcCatData),
				editor:setMultEditor(GV.ArcCatData)},
    		{field: 'handler', title: '操作', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='sheetConfigHandler.deleteOrdSuffixConfig(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
			}}
		    	       	       
		]],
		rownumbers: true,
		singleSelect : true,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = "Nur.NIS.Service.OrderSheet.Setting"
			param.MethodName = "getOrdSuffixConfig"
            param.parId = getParId()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#OrdSuffixConfigTable').datagrid("acceptChanges");
				$('#OrdSuffixConfigTable').datagrid("unselectAll");
				$('#OrdSuffixConfigTable').datagrid('appendRow',{});
                var rows= $('#OrdSuffixConfigTable').datagrid('getRows');
                $('#OrdSuffixConfigTable').datagrid('beginEdit',rows.length-1);
				$('#OrdSuffixConfigTable').datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow:function(rowIndex,rowData){
			$('#OrdSuffixConfigTable').datagrid("acceptChanges");
            $('#OrdSuffixConfigTable').datagrid("unselectAll");
            $('#OrdSuffixConfigTable').datagrid("beginEdit", rowIndex);
            $('#OrdSuffixConfigTable').datagrid("selectRow",rowIndex);
		},
		onLoadSuccess:function(Data){
			$(this).datagrid('enableDnd');
			for (var index in Data.rows ){
				var single = Data.rows[index]
				single.ArcCats = single.ArcCats.toString()
				single.Prioritys = single.Prioritys.toString()
			}
			return Data
		},
		onDrop:function(targetRow,sourceRow,point){
			var rows = $('#OrdSuffixConfigTable').datagrid('getRows')
			$cm({
				ClassName:GV._CLASSNAME,
				MethodName: "changeOrdSuffixSequence",
				rows: JSON.stringify(rows)
			}, function(rtn){
				$.messager.popover({ msg: "保存成功！", type:'success' });
				$('#OrdSuffixConfigTable').datagrid("reload");
			})
		}
	})
}

/**
 * 表格内容
 */
var sheetConfigHandler = {
	delete: function(id){
		if ("undefined" == id && id == "" ) return
		$.messager.confirm('提示','是否删除?',function(r){  
			if (r){
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "DeleteSheetConfig",
					id: id
				},function(result){
					if (result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#sheetConfigTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
				
			}  
		});
	},
	upOrDown: function(id, handler, index){
		if ((index==0)&&(handler=="up"))
		{
			$.messager.popover({msg: '顶行无法上移!',type:'error',timeout: 1000});
			  return
		}
		
		var rows=$('#sheetConfigTable').datagrid('getRows');
		var rowlength=rows.length
		
	   if ((index==rowlength-1)&&(handler=="down"))
	   {
			   $.messager.popover({msg: '底行无法下移!',type:'error',timeout: 1000});
			   return
	   }
	   $cm({
			   ClassName: GV._CLASSNAME,
			MethodName: "upOrDownSheetConfig",
			id: id,
			handler:handler
	   },function(data){
			 if (data == 0){
				$.messager.popover({ msg: "保存成功！", type:'success' });
				$('#sheetConfigTable').datagrid('reload')
			}else{
				$.messager.popover({msg: data,type:'error',timeout: 1000});
			}
	   })
	},
	save: function(){
		var indexs = $('#sheetConfigTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#sheetConfigTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#sheetConfigTable').datagrid('getRows');
		$.cm({	
			ClassName:GV._CLASSNAME,
			MethodName:"SaveSheetConfig",
			saveDataJson:JSON.stringify(rows),
			parId: getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#sheetConfigTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	},
	saveOrdSuffixConfig: function (){
		var indexs = $('#OrdSuffixConfigTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#OrdSuffixConfigTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#OrdSuffixConfigTable').datagrid('getRows');
		$.cm({	
			ClassName:GV._CLASSNAME,
			MethodName:"saveOrdSuffixConfig",
			saveDataJson:JSON.stringify(rows),
			parId: getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#OrdSuffixConfigTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	},
	deleteOrdSuffixConfig: function(id){
		if ('undefined' === id || id === '' )
		{
			$.messager.popover({ msg: "未保存记录", type:'error' });
			return
		}
		$cm({
			ClassName:GV._CLASSNAME,
			MethodName: "deleteOrdSuffixConfig",
			id : id
		}, function(result){
			if (result == 0){
				$.messager.popover({ msg: "保存成功！", type:'success' });		
				$('#OrdSuffixConfigTable').datagrid("reload");
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}
		})
	}

}
/**
 * 显示规则
 */
function initDispalyConfig(){
	// 医嘱优先级
	$('#oecprTable').datagrid({
		url: $URL,
		fit:true,
		autoSizeColumn:false,
		fitColumns:true,
		idField:"ID",
		frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],
		columns :[[{field:'Desc',title:'医嘱优先级',width:160}]],
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME
			param.QueryName = "GetSavedOecprV3"
            param.parId = getParId()
        },
		onLoadSuccess: function (data) {
			$("#oecprTable").datagrid("unselectAll");
            $.each(data.rows,function(index,single){
				if (single.Selected=="1"){
					$("#oecprTable").datagrid("selectRow",index);
				}
			})
        }
	});

	// 医嘱单换页划线设置
	$("#skipTable").datagrid({
		url: $URL,
		columns :[[
			{field:'item',title:'项目',width:70},
			{field:'name',title:'显示名称',width:100,editor:{type:'validatebox'}},
			{field:'arcItmDR',title:'医嘱项',width:180, formatter: function (value, row, index) {
                return row["arcItmDesc"];
            },editor: {
				type:'combogrid',
				options:{
					width:180,
					panelWidth: 500,
					panelHeight: 350,
					delay:500,
					mode:'remote',
					idField: 'ArcimDR',
					textField: 'ArcimDesc',
					columns: [[
						{field:'ArcimDesc',title:'项目名称',width:100},
						{field:'ArcimDR',title:'项目ID',width:30}
					]],
					pagination : true,
					url:$URL,
					fitColumns: true,
					enterNullValueClear:true,
					onBeforeLoad:function(param){
						var indexs = $('#skipTable').datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#skipTable' ).datagrid('getRows')
							var desc = rows[indexs[0]]['arcItmDesc']
							if ((!param.q)&&(!!desc))
							{
								param.q = desc
							}
			
						}
						param.ClassName = "Nur.NIS.Service.NursingGrade.DataConfig"
						param.QueryName = "FindMasterItem"
						param.arcimdesc = param.q
						param.HospId = getHosp()
					},
					onSelect: function(rowIndex, rowData){
						var indexs = $('#skipTable').datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#skipTable').datagrid('getRows')
							rows[indexs[0]].arcItmDesc = rowData.ArcimDesc
						}
					}
				}
			}},
			{field:'skipFlag',title:'是否换页',width:70,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
			{field:'scribingFlag',title:'是否划线',width:70,formatter:function(value,row,index){
		    	return value=="Y" ? "是" : "否";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		singleSelect : true,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME
			param.QueryName = "GetChangePageSet"
            param.parId = getParId()
        },
		onDblClickRow:function(rowIndex,rowData){
			$('#skipTable').datagrid("acceptChanges");
			$('#skipTable').datagrid("unselectAll");
			$('#skipTable').datagrid("beginEdit", rowIndex);
			$('#skipTable').datagrid("selectRow",rowIndex);
			var ed = $('#skipTable').datagrid('getEditor', {index:rowIndex,field:'arcItmDR'});
			var ed2 = $('#skipTable').datagrid('getEditor', {index:rowIndex,field:'skipFlag'});
			if(rowData.item=="重整设置"){
				$(ed.target).combogrid("disable");
				$(ed2.target).checkbox("disable");
			}else if(rowData.item=="转科")
			{
				$(ed.target).combogrid("disable");
				$(ed.target).next().attr("title","转科通过转移记录判断")
			}
		},
		onLoadSuccess: function (data) {
			var result=data.rows;		
			if(result.length>0){
				var total= getMark().indexOf("L")>-1 ? 4 : 3;
				if(result.length<total){
					var newData=result;	
					var nums=total-result.length;
					for(var i=result.length;i<total;i++){
						newData.push(GV.changePageList[i]);	
					}
					$("#skipTable").datagrid("loadData",newData);
				}else{
					return data
				}			
			}else{
				var newData= getMark().indexOf("L")>-1 ? GV.changePageList : GV.changePageList.slice(0,3)
				$("#skipTable").datagrid("loadData",newData);
			}
        }
	})

	//显示在长期医嘱单上的临时医嘱 医嘱子类
	initGridData("dgArcCat","GetTempOrdSet",0, {
		combogrid: {
			getMethod: 'getArcItmChart',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '医嘱子类',
		fieldWidth: 180,
		operFormatter: delBtn("dgArcCat")
	});

	//显示在长期医嘱单上的临时医嘱 医嘱项
	initGridData("dgArcItm","GetTempOrdSet",1,{
		combogrid: {
			getMethod: 'getArcim',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '医嘱项',
		fieldWidth: 180,
		operFormatter: delBtn("dgArcItm")
	});


}

//显示规则
var dispalyConfigHandler = {
	saveOecprTable : function(){
		var selRows=$("#oecprTable").datagrid("getSelections");
		var saveArr=[],delArr=[];
		selRows.forEach(function(val){
			saveArr.push(val.ID);
		});
		var rows=$("#oecprTable").datagrid("getRows");
		rows.forEach(function(val){
			if (saveArr.indexOf(val.ID)==-1){
				delArr.push(val.ID)
			}
		})
		$.cm({
			ClassName:GV._CLASSNAME,
			MethodName:"SaveOecprSet",
			saveDataJson:JSON.stringify(saveArr),
			delDataJson:JSON.stringify(delArr),
			parId:getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})		
	},
	saveSkipTable: function(){
		var indexs = $('#skipTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#skipTable').datagrid('endEdit',indexs[0])
		}
		var data=$("#skipTable").datagrid("getRows");
		$.cm({
			ClassName:GV._CLASSNAME,
			MethodName:"SaveChangePageSet",
			saveDataJson:JSON.stringify(data),
			parId: getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#skipTable').datagrid("reload");
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	},
	saveTempOrdSet : function(tableID,type){
		var indexs = $('#'+tableID).datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#'+tableID).datagrid('endEdit',indexs[0])
		}
		var arr=[];
		var rows=$("#"+tableID).datagrid("getRows");
		if(rows.length>0){
			arr=rows.filter(function(val){
				return val.desc!=""	
			})
		}
		if(arr.length>0){
			$.cm({
				ClassName:GV._CLASSNAME,
				MethodName:"SaveTempOrdSet",
				saveDataJson:JSON.stringify(arr),
				parId: getParId(),
				itemType:type
			},function testget(result){
				if(result==0){
					$('#' + tableID).datagrid('reload');
				}else{
					$.messager.popover({ msg: "主表数据不存在，请先保存！", type:'error' });	
				}		
			})
		}	
	}
}

/**
 * 通用设置
 */
function initCommonConfig(){
	// 日期/时间格式
	$HUI.combobox("#DateFormat",
	{
		panelHeight:"80",
		valueField:"value",
		textField:"label",
		data:GV.dateFormat
	});
	$HUI.combobox("#TimeFormat",
	{
		panelHeight:"80",
		valueField:"value",
		textField:"label",
		data:GV.timeFormat
	});
	$HUI.combobox("#DateTimeStyle",
	{
		valueField:"value",
		textField:"desc",
		data:GV.DateTimeStyle
	});

	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"getRuleConfig",
		parId: getParId()
	},function(data){
		setFromValue("#ruleConfig",data)
		if(data.ImgSrc!=""){
			$(".show-img").show();	
		}else{
			$(".show-img").hide();		
		}
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
	})

	//特殊医嘱设置
	var specialOrderColumnData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getSpecialOrderColumnData"
	},false)

	//特殊医嘱显示 医嘱项
	$('#specialArcMastTable').datagrid({
		url: $URL,
		columns:[[
			{field:'id',hidden:true},
			{field:'ItemDR',title:'医嘱项', width:100, formatter: function (value, row, index) {
                return row["ItemDesc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: 'id',
                    textField: 'desc',
                    displayMsg: '',
                    url: $URL,
                    queryParams: {
                        ClassName: GV._CLASSNAME,
                        QueryName: "getArcim",
                        HospID: getHosp(),
                        ConfigName:'Nur_IP_OrderSheetSet'
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: 'id', title: 'id', width: 120, hidden: true },
                        { field: 'desc', title: "医嘱项", width: 300 }
                    ]],
					onSelect: function (rowIndex, rowData) {
						var indexs = $('#specialArcMastTable').datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#specialArcMastTable').datagrid('getRows')
							rows[indexs[0]].ItemDesc = rowData['desc']
						}
                    }
                }
            }},
            {field:'CreateLocs',title:'开医嘱科室',width:100,
				formatter: setMultFormatter(GV.LocData),
				editor:setMultEditor(GV.LocData),
			},
			{field:'ExecUser',title:'执行人',width:80,
				formatter: setFormatter(specialOrderColumnData.execUser),
				editor:setEditor(specialOrderColumnData.execUser),
			},{field:'ExecDataTime',title:'执行时间',width:100,
				formatter: setFormatter(specialOrderColumnData.execDateTime),
				editor:setEditor(specialOrderColumnData.execDateTime),
			},
			{field: 'handler', title: '操作', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='commonConfigHandler.deleteSpecialOrderRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
				}
			}

		]],
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		onBeforeLoad: function(param) {
			param.ClassName = "Nur.NIS.Service.OrderSheet.Setting"
			param.MethodName = "getSpecialOrder"
            param.parId = getParId()
            param.type =  "0"
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#specialArcMastTable').datagrid("acceptChanges");
				$('#specialArcMastTable').datagrid("unselectAll");
				$('#specialArcMastTable').datagrid('appendRow',{});
                var rows= $('#specialArcMastTable').datagrid('getRows');
                $('#specialArcMastTable').datagrid('beginEdit',rows.length-1);
				$('#specialArcMastTable').datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
			$(this).datagrid("acceptChanges");
			$(this).datagrid("unselectAll");
			$(this).datagrid("beginEdit", rowIndex);
			$(this).datagrid("selectRow",rowIndex);
        },
        onLoadSuccess:function(Data){
			for (var index in Data.rows ){
				var single = Data.rows[index]
				single.CreateLocs = single.CreateLocs.toString()
			}
			return Data
		}
	})


	//特殊医嘱显示 医嘱子类
	$('#specialArcCatTable').datagrid({
		url: $URL,
		columns:[[
			{field:'ItemDR',title:'医嘱子类', width:100, formatter: function (value, row) {
                return row["ItemDesc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: 'id',
                    textField: 'desc',
                    displayMsg: '',
                    url: $URL,
                    queryParams: {
                        ClassName: GV._CLASSNAME,
                        QueryName: "getArcItmChart",
                        HospID: $HUI.combogrid('#_HospList').getValue()
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: 'id', title: 'id', width: 120, hidden: true },
                        { field: 'desc', title: "医嘱子类", width: 300 }
                    ]],
					onSelect: function (rowIndex, rowData) {
						var indexs = $('#specialArcCatTable').datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#specialArcCatTable').datagrid('getRows')
							rows[indexs[0]].ItemDesc = rowData['desc']
						}
                    }
                }
            }},
            {field:'CreateLocs',title:'开医嘱科室',width:100,
				formatter: setMultFormatter(GV.LocData),
				editor:setMultEditor(GV.LocData),
			},
			{field:'ExecUser',title:'执行人',width:80,
				formatter: setFormatter(specialOrderColumnData.execUser),
				editor:setEditor(specialOrderColumnData.execUser),
			},{field:'ExecDataTime',title:'执行时间',width:100,
				formatter: setFormatter(specialOrderColumnData.execDateTime),
				editor:setEditor(specialOrderColumnData.execDateTime),
			},
			{field: 'handler', title: '操作', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='commonConfigHandler.deleteSpecialOrderRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
				}
			}

		]],
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		onBeforeLoad: function(param) {
			param.ClassName = "Nur.NIS.Service.OrderSheet.Setting"
			param.MethodName = "getSpecialOrder"
            param.parId = getParId()
            param.type =  "1"
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#specialArcCatTable').datagrid("acceptChanges");
				$('#specialArcCatTable').datagrid("unselectAll");
				$('#specialArcCatTable').datagrid('appendRow',{});
                var rows= $('#specialArcCatTable').datagrid('getRows');
                $('#specialArcCatTable').datagrid('beginEdit',rows.length-1);
				$('#specialArcCatTable').datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $(this).datagrid("acceptChanges");
			$(this).datagrid("unselectAll");
			$(this).datagrid("beginEdit", rowIndex);
			$(this).datagrid("selectRow",rowIndex);
        },
        onLoadSuccess:function(Data){
			for (var index in Data.rows ){
				var single = Data.rows[index]
				single.CreateLocs = single.CreateLocs.toString()
			}
			return Data
		}
	})

	//屏蔽设置
	initAutoSaveGridData("dgOrderCat","GetShieldSet",0, {
		combogrid: {
			getMethod: 'getOrdCat',
            valueField: 'id',
            textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '屏蔽的医嘱大类',
		fieldWidth: 220,
		operFormatter: delBtn("dgOrderCat")
	});
	initAutoSaveGridData("dgArcCat2","GetShieldSet",1, {
		combogrid: {
			getMethod: 'getArcItmChart',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '屏蔽的医嘱子类',
		fieldWidth: 220,
		operFormatter: delBtn("dgArcCat2")
	});
	initAutoSaveGridData("dgLoc","GetShieldSet",2, {
		combogrid: {
			getMethod: 'getLocs',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '屏蔽非本科室医嘱的开医嘱科室',
		fieldWidth: 220,
		operFormatter: delBtn("dgLoc")
	});
	initAutoSaveGridData("dgArcItm2","GetShieldSet",3, {
		combogrid: {
			getMethod: 'getArcim',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '屏蔽的医嘱项',
		fieldWidth: 220,
		operFormatter: delBtn("dgArcItm2")
	});
	initAutoSaveGridData("dgBindSource","GetShieldSet",4, {
		combogrid: {
			getMethod: 'getBindSource',
			valueField: 'id',
			textField: 'desc',
		},
		fieldName: 'itemDR',
		titleDesc: '屏蔽绑定医嘱的类型',
		fieldWidth: 220,
		operFormatter: delBtn("dgBindSource")
	});
}

/**
 * 通用设置
 */
var commonConfigHandler = {
	saveRuleConfig: function(){
		var ImgName=$("#img").filebox("files").length>0 ? $("#img").next().find('input[type=file]')[0].files[0].name : $("#img").next().find('input.filebox-text').val();
		$.cm({
			ClassName:GV._CLASSNAME,
			MethodName:"saveRuleConfig",
			saveDataJson:JSON.stringify(getFromValue("#ruleConfig")),
			ImgSrc: $(".show-img img").attr("src"),
			ImgName: ImgName,
			parId:getParId()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})		
	},
	saveSpecialOrder: function(tableID, type){
		$('#'+tableID).datagrid("acceptChanges");
		var rows = $('#'+tableID).datagrid('getRows')
		var ifExitNull = false
		$.each(rows,function(index,single){
			if (single.ItemDR == "" || String(single.ExecDataTime)=="" || String(single.ExecUser)=="")
			{
				ifExitNull = true
			}
		})
		if (ifExitNull)
		{
			$.messager.popover({ msg: "特殊医嘱显示配置存在填项！", type:'error',style: {bottom: 500,right: 500}});
			return
		}
		
		$cm({
			ClassName:GV._CLASSNAME,
			MethodName: "SaveSpecialOrder",
			saveDataJson: JSON.stringify(rows),
			parId: getParId(),
			type : type
		}, function(rtn){
			$('#'+tableID).datagrid("reload");
		})
	
	},
	deleteSpecialOrderRow: function(id){
		if ('undefined' === id || id === '' )
		{
			$.messager.popover({ msg: "未保存记录", type:'error' });
			return
		}
		$cm({
			ClassName:GV._CLASSNAME,
			MethodName: "DeleteSpecialOrder",
			id : id
		}, function(result){
			if (result == 0){
				$.messager.popover({ msg: "保存成功！", type:'success' });		
				$('#specialArcMastTable').datagrid("reload");
				$('#specialArcCatTable').datagrid("reload");
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}
		})
	},
	saveShieldSet: function(tableID,type,row){
		$.m({
			ClassName:GV._CLASSNAME,
			MethodName:"SaveShieldSet",
			saveDataJson:JSON.stringify(row),
			parId: getParId(),
			itemType:type
		},function testget(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });			
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}
			$('#' + tableID).datagrid('reload');
		})
	}
}

/**
 * 保存
 */
function saveSet(){
	if (getParId() == "")
	{
		$.messager.popover({ msg: "请先选择医嘱单配置列表！", type:'error' });
		return
	}
	textConfigHandler.save()
	sheetConfigHandler.save()
	sheetConfigHandler.saveOrdSuffixConfig()
	dispalyConfigHandler.saveOecprTable()
	dispalyConfigHandler.saveSkipTable()
	dispalyConfigHandler.saveTempOrdSet("dgArcCat",0)
	dispalyConfigHandler.saveTempOrdSet("dgArcItm",1)
	commonConfigHandler.saveRuleConfig()
	commonConfigHandler.saveSpecialOrder("specialArcMastTable","0")
	commonConfigHandler.saveSpecialOrder("specialArcCatTable","1")
}

/**
 * 表格配置-基础数据类型维护
 */
function opensheetDataSourceWin()
{
	$('#sheetDataSourceWin').window('open')
	$('#sheetDataSourceTable').datagrid('reload')
}

/**
 * 初始化 表格配置-基础数据类型维护弹窗
 */
function initsheetDataSourceWin(){

	
	$('#sheetDataSourceWin').window({
		top:"70px",
		width:900,  
		height:600,
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '表格配置-基础数据类型维护',
		iconCls:'icon-w-config'
	})


	$("#sheetDataSourceTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'code',title:'数据编码', width:100,editor:{type:'text'}},
				{field:'name',title:'名称', width:100,editor:{type:'text'}},
				{field:'note',title:'备注', width:100,editor:{type:'text'}},
				{field:'expression',title:'表达式', width:450,editor:{type:'text'}},
				{field: 'handler', title: '操作', width: 100, align:"center", formatter:function(value, row, index){
					return  "<span style='cursor:pointer' onclick='sheetDataSourceHandler.delete(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
					}
				}
			]
		],
		nowrap: false,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '加载中..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getSheetDataSource"
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#sheetDataSourceTable').datagrid("acceptChanges");
				$('#sheetDataSourceTable').datagrid("unselectAll");
				$('#sheetDataSourceTable').datagrid('appendRow',{});
                var rows= $('#sheetDataSourceTable').datagrid('getRows');
                $('#sheetDataSourceTable').datagrid('beginEdit',rows.length-1);
				$('#sheetDataSourceTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('保存'),
			handler: function(){
				sheetDataSourceHandler.save()
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#sheetDataSourceTable').datagrid("acceptChanges");
            $('#sheetDataSourceTable').datagrid("unselectAll");
            $('#sheetDataSourceTable').datagrid("beginEdit", rowIndex);
            $('#sheetDataSourceTable').datagrid("selectRow",rowIndex);
        }

	})
}

var sheetDataSourceHandler = {
	delete : function(id){
		if ("undefined" == id && id == "" ) return
		$.messager.confirm('提示','是否删除?',function(r){
			if (r)
			{
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "deleteSheetDataSource",
					id: id
				},function(result){
					if (result==0){
						$.messager.popover({ msg: "保存成功！", type:'success' });	
						$('#sheetDataSourceTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		})
	},
	save: function(){
		var indexs = $('#sheetDataSourceTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#sheetDataSourceTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#sheetDataSourceTable').datagrid('getRows');
		$.m({	
			ClassName:GV._CLASSNAME,
			MethodName:"saveSheetDataSource",
			saveDataJson:JSON.stringify(rows)
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "保存成功！", type:'success' });	
				$('#sheetDataSourceTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}
}
/**
 * 获取院区ID
 * @returns 
 */
function getHosp(){
	return $HUI.combogrid('#_HospList').getValue()
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

function filter1(q, row) {
		var opts = $(this).combobox('options');
		var text = row[opts.textField];
		var pyjp = getPinyin(text).toLowerCase();
		if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
			return true;
		}
		return false;
}
	
function setMultEditor(data){
	return {
		type:'combobox',
		options:{
			valueField:'id',
			textField:'desc',
			data: data,
			multiple:true,
			filter: filter1
		}
	}
}

function setMultFormatter(data){
	return function(values){
		var rtn=""
		if (!!values)
		{
			var valueList = values.toString().split(",")
			for (var i in valueList)
			{
				for(var j in data)
				{
					if (data[j].id == valueList[i]){
						rtn = (rtn=="" ? data[j].desc : (rtn+","+data[j].desc))
					}
				}
			}
		}
		return rtn
	}
}

function setCombogrid(){
	return{
		type:'combogrid',
		options:{
			width:180,
			panelWidth: 500,
			panelHeight: 350,
			delay:500,
			mode:'remote',
			idField: 'ArcimDR',
			textField: 'ArcimDesc',
			columns: [[
				{field:'ArcimDesc',title:'项目名称',width:100},
				{field:'ArcimDR',title:'项目ID',width:30}
			]],
			pagination : true,
			url:$URL,
			fitColumns: true,
			enterNullValueClear:true,
			onBeforeLoad:function(param){
				var indexs = $('#skipTable').datagrid('getEditingRowIndex');
				if (indexs.length != 0)
				{
					var ed = $('#skipTable').datagrid('getEditor', {index:indexs[0], field:'arcItmDesc'});
					param.q = $(ed.target).combogrid('getText')
				}
				param.ClassName = "Nur.NIS.Service.NursingGrade.DataConfig"
				param.QueryName = "FindMasterItem"
				param.arcimdesc = param.q
				param.HospId = getHosp()
			},
			onLoadSuccess:function(){			 
			}
		}

	}
}

function initGridData(tableID,queryName,type, setObj) {
    $('#' + tableID).datagrid({
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CLASSNAME,
			QueryName: queryName,
            parId: getParId(),
            type: type
        },
        columns: initGridColumn(tableID, setObj),
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('新增'),
			handler: function(){
				$('#'+tableID).datagrid("acceptChanges");
				$('#'+tableID).datagrid("unselectAll");
				$('#'+tableID).datagrid('appendRow',{});
                var rows= $('#'+tableID).datagrid('getRows');
                $('#'+tableID).datagrid('beginEdit',rows.length-1);
				$('#'+tableID).datagrid('selectRow',rows.length-1);
			}
		}],
		onDblClickRow:function(rowIndex,rowData){
			$(this).datagrid("acceptChanges");
			$(this).datagrid("unselectAll");
			$(this).datagrid("beginEdit", rowIndex);
			$(this).datagrid("selectRow",rowIndex);
		}
    });
}

function initGridColumn(tableID, setObj) {
    return [[
        {
            field: setObj.fieldName,
            title: setObj.titleDesc,
            width: setObj.fieldWidth,
            formatter: function (value, row) {
                return row["desc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: setObj.combogrid.valueField,
                    textField: setObj.combogrid.textField,
                    displayMsg: '',
                    url: $URL,
					onBeforeLoad:function(param){
						var indexs = $('#' + tableID).datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#' + tableID ).datagrid('getRows')
							var desc = rows.desc
							if ((!param.q)&&(!!desc))
							{
								param.q = desc
							}
						}
						param.ClassName = GV._CLASSNAME
                        param.QueryName = setObj.combogrid.getMethod
                        param.HospID = hospID
                        param.ConfigName = 'Nur_IP_OrderSheetSet'
					},
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: setObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
                        { field: setObj.combogrid.textField, title: setObj.titleDesc, width: 300 }
                    ]],
                    onSelect: function (rowIndex, rowData) {
						debugger
						var indexs = $('#' + tableID).datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#' + tableID).datagrid('getRows')
							rows[indexs[0]].desc = rowData[setObj.combogrid.textField]
						}
                    }
                }
            },
        },
        {field:'name',title:'显示名称',width:100,editor:{type:'validatebox'}},
        { field: 'oper', title: '操作', width: 40, formatter: setObj.operFormatter }
    ]];
}

function initAutoSaveGridData(tableID,queryName,type, setObj){
	$('#' + tableID).datagrid({
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CLASSNAME,
			QueryName: queryName,
            parId: getParId(),
            type: type
        },
        columns: initAutoSaveGridColumn(tableID,type,setObj),
		onClickRow: function (rowIndex,rowData) {
			$(this).datagrid("acceptChanges");
			$(this).datagrid("unselectAll");
			$(this).datagrid("beginEdit", rowIndex);
			$(this).datagrid("selectRow",rowIndex);
        },
		onLoadSuccess: function (data) {
            $('#' + tableID).datagrid('appendRow', {id:"",itemDR:"",desc:"",name:""});
        }
    });
}

function initAutoSaveGridColumn(tableID,type,setObj){
	return [[
        {
            field: setObj.fieldName,
            title: setObj.titleDesc,
            width: setObj.fieldWidth,
            formatter: function (value, row) {
                return row["desc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: setObj.combogrid.valueField,
                    textField: setObj.combogrid.textField,
                    displayMsg: '',
                    url: $URL,
					onBeforeLoad:function(param){
						var indexs = $('#' + tableID).datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#' + tableID ).datagrid('getRows')
							var desc = rows.desc
							if ((!param.q)&&(!!desc))
							{
								param.q = desc
							}
						}
						param.ClassName = GV._CLASSNAME
                        param.QueryName = setObj.combogrid.getMethod
                        param.HospID = hospID
                        param.ConfigName = 'Nur_IP_OrderSheetSet'
					},
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: setObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
                        { field: setObj.combogrid.textField, title: setObj.titleDesc, width: 300 }
                    ]],
                    onSelect: function (rowIndex, rowData) {
						var indexs = $('#' + tableID).datagrid('getEditingRowIndex');
						if (indexs.length != 0)
						{
							var rows = $('#' + tableID).datagrid('getRows')
							rows[indexs[0]].desc = rowData[setObj.combogrid.textField]
							rows[indexs[0]][setObj.fieldName] = rowData[setObj.combogrid.valueField]
							commonConfigHandler.saveShieldSet(tableID,type,rows[indexs[0]])
						}
                    }
                }
            },
        },
        { field: 'oper', title: '操作', width: 40, formatter: setObj.operFormatter }
    ]];
}

function delBtn(tableID) {
	return function(val,row,index){
		var btns = '';
		btns =   "<span style='cursor:pointer' onclick='onclick=delData(\""+ row.id +"\",\""+ tableID +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
    	return btns;	
	}   
}

function delData(rowid,tableID){
	var type;
	if(tableID=="dgArcCat" || tableID=="dgOrderCat") type=0;
	if(tableID=="dgArcItm" || tableID=="dgArcCat2") type=1;
	if(tableID=="dgLoc") type=2
	if(tableID=="dgArcItm2") type=3
	if (tableID=="dgBindSource") type=4
	if(rowid){
		$.m({
			ClassName:GV._CLASSNAME,
			MethodName:(tableID=="dgArcCat" || tableID=="dgArcItm") ? "DelTempOrdSet" : "DelShieldSet",
			rowid:rowid,
			parId: getParId(),
			itemType:type
		},function testget(result){	
			if(result==0){        		
				$("#"+tableID).datagrid("reload");			
			}else{	
				$.messager.popover({ msg: result, type:'error' });
				return;	
			}
		});
	}else{
		return $.messager.popover({ msg: "未保存的空白行不能删除！", type:'alert' });		
	}
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
					if (jQuery(this)[type]('options').multiple){
						jQuery(this)[type]('setValues', json[name] ? $.parseJSON(json[name]) : []);
					} else {
						jQuery(this)[type]('setValue', json[name] || '');
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
					if ($(this).attr("id") == iptsNames[i] + "_" + json[iptsNames[i]])
					{
						$(this).radio("check")
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
	ipts = jQuery("input.textbox[name], textarea[name]", target);
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

function getParId(){
	var parId=""
	var selectedRow = $('#configTable').datagrid('getSelected')
	if (!!selectedRow){
		parId = selectedRow.id
	}
	var selectedRow = $('#configCopyTable').datagrid('getSelected')
	if (!!selectedRow){
		parId = selectedRow.id
	}
	return parId
}

function getMark(){
	var Mark=""
	var selectedRow = $('#configTable').datagrid('getSelected')
	if (!!selectedRow){
		Mark = selectedRow.Mark
	}
	return Mark
}

/**
 * @description 验证是否为空
 * @param {*} id  
 * @returns 
 */
function verification(id){
    var flag = true
    $("#"+ id + " td").each(function(){
        if ($(this).hasClass("label-request"))
        {
            var item = $(this).next().children()
			var nodeName = item[0].tagName
            var itemValue = ""
            switch(nodeName)
            {
                case "INPUT":
                    itemValue = item.val()
                    break;
                case "SELECT":
                    itemValue = $.trim(item.combobox("getValue"))
                    break;
                default:
                    break;
            }
            if ( $.trim(itemValue) == "" )
            {
                flag = false
				$.messager.popover({ msg: $(this).text() + " 不能为空!", type:'error' });	
                return flag
            }
        }
    })
    return flag
}