//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.workitemtargetexe.csp';
/////////////////// 奖金指标下拉列表 //////////////////

var BonusTargetDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'bonustarget'])
		});
BonusTargetDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=List&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=BonusTargetList',method:'POST'
					});
		});
		
var WorkItemDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'workitem'])
		});

WorkItemDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=WorkItemList',method:'POST'
					});
		});

var BonusTargetCombo = new Ext.form.ComboBox({
			fieldLabel : '奖金指标',
			store : BonusTargetDs,
			displayField : 'bonustarget',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		
		
var BonusTargetCombo1 = new Ext.form.ComboBox({
			fieldLabel : '奖金指标',
			store : BonusTargetDs,
			displayField : 'bonustarget',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		

var WorkItemCombo = new Ext.form.ComboBox({
			fieldLabel : '工作量项目',
			store : WorkItemDs,
			displayField : 'workitem',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});					

// ///////////////////工作量项目
var titleText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});
/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var BonusTar  = BonusTargetCombo.getValue();
	    var ItemName = titleText.getValue();
		itemGrid.load({params:{start:0,limit:25,BonusTar:BonusTar,ItemName:ItemName}});
		
	}
});
  function pctChange(val) {
        if (val > 0) {
            return '<span >' + val*100 + '%</span>';
        } else if (val < 0) {
            return '<span >' + val*100 + '%</span>';
        }
        return val;
    }

var itemGrid = new dhc.herp.Grid({
        title: '工作量项目对应奖金指标映射配置',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.workitemtargetexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'bonustarget',
            header: '奖金指标',
			allowBlank: true,
			width:120,
			type:BonusTargetCombo1,
            dataIndex: 'bonustarget'
        },{
            id:'workitem',
            header: '工作量指标',
			allowBlank: true,
			width:120,
			type:WorkItemCombo,
            dataIndex: 'workitem'
        },{
            id:'ItemRate',
            header: '计提比例',
			allowBlank: true,
			width:80,
		    renderer : pctChange, 
            dataIndex: 'ItemRate'
        },{
            id:'auditdate',
            header: '修改日期',
			allowBlank: true,
			editable:false,
		    //editable:false,
			width:130,
            dataIndex: 'auditdate'
        }],
        
       tbar:['奖金指标',BonusTargetCombo,'-','工作量项目',titleText,'-',findButton]
        
});
/*
var datefield =	new Ext.form.DateField({
						id:'datefield',
                        fieldLabel: '审核时间',
                        name: 'datefield',
                        width:190,
                        allowBlank:true,
                        format:'Y-m-d',
						selectOnFocus:'true'
                    })


   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '修改',
					iconCls : 'option',
					handler : function() {
			var rowObj=itemGrid.getSelectionModel().getSelections();
		  var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			var participantsids = rowObj[i].get("ParticipantsID");	
			//alert(state);
			if(state == "未提交" ){ 
				EditPaperfun(participantsids);}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
			//刷新页面
			//itemGrid.load({params:{start:0,limit:25}});			 
	
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	      text : '删除',
					iconCls : 'remove',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			//alert(state);
			if(state == "未提交" ){ 
				delFun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });
  */
 
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnPrintHide() ;	//隐藏打印按钮
/*itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    

