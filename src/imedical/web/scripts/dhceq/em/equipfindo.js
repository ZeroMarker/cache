var columns=getCurColumnsInfo('EM.L.Software','','','');  
var AttributeCode="61"
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	initButtonWidth();   //add by lmm 2020-04-26 1292188
	initButton();
	initGrid();
}

function initGrid()
{
	initSoftGrid()
}

function initSoftGrid(){
	var vtoolbar=Inittoolbar();
	var vData=GetLnk()
	var vData="SSLocID=^SSGroupID=^SSUserID="+vData
	$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
		idField:'TRowID', //主键   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
		fitColumns:true,  //modify by lmm 2021-05-23
		pagination:true,
    	columns:columns, 
    	toolbar:vtoolbar, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetShortEquip",
	        Equip:'',
	        VUseLoc:'',
	        NeedUseLoc:'',
	        StockStatuType:'',
	        VBAFlag:'',
	        QXType:'',
	        VComputerFlag:'',    
	        PlanNameDR:'',
	        IncludeBussFlag:'',
	        VModelDR:'',   
	        VEquipTypeDR:'',
	        VNo:'',
	        vData:vData,
	        ToolBarFlag:'',
	    }, 
	});
	
}
function Inittoolbar()
{
	var toolbar="" 
	toolbar=[{
        id:'BAdd',
        iconCls: 'icon-add',
        text:'选增软件',
        handler: function(){
             BAdd_Clicked();
        }
    }]			
	return toolbar;
}
function BFind_Clicked()
{
	
		var vData=GetLnk()
		var vData="SSLocID=^SSGroupID=^SSUserID="+vData
		$HUI.datagrid("#tDHCEQEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetShortEquip",
			Equip:$("#EquipName").val(),
	        VUseLoc:getElementValue("UseLocDR"),
	        NeedUseLoc:'',
	        StockStatuType:'',
	        VBAFlag:'',
	        QXType:'',
	        PlanNameDR:'',
	        IncludeBussFlag:'',
	        VModelDR:getElementValue("ModelDR"),   //modify by lmm 2019-05-29  919133
	        VEquipTypeDR:getElementValue("EquipTypeDR"),
	        VNo:getElementValue("No"),
	        vData:vData
	    },
	});
	
}

function GetLnk()
{
	var lnk="";
	lnk=lnk+"^vAIncludeFlag=Y";
	lnk=lnk+"^EquipAttribute="+AttributeCode;
	if (getElementValue("AllInFlag")==true)
			lnk=lnk+"^vAllInFlag=Y";
	else 
		lnk=lnk+"^vAllInFlag=N";
	return lnk
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

// modified by LMH 20220915 2906745 BAdd_Click()错误修改为BAdd_Clicked()初始化页面时initButton()出错导致页面组件datagrid加载出错 
function BAdd_Clicked()
{
	url="dhceq.em.equipbymeasure.csp?"+"&SourceType=3"+"&ComputerFlag=N"+"&EquipAttribute="+AttributeCode; 
	showWindow(url,"设备台账","","","icon-w-paper","modal","","","verylarge",BFind_Clicked)
	
}


