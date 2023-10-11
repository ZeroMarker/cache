var Job=getElementValue("Job")
var DisplayFlag="";

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	setElement("NoDealFlag",true)
	initUserInfo();
    initMessage("dis"); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    //initButtonWidth();
    initPage();//非通用按钮初始化
    initType();
	$HUI.datagrid("#tDHCEQDisuse",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQBatchDisuseRequest",
	        	QueryName:"GetImportDisuseEquipList",
				Job:Job,
			},
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:[[
				{field:'TNo',title:'资产编码',width:150,align:'left'},
				{field:'TFileNo',title:'档案号',width:80,align:'left'},
				{field:'TEquipName',title:'名称',width:150,align:'left'},
				{field:'TModel',title:'型号',width:180,align:'left'},
				{field:'TStoreLoc',title:'科室',width:150,align:'left'},
				{field:'TStatus',title:'状态',width:50,align:'center'},
				{field:'TEquipType',title:'类组',width:80,align:'center'},
				{field:'TTransAssetDate',title:'入库日期',width:100,align:'center'},
				{field:'TOriginalFee',title:'原值',width:100,align:'right'},
				{field:'TNetFee',title:'净值',width:100,align:'right'},
				{field:'TDepreTotalFee',title:'累积折旧',width:100,align:'right'},
				{field:'TFlag',title:'异常标记',width:10,align:'left',hidden:true},		
				{field:'TFlagRemark',title:'异常状态',width:550,align:'left'},
			]],
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
				//creatToolbar();
			}
	});
	initEquipFilter();
}
	
function initEquipFilter()
{
	 $("#EquipFilter").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
	        if (selectItemID=="allflag")
			{
				BAll_Clicked();
			}
			else if (selectItemID=="diffflag")
			{
				BDiff_Clicked();
			}
			
        },
        labelCls:'blue',
        items:[
            {text:'全部设备',id:'allflag',selected:true},
            {text:'异常设备',id:'diffflag'},
        ]
	 });
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px'>全部设备</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px;'>异常设备</a>"
	
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#diffflag").length>0)
	{
		jQuery("#diffflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#diffflag").on("click", BDiff_Clicked);
	}
}

function BAll_Clicked()
{
	DisplayFlag="";
	$("#allflag").css("color", "#FF0000");
	$("#diffflag").css("color", "#FFFFFF");
	BFind_Clicked();
}
function BDiff_Clicked()
{
	DisplayFlag="1";
	$("#allflag").css("color", "#FFFFFF");
	$("#diffflag").css("color", "#FF0000");
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQDisuse",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQBatchDisuseRequest",
	        	QueryName:"GetImportDisuseEquipList",
				Job:Job,
				DisplayFlag:DisplayFlag
			},
	});
}

function initPage()
{
	if (jQuery("#BBatchDisuse").length>0)
	{
		jQuery("#BBatchDisuse").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BBatchDisuse").on("click", BBatchSaveDisuseRequest_Clicked);
		jQuery("#BBatchDisuse").linkbutton({text:'生成单据'});
	}
}
function initType()
{
	var OperationType = $HUI.combobox('#OperationType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '未定义'
			},{
				id: '1',
				text: '生成新建报废单'
			},{
				id: '2',
				text: '生成提交报废单'
			},{
				id: '3',
				text: '生成预报废单'
			},{
				id: '4',
				text: '生成审核完毕报废单'
			}]
	});
	var KindType = $HUI.combobox('#KindType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '单台报废'
			},{
				id: '2',
				text: '多批次'
			}]
	});
	
}
function ImportData()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}

function BImport_Chrome()
{
	if (Job=="")
	{
		messageShow('alert','error','错误提示',"Job不能为空!")
		return;
	}
    
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("没有数据导入！")
		return 0;
	}
    var EquipIDs=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"设备编号为空!")
		    return 1;
	    }
	    No=No.replace(/\ +/g,"")	//去掉空格
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'设备:'+No+'编号为空!')
		    return 1;
	    }
	    else
	    {
		    if (EquipIDs=="") EquipIDs=EquipID
		    else EquipIDs=EquipIDs+"^"+EquipID
		}
	}    
	if (EquipIDs=="")
	{
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","ImportDisuseEquip",Job,EquipIDs);
	if (result!=0)
	{
	    messageShow("","","","错误信息:有"+result+"个设备有其他在途中的业务!请先处理完毕再进行下一步.");
	}
    else
    {
		messageShow("","success","","导入完成!");
		
		disableElement("BBatchDisuse",0)
	}
	BFind_Clicked()
}
function BImport_IE()
{
	if (Job=="")
	{
		messageShow('alert','error','错误提示',"Job不能为空!")
		return;
	}
	
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(1);
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
    var EquipIDs=""
	for (var Row=2;Row<=ExcelRows;Row++)
	{
	    var Col=1;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"设备编号为空!")
		    return 1;
	    }
	    No=No.replace(/\ +/g,"")	//去掉空格
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'设备:'+No+'编号为空!')
		    return 1;
	    }
	    else
	    {
		    if (EquipIDs=="") EquipIDs=EquipID
		    else EquipIDs=EquipIDs+"^"+EquipID
		}
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    
	if (EquipIDs=="")
	{
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","ImportDisuseEquip",Job,EquipIDs);
	if (result!=0)
	{
	    messageShow("","","","错误信息:有"+result+"个设备有其他在途中的业务!请先处理完毕再进行下一步.");
	}
    else
    {
		messageShow("","success","","导入完成!");
		
		disableElement("BBatchDisuse",0)
	}
	BFind_Clicked()
}

function BBatchSaveDisuseRequest_Clicked()
{
	var KindType=getElementValue("KindType")
	if (KindType=="")
	{
		messageShow('alert','error','错误提示',"报废类型为空!")
		return;
	}
	var OperationType=getElementValue("OperationType")
	if (OperationType=="")
	{
		messageShow('alert','error','错误提示',"生成类型为空!")
		return;
	}
	var NoDealFlag=getElementValue("NoDealFlag")
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","BuildDisuseRequest",Job,OperationType,KindType,NoDealFlag);
	if (result!=0)
	{
	    messageShow("","","","错误信息:"+result);
	}
    else
    {
		messageShow("","success","","生成成功!");
		disableElement("BBatchDisuse",1)
	}
}
