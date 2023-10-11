var LINK_CSP="dhcapp.broker.csp";
//��ǰ����
var editIndex = undefined;
var charCode1=String.fromCharCode(1);
var charCode2=String.fromCharCode(2);
var charCode3=String.fromCharCode(3);

/**
 * �����к�̨����:HISUI���е��ú�̨�ķ������ʹ����HISUI����ķ���Ҫȥ��
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص�����
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
if(!typeof $.cm=="function"){
	runClassMethod=function (className,methodName,datas,successHandler,datatype,sync){
		var _options = {
			url : LINK_CSP,
			async : true,
			dataType : "json", // text,html,script,json
			type : "POST",
			data : {
					'ClassName':className,
					'MethodName':methodName
				   }
		};
		$.extend(_options.data, datas);
		var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
		_options=$.extend(_options, option);
		return $.ajax(_options).done(successHandler);
	}
	
	serverCall=function(className,methodName,datas){
		ret=runClassMethod(className,methodName,datas,function(){},"",false)
		return ret.responseText;
	}
}
/**
 * ����datagrid����
 * @creater zhouxin
 * @param className ������
 * @param methodName ������
 * @param gridid datagrid��id
 * @param handle �ص�����
 * @param ����ֵ����
 * saveByDataGrid("web.DHCAPPPart","find","#datagrid",function(data){ alert() },"json")	 
 */
function saveByDataGrid(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");
	//alert(params)
	runClassMethod(className,methodName,{'params':params},handle,datatype)
}

//�ж�grid�Ƿ�༭���
function endEditing(datagridid){
	if (editIndex == undefined){return true}
	if ($(datagridid).datagrid('validateRow', editIndex)){
		$(datagridid).datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		$(datagridid).datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
		return false;
	}
}
//�༭���¼�
function CommonRowClick(index,row,datagridid){
	//if (editIndex != index){  //hxy
		if (endEditing(datagridid)){
			$(datagridid).datagrid('selectRow', index).datagrid('beginEdit', index)
			editIndex = index;
		} else {
			$(datagridid).datagrid('selectRow', editIndex);
		}
	//}   //hxy
}
/**
 * ������ѯ����
 * @creater zhouxin
 * @param _options.formid  ��ѯ����form��id
 * @param _options.datagrid ��ѯ��datagrid��id
 * commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})	 
 */
function commonQuery(_options){
	$(_options.datagrid).datagrid('load',loopBlock(_options.formid));
}
/**
 * �������÷���
 * @creater zhouxin
 * @param _options.formid  ��ѯ����form��id
 * @param _options.datagrid ��ѯ��datagrid��id
 * commonReload({'datagrid':'#datagrid','formid':'#queryForm'})	 
 */
function commonReload(_options){
	$(_options.formid).form("clear");
	$(_options.datagrid).datagrid('load',loopBlock(_options.formid));
}
/**
 * ���ò���һ�еķ���
 * @creater zhouxin
 * @param _options.datagrid  ����datagrid��id
 * @param _options.value  �²����е�Ĭ��ֵ
 */
function commonAddRow(_options){
	
	if(endEditing(_options.datagrid)){
		value=$.extend({},_options.value);
		$(_options.datagrid).datagrid('insertRow',{index:0, row: value}).datagrid('beginEdit', 0);
		$(_options.datagrid).datagrid('selectRow', 0);//hxy
		editIndex=0;
	}
}
/**
 * ƴװform�������в�����Ϊjson��
 * @creater zhouxin
 * @param container  ��ѯform��id
 */
