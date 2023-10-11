//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var PatType="";		    /// ��������
var CstID = "";         /// ��������ID
var CstItmID = "";      /// ���������ֱ�ID
var editSelRow = -1;
var editGrpRow = -1;
var editExpRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LType = "CONSULT";  /// ������Ҵ���
var CsRType = "DOC";    /// ��������  ҽ��
var CstOutFlag = "";    /// Ժ�ʻ����־
var CstMorFlag ="";     /// ��ƻ����־
var TakOrdMsg = "";     /// ��֤�����Ƿ�����ҽ��
var TakCstMsg = "";     /// ��֤ҽ���Ƿ��п�����Ȩ��
var isOpiEditFlag = 0;  /// ��������ǿɱ༭
var IsPerAccFlag = 0;   /// �Ƿ�����������뵥
var CsStatCode = "";    /// ���뵥��ǰ״̬
var seeCstType="";      /// �鿴ģʽ
var CarPrvID = "";      /// ��Դ�ű�
var RBResID=""			/// ��Դ��ID
var AppSclID = "";      /// ��Դ�ֱ�ID
var LODOP="";
var isValFlag = "Y";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
var PageWidth=""
/// ҳ���ʼ������
function initPageDefault(){
	getWidth()
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitAutoLine();
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitLocGrpGrid();	      /// ��ʼ��ҳ��datagrid
	InitOuterExpGrid();	      /// ��ʼ��ҳ��datagrid
	HidePageButton(5);	      /// ��ʼ�����水ť
	multi_Language();         /// ������֧��
	InitMoreScreen(); ///����Ļ����
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
}

function InitAutoLine(){
	var conLayWidth=$("#contentLayout").width();
	if(parseInt(conLayWidth)<850){
		$(".autoNewLine").show();	
	}else{
		$(".autoNewLine").hide();	
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm");           /// �������ID
	CstID = getParam("ID");              /// ����ID
	seeCstType = getParam("seeCstType"); /// ����鿴ģʽ
	isValFlag = getParam("isValFlag");   /// �Ƿ���֤
	LODOP = "" //getLodop();
	if(seeCstType==1) return;
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if ((EpisodeID != "")&(CstID == "")&(isValFlag == "N")){
		InitPatNotTakOrdMsg(1);    /// ��֤�����Ƿ�����ҽ��
		//InitPatHasMdtCons();
	}
}

function replaceMdtPurpose(){
	var mdtPurpose = $("#mdtPurpose").val();
	mdtPurpose = mdtPurpose.replace("1","���");
	mdtPurpose = mdtPurpose.replace("2","����");
	mdtPurpose = mdtPurpose.replace("3","����");
	$("#mdtPurpose").val(mdtPurpose);
	return;
}

function InitPatHasMdtCons(){
	runClassMethod("web.DHCMDTCom","TipHasMdtCons",{"EpisodeID":EpisodeID},function(ret){
		if (ret != ""){
			$.messager.alert("��ʾ","<div style='line-height:18px;letter-spacing:1px;margin:3px;'>"+ ret +"</div>","warning");
		}
	},'text',false)
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// ���Ѳ���
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        ClrDisGrpRel();  /// ��ղ������������
			GetCareProvByGrp(option.value); /// �������Ѳ���ȡ�����ű�
			/// �����Ƿ��������
			if (isTakOrder(option.value) != 1){
				$.messager.alert("��ʾ","�ò���δ�����շ�����ܿ�������������!","warning");
				$HUI.combobox("#mdtDisGrp").setValue(""); 
			}

	    },
	    onShowPanel: function () { //���ݼ�������¼�
			///���ü���ָ��
			//var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup";
			var unitUrl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroup&LgParams="+LgParam+"&MWToken="+websys_getMWToken();
			
			$("#mdtDisGrp").combobox('reload',unitUrl);
        }
	};
	
	var url = "";
	new ListCombobox("mdtDisGrp",url,'',option).init();
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPre);
	
	$('#contentLayout').layout('panel', 'center').panel({
		onResize: function () {InitAutoLine()},
	});
}

/// ��ղ������������
function ClrDisGrpRel(){
	
	$("#mdtPreDate").val("");  /// ԤԼ����
	$("#mdtPreTime").val("");  /// ԤԼʱ��
	$("#mdtPreTimeRange").val("");  /// ����ʱ��
	$("#mdtMakResID").val("");  /// ��ԴID
	$("#LocGrpList").datagrid("load",{total:0,rows:[]});               /// �������
	$("#dgCstDetList").datagrid("reload"); /// Ժ�ڿ���
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 $("#PatName").val(jsonObject.PatName); /// ����
			 $("#PatSex").val(jsonObject.PatSex);   /// �Ա�
			 $("#PatAge").val(jsonObject.PatAge);   /// ����
			 $("#PatNo").val(jsonObject.PatNo);     /// �ǼǺ�   
			 $("#PatBed").val(jsonObject.PatBed);   /// ����
			 $("#PatBill").val(jsonObject.PatBill); /// �ѱ�
			 $("#PatDiagDesc").val(formatHtmlToValue(jsonObject.PatDiagDescAll)); /// ���
			 PatType = jsonObject.PatType;
		}
	},'json',false)
}

/// ȡ��¼��Ϣ
function LoadPageWriEl(){

	runClassMethod("web.DHCMDTConsultQuery","TakCsPatInfo",{"EpisodeID":EpisodeID, "LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#mdtRLoc').val(jsonObject.LocDesc);  /// �������
			$('#mdtRUser').val(jsonObject.LgUser);  /// ����ҽʦ
			$('#mdtAddr').val(jsonObject.LocAddr);  /// ���ҵ�ַ
			$('#mdtTimes').val(jsonObject.mdtTimes);  /// �������
		}
	},'json',false)
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
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
				
				/// ���ְ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val("");
				
				///���ҽ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				///��տ���
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
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
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("��ʾ","����ȷ��ר�ҿ��ң�","warning");
					return;
				}
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				///���ҽ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ���ְ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// ���Ѳ���
				/// ����
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
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
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
			    var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// ���Ѳ���
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'HosID'});
				var HosID = $(ed.target).val();
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var GrpID = HosID=="I"?DisGrpID:"";
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+ GrpID+"&MWToken="+websys_getMWToken();
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val();
				}
			}
		}
	}
	
	var hideFlag=""
	if(CstID!=""){
		hideFlag="true"
		}
	///  ����columns
	var columns=[[
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110,editor:HosEditor,align:'left',hidden:true},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'left'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'left',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'left',styler: slUserName},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,editor:texteditor,align:'left'},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'left',hidden:false},
		{field:'operation',title:"����",width:100,align:'left',formatter:SetCellUrl,hidden:hideFlag}  
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
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=O"+"&MWToken="+websys_getMWToken();
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}

	
	//var html = '<a href="#" class="hisui-linkbutton" data-options="iconCls:\''+a+'\',plain:true" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')">���</a>'

	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "dgCstDetList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
	return html;
}

