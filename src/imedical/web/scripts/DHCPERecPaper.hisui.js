
//����	DHCPERecPaper.hisui.js
//����	�ձ�hisui
//����	2019.10.15
//������  xy

$(function(){
		
	InitCombobox();
	
	//�ձ��¼�б�
	InitRecPaperDataGrid();
	
	//�����¼�б�
	InitPIADMRecordDataGrid();
            
     //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });  
        
    //��ӡ
	$("#BPrint").click(function() {	
		BPrint_click();		
        });
		
	//����
    $("#BYQAll").click(function() {
			YQAll_click();	
		});
         
    //�ձ�
	$("#BRecpaper").click(function() {	
		BRecpaper_click();		
        });
   
   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_click();
				}
	});
	
	//��ȷ���ձ�
   	$("#ConfirmRecPaper").keydown(function(e) {
			
			if(e.keyCode==13){
				ConfirmRecPaper_KeyDown();
				}
		});
		
	//Ĭ���ʹ﷽ʽ
	$("#SendMethod").combobox('setValue',"ZQ");
   
   //Ĭ�ϱ���Լ��
	DefaultReportDate();
	
	//Ĭ�ϲ�ѯʱ��Ϊ����
    Initdate();
    
     $("#ALLPerson").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLGroup").checkbox('setValue',false);}
	       	 		        
        	}
        });
		
    $("#ALLGroup").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLPerson").checkbox('setValue',false);}
	       	 		        
        	}
        }); 

})
function YQAll_click()
{
	var UserID=session['LOGON.USERID'];
	var today = getDefStDate(0);
	var PAADM=$("#PAADM").val();
	if(PAADM==""){
		$.messager.alert("��ʾ","��ѡ������ڵ���Ա","info"); 
		return false;
	}

	var YQDate=$("#YQDate").datebox('getValue')
	if(YQDate==""){
		$.messager.alert("��ʾ","��ѡ����������","info");	
		return false;
	}

	var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
	var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",YQDate);
	if(YQDateLogical<=todayLogical){
		$.messager.alert("��ʾ","��������Ӧ���ڽ���","info");	
		return false;
	}

	var IfComplateAll=$("#IfComplateAll").combobox('getValue');
	if(IfComplateAll==""){
		$.messager.alert("��ʾ","��ѡ���Ƿ�������ܼ�","info");	
		return false;
	}

	var ret=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",$("#PAADM").val(),YQDate,IfComplateAll,"",UserID)
	if((ret>0)||(ret==0)){
		$.messager.alert("��ʾ","���ڳɹ�","success");	
	}else{
		$.messager.alert("��ʾ","����ʧ��","error");	
		return false;
	}
	var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	
	$("#RefuseItemInfoYQ").text(RefuseItemYQ);
	KeyWordsLoadYQ();
}

