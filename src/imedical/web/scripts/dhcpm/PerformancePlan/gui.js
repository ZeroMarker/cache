//Create by zzp
// 20150519
//����ƻ�����
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.PlanCode= new Ext.form.TextField({
		id : 'PlanCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƻ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PlanDesc= new Ext.form.TextField({
		id : 'PlanDesc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƻ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PlanRowid= new Ext.form.TextField({
		id : 'PlanRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,hidden:true
	});
	obj.PlanAdd = new Ext.Button({
		id : 'PlanAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PlanUpdate = new Ext.Button({
		id : 'PlanUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.PlanQuery = new Ext.Button({
		id : 'PlanQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.PlanBatch = new Ext.Button({
		id : 'PlanBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('�ƻ����룺'),obj.PlanCode,new Ext.Toolbar.TextItem('�ƻ����ƣ�'),obj.PlanDesc,'-',obj.PlanQuery,'-',obj.PlanBatch,'-',obj.PlanUpdate,'-',obj.PlanAdd,obj.PlanRowid]
			});
	
	//****************************** End ****************************
	obj.Plantree = new Ext.tree.TreePanel({
	            id:'Plantree',
	           // border:false,
			   region : 'west',
				width:250,
				height:500,
				title:'�ƻ��ṹͼ',
				tbar:obj.tbmode,
    			//animate:true,
    			enableDD:false,
    			containerScroll:true,
				//loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=DirTree'}),
		        loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=Plantree&TYPE='+'206'}),
		        rootVisible:false,
		        //lines:false,
		        //autoScroll:true,
		        root: new Ext.tree.AsyncTreeNode({
		        text: 'text',
				id:'id',
		        expanded:true
				})
	});
	//--------------------------------------------------------------------
	obj.PlanGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PlanGridStore = new Ext.data.Store({
		proxy: obj.PlanGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['PPPGridRowid'
		,'PPPGridCode'
		,'PPPGridDesc'
		,'PPPGridPlanStartDate'
		,'PPPGridPlanStartTime'
		,'PPPGridStartDate'
		,'PPPGridStartTime'
		,'PPPGridPlanEndDate'
		,'PPPGridPlanEndTime'
		,'PPPGridEndDate'
		,'PPPGridEndTime'
		,'PPPGridStatus'
		,'PPPGridStatusid'
		,'PPPGridImprovment'
		,'PPPGridImprovmentid'
		,'PPPGridJobLogg'
		,'PPPGridJobLoggid'
		,'PPPGridModule'
		,'PPPGridModuleid'
		,'PPPGridContractAging'
		,'PPPGridContractAgingid'
		,'PPPGridContract'
		,'PPPGridContractid'
		,'PPPGridAdjuc'
		,'PPPGridMenu'
		,'PPPGridRemark'])
		
	});
	obj.PlanGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'PlanGridStore';
			param.Arg1 = obj.PlanRowid.getRawValue();
			param.Arg2 = obj.PlanCode.getRawValue();
			param.Arg3 = obj.PlanDesc.getRawValue();
			param.ArgCnt = 3;
	});
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ContractGridPanel = new Ext.grid.GridPanel({
		id : 'ContractGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		,region : 'center'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.PlanGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, {header : "����",width : 200,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("PPPGridAdjuc")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��ϸ�鿴</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='ContractUser'>������</a>";
			   formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Download'>��������</a>"; 
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��ϸ�鿴</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='ContractUser'>������</a>";
			   formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Download'>��������</a>"; 
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'PPPGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '�ƻ�����', width : 150, dataIndex : 'PPPGridCode', sortable : false, align : 'center',editable: true }
			, { header : '�ƻ�����', width : 200, dataIndex : 'PPPGridDesc', sortable : false ,align : 'center'}
			, { header : '�ƻ���ʼ����', width : 100, dataIndex : 'PPPGridPlanStartDate', sortable : true, align : 'center' }
			, { header : '�ƻ���ʼʱ��', width : 100, dataIndex : 'PPPGridPlanStartTime',sortable : true,align : 'center' }
			, { header : 'ʵ�ʿ�ʼ����', width : 100, dataIndex : 'PPPGridStartDate',sortable : true,align : 'center'}
			, { header : 'ʵ�ʿ�ʼʱ��', width : 100, dataIndex : 'PPPGridStartTime', sortable : true, align : 'center' }
			, { header : '�ƻ���������', width : 100, dataIndex : 'PPPGridPlanEndDate', sortable : true, align : 'center' }
			, { header : '�ƻ�����ʱ��', width : 100, dataIndex : 'PPPGridPlanEndTime', sortable : true, align : 'center' }
			, { header : 'ʵ�ʽ�������', width : 100, dataIndex : 'PPPGridEndDate', sortable : true, align : 'center' }
			, { header : 'ʵ�ʽ���ʱ��', width : 100, dataIndex : 'PPPGridEndTime', sortable : true, align : 'center' }
			, { header : '�ƻ�״̬', width : 100, dataIndex : 'PPPGridStatus', sortable : true, align : 'center' }
			, { header : '�ƻ�״̬id', width : 100, dataIndex : 'PPPGridStatusid',hidden:true, sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'PPPGridImprovment', sortable : true, align : 'center' }
			, { header : '��������id', width : 100, dataIndex : 'PPPGridImprovmentid', hidden:true,sortable : true, align : 'center' }
			, { header : '������¼', width : 100, dataIndex : 'PPPGridJobLogg', sortable : true, align : 'center' }
			, { header : '������¼id', width : 100, dataIndex : 'PPPGridJobLoggid',hidden:true, sortable : true, align : 'center' }
			, { header : '����ģ��', width : 100, dataIndex : 'PPPGridModule', sortable : true, align : 'center' }
			, { header : '����ģ��id', width : 100, dataIndex : 'PPPGridModuleid', sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'PPPGridContractAging', sortable : true, align : 'center' }
			, { header : '��������id', width : 100, dataIndex : 'PPPGridContractAgingid', sortable : true, align : 'center' }
			, { header : '������ͬ', width : 100, dataIndex : 'PPPGridContract', sortable : true, align : 'center' }
			, { header : '������ͬid', width : 100, dataIndex : 'PPPGridContractid', sortable : true, align : 'center' }
			, { header : '������־', width : 100, dataIndex : 'PPPGridAdjuc', sortable : true, align : 'center' }
			, { header : '��Ҫ����', width : 100, dataIndex : 'PPPGridMenu', sortable : true, align : 'center' }
			, { header : '��ע��Ϣ', width : 100, dataIndex : 'PPPGridRemark', sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PlanGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
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
	obj.PlanPanal=new Ext.Panel({
			id : 'PlanPanal'
			,layout : 'border'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.ContractGridPanel]
		});

	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.Plantree
		          ,obj.PlanPanal]});
	
	//--------------------------------------------------------------------------------------------
	
	obj.PlanGridStore.removeAll();
	obj.PlanGridStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
