﻿/**
 * @Title:通用的工具类
 * @Author: 汪凯-DHCWL
 * @Description:工具类
 * @Created on 2018-01-10
 */
/*--datagrid选中记录上移--*/
var moveup = function moveup (id){
	var allRows = $("#"+id).datagrid("getRows");
	var allLength = allRows.length;
	var row = $("#"+id).datagrid("getSelected");
	var index=$("#"+id).datagrid("getRowIndex",row);
	if (index == 0){
		$.messager.alert("提示","已经到顶啦,不能上移了");
		return;
	}
	$("#"+id).datagrid("deleteRow",index);
	index-=1;
	$("#"+id).datagrid("insertRow",{
		index:index,
		row:row
	});
}

/*--datagrid选中记录下移--*/
var movedown = function movedown (id){
	var allRows = $("#"+id).datagrid("getRows");
	var allLength = allRows.length;
	var row = $("#"+id).datagrid("getSelected");
	var index=$("#"+id).datagrid("getRowIndex",row);
	if (index >= (allLength-1)){
		$.messager.alert("提示","已经到底啦,不能下移了");
		return;
	}
	$("#"+id).datagrid("deleteRow",index);
	index+=1;
	$("#"+id).datagrid("insertRow",{
		index:index,
		row:row
	});
}
/*--弹出框设置--*/
var messageShow = function (infor){
	$.messager.show({
		title:'提示',
		msg:infor,
		timeout:3000,
		showType:'slide',
		style:{
			background:'red'	
		}
	});
}


/**
 * 进度条
 * @param exportExcelUrl
 * @param scanTime 检测是否导出完毕请求间隔 单位毫秒
 * @param interval 进度条更新间隔
 */
var porgressControl = function(className,methodName,rowID,scanTime){
    if(scanTime<1000 || scanTime == undefined){
        scanTime = 1000;
    }
    $.messager.progress({
        title:'操作进行中,请等待...',
        msg:'执行进度：',
        interval: 0
    });
    $.messager.progress('bar').progressbar({
        onChange: function(value){
            if(value == 100){
                $.messager.alert("提示","操作成功")
                $.messager.progress('close');
            }
        }
    });
    var timer = setInterval(function(){
	    $.m({
		    ClassName:className,
		    MethodName:methodName,
		    rowID:rowID
	    },function(data){
		    if (data < 0) {
			    clearInterval(timer);
                $.messager.progress('close');
                $.messager.alert("提示","操作失败")
		    }
		    $.messager.progress('bar').progressbar('setValue',data);
		    if (data == 100){
			    clearInterval(timer);
		    }
	    });
        }, scanTime);
}

// JS处理本地文件方法
//浏览本地文件系统目录
browseFolderUtil = function() {
	var FilePath = "";
	var objSrc = new ActiveXObject("Shell.Application").BrowseForFolder(0,
			"请选择路径", 0, "");
	if (objSrc != null) {
		if (objSrc.Self.IsFileSystem) {
			FilePath = objSrc.Self.Path;
		} else {
			alert('请选择正确路径!');
		}
	}
	return FilePath;
}

var textPath = "";
//写内容到指定文件名中
writeFileUtil = function(filename, filecontent,samePath) {
	var fso, f, s;
	fso = new ActiveXObject("Scripting.FileSystemObject");
	if (samePath == 1){
		var dir = textPath; 
	}else{
		var dir = browseFolderUtil();
		textPath = dir;
	}
	if (dir!="") {
		f = fso.OpenTextFile(dir + "\\" + filename, 8, true);
		f.WriteLine(filecontent);
		myMsg("导出成功");
		f.Close();
	}
	return dir;
}

trimLeftUtil = function(s) {
	if (s == null) {
		return "";
	}
	var whitespace = new String(" \t\n\r	");
	var str = new String(s);
	if (whitespace.indexOf(str.charAt(0)) != -1) {
		var j = 0, i = str.length;
		while (j < i && whitespace.indexOf(str.charAt(j)) != -1) {
			j++;
		}
		str = str.substring(j, i);
	}
	return str;
}

// 返回当前日期和时间的字符串格式为yyyy-mm-dd hhmmss
nowDateTimeUtil = function() {
	var date = new Date();
	date = (date.getFullYear())
			+ '-'
			+ ((date.getMonth() < 9)
					? ('0' + (date.getMonth() + 1))
					: (date.getMonth() + 1))
			+ '-'
			+ (date.getDate() < 10 ? ('0' + date.getDate()) : date
					.getDate()) + " " + date.getHours() + date.getMinutes()
			+ date.getSeconds();//+" "+date.getMilliseconds();
	return date
}


