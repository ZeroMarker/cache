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
var CstEmFlag = "";     /// �������־ hxy 2021-03-31
var TakOrdMsg = "";     /// ��֤�����Ƿ�����ҽ��
var TakCstMsg = "";     /// ��֤ҽ���Ƿ��п�����Ȩ��
var isOpiEditFlag = 0;  /// ��������ǿɱ༭
var isEvaShowFlag = 0;  /// ���������Ƿ���ʾ
var IsPerAccFlag = 0;   /// �Ƿ�����������뵥
var CsStatCode = "";    /// ���뵥��ǰ״̬
var seeCstType="";      /// ģʽ��1(�鿴ģʽ),2(����ģʽ),3(����ģʽ)
var PatType = "";       /// ��������
var IsWFCompFlag="";    /// �������Ƿ�������
var IsMain="";          /// �Ƿ��������Main������� hxy 2021-06-16
var InstanceID="";      /// ����ʵ��ID
var IsAnti="N";
var Risk = "";          /// Σ��ֵ
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
		if(parent.WinName){   /// ��˵��Ļ��ﴦ����˾����赥������
			HidePageButton(4);	  /// ��ʼ�����水ť
		}else{
		HidePageButton(5);	  /// ��ʼ�����水ť
		}
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
		$("textarea").css("border-color","#bbb"); //hxy 2023-02-03
		$("#p-content").css({"left":"20px","padding-right":"20px"});//2023-02-07
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
	IsMain = getParam("IsMain");         /// �Ƿ��������Main������� hxy 2021-06-16
	OpinionAll = getParam("OpinionAll"); /// ����ջ�ʹ�� ������ͼ-ҽ���鿴-�����¼�� ����1ʱ��������۶�ƺϲ���ʾ hxy 2021-07-20
	Risk = getParam("Risk");             /// Σ��ֵ
	ObsId = getParam("obsId");           /// Σ��ֵ
	ObsDate = getParam("obsDate");       /// Σ��ֵ
	if (EpisodeID == ""){
		$("#openemr").hide();
	}
	if (EpisodeID != ""){
		InitPatNotTakOrdMsg(1);    /// ��֤�����Ƿ�����ҽ��
		//InitPatNotTakCst(1);     /// ��֤�����Ƿ��л�������
		PatType = serverCall("web.DHCEMConsultCom", "GetPatType", {EpisodeID:EpisodeID}); //hxy 2021-02-24
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// Ĭ��ƽ����
	//$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	if((PatType=="E")&&(DefETypeCNAT==1)){ //hxy 2021-02-24 st
		$HUI.radio("input[name='CstEmFlag'][value='Y']").setValue(true);
	}else{
		$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	}//ed
	///���ü���ָ��
	var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstType&HospID=" + LgHospID +"&LgUserID="+LgUserID +"&CsRType="+CsRType+"&PatType="+PatType; //hxy 2021-03-02 add +"&PatType="+PatType
	
	/// ��������
	var option = {
		url:unitUrl,
		panelHeight:"auto",
		blurValidValue:true,
        onSelect:function(option){
		    if (option.code.indexOf("DOC03") != "-1"){  /// Ժ�ʻ���
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
	        if(IsMain==1)return;
	        if((seeCstType==2)&&(data.length==0)){ //hxy 2021-12-16 st
		        $.messager.alert("��ʾ","��������Ȩ�ޣ�","warning");
				return;
		    }//ed
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
	        if (option.code.indexOf("OTH") != "-1"){
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
	
	/// �������ڿ��� hxy 2021-03-10
	$('#CstDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			if(seeCstType!=2){	//No send model return true
				return true;
			}
			var now = new Date();
			var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
			return date>=now;
		}
	});
	/// ��������
	$HUI.datebox("#CstDate").setValue(GetCurSystemDate(0));
	/// ����ʱ��
	if(ReqTimeFill==1){ //hxy 2021-02-19
		$HUI.datebox("#CstDate").enable(); //hxy 2021-03-10
		$HUI.timespinner("#CstTime").enable();
	}
	
	/// ���ﵽ�����ڿ��� hxy 2021-04-01
	$('#CstArrDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
			return date<=now;
		}
	});
	
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
			if ((jsonObject.PatSex == "��")||(jsonObject.PatSex == "male")){
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
			if($("#CstAddr").val()==""){//hxy 2022-03-21 st
				if(AuditDefPlace.split(",")[0]==1){
					if(AuditDefPlace.indexOf("1,")>-1){
						$("#CstAddr").val(jsonObject.LocDesc+AuditDefPlace.replace("1,",""));
					}else{
						$("#CstAddr").val(jsonObject.LocDesc);
					}
				}
			}//ed
			
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CsRType2+"&LgHospID="+LgHospID,
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
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'}); //hxy 2021-05-07 st
				var LocID = $(ed.target).val();
				if(LocID!=""){
					var PrvTpID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'DOCTOR',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("��ʾ","��ǰ������ҽ��,��ѡ���������ͣ�");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
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
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'}); //hxy 2021-05-10 st
				var PrvTpID = $(ed.target).val();
				if(PrvTpID!=""){
					var LocID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'DOCTOR',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("��ʾ","��ǰ������ҽ��,��ѡ���������ͣ�");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
				
				GetMarIndDiv("","");  /// �����רҵָ��
			},
			onShowPanel:function(){
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocGrpID'}); //hxy 2021-06-16
				var LocGrpID = $(ed.target).val(); //hxy 2021-06-16
				
				var HospID = $HUI.combobox("#HospArea").getValue(); /// Ժ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+HospID;
				if(LeaderFlag==1){
					var unitUrl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=JsonConsGroupItm&ECRowID="+LocGrpID; //hxy 2021-06-16
					if(LocGrpID==""){
						$.messager.alert("��ʾ","����ѡ���ƣ�");
						return;
					}
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
	
	// ��ƿ��ұ༭��   guoguomin20200908
	var LeaderLocEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocGrp'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocGrpID'});
				$(ed.target).val(option.value);

				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val("");
				
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', "");
				
				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				/// ��רҵID
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val("");
				
				/// ��רҵ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', "");
				
				GetMarIndDiv("","");  /// �����רҵָ��
	
			},
			onShowPanel:function(){
				
				var HospID = $HUI.combobox("#HospArea").getValue(); /// Ժ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocGrp'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultGroup&MethodName=JsonConsGroup&HospID="+LgHospID+"&Type=DOC";
				$(ed.target).combobox('reload',unitUrl);
			}   
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'itmID',title:'itmID',width:100,editor:texteditor,hidden:true},
		{field:'LocGrpID',title:'���ID',width:100,editor:texteditor,align:'left',hidden:true}, //2021-06-10
		{field:'LocGrp',title:'���',width:120,editor:LeaderLocEditor,align:'left'}, //2021-06-10
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'left',hidden:true}, //hxy 2021-05-07 ����ǰ��
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'left'}, //hxy 2021-05-07 ����ǰ��
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'PrvTp',title:'����',width:160,editor:PrvTpEditor,align:'left'}, //hxy 2021-02-20 ְ��->����
		//{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		//{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'center'},
		{field:'MarID',title:'��רҵID',width:100,editor:texteditor,align:'left',hidden:true},
		{field:'MarDesc',title:'��רҵ',width:200,editor:MarEditor,align:'left'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'left',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'left'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor,align:'left'},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetCellUrl}
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
	    onClickRow: function (rowIndex, rowData) { //hxy 2021-03-08 onDblClickRow->onClickRow 
			
			if ((isEditFlag == 1)||((rowData.itmID != "")&&(CsStatCode!=""))) return;
			
			var CstType = $HUI.combobox("#CstType").getValue(); 	          /// ��������
			//if (((CstType.indexOf($g("����")) != "-1")&(rowIndex != 0))||(CstType == ""))return;
			if ((($_CT(CstType).indexOf("DOC01") != "-1")&(rowIndex != 0))||(CstType == ""))return;
			
			
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
            /// �Ƿ����ô�� hxy 2021-06-21
            if (LeaderFlag != 1){
				$("#dgCstDetList").datagrid('hideColumn','LocGrp');
            }
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+CstID;
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){
	var itmID=rowData.itmID;
	if(HISUIStyleCode==="lite"){ //hxy 2023-01-04
		var html = '<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow(\''+ itmID +'\',\''+ rowIndex +'\')"></a>';
	    html +='<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	}else{
		var html = '<a href="javascript:void(0)" onclick="delRow(\''+ itmID +'\',\''+ rowIndex +'\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" border=0/></a>';
	    html += '<a href="javascript:void(0)" onclick="insRow()"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" border=0/></a>';
	}
	return html;
}

