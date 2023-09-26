//Create by zzp
// 20150426
//ϵͳ��������
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.SysFromDate = new Ext.form.DateField({
		id : 'SysFromDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��Ч����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	
	obj.SysToDate = new Ext.form.DateField({
		id : 'SysToDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : 'ʧЧ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	obj.SysTypeName = new Ext.form.TextField({
		id : 'SysTypeName'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '���ͱ���'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	
	obj.SysMenu = new Ext.form.TextField({
		id : 'SysMenu'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ֵ��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.SysText = new Ext.form.TextField({
		id : 'SysText'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ע���ĵ�'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.SysAdd = new Ext.Button({
		id : 'SysAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.SysUpdate = new Ext.Button({
		id : 'SysUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.SysDelete = new Ext.Button({
		id : 'SysDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.SysQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.SysBatch = new Ext.Button({
		id : 'SysBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**��ɾ��**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.SysAdd, '-', obj.SysUpdate, '-', obj.SysDelete]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('���ͱ��룺'),obj.SysTypeName,'-',new Ext.Toolbar.TextItem('ֵ��'),obj.SysMenu,'-',new Ext.Toolbar.TextItem('�������ڣ�'),obj.SysFromDate,'-',new Ext.Toolbar.TextItem('ʧЧ���ڣ�'),obj.SysToDate,'-',new Ext.Toolbar.TextItem('ע�ͣ�'),obj.SysText,'-',obj.SysQuery,'-',obj.SysBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.SysGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.SysGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.SysGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'SysGridStorequery';
			param.Arg1 = '';  //Ext.getCmp('SysTypeName').getValue()+"^"+Ext.getCmp('SysFromDate').getValue()+"^"+Ext.getCmp('SysToDate').getValue();
			param.Arg2 = '';  //Ext.getCmp('SysMenu').getValue();
			param.Arg3 = '';  //Ext.getCmp('SysText').getValue();
			param.ArgCnt = 3;
	});
	obj.SysGridStore = new Ext.data.Store({
		proxy: obj.SysGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record'
			,totalProperty: 'total'
			,fields:[{
			name: 'SysGridRowid',
			mapping: 'SysGridRowid'
			},{
			name: 'SysGridCode',
			mapping: 'SysGridCode'
			},{
			name: 'SysGridDesc',
			mapping: 'SysGridDesc'
			},{
			name: 'SysGridText', 
			mapping: 'SysGridText'
			},{
			name: 'SysGridStdate',
			mapping: 'SysGridStdate'
			},{
			name: 'SysGridEndate',
			mapping: 'SysGridEndate'
			}]
		})
	});
	obj.gridSysCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.SysGridPanel = new Ext.grid.GridPanel({
		id : 'SysGridPanel'
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
		,plugins : obj.gridSysCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.SysGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridSysCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'SysGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '���ͱ���', width : 150, dataIndex : 'SysGridCode', sortable : false, align : 'center',editable: true }
			, { header : 'ֵ��', width : 200, dataIndex : 'SysGridDesc', sortable : false ,align : 'center'}
			, { header : 'ע���ĵ�', width : 420, dataIndex : 'SysGridText', sortable : true, align : 'center' }
			, { header : '��Ч����', width : 100, dataIndex : 'SysGridStdate',sortable : true,align : 'center' }
			, { header : 'ʧЧ����', width : 100, dataIndex : 'SysGridEndate',align : 'center'}
			, {header : "����",width : 80,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("SysGridCode")=="AdjunctIP"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Test'>��������</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   return strRet;
			   }}}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.SysGridStore,
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
	obj.SysPanal=new Ext.Panel({
			id : 'StaDetailPanal'
			,layout : 'fit'
			,width : '100%'
			,title:'���ù���'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.SysGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,title:'���ù���'
		,items : [obj.SysPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.SysGridStore.removeAll();
	obj.SysGridStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function SysMenuWind(){
    var obj = new Object();
	obj.MenuFromDate = new Ext.form.DateField({
		id : 'MenuFromDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��Ч����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	obj.MenuToDate = new Ext.form.DateField({
		id : 'MenuToDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : 'ʧЧ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		//,value : new Date()
	});
	obj.MenuTypeName = new Ext.form.TextField({
		id : 'MenuTypeName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '���ͱ���'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.MenuMenu = new Ext.form.TextField({
		id : 'MenuMenu'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ֵ��'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.MenuText = new Ext.form.TextArea({
		id : 'MenuText'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : 'ע���ĵ�'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.MenuRowid = new Ext.form.TextField({
		id : 'MenuRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'MenuRowid'
		//,editable : true
		//,hidden:true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.MenuFlag = new Ext.form.TextField({
		id : 'MenuFlag'
		,width : 100
		,minChars : 1
		//,hidden:true
		,displayField : 'desc'
		,fieldLabel : '������ʶ'
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.MenuUpdate = new Ext.Button({
		id : 'MenuUpdate'
		,iconCls : 'icon-update'
		,text : '����'
	});
	obj.MenuDelete = new Ext.Button({
		id : 'MenuDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenu = new Ext.Panel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{3,0,0,0}'
		//,height:'80%'
		//,title : '��������'
		,layout : 'form'
		,region : 'center'
		,labelWidth:60
		,frame : true
		,items:[
		     obj.MenuRowid
			,obj.MenuFlag 
			,obj.MenuTypeName
			,obj.MenuMenu 	
			,obj.MenuFromDate
			,obj.MenuToDate
			,obj.MenuText
		]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 350
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '��������'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelMenu
		]
		,buttons:[
			   obj.MenuUpdate
			  ,obj.MenuDelete
		]
	});
	SysMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}