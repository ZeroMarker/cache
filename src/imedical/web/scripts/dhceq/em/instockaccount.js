///add by ZY0223 原easyui界面改造成hisui界面
var AccountFlag=0;
var mestring='您确定要将所选入库单入账？';
var buttonstring='入账审核';
var SelectString='全/反选'	
var SelectFlag=0
var InStockIDs = "";
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 界面加载效果影藏 bug WY0060
});

function initDocument()
{
	initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    //initLookUp("MRObjLocDR_LocDesc^MRExObjDR_ExObj^"); //初始化放大镜
    initLookUp(); //初始化放大镜
    defindTitleStyle(); 
    //initButton(); //按钮初始化
	initEvent();
    initButtonWidth();
    //fillData(); //数据填充
    //setEnabled(); //按钮控制/
    //initApproveButtonNew(); //初始化审批按钮
	$HUI.datagrid("#DHCEQInStockAccount",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQAccountList",
	        	QueryName:"GetInStock",
				InStockNo:getElementValue("InStockNo"),
				ProviderDR:getElementValue("ProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				CurAccountFlag:AccountFlag,
				CurGroupID:curGroupID,
				BuyLocDR:getElementValue("BuyLocDR"),
				EquipName:getElementValue("EquipName")
		},
	    toolbar:[{
                iconCls: 'icon-ok', 
                text:SelectString,      
                handler: function(){
                       selectall();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-add', 
                text:buttonstring,      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
	    //modify by lmm 2020-06-02 更改列宽
		fitColumns:true,
	    columns:[[
	    	{ field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
	    	{field:'TInStockNo',title:'入库单号',width:150},   // modified by kdf 2018-02-08 需求号：548506  
	        {field:'TBuyLoc',title:'科室',width:100},        
	        {field:'TISLRowID',title:'入库明细ID',width:50,hidden:true},
	        {field:'TQuantityNum',title:'数量',align:'right'},  
			{field:'TOriginalFee',title:'单价',align:'right'},
			{field:'TotalFee',title:'总金额',width:100,align:'right'}, 
			{field:'TEquipName',title:'设备名称',width:150},    // modified by jyp 2019-03-11   modified by wy 2019-3-14设备项名称改为设备名称
			{field:'TFunds',title:'资金来源',width:150},
			{field:'TExpenditures',title:'经费来源',width:150},
			{field:'TRemark',title:'备注',width:100}, 
			{field:'TProvider',title:'供应商'}, 
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},               
	    ]],
	    onClickRow:function(rowIndex,rowData){
	   
		    if(rowData.TEnableFlag != "Y")
			{
			   if($("input[value='"+rowData.TRowID+"']").prop("checked"))
			   {
			   	 $("input[value='"+rowData.TRowID+"']").prop("checked",false);
			   	
			   }
			   else 
			   {	
				 $("input[value='"+rowData.TRowID+"']").prop("checked",true);
				 
			   }
			}
			creatToolbar();
	  	},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){creatToolbar();}
	});
};

//添加“合计”信息
function creatToolbar()
{
	var combindata=$("input[name='ckId']").map(function () { 
			if($(this).prop("checked"))  return $(this).val();         
		}).get().join(",");
	var totalISLQuantityNum=0
	var totalISLTotalFee=0
	var data=tkMakeServerCall("web.DHCEQAccountList","CalculaTotal",combindata)
	if (data!="")
	{
		var result=data.split("^"); 
		var totalISLQuantityNum=parseFloat(result[0])
		var totalISLTotalFee=parseFloat(result[1])
	}
	var lable_innerText='总数量:'+totalISLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalISLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}
function initEvent()
{
	var obj=document.getElementById("AccountFlag");
	if (obj)
	{
		jQuery("#AccountFlag").on("click", BAccountFlag_Clicked);
	}
}

/*****
*Add By QW20170602
*响应入账标志按钮，重新进行查询
*buttonstring:按钮文本
*mestring:操作提示文本
*Modify By QW20170927 需求号:456193
******/
function BAccountFlag_Clicked()
{
	SelectFlag=0
	//if(jQuery('#AccountFlag').is(':checked')==true)
	//var AccountFlag=getElementValue("AccountFlag")
	if (getElementValue("AccountFlag"))
	{
		mestring='您确定要将所选入库单取消入账？'
		buttonstring='入账取消'
		AccountFlag=1;
	}
	else 
	{ 
		AccountFlag=0;
		mestring='您确定要将所选入库单入账？';
		buttonstring='入账审核';
	}
	findGridData();
}
/*****
*Add By QW20170602
*查询方法
*modify by QW0008 修改query参数取值方方法
*modify by QW0008 增加全选/反选按钮
******/   
function findGridData(){
	$HUI.datagrid("#DHCEQInStockAccount",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQAccountList",
	        	QueryName:"GetInStock",
				InStockNo:getElementValue("InStockNo"),
				ProviderDR:getElementValue("ProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				CurAccountFlag:AccountFlag,
				CurGroupID:curGroupID,
				BuyLocDR:getElementValue("BuyLocDR"),
				EquipName:getElementValue("EquipName")
		},
		border:false,
	    striped:'true',
	    fit: true,
	    toolbar:[{
                iconCls: 'icon-ok', 
                text:SelectString,      
                handler: function(){
                       selectall();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-add', 
                text:buttonstring,      
                 handler: function(){
                     DeleteGridData();
                     }      
                 },'------------------------',{        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
	   });
}

/*****
*Add By QW20170602
*审核及取消审核
*根据选中的入库单ID进行审核及取消审核入账
*modify by QW0008 修改入库单ID获取方式
*modify by QW0008 增加user参数。
*modify by QW0008 修改返回值判断。
******/
function DeleteGridData(){
	InStockIDs=$("input[name='ckId']").map(function () { 
	if($(this).prop("checked"))  return $(this).val();         
	}).get().join(",");
	if (InStockIDs=="") return;
	messageShow("confirm","","",mestring,"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	var data=tkMakeServerCall("web.DHCEQAccountList","SaveDataByStockDR",InStockIDs,AccountFlag,curSSUserID);
	var errorcode=data.split("^"); 
	if (errorcode[0] ==0)
	{
		creatToolbar()
		$('#DHCEQInStockAccount').datagrid('reload');
		$.messager.show({title: '提示',msg: '操作成功'});
	}
	else
    {
		$.messager.popover({msg:"错误信息:"+errorcode[0],type:'error'});
		return
    }
    
}

/*****
*Add By QW0008 
*全选/反选当页所有checkbox
*modify by QW0009 增加行全选和取消
******/
function selectall()
{
	 $("input[name='ckId']").each(function(rowIndex,rowData) {
		 if(SelectFlag==1)
	     {
		    
		    $(this).prop("checked", false);  
	     } 
    	 else
    	 {
	    	$('#DHCEQInStockAccount').datagrid('selectAll');
	    	$(this).prop("checked", true); 
	    	
	 	 }   
   });  
    if(SelectFlag==0) 
    {
	    $('#DHCEQInStockAccount').datagrid('selectAll');
	    SelectFlag=1	
    }      
   else 
   {
	   $('#DHCEQInStockAccount').datagrid('unselectAll');
	   SelectFlag=0
   }
   creatToolbar();
}

function setSelectValue(elementID,rowData)
{
	//add by ZY0226 2020-04-29
	if (elementID=="Provider") {
			setElement("ProviderDR",rowData.TRowID)
		}
	else {setDefaultElementValue(elementID,rowData)}
}

