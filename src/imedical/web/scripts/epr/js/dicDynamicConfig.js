/**
Creator:	杜金蓉
Desc:		代码表与值域映射
*/
var actionBtn='';
var pagesize=12;
//表名store
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../CT.WS.web.DicDynamicTableList.cls',
	fields: ['ID', 'RowNum','TableName'],
	root: 'datatable',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: pagesize},
	listeners: {
		'beforeload': function() {
			var txttableName = Ext.getCmp("cbxTableName1").getRawValue();
			var txtconfigName = Ext.getCmp("cbxTableName2").getRawValue();
			getLocStore.baseParams = {tableName:txttableName,configName:txtconfigName,actionBtn:actionBtn};
		}
	}
});

//配置代码表名store
var getLocStore1 = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../CT.WS.web.DicDynamicTableList.cls',
	fields: ['ID', 'ConfigName'],
	root: 'dataname',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: pagesize},
	listeners: {
		'beforeload': function() {
			var txttableName = Ext.getCmp("cbxTableName1").getRawValue();
			
			if(actionBtn=="selectbox"){
				txtconfigName="";
			}else{
				var txtconfigName = Ext.getCmp("cbxTableName2").getRawValue();
			}
			document.getElementById('tableNameid').name=Ext.getCmp('cbxTableName1').getValue();
			getLocStore1.baseParams = {tableName: document.getElementById('tableNameid').name,configName:txtconfigName,actionBtn:actionBtn};
		}
	}
});
//配置代码表名store

