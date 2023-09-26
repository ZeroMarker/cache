


//配件数据源
var CheckCoefficientTabUrl = '../csp/dhc.qm.CheckCoefficientexe.csp';
var CheckCoefficientTabProxy= new Ext.data.HttpProxy({url:CheckCoefficientTabUrl + '?action=list'});
var CheckCoefficientTabDs = new Ext.data.Store({
	proxy: CheckCoefficientTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'schemName',
		'schemDr',
		'checkName',
		'checkDr',
		'coefficient',
		'formula',
		'formulaCode'
		
	]),
    // turn on remote sorting
    remoteSort: true
});
//去掉空格
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
//数据库数据模型
var CheckCoefficientTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "检查项目",
		dataIndex: 'schemName',
		width: 200,
		sortable: true,
		menuDisabled:true
	},{
		header: "schemDr",
		dataIndex: 'schemDr',
		width: 50,
		sortable: true,
		hidden:true
	},{
		header: "检查点名称",
		dataIndex: 'checkName',
		width: 200,
		sortable: true,
		menuDisabled:true
	},{
		header: "checkDr",
		dataIndex: 'checkDr',
		width: 50,
		sortable: true,
		hidden:true
	},{
		header: "表达式",
		dataIndex: 'formula',
		width: 100,
		sortable: true,
		menuDisabled:true
	},{
		header: "formulaCode",
		dataIndex: 'formulaCode',
		width: 100,
		sortable: true,
		hidden:true
	},{
		header: "特殊值",
		dataIndex: 'coefficient',
		width: 200,
		sortable: true,
		menuDisabled:true
	},
	{
		header: "rowid",
		dataIndex: 'rowid',
		id:'rowid',
		width: 50,
		sortable: true,
		hidden:true
	}
	
]);
//========================检查点=========================//
//检查点combox
/*
	var checkDsSearch = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},[
		'rowid','code','name'
		])
	});

	checkDsSearch.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:CheckCoefficientTabUrl+'?action=listcheckname&str='+checkComSearch.getValue(),method:'POST'})
	//TODO:模糊查询未处理
	//console.log(Ext.getCmp('checkField').getRawValue());
	});
	
	var checkComSearch = new Ext.form.ComboBox({
		
		fieldLabel: '检查点',
		width:230,
		height:100,
		listWidth :230,
        allowBlank: false,
		store: checkDsSearch,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择检查点...',
		
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		
		resizable:true
	}); 
	
	*/
	
		var checkSearchDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
	checkSearchDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
					
							url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
								+'?action=ListCheck&str='
								+ encodeURIComponent(Ext.getCmp('checkComSearch').getRawValue())+'&schemdr='+encodeURIComponent(Ext.getCmp('SchemeSearchField').getValue()),
						method : 'POST'
					});
		});
var checkComSearch = new Ext.form.ComboBox({
	id: 'checkComSearch',
	fieldLabel: '检查点',
	width:200,
	listWidth : 200,
	resizable:true,
	allowBlank: false,
	store: checkSearchDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '请选择检查点...',
	//name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
	///======================方案============
	var SchemeSearchDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


SchemeSearchDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:CheckCoefficientTabUrl+'?action=ListschemDr&str='+encodeURIComponent(Ext.getCmp('SchemeSearchField').getRawValue())+'&userid='+userid,
	method:'POST'});
});

var SchemeSearchField = new Ext.form.ComboBox({
	id: 'SchemeSearchField',
	fieldLabel: '检查项目',
	width:220,
	listWidth : 220,
	resizable:true,
	//allowBlank: true,
	store:SchemeSearchDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择检查项目...',
	name: 'SchemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

SchemeSearchField.on("beforeselect",function(){
		var check=checkComSearch.getValue();
		
      	if(check!=""){
			checkComSearch.clearValue();
			
	    }
	});
SchemeSearchField.addListener('select',function(){
	checkSearchDs.load({params:{start:0,limit:10,schemdr:SchemeSearchField.getValue()}});
});

//==================================================//
	//分页
	var page = new Ext.PagingToolbar({
		pageSize:20,
		store:CheckCoefficientTabDs,
		displayInfo:true,
		displayMsg:'从{0}到{1}条，共{2}条',
		emptyMsg:'没有数据'
	});
	//查询按钮
	var searchBtn = new Ext.Toolbar.Button({
		text:'查询',
		width:30,
		iconCls: 'option',
		handler:function(){

			CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize,checkDr:checkComSearch.getValue(),schemdr:SchemeSearchField.getValue()}});
				}
	});
	//新增按钮
	var addBtn = new Ext.Toolbar.Button({
		text:'增加',
		width:30,
		iconCls: 'add',
		handler:function(){
				addFun();
		}
	});
	//修改按钮
	var editBtn = new Ext.Toolbar.Button({
		text:'修改',
		width:30,
		iconCls: 'option',
		handler:function(){
			
			editFun(itemGrid);
				}
	});
	//删除按钮
	var deleteBtn = new Ext.Toolbar.Button({
		text:'删除',
		width:30,
		iconCls: 'remove',
		handler:function(btn,even){
			//获得rowid
			var rowid = itemGrid.getSelectionModel().selections.items[0].data.rowid;
			Ext.Ajax.request({
				url:CheckCoefficientTabUrl+'?action=del&rowid='+rowid,
				success:function(result,request){

					var jsonData = Ext.util.JSON.decode( result.responseText );
											console.log(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'删除成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});
					}else{
						
						Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						
					}
				},
				failure:function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				scope: this
			});
		}
	});
	
var itemGrid=new Ext.grid.GridPanel({
	title:"检查点特殊值维护",
	region: 'center',
	layout:'fit',
	cm:CheckCoefficientTabCm,
	store:CheckCoefficientTabDs,
	
	bbar:page,
	tbar:[addBtn,"-",editBtn,"-",deleteBtn,"-",SchemeSearchField,"-",checkComSearch,"-",searchBtn]
	
});
   
    CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});

