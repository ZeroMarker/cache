function InitTabAppQtyList() {
	var TabAppQtyListToolBar = [{
		id:'TRInfoCalculate',
        text: '初始化计算',
        iconCls: 'icon-cal-pen',
        handler: function() { 
        	TRInfoCalculateHandle();
        }
    }];
	var TabAppQtyListColumns=[[    
		{ field: 'TimeRange', title:'时段', width: 150, resizable: true, align:'center' }, 
		{ field: 'Qty', title:'数量', width: 80, resizable: true,
			editor: { 
				type: 'numberbox', 
				options: {
					required: true,
					onChange:function(newValue,oldValue){
					}
				}
			}
		}
	 ]];
	var TabAppQtyListDataGrid=$('#tabAppQtyList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		columns: TabAppQtyListColumns,
		toolbar: TabAppQtyListToolBar,
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){ 
       	},
       	onLoadSuccess:function(data){
			var Rows=$(this).datagrid('getRows');
			for (var i=Rows.length-1;i>=0;i--) {
				$(this).datagrid("beginEdit", i);
			}
			var TimeRangeFlag=GetTRFlag();
			if(TimeRangeFlag=="Y"){
				$("#TRInfoCalculate").linkbutton("enable");
			}else{
				$("#TRInfoCalculate").linkbutton("disable");
			}	
		}
	});
	return TabAppQtyListDataGrid;
}

function GetTRInfo() {
	var Max=$("#Max").val();
	var TimeRangeFlag="N",TimeRangeInfo="";
	var TRLength="",ReservedNum="",TRRegNumStr="",TRRegInfoStr="";
	var TimeRangeFlag=GetTRFlag();
	if(TimeRangeFlag=="Y"){
		//var TRStartTime=$("#TRStartTime").timespinner("getValue");
		//var TREndTime=$("#TREndTime").timespinner("getValue");
		var TRStartTime=$("#StartTime").timespinner("getValue");
		var TREndTime=$("#EndTime").timespinner("getValue");
		var TRLength=$("#TRLength").numberbox("getValue");
		var ReservedNum=$("#ReservedNum").numberbox("getValue");
		
		var Rows=PageLogicObj.m_TabAppQtyListDataGrid.datagrid('getRows');
		var TotalQty=0
		for (var i=0;i<Rows.length;i++) {
			var editors = PageLogicObj.m_TabAppQtyListDataGrid.datagrid('getEditors', i); 
			var Qty=editors[0].target.val();
			TotalQty=TotalQty+parseInt(Qty)
		}

		if(parseInt(TotalQty)==0){
			var ret=TRInfoCalculateHandle();
			if(!ret){
				return false;
			}else{
				var Rows=PageLogicObj.m_TabAppQtyListDataGrid.datagrid('getRows');
				for (var i=0;i<Rows.length;i++) {
					var editors = PageLogicObj.m_TabAppQtyListDataGrid.datagrid('getEditors', i); 
					var Qty=editors[0].target.val();
					TotalQty=TotalQty+parseInt(Qty)
				}
			}
		}
		if (parseFloat(TotalQty)!=parseFloat(Max)){
			$.messager.alert('提示','分时段总号数与最大预约数不等,请检查分时段信息列表每行数量相加总和是否等于最大预约数。',"warning");
			return false;
		}
		var TRRegNumStr="", TRRegInfoStr="",StNum=1
		for (var i=0;i<Rows.length;i++) {
			var TimeRange=Rows[i].TimeRange;
			var Qty=PageLogicObj.m_TabAppQtyListDataGrid.datagrid('getEditors', i)[0].target.val();
			Qty=parseInt(Qty);
			var EndNum=StNum+Qty-1
			var TRRegNum=StNum+"-"+EndNum
			StNum=EndNum+1
			var TRRegInfo=TimeRange
			if (TRRegNumStr=="") TRRegNumStr=TRRegNum
			else TRRegNumStr=TRRegNumStr+","+TRRegNum
			if (TRRegInfoStr=="") TRRegInfoStr=TRRegInfo
			else TRRegInfoStr=TRRegInfoStr+","+TRRegInfo
		}
	}
	TimeRangeInfo=TimeRangeFlag+"^"+TRLength+"^"+ReservedNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	return TimeRangeInfo;
}

