$(function(){
	Init() 
 });
 function Init(){
	InitButton()
	InitLocDocTree()
	InitWeek()
	InitStopReason()
	InitSelLocList()
	InitBatchStopList()
	InitTimeRange()
	
	setTimeout("BatchStopListLoad('','')",100)
	$("#SerchLoc").bind("keyup",findLocData);
 }
 function InitButton(){
	$("#Find").bind("click",FindClick)
	$("#Stop").bind("click",StopClick)
	$("#CancelStop").bind("click",CancelStopClick)
 }
 
 function InitLocDocTree(){
	var url = "dhcbatchstoprequest.csp?pid=0&userid="+session["LOGON.USERID"]+"&groupid="+session["LOGON.GROUPID"]
	$("#LocDocTree").tree({
		url:url,
		multiple:true,
		lines:true,
		checkbox:true,
		onCheck:function(node,checked){
			var nodeIdArr=node.id.split("^")
			if(nodeIdArr[0]=="Exa"){
				var nodeChilds=$("#LocDocTree").tree("getChildren",node.target)
				for(var i=0;i<nodeChilds.length;i++){
					AddDataToSelLocDoc(nodeChilds[i],checked)
				}
			}else{
				AddDataToSelLocDoc(node,checked)
			}
			
		},
		onBeforeExpand:function(node,param){
             $("#LocDocTree").tree('options').url = "dhcbatchstoprequest.csp?pid="+node.id+"&userid="+session["LOGON.USERID"]+"&groupid="+session["LOGON.GROUPID"];
		}, 
		onLoadSuccess:function(node,data){
		},
		onSelect:function(node){
	
			var node=$("#LocDocTree").tree("find",node.id)
			if(node.checked){
				$("#LocDocTree").tree("uncheck",node.target)
				
			}else{
				
				$("#LocDocTree").tree("check",node.target)
			}
		},
		toolbar:[{
			iconCls: 'icon-edit',
			handler: function(){alert('编辑按钮')}
		}]
	}); 
 }
 function InitWeek(){
	 $('#DayWeek').combobox({      
    	valueField:'Id',   
    	textField:'Desc',
		editable:false,
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCBatchStopNew';
						param.QueryName = 'DayWeekFind'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			if(record.Desc=="&nbsp;"){
				 $('#DayWeek').combobox("setText","")
			}
		},onLoadSuccess:function(){
			$('#DayWeek').combobox("setText","")
		}  

	});
 }
  function InitStopReason(){
	 $('#StopReason').combobox({      
    	valueField:'Id',   
    	textField:'Desc',
		editable:false,
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCBatchStopNew';
						param.QueryName = 'StopReasonFind'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			if(record.Desc=="&nbsp;"){
				 $('#StopReason').combobox("setText","")
			}
		},
		onLoadSuccess:function(){
			$('#StopReason').combobox("setText","")
		}  


	});
	
 }
 function InitSelLocList(){
	 //idField:'LocRowId',
	$("#SelLocDoc").datagrid({
		width:'auto',
		border:true,
		striped:true,
		singleSelect:true,
		autoRowHeight:true,
		singleSelect : true, 
		fitColumns : true,
		url:'',
		loadMsg:'',
		rownumbers:true,
		columns:[[
			{field:'LocRowId',title:'LocRowId',hidden:true},
			{field:'LocDesc',title:'科室',width:120,align:'center'},
			{field:'DocRowId',title:'DocRowId',width:230,align:'center',hidden:true},
			{field:'DocDesc',title:'医生',width:40,align:'center'},
			{field:'ItemOpt',title:'操作',width:40,align:'center',formatter:SetCellOpUrl}
			
		]],
		onSelect:function(rowid,RowData){
			
		},
		onDblClickRow:function(rowIndex,rowData){
			//var TarItemCatId=rowData.TarItemCatId
			//window.returnValue=TarItemCatId
			//window.close()
		}
	});
	 
 }
 function InitBatchStopList(){
	$("#BastStopList").datagrid({
		width:'auto',
		border:true,
		striped:true,
		singleSelect:true,
		autoRowHeight:true,
		singleSelect : false, 
		fitColumns : true,
		url:'',
		loadMsg:'正在加载',
		rownumbers:true,
		pagination:true,
		height:270,
		columns:[[
			{field:'check',title:'',width:120,align:'center',checkbox:true},
			{field:'TLoc',title:'科室',width:100,align:'center'},
			{field:'TDoc',title:'医生',width:40,align:'center'},
			{field:'TStopReason',title:'停诊原因',width:40,align:'center'},
			{field:'TStartDate',title:'开始日期',width:40,align:'center'},
			{field:'TEndDate',title:'结束日期',width:40,align:'center'},
			{field:'NARowid',title:'NARowid',width:40,align:'center',hidden:true},
			{field:'RSVP',title:'执行方式',width:40,align:'center'},
			{field:'NAFlag',title:'停诊标志',width:40,align:'center'},
			{field:'PutDOW',title:'星期',width:40,align:'center'},
			{field:'TimeRange',title:'时段',width:40,align:'center'}
		]],
		onSelect:function(rowid,RowData){
			
		},
		onDblClickRow:function(rowIndex,rowData){
			//var TarItemCatId=rowData.TarItemCatId
			//window.returnValue=TarItemCatId
			//window.close()
		}
	}); 
 }
 function InitTimeRange(){
	$('#TimeRange').combobox({      
    	valueField:'Id',   
    	textField:'Desc',
		editable:false,
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCBatchStopNew';
						param.QueryName = 'TimeRangeFind'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			if(record.Desc=="&nbsp;"){
				 $('#TimeRange').combobox("setText","")
			}
		},onLoadSuccess:function(){
			$('#TimeRange').combobox("setText","")
		}  

	});
 }
 function BatchStopListLoad(StartDate,EndDate){
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCBatchStopNew';
	queryParams.QueryName ='FindStopResult';
	queryParams.Arg1 =StartDate;
	queryParams.Arg2 =EndDate;
	queryParams.ArgCnt =2;
	var opts = $("#BastStopList").datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#BastStopList").datagrid('load', queryParams); 
 }
 function AddDataToSelLocDoc(node,checked){
	var LocRowId="", LocDesc="",DocRowId="",DocDesc=""
	var isLeaf = $("#LocDocTree").tree('isLeaf',node.target); 
	if(isLeaf){
		var parentNode=$("#LocDocTree").tree("getParent",node.target)
		LocRowId=parentNode.id
		LocDesc=parentNode.text
		DocRowId=node.id
		DocDesc=node.text
	}else{
		LocRowId=node.id
		LocDesc=node.text
	}
	var rows=$("#SelLocDoc").datagrid("getRows")
	var LocDocStr=""
	var LocArr=new Array()
	var rowLen=rows.length
	for(var i=(rowLen-1);i>=0;i--){
		var rowObj=rows[i]
		var LocId=rowObj.LocRowId
		var DocId=rowObj.DocRowId
		if(LocId==LocRowId){
			$("#SelLocDoc").datagrid("deleteRow",i)	
		}	
	}
	if(DocRowId==""){
		if(checked){
			addItmSelList(LocRowId, LocDesc,DocRowId,DocDesc);
		}
	}else{
		var parentNode=$("#LocDocTree").tree("getParent",node.target)
		if(parentNode.checked){
			addItmSelList(LocRowId, LocDesc,"","");
		}else{
			var childNodes=$("#LocDocTree").tree("getChildren",parentNode.target)
			for(var i=0;i<childNodes.length;i++){
				if(childNodes[i].checked){
					DocRowId=childNodes[i].id
					DocDesc=childNodes[i].text
					addItmSelList(LocRowId, LocDesc,DocRowId,DocDesc);
				}
				
			}
		}
	}
		
 }
 function BodyLoadHandler(){
	 
 }
 /// 查找检查项目树
