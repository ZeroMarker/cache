 /**
 Creator:	杜金蓉
 Desc:		自定义字典维护
 */
 //定义全局所需数据
 var actionbtn=''
 var pagesize=30;
 //列名
 var cm = new Ext.grid.ColumnModel([
        {header:'代码', dataIndex:'Code', width:70},
        {header:'名称', dataIndex:'Name'},
        {header:'描述', dataIndex:'Description', width:40},
        {header:'对应表名', dataIndex:'TableName', width:75},
        {header:'别名列', dataIndex:'DicAliasCol', width:60},
		{header:'代码列', dataIndex:'DicCodeCol', width:60},
		{header:'描述列', dataIndex:'DicDescCol', width:60},
		{header:'默认查询条件代码', dataIndex:'ConditionCode', width:60},
		{header:'默认查询条件内容', dataIndex:'Condition', width:60},
		{header:'ID号', dataIndex:'ID', width:60},
		{header:'顺序号', dataIndex:'IDs', width:60},
		{header:'系统编码', dataIndex:'SystemCode', width:60}
    ]);

function GetGridStore(){

	var ds=new Ext.data.JsonStore({
		proxy: new Ext.data.HttpProxy({url:'../CT.WS.web.DicCustomMaintainQuery.cls'}),
		root: 'rows',
		totalProperty: "results",
		method: 'POST',
		baseParams: { start: 0, limit: pagesize},
		fields: [
			{name:'Code'},
			{name:'Name'},
			{name:'Description'},
			{name:'TableName'},
			{name:'DicAliasCol'},
			{name:'DicCodeCol'},
			{name:'DicDescCol'},
			{name:'ConditionCode'},
			{name:'Condition'},
			{name:'ID'},
			{name:'IDs'},
			{name:'SystemCode'}
		],
		listeners: {
			'beforeload':  function(store,options)  {
				//每次加载后重新获取数据
				var new_params={actionbtn: actionbtn, dataName:getpramsData()}; 
				Ext.apply(options.params,new_params); 
			}
		}
	});
	return  ds;
}
//加载store
store=GetGridStore();
store.load();
//建立装store的gridpanel
var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store:store,
	stripeRows:true,
    cm: cm,
	height:460,
	sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	//分页的bbar
	 bbar: new Ext.PagingToolbar({
        id: "pagingToolbar",
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
    }),
	listeners: {
		//点击某一行时执行函数gettableData()
		'click': function() {		
			gettableData();	
	}}
});
		
//建立一个panel
var paneltextField='';
//获取列数
var gridheadlength=cm.getColumnCount();
var paneltextField = new Ext.Panel({
	id:'paneltextField',
	autowidth:true,
	bodyStyle:'color:red;height:200', 
	frame:true,
	layout:'hbox', 
	border:false,
	autoScroll:true,
	html:''
});
//根据列数获取某一个panel的长度
var panelWidth=document.body.clientWidth/gridheadlength;
//根据列数建立动态的panel
for(i=0;i<gridheadlength;i++){
	var paneltextFieldchildren="paneltextFieldchild"+i;
	var paneltextFieldchildren=new Ext.Panel({
		id:"child_gridrowsdata"+i,
		layout: {
			type: 'vbox',  
			padding:'0', 
			align:'left' 
		}, 
		height:50,
		autoScroll:true,
		flex: 1,
		width:panelWidth,
		items:[{
			//获取动态的标签
			id:paneltextFieldchildren+'label',
			xtype: 'label',
			text: '['+cm.getColumnHeader(i)+']',
			flex:1,
			width:panelWidth,
			name: "labelname"+i,
			fieldLabel: "fieldLabel"+i,
			anchor: '-1'
			}, {
			//获取动态的输入框textfield
			id:paneltextFieldchildren+'textfield',
			flex      :1,
			width:panelWidth,
			xtype     : 'textfield',
			name      : "textfield"+i,
			fieldLabel: 'fieldLabel'+i,
			anchor    : '-1'
			}]
		});
	//添加子panel
	paneltextField.add(paneltextFieldchildren);
	paneltextField.doLayout();
	}
