var editIndex=undefined;
var modifyBeforeRow = {};
var CTRowID=getElementValue("CTRowID");
var CTContractType=getElementValue("CTContractType")
var ComponentName="CON.G.Contract.ContractList"
if (CTContractType==1) ComponentName="CON.G.Contract.ContractListForMaint"
var Columns=getCurColumnsInfo(ComponentName,'','','')
var objtbl=$('#DHCEQContract')	//czf 2021-01-30 
var delRow=[]
var LocListFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",201015);
var ContratNoFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});// Mozy003016		2020-04-23
});

function initDocument()
{
	//modified zy 20191012 
	//setElement("CTSignLocDR_CTLOCDesc",getElementValue("CTSignLoc"))
	initUserInfo();
    initMessage(""); 	//获取所有业务消息
    initLookUp(); 			//初始化放大镜
    initCTHold1();			//初始化合同类型	add by CZF0067 2020--03-12		
    defindTitleStyle();
    initButton(); 				//按钮初始化 
    initButtonWidth();
    initIsIFB();
    InitEvent();
    setRequiredElements("CTContractName^CTProviderDR_VDesc^CTSignDate^CTHold1^CIsIFB^CTPurchaseType^CTSignLocDR_CTLOCDesc"); //必填项 MZY0040	1407717		2020-7-21
    setElement("CTSignDate",GetCurrentDate());		//Mozy	929782	2019-06-13
    fillData(); 				//数据填充
    setEnabled(); 				//按钮控制
    //initPage(); 				//非通用初始化
    setElementEnabled(); 		//输入框只读控制 	//Mozy	868476	2019-5-10
    //initEditFields(); 		//获取可编辑字段信息
    initApproveButtonNew(); 		//初始化审批按钮
    if (getElementValue("CTContractType")=="1") setRequiredElements("CTEndDate^CTTotalFee"); // Mozy003011	2020-04-14
	if (CTContractType==2) hiddenObj("panelTotal",1);	// MZY0153	3225019		2023-02-20
	if (getElementValue("OCRFlag")==1) hiddenObj("BCopy",1);	// MZY0153	3225463		2023-02-20
	$HUI.datagrid("#DHCEQContract",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContract",
	        	QueryName:"GetContractList",
		        RowID:CTRowID
		},
	    toolbar:[
	    	{
				iconCls: 'icon-add',
	            text:'新增',
	            id:'add',       
	            handler: function(){
	                 insertRow();
	            }
	        },		/// Mozy003006		2020-04-29		取消按钮的间距
	        {
	            iconCls: 'icon-cancel',
	            text:'删除',
	            id:'delete',
	            handler: function(){
	                 deleteRow();
	            }
	        },		///add BY ZY0274 20210707 增加批量添加设备的功能
	        {
	            iconCls: 'icon-batch-add',
	            text:'批量添加设备',
	            id:'batchaddequip',
	            handler: function(){
	                 batchAddEquip_Click();
	            }
	        }
	    ],
		rownumbers: true,  		//如果为true则显示行号列
		singleSelect:true,		// Mozy0243	2020-01-11	1146266
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40],
		onLoadSuccess:function(){
			creatToolbar();			
			// 设置隐藏列
			//modified by ZY0267 20210607
			var CTContractType=getElementValue("CTContractType")
			if (CTContractType==0)
			{
				//采购合同
				if (LocListFlag==0)
				{
					$("#DHCEQContract").datagrid("hideColumn", "CTLAction");
					$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
				}
				// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintTimes");
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintCountType_Desc");
				hiddenObj("batchaddequip",1);
			}
			else if (CTContractType==1)
			{
				//保修合同
				//$("#DHCEQContract").datagrid("showColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy	1068113	2019-10-26	Mozy0227
				// Mozy003011	2020-04-14
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				//$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");	// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				$("#DHCEQContract").datagrid("hideColumn", "CLLBuyLocDR_CTLOCDesc"); ///modfied by ZY0264 20210521
			}
			else if (CTContractType==2)
			{
				//协议合同
				$("#DHCEQContract").datagrid("hideColumn", "CTLQuantityNum");
				$("#DHCEQContract").datagrid("hideColumn", "CTLTotalFee");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractArriveDate");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// Mozy0230		2019-11-11	1090361
				// Mozy003018	1279498	2020-04-27
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLScheduledDate");
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				$("#DHCEQContract").datagrid("hideColumn", "CTLFundsList");	///modfied by ZY0263 20210514
				// MZY0095	2021-09-15
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintTimes");
				$("#DHCEQContract").datagrid("hideColumn", "CTLMaintCountType_Desc");
				hiddenObj("batchaddequip",1);
				disableElement("CTHold2",true);			// MZY0103	2314903		2021-12-06
			}
			if (getElementValue("CTStatus")=="")
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");	// Mozy	836945	2019-3-10
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");	///modfied by ZY0260 20210428
				//hiddenObj("batchaddequip",1);   //Modefied  by zc 2021115 zc0107 batchaddequip按钮影藏
			}
			// Mozy		2019-10-22	隐藏按钮
			if ((getElementValue("CTStatus")==1)||(getElementValue("CTStatus")==2))
			{
				hiddenObj("BSave",1);
				hiddenObj("BDelete",1);
				hiddenObj("BSubmit",1);
			}
			///modified by zy0259  20210420  整理一下逻辑
			if (getElementValue("CTStatus")<2)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// MZY0053	1503084	2020-09-08 合同信息未处于审核状态
			}
			//1:设备合同, 2:工程合同,3:软件合同,4配件 5验收后补合同
			if (getElementValue("CTHold1")==2)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		//modified by czf 1243349 工程合同不需验收
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
			}else if (getElementValue("CTHold1")==4)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLEquipAttribute");
				$("#DHCEQContract").datagrid("hideColumn", "CTLContractConfig");
			}
			else if (getElementValue("CTHold1")==5)
			{
				$("#DHCEQContract").datagrid("hideColumn", "CTLAction");		// MZY0066	1679245	2021-01-14 验收后补合同不需验收
				$("#DHCEQContract").datagrid("hideColumn", "CTLListLoc");
			}
			var rows = $('#DHCEQContract').datagrid('getRows');
		    	for (var i = 0; i < rows.length; i++)
		    	{
			    if (rows[i].CLLFlag!=1)
			    {
			    	$("#CTLAction"+"z"+i).hide()
		    		}
		    		else
		    		{
				    //$("#CTLListLoc"+"z"+i).hide()
				}
			}
		}
	});
};

///czf 2022-09-16
function initIsIFB()
{
	var cbox = $HUI.combobox("#CIsIFB",{
		valueField:'id', 
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		data:[
			{id:'',text:''},
			{id:'1',text:'是'},
			{id:'0',text:'否'}
		],
		onChange:function(newval,oldval){
			//
		}
	});
}

