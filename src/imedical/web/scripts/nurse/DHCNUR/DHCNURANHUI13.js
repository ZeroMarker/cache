/**
 * @author Administrator
 */
var grid;

var arrgrid = new Array(); 

//var ITypItm="Item4"; //后取数据字典型

function BodyLoadHandler() {
		setsize("mygridpl", "gform", "mygrid");
		 //fm.doLayout();
		//but.hide();
		grid = Ext.getCmp('mygrid');
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
    //alert(11);
    //alert(13); 
   //var but=Ext.getCmp("mygridbut2");
   //but.setText("保存");
   //but.on('click',gridsave); 
    //Ext.destroy(this.mygridbut1,
    //            this.mygridbut2); 
    var but1=Ext.getCmp("mygridbut1"); 
 		but1.destroy(); 
    var but2=Ext.getCmp("mygridbut2"); 
 		but2.destroy();

 		tobar.addButton({
			className : 'new-topic-button',
			text : "新建",
			handler : additm,
			id : 'mygridadd'
		});
    tobar.addItem("-");  
		tobar.addButton({
			className : 'new-topic-button',
			text : "保存",
			handler : gridsave,
			id : 'mygridSave'
		});
  tobar.addItem("-");   
   tobar.addButton({
		 xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录'
		});
		   tobar.addItem("-");  
tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:setgrid,
		id:'mygridSch'
	  }

	); 
   tobar.addItem("-");   
   tobar.addButton({
			className : 'new-topic-button',
			text : "打印",
			handler : butPrintFn, //typprint,
			id : 'mygridPrint'
		});

		// tobar.render(grid.tbar);
	tobar.doLayout(); 
	layoutset();
	grid.addListener('rowcontextmenu', rightClickFn);
		//alert(14);
	//var but1=Ext.getCmp("mygridbut1"); 
	//but1.on('click',additm);
	//var but = Ext.getCmp("mygridbut2");
	//but.setText("保存");
	 

  //var Item2 = Ext.getCmp("Item4");
	//Item2.on('specialkey',cmbkey);
		
  setgrid();
}  

var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [ {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
            }]
        });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }

function CancelRecord()
{
	if((session['LOGON.GROUPDESC']=="护理部主任") ||(session['LOGON.GROUPDESC']=="科护士长")||(session['LOGON.USERNAME']=="於琴"))
	{	 
	var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	else
	{
		Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '你确定要作废此条护理记录吗?',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){    
					var par=objRow[0].get("par");
					var rw=objRow[0].get("rw");
					//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
					if (objCancelRecord) {
						var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
						if (a!=0){
							alert(a);
							return;
						}else{
							//find();
							setgrid();
						}
					}
	            }    
	        },    
	       animEl: 'newbutton'   
	    });
	} 
  }
  else
  {
   		Ext.Msg.alert('提示', "您的权限不允许执行此项操作!");
   		return;
  }
 }

function layoutset()
{
	var GetLayoutItem=document.getElementById('GetLayoutItem');
	var ret=cspRunServerMethod(GetLayoutItem.value,session['LOGON.GROUPID'] ,EmrCode);
	var arr=ret.split("^");
 	for (var i=0;i<arr.length;i++)
	{
		var itm=arr[i];
		if (itm=="") continue;
		var itmarr=itm.split("|");
 		var com=Ext.getCmp(itmarr[0]);
		com.disable();
	}
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


function additm()
{
	  if((session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="科护士长")||(session['LOGON.USERNAME']=="於琴"))
	  {	  
	  var grid=Ext.getCmp('mygrid');
   	var Plant = Ext.data.Record.create([
            	{name:'CareDate'},
            	{name:'CareTime'},
              {name:'Item1'},
              {name:'Item2'},
              {name:'Item3'},
              {name:'User'}
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"

      ]);
   	            var count = grid.store.getCount(); 
                var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return; 
      }
      else
      {
       		Ext.Msg.alert('提示', "您的权限不允许执行此项操作!");
      		return;
       }

}
   
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}

  
function gridsave() 
{
	if((session['LOGON.GROUPDESC']=="护理部主任") ||(session['LOGON.GROUPDESC']=="科护士长")||(session['LOGON.USERNAME']=="於琴"))
	{	 
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
 
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0;r < len; r++) 
	{
		list.push(rowObj[r].data);
	}	
	var grid1=Ext.getCmp('mygrid');
  var rwIndex=grid1.getSelectionModel().last;
 
  var RecSave=document.getElementById('RecSave');
 
   for (var i = 0; i < list.length; i++) 
   {
 
  	var obj=list[i];
   	var str="";
    var CareDate=""; 
    var CareTime="";

 
    for (var p in obj) 
    {
 
    	 var aa = formatDate(obj[p]); 
    	 if (p=="CareDate") CareDate=aa; 
    	 if (p=='CareTime') CareTime=obj[p];
       if (p=="") continue;
 
       if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			} 
      }

  
    }  
   //alert(str);
   var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURANHUI13",session['LOGON.GROUPDESC']);
	 alert("保存成功");	
	if (a!="0")
	{
				alert(a);
				return;
	}
		setgrid(); 
	}
	else
	{
 		Ext.Msg.alert('提示', "您的权限不允许执行此项操作!");
 		return;
 	}
}

