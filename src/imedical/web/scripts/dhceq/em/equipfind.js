///hisui改造 add by zc 2018-09-30  jQuery台帐页面hisui改造
Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val) return i;
	}
	return -1;
};
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var nameConditionLimit=1   //Modify By zx 2020-02-20 BUG ZX0076
var conditionFlag=0;  //Modify By zx 2020-02-20 BUG ZX0076
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();
	if (getElementValue("DisableFlag")!=1) initStatusData();	// Mozy0241	1150229	2019-12-25
}
//初始化查询头面板
function initTopPanel()
{
	//数值元素定义onchange事件,可校验有效性
	initNumElement("MinValue^MaxValue");
	initLookUp();
	singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	//initStatusData();			 Mozy0241	1150229	2019-12-25		重复
	defindTitleStyle();
	if (getElementValue("UseLocDR")!="")
    {
	    var UseLoc=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID",'dept',getElementValue("UseLocDR"));
	    setElement("UseLoc",UseLoc)
	}
	initDHCEQEquipList();			//初始化表格
	//InitToolbarForAmountInfo()
	$("#EquipType").lookup({
            onSelect:function(index,rowData){
	            setElement("EquipTypeDR",rowData.TRowID)
                //singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
            },
       });
    //add by csj 20191129 设备属性
	var jsonData=tkMakeServerCall("web.DHCEQCMasterItem","ReturnJsonEquipAttribute")
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
    $("#EquipAttributeList").keywords({
       items:string
    });
}
/// modified by sjh SJH0027 2020-06-12 修改台帐界面中的“账”字为“帐”
function GetStatCat(item)
{
	setElement("StatCat",item.TName);			
	setElement("StatCatDR",item.TRowID); 			
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
}
///add by lmm 2017-06-28 394342 状态下拉框增加全部状态
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '在库'
			},{
				id: '1',
				text: '启用'
			},{
				id: '2',
				text: '停用'
			}]
	});
	//Modify By zx 2020-02-20 BUG ZX0076
	var AdvanceDisFlag = $HUI.combobox('#AdvanceDisFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '非预报废'
			},{
				id: '1',
				text: '预报废'
			}]
	});
}

function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		messageShow('popover','error','提示',"请正确输入数值!")
		//$.messager.popover({msg:"请正确输入数值!",type:'alert'})
		return
	}
}
function initDHCEQEquipList()
{
	var vtoolbar=Inittoolbar();
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",   //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetEquipList",
	        Data:"^InitFlag=Y",	//Modefied by ZY0218 2020-04-10加载界面query不输出	//"^IsOut="+getElementValue("IsOut")+"^IsDisused="+getElementValue("IsDisused")+"^UseLocDR="+getElementValue("UseLocDR")+"^Status="+getElementValue("Status"),	//Modefied by ZY0218 2020-04-10加载界面
	        ReadOnly:getElementValue("ReadOnly"),
	        Ejob:getElementValue("Job"),    //Modified by JYP0019 台帐添加job对多用户进行限制
	    },
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,		//modified by czf 2020-05-14
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:vtoolbar, 
    	//Modify By zx 2020-02-20 BUG ZX0076 背景颜色
    	rowStyler: function(index,row){
			return 'background-color:'+row.TBackgroundColor;
		},
		onDblClickRow:function(rowIndex, rowData)
		{	
			if (rowData.TRowID!=""){
				//add by zx 2018-12-12 弹框样式控制
				var ReadOnly=getElementValue("ReadOnly");
				var ToolBarFlag="1";
				var LifeInfoFlag="1"
				var DetailListFlag="1"
				var winHeight=650;
				if($(document.body).height()<650) winHeight="100%"
				if (ReadOnly=="1")
				{
					ToolBarFlag="0";
					DetailListFlag="0";
					winHeight=450;
					
				}
				var str="dhceq.em.equip.csp?&RowID="+rowData.TRowID+"&ReadOnly="+ReadOnly+"&ToolBarFlag="+ToolBarFlag+"&LifeInfoFlag="+LifeInfoFlag+"&DetailListFlag="+DetailListFlag;
				//Modefied by zc 2018-12-28  zc0048 修改弹窗显示过小
				showWindow(str,"台帐详细界面","","","icon-w-paper","","","","verylarge")    //Modefidy by lmm 2020-06-04 UI
				//Modefidy by zc0046 修改弹窗在不同分辨率弹窗覆盖问题
			}
		},
		onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();
		},
});
}
function Inittoolbar()
{
	var toolbar="" 
	if (getElementValue("ReadOnly")=="")
	{
		toolbar=[{
    			iconCls: 'icon-print',
                text:'批量打印条码',          
                handler: function(){
                     BPrintBar_Click();
                }},
                {
                iconCls: 'icon-export',
                text:'导出',
                handler: function(){
                     BSaveExcel_Click();
                }},
                {
                iconCls: 'icon-set-col',
                text:'导出列设置',
                handler: function(){
                     BColSet_Click();
                }},
                {
                iconCls: 'icon-batch-add',
                text:'批量报废',
                handler: function(){
                     BBatchDisuse_Click();
                }},
                {
                iconCls: 'icon-cal-pen',
                text:'批量操作',
                handler: function(){
	                //add by zx 勾选批量修改台帐信息
                     BBatchUpdate_Click();
                }},	//add by ZY0220 批量调科
                {
                iconCls: 'icon-cal-pen',
                text:'批量调科',
                handler: function(){
                     BBatchStockMove_Click();
                }}]
	}
	else
	{
		toolbar=[{
    			iconCls: 'icon-export',
        		text:'导出',
        		handler: function(){
        		BSaveExcel_Click();
    			}},  //modify by lmm 2020-04-02
    			{
        			iconCls: 'icon-set-col',
        			text:'导出列设置',
        			handler: function(){
       				BColSet_Click();
    			}}]
	}
	return toolbar;
}
/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	var lnk=GetLnk()
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",  //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetEquipList",
	        Data:lnk,
	        ReadOnly:getElementValue("ReadOnly"),
	        Ejob:getElementValue("Job"),       //Modified by JYP0019 台帐添加job对多用户进行限制
	    },
	    onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();
		}
	    });
	selectItems.splice(0,selectItems.length); 
	jQuery('#tDHCEQEquipList').datagrid('unselectAll') 
	InfoStr="";  
}

