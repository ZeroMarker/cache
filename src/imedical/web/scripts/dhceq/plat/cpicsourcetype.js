//GR0033 extjs 图片业务
//显示当前可录入图片的业务
//图片业务界面布局代码
var SelectedIndex = -1;
var preIndex=-1;
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	defindTitleStyle();
	initdatagrid();			//
}
function menudatagrid_OnClickRow()
{
     var selected=$('#menudatagrid').datagrid('getSelected');
     if (selected)
     {       
        SelectedIndex=$('#menudatagrid').datagrid('getRowIndex',  selected);;
        if(preIndex!=SelectedIndex)
        {
             preIndex=SelectedIndex;
         }
         else
         {
             SelectedIndex = -1;
             preIndex=-1;
             $('#menudatagrid').datagrid('unselectAll')
         }
     }
}
function initdatagrid()
{
$('#menudatagrid').datagrid({   
    url:'dhceq.process.picsourcetypeaction.csp',
    queryParams:{
						actiontype:"GetPicSourceType"
						},
    //border:'true', modfied by wy  20190301 需求836935
    height:'100%',
    //layout:'fit',
    singleSelect:true,
    toolbar:[] , 
   
    columns:[[    
        {field:'SourceType',title:'业务类型',width:95,align:'center'}, 
        {field:'id',title:'授权',width:100,align:'center',formatter: fomartOperation}          
            ]],
    
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    },
    //pagination:true,
    pageSize:30,
    pageNumber:1
    //,pageList:[10,20,30,40,50]   
});
}
function fomartOperation(value,row,index)
 {
	 var url="dhceq.plat.cpictypeaccess.csp?&CurrentSourceType="+value
	var width=""                    // modfied by wy  2019-2-1 815075
	var height=""     
	var icon="icon-paper"
	var title="图片类型维护"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>' /// modfied by wy 2019-2-16
	return btn;
 }