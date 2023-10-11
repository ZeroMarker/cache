/**
 * @author gaoshan
 * @version 2022.2.8
 * @description  报表共用业务处理类
*/

// 时间格式化
Date.prototype.format = function (format) {
    /*
    * eg:format="yyyy-MM-dd hh:mm:ss";
    */
    if (!format) {
        format = "yyyy-MM-dd hh:mm:ss";
    }
 
    var o = {
        "M+": this.getMonth() + 1, // month
        "d+": this.getDate(), // day
        "h+": this.getHours(), // hour
        "m+": this.getMinutes(), // minute
        "s+": this.getSeconds(), // second
        "q+": Math.floor((this.getMonth() + 3) / 3), // quarter
        "S": this.getMilliseconds()
        // millisecond
    };
 
    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
 
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
};

/**
   * 获取指定时间的日期
   * @params 正是今天之后的日期、负是今天前的日期
   * @return 2020-05-10
   * */
function getDate(num) {
    var date1 = new Date();
    //今天时间
    var time1 = date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
    var date2 = new Date(date1);
    date2.setDate(date1.getDate() + num);
    //num是正数表示之后的时间，num负数表示之前的时间，0表示今天
    var time2 = this.addZero(date2.getFullYear()) + "-" + this.addZero((date2.getMonth() + 1)) + "-" + this.addZero(date2.getDate());
    return time2;
  }
  
 // 获取当前月1号日期
 function getMonthOneDay()
 {
	var today = getDate(0);
	var year = today.split("-")[0]
	var month = today.split("-")[1]
 	var day = "01";
 	var ret = year+"-"+month+"-"+day
 	return ret;
 }
  
 // 获取当前年
 function getNowYear()
 {
	var date1 = new Date();
	return date1.getFullYear();
 }
  
  //补0
function addZero(num){
    if(parseInt(num) < 10){
      num = '0'+num;
    }
    return num;
  }
  
  // 自定义Map
function ReportMap() {
        this.elements = new Array();
        // 获取Map元素个数
        this.size = function() {
            return this.elements.length;
        },
        // 判断Map是否为空
        this.isEmpty = function() {
            return (this.elements.length < 1);
        },
        // 删除Map所有元素
        this.clear = function() {
            this.elements = new Array();
        },
        // 向Map中增加元素（key, value)
        this.put = function(_key, _value) {
            if (this.containsKey(_key) == true) {
                if (this.containsValue(_value)) {
                    if (this.remove(_key) == true) {
                        this.elements.push({
                            key : _key,
                            value : _value
                        });
                    }
                } else {
                    this.elements.push({
                        key : _key,
                        value : _value
                    });
                }
            } else {
                this.elements.push({
                    key : _key,
                    value : _value
                });
            }
        },
        // 向Map中增加元素（key, value)
        this.set = function(_key, _value) {
            if (this.containsKey(_key) == true) {
                if (this.containsValue(_value)) {
                    if (this.remove(_key) == true) {
                        this.elements.push({
                            key : _key,
                            value : _value
                        });
                    }
                } else {
                    this.elements.push({
                        key : _key,
                        value : _value
                    });
                }
            } else {
                this.elements.push({
                    key : _key,
                    value : _value
                });
            }
        },
        // 删除指定key的元素，成功返回true，失败返回false
        this.remove = function(_key) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        this.elements.splice(i, 1);
                        return true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },
        // 删除指定key的元素，成功返回true，失败返回false
        this.delete = function(_key) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        this.elements.splice(i, 1);
                        return true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },
        // 获取指定key的元素值value，失败返回null
        this.get = function(_key) {
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        return this.elements[i].value;
                    }
                }
            } catch (e) {
                return null;
            }
        },
        // set指定key的元素值value
        this.setValue = function(_key, _value) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        this.elements[i].value = _value;
                        return true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },
        // 获取指定索引的元素（使用element.key，element.value获取key和value），失败返回null
        this.element = function(_index) {
            if (_index < 0 || _index >= this.elements.length) {
                return null;
            }
            return this.elements[_index];
        },
        // 判断Map中是否含有指定key的元素
        this.containsKey = function(_key) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        bln = true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },

        // 判断Map中是否含有指定key的元素
        this.has = function(_key) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].key == _key) {
                        bln = true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },
        
        // 判断Map中是否含有指定value的元素
        this.containsValue = function(_value) {
            var bln = false;
            try {
                for (i = 0; i < this.elements.length; i++) {
                    if (this.elements[i].value == _value) {
                        bln = true;
                    }
                }
            } catch (e) {
                bln = false;
            }
            return bln;
        },

        // 获取Map中所有key的数组（array）
        this.keys = function() {
            var arr = new Array();
            for (i = 0; i < this.elements.length; i++) {
                arr.push(this.elements[i].key);
            }
            return arr;
        },

        // 获取Map中所有value的数组（array）
        this.values = function() {
            var arr = new Array();
            for (i = 0; i < this.elements.length; i++) {
                arr.push(this.elements[i].value);
            }
            return arr;
        };
        
        /**
        * map遍历数组
        * @param callback [function] 回调函数；
        * @param context [object] 上下文；
        */
        this.forEach = function forEach(callback,context){
            context = context || window;
            
            //IE6-8下自己编写回调函数执行的逻辑
            var newAry = new Array();
            for(var i = 0; i < this.elements.length;i++) {
                if(typeof  callback === 'function') {
                    var val = callback.call(context,this.elements[i].value,this.elements[i].key,this.elements);
                    newAry.push(this.elements[i].value);
                }
            }
            return newAry;
        }
}

