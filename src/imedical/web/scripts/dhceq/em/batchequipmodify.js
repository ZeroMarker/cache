var Job=getElementValue("Job");
var DisplayFlag="";

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	setElement("NoDealFlag",true)
	initUserInfo();
    initMessage();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    //initPage();
    //initType();
	$HUI.datagrid("#tDHCEQBatchEQModify",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSEquip",
	        	QueryName:"GetEQModify",
				Job:Job,
				User:curUserID
			},
			rownumbers: true, 
			singleSelect:true,
			fit:true,
			border:false,
			toolbar:[
				{
					iconCls:'icon-add',
					id:'BImport',
					text:'��������',
					handler:function(){BImport_Clicked();}
				},
				{
					iconCls:'icon-save',
					id:'BExecute',
					text:'ִ��',
					handler:function(){BExecute_Clicked();}
				}
			],
			columns:[[
				{field:'TEquipID',title:'�ʲ�ID',width:10,align:'left',hidden:true},
				{field:'TEquipNo',title:'�ʲ�����',width:150,align:'left'},
				{field:'TEquipName',title:'�ʲ�����',width:150,align:'left'},
				{field:'TValueType',title:'�������',width:180,align:'left'},
				{field:'TOldValue',title:'���ǰ',width:150,align:'left'},
				{field:'TNewValue',title:'�����',width:150,align:'left'}
			]],
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
				//creatToolbar();
			}
	});
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:20px'>ȫ���豸</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:20px;'>�쳣�豸</a>"
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#diffflag").length>0)
	{
		jQuery("#diffflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#diffflag").on("click", BDiff_Clicked);
	}
}

function BAll_Clicked()
{
	DisplayFlag="";
	$("#allflag").css("color", "#FF0000");
	$("#diffflag").css("color", "#FFFFFF");
	BFind_Clicked();
}
function BDiff_Clicked()
{
	DisplayFlag="1";
	$("#allflag").css("color", "#FFFFFF");
	$("#diffflag").css("color", "#FF0000");
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQBatchEQModify",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSEquip",
	        	QueryName:"GetEQModify",
				Job:Job
			}
	});
}

///������:�ʲ���š�������͡�������ֵ
function BImport_Clicked()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}

function BImport_Chrome()
{
	if (Job=="")
	{
		messageShow('alert','error','������ʾ',"Job����Ϊ��!")
		return;
	}
    var ErrMsg="";
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}
    var ImportInfo=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    var ValueType=RowInfo[Row-1][Col++];
	    if (ValueType==undefined) ValueType=""
	    var Value=RowInfo[Row-1][Col++];
	    if (Value==undefined) Value=""
	    
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�ʲ���Ų���Ϊ��!")
		    return 1;
	    }
	    
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ʲ����:'+No+'������!')
		    return 1;
	    }
		
		ValueType=ValueType.replace(/\ +/g,"")	//ȥ���ո�
		if (ValueType=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"������Ͳ���Ϊ��!")
		    return 1;
	    }
	    ValueTypeID="";
	    NewValue="";
	    var RtnMsg=CheckValueIsInvalid(ValueType,Value,Row,EquipID)
	   	if (RtnMsg!=0)
	   	{
		   	ErrMsg=RtnMsg+","+ErrMsg
		   	continue;
		}
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ValueTypeID+"^"+NewValue;
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ValueTypeID+"^"+NewValue;
	}
	if (ErrMsg!="")
	{
		messageShow('alert','error','������ʾ',ErrMsg)
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ImportEquipModify",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","������Ϣ:"+result.split("^")[1]+",���ȴ�������ٽ�����һ����");
	}
    else
    {
		messageShow("","success","","�������!");
		disableElement("BExecute",0)
	}
	BFind_Clicked()
}

function BImport_IE()
{
	if (Job=="")
	{
		messageShow('alert','error','������ʾ',"Job����Ϊ��!")
		return;
	}
	var ErrMsg=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(1);
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
    var ImportInfo=""
	for (var Row=2;Row<=ExcelRows;Row++)
	{
	    var Col=1;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No="";
	    var ValueType=xlsheet.cells(Row,Col++).value;
	    if (ValueType==undefined) ValueType="";
	    var Value=xlsheet.cells(Row,Col++).value;
	    if (Value==undefined) Value="";
	    
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�ʲ���Ų���Ϊ��!")
		    return 1;
	    }
	    
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ʲ����:'+No+'������!')
		    return 1;
	    }
		
		ValueType=ValueType.replace(/\ +/g,"")	//ȥ���ո�
		if (ValueType=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"������Ͳ���Ϊ��!")
		    return 1;
	    }
	    ValueTypeID="";
	    NewValue="";
	   	var RtnMsg=CheckValueIsInvalid(ValueType,Value,Row,EquipID)
	   	if (RtnMsg!=0)
	   	{
		   	ErrMsg=RtnMsg+","+ErrMsg
		   	continue;
		}
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ValueTypeID+"^"+NewValue;
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ValueTypeID+"^"+NewValue;
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    //xlsheet.Quit;
    xlsheet=null;
	
	if (ErrMsg!="")
	{
		messageShow('alert','error','������ʾ',ErrMsg)
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ImportEquipModify",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","������Ϣ:"+result.split("^")[1]+",���ȴ�������ٽ�����һ����");
	}
    else
    {
		messageShow("","success","","�������!");
		disableElement("BExecute",0)
	}
	BFind_Clicked()
}

function CheckValueIsInvalid(ValueType,Value,Row,EquipID)
{
	var ErrMsg=""
	switch(ValueType){
		case "�ʲ�����":
			NewValue=Value;
			if(NewValue=="")
			{
				ErrMsg="��"+Row+"��"+"���Ʋ���Ϊ��!";
				//messageShow('alert','error','������ʾ',"��"+Row+"��"+"���Ʋ���Ϊ��!")
				return ErrMsg;
			}
			ValueTypeID="name";
			break;
		case "�ͺ�":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Model",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
			    var data=EquipID+"^"+Value;
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","SaveEQModel",data);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="��"+Row+"��"+"�ͺ�:"+Value+"�Զ������ֵ����!"
				    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ͺ�:'+Value+'�Զ������ֵ����!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="model";
			break;
		case "�ʲ�����":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","EquipCat",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'�ʲ�����:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ʲ�����:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="equipcat";
			break;
		case "��λ":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUOM",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'��λ'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��λ'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="uom";
			break;
		case "����":
			NewValue=Value;
			ValueTypeID="code";
			break;
		case "��װ����":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'��װ����'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��װ����'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="installloc";
			break;
		case "��װ����":
			NewValue=changeDateFormat(Value);
			ValueTypeID="installdate";
			break
		case "�������":
			NewValue=Value;
			ValueTypeID="leavefactoryno";
			break
		case "��������":
			NewValue=changeDateFormat(Value);
			ValueTypeID="leavefactorydate";
			break
		case "��������":
			NewValue=changeDateFormat(Value);
			ValueTypeID="opencheckdate";
			break
		case "��������":
			NewValue=changeDateFormat(Value);
			ValueTypeID="checkdate";
			break
		case "��������":
			NewValue=changeDateFormat(Value);
			ValueTypeID="makedate";
			break
		case "����":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTCountry",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'����:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'����:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="country";
			break;
		case "������":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'������:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="manageloc";
			break;
		case "�豸��Դ":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCOrigin",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'�豸��Դ:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'�豸��Դ:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="origin";
			break;
		case "��Դ����":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","FromToDept",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'��Դ����:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��Դ����:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="fromdept";
			break;
		case "ȥ����":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","FromToDept",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'ȥ����:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'ȥ����:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="todept";
			break;
		case "�ɹ���ʽ":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","BuyType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'�ɹ���ʽ:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ɹ���ʽ:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="buytype";
			break;
		case "��Ӧ��":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Provider",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
			    var data=Value+"^^";
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTVendor","UpdProvider",data);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="��"+Row+"��"+'��Ӧ��:'+Value+'�Զ������ֵ�ʧ��!'
				    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��Ӧ��:'+Value+'�Զ������ֵ�ʧ��!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="provider";
			break;
		case "��������":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Manufacturer",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTManufacturer","UpdManufacturer",Value);
			    jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="��"+Row+"��"+'��������:'+Value+'�Զ������ֵ�ʧ��!'
				    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��������:'+Value+'�Զ������ֵ�ʧ��!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="manufactory";
			break;
		case "�۾�����":
			NewValue=Value;
			ValueTypeID="limityearsnum";
			break;
		case "ʹ������":
			NewValue=Value;
			ValueTypeID="hold5";
			break;
		case "�۾ɷ���":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DepreMethod",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'���տ���:'+ToLoc+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="depremethod";
			break;
		case "������":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'������:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="manageuser";
			break;
		case "������ϵ��":
			NewValue=Value;
			ValueTypeID="providerhandler";
			break;
		case "�����绰":
			NewValue=Value;
			ValueTypeID="providertel";
			break;
		case "�깺���":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","PurchaseType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'�깺���:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'�깺���:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="purchasetype";
			break;
		case "��;":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","PurposeType",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'��;:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��;:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="purposetype";
			break;
		case "������":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'������:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="keeper";
			break;
		case "������":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Service",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'������:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="service";
			break;
		case "��ŵص�":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Value);
		    if ((Value!="")&&(NewValue==""))
		    {
				var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","UpdLocation",Value);
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE!=0)
				{
					ErrMsg="��"+Row+"��"+'��ŵص�:'+Value+'�Զ�����ص����!'
				    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'��ŵص�:'+Value+'�Զ�����ص����!')
				    return ErrMsg;
				}
				NewValue=jsonData.Data;
		    }
			ValueTypeID="location";
			break;
		case "������":
			NewValue=Value;
			ValueTypeID="guanranteenum";
			break;
		case "��ͬ��":
			NewValue=Value;
			ValueTypeID="contractno";
			break;
		case "������":
			NewValue=Value;
			ValueTypeID="fileno";
			break;
		case "ƾ֤��":
			NewValue=Value;
			ValueTypeID="accountno";
			break;
		case "ע��֤��":
			NewValue=Value;
			ValueTypeID="registerno";
			break;
		case "Ʒ��":
			NewValue=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","Brand",Value);
		    if (NewValue=="")
		    {
			    ErrMsg="��"+Row+"��"+'Ʒ��:'+Value+'������!'
			    //messageShow('alert','error','������ʾ',"��"+Row+"��"+'Ʒ��:'+Value+'������!')
			    return ErrMsg;
		    }
			ValueTypeID="brand";
			break;
		default:
			ErrMsg="��"+Row+"��:"+ValueType+'�������޸�!'
			//messageShow('alert','error','������ʾ',"��"+Row+"��:"+ValueType+'�������޸�!')
			return ErrMsg;
			break;
	}
	return 0;
}

