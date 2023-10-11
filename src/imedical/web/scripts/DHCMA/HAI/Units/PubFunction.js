/*HISUI公共js*/
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

var urlPath = window.document.location.href;  //浏览器显示地址 https://114.242.246.243:1443/imedical/web/csp/websys.csp?a=a&TMENU=59358&TPAGID=27304090
var docPath = window.document.location.pathname; //文件在服务器相对地址 imedical/web/csp/websys.csp
var index = urlPath.indexOf('/csp/');
var cspPath = urlPath.substring(0, index)+'/csp/dhchai.ir.view.main.csp?';
if ("undefined" !== typeof websys_getMWToken) {
    cspPath+= "MWToken%253D" + websys_getMWToken();
}
cspPath = encodeURIComponent(cspPath); 

//获得当前日期格式配置
var dtformat = $m({                  
	ClassName:"DHCHAI.BT.Config",
	MethodName:"GetValByCode",
	aCode:"CUS-DateLogicalToHtml"
},false);

if (dtformat==0) {
	if ($.fn.datebox){
		$.fn.datebox.defaults.formatter = function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		};
		$.fn.datebox.defaults.parser = function(s){
			if (!s) return new Date();
			var ss = s.split('-');
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		};
	}
}

//日期格式
function GetDateFormat() {
	if (dtformat==0) {
		var DateFormat = 'yyyy-mm-dd';
	}else {
		var DateFormat = $m({                  
			ClassName:"DHCHAI.IO.FromHisSrv",
			MethodName:"GetDateFormat"
		},false);
	}
	return DateFormat;
}

//当期日期 时间
function Common_GetCurrDateTime(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();
	var mm= date.getMinutes();
	var s = date.getSeconds();
	var DateFormat = GetDateFormat();
	if (DateFormat=='yyyy-mm-dd') {	
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}else if (DateFormat=='dd/mm/yyyy') {
		return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y+' '+ h + ":" + mm + ":" + s;
	}else {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}
}
//json排序
function Common_GetSortFun(order,sortBy) {
	var ordAlpah = (order == 'asc') ?'>' : '<';
	var sortFun = new Function('a', 'b', 'return a.'+ sortBy + ordAlpah + 'b.'+ sortBy + '?1:-1');
	return sortFun;
}

