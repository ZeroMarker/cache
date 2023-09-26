//Modified By QW20181031 需求号:733009
var Columns=getCurColumnsInfo('BA.G.StateInfo.StateList','','','')
$.extend($.fn.datagrid.defaults.view,{ 
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
//End By QW20181031 需求号:733009
$(function(){
	defindTitleStyle(); // add by wl 2019-11-04 WL0007	
	initDocument();
});

function initDocument(){
	initButton(); //按钮初始化
    initButtonWidth();
    initLookUp(); //初始化放大镜
   	$HUI.datagrid("#stateinfodatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQStateInfo",
	        	QueryName:"GetStateInfo",
        		PFileNo:getElementValue("FileNo"),
       		 	PNo:getElementValue("No"),
        		PName:getElementValue("Name"),
        		PRecordDate:"",
        		PRecordFlag:1
		},
		//Modified By QW20181031 需求号:733009
		cache: false,
		columns:Columns,
		border:false,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		//End By QW20181031 需求号:733009
		onLoadSuccess:function(){
			
		}
	});
}
//查询
//Modified By QW20181031 需求号:733009
function BFind_Clicked()
{	
	$HUI.datagrid("#stateinfodatagrid",{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQStateInfo",
        QueryName:"GetStateInfo",
       		PFileNo:getElementValue("FileNo"),
       		PNo:getElementValue("No"),
        	PName:getElementValue("Name"),
        	PRecordDate:"",
        	PRecordFlag:1,
        	PLoc:getElementValue("LocDR"), 
        	PUser :getElementValue("UserDR"), 
        	PStartDate: getElementValue("StartDate"), 
        	PEndDate:getElementValue("EndDate")
    },
    });
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