/// ɾ����
function delRow(rowIndex, id){
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ","����ѡ���У�");
		return;
	}
	
	var rows = $('#'+ id).datagrid('getRows');
	if(rows.length>2){
		 $('#'+ id).datagrid('deleteRow',rowIndex);
		 var rows=$('#'+ id).datagrid('getRows');
		 $('#'+ id).datagrid('loadData',rows);
	}else{
		$('#'+ id).datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'O', HosType:'Ժ��', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// ����mdt����
function mdtSave(){

	if (PatientID == ""){
		$.messager.alert("��ʾ","��¼�뻼����Ϣ�����ԣ�","warning");
		return;
	}
	
	var InHosEpisID = GetPatInHosEpisID(); /// �����Ƿ�����סԺID
	if ((InHosEpisID != "")&(PatType != "I")&(HasCenter == 0)){
		$.messager.confirm('ȷ�϶Ի���','���ߵ�ǰ����סԺ���Ƿ񽫷��ü���סԺ������?(���ȷ�ϰ�ť��סԺ�շѣ����ȡ����ť�������շ�)', function(r){
			if (r){
				mSave(InHosEpisID);
			}else{
				mSave(EpisodeID);
			}
		});
	}else{
		mSave(EpisodeID);
	}
}

/// ����mdt����
function mSave(TmpEpisodeID){
    
    /// ȫԺ�����б� �����༭
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// ���ڿ����б� �����༭
    if ((editGrpRow != -1)||(editGrpRow == 0)) { 
        $("#LocGrpList").datagrid('endEdit', editGrpRow); 
    }
    
    /// ��Ժר���б� �����༭
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
    }
    
    /// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
	
	/// ��֤ҽ���Ƿ��п�����Ȩ��
	if (TakCstMsg != ""){
		$.messager.alert("��ʾ",TakCstMsg,"warning");
		return;	
	}
	
    var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	var mdtTrePro = $("#mdtTrePro").val();     /// ��Ҫ����
	if (mdtTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����ժҪ����Ϊ�գ�","warning");
		return;
	}
	mdtTrePro = $_TrsSymbolToTxt(mdtTrePro);        /// �����������
	
	var mdtPurpose = $("#mdtPurpose").val();  	    /// ����Ŀ��
	if (mdtPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����Ŀ�Ĳ���Ϊ�գ�","warning");
		return;
	}
	
	mdtPurpose = $_TrsSymbolToTxt(mdtPurpose);      /// �����������
	if (RBResID == ""){
		$.messager.alert("��ʾ","���ֺű���Ϊ�գ�","warning");
		return;	
	}

	//var mdtTime = $("#mdtPreTime").val();  /// ����ʱ��
	var AppSclID = $("#mdtMakResID").val();  /// �����ID
	if((HasCenter == 0)&(AppSclID == "")){
		$.messager.alert("��ʾ","ԤԼ��Ϣ����Ϊ�գ�","warning");
		return;	
	}
	var mdtPreData = $("#mdtPreDate").val(); /// ԤԼ����
	var mdtPreTime = $("#mdtPreTime").val(); /// ԤԼʱ��
	var mdtUser = $("#mdtUser").val();   /// ��ϵ��
	var mdtTele = $("#mdtTele").val();   /// ��ϵ�绰
	var mdtNote = "";  				     /// ��ע
	var mdtAddr = $("#mdtAddr").val();   /// ����ص�
	var mdtTimes = $("#mdtTimes").val(); /// �ڼ��λ���
	
	/// �������
	var LocArr = [];
	var ConsDetArr=[];
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#LocGrpList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	})
	
	
	var IsNeedValidLocNumber=(SendNoNeedLoc!=1)||(HasCenter=="0")
	
	if ((LocArr.length-AtLeastNumber)<0){
		if(IsNeedValidLocNumber){
			$.messager.alert("��ʾ","����ר�����Ա����������"+AtLeastNumber+"�ˣ�","warning");
			return;	
		}
	}
	
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID;
		    ConsDetArr.push(TmpData);
		    if ($.inArray(item.LocID +"^"+ item.UserID,LocArr) == -1){
				LocArr.push(item.LocID +"^"+ item.UserID);
			}
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	})
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var ConsDetList = ConsDetArr.join("@");
	if (ConsDetList == ""){
		///���谲�Ż������ñ����л���ר��
		if(IsNeedValidLocNumber){
			$.messager.alert("��ʾ","������Ҳ���Ϊ�գ�","warning");
			return;	
		}
	}
	
	/// ��Ժר��
	var repExpArr = [];
	var LocExpArr = [];
	var OuterExpList = "";
	var rowData = $('#OuterExpList').datagrid('getRows');
	
	if(!$("#OuterExpList").datagrid('validateRow', editExpRow)){
		$.messager.alert("��ʾ","��Ժר����ά���������ݡ�ҽ����!","warning");
		return;	
	}
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
	OuterExpList = LocExpArr.join("@");
	
	var mListData = TmpEpisodeID +"^"+ LgUserID +"^"+ LgLocID +"^"+ mdtTrePro +"^"+ mdtPurpose +"^"+ mdtAddr;  //1-6
		mListData += "^"+ mdtPreData +"^"+ mdtPreTime +"^"+ mdtUser +"^"+ mdtTele +"^"+ mdtDisGrp +"^"+ RBResID; //7-12
		mListData += "^"+ AppSclID +"^"+ mdtTimes +"^"+ PatientID;

	///             ����Ϣ  +"&"+  �������  +$c(2)+  ��Ժר��
	var mListData = mListData +del+ ConsDetList +del+ OuterExpList;

	/// ����
	runClassMethod("web.DHCMDTConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			$(".tip").text("(�ѱ���)");
			$.messager.alert("��ʾ","����ɹ���","info",function(){
				$.messager.confirm("��ʾ","�Ƿ������뵥?",function(e){
					if(e){
						mdtSend();
					}
				});
			});
		}
	},'',false)
}

/// �����鿴
function LoadPatientRecord(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link = "emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&MWToken="+websys_getMWToken();
	$("#newWinFrame").attr("src",link);
}


