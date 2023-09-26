editAAccCycleFun = function() {
	var dialog=new Ext.ux.UploadDialog.Dialog({
	    url:ServletURL+'/etl/FileUpload',
		collapsible:true,
		modal:true,
		closable:true,
		draggable:true,
		minWidth:400,
		minHight:200,
		width:400,
		height:200,
		permitted_extensions:[
		'txt','doc','docx','mdb','xls','xlsx'
		],
		resizable:true,
		title:"文件上传",
		allow_close_on_upload:false,
		reset_on_hide:true
	});
	dialog.show('show-button');
};