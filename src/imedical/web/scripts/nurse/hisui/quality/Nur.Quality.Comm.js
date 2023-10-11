var LINK_CSP="dhc.nurse.ip.common.getdata.csp";
//��ǰ����
var editIndex = undefined;
/**
 * �����к�̨����
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص����� 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : buildMWTokenUrl(LINK_CSP),
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
 * ����datagrid����
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param gridid datagrid��id
 * @param handle �ص�����
 * @param ����ֵ����
 * saveByDataGrid("web.DHCAPPPart","find","#datagrid",function(data){ alert() },"json")	 
 */
function saveByDataGrid(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
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

// ��Date����չ���� Date ת��Ϊָ����ʽ��String   
// ��(M)����(d)��Сʱ(h)����(m)����(s)������(q) ������ 1-2 ��ռλ����   
// ��(y)������ 1-4 ��ռλ��������(S)ֻ���� 1 ��ռλ��(�� 1-3 λ������)   
// ���ӣ�   
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423   
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18   
Date.prototype.Format = function(fmt)   
{ //author: meizz   
  var o = {   
    "M+" : this.getMonth()+1,                 //�·�   
    "d+" : this.getDate(),                    //��   
    "h+" : this.getHours(),                   //Сʱ   
    "m+" : this.getMinutes(),                 //��   
    "s+" : this.getSeconds(),                 //��   
    "q+" : Math.floor((this.getMonth()+3)/3), //����   
    "S"  : this.getMilliseconds()             //����   
  };   
  if(/(y+)/.test(fmt))   
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  for(var k in o)   
    if(new RegExp("("+ k +")").test(fmt))   
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
  return fmt;   
}

//��ȡ����ǰ����������
Date.prototype.before = function(num)   
{ 
	this.setTime(this.getTime()-(num*24*60*60*1000));
	return this
}


//��ȡ����ǰ����������
Date.prototype.after = function(num)   
{ 
	this.setTime(this.getTime()+(num*24*60*60*1000));
	return this
}


var floatObj = function() {
     
    /*
     * �ж�obj�Ƿ�Ϊһ������
     */
    function isInteger(obj) {
        return Math.floor(obj) === obj
    }
     
    /*
     * ��һ��������ת�����������������ͱ������� 3.14 >> 314�������� 100
     * @param floatNum {number} С��
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
     * ���ķ�����ʵ�ּӼ��˳����㣬ȷ������ʧ����
     * ˼·����С���Ŵ�Ϊ�������ˣ��������������㣬����СΪС��������
     *
     * @param a {number} ������1
     * @param b {number} ������2
     * @param digits {number} ���ȣ�������С������������ 2, ������Ϊ��λС��
     * @param op {string} �������ͣ��мӼ��˳���add/subtract/multiply/divide��
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
                if (t1 === t2) { // ����С��λ����ͬ
                    result = n1 + n2
                } else if (t1 > t2) { // o1 С��λ ���� o2
                    result = n1 + n2 * (t1 / t2)
                } else { // o1 С��λ С�� o2
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
     
    // �Ӽ��˳����ĸ��ӿ�
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
 * @description ��֤�Ƿ�Ϊ��
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
                message('error', labelItem.text() + " ����Ϊ��!")
                return flag
            }
        }
    })
    return flag
}

/**
 * @description ���õ����ֵ
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
 * @description ��ȡ�����ֵ
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
  * ������Ϣ��
  * @param {*} type 
  * @param {*} msg 
  */
 function message(type, msg)
 {
    $.messager.popover({msg: msg ,type:type ,timeout: 1000});
 }


 function delConfirm(callback)
 {
    $.messager.confirm("ɾ��", "ȷ��Ҫɾ��?", function (r) {
        if (r) {
           callback()
        }
    });

 }
/**
 * @description: token���췽��
 * @return {bool} true/false
 */
function buildMWTokenUrl(url){
	if (typeof websys_getMWToken != 'undefined'){
		if (url.indexOf('?') == -1){
			url = url + '?MWToken=' + websys_getMWToken();
		} else {
			url = url + "&MWToken=" + websys_getMWToken();
		}
	}
	return url;
}