/// ���ػ�����������Ϣ����
function GetCstNoObj(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtObj",{"ID":CstID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���û������뵥����
function InsCstNoObj(itemobj){ 
          
    $("#PatName").val(itemobj.PatName)
    $("#PatSex").val(itemobj.PatSex)
    $("#PatAge").val(itemobj.PatAge)
    $("#PatNo").val(itemobj.PatNo)
    $("#PatBed").val(itemobj.PatBed)
    $("#PatBill").val(itemobj.PatBill)
    $("#PatDiagDesc").val(itemobj.PatDiagDesc)
	$("#mdtTrePro").val($_TrsTxtToSymbol(itemobj.mdtTrePro));  		/// ��Ҫ����
	$("#mdtPurpose").val($_TrsTxtToSymbol(itemobj.mdtPurpose));  	/// ����Ŀ�� 
	$("#mdtUser").val(itemobj.CstUser);   		    /// ��ϵ��
	$("#mdtTele").val(itemobj.CstPhone);   		    /// ��ϵ�绰
	$("#mdtRLoc").val(itemobj.CstRLoc);   		    /// �������
	$("#mdtRUser").val(itemobj.CstRUser);   		/// ����ҽʦ
	$("#mdtAddr").val(itemobj.CstNPlace);           /// ����ص�
	var TreMeasures = "";
	if ((itemobj.TreMeasures != "")&(typeof itemobj.TreMeasures != "undefined")){
		TreMeasures = itemobj.TreMeasures.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#mdtOpinion").val($_TrsTxtToSymbol(TreMeasures));       /// �������
	$HUI.combobox("#mdtDisGrp").setValue(itemobj.DisGrpID);    /// ���Ѳ���
	$HUI.combobox("#mdtDisGrp").setText(itemobj.DisGroup);     /// ���Ѳ���
	$("#mdtCarPrv").val(itemobj.PrvDesc);                      /// ��Դ�ű�
	$("#mdtPreDate").val(itemobj.PreDate);
	$("#mdtPreTimeRange").val(itemobj.PreTimeRange);
	$("#mdtTimes").val(itemobj.MCTimes);
	//$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);   /// ����ʱ��
	
	
	EpisodeID = itemobj.EpisodeID;			/// ����ID
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// ��������ǿɱ༭
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// �Ƿ�����������뵥
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	PatType = itemobj.PatType;              /// ��������
	RBResID = itemobj.RBResID;              /// ��������
	if (CsStatCode == ""){
		$(".tip").text("(�ѱ���)");
	}else{
		$(".tip").text("");
	}
}

/// ����mdt����
function mdtSend(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","���ȱ������뵥��","warning");
		return;
	}
	
	/// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
	/// ��֤ҽ���Ƿ��п�����Ȩ��
	if (TakCstMsg != ""){
		$.messager.alert("��ʾ",TakCstMsg,"warning");
		return;	
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged() == 1){
		$.messager.alert("��ʾ","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뱣�����������ٷ��ͣ�","warning");
		return;
	}
	
	/// ����MDT����ʱ������ָ��ʱ���ʱ������ҽ��
	if ((HasCenter == 1)&(isPermitTakMdt() == 1)){
		//$.messager.alert("��ʾ","<div style='line-height:18px;letter-spacing:1px;margin:3px;'>MDT����16:00���޷�����ԤԼ���������֪����ԤԼʱ��Ϊ�����գ�8:30-11:30��13:30-16:00�ѿ��ߵĻ���������������������Чδ�ڹ涨ʱ���ڰ���ԤԼ����,�������뽫�Զ����ϣ�<div>", "warning");
		if (sendTipMsg != ""){
			$.messager.alert("��ʾ",sendTipMsg, "warning");
			//return;
		}
	}
	
	runClassMethod("web.DHCMDTConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam,"IpAddress":""},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�ѷ��ͣ������ٴη��ͣ�","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-12){
				$.messager.alert("��ʾ","�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��","warning");		
			}
			$.messager.alert("��ʾ","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			isShowPageButton();     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ","���ͳɹ���","info");
			if (window.parent.reLoadMainPanel != undefined){
				window.parent.reLoadMainPanel(CstID);
			}
			/// ���ͳɹ��������������Ҫ�Զ���Ȩ���Ӳ����鿴
			if(DefOpenAcc == 1){
				InsEmrAutMasAll();
			}
			$(".tip").text("");
			InvAutoPrint();  /// ���ͺ�����Զ���ӡ����
		}
	},'',false)
}

function InsEmrAutMasAll(){
	
	var params = EpisodeID+"^"+CstID+"^"+LgUserID+"^72^1";
	
	runClassMethod("web.DHCMDTConsult","InsEmrAutMasAll",{"Params":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�Զ�����������Ȩ72Сʱ�鿴Ȩ�ޣ�","warning");
			return;
		}
		
		if (jsonString == -2){
			$.messager.alert("��ʾ:","������Ȩʧ�ܣ�ʧ��ԭ��:��ǰ���˴˴ξ���û�в��������ʵ��������Ȩ���ֶ���Ȩ��","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�Զ�������Ȩʧ�ܣ�������Ȩ���ֶ���Ȩ��ʧ��ԭ��:"+jsonString,"warning");
			return;
		}
		
	},'',false)	
}

/// ȡ��
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","����ѡ��������룬�ٽ��д˲�����","warning");
		return;
	}
	
	/// ��֤�����Ƿ�����ҽ��
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg.replace("�ٿ�����","ȡ��"),"warning");
		return;	
	}
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫȡ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){
				if (jsonString < 0){
					if(jsonString==-2) {
						$.messager.alert("��ʾ","�Ѿ�ȡ�Ų�������");
					}else if(jsonString==-1){
						$.messager.alert("��ʾ","��ǰ״̬�Ƿ���״̬��������");
					}else{
						$.messager.alert("��ʾ","��������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
					}
				}else{
					$.messager.alert("��ʾ","ȡ���ɹ���","info");
					window.parent.reLoadMainPanel(CstItmID);
				}
			},'text',false)
		}
	});
	
}

