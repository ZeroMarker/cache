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
     // item.on('check',checksj);
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}  
function eachItem11(item,index,length) {   
 if (item.xtype == "checkbox") {
 	item.on('check',function(obj, ischecked){checksj(obj)} );
 	
 }

	   if (item.items && item.items.getCount() > 0) { 
	      
       item.items.each(eachItem11, this);   
    }   
    
}    
function eachItemcheck(item,index,length) {   
     	if (item.xtype=="checkbox") {   
 			if (item.id.indexOf("_")!=-1)
			{
				var aa=item.id.split("_");
				var bb=checkItem.split("_");
				if (aa[0]==bb[0])
				{
					//alert(item.id+"|"+checkItem);
					if (item.id!=checkItem) 
					{
						checkret=checkret+item.id+"^";
						//checkflag="true";
					}
				}

			}
        } 

	   if (item.items && item.items.getCount() > 0) { 
	      
       item.items.each(eachItemcheck, this);   
    }       
}  
var checkItem=""; 
var checkflag="true";
function checksj(item)
{  if (checkflag=="false") return;  
   checkret="";
   checkItem=item.id;    
   if (item.check=true)
   {  
   	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItemcheck, this);     
	   checkflag="false";	 
	   var aa=checkret.split("^");
	 for (var i=0;i<aa.length;i++)
	 {
	 	if (aa[i]=="")continue;
		var ch=Ext.getCmp(aa[i]);
		ch.setValue(false);
	 }
	  checkflag="true"; 
   }
   totelmouth();    
}  
function totelmouth()
{
  ret="";
  sum="";
  checkret="";
  comboret="";
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  var a1=checkret.split('^');
  var arrayObj = new Array();
  var array1=new Array();		
 for(i=0;i<a1.length-1;i++)
 {
  var a2=a1[i].split('_');
  var a3=a2[1];
  var a7=a2[0];
  var a4=a3.split('|');
  var a5=parseFloat(a4[0]);
  arrayObj[i]=a5;
  sum+=a5+","+a7+"^";
  }
  var getzf =document.getElementById('getzf');
  ret=cspRunServerMethod(getzf.value,sum);
  a=ret.split('^');
  zongf=a[0];
  fenj=a[1];
  var zf= Ext.getCmp("Item12");
	zf.setValue(getValueByCode(zongf));
  var fj= Ext.getCmp("Item13");
	fj.setValue(getValueByCode(fenj));
	var getuser=document.getElementById('getuser'); 
	var user=cspRunServerMethod(getuser.value,session['LOGON.USERID']); 
	var tt5=user.split('^');
	var qianm= Ext.getCmp("Item14");
	qianm.setValue(getValueByCode(tt5[0]));
	 	
	  

}
var ITypItm="Item51"; //后取数据字典型
function BodyLoadHandler(){
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
    //alert(1);
	var but=Ext.getCmp("butprint");
   but.on('click',butPrintFn);
	var gform=Ext.getCmp("gform");
 gform.items.each(eachItem11, this);
	var butChk1=Ext.getCmp("Item1")
	
	//alert(butChk1);
	butChk1.on("check",sjj)
	setvalue()
	var but15=Ext.getCmp("Item15")
	but15.disable()
	var but15=Ext.getCmp("Item16")
	but15.disable()
	var but15=Ext.getCmp("Item17")
	but15.disable()
	var but15=Ext.getCmp("Item18")
	but15.disable()
	var but15=Ext.getCmp("Item19")
	but15.disable()
	
}
function  sjj()
{}
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
   //alert(NurRecId);

 if(NurRecId!="")
   {
   
   //alert(ExamId);
   var ha = new Hashtable();
  // var getid=document.getElementById('GetId');
  // var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //EpisodeID_"^"_NurRecId;
   //alert(NurRecId);
   if (NurRecId != "") {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, NurRecId);
   	var tm = ret.split('^')
		sethashvalue(ha, tm);
			getPatInfo();	 
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
			
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));			
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
   else
   {
   getPatInfo();	
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
function ifsave()
{
}
var flag9="";
function Save()
{
  ret="";
  checkret="";
  comboret="";
  var SaveRec=document.getElementById('Save');
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  //alert(EmrCode)
 // alert(EpisodeID);
 ret+"&"+checkret+"&"+comboret;
  //alert(checkret);
  //alert(ret);
 // alert(comboret);
 var stid=NurRecId
 if(NurRecId!="")
 {
   var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,NurRecId);
 }
 else
 {
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 //alert(Id)
   if (Id!="") 
   {
     NurRecId=Id
   }
 }
 if (stid=="")
{
	window.opener.reloadtree();
}
 var flag9=1;
 if (Id!="")
 {
	 checkprn();
     tt=ret.split('^');
     tx=tt[1].split(';');
     ty=tt[0];
     rq=tt[2];
	 var flag = confirm("保存成功! 您要打印吗？")
	 if (flag) 
	 { 	             
     //alert(rq);
     if(!rq!="")
     {alert("未填写\“日期”\"");}
     if(ty!="")
     {
     alert("未置\“评分时间\”");
     }
     if(tx[0]!=""){
     alert("以下项未评分：\“"+tx+"\”");
     }
	 window.opener.find();
     if((!tx[0]!="")&&(!ty!="")&&(rq!=""))
     {  
      //Save();
		var WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
	
		var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
		if(NurRecId!=="") GetPGDId=NurRecId;
		var parr="@"+EpisodeID+"@"+EmrCode;
		var EmrType=3;  //1:混合单 2：记录单 3：评估单
		//var MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
		var ch1=NurRecId.split("||")[0];
		var ch2=NurRecId.split("||")[1];
		var subid=ch1+"_"+ch2;
		var MthArr="Nur.DHCMoudDataSub:getVal1$parr:"+subid+"!flag:";
		//alert(MthArr)
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+"DHCNURMouldPFBPrn"+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
		window.location.href=link;	
		//window.close();  //关闭子窗口  
	    //window.opener.find();
      }	           	            
	  }
	  else
	  {    
	     if(!rq!="")
         {
				alert("未填写\“日期”\"");
				return;
	     }
         if(ty!="")
         {
           alert("未置\“评分时间\”");
		   return;
         }
         if(tx[0]!=""){
           alert("以下项未评分：\“"+tx+"\”");
		   return;
         }      
	     window.close();  //关闭子窗口  
	     window.opener.find();  
	            
	  }  
	     
 
 
 }
 
 //alert("保存成功");
 //window.opener.find();
 //window.close();
 
}

