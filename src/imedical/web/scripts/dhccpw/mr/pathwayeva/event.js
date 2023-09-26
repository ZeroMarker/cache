function InitPathWayEvaWindowEvent(obj) {
	obj.LoadEvent = function(args){
		//obj.LoadPathWayRstInfo();
		obj.btnUpdate.on("click", obj.btnUpdate_OnClick, obj);
	};
	obj.btnUpdate_OnClick = function(){
		obj.ConditionPanel.getForm().submit({
		    clientValidation: true,
		    url: 'dhccpw.mr.eva.csp',
		    params: {
		        PathWayID: obj.PathWayID,
		        UserID:obj.UserID
		    },
		    success: function(form, action) {
					obj.PathWayRstWindow.close();
					if (obj.WinParent) {
						if (obj.WinParent.InitForm){
							obj.WinParent.InitForm();
						}
					}
					//Ext.Msg.alert('±£´æ³É¹¦',"ÆÀ¹À³É¹¦!");
					//Ext.Msg.alert('Success', action.response.responseText);
		    },
		    failure: function(form, action) {
		    	Ext.Msg.alert('±£´æ´íÎó',action.result.rstId);
				/*
				switch (action.failureType) {
				    case Ext.form.Action.CLIENT_INVALID:
				        Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
				        break;
				    case Ext.form.Action.CONNECT_FAILURE:
				        Ext.Msg.alert('Failure', 'Ajax communication failed');
				        break;
				    case Ext.form.Action.SERVER_INVALID:
				       Ext.Msg.alert('Failure', action.result.msg);
				    case "server":
				    	Ext.Msg.alert('µÇÂ¼´íÎó',action.result.errors); 
				}*/
		    }
		});
	}
}

function PathWayEvaHeader(WinParent,PathWayID,UserID)
{
	var objPathWayRstWindow = new InitPathWayEvaWindow(WinParent,PathWayID,UserID);
	objPathWayRstWindow.PathWayRstWindow.show();
	var numTop=(screen.availHeight-objPathWayRstWindow.PathWayRstWindow.height)/2;
	var numLeft=(screen.availWidth-objPathWayRstWindow.PathWayRstWindow.width)/2;
	objPathWayRstWindow.PathWayRstWindow.setPosition(numLeft,numTop);
	ExtDeignerHelper.HandleResize(objPathWayRstWindow);
}