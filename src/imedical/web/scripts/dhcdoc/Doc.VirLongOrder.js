var PageLogicObj={
	m_OrderTableDataGrid:"",
	m_OrderDetailTableDataGrid:"",
	Order_selRowIndex:"",
	OrderDetail_selRowIndex:"",
	HasGifDocList:new Array()		//�����Ƿ���ǩ��ͼƬ
}
var GridParams={};
var OrderDetailGridParams={};
var DATE_FORMAT;
$(function(){
	//ҳ�����ݳ�ʼ��
	Init();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	LoadOrderTableDataGrid();
});

function Init(){
	InitPatInfoBanner(ServerObj.EpisodeID);
	PageLogicObj.m_OrderTableDataGrid=InitOrderTableDataGrid();
	PageLogicObj.m_OrderDetailTableDataGrid=InitOrderDetailTableDataGrid();
}
function PageHandle(){
	if (ServerObj.DateFormat=="4"){
		//DD/MM/YYYY
        DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
	}else if(ServerObj.DateFormat=="3"){
		//YYYY-MM-DD
    	DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
	}
	
	//����
	$('#orderDesc').keydown(function(e){
		if(e.keyCode==13){
			GridParams.inputOrderDesc=e.target.value;
			LoadOrderTableDataGrid();
		}
	});
	//��������
	var cbox = $HUI.combobox("#locDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.ViewLocDescData,
		onSelect: function (rec) {
			GridParams.stloc=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	//ҽ������
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
	//��Χ
	var cbox = $HUI.combobox("#scopeDesc", {
		valueField: 'id',
		textField: 'text',
		editable:false, 
		data: ServerObj.ViewScopeDescData,
		onSelect: function (rec) {
			GridParams.scope=rec.id;
			LoadOrderTableDataGrid();
		}
	});
	//����
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
}


function InitOrderTableDataGrid(){
	var DefaultOrderSort=GetArrayDefaultData(ServerObj.ViewOrderSortData);
	var DefaultLocDesc=GetArrayDefaultData(ServerObj.ViewLocDescData);
	var DefaultScopeDesc=GetArrayDefaultData(ServerObj.ViewScopeDescData);
	var DefaultNurderBill=GetArrayDefaultData(ServerObj.ViewNurderBillData);
	var DefaultOrdReSubCat=GetArrayDefaultData(ServerObj.OrdReSubCatListJson);
	GridParams={
		ClassName:"web.DHCDocOrderVirtualLong",
		QueryName:"FindEMPatOrder",
		EpisodeID:ServerObj.EpisodeID,
		SessionStr:session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID'],
		stloc:DefaultLocDesc,
		nursebill:DefaultNurderBill,
		scope:DefaultScopeDesc,
		inputOrderDesc:"",
		PriorType:"ALL",
		SortType:DefaultOrderSort,
		CatType:DefaultOrdReSubCat
	};
	var OrdToolBar=[{
            text: $g('ͣҽ��'),
            iconCls: 'icon-stop-order',
            handler: function() {ShowStopMulOrdWin();}
        },{
            text: $g('ˢ��'),
            iconCls: 'icon-reload',
            handler: function() {LoadOrderTableDataGrid();}
        },{
            text: $g('Ԥ����ӡ'),
            iconCls: 'icon-print',
            handler: function() {PrintClickHandle();}
        }];
	var columns=[[
	    {field:'CheckOrd',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
		{field:'TItemStatCode',hidden:true,title:''},
		{field:'TOeoriOeori',hidden:true,title:''},
		{field:'PHFreqDesc1',hidden:true,title:''},
		{field:'TPermission',hidden:true,title:''},
		{field:'TItemStatCode',hidden:true,title:''},
		{field:'Priority',title:'ҽ������',align:'center',width:80,auto:false},
		{field:'TStDate',title:'ҽ����ʼʱ��',align:'center',width:150,auto:false},
		{field:'TOrderName',title:'ҽ��',align:'left',width:350,auto:false,
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
		{field:'DoseQtyInfo',title:'����',align:'center',width:80,auto:false},
		{field:'InstrDesc',title:'��ҩ;��',align:'center',width:80,auto:false},
		{field:'FreqDesc',title:'Ƶ��',align:'center',width:50,auto:false},
		{field:'TDuratDesc',title:'�Ƴ�',align:'center',width:50,auto:false},
		//{field:'SumQty',title:'����',align:'center',width:70,auto:false},
		{field:'OrderPackQty',title:'����',align:'center',width:70,auto:false},
		
		{field:'TDoctor',title:'��ҽ����',align:'center',width:80,auto:false},
		{field:'TStopDate',title:'ֹͣʱ��',align:'center',width:140,auto:false,
			styler: function(value,row,index){
 				if ((value!="")&&(value!=" ")){
	 				var stopDate=value.split(" ")[0];
	 				if (stopDate>ServerObj.CurrentDate){
		 				return 'background-color:yellow';
		 			}
	 			}
 			}
		},
		{field:'TStopDoctor',title:'ֹͣҽ��',align:'center',width:80,auto:false},
		{field:'TItemStatDesc',title:'״̬',align:'center',width:80,auto:false,
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
		{field:'TdeptDesc',title:'��������',align:'center',width:120,auto:false},
		{field:'TRecDepDesc',title:'���տ���',align:'center',width:120,auto:false},
		
		{field:'OrderType',title:'ҽ����������',align:'center',width:60,auto:false},
		{field:'TBillUom',title:'�Ƽ۵�λ',align:'center',width:80,auto:false},
		{field:'GroupSign',title:'�����',align:'center',width:30,auto:false,
		 styler: function(value,row,index){
 			 return 'color:red;';
		 }
		},
		{field:'OrderId',title:'ҽ��ID',align:'center',width:120,auto:false,
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
		{field:'TOEORIAddDate',title:'��ҽ������',align:'center',width:145,auto:false},
		{field:'OrderViewFlag',hidden:true},
		{field:'ZSQUrl',hidden:true},
		{field:'ORDVLRowID',hidden:true},
		{field:'IsCNMedItem',hidden:true},
		{field:'PopoverHtml',hidden:true}
		
	]];	

	var OrderTableDataGrid=$("#OrderTable").datagrid({
		fit : true,
		width:1500,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:true,
		rownumbers : true,  //
		//pagination : true,  //
		//pageSize: 10,
		//pageList : [10,100,200],
		idField:'OrderId',
		columns :columns,
		toolbar :OrdToolBar,
        rowStyler:function(rowIndex, rowData){
			if (rowData.OrdStatus == "ֹͣ"){
				return 'background-color:pink;';
			}
		},
		onLoadSuccess:function (data){
			var obj1=document.getElementById("TotalAmount");	//�ܷ���
			var obj2=document.getElementById("PayedAmount");	//�ѽɷѺϼ�
			var obj3=document.getElementById("NotPayedAmount");	//δ�ɷѺϼ�
			var obj4=document.getElementById("ObservedAmount"); //����Ѻ��
			//���ݾ���ŷ��ز��˷�����Ϣ 
	    	$(".pricePart").show();
		    if(obj1) obj1.innerHTML=$g("�ܽ��")+":<font style='color:blue;font-weight:bold;'>"+data.AllPrice+"</font>";
		    if(obj2) obj2.innerHTML=$g("�Ѽ��˽��")+":<font style='color:green;font-weight:bold;'>"+data.PayPrice+"</font>";
		    if(obj3) obj3.innerHTML=$g("δ���˽��")+":<font style='color:red;font-weight:bold;'>"+data.NoPrice+"</font>";
		},
		onDblClickRow :function(rowIndex, rowData){   //  onDblClickRow  onClickRow
			OrdDataGridDbClick(rowIndex, rowData);
		},
		onCheck:function(rowIndex,rowData){
			var OrderId=rowData.OrderId;
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
			//��ѡ��ҽ��
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
					if ((myTOeoriOeori==OrderId)){
						PageLogicObj.Order_selRowIndex=idx;
						PageLogicObj.m_OrderTableDataGrid.datagrid('checkRow',idx);
					}
				}
			}else if (TOeoriOeori.indexOf("||")>=0){ //��ѡ��ҽ�� ���ڿ��е����
				var MasterrowIndex=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
				if (MasterrowIndex>=0){
					PageLogicObj.m_OrderTableDataGrid.datagrid('checkRow',MasterrowIndex);
				}
			}
			PageLogicObj.Order_selRowIndex="";
		},
		onUncheck:function(rowIndex,rowData){
			var OrderId=rowData.OrderId;
			if ((PageLogicObj.Order_selRowIndex!=="")||(OrderId.indexOf("||")<0)) return false;
			var OrderId=rowData.OrderId;
			var TOeoriOeori=rowData.TOeoriOeori;
			var GroupSign=rowData.GroupSign;
			//var OrdList=InPatOrdDataGrid.datagrid('getData');
			if (ServerObj.OrderViewScrollView=="1"){
				var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getData').originalRows;
            }else{
	        	var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
			}
			//��ѡ��ҽ��
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
					if ((myTOeoriOeori==OrderId)){
						PageLogicObj.Order_selRowIndex=idx;
						PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckRow',idx);
					}
				}
			}else if (TOeoriOeori!=""){ //��ѡ��ҽ��
				var MasterrowIndex=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
				if (MasterrowIndex>=0){
					PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckRow',MasterrowIndex);
				}
			}
			PageLogicObj.Order_selRowIndex="";
			PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckAll').datagrid('loadData',[]);
		}
    });
    //OrderTableDataGrid.datagrid({}).datagrid("keyCtr");
	OrderTableDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return OrderTableDataGrid;
}

function LoadOrderTableDataGrid(){
	$.q({
	    ClassName : GridParams.ClassName,
	    QueryName : GridParams.QueryName,
	    EpisodeID:GridParams.EpisodeID,
		SessionStr:GridParams.SessionStr,
		stloc:GridParams.stloc,
		nursebill:GridParams.nursebill,
		scope:GridParams.scope,
		inputOrderDesc:GridParams.inputOrderDesc,
		PriorType:GridParams.PriorType,
		SortType:GridParams.SortType,
		CatType:GridParams.CatType,
	    Pagerows:99999,rows:99999 //PageLogicObj.m_OrderTableDataGrid.datagrid("options").pageSize
	},function(GridData){
		PageLogicObj.m_OrderTableDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
		PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckAll').datagrid('loadData',[]);
	}); 
}
function OrdDataGridDbClick(rowIndex, rowData,type){
	 if ($("#OrderDetailTable").length>0){
        PageLogicObj.m_OrderTableDataGrid.datagrid("clearChecked");
        //��֤˫�����Ҽ�ʱֻѡ����һ��,��Ҫ��Գ���ҽ��
        PageLogicObj.m_OrderTableDataGrid.datagrid("checkRow", rowIndex);
        $.extend(OrderDetailGridParams,{oeori:rowData.OrderId});
		LoadOrderDetail();
		$("#DetailData").data("Data",JSON.stringify({
			IsCNMedItem:rowData.IsCNMedItem
		}));
		
    }else{
        PageLogicObj.m_OrderTableDataGrid.datagrid("clearChecked");
        PageLogicObj.m_OrderTableDataGrid.datagrid("checkRow", rowIndex);
        $("#DetailData").data("Data",JSON.stringify({
			IsCNMedItem:""
		}));
	}
}
function InitOrderDetailTableDataGrid(){
	OrderDetailGridParams={
		ClassName:"web.DHCDocOrderVirtualLong",
		QueryName:"FindOrdItem",
		oeori:""
	};
	var OrdToolBar=[{
        text: '����',
        iconCls: 'icon-stop-order',
        handler: function() {ShowCancelMulOrdWin();}
    }];
	var columns=[[
	    {field:'CheckOrd',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
		{field:'TItemStatCode',hidden:true,title:''},
		{field:'TOeoriOeori',hidden:true,title:''},
		{field:'PHFreqDesc1',hidden:true,title:''},
		{field:'TPermission',hidden:true,title:''},
		{field:'TItemStatCode',hidden:true,title:''},
		
		{field:'TStDate',title:'ҽ����ʼʱ��',align:'center',width:150,auto:false},
		{field:'TOrderName',title:'ҽ��',align:'left',width:350,auto:false,
			formatter: function(value,row,index){
 				var inparaOrderDesc=$("#orderDesc").val();
 				if (inparaOrderDesc!=""){
	 				var tmpvalue=value.replace(/\&nbsp;/g,"").replace(/\&nbsp/g,"");
					tmpvalue = tmpvalue.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
				}else{
					var tmpvalue=value;
				}
				var ordtitle=tmpvalue //.replace(reg1,'').replace(reg2,' ');
				return "<span title='" + ordtitle + "' class='hisui-tooltip'>" + value + "</span>";
			}
		},
		{field:'SumQty',title:'����',align:'center',width:70,auto:false},
		{field:'Priority',title:'ҽ������',align:'center',width:80,auto:false},
		{field:'TStopDate',title:'ֹͣʱ��',align:'center',width:140,auto:false,
			styler: function(value,row,index){
 				if ((value!="")&&(value!=" ")){
	 				var stopDate=value.split(" ")[0];
	 				if (stopDate>ServerObj.CurrentDate){
		 				return 'background-color:yellow';
		 			}
	 			}
 			}
		},
		{field:'TStopDoctor',title:'ֹͣҽ��',align:'center',width:80,auto:false},
		{field:'TItemStatDesc',title:'״̬',align:'center',width:80,auto:false,
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
		{field:'GroupSign',title:'�����',align:'center',width:30,auto:false,
		 styler: function(value,row,index){
 			 return 'color:red;';
		 }
		},
		{field:'OrderId',title:'ҽ��ID',align:'center',width:120,auto:false,
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
		{field:'TOEORIAddDate',title:'��ҽ������',align:'center',width:145,auto:false},
		{field:'OrderViewFlag',hidden:true},
		{field:'ORDVLRowID',hidden:true}
		
	]];	

	var OrderDetailTableDataGrid=$("#OrderDetailTable").datagrid({
		fit : true,
		width:1500,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:true,
		pagination : false,  //
		rownumbers : true,  //
		idField:'OrderId',
		columns :columns,
		toolbar :OrdToolBar,
        rowStyler:function(rowIndex, rowData){
			if (rowData.OrdStatus ==$g( "ֹͣ")){
				return 'background-color:pink;';
			}
		},
		onCheck:function(rowIndex,rowData){
			var OrderId=rowData.OrderId;
			if ((PageLogicObj.OrderDetail_selRowIndex!=="")||(OrderId.indexOf("||")<0)){
				return false;
			}
			var TOeoriOeori=rowData.TOeoriOeori;
			var GroupSign=rowData.GroupSign;
			//var OrdList=InPatOrdDataGrid.datagrid('getData');
			if (ServerObj.OrderViewScrollView=="1"){
				var rows = PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getData').originalRows;
            }else{
	        	var rows = PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getRows');
			}
			//��ѡ��ҽ��
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
					if ((myTOeoriOeori==OrderId)){
						PageLogicObj.OrderDetail_selRowIndex=idx;
						PageLogicObj.m_OrderDetailTableDataGrid.datagrid('checkRow',idx);
					}
				}
			}else if (TOeoriOeori.indexOf("||")>=0){ //��ѡ��ҽ�� ���ڿ��е����
				var MasterrowIndex=PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
				if (MasterrowIndex>=0){
					PageLogicObj.m_OrderDetailTableDataGrid.datagrid('checkRow',MasterrowIndex);
				}
			}
			PageLogicObj.OrderDetail_selRowIndex="";
		},
		onUncheck:function(rowIndex,rowData){
			var OrderId=rowData.OrderId;
			if ((PageLogicObj.OrderDetail_selRowIndex!=="")||(OrderId.indexOf("||")<0)) return false;
			var OrderId=rowData.OrderId;
			var TOeoriOeori=rowData.TOeoriOeori;
			var GroupSign=rowData.GroupSign;
			//var OrdList=InPatOrdDataGrid.datagrid('getData');
			if (ServerObj.OrderViewScrollView=="1"){
				var rows = PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getData').originalRows;
            }else{
	        	var rows = PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getRows');
			}
			//��ѡ��ҽ��
			if ((TOeoriOeori=="")&&(GroupSign!="")){
				for (var idx=rowIndex+1;idx<rows.length;idx++) {
					var myTOeoriOeori=rows[idx].TOeoriOeori;
					if ((myTOeoriOeori==OrderId)){
						PageLogicObj.OrderDetail_selRowIndex=idx;
						PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckRow',idx);
					}
				}
			}else if (TOeoriOeori!=""){ //��ѡ��ҽ��
				var MasterrowIndex=PageLogicObj.m_OrderDetailTableDataGrid.datagrid('getRowIndex',TOeoriOeori);
				if (MasterrowIndex>=0){
					PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckRow',MasterrowIndex);
				}
			}
			PageLogicObj.OrderDetail_selRowIndex="";
		}
    });
	OrderDetailTableDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return OrderDetailTableDataGrid;
}
function LoadOrderDetail(){
	$.q({
	    ClassName : OrderDetailGridParams.ClassName,
	    QueryName : OrderDetailGridParams.QueryName,
	    oeori:OrderDetailGridParams.oeori,
	    Pagerows:9999,rows:99999
	},function(GridData){
		PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	}); 
}
function ShowOrderDescDetail(that){
	
	var OrderRowId=that.id;
	var index=PageLogicObj.m_OrderTableDataGrid.datagrid('getRowIndex',OrderRowId);

    var rows = PageLogicObj.m_OrderTableDataGrid.datagrid('getRows');
	var content=rows[index]['PopoverHtml'];
	var contentFlag=content.split("@")[0]; //Ϊ0 ������ʾ����ҽ������Ϣ Ϊ1�������۳��ȶ�Ҫ��ʾ
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
		title:$g('ҽ����ϸ'),
		iconCls:'icon-w-paper',
		width:400,height:screen.availHeight-260
	});
}
function OpenOrderView(OEItemID){
	websys_showModal({
		url:"dhc.orderview.csp?ord=" + OEItemID,
		title:$g('ҽ���鿴'),
		iconCls:'icon-w-paper',
		width:screen.availWidth-200,height:screen.availHeight-260
	});
}

function ShowStopMulOrdWin(){
	destroyDialog("OrdDiag");
	
	var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderTableDataGrid);
	if (!SelOrdObj.ErrFlag) return false;
	var ORDVLRowIDStr=SelOrdObj.ORDVLRowIDStr;
	var NorOrderStr=SelOrdObj.NorOrderStr;
	var OrderStr=SelOrdObj.OrderStr;
	var IsLongPrior=GetStopOrdPriorType();
	if (IsLongPrior=="-1"){return false}
	if (IsLongPrior=="1"){
		var StopType="SInEM";
	}else{
		var StopType="NormInEM";
	}
	var rtn=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"CheckMulOrdDealPermission",
	    OrderItemStr:OrderStr,
	    date:"",
	    time:"",
	    type:StopType=="SInEM"?"SInEM":"C",
	    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
	},false);
    if (rtn!=0){
	   $.messager.alert("��ʾ",rtn);
	   return false;
    }
	var title=$g("ͣҽ��");
	var Content=initDiagDivHtml(StopType);
	var iconCls="icon-w-edit";
	createModalDialog("OrdDiag",title, 380, 280,iconCls,"ֹͣ",Content,"MulOrdDealWithCom('"+StopType+"')");
	InitStopMulOrdWin(OrderStr);
	$("#winPinNum").focus();
}
function ShowCancelMulOrdWin(){
	var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderDetailTableDataGrid);
	if (!SelOrdObj.ErrFlag) return false;
	var OrderStr=SelOrdObj.OrderStr;
	var DetailData=jQuery.parseJSON($("#DetailData").data("Data"));
	var StopDealType=(DetailData.IsCNMedItem==1)?"":"ReturnVirLongOrdExec"
	var title=$g("ͣҽ��");	
	var rtn=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"CheckMulOrdDealPermission",
	    OrderItemStr:SelOrdObj.OrderStr,
	    date:"",
	    time:"",
	    type:"C",
	    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^^"+StopDealType
	},false);
    if (rtn!=0){
	   $.messager.alert("��ʾ",rtn);
	   return false;
    }
    if (DetailData.IsCNMedItem==1){
	    var StopType="NormInEM";
	    var Content=initDiagDivHtml(StopType);
		var iconCls="icon-w-edit";
		createModalDialog("OrdDiag",title, 380, 280,iconCls,"ֹͣ",Content,"MulOrdDealWithCom('"+StopType+"')");
		InitStopMulOrdWin(OrderStr);
		$("#winPinNum").focus();
	}else{
		$.ajax('doc.virlongorder.execlist.hui.csp'+((typeof websys_getMWToken=='function')?("?MWToken="+websys_getMWToken()):""), {
			"type" : "GET",
			"dataType" : "html",
			"success" : function(data, textStatus) {
				createModalDialog("ReturnOrdExecDetail","�˷���ϸѡ��", 650, 550,"icon-w-ok","ȷ��",data,"ReturnOrdExecOk()");
				InitReturnOrdExecList();
			}
		});
	}
}

