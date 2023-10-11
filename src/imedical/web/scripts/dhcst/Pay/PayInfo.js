
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
		fieldLabel:$g('付款单号'),
		allowBlank:true,
		width:120,
		//emptyText:'付款单号...',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
 
	var VendorField = new Ext.form.TextField({
		id:'VendorField',
		fieldLabel:$g('经营企业'),
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	
	var payAmtField = new Ext.form.TextField({
		id:'payAmtField',
		fieldLabel:$g('付款金额'),
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	var CheckAmtField = new Ext.ux.NumberField({
		id:'CheckAmtField',
		fieldLabel:$g('支付金额'),
		allowBlank:false,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true,
		allowNegative: true,
		formatType: 'FmtRA'
	});	
	
	var CheckNoField = new Ext.form.TextField({
		id:'CheckNoField',
		fieldLabel:$g('支付单号'),
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true
	});	
	
	var PayDate = new Ext.ux.DateField({
		fieldLabel : $g('日期'),
		id : 'PayDate',
		name : 'PayDate',
		anchor : '100%',
		width : 120,
		value : new Date()
	});
	
	var GetPaymodeStore=new Ext.data.Store({
		url:URL+"?actiontype=GetPayMode",
		reader:new Ext.data.JsonReader(
		{
			root: 'rows',
			totalProperty: 'results',
			fields:[{name:'RowId',mapping:'rowid'},{name:'Description',mapping:'payDesc'},'payCode']
		})	
	});
	
	// 入库科室
	var PayMode = new Ext.ux.ComboBox({
		fieldLabel : $g('支付方式'),
		id : 'PayMode',
		name : 'PayMode',
		anchor : '100%',
		width : 120,
		store : GetPaymodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		emptyText : $g('支付方式...')
	});
	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
		text :$g( '确定'),
		tooltip : $g('点击确定'),
		iconCls : 'page_goto',
		handler : function() {
			SelectData();
		}
	});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
		text : $g('取消'),
		tooltip : $g('点击取消'),
		iconCls : 'page_delete',
		handler : function() {
			win.close();
		}
	});

	
	function SelectData(){
		var payMode =Ext.getCmp('PayMode').getValue() ;    //支付方式
		if((payMode=="")||(payMode==null)){
			Msg.info("error",$g( "支付方式不能为空!"));
			return;
		}
		var checkAmt =Ext.getCmp('CheckAmtField').getRawValue() ;  //支付金额
		if((checkAmt=="")||(checkAmt==null)){
			Msg.info("error", $g("支付金额不能为空,可为0!"));
			return;
		}
		var payAmt=Ext.getCmp('payAmtField').getValue() ;  		//付款金额
		if(parseFloat(checkAmt)!=parseFloat(payAmt)){
	        Ext.MessageBox.confirm($g('提示'), $g('支付金额和付款金额不相等,是否继续确认?'),
	        function(btn) {
	            if (btn == 'no') {
		            Ext.getCmp('CheckAmtField').focus(false, 100);
	                return;
	            } else {
					ExecuteData(payMode,checkAmt);
	            }
	        })
		}else{
			ExecuteData(payMode,checkAmt);
		}	
	}
	
	function ExecuteData(payMode,checkAmt){
		var checkNo=Ext.getCmp('CheckNoField').getValue() ;   //支付单号码
		var checkDate =Ext.getCmp('PayDate').getRawValue() ; //支付单日期	
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
						items:[PayMode]
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
		title : $g('会计确认信息'),
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


