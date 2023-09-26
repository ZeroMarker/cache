var cancelOrderHandler,abortOrderHandler,surgeryApplyHandler,consultationHandler,bloodApplyHandler,copyOrderHandler,copySosOrderHandler,copyPrnOrderHandler;
var surgeryApplyShowHandler,consultationShowHandler,bloodApplyShowHandler;
var addOrderNotesHandler;
var cancelOrderShowHandler,abortOrderShowHandler;
var pswMsg = "密码"
var pswNullMsg = "密码为空,请填写密码!"
var OrderNotesNullMsg = "备注为空,请填写备注!";
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
		listQueryName: 'FindSosOrder',
		columnModelFieldJson: window.orderMetaDataJson,		
		internalType: 'DOCTOR',	//NURSE
		orderType: "SOS" //"PRN"	
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','医嘱单型',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: '医嘱单型',
			width: 65,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode: 'local',
			value: "N",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","全部"],["N","医嘱单"]]
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
		var lis = {
			disable : function(t){
				if (t.qtip==undefined) t.qtip=""
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
		var operateMenu = new Ext.menu.Menu();
		operateMenu.add({			
			text: '复制临时',
			id:"copySosOrdersBtn",
			listeners:lis,			
			handler: function(b, e){
				copySosOrderHandler();
			}		
		});
		operateMenu.add({
			text: '复制长期',
			id:"copyPrnOrdersBtn",
			listeners:lis,			
			handler: function(b, e){
				copyPrnOrderHandler();
			}
		});
		operateMenu.add({
			text: '复制出院带药',
			id:"copyOutOrdersBtn",
			listeners:lis,			
			handler: function(b, e){
				copyOutOrderHandler();
			}
		});
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
		orderTbar.add({text:"操作", menu:operateMenu});
		orderTbar.doLayout();
	}
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"]
		}
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
						//刷新患者列表
						var flag = tkMakeServerCall("appcom.OEOrdItem", "RefresPatList",oeoris)
						if ((window.parent.patientTreePanel)&&(flag=="Y")){
							window.parent.patientTreePanel.store.load();
						}
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();	
        var o = orderGridPanel.getPatientJson(); 
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"]
		}
		
		var flag = tkMakeServerCall("web.DHCDocMain", "isHiddenMenu",o.EpisodeID, session['LOGON.CTLOCID'])
		if(flag!=0){
		   var CurrentDischargeStatus=tkMakeServerCall("web.DHCDischargeHistory","GetCurrentDischargeStatus",o.EpisodeID)
		   if (CurrentDischargeStatus!="B"){
			   var CheckOrdIsDis = tkMakeServerCall("appcom.OEOrdItem", "CheckOrdIsDis",oeoris)
			   if (CheckOrdIsDis==0){
				   if(flag!=2){
					   Ext.Msg.alert("提示","患者已做医疗结算,不能作废!");
					   return false;
				   }
			   }else{
				   Ext.Msg.alert("提示","患者已做医疗结算,非出院医嘱不能作废!");
				  return false;
			   }
		   }
		}	
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
						//刷新患者列表
						var flag = tkMakeServerCall("appcom.OEOrdItem", "RefresPatList",oeoris)
						if ((window.parent.patientTreePanel)&&(flag=="Y")){
							window.parent.patientTreePanel.store.load();
						}
			}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	}
	surgeryApplyHandler = function(b, e){
		var o = orderGridPanel.getPatientJson();			
		if(o.EpisodeID>0){
			//window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP&opaId=&appType=ward&EpisodeID="+frm.EpisodeID.value,{window:window},"dialogHeight:800px;dialogWidth:1050px;resizable:yes");	
			window.showModalDialog("dhcclinic.anop.app.csp?opaId=&appType=ward&EpisodeID="+o.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1050px;resizable:yes");	
		}
	};
	consultationHandler = function(b, e){
		var o = orderGridPanel.getPatientJson();			
		if(o.EpisodeID>0){
			window.showModalDialog("dhcconsultpat.csp?PatientID="+o.PatientID+"&EpisodeID="+o.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:900px;resizable:yes");	
		}
	};
	bloodApplyHandler = function(b ,e ){
		var o = orderGridPanel.getPatientJson();			
		if(o.EpisodeID>0){
			//dhcbldappform.csp  old:lis.bld.manage.csp
			window.showModalDialog("dhclab.bs.main.csp?PatientID="+o.PatientID+"&EpisodeID="+o.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1200px;resizable:yes");	
		}
	};
/**
	* @method copyOrderHandler
	* @params {Object} cfg  长期{priorCode:"S}, 临时{priorCode:"NORM"}
	*/
	copyOrderHandler = function(cfg){
		var type = cfg.priorCode;
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
		   var rowrecord = orderGridPanel.getSelectedRow();
		   if(rowrecord){
			   oeoris=rowrecord.data["HIDDEN1"]
		   }
		}
		var Outoeoris="";
		if(type=="OUT"){
			var records=orderGridPanel.getAllPageSelectedRowObjs();
			for(var i=0;i<records.length;i++){
				if(records[i]["OrderType"]=="R"){
					if(Outoeoris==""){
						Outoeoris=records[i]["HIDDEN1"];
					}else{
						Outoeoris=Outoeoris+"^"+records[i]["HIDDEN1"];
					}
				}
			}
			oeoris=Outoeoris;
		}
		if(oeoris!=""){			
			var urlExParam = {"copyOeoris": oeoris, "copyTo": type} 
			var o = orderGridPanel.getPatientJson();
			if (o){
				urlExParam = Ext.apply(urlExParam,o);
			}else{
				Ext.Msg.alert("提示","请先查询再复制医嘱!");
				return false;
			}
			if (LayoutControl && (LayoutControl=="NewOrderEntry")){
				parent.location.href = rewriteUrl(parent.location.href, urlExParam) ;
				//医嘱录入界面不在chart内
			}else{
				var i=-1,j=0;
				var mainFrame = window.parent;
				if (mainFrame.orderTabIndex){i = mainFrame.orderTabIndex;}
				if (i==-1){
					while(mainFrame && j<10 && i==-1) {
						j++; mainFrame = mainFrame.parent;
						if(mainFrame.orderTabIndex) {i = mainFrame.orderTabIndex;	}
					}
				}			
				var i = mainFrame.orderTabIndex;	//DHCOE页签的位置
				if(!(i>-1)){
					alert("没找到DHCOE页签!");
					return ;
				}
				var tp = mainFrame.Ext.getCmp("DHCDocTabPanel");
				var p = tp.getComponent(i);
				tp.setActiveTab(i);
				var iframe = p.el.dom.getElementsByTagName("iframe")[0];
				var iframesrc = iframe.src;			
				var url = mainFrame.rewriteUrl(p.src,Ext.apply({copyOeoris: '', copyTo: ''},o));
				if (p.initialConfig) {
					p.initialConfig.cls = url;	
				}else{
					p.initialConfig = {};
					p.initialConfig.cls = url;	
				}
				var copyUrl = mainFrame.rewriteUrl(p.src, urlExParam);			
				iframe.src = copyUrl;
			}
		}
	};
	copySosOrderHandler = function(){		
		copyOrderHandler({priorCode:"NORM"});
	};
	copyPrnOrderHandler	= function(){
		copyOrderHandler({priorCode:"S"});
	};
	copyOutOrderHandler= function(){		
		copyOrderHandler({priorCode:"OUT"});
	};
	addOrderNotesHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var proNote = tkMakeServerCall("web.DHCDocMain","GetOEORIdepProcNotes",rowrecord.data["HIDDEN1"]);
		var win = new Ext.Window({					
			title: '增加备注', layout: 'form',					
			width: 330, height: 230, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'textarea', id: 'OrderNotes', fieldLabel:"备注",labelStyle: 'width:50px;', width:200,height:120,allowBlank: false,value:proNote}		
			],
			buttons: [{
				text:'确定',handler: function(t,e){								
						var OrderNotes = Ext.getCmp("OrderNotes").getValue();
						if (OrderNotes == ''){
							Ext.Msg.alert("提示",OrderNotesNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddOrderNotes',OrderNotes: OrderNotes});
						win.close();
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("OrderNotes").focus(100);
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
			this.qtip = "权限不够 或 医嘱已被执行 或 不是出院医嘱!";
			return false ;
		}	
		/*如果检查有申请单号,则不能取消*/
		var OrderItemRowId=record.data["HIDDEN1"];
	    var TmInfo=tkMakeServerCall("DHCDoc.Interface.Inside.Common","GetTmInfoByOrderRowId",OrderItemRowId)
	    if (TmInfo!=""){
		    this.qtitle = "说明";
			this.qtip = "医嘱存在病理申请单号,请在相应的病理申请界面取消申请!";
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
		/*如果检查有申请单号,则不能取消*/
		var OrderItemRowId=record.data["HIDDEN1"];
	    var TmInfo=tkMakeServerCall("DHCDoc.Interface.Inside.Common","GetTmInfoByOrderRowId",OrderItemRowId)
	    if (TmInfo!=""){
		    this.qtitle = "说明";
			this.qtip = "医嘱存在病理申请单号,请在相应的病理申请界面取消申请!";
			return false ;
		}	
		return true;
	};
	surgeryApplyShowHandler = function (record,rowIndex){
		this.qtip = ""
		if (patData.patFlag>0){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		return true;	
	}	
	consultationShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (patData.patFlag>0){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		return true;
	}
	bloodApplyShowHandler = function(record , rowIndex){
		this.qtip = "";
		if (patData.patFlag>0){
			this.qtitle = "说明";
			this.qtip = "病人已"+patData.flagDesc+"!";
			return false;
		}
		return true;
	}
	
});