/// ɾ����
function delRow(itmID, rowIndex){
	
	if (isEditFlag == 1) return;
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ","����ѡ���У�");
		return;
	}
	
	if (itmID.indexOf("||") != "-1"){
		$.messager.confirm("ɾ��", "��ȷ��Ҫɾ���������������", function (r) {
			if (r) {
				if (delCsItem(itmID,rowIndex)){ //hxy 2021-04-20 add rowIndex
					$("#dgCstDetList").datagrid("reload");  /// ˢ��
					
					if (window.parent.QryConsList != undefined){  ///ˢ������б�
						window.parent.QryConsList("R");
					}
					if(window.parent.QryCons){ //hxy 2021-07-05
						window.parent.QryCons();	
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
	var CstType = $HUI.combobox("#CstType").getValue(); 	
	if (($_CT(CstType).indexOf("DOC01") != "-1")||(CstType == "")) ret=false; // ����
	if (($_CT(CstType).indexOf("DOC03") != "-1")||(CstType == "")) ret=false; // Ժ��
//	if ((CstType.indexOf($g("����")) != "-1")||(CstType == "")) ret=false;
//	if ((CstType.indexOf("Ժ��") != "-1")||(CstType == "")) ret=false;	
	return ret;
}

/// ���Ͳ�������
function SaveCstNo(SendFlag){
    
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#dgCstDetList").datagrid('endEdit', editSelRow); 
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
	
	/*if ((CstID=="")&&(SendFlag=="Send")){
		$.messager.alert("��ʾ","�뱣�����������ٷ��ͣ�","warning");
		return;
	}*/
	
    var CstType = $HUI.combobox("#CstType").getValue();
	if (CstType == "") {
		$.messager.alert("��ʾ","�������Ͳ���Ϊ�գ�","warning");
		return;
	}
	
	var CstTrePro = $("#ConsTrePro").val();     /// ��Ҫ����
	if (CstTrePro.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����ժҪ����Ϊ�գ�","warning");
		return;
	}
	CstTrePro = $_TrsSymbolToTxt(CstTrePro);        /// �����������
	
	var CstPurpose = $("#ConsPurpose").val();  	/// ����Ŀ��
	if (CstPurpose.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","�������ɼ�Ҫ����Ϊ�գ�","warning");
		return;
	}
	CstPurpose = $_TrsSymbolToTxt(CstPurpose);      /// �����������
	if(PrintModel!=1){ //hxy 2021-05-12 xml��ӡʱ�����Ʋ���ժҪ���������ɼ�Ҫ��������
		var CstTreProLen=CstTrePro.split("\n").length;
		var CstPurposeLen=CstPurpose.split("\n").length;
		if((CstTreProLen+CstPurposeLen)>19){
			$.messager.alert("��ʾ","��ǰ����Ϊ��ҳ��ӡ������� ����ժҪ���������ɼ�Ҫ�󣬼���������","warning");
			return;
		}
	}
	
	var CsRUserID = session['LOGON.USERID'];  		/// �������
	var CsRLocID = session['LOGON.CTLOCID'];  		/// ������
	
	var CstEmFlag = $("input[name='CstEmFlag']:checked").val();   /// �Ӽ���ʶ
	if (typeof CstEmFlag == "undefined"){
		CstEmFlag = "N";
	}
	var CsPropID = $("input[name='CstEmFlag']:checked").attr("id"); /// ��������
	if (typeof CsPropID == "undefined"){
		$.messager.alert("��ʾ","�����������ǰ������ѡ��������ʣ�","warning");
		return;
	}
	var CstTypeID = $HUI.combobox("#CstType").getValue(); 	      /// ��������
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	var CstHospID = $HUI.combobox("#CstHosp").getValue(); 	      /// ��Ժ
	var CstUnit = $HUI.combobox("#CstHosp").getText(); 	          /// ��Ժ����
	var CstDate = $HUI.datebox("#CstDate").getValue();     		  /// ��������
	var CstTime = $HUI.timespinner("#CstTime").getValue(); 		  /// ����ʱ��
	
	if ((CstUnit.indexOf("����ҽԺ") != "-1")&($("#CstUnit").val() == "")){ //hxy 2021-05-06
		$.messager.alert("��ʾ","����д��Ժ����","warning");
		return;	
	}
	
	var CstOutFlag = "N";                /// �Ƿ���Ժ
	if ($("#CstUnit").val() != ""){
		CstUnit = $("#CstUnit").val();   /// ��Ժ����
	}
	if (CstUnit != ""){ CstOutFlag = "Y"; }
	
	if ((CstType.indexOf("Ժ��") != "-1")&(CstOutFlag == "N")){
		$.messager.alert("��ʾ","δѡ��Ժ�ʻ���ҽԺ��","warning");
		return;	
	}
	//var CstLoc = $("#CstLoc").val();     /// ��Ժ����
	var CstLoc = $HUI.combobox("#CstLoc").getText(); 	          /// ��Ժ����
	var CstUser = $("#CstUser").val();   /// ��ϵ��
	var CstTele = $("#CstTele").val();   /// ��ϵ�绰
	if (!$("#CstTele").validatebox('isValid')){
		$.messager.alert("��ʾ","��ϵ�绰��֤ʧ�ܣ�������¼�룡","warning");
		return;
	}
	var CstNote = "";  				     /// ��ע
	var CstAddr = $("#CstAddr").val();   /// ����ص�
	var MoreFlag = $_CT(CstTypeID).indexOf("DOC02") != "-1"?"Y":"N";  /// �Ƿ���
	
//	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
//		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag;

	/// �������
	var PrvTpFlag=0; //hxy 2021-02-07 ְ����д��־��0δ��1���
	var LeaderStr=""; //hxy 2021-06-21 ��ƴ�
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocGrp) != ""){ //guoguomin20200909
			LeaderStr=LeaderStr+trim(item.LocGrp); //hxy 2021-06-21
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID+"^"+item.LocGrpID;
		    ConsDetArr.push(TmpData);
		    if(item.PrvTpID=="")PrvTpFlag=1; //
		}else if(trim(item.LocDesc) != ""){
			
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID  ;
		    ConsDetArr.push(TmpData);
		    if(item.PrvTpID=="")PrvTpFlag=1; //
		}
	})
	
	//if((LeaderFlag==1)&&(LeaderStr=="")&&((CstType.indexOf("���") != "-1")||(CstType.indexOf("����") != "-1"))){ //hxy 2021-06-21
	if((LeaderFlag==1)&&(LeaderStr=="")&&(($_CT(CstTypeID).indexOf("DOC02") != "-1")||($_CT(CstTypeID).indexOf("DOC01") != "-1"))){
		$.messager.alert("��ʾ","�������-��Ʋ���Ϊ�գ�","warning");
		return;	
	}
	
	if((IsMustPrvTp==1)&&(PrvTpFlag==1)){
		$.messager.alert("��ʾ","��ѡ�����ͣ�","warning"); //hxy 2021-05-07 ְ��->����
		return;
	}
	
	if(HasRepetDoc){
		$.messager.alert("��ʾ","����ͬһ��Ա������¼����ȷ�ϣ�","warning");
		return;
	}

	//if ((ConsDetArr.length == 1)&(CstType.indexOf("���") != "-1")){
	if ((ConsDetArr.length == 1)&($_CT(CstTypeID).indexOf("DOC02") != "-1")){  /// ���
		if(LeaderFlag==1){
			$.messager.alert("��ʾ","��������Ϊ��ƻ������ѡ���������������ϴ�ƣ�","warning");
		}else{
		$.messager.alert("��ʾ","��������Ϊ��ƻ������ѡ���������������Ͽ��ң�","warning");
		}
		return;	
	}
	//if ((ConsDetArr.length >= 2)&(CstType.indexOf("����") != "-1")){
	if ((ConsDetArr.length >= 2)&($_CT(CstTypeID).indexOf("DOC01") != "-1")){  /// ����
		$.messager.alert("��ʾ","��������Ϊ���ƻ������ѡ�������ң�","warning");
		return;	
	}
	if (ConsDetArr.length >= 2){ MoreFlag = "Y";}  /// ������������2,Ĭ��Ϊ���
	
	var ConsDetList = ConsDetArr.join("@");
	if ((ConsDetList == "")&(CstOutFlag == "N")){
		$.messager.alert("��ʾ","������Ҳ���Ϊ�գ�","warning");
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
	var otherParams = ObsId+"^"+ObsDate
	
	/// ����
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData,"OtherParams":otherParams,"LgParams":LgParam},function(jsonString){
		if (jsonString < 0){
			if(jsonString==-20){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڵ�ǰʱ�䣡","warning");
				return;
			}else{
			$.messager.alert("��ʾ","�������뱣��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}
		}else{
			CstID = jsonString;
			if(SendFlag=="Send"){ //hxy 2021-04-12
				SendCstNo();
			}else{ //ed
				if(SendFlag=="delete"){ //hxy 2021-04-20 st
					$.messager.alert("��ʾ","ɾ���ɹ���","info");
				}else{ //ed
				$.messager.alert("��ʾ","����ɹ���","info");
					if (window.parent.QryConsList != undefined){  ///ˢ������б� hxy 2021-05-10
						window.parent.QryConsList("R");
					}
					if(window.parent.QryCons){ //hxy 2021-06-15
						window.parent.QryCons();	
					}
				}
				$(".tip").text("("+$g("�ѱ���")+")");
				$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������
			}

		}
	},'',false)
}
/*
/// ����
function SendCstNo(){

	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "UserID":session['LOGON.USERID']},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�ѷ��ͣ������ٴη��ͣ�");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString);
		}else{
			$.messager.alert("��ʾ","���ͳɹ���");
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
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	$("#newWinFrame").attr("src",link);
}


/// ���ػ�����������Ϣ����
function GetCstNoObj(){
	
	if(CstItmID==""){
		CstID==""?"":CstItmID=CstID+"||1";	
	}
	/*var CstItmIDNew=CstItmID; //hxy 2021-01-26 st //2021-03-09 st
	if((MulWriFlag==0)&&(CstMorFlag=="Y")&&(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))){
		CstItmIDNew=CstID;
	}*/
	var Param="";
	//if((MulWriFlag==0)&&(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))){ //hxy 2021-03-15 st
	if((MulWriFlag!=1)&&(parent.$("#QReqBtn").hasClass("btn-blue-select"))){ //ed
		Param="Y";
	}
	if(OpinionAll=="1"){Param="Y";} // hxy 2021-07-20 ����ջ�ʹ��
	Param=Param+"^"+IsMain; //2021-06-16 ���ڻ���������棬��Ժ�ʡ�������������ʱ���ν���
	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID,"Param":Param},function(jsonString){ //ed //ed

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���û������뵥����
function InsCstNoObj(itemobj){
	if(itemobj.CstTrePro==undefined)return;
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
	
	CstEmFlag = itemobj.CstEmFlag;          /// �������־ hxy 2021-03-31      
	CstMorFlag = itemobj.CstMorFlag; 		/// ��ƻ����־
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	IsWFCompFlag=itemobj.IsWFCompFlag;      /// �������Ƿ��Ѿ������
	InstanceID = itemobj.InstanceID;        /// ����ʵ��ID
	var IsNeedHideType=(((MulWriFlag!=1)&&(CstMorFlag=="Y"))||(CstMorFlag!="Y"))&&(parent.$("#QReqBtn").hasClass("btn-blue-select")); //hxy 2021-03-19 ((MulWriFlag==0)&& -> ((MulWriFlag!=1)&&
	var IsNoComp=(CsStatCode=="����")||(CsStatCode=="����")||(CsStatCode=="ȡ������")||(CsStatCode=="ȡ�����")||(CsStatCode.indexOf("���")!=-1);
	if(IsNeedHideType&IsNoComp&(NoCompHideOpin!=1)&(itemobj.CstOutFlag!="Y")){
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
			$("#CstUnit").val(""); //hxy 2021-05-06 Ժ���л���ʾ����ȷ
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
	$HUI.datebox("#CstArrDate").setValue(itemobj.ArrDate);      /// �������� hxy 2021-03-31
	$HUI.timespinner("#CstArrTime").setValue(itemobj.ArrTime);  /// ����ʱ�� hxy 2021-03-31
	
	
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
		if(ReqTimeFill==1){ //hxy 2021-02-19
			$HUI.timespinner("#CstTime").enable();
			$HUI.datebox("#CstDate").enable(); //hxy 2021-03-10
		}
		
		if (itemobj.CstType == "Ժ�ʻ���"){ //2021-05-10 st
	    	$HUI.combobox("#CstLoc").enable();
	    	$HUI.combobox("#CstHosp").enable();
	    }else{
	    	$HUI.combobox("#CstHosp").disable();
	    	$HUI.combobox("#CstLoc").disable();
	    	$("#CstUnit").val("").attr("disabled", true);
		} //ed
		$("#CstAddr").attr("disabled", false); //hxy 2022-03-21
	}else{
		$(".tip").text("");
		$HUI.timespinner("#CstTime").disable(); //hxy 2021-02-19
		$HUI.datebox("#CstDate").disable(); //hxy 2021-03-10
		$("#CstAddr").attr("disabled", true); //hxy 2022-03-21
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
			$("#CstEvaDesc").val(""); /// ��������-����-���۲������� hxy 2022-10-19
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
	
	//ArrTimeDisOrEnByBtn(); //hxy 2021-04-02���ﰴť������ʱ����������ʱ�䲻�ɱ༭
}

/// ����
function SendCstNo(){
		
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
	
	//isTakeDigSignNew(SendCstNoFun,"CONSend");
	isTakeDigSignNew({"callback":SendCstNoFun,"modelCode":"CONSend","isHeaderMenuOpen":false});
	return;
}

/// ���� Fun
function SendCstNoFun(){
	///��֤CAǩ��
	//if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam ,"Risk":Risk},function(jsonString){
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�ѷ��ͣ������ٴη��ͣ�","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","��������������Ҫ�������ҽ��������ҽ��δ���ã�","warning");
			return;
		}
		if (jsonString == -12){
			$.messager.alert("��ʾ","ҽ������ʧ�ܣ�����ֵ:"+errMsg,"warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			CstID = jsonString;
			CsStatCode="����";
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ","���ͳɹ���","info",function(){
				
				GetCstNoObj();
				$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������
				
				///���ͳɹ��������������Ҫ�Զ���Ȩ���Ӳ����鿴
				if(DefOpenAcc==1){
					InsEmrAutMasAll(1);
				}
				///���ͳɹ��������������Ҫ�Զ���Ȩҽ�� hxy 2021-01-18
				if(DefOpenAccOrd==1){
					InsEmrAutMasAll(2);
				}
				///���ͳɹ�������������Զ���ӡ & ����δ��ɿ��Դ�ӡ�����¼�� hxy 2021-02-09
				if((SendAutoPri==1)&&(ConsNoCompCanPrt!=1)){
					PrintCstHtml();
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
			
			if(window.parent.QryCons){ //hxy 2021-06-15
				window.parent.QryCons();	
			}
		}
	},'',false)
}

function InsEmrAutMasAll(Flag,LastChild){
	if(LastChild==undefined){LastChild="";} //hxy 2021-07-05
	if(Flag==2){
		var Hour=Number(DefOpenAccOrdHour);
	}else{
		var Hour=Number(DefOpenAccHour); //hxy 2021-01-15 st
		var GetHours=serverCall("web.DHCEMConsult", "GetHours", {CstID:CstID}); //hxy 2021-03-02 st ������Ȩ�����������������ڲ�Ʒ��������Сʱ��
		if(GetHours!="")Hour=GetHours; //ed
	}
	if((Hour==0)||(Hour==NaN)){
		Hour=72;
	} //ed
	var params = EpisodeID+"^"+CstID+"^"+LgUserID+"^"+Hour+"^"+Flag;
	var FlagDesc="����";
	if(Flag==2)FlagDesc="ҽ��";
	runClassMethod("web.DHCEMConsult","InsEmrAutMasAll",{"Params":params,"LastChild":LastChild},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ","�Զ�����"+FlagDesc+"��Ȩ"+Hour+"Сʱ�鿴Ȩ�ޣ�","warning");
			return;
		}
		
		if (jsonString == -2){
			$.messager.alert("��ʾ","������Ȩʧ�ܣ�ʧ��ԭ��:��ǰ���˴˴ξ���û�в��������ʵ��������Ȩ���ֶ���Ȩ��","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("��ʾ","�Զ�������Ȩʧ�ܣ�������Ȩ���ֶ���Ȩ��ʧ��ԭ��:"+jsonString,"warning");
			return;
		}
		
	},'',false)	
}


///���ͺ�ȡ��CAǩ������
function ConsInsDigitalSign(CstID,ConsType,Type){
	if(!IsCA) return; //if(CAInit!=1) return;
	runClassMethod("web.DHCEMConsultQuery","GetConsOrds",{"CstID":CstID, "ConsType":ConsType},function(ordItms){
		if(ordItms!=""){
			////OrdCaByDoc:��ʾ��ҽ��վ�ķ���
			InsDigitalSignNew(ordItms,LgUserID,Type,"OrdCaByDoc","");	
		}
	},'text',false)
}

function RemoveCstNo(){
	if (CstID == ""){
		$.messager.alert("��ʾ","����ѡ��������룬�ٽ��д˲�����","warning");
		return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫɾ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","RemoveCstNo",{"CstID":CstID},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ��������","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("��ʾ","��������ɾ��ʧ�ܣ�ʧ��ԭ��:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ���","info",function(){
						window.location.reload();
					});
					if(window.parent.reLoadMainPanel){
						window.parent.reLoadMainPanel("");	
					}
					if(window.parent.QryCons){ //hxy 2021-06-15
						window.parent.QryCons();
						window.parent.LoadConFrame();
					}
				}
			},'json',false)
		}
	});
}

