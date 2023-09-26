
//����	DHCPEFetchReportDetail.js
//����	��ȡ����Ϣ
//���  DHCPEFetchReportDetail.js
//����	2018.09.07
//������  xy


function BodyLoadHandler(){
	var obj; 
	
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click; } 

}

function BSave_click()
{
	 var obj;
	 var iName="",iTel="",iIDCard="";
	 
	 var iReportStatus=getValueById("ReportStatus");
	if(iReportStatus.indexOf("��ȡ")<0){
		$.messager.alert("��ʾ","���滹δ��ȡ,���ܱ�����ȡ����Ϣ","info");
		return false;
		}
			
	 //��ȡ������
	 var iName=getValueById("Name");
	if(iName==""){
		$.messager.alert("��ʾ","��������Ϊ��!","info",function(){
			$("#Name").focus();
		});
		return false;
	}
	
	//��ȡ�˵绰
	 var iTel=getValueById("Tel");
	 iTel=trim(iTel);
	if (iTel==""){
		$.messager.alert("��ʾ","�绰����Ϊ��!","info",function(){
			$("#Tel").focus();
		});
		return false;
	}else{
		
		if (!CheckTelOrMobile(iTel,"Tel","")) return false;
	}
	
	
	//��ȡ�����֤��
	var iIDCard=getValueById("IDCard");
	
	if(iIDCard==""){
		$.messager.alert("��ʾ","���֤�Ų���Ϊ��!","info",function(){
			$("#IDCard").focus();
		});
		return false;
	}else{
		var myIsID=isIdCardNo(iIDCard);
		
				if (!myIsID){
					$("#IDCard").focus();
					return false;
				}
	}
	
	
	
	
	
	//����ID
	var iReportID=getValueById("ReportID");
	
	//alert(iReportID+"iReportID")
	var CRMID=tkMakeServerCall("web.DHCPE.CA.HandSign","GetCRMADMByRPTID",iReportID);
	//alert(CRMID+"CRMID")
	var SignFlag=Sign(CRMID)
	
	var Instring=iReportID
	            +"^"+trim(iName)	
				+"^"+trim(iTel)			
				+"^"+trim(iIDCard)			
				;	
				//alert(Instring)
	var flag=tkMakeServerCall("web.DHCPE.FetchReport","UpdateFetchReportInfo",Instring,"1");	
    if(flag=="0") {
	    $.messager.alert("��ʾ","�����ɹ�","success");
	    $("#tDHCPEFetchReportDetail").datagrid('load',{ComponentID:56785,ReportID:iReportID});
	
	   //location.reload(); 
    }
}


function isIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
	    $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info"); 
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
	    $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info"); 
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("��ʾ","���֤�������","info"); 
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			$.messager.alert("��ʾ","���֤��������,����!","info");  
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			$.messager.alert("��ʾ","���֤��������,����!","info"); 
			return false;
		}
	}
	return true;
}

//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
	
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
 	
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
		return true; 
	} 
}


function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var ReportID=rowdata.TReportID;
		setValueById("ReportID",ReportID);
		
	    var Name=rowdata.TName;
		setValueById("Name",Name);
		
		 var Name=rowdata.TName;
		setValueById("Name",Name);
		
		 var Tel=rowdata.TTel;
		setValueById("Tel",Tel);
		
		var IDCard=rowdata.TIDCard;
		setValueById("IDCard",IDCard);
		
	  
		
	}else
	{
		SelectedRow=-1;
	
	}


}


function Sign(CRM)
{
	var ID="";
	var encmeth="",obj;
	//var CRM=e.id;
	//alert(CRM+"CRM")
	var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			alert('��������дǩ���豸');
			return;
		}

			try {
			// ��ȡͼƬ
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);

			//var CRM=dialog
			
			//// DHCPEHandSignMassage ��Code
			var TypeCode="01";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '����';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// ��ȡ�༭��hash
			
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode,"","",CRM)
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
			//alert(err.message);
		}
		//alert("ǩ���ɹ�")
		//BFind_click();
}

document.body.onload = BodyLoadHandler;
