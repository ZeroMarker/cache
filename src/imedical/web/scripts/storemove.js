var editIndex=undefined;
var modifyBeforeRow={};
var oneFillData={};
var Columns=getCurColumnsInfo('EM.G.StoreMove.StoreMoveList','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by zx 2019-05-05 界面加载效果影藏 ZX0063
});

function initDocument()
{
	initUserInfo();
	initMessage("StoreMove"); //获取入参js业务和通用消息 czf 2021-06-17
	setElement("SMFromLocDR",curLocID);
	setElement("SMFromLocDR_CTLOCDesc",curLocName);
	//setElement("SMMoveType","0");	//modified by csj 20190125 界面每次刷新会重新设为0,导致科室lookup查询该参数不变,改为在csp中设默认值
	setElement("SMMoveType_Desc","库房分配");	//初始化默认值
	setElement("SMEquipTypeDR_ETDesc",getElementValue("SMEquipType"));
	initLocLookUp("");
	defindTitleStyle();
	initLookUp();
	initButton(); //按钮初始化
	initButtonWidth();
	initPage();//非通用按钮初始化 czf 2021-06-17
	setRequiredElements("SMMoveType_Desc^SMFromLocDR_CTLOCDesc^SMToLocDR_CTLOCDesc^SMEquipTypeDR_ETDesc"); //必填项
	fillData();
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
	setEnabled();
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action"));
	initApproveButton();
	$("#BPrintBar").linkbutton({iconCls: 'icon-w-print'});
	$("#BPrintBar").on("click", BPrintBar_Clicked);
	$("#BPrintOCR").on("click", BPrintSMOCR_Clicked);	// MZY0115	2495298		2022-03-10
	//table数据加载
	$HUI.datagrid("#DHCEQStoreMove",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSStoreMove",
			QueryName:"GetStoreMoveList",
			StoreMoveID:getElementValue("SMRowID")
		},
		border:false,
	    fit:true,
		fitColumns:true,   //add by lmm 2020-06-02
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    toolbar:[
		    {
				iconCls: 'icon-add',
	            text:'新增',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },     //modify by lmm 2020-04-03
	        {
                iconCls: 'icon-cancel',
	            text:'删除',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        },
	        //add by csj 2020-07-20 批量添加设备 需求号：1427075
	        {
	            iconCls: 'icon-batch-add',
	            text:'批量添加设备',
	            id:'batchaddequip',
	            handler: function(){
	                 batchAddEquip_Click();
	            }
	        }
        ],
	    columns:Columns,
		pagination:true,
		// MZY0147	3143288		2022-12-20
		pageSize:100,
		pageNumber:1,
		pageList:[100,200,300,400,500],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
	$("#SMMoveType_Desc").lookup({
        onSelect:function(index,rowData){
            setElement("SMMoveType",rowData.TRowID);
            initLocLookUp(rowData.TRowID);
            if(rowData.TRowID==1)
            {
	            hiddenObj("SMMoveOutReason",0); 
				hiddenObj("cSMMoveOutReason",0); 
				hiddenObj("SMMoveInReason",0); 
				hiddenObj("cSMMoveInReason",0); 
				disableElement("SMMoveInReason",true);
				setItemRequire("SMMoveOutReason",true);
            }
            else
            {
	            hiddenObj("SMMoveOutReason",1); 
				hiddenObj("cSMMoveOutReason",1); 
				hiddenObj("SMMoveInReason",1); 
				hiddenObj("cSMMoveInReason",1); 
				setItemRequire("SMMoveOutReason",false);
	        }
        },
   });
};

//add by czf 2021-06-17
//非通用按钮初始化
function initPage() 
{	
	if (jQuery("#showOpinion").length>0)
	{
		jQuery("#showOpinion").on("click", BShowOpinion_Clicked);
	}
}

//添加“合计”信息
function creatToolbar()
{
	// Mozy0217  2018-11-01		修改汇总数量及总金额
	var rows = $('#DHCEQStoreMove').datagrid('getRows');
    var totalSMLQuantityNum = 0;
    var totalSMLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
		//Mozy		2019-10-18
	    if (rows[i].SMLHold3=="")
	    {
        	var colValue=rows[i]["SMLQuantityNum"];
        	if (colValue=="") colValue=0;
        	totalSMLQuantityNum += parseFloat(colValue);
        	colValue=rows[i]["SMLTotalFee"];
        	if (colValue=="") colValue=0;
        	totalSMLTotalFee += parseFloat(colValue);
    	}
    }
	var lable_innerText='总数量:'+totalSMLQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalSMLTotalFee.toFixed(2);
	//var lable_innerText='总数量:'+totalSum("DHCEQStoreMove","SMLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQStoreMove","SMLTotalFee").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	var panel = $("#DHCEQStoreMove").datagrid("getPanel");
	var rows = $("#DHCEQStoreMove").datagrid('getRows');
//    for (var i = 0; i < rows.length; i++) {
//	    if ((rows[i].SMLEquipDR=="")&&(rows[i].SMLInStockListDR==""))
//	    {
//		    $("#TEquipList"+"z"+i).hide();
//		}
//    }
    
	var Status=getElementValue("SMStatus");
	if (Status>0)
	{
		//modify by lmm 2020-04-10 1266924
		disableElement("add",true);
		disableElement("delete",true);
		disableElement("batchaddequip",true);		//czf 2021-06-16
	}
	var  job=$('#DHCEQStoreMove').datagrid('getData').rows[0].SMJob;
	setElement("SMJob",job);
}

