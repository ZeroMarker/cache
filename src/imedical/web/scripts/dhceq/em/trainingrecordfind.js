var columns=getCurColumnsInfo('EM.G.TrainingRecord','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����
var frozencolumns=getCurColumnsInfo('EM.G.TrainingRecord','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����
//�������
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
//��ʼ����ѯͷ���
function initTopPanel()
{ 	initLookUp();
	initButton(); //��ť��ʼ��

	initButtonWidth();
	jQuery('#BAdd').on("click", BAdd_Clicked);
	defindTitleStyle();
	initDHCEQEquipList();	

}


function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSTraining",   //Modefied by zc0044 2018-11-22 �޸�query����
	        QueryName:"GetTrainingRecord",
	        StartDate:getElementValue("TrainStartDate"),
	        EndDate:getElementValue("CO_TrainEndDate"),
	        Status:getElementValue("Status"),
	        CourseName:getElementValue("CourseName"),
	        LocDR:getElementValue("LocDR"),
	        Institution:getElementValue("Institution"),
	        TrainPlace:getElementValue("TrainPlace"),
	        SourceType:getElementValue("SourceTypeDR"),
	        SourceID:getElementValue("SourceID"),
	        TrainingUser:getElementValue("TrainingUser"),
	        ItemDR:getElementValue("ItemDR"),
//	        ModelDR:getElementValue("ModelDR"),
//	        ReadOnly:getElementValue("ReadOnly"),
	    },
	    fit:true,
		striped : true,
	    cache: false,
		//fitColumns:true,
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
		onDblClickRow:function(rowIndex, rowData)
		{	
			if (rowData.TRowID!=""){
				//add by zx 2018-12-12 ������ʽ����
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
				var str="dhceq.em.trainingrecordlist.csp?&RowID="+rowData.TRowID;
				//Modefied by zc 2018-12-28  zc0048 �޸ĵ�����ʾ��С
				showWindow(str,"ҽ���豸����ʹ����ѵ��¼��ϸ","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
				//Modefidy by zc0046 �޸ĵ����ڲ�ͬ�ֱ��ʵ�����������
			}
		},
});
}

function BFind_Clicked()
{  
	initDHCEQEquipList()
}

function BAdd_Clicked()
{
	url="dhceq.em.trainingrecordlist.csp"
	title="ҽ���豸����ʹ����ѵ��¼��ϸ"
	showWindow(url,title,"","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
//ѡ���ѡ���¼�
function setSelectValue(elementID,rowData)
{
	if(elementID=="UseLoc") {setElement("LocDR",rowData.TRowID)}
	//else if(elementID=="RProviderDR_VDesc") {setElement("RProviderDR",rowData.TRowID)}
	//else if(elementID=="ROutTypeDR_OTDesc") {setElement("ROutTypeDR",rowData.TRowID)}
}
function GetSourceType(item)
{
	setElement("SourceTypeDR",item.TRowID); 	
	if ((item.TRowID==0)){   //�豸��
		singlelookup("Source","EM.L.GetMasterItem","",GetMasterItem)
		disableElement("Model",false)
	}
	else if ((item.TRowID==1)) 
	{
		var params=[{name:'Equip',type:1,value:'Source'}]
		singlelookup("Source","EM.L.Equip",params,GetEquip)
	}
	else
	{
		var params=[{name:'Name',type:1,value:'Name'},{name:'SourceType',type:4,value:'SourceType'},{name:'CheckDate',type:4,value:'CheckDate'}]
		singlelookup("Source","EM.L.GetContractList",params,GetContractList)
	}
}
function GetMasterItem(item)
{
	setElement("SourceID",item.TRowID);	
	setElement("Item",item.TName);
	setElement("ItemDR",item.TRowID);	
	var SourceType=getElementValue("ItemDR")
	var Params=[{name:'ItemDR',type:4,value:'ItemDR'},{name:'Name',type:4,value:'Model'}]
//	singlelookup("Model","PLAT.L.Model",Params,GetModel)
	
}
function GetModel(item)
{			
	setElement("ModelDR",item.TRowID); 			
}

function GetEquip(item)
{
	setElement("SourceID",item.TRowID);		
	setElement("Item",item.TName);
	setElement("ItemDR",item.TItemDR);
	setElement("Model",item.TModel); 
	setElement("ModelDR",item.TModelDR);			
}
function clearData(elementID)
{
	if(elementID=="UseLoc"){
		setElement("LocDR",'')
	}
	else if(elementID=="Source"){

		setElement("SourceID",'')
		setElement("ItemDR",'')
	}
	else if(elementID=="SourceType"){
		setElement("SourceID",'')
		setElement("SourceTypeDR",'')
		setElement("Source",'')
		setElement("ItemDR",'')
		
	}
//	else{
//		setElement(elementID.split("_")[0],'')
//	}
//	setElement(elementID.split("_")[0],'')
	return;
}