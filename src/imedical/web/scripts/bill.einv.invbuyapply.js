// 入口函数
$(function(){
	setPageLayout(); //初始化页面布局
	setElementEvent(); //初始化页面元素事件
	initSetValue(); // 结束号码赋值
});

//初始化页面布局
function setPageLayout(){
	//申请状态下拉框
	$HUI.combobox("#IBAApplyStatus",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'All',desc:'全部',selected:true},
			{code:'1',desc:'已申请'},
			{code:'2',desc:'申请成功'},
			{code:'3',desc:'申请失败'},
			{code:'9',desc:'申请作废'}
		],
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//库存状态下拉框
	$HUI.combobox("#IBAStockStatus",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'All',desc:'全部',selected:true},
			{code:'1',desc:'待入库'},
			{code:'2',desc:'已入库'},
			{code:'9',desc:'已撤销'}
		],
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//申请人下拉框
	$HUI.combobox('#IBAUsr', {
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		panelHeight:150,
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvBuyApplyCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#IBAUsr').combobox('getValue');
		},
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//票据类型下拉框
	$HUI.combobox("#invoice_type",{
		valueField:'value', 
		textField:'text'
	});
	//加载票据类型下拉框数据
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"GetEInvTypeList"
	},function(jsonData){
		if(jsonData.status>=0){
			$('#invoice_type').combobox('loadData', jsonData.EinvTypeArr);
			$('#INVBuyType').combobox('loadData', jsonData.EinvTypeArr);
		}
	});
	//发票购入类型下拉框
	$('#INVBuyType').combobox({ 
		valueField:'value', 
		textField:'text',
		onLoadSuccess:function(){
			reloadInvBuyApplyView();	
		},
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//电子票据种类代码列表 
	$('#InvBuyApplyView').datagrid({
		url:$URL,
    	fit:true,
    	border:false,
    	striped:true,
    	singleSelect:true,
    	pagination:true,
    	pageSize:30,
    	pageList:[30,40,50],
    	queryParams: {
			ClassName: 'BILL.EINV.BL.COM.InvBuyApplyCtl',
			QueryName: 'QueryInvBuyApplyInfo'
		},
    	columns:[[ 
    		//{field:"Check",id:"Check",checkbox:true},
        	//{field:'ID',title:'ID',width:100,hidden:true},
        	{field:'ID',title:'ID',width:100},
        	{field:'IBATypeCode',title:'票据种类代码',width:100,hidden:true},    
    		{field:'IBATypeName',title:'票据种类名称',width:100},
        	{field:'IBAEBillCount',title:'票据总数',width:80},
        	/*
        	{field:'IBAApplyFlag',title:'电子票据申请标志',width:130,
        		formatter:function(value,row,index){
					if(value=="1"){
						return "待申请"	
					}else{
						return "已申请"
					}
				}
        	},*/
        	//{field:'IBAApplyCount',title:'申请单数量',width:100},
        	{field:'IBAStartNo',title:'票据开始号码',width:100},
        	{field:'IBAEndNo',title:'票据结束号码',width:100},
        	{field:'IBAApplyStatus',title:'申请状态',width:100,
        		formatter:function(value,row,index){
					if(value=="1"){
						return "已申请"	
					}else if(value=="2"){
						return "申请成功"	
					}else if(value=="3"){
						return "申请失败"	
					}else if(value=="9"){
						return "申请作废"	
					}else{
						return "待申请"
					}
				}
        	},
        	{field:'IBAStockStatus',title:'票据库存状态',width:100,
        		formatter:function(value,row,index){
					if(value=="2"){
						return "已入库"	
					}else if(value=="9"){
						return "已撤销"
					}else{
						return "待入库"
					}
				}
        	},
        	{field:'ApplyCommon',title:'申请备注',width:200},
        	//{field:'StockApplyCommon',title:'取消申请备注',width:200,editor:'text'},
        	{field:'RevokeCommon',title:'取消申请备注',width:200,editor:'text'},
        	{field:'IBAUsr',title:'申请人',width:130}, 
        	{field:'cancelApply',title:'撤销申请',width:100,align:'center'
				,formatter:function(value,row){
					var rtn="";
					if ((row.IBAStockStatus != "2")&&(row.IBAApplyStatus != "9")&&(row.IBAApplyStatus != "2")){
						rtn="<a href='#'  class='DelItnconbtn'><img style='padding-left:0px;'src='../images/icons/undo.png' border=0/></a>";
					}
					return rtn;
				}
			},
        	 {field:'store',title:'入库',width:100,align:'center'
				,formatter:function(value,row){
					var rtn="";
					if ((row.IBAStockStatus != "2")&&(row.IBAStockStatus != "9")&&(row.IBAApplyStatus != "9")){
						rtn="<a href='#'  class='DelItnconbtn'><img style='padding-left:0px;'src='../images/icons/redo.png' border=0/></a>";
					}
					return rtn;
				}
			},
			{field:'StockUsr',title:'入库人',width:130},
			{field:'StockApplyUsr',title:'取消申请人',width:130},
        	{field:'IBAApplyNo',title:'申请单号',width:100},   
        	{field:'IBABusNo',title:'申请唯一流水号',width:120},
        	{field:'IBAResultCode',title:'返回申请结果代码',width:130},
        	{field:'IBAResultMeg',title:'返回申请结果描述',width:130},
        	{field:'IBAInvoiceCode',title:'电子票据代码',width:100},
        	{field:'IBAInvoiceName',title:'电子票据名称',width:100},
        	{field:'IBAApplyList',title:'返回申请单列表',width:120},
        	{field:'IBAApplyDate',title:'申请成功日期',width:100},
        	{field:'IBAApplyTime',title:'申请成功时间',width:100},
        	{field:'StockDate',title:'入库日期',width:100},
        	{field:'StockTime',title:'入库时间',width:100},
        	{field:'UpdateDate',title:'最近一次更新日期',width:130},
        	{field:'UpdateTime',title:'最近一次更新时间',width:130},
        	{field:'StockApplyDate',title:'取消申请新日期',width:130},
        	{field:'StockApplyTime',title:'取消申请时间',width:130}
    	]],
        onLoadSuccess:function(){ 
        	
        	/*
        	var Rows=$('#InvBuyApplyView').datagrid('getRows');
        	var ApplyRecs=new Array()
        	for(n=0;n<Rows.length;n++){
	        	if(Rows[n].IBAApplyStatus=="1"){
		        	ApplyRecs.push(Rows[n]);
		        }
	        }
	        var i=0;
	        var ErrMsg=""
	        SearchApplyResults(ApplyRecs, i, ErrMsg);
	        */
	        GetBuyApplyResult();   //查询本页面 已申请的记录的结果
	        
	        //查询是否有待入库状态的数据 并获取本页面的待入库数据信息
	        SearchNotStockData();
		},
		onClickRow:function(index, row){
			//EditRevokeCommonRow(index, row);  //编辑备注行	
		},
		onClickCell:function(index, field, value){
			var DataRows=$('#InvBuyApplyView').datagrid('getRows');
			var RowData=DataRows[index];
			if(field=="RevokeCommon"){
				EditRevokeCommonCell(RowData,index); //编辑取消备注列
			}
			if(field=="cancelApply"){
	    		cancelInvBuyApply(RowData,index); //申请撤消
			}
			if(field=="store"){
	    		SaveInvBuyApply(RowData,index); //入库
			}	
		}
	});
}

//初始化页面元素事件
function setElementEvent(){
	//申请窗口
	$('#AduitBtn').click(function(){
		$('#ApplyCount').val("");  //申请数量
		$('#ApplyCommon').val(""); //申请备注
		$('#startNo').val("");	   //开始号码
		$('#endNo').val("");	   //结束号码
		$('#applyDialog').dialog({
			title:'购入申请',
			width:575,
			height:300,
			closed:false,
			cache:false,
			modal:true
		});
	});
	//提交申请
	$('#ApplyBtn').click(function(){
		InvBuyApply();  //票据申请
	});
	//查询票据列表
	$('#SearchBtn').click(function(){
		reloadInvBuyApplyView();  //重新加载申请列表
	});
	//批量撤销申请
	$('#batchCancelBtn').click(function(){
		batchCancelApply(); //批量撤消申请
	});
}
//重新加载申请列表数据
function reloadInvBuyApplyView(){
	var INVBuyType=$('#INVBuyType').combobox('getValue');
	var IBAApplyStatus=$('#IBAApplyStatus').combobox('getValue');
	var IBAStockStatus=$('#IBAStockStatus').combobox('getValue');
	var IBAUsr=$('#IBAUsr').combobox('getValue');
	if($.trim($('#IBAUsr').combobox('getText'))==""){
		var IBAUsr="";	
	}
	var InputPam=INVBuyType+"^"+IBAApplyStatus+"^"+IBAStockStatus+"^"+IBAUsr;
	//alert(InputPam)
	$('#InvBuyApplyView').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		QueryName:"QueryInvBuyApplyInfo",
		InputPam:InputPam	
	});
}
//申请提交
function InvBuyApply(){
	var invoice_type_code=$('#invoice_type').combobox('getValue'); //票据代码
	var invoice_type_name=$('#invoice_type').combobox('getText');  //票据种类
	var ApplyCount=$('#ApplyCount').val();						   //申请数量
	var startNo=$('#startNo').val();							   //开始号码
	var endNo=$('#endNo').val();							   	   //结束号码
	if(ApplyCount==""){
		alert("申请数量不能为空！");
		return	
	}
	var ApplyCommon=$('#ApplyCommon').val();					   //申请备注
	// DataInfo="1票据种类代码^2票据种类名称^3申请数量^4开始号码^5结束号码^6申请人^7安全组^8登陆科室"
	var DataInfo=invoice_type_code+"^"+invoice_type_name+"^"+ApplyCount+"^"+startNo+"^"+endNo+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"InvBuyApply",
		DataInfo:DataInfo,
		ApplyCommon:ApplyCommon
	},function(data){
		if(data.status>0){
			//alert("申请成功！");
			$.messager.alert("简单提示", "申请成功！", 'success');
			$('#InvBuyApplyView').datagrid('appendRow',data.ApplyData);
			$('#applyDialog').dialog('close');
		}else{
			alert(data.info);
		}
	});
}
// 入库
function SaveInvBuyApply(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAStockStatus != "9")&&(RowData.IBAApplyStatus != "9")){
		$.messager.confirm('确认对话框', '您确定要入库吗？', function(r){
			if (r){
				var ID=RowData.ID;
				var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
				$cm({
					ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
					MethodName:"SaveApplyInvResult",
					InputPam:InputPam
				},function(data){
					if(data.status>0){
						$.messager.alert("简单提示", "入库成功！", 'success');
						//$('#InvBuyApplyView').datagrid('load');
						$('#InvBuyApplyView').datagrid('updateRow',{
							index:index,
							row:data.ApplyData
						});			
					}else{
						alert(data.info);	
					}
				});
			}
		});
	}	
}
var EditIndex=undefined;
//编辑取消编辑列
function EditRevokeCommonCell(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAApplyStatus != "9")&&(RowData.IBAApplyStatus != "2")){
		if((EditIndex!=index)&&(EditIndex!=undefined)){   //先结束编辑当前行，再开始编辑新增行，保证只有一行处于编辑状态
			$('#InvBuyApplyView').datagrid('endEdit',EditIndex);
		}
		$('#InvBuyApplyView').datagrid('beginEdit', index);
		EditIndex=index;
		var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
		$(ed.target).focus();
	}else{
		$('#InvBuyApplyView').datagrid('endEdit',EditIndex);	
	}	
}

