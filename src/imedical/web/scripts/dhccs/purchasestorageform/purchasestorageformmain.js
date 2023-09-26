var tmpText1='10-080001';
var tmpText2='';
var tmpText3='2010��1��23��';

var getDhcDataDetailST = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=GetDhcDataDetailJson'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
				'InvNo',
				'InvDate',
				'ItmDesc',
				'Spec',
				'TrUom',
				'TrQty',
				'Rp',
				'RpAmt',
				'Sp',
				'SpAmt'
			]),
		remoteSort: true
	});
	
var autoHisOutMedCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: 'ҩƷ����',
        dataIndex: 'InvNo',
        width: 150,
        align: 'right',
        sortable: true
    },
    {
        header: "ҩƷ����",
        dataIndex: 'ItmDesc',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "����ͺ�",
        dataIndex: 'Spec',
        width: 100,
        align: 'right',
        sortable: true
    },
	    {
        header: '������λ',
        dataIndex: 'TrUom',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "��Ӧ��",
        dataIndex: 'Suppliers',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "����",
        dataIndex: 'TrQty',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'Rp',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "�ܼ�",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'right',
        sortable: true
    }
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:	'����ƾ֤',
		region:	'north',
		frame:	true,
		height:	100,
		items:	[	
					{
						xtype: 'panel',
						layout:"column",
						hideLabel:true,
						isFormField:true,
						items: [
							{
								columnWidth:.9,
								xtype: 'displayfield', 
								value: '<font size="6px"><center>�ɹ���ⵥ</center></font>'
							}
						]
					},
					{
						xtype: 'panel',
						layout:"column",
						hideLabel:true,
						isFormField:true,
						items: [
							{
								columnWidth:.1,
								xtype:'displayfield'
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '���ݱ�ţ�'+tmpText1
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '�ֿ⣺'+tmpText2
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '�Ƶ�ʱ�䣺'+tmpText3
							}
						]
					}
				]
	});

var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
		store: getDhcDataDetailST , ////////////////temp
		cm: autoHisOutMedCm,
		region:'center',
		clicksToEdit:'auto',
		trackMouseOver: true,
		stripeRows: true,
		bbar:['�ɹ�Ա�����','-','��������������ͨ','-','���Ա:�','-','����Ա������'],
		loadMask: true
	});
	
getDhcDataDetailST.load();