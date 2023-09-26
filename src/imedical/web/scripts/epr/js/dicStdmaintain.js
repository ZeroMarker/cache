/**
Creator:	杜金蓉
Desc:		代码表与值域映射
*/
var pagesize=12;
var getconfigtableStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../CT.WS.web.DicStdmaintainList.cls',
	fields: ['ID',"ConfigName"],
	root: 'ConfigList',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: pagesize}
	
});

getconfigtableStore.load();

var dataCollectPort = new Ext.Viewport({
	id: 'dataCollectPort',
	layout: 'border',
	items: [
		{
        region: 'center',
        title: '公共字典数据维护',
        collapsible: true,
        split: true,
        height: 55,
		html : '<div style="height:100%;width:100%;color:Gray"><iframe id="dicStdmaintain" name="dicStdmaintain" style="width:100%; height:100%" src="CT.WS.dicStdmaintainData.csp"></frame></div>',
	    tbar: [
		'配置代码表名:',
		{
			id: 'cbxTableName',
			name: 'cbxTableName',
			xtype: 'combo',
			fieldLabel: '科室',
			minChars: 1,
			pageSize: pagesize,
			store:getconfigtableStore,
			hiddenName: 'locID',
			displayField: 'ConfigName',
			valueField: 'ID',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请选择配置代码表',
			listWidth: 200,
			mode : 'remote'
		},
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false
		}]

		}]
});

//查询数据
var btnSearch= Ext.getCmp('btnSearch'); 
btnSearch.on('click',function(){
	btnSearch='btnSearch';
	actionBtn="btnSearch";

	var SearchValue=Ext.getCmp('cbxTableName').getRawValue();
	var strRowID=Ext.getCmp('cbxTableName').getValue();
	if(SearchValue==""||SearchValue==null){
		return;
	}else{
	document.getElementById('dicStdmaintain').src="CT.WS.dicStdmaintainData.csp?patientID=" + patientID+"&RowID="+strRowID+"&configName="+SearchValue+"";
	}
});

