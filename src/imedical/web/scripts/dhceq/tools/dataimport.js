var Job=getElementValue("Job");
var BussType=getElementValue("BussType");
var DisplayFlag="";
var columns=[];
var editIndex=undefined;
var objtbl=$('#tDHCEQImportData');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPage();		//非通用按钮初始化
    initColumns();
    initDataGrid();
}

function initPage()
{
	
}

function initColumns()
{
	if(BussType=="11")
	{
		columns=getCurColumnsInfo('EM.G.DataImport.OpenCheck','','','');
		/*
		columns=[[
			{field:'DIRowID',title:'DIRowID',width:10,align:'left',hidden:true},
			{field:'Hold1',title:'供应商',width:150,align:'left',editor:{type: 'validatebox', options: { required: true }}},
			{field:'Hold2',title:'供方联系人',width:80,align:'left',editor:{type:'validatebox'}},
			{field:'Hold3',title:'供方联系方式',width:150,align:'left',editor:{type:'validatebox'}},
			{field:'Hold4',title:'设备类组',width:150,align:'left',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold5',title:'设备名称',width:150,align:'left',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold6',title:'型号',width:150,align:'center',editor:{type:'validatebox'}},
			{field:'Hold7',title:'原值',width:80,align:'center',editor:{type:'validatebox', options: { required: true }}},
			{field:'Hold8',title:'数量',width:100,align:'center',editor:{type:'numberbox', options: { required: true,precision:0}}},
			{field:'Hold9',title:'生产厂商',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold10',title:'国别',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold11',title:'出厂编号',width:100,align:'right',editor:{type:'validatebox'}},
			{field:'Hold12',title:'出厂日期',width:100,align:'left',editor:{type:'datebox', options: { validType:'validDate[\'yyyy-mm-dd\']'}}},		
			{field:'Hold13',title:'验收日期',width:100,align:'left',editor:{type:'datebox', options: { validType:'validDate[\'yyyy-mm-dd\']'}}},
			{field:'Hold14',title:'保修期(月)',width:100,align:'left',editor:{type:'text'}},
			{field:'Hold15',title:'合同号',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold16',title:'备注',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold17',title:'来源',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold18',title:'采购方式',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold19',title:'申购类别',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold20',title:'设备用途',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold21',title:'使用科室',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold22',title:'档案号',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold23',title:'经费来源',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold24',title:'存放地点',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold25',title:'计量标志',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold26',title:'中医标志',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold27',title:'放射标志',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold28',title:'注册证号',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold29',title:'品牌',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold30',title:'发票号',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold31',title:'项目名称',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold32',title:'验收结论',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold33',title:'配置相符',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold34',title:'运行情况',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold35',title:'随机文件',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold36',title:'外观完好性',width:100,align:'left',editor:{type:'validatebox'}},
			{field:'Hold56',title:'校验结果',width:200,align:'left'},
			{field:'TDiffFlag',title:'TDiffFlag',width:10,align:'left',hidden:true}
		]]
		*/
	}
}

function initDataGrid()
{
	$HUI.datagrid("#tDHCEQImportData",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.Tools.DataImport",
	        	QueryName:"GetImportData",
	        	BussType:BussType,
	        	CurUserID:curUserID,
				Job:Job
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			//singleSelect:true,
			fit:true,
			border:false,
			nowrap:false,
			toolbar:[{
					iconCls:'icon-add',
					text:'加载数据',
					handler:function(){ImportData();}
				}/*,{
					iconCls:'icon-checkin',
					text:'校验数据',
					handler:function(){CheckData();}
				}*/,{
					iconCls:'icon-import',
					text:'导入数据',
					handler:function(){ExecuteData();}
				},{
					iconCls:'icon-save',
					text:'保存数据',
					handler:function(){SaveData();}
				},{
					iconCls:'icon-remove',
					text:'删除数据',
					handler:function(){DeleteData();}
				}],
			columns:columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			rowStyler: function(index,row){
				var TDiffFlag=row.TDiffFlag;
				if(TDiffFlag) return 'background-color:yellow';
			},
			onClickRow:onClickRow,
			onLoadSuccess:function(){
				creatToolbar();
			}
	});
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px'>全部数据</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px;'>异常数据</a>"
	
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

function ImportData()
{
	if (websys_isIE)
	{
		BImport_IE();
	}
	else
	{
		BImport_Chrome();
	}
}

function BImport_Chrome()
{
	var val=curLocID;
	if (val!="")
	{
		var result=tkMakeServerCall("web.DHCEQCommon","CheckLocType",'0101',val);
		if (result=="-1")
		{
			messageShow("","","","当前设备库房不是库房!")
			return 0;
		}
		var result=tkMakeServerCall("web.DHCEQCommon","LocIsInEQ",'1',val);
		if (result=="1")
		{
			messageShow("","","","当前设备库房不在登录安全组管理范围内!")
			return 0;
		}
	}
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		messageShow("","","","没有数据导入！")
		return 0;
	}
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var Provider=trim(RowInfo[Row-1][Col++]);
		var ProviderHandler=trim(RowInfo[Row-1][Col++]);
		var ProviderTel=trim(RowInfo[Row-1][Col++]);
		var EquipType=trim(RowInfo[Row-1][Col++]);
		var Name=trim(RowInfo[Row-1][Col++]);
		if (Name=="") continue;
		var Model=trim(RowInfo[Row-1][Col++]);
		var OriginalFee=trim(RowInfo[Row-1][Col++]);
		var Quantity=trim(RowInfo[Row-1][Col++]);
		var ManuFactory=trim(RowInfo[Row-1][Col++]);
		var Country=trim(RowInfo[Row-1][Col++]); 
		var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
		var LeaveFactoryDate=trim(RowInfo[Row-1][Col++]);
		LeaveFactoryDate=changeDateFormat(LeaveFactoryDate);
		var CheckDate=trim(RowInfo[Row-1][Col++]);
		CheckDate=changeDateFormat(CheckDate);
		var GuaranteePeriodNum=trim(RowInfo[Row-1][Col++]);	//保修期
		var ContractNo=trim(RowInfo[Row-1][Col++]);	//合同号
		var Remark=trim(RowInfo[Row-1][Col++]);
		var Origin=trim(RowInfo[Row-1][Col++]);
		var BuyType=trim(RowInfo[Row-1][Col++]);
		var PurchaseType=trim(RowInfo[Row-1][Col++]);
		var PurposeType=trim(RowInfo[Row-1][Col++]);
		var UseLoc=trim(RowInfo[Row-1][Col++]);
		var FileNo=trim(RowInfo[Row-1][Col++]);
		var Expenditures=trim(RowInfo[Row-1][Col++]);
		var Location=trim(RowInfo[Row-1][Col++]);
		var MeasureFlag=trim(RowInfo[Row-1][Col++]);
		var Hold7=trim(RowInfo[Row-1][Col++]);  //中医标志
		var Hold6=trim(RowInfo[Row-1][Col++]);  //放射标志
		var Hold2=trim(RowInfo[Row-1][Col++])  //注册证号
		var Brand=trim(RowInfo[Row-1][Col++])  //品牌
		var Hold1=trim(RowInfo[Row-1][Col++])  //发票号
		var Hold11=trim(RowInfo[Row-1][Col++])  //项目名称
		var CheckResult=trim(RowInfo[Row-1][Col++])  //验收结论
		var ConfigState=trim(RowInfo[Row-1][Col++])  //配置相符
		var RunningState=trim(RowInfo[Row-1][Col++])  //运行情况
		var FileState=trim(RowInfo[Row-1][Col++])  //随机文件情况
		var PackageState=trim(RowInfo[Row-1][Col++])  //外观完好性
		
		var combindata=""; 
		combindata=combindata+"^"+Provider;		//2
		combindata=combindata+"^"+ProviderHandler;
		combindata=combindata+"^"+ProviderTel;
		combindata=combindata+"^"+EquipType;	//5
		combindata=combindata+"^"+Name;		//6
		combindata=combindata+"^"+Model;	//7
		combindata=combindata+"^"+OriginalFee;
		combindata=combindata+"^"+Quantity;
		combindata=combindata+"^"+ManuFactory;	//10
		combindata=combindata+"^"+Country;
		combindata=combindata+"^"+LeaveFactoryNo;
		combindata=combindata+"^"+LeaveFactoryDate;
		combindata=combindata+"^"+CheckDate;
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+ContractNo;
		combindata=combindata+"^"+Remark;
		combindata=combindata+"^"+Origin;	//18
		combindata=combindata+"^"+BuyType;	//19
		combindata=combindata+"^"+PurchaseType;	//20
		combindata=combindata+"^"+PurposeType;	//21
		combindata=combindata+"^"+UseLoc;		//22
		combindata=combindata+"^"+FileNo;
		combindata=combindata+"^"+Expenditures;
		combindata=combindata+"^"+Location;		//25
		combindata=combindata+"^"+MeasureFlag;	//26
		combindata=combindata+"^"+Hold7;
		combindata=combindata+"^"+Hold6;
		combindata=combindata+"^"+Hold2;
		combindata=combindata+"^"+Brand;		//30
		combindata=combindata+"^"+Hold1;
		combindata=combindata+"^"+Hold11;
		combindata=combindata+"^"+CheckResult;	//33
		combindata=combindata+"^"+ConfigState;	//34
		combindata=combindata+"^"+RunningState;	//35
		combindata=combindata+"^"+FileState;	//36
		combindata=combindata+"^"+PackageState;	//37
		
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveData",combindata,BussType,curUserID,Job,Row);
		var JsonData=JSON.parse(result);
		if(JsonData.SQLCODE!=0){
			if (Error=="") Error=JsonData.Data;
			else Error=Error+";"+JsonData.Data;
		}
	}
	if (Error!="") alert(Error)
	else{
		alert("数据装载成功!")
		BFind_Clicked();
	}
}

