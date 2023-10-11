//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-08-15
// ����:	   ��ʿ�������
//===========================================================================================

var CstID = "";         /// ��������ID
var editSelRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var CstOutFlag = "N";   /// Ժ�ʻ����־
var CsNoType = "";      /// ���ﵥ������ ҽ��/��ʿ/MDT
var LType = "CONSULTWARD";  /// ������Ҵ���
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID

var ItemTypeArr = [{"value":"N","text":'����'}, {"value":"Y","text":'����'}];
var del = String.fromCharCode(2);

/// ҳ���ʼ������
function initPageDefault(){

	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();

	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();
	
	/// ��ʼ��ҳ���������
	InitPageBaseSet();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
}

/// ��ʼ��ҳ��������� bianshuai 2019-09-18
function InitPageBaseSet(){

	/// ҽ�����
	if (LgGroupID == "68"){
		$("#audit").linkbutton('disable');   /// ���
		$("#reback").linkbutton('disable');  /// ����
	}
	
	/// ҽ�����/��ʿ��
	if (((LgGroupID != "68")&(CsNoType == ""))||((LgGroupID == "25")&(CsNoType == "Nur"))){
		$HUI.combobox("#CstRLoc").setValue(LgLocID);   /// �������� Ĭ�ϵ�¼���� bianshuai 2019-09-16
		$HUI.combobox("#CstRLoc").disable();
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	CsNoType = getParam("CsType");  /// ���ﵥ������
	if (CsNoType == "Nur"){
		LType = "CONSULTWARD";      /// ������Ҵ���
	}
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// ��������
	$('#CstNDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date(new Date()-24*60*60*1000);
			return date>now;
		}
	});
	
	/// ��������
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// ��������
	$HUI.combobox("#CstType",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// ���״̬
	$HUI.combobox("#AuditFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	$HUI.combobox("#AuditFlag").setValue("N");
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60,align:'center'},
		{field:'PatAge',title:'����',width:60,align:'center'},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatWard',title:'����',width:150},
		{field:'PatBed',title:'����',width:60,align:'center'}, 
		{field:'AuditFlag',title:'���״̬',width:80,align:'center'},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstType',title:'��������',width:100,align:'center'},
		{field:'CstRLoc',title:'��������',width:120},
		{field:'CstRUser',title:'�����ҽʦ',width:100,align:'center'},
		{field:'CstRTime',title:'����ʱ��',width:160,align:'center'},
		{field:'CstTrePro',title:'��Ҫ����',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:400,formatter:SetCellField},
		{field:'CstUnit',title:'����ҽԺ',width:100},
		{field:'CstLocArr',title:'�������',width:220},
		{field:'CstPrvArr',title:'����ҽʦ',width:220},
		{field:'AccpTime',title:'����ʱ��',width:160,align:'center'},
		{field:'CompTime',title:'���ʱ��',width:160,align:'center'},
		{field:'CstStatus',title:'����״̬',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "����"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'PrintFlag',title:'��ӡ',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:green;font-weight:bold;">�Ѵ�ӡ</font>'}
				else {return '<font style="color:red;font-weight:bold;">δ��ӡ</font>'}
			}
		},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'},
		{field:'CstID',title:'CstID',width:100}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			/*
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0) return;
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			var TmpCstID = rowData.CstID;
			var mergerows = 0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpCstID != rows[i].CstID){
				    MergeCells(i,mergerows);  /// �ϲ�ָ����Ԫ��
				    mergerows=0;
				    TmpCstID = rows[i].CstID;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				 MergeCells(i,mergerows);  /// �ϲ�ָ����Ԫ��
			}
			*/
			/// �޸�����
			if (CsNoType == "Nur"){
				$("#bmDetList").datagrid("setColumnTitle",{field:'CstRUser',text:'����ﻤʿ'});
				$("#bmDetList").datagrid("setColumnTitle",{field:'CstPrvArr',text:'���ﻤʿ'});
			}
			BindTips(); /// ����ʾ��Ϣ
		},
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
	        if (rowData.CstStatus == "�ϼ����"){
				return 'background-color:#00FFFF;';
			}
			if (rowData.AuditFlag == "����"){
				return 'background-color:pink;';
			}
		}
	};
	var RLocID = $HUI.combobox("#CstRLoc").getValue();   /// �������� 
	var param = "^^"+ RLocID +"^^^N^"+CsNoType +"^"+ LgGroupID +"^"+ LgUserID +"^"+ LgLocID +"^"+ "GRP";
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsGetConsAudit&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// �ϲ�ָ����Ԫ��
function MergeCells(i, mergerows){
	
	var Fields = ["PatNo","PatName","CstID","PatSex","PatAge","PatLoc","PatWard","PatBed","PatDiag","CstType","CstRLoc","CstRUser","CstRTime","CstTrePro","CstPurpose","CstUnit"];
	for (var m = 0; m < Fields.length; m++){
		$('#bmDetList').datagrid('mergeCells',{
	       index:(i - mergerows),
	       field:Fields[m],
	       rowspan:mergerows
	    });
	}
}

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		QryPatList();  /// ��ѯ
	}
}

