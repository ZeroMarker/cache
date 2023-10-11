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
var equipTypeObj;  //modified by LMH 20220916 2915348 定义全局变量,使用时未定义三处使用
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
	initUserInfo(); 	//add by csj 2020-08-19 
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
	setElement("LocIncludeFlag",true)  //modify by jyp 2021-11-15
	setElement("IncludeFlag",true)    //modify by jyp 2021-11-15
	
	//数值元素定义onchange事件,可校验有效性
	initNumElement("MinValue^MaxValue");
	initLookUp();
	initIdleFlagData();
	initIsIFB();
	//modify by cjc 2022-07-26 2772683
	singlelookup("StatCat","PLAT.L.StatCat",[{name:"StatCat",type:1,value:"StatCat"},{name:"EquipTypeDR",type:5,value:"EquipTypeDR"},{name:"EquipTypeFlag",type:2,value:""},{name:"FinanceTypeDR",type:2,value:""}],GetStatCat)//[{name:"StatcatDR",type:1,value:"StatcatDR"}]
	initLocDisplay("UseLoc","UseLocDRStr");	//初始化科室，根据参数控制显示放大镜或下拉树 czf 2022-07-04
	//initButtonWidth();  modify by txr 2023-03-24
	jQuery('#BFind').on("click", BFind_Clicked);
	//initStatusData();			 Mozy0241	1150229	2019-12-25		重复
	defindTitleStyle();
	if (getElementValue("UseLocDR")!="")
	{
	    var UseLoc=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID",'dept',getElementValue("UseLocDR"));
	    setElement("UseLoc",UseLoc)
	}
	//modify by cjc 2022-07-26 2772683
	singlelookup("StandardItem","Plat.L.StandardItem",[{name:"EquipTypeDR",type:5,value:"EquipTypeDR"},{name:"StatCatDR",type:4,value:"StatCatDR"},{name:"Name",type:1,value:"StandardItem"},{"name":"EquipCatDR","type":"4","value":"EquipCatDR"}],GetStandardItem)
	initDHCEQEquipList();			//初始化表格
	//InitToolbarForAmountInfo()
    //modified by LMH 20220916 2915348 已设置管理类组为下拉框选择，此处注释掉 begin-->
    /*$("#EquipType").lookup({
            onSelect:function(index,rowData){
                setElement("EquipTypeDR",rowData.TRowID)
                //singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
            },
       });*/
     //modified by LMH 20220916 2915348 end<--
    //add by csj 20191129 设备属性
	var jsonData=tkMakeServerCall("web.DHCEQCMasterItem","ReturnJsonEquipAttribute")
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
    $("#EquipAttributeList").keywords({
	    onUnselect:function(v){			//czf 2022-04-14 begin
		    initEquipAttributeCat()
		},
	    onSelect:function(v){
		    initEquipAttributeCat()
		},
		items:string
    });
	initEquipAttributeCat();	//设备属性分类 czf 2022-04-14 end
    //add by ZY0305 20220617 2724602
    initAppendFileInclude();            //初始化电子资料类型
    initEquipType();    //add by LMH 20220916 2915348 初始化管理类组为下拉框，避开判断条件，解决查询按钮失效的问题
}


//add by cjc 2022-0726 2772683 lookupHandle中type为5时调用，返回字符串
function getParam(ID)
{	
	if (ID=="EquipTypeDR"){return equipTypeObj.getValues().toString()}
}


function initLocDisplay(ElementName,ElementID)
{
	var LocDisplay=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","991110")
	if (LocDisplay=="1")
	{
		var LocTree=$.m({
		    ClassName:"web.DHCEQ.Plat.LIBTree",
		    MethodName:"GetTreeMapTreeStr"
		},false);
		
		var cbtree = $HUI.combotree('#'+ElementName,{
			panelWidth:400,
			panelHeight:400,
			editable:true,
			multiple:true,
			cascadeCheck:false,			// MZY0155	3266606		2023-03-13	禁止联动选择
			onSelect:function(node){
				var id = node.id;
				/*
				var isEndLoc = tkMakeServerCall("web.DHCEQCTreeMap","ISEndLoc",id);
				if (isEndLoc!=1){
					messageShow("","","","当前科室不是末级科室!");
					return false;
				}
				*/
			},
			onChange: function (newValue, oldValue) {
				setElement(ElementID,newValue.toString());
			}
			});
		cbtree.loadData(JSON.parse(LocTree));
	}
	else
	{
		var params=[{name:'Type',type:'4',value:'QXType'},{name:'LocDesc',type:'4',value:ElementName}];
        singlelookup(ElementName,"PLAT.L.Loc",params,"");
	}
}

/// modified by sjh SJH0027 2020-06-12 修改台帐界面中的“账”字为“帐”
function GetStatCat(item)
{
	setElement("StatCat",item.TName);			
	setElement("StatCatDR",item.TRowID); 			
}
function setSelectValue(vElementID,item)
{
    //modified by ZY 2938424 20220915
    if(vElementID=="OriginDR_ODesc") {setElement("OriginDR",item.TRowID)}
	else if(vElementID=="StandardItemDR_MIDesc") {setElement("StandardItemDR",item.TRowID)}	// MZY0153	3244652		2023-02-20
    else  setElement(vElementID+"DR",item.TRowID)
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
	
	//add zyq 2022-10-25 begin
	var FliterPrice=$HUI.combobox('#FliterPrice',{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '1',
				text: '0~1000(不含)'
			},{
				id: '2',
				text: '1000~1万(不含)'
			},{
				id: '3',
				text: '1万~10万(不含)'
			},{
				id: '4',
				text: '10万~100万(不含)'
			},{
				id: '5',
				text: '100万及以上'
			}],
		onSelect:function(data){
			switch(data.id)
			{
			    case '1':
			        setElement("MinValue","");
			        setElement("MaxValue",1000);
			        break;
			    case '2':
			        setElement("MinValue",1000);
			        setElement("MaxValue",10000);
			        break;
			    case '3':
			        setElement("MinValue",10000);
			        setElement("MaxValue",100000);
			        break;
			    case '4':
			        setElement("MinValue",100000);
			        setElement("MaxValue",1000000);
			        break;
			    case '5':
			        setElement("MinValue",1000000);
			        setElement("MaxValue","");
			        break;
			    default:
			        setElement("MinValue","");
			        setElement("MaxValue","");
			}
		}
	});
	//add zyq 2022-10-25 end
	//Modify By zx 2020-02-20 BUG ZX0076
	var AdvanceDisFlag = $HUI.combobox('#AdvanceDisFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '正常'		//modified by czf 20200911 begin CZF0127
			},{
				id: '1',
				text: '报废提交'
			},{
				id: '2',
				text: '预报废'		//modified by czf 20200911 end CZF0127
			}]
    });
   	var DisYearFlag = $HUI.combobox('#DisYearFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '未到报废期'
			},{
				id: '1',
				text: '到期未报废'
			},{
				id: '2',
				text: '到期报废中'
			}]
	});
	//Modifed By zc0133 2023-4-20 定义年限类型 begin
	var UsedYearType = $HUI.combobox('#UsedYearType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '1',
				text: '年限内'		
			},{
				id: '2',
				text: '年限外'
			}]
	});
	//Modifed By zc0133 2023-4-20 定义年限类型 end
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
	    //sortOrder: 'desc', //add By QW20220414
	    //sortName: 'TTransAssetDate', //add By QW20220414
	    idField:'TRowID',
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,		//modified by czf 2020-05-14
		//nowrap:false,		//czf 2022-09-21 自适应行高
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:vtoolbar, 
    	//Modify By zx 2020-02-20 BUG ZX0076 背景颜色
    	rowStyler: function(index,row){
			//return 'background-color:'+row.TBackgroundColor;
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
				showWindow(str,"台账详细界面","","","icon-w-paper","","","","verylarge"); 
			}
		},
		onLoadSuccess: function (data) {
			changeToolbarByRight();			//根据权限改变工具栏按钮显示 czf 2020-09-21 1528642
			InitToolbarForAmountInfo();
			if (getElementValue("IsOut")!="Y")			//czf 2022-06-08
			{
				$("#tDHCEQEquipList").datagrid("hideColumn", "TOutToDept");
			}
		},
		onCheckAll:function(rows){
			$.each(rows,function(rowIndex,item){
				var rowData = rows[rowIndex];
				addselectItem(rowIndex,rowData);
			})
        },
        onCheck:function(rowIndex,rowData){  
            addselectItem(rowIndex,rowData);  
        },
        onUncheckAll:function(rows){
	        $.each(rows,function(rowIndex,item){
				var rowData = rows[rowIndex];
				removeSingleItem(rowIndex,rowData);
			}) 
        },
        onUncheck:function(rowIndex,rowData){  
            removeSingleItem(rowIndex,rowData);  
        },
		onSelect:function(rowIndex,rowData){addselectItem(rowIndex,rowData);},
		
});
}
function Inittoolbar()
{
	var toolbar="" 
	toolbar=[{				//modified by czf 1528642 begin
		id:'BPrintBar',
		iconCls: 'icon-print',
        text:'批量打印条码',          
        handler: function(){
             BPrintBar_Click();
        }},
        {
        id:'BSaveExcel',
        iconCls: 'icon-export',
        text:'导出',
        handler: function(){
             BSaveExcel_Click();
        }},
        {
        id:'BSaveAffixExcel',
        iconCls: 'icon-export-paper',
        text:'导出(包含附件)',
        handler: function(){
             BSaveAffixExcel_Click();
        }},
        {
        id:'BColSet',
        iconCls: 'icon-set-col',
        text:'导出列设置',
        handler: function(){
             BColSet_Click();
        }},
        {
        id:'BBatchDisuse',
        iconCls: 'icon-mutpaper-x',
        text:'批量报废',
        handler: function(){
             BBatchDisuse_Click();
        }},
        {
        id:'BBatchUpdate',
        iconCls: 'icon-mtpaper-add',
        text:'批量操作',
        handler: function(){
             BBatchUpdate_Click();
        }},
        {
        id:'BBatchStockMove',
        iconCls: 'icon-doctor-green-pen',
        text:'批量调科',
        handler: function(){
             BBatchStockMove_Click();
        }},
        {
        id:'BBatchOutStock',
        iconCls: 'icon-paper-minus',
        text:'批量减少',
        handler: function(){
             BBatchOutStock_Click();      
        }
    }]
	return toolbar;
}

