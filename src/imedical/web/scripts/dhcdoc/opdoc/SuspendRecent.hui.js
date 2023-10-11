$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//
	PageHandle();
});
function Init(){
	}
function InitEvent(){
	$("#leave").click(leavehandlerclick)
	$("#back").click(backhandlerclick)
	}
function PageHandle(){
	LoadDept();
	LoadSuspendReason();
}
function LoadSuspendReason(){
	$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		QueryName:"FindSuspendReason",
		dataType:"json",
		TCode:"", TDesc : "", AllFlag:"N",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#suspendreason", {
				valueField: 'RowID',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				panelHeight:90,
				filter: function(q, row){
					return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(rec){
				},
		 });
	});
	}
function LoadDept(){
	//初始化科室
    $.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"OPDeptList",
		dataType:"json",
		AdmType:"",
		HospId:session['LOGON.HOSPID'],
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Loc", {
				valueField: 'CTCode',
				textField: 'CTDesc', 
				editable:true,
				data: Data["rows"],
				panelHeight:90,
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
				},
				onLoadSuccess:function(){
					if (ServerObj.PersonFlag=="Y"){
						var sbox = $HUI.combobox("#Loc");
						sbox.select(ServerObj.InitLocID);
						$("#Loc").combobox("disable");
					}
				}
		 });
	});
}
function LoadDoc(LocId){
	$.cm({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		dataType:"json",
		DepID:LocId,
		Type:"", UserID:"", Group:"", MarkCodeName:"",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Doc", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				panelHeight:50,
				filter: function(q, row){
					return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) //||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onLoadSuccess:function(){
					if (ServerObj.PersonFlag=="Y"){
						var sbox = $HUI.combobox("#Doc");
						sbox.select(ServerObj.InitDocID);
						$("#Doc").combobox("disable");
					}
				}
		 });
	});
}
function leavehandlerclick(){
	var Loc=$("#Loc").combobox('getValue');
	if (Loc==""){
		$.messager.alert("提示","科室不能为空")
		return false;
		}
	var Doc=$("#Doc").combobox('getValue');
	if (Doc==""){
		$.messager.alert("提示","医生不能为空")
		return false;
		}
	var suspendreason=$("#suspendreason").combobox('getValue');
	if (suspendreason==""){
		$.messager.alert("提示","离开原因不能为空")
		return false;
		}
	var suspendTime=$("#suspendTime").val()
	if (suspendTime==""){
		$.messager.alert("提示","离开时长不能为空")
		return false;
		}
	if (isNaN(suspendTime)){
			$.messager.alert("提示","离开时长请输入有效数字!");
		    return false;
		}
	if (isPositiveInteger(suspendTime)==false){
			$.messager.alert("提示","离开时长为正整数!");
		    return false;
		}
	var CheckFlag=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"CheckSuspendStatus",
		dataType:"text",
		LocDr:Loc, DocDr:Doc
	},false);
	if (CheckFlag.split("^")[0]!="0"){
		$.messager.alert("提示","医生已离开，请点击归来按钮")
		return false;
		}
	var rtn=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"SuspendRecentLevea",
		 dataType:"text",
		LocDr:Loc, DocDr:Doc, SuspendReason:suspendreason, RangTime:suspendTime, UserID:session['LOGON.USERID']
	},false)
	if (rtn=="0"){
		$.messager.alert("提示","已离开")
		}else{
		$.messager.alert("提示","保存失败"+rtn)
		return false;
		}
	}
function backhandlerclick(){
		var Loc=$("#Loc").combobox('getValue');
	if (Loc==""){
		$.messager.alert("提示","科室不能为空")
		return false;
		}
	var Doc=$("#Doc").combobox('getValue');
	if (Doc==""){
		$.messager.alert("提示","医生不能为空")
		return false;
		}
	var CheckFlag=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"CheckSuspendStatus",
		 dataType:"text",
		LocDr:Loc, DocDr:Doc
	},false)
	if (CheckFlag.split("^")[0]=="0"){
		$.messager.alert("提示","医生未离开，请点击离开按钮")
		return false;
		}
	var RowID=CheckFlag.split("^")[1]
	var rtn=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"SuspendRecentBack",
		 dataType:"text",
		RowID:RowID, UserID:session['LOGON.USERID']
	},false)
	if (rtn=="0"){
		$.messager.alert("提示","已归来")
		}else{
		$.messager.alert("提示","归来失败"+rtn)	
		return false;
		}
	}
function isPositiveInteger(s){//是否为正整数
            var re = /^[0-9]+$/ ;
            return re.test(s)
        }    