function getPatInfo()
{   //alert(EpisodeID);
	  //return ;
	  
	  var PatInfo=document.getElementById('PatInfo');
	  if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
		//alert(ret);
	 	var tt=ret.split('^');
	 	var patName = Ext.getCmp("Item16");
	 	patName.setValue(getValueByCode(tt[4]));
	 	var sex = Ext.getCmp("Item17");
	 	sex.setValue(getValueByCode(tt[3]));
	 	//var  regno= Ext.getCmp("Item5");
	 	//regno.setValue(getValueByCode(tt[0]));
	 //	var age = Ext.getCmp("Item2");
	 //	age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item15");
	 	patLoc.setValue(getValueByCode(tt[1]));
	 	var bedCode = Ext.getCmp("Item18");
	 	bedCode.setValue(getValueByCode(tt[5]));
	 	var MedCareNo = Ext.getCmp("Item19");
	 	//alert(MedCareNo);
	 	MedCareNo.setValue(getValueByCode(tt[9]));
	 //	var diag = Ext.getCmp("Item13");
	 //	diag.setValue(getValueByCode(tt[8]));
 
	 	//var admdate = Ext.getCmp("Item9");
	 	//admdate.setValue(getValueByCode(tt[10]));
	 	//var admtime = Ext.getCmp("Item10");
	 	//admtime.setValue(getValueByCode(tt[11]));
	 	
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
     checkprn();
     tt=ret.split('^');
     tx=tt[1].split(';');
     ty=tt[0];
     rq=tt[2];
     //alert(rq);
     if(!rq!="")
     {alert("未填写\“日期”\"");}
     if(ty!="")
     {
     alert("未置\“评分时间\”");
     }
     if(tx[0]!=""){
     alert("以下项未评分：\“"+tx+"\”");
     }
     if((!tx[0]!="")&&(!ty!="")&&(rq!=""))
     {  
		var WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeTemp",EmrCode,"N");
		//是否生成图片 Y 生成，N 不生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakePic",EmrCode,"N");
		//是否开始生成图片
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","StartMakePic",EmrCode,"N");
		//生成的图片是否上传ftp
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","IfUpload",EmrCode,"N");
		//是否生成所有页 ，默认是否(从原来最后一页开始生成)；"Y"--从第一页开始生成
		tkMakeServerCall("NurEmr.DHCNurEmrPrintComm","SetEmrTempGlobal","MakeAllPages",EmrCode,"N");
	
		var GetPGDId=tkMakeServerCall("Nur.DHCMoudData","GetId",EmrCode,EpisodeID);
		if(NurRecId!=="") GetPGDId=NurRecId;
		var parr="@"+EpisodeID+"@"+EmrCode;
		var EmrType=3;  //1:混合单 2：记录单 3：评估单
		//var MthArr="web.DHCNurMouldDataComm:GetPrnValComm&parr:"+parr;
		var ch1=NurRecId.split("||")[0];
		var ch2=NurRecId.split("||")[1];
		var subid=ch1+"_"+ch2;
		var MthArr="Nur.DHCMoudDataSub:getVal1$parr:"+subid+"!flag:";
		//alert(MthArr)
		var link=WebIp+"/dhcmg/PrintComm/PrintCommPic.application?method=PrintOut&EpisodeID="+EpisodeID+"&EmrCode="+EmrCode+"&EmrType="+EmrType+"&ItmName="+"DHCNURMouldPFBPrn"+"&MthArr="+MthArr+"&WebUrl="+WebUrl;
		window.location.href=link;	
      }
      }
function checkprn()
{ ret="";
  sum="";
  checkret="";
  comboret="";
  var gform=Ext.getCmp("gform");
  gform.items.each(eachItem1, this);  
  var a1=checkret.split('^');
  var a2=ret.split('^');
  var a3=a2[0].split('|');
  //alert(a3);
  var arrayObj = new Array();
 for(i=0;i<a1.length-1;i++)
 {
  var a2=a1[i].split('_');
  var a7=a2[0];
  sum+=a7+"^";
  }
  sum=sum+"*"+a3;
  var checkprn=document.getElementById('checkprn');
  ret=cspRunServerMethod(checkprn.value,sum);
  //alert(ret);
  return ret;
}

