//自定义控件
$.form = new Object();
$.form.Format = "yyyy-mm-dd";
/**
*	日期格式的数据重新进行排序 
*/
jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "date-euro-pre": function ( a ) {
        var x;

        if (a.indexOf('/') > -1 ){   //针对dd/mm/yyyy日期格式类型
	        var frDatea = $.trim(a).split(' ');
            var frDatea2 = frDatea[0].split('/');
            x = (frDatea2[2] + frDatea2[1] + frDatea2[0]) * 1;
        }
        else if (a.indexOf('-') > -1){  //针对yyyy-mm-dd日期格式类型
	       	var frDatea = $.trim(a).split(' ');
            var frDatea2 = frDatea[0].split('-');
            x = (frDatea2[0] + frDatea2[1] + frDatea2[2]) * 1;
	    }
        else {
            x = Infinity;
        }
        return x;
    },
    "date-euro-asc": function ( a, b ) {
        return a - b;
    },
    "date-euro-desc": function ( a, b ) {
        return b - a;
    }
} );
/**
* Form表单赋值 zhufei
* ------------------------
*/
$.form.SetValue = function(cmp, val, txt){
	if (typeof(cmp) !== 'string') return;
	if (cmp == '') return;
	
	var $this = $('#'+ cmp);
	if ($this.length < 1) $this = $('[name="' + cmp + '"]');
	if ($this.length < 1) return;
	
	if (typeof(val) == 'undefined') val = '';
	if (typeof(txt) == 'undefined') txt = '';
	
	if ($this[0].tagName == 'SELECT'){
		if(val =="" && txt !="")
		{
			//通过文本赋值
			if ($this.find("option:contains('"+ txt +"')").length > 0){
				val  = $this.find("option:contains('"+ txt +"')")[0].value;
			}
		}
		else
		{
			if ($this.find("option[value='" + val + "']").length < 1){
				if ((val != '')&&(txt != '')){
					$this.append('<option value="' + val + '">' + txt + '</option>');
				}
			} else {}
		}
		
		
		$this.val(val).select2({
			placeholder: "--请选择--",
			allowClear: true
        });  //modify by liyi 2017-08-28 修复下拉框赋值无效
	} else if ($this[0].tagName == 'INPUT'){
		if ($this.attr("type") == 'text'){
			$this.val(val);
		} else if ($this.attr("type") == 'checkbox'){
			if ($this.length == 1){
				if (val == '') val = 0;
				$this.iCheck((val) ? 'check' : 'uncheck');
			} else {
				var arr = val.split(',');
				$this.each(function(){
					$this.iCheck(($.inArray($(this).val(), arr) > -1) ? 'check' : 'uncheck');
				});
			}
		} else if ($this.attr("type") == 'radio'){
			$this.each(function(){
				$this.iCheck(($(this).val() == val) ? 'check' : 'uncheck');
			});
		} else {}
	} else if ($this[0].tagName == 'TEXTAREA'){
		$this.val(val);
	} else if ($this[0].tagName == 'UL'){
		$this.val(val);
	} else {}
	
	return;
}

/**
* Form表单取值 zhufei
* ------------------------
*/
$.form.GetValue = function(cmp){
	var ret = '';
	if (typeof(cmp) !== 'string') return '';
	if (cmp == '') return '';
	
	var $this = $('#'+ cmp);
	if ($this.length < 1) $this = $('[name="' + cmp + '"]');
	if ($this.length < 1) return ret;
	
	if ($this[0].tagName == 'SELECT'){
		if ($this.val() == null) {
			ret = '';
		} else {
			ret = $this.val();
		}
	} else if ($this[0].tagName == 'INPUT'){
		if ($this.attr("type") == 'text'){
			ret = $this.val();
		} else if ($this.attr("type") == 'checkbox'){
			if ($this.length == 1){
				ret = ($this.is(':checked')?"1":"0");
			} else {
				$this.each(function(){
					var $item = $(this);
					if ($item.is(':checked')){
						if (ret == '') {
							ret = $item.val();
						} else {
							ret = ret + ',' + $item.val();
						}
					}
				});
			}
		} else if ($this.attr("type") == 'radio'){
			$this.each(function(){
				var $item = $(this);
				if ($item.is(':checked')){
					if (ret == '') {
						ret = $item.val();
					} else {
						ret = ret + ',' + $item.val();
					}
				}
			});
		} else {
			ret = $this.val();
		}
	} else if ($this[0].tagName == 'TEXTAREA'){
		ret = $this.val();
	} else if ($this[0].tagName == 'UL'){
		ret = $this.val();
	} else {
		ret = $this.val();
	}
	
	return $.trim(ret);
}

