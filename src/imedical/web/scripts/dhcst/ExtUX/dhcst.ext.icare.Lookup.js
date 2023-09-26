/**
 * @creator:	yunhaibao
 * @createdate: 2017-11-13
 * @description:�̳��Ի���ƽ̨
 * @from 		scripts/framework/ext.icare.Lookup.js
 * initGridPanel:�޸�һЩ���Ը�ֵ,��ӭ��Ŀǰҩ��Ĳ�ѯ��ʽ
 * rowClick:	 ����record
 */   
Ext.ns('dhcst.icare');
dhcst.icare.Lookup=Ext.extend(
	dhcc.icare.Lookup,		
	{
		listFields:[],  //��
		listColumns:[], //����ʾ
		listUrl:"",
		initComponent:function() { 	
	        dhcst.icare.Lookup.superclass.initComponent.apply(this, arguments);
		},
		initGridPanel:function(){
			if(!this.lookupName) return;
			var ds = this.dataSet;
			this.pageSize = this.pageSize || json.pageSize || 15;
			var pagingBar = new Ext.PagingToolbar({
				pageSize: this.pageSize, store: ds, displayInfo: true , displayMsg: '{0}-{1},��{2}��',
				items: ['-',new Ext.Toolbar.Button({handler: this.hide,text:'�ر�',scope:this})]
	    	});
	    	var cms = this.listColumns;
			var styleObj = document.getElementById(dhcc.icare.lookupconfig.lookupDivId+"extStyle");
			this.id = this.lookupName+"zlookup";
			this.title = "";				
			this.width= this.defaultWidth;	
			this.height = this.defaultHeight;
			if (this.rowNumber) cms.splice(0,0,new Ext.grid.RowNumberer());
			this.colModel = cms;
			this.store = ds;
			var myloadM;
			if (Ext.isIE){
				myloadM = new Ext.LoadMask(dhcc.icare.lookupconfig.lookupDiv, {msg:"���ڼ�������...",store:this.store});//this.loadMask = myloadM;
			}else{
				myloadM = true;
			}
			this.stripeRows=true;
			this.border=false;
			this.bbar = pagingBar;
			this.pagingBar = pagingBar;
			this.listeners = {
				afterrender: this.searchAndShow,
				headerdblclick: this.headerDblClick, 
				rowclick: this.rowClick,
				keydown: this.gridPanelKeydown,
				scope: this
			};
			this.renderTo = dhcc.icare.lookupconfig.lookupDivId;

		},
	    doSearch: function(param) {
		    var dom = document.getElementById(this.lookupName);
    		this.store.baseParams.Input = dom.value;
			this.qValue = dom.value ; 
			this.store.load();
	    },
	    rowClick: function(gridPanel, rowIndex, e) {
	        var r = this.store.getAt(rowIndex);
	        if (r){      
		        this.value = r.data[this.displayField];
		        $(this.lookupName).value = this.value;
		        this.fireEvent('selectRow',r);              
		        this.hide();
	        }
	    }

	}
)
