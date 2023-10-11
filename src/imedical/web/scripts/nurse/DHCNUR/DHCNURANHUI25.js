var ret="";
var checkret="";
var comboret=""; 
var radioret=""; 
var RadioScore=0;
var CheckScore=0;
 
var arrgrid=new Array();
var ha = new Hashtable();


var locdata = new Array();
var ITypItm="Item15|Item28|Item18|Item19"; //后取数据字典型
//var ITypItm1="Item28"; //后取数据字典型
//alert(1212)
 function BodyLoadHandler(){
    var Item2 = Ext.getCmp("Item15"); 
    Item2.on('specialkey',cmbkey); 
    var Item3 = Ext.getCmp("Item28"); 
    Item3.on('specialkey',cmbkey);
    var Item19 = Ext.getCmp("Item19"); 
    Item19.on('specialkey',cmbkey);
    var Item1 = Ext.getCmp("Item18"); 
    Item1.on('specialkey',cmbkey4); 
     
    var Item8=Ext.getCmp("Item8"); 
    Item8.items.each(eachItem1,this); 
    var Item9=Ext.getCmp("Item9"); 
    Item9.items.each(eachItem1,this); 
    var Item10=Ext.getCmp("Item10"); 
    Item10.items.each(eachItem1,this); 

    var but=Ext.getCmp("butSave");
    but.on('click',Save);
     var but=Ext.getCmp("butPrint");
    but.on('click',butPrintFn1);
         var but=Ext.getCmp("butPrint2");
    but.on('click',butPrintFn2);
        scoregroup2("Item11",4);

      if ((session['LOGON.GROUPDESC']!="护理部")&&(session['LOGON.GROUPDESC']!="护理部主任"))
			{
				  //alert("非护理部工作人员不可对护理部跟踪评价栏目进行填写")
			  	var Item31 = Ext.getCmp("Item26");
			  	Item31.disable()
		  } 
    
    setvalue();
}  
function butPrintFn()
 {
 	if ((session['LOGON.GROUPDESC']!="护理部")&&(session['LOGON.GROUPDESC']!="护理部主任"))
			{
				//alert(11)
				butPrintFn1();
				//return;
			}
			else
				{
				butPrintFn2();
				//return;
				}
 	}
 
function butPrintFn1()
{
      PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB); 
			PrintComm.ItmName = "DHCNurPrnMouldANHUI250";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURANHUI25";
			//parr=parr+"|web.DHCMGtestpge:DHCNurComplexPrn1&parr$"+EpisodeID;    
   		PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//alert(PrintComm.MthArr);	
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			//alert(112)
			PrintComm.PrintOut();
}
function butPrintFn2()
{
		  //alert("odj");		  
		  PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB); 
			PrintComm.WebUrl=webIP+"/trakcare/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNurPrnMouldANHUI2501";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURANHUI25";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();

	
	//printNurRec();	        
	//return;		
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
  
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
 
  //ret+"&"+checkret+"&"+comboret;

if (id==""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,"");
 Ext.Msg.alert('提示', "已保存!");
 return;
}
else
{
  //alert(radioret); 
  var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret+"&"+radioret,id);
  if (Id!=="")
		{
        Ext.Msg.alert('提示', "已保存!");
        return;
    }
    else 
    {
        Ext.Msg.alert('提示', "保存失败!");
        return;
	  }  
 }

}

function scoregroup2(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 var score1 = Ext.getCmp(Itemstr+"_"+count);
   score1.on('check',scoreAdd,this);
  }
}


function scoreFormat(value)
{
	if (value.indexOf("(")!="-1")
  {
  	var scorearry=new Array();
  	scorearry=value.split("(");
  	value=scorearry[1];  
  	scorearry=value.split("分");
    value=scorearry[0]; 
  }
  return value;
}



function GetScoreGroup(Itemstr,Itemcount)
{
	for (count=1;count<=Itemcount;count++)
	{
	 var scoreobj = Ext.getCmp(Itemstr+"_"+count);
	 var scoreflag=scoreobj.getValue();
	 if (scoreflag==true)
	 {
	   var scoreid=scoreobj.getId();  
	   var scorefen=scoreobj.boxLabel;
	   ha.add(Itemstr,scoreFormat(scorefen));
	  }
  }
}

function GetItemHashScore()
{
	GetScoreGroup("Item11",4);
}

function scoreAdd(obj)
{ 
	var flag=obj.getValue();
	var HJScore = Ext.getCmp("Item13"); 
  GetItemHashScore();
  if (flag==true)
	{
	 var scoreid=obj.getId();  
	 var scorefen=obj.boxLabel; 
	 if (scoreid.indexOf("Item11")!="-1")
   { 
    	ha.remove("Item11"); 
		  ha.add("Item11",scoreFormat(scorefen));
   }
   if (ha.items("Item11")!="")
   { 
    	RadioScore = parseInt(ha.items("Item11")) ;
   }  
  }
  HJScore.setValue(RadioScore+CheckScore);
}  

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
     
   if (item.xtype=="radio") {  
   	    if (item.getValue()==true) radioret=radioret+item.id+"|"+item.boxLabel+"^";   
        else {radioret=radioret+item.id+"|"+""+"^";}
   	    //alert(radioret);
     }  
   
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
				//debugger;
       if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
       else {checkret=checkret+item.id+"|"+""+"^";}
       item.on('check',scoregroup,this)  
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
} 

function scoregroup (obj)
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
   sum=sum+a7; 
  } 
  //var Item39value=Ext.getCmp("Item39").getValue(); 
  //if (Item39value!="")
  //{
  //  sum=sum+parseInt(scoreFormat2(Item39value)); 
  //}
  //alert(Item39value); 
  //sum=sum+parseInt(scoreFormat2(Item39value)); 	 
  var sumscore = Ext.getCmp("Item13"); 
	CheckScore=sum;
	sumscore.setValue(sum+RadioScore);  
	checkret=""  
}

var onedoc=new Array();
function getlistdata4(p,cmb)
{
	var GetPerson =document.getElementById('GetDBPerson');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,p);
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addonedoc(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(onedoc);
	}
}

function addonedoc(a,b)
{
	onedoc.push(
	{
		desc:a,
		id:b
	}
	);
}


function cmbkey4(field, e)
{
	
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata4(pp,field);
	//	alert(ret);
		
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

function cmbkey(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata(pp,field);
	//	alert(ret);
		
	}
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
	 	var sex = Ext.getCmp("Item4");
	 	sex.setValue(getValueByCode(tt[3]));
	 	var  regno= Ext.getCmp("Item6");
	 	regno.setValue(getValueByCode(tt[0]));
	 	var age = Ext.getCmp("Item5");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5])); 
	 	
    var myDate=new Date();
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
	 	
	 	var PJDate = Ext.getCmp("Item27");   //填报日期 
	 	var FSDate = Ext.getCmp("Item17");   //填报日期
    FSDate.setValue(nowDate);
    PJDate.setValue(nowDate);
	 		}
}

function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
}

function setvalue()
{ 
	 var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
    
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