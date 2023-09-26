addCostDeptsFun = function(dataStore,grid,pagingTool,parRef,type,costCombo,recCombo,order,deptLevelSetsDr,layerDr) {
	//Ext.QuickTips.init();
  // pre-define fields in the form
	if(type=="")
	{
		Ext.Msg.show({title:'错误',msg:'请选择科室类型',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
					header:"部门名称",  
					width: 150,		
					dataIndex:"deptDesc"  
					   
			}
		]);
	}else{
		AddTabCm = new Ext.grid.ColumnModel([
			sm,
			new Ext.grid.RowNumberer(),
			{   
					header:"比率",  
					width: 150,		
					dataIndex:"rate",
					editor: new Ext.form.NumberField()		
					   
			},
			{   
					header:"部门名称",  
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
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '部门名称',value: 'searchValue',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
		]}
});

function onLocItemCheck(item, checked)
{
		if(checked) {
				addItemSearchField = item.value;
				addItemFilterItem.setText(item.text + ':');
		}
};

var addItemSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
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
var AddTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 12,
		store: AddTabDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
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
  	title: '添加部门',
    width: 700,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
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
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
									if(jsonData.info=='EmptyType') message='输入的数据项类别为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='EmptyItem') message='输入的数据项已经存在!';
									if(jsonData.info=='RepItem') message='输入的数据项已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});          
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });
	
    window.show();
	AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
};