function BImport_IE()
{
	var val=curLocID;
	if (val!="")
	{
		var result=tkMakeServerCall("web.DHCEQCommon","CheckLocType",'0101',val);
		if (result=="-1")
		{
			messageShow("","","","当前设备库房不是库房!")
			return 0;
		}
		var result=tkMakeServerCall("web.DHCEQCommon","LocIsInEQ",'1',val);
		if (result=="1")
		{
			messageShow("","","","当前设备库房不在登录安全组管理范围内!")
			return 0;
		}
	}
	
	var Error=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("验收单");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var Provider=trim(xlsheet.cells(Row,Col++).text);
		var ProviderHandler=trim(xlsheet.cells(Row,Col++).text);
		var ProviderTel=trim(xlsheet.cells(Row,Col++).text);
		var EquipType=trim(xlsheet.cells(Row,Col++).text);
		var Name=trim(xlsheet.cells(Row,Col++).text);
		if (Name=="") continue;
		var Model=trim(xlsheet.cells(Row,Col++).text);
		var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
		var Quantity=trim(xlsheet.cells(Row,Col++).text);
		var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
		var Country=trim(xlsheet.cells(Row,Col++).text); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
		var LeaveFactoryDate=trim(xlsheet.cells(Row,Col++).text);
		LeaveFactoryDate=changeDateFormat(LeaveFactoryDate);
		var CheckDate=trim(xlsheet.cells(Row,Col++).text);
		CheckDate=changeDateFormat(CheckDate);
		var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);	//保修期
		var ContractNo=trim(xlsheet.cells(Row,Col++).text);	//合同号
		var Remark=trim(xlsheet.cells(Row,Col++).text);
		var Origin=trim(xlsheet.cells(Row,Col++).text);
		var OriginDR="";
		var BuyType=trim(xlsheet.cells(Row,Col++).text);
		var BuyTypeDR="";
		var PurchaseType=trim(xlsheet.cells(Row,Col++).text);
		var PurchaseTypeDR="";
		var PurposeType=trim(xlsheet.cells(Row,Col++).text);
		var PurposeTypeDR="";    
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		var UseLocDR="";
		var FileNo=trim(xlsheet.cells(Row,Col++).text);
		var Expenditures=trim(xlsheet.cells(Row,Col++).text);
		var ExpendituresDR="";
		var Location=trim(xlsheet.cells(Row,Col++).text);
		var MeasureFlag=trim(xlsheet.cells(Row,Col++).text);
		var Hold7=trim(xlsheet.cells(Row,Col++).text);  //中医标志
		var Hold6=trim(xlsheet.cells(Row,Col++).text);  //放射标志
		var Hold2=trim(xlsheet.cells(Row,Col++).text)  //注册证号
		var Brand=trim(xlsheet.cells(Row,Col++).text)  //品牌
		var Hold1=trim(xlsheet.cells(Row,Col++).text)  //发票号
		var Hold11=trim(xlsheet.cells(Row,Col++).text)  //项目名称
		var CheckResult=trim(xlsheet.cells(Row,Col++).text)  //验收结论
		var ConfigState=trim(xlsheet.cells(Row,Col++).text)  //配置相符
		var RunningState=trim(xlsheet.cells(Row,Col++).text)  //运行情况
		var FileState=trim(xlsheet.cells(Row,Col++).text)  //随机文件情况
		var PackageState=trim(xlsheet.cells(Row,Col++).text)  //外观完好性
		
		var combindata=""; 
		combindata=combindata+"^"+Provider;		//2
		combindata=combindata+"^"+ProviderHandler;
		combindata=combindata+"^"+ProviderTel;
		combindata=combindata+"^"+EquipType;	//5
		combindata=combindata+"^"+Name;		//6
		combindata=combindata+"^"+Model;	//7
		combindata=combindata+"^"+OriginalFee;
		combindata=combindata+"^"+Quantity;
		combindata=combindata+"^"+ManuFactory;	//10
		combindata=combindata+"^"+Country;
		combindata=combindata+"^"+LeaveFactoryNo;
		combindata=combindata+"^"+LeaveFactoryDate;
		combindata=combindata+"^"+CheckDate;
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+ContractNo;
		combindata=combindata+"^"+Remark;
		combindata=combindata+"^"+Origin;	//18
		combindata=combindata+"^"+BuyType;	//19
		combindata=combindata+"^"+PurchaseType;	//20
		combindata=combindata+"^"+PurposeType;	//21
		combindata=combindata+"^"+UseLoc;		//22
		combindata=combindata+"^"+FileNo;
		combindata=combindata+"^"+Expenditures;
		combindata=combindata+"^"+Location;		//25
		combindata=combindata+"^"+MeasureFlag;	//26
		combindata=combindata+"^"+Hold7;
		combindata=combindata+"^"+Hold6;
		combindata=combindata+"^"+Hold2;
		combindata=combindata+"^"+Brand;		//30
		combindata=combindata+"^"+Hold1;
		combindata=combindata+"^"+Hold11;
		combindata=combindata+"^"+CheckResult;	//33
		combindata=combindata+"^"+ConfigState;	//34
		combindata=combindata+"^"+RunningState;	//35
		combindata=combindata+"^"+FileState;	//36
		combindata=combindata+"^"+PackageState;	//37
		
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveData",combindata,BussType,curUserID,Job,Row);
		var JsonData=JSON.parse(result);
		if(JsonData.SQLCODE!=0){
			if (Error=="") Error=JsonData.Data;
			else Error=Error+";"+JsonData.Data;
		}
	}
	if (Error!="") alert(Error)
	else{
		messageShow("","","","数据装载成功!")
		BFind_Clicked();
	}
}

