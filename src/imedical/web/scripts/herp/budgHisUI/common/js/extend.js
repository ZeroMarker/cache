/*
撰写作者：刘相松
编码日期：2018/04/04
功能描述：此文件都是扩展功能，包括验证框扩展、表格单元格编辑器类型扩展、表格方法扩展
*/
/*验证框扩展*/
$.extend($.fn.validatebox.defaults.rules, {
    idcard: {// 验证身份证
        validator: function (value) {
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
        },
        message: '身份证号码格式不正确'
    },
    minLength: {
        validator: function(value, param) {
            return value.length >= param[0];
        },
        message: '请输入至少（2）个字符.'
    },
    length: { 
        validator: function(value, param) {
            var len = $.trim(value).length;
            return len >= param[0] && len <= param[1];
        },
        message: "输入内容长度必须介于{0}和{1}之间."
    },
    phone: {// 验证电话号码
        validator: function (value) {
            return /^((\d2,3)|(\d{3}\-))?(0\d2,3|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
        },
        message: '格式不正确,请使用下面格式:020-88888888'
    },
    mobile: {// 验证手机号码
        validator: function (value) {
            return /^(13|15|18)\d{9}$/i.test(value);
        },
        message: '手机号码格式不正确'
    },
    intOrFloat: {// 验证整数或小数
        validator: function (value) {
            return /^\d+(\.\d+)?$/i.test(value);
        },
        message: '请输入数字，并确保格式正确'
    },
    currency: {// 验证货币
        validator: function (value) {
            return /^\d+(\.\d+)?$/i.test(value);
        },
        message: '货币格式不正确'
    },
    qq: {// 验证QQ,从10000开始
        validator: function (value) {
            return /^[1-9]\d{4,9}$/i.test(value);
        },
        message: 'QQ号码格式不正确'
    },
    integer: {// 验证整数 可正负数
        validator: function (value) {
            return /^([+]?[0-9])|([-]?[0-9])+\d*$/i.test(value);
        },
        message: '请输入整数'
    },
    NotNegIntNum: {// 验证非负整数
        validator: function (value) {
             return /^\d+$/i.test(value);
        },
        message: '请输入非负整数'
    }, 
    PositiveNum: {// 正数-大于0的数
        validator: function (value) {
             return /^[0-9]+\.?[0-9]*$/i.test(value);
        },
        message: '请输入大于0的数'
    },
    ZeroToOneNum: {// 正数-大于0小于1的数
        validator: function (value) {
             return /^(0\.\d{2})$/i.test(value);
        },
        message: '请输入大于0小于1的两位小数'
    }, 
    OneToHundredNum: {// 正数-大于0小于100的正整数
        validator: function (value) {
             return /^100$|^(\d|[1-9]\d)$/i.test(value);
        },
        message: '请输入大于0小于100的正整数'
    },           
    age: {// 验证年龄
        validator: function (value) {
            return /^(?:[1-9][0-9]?|1[01][0-9]|120)$/i.test(value);
        },
        message: '年龄必须是0到120之间的整数'
    },
    chinese: {// 验证中文
        validator: function (value) {
            // return /^[\Α-\￥]+$/i.test(value);
            return /^[\u4e00-\u9fa5]+$/i.test(value);
        },
        message: '请输入中文'
    },
    english: {// 验证英语
        validator: function (value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message: '请输入英文'
    },
    unnormal: {// 验证是否包含空格和非法字符
        validator: function (value) {
            return /.+/i.test(value);
        },
        message: '输入值不能为空和包含其他非法字符'
    },
    username: {// 验证用户名
        validator: function (value) {
            return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i.test(value);
        },
        message: '用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）'
    },
    faxno: {// 验证传真
        validator: function (value) {
            //            return /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/i.test(value);
            return /^((\d2,3)|(\d{3}\-))?(0\d2,3|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
        },
        message: '传真号码不正确'
    },
    zip: {// 验证邮政编码
        validator: function (value) {
            return /^[1-9]\d{5}$/i.test(value);
        },
        message: '邮政编码格式不正确'
    },
    ip: {// 验证IP地址
        validator: function (value) {
            return /d+.d+.d+.d+/i.test(value);
        },
        message: 'IP地址格式不正确'
    },
    name: {// 验证姓名，可以是中文或英文
        validator: function (value) {
            return /^[\Α-\￥]+$/i.test(value) | /^\w+[\w\s]+\w+$/i.test(value);
        },
        message: '请输入姓名'
    },
    date: {// 验证姓名，可以是中文或英文
        validator: function (value) {
            //格式yyyy-MM-dd或yyyy-M-d
            return /^(?:(?!0000)[0-9]{4}([-]?)(?:(?:0?[1-9]|1[0-2])\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\1(?:29|30)|(?:0?[13578]|1[02])\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([-]?)0?2\2(?:29))$/i.test(value);
        },
        message: '清输入合适的日期格式'
    },
    msn: {
        validator: function (value) {
            return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);
        },
        message: '请输入有效的msn账号(例：abc@hotnail(msn/live).com)'
    },
    same: {
        validator: function (value, param) {
            if ($("#" + param[0]).val() != "" && value != "") {
                return $("#" + param[0]).val() == value;
            }else {
                return true;
            }
        },
        message: '两次输入的密码不一致！'
    }
});
/*表格单元格编辑器类型*/
$.extend($.fn.datagrid.defaults.editors, {    
    textReadonly: {    //文本框只读模式
        init: function (container, options) {    
            var input = $('<input type="text" readonly="readonly" class="datagrid-editable-input">').appendTo(container);    
            return input;    
        },    
        getValue: function (target) {    
            return $(target).val();    
        },    
        setValue: function (target, value) {    
            $(target).val(value);    
        },    
        resize: function (target, width) {    
            var input = $(target);    
            if ($.boxModel == true){    
                input.width(width - (input.outerWidth() - input.width()));    
            }else {    
                input.width(width);    
            }    
        }    
    }, 
    textdisabled: {    //文本框禁用
        init: function (container, options) {    
            var input = $('<input type="text" disabled="disabled" class="datagrid-editable-input">').appendTo(container);    
            return input;    
        },    
        getValue: function (target) {    
            return $(target).val();    
        },    
        setValue: function (target, value) {    
            $(target).val(value);    
        },    
        resize: function (target, width) {    
            var input = $(target);    
            if ($.boxModel == true){    
                input.width(width - (input.outerWidth() - input.width()));    
            }else {    
                input.width(width);    
            }    
        }    
    }   
});
/*表格方法扩展*/  
$.extend($.fn.datagrid.methods, {  
    //easyui datagrid 获取行号 调用方法 var num=$('#tt').datagrid('getRowNum');
    getRowNum:function (jq) {  
        var opts=$.data(jq[0],"datagrid").options;  
        var array = new Array();  
        opts.finder.getTr(jq[0],"","selected",1).each(function(){  
            array.push($(this).find("td.datagrid-td-rownumber").text());  
        });  
        return array.join(",");  
    },
    /*
    *  datagrid 获取正在编辑状态的行，使用如下：
    *  $('#id').datagrid('getEditingRowIndexs'); //获取当前datagrid中在编辑状态的行编号列表
    */
	getEditingRowIndexs: function (jq) {  
        var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
        var indexs = []
        rows.each(function(i, row) {
            var index = row.sectionRowIndex;
            if ($.inArray(index, indexs)== -1)  {
                indexs.push(index);
            }
        });
        return indexs;
    } 
});

/*表格方法扩展-单元格编辑*/  
$.extend($.fn.datagrid.methods, {
	editCell: function (jq, param) {
		return jq.each(function () {
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field) {
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
/* linkbutton方法扩展(解决linkbutton disable置灰后点击事件仍能发生的bug)
  @param {Object} jq
 */
$.extend($.fn.linkbutton.methods, {
    /*
      激活选项（覆盖重写）
      @param {Object} jq
     */
    enable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if ($(this).hasClass('l-btn-disabled')) {
                var itemData = state._eventsStore;
                //恢复超链接
                if (itemData.href) {
                    $(this).attr("href", itemData.href);
                }
                //回复点击事件
                if (itemData.onclicks) {
                    for (var j = 0; j < itemData.onclicks.length; j++) {
                        $(this).bind('click', itemData.onclicks[j]);
                    }
                }
                //设置target为null，清空存储的事件处理程序
                itemData.target = null;
                itemData.onclicks = [];
                $(this).removeClass('l-btn-disabled');
            }
        });
    },
    /*
    禁用选项（覆盖重写）
     @param {Object} jq
    */
    disable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if (!state._eventsStore)
                state._eventsStore = {};
            if (!$(this).hasClass('l-btn-disabled')) {
                var eventsStore = {};
                eventsStore.target = this;
                eventsStore.onclicks = [];
                //处理超链接
                var strHref = $(this).attr("href");
                if (strHref) {
                    eventsStore.href = strHref;
                    $(this).attr("href", "javascript:void(0)");
                }
                //处理直接耦合绑定到onclick属性上的事件
                var onclickStr = $(this).attr("onclick");
                if (onclickStr && onclickStr != "") {
                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
                    $(this).attr("onclick", "");
                }
                //处理使用jquery绑定的事件
                var eventDatas = $(this).data("events") || $._data(this, 'events');
                if (eventDatas["click"]) {
                    var eventData = eventDatas["click"];
                    for (var i = 0; i < eventData.length; i++) {
                        if (eventData[i].namespace != "menu") {
                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
                            $(this).unbind('click', eventData[i]["handler"]);
                            i--;
                        }
                    }
                }
                state._eventsStore = eventsStore;
                $(this).addClass('l-btn-disabled');
            }
        });
    }
});

