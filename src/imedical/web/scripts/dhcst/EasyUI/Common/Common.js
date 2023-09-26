/**
 * 模块:		药库
 * 子模块:		EasyUI公共
 * createdate:	2017-06-28
 * creator:		yunhaibao
 */

/// json数据写到对应name的插件
DHCSTEASYUI.JsonToComponent=function(_options){
	var jsonObj=_options.jsonData;
	$(".easyui-validatebox").each(function(){
		if (this.id!=""){
			var tmpValue=jsonObj[this.id];
			if (tmpValue!=undefined){
				$(this).val(tmpValue).validatebox('validate');
			}
		}					
	});
	$(".easyui-textbox").each(function(){
		if (this.id!=""){
			var tmpValue=jsonObj[this.id];
			if (tmpValue!=undefined){
				$(this).val(tmpValue);
			}
		}					
	});
	$(".easyui-numberbox").each(function(){
		if (this.id!=""){
			var tmpValue=jsonObj[this.id];
			if (tmpValue!=undefined){
				$(this).numberbox('setValue',tmpValue).numberbox("validate");
			}
		}					
	});
	$(".easyui-combobox").each(function(){
		var tmpValue=jsonObj[this.id];
		if (tmpValue!=undefined){
			$(this).combobox('setValue',tmpValue) //.validatebox('validate');
			var tmpCmbId=this.id+"_text";
			var tmpText=jsonObj[tmpCmbId];
			if (tmpText!=undefined){
				$(this).combobox('setText',tmpText)
			}
		}					
	});
	$(".dhcst-win-content input[type=checkbox]").each(function(){
		var tmpValue=jsonObj[this.id];
		if (tmpValue!=undefined){
			tmpValue=((tmpValue=="Y")||(tmpValue=="1"))?true:false;
			$(this).prop('checked',tmpValue);
		}
	})
	$(".dhcst-win-content .easyui-datebox").each(function(){
		var tmpValue=jsonObj[this.id];
		if (tmpValue!=undefined){
			$(this).datebox('setValue', tmpValue);
		}
	})
};
/// $.ajax封
DHCSTEASYUI.Ajax=function(_options){
	var Plugin="EasyUI.ComboBox";
	var url="DHCST.QUERY.JSON.csp?&Plugin="+Plugin+
			"&ClassName="+_options.ClassName+
			"&QueryName="+_options.QueryName+
			"&StrParams="+_options.StrParams;
	var options={
		type:"POST",
		data:"json",
		url:url,   
		error:function(){        
			alert("获取数据失败!");
		}
	}
	var tmpOptions={};
	var callFunction=_options.CallFunction
	if (callFunction){
		tmpOptions.success=function(jsonData){
			jsonData=JSON.parse(jsonData);
			var jsonObj=jsonData[0];
			eval(callFunction)({jsonData:jsonObj})
		}
	}
	var newOptions=$.extend({},options,tmpOptions);
	$.ajax(newOptions);
}

/// 获取按钮类型(A-增加,U-修改,D-删除,L-关联)
DHCSTEASYUI.GetModifyType=function(_options){
	var modifyType=_options;
	if (modifyType.indexOf("Add")>=0){
		return "A";
	}else if(modifyType.indexOf("Modify")>=0){
		return "U";
	}else if(modifyType.indexOf("Delete")>=0){
		return "D"
	}else if(modifyType.indexOf("Link")>=0){
		return "L"
	}else if(modifyType.indexOf("Save")>=0){
		return "S"
	}else if(modifyType.indexOf("Cancel")>=0){
		return "C"
	}
	return "";	
}

