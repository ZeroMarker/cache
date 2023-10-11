var data=window.dialogArguments;

//window.returnValue=priorrp+"^"+priorsp;

function SetAdjPrice(data,Fn1,Fn2,i,j){
        var ss=data.split("^");
        var incicode=ss[9];
        var incidesc=ss[10];
        var priorrp=ss[5];
        var priorsp=ss[2];
        var resultrp=ss[3];
        var resultsp=ss[6];
        var uomid=ss[1];
        var uomdesc=ss[11];
       var IncRowid=ss[0];
       var StkGrpType=ss[7];
       var gLocId=ss[8];
       var gUserId=ss[4];
	   
		function ReturnData(){
			var newrp=Ext.getCmp("ResultRP").getValue();
			var newsp=Ext.getCmp("ResultSP").getValue();
		    var pricestr=newrp+"^"+newsp
		    if(i==j){
		       Fn1(pricestr);
		       window.close();
		    }else{
			    window.close();
			    Fn2(++i,j,pricestr)
			    }
		    
		    }

		var InciCode = new Ext.form.TextField({
					fieldLabel : $g('代码'),
					id : 'InciCode',
					name : 'InciCode',
					anchor : '90%',
					disabled : true
				});
		var InciDesc = new Ext.form.TextField({
					fieldLabel : $g('名称'),
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					disabled : true
				});
		// 单位
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : $g('基本单位'),
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 120,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : $g('单位...'),
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
				});
		var ADJUom = new Ext.form.ComboBox({
					fieldLabel : $g('调价单位'),
					id : 'ADJUom',
					name : 'ADJUom',
					anchor : '90%',
					//width : 120,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : $g('单位...'),
					selectOnFocus : true,
					forceSelection : true,
					//minChars : 1,
					//pageSize : 10,
					//listWidth : 250,
					valueNotFoundText : '',
					disabled : true
				});
		var PriorRP = new Ext.form.TextField({
					fieldLabel : $g('调前进价'),
					id : 'PriorRP',
					name : 'PriorRP',
					anchor : '90%',
					disabled : true
				});
		var PriorSP = new Ext.form.TextField({
					fieldLabel : $g('调前售价'),
					id : 'PriorSP',
					name : 'PriorSP',
					anchor : '90%',
					disabled : true
				});
		var ResultSP = new Ext.form.TextField({
					fieldLabel : $g('调后售价'),
					id : 'ResultSP',
					name : 'ResultSP',
					anchor : '90%',
					disabled : true
				});
		var ResultRP = new Ext.form.TextField({
					fieldLabel : $g('调后进价'),
					id : 'ResultRP',
					name : 'ResultRP',
					anchor : '90%',
					disabled : true
				});
		// 确定按钮
		var ConfirmBT = new Ext.Toolbar.Button({
					id : "ConfirmBT",
					text : $g('确定'),
					tooltip : $g('确定'),
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						//Save();
						ReturnData();
						//window.returnValue=resultrp+"^"+resultsp;
						//window.close();
					}
				});
		// 关闭按钮
		var CloseBT = new Ext.Toolbar.Button({
					id : "CloseBT",
					text : $g('关闭'),
					tooltip : $g('关闭'),
					width : 70,
					height : 30,
					iconCls : 'page_close',
					handler : function() {

						window.close();
					}
				});
		
		Ext.getCmp("InciCode").setValue(incicode);
		Ext.getCmp("InciDesc").setValue(incidesc);
		Ext.getCmp("PriorRP").setValue(priorrp);
		Ext.getCmp("PriorSP").setValue(priorsp);
		Ext.getCmp("ResultRP").setValue(resultrp);
		Ext.getCmp("ResultSP").setValue(resultsp);
		var store=Ext.getCmp('ADJUom').getStore();
		addComboData(store,uomid,uomdesc);
		Ext.getCmp("ADJUom").setValue(uomid);
		

	    var window = new Ext.Window({
				title : $g('调价信息'),
				width : 800,
				height : 300,
				closable:true,
				labelWidth:80,
			    plain:true,
			    modal:true,
				items:[{
				xtype:'fieldset',
				title:$g('调前信息'),
				//style:'padding:1px 0px 0px 10px',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false}, 
				items : [{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	//defaults: {width: 250},    // Default config options for child items
	            	items: [InciCode,PriorSP]
					
				},{
				    columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	//defaults: {width: 250},    // Default config options for child items
	            	items: [InciDesc,PriorRP]
				}]
			},{
			    xtype:'fieldset',
				title:$g('调后信息'),
				//style:'padding:1px 0px 0px 10px',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false}, 
				items : [{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	//defaults: {width: 250},    // Default config options for child items
	            	items: ResultSP
					
				},{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	//defaults: {width: 250},    // Default config options for child items
	            	items: ResultRP
					
				},{ 				
					columnWidth: 0.3,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	//defaults: {width: 250},    // Default config options for child items
	            	items: ADJUom
					
				}]
			}],
			buttons:[ConfirmBT]
	    })
	    window.show();
	    
					
}