//页面显示
var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	items: [
	{ 
			border: false,
			id: 'patextField',
			region: "south",
			layout: "fit",
			margins:'0 0 0 0',
			height:100,
			items:[{
				layout: false,
				id: 'paneltextFieldlist',
				items:paneltextField,
				bbar: [
				{ 
					id: 'btnInsertData',text: '新增',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/new.gif',pressed: false 
				},
				'-',
				{
					id: 'btnUpdateData',text: '修改', cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/eprwrite.gif',pressed: false
				},
				'-',
				{
					id: 'btnDelete',text: '删除',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/btnClose.gif',pressed: false
				}]
				}]
	},
	{ 
		title: "自定义字典维护",
    	border: false,
		region: "center",
		layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
	}]

	}]
});
//获取加载页面是所需参数，对应的输入框以及输入内容
function getpramsData(){
	var baseParamsString='';
	for(i=0;i<gridheadlength;i++){
	var dataNames='dataName'+i;
	var txtValueTexts='txtValueText'+i
	var dataNames=cm.getDataIndex(i)+'';
	var txtValueTexts= Ext.getCmp('paneltextFieldchild'+i+'textfield').getValue();
	baseParamsString=baseParamsString+dataNames+"|-:-|"+txtValueTexts+"^^^"
	}
	var baseParamsStrings=baseParamsString.substring(0,baseParamsString.length-3);
	return baseParamsStrings;
}
//根据点击行将下面的输入框一一赋值
function gettableData(){
	for(i=0;i<gridheadlength;i++){
		if(grid.getSelectionModel().getSelected()!=null){
			Ext.getCmp('paneltextFieldchild'+i+'textfield').setValue(grid.getSelectionModel().getSelected().data[cm.getDataIndex(i)+'']);
		}
		 
	}
}
var grid=Ext.getCmp('eprEpisodeGrid');
//新增数据
var btnInsertData= Ext.getCmp('btnInsertData'); 
btnInsertData.on('click',function(){
	actionbtn='btnInsertData';
	var textValues='';
	for(i=0;i<gridheadlength;i++){
		textValues=textValues+Ext.getCmp('paneltextFieldchild'+i+'textfield').getValue();
	}
	if(textValues==null||textValues.trim().length==0){
		Ext.Msg.alert('操作提示', '请填写需要增加的内容');
	}else{
		store.reload();
		actionbtn='';
	}
	for(i=0;i<gridheadlength;i++){
			Ext.getCmp('paneltextFieldchild'+i+'textfield').setValue('');
	}
});
//修改数据
var btnUpdateData= Ext.getCmp('btnUpdateData'); 
btnUpdateData.on('click',function(){

actionbtn='updateidbtn';
document.getElementById('actionbtns').name=actionbtn;

if(grid.getSelectionModel().getSelected()==null){
	Ext.Msg.alert('选择错误', '请选择您需要[修改]的行');
}else{
	store.reload();

	actionbtn='';
	}
});


var btnDeleteData= Ext.getCmp('btnDelete'); 
btnDeleteData.on('click',function(){
	actionbtn='deleteidbtn';
		if(grid.getSelectionModel().getSelected()==null){
			Ext.Msg.alert('选择错误', '请选择您需要[删除]的行');
		}else{
			store.reload();
			actionbtn='';
		}
});
//使顺序号对应的textfield变灰，不可编辑
if(Ext.getCmp('paneltextFieldchild'+(gridheadlength-2)+'textfield')!=null){
	var textfieldId=Ext.getCmp('paneltextFieldchild'+(gridheadlength-2)+'textfield');
	var textfieldId1=Ext.getCmp('paneltextFieldchild'+(gridheadlength-3)+'textfield');
		textfieldId.setDisabled (true);
		textfieldId.setReadOnly (true);
		textfieldId1.setDisabled (true);
		textfieldId1.setReadOnly (true);

	}	
//使系统编码对应的textfield添加默认值
if(Ext.getCmp('paneltextFieldchild'+(gridheadlength-1)+'textfield')!=null){
	var textfieldId=Ext.getCmp('paneltextFieldchild'+(gridheadlength-1)+'textfield');
		textfieldId.setValue("dhcc");

	}