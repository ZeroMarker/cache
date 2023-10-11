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
			if (item.checked==true)
			{
				 checkret=checkret+item.id+"|"+item.boxLabel+"^"; 
				}
			else
				{
			
					checkret=checkret+item.id+"|^";
				}
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}   
function BsKeyDown(e) //获取enter键盘事件响应
 {
      if(document.all)
      {
       var iekey=window.event.keyCode;
       if(iekey==13)
          {   
           if(event.srcElement.id=="Item104")
             {
             document.getElementById("Item104").value=session['LOGON.USERNAME'];
             }  
             if(event.srcElement.id=="Item105")
             {
             document.getElementById("Item105").value=session['LOGON.USERNAME'];
             }    
             if(event.srcElement.id=="Item106")
             {
             document.getElementById("Item106").value=session['LOGON.USERNAME'];
             }        
          }
       
       }
}

var ITypItm=""; //后取数据字典型
  var StartLock="0" //续打全院开关：1:启用续打，0:不启用续打
  var IfMakePic=""  //是否生成图片
  var WillUpload=""   //是否上传ftp
  var prnmode=tkMakeServerCall("User.DHCNURMoudelLink","getPrintCode",EmrCode) //根据界面模板获取打印模板
  var prnmcodes=""
  if (prnmode!="")
  {
    var prnarr=prnmode.split('|')
    prnmcodes=prnarr[0]
    IfMakePic=prnarr[3]  //是否生成图片
    WillUpload=prnarr[4]   //是否上传ftp
    if (prnarr[2]=="Y") //启用续打
    {
      StartLock="1"
    }
    else
    {
      StartLock="0"
    }
  }
  if ((StartLock=="1")&&(prnmode==""))
  {
    alert("请关联界面模板和打印模板!")
    StartLock="0" //关闭续打
  }
  var printcolor='#C9C9C9';     //已打印颜色
  var havechangecolor='#FF8247' //有修改颜色
  var noprintcolor='#FFFFF0';   //未打印颜色
  var Startcolor='#1E90FF';     //从该条开始打印的颜色
  var prncode=prnmcodes //打印模板名称
  var Startloc="" //启用续打的科室科室（前提必须是StartLock=1）

function BodyLoadHandler(){

/*
var Item154=Ext.getCmp("Item154");
     Item154.setValue(session['LOGON.USERNAME']);
	 var Item162=Ext.getCmp("Item162");
     Item162.setValue(session['LOGON.USERNAME']);
	 var Item163=Ext.getCmp("Item163");
     Item163.setValue(session['LOGON.USERNAME']);
	 var Item155=Ext.getCmp("Item155");
     if (Item155.getValue()=="") Item155.setValue(new Date());
	 var Item160=Ext.getCmp("Item160");
     if (Item160.getValue()=="") Item160.setValue(new Date());
	 var Item161=Ext.getCmp("Item161");
     if (Item161.getValue()=="") Item161.setValue(new Date());
*/
	//var but=Ext.getCmp("butClose");
   // but.on('click',btclose);
	var but=Ext.getCmp("butSave");
    but.on('click',Save);
	var but=Ext.getCmp("butPrint");
    but.on('click',butPrintFn);
	but.hide();
	document.onkeydown=BsKeyDown;	
	setvalue();
	 var patName = Ext.getCmp("Item56");
	 var sex = Ext.getCmp("Item57");
	 var age = Ext.getCmp("Item58");
	 var patLoc = Ext.getCmp("Item59");
	 var patBed = Ext.getCmp("Item60");
	 var AdmDate = Ext.getCmp("Item61");	 
	 //自动算分1 
	 var retstr1=GetItems(64,80,1);
	 var objstr1=retstr1.split("@")[0];
	 var valuestr1=retstr1.split("@")[1];
	 
	 var retstr2=GetItems(84,91,2);
	 var objstr2=retstr2.split("@")[0];
	 var valuestr2=retstr2.split("@")[1];
	 
	 var retstr3=GetItems(92,101,3);
	 var objstr3=retstr3.split("@")[0];
	 var valuestr3=retstr3.split("@")[1];
	 
	 var retstr4=GetItems(102,106,5);
	 var objstr4=retstr4.split("@")[0];
	 var valuestr4=retstr4.split("@")[1];
	 var objstr=objstr1+"^"+objstr2+"^"+objstr3+"^"+objstr4;
	 var valuestr=valuestr1+"^"+valuestr2+"^"+valuestr3+"^"+valuestr4;
	 SetListeners(objstr,valuestr,"Item63");
	 
	
}
//自动算分
function GetItems(start,end,value)
{
	var ItemStr="";
	var ValueStr="";
	for(var i=start;i<=end;i++)
	{
		if(ItemStr=="") ItemStr="Item"+i;
		else ItemStr=ItemStr+"^"+"Item"+i;
	}
	for(var i=start;i<=end;i++)
	{
		if(ValueStr=="") ValueStr=value;
		else ValueStr=ValueStr+"^"+value;
	}
	return ItemStr+"@"+ValueStr;
}
function SetListeners(objstr,valuestr,sumobj)

