// 调价window
function SetAdjPrice(data,i,j,AdjFn){
		var ss=data.split("^");
		var incicode=ss[9];
		var incidesc=ss[10];
		var PriorRp=ss[5];
		var PriorSp=ss[2];
		var ResultRp=ss[3];
		var ResultSp=ss[6];
		var AdjSpUomId=ss[1];
		var uomdesc=ss[11];
		var IncRowid=ss[0];
		var AdjSpUomId=ss[1];
		var StkGrpType=ss[7];
		var LocId=ss[8];
		var UserId=ss[4];

		function ReturnAdjData(){
			var newrp=Ext.getCmp("ResultRP").getValue();
			var newsp=Ext.getCmp("ResultSP").getValue();
			var HospId = session['LOGON.HOSPID'];
			var AspNo = '';
			var AspRowid = '', PreExecuteDate = new Date().add(Date.DAY, 1).format(ARG_DATEFORMAT),
				AdjSpReasonId = '', PriceFileNo = '', PriceFileDate = '', Remark = '', InvoNo = '',
				InvoDate = '';
			var ResultRp = Ext.getCmp('ResultRP').getValue() , ResultSp = Ext.getCmp('ResultSP').getValue();
			var ListDetail = AspRowid+"^"+ PreExecuteDate + "^" + IncRowid + "^" + AdjSpUomId + "^" + ResultSp
					+ "^" + ResultRp + "^" + UserId+ "^" + AdjSpReasonId+ "^" + HospId+ "^" + PriceFileNo
					+ "^" + PriceFileDate +"^" + Remark+ "^"+InvoNo+"^"+InvoDate+"^"+PriorRp
					+ "^" + PriorSp;
			
			var result = tkMakeServerCall('web.DHCSTM.INAdjSalePrice','Save',AspNo,StkGrpType,LocId,ListDetail);
			if (result.split('^').length <= 1){
				var InciRecord = DetailStore.getAt(i);
				InciRecord.set('Rp', ResultRp);
				InciRecord.set('Sp', ResultSp);
				InciRecord.set('NewSp', ResultSp);
			}else{
				Msg.info('error', '调价失败!');
			}
			AdjWin.close();
			AdjFn(++i,j);
		}

		var InciCode = new Ext.form.TextField({
			fieldLabel : '代码',
			id : 'InciCode',
			anchor : '90%',
			disabled : true
		});
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '名称',
			id : 'InciDesc',
			anchor : '90%',
			disabled : true
		});
		
		var ADJUom = new Ext.form.ComboBox({
			fieldLabel : '调价单位',
			id : 'ADJUom',
			name : 'ADJUom',
			anchor : '90%',
			//width : 120,
			store : ItmUomStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : false,
			triggerAction : 'all',
			emptyText : '单位...',
			selectOnFocus : true,
			forceSelection : true,
			valueNotFoundText : '',
			disabled : true
		});
		var PriorRP = new Ext.form.TextField({
					fieldLabel : '调前进价',
					id : 'PriorRP',
					anchor : '90%',
					disabled : true
				});
		var PriorSP = new Ext.form.TextField({
					fieldLabel : '调前售价',
					id : 'PriorSP',
					anchor : '90%',
					disabled : true
				});
		var ResultSP = new Ext.form.TextField({
					fieldLabel : '调后售价',
					id : 'ResultSP',
					anchor : '90%'
					//disabled : true
				});
		var ResultRP = new Ext.form.TextField({
					fieldLabel : '调后进价',
					id : 'ResultRP',
					anchor : '90%'
					//disabled : true
				});
		// 确定按钮
		var ConfirmBT = new Ext.Toolbar.Button({
					id : "ConfirmBT",
					text : '确定',
					tooltip : '确定',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						ReturnAdjData();
					}
				});
		// 关闭按钮
		var CloseBT = new Ext.Toolbar.Button({
					id : "CloseBT",
					text : '关闭',
					tooltip : '关闭',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						AdjWin.close();
					}
				});

		var AdjWin = new Ext.Window({
			title : '调价信息',
			width : 800,
			height : 300,
			closable:false,
			labelWidth:100,
			plain:true,
			modal:true,
			items:[{
				xtype:'fieldset',
				title:'调前信息',
				layout: 'column',
				defaults: {border:false},
				items : [{
					columnWidth: 0.3,
					xtype: 'fieldset',
					items: [InciCode,PriorSP]
				},{
					columnWidth: 0.3,
					xtype: 'fieldset',
					items: [InciDesc,PriorRP]
				}]
			},{
				xtype:'fieldset',
				title:'调价信息',
				layout: 'column',
				defaults: {border:false},
				items : [{
					columnWidth: 0.3,
					xtype: 'fieldset',
					items: ResultSP
				},{
					columnWidth: 0.3,
					xtype: 'fieldset',
					items: ResultRP
				},{
					columnWidth: 0.3,
					xtype: 'fieldset',
					items: ADJUom
				}]
			}],
			buttons:[ConfirmBT],
			listeners : {
				show : function(){
					Ext.getCmp("InciCode").setValue(incicode);
					Ext.getCmp("InciDesc").setValue(incidesc);
					Ext.getCmp("PriorRP").setValue(PriorRp);
					Ext.getCmp("PriorSP").setValue(PriorSp);
					Ext.getCmp("ResultRP").setValue(ResultRp);
					Ext.getCmp("ResultSP").setValue(ResultSp);
					var store=Ext.getCmp('ADJUom').getStore();
					addComboData(store,AdjSpUomId,uomdesc);
					Ext.getCmp("ADJUom").setValue(AdjSpUomId);
				}
			}
		});
		
		AdjWin.show();
}