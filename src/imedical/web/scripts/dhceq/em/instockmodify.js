///add by ZY0264 20210517
var EquipInfos = "";
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	defindTitleStyle();
	initButton(); //按钮初始化
    //initButtonWidth();
	initBussType();
	setRequiredElements("BussType^BussNo");
	///modified by ZY02264 20210521
	jQuery("#BDepreCalculation").on("click", BSave_Clicked);
	jQuery("#BModify").on("click", BModify_Clicked);
}
function initBussType()
{
	$HUI.combobox('#BussType',{
		valueField:'busscode',
		textField:'text',
		panelHeight:"auto",
		data:[{
			busscode: '21',
			text: '入库'
		}]
	});
}
function BFind_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	if (bussType=="")
	{
		messageShow('alert','error','提示',"业务类型不能为空!")
		return
	}
	if (bussNo=="")
	{
		messageShow('alert','error','提示',"业务单号不能为空!")
		return
	}
	$('#BusinessContent').layout('remove','north');
	switch (bussType) {
        case "21":
        	$('#BusinessMain').hide();
        	$("#InStockInfo").show();
        	loadData(bussType,bussNo);
        	loadInStockListData(bussNo);
        	break;
        default:break;
	}
}

function loadData(bussType,bussNo)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","GetBusinessMain",bussType,bussNo)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE==-9012) {messageShow('','','',jsonData.Data,'',function(){reloadPage();});} // Modify by zx 2020-03-31BUG ZX0082
	else if(jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	var NewISInDate=getElementValue("NewISInDate")
	jQuery("#BDepreCalculation").linkbutton({text:'折旧测算'});
	if (NewISInDate!="")
	{
		$("#BModify").show();
		//jQuery("#BModify").linkbutton({text:'修改'});
	}
	else
	{
		$("#BModify").hide();
	}
}
function loadInStockListData(bussNo)
{
	$HUI.datagrid("#DHCEQBusinessList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSInStockModify",
			QueryName:"GetInStockList",
			InStockNo:bussNo
		},
		fit:true,
		fitColumns:true,
		border:false,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,50],
	    columns:[[
	    	{field:'TRowID',formatter: function(value,row,index){
				return row.TEnableFlag == "Y" ? '<input type="hidden" value="'+value+'" />'
		            :'<input type="checkbox" disabled="disabled" name="ckId" value="'+value+'" />';
				}},
			{field:'TEnableFlag',title:'TEnableFlag',width:50,hidden:true},   
	    	{field:'TEquipName',title:'设备名称',width:150,align:'center'},
	    	{field:'TModel',title:'规格型号',width:100,align:'center'},
			{field:'TQuantityNum',title:'数量',width:50,align:'center',hidden:true},
			{field:'TUnit',title:'单位',width:60,align:'center'},
			{field:'EQOriginalFee',title:'原值',tooltip:'a tooltip',width:100,align:'center'},
			{field:'TManuFactory',title:'生产厂家',width:160,align:'center'},
			//{field:'TStatCat',title:'设备类型',width:120,align:'center'},
			//{field:'TEquipCat',title:'设备分类',width:120,align:'center'},
			//{field:'TInvoiceNos',title:'发票号',width:120,align:'center'},
			//{field:'THold5',title:'经费来源',width:120,align:'center'},
			
			{field:'EQRowID',title:'资产ID',width:120,align:'center',hidden:true},
			{field:'EQNo',title:'资产编号',width:120,align:'center'},
			{field:'TStoreLoc',title:'科室',width:80,align:'center'},
			{field:'TLimitYearsNum',title:'使用年限',width:80,align:'center'},
			{field:'EQNetFee',title:'净值',width:80,align:'center'},
			{field:'EQDepreTotalFee',title:'累计折旧',width:80,align:'center'},
			{field:'TNewDepreTotalFee',title:'新累计折旧',width:80,align:'center',editor:'text'},
			
			{field:'EQTransAssetDate',title:'入账日期',width:100,align:'center'},
			{field:'TNewTransAssetDate',title:'新入账日期',width:100,align:'center'},
			{field:'EQDepreMonths',title:'折旧月数',width:80,align:'center'},
			
			{field:'EQDepreSetID',title:'折旧设置ID',width:120,align:'center',hidden:true},
			//{field:'FundsDepreInfo',title:'资金来源信息',width:120,align:'center'},
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
	  	},
	});
}

/// add by zx 2019-08-30
/// 保存按钮回调事件
function setValueByEdit(id,value)
{
	//alertShow(value)
	//setElement("id",value);
	BFind_Clicked();
}

