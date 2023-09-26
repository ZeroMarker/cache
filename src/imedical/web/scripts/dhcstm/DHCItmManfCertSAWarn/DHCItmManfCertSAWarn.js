// /����: ���ʱ���ͳ��
// /��д�ߣ��쳬
// /��д����: 2015.11.2
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>���ʽ�ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : new Date().add(Date.DAY,30)
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor'
	});
	// ȷ����ť
	var OkBT = new Ext.ux.Button({
				id : "OkBT",
				text : 'ͳ��',
				tooltip : '���ͳ��',
				iconCls : 'page_find',
				handler : function() {
					var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
					var RadioObj = Ext.getCmp(ReportType);
					addtab(RadioObj);
				}
			});
	
	var ClearBT = new Ext.ux.Button({
				id : "ClearBT",
				text : '���',
				tooltip : '������',
				iconCls : 'page_clearscreen',
				handler : function() {
					Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
						f.setValue("");
					});
					Ext.getCmp("DateTo").setValue(new Date().add(Date.DAY,30))
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	// 
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '���ʱ�����ϸ',
				id : 'FlagDetail',
				name : 'ReportType',
				checked : true,
				inputValue : 'FlagDetail'
			});
	//
	var FlagManf = new Ext.form.Radio({
				boxLabel : '��������',
				id : 'FlagManf',
				name : 'ReportType',
				inputValue : 'FlagManf'
			});
	var FlagVend = new Ext.form.Radio({
				boxLabel : '��Ӧ������',
				id : 'FlagVend',
				name : 'ReportType',
				inputValue : 'FlagVend'
			});	
	var FlagSDetail = new Ext.form.Radio({
				boxLabel : '��������',
				id : 'FlagSDetail',
				name : 'ReportType',
				inputValue : 'FlagSDetail'
			});
	//
	var FlagSManf = new Ext.form.Radio({
				boxLabel : '������������',
				id : 'FlagSManf',
				name : 'ReportType',
				inputValue : 'FlagSManf'
			});
	var FlagSVend = new Ext.form.Radio({
				boxLabel : '������Ӧ������',
				id : 'FlagSVend',
				name : 'ReportType',
				inputValue : 'FlagSVend'
			});		
	function ShowReport() {
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(EndDate==""){
			Msg.info("warning","��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();
		var manf=Ext.getCmp("PhManufacturer").getValue();
		var FlagDetail=Ext.getCmp("FlagDetail").getValue();
		var FlagManf=Ext.getCmp("FlagManf").getValue();
		var FlagVend=Ext.getCmp("FlagVend").getValue();
		var FlagSDetail=Ext.getCmp("FlagSDetail").getValue();
		var FlagSManf=Ext.getCmp("FlagSManf").getValue();
		var FlagSVend=Ext.getCmp("FlagSVend").getValue();
		var Vendor=Ext.getCmp("Vendor").getValue();
			var StrParam=EndDate+"^"+manf+"^"+Vendor
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
		//ȡ����ѯ����
		//���ҿ�����

		if(FlagDetail==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSADetail.raq&StrParam='+StrParam;
		}
		//���ҿ����ཻ�汨��(����)
		else if(FlagManf==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSAManf.raq&StrParam='+StrParam;
		}
		//���ҿ�����
		else if(FlagVend==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSAVend.raq&StrParam='+StrParam;		
		}
		else if(FlagSDetail==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSASDetail.raq&StrParam='+StrParam;		
		}
		else if(FlagSManf==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSASManf.raq&StrParam='+StrParam;		
		}
		else if(FlagSVend==true){
			cmpobj=Ext.getCmp("FlagSVend")
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_ItmManfCertSASVend.raq&StrParam='+StrParam;		
		}
		var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
			var reportFrame = document.getElementById("iframe_"+ReportType);
			reportFrame.src = p_URL;
	}

	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		frame : true,
		labelWidth : 80,
		labelAlign : 'right',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [DateTo,PhManufacturer,Vendor]
		}, {
			xtype : 'fieldset',
			title : '��������',
			labelWidth : 40,
			items : [FlagDetail,FlagManf,FlagVend,
					 FlagSDetail,FlagSManf,FlagSVend]
		}]
	});

	var addtab = function(cmpobj){
			var tabs=Ext.getCmp('main-tabs');
			var id=cmpobj.id;
			var title=cmpobj.boxLabel;
			var tabId = "tab_"+id;
			var iframeId = "iframe_"+id;
			var obj = Ext.getCmp(tabId);
			if (!obj){
				//�ж�tab�Ƿ��Ѵ�
				var obj=tabs.add({
					id:tabId,
					title:title,
					html:"<iframe id='"+iframeId+"' frameborder='0' scrolling='auto' height='100%' width='100%' src='../scripts/dhcstm/ExtUX/images/logon_bg.jpg'></iframe>",
					closable:true
				});
				obj.show();	//��ʾtabҳ
			}else{
				tabs.fireEvent('tabchange', tabs, obj);
			}
		}
		
		var tabs=new Ext.TabPanel({
			id:'main-tabs',
			activeTab:0,
			region:'center',
			enableTabScroll:true,
			resizeTabs: true,
			tabWidth:130,
			minTabWidth:120,
			resizeTabs:true,
			plugins: new Ext.ux.TabCloseMenu(), //�Ҽ��رղ˵�
			items:[{
				title:'����',	
					html:'<iframe id="reportFrame" height="100%" width="100%" scrolling="auto" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}],
			listeners : {
				tabchange : function(tabpanel, tab){
					var radioId = tab.id.split('_')[1];
					if(!Ext.isEmpty(radioId) && !Ext.isEmpty(radioId)){
						Ext.getCmp(radioId).setValue(true);
						ShowReport();
					}
				}
			}
		});
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:'���ʱ���ͳ��',
					width:300,
					minSize:250,
					maxSize:350,
					split:true,
					collapsible:true,
					layout:'fit',
					items:HisListTab
				},{
					region:'center',
					layout:'fit',
					items:tabs
				}]
			});
});