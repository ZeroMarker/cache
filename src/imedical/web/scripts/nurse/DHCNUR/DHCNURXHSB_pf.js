var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();



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
 var dd=0
function eachItem1(item,index,length) 
{   
	if (item.getId()=="EmrUser") 
	{
		
	}
    else
	{  	
    if ((usertype=="护理部")&&(session['LOGON.GROUPDESC']=="护理部"))  //护理部只允许修改 压疮性质：Item49;护理部追踪验证（由护理部填写）:Item53 
    {
		
      if ((item.getId()=="Item49")||(item.getId()=="Item53"))
      { 
        if (item.xtype=="textfield") {   
             //修改下拉框的请求地址    
			       ret=  ret+item.id+"|"+item.getValue()+"^";        
             } 
      	 if (item.xtype=="textarea") {   
            //取G元素框值  
			  ret=  ret+item.id+"|"+item.getRawValue()+"^";         
        } 
        if (item.xtype=="combo") {   
            //取下拉单选框O值   
			   comboret= comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
        } 
       
      }
    }
    if (usertype=="科护士长")
    {  //alert(Usercode)
    	 //alert(session['LOGON.USERCODE'])
    	 // 科护士长同时是病区护士长时 可以修改非审核状态的所在病区的上报单
    	 if (((Status=="")||(Status=="S1")||(Status=="S2"))&&(((Usercode==session['LOGON.USERCODE'])&&(Usercode!=""))||(Usercode=="")))
    	 {
    	 	 if ((item.getId()=="Item49")||((item.getId()=="Item53")))   
    	 	  {
    	 	 	}
    	 	 else
    	 	 	{
    	 	 		  if (item.xtype=="datefield") {   
             //取日期框值 
			        ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   	     
              } 
            if (item.xtype=="timefield") {   
             //修改下拉框的请求地址    
			       ret=  ret+item.id+"|"+item.getValue()+"^";         
             } 
	          if (item.xtype=="combo") {   
             //取下拉单选框值   
			       comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
             } 
	          if (item.xtype=="textfield") {   
             //修改下拉框的请求地址    
			       ret=  ret+item.id+"|"+item.getValue()+"^";        
             } 
	          if (item.xtype=="textarea") {   
             //取G元素框值  
			       ret=  ret+item.id+"|"+item.getRawValue()+"^";         
             } 
	          if (item.xtype=="checkbox") {   
             //修改下拉框的请求地址    
			      if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
             } 
    	 	 		
    	 	 		}
    	 	
    	 }
    	 else   //科护士长可以修改其他病区科护士长效果评价（由科护士长填写）：Item46
    	 	{
         if ((item.getId()=="Item46")||((item.getId()=="Item47"))||((item.getId()=="Item48")))   
         {  
           if (item.xtype=="textarea") 
            {   
            //取G元素框值  
			     ret=  ret+item.id+"|"+item.getRawValue()+"^";         
            } 
           if (item.xtype=="datefield")
            {   
            //取日期框值 
			      ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   	     
            } 
            if (item.xtype=="textfield") 
            {   
            //取文本   
			      ret=  ret+item.id+"|"+item.getValue()+"^";        
            } 
      	   //alert(ret)
         }
        }
    }
    if ((usertype=="护士长")||(usertype=="")||(session['LOGON.GROUPDESC']=="住院护士长"))  //病区护士长
    {   
    	 if (Status=="S2") //评价中
  	   { //可以修改 采取的改进措施（由科室护士长填写）：Item41科室效果评价（由科室护士长填写）：Item44
  	   	if (((item.getId()=="Item41")||((item.getId()=="Item42"))||((item.getId()=="Item43"))||(item.getId()=="Item44")||(item.getId()=="Item45")||(item.getId()=="Item45")))
  	   	{
  	   	    if (item.xtype=="datefield") {   
             //取日期框值 
			        ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   	     
              } 
            if (item.xtype=="timefield") {   
             //修改下拉框的请求地址    
			       ret=  ret+item.id+"|"+item.getValue()+"^";         
             } 
	          if (item.xtype=="combo") {   
             //取下拉单选框值   
			       comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
             } 
	          if (item.xtype=="textfield") {   
             //修改下拉框的请求地址    
			       ret=  ret+item.id+"|"+item.getValue()+"^";        
             } 
	          if (item.xtype=="textarea") {   
             //取G元素框值  
			       ret=  ret+item.id+"|"+item.getRawValue()+"^";         
             } 
	          if (item.xtype=="checkbox") {   
             //修改下拉框的请求地址    
			      if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
             } 
         }  	   	
  	   }
  	  if ((Status=="V")||((Status=="")))  //新建和未提交可行修改采取的改进措施以上的
  	  {
  	    if (((item.getId()=="Item41")||((item.getId()=="Item42"))||((item.getId()=="Item43"))||(item.getId()=="Item44")||(item.getId()=="Item45")||(item.getId()=="Item46")||((item.getId()=="Item47"))||((item.getId()=="Item48"))||(item.getId()=="Item49")||((item.getId()=="Item53"))))
  	    { 	    	
  	    }
  	    else
  		    {
            if (item.xtype=="datefield") {   
            //取日期框值 
			      ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   	     
            } 
            if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			      ret=  ret+item.id+"|"+item.getValue()+"^";         
            } 
	          if (item.xtype=="combo") {   
            //取下拉单选框值   
			      comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
            } 
	          if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			      ret=  ret+item.id+"|"+item.getValue()+"^";        
            } 
	          if (item.xtype=="textarea") {   
            //取G元素框值  
			      ret=  ret+item.id+"|"+item.getRawValue()+"^";         
            } 
	          if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			      if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
            } 
	        } 
	    }
    }
    if (item.items && item.items.getCount() > 0)  
        {item.items.each(eachItem1, this);  } 
  }       
}  
function eachItem11(item,index,length) {   
 if (item.xtype == "checkbox") {
 item.on('check',function(obj, ischecked){checksj(obj)} );
 	
 }
	   if (item.items && item.items.getCount() > 0) { 	     
       item.items.each(eachItem11, this);         
   }   
    
}    
function eachItemcheck(item,index,length) {   
	 
     	if (item.xtype=="checkbox") {   
 			if (item.id.indexOf("_")!=-1)
			{
				var aa=item.id.split("_");
				var bb=checkItem.split("_");
				if (aa[0]==bb[0])
				{
					//alert(item.id+"|"+checkItem);
					if (item.id!=checkItem) 
					{
						checkret=checkret+item.id+"^";
						//checkflag="true";
					}
				}

			}
        } 

	   if (item.items && item.items.getCount() > 0) { 
	      
       item.items.each(eachItemcheck, this);   
    }       
}  
var checkItem=""; 
var checkflag="true";
function checksj(item)
{  if (checkflag=="false") return;  
   checkret="";
   checkItem=item.id; 
  // alert(checkItem); 
   var item=checkItem.split("_")[0];
   //alert(item); 
   if (item=='Item9'||item=='Item13')
   {//alert(8);
   if (item.check=true)
   {  
   	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItemcheck, this);     
	   checkflag="false";	 
	   var aa=checkret.split("^");
	 for (var i=0;i<aa.length;i++)
	 {
	 	if (aa[i]=="")continue;
		var ch=Ext.getCmp(aa[i]);
		ch.setValue(false);
	 }
	  checkflag="true"; 
   }
 }
  // totelmouth();    
} 
function yczj(obj)
 { 
 	  var flag=this.getValue()
 	  if (flag==true)
 	  {	  	numyc=numyc+1 	  	}
 	  else
 	  { 	  numyc=numyc-1 	  }
	 	var Item24= Ext.getCmp("Item24"); 
	  Item24.setValue(numyc) 		  
   }
var ITypItm="Item533331"; //后取数据字典型
var numyc=0;
var usertype=0;
var PatInfo=document.getElementById('gettype');
if (PatInfo) {
   //alert(session['LOGON.USERCODE'])
   usertype=cspRunServerMethod(PatInfo.value,session['LOGON.USERCODE']);
   //alert(usertype)		
	}
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butsave");
  but.on('click',Save);
	var but=Ext.getCmp("butprint");
  but.on('click',butPrintFn);
  var but=Ext.getCmp("butSave2");
  but.on('click',Save);
  var but=Ext.getCmp("Braden");
  but.on('click',Braden);
  var but=Ext.getCmp("fy");
  but.on('click',newfy);
  var but=Ext.getCmp("fy2");
  but.on('click',newfy2);
	var but=Ext.getCmp("butPrint2");
  but.on('click',butPrintFn);
   var but=Ext.getCmp("butprintSB");
   but.on('click',butPrintFnSB);
	var gform=Ext.getCmp("gform");
	var but=Ext.getCmp("ycfj");
    but.on('click',Linkycfjb);
    var but=Ext.getCmp("ycbw");
    but.on('click',Linkycbw);
     if (EpisodeID=="")
      {
 
    }
     else
      	{
      		var but=Ext.getCmp("Item18");
    but.disable()
      		}
     var Item45= Ext.getCmp("Item45");
  var Item51= Ext.getCmp("Item51");  
  Item45.hide()
  Item51.hide()
    var but=Ext.getCmp("EmrDate");
    //but.setValue(new Date)
    //but.disable();
	var but=Ext.getCmp("EmrUser");
	but.disable();
    //alert(Usercode)
  //计算压疮部位数
  var Item211= Ext.getCmp("Item21_1"); 
  var Item212= Ext.getCmp("Item21_2"); 
  var Item213= Ext.getCmp("Item21_3"); 
  var Item214= Ext.getCmp("Item21_4"); 
  var Item215= Ext.getCmp("Item21_5"); 
  var Item216= Ext.getCmp("Item21_6"); 
  var Item217= Ext.getCmp("Item21_7"); 
  var Item218= Ext.getCmp("Item21_8"); 
  var Item219= Ext.getCmp("Item21_9"); 
  var Item220= Ext.getCmp("Item21_10"); 
  var Item221= Ext.getCmp("Item21_11"); 
  var Item222= Ext.getCmp("Item21_12");
  var Item223= Ext.getCmp("Item21_13");  
  Item211.on("check",yczj)
  Item212.on("check",yczj)
  Item213.on("check",yczj)
  Item214.on("check",yczj)
  Item215.on("check",yczj)
  Item216.on("check",yczj)
  Item217.on("check",yczj)
  Item218.on("check",yczj)
  Item219.on("check",yczj)
  Item220.on("check",yczj)
  Item221.on("check",yczj)
  Item222.on("check",yczj)  
  Item223.on("check",yczj)    
   var Item111= Ext.getCmp("Item11_1");
   var Item131= Ext.getCmp("Item13_1");	 
	 Item111.on("check",function()
	 {     var dd11=Item111.getValue()
	 	if (dd11==true)
	 	{
	 	    var Item13_1= Ext.getCmp("Item13_1");
    		Item13_1.setValue(false)    		
    	}
   })
    Item131.on("check",function()
	  {    var cc13=Item131.getValue()		
	 	    if (cc13==true)
	 	    {
	 	    var Item13_1= Ext.getCmp("Item11_1");
    		Item13_1.setValue(false)
    	  }
    	})
   var Item58_1= Ext.getCmp("Item58_1");
	 Item58_1.on("check",function(check)
	 {			
			  var Item58_2= Ext.getCmp("Item58_2");
			  var dd=Item58_2.getValue()
			  var cc=Item58_1.getValue()			 
			  if ((cc==true)&&(dd==true))
			  {	 Item58_2.setValue(false)	}
			  if (cc==true)
			  {
			  	var Item11_1= Ext.getCmp("Item11_1");
			  	Item11_1.setValue(false)
			  	var Item13_1= Ext.getCmp("Item13_1");
			  	Item13_1.setValue(false)
			  }
			 
	})
	var Item58_2= Ext.getCmp("Item58_2");
	 Item58_2.on("check",function(check)
	 {			
			  var Item58_1= Ext.getCmp("Item58_1");
			  var dd=Item58_2.getValue()
			  var cc=Item58_1.getValue()			 
			  if ((dd==true)&&(cc==true))
			  {	 Item58_1.setValue(false)	}
			   if (dd==true)
			  {
			  	var Item10_1= Ext.getCmp("Item10_1");
			  	Item10_1.setValue(false)
			  	var Item10_2= Ext.getCmp("Item10_2");
			  	Item10_2.setValue(false)
			  	var Item10_3= Ext.getCmp("Item10_3");
			  	Item10_3.setValue(false)
			  	var Item10_4= Ext.getCmp("Item10_4");
			  	Item10_4.setValue(false)
			  	
			  }
	})
	 
   var Item28_1= Ext.getCmp("Item28_1");
	 Item28_1.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item54");
			  var dd=Item54.getValue()
			  var cc=Item28_1.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue(" ") }
	})
	 var Item28_2= Ext.getCmp("Item28_2");
	 Item28_2.on("check",function(check)
	 {			
			  var Item55= Ext.getCmp("Item55");
			  var dd=Item55.getValue()
			  var cc=Item28_2.getValue()		
			  //alert(cc)	 
			  if (cc==true)
			  {	 Item55.setValue("√")	}
			  else
			  {	 Item55.setValue(" ") }
	 })
	 var Item28_3= Ext.getCmp("Item28_3");
	 Item28_3.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item56");
			  var dd=Item54.getValue()
			  var cc=Item28_3.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue(" ") }
	 })
	 var Item28_4= Ext.getCmp("Item28_4");
	 Item28_4.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item57");
			  var dd=Item54.getValue()
			  var cc=Item28_4.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue(" ") }
	 })
	setvalue()

	if (Status=="S1")  //已提交  但不是评价中 除护理部外保存按钮隐藏
	{
		 //var Item42=Ext.get("Item41");
		 var Item44=Ext.fly("Item44");		
		 Item44.setStyle({	            
     background: '#cccccc'
     })
      var Item44=Ext.get("Item25");		
		 Item44.setStyle({	            
     background: '#cccccc'
     })
		// Item42.highlight('FF0000',
   //{endColor:'0000FF', duration: 22});
		if (usertype!="护理部")
	  {	
	 	 var butsave=Ext.getCmp("butsave");
		 if(butsave)  butsave.hide();	
		 var butsave=Ext.getCmp("butSave2");
		 if(butsave)  butsave.hide();	
		}
	}
	if ((Status=="S2"))  //评价中 保存按钮都保留
	{  
		  //if (usertype!="护理部")
	    //{	
	    //	var butsave=Ext.getCmp("butsave");
		  //  if(butsave)  butsave.hide();	
		  //  var butsave=Ext.getCmp("butSave2");
		  // if(butsave)  butsave.hide();	
		  //}
	}
	if (Status=="A")   //已审核 都不能修改
	{
		   var butsave=Ext.getCmp("butsave");
		   if(butsave)  butsave.hide();	
		   var butsave=Ext.getCmp("butSave2");
		   if(butsave)  butsave.hide();	
	}
	if (usertype=="科护士长")
	{
		  var Item48=Ext.getCmp("Item48");
		   var Item47=Ext.getCmp("Item47");
		   var Item46=Ext.getCmp("Item46");
		  Item47.disable()
		  Item48.disable()
		  if (Item46.getValue()=="")
		  { 
		  Item48.setValue(session['LOGON.USERNAME'])
		  Item47.setValue(diffDate(new Date(), 0))
		  }
	}
	//alert(usertype)
	//alert(Status)
	
	if (((usertype=="护士长")||(session['LOGON.GROUPDESC']=="住院护士长"))&&(Status=="S2"))
	{  
		  var Item41=Ext.getCmp("Item41");
		  var Item44=Ext.getCmp("Item44");
		  var Item42=Ext.getCmp("Item42");
		  var Item43=Ext.getCmp("Item43");
		  Item42.disable()
		  Item43.disable()
		  if (Item41.getValue()=="")
		  {  
		  	 Item43.setValue(session['LOGON.USERNAME'])
		     Item42.setValue(diffDate(new Date(), 0))
		  }
		  var Item45=Ext.getCmp("Item45");
		  var Item51=Ext.getCmp("Item51");
		  Item45.disable()
		  Item51.disable()
		  if (Item44.getValue()=="")
		 { 		 
		  Item51.setValue(session['LOGON.USERNAME'])
		  Item45.setValue(diffDate(new Date(), 0))
		 }		
	}

	/*	
	var ii=1;
	for (ii=1;ii<100;ii++)
	{
		var itm="Item"+ii;
		var obj=Ext.getCmp(itm);
	  if (obj)
	  {
	  	if ((Status=="S1"))
	  	{ 
	  		if (usertype=="护理部")
	  		{
	  				var butsave=Ext.getCmp("butsave");
		        if(butsave)  butsave.hide();	
	  		}
	  		else
	  			{  if (usertype=="科护士长")
	  				{
	  		       if (((ii==46)||(ii==47)||(ii==48)))
	  		       {
	  				    //obj.disable(false);
	  		       }
	  		       else
	  		       {
	  		        obj.disable();
	  	         }
	  		    }
	  		    if (usertype=="")
	  		    {
	  		       if (((ii==41)||(ii==42)||(ii==43)||(ii==44)||(ii==45)||(ii==51)))
	  		        {
	  			    
	  		        }
	  		
	  		        else
	  		       {
	  		         obj.disable();
	  	          }
	  	     }
	  	  }
	  		
	  	}
	  	if ((Status=="S2"))
	  	{ if ((ii==53)||(ii==49))
	  		{
	  				//obj.disable(false);
	  				if (usertype!="护理部")
	  				{ obj.disable();}
	  		}
	  		else
	  		{
	  		   obj.disable();
	  	  }
	  		
	  	}
	    if ((Status=="V")&&((ii==41)||(ii==42)||(ii==43)||(ii==44)||(ii==45)||(ii==51)||(ii==46)||(ii==47)||(ii==48)||(ii==49)||(ii==53)))
	  	{
	  		obj.disable();
	  	}	  
	  }	
	}
	*/
}
function  sjj()
{}
var jj=0
var kk=0

var wind2;   //全局变量
function Braden()
{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurBraden&EpisodeID="+EpisodeID+"&Status="+Status+"&NurRecId="+NurRecId //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 
     var dd=kk%2 
	  
	   if (dd==0)
	   {
	   wind2= window.open(lnk,"html22ww",'left=200,toolbar=no,location=no,directories=no,resizable=yes,width=600,height=500');
	   kk=kk+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind2)!="undefined"&&wind2.open&&!wind2.closed)  //判断是否存在子窗口并处于打开状态
         {   
           wind2.close();  //关闭子窗口
          }
          var getzf =document.getElementById('getzf');
         ret=cspRunServerMethod(getzf.value,EpisodeID);
         //alert(ret)
         var zf= Ext.getCmp("Item18");
	       zf.setValue(ret);
          kk=kk+1;
	   	}

}
var wind3;   //全局变量
var kkk=0
var ddd=0
function newfy()
{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurfy&EpisodeID="+EpisodeID+"&Status="+Status+"&NurRecId="+NurRecId  //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 
     var ddd=kkk%2 
	  
	   if (ddd==0)
	   {	   	
	   wind3= window.open(lnk,"html22ww",'left=700,toolbar=no,location=no,directories=no,resizable=yes,width=570,height=500');
	   kkk=kkk+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind3)!="undefined"&&wind3.open&&!wind3.closed)  //判断是否存在子窗口并处于打开状态
         {   
           wind3.close();  //关闭子窗口
          }
         // var getzf =document.getElementById('getzf');
         //ret=cspRunServerMethod(getzf.value,EpisodeID);
         //alert(ret)
        // var zf= Ext.getCmp("Item18");
	       //zf.setValue(ret);
          kkk=kkk+1;
	   	}

}
var wind32;   //全局变量
var kkk2=0
var ddd2=0
function newfy2()
{
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurfy2&EpisodeID="+EpisodeID+"&Status="+Status+"&NurRecId="+NurRecId  //""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 
     var ddd2=kkk2%2 
	  
	   if (ddd2==0)
	   {	   	
	   wind32= window.open(lnk,"html22ww2",'left=700,toolbar=no,location=no,directories=no,resizable=yes,width=570,height=500');
	   kkk2=kkk2+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind32)!="undefined"&&wind32.open&&!wind32.closed)  //判断是否存在子窗口并处于打开状态
         {   
           wind32.close();  //关闭子窗口
          }
         // var getzf =document.getElementById('getzf');
         //ret=cspRunServerMethod(getzf.value,EpisodeID);
         //alert(ret)
        // var zf= Ext.getCmp("Item18");
	       //zf.setValue(ret);
          kkk2=kkk2+1;
	   	}

}
function  Linkycfjb()
{   
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXHSB_YCFJB&EpisodeID="+""+"&NurRecId="+""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	  //window.showModalDialog(lnk,,'');
	   
	   var dd=jj%2 
	   //alert(dd)
	   if (dd==0)
	   {
	   wind2=window.open(lnk,"html",'left=470,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=900');
	   jj=jj+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind2)!="undefined"&&wind2.open&&!wind2.closed)  //判断是否存在子窗口并处于打开状态
         {   
           wind2.close();  //关闭子窗口
          }
          jj=jj+1;
	   	}
}
	var ii=0
	var wind;   //全局变量
	function  Linkycbw()
{   
		var lnk= WebIp+"/dhcmg/yct.jpg"  ;//"&DtId="+DtId+"&ExamId="+ExamId
	   var dd=ii%2 
	   //alert(dd)
	   if (dd==0)
	   {
	   wind=window.open(lnk,"html2",'left=850,toolbar=no,location=no,directories=no,resizable=yes,width=450,height=350');
	   ii=ii+1;
	   }
	   else 
	   	{
	   		 if(typeof(wind)!="undefined"&&wind.open&&!wind.closed)  //判断是否存在子窗口并处于打开状态
         {   
           wind.close();  //关闭子窗口
          }
          ii=ii+1;
	   	}
	
	}
function scoreAdd(obj)
{
	 //var scorearry1=new Array(); 
	 var scorehj=0; 
	 var tmp=obj.getValue();
	 //alert(tmp)
	 //tmp=scoreFormat(tmp);
     
	 var PatInfo=document.getElementById('PatInfo');
	  if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,tmp);
		//alert(ret);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item1");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	    var age = Ext.getCmp("Item5");
	    age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.setValue(getValueByCode(tt[2]));
	 	//var bedCode = Ext.getCmp("Item2");
	 	//bedCode.setValue(getValueByCode(tt[5]));
	    	var MedCareNo = Ext.getCmp("Item2");
	 	//alert(MedCareNo);
	 	MedCareNo.setValue(getValueByCode(tt[9]));
	 	var diag = Ext.getCmp("Item7");
	 	diag.setValue(getValueByCode(tt[8]));
      }
}

function cmbkey(field, e)
{//alert(33)
	if (e.getKey() ==Ext.EventObject.ENTER)
	{  //alert(e.getKey)
		var pp=field.lastQuery;
		//alert(pp)
		//alert(field)
		getlistdata(pp,field);
	//	alert(ret);
		
	}
}
var person=new Array();
function getlistdata(p,cmb)
{
	var GetPerson =document.getElementById('GetBed');
	//debugger;
	//alert(GetPerson)
    var ret=cspRunServerMethod(GetPerson.value,session['LOGON.CTLOCID']);
   // alert(ret)
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addperson(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}

function setVal2(itm,val)
{
	    if (val=="") return ;
	   	var tt=val.split('!');
		//alert(tt);
	 	var cm=Ext.getCmp(itm);
		person=new Array();
		addperson(tt[1],tt[0]);
		cm.store.loadData(person);
		cm.setValue(tt[0]);
		 
}

var person=new Array();



function btclose()
{
	window.close();
}


var person=new Array();
function getlistdata111(p,cmb)
{
	var GetPerson =document.getElementById('GetBed');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,"414");
    //alert(ret)
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addperson(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}

function AddRec(a, b) {
	alert(a)
	alert(b)
	REC.push({
				loc : a,
				locdes : b
			});
}
function AddRec11(str)
{
	//var a=new Object(eval(str));
	//alert(str)
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function setvalue()
{ 
   //alert(NurRecId);

 if(NurRecId!="")
   {
   
   //alert(ExamId);
   var ha = new Hashtable();
  //var getid=document.getElementById('GetId');
   //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //EpisodeID_"^"_NurRecId;
  
  
   	var getVal = document.getElementById('getVal');
   	 //alert(112);
   	//var ret = cspRunServerMethod(getVal.value, NurRecId);
   	var ret = tkMakeServerCall("Nur.DHCNurSBData","getVal", NurRecId);
   	///alert(ret);
   	var tm = ret.split('^')
		sethashvalue(ha, tm);					
	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItem, this);  
	
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) 
		{
			
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));			
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			itm.setValue(getval(ha.items(key)));			
	    }else{
			var aa=key.split('_');
			if(ha.contains(aa[0]))
			{
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
    }
   }
   else
   {
   getPatInfo();	
   }
	
 
}
function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
}
function ifflag(itm)
{ //alert(tm);
	var tm=ITypItm.split('|');
	//alert(tm);
	var flag=false;
	for (var i=0;i<tm.length;i++)
	{
		if (itm==tm[i])
		{
			flag=true;
		}
	}
	return flag ;
}
function ifsave()
{
}
var flag9="";
function Save()
{
  ret="";
  //alert(122)
  checkret="";
  comboret="";
 // alert(Status)
  var SaveRec=document.getElementById('Save');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
  //alert(checkret);
 var Item104= Ext.getCmp("Item10_4")
  var Item15= Ext.getCmp("Item14");
  if ((Item104.getValue()==true)&&(Item15.getValue()==""))
  {
  	alert("请填写\"院外带来:其他:\"")
  	return;
  }
  var Item1610= Ext.getCmp("Item16_10")
  var Item17= Ext.getCmp("Item17");
  if ((Item1610.getValue()==true)&&(Item17.getValue()==""))
  {
  	alert("请填写\"患者状态:其他:\"")
  	return;
  }
   var Item2113= Ext.getCmp("Item21_13")
  var Item23= Ext.getCmp("Item23");
  if ((Item2113.getValue()==true)&&(Item23.getValue()==""))
  {
  	alert("请填写\"压疮部位:其他:\"")
  	return;
  }
   var Item267= Ext.getCmp("Item26_7")
  var Item27= Ext.getCmp("Item27");
  if ((Item267.getValue()==true)&&(Item27.getValue()==""))
  {
  	alert("请填写\"创面情况:其他:\"")
  	return;
  }
   var Item284= Ext.getCmp("Item28_4")
   var Item321= Ext.getCmp("Item32_1")
   var Item322= Ext.getCmp("Item32_2")
  var Item36= Ext.getCmp("Item36");
  if ((Item284.getValue()==true)&&(Item322.getValue()=="")&&(Item321.getValue()==""))
  {
  	alert("请填写\"压疮发生的原因(可多选):其他因素:\"")
  	return;
  }
  if ((Item322.getValue()==true)&&(Item36.getValue()==""))
  {
  	alert("请填写\"其他因素:其他:\"")
  	return;
  }
   var Item2910= Ext.getCmp("Item29_10")
  var Item33= Ext.getCmp("Item33");
  if ((Item2910.getValue()==true)&&(Item33.getValue()==""))
  {
  	alert("请填写\"患者因素:其他:\"")
  	return;
  }
   var Item303= Ext.getCmp("Item30_3")
  var Item34= Ext.getCmp("Item34");
  if ((Item303.getValue()==true)&&(Item34.getValue()==""))
  {
  	alert("请填写\"医疗因素:其他:\"")
  	return;
  }
    var Item319= Ext.getCmp("Item31_9")
  var Item35= Ext.getCmp("Item35");
  if ((Item319.getValue()==true)&&(Item35.getValue()==""))
  {
  	alert("请填写\"护理人员因素:其他:\"")
  	return;
  }
   var Item3711= Ext.getCmp("Item37_10")
  var Item59= Ext.getCmp("Item59");
  if ((Item3711.getValue()==true)&&(Item59.getValue()==""))
  {
  	alert("请填写\"已采取措施:其他:\"")
  	return;
  }
  var Item291= Ext.getCmp("Item29_1");
  var Item292= Ext.getCmp("Item29_2");
  var Item293= Ext.getCmp("Item29_3");
  var Item294= Ext.getCmp("Item29_4");
  var Item295= Ext.getCmp("Item29_5");
  var Item296= Ext.getCmp("Item29_6");
  var Item297= Ext.getCmp("Item29_7");
  var Item298= Ext.getCmp("Item29_8");
  var Item299= Ext.getCmp("Item29_9");
  var Item54=Ext.getCmp("Item54");
  if(Item54.getValue()=="√"){
	 if((Item291.getValue()=="")&&(Item292.getValue()=="")&&(Item293.getValue()=="")&&(Item294.getValue()=="")&&(Item295.getValue()=="")&&(Item296.getValue()=="")&&(Item297.getValue()=="")&&(Item298.getValue()=="")&&(Item299.getValue()=="")&&(Item2910.getValue()=="")){
		 alert("请选择患者因素!");
		 return;
	 } 
  }
  var Item301= Ext.getCmp("Item30_1");
  var Item302= Ext.getCmp("Item30_2");
  var Item303= Ext.getCmp("Item30_3");
  var Item55=Ext.getCmp("Item55");
  if(Item55.getValue()=="√"){
	 if((Item301.getValue()=="")&&(Item302.getValue()=="")&&(Item303.getValue()=="")){
		 alert("请选择医疗因素!");
		 return;
	 } 
  }
  var Item311= Ext.getCmp("Item31_1");
  var Item312= Ext.getCmp("Item31_2");
  var Item313= Ext.getCmp("Item31_3");
  var Item314= Ext.getCmp("Item31_4");
  var Item315= Ext.getCmp("Item31_5");
  var Item316= Ext.getCmp("Item31_6");
  var Item317= Ext.getCmp("Item31_7");
  var Item318= Ext.getCmp("Item31_8");
  var Item319= Ext.getCmp("Item31_9");
  var Item56=Ext.getCmp("Item56");
  if(Item56.getValue()=="√"){
	 if((Item311.getValue()=="")&&(Item312.getValue()=="")&&(Item313.getValue()=="")&&(Item314.getValue()=="")&&(Item315.getValue()=="")&&(Item316.getValue()=="")&&(Item317.getValue()=="")&&(Item318.getValue()=="")&&(Item319.getValue()=="")){
		 alert("请选择护理人员因素!");
		 return;
	 } 
  }
  var Item321= Ext.getCmp("Item32_1");
  var Item322= Ext.getCmp("Item32_2");
  var Item57=Ext.getCmp("Item57");
  if(Item57.getValue()=="√"){
	 if((Item321.getValue()=="")&&(Item322.getValue()=="")){
		 alert("请选择其他因素!");
		 return;
	 } 
  }
  //alert(checkret);
  //alert(ret);
  //alert(comboret);
  //alert(ret+checkret+comboret)
  //alert(NurRecId)
 if(NurRecId!="")
 {
   var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^EmrLoc|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,NurRecId);
 //alert(Id)
 }
 else
 {
     var Id =cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^EmrLoc|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 //alert(Id)
   NurRecId=Id
 }
 //alert(Id);
 var flag9=1;
 if ((Id!="")&&((Id!=undefined)))
 {
 //alert("保存成功");
 //window.opener.find();
 //window.opener='';
 //window.close();
 //window.opener=null;
 
 //window.close();   
     	   Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '保存成功! 您要关闭该页面吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   				
	              if (self.parent)
				  {
					 self.parent.close();
					 //return;
				  }else{
					 self.close();  //关闭子窗口 
				  }				                       			
				  if (self.opener)
				  {
					 window.opener.find();
				  }	           	            
	            }
			    else
	            {   
			       setvalue()  	
				}	            
	        },    
	       animEl: 'newbutton'   
	       });
    
// alert(22)
}
else 
	{alert("保存失败")}

}

function getPatInfo()
{   //alert(EpisodeID);
	  //return ;
	   if(EpisodeID!=="")
	   {
	  var PatInfo=document.getElementById('PatInfo');
	  if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
		
	 	var tt=ret.split('^');
	 //	alert(tt);
	 	var patName = Ext.getCmp("Item1");
	 	patName.setValue(getValueByCode(tt[4]));
		patName.disable();
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
		sex.disable();
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	 var age = Ext.getCmp("Item5");
	 age.setValue(getValueByCode(tt[6]));
	 age.disable();
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.setValue(getValueByCode(tt[1]));
		patLoc.disable();
	 	//var bedCode = Ext.getCmp("Item2");
	 	//bedCode.setValue(getValueByCode(tt[5]));
	 var MedCareNo = Ext.getCmp("Item2");
	 	//alert(MedCareNo);
	 	MedCareNo.setValue(getValueByCode(tt[9]));
		MedCareNo.disable();
	 	var diag = Ext.getCmp("Item7");
	 	diag.setValue(getValueByCode(tt[8]));
		diag.disable();
	 	 var but=Ext.getCmp("EmrUser");
    but.setValue(session['LOGON.USERNAME'])
    but.disable()
    var but=Ext.getCmp("EmrDate");
    but.setValue(new Date)
    //but.disable()
    //totelmouth();
	 	//var admdate = Ext.getCmp("Item9");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admtime = Ext.getCmp("Item10");
	 	//admtime.setValue(getValueByCode(tt[11]));
	 	
	  }}
	  else 
	  {
	  var but=Ext.getCmp("EmrUser");
    but.setValue(session['LOGON.USERNAME'])
    but.disable()
    var but=Ext.getCmp("EmrDate");
    but.setValue(new Date)		
	  }
}
function getValueByCode(tempStr)
{
	var retStr=tempStr;
	var strArr = tempStr.split("|");
	if (strArr.length>1) 
	{
		retStr=strArr[1];
	}
	return retStr;
}
function butPrintFn(){
	butPGDPrintFnSB("DHCNURPRNXHSB_YC",EpisodeID,"DHCNURykdYWSH",NurRecId);
}

