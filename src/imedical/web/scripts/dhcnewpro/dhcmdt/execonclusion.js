//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-24
// ����:	   ִ��mdt���뵥
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CstID = "";         /// ��������ID
var editSelRow = -1;
var isEditFlag = 1;     /// ҳ���Ƿ�ɱ༭
var LType = "CONSULT";  /// ������Ҵ���
var WriType = "";       /// ��������
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID']; /// ��ȫ��ID
var LgUserCode = session['LOGON.USERCODE'];
var LgUserName = session['LOGON.USERNAME']
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var YnTableOk=false,ZnTableOk=false;
var cancelFlag="N";

/// ҳ���ʼ������
function initPageDefault(){
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	//LoadMoreScr();
	//SeletOrdTab();
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitLocGrpGrid();
	InitOuterExpGrid();
	SetMdtDiscuss();
	InitRoomEvent();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	CstID = getParam("ID");   			 /// ����ID
	mradm = getParam("mradm");           /// �������ID
	WriType = getParam("WriType");       /// ��������
	showModel = getParam("showModel");
	bizCode = "onMDTChat";
	bizId = CstID;
	
	IsOpenMoreScreen=0  //��ⶼ��д����
	if(IsOpenMoreScreen){
		MWScreens=top.MWScreens
	
	}else{
		$("#bt_openVc").hide();
		}
	if(showModel==3){
		$("#mdtTrePro").attr("disabled", true);
		$("#mdtDiscuss").attr("disabled", true);
		$("#mdtPurpose").attr("disabled", true);
		$("#mdtOpinion").attr("disabled", true);
		$("#bt_cancel").hide();
		$("#bt_send").hide();
		$("#bt_sign").hide();
		$("#bt_save").hide();
	}
	/// ����
	if (WriType == "P"){
		$("#mdtTrePro").attr("disabled", true);   /// ����ժҪ
		$("#mdtDiscuss").attr("disabled", false); /// ��������
		$("#mdtPurpose").attr("disabled", true);  /// ����Ŀ��
		$("#mdtOpinion").attr("disabled", true);  /// �������	
	}
	/// ִ��
	if (WriType == "E"){
		$("#mdtTrePro").attr("disabled", true);   /// ����ժҪ
		if(CONSDISRUL==1){
			$("#mdtDiscuss").attr("disabled", true);  /// ��������
		}else{
			$("#mdtDiscuss").attr("disabled", false);  /// ��������
		}
		$("#mdtPurpose").attr("disabled", true);  /// ����Ŀ��
		$("#mdtOpinion").attr("disabled", false); /// �������
	}
	/// �Ƿ�ɱ༭
	if(showModel == 3){
		$("#bt_grpaddloc").hide();
		$("#bt_grpcencel").hide();	
	}
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:CstID,
		LgParams:LgParam,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	///������
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
	CstStatusCode=RetDataArr[4];
	IsHideEdit=((CstStatusCode==80)||(CONSDISRUL!=1))
	IsHideSign=((CstStatusCode!=80)||(CAFLAG!=1))
}

///�����������
function InitRoomEvent(){
	AddMonitor();
	SendInRoom();	
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	if((MDCONTACTSFLAG=="1")&&(IsContact!="Y")){
		//$("#bt_cancel").linkbutton('disable');	
		$("#bt_send").linkbutton('disable');
		$("#bt_save").linkbutton('disable');
		if(showModel!=="3"){		///�鿴ģʽ
			$.messager.alert("��ʾ:","�ǻ���������,�޷�������ɲ���!");
		}
	}

	if(CONSDISRUL==1){
		$("#mdtDiscuss").attr("placeholder","����ר���б����������,������ר����д!");
	}

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	})
}

function InitMdtDiscussTemp(){
	
	if(CONSDISRUL==1) return;
	
	if((!YnTableOk)||(!ZnTableOk)) return;
	
	var mdtDisc =$("#mdtDiscuss").val();
	var locGrpListData=$("#LocGrpList").datagrid("getData").rows;
	var dgCstDetListData=$("#dgCstDetList").datagrid("getData").rows;
	
	
	if(mdtDisc==""){
		for (i in locGrpListData){
			if(locGrpListData[i].UserName=="") continue;
			mdtDisc=mdtDisc+locGrpListData[i].LocDesc+locGrpListData[i].UserName+":"+"\r\n\n";
		}
		for (i in dgCstDetListData){
			if(dgCstDetListData[i].UserName=="") continue;
			mdtDisc=mdtDisc+dgCstDetListData[i].LocDesc+dgCstDetListData[i].UserName+":"+"\r\n\n";
		}
		$("#mdtDiscuss").val(mdtDisc);
	}
	return;
}

