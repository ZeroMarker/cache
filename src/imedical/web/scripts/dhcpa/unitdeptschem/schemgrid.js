var schemUrl = '../csp/dhc.pa.unitdeptschemexe.csp';
var schemProxy = new Ext.data.HttpProxy({url:schemUrl + '?action=schemlist'});


var data="";
var data1=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
var data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
var data3=[['1','1~6上半年'],['2','7~12下半年']];
var data4=[['0','00']];

var periodTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
});

/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return "0"+parseInt(d);

}*/

var yearField= new Ext.form.TextField({
                id:'yearField',
                value:(new Date()).getFullYear(),
                width: 80,
                triggerAction: 'all',
                allowBlank: true,
                fieldLabel: '年度',
                emptyText: '',
                name: 'yearField',
                allowBlank: false ,
                regex:/^\d{4}$/,
                regexText:"只能输入数字年份",
                editable:true,
                minChars: 1,
				pageSize: 10
            });

var periodTypeField = new Ext.form.ComboBox({
	id: 'periodTypeField',
	fieldLabel: '期间类型',
	width:80,
	listWidth : 80,
	selectOnFocus: true,
	allowBlank: false,
	store: periodTypeStore,
	anchor: '90%',
	value:'Q', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

periodTypeField.on("select",function(cmb,rec,id){
	var pattern=/^\d{4}$/;
				
	if(cmb.getValue()=="M"){data=data1;}
	if(cmb.getValue()=="Q"){data=data2;}
	if(cmb.getValue()=="H"){data=data3;}
	if(cmb.getValue()=="Y"){data=data4;}
	periodStore.loadData(data);
	searchFun(cmb.getValue());
});



//期间类别与方案查询的二级联动控制
function searchFun(periodType){
	periodField.setValue("");
	periodField.setRawValue("");
	/* if(getCookie(periodTypeCookieName)==periodType){
		setComboActValueFromClientOfChange(periodField,periodCookieName);
	} */
};


periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
/*var getFullPeriodType = function (date) {
  var d = date.getMonth();
  d=d/3+1;
  return parseInt(d);

}*/

periodStore = new Ext.data.SimpleStore({
	fields:['key','keyValue']
});
periodStore.loadData([['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']]);
var periodField = new Ext.form.ComboBox({
	id: 'periodField',
	fieldLabel: '',
	//value:getFullPeriodType(new Date()),
	width:100,
	listWidth : 100,
	selectOnFocus: true,
	store: periodStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'请选择...',
	mode: 'local', //本地模式
	editable:false,
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
				
				var pattern=/^\d{4}$/;
				
				
				year=yearField.getValue();
				if(
				!pattern.test(year)){
					Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return null;}
				
				schemDs.load({params:{start:0, limit:schemPagingToolbar.pageSize,period:Ext.getCmp('periodTypeField').getValue(),dir:'asc',sort:'rowid'}});
			
			
			
			}
			
		})
//业务类别数据源
var schemDs = new Ext.data.Store({
	proxy: schemProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'frequency'
	]),
	remoteSort: true
});

schemDs.setDefaultSort('rowid', 'desc');

var schemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '自查代码',
		dataIndex: 'code',
		width: 100,
		sortable: true
	},{
		header: "自查名称",
		dataIndex: 'name',
		width: 180,
		align: 'left',
		sortable: true
	}
]);

//自查初始化按钮
var InitButton = new Ext.Toolbar.Button({
	text: '自查初始化',
    tooltip:'自查初始化',        
    iconCls:'add',
	handler:function(){
		var year= yearField.getRawValue();
		var period= periodTypeField.getValue();
		var perioditem= periodField.getValue();
		if((year=="")||(period=="")){
			Ext.Msg.show({title:'注意',msg:'请填写年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  	return false;			
		}
		else{
			Ext.Ajax.request({
			url: 'dhc.pa.unitdeptschemexe.csp?action=init&year='+year+'&period='+period+'&perioditem='+perioditem,
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Ext.Msg.show({title:'注意',msg:'初始化成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info=='DSCNodata') message='自查定义无数据!';
					if(jsonData.info=='UDSNodata') message='请确保每个自查定义对应都有自查科室,然后重试!';
					if(jsonData.info=='DSDNodata') message='请返回到自查定义-管理页面,确保每个自查定义对应都有自查明细,然后重试!';
                    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
			});		
		}
	}
});

var schemPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: schemDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['period']=Ext.getCmp('periodTypeField').getValue();
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({//表格
	title: '自查定义',
	region: 'west',
	width: 550,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: schemDs,
	cm: schemCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['年度:',yearField,'-','期间类型:',periodTypeField,'-','期间:',periodField,'-',findButton,'-',InitButton],
	bbar: schemPagingToolbar
});

var schemRowId = "";
var schemName = "";

SchemGrid.on('rowclick',function(grid,rowIndex,e){
	//单击绩效方案后刷新绩效单元
	var selectedRow = schemDs.data.items[rowIndex];

	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["name"];
	jxUnitGrid.setTitle(schemName+"-科室设置");
	jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&schemDr='+schemRowId+'&sort=rowid&dir=DESC'});
	jxUnitDs.load({params:{start:0, limit:jxUnitPagingToolbar.pageSize}});
});

schemDs.on("beforeload",function(ds){
	jxUnitDs.removeAll();
	schemRowId = "";
	jxUnitGrid.setTitle("科室信息");
});
	