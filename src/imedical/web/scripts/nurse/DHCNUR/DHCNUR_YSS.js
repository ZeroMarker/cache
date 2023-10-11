var sm = new Ext.grid.CheckboxSelectionModel();
var sm1 = new Ext.grid.CheckboxSelectionModel();
var sm2 = new Ext.grid.CheckboxSelectionModel();
var sm3 = new Ext.grid.CheckboxSelectionModel();
var DHCNUR_YSST102=new Ext.data.JsonStore({data:[],fields:['CareDate','CareTime']});
var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:161,y:99,height:327,width:555,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'mygrid',name:'mygrid',title:'T102',loadMask:true,clicksToEdit: 1, stripeRows: true,height:327,width:555,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:DHCNUR_YSST102,colModel: new Ext.grid.ColumnModel({columns:[{header:'日期',dataIndex:'CareDate',width:169,renderer:function(value){if(value instanceof Date){ return new Date(value).format("Y-m-d");}else{ return value}}, editor:new Ext.form.DateField({id:'D106',format: 'Y-m-d'})},{header:'时间',dataIndex:'CareTime',width:170,editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))}],rows:[],defaultSortable:false}),enableColumnMove: false,viewConfig:{forceFit: false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:DHCNUR_YSST102,displayInfo:true,pageSize:10})})]}];
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
