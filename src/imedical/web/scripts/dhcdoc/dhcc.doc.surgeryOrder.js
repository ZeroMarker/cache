Ext.ns("dhcc.doc");
var pswMsg = "����"
var cancelOrderHandler,stopOrderHandler,patientInfoBar,abortOrderHandler;
Ext.onReady(function(){
	/*patientInfoBar =  new Ext.Panel({
		region: 'north',
		split: false,
		height: "30px",
		bodyCfg: {cls:'x-panel-header'},
		bodyStyle:{padding:0,paddingBottom:10},
		html: '<div style="height:27px;" ><table><TBODY><TR><TD noWrap><STRONG>ѡ�еĲ�����Ϣ</STRONG> <LABEL id=BANNERRegistrationNo name="BANNERRegistrationNo"></LABEL></TD></TR></TBODY></table></div>'
	});*/
	/* new Ext.Panel({
		region:'north',
		title:'���˻�����Ϣ',
		frame:true,
		tbar: [				
	        '����:',{xtype: 'tbtext',id:'baseInfoName',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoBedno',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoAge',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
			'�Ա�:',{xtype: 'tbtext',id:'baseInfoSex',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '����:',{xtype: 'tbtext',id:'baseInfoBodyWeight',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'סԺ��:',{xtype: 'tbtext',id:'baseInfoIPNo',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'��������:',{xtype: 'tbtext',id:'baseInfoInsu',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'��Ժ����:',{xtype: 'tbtext',id:'baseInfoIPDate',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-'
	    ]
	});*/
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		title:'ҽ���б�',
		listClassName: 'web.DHCDocSosOrder',
		listQueryName: 'FindSosOrderFSNurse',
		columnModelFieldJson: orderMetaDataJson
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	/*,'ҽ������:',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: 'ҽ������',
			width: 75,
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
		},*/
	if(orderTbar){
		Ext.getCmp("orderDesc").setWidth(200);
		orderTbar.add('-','->',{
			text:'����',id:'stopOrdersBtn',act:'CancelPrnOrder',
				handler:function(b,e){
					cancelOrderHandler(b,e); //stopOrderHandler(b,e);		
				}
		},'-','->',{
			text:'����',id:'abortOrdersBtn',act:'UnUsePrnOrder',
				handler:function(b,e){
					abortOrderHandler(b,e); //stopOrderHandler(b,e);		
				}
		});
		orderTbar.doLayout();
	}
	var operateObj = dhcc.doc.getOperateProxy( orderGridPanel );
    abortOrderHandler = function(b,e){
		var rowrecord = orderGridPanel.getSelectedRow();
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}
		if(rowrecord && rowrecord.data["UnusePermission"]=="0"){
			Ext.Msg.alert("��ʾ","û��Ȩ�����ϸ���ҽ��!");
			return ;
		}
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
				{xtype:'field', id: 'winPinNum', fieldLabel:'ҽ��ǩ��', width:160,inputType:'password',allowBlank: false}	
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
				},{ text:'����',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("OrdAbortReason").focus(100);
	}
	
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
			return ;	
		}
		//2012-11-20 ���ܳ��������Ƶ�ҽ��
		if(rowrecord && rowrecord.data["CancelPermission"]=="0"){
			Ext.Msg.alert("��ʾ","û��Ȩ�޳�������ҽ��!");
			return ;
		}		
		var win = new Ext.Window({					
			title: '����(DC)ҽ��', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'field', id: 'winPinNum', fieldLabel:'ҽ��ǩ��', width:160,inputType:'password',allowBlank: false}		
			],
			buttons: [{
				text:'����(DC)',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("��ʾ","ǩ��Ϊ��,��ǩ��!");
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
	stopOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("��ʾ","û��ѡ��ҽ��!");
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
				{xtype:'field', id: 'winPinNum', fieldLabel:'ǩ��', width:160, inputType:'password'}		
			],
			buttons: [{
				text:'ֹͣ',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectionModel().getSelected();
						//var stDateTime = Date.parseDate(r.data["TStDate"] +" "+ r.data['TStTime'], "Y-m-d g:i");
						var stDateTime = Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], "Y-m-d g:i");
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
							Ext.Msg.alert("��ʾ","ǩ��Ϊ��,��ǩ��!");
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
});