function InitEvent() //初始化
{
	/*	 MZY0024	1311628		2020-05-09	取消"退回"事件重复定义
	if (jQuery("#BCancelSubmit").length>0)
	{
		jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
	}*/
   /// Add:QW 20200810 BUG:QW0073 begin
	if (jQuery("#BBack").length>0)
	{
		jQuery("#BBack").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BBack").on("click", BBackData_Clicked);
	}
	/// Add:QW 20200810 BUG:QW0073 end
	if (jQuery("#BPayPlan").length>0)
	{
		jQuery("#BPayPlan").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BPayPlan").on("click", BPayPlan_Clicked);
	}
	if (jQuery("#BCopy").length>0)
	{
		jQuery("#BCopy").linkbutton({iconCls: 'icon-w-copy'});
		jQuery("#BCopy").on("click", BCopy_Clicked);
	}
	//modified zy 20191012 增加设备项维护的按钮事件
	if (jQuery("#BMasterItem").length>0)
	{
		jQuery("#BMasterItem").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BMasterItem").on("click", MenuMasterItem);
	}
	//Modify by zx 2020-02-25 BUG ZX0077
	if (jQuery("#BAppendFile").length>0)
	{
		jQuery("#BAppendFile").linkbutton({iconCls: 'icon-w-paper'});
		jQuery("#BAppendFile").on("click", BAppendFile_Clicked);
	}
	//add by CZF0090 2020-03-06
	$("#BProvider").on("click", BProvider_Clicked);
}
function initPage() //初始化
{
	//
}
//添加合计信息
function creatToolbar()
{
	// MZY0072	1801775		2021-04-19
	//var lable_innerText='总数量:'+getElementValue("CTTotalNum")+'&nbsp;&nbsp;&nbsp;总金额:'+getElementValue("CTTotalFee");		//czf 2021-01-28 1759063
	//if (getElementValue("CTContractType")==1) lable_innerText='维保设备总数量:'+getElementValue("CTTotalNum")+'&nbsp;&nbsp;&nbsp;维保设备总金额:'+getElementValue("CTTotalFee");	// Mozy003011	2020-04-14
	var lable_innerText='总数量:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2)
	if (getElementValue("CTContractType")==1) lable_innerText='维保设备总数量:'+totalSum("DHCEQContract","CTLQuantityNum")+'&nbsp;&nbsp;&nbsp;维保设备总金额:'+totalSum("DHCEQContract","CTLTotalFee").toFixed(2);	// Mozy003011	2020-04-14
	$("#sumTotal").html(lable_innerText);
	//modified by cjt 20230313 需求号3266462 "#sumTotal"改为".messager-popover"
	if (getElementValue("CTContractType")==2) $(".messager-popover").remove();	// Mozy003004	1247770		2020-3-30	协议合同不显示合计行
	var panel = $("#DHCEQContract").datagrid("getPanel");
	var rows = $("#DHCEQContract").datagrid('getRows');
	//图标影藏
    for (var i = 0; i < rows.length; i++) {
	    if ((rows[i].CTLSourceType=="")&&(rows[i].CTLSourceID==""))
	    {
		    $("#ContractConfig"+"z"+i).hide();
		}
		// MZY0060	1568741,1568794		2020-11-3	配件项
		if (rows[i].CTLSourceType==6)
		{
			$("#CTLContractConfig"+"z"+i).hide();	//'配置明细'
			$("#CTLAction"+"z"+i).hide();			//'通知验收'
			$("#CTLEquipAttribute"+"z"+i).hide();	//'设备属性'
			$("#CTLListLoc"+"z"+i).hide();			//'申购明细'	MZY0074	1846462		2021-04-30
		}
    }
	//按钮灰化
	var Status=getElementValue("CTStatus");
	if (Status>0)
	{
		// Mozy		2019-10-22	无效按钮
		disableElement("add",true);
		disableElement("delete",true);
	}
}
function fillData()
{
	if (CTRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetOneContract",CTRowID);
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
}
function setEnabled()
{
	var Type=getElementValue("Type");
	var Status=getElementValue("CTStatus");
	//modified by ZY0263   20210514
	if (String(Type)=="") Type=1
	if (String(Type)==0)
	{
		setElement("ReadOnly",0)
	}
	else
	{
		setElement("ReadOnly",1)
	}
	var ContractNoFlag=getElementValue("ContractNoFlag");
	var ReadOnly=getElementValue("ReadOnly");
	//alertShow("Type="+Type)
	//alertShow("CTStatus="+Status)
	disableElement("BClear",true); //add by wy 2020-9-24 1532207
	if (ReadOnly=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		///disableElement("BCancelSubmit",true);	//modified by ZY0263   20210514
		disableElement("BScan",true);
		//modified by ZY0263   20210514
		//disableElement("BApprove1",true);
		//disableElement("BApprove2",true);
		//disableElement("BApprove3",true);
		hiddenObj("BCancel",1);		// Mozy0253	1215171		2020-3-4
		hiddenObj("BBack",1);       //Add:QW 20200810 BUG:QW0073
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		//Modife by zc 2020-09-18 ZC0083    灰化复制合同按钮代码位置有处理 begin
		///Modefied by ZC0081 2020-09-07  灰化复制合同按钮  begin
		if (getElementValue("CopyFlag")!="")
		{
			disableElement("BCopy",true);
		}
		///Modefied by ZC0081 2020-09-07  灰化复制合同按钮  end
		//Modife by zc 2020-09-18 ZC0083    灰化复制合同按钮代码位置有处理 end
	}
	if (Status=="")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BCancelSubmit",true);
		disableElement("BPicture",true);
		disableElement("BAppendFile",true);  //Modify by zx 2020-02-25 BUG ZX0077
		disableElement("BScan",true);
		disableElement("BPayPlan",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true); //modified by CZF0088 2020-02-06 1217951
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
	    disableElement("BClear",false); //add by wy 2020-9-24 1532207
	    disableElement("batchaddequip",true);
	}
	else if (Status=="0")
	{
		disableElement("BCancelSubmit",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
	}
	else if (Status=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BScan",true);
		disableElement("BCopy",true);
		disableElement("BCancel",true);	//modified by CZF0088 2020-02-06 1217951
		disableElement("BBack",true);       //Add:QW 20200810 BUG:QW0073
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		disableElement("batchaddequip",true);
	}
	else if (Status=="2")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BCancelSubmit",true);
		disableElement("BScan",true);
		hiddenObj("BProvider",1);	//add by CZF0090 2020-03-06
		//add by CZF0055 2020-02-20
		var CancelOper=getElementValue("CancelOper")
		if (CancelOper=="Y")
		{
			hiddenObj("BCancel",0);
			disableElement("BCancel",false);
			disableElement("BBack",false);       //Add:QW 20200810 BUG:QW0073
		}
		else		//modified by CZF0088 2020-02-06 1217951
		{
			disableElement("BCancel",true);
			hiddenObj("BCancel",1); 
			disableElement("BBack",true); //Add:QW 20200810 BUG:QW0073
			hiddenObj("BBack",1); //Add:QW 20200810 BUG:QW0073
		}
		disableElement("batchaddequip",true);
	}
	if (Type=="0")
	{
		disableElement("BCancelSubmit",true);
	}
	else
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("BScan",true);
	}
	if (ContractNoFlag==1)
	{
		jQuery("#ContractNo").attr('disabled',true);
	}
	if (Status!=2)
	{
		hiddenObj("BCancel",1); 	//add by CZF0055 2020-02-20
		hiddenObj("BBack",1);       //Add:QW 20200810 BUG:QW0073
	}
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="CTProviderDR_VDesc")
	{
		setElement("CTProviderDR",rowData.TRowID);
		// Mozy		1068028		2019-10-26	Mozy0227
		setElement("CTProviderHandler",rowData.TContPerson);	
		setElement("CTProviderTel",rowData.TTel);
	}
	else if(elementID=="CTSignLocDR_CTLOCDesc") {setElement("CTSignLocDR",rowData.TRowID)}
	else if(elementID=="CTManageLocDR_CTLOCDesc") {setElement("CTManageLocDR",rowData.TRowID)}	//Mozy0233	2019-11-25 1096009	修正字段名
	else if(elementID=="CTBuyTypeDR_BTDesc") {setElement("CTBuyTypeDR",rowData.TRowID)}
	else if(elementID=="CTServiceDR_SVName")                          
	 { setElement("CTServiceDR",rowData.TRowID)                         //modified by wl 2019-10-14 1040848
	   setElement("CTServiceTel",rowData.TTel)
	   setElement("CTServiceHandler",rowData.TContPerson)
	 }
	else if(elementID=="CTSubType_List") {setElement("CTSubType",rowData.TRowID)}	//	Mozy	770055	2018-12-20
	else if(elementID=="CTNeedHandlerDR_SSUSRName") {setElement("CTNeedHandlerDR",rowData.TRowID)}	// MZY0095	2021-09-15
	else if(elementID=="CTTaxItemDR_TIDesc") {setElement("CTTaxItemDR",rowData.TRowID)}	//czf 2022-09-19
	else if(elementID=="CTRequestLocDR_CTLOCDesc") {setElement("CTRequestLocDR",rowData.TRowID)} //czf 2022-09-19	
	//else if(elementID=="ContractTypeList") {setElement("CTContractType",rowData.TRowID)}
}
///modified by ZY02264 20210521
/*
//	Mozy	770055	2018-12-20
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
*/
///modified by ZY02264 20210521
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

