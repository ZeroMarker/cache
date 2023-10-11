/*$.extend($.fn.datagrid.defaults.editors, {
	linkbutton: {
		//{colHandler:desc}
	    init: function (_67b, _67c) {
	        var _67d = $("<a href='#'></a>").appendTo(_67b);
	        _67d.linkbutton(_67c);
	        _67d.click(_67c.handler);
	        return _67d;
	    }, destroy: function (_67e) {
	        $(_67e).linkbutton("destroy");
	    }, getValue: function (_67f) {
	        return $(_67f).linkbutton("options").text;
	    }, setValue: function (_680, _681) {
	        $(_680).linkbutton("options").text = _681;
	        $(_680).linkbutton({});
	    }, resize: function (_682, _683) {
	        //$(_682).linkbutton("resize", _683);
	    }
	},
	switchbox: {
		//{colHandler:desc}
	    init: function (_67b, _67c) {
	        var _67d = $("<div href='#'></div>").appendTo(_67b);
	        _67d.switchbox(_67c);
	        return _67d;
	    }, destroy: function (_67e) {
	        $(_67e).switchbox("destroy");
	    }, getValue: function (_67f) {
	        return $(_67f).switchbox("getValue");
	    }, setValue: function (_680, _681) {
	        //$(_680).switchbox("setActive",false);
	        var flag = false;
	        if (_681==1 || _681=='Y' || _681=='true' || _681===true || _681=="on"){ flag=true }
	        $(_680).switchbox("setValue",flag,false);
	        //$(this).find(inputSelector).prop('checked', value).trigger('change', skipOnChange);
	        //$(_680).switchbox("setActive",true);
	    }, resize: function (_682, _683) {
	        //$(_682).linkbutton("resize", _683);
	    }
	}
});*/

