
var FocusRowIndex=0;
var CurrentRow=0;
function BodyLoadHandler(e)
{	
	var obj;
	
 obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClick;
	obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClick;
	obj=document.getElementById("DeleteDetail");
	if (obj) obj.onclick=DeleteClick;
	
	var objtbl=document.getElementById("tdhcpha_callbackitm");
 if (objtbl)
 {
	 objtbl.onkeydown=CheckDispLoc;
		
		var rows=objtbl.rows.length;
		var Row=rows-1;
		var objlastrow=objtbl.rows[Row];
  
		var InciRowid=GetColumnData("TInciRowid",Row);
	
		if (InciRowid=="")
		{
			ChangeRowStyle(objlastrow);
			SetFocusColumn("TInci",Row);
			FocusRowIndex=1;
		}
 }


 if (FocusRowIndex!=1){websys_setfocus('Add')};
	
	SetAuthority();
	//alert(parent.document.activeElement.name);
	//





}
function CheckDispLoc()
{
	if (FocusRowIndex==1)
	{
				var obj=document.getElementById("displocid");
				if (obj.value=="")
				{alert(t['NO_DISPLOC']) ;
					return false ;
				 }
	}
	return true
}
function AddClick() 
{
 var obj=document.getElementById("Add" )
 if (obj.disabled==true)   return ;
  	
	try {
			var objtbl=document.getElementById('tdhcpha_callbackitm');
			
			var ret=CanAddRow(objtbl);
		
			if (ret){
	    		AddRowToList(objtbl);
	  		}
    		//可以控制屏幕不跳动
    		return false;
	} catch(e) {};
}

function SaveClick()
{
	
 var obj=document.getElementById("Save" )
 if (obj.disabled==true)   return ;

	
	if (CheckDataBeforeSave()==false) return;
	
	var ret=SaveData();

	if(ret!="")
	{ 
		var arr=ret.split("^");
		var dhcphac=arr[0];
		var no=arr[1];
	}

	if(dhcphac!="")
	{
		alert(t['SAVE_SUCCESS']);
		//ReloadMainWindow()
		//
		//var obj=document.getElementById("dhcpcdr")
		//if (obj)
		//{
		//	if (obj.value="") obj.value=dhcphac
		//	}
		//window.location.reload();
		//
		LoadAfterSaved(dhcphac)
	}
	else
	{
		alert(t['SAVE_FAILURE']);
	}
	 
 ReloadMainWindow()
	 
	 
}

function CheckDataBeforeSave()
{
	var pcmain=""
	var obj=document.getElementById("dhcpcdr")
	if (obj) pcmain=obj.value
	if (pcmain=="") {
				var docu=parent.frames['dhcpha.callbackmain'].window.document	
				var objward=docu.getElementById("wardid")
				if(objward) var warddr=objward.value;
				if(warddr=="")
				{
					alert(t['NO_ANY_WARD']);
					return false;	
				}
				
				var objloc=docu.getElementById("displocid")
				if(objloc) var disploc=objloc.value;
				if(disploc=="")
				{
					alert(t['NO_DISPLOC']);
					return false;	
				}
 }	
	var objtbl=document.getElementById("tdhcpha_callbackitm") ;
	if (objtbl) var Rows=objtbl.rows.length;
	if(Rows<=1)
	{
		alert(t['NO_DETAIL']);
		return false;
	}

 //check  the detail data 
 var cnt;
 var i; 
 cnt=getRowcount(objtbl)
 for (i=1;i<=cnt;i++)
 {
			 var inci=GetColumnData("TInciRowid",i)
			 if (inci=="")
			  { alert(t['INCI_NEEDED']) 
						return false;
			  }
				var qty=GetColumnData("TQty",i)
				if (qty=="")
				{ alert(t['QTY_NEEDED'])
				  selectRowHandler(window.event)
							return false;
				}
 }
	return true;
	
}

