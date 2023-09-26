// /����: �������
// /����: �������
// /��д�ߣ�zhangxiao
// /��д����: 2014.09.04

var StrParam="";
var gIncId="";
var gGroupId=session['LOGON.GROUPID'];

Ext.onReady(function() {
	Ext.QuickTips.init();// ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var GetPaymodeStore=new Ext.data.Store({
		url:"dhcstm.payaction.csp?actiontype=GetPayMode",
		reader:new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields:[{name:'RowId',mapping:'rowid'},{name:'Description',mapping:'payDesc'},'payCode']
		})
	});
	var PayMode = new Ext.ux.form.LovCombo({
		id : 'PayMode',
		fieldLabel : '֧����ʽ',
		anchor: '90%',
		separator:',',	//����id��^����
		store : GetPaymodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	var StDateField=new Ext.ux.DateField ({
				xtype: 'datefield',
				fieldLabel: '��ʼ����',
				name: 'startdt',
				id: 'startdt',
				anchor : '90%',
				value:new Date
			});
			
	var EndDateField=new Ext.ux.DateField ({
			fieldLabel: '��ֹ����',
			name: 'enddt',
			id: 'enddt',
			anchor : '90%',
			value:new Date
		});


	var FindTypeData=[['δ���','N'],['���','Y'],['ȫ��','']];
	var FindTypeStore = new Ext.data.SimpleStore({
		fields: ['Description', 'RowId'],
		data : FindTypeData
	});

	var FindTypeCombo = new Ext.form.ComboBox({
		store: FindTypeStore,
		valueField : 'RowId',
		displayField:'Description',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'FindTypeCombo',
		fieldLabel : '����״̬',
		triggerAction:'all'
	});
	Ext.getCmp("FindTypeCombo").setValue("");
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		params : {LocId : 'PhaLoc'}
	});
	//��������
	var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '�ɹ�����',
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor:'90%',
					width : 100,
					emptyText : '�ɹ�����...',
					groupId:gGroupId,
					childCombo : 'FindVendor'
				});

	var FindButton = new Ext.Button({
			height : 30,
			width : 70,
			id:"FindButton",
			text: 'ͳ��',
			iconCls : 'page_find',
			tooltip:'ͳ�Ƹ�������',
			icon:"../scripts/dhcpha/img/find.gif",
			listeners:{
				"click":function(){
					FindData();
				}
			}
		});
	
	var StatType = new Ext.form.RadioGroup({
		//fieldLabel : 'ͳ�Ʒ�ʽ',
		id : 'StatType',
		columns : 1,
		anchor : '90%',
		items : [
			{boxLabel : '��Ӧ�̻���', name : 'StatType', inputValue : 'VendorStat', checked : true},
			{boxLabel : '��Ӧ����ϸ����', name : 'StatType', inputValue : 'VendorItmStat'},
			{boxLabel : '�������', name : 'StatType', inputValue : 'PayNoStat'}
		]
	});
	
	var QueryForm = new Ext.ux.FormPanel({
		labelWidth : 80,
		region : 'west',
		title:'�������',
		frame : true,
		width:330,
		tbar:[FindButton],
		items : [{
				xtype : 'fieldset',
				title : '��ѯ����',
				items : [StDateField,EndDateField,PhaLoc,PayMode,FindVendor,FindTypeCombo]
			}, {
				xtype : 'fieldset',
				title : '��������',
				items : [StatType]
			}]
	});
	
	var QueryTabs = new Ext.TabPanel({
		region: 'center',
		id:'TblTabPanel',
		margins:'3 3 3 0',
		activeTab: 0,
		items:[{
			title: 'ͳ���б�',
			id:'list',
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
		}]
	});

	///��ܶ���
	var port = new Ext.ux.Viewport({
				layout : 'border',
				items : [QueryForm,QueryTabs]
			});
	//��ѯ����
	function FindData(){
		//GetStrParam();
		var sdate=Ext.getCmp("startdt").getValue();
		var edate=Ext.getCmp("enddt").getValue();
		if(sdate!=""){
			sdate = sdate.format(ARG_DATEFORMAT);
		}
		if(edate!=""){
			edate = edate.format(ARG_DATEFORMAT);
		}
		var phaLoc=Ext.getCmp("PhaLoc").getValue();
		var phadesc=Ext.getCmp("PhaLoc").getRawValue();
		if(phaLoc==""){
			Msg.info("warning","�ɹ����Ҳ���Ϊ��!");
			return;
		}
		var paymode=Ext.getCmp("PayMode").getValue();
		var vendor = Ext.getCmp('FindVendor').getValue();
		var findtype=Ext.getCmp("FindTypeCombo").getValue();
		var qPar="^"
		var p = Ext.getCmp("TblTabPanel").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		var StatType = Ext.getCmp("StatType").getValue().getGroupValue();
		var RaqName = '';
		if(StatType == 'VendorStat'){
			//��Ӧ�̻���
			RaqName = 'DHCSTM_PayStat.raq';
		}else if(StatType == 'VendorItmStat'){
			//��Ӧ����ϸ����
			RaqName = 'DHCSTM_PayStat2.raq';
		}else if(StatType == 'PayNoStat'){
			//�������
			RaqName = 'DHCSTM_PayStat_payno.raq';
		}
		iframe.src = PmRunQianUrl + '?reportName=' + RaqName
			+'&sdate='+ sdate + '&edate=' + edate + '&phaLoc=' + phaLoc +'&vendor=' + vendor +'&findtype=' + findtype
			+'&qPar=' + qPar + '&paymode=' + paymode + '&phadesc=' + phadesc;
	}
});