/**
* Form表单取值 zhufei
* ------------------------
*/
$.form.GetText = function(cmp){
	var ret = '';
	if (typeof(cmp) !== 'string') return '';
	if (cmp == '') return '';
	
	var $this = $('#'+ cmp);
	if ($this.length < 1) $this = $('[name="' + cmp + '"]');
	if ($this.length < 1) return ret;
	
	if ($this[0].tagName == 'SELECT'){
		var itm = $this.find('option:selected');
		if (itm){
			ret = itm.text();
		}
	} else if ($this[0].tagName == 'INPUT'){
		if ($this.attr("type") == 'text'){
			ret = $this.val();
		} else if ($this.attr("type") == 'checkbox'){
			if ($this.length == 1){
				ret = ($this.is(':checked')?"1":"0");
			} else {
				$this.each(function(){
					var $item = $(this);
					if ($item.is(':checked')){
						var itemId = $(this).attr('id');
						$label = $('label[for="'+ itemId +'"]');
						if ($label.length < 1) return true;
						if (ret == '') {
							ret = $label.text();
						} else {
							ret = ret + ',' + $label.text();
						}
					}
				});
			}
		} else if ($this.attr("type") == 'radio'){
			$this.each(function(){
				var $item = $(this);
				if ($item.is(':checked')){
					var itemId = $(this).attr('id');
					$label = $('label[for="'+ itemId +'"]');
					if ($label.length < 1) return true;
					if (ret == '') {
						ret = $label.text();
					} else {
						ret = ret + ',' + $label.text();
					}
				}
			});
		} else {}
	} else {}
	
	return $.trim(ret);
}

/**
* 渲染复选框|单选钮 zhufei
* ------------------------
*/
$.form.iCheckRender = function(){
	$('input').iCheck({
		checkboxClass: 'icheckbox_square-blue',
		radioClass: 'iradio_square-blue'
	});
}

