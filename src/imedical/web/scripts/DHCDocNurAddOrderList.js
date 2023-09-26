//DHCDocNurAddOrderList.bak0822.js

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
var CurrentRow=0;

var LocalSysDate=tkMakeServerCall('web.DHCDocNurAddOrder','GetDate');
var curDate=LocalSysDate;

var CurrentID=0;

function BodyLoadHandler(){
	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
	if (objtbl) objtbl.onclick=Table_onclick;
	var ObjBtnDone=document.getElementById('BtnDone');
	if (ObjBtnDone) ObjBtnDone.onclick=BtnDone_onclick;
	SetTableStyle();
	var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;
	var ObjAddAllLinkOrders=document.getElementById('AddAllLinkOrders');
	if (ObjAddAllLinkOrders) ObjAddAllLinkOrders.onclick=AddAllLinkOrders_Click;
	var ObjAddAllLinkOrders=document.getElementById('AddAllLabItems');
	if (ObjAddAllLinkOrders) ObjAddAllLinkOrders.onclick=AddAllLabItems_Click;
	var ObjAddAllLinkOrders=document.getElementById('AddAllCanLinkOrders');
	if (ObjAddAllLinkOrders) ObjAddAllLinkOrders.onclick=AddAllCanLinkOrders_Click;
	//刷新之后清空右侧主医嘱关联
	try{
	//var par_win =window.parent.parent.right.maindata.dataframe21;
	var par_win =window.parent.parent.right.maindata.dataframe184;
	if (par_win){
			//par_win.SetLinkItemValue("");
			//新医嘱录入
			par_win.SetVerifiedOrder("");
		}
	}catch(e){
	}
}

function BodyUnLoadHandler(){
	BtnDone_onclick();
}

