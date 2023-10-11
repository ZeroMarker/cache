var userid = session['LOGON.USERID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var adjustdoURL='herp.budg.adjustdoexe.csp';
//调整序号
var AdjustNoDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AdjustNo','AdjustNo'])
});
AdjustNoDs.on('beforeload', function(ds, o){
	 var year =yearCombo.getValue();
          if(!year) 
          {
         	Ext.Msg.show({title:'注意',msg:'请先选择年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
         	return;
          }
});
var AdjustNoCombo = new Ext.form.ComboBox({
	id: 'AdjustNo',
	name: 'AdjustNo',
	fieldLabel: '调整序号',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: AdjustNoDs,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'请先选择年度...',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});

// 年度///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});
smYearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=year&flag=',
						method : 'POST'
					});
		});
var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '年度...',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			columnWidth : .1,
			listeners:{
				select:{
				fn:function(combo,record,index) { 
					AdjustNoDs.removeAll(); 
					AdjustNoCombo.setValue('');   
					AdjustNoDs.proxy= new Ext.data.HttpProxy({url:commonboxURL+'?action=adjustno&flag=&year='+combo.value+'&start=0'+'&limit=10',method:'POST'});
					AdjustNoDs.load({params:{start:0,limit:10}});  
				}
			}
			}
	});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
		var year    = yearCombo.getValue();
		var adjustno= AdjustNoCombo.getValue();
		if(year==""||(adjustno=="")){
			Ext.Msg.show({title:'错误',msg:'请添加完整的查询条件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		};
		itemGridDs.load({params:{start:0, limit:25,year:year,adjustno:adjustno}});
	}
});

