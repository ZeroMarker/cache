var columns=getCurColumnsInfo('RM.G.Rent.RentListFind','','','');
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	initStatusData();
	initButton(); //��ť��ʼ��
	initButtonWidth();
	$HUI.datagrid("#tDHCEQRentList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSRent",
			QueryName:"GetRentList",
			RequestLocDR:getElementValue("RequestLocDR"),
			FromLocDR:getElementValue("FromLocDR"),
			ItemDR:'',
			BeginDate:getElementValue("BeginDate"),
			EndDate:getElementValue("EndDate"),
			RequestNo:getElementValue("RequestNo"),
			StatusDR:getElementValue("StatusDR"),
			CurUser:'',
			Name:getElementValue("Name")
		},
		border:false,
	    fit:true,
	    fitColumns:true,  //modify by lmm 2020-06-06 UI
	    singleSelect:true,
	    rownumbers: true,
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
			
		}
	});
}

function initStatusData()
{
	var Status = $HUI.combobox('#StatusDR',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '����'
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: '���'
			},{
				id: '3',
				text: '�黹'
			}]
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQRentList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSRent",
			QueryName:"GetRentList",
			RequestLocDR:getElementValue("RequestLocDR"),
			FromLocDR:getElementValue("FromLocDR"),
			ItemDR:'',
			BeginDate:getElementValue("BeginDate"),
			EndDate:getElementValue("EndDate"),
			RequestNo:getElementValue("RequestNo"),
			StatusDR:getElementValue("StatusDR"),
			CurUser:'',
			Name:getElementValue("Name")
		}
	});
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}