AcctBook=IsExistAcctBook();


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
            //autoScroll : false, 
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
				itemMain.load({params : {start:0,limit:25,ReportCode:repCode,ReportName:repName,AcctBook:AcctBook}});
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
			allowBlank : true,
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
				


var BudgProAdditionalUrl = '../csp/herp.budg.budgproadditionalmainexe.csp';
var userid = session['LOGON.USERID'];

var queryPanel = new Ext.FormPanel({
	     title: '报表模板维护',
	     iconCls:'maintain',
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
						style: 'padding:0 5px;'
						//width: 60
					}, RepCodeFiled,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '报表名称',
						style: 'padding:0 5px;'
						//width: 60
					}, RepNameFiled, {
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
    //title: '报表模板维护',
	//iconCls:'maintain',
    region : 'center',
    atLoad : false, // 是否自动刷新
    url: 'herp.acct.reportempletaddexe.csp',
    viewConfig : {forceFit : true},
	//tbar : ['报表编码', RepCodeFiled,'-','报表名称', RepNameFiled, '-', findButton],
	listeners :{
		'cellclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var CheckState=record.get("CheckState")
			//alert(CheckState);
			if((CheckState=="审核")&&((columnIndex==9)||(columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==10))){
				//YRepCheckbox.disable();
				//itemMain.btnSaveHide();
				return false;
			}else{return true;}
			 
		},
		
		'celldblclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var CheckState=record.get("CheckState")
			//alert(CheckState);
			if((CheckState=="审核")&&((columnIndex==9)||(columnIndex==2)||(columnIndex==3)||(columnIndex==4)||(columnIndex==5)||(columnIndex==6)||(columnIndex==7)||(columnIndex==8)||(columnIndex==10))){
				 return false;
			}else{return true;}
			 
		}
		
	},
    fields: [
    //new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'ReportCode',
						header : '报表编码',
						dataIndex : 'ReportCode',
						width : 80,
						editable:true,
						allowBlank : false,
						hidden : false

					}, {
						id : 'ReportName',
						header : '报表名称',
						width : 150,
						editable:true,
						allowBlank : false,
						dataIndex : 'ReportName'

					}, {
						id : 'ReportType',
						header : '报表分类',
						align : 'center',
						width : 120,
						editable:true,
						type:RepTypeField,
						allowBlank : true,
						dataIndex : 'ReportType'

					},{
						id : 'MonthReport',
						header : '月报',
						editable:true,
						align : 'center',
						type:MRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						width : 60,
						dataIndex : 'MonthReport'

					}, {
						id : 'QuartReport',
						header : '季报',
						editable:true,
						align : 'center',
						width : 60,
						type:QRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						dataIndex : 'QuartReport'

					}, {
					    id:'SemyearReport',
						header : '半年报',
						width : 60,
						editable : true,
						align : 'center',
						type:SRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						dataIndex : 'SemyearReport'

					},{
						id : 'YearReport',
						header : ' 年报',
						width : 60,
						editable:true,
						align : 'center',
						type : YRepCheckbox,
						renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
						hidden:false,
						dataIndex : 'YearReport'

					}, {
						id : 'LenWayArray',
						header : '纵向数组',
						width : 75,
						editable : true,
						align : 'center',
						allowBlank : true,
						dataIndex : 'LenWayArray'
						
					},{
					    id:'ReportExplain',
						header : '报表说明文件',
						editable : false,
						align : 'center',
						width:120,
						//type:excelUpload,
						renderer : function(v, p, r) {
							//return '<input type="file" />';
								return '<span style="color:blue;cursor:hand"><u>上传</u></span>';								
						},
						dataIndex : 'ReportExplain'
					},{
						id : 'IsStop',
						header : '是否停用',
						align : 'center',
						width : 75,
						editable:false,
						dataIndex : 'IsStop'

					},{
						id : 'CheckState',
						header : '审核状态',
						width : 75,
						align : 'center',
						editable:false,
						//hidden:true,
						dataIndex : 'CheckState'

					},{
						id : 'StartDate',
						header : '启用年月',
						width : 75,
						editable:false,
						//hidden:true,
						dataIndex : 'StartDate'

					},{
						id : 'Checkers',
						header : '审核人',
						width : 110,
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
						//hidden:true,
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
	//containerScroll : true,
	xtype : 'grid',
	//trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,	
	//height:120,
	//trackMouseOver: true,
	stripeRows: true

});

itemMain.btnPrintHide(); 	//隐藏打印按钮
itemMain.btnResetHide(); 	//隐藏重置按钮
itemMain.load(({params:{start:0,limit:25,userid:userid,AcctBook:AcctBook}}));

itemMain.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemMain.getSelectionModel().getSelections();
	MainRowid=selectedRow[0].data['rowid'];
	var CheckState=selectedRow[0].data['CheckState'];
	if(CheckState=="审核"){itemMain.btnDisable();
	}else{
		itemMain.btnEnable();
	}
	var limits=Ext.getCmp("PageSizePluginhss").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
	itemDetail.load({params:{start:0, limit:limits,MainRowid:MainRowid}});	
});

