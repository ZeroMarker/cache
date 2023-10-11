///////////////////////////////////////////////////

var tmpData="";


/////////////////////�ϼ�����/////////////////////////////					
	var ufSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	ufSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('ufSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var ufSuperDeptField = new Ext.form.ComboBox({
			id: 'ufSuperDeptField',
			fieldLabel: '�ϼ�����',
			width:120,
			listWidth : 250,
			allowBlank: true,
			store: ufSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '',
			name: 'ufSuperDeptField',
			//��ʱΪ��
			//disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true
	});
/////////////////���Ҽ����ѯ//////////////////

var ufDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', 'һ������'], ['2', '��������'], ['3', '��������'],['4','�ļ�����']]
	});
	var ufDeptClassField = new Ext.form.ComboBox({
	    id : 'ufDeptClassField',
		fieldLabel : '���Ҽ���',
		width : 120,
		listWidth : 120,
		store : ufDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		//emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true
	});	
/////////////////////���ұ�������Ʋ�ѯ//////////////////////////////	
var ufDeptInfoField = new Ext.form.TextField({
		id: 'ufDeptInfoField',
		fieldLabel: '���ұ��������',
		width:120,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'ufDeptInfoField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
var findButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
    //tooltip:'��ѯ',        
    iconCls:'search',
	handler:function(){	
	    var deptinfo = ufDeptInfoField.getValue();
		var deptclass = ufDeptClassField.getValue();
        var superdept = ufSuperDeptField.getValue();
        
	//itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,deptinfo:deptinfo,deptclass:deptclass,superdept:superdept}}));
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : itemGridUrl+'?action=list&deptinfo='+ encodeURIComponent(deptinfo)+ 
								'&deptclass='+encodeURIComponent(deptclass)+
								'&superdept='+ encodeURIComponent(superdept),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : 25,
									sortDir:'',
									sortField:''
								}
							});
	}
});
/**
var srmdeptuserDs=function(){	

    itemGridDs.proxy = new Ext.data.HttpProxy({
    	
							url : 'herp.srm.srmdeptexe.csp?action=list',
							method : 'GET'
							//'&type='+ userTypeField.getValue()
						});
				itemGridDs.load({
							params : {
								start : 0,
								limit : 25
							}
						});
};
**/
var itemGridUrl = '../csp/herp.srm.srmdeptexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'Code',
			'Name',
			'Type',
			'IsValid',
			'DeptClass',
			'SuperDept'
		]),
	    remoteSort: true
});


Ext.ns("dhc.herp");

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
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		plugins : new dhc.herp.PageSizePlugin(),
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

var tmpTitle='������Ϣά��';	

var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: '����ID',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'Code',
            header: '���ұ��',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'Code'
       }, {
            id:'Name',
            header: '��������',
            allowBlank: false,
            width:240,
            editable:false,
            dataIndex: 'Name'
       },{
            id:'DeptClassID',
            header: '���Ҽ���ID',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'DeptClassID'
       },{
            id:'DeptClass',
            header: '���Ҽ���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DeptClass'
       },{
            id:'SuperDeptID',
            header: '�ϼ�����ID',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'SuperDeptID'
       },{
            id:'SuperDept',
            header: '�ϼ�����',
            allowBlank: false,
            width:240,
            editable:false,
            dataIndex: 'SuperDept'
       }, {
            id:'IsValid',
            header: '�Ƿ���Ч',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'IsValid',
			renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',
					iconCls : 'edit_add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls : 'pencil',
					handler : function() {
						srmdeptuserEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls : 'edit_remove',
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
														limit : 25
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
/*
var itemGrid = new Ext.grid.GridPanel({
			title: '������Ϣά��',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmdeptexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['','���ұ��������','',ufDeptInfoField,'','���Ҽ���','',ufDeptClassField,'','�ϼ�����','',ufSuperDeptField,'','-',findButton,'-',addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});
*/

var itemGrid = new dhc.herp.Grid({
        title: '������Ϣά��',
        iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.srmdeptexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: '����ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'Code',
            header: '���ұ��',
			//allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '��������',
			//allowBlank: false,
			width:180,
			editable:false,
            dataIndex: 'Name'
        },{
            id:'DeptClassID',
            header: '���Ҽ���ID',
			//allowBlank: false,
			editable:false,
		    hidden:true,
			width:180,
            dataIndex: 'DeptClassID'
        },{
            id:'DeptClass',
            header: '���Ҽ���',
			//allowBlank: false,
		    editable:false,
			width:180,
            dataIndex: 'DeptClass'
        },{
            id:'SuperDeptID',
            header: '�ϼ�����ID',
			//allowBlank: false,
			width:180,
			editable:false,
		    hidden:true,
            dataIndex: 'SuperDeptID'
        },{
            id:'SuperDept',
            header: '�ϼ�����',
			//allowBlank: false,
			editable:false,
			width:180,
            dataIndex: 'SuperDept'
        },{
            id:'IsValid',
            header: '�Ƿ���Ч',
			//allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'IsValid',
            //type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }] 
});
itemGrid.hiddenButton(0);
itemGrid.hiddenButton(1);
itemGrid.hiddenButton(2);
itemGrid.hiddenButton(3);
itemGrid.hiddenButton(4);
itemGrid.btnAddHide();     //�������Ӱ�ť
itemGrid.btnSaveHide();    //���ر��水ť
itemGrid.btnResetHide();   //�������ð�ť
itemGrid.btnDeleteHide();  //����ɾ����ť
itemGrid.btnPrintHide();   //���ش�ӡ��ť

itemGrid.addButton('-');
itemGrid.addButton(addButton);
itemGrid.addButton('-');
itemGrid.addButton(editButton);
itemGrid.addButton('-');
itemGrid.addButton(delButton);

itemGridDs.load({	
			params:{start:0, limit:25},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
