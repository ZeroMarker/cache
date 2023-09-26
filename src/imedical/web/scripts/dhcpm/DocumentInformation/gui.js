//Create by zzp
// 20150515
//��ͬ��Ϣ����
function InitviewScreen(){
	var obj = new Object();
	obj.ContractStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractStatusStore.load();
	//******************************Start****************************
	obj.ContractCode= new Ext.form.TextField({
		id : 'ContractCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.Contractid= new Ext.form.TextField({
		id : 'Contractid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'idd'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractName= new Ext.form.TextField({
		id : 'ContractName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.ContractMenu = new Ext.form.TextField({
		id : 'ContractMenu'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��Ҫ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractStatus= new Ext.form.ComboBox({
		id : 'ContractStatus'
		,width : 100
		,minChars : 1
		,store : obj.ContractStatusStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��ͬ״̬'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractAdd = new Ext.Button({
		id : 'ContractAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ContractUpdate = new Ext.Button({
		id : 'ContractUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.ContractDelete = new Ext.Button({
		id : 'ContractDelete'
		,iconCls : 'icon-Delete'
		,text : 'ɾ��'
	});
	obj.ContractQuery = new Ext.Button({
		id : 'ContractQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.ContractBatch = new Ext.Button({
		id : 'ContractBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.ContractAdd, '-', obj.ContractUpdate,'-',obj.ContractDelete]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('��ͬ���룺'),obj.ContractCode,'-',new Ext.Toolbar.TextItem('��ͬ���ƣ�'),obj.ContractName,'-',new Ext.Toolbar.TextItem('��Ҫ���ݣ�'),obj.ContractMenu,'-',new Ext.Toolbar.TextItem('��ͬ״̬��'),obj.ContractStatus,'-',obj.ContractQuery,'-',obj.ContractBatch,obj.Contractid],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.ContractGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.ContractGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ContractGridStore = new Ext.data.Store({
		proxy: obj.ContractGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ContractGridRowid'
		,'ContractGridCode'
		,'ContractGridDesc'
		,'ContractGridGroup'
		,'ContractGridGroupid'
		,'ContractGridType'
		,'ContractGridTypeid'
		,'ContractGridPrincipal'
		,'ContractGridContractDate'
		,'ContractGridContractTime'
		,'ContractGridEffectiveDate'
		,'ContractGridEffectiveTime'
		,'ContractGridStatus'
		,'ContractGridStatusid'
		,'ContractGridFParty'
		,'ContractGridFPartyid'
		,'ContractGridFUser'
		,'ContractGridSParty'
		,'ContractGridSPartyid'
		,'ContractGridSUser'
		,'ContractGridTParty'
		,'ContractGridTPartyid'
		,'ContractGridTUser'
		,'ContractGridModeE'
		,'ContractGridModeEid'
		,'ContractGridCondeM'
		,'ContractGridCondeMid'
		,'ContractGridSource'
		,'ContractGridSourceid'
		,'ContractGridDepartment'
		,'ContractGridTotalMone'
		,'ContractGridFinishDate'
		,'ContractGridFinishTime'
		,'ContractGridMenu'
		,'ContractGridAbnormal'
		,'ContractGridPigeonhol'
		,'ContractGridElecticC'
		,'ContractGridRemark'
		,'ContractGridDate'
		,'ContractGridTime'
		,'ContractGridUser'])
	});
	obj.ContractGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ContractGridStore';
			param.Arg1 = obj.ContractCode.getRawValue();
			param.Arg2 = obj.ContractName.getRawValue();
			param.Arg3 = obj.ContractMenu.getRawValue();   
			param.Arg4 = obj.ContractStatus.getValue();   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 4;
	});
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ContractGridPanel = new Ext.grid.GridPanel({
		id : 'ContractGridPanel'
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
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ContractGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, {header : "����",width : 250,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("ContractGridElecticC")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��ϸ�鿴</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='EditDetail'>����ά��</a>";
               formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Download'>��������</a>"; 			   
			   formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='RelevancyMode'>����ģ��</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>��ϸ�鿴</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='EditDetail'>����ά��</a>";
			   formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='RelevancyMode'>����ģ��</a>";
			   formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Download'>��������</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'ContractGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��ͬ����', width : 150, dataIndex : 'ContractGridCode', sortable : false, align : 'center',editable: true }
			, { header : '��ͬ����', width : 200, dataIndex : 'ContractGridDesc', sortable : false ,align : 'center'}
			, { header : '��ͬ����', width : 100, dataIndex : 'ContractGridGroup', sortable : true, align : 'center' }
			, { header : '��ͬ����id', width : 100, dataIndex : 'ContractGridGroupid',hidden: true ,sortable : true,align : 'center' }
			, { header : '��ͬ����', width : 100, dataIndex : 'ContractGridType',sortable : true,align : 'center'}
			, { header : '��ͬ����id', width : 100, dataIndex : 'ContractGridTypeid', hidden: true ,sortable : true, align : 'center' }
			, { header : '������', width : 100, dataIndex : 'ContractGridPrincipal', sortable : true, align : 'center' }
			, { header : 'ǩ������', width : 100, dataIndex : 'ContractGridContractDate', sortable : true, align : 'center' }
			, { header : 'ǩ��ʱ��', width : 100, dataIndex : 'ContractGridContractTime', sortable : true, align : 'center' }
			, { header : '��Ч����', width : 100, dataIndex : 'ContractGridEffectiveDate', sortable : true, align : 'center' }
			, { header : '��Чʱ��', width : 100, dataIndex : 'ContractGridEffectiveTime', sortable : true, align : 'center' }
			, { header : '��ͬ״̬', width : 100, dataIndex : 'ContractGridStatus', sortable : true, align : 'center' }
			, { header : '��ͬ״̬id', width : 100, dataIndex : 'ContractGridStatusid', hidden: true ,sortable : true, align : 'center' }
			, { header : '�׷���λ', width : 100, dataIndex : 'ContractGridFParty', sortable : true, align : 'center' }
			, { header : '�׷���λid', width : 100, dataIndex : 'ContractGridFPartyid', hidden: true ,sortable : true, align : 'center' }
			, { header : '�׷�������', width : 100, dataIndex : 'ContractGridFUser', sortable : true, align : 'center' }
			, { header : '�ҷ���λ', width : 100, dataIndex : 'ContractGridSParty', sortable : true, align : 'center' }
			, { header : '�ҷ���λid', width : 100, dataIndex : 'ContractGridSPartyid', hidden: true ,sortable : true, align : 'center' }
			, { header : '�ҷ�������', width : 100, dataIndex : 'ContractGridSUser', sortable : true, align : 'center' }
			, { header : '������λ', width : 100, dataIndex : 'ContractGridTParty', sortable : true, align : 'center' }
			, { header : '������λid', width : 100, dataIndex : 'ContractGridTPartyid', hidden: true ,sortable : true, align : 'center' }
			, { header : '����������', width : 100, dataIndex : 'ContractGridTUser', sortable : true, align : 'center' }
			, { header : '���з�ʽ', width : 100, dataIndex : 'ContractGridModeE', sortable : true, align : 'center' }
			, { header : '���з�ʽid', width : 100, dataIndex : 'ContractGridModeEid', hidden: true ,sortable : true, align : 'center' }
			, { header : '������ʽ', width : 100, dataIndex : 'ContractGridCondeM', sortable : true, align : 'center' }
			, { header : '������ʽid', width : 100, dataIndex : 'ContractGridCondeMid', hidden: true ,sortable : true, align : 'center' }
			, { header : '�ɹ���Դ', width : 100, dataIndex : 'ContractGridSource', sortable : true, align : 'center' }
			, { header : '�ɹ���Դid', width : 100, dataIndex : 'ContractGridSourceid', hidden: true ,sortable : true, align : 'center' }
			, { header : '����', width : 100, dataIndex : 'ContractGridDepartment', sortable : true, align : 'center' }
			, { header : '�ܽ��', width : 100, dataIndex : 'ContractGridTotalMone', sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'ContractGridFinishDate', sortable : true, align : 'center' }
			, { header : '����ʱ��', width : 100, dataIndex : 'ContractGridFinishTime', sortable : true, align : 'center' }
			, { header : '��Ҫ����', width : 100, dataIndex : 'ContractGridMenu', sortable : true, align : 'center' }
			, { header : '�쳣����', width : 100, dataIndex : 'ContractGridAbnormal', sortable : true, align : 'center' }
			, { header : '�Ƿ�鵵', width : 100, dataIndex : 'ContractGridPigeonhol', sortable : true, align : 'center' }
			, { header : '���Ӻ�ͬ', width : 100, dataIndex : 'ContractGridElecticC', hidden: true ,sortable : true, align : 'center' }
			, { header : '��ע', width : 100, dataIndex : 'ContractGridRemark', sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'ContractGridDate', sortable : true, align : 'center' }
			, { header : '����ʱ��', width : 100, dataIndex : 'ContractGridTime', sortable : true, align : 'center' }
			, { header : '������', width : 100, dataIndex : 'ContractGridUser', sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ContractGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			scrollOffset: 0
			,enableRpwBody : true
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
	obj.ContractPanal=new Ext.Panel({
			id : 'ContractPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.ContractGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.ContractPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.ContractGridStore.removeAll();
	obj.ContractGridStore.load({params : {start:0,limit:22}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

//��ͬģ�����ݽ���
function ContractMenuWind(){
    var obj = new Object();
	obj.ContractMenuSupplierStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractSupplierStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuModeEStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractMenuModeEStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuGroupStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractGroupStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractMenuTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuCModeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractMenuCModeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuSourceStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractMenuSourceStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuCurrencyStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractMenuCurrencyStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractMenuStatusStore.load()
	obj.ContractMenuModeEStore.load();
	obj.ContractMenuSupplierStore.load();
	obj.ContractMenuGroupStore.load();
	obj.ContractMenuTypeStore.load();
	obj.ContractMenuCModeStore.load();
	obj.ContractMenuSourceStore.load();
	obj.ContractMenuCurrencyStore.load();
	obj.ContractRowid= new Ext.form.TextField({
		id : 'ContractRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬID'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.ContractFlag	= new Ext.form.TextField({
		id : 'ContractFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractMenuCode	= new Ext.form.TextField({
		id : 'ContractMenuCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractMenuDesc = new Ext.form.TextField({
		id : 'ContractMenuDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuStatus = new Ext.form.ComboBox({
		id : 'ContractMenuStatus'
		,width : 100
		,store : obj.ContractMenuStatusStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��ͬ״̬'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuGroup = new Ext.form.ComboBox({
		id : 'ContractMenuGroup'
		,width : 100
		,store : obj.ContractMenuGroupStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��ͬ����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuType = new Ext.form.ComboBox({
		id : 'ContractMenuType'
		,width : 100
		,store : obj.ContractMenuTypeStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '��ͬ����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuPrincipal = new Ext.form.TextField({
		id : 'ContractMenuPrincipal'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�� �� ��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuContractDate = new Ext.form.DateField({
		id : 'ContractMenuContractDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ǩ������'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuContractTime = new Ext.form.TimeField({
		id : 'ContractMenuContractTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ǩ��ʱ��'
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
	obj.ContractMenuEffectiveDate = new Ext.form.DateField({
		id : 'ContractMenuEffectiveDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��Ч����'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuEffectiveTime= new Ext.form.TimeField({
		id : 'ContractMenuEffectiveTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��Чʱ��'
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
	obj.ContractMenuFirstParty = new Ext.form.ComboBox({
		id : 'ContractMenuFirstParty'
		,width : 100
		,store : obj.ContractMenuSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�׷���λ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuFirstUser = new Ext.form.TextField({
		id : 'ContractMenuFirstUser'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //������ʾֵ
		,fieldLabel : '�׷�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuSecondParty = new Ext.form.ComboBox({
		id : 'ContractMenuSecondParty'
		,width : 100
		,store : obj.ContractMenuSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�ҷ���λ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuSecondUser = new Ext.form.TextField({
		id : 'ContractMenuSecondUser'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //������ʾֵ
		,fieldLabel : '�ҷ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuThirdParty = new Ext.form.ComboBox({
		id : 'ContractMenuThirdParty'
		,width : 100
		,store : obj.ContractMenuSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '������λ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuThirdUser = new Ext.form.TextField({
		id : 'ContractMenuThirdUser'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //������ʾֵ
		,fieldLabel : '��������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuModeE = new Ext.form.ComboBox({
		id : 'ContractMenuModeE'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.ContractMenuModeEStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '���з�ʽ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuCMode = new Ext.form.ComboBox({
		id : 'ContractMenuCMode'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.ContractMenuCModeStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : 'ǩ����ʽ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuSource = new Ext.form.ComboBox({
		id : 'ContractMenuSource'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.ContractMenuSourceStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�ɹ���Դ'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuDepartment = new Ext.form.TextField({
		id : 'ContractMenuDepartment'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //������ʾֵ
		,fieldLabel : '�ɹ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuTotalMoney = new Ext.form.TextField({
		id : 'ContractMenuTotalMoney'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //������ʾֵ
		,fieldLabel : '�ɹ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuCurrency = new Ext.form.ComboBox({
		id : 'ContractMenuCurrency'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.ContractMenuCurrencyStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '�ɹ�����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuFinishDate = new Ext.form.DateField({
		id : 'ContractMenuFinishDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractMenuFinishTime = new Ext.form.TimeField({
		id : 'ContractMenuFinishTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����ʱ��'
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
	obj.ContractMenuMenu = new Ext.form.TextArea({
		id : 'ContractMenuMenu'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��Ҫ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractMenuAbnormal = new Ext.form.TextArea({
		id : 'ContractMenuAbnormal'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '�쳣����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractMenuRemark = new Ext.form.TextArea({
		id : 'ContractMenuRemark'
		//,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��ע��Ϣ'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractMenuAdd = new Ext.Button({
		id : 'ContractMenuAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ContractMenuDelete = new Ext.Button({
		id : 'ContractMenuDelete'
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
                layout : "column",         // �������ҵĲ���
                items : [{
                          columnWidth : .5       // ��������������ռ�ٷֱ�
                          ,layout : "form"       // �������µĲ���
                          ,items : [obj.ContractRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuCode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractMenuDesc]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuFirstParty]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractMenuFirstUser]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuSecondParty]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractMenuSecondUser]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuThirdParty]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractMenuThirdUser]
                         }]
                },{ // ��6
                layout : "column",        
                items : [{
                          columnWidth : .25      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuGroup]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuType]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuPrincipal]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuDepartment]
                         }]
                },{ // ��7
                layout : "column",        
                items : [{
                          columnWidth : .25      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuStatus]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuModeE]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuCMode]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuSource]
                         }]
                },{ // ��8
                layout : "column",        
                items : [{
                          columnWidth : .25     
                          ,layout : "form"     
                          ,items : [obj.ContractMenuContractDate]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuContractTime]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuEffectiveDate]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuEffectiveTime]
                         }]
                },{ // ��9
                layout : "column",        
                items : [{
                          columnWidth : .25      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuFinishDate]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuFinishTime]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuTotalMoney]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ContractMenuCurrency]
                         }]
                },{ // ��10
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuMenu]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ContractMenuAbnormal]
                         }]
                },{ // ��11
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.ContractMenuRemark]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 540
		,buttonAlign : 'center'
		,width : 730
		,modal : true
		,title : '��ͬ��ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.ContractMenuAdd
			  ,obj.ContractMenuDelete
		]
	});
	ContractMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}


function ContractModeWind(){
    var obj = new Object();
	//****************************** Start  **************************** 
	obj.ContractModeCode= new Ext.form.TextField({
		id : 'ContractModeCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractModeName= new Ext.form.TextField({
		id : 'ContractModeName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.ContractModRowid= new Ext.form.TextField({
		id : 'ContractModRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,hidden:true
		,valueField : 'rowid'
	});
	obj.ContractModeAdd = new Ext.Button({
		id : 'ContractModeAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ContractModeQuery = new Ext.Button({
		id : 'ContractModeQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.ContractModeBatch = new Ext.Button({
		id : 'ContractModeBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	obj.ContractModeReturn = new Ext.Button({
		id : 'ContractModeReturn'
		,iconCls : 'icon-Delete'
		,text : '����'
	});
	/** ���������� */
	obj.tbmode = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbmode',
				items : [new Ext.Toolbar.TextItem('ģ����룺'),obj.ContractModeCode,'-',new Ext.Toolbar.TextItem('ģ�����ƣ�'),obj.ContractModeName,'-',obj.ContractModeQuery,'-',obj.ContractModeBatch,'-',obj.ContractModeAdd,'-',obj.ContractModeReturn,obj.ContractModRowid]
			});
	
	//****************************** End ****************************
	obj.ContractModeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ContractModeStore = new Ext.data.Store({
		proxy: obj.ContractModeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ContractModeRowid'
		,'ContractModeCode'
		,'ContractModeDesc'
		,'ContractModeStandby3'
		,'ContractModeProduct'
		,'ContractModeAging'
		,'ContractModeStatus'
		,'ContractModePlanDate'
		,'ContractModePlanTime'
		,'ContractModeActDate'
		,'ContractModeActTime'
		,'ContractModeRemark'])
	});
	obj.ContractModeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ContractModeStore';
			param.Arg1 = obj.ContractModeCode.getRawValue();
			param.Arg2 = obj.ContractModeName.getRawValue();
			param.Arg3 = obj.ContractModRowid.getRawValue(); 
			param.ArgCnt = 3;
	});
	obj.gridContractModeCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked1', width: 40,checked:true });  //checkbox
	obj.ContractModePanel = new Ext.grid.GridPanel({
		id : 'ContractModePanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 600
		,height: 400
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridContractModeCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ContractModeStore
		,tbar:obj.tbmode
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractModeCheckCol
			, { header : 'Rowid', width : 150, dataIndex : 'ContractModeRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : 'ģ�����', width : 100, dataIndex : 'ContractModeCode', sortable : false, align : 'center',editable: true }
			, { header : 'ģ������', width : 100, dataIndex : 'ContractModeDesc', sortable : false ,align : 'center'}
			, { header : '��Ʒ', width : 100, dataIndex : 'ContractModeStandby3', sortable : true, align : 'center' }
			, { header : '��Ʒ��', width : 100, dataIndex : 'ContractModeProduct',sortable : true,align : 'center' }
			, { header : '����', width : 100, dataIndex : 'ContractModeAging',sortable : true,align : 'center' }
			, { header : 'ģ��״̬', width : 100, dataIndex : 'ContractModeStatus',sortable : true,align : 'center'}
			, { header : '�ƻ�����', width : 100, dataIndex : 'ContractModePlanDate', sortable : true, align : 'center' }
			, { header : '�ƻ�ʱ��', width : 100, dataIndex : 'ContractModePlanTime', sortable : true, align : 'center' }
			, { header : 'ʵ������', width : 100, dataIndex : 'ContractModeActDate', sortable : true, align : 'center' }
			, { header : 'ʵ��ʱ��', width : 100, dataIndex : 'ContractModeActTime', sortable : true, align : 'center' }
			, { header : '��ע��Ϣ', width : 100, dataIndex : 'ContractModeRemark', sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 10,
			store : obj.ContractModeStore,
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
	//--------------------------------------------------------------------
	obj.ContractPanalMode=new Ext.Panel({
			id : 'ContractPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.ContractModePanel]
		});
	obj.menuwindMode = new Ext.Window({
		id : 'menuwindMode'
		,height : 440
		,buttonAlign : 'center'
		,width : 830
		,modal : true
		,title : '����ģ��'
		,layout : 'form'
		,border:true
		,items:[
			   obj.ContractPanalMode
		]
	});
	//--------------------------------------------------------------------------------------------
	obj.ContractModeStore.removeAll();
	obj.ContractModeStore.load({params : {start:0,limit:10}});
	ContractModeWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
function ContractModeAddWind(){
    var obj = new Object();
	obj.ContractModeNStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ContractModeNStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ContractModeNStore.load();
	//****************************** Start  ****************************
	obj.ContractAddRowid= new Ext.form.TextField({
		id : 'ContractAddRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ͬID'
		,editable : true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractModeN= new Ext.form.ComboBox({
		id : 'ContractModeN'
		,width : 100
		,minChars : 1
		,store : obj.ContractModeNStore   
		,valueField : 'RowId'  //��ֵ̨
        ,displayField : 'Description'   //������ʾֵ
		,fieldLabel : '����ģ��'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ContractModeNAdd = new Ext.Button({
		id : 'ContractModeNAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ContractModeNDelete = new Ext.Button({
		id : 'ContractModeNDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	//****************************** End  ****************************
	obj.ContractPanalModeN=new Ext.Panel({
			id : 'ContractPanalModeN'
			,layout : 'form'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,frame:true
			,border:true
			,labelWidth:60
			,items:[obj.ContractAddRowid
			        ,obj.ContractModeN]
		});
		
	obj.menuwindModeN = new Ext.Window({
		id : 'menuwindModeN'
		,height : 140
		,buttonAlign : 'center'
		,width : 250
		,modal : true
		,title : '����ģ��'
		,layout : 'form'
		,border:true
		,items:[
			   obj.ContractPanalModeN
		]
		,buttons:[obj.ContractModeNAdd
		         ,obj.ContractModeNDelete]
	});
	ContractModeAddWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
function ContractDetailsWind(idd){
    var obj = new Object();
	obj.ContractDetailsQuery = new Ext.Button({
		id : 'ContractDetailsQuery'
		,iconCls : 'icon-find'
		,text : 'Ԥ��'
	});
	obj.ContractDetailsid= new Ext.form.TextField({
		id : 'ContractDetailsid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ID'
		,editable : true
		,disabled:true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.tbmode = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbmode',
				items : [obj.ContractDetailsQuery,obj.ContractDetailsid]
			});
	obj.tree = new Ext.tree.TreePanel({
	            id:'tree',
	           // border:false,
				width:300,
				height:500,
				title:'��ͬ�ṹͼ',
				tbar:obj.tbmode,
    			//animate:true,
    			enableDD:false,
    			containerScroll:true,
		        loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=ContractDetails&ContractId='+idd}),
		        rootVisible:false,
		        //lines:false,
		        //autoScroll:true,
		        root: new Ext.tree.AsyncTreeNode({
		        text: 'text',
				id:'id',
		        expanded:true
				})
	});
	obj.ContractDetailsAdd = new Ext.Button({
		id : 'ContractDetailsAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.ContractDetailsTitle= new Ext.form.TextField({
		id : 'ContractDetailsTitle'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ContractDetailsSub = new Ext.form.Checkbox({
		id : 'ContractDetailsSub'
		,checked : false
		,fieldLabel : '�ӱ���'
		,anchor : '99%'
	});
	obj.tbmenu = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbmenu',
				items : [new Ext.Toolbar.TextItem('�ṹ���⣺'),obj.ContractDetailsTitle,'-',obj.ContractDetailsSub,new Ext.Toolbar.TextItem('�ӱ���'),'-',obj.ContractDetailsAdd]
			});
	obj.ContractDetailMenu = new Ext.Panel({
	     id:'ContractDetailMenu'
		,title:'��ͬ��ϸ��Ϣά��'
		//,buttonAlign : 'center'
		,region : 'fit'
		,layout : 'column'
		//,Resizable:'yes'
		,tbar:obj.tbmenu
		,items:[{xtype:'htmleditor'
		        ,id:'ContractDetailMenui'
				//,autoWidth : true
				,width:632
				,height:440
				,enableSourceEdit:false
				,defaultValue:'�������ͬ������Ϣ���ɴ�Word����'}]  //obj.ContractDetailsREM]	  ,fontFamilies: ["����", "����", "����"]	
	});
	obj.menuwindDetails = new Ext.Window({
		id : 'menuwindDetails'
		,height : 540
		,buttonAlign : 'center'
		,width : 950
		,modal : true
		,title : '��ͬ����'
		,layout : 'column'
		,border:true
		,items:[obj.tree,obj.ContractDetailMenu]
	});						
	ContractDetailsWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
	}
function ContracAdjunct(id,type){
    var obj = new Object();
	obj.ContracAdjunctAdd = new Ext.Button({
		id : 'ContracAdjunctAdd'
		,iconCls : 'icon-add'
		,text : '�ϴ�����'
	});
	obj.ContracAdjunctRowid= new Ext.form.TextField({
		id : 'ContracAdjunctRowid'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.tbAdjuct = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbAdjuct',
				items : [obj.ContracAdjunctAdd,obj.ContracAdjunctRowid]
			});
	//****************************** End ****************************
	obj.ContracAdjuncttoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ContracAdjunctStore = new Ext.data.Store({
		proxy: obj.ContracAdjuncttoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ConAdRowid'
		,'ConAdName'
		,'ConAdFileType'
		,'ConAdDate'
		,'ConAdUser'
		,'ConAdType'
		,'ConAdFtpName'
		,'ConAdFalg'])
	});
	obj.ContracAdjuncttoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ContracAdjunctStore';
			//param.Arg1 = obj.ContracAdjunctRowid.getRawValue();
			//param.Arg2 = 'Contract';
			param.Arg1 = id;
			param.Arg2 = type;
			param.ArgCnt = 2;
	});
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ContracAdjunctPanel = new Ext.grid.GridPanel({
		id : 'ContracAdjunctPanel'
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
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ContracAdjunctStore
		,tbar:obj.tbAdjuct
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, {header : "����",width : 100,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("ConAdFalg")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>���غ�ͬ</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='EditDetail'>ɾ��</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'ConAdRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��������', width : 150, dataIndex : 'ConAdName', sortable : false, align : 'center',editable: true }
			, { header : '�ļ�����', width : 100, dataIndex : 'ConAdFileType', sortable : false ,align : 'center'}
			, { header : '�ϴ�ʱ��', width : 100, dataIndex : 'ConAdDate', sortable : true, align : 'center' }
			, { header : '�ϴ���', width : 100, dataIndex : 'ConAdUser',sortable : true,align : 'center' }
			, { header : '�ϴ�����', width : 100, dataIndex : 'ConAdType',sortable : true,align : 'center'}
			, { header : '�������ļ���', width : 100, dataIndex : 'ConAdFtpName', hidden: true ,sortable : true, align : 'center' }
			, { header : '������־', width : 100, dataIndex : 'ConAdFalg', hidden: true ,sortable : true, align : 'center' }
			, { header : 'ȫ·��', width : 100, dataIndex : 'ConAdAll', hidden:true,sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 10,
			store : obj.ContracAdjunctStore,
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
	//--------------------------------------------------------------------
    obj.ContractaPanal=new Ext.Panel({
			id : 'ContractaPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.ContracAdjunctPanel]
		});
    obj.menuwindContracAd = new Ext.Window({
		id : 'menuwindModeN'
		,height : 440
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '��������'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.ContracAdjunctPanel
		]
	});
	obj.ContracAdjunctStore.removeAll();
	obj.ContracAdjunctStore.load({params : {start:0,limit:10}});
	ContracAdjunctEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;

}