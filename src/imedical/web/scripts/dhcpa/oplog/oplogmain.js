


//配件数据源
var oplogTabUrl = '../csp/dhc.pa.oplogexe.csp';
var oplogTabProxy= new Ext.data.HttpProxy({url:oplogTabUrl + '?action=list'});
var oplogTabDs = new Ext.data.Store({
	proxy: oplogTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		
		'rowid',
		'opModuleName',
		'opMode',
		'opData',
		'opUser',
		'opTime',
		'opUserName'
	]),
    remoteSort: true
});
//去掉空格
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
//数据库数据模型
var oplogTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "rowid",
		dataIndex: 'rowid',
		width: 200,
		sortable: true,
		hidden:true
	},{
		header: "功能模块名称",
		dataIndex: 'opModuleName',
		width: 200,
		sortable: true,
		hidden:false
	},{
		id:"opData",
		header: "操作数据",
		dataIndex: 'opData',
		width: 300,
		sortable: true,
		menuDisabled:true,
		renderer:function(value,meta,record){
			if(value!=""){
				return '<div class="x-grid3-cell-inner x-grid3-col-linker" unselectable="on" ext:qtitle ext:qtip="'+value+'">'+value+'</div>'
			}
		}
	
	},{
		header: "操作人",
		dataIndex: 'opUserName',
		width: 100
	
	},{
		header: "操作方式",
		dataIndex: 'opMode',
		width: 80,
		align:'center',
		//sortable: true,
		renderer:function(v){
			var ret=v;
			if(v=="D"){
				ret="删除";
			}else{
				ret="编辑";
			}
			return ret;
		}
	
	},{
		header: "操作时间",
		dataIndex: 'opTime',
		width: 150,
		align:'right',
		sortable: true
	}
	
]);
/*
	///======================方案============
	var SchemeSearchDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});


SchemeSearchDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:oplogTabUrl+'?action=ListschemDr&userid='+userid,
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
	emptyText:'请选择方案...',
	name: 'SchemeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

SchemeSearchField.on("beforeselect",function(){
		var check=kpiComSearch.getValue();
		
      	if(check!=""){
			kpiComSearch.clearValue();
			
	    }
	});
SchemeSearchField.addListener('select',function(){
	kpiSearchDs.load({params:{start:0,limit:10,schemdr:SchemeSearchField.getValue()}});
});

//==================================================//




		var kpiSearchDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
	kpiSearchDs.on('beforeload', function(ds, o) {
			var schemDr=SchemeSearchField.getValue();
			if(schemDr!=""){
				ds.proxy=new Ext.data.HttpProxy({
					url:oplogTabUrl+'?action=ListKPI&schemdr='+schemDr+'&flag=all',
					method:'POST'});
					
			}else{
				ds.proxy = new Ext.data.HttpProxy({
								url : oplogTabUrl+'?action=ListKPIAll',
									
							method : 'POST'
						});
				}
		});
var kpiComSearch = new Ext.form.ComboBox({
	id: 'kpiComSearch',
	fieldLabel: '指标名称',
	width:200,
	listWidth : 200,
	resizable:true,
	allowBlank: false,
	store: kpiSearchDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '请选择指标...',
	//name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
*/
//==================================================//
	//分页
	var page = new Ext.PagingToolbar({
		pageSize:25,
		store:oplogTabDs,
		displayInfo:true,
		displayMsg:'从{0}到{1}条，共{2}条',
		emptyMsg:'没有数据'
	});
	
	var moduleNameField = new Ext.form.TextField({
		id: 'modeNameField',
		fieldLabel: '模块名称',
		width:150,
		triggerAction: 'all',
		emptyText:'',
		name: 'modeNameField',
		//value:(new Date()).getFullYear(),
		editable:true
	});
	var startTimeField = new Ext.form.DateField({  
        fieldLabel : '起始时间',  
        name : 'startTime',  
        id : 'startTimeId',  
        enableKeyEvents : true,  
        width : 120,  
       // format : 'Y-m-d',  
        value:new Date().add(Date.DAY, -7),  
        emptyText : '起始时间'  
    }); 
		var endTimeField = new Ext.form.DateField({  
        fieldLabel : '结束时间',  
        name : 'endTime',  
        id : 'endTimeId',  
        enableKeyEvents : true,  
        width : 120,  
       // format : 'Y-m-d',  
		value:new Date(),  
        emptyText : '结束时间' 
    })  

	
	
	
	//查询按钮
	var searchBtn = new Ext.Toolbar.Button({
		text:'查询',
		width:30,
		iconCls: 'find',
		
		handler:function(){

			oplogTabDs.load({params:{start:0, limit:page.pageSize,moduleName:moduleNameField.getValue(),
									 startTime:Ext.util.Format.date(startTimeField.getValue(),'Y-m-d'),
									 endTime:Ext.util.Format.date(new Date((endTimeField.getValue()/1000+86400)*1000),'Y-m-d')}});//查后一天
		}
	});
	
	
var itemGrid=new Ext.grid.GridPanel({
	title:"操作日志查询",
	region: 'center',
	layout:'fit',
	cm:oplogTabCm,
	store:oplogTabDs,
	autoExpandColumn:"opData",
	bbar:page,
	tbar:["模板名称：",moduleNameField,"-","操作时间:",startTimeField,"—",endTimeField,searchBtn]
	
});
   
    oplogTabDs.load({params:{start:0, limit:page.pageSize}});

