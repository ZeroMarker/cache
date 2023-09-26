addFun = function(dataStore,grid,pagingTool,dataTypeDr) {
	//Ext.QuickTips.init();
  // pre-define fields in the form
	var items="";
	
//---------------------------------------------------------
var AddTabProxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=listitem&dataTypeDr='+dataTypeDr});
var num=Date.parse(new Date());

var AddTabDs = new Ext.data.Store({
	proxy: AddTabProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'order',
	'code',
	'name',
	'shortcut',
	'remark',
	'active',
	'unit'
	]),
	// turn on remote sorting
	remoteSort: true
});	
AddTabDs.setDefaultSort('Rowid', 'Desc');
var sm = new Ext.grid.CheckboxSelectionModel();
var AddTabCm = new Ext.grid.ColumnModel([
sm,
new Ext.grid.RowNumberer(),
/**
{   
        header:"ѡȡ��־",   
		width: 80,
		name:'itemCheck',
        dataIndex:"Flag",
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+((v=='Y'||v==true)?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
		editor: new Ext.form.Checkbox()
},
*/
{   
        header:"���������",  
		width: 150,		
        dataIndex:"code"  
		   
},
{   
        header:"����������",  
		width: 150,		
        dataIndex:"name"  
		   
},
{   
        header:"�����Ԫ",
		width:150,
        dataIndex:"unit"  
},
{   
        header:"��ע",
		width:350,
        dataIndex:"remark"  
}

]);
//-----------------------------------------------------
var addItemSearchField = 'name';
var searchField="";
var addItemFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���������',value: 'code',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '����������',value: 'name',checked: true,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '�����Ԫ',value: 'unit',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
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
					AddTabDs.proxy = new Ext.data.HttpProxy({url: dataItemCorresUrl + '?action=listitem&searchField='+Ext.getCmp('unitTypeSelecter').getRawValue()+'&dataTypeDr='+dataTypeDr});
					AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
					AddTabDs.proxy = new Ext.data.HttpProxy({
					url: dataItemCorresUrl + '?action=listitem&searchField=' + addItemSearchField + '&searchValue=' + this.getValue()+'&dataTypeDr='+dataTypeDr});
					AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize, dataTypeDr:dataTypeDr}});
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
	afterEdit=function(obj){
		var r=obj.record;
		var rowid=r.get("rowid");
		var flag=r.get("Flag");
		if(flag){
			if(items==""){
				items=rowid;
			}else{
				items=items+","+rowid;
			}
		}else{
			if(items.indexOf(","+rowid)>=0){
				items=items.replace(","+rowid,"");
			}else{
				if((items.indexOf(rowid+","))>=0){
					items=items.replace(rowid+",","");
				}else{
					items=items.replace(rowid,"");
				}
			}
		}
		
	}
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
    formPanel.on("afteredit",afterEdit,formPanel);
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '����������Ӧ',
    width: 800,
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
			var rows=formPanel.getSelectionModel().getSelections();
			for(var i=0;i <rows.length;i++){ 
				if(i==rows.length-1){
					items = items + rows[i].get('rowid'); 
				}else{
					items = items + rows[i].get('rowid') + ','; 
				}
			} 

						Ext.Ajax.request({
							url: dataItemCorresUrl+'?action=add&dataTypeDr='+dataTypeDr+'&items='+items,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,dataTypeDr:dataTypeDr}});
									items="";
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='EmptyType') message='��������������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='EmptyItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
									items="";
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