//当期日期 
function Common_GetDate(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var DateFormat = GetDateFormat();
	if (DateFormat=='yyyy-mm-dd') {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if (DateFormat=='dd/mm/yyyy') {
		return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;
	}else {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}
}

//时间 myDate.toLocaleTimeString()
function Common_GetTime(date){
	var h = date.getHours();
	var m= date.getMinutes();
	var s = date.getSeconds();
	return h+':'+(m<10?('0'+m):m)+':'+(s<10?('0'+s):s);
}

//获取a天之前或a天之后日期
function Common_GetCalDate(a) {	
	var date1 = new Date();
	time1=date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate();
    var date2 = new Date(date1);
	date2.setDate(date1.getDate() + a);
	
	var year = date2.getFullYear();
	var month = date2.getMonth();
	month++;
	if(month<10) month = '0'+month;
	var day = date2.getDate();
	if(day<10) day = '0'+day;
	
	var DateFormat = GetDateFormat();
	if (DateFormat=='yyyy-mm-dd') {
		return time2 =  year+'-'+month+'-'+day;
	}else if (DateFormat=='dd/mm/yyyy') {
		return time2 = day+'/'+month+'/'+year;
	}else {
		return time2 = year+'-'+month+'-'+day;
	}
}



// 判断日期大小
function  Common_CompareDate(startDate,endDate){
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	var startDate = $m({                  
		ClassName:"DHCHAI.IO.FromHisSrv",
		MethodName:"DateHtmlToLogical",
		aDate:startDate
	},false);
	var endDate = $m({                  
		ClassName:"DHCHAI.IO.FromHisSrv",
		MethodName:"DateHtmlToLogical",
		aDate:endDate
	},false);

	if ((startDate=='')||(endDate=='')){
		return -1;
	}
	if (startDate>endDate){
		return 1;
	}else{
		return 0;
	}
}

//计算两日期的天数差
 function DateDiff(startDate,endDate) {
	if(startDate=="")
	{
		return -1;
	}
	if(endDate=="")
	{
		return -1;
	}
	var oSDate = new Date(parseDate(startDate)); // yyyy-MM-dd
	var oEDate = new Date(parseDate(endDate)); // yyyy-MM-dd  含时间的 在ie中转换会失败 默认成功后加上08:00:00 时区
	iDays  = parseInt(Math.abs(oEDate - oSDate)/1000/60/60/24);   //把相差的毫秒数转换为天数  
    return  iDays  
};


/*     IE8 new Date 问题
 *     根据时间字符串 生成时间对象 
 *     dateStr 时间字符串 yyyy-mm-dd
 */
function parseDate(dateStr) {
    var isoExp = /^\s*(\d{4})-(\d\d)-(\d\d)\s*$/;//正则
    var date = new Date(NaN);
    var parts = isoExp.exec(dateStr);//正则验证
    if(parts) {
        var month = Number(parts[2]);
        //设置时间
        date.setFullYear(parts[1], month - 1, parts[3]);
        //判断是否正确
        if(month != date.getMonth() + 1) {
            date.setTime(NaN);
        }
    }
    return date;
}

// 判断时间超过三个月 true:不超过
function checkThreeTime(startDate,endDate){
	//var time1 = new Date(startDate).getTime();
	//时间格式统一
	var DateFormat = GetDateFormat();
	if (DateFormat=='dd/mm/yyyy') {
		startDate=startDate.replace(/\//g, '').replace(/^(\d{2})(\d{2})(\d{4})$/,"$3-$2-$1")
		endDate=endDate.replace(/\//g, '').replace(/^(\d{2})(\d{2})(\d{4})$/,"$3-$2-$1")
	}
	var arr1 = startDate.split('-');
	var arr2 = endDate.split('-');
	arr1[1] = parseInt(arr1[1]);
	arr1[2] = parseInt(arr1[2]);
	arr2[1] = parseInt(arr2[1]);
	arr2[2] = parseInt(arr2[2]);
	//判断时间跨度是否大于3个月
	var flag = true;
	if(arr1[0] == arr2[0]){//同年
	    if(arr2[1]-arr1[1] > 3){ //月间隔超过3个月
	        flag = false;
	    }else if(arr2[1]-arr1[1] == 3){ //月相隔3个月，比较日
	        if(arr2[2] > arr1[2]){ //结束日期的日大于开始日期的日
	            flag = false;
	        }
	    }
	}else{ //不同年
	    if(arr2[0] - arr1[0] > 1){
	        flag = false;
	    }else if(arr2[0] - arr1[0] == 1){
	        if(arr1[1] < 10){ //开始年的月份小于10时，不需要跨年
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] < 12){ //月相隔大于3个月
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] == 12){ //月相隔3个月，比较日
	            if(arr2[2] > arr1[2]){ //结束日期的日大于开始日期的日
	                flag = false;
	            }
	        }
	    }
	}
	if(!flag){
	    return false;
	}
	return true;
}

//Query下拉字典公共方法(取值是ID)
function Common_ComboDicID() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4,       //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			allowNull: true,
			valueField: 'ID',
			textField: 'DicDesc', 
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			    $("#"+ItemCode).combobox('reload',url);
			}
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1",
			editable: false,       
			defaultFilter:4,
			allowNull: true,    
			valueField: 'ID',
			textField: 'DicDesc'
		});	
	}	
	return;
}

//Query下拉字典公共方法(取值是Code)
function Common_ComboDicCode() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4,       //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			allowNull: true,       //再次点击取消选中
			valueField: 'DicCode',
			textField: 'DicDesc', 
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			    $("#"+ItemCode).combobox('reload',url);
			}
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1",
			editable: false,       
			defaultFilter:4,
			allowNull: true,    
			valueField: 'DicCode',
			textField: 'DicDesc'
		});	
	}	
	return;
}

//可控制显示列 多选字典 显示 obj.StatusList = Common_CheckboxToDic("chkStatusList","Status","");
function Common_CheckboxToDic() {   
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		ResultSetType:'array',
		aTypeCode:DicType,
		aActive:1
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var DicID = objStr[dicIndex].ID;
			var DicDesc = objStr[dicIndex].DicDesc;
		
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+DicID+" type='checkbox' class='hisui-checkbox' label='"+DicDesc+"'  name="+ItemCode+"  value="+DicID+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
	
}
//可控制显示列 单选字典
function Common_RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		ResultSetType:'array',
		aTypeCode:DicType,
		aActive:1
	}, false);

	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var DicID = objStr[dicIndex].ID;
			var DicDesc = objStr[dicIndex].DicDesc;
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+DicID+" type='radio' class='hisui-radio' label="+DicDesc+" name="+ItemCode+" value="+DicID+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}


