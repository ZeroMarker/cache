//// �˲���ѯ-��Ŀ����-���ʽ


    var bookID=IsExistAcctBook();
    var acctbookid=bookID;//��ɾ
    var userdr = session['LOGON.USERID'];//��¼��ID
    //alert(userdr);

	
	var buttQuery = new Ext.Button({
    	text:"&nbsp;&nbsp;��&nbsp;&nbsp;ѯ",
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


