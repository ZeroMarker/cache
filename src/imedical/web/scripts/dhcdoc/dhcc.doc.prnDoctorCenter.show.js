Ext.ns("dhcc.doc");
var stopOrderHandler,cancelOrderHandler,abortOrderHandler,addExecOrderHandler,copyOrderHandler,copyPrnOrderHandler,copySosOrderHandler,PrintOutLook;
var pswMsg = "����"
var pswNullMsg = "����Ϊ��,����д����!"
Ext.onReady(function(){
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		listClassName: 'web.DHCDocPrnOrder',
		listQueryName: 'FindPrnOrder',
		columnModelFieldJson: orderMetaDataJson,	
		internalType: 'DOCTOR',		
		orderType: "PRN"
		/*
		plugins:[new Ext.ux.plugins.GroupHeaderGrid({
				rows: [[
					{header: '��ʼ', colspan: 10, align: 'center'},
					{header: 'ֹͣ', colspan: 4, align: 'center'},{},{},{}					
				]],
				hierarchicalColMenu: true
		})]
		*/
		
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	if(orderTbar){		
		orderTbar.add('-','ҽ������:',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: 'ҽ������',
			width: 75,
			name: "nursebillDesc",
			id: "nursebillDesc",
			triggerAction: 'all',
			editable : false,
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
		},'-',{
			text: '��ӡԤ��',			
			handler: function(b, e){
				PrintOutLook();
			}
		},'-',{
			text: '����ҽ��',			
			handler: function(b, e){
				copySosOrderHandler();
			}
		},'-',{
			text: 'ɾ��',
			handler: function(b, e){
				//����
				abortOrderHandler(b,e);
			}
		},'-',{
			text:'ֹͣ',id:'stopOrdersBtn',act:'StopPrnOrder',
				handler:function(b,e){
					stopOrderHandler(b,e);		
				}
		},'-');
		orderTbar.doLayout();
	}
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );	
	stopOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}	
		//TPermission
		if(rowrecord && rowrecord.data["HIDDEN5"].split("^")[0]=="N"){
			Ext.Msg.alert("��ʾ","û��Ȩ��ֹͣ����ҽ��!");
			return ;
		}
		var win = new Ext.Window({					
			title: 'ͣҽ��', layout: 'form',					
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
				format: orderGridPanel.dateFormat,value: new Date(),disabled:true},
				{xtype:'field', id: 'winStopOrderTime', fieldLabel:'ֹͣʱ��',width: 160, value: new Date().format('H:i')},
				{xtype:'field', id: 'winPinNum', fieldLabel:pswMsg, width:160, inputType:'password'}		
			],
			buttons: [{
				text:'ֹͣ',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectedRow(); //.getSelectionModel().getSelected();
						var stDateTime = Date.parseDate(r.data["TStDate"] +" "+ r.data['TStTime'], "Y-m-d g:i");
						var dateTime =  Date.parseDate(date+" "+time, "d/m/Y g:i");
						if(!dateTime){
							alert("���ڻ�ʱ���ʽ����! ��/��/��  ʱ:��,��28/05/2011,11:05");
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
		//TPermission
		if(rowrecord.data["HIDDEN5"].split("^")[1]=="N"){
			Ext.Msg.alert("��ʾ","û��Ȩ�޳�������ҽ��!");
			return ;
		}
		var win = new Ext.Window({					
			title: '����(DC)ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'field', id: 'winPinNum', fieldLabel:pswMsg, width:160,inputType:'password',allowBlank: false}		
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
					}
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
	abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}			
		//TPermission
		if(rowrecord.data["HIDDEN5"].split("^")[2]=="N"){
			Ext.Msg.alert("��ʾ","û��Ȩ�����ϸ���ҽ��!");
			return ;
		}
		var win = new Ext.Window({					
			title: 'ɾ��ҽ��(����)', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'field', id: 'winPinNum', fieldLabel:pswMsg, width:160,inputType:'password',allowBlank: false}		
			],
			buttons: [{
				text:'ɾ��(����)',handler: function(t,e){								
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
	}
	addExecOrderHandler = function (b,e){	
		var win = new Ext.Window({					
			title: '����ִ��ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign: 'right',
			items: [
				{xtype: 'datefield', id: 'ExStDate', fieldLabel:'Ҫ��ִ������', width:160,allowBlank: false, value: new Date(),format:'m/d/Y'},
				{xtype: 'field', id: 'ExStTime', fieldLabel:'Ҫ��ִ��ʱ��', width:160,allowBlank: false}		
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
		var oeoris = orderGridPanel.getSelectedRowIds();
		if(oeoris!=""){
		var mainFrame = window.parent;	
		mainFrame.GetCopyItems(oeoris);
			/*
			var frm = dhcsys_getmenuform();
			var papmi = frm.PatientID.value;
			var adm = frm.EpisodeID.value;
			var mradm = frm.mradm.value;
			var mainFrame = window.parent;			
			var i = mainFrame.orderTabIndex;	//DHCOEҳǩ��λ��
			if(!(i>0)){
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
			*/
		}
	};
	copyPrnOrderHandler = function(){		
		copyOrderHandler({priorCode:"S"});
	};
	copySosOrderHandler = function(){		
		copyOrderHandler({priorCode:"NORM"});
	};
	PrintOutLook = function(){
		var frm = dhcsys_getmenuform();			
		if(frm.EpisodeID.value>0){
			ShowDoctorOrderSheet(frm.EpisodeID.value);
		}
	};
});