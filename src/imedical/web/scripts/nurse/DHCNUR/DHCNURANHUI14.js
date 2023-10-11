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
			if(item.id=="Item76")
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
  
var ITypItm="aaa"; //后取数据字典型
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',ifSave);
	var but=Ext.getCmp("butPrint");
    but.on('click',function(){butPGDPrintFn("DHCNurPrnMouldANHUI15")}); 
  var but=Ext.getCmp("butGetScore");
  but.on('click',butGetScore);

	//var GetQueryData=document.getElementById('GetQueryData');

	var Item62 = Ext.getCmp("Item62");
	Item62.on('specialkey',cmbkey2);
	//ITypItm="Item2";
	//setVal2(ExamId);
	setvalue() 
	//getPatInfo();
	var Item13 = Ext.getCmp("Item13");
	Item13.disable();
 	var Item14 = Ext.getCmp("Item14");
	Item14.disable(); 
	var valueItem14=Item14.getValue();  	        //入院时间
    if (valueItem14!="")
    {
      var Time=tkMakeServerCall("Nur.DHCMoudData","getTime",valueItem14)
      //alert(Time)
      var pgdate = Ext.getCmp("Item75");
	  pgdate.setValue(Time)
    }
	 if (userstr!="") 
	  {	
		  getuserha()
    }	 
	setzkinit() //质控初始化
	var Item76=Ext.getCmp("Item76");
	if(Item76)
	{
		Item76.triggerAction='all';
		Item76.forceSelection=true;
		Item76.typeAhead=false;
		Item76.store.on('beforeload',function(){
				Item76.store.baseParams.typ=Item76.lastQuery;	
			})
	}
	var Item21 = Ext.getCmp("Item21"); 
	Item21.on('change',Item21Click,this);
	Item21Click();		
	//alert(SpId);
}function Item21Click()
{
	var Item21=Ext.getCmp("Item21");
	var Item22=Ext.getCmp("Item22");
	var Item23=Ext.getCmp("Item23");
	var Item24=Ext.getCmp("Item24");
	if((Item21)&&(Item22)&&(Item23)&&(Item24))
	{
		var selval=Item21.getRawValue();
		//alert("@"+selval+"@")
		if(selval=="无") 
		{
			Item22.setValue("/");
			Item22.disable();
			
			Item23.setValue("/");
			Item23.disable();
			
			Item24.setValue("/");
			Item24.disable();
		}
		else
		{
			Item22.enable();
			Item23.enable();
			Item24.enable();
		}
	}
} 

