/**
Creator:	杜金蓉
Desc:		代码表与值域映射
*/
var checkSearchbox=selboxRul;
var actionBtn='';
var boxName='';
var boxIniValue='';
var tableName='';
var configName='';
var tableName_config=tableName_config;
var configName_sel=configName_sel;

   var sm = new Ext.grid.CheckboxSelectionModel({
		handleMouseDown: Ext.emptyFn,
	    singleSelect : false,
		renderer:function(v,c,r){
                if(r.get("Type")=="%Library.CacheString")
                  {
						return '';//不显示checkbox
                   }else{
						return  '<div class="x-grid3-row-checker">&#160;</div>';
				   }},
		listeners:{
			'beforerowselect': 
				function( SelectionModel, rowIndex, keepExisting,record ) 
				{ 
				if(rowIndex==0){
					if(record.data.memberstatus!='1')
					{   //用户状态不正常 
					//	Ext.Msg.alert("提示信息","该行禁用，无法选择!"); 
						return false;  //不能进行选择 
					}
					else
					{ 
						return true;
					}
				}}
			}
			
    });

 var cm = new Ext.grid.ColumnModel([sm,
        {header:'名称', dataIndex:'name', width:70},
        {header:'类型', dataIndex:'Type'},
        {header:'数据库字段名', dataIndex:'DBName', width:40},
        {header:'是否必须', dataIndex:'Require', width:75},
        {header:'默认值', dataIndex:'IniValue',id:"colsIniValue", width:60,
			editor: new Ext.form.TextField({
				id:'textfieldmouse',
				allowBlank: true,
				//inputType:"radio",
					 maxLength:20,
				 listeners: {
				'mouseover': function() {
					}}
                })}, 
		{header:'描述', dataIndex:'Desc', width:60}
    ]);
var rowsCount=0;
function GetGridStore(){

	var ds=new Ext.data.JsonStore({
		url : '../CT.WS.web.DicDynamicConfigList.cls?tableName='+tableName_config+'&configName='+configName_sel,
		root: 'rows',
		totalProperty: "results",
		method: 'POST',
		async: true,
		fields: [
			{name:'name'},
			{name:'Type'},
			{name:'DBName'},
			{name:'Require'},
			{name:'IniValue'},
			{name:'Desc'}
		],
		listeners: {
			'load':function(){
				
			rowsCount=ds.reader.jsonData.results;
			rowNum(rowsCount);
			},
		'beforeload': function() {
		var a=parent.Ext.getCmp('morenzhi').getRawValue();
		ds.baseParams = {boxName:boxName,boxIniValue:boxIniValue,tableNamesave:tableName,configNamesave:configName,actionBtn:actionBtn,morenzhi:a};
			}
	}
});
return  ds;
}
store=GetGridStore();
store.load();
var selectRow;
var eprEpisodeGrid = new Ext.grid.EditorGridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store:store,
    cm: cm,
	clicksToEdit:1,
	height:360,
	boxMinHeight:200,
	sm:sm,        
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	 bbar: new Ext.PagingToolbar({
        id: "pagingToolbar",
        store: store,
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
		'click': function() {		
	}}
});

var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	items: [{ 
    	border: false,
		region: "center",
		layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid,
				bbar: [
					{ id: 'btnSelectAll',text: '全选',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/icon/selectall.gif',pressed: false 
					},
					'-',
					{id: 'btnSave',text: '保存', cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/icon/submission.gif',pressed: false
					},'-',
					{id: 'btnDelete',text: '删除', cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/btnClose.gif',pressed: false
					}
				//	,
				//	'-',
				//	{id: 'btnClose',text: '关闭',cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/btnClose.gif',pressed: false
					//}
					]
		}]
	}]
});


//加载页面是选择checkbox


	Ext.onReady(function(){  
	var rowsCount=store.getCount();
	if(rowsCount!=0){
     rowNum(rowsCount);
	}
   }); 

var gridPanel=Ext.getCmp('eprEpisodeGrid');