/// �ܾ�
function RefCstNo(){
	
	runClassMethod("web.DHCEMConsult","RefCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ����״̬����������оܾ�������","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","�ܾ��ɹ���","info");
			GetCstNoObj();  	         /// ���ػ�������
			isShowPageButton();          /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// �������
function InsCstOpinion(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("��ʾ","���ǵ�ǰ������Ա�����ܽ��д˲�����","warning");
		return;
	}
	
	var mdtOpinion = $("#mdtOpinion").val();
	if (mdtOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����д���������","warning");
		return;
	}
	mdtOpinion = $_TrsSymbolToTxt(mdtOpinion); /// �����������
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":mdtOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�޸�ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ","�޸ĳɹ���","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���
function CompCstNo(){
	
	if ((GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
		return;
	}
	
	var AntiOpinion = $("input[name='AntiRadio']:checked").val(); ///�Ƿ�ͬ��ʹ�ÿ�����ҩ�� 
	if((AntiOpinion=="")||(AntiOpinion==undefined)){
		$.messager.alert("��ʾ","�����ػ��������д�Ƿ�ͬ����ҩ!");
		return false;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����д���������","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","CompCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion,"AntiOpinion":AntiOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","����ʱ�䲻����������ʱ�䣡","warning");
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","��ɳɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton();           /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// �������
function RevCompCstNo(){
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬��������ȡ����ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ�����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ���ɹ���","info");
      		GetCstNoObj();  	    /// ���ػ�������
			isShowPageButton();     /// ��̬����ҳ����ʾ�İ�ť����
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
	var link = "dhcem.consultpupwin.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// ��ӡ֪��ͬ����
function PrintZQTYS(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	PrintConsent(CstID);
	return;
}

/// ��ӡ���ԤԼ��
function PrintZJYYD(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	
	PrintMakeDoc(CstID);
	return;
}

/// �Ƿ��������
function GetIsOperFlag(stCode){
	
	var IsModFlag = "";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = CstID; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","GetIsOperFlag",{"CstID":ItmID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// ȡ���ҵ绰
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCMDTConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// ȡҽ���绰
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCMDTConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}
	},'',false)
}

/// �������뵥����
function LoadReqFrame(){

	GetCstNoObj();  	        /// ���ػ�������
	//GetConsMarIndDiv();	        /// ȡ���������רҵָ��
	isShowPageButton();         /// ��̬����ҳ����ʾ�İ�ť����
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(0); /// ��֤�����Ƿ���������
	}
	$("#dgCstDetList").datagrid("load",{"ID":CstID});    /// �������
	$("#LocGrpList").datagrid("load",{"ID":CstID});      /// �������
	$("#OuterExpList").datagrid("load",{"ID":CstID});    /// ��Ժר��
	if(seeCstType){ 
		$('#contentLayout').layout('hidden','north');
	}
}

/// ������Ȩ
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("��ʾ","�뱣�������ٿ�����Ȩ��","warning");
		return;
	}
	
	var TakEmrAutMsg = isPopEmrAut();
	/// ��֤�����Ƿ����������Ȩ
	if (TakEmrAutMsg != ""){
		$.messager.alert("��ʾ",TakEmrAutMsg,"warning");
		return;	
	}
	
	var Link ="dhcmdt.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url: Link,
		iconCls:"icon-w-paper",
		title: '��Ȩ',
		closed: true,
		onClose:function(){}
	});
}

/// ��֤�����Ƿ����������Ȩ
function isPopEmrAut(){
	
	var TakMsg = "";
	runClassMethod("web.DHCEMConsInterface","isPopEmrAut",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			TakMsg = jsonString;
		}
	},'',false)
	return TakMsg
}

/// ȡ���ﲡ����Ȩ����
function GetConsAutUrl(){
	
	var LinkUrl = "";
	runClassMethod("web.DHCEMConsultQuery","GetConsAutUrl",{"CstID":CstID},function(jsonString){

		if (jsonString != ""){
			LinkUrl = jsonString;
		}
	},'',false)
	return LinkUrl
}

/// �ر���Ȩ
function ClsAuthorize(){
	
	runClassMethod("EPRservice.browser.BOConsultation","FinishConsultation",{"AConsultID":CstID},function(jsonString){

		if (jsonString != ""){
			$.messager.alert("��ʾ",jsonString,"warning");
		}
	},'',false)
}

/// �½�������Ȩ����
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX('������Ȩ', 'newConWin', '1000', '600', option).Init();

}

/// ��������
function EmType_KeyPress(event,value){

	if (value){
		/// Ժ��Ժ��
		$HUI.radio("input[name='CstUnit'][value='Y']").setValue(false);
		$HUI.radio("input[name='CstUnit'][value='N']").setValue(false);
	}
}

/// Ժ��Ժ��
function EmUnit_KeyPress(event,value){

	if (value){
		/// ��������
		$HUI.radio("input[name='CstType'][value='Y']").setValue(false);
		$HUI.radio("input[name='CstType'][value='N']").setValue(false);
	}
}

/// ����
function OpenEmr(flag){

	var Link = "dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&MWToken="+websys_getMWToken();
	
	
//	if (!isIE()){
	window.parent.commonShowWin({
		url: Link,
		title: "����",
		width: $(window.parent).width()-100,
		height: $(window.parent).height()-50
	})
//	}else{
//		var result = window.showModalDialog(Link,"_blank",'dialogWidth:1480px;DialogHeight=660px;center=1'); 
//		if (result){
//			if ($("#mdtTrePro").val() == ""){
//				$("#mdtTrePro").val(result.innertTexts);  		/// ��Ҫ����
//			}else{
//				$("#mdtTrePro").val($("#mdtTrePro").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
//			}
//		}
//	}
}

/// ������������
function InsQuote(resQuote, flag){
	
	if ($("#mdtTrePro").val() == ""){
		$("#mdtTrePro").val(resQuote);   /// ��Ҫ����
	}else{
		$("#mdtTrePro").val($("#mdtTrePro").val()  +"\r\n"+ resQuote);   /// ��Ҫ����
	}
}

/// ��̬����ҳ����ʾ�İ�ť����
function isShowPageButton(){

	runClassMethod("web.DHCMDTConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

		if (jsonString != ""){
			var BTFlag = jsonString;
			HidePageButton(BTFlag);
		}
	},'',false)
}

