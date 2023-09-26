///dhcdoc/dhcc.doc.OrderViewDoctor.js
Ext.ns("dhcc.doc");
var stopOrderHandler,cancelOrderHandler,abortOrderHandler,addExecOrderHandler,copyOrderHandler,copyPrnOrderHandler,copySosOrderHandler;
var stopOrderShowHandler,cancelOrderShowHandler,abortOrderShowHandler,addExecOrderShowHandler;
var consultationHandler,consultationShowHandler,surgeryApplyHandler;
var addOrderNotesHandler;
var OrderNotesNullMsg = "��עΪ��,����д��ע!";
var pswMsg = "����"
var pswNullMsg = "����Ϊ��,����д����!"
dhcc.icare.passwordKey = Ext.extend(Ext.form.Field, {
	width:160,inputType:'password',allowBlank: false,
	listeners:{"specialkey":function(textfield,fieldE){ var key=fieldE.getKey(); if(key==13){ textfield.findParentByType("window").buttons[0].handler.call();}}}
});
var radioCheckArr={"OrderTypeAll":false,"OrderTypeS":false,"OrderTypeOM":false};
var SelOrderPriorType="";
var obj=document.getElementById("OrderPriorType")
if(obj){
	SelOrderPriorType=obj.value;
} 
if ((SelOrderPriorType=="ShortOrderPrior")||(SelOrderPriorType=="OutOrderPrior")){
	radioCheckArr["OrderTypeOM"]=true;
}else if(SelOrderPriorType=="LongOrderPrior"){
	radioCheckArr["OrderTypeS"]=true;
}else{
	radioCheckArr["OrderTypeAll"]=true;
}
Ext.reg('passwordkey', dhcc.icare.passwordKey);
Ext.onReady(function(){
	Ext.QuickTips.init();	
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		listClassName: 'web.DHCDocOrderView',
		listQueryName: 'FindOrder',
		columnModelFieldJson: orderMetaDataJson,	
		internalType: 'DOCTOR',		
		orderType: "PRN",
		rowContextMenuHandler:function(g,rowIndex,e){
			e.stopEvent();		
			g.getSelectionModel().selectRow(rowIndex);
			var r = g.store.getAt(rowIndex);
			var rightKeyMenu=g.rightKeyMenu
			if(r.get("Priority").indexOf("����")>=0){
				var rightKeyMenu=g.rightKeyMenu	
			}else{
				if(g.rightSOSKeyMenu){
					var rightKeyMenu=g.rightSOSKeyMenu
				}
			}
			if(!rightKeyMenu) return;
			//g.rightKeyMenuHidden = false;
			if(false === g.fireEvent('rightKeyMenuShow',g,rowIndex)){
				g.rightKeyMenuHidden = true;
			}
			
			if(g.rightKeyMenuHidden) return ;
			rightKeyMenu.items.each(function(item){
				
				var status = item.displayHandler || {};			//2012-04-18 wanghc
				var arr,flag = true;
				if('function' == typeof status){				
					flag = status.call(this,r,rowIndex);	//this-->item ��ǰ�˵���Ŀ
				}else if('object' == typeof status){
							
					for (statu in status){
					
						if(status.hasOwnProperty(statu)){
							arr = statu.split("_");							
							flag = flag && (arr[1] == "Display") ;	
							if (status[statu].indexOf(r.data[arr[0]]) == -1) {
								flag = !flag;								
							} 													
						}
						if (!flag){break;}					//����ʾ������
					}	
				}		
			
				item.setDisabled(!flag);
				var cmp = Ext.getCmp(item.id)
				if(cmp && cmp.el && "undefined" !== typeof item.qtip){				
					cmp.el.dom.setAttribute("ext:qtip",item.qtip);
					if("undefined" !== typeof item.qtitle) cmp.el.dom.setAttribute("ext:qtitle",item.qtitle);
				}			
		});	
		rightKeyMenu.showAt(e.getXY());
		}
		/*,
		plugins:[new Ext.ux.plugins.GroupHeaderGrid({
				rows: [[
					{header: '��ʼ', colspan: 10, align: 'center'},
					{header: 'ֹͣ', colspan: 4, align: 'center'},
					{header: '����',colspan: 6, align: 'center'}					
				]],
				hierarchicalColMenu: true
		})]
		*/
		
	});
	var lis = {
			disable : function(t){
				if (t.qtip==undefined) t.qtip=""
				if (t.el) t.el.dom.setAttribute("ext:qtip",t.qtip) ; 
			},
			render :function(t){
				// �˵���ʾ��Ż�render,����el. disable��������render
				// evevt time line  disable-->render, ��һ��tip�÷���render��
				if(t.qtip) t.el.dom.setAttribute("ext:qtip",t.qtip) ;
			},
			enable : function(t){
				if(t.el) t.el.dom.setAttribute("ext:qtip","") ;
			}
		};
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','ҽ������:',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: 'ҽ������',
			width: 80,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode: 'local',
			value: "ALL",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","ȫ��"],["N","ҽ����"]]
			}),
			displayField: 'nursebillDesc',
			valueField: 'nursebillId',
			allowBlank:  false			
		});
		
		var operateMenu = new Ext.menu.Menu();
		operateMenu.add({
			text:"������ʱ",
			handler: function(b, e){
				copySosOrderHandler();
			}
		});
		operateMenu.add({
			text: '���Ƴ���',
			handler: function(b, e){
				copyPrnOrderHandler();
			}
		});
		operateMenu.add({
			text: '���Ƴ�Ժ��ҩ',
			handler: function(b, e){
				copyOutOrderHandler();
			}
		});
		operateMenu.add({
			text:'ͣ����',
			id:'stopOrdersBtn',
			act:'StopPrnOrder',
			handler:function(b,e){
				stopOrderHandler(b,e);		
			}
		});
		operateMenu.add({
			text:'��������',
			orgtext:"��������",
			id:"CancelOrdersBtn",
			listeners:lis,
			handler:function(b,e){
				cancelOrderHandler(b,e);
			}
		});
		operateMenu.add({
			text: '���϶���',	
			orgtext:"���϶���",	
			id:"AbortOrdersBtn",
			listeners:lis,
			handler: function(b, e){
				abortOrderHandler();
			}
		});
		operateMenu.on("show",function(){
			UpdateMenuStatus()	
		})
		/*orderTbar.add({
			text:"����",
			menu:operateMenu
		});*/
		orderTbar.doLayout();
		dhcc.doc.orderGridPanel.on("render",function(){
			orderGridPanel=dhcc.doc.orderGridPanel
		var NewToolBar=new Ext.Toolbar({
       renderTo : dhcc.doc.orderGridPanel.tbar,
       items :[
				'����:',
				"ȫ��"
				,{ 
					paramPosition: 8, 
					xtype:"radio", 
					width: 30,
					id:"OrderTypeAll",
					fieldLabel:"ȫ��",
					checked:radioCheckArr["OrderTypeAll"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeS").setValue(false)
							Ext.getCmp("OrderTypeOM").setValue(false)
							OrderPriorFindData(8,"ALL")
						}
					}
							
				},"����",{ 
					paramPosition: 9, 
					xtype:"radio",
					width: 30,
					id:"OrderTypeS",
					fieldLabel:"����",
					checked:radioCheckArr["OrderTypeS"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeOM").setValue(false)
							Ext.getCmp("OrderTypeAll").setValue(false)
							OrderPriorFindData(8,"S")
						}
					}
							
				},"����",{ 
					paramPosition: 10, 
					xtype:"radio", 
					width: 30,
					id:"OrderTypeOM",
					fieldLabel:"����",
					checked:radioCheckArr["OrderTypeOM"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeS").setValue(false)
							Ext.getCmp("OrderTypeAll").setValue(false)
							OrderPriorFindData(8,"OM")
						}
					}
							
				},'-',"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp����:",
				{ 
					paramPosition: 9, 
					xtype:"combo", 
					typeAhead: true,
					fieldLabel: '����',
					width: 80,
					name: "OrderCatType",
					id: "OrderCatTypeId",
					triggerAction: 'all',
					lazyRender: true,		
					mode: 'remote',
					value: "ALL",
					store: new Ext.data.ArrayStore({
						/*fields: ['OrderCatTypeId','OrderCatType'],
						data:[["ALL","ȫ��"],["R","ҩƷ"],["L","����"],["C","���"],["N","һ��ҽ��"]]*/
						fields: ['OrderCatTypeId','OrderCatType'],
						baseParams: {act: 'ordCatList'},
						url: "dhcdoc.request.csp"	
					}),
					displayField: 'OrderCatType',
					valueField: 'OrderCatTypeId',
					allowBlank:  false,
					value: 'ȫ��'		
				},'-',"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp����:",
				{ 
					paramPosition: 10, 
					xtype:"combo", 
					typeAhead: true,
					fieldLabel: '����',
					width: 100,
					name: "OrderSort",
					id: "OrderSortId",
					triggerAction: 'all',
					lazyRender: true,		
					mode: 'local',
					value: "AT",
					store: new Ext.data.ArrayStore({
						fields: ['OrderSortId','OrderSort'],
						data:[["AT","ʱ������"],["DT","ʱ�䵹��"]]
					}),
					displayField: 'OrderSort',
					valueField: 'OrderSortId',
					allowBlank:  false			
				},"-",'',{
					paramPosition: 11, 
					xtype:"field",
					width: 110,
					name: "OrderPriorType",
					id: "OrderPriorType",		
					value:SelOrderPriorType,
					hidden:true
				},'-',{
				    text:"����",
					menu:operateMenu
			    }
				
			]
		});
		var scopeDescObj=Ext.getCmp("scopeDesc")     
            scopeDescObj.store=new Ext.data.ArrayStore({
				fields: ['scopeId','scopeDesc'],
				data:[[1,"ȫ��"],[2,"����"],[3,"��ǰ"],[4,"�����"],[5,"��ֹͣ"],[6,"������Ч"],[7,"������Ч"]]
			})
		orderTbar.doLayout();
		AddToolBarPara(NewToolBar)
	})
	}
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );	
	stopOrderHandler = function(b, e){
		var titlePre = "ͣҽ�� ";
		if (b.id=="stopOrdersBtn"){
			titlePre = "ͣ����ҽ�� ";
		}		
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"];
		}
		var oeorisArr=oeoris.split("^");
		for (var i=0;i<oeorisArr.length;i++){
			var oeorirowid=oeorisArr[i]
			var flag=tkMakeServerCall("web.DHCDocMain","CheckStopOrder",oeorirowid,session['LOGON.USERID'],session['LOGON.CTLOCID'],session['LOGON.GROUPID'],'','')
            if (flag==0){
	            var ARCIMDesc=tkMakeServerCall("web.DHCDocMain","GetARCIMDesc",oeorirowid)
	            Ext.Msg.alert("��ʾ","����Ȩֹͣ"+ARCIMDesc);
				return;
	        }
	    }		
		
		var PHFreqInfo = tkMakeServerCall("web.DHCDocMain","GetPHFreqInfo",rowrecord.data["HIDDEN1"]);
		var PHFreqArr = PHFreqInfo.split(",");
		var timesData = [],PHFreqCount = PHFreqArr.length;
		if (PHFreqCount>0){
			var firstTime = PHFreqArr[0].slice(PHFreqArr[0].lastIndexOf(" ")+1);
			timesData.push([1+"�� "+firstTime,PHFreqArr[0].split(" ")[1]]);
			if(firstTime.indexOf(":")){
				for	(var i=1; i<PHFreqCount; i++){					
					timesData.push([(i+1)+"�� "+PHFreqArr[i],PHFreqArr[i]]);					
				}	
			}	
		}
		var win = new Ext.Window({					
			title: "<font color=red>"+titlePre+"</font>"+PHFreqInfo, layout: 'form',					
			width: 380, height: 230, modal: true,
			labelAlign:'right',		
			items: [
				{xtype:'checkbox',id:'isExpStopOrderCB', fieldLabel:'�Ƿ�Ԥͣ',listeners:{check:function(t,checked){
					var datecmp = Ext.getCmp("winStopOrderDate");
					var orderTimes = Ext.getCmp("winStopOrderTimes");
					var now = new Date();
					if(checked){
						datecmp.setDisabled(false);						
						datecmp.setMinValue(now);
						datecmp.setValue(now.add(Date.DAY,1));
						orderTimes.setDisabled(false);
					}else{											
						datecmp.setMinValue(now.add(Date.DAY,-1));
						datecmp.setValue(now);
						datecmp.setDisabled(true);
						orderTimes.setDisabled(true);	
					}
				}}},
				{xtype: 'uxdatefield', id: 'winStopOrderDate', fieldLabel:'ֹͣ����',width: 160, 
				format: dhcc.doc.orderGridPanel.dateFormat,value: new Date(),disabled:true
				},
				{xtype:'timefield', id: 'winStopOrderTime', fieldLabel:'ֹͣʱ��',width: 160, 
				format:"H:i:s", value: new Date().format('H:i:s')},
				//{xtype:'numberfield', id: 'winStopOrderTimes', fieldLabel:'ֹͣ����',width: 160,decimalPrecision:0,maxValue:PHFreqCount,minValue:1},
				{xtype:"combo",typeAhead: true, fieldLabel: 'ִ�д���', width: 160,
					name: "winStopOrderTimes", id: "winStopOrderTimes",
					triggerAction: 'all', lazyRender: true,	 mode: 'local',
					value: "", editable:false,disabled:true,
					store: new Ext.data.ArrayStore({
						fields: ['times','time'],
						data:timesData
					}),
					listeners:{
						'select':function(cb,r,index){
							var time = cb.getValue();
							Ext.getCmp("winStopOrderTime").setValue(time+":10");
						}
					},
					displayField: 'times',
					valueField: 'time',
					allowBlank:  false			
				},
			//{fieldLabel:'ѡ��ʱ��',xtype:"slider",width: 160,increment: 10,minValue: 0,maxValue: 100,plugins: new Ext.slider.Tip()},			
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'ֹͣ',iconCls:'icon-stoppresc-custom',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();						
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectedRow(); //.getSelectionModel().getSelected();
						var StDateTimeDefault=dhcc.doc.orderGridPanel.dateFormat+" "+"g:i";
						var DateTimeDefault=dhcc.doc.orderGridPanel.dateFormat+" "+"g:i:s";
						var stDateTime = Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], StDateTimeDefault);//Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], "Y-m-d g:i");
						var dateTime =  Date.parseDate(date+" "+time, DateTimeDefault);//Date.parseDate(date+" "+time, "d/m/Y g:i:s");
						if(!dateTime){
							alert("���ڻ�ʱ���ʽ����! ��/��/��  ʱ:��:��,��28/05/2011,11:05:01");
							return ;
						}
						if( dateTime.getTime() < stDateTime.getTime() ){
							Ext.Msg.alert("��ʾ","ֹͣʱ�䲻��С�ڿ�ʼʱ��!");
							return 
						}						
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg);
							return 
						}
						//������֤
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("��ʾ","ǩ���������!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}
						operateObj.sendAjax(b, e, {act:'StopPrnOrder',ExpectEndDate: date, ExpectEndTime:time, PinNum:pinnum});
						win.close();
					}
				},{ text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"];
		}
		var oeorisArr=oeoris.split("^");
		for (var i=0;i<oeorisArr.length;i++){
			var oeorirowid=oeorisArr[i]
			var flag=tkMakeServerCall("web.DHCDocMain","CheckCancelOrder",oeorirowid,session['LOGON.USERID'],session['LOGON.CTLOCID'],session['LOGON.GROUPID'])
            if (flag==0){
	            var ARCIMDesc=tkMakeServerCall("web.DHCDocMain","GetARCIMDesc",oeorirowid)
	            Ext.Msg.alert("��ʾ","����Ȩ����"+ARCIMDesc);
				return;
	        }
	    }

		var win = new Ext.Window({					
			title: '����(DC)ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:"combo",typeAhead: false, fieldLabel: '����ԭ��', width: 160,
					name: "OrdCancelReason", id: "OrdCancelReason",
					triggerAction: 'all', lazyRender: true,	 mode: 'remote',
					value: "", editable:true,disabled:false,
					store:  new Ext.data.ArrayStore({
						fields: ['id','text'],
						baseParams: {act: 'OECStatusChReasonList'},
						url: "dhcdoc.request.csp"			
					}),
					listeners:{
						'select':function(cb,r,index){
							Ext.fly("winPinNum").focus(100);
						}
					},
					displayField: 'text',
					valueField: 'id',
					allowBlank:  false			
				},
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg }		
			],
			buttons: [{
				text:'����(DC)',iconCls:'icon-skip-custom',handler: function(t,e){
						var OrdCancelReasonId = Ext.getCmp("OrdCancelReason").getValue();
						var OrdCancelReasonDesc=Ext.get('OrdCancelReason').dom.value;
						if (OrdCancelReasonId==OrdCancelReasonDesc) OrdCancelReasonId="";
						if ((OrdCancelReasonDesc=="")&&(OrdCancelReasonId=="")){
							Ext.Msg.alert("��ʾ","��ѡ������볷��ԭ��!");
							return
						}
						if ((OrdCancelReasonDesc!="")&&(OrdCancelReasonDesc.indexOf("^")>=0)){
							Ext.Msg.alert("��ʾ","����ԭ��ָ���^��ϵͳ��������,���������������!",function(){
								Ext.fly("OrdCancelReason").focus(100);
							});
							return
						}
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg);
							return 
						}	
						//������֤
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("��ʾ","ǩ���������!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}	
						operateObj.sendAjax(b, e, {act:'CancelPrnOrder',PinNum: pinnum,OrdCancelReasonId:OrdCancelReasonId,OrdCancelReasonDesc:OrdCancelReasonDesc});
						win.close();
					}
				},{ text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		//Ext.fly("winPinNum").focus(100);
		Ext.fly("OrdCancelReason").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var win = new Ext.Window({					
			title: '����ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:"combo",typeAhead: false, fieldLabel: '����ԭ��', width: 160,
					name: "OrdAbortReason", id: "OrdAbortReason",
					triggerAction: 'all', lazyRender: true,	 mode: 'remote',
					value: "", editable:true,disabled:false,
					store:  new Ext.data.ArrayStore({
						fields: ['id','text'],
						baseParams: {act: 'OECStatusChReasonList'},
						url: "dhcdoc.request.csp"			
					}),
					listeners:{
						'select':function(cb,r,index){
							Ext.fly("winPinNum").focus(100);
						}
					},
					displayField: 'text',
					valueField: 'id',
					allowBlank:  false			
				},
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg }		
			],
			buttons: [{
				text:'����',iconCls:'icon-ok-custom',handler: function(t,e){
						var OrdAbortReasonId = Ext.getCmp("OrdAbortReason").getValue();
						var OrdAbortReasonDesc=Ext.get('OrdAbortReason').dom.value;
						if (OrdAbortReasonId==OrdAbortReasonDesc) OrdAbortReasonId="";
						if ((OrdAbortReasonDesc=="")&&(OrdAbortReasonId=="")){
							Ext.Msg.alert("��ʾ","��ѡ�����������ԭ��!");
							return
						}		
						if ((OrdAbortReasonDesc!="")&&(OrdAbortReasonDesc.indexOf("^")>=0)){
							Ext.Msg.alert("��ʾ","����ԭ��ָ���^��ϵͳ��������,���������������!",function(){
								Ext.fly("OrdAbortReason").focus(100);
							});
							
							return
						}						
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg);
							return 
						}
						//������֤
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("��ʾ","ǩ���������!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}
						operateObj.sendAjax(b, e, {act:'UnUsePrnOrder',PinNum: pinnum,OrdAbortReasonId:OrdAbortReasonId,OrdAbortReasonDesc:OrdAbortReasonDesc});
						win.close();
					}
				},{ text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		//Ext.fly("winPinNum").focus(100);
		Ext.fly("OrdAbortReason").focus(100);
	}
	addExecOrderHandler = function (b,e){	
		var win = new Ext.Window({					
			title: '����ִ��ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'uxdatefield', id: 'ExStDate', fieldLabel:'Ҫ��ִ������', width:160,allowBlank: false, value: new Date(),format:dhcc.doc.orderGridPanel.dateFormat},
				{xtype: 'timefield', id: 'ExStTime', fieldLabel:'Ҫ��ִ��ʱ��', width:160,allowBlank: false,format:orderGridPanel.timeFormat}		
			],
			buttons: [{
				text:'����',
				iconCls:'icon-add-custom',
				handler: function(t,e){
						var exDate = Ext.fly("ExStDate").dom.value;
						var exTime = Ext.fly("ExStTime").dom.value;
						if ((exDate == '')||(exTime == '')){
							Ext.Msg.alert("��ʾ","����д������ʱ��!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddExecOrder',exStDate: exDate, exStTime: exTime},function(){
							var index = orderGridPanel.store.indexOf(orderGridPanel.getSelectionModel().getSelected());
							orderGridPanel.fireEvent("rowdblclick", orderGridPanel, index, null);
						});
						win.close();
					}
				},{ text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("ExStTime").focus(100);
	};
	/**
	* @method copyOrderHandler
	* @params {Object} cfg  ����{priorCode:"S}, ��ʱ{priorCode:"NORM"}
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
		if(oeoris!=""){			
			var frm = dhcsys_getmenuform();
			if (frm) {
				var papmi = frm.PatientID.value;
				var adm = frm.EpisodeID.value;
				var mradm = frm.mradm.value;
			}else{
				var papmi = PatientID;
				var adm = EpisodeID;
				var mradm = "";
			}
			if (LayoutControl && (LayoutControl=="NewOrderEntry")){
				parent.location.href = rewriteUrl(parent.location.href, {PatientID:papmi, EpisodeID:adm, mradm: mradm, copyOeoris: oeoris, copyTo: type}) ;
				//ҽ��¼����治��chart��
			}else{
				var mainFrame=null;
				var i=-1,j=0;
				var mainFrame = window.parent;
				if (mainFrame.orderTabIndex){i = mainFrame.orderTabIndex;}
				if (i==-1){
					while(mainFrame && j<10 && i==-1) {
						j++; mainFrame = mainFrame.parent;
						if(mainFrame.orderTabIndex) {i = mainFrame.orderTabIndex;	}
					}
				}
				if(!(i>-1)){
					alert("û�ҵ�DHCOEҳǩ!");
					return ;
				}
				var tp = mainFrame.Ext.getCmp("DHCDocTabPanel");
				var p = tp.getComponent(i);
				tp.setActiveTab(i);
				var iframe = p.el.dom.getElementsByTagName("iframe")[0];
				var iframesrc = iframe.src;			
				var url = mainFrame.rewriteUrl(p.src, {PatientID:papmi, EpisodeID:adm, mradm: mradm, copyOeoris: '', copyTo: ''});
				if (p.initialConfig) {
					p.initialConfig.cls = url;	
				}else{
					p.initialConfig = {};
					p.initialConfig.cls = url;	
				}
				var copyUrl = mainFrame.rewriteUrl(p.src, {PatientID:papmi, EpisodeID:adm, mradm: mradm, copyOeoris: oeoris, copyTo: type});
				iframe.src = copyUrl;
			}				
		}
	};
	copyPrnOrderHandler = function(){		
		copyOrderHandler({priorCode:"S"});
	};
	copySosOrderHandler = function(){		
		copyOrderHandler({priorCode:"NORM"});
	};
	copyOutOrderHandler= function(){		
		copyOrderHandler({priorCode:"OUT"});
	};
	addOrderNotesHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var proNote = tkMakeServerCall("web.DHCDocMain","GetOEORIdepProcNotes",rowrecord.data["HIDDEN1"]);
		var win = new Ext.Window({					
			title: '���ӱ�ע', layout: 'form',					
			width: 330, height: 230, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'textarea', id: 'OrderNotes', fieldLabel:"��ע",labelStyle: 'width:50px;', width:200,height:120,allowBlank: false,value:proNote}		
			],
			buttons: [{
				text:'ȷ��',iconCls:'icon-ok-custom',handler: function(t,e){								
						var OrderNotes = Ext.getCmp("OrderNotes").getValue();
						if (OrderNotes == ''){
							Ext.Msg.alert("��ʾ",OrderNotesNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddOrderNotes',OrderNotes: OrderNotes});
						win.close();
					}
				},{ text:'����',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("OrderNotes").focus(100);
	};
	/**
	*{HIDDEN2_Disable:['D','E'],StopPermission_Disable:['0']}
	*/
	stopOrderShowHandler = function (record,rowIndex){
		this.qtip = "";
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var StopPermission = record.data["StopPermission"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,����ֹͣ!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "˵��";
			this.qtip = "ҽ����ִ�й�,����ֹͣ!";
			return false ;
		}else if(StopPermission == "0"){
			this.qtitle = "˵��";
			this.qtip = "Ȩ�޲���!";
			return false ;
		}		
		return true;
	};
	/**
	*json-->show handler
	*{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}
	*/
	cancelOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var cancelPermission = record.data["CancelPermission"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,���ܳ���!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "˵��";
			this.qtip = "ҽ����ִ�й�,���ܳ���!";
			return false ;
		}else if(orderStatus == "C"){
			this.qtitle = "˵��";
			this.qtip = "ҽ���ѳ���,�����ٳ���!";
			return false ;
		}else if(orderStatus == "U"){
			this.qtitle = "˵��";
			this.qtip = "ҽ��������,���ܳ���!";
			return false ;
		}else if(cancelPermission == "0"){
			this.qtitle = "˵��";
			this.qtip = "Ȩ�޲��� �� ҽ���ѱ�ִ��!";
			return false ;
		}		
		return true;
	};
	/**
	*{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}
	*/
	abortOrderShowHandler = function (record,rowIndex){
		this.qtip = "";
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var UnusePermission = record.data["UnusePermission"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,��������!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "˵��";
			this.qtip = "ҽ����ִ�й�,��������!";
			return false ;
		}else if(orderStatus == "U"){
			this.qtitle = "˵��";
			this.qtip = "ҽ��������,����������!";
			return false ;
		}else if(UnusePermission == "0"){
			this.qtitle = "˵��";
			this.qtip = "������ҽ���� �� ҽ���ѱ�ִ��!";
			return false ;
		}		
		return true;
	};
	/**
	*{HIDDEN2_Disable:['D'],HIDDEN4_Display: ['Prn']}	
	*/
	addExecOrderShowHandler = function (record, rowIndex){
		this.qtip = "";
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var oeoriOeoriDr = record.data["HIDDEN3"];
		var PHFreqCode = record.data["HIDDEN4"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,��������!";
			return false ;
		}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
			this.qtitle = "˵��";
			this.qtip = "prnҽ����������!";
			return false ;
		}else if(PHFreqCode.toLocaleUpperCase() == "PRN" && oeoriOeoriDr!=""){
			this.qtitle = "˵��";
			this.qtip = "������ҽ��������ִ�м�¼!";			
			return false ;				
		}		
		return true;
	}
	surgeryApplyHandler = function(b, e){
		var o = orderGridPanel.getPatientJson();			
		if(o.EpisodeID>0){
			//window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP&opaId=&appType=ward&EpisodeID="+frm.EpisodeID.value,{window:window},"dialogHeight:800px;dialogWidth:1050px;resizable:yes");	
			window.showModalDialog("dhcclinic.anop.app.csp?opaId=&appType=ward&EpisodeID="+o.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:1050px;resizable:yes");	
		}
	};
	surgeryApplyShowHandler = function (record,rowIndex){
		this.qtip = ""
		if (patData.patFlag>0){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
		return true;	
	}	
	consultationShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (patData.patFlag>0){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
		return true;
	}
	bloodApplyShowHandler = function(record , rowIndex){
		this.qtip = "";
		if (patData.patFlag>0){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
		return true;
	}
	consultationHandler = function(b, e){
		var o = orderGridPanel.getPatientJson();			
		if(o.EpisodeID>0){
			window.showModalDialog("dhcconsultpat.csp?PatientID="+o.PatientID+"&EpisodeID="+o.EpisodeID,{window:window},"dialogHeight:800px;dialogWidth:900px;resizable:yes");	
		}
	};
	AddToolBarPara=function(ToolBarObj){
		
		var orderGridPanel = dhcc.doc.orderGridPanel;
		if( ToolBarObj){
			ToolBarObj.items.each(function(item,index){
				if(item.paramPosition){
					//orderGridPanel.conditionCmp.push(item);
					//alert(orderGridPanel.conditionCmp.length)
					orderGridPanel.store.baseParams["P"+(item.paramPosition)] = item.getValue();  
					if(Ext.getCmp("OrderTypeS").getValue()){
						OrderPriorFindData(8,"S")	
					}
					if(Ext.getCmp("OrderTypeAll").getValue()){
						OrderPriorFindData(8,"ALL")
					}
					if(Ext.getCmp("OrderTypeOM").getValue()){
						OrderPriorFindData(8,"OM")
					}
					if(item.xtype == 'combo'){
						item.on('select', function(cb,r,index){					
							var v =  cb.getValue();
							if(orderGridPanel.store.baseParams["P"+(item.paramPosition)] != v){
								orderGridPanel.deselectAll();
								orderGridPanel.store.baseParams["P"+(item.paramPosition)] = v;
								orderGridPanel.store.load();
							}
						});
					}
					if(item.xtype=='field'){
						item.on("specialkey",function(field, e){
		                     if (e.getKey() == e.ENTER) {
		                     	var v = field.getValue();
		                     	if(orderGridPanel.store.baseParams["P"+(item.paramPosition)] != v){
									orderGridPanel.deselectAll();
									orderGridPanel.store.baseParams["P"+(item.paramPosition)] = v;
									orderGridPanel.store.load();
								} 
		                     }
		                });
					}
				}
			});
		}
	}
	OrderPriorFindData=function(paramPosition,OrderTypeCode){
		var orderGridPanel = dhcc.doc.orderGridPanel;
		if(orderGridPanel.store.baseParams["P"+(paramPosition)] != OrderTypeCode){
			orderGridPanel.deselectAll();
			orderGridPanel.store.baseParams["P"+(paramPosition)] = OrderTypeCode;
			orderGridPanel.store.load();
		} 
	}
	UpdateMenuStatus=function(){
		if(Ext.getCmp("OrderTypeS").getValue()){
			var OrderTypeCode="S"	
		}
		if(Ext.getCmp("OrderTypeAll").getValue()){
			var OrderTypeCode="ALL"	
		}
		if(Ext.getCmp("OrderTypeOM").getValue()){
			var OrderTypeCode="OM"	
		}
		operateMenu.items.each(function(item){
				item.setDisabled(false);
				
				if(item.text=="ͣ����"){
					if(((OrderTypeCode=="ALL")||(OrderTypeCode=="OM"))){
						item.setDisabled(true);
						var cmp = Ext.getCmp(item.id)
						//alert(cmp.el)
						item.qtip="ֻ������Ϊ����ʱ����ʹ��ͣ��������"
						item.qtitle="˵��"
						if(cmp && cmp.el && "undefined" !== typeof item.qtip){				
							cmp.el.dom.setAttribute("ext:qtip","ֻ������Ϊ����ʱ����ʹ��ͣ��������");
							if("undefined" !== typeof item.qtitle) cmp.el.dom.setAttribute("ext:qtitle","˵��");
						}			
					}else{
						var cmp = Ext.getCmp(item.id)
						if(cmp && cmp.el && "undefined" !== typeof item.qtip){				
							cmp.el.dom.setAttribute("ext:qtip","");
							if("undefined" !== typeof item.qtitle) cmp.el.dom.setAttribute("ext:qtitle","");
						}
						item.qtitle=""
						item.qtip=""	
					}
				}	
					
		});	
	}
});