function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+getElementValue("No");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^CommonName="+getElementValue("CommonName");   //add by wy 2019-3-15 需求850738
	lnk=lnk+"^EquipCatDR="+getElementValue("EquipCatDR");
	lnk=lnk+"^Code="+getElementValue("Code");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	if (getElementValue("IncludeFlag")==true)
		lnk=lnk+"^IncludeFlag=1"
	else 
		lnk=lnk+"^IncludeFlag=0"
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^FundsTypeDR="+getElementValue("FundsTypeDR");
	lnk=lnk+"^LocationDR="+getElementValue("LocationDR");
	lnk=lnk+"^BeginInStockDate="+getElementValue('BeginInStockDate');   
	lnk=lnk+"^EndInStockDate="+getElementValue('EndInStockDate');
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^StatCatDR="+getElementValue("StatCatDR");
	lnk=lnk+"^ProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"^ManuFactoryDR="+getElementValue("ManuFactoryDR");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^InStockNo="+getElementValue("InStockNo");
	lnk=lnk+"^FileNo="+getElementValue("FileNo");
	lnk=lnk+"^ContractNo="+getElementValue("ContractNo");
	lnk=lnk+"^InvoiceNo="+getElementValue("InvoiceNo");
	lnk=lnk+"^StoreMoveNo="+getElementValue("StoreMoveNo");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	lnk=lnk+"^IsDisused="+getElementValue("IsDisused");                ;
	lnk=lnk+"^IsOut="+getElementValue("IsOut");
	lnk=lnk+"^BeginDisuseDate="+getElementValue("BeginDisuseDate");
	lnk=lnk+"^EndDisuseDate="+getElementValue("EndDisuseDate");
	lnk=lnk+"^BeginOutDate="+getElementValue("BeginOutDate");
	lnk=lnk+"^EndOutDate="+getElementValue("EndOutDate");
	lnk=lnk+"^OriginDR="+getElementValue("OriginDR");
	lnk=lnk+"^PurchaseTypeDR="+getElementValue("PurchaseTypeDR");
	lnk=lnk+"^PurposeTypeDR="+getElementValue("PurposeTypeDR");
	lnk=lnk+"^Chk=";	//未打印条码
	if (getElementValue("Chk")==true)
	{
		lnk=lnk+"1";
	} 
	if (getElementValue("CheckRentFlag")==true)
		lnk=lnk+"^CheckRentFlag=1"
	else 
		lnk=lnk+"^CheckRentFlag=0"
	lnk=lnk+"^LeaveFactoryNo="+getElementValue("LeaveFactoryNo");  ///Modefidy by zc 2018-10-23 ZC0040 修复bug727572
	//Modify By zx 2020-02-20 BUG ZX0076
	lnk=lnk+"^ConditionLimit="+nameConditionLimit;
	if (getElementValue("LocIncludeFlag")==true)
		lnk=lnk+"^LocIncludeFlag=1";
	else
		lnk=lnk+"^LocIncludeFlag=0";
	lnk=lnk+"^BeginTransAssetDate="+getElementValue("BeginTransAssetDate");
	lnk=lnk+"^EndTransAssetDate="+getElementValue("EndTransAssetDate");
	lnk=lnk+"^EndNo="+getElementValue("EndNo");
	lnk=lnk+"^AdvanceDisFlag="+getElementValue("AdvanceDisFlag");
	//start by csj 20191129 设备属性查询
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	//add by lmm 2020-04-28 begin
	var EquipAttributeString=""
	if ((SelectType)||(SelectType!=undefined))
	{
		var i=SelectType.length;
		var EquipAttributeString=""
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id
			}else
			{
				EquipAttributeString=EquipAttributeString+getElementValue("SplitNumCode")+SelectType[j].id
			}
		}
	}
	//add by lmm 2020-04-28 end
	lnk=lnk+"^EquipAttributeString="+EquipAttributeString
	lnk=lnk+"^HospitalDR="+getElementValue("HospitalDR"); //add hly 20200430
	lnk=lnk+"^OldNo="+getElementValue("OldNo"); //add hly 20200602
	//end by csj 20191129 设备属性查询
	return lnk
}
function BSaveExcel_Click() //导出
{	
	var vData=GetLnk()
	PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"",100);     //Modified by JYP0019 台帐添加job对多用户进行限制
	return
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)    //modify by lmm 2020-06-02
	//Modefidy by zc0046 修改弹窗在不同分辨率弹窗覆盖问题
	//Modefied by zc0044 2018-11-22 修改弹窗大小
}
//add by lmm 2017-10-19 begin
function BBatchDisuse_Click()
{
	BatchDisuse("");
}
// add by zx 2019-05-30 勾选批量修改台帐信息
function BBatchUpdate_Click()
{
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	var url="dhceq.em.equipmodify.csp?RowIDs="+selectItems;
	showWindow(url,"台帐批量操作","","8row","icon-w-paper","modal","","","small",reloadGrid);    //modify by lmm 2020-06-02 UI
}
//add by lmm 2017-10-19 end
/// modefied by by zc 2017-05-25 ZC0030 begin
function BatchDisuse(BatchRequestFlag) //批量报废申请  //add by lmm 2017-10-19
{
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	
	//messageShow("","","",selectItems)
	if(selectItems=="")
	{
		messageShow('popover','error','提示',"未选择设备报废！")
		//$.messager.popover({msg:"未选择设备报废！",type:'alert'});
		return false;
	}
	var length=selectItems.length;
	var str=""
	var InfoStr=""
	for(i=0;i<selectItems.length;i++)//开始循环
	{
		var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',selectItems[i],'','','Y');
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{	//add by wl 2019-12-13 WL0022 提示信息延时显示
			$.messager.popover({msg:ret[1],type:'alert',timeout:60000});
			return;	//add by csj 20190508
		    if (InfoStr=="")
			{
				InfoStr=selectItems[i];//循环赋值	
			}
			else
			{
				InfoStr=InfoStr+","+selectItems[i]
			}	
		}
		if (str=="")
		{
			str=selectItems[i];//循环赋值	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	//add by lmm 2017-10-11 begin
	if (BatchRequestFlag=="") 
	{
		var BatchRequestFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601004") 
		if (BatchRequestFlag=="") BatchRequestFlag=0   ///Modefidy by zc 2018-10-23  ZC0040 修复bug722411
		if (BatchRequestFlag==3)
		{
			var str='dhceq.process.disusetype.csp?RowID=';
		    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=380,height=380,left=120,top=0')
			return;
		}
	}
	var data = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "BatchDisuseEquipIDs",str,InfoStr,BatchRequestFlag);

	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	data=data.split("^");
	var num=data[0];
	var errmesg=data[1];
	var Info=data[2]
	if (errmesg=="")
	{
		if(Info=="")
		{
			messageShow('popover','info','提示',"批量报废申请成功,生成"+num+"张报废单")
			//$.messager.popover({msg:"批量报废申请成功,生成"+num+"张报废单",type:'info'})
		}
		else
		{
			messageShow('popover','info','提示',"批量报废申请成功,生成"+num+"张报废单,其中"+Info)
			//$.messager.popover({msg:"批量报废申请成功,生成"+num+"张报废单,其中"+Info,type:'info'})
		}
	}
	else
	{
		if (num!="0")
		{
			if(Info=="")
			{
				messageShow('popover','info','提示',"批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败")
				//$.messager.popover({msg:"批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败",type:'info'})
			}
			else
			{
				messageShow('popover','info','提示',"批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败,其中"+Info)
				//$.messager.popover({msg:"批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败,其中"+Info,type:'info'})
			}
		}
		else
		{
			messageShow('popover','error','提示',"批量报废失败")
			//$.messager.popover({msg:"批量报废失败",type:'error'})
		}
	}
	jQuery('#tDHCEQEquipList').datagrid('uncheckAll');
	jQuery('#tDHCEQEquipList').datagrid('unselectAll');
	jQuery('#tDHCEQEquipList').datagrid('reload');
	InfoStr=""
	
}
///打印条码
function BPrintBar_Click()
{
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode&Job='+getElementValue('Job');  //modified by csj 2020-03-01 需求号：1206002
    showWindow(str,"批量打印条码","","7row","icon-w-paper","modal","","","small")  //modify by lmm 2020-06-04 UI
	//Modefidy by zc0046 修改弹窗在不同分辨率弹窗覆盖问题
	//Modefied by zc0044 2018-11-22 修改弹窗大小
}
// 台帐明细菜单栏中显示合计信息
function InitToolbarForAmountInfo() {
	var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"));   //Modified by JYP0019 台帐添加job对多用户进行限制
	$("#sumTotal").html(Data);	
}
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#tDHCEQEquipList').datagrid('selectRecord', selectItems[i]); //根据id选中行 
        }
}

