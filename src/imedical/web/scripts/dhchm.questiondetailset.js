/**
 * 调查问卷录入 dhchm.questiondetailset.js
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */

/**
 * [翻页事件]
 * @param    {[type]}    QuesID    [问题ID]
 * @param    {[type]}    NextOrder [下一主题序号]
 * @param    {[type]}    Job       [进程ID]
 * @param    {[type]} 	SubjectOrder [主题序号]
 * @param    {[type]}    flag      [1:下一页  -1：上一页  2:保存] 
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function page_OnClick(QuesID,NextOrder,Job,SubjectOrder,flag)
{
	if(flag!=-1){
		if(!isCanToNextPage()) return false;
		var resultList=getResultList();
		//alert("resultList="+resultList);
		var ret=tkMakeServerCall("web.DHCPE.HM.ExamSurveyHandler","SetCurResultGlobal",Job,QuesID,SubjectOrder,resultList);
		if(flag==2){
			var ret=tkMakeServerCall("web.DHCPE.HM.ExamSurveyHandler","SaveSurveyResult",Job,QuesID,JV("RegNo"),JV("PreIADM"));
			if(ret.split("^")[0]!="0"){
				$.messager.alert("错误",ret.split("^")[1],"error");
			}else{
				//$.messager.alert("提示","保存成功!","success");
				if(parent.window.afterSurvey) {
					parent.window.afterSurvey(JV("PreIADM"));
				    parent.window.$("#SurveyWin").window("close");
				}else{
					$.messager.alert("提示","保存成功!","success",function(){
						var countWin = $('div[data-type="websysmodel"]').length;
						parent.window.$("#WinModalEasyUI"+countWin).window("close");
					});
					
				}
			}
			return false;
		}
	}
	var lnk="dhchm.questiondetailset.csp?QuesID="+QuesID+"&SubjectOrder="+NextOrder+"&Job="+Job+"&PreIADM="+JV("PreIADM");
	location.href=lnk;
}



/**
 * [判断能否进入下一页]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function isCanToNextPage() {
	var ret=true;
	var array = document.getElementsByName("queAnswerFlag");
	var num = 0;
	var firstDetail="";
	for (var i = 0; i < array.length; i++) {
		var obj = array[i];
		var detailId = obj.id.split("_")[1];
		var table = document.getElementById("tab_"+detailId);
		if (obj.value == 'Y' && table.style.display != 'none') {
			var value="";
			var detailType=JO("detailType_"+detailId).value;
			if((detailType=="T")||(detailType=="N")){ //录入型
				value=JO("input_"+detailId).value;
			}else if(detailType=="D"){  //时间型
				var linkId=JO("input_"+detailId).getAttribute("comboname");
				var valObj=document.getElementsByName(linkId)[0];
				value=valObj.value;
			}
			if(Trim(value)==""){
				if(firstDetail=="") firstDetail=detailId;
				document.getElementById("spn_"+detailId).style.display = "block";
				num++;
			}
			
		}
	}
	if (num > 0) {
		JO("tab_"+firstDetail).scrollIntoView();  //定位到第一个未做的题目
		$.messager.alert("提示", "您有未做的问题，请将问题全部做完！","info");
		ret=false;
	} 
	return ret;
}


/**
 * 获取结果集合
 * @return   {[string]}    [结果集]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function getResultList(){
	var resultList="";
	var array = document.getElementsByName("detailType");
	for (var i = 0; i < array.length; i++) {
		var obj = array[i];
		var detailId = obj.id.split("_")[1];
		var detailType=obj.value;
		var valList="";
		switch(detailType){
			case "S":
				valList=getRadioVal(detailId); //单选框				
				break;
			case "M":
				valList=getCheckVal(detailId); //复选框
				break;
			case "D":
				valList=getDateVal(detailId); //日期
				break;
			default:
				valList=getInutVal(detailId);

		}
		if(valList!=""){
			if(resultList!=""){
			resultList+="@"+valList;
			}else{
				resultList=valList;
			} 	
		}
			
	}
	return resultList;
}

/**
 * 获取当前界面所有的Input输入值
 * @param   {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function getInutVal(detailId)
{
	var val="";
	if(JO("input_"+detailId)){
		val=JV("input_"+detailId);
		if(Trim(val)!=""){
			var linkId="";
			if (JO("input_"+detailId).tagName=="INPUT"){
				var linkId=JO("input_"+detailId).getAttribute("numberboxname");
			}else{
				linkId=JN("input_"+detailId);
			}
			val=linkId+"~~"+val+"~";
		}
	}
	return val;
}

/**
 * 获取当前界面所有的日期输入值
 * @param   {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function getDateVal(detailId)
{
	var val="";
	if(JO("input_"+detailId)){
		var linkId=JO("input_"+detailId).getAttribute("comboname");
		var valObj=document.getElementsByName(linkId)[0];
		if(Trim(valObj.value)!=""){
			val=linkId+"~~"+valObj.value+"~";
		}
	}
	return val;
}

/**
 * 获取当前界面所有的Checkbox选中值
 * @param   {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function getCheckVal(detailId)
{
	var valList="";
	var checkArry = document.getElementsByName("chk_"+detailId);
	for(var j=0;j<checkArry.length;j++){
		var checkId=checkArry[j].id;
		var remark="";
		if(JO(checkId).checked){
			//备注
			var linkId=checkId.split("~")[0];
			var optionId=checkId.split("~")[1];
			if (JO("optionNote_"+linkId+"~"+optionId)) {	
				remark=JO("optionNote_"+linkId+"~"+optionId).value;
			}

			if(valList!=""){
				valList+="@"+JV(checkId)+Trim(remark);
			}else{
				valList=JV(checkId)+Trim(remark);
			}	
		}		
	}
	return valList;
}


/**
 * 获取当前界面所有的Radio选中值
 * @param   {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function getRadioVal(detailId)
{
	var raValList="";
	var radioArry = document.getElementsByName("rad_"+detailId);
	for(var j=0;j<radioArry.length;j++){
		var radioId=radioArry[j].id;
		if(JO(radioId).checked){
			if(raValList!=""){
				raValList+="@"+JV(radioId);
			}else{
				raValList=JV(radioId);
			}	
		}		
	}
	return raValList;
}

/**
 * [复选框点击事件]
 * @param    {[type]}    chk      [复选框元素]
 * @param    {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
*/
function chkQustion_onclick(chk, detailId) {
	if (chk.checked) {		
		JO("queAnswerFlag_"+detailId).value += (chk.value+"@");				
		JO("spn_"+detailId).style.display = "none";
		// 如果点选的是【其他】，则显示其他内容输入框
		var chkId=chk.id;
		var linkId=chkId.split("~")[0];
		var optionId=chkId.split("~")[1];
		if (JO("optionNote_"+linkId+"~"+optionId)) {				
			JO("optionNote_"+linkId+"~"+optionId).style.display = "inline";
			JO("optionNote_"+linkId+"~"+optionId).focus();
		}				
	}	
	else {
		
		JO("queAnswerFlag_"+detailId).value = JO("queAnswerFlag_"+detailId).value.replace(chk.value+"@", "");
		
		// 如果点选的是【其他】，则隐藏其他内容输入框
		var div = chk.parentNode.parentNode;  //.parentNode;
		if (div.children.length > 2) {
			div.children[2].value = "";
			div.children[2].style.display = "none";
		}
	}
} 
/**
 * 单选型选项点击事件
 * @param    {[type]}    rad             [单选按钮元素]
 * @param    {[type]}    linkDetailId    [关联问题ID，以逗号分隔]
 * @param    {[type]}    excludeDetailId [排斥问题ID，以逗号分隔]
 * @param    {[type]}    detailId        [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-25
 */