function fillData()
{
	//Modefied by zc0125 2022-12-5 根据设备信息赋值 begin
	var EquipDR=getElementValue("EquipDR");
	if (EquipDR!="")
	{
		    //modified by wy 2021-6-1 1959121 begin
	        jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",EquipDR)
	        jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
			setElement("SMEquipTypeDR",jsonData.Data["EQEquipTypeDR"]); //设置类组ID
			setElement("SMEquipTypeDR_ETDesc",jsonData.Data["EQEquipTypeDR_ETDesc"]);//设置类组
			setElement("SMFromLocDR",jsonData.Data["EQUseLocDR"]); //设置类组ID
			setElement("SMFromLocDR_CTLOCDesc",jsonData.Data["EQUseLocDR_CTLOCDesc"]);//设置类组
			setElement("SMMoveType_Desc","科室调配");
			var rows =$('#DHCEQStoreMove').datagrid('getRows');
			if (rows=="") return;
			rows[0].SMLEquipDR=jsonData.Data["EQRowID"];
			rows[0].SMLEquipName=jsonData.Data["EQName"];
			rows[0].SMLInStockListDR="";
			rows[0].SMLManuFactoryDR=jsonData.Data["EQManuFactoryDR"];
			rows[0].SMLManuFactoryDR_MFName=jsonData.Data["EQManuFactoryDR_MFName"];
			rows[0].SMLOriginalFee=jsonData.Data["EQOriginalFee"];
			rows[0].SMLTotalFee=jsonData.Data["EQOriginalFee"];
			rows[0].SMLModelDR=jsonData.Data["EQModelDR"];
			rows[0].SMLModelDR_MDesc=jsonData.Data["EQModelDR_MDesc"];
			rows[0].SMLUnitDR=jsonData.Data["EQUnitDR"];
			rows[0].SMLUnitDR_UOMDesc=jsonData.Data["EQUnitDR_UOMDesc"];
			rows[0].SMLLocationDR=jsonData.Data["EQLocationDR"];
			rows[0].SMLMoveNum="1";
			rows[0].SMLHold3="";
			$('#DHCEQStoreMove').datagrid('updateRow',{
				index: 0,
				row: rows[0],
			});	
	}
	//Modefied by zc0125 2022-12-5 根据设备信息赋值 end
	var SMRowID=getElementValue("SMRowID")
	if (SMRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetOneStoreMove",SMRowID,ApproveRoleDR,Action,Step)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
    if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
	//czf 2021-06-17
	var ApproveListInfo=tkMakeServerCall("web.DHCEQApproveList","GetApproveByRource","14",SMRowID)
	FillEditOpinion(ApproveListInfo,"EditOpinion")
}

//czf 2021-06-17
function FillEditOpinion(value,ename)
{
	if (!value) return
	var list=value.split("^");
	var len=list.length;
	if (len<1) return;
	var CurRole=getElementValue("CurRole");
	if (CurRole=="")
	{
		var EditOpinion=list[len-1].split(",");
		setElement("EditOpinion",EditOpinion[2]);
	}
	else
	{
		for (var i=len-1;i>=0;i--)
		{
			var EditOpinion=list[i].split(",");
			if (CurRole==EditOpinion[0])
			{
				setElement("EditOpinion",EditOpinion[2])
				i=0;
			}
			else
			{
				setElement("EditOpinion","")
			}
		}
	}
}

function setEnabled()
{
	var Status=getElementValue("SMStatus");
	var WaitAD=getElementValue("WaitAD");
	var ReadOnly=getElementValue("ReadOnly");
	hiddenObj("BClear",true); //add by wy 2020-9-24 1532207
	if ((WaitAD=="off")&&(Status!="2"))		//Add By DJ 2021-06-16 DJ0196
	{
		hiddenObj("BClear",false);
	}
	if (Status!="0")
	{
		hiddenObj("BDelete",true);
		hiddenObj("BSubmit",true);
		if (Status!="")
		{
			hiddenObj("BUpdate",true);
			hiddenObj("BSave",true);
			hiddenObj("BClear",true);
			disableElement("InStock",true)	// Mozy003009	1269728		2020-04-11
		}
		else							//czf 2021-06-17 begin
		{
			hiddenObj("showOpinion",1)
			hiddenObj("cEditOpinion",1)
			hiddenObj("EditOpinion",1)
			hiddenObj("cRejectReason",1)
			hiddenObj("RejectReason",1)
			hiddenObj("BPicture",true);
		}
	}
	else{
		hiddenObj("showOpinion",1)
		hiddenObj("cEditOpinion",1)
		hiddenObj("EditOpinion",1)
		hiddenObj("cRejectReason",1)
		hiddenObj("RejectReason",1)		//czf 2021-06-17 end
	}
	var PrintTime=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",302013)  	//设备入库单据打印时间节点','0:审核 1:提交
	if (PrintTime==0)
	{
		if ((Status!="2"))
		{
			hiddenObj("BPrint",true);
			hiddenObj("BPrintOCR",true);	// MZY0119	2022-04-07
		}
	}else
	{
		if ((Status!="2")&&(Status!="1"))
		{
			hiddenObj("BPrint",true);
			hiddenObj("BPrintOCR",true);	// MZY0119	2022-04-07
		}
	}
	if ((Status!="2"))
		{
			hiddenObj("BPrintBar",true);
		}	
	if (WaitAD!="off")
	{
		hiddenObj("BUpdate",true);
		hiddenObj("BDelete",true);
		hiddenObj("BSubmit",true);
		hiddenObj("BSave",true);
		hiddenObj("BClear",true);
		disableElement("InStock",true)	// Mozy003009	1269728		2020-04-11
	}
	///modefied by czf 2019-12-11 CZF0051
	///作废按钮
	hiddenObj("BCancel",true);
	if (Status=="2")
	{
		var CancelOper=getElementValue("CancelOper")
		if (CancelOper=="Y")
		{
			hiddenObj("BCancel",false);
		}
	}
	else
	{
		hiddenObj("BCancel",1); 
	}
	hiddenObj("SMMoveOutReason",1); 	//czf 2022-07-26 begin 2813248
	hiddenObj("cSMMoveOutReason",1); 
	hiddenObj("SMMoveInReason",1); 
	hiddenObj("cSMMoveInReason",1); 
	var SMMoveType=getElementValue("SMMoveType");
	if(SMMoveType==1)
	{
		hiddenObj("SMMoveOutReason",0); 
		hiddenObj("cSMMoveOutReason",0); 
		hiddenObj("SMMoveInReason",0); 
		hiddenObj("cSMMoveInReason",0); 
		disableElement("SMMoveInReason",true);
		setRequiredElements("SMMoveOutReason");		//czf 2022-07-26 end 2813248
	}
}

function onClickRow(index)
{
	//add by zx 2019-03-01 Bug ZX0059 非新增状态不可打开编辑行
	var Status=getElementValue("SMStatus");
	if (Status>0) return;
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQStoreMove').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQStoreMove').datagrid('getRows')[editIndex]);
			bindGridEvent();  //编辑行监听响应
		} else {
			$('#DHCEQStoreMove').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQStoreMove').datagrid('validateRow', editIndex)){
		$('#DHCEQStoreMove').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQStoreMove").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQStoreMove").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    var SMLEquipDR = (typeof rows[lastIndex].SMLEquipDR == 'undefined') ? "" : rows[lastIndex].SMLEquipDR;
    var SMLInStockListDR = (typeof rows[lastIndex].SMLInStockListDR == 'undefined') ? "" : rows[lastIndex].SMLInStockListDR;
    if ((SMLEquipDR=="")&&(SMLInStockListDR==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	}
	else
	{
		$("#DHCEQStoreMove").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#TEquipList"+"z"+newIndex).hide();
	}
}

