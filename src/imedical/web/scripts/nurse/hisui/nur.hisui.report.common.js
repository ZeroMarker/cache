/**
 * @author gaoshan
 * @version 2022.2.8
 * @description  ������ҵ������
*/

// ʱ���ʽ��
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
   * ��ȡָ��ʱ�������
   * @params ���ǽ���֮������ڡ����ǽ���ǰ������
   * @return 2020-05-10
   * */
function getDate(num) {
    var date1 = new Date();
    //����ʱ��
    var time1 = date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
    var date2 = new Date(date1);
    date2.setDate(date1.getDate() + num);
    //num��������ʾ֮���ʱ�䣬num������ʾ֮ǰ��ʱ�䣬0��ʾ����
    var time2 = this.addZero(date2.getFullYear()) + "-" + this.addZero((date2.getMonth() + 1)) + "-" + this.addZero(date2.getDate());
    return time2;
  }
  
 // ��ȡ��ǰ��1������
 function getMonthOneDay()
 {
	var today = getDate(0);
	var year = today.split("-")[0]
	var month = today.split("-")[1]
 	var day = "01";
 	var ret = year+"-"+month+"-"+day
 	return ret;
 }
  
 // ��ȡ��ǰ��
 function getNowYear()
 {
	var date1 = new Date();
	return date1.getFullYear();
 }
  
  //��0
function addZero(num){
    if(parseInt(num) < 10){
      num = '0'+num;
    }
    return num;
  }
  
  // �Զ���Map
