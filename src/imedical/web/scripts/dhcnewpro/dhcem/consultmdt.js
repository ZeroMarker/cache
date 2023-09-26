//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var CstID = "";         /// ��������ID
var editSelRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LType = "CONSULT";  /// ������Ҵ���
var CsRType = "MDT";    /// ��������  ҽ��
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
/// ҳ���ʼ������
function initPageDefault(){
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	HidePageButton(5);		  /// ��ʼ�����水ť
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// Ĭ��ƽ����
	$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);

	/// ��������
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	        if (option.text == "Ժ�ʻ���"){
		    	//$('#CstLoc').combobox({disabled:false});
		    	//$('#CstHosp').combobox({disabled:false});
		    	$HUI.combobox("#CstLoc").enable();
		    	$HUI.combobox("#CstHosp").enable();
		    	isEditFlag = 1;		/// �б༭��־
		    }else{
		    	$HUI.combobox("#CstHosp").disable();
		    	$HUI.combobox("#CstLoc").disable();
		    	isEditFlag = 0;		/// �б༭��־
			}
	    },
	    onLoadSuccess: function () { //���ݼ�������¼�
            var data = $('#CstType').combobox('getData');
             if (data.length > 0) {
                $("#CstType").combobox('select', data[0].value);
                $HUI.combobox("#CstType").disable();
            } 
        }
	};
	var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID;
	new ListCombobox("CstType",url,'',option).init();
	
	/// ҽԺ
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	        if (option.text == "����"){
		    	$("#CstUnit").attr("disabled", false);
		    }else{
		    	$("#CstUnit").val("").attr("disabled", true); 
			}
			
			$HUI.combobox("#CstLoc").setValue("");
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+option.value;
			$("#CstLoc").combobox('reload',unitUrl);
	    }
	};
	var url = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
	new ListCombobox("CstHosp",url,'',option).init();
	$HUI.combobox("#CstHosp").disable();  /// ҽԺ������
	
	/// ����
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstLoc",url,'',option).init();
	$HUI.combobox("#CstLoc").disable();  /// ���Ҳ�����
	
	/*
	/// ���ﲡ��
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstDise",url,'',option).init();
	*/
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}
		})
	},'json',false)
}

/// ȡ��¼��Ϣ
function GetLgContent(){

	runClassMethod("web.DHCEMConsultQuery","GetLgContent",{"LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#CstRLoc').val(jsonObject.LocDesc);  /// �������
			$('#CstRDoc').val(jsonObject.LgUser);   /// ����ҽʦ
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
	
	// ���ұ༭��
	var LocEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=LINK_CSP+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ option.value;
				$(ed.target).combobox('reload',unitUrl);
				
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
	
	// ��רҵ�༭��
	var MarEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			editable:false,
			onSelect:function(option){
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				GetMarIndDiv(option.value); 	/// ȡ������רҵָ��
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
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:260,editor:LocEditor,align:'center'},
		{field:'MarID',title:'��רҵID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'��רҵ',width:200,editor:MarEditor,align:'center'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
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

            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
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
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
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
	
	GetMarIndDiv(""); 	/// ȡ������רҵָ��
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
    var rowObj={LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// ���Ͳ�������
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("��ʾ:","�������Ͳ���Ϊ�գ�");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();  		/// ��Ҫ����
	if (CstTrePro == ""){
		$.messager.alert("��ʾ:","����ժҪ����Ϊ�գ�");
		return;
	}
	var CstPurpose = $("#ConsPurpose").val();  	/// ����Ŀ��
	if (CstPurpose == ""){
		$.messager.alert("��ʾ:","�������ɼ�Ҫ����Ϊ�գ�");
		return;
	}
	
	var CsRUserID = session['LOGON.USERID'];  		/// �������
	var CsRLocID = session['LOGON.CTLOCID'];  		/// ������
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// �Ӽ���ʶ
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}

	var CstTypeID = $HUI.combobox("#CstType").getValue(); 	      /// ��������
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	var CstHospID = $HUI.combobox("#CstHosp").getValue(); 	      /// ��Ժ
	var CstUnit = $HUI.combobox("#CstHosp").getText(); 	          /// ��Ժ����
	var CstDate = ""; //$HUI.datebox("#CstDate").getValue();      /// ��������
	var CstTime = ""; //$HUI.timespinner("#CstTime").getValue();  /// ����ʱ��
	
	var CstOutFlag = "N";                /// �Ƿ���Ժ
	if ($("#CstUnit").val() != ""){
		CstUnit = $("#CstUnit").val();   /// ��Ժ����
	}
	if (CstUnit != ""){ CstOutFlag = "Y"; }
	//var CstLoc = $("#CstLoc").val();     /// ��Ժ����
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// ��Ժ����
	var CstUser = $("#CstUser").val();   /// ��ϵ��
	var CstTele = $("#CstTele").val();   /// ��ϵ�绰
	var CstNote = "";  				     /// ��ע
	var CstAddr = $("#CstAddr").val();   /// ����ص�
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "";

	/// �������
	var ConsDetArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ "" +"^"+ item.MarID  ;
		    ConsDetArr.push(TmpData);
		}
	})

	if ((ConsDetArr.length == 1)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ��ƻ������ѡ���������������Ͽ��ң�");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("����") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ���ƻ������ѡ�������ң�");
		return;	
	}
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�");
		return;	
	}

	/// ��רҵָ��
	var MarIndArr = [];
	$('input[name="MarInd"]:checked').each(function(){
		MarIndArr.push(this.value);
	})
	var MarIndList = MarIndArr.join("@");

	///             ����Ϣ  +"&"+  �������  +"&"+  ��רҵָ��
	var mListData = mListData +"&"+ ConsDetList +"&"+ MarIndList;

	/// ����
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			CstID = jsonString;
			$.messager.alert("��ʾ:","����ɹ���");
		}
	},'',false)
}
/*
/// ����
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","���ͳɹ���");
		}
	},'',false)
}
*/