/// ���û������뵥����
function InsCstNoObj(itemobj){
	
	$("#patName").val(itemobj.PatName);
	$("#patSex").val(itemobj.PatSex);
	$("#patAge").val(itemobj.PatAge);
	$("#patNo").val(itemobj.PatNo);
	$("#medicalNo").val(itemobj.MedicalNo);
	$("#patTelH").val(itemobj.PatTelH);
	$("#mdtDiag").val(itemobj.PatDiagDesc); /// �������
	
	$("#mdtTrePro").val($_TrsTxtToSymbol(itemobj.mdtTrePro));  		/// ��Ҫ����
	$("#mdtPurpose").val($_TrsTxtToSymbol(itemobj.mdtPurpose));  	/// ����Ŀ�� 
	//$("#mdtRUser").val(itemobj.CstRUser);   		/// ����ҽʦ
	$("#mdtAddr").val(itemobj.CstNPlace);           /// ����ص�
	//$("#mdtDiscuss").val(itemobj.DisProcess);	    /// ��������
	$("#mdtSuppsnote").val(itemobj.suppnotes);	    /// ��������
	$HUI.radio("input[name='mdtTumorFlag'][value='"+ itemobj.TumStage +"']").setValue(true); /// ����״̬
	var TreMeasures = "";
	if (itemobj.TreMeasures != ""){
		TreMeasures = itemobj.TreMeasures.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#mdtOpinion").val($_TrsTxtToSymbol(TreMeasures));       /// �������
	$HUI.combobox("#mdtDisGrp").setValue(itemobj.DisGrpID);    /// ���Ѳ���
	$HUI.combobox("#mdtDisGrp").setText(itemobj.DisGroup);     /// ���Ѳ���
	//$("#mdtCarPrv").val(itemobj.PrvDesc);                      /// ��Դ�ű�
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);   /// ����ʱ��
	
	EpisodeID = itemobj.EpisodeID;			/// ����ID
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// ��������ǿɱ༭
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// �Ƿ�����������뵥
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	PatType = itemobj.PatType;              /// ��������			
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'��Ժ'}, {"value":"O","text":'��Ժ'}];
	//������Ϊ�ɱ༭
	var HosEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// ���ұ༭��
	var LocEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);

				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// ��רҵ�༭��
	var MarEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
		
	// ҽʦ�༭��
	var DocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	
	///  ����columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,hidden:true},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110,editor:HosEditor,align:'left',hidden:true},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'left'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'left',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'left'},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'left',hidden:false},
		{field:'CASign',title:"CAǩ��",width:80,align:'left',formatter:SetCASignCellUrl,hidden:IsHideSign},
		{field:'EditAndView',title:"��������",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
			YnTableOk=true;
			InitMdtDiscussTemp();
        }
	};
	/// ��������
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O"+"&MWToken="+websys_getMWToken();
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}


//MDTר�һ�������
function SetEditViewCellUrl(value, rowData, rowIndex){
	var ItmID=rowData.itmID;
	var UserID=rowData.UserID;
	var CsUserID=rowData.CsUserID;
	var LocID=rowData.LocID;
	if(ItmID=="") {return;}
	//if(CsUserID!=LgUserID) {return;} ///�Լ�����Լ������
	
	var Text=rowData.HasOpinion=="1"?"<span style='color:#000;'>�޸�</span>":"��д";
	var Html="";
	if((MDCONTACTSFLAG=="1")&&(IsContact!="Y")){
		Html="<a href='#' style='color:#b7b7b7;'>"+Text+"</a>";
	}else{
		Html="<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"','')\">"+Text+"</a>";	
	}
	return Html;
	
	/*
	var itmCodes = "80";	
	if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){	///�Ѿ����,δǩ�������޸�
		if(LgLocID==LocID){   //����ҽ��
			return "<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"')\">�����д</a>";
		}
	}
	*/
	return "";
}


//ר���Ƿ��Ѿ�ǩ������
function IsgetsignmdtSIGNID(ItmID)
{  
    var IsCASign = "";
	runClassMethod("web.DHCMDTSignVerify","IsgetsignmdtSIGNID",{"mdtID":ItmID},function(jsonString){
		IsCASign = jsonString;     
	},'',false)
	return IsCASign;
	
}


