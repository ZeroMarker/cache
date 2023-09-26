//instrumentlist.js
//modify by wl 2020-03-05 ���������
var Columns=getCurColumnsInfo('BA.L.Device','','','');
$(function(){
	initDocument();
});
//modify by wl 2020-03-05 �޸�web��
function initDocument()
{
	initDeviceSourceDR(); 
	initButton(); //��ť��ʼ��
	initButtonWidth();
		initLookUp();
	defindTitleStyle();
		$HUI.datagrid("#tinstrumentlist",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSDeviceMap",
	        	QueryName:"Device",
	        	DeviceDesc:getElementValue("DeviceDesc"),
	        	DeviceSourceDR:getElementValue("DeviceSourceDR"),
		},
		rownumbers: false,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:false,
		fit:true,
		fitColumns:true,  //modify by lmm 2020-06-06 UI
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,20,75,100]
		});	
	
}
function initDeviceSourceDR()
{ 
			var DeviceSourceDR = $HUI.combobox("#DeviceSourceDR",{
				valueField:'id', textField:'text',panelHeight:"auto",
				data:[
					 {id:'��ѡ����Դ',text:'��ѡ����Դ',selected:true}
					,{id:'DHC-LIS',text:'DHC-LIS'}
					,{id:'DHC-RIS',text:'DHC-RIS'}	
				],
			});   	
   		
}
//modify by wl 2020-03-05 �޸�web��
function BFind_Clicked()
{ 
		$HUI.datagrid("#tinstrumentlist",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSDeviceMap",
	        	QueryName:"Device",
	        	DeviceDesc:getElementValue("DeviceDesc"),
	        	DeviceSourceDR:getElementValue("DeviceSourceDR"),
		},
		rownumbers: false,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:false,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,20,75,100]
		});	
	
}

///modified by zy  ZY0225 2020-04-27
function BPrint_Clicked()
{
	var PrintFlag=getElementValue("PrintFlag");
	var DeviceDesc=getElementValue("DeviceDesc");
	var DeviceSourceDR=getElementValue("DeviceSourceDR");
	if (DeviceSourceDR=="")  return;
	if(PrintFlag==0)
	{
		//
	}
	else if(PrintFlag==1)
	{
		var PreviewRptFlag=getElementValue("PreviewRptFlag");
		var fileName=""	;
        if(PreviewRptFlag==0)
        {
	        fileName="{DHCEQLisRisDevice.raq(DeviceDesc="+DeviceDesc+";DeviceSourceDR="+DeviceSourceDR+")}";
	        DHCCPM_RQDirectPrint(fileName);
        }
        else if(PreviewRptFlag==1)
        { 
	        fileName="DHCEQLisRisDevice.raq&DeviceDesc="+DeviceDesc+"&DeviceSourceDR="+DeviceSourceDR;
	        DHCCPM_RQPrint(fileName);
        }
	}
}