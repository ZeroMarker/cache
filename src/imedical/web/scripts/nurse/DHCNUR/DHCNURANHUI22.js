var ret="";
var checkret="";
var comboret=""; 
var radioret="";
var arrgrid=new Array();



var ITypItm="Item23"; //后取数据字典型
	var Item13Value=0;
	var Item14Value=0;
	var Item15Value=0;
	var Item16Value=0;
	var Item17Value=0;
	var Item18Value=0;
	var Item19Value=0;

function eachItem1(item,index,length) {   
     if (item.xtype=="checkbox") {   
            //多选    
			//debugger;
			if (item.checked==true) 	{checkret=checkret+item.id+"|"+item.boxLabel+"^";}
			else {checkret=checkret+item.id+"|"+""+"^";}
		   
      
    }      
    if (item.xtype=="datefield") {   
            //日期    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";         
    } 
    if (item.xtype=="timefield") {   
            //时间    
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
        //else {radioret=radioret+item.id+"|"+""+"^";}
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
	
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
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

function Save()
{
 
  ret="";
  checkret="";
  comboret=""; 
  radioret="";

  var SaveRec=document.getElementById('Save'); 
  var getid=document.getElementById("GetId"); 
  var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
  //id=DHCMoudDataRowId;  
  //alert(id)
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
 //ret+"&"+checkret+"&"+comboret+"&"+radioret;
 // alert(checkret);
if (id==""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,"");
 alert("已保存!");
 return;
}
else
{
  //alert(radioret); 
  var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,id);
  if (Id!=="")
		{
        alert("已保存!");
        return;
    }
    else 
    {
        alert("保存失败!");
        return;
	  }  
 }
 
 //alert(NurRecId);

}

function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
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
  
function butPrintFn()
{	        
			PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB); 
			PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNurPrnMouldANHUI23";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURANHUI22";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
	
	//alert("11");
	//printNurRec();	        
	//return;			
} 


function printNurRec(){		
	var GetPrnSet=document.getElementById('GetPrnSet');		
	var GetHead=document.getElementById('GetPatInfo');		
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);		
	//alert(ret);
	var hh=ret.split("^");			
	var getid=document.getElementById('GetId');        
	var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);		
	//alert(id);
	//debugger;		
	var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI22",EpisodeID); 
	//page, caredattim, prnpos, adm,Typ,user		
	//alert(a);
	//if (a=="") return;		
	var GetLableRec=document.getElementById('GetLableRec');		
	var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI22^"+session['LOGON.CTLOCID']);		
	var tm=a.split("^");
	alert(tm);		
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
	var aa=tm[1].split("&");		
	//PrintComm.stPage=aa[0];		
	//if (aa.length>1) 
	PrintComm.stRow=aa[1];		
	PrintComm.stPage=0;		
	PrintComm.stRow=0;		
	PrintComm.previewPrint="1"; 
	//是否弹出设置界面		
	//PrintComm.stprintpos=tm[0];		
	PrintComm.stprintpos=0;		
	//alert(PrintComm.Pages);		
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.WebUrl=webIP+"/trakcare/web/DWR.DoctorRound.cls";
	//PrintComm.WebUrl=WebIp+"/trakcarelive/trak/web/DWR.DoctorRound.cls";		
	PrintComm.ItmName = "DHCNurPrnMouldANHUI23"; 
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