/// ��ѯ
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var PatNo = $("#PatNo").val();    /// �ǼǺ�
	var RLocID = $HUI.combobox("#CstRLoc").getValue();     /// ��������
	if (typeof RLocID == "undefined") RLocID = "";
	var CstType = $HUI.combobox("#CstType").getValue();    /// ��������
	if (typeof CstType == "undefined") CstType = "";
	var AuditFlag = $HUI.combobox("#AuditFlag").getValue();/// ���״̬
	if (typeof AuditFlag == "undefined") AuditFlag = "";
	
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ PatNo +"^"+ CstType +"^"+ AuditFlag +"^"+ CsNoType +"^"+ LgGroupID +"^"+ LgUserID +"^"+ LgLocID +"^"+ "GRP";
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// ��дMDT����
function WriteMdt(EpisodeID, CstID){

	var Link = "dhcem.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID;
	OpenMdtConsWin();
	if (CsNoType == "Nur"){
		Link = "dhcem.consultnur.csp?EpisodeID="+EpisodeID +"&CstID="+CstID +"&CstItmID="+CstID;
	}
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		Link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",Link);
}

/// ��ӡ
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		PrintCst_AUD(rowsData.CstID);
		InsCsMasPrintFlag(rowsData.CstID);  /// �޸Ļ����ӡ��־
	}
}

function PrintCstHtml(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); 
	if(!rowsData){
		$.messager.alert("��ʾ","δѡ���ӡ���ݣ�");
		return;	
	}
	InsCsMasPrintFlag(rowsData.CstID);  /// �޸Ļ����ӡ��־

	$m({
		ClassName:"web.DHCEMConsultCom",
		MethodName:"GetCstItmIDs",
		CstID:rowsData.CstID
	},function(txtData){
		var Link="dhcem.printconsone.csp?CstID="+rowsData.CstID+"&CstItmID="+"";
		if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
			Link += "&MWToken="+websys_getMWToken();
		}
		if(txtData=="")	window.open(Link);
		if(txtData!=""){
			var CstItmArr = txtData.split("^");
			for(var i=0;i<CstItmArr.length;i++){
				var Link="dhcem.printconsone.csp?CstID="+rowsData.CstID+"&CstItmID="+CstItmArr[i];
				if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
					Link += "&MWToken="+websys_getMWToken();
				}
				window.open(Link);
			}
		}
	});
	
	return;
}

/// �ܾ�
function RefuseCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		if (rowsData.AuditFlag == "����"){
			$.messager.alert('��ʾ',"��ǰ�����¼�Ѿ���ˣ����ܲ���!","error");
			return;
		}
		if (rowsData.CstStatus == "����"){
			$.messager.alert('��ʾ',"��ǰ�����¼�Ѿ����أ������ٴβ���!","error");
			return;
		}
		$("#TmpCstID").val(rowsData.CstID); /// �ݴ沵�ػ���ID
	    $("#CstRefReason").val("");         /// ���ػ���ԭ��
		RefuseCstWin(); /// ��ʼ�������������
		//InsCsRefAudit(rowsData.CstID);
	}else{
		$.messager.alert("��ʾ:","����ѡ�д������У�","warning");
	}
}

