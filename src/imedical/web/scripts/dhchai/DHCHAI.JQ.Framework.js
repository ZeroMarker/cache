//自定义框架
$.Tool = new Object();

/**
 *  统一提示框样式 
 *  2017-04-06
 */
$.Tool.alert = function(){
	if (arguments.length<1) return;
	
	var options = {
		size: "small",
		title: '提示',
		message: '',
		callback: '',
		buttons: {
			ok:{
				label: '关闭',
				className: 'btn-success'
			}
		}
	}
	
	if (typeof(arguments[0]) == "object") {
		options = $.extend(options, arguments[0]);
	} else {
		if (typeof(arguments[1]) == "function"){
			options.message = arguments[0];
			options.callback = arguments[1];
		} else if (typeof(arguments[2]) == "function"){
			options.title = arguments[0];
			options.message = arguments[1];
			options.callback = arguments[2];
		} else {
			if (arguments.length == 1){
				options.message = arguments[0];
			} else {
				options.title = arguments[0];
				options.message = arguments[1];
			}
		}
	}
	
	bootbox.alert(options);
}

/**
 *  统一提示框样式
 *  2017-04-06
 */
$.Tool.confirm = function(){
	if (arguments.length<1) return;
	
	var options = {
		size: "small",
		title: '提示',
		message: '',
		callback: '',
		buttons: {
			confirm:{
				label: '确定',
				className: 'btn-success'
			},
			cancel:{
				label:'取消',
				className:'btn-danger'
			}
		},
		closeButton:false
	}
	
	if (typeof(arguments[0]) == "object") {
		options = $.extend(options, arguments[0]);
	} else {
		if (typeof(arguments[1]) == "function"){
			options.message = arguments[0];
			options.callback = arguments[1];
		} else if (typeof(arguments[2]) == "function"){
			options.title = arguments[0];
			options.message = arguments[1];
			options.callback = arguments[2];
		} else {
			if (arguments.length == 1){
				options.message = arguments[0];
			} else {
				options.title = arguments[0];
				options.message = arguments[1];
			}
		}
	}
	
	bootbox.confirm(options);
}

/**
 *  统一提示框样式
 *  2017-04-06
 */
$.Tool.prompt = function(title, fn){
	if (arguments.length<1) return;
	
	var options = {
		title: '',
		callback: '',
		buttons: {
			confirm:{
				label: '确定',
				className: 'btn-success'
			},
			cancel:{
				label:'取消',
				className:'btn-danger'
			}
		},
		closeButton:false
	}
	
	if (typeof(arguments[0]) == "object") {
		options = $.extend(options, arguments[0]);
	} else {
		if (typeof(arguments[0]) == "function"){
			options.title = '';
			options.callback = arguments[0];
		} else if (typeof(arguments[1]) == "function"){
			options.title = arguments[0];
			options.callback = arguments[1];
		} else {
			options.title = arguments[0];
		}
	}
	
	bootbox.prompt(options);
}

//用来生成RunServerMethod的加密字符串(P7以下版本用)
$.Tool.GetMethodSignature = function() {
	var retval = '';
	$.ajax({
		url: "../DHCHAI.ClassMethodServiceHelper.cls",
		type: "post",
		timeout: 100,  //100毫秒超时
		async: false,  //同步
		contentType: "application/x-www-form-urlencoded",
		success: function(data, textStatus){
			retval = data;
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert("DHCHAI.ClassMethodServiceHelper.cls执行异常,错误提示:" + errorThrown);
		}
	});
	return retval;
};

//执行类方法函数
$.Tool.RunServerMethod = function(tkclass,tkmethod) {
	if ((tkclass=='')||(tkmethod=='')) return '';
	
	if (tkMakeServerCall) {
		var dataInput = "'" + tkclass + "','" + tkmethod + "'";
		for (var i=2; i<arguments.length; i++) {
			var argInput = arguments[i];
			argInput = argInput.toString();  //处理数字等转字符串；
			argInput = argInput.replace(/\'/g,'\\\'');
			dataInput += ",'" + argInput + "'";
		}
		var retval = (new Function("return tkMakeServerCall(" + dataInput + ")"))();
		return retval;
	} else {
		var MethodSignature = $.Tool.GetMethodSignature();
		var dataInput = "'" + MethodSignature + "','" + tkclass + "','" + tkmethod + "'";
		for (var i=2; i<arguments.length; i++) {
			dataInput += ",'" + arguments[i] + "'";
		}
		var retval = (new Function("return cspRunServerMethod(" + dataInput + ")"))();
		return retval;
	}
}

