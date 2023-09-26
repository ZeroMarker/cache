
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
Ext.onReady(function() {
	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var BarCode = new Ext.form.TextField({
		fieldLabel : '条码',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			    var prescno=Ext.getCmp("BarCode").getValue();
			    if (prescno!=""){
			    PrintJYZ(prescno)
			   window.location.href='dhcst.mbccolldrugprintjyz.csp'
			   Ext.getCmp("BarCode").setValue("");
                        Ext.getCmp("BarCode").focus();
			  //var lnk="dhcst.mbccolldrugprintjyz.csp?extfilename=dhcst/MBCCollDrug/DHCSTMBCCollDrugPrintJYZ";
                       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
        
			    }	 
			}
		    }
		}
		});	

    
  var HisListTab = new Ext.form.FormPanel({
		 labelwidth : 30,
		 labelAlign : 'right',
		 frame : true,
		 title:'煎药证打印',
		 autoScroll : false,
		 bodyStyle : 'padding:0px 0px 0px 0px;',					
		 tbar : [BarCode,"条码"]
  })       	  
         

	var por = new Ext.Viewport({

				layout : 'auto', // 使用border布局

				items : [HisListTab]

			});
	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
   



});
