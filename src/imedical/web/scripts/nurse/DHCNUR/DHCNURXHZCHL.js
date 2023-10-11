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
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',ifSave);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){butPGDPrintFn("DHCNURMouldprnZCHLnew")} );
	//var GetQueryData=document.getElementById('GetQueryData');

	//var Item2 = Ext.getCmp("Item55");
	//alert(session['LOGON.USERID']);
	//Item2.on('specialkey',cmbkey);
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue()
	 if (userstr!="") 
	  {	
		  getuserha()
    }	 
	setzkinit() //质控初始化
	var Item67_1= Ext.getCmp("Item67_1");
	Item67_1.on("check",function(check){			
		
	  var User1 = Ext.getCmp("Item66");
	  var pgdate = Ext.getCmp("Item53");
	  var pgdate2 = Ext.getCmp("Item57");
	  var pgdate2 = Ext.getCmp("Item60");
	  var pgdate2 = Ext.getCmp("Item65");
	  if(Item67_1.checked==true)
	  {
	 	
		User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 	
	 	pgdate.setValue(new Date)
	 	
	 	pgdate2.setValue(new Date)
	 	
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 		
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	  }
	  else
	  {
		 
		 User1.setValue("");
	 	
	 	pgdate.setValue("")
	 	
	 	pgdate2.setValue("")
	 	
	 	pgdate2.setValue("")
	 		
	 	pgdate2.setValue("") 
	  }
	 	
	})
		
	//alert(SpId);
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
  // alert(id);
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
function ifSave()
{
	//alert(window.parent)
	
   var Item22 = Ext.getCmp("Item15"); //体温
  var Item23 = Ext.getCmp("Item16"); //脉搏
  var Item24 = Ext.getCmp("Item17"); //呼吸
  var Item25 = Ext.getCmp("Item18"); //舒张压
  var Item68 = Ext.getCmp("Item68");//收缩压
  var Item26 = Ext.getCmp("Item19"); //身高
  var Item27 = Ext.getCmp("Item20"); //体重
  var Item99 = Ext.getCmp("Item58"); //入院日期
  var Item242 = Ext.getCmp("Item59"); //入院时间
  var valueItem67=Item22.getValue();
  valueItem67=valueItem67.replace(/["/"]/g,"");  //体温
  var valueItem68=Item23.getValue();
  valueItem68=valueItem68.replace(/["/"]/g,""); //脉搏
  var valueItem69=Item24.getValue();
  valueItem69=valueItem69.replace(/["/"]/g,""); //呼吸
  var valueItem70=Item25.getValue();
  valueItem70=valueItem70.replace(/["/"]/g,""); //收缩压
 var valueItem73=Item68.getValue();
 valueItem73=valueItem73.replace(/["/"]/g,""); //舒张压
  var valueItem74=Item26.getValue();
  valueItem74=valueItem74.replace(/["/"]/g,""); //身高
  var valueItem27=Item27.getValue();
  valueItem27=valueItem27.replace(/["/"]/g,""); //体重
  var valueItem13=formatDate(Item99.getValue()); //入院日期
  var valueItem14=Item242.getValue();  	        //入院时间
   if (valueItem14=="") 
  {alert("请选择插入体温单时间点")
   return
  } 
  //var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27+"^"+"Item25|"+valueItem74; 
  var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27+"^"+"Item25|"+valueItem74;
  //var valueItem14="23:00" 
  //var valueItem13="2013-03-12"
  //alert(valueItem13)
  //alert(valueItem14)
  if (valueItem14=="") 
  {alert("请选择插入体温单时间点")
  return
  } 
  var flag=tkMakeServerCall("web.DHCThreeNew","ifexist",EpisodeID,valueItem13,valueItem14);
  //alert(flag)
  if (flag!="")
  {   var alertstr="体温单中该时间点已存在值："+flag+"你确定要修改该点记录吗"
      Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: alertstr,    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	               
	                //alert(parr)
	                var id=tkMakeServerCall("web.DHCThreeNew","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
                  //alert(id)
                  Save()
	            }
					        else
	            {   //alert(22)
	                Save()    	
	            }            
	        },    
	       animEl: 'newbutton'   
	    });
	  }
	  else
	  {
	    //var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27+"^"+"Item25|"+valueItem74;
	   //alert(parr)
	    var id=tkMakeServerCall("web.DHCThreeNew","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
      //alert(id)
	    Save()
	  }
}
function Save()
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
 ret+"&"+checkret+"&"+comboret;
  //alert(checkret);
  //alert(ret);
  //alert(comboret);
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 alert("已保存");
 window.parent.reloadtree();
 //alert(NurRecId);
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
	 	//alert(EpisodeID)
	 	//var ret2=tkMakeServerCall("Nur.DHCMoudData","gethyinfo",EpisodeID);
		//alert(ret2);
	 	//var tt2=ret2.split('^');
	 	//var wbc = Ext.getCmp("Item42");
	 	//wbc.setValue(getValueByCode(tt2[0]));
	 	var wbc = Ext.getCmp("Item43");
	 	//wbc.setValue(getValueByCode(tt2[1]));
	 	var wbc = Ext.getCmp("Item44");
	 	//wbc.setValue(getValueByCode(tt2[2]));
	 	var wbc = Ext.getCmp("Item45");
	 	//wbc.setValue(getValueByCode(tt2[3]));
	 	var wbc = Ext.getCmp("Item46");
	 	//wbc.setValue(getValueByCode(tt2[4]));
	 	var patName = Ext.getCmp("Item5");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item7");
	 	sex.setValue(getValueByCode(tt[3]));
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	 	var age = Ext.getCmp("Item6");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item1");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item3");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var ward= Ext.getCmp("Item2");
	 	ward.setValue(getValueByCode(tt[7]));
 
	 	var diag = Ext.getCmp("Item8");
	 	diag.setValue(getValueByCode(tt[8]));
	 	var Medcno = Ext.getCmp("Item4");
	 	Medcno.setValue(getValueByCode(tt[9]));
        var TEL= Ext.getCmp("Item11"); //联系人
	 	TEL.setValue(getValueByCode(tt[20]));
	 	var TEL= Ext.getCmp("Item12");  //电话
	 	TEL.setValue(getValueByCode(tt[29]));
	 	var admdate = Ext.getCmp("Item58");
	 	admdate.setValue(getValueByCode(tt[14]));
	 	var admtime = Ext.getCmp("Item59");
	 	admtime.setValue(getValueByCode(tt[15]));

	 	//var MedCareNo = Ext.getCmp("Item411");
	 	//MedCareNo.setValue(getValueByCode(tt[9]));
	 	var User1 = Ext.getCmp("Item48");
	 	User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 	var pgdate = Ext.getCmp("Item49");
	 	pgdate.setValue(new Date)
	
	 	var pgdate2 = Ext.getCmp("Item50");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 	
	 	var Dischgdate = Ext.getCmp("Item53");
	 	Dischgdate.setValue(getValueByCode(tt[16]));
	 	var Dischgtime = Ext.getCmp("Item65");
	 	Dischgtime.setValue(getValueByCode(tt[17]));
	 	
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
	         var getid=document.getElementById('GetId');
             var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
            //alert(id);
			if (id=="")
			{
				alert("未保存")
			}
			PrintCommPic.RHeadCaption='dddd';
			PrintCommPic.LHeadCaption="3333333";
			PrintCommPic.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
			var hospital=tkMakeServerCall("web.DHCMGNurComm","gethospital",session['LOGON.CTLOCID'])
			PrintCommPic.TitleCaption=hospital
			//PrintCommPic.RFootCaption="第";
			//PrintCommPic.LFootCaption="页";
			//PrintCommPic.LFootCaption="88";
			//alert(PrintCommPic.Pages);
			PrintCommPic.SetConnectStr(CacheDB);
			PrintCommPic.ItmName = "DHCNURMouldprnZCHLnew";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURXHZCHL";
			
			
			PrintCommPic.MthArr="Nur.DHCMoudData:getVal2&id:"+id;
			//PrintCommPic.LabHead=LabHead;			
			//PrintCommPic.SetParrm(parr);
			PrintCommPic.PrintOut();
}