//执行Query函数
$.Tool.RunQuery = function(tkclass,tkQuery) {
	if ((tkclass=='')||(tkQuery=='')) return "";
	
	var dataInput = "ClassName=" + tkclass + "&QueryName=" + tkQuery;
	for (var i = 2; i < arguments.length; i++) {
		dataInput += "&Arg" + (i-1) + "=" + arguments[i];
	}
	dataInput += "&ArgCnt=" + (arguments.length-2);
	
	var retval = '';
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: false,   //同步
		data: dataInput,
		success: function(data, textStatus){
			retval = (new Function("return " + data))();
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	return retval;
}

//Add By Cjb 2016-11-30 运行Query的方法 异步方式
//      QueryInfo:query的说明
//      ClassName:类名
//      Arg1--ArgN:参数
//      ArgCnt:参数个数
//callback:query运行成功后的回调函数，它需要接受query的结果。结果是返回行的数组
//objScope:callback函数的作用域。
//extraArg : 希望传给callback函数的自定义参数
$.Tool.RunQueryAsync1 = function(QueryInfo, callback, objScope, extraArg)
{
	var arryArgs = new Array();	
	$.ajax({
         type : "get", 
         data : QueryInfo,   //dataType: "json",// 数据返回类型
         async : true,
         url : ToolSetting.RunQueryPageURL,
         success : function(response,params){
         		//response.responseText
         		var obj = (new Function("return " + response))();
         		
				callback.call(objScope, obj, extraArg);
         	},
         error : function(response, params) {
				 		alert('Error:'+response.responseText);
					}
       });
       
};

//字符替换函数
$.Tool.ReplaceText = function(str, find, repl) {
 	var retval = str;
 	while(retval.indexOf(find) >=0)
 	{
 		retval = retval.replace(find, repl);	
 	}
 	return retval;
 }

//超链接传参取值
$.Tool.GetParam = function(obj, key) {
	var retval = "";
	var url = obj.location.href;
	var pos = url.indexOf("?");
	var tmpParams = "";
	var arrParams = null;
	var tmpKey = "";
	if ( pos < 0) {
		return "";
	} else {
		tmpParams = url.substring(pos + 1, url.length);
		arrParams = tmpParams.split("&");
		for (var i = 0; i < arrParams.length; i++) {
			tmpKey = arrParams[i];
			if(tmpKey.indexOf("=") < 0) continue;
			if(tmpKey.substring(0, tmpKey.indexOf("=")) == key){
				retval = tmpKey.substring(tmpKey.indexOf("=") + 1, tmpKey.length);
			}
		}
		return retval;
	}
};

/**
 * Global table Chinesize variable
 * -----------------------
 * This plugin by chenjb
 */
(function ($) {
	var oLanguage={
		"select": {
            rows: {
                _: '%d rows selected',
                0: '',
                1: ''
            }
        },
        "oAria": {
            "sSortAscending": ": 升序排列",
            "sSortDescending": ": 降序排列"
        },
        "oPaginate": {
            "sFirst": "首页",
            "sLast": "末页",
            "sNext": "下页",
            "sPrevious": "上页"
        },
		"sEmptyTable": "表中数据为空",
		"sLengthMenu" : "&nbsp;&nbsp;_MENU_",
		"sInfo" : "当前记录 _START_--_END_ 条&nbsp;&nbsp;&nbsp;&nbsp;共 _TOTAL_ 条记录",
		"sInfoEmpty" : "显示第 0 至 0 项结果，共 0 项",
		"sInfoFiltered" : "" ,  // "(由 _MAX_ 项结果检索)",
		"sInfoPostFix": "",
		"sInfoThousands" : ",",
		"sInfoPostFix": "",
		"sDecimal": "",
		"sThousands": ",",
		"sLoadingRecords": "正在载入...",
		"sProcessing": "处理中...",
		"sSearch": "搜索:",
		"sSearchPlaceholder": "",
		"sUrl": "",
		"sPaginationType": "full_numbers",
		"sZeroRecords": "没有匹配结果"
    }
	if($.fn.dataTable !=undefined)
	{
		$.fn.dataTable.defaults.oLanguage=oLanguage;
		//$.fn.dataTable.defaults.oClasses ={"sPageButton":"btn"};			
	}
}(jQuery));

$.Tool.DataTableByHtml = function(tableID, options)
{
	var defaultsHl = {
		"dom": '<"row"<"col-sm-7"B><"col-sm-5"f>>rt<"row"<"col-sm-7"il><"col-sm-5"p>>',
		"pagingType": "input"
	};
	var settingsHl = $.extend(defaultsHl, options);
	var table=$("#"+tableID).DataTable(settingsHl);
	return table;
};

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

/**
* 初始化日期控件 chenjb
* ------------------------
*/
$.Tool.RefreshDate =function(){
   $('input[data-provide="datepicker"]').each(function () {
   		//Date picker
  		$(this).datepicker({
    		  language: 'zh-CN'
    			,autoclose: true
    			,format:"yyyy-mm-dd"
  		});
  		$(this).datepicker('update', new Date());
   });
};

/**
* 渲染combox chenjb
* ------------------------
*/
$.Tool.RefreshSelect =function(selectID,defFlag){
   //为空则渲染所有控件
   if(selectID==undefined)
   {
	   	selectID="";   
   }
   else
   {
	   selectID = "#"+selectID;
   }
   $('select'+selectID+'[data-set]').each(function () {
	    //var tmp=$(this).attr("data-set");
		var queryStr = $(this).data("set");
		var paramStr = $(this).data("param");
		var colStr = $(this).data("col");
		var $this = $(this);
		//清空数据
		$this.empty();
		if(defFlag==undefined)
		{
			$this.append("<option selected='selected' value=''>--请选择--</option>");
		}
		if(queryStr!=undefined&&queryStr!=null)
		{
			var dataset = null ; //下拉框数据集
			var arrQry = queryStr.split(":");    //^  --> :
			if(paramStr==undefined)
			{
				//不需要参数
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);
			}
			else
			{
				//需要参数
				var arrParam = paramStr.split("^");
				$.each(arrParam, function (i, item) {
					var arrTmp = item.split("#");
					if(arrTmp[0]=="d")
					{
						//元素ID变量
						arrQry[arrQry.length+i] = $("#"+arrTmp[1]).val();
					}
					else
					{
						//静态变量
						arrQry[arrQry.length+i] = arrTmp[1];
					}
				});
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);  //arrQry.concat(arrParam)); 合并数组小可忽略内存效率
			}
			
			if(colStr==undefined || colStr=="")
			{
				//默认的第一和第二属性对应 code desc
				$.each(dataset.record, function (i, item) {
					var arrKey = Object.keys(item);
					$this.append("<option value='"+item[arrKey[0]]+"'>"+item[arrKey[1]]+"</option>");
				});
			}
			else
			{
				var arrCol = colStr.split("^");
				$.each(dataset.record, function (i, item) {
					//$('<option></option>').val(item[arrCol[0]]).html(item[arrCol[1]]).appendTo($(this));
					$this.append("<option value='"+item[arrCol[0]]+"'>"+item[arrCol[1]]+"</option>");
				});
			}				
		}
   });
   //
   $('select'+selectID).css("width","100%");
   var robj=$('select'+selectID).select2({tags: true});
   //robj.val("CA").trigger("change");
};