///modified by ZY02264 20210521
function clearCLLBuyLoc()
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CLLBuyLocDR="";
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit',editIndex);
}
// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		$("#DHCEQContract").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQContract").datagrid('getRows');
    var lastIndex=rows.length-1;
    var newIndex=rows.length;
    // MZY0086		2021-8-12
    if ((lastIndex>0)&&(rows[lastIndex].CTLSourceID=="undefined"))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	}
	else
	{
		$("#DHCEQContract").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		/// modified by ZY0263 20210514
		$("#CTLContractConfig"+"z"+newIndex).hide();
		$("#CTLAction"+"z"+newIndex).hide();
		$("#CTLEquipAttribute"+"z"+newIndex).hide();
		$("#CTLScheduledDate"+"z"+newIndex).hide();
		$("#CLLAction"+"z"+newIndex).hide();
		$("#CTLFundsList"+"z"+newIndex).hide();
	}
}
//Mozy	898948	2019-5-22
///czf 1754903 2021-01-28
function deleteRow()
{
	/*
	////modified zy 20191012 调用公共方法删除行
	if ((editIndex>"0")||(editIndex="0"))  //modify by wl 2019-9-3 1014272
	{
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//结束编辑并传入之前编辑的行
		//$("#DHCEQContract").datagrid('deleteRow',editIndex);
	}
	removeCheckBoxedRow("DHCEQContract")
	
	else if(editIndex=="0")
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
	*/
	if (editIndex != undefined)
	{
		if(objtbl.datagrid('getRows').length<=1)
		{
			messageShow("alert",'info',"提示",t[-9242]);	//当前行不可删除
			return
		}
		jQuery("#DHCEQContract").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		var CTLRowID=objtbl.datagrid('getRows')[editIndex].CTLRowID
		delRow.push(CTLRowID)
		objtbl.datagrid('deleteRow',editIndex);
	}
	else
	{
		messageShow("alert",'info',"提示",t[-9243]);	//请选中一行
	}
}
function BSave_Clicked()
{
    //modified by ZY20230307 bug:3314754
    if (checkLegalChar("CTFileNo")!=true) return true
	if ((ContratNoFlag!="1")&&(getElementValue("CTContractNo")==""))
	{
		messageShow('alert','error','错误提示','合同编号不能为空!');
		return;
	}
	if (getElementValue("CTContractType")=="")
	{
		messageShow('alert','error','错误提示','合同类型不能为空!');
		return;
	}
	if (getElementValue("CTContractName")=="")
	{
		messageShow('alert','error','错误提示','合同名称不能为空!');
        return;
    }
    if (getElementValue("CTTotalFee")<0)
    {
        messageShow('alert','error','错误提示','合同总价不能为负数!');
        return;
    }
    if (getElementValue("CTPreFeeFee")<0)
    {
        messageShow('alert','error','错误提示','预付款不能为负数,请输入正数!');
        return;
	}
    //modified by ZY20230322 bug:3314754
    if (getElementValue("CTGuaranteePeriodNum")<0)
    {
        messageShow('alert','error','错误提示','保修期(月)不能为负数,请输入正数!');
        return;
    }
	// MZY0057	1493603		2020-10-09
	if ((getElementValue("CTContractType")!=1)&&(getElementValue("CTHold1")==""))
	{
		messageShow('alert','error','错误提示','合同类型不能为空!');
		return;
	}
	// MZY0051	1501969		2020-09-06
	if (getElementValue("CTProviderDR")=="")
	{
		var val=GetPYCode(getElementValue("CTProviderDR_VDesc"))+"^"+getElementValue("CTProviderDR_VDesc")+"^^^";
		var CTProviderDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if ((CTProviderDR=="")||(CTProviderDR<0))
		{
			messageShow('alert','error','错误提示','中标、签约公司不能为空!');
			return;
		}
		else
			setElement("CTProviderDR",CTProviderDR);
	}
	if ((getElementValue("CTServiceDR")=="")&&(getElementValue("CTServiceDR_SVName")!=""))		//modified by czf 2020-10-21 begin 1571970
	{
		var val=GetPYCode(getElementValue("CTServiceDR_SVName"))+"^"+getElementValue("CTServiceDR_SVName")+"^^^4";
		var CTServiceDR=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if ((CTServiceDR=="")||(CTServiceDR<0))
		{
			messageShow('alert','error','错误提示','服务商保存错误!');		//modified by czf 2020-10-21 end
			return;
		}
		setElement("CTServiceDR",CTServiceDR);
	}
	if (getElementValue("CTSignDate")=="")
	{
		messageShow('alert','error','错误提示','签订日期不能为空!');
		return;
    }
    ///add by ZY20230309 bug:3301084\3301084
    var CTSignDate = new Date(FormatDate(getElementValue("CTSignDate")).replace(/\-/g, "\/"))
    var CTStartDate = new Date(FormatDate(getElementValue("CTStartDate")).replace(/\-/g, "\/"))
    var CTEndDate = new Date(FormatDate(getElementValue("CTEndDate")).replace(/\-/g, "\/"))
    if (CTStartDate>CTSignDate)
    {
        messageShow('alert','error','错误提示','签订日期不能晚于开始日期!');
        return;
    }
    if (CTStartDate>CTSignDate)
    {
        messageShow('alert','error','错误提示','签订日期不能晚于截止日期!');
        return;
    }
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTEndDate")==""))
	{
		messageShow('alert','error','错误提示',"保修截止日期不能为空!");
		return;
	}
	// Mozy003011	2020-04-14
	if ((getElementValue("CTContractType")=="1")&&(getElementValue("CTTotalFee")==""))
	{
        messageShow('alert','error','错误提示',"维保总金额不能为空,请输入正数!");
		return;
	}
	// MZY0098	2207387		2021-10-15
	if ((getElementValue("CTHold1")==4)&&(getElementValue("CTHold2")==1))
	{
		messageShow('alert','error','错误提示',"配件合同类型不能设置为验收后补合同!");
		return;
	}
	/*	 MZY0095	2021-09-15
	if (getElementValue("CTHold3")!="")
	{
		if (getElementValue("CTHold4")=="")
		{
			messageShow('alert','error','错误提示',"填写维保次数后，维保预警天数不能为空!");
			return;
		}
		if (getElementValue("CTStartDate")=="")
		{
			messageShow('alert','error','错误提示',"保修开始日期不能为空!");
			return;
		}
	}*/
	//czf 2022-09-19
	if (getElementValue("CIsIFB")=="")
	{
		messageShow('alert','error','错误提示','是否招标不能为空!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	if (editIndex != undefined){ $('#DHCEQContract').datagrid('endEdit', editIndex);}
	var rows = $('#DHCEQContract').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		// modified by ZY0265 20210526
		// MZY0040	1407717		2020-7-21
		if ((oneRow.CTLSourceType!=6)&&(getElementValue("CTHold1")==4))
		{
			messageShow('alert','error','错误提示','配件合同. 第'+(i+1)+'行数据不正确:数据来源方式应该是配件项!');
			return "-1";
		}
		if ((oneRow.CTLSourceType==6)&&(getElementValue("CTHold1")!=4))
		{
			messageShow('alert','error','错误提示','非配件合同. 第'+(i+1)+'行数据不正确:数据来源方式不能是配件项!');
			return "-1";
		}
		// MZY0095	2021-09-15
		if ((oneRow.CTLSourceType!=7)&&(getElementValue("CTHold2")==1))
		{
			messageShow('alert','error','错误提示','验收后补合同. 第'+(i+1)+'行数据不正确:数据来源方式应该是验收单!');
			return "-1";
		}
		if ((oneRow.CTLSourceType==7)&&(getElementValue("CTHold2")!=1))
		{
			messageShow('alert','error','错误提示','非验收后补合同. 第'+(i+1)+'行数据不正确:数据来源方式不能是验收单!');
			return "-1";
		}
		// MZY0098	2166119		2021-10-15
		if ((oneRow.CTLSourceType==7)&&(getElementValue("CTHold2")==1))
		{
			var IDFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckIDForOCL",oneRow.CTLRowID,oneRow.CTLSourceID);
			if (IDFlag!=0)
			{
				messageShow('alert','error','错误提示','验收后补合同. 第'+(i+1)+'行数据不正确:数据来源重复!');
				return "-1";
			}
		}
		//Mozy	898948	2019-5-22
		if ((oneRow.CTLSourceType!=99)&&((oneRow.CTLSourceID_Desc=="")||(oneRow.CTLSourceID_Desc==undefined)))
		{
			messageShow('alert','error','错误提示','第'+(i+1)+'行数据不正确:没有选择来源数据!');
			return "-1";
		}
		///modified by ZY0214
		var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","94","");
		// MZY0040	1407717		2020-7-21
		if ((oneRow.CTLSourceType!=99)&&(ItemReqFlag==0)&&(oneRow.CTLItemDR=="")&&(getElementValue("CTHold1")!=4))
		{
			messageShow('alert','error','错误提示','设备项不能为空!');
			return -1
		}
		///end by ZY0214
		if (getElementValue("CTContractType")==0)
		{
			////modified zy 20191012 设备项不必填
			/*
			if (oneRow.CTLItemDR=="")
			{
				messageShow('alert','error','错误提示','第'+(i+1)+'行[通用名]不正确!');
				return "-1";
			}
			*/
			if (oneRow.CTLQuantityNum=="")
			{
                messageShow('alert','error','错误提示','第'+(i+1)+'行[数量]不正确,请输入正数!');
				return "-1";
			}
			if (oneRow.CTLPriceFee=="")
			{
                messageShow('alert','error','错误提示','第'+(i+1)+'行[单价]不正确,请输入正数!');
				return "-1";
			}
		}
		//Mozy	810416	2019-1-21
		if (rows[i].CTLSourceID!="")
		{
			// MZY0066	1679245		2021-01-14	自动保存来源设备项的规格型号
			if (oneRow.CTLSourceType==3)
			{
				if ((oneRow.CTLModelDR_MDesc!="")&&(oneRow.CTLModelDR==""))
				{
					oneRow.CTLModelDR=tkMakeServerCall("web.DHCEQCModel","UpdModel",oneRow.CTLModelDR_MDesc+"^"+oneRow.CTLPriceFee,oneRow.CTLItemDR);
				}
			}
			// 增加明细行型号重复判断
			for(var j=0;j<rows.length;j++)
			{
				if ((j!=i)&&(rows[j].CTLSourceType==3)&&(rows[j].CTLItemDR==oneRow.CTLItemDR)&&(rows[j].CTLModelDR_MDesc==oneRow.CTLModelDR_MDesc))
				{
					// 不同行且设备项相同的明细
					//alert(i+": oneRow.CTLModelDR_MDesc="+oneRow.CTLModelDR_MDesc+"   "+j+": rows[j].CTLModelDR_MDesc="+rows[j].CTLModelDR_MDesc)
					messageShow('alert','error','提示',"第"+(i+1)+"行与第"+(j+1)+"行型号重复!")
					return;
				}
			}
			//czf 2022-10-11 begin
			var manuFactoryName=oneRow.CTLManuFactoryDR_MFName;
			var FirmType=3;
		 	var val="^"+manuFactoryName+"^^^"+FirmType;
			var ManuFactoryRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
			oneRow.CTLManuFactoryDR=ManuFactoryRowID;
			//czf 2022-10-11 end
			// MZY0053	1505534	2020-09-08	End
			val="manufacturer=CTLManuFactoryDR_MFName="+oneRow.CTLManuFactoryDR+"^";
			val=tkMakeServerCall("web.DHCEQCommon","GetDRDesc",val);
			list=val.split("^");
			Detail=list[0].split("=");
			if (oneRow.CTLManuFactoryDR_MFName!=Detail[1])
			{
				oneRow.CTLManuFactoryDR_MFName="";
				oneRow.CTLManuFactoryDR="";
			}
			if (oneRow.CTLHold2_ETDesc=="") oneRow.CTLHold2="";		// MZY0043	2020-08-05	清空管理类组
            ///add by ZY20230309 bug:3314660\3314717
            if (oneRow.CTLGuaranteePeriodNum<0)
            {
                messageShow('alert','error','错误提示','第'+(i+1)+'行[保修期]不正确,请输入正数!');
                return "-1";
            }
            if (oneRow.CTLQuantityNum<0)
            {
                messageShow('alert','error','错误提示','第'+(i+1)+'行[数量]不正确,请输入正数!');
                return "-1";
            }
			//modified by ZY20230407 bug:3412104
			var priceFee=Number(oneRow.CTLPriceFee)
			var retNum = /^[0-9]+\.?[0-9]*$/	//匹配正数
			if(!retNum.test(priceFee))
			{
                messageShow('alert','error','错误提示','第'+(i+1)+'行[单价]不是数字,请输入正数!');
                return "-1";
			}
			else
			{
				if (priceFee<0)
				{
					messageShow('alert','error','错误提示','第'+(i+1)+'行[单价]不正确,请输入正数!');
					return "-1";
				}
			}
            if (oneRow.CTLTotalFee<0)
            {
                messageShow('alert','error','错误提示','第'+(i+1)+'行[总金额]不正确,请输入正数!');
                return "-1";
            }
            //modified by ZY20230307 bug:3357775、3357724
            if (oneRow.CTLHold1<0)
            {
                messageShow('alert','error','错误提示','第'+(i+1)+'行[技术服务费]不正确,请输入正数!');
                return "-1";
            }
			var RowData=JSON.stringify(rows[i]);
			if (dataList=="")
			{
				dataList=RowData;
			}
			else
			{
				dataList=dataList+getElementValue("SplitRowCode")+RowData;	// Mozy0235	2019-11-27
			}
		}
	}
	if (dataList=="")
	{
		messageShow('alert','error','错误提示','合同明细不能为空!');
		return;
	}
	var DelRowid=delRow.join(',')			//czf 2021-01-27 获取删除行rowid串 1754903
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SaveData",data,dataList,DelRowid);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同删除!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","DeleteData",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var val="&ContractType="+getElementValue("CTContractType")+"&Type="+getElementValue("Type")+"&QXType="+getElementValue("QXType")+"&AuditType="+getElementValue("AuditType");	//czf 1914903
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同提交!');
		return;
	}
	// Mozy003019		2020-04-28
	if (getElementValue("CTContractNo")=="")
	{
		messageShow('alert','error','错误提示','合同号为空,不能提交!');
		return;
	}
	// MZY0098	2207387		2021-10-15
	if ((getElementValue("CTHold1")==4)&&(getElementValue("CTHold2")==1))
	{
		messageShow('alert','error','错误提示',"配件合同类型不能设置为验收后补合同!");
		return;
	}
	// MZY0098	2166119		2021-10-15
	if (getElementValue("CTHold2")==1)
	{
		var rows = $('#DHCEQContract').datagrid('getRows');
		for (var i = 0; i < rows.length; i++) 
		{
			var oneRow=rows[i];
			var IDFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckIDForOCL",oneRow.CTLRowID,oneRow.CTLSourceID);
			if (IDFlag==1)
			{
				messageShow('alert','error','错误提示','验收后补合同. 第'+(i+1)+'行数据不正确:数据来源重复!');
				return "-1";
			}
		}
	}
	///modfied by ZY0267 20210607
	var CTContractType=getElementValue("CTContractType")
	if ((CTContractType==1)||(CTContractType==2))
	{
		//Add By By zy20221115 bug：3073937
		if (CTContractType==2)
		{
			var CTStartDate=getElementValue("CTStartDate")
			var CTEndDate=getElementValue("CTEndDate")
			if ((CTStartDate=="")||(CTEndDate==""))
			{
				messageShow('alert','error','错误提示','协议合同的合同开始时间和结束时间不能为空!');
				return "-1";
			}
		}
		
		OptSubmit();
	}
	else
	{
		var CTHold1=getElementValue("CTHold1")	//2 工程合同
		if (CTHold1==2)
		{
			OptSubmit();
		}
		else
		{
			if (LocListFlag==1)		//czf 2022-04-11 启用多科室参数才判断
			{
				var result=tkMakeServerCall("web.DHCEQ.Con.BUSContractListLoc","CheckContractListLoc", CTRowID);
				if (result=="")
				{
					OptSubmit();
				}else
				{
					messageShow("confirm","info","提示",result+",是否继续提交?","",OptSubmit,function(){
						return;
					});
				}
			}
			else
			{
				OptSubmit();
			}
		}
	}
}
function OptSubmit()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","SubmitData",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var url="dhceq.con.contract.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?&RowID="+jsonData.Data+"&Type="+getElementValue("Type")+"&ContractType="+getElementValue("CTContractType");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同取消!');
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("Status");
		var WaitAD=getElementValue("WaitAD"); 
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var ApproveRole=getElementValue("CurRole");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function BApprove_Clicked()
{
  	var combindata=getValueList();
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","AuditData",combindata,CurRole,RoleStep,"");
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
    }
    else
    {
	    //window.location.reload()
		var Status=getElementValue("Status");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var val="&RowID="+RtnObj.Data+"&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");		//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}
