/**
*-----
* @author : wanghc
* @date   : 2019-04-10
* @desc   : 编辑表格 
*-----
*/

/*
* 默认增删改回调
* 提示msg操作成功或失败。后台dto返回json包含gridId属性,刷新gridId表格
*/ 
var defaultCallBack = function(rtn){
	if (rtn.success==1){
		if (rtn.gridId!=""){
			$('#'+rtn.gridId).datagrid('load');
		}
		$.messager.popover({msg:rtn.msg,type:'success'});
	}else{
		$.messager.popover({msg:rtn.msg,type:'error'});
	}
}
/**
* 1. 默认操作方法Find,Insert,Update,Del
* 2. opts.xxxReq.hidden为true时不显示相应的按钮
* @cfg {Object} gridContent  当前grid所在的上下文本  window|top
* @cfg {String} key 生成列表Id=key+"Grid"
* @cfg {Array} columns
* @cfg {Stirng} title
* @cfg {Object} {getReq:{},insReq:{},...}   操作url
* @cfg {String} activeColName  代表行记录激活与否的字段名
* @cfg {String} border
* @cfg {Array} beforeToolbar [{text:'前按钮'},...]
* @cfg {Array} afterToolbar [{text:'后按钮'},...]
* @event onAfterRender
* @event {Function} delHandler
* @event {Function} insOrUpdHandler
* @event {Function} getNewRecord
* @event {Function} onLoadSuccess
* @event {Function} onBeforeLoad
* @event {Function} onClickRow
* @event {Function} onDblClickRow
*/


