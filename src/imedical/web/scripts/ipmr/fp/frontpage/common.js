/**
 * common 编目公共组件
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);
/**
 * 创建非诊断手术编目数据项字典下拉
 * @param {void} 
 * @return {void}
 */
function cbgToCodeItemDic(){
	var ItemCode	= arguments[0];
	var ItemCat		= arguments[1];
	var IsShowCode	= arguments[2];
	var HospID		= arguments[3];
	var LinkCmp	    = arguments[4];
	if (typeof(ItemCode)=='undefined') ItemCode='';
	if (typeof(ItemCat)=='undefined') ItemCat='';
	if (typeof(IsShowCode)=='undefined') IsShowCode='';
	if (typeof(HospID)=='undefined') HospID='';
	if (typeof(LinkCmp)=='undefined') LinkCmp='';
	var textField = 'Desc';
	if (IsShowCode=='1') {
		textField = 'Code';
	}
	var ShowTPDesc = '';
	if((ItemCode=='P01058')||(ItemCode=='P01059')||(ItemCode=='P01060')||(ItemCode=='P01061')
		||(ItemCode=='P01062')||(ItemCode=='P01063')||(ItemCode=='P01064')||(ItemCode=='P01067')||(ItemCode=='P01068')){
		ShowTPDesc = 1;
	}
	var cbox = $HUI.combogrid("#"+ItemCode, {
		url: $URL,
		panelWidth:400,
		panelHeight:250,
		editable: true,
		defaultFilter:4, 
		idField:'Code',
		textField: textField,
		method:'Post',
		mode:'remote',
		multiple: false,
		enterNullValueClear:false,
		fitColumns:true,
		hasDownArrow:false,
		pageSize: 1000,
		delay:200,
		columns:[[
		    {field:'Code',title:'代码',width:50},
		    {field:'Desc',title:'描述',width:200},
		    {field:'CPTDesc',title:'医护人员类型',width:100,hidden:ShowTPDesc=='1'?false:true}
		   ]],
		queryParams:{
		    ClassName:'MA.IPMR.FPS.DataMasterSrv',
			QueryName:'QryDic',
			aDataItemCat:ItemCat,
			aHospID:HospID,
			aAlias:'',
			aLinkValue:getCmpId(LinkCmp),
			rows:1000
		},
		onClickRow:function(rowIndex, rowData){
			var record = rowData;
			var code = record.Code;
			var id   = record.ID;
			var text = record.Desc;
			updatedata(ItemCode,id,code,text);
		},
		keyHandler: {
			enter: function (e) {
				var pClosed = $(this).combogrid("panel").panel("options").closed;
				if (!pClosed) {
					$(this).combogrid("hidePanel");
					var record = $(this).combogrid("grid").datagrid("getSelected");
					if (record==null) {
						var id   = '';
						var code = '';
						var text = '';
					}else{
						var id   = record.ID;
						var code = record.Code;
						var text = record.Desc;
					}
					updatedata($(this).attr('id'),id,code,text);
				}
				onEnter($(this))
			},
			up: function (e) {
				navcbg(this,'prev');
				e.preventDefault();
			},
			down: function (e) {
				navcbg(this,'next');
				e.preventDefault();
			},
			query: function (q) {
				var queryParams=$(this).combogrid('options').queryParams;
				$(this).combogrid("grid").datagrid('load', {
					ClassName:queryParams.ClassName,
					QueryName:queryParams.QueryName,
					aDataItemCat:queryParams.aDataItemCat,
					aHospID:queryParams.aHospID,
					aAlias:q,
					aLinkValue:getCmpId(LinkCmp)
				});
				$(this).combogrid("setValue",q);
			}
		}
	});
	return  cbox;
}

 /**
 * 批量改变组件背景颜色
 * @param {data} 多个组件数据json
 * @return {void}
 */
function Changebgcolr(data)
{
	for(var i in data){
		var itemData = data[i];
		changeCmpBgColor(itemData);
	}
}

/**
 * 改变指定组件背景颜色
 * @param {data} 组件的josn数据
 * @return {void}
 */
function changeCmpBgColor(data)
{
	if (checkcmp(data)) {
		Background_color_normal(data.itemCode);
	}else{
		Background_color_tip(data.itemCode);
	}
}

