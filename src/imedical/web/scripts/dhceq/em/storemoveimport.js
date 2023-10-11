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
    initMessage(); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    //initButtonWidth();
    initPage();//非通用按钮初始化
    initType();
	$HUI.datagrid("#tDHCEQStoreMove",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQStoreMoveNew",
	        	QueryName:"GetImportSMEquipList",
				Job:Job,
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:[[
				{field:'TNo',title:'资产编码',width:150,align:'left'},
				{field:'TLeaveFactoryNo',title:'出厂编号',width:150,align:'left'},
				{field:'TEquipName',title:'资产名称',width:150,align:'left'},
				{field:'TModel',title:'型号',width:180,align:'left'},
				{field:'TFromLoc',title:'供给科室',width:150,align:'left'},
				{field:'TToLoc',title:'接收科室',width:150,align:'left'},
				{field:'TReceiver',title:'接收人',width:80,align:'left'},
				{field:'TLocation',title:'存放地点',width:100,align:'left'},
				{field:'TStatus',title:'状态',width:50,align:'center'},
				{field:'TEquipType',title:'类组',width:80,align:'center'},
				{field:'TTransAssetDate',title:'入库日期',width:100,align:'center'},
				{field:'TOriginalFee',title:'原值',width:100,align:'right'},
				{field:'TNetFee',title:'净值',width:100,align:'right'},
				{field:'TDepreTotalFee',title:'累积折旧',width:100,align:'right'},
				{field:'TFlag',title:'异常标记',width:10,align:'left',hidden:true},		
				{field:'TFlagRemark',title:'异常状态',width:100,align:'left'},
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
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-right:10px'>全部设备</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-right:10px;'>异常设备</a>"
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
	BFind_Clicked();
}
function BDiff_Clicked()
{
	DisplayFlag="1";
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQStoreMove",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQStoreMoveNew",
	        	QueryName:"GetImportSMEquipList",
				Job:Job,
				DisplayFlag:DisplayFlag
			},
	});
}

function initPage()
{
	if (jQuery("#BBatchStoreMove").length>0)
	{
		jQuery("#BBatchStoreMove").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BBatchStoreMove").on("click", BBatchStoreMove_Clicked);
		jQuery("#BBatchStoreMove").linkbutton({text:'生成单据'});
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
				text: '生成新建转移单'
			},{
				id: '2',
				text: '生成提交转移单'
			},{
				id: '3',
				text: '生成审核完成转移单'
			}]
	});
	/*
	var MoveType = $HUI.combobox('#MoveType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '库房分配'
			},{
				id: '1',
				text: '科室调配'
			},{
				id: '2',
				text: '报废转报废库'
			},{
				id: '3',
				text: '科室退库'
			},{
				id: '4',
				text: '库房调配'
			}]
	});*/
	var KindType = $HUI.combobox('#KindType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '单台'
			},{
				id: '2',
				text: '批量'
			}]
	});
}

///导入列:资产名称、资产编号、接收科室、接收人、存放地点
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
    var ImportInfo=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=1;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    var ToLoc=RowInfo[Row-1][Col++];
	    if (ToLoc==undefined) ToLoc=""
	    var Receiver=RowInfo[Row-1][Col++];
	    if (Receiver==undefined) Receiver=""
	    var Location=RowInfo[Row-1][Col++];
	    if (Location==undefined) Location=""
	    
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"资产编号不能为空!")
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    No=No.replace(/\ +/g,"")	//去掉空格
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'资产编号:'+No+'不存在!')
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
		
		if (ToLoc=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"接收科室不能为空!")
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    ToLoc=ToLoc.replace(/\ +/g,"")	//去掉空格
		var ToLocID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",ToLoc);
	    if (ToLocID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'不存在!')
		   // return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    var StoreLocID=tkMakeServerCall("web.DHCEQStoreMoveNew","GetEQStoreLocID",EquipID)
		if (StoreLocID==ToLocID)
		{
			messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'和设备所在科室相同,不能转移!')
		   // return 1;  /// Modefied By ZC0133 2023-4-20 
		}
	    var ToLocType=tkMakeServerCall("web.DHCEQCommon","CheckLocTypeNew",ToLocID)
	 	if (ToLocType="")
	 	{
		 	messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'科室类型未设置,请先设置科室类型!')
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
		}
		
	    var ReceiverID=""
	    if(Receiver!="")
	    {
		    ReceiverID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Receiver);
		    if (ReceiverID=="")
		    {
			    messageShow('alert','error','错误提示',"第"+Row+"行"+'接收人:'+Receiver+'不存在!')
		    }
		}
		
		var LocationID=""
	    if(Location!="")
	    {
		    LocationID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Location);
		    if (LocationID=="")
		    {
			    messageShow('alert','error','错误提示',"第"+Row+"行"+'存放地点:'+Location+'不存在!')
			    LocationID="" /// Modefied By ZC0133 2023-4-20 
		    }
		}
		
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","ImportStoreMoveEquip",Job,ImportInfo);
	if (result.split("^")[0]!=0)		//2006617 czf 20210707
	{
	    messageShow("","","","错误信息:"+result.split("^")[1]+",请先处理完毕再进行下一步！");
	}
    else
    {
		messageShow("","success","","导入完成!");
		
		disableElement("BBatchStoreMove",0)
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
    var ImportInfo=""
	for (var Row=2;Row<=ExcelRows;Row++)
	{
	    var Col=2;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    var ToLoc=xlsheet.cells(Row,Col++).value;
	    if (ToLoc==undefined) ToLoc=""
	    var Receiver=xlsheet.cells(Row,Col++).value;
	    if (Receiver==undefined) Receiver=""
	    var Location=xlsheet.cells(Row,Col++).value;
	    if (Location==undefined) Location=""
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"资产编号不能为空!")
		    //return 1;   /// Modefied By ZC0133 2023-4-20 
	    }
	    No=No.replace(/\ +/g,"")	//去掉空格
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'资产编号:'+No+'不存在!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
		
		if (ToLoc=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"接收科室不能为空!")
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
	    ToLoc=ToLoc.replace(/\ +/g,"")	//去掉空格
		var ToLocID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",ToLoc);
	    if (ToLocID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'不存在!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
	    var StoreLocID=tkMakeServerCall("web.DHCEQStoreMoveNew","GetEQStoreLocID",EquipID)
		if (StoreLocID==ToLocID)
		{
			messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'和设备所在科室相同,不能转移!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
		}
	    var ToLocType=tkMakeServerCall("web.DHCEQCommon","CheckLocTypeNew",ToLocID)
	 	if (ToLocType="")
	 	{
		 	messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'科室类型未设置,请先设置科室类型!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
		}
		
	    var ReceiverID=""
	    if(Receiver!="")
	    {
		    ReceiverID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Receiver);
		    if (ReceiverID=="")
		    {
			    messageShow('alert','error','错误提示',"第"+Row+"行"+'接收人:'+Receiver+'不存在!')
		    }
		}
		
		var LocationID=""
	    if(Location!="")
	    {
		    LocationID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Location);
		    if (LocationID=="")
		    {
			    var val=getPYCode(Location)+"^"+Location;
				var LocationID=tkMakeServerCall("web.DHCEQCLocation","UpdLocation",val);
		  		if ((LocationID<=0)&&(GetElementValue("Location")!=""))
			    {
				    messageShow('alert','error','错误提示',"第"+Row+"行"+'存放地点:'+Location+'登记错误!!')
				    //return 1;   /// Modefied By ZC0133 2023-4-20 
				    LocationID=""  /// Modefied By ZC0133 2023-4-20 
			    }
		    }
		}
		
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    //xlsheet.Quit;
    xlsheet=null;
    
	if (ImportInfo=="")
	{
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","ImportStoreMoveEquip",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","错误信息:"+result.split("^")[1]+",请先处理完毕再进行下一步！");
	}
    else
    {
		messageShow("","success","","导入完成!");
		disableElement("BBatchStoreMove",0);
	}
	BFind_Clicked()
}

function BBatchStoreMove_Clicked()
{
	var OperationType=getElementValue("OperationType")
	if (OperationType=="")
	{
		messageShow('alert','error','错误提示',"操作类型不能为空!")
		return;
	}
	var KindType=getElementValue("KindType")
	if (KindType=="")
	{
		messageShow('alert','error','错误提示',"是否批量不能为空!")
		return;
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","BuildStoreMoveRequest",Job,OperationType,KindType);
	if (result!=0)
	{
	    messageShow('alert','error','错误提示',result);
	}
    else
    {
		messageShow("","success","","生成成功!");
		disableElement("BBatchStoreMove",1)
		//BFind_Clicked();
	}
}