function butPrintFn22()
{    
      PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNXHSB_YC";
			var parr="@"+EpisodeID+"@DHCNURykdYWSH";
			PrintComm.MthArr="Nur.DHCNurSBData:getVal2&parr:"+NurRecId+"!";
			PrintComm.PrintOut();	
      }
function butPrintFnSB()
{   
        butPGDPrintFnSB("DHCNURPRNXHSB_YCSB",EpisodeID,"DHCNURykdYWSH",NurRecId);

            /* PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNXHSB_YCSB";
			PrintComm.MthArr="Nur.DHCNurSBData:getVal2&parr:"+NurRecId+"!";
			PrintComm.PrintOut(); */	
 }
function checkprn()
{ ret="";
  sum="";
  checkret="";
  comboret="";
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  var a1=checkret.split('^');
  var a2=ret.split('^');
  var a3=a2[0].split('|');
  //alert(a3);
  var arrayObj = new Array();
 for(i=0;i<a1.length-1;i++)
 {
  var a2=a1[i].split('_');
  var a7=a2[0];
  sum+=a7+"^";
  }
  sum=sum+"*"+a3;
  var checkprn=document.getElementById('checkprn');
  ret=cspRunServerMethod(checkprn.value,sum);
  //alert(ret);
  return ret;
}

