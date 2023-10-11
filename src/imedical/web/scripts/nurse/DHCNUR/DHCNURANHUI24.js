var ret="";
var checkret="";
var comboret=""; 
var radioret="";
var arrgrid=new Array();

var ITypItm="Item41"; //后取数据字典型

var ha = new Hashtable();

function GDscoregroup (obj)
{
 	sum=0; 
 	var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1,this); 
  //alert(checkret);
  var a1=checkret.split('^');
  var arrayobj=new Array();
  sum=0;
  
  for(i=0;i<a1.length-1;i++)
  {
   var a2=a1[i].split('|');
   var a3=a2[1]; 
   var a7=0;
   // alert(a3);   
   if (a3.indexOf("分")!="-1")
   {
     var a4=a3.split('(');
     var a5=a4[1];
     var a6=a5.split('分');
     a7=parseInt(a6[0]);   
   } 
   //alert(a7);   
   sum=sum+a7; 
  } 
  var Item19value=Ext.getCmp("Item19").getValue(); 
  //alert(sum);  
  if (Item19value!="")
  {
    sum=sum+parseInt(scoreFormat2(Item19value)); 
  } 
  //alert(sum);
  var sumscore = Ext.getCmp("Item20"); 
	sumscore.setValue(sum);  
	checkret=""  
} 

function scoreFormat2(value)
{
 var scorearry1=new Array(); 
 scorearry1=value.split("(");
 value= scorearry1[1];   	
 scorearry1=value.split("分");
 return value;
}



function ifflag(itm)
{
	var tm=ITypItm.split('|');
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



function eachItem1(item,index,length) {      
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";         
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      
    }  
     
   
   if (item.xtype=="radio") {  
   	    if (item.getValue()==true) radioret=radioret+item.id+"|"+item.boxLabel+"^";   
        else {radioret=radioret+item.id+"|"+""+"^";}
   	    //alert(radioret);
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
      else {checkret=checkret+item.id+"|"+""+"^";}
      item.on('check',GDscoregroup,this);  
    }  
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }  
} 


function Save()
{
   ret="";
  checkret="";
  comboret="";
  radioret="";
  var getid=document.getElementById("GetId");
   //alert(getid);
  // var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);
  var SaveRec=document.getElementById("Save");
  var gform=Ext.getCmp("gform");
   gform.items.each(eachItem1, this);  
  //alert(EmrCode)
  ret+"&"+checkret+"&"+comboret;
  //alert(ret+"&"+checkret+"&"+comboret)
 //alert(checkret);
 // alert(ret);
  //alert(comboret);
  //alert(NurRecId)
  //alert(radioret)
  if (NurRecId!=""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,NurRecId);
 }
else
	{var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,"");
 
		}
   //alert(Id)
		if (Id!=="")
		{
//alert("已保存");
}
else {alert("保存失败");
	}
 //setvalue();
 //alert(NurRecId);
window.opener.FindSPLIST();
window.close();

}


function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
}