var SumButton = new Ext.Toolbar.Button({
			text : '汇总',
			tooltip : '数据统计汇总',
			iconCls:'add',
			handler : function() {
				var year    = yearCombo.getValue();
				var adjustno= AdjustNoCombo.getValue();
				if ((year == "")||(adjustno == "")) {
					Ext.Msg.show({title : '错误',msg : '年度、调整序号不能为空!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					return;
				};
				function handler(id) {
					if (id == 'yes') {// 添加数据初始化进度条
						var progressBar = Ext.Msg.show({title : "数据汇总",msg : "'数据正在处理中...",width : 300,wait : true,closable : true});
						Ext.Ajax.request({
							timeout : 30000000,
							url : adjustdoURL+ '?action=sum&year='+year+'&adjustno='+adjustno,
							failure : function(result, request) {
								Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({title : '注意',msg : '数据操作成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
									var year    = yearCombo.getValue();
									var adjustno= AdjustNoCombo.getValue();
									itemGridDs.load({params:{start:0, limit:25,year:year,adjustno:adjustno}});
								}else{
									Ext.Msg.show({title : '错误',msg : jsonData.info,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								}
							},
							scope : this
						})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要汇总计算吗?', handler);
			}
})


var calculateButton = new Ext.Toolbar.Button({
	text: '预算下达',
	tooltip: '预算下达',
	iconCls: 'option',
	handler: function(){
    	var adjustno = AdjustNoCombo.getValue();
    	var year = yearCombo.getValue();
        if(adjustno==""||(year==""))
        {
        	Ext.Msg.show({title:'注意',msg:'请先选择年度和调整号！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
        	return;
        }else{
			Ext.MessageBox.confirm('提示', '确定要下达预算吗？', function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
								url: adjustdoURL+'?action=ok&year='+year+"&adjustno="+adjustno,
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								  	if (jsonData.success=='true') {
								  		Ext.Msg.show({title:'注意',msg:'下达成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										itemGridDs.reload();   
									}else{
								  		var msg='下达失败!'+'SQLError:'+jsonData.info;
								  		Ext.Msg.show({title:'注意',msg:msg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
					});					
			}	
		});
       }
	}

});



var calclebudgetBut = new Ext.Toolbar.Button({
	text: '取消预算下达',
	tooltip: '取消预算下达',
	iconCls: 'option',
	handler: function(){
            var adjustno = AdjustNoCombo.getValue();
	    	var year = yearCombo.getValue();
	        if(adjustno==""||(year==""))
	        {
	        	Ext.Msg.show({title:'注意',msg:'请先选择年度和调整号！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		        return;
	        }else{
				Ext.MessageBox.confirm('提示', '确定要取消下达预算吗？', function(btn) {
				if (btn == 'yes') {
					Ext.Ajax.request({
								url: adjustdoURL+'?action=cancel&year='+year+"&adjustno="+adjustno,
								failure: function(result, request) {
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								  	if (jsonData.success=='true') {
								  		Ext.Msg.show({title:'注意',msg:'取消成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										itemGridDs.reload();   
									}else{
								  		var msg='取消失败!'+'SQLError:'+jsonData.info;
								  		Ext.Msg.show({title:'注意',msg:msg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
					});					}	
				});
			}
	}
});


var deptstate = new Ext.Toolbar.Button({
	text: '科室预算编制状态',
	tooltip: '科室预算编制状态',
	iconCls: 'option',
	handler: function(){
		DbudgFun();
	}
});

//编制状态
var StateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});
var StateField = new Ext.form.ComboBox({
	id: 'StateField',
	fieldLabel: '是否下达',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	forceSelection:true,
	allowBlank: false,
	store: StateStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15
});

//ComboBox in an Editor Grid: create reusable renderer
//适用于渲染时combobox中数据已装载的情况
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}



//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:adjustdoURL+'?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'year',
		'adjustno',
		'bsdcode',
		'bidname',
		'befadjvalue',
		'bfplanvalue',
		'adjrange',
		'aftadjvalue',
		'bfrealvaluelast',
		'sf2',
		'scf2',
		'isapprove'
	]),
    remoteSort: true
});

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(), 
    //new Ext.grid.CheckboxSelectionModel({editable:false}),
	{
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'year',
        header: '年度',
        editable:false,
        width:100,
        dataIndex: 'year',
        hidden: true
    },{
        id:'adjustno',
        header: '调整序号',
        editable:false,
        width:80,
        dataIndex: 'adjustno',
        hidden: true
    },{
        id:'bsdcode',
        header: '科目编码',
        dataIndex: 'bsdcode',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'bidname',
        header: '科目名称',
        dataIndex: 'bidname',
        width:200,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'befadjvalue',
        header: '调整前全院总预算',
        dataIndex: 'befadjvalue',
        align:'right',
        width:120,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'bfplanvalue',
        header: '本次全院调整',
        width:120,
		allowBlank: true,
		align:'right',
		editable:false,
        dataIndex: 'bfplanvalue',
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
		//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
		return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
		}
    }, {
        id:'adjrange',   
        header: '调整幅度(%)',
        align:'right',
        width:90,
        editable:false,
        allowBlank: true,
        dataIndex: 'adjrange'
		
    },{
        id:'aftadjvalue',
        header: '调整后预算',
        align:'right',
        width:120,
		allowBlank: true,
		editable:false,
        dataIndex: 'aftadjvalue'
    },{
        id:'bfrealvaluelast',
        header: '上年执行',
        align:'right',
        width:120,
		allowBlank: true,
		editable:false,
        dataIndex: 'bfrealvaluelast'
    },{
    	id:'sf2',
        header: '差额',
        align:'right',
        width:120,
	    allowBlank: true,
	    editable:false,
        dataIndex: 'sf2'
    },{
    	id:'scf2',
        header: '差异率(%)',
        align:'right',
        width:80,
	    allowBlank: true,
	    editable:false,
        dataIndex: 'scf2'
    },{
    	id:'isapprove',
        header: '是否下达',
        align:'center',
        width:80,
	    allowBlank: true,
	    editable:false,
        dataIndex: 'isapprove',
		renderer :Ext.util.Format.comboRenderer(StateField)	 
    }
]);

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});

//多表头
var row = [
 	{ header: '', colspan: 1, align: 'center' },  
    { header: '科目信息', colspan: 5, align: 'center' },//header表示父表头标题，colspan表示包含子列数目  
    { header: '预算调整', colspan: 4, align: 'center' },  
    { header: '与上年执行比较', colspan: 3, align: 'center' },
    { header: '下达信息', colspan: 1, align: 'center' }
];  
var group = new Ext.ux.grid.ColumnHeaderGroup({  
       rows: [row]  
   }); 

var itemGrid = new Ext.grid.GridPanel({
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'remote',
	plugins: group,
    atLoad : true, // 是否自动刷新
	tbar:['年度:',yearCombo,'-','调整序号','-',AdjustNoCombo,'-',findButton,'-',SumButton,'-',calculateButton,'-',calclebudgetBut],  //,'-',deptstate 
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	bbar:itemGridPagingToolbar
});

itemGridDs.on('beforeload',function(){  
    itemGridDs.baseParams = {year:yearCombo.getValue(),adjustno:AdjustNoCombo.getValue()};  
}); 

// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	if (columnIndex == 7) {	
         var records = itemGrid.getSelectionModel().getSelections();
         DeptDetail(records);
	}
});