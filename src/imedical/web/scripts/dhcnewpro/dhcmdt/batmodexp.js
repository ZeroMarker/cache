//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-04-08
// ����:	   �����޸�ר��
//===========================================================================================
var editIndex = -1;   /// �༭��
var editExpRow = -1;
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
	
	/// ��ʼ����Ժר���б�
	InitOuterExpGrid();
	
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
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID+"&MWToken="+websys_getMWToken(),
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
				if (value == "N"){return '<font style="color:red;font-weight:bold;">'+$g("δ�շ�")+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+$g("���շ�")+'</font>'}
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
		fit:true,
		onLoadSuccess:function(data){

		},
		onClickRow: function (rowIndex, rowData) {
			var rows = $("#bmDetList").datagrid('getSelections');
			var TmpArr = [];
			for(var i = 0; i < rows.length; i++){
				TmpArr.push(rows[i].ID);
			}
			$("#bmDocList").datagrid('reload',{mdtIDs:TmpArr.join("^")});
			$("#OuterExpList").datagrid('reload',{mdtIDs:TmpArr.join("^")});
        }
	};
	/// ��������
	var param = "^^^"+ LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpQry&Params="+param+"&MWToken="+websys_getMWToken();
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
			url: $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp"+"&MWToken="+websys_getMWToken(),
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:false,
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
			url: $URL +"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID"+session['LOGON.HOSPID']+"&MWToken="+websys_getMWToken(),
			blurValidValue:false,
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
				var unitUrl = $URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLoc&HospID="+LgHospID+"&MWToken="+websys_getMWToken();
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
			blurValidValue:false,
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
				var unitUrl=$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&DisGrpID="+"&MWToken="+websys_getMWToken();
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
		title:"Ժ��ר��",
		fit:true,
		fitColumns:false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
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
	
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpDet"+"&MWToken="+websys_getMWToken();
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
		if (jsonString !="0" ){
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
    
    if ((editExpRow != -1)||(editExpRow == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editExpRow); 
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
	
	/// ��Ժ��Ա�ظ����
	var TmpExpCarePrv = ""; /// ר��
	var CareExpPrvArr = [];
	var rowData = $('#OuterExpList').datagrid('getRows');
	for (var i = 0; i < rowData.length; i++){
		var item = rowData[i];
		if(trim(item.LocDesc) != ""){
			/// ��Ա�ظ����
			var masIndex=item.LocID+","+item.PrvTpID+","+item.UserName;
			if ($.inArray(masIndex, CareExpPrvArr) != -1){
				TmpExpCarePrv = item.UserName;
			}
			CareExpPrvArr.push(masIndex);
		}
	}
	if (TmpExpCarePrv != ""){
		$.messager.alert("��ʾ:","����ר�ң�"+ TmpExpCarePrv +"���ظ���ӣ�","warning");
		return;	
	}
	
	var LocExpArr=[]; isExpEmptyFlag=0;
	var rowData = $('#OuterExpList').datagrid('getChanges');
	for (var m = 0; m < rowData.length; m++){
		var item = rowData[m];
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.UserID +"^"+ item.UserName +"^"+ item.LocID +"^"+ item.PrvTpID +"^"+ item.TelPhone +"^"+ item.ID;
		    LocExpArr.push(TmpData);
		}
		if (item.UserName == "") isExpEmptyFlag = 1;
	}
	
	if (isExpEmptyFlag == 1){
		$.messager.alert("��ʾ","��Ժר����������Ϊ�գ�","warning");
		return;	
	}
	
	
	/// ����
	var mLocParams = LocArr.join("@");
	/// ��Ժ����
	var makOuterExp = LocExpArr.join("@");	
	
	if ((mLocParams == "")&&(makOuterExp=="")){
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
	runClassMethod("web.DHCMDTConsult","InsLocParams",{"mdtIds":mdtIds, "mLocParams":mLocParams,"makOuterExp":makOuterExp},function(jsonString){
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
			blurValidValue:false,
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
	var columns=[[
		{field:'LocID',title:'����ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'LocDesc',title:'����',width:200,align:'center',editor:LocEditor},
		{field:'UserID',title:'ҽ��ID',width:110,align:'center',hidden:true,editor:texteditor},
		{field:'UserName',title:'ҽ��',width:120,align:'center',editor:texteditor},
		{field:'TelPhone',title:'��ϵ��ʽ',width:100,align:'center',editor:numbereditor},
		{field:'PrvTpID',title:'ְ��ID',width:100,align:'center',hidden:true,editor:texteditor},
		{field:'PrvTp',title:'ְ��',width:160,align:'center',hidden:false,editor:PrvTpEditor}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		title:'��Ժר��',
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (rowData.ID) return;
		
            if ((editExpRow != -1)||(editExpRow == 0)) { 
                $("#OuterExpList").datagrid('endEdit', editExpRow); 
            }
            
            $("#OuterExpList").datagrid('beginEdit', rowIndex); 
			
            editExpRow = rowIndex;
            return;
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetBatModExpOutDet"+"&MWToken="+websys_getMWToken();
	new ListComponent('OuterExpList', columns, uniturl, option).Init();
}


/// �������
function insExpRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={UserID:'', UserName:''};
	$("#OuterExpList").datagrid('appendRow',rowObj);
}

 /// ɾ����
function delOutExpRow(rowIndex, id){
	
	/// �����༭
	if ((editIndex != -1)||(editIndex == 0)) { 
        $("#OuterExpList").datagrid('endEdit', editIndex); 
    }
    
	var rowData = $('#OuterExpList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ','����ѡ���ɾ���У�','warning');
		return;
	}
	var rowID=rowData.ID;
	
	/// ����
	runClassMethod("web.DHCMDTConsult","DeleteOuterExpert",{"ID":rowID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$('#OuterExpList').datagrid("reload");
		}
	},'',false)
	
	return;
	// ��ȡѡ���е�Index��ֵ
	var rowIndex=$('#OuterExpList').datagrid('getRowIndex',rowData);
    $('#OuterExpList').datagrid('deleteRow',rowIndex);
    var rows = $('#OuterExpList').datagrid("getRows");  //���»�ȡ���������к�
    $('#OuterExpList').datagrid("loadData", rows);
}

/// ���
function Clear(FlagCode){
	
	if (FlagCode == "G"){
		/// ���ڿ���
		$("#LocGrpList").datagrid("reload",{"QueFlg":'','ID':''});
	}else if(FlagCode == "I"){
		/// Ժ�ڿ���
		$("#mainList").datagrid("reload",{"QueFlg":'','ID':''});
	}else{
		/// Ժ�����
		$("#OuterExpList").datagrid("reload",{"QueFlg":'','ID':''});
	}
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