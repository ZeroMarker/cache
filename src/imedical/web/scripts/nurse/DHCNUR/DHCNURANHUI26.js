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
     if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) 	{checkret=checkret+item.id+"|"+item.boxLabel+"^";}
			else {checkret=checkret+item.id+"|"+""+"^";}
		   
      
    }      
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
	 /*if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";   
      else {checkret=checkret+item.id+"|"+""+"^";}
    }  */
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}   
var ITypItm="Item10|Item11|Item61"; //后取数据字典型
function BodyLoadHandler(){
	//alert(22)
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){butPGDPrintFn("DHCNurPrnMouldANHUI260")}); 
 

	//var GetQueryData=document.getElementById('GetQueryData');

	var Item2 = Ext.getCmp("Item61");
	
	Item2.on('specialkey',cmbkey);
		var Item11 = Ext.getCmp("Item11");
	
	Item11.on('specialkey',cmbkey);
		var Item10 = Ext.getCmp("Item10");
	
	Item10.on('specialkey',cmbkey);
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue()
	//var temp = Ext.getCmp("Item67");
//	var temp1= temp.getValue();
	//find1();
	SetPatInfoDisable();	
}
function SetPatInfoDisable()
{
		var patName = Ext.getCmp("Item1");
	 	patName.disable();
		var sex = Ext.getCmp("Item2");
		sex.disable();
		var  regno= Ext.getCmp("Item6");
		regno.disable();
	 	var age = Ext.getCmp("Item3");
	 	age.disable();
	 	var patLoc = Ext.getCmp("Item4");
	 	patLoc.disable();
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.disable();
} 
var REC=new Array();
function find1(){
	REC = new Array();
	var adm = EpisodeID;
	var StartDate = Ext.getCmp("Item13");
	var StartDate=formatDate(StartDate.getValue());
	
	var EndDate=diffDate(new Date(),0);
	//alert(StartDate+"@"+EndDate)
	var parr =EpisodeID+"^"+StartDate+"^"+EndDate;
	var GetQueryData = document.getElementById('GetQueryData');
  //alert(parr)  //11447467^2112-12-21^2113-01-21
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCThreeNew:GetPatTempData", "Parr$" + parr,"AddRec");  //
	//	alert(a)
	//alert(SpId);
	//alert(a)
	mygrid.store.loadData(REC);
}

function AddRec(str)
{
	//alert(str)
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}

function AddRec(str)
{
	alert(str)
}
function butGetScore()
{
	var GetScore=document.getElementById('GetScore'); 
	if (GetScore) {
		//var ret=cspRunServerMethod(GetScore.value,"DHCNURANHUI16",EpisodeID); 
		 
		var ret=cspRunServerMethod(GetScore.value,"DHCNURANHUI21",EpisodeID);
	 	if (ret!="")
    { 
 	 	var tt=ret.split('^');
	 	var ADLScore = Ext.getCmp("Item45");
	 	ADLScore.setValue(getValueByCode(tt[0]));
	 	var BradenScore = Ext.getCmp("Item63");
	 	BradenScore.setValue(getValueByCode(tt[1]));
    var MorseScore = Ext.getCmp("Item64");
    MorseScore.setValue(getValueByCode(tt[2]));
    var GDScore = Ext.getCmp("Item65");
    GDScore.setValue(getValueByCode(tt[3]));
 
    }
    else
    {
    	Ext.Msg.alert('提示', "该病人尚未填写4评单,请先填写再提取!");
    }
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
/*function Save()
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
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 alert("已保存");
 //alert(NurRecId);

} */

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
  //alert(ret+"&"+checkret+"&"+comboret);
  //alert(checkret);
  //alert(comboret);
    if (id==""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
  alert("已保存!");
  window.parent.reloadtree2(EmrCode,"评估");
 return;
}
 //alert(NurRecId);
else
	{
		//alert("^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret)
		var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,id);
 
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
	//alert(333333)
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
	 	var sex = Ext.getCmp("Item2");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item6");
	 	regno.setValue(getValueByCode(tt[9]));
	 	var age = Ext.getCmp("Item3");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item4");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var diag = Ext.getCmp("Item7");
	 	diag.setValue(getValueByCode(tt[8]));
	 	//var admdate = Ext.getCmp("Item13");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admdate = Ext.getCmp("Item71");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admtime = Ext.getCmp("Item14");
	 	//admtime.setValue(getValueByCode(tt[11]));
		/*
	  var myDate=(new Date(),0);
	 	var Month=myDate.getMonth()+1;
	 	var MDate=myDate.getDate();
	 	if ((((myDate.getDate()).toString()).length)==1)  //修改日期日头格式
	 	{
	 		var MDate="0"+(myDate.getDate()).toString();
	 	}
	 	if ((((myDate.getMonth()+1).toString()).length)==1)  //修改日期月份格式
	 	{
	 		var Month="0"+(myDate.getMonth()+1).toString();
	 	}
	 	var nowDate=myDate.getYear()+"-"+Month+"-"+MDate;

		
		var PGDate = Ext.getCmp("Item66");   //填报日期
    PGDate.setValue(nowDate);

		*/
		//alert("dd");
	 	//var MedCareNo = Ext.getCmp("Item411");
	 	//MedCareNo.setValue(getValueByCode(tt[9]));
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
	
	
		PrintCommPic.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
		//PrintCommPic.ItmName = "DHCNurPrnMouldANHUI27"; //338155!2010-07-13!0:00!!
		//debugger;
		
			//PrintCommPic.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
			PrintCommPic.ItmName = "DHCNurPrnMouldANHUI260";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			//var parr="@"+EpisodeID+"@DHCNURANHUI26";
			//PrintCommPicPic.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			var getid=document.getElementById('GetId');
            var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
            //alert(id)
			PrintCommPic.MthArr="Nur.DHCMoudData:getVal&id:"+id+"!";
			//PrintCommPic.LabHead=LabHead;			
			//PrintCommPic.SetParrm(parr);
			PrintCommPic.PrintOut();
}
