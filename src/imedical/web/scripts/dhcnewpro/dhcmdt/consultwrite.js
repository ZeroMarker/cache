//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-01-22
// ����:	   �������뵥
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CstID = "";         /// ��������ID
var CstItmID = "";      /// ���������ֱ�ID
var editSelRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var LType = "CONSULT";  /// ������Ҵ���
var CsRType = "DOC";    /// ��������  ҽ��
var CsRType2="DOC^PHA"; /// ��ҽ�������������ҩʦ����
var CstOutFlag = "";    /// Ժ�ʻ����־
var CstMorFlag ="";     /// ��ƻ����־
var TakOrdMsg = "";     /// ��֤�����Ƿ�����ҽ��
var TakCstMsg = "";     /// ��֤ҽ���Ƿ��п�����Ȩ��
var isOpiEditFlag = 0;  /// ��������ǿɱ༭
var isEvaShowFlag = 0;  /// ���������Ƿ���ʾ
var IsPerAccFlag = 0;   /// �Ƿ�����������뵥
var CsStatCode = "";    /// ���뵥��ǰ״̬
var seeCstType="";      /// ģʽ��1(�鿴ģʽ),2(����ģʽ),3(����ģʽ)
var PatType = "";       /// ��������
var IsAnti="N";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
/// ҳ���ʼ������
function initPageDefault(){
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitCsPropDiv();          /// ��ʼ����������
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	if (EpisodeID == ""){
		HidePageButton(4);	  /// ��ʼ�����水ť
	}else{
		HidePageButton(5);	  /// ��ʼ�����水ť
	}
	
	HideOrShowByModel();      /// ��������,����,�鿴��ģʽ��ͬ��ʼ������
}

function InitContentTop(){

	if(seeCstType != 1){
		var OpBtnsHeight=$("#OpBtns").height()+7;
		$("#p-content").css({"top":OpBtnsHeight});
	}else{
		$("#p-content").css({"top":10});
		isEditFlag = 1; /// ҳ���Ƿ�ɱ༭
	}
	return;
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	mradm = getParam("mradm");           /// �������ID
	CstID = getParam("CstID");           /// ����ID
	CstItmID = getParam("CstItmID");     /// �����ӱ�ID
	seeCstType = getParam("seeCstType"); /// ����鿴ģʽ
	isEvaShowFlag = getParam("EvaFlag"); /// ���������Ƿ���ʾ
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(1);    /// ��֤�����Ƿ�����ҽ��
		//InitPatNotTakCst(1);     /// ��֤�����Ƿ��л�������
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// Ĭ��ƽ����
	//$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	$HUI.radio("input[name='CstEmFlag'][label='"+$g("ƽ����")+"']").setValue(true);
	
	///���ü���ָ��
	var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID +"&CsRType="+CsRType;
	
	/// ��������
	var option = {
		url:unitUrl,
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text == "Ժ�ʻ���"){
		    	$HUI.combobox("#CstLoc").enable();
		    	$HUI.combobox("#CstHosp").enable();
		    	isEditFlag = 1;		/// �б༭��־
		    }else{
			    $HUI.combobox("#CstHosp").setValue(""); /// ���ҽԺ
		    	$HUI.combobox("#CstLoc").setValue("");  /// ��տ���
		    	$HUI.combobox("#CstHosp").disable();
		    	$HUI.combobox("#CstLoc").disable();
		    	$("#CstUnit").val("").attr("disabled", true);
		    	isEditFlag = 0;		/// �б༭��־
			}
			
			$("#dgCstDetList").datagrid("load",{"CstID":""});      /// �������
			
			GetMarIndDiv("","");  /// �����רҵָ��
	    },
	    onShowPanel: function () { //���ݼ�������¼�
			$("#CstType").combobox('reload',unitUrl);
        },
        onLoadSuccess:function(data){
	        var data = $HUI.combobox("#CstType").getData();
	        var CstType = $HUI.combobox("#CstType").getValue();
	        if(data.length>0){
		        if(CstType==""){
			    	$HUI.combobox("#CstType").select(data[0].value);
		        }
		    }
	    }

	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID;
	new ListCombobox("CstType",url,'',option).init();
	
	/// ҽԺ
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("����")) != "-1"){
		    	$("#CstUnit").attr("disabled", false);
		    }else{
		    	$("#CstUnit").val("").attr("disabled", true); 
			}
			
			$HUI.combobox("#CstLoc").setValue("");
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+option.value;
			$("#CstLoc").combobox('reload',unitUrl);
	    },
		onShowPanel:function(){
			
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
			$("#CstHosp").combobox('reload',unitUrl);
		}
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=HOS&HospID="+LgHospID;
	new ListCombobox("CstHosp",url,'',option).init();
	$HUI.combobox("#CstHosp").disable();  /// ҽԺ������
	
	/// ����
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        
	    }
	};
	var url = ""; //$URL+"?ClassName=web.DHCEMConsHosLoc&MethodName=JsonDicLoc&HospID="+LgHospID;
	new ListCombobox("CstLoc",url,'',option).init();
	$HUI.combobox("#CstLoc").disable();  /// ���Ҳ�����
	
	/// ��������
	$HUI.datebox("#CstDate").setValue(GetCurSystemDate(0));
	
	/// ���������
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("����")) != "-1"){
		    	$("#CstEvaRDesc").attr("disabled", false);
		    }else{
		    	$("#CstEvaRDesc").val("").attr("disabled", true); 
			}
	    },
		onShowPanel:function(){
			
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=EVA&HospID="+LgHospID;
			$("#CstEvaR").combobox('reload',unitUrl);
		}
	};
	var url = "";
	new ListCombobox("CstEvaR",url,'',option).init();
	
	/// ��������
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
	        if (option.text.indexOf($g("����")) != "-1"){
		    	$("#CstEvaDesc").attr("disabled", false);
		    }else{
		    	$("#CstEvaDesc").val("").attr("disabled", true); 
			}
	    },
		onShowPanel:function(){
			
			///���ü���ָ��
			var unitUrl = $URL+"?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&mCode=EVA&HospID="+LgHospID;
			$("#CstEva").combobox('reload',unitUrl);
		}
	};
	var url = "";
	new ListCombobox("CstEva",url,'',option).init();
	
	/// Ժ��
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    },
		onShowPanel:function(){
			
			///���ü���ָ��
			//var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonHosp";
			//$("#HospArea").combobox('reload',unitUrl);
		}
	};
	var url = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonHosp";
	new ListCombobox("HospArea",url,'',option).init();
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
			$('#CstAddr').val(jsonObject.LocAddr);  /// ���ҵ�ַ
			$HUI.combobox("#HospArea").setValue(jsonObject.HospID)
			$HUI.combobox("#HospArea").setText(jsonObject.HospDesc)
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
		
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CsRType2,
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
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
					$(ed.target).combobox('setValue', "");
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
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
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);
				
//				///���ü���ָ��
//				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);
				
//				///���ü���ָ��
//				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
//				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+ option.value;
//				$(ed.target).combobox('reload',unitUrl);

				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val("");
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var HospID = $HUI.combobox("#HospArea").getValue(); /// Ժ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+HospID;
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
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// ȡ������רҵָ��
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
					var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'center'},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'center'},
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
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if ((isEditFlag == 1)||((rowData.itmID != "")&&(CsStatCode!=""))) return;
			
			var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
			if (((CstType.indexOf($g("����")) != "-1")&(rowIndex != 0))||(CstType == ""))return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#dgCstDetList").datagrid('endEdit', editSelRow); 
            }
            $("#dgCstDetList").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
//			/// ҽ��   ���н𿨻���ſ�ָ��ҽ��
//			var ed=$("#dgCstDetList").datagrid('getEditor',{index:rowIndex,field:'UserName'});
//			if (CstType.indexOf("��") != "-1"){
//				$HUI.combobox(ed.target).enable();
//			}else{
//				$HUI.combobox(ed.target).setValue("");
//				$HUI.combobox(ed.target).disable();
//			}
				
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
             /// �Ƿ����û�����רҵ
            if (MarFlag != 1){
				$("#dgCstDetList").datagrid('hideColumn','MarDesc');
            }
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){
	var itmID=rowData.itmID;
	var html = '<a href="#" onclick="delRow(\''+ itmID +'\',\''+ rowIndex +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    html += '<a href="#" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	return html;
}

