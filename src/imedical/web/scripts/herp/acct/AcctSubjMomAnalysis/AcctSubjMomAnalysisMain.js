//----��Ŀ����-���ʽ
var AcctBookID=IsExistAcctBook();
var UserID = session['LOGON.USERID'];//��¼��ID
  
var FindButton = new Ext.Button({
		text:"��ѯ",
		iconCls:'find',
		width:70,
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