function deleteRow()
{
	//add by zx 2019-05-31 修复多行时不可删除第一行bug ZX0067
	var graidLength=$('#DHCEQStoreMove').datagrid('getRows').length;
	if(graidLength<2)
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
		return;
	}
	if (editIndex != undefined)
	{
		jQuery("#DHCEQStoreMove").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		$('#DHCEQStoreMove').datagrid('deleteRow',editIndex);
	} 
	/*else if(editIndex=="0")
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
	}*/
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="SMFromLocDR_CTLOCDesc") {setElement("SMFromLocDR",rowData.TRowID);}
	else if(elementID=="SMReciverDR_SSUSRName") {setElement("SMReciverDR",rowData.TRowID);}
	else if(elementID=="SMToLocDR_CTLOCDesc") {setElement("SMToLocDR",rowData.TRowID);}
	else if(elementID=="SMEquipTypeDR_ETDesc") 
	{
		setElement("SMEquipTypeDR",rowData.TRowID);
		//add by zx 2019-05-31 类组改变刷新列表下拉 ZX0067
		if(editIndex != undefined)
		{
			var sourceIDEdt = $("#DHCEQStoreMove").datagrid('getEditor', {index:editIndex,field:'SMLEquipName'});
   			$(sourceIDEdt.target).combogrid('grid').datagrid('load');
		}
	}
	else if(elementID=="InStock"){saveDataFromInStock(rowData);}
	//modified by ZY20221201 bug：转移类型调整不影响科室
	else if(elementID=="SMMoveType_Desc"){
            setElement("SMMoveType",rowData.TRowID);
            initLocLookUp(rowData.TRowID);
            if(rowData.TRowID==1)
            {
		    	hiddenObj("SMMoveOutReason",0); 
				hiddenObj("cSMMoveOutReason",0); 
				hiddenObj("SMMoveInReason",0); 
				hiddenObj("cSMMoveInReason",0); 
				disableElement("SMMoveInReason",true);
				setItemRequire("SMMoveOutReason",true);
            }
            else
            {
		    	hiddenObj("SMMoveOutReason",1); 
				hiddenObj("cSMMoveOutReason",1); 
				hiddenObj("SMMoveInReason",1); 
				hiddenObj("cSMMoveInReason",1); 
				setItemRequire("SMMoveOutReason",false);
	    }
	}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	if (elementID!="InStock")
	{
		setElement(elementName,"");
	}
	return;
}
function getInStockList(index,data)
{
	var rows = $('#DHCEQStoreMove').datagrid('getRows'); 
	if(data.TEquipID!="")
	{
		for(var i=0;i<rows.length;i++){
			if(rows[i].SMLEquipDR==data.TEquipID)
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
				return;
			}
		}
	}
	else
	{
		for(var i=0;i<rows.length;i++){
			if(rows[i].SMLInStockListDR==data.TInStockListID)
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
				return;
			}
		}
	}
	
	var rowData = $('#DHCEQStoreMove').datagrid('getSelected');
	rowData.SMLEquipDR=data.TEquipID;
	rowData.SMLInStockListDR=data.TInStockListID;
	if (data.TEquipID=="") 
	{
		rowData.SMLBatchFlag="Y";
	}
	else
	{
		rowData.SMLInStockListDR="";
	}
	///modified by ZY 2844708 20220810
	//增加出库数量控制,根据验收是否有使用科室来判断数量是否默认为1
	var inStockList=rowData.SMLInStockListDR
	var Quantity=data.TQuantity
	if ((inStockList>0)&&(Quantity>1))
	{
		var OpenCheckUseLocDR=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetOpenCheckUseLoc",inStockList)
		if (OpenCheckUseLocDR=="") Quantity=1
	}
	
	rowData.SMLManuFactoryDR=data.TManuFactoryDR;
	rowData.SMLManuFactoryDR_MFName=data.TManuFactory;
	rowData.SMLOriginalFee=data.TOriginalFee;
	rowData.SMLTotalFee=Quantity*data.TOriginalFee;	///modified by ZY 2844708 20220810
	rowData.SMLModelDR=data.TModelDR;
	rowData.SMLModelDR_MDesc=data.TModel;
	rowData.SMLUnitDR=data.TUnitDR;
	rowData.SMLUnitDR_UOMDesc=data.TUnit;
	rowData.SMLLocationDR=data.TLocationDR;
	rowData.SMLMoveNum=data.TQuantity;
	rowData.SMLHold3=data.TConfigDR;			// Mozy	20190219
	var objGrid = $("#DHCEQStoreMove");        // 表格对象
	// add by zx 2019-03-14 ZX0061
	//var equipDREQNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLEquipDR_EQName'}); // 设备名称
	//$(equipDREQNameEdt.target).combogrid("setValue",data.TName);
    var quantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLQuantityNum'}); // 数量
	$(quantityEdt.target).val(Quantity);	/////modified by ZY 2844708 20220810
	var locationDRLDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLLocationDR_LDesc'}); // 存放地点
	$(locationDRLDescEdt.target).combogrid("setValue",data.TLocation);
	var equipNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLEquipName'}); // 通用名
	$(equipNameEdt.target).combogrid("setValue",data.TCommonName); // add by zx 2019-03-14 ZX0061
	$('#DHCEQStoreMove').datagrid('endEdit',editIndex);
	$('#DHCEQStoreMove').datagrid('beginEdit',editIndex);
	var quantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLQuantityNum'}); // 数量
	$(quantityEdt.target).focus();
	// 配置设备	 Mozy0217  2018-11-01
	if (data.THasConfig=="Y")
	{
		var RetSMLStr="";
		if (data.TInStockListID==0)  //单台设备
		{
			RetSMLStr=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMLForConfig",1,data.TEquipID,getElementValue("SMFromLocDR"),editIndex);	// Mozy  765433	2018-12-12
		}
		else
		{
			RetSMLStr=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMLForConfig",0,data.TInStockListID,getElementValue("SMFromLocDR"),editIndex);	// Mozy  765433	2018-12-12
		}
		if (RetSMLStr!="")
		{
			///valList=&index+"^^"+EquipDR+"^"+InStockListDR+"^"+TName+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TQuantity+"^"+TModelDR+"^"+TUnitDR+"^^"+TLocationDR+"^^^Hold3^^^"+TCommonName
			//alertShow(RetSMLStr)
			var SMLlist=RetSMLStr.split("&");
			for (var i=0;i<SMLlist.length;i++)
			{
				var SMLInfo=SMLlist[i].split("^");
				/// 检测重复
				if (SMLInfo[3]=="")  //单台设备
				{
					var getRows = $("#DHCEQStoreMove").datagrid("getSelections");
					for(var j=0;j<getRows.length;j++)
					{
						//alertShow(getRows[j].SMLBatchFlag);
						if ((getRows[j].SMLBatchFlag!="Y")&&(getRows[j].SMLEquipDR==SMLInfo[2])&&(editIndex!=j))
						{
							messageShow('alert','error','提示',"当前选择行的配置设备与明细中第"+(editIndex)+"行重复,请先删除已存在的配置设备明细后重新选择主设备!")
							return;
						}
					}
					insertRow()
				}
				else //入库明细
				{
					var getRows = $("#DHCEQStoreMove").datagrid("getSelections");
					for(var j=0;j<getRows.length;j++)
					{
						if ((getRows[j].SMLBatchFlag=="Y")&&(getRows[j].SMLInStockListID==SMLInfo[3])&&(editIndex!=j))
						{
							messageShow('alert','error','提示',"当前选择行的配置设备与明细中第"+(editIndex)+"行重复,请先删除已存在的配置设备明细后重新选择主设备!")
							return;
						}
					}
					insertRow()
				}
				var rows = $("#DHCEQStoreMove").datagrid('getRows');//获得所有行
			    var newIndex=rows.length-1;
				//alertShow(rows.length)
            	var rowDataNew = rows[newIndex];
            	rowDataNew.SMLEquipDR=SMLInfo[2];
				rowDataNew.SMLInStockListDR=SMLInfo[3];
				if (SMLInfo[2]=="") 
				{
					rowDataNew.SMLBatchFlag="Y";
				}
				else
				{
					rowDataNew.SMLInStockListDR="";
				}
				// add by zx 2019-03-14 ZX0061
				//rowDataNew.SMLEquipDR_EQName=SMLInfo[4];
				rowDataNew.SMLManuFactoryDR=SMLInfo[5];
				rowDataNew.SMLManuFactoryDR_MFName=SMLInfo[19];
				rowDataNew.SMLOriginalFee=SMLInfo[6];
				rowDataNew.SMLQuantityNum=SMLInfo[7];
				rowDataNew.SMLTotalFee=(SMLInfo[6]*SMLInfo[7]).toFixed(2);
				rowDataNew.SMLModelDR=SMLInfo[8];
				rowDataNew.SMLModelDR_MDesc=SMLInfo[18];
				rowDataNew.SMLUnitDR=SMLInfo[9];
				rowDataNew.SMLUnitDR_UOMDesc=SMLInfo[20];
				rowDataNew.SMLLocationDR=SMLInfo[11];
				rowDataNew.SMLHold3=SMLInfo[14];
				rowDataNew.SMLEquipName=SMLInfo[17];
				rowDataNew.SMLLocationDR_LDesc=SMLInfo[21];
				//alertShow(rowDataNew.SMLEquipName)
				
				$('#DHCEQStoreMove').datagrid('refreshRow', newIndex);
			}
		}
	}
}

