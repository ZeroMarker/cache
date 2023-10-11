var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

//取值
function Common_GetValue()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
	if ($this.attr("class")){
		var className = $this.attr("class").split(' ')[0];
		if (className == 'textbox') {  //文本框
			itmValue = $this.val();
		}else if (className == 'hisui-numberbox') {  //数字
			itmValue = $this.val();	    
		}else if (className == 'hisui-datebox') {  //日期
			itmValue = $this.datebox('getValue');	    
		}else if (className == 'hisui-timespinner') {  //时间框
			itmValue = $this.timespinner('getValue');	
		}else if (className == 'hisui-combobox') {  //下拉框（多选下拉框没有封装）
			itmValue = $this.combobox('getValue');
		}else if (className == 'hisui-switchbox') {  //开关
			itmValue = $this.switchbox('getValue');	
		}else if (className == 'hisui-checkbox') {  // 单个复选框
			itmValue = $this.checkbox('getValue');	    
		}else if (className == 'hisui-radio') {  //单个单选框
			itmValue = $this.radio('getValue');
		}else if (className == 'hisui-searchbox') {  //查询框框
			itmValue = $this.searchbox('getValue');	
		}
	} else {
		itmValue = $this.val();
	}
	return itmValue;
}

//取值
function Common_GetText()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
	if ($this.attr("class")){
		var className = $this.attr("class").split(' ')[0];
		if (className == 'textbox') {  //文本框
			itmValue = $this.val();
		}else if (className == 'hisui-numberbox') {  //数字
			itmValue = $this.val();	    
		}else if (className == 'hisui-datebox') {  //日期
			itmValue = $this.datebox('getValue');	    
		}else if (className == 'hisui-timespinner') {  //时间框
			itmValue = $this.timespinner('getValue');	
		}else if (className == 'hisui-combobox') {  //下拉框
			itmValue = $this.combobox('getText');
		}else if (className == 'hisui-switchbox') {  //开关
			itmValue = $this.switchbox('getValue');	
		}else if (className == 'hisui-checkbox') {  // 单个复选框
			itmValue = $this.attr("label");	    
		}else if (className == 'hisui-radio') {  //单个单选框
			itmValue =$this.attr("label");
		}else if (className == 'hisui-searchbox') {  //查询框框
			itmValue = $this.searchbox('getValue');	
		}
	} else {
		itmValue = $this.val();
	}
	return itmValue;
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

//创建知识库版本下拉框
function Common_ComboToHospTags(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: false,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'HMS.BT.HospitalTags';
			param.QueryName = 'QryHospTags';
			param.aAlias = "";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	return  cbox;
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
//单选字典赋值
function Common_SetRadioValue() {
	var ItemCode = arguments[0];
	var value = arguments[1];
	$("input[name='"+ItemCode+"']").each(function(){
	      if ($(this).val() == value) {
			  $(this).radio('setValue',true);
		  }
	});
	return true;
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

//扩展datagrid:动态添加删除editor
$.extend($.fn.datagrid.methods, {    
    addEditor : function(jq, param) {   
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item.field); 
                e.editor = item.editor; }); 
            } else {    
                var e = $(jq).datagrid('getColumnOption', param.field);    
                e.editor = param.editor;  
            }   
        },  
    removeEditor : function(jq, param) {    
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item);   
                e.editor = {};  
                }); 
        } else {    
            var e = $(jq).datagrid('getColumnOption', param);
            e.editor = {};  
        }   
    }
});

//***搜索框功能  只针对前台分页查询的正常展示列 Start ***//
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

