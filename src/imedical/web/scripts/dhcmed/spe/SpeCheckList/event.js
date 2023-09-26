function InitSpeCheckListEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.cboPatType.on("select",  obj.cboPatType_select, obj);
		obj.cboQryStatus.on("select",  obj.cboQryStatus_select, obj);
		obj.cboLoc.on("select",  obj.cboLoc_select, obj);
		obj.txtRegNo.on("specialKey",obj.txtRegNo_specialKey,obj);
		obj.txtPatName.on("specialKey",obj.txtPatName_specialKey,obj);
		//obj.RowExpander.on("expand",obj.RowExpander_expand,obj); ��˫��������Ϊ�������
		
		obj.cboPatTypeStore.load({});
		obj.cboQryStatus.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						obj.cboQryStatus.setValue(r[0].get("DicRowId"));
						obj.cboQryStatus.setRawValue(r[0].get("DicDesc"));
						//Common_LoadCurrPage('gridSpeCheckList',1);
						obj.gridSpeCheckListStore.load({params : {start : 0,limit : 50}});
					}
				}
			}
		});
		//�����س��¼�
		obj.txtRegNoENTER = function ()
		{
			var RegNo = obj.txtRegNo.getValue();
			RegNo=RegNo.replace(/(^\s*)|(\s*$)/g, "");
			var Reglength=RegNo.length
			for(var i=0;i<(10-Reglength);i++)
			{
				RegNo="0"+RegNo;
			}
			obj.txtRegNo.setValue(RegNo);
			
		}
  	};
  	/*
  	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var SepID = objRec.get("SpeID");
		obj.RowExpander_load(SepID);
	}
	
	obj.RowExpander_load = function(SepID){
		obj.SelectRow.SepID = SepID;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.SPEService.PatientsQry',
				QueryName : 'QryNewsBySpeID',
				Arg1 : obj.SelectRow.SepID,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var objSpeNews = new Object();
				objSpeNews.SpeID = obj.SelectRow.SepID;
				objSpeNews.ArryNews = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					objSpeNews.ArryNews[objSpeNews.ArryNews.length] = objItem;
				}
				obj.RowTemplate.overwrite("divNewsDtl-" + obj.SelectRow.SepID, [objSpeNews]);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divNewsDtl-" + obj.SelectRow.SepID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	*/
	//��˰�ť���
  	obj.objContextMenu = new Ext.menu.Menu({
		items:[
			{
				text:'<b>���</b>',
				icon:'../scripts/dhcmed/img/edit.gif',
				handler:function(){
					var objSel = ExtTool.GetGridSelectedData(obj.gridSpeCheckList);
					if(objSel == null) return;
					var objCheckWin = new InitwinSpeCheck(objSel.get("SpeID"));
					objCheckWin.winSpeCheck.show();
				}
			}
		]
	});
	
	obj.cboPatType_select = function(){
		Common_LoadCurrPage('gridSpeCheckList',1);
	}
	
	obj.cboQryStatus_select = function(){
		Common_LoadCurrPage('gridSpeCheckList',1);
	} 
	
	obj.cboLoc_select = function(){
		Common_LoadCurrPage('gridSpeCheckList',1);
	}
	
	obj.txtRegNo_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue("txtPatName",'');
		Common_LoadCurrPage('gridSpeCheckList',1);
	}
	
	obj.txtPatName_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_SetValue("txtRegNo",'');
		Common_LoadCurrPage('gridSpeCheckList',1);
	}
	
	obj.btnQuery_click = function(){
		Common_LoadCurrPage('gridSpeCheckList',1);
	}
	/*
	//������Ϣ�¼�
	obj.btnSendNews_Click=function(SpeID){
		var Opinion = '';
		var objCmp = document.getElementById('txtOpinion-' + SpeID);
		if (objCmp) Opinion = objCmp.value;
		if (Opinion == ''){
			ExtTool.alert("����", "��������Ϣ!");
			return;
		}
		
		var InputStr=SpeID;
		InputStr += '^' + Opinion;
		InputStr += '^' + obj.InputObj.OperTpCode;
		InputStr += '^' + session['LOGON.USERID'];
		var strSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetSepInfoByID",SpeID);
		if (strSpeInfo == '') return;
		var arrSepInfo = strSpeInfo.split('^');
		var EpisodeID = arrSepInfo[1];
		if (EpisodeID == '') return;
		
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","SendNews",InputStr);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("����", "������Ϣʧ��!");
		} else {
			//ExtTool.alert("����", "������Ϣ�ɹ�!");
			obj.RowExpander_load(SpeID);
			var NewsID=ret;
			var Hisret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000023",NewsID,"1",EpisodeID);
		}
	}
	
	//�Ķ���Ϣ�¼�
	obj.btnReadNews_Click=function(SpeID){
		if (!SpeID) return;
		var OperTpCode = obj.InputObj.OperTpCode;
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","ReadNews",SpeID,session['LOGON.USERID'],OperTpCode);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("����", "�Ķ���Ϣʧ��!");
		} else {
			//ExtTool.alert("����", "�Ķ���Ϣ�ɹ�!");
			obj.RowExpander_load(SpeID);
		}
	}
	
	//ɾ����Ϣ�¼�
	obj.btnDeleteNews_Click = function(SpeLogID){
		if (!SpeLogID) return;
		Ext.MessageBox.confirm("ϵͳ��ʾ", "�Ƿ�ɾ����Ϣ��", function(but) {
			if (but=="yes"){
				var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","DeleteNews",SpeLogID,session['LOGON.USERID']);
				var arr = ret.split('^');
				if ((arr[0]*1)<1){
					if (arr[0] == '-100') {
						ExtTool.alert("����", "����Ϣ��Ч!");
					} else if (arr[0] == '-200') {
						ExtTool.alert("����", "������ɾ���Ǳ��˷��͵���Ϣ!");
					} else if (arr[0] == '-300') {
						ExtTool.alert("����", "������ɾ���Ѷ�����Ϣ!");
					}  else {
						ExtTool.alert("����", "ɾ����Ϣʧ��!");
					}
				} else {
					//ExtTool.alert("����", "ɾ����Ϣ�ɹ�!");
					var arr = SpeLogID.split('||');
					var SpeID = arr[0];
					obj.RowExpander_load(SpeID);
				}
			}
        });
	}
	*/
	
	//ͼ����ʾ
	obj.DisplaySpeCheckWin = function(SpeID){
		var objInput = new Object();
		objInput.SpeID     = SpeID;
		objInput.EpisodeID = '';
		objInput.OperTpCode = obj.InputObj.OperTpCode;
		
		var objMarkWin = new SPM_InitSpeMarkWin(objInput);
		objMarkWin.SPM_WinSpeMark.show();
		window.event.returnValue = false;
		return true;
	}
	obj.OpenSpeNewsWin = function(SpeID){
		var objInput = new Object();
		objInput.SpeID = SpeID;
		objInput.OperTpCode = obj.InputObj.OperTpCode;	
		var objNewsWin = new SPN_InitSpeNewsWin(objInput);
		objNewsWin.SPN_WinSpeNews.show();
		window.event.returnValue = false;
		return true;
	}
	obj.GetStatusCode = function(CmpID){
		var objCmp = Ext.getCmp(CmpID);
		if (!objCmp) return '';
		var ID = objCmp.getValue();
		var SelectIndex = objCmp.getStore().find('DicRowId',ID);
		if (SelectIndex > -1){
			var rd = objCmp.getStore().getAt(SelectIndex);
			return rd.get('DicCode');
		}
		return '';
	}
	
	obj.SpeGridRowRefresh_Handler = function(SpeID){
		if (SpeID == '') return;
		var strSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetSepInfoByID",SpeID);
		if (strSpeInfo == '') return;
		var arrSepInfo = strSpeInfo.split('^');
		
		var objGrid = Ext.getCmp('gridSpeCheckList');
		if (!objGrid) return;
		var objStore = objGrid.getStore();
		if (!objStore) return;
		var SelectIndex = objStore.find('SpeID',SpeID);
		if (SelectIndex > -1){
			var rd = objStore.getAt(SelectIndex);
			
			var tmp = arrSepInfo[4];
			var arr = tmp.split(CHR_1);
			rd.set('StatusCode',arr[1]);
			rd.set('StatusDesc',arr[2]);
			var tmp = arrSepInfo[10];
			var arr = tmp.split(' ');
			rd.set('CheckDate',arr[0]);
			rd.set('CheckTime',arr[1]);
			rd.set('CheckOpinion',arrSepInfo[11]);
			rd.commit();
		}
	}
}