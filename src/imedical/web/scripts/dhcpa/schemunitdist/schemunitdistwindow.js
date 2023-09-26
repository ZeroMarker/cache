//修改函数
updateSetDetailFun = function(schem,URDetail,extremum,KPIName){
var SchemUrl = 'dhc.pa.schemexe.csp';
var UnitSchemDetail = 'dhc.pa.schemunitdistexe.csp';
var DetailAddProxy = new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetailadd'});
var StratagemTabUrl = '../csp/dhcc.pa.stratagemexe.csp';
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
ParamDs.on('beforeload', function(ds, o){
	//alert(Ext.getCmp('schemedistField').getValue());
	//extremum = getValueByParam('extremum');
	ds.proxy=new Ext.data.HttpProxy({url: UnitSchemDetail+'?action=schemunitdetaildist&schem='+schem+'&rowid='+URDetail});
});

ParamDs.setDefaultSort('rowid', 'DESC');
	if((extremum =='H')||(extremum =='L')){
     range1 = new Ext.grid.ColumnModel({
				columns: [
					{header: '月份', width: 80, dataIndex: 'period'},
					{header: '年基准值', align: 'right',width: 80, dataIndex: 'baseValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
						allowBlank: false
					})
					},
					{header: '年目标值', align: 'right',width: 80, dataIndex: 'trageValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
					   allowBlank: false
				    })},
					{header: '年最佳值', align: 'right',width: 80, dataIndex: 'bestValue',
					renderer:isEdit,
					editor: new Ext.form.TextField({
					   allowBlank: false
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
						   allowBlank: false
					   })},
						{header: '年目标上限', align: 'right',width: 80, dataIndex: 'trageValue',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   allowBlank: false
					   })},
						{header: '年最佳值',align: 'right', width: 80, dataIndex: 'bestValue',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   allowBlank: false
					   })},
						{header: '年目标下限', align: 'right',width: 80, dataIndex: 'trageup',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   allowBlank: false
					   })
						},
						{header: '年基准下限', align: 'right',width: 80, dataIndex: 'baseup',
						renderer:isEdit,
						editor: new Ext.form.TextField({
						   allowBlank: false
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
			var window = new Ext.Window({
				title: '修改指标顺序',
				width: 550,
				height:550,
				minWidth: 550,
				minHeight: 400,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: SchemUnitDetailGrid1,
				//buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};