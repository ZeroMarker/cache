var vouchDatasUrl = 'dhc.ca.vouchdatasexe.csp';
var vouchDatasProxy = new Ext.data.HttpProxy({url: vouchDatasUrl + '?action=list'});
var monthDr="";
var unitDeptsUrl = 'dhc.ca.unitdeptsexe.csp';
var unitsUrl = 'dhc.ca.unitsexe.csp';
var user=session['GROUPDESC']


function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};
var vouchDatasDs = new Ext.data.Store({
		proxy: vouchDatasProxy,
		
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
		
        }, 
		[
            'rowid',
			'intervalDr',
			'intervalName',
			'deptDr',
			'tDeptName',
			'unitDr',
			'unitName',
			'unitTypeDr',
			'unitTypeName',
			'itemDr',
			'itemName',
			'inType',
			'personDr',
			'personName',
			'remark',
			'dealFlag',
			'month',
			'num',
			{name:'nDate',type:'date',dateFormat:'Y-m-d'},
			'abstract',
			'deptCode',
			'deptName',
			'subjCode',
			'subjName',
			'debit',
			'loans'
		]),
    // turn on remote sorting
    remoteSort: true
});

vouchDatasDs.setDefaultSort('rowid', 'desc');

var vouchDatasCm = new Ext.grid.ColumnModel([
	new Ext.grid.CheckboxSelectionModel(),
		
		{
		header: '成本部门',
		dataIndex: 'tDeptName',
		width: 100,
		align: 'left',
		 renderer:color,
		sortable: true
    },
	{
		header: '成本项目',
		dataIndex: 'itemName',
		width: 100,
		align: 'left',
	    renderer:color,
		sortable: true
    },
	{
        header: '录入类型',
        dataIndex: 'inType',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '部门代码',
        dataIndex: 'deptCode',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '部门名称',
        dataIndex: 'deptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '科目代码',
        dataIndex: 'subjCode',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '科目名称',
        dataIndex: 'subjName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '借方',
        dataIndex: 'debit',
        width: 80,
		align: 'right',
		renderer: formatNum,
        sortable: true
    },
	{
        header: '贷方',
        dataIndex: 'loans',
        width: 80,
        align: 'right',
		renderer: formatNum,
        sortable: true
    },
	{
        header: '备注',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '采集人',
        dataIndex: 'personName',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '编辑日期',
        dataIndex: 'nDate',
        width: 80,
		renderer:formatDate,
        align: 'left',
        sortable: true
    },
	{
        header: '处理标志',
        dataIndex: 'dealFlag',
        width: 60,
        align: 'left',
        sortable: true
    }
	
	
]);
var monthsDs = new Ext.data.Store({
	proxy: "",    
	
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
});
var months = new Ext.form.ComboBox({
	id: 'months',
	fieldLabel: '核算区间',
	//anchor: '60%',
	width:100,
	listWidth : 240,
	allowBlank: false,
	store: monthsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'选择核算区间...',
	pageSize: 12,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
monthsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=months&query='+Ext.getCmp('months').getRawValue(),method:'GET'});
});	
months.on("select",function(cmb,rec,id ){
	monthDr=cmb.getValue();
     
	vouchDatasDs.load({params:{start:vouchDatasPagingToolbar.cursor, limit:vouchDatasPagingToolbar.pageSize, monthDr:monthDr,remark:unitRowid}});
});


var unitTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});

unitTypeDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=listunittypes&searchField=shortcut&searchValue='+Ext.getCmp('unitTypeSelecter').getRawValue(), method:'GET'});
	}
);

var unitTypeSelecter = new Ext.form.ComboBox({
			 id:'unitTypeSelecter',
			  fieldLabel:'名称',
			  store: unitTypeDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择单位类别...',
	          allowBlank: false,
			  name:'unitTypeSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});


var unitTypeRowid = "";


var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])	
});
var unitTypeDr="";

var unitRowid = "";

unitTypeSelecter.on(
	"select",
	function(cmb,rec,id ){
	
		unitSelecter.setRawValue('');
		unitSelecter.setValue('');
		unitRowid = "";	
		unitTypeDr = cmb.getValue();
	}
);

unitDs.on(
	'beforeload',
	function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url: unitDeptsUrl + '?action=listunits&searchField=shortcut&unitTypeDr='+unitTypeDr+'&searchValue='+Ext.getCmp('unitSelecter').getRawValue()});
	}
);



var unitSelecter = new Ext.form.ComboBox({
			id:'unitSelecter',
			  fieldLabel:'名称',
			  store: unitDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择单位...',
	          allowBlank: false,
			  name:'unitSelecter',
			  selectOnFocus: true,
			  forceSelection: true 
});

unitSelecter.on(
	"select",
	function(cmb,rec,id ){
	    unitRowid=cmb.getValue();
		
	}
);



var addDataTypesButton ={
		text: '添加',
		tooltip: '添加新的凭证数据表',        
		iconCls: 'add',
		handler: function(){
			
			addFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}
};

var editDataTypesButton  ={
		text: '修改',        
		tooltip: '修改选定的凭证数据表',
		iconCls: 'remove',
		handler: function(){editFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}
};

var delDataTypesButton  ={
		text: '删除',        
		tooltip: '删除选定的凭证数据表',
		iconCls: 'remove',
		disabled: user="成本核算会计"?false:true,
		 //hidden : user="demo"?false:true,
		handler: function(){delFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}
};