//可控制显示列 复选框样式的单选字典
function Common_chkRadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		ResultSetType:'array',
		aTypeCode:DicType,
		aActive:1
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;

	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var DicID = objStr[dicIndex].ID;
			var DicDesc = objStr[dicIndex].DicDesc;
			
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+DicID+" type='radio' class='hisui-radio' label="+DicDesc+" name="+ItemCode+" value="+DicID+" data-options=radioClass:'hischeckbox_square-blue'></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}


//多选字典取值 Common_CheckboxValue("chkStatusList")
function Common_CheckboxValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).val()+ ","; 
	});
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}


//多选字典取值(label文字描述) Common_CheckboxText("chkStatusList")
function Common_CheckboxLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).attr("label")+ ","; 
	});
	
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}

//单选字典取值
function Common_RadioValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = $(this).val(); 
	});
	return value;
}
//单选字典取值(label文字描述)
function Common_RadioLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
		  value = $(this).attr("label");
	});
	return value;
}

//文本框输入特殊字符处理
//oninput 是 HTML5 的标准事件，对于检测 textarea, input:text, input:password 和 input:search 这几个元素通过用户界面发生的内容变化非常有用
CheckSpecificKey = function(){ 
	$('input').bind('input propertychange', function() {
		var value = $(this).val();
		var specialKey = "^";       //特殊字符list
		for (var i = 0; i < value.length; i++) {
			var realkey=value.charAt(i);
			if (specialKey.indexOf(realkey) >= 0) {
				$(this).val($(this).val().replace(realkey,""));  //替换特殊字符
				//layer.alert('请勿输入特殊字符: ' + realkey,{icon: 0});
			}
		}
	});
}

/**
*两种调用方式
*var template1="我是{0}，今年{1}了";
*var template2="我是{name}，今年{age}了";
*var result1=template1.format("loogn",22);
*var result2=template2.format({name:"loogn",age:22});
*两个结果都是"我是loogn，今年22了"
*/
String.prototype.format = function (args) {
    var result = this;
    if (arguments.length > 0) {
        if (arguments.length == 1 && typeof (args) == "object") {
            for (var key in args) {
                if (args[key] != undefined) {
                    var reg = new RegExp("({" + key + "})", "g");
                    result = result.replace(reg, args[key]);
                }
            }
        }
        else {
            for (var i = 0; i < arguments.length; i++) {
                if (arguments[i] != undefined) {
                    //var reg = new RegExp("({[" + i + "]})", "g");//这个在索引大于9时会有问题
                    var reg = new RegExp("({)" + i + "(})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
    }
    return result;
};

//add by jiangpengpeng
//IE8下数组不支持IndexOf方法
//添加数组IndexOf方法
if (!Array.prototype.indexOf){
  Array.prototype.indexOf = function(elt /*, from*/){
    var len = this.length >>> 0;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++){
      if (from in this && this[from] === elt)
        return from;
    }
    return -1;
  };
}

//隐藏加载中效果
function dispalyEasyUILoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}
    
//列排序方法(数字、日期类型)
function Sort_int(a,b) {
    if (a.length > b.length) return 1;
    else if (a.length < b.length) return -1;
    else if (a > b) return 1;
    else return -1;
}
//列排序方法(年龄类型)
function Sort_Age(a,b) {
	var aYear=0,aMonth=0,aDay=0
	if(a.indexOf("岁")>=0){aYear=parseInt(a.split("岁")[0]);a=a.split("岁")[1];}
	if(a.indexOf("月")>=0){aMonth=parseInt(a.split("月")[0]);a=a.split("月")[1];}
	if(a.indexOf("天")>=0){aDay=parseInt(a.split("天")[0]);}
	var bYear=0,bMonth=0,bDay=0
	if(b.indexOf("岁")>=0){bYear=parseInt(b.split("岁")[0]);b=b.split("岁")[1];}
	if(b.indexOf("月")>=0){bMonth=parseInt(b.split("月")[0]);b=b.split("月")[1];}
	if(b.indexOf("天")>=0){bDay=parseInt(b.split("天")[0]);}
	
	if(aYear>bYear){
		return 1;
	}
	else if(aYear<bYear){
		return -1;	
	}	
	else{
		if(aMonth>bMonth){
			return 1;
		}
		else if(aMonth<bMonth){
			return -1;	
		}	
		else{
			if(aDay>bDay){
				return 1;
			}
			else if(aDay<bDay){
				return -1;	
			}	
			else{
			 	return -1;
			}
		}
	}
}

// 分页数据的操作(查询界面导出功能用到)
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	//  判断数据是否是数组
		data = {
			total: data.length,
			rows: data
		}
	}
	
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	var sortName = opts.sortName;
    var sortOrder = opts.sortOrder;
 	
 	if (!data.originalRows) {
        data.originalRows = data.rows;
	}
    if ((!opts.remoteSort)&& (sortName != null)) {	    
        data.originalRows.sort(function (obj1, obj2) {
            var val1 = obj1[sortName];
            var val2 = obj2[sortName];
            if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                val1 = Number(val1);
                val2 = Number(val2);
            }
            var $sorter = dg.datagrid("getColumnOption", sortName).sorter;  //sorter排序方法
            if ($sorter) {
                return (sortOrder == "asc") ? $sorter(val1, val2) : $sorter(val2, val1);
            } else {
                if(val1<val2){
                    return (sortOrder == "desc") ? 1 : -1;
                } else if (val1 > val2) {
                    return (sortOrder == "desc") ? -1 : 1;
                } else {
                    return 0
                }
            }
        })
    }
     
    if (!opts.pagination)    //是否分页
        return data;
	pager.pagination({
		onSelectPage: function (pageNum, pageSize) {
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh', {
				pageNumber: pageNum,
				pageSize: pageSize
			});
			dg.datagrid('loadData', data);
		}
	});
	
	//翻页后查询数据变化，第一次显示空白问题处理
	if (data.originalRows.length<=opts.pageSize) opts.pageNumber=1;  
	if ((data.originalRows.length>opts.pageSize)&&(data.originalRows.length<=((opts.pageNumber-1)*opts.pageSize))) {
	   opts.pageNumber = Math.ceil(data.originalRows.length/opts.pageSize);  //向上取整
	}
	var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

