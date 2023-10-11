var columns=getCurColumnsInfo('PLAT.G.Location','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
var PreSelectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
//�������
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);

//��ʼ������
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); //Ĭ��Style
	initMessage();
	initPage();			//�Ŵ󾵼���ť��ʼ��
	setEnabled();		//��ť����
	initBDPHospComponent("DHC_EQCLocation");	//��Ժ������
	if (HospFlag==2)
	{
		hiddenObj("LHospital",true);
		hiddenObj("cLHospital",true);
	}
}

//ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initMaindatagrid();
}

//��ʼ����ť״̬
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}

//ѡ���а�ť״̬
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
//��ʼ���Ŵ󾵡���ʼ����ť
function initPage()
{
	initLookUp();		//��ʼ���Ŵ�
	initButton();		//��ʼ����ť
	initButtonWidth();
	initMaindatagrid();
	setRequiredElements("LCode^LDesc");
}

//�Ŵ�ѡȡ��ִ�з���
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="LHospital"){setElement("LHospitalDR",rowData.TRowID)}
	else if (vElementID=="LLoc"){setElement("LLocDR",rowData.TRowID)}
}

//��ѯ��ť����¼�
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTLocaton",
			QueryName:"GetLocationDetails",
			Code:getElementValue("LCode"),
			Desc:getElementValue("LDesc")
		}
	});
}

//������GRID
function initMaindatagrid()
{
	$(function(){
		$HUI.datagrid('#maindatagrid',{
			url:$URL,
			queryParams:{
        				ClassName:"web.DHCEQ.Plat.CTLocaton",
        				QueryName:"GetLocationDetails",
        				gHospId:curSSHospitalID,
        				BDPHospId:GetBDPHospValue("_HospList")
    			},
			onSelect:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
			
			onLoadSuccess:function(data){

			},
			autoSizeColumn:true,
			fitColumns:true,
			cache: false,
			columns:columns,
			//idField:'id',
			pagination:true,
			pageSize:15,
			pageNumber:1,
			pageList:[15,30,60,100,200],
			//rownumbers:true,
			singleSelect:true
		})
	})		
}

//������¼�
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("LRowID",rowData.TRowID);
		setElement("LCode",rowData.TCode);
		setElement("LDesc",rowData.TDesc);
		setElement("LPlace",rowData.TPlace);
		setElement("LRemark",rowData.TRemark);
		setElement("LHospital",rowData.THospital);
		setElement("LLoc",rowData.TLoc);
		setElement("LHospitalDR",rowData.THospitalDR);
		setElement("LLocDR",rowData.TLocDR);
		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}	
}

//���Lookup
function clearData(vElementID)
{
 	if (vElementID=="LHospital"){setElement("LHospitalDR","")}
	if (vElementID=="LLoc"){setElement("LLocDR","")}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: ����ɾ������
function BDelete_Clicked()
{
	var truthBeTold = window.confirm("�Ƿ�ɾ��������¼��");
	if (!truthBeTold) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","��ʾ","ɾ���ɹ���");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','��ʾ',"ɾ��ʧ�ܣ�������Ϣ:"+jsonData.Data);
	}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: �������ӷ���
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"2",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","��ʾ","���ӳɹ���");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','��ʾ',"����ʧ��!������Ϣ:"+jsonData.Data);
	}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: ���ݱ��淽��
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"3",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","��ʾ","����ɹ���");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','��ʾ',"����ʧ�ܣ�������Ϣ:"+jsonData.Data);
	}
}

//��հ�ť�����¼���ȡ��ѡ���д����¼�
function BClear_Clicked()
{
	setElement("LRowID","");
	setElement("LCode","");
	setElement("LDesc","");
	setElement("LPlace","");
	setElement("LRemark","");
	setElement("LHospital","");
	setElement("LLoc","");
	setElement("LHospitalDR","");
	setElement("LLocDR","");
	setEnabled();
	PreSelectedRowID="";
}