function BRecpaper_click()
{	
	
	var PAADM=$("#PAADM").val();
	if(PAADM==""){
			$.messager.alert("��ʾ","��ѡ����ձ�ľ����¼","info");
		   return false;
		}
		
		
	/*	
	// ����ǩ��begin
	var rtn=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	var items=rtn.split(";")[0]
	if(items!=""){
		var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			alert('��������дǩ���豸');
			return true;
		}
			//alert(2)
			try {
			// ��ȡͼƬ
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);
			var PatInfos=tkMakeServerCall("web.DHCPE.CA.HandSign","GetCRMADMAndNameByPAADM",ipaadm);
			var CRM=PatInfos.split("^")[0];
			var Name=PatInfos.split("^")[1];
			//// DHCPEHandSignMassage ��Code
			var TypeCode="02";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '����';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// ��ȡ�༭��hash
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode,Name,items)
			//alert("signinfo"+signinfo)
			var record=tkMakeServerCall("web.DHCPE.CA.HandSign","RecordInfo",CRM,signinfo)
			var signInfo = HashData(signinfo);
				isSigned = true;
				// ǩ��
				var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo);
				if ('' == signValue)
					return;
				signValue = $.parseJSON(signValue);
				//debugger;
				// ���̨����
				
				
				var argsData = {
					Action: 'SaveSign',
					CRM: CRM,
					Code:TypeCode,
					Algorithm: handSignInterface.getAlgorithm(signValue),
					BioFeature: handSignInterface.getBioFeature(signValue),
					EventCert: handSignInterface.getEventCert(signValue),
					SigValue: handSignInterface.getSigValue(signValue),
					TSValue: handSignInterface.getTSValue(signValue),
					Version: handSignInterface.getVersion(signValue),
					SignScript: img,
					HeaderImage: headerImage,
					Fingerprint: fingerImage,
					PlainText: signInfo
				};
				
				$.ajax({
					
					type: 'POST',
					dataType: 'text',
					url: '../web.DHCPE.CA.HandSign.cls',
					async: true,
					cache: false,
					data: argsData,
					success: function (ret) {
						//alert("11ret"+ret)
						ret = $.parseJSON(ret);
						//alert("ret"+ret)
						if (ret.Err || false) {
							throw {
								message : 'SaveSignInfo ʧ�ܣ�' + ret.Err
							};
						} else {
							if ('-1' == ret.Value) {
								throw {
									message : 'SaveSignInfo ʧ�ܣ�'
								};
							} else {
								var signId = ret.Value;
								//parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
							}
						}
					},
					error: function (err) {
						throw {
							message : 'SaveSignInfo error:' + err
						}; 
					}
				});
				} catch (err) {
			//debugger
			if (err.message === '�û�ȡ��ǩ��,�����룺61') {
				return;
			}
			else if (isSigned) {
				//parEditor.unSignedDocument();
			}
			//alert(err.message);
		}
		
		
		
		
		
		}
	// ����ǩ��end
	*/
	
	var iReportDate=$("#ReportDate").datebox('getValue')
	var iSendMethod=$("#SendMethod").combobox("getValue"); 
	if (($("#SendMethod").combobox("getValue")==undefined)||($("#SendMethod").combobox("getValue")=="")){var iSendMethod="";}
	
	if(iReportDate==""){
		$.messager.alert("��ʾ","��ѡ�񱨸�Լ��","info");
		   return false;
		}
	if(iSendMethod==""){
		$.messager.alert("��ʾ","��ѡ���ʹ﷽ʽ","info");
		   return false;
		}
	var iRemark=$("#Remark").val();
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaperNew",PAADM,iReportDate,iSendMethod,iRemark);
	var ret=Return.split("#");
	if (ret[0]!=0)
	{ 
		$.messager.alert("��ʾ",ret[0],"info");
    }else{
	    	$.messager.alert("��ʾ","�ձ�ɹ�","success");
	    	var flag=tkMakeServerCall("web.DHCPE.TransResult","TransMain",PAADM);
	    	if(ret[1]=="Y"){
		    	var value=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetBaseInfo",PAADM,iReportDate);
		    	if(value!=""){PrintGetReportPT(value); }//��ӡȡ����ƾ��
	    	}
	    	
	    }
	  
	  
	  //ˢ���ձ�����
     BFind_click();
    
	 if($("#ConfirmRecPaper").val()!=""){
		//ˢ�¾����¼����
		var PADM="";
		 var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",$("#ConfirmRecPaper").val());
		if (PADMS.split("^")[0]!="0"){
			alert(PADMS.split("^")[1]);
			return false;
		}
		var PADM=PADMS.split("^")[1];
		 loadPIADMRecord(PADM);
     }
     //�������
     BClear();
}

function BClear()
{
	$("#PAADM").val("");
	$("#NoSummitStationInfo").text("");
	$("#RefuseItemInfo").text("");
	$("#Remark").val("");

	//Ĭ�ϱ���Լ��
	DefaultReportDate();

	 KeyWordsLoad();
	 KeyWordsLoadYQ();
}