function radQuestion_onclick(rad, linkDetailId, excludeDetailId, detailId) {		
	JO("queAnswerFlag_" + detailId).value = rad.value;
	JO("spn_" + detailId).style.display = "none";

	// 显示该显示的问题
	if (linkDetailId != '') {
		var array1 = linkDetailId.split(",");

		for ( var i = 0; i < array1.length; i++) {
			if(JO("tab_" + array1[i])){
				JO("tab_" + array1[i]).style.display = "block";
			}			
		}
	}

	// 隐藏不该显示的问题，并去除已选择
	if (excludeDetailId != '') {
		var array2 = excludeDetailId.split(",");

		for ( var i = 0; i < array2.length; i++) {
			if(JO("tab_" + array2[i])){
				JO("tab_" + array2[i]).style.display = "none";
			}
			

			var array3 = document.getElementsByName("rad_" + array2[i]);
			for ( var j = 0; j < array3.length; j++) {
				var radTemp = array3[j];

				if (radTemp.checked) {
					radTemp.checked = false;
				}
			}
		}
	}
}


/**
 * 日期时间型选择事件
 * @param   {[type]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */
function onChangeDateTime(detailId)
{
	if(JO("input_"+detailId)){
		var linkId=JO("input_"+detailId).getAttribute("comboname");
		var valObj=document.getElementsByName(linkId)[0];
		if(Trim(valObj.value)!=""){
			JO("spn_"+detailId).style.display = "none";
		}
	}
}


