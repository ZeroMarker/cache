//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-04-08
// ����:	   �����޸�ר��
//===========================================================================================
var editIndex = -1;   /// �༭��
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����
	InitComponent();
	
	/// ��ʼ����ϸ�б�
	InitDetList();
	
	/// ��ʼ��ר���б�
	InitDocList();
	
	multi_Language();         /// ������֧��
}

/// ��ʼ�����
function InitComponent(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// ���Ѳ���
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
}

/// ��ʼ����ϸ�б�
function InitDetList(){
	
	///  ����columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'���Ѳ���',width:140},
		{field:'PreTime',title:'ԤԼʱ��',width:180},
		{field:'PatName',title:'����',width:100},
		{field:'PatNo',title:'����ID',width:100},
		{field:'PayMony',title:'�շ�״̬',width:80,formatter:
			function (value, row, index){
				if (value == "δ�շ�"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'����״̬',width:80,formatter:
			function (value, row, index){
				if (value == "����"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstRLoc',title:'�������',width:120},
		{field:'CstRUser',title:'����ҽʦ',width:100},
		{field:'CstRTime',title:'����ʱ��',width:160},
		{field:'CstLocArr',title:'�μӻ������',width:220},
		{field:'CstPrvArr',title:'�μӻ���ҽʦ',width:220},
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:400},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'ID',title:'ID',width:100}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : false,
		pagination: true,
		onLoadSuccess:function(data){

		},
		onClickRow: function (rowIndex, rowData) {
			var rows = $("#bmDetList").datagrid('getSelections');
			var TmpArr = [];
			for(var i = 0; i < rows.length; i++){
				TmpArr.push(rows[i].ID);
			}
			$("#bmDocList").datagrid('reload',{mdtIDs:TmpArr.join("^")});
        }
	};
	/// ��������
	var param = "^^^"+ LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpQry&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��ʼ��ר���б�
function InitDocList(){
	
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
			blurValidValue:true,
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				if ($(ed.target).val() == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', "");
					$.messager.alert("��ʾ","����ȷ��ר�ҿ��ң�","warning");
					return;
				}
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);

				///���ü���ָ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
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
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				$(ed.target).val(option.value);
				
				///���ҽ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ���ְ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				$(ed.target).val("");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
				$(ed.target).combobox('setValue', "");
				
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID;
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
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);

				$m({
					ClassName:"web.DHCMDTCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
			    
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID=";
				$(ed.target).combobox('reload',unitUrl);
			
			},
			onChange:function(newValue, oldValue){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				if (newValue == ""){
					var ed=$("#bmDocList").datagrid('getEditor',{index:modRowIndex,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  ����columns
     var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'LocID',title:'����ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:280,editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'center',editor:DocEditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'center',hidden:false,editor:PrvTpEditor}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fit:true,
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (rowData.ID != "") return;
			if ((editIndex != -1)||(editIndex == 0)) { 
                $("#bmDocList").datagrid('endEdit', editIndex); 
            }
            
            $("#bmDocList").datagrid('beginEdit', rowIndex); 
			
            editIndex = rowIndex;          
        }
	};
	/// ��������
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpDet";
	new ListComponent('bmDocList', columns, uniturl, option).Init();
}

/// ɾ������
function delRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#bmDocList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ����','warning');
		return;
	}
	var mCareProvID = rowData.UserID;
	
	/// ����������б�
	var rows = $("#bmDetList").datagrid('getSelections');
	var TmpArr = [];
	for(var i = 0; i < rows.length; i++){
		TmpArr.push(rows[i].ID);
	}
	var mdtIds = TmpArr.join("^"); /// ����ID�б� 
	
	var IsPermitMsg = "";
	if (memControlFlag == 1) IsPermitMsg = GetIsPermitDel(mdtIds, mCareProvID); /// �Ƿ�����ɾ��
	if (IsPermitMsg != ""){
		$.messager.confirm('ȷ�϶Ի���','ɾ����ר�Һ󣬻���'+ IsPermitMsg +'�Ļ������ר������3�ˣ��Ƿ������', function(r){
			if (r){
				delCareProv(mdtIds, mCareProvID);  /// ɾ��ר��
			}
		});
	}else{
		delCareProv(mdtIds, mCareProvID);  /// ɾ��ר��
	}
}

/// ɾ��ר��
function delCareProv(mdtIds, mCareProvID){
	
	/// ����
	runClassMethod("web.DHCMDTConsult","RevCsCareProv",{"mdtIds":mdtIds, "mCareProvID":mCareProvID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$('#bmDocList').datagrid("reload");
		}
	},'',false)
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
	
	var rows = $("#bmDetList").datagrid('getSelections');
	if (rows.length == 0){
		$.messager.alert("��ʾ","����ѡ����޸Ļ����¼��","warning");
		return;
	}
			
    var rowObj={ID:'', PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#bmDocList").datagrid('appendRow',rowObj);
}

/// ������
function saveRow(){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#bmDocList").datagrid('endEdit', editIndex); 
    }

	/// ��Ա�ظ����
	var TmpCarePrv = ""; /// ר��
	var CarePrvArr = [];
	var rowData = $('#bmDocList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			if ($.inArray(item.UserID, CarePrvArr) != -1){
				TmpCarePrv = item.UserName;
			}
			CarePrvArr.push(item.UserID);
		}
	}
	if (TmpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocArr=[]; isEmptyFlag=0;
	var rowData = $('#bmDocList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^";
		    LocArr.push(TmpData);
		}
		if (item.UserID == "") isEmptyFlag = 1;
	}
	
	if (isEmptyFlag == 1){
		$.messager.alert("��ʾ","ר�Ҳ���Ϊ�գ�","warning");
		return;	
	}

	/// ����
	var mLocParams = LocArr.join("@");
	if (mLocParams == ""){
		$.messager.alert("��ʾ","δ��鵽�����Ӽ�¼��","warning");
		return;	
	}
	
	/// ����������б�
	var rows = $("#bmDetList").datagrid('getSelections');
	var TmpArr = [];
	for(var i = 0; i < rows.length; i++){
		TmpArr.push(rows[i].ID);
	}
	var mdtIds = TmpArr.join("^"); /// ����ID�б� 	

	/// ����
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":mdtIds, "mLocParams":mLocParams},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","����ɹ���","success",function(){
				$("#bmDocList").datagrid('reload');
			});
		}
	},'',false)
}