// 撤销购入申请
function cancelInvBuyApply(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAApplyStatus != "9")&&(RowData.IBAApplyStatus != "2")){
		var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
		if(ed == null){
			$.messager.confirm('提示框', '您是否要填写取消申请备注？', function(r){
				if(r){
					$('#InvBuyApplyView').datagrid('beginEdit', index);
					EditIndex=index;
					var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
					$(ed.target).focus();
				}else{
					ConfirmCancelApply(index);	
				}
			});
		}else{
			if(($.trim($(ed.target).val())=="")){
				$.messager.popover({msg: '您没有填写备注信息！',type:'info',timeout: 2000,showType: 'show'});
				$(ed.target).focus();
				return	
			}
			ConfirmCancelApply(index);
		}
	}
}
/// 确认是否撤销申请
function ConfirmCancelApply(index){
	$.messager.confirm('撤消框', '您确定要撤销申请吗？', function(r){
		if (r){
			var ID=RowData.ID;
			var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
			if(ed!=null){
				var RevokeCommon=$(ed.target).val();
			}else{
				var RevokeCommon="";	
			}
			var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
			$cm({
				ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
				MethodName:"InvBuyApplyRevoke",
				InputPam:InputPam,
				RevokeCommon:RevokeCommon
			},function(data){
				if(data.status>0){
					//alert("撤消申请成功！");
					$.messager.popover({msg: '撤消申请成功！',type:'success',timeout: 2000});
					//$('#InvBuyApplyView').datagrid('load');
					$('#InvBuyApplyView').datagrid('updateRow',{
						index:index,
						row:data.ApplyData
					});		
				}else{
					alert(data.info);	
				}
			});	
		}else{
			var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
			$(ed.target).val("");
			$('#InvBuyApplyView').datagrid('endEdit',index);	
		}
	});		
}