function butGetScore()
{
	var GetScore=document.getElementById('GetScore'); 
	if (GetScore) {
		//var ret=cspRunServerMethod(GetScore.value,"DHCNURANHUI16",EpisodeID); 		 
		var ret=cspRunServerMethod(GetScore.value,"DHCNURANHUI21",EpisodeID);
		///alert(ret)
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
    	alert("该病人尚未填写4评单,请先填写再提取!");
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
				Ext.getCmp("Item76").store.load({params:{start:0,limit:100},callback:function(){
		 		if(ha.contains("Item76")){
		 			Ext.getCmp("Item76").typeAhead=false;
					var edustr=ha.items("Item76");
					if(edustr.indexOf('!')>-1)
					{
						Ext.getCmp("Item76").setValue(edustr.split('!')[0]);
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
function ifSave()
{
 var Item22 = Ext.getCmp("Item67"); //体温
  var Item23 = Ext.getCmp("Item68"); //脉搏
  var Item24 = Ext.getCmp("Item69"); //呼吸
  var Item25 = Ext.getCmp("Item70"); //收缩压
  var Item111 = Ext.getCmp("Item73");//舒张压
  //var Item26 = Ext.getCmp("Item26"); //身高
  var Item27 = Ext.getCmp("Item74"); //体重
  var Item99 = Ext.getCmp("Item13"); //入院日期
  var Item112 = Ext.getCmp("Item75"); //入院时间
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
 // valueItem74=valueItem74.replace(/["/"]/g,""); //身高
  var valueItem27=Item27.getValue();
  valueItem27=valueItem27.replace(/["/"]/g,""); //体重
  var valueItem13=formatDate(Item99.getValue()); //入院日期
  var valueItem14=Item112.getValue();  	        //入院时间
  //var valueItem14="10:00"
  
  //var valueItem13="2013-03-08"
  //alert(valueItem13)
  //alert(valueItem14)

if (isNaN(valueItem67)) {
					if ((valueItem67 != "") && (valueItem67.split(".").length > 2)) {
						alert("体温输入格式不对,包括多个点!");
						return;
					} else {
						alert("体温值请录入数字!");
						return;
					}
				} else {
					if ((valueItem67 != "") && ((valueItem67 < 34) || (valueItem67 > 43))) {
						alert("体温值小于34或大于43!");
						return;
					}
				}
  if (valueItem14=="") 
  {
	   alert("请选择插入体温单时间点")
       return
  } 
  var parr="Item1|"+valueItem67+"^"+"Item7|"+valueItem68+"^"+"Item4|"+valueItem69+"^"+"Item5|"+valueItem70+"^"+"Item6|"+valueItem73+"^"+"Item2|"+valueItem27;
	    //alert(parr)
  var flag=tkMakeServerCall("Nur.DHCMoudData","ifexistnew",EpisodeID,valueItem13,valueItem14,parr);
  //alert(flag)
  if (flag!="")
  {   
      //var alertstr="体温单中该时间点已存在值："+flag+"你确定要修改该点记录吗"
	  var alertstr="体温单中该时间点已存在值："+flag+"你确定要修改体温单该时间点的记录吗"
      var conflag=confirm(alertstr)
	  if (conflag){
		  tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);          
	  }
	  Save()    
   }
   else
   {	   
	    tkMakeServerCall("Nur.DHCMoudData","hlblSave",EpisodeID,parr,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],valueItem13,valueItem14);
	    Save()
	}
}
function Save()
{
  ret="";
  checkret="";
  comboret="";

   var getid=document.getElementById("GetId");
   //alert(getid);
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);
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
  //alert(comboret);
   if (id==""){
   var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
   alert("已保存!");
   parent.window.initMainTree();
   window.parent.reloadtree();
   return;
  }
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
	 	patLoc.setValue(getValueByCode(tt[7]));
	 	var bedCode = Ext.getCmp("Item5");
	 	bedCode.setValue(getValueByCode(tt[5]));
		var AdmDiag=tkMakeServerCall("web.DHCNurMouldDataComm","getPatAdmDiag",EpisodeID);
	 	var diag = Ext.getCmp("Item18");
	 	diag.setValue(getValueByCode(tt[8]));
	 	var admdate = Ext.getCmp("Item13");
	 	admdate.setValue(getValueByCode(tt[14]));
   	//var admdate = Ext.getCmp("Item71");
	 	//admdate.setValue(getValueByCode(tt[11]));
	 	var admtime = Ext.getCmp("Item14");
	 	admtime.setValue(getValueByCode(tt[15]));
		
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

		
		var PGDate = Ext.getCmp("Item66");   //填报日期
        PGDate.setValue(nowDate);
 
        var mzobj = Ext.getCmp("Item7"); //民族
	 	mzobj.setValue(getValueByCode(tt[18]));
		 var mzobj = Ext.getCmp("Item76"); //职业
	 	mzobj.setValue(getValueByCode(tt[21]));
		 var mzobj = Ext.getCmp("Item9"); //文化程度
	 	//mzobj.setValue(getValueByCode(tt[12]));
		var paersonLX = Ext.getCmp("Item10"); //婚姻
	 	paersonLX.setValue(getValueByCode(tt[23]));
		
		 var mzobj = Ext.getCmp("Item11"); //联系地址
	 	mzobj.setValue(getValueByCode(tt[11]));
		
		var mzobj = Ext.getCmp("Item12"); //联系人及电话
	 	mzobj.setValue(getValueByCode(tt[20])+"  "+getValueByCode(tt[29]));
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
			PrintComm.RHeadCaption='dddd';
			PrintComm.LHeadCaption="3333333";
			//PrintComm.RFootCaption="第";
			//PrintComm.LFootCaption="页";
			//PrintComm.LFootCaption="88";
			//alert(PrintComm.Pages);
			PrintComm.SetConnectStr(CacheDB); 
			PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNurPrnMouldANHUI15";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURANHUI14";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
}
