var UserID = session['LOGON.USERID'];
var AcctBookID=IsExistAcctBook();
/*
var TempNoField= new Ext.form.TextField({
		//id:'addTempNoField',
        fieldLabel: '模板序号',
       // width:180, 
		allowBlank:false,
		maxLength:50,
		minLength:6,
		emptyText:'请输入模板序号',
        selectOnFocus:'true'
    });
*/

//---------取凭证类型--------//
 var VouchTypeDs = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:"results"
		},['rowid','name'])
});
	VouchTypeDs.on('beforeload',function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
				url:'herp.acct.vouchtempvinexe.csp?action=VouchTypeList',
				method :'POST'
		});
	});
var VouchTypeField = new Ext.form.ComboBox({
		fieldLabel: '凭证类别',
		store: VouchTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 120,
		listWidth : 230,
		pageSize : 10,
		minChars : 1
}); 
//----------是否私有-----------
var IsShelfStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','否'],['1','是']]
});

var IsShelfField=new Ext.form.ComboBox({
		id: 'IsShelfField',
		name: 'IsShelfField',
		fieldLabel: '是否私有',
		store: IsShelfStore,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: true,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText:'请选择...',
		minChars: 15,
		pageSize: 10,
		forceSelection:true,
		editable:true
});	

var buttons=new Ext.Toolbar(['说明：序号以999开头的为收支结转凭证模板；以998开头的为期末调汇模板。']);	

var itemMain = new dhc.herp.Grid({
		title: '模板主表维护',
		iconCls:'maintain',
		region : 'west',
		reload:true,
		// height:250,
		width: 480,
		url: 'herp.acct.vouchtempvinexe.csp',
		split : true,
		// collapsible : true,	//向左收起
		containerScroll :true,
		xtype : 'grid',
		trackMouseOver : true,
		stripeRows : true,//斑马线
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		loadMask : true,
		listeners:{
			'render':function(){
				buttons.render(itemMain.tbar);
				}
		},

		fields: [
			 //new Ext.grid.CheckboxSelectionModel({editable:false}), 
		{
			id:'rowid',
			header:'AcctTempletID',
			width:100,
			editable:false,
			dataIndex: 'rowid',
			hidden: true
		},{ 
			id:'TempNo',
			header: '<div style="text-align:center">模板序号</div>',
			dataIndex: 'TempNo',
			width:100,
			//type:TempNoField,
			allowBlank: false,
			editable:true
		}, {
			id:'TempName',
			header: '<div style="text-align:center">模板名称</div>',
			width:180,
			editable:true,
			allowBlank:false,
			dataIndex: 'TempName'
			
		}, {
			id:'VouchType',
			header: '<div style="text-align:center">凭证类型</div>',
			width:70,
			dataIndex: 'VouchType',
			allowBlank: false,
			align: 'center',
			type:VouchTypeField,
			editable:true
			
		},{
			id:'IsShelf',
			header: '<div style="text-align:center">是否私有</div>',
			width:65,
			dataIndex: 'IsShelf',
			allowBlank: true,
			align: 'center',
			type:IsShelfField,
			editable:true
			
		},{
			id:'Tempdesc',
			header: '<div style="text-align:center">模板说明</div>',
			width:120,
			dataIndex: 'Tempdesc',
			allowBlank: true,
			editable:true,
             hidden:true			
			
		},{
			id:'UserID',
			header: '<div style="text-align:center">创建人ID</div>',
			width:100,
			hidden:true,
			dataIndex: 'UserID',
			allowBlank: true,
			editable:true	
			
		},{
			id:'UserName',
			header: '<div style="text-align:center">创建人</div>',
			width:100,
			hidden:true,
			dataIndex: 'UserName',
			allowBlank: true,
			editable:true	
			
		}]
	


});

	// itemMain.btnAddHide();    //隐藏增加按钮
	// itemMain.btnSaveHide();   //隐藏保存按钮
	// itemMain.btnDeleteHide(); //隐藏删除按钮
	// itemMain.btnResetHide();  //隐藏重置按钮
	// itemMain.btnPrintHide();  //隐藏打印按钮
	// itemMain.hiddenButton(1);//隐藏第几个按钮
	
	
itemMain.load({
	params:{
		start:0, 
		limit:25,
		UserID:UserID,
		AcctBookID:AcctBookID
	}
});

// 行编辑
 itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var acctempID = selectedRow[0].data['rowid'];
	var templetNO=selectedRow[0].data['TempNo'];
	//以99开头的模板不能编辑、删除
	var title=templetNO.substr(0,2);
	if(title!='99'){
		document.getElementById("herpDeleteId").getElementsByTagName('button')[0].hidden=false;
		return true;
	}else{
		document.getElementById("herpDeleteId").getElementsByTagName('button')[0].hidden=true;
		return false;	//不可编辑
		
	}
 });
 
// 明细查询 
itemMain.on('rowclick', function () {


	var selectedRow = itemMain.getSelectionModel().getSelections();
	var acctempID = selectedRow[0].get('rowid');
	var templetNO = selectedRow[0].get('TempNo');
    //alert(templetNO);


	var title = templetNO.substr(0, 3);
	var selfTemp=templetNO.substr(0, 2);
	if (title != '999') {
		itemDetail.getColumnModel().setColumnHeader(6, "<div style=text-align:center>对方科目</div>");

	} else {
		itemDetail.getColumnModel().setColumnHeader(6, "<div style=text-align:center>结转科目</div>");

	}
	//隐藏方向、汇总明细、对方科目列
	if(selfTemp!=="99"){
		itemDetail.getColumnModel().setHidden(4,true)
		itemDetail.getColumnModel().setHidden(5,true)
		itemDetail.getColumnModel().setHidden(6,true)
	}else{
		itemDetail.getColumnModel().setHidden(4,false)
		itemDetail.getColumnModel().setHidden(5,false)
		itemDetail.getColumnModel().setHidden(6,false)
	}
	
	itemDetail.load({
		params: {
			start: 0,
			limit: 25,
			acctempID: acctempID,
			AcctBookID:AcctBookID
		}
	});

})