//excel���ڸ�ʽת�� numbΪ���֣�formatΪƴ�ӷ���-��
function changeDateFormat(cellval, format)
{
	if ((cellval=="")||(cellval==null)||(cellval==undefined)) return ""
	if ((format==undefined)||(format=="")||(format==null)) format="-";
	if (getElementValue("ChromeFlag")!="1")
	{
		//IE
		if (typeof cellval=="string")
		{
			if (cellval.indexOf("-")>-1) return cellval;
			if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		}
		else if (typeof cellval=="number")
		{
			var time = new Date((cellval - 2) * 24 * 3600000 + 1)
		    time.setYear(time.getFullYear() - 70)
		    var year = time.getFullYear() + ''
		    var month = time.getMonth() + 1 + ''
		    var date = time.getDate() + ''
		    return year + format + month + format + date;
		}
		else if (typeof cellval=="date")
		{
			var time=new Date(cellval);
			var year = time.getFullYear() + '';
		    var month = time.getMonth() + 1 + '';
		    var date = time.getDate() + '';
		    return year + format + month + format + date;
		}
		else
		{
			return cellval;	
		}
	}
	else
	{
		//Chrome
		if (cellval.indexOf("-")>-1) return cellval;
		if (cellval.indexOf("/")>-1) return cellval.replace(/\//g,"-");
		var time = new Date((cellval - 2) * 24 * 3600000 + 1)
	    time.setYear(time.getFullYear() - 70)
	    var year = time.getFullYear() + ''
	    var month = time.getMonth() + 1 + ''
	    var date = time.getDate() + ''
	    return year + format + month + format + date
	}
}

function BExecute_Clicked()
{
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","ModifyEquipInfo",Job);
	result=result.split("^");
	var ErrCode=result[0];
	if (ErrCode!=0)
	{
	    messageShow('alert','error','������ʾ',result[1]);
	}
    else
    {
		messageShow("","success","","���³ɹ�!");
		disableElement("BExecute",1)
	}
}