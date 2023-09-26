//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";
var CstID = "";         /// ��������ID
var CstItmID = "";      /// ������ϸID
var editSelRow = -1;
var isWriteFlag = "-1";
var seeCstType="false"; ///�鿴ģʽ
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitPatCstID();           /// ��ʼ������ID
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	LoadDataGrid();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	viewMode = getParam("EpisodeID");
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
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			editable:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			}
		}
	}
	
	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			valueField: "value", 
			textField: "text",
			mode:'remote',
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
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
			//editable:false,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// ��ϵ��ʽ
				var TelPhone = GetCareProvPhone(option.value);
				if (TelPhone != ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val(TelPhone);
				}
				
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:120,editor:PrvTpEditor,align:'center'},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:260,editor:LocEditor,align:'center'},
		{field:'UserID',title:'ҽ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'ҽ��',width:160,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"����",width:110,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){

	    },
	    onDblClickRow: function (rowIndex, rowData) {

            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            } 
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
        }
	};
	/// ��������
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
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

	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>4){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// �������
function insRow(){
	
	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// ���Ͳ�������
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
	var ConsTrePro = $("#ConsTrePro").val();  		/// ��Ҫ����
	if (ConsPurpose == ""){
		$.messager.alert("��ʾ:","���λ��ﲡ�˼�Ҫ��������Ϊ�գ�");
		return;
	}
	var ConsPurpose = $("#ConsPurpose").val();  	/// ����Ŀ��
	if (ConsPurpose == ""){
		$.messager.alert("��ʾ:","���λ���Ŀ�Ĳ���Ϊ�գ�");
		return;
	}
	var ConsNote = $("#ConsNote").val();  			/// ��ע
	
	var CsRUserID = session['LOGON.USERID'];  		/// �������
	var CsRLocID = session['LOGON.CTLOCID'];  		/// ������
	
	var ConsEmFlag = $("input[name='CstType']:checked").val();    /// ��������
	var ConsUnitFlag =  $("input[name='CstUnit']:checked").val(); /// Ժ��Ժ��

	var CstDate = $HUI.datebox("#CstDate").getValue();      /// ��������
	var CstTime = $HUI.timespinner("#CstTime").getValue();  /// ����ʱ��
	
	var CstUnit = $("#CstUnit").val(); /// ��Ժ����
	var CstDoc = $("#CstDoc").val();   /// ��Ժҽʦ
	var CstUser = $("#CstUser").val();   /// ��ϵ��
	var CstTele = $("#CstTele").val();   /// ��ϵ�绰
	
	var ShareFlag = $HUI.checkbox("#ShareFlag").getValue()?"Y":"";  /// �Ƿ���
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ ConsTrePro +"^"+ ConsPurpose +"^"+ "" +"^"+ "" +"^"+ "";
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ ConsEmFlag +"^"+ ConsUnitFlag +"^"+ CstUnit +"^"+ CstDoc +"^"+ ConsNote +"^"+ CstUser +"^"+ CstTele +"^"+ ShareFlag;

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
	if (ConsDetList == ""){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�");
		return;	
	}
	
	///             ����Ϣ  +"&"+  �������
	var mListData = mListData +"&"+ ConsDetList;

	/// ����
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			CstID = jsonString;
			LoadReqFrame(CstID)
			$.messager.alert("��ʾ:","����ɹ���");
			/// ���ø���ܺ���
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// ���ػ�����������Ϣ����
function GetCstNoObj(CstID){
	
	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���û������뵥����
function InsCstNoObj(itemobj){
	
	$("#ConsTrePro").val(itemobj.CstTrePro);  		/// ��Ҫ����
	$("#ConsPurpose").val(itemobj.CstPurpose);  	/// ����Ŀ��
	$("#ConsNote").val(itemobj.CstRemark);  		/// ��ע
	$("#CstUnit").val(itemobj.CstUnit);             /// ��Ժ����
	$("#CstDoc").val(itemobj.CstDocName);   	    /// ��Ժҽʦ
	$("#CstUser").val(itemobj.CstUser);   		    /// ��ϵ��
	$("#CstTele").val(itemobj.CstPhone);   		    /// ��ϵ�绰
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// �������
	$("#CstRDoc").val(itemobj.CstUser);   		    /// ����ҽʦ
	$("#ConsOpinion").val(itemobj.CstOpinion);      /// ������� 
	/// ��������
	$HUI.radio("input[name='CstType'][value='"+ itemobj.CstEmFlag +"']").setValue(true);
	/// Ժ��Ժ��
	$HUI.radio("input[name='CstUnit'][value='"+ itemobj.CstOutFlag +"']").setValue(true);

	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// ��������
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// ����ʱ��
	
	$HUI.checkbox("#ShareFlag").setValue(itemobj.ShareFlag=="Y"?true:false); /// �Ƿ���
}

/// ����
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID,"LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			CstID = jsonString;
			$.messager.alert("��ʾ:","���ͳɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ȡ��
function CanCstNo(){
	
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonString){

		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȷ�ϲ�����");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȡ��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","ȡ���ɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ȷ��
function SureCstNo(){
	
	runClassMethod("web.DHCEMConsult","SureCstNo",{"ItmID":CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȷ�ϲ�����");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","ȷ�ϳɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ����
function AcceptCstNo(){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","���ܳɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// �ܾ�
function RefCstNo(){
	
	runClassMethod("web.DHCEMConsult","RefCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ����״̬����������оܾ�������");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","�ܾ��ɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ����
function AriCstNo(){
	
	runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬����������е��������");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵽��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","����ɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���
function CompCstNo(){
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("��ʾ:","����д���������");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","��ɳɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���ﵯ������  ����ҽ��¼��Ͳ����鿴
function OpenPupWin(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	var link = "dhcem.consultpupwin.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// ��ӡ
function PrintCst(){
	
	PrintCst_REQ(CstID);
}

/// ȡ���ҵ绰
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		if (jsonString != ""){
			TelPhone = jsonString;
		}
	},'',false)
	return TelPhone
}

/// ȡҽ���绰
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		if (jsonString != ""){
			TelPhone = jsonString;
		}
	},'',false)
	return TelPhone
}

/// �������뵥����
function LoadReqFrame(arCstID, arCstItmID){

	CstID = arCstID;
	CstItmID = arCstItmID;
	GetCstNoObj(arCstID);  	      /// ���ػ�������
	isShowPageButton(arCstID);    /// ��̬����ҳ����ʾ�İ�ť����
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// �������
}

/// ��̬����ҳ����ʾ�İ�ť����
function isShowPageButton(CstID){
	
	if(seeCstType){
		$("#OpBtns").hide();
		return;	
	}
	
	runClassMethod("web.DHCEMConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

		if (jsonString != ""){
			var BTFlag = jsonString;
			HidePageButton(BTFlag);
		}
	},'',false)
}

/// ���ذ�ť
function HidePageButton(BTFlag){

	if (BTFlag == 1){
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ord").hide();   /// ҽ��¼��
		
		$("#bt_save").show();  /// ����
		$("#bt_send").show();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#bt_sure").show();  /// ȷ��
	}
	if (BTFlag == 2){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		
		$("#bt_acc").show();   /// ����
		$("#bt_ref").show();   /// �ܾ�
		$("#bt_arr").show();   /// ����
		$("#bt_com").show();   /// ���
		$("#bt_ord").show();   /// ҽ��¼��
	}
	if (BTFlag == 3){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_com").hide();   /// ���
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
	}
}

/// �������뵥����:������һ������ʾ���ݣ����������ֻ���ṩ�鿴(window.openʱ�ɵ���)
function InitPatCstID(){
	CstID = getParam("arCstID");
	CstItmID = getParam("arCstItmID");
	if(CstID=="") return;       /// Ϊ�ղ������κζ���
	seeCstType=true;            /// �Ƿ�鿴ģʽ 
	GetCstNoObj(CstID);  	    /// ���ػ�������
	isShowPageButton(CstID);    /// ��̬����ҳ����ʾ�İ�ť����
}

function LoadDataGrid(){
	if(seeCstType){
		$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������	
	}
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })