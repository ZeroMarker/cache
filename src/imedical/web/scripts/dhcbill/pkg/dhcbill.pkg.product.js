/*
 * FileName:	dhcbill.pkg.product.js
 * User:		DingSH
 * Date:		2019-09-24
 * Function:	
 * Description: 套餐产品维护
 */
 //var HospDr=session['LOGON.HOSPID'];
 var GUser = session['LOGON.USERID'];
 $(function () {
	
	//初始化Grid
	init_dg(); 
	
	//初始化套餐组	
	init_PackageGroup();

	//初始化Big-linkbutton
	init_LnkBtn_Big();
	
	//初始化linkbutton
	 init_LnkBtn();
	
	
	//声明searchbox类型 回车事件
	$('#KeyWords').searchbox({  
    searcher:function(value,name){  
        initLoadGrid();
    },  
    
  })
	
	//第一次加套餐
	initLoadGrid();
	
	$('#tPanel').hide();
	// 设置下拉框
	init_ComBobox();
	
});


function init_LnkBtn_Big() {
	//新增
	$HUI.linkbutton("#BtnDraft", {
		onClick: function () {
			initDraftClick();
		}
	}); 
	
	// 待发布
	$HUI.linkbutton("#BtnReleasePre", {
		onClick: function () {
		 iniCheckData(6,"","")
		 UpdStatus();
		}
	});
	
	
	// 发布
	$HUI.linkbutton("#BtnRelease", {
		onClick: function () {
		 setValueById("pStatus","10");
		 iniCheckData(10,"发布","审核通过")
		 showChkProdWin()
		}
	});
	
	
	// 驳回
	$HUI.linkbutton("#BtnReject", {
		onClick: function () {
	     iniCheckData(7,"驳回","")
		 showChkProdWin()
		}
	});
	

	
	//停用
	$HUI.linkbutton("#BtnStopUse", {
		onClick: function () {	
	     iniCheckData(15,"停用","")
		 showChkProdWin()
		}
	});
	
	//停售
	$HUI.linkbutton("#BtnStopSale", {
		onClick: function () {
	     iniCheckData(20,"停售","")
		 showChkProdWin()
		}
	});
	
	//保存
	$HUI.linkbutton("#ProBtnSave", {
		onClick: function () {
			initProBtnSave();
		}
	});
	//取消
	$HUI.linkbutton("#ProBtnCancel", {
		onClick: function () {
			
			$HUI.dialog("#ProductWin", 'close');
		}
	});
	
	
}


function iniCheckData(status,statusDesc,msg)
{
	
	  setValueById("pStatus",status);     //审核状态Code
	  $("#pStatusDesc").text(statusDesc); //审核状态
	  $("#pChkMsg").text(msg);         
	
}


function init_LnkBtn() {
	
/*	
	$HUI.linkbutton("#BtnFind", {
		onClick: function () {
	var url = "dhcbill.pkg.opcharge.paymshw.csp?papmiDr="+346+'&PrtStr='+232810+"&DiscAmt="+38.6+"&receiptNo="+"INV001"
	websys_showModal({
		url: url,
		title: "支付信息",
		iconCls: "icon-fee",
		width: "45%",
		height: "40%",
		onClose:function() {
			initLoadGrid();
		}
	});	
		}
	}); */
	
 $HUI.linkbutton("#BFindAll", {
		onClick: function () {
			
			setValueById('PStatus','');
			SetBtnAcess("")
			LeftBtnClick('BFindAll');
			//initLoadGrid();
		}
	}); 
	
	
	//草稿
	$HUI.linkbutton("#BDraft", {
		onClick: function () {
			setValueById('PStatus','5');
			SetBtnAcess("5")
			LeftBtnClick('BDraft');
		}
	}); 
	
	// 待发布
	$HUI.linkbutton("#BReleasePre", {
		onClick: function () {
			setValueById('PStatus','6');
			SetBtnAcess("6")
			LeftBtnClick('BReleasePre');
		}
	});
	
	// 已驳回
	$HUI.linkbutton("#BRejected", {
		onClick: function () {
		   setValueById('PStatus','7')
		   SetBtnAcess("7")
		   LeftBtnClick('BRejected');
		}
	});
	
	// 已发布
	$HUI.linkbutton("#BReleased", {
		onClick: function () {
			setValueById('PStatus','10');
			SetBtnAcess("10")
			LeftBtnClick('BReleased');
		}
	});
	
	// 已停用 
	$HUI.linkbutton("#BStopUsed", {
		onClick: function () {
			setValueById('PStatus','15');
			SetBtnAcess("15")
			LeftBtnClick('BStopUsed');
		}
	});
	
	// 已停售  
	$HUI.linkbutton("#BStopSaled", {
		onClick: function () {		
			setValueById('PStatus','20');
			SetBtnAcess("20")
			LeftBtnClick('BStopSaled');		 
		}
	});
	
	//审核确认
	$HUI.linkbutton("#pConfirm", {
		onClick: function () {	
		  var ChkMsg=getValueById("pChkMsg");
		  if (ChkMsg!="")
		  {	
		  UpdStatus();
		  }
		  else
		  {
			  $.messager.alert("提示","审批意见不能为空","info")
			 
			  
		  }
		 
		}
	});
	
	//审核取消
	$HUI.linkbutton("#pCancel", {
		onClick: function () {		
			$HUI.dialog("#CheckWin",'close')
		}
	});
	
	
}