function InitReturnOrdExecList(){
	var columns=[[
	    {field:'CheckOrd',title:'ѡ��',checkbox:'true',align:'center',width:70,auto:false},
		
		{field:'TExecStateCode',hidden:true,},
		{field:'TExStDate',title:'Ҫ��ִ��ʱ��',align:'center',width:150,auto:false},
		{field:'TExecState',title:'״̬',align:'center',width:80,auto:false,
			styler: function(value,row,index){
 				if (row.TExecStateCode){
	 				if( [$g("δִ��"),"C"].indexOf(row.TExecStateCode) > -1 ){
		 				return "background-color: yellow;"
		 			}
 				}
 			}
		},
		{field:'TgiveDrugQty',title:'��ҩ����',align:'center',width:80,auto:false},
		{field:'TRealExecDate',title:'����ʱ��',align:'center',width:150,auto:false},
		{field:'TExecUser',title:'������',align:'center',width:150,auto:false},
		
		{field:'TBillState',title:'�ʵ�״̬',align:'center',width:80,auto:false},
		{field:'ExecPart',title:'��鲿λ',align:'center',width:150,auto:false},
		{field:'TcancelDrugQty',title:'��ҩ����',align:'center',width:80,auto:false},
		{field:'OrderExecId',title:'ִ�м�¼��ˮ',align:'center',width:90,auto:false}
	]];
	
	$("#ReturnOrdExec").datagrid({
		fit : true,
		width:1500,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:true,
		rownumbers : true,
		idField:'OrderExecId',
		columns :columns
    });
	var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderDetailTableDataGrid);
	if (!SelOrdObj.ErrFlag) return false;
	var OrderStr=SelOrdObj.OrderStr;
	$.q({
	    ClassName : "web.DHCDocOrderVirtualLong",
	    QueryName : "FindOrderExec",
	    OrdList:OrderStr,
	    Pagerows:$("#ReturnOrdExec").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#ReturnOrdExec").datagrid('uncheckAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//$("#ReturnOrdExec").datagrid('checkAll');
		
		var rows = $("#ReturnOrdExec").datagrid('getRows');
		for (var idx=0;idx<rows.length;idx++) {
			var TExecStateCode=rows[idx].TExecStateCode;
			if (["δִ��","C"].indexOf(TExecStateCode) > -1 ){
				$("#ReturnOrdExec").datagrid('checkRow',idx);
			}
		}
		$("#winPinNum").focus();
	}); 
	$("td[for=password]")[0].innerHTML=$g($("td[for=password]")[0].innerHTML)
}
function ReturnOrdExecOk(){
	var rows = $("#ReturnOrdExec").datagrid('getRows');
	var SelOrdExecRowArr=$("#ReturnOrdExec").datagrid('getChecked');
	if ((SelOrdExecRowArr.length==0)&&(rows.length!=0)){
	   $.messager.alert("��ʾ","û�й�ѡ���˷�ִ�м�¼!")
	   return false;
	}
	var ReturnOrdExecList="";
	$.each(SelOrdExecRowArr,function(Index,RowData){
		if (RowData.OrderExecId!=""){
			if (ReturnOrdExecList=="") ReturnOrdExecList=RowData.OrderExecId;
			else ReturnOrdExecList=ReturnOrdExecList+"^"+RowData.OrderExecId;
		}
	});
	var pinNum="";
	if ($("#winPinNum").length>0){
		pinNum=$("#winPinNum").val();
		if (pinNum==""){
		   $.messager.alert("��ʾ","���벻��Ϊ��!","info",function(){
			   $("#winPinNum").focus();
		   });
		   return false;
		}
	}
	///�п�������ִ�м�¼��ҽ��,
	if (ReturnOrdExecList==""){
		var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderDetailTableDataGrid);
		if (SelOrdObj.OrderStr!=""){
			var Arr=SelOrdObj.OrderStr.split("^");
			for (var i=0;i<Arr.length;i++){
				if (Arr[i]==""){
					continue
				}
				if (ReturnOrdExecList==""){
					ReturnOrdExecList=Arr[i].split(String.fromCharCode(1))[0];
				}else{
					ReturnOrdExecList=ReturnOrdExecList+"^"+Arr[i].split(String.fromCharCode(1))[0];
				}
			}
		}
	}
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^^"+pinNum;
	var val=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdExecDealWithCom",
	    OrderExecStr:ReturnOrdExecList,
	    date:"",
	    time:"",
	    type:"DInEM",
	    ReasonId:"",
	    ExpStr:ExpStr
	},false);
	var alertCode=val.split("^")[0];
	if (alertCode=="0"){
		LoadOrderDetail();
		LoadOrderTableDataGrid();
		destroyDialog("ReturnOrdExecDetail");
		//ExeCASigin(OrderStr);
	}else{
		$.messager.alert("��ʾ",val.split("^")[0],"info",function(){
			if (val.indexOf("����")>=0){
				$("#winPinNum").focus();
			}
		});
		return false;
	}
	
	
	
	
}

function GetSelOrdRowStr(table$){
	var SelOrdObj={
		ErrFlag:true,
		ORDVLRowIDStr:"",
		NorOrderStr:"",
		OrderStr:""
	}
	var SelOrdRowArr=table$.datagrid('getChecked'); //ҽ�������Թ�ѡΪ׼,δ��ѡ��������
	if (SelOrdRowArr.length==0){
	   $.messager.alert("��ʾ","û�й�ѡҽ��!")
	   $.extend(SelOrdObj,{ErrFlag:false});
	   return SelOrdObj;
	}
	var ORDVLRowIDStr="";
	var NorOrderStr="";
	var Length=0
	$.each(SelOrdRowArr,function(Index,RowData){
		if (RowData.ORDVLRowID!=""){
			if (ORDVLRowIDStr=="") ORDVLRowIDStr=RowData.OrderId+String.fromCharCode(1)+RowData.TStDateHide;
			else ORDVLRowIDStr=ORDVLRowIDStr+"^"+RowData.OrderId+String.fromCharCode(1)+RowData.TStDateHide
			++Length;
		}else if (RowData.OrderId!=""){
			if (NorOrderStr=="") NorOrderStr=RowData.OrderId+String.fromCharCode(1)+RowData.TStDateHide;
			else NorOrderStr=NorOrderStr+"^"+RowData.OrderId+String.fromCharCode(1)+RowData.TStDateHide
			++Length;
		}
	});
	if (Length==0){
	   $.messager.alert("��ʾ","û�й�ѡҽ��!")
	   $.extend(SelOrdObj,{ErrFlag:false});
	   return SelOrdObj;
	}
	var OrderStr=ORDVLRowIDStr;
	if (NorOrderStr!=""){
		if (OrderStr=="") OrderStr=NorOrderStr;
		else OrderStr=OrderStr+"^"+NorOrderStr;
	}
	$.extend(SelOrdObj,{ORDVLRowIDStr:ORDVLRowIDStr,NorOrderStr:NorOrderStr,OrderStr:OrderStr});
	return SelOrdObj;
}
function GetStopOrdPriorType(){
	var SelOrdRowArr=PageLogicObj.m_OrderTableDataGrid.datagrid('getChecked'); //ҽ�������Թ�ѡΪ׼,δ��ѡ��������
	var IsLongPrior="";
	
	$.each(SelOrdRowArr,function(Index,RowData){
		var ORDVLRowID=RowData.ORDVLRowID;
		if (RowData.TOeoriOeori!=""){
			return true;
		}
		var myIsLongPrior;
		if (ORDVLRowID==""){
			myIsLongPrior="0";
		}else{
			myIsLongPrior="1";
		}
		if (IsLongPrior==""){
			IsLongPrior=myIsLongPrior
		}else{
			if (IsLongPrior!=myIsLongPrior){
				IsLongPrior="-1";
				return false;
			}
		}
	});
	if (IsLongPrior=="-1"){
		$.messager.alert("��ʾ","����ͬʱѡ����ʱ�ͳ���ҽ������ֹͣ������")
	}
	return IsLongPrior;
}
function InitStopMulOrdWin(SelOrdRowStr){
	var o=$HUI.datebox('#winStopOrderDate');
	o.setValue(ServerObj.CurrentDate);
   $("#winStopOrderTime").timespinner('setValue',GetCurTime());
   $HUI.checkbox("#isExpStopOrderCB",{
	   onChecked:function(event,value){
		    $("#winStopOrderDate").datebox({ disabled:false,minDate:ServerObj.NextDate});
			$("#winStopOrderDate").datebox("setValue",ServerObj.NextDate);
			//$("#winStopOrderTimes").combobox({ disabled:false});
   		},
   		onUnchecked:function(){
		    $("#winStopOrderDate").datebox({ disabled:true,minDate:null})
		   	$("#winStopOrderDate").datebox("setValue",ServerObj.CurrentDate);
		   	//$("#winStopOrderTimes").combobox({ disabled:true})
   		}
   });
   $HUI.checkbox("#IncludeStopDateOrd","setValue",true);
   
}


