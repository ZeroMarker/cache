///动态获取datagrid列信息
var Columns=getCurColumnsInfo('EM.G.Maint.PlanEquipList','','','')
///动态生成datagrid调用查询
var queryParams={ClassName:"web.DHCEQ.EM.BUSMaintPlan",QueryName:"PlanEquipList"}
var editIndex=undefined;
var ISRowID=getElementValue("MPRowID");
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initUserInfo();
	initLookUp();
	initMessage();
	defindTitleStyle();
	initButton();
	initButtonWidth();
	initRiskGrade();
	//setEnabled();
	//显示列表
	$HUI.datagrid("#DHCEQEquipList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        	QueryName:"PlanEquipList",
				Data:"",
				MPID:"",
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'新建计划单',  
				id:'add',        
                handler: function(){
                     createPlan();
                }},
                {
                iconCls: 'icon-import',
                text:'追加计划单',
				id:'app',
                handler: function(){
                     appendPlan();
                }}
        ],
		rownumbers: true,  //如果为true则显示一个行号列
		//singleSelect:true,
		fit:true,
		border:false,
		//striped : true,
	    //cache: false,
		//fitColumns:true,
		columns:Columns,
		//onClickRow:function(rowIndex,rowData){onClickRow();},
		pagination:true,
		pageSize:100,
		pageNumber:1,
		pageList:[100,200,300,400],
		onLoadSuccess:function(){}
	});
	$('#DHCEQEquipList').datagrid('hideColumn','TDeleteList');
	if ($("#AddFlag").val()==1) disableElement("add",true);		//MZY0099	2200181		2021-11-13
}

function setEnabled()
{
	/*var Status=$("#Status").val()
	if (Status==1)
	{
		$("#BExecute").linkbutton("disable")
		$("#BFinish").linkbutton("disable")
		$("#BDelete").linkbutton("disable")
		jQuery("#BExecute").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BFinish").unbind();
	}
	else if((Status=="")||(Status==0))
	{
		$("#BExecute").linkbutton("enable")
		$("#BFinish").linkbutton("enable")
		$("#BDelete").linkbutton("enable")
	}*/
}
function initRiskGrade()
{
	var RiskGrade = $HUI.combobox('#RiskGrade',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '高'
			},{
				id: '2',
				text: '中'
			},{
				id: '3',
				text: '低'
			}],
	});
}
function createMaintEquipList()
{
	queryParams.MPID=getElementValue("MPRowID")
	queryParams.PEID=getElementValue("RowID")
	//动态生成datagrid窗口显示数据
	createdatagrid("tDHCEQMaintEquipList",queryParams,Columns)
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	//if(elementID=="IStoreLocDR_CTLOCDesc") {setElement("IStoreLocDR",rowData.TRowID)}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function BFind_Clicked()
{
	var lnk=GetLnk();
	$HUI.datagrid("#DHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaintPlan",
	        QueryName:"PlanEquipList",
	        Data:lnk,
	        MPID:"",
	    },
	    onLoadSuccess: function (data) {
			//changeToolbarByRight();
			//InitToolbarForAmountInfo();
		}
	});
	if ($("#AddFlag").val()==1) disableElement("add",true);		// MZY0107	2353225		2021-12-17
}
function GetLnk()
{
	var lnk="^No="+getElementValue("No");
	lnk=lnk+"^FileNo="+getElementValue("FileNo");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	lnk=lnk+"^RiskGrade="+getElementValue("RiskGrade");
	lnk=lnk+"^ManuFactoryDR="+getElementValue("ManuFactoryDR");
	lnk=lnk+"^LeaveFactoryNo="+getElementValue("LeaveFactoryNo");
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^StatCatDR="+getElementValue("StatCatDR");
	lnk=lnk+"^EquipCatDR="+getElementValue("EquipCatDR");
	lnk=lnk+"^BeginInStockDate="+getElementValue('BeginInStockDate');
	lnk=lnk+"^EndInStockDate="+getElementValue('EndInStockDate');
	lnk=lnk+"^Chk=";	// 未建计划
	if (getElementValue("Chk")==true)
	{
		lnk=lnk+"1";
	}
	lnk=lnk+"^EngineerDR="+getElementValue("EngineerDR");	//MZY0083	2034340		2021-07-19
	return lnk;
}
function createPlan()
{
	var checkedEquips = $('#DHCEQEquipList').datagrid('getChecked');
	var selectEquips = [];
	$.each(checkedEquips, function(index, item){
        	selectEquips.push(item.TRowID);
		});
	if(selectEquips=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	//alert(selectEquips)
	var url= 'dhceq.em.maintplansimple.csp?&EquipDRStr='+selectEquips+'&ReadOnly=&AddFlag=1';   // Modfied by zc0122 2022-10-12 增加入参AddFlag
	showWindow(url,"保养计划单","","11row","icon-w-paper","modal","","","small");	//Modefied by zc0118 20220520 日期框展示不全	// MZY0099	2198140		2021-11-13
}
function appendPlan()
{
	var checkedEquips = $('#DHCEQEquipList').datagrid('getChecked');
	var selectEquips = [];
	$.each(checkedEquips, function(index, item){
        	selectEquips.push(item.TRowID);
		});
	if(selectEquips=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	// Modfied by zc0122 2022-10-12 修正追加设备 begin
	if (getElementValue("MPRowID")=="")
	{
		var url='dhceq.em.appendmaintplan.csp?&EquipDRStr='+selectEquips+'&ReadOnly=';
		showWindow(url,"计划追加设备","","","icon-w-paper","modal","","","middle");		//MZY0120	2022-04-13
	}
	else
	{
		var str=""
		var InfoStr=""
		for(i=0;i<selectEquips.length;i++)//开始循环
		{
			var res = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "CheckEquipInMaintplan",selectEquips[i]);
	    	var ret=res.split("^");
	    	if (ret[0]!="0")
			{	
				$.messager.popover({msg:"设备"+ret[1]+"已存在计划",type:'alert',timeout:60000});
				return;	//add by csj 20190508	
			}
			if (str=="")
			{
				str=selectEquips[i];//循环赋值	
			}
			else
			{
				str=str+","+selectEquips[i]
			}
		}
		selectEquips.splice(0,selectEquips.length);
		var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "AppendEquip",getElementValue("MPRowID"),str);
		jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE==0)
		{
	    	window.location.reload();

		}
		else
    	{
			messageShow('alert','error','提示',"错误信息:"+jsonData.Data);
			return
    	}
	}
	// Modfied by zc0122 2022-10-12 修正追加设备 end
}
