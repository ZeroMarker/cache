var Job=getElementValue("Job");
var DisplayFlag="";

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	setElement("NoDealFlag",true)
	initUserInfo();
    initMessage();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    //initPage();
    //initType();
	$HUI.datagrid("#tDHCEQBatchEQModify",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSEquip",
	        	QueryName:"GetEQModify",
				Job:Job,
				User:curUserID
			},
			rownumbers: true, 
			singleSelect:true,
			fit:true,
			border:false,
			toolbar:[
				{
					iconCls:'icon-add',
					id:'BImport',
					text:'加载数据',
					handler:function(){BImport_Clicked();}
				},
				{
					iconCls:'icon-save',
					id:'BExecute',
					text:'执行',
					handler:function(){BExecute_Clicked();}
				}
			],
			columns:[[
				{field:'TEquipID',title:'资产ID',width:10,align:'left',hidden:true},
				{field:'TEquipNo',title:'资产编码',width:150,align:'left'},
				{field:'TEquipName',title:'资产名称',width:150,align:'left'},
				{field:'TValueType',title:'变更类型',width:180,align:'left'},
				{field:'TOldValue',title:'变更前',width:150,align:'left'},
				{field:'TNewValue',title:'变更后',width:150,align:'left'}
			]],
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
				//creatToolbar();
			}
	});
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:20px'>全部设备</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:20px;'>异常设备</a>"
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
	$HUI.datagrid("#tDHCEQBatchEQModify",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSEquip",
	        	QueryName:"GetEQModify",
				Job:Job
			}
	});
}

///导入列:资产编号、变更类型、变更后的值
function BImport_Clicked()
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
    var ErrMsg="";
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("没有数据导入！")
		return 0;
	}
    var ImportInfo=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    var ValueType=RowInfo[Row-1][Col++];
	    if (ValueType==undefined) ValueType=""
	    var Value=RowInfo[Row-1][Col++];
	    if (Value==undefined) Value=""
	    
	    No=No.replace(/\ +/g,"")	//去掉空格
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"资产编号不能为空!")
		    return 1;
	    }
	    
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'资产编号:'+No+'不存在!')
		    return 1;
	    }
		
		ValueType=ValueType.replace(/\ +/g,"")	//去掉空格
		if (ValueType=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"变更类型不能为空!")
		    return 1;
	    }
	    ValueTypeID="";
	    NewValue="";
	    var RtnMsg=CheckValueIsInvalid(ValueType,Value,Row,EquipID)
	   	if (RtnMsg!=0)
	   	{
		   	ErrMsg=RtnMsg+","+ErrMsg
		   	continue;
		}
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ValueTypeID+"^"+NewValue;
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ValueTypeID+"^"+NewValue;
	}
	if (ErrMsg!="")
	{
		messageShow('alert','error','错误提示',ErrMsg)
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ImportEquipModify",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","错误信息:"+result.split("^")[1]+",请先处理完毕再进行下一步！");
	}
    else
    {
		messageShow("","success","","导入完成!");
		disableElement("BExecute",0)
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
	var ErrMsg=""
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
	    var Col=1;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No="";
	    var ValueType=xlsheet.cells(Row,Col++).value;
	    if (ValueType==undefined) ValueType="";
	    var Value=xlsheet.cells(Row,Col++).value;
	    if (Value==undefined) Value="";
	    
	    No=No.replace(/\ +/g,"")	//去掉空格
	    if (No=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"资产编号不能为空!")
		    return 1;
	    }
	    
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+'资产编号:'+No+'不存在!')
		    return 1;
	    }
		
		ValueType=ValueType.replace(/\ +/g,"")	//去掉空格
		if (ValueType=="")
	    {
		    messageShow('alert','error','错误提示',"第"+Row+"行"+"变更类型不能为空!")
		    return 1;
	    }
	    ValueTypeID="";
	    NewValue="";
	   	var RtnMsg=CheckValueIsInvalid(ValueType,Value,Row,EquipID)
	   	if (RtnMsg!=0)
	   	{
		   	ErrMsg=RtnMsg+","+ErrMsg
		   	continue;
		}
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ValueTypeID+"^"+NewValue;
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ValueTypeID+"^"+NewValue;
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    //xlsheet.Quit;
    xlsheet=null;
	
	if (ErrMsg!="")
	{
		messageShow('alert','error','错误提示',ErrMsg)
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','错误提示',"表格数据为空!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ImportEquipModify",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","错误信息:"+result.split("^")[1]+",请先处理完毕再进行下一步！");
	}
    else
    {
		messageShow("","success","","导入完成!");
		disableElement("BExecute",0)
	}
	BFind_Clicked()
}

