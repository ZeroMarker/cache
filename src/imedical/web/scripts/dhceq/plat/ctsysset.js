//Creator:CZF0 2021-11-17
//description:ϵͳ����ά��
var Columns=getCurColumnsInfo('Plat.G.GetSySSet','','','');
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
	disabled(true);	
	muilt_Tab();  // �س���һ�����
	setRequiredElements("SSCode^SSDesc");
	initBDPHospComponent("DHC_EQCSysSet");	//CZF0138 ��Ժ������
	initSysSetGrid();
	initEvent();
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	Clear();
	initSysSetGrid();
}

function initEvent()
{
}

function initSysSetGrid()
{
	SysSetGrid = $HUI.datagrid("#tDHCEQSysSet",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTSysSet",
			QueryName:"GetSysSet",
			code:getElementValue("SSCode"),
			desc:getElementValue("SSDesc"),
			remark:getElementValue("SSRemark"),
			value:getElementValue("SSValue"),
			addvalue:getElementValue("SSAddValue"),
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
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,60,100,200],
	    onClickRow:function(rowIndex, rowData){
		    SelectRowHandler(rowIndex,rowData);
		},
		onLoadSuccess:function(){
		}
	});
}

//���ݹ���ҽԺ��ť����¼�
function HospitalHandle()
{
	var SSRowID=getElementValue("SSRowID");
	if(SSRowID==""){
		$.messager.alert("��ʾ", "��ѡ��ϵͳ����!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCSysSet",SSRowID,function(){
		//�ص�����;
	});
}

function BSave_Clicked() 
{
	if (condition()) return;
	var plist=JSON.stringify(getInputList());
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTSysSet","SaveData",plist,"",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',t[0]);
		Clear();
		SysSetGrid.reload();
	}
	else
	{
		messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
	}	
}

function BDelete_Clicked() 
{
	var rowid=getElementValue("SSRowID");
	if (rowid==""){
		messageShow('alert','','��ʾ',"����ѡ��һ����¼!");
		return;
	}else{
		messageShow("confirm","info","��ʾ","�Ƿ�ȷ��ɾ��?","",function(){
			deleteData(rowid);
			},function(){
				return;
		});
	}
}

function deleteData(rowid){
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTSysSet","SaveData",rowid,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow('alert','success','��ʾ',"ɾ���ɹ�");
		Clear();
		SysSetGrid.reload();
	}
	else
	{
		messageShow('alert','error','��ʾ',t[-9200]+jsonData.Data);
	}
}

function BFind_Clicked()
{
	initSysSetGrid();
}

function BClear_Clicked()
{
	Clear();
}

function setSelectValue(elementID,rowData)
{
	if(elementID=="SSCode") 
	{
		//setElement("SSRowID",rowData.TRowID);
		setElement("SSDesc",rowData.TDesc);
		setElement("SSCode",rowData.TCode);
		setElement("SSRemark",rowData.TRemark);
		setElement("SSValue",rowData.TDefaultValue);
		setElement("SSAddValue","");
	}
}

function SelectRowHandler(index,rowdata)
{	
	if (SelectedRow==index){
		Clear();
		disabled(true)	
		SelectedRow=-1;
		rowid=0;
		setElement("SSRowID","");
		$('#tDHCEQSysSet').datagrid('unselectAll');
		return;
	}else{
		SelectedRow=index;
		rowid=rowdata.SSRowID;
		SetData(rowid);
		disabled(false)
	}
}

function Clear()
{
	setElement("SSRowID",""); 
	setElement("SSCode",""); 
	setElement("SSDesc","");
	setElement("SSRemark","");
	setElement("SSValue","");
	setElement("SSAddValue","");
	setElement("SSUniqueFlag","");
}

function SetData(rowid)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTSysSet","GetOneSysSet",rowid);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	// MZY0118	2516855		2022-03-28
	if (jsonData.Data.SSCode==990018)
	{
		setElement("SSValue","");
		disableElement("BSave",true);
		disableElement("BDelete",true);
		var url='dhceq.plat.ftpserver.csp?&SSRowID='+jsonData.Data.SSRowID;
		showWindow(url,"FTPServer����","","6row","icon-w-paper","modal","","","small");
	}
	else
	{
		disableElement("BSave",false);
		disableElement("BDelete",false);
	}
}

function disabled(value)
{
	if (getElementValue("ReadOnly")==1)
	{
		disableElement("BDelete",true)
	}else{
		//disableElement("BSave",value)
		disableElement("BDelete",value)
	}
}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
	if(vElementID=="SSCode") setElement("SSRowID","");
}

function condition()
{
	//if(getElementValue("SSRowID")==""){alertShow("���벻��Ϊ��");return true;}
	if(getElementValue("SSCode")==""){alertShow("���벻��Ϊ��");return true;}
	else if(getElementValue("SSDesc")==""){alertShow("��������Ϊ��");return true;}
}
