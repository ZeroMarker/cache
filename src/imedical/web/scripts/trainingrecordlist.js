var columns=getCurColumnsInfo('EM.G.TrainingUser','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var columns2=getCurColumnsInfo('EM.G.TrainingScoreList','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var frozencolumns=getCurColumnsInfo('EM.G.TrainingUser','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 修复页面不显示输出列
var select=""
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
{ 	
	initLookUp();
	initMessage();
	initButtonWidth();
	initButton(); //按钮初始化
	//jQuery('#BFind').on("click", BFind_Clicked);
	//initStatusData();
	defindTitleStyle();
	//initTrainingScoreList();
	fillData();
	initTrainingUser();	
	setEnabled();
    setRequiredElements("COName^COSourceTypeDesc^COSource")
    disableElement("SelectCourse",!getElementValue("NewCourceFlag"))
    $("#NewCourceFlag").checkbox({
		onCheckChange:function(e,v){
			disableElement("SelectCourse",!v)
		}
	})
}
/*
function OpenDetail(value,row)  //查看使用培训记录
{
	var str=row.TRowID;
	var str="rowid="+str;
	var btn='<A onclick="window.open(&quot;dhceq.em.trainingrecordlist.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>'
	return btn;
}
function OpenScore(value,row)  //查看考核信息
{
	var str=row.RowID;
	var str="rowid="+str;
	var btn='<A onclick="window.open(&quot;dhceq.em.traininguserscorelist.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>'
	return btn;
}
*/
//填充数据
function fillData()
{
	TRRRowID=getElementValue("TRRRowID");
	if (TRRRowID=="") return;
//	$("#NewCourceFlag").disable()
	$("#NewCourceFlag").checkbox("options").disabled=true
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","GetOneTrainingRecord",TRRRowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	CORowID=getElementValue("CORowID");
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","GetOneCourse",CORowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);return;}
	setElementByJson(jsonData.Data); 
	setElement("SelectCourse",jsonData.Data.COName)
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
	var TRRStatus=getElementValue("TRRStatus");
	
	if(TRRStatus=="")
	{
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("AddScoreList",true)
		disableElement("add",true)
		disableElement("ScoreList",true)
	}
	else if(TRRStatus=="0")
	{
//		disableElement("BSubmit",true);
//		disableElement("AddScoreList",true)
		disableElement("AddScoreList",true)

	}else if(TRRStatus=="2")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		disableElement("add",true)
	}
}
function initTrainingUser()
{
	$HUI.datagrid("#tDHCEQTrainingUser",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSTraining",   //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetTrainingUser",
	        TRDR:getElementValue("TRRRowID"),
	        TRRStage:getElementValue("TRRStage"),
	        ReadOnly:getElementValue("ReadOnly"),
	    },
	    fit:true,
		striped : true,
	    cache: false,
	    singleSelect:true,
		//fitColumns:true,
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
		toolbar:[{
    				iconCls: 'icon-add',
        			text:'新增',	//modify by fx 2022-11-29 	2613004
        			id:'add',
        			handler: function(){
        			BAdd_Clicked();
    			}},
    			{
        			iconCls: 'icon-cancel',
        			text:'删除',
        			id:'delete',
        			handler: function(){
       				BDeleteuser_Click();
    			}},
    			{
        			iconCls: 'icon-add',   //modify by lmm 2021-03-09 1788483
        			text:'新增考核记录',	//modify by fx 2022-11-29 	2613004
        			id:'AddScoreList',
        			handler: function(){
       				BAddScoreList_Click();
    			}},
    			{
        			iconCls: 'icon-paper',   //modify by lmm 2021-03-09 1788483
        			text:'历史考核记录',
        			id:'ScoreList',
        			handler: function(){
       				BScoreList_Click();
    			}}],
		onDblClickRow:function(rowIndex, rowData)
		{	
//			BDeleteuser_Click();
		},
		onClickRow:function(rowIndex,rowData){
			if(getElementValue("TRRStatus")=="0")
			if (rowData.TRowID!=""&&select!==rowIndex){
				select=rowIndex
				setElement("TUTrainUserDR",rowData.TTrainUserDR);
				setElement("TUTrainUser",rowData.TTrainUser);
				setElement("TURemark",rowData.TRemark);
				setElement("TURowID",rowData.TRowID);
				disableElement("delete",false)
			}else{
				select=""
				setElement("TUTrainUserDR","");
				setElement("TUTrainUser","");
				setElement("TURemark","");
				setElement("TURowID","");
				disableElement("delete",true)
			}
		},
		onLoadSuccess: function (data) {

		},
		
	});
	disableElement("delete",true)

}
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	//add by csj 2020-05-27 
	if(getElementValue("COSourceType")=="")
 	{
	 	messageShow("alert","error","提示","来源类型"+t[-9201]);
	 	return
	}
	disableElement("BSave",true) //add by csj 2020-06-08 防止新增多次 需求号：1356167
 	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingRecord",data,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data;
		url="dhceq.em.trainingrecordlist.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;

	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-06-08 保存失败后解禁
		messageShow("alert","error","错误提示",t[-9200]+jsonData.Data);
		return
    }	
}
function BSubmit_Clicked()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SubmitTrainingRecord",getElementValue("TRRRowID"));
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
		TRRRowID=getElementValue("TRRRowID");
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingRecord",TRRRowID,"1");
		jsonData=JSON.parse(jsonData)

		if (jsonData.SQLCODE<0)
		{
			messageShow('alert','error','提示',t[-9200]+jsonData.Data);
			return
	    }
	    else
	    {
		    url="dhceq.em.trainingrecordlist.csp";
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
	    	window.location.href= url;
		}

	}
	
	function Cancel(){
		return
	}	
}
function BAdd_Clicked()
{
//	if(checkMustItemNull()){return;}
 	if(getElementValue("TUTrainUserDR")=="")
 	{
	 	messageShow("alert","error","提示","培训人员姓名"+t[-9201]);
	 	return
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingUser",data,"0");
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
	if(elementID=="TRRLoc") {setElement("TRRLocDR",rowData.TRowID)}
	else if(elementID=="TUTrainUser") 
	{
		setElement("TUTrainUserDR",rowData.TRowID)
		setElement("TURemark",tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID",'mobilephone',rowData.TRowID))
	}
	else if(elementID=="SelectCourse") 
	{
		setElement("CORowID",rowData.TRowID)
		setElement("SelectCourse",rowData.TCOName)
		setElement("COName",rowData.TCOName)
		//setElement("COInstitution",rowData.TCOInstitution)
		setElement("COSourceType",rowData.TCOSourceType)
		setElement("COSourceTypeDesc",rowData.TCOSourceTypeDesc)
		setElement("COSourceID",rowData.TCOSourceID)
		setElement("COSource",rowData.TSourceIDDesc)
		setElement("COItemDR",rowData.TCOItemDR)
		setElement("COItem",rowData.TCOItemDesc)
		setElement("COModelDR",rowData.TCOModelDR)
		setElement("COModel",rowData.TCOModelDesc)
		setElement("COCourseContent",rowData.TCOCourseContent)
		setElement("COTrainObj",rowData.TCOTrainObj)
		setElement("CORemark",rowData.TCORemark)
		
	}
	//else if(elementID=="RProviderDR_VDesc") {setElement("RProviderDR",rowData.TRowID)}
	//else if(elementID=="ROutTypeDR_OTDesc") {setElement("ROutTypeDR",rowData.TRowID)}
}

function clearData(elementID)
{
	if(elementID=="TUTrainUser"){
		setElement("TUTrainUserDR",'')
	}
//	else if(elementID=="Source"){
//
//		setElement("SourceID",'')
//		setElement("ItemDR",'')
//	}
//	else if(elementID=="SourceType"){
//		setElement("SourceID",'')
//		setElement("SourceTypeDR",'')
//		setElement("Source",'')
//		setElement("ItemDR",'')
//		
//	}else{
//		setElement(elementID.split("_")[0],'')
//	}
//	setElement(elementID.split("_")[0],'')
	return;
}
function BAddScoreList_Click()
{
	url="dhceq.em.trainingscorelist.csp?&CORowID="+getElementValue("CORowID")+"&TRRRowID="+getElementValue("TRRRowID")+"&TRRStage="+getElementValue("TRRStage")
	title="医疗设备操作使用考核记录明细"
	showWindow(url,title,"","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}

function BScoreList_Click()
{
	url="dhceq.em.trainingscore.csp?&CORowID="+getElementValue("CORowID")+"&TRRRowID="+getElementValue("TRRRowID")+"&TRRStage="+getElementValue("TRRStage")
	title="医疗设备操作使用考核历史记录明细"
	showWindow(url,title,"","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
function BDeleteuser_Click()
{
	
	if(getElementValue("TURowID"))
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSTraining","SaveTrainingUser",getElementValue("TURowID"),"1");
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
}
// MZY0121	2585224		2022-04-15
//元素参数重新获取值
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return getElementValue("EquipTypeDR")}
}
