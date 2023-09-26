
// /����: ������ȷ����Ϣ
// /��д�ߣ�gwj
// /��д����: 2012.09.24
function SetInfo(payInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ss=payInfo.split("^");
	var payNo=ss[0];
	var payVendorName=ss[1];
	var payAmt=ss[2];	
	
	var payNOField = new Ext.form.TextField({
		id:'payNOField',
		fieldLabel:'�����',
		allowBlank:true,
		width:120,
		//emptyText:'�����...',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
 
	var VendorField = new Ext.form.TextField({
		id:'VendorField',
		fieldLabel:'��Ӧ��',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	
	var payAmtField = new Ext.form.TextField({
		id:'payAmtField',
		fieldLabel:'������',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		disabled:true,
		selectOnFocus:true
	});	
	
	var CheckAmtField = new Ext.ux.NumberField({
		id:'CheckAmtField',
		fieldLabel:'֧�����',
		allowBlank:false,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true,
		allowNegative: false,
		formatType: 'FmtRA'
	});	
	
	var CheckNoField = new Ext.form.TextField({
		id:'CheckNoField',
		fieldLabel:'֧������',
		allowBlank:true,
		width:120,
		emptyText:'',
		anchor:'100%',
		selectOnFocus:true
	});	
	
	var PayDate = new Ext.ux.DateField({
		fieldLabel : '����',
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
	
	// ������
	var PayMode = new Ext.ux.ComboBox({
		fieldLabel : '֧����ʽ',
		id : 'PayMode',
		name : 'PayMode',
		anchor : '100%',
		width : 120,
		store : GetPaymodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		emptyText : '֧����ʽ...'
	});
	// ȷ����ť
	var returnBT = new Ext.Toolbar.Button({
		text : 'ȷ��',
		tooltip : '���ȷ��',
		iconCls : 'page_goto',
		handler : function() {
			SelectData();
		}
	});

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
		text : 'ȡ��',
		tooltip : '���ȡ��',
		iconCls : 'page_delete',
		handler : function() {
			win.close();
		}
	});

	
	function SelectData(){
		var payMode =Ext.getCmp('PayMode').getValue() ;    //֧����ʽ
		if((payMode=="")||(payMode==null)){
			Msg.info("error", "֧����ʽ����Ϊ��!");
			return;
		}
		var checkAmt =Ext.getCmp('CheckAmtField').getRawValue() ;  //֧�����
		if((checkAmt=="")||(checkAmt==null)){
			Msg.info("error", "֧������Ϊ��,��Ϊ0!");
			return;
		}
		var payAmt=Ext.getCmp('payAmtField').getValue() ;  		//������
		if(parseFloat(checkAmt)!=parseFloat(payAmt)){
	        Ext.MessageBox.confirm('��ʾ', '֧�����͸�������,�Ƿ����ȷ��?',
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
		var checkNo=Ext.getCmp('CheckNoField').getValue() ;   //֧��������
		var checkDate =Ext.getCmp('PayDate').getRawValue() ; //֧��������	
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
		title : '���ȷ����Ϣ',
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