function initDiagDivHtml(type){
   if (type=="SInEM"){
	   var html="<div id='DiagWin' style=''>"
		   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
		       html +="	 <tr>"
		       	html +="	 <td class='r-label' style='padding-left: 0;'>"
		       		html +=$g("	 �Ƿ�Ԥͣ")
		       	html +="	 </td>"
		       	html +="	 <td>"
		       		html +="	 <input class='hisui-checkbox' type='checkbox' id='isExpStopOrderCB'/>"
		       	html +="	 </td>"
		       html +="	 </tr>"
		       
		       html +="	 <tr>"
		       	html +="	 <td class='r-label' style='padding-left: 0;'>"
		       		html +=$g("	 ֹͣ����")
		       	html +="	 </td>"
		       	html +="	 <td>"
		       		html +="	 <input id='winStopOrderDate' disabled='false' class='hisui-datebox textbox' required='required'></input>"
		       	html +="	 </td>"
		       html +="	 </tr>"
		       
		       
		       html +="	 <tr>"
		       	html +="	 <td class='r-label' style='padding-left: 0;'>"
		       		html +=$g("	 ֹͣʱ��")
		       	html +="	 </td>"
		       	html +="	 <td>"
		       		html +="	 <input id='winStopOrderTime' class='hisui-timespinner textbox' data-options='showSeconds:true' style='width:155px'/> "
		       	html +="	 </td>"
		       html +="	 </tr>"
		       html +="	 <tr title='"+$g("ֹֹͣͣ���ڵ��յ�ҽ��")+"'>"
		       	html +="	 <td class='r-label' style='padding-left: 0;'>"	//colspan='2'
		       		html +=$g("	 ��������")
		       	html +="	 </td>"
		       	html +="	 <td>"
		       		html +="	 <input class='hisui-checkbox' type='checkbox' id='IncludeStopDateOrd'/>"
		       	html +="	 </td>"
		       html +="	 </tr>"
		       html +="	 <tr>"
		       	html +="	 <td class='r-label' style='padding-left: 0;'>"
		       		html +=$g("	 ����")
		       	html +="	 </td>"
		       	html +="	 <td>"
		       		html +="	 <input type='password' id='winPinNum' style='' class='hisui-validatebox textbox' data-options='required:true'  onkeydown='DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")'  /> "
		       	html +="	 </td>"
		       html +="	 </tr>"
		       
		   html +="	</table>"
	   html += "</div>"
   }else if((type=="C")||(type=="NormInEM")){
	   var html="<div id='DiagWin' style='margin-top: 5px;'>"
		   html +="	<table class='search-table' style='margin:0 auto;border:none;'>"
		   		/*
		   		html +="	 <tr>"
			       	html +="	 <td class='r-label'>"
			       		html +="	 ��ѡ��ԭ��"
			       	html +="	 </td>"
			       	html +="	 <td>"
			       		html +="	 <input id='OECStatusChReason' class='textbox'></input>"
			       	html +="	 </td>"
		        html +="	 </tr>"
		       */
		   		html +="	 <tr>"
		       		html +="	 <td class='r-label' style='padding-left: 0;'>"
		       			html +=$g("	 ����")
		       		html +="	 </td>"
		       		html +="	 <td>"
		       			html +="	 <input type='password' id='winPinNum' class='hisui-validatebox textbox' data-options='required:true'  onkeydown='DiagDivKeyDownHandle(\"Confirm\",\""+type+"\")' />"
		       		html +="	 </td>"
		       	html +="	 </tr>"
		       	
		   html +="	</table>"
	   html += "</div>"
   }
   return html;
}
/**
 * ����һ��ģ̬ Dialog
 * @param id divId
 * @param _url Div����
 * @param _title ����
 * @param _width ���
 * @param _height �߶�
 * @param _icon ICONͼ��
 * @param _btntext ȷ����ťtext
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
   //���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
   buttons.push({
	   text:'�ر�',
		iconCls:'icon-w-close',
		handler:function(){
			destroyDialog(id);
		}
   });
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    //$(window.parent.document.body).append("<div id='"+id+"' class='hisui-dialog'></div>");
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
        //href: _url,
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
   var h=myDate.getHours();       //��ȡ��ǰСʱ��(0-23)
   var m=myDate.getMinutes();     //��ȡ��ǰ������(0-59)
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
   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
   $("#"+id).dialog('destroy');
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
function DiagDivKeyDownHandle(HandleType,EventType){
	if (HandleType=="Confirm"){
		if (window.event.keyCode=="13"){
			MulOrdDealWithCom(EventType);
		}
	}else if (HandleType=="ConfirmExec"){
		
		if (window.event.keyCode=="13"){
			ReturnOrdExecOk();
		}
	}
}

function MulOrdDealWithCom(type){
   var date="",time="";
   
   var pinNum="";
   if (type=="SInEM"){
	   var date = $('#winStopOrderDate').datebox('getValue');
	   if (date==""){
		   $.messager.alert("��ʾ","ֹͣ���ڲ���Ϊ��!");
		   $('#winStopOrderDate').next('span').find('input').focus();
		   return false;
	   }
	   if(!DATE_FORMAT.test(date)){
		   $.messager.alert("��ʾ","ֹͣ���ڸ�ʽ����ȷ!");
		   return false;
	   }
	   if ($("#isExpStopOrderCB").checkbox("getValue")) {
		   var CurrentDate=new Date();
		   if (dtseparator=="/"){
			    var tmpdate=date.split("/")[2]+"-"+date.split("/")[1]+"-"+date.split("/")[0]
			    var chkDate = new Date(tmpdate.replace("-", "/").replace("-", "/"));
			}else{
				var chkDate = new Date(date.replace("-", "/").replace("-", "/"));
			}
			if(chkDate<=CurrentDate){
				$.messager.alert("��ʾ","Ԥͣʱֹͣ���ڲ���С�ڵ��ڵ���!","info",function(){
					$('#winStopOrderDate').next('span').find('input').focus();
				});
				return false;
			}
	   }
	   var time=$('#winStopOrderTime').timespinner('getValue'); //$('#winStopOrderTime').combobox('getText');
	   if (time==""){
		   $.messager.alert("��ʾ","ֹͣʱ�䲻��Ϊ��!","info",function(){
			   $('#winStopOrderTime').next('span').find('input').focus();
		   });
		   return false;
	   }
	   if (!IsValidTime(time)){
		   $.messager.alert("��ʾ","ֹͣʱ���ʽ����ȷ! ʱ:��:��,��11:05:01","info",function(){
			   $('#winStopOrderTime').next('span').find('input').focus();
		   });
		   return false;
	   }
   }
   if ($("#winPinNum").length>0){
	   pinNum=$("#winPinNum").val();
	   if (pinNum==""){
		   $.messager.alert("��ʾ","���벻��Ϊ��!","info",function(){
			   $("#winPinNum").focus();
		   });
		   return false;
	   }
   }
	if (ExeCASigin("")==false){
		return false;
	} 
	if ((type=="SInEM")||(type=="NormInEM")){
		var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderTableDataGrid);
	}else{
		var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderDetailTableDataGrid);
	}
	//var SelOrdObj=GetSelOrdRowStr(PageLogicObj.m_OrderTableDataGrid);
	var OrderStr=SelOrdObj.OrderStr;
	var IncludeStopDateOrd="N";
	if (type=="SInEM"){
		var MulOrdDealWithComTtpe="SInEM";
		if ($HUI.checkbox("#IncludeStopDateOrd").getValue()){
			IncludeStopDateOrd="Y";
		}
	}else{
		var MulOrdDealWithComTtpe="C";
	}
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^^"+IncludeStopDateOrd;
	var val=$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdDealWithCom",
	    OrderItemStr:OrderStr,
	    date:date,
	    time:time,
	    type:MulOrdDealWithComTtpe,
	    pinNum:pinNum,
	    ExpStr:ExpStr
	},false);
	var alertCode=val.split("^")[0];
	if ((type=="U")&&(alertCode=="-901")){
		$.messager.alert("��ʾ",val.split("^")[1]);
		alertCode="0";
	}
	if (alertCode=="0"){
		PageLogicObj.m_OrderTableDataGrid.datagrid("uncheckAll").datagrid("clearChecked");
		LoadOrderTableDataGrid();
		PageLogicObj.m_OrderDetailTableDataGrid.datagrid('uncheckAll').datagrid('loadData',[]);
		destroyDialog("OrdDiag");
		ExeCASigin(OrderStr);
	}else{
		$.messager.alert("��ʾ",val.split("^")[0]);
		return false;
	}
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

function GetPrintDetailData(OrderType){
	var DefaultGridParams={};
	$.extend(DefaultGridParams,GridParams);
	//�������ң��������벡��
	DefaultGridParams.stloc=1;
	//ҽ������ :ҽ����
	DefaultGridParams.nursebill="N";
	//��Χ:ȫ��
	DefaultGridParams.scope=1;
	//�ؼ���
	DefaultGridParams.inputOrderDesc="";
	//����ʽ
	DefaultGridParams.PriorType=OrderType;
	//����ʽ
	DefaultGridParams.SortType="AT";
	//ҽ���ط���
	DefaultGridParams.CatType="ALL";
	var GridData=$.q({
	    ClassName : DefaultGridParams.ClassName,
	    QueryName : DefaultGridParams.QueryName,
	    EpisodeID:DefaultGridParams.EpisodeID,
		SessionStr:DefaultGridParams.SessionStr,
		stloc:DefaultGridParams.stloc,
		nursebill:DefaultGridParams.nursebill,
		scope:DefaultGridParams.scope,
		inputOrderDesc:DefaultGridParams.inputOrderDesc,
		PriorType:DefaultGridParams.PriorType,
		SortType:DefaultGridParams.SortType,
		CatType:DefaultGridParams.CatType,
	    Pagerows:99999,rows:99999
	},false); 
	return GridData.rows;
}

function xhrRefresh(Args){
	LoadOrderTableDataGrid();
}
function ExeCASigin(OrdList)
{
	if (ServerObj.CAInit!=1){
		return true;
	}
	var ContainerName="";
	var caIsPass=0;
	var rtn=dhcsys_getcacert();
    if (rtn.IsSucc){
		if (rtn.ContainerName==""){
			ContainerName="";
    		caIsPass=0;
		}else{
			ContainerName=rtn.ContainerName;
    		caIsPass=1;
		}
	}
	if (caIsPass==0){
		$.messager.alert("��ʾ","ǩ��ʧ��!");
        return false;
	}
	if (OrdList!=""){
		var ret=SaveCASign(ContainerName,OrdList,"S");
	}
	return true;
}


function SaveCASign(ContainerName,OrdList,OperationType) 
{    
	try{
      if (ContainerName=="") return false;
		//1.������֤
	    var CASignOrdStr="";
	    var TempIDs=OrdList.split("^");
		var IDsLen=TempIDs.length;
		for (var k=0;k<IDsLen;k++) {
			/*var TempNewOrdDR=TempIDs[k].split("&");
			if (TempNewOrdDR.length <=0) continue;
			var newOrdIdDR=TempNewOrdDR[0];
			if (newOrdIdDR.indexOf("!")>0){
				newOrdIdDR=newOrdIdDR.split("!")[0];
			}*/

			var TempNewOrdDR=TempIDs[k].split(String.fromCharCode(1));
			if (TempNewOrdDR.length <=0) continue;
			var newOrdIdDR=TempNewOrdDR[0];
			if (newOrdIdDR.indexOf("!")>0){
				newOrdIdDR=newOrdIdDR.split("!")[0];
			}
			if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
			else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
		}
		var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
		var CASignOrdArr=CASignOrdStr.split("^");
		for (var count=0;count<CASignOrdArr.length;count++) {
			var CASignOrdId=CASignOrdArr[count];
			var OEORIItemXML=cspRunServerMethod(ServerObj.GetOEORIItemXMLMethod,CASignOrdId,OperationType);
			var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
			for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
				if (OEORIItemXMLArr[ordcount]=="")continue;
  				var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
   				var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
				//$.messager.alert("����","OEORIItemXML:"+OEORIItemXML);
				var OEORIItemXMLHash=HashData(OEORIItemXML);
				//$.messager.alert("����","HashOEORIItemXML:"+OEORIItemXMLHash);
				if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
				else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
				//$.messager.alert("����",ContainerName);
				var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
				if(SignedOrdStr=="") SignedOrdStr=SignedData;
				else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
				if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
			}
		}
		if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
		if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
		//��ȡ�ͻ���֤��
    	var varCert = GetSignCert(ContainerName);
    	var varCertCode=GetUniqueID(varCert);
		/*
		alert("CASignOrdStr:"+CASignOrdStr);
		alert("SignOrdHashStr:"+SignOrdHashStr);
		alert("varCert:"+varCert);
		alert("SignedData:"+SignedOrdStr);
		*/
    	if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
			//3.����ǩ����Ϣ��¼																												CASignOrdValStr,session['LOGON.USERID'],"A",					SignOrdHashStr,varCertCode,SignedOrdStr,""
			var ret=cspRunServerMethod(ServerObj.InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],OperationType,SignOrdHashStr,varCertCode,SignedOrdStr,"");
			if (ret!="0") {
				alert("����ǩ��û�ɹ�");
				return false;
			}else{
			}
		}else{
	  		alert("����ǩ������");
	  		return false;
		} 
		return true;
	}catch(e){alert("CA err:"+e.message);return false;}
}

