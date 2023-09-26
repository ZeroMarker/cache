var LINK_CSP="dhcapp.broker.csp";
//当前索引
var editIndex = undefined;
/**
 * 简单运行后台方法
 * @creater zhouxin
 * @param className 类名称
 * @param methodName 方法名
 * @param datas 参数{}
 * @param 回调函数
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}

/**
 * 保存datagrid数据
 * @creater zhouxin
 * @param className 类名称
 * @param methodName 方法名
 * @param gridid datagrid的id
 * @param handle 回调函数
 * @param 返回值类型
 * saveByDataGrid("web.DHCAPPPart","find","#datagrid",function(data){ alert() },"json")	 
 */
function saveByDataGrid(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");

	runClassMethod(className,methodName,{'params':params},handle,datatype)
}

//判断grid是否编辑完成
function endEditing(datagridid){
	if (editIndex == undefined){return true}
	if ($(datagridid).datagrid('validateRow', editIndex)){
		$(datagridid).datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		$(datagridid).datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
		return false;
	}
}
//编辑行事件
function CommonRowClick(index,row,datagridid){
	//if (editIndex != index){  //hxy
		if (endEditing(datagridid)){
			$(datagridid).datagrid('selectRow', index).datagrid('beginEdit', index)
			editIndex = index;
		} else {
			$(datagridid).datagrid('selectRow', editIndex);
		}
	//}   //hxy
}
/**
 * 公共查询方法
 * @creater zhouxin
 * @param _options.formid  查询条件form的id
 * @param _options.datagrid 查询的datagrid的id
 * commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})	 
 */
function commonQuery(_options){
	$(_options.datagrid).datagrid('load',loopBlock(_options.formid));
}
/**
 * 公用重置方法
 * @creater zhouxin
 * @param _options.formid  查询条件form的id
 * @param _options.datagrid 查询的datagrid的id
 * commonReload({'datagrid':'#datagrid','formid':'#queryForm'})	 
 */
function commonReload(_options){
	$(_options.formid).form("clear");
	$(_options.datagrid).datagrid('load',loopBlock(_options.formid));
}

var serverCall=function(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText;
}
/**
 * 公用插入一行的方法
 * @creater zhouxin
 * @param _options.datagrid  插入datagrid的id
 * @param _options.value  新插入行的默认值
 */
function commonAddRow(_options){
	
	if(endEditing(_options.datagrid)){
		value=$.extend({},_options.value);
		$(_options.datagrid).datagrid('insertRow',{index:0, row: value}).datagrid('beginEdit', 0);
		$(_options.datagrid).datagrid('selectRow', 0);//hxy
		editIndex=0;
	}
}
/**
 * 拼装form表单中所有参数成为json串
 * @creater zhouxin
 * @param container  查询form的id
 */
function loopBlock(container){
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
			ipts = jQuery("input["+cTypes[i]+"name]", target);
			if(ipts.length){
				ipts.each(function(){
					var name = jQuery(this).attr(cTypes[i]+'Name');
					if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
						return true;
					}
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
				if(skipDisabled && $(this).next('.ms2side__div').find(':disabled').length) {
					return true;
				}
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this)['multiselect2side']('getValue');
				extendJSON(name, val);
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
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
			var newObj = eval('({"'+name+'":'+jQuery.toJSON(val)+'})');
			jQuery.extend(attrs, newObj);
		}
		return attrs;
	};	


// 对Date的扩展，将 Date 转化为指定格式的String   
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，   
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)   
// 例子：   
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423   
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18   
Date.prototype.Format = function(fmt)   
{ //author: meizz   
  var o = {   
    "M+" : this.getMonth()+1,                 //月份   
    "d+" : this.getDate(),                    //日   
    "h+" : this.getHours(),                   //小时   
    "m+" : this.getMinutes(),                 //分   
    "s+" : this.getSeconds(),                 //秒   
    "q+" : Math.floor((this.getMonth()+3)/3), //季度   
    "S"  : this.getMilliseconds()             //毫秒   
  };   
  if(/(y+)/.test(fmt))   
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  for(var k in o)   
    if(new RegExp("("+ k +")").test(fmt))   
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
  return fmt;   
}



/**
 * 
 * @creater zhouxin
 * @func getFieldPos  获取当前光标位置
 * @func insertPos   在制定位置插入文本
 */
$(function(){
    /*
     * 文本域光标操作
     */
    $.fn.extend({
        /*
         * 获取光标所在位置
         */
        getFieldPos:function(){
            var field=this.get(0);
            if(document.selection){
                //IE
                $(this).focus();
                var sel=document.selection;
                var range=sel.createRange();
                var dupRange=range.duplicate();
                dupRange.moveToElementText(field);
                dupRange.setEndPoint('EndToEnd',range);
                field.selectionStart=dupRange.text.length-range.text.length;
                field.selectionEnd=field.selectionStart+ range.text.length;
            }
            return field.selectionStart;
        },
        insertPos:function(pos,value){
	        s=$(this).val()
        	$(this).val(s.substring(0, pos)+value+s.substring(pos))
        }
    })
 }) 