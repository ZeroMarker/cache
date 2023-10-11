/**
 * 附页信息
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */
var globalObj = {
	data:{}	// 数据
}

// 页面入口
$(function(){

	renderCmp();	// 渲染组件并加载值
	if (ServerObj.FPTypeDesc!="中医首页") {
		$(".CMItem").remove();
	}
	$("input").keydown(function(){
		if(13 == event.keyCode){
			onEnter($(this))
		}else{
		}
	});
	$("input").keyup(function(){
		updatedata(this.id,'','',this.value)
	});
})

function onEnter() {
	var cmp = arguments[0].attr('id');
	// 找到下一个表单
	var inputEles = $("input[ItemFlag='1'][disabled!='disabled']");
	for(var i=0;i<inputEles.length;i++){
		if ($(inputEles[i]).is(arguments[0])) { //判断两个jQuery对象是否相等用is
			//校验数据，回车到下一个录入框
			if (!checkItem(cmp)) break;
			if(i == inputEles.length-1){
				// 跳转到下一个页签
				window.parent.selectnexttab('附页信息');
				break;
				/*
				if ($(inputEles[0]).hasClass('combogrid-f')) {
					$(inputEles[0]).next().children(":first").focus()
				}else if ($(inputEles[0]).hasClass('datebox-f')||$(inputEles[0]).hasClass('datetimebox-f')) {
					$(inputEles[0]).next().children(":first").focus()
				}else{
					$(inputEles[0]).focus();
				}
				*/
			}else{
				// 判断下一个表单类型
				if ($(inputEles[i+1]).hasClass('combogrid-f')) {
					$(inputEles[i+1]).next().children(":first").focus();
				}else if ($(inputEles[i+1]).hasClass('datebox-f')||$(inputEles[i+1]).hasClass('datetimebox-f')) {
					$(inputEles[i+1]).next().children(":first").focus();
				}else{
					$(inputEles[i+1]).focus();
				}
			}
		}    
	}
}


function checkItem(id)
{
	var data = globalObj.data;
	var flg = true;
	for(var i in data){
		var itemData = data[i];
		var itemCode = itemData.itemCode;
		if (id!=itemCode) continue;
	    flg=checkcmp(itemData);
	}
	return flg;
}

// 构建数据项对象
function buildItemObj(data){
	var value = data.value;
	var obj={
		itemCode :data.DICatCode,
		LinkCatCode:data.LinkCatCode,
		id:value.split('^')[2],
		code:value.split('^')[0],
		text:value.split('^')[1],
		dataType:data.DataType,
		isShowCode:data.IsShowCode,
		IsNecessaryItem:data.IsNecessaryItem,
		IsItemChar:data.IsItemChar
	}
	return obj
}
// 构建数据对象
function buildDataObj(rs) {
	var evalStr = "var obj = {";
	var count=1;
	for (i=0;i<rs.total;i++){
		var data = rs.rows[i];
		if ($('#'+data.DICatCode).length==0) continue;
		if (count==1) {
			evalStr = evalStr+data.DICatCode+":''"
		}else{
			evalStr = evalStr+","+data.DICatCode+":''"
		}
		count++;
	}
	evalStr = evalStr+"}"
	eval(evalStr)
	return obj;
}