function ReportMap() {
        this.elements = new Array();
        // ��ȡMapԪ�ظ���
        this.size = function() {
            return this.elements.length;
        },
        // �ж�Map�Ƿ�Ϊ��
        this.isEmpty = function() {
            return (this.elements.length < 1);
        },
        // ɾ��Map����Ԫ��
        this.clear = function() {
            this.elements = new Array();
        },
        // ��Map������Ԫ�أ�key, value)
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
        // ��Map������Ԫ�أ�key, value)
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
        // ɾ��ָ��key��Ԫ�أ��ɹ�����true��ʧ�ܷ���false
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
        // ɾ��ָ��key��Ԫ�أ��ɹ�����true��ʧ�ܷ���false
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
        // ��ȡָ��key��Ԫ��ֵvalue��ʧ�ܷ���null
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
        // setָ��key��Ԫ��ֵvalue
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
        // ��ȡָ��������Ԫ�أ�ʹ��element.key��element.value��ȡkey��value����ʧ�ܷ���null
        this.element = function(_index) {
            if (_index < 0 || _index >= this.elements.length) {
                return null;
            }
            return this.elements[_index];
        },
        // �ж�Map���Ƿ���ָ��key��Ԫ��
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

        // �ж�Map���Ƿ���ָ��key��Ԫ��
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
        
        // �ж�Map���Ƿ���ָ��value��Ԫ��
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

        // ��ȡMap������key�����飨array��
        this.keys = function() {
            var arr = new Array();
            for (i = 0; i < this.elements.length; i++) {
                arr.push(this.elements[i].key);
            }
            return arr;
        },

        // ��ȡMap������value�����飨array��
        this.values = function() {
            var arr = new Array();
            for (i = 0; i < this.elements.length; i++) {
                arr.push(this.elements[i].value);
            }
            return arr;
        };
        
        /**
        * map��������
        * @param callback [function] �ص�������
        * @param context [object] �����ģ�
        */
        this.forEach = function forEach(callback,context){
            context = context || window;
            
            //IE6-8���Լ���д�ص�����ִ�е��߼�
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

// ���������������ֵ
function getComboboxText(datalist,values)
{
	var re = /^[0-9]+.?[0-9]*/;
	var res = ""
	if (values && values != "")
	{
		var arr = values.split(",");
		var oneval = values.split(",")[0]
		// ��ֵ
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

//datagrid ʱ��ؼ��༭����չ
$.extend($.fn.datagrid.defaults.editors, {
    datetimebox: {// datetimebox������Ҫ�Զ���editor������
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
 * @param field_arr �ϲ����ֶ�
 * @param judge �ϲ���key�����综�����ݣ�����ID(episodeID)��Ϊkey����ͬ����ͬkey������Ҫ�ϲ�
 */
function mergeCells(dgId, field_arr, judge) {
    var rows = $("#"+dgId).datagrid("getRows");
    if ((typeof (field_arr) === "undefined" || field_arr === "" || field_arr == null || field_arr === "null") ||
        (typeof (field_arr) === "undefined" || field_arr === "" || field_arr == null || field_arr === "null")) {
        return;
    }
    for (var i = 1; i < rows.length; i++) {
        for (var k = 0; k < field_arr.length; k++) {
            var field = field_arr[k]; // Ҫ������ֶ�
            if ("ck"==field) continue; // ǰ��CheckBox�ĺϲ�
            if (rows[i][field] === rows[i - 1][field]) { // ���ڵ���������
                if (!(typeof (judge) === "undefined" || judge === "" || judge == null || judge === "null")) {
                    if (rows[i][judge] !== rows[i - 1][judge]) {
                        continue;
                    }
                }
                var rowspan = 2;
                for (var j = 2; i - j >= 0; j++) { // �ж����¶�������һ��
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
                $("#"+dgId).datagrid("mergeCells", { // �ϲ�
                    index: i - rowspan + 1,
                    field: field,
                    rowspan: rowspan
                });
                if (field_arr.indexOf("ck")>-1) { // ǰ��CheckBox�ĺϲ�
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
 @Desc ǰ�˷�ҳ������
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
					dg.datagrid('scrollTo',0); //������ָ������  
					/*
					//���⴦������Ϣ���������ҽ���б�
					ˢ�µ�ǰҳ��ѡ����,Դ�����������ӳ٣�Ҫ��֤��ջִ��˳��
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
						//ȡ���������������ҳ��ʼֵ
						start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
						opts.pageNumber=(start/opts.pageSize)+1;
					}
					//���ҳ����ʾ����ȷ������
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
		///����ִֹͣ��Ajax���󣬷�ֹ��ͬ�������ͬһDOM���������½��������쳣
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

/// ǰ�˺�������
var parser = new formulaParser.Parser();

// switch case
// SWITCH(17, 9, "Nine", 7, "Seven","aaa") 
// ����1��switch value
// ����2���ɶԳ��ֵ�case�����Ÿ���
// �������һλ��default value
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

// ��չ IF�ж�, �ǿպͲ�Ϊ�շ��ض�Ӧֵ
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

// join ����: �����ַ���
parser.setFunction('JOIN', function(arguments) {
    var separator = arguments[0];
    var array = arguments.slice(1);
    var newarray = []
    if (array && array.length > 0)
    {
	    // ����array
		for (var index = 0; index < array.length; index++) {
		    var element = array[index];
		    // �ж��Ƿ����
		    if (element != "") {
		        newarray.push(element)
		    }
		}
    }
    return newarray.join(separator);
});

// ���������������
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

// �������ְٷ���,Ĭ�ϱ�����λС��
parser.setFunction('PERCENT', function(arguments) {
    var num1 = arguments[0]; // ����
    var num2 = arguments[1]; // ��ĸ
    var fix = arguments[2]; // ����С��λ��
    if (!fix) fix = 2 // �����ã�Ĭ�ϱ���2λС��
    var percent = "";
    if (num1 != "" && num2 != "")
    {
        percent = (num1 / num2 * 100).toFixed(fix);
    }
    if (percent!="") {
        // ȥ�����һλΪ0���ַ�
        percent = percent.replace(/0+$/g, "");
        // ȥ�����һλΪ.���ַ�
        percent = percent.replace(/\.$/g, "");
        percent = percent + "%";
    }
    return percent;
});	