/// ��������
function showEditWin(ItmID,UserID,LocID,IsCaSign){
		
	//ר���Ƿ��Ѿ�ǩ������
	var IsCASign=IsgetsignmdtSIGNID(ItmID)
	if(IsCASign==1){
		$.messager.alert("��ʾ", "����ר���Ѿ�ǩ��,�����޸Ļ����������ݣ�","warning")	
	    return;
	}
	
	var Link = "dhcmdt.consopinion.csp?ItmID="+ItmID+"&CsStatCode="+CsStatCode+"&UserID="+UserID+"&LocID="+LocID +"&CstID="+CstID+"&IsCaSign="+IsCaSign;
	commonShowWin({
		url: Link,
		title: "��������",
		width: 820,
		height: 490
	})	
}

/// ��ǰ�û�Ȩ��
function GetIsPerFlag(CstID){

	var IsPerFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTFolUpVis","GetIsPerFlag",{"CstID":CstID,"LgParam":LgParam},function(jsonString){
		if (jsonString != ""){
			IsPerFlag = jsonString;
		}
	},'',false)
	return IsPerFlag
}


/// ����
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// ɾ����
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>2){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'I', HosType:'��Ժ', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// ȡ���ҵ绰
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// ȡҽ���绰
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// ���
/**function mdtCompCs(){
	if (WriType == "E"){
		$.messager.confirm("��ʾ","��ȷ��Ҫ�����?����ִ����ɺ����ݲ����޸ģ�",function(r){
			if(r){
				mdtSend();
			}
		});
	}else{
		mdtSend();  /// ���� 
	}

}*/

/// �ݴ�
function mdtSave(){
	mdtSend("S");
}

/// ���
function mdtCompCs(){
	mdtSend("");
}
/// ����
function mdtSend(OperFlag){
	
	var mdtTrePro = $("#mdtTrePro").val();				///����ժҪ 
	var mdtPurpose = $("#mdtPurpose").val();			///����Ŀ�� 
	var mdtOpinion = $("#mdtOpinion").val();			///�������
	var mdtDiscuss = $("#mdtDiscuss").val();			///��������
	var mdtSuppsnote = $("#mdtSuppsnote").val();
	
	///�ݴ�
	if (OperFlag=="S"){
		if((!mdtOpinion.replace(/\s/g,''))&&(!mdtDiscuss.replace(/\s/g,''))){
			$.messager.alert("��ʾ:","����д�������ۺ������","warning");
			return;
		}
	}
	
	if(!OperFlag){
		if(!mdtOpinion.replace(/\s/g,'')){
			$.messager.alert("��ʾ:","����д���������","warning");
			return;	
		}
	}
	
	var InWriType = (OperFlag == "S"?"S":WriType);
	
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// �����������
	
	/// �������
	var ConsDetArr=[];
	/*
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID;
		    ConsDetArr.push(TmpData);
		}
	})
	*/
	var ConsDetList = ConsDetArr.join("@");
	
	var mdtTumorFlag = $("input[name='mdtTumorFlag']:checked").val();   /// ����״̬
	if (typeof CstEvaRFlag == "undefined"){mdtTumorFlag == ""}
	
	var mListData = mdtTrePro +"^"+ mdtPurpose +"^"+ mdtOpinion +"^"+ mdtDiscuss +"^"+mdtSuppsnote+"^"+ConsDetList+"^"+mdtTumorFlag;
	
	runClassMethod("web.DHCMDTConsult","CompCstNo",{"CstID": CstID, "WriType":InWriType, "LgParam":LgParam, "mListData":mListData},function(jsonString){
		
		if(jsonString==0){
			if (OperFlag == "S"){
				$.messager.alert("��ʾ:","����ɹ���","info");
			}else{
				CompCstNoFun(CstID);
			}	
		}else{
			$.messager.alert("��ʾ:","ʧ��,��Ϣ:"+jsonString,"info");			
		}
	},'',false)	
}

function CompCstNoFun(){
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTConsultQuery",
		MethodName:"OpenEmrData",
		CstID:CstID,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	var EpisodeID=RetDataArr[0];
	var InstanceID=RetDataArr[1];

	if(COMPISOPEEMR==1){
		///&DisplayType=&NavShowType=&RecordShowType=
		var url="emr.interface.ip.mdtconsult.csp?EpisodeID="+EpisodeID+"&InstanceID="+InstanceID+
				"&FromCode="+CstID+"&CTlocID="+LgLocID+"&UserID="+LgUserID+"&ShowNav=N"+"&MWToken="+websys_getMWToken();
		window.open(url,"_blank","height="+(window.screen.availHeight-80)+"px,width="+window.screen.availWidth-100+"px, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	window.parent.reLoadMainPanel(EpisodeID);	
}

/// ȡ��
function mdtCancel(){
	
	window.parent.$("#mdtPopAccWin").window("close");
}

/// ǩ��
function mdtSignCs(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","mdt��������ID����Ϊ�գ�","warning");
		return;
	}
	InvDigSign(CstID); /// ��������ǩ��
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){

	var Width = document.body.offsetWidth;
	//var Height = document.body.scrollHeight;
	var Height = window.screen.availHeight;
	$(".container").height(Height - 250);
	$(".p-content").height(Height - 250);
}

/// ���
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// ���ڿ���
		//$("#GrpLocArr").html('<span style="margin-top:40px;margin-left:300px;">��ѡ�����ר���飡</span>');
		$("#LocGrpList").datagrid("reload",{GrpID:''});
	}else{
		/// Ժ�ڿ���
		$("#dgCstDetList").datagrid("reload",{GrpID:''});
		//$("#dgCstDetList").datagrid('loadData',{total:0,rows:[]});
	}
}