// 渲染组件并加载值
function renderCmp(){
	$cm({
    	ClassName:"MA.IPMR.FPS.CodeExtraSrv",
    	QueryName:"QryExtraInfo",
    	aVolumeID:'',
		aEpisodeID:ServerObj.EpisodeID,
		aFirstLetter:'P,T',
    	rows:10000
    },function(rs){
		globalObj.data = buildDataObj(rs);
    	for (i=0;i<rs.total;i++){
			var data = rs.rows[i]
			if (data.DICatCode=='P01065') {		// 编码员默认登陆用户
				var id = data.value.split('^')[2];
				if (id==''){
					data.value=Logon.UserCode+'^'+Logon.UserName+'^'+Logon.UserID;
				}
			}
		}
		//var json = '{';
		//var cmpcount=0;
		for (i=0;i<rs.total;i++){
			var data = rs.rows[i];
			var objItem = buildItemObj(data);
	    	for (let key in globalObj.data) {
			  if(key == data.DICatCode) {
			    globalObj.data[key]=objItem;
			  }
			}
	    	/*var value = data.value;
	    	var DICatCode = data.DICatCode;
	    	var DataType = data.DataType;
			var IsShowCode = data.IsShowCode;
			var LinkCatCode = data.LinkCatCode;
			var IsNecessaryItem = data.IsNecessaryItem;
			var IsItemChar = data.IsItemChar;
	    	var val = value.split('^')[0];
	    	var txt = value.split('^')[1];
			var id = value.split('^')[2];
			var cmpid = DICatCode;
			if ($('#'+cmpid).length==0) continue;
			// 数据存入data结构
			cmpcount++
			var cmpStr = '"'+cmpid +'":{"itemCode":"' + DICatCode + 
									'","LinkCatCode":"' + LinkCatCode + 
									'","id":"' + id + 
									'","code":"' + val+ 
									'","text":"' + txt + 
									'","dataType":"' + DataType + 
									'","isShowCode":"' + IsShowCode+
									'","IsNecessaryItem":"' + IsNecessaryItem+
									'","IsItemChar":"' + IsItemChar+
								'"}';
			if (cmpcount==1) {
				json = json + cmpStr;
			}else{
				json = json + ',' + cmpStr;
			}*/
		}
		/*json = json + '}';
		globalObj.data = JSON.parse(json);*/

    	for (i=0;i<rs.total;i++){
	    	var data = rs.rows[i];
	    	var value = data.value;
	    	var DICatCode = data.DICatCode;
	    	var DataType = data.DataType;
			var IsShowCode = data.IsShowCode;
			var LinkCatCode = data.LinkCatCode;
	    	var val = value.split('^')[0];
	    	var txt = value.split('^')[1];
			var id = value.split('^')[2];
			var cmpid = DICatCode;
	    	if ($('#'+cmpid).length==0) continue;
	    	
			if (ServerObj.IsFPEidtAll==0) {
				if (IsShowCode==1){
					$('#'+cmpid).val(val);
				}else{
					$('#'+cmpid).val(txt);
				}
				$('#'+cmpid).attr("disabled", true);
			}else{
				if (DataType=='DATE'){
					//$('#'+cmpid).datebox({});
					$('#'+cmpid).datebox({
						onChange: function(value){
							updatedata(this.id,'','',value)
						}
					});
					$('#'+cmpid).datebox('setValue',txt);
				}
				if (DataType=='DATETIME'){
					//$('#'+cmpid).datetimebox({});
					$('#'+cmpid).datetimebox({
						onChange: function(value){
							updatedata(this.id,'','',value)
						}
					});
					$('#'+cmpid).datetimebox('setValue',txt);
				}
				if (DataType=='NUMBER'){
					// 数字类型采用文本框，控制能输入的内容
					var enterExp = /[^\d|0|-]/g;
					$('#'+cmpid).keyup(function(){ 
						$(this).val($(this).val().replace(enterExp,'')); 
					}).bind("paste",function(){
						$(this).val($(this).val().replace(enterExp,'')); 
					});
					//$('#'+cmpid).numberbox({});
					//$('#'+cmpid).numberbox('setValue', txt);
				}
				if (DataType=='TEXT'){
				}
				if (IsShowCode==1){
					$('#'+cmpid).val(val);
				}else{
					$('#'+cmpid).val(txt);
				}
				$('#'+cmpid).attr("data-source",data.DicType);
				$('#'+cmpid).attr("data-itemcat",data.ItemCat);
				$('#'+cmpid).attr("data-type",data.DataType);
				$('#'+cmpid).attr("data-linkcmp",data.LinkCatCode);
				$('#'+cmpid).attr("data-IsNecessaryItem",data.IsNecessaryItem);
				$('#'+cmpid).attr("data-IsItemChar",data.IsItemChar);
				$('#'+cmpid).attr("showCode",data.IsShowCode);
			}
			if (data.DICatCode=='P01065') {		// 编码员不可编辑
				$('#'+cmpid).attr("disabled", true);
			}
	  }
		// 按需渲染字典项目
		$("input[data-type='DIC']").click( function () {
			applyInput(this)
		});
		$("input[data-type='DIC']").focus(function(){
			applyInput(this)
		});
		/*
		$("input[data-type='DIC']").bind('keydown',function(event){
			if(event.keyCode == 13){
				//校验数据，回车到下一个录入框
			}else{
				applyInput(this)
			}
		});
		*/
		$('.datebox .combo-text').keydown(function(){
			if(event.keyCode == 13){
				onEnter($(this).parent().prev())
			}
		});
		if (ServerObj.IsFPEidtAll==1) {
			Changebgcolr(globalObj.data);
		}
    });
}

