//PMP.Minutes.js   »áÒé¼ÇÂ¼
///2015-02-02  zzp

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var options={
	    cssPath : '../scripts/Pmp/kindeditor/plugins/code/prettify.css',
	    filterMode:true
	    };
    KindEditor.ready(function(K) {
       window.editor=K.create('#editor_id')
      
   
	 var editor=K.create('textarea[name="content"]',options);
	 });
	 /*
    ChartInfoAddFun();
    function ChartInfoAddFun() {
	    new Ext.Window({  
        width : 650,  
        title : 'swfUpload demo',  
        height : 300,  
        layout : 'fit',  
        items :editor_id
    }).show(); 
    
    } */
})