var LINK_CSP="dhcapp.broker.csp";
//当前索引
var editIndex = undefined;

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
Date.prototype.addDays = function (d) {
    this.setDate(this.getDate() + d);
};
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
function saveByDataGrid(className,methodName,gridid){
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
	

  $.ajax({
     type: "POST",
     url: LINK_CSP,
     data: {
			'ClassName':className,
			'MethodName':methodName,
			'params':dataList.join("$$")
	 },
     dataType: "json",
     success: function(data){
     		if(data.code==0){
				 $(gridid).datagrid('reload')
			}else{
				$.messager.alert('提示','保存失败:'+data.msg)		
			}
     }
 });
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
//公共删除
function commonRemove(className,methodName,datagridid){
	if(!endEditing(datagridid)){
		$(datagridid).datagrid('reload');
		return;
	}
	if ($(datagridid).datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    	if (r){
	    	var row =$(datagridid).datagrid('getSelected');     
		 	$.ajax({
			     type: "POST",
			     url: LINK_CSP,
			     data: {
						'ClassName':className,
						'MethodName':methodName,
						'ID':row.ID
				 },
				 dataType: "json",
			     success: function(data){
			     		if(data.code==0){
							 $(datagridid).datagrid('reload')
						}else{
							$.messager.alert('提示','保存失败:'+data.msg)		
						}
			     }
			 });
    	}    
	});
}	