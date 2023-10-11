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
	{}
  else
	{  	
    if ((usertype=="护理部")&&(session['LOGON.GROUPDESC']=="护理部"))  //护理部只允许修改 压疮性质：Item49;护理部追踪验证（由护理部填写）:Item53
    {
      if ((item.getId()=="Item49")||((item.getId()=="Item53"))) 
      { 
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
  	   	if (((item.getId()=="Item41")||((item.getId()=="Item42"))||((item.getId()=="Item43"))||(item.getId()=="Item44")||(item.getId()=="Item45")))
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
var UserItems2="^Item13^Item14^";
function cmbkey2(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var objitem=Ext.getCmp(field.id);
		var Userid=objitem.getValue();
		var username=tkMakeServerCall("web.DHCNurRecComm","getUserNameByCode",Userid);
		if(username!="") objitem.setValue(username);
	}
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
	var but=Ext.getCmp("butPrint2");
  but.on('click',butPrintFn);
   var but=Ext.getCmp("butprintSB");
   but.on('click',butPrintFnSB);
	var gform=Ext.getCmp("gform");
    //var but=Ext.getCmp("Item18");
   // but.disable()
    //alert(Usercode)	 
    	setvalue()
	var userarr=UserItems2.split('^');
	for(var kk=0;kk<userarr.length;kk++)
	{
		var usitem=userarr[kk];
		var userobj = Ext.getCmp(usitem);
		if(userobj) userobj.on('specialkey',cmbkey2);
	}
   var Item28_1= Ext.getCmp("Item19_1");
	 Item28_1.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item72");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_1.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	})
	 var Item28_2= Ext.getCmp("Item19_2");
	 Item28_2.on("check",function(check)
	 {			
			  var Item55= Ext.getCmp("Item73");
			    Item55.disable();
			  var dd=Item55.getValue()
			  var cc=Item28_2.getValue()		
			  //alert(cc)	 
			  if (cc==true)
			  {	 Item55.setValue("√")	}
			  else
			  {	 Item55.setValue("") }
	 })
	 var Item28_3= Ext.getCmp("Item19_3");
	 Item28_3.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item74");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_3.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	 var Item28_4= Ext.getCmp("Item19_4");
	 Item28_4.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item75");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_4.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	  var Item28_5= Ext.getCmp("Item19_5");
	 Item28_5.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item76");
			  Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_5.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	  var Item28_6= Ext.getCmp("Item19_6");
	 Item28_6.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item77");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_6.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	  var Item28_7= Ext.getCmp("Item19_7");
	 Item28_7.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item78");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_7.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	  var Item28_8= Ext.getCmp("Item19_8");
	 Item28_8.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item79");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_8.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	  var Item28_9= Ext.getCmp("Item19_9");
	 Item28_9.on("check",function(check)
	 {			
			  var Item54= Ext.getCmp("Item80");
			    Item54.disable();
			  var dd=Item54.getValue()
			  var cc=Item28_9.getValue()			 
			  if (cc==true)
			  {	 Item54.setValue("√")	}
			  else
			  {	 Item54.setValue("") }
	 })
	 var Item612= Ext.getCmp("Item61_2");
	  var Item617= Ext.getCmp("Item61_7");
	   var Item618= Ext.getCmp("Item61_8");
	 var Item622= Ext.getCmp("Item62");
	 var Item623= Ext.getCmp("Item63");
	 var Item624= Ext.getCmp("Item64");
	  Item612.on("check",function(check)
	  {			 		 	
	 		  var cc=Item612.getValue()			 
			   if (cc==true)
			  {	 
			  		Item622.setVisible(true);
			  }
			  else
			  {	 
			  		Item622.setVisible(false);
			  		for (var ii=1;ii<4;ii++)
			  		{
			  			var itm="Item62_"+ii;
			  			var itmm= Ext.getCmp(itm);
			  			itmm.setValue(false);
			  		}
			  }
	  }
	  )
	   Item617.on("check",function(check)
	  {			 		 	
	 		  var cc=Item617.getValue()			 
			   if (cc==true)
			  {	 
			  		Item623.setVisible(true);
			  }
			  else
			  {	 
			  		Item623.setVisible(false);
			  		Item623.setValue("")
			  }
	  }
	  )
	   Item618.on("check",function(check)
	  {			 		 	
	 		  var cc=Item618.getValue()			 
			   if (cc==true)
			  {	 
			  		Item624.setVisible(true);
			  }
			  else
			  {	 
			  		Item624.setVisible(false);
			  		Item624.setValue("")
			  }
	  }
	  )
    if (Item612.getValue()=="")
    {
	  Item622.setVisible(false);
	  }
	    if (Item617.getValue()=="")
    {
	  Item623.setVisible(false);
	  }
	    if (Item618.getValue()=="")
    {
	  Item624.setVisible(false);
	  }
	  

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
		  Item47.disable()
		  Item48.disable()
		  Item48.setValue(session['LOGON.USERNAME'])
		  Item47.setValue(diffDate(new Date(), 0))
		  var butsave=Ext.getCmp("butsave");
		
	}
	if ((usertype=="")&&(Status=="S2"))
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
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNurBraden&EpisodeID="+EpisodeID+"&Status="+Status //+"&NurRecId="+""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 
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
function  Linkycfjb()
{   
		var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURXHSB_YCFJB&EpisodeID="+""+"&NurRecId="+""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
	  //window.showModalDialog(lnk,,'');
	   
	   var dd=jj%2 
	   //alert(dd)
	   if (dd==0)
	   {
	   wind2=window.open(lnk,"html",'left=800,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=900');
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
		var lnk= "http://10.160.16.91/dhcmg/yct.jpg"  ;//"&DtId="+DtId+"&ExamId="+ExamId
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
	alert(str)
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function setvalue()
{ 
  // alert(NurRecId);

 if(NurRecId!="")
   {
   
   //alert(ExamId);
   var ha = new Hashtable();
  var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //EpisodeID_"^"_NurRecId;
   //alert(NurRecId);
   if (NurRecId != "") {
   //	alert(NurRecId);
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, NurRecId);
   	//alert(ret);
   	var tm = ret.split('^')
		sethashvalue(ha, tm);
			getPatInfo();	 
			}
			else {
				getPatInfo();	
				return;			
				}
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
 // alert(checkret);
  var Item125= Ext.getCmp("Item12_5")
  var Item18= Ext.getCmp("Item18");
  if ((Item125.getValue()==true)&&(Item18.getValue()==""))
  {
  	alert("请填写\"发生地点：其他\"")
  	return;
  }
  var Item256= Ext.getCmp("Item25_6")
  var Item26= Ext.getCmp("Item26");
  if ((Item256.getValue()==true)&&(Item26.getValue()==""))
  {
  	alert("请填写\"医嘱给药时间：其他\"")
  	return;
  }
   var Item274= Ext.getCmp("Item27_4")
  var Item28= Ext.getCmp("Item28");
  if ((Item274.getValue()==true)&&(Item28.getValue()==""))
  {
  	alert("请填写\"医嘱给药频次:其他\"")
  	return;
  }
   var Item365= Ext.getCmp("Item36_5")
  var Item37= Ext.getCmp("Item37");
  if ((Item365.getValue()==true)&&(Item37.getValue()==""))
  {
  	alert("请填写\"医嘱药名:其他:\"")
  	return;
  }
   var Item385= Ext.getCmp("Item38_5")
  var Item39= Ext.getCmp("Item39");
  if ((Item385.getValue()==true)&&(Item39.getValue()==""))
  {
  	alert("请填写\"医嘱药名:其他:\"")
  	return;
  }
  var Item666= Ext.getCmp("Item66_6")
  var Item71= Ext.getCmp("Item71");
  if ((Item666.getValue()==true)&&(Item71.getValue()==""))
  {
  	alert("请填写\"缺陷引起的后果:其他:\"")
  	return;
  }
  var Item199= Ext.getCmp("Item19_9")
  var Item67= Ext.getCmp("Item67");
  if ((Item199.getValue()==true)&&(Item67.getValue()==""))
  {
  	alert("请填写\"缺陷类型:其他:\"")
  	return;
  }
  var Item612= Ext.getCmp("Item61_2");
  var Item617= Ext.getCmp("Item61_7");
   var Item619= Ext.getCmp("Item61_9");
   var Item618= Ext.getCmp("Item61_8");
   var Item619= Ext.getCmp("Item61_9");
    var Item63= Ext.getCmp("Item63");
     var Item64= Ext.getCmp("Item64");
      var Item69= Ext.getCmp("Item69");
  var Item621= Ext.getCmp("Item62_1");
  var Item622= Ext.getCmp("Item62_2");
  var Item623= Ext.getCmp("Item62_3");
   if ((Item612.getValue()==true)&&(Item621.getValue()=="")&&(Item622.getValue()=="")&&(Item623.getValue()==""))
  { 
  	alert("请选择\"通知人员\"")
  	return;
  }
   if ((Item617.getValue()==true)&&(Item63.getValue()==""))
  {
  	alert("请填写\"用药(药物名称:\"")
  	return;
  }
  if ((Item618.getValue()==true)&&(Item64.getValue()==""))
  {
  	alert("请填写\"诊断性检查(具体名称:\"")
  	return;
  }
   if ((Item619.getValue()==true)&&(Item69.getValue()==""))
  {
  	alert("请填写\"处理：其他\"")
  	return;
  }
  var Item20=Ext.getCmp("Item20");
  var Item21=Ext.getCmp("Item21");
  var Item72=Ext.getCmp("Item72");
  if(Item72.getValue()=="√"){
	 if((Item20.getValue()=="")&&(Item21.getValue()=="")){
		 alert("请填写给药时间错误!");
		 return;
	 } 
  }
  var Item22=Ext.getCmp("Item22");
  var Item23=Ext.getCmp("Item23");
  var Item73=Ext.getCmp("Item73");
  if(Item73.getValue()=="√"){
	 if((Item22.getValue()=="")&&(Item23.getValue()=="")){
		 alert("请填写给药途径错误!");
		 return;
	 } 
  }
  var Item24=Ext.getCmp("Item24");
  var Item251=Ext.getCmp("Item25_1");
  var Item252=Ext.getCmp("Item25_2");
  var Item253=Ext.getCmp("Item25_3");
  var Item254=Ext.getCmp("Item25_4");
  var Item255=Ext.getCmp("Item25_5");
  var Item74=Ext.getCmp("Item74");
  if(Item74.getValue()=="√"){
	 if((Item24.getValue()=="")&&(Item251.getValue()=="")&&(Item252.getValue()=="")&&(Item253.getValue()=="")&&(Item254.getValue()=="")&&(Item255.getValue()=="")&&(Item256.getValue()=="")){
		 alert("请填写遗漏给药!");
		 return;
	 } 
  }
  var Item271=Ext.getCmp("Item27_1");
  var Item272=Ext.getCmp("Item27_2");
  var Item273=Ext.getCmp("Item27_3");
  var Item274=Ext.getCmp("Item27_4");
  var Item75=Ext.getCmp("Item75");
  if(Item75.getValue()=="√"){
	 if((Item271.getValue()=="")&&(Item272.getValue()=="")&&(Item273.getValue()=="")&&(Item274.getValue()=="")){
		 alert("请选择给药日期错误!");
		 return;
	 } 
  }
  var Item29=Ext.getCmp("Item29");
  var Item30=Ext.getCmp("Item30");
  var Item76=Ext.getCmp("Item76");
  if(Item76.getValue()=="√"){
	 if((Item29.getValue()=="")&&(Item30.getValue()=="")){
		 alert("请填写输液速度错误!");
		 return;
	 } 
  }
  var Item31=Ext.getCmp("Item31");
  var Item32=Ext.getCmp("Item32");
  var Item77=Ext.getCmp("Item77");
  if(Item77.getValue()=="√"){
	 if((Item31.getValue()=="")&&(Item32.getValue()=="")){
		 alert("请填写剂量错误!");
		 return;
	 } 
  }
  var Item33=Ext.getCmp("Item33");
  var Item34=Ext.getCmp("Item34");
  var Item78=Ext.getCmp("Item78");
  if(Item78.getValue()=="√"){
	 if((Item33.getValue()=="")&&(Item34.getValue()=="")){
		 alert("请填写剂型错误!");
		 return;
	 } 
  }
  var Item35=Ext.getCmp("Item35");
  var Item361=Ext.getCmp("Item36_1");
  var Item362=Ext.getCmp("Item36_2");
  var Item363=Ext.getCmp("Item36_3");
  var Item364=Ext.getCmp("Item36_4");
  var Item365=Ext.getCmp("Item36_5");
  var Item37=Ext.getCmp("Item37");
  var Item381=Ext.getCmp("Item38_1");
  var Item382=Ext.getCmp("Item38_2");
  var Item383=Ext.getCmp("Item38_3");
  var Item384=Ext.getCmp("Item38_4");
  var Item385=Ext.getCmp("Item38_5");
  var Item79=Ext.getCmp("Item79");
  if(Item79.getValue()=="√"){
	 if((Item35.getValue()=="")&&(Item361.getValue()=="")&&(Item362.getValue()=="")&&(Item363.getValue()=="")&&(Item364.getValue()=="")&&(Item365.getValue()=="")&&(Item37.getValue()=="")&&(Item381.getValue()=="")&&(Item382.getValue()=="")&&(Item383.getValue()=="")&&(Item384.getValue()=="")&&(Item385.getValue()=="")){
		 alert("请填写药物错误!");
		 return;
	 } 
  }
  var Item67=Ext.getCmp("Item67");
  var Item80=Ext.getCmp("Item80");
  if(Item80.getValue()=="√"){
	 if(Item67.getValue()==""){
		 alert("请填写缺陷类型其他!");
		 return;
	 } 
  }
 //alert(111)
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
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^EmrLoc|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
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
	            {   setvalue()  	}
	            
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
	butPGDPrintFnSB("DHCNURPRNXHSB_GEIYAO",EpisodeID,"DHCNURykdYWSH",NurRecId);
}
function butPrintFn22()
{    
      PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNXHSB_GEIYAO";
			var parr="@"+EpisodeID+"@DHCNURykdYWSH";
			PrintComm.MthArr="Nur.DHCNurSBData:getVal2&parr:"+NurRecId+"!";
			PrintComm.PrintOut();	
      }
function butPrintFnSB()
{   
      butPGDPrintFnSB("DHCNURPRNXHSB_GEIYAOSB",EpisodeID,"DHCNURykdYWSH",NurRecId);
      /* PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNXHSB_GEIYAOSB";
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

