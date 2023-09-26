//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-10
// ����:	      mdt���ﰲ��
//===========================================================================================
var EpisodeID = "";     /// ���˾���ID
var CstID = "";         /// ����ID
var DisGrpID = "";      /// ���Ѳ���ID
var mdtID = "";         /// ��������ID
var mdtMakResID = "";   /// ԤԼ��ԴID
var editSelRow = -1;
var editGrpRow = -1;
var LType = "CONSULT";  /// ������Ҵ���
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ��ҳ�����
	InitPatEpisodeID();
	
	/// ��ʼ��ר�����б�
	InitbmDetList();
	
	InitLocGrpGrid();
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	DisGrpID = getParam("DisGrpID");    /// ���Ѳ���ID
	EpisodeID = getParam("EpisodeID");  /// ����ID
	mdtID = getParam("ID");             /// ���ﵥ������
	mdtMakResID = getParam("mdtMakResID");  /// ԤԼ��ԴID
	if (mdtID != ""){
		var Link = "dhcmdt.makeresources.csp?ID="+ mdtID +"&mdtMakResID="+mdtMakResID +"&DisGrpID="+ DisGrpID +"&EpisodeID="+ EpisodeID;
		$("#mdtFrame").attr("src",Link);
	}
}

// ��ӿ���
function AddLocWin(){
    
   if (TakGrpLocModel == 1){
	   	/// �������
		if (isEditFlag == 1) return;
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
   }else{
	   var Link = "dhcmdt.makresloc.csp?DisGrpID="+DisGrpID;
	   mdtPopWin1(2, Link); /// ����MDT���ﴦ����
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
	}else{
		/// Ժ�ڿ���
		$("#bmDetList").datagrid("reload",{"QueFlg":'','ID':''});
		
	}
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
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
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ DisGrpID;
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
            $("#LocGrpList").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#LocGrpList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editGrpRow = rowIndex;      
        }
	};
	/// ��������
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=I";
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
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
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc&DisGrpID="+DisGrpID;
				}else{
					
					var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonSubMar&LocID="+ LocID;
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID;
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
            
            $("#bmDetList").datagrid('beginEdit', rowIndex); 
			
            editSelRow = rowIndex;
        }
	};
	/// ��������
	
	//var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&mdtID=&Type=O";
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+mdtID+"&Type=O";
	
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

	//if (!frames[0].GetPatMakRes()) return;
	if (!document.getElementById('mdtFrame').contentWindow.GetPatMakRes()) return;
	InsMdtCsMakRes(); /// �޸Ļ�����Դ
}

/// �رյ�������
function TakClsWin(){

	window.parent.$("#mdtWin").window("close");        /// �رյ�������
	window.parent.$("#bmDetList").datagrid("reload");
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
	
	if ((memControlFlag == 1)&(LocArr.length < 3)){
		$.messager.alert("��ʾ:","����ר�����Ա����������3�ˣ�","warning");
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
	
	/// ��Դ��Ϣ
	var makResParams = mdtPreData +"^"+ mdtPreTime +"^"+ mdtMakResID;

	/// ����
	runClassMethod("web.DHCMDTConsult","InsMakRes",{"CstID":mdtID, "LgParams":LgParam, "makResParams":makResParams, "makLocParams":makLocParams},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������а��Ų�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			//$.messager.alert("��ʾ:","����ɹ���","warning");
			//$('#bmDetList').datagrid('reload');
			TakClsWin(); /// �رյ�������
		}
	},'',false)
}



/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })