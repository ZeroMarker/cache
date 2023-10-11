/** 
 * @Title: 诊断相关组查询
 * @Description:根据DRG代码获取诊断相关组详细信息
 * @Creator: 高姗姗
 * @Created: 2019-08-13
 */

 var drgCode = GetParams("drgCode");
 if (drgCode==null){drgCode=""}
 function GetParams(name){
        var search = document.location.search;
        var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");
        var matcher = pattern.exec(search);
        var items = null;
        if(null != matcher){
                try{
                        items = decodeURIComponent(decodeURIComponent(matcher[1]));
                }catch(e){
                        try{
                                items = decodeURIComponent(matcher[1]);
                        }catch(e){
                                items = matcher[1];
                        }
                }
        }
        return items;
};
function BodyLoadHandler()
{
	var columns =[[   
					{field:'Name',title:'名称',width:400},
					{field:'Value',title:'内容',width:200}
				]];
	var icdgrid = $HUI.datagrid("#groupgrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.SDSDiagnosInterface",
			QueryName:"GetDRGsDetail", //安贞ICD
			DRGCode:drgCode
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'Name', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onLoadSuccess:function(data){
			
		}
	});  
      
}


