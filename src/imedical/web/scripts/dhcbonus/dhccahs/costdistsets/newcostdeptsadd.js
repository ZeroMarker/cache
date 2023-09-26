addCostDeptsFun = function(dataStore,grid,pagingTool,parRef,type,costCombo,recCombo,order,deptLevelSetsDr,layerDr) {
	//Ext.QuickTips.init();
  // pre-define fields in the form
	if(type=="")
	{
		Ext.Msg.show({title:'����',msg:'��ѡ���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['deptDr','deptDesc'])
	});
	
	var sm = new Ext.grid.CheckboxSelectionModel();
	var AddTabCm="";
	
	if((type=="inc")||(type=="outc")||(type=="outr")){
		AddTabCm = new Ext.grid.ColumnModel([
			sm,
			new Ext.grid.RowNumberer(),
			{   
					header:"��������",  
					width: 150,		
					dataIndex:"deptDesc"  
					   
			}
		]);
	}else{
		AddTabCm = new Ext.grid.ColumnModel([
			sm,
			new Ext.grid.RowNumberer(),
			{   
					header:"����",  
					width: 150,		
					dataIndex:"rate",
					editor: new Ext.form.NumberField()		
					   
			},
			{   
					header:"��������",  
					width: 150,		
					dataIndex:"deptDesc"  
					   
			}
		]);
	}
	var AddTabProxy="";
	if(type=="inc"){
		AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		//formPanel.reconfigure(AddTabProxy,AddTabCmTwo);
	}if(type=="outc"){
		AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		//formPanel.reconfigure(AddTabProxy,AddTabCmTwo);
	}if(type=="inr"){
		AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchRecDepts&id='+parRef+'&layerDr='+order+'&deptSet='+deptLevelSetsDr, method:'GET'});
		//formPanel.reconfigure(AddTabProxy,AddTabCm);
	}if(type=="outr"){
		AddTabProxy= new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerRecDepts&id='+parRef+'&layerDr='+order+'&deptSet='+deptLevelSetsDr, method:'GET'});
		//formPanel.reconfigure(AddTabProxy,AddTabCm);
	}
	
//---------------------------------------------------------
//var AddTabProxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=listitem&dataTypeDr='+dataTypeDr});
var num=Date.parse(new Date());

var AddTabDs = new Ext.data.Store({
	proxy: AddTabProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'deptDr',
	'deptDesc'
	]),
	// turn on remote sorting
	remoteSort: true
});	
AddTabDs.setDefaultSort('Rowid', 'Desc');

//-----------------------------------------------------
var addItemSearchField = 'searchValue';
var searchField="";
var addItemFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '��������',value: 'searchValue',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
		]}
});

function onLocItemCheck(item, checked)
{
		if(checked) {
				addItemSearchField = item.value;
				addItemFilterItem.setText(item.text + ':');
		}
};

var addItemSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
		listeners: {
				specialkey: {fn:function(field, e) {
				var key = e.getKey();
	      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
	    	},
		grid: this,
		onTrigger1Click: function() {
				if(this.getValue()) {
					this.setValue('');
					//AddTabDs.proxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=listitem&searchField='+Ext.getCmp('unitTypeSelecter').getRawValue()+'&dataTypeDr='+dataTypeDr});
					AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				var AddTabProxy="";
				if(type=="inc"){
					AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr+"&searchValue="+this.getValue(), method:'GET'});
				}if(type=="outc"){
					AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr+"&searchValue="+this.getValue(), method:'GET'});
				}if(type=="inr"){
					AddTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchRecDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr+"&searchValue="+this.getValue(), method:'GET'});
				}if(type=="outr"){
					AddTabProxy= new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerRecDepts&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr+"&searchValue="+this.getValue(), method:'GET'});
				}
				AddTabDs.proxy=AddTabProxy;
				AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
	    	}
		}
});
//-----------------------------------------------------
var AddTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 12,
		store: AddTabDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',addItemFilterItem,'-',addItemSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
					//B['remark']=items;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});	

	// create form panel
	var formPanel = new Ext.grid.EditorGridPanel({
		store: AddTabDs,
		cm: AddTabCm,
		trackMouseOver: true,
		clicksToEdit:1,
		stripeRows: true,
		sm: sm,
		loadMask: true,
		//tbar: [busTypeField],
		bbar: AddTabPagingToolbar
	});
   
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��Ӳ���',
    width: 700,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
		handler: function() {
			var items="";
			var rows=formPanel.getSelectionModel().getSelections();
			for(var i=0;i <rows.length;i++){ 
				var tmpRate=rows[i].get('rate');
				if(tmpRate==undefined)tmpRate="";
				if(i==rows.length-1){
					items = items + rows[i].get('deptDr')+"^"+tmpRate; 
				}else{
					items = items + rows[i].get('deptDr')+"^"+tmpRate + ','; 
				}
			} 
				//alert(items);
				//return;
						Ext.Ajax.request({
							url: costDistSetsUrl+'?action=addCostDepts&id='+parRef+'&deptDr='+items+'&type='+type,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									if((type=="inc")||(type=="outc")){
										costCombo.disable();
									}else{
										recCombo.disable();
									}
									AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id: distMethodsDr}});
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='EmptyType') message='��������������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='EmptyItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});          
	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){window.close();}
      }]
    });
	
    window.show();
	AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
};