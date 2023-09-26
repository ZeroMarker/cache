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
//                text:'��ѯ',      
//                 handler: function(){
//                     findGridData();
//                     }      
//                 }] , 
   
    columns:[[
    	{field:'TRowid',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TGroup',title:'��ȫ��',width:200,align:'center'},
        {field:'menu',title:'�˵�',width:100,align:'center',formatter: menuOperation}, 
        {field:'role',title:'��ɫ',width:100,align:'center',formatter: roleOperation}, 
        {field:'equiptype',title:'��������',width:100,align:'center',formatter: equiptypeOperation},
        {field:'hospital',title:'Ժ��',width:100,align:'center',formatter: hospitalOperation},
        {field:'grouptable',title:'��ȫ����ʴ����',width:130,align:'center',formatter: groupOperation},
		{field:'pictype',title:'ͼƬ���ļ�����',width:130,align:'center',formatter: pictypeOperation},    ///Modiedy by zc0058ͼƬ���ļ�����
        {field:'fundstypetable',title:'�ʽ���Դ����',width:130,align:'center',formatter: fundstypeOperation},	// Mozy0231	�ʽ���Դ����
        {field:'noticetable',title:'��������',width:130,align:'center',formatter: noticeOperation},	// modify by lmm 2020-04-17 ��������
        {field:'equipAttributetable',title:'�豸����',width:130,align:'center',formatter: equipAttributeOperation}	// modify by lmm 2020-04-28 �豸����
    ]], 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
//add by csj 20190123 toolbar��ѯ��Ϊ�Զ��尴ť��ѯ
$("#BFind").on("click",findGridData);
defindTitleStyle(); 

});
function menuOperation(value,row,index)
 {
	var url='dhceq.plat.csysgroupmenu.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="��ȫ����ʲ˵�"
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
	var title="��ȫ���ɫ����"
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
	var title="��ȫ���������"
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
	var title="��ȫ�����Ժ��"
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
	var title="��ȫ����ʴ�������"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;
 }
 // Mozy0231	�ʽ���Դ����
 function fundstypeOperation(value,row,index)
 {
	var url='dhceq.plat.cgroupfundstype.csp?id='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="��ȫ������ʽ���Դ����"
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
///Modiedy by zc0058ͼƬ���ļ�����
function pictypeOperation(value,row,index)
 {
	var url='dhceq.plat.cgrouppictype.csp?GroupDR='+row.TRowid
	var width=""
	var height=""
	var icon="icon-w-edit"
	var title="��ȫ�����ͼƬ���ļ�����"
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
	var title="��ȫ����ʹ�������"
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
	var title="��ȫ������豸����"
	//modify by lmm 2020-06-05 UI
	var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  /></A>' /// modfied by csj 20190122
	return btn;	
}