/**
* 渲染下拉框 zhufei
* ------------------------
*/
$.form.SelectRender = function(cmp){
	var filter = '';
	if (typeof(cmp) == 'undefined'){
		filter = 'select[data-set]';
	} else if (typeof(cmp) == 'object'){
		if (cmp == null) filter = 'select[data-set]';
	} else if (typeof(cmp) == 'string'){
		if (cmp == '') {
			filter = 'select[data-set]';
		} else {
			var $cmp = $(cmp);
			if ($cmp.length > 0){
				if ($cmp[0].tagName == 'SELECT'){
					filter = cmp + '[data-set]';
				} else {
					filter = cmp + ' select[data-set]';
				}
			} else {
				if ((cmp.substr(1) !== '.')&&(cmp.substr(1) !== '#')){
					cmp = '#' + cmp;
				}
				$cmp = $(cmp);
				if ($cmp.length>0){
					if ($cmp[0].tagName == 'SELECT'){
						filter = cmp + '[data-set]';
					} else {
						filter = cmp + ' select[data-set]';
					}
				}
			}
		}
	} else {}
	if (filter == '') return;
	/***** IE 下科室类型第一次选择第一项，无法加载上的问题 *****/
	if(typeof($(filter).data("set"))=="undefined"){
        $(cmp).on("select2:open",function(){
			$(cmp).prepend("<option value ='999'>请选择</option>");
			if ($(cmp+">:first-child").val()==999){
				$(cmp+">:first-child").remove();
			}
		});
		return;
    };
	$(filter).each(function () {
		var $this = $(this);
		var queryStr = $this.data("set");
		var paramStr = $this.data("param"); 
		var colStr = $this.data("col");
		if (typeof(queryStr) == 'undefined') queryStr = '';
		if (typeof(paramStr) == 'undefined') paramStr = '';
		if (typeof(colStr) == 'undefined') colStr = '';
		
		$this.empty();	//清空数据
		$this.append('<option selected=true value="">--请选择--</option>');
		if ((queryStr != '')&&(queryStr != null)){
			var dataset = null ; //下拉框数据集
			var arrQry = queryStr.split(":");    //class:method
			if (paramStr == '') {	//不需要参数
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);
			} else {	//需要参数
				paramStr = paramStr + ''; //统一为字符串
				var arrParam = paramStr.split("^");
				$.each(arrParam, function (i, item) {
					if (item.substr(0,7) == "chosen:"){	//联动变量（关联元素ID）
						var lnkCmp = item.substr(7,item.length);
						arrQry[arrQry.length] = $("#"+lnkCmp).val();
					} else {	//静态变量
						arrQry[arrQry.length] = item;
					}
				});
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);
			}
			
			if ((colStr != '')&&(colStr != null)) {
				var arrCol = colStr.split("^");
				$.each(dataset.record, function (i, item) {
					$this.append("<option value='"+item[arrCol[0]]+"'>"+item[arrCol[1]]+"</option>");
				});
			} else {
				//Query第1、第2列默认对应属性Code、Desc
				$.each(dataset.record, function (i, item) {
					var arrKey = Object.keys(item);
					$this.append("<option value='" + item[arrKey[0]] + "'>" + item[arrKey[1]] + "</option>");
				});
			}
		}
		$this.css("width","100%");
		//$this.select2();		
		$this.select2({
			placeholder: "--请选择--",
			placeholderOption: "first",
			allowClear: true
        });
   });
}
$.form.SelectRender2 = function(cmp,minimumInput){
	var cmp = '#'+cmp;
	var $this = $(cmp);
	var queryStr = $this.data("set");
	var paramStr = $this.data("param"); 
	var colStr 	 = $this.data("col");
	if (typeof(queryStr) == 'undefined') queryStr = '';
	if (typeof(paramStr) == 'undefined') paramStr = '';
	if (typeof(colStr) == 'undefined') colStr = '';
	if ((queryStr=='')||(colStr=='')||(paramStr=='')) return;
	var classname=queryStr.split(':')[0];
	var queryname=queryStr.split(':')[1];
	if ((classname!='')&&(queryname!='')){
		$this.empty();	//清空数据
		//$this.append('<option selected=true value="">--请选择--</option>');
		$this.select2({
			placeholder: "--请选择--",
			placeholderOption: "first",
			allowClear: true,
			multiple: true,
			separator: ",",
			language:"zh-CN",
            ajax: {
                url: "./dhchai.query.csp",
                delay: 250,
                data: function (params) {
                	var Args = {};
                	Args.ClassName = classname;
                	Args.QueryName = queryname;
                	Args.ArgCnt = 0;
                	for (var i=0;i<paramStr.split('^').length;i++){
                		Args.ArgCnt = Args.ArgCnt +1;
                		if (paramStr.split('^')[i]=='Arg'){
                			eval('Args.Arg'+(i+1)+'="'+params.term+'"');
                		}else{
                			eval('Args.Arg'+(i+1)+'="'+paramStr.split('^')[i]+'"');
                		}
                	}
                	return Args;
                },
                processResults: function (data, params) {
                    params.page = params.page || 1;
					var retval = (new Function("return " + data))();
					var itemList = [];
					for(var i=0; i<retval.total; i++){
						itemList.push({id: eval('retval.record[i].'+colStr.split('^')[0]), text: eval('retval.record[i].'+colStr.split('^')[1])})
					}
                    return {
                        results: itemList,
                        pagination: {
                            more: (params.page * 10) < itemList.length
                        }
                    };
                },
                cache: true
            },
            escapeMarkup: function (markup) { return markup; },
            minimumInputLength: minimumInput, 
            templateResult: function (repo) {
            	if (repo.loading) return repo.text;
                var markup = "<div class=''>" + repo.text + "</div>";
                return markup;
            },
            templateSelection: function (repo) {
            	repo.selected = true;   
				return repo.text
            }
        });
	}
	$this.css("width","100%");
}
/**
* 渲染检索下拉框
* ------------------------
*arguments：
*/
$.form.SelectRender1 = function(cmp,minimumInput){
	var cmp = '#'+cmp;
	var $this = $(cmp);
	var queryStr = $this.data("set");
	var paramStr = $this.data("param"); 
	var colStr 	 = $this.data("col");
	if (typeof(queryStr) == 'undefined') queryStr = '';
	if (typeof(paramStr) == 'undefined') paramStr = '';
	if (typeof(colStr) == 'undefined') colStr = '';
	if ((queryStr=='')||(colStr=='')||(paramStr=='')) return;
	var classname=queryStr.split(':')[0];
	var queryname=queryStr.split(':')[1];
	if ((classname!='')&&(queryname!='')){
		$this.empty();	//清空数据
		$this.append('<option selected=true value="">--请选择--</option>');
		$this.select2({
			placeholder: "--请选择--",
			placeholderOption: "first",
			allowClear: true,
			language:"zh-CN",
            ajax: {
                url: "./dhchai.query.csp",
                delay: 250,
                data: function (params) {
                	var Args = {};
                	Args.ClassName = classname;
                	Args.QueryName = queryname;
                	Args.ArgCnt = 0;
                	for (var i=0;i<paramStr.split('^').length;i++){
                		Args.ArgCnt = Args.ArgCnt +1;
                		if (paramStr.split('^')[i]=='Arg'){
                			eval('Args.Arg'+(i+1)+'="'+params.term+'"');
                		}else{
                			eval('Args.Arg'+(i+1)+'="'+paramStr.split('^')[i]+'"');
                		}
                	}
                	return Args;
                },
                processResults: function (data, params) {
                    params.page = params.page || 1;
					var retval = (new Function("return " + data))();
					var itemList = [];
					for(var i=0; i<retval.total; i++){
						itemList.push({id: eval('retval.record[i].'+colStr.split('^')[0]), text: eval('retval.record[i].'+colStr.split('^')[1])})
					}
                    return {
                        results: itemList,
                        pagination: {
                            more: (params.page * 10) < itemList.length
                        }
                    };
                },
                cache: true
            },
            escapeMarkup: function (markup) { return markup; },
            minimumInputLength: minimumInput, 
            templateResult: function (repo) {
            	if (repo.loading) return repo.text;
                var markup = "<div class=''>" + repo.text + "</div>";
                return markup;
            },
            templateSelection: function (repo) {
            	repo.selected = true;   
				return repo.text
            }
        });
	}
	$this.css("width","100%");
}
/**
* 渲染日期控件
* ------------------------
*/
$.form.DateTimeRender = function(domID,param,position){
	
	$("#"+domID).val(param);
	var ret=$("#"+domID).datetimepicker({
	     format: $.form.Format,
	     pickerPosition: position,  //默认'bottom-right',日历输入框靠下会溢出时设置'top-right'
	     autoclose: true,
	     todayBtn: true,
	     startView:2,
		 minView:2,
		 todayHighlight: 1,
		 forceParse: 0,
		 showMeridian: 1,
	     language: 'zh-CN',
	     fontAwesome:true    //显示字体图标
	});
	return ret;
}

