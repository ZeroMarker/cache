// /����: ѡ��¼�뷽ʽ
// /����: ѡ��¼�뷽ʽ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.04

function SelectModel(InputType,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	// ȷ����ť
	var returnBT = new Ext.Toolbar.Button({
				text : $g('ȷ��'),
				tooltip : $g('���ȷ��'),
				iconCls : 'page_goto',
				handler : function() {
					returnData();
				}
			});

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
				text : $g('�ر�'),
				tooltip : $g('����ر�'),
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
					title:'¼�뷽ʽѡ��',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:0 0 0 0;',
					items : [{
								checked: true,				             
				                boxLabel: '¼�뷽ʽһ:������α��ʽ',
				                name: 'InputModel1',
				                inputValue: '1' 							
							},{
								checked: false,				             
				                boxLabel: '¼�뷽ʽ��:���������¼�뷽ʽ',
				                name: 'InputModel1',
				                inputValue: '2' 							
							},{
								checked: false,				             
				                boxLabel: '¼�뷽ʽ��:��Ʒ�������ʽ���Զ���Լ������ƥ�����Σ�',
				                name: 'InputModel1',
				                inputValue: '3' 							
							}]
				}],
				buttons:[returnBT,cancelBT]
	});
*/
	
	var InStkTkWin = new Ext.ux.ComboBox({
			fieldLabel : $g('ʵ�̴���'),
			id : 'InStkTkWin',
			name : 'InStkTkWin',
			anchor : '90%',
			emptyText : $g('ʵ�̴���...'),
			store : INStkTkWindowStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{'LocId':'PhaLoc'}
//			allowBlank : true,
//			triggerAction : 'all',
//			emptyText : 'ʵ�̴���...',
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
				title : $g('ʵ��¼�뷽ʽѡ��'),
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
				                boxLabel: $g('¼�뷽ʽһ:������α��ʽ�������������ݰ��������ʵ������'),
				                id: 'InputModel1',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '1' 							
							},{
								checked: false,				             
				                boxLabel: $g('¼�뷽ʽ��:���������¼�뷽ʽ'),
				                id: 'InputModel2',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '2' 							
							},{
								checked: false,				             
				                boxLabel: $g('¼�뷽ʽ��:��Ʒ�������ʽ�������������ݰ�Ʒ�����ʵ������'),
				                id: 'InputModel3',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '3' 							
							},{
								checked: false,				             
				                boxLabel: $g('¼�뷽ʽ��:����λ�����ʽ�������������ݰ���λ���ʵ������'),
				                id: 'InputModel4',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '4' 							
							},{
								checked: false,				             
				                boxLabel: $g('<font color=blue>�ƶ���¼�뷽ʽһ:</font>��Ʒ��'),
				                id: 'InputModel5',
				                name:'InputModel',
				                width : 150 ,
		                    	height : 30 ,
				                inputValue: '5' ,
				                //hidden:true
				                							
							},{
								checked: false,				             
				                boxLabel: $g('<font color=blue>�ƶ���¼�뷽ʽ��:</font>������'),
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
			Msg.info("error",$g("��ѡ��¼�뷽ʽ!"));
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