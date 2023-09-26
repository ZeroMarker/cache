/**
Creator:	�Ž���
Desc:		�������ֵ��ӳ��
*/
  
var pagesize=100; 
var nodeCode='';
var nodeRight='';
var actionsBtn='';
var nodeidrightcode='';

//����lefttree��store--------------------------------------------------
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
	{header:'ֵ', dataIndex:'DEVID'},
	{header:'����', dataIndex:'Meaning'}
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



//righttree�ұ�����store---------------------------------------------------
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
        {header:'ֵ', dataIndex:'CtmDictCode'},
        {header:'����', dataIndex:'CtmDictDesc'}
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



//ӳ��stroe----------------------------------------------------------
//�м�ӳ���store
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
        {header:'�Զ����ֵ����ݴ���', dataIndex:'DEVID'},
        {header:'�Զ����ֵ���������', dataIndex:'Meaning'},
		{header:'��׼ֵ�����ݴ���', dataIndex:'CtmDictCode'},
		{header:'��׼ֵ��������ֵ����', dataIndex:'CtmDictDesc'}
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



//��ҳ����ʾ
var eprPortal = new Ext.Viewport({
    id: 'eprPortal123',
	title:'�Զ��ֵ��������׼ֵ����������ӳ��',
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
			title:'�Զ����ֵ�����������Ԫֵ������ӳ��',
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
					text: 'ӳ��',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/����ʷ.gif',	
					pressed: false
				}],
				items:[{
					id:'datamapcustom_west',
					region: 'west',
					title: '�Զ����ֵ�����',
					split: true,
					collapsible: false,
					width: '50%',
					items:[eprEpisodeGrid],
					 bbar: new Ext.PagingToolbar({
						id: "datamapcustom_westToolbar",
						store: store,
						pageSize: pagesize,
						displayInfo: true,
						displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
						beforePageText: 'ҳ��',
						afterPageText: '��ҳ�� {0}',
						firstText: '��ҳ',
						prevText: '��һҳ',
						nextText: '��һҳ',
						lastText: 'ĩҳ',
						refreshText: 'ˢ��',
						emptyMsg: "û�м�¼"
						 })
					},{
					id:'datamapcustom_center',
					region: 'center',
					title: '��׼ֵ����������',
					split: true,
					width: '50%',
					collapsible: false,
					items:[eprEpisodeGridright],
					 bbar: new Ext.PagingToolbar({
						id: "datamapcustom_rightToolbar",
						store: storeright,
						pageSize: pagesize,
						displayInfo: true,
						displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
						beforePageText: 'ҳ��',
						afterPageText: '��ҳ�� {0}',
						firstText: '��ҳ',
						prevText: '��һҳ',
						nextText: '��һҳ',
						lastText: 'ĩҳ',
						refreshText: 'ˢ��',
						emptyMsg: "û�м�¼"
						 })
					}]
				},{
				region: 'south',
				title: 'ֵ��ӳ��',
				split: true,
				collapsible: false,
				height: Ext.getBody().getHeight()*0.36,
				items:[eprEpisodeGridmap],
				bbar:[{xtype : "tbfill"},'-',{
					align:'right',
					id: 'btnDelete',
					text: 'ɾ��',
					cls: 'x-btn-text-icon',
					icon: '../scripts/epr/Pics/btnClose.gif',
					pressed: false
				}]
				
				}]
        },{
			id:'dicdataMaptreeleftid',
            region: 'west',
            collapsible: false,
            title: '�Զ����ֵ�',
            split: true,
            width: '20%',
            minWidth: 100,
            minHeight: 140,
           html: '<iframe id="dicdataMaptreeleft" name="dicdataMaptreeleft" style="width:100%; height:100%" src="CT.WS.dicdataMaptreeleft.csp"></frame>'
        },{
            region: 'east',
            collapsible: false,
            title: '��������Ԫֵ������',
            split: true,
            width: '20%',
            minWidth: 100,
            minHeight:'100%',
            html: '<iframe id="dicdataMaptreeright" name="dicdataMaptreeright" style="width:100%; height:100%" src="CT.WS.dicdataMaptreeright.csp"></frame>'
        }]
});


//ӳ�䰴ť�¼�
var btndataMap= Ext.getCmp('btndataMap'); 
btndataMap.on('click',function(){
	actionsBtn='btndataMap';
	var leftdata = Ext.getCmp('eprEpisodeGrid').getSelectionModel().getSelections();
	var rightdata = Ext.getCmp('eprEpisodeGridright').getSelectionModel().getSelections();
	if(leftdata.length==0){
		Ext.Msg.alert('������ʾ', '��ѡ��[�Զ����ֵ�����]');
	}
	else if(rightdata.length==0){
		Ext.Msg.alert('������ʾ', '��ѡ��һ��[��׼ֵ����������]');
	}
	else if(rightdata.length>1){
		Ext.Msg.alert('������ʾ', '[��׼ֵ����������]ֻ��ѡ��һ��');
	}else{
		storemap.reload();
	}
});	


//ѡ�����checkbox�¼�
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


//ѡ���ұ�checkbox�¼�
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



//ѡ��ɾ��checkbox�¼�
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

//ɾ����ť�¼�
var btnDelete= Ext.getCmp('btnDelete'); 
btnDelete.on('click',function(){
	actionsBtn='btnDelete';
	gettablemapData();
	if(isNum==0){
		Ext.Msg.alert('������ʾ', '��ѡ����Ҫ[ɾ��]��[ֵ��ӳ��]');
	}else{
	storemap.reload();
	}
});
