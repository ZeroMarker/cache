var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:-2,y:-4,height:277,width:692,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'mygrid',name:'mygrid',title:'会诊列表',clicksToEdit: 1, stripeRows: true,height:277,width:692,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['PatDep','BedCode','PatName','Diag','Destination','Contyp','InOut','AppDate','AppTime','ConDep','RequestConDoc','ConDate','ConTime','ConDoc','Status','EpisodeId','RowID']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'病人科室',dataIndex:'PatDep',width:115,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'床号',dataIndex:'BedCode',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'病人姓名',dataIndex:'PatName',width:66,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'主诊断',dataIndex:'Diag',width:193,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'基本情况及会诊目的',dataIndex:'Destination',width:251,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'类别',dataIndex:'Contyp',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'院内院外',dataIndex:'InOut',width:65,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'申请日期',dataIndex:'AppDate',width:70,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'申请时间',dataIndex:'AppTime',width:65,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'会诊科室',dataIndex:'ConDep',width:126,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'要求会诊医生',dataIndex:'RequestConDoc',width:98,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'会诊日期',dataIndex:'ConDate',width:75,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'会诊时间',dataIndex:'ConTime',width:66,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'会诊医生',dataIndex:'ConDoc',width:71,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'状态',dataIndex:'Status',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'EpisodeId',dataIndex:'EpisodeId',width:4,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'RowID',dataIndex:'RowID',width:5,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['PatDep','BedCode','PatName','Diag','Destination','Contyp','InOut','AppDate','AppTime','ConDep','RequestConDoc','ConDate','ConTime','ConDoc','Status','EpisodeId','RowID']}),displayInfo:true,pageSize:10})})]}];
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
