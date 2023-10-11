var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:-2,y:-2,height:214,width:598,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'mygrid',name:'mygrid',title:'其他记录',clicksToEdit: 1, stripeRows: true,height:214,width:598,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['ADate','ATime','Typ','User','rw','TypDr']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'日期',dataIndex:'ADate',width:95,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'时间',dataIndex:'ATime',width:103,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'事件',dataIndex:'Typ',width:118,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'记录人',dataIndex:'User',width:86,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'rw',dataIndex:'rw',width:2,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'TypDr',dataIndex:'TypDr',width:4,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['ADate','ATime','Typ','User','rw','TypDr']}),displayInfo:true,pageSize:10})})]}];
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