/// 功能说明：查询已申请记录的结果信息
function SearchApplyResults(ApplyRecs, i, ErrMsg){
	var nowRec=ApplyRecs[i];   //当前记录
	var AllLen=ApplyRecs.length;
	var nowRecIndex=$('#InvBuyApplyView').datagrid('getRowIndex', nowRec);
	var ID=nowRec.ID;   //当前申请记录Dr
	var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"SearchBuyApplyResult",
		InputPam:InputPam,
		Index:nowRecIndex
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.ApplyData
			});
		}else{
			ErrMsg=ErrMsg+";"+data.info;
		}
		
		var nexti=i+1;
		if(nexti<AllLen){
			SearchApplyResults(ApplyRecs, nexti, ErrMsg);   //递归调用
		}else{
			if(ErrMsg!=""){
				alert("查询申请结果失败！"+ErrMsg);
			}
		}
	});	
}
/// 功能说明：根据申请记录的Dr获取最新的记录信息
function GetApplyDataByDr(ApplyRecs, i, ErrMsg){
	
	var nowRec=ApplyRecs[i];   //当前记录
	var AllLen=ApplyRecs.length;
	var nowRecIndex=$('#InvBuyApplyView').datagrid('getRowIndex', nowRec);
	var ID=nowRec.ID;   //当前申请记录Dr
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"GetApplyDataByDr",
		ApplyDataDr:ID,
		Index:nowRecIndex
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.ApplyData
			});
		}else{
			ErrMsg=ErrMsg+";"+data.info;
		}
		
		var nexti=i+1;
		if(nexti<AllLen){
			GetApplyDataByDr(ApplyRecs, nexti, ErrMsg);   //递归调用
		}else{
			if(ErrMsg!=""){
				alert("查询申请结果失败！"+ErrMsg);
			}
		}
	});	
}
/// 功能说明：通过第三方服务查询是否存在待入库的记录
function SearchNotStockData(){
	var InputPam=""
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"SearchNotStockData",
		InputPam:InputPam
	},function(data){
		if(data.status>0){
			reloadApplyInfo();	//重新加载页面已经申请的记录
		}
	});	
}
//重新加载页面已经申请的记录
function reloadApplyInfo(){	
    var Rows=$('#InvBuyApplyView').datagrid('getRows');
    var ApplyRecs=new Array()
    for(n=0;n<Rows.length;n++){
        if(Rows[n].IBAApplyStatus=="1"){
	        ApplyRecs.push(Rows[n]);
	    }
   	}
   	if(ApplyRecs.length>0){
   		var i=0;
    	var ErrMsg="";
   		GetApplyDataByDr(ApplyRecs, i, ErrMsg); 	//根据申请记录的Dr获取最新的记录信息
   	}
}

