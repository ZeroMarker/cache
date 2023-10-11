var columns=getCurColumnsInfo("EM.G.CT.LocDeptMapList","","",""); 
$(function(){
	initDocument();
});

function initDocument()
{
	defindTitleStyle(); 
	initUserInfo();
	initMapList();
	initButton();
	initButtonWidth();
}
function BFind_Clicked()
{
	initMapList()
}
function initMapList(){
	$HUI.datagrid("#tLocDeptMapList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTDepartment",
        	QueryName:"GetDepCTLocMapList",
			Code:getElementValue("Code"),
			Desc:getElementValue("Desc"),
			DiffFlag:getElementValue("DiffFlag")==true?"Y":"",
		},
		columns:columns,
	    fit:true,
	    singleSelect:false,
	    rownumbers: true,
	    toolbar:[{
			id:"BSyncChecked",
			iconCls:'icon-reload', 
			text:'同步勾选科室',
			handler:function(){BSyncChecked_Click();}
		}],
		onLoadError:function(data){
			console.log(JSON.stringify(data))
		},
		onLoadSuccess:function(data){
		},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});

}


function BSyncChecked_Click()
{
	var result="";
    var rows = $('#tLocDeptMapList').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","未选中数据！")
	    return;
	}
	var ErrMsg=""		//czf 2021-01-22 begin
	jQuery.each(rows, function(rowIndex, rowData){
		result = tkMakeServerCall("web.DHCEQ.Plat.CTDepartment","SyncDeptSingle",rowData.TCTLocID)
		eval("result="+result)
		if(result.SQLCODE!="0"){	//modified by csj 2020-03-31
			var ErrStr=rowData.TCTLocCodeDesc+"同步错误,错误信息:"+result.Data
			if(ErrMsg=="") ErrMsg=ErrStr
			else ErrMsg=ErrMsg+";"+ErrStr
		}
	}); 
	if(ErrMsg!=""){messageShow("","","",ErrMsg)}
	else {initMapList();}		//czf 2021-01-22 end
}
