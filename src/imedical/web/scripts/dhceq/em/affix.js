var Columns=getCurColumnsInfo('EM.G.SoftwareModule','','','');
var curIndex=-1;  //�����
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  // add by zx 2019-05-05 �������Ч��Ӱ�� ZX0063
});

function initDocument()
{
	initUserInfo();
	initMessage(""); //��ȡ���jsҵ���ͨ����Ϣ
	defindTitleStyle();
	initLookUp();
	initButton(); //��ť��ʼ��
	//initButtonWidth();
	setRequiredElements("AFPartSpec^AFQuantityNum"); //������
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
	setEnabled();
	
	//table���ݼ���
	$HUI.datagrid("#tDHCEQAffix",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQAffix",
			QueryName:"GetAffix",
			EquipDR:getElementValue("AFEquipDR"),
			CheckListDR:getElementValue("AFCheckListDR"),
			ConfigFlag:getElementValue("ConfigFlag")
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
		onClickRow: function (index, row) {
			fillData(index, row);
		},
		onLoadSuccess:function(){
				//creatToolbar();
			}
	});
};

//��ӡ��ϼơ���Ϣ
function creatToolbar()
{
	var rows = $('#tDHCEQAffix').datagrid('getRows');
    var totalISLQuantityNum = 0;
    var totalISLTotalFee = 0;
    for (var i = 0; i < rows.length; i++)
    {
			var TQuantityNum=rows[i]["TQuantityNum"];
        	if (TQuantityNum=="") TQuantityNum=0;
        	totalISLQuantityNum += parseFloat(TQuantityNum);
        	TPriceFee=rows[i]["TPriceFee"];
        	if (TPriceFee=="") TPriceFee=0;
        	totalISLTotalFee += parseFloat(TPriceFee*TQuantityNum);
    
    }
	var lable_innerText='������:'+totalISLQuantityNum+'&nbsp;&nbsp;&nbsp;�ܽ��:'+totalISLTotalFee.toFixed(2);
	$("#sumTotal").html(lable_innerText);
	
}


// ����к��������
// ���: index,ѡ���к� row,ѡ��������
function fillData(index, row)
{
	if (curIndex!=index) 
	{
		setElement("AFRowID",row.TRowID);
		curIndex = index;
		setEnabled();
		if (row.TRowID=="") 
		{
			Clear();
		}else{
			SetData(row.TRowID); 
		}
		
	}
	else
	{
		Clear();
		curIndex = -1;
		setEnabled();
	}
}


function SetData(rowid)
{
	var gbldata=tkMakeServerCall("web.DHCEQAffix","GetAffixByID","","",rowid);
	var list=gbldata.split("^");
	var sort=34;
	
	setElement("AFPartSpec",list[3]);
	setElement("AFQuantityNum",list[6]);
	setElement("AFLeaveDate",list[28]);
	setElement("AFProviderDR_VDesc",list[sort+7]);
	setElement("AFProviderDR",list[sort+6]);
	setElement("AFPartModel",list[4]);
	setElement("AFPriceFee",list[10]);
	setElement("AFGuaranteeStartDate",list[24]);
	setElement("AFAddDate",list[9]);
	setElement("AFManuFactoryDR_VDesc",list[sort+3]);
	setElement("AFManuFactoryDR",list[sort+3]);
	setElement("AFCurrencyDR_UOMDesc",list[sort+5]);
	setElement("AFCurrencyDR",list[12]);
	setElement("AFGuaranteeEndDate",list[25]);
	setElement("AFSplitFlag",list[26]);
	setElement("AFRemark",list[11]);
}

function Clear()
{
	setElement("AFRowID","");
	setElement("AFPartSpec","");
	setElement("AFQuantityNum","");
	setElement("AFLeaveDate","");
	setElement("AFProviderDR_VDesc","");
	setElement("AFProviderDR","");
	setElement("AFPartModel","");
	setElement("AFPriceFee","");
	setElement("AFGuaranteeStartDate","");
	setElement("AFAddDate","");
	setElement("AFManuFactoryDR_VDesc","");
	setElement("AFManuFactoryDR","");
	setElement("AFCurrencyDR_UOMDesc","");
	setElement("AFCurrencyDR","");
	setElement("AFGuaranteeEndDate","");
	setElement("AFSplitFlag","");
	setElement("AFRemark","");
}

