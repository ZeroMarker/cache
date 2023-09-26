$(document).ready(function () {
	jQuery("#BFind").click(function(){findGridData()});
	jQuery("#BMatchCat").click(function(){MatchCat()});
	jQuery("#BExport").click(function(){BExport_Click()});
	jQuery('#tDHCEQMatchCatList').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQMatchCatlist",
			QueryName:"GetCatlist",
			ArgCnt:0
			},
		fit:true,
    	border:true,
    	striped:true,
		rownumbers:true,
		singleSelect:true,
    	columns:[[
    		{field:'TRowID',title:'RowID',align:'center',hidden:true},
    		{field:'TName',title:'�豸����',align:'center',width:'15%'},
    		{field:'TType',title:'ƥ��ģʽ',align:'center',width:'12%'},
        	{field:'TMatchName',title:'ƥ���豸��',align:'center',width:'15%'},
        	{field:'TFstFtType',title:'�������1',align:'center',width:'8%'},
        	{field:'TFstStatCat',title:'�豸����1',align:'center',width:'12%'},
    		{field:'TFstCat',title:'�豸����1',align:'center',width:'12%'},
        	{field:'TSndFtType',title:'�������2',align:'center',width:'8%'},
        	{field:'TSndStatCat',title:'�豸����2',align:'center',width:'12%'},
        	{field:'TSndCat',title:'�豸����2',align:'center',width:'12%'},
    		{field:'TTrdFtType',title:'�������3',align:'center',width:'8%'},
        	{field:'TTrdStatCat',title:'�豸����3',align:'center',width:'12%'},
        	{field:'TTrdCat',title:'�豸����3',align:'center',width:'12%'},
        	{field:'TJob',title:'Job',align:'center',hidden:true}
    	]],
		onLoadSuccess:function(data){},
		onClickRow:function(rowIndex,rowData){},
		onLoadError: function(resullt) { messageShow("","","",JSON.stringify(resullt)) },
		rowStyler:function(index,row){},
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
});

function findGridData(){
	$('#tDHCEQMatchCatList').datagrid({    
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQMatchCatlist",
        QueryName:"GetCatlist",
        Arg1:$('#Name').val(),
        Arg2:$('#MatchType').combobox("getText"),
        ArgCnt:2
    },
    border:'true',
    singleSelect:true});
}

//Author:Add by czf 20180516
//Description:ƥ�����
function MatchCat(){
	var truthBeTold = window.confirm("�Ƿ�ʼƥ����ࣿ");
	if (!truthBeTold) return;
	$.ajax({
        url :"dhceq.jquery.method.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQMatchCatlist",
            MethodName:"UpdateMatchCat",
            ArgCnt:0
        },
        beforeSend: function () {
            $.messager.progress({
            text: '����ƥ����...'
            });
        },
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",textStatus);
		},
        success:function (data, response, status) {
        $.messager.progress('close');
        if (data==0){
	        $('#tDHCEQMatchCatList').datagrid('reload'); 
	        $.messager.show({
	            title: '��ʾ',
	            msg: 'ƥ�����'
	        }); 
        }
        else {
	        messageShow("","","",data+"ƥ��ʧ��")
	        return;
         }
       }
   })
}

//Author:Add by czf 20180516
//Description:����ƥ�������ϸ��
function BExport_Click(){
    var encmeth=$('#GetRepPath').val();
	if (encmeth=="") return;	
	var	TemplatePath=cspRunServerMethod(encmeth);
	var row=$('#tDHCEQMatchCatList').datagrid('getData').rows[0];
	if (!row) 
	{
		$.messager.alert('error','�޿�������','error'); //modify by wl 2019-12-24 WL0042
		return;
	}
	var TJob=row.TJob;
	if (TJob=="")  return;
	var encmeth=$('#GetOneMatchCatList').val();
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 			//ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows 	//���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQMatchCatList.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+1;
		    	xlsheet.Rows(j).Insert();
		    	
		    	xlsheet.cells(j,1)=OneDetailList[1];	///Name
		    	xlsheet.cells(j,2)=OneDetailList[2];	///MatchType
		    	xlsheet.cells(j,3)=OneDetailList[3];	///MatchName
		    	xlsheet.cells(j,4)=OneDetailList[4];	///FstFinanceType
		    	xlsheet.cells(j,5)=OneDetailList[5];	///FstStatCat	
		    	xlsheet.cells(j,6)=OneDetailList[6];	///FstCat	    	
		    	xlsheet.cells(j,7)=OneDetailList[7];	///SndFinanceType	
		    	xlsheet.cells(j,8)=OneDetailList[8];	///SndStatCat    	
		    	xlsheet.cells(j,9)=OneDetailList[9];	///SndCat
		    	xlsheet.cells(j,10)=OneDetailList[10];	///TrdFinanceType    	
		    	xlsheet.cells(j,11)=OneDetailList[11];	///TrdStatCat
		    	xlsheet.cells(j,12)=OneDetailList[12];	///TrdCat
			}
			xlsheet.Rows(j+1).Delete();
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
		alertShow("�������")
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}