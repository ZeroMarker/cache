var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:-2,y:-2,height:243,width:733,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'mygrid',name:'mygrid',title:'会诊列表',clicksToEdit: 1, stripeRows: true,height:243,width:733,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['ConDep','DocGrade','ConNum','ConMoney','Note']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'科室',dataIndex:'ConDep',width:179,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'类别',dataIndex:'DocGrade',width:95,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'会诊次数',dataIndex:'ConNum',width:89,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'金额',dataIndex:'ConMoney',width:87,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'备注',dataIndex:'Note',width:224,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['ConDep','DocGrade','ConNum','ConMoney','Note']}),displayInfo:true,pageSize:10})})]}];
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