function ConfirmRecPaper_KeyDown()
{
	
	var iReportDate="",iRegNo="";
	
	var iRegNo=$("#ConfirmRecPaper").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#ConfirmRecPaper").val(iRegNo)
		}	
	if (iRegNo=="") 
	   {
			$.messager.popover({msg: "������ǼǺ�", type: "info"});
		   //$.messager.alert("��ʾ","������ǼǺ�","info");
		   return false;
	   }
		var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",iRegNo);
		if (PADMS.split("^")[0]!="0"){
			//alert(PADMS.split("^")[1]);
			$.messager.popover({msg: PADMS.split("^")[1], type: "info"});
			return false;
		}
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
			//$.messager.alert("��ʾ","û��Ҫ�ձ�ļ�¼","info");
			$.messager.popover({msg: "û��Ҫ�ձ�ļ�¼", type: "info"});
			return false;
			}
		var PADMArr=PADM.split("$");
		
		loadPIADMRecord(PADM);
		if (PADMArr.length>2){
           
   
		}
		else{
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PADMArr[0]); 
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		
       if(Flag!=""){
	       		var RefuseItem="",NoSummitStation="";
		       //δ�ύվ��
				var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",PAADM);
				var NoSummitStation=NoSummitStationStr.split("^")[1];
				$("#NoSummitStationInfo").text(NoSummitStation)
				//л�������Ŀ
	            var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	            $("#RefuseItemInfo").text(RefuseItem)
	            //л�����ؼ����б�̬��ʾ
	            $("#PAADM").val(PAADM);
				var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	            	
	            $("#RefuseItemInfoYQ").text(RefuseItemYQ)
	            
	            //л�����ؼ����б�̬��ʾ
	            $("#PAADM").val(PAADM);
	            KeyWordsLoad();
				KeyWordsLoadYQ();
				
	       
       		}
		}
		
		}
	
			
	
}


function InitPIADMRecordDataGrid()
{
	$HUI.datagrid("#PIADMRecordQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [], //������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		queryParams:{
			ClassName:"web.DHCPE.PreIADMEx",
			QueryName:"SearchPreIADM",	
		},
		frozenColumns:[[
			{field:'PIBIPAPMINo',width:100,title:'�ǼǺ�'},
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
		    {field:'PIADMPIBIDR',title:'PIADMPIBIDR',hidden: true}, 
			{field:'PIADMPIBIDRName',width:100,title:'����'},
			{field:'PIADMPGADMDRName',width:200,title:'��������'},
			{field:'PIADMPGTeamDRName',width:120,title:'��������'},
			{field:'PIADMPEDateBegin',width:100,title:'�������'},
			{field:'PIADMOldHPNo',width:120,title:'����'},	
		]],
		onSelect: function (rowIndex, rowData) {
			var PatNo=rowData.PIBIPAPMINo;
			var PIADM=rowData.id;
			
			var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PIADM);
			$("#PAADM").val(PAADM);
			var Flag=""
			if (PAADM!="")
			{
				var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
			}
		       var RefuseItem="",NoSummitStationSt="";
		       //δ�ύվ��
				var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",PAADM);
				$("#NoSummitStationInfo").text("");
				$("#RefuseItemInfo").text("");
				if(NoSummitStationStr.indexOf("^")!="-1"){
					var NoSummitStation=NoSummitStationStr.split("^")[1];
					$("#NoSummitStationInfo").text(NoSummitStation);
				}

				//л�������Ŀ
	            var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	            $("#RefuseItemInfo").text(RefuseItem)
	             //���ڼ����Ŀ
	            var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	            $("#RefuseItemInfoYQ").text(RefuseItemYQ)
	            //л�����ؼ����б�̬��ʾ
				KeyWordsLoad();
				//������δ����Ŀ�ؼ����б�̬��ʾ
				KeyWordsLoadYQ();
				$('#YQDate').datebox('setValue','');
				$("#Remark").val("");
				DefaultReportDate();
			
		},
		onLoadSuccess: function (data) {
	        
	        $("#PIADMRecordQueryTab").datagrid("selectRow",0); //Ĭ��ѡ�е�һ�� 
			
		}
	
	})
}

function loadPIADMRecord(PIADMs) {
	
	$('#PIADMRecordQueryTab').datagrid('load', {
		ClassName: 'web.DHCPE.PreIADMEx',
		QueryName: 'SearchPreIADM',
		PIADMs: PIADMs,
		
	});
		
}

