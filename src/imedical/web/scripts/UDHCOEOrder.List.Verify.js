//document.body.onload = BodyLoadHandler1;
  
  
  //patframeobj.patframe.FinishAdmit.disabled=true;
	var obj=document.getElementById("Update");
	if (obj) {
		var obj1=document.getElementById('PracticeFlag');
		if ((obj1)&&(obj1.value==1)) {
			obj.disabled=true;
			obj.onclick="";
		}else{
		/*
			//如果满足按钮可用的条件则将上部的审核置为不可用状态
			var patframeobj=window.parent.parent
			var ButtonValue=patframeobj.patframe.FinishAdmit.disabled
			// patframeobj.patframe.FinishAdmit.disabled=true;
		*/
			obj.onclick=UpdateClickHandler;
		}
		//实习医生没有审核的权限
	}
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;
	obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAllClickHandler;} 
	document.onclick=OrderDetails;
	var Objtbl=document.getElementById('tUDHCOEOrder_List_Verify');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
		var selobj=document.getElementById('Selectz'+i);  
		selobj.onclick=OrderDetails;
	}
	if (parent){
		if (parent.refreshTabsTitleAndStyle){
			var options=parent.$('#tabsReg').tabs("getSelected").panel('options');
			var title=options.title.split("(")[0];
			var code=options.id;
			var EpisodeID=document.getElementById("EpisodeID").value;
			var RetJson=tkMakeServerCall('websys.DHCChartStyle','GetVerifyStyle',"",EpisodeID,"");
			if (RetJson!=""){
				var RetJson=eval('(' + RetJson + ')');
				var count=RetJson.count;
				var className=RetJson.className;
			}else{
				var count=0;
				var className="";
			}
			var newJsonArr = new Array();
			var newJson={};
			var childArr=new Array();
			childArr.push({"code":code,"text":title,"count":count,"className":className});
			newJson.children=childArr;
			newJsonArr.push(newJson);
			parent.refreshTabsTitleAndStyle(newJsonArr);
			parent.reloadMenu();
		}else{
			parent.refreshBar();
		}
		
	}
	
//当离开页面的时候验证是否满足按钮可用条件，满足在离开时候将上部审核置为可用状态	
//window.onunload=ChangeState;
function ChangeState(){
	var obj=document.getElementById("Update");
	if (obj) {
		var obj1=document.getElementById('PracticeFlag');
		if ((obj1)&&(obj1.value!=1)) {
			window.parent.parent.patframe.TEST.disabled=true;
		}
	}
}

function SelectAllClickHandler(e){
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tUDHCOEOrder_List_Verify');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('Selectz'+i);  
		selobj.checked=obj.checked;  
	}
}
function OrderDetails(e){
	var src=websys_getSrcElement(e);
	if (src.tagName == "A") return;
	if (src.id.substring(0,6)=="Select")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("Selectz"+rowsel);
		if (obj) {
			if (obj.checked) {
				ChangelLinkItemSelect(rowsel);
			}
		else
			{
				
				CacallLinkItemSelect(rowsel,"");
			}
		}
	}
}
function ChangelLinkItemSelect(Row){

    try{
	    var LinkOrderItemMain=GetColumnData("LinkOrderItem",Row);
		var OrderItemRowidMain=GetColumnData("OrderItemRowid",Row);
		var eTABLE=document.getElementById("tUDHCOEOrder_List_Verify");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var SelectObj=document.getElementById("Selectz"+i);
			var LinkOrderItem=GetColumnData("LinkOrderItem",i);
			var OrderItemRowid=GetColumnData("OrderItemRowid",i);
			if (LinkOrderItemMain!=""){
				if ((OrderItemRowid==LinkOrderItemMain)||(LinkOrderItem==LinkOrderItemMain)){SetColumnData("Select",i,true)}
				}
			else{
				if (OrderItemRowidMain==LinkOrderItem){SetColumnData("Select",i,true)}
				}
			
		}
    }catch(e){alert(e.message)}
}
function CacallLinkItemSelect(Row,RowColor){

    try{
	    var LinkOrderItemMain=GetColumnData("LinkOrderItem",Row);
		var OrderItemRowidMain=GetColumnData("OrderItemRowid",Row);
	    
		var eTABLE=document.getElementById("tUDHCOEOrder_List_Verify");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var SelectObj=document.getElementById("Selectz"+i);
			var LinkOrderItem=GetColumnData("LinkOrderItem",i);
			var OrderItemRowid=GetColumnData("OrderItemRowid",i);
			if (LinkOrderItemMain!=""){
				if ((OrderItemRowid==LinkOrderItemMain)||(LinkOrderItem==LinkOrderItemMain)){
					SetColumnData("Select",i,false)
				 	if (RowColor!="") {eTABLE.rows[i].style.color=RowColor;}
				}
			}
			else{
				if ((OrderItemRowidMain==LinkOrderItem)||(OrderItemRowidMain==OrderItemRowid)){
						SetColumnData("Select",i,false)
						if (RowColor!="") {eTABLE.rows[i].style.color=RowColor;}
					}
			}
		}
    }catch(e){alert(e.message)}
}
function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
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
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj.tagName=='LABEL'){
		return CellObj.innerText;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
}