/// ���ذ�ť
function HidePageButton(BTFlag){

	/// �����  ����δ����
	if (BTFlag == 1){

		$("#bt_save").show();  /// ����
		$("#bt_send").show();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#bt_read").hide();  /// ����
		$("#QueEmr").show();    /// ����
		$("#TakTemp").show();   /// ѡ��ģ��
		$("#SaveTemp").show();  /// ����ģ��
		$("#bt_grpaddloc").show(); /// ���ڿ������
		$("#bt_grpcencel").show(); /// ���ڿ������
		$("#bt_addloc").show();    /// Ժ�ڿ������
		$("#bt_cencel").show();    /// Ժ�ڿ������
		$("#bt_openemr").show();   /// ������Ȩ
		$("#bt_expaddloc").show();    /// Ժ��������
		$("#bt_expcancel").show();    /// Ժ��������
		$("#bt_select").show();       /// Ժ�����ѡ��
		PageEditFlag(1);	    /// ҳ��༭
		isEditFlag = 0;	        /// �б༭��־
	}
	/// �����  �����ѷ���
	if (BTFlag == 2){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_read").hide();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#QueEmr").hide();   /// ����
		$("#TakTemp").hide();  /// ѡ��ģ��
		$("#SaveTemp").hide(); /// ����ģ��
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_grpaddloc").hide(); /// ���ڿ������
		$("#bt_grpcencel").hide(); /// ���ڿ������
		$("#bt_addloc").hide();    /// Ժ�ڿ������
		$("#bt_cencel").hide();    /// Ժ�ڿ������
		if (HasCenter == 0) {
			//$("#bt_print").show();   /// ֪��ͬ����
			//$("#bt_printM").show();  /// ���ԤԼ��
		}
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_openemr").show();   /// ������Ȩ
		$("#bt_expaddloc").hide();    /// Ժ��������
		$("#bt_expcancel").hide();    /// Ժ��������
		$("#bt_select").hide();       /// Ժ�����ѡ��
		PageEditFlag(2);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}

	/// ������ʾ
	if (BTFlag == 3){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_read").hide();  /// ����
		$("#QueEmr").hide();   /// ����
		$("#TakTemp").hide();  /// ѡ��ģ��
		$("#SaveTemp").hide(); /// ����ģ��
		$("#bt_grpaddloc").hide(); /// ���ڿ������
		$("#bt_grpcencel").hide(); /// ���ڿ������
		$("#bt_addloc").hide();    /// Ժ�ڿ������
		$("#bt_cencel").hide();    /// Ժ�ڿ������
		if (HasCenter == 0) {
			//$("#bt_print").hide();   /// ֪��ͬ����
			//$("#bt_printM").hide();  /// ���ԤԼ��
		}
		$("#bt_openemr").hide();     /// ������Ȩ
		$("#bt_expaddloc").hide();   /// Ժ��������
		$("#bt_expcancel").hide();   /// Ժ��������
		$("#bt_select").hide();      /// Ժ�����ѡ��
		PageEditFlag(3);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ��������ʾ
	if (BTFlag == 4){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_read").hide();  /// ����
		$("#QueEmr").hide();   /// ����
		$("#TakTemp").hide();  /// ѡ��ģ��
		$("#SaveTemp").hide(); /// ����ģ��
		$("#bt_grpaddloc").hide(); /// ���ڿ������
		$("#bt_grpcencel").hide(); /// ���ڿ������
		$("#bt_addloc").hide();    /// Ժ�ڿ������
		$("#bt_cencel").hide();    /// Ժ�ڿ������
		if (HasCenter == 0) {
			//$("#bt_print").hide();   /// ֪��ͬ����
			//$("#bt_printM").hide();  /// ���ԤԼ��
		}
		$("#bt_openemr").hide();     /// ������Ȩ
		$("#bt_expaddloc").hide();   /// Ժ��������
		$("#bt_expcancel").hide();   /// Ժ��������
		$("#bt_select").hide();      /// Ժ�����ѡ��
		PageEditFlag(4);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ҳ��Ĭ����ʾ
	if (BTFlag == 5){
		$("#bt_can").hide();   /// ȡ��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
	}
	
	//$("#Opinion").show();

	/// �����ӱ�IDΪ��ʱ������ʾ������־��ť
	if (CstItmID == ""){
		$("#bt_log").hide();   /// ������־
	}
	
	if (CsStatCode == "����"){
		//$("#bt_print").hide();   /// ֪��ͬ����
		//$("#bt_printM").hide();  /// ���ԤԼ��
	}
}

/// ���������רҵָ��
function InsMarIndDiv(MarID, LocID){
	
	runClassMethod("web.DHCEMConsLocItem","JsonSubMarInd",{"MarID":MarID, "LocID":LocID},function(jsonObject){

		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
		}
	},'json',false)
}

/// ������רҵָ��
function InsMarIndTable(itmArr){
	
	var itemhtmlArr = [];
	for (var j=1; j<=itmArr.length; j++){
		if($('input[name="MarInd"][value="'+ itmArr[j-1].value +'"]').length == 0){
			itemhtmlArr.push('<tr><td style="width:20px;"><input value="'+ itmArr[j-1].value +'" name="MarInd" type="checkbox" class="checkbox"></input></td><td>'+ itmArr[j-1].text +'</td></tr>');
		}
	}
    $("#itemList").append(itemhtmlArr.join(""));
}


/// ȡ���������רҵָ��
function GetConsMarIndDiv(){
	
	$("#itemList").html("");
	runClassMethod("web.DHCEMConsultQuery","GetJsonSubMarInd",{"CstID":CstID},function(jsonObject){
		if (jsonObject != ""){
			InsMarIndTable(jsonObject);
			$('input[name="MarInd"]').attr("checked",true).attr("disabled","disabled");
		}
	},'json',false)

	/// ����ָ��
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
	}
}

/// ������Ϣ
function PatBaseWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	if (GetEmrAutFlag() == ""){
		$.messager.alert("��ʾ","����Ȩ�޲鿴�ò��˲������ݣ�","warning");
		return;
	}
	
	var lnk ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'+"&MWToken="+websys_getMWToken();
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���λ���
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	window.open("dhcmdt.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&MWToken="+websys_getMWToken(), 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���ý���༭״̬
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// ��Ҫ����
		$("#ConsPurpose").prop("readonly",false); /// ����Ŀ��
		$("#CstUser").attr("disabled", false);    /// ��ϵ��
		$("#CstTele").attr("disabled", false);    /// ��ϵ�绰
		$("#mdtTimes").attr("disabled", false);   /// �ڼ��λ���
		$HUI.combobox("#mdtDisGrp").disable(); 	  /// ���Ѳ���
		$("#app").linkbutton('enable');           /// ԤԼ��ť
	}else{
		$("#ConsTrePro").prop("readonly",true);
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// ��ϵ��
		$("#CstTele").attr("disabled", true);		/// ��ϵ�绰
		$("#mdtTimes").attr("disabled", true);      /// �ڼ��λ���
		$HUI.combobox("#mdtDisGrp").disable(); 	    /// ���Ѳ���
		$("#app").linkbutton('disable');            /// ԤԼ��ť
	    //$("#app").attr("disabled", true).css({"pointer-events":"none","background-color":"gray"});   /// ԤԼ��ť
	}
	
	if ((Flag == 3)||(Flag == 4)){
		$("#OpBtns").hide();
		//$(".p-content").css({"top":25});
	}
	if (Flag != 3){
		$("#ConsOpinion").prop("readonly",true);   /// �������
	}else{
		$("#ConsOpinion").prop("readonly",false);  /// �������
	}
}

