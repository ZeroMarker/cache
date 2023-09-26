var PageLogicObj={
	m_PilotProListTabDataGrid:"",
	m_PilotProCareListTabDataGrid:""
};
$(function(){	
	//ҳ�����ݳ�ʼ��
	Init();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//���ر������
	PilotProListTabDataGridLoad();
	//�¼���ʼ��
	InitEvent();
});
function InitEvent(){
	$("#UpdateWarnSum").click(UpdateWarnSumClick);
	$("#BFind").click(FindClick);
	$("#FindPilotPro").keydown(FindPilotProKeydown);
	$("#FindPilotPro").change(FindPilotProChange);
}
function UpdateWarnSumClick(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ŀ!");
		return false;
	}
	var SelProjectRowId=row["PPRowId"];
	var WarnSum=$("#WarnSum").val();
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"AddPPWarnSum",
		dataType:"text",
		PPRowId:SelProjectRowId,
		PPWarnSum:WarnSum,
		UserDr:session['LOGON.USERID']
	},function(ret){
		if (ret==0){
			$.messager.alert("��ʾ","����ɹ���")
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�")
		}
	}); 
}
function FindPilotProKeydown(e){
	if(e.keyCode==13){
		FindClick();
	}
}
function FindPilotProChange(){
	var q=$("#FindPilotPro").val().toUpperCase();
	if (q==""){
		FindClick();
	}
}
function FindClick(){
	var q=$("#FindPilotPro").val().toUpperCase();
	PageLogicObj.m_PilotProListTabDataGrid.datagrid('uncheckAll');
	ClearPilotProListTab();
	ClearPilotProCareListTab();
	PilotProListTabDataGridLoad();
	if (q=="") return;
	setTimeout(function(){
		var rows=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getRows');
		for (var i=rows.length-1;i>=0;i--){
			var PPRName=rows[i]["PPRName"];
			var PPRDesc=PPRName.split("-")[0].toUpperCase();
			var PPRCode=PPRName.split("-")[1].toUpperCase();
			if ((PPRDesc.indexOf(q)>=0)||(PPRCode.indexOf(q)>=0)){
			}else{
				PageLogicObj.m_PilotProListTabDataGrid.datagrid('deleteRow',i);
			}
		}
	})
}
function PageHandle(){
	LoadStartUser();
}
function LoadStartUser(){
	var Data=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		QueryName:"Finduse",
		dataType:"json",
		Desc:"",
		rows:99999
	},false); 
	var cbox = $HUI.combobox("#UserName", {
			valueField: 'SSUSR_RowId',
			textField: 'SSUSR_Name', 
			editable:true,
			data: Data["rows"],
			onChange:function(newValue,OldValue){
				if (newValue==""){
					var cbox = $HUI.combobox("#PPRReceiverLook");
					cbox.setValue("");
				}
			},
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["SSUSR_Name"].toUpperCase().indexOf(q) >= 0)||(row["SSUSR_Initials"].toUpperCase().indexOf(q) >= 0);
			}
	 });
}
function Init(){
	PageLogicObj.m_PilotProListTabDataGrid=InitPilotProListTabDataGrid();
	PageLogicObj.m_PilotProCareListTabDataGrid=InitPilotProCareListTabDataGrid();
}
function InitPilotProListTabDataGrid(){
	var Columns=[[ 
		{field:'PPRowId',hidden:true,title:''},
		{field:'PPRName',title:'��Ŀ����',width:377,
			styler: function(value,row,index){
					return 'border-right:0;';
			}
		}
    ]]
	var PilotProListTabDataGrid=$("#PilotProListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		rownumbers : true,  
		idField:'PPRowId',
		columns :Columns,
		onSelect:function(index, row){
			selProjectChange(false);
			PilotProCareListTabDataGridLoad(row["PPRowId"]);
			SetWarnSum(row["PPRowId"]);
		},
		onUncheck:function(index, row){
			selProjectChange(true);
			PilotProCareListTabDataGridLoad(row["PPRowId"]);
		}
	}); 
	return PilotProListTabDataGrid;
}
function selProjectChange(disabled){
	$('#WarnSum').attr("disabled",disabled);
	if (disabled){
		$("#UserName").combobox("disable");
		$("#UserName").combobox("select","");
		$("#UpdateWarnSum").hide();
		$("##WarnSum").val("");
		
	}else{
		$("#UserName").combobox("enable");
		$("#UserName").combobox("select","");
		$("#UpdateWarnSum").show();
	}
	$("#ContactTel").val("");
	$("#ContactFlag").checkbox('setValue',false);
	
}
function PilotProListTabDataGridLoad(){
	var myArray=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectStrSelf",
		dataType:"text"
	},false);
	for (var i=0;i<myArray.split("^").length;i++){
		var myArrayTemp=myArray.split("^")[i];
		var rtnArrayTemp=myArrayTemp.split(String.fromCharCode(1));
		if (rtnArrayTemp[0]==""){continue;}
		PageLogicObj.m_PilotProListTabDataGrid.datagrid('appendRow',{
			PPRowId: rtnArrayTemp[0],
			PPRName: rtnArrayTemp[1]
		});
	} 
}
function InitPilotProCareListTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {SaveClickHandle();}
    }];
	var Columns=[[ 
		{field:'UserDr',hidden:true,title:''},
		{field:'UserName',title:'������',width:200},
		{field:'ContactTel',title:'��ϵ�绰',width:200},
		{field:'ContactFlag',title:'�Ƿ���ϵ��',width:200,
			formatter:function(value,record){
	 			if (value=="Y") return "��";
	 			else  return "��";
	 		},styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else {
		 			return 'color:#f16e57;';
		 		}
			}
		}
    ]]
	var PilotProCareListTabDataGrid=$("#PilotProCareListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : false,  
		rownumbers : true,  
		idField:'UserDr',
		columns :Columns,
		toolbar:toobar,
		onSelect:function(index, row){
			ChangeContactStatus(false);
			SetProCareInfo(row["UserDr"]);
		},onUnselect:function(index,row){
			var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getSelections');
			if (rows.length==0){
				ChangeContactStatus(true);
				$("#ContactFlag").checkbox("setValue",false);
				$("#ContactTel").val("");
			}else{
				var UserDr=rows[rows.length-1]["UserDr"];
				SetProCareInfo(UserDr);
			}
		}
	}); 
	return PilotProCareListTabDataGrid;
}
function SetProCareInfo(JionUserRowId){
	$("#ContactFlag").checkbox("setValue",false);
	$("#ContactTel").val("");
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	var SelProjectRowId=row["PPRowId"];
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProCareInfo",
		PPRowId:SelProjectRowId,
		UserRowId:JionUserRowId,
		dataType:"text"
	},function(ProCareInfo){
		if (ProCareInfo!=""){
			var ProCareAry=ProCareInfo.split("^");
			var Rowid=ProCareAry[0];
			var JoinUserDr=ProCareAry[1];
			var DoctorDr=ProCareAry[2];
			var CurGroupDr=ProCareAry[3];
			var Level=ProCareAry[4];
			var State=ProCareAry[5];
			var StartDate=ProCareAry[6];
			var EndDate=ProCareAry[7];
			var Note1=ProCareAry[8];
			var Note2=ProCareAry[9];
			var ContactFlag=ProCareAry[10];
			var ContactTel=ProCareAry[11];
			if (ContactFlag=="Y") {ContactFlag=true;}else{ContactFlag=false;}
			$("#ContactFlag").checkbox("setValue",ContactFlag);
			$("#ContactTel").val(ContactTel);
		}
	}); 
}
function ChangeContactStatus(disabled){
	$('#ContactTel').attr("disabled",disabled);
	$('#ContactFlag').checkbox("setDisable",disabled);
}
function PilotProCareListTabDataGridLoad(PPRowId){
	ClearPilotProCareListTab();
	ChangeContactStatus(true);
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetJoinUserStrByProID",
		PPRowId:PPRowId,
		dataType:"text"
	},function(myArray){
		var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
		var SelProjectRowId=row["PPRowId"];
		for (var i=0;i<myArray.split("^").length;i++){
			var myArrayTemp=myArray.split("^")[i];
			var rtnArrayTemp=myArrayTemp.split(String.fromCharCode(1));
			if (rtnArrayTemp[0]==""){continue;}
			var ContactFlag="N",ContactTel="";
			var ProCareInfo=$.cm({
				ClassName:"web.PilotProject.DHCDocPilotProject",
				MethodName:"GetProCareInfo",
				PPRowId:SelProjectRowId,
				UserRowId:rtnArrayTemp[0],
				dataType:"text"
			},false);
			if (ProCareInfo!=""){
				var ProCareAry=ProCareInfo.split("^");
				var ContactFlag=ProCareAry[10];
				var ContactTel=ProCareAry[11];
			}
			
			
			PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('appendRow',{
				UserDr: rtnArrayTemp[0],
				UserName: rtnArrayTemp[1],
				ContactFlag:ContactFlag,
				ContactTel:ContactTel
			});
		}
	}); 
}
function ClearPilotProCareListTab(){
	var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRows');
    for(var i=rows.length-1;i>=0;i--){
        var index = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRowIndex', rows[i]);  
        PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('deleteRow',index);
    }
}
function ClearPilotProListTab(){
	var rows = PageLogicObj.m_PilotProListTabDataGrid.datagrid('getRows');
    for(var i=rows.length-1;i>=0;i--){
        var index = PageLogicObj.m_PilotProListTabDataGrid.datagrid('getRowIndex', rows[i]);  
        PageLogicObj.m_PilotProListTabDataGrid.datagrid('deleteRow',index);
    }
}
function ClearPilotProCareListTab(){
	var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRows');
    for(var i=rows.length-1;i>=0;i--){
        var index = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRowIndex', rows[i]);  
        PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('deleteRow',index);
    }
	
}
function SaveClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","����ѡ�������Ŀ!");
		return false;
	}
	var PPRowId=row["PPRowId"];
	var SeledUserListStr="";
	var UserListStr="";
	var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRows');
	for (var i=0;i<rows.length;i++){
		var UserDr=rows[i]["UserDr"];
		var UserName=rows[i]["UserName"];
		if (UserListStr=="")UserListStr=UserDr+String.fromCharCode(2)+UserName;
		else UserListStr=UserListStr+String.fromCharCode(1)+UserDr+String.fromCharCode(2)+UserName;
	}
	var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<rows.length;i++){
		var UserDr=rows[i]["UserDr"];
		if (SeledUserListStr=="") SeledUserListStr=UserDr;
		else SeledUserListStr=SeledUserListStr+String.fromCharCode(1)+UserDr;
	}
	var ListStr=PPRowId+"!"+UserListStr;
	var o=$HUI.checkbox("#ContactFlag");
	if (o.getValue()){
		var ContactFlag="Y";
	}else{
		var ContactFlag="N";
	}
	var ContactTel=$("#ContactTel").val();
	if (ContactTel!=""){
		if (!CheckTelOrMobile(ContactTel,"ContactTel","")) return false;
	}
	var ExpStr=SeledUserListStr+"^"+ContactFlag+"^"+ContactTel;
	if ((ContactFlag=="Y")&&(ContactTel=="")) {
		$.messager.alert("��ʾ","��ϵ�˵���ϵ�绰����Ϊ��.","info",function(){
			$("#ContactTel").focus();
		})
		return false;
	}
	var ExistContactStr=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"CheckIsExistContact",
		PPRowId:PPRowId,
		SeledUserListStr:SeledUserListStr,
		ContactFlag:ContactFlag,
		dataType:"text"
	},false);
	//����Ŀ��������֮ǰ�Ƿ������ϵ�� 0 ������ 1 ����
	var ExistContactFlag=ExistContactStr.split('$')[0];
	if (ExistContactFlag=="0") {
		if (ContactFlag!="Y") {
			$.messager.alert("��ʾ","������ָ��һ����ϵ��.")
			return;
		}
		if((ContactFlag=="Y")&&(SeledUserListStr=="")){
			$.messager.alert("��ʾ","������ָ��һ����ϵ��.")
			return;
		}
	}
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"SaveMethod",
		CurGroupDr:session['LOGON.GROUPID'],
		ListStr:ListStr,
		ExpStr:ExpStr,
		UserID:session['LOGON.USERID'],
		dataType:"text"
	},function(myrtn){
		if (myrtn=="0"){
			$.messager.alert("��ʾ","����ɹ�!","info",function(){
				if (ContactFlag=="N") ContactFlag="";
				var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getSelections');
				for (var i=0;i<rows.length;i++){
					var UserDr=rows[i]["UserDr"];
					var index=PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRowIndex',UserDr);
					PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							ContactTel:ContactTel,
							ContactFlag:ContactFlag
						}
					});
				}
			});
		}else{
			$.messager.alert("��ʾ","����ʧ��! �������:"+myrtn);
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_PilotProListTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","����ѡ�������Ŀ!");
		return false;
	}
	var PPRowId=row["PPRowId"];
	var rows=PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getSelections');
	if ((!rows)||(rows.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ���Ĳ�����!");
		return false;
	}
	var SeledUserListStr="";
	var rows = PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<rows.length;i++){
		var UserDr=rows[i]["UserDr"];
		if (SeledUserListStr=="") SeledUserListStr=UserDr;
		else SeledUserListStr=SeledUserListStr+String.fromCharCode(1)+UserDr;
	}
	var ExistContactStr=$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"CheckIsExistContact",
		PPRowId:PPRowId,
		SeledUserListStr:SeledUserListStr,
		ContactFlag:"",
		dataType:"text"
	},false);
	//����Ŀ��������֮ǰ�Ƿ������ϵ�� 0 ������ 1 ����
	var ExistContactFlag=ExistContactStr.split('$')[0];
	if (ExistContactFlag==0){
		$.messager.alert("��ʾ","��ѡ���û�ɾ����,����Ŀû����ϵ��,������������ϵ�˺�,��ɾ��!")
		return;
	}
	for (var i=rows.length-1;i>=0;i--){
		var UserDr=rows[i]["UserDr"];
		var myrtn=$.cm({
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"DeleteProjectCare",
			PPRowId:PPRowId,
			UserRowId:UserDr,
			dataType:"text"
		},false);
		if (myrtn=="0"){
			var index=PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRowIndex',UserDr);
			PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('deleteRow',index);
			$("#ContactTel").val('');
			$("#ContactFlag").checkbox('uncheck').checkbox('disable');
			$("#UserName").prop("disabled",true);
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��! �������:"+myrtn);
		}
	}
	$.messager.alert("��ʾ","ɾ���ɹ�!");
}
function AddClickHandle(){
	var UserRowId=$("#UserName").combobox("getValue");
	UserRowId=CheckComboxSelData("UserName",UserRowId);
	if (UserRowId==""){
		$.messager.alert("��ʾ","��ѡ���û�!","info",function(){
			$('#UserName').next('span').find('input').focus();
		})
		return false;
	}
	var rows=PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('getRows');
	for (var i=0;i<rows.length;i++){
		var UserDr=rows[i]["UserDr"];
		if (UserDr==UserRowId){
			$.messager.alert("��ʾ","�������Ѿ�����!","info",function(){
				$('#UserName').next('span').find('input').focus();
			})
			return false;
		}
	}
	PageLogicObj.m_PilotProCareListTabDataGrid.datagrid('appendRow',{
		UserDr:UserRowId , 
		UserName: $("#UserName").combobox("getText")
	});
	$("#UserName").combobox("select","");
	$("#ContactTel").val('');
	$("#ContactFlag").checkbox('uncheck').checkbox('disable');
	$("#UserName").prop("disabled",true);
	
}
function SetWarnSum(PPRowId){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetWarnSum",
		PPRowId:PPRowId,
		UserId:session['LOGON.USERID'],
		dataType:"text"
	},function(WarnSum){
		$("#WarnSum").val(WarnSum);
	});
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="UserName"){
			var CombValue=Data[i].SSUSR_RowId;
		 	var CombDesc=Data[i].SSUSR_Name;
	     }else{
		    var CombValue=Data[i].rowid  
		 	var CombDesc=Data[i].Desc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}