var PageLogicObj={
	m_OrdListTabDataGrid:"",
	m_selRowIndex:""
}
$(function(){
	Init();
	OrdListTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_OrdListTabDataGrid=InitOrdListTabDataGrid();
}
function InitOrdListTabDataGrid(){
	var toobar=new Array();
	if (ServerObj.PracticeFlag!=1){
		toobar.push({
			text:'审核实习医嘱',
			iconCls: 'icon-save-sure',
			handler: function() {UpdateClickHandler();}
		});
	}
	toobar.push({
		text:'删除',
		iconCls: 'icon-cancel',
		handler: function() {DeleteClickHandler();}
	});
	var Columns=[[ 
		{field:'OrderItemRowid',title:'选择',checkbox:true},
		{field:'OrderSeqNo',title:'序号',width:50},
		{field:'OrderName',title:'医嘱名称',width:300},
		{field:'OrderStatus',title:'医嘱状态',width:80},
		{field:'OrderPrior',title:'医嘱类型',width:80},
		{field:'OrderStartDate',title:'开始日期',width:100},
		{field:'OrderStartTime',title:'开始时间',width:80},
		{field:'OrderDoseQty',title:'单次剂量',width:70},
		{field:'OrderDoseUOM',title:'单位',width:50},
		{field:'OrderFreq',title:'频次',width:80},
		{field:'OrderInstr',title:'用法',width:80},
		{field:'OrderDur',title:'疗程',width:50},
		{field:'OrderPrice',title:'单价',width:80},
		{field:'OrderPackQty',title:'取药数量',width:70},
		{field:'OrderPackUOM',title:'取药单位',width:50},
		{field:'OrderSkinTest',title:'皮试',width:50},
		{field:'OrderRecDep',title:'接收科室',width:110},
		{field:'OrderUserDep',title:'开医嘱科室',width:110},
		{field:'OrderSum',title:'金额',width:80},
		//{field:'OrderPrescNo',title:'处方号',width:115},
		{field:'OrderDepProcNote',title:'备注',width:100},
		{field:'OrderDoc',title:'开医嘱人',width:80},
		{field:'OrderUserAdd',title:'录入人',width:80},
		{field:'OrderMasterSeqNo',title:'关联',width:100,
			formatter: function(value,row,index){
				if (row['OrderSeqNo'].indexOf(".")>=0){
					return row['OrderSeqNo'].split(".")[0];
				}
			}
		},
		//{field:'OrderLabEpisodeNo',title:'检验号',width:100}
    ]]
	var OrdListTabDataGrid=$("#OrdListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		idField:'OrderSeqNo',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			if (PageLogicObj.m_selRowIndex!="") return false;
			ChangeLinkItemSelect(index,row);
		},
		onUncheck:function(index, row){
			if (PageLogicObj.m_selRowIndex!="") return false;
			CacallLinkItemSelect(row['OrderSeqNo'],"");
		}
	}); 
	return OrdListTabDataGrid;
}
function OrdListTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCOEOrdItem",
	    QueryName : "FindUnActiveOrderItems",
	    EpisodeID:ServerObj.EpisodeID,
	    //Pagerows:PageLogicObj.m_OrdListTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_OrdListTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_OrdListTabDataGrid.datagrid('loadData',GridData); //datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).
		if (parent){
			RefreshTabsTitleAndStyle();
		}
		CheckUpdateTime(false);
	}); 
}
function UpdateClickHandler(){
	var rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getSelections');
	if (rows.length==0){
		$.messager.alert("提示","请选择需要审核的医嘱!");
		return false;
	}
	if (!CheckUpdateTime(true)) return false;
	var OrderItemStr=GetOrderDataOnAdd();
	var ret=$.cm({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"SavePractiseDocOrderItems",
		Adm:ServerObj.EpisodeID, User:session['LOGON.USERID'], OrdItemStr:OrderItemStr, loc:session['LOGON.CTLOCID'],
		dataType:"text"
	},false)
	OrdListTabDataGridLoad();
	return false;
}
function DeleteClickHandler(){
	var rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getSelections');
	if (rows.length==0){
		$.messager.alert("提示","请选择需要删除的医嘱!");
		return false;
	}
	var OrderItemStr=GetOrderDataOnAdd();
    for (var i=0;i<OrderItemStr.split("^").length;i++) {
    	var OEItemRowid=OrderItemStr.split("^")[i];
		var ret=$.cm({
			ClassName:"web.DHCOEOrdItem",
			MethodName:"DeleteUnActiveOrderItems",
			OrdItemStr:OEItemRowid, UserID:session['LOGON.USERID'],
			dataType:"text"
		},false)
		if (ret!="0") {
				$.messager.alert("提示","删除失败!");
				return false;
		}
		var LinkOrderStr=$.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"GetLinkOrdItem",
			MaiOrdID:OEItemRowid, Type:1,
			dataType:"text"
		},false)
		if (LinkOrderStr!=""){
			var LinkOrderStrArry=LinkOrderStr.split("^");
			var LinkOrderLeng=LinkOrderStrArry.length;
			for (var J=0;J<LinkOrderLeng;J++){
					var ret=$.cm({
						ClassName:"web.DHCOEOrdItem",
						MethodName:"DeleteUnActiveOrderItems",
						OrdItemStr:LinkOrderStrArry[J], UserID:session['LOGON.USERID'],
						dataType:"text"
					},false)
				}
			}
    }
    OrdListTabDataGridLoad();
    return false;
}
function CheckUpdateTime(SelectFlag){
	var myret=true;
	var CurrDateTime=$.cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetCurrentDateTime",
		DateFormat:"3",
		TimeFormat:"1",
		dataType:"text"
	},false)
	var CurrDateTimeArr=CurrDateTime.split("^");
	var CurrDate=CurrDateTimeArr[0];
  	var CurrTime=CurrDateTimeArr[1];
	//小于当前时间30分钟按钮不可以选择
	var Rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getRows');
	for (var i=0;i<Rows.length;i++){
		var OrderName=Rows[i]['OrderName'];
		var OrderStartDate=Rows[i]['OrderStartDate'];
		var OrderStartTime=Rows[i]['OrderStartTime']; 
		var OrderLinkTo=Rows[i]['OrderLinkTo']; 
		var OrderStatusCode=Rows[i]['OrderStatusCode']; 
		var OrderItemRowid=Rows[i]['OrderItemRowid']; 
		if ($("input[value='"+OrderItemRowid+"']").is(':checked')==SelectFlag) {
			if ((OrderStatusCode=="I")&&(OrderStartDate==CurrDate)&&(OrderStartTime<CurrTime)&&(OrderLinkTo=="")){
				if (CheckTime(CurrTime,OrderStartTime,30)) {
					var SeqNo=Rows[i]['OrderSeqNo']; 
					var arry1=SeqNo.split(".");
					var MasterSeqNo=arry1[0];
					CacallLinkItemSelect(MasterSeqNo,"red");
					//PageLogicObj.m_OrdListTabDataGrid.datagrid('uncheckAll');
					myret=false;
				}
			}
		}
	}
	if (myret==false) {
		$.messager.alert("提示","医嘱开始时间最多只能小于当前时间30分钟,红色医嘱为不符合项目,请确认!");
	}
	return myret;
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
function CacallLinkItemSelect(Row,RowColor){
    try{
	    var rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getRows');
	    var index=PageLogicObj.m_OrdListTabDataGrid.datagrid('getRowIndex',Row);
	    var LinkOrderItemMain=rows[index]['LinkOrderItem'];
		var OrderItemRowidMain=rows[index]['OrderItemRowid'];
		for (var j=0; j<rows.length; j++) {
			var LinkOrderItem=rows[j]['LinkOrderItem']; 
			var OrderItemRowid=rows[j]['OrderItemRowid']; 
			if (LinkOrderItemMain!=""){
				if ((OrderItemRowid==LinkOrderItemMain)||(LinkOrderItem==LinkOrderItemMain)){
					if (RowColor!="") {
					 	$("#datagrid-row-r1-2-"+j).css('color',RowColor);
					}else{
						PageLogicObj.m_selRowIndex=j;
					}
					var SelectFlag=$("input[value='"+OrderItemRowid+"']").is(':checked');
					if (SelectFlag){
						PageLogicObj.m_OrdListTabDataGrid.datagrid('uncheckRow',j);
					}
				}
			}else{
				if ((OrderItemRowidMain==LinkOrderItem)||(OrderItemRowidMain==OrderItemRowid)){
					if (RowColor!="") {
					 	$("#datagrid-row-r1-2-"+j).css('color',RowColor);
					}else{
						PageLogicObj.m_selRowIndex=j;
					}
					var SelectFlag=$("input[value='"+OrderItemRowid+"']").is(':checked');
					if (SelectFlag){
						PageLogicObj.m_OrdListTabDataGrid.datagrid('uncheckRow',j);
					}
				}
			}
		}
		PageLogicObj.m_selRowIndex="";
    }catch(e){$.messager.alert("提示",e.message)}
}
function GetOrderDataOnAdd() {
  var OrderItemStr=""; 
  var OrderItem=""; 
  var OneOrderItem="";
	try{
		var rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getSelections');
		for (var i=0; i<rows.length; i++){
			var OrderItemRowid=rows[i]['OrderItemRowid']; 
			var OrderARCIMRowid=rows[i]['OrderARCIMRowid']; 
			var LinkOrderItem=rows[i]['LinkOrderItem'];
			var LinkOrderItem=LinkOrderItem.replace(/(^\s*)|(\s*$)/g,'');
			if  (LinkOrderItem!=""){OrderItemRowid=LinkOrderItem} ;//只传入主医嘱
			if ((OrderARCIMRowid!="")&&(OrderItemRowid!="")){	
				if (OrderItemStr==""){
					OrderItemStr=OrderItemRowid;
				}else{
					if (("^"+OrderItemStr+"^").indexOf(("^"+OrderItemRowid+"^"))<0){
						OrderItemStr=OrderItemStr+"^"+OrderItemRowid
					}
				}
			}
		}
	}catch(e){$.meaagert.alert("提示",e.message)}
	return OrderItemStr;
}
function ChangeLinkItemSelect(index,row){
    try{
	    var LinkOrderItemMain=row['LinkOrderItem'];
		var OrderItemRowidMain=row['OrderItemRowid']; 
		var rows=PageLogicObj.m_OrdListTabDataGrid.datagrid('getRows');
		for (var i=0; i<rows.length; i++) {
			if (i==index) continue;
			var LinkOrderItem=rows[i]['LinkOrderItem']; 
			var OrderItemRowid=rows[i]['OrderItemRowid']; 
			var SelectFlag=$("input[value='"+OrderItemRowid+"']").is(':checked');
			if (LinkOrderItemMain!=""){
				if (((OrderItemRowid==LinkOrderItemMain)||(LinkOrderItem==LinkOrderItemMain))&&(SelectFlag==false)){
					PageLogicObj.m_selRowIndex=i;
					PageLogicObj.m_OrdListTabDataGrid.datagrid('checkRow',i);
				}
			}else{
				if ((OrderItemRowidMain==LinkOrderItem)&&(SelectFlag==false)){
					PageLogicObj.m_selRowIndex=i;
					PageLogicObj.m_OrdListTabDataGrid.datagrid('checkRow',i);
				}
			}
		}
		PageLogicObj.m_selRowIndex="";
    }catch(e){$.messager.alert("提示",e.message)}
}
function RefreshTabsTitleAndStyle(){
	if (parent.refreshTabsTitleAndStyle){
		var options=parent.$('#tabsReg').tabs("getSelected").panel('options');
		var title=options.title.split("(")[0];
		var code=options.id;
		var RetJson=$.cm({
			ClassName:"websys.DHCChartStyle",
			MethodName:"GetVerifyStyle",
			PatientID:"", EpisodeID:ServerObj.EpisodeID, mradm:"",
			dataType:"text"
		},false)
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
		if (parent.UpdateTabsTilte) {
			parent.UpdateTabsTilte();
		}
		if (parent.refreshBar){
			parent.refreshBar();
		}
	}
}