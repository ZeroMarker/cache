$(function(){
	//ҳ�����ݳ�ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});
function Init(){
	$("#Button_1 .l-btn-text").text(ServerObj.Button1)
	$("#Button_2 .l-btn-text").text(ServerObj.Button2)
	$("#Button_3 .l-btn-text").text(ServerObj.Button3)
	if (ServerObj.PrescriptTypeStr!=""){
		var DataArr=new Array();
		var ary=ServerObj.PrescriptTypeStr.split('!');
		for (var i=0;i<ary.length;i++) {
			var arytxt=ary[i].split('^');
			DataArr.push({"id":arytxt[1],"text":arytxt[0]});
		}
		var cbox = $HUI.combobox("#AdmReasonList", {
			valueField: 'id',
			textField: 'text',
			editable:true, 
			data:DataArr
	   });
	}
}
function InitEvent(){
	$("#UpateTrans").click(UpateTransClickHandler);
	$("#Button_1,#Button_2,#Button_3").click(ButtonClick);
}
function UpateTransClickHandler(){
	var AdmReasonId=$("#AdmReasonList").combobox("getValue");
	if (AdmReasonId=="") {
		$.messager.alert("��ʾ","��طѱ���Ϊ��,��ѡ��[��طѱ�].");
		return;
	}
	window.returnValue="4^"+AdmReasonId;
 	window.close();
}
function ButtonClick(e){
	var id=e.currentTarget.id;
	var index=id.split("_")[1];
	//window.returnValue=index;
 	//window.close();
 	websys_showModal("hide");
	websys_showModal('options').CallBackFunc(index);
	websys_showModal("close");
}