/***
* @param id {String|jQueryObj} Ԫ��id
* @return ����Ԫ�ص�ֵ
*/
function getValueById(id){
	var result=""
	var obj=document.getElementById(id);
	if (!obj) return ""
	var jObj;
	if (typeof id == "string"){
		jObj = jQuery("#"+id);
	}else{
		jObj = id;
	}
	result=jObj.val()
	if (jObj[0].tagName=="INPUT"){
		var objType=jObj.prop("type");
		var objClassInfo=jObj.prop("class");
		if (objType=="checkbox"){
			//result=jObj.is(':checked')
			result = jObj.checkbox("getValue");
		}else if (objType=="select-one"){
			result=jObj.combobox("getValue");
		}else if (objType=="text"){
			if (objClassInfo.indexOf("combogrid")>=0){
				result=jObj.combogrid("getText");
			}else if (objClassInfo.indexOf("datebox-f")>=0){
				result=jObj.datebox('getValue')
			}else if (objClassInfo.indexOf("combobox")>=0){
				result=jObj.combobox("getValue");
			}else if(objClassInfo.indexOf("number")>=0){
				result=jObj.numberbox("getValue");
			}
		}
	}else if(jObj[0].tagName=="SELECT"){
		var objClassInfo=jObj.prop("class");
		if (objClassInfo.indexOf("combogrid")>=0){
			result=jObj.combogrid("getText");
		}else if (objClassInfo.indexOf("combobox")>=0){
			result=jObj.combobox("getValue");
		}
	}else if(jObj[0].tagName=="LABEL"){
		result = jObj.text();
		
	}else if(jObj[0].tagName=="A"){  //��ť�޸���ʾֵ 2018-07-23
		result = jObj.find(".l-btn-text").text();
	}
	return result
}
/**
* @param id {String|jObjectObj}
* @param vValue {String} 
**/
function setValueById(id,vValue)
{
	var result=""
	var obj=document.getElementById(id);
	if (obj){
		var jObj;
		if (typeof id == "string"){
			jObj = jQuery("#"+id);
		}else{
			jObj = id;
		}
		if (jObj[0].tagName=="INPUT"){
			var objType=jObj.prop("type")
			var objClassInfo=jObj.prop("class")
			if (objType=="checkbox"){
				if ((vValue=="1")||(vValue==true)||(vValue=="Y")){
					jObj.checkbox("setValue",true);  
				}else{
					jObj.checkbox("setValue",false);
				}
			}else if (objType=="text"){
				if (objClassInfo.indexOf("combogrid")>=0){
					//jQuery("#"+id).combogrid('setText',vValue);
					jObj.combogrid('setValue',vValue); 
				}else if (objClassInfo.indexOf("datebox-f")>=0){
					jObj.datebox('setValue',vValue);  
				}else if (objClassInfo.indexOf("combobox")>=0){
					jObj.combobox('setValue',vValue);
				}else if(objClassInfo.indexOf("number")>=0){
					result=jObj.numberbox("setValue",vValue);
				}else{
					jObj.val(vValue); 
				}
			}else{
				jObj.val(vValue);
			}
			 //add by 2018-08-10 begin
			if (objClassInfo.indexOf("validatebox-invalid")>=0)
			{
				jObj.validatebox("validate");
			}
			 //add by 2018-08-10 end
		}else if(jObj[0].tagName=="SELECT"){
			var objClassInfo=jObj.prop("class");
			if (objClassInfo.indexOf("combogrid")>=0){
				jObj.combogrid('setValue',vValue);
			}else if (objClassInfo.indexOf("combobox")>=0){
				jObj.combobox('setValue',vValue);
			}
			 //add by 2018-08-10 begin
			if (objClassInfo.indexOf("validatebox-invalid")>=0)
			{
				jObj.validatebox("validate");
			}
			 //add by 2018-08-10 end
			
		}else if(jObj[0].tagName=="LABEL"){ // �к���,���ǲ���,ֻ�޸���ʾ�ı�
			if(jObj.html().indexOf('<span style="color:red">*</span>')>-1){
				jObj.html('<span style="color:red">*</span>'+vValue);
			}else{
				jObj.html(vValue);
			}
		}else if(jObj[0].tagName=="A"){  //��ť�޸���ʾֵ 2018-07-23
			jObj.find(".l-btn-text").text(vValue);
		}else {//hidden areatext
			jObj.val(vValue)  
		}
	}
	return jObj;
}
/**
* @param id {String|jQueryObj}
* @param delay
* @other ��궨�嵽ĳ�����
**/
function focusById(id,delay){
	var jObj;
	if (typeof id == "string"){
		jObj = jQuery("#"+id);
	}else{
		jObj = id;
	}
	if (jObj.is(":hidden")){
		jObj.next("span").find("input").focus();
	}else{
		jObj.focus();
	}
	return jObj;
}
/**
* @param id {String|jQueryObj}
*/
function disableById(id){
	var jObj;
	if (typeof id == "string"){
		jObj = jQuery("#"+id);
	}else{
		jObj = id;
	}
	if (jObj.hasClass("l-btn")){
		jObj.linkbutton("disable");
	}else if (jObj.hasClass("combogrid-f")){
		jObj.combogrid("disable");
	}else if (jObj.hasClass("combobox-f")){
		jObj.combobox("disable");
	}else if (jObj.hasClass("datebox-f")){
		jObj.datebox("disable");
	}else if (jObj.hasClass("timespinner-f")){
		jObj.timespinner("disable");
	}else if(jObj.hasClass("lookup-text")){
		jObj.lookup("disable"); //2018-07-23  �Ŵ�
	}else{
		jObj.prop("disabled",true);
	}
	return jObj;	
}
/**
* @param id {String|jQueryObj}
*/
function enableById(id){
	var jObj;
	if (typeof id == "string"){
		jObj = jQuery("#"+id);
	}else{
		jObj = id;
	}
	if (jObj.hasClass("l-btn")){
		jObj.linkbutton("enable");
	}else if (jObj.hasClass("combogrid-f")){
		jObj.combogrid("enable");
	}else if (jObj.hasClass("combobox-f")){
		jObj.combobox("enable");
	}else if (jObj.hasClass("datebox-f")){
		jObj.datebox("enable");
	}else if (jObj.hasClass("timespinner-f")){
		jObj.timespinner("enable");
	}else if(jObj.hasClass("lookup-text")){
		jObj.lookup("enable"); //2018-07-23  �Ŵ�
	}else{
		jObj.prop("disabled",false);
	}
	return jObj;		
}
function getEditorCell(rowIndex,fieldName,dataGridId){
	var panel ;
	if (typeof dataGridId!=="undefined"){
		panel = $("#"+dataGridId).datagrid("getPanel");
	}else{
		panel = $(document.body);
	}
	var obj = panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+rowIndex+"] td[field="+fieldName+"] input");
	return obj;
}
/*
* @param rowIndex {Number} ������0��ʼ
* @param fieldName {String}
* @param dataGridId {String}  �����ǰ����ֻ��һ��datagridʱ����Ϊ��
* @other ���ص�Ԫ���ڱ༭Ԫ��ֵ
*/
function getColumnValue(rowIndex, fieldName,dataGridId){
	var rtn = "";
	var obj = getEditorCell(rowIndex, fieldName,dataGridId)
	if (obj.attr("type")=="checkbox") {
		rtn = obj.prop("checked");
		if(rtn) {rtn=1;}else{rtn=0;}
	}else{
		rtn = obj.val();
	}
	return rtn;
}
/*
* @param rowIndex {Number} ������0��ʼ
* @param fieldName {String}
* @param cmpName {String}  �����ǰ����ֻ��һ�����ʱ����Ϊ��
* @other ���ص�ǰ����б�Ԫ���ڱ༭Ԫ��ֵ 
*/
function getCmpColumnValue(rowIndex, fieldName,cmpName){
	return getColumnValue(rowIndex,fieldName,"t"+cmpName);
}