function LoadTabAppQtyListDataGrid(Rowid,callBackFun,Type) {
	if(typeof Type=="undefined"){
		Type="Plan";	
	}
	var PlanRowid="",ScheduleRowid="";
	if(Type=="Plan"){
		PlanRowid=Rowid;	
	}else{
		ScheduleRowid=Rowid;
	}
	//$("#TRStartTime,#TREndTime").timespinner("setValue","");
	PageLogicObj.m_TabAppQtyListDataGrid.datagrid('loadData',[]); 
	if (Rowid=="") {
		if(typeof callBackFun == 'function'){
			callBackFun();
		}
	}else{
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			MethodName:"GetTRInfoByRowid",
			PlanRowid:PlanRowid,
			SchedRowId:ScheduleRowid,
			dataType:"json"
		},function(Data){
			//SetValue("TRStartTime",Data.TRStartTime);
			//SetValue("TREndTime",Data.TREndTime);
			PageLogicObj.m_TabAppQtyListDataGrid.datagrid('loadData',Data.TRInfo); 
			if(typeof callBackFun == 'function'){
				callBackFun();
			}
		})
	}
}

function TRInfoCalculateHandle(alertFlag)
{
	PageLogicObj.m_TabAppQtyListDataGrid.datagrid('loadData',[]);
	var TimeRangeFlag=GetTRFlag();
	if(TimeRangeFlag!="Y"){
		return false;
	}
	var StartTime=$("#StartTime").val();
	var EndTime=$("#EndTime").val();
	var TRStartTime=StartTime; //$("#TRStartTime").val();
	var TREndTime=EndTime; //$("#TREndTime").val();

	var Max=$("#Max").val();
	var TRLength=$("#TRLength").numberbox("getValue");
	var TRRowID=$('#TimeDesc').combobox('getValue');
	if (TRRowID=="") {
		if(alertFlag!="N"){
			$.messager.alert("提示", "请选择时段!","info",function(){
				$("#TRRowID").next('span').find("input").focus();
			});
		}
		return false;
	}
	if (Max=="") {
		if(alertFlag!="N"){
			$.messager.alert("提示", "最大预约数不能为空!","info",function(){
				$("#Max").focus();
			});
		}
		return false;
	}
	if (TRLength=="") {
		if(alertFlag!="N"){
			$.messager.alert("提示", "分时段间隔分钟数不能为空!","info",function(){
				$("#TRLength").focus();
			});
		}
		return false;
	}
	if (TRStartTime=="") {
		if(alertFlag!="N"){
			$.messager.alert("提示", "分时段开始时间不能为空!","info",function(){
				$("#TRStartTime").focus();
			});
		}
		return false;
	}
	if (TREndTime=="") {
		if(alertFlag!="N"){
			$.messager.alert("提示", "分时段结束时间不能为空!","info",function(){
				$("#TREndTime").focus();
			});
		}
		return false;
	}
	var DataObj=$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		MethodName:"TRInfoCalculate",
		TRStartTime:TRStartTime,
		TREndTime:TREndTime,
		TimeLength:TRLength,
		RegNum:Max,
		StartTime:StartTime,
		EndTime:EndTime,
		dataType:"json"
	},false);
	if (DataObj.Code!="0") {
		$.messager.alert("提示", DataObj.ErrMsg,"info");
		return false;
	}else {
		PageLogicObj.m_TabAppQtyListDataGrid.datagrid('loadData',DataObj.TRInfo); 
		return true;
	}
}

function ChangeTREleStyle(val){
	if(val){
		//$("#TRStartTime,#TREndTime").timespinner("enable")
		$("#TRLength,#ReservedNum").numberbox("enable");
		$("#TRInfoCalculate").linkbutton("enable");
		var StartTime=$("#StartTime").val();
		var EndTime=$("#EndTime").val();
		//$("#TRStartTime").timespinner("setValue",StartTime);
		//$("#TREndTime").timespinner("setValue",EndTime);
	}else{
		$("#TRInfoCalculate").linkbutton("disable");
		//$("#TRStartTime,#TREndTime").timespinner("disable");
		$("#TRLength,#ReservedNum").numberbox("disable");
		//$("#TRStartTime,#TREndTime").timespinner("setValue","");
		$("#TRLength,#ReservedNum").numberbox("setValue","");
		PageLogicObj.m_TabAppQtyListDataGrid.datagrid('loadData',[]);
	}		
}

function GetTRFlag(){
	var TimeRangeFlag=$("#TimeRangeFlag").checkbox('getValue');
	if(TimeRangeFlag){	
		TimeRangeFlag="Y";
	}else{
		TimeRangeFlag="N";	
	}
	return TimeRangeFlag;
}