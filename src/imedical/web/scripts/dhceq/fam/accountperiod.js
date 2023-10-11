///modified by ZY0298 ������������
///������ʾ����
var SelectedRow="undefined";
var Columns=getCurColumnsInfo('EM.G.AccountPeriod','','','')
$(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  
	
});
function initDocument()
{
	initUserInfo();
    initMessage(""); //��ȡ����ҵ����Ϣ
    initLookUp(); //��ʼ���Ŵ�
	defindTitleStyle(); 
    initButton(); //��ť��ʼ��
    //initPage(); //��ͨ�ð�ť��ʼ��
    initButtonWidth();
    initAPEquipTypeIDs();
    setEnabled(); //��ť����
	jQuery("#BCancel").linkbutton({text:'����'});
	$HUI.datagrid("#tDHCEQAccountPeriod",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
	        	QueryName:"AccountPeriodList",
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		fit:true,
	    singleSelect:true,
		fitColumns:false,    //modify by lmm 2018-11-07 734076
		pagination:true,
		striped : true,
	    cache: false,
		columns:Columns,
		onClickRow:function(rowIndex,rowData){SelectRowHandler(rowIndex,rowData);},
		
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}

function initAPEquipTypeIDs()
{
	var EquipTypeData=getElementValue("EquipTypeData")
	var jsonData=jQuery.parseJSON(EquipTypeData);
	var EquipTypeData=eval('(' + jsonData.Data+ ')');
    $("#APEquipTypeIDs").keywords({
       	items:EquipTypeData
    });
}
function BAudit_Clicked()
{
	var APYear=getElementValue("APYear")
	if (APYear=="")
	{
		alertShow("��Ȳ���Ϊ��!")
		return
	}
	var APMonth=getElementValue("APMonth")
	if (APMonth=="")
	{
		alertShow("�·ݲ���Ϊ��!")
		return
	}
	var APStartDate=getElementValue("APStartDate")
	if (APStartDate=="")
	{
		alertShow("��ʼ���ڲ���Ϊ��!")
		return
	}
	var APEndDate=getElementValue("APEndDate")
	if (APEndDate=="")
	{
		alertShow("�������ڲ���Ϊ��!")
		return
	}
	if (APEndDate<=APStartDate)
	{
		alertShow("�������ڲ��ܱȿ�ʼ����С!")
		return
	}
	messageShow("confirm","info","��ʾ","1.��ǰ�������:"+APYear+"-"+APMonth+",<br>2.��ʼ����:"+APStartDate+",<br>3.��������:"+APEndDate+",<br>4.����������۾�,���ɿ��պ��½ᱨ��<br>��ȷ���Ƿ�Ҫ����ִ�в���?","",ExecuteJob,function(){return},"ȷ��","ȡ��");
	
}
function ExecuteJob()
{
	var data=getInputList();
	data=JSON.stringify(data);
	disableElement("BAudit",true)
	
	$.messager.progress({
				title: "��ʾ",
				msg: '����ִ�в���',
				text: 'ִ����....'
			});
	$cm({
		ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
		MethodName:"ExecuteJob",
		data:data
	},function(jsonData){
		//jsonData=JSON.parse(jsonData)
		$.messager.progress('close');
		if (jsonData.SQLCODE==0)
		{
			//disableElement("BAudit",false);
			alertShow("ִ�гɹ�!");
			url="dhceq.fam.accountperiod.csp?"
		    window.location.href= url;
			return
		}
		else
	    {
		    disableElement("BAudit",false)
			alertShow("������Ϣ:"+jsonData.Data);
			return
	    }
	});
	//var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSAccountPeriod","ExecuteJob",data);
	//jsonData=JSON.parse(jsonData)
	
}
function BCancel_Clicked()
{
	var APYear=getElementValue("APYear")
	if (APYear=="")
	{
		alertShow("��Ȳ���Ϊ��!")
		return
	}
	var APMonth=getElementValue("APMonth")
	if (APMonth=="")
	{
		alertShow("�·ݲ���Ϊ��!")
		return
	}
	var APStartDate=getElementValue("APStartDate")
	if (APStartDate=="")
	{
		alertShow("��ʼ���ڲ���Ϊ��!")
		return
	}
	var APEndDate=getElementValue("APEndDate")
	if (APEndDate=="")
	{
		alertShow("�������ڲ���Ϊ��!")
		return
	}
	
	messageShow("confirm","info","��ʾ","��ǰ�������޸ĵ�����:<br>1.�ѻ������:"+APYear+"-"+APMonth+"���۾ɸĻص�ǰһ������,<br>2.ɾ����ǰ���ڵĿ���,<br>3.ɾ����ǰ���ڵ��±���¼,<br>��ȷ���Ƿ�Ҫ����ִ�г�������?","",
	function(){
		
			$.messager.progress({
						title: "��ʾ",
						msg: '���ڳ���ִ��',
						text: 'ִ����....'
					});
			$cm({
				ClassName:"web.DHCEQ.EM.BUSAccountPeriod",
				MethodName:"CancelJob",
				APRowID:APRowID
			},function(jsonData){
				//jsonData=JSON.parse(jsonData)
				$.messager.progress('close');
				if (jsonData.SQLCODE==0)
				{
					//disableElement("BAudit",false);
					alertShow("�����ɹ�!");
					url="dhceq.fam.accountperiod.csp?"
				    window.location.href= url;
					return
				}
				else
			    {
				    disableElement("BCancel",false)
					alertShow("������Ϣ:"+jsonData.Data);
					return
			    }
			});
		
		},
	function(){return},
	"ȷ��",
	"ȡ��");
}
function setEnabled()
{
	disableElement("APYear",true); 
	disableElement("APMonth",true);
	disableElement("APStartDate",true);
	disableElement("APStartTime",true);
	disableElement("APEndDate",true); 
	//disableElement("BAudit",true);
	disableElement("BCancel",true);
}
function SelectRowHandler(rowIndex,rowData)
{
	if (rowIndex==SelectedRow)
	{
		setElement("APRowID","");
		setElement("APYear",getElementValue("NewAPYear")); 
		setElement("APMonth",getElementValue("NewAPMonth"));
		setElement("APStartDate",getElementValue("NewStartDate"));
		setElement("APStartTime","");
		setElement("APEndDate",GetCurrentDate()); 
		setElement("APEndTime","");
		setElement("APSnapID","");
		setElement("APRemark","");
		SelectedRow= "undefined";
		//initButton();
		disableElement("BAudit",false);
		disableElement("BCancel",true);
	}
	else
	{
		setElementByJson(rowData);
		//initButton();
		disableElement("BAudit",true);
		///�����Ƿ����һ����¼��ֻ�����һ����¼�ſ��Գ���
		var APRowID=getElementValue("APRowID");
		var LastRowID=getElementValue("LastRowID");
		var APRemark=getElementValue("APRemark");
		if ((APRowID!=LastRowID)||(APRemark=="��ʼ��¼"))
		{
			disableElement("BCancel",true);
		}
		else
		{
			disableElement("BCancel",false);
		}
		SelectedRow=rowIndex
	}
}
