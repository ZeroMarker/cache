

/*
*/

var url = "DHCST.PIVA.SETRULE.ACTION.csp";
var UserGrpDr=session['LOGON.GROUPID'] ;

$(function(){
    initPhaLoc();
	InitFreqList();
	InitFreqComb();
    $('#btnAdd').bind("click",AddFreqList);  //�������
	$('#btnDel').bind("click",DelFreqList);

});
//��ʼ��ҩ������
function initPhaLoc()
{
	
	$('#combphaloc').combobox({  
		width: 225,//�����
		url:url+'?action=GetStockPhlocDs&GrpDr='+UserGrpDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#combphaloc').combobox('getData');
            if (data.length > 0) {
                  $('#combphaloc').combobox('select', data[0].rowId);
              }
             Query();
	    },
        onSelect: function(rec){
			Query();

		} 
		});
		
}
//��ʼƵ���б�
function InitFreqList()
{
	//����columns
	var columns=[[
		{field:"rowid",title:'FreqID',hidden:true},
		{field:'FreqDesc',title:'Ƶ��',width:200},
		{field:'pri',title:'���ȼ�',width:80, 
                    formatter:function(value,rec,index){    
                        var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">����</a> ';
						var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">����</a> ';
                        return a+b;  
                    }  
		}
	]];
	
	//����datagrid
	$('#freqdg').datagrid({
		width:'100%',
	    height:'100%',
		toolbar:'#freqdgbar',
		url:url+'?action=GetFreqRuleList',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   //CurWardID=rowData.WardID;
		   //CurAdm="";
		   //QueryDetail();
	   }


	});
    initScroll("#freqdg");
}

//��ʼ��Ƶ��combo
function InitFreqComb()
{

		$('#allfreqcomb').combogrid({
			width:150,
			panelWidth:200,    
			idField:'id',    
			textField:'desc',    
			url:url+'?action=GetAllFreqList',     
			columns:[[    
				{field:'id',title:'id',width:60},    
				{field:'desc',title:'Ƶ��',width:100}    
			]]    
		});

}


//����
function AddFreqList()
{
	        var freqdr="" ;
			var freqcombo=$("#allfreqcomb").combogrid("grid");
			var rows  = freqcombo.datagrid('getSelections');
			for(var i=0; i<rows.length; i++){
					var row = rows[i];
					freqdr=row.id ;
			}

			if (freqdr=="")
			{
					$.messager.alert('������ʾ','Ƶ��Ϊ��!',"error");
					return;
			}
            var phlocdr=$('#combphaloc').combobox('getValue');

			var input=freqdr+"^"+phlocdr;
            
			//��ȡ��Ϣ
			$.ajax({
			   type: "POST",
			   url: url,
			   data: "action=AddFreqList&Input="+input,
			   //dataType: "json",
			   success: function(val){
				  $("#allfreqcomb").combogrid('clear');
                  Query();
       
			   }
			})


}


//ɾ��
function DelFreqList()
{    
	        var rowid="";
			var row = $('#freqdg').datagrid('getSelected');
			if (row){
				rowid=row.rowid;
			}
			if (rowid=="")
			{
					$.messager.alert('������ʾ','����ѡ���¼!',"error");
					return;
			}

			var input=rowid;
           
			//��ȡ��Ϣ
			$.ajax({
			   type: "POST",
			   url: url,
			   data: "action=DelFreqList&Input="+input,
			   //dataType: "json",
			   success: function(val){
                  Query();
			   }
			})



}




//��ѯ
function Query()
{
	var phlocdr=$('#combphaloc').combobox('getValue');

	$('#freqdg').datagrid({
		url:url+'?action=GetFreqRuleList',	
		queryParams:{
			params:phlocdr}
	});
}


function upclick(index)
{
     var newrow=parseInt(index)-1 
	 var curr=$("#freqdg").datagrid('getData').rows[index];
	 var currowid=curr.rowid;
	 
	 var up =$("#freqdg").datagrid('getData').rows[newrow];
	 var uprowid=up.rowid;

	 var input=currowid+"^"+uprowid ;


     SaveUp(input);

	 mysort(index, 'up', 'freqdg');
     
	
}



function downclick(index)
{

	 var newrow=parseInt(index)+1 ;
	 var curr=$("#freqdg").datagrid('getData').rows[index];
	 var currowid=curr.rowid;
	 
	 var down =$("#freqdg").datagrid('getData').rows[newrow];
	 var downrowid=down.rowid;

	 var input=currowid+"^"+downrowid ;


     SaveUp(input);

	 mysort(index, 'down', 'freqdg');
}

function SaveUp(input)
{			
	   $.ajax({
			   type: "POST",
			   url: url,
			   data: "action=SaveUp&Input="+input,
			   //dataType: "json",
			   success: function(val){

			   }
	 })
}


function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {


			var nextrow=parseInt(index)-1 ;

			var lastrow=parseInt(index);


            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];

            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
		

            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;

            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;

            $('#' + gridname).datagrid('refreshRow', lastrow);

            $('#' + gridname).datagrid('refreshRow', nextrow);

            $('#' + gridname).datagrid('selectRow', nextrow);

        }

    } else if ("down" == type) {

        var rows = $('#' + gridname).datagrid('getRows').length;

        if (index != rows - 1) {

		    var nextrow=parseInt(index)+1 ;

			var lastrow=parseInt(index);
			
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];

            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];

            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;
              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;

            $('#' + gridname).datagrid('refreshRow', lastrow);

            $('#' + gridname).datagrid('refreshRow', nextrow);

            $('#' + gridname).datagrid('selectRow', nextrow);

        }

    }



}

