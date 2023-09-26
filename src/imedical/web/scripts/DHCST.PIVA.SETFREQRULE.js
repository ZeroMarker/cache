

/*
*/

var url = "DHCST.PIVA.SETRULE.ACTION.csp";
var UserGrpDr=session['LOGON.GROUPID'] ;

$(function(){
    initPhaLoc();
	InitFreqList();
	InitFreqComb();
    $('#btnAdd').bind("click",AddFreqList);  //点击增加
	$('#btnDel').bind("click",DelFreqList);

});
//初始化药房科室
function initPhaLoc()
{
	
	$('#combphaloc').combobox({  
		width: 225,//面板宽度
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
//初始频次列表
function InitFreqList()
{
	//定义columns
	var columns=[[
		{field:"rowid",title:'FreqID',hidden:true},
		{field:'FreqDesc',title:'频次',width:200},
		{field:'pri',title:'优先级',width:80, 
                    formatter:function(value,rec,index){    
                        var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">上移</a> ';
						var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">下移</a> ';
                        return a+b;  
                    }  
		}
	]];
	
	//定义datagrid
	$('#freqdg').datagrid({
		width:'100%',
	    height:'100%',
		toolbar:'#freqdgbar',
		url:url+'?action=GetFreqRuleList',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:100,  // 每页显示的记录条数
		pageList:[100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   //CurWardID=rowData.WardID;
		   //CurAdm="";
		   //QueryDetail();
	   }


	});
    initScroll("#freqdg");
}

//初始化频次combo
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
				{field:'desc',title:'频次',width:100}    
			]]    
		});

}


//增加
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
					$.messager.alert('错误提示','频次为空!',"error");
					return;
			}
            var phlocdr=$('#combphaloc').combobox('getValue');

			var input=freqdr+"^"+phlocdr;
            
			//获取信息
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


//删除
function DelFreqList()
{    
	        var rowid="";
			var row = $('#freqdg').datagrid('getSelected');
			if (row){
				rowid=row.rowid;
			}
			if (rowid=="")
			{
					$.messager.alert('错误提示','请先选择记录!',"error");
					return;
			}

			var input=rowid;
           
			//获取信息
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




//查询
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

