///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/herp.srm.horizonprjmidcheckexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
	        'rowid','Name','DeptDr','DeptName','Head','HeadName','Participants','SubSource','SubSourceName','SubNo','AppFunds','GraFunds','StartDate','EndDate','ConDate','RelyUnit','SubUser','SubUserName','SubDate','DataStatus','ResAudit','ResDesc','AuditUser','AuditUserName','AuditDate','ProjStatus','Remark','SysNo','SysNoCode'

		]),
	    remoteSort: true
});


var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

//

var PrjSrcDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['prjtyperowid','prjtypename'])
});
PrjSrcDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetPrjType&str='+encodeURIComponent(Ext.getCmp('PrjSrcField').getRawValue()),method:'POST'});
});
var PrjSrcField = new Ext.form.ComboBox({
	id: 'PrjSrcField',
	fieldLabel: '������Դ',
	width:150,
	listWidth :225,
//	allowBlank: false,
	store: PrjSrcDs,
	valueField: 'prjtyperowid',
	displayField: 'prjtypename',
	triggerAction: 'all',
	emptyText:'��ѡ�������Դ...',
	name: 'PrjSrcField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

///���⸺����////////////////////////////////
var PrjHeaderDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['headerrowid','headername'])
});
PrjHeaderDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetPrjHeader&str='+encodeURIComponent(Ext.getCmp('PrjHeaderField').getRawValue()),method:'POST'});
});
var PrjHeaderField = new Ext.form.ComboBox({
	id: 'PrjHeaderField',
	fieldLabel: '���⸺����',
	width:150,
	listWidth :225,
//	allowBlank: false,
	store: PrjHeaderDs,
	valueField: 'headerrowid',
	displayField: 'headername',
	triggerAction: 'all',
	emptyText:'��ѡ����⸺����...',
	name: 'PrjHeaderField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
// ////////////����////////////////////////
var CalDeptDs = new Ext.data.Store({
	    autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['deptrowid', 'deptname'])
		});

CalDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
		  url:itemGridUrl+'?action=GetDepts&str='+encodeURIComponent(Ext.getCmp('CalDeptField').getRawValue()),method:'POST'});
		});
var CalDeptField = new Ext.form.ComboBox({
	id: 'CalDeptField',
	fieldLabel: '����',
	width:100,
	listWidth : 225,
	//allowBlank: false,
	store: CalDeptDs,
	valueField: 'deptrowid',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'CalDeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//
var PrjNameField = new Ext.form.TextField({
	id:'PrjName',
	fieldLabel: '��������',
	//allowBlank: false,
	width:150,
	listWidth : 150,
	emptyText:'����д��������...',
	anchor: '90%',
	selectOnFocus:'true'
});
//������ʼʱ��ؼ�
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120,
	//allowBlank : false,
	emptyText : ''
});
var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120,
	emptyText : ''
	
});


/////////////////////ISBN��
var ISBNText = new Ext.form.TextField({
width :100,
selectOnFocus : true
});

/////����
var userDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

userDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=userList',
					method : 'POST'
				});
	});

var userCombo = new Ext.form.ComboBox({
		fieldLabel : '���� ',
		store : userDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 110,
		listWidth : 225,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
	});
	

///////////////////�������
var MonTraStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', 'ר��'], ['2', '����']]
	});
var MonTraField = new Ext.form.ComboBox({
		fieldLabel : '�������',
		width : 100,
		listWidth : 80,
		selectOnFocus : true,
		allowBlank : false,
		store : MonTraStore,
		anchor : '90%',
		// value:'key', //Ĭ��ֵ
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		triggerAction : 'all',
		emptyText : '',
		mode : 'local', // ����ģʽ
		editable : false,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true,
		forceSelection : true
	});

