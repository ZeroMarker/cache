/**
Creator:	杜金蓉
Desc:		代码表与值域映射
*/
  
var pagesize=100; 
var nodeCode='';
var nodeRight='';
var actionsBtn='';
var nodeidrightcode='';

//生成lefttree的store--------------------------------------------------
var reloadstore=function reloadstore(nodeidstr,nodecode,systemcode){
	nodeCode=nodecode;
	document.getElementById('nodeid').name=nodeidstr;
	document.getElementById('nodecdeBtn').name=nodecode;
	document.getElementById('nodeSystemBtn').name=systemcode;
	store.removeAll() ;
	store.load();
	return ;
}
var nodeid=document.getElementById('nodeid').name;
var nodeCode=document.getElementById('nodecdeBtn').name;
var systemcode=document.getElementById('nodeSystemBtn').name;
var sm = new Ext.grid.CheckboxSelectionModel({
 handleMouseDown: Ext.emptyFn
	  // singleSelect : false
});
var cm = new Ext.grid.ColumnModel([
	sm,
	{header:'值', dataIndex:'DEVID'},
	{header:'描述', dataIndex:'Meaning'}
    ]);
function GetGridStore(){
	var ds=new Ext.data.JsonStore({
		id:'storeleft',
		url : '../CT.WS.web.DicDataValueLeft.cls',
		method: 'POST',
		root: 'rows',
		totalProperty: "results",
		baseParams: { start: 0, limit: pagesize},
		fields: [
			{name:'DEVID'},
			{name:'Meaning'}
		],
		listeners: {
			'beforeload': function() {
				ds.baseParams = {nodeid:document.getElementById('nodeid').name,nodeCode:document.getElementById('nodecdeBtn').name,systemCode:document.getElementById('nodeSystemBtn').name};
			}
	}
});
return  ds;
}
store=GetGridStore();
store.load();
var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store:store,
	stripeRows:true,
	height:Ext.getBody().getHeight()*0.6-80,
    cm: cm,
	sm: sm,
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	listeners: {
		'click': function() {		
				gettableleftData();	
			}
	}
});



//righttree右边树的store---------------------------------------------------
var reloadstoreright=function reloadstoreright(nodeidstr,noderight){
	document.getElementById('nodeidright').name=nodeidstr;
	document.getElementById('noderightBtn').name=noderight;
	storeright.removeAll() ;
	storeright.load();
	return ;
}
var nodeidright=document.getElementById('nodeidright').name;
nodeidrightcode=document.getElementById('noderightBtn').name;
var smright = new Ext.grid.CheckboxSelectionModel({
	singleSelect :true
 });
 
 var cmright = new Ext.grid.ColumnModel([smright,
        {header:'值', dataIndex:'CtmDictCode'},
        {header:'描述', dataIndex:'CtmDictDesc'}
    ]);
function GetGridStoreright(){
	var dsright=new Ext.data.JsonStore({
		id:'storeright',
		url : '../CT.WS.web.DicDataValueRight.cls',
		method: 'POST',
		root: 'rows',
		totalProperty: "results",
		baseParams: { start: 0, limit: pagesize},
		fields: [
			{name:'CtmDictCode'},
			{name:'CtmDictDesc'}
		],
		listeners: {
		'beforeload': function() {
		dsright.baseParams = {nodeidright:document.getElementById('nodeidright').name,nodeRightCode:document.getElementById('noderightBtn').name};
			}
	}
});
return  dsright;
}
storeright=GetGridStoreright();
storeright.load();
var eprEpisodeGridright = new Ext.grid.GridPanel({
    id: 'eprEpisodeGridright',
    layout: 'fit',
    border: false,
    store:storeright,
	stripeRows:true,
	height:Ext.getBody().getHeight()*0.6-80,
    cm: cmright,
	sm: smright,
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	listeners: {
		'click': function() {		
				gettablerightData();	
			}
	}
});



//映射stroe----------------------------------------------------------
//中间映射的store
   var reloadMapstore=function reloadMapstore(nodeidstr,nodecode,systemcode){
			storemap.removeAll() ;
			storemap.load();
			return ;
			
		}
