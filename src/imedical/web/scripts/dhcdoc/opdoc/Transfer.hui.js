var PageLogicObj={
	
};
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	$("#BUpdate").click(TransferClickHandle);
}
function PageHandle(){
	LoadDept();
}
function LoadDept(){
	//初始化科室
    $.cm({
		ClassName:"web.DHCDocTransfer",
		QueryName:"OPDeptList",
		dataType:"json",
		AdmType:"",
		HospId:session['LOGON.HOSPID'],
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Dept", {
				valueField: 'CTCode',
				textField: 'CTDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["CTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(rec){
					if (rec!=undefined){
						$("#Doc").combobox('select','');
						LoadDoc(rec['CTCode']);
					}
				},
				onChange:function(newValue, oldValue){
					if (newValue==""){
						$("#Doc").combobox('select','');
						LoadDoc('');
					}
				}
		 });
	});
}
function LoadDoc(LocId){
	$.cm({
		ClassName:"web.DHCDocTransfer",
		QueryName:"OPDocList",
		dataType:"json",
		DepRowId:LocId,
		AdmId:ServerObj.EpisodeID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Doc", {
				valueField: 'DocId',
				textField: 'DocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["DocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) //||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function TransferClickHandle(){
	var AdmIdStr=ServerObj.EpisodeID;
	if(AdmIdStr==""){
		$.messager.alert("提示","请选择患者!");
		return false;
	}
	var DepRowId=$("#Dept").combobox('getValue');
	if (DepRowId=="undefined") DepRowId="";
	if(DepRowId==""){
		$.messager.alert("提示","请选择科室!");
		return false;
	}
	var DocRowId=$("#Doc").combobox('getValue');
	if (DocRowId=="undefined") DocRowId="";
	if(DocRowId==""){
		$.messager.alert("提示","请选择医生!");
		return false;
	}
	var CareId =$m({
		ClassName:"web.DHCDocTransfer",
		MethodName:"GetCareDrByUserID",
		UserID:session['LOGON.USERID'],
		dataType:"text"
	}, false);
	if(CareId==DocRowId){
		$.messager.alert("提示","转诊医生不能为本人!");
		return false;
	}
	var Ret =$m({
		ClassName:"web.DHCDocTransfer",
		MethodName:"UpdateTransfer",
		DepRowId:DepRowId, DocRowId:DocRowId, AdmIdStr:AdmIdStr,
		dataType:"text"
	}, false);
	var RetArray=Ret.split("^")
	var RetString=""
	for(var i=0;i<RetArray.length;i=i+1){
		var RetArrayArr=RetArray[i].split("!")
		if((RetArrayArr[1]!=0)||(RetArrayArr[2]!=0)||(RetArrayArr[3]!=0)||(RetArrayArr[4]!=0)||(RetArrayArr[5]!=0)){
			RetString=RetString+RetArrayArr[0]+" "
		}
	}
	if (RetString!=""){
		RetString=RetString+",转诊失败!" 
		$.messager.alert("提示",RetString);
	}else{
		$.messager.alert("提示","转诊成功!","info",function(){
			websys_showModal("hide");
		    websys_showModal('options').LoadOutPatientDataGrid();
		    websys_showModal("close");
		});
	}
}