/// 查询页面上为已申请状态的记录 是否已经申请通过 获取申请被拒绝
function GetBuyApplyResult(){
    var Rows=$('#InvBuyApplyView').datagrid('getRows');
    var ApplyRecs=new Array()
    for(n=0;n<Rows.length;n++){
        if(Rows[n].IBAApplyStatus=="1"){
	        ApplyRecs.push(Rows[n]);
	     }
    }
    if(ApplyRecs.length > 0){
    	var i=0;
    	var ErrMsg="";
    	SearchApplyResults(ApplyRecs, i, ErrMsg);    //逐个查询并更新申请状态
    }
}

/// 批量撤销申请
function batchCancelApply(){
	var AllRows=$('#InvBuyApplyView').datagrid('getChecked');
	var Rows=new Array();
	for(n=0;n<AllRows.length;n++){
		if((AllRows[n].IBAApplyStatus!="9")&&(AllRows[n].IBAStockStatus!="2")){
			Rows.push(AllRows[n])	
		} 
	}
	var i=0;
	var ErrMsg=""
	var successNum=0;
	var errorNum=0;
	DealCancelApply(Rows,i,ErrMsg,successNum,errorNum); //逐个处理撤销申请
}
//逐个处理撤销申请
function DealCancelApply(Rows,i,ErrMsg,successNum,errorNum){
	var Row=Rows[i];
	var length=Rows.length;
	var index=$('#InvBuyApplyView').datagrid('getRowIndex', Row);
	var ID=Row.ID;
	var RevokeCommon="";
	var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"InvBuyApplyRevoke",
		InputPam:InputPam,
		RevokeCommon:RevokeCommon
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:index,
				row:data.ApplyData
			});	
			successNum=successNum+1;	
		}else{
			ErrMsg=ErrMsg+";"+data.info;
			errorNum=errorNum+1;	
		}
		var nexti=i+1;
		if(nexti<length){
			DealCancelApply(Rows,nexti,ErrMsg,successNum,errorNum); //调用递归
		}else{
			if(ErrMsg!=""){
				$.messager.popover({
					msg: '撤销申请失败！'+ErrMsg,
					type:'error',
					style:{
						bottom:-document.body.scrollTop - document.documentElement.scrollTop+10, //显示到右下角
						right:10
					}
				});
			}
			$.messager.popover({msg: '批量撤消申请，成功：'+successNum+'条，失败：'+errorNum+'条！',type:'info',timeout: 3000,showType: 'show'});	
		}
	});	
}
function initSetValue(){
	//结束号码赋值
	$("#ApplyCount").keyup(function(){
		var startNo = $('#startNo').val();
		if(startNo != ""){
			var ApplyCount = $('#ApplyCount').val();
			if(ApplyCount != ""){
				$('#endNo').val((Array(startNo.length).join("0") + (parseInt(ApplyCount)+parseInt(startNo,10)-1)).slice(-startNo.length)); 
			}
		}
	});
	$("#ApplyCount").bind('input propertychange',function(){
		var ApplyCount = $('#ApplyCount').val();
		if(ApplyCount == ""){
			$('#startNo').val("");
			$('#endNo').val("");	
		}
	});
}