/// �ܾ���������
function InsCsRefAuditNew(CstID){
	
	var CstNote = "������˲�ͨ��";
	/// ����
	runClassMethod("web.DHCEMConsult","InsCsRefAudit",{"CstID":CstID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ƿ���״̬�������������˲�����","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�����ɹ���","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}


/// �ܾ���������
function InsCsRefAudit(){
	
	var CstID = $("#TmpCstID").val();       /// ���ػ���ID
	var CstNote = $("#CstRefReason").val(); /// ���ػ���ԭ��
	CstNote = $_TrsSymbolToTxt(CstNote);    /// �����������
	/// ����
	runClassMethod("web.DHCEMConsult","InsCsRefAudit",{"CstID":CstID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ƿ���״̬����������в��ز�����","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�����ɹ���","info");
			$('#newRefOpWin').dialog('close');  /// �رղ��ش���
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(CstID){
	
	runClassMethod("web.DHCEMConsult","InsCsMasPrintFlag",{"CstID":CstID},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("��ʾ:","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// ��MDT��дҳ��
function OpenMdtConsWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('��������', 'MdtConsWin', '920', (window.screen.availHeight - 200), option).Init();
}

/// �½���˻��ﴰ��
function newConsult(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	if (rowData.AuditFlag == "����"){
		$.messager.alert('��ʾ',"��ǰ�����¼�Ѿ���ˣ������ٴ����!","error");
		return;
	}
	if (rowData.CstStatus == "����"){
		$.messager.alert('��ʾ',"��ǰ�����¼�Ѿ����أ��������!","error");
		return;
	}
	if (rowData.CstOutFlag == "Y"){
		CstOutFlag = "Y";   /// Ժ�ʻ����־
		isEditFlag = 1;     /// ҳ���Ƿ�ɱ༭
	}

	newCreateConsultWin();  /// �½���ѯ����
	InitConsItem(rowData);  /// ҳ��DataGrid��ʼ������ѡ�б�
	InitConsultDefault(rowData);  //��ʼ������Ĭ����Ϣ
}

/// �½���˻��ﴰ��
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:'ȡ��',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
				}
			}]
		};
	new DialogUX('���', 'newConWin', '910', '500', option).Init();

}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitConsItem(rowData){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ���ұ༭��
	var LocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID'],
			valueField: "value", 
			textField: "text",
			//editable:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			mode:'remote',
			enterNullValueClear:false,
			onSelect:function(option){
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
//				///���ü���ָ��
//				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
//				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);

				///���ü���ָ��
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){

				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocGrpID'});
				var LocGrpID = $(ed.target).val();
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'isGrpFlag'});
				var isGrpFlag = $(ed.target).val();
				if (isGrpFlag != 0){
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonConsGroupLoc&ID="+ LocGrpID;
				}else{
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				}
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
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
			//editable:false,
			enterNullValueClear:false,
			onSelect:function(option){
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// ��ϵ��ʽ
				var TelPhone = GetCareProvPhone(option.value);
				if (TelPhone != ""){
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val(TelPhone);
				}
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					/// ��ȡ��������
					var rowsData = $('#dgConsItem').datagrid('getRows');
					rowsData[editSelRow].PrvTp = ctpcpCtInfo.split("^")[1];
					$("tr[datagrid-row-index='"+ editSelRow +"'] td[field='PrvTp'] div").text(ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#dgConsItem").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType="+ CsNoType +"&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ rowData.CstRUserID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'LocGrpID',title:'LocGrpID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocGrp',title:'ר��С��',width:140,align:'center',hidden:true},
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:120,align:'center'},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,hidden:true},
		{field:'LocDesc',title:'����',width:300,editor:LocEditor},   //handong  2019-9-18 ��� editor:texteditor 
		{field:'UserID',title:'��ʿID',width:100,editor:texteditor,hidden:true},
		{field:'UserName',title:'��ʿ',width:200,editor:DocEditor},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor},
	    {field:'isGrpFlag',title:'isGrpFlag',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'operation',title:"����",width:110,align:'center',formatter:SetCellUrl}
	]];
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+rowData.CstID;
	//����datagrid
	$('#dgConsItem').datagrid({
		showHeader:true,
		url:uniturl,
		border:false,
		columns:columns,
		remoteSort:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {
		    
			if (isEditFlag == 1) return;
			
			var CstType = $("#CsType").text(); 	          /// ��������
			if ((CstType.indexOf("����") != "-1")&(rowIndex != 0))return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgConsItem").datagrid('endEdit', editSelRow); 
            } 
            $("#dgConsItem").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
            
            /// ��ϵ��ʽ
			var ed=$("#dgConsItem").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
        }
	});
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// ɾ����
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	var rows = $('#dgConsItem').datagrid('getRows');
	if(rows.length>6){
		 $('#dgConsItem').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgConsItem').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#dgDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
	var rowObj={LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgConsItem").datagrid('appendRow',rowObj);
}

/// ��ʼ������Ĭ����Ϣ
function InitConsultDefault(rowObj){

	$("#CstID").val(rowObj.CstID); 		    /// ����ID
	$("#CsRLoc").text(rowObj.CstRLoc); 		/// �������
	$("#CsRUser").text(rowObj.CstRUser); 	/// ������
	$("#CsRDate").text(rowObj.CstRTime); 	/// ����ʱ��
	$("#CsType").text(rowObj.CstType); 	    /// �������
	$("#CsUnit").text(rowObj.CstUnit); 		/// Ժ��Ժ��
	$("#ConsNPlace").val(rowObj.CstNPlace); /// ����ص�
	$HUI.datebox("#CstNDate").setValue(rowObj.CstNDate);      /// ��������
	$HUI.timespinner("#CstNTime").setValue(rowObj.CstNTime);  /// ����ʱ��
}

 /**
  * �����������
  */
function saveConsultDetail(){
	
	/// �����б༭״̬
	if ((editSelRow != -1)||(editSelRow == "0")) { 
        $("#dgConsItem").datagrid('endEdit', editSelRow); 
    }
    
    /// ����ID
	var CstID=$('#CstID').val();
	
    /// ����ص�
	var consNPlace=$('#ConsNPlace').val();
	if (consNPlace.replace(/\^/g,'') == ""){
		$('#ConsNPlace').val("");
		$.messager.alert("��ʾ:","����ص㲻��Ϊ�գ�","warning");
		return;
	}
	consNPlace = consNPlace.replace(/\^/g,'');
	
	/// ����ʱ��
	var CstDate = $HUI.datebox("#CstNDate").getValue();      /// ��������
	var CstTime = $HUI.timespinner("#CstNTime").getValue();  /// ����ʱ��
	if ((CstDate == "")||(CstTime == "")){
		$.messager.alert("��ʾ:","����ʱ�䲻��Ϊ�գ�","warning");
		return;
	}
	///var tmpCstCTime = new Date((CstDate +" "+ CstTime).replace(/\-/g, "\/"));
	///var tmpCstRDate = new Date($("#CsRDate").text().replace(/\-/g, "\/"));
	var tmpCstCTime = CstDate +" "+ CstTime;
	var tmpCstRDate = $("#CsRDate").text();
 	if (isCompare(tmpCstCTime , tmpCstRDate) == 1){
		$.messager.alert("��ʾ:","����ʱ�䲻������������ʱ�䣡","warning");
		return;
	}
	
	/// �������
	var ConsDetArr=[];
	var isEmptyFlag = 0;
	var rowData = $('#dgConsItem').datagrid('getRows');
	$.each(rowData, function(index, item){
		if((trim(item.LocDesc) != "")||(trim(item.LocGrpID) != "")){
			//if (item.UserID == "") isEmptyFlag = 1;
			if (item.LocID == "") isEmptyFlag = 1;
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+ item.LocGrpID +"^"+ item.itmID +"^"+ item.LocGrpID;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if ((GetCsLevCode(CstID) == 1)&(isEmptyFlag == 1)&(CsNoType == "Nur")){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�","warning");
		return;	
	}
	if ((isEmptyFlag == 1)&(CsNoType == "Doc")){
		$.messager.alert("��ʾ:","����ҽ������Ϊ�գ�","warning");
		return;	
	}
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetArr.join("") == "")&(CstOutFlag =="N")){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�","warning");
		return;	
	}
	
	var CstType = $("#CsType").text();   /// ��������
	if ((ConsDetArr.length == 1)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ��ƻ������ѡ���������������Ͽ��ң�","warning");
		return;	
	}
	
	///             ����Ϣ  +"&"+  �������
	var mListData = consNPlace +"^"+ CstDate +"^"+ CstTime +"^"+ LgLocID +"^"+ LgUserID +del+ ConsDetList;

	/// ����
	runClassMethod("web.DHCEMConsult","InsConsAudit",{"CstID":CstID, "UserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID, "PageType":"GRP", "mListData":mListData},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ƿ���״̬�������������˲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����������ݱ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$('#newConWin').dialog('close');
			$.messager.alert("��ʾ:","��˳ɹ���","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
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

		if (jsonString != ""){
			TelPhone = jsonString;
		}
	},'',false)
	return TelPhone
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// �����Ŀ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// �½������������
function RefuseCstWin(){
	
	var option = {
			iconCls:'icon-paper',
			buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					InsCsRefAudit();
					}
			},{
				text:'ȡ��',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newRefOpWin').dialog('close');
				}
			}]
		};
	new DialogUX('�����������', 'newRefOpWin', '600', '300', option).Init();
}

/// ���ڴ�С�ж�
function isCompare(FristTime, SecondTime){
	
	var isCompareFlag = 0;
	runClassMethod("web.DHCEMConsultCom","isCompare",{"FristTime":FristTime, "SecondTime":SecondTime},function(jsonString){

		if (jsonString != null){
			isCompareFlag = jsonString;			
		}
	},'',false)
	return isCompareFlag;
}

/// ������˼���
function GetCsLevCode(CstID){
	
	var LevCode = "";
	runClassMethod("web.DHCEMConsult","GetCsLevCode",{"CstID":CstID, "LgUserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID},function(jsonString){

		//if (jsonString != ""){
			LevCode = jsonString;
		//}
	},'',false)
	return LevCode
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })