
   Ext.onReady(function() { 
   
  var dialog = new Ext.ux.UploadDialog.Dialog({
	  	url: 'dhcstm.apcvendoraction.csp?actiontype=Upload',
	  	reset_on_hide: false,
	  	//permitted_extensions:['gif','jpeg','jpg','png','bmp','jar','zip','rar','exe'],
	  	allow_close_on_upload: true,
	  	upload_autostart: false,
	  	//title:'Í¼Æ¬Èë¿â',
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
	   
	});  
	  //dialog.show('show-button');
       