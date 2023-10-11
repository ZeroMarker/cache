var arr=[{id:'mygridpl',name:'mygrid',tabIndex:'0',x:-2,y:-2,height:304,width:711,xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'mygrid',name:'mygrid',title:'外科护理记录',clicksToEdit: 1, stripeRows: true,height:304,width:711,tbar:[{id:'mygridbut1',text:'新建'},{id:'mygridbut2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['CareDate','CareTime','Item1','Item2','Item3','Item4','Item5','Item6','Item7','Item8','Item9','Item10','Item11','Item12','Item13','Item14','Item15','Item16','Item17','Item18','CaseMeasure','User','rw','par']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'日期',dataIndex:'CareDate',width:71, renderer:Ext.util.Format.dateRenderer('Y-m-d'),editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'D115',format: 'Y-m-d'}))},{header:'时间',dataIndex:'CareTime',width:72,editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))},{header:'护理级别',dataIndex:'Item1',width:71,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [['特级','特级'],['I级','I级'],['II级','II级'],['III级','III级']],fields: ['desc', 'id']}),mode:'local'}))},{header:'饮食',dataIndex:'Item2',width:50,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [['普食','普食'],['半流食','半流食'],['流食','流食'],['禁食水','禁食水'],['糖尿病饮食','糖尿病饮食'],['鼻饲饮食','鼻饲饮食'],['低盐饮食','低盐饮食'],['低蛋白饮食','低蛋白饮食'],['低盐低脂饮食','低盐低脂饮食'],['低脂饮食','低脂饮食']],fields: ['desc', 'id']}),mode:'local'}))},{header:'意识',dataIndex:'Item3',width:50,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [['清醒','清醒'],['嗜睡','嗜睡'],['意识模糊','意识模糊'],['昏睡','昏睡'],['浅昏迷','浅昏迷'],['深昏迷','深昏迷'],['谵妄状态','谵妄状态']],fields: ['desc', 'id']}),mode:'local'}))},{header:'体温',dataIndex:'Item4',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'心率',dataIndex:'Item5',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'呼吸',dataIndex:'Item6',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'收缩压',dataIndex:'Item7',width:60,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'舒张压',dataIndex:'Item8',width:59,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'血氧饱和度',dataIndex:'Item9',width:80,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'吸氧',dataIndex:'Item10',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'切口敷料',dataIndex:'Item11',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [['整洁','整洁'],['渗出','渗出']],fields: ['desc', 'id']}),mode:'local'}))},{header:'名称',dataIndex:'Item12',width:78,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'量',dataIndex:'Item13',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'名称',dataIndex:'Item14',width:81,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'量',dataIndex:'Item15',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'颜色性状',dataIndex:'Item16',width:84,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'其他1',dataIndex:'Item17',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'其他2',dataIndex:'Item18',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'病情变化及护理措施',dataIndex:'CaseMeasure',width:162,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'签名',dataIndex:'User',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'rw',dataIndex:'rw',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'par',dataIndex:'par',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))}],rows:[[{},{},{},{},{},{},{},{},{},{},{},{},{},{header:'入液量',colspan:2,align:'center'},{header:'出液量',colspan:3,align:'center'},{},{},{},{},{},{}]],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit: false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['CareDate','CareTime','Item1','Item2','Item3','Item4','Item5','Item6','Item7','Item8','Item9','Item10','Item11','Item12','Item13','Item14','Item15','Item16','Item17','Item18','CaseMeasure','User','rw','par']}),displayInfo:true,pageSize:10})})]}];
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