/**
 * 校验组件数据
 * @param {data} 组件data
 * @return {Boolean} True 正常, false 异常
 */
 function checkcmp(data) {
 	var id= data.id;
    var code= data.code;
    var text= data.text;
    var dataType= data.dataType;
    var IsNecessaryItem = data.IsNecessaryItem;	//	是否必填项
	var IsItemChar = data.IsItemChar;	//	是否可填写‘-’
	if (dataType=='DIC'){
		if (IsNecessaryItem==1) {
			if (text=='-') {
				if (IsItemChar==1) {
					return true;
				}else{
					return false;
				}
			}else{
				if ((id=='')||(code=='')||(text=='')) {
					return false;
				}else{
					return true;
				}
			}
		}else{
			if (text=='-') {
				if (IsItemChar==1) {
					return true;
				}else{
					return false;
				}
			}else{
				if ((id=='')&&(code=='')&&(text=='')) {
					return true;
				}else{
					if ((id!='')&&(code!='')&&(text!='')) {
						return true;
					}else{
						return false;
					}
				}
			}
		}
	}else{
		if (IsNecessaryItem==1) {
			if (text=='-') {
				if (IsItemChar==1) {
					return true;
				}else{
					return false;
				}
			}else{
				if (text=='') {
					return false;
				}else{
					return true;
				}
			}
		}else{
			if (text=='-') {
				if (IsItemChar==1) {
					return true;
				}else{
					return false;
				}
			}else{
				return true;
			}
		}
	}
 }

