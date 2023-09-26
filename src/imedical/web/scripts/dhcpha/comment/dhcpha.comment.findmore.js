var unitsUrl = 'dhcpha.comment.main.save.csp';

MoreFindFun = function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
    var OKButton = new Ext.Button({
             width : 55,
             id:"OKButton",
             text: 'ȷ��',
             listeners:{   
                          "click":function(){  

                           
                           SendDataTOMainWin();
                           
                              }   
                       } 
             
             })	
	
   
   var CancelButton = new Ext.Button({
             width : 55,
             id:"CancelButton",
             text: 'ȡ��',
             listeners:{   
                          "click":function(){   
                           window.close()
                              }   
                       } 
             
             })		
	


 ///������Ʒ���
	
  var ComBoCtrlDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'CtrlID'},['CtrlDesc','CtrlID'])
				
	});


  ComBoCtrlDs.on(
	'beforeload',
	function(ds, o){
	
		ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetComBoCtrlDs', method:'GET'});
	
	}
  );

  var ComBoCtrl = new Ext.ux.form.LovCombo({
		fieldLabel:'���Ʒ���',
		id:'ComBoCtrlID',
		name:'ComBoCtrlID',
		store : ComBoCtrlDs,
		width:115,
		listWidth : 250,
		emptyText:'ѡ����Ʒ���...',
		hideOnSelect : false,
		maxHeight : 300,	
		valueField : 'CtrlID',
		displayField : 'CtrlDesc',
		triggerAction : 'all',
		mode:'local'

				
	});
	
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [ComBoCtrl]
	});
    
  // define window and show it in desktop
  
  
  var window = new Ext.Window({
  	title: '�����ѯ����',
    width: 800,
    height:600,
    //layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [OKButton,CancelButton]

    //html : '<iframe id="dhcpha.comment.selectreason" width=100% height=100% src=dhcpha.comment.selectreason.csp></iframe>'
     


    });

    window.show();
    
    
function SendDataTOMainWin()
{
	  
	   ctrltxt=Ext.getCmp("ComBoCtrlID").getRawValue(); 	   
	   moretxt=ctrltxt ;	   
	   Ext.getCmp("MoreField").setValue(moretxt);	   	   
	   window.close();
}    
    
    
    
    
    
    
 
};