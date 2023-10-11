AcctBook=IsExistAcctBook();
//年月下拉框
var StartYMField = new Ext.form.DateField({
    fieldLabel: '启用年月',
    name : 'StartYM',
    format : 'Y-m',
    editable : true,
    allowBlank : true,
    width: 120,
    plugins: 'monthPickerPlugin'
});
//报表编码文本框
var RepCodeFiled = new Ext.form.TextField({
            id:'RepCodeFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});
//报表名称文本框
var RepNameFiled = new Ext.form.TextField({
            id:'RepNameFiled',
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});

//月报复选框
var MRepCheckbox = new Ext.form.Checkbox({ 
            id : 'MRepCheckbox', 
            name : "MRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//季报复选框
var QRepCheckbox = new Ext.form.Checkbox({ 
            id : 'QRepCheckbox', 
            name : "QRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});

//半年报复选框
var SRepCheckbox = new Ext.form.Checkbox({ 
            id : 'SRepCheckbox', 
            name : "SRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});
		
//年报复选框
var YRepCheckbox = new Ext.form.Checkbox({ 
            id : 'YRepCheckbox', 
            name : "YRepCheckbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});		

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
				//alert(year);
				var repCode=RepCodeFiled.getValue();
				var repName=RepNameFiled.getValue();
				var StartYM=StartYMField.getValue();
				if(StartYM!=""){StartYM=StartYM.format('Y-m')};
				itemMain.load({params : {start:0,limit:25,ReportCode:repCode,ReportName:repName,StartYM:StartYM,AcctBook:AcctBook}});
	}
});

//报表分类
var RepTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '内置'], ['1', '自定义']]
		});
var RepTypeField = new Ext.form.ComboBox({
			id : 'RepTypeField',
			fieldLabel : '报表分类',
			width : 70,
			listWidth : 125,
			selectOnFocus : true,
			allowBlank : false,
			store : RepTypeStore,
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
			forceSelection : true
		});

	var queryPanel = new Ext.FormPanel({
	     title: '报表模板查询',
	     iconCls:'find',
		region: 'north',
		height: 75,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '报表编码',
						style: 'padding: 0 5px;'
						//width: 60
					}, RepCodeFiled,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '报表名称',
						style: 'padding: 0 5px;'
						//width: 60
					}, RepNameFiled, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '启用年月',
						style: 'padding: 0 5px;'
						//width: 60
					},StartYMField,{
						xtype: 'displayfield',
						value: '',
						width: 40
					},
					findButton
				]
			}
		]

	});
	
var itemMain = new dhc.herp.Grid({
    //title: '报表模板审核',
    region : 'center',
    atLoad : false, // 是否自动刷新
    url: 'herp.acct.reportempletaddexe.csp',
   // viewConfig : {forceFit : true},
	//tbar : ['报表编码：', RepCodeFiled, '-', '报表名称：', RepNameFiled, '-', '启用年月：',StartYMField,'-',findButton],
    fields: [
                    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'ReportCode',
						header : '报表编码',
						dataIndex : 'ReportCode',
						width : 80,
						editable:false,
						// type:itemcbbox,
						hidden : false

					}, {
						id : 'ReportName',
						header : '报表名称',
						width : 140,
						editable:false,
						allowBlank : false,
						dataIndex : 'ReportName'

					}, {
						id : 'ReportType',
						header : '报表分类',
						width : 120,
						align : 'center',
						editable:false,
						type:RepTypeField,
						//allowBlank : false,
						dataIndex : 'ReportType'

					},{
						id : 'MonthReport',
						header : '月报',
						editable:false,
						align : 'center',
						type:MRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						width : 60,
						dataIndex : 'MonthReport'

					}, {
						id : 'QuartReport',
						header : '季报',
						editable:false,
						align : 'center',
						width : 60,
						type:QRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						dataIndex : 'QuartReport'

					}, {
					    id:'SemyearReport',
						header : '半年报',
						width : 60,
						editable:false,
						align : 'center',
						type:SRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						dataIndex : 'SemyearReport'

					},{
						id : 'YearReport',
						header : ' 年报',
						width : 60,
						editable:false,
						align : 'center',
						type : YRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						hidden:false,
						dataIndex : 'YearReport'

					}, {
						id : 'LenWayArray',
						header : '纵向数组',
						width : 80,
						editable:false,
						align : 'center',
						dataIndex : 'LenWayArray'
						
					},{
					    id:'ReportExplain',
						header : '报表说明文件',
						width : 120,
						editable : false,
						align : 'center',
						renderer : function(v, p, r) {
								return '<span style="color:blue;cursor:hand"><u>查看</u></span>';								
						},
						dataIndex : 'ReportExplain'
					},{
						id : 'IsStop',
						header : '是否停用',
						width : 80,
						align : 'center',
						editable:false,
						dataIndex : 'IsStop'

					},{
						id : 'CheckState',
						header : '审核状态',
						width : 80,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'CheckState'

					},{
						id : 'StartDate',
						header : '启用年月',
						width : 80,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'StartDate'

					},{
						id : 'Checkers',
						header : '审核人',
						width : 100,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'Checkers'

					},{
						id : 'CheckDate',
						header : '审核时间',
						width : 100,
						align : 'center',
						editable:false,
						dataIndex : 'CheckDate'

					},{
						id : 'IsEarly',
						header : '',
						width : 50,
						editable:false,
						hidden:true,
						dataIndex : 'IsEarly'
                       //启用时间是否账套当前时间
					}],
	
	split : true,
	//collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,	
	//height:230,
	trackMouseOver: true,
	stripeRows: true

});

itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// 前置方案设置
	if (columnIndex == 10) {
		var filename="";
		var server="";
		var path="";
		var records = itemMain.getSelectionModel().getSelections();
	    var repCode=records[0].get("ReportCode");
		var RepName=records[0].get("ReportName");
		 //alert(repCode);
		Ext.Ajax.request({
        url:'../csp/herp.acct.financialreportcheckexe.csp?action=GetFileName&AcctBook='+ AcctBook+'&RepCode='+repCode,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
		var result=jsonData.info;
        if (jsonData.success=='true'){
			filename=result.split("*")[0];
			server=result.split("*")[1];
			path=result.split("*")[2];
			//alert(server+path);
			if(filename==""){
				  Ext.Msg.show({
						title : '提示',
						msg : '未上传文件! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
				
			}else{
	     // window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename); 
		  window.open("ftp://"+server+"/"+path+"/"+filename);   
                  }
		}
             }
	});
	
	}
});

itemMain.btnPrintHide(); 	//隐藏打印按钮
itemMain.btnResetHide(); 	//隐藏重置按钮
itemMain.btnAddHide() 	    //隐藏增加按钮
itemMain.btnSaveHide() 	    //隐藏保存按钮
itemMain.btnDeleteHide()    //隐藏删除按钮
itemMain.load(({params:{start:0,limit:25,AcctBook:AcctBook}}));

itemMain.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	MainRowid=selectedRow[0].data['rowid'];
	//itemDetail,setTitle("aaaaaa");
	itemDetail.load({params:{start:0, limit:25,MainRowid:MainRowid}});	
});
