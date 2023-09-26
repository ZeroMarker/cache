//01严重精神障碍患者(含重性精神疾病)出院信息单
function ExportXMLType1(arryRep){
	var obj = objScreen;
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.DSType01StoreProxy = new Ext.data.HttpProxy(objConn);
	obj.DSType01Store = new Ext.data.Store({
		proxy: obj.DSType01StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PATIENT_ID'
		}, 
		[
			{name: 'PATIENT_ID', mapping: 'PATIENT_ID'}
			,{name: 'NAME', mapping: 'NAME'}
			,{name: 'IDENTITY', mapping: 'IDENTITY'}
			,{name: 'FAMILY_PHONE', mapping: 'FAMILY_PHONE'}
			,{name: 'LINKER', mapping: 'LINKER'}
			,{name: 'LINKER_PHONE', mapping: 'LINKER_PHONE'}
			,{name: 'REG_TYPE', mapping: 'REG_TYPE'}
			,{name: 'NATIONALITY', mapping: 'NATIONALITY'}
			,{name: 'HJ_TYPE', mapping: 'HJ_TYPE'}
			,{name: 'HJ_SHENG', mapping: 'HJ_SHENG'}
			,{name: 'HJ_REGION', mapping: 'HJ_REGION'}
			,{name: 'HJ_STREET', mapping: 'HJ_STREET'}
			,{name: 'HJ_DETAIL', mapping: 'HJ_DETAIL'}
			,{name: 'TYPE', mapping: 'TYPE'}
			,{name: 'CENTER', mapping: 'CENTER'}
			,{name: 'PUBLISH_REGION', mapping: 'PUBLISH_REGION'}
			,{name: 'STREET', mapping: 'STREET'}
			,{name: 'DETAIL', mapping: 'DETAIL'}
			,{name: 'FIRST_DATE', mapping: 'FIRST_DATE'}
			,{name: 'INHOS_DATE', mapping: 'INHOS_DATE'}
			,{name: 'OUTHOS_DATE', mapping: 'OUTHOS_DATE'}
			,{name: 'INHOS_REASON', mapping: 'INHOS_REASON'}
			,{name: 'MENTALLIST', mapping: 'MENTALLIST'}
			,{name: 'ZISHI', mapping: 'ZISHI'}
			,{name: 'ZHAOSHI', mapping: 'ZHAOSHI'}
			,{name: 'ZHAOHUO', mapping: 'ZHAOHUO'}
			,{name: 'ZISHANG', mapping: 'ZISHANG'}
			,{name: 'ZISHA', mapping: 'ZISHA'}
			,{name: 'OTHER_BEHAVIOR', mapping: 'OTHER_BEHAVIOR'}
			,{name: 'OTHER_EFFECT', mapping: 'OTHER_EFFECT'}
			,{name: 'POLICLINIC', mapping: 'POLICLINIC'}
			,{name: 'FIRST_DRUGTREATMENT', mapping: 'FIRST_DRUGTREATMENT'}
			,{name: 'INHOSPITAL', mapping: 'INHOSPITAL'}
			,{name: 'POLICLINIC_NUMBER', mapping: 'POLICLINIC_NUMBER'}
			,{name: 'INHOSPITAL_NUMBER', mapping: 'INHOSPITAL_NUMBER'}
			,{name: 'PAYMENT_TYPE', mapping: 'PAYMENT_TYPE'}
			,{name: 'INSUR_NO', mapping: 'INSUR_NO'}
			,{name: 'DIAGNOSE', mapping: 'DIAGNOSE'}
			,{name: 'ICD10', mapping: 'ICD10'}
			,{name: 'DIAGNOSE_DATE', mapping: 'DIAGNOSE_DATE'}
			,{name: 'INMEDICATIONLIST', mapping: 'INMEDICATIONLIST'}
			,{name: 'INHOSPITAL_METHOD', mapping: 'INHOSPITAL_METHOD'}
			,{name: 'INHOSPITAL_METHOD_QT', mapping: 'INHOSPITAL_METHOD_QT'}
			,{name: 'CURE_RESULT', mapping: 'CURE_RESULT'}
			,{name: 'IF_SUBSIDY', mapping: 'IF_SUBSIDY'}
			,{name: 'SUBSIDY_TYPE', mapping: 'SUBSIDY_TYPE'}
			,{name: 'SUBSIDY', mapping: 'SUBSIDY'}
			,{name: 'SUBSIDY_OTHER', mapping: 'SUBSIDY_OTHER'}
			,{name: 'NEXTMEDICATIONLIST', mapping: 'NEXTMEDICATIONLIST'}
			,{name: 'NEXT_METHOD', mapping: 'NEXT_METHOD'}
			,{name: 'NEXT_METHOD_QT', mapping: 'NEXT_METHOD_QT'}
			,{name: 'REMARKS', mapping: 'REMARKS'}
			,{name: 'DOCTOR', mapping: 'DOCTOR'}
			,{name: 'DOCTOR_PHONE', mapping: 'DOCTOR_PHONE'}
			,{name: 'SIGN_TIME', mapping: 'SIGN_TIME'}
		])
	});
	
	obj.ExportXMLFile = function(ReportIDList, isMapping, filePath, HospInsCode){
		obj.DSType01Store.load({
			params : {
				ClassName : 'DHCMed.SMDService.ExportXml01',
				QueryName : 'QryForXML',
				Arg1 : ReportIDList,
				ArgCnt : 1,
				filePath : filePath,
				isMapping : isMapping,
				HospInsCode : HospInsCode
			},
			callback : function(arryResult, param){
				if ((arryResult.length > 0) && (param.params.isMapping != true)) {
					var objFrm = new InitwinProblem(ReportIDList, obj);
					objFrm.winProblem.show();
				} else {
					try {
						var objDoc = XMLTool.CreateXML("PSYHOSPITALOUTLIST");
						var objRec = null;
						for (var i = 0; i < arryResult.length; i++){
							var objRec = arryResult[i];
							obj.ExportXMLNode(objDoc, objRec, objDoc.documentElement);
						}
						var strFileName = param.params.filePath + "\\" + new Date().format("Ymd") + "_" + param.params.HospInsCode + ".xml";
						objDoc.save(strFileName);
						ExtTool.alert("提示", "保存成功，文件存放在“" + strFileName + "”。", Ext.MessageBox.INFO);
					}catch(err){
						alert(err.message);
					}
				}
			}
		});
	}
	
	obj.ExportXMLNode = function(objDoc, objRec){
		var objNode = XMLTool.CreateNode(objDoc, "PSYHOSPITALOUT", objDoc.documentElement);
		var t="";
		for(var i = 0; i < objRec.fields.length; i ++){
			var objField = objRec.fields.items[i];
			var strValue = objRec.get(objField.name);
			if((objField.name == "INMEDICATIONLIST")||(objField.name == "NEXTMEDICATIONLIST")){
				var tNode = XMLTool.CreateNode(objDoc, objField.name, objNode);
				var arryRows = strValue.split(",");
				for(var j = 0; j < arryRows.length; j ++){
					if(arryRows[j] == "") continue;
					var arryFields = arryRows[j].split("^");
					if(arryFields[0] == "") continue;
					if (objField.name == "INMEDICATIONLIST"){
						var tChild = XMLTool.CreateNode(objDoc, "MEDICATION", tNode);
						XMLTool.CreateTextNode(objDoc, "DRUGCODE", arryFields[0], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGAMOUNT", arryFields[1], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGUNIT", arryFields[2], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGREPITION", arryFields[3], tChild);
					}else{
						var tChild = XMLTool.CreateNode(objDoc, "NEXTMEDICATION", tNode);
						XMLTool.CreateTextNode(objDoc, "DRUGCODE", arryFields[0], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGAMOUNT", arryFields[1], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGUNIT", arryFields[2], tChild);
						XMLTool.CreateTextNode(objDoc, "DRUGREPITION", arryFields[3], tChild);					
					}
				}
			}else{
				strValue = XMLTool.GetDataMapCode(objField.name, strValue);
				XMLTool.CreateTextNode(objDoc, objField.name, strValue, objNode);
				t = t + objField.name + ":" + strValue + "\r\n";
			}
		}
	}
	
	return obj;
}