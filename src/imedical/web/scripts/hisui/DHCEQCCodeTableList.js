var SelectedRow = -1;   //modify by lmm 2018-09-02 hisui改造：修改填充函数开始行号
var varTabName=""; //表名
var varTabNameStr=""; //表名
var varPreFix="";  //前缀
var varType="";    //类型
var varReadOnly="";//只读

function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
	initPanelHeaderStyle();
	if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
		$('.hgt4').css('border-color','#E2E2E2');
	}
	else{
		$('.hgt4').css('border-color','#CCCCCC');
	}
	$("#tDHCEQCCodeTableList").datagrid({showRefresh:false,showPageList:false,displayMsg:''});   //add by lmm 2019-02-19 hisui改造：隐藏翻页条内容
}
///modify by lmm 2018-09-02
///描述：单击行填充事件
///入参：index 行号
///      rowData 选中行json事件
function SelectRowHandler(index,rowData)	{
	Selected(index,rowData);
}
function Selected(selectrow,rowData)
{	
	if (SelectedRow==selectrow)	{			
		SelectedRow=-1;  //modify by lmm 2018-09-02 hisui改造：修改开始行号
		varTabName="";
		varPreFix=""	
		varType="1";
		varReadOnly="";
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.DHCEQCCodeTable.location.href=lnk

		//SetData();			
		}
	else{
		SelectedRow=selectrow;		
		varTabNameStr=rowData.TCodeDesc;
		varTabName=rowData.TCodeName;		
		varPreFix=rowData.TShortDesc;
		varType=rowData.TType;
		varReadOnly=rowData.TReadOnly;
		SetData();		
		}		
}
function SetData()	{
	if(varType=="1")
	{
		//标准代码表
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable&TabName="+(varTabName)+"&PreFix="+(varPreFix)+"&ReadOnly="+(varReadOnly)+"&titleName="+(varTabNameStr); //modify by lmm 2018-09-02 hisui改造：修改hisui默认csp
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.DHCEQCCodeTable.location.href=lnk;
	}
	else
	{
		var value=varTabName.split("_")
		if(value.length>2)
		{
			alertShow('不规则的表名,超出处理范围!');
			return;
		}
		if(varType=="2")
		{
			//非标准代码表
			var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=" + value[0] + value[1]+"&ReadOnly="+(varReadOnly);  //modify by lmm 2018-09-02 hisui改造：修改hisui默认csp
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				lnk += "&MWToken="+websys_getMWToken()
			}				
			parent.DHCEQCCodeTable.location.href=lnk
			
		}
		else
		{
			//csp page
			var varUrl=value[0] + value[1]+".csp?ReadOnly="+(varReadOnly);
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				varUrl += "&MWToken="+websys_getMWToken()
			}
			parent.DHCEQCCodeTable.location.href=varUrl;
		}
	}
}
document.body.style.padding="10px 5px 10px 10px" ////modify by lmm 2019-02-19 829712
document.body.onload = BodyLoadHandler;