//自定义可以自动关闭的弹出框
/*myMsg = function(msg,time,title){
	msg = msg || "这里有个提示";
	time = time || 5000;
	title = title || "提示";
	$.messager.show({
		title: '提示',
		modal:true,
		msg: msg,
		timeout: time,
		showType: 'slide',
		style:{}
	});*/
myMsg = function(msg,title,type){
	if((msg.indexOf("成功") != -1) || (msg.indexOf("ok") != -1)){ 
		$.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
	}else{
		msg = msg || "这里有个提示";
		title = title || "提示";
		if ((msg != "")&&((msg.indexOf("错误") != -1) || (msg.indexOf("失败") != -1))){
			type = "error";
		}
		type = type|| "question";
		$.messager.alert(title, msg, type);
	}
}


//用于生成指标规则
function refreshKPIRule(kpiRuleObjForRule){
	var kpiIndex,kpiRules,kpiRule,dimIndex;
	for (kpiIndex in kpiRuleObjForRule){
		dimIndex = "",kpiRule = "";
		if (isOwnEmpty(kpiRuleObjForRule[kpiIndex])){
			kpiRule=kpiIndex;
		}else{
			for (dimIndex in kpiRuleObjForRule[kpiIndex]){
				var dimProIndex;
				if (isOwnEmpty(kpiRuleObjForRule[kpiIndex][dimIndex])){
					if (kpiRule){
						kpiRule = kpiRule + "^" + dimIndex
					}else{
						kpiRule = kpiIndex + ":" + dimIndex
					}
				}else{
					for (dimProIndex in kpiRuleObjForRule[kpiIndex][dimIndex]){
						if (kpiRule){
							kpiRule = kpiRule + "^" + dimIndex + "." +dimProIndex
						}else{
							kpiRule = kpiIndex + ":" + dimIndex + "." + dimProIndex
						}
					}
				}
			}
		}
		if (kpiRules) {
			kpiRules = kpiRules + "," + kpiRule
		}else {
			kpiRules = kpiRule
		}
	}
	return kpiRules
}

/*--对上面这个方法的优化--*/
/*--由于不同浏览器对于取对象属性的顺序不一致，需要将对象属性改为数组方式--*/
Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
	if (this[i] == val) return i;
	}
	return -1;
};
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
	this.splice(index, 1);
	}
};

function refreshKPIRuleNew(kpiRuleObjForRule){
	var kpiIndex,kpiRules,kpiRule,dimIndex;
	for (kpiIndex in kpiRuleObjForRule){
		dimIndex = "",kpiRule = "";
		/*if (isOwnEmpty(kpiRuleObjForRule[kpiIndex])){
			kpiRule=kpiIndex;
		}else{
			for (dimIndex in kpiRuleObjForRule[kpiIndex]){
				var dimProIndex;
				if (isOwnEmpty(kpiRuleObjForRule[kpiIndex][dimIndex])){
					if (kpiRule){
						kpiRule = kpiRule + "^" + dimIndex
					}else{
						kpiRule = kpiIndex + ":" + dimIndex
					}
				}else{
					for (dimProIndex in kpiRuleObjForRule[kpiIndex][dimIndex]){
						if (kpiRule){
							kpiRule = kpiRule + "^" + dimIndex + "." +dimProIndex
						}else{
							kpiRule = kpiIndex + ":" + dimIndex + "." + dimProIndex
						}
					}
				}
			}
		}*/
		kpiRule = kpiIndex;
		if (kpiRuleObjForRule[kpiIndex].length > 0){
			kpiRule = kpiRule + ":" + kpiRuleObjForRule[kpiIndex].join("^");
		}
		if (kpiRules) {
			kpiRules = kpiRules + "," + kpiRule
		}else {
			kpiRules = kpiRule
		}
	}
	return kpiRules
}

///  Desc  : 合并单元格
function mergeCellForTable(tableID,headName){
	var rows = $("#"+tableID).datagrid("getRows");
	var len = rows.length;
	var code = "",kpiCode = "",startNum = 0,rowspan = 0;
	for (var i = 0;i < len;i++){
		kpiCode = rows[i][headName];
		if ((kpiCode != code)||(i == (len-1))){
			if (i != 0){
				if (i == (len-1)){
					rowspan = i - startNum + 1;
				}else{
					rowspan = i - startNum;
				}
				
				$("#"+tableID).datagrid('mergeCells',{
					index:startNum,
					field:headName,
					rowspan:rowspan
				});
				startNum = i;
			}
			code = kpiCode;
		}
	}
}


window.D = (function(){
	//获取可视窗口的大小
	function getViewportOffset(){
		return{
			x : 100,
			y : 100
		}
	}
	function DHCWL(){
		this.height = getViewportOffset().y;
		this.width = getViewportOffset().x;
	}
	DHCWL.prototype.protest=function(obj){
		for(var name in obj) { 
			if(obj.hasOwnProperty(name)) 
			{ 
				return false; 
			} 
		} 
		return true;
	}
	return new DHCWL();
})()
console.log(D);
var test = {};
test.test=1;
console.log(D.protest(test));


//判断对象是否为空对象(不检测从原型链上继承的属性)
function isOwnEmpty(obj) 
{ 
    for(var name in obj) 
    { 
        if(obj.hasOwnProperty(name)) 
        { 
            return false; 
        } 
    } 
    return true; 
}; 


/*--自定义表单验证方法--*/
$.extend($.fn.validatebox.defaults.rules, {
    /*isCode: {
		validator: function(val){
			try{
				var reg=/[\$\#\@\&\%\!\*\^\~||\-\(\)\']/;
				var reg2=/^\d/;
	            var reg3=/\s/;
				if(reg.test(val)||(reg2.test(val))||(reg3.test(val))){
					return false;
				}
				return true;
			}catch(err){
				return false;
			}
		},
		message: "编码不能包括$,#,@,&,%,*,^,!,~,||,-,(,),'以及空格等特殊字符，并且不能以数字开头"
    },*/
	isCode: {
		validator: function(val){
			try{
				var reg=/^[0-9a-zA-Z]+$/
				if(reg.test(val)){
					return true;
				}
				return false;
			}catch(err){
				return false;
			}
		},
		message: "编码只能是数字和字母的组合"
    },
    isForm:{
	    validator:function(val){
			try{
	            var reg=/\s/;
				if(val == " "){
					return false;
				}
				return true;
			}catch(err){
				return false;
			}
	    },
	    message:"填写的信息不能只有一个空格"
    },
   	isFormIgNull:{
	    validator:function(val){
			try{
	            var reg=/\s/;
				if((reg.test(val))){
					return false;
				}
				return true;
			}catch(err){
				return false;
			}
	    },
	    message:"填写的信息不能有空格,回车符等不可见字符"
    },
    numAndChar:{
		validator:function(val,field){    
			var reg= /^[a-z0-9A-Z]+$/;
	        if(!reg.test(val))    
	        {    
	            return false;    
	        }    
	        return true;    
		},
		message:"请输入英文字母或是数字,其它字符是不允许的" 
    },
    isNum:{
		validator:function(val,field){    
			//var reg= /^[0-9]+$/;
	        var reg= /^\d{1,14}(\.\d{1,2})?$/;
			if(!reg.test(val))    
	        {    
	            return false;    
	        }    
	        return true;    
		},
		message:"只能输入合理数字~" 
    }
});

/*--设置密码--*/
function getPassWord(){
	var newDate = new Date();
	var passWord = newDate.getFullYear(); 
	var passWord = passWord + newDate.getMonth();
	var passWord = passWord + newDate.getDate(); 
	var passWord = passWord + newDate.getHours();
	return passWord;
}
/*--获取父元素的宽度--*/
function getParentWidth(elemID){
	return $("#"+elemID).parent().width();
}
/*--获取父元素的高--*/
function getParentHeight(elemID){
	return parseInt($("#"+elemID).parent().height())-20;
}

//获取可视窗口的大小
function getViewportOffset(){
	if (window.innerWidth){
		return{
			x : window.innerWidth,
			y : window.innerHeight
		}
	}else{
		if(document.compatMode === "BackCompat"){    //如果是怪异模式
			return{
				x : document.body.clientWidth,
				y : document.body.clientHeight
			}
		}else{
			return{
				x : document.documentElement.clientWidth,
				y : document.documentElement.clientHeight
			}
		}
	}
}

//下拉框自动清空关键字
function clearKeyWord(obj)
{
	var ID = obj.id;
	var textField =  $("#" + ID).combobox("getText");
	if (textField != ""){
		var valueField = $("#" + ID).combobox("getValue");
		if (valueField == textField){
			$("#" + ID).combobox("clear");
			$("#" + ID).combobox('reload');
		}
	}
}