/**
* 渲染日期时间控件
* ------------------------
*/
$.form.DateTimeRender1 = function(domID,param){
	var format = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","GetDateFormat");
	$("#"+domID).val(param);
	var ret=$("#"+domID).datetimepicker({
        format: format+" hh:ii",
        autoclose: true,
		todayBtn: true,
		todayHighlight: 1,
        language: 'zh-CN',
        fontAwesome:true //显示字体图标
    });
	return ret;
}

/**
* 渲染日期控件
* ------------------------
*/
$.form.DateRender = function(domID,param,position){
	var format = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","GetDateFormat");
	$("#"+domID).val(param);
	var ret=$("#"+domID).datetimepicker({
        format: format,
        pickerPosition: position,  //默认'bottom-right',日历输入框靠下会溢出时设置'top-right'
		autoclose: true,
		todayBtn: true,
		startView:2,
		minView:2,
		todayHighlight: 1,
		forceParse: 0,
		showMeridian: 1,
		language: 'zh-CN',
		fontAwesome:true    //显示字体图标
    });
	return ret;
}
$.form.MonthRender = function(domID,param,position){
	$("#"+domID).val(param);;
	var ret=$("#"+domID).datetimepicker({
        format: 'yyyy-mm',
        autoclose: true,
        todayBtn: true,
        startView: 'year',
        minView:'year',
        maxView:'decade',
        language:  'zh-CN',
		fontAwesome:true    //显示字体图标
    });
	return ret;
}
/**
* 渲染复选框 chenjb
* ------------------------
*/
$.form.CheckBoxRender = function(cmp){
	var filter = '';
	
	if (typeof(cmp) == 'undefined'){
		filter = 'div[data-set]';
	} else if (typeof(cmp) == 'object'){
		if (cmp == null) filter = 'div[data-set]';
	} else if (typeof(cmp) == 'string'){
		if (cmp == '') {
			filter = 'div[data-set]';
		} else {
			var $cmp = $(cmp);
			if ($cmp.length > 0){
				if ($cmp[0].tagName == 'DIV'){
					filter = cmp + '[data-set]';
				} else {
					filter = cmp + ' div[data-set]';
				}
			} else {
				if ((cmp.substr(1) !== '.')&&(cmp.substr(1) !== '#')){
					cmp = '#' + cmp;
				}
				$cmp = $(cmp);
				if ($cmp){
					if ($cmp[0].tagName == 'DIV'){
						filter = cmp + '[data-set]';
					} else {
						filter = cmp + ' DIV[data-set]';
					}
				}
			}
		}
	} else {}
	if (filter == '') return;
	
	$(filter).each(function () {
		var $this = $(this);
		var queryStr = $this.data("set");
		var paramStr = $this.data("param"); 
		var colStr = $this.data("col");
		var span =$this.data("span");  //分栏数
		var ctype =$this.data("ctype");  //选中框类型
		var comName = $this.attr("id");
		if (typeof(queryStr) == 'undefined') queryStr = '';
		if (typeof(paramStr) == 'undefined') paramStr = '';
		if (typeof(colStr) == 'undefined') colStr = '';
		if (typeof(span) == 'undefined') span = '3';
		if (typeof(ctype) == 'undefined') ctype = 'checkbox'; //radio
		if (typeof(comName) == 'undefined') comName = 'grp'+parseInt(100*Math.random());  //随机数
		
		$this.empty();	//清空数据
		if ((queryStr != '')&&(queryStr != null)){
			var dataset = null ; //数据集
			var arrQry = queryStr.split(":");    //class:method
			if (paramStr == '') {	//不需要参数
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);
			} else {	//需要参数
				paramStr = paramStr + ''; //统一为字符串
				var arrParam = paramStr.split("^");
				$.each(arrParam, function (i, item) {
					if (item.substr(0,7) == "chosen:"){	//联动变量（关联元素ID）
						var lnkCmp = item.substr(7,item.length);
						arrQry[arrQry.length] = $("#"+lnkCmp).val();
					} else {	//静态变量
						arrQry[arrQry.length] = item;
					}
				});
				dataset = $.Tool.RunQuery.apply($.Tool.RunQuery,arrQry);
			}
			
			if ((colStr != '')&&(colStr != null)) {
				var arrCol = colStr.split("^");
				$.each(dataset.record, function (i, item) {
					$this.append("<div class='col-md-"+span+" col-xs-"+span+"'><input id ='"+item[arrCol[0]]+"' type='"+ctype+"' name='"+comName+"'>"+item[arrCol[1]]+" </div>");
				});
			} else {
				//Query第1、第2列默认对应属性Code、Desc
				$.each(dataset.record, function (i, item) {
					var arrKey = Object.keys(item);
					$this.append("<div class='col-md-"+span+" col-xs-"+span+"'><input id ='"+item[arrKey[0]]+"' type='"+ctype+"' name='"+comName+"'>"+item[arrKey[1]]+"</div>");
				});
			}
		}
		
   });
};

