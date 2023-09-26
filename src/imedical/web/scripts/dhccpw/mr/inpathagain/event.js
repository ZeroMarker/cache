
function InitMainViewportEvent(obj) {
	obj.LoadEvent = function(args){
		//ȡ��־ԭ��ͱ�ע��Ϣ
		if (obj.InPathLog){
			var ReasonList=obj.InPathLog.NotInCPWReason;
			var ReasonResume=obj.InPathLog.NotInCPWResume;
		}else{
			var ReasonList="";
			var ReasonResume="";
		}
		//���ò��뾶ԭ��ע
		obj.txtResume.setValue(ReasonResume)
		//���ز��뾶ԭ������б�
		obj.ReasonGridStore.load({
			callback: function(records, options, success){
				//չ����ϲ�����
				obj.ReasonGrid.getView().expandAllGroups();
				//obj.ReasonGrid.getView().collapseAllGroups();
				//�������뾶ԭ��
				var tmpList=ReasonList.split(",");
				var itemStore=obj.ReasonGridStore;
				for (var rowIndex=0;rowIndex<itemStore.getCount();rowIndex++){
					var objRec = itemStore.getAt(rowIndex);
					var itemID=objRec.get("Rowid");
					for (var listIndex=0;listIndex<tmpList.length;listIndex++){
						if (tmpList[listIndex]=='') continue;
						if (itemID==tmpList[listIndex]){
							objRec.set("checked", true);
						}
					}
				}
				obj.ReasonGridStore.commitChanges();
			}
			,scope: obj.ReasonGridStore
			,add: false
		});
		//ȷ����ť�¼�
		obj.btnSave.on("click", obj.btnSave_OnClick, obj);
	};
	obj.btnSave_OnClick = function(){
		var ErrInfo="",notInCPWReasons="";
		var itemStore=Ext.getCmp('ReasonGrid').getStore();
		for (var rowIndex=0;rowIndex<itemStore.getCount();rowIndex++){
			var objRec = itemStore.getAt(rowIndex);
			var itemID=objRec.get("Rowid");
			var itemCheck=objRec.get("checked");
			if (itemCheck){
				notInCPWReasons=notInCPWReasons + itemID + ","
			}
		}
		if (!notInCPWReasons){
			ErrInfo = ErrInfo + "��ѡ�����뾶ԭ��!";
		}
		var txtResume=obj.txtResume.getValue();
		if (!txtResume){
			ErrInfo = ErrInfo + "����д��ע��Ϣ!";
		}
		if (ErrInfo) {
			alert(ErrInfo);
			return;
		}
		
		var InputStr=EpisodeID;
		InputStr=InputStr + CHR_1 + obj.CurrLogon.USERID;
		InputStr=InputStr + CHR_1 + VersionID;
		InputStr=InputStr + CHR_1 + notInCPWReasons;
		InputStr=InputStr + CHR_1 + txtResume;
		var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
		var ret = objInPathLogSrv.InCPWAgain(InputStr,CHR_1);
		if (ret<0){
			ExtTool.alert("��ʾ","���治�뾶ԭ��ʧ��!",Ext.MessageBox.ERROR);
		}else{
			ExtTool.alert("��ʾ","�������뾶ԭ��ɹ�!");
			window.returnValue=ret;
			window.close();  //��������ҽԺ��Ӧ�ùرմ���,��Ϊ����߻�����һ�㴰��
		}
	}
}
