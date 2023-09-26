var abortOrderHandler,cancelOrderHandler,addBillOrderHandler;
var abortOrderShowHandler,cancelOrderShowHandler,addBillOrderShowHandler;
var pswMsg = "密码"
var pswNullMsg = "密码为空,请填写密码!"
Ext.ns("dhcc.doc");
var SelOrderPriorType=""
var obj=document.getElementById("OrderPriorType")
if(obj){
	SelOrderPriorType=obj.value;
}
dhcc.icare.passwordKey = Ext.extend(Ext.form.Field, {
	width:160,inputType:'password',allowBlank: false,
	listeners:{"specialkey":function(textfield,fieldE){ var key=fieldE.getKey(); if(key==13){ textfield.findParentByType("window").buttons[0].handler.call();}}}
});
Ext.reg('passwordkey', dhcc.icare.passwordKey);
Ext.onReady(function(){
	Ext.QuickTips.init();
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		listClassName: 'web.DHCDocSosOrder',
		listQueryName: 'FindSosOrderNurse',
		columnModelFieldJson: window.orderMetaDataJson,
		internalType: 'NURSE',
		orderType: "SOS"
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','医嘱单型',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: '医嘱单型',
			width: 110,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode: 'local',
			value: "ALL",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","全部"],["Y","护嘱单"],["N","医嘱单"]]
			}),
			displayField: 'nursebillDesc',
			valueField: 'nursebillId',
			allowBlank:  false			
		},"-",'',{
			paramPosition: 8, 
			xtype:"field",
			width: 110,
			name: "OrderPriorType",
			id: "OrderPriorType",		
			value:SelOrderPriorType,
			hidden:true
		});
		var operateMenu = new Ext.menu.Menu();
		var lis = {
			disable : function(t){
				if (t.el) t.el.dom.setAttribute("ext:qtip",t.qtip) ;
			},
			render :function(t){
				// 菜单显示后才会render,才有el. disable可以先以render
				// evevt time line  disable-->render, 第一次tip得放在render内
				if(t.qtip) t.el.dom.setAttribute("ext:qtip",t.qtip) ;
			},
			enable : function(t){
				if(t.el) t.el.dom.setAttribute("ext:qtip","") ;
			}
		};
		operateMenu.add({
			text:'撤销多条',
			orgtext:"撤销多条",
			id:"CancelOrdersBtn",
			listeners:lis,
			handler:function(b,e){
				cancelOrderHandler(b,e);		
			}
		});
		operateMenu.add({
			text: '作废多条',	
			orgtext:"作废多条",	
			id:"AbortOrdersBtn",
			listeners:lis,
			handler: function(b, e){
				abortOrderHandler();
			}
		});
		orderTbar.add({
			text:"操作",
			menu:operateMenu
		});
		orderTbar.doLayout();
	};
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );	
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		var win = new Ext.Window({					
			title: '作废医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'作废',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示",pswNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'UnUsePrnOrder',PinNum: pinnum});
						win.close();
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	}
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		var win = new Ext.Window({					
			title: '撤消(DC)医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'撤消(DC)',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示",pswNullMsg);
							return 
						}		
						operateObj.sendAjax(b, e, {act:'CancelPrnOrder',PinNum: pinnum});
						win.close();
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	/**
	*{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}
	*/
	cancelOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		if(!record.data["HIDDEN1"]){
			this.qtitle = "说明";
			this.qtip = "请选中一条医嘱!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var cancelPermission = record.data["CancelPermission"];
		if(orderStatus == "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱已停止,不能撤销!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "说明";
			this.qtip = "医嘱已执行过,不能撤销!";
			return false ;
		}else if(cancelPermission == "0"){
			this.qtitle = "说明";
			this.qtip = "权限不够 或 医嘱已被执行!";
			return false ;
		}		
		return true;		
	};
	/**
	*{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}
	*/
	abortOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		if(!record.data["HIDDEN1"]){
			this.qtitle = "说明";
			this.qtip = "请选中一条医嘱!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var UnusePermission = record.data["UnusePermission"];
		if(orderStatus == "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱已停止,不能作废!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "说明";
			this.qtip = "医嘱已执行过,不能作废!";
			return false ;
		}else if(UnusePermission == "0"){
			this.qtitle = "说明";
			this.qtip = "不是下医嘱人 或 医嘱已被执行!";
			return false ;
		}		
		return true;
	};
	addBillOrderHandler = function (b,e){
		var id = orderGridPanel.getSelectedRowIds();
		new Ext.Window({
			html:"<iframe src='dhcdoc.billorderrecord.csp?oeori="+id+"' scrolling='auto' style='width:1100px;height:400px;margin:0;padding:0'></iframe>",  
			renderTo:Ext.getBody(), 
			modal:true
		}).show();
	};
	addBillOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		if(!record.data["HIDDEN1"]){
			this.qtitle = "说明";
			this.qtip = "请选中一条医嘱!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var oeoriOeoriDr = record.data["HIDDEN3"];
		if(orderStatus == "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱已停止,不能增加!";
			return false ;
		}else if( oeoriOeoriDr!=""){
			this.qtitle = "说明";
			this.qtip = "请在主医嘱上增加记录!";			
			return false ;				
		}
		return true;
	};
});