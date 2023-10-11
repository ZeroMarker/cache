var userdr = session['LOGON.USERID'];
var tmpData="";
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var budgprojsubmitauditDs=function(){
		
	var year				= yearField.getValue();
	var projname			= projnameField.getValue();
	var applyname			= applynameField.getValue();
	var applyno				= applynoField.getValue();
	
	var Iscurrent			= IscurrentField.getValue();
	if(Iscurrent){
		Iscurrent = 1
	}else{
		Iscurrent = 0
	}
	//alert(Iscurrent);
	
    //tmpData=year+'^'+projname+'^'+documents+'^'+applyname+'^'+itemdesc;
	itemGrid.load(({params:{start:0, limit:25,year:year,projname:projname,applyname:applyname,applyno:applyno,Iscurrent:Iscurrent,userdr:userdr}}));
};

//立项年度
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=year&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '立项年度',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//项目名称

var projnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


projnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgprojsubmitauditexe.csp'+'?action=projname&userdr='+userdr,method:'POST'});
});

var projnameField = new Ext.form.ComboBox({
	id: 'projnameField',
	fieldLabel: '项目名称',
	width:150,
	listWidth : 300,
	store: projnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	name: 'projnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//申请人

var applynameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


applynameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:commonboxUrl+'?action=username',method:'POST'});
});

var applynameField = new Ext.form.ComboBox({
	id: 'applynameField',
	fieldLabel: '申请人',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: applynameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	name: 'applynameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//报销单号
var applynoField = new Ext.form.TextField({
			columnWidth : .143,
			width : 150,
			selectOnFocus : true

		});
//当前审批单据
var IscurrentField = new Ext.form.Checkbox({												
				fieldLabel: '当前审批单据'
			});


var queryPanel = new Ext.FormPanel({
	height:140,
	region:'north',
	frame:true,
	defaults: {bodyStyle:'padding:5px'},
		items:[{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'<center><p style="font-weight:bold;font-size:150%">项目支出报销管理</p></center>',
				columnWidth:1,
				height:'50'
			}
		]
	   },{
	    columnWidth:1,
	    xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'立项年度:',
				columnWidth:.07
			},
			yearField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.08
			},{
				xtype:'displayfield',
				value:'',
				columnWidth:.075
			},{
				xtype:'displayfield',
				value:'',
				columnWidth:.1
			},{
				xtype:'displayfield',
				value:'项目名称:',
				columnWidth:.07
			},
			projnameField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.1
			},IscurrentField,
			{
				xtype:'displayfield',
				value:'当前审批单据',
				columnWidth:.1
			}
		]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
			{
				xtype:'displayfield',
				value:'申请人:',
				columnWidth:.058
			},
			applynameField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
			},
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.068
			},
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.095
			},
			{
				xtype:'displayfield',
				value:'报销单号:',
				columnWidth:.06
			},
			applynoField,
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.06
			},
			{
				xtype:'displayfield',
				value:'',
				columnWidth:.06
			},
			{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){
					budgprojsubmitauditDs();
				},
				iconCls: 'add'
			}		
		]
	}
	]
});
var UploadButton = new Ext.Toolbar.Button({
    text:'上传图片',
    tooltip:'上传图片',
    iconCls:'upload',
    //width : 70,
    //height : 30,
    handler:function(){
    	
        var rowObj = itemGrid.getSelectionModel().getSelections(); 
        var len = rowObj.length;
        var message="请选择对应的单据！";  
        if(len < 1){
            Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            return false;
        }else{
            var rowid = rowObj[0].get('rowid');
            var dialog = new Ext.ux.UploadDialog.Dialog({
            url: 'herp.budg.budgprojclaimapplydetailexe.csp?action=Upload&rowid='+rowid,
            reset_on_hide: false, 
            permitted_extensions:['gif','jpeg','jpg','png','bmp'],
            allow_close_on_upload: true,
            upload_autostart: false,
            title:'上传单据信息图片'
            //post_var_name: 'file'
      });
      dialog.show();
        }
    }
});

