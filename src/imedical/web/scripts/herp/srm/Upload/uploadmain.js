uploadMainFun=function(itemGrid,rowidIndex,SysNo,ColNum){

	itemGrid.on('cellclick',function( g, rowIndex, columnIndex, e ){
	
		if(columnIndex==ColNum){
		
		var tmpRec=itemGrid.getStore().data.items[rowIndex];
	 
		var RecDr=tmpRec.data[rowidIndex];   //上传记录ID
		
		if(RecDr==""){
			Ext.Msg.show({title : '错误',msg : '请先保存数据再上传文件!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			return ;
		}
		
		 var DataStatus1=tmpRec.data['DataStatus'];
		 
		if((DataStatus1=='已提交')&&(session['LOGON.GROUPDESC']!="科研管理系统(信息修改)")){
					Ext.Msg.show({title:'提示',msg:'数据已经提交不允许上传!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				};
		
		if (SysNo!=""){
			Ext.Ajax.request({				   	    			        
				url: 'herp.srm.uploadexe.csp'+'?action=GetSRMConfigureInfo&Type='+'1',
				success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );  
				if (jsonData.success=='true'){
					var data = jsonData.info;	
					var dataarr = data.split("^",-1);
					var ip = dataarr[0];
					var user = dataarr[1]; 	
					var userpassword = dataarr[2]; 	
					var tmpurl="http://"+ip+"/FileUpload/UploadTestServlet";
					//alert(user);
					uploadFun(RecDr,SysNo,tmpurl);         
				}
				},
				scope: this
			});  
		}
		

	}
	});
	
	uploadFun=function(RecDr,SysNo,tmpurl){
		
/**	
		if(window.location.hostname=="192.168.120.8")
{
	var uploadUrl = "http://192.168.120.8:8080/FileUpload/UploadServlet";
	}
else{
	
	var uploadUrl = "http://192.168.99.107:8080/FileUpload/UploadServlet";
	
	}
**/
 
//var uploadUrl = "http://127.0.0.1:8080/FileUpload/UploadServlet";
		
//var uploadUrl = srmuploadurl;
  var uploadUrl = tmpurl;
	
		var userID = session['LOGON.USERID'];
		Ext.QuickTips.init();  
		var userCode = session['LOGON.USERCODE'];
			//文件上传功能
			var excelUpload = new Ext.form.TextField({   
				id:'excelUpload', 
				name:'Excel',   
				//anchor:'90%',   
				height:20,   
				//inputType:'file',
				fieldLabel:'文件选择'
			});
			
			//数据项目选择
			var upLoadFieldSet = new Ext.form.FieldSet({
				title:'文件选择',
				labelSeparator:'：',
				height:10,   
				items:[excelUpload]
			});
			
		var form = new Ext.form.FormPanel({
			title:'Excel数据导入',
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:10,
			width:30,
			frame:true,
			//fileUpload:true,
			items:upLoadFieldSet
		})
		
		  var dialog = new Ext.ux.UploadDialog.Dialog({
			     //url: 'herp.srm.uploadexe.csp?action=Upload&userCode='+userCode+'&SysNo='+SysNo+'&RecDr='+RecDr,	 
			     url: uploadUrl+"?SysNo="+SysNo+"&RecDr="+RecDr,
			     reset_on_hide: false,
			     //permitted_extensions:['gif','jpeg','jpg','png','bmp','jar','zip','rar','exe'],
			     allow_close_on_upload: true,
			     upload_autostart: false,
			     //title:'图片入库',
			   	 post_var_name: 'file',
				 width  : 450,   
                 height : 300,   
                 minWidth : 450,   
                 minHeight : 300,   
                 draggable : true ,   
                 resizable : true ,   
                 //autoCreate: true,      
                 constraintoviewport: true ,
				 modal: true,
				 fileUpload:true 
	  });
	
	 dialog.show();
	   
	};


}; 
