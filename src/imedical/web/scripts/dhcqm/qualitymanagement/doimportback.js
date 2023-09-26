/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	var pTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['p','病人信息表'],['detail','科室质量考核明细']]
	});
	var periodType = new Ext.form.ComboBox({
		id: 'periodType',
		fieldLabel: '导入表',
		width:210,
	    listWidth : 210,
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

	var iperiodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['period'])
	});

	iperiodDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.targetsetexe.csp?action=period&start=0&str='+Ext.getCmp('iperiodField').getRawValue()+'&limit=14',method:'POST'})
	});
	var iperiodField = new Ext.form.ComboBox({
		id: 'iperiodField',
		fieldLabel: '考核期间',
		width:210,
		listWidth : 210,
		//allowBlank: false,
		store: iperiodDs,
		valueField: 'period',
		displayField: 'period',
		triggerAction: 'all',
		emptyText:'请选择考核期间...',
		name: 'periodField',
		minChars: 1,
		pageSize: 10,
		//selectOnFocus:true,
		//forceSelection:'true',
		editable:true
	});

	//公共条件选择
	var publicFieldSet = new Ext.form.FieldSet({
		title:'公共条件选择',
		labelSeparator:'：',
		items:[periodType]
	});
	
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'90%',   
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
		width:325,
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
		//items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'导入Excel数据',handler:handler}]
	});
			
	//定义按钮
	var importB = new Ext.Toolbar.Button({
		text:'数据导入'
	});
			
	//下载数据功能
	var handler = function(bt){
		if(bt=="yes"){
			function callback(id){
				if(id=="yes"){
					//获取公共信息
					
					var periodType=Ext.getCmp('periodType').getValue();
					var period=Ext.getCmp('periodField').getValue();

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
						var uploadUrl;

						switch(periodType){
						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
						  default:alert("没有选择表");
						}
						

						//var uploadUrl = "http://127.0.0.1:8080/uploadexcel/UpLoadValueServlet";
						var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						
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
								Ext.MessageBox.alert("Error","数据成功失败!");
							}
						});					
					}		
				}else{
					return;
				}
			}
			Ext.MessageBox.confirm('提示','确定要导入该文件中的数据吗?',callback);
		}
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback);
	} 

	//添加按钮的响应事件
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: 'Excel导入数据',
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