function setgrid()
{	
  var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array(); 
	var GetAdmDate =document.getElementById('GetAdmDate');
	//debugger;
  var StDate=cspRunServerMethod(GetAdmDate.value,EpisodeID);
  //alert(StDate);
  var adm = EpisodeID; 
  var now=new Date();
	var nowMonth=now.getMonth()+1;
	var nowMDate=now.getDate();
  var Enddate=now.getYear()+"-"+nowMonth+"-"+nowMDate;
  var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
  //alert(Enddate); 
  //alert(adm);  
  var parr = adm + "^" +StDate + "^" + "00:00"+ "^" + Enddate + "^" + "23:59" + "^"+"DHCNURANHUI13" + "^" + IfCancelRec;
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurItemCode:CRItem", "parr$" +session['LOGON.CTLOCID'], "AddRec");
   grid.store.loadData(arrgrid);   
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str);	
	var obj = eval('(' + str + ')'); 
	obj.CareDate=getDate(obj.CareDate);
	arrgrid.push(obj);
	//debugger;
} 

function butPrintFn()
{ 
	  var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		//alert("ddd");
		//debugger;
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI13",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI13^"+session['LOGON.CTLOCID']);
		var tm=a.split("^");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//alert(ret);
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		//debugger;
		PrintComm.TitleStr=ret;
		//alert(PrintComm.TitleStr); 
		//alert(webIP+"/trakcare/web/DWR.DoctorRound.cls");

		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		var aa=tm[1].split("&");
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
	  PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
   	PrintComm.ItmName = "DHCNurPrnMouldANHUI14"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURANHUI13";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintCommnew.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:" 
		//alert(parr);
		PrintComm.PrintOut();
		var SavePrnSet=document.getElementById('SavePrnSet');
		//debugger;
		var CareDateTim=PrintComm.CareDateTim;
		if (CareDateTim=="") return ;
		var pages=PrintComm.pages;
		var stRow=PrintComm.stRow;
		//debugger;
		var stprintpos=PrintComm.stPrintPos;
		//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNURANHUI5"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);
		//PrnFlag==1说明是打印预览
		if (PrintComm.PrnFlag==1) return;
		//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
		if (pages<aa[0]) return;
		var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNURANHUI13",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user

	
}

