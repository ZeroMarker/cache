var projUrl = '../csp/herp.acct.acctversinglecertifexe.csp';
var userdr = session['LOGON.USERID'];
var bookID= IsExistAcctBook();
var Verifytext = new Ext.form.TextField({
			columnWidth : .1,
			width : 200,
			columnWidth : .12,
			emptyText: '������ƾ֤����......',
			//disabled: true,
			selectOnFocus : true,
			listeners : {
				
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER){
						var vercode=Verifytext.getValue();
						//alert(vercode);
						p_URL = 'acct.html?acctno='+vercode+'&user='+userdr+'&acctstate='+'11'+'&bookID='+bookID+'&searchFlag='+'1';
					  // p_URL= 'http://ylxt.dhcc.com.cn/ylxt/'
					
					}
					
					//var VouchState=21;
					//alert(vercode);
					
					//alert(p_URL);

                    var reportFrame=document.getElementById("frameReport");
                    //alert(reportFrame);
                    reportFrame.src=p_URL;
		
					}	
			

		}
});
		
var vercode=Verifytext.getValue();		
var VerifyButton = new Ext.Toolbar.Button({
		text: '�� ��',
    	tooltip: '',        
    	iconCls: 'option',
		handler: function(){
			  
			  p_URL = '../scripts/herp/acct/images/logon_bg.jpg';
              var reportFrame=document.getElementById("frameReport");
              reportFrame.src=p_URL;
              
			  var vercode=Verifytext.getValue();
			  Ext.Ajax.request({
				  url: '../csp/acct.html?acctno='+vercode,
					
					url:projUrl+'?action=audit'+'&vercode='+vercode+'&userdr='+userdr,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
			        success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if ((jsonData.success=='true'))
						{				
							if(jsonData.info=='Repuser')
							Ext.Msg.show({title:'ע��',msg:'��Ȩ�����!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='unsubmitted')
							Ext.Msg.show({title:'ע��',msg:'δ�ύ������ˣ�',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='accounted')
							Ext.Msg.show({title:'ע��',msg:'�Ѽ��˲�����ˣ�',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							if(jsonData.info=='again')
							{
				            	if (confirm("����˵���ȷ��������ˣ�")) 
				            	{    
                                  verifyauditFun(vercode,userdr); 
                                } else 
                                {  
								window.close();
								p_URL = 'acct.html?acctno='+vercode+'&user='+userdr;
                    			var reportFrame=document.getElementById("frameReport");
                    			reportFrame.src=p_URL;
                                }  
							}
							//itemMain.load({params:{start:0, limit:12,userdr:userdr}});
							//itemDetail.load({params:{start:0, limit:12,vercode:"",ChkResult:"",view:"",statusid:""}});
						    if(jsonData.info=='go')
						    
				 			verifyauditFun(vercode,userdr);     
						}
						
					},
					scope: this
			    });			       		      
		}	
			
});

var VouProButton = new Ext.Toolbar.Button({
		text: 'ƾ֤������ϸ',
    	tooltip: '',        
    	iconCls: '',
		handler: function(){
			 // p_URL = '../scripts/herp/acct/images/logon_bg.jpg';
             // var reportFrame=document.getElementById("frameReport");
             // reportFrame.src=p_URL;
              //alert(1)
			var vercode=Verifytext.getValue();
			if (vercode==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ��ƾ֤��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			   }
			else
			   {				   											
				 	VouchProgressFun(vercode);   
				 	//url:projUrl+'?action=listd'+'&start='+0+'&limit='+25+'&vercode='+vercode;  						      	 
			   }
	}                 
});
/*
var reportPanel=new Ext.Panel({
		autoScroll:true,
		region:'center',
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/herp/acct/images/logon_bg.jpg" />'
    })
*/
var ListTab = new Ext.form.FormPanel({
			id : 'ListTab',
			frame : true,
			autoScroll : true, 
			tbar : ['ƾ֤���룺','-',Verifytext,'-',VerifyButton,'-',VouProButton] ,
			items : [
					  {
						xtype : 'panel',
						width : 1120,
						height : 580,
						title : '',
						layout:'fit',
						//region:'center',
						html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/herp/acct/images/logon_bg.jpg" />'					
					   // html:'<div id="frameReport" height="100%" width="100%" src="../scripts/herp/acct/images/logon_bg.jpg" />'
					  }
					]			
	})