function loopBlock(container){
		var attrs = {}; // ���صĶ���
		var gettedNames = []; // �����������������
		var target = $(container);

		// combo&datebox
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboName]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboName');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							var val = jQuery(this)[type]('getValues');
							extendJSON(name, val);
						} else {
							var val = jQuery(this)[type]('getValue');
							extendJSON(name, val);
						}
						break;
					}
				}
			});
		}
		// radio&checkbox
		var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
					iptsNames.push(name);
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
				var type = iptsFlts.eq(0).attr('type');
				if(type === 'radio') {
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							extendJSON(iptsNames[i], jQuery(this).val());
							return false;
						}
					});
				} else if(type === 'checkbox') {
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
						}
					});
					extendJSON(iptsNames[i], vals);
				}
			}
		}
		// numberbox&slider
		var cTypes = ['numberbox', 'slider'];
		for(var i=0;i<cTypes.length;i++) {
			ipts = jQuery("input["+cTypes[i]+"name]", target);
			if(ipts.length){
				ipts.each(function(){
					var name = jQuery(this).attr(cTypes[i]+'Name');
					if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
						return true;
					}
					var val = jQuery(this)[cTypes[i]]('getValue');
					extendJSON(name, val);
				});
			}
		}
		// multiselect2side
		ipts = jQuery(".multiselect2side", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipDisabled && $(this).next('.ms2side__div').find(':disabled').length) {
					return true;
				}
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this)['multiselect2side']('getValue');
				extendJSON(name, val);
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				if(skipNames && -1!==jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		// function
		function extendJSON(name, val) {
			if(!name) return;
			if(-1 !== $.inArray(name, gettedNames)) {
				// ֻ��ȡ��һ��name��ֵ
				return;
			} else {
				gettedNames.push(name);
			}
			val = 'undefined'!==typeof(val)? val:'';
			var newObj = eval('({"'+name+'":'+jQuery.toJSON(val)+'})');
			jQuery.extend(attrs, newObj);
		}
		return attrs;
	};	

function loopStr(container){
		var ret=new Array()
		var target = $(container);
		// validatebox&input&textarea
		ipts = jQuery("input[name], textarea[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = $.trim(jQuery(this).val());
				var type=jQuery(this).attr('type')
				if(val.length>0){
	
					if((type=="input")&&(jQuery(this).is(":visible"))){
						ret.push(name+":"+val);
					}
					if((type=="textarea")&&(jQuery(this).is(":visible"))){
						ret.push(name+":"+val);
					}
				}
			});
		}
		// select
		ipts = jQuery("select[name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr('name');
				var val = jQuery(this).val();
				ret.push(name+":"+val);
			});
		}
		
		// combo&datebox
		/**
		$(".combo-value").each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			if(val.length>0){
				ret.push(name+":"+val);
			}
		})
		*/
		var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
		var ipts = jQuery('[comboname]', target);
		if (ipts.length){
			ipts.each(function(){
				for(var i=0; i<cbxCls.length; i++){
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboname');
					if (jQuery(this).hasClass(type+'-f')){
						if (jQuery(this)[type]('options').multiple){
							var val = jQuery(this)[type]('getValues');
							//val=val.replace(/:/g," ") sufan 2019-11-12
							if(val.length>0){
								ret.push(name+":"+val);
							}
						} else {
							var val = jQuery(this)[type]('getValue');
							//val=val.replace(/:/g," ")
							if(val.length>0){
								ret.push(name+":"+val);
							}
						}
						break;
					}
				}
			});
		}
	
		
		// radio
		var ipts = jQuery("input[name][type=radio]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				
				if((jQuery(this).attr("data-type")==undefined)||("radio-input"==jQuery(this).attr("data-type"))){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							//ret.push(iptsNames[i]+":"+jQuery(this).val());
							ret.push(jQuery(this).attr("data-id")+":"+jQuery(this).val());
							return false;
						}
					});
			
			}
		}
		//checkbox
		var ipts = jQuery("input[name][type=checkbox]:checked", target);
		if(ipts.length) {
			var iptsNames = [];
			ipts.each(function(){
				if(jQuery(this).attr("data-type")==undefined){ 
					var name = jQuery(this).attr('name');
					if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
						iptsNames.push(name);
					}
				}
			});
			for(var i=0;i<iptsNames.length;i++) {
				var iptsFlts = ipts.filter('[name="'+iptsNames[i]+'"]');
					var vals = [];
					iptsFlts.each(function(){
						if(jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
						}
					});
					ret.push(iptsNames[i]+":"+vals.join(","));
				
			}
		}
		if(typeof($("#picPath").val()) != "undefined"){
			if($("#picPath").val().length>0){
				ret.push($("#picPath").attr('name')+":"+$("#picPath").val());
			}
		}
		return ret.join("^");	
}
// ��Date����չ���� Date ת��Ϊָ����ʽ��String   
// ��(M)����(d)��Сʱ(h)����(m)����(s)������(q) ������ 1-2 ��ռλ����   
// ��(y)������ 1-4 ��ռλ��������(S)ֻ���� 1 ��ռλ��(�� 1-3 λ������)   
// ���ӣ�   
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423   
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18   
Date.prototype.Format = function(fmt)   
{ //author: meizz   
  var o = {   
    "M+" : this.getMonth()+1,                 //�·�   
    "d+" : this.getDate(),                    //��   
    "h+" : this.getHours(),                   //Сʱ   
    "m+" : this.getMinutes(),                 //��   
    "s+" : this.getSeconds(),                 //��   
    "q+" : Math.floor((this.getMonth()+3)/3), //����   
    "S"  : this.getMilliseconds()             //����   
  };   
  if(/(y+)/.test(fmt))   
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));   
  for(var k in o)   
    if(new RegExp("("+ k +")").test(fmt))   
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));   
  return fmt;   
}



