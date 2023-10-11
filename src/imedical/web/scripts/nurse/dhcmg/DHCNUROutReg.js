var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:-2,y:-2,height:218,width:688,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'mygrid',name:'mygrid',title:'外出记录',clicksToEdit: 1, stripeRows: true,height:218,width:688,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['godate','gotime','nurse','edatern','etimern','reason','drapprove','adatern','atimern','nursern','rowid','chl','nur','rea','doc','turn']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'离开日期',dataIndex:'godate',width:69,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'离开时间',dataIndex:'gotime',width:73,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'批准护士',dataIndex:'nurse',width:72,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'预计返回日期',dataIndex:'edatern',width:94,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'预计返回时间',dataIndex:'etimern',width:95,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'批准理由',dataIndex:'reason',width:82,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'批准医生',dataIndex:'drapprove',width:73,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'实际返回日期',dataIndex:'adatern',width:100,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'实际返回时间',dataIndex:'atimern',width:94,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'返回护士',dataIndex:'nursern',width:78,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'rowid',dataIndex:'rowid',width:4,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'chl',dataIndex:'chl',width:5,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'nur',dataIndex:'nur',width:4,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'rea',dataIndex:'rea',width:2,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'doc',dataIndex:'doc',width:2,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'turn',dataIndex:'turn',width:5,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['godate','gotime','nurse','edatern','etimern','reason','drapprove','adatern','atimern','nursern','rowid','chl','nur','rea','doc','turn']}),displayInfo:true,pageSize:10})})]}];
var pg=0;
Ext.onReady(function() {
if (pg>0) return ;
 new Ext.form.FormPanel({
height:600,
width: 800,
id:'gform',
autoScroll:true,
layout: 'absolute',
items:arr,
renderTo: Ext.getBody()
});
pg++;
var fheight=document.body.offsetHeight;
var fwidth=document.body.offsetWidth;
var fm=Ext.getCmp('gform');
fm.setHeight(fheight);
fm.setWidth(fwidth);
BodyLoadHandler();
});
