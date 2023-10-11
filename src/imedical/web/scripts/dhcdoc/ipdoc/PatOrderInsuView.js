var PageLogicObj={
	m_OrderTableDataGrid:"",
	m_OrderExecTableDataGrid:"",
	Order_selRowIndex:"",
	OrderDetail_selRowIndex:"",
	m_DiagListTableDataGrid:""
}
var GlobalObj={
	DefaultExpendTemplateOnPopTemplate:""
	}
var GridParams={};
var OrderDetailGridParams={};
var DATE_FORMAT;
$(function(){
	//页面数据初始化
	Init();
	//页面元素初始化
	PageHandle();
	if (ServerObj.EpisodeID!=""){
		LoadOrderTableDataGrid();
		initShowPatInfo();
		//SetDiagStr()
		LoadDiagListTableDataGrid()
		//ShowDiagStrDetail()
	}
	var Obj=document.getElementById('UnInsuPat');
	if (Obj){
		Obj.style.color="red"
		}
});

function Init(){
	PageLogicObj.m_OrderTableDataGrid=InitOrderTableDataGrid();
	PageLogicObj.m_OrderExecTableDataGrid=InitOrderDetailTableDataGrid();
	PageLogicObj.m_DiagListTableDataGrid=InitDiagListTableDataGrid();
}
function PageHandle(){
	if (ServerObj.DateFormat=="4"){
		//DD/MM/YYYY
        DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
	}else if(ServerObj.DateFormat=="3"){
		//YYYY-MM-DD
    	DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
	}
	
	//描述
	$('#orderDesc').keydown(function(e){
		if(e.keyCode==13){
			GridParams.inputOrderDesc=e.target.value;
			LoadOrderTableDataGrid();
		}
	});
	//开出科室
	var cbox = $HUI.combobox("#locDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.ViewLocDescData,
		onSelect: function (rec) {
			GridParams.stloc=rec.id;
			LoadOrderTableDataGrid();
		},
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#locDesc");
			sbox.select("3");
		}
	});
	//医嘱单型
	var cbox = $HUI.combobox("#nursebillDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data:ServerObj.ViewNurderBillData,
		onSelect: function (rec) {
			GridParams.nursebill=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	//范围
	var cbox = $HUI.combobox("#scopeDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.ViewScopeDescData,
		onSelect: function (rec) {
			GridParams.scope=rec.id;
			LoadOrderTableDataGrid();
		},
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#scopeDesc");
			sbox.select("1");
		}
	});
	//排序
	var cbox = $HUI.combobox("#OrderSort", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.ViewOrderSortData,
		onSelect: function (rec) {
			GridParams.SortType=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	$HUI.radio(".hisui-radio",{
	    onChecked:function(e,value){
	        GridParams.PriorType=e.target.value;
	    	LoadOrderTableDataGrid();
	    }
	});
	$HUI.combobox("#OrderCatTypeId", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.OrdReSubCatListJson,
		onSelect: function (rec) {
			GridParams.CatType=rec.id;
			LoadOrderTableDataGrid();
		},
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#OrderCatTypeId");
			sbox.select("ALL");
		}
	});
	//是否医保
	$HUI.combobox("#OrdISYB", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: eval("("+ServerObj.OrdISYBListJson+")"),
		onSelect: function (rec) {
			//alert(rec.id)
			GridParams.CoverMainInsFlag=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	//限制用药
	$HUI.combobox("#OrdLimitDrug", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: eval("("+ServerObj.OrdLimitDrugListJson+")"),
		onSelect: function (rec) {
			
			GridParams.limitFlag=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	$('#Startdate').datebox({
		onSelect: function (date) {
			var Startdate = $("#Startdate").datebox('getValue');
			GridParams.Startdate=Startdate;
			LoadOrderTableDataGrid();
		},onChange:function(newValue,oldValue){
			var result = newValue.match(/((^((1[8-9]\d{2})|([2-9]\d{3}))(-)(10|12|0?[13578])(-)(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(11|0?[469])(-)(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(0?2)(-)(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)(-)(0?2)(-)(29)$)|(^([3579][26]00)(-)(0?2)(-)(29)$)|(^([1][89][0][48])(-)(0?2)(-)(29)$)|(^([2-9][0-9][0][48])(-)(0?2)(-)(29)$)|(^([1][89][2468][048])(-)(0?2)(-)(29)$)|(^([2-9][0-9][2468][048])(-)(0?2)(-)(29)$)|(^([1][89][13579][26])(-)(0?2)(-)(29)$)|(^([2-9][0-9][13579][26])(-)(0?2)(-)(29)$))/);
			if(result==null)
        	{
            	//alert("请输入正确的日期格式");
            	return false;
        	}
			GridParams.Startdate=newValue;
			LoadOrderTableDataGrid();
		}
	});

	$("#Startdate").datebox('setValue',ServerObj.AdmDate);
	$('#Enddate').datebox({
		onSelect: function (date) {
			var Enddate = $("#Enddate").datebox('getValue');
			GridParams.Enddate=Enddate;
			LoadOrderTableDataGrid();
		},onChange:function(newValue,oldValue){
			var result = newValue.match(/((^((1[8-9]\d{2})|([2-9]\d{3}))(-)(10|12|0?[13578])(-)(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(11|0?[469])(-)(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(0?2)(-)(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)(-)(0?2)(-)(29)$)|(^([3579][26]00)(-)(0?2)(-)(29)$)|(^([1][89][0][48])(-)(0?2)(-)(29)$)|(^([2-9][0-9][0][48])(-)(0?2)(-)(29)$)|(^([1][89][2468][048])(-)(0?2)(-)(29)$)|(^([2-9][0-9][2468][048])(-)(0?2)(-)(29)$)|(^([1][89][13579][26])(-)(0?2)(-)(29)$)|(^([2-9][0-9][13579][26])(-)(0?2)(-)(29)$))/);
			if(result==null)
        	{
            	//alert("请输入正确的日期格式");
            	return false;
        	}
			GridParams.Enddate=newValue;
			LoadOrderTableDataGrid();
		}
	});
	$("#Enddate").datebox('setValue',ServerObj.CurrentDate);
}

function InitOrderTableDataGrid(){
	var DefaultOrderSort=GetArrayDefaultData(ServerObj.ViewOrderSortData);
	var DefaultLocDesc=GetArrayDefaultData(ServerObj.ViewLocDescData);
	var DefaultScopeDesc=GetArrayDefaultData(ServerObj.ViewScopeDescData);
	var DefaultNurderBill=GetArrayDefaultData(ServerObj.ViewNurderBillData);
	var DefaultOrdReSubCat=GetArrayDefaultData(ServerObj.OrdReSubCatListJson);
    ///papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "", 
    ///PriorType = "", CatType = "", SortType = "", OrderPriorType = "", InstrID = "", FreqID = "", focusOrdList
	GridParams={
        ClassName:"web.DHCDocInPatPortalCommon",
        QueryName:"FindInPatOrderForInsuView",
        papmi:ServerObj.PatientID,
        adm:ServerObj.EpisodeID,
        doctor:"",
        scope:DefaultScopeDesc,
        stloc:DefaultLocDesc,
        nursebill:"ALL",
        inputOrderDesc:"",
        PriorType:"ALL",
        CoverMainInsFlag:"",
        Enddate:"",
        Startdate:"",
        OrdLimitDrugFlag:"",
        CatType:DefaultOrdReSubCat,
        SortType:DefaultOrderSort
	};
	
	if (ServerObj.InsuInExeFlag=="Y"){
		var OrdToolBar=[/*{
			text: '批量修改为自动识别',
			iconCls: 'icon-update',
			handler: function() {ChangeOrderExecInsuBat("");}
		},*/{
			text: '批量修改为医保',
			iconCls: 'icon-upload-cloud',
			handler: function() {ChangeOrderExecInsuBat("Y");}
		},{
			text: '批量修改为自费',
			iconCls: 'icon-paper-pay',
			handler: function() {ChangeOrderExecInsuBat("N");}
		}];
	}else{
		var OrdToolBar=[/*{
				text: '批量修改为自动识别',
				iconCls: 'icon-update',
				handler: function() {ChangeOrderInsu("");}
			},*/{
				text: '批量修改为医保',
				iconCls: 'icon-upload-cloud',
				handler: function() {ChangeOrderInsu("Y");}
			},{
				text: '批量修改为自费',
				iconCls: 'icon-paper-pay',
				handler: function() {ChangeOrderInsu("N");}
			}];
	}
	if (ServerObj.warning!=""){
		var OrdToolBar=[{
				text: ServerObj.warning,
				id:"UnInsuPat"}]
		}
	var columns=[[
		{field:'TItemStatCode',hidden:true,title:''},
		{field:'TOeoriOeori',hidden:true,title:'',},
		{field:'PHFreqDesc1',hidden:true,title:''},
		{field:'TPermission',hidden:true,title:''},
		{field:'TItemStatCode',hidden:true,title:''},
		//{field:'CoverMainIns',title:'是否医保',align:'center',width:80,auto:false},
		{field:'LimitOrdInfo',title:'限制用药信息',align:'center',width:300,auto:false},
		{field:'Priority',title:'医嘱类型',align:'center',width:105,auto:false},
        {field:'TdeptDesc',title:'开单科室',align:'center',width:155,auto:false},
		{field:'TDoctor',title:'开医嘱人',align:'center',width:100,auto:false},
		{field:'TStopDate',title:'停止时间',align:'center',width:140,auto:false,
			styler: function(value,row,index){
 				if ((value!="")&&(value!=" ")){
	 				var stopDate=value.split(" ")[0];
	 				if (stopDate>ServerObj.CurrentDate){
		 				return 'background-color:yellow';
		 			}
	 			}
 			}
		},
		{field:'TStopDoctor',title:'停止医生',align:'center',width:80,auto:false},
		{field:'TItemStatDesc',title:'状态',align:'center',width:80,auto:false,
			formatter:function(value,rec){ 
 				var btn =""; 
 				if (rec.OrderViewFlag=="Y"){
                	btn = '<a class="editcls" onclick="OpenOrderView(\'' + rec.OrderId + '\')">'+value+'</a>';
 				}else{
	 				btn=value;
	 			}
		        return btn;
            }
		},
		{field:'TRecDepDesc',title:'接收科室',align:'center',width:120,auto:false},
		{field:'OrderType',title:'医嘱子类类型',align:'center',width:60,auto:false},
		{field:'TBillUom',title:'计价单位',align:'center',width:80,auto:false},
		{field:'GroupSign',title:'组符号',align:'center',width:30,auto:false,
		 styler: function(value,row,index){
 			 return 'color:red;';
		 }
		},
		{field:'OrderId',title:'医嘱ID',align:'center',width:120,auto:false,
			formatter:function(value,rec){  
               var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>';
		       return btn;
            }
		},
		{field:'StopPermission',title:'StopPermission',width:30,auto:false,hidden:true},
		{field:'TItemStatCode',hidden:true},
		{field:'TPriorityCode',hidden:true},
		{field:'TStDateHide',hidden:true},
		{field:'TPHFreqCode',hidden:true},
		{field:'TOEORIAddDate',title:'开医嘱日期',align:'center',width:145,auto:false},
		{field:'OrderViewFlag',hidden:true},
		{field:'ZSQUrl',hidden:true},
		{field:'ORDVLRowID',hidden:true},
		{field:'IsCNMedItem',hidden:true},
		{field:'PopoverHtml',hidden:true}
		
	]];	
	var InPatOrdProperty={
		fit : true,
		width:1500,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		rownumbers : true,  //
		idField:'OrderId',
		columns :columns,
		toolbar :OrdToolBar,
        frozenColumns:[[
            {field:'CheckOrd',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
            {field:'TStDate',title:'医嘱开始时间',align:'center',width:150,auto:false},
            {field:'TOrderDesc',title:'医嘱',align:'left',width:420,auto:false,
                formatter: function(value,row,index){
                     var inparaOrderDesc=$("#orderDesc").val();
                     if (inparaOrderDesc!=""){
                         var tmpvalue=value.replace(/\&nbsp;/g,"").replace(/\&nbsp/g,"");
                        tmpvalue = tmpvalue.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
                    }else{
                        var tmpvalue=value;
                    }
                    var ordtitle=tmpvalue //.replace(reg1,'').replace(reg2,' ');
                    var PopoverHtml=row['PopoverHtml'];
                    return '<a class="editcls-TOrderDesc" id= "' + row["OrderId"] + '"onmouseover="ShowOrderDescDetail(this)">'+ordtitle+'</a>';
                    //return "<span title='" + ordtitle + "' class='hisui-tooltip'>" + value + "</span>";
                }
            },
            {field:'CoverMainIns',title:'医保',align:'center',width:50,auto:false,
                //hidden:(function(){
                 //   return (ServerObj.InsuInExeFlag=="Y")?true:false;
                //})(),
				formatter:function(value,rec){  
					if (value=="Y"){
						value=$g("是")
					}else if (value=="N"){
						value=$g("否")
					}
					return value;
				 }
            }
            
        ]],
        rowStyler:function(rowIndex, rowData){
			if (rowData.OrdStatus == "停止"){
				return 'background-color:pink;';
			}
			if (rowData.TOrderDesc==""){
				return 'display:none';
				}
		},
		onLoadSuccess:function (data){
			
		},
		onDblClickRow :function(rowIndex, rowData){   //  onDblClickRow  onClickRow
			OrdDataGridDbClick(rowIndex, rowData);
		},
		onCheck:function(rowIndex,rowData){
			//常规设置-》住院医生修改医保标识成组全部选中
			if (ServerObj.OrdGroupSelect!=1) return false;
			var OrderId=rowData.OrderId;
			//alert(PageLogicObj.Order_selRowIndex)
			if ((PageLogicObj.Order_selRowIndex!=="")||(OrderId.indexOf("||")<0)){
				return false;
			}
			var TOeoriOeori=rowData.TOeoriOeori;
			var GroupSign=rowData.GroupSign;
			//var OrdList=InPatOrdDataGrid.datagrid('getData');
			if (ServerObj.OrderViewScrollView=="1"){
				var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getData').originalRows;
            }else{
	        	var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
			}
			var NurseLinkOrderRowId=rowData.NurseLinkOrderRowId;
			//勾选主医嘱
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
					if ((myTOeoriOeori==OrderId)){
						PageLogicObj.Order_selRowIndex=idx;
						PageLogicObj.m_OrderTableDataGrid.datagrid('checkRow',idx);
					}
				}
			}else if (TOeoriOeori.indexOf("||")>=0){ //勾选子医嘱 存在空行的情况
				var MasterrowIndex=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
				if (MasterrowIndex>=0){
					PageLogicObj.m_OrderTableDataGrid.datagrid('checkRow',MasterrowIndex);
				}
			}
			PageLogicObj.Order_selRowIndex="";
			//OrdDataGridDbClick(rowIndex, rowData);
		},
		onUncheck:function(rowIndex,rowData){
			//常规设置-》住院医生修改医保标识成组全部选中
			if (ServerObj.OrdGroupSelect!=1) return false;
			
			var OrderId=rowData.OrderId;
			if ((PageLogicObj.Order_selRowIndex!=="")||(OrderId.indexOf("||")<0)) return false;
			var OrderId=rowData.OrderId;
			var TOeoriOeori=rowData.TOeoriOeori;
			var GroupSign=rowData.GroupSign;
			if (ServerObj.OrderViewScrollView=="1"){
				var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getData').originalRows;
            }else{
	        	var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
			}
			// //勾选主医嘱
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
			 		if ((myTOeoriOeori==OrderId)){
			 			PageLogicObj.Order_selRowIndex=idx;
			 			PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckRow',idx);
			 		}
			 	}
			 }else if (TOeoriOeori!=""){ //勾选子医嘱
			 	var MasterrowIndex=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
			 	if (MasterrowIndex>=0){
			 		PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckRow',MasterrowIndex);
			 	}
			 }
			PageLogicObj.Order_selRowIndex="";
			/*
			if (PageLogicObj.m_OrderExecTableDataGrid) {
				//$('#OrdExecPannel').panel('setTitle',);
				$('#mainPanel').layout('panel', 'east').panel('setTitle',"执行记录");
				PageLogicObj.m_OrderExecTableDataGrid.datagrid('uncheckAll').datagrid('loadData',[]);
			}*/
		}
    };
	if (ServerObj.OrderViewScrollView=="1"){
		$.extend(InPatOrdProperty,{
			pagination : false,
			view:scrollview,
			pageSize:(ServerObj.ViewIPDocPatInfoLayOut=="2"?20:30),	//每次初始化的条数
			ScrollView:1	//后台query接收，是否分页
		});
	}else{
		$.extend(InPatOrdProperty,{
			pagination : true,
			pageSize: (ServerObj.ViewIPDocPatInfoLayOut=="2"?10:15),
			pageList : (ServerObj.ViewIPDocPatInfoLayOut=="2"?[10,100,200]:[15,100,200]),
			ScrollView:0
		});
	}
	$.extend(InPatOrdProperty,{loadFilter:DocToolsHUI.lib.pagerFilter});
	var OrderTableDataGrid=$("#OrderTable").datagrid(InPatOrdProperty);
	return OrderTableDataGrid;
}

function LoadOrderTableDataGrid(){
	if (ServerObj.OrderViewScrollView=="1"){
		var pageSize=99999;
	}else{
		var pageSize=PageLogicObj.m_OrderTableDataGrid.datagrid("options").pageSize;
	}
	$.q({
	    ClassName : GridParams.ClassName,
	    QueryName : GridParams.QueryName,
	    papmi:GridParams.papmi,
        adm:GridParams.adm,
        doctor:GridParams.doctor,
        scope:GridParams.scope,
        stloc:GridParams.stloc,
        nursebill:"ALL",
        inputOrderDesc:GridParams.inputOrderDesc,
        PriorType:GridParams.PriorType,
        CatType:GridParams.CatType,
        SortType:GridParams.SortType,
        EdDate:GridParams.Enddate,
        StDate:GridParams.Startdate,
        OrdLimitDrugFlag:GridParams.limitFlag,
        CoverMainInsFlag:GridParams.CoverMainInsFlag,
		ScrollView:PageLogicObj.m_OrderTableDataGrid.datagrid("options").ScrollView,
	    Pagerows:pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
		if (PageLogicObj.m_OrderExecTableDataGrid) PageLogicObj.m_OrderExecTableDataGrid.datagrid('uncheckAll').datagrid('loadData',[]);
	}); 
}
function OrdDataGridDbClick(rowIndex, rowData,type){
	 if (typeof PageLogicObj.m_OrderExecTableDataGrid=="object"){
        PageLogicObj.m_OrderTableDataGrid.datagrid("clearChecked");
        //保证双击或右键时只选中这一行,主要针对成组医嘱
        PageLogicObj.Order_selRowIndex=rowIndex
        PageLogicObj.m_OrderTableDataGrid.datagrid("checkRow", rowIndex);
        PageLogicObj.Order_selRowIndex=""
        $.extend(OrderDetailGridParams,{orderId:rowData.OrderId});
		LoadOrderExecTable();
    }
}
function InitOrderDetailTableDataGrid(){
	if ($("#OrdExecTable").length==0){
		return null;
	}
	OrderDetailGridParams={
		ClassName:"web.DHCDocInPatPortalCommon",
		QueryName:"FindOrderExecDet",
        orderId:"",
        execStDate:"",
        execEndDate:""
	};
	var OrdExecToolBar=[/*{
		text: '修改为自动识别',
		iconCls: 'icon-update',
		handler: function() {ChangeOrderExecInsu("");}
	},*/{
		text: '修改为医保',
		iconCls: 'icon-upload-cloud',
		handler: function() {ChangeOrderExecInsu("Y");}
	},{
		text: '修改为自费',
		iconCls: 'icon-paper-pay',
		handler: function() {ChangeOrderExecInsu("N");}
	}];
	if (ServerObj.warning!=""){
		var OrdExecToolBar=[]
		}
    var OrdExecColumns=[[ 
        {field:'CheckOrdExec',title:'选择',checkbox:'true'},
        {field:'OrderExecId',hidden:true},
        {field:'TExStDate',title:'要求执行时间',width:110},
		
		{field:'CoverMainIns',title:'医保',align:'center',width:50,auto:false,
			formatter:function(value,rec){  
				if (value=="Y"){
					value=$g("是")
				}else if (value=="N"){
					value=$g("否")
				}
				return value;
			}
		},
        {field:'OrdExecBillQty',title:'计费数量',width:80},
        {field:'TExecState',title:'状态',width:80,
            styler: function(value,row,index){
                if (row.TExecStateCode){
                    if( [$g("未执行"),"D","C"].indexOf(row.TExecStateCode) > -1 ){
                        return "background-color: yellow;"
                    }
                }
            }
        },
		{field:'TBillState',title:'账单状态',width:80,
			formatter:function(value,rec){  
				var btn = '<a class="editcls" onclick="execFeeDataShow(\'' + rec.OrderExecId + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'TRealExecDate',title:'执行时间',width:110},
        {field:'THourExEnTime',title:'小时医嘱结束时间',width:130},
        
        {field:'TExecRes',title:'执行原因',width:100},
        {field:'TExecFreeRes',title:'免费原因',width:100,hidden:true},
        {field:'TExecUser',title:'处理人',width:80},
        {field:'TExecLoc',title:'处理科室',width:80},
        {field:'ExecPart',title:'检查部位',width:80},
       
        {field:'TExecFreeChargeFlag',title:'免费状态',width:100,hidden:true},
        
        {field:'TgiveDrugQty',title:'发药数量',width:80},
        {field:'TcancelDrugQty',title:'退药数量',hidden:true,width:80},
        {field:'Notes',title:'备注',width:100},
        {field:'TPBOID',title:'账单号',width:80},
        {field:'TApplyCancelStatus',hidden:true},
        {field:'TExDateTimes',hidden:true},
        {field:'IsCancelArrivedOrd',hidden:true},
        {field:'TExecStateCode',hidden:true},
        {field:'TPriorityCode',title:'医嘱类型code',hidden:true},
        {field:'TBillUom',hidden:true},
    ]];
    InPatOrdExecDataGrid=$("#OrdExecTable").datagrid({  
        fit : true,
        width:1500,
        border : false,
        striped : true,
        singleSelect : false,
        fitColumns : false,
        autoRowHeight : false,
        rownumbers:true,
        pagination : true,  //
        rownumbers : true,  //
        pageSize: 10,
        pageList : [10,100,200],
        idField:'OrderExecId',
        columns :OrdExecColumns,
        toolbar:OrdExecToolBar,
        onRowContextMenu:function(e, rowIndex, rowData){
            ShowGridRightMenu(e,rowIndex, rowData,"OrdExec");
        }
    });

	InPatOrdExecDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return InPatOrdExecDataGrid;
}
function LoadOrderExecTable(){


	$.q({
	    ClassName : OrderDetailGridParams.ClassName,
	    QueryName : OrderDetailGridParams.QueryName,
	    orderId:OrderDetailGridParams.orderId,
	    Pagerows:9999,rows:99999
	},function(GridData){
		var val=$.m({
		    ClassName:"web.DHCDocMain",
		    MethodName:"getExecDateScope",
		    orderId:OrderDetailGridParams.orderId,
		    execBarExecNum:"1-2"
		},false);
		var OrdInfo=val.split("^")[2];
		
		//$('#OrdExecPannel').panel('setTitle',OrdInfo);
		$('#leftPanel').layout('panel', 'east').panel('setTitle',OrdInfo);

		PageLogicObj.m_OrderExecTableDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	}); 
}
function SetDiagStr(){
	var val=$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"GetMRDiagnosDesc",
		    PAAdmRowid:ServerObj.EpisodeID,
		    DelimStr:" "
		},false);
		//alert(val)
		var valArr=val.split("^")
		var Obj=document.getElementById('DiagStr');
		Obj.innerText=valArr[0]
		var Obj=document.getElementById('DiagStr1');
		if (valArr[1]) Obj.innerText=valArr[1]
		var Obj=document.getElementById('DiagStr2');
		if (valArr[2]) Obj.innerText=valArr[2]
		//innerText
	}
function ShowDiagStrDetail(){
	/*
	onmouseover="ShowDiagStrDetail(this)"
	var val=$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"GetMRDiagnosForPopover",
		    PAAdmRowid:ServerObj.EpisodeID,
		    DelimStr:"<br/>"
		},false);
	var content=val
	var len=content.split("<br/>").length;
	if (len>5) MaxHeight=150,placement="bottom-right";
	else MaxHeight='auto',placement="bottom-right";
	$(that).webuiPopover({
		title:'诊断：',
		content:content,
		trigger:'hover',
		placement:placement,
		style:'',
		height:MaxHeight,
		width:300
		
	});
	$(that).webuiPopover('show');*/
	//dhcdocinPatdiagnos.hui.csp
	var src="dhcdocinPatdiagnos.hui.csp?EpisodeID="+ServerObj.EpisodeID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='96%' scrolling='no' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialogNew("Find","诊断明细", 420, 210,"icon-green-line-eye","",$code,"");
	var Obj=document.getElementById("Find");
    debugger

	
}
function createModalDialogNew(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class=''></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    var collapsed=false;
    $("#"+id).dialog({
	    zIndex:99999,
        title: _title,
        width: _width,
        height: "auto",
        cache: false,
        iconCls: _icon,
        collapsible: true,
        minimizable:false,
        maximizable: false,
        collapsed:collapsed,
        modal: false,
        closed: false,
        closable: false,
        //headerCls:'panel-header-gray',
        content:_content,
        buttons:_btntext,
        inline:true,
        resizable:false,
        isTopZindex:true,
        left:$(window).width()-1120,
        top:53,
        onClose:function(){
	        //destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
    
}
function ShowOrderDescDetail(that){
	
	var OrderRowId=that.id;
	var index=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',OrderRowId);

    var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
	var content=rows[index]['PopoverHtml'];
	var contentFlag=content.split("@")[0]; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
	var content=content.split("@")[1];
	if ((contentFlag==0)&&($(that).width()<450)) return false;
	var MaxHeight=20;
	var len=content.split("<br/>").length;
	if (len>5) MaxHeight=150,placement="right";
	else MaxHeight='auto',placement="top";
	$(that).webuiPopover({
		title:'',
		content:content,
		trigger:'hover',
		placement:placement,
		style:'inverse',
		height:MaxHeight
		
	});
	$(that).webuiPopover('show');
}

function ordDetailInfoShow(OrdRowID){
	websys_showModal({
		url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
		title:'医嘱明细',
		width:400,height:screen.availHeight-200
	});
}
function OpenOrderView(OEItemID){
	websys_showModal({
		url:"dhc.orderview.csp?ord=" + OEItemID,
		title:'医嘱查看',
		width:screen.availWidth-200,height:screen.availHeight-200
	});
}
function ChangeOrderExecInsuBat(CoverMainInsFlag) {
	var OrdRowStr=GetSelOrdRowStr(PageLogicObj.m_OrderTableDataGrid);
	if (OrdRowStr==""){
		$.messager.alert("提示","没有勾选医嘱!")
		return "";
	}
	$.cm({
		ClassName : "web.DHCDocInPatPortalCommon",
		MethodName : "ChangeOrdCovMainInsuFlag",
		TableName : "OE_OrdItem",
		IDs:OrdRowStr,
		CoverMainInsFlag:CoverMainInsFlag,
		dataType:"text"
	},function(ret){
		if (ret==0){
			//$.messager.popover({msg: '批量更新执行记录成功！',type:'info',timeout: 2000,showType: 'show'});
			//LoadOrderExecTable();
		}else{
			$.messager.alert("提示","更新失败,"+ret);
			return false;
		}
	});
	
	$.cm({
		ClassName : "web.DHCDocInPatPortalCommon",
		MethodName : "ChangeOrdCovMainInsuFlag",
		TableName : "OE_OrdExec",
		IDs:OrdRowStr,
		CoverMainInsFlag:CoverMainInsFlag,
		dataType:"text"
	},function(ret){
		if (ret==0){
			$.messager.popover({msg: '批量更新执行记录成功！',type:'info',timeout: 2000,showType: 'show'});
			LoadOrderTableDataGrid();
			LoadOrderExecTable();
		}else{
			$.messager.alert("提示","更新失败,"+ret);
			return false;
		}
	});
}

function ChangeOrderExecInsu(CoverMainInsFlag){
	var OrdExecRowStr=GetSelOrdRowStr(PageLogicObj.m_OrderExecTableDataGrid);
	if (OrdExecRowStr==""){
		$.messager.alert("提示","没有勾选执行记录!")
		return "";
	}
	
	$.cm({
		ClassName : "web.DHCDocInPatPortalCommon",
		MethodName : "ChangeOrdCovMainInsuFlag",
		TableName : "OE_OrdExec",
		IDs:OrdExecRowStr,
		CoverMainInsFlag:CoverMainInsFlag,
		dataType:"text"
	},function(ret){
		if (ret==0){
			LoadOrderExecTable();
			LoadOrderTableDataGrid();
		}else{
			$.messager.alert("提示","更新失败,"+ret);
			return false;
		}
	});
}
function ChangeOrderInsu(CoverMainInsFlag){
	
	var OrdRowStr=GetSelOrdRowStr(PageLogicObj.m_OrderTableDataGrid);
	if (OrdRowStr==""){
		$.messager.alert("提示","没有勾选医嘱!")
		return "";
	}
	
	$.cm({
		ClassName : "web.DHCDocInPatPortalCommon",
		MethodName : "ChangeOrdCovMainInsuFlag",
		TableName : "OE_OrdItem",
		IDs:OrdRowStr,
		CoverMainInsFlag:CoverMainInsFlag,
		dataType:"text"
	},function(ret){
		if (ret==0){
			LoadOrderTableDataGrid();
		}else{
			$.messager.alert("提示","更新失败,"+ret);
			return false;
		}
	});

	
}

function GetSelOrdRowStr(table$){
	var OrderStr=""
	
	var ScrollView=table$.datagrid("options").ScrollView;
	var idField=table$.datagrid("options").idField;
	var state = table$.data('datagrid');
	var dc = state.dc;
	dc.header1.find('input[type=checkbox]');
	//滚动加载模式下，是否进行了全选操作
	if ((dc.header1.find('input[type=checkbox]').is(':checked'))&&(ScrollView=="1")){
		var SelOrdRowArr = PageLogicObj.m_OrderTableDataGrid.datagrid('getData').originalRows;
	}else{
		var SelOrdRowArr=table$.datagrid('getChecked'); //医嘱处理以勾选为准,未勾选代表不处理
	}
	if (SelOrdRowArr.length==0){
	  
	   return OrderStr;
	}
	var ORDVLRowIDStr="";
	var NorOrderStr="";
	var Length=0
	$.each(SelOrdRowArr,function(Index,RowData){
		if (OrderStr==""){
			OrderStr=RowData[idField]
		}else{
			OrderStr=OrderStr+"^"+RowData[idField]
		}
		++Length;
		
	});
	if (Length==0){
	  
	   return OrderStr;
	}
	
	return OrderStr;
}

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
		
}
function GetCurTime(){
   function p(s) {
	   return s < 10 ? '0' + s: s;
   }
   var myDate = new Date();
   var h=myDate.getHours();       //获取当前小时数(0-23)
   var m=myDate.getMinutes();     //获取当前分钟数(0-59)
   var s=myDate.getSeconds();  
   var nowTime=p(h)+':'+p(m)+":"+p(s);
   return nowTime;
}
function myparser(s){
	if (!s) return new Date();
	if (ServerObj.DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(ServerObj.DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
		
}
function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}
/**
	 * 创建一个模态 Dialog
	 * @param id divId
	 * @param _url Div链接
	 * @param _title 标题
	 * @param _width 宽度
	 * @param _height 高度
	 * @param _icon ICON图标
	 * @param _btntext 确定按钮text
    */
 function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	if(_btntext==""){
		var buttons=[];
	}else{
		var buttons=[{
			 text:_btntext,
			 iconCls:_icon,
			 handler:function(){
				 if(_event!="") eval(_event);
			 }
		 }]
	}
	//如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
	buttons.push({
		text:$g('关闭'),
		 iconCls:'icon-w-close',
		 handler:function(){
				destroyDialog(id);
		 }
	});
	 $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
	 if (_width == null)
		 _width = 800;
	 if (_height == null)
		 _height = 500;

	 $("#"+id).dialog({
		 title: _title,
		 width: _width,
		 height: _height,
		 cache: false,
		 iconCls: _icon,
		 collapsible: false,
		 minimizable:false,
		 maximizable: false,
		 resizable: false,
		 modal: true,
		 closed: false,
		 closable: false,
		 content:_content,
		 buttons:buttons
	 });
}
function IsValidTime(time){
   if (time.split(":").length==3){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
   }else if(time.split(":").length==2){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
   }else{
	   return false;
   }
   if(!TIME_FORMAT.test(time)) return false;
   return true;
}

function GetArrayDefaultData(Arr){
	var DefaultData="";
	for (var i=0;i<Arr.length;i++){
		if (typeof Arr[i].selected !="undefiend"){
			if (Arr[i].selected == true){
				DefaultData=Arr[i].id;
			}
		}
		if (DefaultData!=""){
			break;
		}
	}
	if (DefaultData==""){
		DefaultData=Arr[0].id;
		$.extend(Arr[0],{selected:true});
	}
	return DefaultData;
}


function xhrRefresh(Args){
	LoadOrderTableDataGrid();
}
function ShowOrderDescDetail(that){
    
    var OrderRowId=that.id;
    var index=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',OrderRowId);
    if (ServerObj.OrderViewScrollView=="1"){
        var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getData').originalRows;
    }else{
        var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
    }
    var content=rows[index]['PopoverHtml'];
    var contentFlag=content.split("@")[0]; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
    var content=content.split("@")[1];
    if ((contentFlag==0)&&($(that).width()<400)) return false;
    var MaxHeight=20;
    var len=content.split("<br/>").length;
    if (len>5) MaxHeight=150,placement="right";
    else MaxHeight='auto',placement="top";
    $(that).webuiPopover({
        title:'',
        content:content,
        trigger:'hover',
        placement:placement,
        style:'inverse',
        height:MaxHeight
        
    });
    $(that).webuiPopover('show');
}

function execFeeDataShow(execRowId){
    destroyDialog("execFeeDiag");
    var Content="<table id='tabExecFee' cellpadding='5' style='margin:5px;border:none;'></table>";
    var iconCls="";
    createModalDialog("execFeeDiag",$g("费用明细"), 550, 350,iconCls,"",Content,"");
     
    var ExecFeeColumns=[[ 
                  {field:'FeeId',hidden:true,title:''},
                  {field:'TCancelStatu',hidden:true,title:''},
                  {field:'TTarDesc',title:'收费项名称'},
                  {field:'TTarCode',title:'代码'},
                  {field:'TQty',title:'数量'},
                  {field:'TPrice',title:'单价'},
                  {field:'TAmount',title:'金额'},
                  {field:'TDate',title:'记账时间'},
                  {field:'TExtralComment',title:'原因'}
     ]]
     InPatExecFeeDataGrid=$("#tabExecFee").datagrid({  
         fit : true,
         border : false,
         striped : true,
         singleSelect : false,
         fitColumns : false,
         autoRowHeight : false,
         rownumbers:true,
         pagination : true,  
         rownumbers : true,  
         pageSize: 10,
         pageList : [10,100,200],
         idField:'FeeId',
         columns :ExecFeeColumns
     });
     $.q({
         ClassName : "web.DHCDocInPatPortalCommon",
         QueryName : "FindOrderFee",
         orderId : execRowId,
         Pagerows:InPatExecFeeDataGrid.datagrid("options").pageSize,rows:99999
     },function(GridData){
         InPatExecFeeDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
     });
 }
 function initShowPatInfo(){
	if(typeof InitPatInfoBanner=='function'){
		return InitPatInfoBanner();
	}
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:ServerObj.EpisodeID,PatientID:""},function(html){
		if (html!=""){
		//if (false){
			$(".PatInfoItem").html(reservedToHtml(html));
			$(".PatInfoItem").popover({
				width:$(".PatInfoItem").width(),
				trigger:'hover',
				arrow:false,
				style:'patinfo',
				content:"<div class='patinfo-hover-content'>"+$(".PatInfoItem")[0].innerHTML+"</div>"
			});

		}
	});
}




function InitDiagListTableDataGrid(){

	
	var columns=[[
		{field:'MRDiagDesc',title:'诊断名称',align:'center',width:290},
		{field:'LimitOrdInfo',title:'诊断ID',hidden:"true"},
		{field:'DocName',title:'诊断医生',align:'center',width:100},
		
		
	]];	
	var InPatDiagProperty={
		fit : true,
		width:1500,
		border : false,
		//striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		rownumbers : true,  //
		idField:'OrderId',
		toolbar:[],
		columns :columns,
		pageSize: 100,
		onCheck:function(rowIndex,rowData){
			//alert(1)
			return false;
			}
		
		//toolbar :OrdToolBar,
	}
	var DiagListTableDataGrid=$("#DiagList").datagrid(InPatDiagProperty);
	return DiagListTableDataGrid;
}

function LoadDiagListTableDataGrid(){
	$.q({
	    ClassName:"web.DHCDocInPatPortalCommon",
        QueryName:"MRDiagnosQuery",
        PAAdmRowid:ServerObj.EpisodeID,
	    Pagerows:PageLogicObj.m_DiagListTableDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		//alert(GridData)
		PageLogicObj.m_DiagListTableDataGrid.datagrid('loadData',GridData);
	}); 
}

/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
