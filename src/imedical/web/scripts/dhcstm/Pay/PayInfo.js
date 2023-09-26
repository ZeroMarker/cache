
// /描述: 付款单会计确认信息
// /编写者：gwj
// /编写日期: 2012.09.24
function SetInfo(payInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ss=payInfo.split("^");
	var payNo=ss[0];
	var payVendorName=ss[1];
	var payAmt=ss[2];	
	
	var payNOField = new Ext.form.TextField({
		id:'payNOField',
		fieldLabel:'付款单号',
		allowBlank:true,
		width:120,
		//emptyText:'付款单号...',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
 
	var VendorField = new Ext.form.TextField({
		id:'VendorField',
		fieldLabel:'供应商',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	
	var payAmtField = new Ext.form.TextField({
		id:'payAmtField',
		fieldLabel:'付款金额',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	var CheckAmtField = new Ext.form.NumberField({
		id:'CheckAmtField',
		fieldLabel:'支付金额',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true
	});	
	
	var CheckNoField = new Ext.form.TextField({
		id:'CheckNoField',
		fieldLabel:'支付单号',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true
	});	
	
	var PayDate = new Ext.ux.DateField({
		fieldLabel : '日期',
		id : 'PayDate',
		name : 'PayDate',
		
		value : new Date()
	});
	
	var GetPaymodeStore=new Ext.data.Store({
		url:URL+"?actiontype=GetPayMode",
		reader:new Ext.data.JsonReader(
		{
			root: 'rows',
			totalProperty: 'results',
			fields:[{name:'RowId',mapping:'rowid'},{name:'Description',mapping:'payDesc'},'payCode','DefaultFlage']
		})	
	});
	
	// 入库科室
	var PayMode1 = new Ext.ux.ComboBox({
		fieldLabel : '支付方式',
		id : 'PayMode1',
		name : 'PayMode1',
		anchor : '100%',
		width : 120,
		store : GetPaymodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		emptyText : '支付方式...'
	});
	GetPaymodeStore.load({
		callback:function(r,options,success){
			if(success){
				for(var i=0;i<r.length;i++){
					if(r[i].get('DefaultFlage')=="Y"){
						PayMode1.setValue(r[i].get(PayMode1.valueField));
					}
				}
			}
		}
	});
	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
		text : '确定',
		tooltip : '点击确定',
		iconCls : 'page_goto',
		handler : function() {
			SelectData();
		}
	});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
		text : '取消',
		tooltip : '点击取消',
		iconCls : 'page_refresh',
		handler : function() {
			win.close();
		}
	});

	
	function SelectData(){

		var checkNo=Ext.getCmp('CheckNoField').getValue() ;   //支付单号码
		var checkAmt =Ext.getCmp('CheckAmtField').getValue() ;  //支付单金额
		var checkDate =Ext.getCmp('PayDate').getValue() ; //支付单日期
		var checkDate=checkDate.format(ARG_DATEFORMAT)
		var payMode =Ext.getCmp('PayMode1').getValue() ;    //支付方式	
		var payAmt=Ext.getCmp('payAmtField').getValue() ;   //付款金额
		if(checkAmt!=payAmt){
		  Msg.info("warning","支付金额不等于付款金额!");
		  return ;
		}
		var ret=tkMakeServerCall("web.DHCSTM.DHCPayQuery","Checkcheckno",checkNo);
		if(ret!=""){
		Msg.info("warning","该支付单号已经存在于其他付款单中!");
		return;
		}
		var paymodeInfo=payMode+"^"+checkDate+"^"+checkNo+"^"+checkAmt  ;

		ExecuteAck2(payRowId,paymodeInfo);
		win.close();
		
	}	
	
	var conPanel=new Ext.form.FormPanel({
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		defaults:{border:false},
		layout:'form',
		items:[{
			layout : 'column',
			frame:true,
			items : [{
				columnWidth : .25,
				labelWidth : 60,
				layout : 'form',
				items : [payNOField,PayDate]
			},{
				columnWidth : .5,
				labelWidth : 60,
				layout : 'form',
				items : [VendorField,{
					layout:'column',
					items:[{layout:'form',
						columnWidth:.5,
						items:[PayMode1]
					},{
						layout:'form',
						columnWidth:.5,
						items:[CheckNoField]
					}]
				}]
			},{
				columnWidth : .25,
				labelWidth : 60,
				layout : 'form',
				items : [payAmtField,CheckAmtField]
			}]
		}]
	});
	
	var win = new Ext.Window({
		title : '会计确认信息',
		width : 800,
		height : 150,
		modal :true,
		frame:true,
		defaults:{border:false},
		plain:true,
		resizable:false,
		buttons:[returnBT,cancelBT],
		layout:'form',	
		items : [conPanel],
		listeners:{
			'activate':function()
			{
				Ext.getCmp('payNOField').setValue(payNo);
				Ext.getCmp('VendorField').setValue(payVendorName);
				Ext.getCmp('payAmtField').setValue(payAmt);
			}
		
		}
	});
	win.show();	
}


