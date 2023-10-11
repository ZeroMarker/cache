//Creator:CZF0138 2021-05-25
//description:���ܷ���ά��
var Columns=getCurColumnsInfo('Plat.G.FunctionCat','','','');
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
	setRequiredElements("FCCode^FCDesc");
	initBDPHospComponent("DHC_EQCFunctionCat");	//CZF0138 ��Ժ������
	initFunctionCatGrid();
	disabled(true);
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initFunctionCatGrid();
}

function initFunctionCatGrid()
{
	FunctionCatGrid = $HUI.datagrid("#DHCEQCFunctionCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTFunctionCat",
			QueryName:"GetFunctionCat",
			Code:getElementValue("FCCode"),
			Desc:getElementValue("FCDesc"),
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
	var FCRowID=getElementValue("FCRowID");
	if(FCRowID==""){
		$.messager.alert("��ʾ", "��ѡ�������Ŀ!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCFunctionCat",FCRowID,function(){
		//�ص�����;
	});
}

function BSave_Clicked() 
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFunctionCat","SaveData",data,"0",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("popover","success","��ʾ","����ɹ���");
		FunctionCatGrid.reload();
		BClear_Clicked();
	}
	else{
		messageShow('popover','error','��ʾ',"����ʧ�ܣ�������Ϣ:"+jsonData.Data);
	}	
}

function BDelete_Clicked() 
{
	var FCRowID=getElementValue("FCRowID")
	if (FCRowID==""){
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
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFunctionCat","SaveData",FCRowID,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0){
				messageShow("popover","success","��ʾ","ɾ���ɹ���");
				FunctionCatGrid.reload();
				BClear_Clicked();
			}else{
				messageShow('popover','error','��ʾ',"ɾ��ʧ�ܣ�������Ϣ:"+jsonData.Data);
			}
    	}       
  })
}

function BClear_Clicked()
{
	setElement("FCRowID","");
	setElement("FCCode",""); 
	setElement("FCDesc","");
	setElement("FCRemark","");
}

function OnClickRow(index,rowdata)
{
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true)	
		SelectedRow=-1;
		setElement("FCRowID","");
		$('#DHCEQCFunctionCat').datagrid('unselectAll');  
	}else{
		SelectedRow=index;
		setElement("FCRowID",rowdata.TRowID);
        setElement("FCCode",rowdata.TCode);
        setElement("FCDesc",rowdata.TName);
        setElement("FCRemark",rowdata.TRemark);
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