//获得病历浏览csp配置
var cspUrl = $m({                  
	ClassName:"DHCHAI.BT.Config",
	MethodName:"GetValByCode",
	aCode:"SYSEmrCSP",
	aHospID:""
},false);


//加载医院公共方法
function Common_ComboToSSHosp(){
	var ItemCode = arguments[0];
	var LogHospID = arguments[1];
	var isSetValue = arguments[2];
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogHospID
	},false);
	var HospData = HospList.rows;
    
    var cbox = $HUI.combobox("#"+ItemCode, {
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:HospData,
		onLoadSuccess:function(){   //初始加载赋值
			if (!isSetValue) {
				var data=$(this).combobox('getData');
				if (data.length>0){
					$(this).combobox('select',data[0]['ID']);
				}
			}
		}
	});
	/*
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'HospDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.HospitalSrv';
			param.QueryName = 'QryHospListByLogon';
			param.aLogonHospID = LogHospID;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			if (!isSetValue) {
				var data=$(this).combobox('getData');
				if (data.length>0){
					$(this).combobox('select',data[0]['ID']);
				}
			}
		}
	});
	*/
	return  cbox;
}

//加载多选医院公共方法
function Common_ComboToMSHosp(){
	var ItemCode = arguments[0];
	var LogHospID = arguments[1];
	var isSetValue = arguments[2];
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogHospID,
		aIsShowAll:0
	},false);
	var HospData = HospList.rows;
    
    var cbox = $HUI.combobox("#"+ItemCode, {
		valueField:'ID',
		textField:'HospDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		editable:false,
		data:HospData,
		onLoadSuccess:function(data){   //初始加载全部
			if (!isSetValue) {
				var len = data.length;
				var HospIDs= new Array();
				for (var i=0;i<len;i++) {
					HospIDs[i]=data[i]['ID'];
				}
				$(this).combobox('setValues',HospIDs);				
			}
		}
	});
	
	return  cbox;
}

//加载科室/病区公共方法
function Common_ComboToLoc(){
	var ItemCode = arguments[0];
	var HospIDs = arguments[1];
	var Alias   = arguments[2];
	var LocCate = arguments[3];
	var LocType = arguments[4];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		//allowNull: true, 
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospIDs = HospIDs;
			param.aAlias = Alias;
			param.aLocCate = LocCate;
			param.aLocType = LocType;
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	return ;
}

