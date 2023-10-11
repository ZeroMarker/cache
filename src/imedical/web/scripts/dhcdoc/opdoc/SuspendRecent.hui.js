$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
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
	//��ʼ������
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
		$.messager.alert("��ʾ","���Ҳ���Ϊ��")
		return false;
		}
	var Doc=$("#Doc").combobox('getValue');
	if (Doc==""){
		$.messager.alert("��ʾ","ҽ������Ϊ��")
		return false;
		}
	var suspendreason=$("#suspendreason").combobox('getValue');
	if (suspendreason==""){
		$.messager.alert("��ʾ","�뿪ԭ����Ϊ��")
		return false;
		}
	var suspendTime=$("#suspendTime").val()
	if (suspendTime==""){
		$.messager.alert("��ʾ","�뿪ʱ������Ϊ��")
		return false;
		}
	if (isNaN(suspendTime)){
			$.messager.alert("��ʾ","�뿪ʱ����������Ч����!");
		    return false;
		}
	if (isPositiveInteger(suspendTime)==false){
			$.messager.alert("��ʾ","�뿪ʱ��Ϊ������!");
		    return false;
		}
	var CheckFlag=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"CheckSuspendStatus",
		dataType:"text",
		LocDr:Loc, DocDr:Doc
	},false);
	if (CheckFlag.split("^")[0]!="0"){
		$.messager.alert("��ʾ","ҽ�����뿪������������ť")
		return false;
		}
	var rtn=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"SuspendRecentLevea",
		 dataType:"text",
		LocDr:Loc, DocDr:Doc, SuspendReason:suspendreason, RangTime:suspendTime, UserID:session['LOGON.USERID']
	},false)
	if (rtn=="0"){
		$.messager.alert("��ʾ","���뿪")
		}else{
		$.messager.alert("��ʾ","����ʧ��"+rtn)
		return false;
		}
	}
function backhandlerclick(){
		var Loc=$("#Loc").combobox('getValue');
	if (Loc==""){
		$.messager.alert("��ʾ","���Ҳ���Ϊ��")
		return false;
		}
	var Doc=$("#Doc").combobox('getValue');
	if (Doc==""){
		$.messager.alert("��ʾ","ҽ������Ϊ��")
		return false;
		}
	var CheckFlag=$.cm({
		ClassName:"DHCDoc.OPDoc.SuspendRecentDoc",
		MethodName:"CheckSuspendStatus",
		 dataType:"text",
		LocDr:Loc, DocDr:Doc
	},false)
	if (CheckFlag.split("^")[0]=="0"){
		$.messager.alert("��ʾ","ҽ��δ�뿪�������뿪��ť")
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
		$.messager.alert("��ʾ","�ѹ���")
		}else{
		$.messager.alert("��ʾ","����ʧ��"+rtn)	
		return false;
		}
	}
function isPositiveInteger(s){//�Ƿ�Ϊ������
            var re = /^[0-9]+$/ ;
            return re.test(s)
        }    
