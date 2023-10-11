 var itemGridUrl = '../csp/herp.acct.checkdetailexe.csp';

//配件数据源

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'ISBN',
		'StoreName',
		'UnitName',
		'DataType',
		'DataFrom',
		'yearmonth',
		'DataValue',
		'InsertDate'
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : false,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
});
//设置默认排序字段和排序方向

itemGridDs.setDefaultSort('ISBN');
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'ISBN',
        header: '单据编码',
        dataIndex: 'ISBN',
        width: 80,		  
        hidden: false,
        sortable: true
	    
    },
    {
	    id:'yearmonth',
	    header:'年月',
	    dataIndex:'yearmonth',
	    width: 80,
	    hidden: false,
	    sortable:true
	},
    {
	    id:'StoreName',
	    header:'库房名称',
	    dataIndex:'StoreName',
	    width: 220,
	    hidden: false,
	    sortable:true
	},{
	    id:'DataType',
	    header:'物资类别',
	    dataIndex:'DataType',
	    width: 180,
	    hidden: false,
	    sortable:true
	},
	{
	    id:'DataValue',
	    header:'金额',
	    dataIndex:'DataValue',
	    width: 100,
	    hidden: false,
	    sortable:true
	},{
	    id:'DataFrom',
	    header:'数据类别',
	    dataIndex:'DataFrom',
	    width: 100,
	    hidden: false,
	    sortable:true
	},{
	    id:'InsertDate',
	    header:'采集时间',
	    dataIndex:'InsertDate',
	    width: 250,
	    hidden: false,
	    sortable:true
	}
   
]);
//初始化默认排序功能
itemGridCm.defaultSortable = true;
  var DataFromStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '物资请领'], ['2', '物资应付款']]
		});
	var DataFrom = new Ext.form.ComboBox({
            id : 'DataFrom',
			fieldLabel : 'DataFrom',
			width : 130,
			listWidth : 130,
			store : DataFromStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // 本地模式
			triggerAction: 'all',
			emptyText:'请选择...',
			selectOnFocus:true,
			forceSelection : true
		});	
var yearmonth = new Ext.form.DateField({
		fieldLabel: '年月',
		name: 'yearmonth',
		width: 150,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});

	var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
			
				var myyearmonth=yearmonth.getRawValue();
				var datafrom= DataFrom.getValue();
				if (myyearmonth=="")
				{
				Ext.MessageBox.show({
		           title: '提示',
		           msg: "年月不能为空!",
		           buttons: Ext.MessageBox.OK
		       });
		     return null;
		     	}
	
				    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.acct.checkdetailexe.csp?action=list&yearmonth='+encodeURIComponent(myyearmonth)+'&kind='+encodeURIComponent(datafrom),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
							
				itemGridDs.load({
					
							params : {
								start : 0,
								limit : itemGridPagingToolbar.pageSize
								//yearmonth :'',
							    //kind:''
							
							}
						});
						

			}
			
			
		});
			
		
      
		var UpdataButton = new Ext.Toolbar.Button({
			text : '数据更新',
			tooltip : '数据更新',
			iconCls:'option',
			handler : function() {
			
				var myyearmonth=yearmonth.getRawValue();
				if (myyearmonth=="")
				{
				Ext.MessageBox.show({
		           title: '提示',
		           msg: "年月不能为空!",
		           buttons: Ext.MessageBox.OK
		       });
		     return null;
		     	}
	Ext.Ajax.request({
							url: 'herp.acct.checkdetailexe.csp?action=update'+'&start='+0+'&limit='+25+'&yearmonth='+encodeURIComponent(myyearmonth),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'更新成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									
								}
								else
								{	
								  if(jsonData.info==100)
								  {
								 Ext.MessageBox.show({
		                       title: '提示',
		                       msg: "没数据哈!",
		                        buttons: Ext.MessageBox.OK
		                                 });
								  return;
								  }
								
								  
								 Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								 
								}
							},
					  	scope: this
						});
			
			
   
			}
			
			
		});
		
var itemGrid = new Ext.grid.GridPanel({
	//title: '取查询',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
 
    atLoad : true, // 是否自动刷新
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['年月:','-',yearmonth,'-','数据来源',DataFrom,UpdataButton,findButton],
	bbar:itemGridPagingToolbar
});
var myyearmonth=yearmonth.getRawValue();
var datafrom= DataFrom.getValue();
/*
 itemGridDs.load({	
			params:{start:0, 
			limit:itemGridPagingToolbar.pageSize,
			yearmonth : myyearmonth,
			kind:datafrom,
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
			}
});
*/
itemGridDs.loadPage(1);
