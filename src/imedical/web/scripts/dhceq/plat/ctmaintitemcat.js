var columns=getCurColumnsInfo('PLAT.G.CT.MaintItemCat','','','');
var PreSelectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
//�������
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);
///��ʼ������
function initDocument()
{
	defindTitleStyle(); //Ĭ��Style
	initMessage();
	initPage();			//�Ŵ󾵼���ť��ʼ��
	setEnabled();		//��ť����
}
///��ʼ����ť״̬
function setEnabled()
{
//	disableElement("BSave",true);
	disableElement("BDelete",true);
//	disableElement("BAdd",false);
}
///ѡ���а�ť״̬
function onSelect()
{
//	disableElement("BSave",false);
	disableElement("BDelete",false);
//	disableElement("BAdd",true);
}
//�Ŵ󾵼���ť��ʼ��
function initPage()
{
	initLookUp();		//��ʼ���Ŵ�
	initMICType()
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSave").on("click", BSave_Click);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BDelete").on("click", BDelete_Click);
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Click);
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Click);
	initButtonWidth();
	initDatagrid();
	setRequiredElements("MICCode^MICDesc^MICType")
	
}
function initMICType(){
	$HUI.combobox("#MICType",{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id:'',text:''},
			{id:'1',text:'����'},
			{id:'2',text:'���'},
			{id:'3',text:'ά��'}
		],
	});
}

//���Ұ�ť����¼�
function BFind_Click()
{
	$HUI.datagrid("#DHCEQCMaintItemCat",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTMaintItemCat",
			QueryName:"GetMaintItemCat",
	    	Code:getElementValue("MICCode"),
	    	Desc:getElementValue("MICDesc")
		}
	});
}

function initDatagrid()
{
	$HUI.datagrid('#DHCEQCMaintItemCat',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTMaintItemCat",
			QueryName:"GetMaintItemCat",
			Code:"",
			Desc:""
		},
		onSelect:function(rowIndex,rowData){
			OnClickRow(rowIndex, rowData);
		},
		
		onLoadSuccess:function(data){

		},
		autoSizeColumn:true,
		fitColumns:true,
		fit:true,
		fitColumns:true,
		cache: false,
		border:false,  //modify by lmm 2020-04-02
		columns:columns,
		pagination:true,
		pageSize:10,
	    pageNumber:1,
	    pageList:[10,20,30,40,50],
		rownumbers:true,
		singleSelect:true,

	})	
}

function OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		var TTypeCode=""
		if(rowData.TType=='����'){
			TTypeCode=1
		}else if(rowData.TType=='���'){
			TTypeCode=2
		}else if(rowData.TType=='ά��'){
			TTypeCode=3
		}
		setElement("RowID",rowData.TRowID);
		setElement("MICType",TTypeCode);
		setElement("MICCode",rowData.TCode);
		setElement("MICDesc",rowData.TDesc);
		setElement("MICRemark",rowData.TRemark);
//		setElement("MICInvalidFlag",rowData.TInvalidFlag=="Y"?true:false);modified by csj 20190612
		onSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Click();
		PreSelectedRowID=""
	}
	
}


function BSave_Click()
{
	if(checkMustItemNull()){return;}
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItemCat","SaveData",val,"");
	if (result<0) {
		messageShow("alert","error","������ʾ",result)
		return
	}
	messageShow("alert","success","��ʾ","����ɹ���");
	$HUI.datagrid('#DHCEQCMaintItemCat').reload(); 
	BClear_Click()
}

function BDelete_Click()
{
	var val=Combindata();
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTMaintItemCat","SaveData",val,"1");
	if (result<0) {
		if(result=="-3003"){
			messageShow("alert","error","������ʾ","�����ظ���")
			return
		}
		messageShow("alert","error","������ʾ",result)
		return
	}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
	$HUI.datagrid('#DHCEQCMaintItemCat').reload(); 
	BClear_Click()
}

function BClear_Click()
{
	setElement("RowID","");
	setElement("MICType","");
	setElement("MICCode","");
	setElement("MICDesc","");
	setElement("MICRemark","");
//	setElement("MICInvalidFlag",false);	modified by csj 20190612
	setEnabled();
	PreSelectedRowID=""
}

function Combindata()
{
	var combindata=getElementValue("RowID");
	combindata=combindata+"^"+getElementValue("MICType") ;
	combindata=combindata+"^"+getElementValue("MICCode") ;
	combindata=combindata+"^"+getElementValue("MICDesc") ;
	combindata=combindata+"^"+getElementValue("MICRemark") ;
//	combindata=combindata+"^"+getElementValue("MICInvalidFlag") ; modified by csj 20190612
    return combindata;
}