// 单击gird的单元格事件
 itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// 前置方案设置
	if (columnIndex == 10) {
		var records = itemMain.getSelectionModel().getSelections();
	    var repCode=records[0].get("ReportCode");
		var RepName=records[0].get("ReportName");
	  
		if(repCode==""){
			Ext.Msg.show({title:'提示',msg:'请先保存数据再上传报表说明文件 ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}else{
			doimport(repCode,RepName);
		
		}
		
	}
	// else if(columnIndex==5){
		// alert(columnIndex);
		// MRepCheckbox.checked=true;
	// }
}); 


var doimport = function(repCode,RepName){
	var data2="";
	var freStore="";
 var URL="";
 var username="";
 var Password="";
 var Server="";
 var port="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.reportempletaddexe.csp?action=GetInfo&AcctBook='+ AcctBook,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
       var result=jsonData.info;
	 //  alert(result);
	   var info= result.split("^");	
	    URL=info[0];
		username=info[1];
		Password=info[2];
		Server=info[3];
		path=info[4];
		//alert(URL+username+Password);
                  }
             }	 
});


	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'90%',
		region:'right',
		height:25,   
		inputType: 'file',
		fieldLabel:'文件选择',
		width:40
		
	});
				
	//文件选择
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'文件选择',
		labelSeparator:'：',
		height:100,
		bodyStyle:'padding:15px;',
		align:'center',
		items:[excelUpload]
	});
				
	//多文本域
	
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		width:325,
		fieldLabel:'友好提示',
		readOnly:true,
		disabled:true,
		emptyText:'请选择'+RepName+'报表说明文件'
	
	});

	//导入说明多文本域
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'文件上传友情提示',
		labelSeparator:'：',
		items:textArea
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel数据导入',
		formId:'formUp',
		labelWidth:80,
		labelAlign:'right',
		bodyStyle:'padding:10 10 10 10',
		height:515,
		width:515,
		frame:true,
		fileUpload:true,
		items: [exampleFieldSet,upLoadFieldSet]
	});
			
	//定义按钮
	var importB = new Ext.Button({
		text:'文件上传',
		type:'submit'
	});


	
	function callback(id){
		if(id=="yes"){
			//获取公共信息
	
			var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
			if(excelName==""){
				Ext.Msg.show({title:'提示',msg:'请选择'+RepName+'报表说明文件!',buttons: Ext.Msg.OK,icon:Ext.Msg.INFO});
				return;
			}else{
				var array=new Array();
				array=excelName.split("\\");
				var fileName="";
				var i=0;
				for(i=0;i<array.length;i++){
					if(fileName==""){
						fileName=array[i];
					}else{
						fileName=fileName+"/"+array[i];
					}
				}

				
			//var uploadUrl="http://localhost:8080/HerpFtpFileUpload/FtpUploadServlet";
			//var uploadUrl="http://localhost:8080/herpacctFtpUplod/HerpAcctFtpServlet";
			var uploadUrl="http://"+URL+"/herpacctFtpUplod/HerpAcctFtpServlet";
			var upUrl=uploadUrl+"?AcctBookID="+AcctBook+"&file="+fileName+"&ReportCode="+repCode+"&username="+username+"&Password="+Password+"&Server="+Server+"&path="+path;
		     //alert(upUrl);
				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'文件上传中, 请稍等...',
					success:function(form, action) {
						//console.log(action);
						//判断当前浏览器时候为ie，包含ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						//alert(action.result);
						if(action.result!=""&& action.result!=undefined){
							
							Ext.MessageBox.alert("提示信息","文件上传成功! ");
						}else
						{
						    Ext.MessageBox.alert("提示信息","文件上传失败!请检查网络 ");
						}
					  }else{
							Ext.MessageBox.alert("提示信息","文件上传成功! ");
					  }
					},
					failure:function(form, action) {
					
							Ext.MessageBox.alert("Error","文件上传失败! ");
					}
				});
		
			}		
		}else{
			return;
		}
	}	
			  
	//下载数据功能
	var handler = function(bt){
		var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
		if(excelName==""){
				Ext.Msg.show({title:'提示',msg:'请选择'+RepName+'报表说明文件!',buttons: Ext.Msg.OK,icon:Ext.Msg.WARNING});
				return;
			}
			
		if(bt=="yes"){
		
			Ext.MessageBox.confirm('提示','确定要上传该文件吗? ',callback);
		}
		Ext.MessageBox.confirm('提示','确定要上传文件吗? ',callback);
		
	};

	

	//添加按钮的响应事件
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: '报表说明文件上传',
		width: 520,
		height:325,
		minWidth: 530,
		minHeight: 400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			importB
		]
	});
	window.show();
};