/**
 * 
 * @creater zhouxin
 * @func getFieldPos  ��ȡ��ǰ���λ��
 * @func insertPos   ���ƶ�λ�ò����ı�
 */
$(function(){
    /*
     * �ı��������
     */
    $.fn.extend({
        /*
         * ��ȡ�������λ��
         */
        getFieldPos:function(){
            var field=this.get(0);
            if(document.selection){
                //IE
                $(this).focus();
                var sel=document.selection;
                var range=sel.createRange();
                var dupRange=range.duplicate();
                dupRange.moveToElementText(field);
                dupRange.setEndPoint('EndToEnd',range);
                field.selectionStart=dupRange.text.length-range.text.length;
                field.selectionEnd=field.selectionStart+ range.text.length;
            }
            return field.selectionStart;
        },
        insertPos:function(pos,value){
	        s=$(this).val()
        	$(this).val(s.substring(0, pos)+value+s.substring(pos))
        }
    })
 }) 
 
 ///˧����ĳ˼�js���� 2016-12-01 huaxiaoying
//˵����javascript�ĳ˷������������������������˵�ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ĳ˷������ 
//���ã�accMul(arg1,arg2) 
//����ֵ��arg1����arg2�ľ�ȷ��� 
function accMul(arg1,arg2) 
{ 
	var m=0,s1=arg1.toString(),s2=arg2.toString(); 
	try{m+=s1.split(".")[1].length}catch(e){} 
	try{m+=s2.split(".")[1].length}catch(e){} 
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m) 
} 
//��Number��������һ��mul�����������������ӷ��㡣 
Number.prototype.mul = function (arg){ 
	return accMul(arg, this); 
} 

//���� 
//Js���� 
//˵����javascript�ĳ�����������������������������ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ĳ�������� 
//���ã�accDiv(arg1,arg2) 
//����ֵ��arg1����arg2�ľ�ȷ��� 
function accDiv(arg1,arg2){
	var t1=0,t2=0,r1,r2; 
	try{t1=arg1.toString().split(".")[1].length}catch(e){}
	try{t2=arg2.toString().split(".")[1].length}catch(e){}

	with(Math){
//		r1=Number(arg1.toString().replace(".","")) 
//		r2=Number(arg2.toString().replace(".",""))
//		return (r1/r2)*pow(10,t2-t1);
		//var m=pow(10,max(t1,t2));
		var m=pow(10,t1+t2);
		r1=Number(arg1)*m;
		r2=Number(arg2)*m;
		return r1/r2;
	} 
}
//��Number��������һ��div�����������������ӷ��㡣 
Number.prototype.div = function (arg){
	return accDiv(this, arg); 
}

//�ӷ������������õ���ȷ�ļӷ����
//˵����javascript�ļӷ������������������������ӵ�ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ļӷ������
//���ã�accAdd(arg1,arg2)
//����ֵ��arg1����arg2�ľ�ȷ���
function accAdd(arg1,arg2){
    var r1,r2,m;
    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
    //m=Math.pow(10,Math.max(r1,r2))
    m=Math.pow(10,r1+r2)
    return (arg1*m+arg2*m)/m
}

//��Number��������һ��add�����������������ӷ��㡣
Number.prototype.add = function (arg){
    return accAdd(arg,this);
}

 
/**
 * ����datagrid����
 * @creater zhouxin
 * @param entity ʵ��������
 * @param gridid datagrid��id
 * @param handle �ص�����
 * @param ����ֵ����
 * comSaveByDataGrid("User.DHCPueEmrCommon","#datagrid",function(data){ alert() },"json")	 
 */