function getValueList()
{
	var combindata=CTRowID;
	combindata=combindata+"^"+session['LOGON.USERID'];
	combindata=combindata+"^"+getElementValue("ApproveSetDR");
	combindata=combindata+"^"+getElementValue("CancelToFlowDR");
	combindata=combindata+"^"+getElementValue("EditOpinion");
	combindata=combindata+"^"+getElementValue("RejectReason");
  	
	return combindata;
}
function BPicture_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','请先保存单据!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	var Status=+getElementValue("CTStatus");
	if (Status>0) Status=0;
	var value=getElementValue("CTContractType");	//0:采购合同  1:保修合同  2:协议合同
	if (value==1)
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+Status+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
	}
	else
	{
		//modified by czf 20190305
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+Status+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
	}
	showWindow(str,"图片","","","icon-w-paper","modal","","","middle");	//modify by lmm 2020-06-04 UI
}
function BPayPlan_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','请先保存该数据,才能处理付款计划!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	///SourceType:1合同  2验收
	//var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
    var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType=1&SourceID="+CTRowID+"&ReadOnly="+ReadOnly;
	showWindow(str,"付款计划","","","icon-w-paper","modal","","","large");	//modify by lmm 2020-06-04 UI
}
function BPrint_Clicked()
{
	//alertShow("BPrint_Clicked")
}
function BCopy_Clicked()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CopyContract",CTRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","操作成功");
	    //window.location.reload()
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var CurRole=getElementValue("CurRole");
		var val="&RowID="+jsonData.Data+"&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType");	//Mozy	776803	2018-12-12
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQContract').datagrid('validateRow', editIndex))
	{
		$('#DHCEQContract').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index)
{
	var Status=getElementValue("CTStatus");
	if (Status>0) return;
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#DHCEQContract').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQContract').datagrid('getRows')[editIndex]);
			///modofied by 20220725
			if (CTContractType!=1) bindGridEvent(); //编辑行监听响应	 Mozy003011	2020-04-14	取消注释
		} else {
			$('#DHCEQContract').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

//modified by csj 2020-05-09 需求号：1311282，1311051
function GetSourceType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	// Mozy003013	1279967 	2020-04-18	注释并修正隐藏元素
	//SetElement("SourceType",data.TRowID);
	//SetElement("SourceType_Desc",data.TDesc);
	rowData.CTLSourceType=data.TRowID
	SetElement("CTLSourceTypeDesc",data.TDesc);
	SetElement("CTLSourceType",data.TRowID);
	//Mozy	865594	2019-5-9	重新加载来源数据
   	var sourceIDEdt = $("#DHCEQContract").datagrid('getEditor', {index:editIndex,field:'CTLSourceID_Desc'});
   	$(sourceIDEdt.target).combogrid('grid').datagrid('load');
   	var sourceTypeEdt = $("#DHCEQContract").datagrid('getEditor', {index:editIndex,field:'CTLSourceType_Desc'});
   	$(sourceTypeEdt.target).combogrid("setValue",data.TDesc);
   	$('#DHCEQContract').datagrid('endEdit',editIndex);
   	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
}
function GetSourceID(index,data)
{
	// Mozy003012	2020-04-15	增加明细行重复判断
	var rows = $('#DHCEQContract').datagrid('getRows'); 
	if(data.TSourceID!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			// MZY0053	1505534		2020-09-08	过滤重复选中
			if ((i!=editIndex)&&(rows[i].CTLSourceType==getElementValue("CTLSourceType"))&&(rows[i].CTLSourceID==data.TSourceID)&&(rows[i].CTLSourceType!=3))
			{
				messageShow('alert','error','提示',t[-9240].replace("[RowNo]",(i+1)))
				return;
			}
		}
	}
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLSourceType=getElementValue("CTLSourceType");	// Mozy003013	1279967 	2020-04-18
	rowData.CTLSourceID=data.TSourceID;
	rowData.CTLModelDR=data.TModelDR;
	rowData.CTLManuFactoryDR=data.TManuFacDR;
	rowData.CTLUnitDR_UOMDesc=data.TUnit;	//Mozy	762902	2018-12-2
	rowData.CTLUnitDR=data.TUnitDR;	//czf 2022-10-11
	rowData.CTLItemDR=data.TItemDR;
	SetElement("EQItemDR",rowData.CTLItemDR);		//MZY0052	1503091		2020-09-07
	rowData.CTLTotalFee=data.TTotalFee;
	///modofied by 20220725
	rowData.CTLHold2=data.TEquipTypeDR;	
	//rowData.CTLItem=data.CTLItem;
	rowData.CTLGuaranteePeriodNum=data.TGuaranteePeriodNum  //modified by ZY0303 20220615 2686600
	
	var objGrid = $("#DHCEQContract");
	var nameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLName'}); 
	$(nameEdt.target).val(data.TName);
	var sourceTypeDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceType_Desc'}); 
	$(sourceTypeDescEdt.target).combogrid("setValue",getElementValue("CTLSourceTypeDesc"));		// Mozy003013	1279967 	2020-04-18
	var sourceIDDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLSourceID_Desc'});
	$(sourceIDDescEdt.target).combogrid("setValue",data.TNo);		// Mozy003011	2020-04-14
	var CTLItemEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLItem'});
	// MZY0149	3163972		2023-01-09
	if (CTLItemEdt)
	{
		$(CTLItemEdt.target).combogrid("setValue",data.CTLItem);
	}
	else
	{
		rowData.CTLItem=data.CTLItem;
	}
	// MZY0057	1506387		2020-10-09	合同明细选择设备项不清空明细数据
	if (getElementValue("CTLSourceType")!=3)
	{
		var modelDRMDescEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLModelDR_MDesc'}); 
		// MZY0149	3163972		2023-01-09
		if (modelDRMDescEdt)
		{
			$(modelDRMDescEdt.target).combogrid("setValue",data.TModel);
			$(modelDRMDescEdt.target).combogrid('grid').datagrid('load');
		}
		else
		{
			rowData.CTLModelDR_MDesc=data.TModel;
		}
		var manuFactoryDRMFNameEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLManuFactoryDR_MFName'}); 
		// MZY0149	3163972		2023-01-09
		if (manuFactoryDRMFNameEdt)
		{
			$(manuFactoryDRMFNameEdt.target).combogrid("setValue",data.TManuFac);
		}
		else
		{
			rowData.CTLManuFactoryDR_MFName=data.TManuFac;
		}
		var priceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
		// MZY0149	3163972		2023-01-09
		if (priceFeeEdt)
		{
			$(priceFeeEdt.target).val(data.TPriceFee);
		}
		else
		{
			rowData.CTLPriceFee=data.TPriceFee;
		}
		var quantityNumEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'}); 
		// MZY0149	3163972		2023-01-09
		if (quantityNumEdt)
		{
			$(quantityNumEdt.target).val(data.TQuantityNum);
		}
		else
		{
			rowData.CTLQuantityNum=data.TQuantityNum;
		}
	}
	// MZY0061	1612536		2020-12-2	调整'类组'赋值
	rowData.CTLHold2=data.TEquipTypeDR;
	var CTLHold2Edt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLHold2_ETDesc'}); 
	// MZY0149	3163972		2023-01-09
	if (CTLHold2Edt)
	{
		$(CTLHold2Edt.target).combogrid("setValue",data.TEquipType);
	}
	else
	{
		rowData.CTLHold2_ETDesc=data.TEquipType;
	}
	rowData.CTLUnitDR=data.TUnitDR;
	var UnitEditor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLUnitDR_UOMDesc'});
	if (UnitEditor)
	{
		$(UnitEditor.target).combogrid("setValue",data.TUnit);
	}else{
		rowData.CTLUnitDR_UOMDesc=data.TUnit;
	}

	
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
}
function GetModel(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLModelDR=data.TRowID;
	// MZY0053	1505534		2020-09-08	增加明细行重复判断
	var rows = $('#DHCEQContract').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		//alert("i="+i+" rowData.CTLItemDR="+rowData.CTLItemDR+"   rows[i].CTLItemDR="+rows[i].CTLItemDR+"   CTLSourceType="+rows[i].CTLSourceType)
		if ((i!=editIndex)&&(rows[i].CTLSourceType==3)&&(rows[i].CTLItemDR==rowData.CTLItemDR)&&(rows[i].CTLModelDR==data.TRowID))
		{
			messageShow('alert','error','提示',t[-9240].replace("[RowNo]",(i+1)))
			return;
		}
	}
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLModelDR_MDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	//$(editor[3].target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
}