{ 

	var objArr=objstr.split("^");
	var len=objArr.length;
	for(var i=0;i<len;i++)
	{
		Ext.getCmp(objArr[i]).on('change',function(){
				CountScore(objstr,valuestr,sumobj);
		});
	}
	 
	
}
function CountScore(objstr,valuestr,sumobj)
{
	var sum=0;
	var objArr=objstr.split("^");
	var len=objArr.length;
	for(var i=0;i<len;i++)
	{
		var score=Ext.getCmp(objArr[i]).getValue();
		if(score=="") score=0;
		else score=parseInt(valuestr.split("^")[i]);
		sum=sum+score;
	}
	//alert(sumobj)
	var totalobj=Ext.getCmp(sumobj);
	totalobj.setValue(sum);
	 if(sumobj=="Item63"){
	   scoreAdd()
  }
}
 
 
 
  function scoreAdd(obj){
	  
     var Item155=Ext.getCmp("Item155")
     var Item154=Ext.getCmp("Item154")
     if (Item155.getValue()=="") Item155.setValue(new Date())
     Item154.setValue(session['LOGON.USERNAME'])

     if (Item109=="") Item109=0;
     totel=parseInt(Item109);
     var amtsum = Ext.getCmp("Item63"); 	//总分元素
     amtsum.setValue(totel); 
    
} 
function eachItem11(item,index,length) {   
 if (item.xtype == "datafield") {
 	item.on('OnFieldChanged',function(obj, ischecked){checksj(obj)} );
 	
 }

 if (item.items && item.items.getCount() > 0) { 
	      
       item.items.each(eachItem11, this);   
    }   
    
}    
function checksj(item){
	  var str=document.getElementById("Item8").value;
	  var str1=document.getElementById("Item10").value;
     var manydate = document.getElementById('getdate');
   	 var ret = cspRunServerMethod(manydate.value,str+"@"+str1);
   	 document.getElementById("Item9").value=ret;
   	
  
}