function comSaveByDataGrid(entity,gridid,handle,datatype,hosp){
	if(!endEditing(gridid)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			var field=fileds[j];
			var value=typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]];
			rowData.push(field+String.fromCharCode(1)+value)
		}
		dataList.push(rowData.join(charCode2));
	} 
	var params=dataList.join(charCode3); 
	//alert(params)
	var fun;
	if((typeof handle)=='function'){
		fun=handle
	}else{
		fun=function(data){
			if(data==0){
				$.messager.alert('��ʾ','����ɹ�');
				$(gridid).datagrid('reload');
			}else{
				if(5521==data){
					$.messager.alert('��ʾ','����ʧ��:����,���������ظ�')	
				}else{
					$.messager.alert('��ʾ','����ʧ��:'+data)
				}
				
			}
		};	
	}
	if((typeof datatype)=='undefined'){
		datatype="json" 
	}
	runClassMethod("web.DHCADVModel","Save",{entity:entity,'params':params,'hosp':hosp},fun,datatype)
}
/**
 * ɾ��datagrid��¼ͨ�÷���
 * @creater zhouxin
 * @param entity 			|�����ƣ�User.DHCPueEmrTypeCon
 * @param gridid            |gridid��datagrid��id
 *
 * @demo  removeCom("User.DHCPueEmrTypeCon","1^2")	 
 */
function removeCom(entity,gridid){
	var rowsData = $(gridid).datagrid('getSelections')
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ��!");
		return;	
	}
	var idsArr=[]
	for(var i=0; i<rowsData.length; i++){
		idsArr.push(rowsData[i].ID);
	}
	removeEntity(entity,idsArr.join("^"),function(){$(gridid).datagrid('reload')});
}

/**
 * ɾ�����¼ͨ�÷���
 * @creater zhouxin
 * @param entity 			|�����ƣ�User.DHCPueEmrTypeCon
 * @param parStr            |��������id1_^_id2
 * @param successHandler    |�ص�����
 *
 * @demo  removeEntity("User.DHCPueEmrTypeCon","1^2")	 
 */
function removeEntity(entity,idStr,handler){
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ����", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVModel",
				    "removeBath",
					{
		 				'idStr':idStr,
		 				'entity':entity
		 			},
		 			function(data){
			 			if(data.code!=0){
				 			$.messager.alert("��ʾ","����ʧ��!"+data.msg);
				 		}else{
					 		if((typeof handler)=='function'){
								handler();
							} 
					 	}
					});
            } 
    }); 
}
/**
 * ������߸��±�ͨ�÷���
 * @creater zhouxin
 * @param entity 			|�����ƣ�User.DHCPueEmrTypeCon
 * @param parStr            |���������ֶ�����_$c(1)_ֵ
 *                                   ����ֶ�ֵ��$c(2)�ָ�
 *                                   ������¼��$c(3)�ָ�
 * @param saveType          |�������ͣ� 
 *                                   1:����ȫ���ֶΣ�δ������ֵ����Ϊ��
 *                                   2:���´����ֶΣ�δ������ֵ䲻���� 
 * @param successHandler    |�ص�����
 *
 * @demo  saveEntity("User.DHCPueEmrTypeCon","ID$c(1)1",function(data){ alert() })	 
 */
function saveEntity(entity,parStr,saveType,handler){
	var type=(typeof(saveType) == undefined)?1:saveType;
	var fun;
	if((typeof handler)=='function'){
		fun=handler
	}else{
		fun=function(data){
			if(data==0){
				$.messager.alert('��ʾ','����ɹ�');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
		};	
	}
	runClassMethod("web.DHCADVModel","Save",{'entity':entity,'params':parStr,'saveType':type},fun)	 
}


/**
* @datagrid���Ƿ���
* @param 	value 	 	|string 	|ֵ
*						Y:��
*						N:��   
* @author zhouxin
*/
function FormatterYN(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>��</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>��</font>"
  }else{
    return "";
  }
}


