/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	//质量方案
	var JournalDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});
			
	JournalDs.on('beforeload', function(ds, o) {	
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
				+'?action=ListschemDr&str='
				+ encodeURIComponent(Ext.getCmp('LocResultMainschemDr').getRawValue())+'&userid='+userid,
			method : 'POST'
		});
	});
	var LocResultMainschemDr = new Ext.form.ComboBox({
		id: 'LocResultMainschemDr',
		fieldLabel: '病例内涵',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: JournalDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		//triggerAction : 'all',
		emptyText : '',
		name: 'LocResultMainschemDr',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
	});
	
	var yearField = new Ext.form.TextField({
		id: 'importyearField',
		fieldLabel:'年份',
		width:200,
		regex: /^\d{4}$/,
		regexText:'年份为四位数字',
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'yearField',
		value:(new Date()).getFullYear(),
		minChars: 1,
		pageSize: 10,
		editable:true
	});

	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','月'],['Q','季']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'importperiodTypeField',
		fieldLabel: '期间类型',
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		//anchor: '90%',
		value:'Q', //默认值
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

	periodTypeField.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data=[['','全部'],['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
		}
		if(cmb.getValue()=="Q"){
			data=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
		}
		if(cmb.getValue()=="H"){
			data=[['01','1~6上半年'],['02','7~12下半年']];
		}
		if(cmb.getValue()=="Y"){
			data=[['00','全年']];
		}
		periodStore.loadData(data);
	});
	periodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});
	periodStore.loadData([['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']]);
	var periodField = new Ext.form.ComboBox({
		id: 'importperiodField',
		fieldLabel: '期间',
		value:(new Date()).getMonth()<10?"0"+((new Date()).getMonth()+1):((new Date()).getMonth()+1),
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: false,
		//allowBlank: false,
		store: periodStore,
		//anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});	
	


	//公共条件选择
	var publicFieldSet = new Ext.form.FieldSet({
		title:'公共条件选择',
		labelSeparator:'：',
		items:[LocResultMainschemDr,yearField,periodTypeField,periodField]
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
		formId:'formUp',
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
	var importB = new Ext.Button({
		text:'数据导入',
		type:'submit'
	});

	
	function callback(id){
	   // alert("22");
		if(id=="yes"){
			//获取公共信息
			//LocResultMainschemDr,yearField,periodTypeField,periodField
	//		var periodType=Ext.getCmp('periodType').getValue();
	//		var period=Ext.getCmp('periodField').getValue();
			var schemedr=LocResultMainschemDr.getValue();
			var periodType=periodTypeField.getValue();
			var period=yearField.getValue()+''+periodField.getValue();
			
			var year=yearField.getValue();
				var pattern=/^\d{4}$/;
				if(pattern.test(year)==false){
					Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
					return;}
			if(schemedr==""){
				Ext.Msg.show({title:'提示',msg:'病例内涵不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(periodType==""){
				Ext.Msg.show({title:'提示',msg:'期间类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}else if(period==""){
				Ext.Msg.show({title:'提示',msg:'期间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return;
			}
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

				//var uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";
			
				//var uploadUrl="http://localhost:8080/uploadexcel/herp/AcctYear";
//						switch(periodType){
//						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
//						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
//						  default:alert("没有选择表");
//						}
			

				var uploadUrl=dhcUrl+"/uploadexcel/qm/LocResultdetail";
				var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&schemedr="+schemedr+"&userid="+userid+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
				//console.log(upUrl);
				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'数据导入中, 请稍等...',
					success:function(form, action) {
						//判断当前浏览器时候为ie，包含ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
	
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						 // alert("ie");
						if(action.result!=""&& action.result!=undefined){
							Ext.MessageBox.alert("提示信息","数据导入成功!");
						}else{
						    Ext.MessageBox.alert("提示信息","数据导入失败!请检查网络");
						}
					  }else{
							Ext.MessageBox.alert("提示信息","数据导入成功!");
					  }
					},
					failure:function(form, action) {
					
							Ext.MessageBox.alert("Error","数据导入失败!");
					}
				});
				
			}		
		}else{
			return;
		}
	}	
			  
	//下载数据功能
	var handler = function(bt){
		
		if(bt=="yes"){
		
			Ext.MessageBox.confirm('提示','确定要导入该文件中的数据吗?',callback);
		}
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback);
		
	};

	

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
};