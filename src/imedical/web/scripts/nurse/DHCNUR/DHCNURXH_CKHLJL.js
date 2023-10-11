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
			else checkret=checkret+item.id+"|"+"^";  
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}
function InitEventZSK()
{ 
	var arrLength=arr.length;
	var zskObj;
    for(var i=0;i<arrLength;++i)
	{
		if((arr[i].xtype=="textfield")||(arr[i].xtype=="textarea"))		
           {
            zskObj=Ext.getCmp(arr[i].id);
            zskObj.on('focus',GetItemId);
           }
		else
		{
			insrtCurrentId="";
		}			
   }
}


function GetItemId()
{
  insrtCurrentId=this.id;
}
//责任护士
var UserItems="^Item62^Item50^Item151^Item152^Item153^Item154^Item155^Item156^Item157^Item158^Item159^Item160^Item161^Item162^Item163^Item164^Item165^Item166^Item167^Item168^Item169^Item170^Item171^Item172^Item173^Item174^Item175^Item235^";
//指导人
var UserItems2="^Item176^Item177^Item178^Item179^Item180^Item181^Item182^Item183^Item184^Item185^Item186^Item187^Item188^Item189^Item190^Item191^Item192^Item193^Item194^Item195^Item196^Item197^Item198^";
//评估人
var UserItems3="^Item199^Item200^Item201^Item202^Item203^Item204^Item205^Item206^Item207^Item208^Item209^Item210^Item211^Item212^Item213^Item214^Item215^Item216^Item217^Item218^Item219^Item220^Item221^";


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

var insrtCurrentId="" //全局变量
   
