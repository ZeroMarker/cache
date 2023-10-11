//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-10
// ����:	   mdt�������
//===========================================================================================
var EpisodeID = "";     /// ���˾���ID
var CstID = "";         /// ����ID
var DisGrpID = "";      /// ���Ѳ���ID
var mdtID = "";         /// ��������ID
var mdtMakResID = "";   /// ԤԼ��ԴID
var editSelRow = -1;
var editGrpRow = -1;
var editExpRow = -1;
var LType = "CONSULT";  /// ������Ҵ���
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var del = String.fromCharCode(2);
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ��ҳ�����
	InitPatEpisodeID();
	
	/// ��ʼ��ר�����б�
	InitbmDetList();
	
	/// �����б�
	InitLocGrpGrid();
	
	/// ��ʼ��ҳ��datagrid
	InitOuterExpGrid();
	
//	/// ����ص�
//	InitCsAddrDiv();

	/// ��ʼ������ؼ�����
	InitPageComponent();
	
	/// �������
	InitCsFeeDiv();
	
	/// ��������tabs
	InitReqMatTabs();
	
	InitPage();
	
	LoadMoreScr();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	DisGrpID = getParam("DisGrpID");    /// ���Ѳ���ID
	EpisodeID = getParam("EpisodeID");  /// ����ID
	mdtID = getParam("ID");             /// ���ﵥ������
	mdtMakResID = getParam("mdtMakResID");  /// ԤԼ��ԴID
	IsConsCentPlan = getParam("IsConsCentPlan");  /// �������İ���
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:mdtID,
		LgParams:LgParams,
		dataType:"text"
	}, false);
	
	var RetDataArr=RetData.split("^");
	///������
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
	DisGrpID=RetDataArr[3];
	
	if (mdtID != ""){
		var Link = "dhcmdt.makeresources.csp?ID="+ mdtID +"&mdtMakResID="+mdtMakResID +"&DisGrpID="+ DisGrpID +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
		$("#mdtFrame").attr("src",Link);
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// ���õص�
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf("����") != "-1"){
		    	$("#tempAddr").attr("disabled", false);
		    }else{
		    	$("#tempAddr").val("").attr("disabled", true); 
			}
			GetItemOcc(option.text); /// ����ص�ռ�����
	    },
		onShowPanel:function(){

			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsGetDicItem&mCode=LocAddr&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
			$("#itemAddr").combobox('reload',unitUrl);
		}
	};
	var url = ""; 
	new ListCombobox("itemAddr",url,'',option).init();
	
	/*
	/// ԤԼʱ��
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){

	    },
		onShowPanel:function(){
			
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsGetDicItem&mCode=AppPeriod&HospID="+LgHospID;
			$("#itemPeriod").combobox('reload',unitUrl);
		}
	};
	var url = ""; 
	new ListCombobox("itemPeriod",url,'',option).init();
	*/

}

/// ��������tabs
function InitReqMatTabs(){
	
	$('#tag_id').tabs({ 
		onSelect:function(title){
			switch (title){
				case "MDT����":
					if ($("#tab_req").attr("src") == "") $("#tab_req").attr('src',$("#tab_req").attr("data-src"));
					break;
				case "���Ӳ���":
					if ($("#tab_emr").attr("src") == "") $("#tab_emr").attr('src',$("#tab_emr").attr("data-src"));
					break;
				case "����ģ��":
					if ($("#tab_model").attr("src") == "") $("#tab_model").attr('src',$("#tab_model").attr("data-src"));
					break;
				case "�ϴ��ļ�":
					if ($("#tab_file").attr("src") == "") $("#tab_file").attr('src',$("#tab_file").attr("data-src"));
					break;	
				default:
					return;
			}
		}
	}); 
}

// ��ӿ���
function AddLocWin(){
    
   if (TakGrpLocModel == 1){
	   	/// �������
		if (isEditFlag == 1) return;
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
   }else{
	   var Link = "dhcmdt.makresloc.csp?DisGrpID="+DisGrpID +"&Type=G"+"&MWToken="+websys_getMWToken();
	   commonShowWin({
		  url: Link,
		  title: '����ר����',
		  width: 880,
		  height: 520,
		  isParentOpen:true,
		  domName:'CommonWinArrange'
	   })
	   //mdtPopWin1(2, Link); /// ����MDT���ﴦ����
   }
}

