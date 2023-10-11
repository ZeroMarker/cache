var arr=[{name:'B125',id:'B125',tabIndex:'0',x:20,y:314,height:19,width:59,xtype:'label',text:'记录内容'},{name:'B126',id:'B126',tabIndex:'0',x:22,y:380,height:17,width:50,xtype:'label',text:'记录者'},{name:'B127',id:'B127',tabIndex:'0',x:304,y:385,height:14,width:54,xtype:'label',text:'日期'},{name:'subDate',id:'subDate',format:'Y-m-d',tabIndex:'0',x:367,y:373,height:25,width:136,xtype:'datefield',value:''},{name:'subTime',id:'subTime',tabIndex:'0',x:510,y:370,height:29,width:109,xtype:'timefield',value:''},{name:'Content',id:'Content',tabIndex:'0',x:78,y:297,height:71,width:738,xtype:'textarea',value:''},{name:'Doctor',id:'Doctor',tabIndex:'0',x:83,y:376,height:22,width:103,xtype:'combo',store:new Ext.data.JsonStore({data : [],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},{name:'T101',tabIndex:'0',x:0,y:1,height:225,width:798,xtype:'panel',layout:'absolute',border:false,items:[new Ext.grid.GridPanel({id:'T101',name:'T101',title:'记录信息',clicksToEdit: 1, stripeRows: true,height:225,width:798,tbar:[{id:'T101but1',text:'新建'},{id:'T101but2',text:'修改'}],store:new Ext.data.JsonStore({data:[],fields:['AdmDate','Week','Weight','HPressure','LPressure','UrineProtein','Hematin','Edema','UterineHeight','AbdomenCircum','BabyPositionDR','FetalHeart','PresentationDR','AmnioticFluidVol','UrineEstriol','BiparictalDis','AmnioticFluidThick','Disposal','Doctordr']}),colModel: new Ext.grid.ColumnModel({columns:[{header:'就诊日期',dataIndex:'AdmDate',width:83, renderer:Ext.util.Format.dateRenderer('Y-m-d'),editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'D102',format: 'Y-m-d'}))},{header:'孕周',dataIndex:'Week',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'体重',dataIndex:'Weight',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'收缩压',dataIndex:'HPressure',width:78,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'舒张压',dataIndex:'LPressure',width:69,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'尿蛋白',dataIndex:'UrineProtein',width:68,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'血色素',dataIndex:'Hematin',width:74,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'水肿',dataIndex:'Edema',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'宫高',dataIndex:'UterineHeight',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'腹围',dataIndex:'AbdomenCircum',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'胎位',dataIndex:'BabyPositionDR',width:50,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}),mode:'local'}))},{header:'胎心',dataIndex:'FetalHeart',width:50,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'先露',dataIndex:'PresentationDR',width:50,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}),mode:'local'}))},{header:'羊水量',dataIndex:'AmnioticFluidVol',width:67,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'尿雌三醇',dataIndex:'UrineEstriol',width:79,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'双顶径(cm)',dataIndex:'BiparictalDis',width:92,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'羊水平段(cm)',dataIndex:'AmnioticFluidThick',width:100,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'处置',dataIndex:'Disposal',width:66,editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},{header:'检查者',dataIndex:'Doctordr',width:104,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id', valueField:'desc',store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}),mode:'local'}))}],rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:new Ext.data.JsonStore({data:[],fields:['AdmDate','Week','Weight','HPressure','LPressure','UrineProtein','Hematin','Edema','UterineHeight','AbdomenCircum','BabyPositionDR','FetalHeart','PresentationDR','AmnioticFluidVol','UrineEstriol','BiparictalDis','AmnioticFluidThick','Disposal','Doctordr']}),displayInfo:true,pageSize:10})})]},{name:'_Label2',id:'_Label2',tabIndex:'3',x:10,y:280,height:25,width:102,xtype:'label',text:'特殊诊疗记录'}];
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
BodyLoadHandler();
});
