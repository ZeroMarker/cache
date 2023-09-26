var Columns=getCurColumnsInfo('RM.G.Rent.ShareItemList','','','');
//alert(Columns)
var curIndex=-1;  //�����
$(function(){
	initDocument();
});

function initDocument()
{
	disableElement("SILName",true);
	initLookUp();
	initButton();
	initMessage("");
	defindTitleStyle();
	initButtonWidth();
	setRequiredElements("SILItem^SILName");
	$("#BAdd").on("click", BSave_Clicked);
	$HUI.datagrid("#tDHCEQSCShareItemList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemList",
			ShareItemDR:getElementValue("SILShareItemDR"),
			ItemDR:getElementValue("SILItemDR"),
			Name:getElementValue("SILName"),
			ModelDR:getElementValue("SILModelDR"),
			
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    fitColumns:true,
	    columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60],
		onClickRow: function (index, row) {
			fillData(index, row);
		},
		onLoadSuccess:function(){
			setEnabled();
		}
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSCShareItemList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.SCShareItemCat",
			QueryName:"GetShareItemList",
			ShareItemDR:getElementValue("SILShareItemDR"),
			ItemDR:getElementValue("SILItemDR"),
			Name:getElementValue("SILName"),
			ModelDR:getElementValue("SILModelDR"),
			
	    }
	}); 
}

// �������޸�
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	var data=getInputList();
	data=JSON.stringify(data);
	
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",data,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

// add by zx 2020-02-10
// ɾ��
function BDelete_Clicked()
{
	var rowID=getElementValue("SILRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.SCShareItemCat","SaveDataItemList",rowID,"1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		location.reload();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

// add by zx 2020-02-10
// ����к��������
// ���: index,ѡ���к� row,ѡ��������
function fillData(index, row)
{
	
	if (curIndex!=index) 
	{
		
		
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem",row.TItem);
		setElement("SILItemDR",row.TItemDR);
		setElement("SILName",row.TName);
		setElement("SILModel",row.TModel);
		setElement("SILModelDR",row.TModelDR);
		setElement("SILRowID",row.TRowID);
		curIndex = index;
		setEnabled();
	}
	else
	{
		//alert(row.TShareItemDR)
		setElement("SILShareItemDR",row.TShareItemDR);
		setElement("SILItem","");
		setElement("SILItemDR","");
		setElement("SILName","");
		setElement("SILModel","");
		setElement("SILModelDR","");
		setElement("SILRowID","");
		curIndex = -1;
		setEnabled();
	}
}

// add by zx 2020-02-10
// ��ť�һ����ƴ���
function setEnabled()
{
	var SILRowID=getElementValue("SILRowID");
	if (SILRowID!="")
	{
		disableElement("BAdd",true);
		disableElement("BSave",false);
		disableElement("BDelete",false);
	}
	else
	{
		disableElement("BAdd",false);
		disableElement("BSave",true);
		disableElement("BDelete",true);
	}
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID,item.TDesc);
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="SILItem")
	{
		setElement("SILItem",item.TName);
		setElement("SILName",item.TName);
		setElement("SILItemDR",item.TRowID);
		setElement("EQItemDR",item.TRowID);
	}
	if (vElementID=="SILModel")
	{
		setElement("SILModel",item.TName);
		setElement("SILModelDR",item.TRowID);
	}

}