//加载等待
function loadInforShow(flag,title,msg,infor)
{
	if (flag == "start"){
		var titleShow = title||"提示";
		var msgShow = msg||"正在加载中";
		var textShow = infor||"请勿进行其他操作";
		$.messager.progress({
			title: titleShow,
			msg: msgShow,
			text:textShow
		});
	}else{
		$.messager.progress("close");
	}
}
///Creator   : wk
///Desc      : 下拉框输入信息检查
function cleanComboValue(obj){
	var valueField = $(obj).combobox("options").valueField;
    var val = $(obj).combobox("getValue");  //当前combobox的值
    var allData = $(obj).combobox("getData");   //获取combobox所有数据
    var result = true;      //为true说明输入的值在下拉框数据中不存在
    for (var i = 0; i < allData.length; i++) {
    	if (val == allData[i][valueField]) {
    		result = false;
    	}
    }
    if (result) {
    	$(obj).combobox("clear");
    }
}

///Creator：      wz
///CreatDate：    2018-8
///Description:：   得到form各字段值
///Table：       
///Input：            form ID。
///Output：          
///Return：         用JSON对象存储的各表单的值
///Others：        	表单元素必须有"name"属性。返回的对象格式为：nameX:valueY
///	example:		var values=getFieldValues("rptFormLookup");
///					var searchV=values.inputSearchNode;
///////////////////////////////////////////////////////////////////////////////
///工具代码
//得到form各字段赋值
function getFieldValues(formID){
	var values=new Object();
	var selector="form#"+formID+" input";
	$(selector).each(function(){
		if (!$(this).attr("name")) return;
		//alert($(this).attr("name")+":"+$(this).val());
		values[$(this).attr("name")]=$(this).val();
	});
	
	return values;
	
}

///Creator：      wz
///CreatDate：    2018-8
///Description:：   设置form各字段值
///Table：       
///Input：            form ID；值对象
///Output：          
///Return：         
///Others：        	表单元素必须有"name"属性。
///	example:		var values=getFieldValues("rptFormLookup");
///					var searchV=values.inputSearchNode;
///////////////////////////////////////////////////////////////////////////////
///工具代码
//得到form各字段赋值

function setFieldValues(formID,values){

	var selector="form#"+formID+" input";
	$(selector).each(function(){
		if (!$(this).attr("name")) return;
		//alert($(this).attr("name")+":"+$(this).val());
		if (values[$(this).attr("name")]!=undefined) {
			$(this).val(values[$(this).attr("name")]);
		}
	});

}

///Creator：      wz
///CreatDate：    2018-8
///Description:：   简单提示消息框
///Table：       
///Input：            msg：提示内容，type：消息框类型，
///Output：          
///Return：         
///Others：        	HISUI提供的消息框显示的位置有时不是屏幕中央。该方法显示的消息框的位置在屏幕中央。
///	example:		

function showMsgByPop(msg,type,timeout) {
	if (!timeout) timeout=3000
	$.messager.popover({
	msg: msg,
	type:type,
	style:{
		top:document.body.clientHeight/2-20, //
		left:document.body.clientWidth/2-50
	},
	timeout:timeout
	})
}

/*--字符串截取--*/
function PCommond(str,separator,start,end){
	end = end || 0;
	var strArr = str.split(separator);
	var realStart = start - 1;
	if (end == 0){
		return strArr.slice(realStart,start).join(separator);
	}else if(end > 0){
		return strArr.slice(realStart,end).join(separator);
	}else{
		var len = strArr.length;
		var realEnd = end + len;
		return strArr.slice(realStart,realEnd).join(separator);
	}
}

///Creator：      wz
///CreatDate：    2018-11
///Description:：   解析日期字符串
///Table：       
///Input：            日期字符串
///Output：          
///Return：         date对象
///Others：        	
///	example:		

function dhcwlDateParser(strDate) {
	return $.fn.datebox.defaults.parser(strDate);
}

///Creator：      wz
///CreatDate：    2018-11
///Description:：   将date对象转换成字符串
///Table：       
///Input：          date：日期对象；format：字符串格式。目前支持"YMD"。separator:字符串分隔符
///Output：          
///Return：         
///Others：        	
///	example:
function dhcwlDateFormat(date,format,separator) {
	if (!format) format="YMD";
	if (!separator) separator="-";
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	
	if (format=="YMD") {
		//return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;
		return y+separator+(m<10?('0'+m):m)+separator+(d<10?('0'+d):d);
	}
	//其他格式在此添加。
	/*else if () {	
		
		
	}
	*/
}