function LeftBtnClick(id,CheckName) {
	 $(".a-oplist-selected").removeClass("a-oplist-selected");
	 $("#"+id).addClass("a-oplist-selected");
	 //$("#"+id).addClass("a-"+id.toLowerCase()+"-selected");
	 initLoadGrid();
}


/*
 * 套餐产品维护界面datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'PROCode',title:'产品编码',width:100},
			{field:'PROName',title:'产品名称',width:150 },
			{field:'PROPrice',title:'标准金额',width:80 },
			{field:'PROSalesPrice',title:'实际售价',width:80 },	
			{field:'PROMimuamout',title:'最低售价',width:80},	
			{field:'PROStatusDesc',title:'产品状态',width:80,align:'center',
				styler:function(value,row,index){
					return value==="已发布"? 'color:green;font-weight:bold':'color:red;font-weight:bold'
			}},
		    {field:'PROStatus',title:'产品状态',width:80,hidden:true },
		    {field:'PROMark',title:'备注',width:100},
		    {field:'PROStartDate',title:'有效开始日期',width:100},
		    {field:'PROTypeDesc',title:'套餐类型',width:100,align:'center'},
			{field:'PROProdTypeDesc',title:'使用类型',width:100,align:'center'},
			{field:'PROLevelDesc',title:'产品等级',width:100,align:'center'},
			{field:'PRORefundStandardDesc',title:'退费标准',width:100,align:'center'},
			{field:'PROIsshare',title:'是否共享',width:80,hidden:true},
			{field:'PROIsshareDesc',title:'是否共享',width:80},
			{field:'PROIndependentpricing',title:'是否自主定价',width:100,hidden:true},
			{field:'PROIndepDesc',title:'是否自主定价',width:100},
			{field:'PROIssellseparately',title:'是否独立售卖',width:100,hidden:true},
			{field:'PROIssellspDesc',title:'是否独立售卖',width:100},
			{field:'PROCreator',title:'创建人',width:80},
			{field:'PROCreatDate',title:'创建日期',width:100,order:'desc',sortable:true},
			{field:'PROCreatTime',title:'创建时间',width:100},
		    {field:'PROUpdateUser',title:'修改人',width:80},
			{field:'PROUpdateDate',title:'修改日期',width:100},
			{field:'PROUpdateTime',title:'修改时间',width:100},
		
			{field:'PRORefundStandard',title:'退费标准',width:100,hidden:true},
			{field:'PROUpdateUserDr',title:'PROUpdateUserDr',width:150,hidden:true },
		    {field:'PROCreatorId',title:'PROCreatorId',width:150,hidden:true },
			{field:'Rowid',title:'Rowid',width:150,hidden:true }
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		frozenColumns: [[
							{
								title: '产品详细', field: 'ProdInfo', width:80,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onclick='showProdWin("+JSON.stringify(row)+")' \
									'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png ' border=0/>\
									</a>";
								}
							}
							,
						{
						 title: '关联医嘱', field: 'ProConArc', width:80,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onclick='showProConArcWdindow("+JSON.stringify(row)+")'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/switch.png ' border=0/>\
									</a>";
								}
							}
							
							
							
							
							
						]],
						
			onSelect:function(rowIndex, rowData)
			{
			setValueById("pProdDr",rowData.Rowid)
			setValueById("pPrice",rowData.PROPrice)
			SetBtnAcess(rowData.PROStatus)	
		    },			
						
				
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}


function initLoadGrid(){
	var KeyWords=$("#KeyWords").searchbox('getValue') 
	var inArgStr="&KeyWords="+encodeURI(KeyWords);
	    inArgStr=inArgStr+"&Status="+getValueById('PStatus');
	    inArgStr=inArgStr+"&PkgDr="+getValueById('PackageGroup');
	    inArgStr= inArgStr+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID;
	var url = $URL + "?ClassName=BILL.PKG.BL.Product&QueryName=QueryProduct" +inArgStr;
    $('#dg').datagrid('options').url=url;
    $('#dg').datagrid('reload');
	
}

function init_PackageGroup(){
	$('#PackageGroup').combobox({
		valueField:'Id',
		textField:'Desc',
		url:$URL,
		mode:'remote',
		onSelect:function(data){
			initLoadGrid();					
		},
		onBeforeLoad:function(param){
			param.ClassName='BILL.PKG.BL.PackageGroup';
			param.QueryName='QueryPackageGroup';
			param.ResultSetType='array';
			param.KeyWords=param.q;
			param.ActStatus='1'
			param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
		}	
	});
}

/*
 * 套餐参产品关联医嘱维护
 */
