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
var LType = "CONSULTWARD";  /// ������Ҵ���
var CsRType = "NUR";    /// ��������  ҽ��
var CstOutFlag = "";    /// Ժ�ʻ����־
var CstMorFlag ="";     /// ��ƻ����־
var CstEmFlag = "";     /// �������־ hxy 2021-03-31
var TakOrdMsg = "";     /// ��֤�����Ƿ�����ҽ��
var TakCstMsg = "";     /// ��֤ҽ���Ƿ��п�����Ȩ��
var isOpiEditFlag = 0;  /// ��������ǿɱ༭
var isEvaShowFlag = 0;  /// ���������Ƿ���ʾ
var IsPerAccFlag = 0;   /// �Ƿ�����������뵥
var CsStatCode = "";    /// ���뵥��ǰ״̬
var seeCstType="";      ///�鿴ģʽ
var IsWFCompFlag="";    /// ��������˱�־
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
	if ((EpisodeID != "")&&(seeCstType!="1")){ //hxy 2020-08-05 �鿴ģʽ�������֤
		InitPatNotTakOrdMsg(1);    /// ��֤�����Ƿ�����ҽ��
		//InitPatNotTakCst(1);     /// ��֤�����Ƿ��л�������
	}
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	/// Ĭ��ƽ����
	//$HUI.radio("input[name='CstEmFlag'][value='N']").setValue(true);
	$HUI.radio("input[name='CstEmFlag'][label='ƽ����']").setValue(true);

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

		    	isEditFlag = 0;		/// �б༭��־
			}
			$("#dgCstDetList").datagrid("reload");      /// �������
	    },
	    onShowPanel: function () { //���ݼ�������¼�
			$("#CstType").combobox('reload',unitUrl);
        },
        onLoadSuccess:function(data){
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
	        if (option.text.indexOf("����") != "-1"){
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
	        if (option.text.indexOf("����") != "-1"){
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
	        if (option.text.indexOf("����") != "-1"){
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
	
	/// ר��С��
	var option = {
		///panelHeight:"auto",
		blurValidValue:true,
		url:$URL+"?ClassName=web.DHCEMConsultGroup&MethodName=JsonConsGroup&HospID="+LgHospID+"&Type=NUR", //hxy 2021-06-21
        onSelect:function(option){
	        if(GrpAllowUpd!=1){isEditFlag = 1}; //hxy 2020-09-25 isEditFlag = 1;  /// �б༭��־
			$("#dgCstDetList").datagrid("load",{"GrpID":option.value,"LgParams":LgParam});      /// �������
	    },
		onShowPanel:function(){
			
		},
		onChange:function(newValue, oldValue){
			if (newValue == ""){
				isEditFlag = 0;  /// �б༭��־
				$("#dgCstDetList").datagrid("load",{"GrpID":""});      /// �������
			}
		}
	};
	var url = "";
	new ListCombobox("CstGrp",url,'',option).init();
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp&Type="+CsRType,
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
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'}); //hxy 2021-05-10 st
				var LocID = $(ed.target).val();
				if(LocID!=""){
					var PrvTpID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'NURSE',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("��ʾ","��ǰ�����޻�ʿ,��ѡ���������ͣ�");
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
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID,
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);

				///���ü���ָ��
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
				
				var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'}); //hxy 2021-05-10 st
				var PrvTpID = $(ed.target).val();
				if(PrvTpID!=""){
					var LocID = option.value;
					var Datas=serverCall("web.DHCEMConsultCom","JsonLocCareProv",{ProvType:'NURSE',LocID:LocID,PrvTpID:PrvTpID,LgUserID:LgUserID});
					if(Datas=="[]"){
						$.messager.alert("��ʾ","��ǰ�����޻�ʿ,��ѡ���������ͣ�");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
						$(ed.target).val("");
						var ed=$("#dgCstDetList").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
						$(ed.target).combobox('setValue',"");
					} 
				}//ed
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
				GetMarIndDiv(option.value); 	/// ȡ������רҵָ��
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
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=NURSE&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
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
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true}, //2021-05-10 λ��ǰ��
		{field:'LocDesc',title:'����',width:290,editor:LocEditor,align:'center'}, //2021-05-10 λ��ǰ��
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'����',width:160,editor:PrvTpEditor,align:'center'}, //hxy 2021-02-20 ְ��->����
		//{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		//{field:'LocDesc',title:'����',width:290,editor:LocEditor,align:'center'},
		{field:'MarID',title:'��רҵID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'��רҵ',width:200,editor:MarEditor,align:'center',hidden:true},
		{field:'UserID',title:'��ʿID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'��ʿ',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		border:true, //hxy 2023-02-07 st
		bodyCls:'panel-header-gray', //ed
		//showHeader:false,
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onClickRow: function (rowIndex, rowData) { //hxy 2021-03-08 onDblClickRow->onClickRow
			
			if(!isCanUpdConsLoc()) return;
			
			var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
			if (((CstType.indexOf("����") != "-1")&(rowIndex != 0))||(CstType == ""))return;
			
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
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMConsultQuery&MethodName=JsonQryConsult&CstID="+"";
	new ListComponent('dgCstDetList', columns, uniturl, option).Init();
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	if(HISUIStyleCode=="lite"){ //hxy 2023-02-06
		var html = '<a href="javascript:void(0)" class="icon-add" style="color:#000;" onclick="insRow()"></a>';
	    html +='<a href="javascript:void(0)" class="icon-cancel" style="color:#000;" onclick="delRow('+ rowIndex +')"></a>';
	    return html;
	}else{
	var html = "<a href='javascript:void(0)' onclick='delRow("+ rowIndex +")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
	html += "<a href='javascript:void(0)' onclick='insRow()'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>";
	return html;
	}
}

/// ɾ����
function delRow(rowIndex){
	
	if(!isCanUpdConsLoc()) return;
	
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ","����ѡ���У�");
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
	
	if(!isCanUpdConsLoc()) return;
	
	var CstType = $HUI.combobox("#CstType").getText(); 	          /// ��������
	if ((CstType.indexOf("����") != "-1")||(CstType == "")) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#dgCstDetList").datagrid('appendRow',rowObj);
}

/// ���Ͳ�������
function SaveCstNo(SendFlag){ //hxy 2021-04-12 add SendFlag
    
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
	var MoreFlag = CstType.indexOf("���") != "-1"?"Y":"N";  /// �Ƿ���
	
//	var mListData = EpisodeID +"^"+ CsRUserID +"^"+ CsRLocID +"^"+ CstTrePro +"^"+ CstPurpose +"^"+ CstTypeID +"^"+ CstAddr +"^"+ CsRType;
//		mListData += "^"+ CstDate +"^"+ CstTime +"^"+ CstEmFlag +"^"+ CstOutFlag +"^"+ CstUnit +"^"+ CstLoc +"^"+ CstNote +"^"+ CstUser +"^"+ CstTele +"^"+ "" +"^"+ MoreFlag;

	/// �������
	var ConsDetArr=[],HasRepetDoc=false,DocList="^";;
	var rowData = $('#dgCstDetList').datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			if((DocList.indexOf("^"+item.UserID+"^")!=-1)&&(trim(item.UserID) != "")){
				HasRepetDoc=true;
			}
			DocList=DocList+item.UserID+"^";
			
		    var TmpData = item.LocID +"^"+ item.UserID +"^"+ item.PrvTpID +"^"+ item.MarID +"^"+ item.LocGrpID;
		    ConsDetArr.push(TmpData);
		}
	})
	
	if(HasRepetDoc){
		$.messager.alert("��ʾ","����ͬһ��Ա������¼����ȷ�ϣ�","warning");
		return;
	}

	if ((ConsDetArr.length == 1)&(CstType.indexOf("���") != "-1")){
		$.messager.alert("��ʾ","��������Ϊ��ƻ������ѡ���������������Ͽ��ң�","warning");
		return;	
	}
	if ((ConsDetArr.length >= 2)&(CstType.indexOf("����") != "-1")){
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

	/// ����
	runClassMethod("web.DHCEMConsult","Insert",{"CstID":CstID, "mListData":mListData},function(jsonString){
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
			$.messager.alert("��ʾ","����ɹ���","info");
			if (window.parent.QryConsList != undefined){  ///ˢ������б� hxy 2021-05-25
				window.parent.QryConsList("R");
			}
			$(".tip").text("(�ѱ���)");
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
	if(CstItmID=="")return;
	var Param=""; //hxy 2021-03-16 st
	if(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select")){ 
		Param="Y";
	}
	runClassMethod("web.DHCEMConsultQuery","JsGetCstNoObj",{"ItmID":CstItmID,"Param":Param},function(jsonString){ //ed add ,"Param":Param

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsCstNoObj(jsonObjArr);
		}
	},'json',false)
}

/// ���û������뵥����
function InsCstNoObj(itemobj){
	if(itemobj.CstStatus!=""){
		/// �������ڿ���
		$('#CstDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				return date;
			}
		});
	}else{
		/// �������ڿ���
		$('#CstDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
				return date>=now;
			}
		});
	}
	$("#ConsTrePro").val($_TrsTxtToSymbol(itemobj.CstTrePro));  		/// ��Ҫ����
	$("#ConsPurpose").val($_TrsTxtToSymbol(itemobj.CstPurpose));  	/// ����Ŀ�� 
	$("#CstUser").val(itemobj.CstUser);   		    /// ��ϵ��
	$("#CstTele").val(itemobj.CstPhone);   		    /// ��ϵ�绰
	$("#CstRLoc").val(itemobj.CstRLoc);   		    /// �������
	$("#CstRDoc").val(itemobj.CstRUser);   		    /// ����ҽʦ
	$("#CstAddr").val(itemobj.CstNPlace);           /// ����ص�
	var CstOpinion = "";
	if (itemobj.CstOpinion != ""){
		CstOpinion = itemobj.CstOpinion.replace(new RegExp("<br>","g"),"\r\n")
	}
	$("#ConsOpinion").val($_TrsTxtToSymbol(CstOpinion));      /// �������

	/// �Ӽ�
	if (itemobj.CsPropID != ""){
		$HUI.radio("input[name='CstEmFlag'][id='"+ itemobj.CsPropID +"']").setValue(true);
	}
	$HUI.combobox("#CstType").setValue(itemobj.CstTypeID);   /// ��������
	$HUI.combobox("#CstType").setText(itemobj.CstType);      /// ��������
	
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
	$HUI.datebox("#CstDate").setValue(itemobj.CstNDate);      /// ��������
	$HUI.timespinner("#CstTime").setValue(itemobj.CstNTime);  /// ����ʱ��
		
	$HUI.datebox("#ConsDate").setValue(itemobj.SysDate);      /// ϵͳ����
	$HUI.timespinner("#ConsTime").setValue(itemobj.SysTime);  /// ϵͳʱ��
	
	$HUI.datebox("#CstArrDate").setValue(itemobj.ArrDate);      /// �������� hxy 2021-03-31
	$HUI.timespinner("#CstArrTime").setValue(itemobj.ArrTime);  /// ����ʱ�� hxy 2021-03-31
	
	CsUserID = itemobj.CsUserID;            /// ������Ա
	EpisodeID = itemobj.EpisodeID;			/// ����ID
	CstOutFlag = itemobj.CstOutFlag; 		/// ��Ժ�����־
	CstMorFlag = itemobj.CstMorFlag; 		/// ��ƻ����־
	isOpiEditFlag = itemobj.isOpiEditFlag;  /// ��������ǿɱ༭
	IsPerAccFlag = itemobj.IsPerAccFlag;    /// �Ƿ�����������뵥
	CsStatCode = itemobj.CstStatus;         /// ���뵥��ǰ״̬
	CstEmFlag = itemobj.CstEmFlag;          /// �������־ hxy 2021-03-31
	IsWFCompFlag=itemobj.IsWFCompFlag;      /// ��������˱�־ hxy 2021-06-10
	if (CsStatCode == ""){
		$(".tip").text("(�ѱ���)");
		if(ReqTimeFill==1){ //hxy 2021-02-19
			$HUI.timespinner("#CstTime").enable();
			$HUI.datebox("#CstDate").enable(); //hxy 2021-03-10
		}
		$("#CstAddr").attr("disabled", false); //hxy 2022-03-21
	}else{
		$(".tip").text("");
		$HUI.timespinner("#CstTime").disable(); //hxy 2021-02-19
		$HUI.datebox("#CstDate").disable(); //hxy 2021-03-10
		$("#CstAddr").attr("disabled", true); //hxy 2022-03-21
	}
	
	if (itemobj.CsEvaRFlag != ""){
		$HUI.radio("input[name='CstEvaRFlag'][value='"+ itemobj.CsEvaRFlag +"']").setValue(true);
		if (itemobj.CsEvaRID != ""){
			$HUI.combobox("#CstEvaR").setText(itemobj.CsEvaRDesc);   /// ���������
		}else{
			$HUI.combobox("#CstEvaR").setText("����");               /// ��������
			$("#CstEvaRDesc").val($_TrsTxtToSymbol(itemobj.CsEvaRDesc));  /// ���������
		}
//		$HUI.radio("input[name='CstEvaRFlag']").disable();
//		$("#CstEvaRDesc").attr("disabled",true);    /// ��������
//		$HUI.combobox("#CstEvaR").disable();        /// ��������
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
			$HUI.combobox("#CstEva").setText("����");             /// ��������
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

	if (itemobj.CstGrpID != ""){
		$HUI.combobox("#CstGrp").setValue(itemobj.CstGrpID);     /// ר��С��
	}else{
		$HUI.combobox("#CstGrp").setValue("");     /// ר��С��	
	}
	
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
		$.messager.alert("��ʾ","����û�����,����¼�룡","warning");
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
	
	runClassMethod("web.DHCEMConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam},function(jsonString){
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
			GetCstNoObj(); //hxy 2021-02-20
			CsStatCode="����";
			isShowPageButton(CstID);     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ","���ͳɹ���","info");
			///���ͳɹ�������������Զ���ӡ & ����δ��ɿ��Դ�ӡ�����¼�� hxy 2021-05-17
			if((SendAutoPri==1)&&(ConsNoCompCanPrt!=1)){
				PrintCstHtml();
			}
			if (window.parent.reLoadMainPanel != undefined){
				if(CstItmID!=""){ //hxy 2021-01-14 st ��������Ҳ�״̬���ܶ�Ӧ�仯
					window.parent.reLoadMainPanel(CstItmID);
				}else{
				window.parent.reLoadMainPanel(CstID);
				} //ed
			}
			$(".tip").text("");
		}
	},'',false)
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
	
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫȡ����ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCEMConsult","InvCanCstNo",{"CstID":CstID, "UserID":session['LOGON.USERID']},function(jsonObject){

				if (jsonObject.ErrCode == -1){
					$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȡ��������","warning");
					return;
				}
				if (jsonObject.ErrCode < 0){
					$.messager.alert("��ʾ","��������ȡ��ʧ�ܣ�ʧ��ԭ��:"+jsonObject.ErrMsg,"warning");
				}else{
					$.messager.alert("��ʾ","ȡ���ɹ���","info",function(){
						window.location.reload();
					});
					window.parent.reLoadMainPanel(CstItmID);
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
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȷ�ϲ�����","warning");
			return;
		}*/
		if (jsonString.split("^")[0] == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬�����������ȷ�ϲ���"+jsonString.split("^")[1]+"!","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ","�����ҽʦ�������ۺ���ȷ��!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȷ��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","ȷ�ϳɹ���","info");
			GetCstNoObj();
			isShowPageButton(CstID);
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
		if (jsonString == -4){
			$.messager.alert("��ʾ","ְ�����ƣ���������н��ղ���!","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","���ճɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
			window.parent.reLoadMainPanel(CstItmID);
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
		var errMsg=jsonString.split("^").length>1?jsonString.split("^")[1]:jsonString;
		jsonString=jsonString.split("^")[0];
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥�Ǵ�����״̬�����������ȡ�����ղ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ���ɹ���","info");
			GetCstNoObj();  	          /// ���ػ�������
			isShowPageButton(CstID);      /// ��̬����ҳ����ʾ�İ�ť����
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
			$.messager.alert("��ʾ","���뵥�漰����һ��������ܾ�������","warning");
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
	if ((CstMorFlag == "Y")&&(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))){ //���+������ʱ
		var lnk ="dhcem.consultarr.csp?CstID="+ CstID +"&LgParam="+LgParam+"&ModArrTime="+ModArrTime;
		websys_showModal({
			url:lnk,
			title:$g("��������ʱ��"),
			iconCls:"icon-w-paper",
			width:520,
			height:320,
			onClose: function() {
				GetCstNoObj();
				window.parent.reLoadMainPanel(CstItmID);
			}
		});
		return;
	}else{
		/// ��ƻ�����д��ʶ //hxy 2021-03-30 st
		/*var ItmID = "";
		if (((MulWriFlag == 1)&(CstMorFlag == "Y"))||(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))){ ItmID = ""; }
		else{ ItmID = CstItmID; }*/

		var ArrDate = $HUI.datebox("#CstArrDate").getValue();
		var ArrTime = $HUI.timespinner("#CstArrTime").getValue(); 
		
		//runClassMethod("web.DHCEMConsult","AriCstNo",{"ItmID": CstItmID, "UserID":session['LOGON.USERID']},function(jsonString){ //hxy 2021-03-30 st
		runClassMethod("web.DHCEMConsult","AriCstNo",{"CstID": CstID, "ItmID": CstItmID, "LgParam":LgParam,"ArrDate":ArrDate,"ArrTime":ArrTime},function(jsonString){ //ed
		
			if (jsonString == -1){
				$.messager.alert("��ʾ","���뵥��ǰ״̬����������е��������","warning");
				return;
			}
			if (jsonString == -2){ //hxy 2021-05-07 st
				$.messager.alert("��ʾ","����ʱ�䲻�ܴ��ڵ�ǰʱ�䣡","warning");
				return;
			}
			if (jsonString == -3){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڷ���ʱ�䣡","warning");
				return;
			}//ed
			if (jsonString == -4){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ�������ʱ�䣡","warning");
				return;
			}
			if (jsonString < 0){
				$.messager.alert("��ʾ","�������뵽��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
			}else{
				$.messager.alert("��ʾ","����ɹ���","info");
				GetCstNoObj(); /// ���ػ������� hxy 2021-04-01 Ϊ�˸��µ���ʱ��
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
	
	var ConsOpinion = $("#ConsOpinion").val();
	if (ConsOpinion.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ","����д������ۣ�","warning");
		return;
	}
	ConsOpinion = $_TrsSymbolToTxt(ConsOpinion); /// �����������
	
	/// ��Ժ�Ͷ����������д�������
	/// var Fn = ((CstOutFlag == "Y")||(CstMorFlag == "Y"))?"CompCstMas":"CompCstNo";
	/// ��ƻ�����д��ʶ
	var ItmID = "";
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")){ ItmID = ""; }
	else{ ItmID = CstItmID; }
	runClassMethod("web.DHCEMConsult","CompCstMas",{"CstID": CstID, "ItmID": ItmID, "LgParam":LgParam, "CstOpinion":ConsOpinion},function(jsonString){
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
		
		if (jsonString < 0){
			$.messager.alert("��ʾ","�����������ʧ�ܣ�ʧ��ԭ��:"+errMsg,"warning");
		}else{
			$.messager.alert("��ʾ","��ɳɹ���","info");
			GetCstNoObj();  	            /// ���ػ�������
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
	
	runClassMethod("web.DHCEMConsult","RevCompCstMas",{"CstID": CstID, "ItmID": ItmID, "UserID":session['LOGON.USERID']},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ","���뵥��ǰ״̬��������ȡ����ɲ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ","��������ȡ�����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ","ȡ���ɹ���","info");
            GetCstNoObj();  	          /// ���ػ�������
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
	
	if (GetIsOperFlag("60") != "1"){
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

	if (CstEvaDesc.indexOf("����") != "-1"){
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
			window.parent.reLoadMainPanel(CstItmID);
		}
	},'',false)		
}

/// ��������
function EvaCstNo(){
	
	if (GetIsOperFlag("50") != "1"){
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
	
	if (CstEvaDesc.indexOf("����") != "-1"){
		CstEvaDesc = $("#CstEvaDesc").val();
		if (CstEvaDesc.replace(/\s/g,'') == ""){
			$.messager.alert("��ʾ","������д���۲������ݣ�","warning");
			return;
		}	
	}
	CstEvaDesc = $_TrsSymbolToTxt(CstEvaDesc); /// �����������
	
	var CsEvaParam = CstEvaFlag +"^"+ CstEvaDesc;
	
	runClassMethod("web.DHCEMConsult","EvaCstNo",{"ItmID": CstItmID, "UserID":LgUserID, "CsEvaParam":CsEvaParam},function(jsonString){
		
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
		InitPatNotTakOrdMsg(0);    /// ��֤�����Ƿ�����ҽ��
	}
	$("#dgCstDetList").datagrid("load",{"CstID":arCstID});      /// �������
	
	if(seeCstType){ 
		$("#OpBtns").hide();
		$(".p-content").css({"top":25});
	}
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	if (CstID != ""){
		LoadReqFrame(CstID, CstItmID);    /// ���ز�������
	}else{
		GetLgContent();  /// ȡ��¼��Ϣ
	}
}

/// ������Ȩ
function OpenAuthorize(){

	if (CstID == ""){
		$.messager.alert("��ʾ","�뱣�������ٿ�����Ȩ��","warning");
		return;
	}
	
	if (document.body.clientWidth > 1000){
		$("#TabMain").attr("src","dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID);
		/// �½�������Ȩ����
		newCreateConsultWin();	
	}else{
		var lnk ="dhcem.consultemraut.csp?EpisodeID="+ EpisodeID +"&CstID="+ CstID;
		if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk, 'newWin', 'height=550, width=1000, top=200, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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

	var Link="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue=&Flag="+flag; //+obj.text;
	window.parent.commonShowWin({
		url: Link,
		title: "����",
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
	
	if (flag == 21){
		if ($("#ConsTrePro").val() == ""){
			$("#ConsTrePro").val(innertTexts);  		/// ��Ҫ����
		}else{
			$("#ConsTrePro").val($("#ConsTrePro").val()  +"\r\n"+ innertTexts);  		/// ��Ҫ����
		}
	}else if(flag == 23){ //hxy 2021-01-13 st
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
	
	HideAndShowButton(BTFlag);  ///����ͨ�����˷��͡����˽�����ʾ��ť

	HideOrShowBySet();          ///����������ʾ����
	
	DisAndEnabBtn();
	
	HideOrShowByProp();         ///������ƽ�������� hxy 2021-03-31
	
	ArrTimeDisOrEnByBtn();      ///���ﰴť������ʱ����������ʱ�䲻�ɱ༭ hxy 2021-04-02

}

function HideOrShowByProp(){
	if((ArrJustForE==1)&&(CstEmFlag!="Y")){
		$("#bt_arr").hide();	 ///����
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
	$HUI.linkbutton("#bt_arr").enable(); //hxy 2021-03-30
	
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
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
		$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30
		isEditFlag = 1;	         /// �б༭��־
	}
	
	if((CsStatCode=="����")||(CsStatCode=="���")||(CsStatCode.indexOf("���")!=-1)){
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
			//$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-03-30 2021-06-10 ע��
		}
		if(IsWFCompFlag!="Y"){
			$HUI.linkbutton("#bt_arr").disable(); //hxy 2021-06-10 ������������
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
	}
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
		}
		if((CsStatCode=="��������")&(ConsUseStatusCode.indexOf("^60^")!=-1)){  
			$HUI.linkbutton("#bt_reva").disable();
		}
	}

	
}

function HideAndShowButton(BTFlag){
	/// �����  ����δ����
	if (BTFlag == 1){
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ceva").hide();  /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_reva").hide();  /// ����
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		
		$("#bt_save").show();  /// ����
		$("#bt_remove").show(); ///ɾ��
		$("#bt_send").show();  /// ����
		$("#bt_can").show();   /// ȡ��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#Opinion").show();  /// �������
		$("#QueEmr").show();   /// ����
		$("#QueEmr2").hide();   /// ���� hxy 2021-01-13 st
		$("#QueEmr3").show();   /// ���� ed
		$("#ConsEvaR").hide(); /// ��������� //hxy 2021-04-09
		PageEditFlag(1);	   /// ҳ��༭
		isEditFlag = 0;	       /// �б༭��־
		if (CstOutFlag == "Y") isEditFlag = 1;
	}
	/// �����  �����ѷ���
	if (BTFlag == 2){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").show();   /// ���� //hxy 2021-03-31 hide->show
		$("#bt_com").hide();   /// ���
		$("#bt_ceva").hide();  /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_can").show();   /// ȡ��
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").hide();  /// ���� hxy 2021-01-13 st
		$("#QueEmr3").hide();  /// ���� ed
		$("#bt_log").show();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		if(seeCstType!=2){
			$("#bt_reva").show();  /// ����
			$("#bt_sure").show();  /// ȷ��
			$("#ConsEvaR").show(); /// ���������
			$("#Opinion").show();  /// �������
		}
		PageEditFlag(2);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}

	/// ������ʾ
	if (BTFlag == 3){
		$("#bt_save").hide();  /// ����
		$("#bt_remove").hide(); ///ɾ��
		$("#bt_send").hide();  /// ����
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_reva").hide();  /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#ConsEvaR").hide(); /// ���������
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		
		$("#bt_acc").show();   /// ����
		$("#bt_ref").show();   /// �ܾ�
		$("#bt_arr").show();   /// ����
		$("#bt_com").show();   /// ���
		$("#bt_ceva").show();  /// ����
		$("#bt_ord").show();   /// ҽ��¼��
		$("#Opinion").show();  /// �������
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").show ();  /// ���� hxy 2021-01-13 st
		$("#QueEmr3").hide();   /// ���� ed
		$("#bt_TempLoc").show();   /// ����ģ��
		$("#bt_TempUser").show();  /// ����ģ��
		$("#bt_TempQue").show();   /// ѡ��ģ��
		$("#ConsEva").show();  	   /// ��������
		$("#bt_log").show();   /// ������־
		if ((CsStatCode == "����")||(CsStatCode == "ȡ�����")){
			$("#bt_revacc").show();/// ȡ������
		}else{
			$("#bt_revacc").hide();/// ȡ������
		}
		if ((CsStatCode == "����")||(CsStatCode == "���")||(CsStatCode=="�������")||(CsStatCode == "ȡ������")){
			$("#bt_ref").show();/// �ܾ�����
			$("#bt_acc").show();/// ����
		}else{
			$("#bt_ref").hide();/// �ܾ�����
			$("#bt_acc").hide();/// ����
		}
		if (CsStatCode == "���"){
			$("#bt_revcom").show();/// ȡ�����
		}else{
			$("#bt_revcom").hide();/// ȡ�����
		}
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
		$("#bt_reva").hide();  /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ceva").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#Opinion").show();  /// �������
		$("#QueEmr").hide();   /// ����
		$("#QueEmr2").hide();  /// ���� hxy 2021-01-13 st
		$("#QueEmr3").hide();  /// ���� ed
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#ConsEvaR").hide();     /// ���������
		$("#ConsEva").hide();  	   /// ��������
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		PageEditFlag(0);	   /// ҳ��༭
		isEditFlag = 1;	       /// �б༭��־
	}
	/// ҳ��Ĭ����ʾ
	if (BTFlag == 5){
		$("#bt_can").hide();   /// ȡ��
		$("#bt_sure").hide();  /// ȷ��
		$("#bt_reva").hide();  /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_ceva").hide();  /// ����
		$("#bt_acc").hide();   /// ����
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_arr").hide();   /// ����
		$("#bt_ord").hide();   /// ҽ��¼��
		$("#Opinion").hide();  /// �������
		$("#bt_openemr").hide();   /// ������Ȩ
		$("#bt_colseemr").hide();  /// �ر���Ȩ
		$("#bt_TempLoc").hide();   /// ����ģ��
		$("#bt_TempUser").hide();  /// ����ģ��
		$("#bt_TempQue").hide();   /// ѡ��ģ��
		$("#ConsEvaR").hide(); /// ���������
		$("#ConsEva").hide();  /// ��������
		$("#bt_log").hide();   /// ������־
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
	}
	
	/// ��Ժ�ʻ���  �����ѷ���
	if ((CstOutFlag == "Y")&(BTFlag == 2)&(IsPerAccFlag == 0)){
		$("#bt_acc").show();   /// ����
		//$("#bt_ref").show();   /// �ܾ�
		//$("#bt_arr").show();   /// ����
		$("#bt_com").show();   /// ���
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
	}
	
	/// ��������
	if (isEvaShowFlag == 1){
		$("#ConsEvaR").show(); /// ���������
		$("#ConsEva").show();  /// ��������
	}
		/// ϵͳ�����Ƿ���Ҫ��������
	if (WriEvaCsFlag == "0"){
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
	}
	
	/// ��ƻ���  �������ʾ
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 2)){

		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
		
		if (IsPerAccFlag == 0){
			$("#bt_acc").show();   /// ����
			$("#bt_arr").show();   /// ���� //hxy hxy 2021-03-30 ע�ͷſ�
			$("#bt_com").show();   /// ���
			$("#ConsEvaR").show(); /// ���������
			if ((CsStatCode == "����")||(CsStatCode == "ȡ�����")){
				$("#bt_revacc").show();/// ȡ������
			}else{
				$("#bt_revacc").hide();/// ȡ������
			}
			if (CsStatCode == "���"){
				$("#bt_revcom").show();/// ȡ�����
			}else{
				$("#bt_revcom").hide();/// ȡ�����
			}
	    }
	}
	
	/// ��ƻ���  ������ʾ
	if ((MulWriFlag == 1)&(CstMorFlag == "Y")&(BTFlag == 3)){
		$("#bt_ref").hide();   /// �ܾ�
		$("#bt_ceva").hide();  /// ����
		$("#ConsEva").hide();  /// ��������
		
		$("#bt_acc").hide();   /// ����
		//$("#bt_arr").show();   /// ����
		$("#bt_com").hide();   /// ���
		$("#bt_revacc").hide();/// ȡ������
		$("#bt_revcom").hide();/// ȡ�����
		$("#bt_arr").hide();   /// ���� hxy 2021-03-31
	}
	
	if (BTFlag == 4){
		$HUI.combobox("#HospArea").enable(); 	  /// Ժ��
	}
	
	/// �����ӱ�IDΪ��ʱ������ʾ������־��ť
	if (CstItmID == ""){
		$("#bt_log").hide();   /// ������־
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
	}
	
	///��ɰ�ť
	if(ConsUseStatusCode.indexOf("^50^")==-1){
		$("#bt_precom").hide();	 ///Ԥ���
		$("#bt_com").hide();	 ///���
		$("#bt_revcom").hide();	 ///ȡ�����
	}
	
	///��������
	if(ConsUseStatusCode.indexOf("^55^")==-1){
		$("#bt_ceva").hide();   ///��������
		$("#ConsEva").hide();	 	///��������
	}
	
	
	///ȷ��
	if(ConsUseStatusCode.indexOf("^60^")==-1){
		$("#bt_sure").hide();   ///ȷ��
	}
	
	///����
	if(ConsUseStatusCode.indexOf("^70^")==-1){
		$("#bt_reva").hide();   ///����
		$("#ConsEvaR").hide;	 ///��������
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
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var lnk="emr.record.browse.patient.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;//hxy 2023-02-11 Token����
	if ('undefined'!==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken();
	}
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-5) +', width='+ (window.screen.availWidth-5) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ���λ���
function PatHisCst(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var lnk="dhcem.consultpathis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&CsType=Nur";//hxy 2023-02-11 Token����
	if ('undefined'!==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken();
	}
	window.open(lnk, 'newWin', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=50, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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
		$HUI.combobox("#CstType").enable(); //hxy 2021-04-09 ע�ͷſ� ��ʿ����-���ﴦ��-�ѱ���δ���͵����뵥�������޸Ļ������ͣ�
		$HUI.combobox("#CstGrp").enable(); 	      /// ר��С��
	}else{
		//$("#ConsTrePro").attr("disabled",true);   /// ��Ҫ����
		$("#ConsTrePro").prop("readonly",true);
		//$("#ConsPurpose").attr("disabled",true);  /// ����Ŀ��
		$("#ConsPurpose").prop("readonly",true);
		$("#CstUser").attr("disabled", true);       /// ��ϵ��
		$("#CstTele").attr("disabled", true);		/// ��ϵ�绰
		$HUI.radio("input[name='CstEmFlag']").disable();
		$HUI.combobox("#CstType").disable();        /// ��������
		$HUI.combobox("#CstGrp").disable();         /// ר��С��
	}
	if ((Flag != 0)&(CstOutFlag != "Y")&((isOpiEditFlag != "Y"))){
		$("#ConsOpinion").prop("readonly",true);  /// �������
	}else{
		$("#ConsOpinion").prop("readonly",false);   /// �������
		if(isOpiEditFlag != "Y"){ //hxy 2021-03-04 ����״̬����ʱ,����״̬�Ļ��ﲻӦ����д�������(���ջᶪʧ����)��
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
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return;	
	}
}

/// ��֤�����Ƿ�����ҽ��
function PatNotTakOrdMsg(TipFlag){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if ((TakOrdMsg != "")&(TipFlag == 1)){
		$.messager.alert("��ʾ",TakOrdMsg,"warning");
		return false;	
	}
	return true;
}

/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCEMConsultCom","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){ //hxy 2020-08-05 ԭ��web.DHCAPPExaReport

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
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('ѡ��', 'symwin', '260', '130', option).Init();
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymLoc(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	var Params=ConsOpinion+"^"+session['LOGON.CTLOCID']+"^"
	
	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���","info");
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

/// �������߿���ģ��   qiaoqingao  2018/08/20
function saveSymUser(){
	
	var ConsOpinion=$("#ConsOpinion").val();  // ��Ϣ
	var Params=ConsOpinion+"^^"+session['LOGON.USERID']

	runClassMethod("web.DHCEMConsult","SaveCOT",{"Params":Params},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���","info");
		}if (jsonString=="-1"){
			$.messager.alert("��ʾ","�����Ѵ��ڣ�","warning");
		}
	},'',false)
}

///������Ŀ��ģ��    qiaoqingao  2018/08/20
function showmodel(flag){
		
	if($('#winonline').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'ģ���б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	var link="dhcem.consultcottemp.csp"; //hxy 2023-02-11 Token���� st
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src='+link+'></iframe>'; //ed
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
	
	if((CsStatCode=="")||(CsStatCode=="����")||(CsStatCode.indexOf("���")!=-1)||(CsStatCode=="����")||(CsStatCode=="�ܾ�")||(CsStatCode=="����")||(CsStatCode=="ȡ������")||(CsStatCode=="����")||(CsStatCode=="ȡ�����")){
		if(ConsNoCompCanPrt==1){
			$.messager.alert("��ʾ","����δ���,���ܴ�ӡ��","warning");
			return;
		}
	}
	
	var cstType=$("#CstType").combobox("getText");
	
	if((CstMorFlag=="Y")&&(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))){ //hxy 2021-03-16 st
		CstItmID="";
	} //ed
	
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
		var lnk="dhcem.printconsone.csp?CstItmIDs="+txtData+"&CsType=Nur"+"&LgHospID="+LgHospID;//hxy 2023-02-11 Token���� st
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		window.open(lnk); //hxy 2021-03-17 add LgHospID //ed
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

/// ������ϴ���
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

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
		var EmFlag = itmArr[j].itmDesc.indexOf("��") != -1?"Y":"N";
		itemhtmlArr.push("<input id='"+ itmArr[j].itmID +"' class='hisui-radio' type='radio' label='"+ itmArr[j].itmDesc +"' value='"+ EmFlag +"' name='CstEmFlag'>");
	}
    $("#itemProp").html(itemhtmlArr.join(""));
    $HUI.radio("#itemProp input.hisui-radio",{});
}

/// ������
function nuremr_click(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ","����ѡ���ˣ�","warning");
		return;
	}
	
	/// �°�
	var link = "nur.hisui.nursingrecords.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	if ('undefined'!==typeof websys_getMWToken){ //hxy 2023-02-11 Token����
		link += "&MWToken="+websys_getMWToken();
	}
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');

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
				}
			},'json',false)
		}
	});
}

///�Ƿ������޸Ļ������
function isCanUpdConsLoc(){
	var ret=true;
	var grpID =$HUI.combobox("#CstGrp").getValue();
	if((grpID!="")&&(GrpAllowUpd!=1)) ret=false;
	if (isEditFlag==1) ret=false;
	return ret;
}

///hxy 2021-04-02 ���ﰴť������ʱ����������ʱ�䲻�ɱ༭
function ArrTimeDisOrEnByBtn(){
	/// ���ﵽ��ʱ�� hxy 2021-04-01 st
	var RListFlag="N"; //�����б��־
	if(parent.$("button:contains('"+$g("�����б�")+"')").hasClass("btn-blue-select"))RListFlag="Y";
	if(((ModArrTime==3)||((ModArrTime==1)&&(RListFlag=="Y"))||((ModArrTime==2)&&(RListFlag=="N")))&&((!$('#bt_arr').linkbutton('options').disabled)&&$("#bt_arr").is(":visible"))){
		$HUI.datebox("#CstArrDate").enable(); 
		$HUI.timespinner("#CstArrTime").enable();
	}else{
		$HUI.datebox("#CstArrDate").disable(); 
		$HUI.timespinner("#CstArrTime").disable();
	} //ed
}

window.onload = onload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
