//02严重精神障碍患者发病报告卡
function ExportXMLType2(arryRep){
	var obj = objScreen;
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.DSType02StoreProxy = new Ext.data.HttpProxy(objConn);
	obj.DSType02Store = new Ext.data.Store({
		proxy: obj.DSType02StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CARD_ID'
		},
		[
			{name: 'CARD_ID', mapping: 'CARD_ID'}
			,{name: 'REPORT_TYPE', mapping: 'REPORT_TYPE'}
			,{name: 'INHOS_REASON', mapping: 'INHOS_REASON'}
			,{name: 'INTEGRITY', mapping: 'INTEGRITY'}
			,{name: 'INHOS_DATE', mapping: 'INHOS_DATE'}
			,{name: 'NAME', mapping: 'NAME'}
			,{name: 'LINKER_NAME', mapping: 'LINKER_NAME'}
			,{name: 'LINKER_PHONE', mapping: 'LINKER_PHONE'}
			,{name: 'IDENTITY_CARD', mapping: 'IDENTITY_CARD'}
			,{name: 'SEX', mapping: 'SEX'}
			,{name: 'WORKING', mapping: 'WORKING'}
			,{name: 'WORKING_PHONE', mapping: 'WORKING_PHONE'}
			,{name: 'CENSUS', mapping: 'CENSUS'}
			,{name: 'HJ_TYPE', mapping: 'HJ_TYPE'}
			,{name: 'HJ_PROVINCE', mapping: 'HJ_PROVINCE'}
			,{name: 'HJ_REGION', mapping: 'HJ_REGION'}
			,{name: 'HJ_STREET', mapping: 'HJ_STREET'}
			,{name: 'HJ_DETAIL', mapping: 'HJ_DETAIL'}
			,{name: 'TYPE', mapping: 'TYPE'}
			,{name: 'CENTER', mapping: 'CENTER'}
			,{name: 'REGION', mapping: 'REGION'}
			,{name: 'STREET', mapping: 'STREET'}
			,{name: 'DETAIL', mapping: 'DETAIL'}
			,{name: 'JOB', mapping: 'JOB'}
			,{name: 'FIRST_DATE', mapping: 'FIRST_DATE'}
			,{name: 'SEND_SUBJECT', mapping: 'SEND_SUBJECT'}
			,{name: 'SUBJECT_QT', mapping: 'SUBJECT_QT'}
			,{name: 'DIAGNOSE_DATE', mapping: 'DIAGNOSE_DATE'}
			,{name: 'ILL_CODE', mapping: 'ILL_CODE'}
			,{name: 'ICD10', mapping: 'ICD10'}
			,{name: 'REPORT_UNITS', mapping: 'REPORT_UNITS'}
			,{name: 'ZZJG_PHONE', mapping: 'ZZJG_PHONE'}
			,{name: 'REPORT_DOCTOR', mapping: 'REPORT_DOCTOR'}
			,{name: 'CARD_DATE', mapping: 'CARD_DATE'}
			,{name: 'REMARK', mapping: 'REMARK'}
		])
	});
	
	obj.ExportXMLFile = function(ReportIDList, isMapping, filePath, HospInsCode){
		obj.DSType02Store.load({
			params : {
				ClassName : 'DHCMed.SMDService.ExportXml02',
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
						var objDoc = XMLTool.CreateXML("PSYHOSPITALCARDLISTRY");
						var objRec = null;
						for(var i = 0; i < arryResult.length; i ++)
						{
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
	
	obj.ExportXMLNode = function(objDoc, objRec) {
		var t="";
		var objNode = XMLTool.CreateNode(objDoc, "PSYHOSPITALCARD", objDoc.documentElement)
		for (var i = 0; i < objRec.fields.length; i++){
			var objField = objRec.fields.items[i];
			var strValue = objRec.get(objField.name);
			strValue = XMLTool.GetDataMapCode(objField.name, strValue);
			XMLTool.CreateTextNode(objDoc, objField.name, strValue, objNode);
			t = t + objField.name + ":" + strValue;
		}
	}
	
	return obj;
}