function GetManuFacturer(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLManuFactoryDR=data.TRowID;	// Mozy		770055	2018-12-20
	// Mozy		769995	2018-12-12
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLManuFactoryDR_MFName'});
	$(editor.target).combogrid("setValue",data.TName);
	//$(editor[4].target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);	// MZY0037	1400284		2020-07-06
	if (CTContractType!=1) bindGridEvent();
}

//czf 2022-10-11
function GetUOM(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLUnitDR=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLUnitDR_UOMDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
	bindGridEvent();
}
// 需求：741240		2018-11-12
function GetEquipID(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	//rowData.ISLHold5=data.TRowID
	//rowData.ISLHold5_EDesc=data.TName
}
function GetBrand(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLBrandDR=data.TRowID
	rowData.CTLBrandDR_BDesc=data.TName
}
function checkboxDisabledChange()
{
	alertShow("checkboxDisabledChange")
}
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
        var objGrid = $("#DHCEQContract");		// 表格对象
        // Mozy003013	1279967 	2020-04-18	对选中明细行参数进行赋值
        setElement("CTLSourceTypeDesc", objGrid.datagrid('getSelected').CTLSourceType_Desc);
        setElement("CTLSourceType", objGrid.datagrid('getSelected').CTLSourceType);
        setElement("CTLSourceID",objGrid.datagrid('getSelected').CTLSourceID);
        setElement("CTLRowID",objGrid.datagrid('getSelected').CTLRowID);
        SetElement("EQItemDR",objGrid.datagrid('getSelected').CTLItemDR);	//MZY0052	1503091		2020-09-07
        var invQuantityEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLQuantityNum'});	// 数量
        var invPriceFeeEdt = objGrid.datagrid('getEditor', {index:editIndex,field:'CTLPriceFee'});
        ///modofied by 20220725
	if (invQuantityEdt!=null)
        {
	        // 数量  绑定 离开事件 
	        $(invQuantityEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = $('#DHCEQContract').datagrid('getSelected');
				rowData.CTLTotalFee=quantityNum*originalFee;
				//$('#DHCEQContract').datagrid('endEdit',editIndex);	//编辑后不关闭编辑状态 2022-12-30
	        });
        }
        if (invPriceFeeEdt!=null)
        {
			// Mozy003011	2020-04-14	增加单价触发事件
	        $(invPriceFeeEdt.target).bind("blur",function(){
	            // 根据数量变更后计算 金额
	            var quantityNum=parseFloat($(invQuantityEdt.target).val());
	            var originalFee=parseFloat($(invPriceFeeEdt.target).val());
	            var rowData = $('#DHCEQContract').datagrid('getSelected');
				rowData.CTLTotalFee=quantityNum*originalFee;
				//$('#DHCEQContract').datagrid('endEdit',editIndex);	//编辑后不关闭编辑状态 2022-12-30
	        });
        }
    }
    catch(e)
    {
        alertShow(e);
    }
}
//Mozy	868476	2019-5-10
function setElementEnabled()
{
	var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	if(Rtn=="1")
	{
		 disableElement("CTContractNo",true);
	}
	else
	{
		setRequiredElements("CTContractNo")
	}
}