//加载多选科室/病区公共方法
function Common_ComboToMSLoc(){
	var ItemCode = arguments[0];
	var HospIDs = arguments[1];
	var Alias   = arguments[2];
	var LocCate = arguments[3];
	var LocType = arguments[4];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.LocationSrv';
			param.QueryName = 'QryLoc';
			param.aHospIDs = HospIDs;
			param.aAlias = Alias;
			param.aLocCate = LocCate;
			param.aLocType = LocType;
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	return ;
}
//加载科室公共方法
function Common_LookupToLoc() {
	var ItemCode = arguments[0];
	var LinkItem = arguments[1];
	var HospIDs = arguments[2];
	var LocCate = arguments[3];
	var LocType = arguments[4];
	
	$("#"+ItemCode).lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'LocDesc2',
		queryParams:{
			ClassName: 'DHCHAI.BTS.LocationSrv',
			QueryName: 'QryLoc',
			aHospIDs : HospIDs,
			aLocCate : LocCate,
			aLocType : LocType,
			aIsActive: 1
		},
		columns:[[  
			{field:'ID',title:'ID',width:80},
			{field:'LocDesc2',title:'科室',width:360}
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			 var ID=rowData['ID'];
			 if (LinkItem) {
				$("#"+LinkItem).val(ID);           //给相关的ID赋值
			 }
		},
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0             //isCombo为true时，可以搜索要求的字符最小长度
	});
	return;
}

//加载细菌字典公共方法
function Common_ComboToBact() {
	var ItemCode = arguments[0];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,        //因测试组测试输入非字典内容，小字典统一不允许编辑
		defaultFilter:4,       //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,       //再次点击取消选中
		valueField: 'ID',
		textField: 'BacDesc', 
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=array&aAlias";
			$("#"+ItemCode).combobox('reload',url);
		}
	});
	return;
}
//加载细菌字典LookUP公共方法
function Common_LookupToBact() {
	var ItemCode = arguments[0];
	var LinkItem = arguments[1];
	
	$("#"+ItemCode).lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
		columns:[[  
			{field:'ID',title:'ID',width:80},
			{field:'BacDesc',title:'致病菌列名称',width:360}
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			 var ID=rowData['ID'];
			 if (LinkItem) {
				$("#"+LinkItem).val(ID);           //给相关的ID赋值
			 }
		},
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0             //isCombo为true时，可以搜索要求的字符最小长度
	});
	return;
}
//赋值
function Common_SetValue()
{
	var itmValue = '';
    
    var val = arguments[1];     
	var txt = arguments[2];
	
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	if (typeof val == 'undefined') val = '';
	if (typeof txt == 'undefined') txt = '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //文本框
	    itmValue = $this.val(val);
    }else if (className == 'hisui-numberbox') {  //数字
    	itmValue = $this.val(val);	    
    }else if (className == 'hisui-datebox') {  //日期
    	itmValue = $this.datebox('setValue',val);   
    }else if (className == 'hisui-timespinner') {  //时间框
    	itmValue = $this.timespinner('setValue',val);	
    }else if (className == 'hisui-combobox') {  //下拉框
    	if(val !="" && txt ==""){
   	  		itmValue = $this.combobox('setValue',val);
    	}else{
	    	itmValue = $this.combobox('setValue',txt);
		}
    }else if (className == 'hisui-switchbox') {  //开关
    	itmValue = $this.switchbox('setValue',val);	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	if (val == '') val = 0;
    	itmValue = $this.checkbox('setValue',(val) ? true : false);
    }else if (className == 'hisui-radio') {  //单个单选框
        if (val == '') val = 0;
    	itmValue = $this.radio('setValue',(val) ? true : false);
    }else if (className == 'hisui-searchbox') {  //查询框框
    	itmValue = $this.searchbox('setValue',val);	
    }
    
	return itmValue;	
}
//禁用组件
function Common_Disable()
{
	var itmValue = '';
    
    var val = arguments[1];     
	var txt = arguments[2];
	
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	if (typeof val == 'undefined') val = '';
	if (typeof txt == 'undefined') txt = '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //文本框
	    $this.attr('disabled','disabled');	
    }else if (className == 'hisui-numberbox') {  //数字
    	$this.attr('disabled','disabled');	    
    }else if (className == 'hisui-datebox') {  //日期
    	$this.datebox('disable');   
    }else if (className == 'hisui-timespinner') {  //时间框
    	$this.timespinner('disable');	
    }else if (className == 'hisui-combobox') {  //下拉框
		$this.combobox('disable');
    }else if (className == 'hisui-switchbox') {  //开关
    	$this.switchbox('disable');	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	$this.checkbox('disable');
    }else if (className == 'hisui-radio') {  //单个单选框
    	$this.radio('disable');
    }else if (className == 'hisui-searchbox') {  //查询框框
    	$this.searchbox('disable');	
    }
}
//启用组件
function Common_Enable()
{
	var itmValue = '';
    
    var val = arguments[1];     
	var txt = arguments[2];
	
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	if (typeof val == 'undefined') val = '';
	if (typeof txt == 'undefined') txt = '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //文本框
	    $this.removeAttr('disabled');	
    }else if (className == 'hisui-numberbox') {  //数字
    	$this.removeAttr('disabled');	    
    }else if (className == 'hisui-datebox') {  //日期
    	$this.datebox('enable');   
    }else if (className == 'hisui-timespinner') {  //时间框
    	$this.timespinner('enable');	
    }else if (className == 'hisui-combobox') {  //下拉框
		$this.combobox('enable');
    }else if (className == 'hisui-switchbox') {  //开关
    	$this.switchbox('enable');	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	$this.checkbox('enable');
    }else if (className == 'hisui-radio') {  //单个单选框
    	$this.radio('enable');
    }else if (className == 'hisui-searchbox') {  //查询框框
    	$this.searchbox('enable');	
    }
}

