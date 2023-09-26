/**
  *name:tab of database
  *author:wang ying
  *Date:2010-12-14
  *excel文件上传功能
 */
var uploadExcel = function(){
			var excelUpload = new Ext.form.TextField({   
				id:'excelUpload', 
				name:'Excel',   
				anchor:'90%',   
				height:20,   
				inputType:'file',
				fieldLabel:'文件选择'
			});
			
			
			//数据项目选择
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
		/*	
		var PeriodField = new Ext.form.TextField({
			id:'PeriodField',
			fieldLabel: '考核期间',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'请填写考核期间...',
			anchor: '90%',
			selectOnFocus:'true'
		});
		*/
		var formPanel = new Ext.form.FormPanel({
			//title:'Excel数据导入',
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:500,
			width:503,
			frame:true,
			fileUpload:true,
			//applyTo:'form',
			items: [upLoadFieldSet,exampleFieldSet]
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
								var uploadUrl = "http://172.16.2.20:8080/uploadexcel/uploadexcel";
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
				Ext.MessageBox.confirm('提示','确定要导入excel数据吗?',callback);
			} 
		//添加按钮的响应事件
		importB.addListener('click',handler,false);

		var win = new Ext.Window({
			title: '导入基本指标数据',
			width: 515,
			height:320,
			minWidth: 515,
			minHeight: 320,
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
		win.show();
		
}