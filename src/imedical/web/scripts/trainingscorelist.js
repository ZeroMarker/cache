var editIndex=undefined;
var columns=getCurColumnsInfo('EM.G.TrainingScoreList','','','');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var columns2=getCurColumnsInfo('EM.G.TrainingScore','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var frozencolumns=getCurColumnsInfo('EM.G.TrainingUser','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
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
	//initStatusData();		
}
//初始化查询头面板
function initTopPanel()
{ 	initLookUp();
	initButtonWidth();
	initButton(); //按钮初始化
	//jQuery('#BFind').on("click", BFind_Clicked);
	//initStatusData();
	initMessage();
	defindTitleStyle();
	initTrainingScoreList();
	fillData();
	setEnabled();
	initTrainingUser();	
}

//填充数据
function fillData()
{
	CORowID=getElementValue("CORowID")
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","GetOneCourse",CORowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	
	TSRowID=getElementValue("TSRowID")
	if (TSRowID=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","GetOneTrainingScore",TSRowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	

	SourceType=getElementValue("COSourceType");
	if ((SourceType==0)){   //设备项
		singlelookup("COSource","EM.L.GetMasterItem","",GetMasterItem)
		disableElement("COModel",false)
	}
	else if ((SourceType==1))
	{
		var params=[{name:'Equip',type:1,value:'COSource'},{name:'VUseLoc',type:4,value:'TRRLocDR'},{name:'NeedUseLoc',type:2,value:'1'}]
		singlelookup("COSource","EM.L.Equip",params,GetEquip)
	}
	else
	{
		var params=[{name:'Name',type:1,value:'Name'},{name:'SourceType',type:4,value:'SourceType'},{name:'CheckDate',type:4,value:'CheckDate'}]
		singlelookup("Name","EM.L.GetContractList",params,GetContractList)
	}
}
function setEnabled()
{
	var TSStatus=getElementValue("TSStatus");
	if(TSStatus=="")
	{
		if(location.href.split("?")[0].indexOf("list")==-1)
		{
			disableElement("BSave",true);	
		}
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
	}
	else if(TSStatus=="0")
	{
//		disableElement("BSubmit",true);
		disableElement("BSave",false);
		disableElement("BSubmit",false);
		disableElement("BDelete",false);
	}else if(TSStatus=="2")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
	}
}
function initTrainingScoreList()
{
	if($("#tDHCEQTrainingScoreList").length){
		$HUI.datagrid("#tDHCEQTrainingScoreList",{   
		    url:$URL, 
		    queryParams:{
		        ClassName:"web.DHCEQ.EM.BUSTraining", 
		        QueryName:"GetTrainingScore",
				TrainingDR:getElementValue("CORowID"),
				Stage:getElementValue("TRRStage") 
		    },
		    fit:true,
			striped : true,
		    cache: false,
			//fitColumns:true,
			singleSelect:true,
	    	columns:columns2, 
	    	frozenColumns:frozencolumns,
			pagination:true,
			pageSize:12,
			pageNumber:1,
			pageList:[12,24,36,48],
			onClickRow:function(rowIndex, rowData) 
			{	
				setElement("TSRowID",rowData.TRowID);
				setElement("CORowID",rowData.TTrainingDR);
				setElement("TRRStage",rowData.TStage==""?getElementValue("TRRStage"):rowData.TStage);
				fillData();
				initTrainingUser();
				setEnabled()
			},
			onLoadSuccess: function (data) {

			},
	});
	}
}