var getLocStore2 = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../CT.WS.web.DicDynamicConfigList.cls',
	fields: ['name', 'name'],
	root: 'rows',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: pagesize},
		listeners: {
		'beforeload': function() {
			var txttableName = Ext.getCmp("cbxTableName1").getRawValue();
			if(actionBtn=="selectbox"){
				txtconfigName="";
			}else{
				var txtconfigName = Ext.getCmp("cbxTableName2").getRawValue();
			}
			document.getElementById('tableNameid').name=Ext.getCmp('cbxTableName1').getValue();
			getLocStore2.baseParams = {tableName:document.getElementById('tableNameid').name,configName:txtconfigName,actionBtn:actionBtn};
		}
	}
});
var dataCollectPort = new Ext.Viewport({
	id: 'dataCollectPort',
	 renderTo: Ext.getBody(),
	layout: 'border',
	items: [
		{
		id:'sts',
        region: 'north',
        title: '代码表配置',
        split: false,
        height: 55,
	    tbar: [
		'表名:',
		{
			id: 'cbxTableName1',
			name: 'cbxTableName1',
			xtype: 'combo',
			fieldLabel: '表名',
			minChars: 1,
			pageSize: pagesize,
			store:getLocStore,
			hiddenName: 'locID',
			displayField: 'TableName',
			valueField: 'TableName',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请选择表名',
			listWidth: 200,
			mode : 'remote',
			 editable : true,
			listeners:{
				'select':function(){
					selectTableName();
				},
				'expand':function(){
					Ext.getCmp('morenzhi').setRawValue(""); 
					Ext.getCmp('morenzhi').setValue("");
					getLocStore2.removeAll() ;
					Ext.getCmp('cbxTableName2').setRawValue(""); 
					Ext.getCmp('cbxTableName2').setValue("");
					getLocStore1.removeAll() ;
					Ext.getCmp('cbxTableName1').setRawValue(""); 
					Ext.getCmp('cbxTableName1').setValue("");
					getLocStore.removeAll() ;
					getLocStore.load();
				},'change':function(){
					getLocStore2.removeAll() ;
					getLocStore2.load();

					Ext.getCmp('morenzhi').setRawValue(getLocStore2.reader.jsonData.tableRow); 
					Ext.getCmp('morenzhi').setValue(getLocStore2.reader.jsonData.tableRow);

					getLocStore1.removeAll() ;
					getLocStore1.load();
				}
			}
 
		},
		'-',
		'配置代码表名:',
		{

			id: 'cbxTableName2',
			name: 'cbxTableName2',
			xtype: 'combo',
			fieldLabel: '配置表名',
			minChars: 1,
			pageSize: pagesize,
			store:getLocStore1,
			hiddenName: 'locID',
			displayField: 'ConfigName',
			valueField: 'ConfigName',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请选择配置代码表',
			listWidth: 200,
			editable : true,
			mode : 'remote',
			listeners:{
				
			}
 
			
		}, 
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false
		},{xtype : "tbfill"},'-',
		'默认值',
		{
			align:'right',
			id: 'morenzhi',
			xtype: 'combo',
			store:getLocStore2,
			hiddenName: 'locID',
			displayField: 'name',
			allowBlank : false,
			valueField: 'name',
			triggerAction: 'all',
			selectOnFocus: true,
			editable : true,
			emptyText: '请填写正确的默认值',
			listWidth: 200,
			mode : 'remote',
			pressed: false
		}
		]
		},

		{
        region: 'center',
		id:"iframehtml",
        xtype: 'panel', 
		title: '备选项',
        html : '<iframe id="dicdynamicdata" name="dicdynamicdata" style="width:100%; height:100%" src="CT.WS.dicdynamicdata.csp?patientID=' + patientID + '"></frame>'
        }]
});
//查询数据
var btnSearch= Ext.getCmp('btnSearch'); 
function clickBtnSearch(patientID,SearchValue,cbxTableName){
	document.getElementById('dicdynamicdata').src="CT.WS.dicdynamicdata.csp?patientID=" + patientID+"&tableName="+SearchValue+"&configName="+cbxTableName+"";
		getLocStore2.removeAll() ;
		getLocStore2.load();
		Ext.getCmp('morenzhi').setRawValue(getLocStore2.reader.jsonData.tableRow); 
		Ext.getCmp('morenzhi').setValue(getLocStore2.reader.jsonData.tableRow);

}
btnSearch.on('click',function(){
	btnSearch='btnSearch';
	actionBtn="btnSearch";

	var SearchValue=Ext.getCmp('cbxTableName1').getRawValue();
	var cbxTableName=Ext.getCmp('cbxTableName2').getRawValue();
	if(SearchValue==""||SearchValue==null){
		Ext.Msg.alert('操作提示', '请输入您要查询的[表名]');
		return;
	}else{
		clickBtnSearch(patientID,SearchValue,cbxTableName);

	}
});
//选择表名时事件
function selectTableName(){
	var SearchValue=Ext.getCmp('cbxTableName1').getRawValue();
	actionBtn="selectbox";
	document.getElementById('tableNameid').name=Ext.getCmp('cbxTableName1').getValue();
	Ext.getCmp('cbxTableName2').setRawValue(""); 
	Ext.getCmp('cbxTableName2').setValue("");
	getLocStore1.removeAll() ;
	getLocStore1.load();
	Ext.getCmp('morenzhi').setRawValue(""); 
	Ext.getCmp('morenzhi').setValue("");
	getLocStore2.removeAll() ;
	getLocStore2.load();
	if (getLocStore2.length>0)
	{
	Ext.getCmp('morenzhi').setRawValue(getLocStore2.reader.jsonData.tableRow); 
	Ext.getCmp('morenzhi').setValue(getLocStore2.reader.jsonData.tableRow);
	}

}

//保存事件
var btnSave= Ext.getCmp('btnSave'); 
btnSearch.on('click',function(){
	actionBtn="btnSearchConfig";
});
//获取选择的表名
function tablesNameValue(){
	var SearchValue=Ext.getCmp('cbxTableName1').getRawValue();
	return SearchValue;
}
//获取选择的配置代码表名
function configsNameValue(){
	var cbxTableName=Ext.getCmp('cbxTableName2').getRawValue();
	return cbxTableName;
}
var srcstore=document.getElementById('dicdynamicdata').src;
