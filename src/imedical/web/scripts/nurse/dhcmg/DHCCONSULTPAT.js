var arr=[{name:'B101',id:'B101',tabIndex:'0',x:32,y:6,height:21,width:30,xtype:'label',text:'姓名'},{name:'B102',id:'B102',tabIndex:'0',x:266,y:6,height:21,width:30,xtype:'label',text:'床号'},{name:'B103',id:'B103',tabIndex:'0',x:31,y:34,height:21,width:31,xtype:'label',text:'科室'},{name:'B104',id:'B104',tabIndex:'0',x:435,y:6,height:21,width:48,xtype:'label',text:'登记号'},{name:'B105',id:'B105',tabIndex:'0',x:229,y:34,height:21,width:67,xtype:'label',text:'住院病历号'},{name:'B106',id:'B106',tabIndex:'0',x:8,y:61,height:21,width:54,xtype:'label',text:'申请日期'},{name:'B109',id:'B109',tabIndex:'0',x:429,y:61,height:11,width:54,xtype:'label',text:'会诊科室'},{name:'B110',id:'B110',tabIndex:'0',x:65,y:297,height:17,width:79,xtype:'label',text:'主要诊断'},{name:'B111',id:'B111',tabIndex:'0',x:65,y:123,height:20,width:137,xtype:'label',text:'简要病历及会诊目的'},{name:'B112',id:'B112',tabIndex:'0',x:65,y:366,height:15,width:68,xtype:'label',text:'会诊意见'},{name:'B113',id:'B113',tabIndex:'0',x:448,y:553,height:21,width:64,xtype:'label',text:'会诊医生'},{name:'B114',id:'B114',tabIndex:'0',x:31,y:93,height:20,width:29,xtype:'label',text:'类别'},{name:'B115',id:'B115',tabIndex:'0',x:243,y:93,height:20,width:53,xtype:'label',text:'院内院外'},{name:'B116',id:'B116',tabIndex:'0',x:465,y:348,height:16,width:57,xtype:'label',text:'申请医生'},{name:'B117',id:'B117',tabIndex:'0',x:242,y:61,height:21,width:53,xtype:'label',text:'申请时间'},{name:'B120',id:'B120',tabIndex:'0',x:407,y:93,height:11,width:79,xtype:'label',text:'要求会诊医生'},{name:'B122',id:'B122',tabIndex:'0',x:65,y:553,height:21,width:56,xtype:'label',text:'会诊日期'},{name:'B123',id:'B123',tabIndex:'0',x:263,y:553,height:21,width:53,xtype:'label',text:'会诊时间'},{name:'AppDate',id:'AppDate',format:'Y-m-d',tabIndex:'0',x:65,y:61,height:29,width:139,xtype:'datefield',value:''},{name:'ConsultDate',id:'ConsultDate',format:'Y-m-d',tabIndex:'0',x:128,y:553,height:32,width:110,xtype:'datefield',value:''},{name:'ConDestination',id:'ConDestination',tabIndex:'0',x:65,y:143,height:147,width:570,xtype:'textarea',value:''},{name:'Attitude',id:'Attitude',tabIndex:'0',x:65,y:387,height:161,width:570,xtype:'textarea',value:''},{name:'ConsultDep',id:'ConsultDep',tabIndex:'0',x:484,y:61,height:21,width:152,xtype:'combo',store:new Ext.data.JsonStore({data : [],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},{name:'ConsultDoc',id:'ConsultDoc',tabIndex:'0',x:525,y:553,height:21,width:112,xtype:'combo',store:new Ext.data.JsonStore({data : [],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},{name:'RequestConDoc',id:'RequestConDoc',tabIndex:'0',x:484,y:93,height:21,width:152,xtype:'combo',store:new Ext.data.JsonStore({data : [],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},{name:'ConType',id:'ConType',tabIndex:'0',x:65,y:93,height:20,width:86,xtype:'combo',store:new Ext.data.SimpleStore({data : [['一般','C'],['急','E']],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:'C'},{name:'InOut',id:'InOut',tabIndex:'0',x:296,y:93,height:20,width:84,xtype:'combo',store:new Ext.data.SimpleStore({data : [['院内','I'],['院外','O']],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:'I'},{tabIndex:'0' ,xtype:'textfield',x:65,y:6,height:21,width:139,name:'PatName',id:'PatName',value:''},{tabIndex:'0' ,xtype:'textfield',x:296,y:6,height:21,width:84,name:'BedCode',id:'BedCode',value:''},{tabIndex:'0' ,xtype:'textfield',x:65,y:34,height:21,width:139,name:'PatDep',id:'PatDep',value:''},{tabIndex:'0' ,xtype:'textfield',x:484,y:6,height:21,width:152,name:'PatRegNo',id:'PatRegNo',value:''},{tabIndex:'0' ,xtype:'textfield',x:296,y:34,height:21,width:84,name:'PatId',id:'PatId',value:'asdfasdf'},{tabIndex:'0' ,xtype:'textfield',x:65,y:316,height:21,width:567,name:'Diag',id:'Diag',value:''},{tabIndex:'0' ,xtype:'textfield',x:532,y:345,height:21,width:101,name:'PatDoc',id:'PatDoc',value:''},{tabIndex:'0' ,xtype:'textfield',x:296,y:61,height:21,width:84,name:'AppTime',id:'AppTime',value:''},{tabIndex:'0' ,xtype:'textfield',x:325,y:553,height:21,width:90,name:'ConsultTime',id:'ConsultTime',value:''}];
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