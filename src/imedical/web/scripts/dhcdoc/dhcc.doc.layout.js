function xhrRefresh(obj){	
	dhcc.doc.orderGridPanel.refreshData(obj);
	if(obj.adm){
		var copySosOrdersBtn = Ext.getCmp("copySosOrdersBtn");
		var copyPrnOrdersBtn = Ext.getCmp("copyPrnOrdersBtn");
		var stopOrdersBtn = Ext.getCmp("stopOrdersBtn");
		var cancelOrdersBtn = Ext.getCmp("CancelOrdersBtn");
		var abortOrdersBtn = Ext.getCmp("AbortOrdersBtn");
		Ext.Ajax.request({
			url: "jquery.easyui.broker.csp",
			params: {ClassName:"web.DHCDocMainOrderInterface",MethodName:"HiddenMenuFlag",adm:obj.adm},
			callback: function(request,succ,response){
				patData.patFlag = response.responseText ;
				switch(patData.patFlag){
					case '1' : patData.flagDesc = "已出院";  break;
					case '2' : patData.flagDesc = "医疗结算"; break;
					case '2.5':patData.flagDesc = "最终结算后,护士调整费用"; break;
					case '3' : patData.flagDesc = "最终结算"; break;
					case '4' : patData.flagDesc = "财务结算"; break;
					case "5" : patData.flagDesc = "不是V7的病人"; break;
					default: patData.flagDesc = patData.patFlag;
				}
				/*按钮操作控制不细化*/ 
				if (patData.patFlag>0){
					if (copySosOrdersBtn){
						copySosOrdersBtn.qtip = patData.flagDesc;
						copySosOrdersBtn.setDisabled(true);
					}
					if (copyPrnOrdersBtn){
						copyPrnOrdersBtn.qtip = patData.flagDesc;
						copyPrnOrdersBtn.setDisabled(true);
					}
					if (stopOrdersBtn){
						stopOrdersBtn.qtip = patData.flagDesc;
						stopOrdersBtn.setDisabled(true);
					}
					if (stopOrdersBtn){
						stopOrdersBtn.qtip = patData.flagDesc;
						stopOrdersBtn.setDisabled(true);
					}
					if (cancelOrdersBtn){
						cancelOrdersBtn.qtip = patData.flagDesc;
						cancelOrdersBtn.setDisabled(true);
					}
					if (abortOrdersBtn){
						abortOrdersBtn.qtip = patData.flagDesc;
						abortOrdersBtn.setDisabled(true);
					}
				}else{
					if (stopOrdersBtn) stopOrdersBtn.setDisabled(false);
					if (cancelOrdersBtn) cancelOrdersBtn.setDisabled(false);
					if (abortOrdersBtn) abortOrdersBtn.setDisabled(false);
					if (copySosOrdersBtn){copySosOrdersBtn.setDisabled(false);}
					if (copyPrnOrdersBtn){copyPrnOrdersBtn.setDisabled(false);}
				}
			}
		});
	}
}
Ext.onReady(function(){
	if ("undefined" == typeof collapsed) collapsed = false;
	if (LayoutControl=="NewOrderEntry") {
		var viewport = new Ext.Viewport({
			layout:'fit',
			items:[{
				xtype:'panel',
				layout:'border',
				items:[dhcc.doc.orderGridPanel,{	
					xtype:'panel',
					width:380,
					layout:'border',
					region:"east",
					split:true,
					collapsible: true,
					collapsed:true,
					items:[
						dhcc.doc.execOrder
					]	
				}]
			}]	
		});
	}else{
		var viewport = new Ext.Viewport({
			layout:'border',					
			items:[dhcc.doc.orderGridPanel,{	
				xtype:'panel',
				width:feeListWidth,
				layout:'border',
				region:"east",
				split:true,
				collapsed:collapsed,
				collapseMode:'mini',
				items:[
					dhcc.doc.execOrder,
					dhcc.doc.feeOrder
				]	
			}]
		});
	}			
	if (orderRightMenuJson && orderRightMenuJson.menu){
		dhcc.doc.orderGridPanel.rightKeyMenu = new Ext.menu.Menu(orderRightMenuJson.menu);
			
	}
	if (orderSOSRightMenuJson && orderSOSRightMenuJson.menu){
		dhcc.doc.orderGridPanel.rightSOSKeyMenu = new Ext.menu.Menu(orderSOSRightMenuJson.menu);	
	}
		
	if (execRightMenuJson && execRightMenuJson.menu){
		dhcc.doc.execOrder.rightKeyMenu = new Ext.menu.Menu(execRightMenuJson.menu);	
	}
	if (execSOSRightMenuJson && execSOSRightMenuJson.menu){
		dhcc.doc.execOrder.rightSOSKeyMenu = new Ext.menu.Menu(execSOSRightMenuJson.menu);	
	}
	
	if (feeRightMenuJson && feeRightMenuJson.menu){
		dhcc.doc.feeOrder.rightKeyMenu = new Ext.menu.Menu(feeRightMenuJson.menu);	
	}
	if (feeSOSRightMenuJson && feeSOSRightMenuJson.menu){
		dhcc.doc.feeOrder.rightSOSKeyMenu = new Ext.menu.Menu(feeSOSRightMenuJson.menu);	
	}
	
	
	if (PatientID>0){
		xhrRefresh({papmi:PatientID, adm: EpisodeID});
	}else{
		var frm = dhcsys_getmenuform();		
		if (frm && frm.EpisodeID.value !== "0" ) {
			xhrRefresh({papmi:frm.PatientID.value, adm: frm.EpisodeID.value});
		}
	}
});	