function srmFundSearch(){
    var starttime= PSField.getValue();
    if (starttime!=="")
    {
       //starttime=starttime.format ('Y-m-d');
    }
    //alert(starttime);
    var endtime = PEField.getValue();
    if (endtime!=="")
    {
       //endtime=endtime.format ('Y-m-d');
    }
    //alert(endtime);
    var deptdr  = CalDeptField.getValue();
    var source = PrjSrcField.getValue(); 
    var headdr = PrjHeaderField.getValue();
    var name = PrjNameField.getValue();
  	itemGridDs.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:starttime,
	   // editor, isbn, montra, starttime, endtime
	    endtime:endtime,
	    deptdr:deptdr,
	    source:source,
	    headdr:headdr,
	    name:name,
	    user:session['LOGON.USERCODE']
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		height:150,
		region:'north',
		frame:true,
		defaults: {bodyStyle:'padding:5px'},
			items:[{
			xtype: 'panel',
			layout:"column",
			items: [
				{   
					xtype:'displayfield',
					value:'<center><p style="font-weight:bold;font-size:150%">��Ŀ�м�����ϱ�</p></center>',
					columnWidth:1,
					height:'50'
				}]
		    },{
		    columnWidth:1,
		    xtype: 'panel',
			layout:"column",
			items: [
				{
					xtype:'displayfield',
					value:'��Ŀ��ֹʱ��:',
					columnWidth:.14
				},
				PSField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.01
				},
				{
					xtype:'displayfield',
					value:' ��',
					columnWidth:.03
				},
				PEField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.1
				},{
					xtype:'displayfield',
					value:'����:',
					columnWidth:.06
				},
				CalDeptField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.1
				},{
					xtype:'displayfield',
					value:'������Դ:',
					columnWidth:.10
				},PrjSrcField
				]
		    },{
			xtype: 'panel',
			layout:"column",
			items: [
				
				{
					xtype:'displayfield',
					value:'���⸺����:',
					columnWidth:.09
				},
				PrjHeaderField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.06
				},
				{
					xtype:'displayfield',
					value:'��������:',
					columnWidth:.07
				},
				PrjNameField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.15
				},
				{
					columnWidth:0.05,
					xtype:'button',
					text: '��ѯ',
					handler:function(b){
						srmFundSearch();
					
				
					},
					iconCls: 'option'
				}		
			]
		}
		]
	});
var itemGridCm = new Ext.grid.ColumnModel([

        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'Name',
            header: '��������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Name'
       }, {
            id:'DeptDr',
            header: '����ID',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'DeptDr'
       }, {
            id:'DeptName',
            header: '��������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DeptName'
       }, {
            id:'Head',
            header: '������Dr',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'Head'
       }, {
            id:'HeadName',
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'HeadName'
       }, {
            id:'Participants',
            header: '�μ���Ա',
            allowBlank: false,
            width:200,
            editable:false,
            dataIndex: 'Participants'
       }, {
            id:'SubSource',
            header: '������ԴID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'SubSource'
       }, {
            id:'SubSourceName',
            header: '������Դ',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubSourceName'
       }, {
            id:'SubNo',
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubNo'
       }, {
            id:'AppFunds',
            header: '���뾭��',
            allowBlank: false,
            width:100,
            align:'right',
            xtype:'numbercolumn',
            editable:false,
            dataIndex: 'AppFunds'
       }, {
            id:'GraFunds',
            header: '��׼����',
            xtype:'numbercolumn',
            allowBlank: false,
            align:'right',
            width:100,
            editable:false,
            dataIndex: 'GraFunds'
       }, {
            id:'StartDate',
            header: '������ʼʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'StartDate'
       }, {
            id:'EndDate',
            header: '������ֹʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'EndDate'
       }, {
            id:'ConDate',
            header: '�������ʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ConDate'
       }, {
            id:'RelyUnit',
            header: '���е�λ',
            allowBlank: false,
            width:200,
            editable:false,
            dataIndex: 'RelyUnit'
       }, {
            id:'SubUser',
            header: '������ID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'SubUser'
       }, {
            id:'SubUserName',
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubUserName'
       }, {
            id:'SubDate',
            header: '��������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubDate'
       }, {
            id:'DataStatus',
            header: '����״̬',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DataStatus'
       }, {
            id:'ResAudit',
            header: '���п����״̬',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ResAudit'
       }, {
            id:'ResDesc',
            header: '������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ResDesc'
       }, {
            id:'AuditUser',
            header: '�����ID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'AuditUser'
       }, {
            id:'AuditUserName',
            header: '�����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'AuditUserName'
       }, {
            id:'AuditDate',
            header: '���ʱ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'AuditDate'
       }, {
            id:'ProjStatus',
            header: '��Ŀ״̬',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ProjStatus'
       }, {
            id:'Remark',
            header: '��ע',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Remark'
       }, {
            id:'SysNo',
            header: 'ϵͳģ���ID',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       }, {
            id:'SysNoCode',
            header: 'ϵͳģ���',
            hidden:true,
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SysNoCode'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',
					iconCls : 'add',
					handler : function() {
						srmmonographAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						srmMonographEditFun();
					}
				});