function saveDataFromInStock(rowData)
{
	var SMRowID=getElementValue("RowID");
	if (SMRowID!="")
	{
		
	}
	var fromLocDR=getElementValue("SMFromLocDR");  
	var moveType=getElementValue("SMMoveType");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMInfoByISL",rowData.TEquipID,rowData.TInStockListID,moveType,fromLocDR,curUserID);   //modify by lmm 2019-02-02 821382
	
	jsonData=jQuery.parseJSON(jsonData);
	jsonData.Data["SMJob"]=getElementValue("SMJob");
	jsonData.Data["SMStoreMoveNo"]="";
	jsonData.Data["SMRowID"]="";
	var data = jsonData.Data;
	data = JSON.stringify(data);
	if (rowData.TInStockListID==0)
	{
		var EquipDR=rowData.TEquipID;
		var InStockListDR="";
		var BatchFlag="";
	}
	else
	{
		var EquipDR="";
		var InStockListDR=rowData.TInStockListID;
		var BatchFlag="Y"
	}
	
	var dataList={"SMLRowID":""};
	dataList["SMLEquipDR"]=EquipDR;
	dataList["SMLInStockListDR"]=InStockListDR;
	dataList["SMLBatchFlag"]=BatchFlag;
	dataList["SMLEquipName"]=rowData.TCommonName;		//Mozy	765422	2018-12-12   modify by jyp 2019-03-07
	dataList["SMLManuFactoryDR"]=rowData.TManuFactoryDR;
	dataList["SMLOriginalFee"]=rowData.TOriginalFee;
	dataList["SMLQuantityNum"]=rowData.TQuantity;
	dataList["SMLModelDR"]=rowData.TModelDR;
	dataList["SMLUnitDR"]=rowData.TUnitDR;
	dataList["SMLLocationDR"]=rowData.TLocationDR;
	// Mozy	20190219
	dataList["SMLHold3"]=rowData.TConfigDR;
	//if (rowData.TConfigDR!="") dataList["SMLEquipName"]="(附)"+dataList["SMLEquipName"]	// Mozy	930989	20190617	注释
	dataList["SMLIndex"]=1;
	dataList = JSON.stringify(dataList);
	var SplitRowCode=getElementValue("SplitRowCode");
	// Mozy0217  2018-11-01		插入配置设备
	if (rowData.THasConfig=="Y")
	{
		var RetSMLStr="";
		if (rowData.TInStockListID==0)
		{
			RetSMLStr=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMLForConfig",1,EquipDR,getElementValue("SMFromLocDR"),1);	// Mozy  765433	2018-12-12
		}
		else
		{
			RetSMLStr=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetSMLForConfig",0,InStockListDR,getElementValue("SMFromLocDR"),1);	// Mozy  765433	2018-12-12
		}
		if (RetSMLStr!="")
		{
			//alertShow(RetSMLStr)
			var SMLlist=RetSMLStr.split(SplitRowCode);		//czf 2022-05-27
			for (var i=0;i<SMLlist.length;i++)
			{
				var SMLlistInfo=SMLlist[i].split("^");
				var ConfigData={"SMLRowID":""};
				ConfigData["SMLEquipDR"]=SMLlistInfo[2];
				ConfigData["SMLInStockListDR"]=SMLlistInfo[3];
				ConfigData["SMLBatchFlag"]="";
				if (SMLlistInfo[3]!=0) ConfigData["SMLBatchFlag"]="Y";
				ConfigData["SMLEquipName"]=SMLlistInfo[17];	// Mozy  765433	2018-12-12
				ConfigData["SMLManuFactoryDR"]=SMLlistInfo[5];
				ConfigData["SMLOriginalFee"]=SMLlistInfo[6];
				ConfigData["SMLQuantityNum"]=SMLlistInfo[7];
				ConfigData["SMLModelDR"]=SMLlistInfo[8];
				ConfigData["SMLUnitDR"]=SMLlistInfo[9];
				ConfigData["SMLLocationDR"]=SMLlistInfo[11];
				ConfigData["SMLIndex"]=i+2;		//Mozy	765422	2018-12-12
				ConfigData["SMLHold3"]=SMLlistInfo[14];
				ConfigData = JSON.stringify(ConfigData);
				if (dataList=="")
				{
					dataList=ConfigData;
				}
				else
				{
					dataList=dataList+getElementValue("SplitRowCode")+ConfigData;  //add by zx 2019-07-22
				}
			}
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var moveType = getElementValue("SMMoveType");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag+"&SMMoveType="+moveType;
		url="dhceq.em.storemove.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;

	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

function BSave_Clicked()
{
	if (editIndex != undefined){ $('#DHCEQStoreMove').datagrid('endEdit', editIndex);}
	if (getElementValue("SMMoveType")=="")
	{
		messageShow('alert','error','提示',"转移类型不能为空!")
		return
	}
	if (getElementValue("SMFromLocDR")=="")
	{
		messageShow('alert','error','提示',"供给部门不能为空!")
		return
	}
	if (getElementValue("SMToLocDR")=="")
	{
		messageShow('alert','error','提示',"接收部门不能为空!") // modified by sjh SJH0041 2020-12-01
		return
	}
	if (getElementValue("SMEquipTypeDR")=="")
	{
		messageShow('alert','error','提示',"管理类组不能为空!")
		return
	}
	if ((getElementValue("SMMoveType")==1)&&(getElementValue("SMMoveOutReason")==""))
	{
		messageShow('alert','error','提示',"转出原因不能为空!")
		return
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList="";
	var rows = $('#DHCEQStoreMove').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		// add by zx 2019-05-23 测试需求 905545
		if ((oneRow.SMLEquipName=="")||(oneRow.SMLEquipName==undefined))
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行数据不正确!");
			return "-1";
		}
		
		//add by lmm 2019-08-30 begin 994942
		var EquipTypeFlag=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","CheckStoreMoveEquipType",getElementValue("SMEquipTypeDR"),oneRow.SMLEquipDR,oneRow.SMLInStockListDR);
		if (EquipTypeFlag=="-1")
		{
			messageShow('alert','error','提示',"第"+(i+1)+"行数据与主单类组不一致!");
			return "-1";
		}
		//add by lmm 2019-08-30 end 994942
		//add by zx 2019-06-20 存放地点自动生成基础数据处理 BUG ZX0068
		var LocationDR=getLocationRowID(getElementValue("LocationOperMethod"),oneRow.SMLLocationDR_LDesc);
		oneRow["SMLLocationDR"]=LocationDR;
		oneRow["SMLIndex"]=i; //index值处理
		var RowData=JSON.stringify(oneRow);
		if (dataList=="")
		{
			dataList=RowData;
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;  //add by zx 2019-07-22
		}
		
	}
	if (dataList=="")
	{
		messageShow('alert','error','提示',"转移明细不能为空!");
		return;
	}
	disableElement("BSave",true)	//add by csj 2020-03-10 表单校验后禁用
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","SaveData",data,dataList,"0",getElementValue("InventoryListDR"),getElementValue("InventoryExceptionDR"));//Modefied by zc0125 2022-12-12 添加盘点明细与盘盈id入参
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
		url="dhceq.em.storemove.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;

	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 保存失败后启用
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}

function BDelete_Clicked()
{
	var SMRowID=getElementValue("SMRowID")
	if (SMRowID=="")
	{
		messageShow('alert','error','提示',"没有出库单删除!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","SaveData",SMRowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
		url="dhceq.em.storemove.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}
///modified by ZY0298 20220310  增加会计周期的判断提醒
function BSubmit_Clicked()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","IsCurPeriod");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
		messageShow("confirm","info","提示","当前操作会内容会统计入会计周期:"+RtnObj.Data+"中<br>请确定是否要继续执行操作?","",BSubmit,function(){return},"确定","取消");
    }
    else
    {
	    BSubmit()
	}
}
function BSubmit()
{
	var SMRowID=getElementValue("SMRowID")
	var rtn=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","CheckStoreMoveLoc",SMRowID)
	if (rtn!="")
	{
		messageShow('alert','error','提示',rtn);
		return
	}
	if (SMRowID=="")
	{
		messageShow('alert','error','提示',"没有出库单信息!");
		return;
	}
	//add by wy 2021-3-23判断类组与库房是否相符 0相符 1不符
	var StoreLocDR=""
	if (getElementValue("SMMoveType")==0)
	{
		var StoreLocDR=getElementValue("SMFromLocDR")
	}
	else if (getElementValue("SMMoveType")==3)
	{
		var StoreLocDR=getElementValue("SMToLocDR")
	}	
	var Info=tkMakeServerCall("web.DHCEQ.Plat.CTStoreEquipType","CheckEquipTypeByStoreLocDR",StoreLocDR,getElementValue("SMEquipTypeDR"))  	
	if (Info=="1")
	{
		messageShow("alert","error","错误提示","管理类组与设备库房不相符!")
		return
	}
	///Modefied by zc0110 2021-12-15 判断业务是否存在必须上传的内容 begin
	var PicMustRtn=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","CheckMustUpLoad",'22',SMRowID,'0')
	var PicMustInfo=PicMustRtn.split("^");
	var PicFlag=PicMustInfo[0]
	var PicTyp=PicMustInfo[2]
	if (PicFlag=="1")
	{
		alertShow("有必须上传的"+PicTyp+"图片没有上传!") 
		return ;
	}
	///Modefied by zc0110 2021-12-15 判断业务是否存在必须上传的内容  end
	var data=getValueList();
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","SubmitData",data);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		//Mozy	2020-1-19
		var CheckData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeStoreMove",jsonData.Data,0);
		CheckData=JSON.parse(CheckData);
		if (CheckData.SQLCODE==0)
		{
			takeAllOff();
		}
		else
		{
			messageShow("confirm","","","转移单中["+CheckData.Data+"]是否进行下架操作?","",takeAllOff,takePartOff);
		}
	}
	else
    {
		messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (getElementValue("RejectReason")=="")	//czf 2021-06-17
	{
		setFocus("RejectReason");
		messageShow('alert','error','提示',t[-9234])	//"拒绝原因不能为空!"
		return
	}
	var SMRowID=getElementValue("SMRowID");
	if (SMRowID=="")
	{
		messageShow('alert','error','提示',"没有出库单取消!");
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var val="&RowID="+RtnObj.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
		url="dhceq.em.storemove.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
///modified by ZY0298 20220310  增加会计周期的判断提醒
function BApprove_Clicked()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","IsCurPeriod");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
		messageShow("confirm","info","提示","当前操作会内容会统计入会计周期:"+RtnObj.Data+"中<br>请确定是否要继续执行操作?","",BApprove,function(){return},"确定","取消");
    }
    else
    {
	    BApprove()
	}
}
function BApprove()
{
	if (getElementValue("EditOpinion")=="")		//czf 2021-06-17
	{
		setFocus("EditOpinion");
		messageShow('alert','error','提示',t[-9233])	//审批意见不能为空!
		return
	}
	var combindata=getValueList();
	var curRole=getElementValue("CurRole");
  	if (curRole=="") return;
	var roleStep=getElementValue("RoleStep");
  	if (roleStep=="") return;
	var objtbl=getParentTable("SMInStockNo")
	var editFieldsInfo=approveEditFieldsInfo(objtbl);
	if (editFieldsInfo=="-1") return;
	
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","AuditData",combindata,curRole,roleStep,editFieldsInfo);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data);
	    return;
    }
    else
    {
	    //Mozy	2020-1-19
		var CheckData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeStoreMove",jsonData.Data,0);
		CheckData=JSON.parse(CheckData);
		if (CheckData.SQLCODE==0)
		{
			takeAllOff();
		}
		else
		{
			messageShow("confirm","","","转移单中["+CheckData.Data+"]是否进行下架操作?","",takeAllOff,takePartOff);
		}
    }
}
/// modified by kdf 2018-01-11
/// 增加系统参数PrintFlag，控制转移单润乾打印
function BPrint_Clicked()
{	
	var SMRowID=getElementValue("SMRowID");
	if (SMRowID=="") return;
	var PrintFlag=getElementValue("PrintFlag");
	
	//Excel打印方式
	if(PrintFlag==0)  
	{
		printStoreMove(SMRowID);
	}
	
	//润乾打印方式
	if(PrintFlag==1)
	{
		var moveType=oneFillData["SMMoveType"];
		if(moveType=="0")
		{var EQTitle="设备出库单";}
		else if(moveType=="3")
		{var EQTitle="设备退库单"}
		else{var EQTitle="设备转移单"}
		//Add By QW20210913 BUG:QW0147 标题增加补打标记	begin
		var PrintNumFlag=getElementValue("PrintNumFlag");
		if(PrintNumFlag==1)  
		{
			var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","22",SMRowID)
			if(num>0) EQTitle=EQTitle+"(补打)";
		}
		
		///modified by ZY0286 20211210
		//var FromLoc=GetShortName(oneFillData["SMFromLocDR_CTLOCDesc"],"-"); //供给部门
		//var ToLoc=GetShortName(oneFillData["SMToLocDR_CTLOCDesc"],"-"); //接收部门
		//var AckDate=ChangeDateFormat(oneFillData["SMMakeDate"]); //日期
		//var StoreMoveNo=oneFillData["SMStoreMoveNo"];  //单号
		//var AckUser=oneFillData["SMMakerDR_SSUSRName"];  //制单人 modified by ZY0282 20211112
		var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   增加润乾预览标志
		var fileName=""	;
        if(PreviewRptFlag==0)
        {
	        //fileName="{DHCEQStoreMoveSPrint.raq(RowID="+SMRowID+";EQTitle="+EQTitle+";FromLoc="+FromLoc+";ToLoc="+ToLoc+";AckDate="+AckDate+";StoreMoveNo="+StoreMoveNo+";AckUser="+AckUser+")}";
	        fileName="{DHCEQStoreMoveSPrint.raq(RowID="+SMRowID+";EQTitle="+EQTitle+";HOSPDESC="+curSSHospitalName+")}";
	        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        {
	        //fileName="DHCEQStoreMoveSPrint.raq&RowID="+SMRowID+"&EQTitle="+EQTitle+"&FromLoc="+FromLoc +"&ToLoc="+ToLoc+"&AckDate="+AckDate+"&StoreMoveNo="+StoreMoveNo+"&AckUser="+AckUser ;
			fileName="DHCEQStoreMoveSPrint.raq&RowID="+SMRowID+"&EQTitle="+EQTitle+"&HOSPDESC="+curSSHospitalName ; //Modified By QW20191022 BUG:QW0032 修改润乾打印id未定义
			DHCCPM_RQPrint(fileName); 
        }												//add by wl 2019-11-11 WL0010 end			

	}	
	var StoreMovePrintOperateInfo="^22^"+SMRowID+"^^转移打印操作^0"
	var PrintFlag=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",StoreMovePrintOperateInfo)
	//Modified By QW20210913 BUG:QW0147 修改打印次数  end
}

function printStoreMove(SMRowID)
{
    //Add By QW20210913 BUG:QW0147 标题增加补打标记	begin
	var PrintNumFlag=getElementValue("PrintNumFlag");
	var num=0;
	if(PrintNumFlag==1)  
	{
		num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","22",SMRowID)
		
	}
	//Add By QW20210913 BUG:QW0147 标题增加补打标记	end
	var moveType=oneFillData["SMMoveType"];
	var gbldata=tkMakeServerCall("web.DHCEQStoreMoveSP","GetList",SMRowID);
	var list=gbldata.split(getElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	
	var PageRows=6;//每页固定行数
	var Pages=parseInt(rows / PageRows); //总页数-1  
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	
    var xlApp,xlsheet,xlBook;
    var Template;
    if (moveType=="0")
    {	Template=TemplatePath+"DHCEQStoreMoveSP.xls";}
    else
    {	Template=TemplatePath+"DHCEQStoreMoveSP1.xls";}

    xlApp = new ActiveXObject("Excel.Application");
    for (var i=0;i<=Pages;i++)
    {
	    xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.PageSetup.TopMargin=0;
    	var sort=27;
    	//Add By QW20210913 BUG:QW0147 标题增加补打标记	begin
		if(PrintNumFlag==1)  
		{
			if(num>0) 
			{
				if (moveType=="3")
		    	{
			    	xlsheet.cells(1,2)="[Hospital]设备退库单(补打)"
		    	}else if (moveType=="0"){
			    	xlsheet.cells(1,2)="[Hospital]设备出库单(补打)"
			    }else{
				    xlsheet.cells(1,2)="[Hospital]设备转移单(补打)"
				}
			}
		}else{
			if (moveType=="3")
	    	{
		    	xlsheet.cells(1,2)="[Hospital]设备退库单"
	    	}
		}
		//Add By QW20210913 BUG:QW0147 标题增加补打标记	end
    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
    	xlsheet.cells(2,2)="供给部门:"+GetShortName(oneFillData["SMFromLocDR_CTLOCDesc"],"-");//供给部门
    	xlsheet.cells(3,2)="接收部门:"+GetShortName(oneFillData["SMToLocDR_CTLOCDesc"],"-");//接收部门
    	xlsheet.cells(2,7)="出库日期:"+ChangeDateFormat(oneFillData["SMMakeDate"]);  //时间	
    	xlsheet.cells(3,7)="转移单号:"+oneFillData["SMStoreMoveNo"];  //凭单号 
    	
    	var OnePageRow=PageRows;
   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
   		
		for (var Row=1;Row<=OnePageRow;Row++)
		{
			//messageShow("","","",Listall);
			var Lists=Listall.split(getElementValue("SplitRowCode"));
			var Listl=Lists[i*PageRows+Row];
			var List=Listl.split("^");
			var cellRow=Row+4;
			if (List[0]=='合计')
			{					
				Row=6;
				cellRow=Row+4;
				xlsheet.cells(cellRow,2)=List[0];//设备名称
				xlsheet.cells(cellRow,5)=List[4];//数量
				xlsheet.cells(cellRow,7)=List[7];//总价

			}
			else
			{
				xlsheet.cells(cellRow,2)=List[0];//设备名称
				xlsheet.cells(cellRow,3)=List[2];//机型
				xlsheet.cells(cellRow,4)=List[3];//单位
				xlsheet.cells(cellRow,5)=List[4];//数量
				xlsheet.cells(cellRow,6)=List[5];//原值
				xlsheet.cells(cellRow,7)=List[7];//总价
				xlsheet.cells(cellRow,8)=List[6];//备注
			}
			
    	}
	    xlsheet.cells(12,7)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间
	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    
	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\StoreMove"+i+".xls");
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
    }
    xlApp=null;
	
}

function getValueList()
{
	var combindata="";
  	combindata=getElementValue("SMRowID");
  	combindata=combindata+"^"+getElementValue("SMFromLocDR") ;
  	combindata=combindata+"^"+getElementValue("SMToLocDR") ;
  	combindata=combindata+"^"+getElementValue("SMMoveType") ;
  	combindata=combindata+"^"+getElementValue("SMRemark") ;
	combindata=combindata+"^"+getElementValue("SMReciverDR") ;
	combindata=combindata+"^"+getElementValue("SMEquipTypeDR") ;
  	combindata=combindata+"^"+getElementValue("SMStatCatDR") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+getElementValue("CancelToFlowDR");
	combindata=combindata+"^"+getElementValue("ApproveSetDR");
	combindata=combindata+"^"+getElementValue("SMJob");
	combindata=combindata+"^"+getElementValue("EditOpinion");	//czf 2021-06-17 保存审批意见
	combindata=combindata+"^"+getElementValue("RejectReason");
	return combindata
}

function initLocLookUp(moveType)
{
	if (moveType=="") moveType=getElementValue("SMMoveType");
	if (moveType=="0")
    {
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }
    else if (moveType=="3")
    {
     	var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");   
    }
    else if(moveType=="1")
    {
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"SMToLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }
    else
    {
        var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":""},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
        var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":""},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("SMToLocDR_CTLOCDesc","PLAT.L.Loc",paramsTo,"");
    }
}

function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQStoreMove");        // 表格对象
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'SMLQuantityNum'});            // 数量
        // 数量  绑定 离开事件 
        $(invQuantityEdt.target).bind("blur",function(){
	        var rowData = $('#DHCEQStoreMove').datagrid('getSelected');
            //
            var moveNum=parseFloat(rowData.SMLMoveNum);
            var quantityNum=parseFloat($(invQuantityEdt.target).val());
			//Modefied by zc0111 2021-12-29 判断输入的数字是否为非正整数  begin
			if(!/^\d+$/.test(quantityNum))
            {
 				messageShow('alert','error','提示',"数量不是整数!");
 				$(invQuantityEdt.target).val(moveNum);
 				return ;
			}
			//Modefied by zc0111 2021-12-29 判断输入的数字是否为非正整数  end
            if (parseInt(quantityNum)>parseInt(moveNum))
            {
	            messageShow('alert','error','提示',"转移数量无效!");
	            $(invQuantityEdt.target).val(moveNum);
	            return;
	        }
            // 根据数量变更后计算 金额
            var originalFee=parseFloat(rowData.SMLOriginalFee);
			rowData.SMLTotalFee=quantityNum*originalFee;
			$('#DHCEQStoreMove').datagrid('endEdit',editIndex);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}

//元素参数重新获取值
function getParam(ID)
{
	if (ID=="FromLocDR"){return getElementValue("SMFromLocDR")}
	else if (ID=="EquipTypeDR"){return getElementValue("SMEquipTypeDR")}
	else if (ID=="StatCatDR"){return ""}	//modified by csj 20190722 界面无按类型检索 需求号：951237
	else if (ID=="ProviderDR"){return ""}
	//add by zx 2019-06-01 单台参数处理 Bug ZX0066
	else if (ID=="Flag")
	{
		if (editIndex == undefined) return "";  //add by zx 2019-07-05
		var flagEdt = $("#DHCEQStoreMove").datagrid('getEditor', {index:editIndex,field:'SMLFlag'}); 
		return flagEdt==null?'':flagEdt.target.checkbox("getValue");	//modified add by csj 20190722 flagEdt可能为null 需求号：951229
	}
}

//出厂编号点击弹窗
function BUpdateEquipsByList(editIndex)
{
	var rowData =  $("#DHCEQStoreMove").datagrid("getRows")[editIndex];
	var inStockListDR=(typeof rowData.SMLInStockListDR == 'undefined') ? "" : rowData.SMLInStockListDR;
	var equipDR=rowData.SMLEquipDR;
	if ((inStockListDR=="")&&(equipDR=="")) return;
	var quantityNum=(typeof rowData.SMLQuantityNum == 'undefined') ? "" : rowData.SMLQuantityNum;
	if (quantityNum=="") return;
	var url="dhceq.em.updateequipsbylist.csp?";
	url=url+"SourceID="+inStockListDR;
	url=url+"&QuantityNum="+quantityNum;
	url=url+"&Job="+getElementValue("SMJob");
	url=url+"&Index="+editIndex;
	var SMLRowID = (typeof rowData.SMLRowID == 'undefined') ? "" : rowData.SMLRowID;
	url=url+"&MXRowID="+SMLRowID;
	url=url+"&StoreLocDR="+getElementValue("SMFromLocDR");
	url=url+"&Status="+getElementValue("SMStatus");
	url=url+"&Type=1";
	url=url+"&EquipID="+equipDR;
	showWindow(url,"设备出厂编号列表","","","icon-w-paper","modal","","","small",listChange);   //modify by lmm 2019-02-19 增加回调
}

function BPrintBar_Clicked()
{
	storeMovePrintBar();
}

//add by zx 2018-11-22
//设备出厂编号保存后调用修改数量与金额
function listChange(index,quantity)
{
	$('#DHCEQStoreMove').datagrid('selectRow', index).datagrid('beginEdit', index);
	var rowData = $('#DHCEQStoreMove').datagrid('getSelected');
	var objGrid = $("#DHCEQStoreMove");        // 表格对象
    var quantityEdt = objGrid.datagrid('getEditor', {index:index,field:'SMLQuantityNum'}); // 数量
	$(quantityEdt.target).val(quantity);
	var originalFee=rowData.SMLOriginalFee;
	rowData.SMLTotalFee=quantity*originalFee;
	$('#DHCEQStoreMove').datagrid('endEdit',Number(index));  //add by zx 2019-01-24 结束时行号要为数字格式
}

// add by zx 2018-11-22
// 设备存放地点选择
function getLocation(index,data)
{
	var rowData = $('#DHCEQStoreMove').datagrid('getSelected');
	rowData.SMLLocationDR=data.TRowID;
	var locationDRLDescEdt = $('#DHCEQStoreMove').datagrid('getEditor', {index:editIndex,field:'SMLLocationDR_LDesc'});
	$(locationDRLDescEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQStoreMove').datagrid('endEdit',editIndex);
}

//add by zx 2019-06-20 BUG ZX0068 生成存放地点
function getLocationRowID(type,value)
{
	var result="";
	if ((value=="")||(value=="undefined")||(value==undefined)) return result;  //add by zx 2019-07-24 未定义处理
	if((type!="0")||(type!=""))
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",value);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) result = jsonData.Data;
	}
	return result;
}
//add by czf 20191211 CZF0051
//转移单据作废
function BCancel_Clicked()
{
	var SMRowID=getElementValue("SMRowID")
  	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CheckBussCancelFlag",3,SMRowID);
  	
	var result=results.split("^")
	if (result[0]!="0")
	{
		messageShow("","","",result[1])
	}
	else
	{
		//modified by CZF0105 20200409
		messageShow("confirm","info","提示","是否作废转移单?","",CancelStoreMove,function(){
			return;
		});
	}
}

//modified by CZF0104 20200409
function CancelStoreMove()
{
	var SMRowID=getElementValue("SMRowID")
	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CancelBuss",3,SMRowID);
	var result=results.split("^")
	if (result[0]!="0")
	{
		if (result[1]!="")
		{
			messageShow("","","","操作失败:"+result[1])
		}
		else
		{
			messageShow("","","","操作失败:"+result[0])
		}
	}
	else
	{
		messageShow("","","","成功作废!")
		//modify by zx 2022-04-11 bug ZX0144
		if (typeof(eval(websys_showModal("options").mth)) == "function") {
			websys_showModal("options").mth("22");
		}
		var url="dhceq.em.storemove.csp?&RowID="+SMRowID;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
    	window.setTimeout(function(){window.location.href=url},50); 
	}
}

// Mozy		2020-1-19
//设置全部下架
function takeAllOff()
{
	var ChangeData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeStoreMove",getElementValue("SMRowID"),2);
	ChangeData=JSON.parse(ChangeData);
	if (ChangeData.SQLCODE!=0) messageShow('alert','error','提示',"错误信息:转移单中相关设备自动下架失败,请核对后手动下架处理!!",'',reloadStoreMove);
	else reloadStoreMove();
}
//设置部分下架
function takePartOff()
{
	var ChangeData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","ChangeStoreMove",getElementValue("SMRowID"),1);
	ChangeData=JSON.parse(ChangeData);
	if (ChangeData.SQLCODE!=0) messageShow('alert','error','提示',"错误信息:转移单中相关设备自动下架失败,请核对后手动下架处理!!",'',reloadStoreMove);
	else reloadStoreMove();
}
//重新加载转移单
function reloadStoreMove()
{
    ///modified by ZY 2022118 防止业务建单菜单点开报错
    if (websys_showModal("options"))
    {
        if (websys_showModal("options").mth)
        {
            websys_showModal("options").mth("22");
        }
        else
        {
            url="dhceq.em.storemove.csp?&RowID="+getElementValue("SMRowID")+"&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&flag="+getElementValue("flag");
            if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
            window.location.href=url              
        }
    }
    else
    {
        url="dhceq.em.storemove.csp?&RowID="+getElementValue("SMRowID")+"&WaitAD="+getElementValue("WaitAD")+"&QXType="+getElementValue("QXType")+"&flag="+getElementValue("flag");
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
        window.location.href=url  
    }
    
}

///add by lmm 2020-04-02 LMM0069
///增加勾选框显示列
function checkboxSMLFlagChange(SMLFlag,rowIndex)
{
	var row = jQuery('#DHCEQStoreMove').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (SMLFlag==key)
			{
				if (((val=="N")||val=="")) row.SMLFlag="Y"
				else row.SMLFlag="N"
			}
		})
	}
}
///add by csj 2020-07-20 需求号：1427075
///批量添加设备
function batchAddEquip_Click()
{
	//add by csj 2020-08-19 需求号：1464629
	if(getElementValue("SMFromLocDR")==""){
		alertShow("供给部门不能为空!")
		return
	}
	if(getElementValue("SMEquipTypeDR")==""){
		alertShow("管理类组不能为空!")
		return
	}
	var str=""
	str=str+"&FromLocDR="+getElementValue("SMFromLocDR")
	str=str+"&EquipTypeDR="+getElementValue("SMEquipTypeDR")
	str=str+"&title="+"转移批量添加设备"     //Modefied  by zc 20211115  zc0107 title改成取值
	var url="dhceq.em.batchaddequip.csp?StoreMoveID="+getElementValue("SMRowID")+str;
	showWindow(url,"转移批量添加设备","","","icon-w-paper","modal","","","middle",insertEquipRow); 	
}

///add by csj 2020-07-20 需求号：1427075
///批量添加设备回调
///copyrows:列表数据数组
function insertEquipRow(copyrows)
{
	var ComponentID="DHCEQStoreMove"
	len=copyrows.length
	if($("#DHCEQStoreMove").datagrid("getRows")[0].SMLEquipName==""){
		$('#DHCEQStoreMove').datagrid('deleteRow',0)
	}
	for(i=0;i<len;i++)
	{
			var morows = $("#"+ComponentID).datagrid("getRows");
			var index=morows.length;
    		var vallist=""
			if(copyrows[i].TEquipID!="")
			{
				for(var j=0;j<morows.length;j++){
					if(morows[j].SMLEquipDR==copyrows[i].TEquipID)
					{
						return;
					}
				}
			}
			else
			{
				for(var j=0;j<morows.length;j++){
					if(morows[j].SMLInStockListDR==copyrows[i].TInStockListID)
					{
						return;
					}
				}
			}
			$("#"+ComponentID).datagrid('appendRow',{ 
				SMLFlag: copyrows[i].TEquipID==""?"":"Y",
             	SMLEquipDR :copyrows[i].TEquipID,
             	SMLEquipName:copyrows[i].TCommonName,
             	SMLBatchFlag : copyrows[i].TEquipID==""?"Y":"",
             	SMLInStockListDR : copyrows[i].TEquipID==""?copyrows[i].TInStockListID:"",
             	SMLManuFactoryDR : copyrows[i].TManuFactoryDR,
             	SMLManuFactoryDR_MFName : copyrows[i].TManuFactory,
             	SMLOriginalFee : copyrows[i].TOriginalFee,
             	SMLQuantityNum : copyrows[i].TQuantity,
             	SMLTotalFee: copyrows[i].TQuantity*copyrows[i].TOriginalFee,
             	SMLModelDR : copyrows[i].TModelDR,
             	SMLModelDR_MDesc: copyrows[i].TModel,
             	SMLUnitDR:copyrows[i].TUnitDR,
				SMLUnitDR_UOMDesc:copyrows[i].TUnit,
				SMLRemark:"",
				SMLMoveNum:copyrows[i].TQuantity,
				SMLLocationDR_LDesc:copyrows[i].TLocation,
				SMLLocationDR:copyrows[i].TLocationDR,
				SMLHold1:"",
				SMLHold2:"",
				SMLHold3:copyrows[i].TConfigDR,
				SMLHold4:"",
				SMLHold5:"",
		     })  		
				
	}
}
//add by wy 2020-9-24 1532207增加业务清屏功能
function BClear_Clicked()
{
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var flag=getElementValue("flag");
		var val="&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
		url="dhceq.em.storemove.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
}
//add by czf 2020-11-05 1559991 
//非DR元素增加回调函数处理
function GetSMHold2(item)
{
	setElement("SMHold2",item.TRowID);
}
//Add By QW20210422 bug:QW0100 图片上传按钮
function BPicture_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly")
	var Status=getElementValue("SMStatus");
	if (Status>0) Status=0;
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=22&CurrentSourceID='+getElementValue("SMRowID")+'&Status='+Status+'&ReadOnly=';
	showWindow(str,"图片信息","","","icon-w-paper","modal","","","large");
}