/// ��ѯ
function find_click(){
	
	$("#bmDocList").datagrid('reload',{mdtIDs:""}); /// ���
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var mDisGrpID = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// ���Ѳ���
	var params = StartDate +"^"+ EndDate +"^"+ mDisGrpID +"^"+ LgHospID;
	$("#bmDetList").datagrid("load",{"Params":params});
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

/// �Ƿ�����ɾ������ר��
function GetIsPermitDel(mdtIds, mCareProvID){

	var IsPermitDel = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCMDTConsult","IsPermitDel",{"mdtIds":mdtIds, "mCareProvID":mCareProvID},function(jsonString){

		if (jsonString != ""){
			IsPermitDel = jsonString;
		}
	},'',false)

	return IsPermitDel;
}

/// ������֧��
function multi_Language(){
	
	$g("��ʾ");
	$g("����ѡ��һ���������¼!");
	$g("����ȷ��ר�ҿ��ң�")
	$g("����ѡ���ɾ����")
	$g("ɾ��ʧ�ܣ�ʧ��ԭ��:")
	$g("����ѡ����޸Ļ����¼��")
	$g("ר�Ҳ���Ϊ�գ�")
	$g("δ��鵽�����Ӽ�¼��")
	$g("����ʧ�ܣ�ʧ��ԭ��:")
	$g("����ɹ���")
	$g("ȷ�϶Ի���")
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })