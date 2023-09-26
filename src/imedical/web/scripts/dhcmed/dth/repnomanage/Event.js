function InitDMReportNoEvent(obj){
    obj.LoadEvent=function(){
		obj.btnPass.on('click',obj.btnPass_click,obj);
		
		obj.cboLoc.on("select",obj.cboLoc_select,obj);
		obj.cboLoc.getStore().load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						for (var rowIndex = 0; rowIndex < r.length; rowIndex++){
							var record = r[rowIndex];
							if (record.get('LocRowId') == session['LOGON.CTLOCID']){
								obj.cboLoc.setValue(record.get("LocRowId"));
								obj.cboLoc.setRawValue(record.get("LocDesc"));
								obj.cboLoc_select();
							}
						}
					}
				}
			}
		});
		
		obj.gridRepNoListStore.load({params:{start:0,limit:18}});
    }
	
	obj.cboLoc_select = function(){
		obj.gridRepNoListStore.load({params:{start:0,limit:18}});
	}
	
	obj.btnPass_click=function(){
		Ext.MessageBox.confirm("提示","确定过号？",function(btn){
		  if(btn=="yes"){
			var separate="^"
			var LogonLocID=session['LOGON.CTLOCID'];
			var LogonUserID=session['LOGON.USERID'];
			var inStr=LogonLocID+separate+LogonUserID+separate+"1";
			var objFunction=ExtTool.StaticServerObject("DHCMed.DTHService.RepNoSrv");
			var retVal=objFunction.SaveDTHRepNo(inStr);
			if(retVal.indexOf("||")>0){
				obj.gridRepNoListStore.load({
				  params:{
					 start:0
					 ,limit:18
				  }
			   });
			}
		  }
		});
	}
}