Array.prototype.contains = function(item){
	RegExp("\\b"+item+"\\b").test(this);
};
var originalData =[];   //初始数据
function searchText(dg,t,odata){ //参数：$("#datagrid")
	var tempIndex=[];	   //匹配行	
	var state = dg.data('datagrid'); 
	
	//if (!odata) odata = originalData;
    if (!odata.total) {
	    var rows = state.data.originalRows||state.originalRows;
	   	odata = {
			selector : dg.selector,
			total: rows.length,
			rows: rows
		}
    } else {
	  var rows = odata.originalRows||odata.rows;
    }
    var columns = dg.datagrid('getColumnFields');
    var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
	
    var searchVal = t;
    if (searchVal) {
	    for(var i=0;i<rows.length;i++){
	        for(var j=1;j<columns.length;j++){
		        var col = dg.datagrid('getColumnOption', fields[j]);
		        if((col.hidden == true)||(col.checkbox == true)) {  //隐藏列、复选框列
					continue;
				}
				if(col.formatter) {   //链接、格式化函数列
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
		dg.datagrid('loadData', odata);
	}
	return odata;
}



/****************************************** 以下内容先不用管 zhufei ***********************************************/
/****************************************** 以下内容先不用管 zhufei ***********************************************/
/*
//字典公共方法(取值是ID)
function Common_ComboToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	if (arguments[3]) {
		var HospID = arguments[3];
	} else {
		var HospID = "";
	}
	if (arguments[2]) {  //需初始赋值
		var cbox = $HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4, 
			allowNull: true,
			//placeholder:'请选择',
			valueField: 'DicRowId',
			textField: 'DicDesc', 
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDicToCbo';
				param.aDicType = DicType;
				param.aAddItem = AddItem;
				param.aHospID = HospID;
				param.ResultSetType = 'array';
			}
		});	
	} else {	
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       
			defaultFilter:4,  
			allowNull: true,			
			valueField: 'DicRowId',
			textField: 'DicDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDicToCbo&ResultSetType=array&aDicType="+DicType +"&aAddItem="+AddItem+"&aHospID="+HospID;;
			   	$("#"+ItemCode).combobox('reload',url);
			}
		});
	}		
	return;
}

//多选下拉框(取值是ID)
function Common_ComboMultiDicID(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			valueField:'myid',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
				$("#"+ItemCode).combobox('reload',url);
			}
		});
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			valueField:'myid',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false
		});
	}
	
}

//至少输入一个字符进行查询
function Common_LookupToICD() {
	var ItemCode = arguments[0];
	var LinkItem = arguments[1];
	
	$("#"+ItemCode).lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ICDRowID',
		textField: 'ICDDesc',
		queryParams:{ClassName: 'DHCMed.SSService.CommonCls',QueryName: 'QryICDDxByAlias'},
		columns:[[  
			{field:'ICD10',title:'ICD10',width:80},   
			{field:'ICDDesc',title:'诊断描述',width:360}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			 var ICD10=rowData['ICD10'];
			 if (LinkItem) {
				$("#"+LinkItem).val(ICD10);            //给相关的ICD10赋值
			 }
		},
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1             //isCombo为true时，可以搜索要求的字符最小长度
	});
	return;
}
//多选字典 显示 obj.StatusList = Common_CheckboxToDic("chkStatusList","SPEStatus","");
function Common_CheckboxToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
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
			var dicDesc=dicSubList[1].replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicDesc+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
	
}

//单选字典
function Common_RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}


//复选框样式的单选字典
function Common_chkRadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+" data-options=radioClass:'hischeckbox_square-blue'></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}

//Query多选选字典（不限制展示列,取值为code）
function Common_CheckboxDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
		
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='checkbox' class='hisui-checkbox' label="+Value+" name="+ItemCode+" value="+ValueCode+">";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
	
}

//Query单选字典（不限制展示列,取值为code）
function Common_RadioDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+">";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
}

//复选框样式Query单选字典（不限制展示列,取值为code）
function Common_chkRadioDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+" data-options=radioClass:'hischeckbox_square-blue'></div>";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
}

//日期格式化显示
function Common_FormatDate(date){	
	var LogicalDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:date
	},false);
	var FormatDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateLogicalToHtml",
		aDate:LogicalDate
	},false);
	return  FormatDate;
}

//日期时间格式转化 1->3
function Common_Format13DateT(dateTime){
	//如果入惨非指定日期格式，则原值返回
	if (dateTime.indexOf('/')<0)
	{
		return dateTime;
	}
	var Time=dateTime.split(' ')[1];
	var date=dateTime.split(' ')[0];
	var year=date.split('/')[2];
	var month=date.split('/')[1];
	var day=date.split('/')[0];
	var date=year+"-"+month+"-"+day
	if (Time!="") {
		var dateTime=date+" "+Time;
	}else{
		var dateTime=date;
		}
	return  dateTime;
}

function GetDateFormat() {
	var DateFormat ;
    if ("undefined"==typeof dtformat){
        DateFormat = $m({ 
            ClassName:"DHCMed.SSService.CommonCls",
            MethodName:"GetDateFormat"
        },false);
    }else{
        DateFormat = dtformat;
    }
    return DateFormat;
}

//当期日期 时间
function Common_GetDate(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var DateFormat = GetDateFormat();
	if (DateFormat=='YMD') {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if (DateFormat=='DMY') {
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

//当期日期 时间
function Common_GetCurrDateTime(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();
	var mm= date.getMinutes();
	var s = date.getSeconds();
	var DateFormat = GetDateFormat();
	if (DateFormat=='YMD') {	
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}else if (DateFormat=='DMY') {
		return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y+' '+ h + ":" + mm + ":" + s;
	}else {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}
}

// 判断日期大小
function  Common_CompareDate(startDate,endDate){
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	var startDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:startDate
	},false);
	var endDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
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
// 判断日期是否在三天内
function  Common_CompareDateToNum(startDate,endDate){
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	var startDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:startDate
	},false);
	var endDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:endDate
	},false);
	if ((Math.abs(startDate-endDate))>3){
		return -1;
	}
	else{
		return 1;
	}
}
// 判断时间超过三个月 true:不超过
function checkThreeTime(startDate,endDate){
	//var time1 = new Date(startDate).getTime();
	//时间格式统一
	var DateFormat = GetDateFormat();
	if (DateFormat=='DMY') {
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
	if (DateFormat=='YMD') {
		return time2 =  year+'-'+month+'-'+day;
	}else if (DateFormat=='DMY') {
		return time2 = day+'/'+month+'/'+year;
	}else {
		return time2 = year+'-'+month+'-'+day;
	}
}

function Common_ComboGrpDicID(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
		valueField: 'myid',
		textField: 'Description', 
		multiple:true,
		allowNull: true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
		    $("#"+ItemCode).combobox('reload',url);
		},
		filter: function(q, row){
			return (row["Description"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
	return;
}
function Common_CheckboxToSDRule() {
	var ItemCode = arguments[0];
	var ParRef	 = arguments[1];
	var RuleType = arguments[2];
	var columns	 = arguments[3]? arguments[3] : 4;;
	var strDicList =$m({
		ClassName:"DHCMA.CPW.SDS.QCEntityMatchRuleSrv",
		MethodName:"GetRulesByParref",
		aParRef:ParRef,
		aRuleType:RuleType
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
	if (dicList[0]=="") {$('#'+ItemCode).html(""); return;}
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[1]+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
	
}

//获得病历浏览csp配置
var cspUrl = $m({                  
	ClassName:"DHCMA.Util.BT.Config",
	MethodName:"GetValueByCode",
	aCode:"SYSEmrCSP",
	aHospID:session['DHCMA.HOSPID']||""
},false);


function Common_CreateMonth() {
	var domId = arguments[0];
	$("#" + domId).datebox({
		validParams:"YM",
        parser: function (s) {//配置parser，返回选择的日期
            if (!s) return new Date();
            var arr = s.split('-');
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

//验证手机号
function Common_CheckPhone(){
	var telNumber=arguments[0];
	var cType=arguments[1];
	if (typeof(telNumber) !== 'string'){
		 return false;
	}
	if (!cType) {  
		 return (telNumber.length==11)
	}else{    
		//验证手机号+座机号
		return /(^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^(()|(\d{3}\-))?(1[358]\d{9})$)/.test(telNumber)
	}	
}

*/