///add by czf 1528642
///根据权限修改按钮状态
function changeToolbarByRight()
{
	var ReadOnly=getElementValue("ReadOnly");
	var Status=getElementValue("Status");
	var IsOut=getElementValue("IsOut");
	var IsDisused=getElementValue("IsDisused");
	var QXType=getElementValue("QXType");
	if (ReadOnly=="1")
	{
		hiddenObj("BPrintBar",true);
		hiddenObj("BBatchDisuse",true);
		hiddenObj("BBatchStockMove",true);
		hiddenObj("BBatchOutStock",true);
		
		if (QXType=="0")
		{
			if ((Status=="2")||(IsOut=="Y")||(IsDisused="Y"))	//停用台帐、退货减少台帐、报废台帐不显示按钮
			{
				hiddenObj("BBatchUpdate",true);
			}
		}
	}
}
/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	removeAllItem();	//选择行初始化为空
	var lnk=GetLnk();
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
			changeToolbarByRight();			//根据权限改变工具栏按钮显示 czf 2020-09-21 1528642
			InitToolbarForAmountInfo();
			if (getElementValue("IsOut")!="Y")			//czf 2022-06-08
			{
				$("#tDHCEQEquipList").datagrid("hideColumn", "TOutToDept");
			}
		}
	});
	//selectItems.splice(0,selectItems.length); 
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
	if(document.getElementById("EquipType")) //modify by zyq 2023-03-16 3277952
	{
		lnk=lnk+"^EquipTypeDR="+$("#EquipType").combogrid('getValues').toString();//getElementValue("EquipTypeDR"); //Modify By CJC 2022-07-15 需求2772683
	}
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
	lnk=lnk+"^IsDisused="+getElementValue("IsDisused");
	lnk=lnk+"^IsOut="+getElementValue("IsOut");
	lnk=lnk+"^BeginDisuseDate="+getElementValue("BeginDisuseDate");
	lnk=lnk+"^EndDisuseDate="+getElementValue("EndDisuseDate");
	lnk=lnk+"^BeginOutDate="+getElementValue("BeginOutDate");
	lnk=lnk+"^EndOutDate="+getElementValue("EndOutDate");
	lnk=lnk+"^OriginDR="+getElementValue("OriginDR");
	lnk=lnk+"^PurchaseTypeDR="+getElementValue("PurchaseTypeDR");
	lnk=lnk+"^PurposeTypeDR="+getElementValue("PurposeTypeDR");
	lnk=lnk+"^IdleFlag="+getElementValue("IdleFlag")
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
				EquipAttributeString=EquipAttributeString+":"+SelectType[j].id  //getElementValue("SplitNumCode")//Modified By QW20210416 BUG:QW0097 修正传参错误
			}
		}
	}
	lnk=lnk+"^EquipAttributeString="+EquipAttributeString;
	lnk=lnk+"^HospitalDR="+getElementValue("HospitalDR");
	lnk=lnk+"^OldNo="+getElementValue("OldNo"); 
	lnk=lnk+"^ModelDR="+getElementValue("ModelDR");
	lnk=lnk+"^StandardItemDR="+getElementValue("StandardItemDR");	//czf 2021-12-14
	var EquipAttributeStringCat=""
	if ($("#IHTDesc").length>0) EquipAttributeStringCat=$("#IHTDesc").combogrid("getValues");	//czf 2022-04-14
	EquipAttributeStringCat=EquipAttributeStringCat.toString();
	lnk=lnk+"^EquipAttributeStringCat="+EquipAttributeStringCat;
	//add by ZY0305 20220617 2724602
	if(document.getElementById("AppendFileInclude")) //modify by zyq 2023-03-16 3277952
	{
		lnk=lnk+"^AppendFileInclude="+$("#AppendFileInclude").combogrid("getValues");
	}
		
	lnk=lnk+"^UseLocDRStr="+getElementValue("UseLocDRStr");
	lnk=lnk+"^FilterFlag="+getElementValue("FilterFlag");
	lnk=lnk+"^RegisterNo="+getElementValue("RegisterNo");
	lnk=lnk+"^Model="+getElementValue("Model");
	lnk=lnk+"^ConfigFlag=";	//是否包含附属设备
	if (getElementValue("ConfigFlag")==true)
	{
		lnk=lnk+"1";
	}
	lnk=lnk+"^IsIFB="+getElementValue("IsIFB");	//FX 2022-9-20
	lnk=lnk+"^HasConfigLicence=";
	if (getElementValue("HasConfigLicence")==true)
	{
		lnk=lnk+"1";
	}
	lnk=lnk+"^CheckUserDR="+getElementValue("CheckUserDR"); //add by zyq 2023-02-08
	lnk=lnk+"^DisYearFlag="+getElementValue("DisYearFlag");		//到期状态查询
	lnk=lnk+"^UsedYearType="+getElementValue("UsedYearType");  //add by zc0133 2023-04-12 年限类型查询
    // MZY0160	3467203		2023-05-09
    lnk=lnk+"^BeginStoreMoveDate="+getElementValue('BeginStoreMoveDate');
	lnk=lnk+"^EndStoreMoveDate="+getElementValue('EndStoreMoveDate');

	return lnk
}
function BSaveExcel_Click() //导出
{	
	//Modefied by zc0093  润乾导出修改 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		var Rows = $('#tDHCEQEquipList').datagrid('getRows');
		var RowCount=Rows.length;
		if(RowCount<=0){
			messageShow("","","","没有数据!")
			return;
		}
		//add by mwz 20220418 mwz0060 begin
		if (!CheckColset("Equip"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		//add by mwz 20220418 mwz0060 end
		var url="dhccpmrunqianreport.csp?reportName=DHCEQEquipExport.raq&CurTableName=Equip&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		var vData=GetLnk()
		PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"EquipList",100);	// MZY0149	3076883		2023-01-09
	}
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	showWindow(url,"导出列设置","","","icon-w-paper","","","","large");		// MZY0116	2524685		2022-03-14
}
//add by lmm 2017-10-19 begin
function BBatchDisuse_Click()
{
	BatchDisuse("");
}
// add by zx 2019-05-30 勾选批量修改台帐信息
function BBatchUpdate_Click()
{
	/*
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	*/
	if(selectItems.toString()=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	var url="dhceq.em.equipmodify.csp?RowIDs="+selectItems.toString()+"&QXType="+getElementValue("QXType"); //Modify by zx 2020-08-18  ZX0102 增加权限参数
	showWindow(url,"台账批量操作","","10row","icon-w-paper","modal","","","small",reloadGrid);	// MZY0153	3244481		2023-02-20
}
//add by lmm 2017-10-19 end
/// modefied by by zc 2017-05-25 ZC0030 begin
function BatchDisuse(BatchRequestFlag) //批量报废申请  //add by lmm 2017-10-19
{
	// modfied by ZY0306 20220711  台帐选择行取值从数组中取
	/*
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	*/
	if(selectItems.toString()=="")
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
			$.messager.popover({msg:ret[1],type:'alert',timeout:3000});
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
	//selectItems.splice(0,selectItems.length);
	//add by lmm 2017-10-11 begin
	if (BatchRequestFlag=="") 
	{
		var BatchRequestFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601004") 
		if (BatchRequestFlag=="") BatchRequestFlag=0   ///Modefidy by zc 2018-10-23  ZC0040 修复bug722411
		if (BatchRequestFlag==3)
		{
			var str='dhceq.process.disusetype.csp?RowID=';
		    //showWindow(str,"批量报废",420,500,"icon-w-paper","modal","","","",reloadGrid);
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				str += "&MWToken="+websys_getMWToken()
			}
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
	reloadGrid();
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
    //modified by ZY 20221011 修改合计行取值位置
    //var Data = tkMakeServerCall("web.DHCEQEquipSave","GetEquipSumInfo",'',getElementValue("Job"),0);   //Modified by JYP0019 台帐添加job对多用户进行限制 //add by wy 2022-3-31 WY0099 增加参数vType
    var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'EquipList','',getElementValue("Job"),''); 
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
	    if (ret[1]!=undefined) $.messager.popover({msg:ret[1],type:'alert'});	 //MZY0144	3076613		2022-11-24
	    $('#tDHCEQEquipList').datagrid('unselectRow', rowIndex);
	}
	// modfied by ZY0306 20220711  台帐选择行存值到数组中
	else
	{
		var findindex=findSelectItem(rowid)
		if (findindex == -1) {
            	selectItems.push(rowid);
        }
        /*
        else
        {
            selectItems.splice(findindex, 1);
        }*/
	}
}
//清除所有选中记录的ID
function removeAllItem() {
	$('#tDHCEQEquipList').datagrid('clearSelections');
    selectItems=[];
}
//清除单条选中记录的ID
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
	removeAllItem();	//重载表格，初始化选择列
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
	/*
	var checkedItems = $('#tDHCEQEquipList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	*/
	if(selectItems.toString()=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	var url="dhceq.em.equipstockmove.csp?RowIDs="+selectItems.toString();
	showWindow(url,"台账批量调科",420,500,"icon-w-paper","modal","","","",reloadGrid);  //modified by LMH 20220825 2676671
}
//modified by zc0107 2021-11-14 1982788 台账导出包含附件
function BSaveAffixExcel_Click()
{	
	var Rows = $('#tDHCEQEquipList').datagrid('getRows');
	var RowCount=Rows.length;
	if(RowCount<=0){
		messageShow("","","","没有数据!")
		return;
	}
	if (!CheckColset("Equip"))
	{
		messageShow('popover','alert','提示',"导出数据列未设置!")
		return;
	}
	var url="dhccpmrunqianreport.csp?reportName=DHCEQEquipExportSB.raq&CurTableName=Equip&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

// CZF 2021-07-15 1967027
// 标准设备项回调函数
function GetStandardItem(item)
{
	setElement("StandardItemDR_MIDesc",item.TName);
	setElement("StandardItemDR",item.TRowID);
}

function initEquipAttributeCat()
{
	/*
	var jsonData=tkMakeServerCall("web.DHCEQCMasterItem","GetEquipAttributeCat")
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
    $("#EquipAttributeCat").keywords({
       items:string
    });
    */
    //设备属性相关调整
    if ($("#EquipAttributeList").length>0)
    {
		var SelectType=$("#EquipAttributeList").keywords("getSelected");
		var i=SelectType.length;
		var EquipAttributeString=""
		if(i>0)  //修改设备属性不能完全删除的问题
		{
			for (var j=0;j<i;j++)
			{
				if(EquipAttributeString=="")
				{
					EquipAttributeString=SelectType[j].id.slice(2)
				}else
				{
					EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id.slice(2)
				}
			}
		}
		else
		{
			var EquipAttributeString=""
		}
	    $HUI.combogrid('#IHTDesc',{   
		    url:$URL, 
		    queryParams:{
		        ClassName:"web.DHCEQ.EM.BUSAttributeCat",
		        QueryName:"GetAttributeCat",
		        TypeIDStr:EquipAttributeString
		    },
		    idField:'TRowID',
			textField:'TName',
		    multiple: true,
		    rowStyle:'checkbox', //显示成勾选行形式
		    selectOnNavigation:false,
		    fitColumns:true,
		    fit:true,
		    border:'true',
		    //singleSelect: true,
			//selectOnCheck: true,
			//checkOnSelect: true
		    columns:[[
		    	{field:'check',checkbox:true},
		    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
		        {field:'TName',title:'全选',width:150}
		    ]]
	    });
    }
}
//add by ZY0305 20220617 2724602
//modify by cjc 20220825 修改了引入的类和query以及请求方式
function initAppendFileInclude()
{	
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu","52","","1")
	var vdata=eval(PicTypesJson)
	var AppendFileInclude = $HUI.combobox('#AppendFileInclude',
	{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"200",	
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    border:'true',
	    data:vdata
	});
}
/**
 * 初始化管理类组为下拉框
 * @param {string} 无
 * @param {Object} 无
 * @returns 无
 * @author 刘梦辉 2022-09-16 2915348  挪动初始化界面时管理类组设置为下拉的位置，避开加载页面时DisableFlag的判断
 */
function initEquipType()
{
	//add by cjc 2022-07-12  台账增加设备类组可以多选查询 需求2772683
    $cm({
        ClassName:"web.DHCEQ.Plat.CTEquipType",
        QueryName:"GetEquipType",
        Desc:"",
        GroupID:"",
        
    },function(jsonData){
        equipTypeObj  = $HUI.combobox("#EquipType",{
        valueField:'TRowID',
        textField:'TName',
        multiple:true,
        rowStyle:'checkbox', //显示成勾选行形式
        selectOnNavigation:false,
        panelHeight:"auto",
        editable:false,
	onSelect:function(rowData){		// MZY0153	3244652		2023-02-20
                setElement("EquipTypeDR",rowData.TRowID)
                //singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
            },
        data:jsonData.rows
    });
        
    }); 
}
function initIdleFlagData()
{
	var IdleFlag = $HUI.combobox('#IdleFlag',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '1',
				text: '是'
			},{
				id: '0',
				text: '否'
			}]
	});
	
}

///czf 2022-09-16
function initIsIFB()
{
	var cbox = $HUI.combobox("#IsIFB",{
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
//add by txr 20230314
function BBatchOutStock_Click()
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
	var url="dhceq.em.equipoutstock.csp?RowIDs="+selectItems+"&ROutTypeDR="+getElementValue("ROutTypeDR");  //modified by txr 20230406
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	showWindow(url,"台帐批量减少",420,500,"icon-w-paper","modal","","","",reloadGrid); 
}
