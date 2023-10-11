var editFlag="undefined";
var PRRowID=getElementValue("PRRowID");
var Columns=getCurColumnsInfo('EM.G.PayRequest.PayRecord','','','')
var oneFillData={}

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("PayRequest");
	defindTitleStyle();
	initButtonWidth();
	initLookUp(); //初始化放大镜
	initPRPayFromType();
	setElement("PRPayFromType","1");
	initPRSourceType();
	initPRPayMode();
    initButton(); //按钮初始化
	initPanelHeaderStyle();   //add by mwz 20230427 mwz0070
	initApproveButtonNew();
	initButtonColor();
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-submit'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Clicked);
    fillData(); //数据填充
    setEnabled(); //按钮控制
	setRequiredElements("PRMakeDate^PRPayFromType^PRSourceType^PRProviderDR_VDesc^PRAccountDate")
	payRecordReload();
	changeColumnOption()
};
function BFind_Clicked()
{
	payRecordReload()
}
function BCancelSubmit_Clicked()
{
	UpdateData(0)
}
function BAudit_Clicked()
{
	UpdateData(2)
}
function BSubmit_Clicked()
{
	UpdateData(1)
}
function UpdateData(vStatus)
{
	if (PRRowID=="")
	{
		alertShow("无付款申请单可操作!");
		return;
	}
	var rows = $('#DHCEQPayRecord').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		var PRPayFee=parseFloat(oneRow.PRPayFee)
		var TNotPayAmount=parseFloat(oneRow.TNotPayAmount)
		if ((PRPayFee>TNotPayAmount)||(PRPayFee<0))
		{
			messageShow("","","","第"+(i+1)+"行付款金额有误!")
			return
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","UpdateData",PRRowID,vStatus);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 弹框异步,回调函数方式处理 BUG ZX0082-->
		/*messageShow("","","","操作成功!");
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"操作成功!",'',function(){reloadPage(jsonData.Data);});
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (PRRowID=="")
	{
		alertShow("无付款申请单可删除!");
		return;
	}
	var truthBeTold = window.confirm(t[-9203]);
	if (!truthBeTold) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","SaveData",PRRowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 弹框异步,回调函数方式处理 BUG ZX0082-->
		/*messageShow("","","","操作成功!");
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"操作成功!",'',function(){reloadPage("");});
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData.Data);
		return
    }
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
		totlefeeChange()
	}
	//检测必填项
	if (checkMustItemNull("")) return
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var noListFlag="Y"
	var rows = $('#DHCEQPayRecord').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			var PRPayPercent=parseFloat(oneRow.PRPayPercent)
			var PRPayFee=parseFloat(oneRow.PRPayFee)
			var TNotPayAmount=parseFloat(oneRow.TNotPayAmount)
			if (oneRow.PRItem=="")
			{
				messageShow("","","","第"+(i+1)+"行收付款项目为空!");
				return
			}
			else if (oneRow.PRQuantity=="")
			{
				messageShow("","","","第"+(i+1)+"行数量为空!");
				return
			}
			else if (oneRow.PRPrice=="")
			{
				messageShow("","","","第"+(i+1)+"行原值为空!");
				return
			}
			else if (oneRow.PRPayFee=="")
			{
				messageShow("","","","第"+(i+1)+"行收付款金额为空!");
				return
			}
			else if ((oneRow.PRPayPercent!="")&&((PRPayPercent>100)||(PRPayPercent<0)))
			{
				messageShow("","","","第"+(i+1)+"行付款比例有误!")
				return
			}
			else if ((PRPayFee>TNotPayAmount)||(PRPayFee<0))
			{
				messageShow("","","","第"+(i+1)+"行付款金额有误!")
				return
			}
			if (oneRow.PRSourceType!=getElementValue("PRSourceType"))
			{
				messageShow("","","","第"+(i+1)+"行明细业务类型与总单业务类型不一致!");
				return
			}
			noListFlag="N"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData
		}
	}
	
	if (noListFlag=="Y")
	{
		messageShow("","","","付款申请单无付款明细不能保存!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		<!--Modify by zx 2020-03-31 弹框异步,回调函数方式处理 BUG ZX0082-->
		/*messageShow("","","","操作成功!");
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var Type=getElementValue("Type");
		var val="&PRRowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
		url="dhceq.em.payrequest.csp?"+val
	    window.location.href= url;*/
	    messageShow('','','',"操作成功!",'',function(){reloadPage(jsonData.Data);});
	}
	else
    {
	    messageShow("","","","错误信息:"+jsonData.Data);
		return
    }
}
function payRecordReload()
{
	var PRSourceType=getElementValue("PRSourceType")
	var PRProviderDR=getElementValue("PRProviderDR")
	var PRStatus=getElementValue("PRStatus")
	var Type=getElementValue("Type")
	var PRLocDR=getElementValue("PRLocDR")
	$HUI.datagrid("#DHCEQPayRecord",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSPayRequest",
	        	QueryName:"GetPayRecord",
				vPayRequestDR:PRRowID,
				vSourceType:PRSourceType,
				vProviderDR:PRProviderDR,
				vLocDR:PRLocDR
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
        toolbar:[
              {iconCls: 'icon-add',text:'新增',id:'add',handler: function(){insertRow();}},
              {iconCls: 'icon-cancel',text:'删除',id:'delete',handler: function(){deleteRow();}}
              ],
	    onClickRow: function (rowIndex,rowData) {//单击选择行编辑
	    	if (((PRStatus=="")||(PRStatus==0))&&(Type==0))
	    	{
		    	if (editFlag!="undefined")
		    	{
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);
	            }
	            jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	            payPercentOnChange(rowIndex)
	            payFeeOnChange(rowIndex)
	            payHold3Change(rowIndex)	//add by csj 2020-04-07 质保金比例 
	    	}
        },
		onLoadSuccess:function(){toolbarenable()}
	});
}
function toolbarenable()
{
    ///modified by ZY20230307 bug:3261903
    var rows = $('#DHCEQPayRecord').datagrid('getRows');
    var totalQuantityNum = 0;
    var totalTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
        var colValue=rows[i]["PRQuantity"];
        if (colValue=="") colValue=0;
        totalQuantityNum += parseFloat(colValue);
        colValue=rows[i]["TAllAmount"];
        if (colValue=="") colValue=0;
        totalTotalFee += parseFloat(colValue);
    }
    var lable_innerText='总数量:'+totalQuantityNum+'&nbsp;&nbsp;&nbsp;总金额:'+totalTotalFee.toFixed(2);
    $("#sumTotal").html(lable_innerText);
    
    
    disableElement("add",true);
    disableElement("delete",true);
    if ((getElementValue("PRPayFromType")==9)&&((getElementValue("PRStatus")==0)||(getElementValue("PRStatus")==""))&&(getElementValue("Type")==0))
    {
        disableElement("add",false);
        disableElement("delete",false);
    }
}
function insertRow()
{
	alertShow("新增")
}
function deleteRow()
{
	alertShow("删除")
}
function totlefeeChange()
{
	var AllAmount=0
	var rows = jQuery("#DHCEQPayRecord").datagrid('getRows');
	if(rows.length<=0) return "";
	for(var i=0;i<rows.length;i++)
	{
		var Opt=$('#DHCEQPayRecord').datagrid('getRows')[i]['Opt']
		var PRPayFee=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[i]['PRPayFee']);
		if (Opt=="Y")
		{
			AllAmount=AllAmount+PRPayFee
		}
	}
	setElement("PRTotalFee",AllAmount)
	setElement("PRChineseFee",ChineseNum(AllAmount))
}
function payFeeOnChange(rowIndex)
{
    //付款金额OnChange
    var NotPayAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TNotPayAmount']); 
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayFee' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>NotPayAmount)))
                {
	                messageShow("","","","请正确输入付款金额");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                var PPed=$('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayPercent' });
	                jQuery(PPed.target).val((newvalue/NotPayAmount*100).toFixed(2))
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}
function payPercentOnChange(rowIndex)
{
    //付款比例OnChange
    var NotPayAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TNotPayAmount']);
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayPercent' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>100)))
                {
	                messageShow("","","","请正确输入付款比例");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                var PFed=$('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRPayFee' });
	                jQuery(PFed.target).val((NotPayAmount*newvalue/100).toFixed(2))
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}