function showProConArcWdindow(rowData){
	var url = "dhcbill.pkg.prodconarcitms.csp?ProdDr="+rowData.Rowid+'&PROCode='+rowData.PROCode+'&PROName='+charTransAsc(rowData.PROName)+'&PROStatus='+rowData.PROStatus+'&PROPrice='+rowData.PROPrice
	    url=url+'&PROSalesPrice='+rowData.PROSalesPrice+'&PROMimuamout='+rowData.PROMimuamout;
	    url=url+'&PROTypeDesc='+charTransAsc(rowData.PROTypeDesc)+'&PROStatusDesc='+ charTransAsc(rowData.PROStatusDesc)
	    url=url+'&PROProdTypeDesc='+charTransAsc(rowData.PROProdTypeDesc)+'&PROIsshareDesc='+ charTransAsc(rowData.PROIsshareDesc)
	    url=url+'&PROIndepDesc='+ charTransAsc(rowData.PROIndepDesc) +'&PROLevelDesc='+charTransAsc(rowData.PROLevelDesc)
	     url=url+'&PROIssellspDesc='+ charTransAsc(rowData.PROIssellspDesc) 
	    
	websys_showModal({
		url: url,
		title: "套餐产品关联医嘱维护",
		iconCls: "icon-w-edit",
		width: "95%",
		height: "75%",
		onClose:function() {
			initLoadGrid();
		}
	});	
}

/*
 * 点击显示产品信息
 * ---------Start----------  
 */
function showProdWin(rowData){
	$('#tPanel').show(); 
	$('#ProdInfo').window({
		width:"900",
		height:"700",
		//left:'120px',
		title:'套餐产品简介',
		iconCls: "icon-w-list"
	})
	
	$('#spProCode').text(rowData.PROCode);
	$('#spProDesc').text(rowData.PROName);
	$('#spPrice').text(rowData.PROPrice);
	$('#spSalesPrice').text(rowData.PROSalesPrice);
	$('#spMimuamout').text(rowData.PROMimuamout);
	$('#ProdInfo').window('open');
	add_ProdArcItmsTableData(rowData); //医嘱信息列表 
	
}

 /*
 * 审核弹窗
 * 
 */
function showChkProdWin(rowData){
	
		$HUI.dialog("#CheckWin",{
		title:"审核套餐",
		height:260,
		width:360,
		collapsible:false,
		modal:true,
	    iconCls: 'icon-w-update',
	    
	});
	
}

