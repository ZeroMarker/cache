var loadData;
function part1(){
var p1store=new Ext.data.JsonStore({data:[],fields:['field1','index3','field3','field4','field2','rw']});
var p1model=new Ext.grid.ColumnModel({columns:[
{header:'标签',dataIndex:'field1',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'字段',dataIndex:'index3',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'选中',dataIndex:'field3',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',valueField:'desc',store:new Ext.data.JsonStore({data:[{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields: ['desc','id']}),mode:'local'}))},
{header:'隐藏',dataIndex:'field4',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',valueField:'desc',store:new Ext.data.JsonStore({data:[{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields:['desc','id']}),mode:'local'}))},
{header:'顺序',dataIndex:'field2',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'rw',dataIndex:'rw',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))}
],defaultSortable:false});
var p1=new Ext.grid.EditorGridPanel({id:'p1',title:'查询条件',clicksToEdit:1,stripeRows:true,height:320,width:380.82,tbar:[
{id:'p1b1',text:'新建',handler:add1},
{id:'p1b2',text:'保存',handler:save1},
{id:'p1b3',text:'删除',handler:delete1},
{id:'p1b4',text:'查询',handler:find1}
],store:p1store,colModel:p1model,enableColumnMove:false,viewConfig:{forceFit:false},sm:new Ext.grid.RowSelectionModel({singleSelect:false})});
}
function add1(){
var p1=Ext.getCmp('p1');
var plant=Ext.data.Record.create([
{name:'field1'},
{name:'index3'},
{name:'field3'},
{name:'field4'},
{name:'field2'},
{name:'rw'}
]);
var count=p1.store.getCount();
var r=new plant();
p1.store.commitChanges();
p1.store.insert(count,r);
}
function save1(){
var p1=Ext.getCmp('p1');
var rowObj=p1.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var str="";
var obj=rowObj[0].data;
for(var p in obj){
str+=(str!="")?"^":"";
str+=p+"|"+obj[p];
}
if(str!=""){
str+="^index1|durgauditnew^index2|west"
var ret=cspRunServerMethod(saveset,str);
if(ret>0){
alert('保存成功!');
find1();
}
}
}
function delete1(){
var p1=Ext.getCmp('p1');
var rowObj=p1.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var obj=rowObj[0].data;
var rw=obj["rw"];
if(rw!=""){
var ret=cspRunServerMethod(deleteset,rw);
if(ret>0){
alert('删除成功!');
find1();
}
}
}
function find1(){
var p1=Ext.getCmp('p1');
var parr="index1|durgauditnew^index2|west";
loadData=[];
var ret=cspRunServerMethod(getquerydata,"web.NurseSetNew:find","parr$"+parr,"addrec");
p1.store.loadData(loadData);
}
function part2(){
var p2store=new Ext.data.JsonStore({data:[],fields:['field1','index3','field3','field4','field2','field5','rw']});
var p2model=new Ext.grid.ColumnModel({columns:[
{header:'标签',dataIndex:'field1',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'字段',dataIndex:'index3',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'宽度',dataIndex:'field3',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'隐藏',dataIndex:'field4',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',valueField:'desc',store:new Ext.data.JsonStore({data:[{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields:['desc','id']}),mode:'local'}))},
{header:'顺序',dataIndex:'field2',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'field5',dataIndex:'field5',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))},
{header:'rw',dataIndex:'rw',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))}
],defaultSortable:false});
var p2=new Ext.grid.EditorGridPanel({id:'p2',title:'药品查询',clicksToEdit:1,stripeRows:true,height:320,width:380.82,tbar:[
{id:'p2b1',text:'新建',handler:add2},
{id:'p2b2',text:'保存',handler:save2},
{id:'p2b3',text:'删除',handler:delete2},
{id:'p2b4',text:'查询',handler:find2}
],store:p2store,colModel:p2model,enableColumnMove:false,viewConfig:{forceFit:false},sm:new Ext.grid.RowSelectionModel({singleSelect:false})});
}
function add2(){
var p2=Ext.getCmp('p2');
var plant=Ext.data.Record.create([
{name:'field1'},
{name:'index3'},
{name:'field3'},
{name:'field4'},
{name:'field2'},
{name:'field5'},
{name:'rw'}
]);
var count=p2.store.getCount();
var r=new plant();
p2.store.commitChanges();
p2.store.insert(count,r);
}
function save2(){
var p2=Ext.getCmp('p2');
var rowObj=p2.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var str="";
var obj=rowObj[0].data;
for(var p in obj){
str+=(str!="")?"^":"";
str+=p+"|"+obj[p];
}
if(str!=""){
str+="^index1|durgauditnew^index2|north"
var ret=cspRunServerMethod(saveset,str);
if(ret>0){
alert('保存成功!');
find2();
}
}
}
function delete2(){
var p2=Ext.getCmp('p2');
var rowObj=p2.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var obj=rowObj[0].data;
var rw=obj["rw"];
if(rw!=""){
var ret=cspRunServerMethod(deleteset,rw);
if(ret>0){
alert('删除成功!');
find2();
}
}
}
function find2(){
var p2=Ext.getCmp('p2');
var parr="index1|durgauditnew^index2|north";
loadData=[];
var ret=cspRunServerMethod(getquerydata,"web.NurseSetNew:find","parr$"+parr,"addrec");
p2.store.loadData(loadData);
}
function part3(){
var p3store=new Ext.data.JsonStore({data:[],fields:['field1','index3','field3','field4','field2','field5','rw']});
var p3model=new Ext.grid.ColumnModel({columns:[
{header:'标签',dataIndex:'field1',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'字段',dataIndex:'index3',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'宽度',dataIndex:'field3',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'隐藏',dataIndex:'field4',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',valueField:'desc',store:new Ext.data.JsonStore({data:[{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields:['desc','id']}),mode:'local'}))},
{header:'顺序',dataIndex:'field2',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'field5',dataIndex:'field5',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))},
{header:'rw',dataIndex:'rw',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))}
],defaultSortable:false});
var p3=new Ext.grid.EditorGridPanel({id:'p3',title:'明细查询',clicksToEdit:1,stripeRows:true,height:320,width:380.82,tbar:[
{id:'p3b1',text:'新建',handler:add3},
{id:'p3b2',text:'保存',handler:save3},
{id:'p3b3',text:'删除',handler:delete3},
{id:'p3b4',text:'查询',handler:find3}
],store:p3store,colModel:p3model,enableColumnMove:false,viewConfig:{forceFit:false},sm:new Ext.grid.RowSelectionModel({singleSelect:false})});
}
function add3(){
var p3=Ext.getCmp('p3');
var plant=Ext.data.Record.create([
{name:'field1'},
{name:'index3'},
{name:'field3'},
{name:'field4'},
{name:'field2'},
{name:'field5'},
{name:'rw'}
]);
var count=p3.store.getCount();
var r=new plant();
p3.store.commitChanges();
p3.store.insert(count,r);
}
function save3(){
var p3=Ext.getCmp('p3');
var rowObj=p3.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var str="";
var obj=rowObj[0].data;
for(var p in obj){
str+=(str!="")?"^":"";
str+=p+"|"+obj[p];
}
if(str!=""){
str+="^index1|durgauditnew^index2|south"
var ret=cspRunServerMethod(saveset,str);
if(ret>0){
alert('保存成功!');
find3();
}
}
}
function delete3(){
var p3=Ext.getCmp('p3');
var rowObj=p3.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var obj=rowObj[0].data;
var rw=obj["rw"];
if(rw!=""){
var ret=cspRunServerMethod(deleteset,rw);
if(ret>0){
alert('删除成功!');
find3();
}
}
}
function find3(){
var p3=Ext.getCmp('p3');
var parr="index1|durgauditnew^index2|south";
loadData=[];
var ret=cspRunServerMethod(getquerydata,"web.NurseSetNew:find","parr$"+parr,"addrec");
p3.store.loadData(loadData);
}
function part4(){
var p4store=new Ext.data.JsonStore({data:[],fields:['field1','index3','field3','field4','field2','rw']});
var p4model=new Ext.grid.ColumnModel({columns:[
{header:'标签',dataIndex:'field1',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'字段',dataIndex:'index3',width:100,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'颜色',dataIndex:'field3',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'控制',dataIndex:'field4',width:70,editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',valueField:'desc',store:new Ext.data.JsonStore({data:[{desc:'Y',id:'Y'},{desc:'N',id:'N'}],fields:['desc','id']}),mode:'local'}))},
{header:'顺序',dataIndex:'field2',width:70,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:false}))},
{header:'rw',dataIndex:'rw',width:0,editor:new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:true}))}
],defaultSortable:false});
var p4=new Ext.grid.EditorGridPanel({id:'p4',title:'审核控制',clicksToEdit:1,stripeRows:true,height:320,width:380.82,tbar:[
{id:'p4b1',text:'新建',handler:add4},
{id:'p4b2',text:'保存',handler:save4},
{id:'p4b3',text:'删除',handler:delete4},
{id:'p4b4',text:'查询',handler:find4}
],store:p4store,colModel:p4model,enableColumnMove:false,viewConfig:{forceFit:false},sm:new Ext.grid.RowSelectionModel({singleSelect:false})});
}
function add4(){
var p4=Ext.getCmp('p4');
var plant=Ext.data.Record.create([
{name:'field1'},
{name:'index3'},
{name:'field3'},
{name:'field4'},
{name:'field2'},
{name:'rw'}
]);
var count=p4.store.getCount();
var r=new plant();
p4.store.commitChanges();
p4.store.insert(count,r);
}
function save4(){
var p4=Ext.getCmp('p4');
var rowObj=p4.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var str="";
var obj=rowObj[0].data;
for(var p in obj){
str+=(str!="")?"^":"";
str+=p+"|"+obj[p];
}
if(str!=""){
str+="^index1|durgauditnew^index2|error"
var ret=cspRunServerMethod(saveset,str);
if(ret>0){
alert('保存成功!');
find4();
}
}
}
function delete4(){
var p4=Ext.getCmp('p4');
var rowObj=p4.getSelectionModel().getSelections();
if(rowObj.length==0){
alert('请选中一行!');
return;
}
var obj=rowObj[0].data;
var rw=obj["rw"];
if(rw!=""){
var ret=cspRunServerMethod(deleteset,rw);
if(ret>0){
alert('删除成功!');
find4();
}
}
}
function find4(){
var p4=Ext.getCmp('p4');
var parr="index1|durgauditnew^index2|error";
loadData=[];
var ret=cspRunServerMethod(getquerydata,"web.NurseSetNew:find","parr$"+parr,"addrec");
p4.store.loadData(loadData);
}
function part5(){
var f3=new Ext.form.TextField({
height:20,
id:'p5_field3',
fieldLabel:'开始日期',
allowBlank:true,
anchor:'80%'
});
var f4=new Ext.form.TextField({
height:20,
id:'p5_field4',
fieldLabel:'结束日期',
allowBlank:true,
anchor:'80%'
});
var f5=new Ext.form.TimeField({
height:20,
id:'p5_field5',
fieldLabel:'开始时间',
allowBlank:true,
format:'G:i',
anchor:'80%'
});
var f6=new Ext.form.TimeField({
height:20,
id:'p5_field6',
fieldLabel:'结束时间',
allowBlank:true,
format:'G:i',
anchor:'80%'
});
var rw=new Ext.form.TextField({
id:'p5_rw',
fieldLabel:'',
hidden:true
});
var p5=new Ext.form.FormPanel({
id:'p5',
baseCls:'x-plain',
labelWidth:60,
height:200,width:380.82,
items:[f3,f4,f5,f6,rw],
buttonAlign:'center',
buttons: [{
text:'保存',handler:function(){
save5();
}},{text:'清除',handler:function(){
delete5();
}},{text:'查询',handler:function(){
find5();
}}]
});
}
function save5(){
var f3=Ext.get("p5_field3").dom.value;
var f4=Ext.get("p5_field4").dom.value;
var f5=Ext.get("p5_field5").dom.value;;
var f6=Ext.get("p5_field6").dom.value;
var rw=Ext.get("p5_rw").dom.value;
if(f5+f6+f3+f4!=''){
var str="field3|"+f3+"^field4|"+f4+"^field5|"+f5+"^field6|"+f6+"^rw|"+rw;
str+="^index1|durgauditnew^index2|period^index3|0";
alert(str);
var ret=cspRunServerMethod(saveset,str);
if(ret>0){
alert('保存成功!');
find5();
}
}
}
function delete5(){
var rw=Ext.get("p5_rw").dom.value;
if(rw!=''){
var ret=cspRunServerMethod(deleteset,rw);
if(ret>0){
alert('删除成功!');
find5();
}
}
}
function find5(){
var ret=cspRunServerMethod(findsimple,"durgauditnew","period","0");
var f3=Ext.getCmp("p5_field3");
var f4=Ext.getCmp("p5_field4");
var f5=Ext.getCmp("p5_field5");
var f6=Ext.getCmp("p5_field6");
var rw=Ext.getCmp("p5_rw");
var arr=ret.split('^');
var arr5=tkMakeServerCall('Nur.Utility','getTime',arr[5]||'');
var arr6=tkMakeServerCall('Nur.Utility','getTime',arr[6]||'');
rw.setValue(arr[0]||'');
f3.setValue(arr[3]||'');
f4.setValue(arr[4]||'');
f5.setValue(arr5);
f6.setValue(arr6);
}
function part6(){
var f3_1=new Ext.form.Checkbox({
height:20,
id:'p6_field3_1',
fieldLabel:'成组审核',
checked:false,
anchor:'80%'
});
var f3_2=new Ext.form.Checkbox({
height:20,
id:'p6_field3_2',
fieldLabel:'库存提示',
checked:false,
anchor:'80%'
});
var f4_2=new Ext.form.Checkbox({
height:20,
id:'p6_field4_2',
fieldLabel:'库存控制',
checked:false,
anchor:'80%'
});
var f5_2=new Ext.form.Checkbox({
height:20,
id:'p6_field5_2',
fieldLabel:'包括已审未发提示',
checked:false,
anchor:'80%'
});
var f6_2=new Ext.form.Checkbox({
height:20,
id:'p6_field6_2',
fieldLabel:'包括已审未发控制',
checked:false,
anchor:'80%'
});
var rw_1=new Ext.form.TextField({
id:'p6_rw_1',
fieldLabel:'',
hidden:true
});
var rw_2=new Ext.form.TextField({
id:'p6_rw_2',
fieldLabel:'',
hidden:true
});
var p6=new Ext.form.FormPanel({
id:'p6',
baseCls:'x-plain',
labelWidth:120,
height:200,width:380.82,
items:[f3_1,f3_2,f4_2,f5_2,f6_2,rw_1,rw_2],
buttonAlign:'center',
buttons: [{
text:'保存',handler:function(){
save6();
}},{text:'清除',handler:function(){
delete6();
}},{text:'查询',handler:function(){
find6();
}}]
});
}
function save6(){
var f3_1=((Ext.getCmp("p6_field3_1").getValue()==true)?"Y":"");
var f3_2=((Ext.getCmp("p6_field3_2").getValue()==true)?"Y":"");
var f4_2=((Ext.getCmp("p6_field4_2").getValue()==true)?"Y":"");
var f5_2=((Ext.getCmp("p6_field5_2").getValue()==true)?"Y":"");
var f6_2=((Ext.getCmp("p6_field6_2").getValue()==true)?"Y":"");
var rw_1=Ext.getCmp("p6_rw_1").getValue();
var rw_2=Ext.getCmp("p6_rw_2").getValue();
if(f3_1+f3_2+f4_2+f5_2+f6_2!=""){
var str="field3|"+f3_1+"^rw|"+rw_1;
str+="^index1|durgauditnew^index2|other^index3|0";
alert(str);
var ret1=cspRunServerMethod(saveset,str);
str="field3|"+f3_2+"^field4|"+f4_2+"^field5|"+f5_2+"^field6|"+f6_2+"^rw|"+rw_2;
str+="^index1|durgauditnew^index2|other^index3|1";
alert(str);
var ret2=cspRunServerMethod(saveset,str);
if((ret1>0)&&(ret2>0)){
alert('保存成功!');
find6();
}
}
}
function delete6(){
var rw_1=Ext.getCmp("p6_rw_1").getValue();
var rw_2=Ext.getCmp("p6_rw_2").getValue();
if(rw_1+rw_2!=''){
var ret1=1;
if(rw_1!=""){
ret1=cspRunServerMethod(deleteset,rw_1);
}
var ret2=1;
if(rw_2!=""){
ret2=cspRunServerMethod(deleteset,rw_2);
}
if((ret1>0)&&(ret2>0)){
alert('删除成功!');
find6();
}
}
}
function find6(){
var ret1=cspRunServerMethod(findsimple,"durgauditnew","other","0");
var ret2=cspRunServerMethod(findsimple,"durgauditnew","other","1");
var f3_1=Ext.getCmp("p6_field3_1");
var f3_2=Ext.getCmp("p6_field3_2");
var f4_2=Ext.getCmp("p6_field4_2");
var f5_2=Ext.getCmp("p6_field5_2");
var f6_2=Ext.getCmp("p6_field6_2");
var rw_1=Ext.getCmp("p6_rw_1");
var rw_2=Ext.getCmp("p6_rw_2");
var arr1=ret1.split('^');
var arr2=ret2.split('^');
rw_1.setValue(arr1[0]);
rw_2.setValue(arr2[0]);
f3_1.setValue(arr1[3]=='Y');
f3_2.setValue(arr2[3]=='Y');
f4_2.setValue(arr2[4]=='Y');
f5_2.setValue(arr2[5]=='Y');
f6_2.setValue(arr2[6]=='Y');
}
function addrec(str){
var obj=eval('('+str+')');
loadData.push(obj);
}
Ext.onReady(function(){
Ext.QuickTips.init();
part1();
part2();
part3();
part4();
part5();
part6();
var p1=Ext.getCmp('p1');
var p2=Ext.getCmp('p2');
var p3=Ext.getCmp('p3');
var p4=Ext.getCmp('p4');
var p5=Ext.getCmp('p5');
var p6=Ext.getCmp('p6');
var r1=new Ext.Panel({
layout:'form',height:320,width:380.82,region:'west',id:'p1r1',items:[p1]
});
var r2=new Ext.Panel({
layout:'form',height:320,width:380.82,region:'center',id:'p1r2',items:[p2]
});
var r3=new Ext.Panel({
layout:'form',height:320,width:380.82,region:'east',id:'p1r3',items:[p3]
});
var r4=new Ext.Panel({
layout:'form',height:320,width:380.82,region:'west',id:'p1r4',items:[p4]
});
var r5=new Ext.Panel({
layout:'form',title:'查询时间',height:320,width:380.82,region:'center',id:'p1r5',items:[p5]
});
var r6=new Ext.Panel({
layout:'form',title:'其他设置',height:320,width:380.82,region:'east',id:'p1r6',items:[p6]
});
var a1=new Ext.Panel({
layout:'border',width:1154,height:336.5,region:'north',id:'a1',items:[r1,r2,r3]
})
var a2=new Ext.Panel({
layout:'border',width:1154,height:336.5,region:'center',id:'a2',items:[r4,r5,r6]
})
var viewport=new Ext.Viewport({id:'viewport1',layout:'border',defaults:{border:true,frame:true,split:true,bodyBorder:true},items:[a1,a2]});
var height=viewport.getHeight()*.5;
var width=viewport.getWidth()*.33;
a1.setHeight(height);
a2.setHeight(height);
a1.setWidth(viewport.getWidth());
a2.setWidth(viewport.getWidth());
r1.setHeight(height-17);
r2.setHeight(height-17);
r3.setHeight(height-17);
r4.setHeight(height-17);
r5.setHeight(height-17);
r6.setHeight(height-17);
r1.setWidth(width);
r2.setWidth(width);
r3.setWidth(width);
r4.setWidth(width);
r5.setWidth(width);
r6.setWidth(width);
p1.setHeight(height-17);
p2.setHeight(height-17);
p3.setHeight(height-17);
p4.setHeight(height-17);
p1.setWidth(width);
p2.setWidth(width);
p3.setWidth(width);
p4.setWidth(width);
p5.setWidth(width);
p6.setWidth(width);
viewport.syncSize();
find1();
find2();
find3();
find4();
find5();
find6();
});