function layoutset()
{
	var GetLayoutItem=document.getElementById('GetLayoutItem');
	//alert(GetLayoutItem);
	var ret=cspRunServerMethod(GetLayoutItem.value,session['LOGON.GROUPID'] ,EmrCode);
	var arr=ret.split("^");
	for (var i=0;i<arr.length;i++)
	{
		var itm=arr[i];
		alert(itm);
		if (itm=="") continue;
		var itmarr=itm.split("|");
		var com=Ext.getCmp(itmarr[0]);
		//com.disable();
	}
}
function  setvtf(item,test){ //设置控件显示
var testzsw=Ext.getCmp(test);
         if(item.checked==true)
           {
	         testzsw.setVisible(true);
	         }
	       else
	         {
	       document.getElementById(test).value="";
	         testzsw.setVisible(false);
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
function checksj1(item)
{  
   if (checkflag=="false") return;  
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
    
     
} 
//***********************************************************************************out

function setVal2(itm,val)
{
	    if (val=="") return ;
	   	var tt=val.split('!');
		alert(tt);
	 	var cm=Ext.getCmp(itm);
		person=new Array();
		addperson(tt[1],tt[0]);
		cm.store.loadData(person);
		cm.setValue(tt[0]);
		 
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
		alert(pp)
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
	
   var ha = new Hashtable();
  // var getid=document.getElementById('GetId');
   //var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(NurRecId)
   if (NurRecId!="")
   {
   	 var getVal=document.getElementById('getVal');
	 var ret=cspRunServerMethod(getVal.value,NurRecId);
     var tm=ret.split('^')
	//alert(ret)
	 sethashvalue(ha,tm)

   }
 	 else {
 	 	getPatInfo();	
 	 }
	
  
    
	 var gform=Ext.getCmp("gform");
     gform.items.each(eachItem, this);  
	
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
	
		if (key.indexOf("_") == -1) 
		{
		
			var flag=ifflag(key );
			if (flag==true)
			{
				setVal2(key ,ha.items(key));
		
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
function Save()
{
   ret="";
  checkret="";
  comboret="";
  var getid=document.getElementById("GetId");
   //alert(getid);
  // var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id);
  var SaveRec=document.getElementById("Save");
  var gform=Ext.getCmp("gform");
   gform.items.each(eachItem1, this);  
  //alert(EmrCode)
  ret+"&"+checkret+"&"+comboret;
 //alert(checkret);
 // alert(ret);
  //alert(comboret);
  //alert(NurRecId)
  if (NurRecId!=""){
 var Id=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,NurRecId);
 }
else
	{
		NurRecId=cspRunServerMethod(SaveRec.value,"^EmrUser|"+session['LOGON.USERID']+"^EmrCode|"+EmrCode+"^"+ret+"^DetLocDr|"+session['LOGON.CTLOCID']+"^EpisodeId|"+EpisodeID+"&"+checkret+"&"+comboret,"");
 
		}
   //alert(Id)
		if (Id!=="")
		{
	alert("已保存");
}
else {alert("保存失败");
	}

	//alert(NurRecId);
	if (IfMakePic=="Y")
	{
	  MakePicture()
  }
 //setvalue();
 //
window.close();
window.opener.find();


}
  //生成图片
   function MakePicture()
   {
		  PrintCommPic.StartMakePic="Y"  //图片
		  //以下4句请参考butPrintFn方法
			PrintCommPic.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
			PrintCommPic.ItmName = "DHCNURPRNTCFFYC";
			PrintCommPic.MthArr="Nur.DHCMoudData:getVal&parr:"+NurRecId+"!";
			PrintCommPic.PrintOut();	
			
		  PrintCommPic.NurRecId=NurRecId   //图 片
		  PrintCommPic.EmrCode=EmrCode     //图片
		  PrintCommPic.EpisodeID=EpisodeID //图片
		  PrintCommPic.curPages=0;         //图片
		  PrintCommPic.MakeTemp="Y";       //图片
		  PrintCommPic.filepath=WebIp+"/DHCMG/HLBLMakePictureSet.xml"		//图片
		  //PrintComm.MakeAllPages="Y";    //图片
		  PrintCommPic.MakePicture();      //图片
  }
function getPatInfo()
{
	var PatInfo=document.getElementById('PatInfo');
	if (PatInfo) {
		var ret=cspRunServerMethod(PatInfo.value,EpisodeID);
	 	var tt=ret.split('^');
	    //alert(tt)
		//var regno = Ext.getCmp("Item104");
	 	//regno.setValue(getValueByCode(tt[0]));
	 	var patName = Ext.getCmp("Item56");
	 	patName.setValue(getValueByCode(tt[4]));
		var sex = Ext.getCmp("Item57");
	 	sex.setValue(getValueByCode(tt[3]));
	 	//var DisDate = Ext.getCmp("Item7");
	 	//DisDate.setValue(getValueByCode(tt[16]));
		//var diag = Ext.getCmp("Item5");
	 	//diag.setValue(getValueByCode(tt[8]));
		var age = Ext.getCmp("Item58");
		age.setValue(getValueByCode(tt[6]));
	 	var patLoc = Ext.getCmp("Item59");
	 	patLoc.setValue(getValueByCode(tt[1]));
		var patBed = Ext.getCmp("Item60");
	 	patBed.setValue(getValueByCode(tt[5]));
		var MedCareNo = Ext.getCmp("Item61");
	 	MedCareNo.setValue(getValueByCode(tt[9]));
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
					//alert(CacheDB)

			//PrintComm.SetConnectStr(CacheDB);
	
			PrintComm.WebUrl=WebIp+"/imedical/web/DWR.DoctorRound.cls";
			PrintComm.ItmName = "DHCNURPRNTCFFYC";
			//debugger;
			//var parr="@"+EpisodeID+"@DHCNURHYD_Assessment@DHCNURHYD_DisSummary";
			var parr="@"+EpisodeID+"@DHCNURPGD_XSFXYS";
			var ch1=NurRecId.split("||")[0];
			var ch2=NurRecId.split("||")[1];
			var subid=ch1+"_"+ch2;
			//alert(subid)
			PrintComm.MthArr="Nur.DHCMoudDataSub:getVal1&parr:"+subid+"!flag:";
			//PrintComm.LabHead=LabHead;			
			//PrintComm.SetParrm(parr);
			PrintComm.PrintOut();
			
			
			
		
      }
