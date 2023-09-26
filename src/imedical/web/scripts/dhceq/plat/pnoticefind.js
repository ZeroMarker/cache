var columns=getCurColumnsInfo('PLAT.G.CT.Notice','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();

	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	$HUI.datagrid("#pnoticefinddatagrid",{   
	   	url:$URL, 
		idField:'TRowID', //主键   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBPNotice",
	        QueryName:"GetNotice",
	        NoticeCatDR:getElementValue("NoticeCatDR"),
	        Title:getElementValue("Title"),
	        Content:getElementValue("Content"),
	        Status:getElementValue("Status"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	
	var TTitle=$("#pnoticefinddatagrid").datagrid('getColumnOption','TTitle');
	TTitle.formatter=	function(value,row,index){
			return TitleOperation(value,row,index)	
		}	    
		
	if (jQuery("#Status").prop("type")!="hidden")
	{
		var MapType = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '0',
			text: '新增'
		},{
			id: '1',
			text: '提交'
		},{
			id: '2',
			text: '审核'
		},{
			id: '3',
			text: '作废'
		}],
		});
	}
		
			    
}
function BAdd_Clicked(){
	
	var url="dhceq.plat.pnotice.csp?"
	var title="公告信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","middle") //modify by lmm 2020-06-05 UI
	
}


function BFind_Clicked()
{
		$HUI.datagrid("#pnoticefinddatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBPNotice",
	        QueryName:"GetNotice",
	        NoticeCatDR:getElementValue("NoticeCatDR"),
	        Title:getElementValue("Title"),
	        Content:getElementValue("Content"),
	        Status:getElementValue("Status"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
		    },
	});
	
}

function TitleOperation(value,row,index)
{
	var btn=""
		var para="&RowID="+row.TRowID
		var url="dhceq.plat.pnotice.csp?";
		var title="公告信息"
		
		url=url+para;
		var icon="icon-w-paper"	 //modify by lmm 2018-11-14
		var type=""	 //modify by lmm 2018-11-14
		//modify by lmm 2020-06-05 UI
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;middle&quot;)" href="#">'+row.TTitle+'</A>';
	return btn;
	
}
function setSelectValue(elementID,rowData)
{
	setElement(elementID+"DR",rowData.TRowID)
}

function clearData(elementID)
{
	setElement(elementID+"DR","")
}
