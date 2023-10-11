var columns=getCurColumnsInfo('EM.G.Message.MSGReissue','','','');
var SysSetVal = tkMakeServerCall("web.DHCEQCommon","GetSysInfo",992015);	// MZY0115	2473605		2022-03-10
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initButton(); //��ť��ʼ��
	initButtonWidth();
	defindTitleStyle();
	initSourceType();
	columns[0][8].showTip=true; //Add By Qw20200819 BUG:QW0074
	$HUI.datagrid("#tDHCEQMSGReissue",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"GetBussMessages",
			vStartDate:getElementValue("vStartDate"),
			vEndDate:getElementValue("vEndDate"),
			vBussTypeDR:getElementValue("vBussTypeDR"),
			vBussNo:getElementValue("vBussNo"),
			vNotSendMessFlag:getElementValue("vNotSendMessFlag"),
			InvalidMsgFlag:getElementValue("InvalidMsgFlag")
		},
		fitColumns : true,
	    scrollbarSize:0, 
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){	// MZY0115	2473605		2022-03-10
			if (SysSetVal=="")
			{
				$("#tDHCEQMSGReissue").datagrid("hideColumn", "TInvalid");
			}
		}
	});
}
function BFind_Clicked()
{
		$HUI.datagrid("#tDHCEQMSGReissue",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"GetBussMessages",
			vStartDate:getElementValue("vStartDate"),
			vEndDate:getElementValue("vEndDate"),
			vBussTypeDR:getElementValue("vBussTypeDR"),
			vBussNo:getElementValue("vBussNo"),
			vNotSendMessFlag:'',  //Add By Qw20200813 BUG:QW0074
			InvalidMsgFlag:''    //Add By Qw20200813 BUG:QW0074
		}
	});
}
function initSourceType(){
			var SourceType = $HUI.combobox("#vBussTypeDR",{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{id:'11',text:'��������'}
				,{id:'21',text:'���'}
				,{id:'22',text:'ת��'}
				,{id:'23',text:'���١��˻�'}
				,{id:'31',text:'ά��'}
				,{id:'34',text:'����'}
				,{id:'64',text:'����'}
				,{id:'91',text:'�ɹ�����'}
				,{id:'92',text:'�ɹ��б�'}
				,{id:'93',text:'�ɹ���ͬ'}
			],
		});
	}
function initNotSendMessFlag(){
			var NotSendMessFlag = $HUI.combobox("#vNotSendMessFlag",{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{id:'',text:'ȫ��'}				
				,{id:'Y',text:'�ѽ�����Ϣ'}
				,{id:'N',text:'δ������Ϣ'}
			],
		});
	}
function initInvalidMsgFlag(){
			var InvalidMsgFlag = $HUI.combobox("#InvalidMsgFlag",{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{id:'',text:'All'}				
				,{id:'Y',text:'Yes'}
				,{id:'N',text:'No'}
			],
		});
	}
	
function ReissueClickHandler(editIndex){
	var rowData =  $("#tDHCEQMSGReissue").datagrid("getRows")[editIndex];
	var vBussType=getElementValue("vBussTypeDR");
	var vBussID=rowData.TBussID;
	if((vBussType=="")||(vBussID=="")) return;
	var vMessDealFlag=rowData.TMessDealFlag;
	if(vMessDealFlag!="N"){
		messageShow("alert","info","��ʾ","δ������Ϣ�ſɲ���");
		return
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.LIBMessages", "MessageSendAgain",vBussType,vBussID);
	messageShow("alert","info","��ʾ",Rtn);
	 $("#tDHCEQMSGReissue").datagrid("reload");
}
// MZY0115	2473605		2022-03-10	���� ת�� ά�� ����
function InvalidClickHandler(editIndex)
{
	var vBussType=getElementValue("vBussTypeDR");
	if(vBussType=="") return;
	var SysSetStr=","+SysSetVal+",";
	if (SysSetStr.indexOf(","+vBussType+",")<0)
	{
		messageShow("alert","info","��ʾ","δ���ø�ҵ��ɽ�����Ч����,����ϵϵͳ����Ա!");
		return
	}
	var rowData =  $("#tDHCEQMSGReissue").datagrid("getRows")[editIndex];
	if(rowData.TBussID=="") return;
	messageShow("confirm","info","��ʾ",rowData.TBussType+":"+rowData.TBussNo+"   ȷ��Ҫ��Ч��ҵ��?","",function(){
			var jsonData = tkMakeServerCall("web.DHCEQ.Plat.LIBMessages", "InvalidBuss",vBussType,rowData.TBussID);
			jsonData=JSON.parse(jsonData);
			if (jsonData.SQLCODE==0)
			{
				messageShow("alert","info","��ʾ","�����ɹ�!");
				$("#tDHCEQMSGReissue").datagrid("reload");
			}
			else
	    	{
				messageShow('alert','error','������ʾ',jsonData.Data);
	    	}
		},function(){
			return;
		}
	);
}