function add_ProdArcItmsTableData(rowData){
	var dgColumns = [[
			{field:'PRODArcimCode',title:'医嘱编码',width:100},
			{field:'ArcimDesc',title:'医嘱名称',width:120 },
			{field:'ItemPrice',title:'标准单价',width:90,align:'right' },
			{field:'ActualPrice',title:'实售单价',width:90,align:'right' },
			{field:'Qty',title:'数量',width:70,align:'right' },
			{field:'TotalAmt',title:'金额',width:80,align:'right' },
			{field:'SalesAmount',title:'实售金额',width:80,align:'right' },
			{field:'PRODDayNum',title:'限制天数',width:80,align:'right'},
			{field:'PRODMutex',title:'互斥标识',width:80,align:'right',hidden:true},
			{field:'ArcimRowID',title:'PRODArcimId',width:50,hidden:true},
			{field:'Rowid',title:'Rowid',width:50,hidden:true}
		]];
	$('#ProdArcItmsTable').datagrid({
		height:300,
		title:'产品医嘱信息',
		headerCls:'panel-header-gray',
		//fit: true,
		border: false,
		striped: true,
		//rownumbers: true,
		fitColumns:true,
		url: $URL,
		columns: dgColumns,
		onLoadSuccess: function (data) {
			
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
			
	var queryParams={
			ClassName:'BILL.PKG.BL.ProductDetails',
			QueryName:'QueryProductDetails',
			ProdDr:rowData.Rowid,
	}
	$('#ProdArcItmsTable').datagrid({
		queryParams:queryParams	
	})
	$('#ProdArcItmsTable').datagrid('reload');

}

function closeProdPanel(){
	$('#tPanel').hide(); 
	$('#ProdInfo').window('close')
}

/*
 * 鼠标悬浮显示产品信息
 *
 * ---------End----------  
 */
 /*
 * Description:	维护产品信息
 * Creator:		TianZJ
 * CreatDate:	2019-09-26
 */
function initDraftClick()
{
	$('#ProductWin').show(); 

	$HUI.dialog("#ProductWin",{
		title:"新增套餐",
		height:360,
		width:680,
		collapsible:false,
		modal:true,
	    iconCls: 'icon-w-edit',
	    onBeforeOpen:function(){
		    	$('#ProductWin').form('clear');
		    	$("#RefundType").combobox("setValue","01")
		    	$("#ProType").combobox("setValue","Bill")
		    	setDefValidStartDateValue();
		    	
		    }
	});
}

function init_ComBobox(){
	init_Group();
	PKGLoadDicData('Type','PacType','','combobox');
	PKGLoadDicData('ProType','PacCate','','combobox');
	PKGLoadDicData('Levol','PacLevl','','combobox');
	PKGLoadDicData('RefundType','RefStand','','combobox');

}

function initProBtnSave()
{  
	var ProGroup = getValueById('Group');
    var Isshare=0;Independentpricing=0;Issellseparately=0;ContractResponsibility=0
	var IsshareObj= getValueById("Isshare");
	if (IsshareObj==true){
		Isshare = 1;
	}
	var IndependentpricingObj = getValueById("Independentpricing");
	if (IndependentpricingObj==true){
		Independentpricing = 1;
	}
	var IssellseparatelyObj = getValueById("Issellseparately");
	if (IndependentpricingObj==true){
		Issellseparately = 1;
	}
	var ContractResponsibilityObj = getValueById("ContractResponsibility");
	if (IndependentpricingObj==true){
		ContractResponsibility = 1;
	}
	var ProDesc = getValueById('ProDesc');
    if(ProDesc ==''){
		$.messager.alert('提示', "产品描述不能为空", 'info');	
		return;
	}	
	var ProCode = getValueById('ProCode');
    if(ProCode==''){
		$.messager.alert('提示', "产品编码不能为空", 'info');	
		return;
	}	
	var Levol = getValueById('Levol');
    if(Levol ==''){
		$.messager.alert('提示', "产品等级不能为空", 'info');	
		return;
	}	
	var ValidStartDate = getValueById('ValidStartDate');
    if(ValidStartDate ==''){
		$.messager.alert('提示', "开始使用日期不能为空", 'info');	
		return;
	}	
	//var Protructure = getValueById('Protructure');
	var Protructure="" ;
	/*
    if(Protructure =='') {
		$.messager.alert('提示', "产品结构不能为空", 'info');	
		return;
	}
	*/	
	var Type = getValueById('Type')
    if(Type==''){
		$.messager.alert('提示', "套餐类型不能为空", 'info');	
		return;
	}	
	var ProType = getValueById('ProType');
    if(ProType==''){
		$.messager.alert('提示', "使用类型不能为空", 'info');	
		return;
	}	
	var RefundType = getValueById('RefundType');
    if(RefundType==''){
		$.messager.alert('提示', "退费标准不能为空", 'info');	
		return;
	}
	// 判断此产品组能是不是已经有相同的产品，有时，则不让添加成功。
	// 判断没有维护产品组时，是不时已经存在相同的产品，有时，则不让添加成功。
	// 共享、自主定价、独立售卖、包干、产品描述、产品编码、开始使用日期、等级、结构、产品类型、使用类型、退费标准
	var ExStr=ProGroup+"^"+ProCode+"^"+ProDesc+"^"+ValidStartDate+"^"+Levol+"^"+Protructure+"^"+ProType+"^"+Type+"^"+RefundType;
	ExStr = ExStr+"^"+Isshare+"^"+Independentpricing+"^"+Issellseparately+"^"+ContractResponsibility;
	ExStr = ExStr+"^"+PUBLIC_CONSTANT.SESSION.USERID+"^"+PUBLIC_CONSTANT.SESSION.HOSPID
	$.m({
		ClassName: "BILL.PKG.BL.Product",
		MethodName: "CheckProduct",
		ProGroup:ProGroup,
		Code:ProCode,
		Desc:ProDesc,
	}, function (rtn) {
		if(rtn!='0'){
			$.messager.alert('提示','已经存在相同的产品，不允许增加'+rtn,'info');
			return ;
		}else{
			saveInfo(ExStr); // 不重复才能进行发放
		}
	});
}

function saveInfo(ExStr){
	$.m({
		ClassName: "BILL.PKG.BL.Product",
		MethodName: "ProGroupDuctSave",
		ExStr: ExStr
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
			$.messager.alert('提示', "保存成功", 'info');
			setTimeout("initLoadGrid()",1500);	
		}else{
			$.messager.alert('提示', "保存失败，错误代码：" + rtn.split('^')[1], 'error');	
		}
		$HUI.dialog("#ProductWin", 'close');
	});
}

function init_Group(){
	$('#Group').combobox({
		valueField:'Id',
		textField:'Desc',
		url:$URL,
		mode:'remote',
		onSelect:function(data){
			initLoadGrid();
		},
		onBeforeLoad:function(param){
			param.ClassName='BILL.PKG.BL.PackageGroup';
			param.QueryName='QueryPackageGroup';
			param.ResultSetType='Array';
			param.KeyWords=param.q;
			param.ActStatus='1'
			param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
		}		
	});
}

//审核状态更新
function UpdStatus(){
	
	if (getValueById("pProdDr")==""){
		
		$.messager.alert("提示","请选一条待审的套餐","info")
		return ;
		
		}
		
	if (getValueById("pPrice")=="0.00"){
		
		$.messager.alert("提示","请先为此套餐关联医嘱","info")
		return ;
		
		}
		
		
	
	$.m(
	
	    {
		    ClassName:"BILL.PKG.BL.Product",
		    MethodName:"UpdStatus",
		    ProdDr:getValueById("pProdDr"),
		    Status:getValueById("pStatus"),
		    ChkMsg:getValueById("pChkMsg"),
		    UserDr:GUser,
		    ExpStr:""
		   
		 },
	    
	    function(rtn)
	    {
		    
		    if(rtn.split("^")[0]==0)
		    {
			    
			    $.messager.alert("提示","审核完成","info")
			    setTimeout("initLoadGrid()",1500);
			    $HUI.dialog("#CheckWin",'close')
			}else
			{
				
				$.messager.alert("提示","审核失败,Err="+rtn,"error")
				
		    }
		    
		    
		 }
	
	
    	);
	
	
	
	
	}


//设置审核按钮权限	
function SetBtnAcess(Status)
{
	
	
	
	
   if(Status=="")
   {
	   disableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
	 
   //5 草稿状态	 
   if(Status==5)
   {
	   enableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
   //6 待发布状态	 
   if(Status==6)
   {
	   
	   disableById("BtnReleasePre"); //待发布
	   enableById("BtnReject");     //驳回
	   enableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
   //7 驳回状态	 
   if(Status==7)
   {
	   
	   enableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
   //10 发布状态	 
   if(Status==10)
   {
	   
	   disableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   enableById("BtnStopUse");    //停用
	   enableById("BtnStopSale");   //停售
	   
   }
   //15 停用状态
   if(Status==15)
   {
	   
	   disableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
    //20 停售状态
   if(Status==20)
   {
	   
	   disableById("BtnReleasePre"); //待发布
	   disableById("BtnReject");     //驳回
	   disableById("BtnRelease");   //发布
	   disableById("BtnStopUse");    //停用
	   disableById("BtnStopSale");   //停售
	   
   }
   
   
	 
	 
}


/**
* 开始使用日期设置默认
*/
function setDefValidStartDateValue() {
	
	var curDateTime = getCurDateTime();
	var myAry = curDateTime.split(/\s+/);
	setValueById("ValidStartDate", myAry[0]);
	
}

/**
* 取当前时间
*/
function getCurDateTime() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
}


// 院区combogrid选择事件
function selectHospCombHandle(){
	init_PackageGroup()
	//alert("PUBLIC_CONSTANT.SESSION.HOSPID="+PUBLIC_CONSTANT.SESSION.HOSPID)
	initLoadGrid()
	
	}