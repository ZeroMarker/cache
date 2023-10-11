var columns=getCurColumnsInfo('PLAT.G.DT3D.Building','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	jQuery("#BImport").linkbutton({iconCls: 'icon-w-import'});
	jQuery("#BImport").on("click", BImport_Clicked);
	$HUI.datagrid("#buildingfind",{   
	   	url:$URL, 
		idField:'TRowID', //主键  
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCDT3D.BUSBuilding",
	        QueryName:"GetBuildingList",
	        EquipDR:getElementValue("EquipDR"),
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	//End By QW20181225 需求号:786608
	var TBuildName=$("#buildingfind").datagrid('getColumnOption','TBuildName');
	TBuildName.formatter=	function(value,row,index){
		return BuildNameOperation(value,row,index)	
	}	    
	var TBuildingUnit=$("#buildingfind").datagrid('getColumnOption','TBuildingUnit');
	TBuildingUnit.formatter=	function(value,row,index){
		return BuildingUnitOperation(value,row,index)	
	}
}

function BuildNameOperation(value,row,index)
{
	var btn=""
	var para="&EquipDR="+row.TEquipDR;
	var url="dhceq.em.building.csp?";
	var title="建筑信息"
		
	url=url+para;
	var icon="icon-w-paper"	 //modify by lmm 2018-11-14
	var type=""	 //modify by lmm 2018-11-14
	//modified by csj 20181128 需求号:762692
	//modify by lmm 2020-0202-06-05 UI
	btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;7row&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;middle&quot;)" href="#">'+row.TBuildName+'</A>';
	return btn;
}

function BFind_Clicked()
{
	$HUI.datagrid("#buildingfind",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCDT3D.BUSBuilding",
        QueryName:"GetBuildingList",
        EquipDR:getElementValue("EquipDR"),
	    },
	});
	
}
function BuildingUnitOperation(value,row,index)
{
	var btn=""
	var para="&FBuildingDR="+row.TRowID;
	var url="dhceqbu.em.buildingunit.csp?";
	var title="建筑单元"
		
	url=url+para;
	var icon="icon-w-paper"	
	var type=""	 
	btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>';
	return btn;
	
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)

}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

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
function BImport_IE()
{
	MaintPlanIDs=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	//xlsheet =xlBook.Worksheets("楼层房屋");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var BUBuildingDR_BDBuildKey=trim(xlsheet.cells(Row,Col++).text);  //建筑编号
		var BUFloorIndex=trim(xlsheet.cells(Row,Col++).text);  //楼层编号
		var BUDoorNo=trim(xlsheet.cells(Row,Col++).text);	//门牌号
		var BUDesc=trim(xlsheet.cells(Row,Col++).text);	//描述
		var BUBuildingArea=trim(xlsheet.cells(Row,Col++).text);	//建筑面积
		var BUUtilizationArea=trim(xlsheet.cells(Row,Col++).text);	//使用面积
		var BUUseLoc=trim(xlsheet.cells(Row,Col++).text); //使用科室
		var BUStuct=trim(xlsheet.cells(Row,Col++).text); //结构
		var BUUnitType=trim(xlsheet.cells(Row,Col++).text);	//建筑单元类型
		var BUStatus=trim(xlsheet.cells(Row,Col++).text);	//状态
		var BUContractPersonDR=trim(xlsheet.cells(Row,Col++).text); 	//负责人
		var BUPurpose=trim(xlsheet.cells(Row,Col++).text);  //用途
		var BUOriginalFee=trim(xlsheet.cells(Row,Col++).text); //原值
		var BUOrigin=trim(xlsheet.cells(Row,Col++).text); //来源
		var BUChange=trim(xlsheet.cells(Row,Col++).text);	//变更类型
		var BUDateFrom=trim(xlsheet.cells(Row,Col++).text);	//开始日期
		var BUDateTo=trim(xlsheet.cells(Row,Col++).text);	//结束日期
		var BURoomFacing=trim(xlsheet.cells(Row,Col++).text);	//房间朝向
		var BUMinPeople=trim(xlsheet.cells(Row,Col++).text);	//最小容纳人数
		var BUMaxPeople=trim(xlsheet.cells(Row,Col++).text);	//最大容纳人数


		if (BUBuildingDR_BDBuildKey=="")
		{
			alertShow("建筑编号不能为空!");
		    return 0;
		}
		if (BUFloorIndex=="")
		{
			alertShow("楼层编号不能为空!");
		    return 0;
		}
		if (BUDoorNo=="")
		{
			alertShow("门牌号不能为空!");
		    return 0;
		}
		if (BUDesc=="")
		{
			alertShow("描述不能为空!");
		    return 0;
		}
		if (BUUseLoc!="")
		{
			var BUUseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",BUUseLoc);
			if (BUUseLocDR=="")
			{
				alertShow("第"+Row+"行 使用科室信息不正确:"+BUUseLoc);
				return 0;
			}
		}
		var BUBuildingDR=tkMakeServerCall("web.DHCDT3D.BUSBuilding","GetBuildingID",BUBuildingDR_BDBuildKey);
		if (BUBuildingDR=="")
		{
			alertShow("第"+Row+"行 建筑编号信息不正确:"+BUBuildingDR_BDBuildKey);
			return 0;
		}
		
		//var combindata={};
		var combindata={"BUBuildingDR":BUBuildingDR,"BUStatus":BUStatus,"BUUnitType":BUUnitType,"BUStuct":BUStuct,"BUUseLocDR":BUUseLocDR,"BUUtilizationArea":BUUtilizationArea,"BUBuildingArea":BUBuildingArea,"BUDesc":BUDesc,"BUFloorIndex":BUFloorIndex,"BUMaxPeople":BUMaxPeople,"BUMinPeople":BUMinPeople,"BURoomFacing":BURoomFacing,"BUDateTo":BUDateTo,"BUDateFrom":BUDateFrom,"BUChange":BUChange,"BUOrigin":BUOrigin,"BUDoorNo":BUDoorNo,"BUContractPersonDR":BUContractPersonDR,"BUPurpose":BUPurpose,"BUOriginalFee":BUOriginalFee}
		var combindata=JSON.stringify(combindata)
		var Rtn = tkMakeServerCall("web.DHCDT3D.Common", "SaveJsonData","",combindata,"User.DHCEQBuildingUnit");
		var SQLCODE=Rtn.split("^")[0]
		if (SQLCODE<0)
		{
			alertShow("第"+Row+"行 <"+xlsheet.cells(Row,4).text+"> 信息导入失败!!!dddd请载剪该行信息重新整理后再次导入该行信息.");;
		}
	}

			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("导入操作完成!请核对相关信息.");
			window.location.reload();
			return;
		

//			xlsheet.Quit;
//			xlsheet=null;
//			xlBook.Close (savechanges=false);
//			xlApp=null;
//			alertShow("导入计划信息操作完成!请核对相关信息.");
//			window.location.reload();	
}