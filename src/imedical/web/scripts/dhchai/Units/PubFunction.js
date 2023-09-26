/*HISUI����js*/
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

//��õ�ǰ���ڸ�ʽ����
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

//���ڸ�ʽ
function GetDateFormat() {
	if (dtformat==0) {
		var DateFormat = 'YMD';
	}else {
		var DateFormat = $m({                  
			ClassName:"DHCMed.SSService.CommonCls",
			MethodName:"GetDateFormat"
		},false);
	}
	return DateFormat;
}

//�������� ʱ��
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

//�������� 
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

//ʱ�� myDate.toLocaleTimeString()
function Common_GetTime(date){
	var h = date.getHours();
	var m= date.getMinutes();
	var s = date.getSeconds();
	return h+':'+(m<10?('0'+m):m)+':'+(s<10?('0'+s):s);
}


// �ж����ڴ�С
function  Common_CompareDate(startDate,endDate){
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return -1;
	} 
	// ת��Ϊ��̨���ݿ��ʽ
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
// �ж�ʱ�䳬�������� true:������
function checkThreeTime(startDate,endDate){
	//var time1 = new Date(startDate).getTime();
	//ʱ���ʽͳһ
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
	//�ж�ʱ�����Ƿ����3����
	var flag = true;
	if(arr1[0] == arr2[0]){//ͬ��
	    if(arr2[1]-arr1[1] > 3){ //�¼������3����
	        flag = false;
	    }else if(arr2[1]-arr1[1] == 3){ //�����3���£��Ƚ���
	        if(arr2[2] > arr1[2]){ //�������ڵ��մ��ڿ�ʼ���ڵ���
	            flag = false;
	        }
	    }
	}else{ //��ͬ��
	    if(arr2[0] - arr1[0] > 1){
	        flag = false;
	    }else if(arr2[0] - arr1[0] == 1){
	        if(arr1[1] < 10){ //��ʼ����·�С��10ʱ������Ҫ����
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] < 12){ //���������3����
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] == 12){ //�����3���£��Ƚ���
	            if(arr2[2] > arr1[2]){ //�������ڵ��մ��ڿ�ʼ���ڵ���
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

//Query�����ֵ乫������(ȡֵ��ID)
function Common_ComboDicID() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //�Ƿ��ʼ��ֵ
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //����������������ֵ����ݣ�С�ֵ�ͳһ������༭
			defaultFilter:4,       //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
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
			valueField: 'ID',
			textField: 'DicDesc'
		});	
	}	
	return;
}


//��ѡ�ֵ�ȡֵ Common_CheckboxValue("chkStatusList")
function Common_CheckboxValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).val()+ ","; 
	});
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}

//��ѡ�ֵ�ȡֵ(label��������) Common_CheckboxText("chkStatusList")
function Common_CheckboxLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).attr("label")+ ","; 
	});
	
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}

//��ѡ�ֵ�ȡֵ
function Common_RadioValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = $(this).val(); 
	});
	return value;
}
//��ѡ�ֵ�ȡֵ(label��������)
function Common_RadioLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
		  value = $(this).attr("label");
	});
	return value;
}

//�ı������������ַ�����
//oninput �� HTML5 �ı�׼�¼������ڼ�� textarea, input:text, input:password �� input:search �⼸��Ԫ��ͨ���û����淢�������ݱ仯�ǳ�����
CheckSpecificKey = function(){ 
	$('input').bind('input propertychange', function() {
		var value = $(this).val();
		var specialKey = "^";       //�����ַ�list
		for (var i = 0; i < value.length; i++) {
			var realkey=value.charAt(i);
			if (specialKey.indexOf(realkey) >= 0) {
				$(this).val($(this).val().replace(realkey,""));  //�滻�����ַ�
				//layer.alert('�������������ַ�: ' + realkey,{icon: 0});
			}
		}
	});
}

/**
*���ֵ��÷�ʽ
*var template1="����{0}������{1}��";
*var template2="����{name}������{age}��";
*var result1=template1.format("loogn",22);
*var result2=template2.format({name:"loogn",age:22});
*�����������"����loogn������22��"
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
                    //var reg = new RegExp("({[" + i + "]})", "g");//�������������9ʱ��������
                    var reg = new RegExp("({)" + i + "(})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
    }
    return result;
};

//add by jiangpengpeng
//IE8�����鲻֧��IndexOf����
//�������IndexOf����
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

// ��ҳ���ݵĲ���(��ѯ���浼�������õ�)
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	//  �ж������Ƿ�������
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
	var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

//��ò������csp����
var cspUrl = $m({                  
	ClassName:"DHCHAI.BT.Config",
	MethodName:"GetValByCode",
	aCode:"SYSEmrCSP",
	aHospID:""
},false);

if (!cspUrl) {
	var cspUrl = $m({                  
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSEmrCSP",
		aHospID:""
	},false);
}