/*
* 取DataTables行索引 zhufei
* ------------------------
*/
$.Tool.GetTableRowIndex = function(tabId, colInd, colVal){
	var rowIndex = -1;
	if (arguments.length < 2) { return rowIndex; }
	
	if (typeof(tabId) == 'string'){
		var table = $("#" + tabId);
	} else {
		var table = tabId;
	}
	if (!table) { return rowIndex; }
	
	if (arguments.length == 2){
		var colIndex = "ID";
		var colvalue = colInd;
	} else {
		var colIndex = colInd;
		var colvalue = colVal;
	}
	
	var rowDatas = table.data().toArray();
	$.each(rowDatas, function(i,item) {
		if (item[colIndex] == colvalue){
			rowIndex = i;
			return false;  //跳出循环
		}
	});
	
	return rowIndex;
}

/*
* 选中select下拉框第一个
* 使用prop()时请使用jquery1.6及以上版本
*/
$.Tool.SelectFirstItem =function(selID){
	$("#"+selID+" option:first").prop("selected", 'selected');
};

/*
* 获取select2选中记录data
* ------------------------
*/
$.Tool.GetSelect2Rec =function(selID) {
	//$exampleMulti.val(["CA", "AL"]).trigger("change");
	var rst = null;
	debugger
	var rstArr = $("#"+selID).select2("data");
	if(rstArr.length==1)
	{
		rst = rstArr[0];
	}
	else
	{
		rst = rstArr;
	}
	return rst;
};