//л�����ؼ����б�̬��ʾ
function KeyWordsLoad()
{	
	var UserID=session['LOGON.USERID'];

		$.cm({	
			ClassName: 'web.DHCPE.ResultEdit',
			MethodName: 'GetUnAppedItemsHisui',
			EpisodeID:$("#PAADM").val(),
			StationID:"",
			OEFlag:"1",
			LabRecFlag:"1",
		},function(data){
			$('#keywords').keywords({
    				items:data,
   				 	onSelect:function(v){
	   				 
	   				 $.messager.confirm("ȷ��", "ȷʵҪ����'"+v.text+"'��", function(r){
					if (r){
						var OEID=v.id;
						var OEID=OEID.replace('-', '||');
						var ret=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEID,"",UserID);
						 var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",$("#PAADM").val());
	            		$("#RefuseItemInfo").text(RefuseItem);
						 //δ�ύվ��
	            		var NoSummitStationStr=""
						var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",$("#PAADM").val());
						$("#NoSummitStationInfo").text("");
						if(NoSummitStationStr.indexOf("^")!="-1"){
								var NoSummitStation=NoSummitStationStr.split("^")[1];
								$("#NoSummitStationInfo").text(NoSummitStation);
						}
	            		KeyWordsLoad();
	            		var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",$("#PAADM").val());
						//debugger; ///  
						$("#RefuseItemInfoYQ").text(RefuseItemYQ);
						KeyWordsLoadYQ();
			
					
						}
					});
	   				 	
   				 	}	 
			});
		});
		
		
}
//���ڼ��ؼ����б�̬��ʾ
function KeyWordsLoadYQ()
{	

		$.cm({	
			ClassName: 'web.DHCPE.OrderPostPoned',
			MethodName: 'GetDelayItems',
			PAADM:$("#PAADM").val()	
		},function(data){
	
			$('#keywordsYQ').keywords({
				
    				items:data,
   				 	onSelect:function(v){
	   			
						var OEID=v.id;
						var OEID=OEID.replace('-', '||');
						var YQDate=$("#YQDate").datebox('getValue')
						if(YQDate==""){
							$.messager.alert("��ʾ","��ѡ����������","info");	
							return false;
						}
						var today = getDefStDate(0);
						var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
						var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",YQDate);
						if(YQDateLogical<=todayLogical){
							$.messager.alert("��ʾ","��������Ӧ���ڽ��죡","info");	
							return false;
						}
						
						var IfComplateAll=$("#IfComplateAll").combobox('getValue');
						if(IfComplateAll==""){
							$.messager.alert("��ʾ","��ѡ���Ƿ�������ܼ죡","info");	
							return false;
						}
						var UserID=session['LOGON.USERID'];
						var ret=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",$("#PAADM").val(),YQDate,IfComplateAll,OEID,UserID);
						
						 var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",$("#PAADM").val());
						
	            		$("#RefuseItemInfoYQ").text(RefuseItemYQ);
	            		
	            		KeyWordsLoadYQ();
			
				
	   				 	
   				 	}	 
			});
		});
		
		
}

function CancelPaper(PIADM)
{
	
	if (PIADM=="")	{
		$.messager.alert("��ʾ","��ѡ���ȡ���ձ�Ŀͻ���","info");
		return false
	} 
	else{ 
		$.messager.confirm("ȷ��", "ȷ��Ҫȡ����", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.DHCPEIAdm", MethodName:"CancelRecPaper",PIADM:PIADM},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ȡ���ձ�ʧ�ܣ�"+flag,"error");  
				}else{
					$.messager.popover({msg: 'ȡ���ձ�ɹ���',type:'success',timeout: 1000});
					BFind_click();
     
				}
			});	
		}
	});
	}
		

}