// 本地下拉框回显设值
function getComboboxText(datalist,values)
{
	var re = /^[0-9]+.?[0-9]*/;
	var res = ""
	if (values && values != "")
	{
		var arr = values.split(",");
		var oneval = values.split(",")[0]
		// 数值
		if (re.test(oneval))
		{
			for (j=0;j<arr.length;j++)
			{
				var sval = arr[j]
				for (i=0;i<datalist.length;i++)
				{
					var obj = datalist[i]
					if (sval == obj.id)
					{
						if (res=="")
						{
							res = obj.desc
						}else
						{
							res = res+","+obj.desc	
						}
					}
				}
			}
		}else
		{
			res = values;	
		}
	}
	return res;
}

//datagrid 时间控件编辑器扩展
$.extend($.fn.datagrid.defaults.editors, {
    datetimebox: {// datetimebox就是你要自定义editor的名称
        init: function (container, options) {
            var input = $('<input class="easyuidatetimebox">').appendTo(container);
            return input.datetimebox({
                formatter: function (date) {
                    return new Date(date).format("yyyy-MM-dd hh:mm");
                }
            });
        },
        getValue: function (target) {
            return $(target).parent().find('input.combo-value').val();
        },
        setValue: function (target, value) {
            $(target).datetimebox("setValue", value);
        },
        resize: function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.width(width - (input.outerWidth() - input.width()));
            } else {
                input.width(width);
            }
        }
    }
});

/**
 * @param dgId datagrid ID
 * @param field_arr 合并列字段
 * @param judge 合并行key，例如患者数据：就诊ID(episodeID)作为key，不同行相同key数据需要合并
 */
