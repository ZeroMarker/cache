Ext.namespace("Ext.BDP.FunLib.AfterLoad");  
/////////////////////////写公共方法，按回车直接触发检索功能 ESC重置返回数据列表 sunfengchao///////////////////////////////////////
Ext.onReady(function() {
Ext.BDP.FunLib.AfterLoad.SearchByEnterKey=function(tablename) {  
	var CmpIDStr=tkMakeServerCall("web.DHCBL.BDP.BDPExecutables","GetEnterItems1",tablename)    
	if ((CmpIDStr!="")&&(CmpIDStr!="undefined")&&((CmpIDStr!=null))){ 
		var CmpIDArr=new Array();
		CmpIDArr=CmpIDStr.split("^"); 
		for (k=0;k<CmpIDArr.length;k++){
	 		var CmpID=Ext.getCmp(CmpIDArr[k]); 
	 		if (CmpID!=undefined){
		 		var searchid=tkMakeServerCall("web.DHCBL.BDP.BDPExecutables","FindSeachByT",tablename,CmpID.id);
		 		var resetid=tkMakeServerCall("web.DHCBL.BDP.BDPExecutables","FindResetIDByT",tablename,CmpID.id); 
		 		CmpID.searchid=searchid;
		 		CmpID.resetid=resetid;
		 	  	CmpID.on('specialkey', function(key,e){  
					if (e.keyCode ==13) {  
		 				var ComponentN=Ext.getCmp(this.searchid) 
		 				if (ComponentN!=undefined){
		 			 		ComponentN.handler();
		 				}
					 }
					 if (e.keyCode==27){
			 			var ComponentN2=Ext.getCmp(this.resetid)
			 			if (ComponentN2!=undefined){
			 				ComponentN2.handler() ;
			 			}
					 }
		    	}); 
		 	} 
		 	else{
		  		continue
		  	}
	  	}
	}
}

///Function:　设置 datefrom 在添加时为默认
   Ext.BDP.FunLib.AfterLoad.SetDefaultDateFrom=function(tableName){  
      if (tableName!="")
      var datefromstr=tkMakeServerCall("web.DHCBL.BDP.BDPExecutables","GetDateFromID",tableName) ;
      if ((datefromstr!="")&&(datefromstr!="undefined")&&((datefromstr!=null))){   
        var datearr=new Array();
        datearr=datefromstr.split("^")
        if (datearr.length>0){
          for (var i=0;i<datearr.length;i++){
          	var dateComponentID=Ext.getCmp(datearr[i])
          	if (dateComponentID!=undefined){
            	Ext.getCmp(datearr[i]).setValue(new Date())
          	}
          }
        }
      }
   }   
   
   if (Ext.BDP.FunLib.TableName!=""){
      Ext.BDP.FunLib.AfterLoad.SearchByEnterKey(Ext.BDP.FunLib.TableName);
      Ext.BDP.FunLib.AfterLoad.SetDefaultDateFrom(Ext.BDP.FunLib.TableName);
   }
 });