function InitOutPathWayWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.LoadOutPathWayInfo();
		//obj.cboOutReasonCateg.on("expand", obj.cboOutReasonCateg_OnExpand, obj);
		//obj.cboOutReasonCateg.on("collapse", obj.cboOutReasonCateg_OnCollapse, obj);
		//obj.cboOutReason.on("expand", obj.cboOutReason_OnExpand, obj);
		// modify by wuqk 2011-07-22 �޸�bug94
		// �ٴ�Ӧ��--����ȷ��-������ԭ��Ϊ��ʱ���������ͷ����ѡ��������ԭ����ࡿ��������ԭ����Ϊ��
		obj.cboOutReasonCateg.on("select", obj.cboOutReasonCateg_OnSelect, obj);
		obj.btnOutPathWay.on("click", obj.btnOutPathWay_OnClick, obj);
		obj.btnCloseForm.on("click", obj.btnCloseForm_OnClick, obj);
	};
	obj.cboOutReasonCateg_OnSelect = function(){
		obj.cboOutReason.clearValue();
		obj.cboOutReasonStore.load({});
	}
	/* modify by wuqk 2011-07-22 �޸�bug94
	obj.cboOutReasonCateg_OnExpand = function(){
		obj.cboOutReasonCateg.clearValue();
		obj.cboOutReasonCategStore.load({});
	}
	obj.cboOutReasonCateg_OnCollapse = function(){
		obj.cboOutReason.clearValue();
	}
	obj.cboOutReason_OnExpand = function(){
		obj.cboOutReason.clearValue();
		obj.cboOutReasonStore.load({});
	}*/
	obj.LoadOutPathWayInfo = function(){
		if (obj.PathWayID){
			var objPathWay = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
			var strPathWay=objPathWay.GetStringById(obj.PathWayID,"^");
			if (strPathWay){
				var tmpList=strPathWay.split("^");
				if (tmpList.length>=27){
					obj.cboOutReasonCateg.clearValue();
					obj.cboOutReasonCateg.setValue(tmpList[25]);
					obj.cboOutReasonCateg.setRawValue(tmpList[26]);
					obj.cboOutReason.clearValue();
					obj.cboOutReason.setValue(tmpList[18]);
					obj.cboOutReason.setRawValue(tmpList[19]);
					obj.txtOutReasonResume.setValue(tmpList[24]);
				}
			}
		}
	}
	obj.btnCloseForm_OnClick = function(){
		Ext.getCmp("OutPathWayWindow").close();
	}
	obj.btnOutPathWay_OnClick = function(){
		/// 1:Rowid  2:Status
		/// 3:OutDoctorDR 4:OutDate 5:OutTime 6:OutReasonDR 
		/// 7:Comments 8:UpdateUserDR
		
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var docString=ctpcpService.GetCareProvByUserID(obj.UserID);
		var OutDoctor=docString.split("^")[0];
		
		var ErrInfo="";
		var outReason=obj.cboOutReason.getValue();
		if (!outReason){
			ErrInfo = ErrInfo + "��ѡ�����ԭ��,����ԭ������Ϊ��!";
		}
		var outReasonResume=obj.txtOutReasonResume.getValue();
		if (!outReasonResume){
			ErrInfo = ErrInfo + "����дԭ��ע,��ע������Ϊ��!";
		}
		if (ErrInfo) {
			alert(ErrInfo);
			return;
		}
		
		var InputStr=obj.PathWayID;
		InputStr=InputStr + "^" + "O";
		InputStr=InputStr + "^" + OutDoctor;
		InputStr=InputStr + "^" ;
		InputStr=InputStr + "^" ;
		InputStr=InputStr + "^" + outReason;
		InputStr=InputStr + "^" + outReasonResume;
		InputStr=InputStr + "^" + obj.UserID;
		var ret = objMRClinicalPathWays.OutPathWay(InputStr);
		if (ret<0){
			ExtTool.alert("��ʾ","����ʧ��!",Ext.MessageBox.ERROR);
		}else{
			Ext.getCmp("OutPathWayWindow").close();
			if (obj.WinParent) {
				window.location.reload();
			}
			//var lnk="dhccpw.mr.clinpathway.csp?a=a&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+MRADMDR+"&BackPage=1&b=b";
			//document.location.href=lnk;
			//add by wuqk 2011-12-28 ������ת����뾶ҳ��
			//top.CheckLinkDetails("dhccpw.mr.clinpathway.csp?a=a","");
		}
	}
}

function OutPathWayHeader(WinParent,PathWayID,UserID)
{
	var objOutPathWayWindow = new InitOutPathWayWindow(WinParent,PathWayID,UserID);
	objOutPathWayWindow.OutPathWayWindow.show();
	var numTop=(screen.availHeight-objOutPathWayWindow.OutPathWayWindow.height)/2;
	var numLeft=(screen.availWidth-objOutPathWayWindow.OutPathWayWindow.width)/2;
	objOutPathWayWindow.OutPathWayWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objOutPathWayWindow);
}