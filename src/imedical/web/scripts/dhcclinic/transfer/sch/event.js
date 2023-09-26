function InitViewScreenEvent(obj)
{
	var _DHCANOPTransfer=ExtTool.StaticServerObject('web.DHCANOPTransfer');
	var userId=session["LOGON.USERID"];
	var GROUPID=session["LOGON.GROUPID"];
	obj.LoadEvent = function(args)
	{
		Ext.getCmp('PatInRoom').setVisible(true);     
		Ext.getCmp('PatOutRoom').setVisible(true);
		
		if(dateFrm!="")  
		{
			obj.dateFrm.setValue(dateFrm);
		}
		if(dateTo!="")
		{
			obj.dateTo.setValue(dateTo);
		}
		var sessWardId=session['LOGON.WARDID'];
	//alert(obj.dateFrm.getRawValue()+"^"+obj.dateTo.getRawValue()+"^"+EpisodeID);
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPTransfer';
			param.QueryName = 'GetANOPTransferList';
			param.Arg1 = obj.dateFrm.getRawValue();
			param.Arg2 = obj.dateTo.getRawValue();
			param.Arg3 = obj.comOperStat.getValue();
			param.Arg4 = obj.comOpRoom.getValue();
			param.Arg5 = obj.comAppLoc.getValue();
			param.Arg6 = obj.txtMedCareNo.getValue();	
			param.Arg7 = obj.comPatWard.getValue();//sessWardId;
			param.Arg8 = obj.comOprFloor.getValue();
			param.Arg9 = obj.chkIfAllLoc.getValue()?'Y':'N';
			param.Arg10= EpisodeID;
			param.ArgCnt = 10;
		});
		
	obj.retGridPanelStore.load({});
	}
	
	//接病人护工报到
	obj.ReceviceSure_click=function(){         
		var opaId=""
		console.log(obj.retGridPanel.getSelectionModel());
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		console.log(selectObj);
		if (selectObj)
		{
			opaId=selectObj.get('opaId');
			var receiveAssTime=selectObj.get('receiveAssTime');
			if(receiveAssTime!="")
			{
				alert("接病人护工报到时间已确认，不能重复确认！");
				return;
			}
			var ret=_DHCANOPTransfer.insertReceiveAss(opaId,userId);
			if(ret==0)
			{
				alert("接病人护工报到确认成功！")
				obj.retGridPanelStore.reload();
			}else{
				alert(ret+"^"+"确认时间失败！")
				return;
			}
		}else{
			alert("请选择一条病人调度信息！")
			return;
		}
	}
	//送病人护工报到
	obj.SendSure_click=function(){
		var opaId=""
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			opaId=selectObj.get('opaId');
			var sendAssTime=selectObj.get('sendAssTime');
			if(sendAssTime!="")
			{
				alert("送病人护工报到时间已确认，不能重复确认！");
				return;
			}
			var ret=_DHCANOPTransfer.insertSendAss(opaId,userId);
			if(ret==0)
			{
				alert("送病人护工报到确认成功！")
				obj.retGridPanelStore.reload();
			}else{
				alert(ret+"^"+"确认时间失败！")
				return;
			}
		}else{
			alert("请选择一条病人调度信息！")
			return;
		}
	}
	//病人入手术间时间
	obj.PatInRoom_click=function()
	 {
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
		var opaId=selectObj.get('opaId');
		var receiveBackTime=selectObj.get('receiveBackTime');
		if (receiveBackTime!="")
		{	
			alert("不能重复确认");
			return;
		}
		var ret=_DHCANOPTransfer.insertPatInRoom(opaId,userId);
		if(ret=="0")
		{
			alert("操作成功");
			obj.retGridPanelStore.reload();
		}else{
			alert(ret);
			return;
		}
				
		}
		else
		{
		  alert("请选择一条手术记录");
		}
	 }	
	 //病人出手术间时间
	 obj.PatOutRoom_click=function()
	 {
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
		var opaId=selectObj.get('opaId');
		var sendBackTime=selectObj.get('sendBackTime');
		if (sendBackTime!="")
		{	
			alert("不能重复确认");
			return;
		}
		var ret=_DHCANOPTransfer.insertPatOutRoom(opaId,userId);
		if(ret=="0")
		{
			alert("操作成功");
			obj.retGridPanelStore.reload();
		}else{
			alert(ret);
			return;
		}
				
		}
		else
		{
		  alert("请选择一条手术记录");
		}
	 }	
	
	obj.btnSch_click=function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
		/*Ext.TaskMgr.stopAll();
		Ext.TaskMgr.start({
    		run: function(){Ext.Ajax.request({
                url: '../web.DHCClinic.DHCANOPSendpolling.cls',
                timeout: 5000,
                methode: 'POST',
                params: {
                    stdate: obj.dateFrm.getRawValue(),
                    enddate: obj.dateTo.getRawValue()
                },
                success: function (response, opts) {
                    var groupId=session['LOGON.GROUPID'];
					if((groupId=="51")&&(response.responseText=="1"))
					{
                    	mplayer.URL = "../scripts/dhcclinic/Sound/tst.mp3";
						mplayer.controls.play();
					}

                },
                failure: function (response, opts) {
                }
            });
		},
    	interval: 1000
		});*/
		} 
		
	obj.retGridPanel_beforeedit = function (ev) {
	}

	obj.retGridPanel_validateedit=function(ev)
	{ 
	}
	obj.retGridPanel_afteredit=function(ev)
	{
		
		var opaId=ev.record.data.opaId;	
		if(ev.field=='receiveTime')
		{
			var receiveTime=ev.value;
			if(receiveTime!="")
			{
				var ret=_DHCANOPTransfer.updateReceiveTime(opaId,receiveTime,userId)
				if(ret!='0') 
				{
					if(ret=='-3')
					{
						alert("请先提交接病人申请单！")
					}
					else{
				    	alert(ret);
				    	obj.retGridPanelStore.reload();
					}
				}
			}
			
			
		}
		
		if(ev.field=='receiveUser')
		{
			var IdStr=ev.record.data.receiveUser;
			if(IdStr!="")
			{
				var ret=_DHCANOPTransfer.updateReceiveUser(opaId,IdStr,userId);
				if(ret!='0')
			    {
				   if(ret=='-3')
			       {
				       alert("请先填写接病人日期和时间！")
			       }
			       else
			       {
				       alert(ret);
					   ev.record.set('receiveUser',ev.originalValue);
					   obj.retGridPanelStore.reload();
			       }
			    }
			    
			}
			else{
			    alert("请选择接病人护工");
				return;
			}
			
		}
		
		if(ev.field=='sendTime')
		{
			var sendTime=ev.value;
			if(sendTime!="")
			{
				var ret=_DHCANOPTransfer.updateSendTime(opaId,sendTime,userId)
				if(ret!='0') 
				{
					if(ret=='-3')
					{
						alert("请先提交接病人申请单！")
					}
					else{
				    	alert(ret);
				    	obj.retGridPanelStore.reload();
					}
				}
			}
			
		
		}
		
		
		if(ev.field=="sendUser")
		{
			var IdStr=ev.value;
			if(IdStr!="")
			{
				var ret=_DHCANOPTransfer.updateSendUser(opaId,IdStr,userId);
				if(ret!='0') 
			    {
				    if(ret=='-3')
			        {
				        alert("请先填写送病人日期和时间！")
			        }
			        else
			        {
				        alert(ret);
				        ev.record.set('sendUser',ev.originalValue);
				        obj.retGridPanelStore.reload();
			        }
			    }
			    
				
			}
			else{
			    alert("请选择送病人护工");
				return;
			}
		}
		
	}
}