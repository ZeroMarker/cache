//Create by zzp
// 20150430
//ģ�����
function InitviewScreen(){
	var obj = new Object();
	//alert(ExtToolSetting.RunQueryPageURL);
	//******************************Start****************************
	obj.ModeuleStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeuleStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeuleName= new Ext.form.TextField({
		id : 'ModeuleName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModeuleCode = new Ext.form.TextField({
		id : 'ModeuleCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.ModeuleStandby1 = new Ext.form.TextField({
		id : 'ModeuleStandby1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�汾��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ModeuleStatus = new Ext.form.ComboBox({
		id : 'ModeuleStatus'
		,width : 100
		,store : obj.ModeuleStatusStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '״̬'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ModeuleAdd = new Ext.Button({
		id : 'ModeuleAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ModeuleUpdate = new Ext.Button({
		id : 'ModeuleUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.ModeuleQuery = new Ext.Button({
		id : 'ModeuleQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.ModeuleBatch = new Ext.Button({
		id : 'ModeuleBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.ModeuleAdd, '-', obj.ModeuleUpdate]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('ģ�����ƣ�'),obj.ModeuleName,'-',new Ext.Toolbar.TextItem('ģ����룺'),obj.ModeuleCode,'-',new Ext.Toolbar.TextItem('�汾�ţ�'),obj.ModeuleStandby1,'-',new Ext.Toolbar.TextItem('״̬��'),obj.ModeuleStatus,'-',obj.ModeuleQuery,'-',obj.ModeuleBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.ModeuleGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.ModeuleGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.ModeuleGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'ModeuleGridStoreQuery';
			param.Arg1 = Ext.getCmp('ModeuleName').getValue()+"^"+Ext.getCmp('ModeuleStandby1').getValue()+"^"+Ext.getCmp('ModeuleCode').getValue()+"^"+Ext.getCmp('ModeuleStatus').getValue();
			param.ArgCnt = 1;
	});
	obj.ModeuleGridStore = new Ext.data.Store({
		proxy: obj.ModeuleGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record'
			,totalProperty: 'total'
			,fields:[{
			name: 'ModeuleGridRowid',
			mapping: 'ModeuleGridRowid'
			},{
			name: 'ModeuleGridName',
			mapping: 'ModeuleGridName'
			},{
			name: 'ModeuleGridCode',
			mapping: 'ModeuleGridCode'
			},{
			name: 'ModeuleGridCP', 
			mapping: 'ModeuleGridCP'
			},{
			name: 'ModeuleGridCPid',
			mapping: 'ModeuleGridCPid'
			},{
			name: 'ModeuleGridContract',
			mapping: 'ModeuleGridContract'  
			},{
			name: 'ModeuleGridContractid',
			mapping: 'ModeuleGridContractid'
			},{
			name: 'ModeuleGridGroup',
			mapping: 'ModeuleGridGroup'
			},{
			name: 'ModeuleGridGroupid',
			mapping: 'ModeuleGridGroupid'
			},{
			name: 'ModeuleGridStandby1',
			mapping: 'ModeuleGridStandby1'
			},{
			name: 'ModeuleGridProduct',
			mapping: 'ModeuleGridProduct'
			},{
			name: 'ModeuleGridStandby2',
			mapping: 'ModeuleGridStandby2'
			},{
			name: 'ModeuleGridProduct1',
			mapping: 'ModeuleGridProduct1'
			},{
			name: 'ModeuleGridStatus',
			mapping: 'ModeuleGridStatus'
			},{
			name: 'ModeuleGridPlanDate',
			mapping: 'ModeuleGridPlanDate'
			},{
			name: 'ModeuleGridActuclDate',
			mapping: 'ModeuleGridActuclDate'
			},{
			name: 'ModeuleGridRemark',
			mapping: 'ModeuleGridRemark'
			},{
			name: 'ModeuleGridImpro',
			mapping: 'ModeuleGridImpro'
			}]
		})
	});
	obj.gridModeuleCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ModeuleGridPanel = new Ext.grid.GridPanel({
		id : 'ModeuleGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		//,trackMouseOver: false   //������ȥ����������ʾ
		//,disableSelection: true   //���ܶ�grid����ѡ��
		,plugins : obj.gridModeuleCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ModeuleGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridModeuleCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'ModeuleGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : 'ģ������', width : 200, dataIndex : 'ModeuleGridName', sortable : false, align : 'center',editable: true }
			, { header : 'ģ�����', width : 100, dataIndex : 'ModeuleGridCode', sortable : false ,align : 'center'}
			, { header : '��Ʒ', width : 100, dataIndex : 'ModeuleGridCP',sortable : true,align : 'center' }
			, { header : '��Ʒid', width : 100, dataIndex : 'ModeuleGridCPid',hidden: true ,sortable : true,align : 'center' }
			, { header : '��ͬ', width : 100, dataIndex : 'ModeuleGridContract',sortable : true,align : 'center' }
			, { header : '��ͬid', width : 100, dataIndex : 'ModeuleGridContractid',hidden: true ,sortable : true,align : 'center' }
			, { header : '����', width : 100, dataIndex : 'ModeuleGridGroup',sortable : true,align : 'center' }
			, { header : '����id', width : 100, dataIndex : 'ModeuleGridGroupid',hidden: true ,sortable : true,align : 'center' }
			, { header : '�汾��', width : 100, dataIndex : 'ModeuleGridStandby1', sortable : true, align : 'center' }
			, { header : '������Ʒ��', width : 100, dataIndex : 'ModeuleGridProduct',sortable : true,align : 'center' }
			, { header : '��Ʒ������', width : 100, dataIndex : 'ModeuleGridStandby2',align : 'center'}
			, { header : '��Ŀ����', width : 100, dataIndex : 'ModeuleGridProduct1',sortable : true,align : 'center' }
			, { header : 'ģ��״̬', width : 100, dataIndex : 'ModeuleGridStatus',sortable : true,align : 'center' }
			, { header : '�ƻ���������', width : 150, dataIndex : 'ModeuleGridPlanDate',sortable : true,align : 'center' }
			, { header : 'ʵ����������', width : 150, dataIndex : 'ModeuleGridActuclDate',sortable : true,align : 'center' }
			, { header : '��ע', width : 150, dataIndex : 'ModeuleGridRemark',sortable : true,align : 'center' }
			, { header : '�Ƿ�������', width : 150, dataIndex : 'ModeuleGridImpro',hidden:true,sortable : true,align : 'center' }
			, { header : "����",width : 100,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("ModeuleGridImpro")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>�鿴����</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   return strRet;
			   }}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ModeuleGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} ���ƣ� {2}',
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
	obj.ModeulePanal=new Ext.Panel({
			id : 'ModeulePanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,title:'ģ�����'
			,items:[obj.ModeuleGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.ModeulePanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.ModeuleGridStore.removeAll();
	obj.ModeuleGridStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
//ģ����ϸ��Ϣ������¡�����
function ModeuleMenuWind(){
    var obj = new Object();
	obj.ModeuleProNameStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeuleProNameStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
    obj.ModPerJStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModPerJStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
    obj.ModStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeuleStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeulePerTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeulePerType'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeulePerPCStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeulePerPCStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeulePerContractStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeulePerContractStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeulePerGroupStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeulePerGroupStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ModeulePerPCStore.load();
	obj.ModeulePerContractStore.load();
	obj.ModeulePerGroupStore.load();
    obj.ModeuleProNameStore.load();
	obj.ModPerJStore.load();
	obj.ModeulePerTypeStore.load();
	obj.ModStatusStore.load();
	obj.ModRowid= new Ext.form.TextField({
		id : 'ModRowid'
		,width : 40
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModFlag	= new Ext.form.TextField({
		id : 'ModFlag'
		,width : 40
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		//,editable : true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModName= new Ext.form.TextField({
		id : 'ModName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ������'
		//,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModCode = new Ext.form.TextField({
		id : 'ModCode'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ModProName= new Ext.form.ComboBox({
		id : 'ModProName'
		,width : 100
		//,minChars : 1
		,fieldLabel : '��Ŀ����'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.ModeuleProNameStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModSdy1= new Ext.form.TextField({
		id : 'ModSdy1'
		,width : 100
		//,minChars : 1
		,fieldLabel : '�汾��'
        ,displayField : 'desc'   //������ʾֵ
		//,editable : true
		//,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModPerJ= new Ext.form.ComboBox({
		id : 'ModPerJ'
		,width : 100
		//,minChars : 1
		,fieldLabel : '��Ʒ��'
		,mode : 'local'
		//triggerAction : 'all', 
		,store: obj.ModPerJStore    
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModPerUser= new Ext.form.TextField({
		id : 'ModPerUser'
		,width : 100
		//,minChars : 1
		,fieldLabel : '������'
		//triggerAction : 'all', 
        ,displayField : 'desc'   //������ʾֵ
		//,editable : true
		//,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModStatus= new Ext.form.ComboBox({
		id : 'ModStatus'
		,width : 100
		,minChars : 1
		,fieldLabel : 'ģ��״̬'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store: obj.ModStatusStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModPanDate= new Ext.form.DateField({
		id : 'ModPanDate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƻ�����'
		,enableKeyEvents : true
	    //,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	   //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModDate= new Ext.form.DateField({
		id : 'ModDate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ʵ������'
		,enableKeyEvents : true
	    //,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	   //,value:new Date().add(Date.DAY,0)
		,editable : true
		,maxValue:new Date()
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModEar = new Ext.form.TextArea({
		id : 'ModEar'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��ע��Ϣ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModProPC= new Ext.form.ComboBox({
		id : 'ModProPC'
		,width : 100
		//,minChars : 1
		,fieldLabel : '��Ʒ����'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.ModeulePerPCStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModProContract= new Ext.form.ComboBox({
		id : 'ModProContract'
		,width : 100
		//,minChars : 1
		,fieldLabel : '��ͬ����'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.ModeulePerContractStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModProGroup= new Ext.form.ComboBox({
		id : 'ModProGroup'
		,width : 100
		//,minChars : 1
		,fieldLabel : 'ģ�����'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.ModeulePerGroupStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ModAdd = new Ext.Button({
		id : 'ModAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ModDelete = new Ext.Button({
		id : 'ModDelete'
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
		
		,frame : true
		,items:[{   // ��1
                layout : "column",         // �������ҵĲ���
				labelWidth:60,
                items : [{
                          columnWidth : .5       // ��������������ռ�ٷֱ�
                          ,layout : "form"       // �������µĲ���
                          ,items : [obj.ModRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ModFlag]
                         }]
                },{ // ��4
                layout : "column", 
                labelWidth:60,				
                items : [{
                          columnWidth : .5     
                          ,layout : "form"     
                          ,items : [obj.ModProContract]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ModProGroup]
                         }]
                },{ // ��5
                layout : "column", 
                labelWidth:60,				
                items : [{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ModPerUser]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ModStatus]
                         }]
                },{ // ��5
                layout : "column", 
                labelWidth:60,				
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ModPanDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ModDate]
                         }]
                },{ // ��2
                layout : "column",   
                labelWidth:60,				
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.ModCode]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ModName]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ModSdy1]
                         }]
                },{ // ��3
                layout : "column",   
                labelWidth:60,				
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.ModProName]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ModProPC]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ModPerJ]
                         }]
                },{ // ��6
                layout : "column",
                labelWidth:60,				
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.ModEar]
                         }]
                }]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 350
		,buttonAlign : 'center'
		,width : 560
		,modal : true
		,title : 'ģ����ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.ModAdd
			  ,obj.ModDelete
		]
	});
	ModeuleMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
