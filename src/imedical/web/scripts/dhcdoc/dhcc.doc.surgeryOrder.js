Ext.ns("dhcc.doc");
var pswMsg = "密码"
var cancelOrderHandler,stopOrderHandler,patientInfoBar,abortOrderHandler;
Ext.onReady(function(){
	/*patientInfoBar =  new Ext.Panel({
		region: 'north',
		split: false,
		height: "30px",
		bodyCfg: {cls:'x-panel-header'},
		bodyStyle:{padding:0,paddingBottom:10},
		html: '<div style="height:27px;" ><table><TBODY><TR><TD noWrap><STRONG>选中的病人信息</STRONG> <LABEL id=BANNERRegistrationNo name="BANNERRegistrationNo"></LABEL></TD></TR></TBODY></table></div>'
	});*/
	/* new Ext.Panel({
		region:'north',
		title:'病人基本信息',
		frame:true,
		tbar: [				
	        '姓名:',{xtype: 'tbtext',id:'baseInfoName',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '床号:',{xtype: 'tbtext',id:'baseInfoBedno',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '年龄:',{xtype: 'tbtext',id:'baseInfoAge',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
			'性别:',{xtype: 'tbtext',id:'baseInfoSex',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},"-",
	        '体重:',{xtype: 'tbtext',id:'baseInfoBodyWeight',width:'50',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'住院号:',{xtype: 'tbtext',id:'baseInfoIPNo',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'保险类型:',{xtype: 'tbtext',id:'baseInfoInsu',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-',
			'入院日期:',{xtype: 'tbtext',id:'baseInfoIPDate',width:'100',text:'',cls:'x-panel-header',style:'font-weight:bold;font-size:16px;'},'-'
	    ]
	});*/
	dhcc.doc.orderGridPanel = new dhcc.doc.OrderCenter({
		region:'center',
		title:'医嘱列表',
		listClassName: 'web.DHCDocSosOrder',
		listQueryName: 'FindSosOrderFSNurse',
		columnModelFieldJson: orderMetaDataJson
	});
	var orderGridPanel = dhcc.doc.orderGridPanel;
	var orderTbar = orderGridPanel.getTopToolbar();
	/*,'医嘱单型:',{ 
			paramPosition: 6, 
			xtype:"combo", 
			typeAhead: true,
			fieldLabel: '医嘱单型',
			width: 75,
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
		},*/
	if(orderTbar){
		Ext.getCmp("orderDesc").setWidth(200);
		orderTbar.add('-','->',{
			text:'撤消',id:'stopOrdersBtn',act:'CancelPrnOrder',
				handler:function(b,e){
					cancelOrderHandler(b,e); //stopOrderHandler(b,e);		
				}
		},'-','->',{
			text:'作废',id:'abortOrdersBtn',act:'UnUsePrnOrder',
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
			Ext.Msg.alert("提示","没有选中医嘱!");
			return ;	
		}
		if(rowrecord && rowrecord.data["UnusePermission"]=="0"){
			Ext.Msg.alert("提示","没有权限作废该条医嘱!");
			return ;
		}
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
				{xtype:'field', id: 'winPinNum', fieldLabel:'医生签名', width:160,inputType:'password',allowBlank: false}	
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
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("OrdAbortReason").focus(100);
	}
	
	cancelOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("提示","没有选中医嘱!");
			return ;	
		}
		//2012-11-20 不能撤销其它科的医嘱
		if(rowrecord && rowrecord.data["CancelPermission"]=="0"){
			Ext.Msg.alert("提示","没有权限撤销该条医嘱!");
			return ;
		}		
		var win = new Ext.Window({					
			title: '撤消(DC)医嘱', layout: 'form',					
			width: 300, height: 200, modal: true,
			labelAlign:'right',
			items: [
				{xtype:'field', id: 'winPinNum', fieldLabel:'医生签名', width:160,inputType:'password',allowBlank: false}		
			],
			buttons: [{
				text:'撤消(DC)',handler: function(t,e){								
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示","签名为空,请签名!");
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
	stopOrderHandler = function(b, e){
		var rowrecord = orderGridPanel.getSelectedRow();		
		if(!rowrecord){
			Ext.Msg.alert("提示","没有选中医嘱!");
			return ;	
		}	
		var win = new Ext.Window({					
			title: '停医嘱', layout: 'form',					
			width: 350, height: 250, modal: true,
			labelAlign:'right',		
			items: [
				{xtype:'checkbox',id:'isExpStopOrderCB', fieldLabel:'是否预停',listeners:{check:function(t,checked){
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
				{xtype:'datefield', id: 'winStopOrderDate', fieldLabel:'停止日期',width: 160, 
				format: orderGridPanel.dateFormat,value: new Date(),disabled:true},
				{xtype:'field', id: 'winStopOrderTime', fieldLabel:'停止时间',width: 160, value: new Date().format('H:i')},
				{xtype:'field', id: 'winPinNum', fieldLabel:'签名', width:160, inputType:'password'}		
			],
			buttons: [{
				text:'停止',handler: function(t,e){
						var time = Ext.getCmp("winStopOrderTime").getValue();
						var dateCmp = Ext.getCmp("winStopOrderDate");
						var date = dateCmp.getRawValue();					
						var r = orderGridPanel.getSelectionModel().getSelected();
						//var stDateTime = Date.parseDate(r.data["TStDate"] +" "+ r.data['TStTime'], "Y-m-d g:i");
						var stDateTime = Date.parseDate(r.data["TStDateHide"] +" "+ r.data['TStTimeHide'], "Y-m-d g:i");
						var dateTime =  Date.parseDate(date+" "+time, "d/m/Y g:i");
						if(!dateTime){
							alert("日期或时间格式不对! 日/月/年  时:分,如28/05/2011,11:05");
							return ;
						}
						if( dateTime.getTime() < stDateTime.getTime() ){
							Ext.Msg.alert("提示","停止时间不能小于开始时间!");
							return 
						}						
						var pinnum = Ext.getCmp("winPinNum").getValue();
						if (pinnum == ''){
							Ext.Msg.alert("提示","签名为空,请签名!");
							return 
						}
						operateObj.sendAjax(b, e, {act:'StopPrnOrder',ExpectEndDate: date, ExpectEndTime:time, PinNum:pinnum});
						win.close();
					}
				},{ text:'返回',handler: function(t,e){ win.close();}
			}]				
		});
		win.show();
		Ext.fly("winPinNum").focus(100);
	};
});