var smmap = new Ext.grid.CheckboxSelectionModel({
        listeners:{
            'rowselect':function(record,index,e)
            {			
            }
        }
    });

var cmmap = new Ext.grid.ColumnModel([smmap,
		{header:'id', dataIndex:'id',hidden :true},
        {header:'自定义字典数据代码', dataIndex:'DEVID'},
        {header:'自定义字典数据描述', dataIndex:'Meaning'},
		{header:'标准值域数据代码', dataIndex:'CtmDictCode'},
		{header:'标准值域数允许值含义', dataIndex:'CtmDictDesc'}
    ]);
function GetGridStoreMap(){
	var ds=new Ext.data.JsonStore({
		id:'storemap',
		url : '../CT.WS.web.DicDataValueMapLR.cls',
		method: 'POST',
		root: 'rows',
		totalproperty: "results",
		fields: [
			{name:'id'},
			{name:'DEVID'},
			{name:'Meaning'},
			{name:'CtmDictCode'},
			{name:'CtmDictDesc'}
		],
		listeners: {
			'beforeload': function() {
				var delectIds='';
				if(actionsBtn=='btnDelete'){
					delectIds=gettablemapData();
				}
				var leftdata = Ext.getCmp('eprEpisodeGrid').getSelectionModel().getSelections();
				ds.baseParams = {actionBtn:actionsBtn,leftlength:leftdata.length,seldataleft:gettableleftData(),seldataright:gettablerightData(),delectId:delectIds,nodeCode:document.getElementById('nodecdeBtn').name,nodeRightCode:document.getElementById('noderightBtn').name,systemCode:document.getElementById('nodeSystemBtn')};
			}
	}
});
return  ds;
}
storemap=GetGridStoreMap();
storemap.load();
var eprEpisodeGridmap = new Ext.grid.GridPanel({
    id: 'eprEpisodeGridmap',
    layout: 'fit',
    border: false,
    store:storemap,
	stripeRows:true,
	height:Ext.getBody().getHeight()*0.29,
    cm: cmmap,
	sm: smmap,
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	listeners: {
		'click': function() {			
			}
	}
});



//主页面显示
var eprPortal = new Ext.Viewport({
    id: 'eprPortal123',
	title:'自定字典数据与标准值域代码表数据映射',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
	width: '100%',
    collapsible: false,
    animCollapse: false,
    constrainHeader: true,
	items:[{
			id:'datamap',
            region: 'center',  
			title:'自定义字典数据与数据元值域代码表映射',
			items:[{
				id:'datamapcustom',
				region: 'north',
				collapsible: false,
				split: true,
				width: '100%',
				layout: 'border',
				height: Ext.getBody().getHeight()*0.6,
				bbar:[{xtype : "tbfill"},'-',{
					align:'right',
					id: 'btndataMap',
					text: '映射',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/家族史.gif',	
					pressed: false
				}],
				items:[{
					id:'datamapcustom_west',
					region: 'west',
					title: '自定义字典数据',
					split: true,
					collapsible: false,
					width: '50%',
					items:[eprEpisodeGrid],
					 bbar: new Ext.PagingToolbar({
						id: "datamapcustom_westToolbar",
						store: store,
						pageSize: pagesize,
						displayInfo: true,
						displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
						beforePageText: '页码',
						afterPageText: '总页数 {0}',
						firstText: '首页',
						prevText: '上一页',
						nextText: '下一页',
						lastText: '末页',
						refreshText: '刷新',
						emptyMsg: "没有记录"
						 })
					},{
					id:'datamapcustom_center',
					region: 'center',
					title: '标准值域代码表数据',
					split: true,
					width: '50%',
					collapsible: false,
					items:[eprEpisodeGridright],
					 bbar: new Ext.PagingToolbar({
						id: "datamapcustom_rightToolbar",
						store: storeright,
						pageSize: pagesize,
						displayInfo: true,
						displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
						beforePageText: '页码',
						afterPageText: '总页数 {0}',
						firstText: '首页',
						prevText: '上一页',
						nextText: '下一页',
						lastText: '末页',
						refreshText: '刷新',
						emptyMsg: "没有记录"
						 })
					}]
				},{
				region: 'south',
				title: '值域映射',
				split: true,
				collapsible: false,
				height: Ext.getBody().getHeight()*0.36,
				items:[eprEpisodeGridmap],
				bbar:[{xtype : "tbfill"},'-',{
					align:'right',
					id: 'btnDelete',
					text: '删除',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/btnClose.gif',
					pressed: false
				}]
				
				}]
        },{
			id:'dicdataMaptreeleftid',
            region: 'west',
            collapsible: false,
            title: '自定义字典',
            split: true,
            width: '20%',
            minWidth: 100,
            minHeight: 140,
           html: '<iframe id="dicdataMaptreeleft" name="dicdataMaptreeleft" style="width:100%; height:100%" src="CT.WS.dicdataMaptreeleft.csp"></frame>'
        },{
            region: 'east',
            collapsible: false,
            title: '卫生数据元值域代码表',
            split: true,
            width: '20%',
            minWidth: 100,
            minHeight:'100%',
            html: '<iframe id="dicdataMaptreeright" name="dicdataMaptreeright" style="width:100%; height:100%" src="CT.WS.dicdataMaptreeright.csp"></frame>'
        }]
});