function CheckUpdateTime(SelectFlag){
	var myret=true;
	var obj=document.getElementById('GetCurrentDateTimeMethod');
	if (obj){var GetCurrentDateTimeMethod=obj.value}else{var GetCurrentDateTimeMethod=""}
	var CurrDateTime=cspRunServerMethod(GetCurrentDateTimeMethod,"3","1");
	var CurrDateTimeArr=CurrDateTime.split("^");
	var CurrDate=CurrDateTimeArr[0];
  	var CurrTime=CurrDateTimeArr[1];
	//小于当前时间30分钟按钮不可以选择
	var Objtbl=document.getElementById('tUDHCOEOrder_List_Verify');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
		var OrderName=GetColumnData("OrderName",i);
		var OrderStartDate=GetColumnData("OrderStartDate",i);
		var OrderStartTime=GetColumnData("OrderStartTime",i);
		var OrderLinkTo=GetColumnData("OrderLinkTo",i);
		var selobj=document.getElementById('Selectz'+i);
		var OrderStatusCode=document.getElementById('OrderStatusCodez'+i);
		if (selobj.checked==SelectFlag) {
			if ((OrderStatusCode!="I")&&(OrderStartDate==CurrDate)&&(OrderStartTime<CurrTime)&&(OrderLinkTo=="")){
				if (CheckTime(CurrTime,OrderStartTime,60)) {
					var SeqNo=GetColumnData("OrderSeqNo",i)
					var arry1=SeqNo.split(".");
					var MasterSeqNo=arry1[0];
					CacallLinkItemSelect(MasterSeqNo,"red");
					var SelectAllObj=document.getElementById('SelectAll');
					if (SelectAllObj&&SelectAllObj.checked) SelectAllObj.checked=false;
					myret=false;
				}
			}
		}
	}
	if (myret==false) {alert("医嘱开始时间最多只能小于当前时间30分钟,红色医嘱为不符合项目,请确认!");}
	return myret;
}
function UpdateClickHandler(e){
	var CheckUpdateTimeFlag=CheckUpdateTime(true);
	if (!CheckUpdateTimeFlag){return}
	var OrderItemStr=GetOrderDataOnAdd();
	if (OrderItemStr==""){
		alert(t['No_SelectOrder']);
		return false;
	}
	
	var PinNumberobj=document.getElementById("PinNumber");
	if (PinNumberobj){
		var PinNumber=PinNumberobj.value;
		if (PinNumber==""){
			alert(t['Input_PinNumber']);
			websys_setfocus('PinNumber');
			return websys_cancel();
		}else{
			var PinNumberMethodobj=document.getElementById("PinNumberMethod");
			if ((PinNumberMethodobj)&&(PinNumberMethodobj.value!="")){
				var PinNumberMethod=PinNumberMethodobj.value;
				var ret=cspRunServerMethod(PinNumberMethod,session['LOGON.USERID'],PinNumber)
				if (ret=="-4"){
					alert(t['Wrong_PinNumber']);
					websys_setfocus('PinNumber');
					return websys_cancel();
				}
			}
		}
		var OEOrdItemIDsobj=document.getElementById("OEOrdItemIDs");
		if (OEOrdItemIDsobj){
			OEOrdItemIDsobj.value=OEOrdItemIDs;
		}
	}
	var ret=SaveOrderItems(OrderItemStr);
	Update_click();
	return websys_cancel();
}

