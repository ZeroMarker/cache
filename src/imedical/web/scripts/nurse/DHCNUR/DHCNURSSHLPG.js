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
function eachItem1(item,index,length) {   
    if (item.xtype=="datefield") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   
			
      
    } 
    if (item.xtype=="timefield") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="combo") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
		
      
    } 
	 if (item.xtype=="textfield") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="textarea") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
      
    } 
	 if (item.xtype=="checkbox") {   
            //ä¿??¹ä???æ¡???è¯·æ??°å??    
			//debugger;
			if (item.checked==true)
			{
				 checkret=checkret+item.id+"|"+item.boxLabel+"^"; 
				}
			else
				{
			
					checkret=checkret+item.id+"|^";
				}
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}   
var ITypItm=""; //?????°æ??å­??¸å??
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){
		butPGDPrintFn("DHCNURSSHLPGMouldPrn")
    });
    //butPrintFn
	//var GetQueryData=document.getElementById('GetQueryData'); 
	 //var cmb=Ext.getCmp("Item36");
	 //cmb.on('specialkey',cmbkey);
	//var Item2 = Ext.getCmp("Item2");
	
	//Item2.on('specialkey',cmbkey);
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue()
	//getPatInfo();
	for (var i=1;i<6;i++)
	{
		var obj=Ext.getCmp("Item"+i);
		if (obj) obj.disable()
	}
    var obj=Ext.getCmp("Item50");
    if (obj) obj.disable()
	
	//alert(SpId);
}


function setVal2(itm,val)
{
	    if (val=="") return ;
	   	var tt=val.split('!');
		alert(tt);
	 	var cm=Ext.getCmp(itm);
		person=new Array();
		addperson(tt[1],tt[0]);
		cm.store.loadData(person);
		cm.setValue(tt[0]);
		 
}



function btclose()
{
	window.close();
}

function cmbkey(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		alert(pp)
		getlistdata(pp,field);
	//	alert(ret);
		
	}
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
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}


function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function setvalue()
{
	//alert(ExamId);
   var ha = new Hashtable();
   var getid=document.getElementById('GetId');
  
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   // alert(id)
   if (id!="")
   {
   	 var getVal=document.getElementById('getVal');
	 var ret=cspRunServerMethod(getVal.value,id);
     var tm=ret.split('^')
	// alert(tm);
	 sethashvalue(ha,tm)

   }
 	 else {
 	 	getPatInfo();	
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
				setVal2(key ,ha.items(key));
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
function Save()
{
  ret="";
  checkret="";
  comboret="";
  var getid=document.getElementById("GetId");
  var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
  var SaveRec=document.getElementById('Save');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
 //ret+"&"+checkret+"&"+comboret;
 
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
  
  alert("成功!")
 //alert(NurRecId);
 
window.parent.reloadtree2(EmrCode,"评估");
}
function getPatInfo()
{
	var PatInfo=document.getElementById('PatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item3");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var MedCareNo = Ext.getCmp("Item5");
	 	MedCareNo.setValue(getValueByCode(tt[9]));
	 	var Age = Ext.getCmp("Item4");
	 	Age.setValue(getValueByCode(tt[6]));
		var AdmDiag=tkMakeServerCall("web.DHCNurMouldDataComm","getPatAdmDiag",EpisodeID);
	 	var diag = Ext.getCmp("Item9");
	 	diag.setValue(getValueByCode(tt[8]));
	    var RegNo = Ext.getCmp("Item50");
	 	RegNo.setValue(getValueByCode(tt[0]));
	 	
	}
}
function getValueByCode(tempStr)
{
	var retStr=tempStr;
	var strArr = tempStr.split("@");
	if (strArr.length>1) 
	{
		retStr=strArr[1];
	}
	return retStr;
}
function butPrintFn()
{
			PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			//PrintComm.RFootCaption="ç¬?";
			//PrintComm.LFootCaption="é¡?;
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB);
			PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURSSHLPGMouldPrn";
			//debugger;
			var parr="@"+EpisodeID+"@DHCNURSSHLPG";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
}