function SaveData()
{
	var dhcpcdr=""
	var obj=document.getElementById("dhcpcdr")
	if (obj) dhcpcdr=obj.value

	var disploc=""
	var warddr=""
	var strdata="";
	
 if (dhcpcdr=="")
 {
		var docu=parent.frames['dhcpha.callbackmain'].window.document	
		var objward=docu.getElementById("wardid")
		if(objward) warddr=objward.value;
		var objdisloc=docu.getElementById("displocid")
		if(objdisloc) disploc=objdisloc.value;
 }
	
 var userid=session['LOGON.USERID'];
	var objtbl=document.getElementById("tdhcpha_callbackitm") ;
	if (objtbl) var Rows=objtbl.rows.length;

	var Rows=getRowcount(objtbl)
	
	for(var i=1;i<=Rows;i++)
	{
		var incidr=GetColumnData("TInciRowid",i);
		var qty=GetColumnData("TQty",i);	
		var dhcpci=GetColumnData("TRowid",i);
		
		var xx=incidr+"^"+qty+"^"+dhcpci
		if (strdata==""){strdata=xx;}
		else{strdata=strdata+"&"+xx;}	
	}

	var objsave=document.getElementById("mSaveData");
	if (objsave) {var encmeth=objsave.value;} else {var encmeth='';}
	
	var MainRowid=cspRunServerMethod(encmeth,disploc,warddr,userid,strdata,dhcpcdr) ;
	
	return MainRowid
}
		
function CanAddRow(objtbl)
{
	var incidesc,Row;
	var rows=objtbl.rows.length;
	
	if(rows==1) return true;
	if(rows>1)
	{ 	
		Row=rows-1;
		incidesc=GetColumnData("TInci",Row)
	}

	if (incidesc==""){	
	
		SetFocusColumn("TInci",Row);
		return false;
	}
	return true;
}

function AddRowToList(objtbl) 
{
	var rows=objtbl.rows.length;
	var objlastrow=objtbl.rows[rows-1];

	//make sure objtbl is the tbody element,
	//之所以要走tk_getTBody?是因为TBody不包括THead,而且TBody只有appendChild,但只用通过rowobj才能取得TBody
	//tUDHCOEOrder_List_Custom是包括THeader和Tbody
	//tUDHCOEOrder_List_Custom.rows和TBody.rows是不同的?后者一般比前者少1
	objtbody=tk_getTBody(objlastrow);

	//alert(objtbl.innerHTML);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
	    //rowitems其实是element的集合,每个element的ParentElement就是Tabelobj.RowObj.Cell对象
	    //将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
			/*
			if (arrId[0]=="OrderPrior"){
				var obj=websys_getParentElement(rowitems[j]); 
				var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"width:" + obj.style.width +"\" value=\"\">";
        obj.innerHTML=str;
			} 
			*/
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}

	objnewrow=objtbody.appendChild(objnewrow);
	ChangeRowStyle(objnewrow);

	//将焦点放在名称上
	websys_setfocus("Inci"+Row);
 FocusRowIndex=objnewrow.rowIndex;
	//alert("add:"+FocusRowIndex);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function SelectRowHandler()	
{
	var row=selectedRow(window);	
 CurrentRow=row
	if (row<1) return ;
	
	 //	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tdhcpha_callbackitm');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alert("selectrow:"+selectrow);
	if (!selectrow) return;

	//FocusRowIndex是Tbody的?所以GetRow也要去Tbody的;
	FocusRowIndex=selectrow;
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	
	if (selectrow!=SelectedRow){
		SelectedRow=0;
	}
	

	var objcell=document.getElementById("TQty"+"z"+row);
	if(objcell)
	{
			objcell.onchange=QtyChangeHandler;
	}
	
	
	
}

function GetRow(Rowindex)
{
	var objtbl=document.getElementById('tdhcpha.callbacknew');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}