/// ȡ��
function CanCstNo(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","����ѡ��������룬�ٽ��д˲�����","warning");
		return;
	}
	
	IsInsOrd = serverCall("web.DHCEMConsult", "SendIsInsOrd", {CstID:CstID,HospID:LgHospID,Type:"R"}); //hxy 2021-06-15
	/// ��֤�����Ƿ�����ҽ��
	if ((IsInsOrd=="1")&&(TakOrdMsg != "")){ //if (TakOrdMsg != ""){
		$.messager.alert("��ʾ",TakOrdMsg.replace("�ٿ�����","ȡ��"),"warning");
		return;	
	}
	
	//isTakeDigSignNew(CanCstNoFun,"CONCancelSend");
	isTakeDigSignNew({"callback":CanCstNoFun,"modelCode":"CONCancelSend","isHeaderMenuOpen":false});
}
/// ȡ�� Fun
function CanCstNoFun(){	
	///��֤CAǩ��
	//if (!isTakeDigSign()) return;
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫȡ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","InvCanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID'],"LgParam":LgParam},function(jsonObject){ //hxy 2022-12-23 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)

				if (jsonObject.ErrCode == -1){
					$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ��������","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("��ʾ","��������ȡ��ʧ�ܣ�ʧ��ԭ��:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("��ʾ","ȡ���ɹ���","info",function(){
						if(seeCstType==2){
							window.location.reload();	///�����������ȡ�������ʱ��ˢ�½���					
						}	
					});
					ConsInsDigitalSign(CstID,"R","S");
					//GetCstNoObj();  	          /// ���ػ������� //hxy 2020-03-02 st
					//isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
					//window.parent.reLoadMainPanel(CstItmID);  
					window.location.reload(); 
					if(window.parent.QryCons){ //hxy 2021-06-15
						window.parent.QryCons();
						window.parent.LoadConFrame();
					}
					if(window.parent.reLoadMainPanel){
					window.parent.reLoadMainPanel(""); //ed
					}
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
	
	runClassMethod("web.DHCEMConsult","SureCstMas",{"CstID": CstID, "ItmID":ItmID, "UserID":session['LOGON.USERID'],"LgParam":LgParam},function(jsonString){ //hxy 2022-12-27 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		
		/*if (jsonString == -1){ //hxy 2020-05-08 st
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȷ�ϲ�����","warning");
			return;
		}*/
		if (jsonString.split("^")[0] == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȷ�ϲ���"+jsonString.split("^")[1]+"!","warning");
			return;
		}//ed
		if (jsonString == -2){
			$.messager.alert("��ʾ","�����ҽʦ�������ۺ���ȷ��!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","ȷ�ϳɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)
}

/// ȡ��ȷ��
function CanSureCstNo(){
	runClassMethod("web.DHCEMConsult","CanSureCstMas",{"CstID": CstID, "UserID":session['LOGON.USERID'],"LgParam":LgParam},function(jsonString){  //hxy 2022-12-28 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		if (jsonString == -1){
			$.messager.alert("��ʾ","��ǰ״̬���������ȡ��ȷ�ϲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ȡ��ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ��ȷ�ϳɹ���","info");
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
			$.messager.alert("��ʾ","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","���ճɹ���","info");
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
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("��ʾ","�����ѱ����أ����ܽ��գ�","warning");
			return;
		}
		if (jsonString == -4){
			$.messager.alert("��ʾ","ְ�����ƣ���������н��ղ���!","warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("��ʾ","Ժ�ʻ�����δ���,��������н��ղ���!","warning");
			return;
		}
		if (jsonString == -100009){
			$.messager.alert("��ʾ","����ҽ��δ��ˣ����ܽ���!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","���ճɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			//window.parent.UpdMainPanel(CstItmID,$g("����"));
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���������ж�
function RevAccCstNoJudg(){
	$("#reasonInput").val("");
	if(RevAccReason==1){
		var lnk = "dhcem.consultnote.csp";
		websys_showModal({
			url: lnk,
			width:400,
			height:150,
			iconCls:"icon-w-paper",
			title: 'ԭ��',
			closed: true,
			onClose:function(){
				var reasonVal=$("#reasonInput").val();
				if(reasonVal!="")RevAccCstNo(reasonVal);
			}
		});
	}else{
		RevAccCstNo("");
	}
}

/// ��������
function RevAccCstNo(reason){
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"AcceptCstMas":"AcceptCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }

	runClassMethod("web.DHCEMConsult","RevAccCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID'],"Reason":reason,"LgParam":LgParam},function(jsonString){ //hxy 2022-12-23 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�ǽ���״̬�����������ȡ�����ղ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ���ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
			//window.parent.UpdMainPanel(CstItmID,$g("ȡ������"));
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

/// �ܾ��ж�
function RefCstNoJudg(){
	$("#reasonInput").val("");
	if(RefReason==1){
		var lnk = "dhcem.consultnote.csp";
		websys_showModal({
			url: lnk,
			width:400,
			height:150,
			iconCls:"icon-w-paper",
			title: 'ԭ��',
			closed: true,
			onClose:function(){
				var reasonVal=$("#reasonInput").val();
				if(reasonVal!="")RefCstNo(reasonVal);
			}
		});
	}else{
		RefCstNo("");
	}
}

/// �ܾ�
function RefCstNo(reason){
	
	runClassMethod("web.DHCEMConsult","RefCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'],"Reason":reason,"LgParam":LgParam},function(jsonString){ //hxy 2022-12-26 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ����״̬����������оܾ�������","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","���뵥�Ѿ���ˣ���������оܾ�������","warning");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("��ʾ","��ƻ��ﲻ����ܾ���","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","�ܾ��ɹ���","info");
			GetCstNoObj();  	         /// ���ػ�������
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ����
function AriCstNo(){
	if ((CstMorFlag == "Y")&&(parent.$("#QReqBtn").hasClass("btn-blue-select"))){ //���+�ɻ���ҽ����д���,������ʱ
		var lnk ="dhcem.consultarr.csp?CstID="+ CstID +"&LgParam="+LgParam+"&ModArrTime="+ModArrTime;
		websys_showModal({
			url:lnk,
			title:"��������ʱ��",
			iconCls:"icon-w-paper",
			width:520,
			height:320,
			onClose: function() {
				GetCstNoObj();
				isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
				window.parent.reLoadMainPanel(CstItmID);
			}
		});
		return;
	}else{
		/// ��ƻ�����д��ʶ //hxy 2021-03-30 st
		/*var ItmID = "";
		if ((CstMorFlag == "Y")&&((MulWriFlag == 1)||(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")))){ ItmID = ""; } //��Ƹ�������������б���ͬʱ���������Ҫ�ֿ����Ե�
		else{ ItmID = CstItmID; }*/
		var ArrDate = $HUI.datebox("#CstArrDate").getValue();
		var ArrTime = $HUI.timespinner("#CstArrTime").getValue(); 
		runClassMethod("web.DHCEMConsult","AriCstNo",{"CstID": CstID, "ItmID": CstItmID, "LgParam":LgParam,"ArrDate":ArrDate,"ArrTime":ArrTime},function(jsonString){
			if (jsonString == -1){
				$.messager.alert("��ʾ","���뵥��ǰ״̬����������е��������","warning");
				return;
			}
			if (jsonString == -2){
				$.messager.alert("��ʾ","����ʱ�䲻�ܴ��ڵ�ǰʱ�䣡","warning");
				return;
			}
			if (jsonString == -3){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڷ���ʱ�䣡","warning");
				return;
			}
			if (jsonString == -4){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ�������ʱ�䣡","warning");
				return;
			}
			if (jsonString == -5){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڽ���ʱ�䣡","warning");
				return;
			}
			if (jsonString < 0){
				$.messager.alert("��ʾ","�������뵽��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}else{
				$.messager.alert("��ʾ","����ɹ���","info");
				GetCstNoObj();
				isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
				window.parent.reLoadMainPanel(CstItmID);
			}
		},'',false)	
	}
}

/// ȡ������
function CanAriCstNo(){
	if ((CstMorFlag == "Y")&&(parent.$("#QReqBtn").hasClass("btn-blue-select"))){ //���+�ɻ���ҽ����д���,������ʱ
		var lnk ="dhcem.consultarr.csp?CstID="+ CstID +"&LgParam="+LgParam+"&ModArrTime="+ModArrTime+"&CanAriFlag=1";
		websys_showModal({
			url:lnk,
			title:"��������ʱ��",
			iconCls:"icon-w-paper",
			width:520,
			height:320,
			onClose: function() {
				GetCstNoObj();
				isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
				window.parent.reLoadMainPanel(CstItmID);
			}
		});
		return;
	}else{
		var ArrDate = $HUI.datebox("#CstArrDate").getValue();
		if(ArrDate==""){
			$.messager.alert("��ʾ","�޵���ʱ�䣬����ȡ�����","warning");
			return;
		}
		runClassMethod("web.DHCEMConsult","CanAriCstNo",{"CstID": CstID, "ItmID": CstItmID, "LgParam":LgParam},function(jsonString){
			if (jsonString == -1){
				$.messager.alert("��ʾ","�Ǳ����õ����������иò�����","warning");
				return;
			}
			if (jsonString < 0){
				$.messager.alert("��ʾ","ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}else{
				$.messager.alert("��ʾ","ȡ������ɹ���","info");
				GetCstNoObj();
				isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
				window.parent.reLoadMainPanel(CstItmID);
			}
		},'',false)	
	}
	
}

/// �������
function SaveCstOpi(){
	
	if (CsUserID != session['LOGON.USERID']){
		$.messager.alert("��ʾ","���ǵ�ǰ������Ա�����ܽ��д˲�����","warning");
		return;
	}
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����д������ۣ�","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	runClassMethod("web.DHCEMConsult","SaveCstOpi",{"ItmID": CstItmID, "UserID":session['LOGON.USERID'], "CstOpinion":ConsOpinion},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�","warning");
		}else{
			$.messager.alert("��ʾ","����ɹ���","info");
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// Ԥ���
function PreCompCstNo(){
	var ConsOpinion = $("#ConsOpinion").val();
	
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	if (ConsOpinion==""){
		$.messager.alert("��ʾ","����д������ۣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCEMConsult","PreCompCstMas",{"CstID":CstID,"ItmID": CstItmID,"CstOpinion":ConsOpinion,"LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������Ԥ���(�ݴ�������)������","warning");
			return;
		}
		
		if (jsonString == -300){
			$.messager.alert("��ʾ","Ժ�ʻ�����δ���,���������Ԥ���(�ݴ�������)����!","warning");
			return;
		}
		
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������Ԥ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","Ԥ���(�ݴ�������)�ɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���
function CompCstNo(){
	var IsUserAcc= ConsUseStatusCode.indexOf("^30^");   ///�Ƿ������˱���״̬
	
	if ((IsUserAcc!=-1)&(GetIsOperFlag("30") != "1")&(GetIsOperFlag("51") != "1")&(GetIsOperFlag("40") != "1")){ //hxy 2021-03-30 add 40
		$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
		return;
	}
	if ((IsUserAcc==-1)&(GetIsOperFlag("20") != "1")&(GetIsOperFlag("21") != "1")&(GetIsOperFlag("51") != "1")&(GetIsOperFlag("40") != "1")){ //hxy 2021-03-30 add 40
		$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
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
		$.messager.alert("��ʾ","����д������ۣ�","warning");
		return;
	}
	
	//isTakeDigSignNew(CompCstNoFun,"CONComp");
	isTakeDigSignNew({"callback":CompCstNoFun,"modelCode":"CONComp","isHeaderMenuOpen":false});
	return;
}

/// ���Fun
function CompCstNoFun(){
	//alert("CompCstNoFun")
	var AntiOpinion = $("input[name='AntiRadio']:checked").val(); ///�Ƿ�ͬ��ʹ�ÿ�����ҩ��
	var ConsOpinion = $("#ConsOpinion").val();
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
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
	//if (!isTakeDigSign()) return;
	runClassMethod("web.DHCEMConsult","CompCstMas",ParObj,function(jsonString){
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�������������ɲ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString == -200){
			$.messager.alert("��ʾ","�������������Ҫ�������ҽ��������ҽ��δ���ã�","warning");
			return;
		}
		if (jsonString == -13){
			$.messager.alert("��ʾ","ҽ������ʧ�ܣ�����ֵ��"+errMsg,"warning");
			return;
		}
		if (jsonString == -300){
			$.messager.alert("��ʾ","Ժ�ʻ�����δ���,�����������ɲ���!","warning");
			return;
		}
		if (jsonString==-101){
			$.messager.alert("��ʾ","���ʱ�䲻�����ڷ���ʱ�䣡","warning");
			return;	
		}
		if (jsonString==-102){
			$.messager.alert("��ʾ","���ʱ����ڵ�ǰʱ�䣡","warning");
			return;	
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
			return;
		}else{
			$.messager.alert("��ʾ","��ɳɹ���","info");
			ConsInsDigitalSign(CstID,"C","A");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// �������
function RevCompCstNo(){
	//isTakeDigSignNew(RevCompCstNoFun,"CONCancelComp");
	isTakeDigSignNew({"callback":RevCompCstNoFun,"modelCode":"CONCancelComp","isHeaderMenuOpen":false});
	return;
}

/// ������� Fun
function RevCompCstNoFun(){	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	
	///��֤CAǩ��
	//if (!isTakeDigSign()) return;
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID'],"LgParam":LgParam},function(jsonString){ //hxy 2022-12-26 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];	
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬��������ȡ����ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-2){
				$.messager.alert("��ʾ","������ҩƷ�Ѿ�ʹ�ã�����������","warning");
				return;	
			}
			$.messager.alert("��ʾ","��������ȡ�����ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ���ɹ���","info");
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
		$.messager.alert("��ʾ","���ǵ�ǰ������Ա�����ܽ��д˲�����","warning");
		return;
	}
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion == ""){
		$.messager.alert("��ʾ","����д������ۣ�","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	runClassMethod("web.DHCEMConsult","CompCstNo",{"ItmID": CstItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion, "Params":Params},function(jsonString){
		
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
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)	
}

/// ���������
function EvaRCstNo(){
	
	var IsUserSure= ConsUseStatusCode.indexOf("^60^");   ///�Ƿ������˱���״̬
	
	if ((IsUserSure!=-1)&(GetIsOperFlag("60") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("��ʾ","���뵥��ǰ״̬��������������۲�����","warning");
		return;
	}
	if ((IsUserSure==-1)&(GetIsOperFlag("50") != "1")&(GetIsOperFlag("55") != "1")&(GetIsOperFlag("79") != "1")){ //hxy 2021-01-08 add 79
		$.messager.alert("��ʾ","���뵥��ǰ״̬��������������۲�����","warning");
		return;
	}
	var CstEvaRFlag = $("input[name='CstEvaRFlag']:checked").val();   /// ������������ȱ�ʶ
	if (typeof CstEvaRFlag == "undefined"){
		$.messager.alert("��ʾ","����ѡ����������ȣ�","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEvaR").getValue(); 	      /// ��������
	var CstEvaDesc = $HUI.combobox("#CstEvaR").getText(); 	      /// ��������
	if (CstEvaDesc == ""){
		$.messager.alert("��ʾ","��ѡ���������ݣ�","warning");
		return;
	}

	if (CstEvaDesc.indexOf($g("����")) != "-1"){
		var CstEvaDesc = $("#CstEvaRDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("��ʾ","������д���۲������ݣ�","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// �����������
	
	var CsEvaParam = CstEvaRFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaRCstNo",{"CstID": CstID, "LgParam":LgParam, "CsEvaParam":CsEvaParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬��������������۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","������������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ","���۳ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ���������-ȡ������
function CanEvaRCstNo(){
	if(GetIsOperFlag("70") != "1"){
		$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
		return;
	}
		
	runClassMethod("web.DHCEMConsult","CanEvaRCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ","ȡ�����۳ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ��������
function EvaCstNo(){
	
	if ((GetIsOperFlag("50") != "1")&(GetIsOperFlag("61") != "1")){
		$.messager.alert("��ʾ","���뵥��ǰ״̬��������������۲�����","warning","warning");
		return;
	}
	var CstEvaFlag = $("input[name='CstEvaFlag']:checked").val();   /// ������������ȱ�ʶ
	if (typeof CstEvaFlag == "undefined"){
		$.messager.alert("��ʾ","����ѡ����������ȣ�","warning");
		return;
	}
	
	var CstEvaID = $HUI.combobox("#CstEva").getValue(); 	      /// ��������
	var CstEvaDesc = $HUI.combobox("#CstEva").getText(); 	      /// ��������
	if (CstEvaDesc == ""){
		$.messager.alert("��ʾ","��ѡ���������ݣ�","warning");
		return;
	}
	
	if (CstEvaDesc.indexOf($g("����")) != "-1"){
		CstEvaDesc = $("#CstEvaDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("��ʾ","������д���۲������ݣ�","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// �����������
	
	var CsEvaParam = CstEvaFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID, "CsEvaParam":CsEvaParam,"LgParam":LgParam},function(jsonString){ //hxy 2022-12-23 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬��������������۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","������������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ","���۳ɹ���","info");
      		GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}


/// ��������-ȡ����������
function CanEvaCstNo(){

	runClassMethod("web.DHCEMConsult","CanEvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID,"LgParam":LgParam},function(jsonString){ //hxy 2022-12-23 add LgParam(Ϊ�˵���ƽ̨�ӿ�ʱ���벿��)
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ�����۲�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ","ȡ�����۳ɹ���","info");
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
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link,"_blank","height=600, width=1100, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

/// ��ӡ
function PrintCst(){
	
	if (CstID == ""){
		$.messager.alert("��ʾ","�뷢�ͻ���������ٴ�ӡ��","warning");
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
			$.messager.alert("��ʾ","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
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
		$.messager.alert("��ʾ","�뱣�������ٿ�����Ȩ��","warning");
		return;
	}

	var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;

	websys_showModal({
		url:lnk,
		title:'��Ȩ',
		iconCls:'icon-w-paper', //hxy 2023-02-08
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
			$.messager.alert("��ʾ",jsonString,"warning");
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
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11
		Link += "&MWToken="+websys_getMWToken()
	}
	typeof window.parent.commonShowWin == "function"?OpenWinObj=window.parent:OpenWinObj=window;
	
	OpenWinObj.commonShowWin({
		url: Link,
		title: $g("����"),
		width: 1190,//1280
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
	var Param="C"; /// �����б�����//hxy 2021-03-12 st ����ԭ�򣺿���ҩ�����뱾���ң�����ͨ������id���������뻹�ǻ���
	if(parent.$("#QReqBtn").hasClass("btn-blue-select")){
		Param="R";
	}
	runClassMethod("web.DHCEMConsultQuery","GetCstPageBtFlag",{"CstID":CstID, "LgUserID":session['LOGON.USERID'], "LgLocID":session['LOGON.CTLOCID'], "LgHospID":session["LOGON.HOSPID"],"Param":Param},function(jsonString){ //hxy 2021-03-11 LgHospID //ed

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
	
	DisAndEnabBtn(BTFlag);      ///ͨ��״̬���ð�ť�Ƿ�ȥ //hxy 2021-04-19 add BTFlag
	
	HideOrShowBySet();          ///����������ʾ����
	
	HideByConsType();           ///���ƶ�Ƶ�����
	
	HideOrShowByProp();         ///������ƽ�������� hxy 2021-03-31
	
	DisAndEnabBtnByConfig();    ///���ﰴť�Ƿ���ð����� hxy 2022-10-28
	
	ArrTimeDisOrEnByBtn();      ///���ﰴť������ʱ����������ʱ�䲻�ɱ༭ hxy 2021-04-02

}

function HideOrShowByProp(){
	if((ArrJustForE==1)&&(CstEmFlag!="Y")){
		$("#bt_arr").hide();	 ///����
		$("#bt_revarr").hide();  ///ȡ������ 2023-02-01
	}
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
		$("#bt_revarr").hide();/// ȡ������ //hxy 2023-02-01
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
		$("#bt_Surg").hide();   /// ��������
		$("#bt_patsee").hide();  /// ������
		$("#bt_patemr").hide(); /// �鿴����
		$("#bt_saveloc").hide(); /// �������
		$("#bt_can").hide();
		$("#ConsEvaR").hide(); /// ��������� //hxy 2021-04-09
		PageEditFlag(1);	    /// ҳ��༭
		isEditFlag = 0;	        /// �б༭��־
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// �����  �����ѷ���
	if (BTFlag == 2){
		$("#bt_emrwin").show(); ///���� //hxy 2021-05-20
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").show();   /// ���� //hxy 2021-03-31 hide->show
		$("#bt_revarr").show();/// ȡ������ 2023-02-01
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
		$("#bt_Surg").hide();      /// ��������
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
	
	/// �����  �����ѷ���  ͬ�Ʋ�ͬ������ //hxy 2021-03-10
	if (BTFlag == 20){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide();/// ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_revarr").hide();/// ȡ������ 2023-02-01
		$("#bt_com").hide();   /// ���
		$("#bt_precom").hide();/// �ݴ�
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide();   /// ȡ���������� 
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_order").hide();     /// ҽ��¼��
		$("#bt_Surg").hide();      /// ��������
		$("#bt_patsee").hide();    /// ������
		$("#bt_patemr").hide();    /// �鿴����
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_can").show();   /// ȡ��
		if(seeCstType!=2){
			$("#Opinion").show();  /// �������
			$("#ConsEvaR").show(); /// ���������
		}
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").hide();  /// ����
		$("#QueEmr3").hide();  /// ���� 
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_reva").hide();  /// ����
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_revsure").hide(); /// ȡ��ȷ��
		$("#bt_revreva").hide(); /// ȡ������
		$("#bt_saveloc").hide(); /// �������
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
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
		$("#bt_revarr").show();/// ȡ������ 2023-02-01
		$("#bt_com").show();   /// ���
		$("#bt_revcom").show();/// ȡ�����
		$("#bt_precom").show();
		$("#bt_ceva").show();  /// ����
		$("#bt_revceva").show(); /// ȡ���������� //hxy 2021-01-09
		$("#bt_order").show();   /// ҽ��¼��
		$("#bt_Surg").show();    /// ��������
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
	/// ������ʾ  ͬ�Ʋ�ͬ�˻��� //hxy 2022-05-27
	if (BTFlag == 30){
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
		
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_revacc").show();/// ȡ������
		$("#bt_arr").hide();   /// ����
		$("#bt_revarr").hide();/// ȡ������ 2023-02-01
		$("#bt_com").hide();   /// ���
		$("#bt_revcom").show();/// ȡ�����
		$("#bt_precom").hide();
		$("#bt_ceva").hide();  /// ����
		$("#bt_revceva").hide(); /// ȡ���������� //hxy 2021-01-09
		$("#bt_order").hide();   /// ҽ��¼��
		$("#bt_Surg").hide();    /// ��������
		$("#bt_patsee").hide();  /// ������
		$("#bt_patemr").hide(); /// �鿴����
		$("#Opinion").hide();   /// �������
		$("#QueEmr").hide();    /// ����
		$("#QueEmr2").hide ();  /// ����
		$("#QueEmr3").hide();   /// ���� hxy 2021-01-12
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_TempSave").hide();  /// ����ģ��
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_log").hide();       /// ������־
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
		$("#bt_revarr").hide();/// ȡ������ 2023-02-01
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
		$("#bt_Surg").hide();  /// ��������
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
		$("#bt_revarr").hide();/// ȡ������ 2023-02-01
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
		$("#bt_Surg").hide();  /// ��������
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
		$("#bt_revcom").show();  /// ȡ����� //hxy 2021-01-21
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
			$("#bt_arr").show();    /// ���� hxy 2021-03-30
			$("#bt_revarr").show();/// ȡ������ 2023-02-01
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
		$("#bt_arr").hide();   /// ���� hxy 2021-03-31
		$("#bt_revarr").hide();/// ȡ������ 2023-02-01
	}
	
	if (BTFlag == 4){
		//$HUI.combobox("#HospArea").enable(); 	  /// Ժ��
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
			//$("#bt_precom").show(); ///Ԥ��� //hxy 2021-03-11ע�� �����б�-ͬ�Ʋ�ͬ�˲鿴�����ݴ水ť(�ѷ��ͻ��ò����ã�δ���͵İ�ť����)
		}
	}
	
	
	/// �����ӱ�IDΪ��ʱ������ʾ������־��ť
	if (CstItmID == ""){
		$("#bt_log").hide();   /// ������־
	}
	/// IsMainʱ������ʾ������־��ť 2021-06-16 ԭ����������治��ʾ������һ�£�����ʾ���ܹرգ����С���
	if (IsMain == "1"){
		$("#bt_log").hide();   /// ������־
	}
}

function DisAndEnabBtn(BTFlag){
	
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
	$HUI.linkbutton("#bt_Surg").enable();     //hxy 2022-08-25
	$HUI.linkbutton("#bt_print").enable();
	$HUI.linkbutton("#bt_patemr").enable();
	$HUI.linkbutton("#bt_patsee").enable();
	$HUI.linkbutton("#bt_revsure").disable(); //hxy 2021-01-07
	$HUI.linkbutton("#bt_revreva").disable(); //hxy 2021-01-08
	$HUI.linkbutton("#bt_revceva").disable(); //hxy 2021-01-09
	$HUI.linkbutton("#bt_arr").enable();      //hxy 2021-03-30
	$HUI.linkbutton("#bt_revarr").enable();   //hxy 2023-02-01
	
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
		$HUI.linkbutton("#bt_Surg").disable();
		$HUI.linkbutton("#bt_print").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
		$HUI.linkbutton("#bt_revarr").disable(); //hxy 2023-02-01
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
		$HUI.linkbutton("#bt_Surg").disable();
		$HUI.linkbutton("#bt_patemr").disable();
		$HUI.linkbutton("#bt_patsee").disable();
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
		$HUI.linkbutton("#bt_revarr").disable(); //hxy 2023-02-01
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
			//$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30 ���� 2021-06-10ע��
		}
		if(IsWFCompFlag!="Y"){
			$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-06-10 ������������
			$HUI.linkbutton("#bt_revarr").disable(); //hxy 2023-02-01
		}
		if (IsMain == "1"){ //2021-06-16 ���ﰴť������ͬԭ�����������һ��
			$HUI.linkbutton("#bt_arr").disable(); 
			$HUI.linkbutton("#bt_revarr").disable(); //hxy 2023-02-01
		}
	}
	
	if((CsStatCode=="����")||(CsStatCode.indexOf("���")>-1)){ //hxy 2021-02-04 δ���ղ�����ҽ��¼��
		$HUI.linkbutton("#bt_order").disable(); 
		$HUI.linkbutton("#bt_Surg").disable();
	}
	if((CsStatCode!="����")&&(CsStatCode!="ȡ�����")){ //hxy 2021-02-05 ������ɺ�������ҽ��¼��
		$HUI.linkbutton("#bt_order").disable(); 
		$HUI.linkbutton("#bt_Surg").disable();
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
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
		$HUI.linkbutton("#bt_ceva").disable(); //2021-06-02
	}
	if(CsStatCode=="ȡ��ȷ��"){ //hxy 2021-01-07 st
		$HUI.linkbutton("#bt_com").disable();
		$HUI.linkbutton("#bt_revcom").disable();
		$HUI.linkbutton("#bt_precom").disable();
		$HUI.linkbutton("#bt_ref").disable();
		$HUI.linkbutton("#bt_revacc").disable();
		$HUI.linkbutton("#bt_acc").disable();
		$HUI.linkbutton("#bt_can").disable();
		$HUI.linkbutton("#bt_reva").disable();
		$HUI.linkbutton("#bt_ceva").disable(); //
		isEditFlag = 1;	         /// �б༭��־
		if(ConsUseStatusCode.indexOf("^60^")!=-1){
			$HUI.linkbutton("#bt_revceva").enable();
		}
		if(ConsUseStatusCode.indexOf("^55^")==-1){
			$HUI.linkbutton("#bt_revcom").enable();
		}
		
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
		//$HUI.linkbutton("#bt_revcom").disable();
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
	//if(CsStatCode!="����"){
	// �޸��ж���������ɡ�ȷ��״̬�²�������б༭ bianshuai 2021-11-19
	if((CsStatCode == $g("���"))||(CsStatCode == $g("ȷ��"))){
		$("#bt_saveloc").hide(); /// �������
		isEditFlag=1;
	}else{
		if(((ModCsFlag == 1)&&(parent.$("#QReqBtn").hasClass("btn-blue-select")))||(IsMain==1)){
			$("#bt_saveloc").show(); /// �������
		}else{
			$("#bt_saveloc").hide(); /// �������
		}
	}
	
	if(seeCstType == 1){
		$("#bt_saveloc").hide();   /// �������
	}
	
	if((CsStatCode=="")&&(BTFlag==1)&&(CstOutFlag != "Y")){ //hxy 2021-04-09 2021-04-19 add BTFlag==1
		isEditFlag=0;
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
	
	///���ﰴť hxy 2021-03-30
	if(ConsUseStatusCode.indexOf("^40^")==-1){
		$("#bt_arr").hide();	 ///����
		$("#bt_revarr").hide();	 ///ȡ������ ���ﲻ������ȡ������Ĭ�ϲ�����
	}
	
	///ȡ�����ﰴť hxy 2023-02-01
	if(ConsUseStatusCode.indexOf("^41^")==-1){
		$("#bt_revarr").hide();	 ///ȡ������
	}
	
	///��ɰ�ť
	if(ConsUseStatusCode.indexOf("^50^")==-1){
		$("#bt_precom").hide();	 ///Ԥ���
		$("#bt_com").hide();	 ///���
		$("#bt_revcom").hide();	 ///ȡ�����
	}
	
	///��������
	if((ConsUseStatusCode.indexOf("^55^")==-1)||(WriEvaCsFlag=="0")){//hxy 2020-07-09 ԭ:if(ConsUseStatusCode.indexOf("^55^")==-1){
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
			$.messager.alert("��ʾ","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","����ʱ�䲻����������ʱ�䣡","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","���ճɹ���","info");
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
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(1) != 1){
		$.messager.alert("��ʾ","����Ȩ�޲鿴�ò��˲������ݣ�","warning");
		return;
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("��ʾ","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	var lnk ="emr.bs.browse.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&EpisodeLocID="+session['LOGON.CTLOCID']+"&Action="+'externalapp'; //emr.interface.browse.category.csp
	websys_showModal({ //hxy 2023-02-08
		url:lnk,
		title:$g('�������'),
		onClose: function() {
		}
	});	
	//window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function PatPacsAndLis(){
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	var lnk = "dhcem.consultsee.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	websys_showModal({
		url:lnk,
		iconCls:"icon-w-paper", //hxy 2023-03-17
		title:$g('������鿴'),
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			
		}
	});	
}

/// ���λ���
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var link="dhcem.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=50, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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
		//$HUI.combobox("#HospArea").enable(); 	  /// Ժ��
		$HUI.combobox("#CstType").enable(); //hxy 2021-04-09 �ſ�ע��
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
		if(isOpiEditFlag != "Y"){ //hxy 2021-03-03 ����״̬����ʱ,����״̬�Ļ��ﲻӦ����д�������(���ջᶪʧ����)��
			$("#ConsOpinion").prop("readonly",true);   /// �������
		}
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
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function PatNotTakOrdMsg(TipFlag){
	
	if(seeCstType==1) return false;
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)&&(NoAdmValidDaysLimit!=1)){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return false;	
	}
	return true;
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
		$.messager.alert("��ʾ","û�д��������ݣ�","warning");
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
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'symwin', '300', '130', option).Init();
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymLoc(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	if(ConsOpinion==""){
		$.messager.alert("��ʾ","�������ģ�岻��Ϊ�գ�","warning");
		return;	
	}else{
		ConsOpinion=$_TrsSymbolToTxt(ConsOpinion.replace(/\"/g,'��')); /// ����������� hxy 2023-02-24
	}
	var Params=session['LOGON.CTLOCID']+"^^"+ConsOpinion;
	
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���","info");
			$('#symwin').window('close');
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymUser(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	if(ConsOpinion==""){
		$.messager.alert("��ʾ:","�������ģ�岻��Ϊ�գ�","warning");
		return;	
	}else{
		ConsOpinion=$_TrsSymbolToTxt(ConsOpinion.replace(/\"/g,'��')); /// ����������� hxy 2023-02-24
	}
	var Params="^"+session['LOGON.USERID']+"^"+ConsOpinion;
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���","info");
			$('#symwin').window('close');
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

///������Ŀ��ģ��    qiaoqingao  2018/08/20
function showmodel(flag){
		
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winonline" style="overflow:hidden"></div>');
	$('#winonline').window({
		iconCls:'icon-w-paper', //hxy 2023-02-24
		title:$g('ģ���б�'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:700,
		height:500
	});
	
	var link="dhcem.consultcottemp.csp?";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src='+link+'></iframe>';
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
	
	var CstItmIDPri=CstItmID;
	if((CstMorFlag=="Y")&&(parent.$("#QReqBtn").hasClass("btn-blue-select"))){ //hxy 2021-01-26 st
		CstItmIDPri="";
	} //ed
	if((CstMorFlag=="Y")&&(parent.$("#QReqBtn").length<1)&&((!$('#bt_can').linkbutton('options').disabled))){ //�������-����ÿ�CstItmID
		CstItmIDPri="";
	}
	
	if(CstItmIDPri!=""){
		PrintCstHtmlMethod(CstItmIDPri);
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
		var link="dhcem.printconsone.csp?CstItmIDs="+txtData+"&LgHospID="+LgHospID;
		if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
			link += "&MWToken="+websys_getMWToken();
		}
		window.open(link); //hxy 2021-03-04 add LgHospID
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
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	if (GetTakOrdAutFlag(2) != 1){
		$.messager.alert("��ʾ","����Ȩ�޸��ò�����ҽ����","warning");
		return;
	}
	
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm + "&FixedEpisodeID="+EpisodeID+"&CstItmID="+CstItmID;
	websys_showModal({
		url:lnk,
		maximizable:false,
		title:$g('ҽ��¼��'),
		iconCls:"icon-w-paper", //hxy 2023-03-17
		//width:top.screen.width, //hxy 2022-03-25 st
		//height:top.screen.height, //ed
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
		$.messager.alert("��ʾ","û�д��޸����ݣ�","warning");
		return;	
	}
	$.each(rowData, function(index, item){
		if((trim(item.LocDesc) != "")||(trim(item.LocGrp) != "")){ //guoguomin20200909){
		    //var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^^^"+ item.itmID;
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^^"+item.LocGrpID+"^"+ item.itmID;
		    CsLocArr.push(TmpData);
		}
	})
	
	if (isExistItem() == 1){
		$.messager.alert("��ʾ","����һ�˶�����¼�����ܱ��棡","warning");
		return;		
	}
	if ((CsLocArr.length == 0)&&(LeaderFlag!=1)){
		$.messager.alert("��ʾ","û�д��޸����ݣ�","warning");
		return;	
	}
	
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// ��������
	if ((CsLocArr.length >= 2)&(CstType.indexOf("����") != "-1")){
		$.messager.alert("��ʾ","��������Ϊ���ƻ������ѡ�������ң�","warning");
		return;	
	}
	var mListData = CsLocArr.join("@");
	if(mListData == ""){
		$.messager.alert("��ʾ","û�д��޸����ݣ�","warning");
		return;	
	}
	
	runClassMethod("web.DHCEMConsult","InsCsLocItem",{"CstID":CstID, "LgParam":LgParam, "mListData":mListData},function(jsonString){
		var LastChild=jsonString.split("^").length>1?jsonString.split("^")[1]:"";
		jsonString=jsonString.split("^")[0];
		if (jsonString == 0){
			$.messager.alert("��ʾ","�޸ĳɹ���","info",function(){
				///���ͳɹ��������������Ҫ�Զ���Ȩ���Ӳ����鿴 hxy 2021-07-05 st
				if(DefOpenAcc==1){
					InsEmrAutMasAll(1,LastChild);
				}
				///���ͳɹ��������������Ҫ�Զ���Ȩҽ��
				if(DefOpenAccOrd==1){
					InsEmrAutMasAll(2,LastChild);
				}//ed
			});

			$("#dgCstDetList").datagrid("load",{"CstID":CstID});      /// �������
			if (window.parent.QryConsList != undefined){
				window.parent.QryConsList("R");
			}
			if(window.parent.QryCons){ //hxy 2021-07-05
				window.parent.QryCons();	
			}
			
		}else if(jsonString=="-2"){
			$.messager.alert("��ʾ","��ָ��ҽ����","error");
		}else{
			$.messager.alert("��ʾ","�������޸Ŀ��ң�","error");
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
function delCsItem(ItmID,rowIndex){ //hxy 2021-04-20 add rowIndex
	var CstType = $HUI.combobox("#CstType").getText(); 	 /// ��������
	var rows = $('#dgCstDetList').datagrid('getRows');
	var CsLocArr = [];
	for(var i=0; i<rows.length; i++){
		if (rows[i].LocID != ""){
			CsLocArr.push(rows[i].LocID);
		}
	}
	if ((CsLocArr.length <= 2)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ","ɾ�����󣬻�������Ϊ��ƻ������Ӧѡ���������������Ͽ��ң�","warning");
		return false;	
	}
	if (CsLocArr.length <= 1){
		$.messager.alert("��ʾ","ɾ�����󣬻�����Ҳ���Ϊ�գ�������Ҫѡ��һ�����ң�","warning");
		return false;	
	}
	
	var Flag = false;
	//delRowObj(rowIndex);  /// ɾ���� hxy 2021-04-20 st 2021-05-17 ���ƴ���
	if(CsStatCode==""){
		delRowObj(rowIndex); //
		SaveCstNo("delete");
		return true;
	}else{ //ed
	runClassMethod("web.DHCEMConsult","delCsItem",{"ItmID":ItmID, "LgUserID":LgUserID},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ","ɾ���ɹ���","info");
			Flag = true;
		}else if (jsonString == -1){ //hxy 2021-05-17 st
			$.messager.alert("��ʾ","ɾ�����󣬻�������Ϊ��ƻ������Ӧѡ���������������Ͽ��ң�","info");
			Flag = false; //ed
		}else if (jsonString == -2){
			$.messager.alert("��ʾ","�ü�¼�ѱ����գ���ȡ�����պ�ɾ��","info"); //�Ѿ����յļ�¼����ɾ��
			Flag = false;
		}else if (jsonString == -3){
			$.messager.alert("��ʾ","�ü�¼����ɣ��޷�ɾ��","info"); //�Ѿ���ɵļ�¼����ɾ��
			Flag = false;
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�","info");
			Flag = false;
		}
	},'',false)
	}
	return Flag;
}

///����ر�ʱ���δ������ʾ�������������ȥ��
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
		$.messager.alert("��ʾ","��������Ϊ�գ����ڻ���������ά����","warning");
		return;
	}
	var itemhtmlArr = [];
	for (var j=0; j<itmArr.length; j++){
		//var EmFlag = itmArr[j].itmDesc.indexOf($g("��")) != -1?"Y":"N"; //������ܲ�ͳһ(����:һ��Em,һ��em)
		var EmFlag = ((itmArr[j].itmDesc.indexOf($g("��")) != -1)||(itmArr[j].itmDesc.indexOf("��") != -1))?"Y":"N";
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
	openAppraisePage(ID,Code,Mode,Title,seeCstType); //hxy 2021-04-12 add seeCstType
}

function openAppraisePageC(){
	var ID=CstItmID;
	var Code ="SHP";
	var Mode = "C";
	var Title = $g("����ҽʦ����");
	openAppraisePage(ID,Code,Mode,Title,seeCstType); //hxy 2021-04-12 add seeCstType
}



///����ҽ����������
function openAppraisePage(ID,Code,Mode,Title,seeCstType){
	var ID=CstItmID;   
	var AppTableCode=Code ;
	var SaveMode=Mode;     ///��ʽ,���ﻹ������   C����ҽʦ���� R����ҽ������
	var AppTableTitle=Title;
	var lnk ="dhcem.consapptable.csp?ID="+ ID +"&AppTableCode="+AppTableCode+"&SaveMode="+SaveMode+"&AppTableTitle="+AppTableTitle+"&seeCstType="+seeCstType;

	websys_showModal({
		url:lnk,
		title:AppTableTitle,
		width:550,
		height:500,
		onClose: function() {
			
		}
	});
	
}

///hxy 2021-04-02 ���ﰴť������ʱ����������ʱ�䲻�ɱ༭
function ArrTimeDisOrEnByBtn(){
	/// ���ﵽ��ʱ�� hxy 2021-04-01 st
	var RListFlag="Y"; //�����б��־
	if(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))RListFlag="N";
	if(((ModArrTime==3)||((ModArrTime==1)&&(RListFlag=="Y"))||((ModArrTime==2)&&(RListFlag=="N")))&&((!$('#bt_arr').linkbutton('options').disabled)&&$("#bt_arr").is(":visible"))){
		$HUI.datebox("#CstArrDate").enable(); 
		$HUI.timespinner("#CstArrTime").enable();
	}else{
		$HUI.datebox("#CstArrDate").disable(); 
		$HUI.timespinner("#CstArrTime").disable();
	} //ed
}

function DisAndEnabBtnByConfig(){
	//1�������ˣ�2�������ˣ�3�������˻����˶����޸ģ��������������޸� (��ҽԺ����)
	if((ModArrTime==1)&&(!parent.$("#QReqBtn").hasClass("btn-blue-select"))){
		$HUI.linkbutton("#bt_arr").disable();
	}
	if((ModArrTime==2)&&(!parent.$("#QConBtn").hasClass("btn-blue-select"))){
		$HUI.linkbutton("#bt_arr").disable();
	}
	if(((ModArrTime!=1)&&(ModArrTime!=2)&&(ModArrTime!=3))&&($HUI.datebox("#CstArrDate").getValue()!="")){
		$HUI.linkbutton("#bt_arr").disable();
	}
	if((ConsUseStatusCode.indexOf("^41^")>-1)&&(ConsUseStatusCode.indexOf("^40^")>-1)){
		if((CstMorFlag == "Y")&&(parent.$("#QReqBtn").hasClass("btn-blue-select"))){ //���+������ʱ
		}else{
		if($HUI.datebox("#CstArrDate").getValue()!=""){ //2023-02-02
			$HUI.linkbutton("#bt_arr").disable();
			$HUI.linkbutton("#bt_revarr").enable();
		}else{
			$HUI.linkbutton("#bt_arr").enable();
			$HUI.linkbutton("#bt_revarr").disable();
		}
		}
	}
}

/// ���Ӳ�������
function OpenEmrWin(){
	if (CstID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼��","warning");
		return;
	}
	//var lnk ="emr.interface.ip.consult.csp?EpisodeID="+ EpisodeID +"&InstanceID=&FromCode="+CstID+"&CTlocID="+LgLocID+"&UserID="+LgUserID+"&DisplayType=Nav&NavShowType=Category&RecordShowType=Category"
	var lnk ="emr.interface.ip.consult.csp?EpisodeID="+ EpisodeID +"&InstanceID="+InstanceID+"&FromCode="+CstID+"&CTlocID="+LgLocID+"&UserID="+LgUserID+"&DisplayType=&NavShowType=&RecordShowType=&ShowNav=N"
	//window.open(lnk,"_blank","height=800, width=1200, top=30, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	//return;
	websys_showModal({
		url:lnk,
		title:"����",
		iconCls:"icon-w-paper",
		width:1200,
		height:800,
		onClose: function() {	
		}
	});	
}

/// �����������봰��
function OpenSurgWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	//var lnk = "dhcanoperapplication.csp?a=a&opaId=&appType=ward&EpisodeID="+ EpisodeID;
	var lnk = "cis.an.operapplication.csp?a=a&opaId=&appType=ward&ConFlag=1&EpisodeID="+ EpisodeID; //hxy 2023-02-13 �ṩ��csp�޸ģ�ԭ��CIS.AN.OperApplication.New.csp
	
	websys_showModal({
		url:lnk,
		maximizable:false,
		title:$g('��������'),
		width:screen.availWidth-150,
		//height:screen.availHeight-150,
		onClose: function() {
		}
	});

}

/// combobox ����ֵ
function $_CT(id){

	var datas = $HUI.combobox("#CstType").getData()
	var itemCode = "";
	for (var i = 0; i<datas.length; i++){
		if (id == datas[i].value){
			itemCode = datas[i].code;
			break;
		}
	}
	return itemCode;
}
window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