//***搜索框功能  只针对前台分页查询的正常展示列***//
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

/*
*1.searchText()方法支持前台分页查询方式的全部数据检索
*2.如果检索的表格数据可能发生变化（有增、删、改功能），在重新加载数据前需清除初始数据
*3.如果一个界面只有一个检索表格，清除数据可直接写originalData =""，如果是多个检索表格，清除数据需指明清除的表格名称：originalData["表格id"] =""
*/
var originalData =new Array();   //初始数据
function searchText(dg,t,f){ //参数：$("#datagrid")   
	var tempIndex=[];	   //匹配行	
	var state = dg.data('datagrid');
	var tmptable = state.options.id;   //查询的表格
	if ((! originalData[tmptable])||((originalData[tmptable].length)=='0')) {
	     var rows = state.data.originalRows||state.originalRows; 
	   	 originalData[tmptable] = {
			total: rows.length,
			rows: rows
		}
    } else {
	    var rows = originalData[tmptable].originalRows||originalData[tmptable].rows;
    }

    var columns = dg.datagrid('getColumnFields');
    var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
	
    var searchVal = t;
	var noFormat=f;
    if (searchVal) {
	    for(var i=0;i<rows.length;i++){
	        for(var j=0;j<columns.length;j++){
		        var col = dg.datagrid('getColumnOption', fields[j]);
		        if((col.hidden == true)||(col.checkbox == true)) {  //隐藏列、复选框列
					continue;
				}
				if((!noFormat)&&(col.formatter)) {   //链接、格式化函数列
					continue;
				}	
				if(!col.title) {  //无标题（非前台展示列）
					continue;
				}
	            if((rows[i][columns[j]])&&(rows[i][columns[j]].indexOf(searchVal)>=0)){
	                if(!tempIndex.contains(i)){
	                    tempIndex.push(i);
	                    break;
	                }
	            }
	        }
	    }
	   var RowsData=[];
	   for(var rowIndex=0;rowIndex<tempIndex.length;rowIndex++){  //匹配行
		    var Index = tempIndex[rowIndex];
		    var row = rows[Index];
		    RowsData.push(row);   
	    }
	    data = {  //搜索数据
			total: tempIndex.length,
			rows: RowsData
		}
		dg.datagrid('loadData', data);
	}else {
		dg.datagrid('loadData', originalData[tmptable]);
		originalData[tmptable]="";
	}
}
function Common_CreateMonth() {
	var domId = arguments[0];
	var lastFlg = arguments[1];
	var IsFisrt =1;
	$("#" + domId).datebox({
		validParams:"YM",
        parser: function (s) {//配置parser，返回选择的日期
            if (!s) return new Date();
            var arr = s.split('-');
            if ((lastFlg)&&(IsFisrt==1)) {
				arr[1]=arr[1]-1;
				IsFisrt=0;
	        }         
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
        }, 
        formatter: function (d) {
			var Month=parseInt(d.getMonth())+1;
            return d.getFullYear() + '-' + (Month < 10 ? ('0' + Month) : Month);
        }//配置formatter，只返回年月
    });
	var curr_time =new Date();
        $("#" + domId).datebox("setValue",month_formatter(curr_time));
}
 //格式化日期，仅年月
