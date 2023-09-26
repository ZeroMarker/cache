$(document).ready(function () {
    $('#group').validatebox({
        width: 160   
    }); 
$('#groupdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupEquipType",
        QueryName:"Group",
        ArgCnt:0
    },
    border:'true',
    singleSelect:true,
    toolbar:[{                        
                iconCls: 'icon-search', 
                text:'查询',      
                 handler: function(){
                     findGridData();
                     }      
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'group',title:'安全组',width:200,align:'center'},
        {field:'menu',title:'菜单',width:100,align:'center',formatter: menuOperation}, 
        {field:'role',title:'角色',width:100,align:'center',formatter: roleOperation}, 
        {field:'equiptype',title:'类组',width:100,align:'center',formatter: equiptypeOperation},
        {field:'hospital',title:'院区',width:100,align:'center',formatter: hospitalOperation},
        {field:'grouptable',title:'安全组访问代码表',width:120,align:'center',formatter: groupOperation}
    ]], 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
function menuOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	//var btn="<a  href='dhceqcsysgroupmenu.csp?"+str+"'><img border='0' src='../scripts/dhceq/easyui/themes/icons/detail.png' width='16' height='16'></a>";
	var btn='<A onclick="window.open(&quot;dhceqcsysgroupmenu.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026 
	return btn;
 }
 function roleOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	//var btn="<a  href='dhceqcgrouprole.csp?"+str+"'><img border='0' src='../scripts/dhceq/easyui/themes/icons/detail.png' width='16' height='16'></a>"; 
	var btn='<A onclick="window.open(&quot;dhceqcgrouprole.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026
	return btn;
 }
 function equiptypeOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	//var btn="<a  href='dhceqcgroupequiptype.csp?"+str+"'><img border='0' src='../scripts/dhceq/easyui/themes/icons/detail.png' width='16' height='16'></a>";
	var btn='<A onclick="window.open(&quot;dhceqcgroupequiptype.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026 
	return btn;
 }
 function hospitalOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	var btn='<A onclick="window.open(&quot;dhceqcgrouphospital.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' /// Modfied by zc 2015-07-27 ZC0026 
	return btn;
 }
  function groupOperation(value,row,index)
 {
	var str=row.rowid;
	var str="id="+str;
	//var str="&id="+str;
	//var btn="<a  href='dhceqcgrouptable.csp?"+str+"'><img border='0' src='../scripts/dhceq/easyui/themes/icons/detail.png' width='16' height='16'></a>";
	var btn='<A onclick="window.open(&quot;dhceqcgrouptable.csp?'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' 
	//var btn='<A onclick="window.open(&quot;websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCGroupCTable'+str+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>' 
	return btn;
 }
function findGridData(){
	$('#groupdatagrid').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupEquipType",
        QueryName:"Group",
        Arg1:$('#group').val(),
        ArgCnt:1
    },
    border:'true',
    singleSelect:true});
}
});