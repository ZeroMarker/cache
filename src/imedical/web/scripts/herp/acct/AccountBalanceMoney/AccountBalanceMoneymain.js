//// 账簿查询-科目余额表-金额式


var bookID=IsExistAcctBook();
var userdr = session['LOGON.USERID'];//登录人ID
//alert(userdr);
    //=================================查询条件 FormPanel==========================//
	var buttQuery = new Ext.Button({
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
				//autoScroll : true,
				//layout : 'fit',
				items : [buttQuery]
	}); 
	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		//autoScroll:false, 
		html:'<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'
		
	});