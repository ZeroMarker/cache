var UserId = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var bookID = IsExistAcctBook();
var AcctBookID = bookID

//----------------- 会计科目--------------//
	//往来科目store
	var bankStore = new Ext.data.Store({
		//autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName', 'subjCodeName'])
	});
	bankStore.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'herp.acct.AcctBankInParaexe.csp?action=GetCashSubj&AcctBookID='+AcctBookID,method:'POST'});
	});
    //往来科目ComboBox
    var acctbankCombo = new Ext.form.ComboBox({
		id : 'acctbank',
		fieldLabel : '会计科目',
		store: bankStore,
		emptyText:'',
		valueField : 'subjId',
		displayField : 'subjName',
		width:200,
		listWidth : 250,
		//allowBlank: false,
		//anchor: '90%',
		//value:'', //默认值
		//valueNotFoundText:'',
		triggerAction: 'all',
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		resizable:true
    });
	
	
 ///银行科目
//末级银行科目
var bankDs = new Ext.data.Store({
			//autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",root : 'rows'
					}, ['subjId','subjCode','subjName', 'subjCodeName'])
		});
bankDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.AcctBankInParaexe.csp?action=GetCashSubj&AcctBookID='+AcctBookID,method:'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '银行科目',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjId',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '科目字典中末级银行科目',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});	

 ///单位帐套ID
var bookIdDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','name'])
		});
bookIdDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.AcctBankInParaexe.csp?action=GetBookID&AcctBookID='+AcctBookID,method:'POST'
					});
		});
var bookIdCombo = new Ext.form.ComboBox({
			fieldLabel : '单位帐套',
			store : bookIdDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			allowBlank: false,
			selectOnFocus : true
		});		
		
//文件类型
var FileTypeStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['0', 'excel'], ['1', 'txt']]
		});
var FileTypeCombo = new Ext.form.ComboBox({
	        id:'FileTypeCombo',
			fieldLabel : '显示方式',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : FileTypeStore,
			//anchor : '90%',
			value : 1, //默认值
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false	
});

//列分隔符
var SeparatorStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['0', ','], ['1', ';']]
		});
var SeparatorCombo = new Ext.form.ComboBox({
	        id:'SeparatorCombo',
			fieldLabel : '显示方式',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : SeparatorStore,
			anchor : '90%',
			value : 1, //默认值
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false	
});

//是否借贷同列
var IsDCTColStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['1', '相同'], ['0', '不相同']]
		});
var IsDCTColCombo = new Ext.form.ComboBox({
	        id:'IsDCTColCombo',
			fieldLabel : '显示方式',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsDCTColStore,
			anchor : '90%',
			value : 1, //默认值
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false	
});

//日期格式
var DateFormateStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['1', 'YYYY-MM-DD'], ['2', 'YYYYMMDD'], ['3','YYYY年MM月DD日']]
		});
