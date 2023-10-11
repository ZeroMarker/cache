//GR0033 extjs 图片业务
//显示当前可录入图片的业务
//图片业务界面布局代码
//关联csp：dhceq.process.picsourcetype.csp
$(document).ready(function () {	//jquery加载
var SelectedIndex = -1;
var preIndex=-1;
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
$('#menudatagrid').datagrid({   
    url:'dhceq.process.picsourcetypeaction.csp',
    queryParams:{
						actiontype:"GetPicSourceType"
						},
    border:'true',
    height:'100%',
    //layout:'fit',
    singleSelect:true,
    toolbar:[] , 
   
    columns:[[    
        {field:'SourceType',title:'业务类型',width:95,align:'center'}, 
         {title:'授权',field:'id',width:100,align:'center',
        //formatter:function(value,row,index){return '<A onclick="window.open(&quot;dhceq.process.picturemenu.csp?&CurrentSourceType=7&CurrentSourceID=1&quot;)"><img border=0 src="../images/websys/security.gif" /></A>';}
        //<a id="TEquipz10" onclick="websys_lu('websys.csp?TEVENT=t51135iTEquip&TPAGID=119159864&TRELOADID=29516456&Group=住院护士&RowID=20',false,'width=500,height=700');return false;" href="#">
        formatter:function(value,row,index){
	        var url='dhceq.process.pictypeaccess.csp?&CurrentSourceType='+value+'&SourceType='+row.SourceType
	        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
	        return '<A onclick="window.open(&quot;'+url+'&quot;,&quot;_blank&quot;,&quot;toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes&quot;)" href="#"><img border=0 complete="complete" src="../images/websys/security.gif" /></A>';
	        }
    	}          
    ]],
    
    onClickRow : function (rowIndex, rowData) {
        menudatagrid_OnClickRow();
    },
    //pagination:true,
    pageSize:30,
    pageNumber:1
    //,pageList:[10,20,30,40,50]   
});
}); 