function UpdateClickHandlerFinish() {
	UpdateClickHandler();
}
function GetOrderDataOnAdd() {
  var OrderItemStr=""; 
  var OrderItem=""; 
  var OneOrderItem="";
	try{
		var objtbl=document.getElementById('tUDHCOEOrder_List_Verify');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var OrderItemRowid=GetColumnData("OrderItemRowid",i);
			var OrderARCIMRowid=GetColumnData("OrderARCIMRowid",i);
			var LinkOrderItem=GetColumnData("LinkOrderItem",i);
			var LinkOrderItem=LinkOrderItem.replace(/(^\s*)|(\s*$)/g,'');
			if  (LinkOrderItem!=""){OrderItemRowid=LinkOrderItem} ;//只传入主医嘱
			var SelectVlaue=GetColumnData("Select",i);
			if ((OrderARCIMRowid!="")&&(OrderItemRowid!="")&&(SelectVlaue==true)){	
			if (OrderItemStr==""){OrderItemStr=OrderItemRowid}
			else{
				if (("^"+OrderItemStr+"^").indexOf(("^"+OrderItemRowid+"^"))<0)
				{
					OrderItemStr=OrderItemStr+"^"+OrderItemRowid
				}
			}
			//OrderItem=OrderARCIMRowid+"*"+OrderItemRowid+"*V";
		    //if (OrderItemStr==""){OrderItemStr=OrderItem}
		    //else{OrderItemStr=OrderItemStr+"^"+OrderItem}
			}
		}
	}catch(e){alert(e.message)}
	return OrderItemStr;
}
function SaveOrderItems(OrderItemStr){
	var UserAddRowid="";
	var UserAddDepRowid="";
	var DoctorRowid="";
	UserAddRowid=session['LOGON.USERID'];
	UserAddDepRowid=session['LOGON.CTLOCID'];
	var EpisodeID= document.getElementById("EpisodeID").value;
	DoctorRowid=UserAddRowid;
	var Obj=document.getElementById("SaveOrderItemsMethod");
	if(Obj){SaveOrderItemsEN=Obj.value;}else{SaveOrderItemsEN="";}
	//alert(EpisodeID+"!"+UserAddRowid+"!"+OrderItemStr+"!"+UserAddDepRowid+"^"+SaveOrderItemsEN)
	var ret=cspRunServerMethod(SaveOrderItemsEN,EpisodeID,UserAddRowid,OrderItemStr,UserAddDepRowid)
	return ret;
}

function DeleteClickHandler() {
	var OrderItemStr=GetOrderDataOnAdd();
	//alert(OrderItemStr);
	if (OrderItemStr==""){
		alert(t['No_SelectOrder']);
		return false;
	}
	
	var PinNumberobj=document.getElementById("PinNumber");
	if (PinNumberobj){
		var PinNumber=PinNumberobj.value;
		if (PinNumber==""){
			alert(t['Input_PinNumber']);
			websys_setfocus('PinNumber');
			return websys_cancel();
		}else{
			var PinNumberMethodobj=document.getElementById("PinNumberMethod");
			if ((PinNumberMethodobj)&&(PinNumberMethodobj.value!="")){
				var PinNumberMethod=PinNumberMethodobj.value;
				var ret=cspRunServerMethod(PinNumberMethod,session['LOGON.USERID'],PinNumber)
				if (ret=="-4"){
					alert(t['Wrong_PinNumber']);
					websys_setfocus('PinNumber');
					return websys_cancel();
				}
			}
		}
	}
	
	var UserAddRowid="";
	var UserAddDepRowid="";
	var DoctorRowid="";
  	UserAddRowid=session['LOGON.USERID'];
  	UserAddDepRowid=session['LOGON.CTLOCID'];
  	var EpisodeID= document.getElementById("EpisodeID").value;
  	DoctorRowid=UserAddRowid;
	
	var Obj=document.getElementById("DeleteOrderItemsMethod");
    if(Obj){encmeth=Obj.value;}else{encmeth="";}
    for (var i=0;i<OrderItemStr.split("^").length;i++) {
    	var OEItemRowid=OrderItemStr.split("^")[i];
    	var LinkOrderStr=tkMakeServerCall('web.DHCDocOrderCommon','GetLinkOrdItem',OEItemRowid,1);
    	var ret=cspRunServerMethod(encmeth,OEItemRowid,UserAddRowid)
		if (ret!="0") {
				alert(t['DeleteErr']);
				return websys_cancel();
		}
		if (LinkOrderStr!=""){
			var LinkOrderStrArry=LinkOrderStr.split("^");
			var LinkOrderLeng=LinkOrderStrArry.length;
			for (var J=0;J<LinkOrderLeng;J++){
				var ret=cspRunServerMethod(encmeth,LinkOrderStrArry[J],UserAddRowid)
				}
			}
    }
    Delete_click();
    return websys_cancel();
}
function CheckTime(FirstTime,SecondTime,lap){
	var FirstTimeMinute=ConvertTimeToMinute(FirstTime)-lap;
	var SecondTimeMinute=ConvertTimeToMinute(SecondTime);
	if (FirstTimeMinute>SecondTimeMinute) return true;
	return false;
}
function ConvertTimeToMinute(tm) {
	 if (tm=='') return 0;
	 var tmArr=tm.split(':');
	 var len=tmArr.length;
	 if (len>3) return 0;
	 for (i=0; i<len; i++) {
	  if (tmArr[i]=='') return 0;
	 }
	 var hr=parseFloat(tmArr[0]);
	 var mn=parseFloat(tmArr[1]);
	 var minutes=hr * 60 +mn;
	 return minutes;
}

 var CheckUpdateTimeFlag=CheckUpdateTime(false);