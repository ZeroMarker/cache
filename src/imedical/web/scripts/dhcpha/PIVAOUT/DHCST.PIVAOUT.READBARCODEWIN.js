


//��ɨ����洰��
//opflag - ������ʶ   
OpenReadBarcodeWin = function(opflag) {
	
	
	
      Ext.QuickTips.init();
      
  
      ///ƿǩ����
      var BarcodeField=new Ext.form.TextField({
  
        width : 120, 
        id:"BarcodeTxt", 
        fieldLabel:"ƿǩ����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
           ///ɨ�������
      var BarcodeNumField=new Ext.form.TextField({
  
        width : 120, 
        id:"BarcodeNumTxt", 
        fieldLabel:"ɨ�����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
       
       
       ///ɨ�봰��Form
      var ReadBarcodeForm=new Ext.Panel( {
	
	  //lableWidth:80,
	  region : 'center',
	  frame :true,
	  layout : "form",
	  labelAlign : 'right',
	  items : [BarcodeField,BarcodeNumField]
	 }) ;
	  
        
     ///ɨ�봰��  
     var ReadBarcodeWindow = new Ext.Window({
	    title: '��Һ����-ɨ��',
	    width: 600,
	    height:400,
	    minWidth: 400,
	    minHeight: 300,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    items:  [  ReadBarcodeForm],	    
	    listeners: {
		  'show': function() {
		     Ext.getCmp('BarcodeTxt').focus(true,true); 
		  }
		}




 
     });
    
     ReadBarcodeWindow.show();



}