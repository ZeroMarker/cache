/**
  *name:tab of hospreport
  *author:limingzhong
  *Date:2010-9-17
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
 
//配件数据源
var DimensTypeTabUrl = '../csp/dhc.pa.dimenstypeexe.csp';
var DimensTypeTabProxy= new Ext.data.HttpProxy({url:DimensTypeTabUrl + '?action=list'});
var DimensTypeTabDs = new Ext.data.Store({
	proxy: DimensTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'shortcut',
		'order',
		'appSysDr',
		'appSysName',
		'desc',
		'isInner',
		'active'
	]),
    // turn on remote sorting
    remoteSort: true
});

//数据库数据模型
var DimensTypeTabCm = new Ext.grid.ColumnModel([
]);

//柱图按钮
var addDimensType = new Ext.Toolbar.Button({
	text: '柱图按钮',
    tooltip:'柱图按钮',        
    iconCls:'add',
	handler:function(){
		var url="http://127.0.0.1:6001/demo/reportJsp/showReport.jsp?raq=/testg.raq";
		var frequency="M";
		var schemDr="1||2";
		var str=url+"&cycleDr="+1+"&frequency="+frequency+"&period="+1+"&schemDr="+schemDr;
		window.open(str,"newwindow","height=400,width=800,top=10%,left=10%,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no"); 
	}
});

//表格
var hospReportTab = new Ext.grid.EditorGridPanel({
	title: '全院考核报表',
	store: DimensTypeTabDs,
	cm: DimensTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addDimensType]
});

//加载
DimensTypeTabDs.load({params:{start:0, limit:15}});

