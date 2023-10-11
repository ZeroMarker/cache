

//����	DHCPEYGHadKnow.hisui.js
//����	�Ҹ�֪��ͬ����hisui
//����	2021.01.21
//������  xy

$(function(){
		

	InitYGHadKnowGrid();
	    
     //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
           
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });  
          
        

   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				RegNoOnChange();
				}
	});
	
	
	$("#RegNo").focus();
	
	Info();
	
})


function RegNoOnChange()
{	
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		iRegNo=$("#RegNo").val();
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		} 

	var PADMS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPIADMByRegNo",iRegNo);
	var PADM=PADMS.split("^")[1];
	if (PADM==""){return false;}
	
	/// ����ǩ�� begin
			var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			//alert('��������дǩ���豸');
			$.messager.alert("��ʾ","��������дǩ���豸","success");
			return;
		}

			try {
				
			// ��ȡͼƬ
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);

			var CRM=PADM
			
			//// DHCPEHandSignMassage ��Code
			var TypeCode="03";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '����';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// ��ȡ�༭��hash
			
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode);
			var record=tkMakeServerCall("web.DHCPE.CA.HandSign","RecordInfo",CRM,signinfo);
			var signInfo = HashData(signinfo);
			
				isSigned = true;
				// ǩ��
				var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo);
				//alert("signValue: "+signValue)
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
				parEditor.unSignedDocument();
			}
			$.messager.alert("��ʾ",err.message,"success");
			
		}
		

	
	BFind_click();
	
	
}

function BClear_click()
{
	
	$("#RegNo").val("");
	$("#DateBegin").datebox('setValue',"");
	$("#DateEnd").datebox('setValue',"");
	BFind_click();
}

function Info()
{
	var YGDetail=tkMakeServerCall("web.DHCPE.CA.HandSign","GetYGHadKnowDetail");
	$("#YGDetail").val(YGDetail)
	
}


//��ѯ
function BFind_click(){
	

	$("#YGHadKnowGrid").datagrid('load',{
			ClassName:"web.DHCPE.CA.HandSign",
			QueryName:"SearchPreIADM",
			DateBegin:$("#DateBegin").datebox('getValue'),
			DateEnd:$("#DateEnd").datebox('getValue')
				
			})
	
}


function InitYGHadKnowGrid()
{
	$HUI.datagrid("#YGHadKnowGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		checkOnSelect: true, 
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CA.HandSign",
			QueryName:"SearchPreIADM",
			DateBegin:$("#DateBegin").datebox('getValue'),
			DateEnd:$("#DateEnd").datebox('getValue')
				
		},
	
		columns:[[
	
		    {field:'CRM',title:'CRM',hidden: true},
		    {field:'TRegNo',width:180,title:'�ǼǺ�'},
			{field:'TName',width:180,title:'����'},
			{field:'TDate',width:150,title:'��������'},
			{field:'TSignName',width:200,title:'ǩ��',
			formatter:function(value,rowData,rowIndex){
						var rvalue=tkMakeServerCall("web.DHCPE.CA.HandSign","OutSignScriptNew",rowData.CRM,"03");
						return rvalue;
						
						
			}}
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}


