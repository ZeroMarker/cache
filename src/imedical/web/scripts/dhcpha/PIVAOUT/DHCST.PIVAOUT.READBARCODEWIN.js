


//打开扫码界面窗口
//opflag - 操作标识   
OpenReadBarcodeWin = function(opflag) {
	
	
	
      Ext.QuickTips.init();
      
  
      ///瓶签条码
      var BarcodeField=new Ext.form.TextField({
  
        width : 120, 
        id:"BarcodeTxt", 
        fieldLabel:"瓶签条码" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
           ///扫码计数器
      var BarcodeNumField=new Ext.form.TextField({
  
        width : 120, 
        id:"BarcodeNumTxt", 
        fieldLabel:"扫码计数" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
       
       
       ///扫码窗口Form
      var ReadBarcodeForm=new Ext.Panel( {
	
	  //lableWidth:80,
	  region : 'center',
	  frame :true,
	  layout : "form",
	  labelAlign : 'right',
	  items : [BarcodeField,BarcodeNumField]
	 }) ;
	  
        
     ///扫码窗口  
     var ReadBarcodeWindow = new Ext.Window({
	    title: '配液减库-扫码',
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