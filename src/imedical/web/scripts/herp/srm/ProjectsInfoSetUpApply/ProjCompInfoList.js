 var ProjCompUrl = '../csp/herp.srm.projectapprovalapplyexe.csp';
 
 CompInfoList=function(projectrowid){
 	

///////////////////Flag//////////////////////////////////
var FlagStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '依托单位'], ['2', '合作单位']]
		});
var FlagField = new Ext.form.ComboBox({
			fieldLabel : '单位',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : FlagStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
            "select":function(combo,record,index){
        if(FlagField.getValue()==1){
	      //CompCombox.removeAll();     
				CompCombox.setValue('');
				CompStore.proxy = new Ext.data.HttpProxy({url:ProjCompUrl+'?action=relyuintslist1&prjrowid='+projectrowid,method:'POST'})  
				CompStore.load();   
			}   		
			else
			{
				//CompCombox.removeAll();     
				CompCombox.setValue('');
				CompStore.proxy = new Ext.data.HttpProxy({url:ProjCompUrl+'?action=relyuintslist2',method:'POST'})  
				CompStore.load(); 
			}			
			}
		}
		});
////////////////////单位Comp/////////////
var CompStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

var CompCombox = new Ext.form.ComboBox({
			store : CompStore,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
////////////////////分工/////////////
var DivideWorkField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////项目经费/////////////
var FundTotalField=new Ext.form.NumberField({
	width : 120,
	selectOnFocus : true
});

////////////////////上级拨款/////////////
var FundGovField=new Ext.form.NumberField({
	width : 120,
	selectOnFocus : true
});
/**
var searchbutton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	
	    var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;

	   		if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请先选择项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{
			mainrowid=selectedRow[0].data['rowid'];
			
			DetailGrid.load({params:{sortField:'',sortDir:'',start:0, limit:12,mainrowid:mainrowid}})
			}
	}
});
**/
var ProjCompGrid = new dhc.herp.CompGrid({
			region : 'center',
			url : ProjCompUrl,	
      cm : colModel,
      //selModel:sm,
      readerModel:'remote',		
			fields : [          
			{ 		
            id:'ID',
						header : 'ID',
						dataIndex : 'rowid',
						width : '120',
						hidden : true
					},{ 		
            id:'prjrowid',
						header : '项目ID',
						dataIndex : 'prjrowid',
						width : '120',
						hidden : true
					},{
						id : 'Flag',
						header : '单位类型',
						dataIndex : 'Flag',
						width : 120,
						align : 'right',
						editable:true,        
						hidden : false,
						type:FlagField

					}, {
						id : 'CompDR',
						header : '单位DR',
						width : 120,
						editable:true,
            align : 'right',
						dataIndex : 'CompDR',
						hidden:true
				}, {
						id : 'CompName',
						header : '单位名称',
						width : 120,
						editable:true,
            align : 'right',
						dataIndex : 'CompName',
					  type:CompCombox
				}, {
						id : 'DivideWork',
						header : '项目分工',
						width : 120,
						align : 'right',
            editable: true,
						dataIndex : 'DivideWork',
						type:DivideWorkField
					},{
						id : 'FundTotal',
						header : '项目经费（万元）',
						width : 120,
						editable: true,
						align : 'right',	
						dataIndex : 'FundTotal',
						type:FundTotalField
					},{
						id : 'FundGov',
						header : '上级资助经费（万元）',
						width : 120,
						editable : true,
						align : 'right',
						dataIndex : 'FundGov',
						type:FundGovField
						
					}]
		});
ProjCompGrid.btnResetHide();  //隐藏重置按钮
ProjCompGrid.btnPrintHide();  //隐藏打印按钮
    
ProjCompGrid.load({params:{start:0,limit:15,prjrowid:projectrowid}});

  // 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProjCompGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '项目分工信息',
				plain : true,
				width : 468,
				height : 300,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}