function month_formatter(date) {
	//获取年份
	var y = date.getFullYear();
	//获取月份
	var m = date.getMonth() + 1;
	return y + '-' + m;
}
//快速选择日期(2021-06-02 ShenC)
function Date_QuickSelect(){
	var YearCode = arguments[0];
	var MonthCode = arguments[1];
	var DateFromCode = arguments[2];
	var DateToCode = arguments[3];
	
	var Year = $('#'+YearCode).combobox('getValue');	//年
	var Month 	= $('#'+MonthCode).combobox('getValue');	//月+季度
	if((Year=="")||(Month=="")) return;
		
	if((Month>=1)&&(Month<=12)){	//月
		$('#'+DateFromCode).datebox('setValue', Year+"-"+Month+"-01");    // 日期初始赋值
		var todayDate = new Date(Year,Month,0)   
		var Day=todayDate.getDate();    //31
		$('#'+DateToCode).datebox('setValue', Year+"-"+Month+"-"+Day);    // 日期初始赋值
	}
	if(Month.indexOf("JD")>=0){
		if(Month.indexOf("JD1")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-03-31");    // 日期初始赋值
		}
		if(Month.indexOf("JD2")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-04-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-06-30");    // 日期初始赋值
		}
		if(Month.indexOf("JD3")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-07-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-09-30");    // 日期初始赋值
		}
		if(Month.indexOf("JD4")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-10-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
		}
	}
	if(Month.indexOf("BN")>=0){
		if(Month.indexOf("BN1")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-06-30");    // 日期初始赋值
		}
		if(Month.indexOf("BN2")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-07-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
		}
	}
	if(Month.indexOf("QN")>=0){
		$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
		$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
	}
}
// 打开页面[摘要][电子病历][院感报告]--以医为浏览器为准
/// 格式:  1.页面关联url
		///2.页面参数()
		/// 第一个参数：  width
		/// 第二个参数：  height
function DHCCPM_Open(parameter) {
	//use window.open so we can close this window, without closing everything
	//format reportname(reportarg1=value;reportarg2=value)
	var args = arguments.length
	//1.宽度,2.高度(默认网页高度)
	var Width=document.body.clientWidth*0.95;
	var Height=(document.body.clientHeight-50)*0.95;	
	
	var strUrl = ""
	//页面csp链接
	if(args>=1){					
		if (arguments[0]==""){
			alert("请输入页面参数");
			return;
		}
		strUrl=arguments[0];
	}
	if(args>=2){
		if(arguments[1]!=""){
			Width=arguments[1];
		}
	}
	if(args>=3){
		if(arguments[2]!=""){
			Height=arguments[2];
		}
	}
	var Left = (document.body.clientWidth - Width-10) / 2; 
	var Top =(document.body.clientHeight-Height-50) / 2;
	
	//--打开页面
	//var Page=window.open(strUrl,"",'height='+Height+',innerHeight='+Height+',width='+Width+',innerWidth='+Width+',top='+Top+',left='+Left+',status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no'); 
	var Page=websys_createWindow(
		strUrl,"",'height='+Height+',innerHeight='+Height+',width='+Width+',innerWidth='+Width+',top='+Top+',left='+Left+',status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no'
	); 
	return Page;
}
//多选文本 示例:Common_CheckboxToDic("chkStatusList","SPEStatus","");
function Common_CheckTextboxToDic() {
    var ItemCode = arguments[0];
    var DicType = arguments[1];
    var columns = arguments[2]? arguments[2] : 4;
    var RemarkItem = arguments[3]? arguments[3] : false; //某个值时显示备注项
    
    var strDicList =$m({
        ClassName:"DHCMA.Util.BTS.DictionarySrv",
        MethodName:"GetDicsByType",
        aTypeCode:DicType,
        aActive:1
    },false);
    
    var dicList = strDicList.split(String.fromCharCode(1));
    var len =dicList.length;        
    var count = parseInt(len/columns)+1;
    var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
    
    var listHtml=""
    for (var index =0; index< count; index++) {
        var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
        listHtml +="<div>"; 
        for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) { 
            var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
            
            var RemarkHtml = ((RemarkItem!=false)&&(RemarkItem==dicSubList[1])) ? "<input class='textbox' id='"+ItemCode+"Other' style='margin-left: 5px;'/>" : "";
            
            listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[1]+"  name="+ItemCode+"  value="+dicSubList[0]+">"+RemarkHtml+"</div>";  
        } 
        listHtml +="</div>"
    }
    $('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析checkbox 
    
}
//可控制显示列 单选文本
function Common_RadioTextToDic() {
    var ItemCode = arguments[0];
    var DicType = arguments[1];
    var columns = arguments[2]? arguments[2] : 4;
    var RemarkItem = arguments[3]? arguments[3] : false; //某个值时显示备注项
    
    var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
        ClassName:"DHCHAI.BTS.DictionarySrv",
        QueryName:"QryDic",
        ResultSetType:'array',
        aTypeCode:DicType,
        aActive:1
    }, false);

    var objStr = JSON.parse(strList);
    var len = objStr.length;
    var count = parseInt(len/columns)+1;
    var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
    var listHtml=""
    for (var index =0; index< count; index++) {
        var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
        listHtml +="<div>"; 
        for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) { 
            var DicID = objStr[dicIndex].ID;
            var DicDesc = objStr[dicIndex].DicDesc;
             var RemarkHtml = ((RemarkItem==true)||(RemarkItem==dicSubList[1])) ? "<input class='textbox' id='"+ItemCode+"Other'"+ objStr[dicIndex].DicCode+" style='margin-left: 5px;'/>" : "";
            listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+DicID+" type='radio' class='hisui-radio' label=\""+DicDesc+"\" name="+ItemCode+" value="+DicID+">"+RemarkHtml+"</div>";
        } 
        listHtml +="</div>"
    }
    $('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}

//ADD 2023-03-17 复选框样式下拉框
function Common_ComboCkDicID() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4,       //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			allowNull: true,
			multiple:true,
			rowStyle:'checkbox',
			valueField: 'ID',
			textField: 'DicDesc', 
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1";
			    $("#"+ItemCode).combobox('reload',url);
			}
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode="+DicType+"&aActive=1",
			editable: false,       
			defaultFilter:4,
			allowNull: true, 
			multiple:true,
			rowStyle:'checkbox',   
			valueField: 'ID',
			textField: 'DicDesc'
		});	
	}	
	return;
}
//取统计维度展示方式
function ShowStatDimens() {
	var ItemCode = arguments[0];
	var LocType = arguments[1];
	
	//维度列表
	var DimensList = $cm ({
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryStatDimens",
		aType:LocType
	},false);
	var DimenspData = DimensList.rows;
	var length=DimensList.total;
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,
		defaultFilter:4,    
		valueField: 'Code',
		textField: 'Desc',
		data:DimenspData,
		onLoadSuccess:function(data){   //初始加载全部
			if (length>0) {
				for (var i=0;i<length;i++) {
					if (data[i]['IsDefault']==1) {	
						$(this).combobox('setValue',data[i]['Code']);
					}
				}					
			}					
		}
	});
	return;
}

function Append_Url(url) {
	var p_URL = url;
	p_URL += '&aStatDimens=' + $('#cboShowType').combobox('getValue');
	p_URL += '&aLocIDs=' + $('#cboLoc').combobox('getValues').join(',');
	p_URL += '&aPath=' + cspPath;	   //202211报表优化时添加
	return p_URL;
}
function RemoveArr(arrRecord) {
	var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
	var arrlength = 0;
	var len = arrRecord.length;
	for (var indRd = 0; indRd < len; indRd++) {
		var rd = arrRecord[indRd];
		console.log(rd);
	
		//去掉全院、医院、科室组、科室合计
		if ((rd["DimensKey"].indexOf('-A-') > -1) || ((aStatDimens != "H") && (rd["DimensKey"].indexOf('-H-') > -1)) || ((aStatDimens != "G") && (aStatDimens != "HG") && (rd["DimensKey"].indexOf('-G-') > -1)) || (!rd["DimensKey"])) {
			delete arrRecord[indRd];
			arrlength = arrlength + 1;
			continue;
		}
	}
	arrRecord = arrRecord.sort(function(x, y){
		return y.UseAntiCnt - x.UseAntiCnt
	});
	arrRecord.length = len - arrlength
	return arrRecord;
}
//通过当前医院ID获取医院分组
function GetGroupLinkHospForCSS(){
	var arrHospID=$cm({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByHis",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	if (arrHospID.total>0){
		return arrHospID.rows[0].ID;
	}
	return "";
}
