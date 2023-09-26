var PageLogicObj = {
	m_OrderList:"",
	m_PrescNoList:"",
	m_DiagList:""
}
$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	//诊断列表
	PageLogicObj.m_DiagList=InitDiagList();
	//加载诊断列表
	LoadDiagList();
	//初始化处方
	PageLogicObj.m_PrescNoList=InitPrescNoList();
}
function InitEvent(){
	//保存处方对应的诊断
	$('#Save').bind('click',InsertPresc)
	$HUI.radio(".hisui-radio",{
        onChecked:function(e,value){
	        setTimeout(function() {
				LoadDiagList();
				SetDiagselect();
			}, 100);
        }
    });
	//退出
	/*$('#Exit').bind('click',function(){
		$.messager.confirm('确认','是否退出',function(r){    
    		if (r){    
        			this.close();
    		}    
		}); 
	})*/	
}
function InitPrescNoList(){
	var PrescNoListGrid=$('#PrescNoList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,   
		pageSize: 30,
		pageList : [30,100,200],
		url:$URL+"?ClassName=web.DHCDocDiagLinkToPrse&QueryName=GetAllPrescList&EpisodeID="+ServerObj.EpisodeID+"&PrescNoFind="+ServerObj.PrescNoStr+"&LogOnUser="+session['LOGON.USERID'],
		idField:"prceno",
		columns :[[ 
			{field:'prceno',checkbox:true},
			{field:'prcedesc',title:"处方",align:'left'}
		]],
		onSelect:function (rowIndex, rowData){
			LoadOrderList();
			SetDiagselect();
		},
		onUnselect:function (rowIndex, rowData){
			LoadOrderList();
			SetDiagselect();
		},
		onSelectAll:function (rows){
			LoadOrderList();
			SetDiagselect();
		},
		onUnselectAll:function (rows){
			LoadOrderList();
			SetDiagselect();
		},
		onLoadSuccess:function(data){
			if (data['total']==1){
				$(this).datagrid('selectRow',0);
			}
		}
	});
	return PrescNoListGrid
}
function InitDiagList(){
	var tabdatagrid=$('#DiagList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,   
		pageSize: 20,
		pageList : [20,50],
		idField:"diaid",
		columns :[[ 
				{field:'RowCheck',checkbox:true},
				{field:'desc',title:"诊断描述",width:400,align:'left'},
				{field:'diaid',title:"诊断ID",width:60,align:'left',hidden:true},
			]]
	});
	return tabdatagrid
}
function IntorderlistList(){
	var tabdatagrid=$('#OrderList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,   
		pageSize: 30,
		pageList : [30,100,200],
		idField:"RowId",
		columns :[[ 
			{field:'OrderName',title:"医嘱名称",width:150,align:'left'},
			{field:'statDesc',title:"状态",width:60,align:'left'},
			{field:'OrderDoseQty',title:"剂量",width:60,align:'left'}, 
			{field:'OrderDoseUOM',title:"单位",width:60,align:'left'},
			{field:'Freq',title:"频率",width:60,align:'left'},
			{field:'Instruc',title:"用法",width:60,align:'left'},
			{field:'OrderDur',title:"疗程",width:60,align:'left'},
			{field:'OrderPackQty',title:"整包装量",width:80,align:'left'},
			{field:'OrderPackUOM',title:"单位",width:80,align:'left'},
			{field:'reloc',title:"接收科室",width:100,align:'left'},
			{field:'OrderPrice',title:"单价",width:60,align:'left'},
			{field:'OrderPriceAll',title:"金额",width:60,align:'left'},
			{field:'AdmReason',title:"费别",width:60,align:'left'},
			{field:'InsuClass',title:"医保类别",width:80,align:'left'},
			{field:'poisondesc',title:"管制分类",width:80,align:'left'},
			{field:'Initials',title:"工号",width:60,align:'left'},
			{field:'UserAdd',title:"医生",width:100,align:'left'},
			{field:'orderdr',title:"医嘱项ID",width:80,align:'left'},
		 ]],
		 onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
		}
	});
	return tabdatagrid
}
function LoadOrderList(){
	if (PageLogicObj.m_OrderList==""){
		//初始化医嘱列表
		PageLogicObj.m_OrderList=IntorderlistList();
	}
	var rows=PageLogicObj.m_PrescNoList.datagrid("getSelections");
	var PrescNoStr="";
	for (var i=0;i<rows.length;i++){
		if (PrescNoStr=="") PrescNoStr=rows[i]['prceno'];
		else  PrescNoStr=PrescNoStr+"^"+rows[i]['prceno'];
	}
	$cm({
		ClassName:"web.DHCDocDiagLinkToPrse",
		QueryName:"FindPrseOrderList",
		EpisodeID:ServerObj.EpisodeID,
		PrescNoStr:PrescNoStr,
		Pagerows:PageLogicObj.m_OrderList.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_OrderList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});	
}
function SetDiagselect(){
	var rows=PageLogicObj.m_PrescNoList.datagrid("getSelections");
	var PrescNoStr="";
	for (var i=0;i<rows.length;i++){
		if (PrescNoStr=="") PrescNoStr=rows[i]['prceno'];
		else  PrescNoStr=PrescNoStr+"^"+rows[i]['prceno'];
	}
	PageLogicObj.m_DiagList.datagrid('unselectAll');
	var DiaStr=$cm({
		ClassName:"web.DHCDocDiagLinkToPrse",
		MethodName:"getDia",
		dataType:"text",
		PrescNoStr:PrescNoStr,
	},false);
	if (DiaStr!=""){
		var DiaArry=DiaStr.split(String.fromCharCode(1));
		var data=PageLogicObj.m_DiagList.datagrid("getData")
		for (i=0;i<data.rows.length;i++){
			var diaid=data.rows[i].diaid;
			if (diaid==""){continue}
			if (("^"+DiaArry+"^").indexOf("^"+diaid+"^")>=0){
				PageLogicObj.m_DiagList.datagrid("selectRow",i)
			}
		}
	}
}
function LoadDiagList(){
	var GridData=$.cm({
		ClassName:"web.DHCDocDiagLinkToPrse",
		QueryName:"GetDiaQuery",
		Adm:ServerObj.EpisodeID,
		Type:$("input[name='DiagType']:checked")[0].value,
		Pagerows:PageLogicObj.m_DiagList.datagrid("options").pageSize,rows:99999
	},false);
	PageLogicObj.m_DiagList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
}
function InsertPresc(){
	var rows=PageLogicObj.m_PrescNoList.datagrid("getSelections");
	var PrescNoStr="";
	for (var i=0;i<rows.length;i++){
		if (PrescNoStr=="") PrescNoStr=rows[i]['prceno'];
		else  PrescNoStr=PrescNoStr+"^"+rows[i]['prceno'];
	}
	if (PrescNoStr==""){
		$.messager.alert("提示","请选择处方!")
		return false
	}
	var rows=PageLogicObj.m_DiagList.datagrid("getSelections");
	var DiagIdStr="";
	for (var i=0;i<rows.length;i++){
		if (DiagIdStr=="") DiagIdStr=rows[i]['diaid'];
		else  DiagIdStr=DiagIdStr+"^"+rows[i]['diaid'];
	}
	if (DiagIdStr==""){
		$.messager.alert("提示","请勾选需要关联的诊断!")
		return false
	}
   var rtn=$cm({
		ClassName:"web.DHCDocDiagLinkToPrse",
		MethodName:"Insert",
		dataType:"text",
		PrescNoStr:PrescNoStr,
		DiagIdStr:DiagIdStr,
		UserDr:session['LOGON.USERID'],
   },false);
  if (rtn==0){
	   $.messager.popover({msg: '保存成功！',type:'success'});
	   PageLogicObj.m_PrescNoList.datagrid("reload");
	   window.setTimeout('CloseAtto()',100)
	   return true
  }else{
	  $.messager.alert("提示","保存失败"+rtn)
	  return false
  }
}
function CloseAtto()
{
	//自动关闭标识
	if (ServerObj.ExitFlag=="Y"){
		   websys_showModal("close");
	 }
	
}