/// 验证,不完善,目前仅作药品信息维护用
/// params:_options(元素ID)
/// return:retVal(元素值),'required'(需要填写)
DHCSTEASYUI.ValidateValue=function(_options){
	var _id,retVal="";
	if (typeof _options == 'string'){
		_id=_options;
	}
	if (_id.indexOf("LOGON")>=0){
		return session[_id];
	}
	if (_id.indexOf("url")>=0){
		return eval(_id);
	}
	var $_id=$("#"+_id);
	if ($_id.html()==undefined){
		return "";
	}
	var _class=$_id.attr("class");
	if (_class==undefined){
		_class="";
	}
	if ($_id.attr("type")=="checkbox"){
		retVal=$_id.prop('checked')
		return retVal;
	}
	if (_class.indexOf("easyui-combobox")>=0){
		retVal=$_id.dhcstcomboeu('getValue');
		if ($_id.combobox('options').required==true){
			if (retVal==""){
				$.messager.alert("验证提示","请选择"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}
	}else if (_class.indexOf("easyui-numberbox")>=0){
		retVal=$_id.numberbox('getValue');
		if ($_id.validatebox('options').required==true){
			if (retVal==""){
				$.messager.alert("验证提示","请输入"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}	
	}else if (_class.indexOf("easyui-datebox")>=0){
		retVal=$_id.datebox('getValue');
	}else if (_class.indexOf("easyui-validatebox")>=0){
		retVal=$_id.val();
		if ($_id.validatebox('options').required==true){
			if (retVal==""){
				$.messager.alert("验证提示","请输入"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}
	}
	return retVal;
}

/// 对应基础平台功能元素授权设置
/// BDPAutDisableFlag为true时均为不可用
DHCSTEASYUI.Authorize=function(){
	$(".easyui-linkbutton,.easyui-combobox,.easyui-datebox,.easyui-numberbox,.easyui-validatebox").each(function(){
		var thisId=this.id;
		var thisClass=$(this).attr('class');
		if (BDPAutDisableFlag(thisId)==true){
			if (thisClass.indexOf("easyui-linkbutton")>=0){
				$(this).linkbutton('disable');
			}
			if (thisClass.indexOf("easyui-combobox")>=0){
				$(this).combobox('disable');
			}
			if (thisClass.indexOf("easyui-datebox")>=0){
				$(this).datebox('disable');
			}
			if (thisClass.indexOf("easyui-numberbox")>=0){
				$(this).attr('disabled', true);
			}
			if (thisClass.indexOf("easyui-validatebox")>=0){
				$(this).attr('disabled', true);
			}
		}	
	});
	$(".dhcst-win-content input[type=checkbox]").each(function(){
		var thisId=this.id;
		if (BDPAutDisableFlag(thisId)==true){
			$(this).attr('disabled',true);
		}	
	});		
}

/// 屏蔽键盘Backspace后退事件
DHCSTEASYUI.BanBackspace=function(e){
	var ev = e || window.event;
  	// 各种浏览器下获取事件对象
  	var obj = ev.relatedTarget || ev.srcElement || ev.target ||ev.currentTarget;
	if(ev.keyCode == 8){ 
		var tagName = obj.nodeName ;
		if(tagName!='INPUT' && tagName!='TEXTAREA'){
			return DHCSTEASYUI.BanKey(ev);
		}
		var tagType = obj.type.toUpperCase();
		if(tagName=='INPUT' && (tagType!='TEXT' && tagType!='TEXTAREA' && tagType!='PASSWORD')){
			return DHCSTEASYUI.BanKey(ev);
		}
		if((tagName=='INPUT' || tagName=='TEXTAREA') && (obj.readOnly==true || obj.disabled ==true)){
			return DHCSTEASYUI.BanKey(ev);
		}
	}
}

/// 屏蔽键盘事件
DHCSTEASYUI.BanKey=function(ev){
	if(ev.preventDefault ){
		//preventDefault()方法阻止元素发生默认的行为
		ev.preventDefault();
	}
	if(ev.returnValue){
		//IE浏览器下用window.event.returnValue = false;实现阻止元素发生默认的行为
		ev.returnValue = false;
	}
	return false;
}