function ReloadTable(){
	$("#LocGrpList").datagrid("reload");
	$("#dgCstDetList").datagrid("reload");
	$("#OuterExpList").datagrid("reload");
	SetMdtDiscuss();
}

/// ����
function SetLocCellUrl(value, rowData, rowIndex){	
	var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/edit_remove.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
	return html;
}

/// ��ʼ���������б�
function InitLocGrpGrid(){
	
	///  ����columns
	var hideFlags=""
	if(CstID!=""){
	hideFlags="true"
		}
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'left',hidden:true},
		{field:'LocDesc',title:'����',width:200,align:'left'},
		{field:'UserID',title:'ҽ��ID',width:110,align:'left',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,align:'left'},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'left',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,align:'left',hidden:false},
		{field:'CASign',title:"CAǩ��",width:80,align:'left',formatter:SetCASignCellUrl,hidden:IsHideSign},
		{field:'EditAndView',title:"��������",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit},
		{field:'operation',title:"����",width:100,align:'left',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
        
        },
        onLoadSuccess: function (data) { //���ݼ�������¼�
			ZnTableOk=true;
			InitMdtDiscussTemp();
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I"+"&MWToken="+websys_getMWToken();
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}



/// ��ʼ����Ժר���б�
function InitOuterExpGrid(){
	
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'left',hidden:true},
		{field:'LocDesc',title:'����',width:200,align:'left'},
		{field:'UserID',title:'ҽ��ID',width:110,align:'left',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,align:'left'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'left'},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'left',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,align:'left',hidden:false},
		{field:'EditAndView',title:"��������",width:80,align:'left',formatter:SetEditViewCellUrl,hidden:IsHideEdit}
	]];
	
	///  ����datagrid
	var option = {
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
		border:true,
		bodyCls:'panel-header-gray',
		headerCls:'panel-header-gray',
	    onClickRow: function (rowIndex, rowData) {  
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=E"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}

function SetMdtDiscuss(){
	$.cm({ 
		ClassName:"web.DHCMDTConsultQuery",
		MethodName:"GetMdtDiscuss",
		MdtID:CstID,
		Type:CONSDISRUL,
		dataType:"text"
	},function(retData){
		retData=retData.replace(new RegExp('<br>',"g"),'\n')
		$("#mdtDiscuss").val(retData);
	});
}

function SetCASignCellUrl(value, rowData, rowIndex){
	var ItmID=rowData.itmID
	var UserID=rowData.UserID
	var LocID=rowData.LocID
	if(ItmID=="") {return;}
	
	if(rowData.CaImage!=""){
		return '<img onclick=\'showEditWin("'+ItmID+'","'+UserID+'","'+LocID+'","1")\' style="height: 30px;width: 100%;" src="data:image/jpg;base64,'+rowData.CaImage+'"/>'
	}
	
	if((rowData.LocID==LgLocID)&&(rowData.CsUserID==LgUserID)){
		return "<a href='#' onclick=\"showEditWin('"+ItmID+"','"+UserID+"','"+LocID+"','1')\">ǩ��</a>";	
	}
	return "";
}

/// �Ƿ��������
function GetIsTakOperFlagNew(CstID, ToStCode){
	var Ret=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"ValidStatus",
		ID:CstID,ToStatusIdCode:ToStCode,
		dataType:"text"
	}, false);
	return Ret;
}