function GetColumnData(ColName,Row)
{
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox")
			{return CellObj.checked;}
			else
			{return CellObj.value;}
		}
	}
	return "";
}

function SetFocusColumn(ColName,Row){
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};

}

function ChangeRowStyle(RowObj)
{
		for (var j=0;j<RowObj.cells.length;j++) 
		{
    if (!RowObj.cells[j].firstChild) {continue} 
		  
				var Id=RowObj.cells[j].firstChild.id;
				var arrId=Id.split("z");
				var objindex=arrId[1];
				var objwidth=RowObj.cells[j].style.width;
				var objheight=RowObj.cells[j].style.height;
				var IMGId="ldi"+Id;
				
				/*
				1.RowObj.cells[i]本身是个对象,本身有Style属性,里面可以包含多个element(HIDDEN TableItem就全放在了一个Cell中)
				2.cells[j].firstChild是Cell里的第一个element,如果为label的话就没有type属性
				3.将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
    4.只有列不为Display only?不一定会有Style属性(可以参见网页源码),所以最好只将Display Only的列变为可编辑时候
        对innerHTML属性进行重新定义,否则容易造成列自动变为一个默认长度
    */
    /*  
				if (arrId[0]=="TUom")
				{
        	if (RowObj.cells[j].firstChild.tagName!="LABEL"){continue;}
				  			//cells[j].className="DentalSel";
				 				//alert(owObj.cells[j].className);
				  			//alert(RowObj.cells[j].innerHTML);
				  			//alert(RowObj.cells[j].style.height);
									var stylestr="style=\"WIDTH:" + objwidth + ";HEIGHT:" + objheight +";FONT-SIZE:9pt \"";
									var str="<select id=\""+Id+"\" name=\""+Id+ "\"  " + stylestr +" value=\"\" onchange=\"UomChangeHandler()\">";
        
         RowObj.cells[j].innerHTML=str;
         obj=RowObj.cells[j].firstChild;
          	
        /* if (obj)
          	{
		         var OrderPriorArray=OrderPriorStr.split("^");
		         for (var i=0;i<OrderPriorArray.length;i++) {
		         	 var OrderPrior=OrderPriorArray[i].split(String.fromCharCode(1));
		           obj.options[obj.length] = new Option(OrderPrior[2],OrderPrior[0]);
		         }
		         //obj.onchange=PrescList_Change;
		         
		      }
          //alert(RowObj.cells[j].innerHTML);
			} */
	
			if (arrId[0]=="TInci")
			{
				  objwidth=AdjustWidth(objwidth);
				 
				  //\""+objindex+"\"
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onkeydown=\"xInci_lookuphandler()\">";
					str=str+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\" onclick=\"xInci_lookuphandler()\">";
          //alert(str);
          RowObj.cells[j].innerHTML=str;
          /*也可以采用下面的方式定义事件
					var obj=document.getElementById(Id);
					if (obj) obj.onkeydown=Item_lookuphandler;
					var obj=document.getElementById(IMGId);
					if (obj) obj.onclick=Item_lookuphandler;
					*/
			}
			if (arrId[0]=="TQty")
			{
					var str="<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"WIDTH:" + objwidth + " ;HEIGHT:" + objheight +"\" value=\"\" onchange=\"QtyChangeHandler()\" onkeydown=\"QtyKeyDownHandler()\">";
          RowObj.cells[j].innerHTML=str;
			}
	}
}

function AliasLookupSelect(str)
{	
	//2007-8-21,zdm

	var inci=str.split("^");
	var row=GetRow(FocusRowIndex);

	if(inci.length>0)
	{
		SetColumnData("TInciRowid",row,inci[2]);
		SetColumnData("TInci",row,inci[0]);
		SetColumnData("TForm",row,inci[3]);
		SetColumnData("TBarCode",row,inci[4]);
		SetColumnData("TManf",row,inci[5]);
		SetColumnData("TUom",row,inci[6]);
		SetColumnData("TPrice",row,inci[7]);
	}
 websys_setfocus("TQty")
}