function SetTableStyle(){
	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		var Row=i;
		var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+Row);
		var SelectOrderItem=GetColumnData("SelectOrderItem",Row);
		var NurDoneFlag=GetColumnData("NurDoneFlag",Row);
		if (NurDoneFlag==1){
			RowObj=objtbl.rows[Row];
			RowObj.className="green";//green //arrange
			//ObjSelectOrderItem.disabled=true;
		}
		var OrderSeqNo=GetColumnData("OrderSeqNo",Row);
		if (OrderSeqNo.indexOf(".")>-1){
			ObjSelectOrderItem.disabled=true;	
		}
		
		var ObjOrderName=document.getElementById("OrderNamez"+Row);
		if (ObjOrderName) {
			ObjOrderName.style.fontWeight = "bold";
			ObjOrderName.style.color = "blue";
		}
	}
}

 function Table_onclick(){
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id
	if ((eSrcID.indexOf("OrderName")==-1)&&(eSrcID.indexOf("SelectOrderItem")==-1)){
		return websys_cancel();
	}
	SetTableStyle();
	//var par_win =window.parent.parent.right.maindata.dataframe21;
	//新医嘱录入
	var par_win =window.parent.parent.right.maindata.dataframe184;
	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
	var RowObj=getRow(eSrc);
	var selrow=RowObj.rowIndex;
	if (selrow<1) return;
	var ObjEpisodeID=document.getElementById("EpisodeID");
	if (ObjEpisodeID) var EpisodeID=ObjEpisodeID.value;
	//alert("EpisodeID=="+EpisodeID);

	var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+selrow);
	var PAPMINameLink='OrderNamez'+selrow;
	if (eSrc.id==PAPMINameLink){
		ObjSelectOrderItem.checked=true;
	}
  
	var itemsel=document.getElementById("SelectOrderItemz"+selrow);
	if (itemsel) {
		var OldFlag=GetColumnData("OldFlag",selrow);
		if (OldFlag=="1") {itemsel.checked=false;alert("该医嘱已经过了补录时间,请单独录一条");return;}
		SetRowStyle(selrow);
	}
  
	var OrderItemRowId=GetColumnData("OrderItemRowId",selrow);
	var MasterOrderItemRowId=GetColumnData("OrderLinkOrderDR",selrow);
	if (MasterOrderItemRowId.indexOf("||")<0) {
		MasterOrderItemRowId=OrderItemRowId;
	}else{
		OrderItemRowId=MasterOrderItemRowId;
	}
	var OrderSeqNo=GetColumnData("OrderSeqNo",selrow);
	if (OrderSeqNo.indexOf(".")>-1){
		var TempArr=OrderSeqNo.split(".");
		var MasterOrderSeqNo=TempArr[0];
	}else{
		var MasterOrderSeqNo=OrderSeqNo;
	}
	
	var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+selrow);
	if (ObjSelectOrderItem){
		var CheckVal=ObjSelectOrderItem.checked;
		var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=i;
			var OrderLinkOrderDR=GetColumnData("OrderLinkOrderDR",Row);
			var CurrOrderItemRowId=GetColumnData("OrderItemRowId",Row);
			var ObjSubSelectOrderItem=document.getElementById("SelectOrderItemz"+Row);
			if ((OrderLinkOrderDR==OrderItemRowId)||(CurrOrderItemRowId===OrderItemRowId)){
				ObjSubSelectOrderItem.checked=CheckVal;
				var SubRowObj=objtbl.rows[Row];
				SetRowStyle(Row);
			}else{
				ObjSubSelectOrderItem.checked=false;
				SetRowStyle(Row);
			}
		}
		if (CheckVal){
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",selrow);
			var OrderStartDate=GetColumnData("OrderStartDate",selrow);
			var OrderStartTime=GetColumnData("OrderStartTime",selrow);
			var OrderFreqRowid=GetColumnData("OrderFreqRowid",selrow);
			var OrderFreq=GetColumnData("OrderFreq",selrow);
			var OrderInstrRowid=GetColumnData("OrderInstrRowid",selrow);
			var OrderInstr=GetColumnData("OrderInstr",selrow);
			var OrderName=GetColumnData("OrderName",selrow);
			var LinkOrderStr=MasterOrderItemRowId+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderFreqRowid+"^"+OrderFreq+"^"+MasterOrderSeqNo+"^"+OrderStartTime+"^"+OrderInstrRowid+"^"+OrderInstr+"^"+OrderName;
			//if (par_win)par_win.SetLinkItemValue(LinkOrderStr);
			//新医嘱录入
			if (par_win)par_win.SetVerifiedOrder(LinkOrderStr);
			var ObjGetInstrLinkItemsNum=document.getElementById('GetInstrLinkItemsNum');
			if (ObjGetInstrLinkItemsNum){
				var GetInstrLinkItemsNum=ObjGetInstrLinkItemsNum.value;
				var ret=cspRunServerMethod(GetInstrLinkItemsNum,EpisodeID,MasterOrderItemRowId);
				if (ret>0) {
						var path="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocInstrLinkOrdItem&EpisodeID="+EpisodeID+"&MasterOrderItemRowId="+MasterOrderItemRowId+"&MasterOrderSeqNo="+MasterOrderSeqNo+"&MasterOrderPriorRowid="+OrderPriorRowid+"&MasterOrderStartDate="+OrderStartDate+"&MasterOrderFreqRowid="+OrderFreqRowid;
						window.open(path,"frmOSList","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,top=100,width=500,height=600")	
				}
			}
			
		}else{
			//if (par_win)par_win.SetLinkItemValue("");
			//新医嘱录入
			if (par_win)par_win.SetVerifiedOrder("");
		}
  }

}
 
 function BtnDone_onclick(){
 	var OrderItemStr="";
 	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=i;
			var SelectOrderItem=GetColumnData("SelectOrderItem",Row);
			if (SelectOrderItem==true) {
				var OrderName=GetColumnData("OrderName",Row);
				var OrderItemRowId=GetColumnData("OrderItemRowId",Row);
				if (OrderItemStr==""){
					OrderItemStr=OrderItemRowId;
				}else{
					OrderItemStr=OrderItemStr+"^"+OrderItemRowId;
				}
			}
		}
		AddOrderDone(OrderItemStr);
 }
 

function AddOrderDone(OrderItemStr){
	if (OrderItemStr=="") {
		//alert("请选择处置的医嘱");
		return;	
	}
	var ObjSaveDone=document.getElementById('SaveDone');
	if (ObjSaveDone){
		var SaveDone=ObjSaveDone.value;
		var ret=cspRunServerMethod(SaveDone,OrderItemStr);
		//if (ret==1) alert("处置完成");
	}
	window.location.reload();
 } 
 
 function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

 function BtnUnSave(){
 	var OrderItemStr="";
 	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=i;
			var SelectOrderItem=GetColumnData("SelectOrderItem",Row);
			if (SelectOrderItem==false) {
				var OrderName=GetColumnData("OrderName",Row);
				var OrderItemRowId=GetColumnData("OrderItemRowId",Row);
				if (OrderItemStr==""){
					OrderItemStr=OrderItemRowId;
				}else{
					OrderItemStr=OrderItemStr+"^"+OrderItemRowId;
				}
			}
		}
		
		if (OrderItemStr=="") {
			return;	
		}
		var ObjUnSave=document.getElementById('UnSave');
		if (ObjUnSave){
			var UnSave=ObjUnSave.value;
			//alert("OrderItemStr=="+OrderItemStr);
			var ret=cspRunServerMethod(UnSave,OrderItemStr);
			//if (ret==1) alert("处置完成");
			//alert("ret=="+ret);
		}
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

function AddAllLinkOrders_Click(){
	var ObjEpisodeID=document.getElementById("EpisodeID");
	if (ObjEpisodeID) var EpisodeID=ObjEpisodeID.value;
	var GetLinkOrdersBroker=document.getElementById('GetLinkOrdersBroker');
	if (GetLinkOrdersBroker){
		var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=i;
			CurrentRow=Row;
			var MasterOrderItemRowId=GetColumnData("OrderLinkOrderDR",Row);
			var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+Row);
			var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
			var SelectedOrder=GetColumnData("SelectOrderItem",Row);
			var ARCIMRowid=GetColumnData("ARCIMRowid",Row);
			if (ObjSelectOrderItem){
				var SelectDisabled=ObjSelectOrderItem.disabled;
			}
			if ((MasterOrderItemRowId.indexOf("||")<0)&&(OrderPriorRowid!=4)&&(OrderPriorRowid!=9)&&(SelectDisabled==false)&&(SelectedOrder==false)) {
				var OrderItemRowId=GetColumnData("OrderItemRowId",Row);
			MasterOrderItemRowId=OrderItemRowId;
			var encmeth=GetLinkOrdersBroker.value
			if (cspRunServerMethod(encmeth,'AddLinkOrders',EpisodeID,MasterOrderItemRowId,ARCIMRowid)=='0') {

				}
			}
		}
	}
	BtnDone_onclick();
	//window.location.reload();
}

function AddAllLabItems_Click(){
	var ObjEpisodeID=document.getElementById("EpisodeID");
	if (ObjEpisodeID) var EpisodeID=ObjEpisodeID.value;
	var GetLinkLabOrdersBroker=document.getElementById('GetLinkLabOrdersBroker');
	if (GetLinkLabOrdersBroker){
		var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
			var Row=i;
			CurrentRow=Row;
			var LabEpisodeNo=GetColumnData("LabEpisodeNo",Row);
			var LabelDesc=GetColumnData("LabelDesc",Row);
			var ARCIMRowid=GetColumnData("ARCIMRowid",Row);
			if(LabEpisodeNo!=" "){
				  if((LabelDesc!="")&&(GetColumnData("SelectOrderItem",Row)==false)){
							var OrderItemRowId=GetColumnData("OrderItemRowId",Row);
							var encmeth=GetLinkLabOrdersBroker.value
							if (cspRunServerMethod(encmeth,'AddLinkOrders',EpisodeID,LabelDesc,ARCIMRowid)=='0') {  }
					}
				  SetColumnData("SelectOrderItem",Row,true);
				  var SelectOrderItem=GetColumnData("SelectOrderItem",Row);
					for (var j=CurrentRow; j<rows; j++){
							var subRow=j;
							CurrentsubRow=subRow;
							var subLabEpisodeNo=GetColumnData("LabEpisodeNo",subRow);
							var ObjsubSelectOrderItem=document.getElementById("SelectOrderItemz"+subRow);
							if((GetColumnData("SelectOrderItem",subRow)==false)&&(subLabEpisodeNo==LabEpisodeNo)){
							SetColumnData("SelectOrderItem",subRow,true);
							SetRowStyle(subRow);
						}
					}
			}
		}
	}
	BtnDone_onclick();
	//window.location.reload();
}