//������ϸ����
function PPPMenuWind(){
    var obj = new Object();
	obj.PPPMenuStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=PPPMenuStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuStatusStore.load()
	obj.PPPMenuIMPROStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ObIpmlboxstore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuIMPROStore.load();
	obj.PPPJobStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=PPPJobStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPJobStore.load();
	obj.PPPMenuModeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=PPPMenuModeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuModeStore.load();
	obj.PPPMenuContractAgingStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=PPPMenuContractAgingStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuContractAgingStore.load();
	obj.PPPMenuContractStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAgingContractStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuContractStore.load();
	obj.PPPMenuUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=DepartUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PPPMenuUserStore.load();
	obj.PPPMenuRowid= new Ext.form.TextField({
		id : 'PPPMenuRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ID'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.PPPMenuFlag	= new Ext.form.TextField({
		id : 'PPPMenuFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuCode	= new Ext.form.TextField({
		id : 'PPPMenuCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƻ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuDesc = new Ext.form.TextField({
		id : 'PPPMenuDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƻ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuStatus = new Ext.form.ComboBox({
		id : 'PPPMenuStatus'
		,width : 100
		,store : obj.PPPMenuStatusStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�ƻ�״̬'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuImpro = new Ext.form.ComboBox({
		id : 'PPPMenuImpro'
		,width : 100
		,store : obj.PPPMenuIMPROStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuJob = new Ext.form.ComboBox({
		id : 'PPPMenuJob'
		,width : 100
		,store : obj.PPPJobStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '������¼'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuMode = new Ext.form.ComboBox({
		id : 'PPPMenuMode'
		,width : 100
		,store : obj.PPPMenuModeStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '����ģ��'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuContractAging = new Ext.form.ComboBox({
		id : 'PPPMenuContractAging'
		,width : 100
		,store : obj.PPPMenuContractAgingStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuContract = new Ext.form.ComboBox({
		id : 'PPPMenuContract'
		,width : 100
		,store : obj.PPPMenuContractStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '������ͬ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuUser = new Ext.form.ComboBox({
		id : 'PPPMenuUser'
		,width : 100
		,store : obj.PPPMenuUserStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�����û�'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuPlanStartDate = new Ext.form.DateField({
		id : 'PPPMenuPlanStartDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƿ�����'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuPlanStartTime = new Ext.form.TimeField({
		id : 'PPPMenuPlanStartTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƿ�ʱ��'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuStartDate = new Ext.form.DateField({
		id : 'PPPMenuStartDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ʵ������'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuStartTime= new Ext.form.TimeField({
		id : 'PPPMenuStartTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ʵ��ʱ��'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuPlanEndDate = new Ext.form.DateField({
		id : 'PPPMenuPlanEndDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƽ�����'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuPlanEndTime= new Ext.form.TimeField({
		id : 'PPPMenuPlanEndTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ƽ�ʱ��'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuEndDate = new Ext.form.DateField({
		id : 'PPPMenuEndDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ʵ������'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PPPMenuEndTime= new Ext.form.TimeField({
		id : 'PPPMenuEndTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ʵ��ʱ��'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuMenu = new Ext.form.TextArea({
		id : 'PPPMenuMenu'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��Ҫ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuRemark = new Ext.form.TextArea({
		id : 'PPPMenuRemark'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��ע��Ϣ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PPPMenuAdd = new Ext.Button({
		id : 'PPPMenuAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PPPMenuDelete = new Ext.Button({
		id : 'PPPMenuDelete'
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
		//,hideLabel:false
		,labelAlign : "right"
		,labelWidth:60
		,frame : true
		,items:[{   // ��1
                layout : "column",         // �������ҵĲ���
                items : [{
                          columnWidth : .5       // ��������������ռ�ٷֱ�
                          ,layout : "form"       // �������µĲ���
                          ,items : [obj.PPPMenuRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuCode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuDesc]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuPlanStartDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuPlanStartTime]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuStartDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuStartTime]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuPlanEndDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuPlanEndTime]
                         }]
                },{ // ��6
                layout : "column",        
                items : [{
                          columnWidth : .5     
                          ,layout : "form"     
                          ,items : [obj.PPPMenuEndDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PPPMenuEndTime]
                         }]
                },{ // ��7
                layout : "column",        
                items : [{
                          columnWidth : .33     
                          ,layout : "form"     
                          ,items : [obj.PPPMenuStatus]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.PPPMenuImpro]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.PPPMenuJob]
                         }]
                },{ // ��8
                layout : "column",        
                items : [{
                          columnWidth : .33     
                          ,layout : "form"     
                          ,items : [obj.PPPMenuContractAging]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.PPPMenuMode]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.PPPMenuContract]
                         }]
                },{ // ��9
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuUser]
                         }]
                },{ // ��10
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuMenu]
                         }]
                },{ // ��11
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.PPPMenuRemark]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 540
		,buttonAlign : 'center'
		,width : 530
		,modal : true
		,title : '�ƻ���ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.PPPMenuAdd
			  ,obj.PPPMenuDelete
		]
	});
	ContractMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}


	/**************************************�����˹���***************************************/
function ResponsUserWind(MainObj){	
	var obj = new Object();
	obj.ResponsRowid = new Ext.form.TextField({
		id : 'ResponsRowid'
		,hidden : true
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ID'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.ResponsUser = new Ext.form.TextField({
		id : 'ResponsUser'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '������Ա'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ResponsCreatUser = new Ext.form.TextField({
		id : 'ResponsCreatUser'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '������Ա'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.ResponsMainPlan = new Ext.form.TextField({
		id : 'ResponsMainPlan'
		,hideLabel : true
		,hide : true
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�����ƻ�'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.ResponsPlanRowID = new Ext.form.TextField({
		id : 'ResponsPlanRowID'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�����ƻ�ID'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.ResponsInDate = new Ext.form.DateField({
		id : 'ResponsInDate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ʼ����'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.ResponsOutDate=new Ext.form.DateField
		({
			id : 'ResponsOutDate'
			,width : 100
			,minChars : 1
			,displayField : 'desc'
			,fieldLabel : '��������'
			,format:'Y-m-d H:i:s'
			,value:new Date()
			,editable : true
			,disabled:true
			,triggerAction : 'all'
			,anchor : '99%'
		});
	
	obj.ResponsUserQuery = new Ext.Button({
		id : 'ResponsUserQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.ResponsUserBatch = new Ext.Button({
		id : 'ResponsUserBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	
	obj.ResponsUserAdd = new Ext.Button
		({
			id : 'ResponsUserAdd'
			,iconCls : 'icon-add'
			,text : '���������'
		});

	obj.ResponsUserDelete = new Ext.Button
		({
			id : 'ResponsUserDelete'
			,iconCls : 'icon-delete'
			,text : 'ɾ��������'
		});
		
	/**��ɾ�Ĺ�����**/
	obj.ResponsUserbar = new Ext.Toolbar
		({
		    id:'ResponsUserbar',
			enableOverflow : true,
			items : [obj.ResponsUserAdd,'-',obj.ResponsUserDelete,'-',obj.ResponsRowid]
		});
	obj.ResponsUserGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ResponsUserGridStore = new Ext.data.Store
	({
		proxy: obj.ResponsUserGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, ['ResponsGridRowid',
			'ResponsGridUser',
			'ResponsGridMainPlan',
			'ResponsGridInDate',
			'ResponsGridOutDate',
			'ResponsGridCreatUser',
			'ResponsGridPlanRowID'])
		
	});
	obj.ResponsUserGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ResponsUserGridStore';
			param.Arg1 = obj.ResponsRowid.getRawValue();
			param.ArgCnt = 1;
	});
	obj.gridResponsUserCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ResponsUserGridPanel = new Ext.grid.GridPanel({
		id : 'ResponsUserGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,width : 1200
		,height : 280
		,plugins : obj.gridResponsUserCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,editable: true
		,store : obj.ResponsUserGridStore
		,tbar:obj.ResponsUserbar
		,columns: 
		[
			new Ext.grid.RowNumberer()
			, { header : 'Rowid', width : 100, dataIndex : 'ResponsGridRowid', sortable : true ,hidden: true ,align : 'center'}
			, { header : '������Ա', width : 150, dataIndex : 'ResponsGridUser', sortable : true ,align : 'center'}
			, { header : '�����ƻ�', width : 150, dataIndex : 'ResponsGridMainPlan', sortable : true, align : 'center' }
			, { header : '��ʼ����', width : 150, dataIndex : 'ResponsGridInDate',sortable : true,align : 'center' }
			, { header : '��������', width : 150, dataIndex : 'ResponsGridOutDate',sortable : true,align : 'center' }
			, { header : '������Ա', width : 150, dataIndex : 'ResponsGridCreatUser',sortable : true,align : 'center' }
			, { header : '�ƻ�ID', width : 150, dataIndex : 'ResponsGridPlanRowID',sortable : true,align : 'center' }
		]		
		,bbar: new Ext.PagingToolbar
			({
				pageSize : 20,
				store : obj.ResponsUserGridStore,
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

	
	/********************************************����ܹ�***************************************************/
    obj.MainFrmPanal=new Ext.Panel({
			id : 'MainFrmPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.ResponsUserGridPanel]
		});
    obj.menuwindResponsAd = new Ext.Window({
		id : 'menuwindResponsAd'
		,height : 360
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '�����˹���'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.MainFrmPanal
		]
	});
	
	/********************************************�¼�����***************************************************/ 
	ResponsUserWindEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function PUUserModAddUpWind(){
    var obj = new Object();
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objAudit.HisVersions();
	if(HisVersions=="1"){
	 obj.AddModeUserNameStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PermissionUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	}
	else{
	obj.AddModeUserNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AddModeUserNameStore = new Ext.data.Store({
		proxy: obj.AddModeUserNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['RowId'
		,'Description'])
	});
	obj.AddModeUserNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'DepartUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});
	};
    obj.AddModeUserNameStore.load();
	obj.AddModeRowid= new Ext.form.TextField({
		id : 'AddModeRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'    //1@@2
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.AddModeFlag= new Ext.form.TextField({
		id : 'AddModeFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.AddModePlanName= new Ext.form.TextField({
		id : 'AddModePlanName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.AddModeUserName= new Ext.form.ComboBox({
		id : 'AddModeUserName'
		,width : 100
		,mode:'local'
		,store:obj.AddModeUserNameStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '������Ա'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,listeners:{
        	beforequery : function(e){
            	var combo = e.combo;
                if(!e.forceAll){
                	var value = e.query;
                	combo.store.filterBy(function(record,id){
                		var text = record.get(combo.displayField);
                		return (text.indexOf(value)!=-1);
                	});
                	combo.expand();
                	return false;
                }
        	}
        }
	});
	
	obj.AddModeInDate = new Ext.form.DateField({
		id : 'AddModeInDate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ʼ����'
		,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	    ,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});

	obj.AddModeOutDate = new Ext.form.DateField({
		id : 'AddModeOutDate'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,format:'Y-m-d'
	    ,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});

	obj.AddModeAdd = new Ext.Button({
		id : 'AddModeAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.AddModeDelete = new Ext.Button({
		id : 'AddModeDelete'
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
		,labelWidth:60
		,frame : true
		,items:[{   // ��1
                layout : "column",         
                items : [{
                          columnWidth : .5       
                          ,layout : "form"       
                          ,items : [obj.AddModeFlag]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.AddModeUserName]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.AddModeInDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.AddModeOutDate]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 160
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '���������Ա'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.AddModeAdd
			  ,obj.AddModeDelete
		]
	});
    PUUserModAddUpWindEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