function CheckValueIsInvalid(ValueType,Value,Row,EquipID)
{
	var ErrMsg=""
	switch(ValueType){
		case "资产名称":
			NewValue=Value;
			if(NewValue=="")
			{
				ErrMsg="第"+Row+"行"+"名称不能为空!";
				//messageShow('alert','error','错误提示',"第"+Row+"行"+"名称不能为空!")
				return ErrMsg;
			}
			ValueTypeID="name";
			break;
		case "型号":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Model",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
			    var data=EquipID+"^"+Value;
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveEQModel",data);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="第"+Row+"行"+"型号:"+Value+"自动保存字典错误!"
				    //messageShow('alert','error','错误提示',"第"+Row+"行"+'型号:'+Value+'自动保存字典错误!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="model";
			break;
		case "资产分类":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","EquipCat",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'资产分类:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'资产分类:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="equipcat";
			break;
		case "单位":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUOM",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'单位'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'单位'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="uom";
			break;
		case "代码":
			NewValue=Value;
			ValueTypeID="code";
			break;
		case "安装科室":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'安装科室'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'安装科室'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="installloc";
			break;
		case "安装日期":
			NewValue=changeDateFormat(Value);
			ValueTypeID="installdate";
			break
		case "出厂编号":
			NewValue=Value;
			ValueTypeID="leavefactoryno";
			break
		case "出厂日期":
			NewValue=changeDateFormat(Value);
			ValueTypeID="leavefactorydate";
			break
		case "开箱日期":
			NewValue=changeDateFormat(Value);
			ValueTypeID="opencheckdate";
			break
		case "验收日期":
			NewValue=changeDateFormat(Value);
			ValueTypeID="checkdate";
			break
		case "制造日期":
			NewValue=changeDateFormat(Value);
			ValueTypeID="makedate";
			break
		case "国别":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTCountry",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'国别:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'国别:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="country";
			break;
		case "管理部门":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'管理部门:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'管理部门:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="manageloc";
			break;
		case "设备来源":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCOrigin",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'设备来源:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'设备来源:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="origin";
			break;
		case "来源部门":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","FromToDept",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'来源部门:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'来源部门:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="fromdept";
			break;
		case "去向部门":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","FromToDept",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'去向部门:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'去向部门:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="todept";
			break;
		case "采购方式":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","BuyType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'采购方式:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'采购方式:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="buytype";
			break;
		case "供应商":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Provider",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
			    var data=Value+"^^";
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTVendor","UpdProvider",data);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="第"+Row+"行"+'供应商:'+Value+'自动保存字典失败!'
				    //messageShow('alert','error','错误提示',"第"+Row+"行"+'供应商:'+Value+'自动保存字典失败!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="provider";
			break;
		case "生产厂商":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Manufacturer",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTManufacturer","UpdManufacturer",Value);
			    jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="第"+Row+"行"+'生产厂商:'+Value+'自动保存字典失败!'
				    //messageShow('alert','error','错误提示',"第"+Row+"行"+'生产厂商:'+Value+'自动保存字典失败!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="manufactory";
			break;
		case "折旧年限":
			NewValue=Value;
			ValueTypeID="limityearsnum";
			break;
		case "使用年限":
			NewValue=Value;
			ValueTypeID="hold5";
			break;
		case "折旧方法":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DepreMethod",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'接收科室:'+ToLoc+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'接收科室:'+ToLoc+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="depremethod";
			break;
		case "管理人":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'管理人:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'管理人:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="manageuser";
			break;
		case "供方联系人":
			NewValue=Value;
			ValueTypeID="providerhandler";
			break;
		case "供方电话":
			NewValue=Value;
			ValueTypeID="providertel";
			break;
		case "申购类别":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","PurchaseType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'申购类别:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'申购类别:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="purchasetype";
			break;
		case "用途":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","PurposeType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'用途:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'用途:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="purposetype";
			break;
		case "保管人":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'保管人:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'保管人:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="keeper";
			break;
		case "服务商":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Service",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'服务商:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'服务商:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="service";
			break;
		case "存放地点":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",Value);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="第"+Row+"行"+'存放地点:'+Value+'自动保存地点错误!'
				    //messageShow('alert','error','错误提示',"第"+Row+"行"+'存放地点:'+Value+'自动保存地点错误!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="location";
			break;
		case "保修期":
			NewValue=Value;
			ValueTypeID="guanranteenum";
			break;
		case "合同号":
			NewValue=Value;
			ValueTypeID="contractno";
			break;
		case "档案号":
			NewValue=Value;
			ValueTypeID="fileno";
			break;
		case "凭证号":
			NewValue=Value;
			ValueTypeID="accountno";
			break;
		case "注册证号":
			NewValue=Value;
			ValueTypeID="registerno";
			break;
		case "品牌":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Brand",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="第"+Row+"行"+'品牌:'+Value+'不存在!'
			    //messageShow('alert','error','错误提示',"第"+Row+"行"+'品牌:'+Value+'不存在!')
			    return ErrMsg;
		    }
			ValueTypeID="brand";
			break;
		default:
			ErrMsg="第"+Row+"行:"+ValueType+'不允许修改!'
			//messageShow('alert','error','错误提示',"第"+Row+"行:"+ValueType+'不允许修改!')
			return ErrMsg;
			break;
	}
	return 0;
}