function AddAllCanLinkOrders_Click(){
	var ObjEpisodeID=document.getElementById("EpisodeID");
	if (ObjEpisodeID) var EpisodeID=ObjEpisodeID.value;
	var GetOrderLinkOrdersBroker=document.getElementById('GetOrderLinkOrdersBroker');
	if (GetOrderLinkOrdersBroker){
		var objtbl=document.getElementById('tDHCDocNurAddOrderList');
		var rows=objtbl.rows.length;
		for (var i=1; i<rows; i++){
		var Row=i;
		CurrentRow=Row;
		var MasterOrderItemRowId=GetColumnData("OrderLinkOrderDR",Row);
		var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+Row);
		var OrderPriorRowid=GetColumnData("OrderPriorRowid",Row);
		var ARCIMRowid=GetColumnData("ARCIMRowid",Row);

		if (ObjSelectOrderItem){
			var SelectDisabled=ObjSelectOrderItem.disabled;
		}
		  if ((MasterOrderItemRowId.indexOf("||")<0)&&(OrderPriorRowid!=4)&&(OrderPriorRowid!=9)&&(SelectDisabled==false)) {
			var OrderItemRowId=GetColumnData("OrderItemRowId",Row);
			MasterOrderItemRowId=OrderItemRowId;
			var encmeth=GetOrderLinkOrdersBroker.value
			//alert(MasterOrderItemRowId)
		  	ret=cspRunServerMethod(encmeth,'AddLinkOrders',EpisodeID,MasterOrderItemRowId,ARCIMRowid)
		  	if (ret!="") {
					SetColumnData("SelectOrderItem",Row,true);
				}
			}
		}
	}
	BtnDone_onclick();
	//window.location.reload();
}

