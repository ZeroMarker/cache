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
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
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
var hospID,wardsData=[];
var selectESIndex,editESIndex,esTableData={"total":0,"rows":[]};
var selectADIndex,editADIndex,adTableData={"total":0,"rows":[]};
var selectGTIndex,editGTIndex,gtTableData={"total":0,"rows":[]};

$(function() {
	// if (parseInt(multiFlag)) {
		hospComp = GenHospComp("Nur_IP_CTCEvaluate",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
		///var hospComp = GenHospComp("ARC_ItemCat")
		// console.log(hospComp.getValue());     //获取下拉框的值
		hospID=hospComp.getValue();
		hospComp.options().onSelect = function(i,d){
			// 	HOSPDesc: "东华标准版数字化医院[总院]"
			// HOSPRowId: "2"
			console.log(arguments);
			hospID=d.HOSPRowId;
			getESTableData();
		}  ///选中事件
	// } else {
	// 	hospID=session['LOGON.HOSPID'];
	// }
	console.log(hospID);
	getESTableData();
})
function getESTableData() {
	// 获取放化疗评价系统数据
  $cm({
      ClassName: 'Nur.NIS.Service.CTC.Config',
      QueryName: 'GetCTCEvaluate',
      rows: 999999999999999,
      hospDR: hospID
  }, function (data) {
  	console.log(data);
    esTableData=data;
		selectESIndex=undefined;
		editESIndex=undefined;
		filterEvaluate()
  });
}
// 过滤病区
function filterEvaluate() {
	var keyword=$("#evaluateInput").searchbox('getValue');
	var filterData=[];
	esTableData.rows.map(function(elem) {
		if (elem.sysCode.toUpperCase().includes(keyword.toUpperCase())||elem.sysDesc.includes(keyword)) {
			filterData.push(elem);
		}
	})
  $('#evaluateSystem').datagrid({data: filterData});
	getADRsTableData();
}
function filterADRs() {
	var keyword=$("#ADRsInput").searchbox('getValue');
	var filterData=[];
	adTableData.rows.map(function(elem) {
		if (elem.adrsCode.toUpperCase().includes(keyword.toUpperCase())||elem.adrsDesc.includes(keyword)) {
			filterData.push(elem);
		}
	})
  $('#ADRsTable').datagrid({data: filterData});
	getADRsContentAndGrades();
}
function selectESRow(curInd,row) {
	selectESIndex=curInd;
	$('#evaluateSystem').datagrid('selectRow',curInd);
	getADRsTableData(row.id);
	// editCSIndex=undefined;
	// selectCSIndex=undefined;
}
function editESRow(curInd,row) {
	// 当双击另一行时，先保存正在编辑的行
	if ((undefined!=editESIndex)&&(editESIndex!=curInd)&&!saveESRow()) return;
	editESIndex=curInd;
	$('#evaluateSystem').datagrid('beginEdit', editESIndex);
}
function addESRow() {
	if ((undefined!=editESIndex)&&!saveESRow()) return;
	editESIndex=$('#evaluateSystem').datagrid('getRows').length;
	var row={
		num: editESIndex+1,
		sysCode: "",
		sysDesc: "",
		id: ""
	}
	$('#evaluateSystem').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editESIndex);
	selectESIndex=editESIndex;
  editESRow(editESIndex,row)
  // esTableData.rows.push(row)
}
function saveESRow() {
	if (undefined==editESIndex) {
		return $.messager.popover({msg: '无需要保存的项！',type:'alert'});
	}
	var index=$('#evaluateSystem').datagrid('getEditingRowIndexs')[0];
	if (undefined===index) return true;
	var curRow=$('#evaluateSystem').datagrid('getRows')[index];
	var rowEditors=$('#evaluateSystem').datagrid('getEditors',editESIndex);
	var id=curRow.id||'';
	var sysCode=$(rowEditors[0].target).val();
	var sysDesc=$(rowEditors[1].target).val();
	if (!sysCode||!sysDesc) {
		$.messager.popover({msg: '请填写系统code和系统描述！',type:'alert'});
		return false;
	}

	for (var i = 0; i < esTableData.rows.length; i++) {
		if ((id!=esTableData.rows[i].id)&&(sysCode==esTableData.rows[i].sysCode)) {
			return $.messager.popover({msg: '系统code已存在！',type:'alert'});
		}
	}
	var data={
		id:id,
		sysCode:sysCode,
		sysDesc:sysDesc,
		hospDR:hospID
	}
	var updateRow=editESIndex;
  var res=$cm({
    ClassName: 'Nur.NIS.Service.CTC.Config',
    MethodName: 'AddOrUpdateCTCEvaluate',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	console.log(res);
	if (0==res||res.includes('@')) {
		$.messager.popover({msg: '保存成功！',type:'success'});
		var row={
    	id:id||res.split('@')[0],
    	sortNo:curRow.sortNo||res.split('@')[1],
      sysCode:sysCode,
      sysDesc:sysDesc
    };
		$('#evaluateSystem').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: row
    });
		$('#evaluateSystem').datagrid('endEdit',editESIndex)
		editESIndex=undefined;
		// 更新数据
		if (res.includes('@')) {
			esTableData.rows.push(row);
		} else {
			esTableData.rows.map(function(elem,index) {
				if (row.id==elem.id) {
					esTableData.rows[index].sysCode=row.sysCode;
					esTableData.rows[index].sysDesc=row.sysDesc;
				}
			});
		}
		filterEvaluate();
		return true;
	} else {
		$.messager.popover({msg: res,type:'alert'});
		return false;
	}
}
function deleteESRow() {
	var esObj = $('#evaluateSystem');
	var row=esObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
				if (row.id) {
			    var res=$cm({
		        ClassName: 'Nur.NIS.Service.CTC.Config',
		        MethodName: 'DeleteCTCEvaluate',
		        ID:row.id
			    }, false);
		    	console.log(res);
		    	if (0==res) {
		    		$.messager.popover({msg: '删除成功！',type:'success'});
						esTableData.rows.map(function(elem,index) {
							if (row.id==elem.id) {
								esTableData.rows.splice(index,1);
							}
						});
						filterEvaluate();
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
				}else{
					var curInd =esObj.datagrid('getRowIndex',row);
					esObj.datagrid('deleteRow',curInd);
				}
				// updateTableHeight()
				selectESIndex = undefined;
				editESIndex = undefined;
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
function beforeDragESRow() {
	// if ((undefined!=editESIndex)&&!saveESRow()) return false;
	if (undefined!=editESIndex) return false;
}
// 拖动数据引入表格
function dropESRow(target,source,point) {
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
    ClassName: 'Nur.NIS.Service.CTC.Config',
    MethodName: 'UpdateCTCEvaluateSort',
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
function getADRsTableData(pId) {
	// 获取放化疗评价系统数据
	if (pId) {
	  adTableData=$cm({
	      ClassName: 'Nur.NIS.Service.CTC.Config',
	      QueryName: 'GetCTCEvaluateADRs',
	      rows: 999999999999999,
	      pId: pId
	  }, false);
	} else {
		adTableData={"total":0,"rows":[]};
	}
	selectADIndex=undefined;
	editADIndex=undefined;
	filterADRs();
}
function selectADRsRow(curInd,row) {
	console.log(curInd,row);
	getADRsContentAndGrades(row.id);
}
function editADRsRow(curInd,row) {
	// 当双击另一行时，先保存正在编辑的行
	if ((undefined!=editADIndex)&&(editADIndex!=curInd)&&!saveADRsRow()) return;
	editADIndex=curInd;
	$('#ADRsTable').datagrid('beginEdit', editADIndex);
}
function addADRsRow() {
	var pRow=$('#evaluateSystem').datagrid('getSelected');
	if (!pRow) return $.messager.popover({msg: '请先选中评价系统中的行！',type:'alert'});
	if (!pRow.id) return $.messager.popover({msg: '请先保存评价系统中的行！',type:'alert'});
	if ((undefined!=editADIndex)&&!saveADRsRow()) return;
	editADIndex=$('#ADRsTable').datagrid('getRows').length;
	var row={
		num: editADIndex+1,
		adrsCode: "",
		adrsDesc: "",
		id: ""
	}
	$('#ADRsTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editADIndex);
	selectADIndex=editADIndex;
  editADRsRow(editADIndex,row)
}
function saveADRsRow() {
	if (undefined==editADIndex) {
		return $.messager.popover({msg: '无需要保存的项！',type:'alert'});
	}
	var index=$('#ADRsTable').datagrid('getEditingRowIndexs')[0];
	if (undefined===index) return true;
	var curRow=$('#ADRsTable').datagrid('getRows')[index];
	var rowEditors=$('#ADRsTable').datagrid('getEditors',editADIndex);
	var id=curRow.id||'';
	var adrsCode=$(rowEditors[0].target).val();
	var adrsDesc=$(rowEditors[1].target).val();
	if (!adrsCode||!adrsDesc) {
		$.messager.popover({msg: '请填写不良反应code和不良反应描述！',type:'alert'});
		return false;
	}

	for (var i = 0; i < adTableData.rows.length; i++) {
		if ((id!=adTableData.rows[i].id)&&(adrsCode==adTableData.rows[i].adrsCode)) {
			return $.messager.popover({msg: '不良反应code已存在！',type:'alert'});
		}
	}
	var pId=$('#evaluateSystem').datagrid('getSelected').id;
	var data={
		id:id,
		pId:pId,
		adrsCode:adrsCode,
		adrsDesc:adrsDesc
	}
	var updateRow=editADIndex;
  var res=$cm({
    ClassName: 'Nur.NIS.Service.CTC.Config',
    MethodName: 'AddOrUpdateCTCEvaluateADRs',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	console.log(res);
	if ((0==res)||res.includes(pId+"||")) {
		$.messager.popover({msg: '保存成功！',type:'success'});
		var row={
    	id:id||res.split('@')[0],
    	sortNo:curRow.sortNo||res.split('@')[1],
      adrsCode:adrsCode,
      adrsDesc:adrsDesc
    };
		$('#ADRsTable').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: row
    });
		$('#ADRsTable').datagrid('endEdit',editADIndex)
		editADIndex=undefined;
		// 更新数据
		if (0==res) {
			adTableData.rows.map(function(elem,index) {
				if (row.id==elem.id) {
					adTableData.rows[index].adrsCode=row.adrsCode;
					adTableData.rows[index].adrsDesc=row.adrsDesc;
				}
			});
		} else {
			adTableData.rows.push(row);
		}
		filterADRs();
		return true;
	} else {
		$.messager.popover({msg: res,type:'alert'});
		return false;
	}
}
function deleteADRsRow() {
	var adObj = $('#ADRsTable');
	var row=adObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
				if (row.id) {
			    var res=$cm({
		        ClassName: 'Nur.NIS.Service.CTC.Config',
		        MethodName: 'DeleteCTCEvaluateADRs',
		        ID:row.id
			    }, false);
		    	console.log(res);
		    	if (0==res) {
		    		$.messager.popover({msg: '删除成功！',type:'success'});
						adTableData.rows.map(function(elem,index) {
							if (row.id==elem.id) {
								adTableData.rows.splice(index,1);
							}
						});
						filterADRs();
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		    		return false
		    	}
				}else{
					var curInd =adObj.datagrid('getRowIndex',row);
					adObj.datagrid('deleteRow',curInd);
				}
				// updateTableHeight()
				selectADIndex = undefined;
				editADIndex = undefined;
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
function beforeDragADRsRow() {
	// if ((undefined!=editADIndex)&&!saveADRsRow()) return false;
	if (undefined!=editADIndex) return false;
}
// 拖动数据引入表格
function dropADRsRow(target,source,point) {
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
      ClassName: 'Nur.NIS.Service.CTC.Config',
      MethodName: 'UpdateCTCEvaluateADRsSort',
      newSort: newSort,
      ID:source.id
  }, function (data) {
  	console.log(data);
  	if (0==data) {
  		// 更新排序号
			var diObj = $('#dataImport');
  		var len=diObj.datagrid('getRows').length;
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
function getADRsContentAndGrades(id) {
	if (id) {
		gtTableData=$cm({
	    ClassName: 'Nur.NIS.Service.CTC.Config',
	    MethodName: 'GetADRsContentAndGrades',
	    id:id
	  }, false);
	} else {
		gtTableData={"total":0,"rows":[]};
	}
	$("#definition").val(gtTableData.definition||"");
	$("#extendedNotes").val(gtTableData.extendedNotes||"");
  $('#gradeTable').datagrid({data: gtTableData});
	editGTIndex=undefined;
}
function saveADRsContentAndGrades() {
	var curRow=$('#ADRsTable').datagrid('getSelected');
	if (!curRow) return $.messager.popover({msg: "请先选中不良反应！",type:'alert'});
	var adrsId=curRow.id;
	if (!adrsId) return $.messager.popover({msg: "请先保存不良反应！",type:'alert'});
	var definition=$("#definition").val();
	if (definition.length>500) return $.messager.popover({msg: "定义的长度不大于500！",type:'alert'});
	var extendedNotes=$("#extendedNotes").val();
	if (extendedNotes.length>500) return $.messager.popover({msg: "引申注释的长度不大于500！",type:'alert'});
	var saveFlag=1;
	// 有改变才保存
	if ((gtTableData.definition!=definition)||(gtTableData.extendedNotes!=extendedNotes)) {
		var data={
			id:adrsId,
			definition:definition,
			extendedNotes:extendedNotes
		}
	  var res=$cm({
	    ClassName: 'Nur.NIS.Service.CTC.Config',
	    MethodName: 'AddOrUpdateCTCEvaluateADRs',
	    dataType: "text",
	    data:JSON.stringify(data)
	  }, false);
	  if ((1==saveFlag)&&(0==res)) {
	  	// $.messager.popover({msg: '保存成功！',type:'success'});
	  	gtTableData.definition=definition;
	  	gtTableData.extendedNotes=extendedNotes;
	  }
	  if (0!=res) $.messager.popover({msg: res,type:'alert'});
	}
	// 保存分级
	var indexes=$('#gradeTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true;
	for (var i = 0; i < indexes.length; i++) {
		(function() {
			var j=i;
			var index=indexes[j];
			if (undefined===index) return true;
			var gradeRow=$('#gradeTable').datagrid('getRows')[index];
			var id=gradeRow.id;
			var rowEditors=$('#gradeTable').datagrid('getEditors',index);
			var gradeNum=$(rowEditors[0].target).combobox('getValue');
			console.log(gradeNum);
			if (!gradeNum) {
				submitFlag=false;
				return $.messager.popover({msg: "请选择分级！",type:'alert'});
			}
			var gradeDesc=$(rowEditors[1].target).val();
			if (gradeDesc.length<1) {
				submitFlag=false;
				return $.messager.popover({msg: "请填写分级描述！",type:'alert'});
			}
			if (gradeDesc.length>500) {
				submitFlag=false;
				return $.messager.popover({msg: "分级描述长度不大于500！",type:'alert'});
			}
			var measure=$(rowEditors[2].target).val();
			if (measure.length>500) {
				submitFlag=false;
				return $.messager.popover({msg: "措施长度不大于500！",type:'alert'});
			}
			// 重复校验
			var repeatFlag=false;
			gtTableData.rows.map(function(elem) {
				if ((id!=elem.id)&&(gradeNum==elem.gradeNum)) repeatFlag=true;
			})
			if (repeatFlag) {
				submitFlag=false;
				return $.messager.popover({msg: "分级编号已存在！",type:'alert'});
			}
			var gradeData={
				id:id,
				pId:adrsId,
				gradeNum:gradeNum,
				gradeDesc:gradeDesc,
				measure:measure
			}
			saveFlag=2;
			setTimeout(function() {
				if (!submitFlag) return;
			  $cm({
			    ClassName: 'Nur.NIS.Service.CTC.Config',
			    MethodName: 'AddOrUpdateCTCEvaluateADRsGrade',
			    dataType: "text",
			    data:JSON.stringify(gradeData)
			  }, function(res) {
					console.log(res);
					if ((0==res)||res.includes(adrsId+"||")) {
						// $.messager.popover({msg: "保存成功！",type:'success'});
					}else{
						$.messager.popover({msg: res,type:'alert'});
					}
					n++;
			  });
			},50);
		})();
	}
	var timer = setInterval(function(){
		if(n==indexes.length) {
			clearInterval(timer);
			getADRsContentAndGrades(adrsId);
			$.messager.popover({msg: "保存成功！",type:'success'});
		}
		if(m>20) {
			clearInterval(timer);
		}
		m++;
	},100);
}
function addGradeRow(curInd,row) {
	var pRow=$('#ADRsTable').datagrid('getSelected');
	if (!pRow) return $.messager.popover({msg: '请先选中不良反应中的行！',type:'alert'});
	if (!pRow.id) return $.messager.popover({msg: '请先保存不良反应中的行！',type:'alert'});
	// if (undefined!=editGTIndex) return $.messager.popover({msg: '请先保存分级内容！',type:'alert'});
	editGTIndex=$('#gradeTable').datagrid('getRows').length;
	var flag;
	for (var i = 1; i < 6; i++) {
		flag=true;
		gtTableData.rows.map(function(elem) {
			if (i==elem.gradeNum) {
				flag=false
			}
		})
		if (flag) break;
	}
	if (i>5) {
		editGTIndex=undefined;
		return $.messager.popover({msg: '分级新建不超过5个！',type:'alert'});
	}
	var row={
		num: editGTIndex+1,
		gradeNum: i,
		gradeDesc: "",
		id: ""
	}
	$('#gradeTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editGTIndex);
	selectGTIndex=editGTIndex;
  editGradeRow(editGTIndex,row)
}
function editGradeRow(curInd,row) {
	// 当双击另一行时，先保存正在编辑的行
	// if ((undefined!=editGTIndex)&&(editGTIndex!=curInd)) return;
	// editGTIndex=curInd;
	$('#gradeTable').datagrid('beginEdit', curInd);
}
function deleteGradeRow(gId,pId,id,obj) {
	if (0==gId) {
		var indexes=$('#gradeTable').datagrid('getEditingRowIndexs');
		var tr=$(obj).parents('tr');
		var index=tr.index();
		console.log(indexes);
		console.log(index);
		$('#gradeTable').datagrid('acceptChanges')
		gtTableData.rows.splice(index,1)
		// tr.remove();
	  $('#gradeTable').datagrid({data: gtTableData});
	  indexes.map(function(i) {
	  	if (i<index) {
	  		$('#gradeTable').datagrid('beginEdit', i);
	  	}
	  	if (i>index) {
	  		$('#gradeTable').datagrid('beginEdit', i-1);
	  	}
	  })
	} else {
		$.messager.confirm("删除", "确定要删除选中的分级?", function (r) {
			if (r) {
				var rowId=gId+"||"+pId+"||"+id;
		    var res=$cm({
		      ClassName: 'Nur.NIS.Service.CTC.Config',
		      MethodName: 'DeleteCTCEvaluateADRsGrade',
		      ID:rowId
		    }, false);
		  	console.log(res);
		  	if (0==res) {
		  		$.messager.popover({msg: '删除成功！',type:'success'});
					gtTableData.rows.map(function(elem,index) {
						if (rowId==elem.id) {
							gtTableData.rows.splice(index,1)
						}
					})
		  	} else {
		  		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
		  		return false
		  	}
				selectGTIndex = undefined;
				editGTIndex = undefined;
			  $('#gradeTable').datagrid({data: gtTableData});
			}
		});
	}
}
function resizeTableHeight() {
	var innerHeight=window.innerHeight;
  $('#evaluateSystem').datagrid('resize',{
    height:innerHeight-155
	});
  $('#ADRsTable').datagrid('resize',{
    height:innerHeight-155
	});
  $('#gradeTable').datagrid('resize',{
    height:innerHeight-346
	});
	setTimeout(function(){
	  $('.evaluate .datagrid-view .datagrid-body,.ADRs .datagrid-view .datagrid-body').css('height',innerHeight-185+'px');
	},100);
	setTimeout(function(){
		console.log($("div.grade>.panel").height());
		console.log($("div.ADRs>.panel").height());
	  $('#gradeTable').datagrid('resize',{
	    height:innerHeight-346-($("div.grade>.panel").height()-$("div.ADRs>.panel").height())
		});
	},300);
}
setTimeout(resizeTableHeight,100);
window.addEventListener("resize",resizeTableHeight);
