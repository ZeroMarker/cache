var LINK_CSP="dhc.nurse.ip.common.getdata.csp";
//当前索引
var editIndex = undefined;
/**
 * 简单运行后台方法
 * @creater zhouxin
 * @param className 类名称
 * @param methodName 方法名
 * @param datas 参数{}
 * @param 回调函数 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'className':className,
				'methodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler).error(successHandler);
}


function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
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
	//alert(params)
	runClassMethod(className,methodName,{'params':params},handle,datatype)
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

//获取几天前或几天后的日期
Date.prototype.before = function(num)   
{ 
	this.setTime(this.getTime()-(num*24*60*60*1000));
	return this
}


//获取几天前或几天后的日期
Date.prototype.after = function(num)   
{ 
	this.setTime(this.getTime()+(num*24*60*60*1000));
	return this
}


var floatObj = function() {
     
    /*
     * 判断obj是否为一个整数
     */
    function isInteger(obj) {
        return Math.floor(obj) === obj
    }
     
    /*
     * 将一个浮点数转成整数，返回整数和倍数。如 3.14 >> 314，倍数是 100
     * @param floatNum {number} 小数
     * @return {object}
     *   {times:100, num: 314}
     */
    function toInteger(floatNum) {
        var ret = {times: 1, num: 0}
        if (isInteger(floatNum)) {
            ret.num = floatNum
            return ret
        }
        var strfi  = floatNum + ''
        var dotPos = strfi.indexOf('.')
        var len    = strfi.substr(dotPos+1).length
        var times  = Math.pow(10, len)
        var intNum = parseInt(floatNum * times + 0.5, 10)
        ret.times  = times
        ret.num    = intNum
        return ret
    }
     
    /*
     * 核心方法，实现加减乘除运算，确保不丢失精度
     * 思路：把小数放大为整数（乘），进行算术运算，再缩小为小数（除）
     *
     * @param a {number} 运算数1
     * @param b {number} 运算数2
     * @param digits {number} 精度，保留的小数点数，比如 2, 即保留为两位小数
     * @param op {string} 运算类型，有加减乘除（add/subtract/multiply/divide）
     *
     */
    function operation(a, b, digits, op) {
        var o1 = toInteger(a)
        var o2 = toInteger(b)
        var n1 = o1.num
        var n2 = o2.num
        var t1 = o1.times
        var t2 = o2.times
        var max = t1 > t2 ? t1 : t2
        var result = null
        switch (op) {
            case 'add':
                if (t1 === t2) { // 两个小数位数相同
                    result = n1 + n2
                } else if (t1 > t2) { // o1 小数位 大于 o2
                    result = n1 + n2 * (t1 / t2)
                } else { // o1 小数位 小于 o2
                    result = n1 * (t2 / t1) + n2
                }
                return result / max
            case 'subtract':
                if (t1 === t2) {
                    result = n1 - n2
                } else if (t1 > t2) {
                    result = n1 - n2 * (t1 / t2)
                } else {
                    result = n1 * (t2 / t1) - n2
                }
                return result / max
            case 'multiply':
                result = (n1 * n2) / (t1 * t2)
                return result
            case 'divide':
                result = (n1 / n2) * (t2 / t1)
                return result
        }
    }
     
    // 加减乘除的四个接口
    function add(a, b, digits) {
        return operation(a, b, digits, 'add')
    }
    function subtract(a, b, digits) {
        return operation(a, b, digits, 'subtract')
    }
    function multiply(a, b, digits) {
        return operation(a, b, digits, 'multiply')
    }
    function divide(a, b, digits) {
        return operation(a, b, digits, 'divide')
    }
     
    // exports
    return {
        add: add,
        subtract: subtract,
        multiply: multiply,
        divide: divide
    }
}();


function filter(q, row) {
    var opts = $(this).combobox('options');
    var text = row[opts.textField];
    var pyjp = getPinyin(text).toLowerCase();
    if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
        return true;
    }
    return false;
}

/**
 * @description 验证是否为空
 * @param {*} id  
 * @returns 
 */
function verification(id){
    var flag = true
    $("#"+ id + " .row-item").each(function(){
        var labelItem = $(this).children(":nth-child(1)")
        if (labelItem.hasClass("label-request"))
        {
            var item = $(this).children(":nth-child(2)")
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
                message('error', labelItem.text() + " 不能为空!")
                return flag
            }
        }
    })
    return flag
}

/**
 * @description 设置弹框的值
 * @param {*} id 
 * @param {*} obj 
 */
function setFormValue(id, obj)
{
    $("#"+ id + " .row-item").each(function(){
        var item = $(this).children(":nth-child(2)")
        var nodeName = item[0].tagName
        switch(nodeName)
        {
            case "INPUT":
                item.val(obj[item.attr("id")])
                break;
            case "SELECT":
                if (item.prop("multiple"))
                {
                    if (obj[item.attr("id")]){
                        item.combobox("setValues",obj[item.attr("id")])
                    }else{
                        item.combobox("setValues",[])
                    }
                }else{
                    item.combobox("setValue",obj[item.attr("id")])
                }
                break;
            default:
                break;
        }
    })
}


/**
 * @description 获取弹框的值
 */
 function getFormValue(id)
 {
     var obj = {}
     $("#"+ id + " .row-item").each(function(){
         var item = $(this).children(":nth-child(2)")
         var nodeName = item[0].tagName
         switch(nodeName)
         {
             case "INPUT":
                 obj[item.attr("id")] = item.val();
                 break;
             case "SELECT":
                 if (item.prop("multiple"))
                 {
                    obj[item.attr("id")] = item.combobox("getValues");       
                 }else{
                    obj[item.attr("id")] = item.combobox("getValue");
                 }
                 break;
             default:
                 break;
         }
     })
     return obj
 }


 /**
  * 弹出消息框
  * @param {*} type 
  * @param {*} msg 
  */
 function message(type, msg)
 {
    $.messager.popover({msg: msg ,type:type ,timeout: 1000});
 }


 function delConfirm(callback)
 {
    $.messager.confirm("删除", "确定要删除?", function (r) {
        if (r) {
           callback()
        }
    });

 }
