var SchemUrl = 'dhc.pa.schemexe.csp';
var UnitSchemDetail = 'dhc.pa.schemunitdistexe.csp';
//var ParamProxy = new Ext.data.HttpProxy({url: ParamUrl+'?action=list'});
var DetailAddProxy = new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetailadd'});
var StratagemTabUrl = '../csp/dhcc.pa.stratagemexe.csp';
var userCode = session['LOGON.USERCODE'];
function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
//DetailAddProxy+'&schem='+Ext.getCmp('schemedistField').getValue()
var ParamDs = new Ext.data.Store({
	proxy: "",
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
           'rowid','period','KPIName','calUnitName','baseValue','trageValue','bestValue','baseup','trageup'
 
		]),
    remoteSort: true
});
function getValueByParam(paras){ 
	var url = location.href; 
	var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
	var paraObj = {} 
	for (i=0; j=paraString[i]; i++){ 
	paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
} 

var returnValue = paraObj[paras.toLowerCase()]; 
	if(typeof(returnValue)=="undefined"){ 
	return ""; 
	}else{ 
	return returnValue; 
	} 
}

var extremum; 
ParamDs.on('beforeload', function(ds, o){
	//alert(Ext.getCmp('schemedistField').getValue());
	extremum = getValueByParam('extremum');
	ds.proxy=new Ext.data.HttpProxy({url: UnitSchemDetail+'?action=schemunitdetaildist&schem='+getValueByParam('schem')+'&rowid='+getValueByParam('rowid')});
});

ParamDs.setDefaultSort('rowid', 'DESC');

var addAdjustButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的方案调整',
		iconCls: 'add',
		handler: function(){addAdjustFun(ParamDs,SchemDetailDistGrid,ParamPagingToolbar);
		}
});

var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'add'
		//handler: function(){}		
});



if((getValueByParam('extremum')=='H')||(getValueByParam('extremum')=='L')){
     range1 = new Ext.grid.ColumnModel({
				columns: [
					{header: '月份', width: 80, dataIndex: 'period'},
					{header: '年基准值', align: 'right',width: 80, dataIndex: 'baseValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
						//allowBlank: false
					})
					},
					{header: '年目标值', align: 'right',width: 80, dataIndex: 'trageValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
					   //allowBlank: false
				    })},
					{header: '年最佳值', align: 'right',width: 80, dataIndex: 'bestValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
					   //allowBlank: false
				   })}
				],
				defaultSortable: true
			});
	}
	else{
	range1 = new Ext.grid.ColumnModel({
					columns: [
						{header: '月份', width: 80, dataIndex: 'period'},
						{header: '年基准上限', align: 'right',width: 80, dataIndex: 'baseValue',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   //allowBlank: false
					   })},
						{header: '年目标上限', align: 'right',width: 80, dataIndex: 'trageValue',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   //allowBlank: false
					   })},
						{header: '年最佳值',align: 'right', width: 80, dataIndex: 'bestValue',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   //allowBlank: false
					   })},
						{header: '年目标下限', align: 'right',width: 80, dataIndex: 'trageup',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   //allowBlank: false
					   })
						},
						{header: '年基准下限', align: 'right',width: 80, dataIndex: 'baseup',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   //allowBlank: false
					   })
					   }
					],
					defaultSortable: true
				});
		}

 var SchemUnitDetailGrid1 = new Ext.grid.EditorGridPanel({//表格
							title: decodeURI(getValueByParam('title'))+"每月指标区间设置",
							store: ParamDs,
							id:'SchemUnitDetailGrid1',
							xtype: 'grid',
							cm: range1,
							trackMouseOver: true,
							region:'center',
							stripeRows: true,
							sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
							loadMask: true,
							frame: true,
							clicksToEdit: 2,
							stripeRows: true,
							listeners : {   
							'afteredit' : function(e) {   
							var mr=ParamDs.getModifiedRecords();//获取所有更新过的记录 
							   for(var i=0;i<mr.length;i++){   
									//alert("orginValue:"+mr[i].data["desc"]);//此处cell是否发生   
									var data = mr[i].data["baseValue"].trim()+"^"+mr[i].data["trageValue"].trim()+"^"+mr[i].data["bestValue"].trim();
									if(getValueByParam('extremum')=="M"){
									  data = data+"^"+mr[i].data["baseup"].trim()+"^"+mr[i].data["trageup"].trim();
									}
									var myRowid = mr[i].data["rowid"].trim();				
						    }  
							Ext.Ajax.request({
												url: UnitSchemDetail+'?action=edit&data='+data+'&rowid='+myRowid,
												failure: function(result, request) {
													Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
													var jsonData = Ext.util.JSON.decode( result.responseText );
												if (jsonData.success=='true') {
													//Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
														//AAccCycleDs.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
														this.store.commitChanges(); //还原数据修改提示
													}
													else
													{
														var message = "";
														message = "SQLErr: " + jsonData.info;
														if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
													  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
													}
												},
											scope: this
											});  
							}   
						}   
		});



var ParamSearchField = 'name';

var ParamFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '描述',value: 'info',checked: false,group: 'ParamFilter',checkHandler: onParamItemCheck })
		]}
});
function onParamItemCheck(item, checked)
{
		if(checked) {
				ParamSearchField = item.value;
				ParamFilterItem.setText(item.text + ':');
		}
}

var ParamSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				ParamDs.proxy = new Ext.data.HttpProxy({url: ParamUrl + '?action=list'});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				ParamDs.proxy = new Ext.data.HttpProxy({
				url: ParamUrl + '?action=list&searchField=' + ParamSearchField + '&searchValue=' + this.getValue()});
				ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
	    	}
		}
});
ParamDs.each(function(record){
    alert(record.get('tieOff'));

});
var ParamPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: ParamDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',ParamFilterItem,'-',ParamSearchBox]
});


////
function isEdit(value,record){   
    //向后台提交请求   
   return value?format(value):'';   
  }  
function afterEdit(obj){    //每次更改后，触发一次该事件   
          var mr=ParamDs.getModifiedRecords();//获取所有更新过的记录 
		   for(var i=0;i<mr.length;i++){   
                var data = mr[i].data["baseValue"].trim()+"^"+mr[i].data["trageValue"].trim()+"^"+mr[i].data["bestValue"].trim();
				if(getValueByParam('extremum')=="M"){
				  data = data+"^"+mr[i].data["baseup"].trim()+"^"+mr[i].data["trageup"].trim();
				}
				var myRowid = mr[i].data["rowid"].trim();
     }  
	 Ext.Ajax.request({
							url: UnitSchemDetail+'?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									this.store.commitChanges(); //还原数据修改提示
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
	 
}
//SchemDetailDistGrid1.on("afteredit", afterEdit, SchemDetailDistGrid);    
ParamDs.load({params:{start:0, limit:ParamPagingToolbar.pageSize}});