//判断选中记录的ID是否已存在checkedItems这个数组里
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//将选中记录的ID是存储checkedItems这个数组里
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQEquipList').datagrid('getSelections');
	    var rowid=rowData.TRowID;
	    /// modefied by by zc 2017-06-25 ZC0031 begin
	    var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{
		    $.messager.popover({msg:ret[1],type:'alert'});
		    $('#tDHCEQEquipList').datagrid('unselectRow', rowIndex);
		}
		/// modefied by by zc 2017-06-25 ZC0031 end
		if (ret[0]=="0")
		{
        	for (var i = 0; i < row.length; i++) {
            	if (findSelectItem(row[i].TRowID) == -1) {
                	selectItems.push(row[i].TRowID);
            	}
        	}
		}
}
//清楚所有选中记录的ID
function removeAllItem(rows) {
        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//清楚单条选中记录的ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}
/// modefied by by zc 2017-06-25 ZC0031 begin
function BSelectAll_Click() //全选
{
	messageShow('popover','alert','提示',"当前页面未被选中的设备被其他业务单据占用")
	//jQuery.messager.alert("提示","当前页面未被选中的设备被其他业务单据占用");  /// modefied by by zc 2017-08-29 ZC0032
	jQuery('#tDHCEQEquipList').datagrid('selectAll');
}
/// modefied by by zc 2017-06-25 ZC0031 begin
function BUnSelectAll_Click() //取消全选
{
	selectItems.splice(0,selectItems.length);
	jQuery('#tDHCEQEquipList').datagrid('unselectAll');
}
//add by zx 2019-06-01 批量修改后刷新列表数据
function reloadGrid()
{
	$('#tDHCEQEquipList').datagrid('reload');
}
//Modify By zx 2020-02-20 BUG ZX0076
$("#ChooseCondition").popover({trigger:'manual',placement:'bottom',content:'<table><tr><td><input type="radio" name="condition" value="2"></td><td>等于</td></tr><tr><td><input type="radio" name="condition" value="1" checked></td><td>包含</td></tr><tr><td><input type="radio" name="condition" value="0"></td><td>不含</td></tr></table>'});

//Modify By zx 2020-02-20 BUG ZX0076
$("#ChooseCondition").click(function(){
	$("#ChooseCondition").popover('show');
	if(conditionFlag==0)
	{
		$('input[name="condition"]').click(function(){
	   		nameConditionLimit=$("input[name='condition']:checked").val();
	   		$("#ChooseCondition").popover('hide');
	   		$("#ChooseCondition").text($(this).parent().next().text());
		});
	}
	conditionFlag=1;
});
//add by ZY0218 批量调科
function BBatchStockMove_Click()
{
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	var url="dhceq.em.equipstockmove.csp?RowIDs="+selectItems;
	showWindow(url,"台帐批量调科",420,500,"icon-w-paper","modal","","","",reloadGrid); 
}