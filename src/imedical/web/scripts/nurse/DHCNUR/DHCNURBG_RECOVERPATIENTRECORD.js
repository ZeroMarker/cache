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
		//alert(ret);
		sethashvalue(ha, tm);
		//alert(123)		
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
		//alert(ret)
	 	var tt=ret.split('^');

	    var bedCode = Ext.getCmp("Item5");
		bedCode.setValue(getValueByCode(tt[5]));
		bedCode.disable();
		
		var patname = Ext.getCmp("Item1");
	 	patname.setValue(getValueByCode(tt[4]));
		patname.disable();
		
		var diag = Ext.getCmp("Item9");
	 	diag.setValue(getValueByCode(tt[8]));
		diag.disable();
		
        var regno = Ext.getCmp("Item6");
		regno.setValue(getValueByCode(tt[0]));
		regno.disable();
	 	
		var sex = Ext.getCmp("Item2");
		sex.setValue(getValueByCode(tt[3]));
		sex.disable();
		
		var age = Ext.getCmp("Item3");
		age.setValue(getValueByCode(tt[6]));
		age.disable();
		
		var age = Ext.getCmp("Item4");
		age.setValue(getValueByCode(tt[1]));
		age.disable();
		
		var admdate = Ext.getCmp("Item42");
		admdate.setValue(getValueByCode(tt[14]));
		admdate.disable();
		
		var admtime = Ext.getCmp("Item43");
		admtime.setValue(getValueByCode(tt[15]));
		admtime.disable();
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
function butPrintFn()
{
			PrintCommPic.RHeadCaption='dddd';
			PrintCommPic.LHeadCaption="3333333";
			PrintCommPic.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
			//PrintCommPic.RFootCaption="第";
			//PrintCommPic.LFootCaption="页";
			//PrintCommPic.LFootCaption="88";
			//alert(PrintCommPic.Pages);
			PrintCommPic.SetConnectStr(CacheDB);
			PrintCommPic.ItmName = "DHCNURMouldPrn_KFBRSCHLJLDDY";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURBG_RECOVERPATIENTRECORD";
			PrintCommPic.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintCommPic.LabHead=LabHead;			
			//PrintCommPic.SetParrm(parr);
			PrintCommPic.PrintOut();
}
