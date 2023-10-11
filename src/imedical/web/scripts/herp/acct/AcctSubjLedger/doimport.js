var doimport = function(importFields){

var URL="";
	 Ext.Ajax.request({
        url:'../csp/herp.acct.acctsubjledgerexe.csp?action=GetURL&bookID='+ bookID,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
        if (jsonData.success=='true'){
			URL= jsonData.info;	
		
			//alert(URL);
                  }
             }
			 
});

//var importField=importField.getValue();
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

var info="";
if(importFields==1){
	var info="注意：请选择金额数量期初余额导入模板";
	}else{
	var info="注意：请选择外币金额期初数据导入模板";
		}
				
	//文件选择
	var upLoadFieldSet = new Ext.form.FieldSet({
		title:'文件选择',
		labelSeparator:'：',
		height:130,
		//bodyStyle:'padding:10px;',
		align:'center',
		items:[excelUpload],
		html:"<br/><span  style='color:red;padding:15px'>"+info+"</span>"
	});
				
	//多文本域
	var textArea = new Ext.form.TextArea({
		id:'textArea',
		width:325,
		fieldLabel:'友好提示',
		readOnly:true,
		disabled:true,
		emptyText:'1.请您仔细核对需要导入数据的格式，保证数据的有效性，避免造成不必要的错误！'
	
	});

	//导入说明多文本域
	var exampleFieldSet = new Ext.form.FieldSet({
		title:'数据导入友情提示',
		labelSeparator:'：',
		//bodyStyle:'padding:10px;',
		align:'center',
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
		text:'数据导入',
		iconCls:'in',
		type:'submit'
	});

	//var importField=importField.getValue();
	function callback(id){
	   // alert("22");
		if(id=="yes"){
			//获取公共信息
		//alert(importFields);
		
			
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

		if (importFields==1){
				 
			//var uploadUrl="http://192.168.5.4:8080/herp.acct.importExcel/AcctLedgerServlet";
		    var uploadUrl="http://"+URL+"/herp.acct.importExcel/AcctLedgerServlet";
			var upUrl=uploadUrl+"?AcctBookID="+bookID+"&userdr="+userdr+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);
		}else if(importFields==2){
						
		    //var uploadUrl="http://192.168.5.4:8080/herp.acct.importExcel/AcctCheckLedgerServlet";
			var uploadUrl="http://"+URL+"/herp.acct.importExcel/AcctCheckLedgerServlet";
			var upUrl=uploadUrl+"?AcctBookID="+bookID+"&userdr="+userdr+"&fileType="+fileName.substring(fileName.lastIndexOf(".")+1);			
		}
			
			
				
		

				formPanel.getForm().submit({
					url:upUrl,
					method:'POST',
					waitMsg:'数据导入中, 请稍等...',
					success:function(form, action) {
						//console.log(action)

						//判断当前浏览器时候为ie，包含ie11
						var userAgent = navigator.userAgent;   
						var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;   
	
						var ua = userAgent.toLowerCase(); 
						var match = rMsie.exec(ua);  
						if(match != null){
						  //alert(action.result.success);
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