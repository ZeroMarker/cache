
function InitMainViewportEvent(obj) {
	obj.LoadEvent = function(args){
		//取日志原因和备注信息
		if (obj.InPathLog){
			var ReasonList=obj.InPathLog.NotInCPWReason;
			var ReasonResume=obj.InPathLog.NotInCPWResume;
		}else{
			var ReasonList="";
			var ReasonResume="";
		}
		//设置不入径原因备注
		obj.txtResume.setValue(ReasonResume)
		//加载不入径原因分组列表
		obj.ReasonGridStore.load({
			callback: function(records, options, success){
				//展开或合并分组
				obj.ReasonGrid.getView().expandAllGroups();
				//obj.ReasonGrid.getView().collapseAllGroups();
				//设置再入径原因
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
		//确定按钮事件
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
			ErrInfo = ErrInfo + "请选择再入径原因!";
		}
		var txtResume=obj.txtResume.getValue();
		if (!txtResume){
			ErrInfo = ErrInfo + "请填写备注信息!";
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
			ExtTool.alert("提示","保存不入径原因失败!",Ext.MessageBox.ERROR);
		}else{
			ExtTool.alert("提示","保存再入径原因成功!");
			window.returnValue=ret;
			window.close();  //航天中心医院不应该关闭窗体,因为他外边还包的一层窗体
		}
	}
}