$.form.GetCurrDate = function(splitStr)
{
	if (typeof(splitStr) == 'undefined') splitStr = '';
	if(splitStr=='')
	{
		splitStr = '-';
	}
	var dateNow = new Date();
	var year = dateNow.getFullYear();
	var month = dateNow.getMonth();
	month++;
	var day = dateNow.getDate();
	/*
	if(month==0){
		month = 12;
		year--;
	}
	else
	{
		month++;
	}
	*/
	var lastDay = new Date(year,month,0).getDate();
	
	if(month<10) month = '0'+month;
	if(day<10) day = '0'+day;
	var ret = year+splitStr+month+splitStr+day;
	return ret;
};
//回车转为br标签
$.form.return2Br = function(str) {
	str = str.replace(/\^/g,"");
	return str.replace(/\r?\n/g,"<br />");	
};
//清空div下元素的值
$.form.clearDivInput = function(divName) {
	var filter ="";
	if ((divName.substr(1) !== '.')&&(divName.substr(1) !== '#')){
		filter = '#' + divName;
	}	
	$(filter + ' INPUT').each(function () {
		var $this = $(this);
		if ($this.attr("type") == 'text'){
			$this.val("");
		}else if ($this.attr("type") == 'checkbox'){
			$this.iCheck('uncheck');
		} else if ($this.attr("type") == 'radio'){
			$this.iCheck('uncheck');
		}
		else
		{}
	});
	$(filter + ' SELECT').each(function () {
		var $this = $(this);
		$this.val("").select2({
			placeholder: "--请选择--",
			allowClear: true
        });
	});
};