var createDatagridEdit = function(opts){
	var key = opts.key;
	var cn = opts.className;
	var currEditIndex = -1;
	var gridId = key+"Grid";
	/*var $ = $
	if (opts && opts.gridContent && opts.gridContent.$) {
		 $ =  opts.gridContent.$ ;
	}*/
	opts = $.extend(true,{
		activeColName:'Active',
		getReq : {ClassName:cn,QueryName:"Find"},
		insReq : {ClassName:cn,MethodName:"Insert","dto.gridId":key+"Grid"},
		saveReq: {hidden:false},
		updReq : {ClassName:cn,MethodName:"Update","dto.gridId":key+"Grid"},
		delReq : {ClassName:cn,MethodName:"Del","dto.gridId":key+"Grid"}
	},opts);
	$(document.body).keydown(function(e){
		if (e.key=="Escape"){
			$("#"+key+'CancelBtn').trigger('click');
		}
	});
	$.fn.datagrid.defaults.view.onAfterRender = opts.onAfterRender;
	if ("undefined" == typeof opts.border ){opts.border=true;}
	var _toolbar=[];
	if (opts.beforeToolbar) _toolbar=opts.beforeToolbar;
	if (!opts.insReq.hidden){
		_toolbar.push({id:key+'AddBtn',iconCls:'icon-add',text:opts.addBtnText||'新增',handler:function(){
			if (currEditIndex>-1){
				$.messager.popover({msg:'有正在编辑的项目',type:'info'});
				return ;
			}
			if (currEditIndex === -1) {
				var row = $('#'+gridId).datagrid("getRows");
				var lastInd = row.length;
                $("#"+gridId).datagrid('insertRow', {index : lastInd, row : opts.getNewRecord()} );
                $("#"+gridId).datagrid('beginEdit', lastInd);	
				var inputObj = $("#"+gridId).datagrid('getPanel').find('.datagrid-row-editing input');
				$.each(inputObj,function(index,item){
					var _t = $(this);
					if (!_t.prop('disabled') && _t.css('display')!='none'){
						_t.focus();
						return false;
					}
				});
            }
		}});
	}
	if (!opts.updReq.hidden){
		_toolbar.push({
			id:key+'EditBtn',iconCls:'icon-write-order',text:opts.editBtnText||'修改',handler:function(){
			if (currEditIndex==-1){
				//var gridId = $(this).closest(".datagrid").find('table.datagrid-f').attr('id');
				//if (gridId!=""){
				var grid = $('#'+gridId);
				var curInd = grid.datagrid('getRowIndex',grid.datagrid('getSelected'));
				grid.datagrid('beginEdit',curInd);
				var ed2 = grid.datagrid('getEditor', { 'index': curInd, field: 'Code' });
				if (ed2){
					$(ed2.target).attr("disabled", true);
					if ($(ed2.target).hasClass('combo-f')){
						$(ed2.target).combobox('disable');
					}
				}
				currEditIndex = curInd;
				var inputObj = $("#"+gridId).datagrid('getPanel').find('.datagrid-row-editing input');
				$.each(inputObj,function(index,item){
					var _t = $(this);
					if (!_t.prop('disabled') && _t.css('display')!='none'){
						_t.focus();
						return false;
					}
				});
				//}
			}
		}});
	}
	if (!opts.saveReq.hidden){
		_toolbar.push({
			id:key+'SaveBtn',iconCls:'icon-save',text:opts.saveBtnText||'保存',handler:function(){
			if (currEditIndex>-1){
				var oriEditIndex = currEditIndex;
				var gridJObj = $('#'+gridId);
				gridJObj.datagrid('endEdit',currEditIndex); //acceptChanges
				var row = gridJObj.datagrid("getChanges"); //完成编辑后才能取到getChanges
				
				if (row.length>0){
					if (row[0].Code==""){ 
						$.messager.popover({msg:'代码不能为空',type:'info'});
						gridJObj.datagrid('beginEdit',oriEditIndex);
						return ; 
					}
					if (row[0].Description==""){ 
						$.messager.popover({msg:'描述不能为空',type:'info'}); 
						gridJObj.datagrid('beginEdit',oriEditIndex);
						return ; 
					}
					opts.insOrUpdHandler(row[0],function(flag,msg,data){
							if (flag){
								gridJObj.datagrid('load');
								$.messager.popover({msg:msg||'成功',type:'success'});
							}else{
								$.messager.popover({msg:msg||'失败',type:'error'});
								gridJObj.datagrid('beginEdit',oriEditIndex);
								return ; 
							}
					});
				}else{
					gridJObj.datagrid('endEdit',currEditIndex); //acceptChanges
				}
			}
		}});
	}
	if (!opts.delReq.hidden){
		_toolbar.push({
			id:key+'DelBtn',iconCls:'icon-cancel',text:opts.delBtnText||'删除',handler:function(){
			var row = $('#'+gridId).datagrid('getSelected');
			if (row.ID=="") return;
			opts.delHandler(row);
		}});
	}
	_toolbar.push({
		id:key+'CancelBtn',iconCls:'icon-undo',text:opts.cancelBtnText||'撤销',handler:function(){
		if (currEditIndex>-1) {
			var row = $('#'+gridId).datagrid('getRows')[currEditIndex];
			if (row.ID=="") {
				$('#'+gridId).datagrid('deleteRow',currEditIndex);
			}else{
				$('#'+gridId).datagrid('cancelEdit',currEditIndex);
			}
		}
	}});
	$("#"+gridId).datagrid({
		headerCls:'panel-header-gray',
		bodyCls:'panel-body-gray',
		rownumbers:true,singleSelect:true,fit:true,pagination:true,showPageList:false,pageSize:50,
		fitColumns:true,showChangedStyle:false,
		border:opts.border,
		iconCls:'icon-paper',
		title:opts.title,
		url:$URL,
		queryParams:opts.getReq,
		columns:opts.columns,
		toolbar:_toolbar,
		rowStyler: function(index,row){if (row[opts.activeColName]=="N" || row[opts.activeColName]=="0"){return 'color:#ccc;';}},
		onBeforeEdit:function(rowIndex,rowData){
			currEditIndex = rowIndex;
			$("#"+key+"SaveBtn").linkbutton('enable');
			$("#"+key+"EditBtn").linkbutton('disable');
			$("#"+key+"AddBtn").linkbutton('disable');
			$("#"+key+"DelBtn").linkbutton('disable');
			$("#"+key+"CancelBtn").linkbutton('enable');
			$("#"+gridId).datagrid('selectRow', rowIndex);
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			currEditIndex=-1;	
			$("#"+key+"AddBtn").linkbutton('enable');
			$("#"+key+"EditBtn").linkbutton('enable');
			$("#"+key+"DelBtn").linkbutton('enable');
			$("#"+key+"SaveBtn").linkbutton('disable');
			$("#"+key+"CancelBtn").linkbutton('disable');
		},
		onCancelEdit:function(){
			currEditIndex=-1;
			var selRow = $(this).datagrid('getSelected');
			if (selRow["ID"]==""){ //增加空行后-cancel
				$("#"+key+"DelBtn").linkbutton('disable');
				$("#"+key+"EditBtn").linkbutton('disable');
			}else{
				$("#"+key+"EditBtn").linkbutton('enable');
				$("#"+key+"DelBtn").linkbutton('enable');
			}
			$("#"+key+"AddBtn").linkbutton('enable');
			$("#"+key+"SaveBtn").linkbutton('disable');
			$("#"+key+"CancelBtn").linkbutton('disable');
			
		},
		onLoadSuccess:function(data){
			currEditIndex=-1;
			$("#"+key+"AddBtn").linkbutton('enable');
			$("#"+key+"EditBtn").linkbutton('disable');
			$("#"+key+"DelBtn").linkbutton('disable');
			$("#"+key+"SaveBtn").linkbutton('disable');
			$("#"+key+"CancelBtn").linkbutton('disable');
			if(opts.onLoadSuccess) opts.onLoadSuccess.call(this,data);
		},
		onClickRow:function(rowIndex,rowData){
			if (currEditIndex==-1) $("#"+key+"EditBtn").linkbutton('enable');
			$("#"+key+"DelBtn").linkbutton('enable');
			if(opts.onClickRow) opts.onClickRow.call(this,rowIndex,rowData);
		},
		onDblClickRow:function(rowIndex,rowData){
			$("#"+key+'CancelBtn').trigger('click');
			$("#"+key+'EditBtn').trigger('click');
			if(opts.onDblClickRow) opts.onDblClickRow.call(this,rowIndex,rowData);
		},
		onSelect:opts.onSelect,
		onBeforeLoad:opts.onBeforeLoad
	});
	return gridId;
};