function mergeCells(dgId, field_arr, judge) {
    var rows = $("#"+dgId).datagrid("getRows");
    if ((typeof (field_arr) === "undefined" || field_arr === "" || field_arr == null || field_arr === "null") ||
        (typeof (field_arr) === "undefined" || field_arr === "" || field_arr == null || field_arr === "null")) {
        return;
    }
    for (var i = 1; i < rows.length; i++) {
        for (var k = 0; k < field_arr.length; k++) {
            var field = field_arr[k]; // 要排序的字段
            if ("ck"==field) continue; // 前面CheckBox的合并
            if (rows[i][field] === rows[i - 1][field]) { // 相邻的上下两行
                if (!(typeof (judge) === "undefined" || judge === "" || judge == null || judge === "null")) {
                    if (rows[i][judge] !== rows[i - 1][judge]) {
                        continue;
                    }
                }
                var rowspan = 2;
                for (var j = 2; i - j >= 0; j++) { // 判断上下多行内容一样
                    if (rows[i][field] !== rows[i - j][field]) {
                        break;
                    } else {
                        if (!(typeof (judge) === "undefined" || judge === "" || judge == null || judge === "null")) {
                            if (rows[i][judge] !== rows[i - j][judge]) {
                                break;
                            }
                        }
                        rowspan = j + 1;
                    }
                }
                $("#"+dgId).datagrid("mergeCells", { // 合并
                    index: i - rowspan + 1,
                    field: field,
                    rowspan: rowspan
                });
                if (field_arr.indexOf("ck")>-1) { // 前面CheckBox的合并
                    $("#"+dgId).datagrid("mergeCells", {
                        index: i - rowspan + 1,
                        field: "ck",
                        rowspan: rowspan
                    });
                }
            }
        }
    }
}
/**
 @Desc 前端分页过滤器
 @use .datagrid({loadFilter:DocToolsHUINur.lib.pagerFilter})
*/
var DocToolsHUINur={
	lib:{
		pagerFilter:function pagerFilter(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				data = {
					total: data.length,
					rows: data
				}
			}else{
				if(typeof(data.rows)=='undefined'){
					var arr = []
					for (var i in data){
						arr.push(data[i])
					}
					data = {
						total: arr.length,
						rows: arr
					}
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			pager.pagination({
				showRefresh:false,
				onSelectPage:function(pageNum, pageSize){
					if (dg[0].id!="tabInPatOrd"){
						dg.datagrid('unselectAll');
					}
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					dg.datagrid('loadData',data);
					dg.datagrid('scrollTo',0); //滚动到指定的行  
					/*
					//特殊处理下信息总览界面的医嘱列表
					刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
					*/
					if (dg[0].id=="tabInPatOrd"){
						setTimeout(function() {
							SetVerifiedOrder(true);
						}, 0);
					}      
				}
			});
			if (!data.originalRows){
				data.originalRows = (data.rows);
			}
			if (opts.pagination){
				if (data.originalRows.length>0) {
					var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
					if ((start+1)>data.originalRows.length){
						//取现有行数最近的整页起始值
						start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
						opts.pageNumber=(start/opts.pageSize)+1;
					}
					//解决页码显示不正确的问题
					$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
					
					var end = start + parseInt(opts.pageSize);
					data.rows = (data.originalRows.slice(start, end));
				}
			}
			//console.log(data)
			return data;
		}
	},
	MessageQueue:{
		Queue: {},
		Add: function(MsgType,$Msg){
			if ((typeof MsgType=="undefined")||(typeof $Msg=="undefined")){
				return;   
			}
			if (this.Queue[MsgType] instanceof Array ===false){
			   this.Queue[MsgType]=new Array();
			}
			this.Queue[MsgType].push($Msg);
			return $Msg;
		},
		///批量停止执行Ajax请求，防止相同的请求对同一DOM操作，导致界面数据异常
		FireAjax:   function (MsgType) {
			this.EachDel(MsgType,function($Ajax){
				if($Ajax.readyState == 4 && $Ajax.status == 200) {
					return;
				}
				$Ajax.abort();
			});
		},
		EachDel:   function (MsgType,callBack) {
			if (this.Queue[MsgType] instanceof Array ===false){
				return;
			}
		    var $Msg;
			for(var i=0; i<this.Queue[MsgType].length; i++){
				$Msg=this.Queue[MsgType][i];
				this.Queue[MsgType].splice(i--, 1);
				if (callBack($Msg)===false){
					break;
				}
			}
         }
	}
}

/// 前端函数计算
var parser = new formulaParser.Parser();

// switch case
// SWITCH(17, 9, "Nine", 7, "Seven","aaa") 
// 参数1：switch value
// 参数2：成对出现的case，逗号隔开
// 参数最后一位：default value
parser.setFunction('SWITCH', function(arguments) {
    var result = '';
    if (arguments.length > 0) {
            var targetValue = arguments[0]
            var argc = arguments.length - 1
            var switchCount = Math.floor(argc / 2)
            var switchSatisfied = false
            var hasDefaultClause = argc % 2 !== 0
            var defaultClause = argc % 2 === 0 ? null : arguments[arguments.length - 1]

            if (switchCount) {
                for (var index = 0; index < switchCount; index++) {
                    if (targetValue === arguments[index * 2 + 1]) {
                        result = arguments[index * 2 + 2]
                        switchSatisfied = true
                        break
                    }
                }
            }
        if (!switchSatisfied) {
            result = hasDefaultClause ? defaultClause : ""
        }
    }
    return result;
});

// 扩展 IF判断, 非空和不为空返回对应值
parser.setFunction('IF_ELSE', function(arguments) {
    var condition = arguments[0];
    var ifValue = arguments[1];
    var elseValue = arguments[2];
    if (condition != "")
    {
        return ifValue;
    }
    return elseValue;
});

// join 函数: 连接字符串
parser.setFunction('JOIN', function(arguments) {
    var separator = arguments[0];
    var array = arguments.slice(1);
    var newarray = []
    if (array && array.length > 0)
    {
	    // 遍历array
		for (var index = 0; index < array.length; index++) {
		    var element = array[index];
		    // 判断是否存在
		    if (element != "") {
		        newarray.push(element)
		    }
		}
    }
    return newarray.join(separator);
});

// 两个日期相差天数
parser.setFunction('DATE_DIFF', function(arguments) {
    var startDate = arguments[0];
    var endDate = arguments[1];
    var dates = "";
    if (startDate && endDate && startDate != "" && endDate != "")
    {
        var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
        var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
        // var dates = (endTime - startTime) / (1000 * 60 * 60 * 24);
        dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    }
    
    return dates;
});

// 两个数字百分率,默认保留两位小数
parser.setFunction('PERCENT', function(arguments) {
    var num1 = arguments[0]; // 分子
    var num2 = arguments[1]; // 分母
    var fix = arguments[2]; // 保留小数位数
    if (!fix) fix = 2 // 不设置，默认保留2位小数
    var percent = "";
    if (num1 != "" && num2 != "")
    {
        percent = (num1 / num2 * 100).toFixed(fix);
    }
    if (percent!="") {
        // 去掉最后一位为0的字符
        percent = percent.replace(/0+$/g, "");
        // 去掉最后一位为.的字符
        percent = percent.replace(/\.$/g, "");
        percent = percent + "%";
    }
    return percent;
});	