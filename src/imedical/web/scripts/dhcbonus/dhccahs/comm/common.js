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
	       
		     Ext.Msg.show({title:'����',msg:'���������ѷ�̯�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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