/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var importExcel = function(){
	//var uploadUrl = "http://10.0.1.142:8080/uploadexcel/ImportExcelByIdServlet";
  var uploadUrl = "http://127.0.0.1:8080/excel/uploadZYYExcel";
  //var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportExcelByIdServlet";
	var data2="";
	var freStore="";
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
		fieldLabel:'考核周期',
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
		anchor: '90%',
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
		anchor: '90%',
		value:'', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	periodType.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data2=[['1','01月'],['2','02月'],['3','03月'],['4','04月'],['5','05月'],['6','06月'],['7','07月'],['8','08月'],['9','09月'],['10','10月'],['11','11月'],['12','12月']];
		}
		if(cmb.getValue()=="Q"){
			data2=[['1','01季度'],['2','02季度'],['3','03季度'],['4','04季度']];
		}
		if(cmb.getValue()=="H"){
			data2=[['1','1~6上半年'],['2','7~12下半年']];
		}
		if(cmb.getValue()=="Y"){
			data2=[['0','全年']];
		}
		pStore.loadData(data2);
	});
	pStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});

	var period = new Ext.form.ComboBox({
		id: 'period',
		fieldLabel: '期间值',
		//width:180,
		//listWidth : 180,
		selectOnFocus: true,
		allowBlank: false,
		store: pStore,
		anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择期间值...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	//公共条件选择
	var publicFieldSet = new Ext.form.FieldSet({
		title:'公共条件选择',
		labelSeparator:'：',
		items:[cycle,periodType,period]
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
					var cycleCode=Ext.getCmp('cycle').getValue();
					var periodType=Ext.getCmp('periodType').getValue();
					var period=Ext.getCmp('period').getValue();
					if(period<10){
						period="0"+period;
					}
					var period=cycleCode+period;
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
						var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType;
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
			Ext.MessageBox.confirm('提示','确定要导入该文件中的数据吗?',callback);
		}
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback);
	} 

	//添加按钮的响应事件
	importB.addListener('click',handler,false);

	var window = new Ext.Window({
		title: '导入基本指标数据',
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