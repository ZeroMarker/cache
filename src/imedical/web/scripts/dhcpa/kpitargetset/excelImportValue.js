/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var importExcel = function(){
	var data2="";
	var freStore="";
	
	var pTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['t','目标值'],['b','最佳值'],['base','基准值']]
	});
	var type = new Ext.form.ComboBox({
		id: 'type',
		fieldLabel: '数据类型',
		anchor: '98%',
		selectOnFocus: true,
		allowBlank: false,
		store: pTypeStore,
		//anchor: '90%',
		value:'', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择数据类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
/*
	var periodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
	});

	periodDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.targetsetexe.csp?action=period&start=0&str='+Ext.getCmp('periodField').getRawValue()+'&limit=14',method:'POST'})
	});
	var periodField = new Ext.form.ComboBox({
		id: 'periodField',
		fieldLabel: '考核期间',
		width:210,
		listWidth : 210,
		allowBlank: false,
		store: periodDs,
		valueField: 'period',
		displayField: 'period',
		triggerAction: 'all',
		emptyText:'请选择考核期间...',
		name: 'periodField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
*/


var cDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
	});

	cDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'../csp/dhc.pa.paauditexe.csp?action=cycle&str='+Ext.getCmp('cycle').getRawValue()+'&active=Y',method:'POST'})
	});

	var cycle = new Ext.form.ComboBox({
		id: 'cycle',
		fieldLabel:'年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;度',
		//width:180,
		//listWidth : 180,
		allowBlank: false,
		store: cDs,
		valueField: 'code',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择考核周期...',
		name: 'cycleField',
		minChars: 1,
		anchor: '98%',
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
var pTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','M-月'],['Q','Q-季'],['H','H-半年'],['Y','Y-年']]
	});
	var periodType = new Ext.form.ComboBox({
		id: 'periodType',
		fieldLabel: '期间类型',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: pTypeStore,
		anchor: '98%',
		value:'', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		editable:false,
		//pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	periodType.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data2=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
		}
		if(cmb.getValue()=="Q"){
			data2=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
		}
		if(cmb.getValue()=="H"){
			data2=[['01','1~6上半年'],['02','7~12下半年']];
		}
		if(cmb.getValue()=="Y"){
			data2=[['00','全年']];
		}
		pStore.loadData(data2);
	});
	pStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var period = new Ext.form.ComboBox({
		id: 'period',
		fieldLabel: '期&nbsp;&nbsp;间&nbsp;&nbsp;值',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: pStore,
		anchor: '98%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择期间值...',
		mode: 'local', //本地模式
		editable:false,
		//pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});



	//公共条件选择
	var publicFieldSet = new Ext.form.FieldSet({
		title:'公共条件选择',
		labelSeparator:'：',
		items:[type,cycle,periodType,period]
	});
	
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor: '98%', 
		height:20,   
		inputType:'file',
		fieldLabel:'文件选择'
	});
				
	//文件选择
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'文件选择',
		labelSeparator:'：',
		items:[excelUpload]
	});
				
	//多文本域
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		anchor: '98%',
		fieldLabel:'友好提示',
		readOnly:true,
		disabled:true,
		emptyText:'请仔细核对要导入数据的格式以及数据的有效性！'
	});

	//导入说明多文本域
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'数据导入友情提示',
		labelSeparator:'：',
		items:textArea
	});

	var formPanel = new Ext.form.FormPanel({
		//title:'Excel数据导入',
		labelWidth:80,
		bodyStyle:'padding:5 5 5 5',
		height:515,
		width:515,
		frame:true,
		fileUpload:true,
		//applyTo:'form',
		items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'导入Excel数据',handler:handler}]
	});
			
	//定义按钮
	var importB = new Ext.Toolbar.Button({
		text:'数据导入'
	});
			
	//下载数据功能
	var handler = function(bt){
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback);
	} 
	function callback(id){
				if(id=="yes"){
					//获取公共信息
					var type=Ext.getCmp('type').getValue();
					var cycle=Ext.getCmp('cycle').getValue();
					var periodType=Ext.getCmp('periodType').getValue();
					var period=Ext.getCmp('period').getValue();
					var cyclePeriod=cycle+period;
				
					//判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
					if(excelName==""){
						Ext.Msg.show({title:'提示',msg:'请选择Excel文件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
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

						//var uploadUrl = "http://192.167.102.77:8080/uploadexcel/UpLoadValueServlet";
						//var uploadUrl = "http://132.147.160.114:8080/uploadexcel/UpLoadValueServlet";
						
						var uploadUrl = dhcUrl+"/uploadexcel/unitResultDetail";
						//var uploadUrl = "http://127.0.0.1:8080/uploadexcel/UpLoadValueServlet";
						var upUrl = uploadUrl+"?period="+cyclePeriod+"&periodType="+type+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						
						//alert(upUrl);
						formPanel.getForm().submit({
							url:upUrl,
							method:'POST',
							waitMsg:'数据导入中, 请稍等...',
							success:function(form, action, o) {
								Ext.MessageBox.alert("提示信息","数据成功导入!");
								//Ext.MessageBox.alert("Information",action.result.mess);
							},
							failure:function(form, action) {
								Ext.MessageBox.alert("Error",action.result.mess);
							}
						});					
					}		
				}else{
					return;
				}
			}

	//添加按钮的响应事件
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: '导入目标值、基准值、最佳值',
		width: 530,
		height:400,
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
}