function rowNum(rowsCount){
	var rowsel=checkSearchbox.split(",");
	var rowNum='';
	var mycars=new Array();
	var k=0;
	for(i=0;i<rowsel.length;i++){
		for(j=0;j<rowsCount;j++){
			if(rowsel[i]==store.getAt(j).get('name')){
				mycars[k]=j;
				k++;
			}
		}
	}
	gridPanel.getSelectionModel().selectRows(mycars);
	 var iniValueRulrow=striniValueRul.split(",")
	for(j=0;j<iniValueRulrow.length;j++){
		var rowsName=iniValueRulrow[j].split("=")
		var rowsNameLeft=rowsName[0];
		var rowsNameRight=rowsName[1];
			for(i=0;i<rowsCount;i++){
				if(store.getAt(i).get('name')==rowsNameLeft){
					 store.getAt(i).set("IniValue",rowsNameRight);
				}
			}
		}
	
	

}
//删除按钮/////////////////////////////////////////////////////////////

	

	var btnDelete=Ext.getCmp('btnDelete');

	var tableName="";
	var actionBtn="";
	var deleteId=""
    btnDelete.on('click', function(){
		var smCTable =  new Ext.grid.CheckboxSelectionModel({
		singleSelect :false
		});

		//配置代码表名store
		var CTablestore = new Ext.data.JsonStore({
			autoLoad: false,
			url: '../CT.WS.web.DicDynamicTableList.cls',
			fields: ['ID','TableName','RowNum','Fields', 'ConfigName'],
			root: 'dataname',
			totalProperty: 'TotalCount',
			baseParams: { start: 0, limit:12},
			listeners: 
			{
				'beforeload': function() {
					CTablestore.baseParams = {tableName:tableName,actionBtn:actionBtn,deleteId:deleteId};
				}
			}
		});

		 var cmCTable = new Ext.grid.ColumnModel([smCTable,
        {header:'ID', dataIndex:'ID',hidden:true},
		{header:'TableName', dataIndex:'TableName',hidden:true},
		{header:'NO.', dataIndex:'RowNum', width:40},	
        {header:'表名', dataIndex:'ConfigName', width:200},
		{header:'表列项', dataIndex:'Fields', width:320}]);
		var CTableGrid = new  Ext.grid.GridPanel({
            title: '配置代码表',
			id:'CTableGrid',
            region: 'west',
            split: true,
			sm:smCTable,
            width:Ext.getBody().getWidth()*0.4+30,
			height:Ext.getBody().getHeight()*0.6+15,
			pageSize: 12,
			cm:cmCTable,
			store:CTablestore,
			cm:cmCTable,
            //collapsible: true,
            margins:'3 0 3 3',
            cmargins:'3 3 3 3',
			
			bbar: new Ext.PagingToolbar({
				id: "CTablesToolBar",
				store: CTablestore,
				displayInfo: true,
				pageSize: 12,
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
        });
        // tabs for the center
        var tabs = new Ext.TabPanel({
            region: 'center',
            margins:'3 3 3 0', 
            activeTab: 0,
            defaults:{autoScroll:true},
			items:[CTableGrid]
           
        });
		var navstore = new Ext.data.JsonStore({
		autoLoad: false,
		url: '../CT.WS.web.DicDynamicTableList.cls',
		fields: ['ID', 'RowNum','TableName'],
		root: 'datatable',
		totalProperty: 'TotalCount',
		baseParams: { start: 0, limit: 12},
		listeners: {
			'beforeload': function() {
			navstore.baseParams = {tableName:"",configName:"",actionBtn:'btnSearch'};
			}
		}
	});
		//var navstore=parent.getLocStore;
		//parent.Ext.getCmp("cbxTableName1").setRawValue('');
		navstore.load();
		
		 var cmnav = new Ext.grid.ColumnModel([
        {header:'ID', dataIndex:'ID',hidden:true},
		{header:'NO.', dataIndex:'RowNum', width:40},
        {header:'表名', dataIndex:'TableName', width:150}]);
        // Panel for the west
        var nav = new  Ext.grid.GridPanel({
            title: '表名',
            region: 'west',
            split: true,
            width: 200,
			pageSize: 12,
			store:navstore,
			cm:cmnav,
            collapsible: true,
            margins:'3 0 3 3',
            cmargins:'3 3 3 3',
			bbar: new Ext.PagingToolbar({
				id: "navpagingT",
				store: navstore,
				pageSize: 12,
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
				'rowclick': function() {
					var SelNavigation=nav.getSelectionModel().getSelections()  ;
					tableName=SelNavigation[0].data.TableName;
					actionBtn="selectbox";
					CTablestore.load();

			}}
			
        });
	
        var win = new Ext.Window({
			id:"windelete",
            title: '配置代码表的删除',
            closable:false,
            width:800,
            height:405,
            //border:false,
            plain:true,
            layout: 'border',

            items: [nav, tabs],
			bbar: [{xtype : "tbfill"},'-',					
					{align:'right',id: 'btnDeleteS',text: '删除', cls: 'x-btn-text-icon',icon: '../scripts/epr/Pics/btnClose.gif',pressed: false,handler:btnDeleteFunction}
					,'-','-',{align:'right',id: 'btnClose',text: '关闭窗口',handler:btnCloseFunction}
					]
        });
		Ext.getBody().mask(); 
		//parent.Ext.getBody().mask(); 
		win.show(this);
		parent.Ext.getCmp("sts").getEl().mask(); 
		var tableName="";
		function btnCloseFunction(){
		win.close();
		parent.Ext.getCmp("sts").getEl().unmask(); 
		Ext.getBody().unmask();
		}
		function btnDeleteFunction(){
		var SelNavigation=CTableGrid.getSelectionModel().getSelections()  ;
		if (SelNavigation==""||SelNavigation==null)
		{
			Ext.Msg.alert('[删除失败]','请选择您需要删除的[表名]或者[配置代码表名]');
			return;
		}
		tableName=SelNavigation[0].data.TableName;
		deleteId=SelNavigation[0].data.ID;
		actionBtn="btnDeleteS";
		


		CTablestore.reload({
		'callback': function(records, options, success){ 
			if (CTablestore.reader.jsonData.quits=='1')
			{
				Ext.Msg.alert('[删除失败]','该[配置代码表]的数据没有清除，请全部清除表格数据后再删除此表格');
				return;
			}
		} }	);
		CTablestore.removeAll() ;
		navstore.reload();
		actionBtn='';

		}
    });
	

	
/////////////////////////////////////////////////////////////////////////




//保存按钮事件
var btnSave=Ext.getCmp('btnSave');
btnSave.on('click',function(){
btnSave='btnSaves';
var selBox=0;
if (store.reader.jsonData.resultTable!='1')
{
	Ext.Msg.alert('[保存失败]','没有该数据库表名,请输入正确的表名再保存！！！');
	return;
}

if (parent.Ext.getCmp('morenzhi').getRawValue()=='')
{
	Ext.Msg.alert('[保存失败]','默认值不能为空，必须选择！！！');
	boxIniValue='';
	boxName='';
	return;

}
if(parent.getLocStore2.reader.jsonData.tableRow!=''){
if (parent.getLocStore2.reader.jsonData.tableRow!=parent.Ext.getCmp('morenzhi').getRawValue())
{
	Ext.Msg.alert('[保存失败]','该表"默认值"选项已经确认,只能为['+parent.getLocStore2.reader.jsonData.tableRow+']');
	return;
}}
var boxrows=gridPanel.getSelectionModel().getSelections();
var sellength=boxrows.length;
   for(i=0;i<sellength;i++){
		boxName=boxName+','+boxrows[i].data['name']
   }
	boxName=boxName.substring(1,boxName.length);
	for(i=0;i<sellength;i++){
		var rowName=boxrows[i].data['name'];
		if (rowName=='%Concurrency')
		{
          Ext.Msg.alert('[保存失败]', '不应选择[名称]为[%Concurrency]');
		  boxIniValue='';
		  boxName='';
		  return;
		}
		
		if(boxrows[i].data['IniValue']!=null&&boxrows[i].data['IniValue'].trim().length!=0){
			boxIniValue=boxIniValue+","+rowName+"='"+boxrows[i].data['IniValue'].trim()+"'";
			if(boxrows[i].data['Type']=="%Library.Date"){
				var a=boxrows[i].data['IniValue'].trim();
				var b=a.split("-");
				if((b.length==3)&&(b[0].length==4)&&(b[1].length==2)&&(b[2].length==2)&&(b[0]>1840&&b[0]<9999)&&(b[1]>=1&&b[1]<=12)&&(b[2]>=0&&b[2]<31)){
					
						boxIniValue=boxIniValue+","+rowName+"='"+boxrows[i].data['IniValue'].trim()+"'";
					
				}else{
					Ext.Msg.alert('[保存失败]', rowName+'行,日期型默认值为[YYYY-MM-DD],请重新输入默认值');
					boxIniValue='';
					boxName='';
					return;
				}
			}
			if(boxrows[i].data['Type']=="%Library.Time"){
				var a=boxrows[i].data['IniValue'].trim();
				var b=a.split(":");
				if((b.length==2)&&(b[0].length==2)&&(b[1].length==2)&&(b[0]>=0&&b[0]<=24)&&(b[1]>=0&&b[1]<=59)){
						boxIniValue=boxIniValue+","+rowName+"='"+boxrows[i].data['IniValue'].trim()+"'";
				}else{
					Ext.Msg.alert('[保存失败]', rowName+'行,时间型默认值为[HH:MM],,请重新输入默认值');
					boxIniValue='';
					boxName='';
					return;
				}
			}
		}
   }
	boxIniValue=boxIniValue.substring(1,boxIniValue.length);
	tableName=parent.tablesNameValue();
	configName=parent.configsNameValue();
	if(tableName==null||tableName.trim().length<1){
		Ext.Msg.alert('[保存失败]', '请输入您要保存的[表名]');
		boxIniValue='';
		boxName='';
	}else if(configName==null||configName.trim().length<1){
		Ext.Msg.alert('[保存失败]', '请输入您要保存的[配置代码表名]');
		boxIniValue='';
		boxName='';
	}else if(sellength==null||sellength==0){
		Ext.Msg.alert('[保存失败]', '请选择您要保存的[备选项]');
		boxIniValue='';
		boxName='';
	}else{
		tableName_config=tableName;
		configName_sel=configName;	
		var test123='';
		for(i=0;i<sellength;i++){
			var rowName=boxrows[i].data['name'];
			
			if(parent.Ext.getCmp('morenzhi').getRawValue()==rowName){
				test123='test123'
				
				var successSave=""
				if(boxrows[i].data['IniValue']!=null&&boxrows[i].data['IniValue'].trim().length!=0){
					store.reload();
					Ext.MessageBox.show({
					 msg: 'Saving your data, please wait...',
					 progressText: 'Saving...',
					 width:300,
					 wait:true,
					 waitConfig: {interval:200},
					 icon:'ext-mb-download', //custom class in msg-box.html
					  animEl: 'mb7'
					 });
					 setTimeout(function(){
					Ext.MessageBox.hide();
					if(store.reader.jsonData.defautvalue!=""){
					var deValue=store.reader.jsonData.defautvalue;
					var dev=deValue.split("^")
					if (dev[0]=='0'){
						alert("保存成功");
					}
					if(dev[0]=='1'){
						alert('保存失败!,在配置代码表['+dev[1]+']已经有[默认值]'+dev[2]+',若要改变数据值,请在此表中改变参数！');
					}	
					
					}
					parent.clickBtnSearch(patientID,tableName_config,configName_sel);

					}, 5000);

				
				}else{
					Ext.Msg.alert('[保存失败]','[默认值]输入值不应该为空');
					boxIniValue='';
					boxName='';
					return;
					}

			}
		}
		if(test123==''){
			Ext.Msg.alert('[保存失败]','[默认值]不正确,选择的默认值不在正确的属性范围类');
			boxIniValue='';
			boxName='';
			return;
		
		}
		
	}
});
//全选按钮事件
var btnSelectAll=Ext.getCmp('btnSelectAll');
btnSelectAll.on('click',function(){
	if(btnSelectAll.text=='全选'){
		gridPanel.getSelectionModel().selectAll();		
		btnSelectAll.setText('取消全选');
	}else if(btnSelectAll.text=='取消全选'){
		gridPanel.getSelectionModel().clearSelections();
		btnSelectAll.setText('全选');
	}
});