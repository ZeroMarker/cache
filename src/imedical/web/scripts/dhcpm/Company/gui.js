//Create by zzp
// 20150515
//��˾����
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.CompanyTel	= new Ext.form.TextField({
		id : 'CompanyTel'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ϵ��ʽ'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyCode = new Ext.form.TextField({
		id : 'CompanyCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.CompanyDesc = new Ext.form.TextField({
		id : 'CompanyDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyAddress = new Ext.form.TextField({
		id : 'CompanyAddress'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ַ'
		,editable : true
		//,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyAdd = new Ext.Button({
		id : 'CompanyAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.CompanyUpdate = new Ext.Button({
		id : 'CompanyUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.CompanyDelete = new Ext.Button({
		id : 'CompanyDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.CompanyQuery = new Ext.Button({
		id : 'CompanyQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.CompanyBatch = new Ext.Button({
		id : 'CompanyBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.CompanyAdd, '-', obj.CompanyUpdate,'-',obj.CompanyDelete]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('���룺'),obj.CompanyCode,'-',new Ext.Toolbar.TextItem('������'),obj.CompanyDesc,'-',new Ext.Toolbar.TextItem('��ϵ��ʽ��'),obj.CompanyTel,'-',new Ext.Toolbar.TextItem('��ַ��'),obj.CompanyAddress,'-',obj.CompanyQuery,'-',obj.CompanyBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.CompanyGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	
    obj.CompanyGridStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyGridStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['CompanyGridRowid','CompanyGridCode','CompanyGridDesc','CompanyGridAddress','CompanyGridPhone','CompanyGridWebsite','CompanyGridEmail','CompanyGridLawPerson','CompanyGridType','CompanyGridListing','CompanyGridPhone1','CompanyGridPhone2','CompanyGridPostCdoe','CompanyGridEmail1','CompanyGridEmail2','CompanyGridFlag','CompanyGridRemark','CompanyGridCreatUser','CompanyGridCreatDate','CompanyGridCreatTime','CompanyGridTypeid','CompanyGridListingid'])
    	});
	obj.gridCompanyCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.CompanyGridPanel = new Ext.grid.GridPanel({
		id : 'CompanyGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridCompanyCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.CompanyGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridCompanyCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'CompanyGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��˾����', width : 200, dataIndex : 'CompanyGridCode', sortable : false, align : 'center',editable: true }
			, { header : '��˾����', width : 200, dataIndex : 'CompanyGridDesc', sortable : false ,align : 'center'}
			, { header : '��˾��ַ', width : 300, dataIndex : 'CompanyGridAddress', sortable : true, align : 'center' }
			, { header : '��˾�绰', width : 150, dataIndex : 'CompanyGridPhone',sortable : true,align : 'center' }
			, { header : '��˾��ַ', width : 150, dataIndex : 'CompanyGridWebsite',sortable : true,align : 'center'}
			, { header : '��˾����', width : 150, dataIndex : 'CompanyGridEmail',sortable : true,align : 'center' }
			, { header : '���˴���', width : 150, dataIndex : 'CompanyGridLawPerson',sortable : true,align : 'center' }
			, { header : '��˾����', width : 150, dataIndex : 'CompanyGridType',sortable : true,align : 'center' }
			, { header : '�Ƿ�����', width : 150, dataIndex : 'CompanyGridListing',sortable : true,align : 'center' }
			, { header : '��˾�绰1', width : 150, dataIndex : 'CompanyGridPhone1',sortable : true,align : 'center' }
			, { header : '��˾�绰2', width : 150, dataIndex : 'CompanyGridPhone2',sortable : true,align : 'center' }
			, { header : '�ʱ�', width : 150, dataIndex : 'CompanyGridPostCdoe',sortable : true,align : 'center' }
			, { header : '��˾����1', width : 150, dataIndex : 'CompanyGridEmail1',sortable : true,align : 'center' }
			, { header : '��˾����2', width : 150, dataIndex : 'CompanyGridEmail2',sortable : true,align : 'center' }
			, { header : '��Ч��־', width : 150, dataIndex : 'CompanyGridFlag',sortable : true,align : 'center' }
			, { header : '��ע', width : 150, dataIndex : 'CompanyGridRemark',sortable : true,align : 'center' }
			, { header : '������', width : 150, dataIndex : 'CompanyGridCreatUser',sortable : true,align : 'center' }
			, { header : '��������', width : 150, dataIndex : 'CompanyGridCreatDate',sortable : true,align : 'center' }
			, { header : '����ʱ��', width : 150, dataIndex : 'CompanyGridCreatTime',sortable : true,align : 'center' }
			, { header : '��˾����id', width : 150, dataIndex : 'CompanyGridTypeid',hidden:true,sortable : true,align : 'center' }
			, { header : '�Ƿ�����id', width : 150, dataIndex : 'CompanyGridListingid',hidden:true,sortable : true,align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.CompanyGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
	obj.CompanyPanal=new Ext.Panel({
			id : 'CompanyPanal'
			,layout : 'fit'
			,title:'��˾����'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.CompanyGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.CompanyPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.CompanyGridStore.removeAll();
	obj.CompanyGridStore.load();
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function CompanyMenuWind(){
    var obj = new Object();
	obj.CompanyMenuTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyMenuTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CompanyMenuListingStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyMenuListingStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CompanyMenuTypeStore.load();
	obj.CompanyMenuListingStore.load();
	obj.CompanyRowid= new Ext.form.TextField({
		id : 'CompanyRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.CompanyFlag	= new Ext.form.TextField({
		id : 'CompanyFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuCode	= new Ext.form.TextField({
		id : 'CompanyMenuCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾����'
		//,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuDesc = new Ext.form.TextField({
		id : 'CompanyMenuDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuAddress = new Ext.form.TextField({
		id : 'CompanyMenuAddress'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾��ַ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel = new Ext.form.TextField({
		id : 'CompanyMenuTel'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾�绰'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuWebsite = new Ext.form.TextField({
		id : 'CompanyMenuWebsite'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾��ַ'
		,editable : true
		//,regex:  ((http|https|ftp):(\/\/|\\\\)((\w)+[.]){1��}(net|com|cn|org|cc|tv|[0-9]{1��3})(((\/[\~]*|\\[\~]*)(\w)+)|[.](\w)+)*(((([?](\w)+){1}[=]*))*((\w)+){1}([\&](\w)+[\=](\w)+)*)*)
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail = new Ext.form.TextField({
		id : 'CompanyMenuEmeail'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾����'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuLawPerson = new Ext.form.TextField({
		id : 'CompanyMenuLawPerson'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '���˴���'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuType = new Ext.form.ComboBox({
		id : 'CompanyMenuType'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.CompanyMenuTypeStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��˾����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuListing = new Ext.form.ComboBox({
		id : 'CompanyMenuListing'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.CompanyMenuListingStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�Ƿ�����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel1 = new Ext.form.TextField({
		id : 'CompanyMenuTel1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾�绰1'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel2 = new Ext.form.TextField({
		id : 'CompanyMenuTel2'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾�绰2'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuPostCdoe = new Ext.form.TextField({
		id : 'CompanyMenuPostCdoe'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ʱ�'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail1 = new Ext.form.TextField({
		id : 'CompanyMenuEmeail1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾����1'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail2 = new Ext.form.TextField({
		id : 'CompanyMenuEmeail2'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��˾����2'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuRemark = new Ext.form.TextArea({
		id : 'CompanyMenuRemark'
		,width : 100
		,minChars : 1
		,height : 150
		,displayField : 'desc'
		,fieldLabel : '��ע��Ϣ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuAdd = new Ext.Button({
		id : 'CompanyMenuAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.CompanyMenuDelete = new Ext.Button({
		id : 'CompanyMenuDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenuadd = new Ext.form.FormPanel({
		id : 'winTPanelMenuadd'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : "right"
		,labelWidth:65
		,frame : true
		,items:[{   // ��1
                layout : "column",         // �������ҵĲ���
                items : [{
                          columnWidth : .5       // ��������������ռ�ٷֱ�
                          ,layout : "form"       // �������µĲ���
                          ,items : [obj.CompanyRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuCode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuDesc]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuTel]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuEmeail]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuTel1]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuTel2]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuEmeail1]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuEmeail2]
                         }]
                },{ // ��6
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuWebsite]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuPostCdoe]
                         }]
                },{ // ��7
                layout : "column",        
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuLawPerson]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.CompanyMenuType]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.CompanyMenuListing]
                         }]
                },{ // ��8
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuAddress]
                         }]
                },{ // ��9
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuRemark]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 470
		,buttonAlign : 'center'
		,width : 550
		,modal : true
		,title : '��˾��ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.CompanyMenuAdd
			  ,obj.CompanyMenuDelete
		]
	});
	CompanyMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}