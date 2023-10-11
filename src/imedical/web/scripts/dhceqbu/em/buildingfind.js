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
		idField:'TRowID', //����  
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
	//End By QW20181225 �����:786608
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
	var title="������Ϣ"
		
	url=url+para;
	var icon="icon-w-paper"	 //modify by lmm 2018-11-14
	var type=""	 //modify by lmm 2018-11-14
	//modified by csj 20181128 �����:762692
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
	var title="������Ԫ"
		
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
	//xlsheet =xlBook.Worksheets("¥�㷿��");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var BUBuildingDR_BDBuildKey=trim(xlsheet.cells(Row,Col++).text);  //�������
		var BUFloorIndex=trim(xlsheet.cells(Row,Col++).text);  //¥����
		var BUDoorNo=trim(xlsheet.cells(Row,Col++).text);	//���ƺ�
		var BUDesc=trim(xlsheet.cells(Row,Col++).text);	//����
		var BUBuildingArea=trim(xlsheet.cells(Row,Col++).text);	//�������
		var BUUtilizationArea=trim(xlsheet.cells(Row,Col++).text);	//ʹ�����
		var BUUseLoc=trim(xlsheet.cells(Row,Col++).text); //ʹ�ÿ���
		var BUStuct=trim(xlsheet.cells(Row,Col++).text); //�ṹ
		var BUUnitType=trim(xlsheet.cells(Row,Col++).text);	//������Ԫ����
		var BUStatus=trim(xlsheet.cells(Row,Col++).text);	//״̬
		var BUContractPersonDR=trim(xlsheet.cells(Row,Col++).text); 	//������
		var BUPurpose=trim(xlsheet.cells(Row,Col++).text);  //��;
		var BUOriginalFee=trim(xlsheet.cells(Row,Col++).text); //ԭֵ
		var BUOrigin=trim(xlsheet.cells(Row,Col++).text); //��Դ
		var BUChange=trim(xlsheet.cells(Row,Col++).text);	//�������
		var BUDateFrom=trim(xlsheet.cells(Row,Col++).text);	//��ʼ����
		var BUDateTo=trim(xlsheet.cells(Row,Col++).text);	//��������
		var BURoomFacing=trim(xlsheet.cells(Row,Col++).text);	//���䳯��
		var BUMinPeople=trim(xlsheet.cells(Row,Col++).text);	//��С��������
		var BUMaxPeople=trim(xlsheet.cells(Row,Col++).text);	//�����������


		if (BUBuildingDR_BDBuildKey=="")
		{
			alertShow("������Ų���Ϊ��!");
		    return 0;
		}
		if (BUFloorIndex=="")
		{
			alertShow("¥���Ų���Ϊ��!");
		    return 0;
		}
		if (BUDoorNo=="")
		{
			alertShow("���ƺŲ���Ϊ��!");
		    return 0;
		}
		if (BUDesc=="")
		{
			alertShow("��������Ϊ��!");
		    return 0;
		}
		if (BUUseLoc!="")
		{
			var BUUseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",BUUseLoc);
			if (BUUseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ÿ�����Ϣ����ȷ:"+BUUseLoc);
				return 0;
			}
		}
		var BUBuildingDR=tkMakeServerCall("web.DHCDT3D.BUSBuilding","GetBuildingID",BUBuildingDR_BDBuildKey);
		if (BUBuildingDR=="")
		{
			alertShow("��"+Row+"�� ���������Ϣ����ȷ:"+BUBuildingDR_BDBuildKey);
			return 0;
		}
		
		//var combindata={};
		var combindata={"BUBuildingDR":BUBuildingDR,"BUStatus":BUStatus,"BUUnitType":BUUnitType,"BUStuct":BUStuct,"BUUseLocDR":BUUseLocDR,"BUUtilizationArea":BUUtilizationArea,"BUBuildingArea":BUBuildingArea,"BUDesc":BUDesc,"BUFloorIndex":BUFloorIndex,"BUMaxPeople":BUMaxPeople,"BUMinPeople":BUMinPeople,"BURoomFacing":BURoomFacing,"BUDateTo":BUDateTo,"BUDateFrom":BUDateFrom,"BUChange":BUChange,"BUOrigin":BUOrigin,"BUDoorNo":BUDoorNo,"BUContractPersonDR":BUContractPersonDR,"BUPurpose":BUPurpose,"BUOriginalFee":BUOriginalFee}
		var combindata=JSON.stringify(combindata)
		var Rtn = tkMakeServerCall("web.DHCDT3D.Common", "SaveJsonData","",combindata,"User.DHCEQBuildingUnit");
		var SQLCODE=Rtn.split("^")[0]
		if (SQLCODE<0)
		{
			alertShow("��"+Row+"�� <"+xlsheet.cells(Row,4).text+"> ��Ϣ����ʧ��!!!dddd���ؼ�������Ϣ����������ٴε��������Ϣ.");;
		}
	}

			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("����������!��˶������Ϣ.");
			window.location.reload();
			return;
		

//			xlsheet.Quit;
//			xlsheet=null;
//			xlBook.Close (savechanges=false);
//			xlApp=null;
//			alertShow("����ƻ���Ϣ�������!��˶������Ϣ.");
//			window.location.reload();	
}