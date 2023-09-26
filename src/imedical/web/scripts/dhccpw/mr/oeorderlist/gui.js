
function InitMainViewport(){
	var obj = new Object();
	var btnDelete = new Ext.Toolbar.Button({
		tooltip: '�Ƴ�����ҽ��'
		,id: 'btnDelete'
		,text : "<img SRC='../scripts/dhccpw/img/delete.gif'><b>�Ƴ�</b>"
	});
	obj.OEOrderListGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OEOrderListGridStore = new Ext.data.Store({
		proxy: obj.OEOrderListGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record'
			,totalProperty: 'total'
			,idProperty: 'ItmNumber'
		},[
			{name: 'OEItemID', mapping: 'OEItemID', type: 'string'}
			,{name: 'ItmNumber', mapping: 'ItmNumber', type: 'integer'}
			,{name: 'ItmPriorityID', mapping: 'ItmPriorityID', type: 'string'}
			,{name: 'ItmPriority', mapping: 'ItmPriority', type: 'string'}
			,{name: 'ItmStartDate', mapping: 'ItmStartDate', type: 'string'}
			,{name: 'ItmStartTime', mapping: 'ItmStartTime', type: 'string'}
			,{name: 'ItmArcimID', mapping: 'ItmArcimID', type: 'string'}
			,{name: 'ItmArcim', mapping: 'ItmArcim', type: 'string'}
			,{name: 'ItmFreqID', mapping: 'ItmFreqID', type: 'string'}
			,{name: 'ItmFreq', mapping: 'ItmFreq', type: 'string'}
			,{name: 'ItmInstrucID', mapping: 'ItmInstrucID', type: 'string'}
			,{name: 'ItmInstruc', mapping: 'ItmInstruc', type: 'string'}
			,{name: 'ItmQty', mapping: 'ItmQty', type: 'string'}
			,{name: 'ItmPackUomID', mapping: 'ItmPackUomID', type: 'string'}
			,{name: 'ItmPackUom', mapping: 'ItmPackUom', type: 'string'}
			,{name: 'ItmDoseQty', mapping: 'ItmDoseQty', type: 'string'}
			,{name: 'ItmUnitID', mapping: 'ItmUnitID', type: 'string'}
			,{name: 'ItmUnit', mapping: 'ItmUnit', type: 'string'}
			,{name: 'ItmExecuteTime', mapping: 'ItmExecuteTime', type: 'string'}
			,{name: 'ItmResume', mapping: 'ItmResume', type: 'string'}
			,{name: 'StepItemIDStr', type: 'string'}
		])
	});
	
    obj.OEOrderListGrid = new Ext.grid.EditorGridPanel({
    	id: 'OEOrderListGrid'
        ,store: obj.OEOrderListGridStore
        ,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
        //render: 'center'
        //,autoExpandColumn: 'common'
        //,frame: true
        ,clicksToEdit : 1
        ,columnLines : true
        ,stripeRows : true
        ,columns: [
			{ header: '���', dataIndex: 'ItmNumber', width: 40 , sortable: false, menuDisabled:true , align:'center' }
            ,{ header: 'ҽ������', dataIndex: 'ItmPriority', width: 60 , sortable: false, menuDisabled:true , align:'center' }
            ,{ header: 'ҽ������', dataIndex: 'ItmArcim', width: 250, sortable: false, menuDisabled:true , align:'left' }
			,{ header: 'Ƶ��', dataIndex: 'ItmFreq', width: 40, sortable: false, menuDisabled:true , align:'center' }
            ,{ header: '�÷�', dataIndex: 'ItmInstruc', width: 60, sortable: false, menuDisabled:true , align:'left' }
			,{ header: '����', dataIndex: 'ItmDoseQty', width: 40, sortable: false, menuDisabled:true , align:'center' }
            ,{ header: '����<br>��λ', dataIndex: 'ItmUnit', width: 60, sortable: false, menuDisabled:true , align:'left' }
            ,{ header: '����', dataIndex: 'ItmQty', width: 40, sortable: false, menuDisabled:true , align:'center' }
            ,{ header: '��λ', dataIndex: 'ItmPackUom', width: 60, sortable: false, menuDisabled:true , align:'left' }
			,{ header: '��ʼ����', dataIndex: 'ItmStartDate', width: 70, sortable: false, menuDisabled:true , align:'center' }
            ,{ header: '��ʼ<br>ʱ��', dataIndex: 'ItmStartTime', width: 40, sortable: false, menuDisabled:true , align:'center' }
            ,{ header: 'ִ��ʱ��', dataIndex: 'ItmExecuteTime', width: 80, sortable: false, menuDisabled:true , align:'left' }
			,{ header: '��ע', dataIndex: 'ItmResume', width: 120, sortable: false, menuDisabled:true , align:'left' }
        ]
		,iconCls: 'icon-grid'
		,loadMask : {
			msg : '��������ҽ������,���Ժ�...'
		}
		,bbar : ['��ܰ��ʾ���˴����Ƴ�����ť��ֻ�����Ƴ�ҽ���б�������ӣ����һ�δ�����ҽ��!','->','-',btnDelete,'-']
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
				if (record.data.OEItemID!='') {
					return 'x-grid-record-gray';
					//return 'x-grid-record-red';
				} else {
					return '';
				}
			}
		}
    });
	obj.OEOrderListGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysOrderList';
		param.QueryName = 'QryOrderList';
		param.Arg1 = EpisodeID;
		param.Arg2 = '';
		param.ArgCnt = 1;
	});
	
	obj.WinOEOrderList = new Ext.Viewport({
		id : 'WinOEOrderList'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,layout : 'fit'
		,modal : true
		,items:[
			obj.OEOrderListGrid
		]
	});
	
	InitMainViewportEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}