function CheckData()
{
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","CheckData",BussType,curUserID,Job);
	
	if (result>0)
	{
		messageShow("","","",result+"条数据校验错误，请查看检验结果!")
	}
	else
	{
		messageShow("","","","校验成功，请执行导入数据操作!")
	}
	$("#tDHCEQImportData").datagrid('reload');
}

function ExecuteData()
{
	//$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	//执行前先保存数据，然后校验数据
	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveDataList",valList);
  	var JsonData=JSON.parse(result);
	if(JsonData.SQLCODE!=0){
		//保存成功，校验数据
		editIndex=undefined;
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","CheckData",BussType,curUserID,Job);
		if (result>0){
			messageShow("","","",result+"条数据校验错误，请查看校验结果，修正数据保存后继续导入!")
			$("#tDHCEQImportData").datagrid('reload');
			return;
		}else{
			//校验成功，执行导入
			var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","ExecuteData",BussType,curUserID,Job,curSSHospitalID);
			var JsonData=JSON.parse(result);
			if(JsonData.SQLCODE!=0){
				messageShow("","","","执行失败，错误信息："+JsonData.Data)
			}else{
				if(JsonData.Data>0){
					messageShow("","","",JsonData.Data+"条数据执行错误，请查看校验结果!")
				}else{
					messageShow("","","","执行成功，请返回界面查看已导入验收单!")
					websys_showModal("options").mth();	//刷新父界面
				}
			}
			BFind_Clicked();
		}
	}else{
		messageShow('alert','error','提示',"修改数据保存错误："+JsonData.Data);
		BFind_Clicked();
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
	$HUI.datagrid("#tDHCEQImportData",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.Tools.DataImport",
	        	QueryName:"GetImportData",
				BussType:BussType,
	        	CurUserID:curUserID,
				Job:Job,
				DiffFlag:DisplayFlag
			},
	});
}