//��ѯ
function BFind_click(){
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}
	 var HospID=session['LOGON.HOSPID'];
	$("#RecPaperQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.DHCPEIAdm",
			QueryName:"SearchGPaperByRecDate",
			RecBegDate:$("#RecBegDate").datebox('getValue'),
			RecEndDate:$("#RecEndDate").datebox('getValue'),
			txtRegNo:$("#RegNo").val(),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			ALLGroup:$HUI.checkbox('#ALLGroup').getValue() ? "on" : "",
			ALLPerson:$HUI.checkbox('#ALLPerson').getValue() ? "on" : "",
			HospID:HospID
			})
	
}

function InitRecPaperDataGrid()
{
	var HospID=session['LOGON.HOSPID'];
	$HUI.datagrid("#RecPaperQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.DHCPEIAdm",
			QueryName:"SearchGPaperByRecDate",
			RecBegDate:$("#RecBegDate").datebox('getValue'),
			RecEndDate:$("#RecEndDate").datebox('getValue'),
			txtRegNo:$("#RegNo").val(),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			ALLGroup:$HUI.checkbox('#ALLGroup').getValue() ? "on" : "",
			ALLPerson:$HUI.checkbox('#ALLPerson').getValue() ? "on" : "",
			HospID:HospID
		},
		frozenColumns:[[
			{field:'CancelPaper',title:'ȡ���ձ�',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if((rowData.PIADM!="")&&(rowData.TReceiver!="")){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="ȡ���ձ�" border="0" onclick="CancelPaper('+rowData.PIADM+')"></a>';
					
					}
				}},
			{field:'TAdmNo',width:100,title:'�ǼǺ�'},
			{field:'TPatNAME',width:80,title:'����'},
		]],
		columns:[[
	
		    {field:'PIADM',title:'PIADM',hidden: true},
		   
			{field:'TSex',width:45,title:'�Ա�'},
			{field:'TReceiver',width:80,title:'�ձ���'},
			{field:'TReceivedDate',width:100,title:'�ձ�����'},
			{field:'TAge',width:45,title:'����',align:'center'},
			{field:'TGDesc',width:200,title:'��������'},
			{field:'TPosition',width:80,title:'����'},
			{field:'TTel',width:120,title:'��ϵ��ʽ'},
			{field:'TReportDate',width:100,title:'����Լ��'},
			{field:'TVip',width:80,title:'VIP�ȼ�'},
			{field:'TSendMethod',width:80,title:'���ͷ�ʽ'},
			{field:'TOrdSet',width:160,title:'�ײ�����'},
			{field:'TAmount',width:90,title:'Ӧ�ս��',align:'right'},
			{field:'TRemark',width:320,title:'��ע'}
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})

}


function InitCombobox()
{
	  // VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	})
	
	// �Ƿ�������ܼ�
	var IfComplateAll = $HUI.combobox("#IfComplateAll",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'Y',text:$g('��')},
            {id:'N',text:$g('��')}
            
           
        ]

	});
	
	//�ʹ﷽ʽ
	var SendMethodObj = $HUI.combobox("#SendMethod",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'ZQ',text:$g('��ȡ')},
            {id:'TQ',text:$g('ͳȡ')},
            {id:'KD',text:$g('���')},
            {id:'DY',text:$g('����')},
            {id:'DZB',text:$g('���Ӱ�')}
           
        ]

	});
		
	
}

//Ĭ�ϱ���Լ��
function DefaultReportDate()
{
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
	var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate);
	var CurDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",parseInt(CurDate)+7);
   	$("#ReportDate").datebox('setValue',CurDate);
	 //Ĭ���ʹ﷽ʽ
	$("#SendMethod").combobox('setValue',"DZB");
	//Ĭ��ȫ���������ܼ�
	$("#IfComplateAll").combobox('setValue',"Y");
}

//����Ĭ��ʱ��Ϊ����
function Initdate()
{
	var today = getDefStDate(0);
	$("#RecBegDate").datebox('setValue', today);
	$("#RecEndDate").datebox('setValue', today);
}