/// ��֤�����Ƿ�����ҽ��
function InitPatNotTakOrdMsg(TipFlag){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCMDTCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// ��ӡ
function Print(){
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+CstID+"&MWToken="+websys_getMWToken());
	}else{
	    PrintCons(CstID);  /// ��ӡ�������뵥	
	}
	return;
}


/// ��ӡ��֪��
function printInfoSing(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	
	var MdtDisGrp=$HUI.combobox("#mdtDisGrp").getValue();
	PrintCst_REQ(CstID,MdtDisGrp);  /// ��ӡ�������뵥
	InsCsMasPrintFlag(CstID,"Z"); ///�޸������ӡ�ֶ� 
	return;
}

/// ��ӡ֮��ͬ����
function PrintInfoCons(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	PrintConsent(CstID);
	return;
}

/// ��ӡ֮��ͬ����
function PrintConfApp(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	
	PrintMakeDoc(CstID);
	return;
}

/// ��֤�����Ƿ���������
function InitPatNotTakCst(TipFlag){
	
	TakCstMsg = GetPatNotTakCst();
	if ((TakCstMsg != "")&(TipFlag == 1)){
		$.messager.alert("��ʾ",TakCstMsg,"warning");
		return;	
	}
}

/// ȡ��ǰ��½�˿ɲ����Ļ�������
function GetPatNotTakCst(){
	
	var NotTakCstMsg = "";
	runClassMethod("web.DHCEMConsultCom","JsonCstType",{"HospID":LgHospID, "LgUserID":LgUserID},function(jsonObject){

		if (jsonObject != null){
			if (jsonObject.length == 0){
				NotTakCstMsg = "��ǰ��½��δ����������ͣ�����ϵ�����Ŵ���";
			};
		}
	},'json',false)

	return NotTakCstMsg;
}

/// ��ȡ���˵���ϼ�¼��
function GetMRDiagnoseCount(){

	var Count = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// ��ȡҽ�ƽ����־
function GetIsMidDischarged(){

	var MidDischargedFlag = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}

/// ��ѯ�����Ƿ�����סԺ
function GetPatInHosEpisID(){

	var InHospEpisID = "";
	runClassMethod("web.DHCMDTCom","PatInIPAdmID",{"PatientID":PatientID},function(jsonString){
		
		if (jsonString != ""){
			InHospEpisID = jsonString;
		}
	},'',false)

	return InHospEpisID;
}

/// ��ȡ�鿴����Ȩ��
function GetEmrAutFlag(){

	var EmrAutFlag = "";
	runClassMethod("web.DHCEMConsult","GetEmrAutID",{"itmID":CstItmID},function(jsonString){
		
		EmrAutFlag = jsonString;
	},'',false)

	return EmrAutFlag;
}

/// ������ϴ���
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	//window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ����ҽ��¼�봰��
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url:lnk,
		title:'ҽ��¼��',
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// �������Ѳ���ȡ�����ű�
function GetCareProvByGrp(mID){

	runClassMethod("web.DHCMDTCareProv","GetCareProvByGrp",{"mID":mID},function(jsonObject){
		
		if (jsonObject != null){
			CarPrvID = jsonObject.PrvID;
			RBResID = jsonObject.RBResID;
			$('#mdtCarPrv').val(jsonObject.PrvDesc);  /// ��Դ�ű�
			$("#mdtAddr").val(jsonObject.Address);
		}
	},'json',false)
}

/// ��ʾ�Ű洰��
function RsPrvWin(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	if (HasCenter == 1){
		parent.$.messager.alert("��ʾ","����ԤԼʱ�������Ѳ��������İ���ʱ��Ϊ����","warning",function(){
			var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
			mdtPopWin(1, Link); /// ����MDT���ﴦ����
		});
	}else{
		var Link = "dhcmdt.makeresources.csp?DisGrpID="+mdtDisGrp +"&EpisodeID="+ EpisodeID+"&MWToken="+websys_getMWToken();
		mdtPopWin(1, Link); /// ����MDT���ﴦ����
	}
}

/// ����MDT���ﴦ����
function mdtPopWin(WidthFlag, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	$("#mdtFrame").attr("src",Link);
	if (WidthFlag == 1){
		$("#mdtFrame").height(380);
		$("#mdtWinTools").show();
		new WindowUX('�Ű���Դ', 'mdtWin', 880, 460, option).Init();
	}else if (WidthFlag == 2){
		$("#mdtFrame").height(480);
		$("#mdtWinTools").hide();
		new WindowUX('����ר����<span style="color:red">������ר���Ⱥ�ƴ������</span>', 'mdtWin', 880, 520, option).Init();
	}else{
		$("#mdtWinTools").hide();
		$("#mdtFrame").height(380);
		new WindowUX('����Ŀ��ģ��', 'mdtWin', 880, 420, option).Init();
	}
}

/// ԤԼʱ��
function TakPreTime(){
	
	if (!frames[1].GetPatMakRes()) return;

	TakClsWin(); /// �رյ�������
}

/// �رյ�������
function TakClsWin(){

	$("#mdtWin").window("close");        /// �رյ�������
}

/// ����MDT����ʱ������ָ��ʱ���ʱ������ҽ��
function isPermitTakMdt(){

	var isPerTakMdtFlag = "";
	runClassMethod("web.DHCMDTConsultQuery","isPermitTakMdt",{"mParams":""},function(jsonString){
		
		isPerTakMdtFlag = jsonString;
	},'',false)

	return isPerTakMdtFlag;
}

/// ѡ��ģ��
function TakTemp(){
    var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
    
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	var Link = "dhcmdt.template.csp?DisGrpID="+mdtDisGrp+"&MWToken="+websys_getMWToken();
	mdtPopWin(0, Link); /// ����MDT���ﴦ����
}

/// ����ģ��
function SaveTemp(){
	
	var mdtPurpose = $("#mdtPurpose").val();   /// ����Ŀ��
	if (mdtPurpose.replace(/\s/g,'') == ""){
		$.messager.alert('��ʾ','����Ŀ�Ĳ���Ϊ�գ�','warning');
		return;
	}
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	var mdtCode = mdtPurpose.substring(0, 6);
	var mListData= "" +"^"+ mdtCode +"^"+ mdtPurpose +"^M^"+mdtDisGrp +"^"+LgHospID;
	//��������
	runClassMethod("web.DHCMDTOpiTemp","save",{"mParam":mListData},function(jsonString){

		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ���','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
	})
}

/// ��ӿ���
function AddLocWin(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	if (TakGrpLocModel == 1){
		/// �������
		if (isEditFlag == 1) return;
    	var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
		$("#LocGrpList").datagrid('appendRow',rowObj);
	}else{
		var Link = "dhcmdt.makresloc.csp?DisGrpID="+ mdtDisGrp +"&Type=G"+"&MWToken="+websys_getMWToken();
		//mdtPopWin(2, Link); /// ����MDT���ﴦ����
		window.parent.commonShowWin({
			url: Link,
			title: '����ר����',
			width: 880,
			height: 520
		})
	}
}

/// ���
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// ���ڿ���
		$("#LocGrpList").datagrid("reload",{GrpID:''});
	}
	if (FlagCode == "I"){
		/// Ժ�ڿ���
		$("#dgCstDetList").datagrid("reload",{GrpID:''});
	}
	if (FlagCode == "O"){
		/// ��Ժר��
		$("#OuterExpList").datagrid("load",{GrpID:''}); 
	}
}