/*
* 设置select有效状态
* ------------------------
*/
$.Tool.SetSelect2Disabled =function(selID,status) {
	$("#"+selID).prop("disabled", status);
};

/*
* 设置select2选中值
* ------------------------
*/
$.Tool.SetSelect2Value =function(selID, FieldValue) {
	//$exampleMulti.val(["CA", "AL"]).trigger("change");
	var flag = true;
	$("#"+selID+" option").each(function(){
		if($(this).val() == FieldValue){
			$(this).attr("selected", true);
			flag=false;
		}
	});
	if(flag)
	{
		//$('#taskListTarget').append('<option>' + select + '</option>'); 
		//$example.val(FieldValue).trigger("change");
		$("#"+selID).append("<option value='"+FieldValue+"' selected>"+FieldValue+"</option>");
	}	
	$("#"+selID).select2();
};

/*
* 获取select2选中值
* ------------------------
*/
$.Tool.GetSelect2Value =function(selID) {
	//$exampleMulti.val(["CA", "AL"]).trigger("change");
	var rst = $("#"+selID).select2("val");
	return rst;
};

/*
* 进度条弹窗
* Add by mayanpeng 2018-08-29
* ------------------------
*/
$.Tool.ProgressBar = new Object();

/*
* 进度条显示
* 可传入DefaultConf中的对象参数覆盖默认值
* ------------------------
*/
$.Tool.ProgressBar.Start = function(ProgressConf) {
	var DefaultConf = {
		title : "进度条",
		tips : "",
		width : "420px",
		height : "140px",
		closeBtn : false, //禁用关闭按钮
		ProgressColor : "#337ab7", //进度条颜色
		striped : true, //是否带条纹
		rolling : true //条纹是否带动画效果(需同时开启条纹striped)
	};
	$.extend(DefaultConf, ProgressConf);
	var tempHtml='<div class="progress" style="margin:10px 3%;text-align:center;";>'
		+'<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">'
		+	'<span class="sr-only">0% Complete</span>'
		+	'<span class="progressNum"></span>'
		+'</div>'
		+	'<span class="progressTip"></span>'
		+'</div>';
	$.Tool.ProgressBarIndex = layer.open({
		type: 1,
		title: DefaultConf.title,
		area: [DefaultConf.width, DefaultConf.height], //宽高
		closeBtn: (DefaultConf.closeBtn) ? 1 : 0,
		content: tempHtml,
		success: function(layero, index){
			$(".progress").css("margin", (parseInt(DefaultConf.height)-50)/2.5 + "px 3% 0px 3%"); //计算滚动条垂直居中
			if(DefaultConf.striped) $(".progress-bar").addClass("progress-bar-striped");
			if(DefaultConf.rolling) $(".progress-bar").addClass("active");
			if(ProgressConf.ProgressColor) $(".progress-bar").css("background-color",ProgressConf.ProgressColor);
			if(DefaultConf.tips) {
				$(".progressTip").text(DefaultConf.tips);
				var tempProNum=0,tempProMaxNum=6;
				$.Tool.ProgressBar.ProSyncCode=setInterval(function() {
					if(tempProNum >= tempProMaxNum) {
						tempProNum=0;
						$(".progressTip").text(DefaultConf.tips);
					} else {
						tempProNum += 1;
						$(".progressTip").text($(".progressTip").text()+".");
					}
				},1000);
			}
		}
	});
};

/*
* 更新进度条进度
* 可传入0-100的任意数字来改变进度
* ------------------------
*/
$.Tool.ProgressBar.Update = function(progressNum){
	progressNum = parseInt(progressNum);
	$(".progress-bar").attr("aria-valuemin", progressNum);
	$(".progress-bar").css("width", progressNum + "%");
	$(".sr-only").text(progressNum + "% Complete");
	$(".progressNum").text(progressNum + "%");
	$(".progressTip").text("");
	clearInterval($.Tool.ProgressBar.ProSyncCode);
}

/*
* 关闭进度条，初始化所有内容
* ------------------------
*/
$.Tool.ProgressBar.Close = function() {
	if ($.Tool.ProgressBarIndex){
		layer.close($.Tool.ProgressBarIndex);
		clearInterval($.Tool.ProgressBar.ProSyncCode);
		$.Tool.ProgressBarIndex = null;
	}
}
