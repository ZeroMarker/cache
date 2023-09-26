var largCostDetailProxy;
function formatDate(value) {
    return value ? value.dateFormat('Y-m-d') : '';
};
var largCostDetailDs = new Ext.data.Store({
    proxy: largCostDetailProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
	'rowid',
	{ name: 'mDate', type: 'date', dateFormat: 'Y-m-d' },
	'fee',
	'flag'
	]),
    // turn on remote sorting
    remoteSort: true
});

largCostDetailDs.setDefaultSort('mDate', 'ASC');
var largCostDetailCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
    header: "��̯����",
    dataIndex: 'mDate',
    width: 90,
    renderer: formatDate,
    align: 'left',
    sortable: true
},
{
    header: "���",
    dataIndex: 'fee',
    width: 40,
    align: 'left',
    sortable: true
},
{
    header: "��־",
    dataIndex: 'flag',
    width: 40,
    align: 'left',
    sortable: true,
    renderer: function(v, p, record) {
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
}
]);

var largCostDetailPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: largCostDetailDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������"
});
var largCostDetailGrid = new Ext.grid.GridPanel({//���
    title: '���ɱ�����',
    region: 'center',
    xtype: 'grid',
    store: largCostDetailDs,
    cm: largCostDetailCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    viewConfig: { forceFit: true },
    bbar: largCostDetailPagingToolbar
});