function AddMonitor(){
	websys_on(bizCode+bizId,function(data){ /*���뷿�����ܼ���������Ϣ*/
		console.log(data);
		if (data.eventType=='join'){
			console.log(data.fromUser +"����->"+data.toUser+"�����");
		}else if (data.eventType=='leave'){
			console.log(data.username +"�뿪->"+data.toUser+"�����");
		}else{
			console.log("�յ�->����ţ�"+data.extend.opt.usercode+":"+data.usercode+":"+data.toUser+", �ı����ݣ�"+data.extend.opt.content);
			
			if(data.extend.opt.ParCode==="ConsTalk"){
				jumpDiscuss(data.extend.opt.CstID);
			}else{
				saveMdtOp(data.extend.opt.usercode,data.extend.opt.content);
			}
		}
	});	
	
	window.onunload = function(){
		//websys_leaveChatRoom(bizCode,bizId);
	};
}

function mdtOpenVc(){
	var Obj={
		PatientID:PatientID,
		EpisodeID:EpisodeID,
		ID:CstID
	}
	//websys_emit("onMdtOpenVideo",Obj); ///������Ƶ����
	//var url=window.location.origin+"/imedical/web/csp/dhcmdt.videocall.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ID="+CstID;
	var url="https://ai.imedway.cn/trtc?u="+LgUserID+"&r="+CstID+"&auto=1";
	chromeOpen(url);
	
	$.messager.confirm("��ʾ","�Ƿ����ͻ������Ӹ����л���ר��?",function(r){
		if(r){
			sendVcUrl(CstID);
		}
	});
	return;		
}


function chromeOpen(urlParam){
	
	exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	exec('"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	exec('"C:\\Users\\sun_h\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	
	return;
	
	if(!IsOpenMoreScreen){
		websys_showModal({
			url:urlParam,
			title:"��ѧ����Ƶ",
			iconCls:"icon-w-paper",
			width:$(window).width()-200,
			height:$(window).height()-200,
			onClose: function() {	
			}
		});	
	}
	
	
	///û�и���Ļ
	/*
	if(MWScreens.screens.length==1) {
		exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
		var ex = "ScreenMax"
		setTimeout(function(){
			CMgr.moveWindow("",0,0,MWScreens.screens[0].WorkingArea.Width,MWScreens.screens[0].WorkingArea.Height,ex);
		},500);	
		return;
	}
	*/
	
	var scPos=2; ///��?����
	MWScreens.length==2?scPos=1:""; ///��һ����,û�еڶ�����
	
	var scWidthPos=MWScreens.screens[0].Bounds.Width+1;
	scPos==2?(scWidthPos=scWidthPos+MWScreens.screens[1].Bounds.Width):"";
	var scWidth=MWScreens.screens[scPos].WorkingArea.Width;
	var scHeight=MWScreens.screens[scPos].WorkingArea.Height;

	exec('"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" "'+urlParam+'"');
	var ex = "ScreenMax"
	setTimeout(function(){
		CMgr.moveWindow("",scWidthPos,0,scWidth,scHeight,ex);
	},500);	
}

function sendVcUrl(){
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"SendVcUrl",
		MdtID:CstID,
		LgParams:LgParam,
		dataType:"text"
	},function(ret){
		$.messager.alert("��ʾ:","��Ϣ�������!");
		return;
	});	
}

function SendInRoom(){
	websys_emit(bizCode,{type:"cross-device",bizId:bizId,content:LgUserCode+"("+LgUserName+")������"+bizId+"����",mdt:""});	
}

function jumpDiscuss(CstID){
	var url="dhcmdt.consdiscuss.csp?CstID="+CstID; ///
	var _opWin=window.open("",bizCode+bizId+"Win");
	if(_opWin) _opWin.close();
	window.location.href=url;
}

function openTemp(){
	var url="dhcmdt.constemp.csp?mark=O"
	//window.open(url,"_blank","height="+(window.screen.availHeight-80)+"px,width="+window.screen.availWidth-100+"px, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	window.open(url,"_blank","height=600px,width=1100px, top=200, left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

function tempValue(mark,value){
	var mdtOpinion=$('#mdtOpinion').val();
	var mdtOpinion=mdtOpinion+(mdtOpinion==''?'':'\n')+value;
	$('#mdtOpinion').val(mdtOpinion);
	return;
}

function saveMdtOp(userCode,mdtOpinion){
	
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"UpdConItmOpionUserCode",
		MdtID:CstID,
		UserCode:userCode,
		MdtOpinion:mdtOpinion,
		dataType:"text"
	},function(ret){
		if (ret < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
		}else{
			ReloadTable()
		}
		return;
	});		
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ��ֲ�
	onresize_handler();
}
window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })