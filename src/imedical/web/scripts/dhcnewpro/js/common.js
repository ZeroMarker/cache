var LINK_CSP="dhcapp.broker.csp";
//当前索引
var editIndex = undefined;
/**
 * 简单运行后台方法:HISUI中有调用后台的方法如果使用了HISUI这里的方法要去掉
 * @creater zhouxin
 * @param className 类名称
 * @param methodName 方法名
 * @param datas 参数{}
 * @param 回调函数
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
if(!(typeof $.cm=="function")){
	runClassMethod=function (className,methodName,datas,successHandler,datatype,sync){
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
	
	serverCall=function(className,methodName,datas){
		ret=runClassMethod(className,methodName,datas,function(){},"",false)
		return ret.responseText;
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
function saveByDataGrid(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("提示","请编辑必填数据!","warning");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
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
	//alert(params)
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

function loopStr(container){
		var ret=new Array()
		var target = $(container);
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = $.trim(jQuery(this).val());
				var type=jQuery(this).attr('type')
				if(val.length>0){
	
					if((type=="input")&&(jQuery(this).is(":visible"))){
						ret.push(name+":"+val);
					}
					if((type=="textarea")&&(jQuery(this).is(":visible"))){
						ret.push(name+":"+val);
					}
				}
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = jQuery(this).val();
				ret.push(name+":"+val);
			});
		}
		
		// combo&datebox
		/**
		$(".combo-value").each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			if(val.length>0){
				ret.push(name+":"+val);
			}
		})
		*/
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboname]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboname');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							var val = jQuery(this)[type]('getValues');
							val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val);
							}
						} else {
							var val = jQuery(this)[type]('getValue');
							val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val);
							}
						}
						break;
					}
				}
			});
		}
	
		
		// radio
		var ipts = jQuery("input[name][type=radio]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				
				if((jQuery(this).attr("data-type")==undefined)||("radio-input"==jQuery(this).attr("data-type"))){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							//ret.push(iptsNames[i]+":"+jQuery(this).val());
							ret.push(jQuery(this).attr("data-id")+":"+jQuery(this).val());
							return false;
						}
					});
			
			}
		}
		//checkbox
		var ipts = jQuery("input[name][type=checkbox]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				if(jQuery(this).attr("data-type")==undefined){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
						}
					});
					ret.push(iptsNames[i]+":"+vals.join(","));
				
			}
		}
		if(typeof($("#picPath").val()) != "undefined"){
			if($("#picPath").val().length>0){
				ret.push($("#picPath").attr('name')+":"+$("#picPath").val());
			}
		}
		return ret.join("^");	
}
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
 
 ///帅哥给的乘加js方法 2016-12-01 huaxiaoying
//说明：javascript的乘法结果会有误差，在两个浮点数相乘的时候会比较明显。这个函数返回较为精确的乘法结果。 
//调用：accMul(arg1,arg2) 
//返回值：arg1乘以arg2的精确结果 
function accMul(arg1,arg2) 
{ 
	var m=0,s1=arg1.toString(),s2=arg2.toString(); 
	try{m+=s1.split(".")[1].length}catch(e){} 
	try{m+=s2.split(".")[1].length}catch(e){} 
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m) 
} 
//给Number类型增加一个mul方法，调用起来更加方便。 
Number.prototype.mul = function (arg){ 
	return accMul(arg, this); 
} 

//除法 
//Js代码 
//说明：javascript的除法结果会有误差，在两个浮点数相除的时候会比较明显。这个函数返回较为精确的除法结果。 
//调用：accDiv(arg1,arg2) 
//返回值：arg1除以arg2的精确结果 
function accDiv(arg1,arg2){
	var t1=0,t2=0,r1,r2; 
	try{t1=arg1.toString().split(".")[1].length}catch(e){}
	try{t2=arg2.toString().split(".")[1].length}catch(e){}

	with(Math){
//		r1=Number(arg1.toString().replace(".","")) 
//		r2=Number(arg2.toString().replace(".",""))
//		return (r1/r2)*pow(10,t2-t1);
		//var m=pow(10,max(t1,t2));
		var m=pow(10,t1+t2);
		r1=Number(arg1)*m;
		r2=Number(arg2)*m;
		return r1/r2;
	} 
}
//给Number类型增加一个div方法，调用起来更加方便。 
Number.prototype.div = function (arg){
	return accDiv(this, arg); 
}

//加法函数，用来得到精确的加法结果
//说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
//调用：accAdd(arg1,arg2)
//返回值：arg1加上arg2的精确结果
function accAdd(arg1,arg2){
    var r1,r2,m;
    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
    //m=Math.pow(10,Math.max(r1,r2))
    m=Math.pow(10,r1+r2)
    return (arg1*m+arg2*m)/m
}

//给Number类型增加一个add方法，调用起来更加方便。
Number.prototype.add = function (arg){
    return accAdd(arg,this);
}

/// 获取多少天之后的某一天
function GetDateAfter(curr_Date,t,flag){
	if(flag=="+"){
		curr_Date.setDate(curr_Date.getDate() + parseInt(t));
	}else if(flag=="-"){
		curr_Date.setDate(curr_Date.getDate() - parseInt(t));	
	}else{
		curr_Date=new Date();	
	}
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}
 
