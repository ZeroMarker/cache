/**
 * 评估录入  dhchm.oevaluation.js
 * @Author   wangguoying
 * @DateTime 2019-05-05
 */
function EDSave_onclick()
{
	var InputArr=document.getElementsByName("EDResultDR");
	var resultStr=""
	var char1=String.fromCharCode(1);
	var char2=String.fromCharCode(2);
	for(var i=0;i<InputArr.length;i++){
		var EDId=InputArr[i].id;
		var ResultID=InputArr[i].value;
		var EDType=JV("T_"+EDId);
		var val="";
		switch (EDType)
		{
			case "C":
				val=$("#I_"+EDId).combobox('getValue');
				break;			
			case "D":
				val=$("#I_"+EDId).datebox('getValue');
				break;				
			case "N":
			case "T":
				val=JV("I_"+EDId);
				break;
		}
		if(resultStr!="") resultStr=resultStr+char1+ResultID+char2+JV("EQID")+char2+EDId+char2+ val;
		else resultStr=ResultID+char2+JV("EQID")+char2+EDId+char2+val;
	}
	var User = session['LOGON.USERID'];
	var saveRet=tkMakeServerCall("web.DHCHM.OEvaluationRecord","UpdateResult","E",resultStr,User);
	if(saveRet==""){
		$.messager.alert("提示","保存成功","success",function(){
			if(document.parentWindow)
			{
				var tab=document.parentWindow.parent.$("#TabPanel").tabs("getSelected");
				tab.panel("refresh",location);
			}
		});
		
	}else{
		$.messager.alert("提示","保存失败:"+saveRet,"error");
	}
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