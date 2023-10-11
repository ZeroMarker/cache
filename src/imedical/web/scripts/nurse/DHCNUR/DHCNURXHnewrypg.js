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
			if(item.id=="Item116")
			{
				comboret=  comboret+item.id+"|"+item.getValue()+"@"+item.lastSelectionText+"!"+item.lastSelectionText+"^";
			}
			else
			{
				comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
			}
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
       else  checkret=checkret+item.id+"|"+""+"^";  
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}

var ITypItm="Item51"; //后取数据字典型
var yaochuang=0; //压疮
var diedaozc=0;//跌倒坠床
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);    
  // alert(findPosition(myCanvas))
	var but=Ext.getCmp("butSave");
    but.on('click',ifSave);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){butPGDPrintFn("DHCNURMouldnewrypgdPrn")});
	//var GetQueryData=document.getElementById('GetQueryData');

	var Item2 = Ext.getCmp("Item51");
	//alert(session['LOGON.USERID']);
	Item2.on('specialkey',cmbkey);
	//ITypItm="Item2";
	//setVal2(ExamId);
	//alert(23)
	setvalue()
	//getPatInfo();
	var Item100 = Ext.getCmp("Item100");
	Item100.disable()
	var valueItem14=Item100.getValue();  	        //入院时间
  //alert(valueItem14)
  if (valueItem14!="")
  {
  var Time=tkMakeServerCall("Nur.DHCMoudData","getTime",valueItem14)
  //alert(Time)
  var pgdate = Ext.getCmp("Item112");
	 	pgdate.setValue(Time)
  }
	//yaochuang=0; //压疮
  //diedaozc=0;//跌倒坠床
	var Item9_2= Ext.getCmp("Item9_2");
	Item9_2.on("check",function(check){			
			 yaochuang=1;
			 //alert(yaochuang)
	})
		var Item9_2= Ext.getCmp("Item105_3");
	Item9_2.on("check",function(check){			
			 yaochuang=1;
	})
	var Item9_2= Ext.getCmp("Item29_2");
	Item9_2.on("check",function(check){		
	    diedaozc=1	
		
	})
	var Item9_2= Ext.getCmp("Item29_3");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item29_4");
	Item9_2.on("check",function(check){			
			 diedaozc=1	
	})
	var Item9_2= Ext.getCmp("Item29_5");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item46_2");
	Item9_2.on("check",function(check){			
			 yaochuang=1;
	})
	var Item9_2= Ext.getCmp("Item46_3");
	Item9_2.on("check",function(check){			
		 yaochuang=1;
	})
	//var Item9_2= Ext.getCmp("Item46_8");
	//Item9_2.on("check",function(check){			
	//	 yaochuang=1;
	//})
		var Item9_2= Ext.getCmp("Item56");
	Item9_2.on("check",function(check){			
		 yaochuang=1;
	})
		
		var Item9_2= Ext.getCmp("Item51_4");
	Item9_2.on("check",function(check){			
			 yaochuang=1;	
	})
	var Item9_2= Ext.getCmp("Item60_2");
	Item9_2.on("check",function(check){			
			 diedaozc=1	
	})
	var Item9_2= Ext.getCmp("Item60_3");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item60_4");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item61");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item68_3");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
	var Item9_2= Ext.getCmp("Item69_3");
	Item9_2.on("check",function(check){			
			 diedaozc=1	
	})
	var Item9_2= Ext.getCmp("Item21");
	Item9_2.on("check",function(check){			
			 diedaozc=1		
	})
		var Item9_2= Ext.getCmp("Item61");
	Item9_2.on("check",function(check){			
			 yaochuang=1;
	})
	var Item71= Ext.getCmp("Item71");
			
	//Item71.on('change',chek71,this);

	/* var Item46_1 = Ext.getCmp("Item46_1");

	Item46_1.on("check",function(check){
			Ext.getCmp("Item46_7").setValue(check.checked);
		
	}) */
	var Item67_1= Ext.getCmp("Item92_1");
	Item67_1.on("check",function(check){			
			 
	  var User1 = Ext.getCmp("Item96");
	 	User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 	var pgdate = Ext.getCmp("Item97");
	 	pgdate.setValue(new Date)
	  	var pgdate = Ext.getCmp("Item87");
	 	pgdate.setValue(new Date)
	 	var pgdate2 = Ext.getCmp("Item98");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 		var pgdate2 = Ext.getCmp("Item88");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 	
	})
	var Item87 = Ext.getCmp("Item87"); 
	Item87.on('change',Item87Click,this); 
	var Item84 = Ext.getCmp("Item84");
	Item84.disable()
	var Item14 = Ext.getCmp("Item14"); 
	Item14.on('change',Item14Click,this);
	var Dischgdate = Ext.getCmp("Item87");
	if(Dischgdate.getValue()=="")
	{
		var PatInfo=document.getElementById('PatInfo');
		if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
	 	var tt=ret.split('^');
		if(Dischgdate.getValue()=="") Dischgdate.setValue(getValueByCode(tt[16]));
		var Dischgtime = Ext.getCmp("Item88");
		if(Dischgtime.getValue()=="") Dischgtime.setValue(getValueByCode(tt[17]));
		var DischgDiag = Ext.getCmp("Item89");
		if(DischgDiag.getValue()=="") DischgDiag.setValue(getValueByCode(tt[32]));
		}
	}
	var Item116=Ext.getCmp("Item116");
	if(Item116)
	{
		Item116.triggerAction='all';
		Item116.forceSelection=true;
		Item116.typeAhead=false;
		Item116.store.on('beforeload',function(){
					Item116.store.baseParams.typ=Item116.lastQuery;	
			})
	}
	Item14Click();
	//过敏史食物控制
	var Item106=Ext.getCmp("Item106");
	var Item54_1= Ext.getCmp("Item54_1");
	Item54_1.on("check",function(check){			
		if(Item54_1.getValue())
		{
			Item106.setValue("");
			Item106.disable();
		}
		else{
			Item106.enable();
		}
	})
	//过敏史药物控制
	var Item108=Ext.getCmp("Item108");
	var Item55_1= Ext.getCmp("Item55_1");
	Item55_1.on("check",function(check){			
		if(Item55_1.getValue())
		{
			Item108.setValue("");
			Item108.disable();
		}
		else{
			Item108.enable();
		}
	})
	//饮食-食物禁忌控制
	var Item53=Ext.getCmp("Item53");
	var Item52_1= Ext.getCmp("Item52_1");
	var Item52_2= Ext.getCmp("Item52_2");
	Item52_1.on("check",function(check){			
		if(Item52_1.getValue())
		{
			Item53.setValue("");
			Item53.disable();
			Item52_2.setValue(false);
		}
		else{
			Item53.enable();
			Item52_2.setValue(true);
		}
	})
	Item52_2.on("check",function(check){			
		if(Item52_2.getValue())
		{
			
			Item53.enable();
			Item52_1.setValue(false);
		}
		else{
			Item53.setValue("");
			Item53.disable();
			Item52_1.setValue(true);
		}
	})
	SetPatInfoDisable();
}
function Item87Click()
{
		var User1 = Ext.getCmp("Item96");
	 	User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 	var pgdate = Ext.getCmp("Item97");
	 	pgdate.setValue(new Date)
	  	//var pgdate = Ext.getCmp("Item87");
	 	//pgdate.setValue(new Date)
	 	var pgdate2 = Ext.getCmp("Item98");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 		var pgdate2 = Ext.getCmp("Item88");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
}
function Item14Click()
{
	var Item14=Ext.getCmp("Item14");
	var Item15=Ext.getCmp("Item15");
	if((Item14)&&(Item15))
	{
		var selval=Item14.getValue();
		if(selval=="无") 
		{
			Item15.setValue("");
			Item15.disable();
		}
		else
		{
			Item15.enable();
		}
	}
}
function SetPatInfoDisable()
{
		var patName = Ext.getCmp("Item5");
	 	patName.disable();
	 	var sex = Ext.getCmp("Item7");
	 	sex.disable();
	 	var  ward= Ext.getCmp("Item1");
	    ward.disable();
	 	var age = Ext.getCmp("Item6");
	 	age.disable();
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.disable();
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.disable();
	 	var admdate = Ext.getCmp("Item99");
	 	admdate.disable();
	 	var admtime = Ext.getCmp("Item100");
	 	admtime.disable();
		/* var Dischgdate = Ext.getCmp("Item87");
	 	Dischgdate.disable();
	 	var Dischgtime = Ext.getCmp("Item88");
	 	Dischgtime.disable(); */
	 	var MedCareNo = Ext.getCmp("Item4");
	 	MedCareNo.disable();
	 	
}
function chek71(obj)
{
	 //var scorearry1=new Array(); 
	 var scorehj=0; 
	 var tmp=obj.getValue();
	 //alert(11)
	 //alert(tmp)
	
 
	
	
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
	//alert(1)
   var ha = new Hashtable();
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   var Item116=Ext.getCmp("Item116");
	if(Item116)
	{
		Item116.store.load({params:{start:0,limit:10}});
	}
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
		
			Ext.getCmp("Item116").store.load({params:{start:0,limit:100},callback:function(){
		 		if(ha.contains("Item116")){
		 			Ext.getCmp("Item116").typeAhead=false;
					var edustr=ha.items("Item116");
					if(edustr.indexOf('!')>-1)
					{
						Ext.getCmp("Item116").setValue(edustr.split('!')[0]);
					}
		 			
					//alert(ha.items("Item116"))
		 		}
		 	}})
			
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
function ageFormat(value)
{
if (value.indexOf("岁")!="-1")
{ 
 var scorearry1=new Array(); 
 scorearry1=value.split("岁");
 value=scorearry1[0]; 
 
 if (value==null)
 {
  value="0";
 }
}
else
{
	if (value=="") value="0";
}  
 return value;
}
function inserttwd()
{
  var Item22 = Ext.getCmp("Item22"); //体温
  var Item23 = Ext.getCmp("Item23"); //脉搏
  var Item24 = Ext.getCmp("Item24"); //呼吸
  var Item25 = Ext.getCmp("Item25"); //收缩压
  var Item111 = Ext.getCmp("Item111");//舒张压
  var Item26 = Ext.getCmp("Item26"); //身高
  var Item27 = Ext.getCmp("Item27"); //体重
  var Item99 = Ext.getCmp("Item99"); //入院日期
  var Item112 = Ext.getCmp("Item112"); //入院时间
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
  var valueItem74=Item26.getValue();
  valueItem74=valueItem74.replace(/["/"]/g,""); //身高
  var valueItem27=Item27.getValue();
  valueItem27=valueItem27.replace(/["/"]/g,""); //体重
  var valueItem13=formatDate(Item99.getValue()); //入院日期
  var valueItem14=Item112.getValue();  	        //入院时间
 // alert(valueItem14)
  if (valueItem14=="") 
  {alert("请选择插入体温单时间点")
  return
  }
  
  //alert(valueItem14)
  //var Time=tkMakeServerCall("Nur.DHCMoudData","getTime",valueItem14)
  //alert(Time)

  //alert(tempSave)
  //alert(parr)
  //var id=cspRunServerMethod(tempSave.value,EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,Time);
  //alert(id)
  //var id=tkMakeServerCall("web.DHCThreeNew","Save",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
  //alert(id)
}
function ifSave()
{
 var Item22 = Ext.getCmp("Item22"); //体温
  var Item23 = Ext.getCmp("Item23"); //脉搏
  var Item24 = Ext.getCmp("Item24"); //呼吸
  var Item25 = Ext.getCmp("Item25"); //收缩压
  var Item111 = Ext.getCmp("Item111");//舒张压
  var Item26 = Ext.getCmp("Item26"); //身高
  var Item27 = Ext.getCmp("Item27"); //体重
  var Item99 = Ext.getCmp("Item99"); //入院日期
  var Item112 = Ext.getCmp("Item112"); //入院时间
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
  var valueItem74=Item26.getValue();
  valueItem74=valueItem74.replace(/["/"]/g,""); //身高
  var valueItem27=Item27.getValue();
  valueItem27=valueItem27.replace(/["/"]/g,""); //体重
  var valueItem13=formatDate(Item99.getValue()); //入院日期
  var valueItem14=Item112.getValue();  	        //入院时间
  //var valueItem14="10:00"
  
  //var valueItem13="2013-03-08"
  //alert(valueItem13)
 // alert(valueItem14)
  if (valueItem14=="") 
  {alert("请选择插入体温单时间点")
  return
  } 
  var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27+"^"+"Item25|"+valueItem74;   //+"^"+"Item25|"+valueItem74;
  var flag=tkMakeServerCall("Nur.DHCMoudData","ifexistnew",EpisodeID,valueItem13,valueItem14,parr);
  //var flag=tkMakeServerCall("web.DHCThreeNew","ifexist",EpisodeID,valueItem13,valueItem14);
  //alert(flag)
  if (flag!="")
  {   
	var alertstr="体温单中该时间点已存在值："+flag+"你确定要修改该点记录吗"
	var conflag=confirm(alertstr);
	if (conflag)
	{
		//var id=tkMakeServerCall("web.DHCThreeNew","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
		tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
        Save()
	}
	  }
	  else
	  {
	    var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27+"^"+"Item25|"+valueItem74;   //+"^"+"Item25|"+valueItem74;
	    //alert(parr)
	    //var id=tkMakeServerCall("web.DHCThreeNew","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
		tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
     // alert(id)
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
  ret+"&"+checkret+"&"+comboret;
  var getid=document.getElementById("GetId");
  var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
 
if (id!="")
{
		var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,id);

}
else
	{
		var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 
	}
if (Id!=="")
	{
		alert("已保存");
	}
else 
	{
		alert("保存失败");
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
	 	//alert(tt)
	 	var patName = Ext.getCmp("Item5");
	 	patName.setValue(getValueByCode(tt[4]));
	 	//patName.disable();
	 	var sex = Ext.getCmp("Item7");
	 	sex.setValue(getValueByCode(tt[3]));
	 	//sex.disable();
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	 	var  ward= Ext.getCmp("Item1");
	  ward.setValue(getValueByCode(tt[7]));
	 	var age = Ext.getCmp("Item6");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item3");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item2");
	 	bedCode.setValue(getValueByCode(tt[5]));
		
		var AdmDiag=tkMakeServerCall("web.DHCNurMouldDataComm","getPatAdmDiag",EpisodeID);
	 	var diag = Ext.getCmp("Item10");
	 	diag.setValue(AdmDiag);
 
	 	var TEL= Ext.getCmp("Item20");
	 	//alert(TEL)
	 	TEL.setValue(getValueByCode(tt[29]));
	 	var admdate = Ext.getCmp("Item99");
	 	admdate.setValue(getValueByCode(tt[14]));
	 	var admtime = Ext.getCmp("Item100");
	 	admtime.setValue(getValueByCode(tt[15]));
		var Dischgdate = Ext.getCmp("Item87");
	 	Dischgdate.setValue(getValueByCode(tt[16]));
	 	var Dischgtime = Ext.getCmp("Item88");
	 	Dischgtime.setValue(getValueByCode(tt[17]));
		var DischgDiag = Ext.getCmp("Item89");
	 	DischgDiag.setValue(getValueByCode(tt[32]));
	 	var MedCareNo = Ext.getCmp("Item4");
	 	MedCareNo.setValue(getValueByCode(tt[9]));
	 	var Nation = Ext.getCmp("Item8");
	 	Nation.setValue(getValueByCode(tt[18]));
	 	var admreason = Ext.getCmp("Item11"); //费用支付
	 	admreason.setValue(getValueByCode(tt[19]));
	 	var paersonLX = Ext.getCmp("Item19");
	 	paersonLX.setValue(getValueByCode(tt[20]));
	 	var Item18 = Ext.getCmp("Item18"); //职业
	 	Item18.setValue(getValueByCode(tt[21]));
	 	var paersonLX = Ext.getCmp("Item21"); //与患者关系
	 	paersonLX.setValue(getValueByCode(tt[22]));
	 	var paersonLX = Ext.getCmp("Item13"); //婚姻
	 	paersonLX.setValue(getValueByCode(tt[23]));
	 	
	 	var User1 = Ext.getCmp("Item84");
	 	User1.setValue(session['LOGON.USERNAME']+" "+session['LOGON.USERCODE']);
	 	var pgdate = Ext.getCmp("Item85");
	 	pgdate.setValue(new Date)
	 	var pgdate2 = Ext.getCmp("Item86");
	 	pgdate2.setValue(new Date().dateFormat('H:i'))
	 	//var User2 = Ext.getCmp("Item96");
	 	//User2.setValue(session['LOGON.USERCODE']);
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
	var parr="@"+EpisodeID+"@"+EmrCode;
	var EmrType=3;  //1:混合单 2：记录单 3：评估单
	var MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
	var ItmName="DHCNURMouldnewrypgdPrn";	
	var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+ItmName+"&MthArr="+MthArr;
	window.location.href=link;
}
 //生成图片
 function MakePicturePGd(prncode)
 {
    if(prncode=="") return;
	var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
	if(GetPGDId)
	{   
		var MthArr="Nur.DHCMoudData:getVal$parr:"+GetPGDId+"!";	
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"Y");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"Y");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"Y");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"Y");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"Y");
		var EmrType=3; 
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&MthArr="+MthArr;
		window.location.href=link;
		
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=MakePicture&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+prncode+"&MthArr="+MthArr;
		window.location.href=link;
	}
  } 
  

