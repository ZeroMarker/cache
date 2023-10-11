var arr=[{name:'B101',id:'B101',tabIndex:'0',x:20,y:45,height:18,width:31,xtype:'label',text:'孕周'},{name:'B103',id:'B103',tabIndex:'0',x:204,y:43,height:14,width:63,xtype:'label',text:'评估日期'},{name:'B105',id:'B105',tabIndex:'0',x:13,y:80,height:22,width:61,xtype:'label',text:'本次孕期情况'},{name:'B106',id:'B106',tabIndex:'0',x:16,y:159,height:26,width:56,xtype:'label',text:'骨盆情况'},{name:'B107',id:'B107',tabIndex:'0',x:583,y:263,height:18,width:85,xtype:'label',text:'估计胎儿大小'},{name:'B108',id:'B108',tabIndex:'0',x:27,y:376,height:20,width:53,xtype:'label',text:'医生意见'},{name:'B109',id:'B109',tabIndex:'0',x:467,y:540,height:19,width:65,xtype:'label',text:'医师签名'},{name:'B110',id:'B110',tabIndex:'0',x:462,y:592,height:14,width:57,xtype:'label',text:'日期时间'},{name:'EvalDate',id:'EvalDate',format:'Y-m-d',tabIndex:'0',x:289,y:33,height:27,width:116,xtype:'datefield',value:''},{name:'CDate',id:'CDate',format:'Y-m-d',tabIndex:'0',x:536,y:581,height:23,width:117,xtype:'datefield',value:''},{name:'CTime',id:'CTime',tabIndex:'0',x:661,y:579,height:26,width:112,xtype:'timefield',value:''},{name:'PregMem',id:'PregMem',tabIndex:'0',x:91,y:75,height:54,width:706,xtype:'textarea',value:''},{name:'Pelvis',id:'Pelvis',tabIndex:'0',x:89,y:146,height:82,width:709,xtype:'textarea',value:''},{name:'FetusWeight',id:'FetusWeight',tabIndex:'0',x:89,y:386,height:60,width:709,xtype:'textarea',value:''},{name:'Doctor',id:'Doctor',tabIndex:'0',x:546,y:540,height:25,width:148,xtype:'combo',store:new Ext.data.JsonStore({data : [],fields: ['desc', 'id']}), displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},{tabIndex:'0' ,xtype:'textfield',x:94,y:41,height:21,width:75,name:'PregWeek',id:'PregWeek',value:''},{tabIndex:'0' ,xtype:'textfield',x:679,y:257,height:21,width:112,name:'FetusWeight',id:'FetusWeight',value:''},{name:'_Label1',id:'_Label1',tabIndex:'3',x:13,y:12,height:23,width:101,xtype:'label',text:'分娩方式评估'}];
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