/// �����鿴
function LoadPatientRecord(){
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
	var link = "emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID'];
	$("#newWinFrame").attr("src",link);
}


/// ���ػ�����������Ϣ����
function GetCstNoObj(){

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
	$("#CstUser").val(itemobj.CstUser);   		    /// ��ϵ��
	$("#CstTele").val(itemobj.CstPhone);   		    /// ��ϵ�绰
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// �������
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// ����ҽʦ
	$("#ConsOpinion").val(itemobj.CstOpinion);      /// ������� 

	/// �Ӽ�
	$HUI.radio("input[name='CstEmFlag'][value='"+ itemobj.CstEmFlag +"']").setValue(true);
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);     /// ��������
	$HUI.combobox("#CstType").setValue(itemobj.CstType);       /// ��������
	
	if(itemobj.CstUnit != ""){
		$HUI.combobox("#CstHosp").setText(itemobj.CstUnit);    /// ��Ժ
	}else{
		$HUI.combobox("#CstHosp").setText("");                 /// ��Ժ
		$("#CstUnit").val(itemobj.CstUnit);                    /// ��Ժ����
	}
	if(itemobj.CstDocName != ""){
		$HUI.combobox("#CstLoc").setText(itemobj.CstDocName);  /// ��Ժ����
	}else{
		$HUI.combobox("#CstLoc").setText("");                  /// ��Ժ����
	}
	//$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// ��������
	//$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// ����ʱ��
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// ϵͳ����
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// ϵͳʱ��
	
	CsUserID = itemobj.CsUserID;  /// ������Ա
	EpisodeID = itemobj.EpisodeID;
	
}

/// ����
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			CstID = jsonString;
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ:","���ͳɹ���");
			if (window.parent.reLoadMainPanel != undefined){
				window.parent.reLoadMainPanel(CstID);
			}
		}
	},'',false)
}

/// ȡ��
function CanCstNo(){
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫȡ����ǰ����������', function(r){
		if (r){
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
	});
	
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
function AcceptCstNo2(Params){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","���ܳɹ���");
			GetCstNoObj();  	          /// ���ػ�������
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
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","���ܳɹ���");
			GetCstNoObj();  	          /// ���ػ�������
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ����
function SaveAccCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// ��������
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// ����ʱ��
	var Params = consDate +"^"+ consTime;
	AcceptCstNo2(Params)
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

/// �������
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("��ʾ:","���ǵ�ǰ������Ա�����ܽ��д˲�����");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("��ʾ:","����д���������");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�");
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
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡");
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","��ɳɹ���");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ���
function saveCompCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// ��������
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// ����ʱ��
	var Params = consDate +"^"+ consTime;
	CompCstNo2(Params)
}
	
/// ���
function CompCstNo2(Params){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("��ʾ:","���ǵ�ǰ������Ա�����ܽ��д˲�����");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("��ʾ:","����д���������");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡");
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
	
	if (CstItmID == ""){
		PrintCst_REQ(CstID);
	}else{
		PrintCst_REQ(CstItmID);
	}
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
	GetCstNoObj();  	          /// ���ػ�������
	GetConsMarIndDiv(CstID);	  /// ȡ���������רҵָ��
	isShowPageButton(arCstID);    /// ��̬����ҳ����ʾ�İ�ť����
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// �������
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	if (CstID != ""){
		LoadReqFrame(CstID, "");    /// ���ز�������
	}
	
	GetLgContent();  /// ȡ��¼��Ϣ
}

