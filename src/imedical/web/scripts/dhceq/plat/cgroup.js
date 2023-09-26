$(document).ready(function () {
    $('#group').validatebox({
        width: 160   
    }); 
$HUI.datagrid('#groupdatagrid',{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupEquipType",
        QueryName:"Group",
    },
    fitColumns:true,   //add by lmm 2020-06-05 UI
    fit:true,   //add by lmm 2020-06-05 UI
    singleSelect:true,
//    toolbar:[{                        
//                iconCls: 'icon-search', 
//                text:'查询',      
//                 handler: function(){
//                     findGridData();
//                     }      
//                 }] , 
   
    columns:[[
    	{field:'TRowid',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TGroup',title:'安全组',width:200,align:'center'},
        {field:'menu',title:'菜单',width:100,align:'center',formatter: menuOperation}, 
        {field:'role',title:'角色',width:100,align:'center',formatter: roleOperation}, 
        {field:'equiptype',title:'管理类组',width:100,align:'center',formatter: equiptypeOperation},
        {field:'hospital',title:'院区',width:100,align:'center',formatter: hospitalOperation},
        {field:'grouptable',title:'安全组访问代码表',width:130,align:'center',formatter: groupOperation},
		{field:'pictype',title:'图片与文件类型',width:130,align:'center',formatter: pictypeOperation},    ///Modiedy by zc0058图片与文件类型
        {field:'fundstypetable',title:'资金来源类型',width:130,align:'center',formatter: fundstypeOperation},	// Mozy0231	资金来源类型
        {field:'noticetable',title:'公告类型',width:130,align:'center',formatter: noticeOperation},	// modify by lmm 2020-04-17 发布公告
        {field:'equipAttributetable',title:'设备属性',width:130,align:'center',formatter: equipAttributeOperation}	// modify by lmm 2020-04-28 设备属性
    ]], 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
//add by csj 20190123 toolbar查询改为自定义按钮查询
$("#BFind").on("click",findGridData);
defindTitleStyle(); 

});
function menuOperation(value,row,index)
 {
	var url='dhceq.plat.csysgroupmenu.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问菜单"
	//modify by lmm 2020-06-05 UI	
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' /// modfied by csj 20190122
	return btn;
 }
 function roleOperation(value,row,index)
 {
	var url='dhceq.plat.cgrouprole.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组角色分配"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' /// modfied by csj 20190122
	return btn;
 }
 function equiptypeOperation(value,row,index)
 {
	var url='dhceq.plat.cgroupequiptype.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问类组"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' /// modfied by csj 20190122
	return btn;
 }
 function hospitalOperation(value,row,index)
 {
	var url='dhceq.plat.cgrouphospital.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问院区"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' /// modfied by csj 20190122
	return btn;
 }
  function groupOperation(value,row,index)
 {
	var url='dhceq.plat.cgrouptable.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问代码表分配"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;
 }
 // Mozy0231	资金来源类型
 function fundstypeOperation(value,row,index)
 {
	var url='dhceq.plat.cgroupfundstype.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问资金来源类型"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>'
	return btn;
 }
function findGridData(){
	$('#groupdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.CTGroupEquipType",
        QueryName:"Group",
        Arg1:$('#group').val(),
        ArgCnt:1
    },
    singleSelect:true});
}
///Modiedy by zc0058图片与文件类型
function pictypeOperation(value,row,index)
 {
	var url='dhceq.plat.cgrouppictype.csp?GroupDR='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问图片与文件类型"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;
 }
 
 //add by lmm 2020-04-17
 function noticeOperation(value,row,index)
 {
	var url='dhceq.plat.cgroupnoticecat.csp?GroupDR='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问公告类型"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;
	 
}
//add by lmm 2020-04-28
function equipAttributeOperation(value,row,index)
{
	var url='dhceq.plat.cgroupequipattribute.csp?GroupDR='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="安全组访问设备属性"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;	
}
