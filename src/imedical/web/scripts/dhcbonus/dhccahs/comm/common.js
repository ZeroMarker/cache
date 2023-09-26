(function(){

Ext.ns("herp.ca");

})();

herp.ca.isDeal=function(){

       var dataStore=null;
       var dealFlag=null;
       
       this.setStore=function(store)
        {
	       dataStore=store;
	    }
	   this.setdealField=function(FieldName)
	    { 
		 dealFlag=FieldName;   
		}
	   this.isDeal=function()
		{ 
		  checkDeal();
		}
		
	   function checkDeal()
	   { 
        if(dataStore.getAt(0)) 
         {
	       var flag=dataStore.getAt(0).get(dealFlag); 
	      
	       if (flag=="Y")
	        { 
	       
		     Ext.Msg.show({title:'错误',msg:'本月数据已分摊，不允许操作!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		     return false;
	        }
	       else
	        {
		       return 1;
		    }
         }
         else 
         {
	      return 1;   
	      }
	   }
	    
	  
}