function findLocData(event){
	var PyCode=$.trim($("#SerchLoc").val());
	var url = $("#LocDocTree").tree('options').url = "dhcbatchstoprequest.csp?pid=0"+"&desc="+PyCode+"&userid="+session["LOGON.USERID"]+"&groupid="+session["LOGON.GROUPID"];
	$('#LocDocTree').tree('options').url =encodeURI(url);
	$(LocDocTree).tree('reload');
}
function SetCellOpUrl(){
	/// 操作
}
function SetCellOpUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>删除</a>";
    return html;

}
/// 删除行
function delItmSelRow(rowIndex){	
	/// 删除行
	$("#SelLocDoc").datagrid('deleteRow',rowIndex);
	/// 刷新列表数据
	var selItems=$("#SelLocDoc").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#SelLocDoc').datagrid('refreshRow', index);
	})
} 
/// 加入项目列表
function addItmSelList(LocRowId, LocDesc,DocRowId,DocDesc){

	var rowobj={LocRowId:LocRowId, LocDesc:LocDesc, DocRowId:DocRowId,DocDesc:DocDesc,ItemOpt:""}
	$("#SelLocDoc").datagrid('appendRow',rowobj);
} 
/// 删除列表数据
function delItmSelList(LocRowId, LocDesc,DocRowId,DocDesc){
	
	var selItems=$("#SelLocDoc").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmSelRow(index);  /// 删除对应行
			return false;
		}
	})
} 
function FindClick(){
	var StartDate=$("#StartDate").datebox("getValue")
	var EndDate=$("#EndDate").datebox("getValue")
	BatchStopListLoad(StartDate,EndDate)
}
function StopClick(){
	var rows=$("#SelLocDoc").datagrid("getRows")
	var LocDocStr=""
	var LocArr=new Array()
	for(var i=0;i<rows.length;i++){
		var rowObj=rows[i]
		var LocRowId=rowObj.LocRowId
		var DocRowId=rowObj.DocRowId
		LocRowId=LocRowId.split("^")[1]
		if(DocRowId!=""){
			DocRowId=DocRowId.split("^")[1]
		}
		if(typeof(LocArr[LocRowId])!="undefined"){
			if(DocRowId!=""){
				LocArr[LocRowId]=LocArr[LocRowId]+"^"+DocRowId
			}
		}else{
			LocArr[LocRowId]=DocRowId
		}
	}
	for(var LocId in LocArr){
		var DocIdStr=LocArr[LocId]
		if(LocDocStr==""){
			LocDocStr=LocId+"!"+DocIdStr
		}else{
			LocDocStr=LocDocStr+"|"+LocId+"!"+DocIdStr
		}
	}
	if(LocDocStr==""){
		$.messager.alert('提示','请选择科室和医生!');
		return 
	}
	var StartDate=$("#StartDate").datebox("getValue")
	var EndDate=$("#EndDate").datebox("getValue")
	if(StartDate==""){
		$.messager.alert('提示','开始日期不能为空!');
		//alert("开始日期不能为空!")
		return 
	}
	if(EndDate==""){
		$.messager.alert('提示','结束日期不能为空!');
		//alert("结束日期不能为空!");
		return;
	}
	//判断有没有预约记录
	var DayWeekId=$('#DayWeek').combobox("getValue")
	var TimeRangeId=$('#TimeRange').combobox("getValue")
	var ret=tkMakeServerCall("web.DHCBatchStopNew","CheckResData",StartDate,EndDate,LocDocStr,DayWeekId,TimeRangeId)
	if(ret!=""){
		ret=ret.split(",").join("\n")
		if(!confirm(ret+" \n是否继续?")){
			return 
		}
	}
	var DayWeekId=$('#DayWeek').combobox("getValue")
	var StopReasonId=$('#StopReason').combobox("getValue")
	var ret=tkMakeServerCall("web.DHCBatchStopNew","BatchStopAll",StartDate,EndDate,LocDocStr,StopReasonId,DayWeekId,session["LOGON.USERID"],"","S",TimeRangeId)
	if(ret!=0){
		$.messager.alert('提示','长时段停诊失败!');
	}else{
		$.messager.alert('提示','长时段停诊成功!');	
		//加载停诊列表
		BatchStopListLoad(StartDate,EndDate)
		///
		$('#SelLocDoc').datagrid('loadData', { total: 0, rows: [] }); 
	}
}
function CancelStopClick(){
	var rows=$("#BastStopList").datagrid("getSelections") 
	if(rows.length==0){
		$.messager.alert('提示','请选择一条记录!');
		return 
	}
	var rowistr=""
	for(var i=0;i<rows.length;i++){
		var rowObj=rows[i]
		var rowid=rowObj.NARowid
		if(rowistr=="") rowistr=rowid
		else  rowistr=rowistr+"^"+rowid
		//
		
	}
	if(ret!=""){
		var ret=tkMakeServerCall("web.DHCBatchStopNew","UpdateNotAvailSel",rowistr,session["LOGON.USERID"],"N")
		if(ret==0){
			//加载停诊列表
			BatchStopListLoad("","")
		}else{
			alert("撤销停诊失败!")
		}
	}
	
	
}

 