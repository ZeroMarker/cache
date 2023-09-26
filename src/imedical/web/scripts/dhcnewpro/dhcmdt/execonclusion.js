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
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var cancelFlag="N";

/// ҳ���ʼ������
function initPageDefault(){
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitLocGrpGrid();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	CstID = getParam("ID");   			 /// ����ID
	mradm = getParam("mradm");           /// �������ID
	WriType = getParam("WriType");       /// ��������
	showModel = getParam("showModel");

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
		$("#mdtDiscuss").attr("disabled", true);  /// ��������
		$("#mdtPurpose").attr("disabled", true);  /// ����Ŀ��
		$("#mdtOpinion").attr("disabled", false); /// �������
	}
	/// �Ƿ�ɱ༭
	if(showModel == 3){
		$("#bt_grpaddloc").hide();
		$("#bt_grpcencel").hide();	
	}

}

/// ��ʼ������ؼ�����
function InitPageComponent(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	})
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
	$("#mdtDiscuss").val(itemobj.DisProcess);	    /// ��������
	$("#mdtSuppsnote").val(itemobj.suppnotes);	    /// ��������
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
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
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID;
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
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
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110,editor:HosEditor,align:'center',hidden:true},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'center'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'center'},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'center',hidden:false},
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
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

        }
	};
	/// ��������
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=O";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
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
	
	if ((WriType != "P")&(mdtOpinion.replace(/\s/g,'') == "")){
		$.messager.alert("��ʾ:","����д���������","warning");
		return;
	}
	
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// �����������
	
	/// �������
	var ConsDetArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID;
		    ConsDetArr.push(TmpData);
		}
	})
	var ConsDetList = ConsDetArr.join("@");
	
	var mListData = mdtTrePro +"^"+ mdtPurpose +"^"+ mdtOpinion +"^"+ mdtDiscuss +"^"+mdtSuppsnote+"^"+ConsDetList;
	
	runClassMethod("web.DHCMDTConsult","CompCstNo",{"CstID": CstID, "WriType":(OperFlag == "S"?"S":WriType), "LgParam":LgParam, "mListData":mListData},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������"+ (WriType == "P"?"����":"ִ��") +"������","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
		}else{
			if (OperFlag == "S"){
				$.messager.alert("��ʾ:","����ɹ���","info");
			}else{
				//$.messager.alert("��ʾ:","����ɹ���","info");
				window.parent.reLoadMainPanel(EpisodeID);
			}
		}
			
		
	},'',false)	
	
	
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
	$(".container").height(Height - 280);
	$(".p-content").height(Height - 280);
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
		{field:'LocID',title:'����ID',width:100,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:200,align:'center'},
		{field:'UserID',title:'ҽ��ID',width:110,align:'center',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,align:'center'},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,align:'center',hidden:false},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID+"&Type=I";
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
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