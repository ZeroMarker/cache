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
    header: "分摊日期",
    dataIndex: 'mDate',
    width: 90,
    renderer: formatDate,
    align: 'left',
    sortable: true
},
{
    header: "金额",
    dataIndex: 'fee',
    width: 40,
    align: 'left',
    sortable: true
},
{
    header: "标志",
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

var largCostDetailPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: largCostDetailDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据"
});
var largCostDetailGrid = new Ext.grid.GridPanel({//表格
    title: '大额成本分期',
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