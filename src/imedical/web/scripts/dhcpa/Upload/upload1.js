
uploadFun=function(RecDr,SysNo,ProStatus){
//alert(addInvhs);
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
		/**	
	 var dialog = new Ext.ux.UploadDialog.Dialog({
	  	url: 'dhc.pa.testlyexe.csp?actiontype=Upload',	 
	  	reset_on_hide: false,
	  	//permitted_extensions:['gif','jpeg','jpg','png','bmp','jar','zip','rar','exe'],
	  	allow_close_on_upload: true,
	  	upload_autostart: false,
	  	title:'图片入库',
	  	post_var_name: 'file'
	  });
		 **/
	//userId, RecDr, SysNo,ProStatus
		  var dialog = new Ext.ux.UploadDialog.Dialog({
			     url: 'herp.srm.uploadexe.csp?actiontype=Upload&userCode='+userCode+'&SysNo='+SysNo+'&RecDr='+RecDr+'&ProStatus='+ProStatus,	 
			     reset_on_hide: false,
			     //permitted_extensions:['gif','jpeg','jpg','png','bmp','jar','zip','rar','exe'],
			     allow_close_on_upload: true,
			     upload_autostart: false,
			     //title:'图片入库',
			   	 post_var_name: 'file',
				 width : 450,   
                 height : 300,   
                 minWidth : 450,   
                 minHeight : 300,   
                 draggable : true ,   
                 resizable : true ,   
                 //autoCreate: true,      
                 constraintoviewport: true ,
				 modal: true 
	  });
	
	 dialog.show();
	   
	};  
	  //dialog.show('show-button');
	
	  

			

     