// ��ť�һ����ƴ���
function setEnabled()
{
	var AFRowID=getElementValue("AFRowID");
	if (AFRowID!="")
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

function BFundsByList(editIndex)
{
	var rowData =  $("#tDHCEQAffix").datagrid("getRows")[editIndex];
	var TRowID=(typeof rowData.TRowID == 'undefined') ? "" : rowData.TRowID;
	if (TRowID=="") return;
	var TQuantityNum=(typeof rowData.TQuantityNum == 'undefined') ? "" : rowData.TQuantityNum;
	if (TQuantityNum=="") return;
	var TPriceFee=(typeof rowData.TPriceFee == 'undefined') ? "" : rowData.TPriceFee;
	if (TPriceFee=="") return;
	var url="dhceq.em.funds.csp?";
	url=url+"FromType=2";
	url=url+"&FromID="+TRowID;
	url=url+"&ReadOnly="+getElementValue("ReadOnly")
	url=url+"&FundsAmount="+(TQuantityNum*TPriceFee);
	showWindow(url,"�ʽ���Դ","","","icon-w-paper","modal","","","small","");  
}


function setSelectValue(elementID,rowData)
{
	if(elementID=="AFPartSpec") {
		//console.log(rowData);//modify by zyq 2022-12-06 begin
		setElement("AFPartSpec",rowData.TPartSpec) 
		setElement("AFPartModel",rowData.TPartModel)
		setElement("AFCurrencyDR_UOMDesc",rowData.TUnit)//modify by zyq 2022-12-06 end
		setElement("AFCurrencyDR",rowData.Hidden)
	}
	else if(elementID=="AFProviderDR_VDesc") {setElement("AFProviderDR",rowData.TRowID)}
	else if(elementID=="AFManuFactoryDR_VDesc") {setElement("AFManuFactoryDR",rowData.TRowID)}
	else if(elementID=="AFCurrencyDR_UOMDesc") {setElement("AFCurrencyDR",rowData.TRowID)}
}

//hisui.common.js���������Ҫ
//add by csj 20181103 onChange����¼�
function clearData(vElementID)
{
	if (vElementID=="AFPartSpec"){
		setElement("AFPartModel","")
		setElement("AFCurrencyDR","")
		setElement("AFCurrencyDR","")
	}else{
		var _index = vElementID.indexOf('_')
		if(_index != -1){
			var vElementDR = vElementID.slice(0,_index)
			if($("#"+vElementDR).length>0)
			{
				setElement(vElementDR,"");
			}
		}
	}
	
}

function BAdd_Clicked() 
{
	var newrowid=0;
	
	if (checkMustItemNull()) return
	
	var plist=CombinData();
	var result=tkMakeServerCall("web.DHCEQAffix","SaveData","","",plist,getElementValue("AFCheckListDR"),"0");
	newrowid=result;
	if (newrowid>0)
	{
		var flag=tkMakeServerCall("web.DHCEQAffix","GetChangeAccountFlag",newrowid);
		if (flag==0)
		{
			location.reload();
			return;
		}
		if (flag==1)
		{
			messageShow("confirm","alert","��ʾ","Ҫ�����豸ԭֵ��","show",function(){
						var result=tkMakeServerCall("web.DHCEQAffix","ChangeAccountByAffix",newrowid);
							if (result=="") 
							{
								location.reload();
								return;
							}
							if (result>0)
							{
								var equipdr=getElementValue("AFEquipDR");
								var str="dhceqchangeaccount.csp?RowID="+equipdr;
								showWindow(str,"�豸����",1100,"96%","icon-w-paper","modal","","","",refreshWindow);  //modify by lmm 2019-08-05 941349
							}
							else
							{
								location.reload();
							}
						
			},function(){
				location.reload();
				return;
				},"��","��");
		}
		
	}
	else
	{
		//add by zyq 2023-03-30
		messageShow('alert','error','��ʾ',"���������Ϣ:"+result);
		return
	}
}

function BSave_Clicked() 
{
	SaveData();
}

function SaveData()
{
	if (checkMustItemNull()) return
	var plist=CombinData();
	var result=tkMakeServerCall("web.DHCEQAffix","SaveData","","",plist,getElementValue("AFCheckListDR"),"0");
	newrowid=result;
	if (result>0)
	{	
		location.reload();
	}
	else
	{
		messageShow('alert','error','��ʾ',"���������Ϣ:"+result);
		return
	}
}

function CombinData()
{
	var RProvDR=setProviderRowID(getElementValue("ProviderOperMethod"));
    if ((RProvDR!=0)&&(getElementValue("AFProviderDR_VDesc")!=""))
    {
	    alertShow("��Ӧ�̵ǼǴ���!");
	    return -1;
    }
    var RManuDR=setManuFactoryRowID(getElementValue("ManuFactoryOperMethod"));
    if ((RManuDR!=0)&&(getElementValue("AFManuFactoryDR_VDesc")!=""))
    {
	    alertShow("�������ҵǼǴ���!");
	    return -1;
    }
	var combindata="";
  	combindata=getElementValue("AFRowID") ;
  	combindata=combindata+"^"+getElementValue("AFEquipDR") ;
  	combindata=combindata+"^" ;
  	combindata=combindata+"^" ;
  	combindata=combindata+"^"+getElementValue("AFPartSpec") ;
  	combindata=combindata+"^"+getElementValue("AFPartModel") ;
  	combindata=combindata+"^"+getElementValue("AFManuFactoryDR");;
  	combindata=combindata+"^"+getElementValue("AFQuantityNum") ;
  	combindata=combindata+"^" ;
  	combindata=combindata+"^" ;
  	combindata=combindata+"^"+getElementValue("AFAddDate") ;		
  	combindata=combindata+"^"+getElementValue("AFPriceFee") ;
  	combindata=combindata+"^"+getElementValue("AFRemark") ;
  	combindata=combindata+"^"+getElementValue("AFCurrencyDR") ;
	combindata=combindata+"^"+getElementValue("AFProviderDR");
	combindata=combindata+"^"+getElementValue("AFGuaranteeStartDate");	
	combindata=combindata+"^"+getElementValue("AFGuaranteeEndDate");
	combindata=combindata+"^"+getElementValue("AFSplitFlag");		
	combindata=combindata+"^";
	combindata=combindata+"^";		
	combindata=combindata+"^"+getElementValue("AFLeaveDate");		
  	return combindata;
}


function BDelete_Clicked() 
{
	rowid=getElementValue("AFRowID");
	if (rowid=="")	{
		messageShow("","","","��ѡ��Ҫɾ���ĸ���?");
		return;
	}
	messageShow("confirm","alert","��ʾ","��ȷ��Ҫɾ���ø�����?","show",confirmfun,cancelfun);  
}

function confirmfun()
{
	rowid=getElementValue("AFRowID");
	var result=tkMakeServerCall("web.DHCEQAffix","SaveData","","",rowid+"^"+getElementValue("AFEquipDR"),getElementValue("AFCheckListDR"),"1");
	if (result>0)
	{	location.reload();	}

}

function cancelfun()
{
	return;
}

function setProviderRowID(type)
{
	var rtn=-1
	if((type=="0")||(type==""))
	{
		setElement("AFProviderDR","");
	}
	else
	{
		var providerName=getElementValue("AFProviderDR_VDesc");
		if (providerName=="") return;
		var data=providerName+"^"+getElementValue("AFProviderHandler")+"^"+getElementValue("AFProviderTel");
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTVendor","UpdProvider",data);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("AFProviderDR",jsonData.Data);
		rtn = jsonData.SQLCODE
	}
	return rtn
}

function setManuFactoryRowID(type)
{
	var rtn=-1
	if((type=="0")||(type==""))
	{
		setElement("AFManuFactoryDR","");
	}
	else
	{
		var manuFactoryName=getElementValue("AFManuFactoryDR_VDesc");
		if (manuFactoryName=="") return;
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTManufacturer","UpdManufacturer",manuFactoryName);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0) setElement("AFManuFactoryDR",jsonData.Data);
		rtn = jsonData.SQLCODE
	}
	return rtn
}
