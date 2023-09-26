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

//写内容到指定文件名中
writeFileUtil = function(filename, filecontent) {
	var fso, f, s;
	fso = new ActiveXObject("Scripting.FileSystemObject");
	var dir = browseFolderUtil();
	if (dir!="") {
		f = fso.OpenTextFile(dir + "\\" + filename, 8, true);
		f.WriteLine(filecontent);
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
myMsg = function(msg,time,title){
	msg = msg || "这里有个提示";
	time = time || 5000;
	title = title || "提示";
	$.messager.show({
		title: '提示',
		msg: msg,
		timeout: time,
		showType: 'slide',
		style:{}
	});
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
    isCode: {
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
    },
    isForm:{
	    validator:function(val){
			try{
	            var reg=/\s/;
				if((!val)||(reg.test(val))){
					return false;
				}
				return true;
			}catch(err){
				return false;
			}
	    },
	    message:"填写的信息不能为空且不能有空格,回车符等不可见字符"
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
			var reg= /^[0-9]+$/;
	        if(!reg.test(val))    
	        {    
	            return false;    
	        }    
	        return true;    
		},
		message:"只能输入数字~" 
    }
});