function cmbkey(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata(pp,field);
	//	alert(ret);
		
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

var person=new Array();
function getlistdata(p,cmb)
{
	var GetPerson =document.getElementById('GetPerson');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,p);
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

function butPrintFn()
{	        
	printNurRec();	        
	return;			
} 

function printNurRec(){		
	//alert("dj");
	var GetPrnSet=document.getElementById('GetPrnSet');		
	var GetHead=document.getElementById('GetPatInfo');		
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);		
	var hh=ret.split("^");			
	var getid=document.getElementById('GetId');        
	var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);		
	//debugger;		
	var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI24",EpisodeID); 
	//page, caredattim, prnpos, adm,Typ,user		
	//alert(a);
	//if (a=="") return;		
	var GetLableRec=document.getElementById('GetLableRec');		
	var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI24^"+session['LOGON.CTLOCID']);		
	var tm=a.split("^");		
	var stdate="" 
	//tm[2];		
	var stim="" 
	//tm[3];		
	var edate="" 
	//tm[4];		
	var etim="" 
	//tm[5];		
	//PrintComm.RHeadCaption=hh[1];		
	//PrintComm.LHeadCaption=hh[0];		
	//PrintComm.RFootCaption="第";		
	//PrintComm.LFootCaption="页";		
	//PrintComm.LFootCaption=hh[2];		
	PrintComm.TitleStr=ret;		
	PrintComm.SetPreView("1");		
	PrintComm.PrnLoc=session['LOGON.CTLOCID'];		
	//var aa=tm[1].split("&");		
	//PrintComm.stPage=aa[0];		
	//if (aa.length>1) 
	//PrintComm.stRow=aa[1];		
	PrintComm.stPage=0;		
	PrintComm.stRow=0;		
	PrintComm.previewPrint="1"; 
	//是否弹出设置界面		
	//PrintComm.stprintpos=tm[0];		
	PrintComm.stprintpos=0;		
	//alert(PrintComm.Pages);		
	PrintComm.SetConnectStr(CacheDB);
	//alert(webIP);
	PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
	//PrintComm.WebUrl=WebIp+"/trakcarelive/trak/web/DWR.DoctorRound.cls";		
	PrintComm.ItmName = "DHCNurPrnMouldANHUI25"; 
	//338155!2010-07-13!0:00!!		
	//debugger;		
	var parr=EpisodeID;		
	PrintComm.ID = "";		
	PrintComm.MultID = "";		
	var mth1="Nur.DHCMoudData:getVal&parr:"+id+"!";		
	PrintComm.MthArr=mth1;		
	//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;		
	if(LabHead!="")PrintComm.LabHead=LabHead;		
	PrintComm.SetParrm(parr); 
	// ="EpisodeId" ; 
	//"p1:0^p2:"		
	PrintComm.PrintOut();		
	var SavePrnSet=document.getElementById('SavePrnSet');		
	//debugger;		
	var CareDateTim=PrintComm.CareDateTim;		
	if (CareDateTim=="") return ;		
	var pages=PrintComm.pages;   		
	var stRow=PrintComm.stRow;		
	//debugger;		
	var stprintpos=PrintComm.stPrintPos;		
	//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNURANHUI15"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);		
	//PrnFlag==1说明是打印预览		
	if (PrintComm.PrnFlag==1) return;		
	//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录		
	if (pages<aa[0]) return;		
	//var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNURANHUI15",session['LOGON.USERID']);
	//page, caredattim, prnpos, adm,Typ,user		
	//find();
} 

function scoreAdd3(obj)
{ 
  var gform = Ext.getCmp("gform");
  gform.items.each(eachItem1,this);
  var a1=checkret.split('^');
  var arrayobj=new Array();
  sum=0;
  for(i=0;i<a1.length-1;i++)
  {
   var a2=a1[i].split('|');
   var a3=a2[1]; 
   var a7=0;
   if (a3.indexOf("分")!="-1")
   {
     var a4=a3.split('(');
     var a5=a4[1];
     var a6=a5.split('分');
     a7=parseInt(a6[0]);   
   } 
   sum=sum+a7; 
  } 
  var Item19value=Ext.getCmp("Item19").getValue(); 
  if (Item19value!="")
  {
    sum=sum+parseInt(scoreFormat2(Item19value)); 
  }
	var sumscore = Ext.getCmp("Item20"); 
	sumscore.setValue(sum);
	checkret="" 
}


function BodyLoadHandler(){
	
	var but=Ext.getCmp("butSave");
  but.on('click',Save);
  
  var but=Ext.getCmp("butPrint");
  but.on('click',function(){butPGDPrintFn("DHCNurPrnMouldANHUI25")});
  
  var Item41 = Ext.getCmp("Item41");
	Item41.on('specialkey',cmbkey); 
	
	 var Item15=Ext.getCmp("Item15"); 
   Item15.items.each(eachItem1,this);
   var Item16=Ext.getCmp("Item16"); 
   Item16.items.each(eachItem1,this); 
   var Item17=Ext.getCmp("Item17"); 
   Item17.items.each(eachItem1,this);  
    
   var score1 = Ext.getCmp("Item19"); 
	 score1.on('change',scoreAdd3,this);  

 

	
	scoregroup("Item6",4);
	scoregroup("Item7",4);
	scoregroup("Item8",4);
	scoregroup("Item9",4);
	scoregroup("Item10",4);
	scoregroup("Item11",4);
	scoregroup("Item21",4);
	scoregroup("Item22",4);
	scoregroup("Item23",4);
	scoregroup("Item24",4);
	
	scoregroup2("Item25",4);
	scoregroup2("Item26",4);
	scoregroup2("Item27",4);
	scoregroup2("Item28",4);
	scoregroup2("Item29",4);
	scoregroup2("Item30",4);
	
	scoregroup3("Item32",4);
	scoregroup3("Item33",4);
	scoregroup3("Item34",3);
	scoregroup3("Item35",6);
	scoregroup3("Item36",4);
	scoregroup3("Item37",7);
	scoregroup3("Item38",3);
	scoregroup3("Item39",3);

	setvalue();

}