/// ɾ����
function delRow(itmID, rowIndex){
	
	if (isEditFlag == 1) return;
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	if (itmID.indexOf("||") != "-1"){
		$.messager.confirm("ɾ��", "��ȷ��Ҫɾ���������������", function (r) {
			if (r) {
				if (delCsItem(itmID)){
					$("#dgCstDetList").datagrid("reload");  /// ˢ��
					
					if (window.parent.QryConsList != undefined){  ///ˢ������б�
						window.parent.QryConsList("R");
					}
				}
			}
		});
	}else{
		delRowObj(rowIndex);  /// ɾ����
	}
	
	// ɾ����,��������
	//$('#dgCstDetList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	
	GetMarIndDiv("", ""); 	/// ȡ������רҵָ��
}

/// ɾ����
function delRowObj(rowIndex){
	
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:'', itmID:''};

	var rows = $('#dgCstDetList').datagrid('getRows');
	if(rows.length>2){
		 $('#dgCstDetList').datagrid('deleteRow',rowIndex);
	}else{
		$('#dgCstDetList').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	
	if(!isCanAddLoc()) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:'', itmID:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

function isCanAddLoc(){
	var ret=true;
	var CstType = $HUI.combobox("#CstType").getText(); 	 
	if ((CstType.indexOf($g("����")) != "-1")||(CstType == "")) ret=false;
	if ((CstType.indexOf("Ժ��") != "-1")||(CstType == "")) ret=false;	
	return ret;
}

/// ���Ͳ�������
function SaveCstNo(){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
    /// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
	
	/// ��֤ҽ���Ƿ��п�����Ȩ��
	if (TakCstMsg != ""){
		$.messager.alert("��ʾ:",TakCstMsg,"warning");
		return;	
	}
	
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("��ʾ:","�������Ͳ���Ϊ�գ�","warning");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();     /// ��Ҫ����
	if (CstTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","����ժҪ����Ϊ�գ�","warning");
		return;
	}
	CstTrePro = $_TrsSymbolToTxt(CstTrePro);        /// �����������
	
	var CstPurpose = $("#ConsPurpose").val();  	/// ����Ŀ��
	if (CstPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","�������ɼ�Ҫ����Ϊ�գ�","warning");
		return;
	}
	CstPurpose = $_TrsSymbolToTxt(CstPurpose);      /// �����������
	
	var CsRUserID = session['LOGON.USERID'];  		/// �������
	var CsRLocID = session['LOGON.CTLOCID'];  		/// ������
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// �Ӽ���ʶ
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}
	var CsPropID = $("input[name='CstEmFlag']:checked").attr("id"); /// ��������
	if (typeof CsPropID == "undefined"){
		$.messager.alert("��ʾ:","�����������ǰ������ѡ��������ʣ�","warning");
		return;
	}
	var CstTypeID = $HUI.combobox("#CstType").getValue(); 	      /// ��������
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	var CstHospID = $HUI.combobox("#CstHosp").getValue(); 	      /// ��Ժ
	var CstUnit = $HUI.combobox("#CstHosp").getText(); 	          /// ��Ժ����
	var CstDate = $HUI.datebox("#CstDate").getValue();     		  /// ��������
	var CstTime = $HUI.timespinner("#CstTime").getValue(); 		  /// ����ʱ��
	
	var CstOutFlag = "N";                /// �Ƿ���Ժ
	if ($("#CstUnit").val() != ""){
		CstUnit = $("#CstUnit").val();   /// ��Ժ����
	}
	if (CstUnit != ""){ CstOutFlag = "Y"; }
	
	if ((CstType.indexOf("Ժ��") != "-1")&(CstOutFlag == "N")){
		$.messager.alert("��ʾ:","δѡ��Ժ�ʻ���ҽԺ��","warning");
		return;	
	}
	//var CstLoc = $("#CstLoc").val();     /// ��Ժ����
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// ��Ժ����
	var CstUser = $("#CstUser").val();   /// ��ϵ��
	var CstTele = $("#CstTele").val();   /// ��ϵ�绰
	if (!$("#CstTele").validatebox('isValid')){
		$.messager.alert("��ʾ:","��ϵ�绰��֤ʧ�ܣ�������¼�룡","warning");
		return;
	}
	var CstNote = "";  				     /// ��ע
	var CstAddr = $("#CstAddr").val();   /// ����ص�
	var MoreFlag = CstType.indexOf($g("���")) != "-1"?"Y":"N";  /// �Ƿ���
	
//	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
//		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag;

	/// �������
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID  ;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if(HasRepetDoc){
		$.messager.alert("��ʾ:","����ͬһ��Ա������¼����ȷ�ϣ�","warning");
		return;
	}

	if ((ConsDetArr.length == 1)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ��ƻ������ѡ���������������Ͽ��ң�","warning");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("����") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ���ƻ������ѡ�������ң�","warning");
		return;	
	}
	if (ConsDetArr.length >= 2){ MoreFlag = "Y";}  /// ������������2,Ĭ��Ϊ���
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("��ʾ:","������Ҳ���Ϊ�գ�","warning");
		return;	
	}

	/// ��רҵָ��
	var MarIndArr = [];
	$('input[name="MarInd"]:checked').each(function(){
		MarIndArr.push(this.value);
	})
	var MarIndList = MarIndArr.join("@");
	
	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag +"^"+ CsPropID;

	///             ����Ϣ  +"&"+  �������  +"&"+  ��רҵָ��
	var mListData = mListData +del+ ConsDetList +del+ MarIndList;

	/// ����
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			$.messager.alert("��ʾ:","����ɹ���","info");
			$(".tip").text("("+$g("�ѱ���")+")");
			$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������
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
	
	if(CstItmID==""){
		CstID==""?"":CstItmID=CstID+"||1";	
	}

	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���û������뵥����
function InsCstNoObj(itemobj){

	$("#ConsTrePro").val($_TrsTxtToSymbol(itemobj.CstTrePro));  		/// ��Ҫ����
	$("#ConsPurpose").val($_TrsTxtToSymbol(itemobj.CstPurpose));  	/// ����Ŀ�� 
	$("#CstUser").val(itemobj.CstUser);   		    /// ��ϵ��
	$("#CstTele").val(itemobj.CstPhone);   		    /// ��ϵ�绰
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// �������
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// ����ҽʦ
	$("#CstAddr").val(itemobj.CstNPlace);           /// ����ص�
	$HUI.combobox("#HospArea").setValue(itemobj.CsHospID);   /// Ժ��
	var CstOpinion = "";
	if (itemobj.CstOpinion != ""){
		CstOpinion = itemobj.CstOpinion.replace(new RegExp("<br>","g"),"\r\n")
	}
	
	CstMorFlag = itemobj.CstMorFlag; 		/// ��ƻ����־
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	var IsNeedHideType=((MulWriFlag==0)&&(CstMorFlag=="Y"))||(CstMorFlag!="Y")
	var IsNoComp=(CsStatCode=="����")||(CsStatCode=="����")||(CsStatCode=="ȡ������")||(CsStatCode=="ȡ�����")||(CsStatCode.indexOf("���")!=-1);
	if(IsNeedHideType&IsNoComp&(NoCompHideOpin!=1)){
		$("#ConsOpinion").val("");
	}else{
		$("#ConsOpinion").val($_TrsTxtToSymbol(CstOpinion));      /// �������
	}
	/// �Ӽ�
	if (itemobj.CsPropID != ""){
		$HUI.radio("input[name='CstEmFlag'][id='"+ itemobj.CsPropID +"']").setValue(true);
	}
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);   /// ��������
	$HUI.combobox("#CstType").setText(itemobj.CstType);      /// ��������
	
	if(itemobj.CstUnit != ""){
		if (itemobj.isExiHosFlag == 1){
			$HUI.combobox("#CstHosp").setText(itemobj.CstUnit);    /// ��Ժ
		}else{
			$HUI.combobox("#CstHosp").setText($g("����ҽԺ"));         /// ��Ժ
			$("#CstUnit").val(itemobj.CstUnit);                    /// ��Ժ����
		}
	}else{
		$HUI.combobox("#CstHosp").setText("");                 /// ��Ժ
		$("#CstUnit").val(itemobj.CstUnit);                    /// ��Ժ����
	}
	if(itemobj.CstDocName != ""){
		$HUI.combobox("#CstLoc").setText(itemobj.CstDocName);  /// ��Ժ����
	}else{
		$HUI.combobox("#CstLoc").setText("");                  /// ��Ժ����
	}
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// ��������
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// ����ʱ��
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// ϵͳ����
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// ϵͳʱ��
	$HUI.datebox("#CstCompDate").setValue(itemobj.CmpDate);      /// �������
	$HUI.timespinner("#CstCompTime").setValue(itemobj.CmpTime);  /// ���ʱ��
	
	
	$HUI.radio("input[name='AntiRadio']").setValue(false);
	if (itemobj.AgreeFlag != ""){
		$HUI.radio("input[name='AntiRadio'][value='"+ itemobj.AgreeFlag +"']").setValue(true);
	}
	IsAnti = itemobj.CstEcType=="DOCA"?"Y":"N";  /// ����ҩ��������
	
	CsUserID = itemobj.CsUserID;            /// ������Ա
	EpisodeID = itemobj.EpisodeID;			/// ����ID
	PatientID = itemobj.PatientID;			/// ����ID
	CstOutFlag = itemobj.CstOutFlag; 		/// ��Ժ�����־
	CstMorFlag = itemobj.CstMorFlag; 		/// ��ƻ����־
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// ��������ǿɱ༭
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// �Ƿ�����������뵥
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	PatType = itemobj.PatType;              /// ��������
	if (CsStatCode == ""){
		$(".tip").text("("+$g("�ѱ���")+")");
	}else{
		$(".tip").text("");
	}
	
	if (itemobj.CsEvaRFlag != ""){
		
		$("#CstEvaRDesc").val("");
		
		$HUI.radio("input[name='CstEvaRFlag'][value='"+ itemobj.CsEvaRFlag +"']").setValue(true);
		if (itemobj.CsEvaRID != ""){
			$HUI.combobox("#CstEvaR").setText(itemobj.CsEvaRDesc);   /// ���������
		}else{
			$HUI.combobox("#CstEvaR").setText($g("����"));               /// ��������
			$("#CstEvaRDesc").val($_TrsTxtToSymbol(itemobj.CsEvaRDesc));  /// ���������
		}
	}else{
		$HUI.radio("input[name='CstEvaRFlag']").setValue(false);
		$HUI.combobox("#CstEvaR").setValue("");  /// ��������
		$("#CstEvaRDesc").val("");   		     /// ���������
	}
	
	if (itemobj.CsEvaFlag != ""){
		$HUI.radio("input[name='CstEvaFlag'][value='"+ itemobj.CsEvaFlag +"']").setValue(true);
		if (itemobj.CsEvaID != ""){
			$HUI.combobox("#CstEva").setText(itemobj.CsEvaDesc);  /// ��������
		}else{
			$HUI.combobox("#CstEva").setText($g("����"));             /// ��������
			$("#CstEvaDesc").val($_TrsTxtToSymbol(itemobj.CsEvaDesc)); /// ��������
		}
//		$HUI.radio("input[name='CstEvaFlag']").disable();
//		$("#CstEvaDesc").attr("disabled",true);    /// ���۲�������
//		$HUI.combobox("#CstEva").disable();        /// ��������
	}else{
		$HUI.radio("input[name='CstEvaFlag']").setValue(false);
		$HUI.combobox("#CstEva").setValue("");     /// ��������
		$("#CstEvaDesc").val("");   		       /// ���������	
	}
}

/// ����
function SendCstNo(){
		
	/// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
	/// ��֤ҽ���Ƿ��п�����Ȩ��
	if (TakCstMsg != ""){
		$.messager.alert("��ʾ:",TakCstMsg,"warning");
		return;	
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged() == 1){
		$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","�뱣�����������ٷ��ͣ�","warning");
		return;
	}
	
	///��֤CAǩ��
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�","warning");
			return;
		}
		if (jsonString == -12){
			$.messager.alert("��ʾ:","��������������Ҫ�������ҽ��������ҽ��δ����,����ҽ������ʧ�ܣ�","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			CstID = jsonString;
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ:","���ͳɹ���","info",function(){
				
				GetCstNoObj();
				
				///���ͳɹ��������������Ҫ�Զ���Ȩ���Ӳ����鿴
				if(DefOpenAcc==1){
					InsEmrAutMasAll(1);
				}
				///���ͳɹ��������������Ҫ�Զ���Ȩҽ�� hxy 2021-01-18
				if(DefOpenAccOrd==1){
					InsEmrAutMasAll(2);
				}
			});
			ConsInsDigitalSign(CstID,"R","A");
			if (window.parent.reLoadMainPanel != undefined){
				if(CstItmID!=""){ //hxy 2021-01-13 st ��������Ҳ�״̬���ܶ�Ӧ�仯
					window.parent.reLoadMainPanel(CstItmID);
				}else{
				window.parent.reLoadMainPanel(CstID);
				} //ed
			}
			$(".tip").text("");
		}
	},'',false)
}

function InsEmrAutMasAll(Flag){
	var Hour=Number(DefOpenAccHour); //hxy 2021-01-15 st
	if((Hour==0)||(Hour==NaN)){
		Hour=72;
	} //ed
	var params = EpisodeID+"^"+CstID+"^"+LgUserID+"^"+Hour+"^"+Flag;
	var FlagDesc="����";
	if(Flag==2)FlagDesc="ҽ��";
	runClassMethod("web.DHCEMConsult","InsEmrAutMasAll",{"Params":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�Զ�����"+FlagDesc+"��Ȩ"+Hour+"Сʱ�鿴Ȩ�ޣ�","warning");
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


///���ͺ�ȡ��CAǩ������
function ConsInsDigitalSign(CstID,ConsType,Type){
	if(CAInit!=1) return;
	runClassMethod("web.DHCEMConsultQuery","GetConsOrds",{"CstID":CstID, "ConsType":ConsType},function(ordItms){
		if(ordItms!=""){
			InsDigitalSign(ordItms,LgUserID,Type);	
		}
	},'text',false)
}

function RemoveCstNo(){
	if (CstID == ""){
		$.messager.alert("��ʾ:","����ѡ��������룬�ٽ��д˲�����","warning");
		return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫɾ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","RemoveCstNo",{"CstID":CstID},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȡ��������","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("��ʾ:","��������ɾ��ʧ�ܣ�ʧ��ԭ��:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("��ʾ:","ɾ���ɹ���","info",function(){
						window.location.reload();
					});
					if(window.parent.reLoadMainPanel){
						window.parent.reLoadMainPanel("");	
					}
				}
			},'json',false)
		}
	});
}

/// ȡ��
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","����ѡ��������룬�ٽ��д˲�����","warning");
		return;
	}
	
	/// ��֤�����Ƿ�����ҽ��
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg.replace("�ٿ�����","ȡ��"),"warning");
		return;	
	}
	
	///��֤CAǩ��
	if (!isTakeDigSign()) return;
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫȡ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","InvCanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȡ��������","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("��ʾ:","��������ȡ��ʧ�ܣ�ʧ��ԭ��:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("��ʾ:","ȡ���ɹ���","info",function(){
						if(seeCstType==2){
							window.location.reload();	///�����������ȡ�������ʱ��ˢ�½���					
						}	
					});
					ConsInsDigitalSign(CstID,"R","S");
					//GetCstNoObj();  	          /// ���ػ������� //hxy 2020-03-02 st
					//isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
					//window.parent.reLoadMainPanel(CstItmID);  
					window.location.reload(); 
					window.parent.reLoadMainPanel(""); //ed
				}
			},'json',false)
		}
	});
	
}