/**
 * 录入型问题失去焦点事件
 * @param    {[string]}    detailId [问题ID]
 * @Author   wangguoying
 * @DateTime 2019-03-25
 */
function txt_onblur(detailId) {
	var chk=JO("input_"+detailId);
	var content = $.trim(chk.value);
	if (content.indexOf("~")>=0 || content.indexOf("@")>=0 || content.indexOf("#")>=0) {
		alertFunc("不允许输入非法字符(~、#、@) ！");
		chk.value="";
		return;
	}
	if(content!=""){
		JO("spn_"+detailId).style.display = "none";
	}

}


//【其他】内容输入框失去焦点触发事件
function txtOther_onblur(chk,appendStrWithoutValue) {
	
}

//将选项值追加到对应的queAnswerFlag输入框中
function addQueAnswerFlagValue(value, detailId) {
	JO("queAnswerFlag_"+detailId).value += (value + "@");
}

	

function JO(id){
	return document.getElementById(id);
}
function JV(id) {
	return JO(id).value=="null"?"":JO(id).value;
}
function JN(id) {
	return JO(id).name=="null"?"":JO(id).name;
}
function Trim(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}

function banBackSpace(e) {
	var ev = e || window.event;
	//各种浏览器下获取事件对象
	var obj = ev.relatedTarget || ev.srcElement || ev.target || ev.currentTarget;
	//按下Backspace键
	if (ev.keyCode == 8) {
		var tagName = obj.nodeName //标签名称
		//如果标签不是input或者textarea则阻止Backspace
		if (tagName != 'INPUT' && tagName != 'TEXTAREA') {
			return stopIt(ev);
		}
		var tagType = obj.type.toUpperCase();//标签类型
		//input标签除了下面几种类型，全部阻止Backspace
		if (tagName == 'INPUT' && (tagType != 'TEXT' && tagType != 'TEXTAREA' && tagType != 'PASSWORD')) {
			return stopIt(ev);
		}
		//input或者textarea输入框如果不可编辑则阻止Backspace
		if ((tagName == 'INPUT' || tagName == 'TEXTAREA') && (obj.readOnly == true || obj.disabled == true)) {
			return stopIt(ev);
		}
	}
}
	
function stopIt(ev) {
	if (ev.preventDefault) {
		//preventDefault()方法阻止元素发生默认的行为
		ev.preventDefault();
	}
	if (ev.returnValue) {
		//IE浏览器下用window.event.returnValue = false;实现阻止元素发生默认的行为
		ev.returnValue = false;
	}
	return false;
}
$(init);
function init(){
	//实现对字符码的截获，keypress中屏蔽了这些功能按键
	document.onkeypress = banBackSpace;
	//对功能按键的获取
	document.onkeydown = banBackSpace;
}