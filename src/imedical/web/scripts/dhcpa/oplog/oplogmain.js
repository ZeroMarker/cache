


//�������Դ
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
//ȥ���ո�
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
//���ݿ�����ģ��
var oplogTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "rowid",
		dataIndex: 'rowid',
		width: 200,
		sortable: true,
		hidden:true
	},{
		header: "����ģ������",
		dataIndex: 'opModuleName',
		width: 200,
		sortable: true,
		hidden:false
	},{
		id:"opData",
		header: "��������",
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
		header: "������",
		dataIndex: 'opUserName',
		width: 100
	
	},{
		header: "������ʽ",
		dataIndex: 'opMode',
		width: 80,
		align:'center',
		//sortable: true,
		renderer:function(v){
			var ret=v;
			if(v=="D"){
				ret="ɾ��";
			}else{
				ret="�༭";
			}
			return ret;
		}
	
	},{
		header: "����ʱ��",
		dataIndex: 'opTime',
		width: 150,
		align:'right',
		sortable: true
	}
	
]);
/*
	///======================����============
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
	fieldLabel: '�����Ŀ',
	width:220,
	listWidth : 220,
	resizable:true,
	//allowBlank: true,
	store:SchemeSearchDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񷽰�...',
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
	fieldLabel: 'ָ������',
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
	emptyText : '��ѡ��ָ��...',
	//name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
*/
//==================================================//
	//��ҳ
	var page = new Ext.PagingToolbar({
		pageSize:25,
		store:oplogTabDs,
		displayInfo:true,
		displayMsg:'��{0}��{1}������{2}��',
		emptyMsg:'û������'
	});
	
	var moduleNameField = new Ext.form.TextField({
		id: 'modeNameField',
		fieldLabel: 'ģ������',
		width:150,
		triggerAction: 'all',
		emptyText:'',
		name: 'modeNameField',
		//value:(new Date()).getFullYear(),
		editable:true
	});
	var startTimeField = new Ext.form.DateField({  
        fieldLabel : '��ʼʱ��',  
        name : 'startTime',  
        id : 'startTimeId',  
        enableKeyEvents : true,  
        width : 120,  
       // format : 'Y-m-d',  
        value:new Date().add(Date.DAY, -7),  
        emptyText : '��ʼʱ��'  
    }); 
		var endTimeField = new Ext.form.DateField({  
        fieldLabel : '����ʱ��',  
        name : 'endTime',  
        id : 'endTimeId',  
        enableKeyEvents : true,  
        width : 120,  
       // format : 'Y-m-d',  
		value:new Date(),  
        emptyText : '����ʱ��' 
    })  

	
	
	
	//��ѯ��ť
	var searchBtn = new Ext.Toolbar.Button({
		text:'��ѯ',
		width:30,
		iconCls: 'find',
		
		handler:function(){

			oplogTabDs.load({params:{start:0, limit:page.pageSize,moduleName:moduleNameField.getValue(),
									 startTime:Ext.util.Format.date(startTimeField.getValue(),'Y-m-d'),
									 endTime:Ext.util.Format.date(new Date((endTimeField.getValue()/1000+86400)*1000),'Y-m-d')}});//���һ��
		}
	});
	
	
var itemGrid=new Ext.grid.GridPanel({
	title:"������־��ѯ",
	region: 'center',
	layout:'fit',
	cm:oplogTabCm,
	store:oplogTabDs,
	autoExpandColumn:"opData",
	bbar:page,
	tbar:["ģ�����ƣ�",moduleNameField,"-","����ʱ��:",startTimeField,"��",endTimeField,searchBtn]
	
});
   
    oplogTabDs.load({params:{start:0, limit:page.pageSize}});