function onClickRow(index)
{
	if (editIndex!=index)
	{
		if (endEditing())
		{
			objtbl.datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},objtbl.datagrid('getRows')[editIndex]);
		} else {
			objtbl.datagrid('selectRow', editIndex);
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
	if (objtbl.datagrid('validateRow', editIndex))
	{
		objtbl.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function SaveData()
{
	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
  	var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","SaveDataList",valList);
  	var JsonData=JSON.parse(result);
	if(JsonData.SQLCODE!=0){
		messageShow('alert','success','提示',"保存成功!");
		BFind_Clicked();
		editIndex=undefined;
	}
	else
	{
		messageShow('alert','error','提示',JsonData.Data);
	}
}

//获取列表明细
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		RowNo=i+1;
		
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (valList=="")
	{
		messageShow('alert','error','提示',"列表明细不能为空!");
		return -1;
	}
	return valList;
}

function GetMasterItem(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold5'});
	$(editor.target).combogrid("setValue",data.TName);
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold4'});
	$(editor.target).combogrid("setValue",data.TEquipType);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetEquipType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold4'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetModel(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold6'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getVendor(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold1'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetManuFacturer(index,data)
{
	//var rowData = $('#tDHCEQImportData').datagrid('getSelected');
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold9'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getUseLoc(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold21'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetBrand(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold29'});
	$(editor.target).combogrid("setValue",data.TDesc);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function getExpenditures(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold23'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetLocation(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold24'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetPurchaseType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold19'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetPurposeType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold20'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetCountry(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold10'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetBuyType(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold18'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

function GetOrigin(index,data)
{
	var editor = $('#tDHCEQImportData').datagrid('getEditor',{index:editIndex,field:'Hold17'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQImportData').datagrid('endEdit',editIndex);
	$('#tDHCEQImportData').datagrid('beginEdit',editIndex);
}

//excel日期格式转换 numb为数字，format为拼接符“-”
function changeDateFormat(cellval, format)
{
	if ((cellval=="")||(cellval==null)||(cellval==undefined)) return ""
	if ((format==undefined)||(format=="")||(format==null)) format="-";
	if (websys_isIE)
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


function DeleteData()
{
	var RowsData=$('#tDHCEQImportData').datagrid('getChecked');
	var ValList=""
	
	if (RowsData.length==0){
		messageShow('alert','error','提示',"未勾选数据!");
		return;
	}
	
	messageShow("confirm","info","提示","是否确认删除已勾选数据?","",function(){
		for (var i=0;i<RowsData.length;i++)
		{
			if (ValList=="")
			{
				ValList=RowsData[i].DIRowID;	
			}
			else
			{
				ValList=ValList+","+RowsData[i].DIRowID
			}
		}
		var result=tkMakeServerCall("web.DHCEQ.Tools.DataImport","DeleteData",ValList);
		if (result>0)
		{
			messageShow("","","",result+"条数据删除错误!")
		}
		else
		{
			messageShow("","","","删除成功!")
		}
		$("#tDHCEQImportData").datagrid('reload');
	
	},function(){
		return;
	});
}

function getParam()
{
	
}