//excel日期格式转换 numb为数字，format为拼接符“-”
function changeDateFormat(cellval, format)
{
	if ((cellval=="")||(cellval==null)||(cellval==undefined)) return ""
	if ((format==undefined)||(format=="")||(format==null)) format="-";
	if (getElementValue("ChromeFlag")!="1")
	{
		//IE
		if (typeof cellval=="string")
		{
			if (cellval.indexOf("-")>-1) return cellval;
			if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		}
		else if (typeof cellval=="number")
		{
			var time = new Date((cellval - 2) * 24 * 3600000 + 1)
		    time.setYear(time.getFullYear() - 70)
		    var year = time.getFullYear() + ''
		    var month = time.getMonth() + 1 + ''
		    var date = time.getDate() + ''
		    return year + format + month + format + date;
		}
		else if (typeof cellval=="date")
		{
			var time=new Date(cellval);
			var year = time.getFullYear() + '';
		    var month = time.getMonth() + 1 + '';
		    var date = time.getDate() + '';
		    return year + format + month + format + date;
		}
		else
		{
			return cellval;	
		}
	}
	else
	{
		//Chrome
		if (cellval.indexOf("-")>-1) return cellval;
		if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		var time = new Date((cellval - 2) * 24 * 3600000 + 1)
	    time.setYear(time.getFullYear() - 70)
	    var year = time.getFullYear() + ''
	    var month = time.getMonth() + 1 + ''
	    var date = time.getDate() + ''
	    return year + format + month + format + date
	}
}

function BExecute_Clicked()
{
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ModifyEquipInfo",Job);
	result=result.split("^");
	var ErrCode=result[0];
	if (ErrCode!=0)
	{
	    messageShow('alert','error','错误提示',result[1]);
	}
    else
    {
		messageShow("","success","","更新成功!");
		disableElement("BExecute",1)
	}
}