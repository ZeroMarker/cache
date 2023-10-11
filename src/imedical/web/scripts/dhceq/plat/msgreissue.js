var columns=getCurColumnsInfo('EM.G.Message.MSGReissue','','','');
var SysSetVal = tkMakeServerCall("web.DHCEQCommon","GetSysInfo",992015);	// MZY0115	2473605		2022-03-10
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initButton(); //按钮初始化
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
				{id:'11',text:'开箱验收'}
				,{id:'21',text:'入库'}
				,{id:'22',text:'转移'}
				,{id:'23',text:'减少、退货'}
				,{id:'31',text:'维修'}
				,{id:'34',text:'报废'}
				,{id:'64',text:'租赁'}
				,{id:'91',text:'采购申请'}
				,{id:'92',text:'采购招标'}
				,{id:'93',text:'采购合同'}
			],
		});
	}
function initNotSendMessFlag(){
			var NotSendMessFlag = $HUI.combobox("#vNotSendMessFlag",{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{id:'',text:'全部'}				
				,{id:'Y',text:'已接收消息'}
				,{id:'N',text:'未接收消息'}
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
		messageShow("alert","info","提示","未处理消息才可补发");
		return
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.LIBMessages", "MessageSendAgain",vBussType,vBussID);
	messageShow("alert","info","提示",Rtn);
	 $("#tDHCEQMSGReissue").datagrid("reload");
}
// MZY0115	2473605		2022-03-10	验收 转移 维修 报废
function InvalidClickHandler(editIndex)
{
	var vBussType=getElementValue("vBussTypeDR");
	if(vBussType=="") return;
	var SysSetStr=","+SysSetVal+",";
	if (SysSetStr.indexOf(","+vBussType+",")<0)
	{
		messageShow("alert","info","提示","未设置该业务可进行无效处理,请联系系统管理员!");
		return
	}
	var rowData =  $("#tDHCEQMSGReissue").datagrid("getRows")[editIndex];
	if(rowData.TBussID=="") return;
	messageShow("confirm","info","提示",rowData.TBussType+":"+rowData.TBussNo+"   确定要无效该业务单?","",function(){
			var jsonData = tkMakeServerCall("web.DHCEQ.Plat.LIBMessages", "InvalidBuss",vBussType,rowData.TBussID);
			jsonData=JSON.parse(jsonData);
			if (jsonData.SQLCODE==0)
			{
				messageShow("alert","info","提示","操作成功!");
				$("#tDHCEQMSGReissue").datagrid("reload");
			}
			else
	    	{
				messageShow('alert','error','错误提示',jsonData.Data);
	    	}
		},function(){
			return;
		}
	);
}