function ExportTableToExcel(fileName,html){
	  if (!!window.ActiveXObject || "ActiveXObject" in window){
			  var table = document.createElement("table");
			  table.style.display='none';
			  table.innerHTML=html
		      document.body.appendChild(table);
		      var oXL = new ActiveXObject("excel.Application");
			  //oXL.Visible = true;
		      var oWB = oXL.Workbooks.Add;
        	  var oSheet = oWB.ActiveSheet;
        	  var xlsheet = oWB.Worksheets(1);
		      var oRangeRef = document.body.createTextRange();
              oRangeRef.moveToElementText(table);
              oRangeRef.execCommand("Copy");
              oSheet.cells(1,1).select;
              oSheet.Paste();    //�˷�ʽΪֱ��ճ��������ʽ
		      oXL.Selection.CurrentRegion.Select;            //ѡ��ǰ����
        	  oXL.Selection.Interior.Pattern = 0;            //���õ�ɫΪ��
        	  oXL.Selection.Borders.LineStyle = 1;        //���õ�Ԫ��߿�Ϊʵ��
        	  oXL.Selection.ColumnWidth = 5;                //�����п�
        	  oXL.Selection.RowHeight = 16;                //�и�
 			  oXL.Selection.WrapText = true;
        	  oXL.Selection.Columns.AutoFit;                //�п��Զ���Ӧ
		      document.body.removeChild(table);
		      
            //ճ�������EXCEL��
            //oXL.Visible = true;
            //����excel�ɼ�����

            try {
                var fname = oXL.Application.GetSaveAsFilename(fileName, "Excel Spreadsheets (*.xls), *.xls");
            } catch (e) {
                print("Nested catch caught " + e);
            } finally {
	            if(fname==false){return}
                oWB.SaveAs(fname);
				///oXL.UserControl = true;
                oWB.Close(savechanges = false);
                //xls.visible = false;
                oXL.Quit();
                oXL = null;
                //����excel���̣��˳����
                //window.setInterval("Cleanup();",1);
                idTmr = window.setInterval("Cleanup();", 1);
            }
       }else{
		tableToExcel(fileName,html)
	  }     
}

var tableToExcel = (function() {
      var uri = 'data:application/vnd.ms-excel;base64,',
      template=""
      template =template+ '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">'
      template =template+ '<head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets>'
      template =template+ '<x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet>'
      template =template+ '</x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        
        
        base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format = function(s, c) {
            return s.replace(/{(\w+)}/g,
            function(m, p) { return c[p]; }) }
        return function(name,html) {
        //if (!table.nodeType) table = document.getElementById(table)
        var ctx = {worksheet: name || 'Worksheet', table: html}
        window.location.href = uri + base64(format(template, ctx))
      }
})


function Cleanup(){
	
}

/**  
 * layout������չ   ���غ���ʾlayout����  ���÷�ʽ��$("#id").layout("show","west"); $("#id").layout("hidden","west")
 * @param {Object} jq  
 * @param {Object} region  
 */  
