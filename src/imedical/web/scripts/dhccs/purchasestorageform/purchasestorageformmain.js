var tmpText1='10-080001';
var tmpText2='';
var tmpText3='2010年1月23日';

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
        header: '药品编码',
        dataIndex: 'InvNo',
        width: 150,
        align: 'right',
        sortable: true
    },
    {
        header: "药品名称",
        dataIndex: 'ItmDesc',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "规格型号",
        dataIndex: 'Spec',
        width: 100,
        align: 'right',
        sortable: true
    },
	    {
        header: '计量单位',
        dataIndex: 'TrUom',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "供应商",
        dataIndex: 'Suppliers',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "数量",
        dataIndex: 'TrQty',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '单价',
        dataIndex: 'Rp',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "总价",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'right',
        sortable: true
    }
]);

var autohisoutmedvouchForm = new Ext.form.FormPanel({
		title:	'记账凭证',
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
								value: '<font size="6px"><center>采购入库单</center></font>'
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
								value: '单据编号：'+tmpText1
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '仓库：'+tmpText2
							},
							{
								columnWidth:.3,
								xtype:'displayfield',
								value: '制单时间：'+tmpText3
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
		bbar:['采购员：李风','-','科主任审批：王通','-','库管员:李华','-','记账员：于丽'],
		loadMask: true
	});
	
getDhcDataDetailST.load();