/**
 * 组件背景变为提示色
 * @param {id} 组件id
 * @return {void}
 */
 function Background_color_tip(id) {
 	var color = "#FFC1C1"
 	var cmp = $('#'+id);
 	if (cmp.hasClass('textbox')) {
		cmp.css("background-color",color);
	}
	if (cmp.hasClass('combogrid-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
	if (cmp.hasClass('datebox-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
	if (cmp.hasClass('datetimebox-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
 }

 /**
 * 组件背景变为正常色
 * @param {id} 组件id
 * @return {void}
 */
 function Background_color_normal(id) {
 	var color = "#FFFFFF"
 	var cmp = $('#'+id);
 	if (cmp.hasClass('textbox')) {
		cmp.css("background-color",color);
	}
	if (cmp.hasClass('combogrid-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
	if (cmp.hasClass('datebox-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
	if (cmp.hasClass('datetimebox-f')) {
		cmp.next().children(":first").css("background-color",color);
	}
 }

 /**
 * focus 组件
 * @param {arguments[0]} 组件id
 * @return {void}
 */
function focus()
{
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
    if ($this.hasClass('textbox')) {  //文本框
	    $this.focus()
    }
    if ($this.hasClass('combogrid-f')) {  //下拉框（多选下拉框没有封装）
   	   $this.next().children(":first").focus()
    }
}

 /**
 * 设置组件页面显示值
 * @param {cmpid} 组件id
 * @param {value} 显示的值
 * @return {void}
 */
function setText(cmpid,value)
{
	var cmp = $('#'+cmpid);
	if (cmp.hasClass('combogrid-f')) {
		cmp.combobox('setValue',value)
	}else if (cmp.hasClass('datebox-f')) {
		cmp.datebox('setValue',value);
	}else if (cmp.hasClass('datetimebox-f')) {
		cmp.datetimebox('setValue',value);
	}else if (cmp.hasClass('numberbox-f')) {
		cmp.numberbox('setValue',value);
	}else{
		cmp.val(value);
	}
}

/**
 * 下拉框回车动作调用函数
 * @param {target} 选择器
 * @return {void}
 */
function entercbg(target) {
	var state = $.data(target,"combogrid");;
	var opts = state.options;
	var grid = state.grid;
	var panel = $.data(target,"combo").panel;
	if(panel.is(':visible')) {
		var tr = opts.finder.getTr(grid[0],null,"highlight");
		state.remainText = false;
		if(tr.length){
			var _31 = parseInt(tr.attr("datagrid-row-index"));
			if(opts.multiple){
				if(tr.hasClass("datagrid-row-selected")){
					grid.datagrid("unselectRow",_31);
				}
				else{
					grid.datagrid("selectRow",_31);
				}
			}else{
				grid.datagrid("selectRow",_31);
			}
			var vv=[];
			$.map(grid.datagrid("getSelections"),function(row){
				vv.push(row[opts.idField]);
			});
			$(target).combogrid("setValues",vv);
			if(!opts.multiple){
				$(target).combogrid("hidePanel");
				//enterToNext(target);
			}
		}else{
		}
	}else{
		$(target).combogrid("showPanel");
		var q = $(target).combogrid("textbox").val();
		if (state.previousValue != q) {
			state.previousValue = q;
			opts.keyHandler.query.call(target, q);
		}
		$(target).combogrid("validate");
	}
}
/**
 * 下拉框关联检索
 * @param {target} 选择器
 * @param {q} 关键字
 * @param {linkvalue} 关联值
 * @return {void}
 */
function Qrycbglink(target,q,linkvalue,VerID) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		if (typeof(VerID)==undefined) {
			grid.datagrid("load",$.extend({},opts.queryParams,{aAlias:q,aTypeID:linkvalue}));
		}else{
			grid.datagrid("load",$.extend({},opts.queryParams,{aVerID:VerID,aAlias:q,aTypeID:linkvalue}));
		}
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
	//state.remainText = false;
}
/**
 * 下拉框检索
 * @param {target} 选择器
 * @param {q} 关键字
 * @return {void}
 */
function qrycbg(target,q) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	state.remainText = true;
	if(opts.multiple&&!q){
		_1ag(target,[],true);
	}
	else{
		_1ag(target,[q],true);
	}
	if(opts.mode=="remote"){
		grid.datagrid("clearSelections");
		grid.datagrid("load",$.extend({},opts.queryParams,{aAlias:q}));
	}
	else{
		if(!q){
			return;
		}
		grid.datagrid("clearSelections").datagrid("highlightRow",-1);
		var _2b = grid.datagrid("getRows");
		var qq = opts.multiple?q.split(opts.separator):[q];
		$.map(qq,function(q){
			q=$.trim(q);
			if(q){
				$.map(_2b,function(row,i){
					if(q==row[opts.textField]){
						grid.datagrid("selectRow",i);
					}
					else{
						if(opts.filter.call(target,q,row)){
							grid.datagrid("highlightRow",i);
						}
					}
				});
			}
		});
	}
	//state.remainText = false;
}

/**
 * 下拉框上下键导航
 * @param {target} 选择器
 * @param {dir} next or prev
 * @return {void}
 */
function navcbg(target,dir) {
	var state = $.data(target,"combogrid");
	var opts = state.options;
	var grid = state.grid;
	grid.datagrid("unselectAll");
	var _18 = grid.datagrid("getRows").length;
	if (!_18) {
		return;
	}
	var tr = opts.finder.getTr(grid[0],null,"highlight");
	if (!tr.length) {
		tr = opts.finder.getTr(grid[0],null,"selected");
	}
	var _19;
	if (!tr.length) {
		_19 = (dir=="next"?0:_18-1);
	} else {
		var _19 = parseInt(tr.attr("datagrid-row-index"));
		_19 += (dir=="next"?1:-1);
		if (_19 < 0) {
			_19 = _18-1;
		}
		if	(_19 >= _18)	{
			_19 = 0;
		}
	}
	grid.datagrid("highlightRow",_19);
	if(opts.selectOnNavigation){
		state.remainText = false;
		grid.datagrid("selectRow",_19);
	}
}

function _1ag(_1b,_1c,_1d){
	var _1e=$.data(_1b,"combogrid");
	var _1f=_1e.options;
	var _20=_1e.grid;
	var _21=_20.datagrid("getRows");
	var ss=[];
	var _22=$(_1b).combo("getValues");
	var _23=$(_1b).combo("options");
	var _24=_23.onChange;
	_23.onChange=function(){
	};
	_20.datagrid("clearSelections");
	for(var i=0;i<_1c.length;i++){
		var _25=_20.datagrid("getRowIndex",_1c[i]);
		if(_25>=0){
			_20.datagrid("selectRow",_25);
			ss.push(_21[_25][_1f.textField]);
		}else{
			ss.push(_1c[i]);
		}
	}
	$(_1b).combo("setValues",_22);
	_23.onChange=_24;
	$(_1b).combo("setValues",_1c);
	if(!_1d){
		var s=ss.join(_1f.separator);
		if($(_1b).combo("getText")!=s){
			$(_1b).combo("setText",s);
		}
	}
}