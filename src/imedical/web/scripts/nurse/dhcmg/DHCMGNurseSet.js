var arr=[{name:'B101',id:'B101',tabIndex:'0',x:15,y:22,height:11,width:60,xtype:'label',text:'数据库'},{name:'B102',id:'B102',tabIndex:'0',x:15,y:72,height:19,width:66,xtype:'label',text:'webserver'},{name:'B107',id:'B107',tabIndex:'0',x:15,y:112,height:23,width:87,xtype:'label',text:'GeneratorPath'},{tabIndex:'0' ,xtype:'textfield',x:128,y:22,height:21,width:320,name:'dbip',id:'dbip',value:''},{tabIndex:'0' ,xtype:'textfield',x:128,y:70,height:21,width:172,name:'webip',id:'webip',value:''},{tabIndex:'0' ,xtype:'textfield',x:129,y:115,height:21,width:309,name:'GeneratorPath',id:'GeneratorPath',value:''},{tabIndex:'3',name:'_Button5',xtype:'panel',layout:'column',x:317,y:177,height:31,width:95,border:false,buttons:[{plain:true,frame:true,xtype:'button',id:'_Button5',text:'保存'}]}];
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