function AddLinkOrders(value){
	//return;
	var Copyary=new Array();
	var par_win = window.parent.parent.right;
	//alert(value)
	var Split_Value=value.split("^");
	var OrderItemRowId=unescape(Split_Value[1]);
	var ItemOrderType=unescape(Split_Value[2]);
	var qty=unescape(Split_Value[3]);
	var LinkNotes="";
	var MasterID=unescape(Split_Value[4]);
	
	var OrderSeqNo=GetColumnData("OrderSeqNo",CurrentRow);
	//alert(OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+"")
	var MasterOrderItemRowId=GetColumnData("OrderItemRowId",CurrentRow);
	var MasterOrderSeqNo=GetColumnData("OrderSeqNo",CurrentRow);
	var MasterOrderPriorRowid=GetColumnData("OrderPriorRowid",CurrentRow);
	if (MasterOrderPriorRowid==8){  //嘱托长期
		MasterOrderPriorRowid=5;
	} else if (MasterOrderPriorRowid==6){ //嘱托临时
			MasterOrderPriorRowid=3;
	} else if (MasterOrderPriorRowid==1){ //即刻医嘱
		MasterOrderPriorRowid=3;
	}
	var MasterOrderFreqRowid=GetColumnData("OrderFreqRowid",CurrentRow);
	var MasterOrderStartDate=GetColumnData("OrderStartDate",CurrentRow);
	
	StartDate1=ConvertDateFormat(MasterOrderStartDate,1)
	CurrentDate1=ConvertDateFormat(GetCurrentDate(),1)
	var OragK=StartDate1;
	if (MasterOrderPriorRowid==3) {   //对"临时医嘱"  "即刻医嘱" 只需要填写备注 & 改写开始日期即可
		if ((StartDate1-CurrentDate1) < 0) {
			LinkNotes="补"+MasterOrderStartDate+"费用";
			MasterOrderStartDate=GetCurrentDate();
			Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+LinkNotes+"!";
			if ((par_win)&&(Copyary.length!=0)){
				par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqRowid,MasterOrderStartDate);
				var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+CurrentRow);
				ObjSelectOrderItem.checked=true;
				SetRowStyle(CurrentRow);
				var objtbl=document.getElementById('tDHCDocNurAddOrderList');
				var rows1=objtbl.rows.length;
				for (var j=1; j<rows1; j++){
					var SubOrderRow=j;
					var OrderLinkOrderDR=GetColumnData("OrderLinkOrderDR",SubOrderRow);
					var ObjSubSelectOrderItem=document.getElementById("SelectOrderItemz"+SubOrderRow);
					if (OrderLinkOrderDR==MasterOrderItemRowId){
						ObjSubSelectOrderItem.checked=true;
						SetRowStyle(SubOrderRow);
					}
				}
			}
		}else{
			var Copyary=new Array();
			Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+LinkNotes+"!";
			if ((par_win)&&(Copyary.length!=0)){
				par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqRowid,MasterOrderStartDate);
				
				var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+CurrentRow);
				ObjSelectOrderItem.checked=true;
				SetRowStyle(CurrentRow);
				var objtbl=document.getElementById('tDHCDocNurAddOrderList');
				var rows1=objtbl.rows.length;
				for (var j=1; j<rows1; j++){
					var SubOrderRow=j;
					var OrderLinkOrderDR=GetColumnData("OrderLinkOrderDR",SubOrderRow);
					var ObjSubSelectOrderItem=document.getElementById("SelectOrderItemz"+SubOrderRow);
					if (OrderLinkOrderDR==MasterOrderItemRowId){
						ObjSubSelectOrderItem.checked=true;
						SetRowStyle(SubOrderRow);
					}
				}
			}
		}
	}else{
		//对"长期医嘱"的处理  开始
		if ((StartDate1-CurrentDate1) < 0){  //当需要补录的医嘱比当前日期小时, 需要首先进行当日之前费用的补录
			//循环日期, 计算插入当日之前的临时医嘱(需要按照频次的定义生成)
			var FreqDetail=GetFreqDetail(MasterOrderFreqRowid);  //取得频次的所有参数信息
			//alert(FreqDetail)
			var Split_FreqDetail=FreqDetail.split("^");  //频次信息截取为数组
			var OrderFreqFactor=unescape(Split_FreqDetail[0]); //获取频次的分发次数
			var OrderFreqInterval=unescape(Split_FreqDetail[1]); //获取频次的间隔天数
			var OrderFreqDispTimeStr=unescape(Split_FreqDetail[2]); //获取频次的星期字符串
			var NumTimes=0;
			//对WnD频次  与其他频次分开处理方式
			if (OrderFreqDispTimeStr!=""){
				//alert("weekdeal")
				var NumTimes=0; //用于循环寻找需要执行日期时, 记录下一个日期的天数用
				var MasterOrderPriorRowidGen=3;  //设置医嘱类型为"临时医嘱"
				var MasterOrderStartDate=GetCurrentDate();
			  //根据频次的当日分发次数, 设置插入临时医嘱的数量
				if(OrderFreqFactor!=""){
					qty=OrderFreqFactor;
				}else{
					qty=1;
				}
				MasterOrderSeqNoGen=""
				for(k=StartDate1; (CurrentDate1-k) > 0; k++){
					if(k!=OragK){
						continue;
					}
					NumTimes=GetNextDateByFreqDispTime(OrderFreqDispTimeStr,ConvertDateFormat(k,4),8); //获取此WnD频次 下一个需要执行的日期距k的天数
					if(NumTimes==0){
						OragK++;
						NumTimes=GetNextDateByFreqDispTime(OrderFreqDispTimeStr,ConvertDateFormat(OragK,4),8);
					}
					OragK=OragK+NumTimes
					MasterOrderFreqRowidGen="";  //设置频次为ONCE
					LinkNotes="补"+ConvertDateFormat(k,4)+"("+OrderSeqNo+")费用"  //设置医嘱备注为"补某日费用", 日期由循环取得
					var Copyary=new Array();  //初始化传参数组
					Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+LinkNotes+"!";
					if ((par_win)&&(Copyary.length!=0)){
						par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNoGen,MasterOrderPriorRowidGen,MasterOrderFreqRowidGen,MasterOrderStartDate);
					}
				}  //日期循环结束, 即: 完成临时医嘱插入工作
			}else{
				//alert("longnormaldeal")
				if(OrderFreqInterval==""){OrderFreqInterval=1;}
				for (k=StartDate1; (CurrentDate1-k)>0; k++){
					if (k!=OragK){
							continue;
					}
					for(l=0;l<OrderFreqInterval;l++){
						OragK++;
					}
					MasterOrderPriorRowidGen=3;  //设置医嘱类型为"临时医嘱"
					MasterOrderStartDate=GetCurrentDate();
					  //根据频次的当日分发次数, 设置插入临时医嘱的数量
					if(OrderFreqFactor!=""){
						qty=OrderFreqFactor;
					}else{
						qty=1;
					}
					MasterOrderFreqRowidGen="";  //设置频次为ONCE
					MasterOrderSeqNoGen=""
					OrderSeqNoGen="";
					LinkNotes="补"+ConvertDateFormat(k,4)+"("+OrderSeqNo+")费用"  //设置医嘱备注为"补某日费用", 日期由循环取得
					var Copyary=new Array();  //初始化传参数组
					Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNoGen+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+LinkNotes+"!";
					if ((par_win)&&(Copyary.length!=0)){
						par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNoGen,MasterOrderPriorRowidGen,MasterOrderFreqRowidGen,MasterOrderStartDate);
					}
				}  //日期循环结束, 即: 完成临时医嘱插入工作
			}
			
			//开始插入本日的 长期医嘱
			MasterOrderStartDate=ConvertDateFormat(OragK,0);
			//	MasterOrderStartDate=GetCurrentDate();
			qty=1;
			var Copyary=new Array();
			Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+""+"!";
			if ((par_win)&&(Copyary.length!=0)){
				par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqRowid,MasterOrderStartDate);
			}
			
			var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+CurrentRow);
			ObjSelectOrderItem.checked=true;
			SetRowStyle(CurrentRow);
			var objtbl=document.getElementById('tDHCDocNurAddOrderList');
			var rows1=objtbl.rows.length;
			for (var j=1; j<rows1; j++){
				var SubOrderRow=j;
				var OrderLinkOrderDR=GetColumnData("OrderLinkOrderDR",SubOrderRow);
				var ObjSubSelectOrderItem=document.getElementById("SelectOrderItemz"+SubOrderRow);
				if (OrderLinkOrderDR==MasterOrderItemRowId){
					ObjSubSelectOrderItem.checked=true;
					SetRowStyle(SubOrderRow);
				}
			}
		}else{
			var Copyary=new Array();
			Copyary[Copyary.length]=OrderItemRowId+"!"+OrderSeqNo+"!"+""+"!"+ItemOrderType+"!"+qty+"!"+LinkNotes+"!";
			if ((par_win)&&(Copyary.length!=0)){
				par_win.AddLinkItemToList(Copyary,MasterOrderItemRowId,MasterOrderSeqNo,MasterOrderPriorRowid,MasterOrderFreqRowid,MasterOrderStartDate);
				var ObjSelectOrderItem=document.getElementById("SelectOrderItemz"+CurrentRow);
				ObjSelectOrderItem.checked=true;
				SetRowStyle(CurrentRow);
				var objtbl=document.getElementById('tDHCDocNurAddOrderList');
				var rows1=objtbl.rows.length;
				for (var j=1; j<rows1; j++){
					var SubOrderRow=j;
					var OrderLinkOrderDR=GetColumnData("OrderLinkOrderDR",SubOrderRow);
					var ObjSubSelectOrderItem=document.getElementById("SelectOrderItemz"+SubOrderRow);
					if (OrderLinkOrderDR==MasterOrderItemRowId){
						ObjSubSelectOrderItem.checked=true;
						SetRowStyle(SubOrderRow);
					}
				}
			}
		}
	}
}
function GetNextDateByFreqDispTime(FreqDispTimeStr,StartDateStr,DurFactor)
{
	var objStartDate=ConervToDate(StartDateStr);
	var ArrData=FreqDispTimeStr.split(String.fromCharCode(1));
	for (var j=0;j<DurFactor;j++){
		var TempDate=dateadd(objStartDate,j);
		var TempDateWeek=TempDate.getDay();
		for (var i=0;i<ArrData.length;i++) {
		 var ArrData1=ArrData[i].split(String.fromCharCode(2));
	 	 var DispTime=ArrData1[0];
	 	 var DispWeek=ArrData1[1];
	 	 if (DispWeek==TempDateWeek){return j;}
	 	 if ((DispWeek==7)&&(TempDateWeek==0)){return j;}
		}
	}
}
function dateadd(date1,day)
{
    var T=new Date();
    if(day<0)day=0;
    var t=Date.parse(date1)+day*1000*3600*24;
    T.setTime(t);
    return T;
}
function ConervToDate(OrderStartDate){
 	var OrderStartDateArr=OrderStartDate.split("/");
	var OrderStartDateYear=OrderStartDateArr[2];
	var OrderStartDateMonth=parseInt(OrderStartDateArr[1],10)-1;
	var OrderStartDateDay=OrderStartDateArr[0];	
	var objDate = new Date(OrderStartDateYear,OrderStartDateMonth,OrderStartDateDay,0,0,0);
	return objDate;	
}

