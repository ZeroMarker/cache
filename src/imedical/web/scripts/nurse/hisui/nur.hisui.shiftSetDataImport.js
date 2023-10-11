if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			$(this).datagrid('endEdit', param.index);
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				// if (fields[i] != param.field){
				if (!param.field.includes(fields[i])){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			if (param.field.includes('ruleLocs')) {
				reloadLocsData()
			}
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
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
// -----------------------------------------------------
var selectDIIndex,editDIIndex,hospComp,hospID,wardList,diTableData,wardID,wardDescObj={},fieldListAssemble={},fieldObj={},blankTabType=["NR","SR","SB","KL","ER"];
diTableData={"total":0,"rows":[]};
var selectCSIndex,editCSIndex,csTableData;
csTableData={"total":0,"rows":[]}
$.extend($.fn.datagrid.defaults.editors, {
	selfDefEdit: {
		init: function(container, options){
			var tabType=diTableData.rows[selectDIIndex].tabType
			if (!blankTabType.includes(tabType)) {
				console.log(11);
				var input = $('<input class="nameItem" type="text">').appendTo(container);
				return input.combobox({
				  data:fieldListAssemble[tabType],
				  valueField:'name',
				  textField:'name'
				});
			} else {
				console.log(22);
				var input = $('<input class="nameItem" class="textbox">').appendTo(container);
				console.log(2222);
				return $HUI.validatebox(input, {});
			}
		},
		destroy: function(target){
			if (!blankTabType.includes(diTableData.rows[selectDIIndex].tabType)) {
				console.log(11);
				$(target).combobox('destroy');
			} else {
				console.log(22);
				$(target)[0].destroy();
			}
		},
		getValue: function(target){
			if (!blankTabType.includes(diTableData.rows[selectDIIndex].tabType)) {
				console.log(11);
				return $(target).combobox('getValue');
			} else {
				console.log(22);
				console.log($(target));
				console.log($(target)[0].jdata.value);
				return $(target)[0].jdata.value;
			}
		},
		setValue: function(target, value){
			if (!blankTabType.includes(diTableData.rows[selectDIIndex].tabType)) {
				console.log(11);
				$(target).combobox('setValue',value);
			} else {
				console.log(22);
				console.log('"""""""""value"""""""""');
				console.log(value);
				console.log($(target));
				target.jqselector[0].value=value;
				$(target)[0].jdata.value=value;
			}
		},
		resize: function(target, width){
			if (!blankTabType.includes(diTableData.rows[selectDIIndex].tabType)) {
				console.log(11);
				$(target).combobox('resize',width);
			} else {
				console.log(22);
				$(target)[0].jqselector.css('width',width);
			}
		}
	}
});
$(function() {
	if (parseInt(multiFlag)) {
		hospComp = GenHospComp("Nur_IP_DataTab",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
		///var hospComp = GenHospComp("ARC_ItemCat")
		// console.log(hospComp.getValue());     //获取下拉框的值
		hospID=hospComp.getValue();
		hospComp.options().onSelect = function(i,d){
			// 	HOSPDesc: "东华标准版数字化医院[总院]"
			// HOSPRowId: "2"
			console.log(arguments);
		}  ///选中事件
	} else {
		hospID=session['LOGON.HOSPID'];
	}
	console.log(hospID);
	findDIData();
	getFieldLists();
})
// 查询数据引入表格
function findDIData() {
	hospID=hospComp?hospComp.getValue():hospID;
	wardID=$('#wardType').combobox('getValue');
	getallWardNew();
	$('#dataImport').datagrid('loadData',diTableData);
	$('#contentSet').datagrid('loadData',{"total":0,"rows":[]});
	$("#templateArea").val('');
	// 获取体征信息
  $cm({
      ClassName: 'Nur.SHIFT.Service.ShiftSetting',
      MethodName: 'GetVitalSignCode',
      hospID: hospID
  }, function (data) {
  	console.log(data);
  	fieldListAssemble["OBS"]=data;
  });
}
// 查询数据引入表格
function getFieldLists() {
	// 获取医嘱信息
  $cm({
      ClassName: 'Nur.NIS.Service.Page.PageHelper',
      MethodName: 'GetTableColumnOfAntVueUI',
      className: 'Nur.SHIFT.Service.ShiftDataBridge',
      classQuery: 'QueryOrdRecord'
  }, function (data) {
  	fieldListAssemble["OI"]=data;
  });
	// 获取检查信息
  $cm({
      ClassName: 'Nur.NIS.Service.Page.PageHelper',
      MethodName: 'GetTableColumnOfAntVueUI',
      className: 'Nur.SHIFT.Service.ShiftDataBridge',
      classQuery: 'GetReportInfo'
  }, function (data) {
  	fieldListAssemble["PACS"]=data;
  });
	// 获取校验信息
  $cm({
      ClassName: 'Nur.NIS.Service.Page.PageHelper',
      MethodName: 'GetTableColumnOfAntVueUI',
      className: 'Nur.SHIFT.Service.ShiftDataBridge',
      classQuery: 'GetLabResult'
  }, function (data) {
  	fieldListAssemble["LIS"]=data;
  });
}
function getWardsDesc(wardIDString) {
	if (''==wardIDString) return "";
	var ids=wardIDString.toString().split(','),str="";
	ids.map(function(elem,index) {
		str+=wardDescObj[elem]+",";
	});
	return str.slice(0,-1);
}
function getDITableData() {
	// 获取数据引入表格数据
  $cm({
      ClassName: 'Nur.SHIFT.Service.ShiftSetting',
      QueryName: 'GetShiftDataTabList',
      hospDR: hospID,
      wardType: wardID
  }, function (data) {
  	console.log(data);
  	data.rows.map(function(elem,index) {
			data.rows[index].ruleInvalidLocs=elem.ruleInvalidLocs.replace(/\|/g,',')
			data.rows[index].ruleLocs=elem.ruleLocs.replace(/\|/g,',')
		});
    diTableData=data;
		$('#dataImport').datagrid('loadData',diTableData);
		selectDIIndex=undefined;
		editDIIndex=undefined;
		resizePageStyle()
  });
}
function getallWardNew() {
	// 获取病区
    $cm({
        ClassName: 'Nur.NIS.Service.Base.Ward',
        QueryName: 'GetallWardNew',
        desc: '',
        hospid: hospID,
        bizTable: 'Nur_IP_DataTab',
        rows: 10000
    }, function (data) {
        wardList=data.rows;
        wardList.map(function(elem,index) {
        	wardDescObj[elem.wardid]=elem.warddesc;
        });
        getDITableData();
    	// console.log(wardList);
    });
}
function addDIRow() {
	if ((undefined!=editDIIndex)&&!saveDIRow()) return;
	editDIIndex=$('#dataImport').datagrid('getRows').length;
	var row={
		activeFlag: "Y",
		emrCode: "",
		emrVer: "",
		id: "",
		ruleInvalidLocs: "",
		ruleLocs: "",
		sortNo: "",
		tabID: "",
		tabName: "",
		tabType: ""
	}
	$('#dataImport').datagrid("insertRow", { 
		row: row
    }).datagrid("selectRow", editDIIndex);
	selectDIIndex=editDIIndex;
    editDIRow(editDIIndex,row)
}
//删除一行
function deleteDIRow() {
	var diObj = $('#dataImport');
	var row=diObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
				if (row.id) {
			    var res=$cm({
		        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
		        MethodName: 'DeleteShiftDataTab',
		        ID:row.id
			    }, false);
		    	console.log(res);
		    	if (0==res) {
		    		$.messager.popover({msg: '删除成功！',type:'success'});
		    		// 更新排序号
		    		var len=diObj.datagrid('getRows').length
		    		for (var i = 0; i < len; i++) {
			        diObj.datagrid('updateRow', {
		            index: i,
		            row: {
		            	sortNo:i+1
		            }
			        });
		    		}
		    		selectDIRow();
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
				}
				var curInd =diObj.datagrid('getRowIndex',row);
				diObj.datagrid('deleteRow',curInd);
				// updateTableHeight()
				selectDIIndex = undefined;
				editDIIndex = undefined;
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
// 选中数据引入表格
function selectDIRow(curInd) {
	selectDIIndex=curInd;
	$('#dataImport').datagrid('selectRow',curInd);
	getCSTableData();
	getTemplateSetData();
	if(editCSIndex!==undefined) $("#contentSet").datagrid("endEdit",editCSIndex);
	editCSIndex=undefined;
	selectCSIndex=undefined;
}
// 编辑数据引入表格
function editDIRow(curInd,row) {
	// 当双击另一行时，先保存正在编辑的行
	if ((undefined!=editDIIndex)&&(editDIIndex!=curInd)&&!saveDIRow()) return;
	editDIIndex=curInd;
	if ("NR"==row.tabType) {
		$('#dataImport').datagrid('editCell', {
			index:editDIIndex,
			field:['tabID','tabName','tabType','emrVer','emrCode','ruleLocs','ruleInvalidLocs','activeFlag']
		});
	} else {
		$('#dataImport').datagrid('editCell', {
			index:editDIIndex,
			field:['tabID','tabName','tabType','ruleLocs','ruleInvalidLocs','activeFlag']
		});
	}
	reloadLocsData()
}
function beforeDragDIRow() {
	if ((undefined!=editDIIndex)&&(editDIIndex!=curInd)&&!saveDIRow()) return false;
}
// 拖动数据引入表格
function dropDIRow(target,source,point) {
	var newSort=target.sortNo,oldSort=source.sortNo;
	if (newSort==oldSort) return;
	if ((newSort>oldSort)&&('top'==point)) {
		newSort--;
	}
	if ((newSort<oldSort)&&('bottom'==point)) {
		newSort++;
	}
	if (newSort==oldSort) return;
    $cm({
        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
        MethodName: 'UpdateShiftDataTabSort',
        newSort: newSort,
        ID:source.id
    }, function (data) {
    	console.log(data);
    	if (0==data) {
    		// 更新排序号
			var diObj = $('#dataImport');
    		var len=diObj.datagrid('getRows').length
    		for (var i = 0; i < len; i++) {
		        diObj.datagrid('updateRow', {
		            index: i,
		            row: {
		            	sortNo:i+1
		            }
		        });
    		}
			$('#dataImport').datagrid('loadData',diTableData);
    	} else {
    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
    	}
    });
}
// 保存数据引入表格
function saveDIRow() {
	if (undefined==editDIIndex) {
		return $.messager.popover({msg: '无需要保存的项！',type:'alert'});
	}
	var rowEditors=$('#dataImport').datagrid('getEditors',editDIIndex);
	var tabID=$(rowEditors[0].target).val();
	var tabName=$(rowEditors[1].target).val();
	var tabType=$(rowEditors[2].target).combobox('getValue');
	if (!tabID||!tabName||!tabType) {
		$.messager.popover({msg: '请填写页签id、名称和类型！',type:'alert'});
		return false;
	}
	var emrVer="",emrCode="",ruleLocs="",ruleInvalidLocs="",activeFlag="";
	if ("NR"==tabType) {
		emrVer=$(rowEditors[3].target).combobox('getValue');
		emrCode=$(rowEditors[4].target).val();
		ruleLocs=$(rowEditors[5].target).combobox('getValues');
		ruleInvalidLocs=$(rowEditors[6].target).combobox('getValues');
		activeFlag=$(rowEditors[7].target).checkbox('getValue');
		if (!emrVer||!emrCode) {
			$.messager.popover({msg: '病历版本和code不能为空！',type:'alert'});
			return false;
		}
	} else {
		ruleLocs=$(rowEditors[3].target).combobox('getValues');
		ruleInvalidLocs=$(rowEditors[4].target).combobox('getValues');
		activeFlag=$(rowEditors[5].target).checkbox('getValue');
	}
	console.log(tabID,tabName,tabType,emrVer,emrCode,ruleLocs,ruleInvalidLocs,activeFlag);

	var repeatCheck={};//重复校验
	for (var i = 0; i < ruleLocs.length; i++) {
		repeatCheck[ruleLocs[i]]=1;
	}
	for (var i = 0; i < ruleInvalidLocs.length; i++) {
		if (repeatCheck[ruleInvalidLocs[i]]) {
			$.messager.popover({msg: '适用范围和不适用范围不能有相同选项！',type:'alert'});
			return false;
		} else {
			repeatCheck[ruleInvalidLocs[i]]=1;
		}
	}
	var data={
		id:diTableData.rows[editDIIndex].id||'',
		tabID:tabID,
		tabName:tabName,
		tabType:tabType,
		emrVer:emrVer,
		emrCode:emrCode,
		ruleLocs:ruleLocs.join('|'),
		ruleInvalidLocs:ruleInvalidLocs.join('|'),
		activeFlag:activeFlag?'Y':'N',
		hospitalID:hospID,
		wardType:wardID,
	}
	var updateRow=editDIIndex;
  var res=$cm({
    ClassName: 'Nur.SHIFT.Service.ShiftSetting',
    MethodName: 'AddOrUpdateShiftDataTab',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	console.log(res);
	if (0==res||res.includes('@')) {
		$.messager.popover({msg: '保存成功！',type:'success'});
		$('#dataImport').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: {
      	id:diTableData.rows[updateRow].id||res.split('@')[0],
      	sortNo:diTableData.rows[updateRow].sortNo||res.split('@')[1],
        emrVer:emrVer,
        emrCode:emrCode
      }
    });
		$('#dataImport').datagrid('endEdit',editDIIndex)
		editDIIndex=undefined;
		return true;
	} else {
		$.messager.popover({msg: res,type:'alert'});
		return false;
	}
}

function getCSTableData() {
	// 获取数据引入表格数据
	var pRow=$('#dataImport').datagrid('getSelected');
	if (!pRow||!pRow.id) return $('#contentSet').datagrid('loadData',{"total":0,"rows":[]});
  $cm({
      ClassName: 'Nur.SHIFT.Service.ShiftSetting',
      QueryName: 'GetShiftEmrDataFieldList',
      parentId: pRow.id
  }, function (data) {
  	console.log(data);
    csTableData=data;
		$('#contentSet').datagrid('loadData',csTableData);
		// updateTableHeight()
  });
}
function addCSRow() {
	if (undefined==selectDIIndex) {
		$.messager.popover({msg: "请先选中引入类型表格中的行！",type:'alert'});
		return;
	}
	if (!$('#dataImport').datagrid('getSelected').id) {
		$.messager.popover({msg: "请先保存选中的行！",type:'alert'});
		return;
	}
	if ((undefined!=editCSIndex)&&!saveCSRow()) return;
	editCSIndex=$('#contentSet').datagrid('getRows').length;
	console.log(editCSIndex);
	var row={
		id: "",
		contentID: "",
		contentName: "",
		field: "",
		sortNo: ""
	}
	$('#contentSet').datagrid("insertRow", { 
		row: row
    }).datagrid("selectRow", editCSIndex);
	selectCSIndex=editCSIndex;
    editCSRow(editCSIndex,row)
}
//删除一行
function deleteCSRow() {
	var csObj = $('#contentSet');
	var row=csObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
				if (row.id) {
				    $cm({
				        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
				        MethodName: 'DeleteShiftEmrDataField',
				        ID:row.id
				    }, function (data) {
				    	console.log(data);
				    	if (0==data) {
				    		$.messager.popover({msg: '删除成功！',type:'success'});
				    		// 更新排序号
				    		var len=csObj.datagrid('getRows').length
				    		for (var i = 0; i < len; i++) {
						        csObj.datagrid('updateRow', {
						            index: i,
						            row: {
						            	sortNo:i+1
						            }
						        });
				    		}
				    	} else {
				    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
				    	}
				    });
				}
				var curInd =csObj.datagrid('getRowIndex',row);
				csObj.datagrid('deleteRow',curInd);
				selectCSIndex = undefined;
				editCSIndex = undefined;
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
// 选中数据引入表格
function selectCSRow(curInd) {
	selectCSIndex=curInd;
	$('#contentSet').datagrid('selectRow',curInd);
}
// 编辑数据引入表格
function editCSRow(curInd,row) {
	console.log(arguments);
	// 当双击另一行时，先保存正在编辑的行
	if ((undefined!=editCSIndex)&&(editCSIndex!=curInd)&&!saveCSRow()) return;
	editCSIndex=curInd;
	$('#contentSet').datagrid('editCell', {
		index:editCSIndex,
		field:['contentID','contentName','field']
	});
}
function beforeDragCSRow() {
	if ((undefined!=editCSIndex)&&(editCSIndex!=curInd)&&!saveCSRow()) return false;
}
// 拖动数据引入表格
function dropCSRow(target,source,point) {
	var newSort=target.sortNo,oldSort=source.sortNo;
	if (newSort==oldSort) return;
	if ((newSort>oldSort)&&('top'==point)) {
		newSort--;
	}
	if ((newSort<oldSort)&&('bottom'==point)) {
		newSort++;
	}
	if (newSort==oldSort) return;
    $cm({
        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
        MethodName: 'UpdateShiftEmrDataFieldSort',
        newSort: newSort,
        ID:source.id
    }, function (data) {
    	console.log(data);
    	if (0==data) {
    		// 更新排序号
			var csObj = $('#contentSet');
    		var len=csObj.datagrid('getRows').length
    		for (var i = 0; i < len; i++) {
		        csObj.datagrid('updateRow', {
		            index: i,
		            row: {
		            	sortNo:i+1
		            }
		        });
    		}
			$('#contentSet').datagrid('loadData',csTableData);
    	} else {
    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
    	}
    });
}
// 保存数据引入表格
function saveCSRow() {
	if (undefined==editCSIndex) {
		return $.messager.popover({msg: '无需要保存的项！',type:'alert'});
	}
	var rowEditors=$('#contentSet').datagrid('getEditors',editCSIndex);
	var contentID=$(rowEditors[0].target).val();
	var contentName=$(rowEditors[1].target).val();
	if (!blankTabType.includes(diTableData.rows[selectDIIndex].tabType)) {
		var field=$(rowEditors[2].target).combobox('getValue');
	} else {
		var field=$(rowEditors[2].target)[0].jdata.value;
	}
	if (!contentID||!contentName||!field) {
		$.messager.popover({msg: '请填写引入内容Id、名称和关联字段！',type:'alert'});
		return false;
	}
	var repeatCheck={},tmpContentID;//重复校验
	for (var i = 0; i < csTableData.rows.length; i++) {
		if (editCSIndex==i) {
			tmpContentID=contentID;
		} else {
			tmpContentID=csTableData.rows[i].contentID;
		}
		if (repeatCheck[tmpContentID]) {
			$.messager.popover({msg: '引入内容Id不能重复！',type:'alert'});
			return false;
		} else {
			repeatCheck[tmpContentID]=1;
		}
	}
	var data={
		id:csTableData.rows[editCSIndex].id||'',
		contentID:contentID,
		contentName:contentName,
		field:field,
		parentId:$('#dataImport').datagrid('getSelected').id
	}
	var updateRow=editCSIndex;
  var res=$cm({
    ClassName: 'Nur.SHIFT.Service.ShiftSetting',
    MethodName: 'AddOrUpdateShiftEmrDataField',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	console.log(res);
  if (0==res||res.includes('@')) {
    $.messager.popover({msg: '保存成功！',type:'success'});
    $('#contentSet').datagrid('updateRow', {
      index: updateRow,
      row: {
      	id:csTableData.rows[updateRow].id||res.split('@')[0],
				contentID:contentID,
				contentName:contentName,
				field:field,
      	sortNo:csTableData.rows[updateRow].sortNo||res.split('@')[1]
      }
    });
		$('#contentSet').datagrid('endEdit',editCSIndex)
		editCSIndex=undefined;
		return true;
  } else {
    $.messager.popover({msg: res,type:'alert'});
    return false;
  }
}
// 添加置换符
function addDisplaceMark() {
	var str="{}";
	if (undefined!=selectCSIndex) {
		str="{"+csTableData.rows[selectCSIndex].contentID+"}";
	}
	insertText($("#templateArea")[0],str)
}

function addDisplace() {

	insertText($("#templateArea")[0],"@")
}

function getTemplateSetData() {
	var pRow=diTableData.rows[selectDIIndex]
	if (!pRow||!pRow.id) {
    	$("#templateArea").val('');
    	return;
	} 
  $cm({
    ClassName: 'Nur.SHIFT.Service.ShiftSetting',
    MethodName: 'GetShiftDataTabTemplate',
    dataType: "text",
    id: pRow.id
  }, function (data) {
  	console.log(data);
  	$("#templateArea").val(data)
  });
}
function saveTemplate() {
	var pRow=diTableData.rows[selectDIIndex]
	if (!pRow) {
		return $.messager.popover({msg: '请先选择数据引入类型中的行！',type:'alert'});
	}
	if (!pRow.id) {
		return $.messager.popover({msg: '请先保存选中的行！',type:'alert'});
	}
    $cm({
        ClassName: 'Nur.SHIFT.Service.ShiftSetting',
        MethodName: 'saveShiftDataTabTemplate',
        id: pRow.id,
        data:$("#templateArea").val()
    }, function (data) {
    	console.log(data);
    	if (0==data) {
    		$.messager.popover({msg: '模板保存成功！',type:'success'});
    	} else {
    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
    	}
    });
}
function insertText(obj,str) {
  if (document.selection) {
    var sel = document.selection.createRange();
    sel.text = str;
  } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
    var startPos = obj.selectionStart,
        endPos = obj.selectionEnd,
        cursorPos = startPos,
        tmpStr = obj.value;
    obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length);
    cursorPos += str.length;
    obj.selectionStart = obj.selectionEnd = cursorPos;
  } else {
    obj.value += str;
  }
}

function reloadLocsData() {
	var row=diTableData.rows[editDIIndex];
	// 重新加载病区数据
	var ruleLocsEditor = $('#dataImport').datagrid('getEditor', {
		index : editDIIndex,  
		field : 'ruleLocs'  
    });
	console.log(ruleLocsEditor);
	$(ruleLocsEditor.target).combobox({
    data:wardList,
    width:$(ruleLocsEditor.target).parentsUntil('tr')[0].offsetWidth
	}).combobox('setValues',row.ruleLocs?row.ruleLocs.split(','):[]);
	var ruleInvalidLocsEditor = $('#dataImport').datagrid('getEditor', {
		index : editDIIndex,  
		field : 'ruleInvalidLocs'  
    });
	$(ruleInvalidLocsEditor.target).combobox({
		data:wardList,
    width:$(ruleInvalidLocsEditor.target).parentsUntil('tr')[0].offsetWidth
	}).combobox('setValues',row.ruleInvalidLocs?row.ruleInvalidLocs.split(','):[]);
}

function tabTypeChange(data) {
	// desc: "护理病历", value: "NR"
	if ("NR"==data.value) {
		if ($('#dataImport').datagrid('validateRow', editDIIndex)){
			$('#dataImport').datagrid('editCell', {
				index:editDIIndex,
				field:['tabID','tabName','tabType','emrVer','emrCode','ruleLocs','ruleInvalidLocs','activeFlag']
			});
		}
	} else {
		$('#dataImport').datagrid('editCell', {
			index:editDIIndex,
			field:['tabID','tabName','tabType','ruleLocs','ruleInvalidLocs','activeFlag']
		});
	}
}
function updateTableHeight() {
	$('#dataImport').datagrid('resize',{
    	width: document.querySelector("hr.dashed").offsetWidth,
        height:(window.innerHeight-70) / 2
    })
    $('#importContentSet').panel('resize', {
    	width: document.querySelector("hr.dashed").offsetWidth,
    	height:(window.innerHeight-70) / 2
    	// width: window.innerWidth-40
    }); 
    $('#templateSet').panel('resize', {
    	width:parseInt((window.innerWidth-50)*0.4),
    	height:document.querySelector(".flex2").offsetHeight+1
    }); 
    console.log(document.querySelector(".flex2").offsetHeight);
	$('#contentSet').datagrid('resize',{
		width:parseInt((window.innerWidth-50)*0.6),
        height:document.querySelector(".flex2").offsetHeight+1
    })
    $('#templateArea').css("height",document.querySelector(".flex2").offsetHeight - 38 - 38)
}
function resizePageStyle() {
	updateTableHeight()
	setTimeout(function(){
		updateTableHeight()
	},800)
}
window.addEventListener("resize",resizePageStyle)
