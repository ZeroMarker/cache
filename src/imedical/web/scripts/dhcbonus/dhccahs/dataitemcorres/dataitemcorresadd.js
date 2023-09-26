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
        header:"选取标志",   
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
        header:"数据项代码",  
		width: 150,		
        dataIndex:"code"  
		   
},
{   
        header:"数据项名称",  
		width: 150,		
        dataIndex:"name"  
		   
},
{   
        header:"数据项单元",
		width:150,
        dataIndex:"unit"  
},
{   
        header:"备注",
		width:350,
        dataIndex:"remark"  
}

]);
//-----------------------------------------------------
var addItemSearchField = 'name';
var searchField="";
var addItemFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '数据项代码',value: 'code',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '数据项名称',value: 'name',checked: true,group: 'LocFilter',checkHandler: onLocItemCheck }),
				new Ext.menu.CheckItem({ text: '数据项单元',value: 'unit',checked: false,group: 'LocFilter',checkHandler: onLocItemCheck })
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
  	title: '添加数据项对应',
    width: 800,
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
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									AddTabDs.load({params:{start:0, limit:AddTabPagingToolbar.pageSize}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,dataTypeDr:dataTypeDr}});
									items="";
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='EmptyType') message='输入的数据项类别为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='EmptyItem') message='输入的数据项已经存在!';
									if(jsonData.info=='RepItem') message='输入的数据项已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
									items="";
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