//add by csj 20190809 供模态窗回调刷新列表
function reloadDatagrid()
{
	$('#DHCEQContract').datagrid('reload');
}
//add by csj 20190809 通用名
function GetMasterItem(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLItemDR=data.TRowID;
	var editor =$('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLItem'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	// MZY0038	2020-7-10
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
	if (CTContractType!=1) bindGridEvent();
}
///modfied by ZY0260 20210428  重新启用
// MZY0053	1503084		2020-09-08		注释
//add by zy 20190809 通知验收
function ArriveConfirmClickHandler(index) 
{
	if (getElementValue("CTStatus")<2)
	{
		messageShow('alert','error','错误提示','请先确保合同信息处于审核状态!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	if (!rowData) return
	if (rowData.CTLRowID=="")
	{
		messageShow('alert','error','错误提示','无合同信息!');	// Mozy0230		2019-11-11	1090361
		return;
	}
	// MZY0047	1455739		2020-08-19
	if (rowData.CTLSourceType==6)
	{
		messageShow('alert','error','错误提示','配件无法进行设备的通知验收!');
		return;
	}
	var url="dhceq.em.arrive.csp?&SourceType=1&SourceID="+rowData.CTLRowID
	//alertShow(url)
	showWindow(url,"验收通知","350","11row","icon-w-paper","modal","","","");    //modify by lmm 2020-06-02 UI
}
///add by zy 20190919
function MenuMasterItem()
{
	///modified by ZY20230328 bug:3333797
    // Mozy003011   2020-04-14  修正合同业务中“名称字典库”链接
    var url='dhceq.plat.masteritem.csp?&ReadOnly=';
    if ((getElementValue("CTStatus")>0)||(getElementValue("ReadOnly")==1)) url=url+"1";
    showWindow(url,"设备通用名称字典库","","","icon-w-paper","modal","","","verylarge"); //modify by lmm 2020-06-04 UI
}

//add by CZF0055 2020-02-20
//合同作废
function BCancel_Clicked()
{
	var CTRowID=getElementValue("CTRowID")
  	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CheckBussCancelFlag",4,CTRowID);
  	
	var result=results.split("^")
	if (result[0]!="0")
	{
		messageShow("","","",result[1])
	}
	else
	{
		var confirmStr=""		//czf 2286940 2021-11-18 begin
		if (result[4]!=""){
			confirmStr=confirmStr+"相关的验收:"+result[4]
			if (result[2]!=""){
				confirmStr=confirmStr+",入库:"+result[2]
				if (result[3]!=""){
					confirmStr=confirmStr+",转移:"+result[3]+",台账"
				}
				else{
					confirmStr=confirmStr+",台账"
				}
			}
			confirmStr=confirmStr+"也一起作废!是否继续?"
		}
		else if (result[5]!="")		// MZY0109	2384432		2021-12-23
		{
			confirmStr=confirmStr+"相关的配件入库:"+result[5];
			if (result[6]!="") confirmStr=confirmStr+",配件出库:"+result[6];
			confirmStr=confirmStr+"也一起作废!是否继续?";
		}
		else{
			confirmStr=confirmStr+"是否作废该合同?"
		}
		
		messageShow("confirm","","",confirmStr,"",ConfirmOpt,DisConfirmOpt);	//czf 2286940 2021-11-18 end
	}
}
// Mozy003006		2020-04-03	UI评审修正
function ConfirmOpt()
{
	var results=tkMakeServerCall("web.DHCEQAbnormalDataDeal","CancelBuss",4,getElementValue("CTRowID"));
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
		var url="dhceq.con.contract.csp?&RowID="+CTRowID
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	   	window.setTimeout(function(){window.location.href=url},50); 
	}
}
function DisConfirmOpt()
{
}

//Modify by zx 2020-02-25 BUG ZX0077
function BAppendFile_Clicked()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','请先保存单据!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	// Mozy		784069	2018-12-20
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0) CTStatus=0;
	var value=getElementValue("CTContractType");
	if (value==0)
	{
		//Modefied by zc0060 20200329 文件上传改造  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=94&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
		//Modefied by zc0060 20200329 文件上传改造  end
	}
	else
	{
		//Modefied by zc0060 20200329 文件上传改造  begin
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=95&CurrentSourceID='+CTRowID+'&Status='+CTStatus+'&ReadOnly='+ReadOnly;	// MZY0153	3225463		2023-02-20
		//Modefied by zc0060 20200329 文件上传改造  end
	}
	showWindow(str,"电子资料","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04
}

//add by CZF0090 2020-03-06
function BProvider_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly");
	var CTStatus=+getElementValue("CTStatus");
	if (CTStatus>0)	ReadOnly=1;
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCVendor&ReadOnly="+ReadOnly;
	showWindow(str,"公司信息维护","","","icon-w-paper","modal","","","verylarge");		//modified by lmm 2020-06-04
}

