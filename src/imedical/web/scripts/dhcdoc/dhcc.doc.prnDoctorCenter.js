Ext.ns("dhcc.doc");
var stopOrderHandler,cancelOrderHandler,abortOrderHandler,addExecOrderHandler,copyOrderHandler,copyPrnOrderHandler,copySosOrderHandler;
var stopOrderShowHandler,cancelOrderShowHandler,abortOrderShowHandler,addExecOrderShowHandler;
var addOrderNotesHandler;
var OrderNotesNullMsg = "��עΪ��,����д��ע!";
var pswMsg = "����"
var pswNullMsg = "����Ϊ��,����д����!"
dhcc.icare.passwordKey = Ext.extend(Ext.form.Field, {
	width:160,inputType:'password',allowBlank: false,
	listeners:{"specialkey":function(textfield,fieldE){ var key=fieldE.getKey(); if(key==13){ textfield.findParentByType("window").buttons[0].handler.call();}}}
});
Ext.reg('passwordkey', dhcc.icare.passwordKey);
Ext.onReady(function(){
	Ext.QuickTips.init();	
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		listClassName: 'web.DHCDocPrnOrder',
		listQueryName: 'FindPrnOrder',
		columnModelFieldJson: orderMetaDataJson,	
		internalType: 'DOCTOR',		
		orderType: "PRN",
		plugins:[new Ext.ux.plugins.GroupHeaderGrid({
				rows: [[
					{header: '��ʼ', colspan: 10, align: 'center'},
					{header: 'ֹͣ', colspan: 4, align: 'center'},
					{header: '����',colspan: 6, align: 'center'}					
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
			value: "N",
			store: new Ext.data.ArrayStore({
				fields: ['nursebillId','nursebillDesc'],
				data:[["ALL","ȫ��"],["N","ҽ����"]]
			}),
			displayField: 'nursebillDesc',
			valueField: 'nursebillId',
			allowBlank:  false			
		},'-');
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
		orderTbar.add({
			text:"����",
			menu:operateMenu
		});
		orderTbar.doLayout();
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
	    var dateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
	    if (dateFormat=="3"){
		    dateFormat="Y-m-d"
		}else if(dateFormat=="4"){
			dateFormat="d/m/Y"
		}else{
			dateFormat=orderGridPanel.dateFormat;
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
				{xtype:'datefield', id: 'winStopOrderDate', fieldLabel:'ֹͣ����',width: 160, 
				format: dateFormat,value: new Date(),disabled:true},
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
				text:'ֹͣ',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();						
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();	
						var r = orderGridPanel.getSelectedRow(); //.getSelectionModel().getSelected();
						var oeoris = orderGridPanel.getAllPageSelectedRowIds();
						if(oeoris==""){
							oeoris=r.data["HIDDEN1"]
						}
						var StDateTimeDefault=dateFormat+" "+"g:i";
						var DateTimeDefault=dateFormat+" "+"g:i:s";
						//var stDateTime = Date.parseDate(r.data["TStDate"] +" "+ r.data['TStTime'], "Y-m-d g:i");
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
						//ˢ�»����б�
						var flag = tkMakeServerCall("appcom.OEOrdItem", "RefresPatList",oeoris)
						if ((window.parent.patientTreePanel)&&(flag=="Y")){
							window.parent.patientTreePanel.store.load();
						}
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"]
		}
		var win = new Ext.Window({					
			title: '����(DC)ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'passwordkey', id: 'winPinNum', fieldLabel:pswMsg }		
			],
			buttons: [{
				text:'����(DC)',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ",pswNullMsg);
							return 
						}		
						operateObj.sendAjax(b, e, {act:'CancelPrnOrder',PinNum: pinnum});
						win.close();
						//ˢ�»����б�
						var flag = tkMakeServerCall("appcom.OEOrdItem", "RefresPatList",oeoris)
						if ((window.parent.patientTreePanel)&&(flag=="Y")){
							window.parent.patientTreePanel.store.load();
						}
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();
		var oeoris = orderGridPanel.getAllPageSelectedRowIds();
		if(oeoris==""){
			oeoris=rowrecord.data["HIDDEN1"]
		}
		
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
						//ˢ�»����б�
						var flag = tkMakeServerCall("appcom.OEOrdItem", "RefresPatList",oeoris)
						if ((window.parent.patientTreePanel)&&(flag=="Y")){
							window.parent.patientTreePanel.store.load();
						}
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	}
	addExecOrderHandler = function (b,e){	
		var win = new Ext.Window({					
			title: '����ִ��ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'datefield', id: 'ExStDate', fieldLabel:'Ҫ��ִ������', width:160,allowBlank: false, value: new Date(),format:'m/d/Y'},
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
						operateObj.sendAjax(b, e, {act:'AddExecOrder',exStDate: exDate, exStTime: exTime},function(){
							var index = orderGridPanel.store.indexOf(orderGridPanel.getSelectionModel().getSelected());
							orderGridPanel.fireEvent("rowdblclick", orderGridPanel, index, null);
						});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
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
				text:'ȷ��',handler: function(t,e){								
						var OrderNotes = Ext.getCmp("OrderNotes").getValue();
						if (OrderNotes == ''){
							Ext.Msg.alert("��ʾ",OrderNotesNullMsg);
							return 
						}
						operateObj.sendAjax(b, e, {act:'AddOrderNotes',OrderNotes: OrderNotes});
						win.close();
					}
				},{ text:'����',handler: function(t,e){ win.close();}
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
});