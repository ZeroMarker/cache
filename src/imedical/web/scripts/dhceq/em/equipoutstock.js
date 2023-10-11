////add by txr 2023-03-15��������
var columns=getCurColumnsInfo('EM.G.Return.BatchReturn','','','','N'); 
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by zx 2019-05-05 �������Ч��Ӱ�� ZX0063
});
function initDocument()
{
	initUserInfo();
    initMessage("Return"); 
	setElement("RFromLocDR",getElementValue("RFromLocDR"));
	setElement("RFromLocDR_CTLOCDesc",getElementValue("RFromLoc"));
	setElement("ROutTypeDR",getElementValue("ROutTypeDR"));   //add by txr 20230512 3477416
	setElement("ROutTypeDR_CTDesc",getElementValue("ROutType"));  //add by txr 20230512 3477416
	defindTitleStyle();
	initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"RFromLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("RFromLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	initButton(); //��ť��ʼ��
	initButtonWidth();
	setRequiredElements("RFromLocDR_CTLOCDesc^ROutTypeDR_CTDesc"); //������ modifed by txr 20230512 3477416
	setEnabled();
	//table���ݼ���
	$HUI.datagrid("#DHCEQEquipReturn",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSReturn",
			QueryName:"GetBatchReturn",
			RRowIDs:getElementValue("RRowIDs"),
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    toolbar:[
		    {
				iconCls: '',
	            text:'',
	            id:'add',
	        },'----------',],
	    columns:columns,
		fitColumns:true,   //modify by lmm 2020-06-04 UI
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10],
		onLoadSuccess:function(){
				creatToolbar();
			}
	});
};

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var TotalFee=parseFloat(getElementValue("TotalFee"))
	var lable_innerText='������:'+getElementValue("Length")+'&nbsp;&nbsp;&nbsp;�ܽ��:'+TotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}

function setEnabled()
{
	var RRowIDs=getElementValue("RRowIDs")
	if (RRowIDs!="")
	{
		disableElement("BSave",true);
	}
}

function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var RFromLocDR=getElementValue("RFromLocDR")
	var RowIDs=getElementValue("RowIDs")
	var ROutTypeDR=getElementValue("ROutTypeDR")
	var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSReturn","BatchReturn",RFromLocDR,RowIDs,ROutTypeDR);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RRowIDs="+jsonData.Data
		val=val+"&RowIDs="+RowIDs
		val=val+"&QXType="+getElementValue("QXType")
		val=val+"&WaitAD="+getElementValue("WaitAD")
		val=val+"&CurRole="+getElementValue("CurRole")
		val=val+"&CancelOper="+getElementValue("CancelOper")
		val=val+"&ROutTypeDR="+getElementValue("ROutTypeDR")  //add by txr 20230512 3477416
		var url="dhceq.em.equipoutstock.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }

}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}