function BPrintNew_click(){
	
		var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
		if(RowsLen==0){
			$.messager.alert("��ʾ","�˴β�ѯ���Ϊ��","info");	
	   		return;
		} 
	var iArrivedFlag="�ձ�";
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag) {iArrivedFlag="δ�ձ�";}
	var BegDate=$("#RecBegDate").datebox('getValue')
	var EndDate=$("#RecEndDate").datebox('getValue')


	var HosName=""
	var HOSPID=session['LOGON.HOSPID']
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
    
	   var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	   var Templatefilepath=prnpath+'DHCPERecPaper.xls';
		var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
		 "xlSheet.Cells(1,1)='"+HosName+" "+BegDate+"--"+EndDate+iArrivedFlag+"ͳ������';"
    
	 var ret=""
	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		if(ret==""){
			k=k+1;
			 ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+  
			 	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+  
			 	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+  
			 	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"+
			 	"xlSheet.Cells("+k+",5).Value='"+tempcol[4]+"';"+  
			 	"xlSheet.Cells("+k+",6).Value='"+tempcol[5]+"';"+  
			 	"xlSheet.Cells("+k+",7).Value='"+tempcol[6]+"';"+  
			 	"xlSheet.Cells("+k+",8).Value='"+tempcol[7]+"';"+  
			 	"xlSheet.Cells("+k+",9).Value='"+tempcol[8]+"';"+  
			 	"xlSheet.Cells("+k+",10).Value='"+tempcol[9]+"';"+  
			 	"xlSheet.Cells("+k+",11).Value='"+tempcol[10]+"';" 
		}else{
			k=k+1;
			ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+  
			 	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+  
			 	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+  
			 	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"+
			 	"xlSheet.Cells("+k+",5).Value='"+tempcol[4]+"';"+  
			 	"xlSheet.Cells("+k+",6).Value='"+tempcol[5]+"';"+  
			 	"xlSheet.Cells("+k+",7).Value='"+tempcol[6]+"';"+  
			 	"xlSheet.Cells("+k+",8).Value='"+tempcol[7]+"';"+  
			 	"xlSheet.Cells("+k+",9).Value='"+tempcol[8]+"';"+  
			 	"xlSheet.Cells("+k+",10).Value='"+tempcol[9]+"';"+  
			 	"xlSheet.Cells("+k+",11).Value='"+tempcol[10]+"';" 
		}
		
		
	}  
	
	var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",11)).Borders.LineStyle='1';"+
             "xlSheet.PrintOut();"+
          	"xlBook.Close(savechanges=false);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
      //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
       CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return ; 
	
}
//��ӡ
function BPrint_click()
{  
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
	   var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	   var Templatefilepath=prnpath+'DHCPERecPaper.xls';
	
		xlApp = new ActiveXObject("Excel.Application");  //�̶�
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
     
 
	var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
	if(RowsLen==0){		
		alert("�˴β�ѯ���Ϊ��")
	   	return;
	} 
	var iArrivedFlag="�ձ�";
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag) {iArrivedFlag="δ�ձ�";}
	var BegDate=$("#RecBegDate").datebox('getValue')
	var EndDate=$("#RecEndDate").datebox('getValue')


	var HosName=""
	var HOSPID=session['LOGON.HOSPID']
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID)

	xlsheet.cells(1,1)=HosName+" "+BegDate+"--"+EndDate+iArrivedFlag+"ͳ������"

	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		k=k+1;
		xlsheet.Rows(k).insert(); 
		xlsheet.cells(k,1)=tempcol[0];
		xlsheet.cells(k,2)=tempcol[1];
		xlsheet.cells(k,3)=tempcol[2];
		xlsheet.cells(k,4)=tempcol[3];
		xlsheet.cells(k,5)=tempcol[4];
		xlsheet.cells(k,6)=tempcol[5];
		xlsheet.cells(k,7)=tempcol[6];
		xlsheet.cells(k,8)=tempcol[7]; 
		xlsheet.cells(k,9)=tempcol[8];
		xlsheet.cells(k,10)=tempcol[9]; 
		xlsheet.cells(k,11)=tempcol[10];

		
	}   
	///ɾ�����Ŀ���
	xlsheet.Rows(k+1).Delete;

    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}else{
	BPrintNew_click()
}
}