/// ����MDT���ﴦ����
function mdtPopWin1(WidthFlag, Link){
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	$("#mdtFrames").attr("src",Link);
	if(WidthFlag == 2){
		new WindowUX('����ר����', 'mdtWin', 880, 420, option).Init();
	}
}

/// ���
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// ���ڿ���
		$("#LocGrpList").datagrid("reload",{"QueFlg":'','ID':''});
	}
	if (FlagCode == "I"){
		/// Ժ�ڿ���
		$("#bmDetList").datagrid("reload",{GrpID:''});
	}
	if (FlagCode == "O"){
		/// ��Ժר��
		$("#OuterExpList").datagrid("load",{GrpID:''}); 
	}
}

/// ��Ժר�ҿ�ݷ�ʽ
function shortcut_selOuterExp(){
	
	if (DisGrpID == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	var Link = "dhcmdt.makresloc.csp?DisGrpID="+ DisGrpID +"&Type=E"+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: Link,
		title: "��Ժר�ҿ��ѡ��",
		width: 900,
		height: 500,
		isParentOpen:true,
		domName:'CommonWinArrange'
	})
}

/// ����
function SetLocCellUrls(value, rowData, rowIndex){	
	var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';    
	return html;
}
/// ��ʼ���������б�
function InitLocGrpGrid(){

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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("��ʾ","����ȷ��ר�ҿ��ң�","warning");
					return;
				}
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///���ü���ָ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:true,
			onSelect:function(option) {
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				/// ��ϵ��ʽ
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				///���ҽ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ���ְ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
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
			mode:'remote',
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// ��ϵ��ʽ
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#LocGrpList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'center',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'center',editor:DocEditor},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'center',hidden:false,editor:PrvTpEditor},
		{field:'operation',title:"����",width:70,align:'center',formatter:SetLocCellUrls}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
	    onDblClickRow: function (rowIndex, rowData) {
		  	
		  	if (isEditFlag == 1) return;
			
			if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#bmDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            $("#LocGrpList").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#LocGrpList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editGrpRow = rowIndex;      
        }
	};
	/// ��������
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=I"+"&MWToken="+websys_getMWToken();
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitbmDetList(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	var HosTypeArr = [{"value":"I","text":'����'}, {"value":"O","text":'Ժ��'}];
	//������Ϊ�ɱ༭
	var HosEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				
				///��տ���
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val("");
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
			}
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
                
                var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
                
				///���ü���ָ��
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				
				//var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				/// ����
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = "";
				if (HosID == "I"){
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID+"&MWToken="+websys_getMWToken();
				}else{
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
				}
				
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
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// ȡ������רҵָ��
			},
			onShowPanel:function(){
				
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonSubMar&LocID="+ LocID+"&MWToken="+websys_getMWToken();
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
			mode:'remote',
			onSelect:function(option){
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				///���ü���ָ��
				//var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
			    /// ����
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				//var GrpID = HosID="I"?DisGrpID:"";
				var GrpID="";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#bmDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
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
		{field:'operation',title:"����",width:70,align:'center',formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
	    onDblClickRow: function (rowIndex, rowData) {
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#bmDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            $("#bmDetList").datagrid('beginEdit', rowIndex); 
			
            editSelRow = rowIndex;
        }
	};
	/// ��������
	
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&mdtID=&Type=O"+"&MWToken="+websys_getMWToken();
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=O"+"&MWToken="+websys_getMWToken();
	
	new ListComponent('bmDetList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "bmDetList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	return html;
}

 /// ɾ����
function delRow(rowIndex, id){
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	var rows = $('#'+ id).datagrid('getRows');
	if(rows.length>2){
		 $('#'+ id).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+ id).datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	
	GetMarIndDiv("", ""); 	/// ȡ������רҵָ��
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;

    var rowObj={PrvTpID:'', PrvTp:'', HosID:'O', HosType:'Ժ��', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	 $("#bmDetList").datagrid('appendRow',rowObj);
}

/// ��ʼ����Ժר���б�
function InitOuterExpGrid(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// �༭��
	var numbereditor={
		type: 'numberbox',//���ñ༭��ʽ
		options: {
			//required: true //���ñ༭��������
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	/// ����
	var LocEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTDicItem&MethodName=jsonParDicItem&mCode=OutLoc&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///��������ֵ
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#OuterExpList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	///  ����columns
	var hideFlags=""
	if(CstID!=""){
		hideFlags="true"
	}
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'center',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'center',editor:texteditor},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'center',editor:numbereditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'center',hidden:false,editor:PrvTpEditor},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetExpCellUrl,hidden:hideFlags}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
	    onClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#bmDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            if (rowData.UserID != "") return;
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;    
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=E"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}
/// ����
function SetExpCellUrl(value, rowData, rowIndex){	
	var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	return html;
}

/// �������
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
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

/// ԤԼʱ��
function TakPreTime(){
	
	if((IsContact!="Y")&&(NOCENTPLANPAT==2)){
		$.messager.alert("��ʾ:","�ǻ���������,�ް���Ȩ��!","warning");
		return;		
	}
	
	if (!document.getElementById('mdtFrame').contentWindow.GetPatMakRes()) return;
	InsMdtCsMakRes(); /// �޸Ļ�����Դ
}

/// �رյ�������
function TakClsWin(){
	///����������
	if(typeof parent.TakClsWin ==="function"){
		parent.TakClsWin();  
		return;
	}
	///�򿪴˽���ʹ��websys_showModal
	websys_showModal("close")
}

/// �޸Ļ�����Դ
function InsMdtCsMakRes(){

    /// ȫԺ�����б� �����༭
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#bmDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// ���ڿ����б� �����༭
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }
     
    /// ��Ժר���б� �����༭
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }

	var mdtPreData = $("#mdtPreDate").val();       /// ԤԼ����
	var mdtPreTime = $("#mdtPreTime").val();       /// ԤԼʱ��
	var mdtMakResID = $("#mdtMakResID").val();     /// �����ID
	   
	/// �������
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var LocArr = [];
	/// ����
	var rowData = $('#LocGrpList').datagrid('getRows');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	
	/// Ժ��
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#bmDetList").datagrid('endEdit', editSelRow); 
    }
	var rowData = $('#bmDetList').datagrid('getRows');
	for (var n = 0; n < rowData.length; n++){
		var item = rowData[n];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	
	if ((LocArr.length-AtLeastNumber) < 0){
		$.messager.alert("��ʾ:","����ר�����Ա����������"+AtLeastNumber+"�ˣ�","warning");
		return;	
	}
	
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	/// ����
	var makLocParams = ConsDetArr.join("@");
	if (makLocParams == ""){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�","warning");
		return;	
	}
	
	/// ��Ժר��
	var repExpArr = [];
	var LocExpArr = [];
	var OuterExpList = "";
	var rowData = $('#OuterExpList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone;
			LocExpArr.push(TmpData);
		    if ($.inArray(item.UserID, repExpArr) == -1){
				repExpArr.push(item.UserID);
			}else{
				TmpCarePrv = item.UserName;
			}
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	var makOuterExp = LocExpArr.join("@");
	
	// ����ص�
	//var LocAddr = $("input[name='LocAddr']:checked").attr("value");
	var LocAddr = $HUI.combobox("#itemAddr").getText();
	if ($("#tempAddr").val() != ""){
		LocAddr = $("#tempAddr").val();
	}
	
	/// �������
	var arcimid = $("input[name='itemCharge']:checked").attr("value");
	
	/// ��Դ��Ϣ
	var makResParams = mdtPreData +"^"+ mdtPreTime +"^"+ mdtMakResID +"^"+ LocAddr;
	
	/// ����
	runClassMethod("web.DHCMDTConsult","InsMakRes",{"CstID":mdtID, "LgParams":LgParams, "makResParams":makResParams, "makLocParams":makLocParams, "makOuterExp":makOuterExp},function(jsonString){
		if(jsonString==0){
			$.messager.alert("��ʾ:","���ųɹ�!","info",function(){
				TakClsWin(); /// �رյ�������	
			});
			ParentTableLoad();
		}else{
			$.messager.alert("��ʾ:","ʧ��,��Ϣ:"+jsonString,"warning");
			return;
		}
	},'',false)
}


/// �˺�
function RetMakRes(){
	
	var IsValid=GetIsTakOperFlagNew(mdtID,"25");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','�˺Ż��ͷŴ˺ű�ԤԼ��Դ������ֹͣ����ҽ������ȷ��Ҫ���д˲�����', function(r){
		if (r){
			/// ����
			runClassMethod("web.DHCMDTConsult","CancelArrange",{"CstID":mdtID, "LgParams":LgParams},function(jsonString){
				
				if ( jsonString == 0){
					$.messager.alert("��ʾ:","ȡ�����ųɹ���","info",function(){
						TakClsWin(); 	
					});
					ParentTableLoad();
				}else{
					$.messager.alert("��ʾ:","ʧ��,��Ϣ:"+jsonString,"error");	
				}
			},'',false)
		}
	});
}

