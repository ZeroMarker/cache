// /名称: 选择录入方式
// /描述: 选择录入方式
// /编写者：zhangdongmei
// /编写日期: 2012.09.04

function SelectModel(InputType,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
				text : $g('确定'),
				tooltip : $g('点击确定'),
				iconCls : 'page_goto',
				handler : function() {
					returnData();
				}
			});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
				text : $g('关闭'),
				tooltip : $g('点击关闭'),
				iconCls : 'page_delete',
				handler : function() {
					window.close();
				}
			});
/*
	var SelectModelForm = new Ext.form.FormPanel({
				frame : true,
				labelAlign : 'right',
				id : "SelectModelForm",
				items:[{
					xtype:'fieldset',
					title:'录入方式选择',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:0 0 0 0;',
					items : [{
								checked: true,				             
				                boxLabel: '录入方式一:填充批次表格式',
				                name: 'InputModel1',
				                inputValue: '1' 							
							},{
								checked: false,				             
				                boxLabel: '录入方式二:按库存批次录入方式',
				                name: 'InputModel1',
				                inputValue: '2' 							
							},{
								checked: false,				             
				                boxLabel: '录入方式三:按品种填充表格式（自动按约定规则匹配批次）',
				                name: 'InputModel1',
				                inputValue: '3' 							
							}]
				}],
				buttons:[returnBT,cancelBT]
	});
*/
	
	var InStkTkWin = new Ext.ux.ComboBox({
			fieldLabel : $g('实盘窗口'),
			id : 'InStkTkWin',
			name : 'InStkTkWin',
			anchor : '90%',
			emptyText : $g('实盘窗口...'),
			store : INStkTkWindowStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{'LocId':'PhaLoc'}
//			allowBlank : true,
//			triggerAction : 'all',
//			emptyText : '实盘窗口...',
//			selectOnFocus : true,
//			forceSelection : true,
//			minChars : 1,
//			pageSize : 20,
//			valueNotFoundText : '',
//			listeners:{
//				'beforequery':function(e){
//					this.store.removeAll();
//					this.store.setBaseParam('LocId',gLocId);
//					this.store.load({params:{start:0,limit:20}});
//				}
//			}
		});		
	var window = new Ext.Window({
				title : $g('实盘录入方式选择'),
				width : 500,
				height : 320,
				labelWidth:100,
			      plain:true,
			      modal:true,
				items:[{
					xtype:'radiogroup',
					id:'InputModel',
					anchor: '95%',
					columns: 1,
					style: 'padding:5px 5px 5px 5px;',
					items : [{
								checked: true,				             
				                boxLabel: $g('录入方式一:填充批次表格式（根据账盘数据按批次填充实盘数）'),
				                id: 'InputModel1',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '1' 							
							},{
								checked: false,				             
				                boxLabel: $g('录入方式二:按库存批次录入方式'),
				                id: 'InputModel2',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '2' 							
							},{
								checked: false,				             
				                boxLabel: $g('录入方式三:按品种填充表格式（根据账盘数据按品种填充实盘数）'),
				                id: 'InputModel3',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '3' 							
							},{
								checked: false,				             
				                boxLabel: $g('录入方式四:按货位填充表格式（根据账盘数据按货位填充实盘数）'),
				                id: 'InputModel4',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '4' 							
							},{
								checked: false,				             
				                boxLabel: $g('<font color=blue>移动端录入方式一:</font>按品种'),
				                id: 'InputModel5',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '5' ,
				                //hidden:true
				                							
							},{
								checked: false,				             
				                boxLabel: $g('<font color=blue>移动端录入方式二:</font>按批次'),
				                id: 'InputModel6',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '6' ,
				                //hidden:true							
							}]
					},{
						layout:'form',
						frame:true,
						border:false,
						labelAlign:'right',
						items:[InStkTkWin]
					}
					],
				buttons:[returnBT,cancelBT]			
			});

	window.show();	
	
	if(InputType==1){
		Ext.getCmp("InputModel3").setDisabled(true);
		Ext.getCmp("InputModel5").setDisabled(true);
	}else if(InputType==2){
		Ext.getCmp("InputModel1").setDisabled(true);
		Ext.getCmp("InputModel2").setDisabled(true);
		Ext.getCmp("InputModel3").setValue(true);
		Ext.getCmp("InputModel4").setDisabled(true);
		Ext.getCmp("InputModel5").setDisabled(true);
		Ext.getCmp("InputModel6").setDisabled(true);
	}
	else if(InputType==5){
		Ext.getCmp("InputModel1").setDisabled(true);
		Ext.getCmp("InputModel2").setDisabled(true);
		Ext.getCmp("InputModel3").setDisabled(true);
		Ext.getCmp("InputModel4").setDisabled(true);
		Ext.getCmp("InputModel6").setDisabled(true);
		Ext.getCmp("InputModel5").setValue(true);
	}
	else if(InputType==6){
		Ext.getCmp("InputModel1").setDisabled(true);
		Ext.getCmp("InputModel2").setDisabled(true);
		Ext.getCmp("InputModel3").setDisabled(true);
		Ext.getCmp("InputModel4").setDisabled(true);
		Ext.getCmp("InputModel5").setDisabled(true);
		Ext.getCmp("InputModel6").setValue(true);
	}
	
	

	function returnData() {
		var selectModel = Ext.getCmp('InputModel').getValue();	
		if (selectModel== null) {
			Msg.info("error",$g("请选择录入方式!"));
		} else {
			SelectData();
			window.close();
		}
	}

	function SelectData(){
		var selectRadio = Ext.getCmp('InputModel').getValue();	
		if(selectRadio){
			var selectModel =selectRadio.inputValue;    // selectRadio.getValue();
			var instwWin=Ext.getCmp("InStkTkWin").getValue();
			Fn(selectModel,instwWin);	
		}	
	}
}