function BodyLoadHandler(){
	
	var but=Ext.getCmp("butSave");
  but.on('click',Save); 
   
  var but=Ext.getCmp("butPrint");
  but.on('click',function(){butPGDPrintFn("DHCNurPrnMouldANHUI23")});

	
	var Item2 = Ext.getCmp("Item23");
	Item2.on('specialkey',cmbkey);
  
  var score1 = Ext.getCmp("Item13_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item13_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item13_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item13_4");
  score1.on('check',scoreAdd,this);
  
  var score1 = Ext.getCmp("Item14_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item14_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item14_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item14_4");
  score1.on('check',scoreAdd,this); 
  
  var score1 = Ext.getCmp("Item15_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item15_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item15_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item15_4");
  score1.on('check',scoreAdd,this); 
  
  
  var score1 = Ext.getCmp("Item16_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item16_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item16_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item16_4");
  score1.on('check',scoreAdd,this); 
  
  var score1 = Ext.getCmp("Item17_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item17_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item17_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item17_4");
  score1.on('check',scoreAdd,this); 
  
  var score1 = Ext.getCmp("Item18_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item18_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item18_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item18_4");
  score1.on('check',scoreAdd,this); 
  
  var score1 = Ext.getCmp("Item19_1");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item19_2");
  score1.on('check',scoreAdd,this); 
  var score1 = Ext.getCmp("Item19_3");
  score1.on('check',scoreAdd,this);
  var score1 = Ext.getCmp("Item19_4");
  score1.on('check',scoreAdd,this);
	SetPatInfoDisable();
	setvalue();
}
function SetPatInfoDisable()
{
		var patName = Ext.getCmp("Item3");
	 	patName.disable();
	 	var sex = Ext.getCmp("Item5");
	 	sex.disable();
	 	var  regno= Ext.getCmp("Item6");
	 	regno.disable();
	 	var age = Ext.getCmp("Item4");
	 	age.disable();
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.disable();
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.disable();
	 	var admdate = Ext.getCmp("Item7");
	 	admdate.disable();
	 	var admtime = Ext.getCmp("Item8");
	 	admtime.disable();
}
function scoreFormat(value)
{
	if (value.indexOf("_")!="-1")
  {
  	var scorearry=new Array();
  	scorearry=value.split("_");
  	value=scorearry[1]; 
  }
  return value;
}

function scoreAdd(obj)
{
	var flag=obj.getValue();
	if (flag==true)
	{
	var scorefen=obj.getId();  
	
	if (scorefen.indexOf("Item13")!="-1")
	{
		 Item13Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item14")!="-1")
	{
		Item14Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item15")!="-1")
	{
		Item15Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item16")!="-1")
	{
		Item16Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item17")!="-1")
	{
		Item17Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item18")!="-1")
	{
		Item18Value=scoreFormat(scorefen);
	}
	if (scorefen.indexOf("Item19")!="-1")
	{
		Item19Value=scoreFormat(scorefen);
	}
	//alert(scorefen);
  }
  var HJScore = Ext.getCmp("Item20");
  
  HJScore.setValue(parseInt(Item13Value)+parseInt(Item14Value)+parseInt(Item15Value)+parseInt(Item16Value)+parseInt(Item17Value)+parseInt(Item18Value)+parseInt(Item19Value));
}

function setvalue()
{
   //alert("cc");   
   var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);

   //id=DHCMoudDataRowId; 
   //alert(id);   
   if (id != "") {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, id);
   	var tm = ret.split('^')
   // alert(tm);
		sethashvalue(ha, tm);
				
			}
			else {
				getPatInfo();
				return;
		
				}
			
	// debugger;
    	
  
 
	 var gform=Ext.getCmp("gform");
   gform.items.each(eachItem, this);  
	 //  alert(a);
	 //alert(ht.keys())
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		//alert(key)
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
			
	  }
	    else
	    {
			var aa=key.split('_');
			//alert(aa)
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
	 	var patName = Ext.getCmp("Item3");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item5");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item6");
	 	regno.setValue(getValueByCode(tt[9]));
	 	var age = Ext.getCmp("Item4");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[7]));
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var diag = Ext.getCmp("Item11");
	 	diag.setValue(getValueByCode(tt[8]));
	 	var admdate = Ext.getCmp("Item7");
	 	admdate.setValue(getValueByCode(tt[14]));
	 	var admtime = Ext.getCmp("Item8");
	 	admtime.setValue(getValueByCode(tt[15]));
		
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
    var ReportDate = Ext.getCmp("Item24");  
	 	ReportDate.setValue(nowDate);
	 	var TBDate = Ext.getCmp("Item9");
	 	TBDate.setValue(new Date());  //填报日期
	 	var TBTime = Ext.getCmp("Item10");
	 	var hh=myDate.getHours();
	 	var mm=myDate.getMinutes();
	 	var Time=hh+":"+mm;
	 	TBTime.setValue(Time);

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
