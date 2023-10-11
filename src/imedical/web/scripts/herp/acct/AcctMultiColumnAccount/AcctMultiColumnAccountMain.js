//// 账簿查询-科目余额表-金额式


    var bookID=IsExistAcctBook();
    var acctbookid=bookID;//勿删
    var userdr = session['LOGON.USERID'];//登录人ID
    //alert(userdr);

	
	var buttQuery = new Ext.Button({
    	text:"&nbsp;&nbsp;查&nbsp;&nbsp;询",
    	handler:function(){ Query();}
    
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