function BSave_Clicked()
{
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	var NewISInDate=getElementValue("NewISInDate")
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","SaveBusinessMain",bussType,bussNo,NewISInDate)
	jsonData=jQuery.parseJSON(jsonData);
	if(jsonData.SQLCODE==0)
	{
		loadInStockListData(bussNo)
		///modified by ZY02264 20210521
		loadData(bussType,bussNo)
	}
	else
	{
		if (jsonData.SQLCODE==-9012) {messageShow('','','',jsonData.Data,'',function(){});} // Modify by zx 2020-03-31BUG ZX0082
	}
}
function BModify_Clicked()
{
	
	var bussType=getElementValue("BussType");
	var bussNo=getElementValue("BussNo");
	InStockListIDs=$("input[name='ckId']").map(function () { 
	if($(this).prop("checked"))  return $(this).val();         
	}).get().join(",");
	if (InStockListIDs=="") {
		alertShow("未选择数据！")
		return;
	}
	else
	{
		var rows = $('#DHCEQBusinessList').datagrid('getRows');
	    var InStockListIDs = ","+InStockListIDs+",";
	    var EquipInfos=""
	    for (var i = 0; i < rows.length; i++)
	    {
		    if (InStockListIDs.indexOf(","+rows[i].TRowID+",") != -1)
		    {
			    var oneListData=rows[i].EQRowID+getElementValue("SplitNumCode")+rows[i].TNewDepreTotalFee+getElementValue("SplitNumCode")+rows[i].EQDepreSetID+getElementValue("SplitNumCode")+rows[i].EQDepreMonths+getElementValue("SplitNumCode")+rows[i].FundsDepreInfo
			    if (EquipInfos=="") EquipInfos=oneListData
			    else EquipInfos=EquipInfos+getElementValue("SplitRowCode")+oneListData
	    	}
	    }
	}
	messageShow("confirm","","","该操作直接修改资产的入账日期和折旧数据,是否继续?","",function(){
		
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInStockModify","ModifyEquipInfoByInStockDate",bussType,bussNo,EquipInfos);
			jsonData=jQuery.parseJSON(jsonData);
			if(jsonData.SQLCODE==0)
			{
				alertShow("提示:操作成功");
			}
			else
		    {
			    alertShow("操作失败:"+jsonData.Data);
		    }
		},"")
}
/// add by zx 2019-08-30
/// 业务单据修改图标操作样式变化
$("i").hover(function(){
	$(this).css("background-color","#378ec4");
	$(this).removeClass("icon-blue-edit");
    $(this).addClass("icon-w-edit");
},function(){
    $(this).css("background-color","#fff");
    $(this).addClass("icon-blue-edit");
    $(this).removeClass("icon-w-edit");
});

/// add by zx 2019-08-30
/// 业务单据修改图标点击事件
$("i").click(function(){
	// 元素类型 数据属性 表明 字段名 
	var inputID=$(this).prev().attr("id");
	if (typeof inputID=="undefined") return;
	var oldValue=getElementValue(inputID);
	//取元素的信息
	var options=$("#"+inputID).attr("data-options");
	if ((options==undefined)&&(options=="")) return;
	//转json格式
	options='{'+options+'}';
	var options=eval('('+options+')');
	var inputType=options.itype;
	var inputProperty=options.property;
	inputType=(typeof inputType == 'undefined') ? "" : inputType;
	inputProperty=(typeof inputProperty == 'undefined') ? "" : inputProperty;
	
	if (inputType=="") return;
	var title=$("label[for='"+inputID+"']").text(); //通过文本描述生成对应弹窗标题
	inputID=inputID.split("_")[0]; //指向型id需要截取
	var bussType=getElementValue("BussType");
	var bussID=getElementValue("BussID");
	var mainFlag=getElementValue("MainFlag");
	var equipTypeDR=""
	if (inputID=="ISLStatCatDR") equipTypeDR=getElementValue("ISEquipTypeDR");
	var url="dhceq.plat.businessmodifyedit.csp?OldValue="+oldValue+"&InputID="+inputID+"&BussType="+bussType+"&BussID="+bussID+"&MainFlag="+mainFlag+"&InputType="+inputType+"&InputProperty="+inputProperty+"&ComponentName="+title+"&EquipTypeDR="+equipTypeDR;
	showWindow(url,"入库单 ‘"+title+"’ 修改","","9row","icon-w-paper","modal","","","small",setValueByEdit);    //modify by lmm 2020-06-05
});
