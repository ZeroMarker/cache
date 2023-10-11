/**
 * @author Administrator
 */
var locdata=new Array();
var condata=new Array();
var arr=new Array();
//var a=cspRunServerMethod(pdata1,"","dhcnurRec",EpisodeID,"");
//alert(comlayout);
//alert(a);

//arr=eval(comlayout);
  var ds = new Ext.data.Store         //创建数据源格式
            ({
				proxy: new Ext.data.HttpProxy({ url: 'web.DHCMGtestpge.cls?AppType=List&EpisodeID=' + EpisodeID }),     
                reader: new Ext.data.JsonReader(
                {                    
                    root: 'root1'                               //具体数据
                },
                [
                    { name: 'a' },
                    { name: 'b' }
                ])
                });

    
    ds.load();
	//store.load(); 
	//debugger;
 var	DataStore = new Ext.data.Store({
		//数据存储器 
		proxy: new Ext.data.HttpProxy({
			url: "web.DHCMGtestpge.cls?mth="+"ss"
		}),
		reader: new Ext.data.JsonReader({
			root: 'd'
		}, [
		   {name:'s1'},
	       {name:'s2'}
	     ])
	});
	DataStore.load({params:{start:0,limit:5}} );
arr=[{name:'testgrid',tabIndex:'0',x:1,y:0,height:237,width:508,xtype:'panel',
layout:'fit',border:false,
items:[new Ext.grid.EditorGridPanel({id:'testgrid',
name:'testgrid',title:'T101',
clicksToEdit: 1, 
stripeRows: true,
height:237,
width:508,
tbar:[{id:'testgridbut1',text:'新建'},{id:'testgridbut2',text:'修改'}],
store:DataStore,
colModel: new Ext.grid.ColumnModel({columns:[{header:'S102',dataIndex:'s1',width:219,
editor: new Ext.grid.GridEditor(new Ext.form.TextField())},
{header:'S103',dataIndex:'s2',width:164,
editor: new Ext.grid.GridEditor(new Ext.form.TextField())}],
rows:[],defaultSortable: true}),enableColumnMove: false,viewConfig:{forceFit: true},
plugins:[new Ext.ux.plugins.GroupHeaderGrid()],
sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),
bbar: new Ext.PagingToolbar({store:DataStore,displayInfo:true,pageSize:5})})]}]


Ext.onReady(function() {
     new Ext.form.FormPanel({
       	height:680,
        width: 1100,
		id:'gform',
        autoScroll:true,
        layout: 'absolute',
        items:arr,
        renderTo: Ext.getBody()
    });
	//DataStore.load();
	debugger;
	// lnmp=Ext.getCmp("Preglnmp");
	//alert(1);
	//var btn=Ext.getCmp('but1');
	//btn.on('click',add);
	//var btn=Ext.getCmp('but2');
	//btn.on('click',find);
//debugger;

	//Ext.on(window, "load", fireDocReady);  
//lnmp.on('change',function(){alert("dfd");});
//BodyLoadHandler();
 });
 
 

  