
var userdr = session['LOGON.USERCODE'];


var itemGridUrl = '../csp/herp.srm.templatedownloadexe.csp';

var projUrl = 'herp.srm.templatedownloadexe.csp';

//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//����һ��url�ķ�������
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'YearDr',
			'Year',
			'SysNoDr',
			'SysNo',
			'Desc',
			'Type'
		]),
	    remoteSort: true
});

//���÷�ҳ
dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};


Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});


//�����ҳˢ��
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		plugins : new dhc.herp.PageSizePlugin(),
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');



//���
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=Year&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '���',
	width:180,
	listWidth : 250,
	//allowBlank : false, 
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	//emptyText:'��ѡ��ʼʱ��...',
	name: 'YearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//ģ����
var SysNoDrDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


SysNoDrDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=SysNoDr&str='+encodeURIComponent(Ext.getCmp('SysNoDrField').getRawValue()),method:'POST'});
});

var SysNoDrField = new Ext.form.ComboBox({
	id: 'SysNoDrField',
	fieldLabel: 'ģ������ģ���',
	width:180,
	listWidth : 250,
	//allowBlank : false, 
	store:SysNoDrDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	//emptyText:'��ѡ��ʼʱ��...',
	name: 'SysNoDrField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
var TypeField = new Ext.form.TextField({
		id: 'TypeField',
		fieldLabel: 'ģ������',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'TypeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});


var combos = new Ext.FormPanel({
			height:50,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,//columnWidth��ʾʹ�ðٷֱȵ���ʽָ���п��
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'���:',
						columnWidth:.06
					},
					YearField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'ģ������ģ���:',
						columnWidth:.15
					},
					SysNoDrField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},{
						xtype:'displayfield',
						value:'ģ������:',
						columnWidth:.13
					},TypeField,{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						columnWidth:0.1,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmtemplatedownloadDs();
						},
						iconCls: 'find'
						
					}	
		     	]
			}]
});




//������ʾ�б�cm��������������б�
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'YearDr',
            header: '���Dr',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'YearDr'
       },{
            id:'Year',
            header: '���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Year'
       }, {
            id:'SysNoDr',
            header: 'ģ������ģ���Dr',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'SysNoDr'
       },{
            id:'SysNo',
            header: 'ģ������ģ���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SysNo'
       },  {
            id:'Type',
            header: 'ģ������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Type'
       },{
            id:'Desc',
            header: '˵��',
            allowBlank: false,
            width:200,
            editable:false,
            dataIndex: 'Desc',
            renderer :function(value, meta, record) {   
                             meta.attr = 'style="white-space:normal;word-wrap:break-word;"';    
                             return value;    
            }
       },{
			id:'upload',
			header: 'ģ���ϴ�',
			allowBlank: false,
			width:60,
			editable:false,
			dataIndex: 'upload',
			//hidden:true,
			renderer : function(v, p, r){			
			return '<span style="color:blue"><u>�ϴ�</u></span>';
			}
       }, {
			id:'download',
			header: 'ģ������',
			allowBlank: false,
			width:60,
			editable:false,
			dataIndex: 'download',
			renderer : function(v, p, r){
			return '<span style="color:blue"><u>����</u></span>';
			}
       }
			    
]);


	
	



//��������ťtbar---���幦�ܰ�ť
var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',
					id:'addButton',
					iconCls : 'add',
					handler : function() {
						srmtemplatedownloadAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					id:'editButton',
					iconCls : 'option',
					handler : function() {
						srmtemplatedownloadEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			id:'delButton',
			iconCls : 'remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
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
					})
				}
			}
});

var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.templatedownloadexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,/*������Դstore*/
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],/*������ӵ��ǰ�ť-��������ťtbar*/
			bbar:itemGridPagingToolbar/*������ӵ��������ҳ��ˢ�µ�-��ҳˢ��bbar*/
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});


var srmtemplatedownloadDs=function(){
	
		var year=YearField.getValue();	
		var sysnodr=SysNoDrField.getValue();
		var type=TypeField.getValue();

					itemGridDs.load({
								params : {
									start : 0,
									limit : 20,
									year:year,
									sysnodr:sysnodr,
									type:type
								}
							});
};

 if ((userdr=="Y1002")||(userdr=="O0100")||(userdr=="O2404")||(userdr=="demo"))
{
	Ext.getCmp('addButton').setVisible(true);
	Ext.getCmp('editButton').setVisible(true);
	Ext.getCmp('delButton').setVisible(true);
	//Ext.getCmp('upload').setVisible(false);
	//upload.disable();
	//Ext.getCmp('upload').hidden = true;
	//Ext.getCmp('upload').hide();
	//grid.getColumnModel().setHidden(2,true); 
	//grid.columns[4].setVisible(true);
	//myGrid.getColumnModel().setHidden(3, true);
	itemGrid.getColumnModel().setHidden(8,false);
}
else{
	Ext.getCmp('addButton').setVisible(false);
	Ext.getCmp('editButton').setVisible(false);
	Ext.getCmp('delButton').setVisible(false);
	itemGrid.getColumnModel().setHidden(8,true);
}

uploadMainFun(itemGrid,'rowid','P000',8);
downloadMainFun(itemGrid,'rowid','P000',9);