function PrintClickHandle(){
	
	var PrintNum = 1; //��ӡ����
	var IndirPrint = "Y"; //�Ƿ�Ԥ����ӡ
	var TaskName=$g("���ﻼ��ҽ����"); //��ӡ��������
	
	var DetailData=GetPrintOrdInfo("ALL"); //��ϸ��Ϣ
	if (DetailData==false) return false;
	
	//��ϸ��Ϣչʾ
	var Cols=[
		{field:'TStDate',title:'ҽ����ʼʱ��',width:'125px',align:"left"},
		{field:'Priority',title:'ҽ������',width:'65px',align:"left"}, 
		{field:'TOrderDesc',title:'ҽ��',width:'250px',align:"left"}, 
		{field:'TDoctor',title:'��ҽ����',width:'80px',align:"left"}, 
		{field:'TStopDate',title:'ֹͣʱ��',width:'125px',align:"left"},
		{field:'TStopDoctor',title:'ֹͣҽ��',width:'80px',align:"left"}
	];	
	DHCP_GetXMLConfig("InvPrintEncrypt","DocVirlongOrderPrtHead");
	var MyPara=GetPrintPatInfo(TaskName);
	PrintOrd(PrintNum,IndirPrint,TaskName,MyPara,Cols,DetailData);
}
function GetPrintOrdInfo(OrderType){
	var DetailData=GetPrintDetailData(OrderType); //��ϸ��Ϣ
	if (DetailData==false) return false;
	
	if (DetailData.length==0) {
		$.messager.alert("��ʾ","û����Ҫ��ӡ������!");
		return false;
	}
	for (var i=0;i<DetailData.length;i++){
		if (DetailData[i].DoctorUserDr!=""){
			if (typeof PageLogicObj.HasGifDocList[DetailData[i].DoctorUserDr] =="undefined"){
				var GifFlag=GetGifInfo(DetailData[i].DoctorUserDr);
				PageLogicObj.HasGifDocList[DetailData[i].DoctorUserDr]=GifFlag;
			}
			if (PageLogicObj.HasGifDocList[DetailData[i].DoctorUserDr]==0){
				DetailData[i].TDoctor="<img src='c://"+DetailData[i].DoctorUserDr+".gif'>"
				
			}
		}
		if (DetailData[i].StopDoctorUserDr!=""){
			if (typeof PageLogicObj.HasGifDocList[DetailData[i].StopDoctorUserDr] =="undefined"){
				var GifFlag=GetGifInfo(DetailData[i].StopDoctorUserDr);
				PageLogicObj.HasGifDocList[DetailData[i].StopDoctorUserDr]=GifFlag;
			}
			if (PageLogicObj.HasGifDocList[DetailData[i].StopDoctorUserDr]==0){
				DetailData[i].TStopDoctor="<img src='c://"+DetailData[i].StopDoctorUserDr+".gif'>"
			}
		}
	}
	return DetailData
}
function GetPrintPatInfo(TaskName){
	var PatBaseInfo=$.cm({
		ClassName:"DHCDoc.OPDoc.TreatPrint",
		MethodName:"GetPatBaseInfo",
		episodeID:ServerObj.EpisodeID,
		dataType:"text"
	},false);
	var PatBaseInfoArr=PatBaseInfo.split("^");
	var PANo=PatBaseInfoArr[0];
	var PatientMedicareNo=PatBaseInfoArr[1];
	var AdmDep=PatBaseInfoArr[2];
	var AdmDate=PatBaseInfoArr[3];
	var MRNo=PatBaseInfoArr[4];
	var Name=PatBaseInfoArr[5];
	var Sex=PatBaseInfoArr[6];
	var Age=PatBaseInfoArr[7];
	var Company=PatBaseInfoArr[8];
	var Childweight=PatBaseInfoArr[9];
	var Diagnose1=PatBaseInfoArr[10];
	var Diagnose2=PatBaseInfoArr[11];
	var Diagnose3=PatBaseInfoArr[12];
	var Diagnose4=PatBaseInfoArr[13];
	var Diagnose5=PatBaseInfoArr[14];
	var Diagnose6=PatBaseInfoArr[15];
	var SessHospDesc=PatBaseInfoArr[16];
	var AdmReasonDesc=PatBaseInfoArr[17];
	var CardNo=PatBaseInfoArr[18];
	var diagnodesc=PatBaseInfoArr[19];
	var CurrentWard=PatBaseInfoArr[20];
	var BedNo=PatBaseInfoArr[21];
	var PDlime=String.fromCharCode(2);
	var MyPara="Name"+PDlime+Name+"^"+"Sex"+PDlime+Sex+"^"+"Age"+PDlime+Age+"^"+"AdmDep"+PDlime+AdmDep+"^"+"Ward"+PDlime+CurrentWard;
	var MyPara=MyPara+"^"+"BedNo"+PDlime+BedNo+"^"+"HospName"+PDlime+SessHospDesc;
	var MyPara=MyPara+"^"+"Title"+PDlime+TaskName+"^"+"PANo"+PDlime+PANo
	return MyPara
}

