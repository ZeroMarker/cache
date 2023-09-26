
function InitOESubWindow(EpisodeID){
	var obj = new Object();
	obj.dfOEDateFrom = new Ext.form.DateField({
		id : 'dfOEDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date()
	});
	obj.pOEConditionChild1 = new Ext.Panel({
		id : 'pOEConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dfOEDateFrom
		]
	});
	obj.dfOEDateTo = new Ext.form.DateField({
		id : 'dfOEDateTo'
		,width : 100
		,fieldLabel : '��������'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		//,value : new Date()
	});
	obj.pOEConditionChild2 = new Ext.Panel({
		id : 'pOEConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dfOEDateTo
		]
	});
	obj.cboItemCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboItemCatStore = new Ext.data.Store({
		proxy: obj.cboItemCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CatID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CatID', mapping: 'CatID'}
			,{name: 'CatCode', mapping: 'CatCode'}
			,{name: 'CatDesc', mapping: 'CatDesc'}
		])
	});
	obj.cboItemCat = new Ext.form.ComboBox({
		id : 'cboItemCat'
		,listEmptyText : ''
		,width : 50
		,store : obj.cboItemCatStore
		,minChars : 1
		,displayField : 'CatDesc'
		,fieldLabel : 'ҽ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CatID'
	});
	obj.pOEConditionChild3 = new Ext.Panel({
		id : 'pOEConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.cboItemCat
		]
	});
	obj.cboItemSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboItemSubCatStore = new Ext.data.Store({
		proxy: obj.cboItemSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SubCatID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SubCatID', mapping: 'SubCatID'}
			,{name: 'SubCatCode', mapping: 'SubCatCode'}
			,{name: 'SubCatDesc', mapping: 'SubCatDesc'}
		])
	});
	obj.cboItemSubCat = new Ext.form.ComboBox({
		id : 'cboItemSubCat'
		,listEmptyText : ''
		,width : 50
		,store : obj.cboItemSubCatStore
		,minChars : 1
		,displayField : 'SubCatDesc'
		,fieldLabel : 'ҽ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'SubCatID'
	});
	obj.pOEConditionChild4 = new Ext.Panel({
		id : 'pOEConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.cboItemSubCat
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '��ѯ'
		,disabled : false
	});
	obj.pOEConditionChild5 = new Ext.Panel({
		id : 'pOEConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.btnQuery
		]
	});
	obj.OEConditionSubPanel = new Ext.form.FormPanel({
		id : 'OEConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pOEConditionChild1
			,obj.pOEConditionChild2
			,obj.pOEConditionChild3
			,obj.pOEConditionChild4
			,obj.pOEConditionChild5
		]
	});
	obj.OEConditionPanel = new Ext.Panel({
		id : 'OEConditionPanel'
		,height : 40
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		//,title : 'ҽ����ѯ'
		,items:[
			obj.OEConditionSubPanel
		]
	});
	//******************************************************
	obj.gpOeordItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gpOeordItemStore = new Ext.data.Store({
		proxy: obj.gpOeordItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OeItemID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OeItemID', mapping: 'OeItemID'}
			,{name: 'Priority', mapping: 'Priority'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'ArcimSubCat', mapping: 'ArcimSubCat'}
			,{name: 'OrdCreateDate', mapping: 'OrdCreateDate'}
			,{name: 'OrdCreateTime', mapping: 'OrdCreateTime'}
			,{name: 'OrdStartDate', mapping: 'OrdStartDate'}
			,{name: 'OrdStartTime', mapping: 'OrdStartTime'}
			,{name: 'OrdXDate', mapping: 'OrdXDate'}
			,{name: 'OrdXTime', mapping: 'OrdXTime'}
			,{name: 'OrdStatus', mapping: 'OrdStatus'}
			,{name: 'DoseQty', mapping: 'DoseQty'}
			,{name: 'DoseUnit', mapping: 'DoseUnit'}
			,{name: 'PHFreq', mapping: 'PHFreq'}
			,{name: 'Instr', mapping: 'Instr'}
			,{name: 'Dura', mapping: 'Dura'}
			,{name: 'QtyPackUOM', mapping: 'QtyPackUOM'}
			,{name: 'PackUOMDesc', mapping: 'PackUOMDesc'}
			,{name: 'PrescNo', mapping: 'PrescNo'}
		])
	});
	obj.gpOeordItemCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gpOeordItem = new Ext.grid.GridPanel({
		id : 'gpOeordItem'
		,store : obj.gpOeordItemStore
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ҽ������', width: 80, dataIndex: 'Priority', sortable: true}
			,{header: 'ҽ����', width: 250, dataIndex: 'ArcimDesc', sortable: true}
			,{header: 'ҽ������', width: 100, dataIndex: 'ArcimSubCat', sortable: true}
			//,{header: '��ҽ������', width: 80, dataIndex: 'OrdCreateDate', sortable: false}
			//,{header: '��ҽ��ʱ��', width: 60, dataIndex: 'OrdCreateTime', sortable: false}
			,{header: '��ʼ����', width: 80, dataIndex: 'OrdStartDate', sortable: true}
			,{header: '��ʼʱ��', width: 60, dataIndex: 'OrdStartTime', sortable: true}
			,{header: 'ִ������', width: 80, dataIndex: 'OrdXDate', sortable: true}
			,{header: 'ִ��ʱ��', width: 60, dataIndex: 'OrdXTime', sortable: true}
			,{header: '״̬', width: 50, dataIndex: 'OrdStatus', sortable: true}
			,{header: '����', width: 50, dataIndex: 'DoseQty', sortable: false}
			,{header: '������λ', width: 50, dataIndex: 'DoseUnit', sortable: false}
			,{header: 'Ƶ��', width: 50, dataIndex: 'PHFreq', sortable: false}
			,{header: '�÷�', width: 50, dataIndex: 'Instr', sortable: false}
			,{header: '�Ƴ�', width: 50, dataIndex: 'Dura', sortable: false}
			,{header: '����(����װ)', width: 50, dataIndex: 'QtyPackUOM', sortable: false}
			,{header: '��λ(����װ)', width: 80, dataIndex: 'PackUOMDesc', sortable: false}
			//,{header: '������', width: 100, dataIndex: 'PrescNo', sortable: false}
		]
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
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.OrdStatus=="ֹͣ") {
					return 'x-grid-record-red';
				} else if (record.data.OrdStatus=="ִ��") {
					return 'x-grid-record-green';
				} else {
					return '';
				}
			}
		}

});
	obj.OESubWindow = new Ext.Window({
		id : 'OESubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : 'ҽ����'
		,layout : 'border'
		,width : 900
		,height : 500
		,modal: true
		,items:[
			obj.OEConditionPanel
			,obj.gpOeordItem
		]
	});
	
	obj.cboItemCatStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryARCItemCat';
			param.Arg1 = obj.cboItemCat.getRawValue();
			param.ArgCnt = 1;
	});
	//obj.cboItemCatStore.load({});
	
	obj.cboItemSubCatStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryARCItemSubCat';
			param.Arg1 = obj.cboItemSubCat.getRawValue();
			param.Arg2 = obj.cboItemCat.getValue();
			param.ArgCnt = 2;
	});
	//obj.cboItemSubCatStore.load({});
	
	obj.gpOeordItemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysMonitor';
			param.QueryName = 'QryOEItemByAdm';
			param.Arg1 = EpisodeID;
			param.Arg2 = obj.dfOEDateFrom.getRawValue();
			param.Arg3 = obj.dfOEDateTo.getRawValue();
			param.Arg4 = obj.cboItemCat.getValue();
			param.Arg5 = obj.cboItemSubCat.getValue();
			param.ArgCnt = 5;
	});
	InitOESubWindowEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