// 渲染组件
function applyInput(cmp)
{
	if (!$(cmp).hasClass('combogrid-f')) {
		var width = $(cmp).width();
		var offset = $(cmp).offset();
		if ($(cmp).attr('data-type')=='DIC') {
			cbgToCodeItemDic($(cmp).attr('id'),$(cmp).attr('data-itemcat'),$(cmp).attr('showCode'),'',$(cmp).attr('data-linkcmp'))
			//$(cmp).combogrid("showPanel");
			$(cmp).combogrid("resize",width+10);
			$(cmp).offset(offset)
			$(cmp).next().children(":first").focus()
			$(cmp).next().children(":first").change( function() {
				var record = $(cmp).combogrid("grid").datagrid("getSelected");
				if (record==null) {
				  var id   = '';
				  var code = '';
				  var text = $(cmp).combogrid('getText');
				}else{
				  var code = record.Code;
				  var id   = record.ID;
				  var text = record.Desc;
				}
				updatedata($(cmp).attr('id'),id,code,text);
			});
		}
	}
	var str = 'var cmpdata = globalObj.data.'+$(cmp).attr('id');
	eval(str);
	changeCmpBgColor(cmpdata);
}

function getCmpId(cmpid) {
	if (cmpid=='') return '';
	var str = 'var id = globalObj.data.'+cmpid+'.id';
	eval(str);
	return id;
	
}

function updatedata(cmp,id,code,text){
	// 当前id和更新id比较
	var isIdChange=0;
	var data = globalObj.data;
	for(var i in data){
		var itemData = data[i];
		var itemCode = itemData.itemCode;
		if (itemCode!=cmp) continue;
	    var oldid= itemData.id;
	    if (oldid!=id) isIdChange=1;
	    globalObj.data[i].id=id;
	    globalObj.data[i].code=code;
	    globalObj.data[i].text=text;
	    changeCmpBgColor(globalObj.data[i]);
	}
	if ($("input[data-linkcmp='"+cmp+"']").length!=0) {
		if (isIdChange==1) {
			// 获取表单id
			var cmpid = $($("input[data-linkcmp='"+cmp+"']")[0]).attr('id');
			updatedata(cmpid,'','','')
		}
	}
	/*
	var str = 'globalObj.data.'+cmp+'.id='+'"'+id+'"';
	eval(str);
	var str = 'globalObj.data.'+cmp+'.code='+'"'+code+'"';
	eval(str);
	var str = 'globalObj.data.'+cmp+'.text='+'"'+text+'"';
	eval(str);
	var str = 'var cmpdata = globalObj.data.'+cmp;
	eval(str);
	if ($("input[data-linkcmp='"+cmp+"']").length!=0) {
		// 获取表单id
		var cmpid = $($("input[data-linkcmp='"+cmp+"']")[0]).attr('id');
		updatedata(cmpid,'','','')
	}
	changeCmpBgColor(cmpdata);
	*/
}

// 返回保存时的数据格式
function getPatinfo(status){
	if (!checkData(status)){
		return false;
	}
	var data = globalObj.data;
	var strResult = '';
	for(var i in data){
		var strTemp = '';
		var itemData = data[i];
		
		var itemCode = itemData.itemCode;
	    var id= itemData.id;
	    var code= itemData.code;
	    var text= itemData.text;
	    var dataType= itemData.dataType;
		if (dataType=='DIC'){
			strTemp = itemCode+'01'+CHR_1+text+CHR_2+itemCode+'02'+CHR_1+code;
		}else{
			strTemp = itemCode+'01'+CHR_1+text;
		}
		if (strResult != '') strResult += CHR_2
		strResult += strTemp
	}
	return strResult;
}

// 检查数据完整性并高亮提示
function checkData(status){
	if (ServerObj.IsFPEidtAll==0) 
		return true;
	if (status!='R') {
		var data = globalObj.data;
		var errflg=true;
		var errcmp='';
		var errdataTpe='';
		for(var i in data){
			var itemData = data[i];
			var itemCode = itemData.itemCode;
			errflg = checkcmp(itemData);
			errcmp = itemCode;
			if (!errflg) break;
		}
		if (!errflg) {
			window.parent.selecttab('附页信息');
			$.messager.popover({msg: '数据不标准！请重新录入',type:'alert'});
			focus(errcmp);
			return false;
		}else{	// 草稿不验证
			return true;
		}
	}else{
		return true;
	}
}

/**
 * 编目数据项数据替换（表单和数据json）
 * @param {array} 需替换成的数据内容['cmpid',id,code,text]
 * @return {Boolean} True 正常, false 异常
 */
function replaceData(array) 
{
	try {
		var data = globalObj.data;
		for(var i in data){
			var item = data[i];
			if (item.itemCode!=array[0]) continue;
			updatedata(array[0],array[1],array[2],array[3]);
			if (item.isShowCode==1){
				var showval = item.code;
			}else{
				var showval = item.text;
			}
			setText(item.itemCode,showval);
			var str = 'var cmpdata = globalObj.data.'+item.itemCode;
			eval(str);
			changeCmpBgColor(cmpdata)
		}
	}catch(e){
		return false;
	}
	return true;
}