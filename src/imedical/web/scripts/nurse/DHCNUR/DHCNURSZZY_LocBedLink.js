var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();
//var Rowid=opener.document.getElementById("Rowid").value;
var locdata = new Array();
var condata = new Array();
var beddata = new Array();
//var condata = new Array();
function addloc(a, b) {
	//alert(a+"^"+b)
	locdata.push({
				id : a,
				desc : b
				
			});
}
function addbed(a, b) {
	//alert(a+"^"+b)
	beddata.push({
				id : a,
				desc : b
				
			});
}
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
      else
				{
			
					checkret=checkret+item.id+"|^";
				}
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}   
var ITypItm="PatLoc"; //后取数据字典型
function BodyLoadHandler(){

	  var but=Ext.getCmp("butSave");
    but.on('click',Save);
	  var dep = Ext.getCmp("PatLoc");
	  if (Prnloctype=="L")
	  {
	  cspRunServerMethod(gettranloc,'addloc',EpisodeID);
	  }
	  if (Prnloctype=="W")
	  {
	  	 cspRunServerMethod(gettranward,'addloc',EpisodeID);
	  }
		dep.store.loadData(locdata); 
		
	
    var bed = Ext.getCmp("BedCode");
	  cspRunServerMethod(gettranbed,'addbed',EpisodeID);
		bed.store.loadData(beddata); 
		//alert(Rowid)
			if ((Rowid.indexOf('^')==-1)&&(Rowid!=""))
			{
				var str=cspRunServerMethod(getlocbed,Rowid);
				var tt=str.split('^')
				//alert(tt)
			  if (Prnloctype=="W")
	      {
				   dep.setValue(tt[2]);
				   bed.setValue(tt[1]);
				}
				 if (Prnloctype=="L")
	      {
				   dep.setValue(tt[0]);
				   bed.setValue(tt[1]);
				}
				
			}
}
function find() {
	  if(Rowid!="") 
	  { 
	  	var str=cspRunServerMethod(getVal,Rowid);
	  	var  tem=str.split("^");
	  	var dep=Ext.getCmp("PatLoc"); 
	  	var bed = Ext.getCmp("BedCode"); 
	  	dep.setValue(tem[0]);
      bed.setValue(tem[1]);
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
				//getPatInfo();
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
 	//getPatInfo();
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
	//alert(111)
  ret="";
  checkret="";
  comboret="";
  var SaveRec=document.getElementById('SaveChange');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  var dep =""
	var bed = Ext.getCmp("BedCode").value;
	//alert(Rowid+"^"+dep+"^"+bed)
	var nurseloc=""
 if (Prnloctype=="L") //病人科室
 {
	  dep = Ext.getCmp("PatLoc").value;
 }
 if (Prnloctype=="W") //护士科室
 {
	  nurseloc = Ext.getCmp("PatLoc").value;
 }
 if(Rowid!=""){
 var Id=cspRunServerMethod(SaveRec.value,Rowid,dep,bed,nurseloc);
 if(Id=="0") 
 {
 	      Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '保存成功! 您要关闭该页面吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	            window.close();  //关闭子窗口  
	            //window.opener.find();
	            
	            }
					        else
	            {   
	            	//setvalue()  
	            		}
	            
	        },    
	       animEl: 'newbutton'   
	       });
 	//alert("已保存");
}
 }
 //find();

}
function getPatInfo()
{
	  //return ;
	  var PatInfo=document.getElementById('PatInfo');
	  if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
		//alert(ret);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item4");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item5");
	 	sex.setValue(getValueByCode(tt[3]));
	 //	var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[7]));
	 	var age = Ext.getCmp("Item6");
	 	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item7");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item8");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var diag = Ext.getCmp("Item10");
	 	diag.setValue(getValueByCode(tt[8])); 
	 //	var TEL= Ext.getCmp("Item9");
	 //	TEL.setValue(getValueByCode(tt[3]));
	 	//var admdate = Ext.getCmp("Item10");
	 	//admdate.setValue(getValueByCode(tt[6]));
	 	//var admtime = Ext.getCmp("Item11");
	 	//admtime.setValue(getValueByCode(tt[15]));
	
	 	//var MedCareNo = Ext.getCmp("Item9");
	 	//MedCareNo.setValue(getValueByCode(tt[9]));
	 	var reasonobj=Ext.getCmp("Item1");
	 	if(reasonobj.getValue()=="") reasonobj.setValue("   患者因");
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
			PrintComm.WebUrl=WebIp+"/trakcarelive/trak/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNurMoudPrn_nmyczqtzs";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURSZZY_NMYCZQTYS";
			PrintComm.MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
}