// MZY0066	1679245		2021-01-14	调整合同类型
function initCTHold1()
{
	if (getElementValue("CTContractType")==0)
	{
		//采购合同	MZY0095	2021-09-15
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '设备合同'},{id: '2',text: '工程合同'},{id: '3',text: '软件合同'},{id: '4',text: '配件合同'}],
			onSelect : function(){}
		});
	}
	if (getElementValue("CTContractType")==1)
	{
		//保修合同
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '设备合同'},{id: '2',text: '工程合同'},{id: '3',text: '软件合同'}],
			onSelect : function(){}
		});
	}
	if (getElementValue("CTContractType")==2)
	{
		//协议合同
		var CTHold1 = $HUI.combobox('#CTHold1',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[{id: '1',text: '设备合同'},{id: '2',text: '工程合同'},{id: '3',text: '软件合同'}],
			onSelect : function(){}
		});
	}
}
// MZY0072	1797995		2021-04-19	修正根据Index取行
function EquipAttributeClickHandler(index) 
{
	var rows = $('#DHCEQContract').datagrid('getRows');//获得所有行
	if (!rows) return;
	// MZY0144	3070773		2022-11-24
	if ((rows[index].CTLRowID=="")||(rows[index].CTLRowID==undefined))
	{
		messageShow('alert','error','错误提示','保存合同信息后才可以进行设备属性设置!');
		return;
	}
	
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	var url='dhceq.em.equipattributelist.csp?SourceType=4&SourceID='+rows[index].CTLRowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"合同设备属性","","","icon-w-paper","modal","","","middle");  //modify by lmm 2020-06-04 UI
}
// MZY0072	1797995		2021-04-19	修正根据Index取行
function ScheduledDateClickHandler(index)
{
	var rows = $('#DHCEQContract').datagrid('getRows');//获得所有行
	if (!rows) return;
	// MZY0144	3070773		2022-11-24
	if ((rows[index].CTLRowID=="")||(rows[index].CTLRowID==undefined))
	{
		messageShow('alert','error','错误提示','保存合同信息后才可以进行预警设置!');
		return;
	}
	var ReadOnly=getElementValue("ReadOnly");
	if (getElementValue("CTStatus")>0) ReadOnly=1;
	// MZY0095	2021-09-15
	var url='dhceq.plat.busswarndays.csp?SourceID='+rows[index].CTLRowID+"&WarnDay="+rows[index].CTLContractArriveDate+"&ReadOnly="+ReadOnly+"&Name="+rows[index].CTLName;
	if (getElementValue("CTContractType")==0) url=url+"&SourceType=75&SubType=94-1";
	if (getElementValue("CTContractType")==1) url=url+"&SourceType=71&SubType=95-1";
	//modified by cjt 20230201 需求号3220213 UI页面改造
	showWindow(url,"预警设置","548px","278px","icon-w-paper","modal","","","small");
}
// MZY0043	2020-08-05
function GetEquipType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLHold2=data.TRowID
	rowData.CTLHold2_ETDesc=data.TName
}
/// Add:QW 20200810 BUG:QW0073 合同撤销 
function BBackData_Clicked()
{
    var CTRowID=getElementValue("CTRowID")
  	var results=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckBuss",CTRowID);
  	
	var result=results.split("^")
	if (result[0]!="0")
	{
		messageShow("","","",result[1])
	}
	else
	{
		messageShow("confirm","","","是否撤回该合同?","",ConfirmBack,DisConfirmOpt);
	}
}
/// Add:QW 20200810 BUG:QW0073 合同撤销 
function ConfirmBack()
{
	if (CTRowID=="")
	{
		messageShow('alert','error','错误提示','没有合同取消!');
		return;
	}
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.Con.BUSContract","BackData",combindata);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow('alert','error','错误提示',RtnObj.Data);
    }
    else
    {
		messageShow("","","","成功撤回!")
		var url="dhceq.con.contract.csp?&RowID="+CTRowID
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	   	window.setTimeout(function(){window.location.href=url},50);
    }
}
//add by wy 2020-9-24 1532207增加业务清屏功能
function BClear_Clicked()
{
		var Type=getElementValue("Type");
		var QXType=getElementValue("QXType");
		var val="&Type="+Type+"&QXType="+QXType+"&ContractType="+getElementValue("CTContractType")+"&AuditType="+getElementValue("AuditType");	//czf 1914903
		var url="dhceq.con.contract.csp?"+val;
		if (getElementValue("CTContractType")==1) url="dhceq.con.contractformaint.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
}
///modfied by ZY0260 20210428
function getBuyLoc(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CLLBuyLocDR=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CLLBuyLocDR_CTLOCDesc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	$("#CTLAction"+"z"+editIndex).hide()
}
///modfied by ZY0260 20210428
function reloadGrid()
{
	$HUI.datagrid("#DHCEQContract",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.Con.BUSContract",
	        	QueryName:"GetContractList",
		        RowID:CTRowID
		},
		columns:Columns
	});
}
///add by ZY0274 20210707 批量增加设备
function batchAddEquip_Click()
{
	/*
	if(getElementValue("SMFromLocDR")==""){
		alertShow("供给部门不能为空!")
		return
	}
	if(getElementValue("SMEquipTypeDR")==""){
		alertShow("管理类组不能为空!")
		return
	}
	*/
	var str=""
	str=str+"&BussType=94"+""
	str=str+"&FromLocDR="+""
	str=str+"&EquipTypeDR="+""
	str=str+"&title="+"保修设备选择"     //Modefied  by zc 2021115  zc0107 title改成取值
	var url="dhceq.em.batchaddequip.csp?"+str;
	showWindow(url,"批量添加设备","","","icon-w-paper","modal","","","middle",insertEquipRow);  
}
/// MZY0100	2288153,2288189		2021-11-18	修正批量返回处理
///add by ZY0274 20210707 批量增加设备
///批量添加设备回调
///copyrows:列表数据数组
function insertEquipRow(copyrows)
{
	var ComponentID="DHCEQContract";
	if ($("#"+ComponentID).datagrid("getRows")[0].CTLSourceType_Desc=="") $("#"+ComponentID).datagrid('deleteRow',0);

	for(i=0;i<copyrows.length;i++)
	{
		var morows = $("#"+ComponentID).datagrid("getRows");
		var index=morows.length;
		var vallist=copyrows[i].TEquipID;
		if (vallist=="") vallist=tkMakeServerCall("web.DHCEQ.EM.BUSStoreMove","GetEQIDs",copyrows[i].TFromLocDR, copyrows[i].TInStockListID);
		var EQRowID=vallist.split(",");
		for(var j=0;j<EQRowID.length;j++)
		{
			for (k=0;k<morows.length;k++)
			{
				if(morows[k].CTLSourceID==EQRowID[j])
				{
					//messageShow('alert','error','提示',"错误信息:"+copyrows[i].TEquipNo+"设备重复!");
					return;
				}
			}
			
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",EQRowID[j]);
			jsonData=jQuery.parseJSON(jsonData);
			if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
			var ObjEquip=jsonData.Data
			$("#"+ComponentID).datagrid('appendRow',{ 
				CTLSourceType:"4",
				CTLSourceType_Desc: "设备",
				CTLSourceID:ObjEquip.EQRowID,
				CTLSourceID_Desc:ObjEquip.EQNo,
				CTLName:ObjEquip.EQName,
				CTLItemDR:ObjEquip.EQItemDR,
				CTLItem:ObjEquip.EQItemDR_MIDesc,
				CTLModelDR:ObjEquip.EQModelDR,
				CTLModelDR_MDesc:ObjEquip.EQModelDR_MDesc,
				CTLManuFactoryDR:ObjEquip.EQManuFactoryDR,
				CTLManuFactoryDR_MFName:ObjEquip.EQManuFactoryDR_MFName,
				CTLQuantityNum:1,
				CTLPriceFee:ObjEquip.EQOriginalFee,
				CTLTotalFee:ObjEquip.EQOriginalFee,
				CTLUnitDR_UOMDesc:ObjEquip.EQUnitDR_UOMDesc,
				CTLHold2:ObjEquip.EQEquipTypeDR,
				CTLHold2_ETDesc:ObjEquip.EQEquipTypeDR_ETDesc,
				CTLRemark:"",
				CTLContractArriveDate:"",
				CTLArriveDate:"",
				CTLArriveQuantityNum:"",
				CTLGuaranteePeriodNum:"",
				CTLBrandDR:"",
				CTLImportFlag:"",
				CTLGuaranteeContent:"",
				CTLMaintCountType:"",
				CTLMaintTimes:"",
				CTLHold1:"",
				CTLHold3:"",
				CTLHold4:"",
				CTLHold5:"",
				CTLBrandDR_BDesc:"",
		     })
		}
	}
}
// MZY0095	2021-09-15
function GetMaintCountType(index,data)
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLMaintCountType=data.TRowID;
	var editor = $('#DHCEQContract').datagrid('getEditor',{index:editIndex,field:'CTLMaintCountType_Desc'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit', editIndex);
	if (CTContractType!=1) bindGridEvent();
}

function clearMaintCountType()
{
	var rowData = $('#DHCEQContract').datagrid('getSelected');
	rowData.CTLMaintCountType="";
	$('#DHCEQContract').datagrid('endEdit',editIndex);
	$('#DHCEQContract').datagrid('beginEdit',editIndex);
}
