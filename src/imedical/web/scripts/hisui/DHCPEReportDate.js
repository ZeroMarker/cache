
//名称	DHCPEReportDate.js
//组件  DHCPEReportDate
//功能  收表-确认界面
//创建	2018.09.13
//创建人  xy

function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("BConfirm"); //确认
	if (obj){ obj.onclick=BConfirm_click; }
	
	obj=document.getElementById("BCancle"); //确认
	if (obj){ obj.onclick=BCancle_click; }
	
	obj=document.getElementById("BSaveResult");
	if (obj){ obj.onclick=BSaveResult_click; }
	
	 obj=document.getElementById("ReportDate");
	if (obj){ obj.onkeydown=ReportDate_keydown; }
	
	
	document.onkeydown=Doc_OnKeyDown;
	SetFocus(); 
}
function RefuseItem(e)
{
	if (!confirm("确实要放弃'"+e.innerText+"'吗")) return false;
	var OEID=e.id;
	var ret=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEID);
	window.location.reload();
}
function SetFocus()
{
	var obj=document.getElementsByName('result'); 
	if (obj) ResultLength=obj.length;
	if (ResultLength>0){
		var ID=obj[0];
		websys_setfocus(ID); 
	}else{
		websys_setfocus("ReportDate"); 
	}
}
function Doc_OnKeyDown(){
	if (event.keyCode==13)
	{
		event.keyCode=9;
		
		document.onkeydown=Doc_OnKeyDown;
	}
	
}
function ReportDate_keydown()
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		websys_setfocus("BConfirm");  
	}
	
}

function BCancle_click()
{
	websys_showModal("close"); 
	return false 


}

function BSaveResult_click()
{
	var ResultLength=0,ResultObj,Result="",ResultID="";
	var obj=document.getElementsByName('result'); //.length
	if (obj) ResultLength=obj.length;
	var ResultStr="";
	for (var i=0;i<ResultLength;i++)
	{
		ResultObj=obj[i];
		Result=ResultObj.value;
		ResultID=ResultObj.id;
		var OneStr=ResultID+"#"+Result;
		if (ResultStr==""){
			ResultStr=OneStr;
		}else{
			ResultStr=ResultStr+"%"+OneStr;
		}
	}
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SaveResult",ResultStr);
	if (Return=="0"){
		
		window.location.reload();
		
		}
	else{
	alert(Return)
	}

}
function BConfirm_click()
{
	var obj;  
	var iReportDate="",iRegNo="",iSendMethod=""; 
 
	
	obj=document.getElementById("ReportDate");  
	if (obj){ iReportDate=obj.value; } 
	obj=document.getElementById("RegNo");  
	if (obj){ iRegNo=obj.value; }
	obj=document.getElementById("SendMethod"); 
	if (obj){ iSendMethod=obj.value; }
	obj=document.getElementById("PAADM"); 
	if (obj){ ipaadm=obj.value; }

	// 患者签名begin
	var rtn=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",ipaadm);
	var items=rtn.split(";")[0]
	if(items!=""){
		var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			alert('请配置手写签名设备');
			return true;
		}
			//alert(2)
			try {
			// 获取图片
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);
			var PatInfos=tkMakeServerCall("web.DHCPE.CA.HandSign","GetCRMADMAndNameByPAADM",ipaadm);
			var CRM=PatInfos.split("^")[0];
			var Name=PatInfos.split("^")[1];
			//// DHCPEHandSignMassage 的Code
			var TypeCode="02";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '患者';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// 获取编辑器hash
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode,Name,items)
			//alert("signinfo"+signinfo)
			var record=tkMakeServerCall("web.DHCPE.CA.HandSign","RecordInfo",CRM,signinfo)
			var signInfo = HashData(signinfo);
				isSigned = true;
				// 签名
				var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo);
				if ('' == signValue)
					return;
				signValue = $.parseJSON(signValue);
				//debugger;
				// 向后台保存
				
				
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
								message : 'SaveSignInfo 失败！' + ret.Err
							};
						} else {
							if ('-1' == ret.Value) {
								throw {
									message : 'SaveSignInfo 失败！'
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
			if (err.message === '用户取消签名,错误码：61') {
				return;
			}
			else if (isSigned) {
				//parEditor.unSignedDocument();
			}
			//alert(err.message);
		}
		
		
		
		
		
		}
	// 患者签名end

	//alert(iRegNo+"^"+iReportDate+"^"+iSendMethod)
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaperNew",ipaadm,iReportDate,iSendMethod);
	if (Return!=0)
	{   
		alert(Return);
    }
	websys_showModal("close"); 
	return true 
	 
	
	
}
document.body.onload = BodyLoadHandler;