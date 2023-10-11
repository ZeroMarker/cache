//Creator:CZF0138 2021-05-25
//description:ҽԺ������Ŀά��
var Columns=getCurColumnsInfo('Plat.G.FinaceItem','','','');
var SelectedRow = -1 ; 

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  //�������Ч��Ӱ��
});

function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle();
	initLookUp();
	initButton();
	//initButtonWidth();
	muilt_Tab();  // �س���һ�����
	setRequiredElements("FICode^FIDesc");
	initBDPHospComponent("DHC_EQCFinaceItem");	//CZF0138 ��Ժ������
	initFinanceItemGrid();
	disabled(true);
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initFinanceItemGrid();
}

function initFinanceItemGrid()
{
	FinanceItemGrid = $HUI.datagrid("#DHCEQCFinanceItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTFinanceItem",
			QueryName:"GetFinanceItem",
			Code:getElementValue("FICode"),
			Desc:getElementValue("FIDesc"),
			gHospId:curSSHospitalID,
			BDPHospId:GetBDPHospValue("_HospList")
		},
		border:false,
	    fit:true,
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
		onLoadSuccess:function(){
		}
	});
}

//���ݹ���ҽԺ��ť����¼�
function HospitalHandle()
{
	var FIRowID=getElementValue("FIRowID");
	if(FIRowID==""){
		$.messager.alert("��ʾ", "��ѡ�������Ŀ!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCFinaceItem",FIRowID,function(){
		//�ص�����;
	});
}

function BSave_Clicked() 
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFinanceItem","SaveData",data,"0",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("popover","success","��ʾ","����ɹ���");
		FinanceItemGrid.reload();
		BClear_Clicked();
	}
	else{
		messageShow('popover','error','��ʾ',"����ʧ�ܣ�������Ϣ:"+jsonData.Data);
	}	
}

function BDelete_Clicked() 
{
	var FIRowID=getElementValue("FIRowID")
	if (FIRowID==""){
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
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFinanceItem","SaveData",FIRowID,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0){
				messageShow("popover","success","��ʾ","ɾ���ɹ���");
				FinanceItemGrid.reload();
				BClear_Clicked();
			}else{
				messageShow('popover','error','��ʾ',"ɾ��ʧ�ܣ�������Ϣ:"+jsonData.Data);
			}
    	}       
  })
}

function BClear_Clicked()
{
	setElement("FIRowID","");
	setElement("FICode",""); 
	setElement("FIDesc","");
	setElement("FIRemark","");
}

function OnClickRow(index,rowdata)
{
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true);	
		SelectedRow=-1;
		setElement("FIRowID","");
		$('#DHCEQCFinanceItem').datagrid('unselectAll');  
	}else{
		SelectedRow=index;
		setElement("FIRowID",rowdata.TRowID);
        setElement("FICode",rowdata.TCode);
        setElement("FIDesc",rowdata.TName);
        setElement("FIRemark",rowdata.TRemark);
		disabled(false);
	}
}

function disabled(value)
{
	if (getElementValue("ReadOnly")==1){
		disableElement("BDelete",true)
	}else{
		disableElement("BDelete",value)
	}
}

