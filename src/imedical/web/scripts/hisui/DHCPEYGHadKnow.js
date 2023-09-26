
//名称	DHCPEYGHadKnow.js
//组件  DHCPEYGHadKnow
//功能	乙肝知情同意书，记录患者签名
//创建	2020.02.24
//创建人  sxt

document.body.onload = BodyLoadHandler;


function BodyLoadHandler() {
	
	//设置按钮大小
	//$("#BFind").css({"width":"150px"});
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_keydown; }
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	websys_setfocus("RegNo")
	
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	var encmeth="",RegNo="";
	
	if ((9==Key)||(13==Key)) {
		
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		iRegNo=$("#RegNo").val();
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		} 

	var PADMS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPIADMByRegNo",iRegNo);
		var PADM=PADMS.split("^")[1];
		if (PADM==""){return false;}
	
	/// 患者签名 begin
			var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			//alert('请配置手写签名设备');
			$.messager.alert("提示","请配置手写签名设备","success");
			return;
		}

			try {
				
			// 获取图片
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);

			var CRM=PADM
			
			//// DHCPEHandSignMassage 的Code
			var TypeCode="03";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '患者';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// 获取编辑器hash
			
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode);
			var record=tkMakeServerCall("web.DHCPE.CA.HandSign","RecordInfo",CRM,signinfo);
			var signInfo = HashData(signinfo);
			
				isSigned = true;
				// 签名
				var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo);
				//alert("signValue: "+signValue)
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
				parEditor.unSignedDocument();
			}
			$.messager.alert("提示",err.message,"success");
			
		}
		
	// $.messager.alert("提示",123,"success");
	
	BFind_click();
	}
	
}
function BFind_click()
{
	
	
	var DateBegin=getValueById("DateBegin");
	var DateEnd=getValueById("DateEnd");
	//var DateBegin=getValueById("DateBegin");
	
	$("#tDHCPEYGHadKnow").datagrid('load',{ComponentID:56820,DateBegin:DateBegin,DateEnd:DateEnd});
}