var opMenu2 = new Ext.menu.Menu({
    id: 'opMenu2',
    //items: [addDataTypesButton,editDataTypesButton, delDataTypesButton]
    items: [addDataTypesButton, delDataTypesButton]
});
var operation = new Ext.Toolbar([{
	
    text: '基本操作',
    iconCls: 'add',
    //disabled:rightDr=1?true:false,
    menu: opMenu2
}]);

var refreshButton  = new Ext.Toolbar.Button({
		text: '执行数据对照',        
		tooltip: '科室和项目对照',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){refreshFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}
});


var importButton = {
    text: 'EXCEL导入',
    tooltip: '导入数据',
    iconCls: 'remove',
    handler: function() { loadVouchData(vouchDatasDs) }
};

var importButtonPM ={
 text:'门诊药品成本采集',
 tooltip:'导入药品成本数据',
 disabled: true,
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"PM");}
};

var importButtonPZ ={
 text:'住院药品成本采集',
 tooltip:'导入药品成本数据',
 disabled: true,
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"PZ");}
};

var importButtonM ={
 text:'物流部物资出库',
 tooltip:'导入物资出库数据',
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"M");}
};


var importButtonZ ={
 text:'折旧数据采集',
 tooltip:'导入折旧数据',
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"Z");}
};


var opMenu = new Ext.menu.Menu({
    id: 'opMenu',
    items: [importButton,importButtonPM,importButtonPZ,importButtonM,importButtonZ]
});
var opTool = new Ext.Toolbar([{
    text: '成本数据采集',
    iconCls: 'add',
    menu: opMenu
}]);

var FindButton = new Ext.Toolbar.Button({
    text: '统计查询',
    tooltip: '统计查询',
    iconCls: 'remove',
    handler: function() { CommFindFun() }
});


var vouchDatasSearchField = 'itemName';

var vouchDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '成本部门',value: 'tDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '成本项目',value: 'itemName',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '录入类型',value: 'inType',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '录入人',value: 'personName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '凭证号',value: 'num',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '摘要',value: 'abstract',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)部门代码',value: 'deptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)部门名称',value: 'deptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)科目代码',value: 'subjCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)科目名称',value: 'subjName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '借方',value: 'debit',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '贷方',value: 'loans',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '日期',value: 'date',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				vouchDatasSearchField = item.value;
				vouchDatasFilterItem.setText(item.text + ':');
		}
};

var vouchDatasSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
				specialkey: {fn:function(field, e) {
				var key = e.getKey();
	      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
	    	},
		grid: this,
		onTrigger1Click: function() {
				if(this.getValue()) {
					this.setValue('');    
					vouchDatasDs.proxy = new Ext.data.HttpProxy({url: vouchDatasUrl + '?action=list'});
					vouchDatasDs.load({params:{start:0, limit:vouchDatasPagingToolbar.pageSize, monthDr:monthDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
				vouchDatasDs.proxy = new Ext.data.HttpProxy({
				url: vouchDatasUrl + '?action=list&searchField=' + vouchDatasSearchField + '&query=' + this.getValue()});
	        	vouchDatasDs.load({params:{start:0, limit:vouchDatasPagingToolbar.pageSize, monthDr:monthDr}});
	    	}
		}
});

var vouchDatasPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 50,
		store: vouchDatasDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',vouchDatasFilterItem,'-',vouchDatasSearchBox],
		doLoad:function(C)
		{
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['monthDr']=monthDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
});

var vouchDatasMain = new Ext.grid.GridPanel({//表格
		title: '财务支出数据',
		store: vouchDatasDs,
		cm: vouchDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		tbar: ['核算区间:',months,'-',operation,'-',opTool,'-',refreshButton,'-',FindButton ],
		//tbar: ['核算区间:',months,'-',operation,'-',importButton,'-',refreshButton,'-',FindButton ],
		bbar: vouchDatasPagingToolbar
});

vouchDatasMain.on("rowcontextmenu",function(vouchDatasMain,rowIndex,e) 
{ 
e.preventDefault();
if(rowIndex<0)
 {
 return;
 } 
var treeMenu = new Ext.menu.Menu 
([ 
{xtype:"button",text:"添加",icon:"../scripts/ext2/resources/images/default/dd/drop-add.gif",pressed:true,handler: function(){addFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}}, 
{xtype:"button",text:"编辑",icon:"Images/Icons/button/delete.gif",pressed:true,handler: function(){editFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}}, 
{xtype:"button",text:"删除",icon:"Images/Icons/button/cross.gif",pressed:true, handler:function(){delFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}}

]); 
treeMenu.showAt(e.getPoint()); 
}); 




function ExcelExport() { 
  var vExportContent = grid.getExcelXml(); // 获取数据 
  if (Ext.isIE8 ||Ext.isIE6 || Ext.isIE7 || Ext.isSafari || Ext.isSafari2 
    || Ext.isSafari3) { // 判断浏览器 
   var fd = Ext.get('frmDummy'); 
   if (!fd) { 
    fd = Ext.DomHelper.append(Ext.getBody(), { 
       tag : 'form', 
       method : 'post', 
       id : 'frmDummy', 
       action : 'ExportExcel.jsp', 
       target : '_blank', 
       name : 'frmDummy', 
       cls : 'x-hidden', 
       cn : [{ 
          tag : 'input', 
          name : 'exportContent', 
          id : 'exportContent', 
          type : 'hidden' 
         }] 
      }, true); 
   } 
   fd.child('#exportContent').set({ 
      value : vExportContent 
     }); 
   fd.dom.submit(); 
  } else { 
   document.location = 'data:application/vnd.ms-excel;base64,' 
     + Base64.encode(vExportContent); 
  } 

} 


//vouchDatasDs.load({params:{start:0, limit:vouchDatasPagingToolbar.pageSize}});