/// ȷ��
function SureCstNo(){
	
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	runClassMethod("web.DHCEMConsult","SureCstMas",{"CstID": CstID, "ItmID":ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		/*if (jsonString == -1){ //hxy 2020-05-08 st
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȷ�ϲ�����","warning");
			return;
		}*/
		if (jsonString.split("^")[0] == -1){
			$.messager.alert("��ʾ:","��ǰ״̬���������ȷ�ϲ�����","warning");
			return;
		}//ed
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","ȷ�ϳɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ȡ��ȷ��
function CanSureCstNo(){
	runClassMethod("web.DHCEMConsult","CanSureCstMas",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","��ǰ״̬���������ȡ��ȷ�ϲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ȡ��ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","ȡ��ȷ�ϳɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ����
function AcceptCstNo2(Params){

	runClassMethod("web.DHCEMConsult","AcceptCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ճɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ����
function AcceptCstNo(){
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"AcceptCstMas":"AcceptCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }

	runClassMethod("web.DHCEMConsult","AcceptCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("��ʾ:","�����ѱ����أ����ܽ��գ�","warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("��ʾ:","Ժ�ʻ�����δ���,��������н��ղ���!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ճɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.UpdMainPanel(CstItmID,$g("����"));
		}
	},'',false)	
}

/// ��������
function RevAccCstNo(){
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"AcceptCstMas":"AcceptCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }

	runClassMethod("web.DHCEMConsult","RevAccCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬�����������ȡ�����ղ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","ȡ���ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.UpdMainPanel(CstItmID,$g("ȡ������"));
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
			$.messager.alert("��ʾ:","���뵥��ǰ����״̬����������оܾ�������","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","���뵥�Ѿ���ˣ���������оܾ�������","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("��ʾ:","��ƻ��ﲻ����ܾ���","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","�ܾ��ɹ���","info");
			GetCstNoObj();  	         /// ���ػ�������
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ����
function AriCstNo(){
	
	runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬����������е��������","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������뵽��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// �������
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("��ʾ:","���ǵ�ǰ������Ա�����ܽ��д˲�����","warning");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","����д������ۣ�","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// Ԥ���
function PreCompCstNo(){
	var ConsOpinion = $("#ConsOpinion").val();
	
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	if (ConsOpinion==""){
		$.messager.alert("��ʾ:","����д������ۣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","PreCompCstMas",{"CstID":CstID,"ItmID": CstItmID,"CstOpinion":ConsOpinion,"LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������Ԥ���(�ݴ�������)������","warning");
			return;
		}
		
		if (jsonString == -300){
			$.messager.alert("��ʾ:","Ժ�ʻ�����δ���,���������Ԥ���(�ݴ�������)����!","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������Ԥ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","Ԥ���(�ݴ�������)�ɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���
function CompCstNo(){
	var IsUserAcc= ConsUseStatusCode.indexOf("^30^");   ///�Ƿ������˱���״̬
	
	if ((IsUserAcc!=-1)&(GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����","warning");
		return;
	}
	if ((IsUserAcc==-1)&(GetIsOperFlag("20") != "1")&(GetIsOperFlag("21") != "1")&(GetIsOperFlag("51") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����","warning");
		return;
	}
	
	var AntiOpinion = $("input[name='AntiRadio']:checked").val(); ///�Ƿ�ͬ��ʹ�ÿ�����ҩ�� 
	
	if((IsAnti=="Y")&((AntiOpinion=="")||(AntiOpinion==undefined))){
		$.messager.alert("��ʾ","�����ػ��������д�Ƿ�ͬ����ҩ!","warning");
		return false;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	if ((ConsOpinion == "")&&(IsAnti!="Y")){
		$.messager.alert("��ʾ:","����д������ۣ�","warning");
		return;
	}
	var CmpDate = $HUI.datebox("#CstCompDate").getValue();
	var CmpTime = $HUI.timespinner("#CstCompTime").getValue();
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	var ParObj={
		"CstID": CstID, 
		"ItmID": ItmID, 
		"LgParam":LgParam, 
		"CstOpinion":ConsOpinion,
		"AntiOpinion":AntiOpinion,
		"CmpDate":CmpDate,
		"CmpTime":CmpTime
	}
	
	///��֤CAǩ��
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","CompCstMas",ParObj,function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString == -13){
			$.messager.alert("��ʾ:","�������������Ҫ�������ҽ��������ҽ��δ����,����ҽ������ʧ�ܣ�","warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("��ʾ:","Ժ�ʻ�����δ���,�����������ɲ���!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			return;
		}else{
			$.messager.alert("��ʾ:","��ɳɹ���","info");
			ConsInsDigitalSign(CstID,"C","A");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
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
	
	///��֤CAǩ��
	if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬��������ȡ����ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-101){
				$.messager.alert("��ʾ:","���ʱ�䲻�����ڷ���ʱ�䣡","warning");
				return;	
			}
			if(jsonString==-102){
				$.messager.alert("��ʾ:","���ʱ����ڵ�ǰʱ�䣡","warning");
				return;	
			}
			if(jsonString==-2){
				$.messager.alert("��ʾ:","������ҩƷ�Ѿ�ʹ�ã�����������","warning");
				return;	
			}
			$.messager.alert("��ʾ:","��������ȡ�����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","ȡ���ɹ���","info");
			ConsInsDigitalSign(CstID,"C","S");
      		GetCstNoObj();  	            /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
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
		$.messager.alert("��ʾ:","���ǵ�ǰ������Ա�����ܽ��д˲�����","warning");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("��ʾ:","����д������ۣ�","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡","warning");
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","��ɳɹ���","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���������
function EvaRCstNo(){
	
	var IsUserSure= ConsUseStatusCode.indexOf("^60^");   ///�Ƿ������˱���״̬
	
	if ((IsUserSure!=-1)&(GetIsOperFlag("60") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("��ʾ:","���뵥��ǰ״̬��������������۲�����","warning");
		return;
	}
	if ((IsUserSure==-1)&(GetIsOperFlag("50") != "1")&(GetIsOperFlag("55") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("��ʾ:","���뵥��ǰ״̬��������������۲�����","warning");
		return;
	}
	var CstEvaRFlag = $("input[name='CstEvaRFlag']:checked").val();   /// ������������ȱ�ʶ
	if (typeof CstEvaRFlag == "undefined"){
		$.messager.alert("��ʾ:","����ѡ����������ȣ�","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEvaR").getValue(); 	      /// ��������
	var CstEvaDesc = $HUI.combobox("#CstEvaR").getText(); 	      /// ��������
	if (CstEvaDesc == ""){
		$.messager.alert("��ʾ:","��ѡ���������ݣ�","warning");
		return;
	}

	if (CstEvaDesc.indexOf($g("����")) != "-1"){
		var CstEvaDesc = $("#CstEvaRDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("��ʾ:","������д���۲������ݣ�","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// �����������
	
	var CsEvaParam = CstEvaRFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaRCstNo",{"CstID": CstID, "LgParam":LgParam, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬��������������۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","���۳ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ���������-ȡ������
function CanEvaRCstNo(){
	if(GetIsOperFlag("70") != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
		return;
	}
		
	runClassMethod("web.DHCEMConsult","CanEvaRCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","ȡ�����۳ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ��������
function EvaCstNo(){
	
	if (GetIsOperFlag("50") != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬��������������۲�����","warning","warning");
		return;
	}
	var CstEvaFlag = $("input[name='CstEvaFlag']:checked").val();   /// ������������ȱ�ʶ
	if (typeof CstEvaFlag == "undefined"){
		$.messager.alert("��ʾ:","����ѡ����������ȣ�","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEva").getValue(); 	      /// ��������
	var CstEvaDesc = $HUI.combobox("#CstEva").getText(); 	      /// ��������
	if (CstEvaDesc == ""){
		$.messager.alert("��ʾ:","��ѡ���������ݣ�","warning");
		return;
	}
	
	if (CstEvaDesc.indexOf($g("����")) != "-1"){
		CstEvaDesc = $("#CstEvaDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("��ʾ:","������д���۲������ݣ�","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// �����������
	
	var CsEvaParam = CstEvaFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬��������������۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","������������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","���۳ɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}


/// ��������-ȡ����������
function CanEvaCstNo(){

	runClassMethod("web.DHCEMConsult","CanEvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","ȡ�����۳ɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
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
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","�뷢�ͻ���������ٴ�ӡ��","warning");
		return;
	}
	if (typeof CstItmID == "undefined"){
		PrintCst_REQ(CstID);
	}else{
		PrintCst_REQ(CstItmID);
	}
	
	InsCsMasPrintFlag();  /// �޸Ļ����ӡ��־
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

/// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(){
	
	runClassMethod("web.DHCEMConsult","InsCsMasPrintFlag",{"CstID":CstID},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("��ʾ:","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
	},'',false)
}

/// �������뵥����
function LoadReqFrame(arCstID, arCstItmID){

	CstID = arCstID;
	CstItmID = arCstItmID;
	InitCsPropDiv();              /// ��ʼ����������
	GetCstNoObj();  	          /// ���ػ�������
	GetConsMarIndDiv(CstID);	  /// ȡ���������רҵָ��
	isShowPageButton(arCstID);    /// ��̬����ҳ����ʾ�İ�ť����
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(0);   /// ��֤�����Ƿ�����ҽ��
	}
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// �������
}

function HideOrShowByModel(){
	if(seeCstType==1){ 
		$("#OpBtns").hide();
		$(".p-content").css({"top":25});
	}else if(seeCstType==2){ 
		$("#CompAreaDiv").hide();   ///������ں����ʱ��
		$("#Opinion").hide();  ///�������
		$("#bt_reva").hide();  
		$("#bt_sure").hide();
		$("#bt_revsure").hide(); //hxy 2021-01-07
		$("#bt_revreva").hide(); //hxy 2021-01-08
		$("#bt_can").hide();
	}else{ 
		var CmpDate = $HUI.datebox("#CstCompDate").getValue();   ///�Ѿ������ʱ��ľͲ���ʼ��Ĭ��ʱ��
		$("#CompAreaDiv").show();
		if(UpdCompDateFlag==1){
			$HUI.datebox("#CstCompDate").enable();
			$HUI.timespinner("#CstCompTime").enable();
			
		}else{
			$HUI.datebox("#CstCompDate").disable();
			$HUI.timespinner("#CstCompTime").disable();
		}
	}
	return;	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	if (CstID != ""){
		LoadReqFrame(CstID, CstItmID);    /// ���ز�������
	}else{
		if (EpisodeID!="") GetLgContent();  /// ȡ��¼��Ϣ
	}
}

/// ������Ȩ
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("��ʾ:","�뱣�������ٿ�����Ȩ��","warning");
		return;
	}

	var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;

	websys_showModal({
		url:lnk,
		title:'��Ȩ',
		isTopZindex:true,
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			
		}
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
			$.messager.alert("��ʾ:",jsonString,"warning");
		}
	},'',false)
}

/// �½�������Ȩ����
function newCreateConsultWin(){
	var option = {
		};
	new WindowUX($g('������Ȩ'), 'newConWin', '1000', '600', option).Init();

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

	var Link="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
	
	typeof window.parent.commonShowWin == "function"?OpenWinObj=window.parent:OpenWinObj=window;
	
	OpenWinObj.commonShowWin({
		url: Link,
		title: $g("����"),
		width: 1280,
		height: 600
	})
//	//showModalDialog chrome ���ܼ���,����Open
//	//var result = window.showModalDialog(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
//	var result = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
//	return;
//	try{
//		if (result){
//			if (flag == 1){
//				if ($("#ConsTrePro").val() == ""){
//					$("#ConsTrePro").val(result.innertTexts);  		/// ��Ҫ����
//				}else{
//					$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
//				}
//			}else{
//				if ($("#ConsOpinion").val() == ""){
//					$("#ConsOpinion").val(result.innertTexts);  		/// ��Ҫ����
//				}else{
//					$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
//				}	
//			}
//		}
//	}catch(ex){}
}

function InsQuote(innertTexts,flag){
	
	if (flag == 1){
		if ($("#ConsTrePro").val() == ""){
			$("#ConsTrePro").val(innertTexts);  		/// ��Ҫ����
		}else{
			$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// ��Ҫ����
		}
	}else if(flag == 3){ //hxy 2021-01-12 st
		if ($("#ConsPurpose").val() == ""){
			$("#ConsPurpose").val(innertTexts);  		/// �������ɼ�Ҫ��
		}else{
			$("#ConsPurpose").val($("#ConsPurpose").val()  +"\r\n"+ innertTexts);  		/// �������ɼ�Ҫ��
		} //ed
	}else{
		if ($("#ConsOpinion").val() == ""){
			$("#ConsOpinion").val(innertTexts);  		/// ��Ҫ����
		}else{
			$("#ConsOpinion").val($("#ConsOpinion").val()  +"\r\n"+ innertTexts);  		/// ��Ҫ����
		}	
	}
	return;
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

	HideOrShowByModel();   		///�����롢�����鿴�������������ʾ������Ԫ��
	
	HideAndShowButton(BTFlag);  ///����ͨ�����˷��͡����˽�����ʾ��ť
	
	InitContentTop();     		///��ͬ�İ�ť����content��topֵ��ͬ
	
	DisAndEnabBtn();  		    ///ͨ��״̬���ð�ť�Ƿ�ȥ
	
	HideOrShowBySet();          ///����������ʾ����
	
	HideByConsType();           ///���ƶ�Ƶ�����
}

function HideByConsType(){
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	if(!isCanAddLoc()) {
		$("#bt_saveloc").hide(); /// �������	
	}
}

function HideAndShowButton(BTFlag){
	//IsAnti: Is anti consult flog
	/// �����  ����δ����
	if (BTFlag == 1){
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_revsure").hide();  /// ȡ��ȷ�� //hxy 2021-01-07
		$("#bt_reva").hide();  /// ����
		$("#bt_revreva").hide();  /// ȡ������ //hxy 2021-01-08
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_save").show();  /// ����
		$("#bt_remove").show(); ///ɾ��
		$("#bt_send").show();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#bt_openemr").show();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#Opinion").show();   /// �������
		$("#QueEmr").show();    /// ����
		$("#QueEmr2").hide();   /// ����
		$("#QueEmr3").show();   /// ���� hxy 2021-01-12
		$("#bt_order").hide();  /// ҽ��¼��
		$("#bt_patsee").hide();  /// ������
		$("#bt_patemr").hide(); /// �鿴����
		$("#bt_saveloc").hide(); /// �������
		$("#bt_can").hide();
		PageEditFlag(1);	    /// ҳ��༭
		isEditFlag = 0;	        /// �б༭��־
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// �����  �����ѷ���
	if (BTFlag == 2){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide();   /// ȡ���������� //hxy 2021-01-09
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_order").hide();     /// ҽ��¼��
		$("#bt_patsee").hide();  /// ������
		$("#bt_patemr").hide();    /// �鿴����
		$("#bt_openemr").show();   /// ������Ȩ
		$("#bt_can").show();   /// ȡ��
		if(seeCstType!=2){
			$("#Opinion").show();  /// �������
			$("#ConsEvaR").show(); /// ���������
		}
		
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").hide();  /// ����
		$("#QueEmr3").hide();   /// ���� hxy 2021-01-12
		$("#bt_log").show();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		if(seeCstType!=2){
			$("#bt_reva").show();  /// ����
			$("#bt_sure").show();  /// ȷ��
			$("#bt_revsure").show();  /// ȡ��ȷ�� //hxy 2021-01-07
			$("#bt_revreva").show();  /// ȡ������ //hxy 2021-01-08
		}
		if (ModCsFlag == 1){
			$("#bt_saveloc").show(); /// �������
		}else{
			$("#bt_saveloc").hide(); /// �������
		}
		PageEditFlag(2);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
		var CstType = $HUI.combobox("#CstType").getText(); 	 
		if ((ModCsFlag == 1)&&(CstType.indexOf("Ժ��")==-1)) isEditFlag = 0;	 /// �б༭��־
	}

	/// ������ʾ
	if (BTFlag == 3){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_revsure").hide();  /// ȡ��ȷ�� //hxy 2021-01-07
		$("#bt_reva").hide();  /// ����
		$("#bt_revreva").hide();  /// ȡ������ //hxy 2021-01-08
		$("#ConsEvaR").hide(); /// ���������
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_saveloc").hide();   /// �������
		
		$("#bt_acc").show();   /// ����
		$("#bt_ref").show();   /// �ܾ�
		$("#bt_revacc").show();/// ȡ������
		$("#bt_arr").show();   /// ����
		$("#bt_com").show();   /// ���
		$("#bt_revcom").show();/// ȡ�����
		$("#bt_precom").show();
		$("#bt_ceva").show();  /// ����
		$("#bt_revceva").show(); /// ȡ���������� //hxy 2021-01-09
		$("#bt_order").show();   /// ҽ��¼��
		$("#bt_patsee").show();  /// ������
		$("#bt_patemr").show(); /// �鿴����
		$("#Opinion").show();   /// �������
		$("#QueEmr").hide();    /// ����
		$("#QueEmr2").show ();  /// ����
		$("#QueEmr3").hide();   /// ���� hxy 2021-01-12
		$("#bt_TempLoc").show();   /// ����ģ��
		$("#bt_TempUser").show();  /// ����ģ��
		$("#bt_TempQue").show();   /// ѡ��ģ��
		$("#bt_TempSave").show();  /// ����ģ��
		$("#ConsEva").show();  	   /// ��������
		$("#bt_log").show();       /// ������־
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ��������ʾ
	if (BTFlag == 4){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_revsure").hide();  /// ȡ��ȷ�� //hxy 2021-01-07
		$("#bt_reva").hide();  /// ����
		$("#bt_revreva").hide();  /// ȡ������ //hxy 2021-01-08
		$("#bt_com").hide();   /// ���
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_patemr").hide();    /// �鿴����
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#Opinion").show();  /// �������
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").hide();  /// ����
		$("#QueEmr3").hide();   /// ���� hxy 2021-01-12
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#ConsEvaR").hide();     /// ���������
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_order").hide(); /// ҽ��¼��
		$("#bt_patsee").hide();  /// ������
		$("#bt_saveloc").hide(); /// �������
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ҳ��Ĭ����ʾ
	if (BTFlag == 5){
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_revsure").hide();  /// ȡ��ȷ�� //hxy 2021-01-07
		$("#bt_reva").hide();  /// ����
		$("#bt_revreva").hide();  /// ȡ������ //hxy 2021-01-08
		$("#bt_com").hide();   /// ���
		$("#bt_precom").hide();/// Ԥ���
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_patemr").hide();    /// �鿴����
		$("#Opinion").hide();      /// �������
		$("#QueEmr").show();   /// ����
		$("#QueEmr2").hide();  /// ����
		$("#QueEmr3").show();   /// ���� hxy 2021-01-12
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#ConsEvaR").hide(); /// ���������
		$("#ConsEva").hide();  /// ��������
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_order").hide(); /// ҽ��¼��
		$("#bt_patsee").hide();  /// ������
		$("#bt_saveloc").hide(); /// �������
	}
	
	/// ��Ժ�ʻ���  �����ѷ���
	if ((CstOutFlag == "Y")&(BTFlag == 2)&(IsPerAccFlag == 0)){
		$("#bt_acc").show();   /// ����
		$("#bt_revacc").show();/// ȡ������
		$("#bt_com").show();   /// ���
		$("#bt_precom").show();
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		if(CsStatCode=="���"){     
			$("#bt_revcom").show();    //״̬Ϊ���ʱ��ʾȡ����ɰ�ť
		}
	}
	
	/// ��������
	if (isEvaShowFlag == 1){
		$("#ConsEvaR").show(); /// ���������
		$("#ConsEva").show();  /// ��������
	}
	
	/// ��ƻ���  �������ʾ
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 2)){

		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		
		if (IsPerAccFlag == 0){
			$("#bt_acc").show();    /// ����
			$("#bt_precom").show(); /// Ԥ���
			$("#bt_com").show();    /// ���
			$("#ConsEvaR").show();  /// ���������
			$("#bt_revacc").show();
			$("#bt_revcom").show(); /// ȡ�����
			$("#QueEmr2").show ();  /// ����
	    }
	}
	
	/// ��ƻ���  ������ʾ
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 3)){
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
		$("#bt_revceva").hide();  /// ȡ���������� //hxy 2021-01-09
		$("#bt_acc").hide();   /// ����
		$("#bt_precom").hide(); ///Ԥ���
		$("#bt_com").hide();   /// ���
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
	}
	
	if (BTFlag == 4){
		$HUI.combobox("#HospArea").enable(); 	  /// Ժ��
	}
	
	if(IsAnti=="Y"){
		$("#AntiDiv").show();
		if(DocaNeedOpin!=1){
			$("#Opinion").hide();
			$("#bt_precom").hide(); ///Ԥ���
		}
		$("#bt_order").hide();   /// ҽ��¼��
		//$("#bt_patsee").hide();  /// ������
		$("#bt_saveloc").hide(); /// �������
	}else{
		$("#AntiDiv").hide();
		if(seeCstType!=2){
			$("#Opinion").show();
			$("#bt_precom").show(); ///Ԥ���
		}
	}
	
	
	/// �����ӱ�IDΪ��ʱ������ʾ������־��ť
	if (CstItmID == ""){
		$("#bt_log").hide();   /// ������־
	}	
}

function DisAndEnabBtn(){
	
	$HUI.linkbutton("#bt_acc").enable();
	$HUI.linkbutton("#bt_ref").enable();
	$HUI.linkbutton("#bt_com").enable();
	$HUI.linkbutton("#bt_precom").enable();
	$HUI.linkbutton("#bt_ceva").enable();
	$HUI.linkbutton("#bt_can").enable();
	$HUI.linkbutton("#bt_openemr").enable();
	$HUI.linkbutton("#bt_revcom").enable();
	$HUI.linkbutton("#bt_revacc").enable();
	$HUI.linkbutton("#bt_reva").enable();
	$HUI.linkbutton("#bt_remove").enable();
	$HUI.linkbutton("#bt_save").enable();
	$HUI.linkbutton("#bt_sure").enable();
	$HUI.linkbutton("#bt_order").enable();
	$HUI.linkbutton("#bt_print").enable();
	$HUI.linkbutton("#bt_patemr").enable();
	$HUI.linkbutton("#bt_patsee").enable();
	$HUI.linkbutton("#bt_revsure").disable(); //hxy 2021-01-07
	$HUI.linkbutton("#bt_revreva").disable(); //hxy 2021-01-08
	$HUI.linkbutton("#bt_revceva").disable(); //hxy 2021-01-09
	
	if(CsStatCode=="ȡ��"){
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_openemr").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_order").disable();
		$HUI.linkbutton("#bt_print").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		isEditFlag = 1;	         /// �б༭��־
	}
	
	
	if((CsStatCode=="�ܾ�")||(CsStatCode=="����")){
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_openemr").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_print").disable();
		$HUI.linkbutton("#bt_order").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		isEditFlag = 1;	         /// �б༭��־
	}
	
	if((CsStatCode=="����")||(CsStatCode=="���")){
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_remove").disable();
		$HUI.linkbutton("#bt_save").disable();	
		$HUI.linkbutton("#bt_sure").disable();
		if(ConsUseStatusCode.indexOf("^30^")!=-1){   ///����״̬����
			$HUI.linkbutton("#bt_com").disable();
			$HUI.linkbutton("#bt_precom").disable();	
		}
	}
	
	if((CsStatCode=="����")||(CsStatCode=="ȡ�����")){
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_reva").disable();
//		if(CsStatCode=="ȡ�����"){
//			$HUI.linkbutton("#bt_revacc").disable();	
//		}
	}
	
	if(CsStatCode=="ȡ������"){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_sure").disable();
	}
	
	if(CsStatCode=="���"){
		//$HUI.linkbutton("#bt_ceva").disable();
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();

		if(ConsUseStatusCode.indexOf("^60^")!=-1){   ///ȷ��״̬����
			$HUI.linkbutton("#bt_reva").disable();
		}
		isEditFlag = 1;	         /// �б༭��־
	}
	
	
	if(CsStatCode=="ȷ��"){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_sure").disable();
		isEditFlag = 1;	         /// �б༭��־
		$HUI.linkbutton("#bt_revsure").enable(); //hxy 2021-01-07 ֻ��ȷ��ʱ��ȡ��ȷ��
	}
	if(CsStatCode=="ȡ��ȷ��"){ //hxy 2021-01-07 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_ceva").disable(); //
		isEditFlag = 1;	         /// �б༭��־
	} //ed
	if(CsStatCode=="ȡ������"){ //hxy 2021-01-08 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_sure").disable();
		$HUI.linkbutton("#bt_revsure").enable(); //hxy 2021-01-08 ȡ������ʱ��ȡ��ȷ��
		$HUI.linkbutton("#bt_ceva").disable(); //
		isEditFlag = 1;	         /// �б༭��־
	} //ed
	if(CsStatCode=="ȡ����������"){ //hxy 2021-01-09 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		isEditFlag = 1;	         /// �б༭��־
	} //ed
	if((CsStatCode=="����")||(CsStatCode=="��������")){
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_ceva").disable();
		if(CsStatCode=="����"){
			$HUI.linkbutton("#bt_sure").disable();
			$HUI.linkbutton("#bt_reva").disable();
			$HUI.linkbutton("#bt_revreva").enable(); //hxy 2021-01-08 ֻ������ʱ��ȡ������
		}
		if((CsStatCode=="��������")&(ConsUseStatusCode.indexOf("^60^")!=-1)){  
			$HUI.linkbutton("#bt_reva").disable();
			$HUI.linkbutton("#bt_revceva").enable(); //hxy 2021-01-09 ֻ�л�������ʱ��ȡ������
		}
		
		isEditFlag = 1;	         /// �б༭��־
	}

	//if("^"+$g("ȡ��")+"^"+$g("�ܾ�")+"^"+$g("���")+"^"+$g("ȷ��")+"^"+$g("����")+"^"+$g("��������")+"^".indexOf("^"+CsStatCode+"^")!=-1){
	if(CsStatCode!="����"){
		$("#bt_saveloc").hide(); /// �������
		isEditFlag=1;
	}else{
		if(ModCsFlag == 1){
			$("#bt_saveloc").show(); /// �������
		}else{
			$("#bt_saveloc").hide(); /// �������
		}
	}
	
	if(seeCstType == 1){
		$("#bt_saveloc").hide();   /// �������
	}
	
}

///�ߺ�̨�������þ���������ʾ����
function HideOrShowBySet(){
	
	///�ܾ���ť
	if(ConsUseStatusCode.indexOf("^25^")==-1){
		$("#bt_ref").hide();	 ///�ܾ�����
	}
	
	///����
	if(ConsUseStatusCode.indexOf("^30^")==-1){
		$("#bt_acc").hide();     ///����
		$("#bt_revacc").hide();	 ///ȡ������
		$("#bt_ref").hide();	 ///�ܾ�����
	}
	
	///ȡ������
	if(ConsUseStatusCode.indexOf("^35^")==-1){
		$("#bt_revacc").hide();	 ///ȡ������
	}
	
	///��ɰ�ť
	if(ConsUseStatusCode.indexOf("^50^")==-1){
		$("#bt_precom").hide();	 ///Ԥ���
		$("#bt_com").hide();	 ///���
		$("#bt_revcom").hide();	 ///ȡ�����
	}
	
	///��������
	if((ConsUseStatusCode.indexOf("^55^")==-1)||(WriEvaCsFlag==0)){//hxy 2020-07-09 ԭ:if(ConsUseStatusCode.indexOf("^55^")==-1){
		$("#bt_ceva").hide();   ///��������
		$("#ConsEva").hide();	 	///��������
		$("#bt_revceva").hide();	///ȡ���������� //hxy 2021-01-08
	}
	
	
	///ȷ��
	if(ConsUseStatusCode.indexOf("^60^")==-1){
		$("#bt_sure").hide();   ///ȷ��
		$("#bt_revsure").hide();   ///ȡ��ȷ�� //hxy 2021-01-08
	}
	
	///����
	if(ConsUseStatusCode.indexOf("^70^")==-1){
		$("#bt_reva").hide();   ///����
		$("#ConsEvaR").hide;	 ///��������
		$("#bt_revreva").hide();   ///ȡ������ //hxy 2021-01-08
	}
	return;
}

/// ����
function SaveAcceptCstNo(){

	var consDate = $HUI.datebox("#ConsDate").getValue();      /// ��������
	var consTime = $HUI.timespinner("#ConsTime").getValue();  /// ����ʱ��
	var Params = consDate +"^"+ consTime;
	runClassMethod("web.DHCEMConsult","SaveAccCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "Params":Params},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ճɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ȡ������רҵָ��
function GetMarIndDiv(MarID, LocID){
	
	$("#itemList").html("");
	var rowData = $('#dgCstDetList').datagrid('getRows');
	for (var i=0; i<rowData.length; i++){
		if (typeof rowData[i].MarID != "undefined"){
			InsMarIndDiv(rowData[i].MarID, rowData[i].LocID);  /// ���ػ���ָ��
		}
	}
	if (MarID != ""){
		InsMarIndDiv(MarID, LocID);  /// ���ػ���ָ��
	}
	/// ����ָ��
	if ($("#itemList").html() == ""){
		$("#MarIndDiv ").hide();
	}else{
		$("#MarIndDiv ").show();
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
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(1) != 1){
		$.messager.alert("��ʾ:","����Ȩ�޲鿴�ò��˲������ݣ�","warning");
		return;
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	var lnk ="emr.interface.browse.category.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp';
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function PatPacsAndLis(){
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	var lnk = "dhcem.consultsee.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	websys_showModal({
		url:lnk,
		title:$g('������鿴'),
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			
		}
	});	
}

/// ���λ���
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	window.open("dhcem.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���ý���༭״̬
function PageEditFlag(Flag){
	
	if (Flag == 1){
		$("#ConsTrePro").prop("readonly",false);  /// ��Ҫ����
		$("#ConsPurpose").prop("readonly",false); /// ����Ŀ��
		$("#CstUser").attr("disabled", false);    /// ��ϵ��
		$("#CstTele").attr("disabled", false);    /// ��ϵ�绰
		//$HUI.radio("input[name='CstEmFlag']").disable(false);
		$HUI.combobox("#CstType").disable(); 	  /// ��������
		$HUI.radio("input[name='CstEmFlag']").enable();
		$HUI.combobox("#HospArea").enable(); 	  /// Ժ��
		//$HUI.combobox("#CstType").enable();
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// ��Ҫ����
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// ����Ŀ��
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// ��ϵ��
		$("#CstTele").attr("disabled", true);		/// ��ϵ�绰
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();        /// ��������
		$HUI.combobox("#HospArea").disable(); 	    /// Ժ��
	}

	if ((Flag != 0)&(CstOutFlag != "Y")&(isOpiEditFlag != "Y")){
		$("#ConsOpinion").prop("readonly",true);   /// �������
	}else{
		$("#ConsOpinion").prop("readonly",false);  /// �������
	}
	
	/// ��������
	if (isEvaShowFlag == 1){
		$HUI.radio("input[name='CstEvaFlag']").disable();
		$("#CstEvaDesc").attr("disabled",true);    /// ���۲�������
		$HUI.combobox("#CstEva").disable();        /// ��������

		$HUI.radio("input[name='CstEvaRFlag']").disable();
		$("#CstEvaRDesc").attr("disabled",true);    /// ��������
		$HUI.combobox("#CstEvaR").disable();        /// ��������
	}else{
		$("#CstEvaRDesc").attr("disabled",($("#CstEvaRDesc").val()==""?true:false));    /// ���۲�������	
		$("#CstEvaDesc").attr("disabled",($("#CstEvaDesc").val()==""?true:false));      /// ���۲�������	
	}
}

/// ��֤�����Ƿ�����ҽ��
function InitPatNotTakOrdMsg(TipFlag){
	
	///seeCstType==1:�鿴ģʽ
	if(seeCstType==1) return "";
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)&&(NoAdmValidDaysLimit!=1)){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCEMConsultCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

///����ʱ������ʾ����  qiaoqingao  2018/08/20
function savesymmodel(){
	
	var patsymtom=$("#arPatSym").val();
	if ((patsymtom=="�������ߣ�")||patsymtom==""){
		$.messager.alert("��ʾ:","û�д��������ݣ�","warning");
		return;
	}
	createsymPointWin();    ///����ʾ����
}

/// ��ʾ����   qiaoqingao  2018/08/20
function createsymPointWin(){
		
	if($('symwin').is(":hidden")){ 
	   $('symwin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	/// ��ѯ����
	var option = {
		collapsible:true,
		minimizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'symwin', '260', '130', option).Init();
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymLoc(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	if(ConsOpinion==""){
		$.messager.alert("��ʾ:","�������ģ�岻��Ϊ�գ�","warning");
		return;	
	}
	var Params=ConsOpinion+"^"+session['LOGON.CTLOCID']+"^"
	
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ:","����ɹ���","info");
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymUser(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	var Params=ConsOpinion+"^^"+session['LOGON.USERID']
	if(ConsOpinion==""){
		$.messager.alert("��ʾ:","�������ģ�岻��Ϊ�գ�","warning");
		return;	
	}
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ:","����ɹ���","info");
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ:","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

///������Ŀ��ģ��    qiaoqingao  2018/08/20
function showmodel(flag){
		
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:$g('ģ���б�'),
		collapsible:true,
		minimizable:false,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcem.consultcottemp.csp"></iframe>';
	$('#winonline').html(cot);
	$('#winonline').window('open');
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

/// �����ӡHTML
function PrintCstHtml(){
	
	if(CstID==""){
		$.messager.alert("��ʾ","��ǰδѡ����Ч����,���ܴ�ӡ��","warning");
		return;
	}
	
	if(CsStatCode==""){ //hxy 2021-01-13
		$.messager.alert("��ʾ","����δ����,���ܴ�ӡ��","warning");
		return;
	}
	
	if(CsStatCode=="ȡ��"){
		$.messager.alert("��ʾ","���뵥�Ѿ�ȡ��,���ܴ�ӡ��","warning");
		return;
	}
	
	if((CsStatCode=="����")||(CsStatCode.indexOf("���")!=-1)||(CsStatCode=="����")||(CsStatCode=="�ܾ�")||(CsStatCode=="����")||(CsStatCode=="ȡ������")||(CsStatCode=="����")||(CsStatCode=="ȡ�����")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("��ʾ","����δ���,���ܴ�ӡ��","warning");
			return;
		}
	}
	
	var cstType=$("#CstType").combobox("getText");
	
	if(CstItmID!=""){
		PrintCstHtmlMethod(CstItmID);
		return;
	}
	
	$m({
		ClassName:"web.DHCEMConsultCom",
		MethodName:"GetCstItmIDs",
		CstID:CstID
	},function(txtData){
		PrintCstHtmlMethod(txtData);
	});
	
	return;
}

function PrintCstHtmlMethod(txtData){
	if(PrintModel==1){
		window.open("dhcem.printconsone.csp?CstItmIDs="+txtData);
		InsCsMasPrintFlag();  /// �޸Ļ����ӡ��־
	}else{
		var prtRet = PrintCstNew(txtData,LgHospID);
		if(prtRet){
			InsCsMasPrintFlag();  /// �޸Ļ����ӡ��־	
		}
	}	
}

/// ��֤�����Ƿ���������
function InitPatNotTakCst(TipFlag){
	
	TakCstMsg = GetPatNotTakCst();
	if ((TakCstMsg != "")&(TipFlag == 1)){
		$.messager.alert("��ʾ:",TakCstMsg,"warning");
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
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	websys_createWindow(lnk, "_blank", "height: " + (top.screen.height - 100) + "px,width: " + (top.screen.width - 100) + "px");
}

/// ����ҽ��¼�봰��
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(2) != 1){
		$.messager.alert("��ʾ:","����Ȩ�޸��ò�����ҽ����","warning");
		return;
	}
	
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm + "&FixedEpisodeID="+EpisodeID+"&CstItmID="+CstItmID;
	websys_showModal({
		url:lnk,
		maximizable:false,
		title:$g('ҽ��¼��'),
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// ��ȡ�鿴����Ȩ��
function GetTakOrdAutFlag(TakType){
	
	var HasFlag = "";
	runClassMethod("web.DHCEMConsult","HasTakOrdAut",{"itmID":CstItmID,"TakType":TakType},function(jsonString){
		HasFlag = jsonString;
	},'',false)

	return HasFlag;
}

/// ҳ�����̰�ť��ʾ����
function InitPageButton(){
	
	runClassMethod("web.DHCEMConsStatus","jsCsStatNode",{"HospID":""},function(jsObject){
		if (jsObject != null){
		}
	},'json',false)
}

/// �޸Ļ�������б�
function InsCsLocItem(){
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
    }
    
	/// �������
	var CsLocArr=[];
	var rowData = $('#dgCstDetList').datagrid('getChanges');
	if (rowData.length == 0){
		$.messager.alert("��ʾ:","û�д��޸����ݣ�","warning");
		return;	
	}
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^^^"+ item.itmID;
		    CsLocArr.push(TmpData);
		}
	})
	
	if (isExistItem() == 1){
		$.messager.alert("��ʾ:","����һ�˶�����¼�����ܱ��棡","warning");
		return;		
	}
	
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// ��������
	if ((CsLocArr.length >= 2)&(CstType.indexOf("����") != "-1")){
		$.messager.alert("��ʾ:","��������Ϊ���ƻ������ѡ�������ң�","warning");
		return;	
	}
	var mListData = CsLocArr.join("@");
	
	runClassMethod("web.DHCEMConsult","InsCsLocItem",{"CstID":CstID, "LgParam":LgParam, "mListData":mListData},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�޸ĳɹ���","info");
			$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������
			if (window.parent.QryConsList != undefined){
				window.parent.QryConsList("R");
			}
		}
	},'',false)
}

/// �ж��Ƿ����ظ���Ŀ
function isExistItem(){
	
	var isExistFlag = 0;
	var LocArr = [],UserArr=[];
	var rowData = $('#dgCstDetList').datagrid('getRows');
	/*
	for(var m=0; m<rowData.length; m++){
		if(trim(rowData[m].LocDesc) != ""){
		    if (LocArr.indexOf(rowData[m].LocID) != -1) {isExistFlag = 1;}
		    LocArr.push(rowData[m].LocID);
		}
	}
	*/
	
	for(var m=0; m<rowData.length; m++){
		if(trim(rowData[m].UserID) != ""){
		    if (UserArr.indexOf(rowData[m].UserID) != -1) {isExistFlag = 1;}
		    UserArr.push(rowData[m].UserID);
		}
	}
	
	return isExistFlag;
}

/// ɾ����������б�
function delCsItem(ItmID){
	
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// ��������
	var rows = $('#dgCstDetList').datagrid('getRows');
	var CsLocArr = [];
	for(var i=0; i<rows.length; i++){
		if (rows[i].LocID != ""){
			CsLocArr.push(rows[i].LocID);
		}
	}
	if ((CsLocArr.length <= 2)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ:","ɾ�����󣬻�������Ϊ��ƻ������Ӧѡ���������������Ͽ��ң�","warning");
		return false;	
	}
	if (CsLocArr.length <= 1){
		$.messager.alert("��ʾ:","ɾ�����󣬻�����Ҳ���Ϊ�գ�������Ҫѡ��һ�����ң�","warning");
		return false;	
	}
	
	var Flag = false;
	runClassMethod("web.DHCEMConsult","delCsItem",{"ItmID":ItmID, "LgUserID":LgUserID},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","ɾ���ɹ���","info");
			Flag = true;
		}
	},'',false)
	return Flag;
}

///����ر�ʱ���δ������ʾ:�������������ȥ��
/*
window.onbeforeunload= function(e) { 
	var isSaveNoSend=false;
	var isSend = $("#bt_send").is(":hidden");  ///�Ƿ񱣴���δ����
	if((CstID!="")&&(!isSend)) isSaveNoSend=true;
	if((isSaveNoSend)&&(seeCstType==2)){
		var e= window.event||e;  
		e.returnValue=("ע��!!���뵥δ����,�����޸Ĳ�����������Ҫȥ���ﴦ�����,ȷ���رս�����");
	}
}
*/

/// ��������
function InitCsPropDiv(){
	
	runClassMethod("web.DHCEMConsultCom","JsonCstProp",{"CstID":CstID,"LgHospID":LgHospID},function(jsonObject){ //hxy 2020-05-29 add LgHospID

		if (jsonObject != null){
			InsCsPropTable(jsonObject);
		}
	},'json',false)
}

/// ��������
function InsCsPropTable(itmArr){
	
	if (itmArr.length == 0){
		$.messager.alert("��ʾ:","��������Ϊ�գ����ڻ���������ά����","warning");
		return;
	}
	var itemhtmlArr = [];
	for (var j=0; j<itmArr.length; j++){
		var EmFlag = itmArr[j].itmDesc.indexOf($g("��")) != -1?"Y":"N";
		itemhtmlArr.push("<input id='"+ itmArr[j].itmID +"' class='hisui-radio' type='radio' label='"+ itmArr[j].itmDesc +"' value='"+ EmFlag +"' name='CstEmFlag'>");
	}
    $("#itemProp").html(itemhtmlArr.join(""));
    $HUI.radio("#itemProp input.hisui-radio",{});
}



function openAppraisePageR(){
	var ID=CstID;
	var Code ="SHR";
	var Mode = "R";
	var Title = $g("����ҽʦ����");
	openAppraisePage(ID,Code,Mode,Title);
}

function openAppraisePageC(){
	var ID=CstItmID;
	var Code ="SHP";
	var Mode = "C";
	var Title = $g("����ҽʦ����");
	openAppraisePage(ID,Code,Mode,Title);
}



///����ҽ����������
function openAppraisePage(ID,Code,Mode,Title){
	var ID=CstItmID;   
	var AppTableCode=Code ;
	var SaveMode=Mode;     ///��ʽ,���ﻹ������   C����ҽʦ���� R����ҽ������
	var AppTableTitle=Title;
	var lnk ="dhcem.consapptable.csp?ID="+ ID +"&AppTableCode="+AppTableCode+"&SaveMode="+SaveMode+"&AppTableTitle="+AppTableTitle;

	websys_showModal({
		url:lnk,
		title:AppTableTitle,
		width:550,
		height:500,
		onClose: function() {
			
		}
	});
	
}


window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
