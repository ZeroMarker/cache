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
       item.items.each(eachItem1, this);   
    }   
}   
var ITypItm="Item91"; //后取数据字典型
function BodyLoadHandler(){
	
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
	var but=Ext.getCmp("butPrint");
    but.on('click',butPrintFn);
	
	setvalue()
	getPatInfo()
	
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


function btclose()
{
	window.close();
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
function Save()
{
	ret="";
	checkret="";
	comboret="";
	var SaveRec=document.getElementById('Save');
	var gform=Ext.getCmp("gform");
	gform.items.each(eachItem1, this);  
	//alert(EmrCode)
	ret+"&"+checkret+"&"+comboret;
	//alert(checkret);
	//alert(ret);
	//alert(SaveRec.value);
	var getid = document.getElementById('GetId');
	var Id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);
	Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,Id);
	alert("已保存");
	checkret="";
	comboret="";
	//alert(NurRecId);
	//setvalue();
	window.parent.reloadtree2(EmrCode,"评估");

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
		patName.disable();
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
		sex.disable();
	 	var  regno= Ext.getCmp("Item7");
		regno.setValue(getValueByCode(tt[0]));
		regno.disable();
	 	var age = Ext.getCmp("Item5");
	 	age.setValue(getValueByCode(tt[6]));
		age.disable();
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[1]));
		patLoc.disable();
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5]));
		bedCode.disable();
	 	var diag = Ext.getCmp("Item9");
	 	diag.setValue(getValueByCode(tt[8]));
		diag.disable();
		var MedCareNo = Ext.getCmp("Item6");
	 	MedCareNo.setValue(getValueByCode(tt[9]));
		MedCareNo.disable();
	 
	 	
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
	//alert(11)
	PrintComm.RHeadCaption='dddd';
	PrintComm.LHeadCaption="3333333";
	PrintComm.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
	//PrintComm.RFootCaption="第";
	//PrintComm.LFootCaption="页";
	//PrintComm.LFootCaption="88";
	//alert(PrintComm.Pages);
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.ItmName = "DHCNURMouldPrn_XZJRSSHZJJZYDDY";
	//debugger;
	//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
	var parr="@"+EpisodeID+"@DHCNURPGD_XZJRSSHZZYJJD";
	PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
	//alert(11)
	//PrintComm.LabHead=LabHead;			
	//PrintComm.SetParrm(parr);
	PrintComm.PrintOut();
}