$.extend($.fn.layout.methods, {   
    /**  
     * ����Ƿ���ںͿɼ�  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    isVisible: function(jq, params) {   
        var panels = $.data(jq[0], 'layout').panels;   
        var pp = panels[params];   
        if(!pp) {   
            return false;   
        }   
        if(pp.length) {   
            return pp.panel('panel').is(':visible');   
        } else {   
            return false;   
        }   
    },   
    /**  
     * ���س�ĳ��region��center���⡣  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    hidden: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            if(!opts.regionState){   
                opts.regionState = {};   
            }   
            var region = params;   
            function hide(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if($(dom).layout('isVisible', expand)) {   
                        opts.regionState[region] = 1;   
                        panels[expand].panel('close');   
                    } else if($(dom).layout('isVisible', region)) {   
                        opts.regionState[region] = 0;   
                        panels[region].panel('close');   
                    }   
                } else {   
                    panels[region].panel('close');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                hide(this,'east',false);   
                hide(this,'north',false);   
                hide(this,'west',false);   
                hide(this,'south',true);   
            }else{   
                hide(this,region,true);   
            }   
        });   
    },   
    /**  
     * ��ʾĳ��region��center���⡣  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    show: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            var region = params;   
  
            function show(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if(!$(dom).layout('isVisible', expand)) {   
                        if(!$(dom).layout('isVisible', region)) {   
                            if(opts.regionState[region] == 1) {   
                                panels[expand].panel('open');   
                            } else {   
                                panels[region].panel('open');   
                            }   
                        }   
                    }   
                } else {   
                    panels[region].panel('open');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                show(this,'east',false);   
                show(this,'north',false);   
                show(this,'west',false);   
                show(this,'south',true);   
            }else{   
                show(this,region,true);   
            }   
        });   
    }   
}); 
$.extend(
	$.fn.validatebox.defaults.rules,{     
     	isBlank : 	{   
     					validator : function(value) {        
     						return $.trim(value) != '';       
     					},       
     					message : '��������Ϊ������'      
     				},      	    
 });
/**
* @ͨ�õ���div��
* @param 	width 	 	|string 	|���
* @param 	height 	 	|string 	|�߶�
* @param 	code 	 	|string 	|�����ֵ�code
* @param 	adm 	 	|string 	|�����ID
* @param 	input 	 	|string 	|���
* @param 	columns 	|string 	|datagrid��column
* @param 	url 	 	|string 	|datagrid��url
* @param 	emrType 	|string 	|������
* @param 	htmlType 	|string 	|html����
*						input
*						radio
*						checkbox  
*						tree
*						datagrid
* @author zhouxin
*/
function divComponent(opt,callback){
		var option={
			width: 450,
			height: 320,
			emrType:'review',
			htmlType:'radio',
			foetus:1
		}
		
		$.extend(option,opt);

		if ($("#win").length > 0){
			$("#win").remove();
		}
		var retobj={};	// ���ض���
			
		///������������
		var btnPos=option.tarobj.offset().top+ option.height;
		var btnLeft=option.tarobj.offset().left - tleft;
		
		if(option.foetus>1){
			option.height=option.height+32*(option.foetus-1)
		}
		
		$(document.body).append('<div id="win" style="width:'+ option.width +';height:'+option.height+';border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;">';
		html=html+'<div id="divTable"></div>';
		
		if ((option.htmlType == "checkbox")||(option.htmlType == "radio")){				
		
		}		
		else if (option.htmlType == "textarea"){
			html=html+'<textarea id="divTable" type="text" border="1" class="hisui-validatebox" style="width:92%;height:200px;resize:none;overflow:hidden;margin:10px;!important" data-options="required:true"></textarea>';
		}
				
		html=html+'</div>';
		/**
		html=html+' <div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;height:30px;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >����</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >�ر�</a>';
		html=html+'</div>';
		*/
		html=html+'</div>';
		$("#win").append(html);
		if (option.htmlType == "datagrid"){
		
			$('#divTable').datagrid({
				url:opt.url,
				columns:opt.columns,
				fit:true,
				fitColumns:true,
				singleSelect:true,	
				nowrap: false,
				striped: true, 
				pagination:true,
				rownumbers:true,
				pageSize:10,
				pageList:[10,20,30],
				onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
		           callback(rowData);
		        }
			});			
		}
		else if (option.htmlType == "tree"){	
				
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;

			var options = {
				multiple: true,
				lines:true,
				animate:true,
		        onClick:function(node, checked){		       
			        var isLeaf = $("#divAttrTable").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
			        if (isLeaf){
				        //$(option.tarobj).val(itmText); 		
						//$(ed.target).val(itmID);							
						$("#win").remove();	
			        }else{
				    	//$("#divAttrTable").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
				    }
				    $(option.tarobj).val(node.text);
				    callback(node);
			    },
			    onExpand:function(node, checked){
					var childNode = $("#divAttrTable").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
			        var isLeaf = $("#divAttrTable").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
			        if (isLeaf){
				        
			        }
				}
			};			
			new CusTreeUX("divAttrTable", url, options).Init();			
		}	
		$("#win").show();
		//���÷�ҳ�ؼ�  

			var p = $("#divTable").datagrid('getPager');  

			$(p).pagination({  

				buttons: [{
						text:'�ر�',
						handler:function(){
						$("#win").remove();
						}
					}]


			});
		
		
		$.parser.parse($("#win"));
		var tleft = "";
		if((option.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
	
		$("#win").css("left",option.tarobj.offset().left - tleft);
		if(320<option.tarobj.offset().top){
	   		$("#win").css("top",option.tarobj.offset().top-320);//divλ�� ���ϵ���
	   	}else
	   	{
			$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
	   	}

		$("#divTable").find("td").children().eq(0).focus();
		$("#saveDivWinBTN").on('click',function(){
			if (option.htmlType == "textarea"){
				$(option.tarobj).val($("#divTable").val());
			}	
				
			$("#win").remove();
		})

		$("#removeDivWinBTN").on('click',function(){
			$("#win").remove();
		});
		
		$(document).keyup(function(event){
			
			switch(event.keyCode) {
				case 27:
					$("#win").remove();
				case 96:
					$("#win").remove();
			}
		});
}