function GetScoreGroup(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 //alert(Itemstr+"_"+count);
	 var scoreobj = Ext.getCmp(Itemstr+"_"+count);
	 var scoreflag=scoreobj.getValue();
	if (scoreflag==true)
	{
	  var scoreid=scoreobj.getId();  
	  var scorefen=scoreobj.boxLabel;
	  ha.add(Itemstr,scoreFormat(scorefen));
	  //Itemstr+"Value"=scoreFormat(scorefen);
	}
  }
}

function GetItemHashScore()
{  
    GetScoreGroup("Item6",4);
	GetScoreGroup("Item7",4);
	GetScoreGroup("Item8",4);
	GetScoreGroup("Item9",4);
	GetScoreGroup("Item10",4);
	GetScoreGroup("Item11",4);
	GetScoreGroup("Item21",4);
	GetScoreGroup("Item22",4);
	GetScoreGroup("Item23",4);
	GetScoreGroup("Item24",4);
	  
  GetScoreGroup("Item25",4);
	GetScoreGroup("Item26",4);
	GetScoreGroup("Item27",4);
	GetScoreGroup("Item28",4);
	GetScoreGroup("Item29",4);
	GetScoreGroup("Item30",4);
  
    GetScoreGroup("Item32",3);
	GetScoreGroup("Item33",3);
	GetScoreGroup("Item34",2);
	GetScoreGroup("Item35",4);
	GetScoreGroup("Item36",3);
	GetScoreGroup("Item37",6);
	GetScoreGroup("Item38",2);
	GetScoreGroup("Item39",2);
}