function xInci_lookuphandler(e) 
{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);

	if (evtName=='TInci') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}

	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		//if (!CheckDiagnose()) return;
		var url='websys.lookup.csp';
		url += "?ID=d50013iTInciz"+Row;
		//url += "?ID=d50013iItem";
		//url += "&CONTEXT=Kweb.DHCSTKUTIL:IncAlias";
		url += "&CONTEXT=Kweb.DHCSTKUTIL:IncDetail";
		url += "&TLUJSF=AliasLookupSelect";
		var obj=document.getElementById('TInciz'+Row);
		var incidesc=obj.value;
		if (incidesc==""){return false}
		if (incidesc=="*"){incidesc=""}
		if (obj) url += "&P1=" + websys_escape(incidesc);
		
		
		var obj=document.getElementById('displocid');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		
		/*var obj=document.getElementById("catID");
		if (obj) url += "&P3=" + websys_escape(obj.value);
		//if (obj) url += "&P3=" ;
		var obj=document.getElementById('subCatID');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		//if (obj) url += "&P4=";
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P6=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P7=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		var obj=document.getElementById('OrdCatGrp');
		if (obj) url += "&P12=" + websys_escape(obj.value); */
		websys_lu(url,1,'');
		//alert(url);
		return websys_cancel();
	}else{
		if ((type=='keydown')&&(key==9)){
			var obj=websys_getSrcElement(e);
			var incidesc=obj.value;
			if (incidesc==""){
				websys_setfocus(obj.id);
			  return websys_cancel();
			}
		}
	}

}

//如果有图标和元素在同一列里?要调整元素的宽度
function AdjustWidth(objwidth){
  if (objwidth!=""){
  	 var objwidtharr=objwidth.split("px")
  	 var objwidthnum=objwidtharr[0]-25;
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
 FocusRowIndex=TRSrc.rowIndex;
	return Row
}

function GetRow(Rowindex){
	var objtbl=document.getElementById('tdhcpha_callbackitm');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}

function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}

function QtyKeyDownHandler(e)
{
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}

	if ((keycode==8)||(keycode==9)||(keycode==46)||(keycode==13)||((keycode>47)&&(keycode<58))||((keycode>95)&&(keycode<106))||(keycode==190))
	{
			try {
					if ((keycode==13)||(keycode==9))
					{	
						window.event.keyCode=0;
						var Row=GetEventRow(e);
			 			var qty=GetColumnData("TQty",Row);
		  			var incirowid=GetColumnData("TInciRowid",Row);
				
						var amt=parseFloat(price)*parseFloat(qty);
						amt=amt.toFixed(4);
		
						SetColumnData("TAmt",Row,amt);
						return websys_cancel();
					}
			}catch(e) {}
	}else{
		window.event.returnValue = false;
		return websys_cancel();
		
	}
}


function QtyChangeHandler(e)
{ 
	var eSrc=websys_getSrcElement(e);
	try {
						var Row=GetEventRow(e);
					
		  		var qty=GetColumnData("TQty",Row);
		  		var incirowid=GetColumnData("TInciRowid",Row);
		 
		  		if (qty==""){qty=0}
		  		if (incirowid!="")
		  		{
							var price=GetColumnData("TPrice",Row);
							var amt=parseFloat(price)*parseFloat(qty);
							amt=amt.toFixed(4);
		
							SetColumnData("TAmt",Row,amt);
						}
						//return websys_cancel();
	}catch(e) {}
}