function ParentTableLoad(){
	if(window.parent){
		if(window.parent.parent){
			if(typeof window.parent.parent.qryConsList==="function"){
				///����ִ�н��浯��
				window.parent.parent.qryConsList();
			}
		}	
	}
	return;
}

/// ����ص�
function InitCsAddrDiv(){
	
	runClassMethod("web.DHCMDTCom","JsGetDicItem",{"mCode":"LocAddr", "HospID":LgHospID},function(jsonObject){
		if (jsonObject != null){
			InsCsAddrTable(jsonObject);
		}
	},'json',true)
}

/// ����ص�
function InsCsAddrTable(itmArr){
	
	if (itmArr.length == 0){
		$.messager.alert("��ʾ:","����ص�Ϊ�գ����ڻ���������ά����","warning");
		return;
	}
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=0; j<itmArr.length; j++){
		itemhtmlArr.push('<td style=""><input id="'+ itmArr[j].value +'" class="hisui-radio" type="radio" label="'+ itmArr[j].text +'" value="'+ itmArr[j].text +'" name="LocAddr"/></td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
    $("#itemAddr").html(itemhtmlstr);
    $HUI.radio("#itemAddr input.hisui-radio",{});
}

/// �������
function InitCsFeeDiv(){
	
	runClassMethod("web.DHCMDTCom","JsGetFeeDicItem",{"DisGrpID":DisGrpID, "HospID":LgHospID},function(jsonObject){
		if (jsonObject != null){
			InsCsFeeTable(jsonObject);
		}
	},'json',true)
}

/// �������
function InsCsFeeTable(itmArr){
	
	if (itmArr.length == 0){
		//$.messager.alert("��ʾ:","�������Ϊ�գ����ڻ���������ά����","warning");
		return;
	}
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=0; j<itmArr.length; j++){
		itemhtmlArr.push('<td style=""><input id="'+ itmArr[j].value +'" class="hisui-radio" type="radio" label="'+ itmArr[j].text +'" value="'+ itmArr[j].value +'" name="itemCharge"/></td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
    $("#itemCharge").html(itemhtmlstr);
    $HUI.radio("#itemCharge input.hisui-radio",{});
}

/// ����
function refuseREQ(){
	
//    var rowData = $('#bmDetList').datagrid('getSelected');
//    if (rowData == null){
//		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
//		return;
//	  }
	
	var IsValid=GetIsTakOperFlagNew(mdtID,"5");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	var linkUrl ="dhcmdt.refusereq.csp?ID="+ mdtID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: linkUrl,
		title: $g("����"),
		width: 550,
		height: 340
	})	
}

/// �Ƿ��������
function GetIsTakOperFlag(CstID, stCodes){

	var IsModFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTConsult","GetIsTakOperFlag",{"CstID":CstID, "stCodes":stCodes},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// ȡ����ص�ռ�����
function GetItemOcc(itemAddr){
	
	if (!document.getElementById('mdtFrame').contentWindow.GetPatMakRes()) return;
	var mdtPreData = $("#mdtPreDate").val();       /// ԤԼ����
	var mdtPreTime = $("#mdtPreTime").val();       /// ԤԼʱ��
	
	runClassMethod("web.DHCMDTConsult","GetItemOcc",{"mdtPreData":mdtPreData, "mdtPreTime":mdtPreTime, "itemAddr":itemAddr },function(jsonString){

		if (jsonString != ""){
			//  ռ�����
			$("#itemPeriod").val(jsonString);
		}
	},'',false)
}

function InitPage(){

	var IsValid=GetIsTakOperFlagNew(mdtID,"30");
	if (IsValid==0){
		$(".canPlanArea").hide();
		$(".planArea").show();
	}else{
		$(".planArea").hide();	
	}
	
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

function updRes(){
	parent.updRes(mdtID,mdtMakResID,DisGrpID,EpisodeID)
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
