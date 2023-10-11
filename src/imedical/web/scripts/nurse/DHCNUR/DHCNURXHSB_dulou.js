var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();


//alert(usertype)
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
    {   var valu=item.getId()
  	    var Itemdx=0
  	  	if (valu.indexOf("_")!=-1)
  	  	{
  	  		Itemdx=valu.split("_")
  	  		//alert(Itemdx[0])
  	  	}
  	  
      if ((Itemdx[0]=="Item21")||(Itemdx[0]=="Item22")||((item.getId()=="Item23"))||(item.getId()=="Item25")||(item.getId()=="Item30")||(item.getId()=="Item31")||(item.getId()=="Item53")) 
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
			       // alert(item.getId())
              // alert(item.getRawValue())        
             } 
	          if (item.xtype=="checkbox") {   
             //修改下拉框的请求地址    
			      if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
             } 
       
      }
    }
    if (usertype=="科护士长")
    {  
    }
    if ((usertype=="护士长")||(usertype=="")||(session['LOGON.GROUPDESC']=="住院护士长"))  //病区护士长
    {   
    	 if (Status=="S2") //评价中
  	   { //可以修改 采取的改进措施（由科室护士长填写）：Item41科室效果评价（由科室护士长填写）：Item44
  	   	if (((item.getId()=="Item38")||(item.getId()=="Item45")))
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
  	  { var valu=item.getId()
  	    var Itemdx=0
  	  	if (valu.indexOf("_")!=-1)
  	  	{
  	  		Itemdx=valu.split("_")
  	  		//alert(Itemdx[0])
  	  	}
  	  	
  	  	//alert(valu)
  	    if (((Itemdx[0]=="Item21")||((Itemdx[0]=="Item22"))||((item.getId()=="Item23"))||(item.getId()=="Item25")||(item.getId()=="Item30")||(item.getId()=="Item31")||((item.getId()=="Item53"))))
  	    { 	    	
  	    	//alert(item.getId())
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
var UserItems2="^Item13^Item14^Item34^Item35^Item38^";
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
   //var but=Ext.getCmp("butprintSB");
  // but.on('click',butPrintFnSB);
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
	if (Status=="S1")  //已提交  但不是评价中 除护理部外保存按钮隐藏
	{
		 //var Item42=Ext.get("Item41");
		 //var Item44=Ext.fly("Item44");		
		//Item44.setStyle({	            
     //background: '#cccccc'
     //})
     // var Item44=Ext.get("Item25");		
		// Item44.setStyle({	            
    // background: '#cccccc'
    // })
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
	 if (usertype=="护理部")
	  {	
       var Item30=Ext.getCmp("Item30");	
	   if (Item30.getValue()=="") {Item30.setValue(new Date());}
       Item30.disable();	
       var Item31=Ext.getCmp("Item31");	
	   if (Item31.getValue()=="") {Item31.setValue(session['LOGON.USERNAME']);}
       Item31.disable()	;
    }
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
		  //var Item48=Ext.getCmp("Item48");
		  // var Item47=Ext.getCmp("Item47");
		 // Item47.disable()
		  //Item48.disable()
		  //Item48.setValue(session['LOGON.USERNAME'])
		//  Item47.setValue(diffDate(new Date(), 1))
		//  var butsave=Ext.getCmp("butsave");
		
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
		     Item42.setValue(diffDate(new Date(), 1))
		  }
		  var Item45=Ext.getCmp("Item45");
		  var Item51=Ext.getCmp("Item51");
		  Item45.disable()
		  Item51.disable()
		  if (Item44.getValue()=="")
		 { 		 
		  Item51.setValue(session['LOGON.USERNAME'])
		  Item45.setValue(diffDate(new Date(), 1))
		 }		
	}
	    var Item42=Ext.getCmp("Item32");
		  var EmrUser=Ext.getCmp("EmrUser");
		  Item42.disable()
		  EmrUser.disable()
		  var EmrDate=Ext.getCmp("EmrDate");
		  //EmrDate.disable()
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
  var Item216= Ext.getCmp("Item21_5");
  //alert(Item216.getValue())
  var Item224= Ext.getCmp("Item22_4");
  var Item25= Ext.getCmp("Item25");
  if ((Item224.getValue()==true)&&(Item25.getValue()==""))
  { 
  	alert("请填写护理风险分类其他")
  	return;
  }
  var SaveRec=document.getElementById('Save');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
 // alert(checkret);
 
// alert(ret+"&"+checkret+"&"+comboret)
 // var Item61=Ext.getCmp("Item61").value;
  /*
  if (Item61==""){
		Ext.Msg.alert('提示', "请选择‘意外事件发生日期’!");
		return;  
	            }
  var Item7=Ext.getCmp("Item7").value;
  if (Item7==""){
		Ext.Msg.alert('提示', "请选择‘发生地点’!");
		return;  
	            }
  var Item9=Ext.getCmp("Item9").value;
  if (Item9==""){
		Ext.Msg.alert('提示', "请选择‘患者意识状态(发生前)’!");
		return;  
	            }
  var Item11=Ext.getCmp("Item11").value;
  if (Item11==""){
		Ext.Msg.alert('提示', "请选择‘患者意识状态(发生后)’!");
		return;  
	            }
 */
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
	   /* var getlocdesc=document.getElementById('getlocdesc');
	  
	  if (getlocdesc) {
		var ret=cspRunServerMethod(getlocdesc.value,session['LOGON.CTLOCID']);
			var patLoc = Ext.getCmp("Item32");
	 	patLoc.setValue(ret);
	
	   } */
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
	 	var patLoc = Ext.getCmp("Item32");
	 	patLoc.setValue(getValueByCode(tt[1]));
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
	butPGDPrintFnSB("DHCNURPRNSB_Dulou",EpisodeID,"DHCNURykdYWSH",NurRecId);
}
function butPrintFn22()
{    
      PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNSB_Dulou";
			var parr="@"+EpisodeID+"@DHCNURykdYWSH";
			PrintComm.MthArr="Nur.DHCNurSBData:getVal2&parr:"+NurRecId+"!";
			PrintComm.PrintOut();	
      }
function butPrintFnSB()
{   
      PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNXHSB_YWSJSB";
			PrintComm.MthArr="Nur.DHCNurSBData:getVal2&parr:"+NurRecId+"!";
			PrintComm.PrintOut();	
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