function initTrainingUser()
{
//	alert(getElementValue("TSRowID"))
//	alert(getElementValue("CORowID"))
//	alert(getElementValue("TRRStage"))
	$HUI.datagrid("#tDHCEQTrainingUser",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSTraining",   //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"TrainingScoreList",
	        TRScoreDR:getElementValue("TSRowID"),
	        CourseDR:getElementValue("CORowID"),
	        Stage:getElementValue("TRRStage"),
//	        ReadOnly:getElementValue("ReadOnly"),
	    },
	    fit:true,
	   	singleSelect:true,
		//fitColumns:true,
    	columns:columns, 
//    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
//		toolbar:[{
//    				iconCls: 'icon-add',
//        			text:'保存',
//        			id:'save',
//        			handler: function(){
//        			BAdd_Clicked();
//    			}}],
		onDblClickRow:onClickRow,
		onClickRow:function(rowIndex,rowData){
//			onClickRow(rowIndex)
//			if (rowData.TRowID!=""){
//				setElement("TUTrainUserDR",rowData.TTrainUserDR);
//				setElement("TUTrainUser",rowData.TTrainUser);
//				setElement("TURemark",rowData.TRemark);
//				setElement("TURowID",rowData.TRowID);
//				setElement("TUAverageScore",rowData.TAverageScore);
//				setElement("TUPassFlag",rowData.TPassFlag);
//			}
		},
		onLoadSuccess: function (data) {
		},
		onLoadError:function (err){
			console.log(err)
		}
	});
	if(getElementValue("TSRowID")==""){
		disableElement("save",true);
	}
}

function BSave_Clicked()
{
 	var data=getInputList();
	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingScore",data,valList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data+"&CORowID="+getElementValue("CORowID");
//		url="dhceq.em.trainingscorelist.csp?"+val
		url=location.href.split("?")[0]+"?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;

	}
	else
    {
		messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);
		return
    }	
}
function BSubmit_Clicked()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SubmitTrainingScore",getElementValue("TSRowID"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		location.reload()
	}
	else
    {
		messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);
		return
    }
	
}
function BDelete_Clicked()
{
    messageShow("confirm","","",t[-9203],"",truthBeTold,Cancel);
	
	function truthBeTold(){
		TSRowID=getElementValue("TSRowID");
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingScore",TSRowID,"","1");
		jsonData=JSON.parse(jsonData)

		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','错误提示',t[-9200]+jsonData.Data);
			return
	    }
	    else
	    {
			location.reload()
		}

	}
	
	function Cancel(){
		return
	}
}
function BAdd_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var valList=GetTableInfo(); 	//明细信息
  	if (valList=="-1")  return; 	//明细信息有误

	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingUser",data,valList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+getElementValue("TRRRowID");
		url="dhceq.em.trainingrecordlist.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;

	}
	else
    {
		messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);
		return
    }
}
function GetSourceType(item)
{
	setElement("COSourceType",item.TRowID); 	
	if ((item.TRowID==0)){   //设备项
		singlelookup("COSource","EM.L.GetMasterItem","",GetMasterItem)
		disableElement("COModel",false)
	}
	else if ((item.TRowID==1)) 
	{
		var params=[{name:'Equip',type:1,value:'COSource'},{name:'VUseLoc',type:4,value:'TRRLocDR'},{name:'NeedUseLoc',type:2,value:'1'}]
		singlelookup("COSource","EM.L.Equip",params,GetEquip)
	}
	else
	{
		var params=[{name:'Name',type:1,value:'Name'},{name:'SourceType',type:4,value:'SourceType'},{name:'CheckDate',type:4,value:'CheckDate'}]
		singlelookup("Name","EM.L.GetContractList",params,GetContractList)
	}
}
function GetMasterItem(item)
{
	setElement("COSourceID",item.TRowID);	
	setElement("COItem",item.TName);
	setElement("COItemDR",item.TRowID);	
	var SourceType=getElementValue("COItemDR")
	var Params=[{name:'ItemDR',type:4,value:'COItemDR'},{name:'Name',type:4,value:'COModel'}]
	singlelookup("COModel","PLAT.L.Model",Params,GetModel)
	
}
function GetModel(item)
{			
	setElement("COModelDR",item.TRowID); 			
}

function GetEquip(item)
{
	setElement("COSourceID",item.TRowID);		
	setElement("COItem",item.TName);
	setElement("COItemDR",item.TItemDR);
	setElement("COModel",item.TModel); 
	setElement("COModelDR",item.TModelDR);			
}
function GetUser(GetUser)
{
	setElement("GetUser",item.TUTrainUserDR);					
}
//选择框选择事件
function setSelectValue(elementID,rowData)
{
	if(elementID=="TSLoc") {setElement("TSLocDR",rowData.TRowID)}
	else if(elementID=="TUTrainUser") {setElement("TUTrainUserDR",rowData.TRowID)}
	//else if(elementID=="RProviderDR_VDesc") {setElement("RProviderDR",rowData.TRowID)}
	//else if(elementID=="ROutTypeDR_OTDesc") {setElement("ROutTypeDR",rowData.TRowID)}
}
function onClickRow(index,data)
{
	$("#tDHCEQTrainingUser").datagrid('validateRow', index)
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$("#tDHCEQTrainingUser").datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
//			modifyBeforeRow = $.extend({},$("#tDHCEQTrainingUser").datagrid('getRows')[editIndex]);
//			bindGridEvent(); //编辑行监听响应
		} else {
			$("#tDHCEQTrainingUser").datagrid('selectRow', editIndex);
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
	if ($("#tDHCEQTrainingUser").datagrid('validateRow', editIndex))
	{
		$("#tDHCEQTrainingUser").datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
//获取列表明细
function GetTableInfo()
{
	var valList="";
	if (editIndex != undefined){ $("#tDHCEQTrainingUser").datagrid('endEdit', editIndex);}
	var rows = $("#tDHCEQTrainingUser").datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		/* modified by csj 2020-06-08 多余代码片段
		RowNo=i+1
		var TSLRowID=(typeof rows[i].TSLRowID == 'undefined') ? "" : rows[i].TSLRowID
		var TSLTrainingScoreDR=(typeof rows[i].TSLTrainingScoreDR == 'undefined') ? "" : rows[i].TSLTrainingScoreDR
		var TSLTrainUserDR=(typeof rows[i].TSLTrainUserDR == 'undefined') ? "" : rows[i].TSLTrainUserDR
		var TSLScore=(typeof rows[i].TSLScore == 'undefined') ? "" : rows[i].TSLScore
		var TSLForms=(typeof rows[i].TSLForms == 'undefined') ? "" : rows[i].TSLForms
		var TSLPassFlag=(typeof rows[i].TSLPassFlag == 'undefined') ? "" : rows[i].TSLPassFlag
		var TSLRemark=(typeof rows[i].TSLRemark == 'undefined') ? "" : rows[i].TSLRemark
		*/
//		if (CheckInvalidData(i)) return -1;
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
		messageShow('alert','error','提示',t[-9248]);	//"列表明细不能为空!"
		return -1;
	}
	return valList;
}
//function CheckInvalidData(i)
//{
//	var rows = $("#tDHCEQTrainingUser").datagrid('getRows');
//	var oneRow=rows[i]
//	var RowNo=i+1
//	if ((oneRow.BPLPriceFee=="")||(IsValidateNumber(oneRow.TSLScore,0,1,0,0)==0))
//	{
//		messageShow('alert','error','提示',t[-9245].replace('[RowNo]',RowNo));	//成绩不正确
//		return "-1";
//	}
//	return false;
//}
function IsValidateNumber(NumStr,AllowEmpty,AllowDecimal,AllowNegative,AllowZero)
{
	if (NumStr=="")
	{
		if (AllowEmpty=="1")
		{
			return "1";
		}
		else
		{
			return "0";
		}
	}
	if (isNaN(NumStr)) return "0";
	//判断是否负数
	if ((NumStr<0)&&(AllowNegative!="1")) return "0";
	//判断是否整数
	if ((parseInt(NumStr)!=NumStr)&&(AllowDecimal!="1")) return "0";
	if ((parseFloat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}
function checkboxTSLPassFlagChange(TSLPassFlag,rowIndex)
{
	var row = $("#tDHCEQTrainingUser").datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TSLPassFlag==key)
			{
				//modified by csj 2020-06-08 需求号：1354074
				if ((val=="N"||val=="")) row.TSLPassFlag="Y" 
				else row.TSLPassFlag="N"
			}
		})
	}
}