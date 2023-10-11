
	
   var UserId=session['LOGON.USERID'];
   //var bookID=IsExistAcctBook();



    var ListTab = new Ext.form.FormPanel({
			id : 'ListTab',
			
			//frame : true,
			//autoScroll : true,
			// region:'center',
			html:'<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" height="100%" width="100%"  src="../csp/acct.html?acctno='+0+'&user='+UserId+'&acctstate='+6+'&bookID=&searchFlag='+0+'" />'					
				
	});