//映射按钮事件
var btndataMap= Ext.getCmp('btndataMap'); 
btndataMap.on('click',function(){
	actionsBtn='btndataMap';
	var leftdata = Ext.getCmp('eprEpisodeGrid').getSelectionModel().getSelections();
	var rightdata = Ext.getCmp('eprEpisodeGridright').getSelectionModel().getSelections();
	if(leftdata.length==0){
		Ext.Msg.alert('操作提示', '请选择[自定义字典数据]');
	}
	else if(rightdata.length==0){
		Ext.Msg.alert('操作提示', '请选择一行[标准值域代码表数据]');
	}
	else if(rightdata.length>1){
		Ext.Msg.alert('操作提示', '[标准值域代码表数据]只能选择一行');
	}else{
		storemap.reload();
	}
});	


//选择左边checkbox事件
var seldataleft=function gettableleftData(){
var leftdata = Ext.getCmp('eprEpisodeGrid').getSelectionModel().getSelections();
	var seldataleft='';
	for(i=0;i<leftdata.length;i++){
	var divids="divid"+i;
		divids=leftdata[i];
		seldataleft=seldataleft+'|@|DEVID:'+divids.data['DEVID']+'^Meaning:'+divids.data['Meaning'];
	}
	seldataleft=seldataleft.substring(3,seldataleft.length);
	return seldataleft;
}


//选择右边checkbox事件
var seldataright=function gettablerightData(){
	var seldataright='';
	var rightdata = Ext.getCmp('eprEpisodeGridright').getSelectionModel().getSelections();
	for(i=0;i<rightdata.length;i++){	
		var rightdatas="rightdata"+i;
		rightdatas=rightdata[i];
		seldataright='CtmDictCode:'+rightdatas.data['CtmDictCode']+'^CtmDictDesc:'+rightdatas.data['CtmDictDesc'];
		return seldataright;
	}
}



//选择删除checkbox事件
var isNum=0;
var seldatamap=function gettablemapData(){
	var seldatamap='';
	var mapdata = Ext.getCmp('eprEpisodeGridmap').getSelectionModel().getSelections();

	for(i=0;i<mapdata.length;i++){	
		var mapdatas="mapdata"+i;
		mapdatas=mapdata[i];
		if(mapdatas.data['id']!=null||mapdatas.data['id'].trim().length>1){
			isNum++
		}
		seldatamap=seldatamap+'^id:'+mapdatas.data['id'];
	}
	return seldatamap.substring(1,seldatamap.length);
}

//删除按钮事件
var btnDelete= Ext.getCmp('btnDelete'); 
btnDelete.on('click',function(){
	actionsBtn='btnDelete';
	gettablemapData();
	if(isNum==0){
		Ext.Msg.alert('操作提示', '请选择需要[删除]的[值域映射]');
	}else{
	storemap.reload();
	}
});