//add by csj 2020-04-07 质保金比例
function payHold3Change(rowIndex)
{
    //质保金比例OnChange
    var AllAmount=parseFloat($('#DHCEQPayRecord').datagrid('getRows')[rowIndex]['TAllAmount']);
    var ed = $('#DHCEQPayRecord').datagrid('getEditor', { index: rowIndex, field: 'PRHold3' });
    $(ed.target).numberbox({
        precision:"2",
        onChange: function (newvalue,oldvalue) 
        {
            if (newvalue!=oldvalue)
            {
                if ((newvalue!="")&&((newvalue<0)||(newvalue>100)))
                {
	                messageShow("","","","请正确输入质保金比例");
	                jQuery(ed.target).val("")
	                return
                }
                if (newvalue!="")
                {
					jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
					jQuery("#DHCEQPayRecord").datagrid('beginEdit', rowIndex);
	                jQuery(ed.target).val(newvalue)
	                $('#DHCEQPayRecord').datagrid('getRows')[rowIndex].PRHold4=(AllAmount*newvalue/100).toFixed(2)	//PRHold4 质保金额
	                jQuery("#DHCEQPayRecord").datagrid('endEdit', rowIndex);
                }
            }
        }
    });
    totlefeeChange()
}

function checkboxOnChange(Opt,rowIndex)
{
	var row = jQuery('#DHCEQPayRecord').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (Opt==key)
			{
				if (((val=="N")||val==""))
				{
					row.Opt="Y"
					totlefeeChange()
				}
				else
				{
					row.Opt="N"
				}
			}
		})
	}
}
function changeColumnOption()
{
	var PRPayType=$("#DHCEQPayRecord").datagrid('getColumnOption','PRPayType');	
	PRPayType.editor={type: 'combobox',options:{
					data: [{"id":"0","text":"全款"},{"id":"1","text":"预付款"},{"id":"2","text":"期款"},{"id":"3","text":"尾款"}],
                    valueField: "id",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayType'});
						jQuery(ed.target).val(option.id);
						jQuery(ed.target).combobox('setValue', option.text);
						if (option.id=="0")
						{
							var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayPercent'});
							jQuery(ed.target).val(100)
							var ed=jQuery("#DHCEQPayRecord").datagrid('getEditor',{index:editFlag,field:'PRPayFee'});
							jQuery(ed.target).val(parseFloat($('#DHCEQPayRecord').datagrid('getRows')[editFlag]['TNotPayAmount']))
							totlefeeChange()
						}
						jQuery("#DHCEQPayRecord").datagrid('endEdit', editFlag);
						//jQuery("#DHCEQPayRecord").datagrid('beginEdit', editFlag);	// MZY0123	2665275		2022-05-12
					}
		}};
}
function fillData()
{
	if (PRRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetOnePayRequest",PRRowID,ApproveRoleDR,Action,Step)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
}
function setEnabled()
{
	var PRStatus=getElementValue("PRStatus")
	var Type=getElementValue("Type")
	if (PRStatus=="")
	{
		disableElement("BSubmit",true)
		disableElement("BCancelSubmit",true)
		disableElement("BDelete",true)
		disableElement("BAudit",true)
		disableElement("BPicture",true); // add By QW20210422 BUG:QW0099 增加图片上传
	}
	if (PRStatus=="0")
	{
		disableElement("BCancelSubmit",true)
		disableElement("BAudit",true)
	}
	if (PRStatus=="1")
	{
		disableElement("BFind",true)
		disableElement("BSave",true)
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
	}
	if (PRStatus=="2")
	{
		disableElement("BFind",true)
		disableElement("BSave",true)
		disableElement("BSubmit",true)
		disableElement("BCancelSubmit",true)
		disableElement("BDelete",true)
		disableElement("BAudit",true)
	}
	if (Type=="0")
	{
		hiddenObj("BCancelSubmit",true)
		hiddenObj("BAudit",true)
	}
	if (Type=="1")
	{
		hiddenObj("BFind",true)
		hiddenObj("BSave",true)
		hiddenObj("BSubmit",true)
		hiddenObj("BDelete",true)
	}
}
function initPRPayMode()
{
	var PRPayMode = $HUI.combobox('#PRPayMode',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '现金'},{id: '2',text: '支票'},{id: '3',text: '汇款'}],
		onSelect : function(){}
	});
}

