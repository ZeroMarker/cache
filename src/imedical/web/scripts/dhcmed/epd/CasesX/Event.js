function InitCasesXEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
  		obj.cbgAdmType.setValue("I,O,E");
		obj.cboLoc.on("select",  obj.cboLoc_select, obj);
  		obj.btnExport.on('click', obj.btnExport_click, obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);	
		
	};
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var EpisodeID = objRec.get("EpisodeID");
		var CXLnkResults = objRec.get("LnkResults");
		if ((!EpisodeID)||(!CXLnkResults)) return;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.EPDService.CtlResultSrv',
				QueryName : 'QryCtrlDtlByAdm',
				Arg1 : CXLnkResults,
				ArgCnt : 1
			},
			
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID, arryData);
			},
			
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	
	obj.cboLoc_select = function(){
		Common_LoadCurrPage('gridCasesX',1);
	}
	
	obj.btnQuery_click = function(){
		obj.gridCasesXStore.load({});
	};
	obj.btnExport_click = function() {
		if (obj.gridCasesXStore.getCount()<1) {
			ExtTool.alert("ȷ��", "�����ݼ�¼,��������!");
			return;
		}
		
		var strFileName = "��Ⱦ�����ü�¼";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridCasesX, strFileName);
	}
}


//������ʾ
function DisplayCasesHandle(CasesXID,EpisodeID){

	var objInput = new Object();
	objInput.CasesXID     = CasesXID;
	objInput.EpisodeID    = EpisodeID;

	var ret = ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","CheckCasesStatus",SubjectCode,objInput.CasesXID);
	if (ret<1) {
		ExtTool.alert("��ʾ", "�Ѿ���ȷ����ų����Ĵ��ò������ٲ���!");
		return true;
	}else{	  
		var objFrmEdit = new InitwinEdit(objInput);
	 	objFrmEdit.winEdit.show();
	}
	window.event.returnValue = false;
	return true;
}

