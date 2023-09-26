$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Baseinfo",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		$HUI.radio(".hisui-radio").setValue(false);
		Init();
		} 
	//初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	LoadDataList()
}
function InitEvent(){
	$("#BSave").click(SaveClickHandler);
}
function SaveClickHandler(){
	 var DataList="";
	 var PrintNo = $("input[name='DHCAPP_PrintNo']:checked").val();
	 if (PrintNo==undefined) {PrintNo=""}
	 DataList="PrintNo"+String.fromCharCode(1)+PrintNo;
	 var PrintSet = $("input[name='DHCAPP_PrintSet']:checked").val();
	 if (PrintSet==undefined) {PrintSet=""}
	 DataList=DataList+String.fromCharCode(2)+"PrintSet"+String.fromCharCode(1)+PrintSet;	
	 var PrintStyle = $("input[name='DHCAPP_PrintStyle']:checked").val();
	 if (PrintStyle==undefined) {PrintStyle=""}
	 DataList=DataList+String.fromCharCode(2)+"PrintStyle"+String.fromCharCode(1)+PrintStyle;
	 var SetChangeSpec="0";
     if ($("#DHCAPP_SetChangeSpec").is(":checked")) {
		 SetChangeSpec="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"SetChangeSpec"+String.fromCharCode(1)+SetChangeSpec;
	 var SetSpecBilled="0";
     if ($("#DHCAPP_SetSpecBilled").is(":checked")) {
		 SetSpecBilled="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"SetSpecBilled"+String.fromCharCode(1)+SetSpecBilled;
	 var DocDr="0";
     if ($("#DHCAPP_DocDr").is(":checked")) {
		 DocDr="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"DocDr"+String.fromCharCode(1)+DocDr;	
	 var Spec="0";
     if ($("#DHCAPP_Spec").is(":checked")) {
		 Spec="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"Spec"+String.fromCharCode(1)+Spec;
	 var CellShowType = $("input[name='DHCAPP_CellShowType']:checked").val();
	 if (CellShowType==undefined) {CellShowType=""}
	 DataList=DataList+String.fromCharCode(2)+"CellShowType"+String.fromCharCode(1)+CellShowType;
	 var LIVSetMin = $("#DHCAPP_LIVSetMin").val();
	 if (LIVSetMin==undefined) {LIVSetMin=""}
	 DataList=DataList+String.fromCharCode(2)+"LIVSetMin"+String.fromCharCode(1)+LIVSetMin;
	 var TCTWomen="0";
     if ($("#DHCAPP_TCTWomen").is(":checked")) {
		 TCTWomen="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"TCTWomen"+String.fromCharCode(1)+TCTWomen;
	 var LIVSpecFix="0";
     if ($("#DHCAPP_LIVSpecFix").is(":checked")) {
		 LIVSpecFix="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"LIVSpecFix"+String.fromCharCode(1)+LIVSpecFix;
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SavebaseInfo",
	 	DataList:DataList,
	 	HospId:HospID
		},false);
	if (value==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		LoadDataList();
	}else{
		$.messager.alert("提示", "保存失败"+value, "error");
        return false;	
		}	
}
function LoadDataList(){
	GetCheckValue("SetChangeSpec")
	GetCheckValue("SetSpecBilled")
	GetCheckValue("DocDr")
	GetCheckValue("Spec")
	GetCheckValue("TCTWomen")
	GetCheckValue("LIVSpecFix")
	GetRadioValue("PrintNo")
	GetRadioValue("PrintSet")
	GetRadioValue("PrintStyle")
	GetRadioValue("CellShowType")
	GetTextValue("LIVSetMin")
	GetTextValue("TCTWomen")
}
function GetTextValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	$("#DHCAPP_"+Node).val(value)
}
function GetCheckValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value=="1"){
		$HUI.checkbox("#DHCAPP_"+Node).setValue(true);
		}else{
		$HUI.checkbox("#DHCAPP_"+Node).setValue(false);
		}
	}
function GetRadioValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value!=""){
		$HUI.radio("#"+value).setValue(true);
		}
	}