function butPrintFn1()
{
	var GetPrnSet=document.getElementById('GetPrnSet');		
	//var GetHead=document.getElementById('GetPatInfo');		
	//var ret=cspRunServerMethod(GetHead.value,EpisodeID);		
	//var hh=ret.split("^");			
	//var getid=document.getElementById('GetId');        
	//var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID); 
	
	var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI13",EpisodeID); //page, caredattim, prnpos, adm,Typ,user 
	if (a=="") return;
	var GetLableRec=document.getElementById('GetLableRec'); 
	var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI13^"+session['LOGON.CTLOCID']);
	var tm=a.split("^");		
	var stdate="" //tm[2];		
	var stim="" //tm[3];		
	var edate="" //tm[4];		
	var etim="" //tm[5];
	PrintComm.TitleStr=ret;		
	PrintComm.SetPreView("1");		
	PrintComm.PrnLoc=session['LOGON.CTLOCID'];		
	var aa=tm[1].split("&"); 
	PrintComm.stPage=0;		
	PrintComm.stRow=0;		
	PrintComm.previewPrint="1"; //是否弹出设置界面 
	PrintComm.stprintpos=0; 
	PrintComm.SetConnectStr(CacheDB);
	//parent.opener.parent.frames["anopbottom"].PrintCareRecord(AnaesID);
	//opener.parent.frames["anopbottom"].PrintCareRecord(AnaesID);
	//window.parent.opener.parent.parent.PrintCareRecord();
	alert("开始调用");
	//debugger
	//alert(parent.opener.parent.parent.frames[0].name);
	alert(window.parent.opener.parent.frames.length);
	window.parent.opener.parent.frames[0].PrintCareRecord();
	//alert(window.parent.opener.parent.frames[0].document.getElementById("PrintComm"));
	//alert(window.parent.opener.parent.frames[0].document.getElementById("PrintComm"));
	//window.parent.opener.parent.frames[0].find();
	//var w=window.parent.opener.parent;
	//alert();
  //alert(w.frames["TRAK_main"].PrintCareRecord());
	//var w=window.parent.opener.parent.parent;
	//var len=w.frames.length;
	//for (i=0;i<len;i++)
	 //{
	 // alert(w.frames[i].name);
	 //}
}


  
function typprint() { 
	
	//var w=window.parent.opener.parent.parent;

	 //alert(w.frames.length);
	 //var len=w.frames.length;
	 //var PrintComm=w.frames["eprmenu"].document.getElementById("PrintComm");
	 //PrintComm.value="PrintComm.PrintCom"
	 //var PrintComm=document.getElementById("PrintComm");
	 //alert(PrintComm);
	// for (i=0;i<len;i++)
	// {
	//  alert(w.frames[i].name);
	// }

  /*	
	alert(1);
	alert(window.parent.parent.frames.length);
	 var len=window.parent.frames.length;
	 alert("len="+len);
	 for (i=0;i<len;i++)
	 {
	 	alert(window.parent.frames[i].name);
	 	}
	 return;*/
    //var stdate = Ext.getCmp("mygridstdate");
		//var enddate = Ext.getCmp("mygridenddate");
		//var AllFlag = Ext.getCmp("AllFlag").getValue();
    //PrintComm.RHeadCaption = tm[1];
    //PrintComm.LHeadCaption ="" //"科室: "+LogLoc+"     时间段: "+stdate.value+" 至 "+enddate.value;
    //PrintComm.LFootCaption = tm[2];
   	//var ret=cspRunServerMethod(GetHead.value,EpisodeID);
    //alert(ret);    
    /*PrintComm.SetPreView("1");
    PrintComm.stPage = 0;
    PrintComm.stRow = 0;
    PrintComm.previewPrint="0"; //是否弹出设置界面
    PrintComm.stprintpos = 0;
    PrintComm.SetConnectStr(CacheDB);
    PrintComm.ItmName = "DHCNurPrnMouldANHUI14";
    PrintComm.ID = "";
    PrintComm.MultID = "";
    PrintComm.MthArr = "";
		//alert("EpisodeID="+EpisodeID+" stdate="+stdate.value+" enddate="+enddate.value+" AllFlag="+AllFlag);
		var parr=EpisodeID+"!"+""+"!"+""+"!"+""+"!"+""+"!DHCNURANHUI13";
    PrintComm.SetParrm(parr);
    PrintComm.PrintOut();  */

    
    
    var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		alert("ddd");
		//debugger;
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI13",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI13^"+session['LOGON.CTLOCID']);
		var tm=a.split("^");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		alert(ret);
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		debugger;
		PrintComm.TitleStr=ret;
		alert(PrintComm.TitleStr);
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		var aa=tm[1].split("&");
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB);
   	PrintComm.ItmName = "DHCNurPrnMouldANHUI14"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURANHUI13";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintComm.LabHead=LabHead;
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:" 
		//alert(parr);
		PrintComm.PrintOut();
		var SavePrnSet=document.getElementById('SavePrnSet');
		//debugger;
		var CareDateTim=PrintComm.CareDateTim;
		if (CareDateTim=="") return ;
		var pages=PrintComm.pages;
		var stRow=PrintComm.stRow;
		//debugger;
		var stprintpos=PrintComm.stPrintPos;
		//alert(pages+","+CareDateTim+","+stprintpos+","+EpisodeID+","+"DHCNURANHUI5"+","+session['LOGON.USERID']+","+PrintComm.PrnFlag);
		//PrnFlag==1说明是打印预览
		if (PrintComm.PrnFlag==1) return;
		//如果原记录保存打印到第8页则当打印第8页之前页时不保存打印记录
		if (pages<aa[0]) return;
		var a=cspRunServerMethod(SavePrnSet.value,pages,CareDateTim,stprintpos,EpisodeID,"DHCNURANHUI13",session['LOGON.USERID']); //page, caredattim, prnpos, adm,Typ,user
    
 }
 
 function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
 
	 var list = [];
 
	 var rw=""
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
for (var r = 0;r < len; r++) 
{
			list.push(rowObj[r].data);
}
 
for (var i = 0; i < list.length; i++) 
{
			  var obj=list[i];
 
			  rw=obj["rw"];
}
 

if (rw==undefined) 
	{
		Ext.Msg.alert('提示', "请先选择有效行!");
		return;
	};
  
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete)
	{
		var ee = cspRunServerMethod(QtDelete.value, rw);
		if (ee != "0") {
			alert(ee);
			return;
		}
 	}
	clearscreen();
	setgrid();
}
 

function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
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