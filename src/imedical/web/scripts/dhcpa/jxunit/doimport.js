/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var doimport = function(){
	var data2="";
	var freStore="";
	
	var excelUpload = new Ext.form.TextField({   
		id:'excelUpload', 
		name:'Excel',   
		anchor:'98%',   
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
		//width:325,
		anchor:'98%', 
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
		//height:200,
		//width:500,
		frame:true,
		fileUpload:true,
		//applyTo:'form',
		//items: [publicFieldSet,upLoadFieldSet,exampleFieldSet]
		//items: [upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'导入Excel数据',handler:handler}]
		items:[excelUpload,textArea]  //2016-6-30 cyl
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
				var uploadUrl="http://localhost:8080/uploadexcel/pa.JxunitImport";
				//var uploadUrl="http://localhost:8080/uploadexcel/herp/AcctYear";
//						switch(periodType){
//						  case 'p':uploadUrl="http://localhost:8080/uploadexcel/qm/patient";break;
//						  case 'detail':uploadUrl="http://localhost:8080/uploadexcel/qm/LocResultdetail";break;
//						  default:alert("没有选择表");
//						}
			

				//var uploadUrl = "http://127.0.0.1:8080/uploadexcel/UpLoadValueServlet";
				var upUrl = uploadUrl+"?fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
				//alert(upUrl);
				//alert(fileName);
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
		width: 500,
		height:200,
		minWidth: 500,
		minHeight: 200,
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