/// ������Ȩ
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("��ʾ:","�뱣�������ٿ�����Ȩ��");
		return;
	}
	
	/// �½�������Ȩ����
	newCreateConsultWin();
	
	var LinkUrl = GetConsAutUrl();
	if (LinkUrl != ""){
		$("#TabMain").attr("src", LinkUrl);
	}
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
			$.messager.alert("��ʾ:",jsonString);
		}
	},'',false)
}

/// �½�������Ȩ����
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX('���ﲡ����Ȩ', 'newConWin', '500', '500', option).Init();

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

	var url="dhcem.consultpatemr.csp?&EpisodeID="+EpisodeID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-5)+'px;DialogHeight='+(window.screen.availHeight-5)+'px;center=1'); 
	try{
		if (result){
			if (flag == 1){
				if ($("#ConsTrePro").val() == ""){
					$("#ConsTrePro").val(result.innertTexts);  		/// ��Ҫ����
				}else{
					$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
				}
			}else{
				if ($("#ConsOpinion").val() == ""){
					$("#ConsOpinion").val(result.innertTexts);  		/// ��Ҫ����
				}else{
					$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
				}	
			}
		}
	}catch(ex){}
}

/// ��̬����ҳ����ʾ�İ�ť����
function isShowPageButton(CstID){

	runClassMethod("web.DHCEMConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID']},function(jsonString){

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
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ord").hide();   /// ҽ��¼��
		
		$("#bt_save").show();  /// ����
		$("#bt_send").show();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#bt_sure").show();  /// ȷ��
		$("#bt_openemr").show();   /// ������Ȩ
		$("#bt_colseemr").show();  /// �ر���Ȩ
		$("#Opinion").show();  /// �������
		PageEditFlag(1);	   /// ҳ��༭
		isEditFlag = 0;	       /// �б༭��־
	}
	/// �����  �����ѷ���
	if (BTFlag == 2){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ

		$("#bt_can").show();   /// ȡ��
		$("#bt_sure").show();  /// ȷ��
		$("#Opinion").show();  /// �������
		PageEditFlag(2);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}

	/// ������ʾ
	if (BTFlag == 3){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		
		$("#bt_acc").show();   /// ����
		$("#bt_ref").show();   /// �ܾ�
		$("#bt_arr").show();   /// ����
		$("#bt_com").show();   /// ���
		$("#bt_ord").show();   /// ҽ��¼��
		$("#Opinion").show();  /// �������
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ��������ʾ
	if (BTFlag == 4){
		$("#bt_save").hide();  /// ����
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_com").hide();   /// ���
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#Opinion").show();  /// �������
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ҳ��Ĭ����ʾ
	if (BTFlag == 5){
		//$("#bt_can").hide();   /// ȡ��
		//$("#bt_sure").hide();  /// ȷ��
		//$("#bt_com").hide();   /// ���
		//$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#Opinion").hide();  /// �������
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
	}
}

/// ����
function SaveAcceptCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// ��������
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// ����ʱ��
	var Params = consDate +"^"+ consTime;
	runClassMethod("web.DHCEMConsult","SaveAccCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ:","���ܳɹ���");
			GetCstNoObj();  	          /// ���ػ�������
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ȡ������רҵָ��
function GetMarIndDiv(MarID){
	
	$("#itemList").html("");
	var rowData = $('#dgCstDetList').datagrid('getRows');
	for (var i=0; i<rowData.length; i++){
		if (typeof rowData[i].MarID != "undefined"){
			InsMarIndDiv(rowData[i].MarID);  /// ���ػ���ָ��
		}
	}
	if (MarID != ""){
		InsMarIndDiv(MarID);  /// ���ػ���ָ��
	}
	/// ����ָ��
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
	}
}

/// ���������רҵָ��
function InsMarIndDiv(MarID){
	
	runClassMethod("web.DHCEMConsLocItem","JsonSubMarInd",{"MarID":MarID},function(jsonObject){

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
function GetConsMarIndDiv(CstID){
	
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
	
	window.open("emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���λ���
function PatHisCst(){
	
	window.open("dhcem.consultquery.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���ý���༭״̬
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// ��Ҫ����
		$("#ConsPurpose").prop("readonly",false); /// ����Ŀ��
		$("#CstUser").attr("disabled", false);    /// ��ϵ��
		$("#CstTele").attr("disabled", false);    /// ��ϵ�绰
		$HUI.radio("input[name='CstEmFlag']").disable(false);
		//$('#CstType').combobox({disabled:false}); /// ��������
		$HUI.combobox("#CstType").enable();
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// ��Ҫ����
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// ����Ŀ��
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// ��ϵ��
		$("#CstTele").attr("disabled", true);		/// ��ϵ�绰
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();      /// ��������
	}
	if (Flag != 0){
		$("#ConsOpinion").prop("readonly",true);  /// �������
	}
}
window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })