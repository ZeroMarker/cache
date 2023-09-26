/*HISUI公共js*/
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

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
		
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+DicID+" type='checkbox' class='hisui-checkbox' label="+DicDesc+"  name="+ItemCode+"  value="+DicID+"></div>";  
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
	if (!data.originalRows) {
		data.originalRows = (data.rows);
	}
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
		allowNull: true, 
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
			aa;
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
