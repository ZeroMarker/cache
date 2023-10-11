/**
  *name:tab of database
  *author:LY
  *Date:2013-08-07
  *武汉市第一医院excel文件上传功能
 */
var importExcel = function(){
	//var uploadUrl = "http://10.0.1.142:8080/uploadexcel/ImportExcelByIdServlet";
  var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportHERPTRCourseExamServlet";
  //var uploadUrl = "http://127.0.0.1:8080/uploadexcel/ImportExcelByIdServlet";
	var data2="";
	var freStore="";

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
		items: [upLoadFieldSet,exampleFieldSet]
		//buttons:[{text:'导入Excel数据',handler:handler}]
	});
	
importdata=function(){
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',
			function(btn) {
	    	    if(btn == 'yes')
		        {	
					//判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
					if(excelName==""){
						Ext.Msg.show({title:'提示',msg:'请选择Excel文件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
						return;
					}else{ 
						Ext.MessageBox.confirm('提示','确定要导入该文件中的数据吗?',
						function(id){
							if(id=='yes')
							{
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
						//alert("filename"+fileName.substring(fileName.lastIndexOf(".")+1));
						//var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						//alert(upUrl);
								var grade=3;
								var year=2;
								var upUrl = uploadUrl+"?year="+year;
								//var upUrl = uploadUrl;
								alert(upUrl);
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
							}else{
								return;
							}
						})
				    }  
				}else{
				return;
			}
		});
	} 
	//定义按钮
	var importB = new Ext.Toolbar.Button({
		text:'数据导入',
		tooltip:'数据导入',        
        iconCls:'import',
	    handler:function(){
	        importdata();		
	}
	});
	
	
/*
	//下载数据功能
	var handler = function callback1(bt){
		if(bt=="yes"){
			alert("22"); 
			function callback(id){
				if(id=="yes"){
					
					//判断是否已选择好所要上传的excel文件
					var excelName = Ext.getCmp('excelUpload').getRawValue();//上传文件名称的路径
					alert(excelName);
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
						//alert("filename"+fileName.substring(fileName.lastIndexOf(".")+1));
						//var upUrl = uploadUrl+"?period="+period+"&periodType="+periodType+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
						//alert(upUrl);
						var upUrl = uploadUrl;
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
		Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback1);
	} 


*/
	var window = new Ext.Window({
		title: '导入excel数据',
		iconCls:'import',
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