var DateFormateCombo = new Ext.form.ComboBox({
	        id:'DateFormateCombo',
			fieldLabel : '显示方式',
			width : 150,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : DateFormateStore,
			anchor : '90%',
			value : 1, //默认值
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false	
});
//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip:'查询', 
		iconCls: 'find',	       //给按钮加图标
		handler:function(){
	
			//查询函数List()的JS文件
					var AcctSubj  = deptCombo.getValue();
					 itemGrid.load({
						 params:{						 
						        //start : 0,
								//limit : 25,
								AcctSubj:AcctSubj,
								AcctBookID:AcctBookID
								}});
					}
});
//保存按钮
var saveButton = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存更改',
	iconCls: 'save',
	handler:function(){
		var records=itemGrid.getSelectionModel().getSelections();
		var AcctBookID = records[0].get("AcctBookID");
		var AcctSubjID = records[0].get("AcctSubjID");		
		//alert(AcctBookID)
		if(AcctBookID==""){
			Ext.Msg.show({title:'注意',msg:'单位账套不能为空',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		   return;
		}
		if(AcctSubjID==""){
			Ext.Msg.show({title:'注意',msg:'会计科目不能为空',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		    return;
		}
		//调用保存函数
		itemGrid.save();		
	}
});

var itemGrid = new dhc.herp.Grid({
		    //title: '银行对账单导入参数定义表维护',
		    region : 'center',
			//iconCls:'maintain',
		    url: 'herp.acct.AcctBankInParaexe.csp',
		    //atLoad : true, // 是否自动刷新
		    tbar:["银行科目",deptCombo,'-',findButton,'-',saveButton,'-'],
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'AcctBookID',
						header: '<div style="text-align:center">单位账套</div>',
						width : 150,
						type:bookIdCombo,						
						dataIndex : 'AcctBookID'
					},{
						id : 'AcctSubjID',
						header: '<div style="text-align:center">会计科目</div>',						
						width : 180,
						type: acctbankCombo,
						dataIndex : 'AcctSubjID'
						
					},{
						id : 'AcctSubjCode',
						header: '<div style="text-align:center">科目编码</div>',
						width : 150,
						allowBlank:false,
						dataIndex : 'AcctSubjCode'
					},{
						id : 'FileType',
						header: '<div style="text-align:center">文件类型</div>',
						align:'center',
						width : 80,
						hidden:true,
						type: FileTypeCombo,
						dataIndex : 'FileType'
					},{
						id : 'BeginRow',
						header: '<div style="text-align:center">数据开始行</div>',
						align:'center',
						width : 80,
						//type:'numberField',
						allowBlank:false,
						
						dataIndex : 'BeginRow'
					}, {
						id : 'OccurDate',
						header: '<div style="text-align:center">发生日期列</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'OccurDate'
					}, {
						id : 'CheqTypeCol',
						header: '<div style="text-align:center">票据类型列</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'CheqTypeCol'
					},{
						id : 'CheqNoCol',
						header: '<div style="text-align:center">支票号列</div>',
						align:'center',
						width : 80,
						allowBlank:false,
						//align: 'right',
						dataIndex : 'CheqNoCol'
					},{
						id : 'summary',
						header: '<div style="text-align:center">摘要列</div>',
						width : 80,
						align: 'center',
						dataIndex : 'summary'
					},{
						id : 'AmtDebitCol',
						header: '<div style="text-align:center">借方金额列</div>',
						width : 80,
						align: 'center',
						allowBlank:false,
						dataIndex : 'AmtDebitCol'
					},{
						id : 'AmtCrediCol',
						header: '<div style="text-align:center">贷方金额列</div>',
						width : 80,
						align: 'center',
						allowBlank:false,
						dataIndex : 'AmtCrediCol'
					},{
						id : 'Separator',
						header: '<div style="text-align:center">列分隔符</div>',
						width : 80,
						align: 'center',
						hidden:true,
						type: SeparatorCombo,
						dataIndex : 'Separator'
					},{
						id : 'Position',
						header: '<div style="text-align:center">分隔符位置</div>',
						width : 80,
						align: 'center',
						hidden:true,
						allowBlank:true,
						dataIndex : 'Position'
					},{
						id : 'IsDCTCol',
						header: '<div style="text-align:center">是否借贷同列</div>',
						width : 90,
						align: 'center',
						allowBlank:false,
						type: IsDCTColCombo,
						dataIndex : 'IsDCTCol'
					},{
						id : 'DateFormate',
						header: '<div style="text-align:center">日期格式</div>',
						width : 120,
						align: 'center',
						type: DateFormateCombo,
						dataIndex : 'DateFormate'
					}]					
		});
	itemGrid.load({params:{start:0, limit:12,AcctBookID:AcctBookID}});
	
itemGrid.on('afteredit',function(afterEdit, e){		
	var records=itemGrid.getSelectionModel().getSelections();
	var AcctSubjID = records[0].get("AcctSubjID");
	
	Ext.Ajax.request({
		url:'herp.acct.AcctBankInParaexe.csp?action=GetSubjCode&AcctSubjID='+AcctSubjID,method:'POST',
		failure: function (result, request) {
			Ext.Msg.show({
				title: '错误',
				msg: '请检查网络连接!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			//if (jsonData.success == 'true') {
				records[0].set("AcctSubjCode",jsonData.info);
			//}
		},
		scope: this
	});	 
});
/* 
 	itemGrid.btnAddHide()     //隐藏增加按钮 
    itemGrid.btnDeleteHide()  //隐藏删除按钮 */
	itemGrid.btnSaveHide()    //隐藏保存按钮
    itemGrid.btnResetHide()     //隐藏重置按钮
    itemGrid.btnPrintHide()     //隐藏打印按钮