function ReloadMainWindow()
{
		 var docu=parent.frames['dhcpha.callbackmain'].window.document	
			var objward=docu.getElementById("Ward")
			if(objward) var ward=objward.value;
	  var objward=docu.getElementById("wardid")
			if(objward) var wardid=objward.value;
			var objdisloc=docu.getElementById("DispLoc")
			if(objdisloc) var disploc=objdisloc.value; 
			var objdisloc=docu.getElementById("displocid")
			if(objdisloc) var displocid=objdisloc.value; 
			
			var startdate=today();
			var enddate=today();
			var ackflag="N"
			
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackmain&DispLoc="+disploc+"&displocid="+displocid+"&Ward="+ward+"&wardid="+wardid+"&StartDate="+startdate+"&EndDate="+enddate+"&ackflag="+ackflag;
			docu.location.href=lnk ;
	
}
function LoadAfterSaved(dhcpcb)
{
//	alert(dhcpcb)
 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackitm&dhcpcdr="+dhcpcb;
// alert(lnk)
	document.location.href=lnk
	
	}

function DeleteClick()
{
 var obj=document.getElementById("DeleteDetail" )
 if (obj.disabled==true)   return ;

	//var obj=document.getElementById("dhcpcdr")
//if(obj) var dhcpcdr=obj.value;

	//var row=GetRow(FocusRowIndex);
 var row=CurrentRow;
	if(row<1) return;
	
	/*
	var incdr=GetColumnData("TInciRowid",row)
 
	if(incdr=="")
	{
			alert(t['NO_DATA']);
			return;
	}
	*/
	
	var ask=window.confirm(t['DELETE_OR_NOT'])

	if (ask==false) return ;
	
	var pci=GetColumnData("TRowid",row)
	if(pci=="")
	{
		 var objtbl=document.getElementById("t"+"dhcpha_callbackitm")
		 DelOneRow(objtbl,row) 
			return;
	}
	else
	{	
			var ret=DeleteCallBackItm(pci);
			
			 if(ret=="0")
			{
			 	alert(t['CANNOTDELETE']);
			} else if(ret=="1")
			{
			//	alert(t['DELETE_SUCCESS']);
			//	ReloadMainWindow()
				window.location.reload() ;
			}
			else
			{
				alert(t['DELETE_FAILURE']);
			}
}

}

function DeleteData(dhcpcdr,incdr)
{
	
	var obj=document.getElementById("mDeleteDetail");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
	var ret=cspRunServerMethod(encmeth,'','',dhcpcdr,incdr) ;
 
	return ret
}

function DeleteCallBackItm(pci)
{
	var obj=document.getElementById("mDeleteDetail");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
	var ret=cspRunServerMethod(encmeth,pci) ;
	return ret
}


function SetAuthority()
{
		var locid=session['LOGON.CTLOCID'];
		var ret=GetLocType(locid);
		var arr=ret.split("^");
		var loctype=arr[0];
		var locdesc=arr[1];
		var ackflag="";
		
		var obj=document.getElementById("ackflag")
		if (obj)
		{ 
					ackflag=obj.value;
		}
					
		if(loctype=="D"||ackflag=="Y")
		{					
					var obj=document.getElementById("Add");
					if (obj)
					{ 
							
				//			obj.outerHTML=obj.innerText
					obj.disabled=true;
					obj.Enabled=false;
					}
					
					var obj=document.getElementById("Save");
					if (obj)
					{ 
							obj.disabled=true;
					}
					
					var obj=document.getElementById("DeleteDetail");
					if (obj)
					{ 
							obj.disabled=true;
					}
		}

}

function GetLocType(locid)
{
		if(locid=="") return;
		
		var obj=document.getElementById("mGetLocType");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
		var ret=cspRunServerMethod(encmeth,'','',locid) ;

		return ret
}

/*
function SelectRowHandler()
{
	var row=selectedRow(window);	
 CurrentRow=row
	if (row<1) return ; //
	var objcell=document.getElementById("TQty"+"z"+row);
	if(objcell)
	{
			objcell.onchange=QtyChangeHandler;
	}
		
}
*/
document.body.onload=BodyLoadHandler;