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
		header: '�ɱ�����',
		dataIndex: 'tDeptName',
		width: 100,
		align: 'left',
		 renderer:color,
		sortable: true
    },
	{
		header: '�ɱ���Ŀ',
		dataIndex: 'itemName',
		width: 100,
		align: 'left',
	    renderer:color,
		sortable: true
    },
	{
        header: '¼������',
        dataIndex: 'inType',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '���Ŵ���',
        dataIndex: 'deptCode',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '��������',
        dataIndex: 'deptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '��Ŀ����',
        dataIndex: 'subjCode',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '��Ŀ����',
        dataIndex: 'subjName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '�跽',
        dataIndex: 'debit',
        width: 80,
		align: 'right',
		renderer: formatNum,
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'loans',
        width: 80,
        align: 'right',
		renderer: formatNum,
        sortable: true
    },
	{
        header: '��ע',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: '�ɼ���',
        dataIndex: 'personName',
        width: 70,
        align: 'left',
        sortable: true
    },
	
	{
        header: '�༭����',
        dataIndex: 'nDate',
        width: 80,
		renderer:formatDate,
        align: 'left',
        sortable: true
    },
	{
        header: '�����־',
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
	fieldLabel: '��������',
	//anchor: '60%',
	width:100,
	listWidth : 240,
	allowBlank: false,
	store: monthsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'ѡ���������...',
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
			  fieldLabel:'����',
			  store: unitTypeDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��λ���...',
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
			  fieldLabel:'����',
			  store: unitDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:120,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��λ...',
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
		text: '���',
		tooltip: '����µ�ƾ֤���ݱ�',        
		iconCls: 'add',
		handler: function(){
			
			addFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}
};

var editDataTypesButton  ={
		text: '�޸�',        
		tooltip: '�޸�ѡ����ƾ֤���ݱ�',
		iconCls: 'remove',
		handler: function(){editFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}
};

var delDataTypesButton  ={
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ����ƾ֤���ݱ�',
		iconCls: 'remove',
		disabled: user="�ɱ�������"?false:true,
		 //hidden : user="demo"?false:true,
		handler: function(){delFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}
};

var opMenu2 = new Ext.menu.Menu({
    id: 'opMenu2',
    //items: [addDataTypesButton,editDataTypesButton, delDataTypesButton]
    items: [addDataTypesButton, delDataTypesButton]
});
var operation = new Ext.Toolbar([{
	
    text: '��������',
    iconCls: 'add',
    //disabled:rightDr=1?true:false,
    menu: opMenu2
}]);

var refreshButton  = new Ext.Toolbar.Button({
		text: 'ִ�����ݶ���',        
		tooltip: '���Һ���Ŀ����',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){refreshFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}
});


var importButton = {
    text: 'EXCEL����',
    tooltip: '��������',
    iconCls: 'remove',
    handler: function() { loadVouchData(vouchDatasDs) }
};

var importButtonPM ={
 text:'����ҩƷ�ɱ��ɼ�',
 tooltip:'����ҩƷ�ɱ�����',
 disabled: true,
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"PM");}
};

var importButtonPZ ={
 text:'סԺҩƷ�ɱ��ɼ�',
 tooltip:'����ҩƷ�ɱ�����',
 disabled: true,
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"PZ");}
};

var importButtonM ={
 text:'���������ʳ���',
 tooltip:'�������ʳ�������',
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"M");}
};


var importButtonZ ={
 text:'�۾����ݲɼ�',
 tooltip:'�����۾�����',
 iconCls:'remove',
 handler:function(){imporFun(vouchDatasDs,vouchDatasPagingToolbar,monthDr,"Z");}
};


var opMenu = new Ext.menu.Menu({
    id: 'opMenu',
    items: [importButton,importButtonPM,importButtonPZ,importButtonM,importButtonZ]
});
var opTool = new Ext.Toolbar([{
    text: '�ɱ����ݲɼ�',
    iconCls: 'add',
    menu: opMenu
}]);

var FindButton = new Ext.Toolbar.Button({
    text: 'ͳ�Ʋ�ѯ',
    tooltip: 'ͳ�Ʋ�ѯ',
    iconCls: 'remove',
    handler: function() { CommFindFun() }
});


var vouchDatasSearchField = 'itemName';

var vouchDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '�ɱ�����',value: 'tDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ɱ���Ŀ',value: 'itemName',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '¼������',value: 'inType',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '¼����',value: 'personName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: 'ƾ֤��',value: 'num',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: 'ժҪ',value: 'abstract',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)���Ŵ���',value: 'deptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)��������',value: 'deptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)��Ŀ����',value: 'subjCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '(HIS)��Ŀ����',value: 'subjName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�跽',value: 'debit',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'loans',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'date',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				vouchDatasSearchField = item.value;
				vouchDatasFilterItem.setText(item.text + ':');
		}
};

var vouchDatasSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
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

var vouchDatasPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 50,
		store: vouchDatasDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}�A����{2}',
		emptyMsg: "û������",
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

var vouchDatasMain = new Ext.grid.GridPanel({//���
		title: '����֧������',
		store: vouchDatasDs,
		cm: vouchDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		tbar: ['��������:',months,'-',operation,'-',opTool,'-',refreshButton,'-',FindButton ],
		//tbar: ['��������:',months,'-',operation,'-',importButton,'-',refreshButton,'-',FindButton ],
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
{xtype:"button",text:"���",icon:"../scripts/ext2/resources/images/default/dd/drop-add.gif",pressed:true,handler: function(){addFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar);}}, 
{xtype:"button",text:"�༭",icon:"Images/Icons/button/delete.gif",pressed:true,handler: function(){editFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}}, 
{xtype:"button",text:"ɾ��",icon:"Images/Icons/button/cross.gif",pressed:true, handler:function(){delFun(vouchDatasDs,vouchDatasMain,vouchDatasPagingToolbar,monthDr);}}

]); 
treeMenu.showAt(e.getPoint()); 
}); 




function ExcelExport() { 
  var vExportContent = grid.getExcelXml(); // ��ȡ���� 
  if (Ext.isIE8 ||Ext.isIE6 || Ext.isIE7 || Ext.isSafari || Ext.isSafari2 
    || Ext.isSafari3) { // �ж������ 
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