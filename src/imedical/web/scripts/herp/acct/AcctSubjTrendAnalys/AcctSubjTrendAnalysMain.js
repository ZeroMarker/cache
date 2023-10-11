//// 财务分析--科目对比分析

var userid = session['LOGON.USERID'];
var bookID=IsExistAcctBook();
var userdr = session['LOGON.USERID'];

var FindButton = new Ext.Button({
	text:"查询",
	width:70,
	iconCls:'find',
	handler:function(){ 
			Query();
		}

});
formPanel =  new Ext.form.FormPanel({
			id : 'formPanel',
			frame : true,
			items : [FindButton]
}); 
var reportPanel=new Ext.Panel({
	autoScroll:true,
	layout:'fit',
	//autoScroll:false, 
	html:'<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'
	
});

