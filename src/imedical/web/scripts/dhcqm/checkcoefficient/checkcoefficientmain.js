


//�������Դ
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
//ȥ���ո�
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
//���ݿ�����ģ��
var CheckCoefficientTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header: "�����Ŀ",
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
		header: "��������",
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
		header: "���ʽ",
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
		header: "����ֵ",
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
//========================����=========================//
//����combox
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
	//TODO:ģ����ѯδ����
	//console.log(Ext.getCmp('checkField').getRawValue());
	});
	
	var checkComSearch = new Ext.form.ComboBox({
		
		fieldLabel: '����',
		width:230,
		height:100,
		listWidth :230,
        allowBlank: false,
		store: checkDsSearch,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�����...',
		
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
	fieldLabel: '����',
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
	emptyText : '��ѡ�����...',
	//name: 'LocResultdetailcheckDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
	///======================����============
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
	fieldLabel: '�����Ŀ',
	width:220,
	listWidth : 220,
	resizable:true,
	//allowBlank: true,
	store:SchemeSearchDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ������Ŀ...',
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
	//��ҳ
	var page = new Ext.PagingToolbar({
		pageSize:20,
		store:CheckCoefficientTabDs,
		displayInfo:true,
		displayMsg:'��{0}��{1}������{2}��',
		emptyMsg:'û������'
	});
	//��ѯ��ť
	var searchBtn = new Ext.Toolbar.Button({
		text:'��ѯ',
		width:30,
		iconCls: 'option',
		handler:function(){

			CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize,checkDr:checkComSearch.getValue(),schemdr:SchemeSearchField.getValue()}});
				}
	});
	//������ť
	var addBtn = new Ext.Toolbar.Button({
		text:'����',
		width:30,
		iconCls: 'add',
		handler:function(){
				addFun();
		}
	});
	//�޸İ�ť
	var editBtn = new Ext.Toolbar.Button({
		text:'�޸�',
		width:30,
		iconCls: 'option',
		handler:function(){
			
			editFun(itemGrid);
				}
	});
	//ɾ����ť
	var deleteBtn = new Ext.Toolbar.Button({
		text:'ɾ��',
		width:30,
		iconCls: 'remove',
		handler:function(btn,even){
			//���rowid
			var rowid = itemGrid.getSelectionModel().selections.items[0].data.rowid;
			Ext.Ajax.request({
				url:CheckCoefficientTabUrl+'?action=del&rowid='+rowid,
				success:function(result,request){

					var jsonData = Ext.util.JSON.decode( result.responseText );
											console.log(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});
					}else{
						
						Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						
					}
				},
				failure:function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				scope: this
			});
		}
	});
	
var itemGrid=new Ext.grid.GridPanel({
	title:"��������ֵά��",
	region: 'center',
	layout:'fit',
	cm:CheckCoefficientTabCm,
	store:CheckCoefficientTabDs,
	
	bbar:page,
	tbar:[addBtn,"-",editBtn,"-",deleteBtn,"-",SchemeSearchField,"-",checkComSearch,"-",searchBtn]
	
});
   
    CheckCoefficientTabDs.load({params:{start:0, limit:page.pageSize}});