var itemGrid = new dhc.herp.Grid({
        title: '项目支出报销管理',
        width: 400,
        region: 'center',
        tbar:[UploadButton],
        url: 'herp.budg.budgprojsubmitauditexe.csp',
		//atLoad : true, // 是否自动刷新
		listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
               var record = grid.getStore().getAt(rowIndex);
               // 根据条件设置单元格点击编辑是否可用
               //alert(columnIndex);
               var chk = record.data['ChkStep'];
               var no = record.data['StepNO'];
               if (((record.get('ChkState') =="新建")||(record.data['IsCurStep']=="否")||(chk!=no))&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },      
         'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if (((record.get('ChkState') =="新建")||(record.data['IsCurStep']=="否")||(chk!=no)) && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },
        fields: [
        {
            header: 'ID',
            dataIndex: 'rowid',
            hidden: true
        },{
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
                     dataIndex : 'CompName'

	    },{
            id:'audit',
            header: '选择',
            dataIndex: 'audit',
            width : 40,
            editable:false,
            renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsCurStep'];
						var cf = record.data['ChkState'];
						var chk = record.data['ChkStep'];
						var no = record.data['StepNO'];
						if ((sf == "是")&&(cf=="提交")&&(chk==no)) {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>审核</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand">审核</span>';
						}},
		   hidden : false
        }, {
			id : 'year',
			header : '年度',
			width : 40,
			editable:false,
			dataIndex : 'year'
	
       }, {
			id : 'code',
			header : '报销单号',
			width : 120,
			editable:false,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
				//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
				return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			},
			dataIndex : 'code'

		},{
			id : 'name',
			header : '项目名称',
			editable:false,
			width : 200,
			//renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
				//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
			//	return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			//},
			dataIndex : 'name'

		}, {
			id : 'deptname',
			header : '报销科室',
			editable:false,
			width : 140,
			dataIndex : 'deptname'

	   },{
			id : 'username',
			header : '报销人',
			width : 60,
			editable:false,
			dataIndex : 'username'

	   },{
			id : 'Desc',
			header : '报销说明',
			width : 160,
			editable:false,
			//hidden:true,
			dataIndex : 'Desc'

		},{
			
			id : 'Actmoney',
			header : '报销金额',
			width : 150,
			editable : false,
			align:'right',
		    dataIndex : 'Actmoney'
			
		},{
			id : 'budgco',
			header : '预算结余',
			width : 150,
			editable:false,
			align:'right',
			dataIndex : 'budgco'

		},{
			id : 'budgcotrol',
			header : '预算控制',
			width : 80,
			editable:false,
			hidden:false,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			var sf = record.data['budgcotrol']
			if (sf == "超出预算") {
				return '<span style="color:red;cursor:hand;">'+value+'</span>';
			} else {
				return '<span style="color:black;cursor:hand">'+value+'</span>';
			}},
			dataIndex : 'budgcotrol'

		},{
			id : 'IsCurStep',
			header : '是否为当前审批',
			width : 60,
			editable:false,
			hidden:true,
			dataIndex : 'IsCurStep'

		},/*{
			id : 'BillState',
			header : '单据状态',
			width : 60,
			align : 'center',
			editable:false,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			var sf = record.data['BillState']
			if (sf == "新建") {
				return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
			} else if (sf == "提交"){
				return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
			}else {
				return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
			}},
			dataIndex : 'BillState'

					},*/{
						id : 'ChkState',
						header : '审核状态',
						width : 80,
						editable:false,
						dataIndex : 'ChkState'

					},{
						id : 'ChkStep',
						header : '登录人步奏号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ChkStep'

					},{
						id : '当前步奏号',
						header : 'StepNO',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'StepNO'

					},{
						id : 'File',
						header : '附件图片',
						width : 150,
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			 			},
						dataIndex : 'File'
					}],
			//viewConfig : {forceFit : true},
			xtype : 'grid',
			loadMask : true
			

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:25,userdr:userdr}});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	
	
	if (columnIndex == 5) {		

		var records = itemGrid.getSelectionModel().getSelections();
		var rowid = records[0].get("rowid")
		var Code  		 = records[0].get("code");
		var dname  		 = records[0].get("deptname");
		var uName  		 = records[0].get("username");
		var Name  		 = records[0].get("name");
		var Desc  		 = records[0].get("Desc");
		var year 		 = records[0].get("year");
		applyFun(rowid,Code,dname,uName,Name,Desc,year);
	
	}
	
	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("name");
		ProjnameFun(FundBillDR,Name);
	}

	if (columnIndex == 14) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("code");
		var Name		 = records[0].get("name");
		stateFun(FundBillDR,Code,Name);
	}
	if (columnIndex == 3) {		
				
			var records = itemGrid.getSelectionModel().getSelections();
			var IsCurStep = records[0].get("IsCurStep")
			var rowid = records[0].get("rowid")
			checkFun(rowid);

	}
	
			//附件图片的显示
	//alert(columnIndex)
	if (columnIndex == 17) {
		var records = itemGrid.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		projpayuploadFun(rowid);
	}
		
	
});