function SetRowStyle(Row){
	var objtbl=document.getElementById('tDHCDocNurAddOrderList');
	var RowObj=objtbl.rows[Row];
	var RowObj=objtbl.rows[Row];
	var itemsel=document.getElementById("SelectOrderItemz"+Row);
	if (itemsel) {
		if (itemsel.checked==true){
			RowObj.className="LackOfFee";//green //arrange
		}else{
		 var NurDoneFlag=GetColumnData("NurDoneFlag",Row);
			if (NurDoneFlag==1){
				RowObj.className="green";
			}else{
				var num=Row%2;
			  if (num==0){		
			  	RowObj.className="RowEven";//green //arrange
			  }else{
			  	RowObj.className="RowOdd";//green //arrange
			  }	
			} 
		}
	}
}

function GetCurrentDate(){
	var GetCurrentDateMethod=document.getElementById('GetCurrentDate');
	var encmeth=GetCurrentDateMethod.value
	var CurrDate=cspRunServerMethod(encmeth,3);
	var CurrDateArr=CurrDate.split("^");
	var CurrentDate=CurrDateArr[0];
	return CurrentDate;
}

function ConvertDateFormat(OragDate,ConvertType){
	var ConvertDateFormatMethod=document.getElementById('ConvertDateFormat');
	var encmeth=ConvertDateFormatMethod.value
	var ConvertDate=cspRunServerMethod(encmeth,OragDate,ConvertType);
	return ConvertDate;
}

function GetFreqDetail(RowId){
	var GetCurrentDateMethod=document.getElementById('GetFreqDetail');
	var encmeth=GetCurrentDateMethod.value
	var ret=cspRunServerMethod(encmeth,RowId);
	return ret;   //factor_"^"_days_"^"_disptimestr_"^"
}

///医嘱录入界面刷新取消选择
function ClearCheck()
{
  var objtbl=document.getElementById('tDHCDocNurAddOrderList');
  var rows=objtbl.rows.length;
  for (var i=1; i<rows; i++){
	var Row=i;
	var Obj=document.getElementById("SelectOrderItemz"+Row);
	if (Obj){Obj.checked=false}
	}
}