function scoreDDAdd(obj)
{
	var flag=obj.getValue();
	var HJScore = Ext.getCmp("Item14");
    //alert(flag)
	GetItemHashScore();
	if (flag==true)
	{
	 var scoreid=obj.getId();  
	 var scorefen=obj.boxLabel;  
	
	if (scoreid.indexOf("Item32")!="-1")
	{
		 //alert(scoreFormat(scorefen));
		  //Item32Value=scoreFormat(scorefen);
		  ha.remove("Item32");
		  ha.add("Item32",scoreFormat(scorefen));
		  //ha["Item32"]=scoreFormat(scorefen);
		  //ha.set("Item32","");
		  //debugger
		  //alert(ha.items("Item32"));
		  //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item33")!="-1")
	{
		//Item33Value=scoreFormat(scorefen);
		 ha.remove("Item33");
		 ha.add("Item33",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item34")!="-1")
	{
		//Item34Value=scoreFormat(scorefen);
		 ha.remove("Item34");
		 ha.add("Item34",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item35")!="-1")
	{
		//Item35Value=scoreFormat(scorefen);
		 ha.remove("Item35");
		 ha.add("Item35",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item36")!="-1")
	{
		//Item36Value=scoreFormat(scorefen);
		 ha.remove("Item36");
		 ha.add("Item36",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item37")!="-1")
	{
		//Item37Value=scoreFormat(scorefen);
		ha.remove("Item37");
		ha.add("Item37",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item38")!="-1")
	{
		//Item38Value=scoreFormat(scorefen);
		ha.remove("Item38");
		ha.add("Item38",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}
	if (scoreid.indexOf("Item39")!="-1")
	{
		//Item39Value=scoreFormat(scorefen);
		ha.remove("Item39");
		ha.add("Item39",scoreFormat(scorefen));
		 //HJScore.setValue(parseInt(Item32Value)+parseInt(Item33Value)+parseInt(Item34Value)+parseInt(Item35Value)+parseInt(Item36Value)+parseInt(Item37Value)+parseInt(Item38Value)+parseInt(Item39Value));
	}	
	    var val32=ha.items("Item32")
		if (isNaN(val32))
		{
			val32=0
		}
		var val33=ha.items("Item33")
			if (isNaN(val33))
		{
			val33=0
		}
		var val34=ha.items("Item34")
			if (isNaN(val34))
		{
			val34=0
		}
		var val35=ha.items("Item35")
			if (isNaN(val35))
		{
			val35=0
		}
		var val36=ha.items("Item36")
			if (isNaN(val36))
		{
			val36=0
		}
		var val37=ha.items("Item37")
			if (isNaN(val37))
		{
			val37=0
		}
		var val38=ha.items("Item38")
			if (isNaN(val38))
		{
			val38=0
		}
		var val39=ha.items("Item39")
			if (isNaN(val39))
		{
			val39=0
		}
		//alert(val32+val33+val34+val35+val36+val37+val38+val39)

	   HJScore.setValue(parseInt(val32)+parseInt(val33)+parseInt(val34)+parseInt(val35)+parseInt(val36)+parseInt(val37)+parseInt(val38)+parseInt(val39)); 
   checkret ="";
  }

}

function scoregroup3(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 //alert(Itemstr+"_"+count);
	   var score1 = Ext.getCmp(Itemstr+"_"+count);
       score1.on('check',scoreDDAdd,this);
  }
}

function scoreBardenAdd(obj)
{
	GetItemHashScore();
	var flag=obj.getValue();
	//alert(flag);
	if (flag==true)
	{
	 var scoreid=obj.getId();  
	 var scorefen=obj.boxLabel;  
	 //alert(scorefen);  
	
	if (scoreid.indexOf("Item25")!="-1")
	{
		 ha.remove("Item25");
		 ha.add("Item25",scoreFormat(scorefen));
		 //Item25Value=scoreFormat(scorefen);
	}
	if (scoreid.indexOf("Item26")!="-1")
	{
		ha.remove("Item26");
		ha.add("Item26",scoreFormat(scorefen));
		//Item26Value=scoreFormat(scorefen);
	}
	if (scoreid.indexOf("Item27")!="-1")
	{
		ha.remove("Item27");
		ha.add("Item27",scoreFormat(scorefen));
		//Item27Value=scoreFormat(scorefen);
	}
	if (scoreid.indexOf("Item28")!="-1")
	{
		ha.remove("Item28");
		ha.add("Item28",scoreFormat(scorefen));
		//Item28Value=scoreFormat(scorefen);
	}
	if (scoreid.indexOf("Item29")!="-1")
	{
		ha.remove("Item29");
		ha.add("Item29",scoreFormat(scorefen));
		//Item29Value=scoreFormat(scorefen);
	}
	if (scoreid.indexOf("Item30")!="-1")
	{
		ha.remove("Item30");
		ha.add("Item30",scoreFormat(scorefen));
		//Item30Value=scoreFormat(scorefen);
	}
	
  }
  var HJScore = Ext.getCmp("Item13");
  
  var i1=parseInt(ha.items("Item25"))
  if((ha.items("Item25")=="")||(ha.items("Item25")==undefined)) i1=0;
  
  var i2=parseInt(ha.items("Item26"))
  if((ha.items("Item26")=="")||(ha.items("Item26")==undefined)) i2=0;
  
  var i3=parseInt(ha.items("Item27"))
  if((ha.items("Item27")=="")||(ha.items("Item27")==undefined)) i3=0;
  var i4=parseInt(ha.items("Item28"))
  if((ha.items("Item28")=="")||(ha.items("Item28")==undefined)) i4=0;
  var i5=parseInt(ha.items("Item29"))
  if((ha.items("Item29")=="")||(ha.items("Item29")==undefined)) i5=0;
  var i6=parseInt(ha.items("Item30"))
  if((ha.items("Item30")=="")||(ha.items("Item30")==undefined)) i6=0;
  
 
  var sums=i1+i2+i3+i4+i5+i6;
  
  HJScore.setValue(sums); 
   checkret ="";
}

function scoregroup2(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 //alert(Itemstr+"_"+count);
	 var score1 = Ext.getCmp(Itemstr+"_"+count);
   score1.on('check',scoreBardenAdd,this);
  }
}

function scoregroup(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 //alert(Itemstr+"_"+count);
	 var score1 = Ext.getCmp(Itemstr+"_"+count);
   score1.on('check',scoreADLAdd,this);
  }
}


function scoreADLAdd(obj)
{
	GetItemHashScore();
	var flag=obj.getValue();
	//alert(flag);
	if (flag==true)
	{
	 var scoreid=obj.getId();  
	 var scorefen=obj.boxLabel;  
	 //alert(scorefen);  
	
	if (scoreid.indexOf("Item6")!="-1")
	{
		 ha.remove("Item6");
		 ha.add("Item6",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item7")!="-1")
	{
		 ha.remove("Item7");
		 ha.add("Item7",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item8")!="-1")
	{
		 ha.remove("Item8");
		 ha.add("Item8",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item9")!="-1")
	{
		 ha.remove("Item9");
		 ha.add("Item9",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item10")!="-1")
	{
		 ha.remove("Item10");
		 ha.add("Item10",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item11")!="-1")
	{
		 ha.remove("Item11");
		 ha.add("Item11",scoreFormat(scorefen));
	}
	if (scoreid.indexOf("Item21")!="-1")
	{
		 ha.remove("Item21");
		 ha.add("Item21",scoreFormat(scorefen));
	}
  if (scoreid.indexOf("Item22")!="-1")
	{
		 ha.remove("Item22");
		 ha.add("Item22",scoreFormat(scorefen));
	}//alert(scorefen);
  if (scoreid.indexOf("Item23")!="-1")
	{
		 ha.remove("Item23");
		 ha.add("Item23",scoreFormat(scorefen));
	}//alert(scorefen);
	if (scoreid.indexOf("Item24")!="-1")
	{
		 ha.remove("Item24");
		 ha.add("Item24",scoreFormat(scorefen));
	}
  }
  var HJScore = Ext.getCmp("Item12");
  
  var i1=parseInt(ha.items("Item6"))
  if((ha.items("Item6")=="")||(ha.items("Item6")==undefined)) i1=0;
  
  var i2=parseInt(ha.items("Item7"))
  if((ha.items("Item7")=="")||(ha.items("Item7")==undefined)) i2=0;
  
  var i3=parseInt(ha.items("Item8"))
  if((ha.items("Item8")=="")||(ha.items("Item8")==undefined)) i3=0;
  var i4=parseInt(ha.items("Item9"))
  if((ha.items("Item9")=="")||(ha.items("Item9")==undefined)) i4=0;
  var i5=parseInt(ha.items("Item10"))
  if((ha.items("Item10")=="")||(ha.items("Item10")==undefined)) i5=0;
  var i6=parseInt(ha.items("Item11"))
  if((ha.items("Item11")=="")||(ha.items("Item11")==undefined)) i6=0;
  var i7=parseInt(ha.items("Item21"))
  if((ha.items("Item21")=="")||(ha.items("Item21")==undefined)) i7=0;
  var i8=parseInt(ha.items("Item22"))
  if((ha.items("Item22")=="")||(ha.items("Item22")==undefined)) i8=0;
  var i9=parseInt(ha.items("Item23"))
  if((ha.items("Item23")=="")||(ha.items("Item23")==undefined)) i9=0;
  var i10=parseInt(ha.items("Item24"))
  if((ha.items("Item24")=="")||(ha.items("Item24")==undefined)) i10=0;
 
  var sums=i1+i2+i3+i4+i5+i6+i7+i8+i9+i10;
  HJScore.setValue(sums); 
   checkret ="";
}

function scoreFormat(value)
{
	//alert(value);
	if(value=="") value=0;	
	if (value.indexOf("(")!="-1")
  {
  	var scorearry=new Array();
  	scorearry=value.split("(");
  	value=scorearry[1];  
  	//alert(value);
  	scorearry=value.split("分");
    value=scorearry[0]; 
  }
  if(value=="") value=0;
  return value;
}

function setvalue()
{
	//alert(ExamId);
   var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);
   id=NurRecId; 
   if (id != "") {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, id);
   	var tm = ret.split('^')
    //alert(tm);
		sethashvalue(ha, tm);
				
			}
			else {
				getPatInfo();
				return;
				//var PatInfo = document.getElementById('PatInfo');
				//if (PatInfo) {
				//alert(12);
					//var ret = cspRunServerMethod(PatInfo.value, EpisodeID, EmrCode);
					//var tm = ret.split('^')
					//sethashvalue(ha, tm)
				}
			
	// debugger;
    	
  
   
	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItem, this);  
	 //  alert(a);
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) 
		{
			//alert(key);
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));
				//debugger;
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

function getPatInfo()
{
	//return ;
	var PatInfo=document.getElementById('PatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
		//alert(ret);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item1");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item5");
	 	regno.setValue(getValueByCode(tt[9]));
	 	//var age = Ext.getCmp("Item3");
	 	//age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item2");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item3");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	//var diag = Ext.getCmp("Item18");
	 	//diag.setValue(getValueByCode(tt[8]));
	 	//var admdate = Ext.getCmp("Item13");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admtime = Ext.getCmp("Item14");
	 	//admtime.setValue(getValueByCode(tt[11]));
		//alert("dd");
	 	//var MedCareNo = Ext.getCmp("Item411");
	 	//MedCareNo.setValue(getValueByCode(tt[9])); 
	  var myDate=new Date();
	 	var Month=myDate.getMonth()+1;
	 	var MDate=myDate.getDate();
	 	if ((((myDate.getDate()).toString()).length)==1)  
	 	{
	 		var MDate="0"+(myDate.getDate()).toString();
	 	}
	 	if ((((myDate.getMonth()+1).toString()).length)==1)  
	 	{
	 		var Month="0"+(myDate.getMonth()+1).toString();
	 	}
	 	var nowDate=myDate.getYear()+"-"+Month+"-"+MDate; 
    var ReportDate = Ext.getCmp("Item40");  
	 	ReportDate.setValue(nowDate);
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

