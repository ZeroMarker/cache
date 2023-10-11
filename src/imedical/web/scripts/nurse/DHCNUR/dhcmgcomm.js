/**
 * @author Administrator
 */
function eachItem(item,index,length) {   
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+formatDate(item.getValue())+"!date^";   
   			inserthash(item,"datefield");
   
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!time^";   
			inserthash(item,"timefield");
      
    }   if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;+"!"+item.lastSelectionText
			comboret=  comboret+item.id+"|"+item.getValue()+"^";   
            inserthash(item,"combo");
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
            inserthash(item,"textfield");
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
            inserthash(item,"textarea");
    } 
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
             inserthash(item,"checkbox"+"^"+item.boxLabel);
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
}   
function inserthash(item,typ)
{
			  if (ht.contains(item.id)) {
				}
				else {
				ht.add(item.id, typ)
			    }
} 
function sethashvalue(ha,tm)
{
	 for (i=0;i<tm.length;i++)
	 {
	 	var v=tm[i].split('|');
		var id=v[0];
		var vl=v[1];
		ha.add(id,vl);
	 }
} 

function setcheckvalue(itmkey,val)
{
  var itm=Ext.getCmp(itmkey);
  //item.boxLabel
  var arr=val.split(';');
  for (i=0;i<arr.length;i++)
  {
  	 if (itm.boxLabel==arr[i])
	 {
	 	itm.setValue(true);
	 }
  }
	
}       