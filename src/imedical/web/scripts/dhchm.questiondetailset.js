/**
 * �����ʾ�¼�� dhchm.questiondetailset.js
 * @Author   wangguoying
 * @DateTime 2019-03-22
 */

/**
 * [��ҳ�¼�]
 * @param    {[type]}    QuesID    [����ID]
 * @param    {[type]}    NextOrder [��һ�������]
 * @param    {[type]}    Job       [����ID]
 * @param    {[type]} 	SubjectOrder [�������]
 * @param    {[type]}    flag      [1:��һҳ  -1����һҳ  2:����] 
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
				$.messager.alert("����",ret.split("^")[1],"error");
			}else{
				//$.messager.alert("��ʾ","����ɹ�!","success");
				if(parent.window.afterSurvey) {
					parent.window.afterSurvey(JV("PreIADM"));
				    parent.window.$("#SurveyWin").window("close");
				}else{
					$.messager.alert("��ʾ","����ɹ�!","success",function(){
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
 * [�ж��ܷ������һҳ]
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
			if((detailType=="T")||(detailType=="N")){ //¼����
				value=JO("input_"+detailId).value;
			}else if(detailType=="D"){  //ʱ����
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
		JO("tab_"+firstDetail).scrollIntoView();  //��λ����һ��δ������Ŀ
		$.messager.alert("��ʾ", "����δ�������⣬�뽫����ȫ�����꣡","info");
		ret=false;
	} 
	return ret;
}


/**
 * ��ȡ�������
 * @return   {[string]}    [�����]
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
				valList=getRadioVal(detailId); //��ѡ��				
				break;
			case "M":
				valList=getCheckVal(detailId); //��ѡ��
				break;
			case "D":
				valList=getDateVal(detailId); //����
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
 * ��ȡ��ǰ�������е�Input����ֵ
 * @param   {[type]}    detailId [����ID]
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
 * ��ȡ��ǰ�������е���������ֵ
 * @param   {[type]}    detailId [����ID]
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
 * ��ȡ��ǰ�������е�Checkboxѡ��ֵ
 * @param   {[type]}    detailId [����ID]
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
			//��ע
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
 * ��ȡ��ǰ�������е�Radioѡ��ֵ
 * @param   {[type]}    detailId [����ID]
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
 * [��ѡ�����¼�]
 * @param    {[type]}    chk      [��ѡ��Ԫ��]
 * @param    {[type]}    detailId [����ID]
 * @Author   wangguoying
 * @DateTime 2019-03-22
*/
function chkQustion_onclick(chk, detailId) {
	if (chk.checked) {		
		JO("queAnswerFlag_"+detailId).value += (chk.value+"@");				
		JO("spn_"+detailId).style.display = "none";
		// �����ѡ���ǡ�������������ʾ�������������
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
		
		// �����ѡ���ǡ����������������������������
		var div = chk.parentNode.parentNode;  //.parentNode;
		if (div.children.length > 2) {
			div.children[2].value = "";
			div.children[2].style.display = "none";
		}
	}
} 
/**
 * ��ѡ��ѡ�����¼�
 * @param    {[type]}    rad             [��ѡ��ťԪ��]
 * @param    {[type]}    linkDetailId    [��������ID���Զ��ŷָ�]
 * @param    {[type]}    excludeDetailId [�ų�����ID���Զ��ŷָ�]
 * @param    {[type]}    detailId        [����ID]
 * @Author   wangguoying
 * @DateTime 2019-03-25
 */
function radQuestion_onclick(rad, linkDetailId, excludeDetailId, detailId) {		
	JO("queAnswerFlag_" + detailId).value = rad.value;
	JO("spn_" + detailId).style.display = "none";

	// ��ʾ����ʾ������
	if (linkDetailId != '') {
		var array1 = linkDetailId.split(",");

		for ( var i = 0; i < array1.length; i++) {
			if(JO("tab_" + array1[i])){
				JO("tab_" + array1[i]).style.display = "block";
			}			
		}
	}

	// ���ز�����ʾ�����⣬��ȥ����ѡ��
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
 * ����ʱ����ѡ���¼�
 * @param   {[type]}    detailId [����ID]
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
 * ¼��������ʧȥ�����¼�
 * @param    {[string]}    detailId [����ID]
 * @Author   wangguoying
 * @DateTime 2019-03-25
 */
function txt_onblur(detailId) {
	var chk=JO("input_"+detailId);
	var content = $.trim(chk.value);
	if (content.indexOf("~")>=0 || content.indexOf("@")>=0 || content.indexOf("#")>=0) {
		alertFunc("����������Ƿ��ַ�(~��#��@) ��");
		chk.value="";
		return;
	}
	if(content!=""){
		JO("spn_"+detailId).style.display = "none";
	}

}


//�����������������ʧȥ���㴥���¼�
function txtOther_onblur(chk,appendStrWithoutValue) {
	
}

//��ѡ��ֵ׷�ӵ���Ӧ��queAnswerFlag�������
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
	//����������»�ȡ�¼�����
	var obj = ev.relatedTarget || ev.srcElement || ev.target || ev.currentTarget;
	//����Backspace��
	if (ev.keyCode == 8) {
		var tagName = obj.nodeName //��ǩ����
		//�����ǩ����input����textarea����ֹBackspace
		if (tagName != 'INPUT' && tagName != 'TEXTAREA') {
			return stopIt(ev);
		}
		var tagType = obj.type.toUpperCase();//��ǩ����
		//input��ǩ�������漸�����ͣ�ȫ����ֹBackspace
		if (tagName == 'INPUT' && (tagType != 'TEXT' && tagType != 'TEXTAREA' && tagType != 'PASSWORD')) {
			return stopIt(ev);
		}
		//input����textarea�����������ɱ༭����ֹBackspace
		if ((tagName == 'INPUT' || tagName == 'TEXTAREA') && (obj.readOnly == true || obj.disabled == true)) {
			return stopIt(ev);
		}
	}
}
	
function stopIt(ev) {
	if (ev.preventDefault) {
		//preventDefault()������ֹԪ�ط���Ĭ�ϵ���Ϊ
		ev.preventDefault();
	}
	if (ev.returnValue) {
		//IE���������window.event.returnValue = false;ʵ����ֹԪ�ط���Ĭ�ϵ���Ϊ
		ev.returnValue = false;
	}
	return false;
}
$(init);
function init(){
	//ʵ�ֶ��ַ���Ľػ�keypress����������Щ���ܰ���
	document.onkeypress = banBackSpace;
	//�Թ��ܰ����Ļ�ȡ
	document.onkeydown = banBackSpace;
}