var ITypItm="Item93331"; //后取数据字典型
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){butPGDPrintFn("DHCNURHLJLD_ckprn")});
    var but=Ext.getCmp("butsave1");
    but.on('click',Save);
	var but=Ext.getCmp("butprint1");
    but.on('click',function(){butPGDPrintFn("DHCNURHLJLD_ckprn")});
    var but=Ext.getCmp("butsave2");
    but.on('click',Save);
	var but=Ext.getCmp("butprint2");
    but.on('click',function(){butPGDPrintFn("DHCNURHLJLD_ckprn")});
	//var GetQueryData=document.getElementById('GetQueryData');
	var userarr=UserItems.split('^');
	for(var kk=0;kk<userarr.length;kk++)
	{
		var usitem=userarr[kk];
		var userobj = Ext.getCmp(usitem);
		if(userobj) userobj.on('specialkey',cmbkey2);
	}
	var userarr=UserItems2.split('^');
	for(var kk=0;kk<userarr.length;kk++)
	{
		var usitem=userarr[kk];
		var userobj = Ext.getCmp(usitem);
		if(userobj) userobj.on('specialkey',cmbkey2);
	}
	var userarr=UserItems3.split('^');
	for(var kk=0;kk<userarr.length;kk++)
	{
		var usitem=userarr[kk];
		var userobj = Ext.getCmp(usitem);
		if(userobj) userobj.on('specialkey',cmbkey2);
	}
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue()
	 if (userstr!="") 
	  {	
		  getuserha()
    }
	InitEventZSK(); //知识库	
	setzkinit() //质控初始化
	var Item67 = Ext.getCmp("Item67");
	Item67.disable()
	var valueItem14=Item67.getValue();  	        //入院时间
  //alert(valueItem14)
  if (valueItem14!="")
  {
  var Time=tkMakeServerCall("Nur.DHCMoudData","getTime",valueItem14)
  //alert(Time)
  var pgdate = Ext.getCmp("Item242");
	 	pgdate.setValue(Time)
  }
	//var Item67_1= Ext.getCmp("Item67_1");
	//Item67_1.on("check",function(check){			
			 
	//  var User1 = Ext.getCmp("Item66");
	// 	User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	/// 	var pgdate = Ext.getCmp("Item53");
	// 	pgdate.setValue(new Date)
	// 	var pgdate2 = Ext.getCmp("Item57");
	// 	pgdate2.setValue(new Date)
	// 	var pgdate2 = Ext.getCmp("Item60");
	 //	pgdate2.setValue(new Date().dateFormat('H:i'))
	// 		var pgdate2 = Ext.getCmp("Item65");
	// 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 	
	//})
	//var Item235= Ext.getCmp("Item235");
	//Item235.disable()
	var Item67_1= Ext.getCmp("Item233_1");
	Item67_1.on("check",function(check){					 
	  var User1 = Ext.getCmp("Item235");
	 	User1.setValue(session['LOGON.USERNAME']);	 	
	})
	var Item67_1= Ext.getCmp("Item233_2");
	Item67_1.on("check",function(check){					 
	  var User1 = Ext.getCmp("Item235");
	 	User1.setValue(session['LOGON.USERNAME']);	 	
	})
	var Item67_1= Ext.getCmp("Item233_3");
	Item67_1.on("check",function(check){					 
	  var User1 = Ext.getCmp("Item235");
	 	User1.setValue(session['LOGON.USERNAME']);	 	
	})
	var Dischgdate = Ext.getCmp("Item222");
	if(Dischgdate.getValue()=="")
	{
		var PatInfo=document.getElementById('PatInfo');
		if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
	 	var tt=ret.split('^');
		if(Dischgdate.getValue()=="") Dischgdate.setValue(getValueByCode(tt[16]));
		var DischgDiag = Ext.getCmp("Item223");
		if(DischgDiag.getValue()=="") DischgDiag.setValue(getValueByCode(tt[32]));
		}
	}
	SetPatInfoDisable();
}
function SetPatInfoDisable()
{
		var patName = Ext.getCmp("Item1");
	 	patName.disable();
	 	var age = Ext.getCmp("Item4");
	 	age.disable();
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.disable();
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.disable();
	 	var Medcno = Ext.getCmp("Item2");
	 	Medcno.disable();
	 	var admdate = Ext.getCmp("Item11");
	 	admdate.disable();
	 	var admtime = Ext.getCmp("Item67");
	 	admtime.disable();
    	var admtime = Ext.getCmp("Item14"); 
	 	admtime.disable();
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
  
  var Item22 = Ext.getCmp("Item15"); //体温
  var Item23 = Ext.getCmp("Item17"); //脉搏
  var Item24 = Ext.getCmp("Item68"); //呼吸
  var Item25 = Ext.getCmp("Item18"); //收缩压
  var Item111 = Ext.getCmp("Item239");//舒张压
  //var Item26 = Ext.getCmp("Item8"); //身高
  //var Item27 = Ext.getCmp("Item54"); //体重
  var Item99 = Ext.getCmp("Item11"); //入院日期
  var Item242 = Ext.getCmp("Item242"); //入院时间
  var valueItem67=Item22.getValue();
  valueItem67=valueItem67.replace(/["/"]/g,"");  //体温
  var valueItem68=Item23.getValue();
  valueItem68=valueItem68.replace(/["/"]/g,""); //脉搏
  var valueItem69=Item24.getValue();
  valueItem69=valueItem69.replace(/["/"]/g,""); //呼吸
  var valueItem70=Item25.getValue();
  valueItem70=valueItem70.replace(/["/"]/g,""); //收缩压
  var valueItem73=Item111.getValue();
  valueItem73=valueItem73.replace(/["/"]/g,""); //舒张压
  //var valueItem74=Item26.getValue();
  //valueItem74=valueItem74.replace(/["/"]/g,""); //身高
  //var valueItem27=Item27.getValue();
  //valueItem27=valueItem27.replace(/["/"]/g,""); //体重
  var valueItem13=formatDate(Item99.getValue()); //入院日期
  var valueItem14=Item242.getValue();  	        //入院时间
   if (valueItem14=="") 
  {alert("请选择插入体温单时间点")
   return
  }
  //alert(valueItem14)
  //var Time=tkMakeServerCall("Nur.DHCMoudData","getTime",valueItem14)
  //alert(Time)
  //var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73;
  var parr="TEMPERATURE|"+valueItem67+"^"+"PULSE|"+valueItem68+"^"+"BREATH|"+valueItem69+"^"+"SYSPRESSURE|"+valueItem70+"^"+"DIAPRESSURE|"+valueItem73;
  var flag=tkMakeServerCall("Nur.DHCMoudData","ifexistnew",EpisodeID,valueItem13,valueItem14,parr);
  if (flag!="")
  {   
      var alertstr="体温单中该时间点已存在值："+flag+"你确定要修改体温单该时间点的记录吗"
      var conflag=confirm(alertstr)
	  if (conflag){
		  tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);          
	  }
	  Save2()    
   }
   else
   {	   
	    tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
	    Save2()
	}
}
function Save2()
{
  ret="";
  checkret="";
  comboret="";
  var SaveRec=document.getElementById('Save');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
   var flag=Savezk();	  //质控
  if (flag==1) 
  {
	   alert("红色区域不能为空")
	   return
  }
  if (flag==2) 
  {
	  // alert("红色区域不能为空")
	  return
  }
  //alert(EmrCode)
 //alert(ret+"&"+checkret+"&"+comboret);
  //alert(checkret);
  //alert(ret);
  //alert(comboret);
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 //alert(Id)
 alert("本入院评估单数据已保存");
 //alert(NurRecId);
  window.parent.reloadtree();
 setvalue();
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
	 //	var sex = Ext.getCmp("Item7");
	 //	sex.setValue(getValueByCode(tt[3]));
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	 	var age = Ext.getCmp("Item4");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	//var ward= Ext.getCmp("Item2");
	 //	ward.setValue(getValueByCode(tt[7]));
 
	 	//var diag = Ext.getCmp("Item8");
	 //	diag.setValue(getValueByCode(tt[8]));
	 	var Medcno = Ext.getCmp("Item2");
	 	Medcno.setValue(getValueByCode(tt[9]));
  
	 	//var TEL= Ext.getCmp("Item12");
	 	//TEL.setValue(getValueByCode(tt[10]));
	 	var admdate = Ext.getCmp("Item11");
	 	admdate.setValue(getValueByCode(tt[14]));
	 	var admtime = Ext.getCmp("Item67");
	 	admtime.setValue(getValueByCode(tt[15]));
    	var admtime = Ext.getCmp("Item14"); //费用支付
	 	admtime.setValue(getValueByCode(tt[19]));
		
		var Dischgdate = Ext.getCmp("Item222");
	 	Dischgdate.setValue(getValueByCode(tt[16]));
		var DischgDiag = Ext.getCmp("Item223");
	 	DischgDiag.setValue(getValueByCode(tt[32]));
	 	//var MedCareNo = Ext.getCmp("Item411");
	 	//MedCareNo.setValue(getValueByCode(tt[9]));
	 //	var User1 = Ext.getCmp("Item48");
	 //User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 //	var pgdate = Ext.getCmp("Item49");
	 //	pgdate.setValue(new Date)
	
	// 	var pgdate2 = Ext.getCmp("Item50");
	 //	pgdate2.setValue(new Date().dateFormat('H:i'))
	 	
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
			PrintComm.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB);
			var hospital=tkMakeServerCall("web.DHCMGNurComm","gethospital",session['LOGON.CTLOCID'])
			PrintComm.TitleCaption=hospital
			PrintComm.ItmName = "DHCNURHLJLD_ckprn";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURXH_CKHLJL";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm2&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
}
