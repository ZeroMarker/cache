/**
 * @author Administrator
 */

 
 var ret="";
 var checkret="";
 var comboret="";
 function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };
function eachItem(item,index,length) {   
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+formatDate(item.getValue())+"!"+item.lastSelectionText+"^";   
      
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      
    } 
	 if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
      
    } 
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
}   
           
//form.items.each(eachItem, this);  
function BodyLoadHandler(){
	//var date=Ext.getCmp("PerBusines");
 //   date.on('change',aa);
//	  var butadd=Ext.getCmp('but1');
 //  butadd.on("click",additm);
 var but=Ext.getCmp("_Button114");
 but.on('click',save);


 
}
//String.fromCharCode(1)
function save()
{
  ret="";
  checkret="";
  comboret="";
  var SaveMoudle=document.getElementById('SaveMoudle');
  var gform=Ext.getCmp("gform");
   gform.items.each(eachItem, this);  
  // alert(comboret);
  //alert(aa)
  var a=cspRunServerMethod(SaveMoudle.value,"",EmrCode,ret+"&"+checkret+"&"+comboret,EpisodeID,"","");
  

}
