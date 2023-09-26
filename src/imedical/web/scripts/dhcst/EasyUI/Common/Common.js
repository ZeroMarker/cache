/**
 * ģ��:		ҩ��
 * ��ģ��:		EasyUI����
 * createdate:	2017-06-28
 * creator:		yunhaibao
 */

/// json����д����Ӧname�Ĳ��
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
/// $.ajax��
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
			alert("��ȡ����ʧ��!");
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

/// ��ȡ��ť����(A-����,U-�޸�,D-ɾ��,L-����)
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

/// ��֤,������,Ŀǰ����ҩƷ��Ϣά����
/// params:_options(Ԫ��ID)
/// return:retVal(Ԫ��ֵ),'required'(��Ҫ��д)
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
				$.messager.alert("��֤��ʾ","��ѡ��"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}
	}else if (_class.indexOf("easyui-numberbox")>=0){
		retVal=$_id.numberbox('getValue');
		if ($_id.validatebox('options').required==true){
			if (retVal==""){
				$.messager.alert("��֤��ʾ","������"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}	
	}else if (_class.indexOf("easyui-datebox")>=0){
		retVal=$_id.datebox('getValue');
	}else if (_class.indexOf("easyui-validatebox")>=0){
		retVal=$_id.val();
		if ($_id.validatebox('options').required==true){
			if (retVal==""){
				$.messager.alert("��֤��ʾ","������"+$_id.closest('td').prev().html().trim(),"warning");
				return 'required';
			}
		}
	}
	return retVal;
}

/// ��Ӧ����ƽ̨����Ԫ����Ȩ����
/// BDPAutDisableFlagΪtrueʱ��Ϊ������
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

/// ���μ���Backspace�����¼�
DHCSTEASYUI.BanBackspace=function(e){
	var ev = e || window.event;
  	// ����������»�ȡ�¼�����
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

/// ���μ����¼�
DHCSTEASYUI.BanKey=function(ev){
	if(ev.preventDefault ){
		//preventDefault()������ֹԪ�ط���Ĭ�ϵ���Ϊ
		ev.preventDefault();
	}
	if(ev.returnValue){
		//IE���������window.event.returnValue = false;ʵ����ֹԪ�ط���Ĭ�ϵ���Ϊ
		ev.returnValue = false;
	}
	return false;
}