/// ����
function SetLocCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}
	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "LocGrpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	    //html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcnewpro/images/edit_add.png' border=0/></a>";
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
				var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// ���Ѳ���
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
			    
			    var DisGrpID = $HUI.combobox("#mdtDisGrp").getValue(); /// ���Ѳ���
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
	var hideFlags=""
	if(CstID!=""){
		hideFlags="true"
	}
	var columns=[[
		{field:'LocID',title:'����ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'left',editor:DocEditor,styler: slUserName},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'left',editor:texteditor},
		{field:'PrvTpID',title:'ְ��ID',width:20,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:100,align:'left',hidden:false,editor:PrvTpEditor},
		{field:'operation',title:"����",width:100,align:'left',formatter:SetLocCellUrl,hidden:hideFlags}
	]];
	
	///  ����datagrid
	var option = {
		border:true, //hxy 2023-02-07 st
		bodyCls:'panel-header-gray', //ed
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
                                    
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
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
		var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=I"+"&MWToken="+websys_getMWToken();

//	$('#LocGrpList').datagrid({
//		url:uniturl,
//		option:option,
//		columns:columns
//		})
	
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=I"+"&MWToken="+websys_getMWToken();
	new ListComponent('LocGrpList', columns, uniturl, option).Init();
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
	/// �༭�����
	var validEditor={
		type:'validatebox',
		options:{
			required:true
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
		{field:'LocID',title:'����ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'left',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'left',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'left',editor:validEditor,styler: slUserName,formatter:userNameFormat},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'left',editor:numbereditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'left',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'left',hidden:false,editor:PrvTpEditor},
		{field:'AssUser',title:'����Ժ���û�',width:100,align:'center',hidden:!hideFlags},
		{field:'operation',title:"����",width:100,align:'left',formatter:SetExpCellUrl,hidden:hideFlags}
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
	    onClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
			if ((editGrpRow != -1)||(editGrpRow == 0)) { 
                $("#LocGrpList").datagrid('endEdit', editGrpRow); 
            }
            
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            
            if ((editExpRow != -1)||(editExpRow == 0)) { 
            	if($("#OuterExpList").datagrid('validateRow', editExpRow)){
	            	$("#OuterExpList").datagrid('endEdit', editExpRow); 	
	            }else{
		        	return;    
		        }
            }
            
            if (rowData.UserID != "") return;
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;    
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&CstID=&Type=E"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}
/// ����
function SetExpCellUrl(value, rowData, rowIndex){	

	if(HISUIStyleCode==="lite"){ // 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"></a>';
	    //html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    //html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}

	//var html = '<a href="#" onclick="delRow(\''+ rowIndex +'\',\''+ "OuterExpList" +'\')"><img src="../scripts/dhcnewpro/images/cancel.png" border=0/></a>';
	return html;
}

/// �������
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
}

function mdtUpload(){
	if (CstID == ""){
		$.messager.alert("��ʾ:","�뷢�ͻ�����������ϴ���","warning");
		return;
	}
	var lnk = "dhcmdt.uploadify.csp?MdtCstID="+CstID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: lnk,
		title: '�ϴ��鿴�ļ�',
		width:PageWidth,height:screen.availHeight-150,
	});
}

/// ���ͺ�����Զ���ӡ����
function InvAutoPrint(){
	
	if (HasCenter == 1) return;
	if ((PatType != "I")&(LocAppPriFlag == 1)){
		PrintZJYYD();  /// ��ӡ���ԤԼ��
	}
	if (TakArgPriFlag == 1){
		PrintZQTYS();  /// ��ӡ֪��ͬ����
	}
}
/// ����
function readCard(){
	
	Inv_ReadCardCom(GetPatLastEpi);  /// ������������
}

/// �ǼǺ�
function PatNo_KeyPre(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		var PatNo = $("#PatNo").val();
		GetPatLastEpi({"PatNo": PatNo});  /// ȡ������Ϣ
	}
}

/// ȡ�������һ�ξ�����Ϣ
function GetPatLastEpi(PatObj){
	
	if ((PatObj.PatNo == "")||(typeof PatObj.PatNo == "undefined")) return;
	runClassMethod("web.DHCMDTConsultQuery","GetPatLastEpi",{"PatNo": PatObj.PatNo},function(jsonObject){
		
		if (!$.isEmptyObject(jsonObject)){
			PatientID = jsonObject.PatientID;   /// ����ID
			EpisodeID = jsonObject.EpisodeID;   /// ����ID
			mradm = jsonObject.mradm;           /// �������ID
//			LoadPageWriEl();  /// ȡ��¼��Ϣ
//			GetPatEssInfo();  /// ȡ������Ϣ
			var frm = dhcsys_getmenuform();
			if (frm) {
				frm.PatientID.value = PatientID;
				frm.EpisodeID.value = EpisodeID;
				frm.mradm.value = mradm;
			}
			parent.Flag="Y";
			parent.initFrameSrc();   /// ˢ�¿����Դ
			parent.getPatBaseInfo(); /// ���˾�����Ϣ
			parent.refreshComboGrid(EpisodeID); /// ˢ�� combogrid
		}else{
			$.messager.alert('��ʾ',"�ǼǺ��������","warning");
			return;
		}
	},'json',false)
}

/// ȡ������Ϣ
function GetPatEssInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		
		 $("#PatName").val(jsonString.PatName); /// ����
		 $("#PatSex").val(jsonString.PatSex);	/// �Ա�
		 $("#PatAge").val(jsonString.PatAge);	/// ����
		 $("#PatNo").val(jsonString.PatNo);		/// �ǼǺ�
		 $("#PatBed").val(jsonString.PatBed);	/// ����
		 $("#PatBill").val(jsonString.PatBill); /// �ѱ�
		 $("#PatDiagDesc").val(jsonString.PatDiagDesc);/// ���
	},'json',false)
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
			$.messager.alert('��ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// �����Ƿ��������
function isTakOrder(DisGrpID){

	var isTakOrderFlag = "";
	runClassMethod("web.DHCMDTConsultQuery","isTakOrder",{"DisGrpID":DisGrpID},function(jsonString){
		
		isTakOrderFlag = jsonString;
	},'',false)

	return isTakOrderFlag;
}

/// ��Ժר�ҿ�ݷ�ʽ
function shortcut_selOuterExp(){
	
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	if (mdtDisGrp == "") {
		$.messager.alert("��ʾ","���Ѳ��ֲ���Ϊ�գ�","warning");
		return;
	}
	
	var Link = "dhcmdt.makresloc.csp?DisGrpID="+ mdtDisGrp +"&Type=E"+"&MWToken="+websys_getMWToken();
	window.parent.commonShowWin({
		url: Link,
		title: $g("��Ժר�ҿ��ѡ��"),
		width: 900,
		height: 500
	})
}

/// ������֧��
function multi_Language(){
	
	$g("��ʾ");
	$g("û��Ȩ�޷���MDT���룡")
	$g("����ȷ��ר�ҿ��ң�")
	$g("���Ѳ��ֲ���Ϊ�գ�")
	$g("����Ŀ�Ĳ���Ϊ�գ�")
	$g("����ժҪ����Ϊ�գ�")
	$g("����ԤԼʱ�������Ѳ��������İ���ʱ��Ϊ����")
	$g("��ѡ������¼�����ԣ�")
	$g("�뷢�ͻ���������ٴ�ӡ��")
	$g("����Ȩ�޲鿴�ò��˲������ݣ�")
	$g("�뱣�������ٿ�����Ȩ��")
	$g("���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:")
	$g("��������ȡ�����ʧ�ܣ�ʧ��ԭ��:")
	$g("�����������ʧ�ܣ�ʧ��ԭ��:")
	$g("��������ʧ�ܣ�ʧ��ԭ��:")
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ��:")
	$g("�������뱣��ʧ�ܣ�ʧ��ԭ��:")
	$g("������Ҳ���Ϊ�գ�")
	$g("����ר�����Ա����������3�ˣ�")
	$g("�Ѿ�ȡ�Ų�������")
	$g("��ǰ״̬�Ƿ���״̬��������")
	$g("��ȷ��Ҫȡ����ǰ����������")
	$g("����ѡ��������룬�ٽ��д˲�����")
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��")
	$g("���뵥��ǰ״̬��������ȡ����ɲ�����")
	$g("����ʱ�䲻����������ʱ�䣡")
	$g("�뷢�ͻ���������ٴ�ӡ��")
	$g("���뵥��ǰ״̬�������������ɲ�����")
	$g("����д���������")
	$g("�����ػ��������д�Ƿ�ͬ����ҩ!")
	$g("���뵥��ǰ״̬�������������ɲ�����")
	$g("����д���������")
	$g("���ǵ�ǰ������Ա�����ܽ��д˲�����")
	$g("���뵥�ѷ��ͣ������ٴη��ͣ�")
	$g("�뱣�����������ٷ��ͣ�")
	$g("�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����")
	$g("����û�����,����¼�룡")
	$g("�Ƿ������뵥?")
	$g("ԤԼ��Ϣ����Ϊ�գ�")
	$g("���ֺű���Ϊ�գ�")
	$g("���ߵ�ǰ����סԺ���Ƿ񽫷��ü���סԺ������?(���ȷ�ϰ�ť��סԺ�շѣ����ȡ����ť�������շ�")
	$g("ȷ�϶Ի���")
	$g("����ѡ����")
	$g("ȡ���ɹ���")
	$g("����ʧ�ܣ�")
	$g("����ɹ���")
	$g("��ɳɹ���")
	$g("�޸�ʧ�ܣ�")
	$g("�޸ĳɹ���")
	$g("���ͳɹ���")
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){

	setTimeout(function(){
		$HUI.datagrid("#dgCstDetList").resize();
		$HUI.datagrid("#LocGrpList").resize();
		$HUI.datagrid("#OuterExpList").resize();	
	},200)

	return;
	var Width = document.body.offsetWidth;
	var Height = window.screen.availHeight;
	$(".p-content").width(Width - 40);
	return;
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	if (CstID != ""){
		LoadReqFrame();  /// ����MDT���뵥����
	}else{
		LoadPageWriEl();  /// ȡ��¼��Ϣ
		GetPatBaseInfo(); /// ���˾�����Ϣ
	}
	
	/// �Զ��ֲ�
	onresize_handler();
}

function formatHtmlToValue(text){
	text = text.replace(new RegExp('&nbsp;',"g"),' '); //text.replaceAll("&nbsp;"," ");
	text = text.replace(new RegExp('&nbsp',"g"),' '); //text.replaceAll("&nbsp"," ");
	return text;
}

function getWidth(){
	
	var width=$(".ph-title").css("width")
	var twidth = width.split("px")[0]-20
	PageWidth=twidth
	$(".dataWidth").css("width",twidth+"px")
	}
	
	
window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })


function InitMoreScreen(){
	if(!IsOpenMoreScreen) return;
	
	ListenRetValue();
}
function ListenRetValue(){
	websys_on("onMdtRefData",function(res){
		if(res.flag===''){
			var nowValue = $("#mdtTrePro").val();
			$("#mdtTrePro").val( nowValue+(nowValue?'\r\n':'')+res.text);
		}
	});
}

function slUserName(value,row,index){
	//console.log(row);
	if (row.IsContact === "Y"){
		return 'color:#00F;';
	}
}

function userNameFormat(value, rowData, rowIndex){
	return value;
}