(function ($){
	$.fn.mgrid = function(opts){
		//var currEditIndex = -1;
		var gridId = this[0].id; //key+"Grid";
		var key = gridId;
		var cn = opts.className;
		var codeField = opts.codeField||"Code";
		opts = $.extend(true,{
			activeColName:'Active',
			getReq : {ClassName:cn,QueryName:"Find"}
		},$.fn.mgrid.defaults,opts);
		if (opts.editGrid){
			opts = $.extend(true,{
				insReq : {ClassName:cn,MethodName:"Insert","dto.gridId":gridId},
				saveReq: {hidden:false},
				updReq : {ClassName:cn,MethodName:"Update","dto.gridId":gridId},
				delReq : {ClassName:cn,MethodName:"Del","dto.gridId":gridId}
			},opts);
			$(document.body).keydown(function(e){
				if (e.key=="Escape"){
					$("#"+key+'CancelBtn').trigger('click');
				}
			});
			var _toolbar=[];
			if (opts.beforeToolbar) _toolbar=opts.beforeToolbar;
			if (!opts.insReq.hidden){
				_toolbar.push({id:key+'AddBtn',iconCls:'icon-add',text:opts.addBtnText||'新增',handler:function(){
					if ($('#'+gridId).datagrid('options').currEditIndex>-1){
						$.messager.popover({msg:'有正在编辑的项目',type:'info'});
						return ;
					}
					if ($('#'+gridId).datagrid('options').currEditIndex === -1) {
						var row = $('#'+gridId).datagrid("getRows");
						var newRecord = opts.getNewRecord();
						if (newRecord!==false){
							var lastInd = row.length;
							$("#"+gridId).datagrid('insertRow', {index : lastInd, row : newRecord} );
							$("#"+gridId).datagrid('beginEdit', lastInd);	
							var inputObj = $("#"+gridId).datagrid('getPanel').find('.datagrid-row-editing input');
							$.each(inputObj,function(index,item){
								var _t = $(this);
								if (!_t.prop('disabled') && _t.css('display')!='none'){
									_t.focus();
									return false;
								}
							});
						}
		            }
				}});
			}
			if (!opts.updReq.hidden){
				_toolbar.push({
					id:key+'EditBtn',iconCls:'icon-write-order',text:opts.editBtnText||'修改',handler:function(){
					if ($('#'+gridId).datagrid('options').currEditIndex==-1){
						//var gridId = $(this).closest(".datagrid").find('table.datagrid-f').attr('id');
						//if (gridId!=""){
						var grid = $('#'+gridId);
						var curInd = grid.datagrid('getRowIndex',grid.datagrid('getSelected'));
						grid.datagrid('beginEdit',curInd);
						if ('string'==typeof codeField){
							var ed2 = grid.datagrid('getEditor', { 'index': curInd, field: codeField });
							if (ed2){
								$(ed2.target).attr("disabled", true);
								if ($(ed2.target).hasClass('combo-f')){
									$(ed2.target).combobox('disable');
								}
							}
						}else{
							for(var cf=0; cf<codeField.length; cf++){
								var ed2 = grid.datagrid('getEditor', { 'index': curInd, field: codeField[cf] });
								if (ed2){
									$(ed2.target).attr("disabled", true);
									if ($(ed2.target).hasClass('combo-f')){
										$(ed2.target).combobox('disable');
									}
								}
							}
						}
						$('#'+gridId).datagrid('options').currEditIndex = curInd;
						var inputObj = $("#"+gridId).datagrid('getPanel').find('.datagrid-row-editing input');
						$.each(inputObj,function(index,item){
							var _t = $(this);
							if (!_t.prop('disabled') && _t.css('display')!='none'){
								_t.focus();
								return false;
							}
						});
						//}
					}
				}});
			}
			if (!opts.saveReq.hidden){
				_toolbar.push({
					id:key+'SaveBtn',iconCls:'icon-save',text:opts.saveBtnText||'保存',handler:function(){
					var currEditIndex = $('#'+gridId).datagrid('options').currEditIndex;
					if (currEditIndex>-1){
						var oriEditIndex = currEditIndex;
						var gridJObj = $('#'+gridId);
						gridJObj.datagrid('endEdit',currEditIndex); //acceptChanges
						var row = gridJObj.datagrid("getChanges"); //完成编辑后才能取到getChanges
						if (row.length>0){
							if ('string'==typeof codeField){
								if ("undefind"!=typeof row[0][codeField] && row[0][codeField]==""){
									$.messager.popover({msg:'代码不能为空',type:'info'});
									gridJObj.datagrid('beginEdit',oriEditIndex);
									return ; 
								}
							}else{
								for(var cf=0; cf<codeField.length; cf++){
									if ("undefind"!=typeof row[0][codeField[cf]] && row[0][codeField[cf]]==""){
										$.messager.popover({msg:'代码类属性不能为空',type:'info'});
										gridJObj.datagrid('beginEdit',oriEditIndex);
										return ; 
									}
								}
							}
							if ("undefind"!=typeof row[0].Description && row[0].Description==""){
								$.messager.popover({msg:'描述不能为空',type:'info'}); 
								gridJObj.datagrid('beginEdit',oriEditIndex);
								return ; 
							}
							opts.insOrUpdHandler(row[0],function(flag,msg,data){
									if (flag){
										gridJObj.datagrid('load');
										$.messager.popover({msg:msg||'成功',type:'success'});
									}else{
										$.messager.popover({msg:msg||'失败',type:'error'});
										gridJObj.datagrid('beginEdit',oriEditIndex);
										return ; 
									}
							});
						}else{
							gridJObj.datagrid('endEdit',currEditIndex); //acceptChanges
						}
					}
				}});
			}
			if (!opts.delReq.hidden){
				_toolbar.push({
					id:key+'DelBtn',iconCls:'icon-cancel',text:opts.delBtnText||'删除',handler:function(){
					var row = $('#'+gridId).datagrid('getSelected');
					if (row.ID=="") return;
					opts.delHandler(row);
					
				}});
			}
			_toolbar.push({
				id:key+'CancelBtn',iconCls:'icon-undo',text:opts.cancelBtnText||'撤销',handler:function(){
				var currEditIndex = $('#'+gridId).datagrid('options').currEditIndex;
				if (currEditIndex>-1) {
					var row = $('#'+gridId).datagrid('getRows')[currEditIndex];
					if (("undefined"==typeof row.ID && typeof codeField=="string" && row[codeField]=="")){
						$('#'+gridId).datagrid('deleteRow',currEditIndex);
					}else if(row.ID=="") {
						$('#'+gridId).datagrid('deleteRow',currEditIndex);
					}else{
						$('#'+gridId).datagrid('cancelEdit',currEditIndex);
					}
				}
			}});
			if (opts.afterToolbar && opts.afterToolbar instanceof Array ) {
				for(var a=0;a<opts.afterToolbar.length;a++){
					_toolbar.push(opts.afterToolbar[a]);
				}
				
			}

			opts.onOriginLoadSuccess = opts.onLoadSuccess||null;
			opts.onOriginClickRow = opts.onClickRow||null;
			opts.onOriginDblClickRow = opts.onDblClickRow||null;
			$.extend(opts,{
				toolbar:_toolbar,
				onBeforeEdit:function(rowIndex,rowData){
					$('#'+gridId).datagrid('options').currEditIndex = rowIndex;
					$("#"+key+"SaveBtn").linkbutton('enable');
					$("#"+key+"EditBtn").linkbutton('disable');
					$("#"+key+"AddBtn").linkbutton('disable');
					$("#"+key+"DelBtn").linkbutton('disable');
					$("#"+key+"CancelBtn").linkbutton('enable');
					$("#"+gridId).datagrid('selectRow', rowIndex);
				},
				onAfterEdit:function(rowIndex,rowData,changes){
					$('#'+gridId).datagrid('options').currEditIndex=-1;	
					$("#"+key+"AddBtn").linkbutton('enable');
					$("#"+key+"EditBtn").linkbutton('enable');
					$("#"+key+"DelBtn").linkbutton('enable');
					$("#"+key+"SaveBtn").linkbutton('disable');
					$("#"+key+"CancelBtn").linkbutton('disable');
				},
				onCancelEdit:function(){
					$('#'+gridId).datagrid('options').currEditIndex=-1;
					var selRow = $(this).datagrid('getSelected');
					if (selRow["ID"]==""){ //增加空行后-cancel
						$("#"+key+"DelBtn").linkbutton('disable');
						$("#"+key+"EditBtn").linkbutton('disable');
					}else{
						$("#"+key+"EditBtn").linkbutton('enable');
						$("#"+key+"DelBtn").linkbutton('enable');
					}
					$("#"+key+"AddBtn").linkbutton('enable');
					$("#"+key+"SaveBtn").linkbutton('disable');
					$("#"+key+"CancelBtn").linkbutton('disable');
				},
				onLoadSuccess:function(data){
					$('#'+gridId).datagrid('options').currEditIndex=-1;
					$("#"+key+"AddBtn").linkbutton('enable');
					$("#"+key+"EditBtn").linkbutton('disable');
					$("#"+key+"DelBtn").linkbutton('disable');
					$("#"+key+"SaveBtn").linkbutton('disable');
					$("#"+key+"CancelBtn").linkbutton('disable');
					if(opts.onOriginLoadSuccess) opts.onOriginLoadSuccess.call(this,data);
				},
				onClickRow:function(rowIndex,rowData){
					var currEditIndex = $('#'+gridId).datagrid('options').currEditIndex;					
					if (rowIndex!==currEditIndex){
						if (currEditIndex==-1) $("#"+key+"EditBtn").linkbutton('enable');
						$("#"+key+"DelBtn").linkbutton('enable');
						
					}
					if(opts.onOriginClickRow) opts.onOriginClickRow.call(this,rowIndex,rowData);
				},
				onDblClickRow:function(rowIndex,rowData){
					if (rowIndex!==$('#'+gridId).datagrid('options').currEditIndex){
						$("#"+key+'CancelBtn').trigger('click');
						$("#"+key+'EditBtn').trigger('click');
					}
					if(opts.onOriginDblClickRow) opts.onOriginDblClickRow.call(this,rowIndex,rowData);
				}
			});
		}		
		var originRowStyler = opts.rowStyler||null;
		$.extend(opts,{
			//title:opts.title,
			queryParams:opts.getReq,
			//columns:opts.columns,			
			rowStyler: function(index,row){
				if (row[opts.activeColName]=="N" || row[opts.activeColName]=="0"){return 'color:#ccc;';}
				if (originRowStyler){ return originRowStyler.call(this,index,row);}
			}
		});
		this.datagrid(opts);
	};
	$.fn.mgrid.methods = {};
	//$.fn.mgrid.parseOptions = function(){};
	$.fn.mgrid.defaults = $.extend({},$.fn.datagrid.defaults,{
		editGrid:false,
		currEditIndex:-1, /*当前编辑行*/
		headerCls:'panel-header-gray',
		bodyCls:'panel-body-gray',
		rownumbers:true,singleSelect:true,fit:true,pagination:true,showPageList:false,pageSize:50,
		fitColumns:true,showChangedStyle:false,border:true,iconCls:'icon-paper',url:$URL,
		className:"",
		columnModelFieldJson:"",
		activeColName:'Active' /*行激活标志列*/
	});
})(jQuery);