/*
* @param rowIndex {Number} ������0��ʼ
* @param fieldName {String}
* @param value {String|Number} �����checkboxֵΪ0��1
* @param dataGridId {String}  �����ǰ����ֻ��datagridʱ����Ϊ��
* @other ���ص�ǰgrid�б�Ԫ���ڱ༭Ԫ��ֵ 
*/
function setColumnValue(rowIndex, fieldName,value,dataGridId){
	var obj = getEditorCell(rowIndex, fieldName,dataGridId)
	if (obj.attr("type")=="checkbox") {
		obj.prop("checked",value);
	}else{
		obj.val(value);
	}
	return obj;
}
/*
* @param rowIndex {Number} ������0��ʼ
* @param fieldName {String}
* @param value {String|Number} �����checkboxֵΪ0��1
* @param cmpName {String}  �����ǰ����ֻ��һ�����ʱ����Ϊ��
* @other ���ص�ǰ����б�Ԫ���ڱ༭Ԫ��ֵ 
*/
function setCmpColumnValue(rowIndex, fieldName,value,cmpName){
	return setColumnValue(rowIndex, fieldName,value,"t"+cmpName);
}
/**
* @param id {String}  Ԫ��id
* @parma flag {Boolean} �Ƿ����
* ��̬����ĳ���Ԫ��Ϊ����
* ���ñ���ʱ,���ǲ��ظ�����
* ���÷Ǳ���ʱ,ɾ������
*/
function setItemRequire(id,flag){
	if(flag){
		$("#"+id).attr("data-required",true).attr("title","������");
		if ($("#c"+id+">span").length==0) $('<span style="color:red">*</span>').prependTo("#c"+id);
	}else{
		$("#"+id).attr("data-required",false);
		$("#c"+id+">span").remove();
	}
}
/**
* ��֤��ǰ��������� ����������������data-required="true"
*/
function validateRequired(){
	var errorNum = 0,errorIdArr=[];
	$('[data-required="true"]').each(function(ind,item){
		var _t = $(this);
		var id = _t.attr("id");
		var val = getValueById(id);
		if (val=="" || typeof val === 'undefined'){
			if (this.tagName!="TEXTAREA"){
				$("#"+id+",#"+id+"+span>.validatebox-text").addClass("validatebox-invalid");
			}
			errorNum++;
			errorIdArr.push(id);
		}
	});
	if (errorIdArr.length>0) {focusById(errorIdArr[0]);}
	return errorIdArr.join("^");
}
//websys_lu('websys.csp?TEVENT=t54369iTest&&USERNAME=&SessionId=Tba68W8MC8',false,'title='title',width=980,height=650,left=130,top=3');return false;
/*websys_lubak = websys_lu;
/** websys_showModal({url:'http://www.baidu.com',title:'����iMedical',width:860,height:592});
 * websys_showModal({title:'����iMedical',content:'��������',width:860,height:592});*/
// opt��left��topΪ��ʱ,�������ھ���
/*
function websys_lu(url,lookup,opt){
	opt=opt||"";
	//if (opt!="") eval("var "+opt);
	var obj={};
	var arr = opt.split(",");
	$.each(arr,function(ind,item){
		var itemArr = item.split("=");
		obj[itemArr[0]]=itemArr[1];
	});
	if ("undefined"==typeof obj.title){obj.title=document.title;}
	if ("undefined"==typeof obj.width){obj.width=300;}
	if ("undefined"==typeof obj.height){obj.height=380;}
	if ("undefined"==typeof obj.top){obj.top="";}
	if ("undefined"==typeof obj.left){obj.left="";}
	if(websys_showModal){
		websys_showModal({url:url,title:obj.title,width:obj.width,height:obj.height,top:obj.top,left:obj.left});
	}else{
		websys_lubak(url,lookup,opt);
	}	
}*/