// 对Date的扩展，将 Date 转化为指定格式的String   
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，   
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)   
// 例子：   
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423   
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18   
Date.prototype.Format = function(fmt)   
{   
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
};

//计算两日期的天数差
$.form.DateDiff =function(startDate,endDate)
{
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
	iDays  =  parseInt(Math.abs(oEDate - oSDate)/1000/60/60/24)    //把相差的毫秒数转换为天数  
    return  iDays  
};

//返回传入日期的之前N天的数组
$.form.DateArr = function(endDate,DayDiff)
{
	var rst = [];
	if(DayDiff<0)
	{
		return rst;  //空数组
	}
	var oEDate = new Date(parseDate(endDate));  // yyyy-MM-dd
	for(i=DayDiff-1;i>-1;i--)
	{
		var tmpDate = new Date(oEDate - i*24*60*60*1000);		
		rst.push(tmpDate.Format("yyyy-MM-dd"));
	}
	return rst;
};

// 判断日期a是否大于等于日期b，异常：-1，是：1，否：0
$.form.CompareDate = function(a,b){
	if ((typeof(a)=='undefined')||(typeof(b)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	a = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",a);
	b = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",b);
	if ((a=='')||(b=='')){
		return -1;
	}
	if (a>=b){
		return 1;
	}else{
		return 0;
	}
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
* zhoubo
* ------------------------
*/
// 判断时间a是否大于等于时间b，异常：-1，是：1，否：0
$.form.CompareDateTime = function(a,b){
	if ((typeof(a)=='undefined')||(typeof(b)=='undefined')){
		return -1;
	}
	var a1 = a.split(' ')[0];
	var a2 = a.split(' ')[1];
	var b1 = b.split(' ')[0];
	var b2 = b.split(' ')[1];	
	// 转换为后台数据库格式
	a1 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",a1);
	a2 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","TimeHtmlToLogical",a2);
	b1 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",b1);
	b2 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","TimeHtmlToLogical",b2);
	if ((a1=='')||(b1=='')){
		return -1;
	}
	if (a1>b1){
		return 1;
	}else if(a1==b1){
		if (parseInt(a2) >= parseInt(b2)){
			return 1;
		}else{
			return 0;
		}
	}else{
		return 0;
	}
}

//解决IE8不支持forEach的方法
/*
if (typeof Array.prototype.forEach != 'function') {
    Array.prototype.forEach = function(callback){
      for (var i = 0; i < this.length; i++){
        callback.apply(this, [this[i], i, this]);
      }
    };
}
*/
//官网解决IE8不支持foreach　　
if ( !Array.prototype.forEach ) {
    Array.prototype.forEach = function forEach( callback, thisArg ) {
        var T, k;

        if ( this == null ) {
            throw new TypeError( "this is null or not defined" );
        }
        var O = Object(this);
        var len = O.length >>> 0;
        if ( typeof callback !== "function" ) {
            throw new TypeError( callback + " is not a function" );
        }
        if ( arguments.length > 1 ) {
            T = thisArg;
        }
        k = 0;
        while( k < len ) {

            var kValue;
            if ( k in O ) {

                kValue = O[ k ];
                callback.call( T, kValue, k, O );
            }
            k++;
        }
    };
}

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
// 判断是否超过三个月
checkThreeTime=function(begintime,endtime){
	if(!endtime){
	    return true;
	}
	var time1 = new Date(begintime).getTime();
	var time2 = new Date(endtime).getTime();
	if(begintime==''){
	    return false;
	}
	if(endtime==''){
	    return false;
	}
	if(time1 > time2){
	    return false;
	}

	//判断时间跨度是否大于3个月
	var arr1 = begintime.split('-');
	var arr2 = endtime.split('-');
	arr1[1] = parseInt(arr1[1]);
	arr1[2] = parseInt(arr1[2]);
	arr2[1] = parseInt(arr2[1]);
	arr2[2] = parseInt(arr2[2]);
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

//获取a天之前或a天之后日期
$.form.fun_date = function(a) {
	
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
	
	return time2 = year+"-"+month+"-"+day;
}

//获得病历浏览csp配置
var cspUrl = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","SYSEmrCSP","");

//公共方法处理layer和hisui全屏弹出问题
function showFullScreenDiag(url,title,closeBtn)
{
	
	if(parent.layer)  
	{  
	  //方法存在  
	  parent.layer.open({
		  type: 2,
		  area: ['95%', '95%'],
		  title:title!=""?title:false,
		  closeBtn:closeBtn>0?closeBtn:0,
		  fixed: false, //不固定
		  maxmin: false,
		  maxmin: false,
		  content: [url,'no']
	  });
	}
	else
	{	
		var t=new Date();
		t=t.getTime();
		//hisui全屏弹出
		url=url+"&t=" + t;
		if(title!="")
		{
			url=url+"&PageType=WinOpen";
		}
		websys_showModal({
			url:url,
			title:title,
			iconCls:'icon-w-paper',  
			originWindow:window,
			width:'95%',
			height:'95%'
			,onBeforeClose:function(){
				
			}
		});
	}
}