var submitButton = new Ext.Toolbar.Button({
	text : '�ύ',
	tooltip : '�ύ',
	iconCls : 'option',
	handler : function() {
		srmMonographSubmitFun();
	}
});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				 if(rowObj[0].get("DataStatus")=="�ύ")
				 {
					      Ext.Msg.show({title:'ע��',msg:'���ύ��¼�޷�ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					       return;
				 }
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : 'ɾ����...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '����',
												msg : '������������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : 'ע��',
													msg : '�����ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
												});
									} else {
										Ext.Msg.show({
													title : '����',
													msg : '����',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					});
				}
			}
});

var itemGrid = new Ext.grid.GridPanel({
			//title: 'ר���ɹ�����',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.horizonprjmidcheckexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addButton,'-',editButton,'-',delButton,'-',submitButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize,user:session['LOGON.USERCODE']},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  var srmdeptuserDs=function(){	
		var type=Ext.getCmp('uTypeGridField').value;
		if (type==undefined){type="";}
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.srm.horizonprjmidcheckexe.csp?action=list&code='+ encodeURIComponent(uCodeField.getValue())+ 
								'&name='+encodeURIComponent(Ext.getCmp('uNameField').getRawValue())+
								'&type='+ encodeURIComponent(type),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : itemGridPagingToolbar.pageSize
								}
							});
	};
	/**
	 * �˴�Ӧ��Ƴ��û�ֻ���ύ�Լ�����Ʒ*/
	srmMonographSubmitFun=function(){

	//���岢��ʼ���ж���
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�ύ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	 for(var j= 0; j < len; j++){
		 if(rowObj[j].get("DataStatus")=="�ύ")
		 {
			      Ext.Msg.show({title:'ע��',msg:'���ύ��¼�޷��ٴ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
//		�˶δ��������ж��û�ֻ���ύ�Լ��Ĵ���
//		 if(rowObj[j].get("EditorName")!=session['LOGON.USERNAME'])
//		 {
//			      Ext.Msg.show({title:'ע��',msg:'�û�ֻ���ύ�Լ���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//			       return;
//		 }
		}

	
    
	function handler(id){
		if(id=="yes"){
			
			for(var i = 0; i < len; i++){
				    Ext.Ajax.request({
					url:'herp.srm.horizonprjmidcheckexe.csp?action=monographAsk&&rowid='+rowObj[i].get("rowid")+'&sysno='+rowObj[i].get("SysNo")+'&editor='+rowObj[i].get("EditorDr")+'&deptdr='+rowObj[i].get("DeptDr"),
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});	
							
						}else{
							var message='���ʧ��!';
							if(jsonData.info=="RepName") message="�����ظ�";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('��ʾ','ȷʵҪ�ύ��ѡ��¼��?',handler);

	}
