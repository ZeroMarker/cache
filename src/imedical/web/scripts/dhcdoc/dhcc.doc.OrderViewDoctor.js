///dhcdoc/dhcc.doc.OrderViewDoctor.js
Ext.ns("dhcc.doc");
var stopOrderHandler,cancelOrderHandler,abortOrderHandler,addExecOrderHandler,copyOrderHandler,copyPrnOrderHandler,copySosOrderHandler;
var stopOrderShowHandler,cancelOrderShowHandler,abortOrderShowHandler,addExecOrderShowHandler;
var consultationHandler,consultationShowHandler,surgeryApplyHandler;
var addOrderNotesHandler;
var OrderNotesNullMsg = "备注为空,请填写备注!";
var pswMsg = "密码"
var pswNullMsg = "密码为空,请填写密码!"
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
			if(r.get("Priority").indexOf("长期")>=0){
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
					flag = status.call(this,r,rowIndex);	//this-->item 当前菜单项目
				}else if('object' == typeof status){
							
					for (statu in status){
					
						if(status.hasOwnProperty(statu)){
							arr = statu.split("_");							
							flag = flag && (arr[1] == "Display") ;	
							if (status[statu].indexOf(r.data[arr[0]]) == -1) {
								flag = !flag;								
							} 													
						}
						if (!flag){break;}					//不显示就跳出
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
					{header: '开始', colspan: 10, align: 'center'},
					{header: '停止', colspan: 4, align: 'center'},
					{header: '其它',colspan: 6, align: 'center'}					
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
				// 菜单显示后才会render,才有el. disable可以先以render
				// evevt time line  disable-->render, 第一次tip得放在render内
				if(t.qtip) t.el.dom.setAttribute("ext:qtip",t.qtip) ;
			},
			enable : function(t){
				if(t.el) t.el.dom.setAttribute("ext:qtip","") ;
			}
		};
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','医嘱单型:',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: '医嘱单型',
			width: 80,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode: 'local',
			value: "ALL",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","全部"],["N","医嘱单"]]
			}),
			displayField: 'nursebillDesc',
			valueField: 'nursebillId',
			allowBlank:  false			
		});
		
		var operateMenu = new Ext.menu.Menu();
		operateMenu.add({
			text:"复制临时",
			handler: function(b, e){
				copySosOrderHandler();
			}
		});
		operateMenu.add({
			text: '复制长期',
			handler: function(b, e){
				copyPrnOrderHandler();
			}
		});
		operateMenu.add({
			text: '复制出院带药',
			handler: function(b, e){
				copyOutOrderHandler();
			}
		});
		operateMenu.add({
			text:'停多条',
			id:'stopOrdersBtn',
			act:'StopPrnOrder',
			handler:function(b,e){
				stopOrderHandler(b,e);		
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
		operateMenu.on("show",function(){
			UpdateMenuStatus()	
		})
		/*orderTbar.add({
			text:"操作",
			menu:operateMenu
		});*/
		orderTbar.doLayout();
		dhcc.doc.orderGridPanel.on("render",function(){
			orderGridPanel=dhcc.doc.orderGridPanel
		var NewToolBar=new Ext.Toolbar({
       renderTo : dhcc.doc.orderGridPanel.tbar,
       items :[
				'类型:',
				"全部"
				,{ 
					paramPosition: 8, 
					xtype:"radio", 
					width: 30,
					id:"OrderTypeAll",
					fieldLabel:"全部",
					checked:radioCheckArr["OrderTypeAll"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeS").setValue(false)
							Ext.getCmp("OrderTypeOM").setValue(false)
							OrderPriorFindData(8,"ALL")
						}
					}
							
				},"长嘱",{ 
					paramPosition: 9, 
					xtype:"radio",
					width: 30,
					id:"OrderTypeS",
					fieldLabel:"长嘱",
					checked:radioCheckArr["OrderTypeS"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeOM").setValue(false)
							Ext.getCmp("OrderTypeAll").setValue(false)
							OrderPriorFindData(8,"S")
						}
					}
							
				},"临嘱",{ 
					paramPosition: 10, 
					xtype:"radio", 
					width: 30,
					id:"OrderTypeOM",
					fieldLabel:"临嘱",
					checked:radioCheckArr["OrderTypeOM"],
					handler:function(b,e){
						if(b.checked){
							Ext.getCmp("OrderTypeS").setValue(false)
							Ext.getCmp("OrderTypeAll").setValue(false)
							OrderPriorFindData(8,"OM")
						}
					}
							
				},'-',"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp分类:",
				{ 
					paramPosition: 9, 
					xtype:"combo", 
					typeAhead: true,
					fieldLabel: '分类',
					width: 80,
					name: "OrderCatType",
					id: "OrderCatTypeId",
					triggerAction: 'all',
					lazyRender: true,		
					mode: 'remote',
					value: "ALL",
					store: new Ext.data.ArrayStore({
						/*fields: ['OrderCatTypeId','OrderCatType'],
						data:[["ALL","全部"],["R","药品"],["L","检验"],["C","检查"],["N","一般医嘱"]]*/
						fields: ['OrderCatTypeId','OrderCatType'],
						baseParams: {act: 'ordCatList'},
						url: "dhcdoc.request.csp"	
					}),
					displayField: 'OrderCatType',
					valueField: 'OrderCatTypeId',
					allowBlank:  false,
					value: '全部'		
				},'-',"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp排序:",
				{ 
					paramPosition: 10, 
					xtype:"combo", 
					typeAhead: true,
					fieldLabel: '排序',
					width: 100,
					name: "OrderSort",
					id: "OrderSortId",
					triggerAction: 'all',
					lazyRender: true,		
					mode: 'local',
					value: "AT",
					store: new Ext.data.ArrayStore({
						fields: ['OrderSortId','OrderSort'],
						data:[["AT","时间正序"],["DT","时间倒序"]]
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
				    text:"操作",
					menu:operateMenu
			    }
				
			]
		});
		var scopeDescObj=Ext.getCmp("scopeDesc")     
            scopeDescObj.store=new Ext.data.ArrayStore({
				fields: ['scopeId','scopeDesc'],
				data:[[1,"全部"],[2,"作废"],[3,"当前"],[4,"待审核"],[5,"已停止"],[6,"今日有效"],[7,"三日有效"]]
			})
		orderTbar.doLayout();
		AddToolBarPara(NewToolBar)
	})
	}
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );	
	stopOrderHandler = function(b, e){
		var titlePre = "停医嘱 ";
		if (b.id=="stopOrdersBtn"){
			titlePre = "停多条医嘱 ";
		}		
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("提示","没有选中医嘱!");
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
	            Ext.Msg.alert("提示","您无权停止"+ARCIMDesc);
				return;
	        }
	    }		
		
		var PHFreqInfo = tkMakeServerCall("web.DHCDocMain","GetPHFreqInfo",rowrecord.data["HIDDEN1"]);
		var PHFreqArr = PHFreqInfo.split(",");
		var timesData = [],PHFreqCount = PHFreqArr.length;
		if (PHFreqCount>0){
			var firstTime = PHFreqArr[0].slice(PHFreqArr[0].lastIndexOf(" ")+1);
			timesData.push([1+"次 "+firstTime,PHFreqArr[0].split(" ")[1]]);
			if(firstTime.indexOf(":")){
				for	(var i=1; i<PHFreqCount; i++){					
					timesData.push([(i+1)+"次 "+PHFreqArr[i],PHFreqArr[i]]);					
				}	
			}	
		}
		var win = new Ext.Window({					
			title: "<font color=red>"+titlePre+"</font>"+PHFreqInfo, layout: 'form',					
			width: 380, height: 230, modal: true,
			labelAlign:'right',		
			items: [
				{xtype:'checkbox',id:'isExpStopOrderCB', fieldLabel:'是否预停',listeners:{check:function(t,checked){
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
				{xtype: 'uxdatefield', id: 'winStopOrderDate', fieldLabel:'停止日期',width: 160, 
				format: dhcc.doc.orderGridPanel.dateFormat,value: new Date(),disabled:true
				},
				{xtype:'timefield', id: 'winStopOrderTime', fieldLabel:'停止时间',width: 160, 
				format:"H:i:s", value: new Date().format('H:i:s')},
				//{xtype:'numberfield', id: 'winStopOrderTimes', fieldLabel:'停止次数',width: 160,decimalPrecision:0,maxValue:PHFreqCount,minValue:1},
				{xtype:"combo",typeAhead: true, fieldLabel: '执行次数', width: 160,
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
			//{fieldLabel:'选择时间',xtype:"slider",width: 160,increment: 10,minValue: 0,maxValue: 100,plugins: new Ext.slider.Tip()},			
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'停止',iconCls:'icon-stoppresc-custom',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();						
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectedRow(); //.getSelectionModel().getSelected();
						var StDateTimeDefault=dhcc.doc.orderGridPanel.dateFormat+" "+"g:i";
						var DateTimeDefault=dhcc.doc.orderGridPanel.dateFormat+" "+"g:i:s";
						var stDateTime = Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], StDateTimeDefault);//Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], "Y-m-d g:i");
						var dateTime =  Date.parseDate(date+" "+time, DateTimeDefault);//Date.parseDate(date+" "+time, "d/m/Y g:i:s");
						if(!dateTime){
							alert("日期或时间格式不对! 日/月/年  时:分:秒,如28/05/2011,11:05:01");
							return ;
						}
						if( dateTime.getTime() < stDateTime.getTime() ){
							Ext.Msg.alert("提示","停止时间不能小于开始时间!");
							return 
						}						
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示",pswNullMsg);
							return 
						}
						//密码验证
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("提示","签名密码错误!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}
						operateObj.sendAjax(b, e, {act:'StopPrnOrder',ExpectEndDate: date, ExpectEndTime:time, PinNum:pinnum});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("提示","没有选中医嘱!");
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
	            Ext.Msg.alert("提示","您无权撤销"+ARCIMDesc);
				return;
	        }
	    }

		var win = new Ext.Window({					
			title: '撤消(DC)医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:"combo",typeAhead: false, fieldLabel: '撤销原因', width: 160,
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
				text:'撤消(DC)',iconCls:'icon-skip-custom',handler: function(t,e){
						var OrdCancelReasonId = Ext.getCmp("OrdCancelReason").getValue();
						var OrdCancelReasonDesc=Ext.get('OrdCancelReason').dom.value;
						if (OrdCancelReasonId==OrdCancelReasonDesc) OrdCancelReasonId="";
						if ((OrdCancelReasonDesc=="")&&(OrdCancelReasonId=="")){
							Ext.Msg.alert("提示","请选择或输入撤销原因!");
							return
						}
						if ((OrdCancelReasonDesc!="")&&(OrdCancelReasonDesc.indexOf("^")>=0)){
							Ext.Msg.alert("提示","撤销原因分隔符^是系统保留符号,请更换成其他符号!",function(){
								Ext.fly("OrdCancelReason").focus(100);
							});
							return
						}
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示",pswNullMsg);
							return 
						}	
						//密码验证
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("提示","签名密码错误!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}	
						operateObj.sendAjax(b, e, {act:'CancelPrnOrder',PinNum: pinnum,OrdCancelReasonId:OrdCancelReasonId,OrdCancelReasonDesc:OrdCancelReasonDesc});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		//Ext.fly("winPinNum").focus(100);
		Ext.fly("OrdCancelReason").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var win = new Ext.Window({					
			title: '作废医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:"combo",typeAhead: false, fieldLabel: '作废原因', width: 160,
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
				text:'作废',iconCls:'icon-ok-custom',handler: function(t,e){
						var OrdAbortReasonId = Ext.getCmp("OrdAbortReason").getValue();
						var OrdAbortReasonDesc=Ext.get('OrdAbortReason').dom.value;
						if (OrdAbortReasonId==OrdAbortReasonDesc) OrdAbortReasonId="";
						if ((OrdAbortReasonDesc=="")&&(OrdAbortReasonId=="")){
							Ext.Msg.alert("提示","请选择或输入作废原因!");
							return
						}		
						if ((OrdAbortReasonDesc!="")&&(OrdAbortReasonDesc.indexOf("^")>=0)){
							Ext.Msg.alert("提示","作废原因分隔符^是系统保留符号,请更换成其他符号!",function(){
								Ext.fly("OrdAbortReason").focus(100);
							});
							
							return
						}						
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示",pswNullMsg);
							return 
						}
						//密码验证
					 	var err=tkMakeServerCall("web.DHCOEOrdItem","PinNumberValid",session['LOGON.USERID'],pinnum) 
						if (err!=0){
							Ext.Msg.alert("提示","签名密码错误!",function(){
								Ext.fly("winPinNum").focus(100);
							});
							return 
						}
						operateObj.sendAjax(b, e, {act:'UnUsePrnOrder',PinNum: pinnum,OrdAbortReasonId:OrdAbortReasonId,OrdAbortReasonDesc:OrdAbortReasonDesc});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		//Ext.fly("winPinNum").focus(100);
		Ext.fly("OrdAbortReason").focus(100);
	}
	addExecOrderHandler = function (b,e){	
		var win = new Ext.Window({					
			title: '增加执行医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'uxdatefield', id: 'ExStDate', fieldLabel:'要求执行日期', width:160,allowBlank: false, value: new Date(),format:dhcc.doc.orderGridPanel.dateFormat},
				{xtype: 'timefield', id: 'ExStTime', fieldLabel:'要求执行时间', width:160,allowBlank: false,format:orderGridPanel.timeFormat}		
			],
			buttons: [{
				text:'增加',
				iconCls:'icon-add-custom',
				handler: function(t,e){
						var exDate = Ext.fly("ExStDate").dom.value;
						var exTime = Ext.fly("ExStTime").dom.value;
						if ((exDate == '')||(exTime == '')){
							Ext.Msg.alert("提示","请填写日期与时间!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddExecOrder',exStDate: exDate, exStTime: exTime},function(){
							var index = orderGridPanel.store.indexOf(orderGridPanel.getSelectionModel().getSelected());
							orderGridPanel.fireEvent("rowdblclick", orderGridPanel, index, null);
						});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("ExStTime").focus(100);
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
				//医嘱录入界面不在chart内
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
					alert("没找到DHCOE页签!");
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
			title: '增加备注', layout: 'form',					
			width: 330, height: 230, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'textarea', id: 'OrderNotes', fieldLabel:"备注",labelStyle: 'width:50px;', width:200,height:120,allowBlank: false,value:proNote}		
			],
			buttons: [{
				text:'确定',iconCls:'icon-ok-custom',handler: function(t,e){								
						var OrderNotes = Ext.getCmp("OrderNotes").getValue();
						if (OrderNotes == ''){
							Ext.Msg.alert("提示",OrderNotesNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddOrderNotes',OrderNotes: OrderNotes});
						win.close();
					}
				},{ text:'返回',iconCls:'icon-undo-custom',handler: function(t,e){ win.close();}
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
			this.qtitle = "说明";
			this.qtip = "请选中一条医嘱!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var StopPermission = record.data["StopPermission"];
		if(orderStatus == "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱已停止,不能停止!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "说明";
			this.qtip = "医嘱已执行过,不能停止!";
			return false ;
		}else if(StopPermission == "0"){
			this.qtitle = "说明";
			this.qtip = "权限不够!";
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
		}else if(orderStatus == "C"){
			this.qtitle = "说明";
			this.qtip = "医嘱已撤销,不能再撤销!";
			return false ;
		}else if(orderStatus == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废,不能撤销!";
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
	abortOrderShowHandler = function (record,rowIndex){
		this.qtip = "";
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
		}else if(orderStatus == "U"){
			this.qtitle = "说明";
			this.qtip = "医嘱已作废,不能再作废!";
			return false ;
		}else if(UnusePermission == "0"){
			this.qtitle = "说明";
			this.qtip = "不是下医嘱人 或 医嘱已被执行!";
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
			this.qtitle = "说明";
			this.qtip = "请选中一条医嘱!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var oeoriOeoriDr = record.data["HIDDEN3"];
		var PHFreqCode = record.data["HIDDEN4"];
		if(orderStatus == "D") {
			this.qtitle = "说明";
			this.qtip = "医嘱已停止,不能增加!";
			return false ;
		}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
			this.qtitle = "说明";
			this.qtip = "prn医嘱才能增加!";
			return false ;
		}else if(PHFreqCode.toLocaleUpperCase() == "PRN" && oeoriOeoriDr!=""){
			this.qtitle = "说明";
			this.qtip = "请在主医嘱上增加执行记录!";			
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
				
				if(item.text=="停多条"){
					if(((OrderTypeCode=="ALL")||(OrderTypeCode=="OM"))){
						item.setDisabled(true);
						var cmp = Ext.getCmp(item.id)
						//alert(cmp.el)
						item.qtip="只有类型为长嘱时才能使用停多条功能"
						item.qtitle="说明"
						if(cmp && cmp.el && "undefined" !== typeof item.qtip){				
							cmp.el.dom.setAttribute("ext:qtip","只有类型为长嘱时才能使用停多条功能");
							if("undefined" !== typeof item.qtitle) cmp.el.dom.setAttribute("ext:qtitle","说明");
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