//add by czf 2021-06-17
//审批进度显示
function BShowOpinion_Clicked()
{
	url="dhceq.plat.approvelist.csp?&BussType=22&BussID="+getElementValue("SMRowID");
	showWindow(url,"转移审批进度","","","icon-w-paper","modal","","","middle");
}
// MZY0115	2495298		2022-03-10	吉林国文医院资产转固交接验收单
function BPrintSMOCR_Clicked()
{
	var RowID=getElementValue("SMRowID");
	if (RowID=="") return;
	var ReturnList=tkMakeServerCall("web.DHCEQStoreMoveNew","GetOneStoreMove",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	//alert(ReturnList)
	var gbldata=tkMakeServerCall("web.DHCEQStoreMoveSP","GetList",RowID);
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	//alert(gbldata)
	var Listall=list[0];
	var rows=list[1];
	var sort=27;
	
	var c2=String.fromCharCode(2);
	var curSSHospitalName=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990003");
	var CurDate=GetCurrentDate();	// tkMakeServerCall("web.DHCEQCommon","GetCurTime");
	for (var Row=1;Row<rows;Row++)
	{
		var Lists=Listall.split(GetElementValue("SplitRowCode"));
		var Listl=Lists[Row];
		var List=Listl.split("^");
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQSMOCR");
		var LODOP = getLodop();
		
	    var inpara="EQTitle"+c2+curSSHospitalName+"资产转固交接验收单";
	    inpara+="^SMStoreMoveNo"+c2+lista[0];  			//转移单号
	    inpara+="^OCRNo"+c2+List[15];
	    inpara+="^EQName"+c2+List[0];					//设备名称
		inpara+="^EQNo"+c2+List[12];
	    inpara+="^EQModel"+c2+List[2];					//机型
	    inpara+="^BuyType"+c2+List[18];
	    inpara+="^QuantityNum"+c2+List[4]+List[3];		//数量
		inpara+="^TotalFee"+c2+parseFloat(List[7]).toFixed(2);	//总价
		inpara+="^Vendor"+c2+List[11];
		inpara+="^Location"+c2+List[14];
		inpara+="^OpenCheckDate"+c2+List[16];
		inpara+="^CheckDate"+c2+List[17];
	    inpara+="^SMToLoc"+c2+GetShortName(lista[sort+1],"-");//接收部门
		inpara+="^SMReciver"+c2+lista[sort+5];
		inpara+="^PrintDate"+c2+CurDate;
		//alert(inpara)
		DHC_PrintByLodop(LODOP,inpara,"","","",{printListByText:true});
	}
}

// add by zy0297 2022-03-28
// hisui分摊设置处理
//modified by LMH 20220913 增加函数入参 editIndex，解决点击出资比例超链接无响应的问题
function BDepreAllot_Clicked(editIndex)
{
	var rowData =  $("#DHCEQStoreMove").datagrid("getRows")[editIndex];
	var SMLRowID = (typeof rowData.SMLRowID == 'undefined') ? "" : rowData.SMLRowID;
	if (SMLRowID=="")
	{
		alertShow("请录入出库明细数据保存后,再来设置!")
		return
	}
	var ReadOnly=getElementValue("ReadOnly")
	var Status=getElementValue("SMStatus");
	if (Status!=0) {ReadOnly=1}
	var url='dhceq.em.costallot.csp?&CAHold2='+SMLRowID+'&CATypes=3'+'&ReadOnly='+ReadOnly+'&Status='+Status;
	showWindow(url,"出资比例","","","icon-w-paper","","","","middle"); //modify by lmm 2020-06-05 UI
}