///��ӡ
function PrintOrd(PrintNum,IndirPrint,TaskName,inpara,Cols,DetailData) {
	
	if(PrintNum==""){PrintNum=1}
	if(IndirPrint==""){IndirPrint="Y"}
	if(TaskName==""){TaskName=$g("���ݴ�ӡ")}
	
	/*�ж�Lodop�ؼ�*/
	var LODOP=getLodop();
	/*��ʼ��*/
	LODOP.PRINT_INIT(TaskName);
	LODOP.SET_PRINT_STYLE("FontSize", 11); //��λ��pt
	LODOP.SET_PRINT_MODE("RESELECT_PAGESIZE",true); //������ѡֽ��
	/*ģ������*/
	
	LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
	LODOP.SET_PRINT_STYLEA(0,"FontColor","#FF0000");
	LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
	LODOP.SET_PRINT_STYLEA(0,"Horient",3);

	LODOP.ADD_PRINT_HTM("98%","45%","300",25,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
	LODOP.SET_PRINT_STYLEA(0,"ItemType",1);	
	//��ͷ�ĸ߶�
	var invHeight="30mm";
	var mystr="";
	for (var i= 0; i<PrtAryData.length;i++){
		mystr=mystr + PrtAryData[i];
	}
	var docobj=DHC_parseXml(mystr);
	if (docobj){
		if (docobj.parsed){
			var inv = docobj.documentElement.childNodes[0];
			var invAttr = inv.attributes;
			invHeight = parseFloat(invAttr.getNamedItem("height").value);
			invHeight=(invHeight*10)+"mm";
			invWidth = parseFloat(invAttr.getNamedItem("width").value);
			invWidth=(invWidth*10)+"mm";
		}
	}
	DHC_CreateByXML(LODOP,inpara,"","","","");
	
	/*
	var intOrient=3; //��ӡ����
	var PageWidth='0'; //���ӵ�λ,Ĭ��0.1mm
	var PageHeight='0'; //���ӵ�λ,Ĭ��0.1mm
	var strPageName="A4"; //��width��height��������ʱ��������
	LODOP.SET_PRINT_PAGESIZE(intOrient, PageWidth,PageHeight,strPageName)
	*/
	////-----ģ�����ݽ���
	var tableStyle={
		HeadTrHeight:20,
		HeadFontsize:"9pt",
		DataTrHeight:20,
		DataFontsize:"9pt",
		FootTrHeight:20,
		FootFontsize:"9pt",
		ifnewline:0
	}
	//var strTableStyle = "<style type='text/css'>table{}</style>";
	//LODOP.SET_PRINT_STYLEA(0,"Vorient",3);	
	//LODOP.ADD_PRINT_HTM(invHeight, 0, 800, 1000, strTableStyle);
	
	var TableHtml=GetPrintTableHtml(tableStyle,Cols,DetailData,"N")
	LODOP.ADD_PRINT_TABLE(invHeight, 0, "100%", "BottomMargin:25", TableHtml);
	
	/*������ӡ*/
	LODOP.SET_PRINT_COPIES(PrintNum)  //���ô�ӡ����
	if (IndirPrint == "N") {
		LODOP.PRINT ();  //ֱ�Ӵ�ӡ
		//LODOP.PREVIEW();
	}else{
		LODOP.PREVIEW();  //Ԥ����ӡ
	}

}