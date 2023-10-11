/**
 * @file ��������
 * @author �½���
 * @createdate 2022-07-25
 */
var Columns=getCurColumnsInfo('Plat.G.Action','','','','','','');  //modified by LMH 20220914 2896679   //modified by LMH 20221009 2896679
var SelectedRow = -1 ; 
$(function(){
	initDocument();
});
///��ʼ������
function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle(); //Ĭ��Style
	initLookUp();
	initButton();
	initButtonWidth();
	setRequiredElements("ACode^ADesc^ASourceType")//��֤������
	muilt_Tab();  // �س���һ�����
	
	initActionGrid();

	disabled(true);	
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

//���ر������ҳ���ʼ���Լ���ѯʱ
function initActionGrid()
{	
		ActionGrid = $HUI.datagrid("#DHCEQCAction",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTAction",
			QueryName:"Action",
			Code:getElementValue("ACode"),
			Desc:getElementValue("ADesc"),
			Remark:getElementValue("ARemark"),
			SourceTypeID:getElementValue("ASourceTypeDR")
		},
		fit:true,
		border:false,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true, 
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		
	    onClickRow:function(rowIndex, rowData){
		    OnClickRow(rowIndex,rowData);
		},
		onLoadSuccess:function(jsondata){
			
		}
	});
}

// ���ݲ�ѯ�¼�
function BFind_Clicked()
{
	initActionGrid();
}

//��������뱣��
function BSave_Clicked() 
{	
	if (checkMustItemNull()) return;
	var data=getInputList();
	data["ASourceType"]=getElementValue("ASourceTypeDR"); //��data�������ASourceType����
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTAction","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if ((jsonData.SQLCODE==0))
	{
		
		jQuery('#DHCEQCAction').datagrid('reload');
		alertShow("����ɹ�");
	}
	else{
		alertShow("������Ϣ:"+jsonData.Data);
		return
	}	
}

//����ɾ��
function BDelete_Clicked() 
{
	var RowID=getElementValue("ARowID");
	if (RowID==""){
            $.messager.popover({msg:"��ѡ��һ��",type:'alert'}); 
            return false;
    } 
    $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
    	if (b==false)
    	{
        	 return;
   	 	}
    	else
    	{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTAction","SaveData",RowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				
				jQuery('#DHCEQCAction').datagrid('reload');
				
				alertShow("ɾ���ɹ�");
			}
			else{
				alertShow("������Ϣ:"+jsonData.Data);
				return
			}
    	}       
  })
}

function BClear_Clicked()
{	
	setElement("ARowID","");
	setElement("ASourceType","");
	setElement("ACode","");
	setElement("ADesc","");
	setElement("ARemark","");
	setElement("ASourceTypeDR","");
}

//������¼�
function OnClickRow(index,rowdata)
{	
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true);	
		SelectedRow=-1;
		$('#DHCEQCAction').datagrid('unselectAll');  
	}else{
		
		SelectedRow=index;
		setElement("ARowID",rowdata.TRowID);
		setElement("ASourceType",rowdata.TSourceType);
		setElement("ASourceTypeDR",rowdata.TSourceTypeID);
        setElement("ACode",rowdata.TCode);
        setElement("ADesc",rowdata.TDesc);
        setElement("ARemark",rowdata.TRemark);
		disabled(false);
	}
}

//��ť�һ�
function disabled(value)
{
	if (getElementValue("ReadOnly")==1){
		disableElement("BDelete",true)
	}else{
		disableElement("BDelete",value)
	}
}