/// 格式化日期  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

function ajaxLoading(){   
    $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});   
 }   
 function ajaxLoadEnd(){   
     $(".datagrid-mask").remove();   
     $(".datagrid-mask-msg").remove();               
}
/**
* @datagrid中是否标记
* @param 	value 	 	|string 	|值
*						Y:是
*						N:否   
* @author zhouxin
*/
function FormatterYN(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>是</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>否</font>"
  }else{
    return "";
  }
}

/**
 * 保存或者更新表通用方法
 * @creater zhouxin
 * @param entity 			|类名称：User.DHCPueEmrTypeCon
 * @param parStr            |参数串：字段名称_$c(1)_值
 *                                   多个字段值用$c(2)分隔
 *                                   多条记录用$c(3)分隔
 * @param saveType          |保存类型： 
 *                                   1:更新全部字段，未传入的字典更新为空
 *                                   2:更新传入字段，未传入的字典不更新 
 * @param successHandler    |回调函数
 *
 * @demo  saveEntity("User.DHCPueEmrTypeCon","ID$c(1)1",function(data){ alert() })	 
 */
function saveEntity(entity,parStr,saveType,handler){
	var type=(typeof(saveType) == undefined)?1:saveType;
	var fun;
	if((typeof handler)=='function'){
		fun=handler
	}else{
		fun=function(data){
			if(data==0){
				$.messager.alert('提示','保存成功');
			}else{
				$.messager.alert('提示','保存失败:'+data)
			}
		};	
	}
	runClassMethod("web.DHCPUEEmrTypeCon","Save",{'entity':entity,'params':parStr,'saveType':type},fun)	 
}
/**
 * 删除datagrid记录通用方法
 * @creater zhouxin
 * @param entity 			|类名称：User.DHCPueEmrTypeCon
 * @param gridid            |gridid：datagrid的id
 *
 * @demo  removeCom("User.DHCPueEmrTypeCon","1^2")	 
 */
function removeCom(entity,gridid){
	var rowsData = $(gridid).datagrid('getSelections')
	if (rowsData == null) {
		$.messager.alert("提示","请选择!");
		return;	
	}
	var idsArr=[]
	for(var i=0; i<rowsData.length; i++){
		idsArr.push(rowsData[i].ID);
	}
	removeEntity(entity,idsArr.join("^"),function(){$(gridid).datagrid('reload')});
}
/**
 * 删除表记录通用方法
 * @creater zhouxin
 * @param entity 			|类名称：User.DHCPueEmrTypeCon
 * @param parStr            |参数串：id1_^_id2
 * @param successHandler    |回调函数
 *
 * @demo  removeEntity("User.DHCPueEmrTypeCon","1^2")	 
 */
function removeEntity(entity,idStr,handler){
	$.messager.confirm("操作提示", "确认要删除吗？", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVModel",
				    "removeBath",
					{
		 				'idStr':idStr,
		 				'entity':entity
		 			},
		 			function(data){
			 			if(data.code!=0){
				 			$.messager.alert("提示","操作失败!"+data.msg);
				 		}else{
					 		if((typeof handler)=='function'){
								handler();
							} 
					 	}
					});
            } 
    }); 
}




/**  
 * layout方法扩展   隐藏和显示layout布局  调用方式：$("#id").layout("show","west"); $("#id").layout("hidden","west")
 * @param {Object} jq  
 * @param {Object} region  
 */  
$.extend($.fn.layout.methods, {   
    /**  
     * 面板是否存在和可见  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    isVisible: function(jq, params) {   
        var panels = $.data(jq[0], 'layout').panels;   
        var pp = panels[params];   
        if(!pp) {   
            return false;   
        }   
        if(pp.length) {   
            return pp.panel('panel').is(':visible');   
        } else {   
            return false;   
        }   
    },   
    /**  
     * 隐藏除某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    hidden: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            if(!opts.regionState){   
                opts.regionState = {};   
            }   
            var region = params;   
            function hide(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if($(dom).layout('isVisible', expand)) {   
                        opts.regionState[region] = 1;   
                        panels[expand].panel('close');   
                    } else if($(dom).layout('isVisible', region)) {   
                        opts.regionState[region] = 0;   
                        panels[region].panel('close');   
                    }   
                } else {   
                    panels[region].panel('close');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                hide(this,'east',false);   
                hide(this,'north',false);   
                hide(this,'west',false);   
                hide(this,'south',true);   
            }else{   
                hide(this,region,true);   
            }   
        });   
    },   
    /**  
     * 显示某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    show: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            var region = params;   
  
            function show(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if(!$(dom).layout('isVisible', expand)) {   
                        if(!$(dom).layout('isVisible', region)) {   
                            if(opts.regionState[region] == 1) {   
                                panels[expand].panel('open');   
                            } else {   
                                panels[region].panel('open');   
                            }   
                        }   
                    }   
                } else {   
                    panels[region].panel('open');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                show(this,'east',false);   
                show(this,'north',false);   
                show(this,'west',false);   
                show(this,'south',true);   
            }else{   
                show(this,region,true);   
            }   
        });   
    }   
}); 
 