function CustomData(OneCustomStr)
{
	var Str=OneCustomStr.split("^")
	this.id=Str[0]
	this.text=Str[1]
}
function initPRSourceType()
{
	//{id:'11',text:'合同总单'},{id:'12',text:'合同明细'},{id:'13',text:'验收明细'},{id:'14',text:'入库明细'},{id:'15',text:'首次出库明细(不推荐)'},{id:'16',text:'退货明细'}
	//{id:'21',text:'维保合同总单'},{id:'22',text:'维保合同明细'}
	//{id:'31',text:'配件入库'},{id:'32',text:'首次配件出库(不推荐)'},{id:'33',text:'配件退货'}
	//{id:'41',text:'调账'}
	//{id:'51',text:'保养'},{id:'52',text:'检查'},{id:'53',text:'维修'}
	var PRPayFromType=getElementValue("PRPayFromType")
	var PRSourceTypeData=[]
	if (PRPayFromType=="1")	{PRSourceTypeData=[{id:'11',text:'合同总单'},{id:'12',text:'合同明细'},{id:'13',text:'验收明细'},{id:'14',text:'入库明细'},{id:'16',text:'退货明细'}]}
	else if (PRPayFromType=="2"){PRSourceTypeData=[{id:'21',text:'维保合同总单'},{id:'22',text:'维保合同明细'}]}
	else if (PRPayFromType=="3"){PRSourceTypeData=[{id:'31',text:'配件入库'},{id:'33',text:'配件退货'}]}
	else if (PRPayFromType=="4"){PRSourceTypeData=[{id:'41',text:'调账'}]}
	else if (PRPayFromType=="5"){PRSourceTypeData=[{id:'51',text:'保养'},{id:'52',text:'检查'},{id:'53',text:'维修'}]}
	else if (PRPayFromType=="9"){
		var PRSourceTypeStr=tkMakeServerCall("web.DHCEQ.EM.BUSPayRequest","GetPayCostType")
		var PRSourceTypeCount=PRSourceTypeStr.split("@")
		for (var i=0; i<PRSourceTypeCount.length; i++)
		{
			var OneInfo=new CustomData(PRSourceTypeCount[i])
			PRSourceTypeData.push(OneInfo)
		}
	}
	var PRSourceType = $HUI.combobox('#PRSourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:PRSourceTypeData,
		onSelect : function(){}
	});
}
function initPRPayFromType()
{
	var PRPayFromType = $HUI.combobox('#PRPayFromType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id: '1',text: '新购设备'}
//			{id: '2',text: '维保合同'},
//			{id: '3',text: '配件'},
//			{id: '4',text: '调账付款'},
//			{id: '5',text: '维护费用'},
//			{id: '9',text: '其他费用'}
			],
		onSelect : function(){
			initPRSourceType()
			toolbarenable()
			}
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="PRProviderDR_VDesc")
	{
		setElement("PRProviderDR",rowData.TRowID)
		setElement("PRBank",rowData.TBank)
		setElement("PRBankAccount",rowData.TBankNo)
	}
}

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

/// add by zx 2020-03-31 BUG ZX0082
/// 描述: 界面刷新处理
/// 入参: rowID 付款申请RowID
function reloadPage(rowID)
{
	var WaitAD=getElementValue("WaitAD"); 
	var QXType=getElementValue("QXType");
	var Type=getElementValue("Type");
	//if (rowID=="") Type="";
	var val="&PRRowID="+rowID+"&WaitAD="+WaitAD+"&QXType="+QXType+"&Type="+Type;
	url="dhceq.em.payrequest.csp?"+val
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}
 // add By QW20210422 BUG:QW0099 增加图片上传
function BPicture_Clicked()
{
	var ReadOnly=getElementValue("ReadOnly")
	var PicQXType=getElementValue("QXType") 
	var Status=getElementValue("PRStatus");
	if (Status!=0) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=76&CurrentSourceID='+getElementValue("PRRowID")+'&Status='+Status+'&ReadOnly='+ReadOnly+'&PicQXType='+PicQXType;
	showWindow(str,"图片信息","","","icon-w-paper","modal","","","large");
}
