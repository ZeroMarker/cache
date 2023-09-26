var stopOrderHandler,cancelOrderHandler,abortOrderHandler,addExecOrderHandler,addBillOrderHandler;
var stopOrderShowHandler,cancelOrderShowHandler,abortOrderShowHandler,addExecOrderShowHandler,addBillOrderShowHandler;
var pswMsg = "����"
var pswNullMsg = "����Ϊ��,����д����!"
Ext.ns("dhcc.doc");
dhcc.icare.passwordKey = Ext.extend(Ext.form.Field, {
	width:160,inputType:'password',allowBlank: false,
	listeners:{"specialkey":function(textfield,fieldE){ var key=fieldE.getKey(); if(key==13){ textfield.findParentByType("window").buttons[0].handler.call();}}}
});
var dateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (dateFormat=="3"){
    dateFormat="Y-m-d"
}else if(dateFormat=="4"){
	dateFormat="d/m/Y"
}else{
	dateFormat=orderGridPanel.dateFormat;
}
Ext.reg('passwordkey', dhcc.icare.passwordKey);
Ext.onReady(function(){
	Ext.QuickTips.init();
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		listClassName: 'web.DHCDocPrnOrder',
		listQueryName: 'FindPrnOrderNurse',
		columnModelFieldJson: window.orderMetaDataJson,
		internalType: 'NURSE',
		orderType: "PRN",
		//bbarItems:['-',{text:"ͣ����ҽ��"}],
		plugins:[new Ext.ux.plugins.GroupHeaderGrid({
				rows: [[
					{header: '��ʼ', colspan: 10, align: 'center'},
					{header: 'ֹͣ', colspan: 4, align: 'center'},{},{},{}						
				]],
				hierarchicalColMenu: true
		})]
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','ҽ������',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: 'ҽ������',
			width: 65,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode: 'local',
			value: "ALL",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","ȫ��"],["Y","������"],["N","ҽ����"]]
			}),
			displayField: 'nursebillDesc',
			valueField: 'nursebillId',
			allowBlank:  false			
		});	
		var operateMenu = new Ext.menu.Menu();
		var lis = {
			disable : function(t){
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
		operateMenu.add({
			text:'ͣ����',
			orgtext:"ͣ����",
			id:'stopOrdersBtn',
			act:'StopPrnOrder',
			listeners:lis,
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
		orderTbar.add({
			text:"����",
			menu:operateMenu
		});
		orderTbar.doLayout();
	};
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );	
	stopOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}
		var PHFreqInfo = tkMakeServerCall("web.DHCDocMain","GetPHFreqInfo",rowrecord.data["HIDDEN1"]);
		var PHFreqArr = PHFreqInfo.split(",");
		var timesData = [],PHFreqCount = PHFreqArr.length;
		if (PHFreqCount>0){
			var firstTime = PHFreqArr[0].slice(PHFreqArr[0].lastIndexOf(" ")+1);
			timesData.push([1+"�� "+firstTime,firstTime]);
			if(firstTime.indexOf(":")){
				for	(var i=1; i<PHFreqCount; i++){					
					timesData.push([(i+1)+"�� "+PHFreqArr[i],PHFreqArr[i]]);					
				}	
			}	
		}
		
		var win = new Ext.Window({					
			title: 'ͣҽ�� '+PHFreqInfo, layout: 'form',					
			width: 350, height: 250, modal: true,
			labelAlign:'right',		
			items: [
				{xtype:'checkbox',id:'isExpStopOrderCB', fieldLabel:'�Ƿ�Ԥͣ',listeners:{check:function(t,checked){
					var datecmp = Ext.getCmp("winStopOrderDate");					
					var now = new Date();
					if(checked){
						datecmp.setDisabled(false);						
						datecmp.setMinValue(now);
						datecmp.setValue(now.add(Date.DAY,1));						
					}else{											
						datecmp.setMinValue(now.add(Date.DAY,-1));
						datecmp.setValue(now);
						datecmp.setDisabled(true);											
					}
				}}},
				{xtype:'datefield', id: 'winStopOrderDate', fieldLabel:'ֹͣ����',width: 160, 
				format: dateFormat,value: new Date(),disabled:true},
				{xtype:'timefield', id: 'winStopOrderTime', fieldLabel:'ֹͣʱ��',width: 160, 
				format:"H:i:s", value: new Date().format('H:i:s')},
				//{xtype:'numberfield', id: 'winStopOrderTimes', fieldLabel:'ֹͣ����',width: 160,decimalPrecision:0,maxValue:PHFreqCount,minValue:1},
				{xtype:"combo",typeAhead: true, fieldLabel: 'ִ�д���', width: 160,
					name: "winStopOrderTimes", id: "winStopOrderTimes",
					triggerAction: 'all', lazyRender: true,	 mode: 'local',
					value: "", editable:false,
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
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'ֹͣ',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();						
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectedRow(); //.getSelectionModel().getSelected();
						//var stDateTime = Date.parseDate(r.data["TStDate"] +" "+ r.data['TStTime'], "Y-m-d g:i");
						var StDateTimeDefault=dateFormat+" "+"g:i";
						var DateTimeDefault=dateFormat+" "+"g:i:s";
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
						operateObj.sendAjax(b, e, {act:'StopPrnOrder',ExpectEndDate: date, ExpectEndTime:time, PinNum:pinnum});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		var win = new Ext.Window({					
			title: '����(DC)ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg}		
			],
			buttons: [{
				text:'����(DC)',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg );
							return 
						}		
						operateObj.sendAjax(b, e, {act:'CancelPrnOrder',PinNum: pinnum});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		var win = new Ext.Window({					
			title: '����ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg }		
			],
			buttons: [{
				text:'����',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'UnUsePrnOrder',PinNum: pinnum});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	addExecOrderHandler = function (b,e){	
		var win = new Ext.Window({					
			title: '����ִ��ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'datefield', id: 'ExStDate', fieldLabel:'Ҫ��ִ������', width:160,allowBlank: false, value: new Date(),format:dateFormat},
				{xtype: 'timefield', id: 'ExStTime', fieldLabel:'Ҫ��ִ��ʱ��', width:160,allowBlank: false,format:orderGridPanel.timeFormat}		
			],
			buttons: [{
				text:'����',
				handler: function(t,e){
						var exDate = Ext.fly("ExStDate").dom.value;
						var exTime = Ext.fly("ExStTime").dom.value;
						if ((exDate == '')||(exTime == '')){
							Ext.Msg.alert("��ʾ","����д������ʱ��!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddExecOrder', exStDate: exDate, exStTime: exTime});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("ExStTime").focus(100);
	};
	addBillOrderHandler = function (b,e){
		var id = orderGridPanel.getSelectedRowIds();
		new Ext.Window({
			html:"<iframe src='dhcdoc.billorderrecord.csp?oeori="+id+"' scrolling='auto' style='width:1100px;height:400px;margin:0;padding:0'></iframe>",  
			renderTo:Ext.getBody(), 
			modal:true
		}).show();
		/* var rtn = window.open("dhcdoc.billorderrecord.csp?oeori="+id,{},"dialogHeight:600px;dialogWidth:1000px;resizable:yes");	*/
	};
	/**
	*{HIDDEN2_Disable:['D','E'],StopPermission_Disable:['0']}
	*/
	stopOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var StopPermission = record.data["StopPermission"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,���ܳ���!";
			return false ;
		}else if(orderStatus == "E"){
			this.qtitle = "˵��";
			this.qtip = "ҽ����ִ�й�,���ܳ���!";
			return false ;
		}else if(StopPermission == "0"){
			this.qtitle = "˵��";
			this.qtip = "Ȩ�޲��� �� ҽ���ѱ�ִ��!";
			return false ;
		}		
		return true;
	};
	/**
	*{HIDDEN2_Disable:['D','E'],CancelPermission_Disable:['0']}
	*/
	cancelOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
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
	abortOrderShowHandler = function(record,rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
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
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
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
	};
	addBillOrderShowHandler = function(record, rowIndex){
		this.qtip = "";
		if (["3","4","5"].indexOf(patData.patFlag)>-1){
			this.qtitle = "˵��";
			this.qtip = "������"+patData.flagDesc+"!";
			return false;
		}
		if(!record.data["HIDDEN1"]){
			this.qtitle = "˵��";
			this.qtip = "��ѡ��һ��ҽ��!";
			return false;
		}
		var orderStatus = record.data["HIDDEN2"];
		var oeoriOeoriDr = record.data["HIDDEN3"];
		if(orderStatus == "D") {
			this.qtitle = "˵��";
			this.qtip = "ҽ����ֹͣ,��������!";
			return false ;
		}else if( oeoriOeoriDr!=""){
			this.qtitle = "˵��";
			this.qtip = "������ҽ�������Ӽ�¼!";			
			return false ;				
		}
		return true;
	};
});